CREATE OR REPLACE PACKAGE BODY nm3invval IS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3invval.pkb-arc   2.19   Jul 03 2015 14:45:28   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3invval.pkb  $
--       Date into PVCS   : $Date:   Jul 03 2015 14:45:28  $
--       Date fetched Out : $Modtime:   Jul 03 2015 14:43:12  $
--       Version          : $Revision:   2.19  $
--       Based on SCCS version : 1.30
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   NM3 Inventory validation package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.19  $"';
--  g_body_sccsid is the SCCS ID for the package body
   g_package_name    CONSTANT  varchar2(30)   := 'nm3invval';
--
----------------------------------------------------------------------------------------------
--
-- Package variables for exceptions
--
   g_validation_error      EXCEPTION;
   g_validation_error_code number         := -20001;                               -- Initial Value
   g_validation_error_msg  varchar2(4000) := 'Unspecified error within NM3INVVAL'; -- Initial Value
--
   g_rec_nit               nm_inv_types%ROWTYPE;
--
   CURSOR cs_is_parent (p_inv_type nm_inv_type_groupings.itg_parent_inv_type%TYPE) IS
   SELECT itg_inv_type
         ,itg_mandatory
         ,itg_relation
    FROM  nm_inv_type_groupings
   WHERE  itg_parent_inv_type = p_inv_type;
--
   CURSOR cs_is_child  (p_inv_type nm_inv_type_groupings.itg_inv_type%TYPE) IS
   SELECT itg_parent_inv_type
         ,itg_mandatory
         ,itg_relation
    FROM  nm_inv_type_groupings
   WHERE  itg_inv_type = p_inv_type;
--
---- Package Procedure Declarations ----------------------------------------------------------
--
PROCEDURE process_insert_for_child (pi_rec_nii IN rec_nii);
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_enddate_upd_for_parent (pi_rec_nii IN rec_nii);
--
-----Global Procedures -----------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
  RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE validate_itg (pi_rec_itg IN nm_inv_type_groupings%ROWTYPE) IS
--
   l_nit_child  nm_inv_types%ROWTYPE;
   l_nit_parent nm_inv_types%ROWTYPE;
--
   l_tab_nin_child  tab_nin;
   l_tab_nin_parent tab_nin;
--
   l_inv_nw_match_found    boolean := FALSE;
--
BEGIN
--
   IF pi_rec_itg.itg_inv_type = pi_rec_itg.itg_parent_inv_type
    THEN
      g_validation_error_code := -20101;
      g_validation_error_msg  := 'itg_inv_type AND itg_parent_inv_type cannot be the same';
      RAISE g_validation_error;
   END IF;
--
-- Get the NM_INV_TYPES details for the two INV_TYPES
--
   l_nit_child  := nm3inv.get_inv_type (pi_rec_itg.itg_inv_type);
   l_nit_parent := nm3inv.get_inv_type (pi_rec_itg.itg_parent_inv_type);
--
   IF   pi_rec_itg.itg_relation     =  c_at_relation
    AND l_nit_child.nit_pnt_or_cont <> l_nit_parent.nit_pnt_or_cont
    THEN
      --
      -- If this is an AT and not P/P or C/C
      --
      g_validation_error_code := -20102;
      g_validation_error_msg  := 'AT relation only valid for same type of item (P/P or C/C) not '
                                 ||l_nit_child.nit_pnt_or_cont||'/'||l_nit_parent.nit_pnt_or_cont;
      RAISE g_validation_error;
   END IF;
--
   IF pi_rec_itg.itg_relation <> c_none_relation
    THEN
      l_tab_nin_child  := get_tab_inv_nw (pi_inv_type => pi_rec_itg.itg_inv_type);
      l_tab_nin_parent := get_tab_inv_nw (pi_inv_type => pi_rec_itg.itg_parent_inv_type);
   --
   -- Make sure there is at least one NW_TYPE on each of them which matches
   --
      IF (l_tab_nin_child.COUNT     > 0
          OR l_tab_nin_parent.COUNT > 0
         )
       THEN
         FOR l_child_count IN 1..l_tab_nin_child.COUNT
          LOOP
   --
            FOR l_parent_count IN 1..l_tab_nin_parent.COUNT
             LOOP
   --
               IF l_tab_nin_child(l_child_count).nin_nw_type = l_tab_nin_parent(l_parent_count).nin_nw_type
                THEN
                  l_inv_nw_match_found := TRUE;
                  EXIT;
               END IF;
   --
            END LOOP;
   --
            EXIT WHEN l_inv_nw_match_found;
   --
         END LOOP;
   --
         IF NOT l_inv_nw_match_found
          THEN
            g_validation_error_code := -20103;
            g_validation_error_msg  := 'No matching NM_INV_NW records found';
            RAISE g_validation_error;
         END IF;
      END IF;
   END IF;
--
   IF   pi_rec_itg.itg_relation      = c_in_relation
    AND l_nit_parent.nit_pnt_or_cont = 'P'
    THEN
      g_validation_error_code := -20104;
      g_validation_error_msg  := 'IN relation not valid for Point Parent Type';
      RAISE g_validation_error;
   END IF;
--
   IF   pi_rec_itg.itg_relation      = c_derived_relation
    AND l_nit_parent.nit_pnt_or_cont = 'P'
    AND l_nit_child.nit_pnt_or_cont  = 'C'
    THEN
      g_validation_error_code := -20105;
      g_validation_error_msg  := 'DERIVED relation not valid for P/C';
      RAISE g_validation_error;
   END IF;
--
EXCEPTION
--
   WHEN g_validation_error
    THEN
      Raise_Application_Error(g_validation_error_code, g_validation_error_msg);
--
END validate_itg;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_tab_inv_nw (pi_nw_type  IN nm_inv_nw.nin_nw_type%TYPE      DEFAULT NULL
                        ,pi_inv_type IN nm_inv_nw.nin_nit_inv_code%TYPE DEFAULT NULL
                        ) RETURN tab_nin IS
--
   CURSOR cs_nin (p_nw_type  nm_inv_nw.nin_nw_type%TYPE
                 ,p_inv_type nm_inv_nw.nin_nit_inv_code%TYPE
                 ) IS
   SELECT *
    FROM  nm_inv_nw
   WHERE (nin_nw_type      = p_nw_type  OR p_nw_type  IS NULL)
    AND  (nin_nit_inv_code = p_inv_type OR p_inv_type IS NULL);
--
   l_tab_nin tab_nin;
--
BEGIN
--
   FOR cs_rec IN cs_nin (pi_nw_type,pi_inv_type)
    LOOP
      l_tab_nin(l_tab_nin.COUNT+1) := cs_rec;
   END LOOP;
--
   RETURN l_tab_nin;
--
END get_tab_inv_nw;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pc_pop_nit_tab (pi_rec_nii IN nm_inv_items%ROWTYPE
                         ,pi_mode    IN varchar2 DEFAULT 'UNKNOWN'
                         ) IS
--
   l_dummy      varchar2(1);
--
   l_rec_nii    rec_nii;
--
BEGIN
--
   g_statement_in_progress := TRUE;
--
   l_rec_nii.ne_id        := pi_rec_nii.iit_ne_id;
   l_rec_nii.inv_type     := pi_rec_nii.iit_inv_type;
   l_rec_nii.start_date   := pi_rec_nii.iit_start_date;
   l_rec_nii.end_date     := pi_rec_nii.iit_end_date;
   l_rec_nii.primary_key  := pi_rec_nii.iit_primary_key;
   l_rec_nii.foreign_key  := pi_rec_nii.iit_foreign_key;
   l_rec_nii.admin_unit   := pi_rec_nii.iit_admin_unit;
   l_rec_nii.trigger_mode := pi_mode;
--
   OPEN  cs_is_parent (pi_rec_nii.iit_inv_type);
   FETCH cs_is_parent INTO l_rec_nii.parent_inv_type, l_rec_nii.parent_mandatory, l_rec_nii.parent_relation;
   l_rec_nii.is_parent := cs_is_parent%FOUND;
   CLOSE cs_is_parent;
--
   OPEN  cs_is_child (pi_rec_nii.iit_inv_type);
   FETCH cs_is_child INTO l_rec_nii.child_inv_type, l_rec_nii.child_mandatory, l_rec_nii.child_relation;
   l_rec_nii.is_child := cs_is_child%FOUND;
   CLOSE cs_is_child;
--
   IF   pi_rec_nii.iit_primary_key IS NULL
    AND l_rec_nii.is_parent
    THEN
      NULL;
--  	  g_validation_error_code := -20111;
--      g_validation_error_msg  := 'No IIT_PRIMARY_KEY specified and INV_TYPE is an ITG parent';
--      RAISE g_validation_error;
--   ELSIF pi_rec_nii.iit_primary_key IS NOT NULL
   END IF;
   IF pi_rec_nii.iit_primary_key IS NOT NULL
    AND  NOT l_rec_nii.is_parent
    THEN
	  NULL;
--      g_validation_error_code := -20112;
--      g_validation_error_msg  := 'IIT_PRIMARY_KEY specified and INV_TYPE is NOT an ITG parent';
--      RAISE g_validation_error;
   END IF;
--
   IF    pi_rec_nii.iit_foreign_key IS NULL
    AND  l_rec_nii.is_child
    THEN
      g_validation_error_code := -20113;
      g_validation_error_msg  := 'No IIT_FOREIGN_KEY specified and INV_TYPE is an ITG child';
      RAISE g_validation_error;
   ELSIF pi_rec_nii.iit_foreign_key IS NOT NULL
    AND  NOT l_rec_nii.is_child
    THEN
      g_validation_error_code := -20114;
      g_validation_error_msg  := 'IIT_FOREIGN_KEY specified and INV_TYPE is NOT an ITG child';
      RAISE g_validation_error;
   END IF;
--
   IF  (l_rec_nii.is_child  AND pi_mode = c_insert_mode)
    OR (l_rec_nii.is_child  AND pi_mode = c_update_mode AND l_rec_nii.end_date IS NOT NULL)
    OR (l_rec_nii.is_parent AND pi_mode = c_update_mode)
    THEN
      g_tab_rec_nii(g_tab_rec_nii.COUNT+1) := l_rec_nii;
   END IF;
--
EXCEPTION
--
   WHEN g_validation_error
    THEN
      Raise_Application_Error(g_validation_error_code, g_validation_error_msg);
--
END pc_pop_nit_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pc_process_nit_tab IS
--
   l_rec_nii    rec_nii;
--
BEGIN
--
-- Process each row in the global table (this will have been populated by the ROW level B4 Trigger)
--
   g_process_update_trigger := FALSE;
   g_statement_in_progress  := FALSE;
--
   FOR l_count IN 1..g_tab_rec_nii.COUNT
    LOOP
      -- Deal with the record in a non-array style as it makes it simpler to read
      l_rec_nii := g_tab_rec_nii(l_count);
--
      IF   l_rec_nii.is_child
       AND l_rec_nii.trigger_mode = c_insert_mode
       THEN
         process_insert_for_child (l_rec_nii);
      END IF;
      -- 713421
      --      ELSIF l_rec_nii.is_parent
      --       AND  l_rec_nii.trigger_mode = c_update_mode
      --       AND  l_rec_nii.end_date IS NOT NULL
      --       THEN
      --         process_enddate_upd_for_parent (l_rec_nii);
      --      END IF;
      IF   l_rec_nii.trigger_mode = c_update_mode
       AND l_rec_nii.end_date IS NOT NULL
       THEN
         --
         -- Do it's own NM_INV_TYPE_GROUPINGS (if there is one)
         --
         UPDATE nm_inv_item_groupings
          SET   iig_end_date = l_rec_nii.end_date
         WHERE  iig_item_id  = l_rec_nii.ne_id;
      END IF;
--
   END LOOP;
--
-- Now that we're finished with the PL/SQL table, remove all rows from it
--
   g_tab_rec_nii.DELETE;
   g_process_update_trigger := TRUE;
--
EXCEPTION
--
   WHEN g_validation_error
    THEN
      g_tab_rec_nii.DELETE;
      g_process_update_trigger := TRUE;
      Raise_Application_Error(g_validation_error_code, g_validation_error_msg);
--
   WHEN OTHERS
    THEN
      g_tab_rec_nii.DELETE;
      g_process_update_trigger := TRUE;
      RAISE;
--
END pc_process_nit_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE insert_iig (pi_rec_iig IN nm_inv_item_groupings%ROWTYPE) IS
BEGIN
--
   INSERT INTO nm_inv_item_groupings
          (iig_top_id
          ,iig_item_id
          ,iig_parent_id
          ,iig_start_date
          ,iig_end_date
          )
   VALUES (pi_rec_iig.iig_top_id
          ,pi_rec_iig.iig_item_id
          ,pi_rec_iig.iig_parent_id
          ,pi_rec_iig.iig_start_date
          ,pi_rec_iig.iig_end_date
          );
--
END insert_iig;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_iig_top_id (pi_item_id nm_inv_item_groupings.iig_item_id%TYPE
                        ) RETURN nm_inv_item_groupings.iig_top_id%TYPE IS
--
   l_top_id nm_inv_item_groupings.iig_top_id%TYPE;
--
   CURSOR cs_iig (p_item_id nm_inv_item_groupings.iig_item_id%TYPE) IS
   SELECT iig_top_id
    FROM  nm_inv_item_groupings
   WHERE  iig_item_id = p_item_id;
--
BEGIN
--
   OPEN  cs_iig (pi_item_id);
   FETCH cs_iig INTO l_top_id;
--
   IF cs_iig%NOTFOUND
    THEN
      --
      -- If not found then the parent is the top of the hierarchy
      --
      l_top_id := pi_item_id;
   END IF;
--
   CLOSE cs_iig;
--
   RETURN l_top_id;
--
END get_iig_top_id;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_insert_for_child (pi_rec_nii rec_nii) IS
--
   CURSOR cs_get_parent (p_inv_type    nm_inv_items.iit_inv_type%TYPE
                        ,p_primary_key nm_inv_items.iit_primary_key%TYPE
                        ,p_start_date  nm_inv_items.iit_start_date%TYPE
                        ,p_end_date    nm_inv_items.iit_end_date%TYPE
                        ) IS
   SELECT *
    FROM  nm_inv_items
   WHERE  iit_primary_key               = p_primary_key
    AND   iit_inv_type                 IN (SELECT itg_parent_inv_type
                                            FROM  nm_inv_type_groupings
                                           WHERE  itg_inv_type = p_inv_type
                                          )
    AND   iit_start_date               <= p_start_date
    AND  (iit_end_date                 >= p_end_date
          OR p_end_date IS NULL
         );
--
   l_rec_parent        nm_inv_items%ROWTYPE;
   l_rec_parent_dummy  nm_inv_items%ROWTYPE;
   l_rec_child         nm_inv_items%ROWTYPE;
   l_found             BOOLEAN;
   l_found_more_than_1 BOOLEAN;
--
   l_rec_iig    nm_inv_item_groupings%ROWTYPE;

   l_nit        nm_inv_types%rowtype;
   l_parent_nit nm_inv_types%rowtype;
   
   --Log 697651:LS:21/04/09
   --Added this check to stop creation of duplicate Child if It is Exclusive and relationship is AT
   FUNCTION does_relation_exist (p_inv_type IN VARCHAR2
                             ,p_relation IN VARCHAR2
                             ) RETURN BOOLEAN IS
   --
   CURSOR cs_itg (c_inv_type VARCHAR2
                 ,c_relation VARCHAR2
                 ) IS
   SELECT 1
   FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  NM_INV_TYPE_GROUPINGS
                  WHERE  itg_inv_type = c_inv_type
                   AND   itg_relation = c_relation
                 );
   --
   l_dummy  BINARY_INTEGER;
   l_retval BOOLEAN;
   --
   BEGIN
   --
      OPEN  cs_itg (p_inv_type,p_relation);
      FETCH cs_itg INTO l_dummy;
      l_retval := cs_itg%FOUND;
      CLOSE cs_itg;
   --
      RETURN l_retval;
   --
   END does_relation_exist;
   FUNCTION has_parent (pi_iit_ne_id IN NUMBER,pi_inv_type Varchar2,pi_xsp Varchar2) RETURN BOOLEAN IS
   --
      CURSOR cs_iig (c_parent_id NUMBER,c_inv_type VARCHAR2,c_xsp Varchar2) IS
      SELECT 1
      FROM  dual
      WHERE EXISTS (SELECT 1
                    FROM  NM_INV_ITEM_GROUPINGS iig,NM_INV_TYPE_GROUPINGS itg,nm_inv_items iit
                    WHERE  iig_item_id             = iit.iit_ne_id
                    AND    itg.itg_inv_type        = c_inv_type
                    AND    itg.itg_inv_type        = iit.iit_inv_type
                    AND    Nvl(iit.iit_x_sect,'*') = Nvl(c_xsp,'*')
                    AND    iig_parent_id = c_parent_id
                   );
   --
      l_retval BOOLEAN;
      l_dummy  BINARY_INTEGER;
   --
   BEGIN
   --
      OPEN  cs_iig (pi_iit_ne_id,pi_inv_type,pi_xsp );
      FETCH cs_iig INTO l_dummy;
      l_retval := cs_iig%FOUND;
      CLOSE cs_iig;
   --
      RETURN l_retval;
   --
   END has_parent;
   --Log 697651:LS:21/04/09
--
BEGIN
   --
   OPEN  cs_get_parent (p_inv_type    => pi_rec_nii.inv_type
                       ,p_primary_key => pi_rec_nii.foreign_key
                       ,p_start_date  => pi_rec_nii.start_date
                       ,p_end_date    => pi_rec_nii.end_date
                       );
   --
   FETCH cs_get_parent INTO l_rec_parent;
   l_found := cs_get_parent%FOUND;
   IF l_found
    THEN
      FETCH cs_get_parent INTO l_rec_parent_dummy;
      l_found_more_than_1 := cs_get_parent%FOUND;
   END IF;
   CLOSE cs_get_parent;
   --
   --Log 697651:LS:21/04/09
   l_parent_nit := nm3get.get_nit(nm3get.get_iit(l_rec_parent.iit_ne_id).iit_inv_type);
   l_nit        := nm3get.get_nit(pi_rec_nii.inv_type);
   
   IF   does_relation_exist(pi_rec_nii.inv_type,c_at_relation)
   AND  has_parent (l_rec_parent.iit_ne_id,pi_rec_nii.inv_type,nm3get.get_iit(pi_rec_nii.ne_id).iit_x_sect)
   AND  l_nit.nit_exclusive = 'Y' 
   AND  l_parent_nit.nit_exclusive = 'Y' 
   -- AE
   -- Task 0108660 / ECDM Log 722948
   -- Allow more than one Child asset to be located with a mandatory AT relationship
   -- if the Parent is exclusive, but the Child asset type is not.
   --
   AND  nm3get.get_nit(pi_rec_nii.inv_type).nit_exclusive = 'Y'
   --
   -- AE Changes Complete.
   --

   THEN
       hig.raise_ner (pi_appl => nm3type.c_net
                     ,pi_id   => 106
                    );
   END IF;
   --Log 697651:LS:21/04/09

   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info =>  'IIT_FOREIGN_KEY ('||pi_rec_nii.foreign_key||') does not exist as an IIT_PRIMARY_KEY for allowable parent inv type :'||pi_rec_nii.start_date||':'||pi_rec_nii.end_date
                    );
--      g_validation_error_code := -20121;
--      g_validation_error_msg  :=;
--      RAISE g_validation_error;
   END IF;
   --
   IF l_found_more_than_1
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 28
                    ,pi_supplementary_info => 'IIT_FOREIGN_KEY ('||pi_rec_nii.foreign_key||') found on >1 record as IIT_PRIMARY_KEY for allowable parent inv type'
                    );
   END IF;
   --
   IF does_relation_exist(pi_rec_nii.inv_type,c_at_relation) and l_nit.nit_use_xy = 'Y' and l_parent_nit.nit_use_xy = 'Y' 
    THEN
      update nm_inv_items
      set iit_x = l_rec_parent.iit_x,
          iit_y = l_rec_parent.iit_y
      where iit_ne_id = pi_rec_nii.ne_id;
   END IF;
   -- Create the NM_INV_ITEM_GROUPINGS record
   --
   l_rec_iig.iig_top_id     := get_iig_top_id (l_rec_parent.iit_ne_id);
   l_rec_iig.iig_item_id    := pi_rec_nii.ne_id;
   l_rec_iig.iig_parent_id  := l_rec_parent.iit_ne_id;
   l_rec_iig.iig_start_date := GREATEST(pi_rec_nii.start_date, l_rec_parent.iit_start_date);
   --
   IF    pi_rec_nii.end_date IS NULL
    THEN
      --
      -- If the NM_INV_ITEM has no end_date then use the end_date from the parent inv_item
      --
      l_rec_iig.iig_end_date := l_rec_parent.iit_end_date;
   ELSIF l_rec_parent.iit_end_date IS NULL
    THEN
      --
      -- If the parent inv_item has no end_date then use the end_date from the NM_INV_ITEM
      --
      l_rec_iig.iig_end_date := pi_rec_nii.end_date;
   ELSE
      --
      -- Check to see which is the biggest
      --
      l_rec_iig.iig_end_date := LEAST(pi_rec_nii.end_date,l_rec_parent.iit_end_date);
   END IF;
   --
   insert_iig (l_rec_iig);
   --
   IF l_rec_iig.iig_end_date < NVL(pi_rec_nii.end_date,c_max_date)
    THEN
      UPDATE nm_inv_items
       SET   iit_end_date = l_rec_iig.iig_end_date
      WHERE  iit_ne_id    = pi_rec_nii.ne_id;
   END IF;
   --
   IF pi_rec_nii.child_relation = c_at_relation
    THEN
      pc_duplicate_members (l_rec_parent.iit_ne_id
                           ,pi_rec_nii.ne_id
                           ,pi_rec_nii.inv_type
                           ,pi_rec_nii.admin_unit
                           ,pi_rec_nii.start_date
                           ,pi_rec_nii.end_date
                           );
   END IF;
   --
END process_insert_for_child;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_enddate_upd_for_parent (pi_rec_nii IN rec_nii) IS
--
   CURSOR cs_hierarchy (pi_item_id nm_inv_item_groupings.iig_item_id%TYPE) IS
   SELECT iig_item_id
    FROM  nm_inv_item_groupings
   START WITH iig_parent_id = pi_item_id
   CONNECT BY iig_parent_id = PRIOR iig_item_id;
--
   l_tab_child_ne_id  tab_number;
--
BEGIN
--
   --  This procedure is for updating the end date of those NM_INV_ITEMS +
   --   NM_INV_ITEM_GROUPINGS records when an inventory item who is a parent is end-dated
   --
--
   OPEN  cs_hierarchy (pi_rec_nii.ne_id);
   FETCH cs_hierarchy BULK COLLECT INTO l_tab_child_ne_id;
   CLOSE cs_hierarchy;
   --
   -- Update all NM_INV_TYPE_GROUPINGS records (for children)
   --
   FORALL l_count IN 1..l_tab_child_ne_id.COUNT
      UPDATE nm_inv_item_groupings
       SET   iig_end_date = pi_rec_nii.end_date
      WHERE  iig_item_id  = l_tab_child_ne_id(l_count)
       AND   NVL(iig_end_date,pi_rec_nii.end_date) >= pi_rec_nii.end_date;
   --
   --
   -- Update any NM_MEMBERS records for the record
   --
   UPDATE nm_members
    SET   nm_end_date = pi_rec_nii.end_date
   WHERE  nm_ne_id_in = pi_rec_nii.ne_id
    AND   NVL(nm_end_date,pi_rec_nii.end_date) >= pi_rec_nii.end_date;
   --
   -- Update all NM_INV_ITEMS records (if the relationship is mandatory)
   --
   IF pi_rec_nii.parent_mandatory = 'Y'
    THEN
      FORALL l_count IN 1..l_tab_child_ne_id.COUNT
         UPDATE nm_inv_items
          SET   iit_end_date = pi_rec_nii.end_date
         WHERE  iit_ne_id    = l_tab_child_ne_id(l_count)
          AND   NVL(iit_end_date,pi_rec_nii.end_date) >= pi_rec_nii.end_date;
      FORALL l_count IN 1..l_tab_child_ne_id.COUNT
         UPDATE nm_members
          SET   nm_end_date = pi_rec_nii.end_date
         WHERE  nm_ne_id_in = l_tab_child_ne_id(l_count)
          AND   NVL(nm_end_date,pi_rec_nii.end_date) >= pi_rec_nii.end_date;
   END IF;
--
END process_enddate_upd_for_parent;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pc_duplicate_members (pi_parent_ne_id     IN nm_members.nm_ne_id_in%TYPE
                               ,pi_child_ne_id      IN nm_members.nm_ne_id_in%TYPE
                               ,pi_child_inv_type   IN nm_members.nm_obj_type%TYPE
                               ,pi_child_admin_unit IN nm_members.nm_admin_unit%TYPE DEFAULT NULL
                               ,pi_child_start_date IN nm_members.nm_start_date%TYPE DEFAULT NULL
                               ,pi_child_end_date   IN nm_members.nm_start_date%TYPE DEFAULT NULL
                               ) IS
--
   CURSOR cs_mem (pi_parent_ne_id_in nm_members.nm_ne_id_in%TYPE) IS
   SELECT *
    FROM  nm_members
   WHERE  nm_ne_id_in = pi_parent_ne_id_in
   ORDER BY nm_seq_no;
--
   l_rec_nm nm_members%ROWTYPE;
--
BEGIN
--
   FOR cs_rec IN cs_mem (pi_parent_ne_id)
    LOOP
--
      nm_debug.debug(cs_mem%rowcount);
--
      l_rec_nm := cs_rec;
--
      l_rec_nm.nm_ne_id_in   := pi_child_ne_id;
      l_rec_nm.nm_start_date := NVL(pi_child_start_date,l_rec_nm.nm_start_date); -- Inherit start date from parent if not passed
      l_rec_nm.nm_end_date   := NVL(pi_child_end_date,l_rec_nm.nm_end_date);     -- Inherit end date from parent if not passed
      l_rec_nm.nm_admin_unit := NVL(pi_child_admin_unit,l_rec_nm.nm_admin_unit); -- Inherit AU from parent if not passed
      l_rec_nm.nm_obj_type   := pi_child_inv_type;
--
      BEGIN
         nm3net.ins_nm(l_rec_nm);
      EXCEPTION
         WHEN dup_val_on_index
          THEN
            UPDATE nm_members_all
             SET   nm_end_date   = l_rec_nm.nm_end_date
                  ,nm_end_mp     = l_rec_nm.nm_end_mp
                  ,nm_seq_no     = l_rec_nm.nm_seq_no
            WHERE  nm_ne_id_in   = l_rec_nm.nm_ne_id_in
             AND   nm_ne_id_of   = l_rec_nm.nm_ne_id_of
             AND   nm_begin_mp   = l_rec_nm.nm_begin_mp
             AND   nm_start_date = l_rec_nm.nm_start_date;
      END;
--
   END LOOP;
--
END pc_duplicate_members;
--
----------------------------------------------------------------------------------------------
--
--
-- checks the inv items dates are in the correct bounds
-- and the dates are within the foreign key date bounds
--
PROCEDURE check_inv_dates ( p_rec_nii    rec_date_chk) IS
--
   l_end_date_out_of_range    EXCEPTION;
   l_start_date_out_of_range  EXCEPTION;
   l_has_children             EXCEPTION;
--
   l_parent_start_date        DATE;
   l_parent_end_date          DATE;
   
   l_hier_start_date          DATE;
   l_hier_end_date            DATE;
--
   --
   CURSOR c1 ( c_iit_located_by nm_inv_items.iit_located_by%TYPE ) IS
   SELECT iit_start_date
         ,iit_end_date
   FROM nm_inv_items_all
   WHERE iit_ne_id = c_iit_located_by;
   --
   CURSOR c2 ( c_nau_admin_unit nm_admin_units.nau_admin_unit%TYPE )IS
   SELECT nau_start_date
         ,nau_end_date
   FROM nm_admin_units_all
   WHERE nau_admin_unit = c_nau_admin_unit;
   --
   CURSOR c3 (c_nit_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   SELECT nit_start_date
         ,nit_end_date
   FROM nm_inv_types_all
   WHERE nit_inv_type = c_nit_inv_type;
   --
-- Start Log 37786
--
--   CURSOR c4 (c_child_ne_id nm_inv_items.iit_ne_id%TYPE) IS
--   SELECT iit_start_date
--         ,iit_end_date
--    FROM  nm_inv_items_all
--         ,nm_inv_item_groupings_all
--    WHERE iig_item_id   = c_child_ne_id
--     AND  iig_parent_id = iit_ne_id;
--
--
   CURSOR c4 (c_child_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   SELECT iit_start_date, iit_end_date, iig_start_date, iig_end_date
   FROM   nm_inv_items_all, nm_inv_item_groupings_all 
   WHERE iig_item_id = c_child_ne_id
   AND   iit_ne_id   = iig_parent_id;
--
-- End Log 37786
   --
   CURSOR cs_child_inv (c_iit_ne_id  nm_inv_items.iit_ne_id%TYPE
                       ,c_start_date date
                       ,c_end_date   date
                       ) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1 -- This record is used as a LOCATED_BY
                   FROM  nm_inv_items
                  WHERE  iit_located_by = c_iit_ne_id
                   AND  (iit_start_date < c_start_date
                          OR (   (iit_end_date IS     NULL AND c_end_date IS NOT NULL)
                              OR (iit_end_date IS NOT NULL AND c_end_date IS NOT NULL AND iit_end_date > c_end_date)
                             )
                        )
                 );
--

    CURSOR cs_child_iig (c_iit_ne_id  nm_inv_items.iit_ne_id%TYPE
                        ,c_start_date date
                        ,c_end_date   date
                        ) IS
    SELECT 1 -- This record is a PARENT in inv_item_groupings
     FROM  nm_inv_item_groupings_all
          ,nm_inv_items_all
    WHERE  iig_parent_id = c_iit_ne_id
     AND   iig_item_id   = iit_ne_id
     AND  (iit_start_date < c_start_date
            OR (   (iit_end_date IS     NULL AND c_end_date IS NOT NULL)
                OR (iit_end_date IS NOT NULL AND c_end_date IS NOT NULL AND iit_end_date > c_end_date)
               )
          )
     AND  (iig_start_date < c_start_date
            OR (   (iig_end_date IS     NULL AND c_end_date IS NOT NULL)
                OR (iig_end_date IS NOT NULL AND c_end_date IS NOT NULL AND iig_end_date > c_end_date)
               )
          );
--
   CURSOR check_for_dup_pk (c_iit_ne_id    nm_inv_items.iit_ne_id%TYPE
                           ,c_iit_pk       nm_inv_items.iit_primary_key%TYPE
                           ,c_iit_inv_type nm_inv_items.iit_inv_type%TYPE
                           ) IS
   SELECT /*+ INDEX (nm_inv_items iit_uk) */ 1
    FROM  nm_inv_items
   WHERE  iit_primary_key = c_iit_pk
    AND   iit_inv_type    = c_iit_inv_type
    AND   iit_ne_id      != c_iit_ne_id;
--
   l_dummy pls_integer;
--
   l_ner_id             nm_errors.ner_id%TYPE;
   l_ner_appl           nm_errors.ner_appl%TYPE := nm3type.c_net;
   l_supplementary_info VARCHAR2(500) := 'NM_INV_ITEMS_ALL('||p_rec_nii.ne_id||')';
--
BEGIN
--
--   nm_debug.proc_start(g_package_name, 'check_inv_dates');
   --
   -- Check to make sure the IIT_PRIMARY_KEY is not a duplicate
   --
   OPEN  check_for_dup_pk (p_rec_nii.ne_id
                          ,p_rec_nii.primary_key
                          ,p_rec_nii.inv_type
                          );
   FETCH check_for_dup_pk INTO l_dummy;
   IF check_for_dup_pk%FOUND
    THEN
      CLOSE check_for_dup_pk;
      RAISE_APPLICATION_ERROR(-20567,'Dup IIT_PK : '||p_rec_nii.primary_key);
--      RAISE dup_val_on_index;
   END IF;
   CLOSE check_for_dup_pk;
   --
 --nm_debug.debug('IIT_LOCATED_BY_FK');
   -- IIT_LOCATED_BY_FK
   IF p_rec_nii.located_by IS NOT NULL
    THEN
      OPEN  c1( p_rec_nii.located_by );
      FETCH c1 INTO l_parent_start_date, l_parent_end_date;
      CLOSE c1;
      IF l_parent_end_date IS NULL
       THEN
         NULL; -- Dont worry about it
      ELSIF p_rec_nii.end_date IS NULL
       OR   p_rec_nii.end_date >  l_parent_end_date
       THEN
         l_ner_id             := 12;
         l_supplementary_info := l_supplementary_info||'.IIT_LOCATED_BY - NM_INV_ITEMS_ALL';
         RAISE l_end_date_out_of_range;
      END IF;
      IF p_rec_nii.start_date < l_parent_start_date
       THEN
         l_ner_id             := 11;
         l_supplementary_info := l_supplementary_info||'.IIT_LOCATED_BY - NM_INV_ITEMS_ALL';
         RAISE l_start_date_out_of_range;
      END IF;
   END IF;
   --
 --nm_debug.debug('IIT_NAU_FK');
   -- IIT_NAU_FK
   OPEN  c2 ( p_rec_nii.admin_unit );
   FETCH c2 INTO l_parent_start_date, l_parent_end_date;
   CLOSE c2;
   IF l_parent_end_date IS NULL
    THEN
      NULL; -- Dont worry about it
   ELSIF p_rec_nii.end_date IS NULL
    OR   p_rec_nii.end_date >  l_parent_end_date
    THEN
      l_ner_id             := 12;
      l_supplementary_info := l_supplementary_info||'.IIT_ADMIN_UNIT - NM_ADMIN_UNITS_ALL';
      RAISE l_end_date_out_of_range;
   END IF;
   IF p_rec_nii.start_date < l_parent_start_date
    THEN
      l_ner_id             := 11;
      l_supplementary_info := l_supplementary_info||'.IIT_ADMIN_UNIT - NM_ADMIN_UNITS_ALL';
      RAISE l_start_date_out_of_range;
   END IF;
   --
 --nm_debug.debug('IIT_NIT_FK');
   -- IIT_NIT_FK
   OPEN  c3 ( p_rec_nii.inv_type );
   FETCH c3 INTO l_parent_start_date, l_parent_end_date;
   CLOSE c3;
   IF l_parent_end_date IS NULL
    THEN
      NULL; -- Dont worry about it
   ELSIF p_rec_nii.end_date IS NULL
    OR   p_rec_nii.end_date >  l_parent_end_date
    THEN
      l_ner_id             := 12;
      l_supplementary_info := l_supplementary_info||'.IIT_INV_TYPE - NM_INV_TYPES_ALL';
      RAISE l_end_date_out_of_range;
   END IF;
   IF p_rec_nii.start_date < l_parent_start_date
    THEN
      l_ner_id             := 11;
      l_supplementary_info := l_supplementary_info||'.IIT_INV_TYPE - NM_INV_TYPES_ALL';
      RAISE l_start_date_out_of_range;
   END IF;
   --
 --nm_debug.debug('Check for hierarchical stuff');
   -- Check for hierarchical stuff -  log 726036 - need to cater for multiple rows
   --
   OPEN  c4 ( p_rec_nii.ne_id);
   FETCH c4 INTO l_parent_start_date, l_parent_end_date, l_hier_start_date, l_hier_end_date;
   while c4%found loop
      IF l_parent_end_date IS NULL AND l_hier_end_date is NULL
       THEN
         NULL; -- Dont worry about it
      ELSIF p_rec_nii.end_date IS NULL
       OR   p_rec_nii.end_date >  l_parent_end_date
       THEN
         l_ner_id             := 12;
         l_supplementary_info := l_supplementary_info||' - NM_INV_ITEMS_ALL (parent)';
         RAISE l_end_date_out_of_range;
      ELSIF p_rec_nii.end_date IS NULL
       OR   p_rec_nii.end_date <  l_hier_end_date
       THEN
         l_ner_id             := 12;
         l_supplementary_info := l_supplementary_info||' - NM_INV_ITEM_GROUPINGS_ALL (parent)';
         RAISE l_end_date_out_of_range;
      END IF;
      IF p_rec_nii.start_date < l_parent_start_date
       THEN
         l_ner_id             := 11;
         l_supplementary_info := l_supplementary_info||' - NM_INV_ITEMS_ALL (parent)';
         RAISE l_start_date_out_of_range;
      END IF;
      IF p_rec_nii.start_date > l_hier_start_date
       THEN
         l_ner_id             := 11;
         l_supplementary_info := l_supplementary_info||' - NM_INV_ITEM_GROUPINGS_ALL (parent)';
         RAISE l_start_date_out_of_range;
      END IF;

   FETCH c4 INTO l_parent_start_date, l_parent_end_date, l_hier_start_date, l_hier_end_date;

   END LOOP;
   CLOSE c4;


 --nm_debug.debug('Check for children');
   -- Check for children
   --
 --nm_debug.debug('cs_child_iig');

   OPEN  cs_child_iig (p_rec_nii.ne_id, p_rec_nii.start_date, p_rec_nii.end_date);
   FETCH cs_child_iig INTO l_dummy;
   IF cs_child_iig%FOUND
   THEN
       CLOSE cs_child_iig;
       --Log 696122:Linesh:04-Feb-2009:Start
       --Commneted the exception rasied now we have to end date all the child records
       --when the parent gets end dated.
       --l_ner_id             := 14;
       --l_supplementary_info := l_supplementary_info||' - NM_INV_ITEMS_ALL (child)';
       --RAISE l_has_children;
       IF p_rec_nii.end_date IS NOT NULL
       THEN
           -- LOG 713421
           FOR l_rec IN (SELECT  iig_item_id
                                ,itg_mandatory
                                ,itg_relation
                         FROM    nm_inv_item_groupings iig
                                ,nm_inv_items iit
                                ,nm_inv_type_groupings itg
                         WHERE   iig.iig_item_id       = iit.iit_ne_id
                         AND     iit.iit_inv_type      = itg.itg_inv_type
                         CONNECT By PRIOR iig_item_id  = iig_parent_id
                         START   WITH iig_parent_id    = p_rec_nii.ne_id
                        )
           LOOP
               IF  NVL(l_rec.itg_mandatory,'N')  = 'Y'
               THEN
                   UPDATE nm_members
                   SET    nm_end_date = p_rec_nii.end_date
                   WHERE  nm_ne_id_in = l_rec.iig_item_id
                   AND    nm_type     = 'I' ;

                   UPDATE nm_inv_item_groupings
                   SET    iig_end_date = p_rec_nii.end_date
                   WHERE  iig_item_id  = l_rec.iig_item_id ;

                   UPDATE nm_inv_items
                   SET    iit_end_date = p_rec_nii.end_date
                   WHERE  iit_ne_id    = l_rec.iig_item_id ;
               ELSIF NVL(l_rec.itg_mandatory,'N')  = 'N'
               THEN
                   UPDATE nm_inv_item_groupings
                   SET    iig_end_date = p_rec_nii.end_date
                   WHERE  iig_item_id  = l_rec.iig_item_id ;
               END IF ;
           END LOOP;
           -- LOG 713421
       END IF ;
   ELSE
       CLOSE cs_child_iig;
   END IF;
   --Log 696122:Linesh:04-Feb-2009:End
--
 --nm_debug.debug('cs_child_inv');
   OPEN  cs_child_inv (p_rec_nii.ne_id, p_rec_nii.start_date, p_rec_nii.end_date);
   FETCH cs_child_inv INTO l_dummy;
   IF cs_child_inv%FOUND
    THEN
      CLOSE cs_child_inv;
      l_ner_id             := 14;
      l_supplementary_info := l_supplementary_info||' - NM_INV_ITEMS_ALL.IIT_LOCATED_BY';
      RAISE l_has_children;
   END IF;
   CLOSE cs_child_inv;
--
  -- End date any inventory locations which exist
   IF p_rec_nii.end_date IS NOT NULL
    THEN
      UPDATE nm_members
       SET   nm_end_date                          = p_rec_nii.end_date
      WHERE  nm_ne_id_in                          = p_rec_nii.ne_id
       AND   NVL(nm_end_date,p_rec_nii.end_date) >= p_rec_nii.end_date;
      -- task 0108705 CWS Updates value from global variable set in the pre update trigger.
   ELSE
   --
    UPDATE nm_members_all
          SET  nm_end_date             = p_rec_nii.end_date
     WHERE  nm_ne_id_in              = p_rec_nii.ne_id
          AND TRUNC(nm_end_date) = TRUNC(g_nii_end_date_old)
          AND EXISTS (SELECT 'X' FROM nm_elements WHERE nm_ne_id_of = ne_id);
   END IF;
      -- task 0108705 END
--

-- task 0111977 - clear out any shapes that may not be picked up by the member triggers. This is pure inventory so we know the date columns
-- we can rely on sdo_edit - loop in case there are more than one
--
   DECLARE
     cursor cs_asset_shapes ( c_iit_ne_id in nm_inv_items.iit_ne_id%type ) is
       select nth_theme_id, nth_feature_table, nth_feature_shape_column
       from nm_themes_all, nm_inv_themes, nm_inv_items_all
       where nth_theme_id = nith_nth_theme_id
       and iit_ne_id = c_iit_ne_id
       and nith_nit_id = iit_inv_type
	   and nth_use_history = 'Y'
       and nth_base_table_theme is null;
  begin
    for irec in cs_asset_shapes( p_rec_nii.ne_id ) loop
       NM3SDO_EDIT.END_DATE_SHAPE(PI_NTH_ID => irec.nth_theme_id, PI_PK => p_rec_nii.ne_id, pi_date => p_rec_nii.end_date );
    end loop;	
  end;	   

--   nm_debug.proc_end(g_package_name, 'check_inv_dates');
   --
EXCEPTION
--
-- g_process_update_trigger := TRUE; was false at start of procedure
-- set it back to TRUE so that the trigger will be called again if updating.
--
   WHEN l_has_children
    THEN
      g_process_update_trigger := TRUE;
      hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info
                    );
   WHEN l_start_date_out_of_range
    THEN
      g_process_update_trigger := TRUE;
      hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info||' '||TO_CHAR(p_rec_nii.start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))||' > '||TO_CHAR(l_parent_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                    );
   WHEN l_end_date_out_of_range
    THEN
      g_process_update_trigger := TRUE;
      hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info||' '||NVL(TO_CHAR(p_rec_nii.end_date,Sys_Context('NM3CORE','USER_DATE_MASK')),'Null')||' > '||TO_CHAR(l_parent_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                    );
--
END check_inv_dates;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pop_date_chk_tab ( pi_rec_nii IN nm_inv_items%ROWTYPE
                            ,pi_mode    IN varchar2 DEFAULT 'UNKNOWN'
                           ) IS
--
   l_rec_nii    rec_date_chk;
--
BEGIN
--
   g_statement_in_progress  := TRUE;
--   nm_debug.proc_start(g_package_name, 'pop_date_chk_tab');
--
   l_rec_nii.ne_id        := pi_rec_nii.iit_ne_id;
   l_rec_nii.inv_type     := pi_rec_nii.iit_inv_type;
   l_rec_nii.start_date   := pi_rec_nii.iit_start_date;
   l_rec_nii.end_date     := pi_rec_nii.iit_end_date;
   l_rec_nii.admin_unit   := pi_rec_nii.iit_admin_unit;
   l_rec_nii.located_by   := pi_rec_nii.iit_located_by;
   l_rec_nii.primary_key  := pi_rec_nii.iit_primary_key;
   l_rec_nii.trigger_mode := pi_mode;
--
--
   IF  (pi_mode = c_insert_mode)
    OR (pi_mode = c_update_mode)
    THEN
      g_tab_rec_date_chk(g_tab_rec_date_chk.COUNT+1) := l_rec_nii;
   END IF;
--
--   nm_debug.proc_end(g_package_name, 'pop_date_chk_tab');
--
EXCEPTION
--
   WHEN g_validation_error
    THEN
      Raise_Application_Error(g_validation_error_code, g_validation_error_msg);
--
END pop_date_chk_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_date_chk_tab IS
--
   l_rec_nii    rec_date_chk;
--
BEGIN
--
--   nm_debug.proc_start(g_package_name, 'process_date_chk_tab');
--
-- Process each row in the global table (this will have been populated by the ROW level B4 Trigger)
--
   g_process_update_trigger := FALSE;
   g_statement_in_progress  := FALSE;
--
   FOR l_count IN 1..g_tab_rec_date_chk.COUNT
    LOOP
      -- Deal with the record in a non-array style as it makes it simpler to read
      l_rec_nii := g_tab_rec_date_chk(l_count);
--
      check_inv_dates (l_rec_nii);
--
   END LOOP;
--
-- Now that we're finished WITH the PL/SQL TABLE, remove ALL ROWS FROM it
--
   g_tab_rec_date_chk.DELETE;
   g_process_update_trigger := TRUE;
--
--   nm_debug.proc_end(g_package_name, 'process_date_chk_tab');
--
EXCEPTION
--
   WHEN g_validation_error
    THEN
      g_tab_rec_date_chk.DELETE;
      g_process_update_trigger := TRUE;
      Raise_Application_Error(g_validation_error_code, g_validation_error_msg);
--
   WHEN OTHERS
    THEN
      g_tab_rec_date_chk.DELETE;
      g_process_update_trigger := TRUE;
      RAISE;
--
END process_date_chk_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_xsp_valid_on_inv_loc (pi_iit_ne_id    IN nm_inv_items.iit_ne_id%TYPE
                                     ,pi_iit_inv_type IN nm_inv_items.iit_inv_type%TYPE
                                     ,pi_iit_x_sect   IN nm_inv_items.iit_x_sect%TYPE
                                     ) IS
--
   CURSOR cs_exists (c_ne_id_in nm_members.nm_ne_id_in%TYPE
                    ,c_inv_type nm_inv_items.iit_inv_type%TYPE
                    ,c_x_sect   nm_inv_items.iit_x_sect%TYPE
                    ) IS
   SELECT 1
    FROM  nm_members a
   WHERE  nm_ne_id_in = c_ne_id_in
    AND   NOT EXISTS (
                       SELECT 1
                       FROM  nm_elements
                                ,xsp_restraints
                      WHERE  a.nm_ne_id_of      = ne_id
                       AND   xsr_nw_type      = ne_nt_type
                       AND   xsr_ity_inv_code = c_inv_type
                       AND   xsr_scl_class  = ne_sub_class
                       AND   xsr_x_sect_value = c_x_sect
                       UNION ALL
                       SELECT 1
                       FROM  nm_elements
                                ,xsp_restraints, nm_members b
                      WHERE  b.nm_ne_id_in      = ne_id
                      and a.nm_ne_id_of = b.nm_ne_id_of
                       AND   xsr_nw_type      = ne_nt_type
                       AND   xsr_ity_inv_code = c_inv_type
                       AND   xsr_scl_class  = ne_sub_class
                       AND   xsr_x_sect_value = c_x_sect
                     );
--
   l_dummy   PLS_INTEGER;
--
   l_rec_nit nm_inv_types%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_xsp_valid_on_inv_loc');
--
   DECLARE
      no_locations    EXCEPTION;
      xsp_not_allowed EXCEPTION;
   BEGIN
      --
      -- Get the NM_INV_TYPES record
      --
      l_rec_nit := nm3inv.get_inv_type (pi_iit_inv_type);
      --
      -- If it is not XSP allowed then do not worry about it - the dynamic nm_inv_items_mand_check trigger
      --  will catch this
      --
      IF l_rec_nit.nit_x_sect_allow_flag = 'N'
       THEN
         RAISE xsp_not_allowed;
      END IF;
      --
      -- If this item is not located then do not proceed
      --
      IF NOT nm3ausec.do_locations_exist (p_ne_id => pi_iit_ne_id)
       THEN
         RAISE no_locations;
      END IF;
      --
      -- If it is located then make sure the XSP is valid on the location (NW_TYPE and SubClass)
      --
      OPEN  cs_exists (c_ne_id_in => pi_iit_ne_id
                      ,c_inv_type => l_rec_nit.nit_inv_type
                      ,c_x_sect   => pi_iit_x_sect
                      );
      FETCH cs_exists INTO l_dummy;
      IF cs_exists%FOUND
       THEN
         CLOSE cs_exists;
         hig.raise_ner(nm3type.c_net,46); -- XSP is invalid for this inventory type on this network type.
      END IF;
      CLOSE cs_exists;
      --
   EXCEPTION
      WHEN no_locations
       OR  xsp_not_allowed
       THEN
         Null;
   END;
--
   nm_debug.proc_end(g_package_name,'check_xsp_valid_on_inv_loc');
--
END check_xsp_valid_on_inv_loc;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pop_excl_check_tab (pi_iit_ne_id    IN nm_inv_items.iit_ne_id%TYPE
                             ,pi_iit_inv_type IN nm_inv_items.iit_inv_type%TYPE
                             ) IS
--
   l_rec_excl_check rec_excl_check;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pop_excl_check_tab');
--
   l_rec_excl_check.iit_ne_id    := pi_iit_ne_id;
   l_rec_excl_check.iit_inv_type := pi_iit_inv_type;
   IF pi_iit_inv_type != NVL(g_rec_nit.nit_inv_type,nm3type.c_nvl)
    THEN
      g_rec_nit                  := nm3inv.get_inv_type (pi_iit_inv_type);
   END IF;
--
   IF   g_rec_nit.nit_exclusive = 'Y'
    AND nm3ausec.get_status     = nm3type.c_on
    THEN
      --
      -- If this is exclusive
      --  AND
      -- Admin Unit (and everything else) security is on
      --  We only do this when AU sec is on so that this does not fire and cause problems in reverse
      --
      l_rec_excl_check.nit_pnt_or_cont       := g_rec_nit.nit_pnt_or_cont;
      l_rec_excl_check.nit_x_sect_allow_flag := g_rec_nit.nit_x_sect_allow_flag;
      g_tab_rec_excl_check(g_tab_rec_excl_check.COUNT+1) := l_rec_excl_check;
   END IF;
--
   nm_debug.proc_end(g_package_name,'pop_excl_check_tab');
--
END pop_excl_check_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_excl_check_tab IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_excl_check_tab');
--
   FOR i IN 1..g_tab_rec_excl_check.COUNT
    LOOP
      process_rec_excl_check (g_tab_rec_excl_check(i));
   END LOOP;
--
   clear_excl_check_tab;
--
   nm_debug.proc_end(g_package_name,'process_excl_check_tab');
--
EXCEPTION
--
   WHEN others
    THEN
      clear_excl_check_tab;
      RAISE;
--
END process_excl_check_tab;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_overlapping_inventory (p_iit_ne_id       nm_inv_items.iit_ne_id%TYPE
                                   ,p_nit_pnt_or_cont nm_inv_types.nit_pnt_or_cont%TYPE
                                   ) RETURN nm3type.tab_number IS
--
   CURSOR cs_locs_cont (c_iit_ne_id nm_members.nm_ne_id_in%TYPE) IS
   SELECT nm2.nm_ne_id_in
    FROM  nm_members nm1
         ,nm_members nm2
   WHERE  nm1.nm_ne_id_in  = c_iit_ne_id
    AND   nm1.nm_ne_id_of  = nm2.nm_ne_id_of
    AND   nm1.nm_begin_mp  < nm2.nm_end_mp
    AND   nm1.nm_end_mp    > nm2.nm_begin_mp
    AND   nm2.nm_type      = 'I'
    AND   nm2.nm_obj_type  = nm1.nm_obj_type
    AND   nm1.nm_ne_id_in != nm2.nm_ne_id_in;
--
   CURSOR cs_locs_point (c_iit_ne_id nm_members.nm_ne_id_in%TYPE) IS
   SELECT nm2.nm_ne_id_in
    FROM  nm_members nm1
         ,nm_members nm2
   WHERE  nm1.nm_ne_id_in  = c_iit_ne_id
    AND   nm1.nm_ne_id_of  = nm2.nm_ne_id_of
    AND   nm1.nm_begin_mp  = nm2.nm_begin_mp
    AND   nm1.nm_end_mp    = nm2.nm_end_mp
    AND   nm2.nm_type      = 'I'
    AND   nm2.nm_obj_type  = nm1.nm_obj_type
    AND   nm1.nm_ne_id_in != nm2.nm_ne_id_in;
--
   l_tab_possible_affected_inv nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_overlapping_inventory');
--
   IF p_nit_pnt_or_cont = 'C'
    THEN
      OPEN  cs_locs_cont (p_iit_ne_id);
      FETCH cs_locs_cont BULK COLLECT INTO l_tab_possible_affected_inv;
      CLOSE cs_locs_cont;
   ELSE
      OPEN  cs_locs_point (p_iit_ne_id);
      FETCH cs_locs_point BULK COLLECT INTO l_tab_possible_affected_inv;
      CLOSE cs_locs_point;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_overlapping_inventory');
--
   RETURN l_tab_possible_affected_inv;
--
END get_overlapping_inventory;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_rec_excl_check (p_rec_excl_check rec_excl_check) IS
--
   l_tab_possible_affected_inv nm3type.tab_number;
   l_rec_iit                   nm_inv_items%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_rec_excl_check');
--
   l_tab_possible_affected_inv := get_overlapping_inventory
                                         (p_iit_ne_id       => p_rec_excl_check.iit_ne_id
                                         ,p_nit_pnt_or_cont => p_rec_excl_check.nit_pnt_or_cont
                                         );
--
   IF l_tab_possible_affected_inv.COUNT > 0
    THEN
      l_rec_iit := nm3inv.get_inv_item (p_rec_excl_check.iit_ne_id);
      FOR i IN 1..l_tab_possible_affected_inv.COUNT
       LOOP
         IF nm3homo.is_affected_by_exclusivity
                                 (p_iit_ne_id => l_tab_possible_affected_inv(i)
                                 ,p_rec_iit   => l_rec_iit
                                 ,p_exclusive => TRUE -- This is only called for exclusive types
                                 ,p_x_sect    => (p_rec_excl_check.nit_x_sect_allow_flag = 'Y')
                                 )
          THEN
            hig.raise_ner (nm3type.c_net, 228);
         END IF;
      END LOOP;
   END IF;
--
   nm_debug.proc_end(g_package_name,'process_rec_excl_check');
--
END process_rec_excl_check;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE clear_excl_check_tab IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'clear_excl_check_tab');
--
   g_tab_rec_excl_check.DELETE;
--
   nm_debug.proc_end(g_package_name,'clear_excl_check_tab');
--
END clear_excl_check_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE datetrack_update_au_for_invmem (p_iit_ne_id      nm_inv_items.iit_ne_id%TYPE
                                         ,p_iit_admin_unit nm_inv_items.iit_admin_unit%TYPE
                                         ,p_effective_date nm_inv_items.iit_start_date%TYPE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                         ) IS
--
   CURSOR cs_mem (c_ne_id_in nm_members.nm_ne_id_in%TYPE) IS
   SELECT *
    FROM  nm_members
   WHERE  nm_ne_id_in = c_ne_id_in
   FOR UPDATE OF nm_end_date NOWAIT;
--
   CURSOR cs_future (c_ne_id_in nm_members.nm_ne_id_in%TYPE
                    ,c_eff_date nm_members.nm_start_date%TYPE
                    ) IS
   SELECT 1
    FROM  nm_members_all
   WHERE  nm_ne_id_in   = c_ne_id_in
    AND   nm_start_date > c_eff_date;
--
   l_dummy                 PLS_INTEGER;
--
   l_tab_rec_nm            nm3type.tab_rec_nm;
--
   l_tab_in                nm3type.tab_number;
   l_tab_of                nm3type.tab_number;
   l_tab_begin_mp          nm3type.tab_number;
   l_tab_st_date           nm3type.tab_date;
--
   l_tab_dup_val           nm3type.tab_boolean;
--
   l_count                 PLS_INTEGER;
--
   c_eff_date     CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'datetrack_update_au_for_invmem');
--
   nm3user.set_effective_date (p_effective_date);
--
   OPEN  cs_future (p_iit_ne_id,p_effective_date);
   FETCH cs_future INTO l_dummy;
   IF cs_future%FOUND
    THEN
      CLOSE cs_future;
      hig.raise_ner(nm3type.c_net,250);
   END IF;
   CLOSE cs_future;
--
   FOR cs_rec IN cs_mem (p_iit_ne_id)
    LOOP
      l_count := cs_mem%ROWCOUNT;
      --
      l_tab_in(l_count)                   := cs_rec.nm_ne_id_in;
      l_tab_of(l_count)                   := cs_rec.nm_ne_id_of;
      l_tab_begin_mp(l_count)             := cs_rec.nm_begin_mp;
      l_tab_st_date(l_count)              := cs_rec.nm_start_date;
      --
      l_tab_rec_nm(l_count)               := cs_rec;
      l_tab_rec_nm(l_count).nm_start_date := p_effective_date;
      l_tab_rec_nm(l_count).nm_admin_unit := p_iit_admin_unit;
      --
      --  If we know this one is going to be a DUP VAL ON INDEX
      --   beacause the NM_START_DATE is the same as the effective_date
      --
      l_tab_dup_val(l_count)              := (p_effective_date = cs_rec.nm_start_date);
      --
   END LOOP;
--
   FORALL i IN 1..l_tab_in.COUNT
      UPDATE nm_members_all
       SET   nm_end_date   = p_effective_date
      WHERE  nm_ne_id_in   = l_tab_in(i)
       AND   nm_ne_id_of   = l_tab_of(i)
       AND   nm_begin_mp   = l_tab_begin_mp(i)
       AND   nm_start_date = l_tab_st_date(i);
--
   FOR i IN 1..l_tab_rec_nm.COUNT
    LOOP
      IF l_tab_dup_val(i)
       THEN
         DELETE nm_members_all
         WHERE  nm_ne_id_in   = l_tab_rec_nm(i).nm_ne_id_in
          AND   nm_ne_id_of   = l_tab_rec_nm(i).nm_ne_id_of
          AND   nm_begin_mp   = l_tab_rec_nm(i).nm_begin_mp
          AND   nm_start_date = l_tab_rec_nm(i).nm_start_date;
      END IF;
      nm3net.ins_nm (l_tab_rec_nm(i));
   END LOOP;
--
   nm3user.set_effective_date (c_eff_date);
--
   nm_debug.proc_end(g_package_name,'datetrack_update_au_for_invmem');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_eff_date);
      RAISE;
--
END datetrack_update_au_for_invmem;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE clear_update_au_tab IS
BEGIN
   g_tab_rec_update_au.DELETE;
END clear_update_au_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_update_au_tab IS
BEGIN
   FOR i IN 1..g_tab_rec_update_au.COUNT
    LOOP
      datetrack_update_au_for_invmem (p_iit_ne_id      => g_tab_rec_update_au(i).iit_ne_id
                                     ,p_iit_admin_unit => g_tab_rec_update_au(i).iit_admin_unit_new
                                     );
   END LOOP;
   nm3invval.clear_update_au_tab;
END process_update_au_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pop_update_au_tab (pi_iit_ne_id          IN nm_inv_items.iit_ne_id%TYPE
                            ,pi_iit_admin_unit_old IN nm_inv_items.iit_admin_unit%TYPE
                            ,pi_iit_admin_unit_new IN nm_inv_items.iit_admin_unit%TYPE
                            ) IS
--
   l_rec_update_au rec_update_au;
--
BEGIN
--
   IF pi_iit_admin_unit_old != pi_iit_admin_unit_new
    THEN
      l_rec_update_au.iit_ne_id          := pi_iit_ne_id;
      l_rec_update_au.iit_admin_unit_old := pi_iit_admin_unit_old;
      l_rec_update_au.iit_admin_unit_new := pi_iit_admin_unit_new;
      g_tab_rec_update_au(g_tab_rec_update_au.COUNT+1) := l_rec_update_au;
   END IF;
--
END pop_update_au_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE clear_inv_type_chk_tab IS
BEGIN
   g_tab_rec_nit.DELETE;
END clear_inv_type_chk_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_inv_type_chk_tab IS
--
   CURSOR cs_check_for_cat (c_category nm_inv_types.nit_category%TYPE
                           ,c_except   nm_inv_types.nit_inv_type%TYPE DEFAULT nm3type.c_nvl
                           ) IS
   SELECT nit_inv_type
    FROM  nm_inv_types
   WHERE  nit_category  = c_category
    AND   nit_inv_type != c_except;
--
   l_inv_type          nm_inv_types.nit_inv_type%TYPE;
--
   l_rec_nit           nm_inv_types%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_inv_type_chk_tab');
--
   FOR i IN 1..g_tab_rec_nit.COUNT
    LOOP
--
      l_rec_nit := g_tab_rec_nit(i);
--
      IF l_rec_nit.nit_category = nm3type.c_stp_nit_category
       THEN
         OPEN  cs_check_for_cat (nm3type.c_stp_nit_category, l_rec_nit.nit_inv_type);
         FETCH cs_check_for_cat INTO l_inv_type;
         IF cs_check_for_cat%FOUND
          THEN
            CLOSE cs_check_for_cat;
            hig.raise_ner(pi_appl               => nm3type.c_net
                         ,pi_id                 => 248
                         ,pi_supplementary_info => 'Already '||l_inv_type
                         );
         END IF;
         CLOSE cs_check_for_cat;
      END IF;
--
   END LOOP;
--
   clear_inv_type_chk_tab;
--
   nm_debug.proc_end(g_package_name,'process_inv_type_chk_tab');
--
EXCEPTION
--
   WHEN others
    THEN
      clear_inv_type_chk_tab;
      RAISE;
--
END process_inv_type_chk_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pop_inv_type_chk_tab (p_rec_nit nm_inv_types%ROWTYPE) IS
BEGIN
   IF   p_rec_nit.nit_category = nm3type.c_stp_nit_category
    AND NOT hig.is_product_licensed (nm3type.c_stp)
    THEN
      hig.raise_ner(pi_appl => nm3type.c_net
                   ,pi_id   => 247
                   );
   END IF;
   g_tab_rec_nit(g_tab_rec_nit.COUNT+1) := p_rec_nit;
END pop_inv_type_chk_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE clear_nm_inv_nw_child_chk_tab IS
BEGIN
   g_tab_inv_nw_chk.DELETE;
END clear_nm_inv_nw_child_chk_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pop_nm_inv_nw_child_chk_tab (p_inv_type nm_inv_types.nit_inv_type%TYPE) IS
BEGIN
   g_tab_inv_nw_chk(g_tab_inv_nw_chk.COUNT+1) := p_inv_type;
END pop_nm_inv_nw_child_chk_tab;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE proc_nm_inv_nw_child_chk_tab IS
--
   CURSOR cs_check (c_inv_type_1 nm_inv_nw.nin_nit_inv_code%TYPE
                   ,c_inv_type_2 nm_inv_nw.nin_nit_inv_code%TYPE
                   ) IS
   SELECT 1
    FROM  nm_inv_nw nin1
         ,nm_inv_nw nin2
   WHERE  nin1.nin_nit_inv_code = c_inv_type_1
    AND   nin2.nin_nit_inv_code = c_inv_type_2
    AND   nin1.nin_nw_type      = nin2.nin_nw_type;
--
   l_dummy PLS_INTEGER;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'proc_nm_inv_nw_child_chk_tab');
--
   FOR i IN 1..g_tab_inv_nw_chk.COUNT
    LOOP
--
      FOR cs_rec IN cs_is_child (g_tab_inv_nw_chk(i))
       LOOP
         IF cs_rec.itg_relation <> c_none_relation
          THEN
            OPEN  cs_check (g_tab_inv_nw_chk(i)
                           ,cs_rec.itg_parent_inv_type
                           );
            FETCH cs_check INTO l_dummy;
            IF cs_check%NOTFOUND
             THEN
               CLOSE cs_check;
               hig.raise_ner(nm3type.c_net,249);
            END IF;
            CLOSE cs_check;
         END IF;
      END LOOP;
--
   END LOOP;
--
   clear_nm_inv_nw_child_chk_tab;
--
   nm_debug.proc_end(g_package_name,'proc_nm_inv_nw_child_chk_tab');
--
EXCEPTION
   WHEN others
    THEN
      clear_nm_inv_nw_child_chk_tab;
      RAISE;
END proc_nm_inv_nw_child_chk_tab;
--
----------------------------------------------------------------------------------------------
--
FUNCTION inv_type_is_child_type (pi_inv_type nm_inv_types.nit_inv_type%TYPE) RETURN BOOLEAN IS
--
   l_dummy  cs_is_child%ROWTYPE;
   l_retval BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'inv_type_is_child_type');
--
   OPEN  cs_is_child (pi_inv_type);
   FETCH cs_is_child INTO l_dummy;
   l_retval := cs_is_child%FOUND;
   CLOSE cs_is_child;
--
   nm_debug.proc_end(g_package_name,'inv_type_is_child_type');
--
   RETURN l_retval;
--
END inv_type_is_child_type;
--
----------------------------------------------------------------------------------------------
--
FUNCTION inv_type_is_parent_type (pi_inv_type nm_inv_types.nit_inv_type%TYPE) RETURN BOOLEAN IS
--
   l_dummy  cs_is_parent%ROWTYPE;
   l_retval BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'inv_type_is_parent_type');
--
   OPEN  cs_is_parent (pi_inv_type);
   FETCH cs_is_parent INTO l_dummy;
   l_retval := cs_is_parent%FOUND;
   CLOSE cs_is_parent;
--
   nm_debug.proc_end(g_package_name,'inv_type_is_parent_type');
--
   RETURN l_retval;
--
END inv_type_is_parent_type;
--
----------------------------------------------------------------------------------------------
--
FUNCTION all_children_are_mandatory_at (pi_inv_type nm_inv_types.nit_inv_type%TYPE) RETURN BOOLEAN IS
--
   l_retval BOOLEAN := TRUE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'all_children_are_mandatory_at');
--
   FOR cs_rec IN cs_is_parent (pi_inv_type)
    LOOP
      IF  cs_rec.itg_mandatory != 'Y'
       OR cs_rec.itg_relation  != c_at_relation
       THEN
         l_retval := FALSE;
         EXIT;
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'all_children_are_mandatory_at');
--
   RETURN l_retval;
--
END all_children_are_mandatory_at;
--
----------------------------------------------------------------------------------------------
--
FUNCTION check_inv_item_latest ( pi_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE)
  RETURN BOOLEAN
IS
-- This function checks if the ne_id of an asset passes in is the latest occurrence
-- based on the nm_inv_type and nm_primary_key
  l_dummy NUMBER;
BEGIN
  -- CWS 22/07/2010 0109041
  -- The first reference to nm_inv_items_all (A) uses the p_iit_ne_id to find the 
  -- iit_inv_type and iit_primary_key. The second reference (B) finds all the assets that 
  -- match these two values and rank them in start_date order. They are then compared
  -- to make sure the entered iit_ne_id belongs to the latest version of the asset.
  --
  -- It was proposed originally to have a view that had the rank added to it to make
  -- the statement simpler but that was inefficient and replaced by this solution.
  --
    SELECT COUNT(*) 
    INTO l_dummy
    FROM (SELECT  A.iit_ne_id AID
                 ,B.iit_ne_id BID
                 ,dense_rank()
                  OVER (PARTITION BY B.iit_inv_type, B.iit_primary_key
                        ORDER BY B.iit_start_date DESC) d_rank
          FROM nm_inv_items_all a
          , nm_inv_items_all b
          WHERE A.iit_ne_id = pi_iit_ne_id
          AND A.IIT_INV_TYPE = B.IIT_INV_TYPE
          AND A.IIT_PRIMARY_KEY = B. IIT_PRIMARY_KEY)
   WHERE AID = BID
   AND d_rank = 1;
  --
  return(l_dummy > 0);
END check_inv_item_latest;
--
----------------------------------------------------------------------------------------------
--
FUNCTION edit_latest_asset_enabled
  RETURN BOOLEAN
-- This function checks if the edit latest asset functionality is enabled
IS
BEGIN
RETURN (hig.get_sysopt('EDITENDDAT') = 'Y');
END edit_latest_asset_enabled;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE process_latest_asset_chk IS
-- This procedure is used in a trigger to make a list of editted assets for edit
-- latest asset validation
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_latest_asset_chk');
--
   FOR i IN 1..g_tab_rec_la_check.COUNT
   LOOP
   --
     IF NOT(nm3invval.check_inv_item_latest ( pi_iit_ne_id => g_tab_rec_la_check(i).iit_ne_id)) THEN
     nm3invval.g_tab_rec_la_check.DELETE;
     hig.raise_ner( pi_appl               => 'NET'
                  , pi_id                 => 464);
     END IF;
   --
   END LOOP;
   nm3invval.g_tab_rec_la_check.DELETE;
--
   nm_debug.proc_end(g_package_name,'process_latest_asset_chk');
--
END process_latest_asset_chk;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE pop_latest_asset_tab( pi_iit_ne_id IN nm_inv_items_all.iit_ne_id%TYPE)
IS
--This procedure is used in a trigger to validate the assets listed in process_latest_asset_chk
BEGIN
--
   nm_debug.proc_start(g_package_name,'pop_latest_asset_tab');
--
   IF UPDATING AND NM3INVVAL.EDIT_LATEST_ASSET_ENABLED THEN
       nm3invval.g_tab_rec_la_check(nm3invval.g_tab_rec_la_check.count+1).iit_ne_id := pi_iit_ne_id;
   END IF;
--
   nm_debug.proc_end(g_package_name,'pop_latest_asset_tab');
--
END pop_latest_asset_tab;
--
----------------------------------------------------------------------------------------------
--
FUNCTION check_contiguity ( pi_ne_id       nm_elements.ne_id%TYPE
                          , pi_inv_type    nm_inv_items.iit_inv_type%TYPE
                          , pi_xsp         nm_inv_items.iit_x_sect%TYPE
                          , pi_route_datum VARCHAR)
  RETURN BOOLEAN
IS
BEGIN
RETURN nm3pla.check_contiguity ( pi_ne_id       => pi_ne_id
                               , pi_inv_type    => pi_inv_type
                               , pi_xsp         => pi_xsp
                               , pi_route_datum => pi_route_datum
                               );
END check_contiguity;

END nm3invval;
/
