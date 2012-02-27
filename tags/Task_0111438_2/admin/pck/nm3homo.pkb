CREATE OR REPLACE PACKAGE BODY nm3homo AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3homo.pkb-arc   2.20   Feb 27 2012 11:38:54   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3homo.pkb  $
--       Date into PVCS   : $Date:   Feb 27 2012 11:38:54  $
--       Date fetched Out : $Modtime:   Feb 27 2012 11:33:56  $
--       PVCS Version     : $Revision:   2.20  $
--
--
--   Author : Jonathan Mills
--
--   Homogenous Inventory Update package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   type t_ne_arr    is table of nm_elements%rowtype index by pls_integer;
   type t_date_arr  is table of pls_integer index by varchar2(11);
   
   type t_chunk_rec is record(begin_mp nm_members.nm_begin_mp%type
                             ,end_mp   nm_members.nm_end_mp%TYPE); 
   type t_chunk_arr is table of t_chunk_rec index by pls_integer;

   -- Log 713421
   TYPE l_child_ne IS RECORD (iit_ne_id        nm_inv_items.iit_ne_id%TYPE
                             ,child_obj_type   nm_inv_items.iit_inv_type%TYPE
                             ,parent_obj_type  nm_inv_items.iit_inv_type%TYPE
                             ,child_location   nm_inv_nw.nin_loc_mandatory%TYPE
                             ,rel_mandatory    nm_inv_type_groupings.itg_mandatory%TYPE
                             ,itg_relation     nm_inv_type_groupings.itg_relation%TYPE) ;
   l_child_ne_rec  l_child_ne ;
   TYPE l_child_ne_table IS TABLE OF l_child_ne INDEX BY BINARY_INTEGER;
   l_child_ne_tab l_child_ne_table ;
   l_par_iit_tab  nm3type.tab_rec_iit ;
   
   -- Log 713421
   
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.20  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3homo';
   
   c_hist_enabled_opt constant hig_option_list.hol_id%TYPE := 'HISTINVLOC';
   c_force_orig_hu    constant hig_option_list.hol_id%TYPE := 'USEORIGHU';
   c_hist_loc_enabled CONSTANT BOOLEAN := NVL(hig.get_sysopt(p_option_id => c_hist_enabled_opt), 'N') = 'Y';
   
   c_date_arr_format CONSTANT varchar2(11) := 'DD-MON-YYYY';
--
--all global package variables here
   g_orig_new_inv_pl_arr NM_PLACEMENT_ARRAY;
--
   g_homo_exc_code   NUMBER         := -20001;
   g_homo_exc_msg    VARCHAR2(2000) := 'Unspecified error within '||g_package_name;
   g_homo_exception  EXCEPTION;
--
   -- <Used in Exclusivity Checking>
   g_tab_vc          nm3type.tab_varchar32767;
   g_tab_vc_inv_type NM_INV_TYPES.nit_inv_type%TYPE := SUBSTR(nm3type.c_nvl,1,4);
   -- </Used in Exclusivity Checking>
--
   c_xattr_status BOOLEAN := nm3inv_xattr.g_xattr_active;
   
   g_debug_on boolean := FALSE;


--
-----------------------------------------------------------------------------
--
PROCEDURE get_xattr_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE xattr_off;
--
-----------------------------------------------------------------------------
--
PROCEDURE xattr_on;
--
-----------------------------------------------------------------------------
--
FUNCTION has_children (pi_iit_ne_id IN NUMBER) RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
--
FUNCTION has_parent   (pi_iit_ne_id IN NUMBER) RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
--
FUNCTION does_relation_exist (p_inv_type IN VARCHAR2
                             ,p_relation IN VARCHAR2
                             ) RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
--
PROCEDURE deal_with_hierarchical (p_ne_id          NUMBER
                                 ,p_effective_date DATE
                                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE check_item_has_no_future_locs (p_iit_ne_id      nm_inv_items.iit_ne_id%TYPE
                                        ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                        );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
procedure db(pi_txt in varchar2
            ) IS
BEGIN
  IF g_debug_on
  THEN
    nm_debug.debug(pi_txt);
  END IF;
END db;
--
-----------------------------------------------------------------------------
--
FUNCTION hist_loc_enabled RETURN BOOLEAN IS
BEGIN
  RETURN c_hist_loc_enabled;

END hist_loc_enabled;
--
-----------------------------------------------------------------------------
--
PROCEDURE homo_update (p_temp_ne_id_in  IN NUMBER
                      ,p_iit_ne_id      IN NUMBER
                      ,p_effective_date IN DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
--
   l_warning_code VARCHAR2(30);
   l_warning_msg  VARCHAR2(32767);
--
   c_pl CONSTANT NM_PLACEMENT_ARRAY := nm3pla.get_placement_from_temp_ne (p_temp_ne_id_in);
--
BEGIN
--
   nm_debug.proc_start(g_package_name, 'homo_update');
--
   homo_update (p_temp_ne_id_in  => p_temp_ne_id_in
               ,p_iit_ne_id      => p_iit_ne_id
               ,p_effective_date => p_effective_date
               ,p_warning_code   => l_warning_code
               ,p_warning_msg    => l_warning_msg
               );
--
   IF l_warning_code IS NOT NULL
    THEN
      NULL;
--  nm_debug.debug('# Temp NE In - ');
--  nm3pla.dump_placement_array(c_pl);
--  nm_debug.debug('# IIT NE ID       : '||p_iit_ne_id);
--  nm_debug.debug('# Effective Date  : '||p_effective_date);
--  nm_debug.debug('# Warning Code    : '||l_warning_code);
--  nm_debug.debug('# Warning Message : '||l_warning_msg);
   END IF;
--
   nm_debug.proc_end(g_package_name, 'homo_update');
--
END homo_update;
--
-----------------------------------------------------------------------------
--
PROCEDURE homo_update_old (p_temp_ne_id_in  IN     NUMBER
                      ,p_iit_ne_id      IN     NUMBER
                      ,p_effective_date IN     DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ,p_warning_code      OUT VARCHAR2
                      ,p_warning_msg       OUT VARCHAR2
                      ) IS
--
   
   CURSOR cs_affected_inv
                (p_nte_job_id NUMBER
                ,p_inv_type   VARCHAR2
                ,p_iit_ne_id  NUMBER
                ) IS
   SELECT DISTINCT nm.*
    FROM  NM_MEMBERS          nm
         ,NM_NW_TEMP_EXTENTS  nte
   WHERE  nte.nte_job_id       = p_nte_job_id
    AND   nte.nte_ne_id_of     = nm.nm_ne_id_of
    AND   nte.nte_begin_mp     < nm.nm_end_mp
    AND   nte.nte_end_mp       > nm.nm_begin_mp
    AND   nm.nm_type           = 'I'
    AND   nm.nm_obj_type       = p_inv_type
    AND   nm.nm_ne_id_in      != p_iit_ne_id;
--
   CURSOR cs_affected_point
                (p_nte_job_id NUMBER
                ,p_inv_type   VARCHAR2
                ,p_iit_ne_id  NUMBER
                ) IS
   SELECT DISTINCT nm.*
    FROM  NM_MEMBERS         nm
         ,NM_NW_TEMP_EXTENTS nte
   WHERE  nte.nte_job_id        = p_nte_job_id
    AND   nte.nte_ne_id_of      = nm.nm_ne_id_of
    AND   nte.nte_begin_mp      = nm.nm_begin_mp
    AND   nte.nte_end_mp        = nm.nm_end_mp
    AND   nm.nm_type            = 'I'
    AND   nm.nm_obj_type        = p_inv_type
    AND   nm.nm_ne_id_in       != p_iit_ne_id;
--
   l_not_correct_xsp EXCEPTION;
--
--   CURSOR cs_xsp (p_iit_ne_id number) IS
--   SELECT iit_x_sect
--    FROM  nm_inv_items
--   WHERE  iit_ne_id = p_iit_ne_id;
--   l_xsp nm_inv_items.iit_x_sect%TYPE;
--
   CURSOR cs_lock (p_ne_id_in   NUMBER
                  ,p_ne_id_of   NUMBER
                  ,p_begin_mp   NUMBER
                  ,p_start_date DATE
                  ) IS
   SELECT ROWID mem_rowid
    FROM  NM_MEMBERS
   WHERE  nm_ne_id_in   = p_ne_id_in
    AND   nm_ne_id_of   = p_ne_id_of
    AND   nm_begin_mp   = p_begin_mp
    AND   nm_start_date = p_start_date
   FOR UPDATE OF nm_end_date NOWAIT;
--
   l_mem_rowid ROWID;
--
   l_new_inv_pl_arr  NM_PLACEMENT_ARRAY;
   l_new_first_pl    NM_PLACEMENT;
   l_new_last_pl     NM_PLACEMENT;
--
   l_inv_orig_location NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
   l_new_inv_location  NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
--
   c_initial_effective_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_rec_nin    NM_INV_NW%ROWTYPE;
   l_rec_nit    NM_INV_TYPES%ROWTYPE;
   l_rec_iit    NM_INV_ITEMS%ROWTYPE;
   l_rec_ne     NM_ELEMENTS%ROWTYPE;
--
   l_dummy            PLS_INTEGER;
--
   l_tab_iit_ne_id    nm3type.tab_number;
--
   c_nte_id_for_unchanged_locs CONSTANT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE := nm3net.get_next_nte_id;
   c_nte_id                    CONSTANT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE := nm3net.get_next_nte_id;
   l_remnant_job_id                     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;

--
   PROCEDURE reset_for_return IS
   BEGIN
      --
      --  Reset the effective date
      --
      nm3user.set_effective_date (c_initial_effective_date);
      nm3extent.g_combine_temp_ne_called := FALSE;
      xattr_on;
   END reset_for_return;
--
BEGIN
--
   nm_debug.proc_start(g_package_name, 'homo_update');
----
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
----
   get_xattr_status;
--
--    Set the effective date
--
   nm3user.set_effective_date (p_effective_date);
--
   -- get a Placement Array with the inventory items original location
   l_inv_orig_location := nm3pla.get_placement_from_ne (p_iit_ne_id);
--
-- Duplicate the NM_NW_TEMP_EXTENTS records for manipulation
--  so we leave the original one untouched
--
   INSERT INTO NM_NW_TEMP_EXTENTS
          (nte_job_id
          ,nte_ne_id_of
          ,nte_begin_mp
          ,nte_end_mp
          ,nte_cardinality
          ,nte_seq_no
          ,nte_route_ne_id
          )
   SELECT  c_nte_id nte_job_id
          ,nte_ne_id_of
          ,nte_begin_mp
          ,nte_end_mp
          ,nte_cardinality
          ,nte_seq_no
          ,nte_route_ne_id
    FROM   NM_NW_TEMP_EXTENTS
   WHERE   nte_job_id = p_temp_ne_id_in;
--
-- nm_debug.debug(' INPUT PARAMETERS ');
-- nm3extent.debug_temp_extents(c_nte_id);
-- nm_debug.debug('temp_ne_id_in  : '||c_nte_id);
-- nm_debug.debug('iit_ne_id      : '||p_iit_ne_id);
-- nm_debug.debug('effective_date : '||p_effective_date);
--  #############################################################################
--   Get NM_INV_ITEMS record
--  #############################################################################
-- nm_debug.debug('Get NM_INV_ITEMS record');
--
   l_rec_iit := nm3inv.get_inv_item(p_iit_ne_id);
   IF l_rec_iit.iit_ne_id IS NULL
    THEN
      g_homo_exc_code := -20502;
      g_homo_exc_msg  := 'No NM_INV_ITEMS record found';
      RAISE g_homo_exception;
   END IF;
--
   IF g_homo_touch_flag 
   THEN
     nm3lock.lock_inv_item (pi_iit_ne_id      => p_iit_ne_id
                           ,p_lock_for_update => TRUE
                           );
   END IF;
--
--  #############################################################################
--   Get NM_INV_TYPES record
--  #############################################################################
-- nm_debug.debug('Get NM_INV_TYPES record');
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => l_rec_iit.iit_inv_type);
--
--  #############################################################################
--   Get rid of any distance break records in the Temp Extent
--    given that we don't want to locate any inventory on a DB
--  #############################################################################
--
   nm3extent.remove_db_from_temp_ne (c_nte_id);
--
--
-- #############################################################################
--  Check to make sure the structure of the temp ne is valid for either point of cont
-- #############################################################################
--
   check_temp_ne_for_pnt_or_cont (pi_nte_job_id  => c_nte_id
                                 ,pi_pnt_or_cont => l_rec_nit.nit_pnt_or_cont
                                 );
--
-- #############################################################################
-- Check multiple allowed
-- #############################################################################
--
   l_new_inv_pl_arr   := nm3pla.get_placement_from_temp_ne (c_nte_id);
   l_new_inv_location := l_new_inv_pl_arr;
   IF l_rec_nit.nit_multiple_allowed != 'Y'
    THEN
      DECLARE
         l_pl_arr           NM_PLACEMENT_ARRAY;
         l_pl               NM_PLACEMENT;
         fail_multi_allowed EXCEPTION;
      BEGIN
         IF   l_new_inv_pl_arr.placement_count > 1
          AND l_rec_nit.nit_pnt_or_cont = 'P'
          THEN
             -- If not multi_allowed and there is >1 loc for a point item fail immediately
            RAISE fail_multi_allowed;
         END IF;
         l_pl_arr := nm3pla.defrag_placement_array(l_new_inv_pl_arr);
         FOR i IN 2..l_pl_arr.placement_count
          LOOP
            l_pl := l_pl_arr.npa_placement_array(i);
            IF l_pl.pl_measure            = 0
             THEN
               -- If the measure is zero then the record is seperate from the last one
               RAISE fail_multi_allowed;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN fail_multi_allowed
          THEN
            g_homo_exc_code := -20513;
            g_homo_exc_msg  := 'Inventory types not marked as "multiple allowed" must only have a single location';
            RAISE g_homo_exception;
      END;
   END IF;
   l_new_inv_pl_arr := nm3pla.initialise_placement_array;
--
--  #############################################################################
--   Check that the temp extents do not overlap
--  #############################################################################
--
   IF nm3extent.temp_ne_has_overlaps (c_nte_id)
    THEN
      g_homo_exc_code := -20519;
      g_homo_exc_msg  := 'NM_NW_TEMP_EXTENTS records with overlaps found';
      RAISE g_homo_exception;
   END IF;
--
   g_orig_new_inv_pl_arr := nm3pla.get_placement_from_temp_ne (c_nte_id);
--
--  #############################################################################
--   If the inventory already has a location
--    and we are therefore relocating, do not
--    relocate bits which are identical
--  #############################################################################
--
-- nm_debug.debug('Initial Temp Extent');
-- nm3extent.debug_temp_extents(c_nte_id);
--
   UPDATE NM_NW_TEMP_EXTENTS nte
    SET   nte.nte_job_id = c_nte_id_for_unchanged_locs
   WHERE  nte.nte_job_id = c_nte_id
    AND   EXISTS (SELECT 1
                   FROM  NM_MEMBERS nm
                  WHERE  nm.nm_ne_id_in = p_iit_ne_id
                   AND   nm.nm_ne_id_of = nte.nte_ne_id_of
                   AND   nm.nm_begin_mp = nte.nte_begin_mp
                   AND   nm.nm_end_mp   = nte.nte_end_mp
                 );
-- nm_debug.debug('Temp Extent with locations removed which are identical to existing inv loc');
---- nm3extent.debug_temp_extents(c_nte_id);
----    nm_debug.debug('Temp Extent with locations which are identical to existing inv loc');
--    nm3extent.debug_temp_extents(c_nte_id_for_unchanged_locs);
--
--  #############################################################################
--   Store the Temp Extent in a Placement array
--  #############################################################################
--
   l_new_inv_pl_arr := nm3pla.get_placement_from_temp_ne (c_nte_id);
--
--  #############################################################################
--   Defragment and re-store the rest of the placement array
--  #############################################################################
--
   l_new_inv_pl_arr := nm3pla.defrag_placement_array(l_new_inv_pl_arr);
--   DELETE FROM nm_nw_temp_extents
--   WHERE nte_job_id = c_nte_id;
-- nm_debug.debug('Defragmented Temp Extent with locations removed which are identical to existing inv loc');
-- nm3extent.debug_temp_extents(l_remnant_job_id);
--   nm3pla.dump_placement_array(l_new_inv_pl_arr);
--
--
   DECLARE
      skip_rest_of_val EXCEPTION;
   BEGIN
      IF l_new_inv_pl_arr.is_empty
       THEN
         IF   NOT nm3extent.g_combine_temp_ne_called -- This is not a "ADD TO LOCATION"
          THEN
            IF NOT nm3ausec.do_locations_exist(p_iit_ne_id)
             THEN  -- And there are no locations currently in existence
               g_homo_exc_code := -20501;
               g_homo_exc_msg  := 'No NM_NW_TEMP_EXTENTS records found';
               RAISE g_homo_exception;
            END IF;
         END IF;
         RAISE skip_rest_of_val;
      END IF;
 
      nm3extent_o.create_temp_ne_from_pl (l_new_inv_pl_arr, l_remnant_job_id);
--      nm_debug.debug('Remnant Temp Extent');
-- nm3extent.debug_temp_extents(l_remnant_job_id);
--   nm3pla.dump_placement_array(l_new_inv_pl_arr);
      l_new_inv_pl_arr := nm3pla.get_placement_from_temp_ne (l_remnant_job_id);
   --
      l_new_first_pl := l_new_inv_pl_arr.npa_placement_array(l_new_inv_pl_arr.npa_placement_array.FIRST);
      l_new_last_pl  := l_new_inv_pl_arr.npa_placement_array(l_new_inv_pl_arr.npa_placement_array.LAST);
   --
   --
   -- Validate where the Inventory is valid on the network, and whether or not
   --  the specified XSP is valid
   -- The code is in multiple anonymous blocks to allow us to trap all of the
   --  20001 errors returned by the atomic functions and return a more meaningful
   --  error to the calling transaction
      --
      -- Get the NW type from the first element in the placement array,
      --  they will all be the same
   -- nm_debug.debug('Get the NW type from the first element in the placement array');
      FOR i IN 1..l_new_inv_pl_arr.placement_count
       LOOP
         DECLARE
            l_pl NM_PLACEMENT := l_new_inv_pl_arr.get_entry(i);
         BEGIN
            l_rec_ne := nm3get.get_ne (pi_ne_id           => l_pl.pl_ne_id
                                      ,pi_raise_not_found => FALSE
                                      );
         END;
         EXIT WHEN l_rec_ne.ne_id IS NOT NULL;
      END LOOP;
   --
      IF l_rec_ne.ne_id IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => 'NM_ELEMENTS : Effective Date : '||TO_CHAR(p_effective_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                       );
--         g_homo_exc_code := -20510;
--         g_homo_exc_msg  := 'No NM_ELEMENTS record found for NE_ID "'||l_new_first_pl.pl_ne_id||'"';
--         RAISE g_homo_exception;
      END IF;
   --
   --  #############################################################################
   --   Get NM_INV_NW record
   --  #############################################################################
   -- nm_debug.debug('Get NM_INV_NW record');
   --
      DECLARE
         no_nin_found EXCEPTION;
         PRAGMA EXCEPTION_INIT (no_nin_found,-20001);
      BEGIN
         l_rec_nin := nm3inv.get_nm_inv_nw(l_rec_iit.iit_inv_type
                                          ,l_rec_ne.ne_nt_type
                                          );
      EXCEPTION
         WHEN no_nin_found
          THEN
            g_homo_exc_code := -20505;
            g_homo_exc_msg  := 'Inventory type "'||l_rec_iit.iit_inv_type||'"'
                               ||' invalid on NW_TYPE "'||l_rec_ne.ne_nt_type||'"';
            RAISE g_homo_exception;
      END;
   --
   -- ####################################################################################
   --  Do not allow location of Child AT records which have a parent
   -- ####################################################################################
   --
      IF   does_relation_exist(l_rec_nit.nit_inv_type,nm3invval.c_at_relation)
       AND has_parent (l_rec_iit.iit_ne_id)
       THEN
           g_homo_exc_code := -20518;
           g_homo_exc_msg  := 'Cannot locate Inventory records which are in a Child AT relationship';
           RAISE g_homo_exception;
      END IF;
   --
   --
   -- LOG 713421
   -- ####################################################################################
   --  Do not allow location chnage of Child IN records which have a parent
   -- ####################################################################################
   --
      IF   (does_relation_exist(l_rec_nit.nit_inv_type,nm3invval.c_in_relation)
           OR 
           does_relation_exist(l_rec_nit.nit_inv_type,nm3invval.c_derived_relation) )
--      AND  has_parent (l_rec_iit.iit_ne_id)
      THEN
          DECLARE
             l_found_par Boolean ;
             c_pl CONSTANT NM_PLACEMENT := l_new_inv_pl_arr.npa_placement_array(1);
             l_ne_id NUMBER ;
             CURSOR  c_parent IS
             SELECT  Nvl(iig_parent_id,0) iig_parent_id,
                     itg_parent_inv_type iit_inv_type 
             FROM    nm_inv_item_groupings iig,
                     nm_inv_items          iit,
                     nm_inv_type_groupings itg
             WHERE   iit.iit_ne_id    =   l_rec_iit.iit_ne_id
             AND     iig_parent_id(+) =   iit.iit_ne_id 
             AND     itg_inv_type     =   iit.iit_inv_type;
             l_parent_rec c_parent%ROWTYPE ;
             l_iit_rec nm_inv_items%ROWTYPE := nm3get.get_iit(l_rec_iit.iit_ne_id);
             --
             CURSOR c_child_loc IS
             SELECT nin_loc_mandatory 
             FROM   nm_inv_nw
             WHERE  nin_nit_inv_code = l_iit_rec.iit_inv_type ;
             l_loc_man nm_inv_nw.nin_loc_mandatory%TYPE;
             --
             CURSOR c_get_rel_mandatory IS
             SELECT  itg_mandatory
                    ,itg_relation
             FROM    nm_inv_type_groupings
             WHERE   itg_inv_type = l_iit_rec.iit_inv_type ;
             l_rel_mandatory  c_get_rel_mandatory%ROWTYPE ;
             l_nit_rec nm_inv_types%ROWTYPE := nm3get.get_nit(l_iit_rec.iit_inv_type) ;
          BEGIN
             l_found_par := False;
             OPEN   c_parent;
             FETCH  c_parent INTO l_parent_rec ;
             CLOSE  c_parent;
             --
             OPEN   c_child_loc;
             FETCH  c_child_loc INTO l_loc_man ;
             CLOSE  c_child_loc;
             --
             OPEN   c_get_rel_mandatory;
             FETCH  c_get_rel_mandatory INTO l_rel_mandatory ;
             CLOSE  c_get_rel_mandatory;              
             --
             FOR i in (SELECT distinct nm_ne_id_in
                       FROM   nm_members
                             ,nm_inv_items
                       WHERE  nm_obj_type = l_parent_rec.iit_inv_type
                       AND    nm_ne_id_in = iit_ne_id
                       AND Decode(l_nit_rec.NIT_X_SECT_ALLOW_FLAG,'Y',Nvl(iit_x_sect,'-'),'-') = Decode(l_nit_rec.NIT_X_SECT_ALLOW_FLAG,'Y',Nvl(l_iit_rec.iit_x_sect,'-'),'-')
                       AND    nm_ne_id_of IN (SELECT x.pl_ne_id
                                              FROM   table(l_new_inv_pl_arr.npa_placement_array) x)
                 )
             LOOP
                 DECLARE
                    --
                    l_ne_id Number  ;
                 BEGIN
                    --  
                    SELECT ne_id INTO l_ne_id
                    FROM
                        (SELECT x.pl_ne_id ne_id
                         from  table( NM3PLA.SUBTRACT_PL_FROM_PL(l_new_inv_pl_arr, NM3PLA.GET_PLACEMENT_FROM_NE( i.nm_ne_id_in )).npa_placement_array) x
                         )
                    WHERE ne_id IS NOT NULL;   
                    --               
                    EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                            l_found_par   := TRUE ;
                            DECLARE
                               --
                               l_iig_rec     nm_inv_item_groupings%ROWTYPE ;
                               --
                            BEGIN
                               --
                               IF l_parent_rec.iig_parent_id != i.nm_ne_id_in
                               THEN 
                                   Update nm_inv_item_groupings
                                   SET    iig_end_date = p_effective_date
                                   WHERE  iig_item_id  = l_rec_iit.iit_ne_id ;
                                   --
                                   l_iig_rec.iig_top_id     := nm3invval.get_iig_top_id(i.nm_ne_id_in) ;
                                   l_iig_rec.iig_item_id    := l_rec_iit.iit_ne_id ;
                                   l_iig_rec.iig_parent_id  := i.nm_ne_id_in ;
                                   l_iig_rec.iig_start_date := p_effective_date ;                                                      
                                   BEGIN
                                      nm3ins.ins_iig(l_iig_rec);  
                                   EXCEPTION
                                       WHEN dup_val_on_index
                                       THEN
                                           UPDATE nm_inv_item_groupings_all
                                           SET    iig_end_date = NULL
                                           WHERE  iig_item_id    = l_rec_iit.iit_ne_id
                                           AND    iig_parent_id  = i.nm_ne_id_in
                                           AND    iig_start_date = p_effective_date ;
                                   END ;
                               END IF;
                               --
                           END ;
                        WHEN Others
                        THEN 
                            Null ;
                 END ;        
             END LOOP ;
             IF NOT l_found_par 
             THEN                 
                 IF  Nvl(l_loc_man,'N')                     = 'N'                   
                 AND NVL(l_rel_mandatory.itg_mandatory,'N') = 'N'
                 THEN
                     UPDATE nm_inv_item_groupings
                     SET    iig_end_date  = p_effective_date
                     WHERE  iig_item_id   = l_rec_iit.iit_ne_id ;
                 ELSIF Nvl(l_loc_man,'N')                     = 'Y'                   
                 AND   NVL(l_rel_mandatory.itg_mandatory,'N') = 'N'
                 AND   l_rel_mandatory.itg_relation           = nm3invval.c_derived_relation
                 THEN
                     UPDATE nm_inv_item_groupings
                     SET    iig_end_date  = p_effective_date
                     WHERE  iig_item_id   = l_rec_iit.iit_ne_id ;
                 ELSE
                     g_homo_exc_code   := -20511;
                     g_homo_exc_msg    := 'Cannot locate Child Asset outside the bounds of Parent Location';
                     RAISE g_homo_exception;
                 END IF ;
             END IF ;
         END ;
      END IF;
   --
   --  #############################################################################
   --   Check to make sure continuous isn't placed at a point
   --  #############################################################################
   -- nm_debug.debug('Check to make sure continuous isnt placed at a point');
   --
      IF   l_rec_nit.nit_pnt_or_cont = 'C'
       AND l_new_first_pl.pl_ne_id = l_new_last_pl.pl_ne_id
       AND l_new_first_pl.pl_start = l_new_last_pl.pl_end
       THEN
         g_homo_exc_code := -20512;
         g_homo_exc_msg  := 'Continuous Inventory Items must not be placed at a single point';
         RAISE g_homo_exception;
      ELSIF l_rec_nit.nit_pnt_or_cont        = 'P'
        THEN
          FOR i IN 1..l_new_inv_pl_arr.placement_count
           LOOP
             DECLARE
                c_pl CONSTANT NM_PLACEMENT := l_new_inv_pl_arr.npa_placement_array(i);
             BEGIN
                IF c_pl.pl_start != c_pl.pl_end
                 THEN
                   g_homo_exc_code := -20515;
                   g_homo_exc_msg  := 'Point Inventory Items can only be placed at single points';
                   RAISE g_homo_exception;
                END IF;
             END;
          END LOOP;
      END IF;
   --
   --  #############################################################################
   --   Validate the XSP
   --  #############################################################################
   -- nm_debug.debug('Validate the XSP');
   --
      IF   l_rec_nit.nit_x_sect_allow_flag = 'N'
       AND l_rec_iit.iit_x_sect IS NOT NULL
       THEN
         g_homo_exc_code := -20506;
         g_homo_exc_msg  := 'XSP not allowed for Inventory type "'||l_rec_iit.iit_inv_type||'"';
         RAISE g_homo_exception;
      ELSIF l_rec_nit.nit_x_sect_allow_flag = 'Y'
       THEN
         IF l_rec_iit.iit_x_sect IS NULL
          THEN
            g_homo_exc_code := -20507;
            g_homo_exc_msg  := 'XSP must be specified for Inventory type "'||l_rec_iit.iit_inv_type||'"';
            RAISE g_homo_exception;
         ELSE
            --
            -- For all the elements on which this item is being located, check XSP restraints
            --
            DECLARE
               l_last_rec_ne  NM_ELEMENTS%ROWTYPE;
               l_local_rec_ne NM_ELEMENTS%ROWTYPE;
               l_ne_id        NM_ELEMENTS.ne_id%TYPE;
               l_tab_ne_id_ok nm3type.tab_boolean;
            BEGIN
               l_last_rec_ne.ne_nt_type   := nm3type.c_nvl;
               l_last_rec_ne.ne_sub_class := nm3type.c_nvl;
               FOR j IN 1..l_new_inv_pl_arr.placement_count
                LOOP
                  l_ne_id := l_new_inv_pl_arr.get_entry(j).pl_ne_id;
                  --
                  IF NOT l_tab_ne_id_ok.EXISTS(l_ne_id)
                   THEN -- Only check for NE_IDs we haven't already checked - no point wasting time
                  --
                     l_local_rec_ne := nm3net.get_ne (l_ne_id);
                     IF  l_local_rec_ne.ne_nt_type                      != l_last_rec_ne.ne_nt_type
                      OR NVL(l_local_rec_ne.ne_sub_class,nm3type.c_nvl) != NVL(l_last_rec_ne.ne_sub_class,nm3type.c_nvl)
                      THEN -- Only check if the NT_TYPE or the SUBCLASS has changed from the previous record. no point otherwise
                        DECLARE
                           l_xsr_descr  XSP_RESTRAINTS.xsr_descr%TYPE;
                           no_xsr_found EXCEPTION;
                           PRAGMA EXCEPTION_INIT (no_xsr_found,-20001);
                        BEGIN
                           l_xsr_descr := nm3inv.get_xsp_descr
                                             (p_inv_type   => l_rec_iit.iit_inv_type
                                             ,p_x_sect_val => l_rec_iit.iit_x_sect
                                             ,p_nw_type    => l_local_rec_ne.ne_nt_type
                                             ,p_scl_class  => l_local_rec_ne.ne_sub_class
                                             );
                        EXCEPTION
                           WHEN no_xsr_found
                            THEN
                              g_homo_exc_code := -20508;
                              g_homo_exc_msg  := 'XSP "'||l_rec_iit.iit_x_sect||'" is not allowed for Inventory type "'
                                                 ||l_rec_iit.iit_inv_type||'" on NW_TYPE "'||l_local_rec_ne.ne_nt_type||'"'
                                                 ||', SUB_CLASS "'||l_local_rec_ne.ne_sub_class||'"';
                              RAISE g_homo_exception;
                        END;
                     END IF;
                     l_last_rec_ne           := l_local_rec_ne;
                     l_tab_ne_id_ok(l_ne_id) := TRUE;
                  END IF;
                  --
               END LOOP;
                  --
            END;
         END IF;
      END IF;
   --
   --  #############################################################################
   --   Check the item has no future locations
   --  #############################################################################
   --
   check_item_has_no_future_locs (p_iit_ne_id      => l_rec_iit.iit_ne_id
                                 ,p_effective_date => p_effective_date
                                 );
   --
   --  #############################################################################
   --   Check for future affected inv
   --  #############################################################################
   -- nm_debug.debug('Check for future affected inv');
   --
      DECLARE
         l_future_ne_id_in nm3type.tab_number;
      BEGIN
         l_future_ne_id_in := get_future_affected_inv
                                          (p_nte_job_id     => l_remnant_job_id
                                          ,p_inv_type       => l_rec_iit.iit_inv_type
                                          ,p_effective_date => p_effective_date
                                          );
         FOR i IN 1..l_future_ne_id_in.COUNT
          LOOP
            IF is_affected_by_exclusivity (p_iit_ne_id => l_future_ne_id_in(i)
                                          ,p_rec_iit   => l_rec_iit
                                          ,p_exclusive => (l_rec_nit.nit_exclusive         = 'Y')
                                          ,p_x_sect    => (l_rec_nit.nit_x_sect_allow_flag = 'Y')
                                          )
             THEN
               g_homo_exc_code := -20503;
               g_homo_exc_msg  := 'There are future inventory locations which would be affected';
               RAISE g_homo_exception;
            END IF;
         END LOOP;
      END;
   --
   --
   -- ##############################################################
   --   End of the basic validation
   -- ##############################################################
   --
   EXCEPTION
      WHEN skip_rest_of_val
       THEN
         NULL;
   END;
--
-- #####################################################################################
-- Lock all datum elements of the temp_ne;
-- #####################################################################################

   DECLARE
      --
      CURSOR cs_nte_ele (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT ne.ROWID ne_rowid
       FROM  nm_elements_all    ne
            ,(SELECT nte.nte_ne_id_of -- get the distinct list of NE_IDs
               FROM  nm_nw_temp_extents nte
              WHERE  nte_job_id   = c_nte_job_id
              GROUP BY nte.nte_ne_id_of
             )
      WHERE  nte_ne_id_of = ne_id
      FOR UPDATE OF ne_date_modified NOWAIT;
      --
      CURSOR cs_nte_nm (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT /*+ INDEX (nm nm_ne_id_of_ind) */ nm.ROWID nm_rowid
       FROM  nm_members         nm
            ,(SELECT nte.nte_ne_id_of -- get the distinct list of NE_IDs
               FROM  nm_nw_temp_extents nte
              WHERE  nte_job_id   = c_nte_job_id
              GROUP BY nte.nte_ne_id_of
             )
      WHERE  nte_ne_id_of = nm.nm_ne_id_of
       AND   nm.nm_type   = 'G'
      FOR UPDATE OF nm_date_modified NOWAIT;
      --
      l_tab_ne_rowid nm3type.tab_rowid;
      l_tab_nm_rowid nm3type.tab_rowid;
      --
   BEGIN
      --
      OPEN  cs_nte_ele (l_remnant_job_id);
      FETCH cs_nte_ele
       BULK COLLECT
       INTO l_tab_ne_rowid;
      CLOSE cs_nte_ele;
      --
      IF nm3ausec.get_status = nm3type.c_off
       THEN
         --
         -- JM - 25/03/03
         -- If AU Security is switched OFF then we are assuming (as other code does)
         --  that whatever is happening is "trusted". Therefore if the operation is "trusted"
         --  then the assumption may be made that the operation is running on an isolated
         --  database so we don't need to lock ALL the records up - this takes quite a
         --  long time to lock the members which becomes VERY noticible when running in
         --  batch mode (i.e. from the CSV loader), so we will just lock the element
         --  records - this would stop an "untrusted" homo running on the same element
         --
         Null;
      ELSE
--
--       Lock up any GROUP membership records
--        on which we are locating inventory.
--       This will prevent people rescaling etc when we are locating
--        (undesirable because we may well be locating by Route/SLK),
--        but it's not going to try and lock up all the inventory members
--        which will (and does!) take an age
--       This means that we do not NEED to switch off AUSEC in order to get the
--        majority of the performance benefit - good for bulk loading when the AU
--        is to be policed
--
         OPEN  cs_nte_nm (l_remnant_job_id);
         FETCH cs_nte_nm
          BULK COLLECT
          INTO l_tab_nm_rowid;
         CLOSE cs_nte_nm;
--      nm3extent.lock_temp_extent_datums(l_remnant_job_id);
      END IF;
   END;
--
--   END IF;
--
--  #############################################################################
--   End date location of the inventory being placed
--  #############################################################################
--
    xattr_off;
    UPDATE NM_MEMBERS nm
    SET   nm.nm_end_date = p_effective_date
    WHERE  nm.nm_ne_id_in = p_iit_ne_id
    AND NOT EXISTS (SELECT 1
                    FROM  NM_NW_TEMP_EXTENTS nte
                    WHERE  nte.nte_job_id   = c_nte_id_for_unchanged_locs
                    AND   nte.nte_ne_id_of = nm.nm_ne_id_of
                    AND   nte.nte_begin_mp = nm.nm_begin_mp
                    AND   nte.nte_end_mp   = nm.nm_end_mp
                   );
   xattr_on;

   nm3extent.g_combine_temp_ne_called := FALSE;
--
--  #############################################################################
--   Replace existing inventory
--    Existing membership by existing membership
--  #############################################################################
-- nm_debug.debug('Replace existing inventory');
--
   IF l_rec_nit.nit_exclusive = 'Y'
    THEN
      IF l_rec_nit.nit_pnt_or_cont = 'C'
       THEN
         FOR cs_rec IN cs_affected_inv (l_remnant_job_id, l_rec_iit.iit_inv_type, p_iit_ne_id)
          LOOP -- This cursor returns affected membership records, independent of XSP
               -- The records with the "wrong" XSP are ignored
   --
            DECLARE
      --
               l_new_nm_reqd nm3type.tab_rec_nm;
               l_placed_begin_mp nm3type.tab_number;
               l_placed_end_mp   nm3type.tab_number;
      --
               c_orig_rec_nm CONSTANT NM_MEMBERS%ROWTYPE := cs_rec;
               l_mp              nm3type.tab_number;
      --
               l_placement_arr   NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
               l_member_arr      NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
               l_tab_dont_do     nm3type.tab_number;
   --
               l_pl_pos NUMBER;
      --
            BEGIN
      --
               IF is_affected_by_exclusivity (p_iit_ne_id => cs_rec.nm_ne_id_in
                                             ,p_rec_iit   => l_rec_iit
                                             ,p_exclusive => (l_rec_nit.nit_exclusive         = 'Y')
                                             ,p_x_sect    => (l_rec_nit.nit_x_sect_allow_flag = 'Y')
                                             )
                THEN
                  NULL;
               ELSE
                  RAISE l_not_correct_xsp;
               END IF;
--               IF l_rec_iit.iit_x_sect IS NOT NULL
--                THEN
--                  -- Check the XSP to make sure we're interested
--                  OPEN  cs_xsp (cs_rec.nm_ne_id_in);
--                  FETCH cs_xsp INTO l_xsp;
--                  CLOSE cs_xsp;
--                  IF l_xsp != l_rec_iit.iit_x_sect
--                   THEN
--                     RAISE l_not_correct_xsp;
--                  END IF;
--               END IF;
            --
      --
            -- nm_debug.debug('Original');
            -- nm_debug.debug(cs_rec.nm_ne_id_in||':'||cs_rec.nm_ne_id_of||':'||cs_rec.nm_begin_mp||':'||cs_rec.nm_end_mp);
   --
               OPEN  cs_lock (cs_rec.nm_ne_id_in
                             ,cs_rec.nm_ne_id_of
                             ,cs_rec.nm_begin_mp
                             ,cs_rec.nm_start_date
                             );
               FETCH cs_lock INTO l_mem_rowid;
               CLOSE cs_lock;
   --
               xattr_off;
               UPDATE NM_MEMBERS
                SET   nm_end_date = p_effective_date
               WHERE  ROWID       = l_mem_rowid;
               xattr_on;
   --
               -- Deal with any hierarchical children
               deal_with_hierarchical (p_ne_id          => cs_rec.nm_ne_id_in
                                      ,p_effective_date => p_effective_date
                                      );
   --
   --
               -- Record this iit_ne_id as having had it's location changed
               l_tab_iit_ne_id(l_tab_iit_ne_id.COUNT+1) := cs_rec.nm_ne_id_in;
   --
               -- Get all of the MPs for this NE_ID_OF
               FOR cs_mp IN (SELECT nte_begin_mp mp
                              FROM  NM_NW_TEMP_EXTENTS
                             WHERE  nte_job_id   = l_remnant_job_id
                              AND   nte_ne_id_of = cs_rec.nm_ne_id_of
                             UNION
                             SELECT nte_end_mp mp
                              FROM  NM_NW_TEMP_EXTENTS
                             WHERE  nte_job_id   = l_remnant_job_id
                              AND   nte_ne_id_of = cs_rec.nm_ne_id_of
                             UNION
                             SELECT cs_rec.nm_begin_mp mp
                              FROM  dual
                             UNION
                             SELECT cs_rec.nm_end_mp mp
                              FROM  dual
                            )
                LOOP
                  l_mp(l_mp.COUNT+1) := cs_mp.mp;
               END LOOP;
            -- nm_debug.debug('Potential chunks');
               -- Assemble the MPs into potential chunks
               FOR l_count IN 1..l_mp.COUNT-1
                LOOP
                  l_placement_arr := l_placement_arr.add_element(pl_ne_id   => cs_rec.nm_ne_id_of
                                                                ,pl_start   => l_mp(l_count)
                                                                ,pl_end     => l_mp(l_count+1)
                                                                ,pl_measure => 0
                                                                ,pl_mrg_mem => FALSE
                                                                );
                  l_placed_begin_mp(l_count) := l_mp(l_count);
                  l_placed_end_mp(l_count)   := l_mp(l_count+1);
                -- nm_debug.debug(l_mp(l_count)||':'||l_mp(l_count+1));
               END LOOP;
   --
   --            nm3pla.dump_placement_array(l_placement_arr);
   --
               -- Mark any of those potential chunks as not to be reused if they are the location of the new item
               l_pl_pos := 1;
               FOR cs_placed IN (SELECT nte_begin_mp
                                       ,nte_end_mp
                                  FROM  NM_NW_TEMP_EXTENTS
                                 WHERE  nte_job_id   = l_remnant_job_id
                                  AND   nte_ne_id_of = cs_rec.nm_ne_id_of
                                 ORDER BY nte_begin_mp
                                )
                LOOP
                 -- nm_debug.debug('running thro '||cs_placed.nte_begin_mp||':'||cs_placed.nte_end_mp);
                  IF l_placement_arr.npa_placement_array(l_pl_pos).pl_start = cs_placed.nte_begin_mp
                   THEN
                  -- nm_debug.debug('S Dont do '||l_placement_arr.npa_placement_array(l_pl_pos).pl_start||':'||l_placement_arr.npa_placement_array(l_pl_pos).pl_end);
                     l_tab_dont_do(l_pl_pos) := l_pl_pos;
                  ELSE
                     l_pl_pos := l_pl_pos+1;
                  END IF;
                  LOOP
                    EXIT WHEN l_placement_arr.npa_placement_array(l_pl_pos).pl_start >= cs_placed.nte_begin_mp;
                    l_pl_pos := l_pl_pos+1;
                  END LOOP;
                  LOOP
                     IF l_placement_arr.npa_placement_array(l_pl_pos).pl_end <= cs_placed.nte_end_mp
                      THEN
                        l_tab_dont_do(l_pl_pos) := l_pl_pos;
                     -- nm_debug.debug('E Dont do '||l_placement_arr.npa_placement_array(l_pl_pos).pl_start||':'||l_placement_arr.npa_placement_array(l_pl_pos).pl_end);
                        IF l_placement_arr.npa_placement_array(l_pl_pos).pl_end = cs_placed.nte_end_mp
                         THEN
                           EXIT;
                        END IF;
                        l_pl_pos := l_pl_pos+1;
                     ELSE
                        EXIT;
                     END IF;
                  END LOOP;
               END LOOP;
   --
               -- Re-create any of the location records for existing inventory on this ne_id_of
               FOR l_count IN 1..l_placement_arr.npa_placement_array.COUNT
                LOOP
                  IF NOT l_tab_dont_do.EXISTS(l_count)
                   THEN
                     DECLARE
                        l_pl NM_PLACEMENT := l_placement_arr.npa_placement_array(l_count);
                     BEGIN
                        l_member_arr := l_member_arr.add_element(pl_ne_id   => l_pl.pl_ne_id
                                                                ,pl_start   => l_pl.pl_start
                                                                ,pl_end     => l_pl.pl_end
                                                                ,pl_measure => 0
                                                                ,pl_mrg_mem => FALSE
                                                                );
                     END;
                  END IF;
               END LOOP;
--             nm_debug.debug('Inserting replacements');
--             nm3pla.dump_placement_array(l_member_arr);
               IF NOT l_member_arr.is_empty
                THEN
                  FOR l_count IN 1..l_member_arr.npa_placement_array.COUNT
                   LOOP
                     DECLARE
                        l_pl         NM_PLACEMENT := l_member_arr.npa_placement_array(l_count);
                        l_rec_nm     NM_MEMBERS%ROWTYPE := cs_rec;
                        l_rec_chi_nm NM_MEMBERS%ROWTYPE ;
                        --Log 713412:Linesh:Start
                        --Added Following to move the Subordinate Asset Location to that of the Parent
                        CURSOR  c_child_nm(qp_nm_ne_id_in nm_members.nm_ne_id_in%TYPE)
                        IS
                        SELECT Distinct nm_ne_id_in   
                                       ,Null nm_ne_id_of   
                                       ,nm_type  
                                       ,nm_obj_type   
                                       ,Null nm_begin_mp   
                                       ,Null nm_start_date   
                                       ,Null nm_end_date   
                                       ,Null nm_end_mp  
                                       ,Null nm_slk   
                                       ,Null nm_cardinality   
                                       ,Null nm_admin_unit   
                                       ,Null nm_date_created   
                                       ,Null nm_date_modified   
                                       ,Null nm_modified_by   
                                       ,Null nm_created_by   
                                       ,Null nm_seq_no     
                                       ,Null nm_seg_no   
                                       ,Null nm_true   
                                       ,Null nm_end_slk   
                                       ,Null nm_end_true
                        FROM   nm_members_all nm
                        WHERE  nm_ne_id_in IN (SELECT  iit.iit_ne_id
                                               FROM    NM_INV_ITEMS iit
                                                      ,NM_INV_ITEMS iit_p
                                                      ,NM_INV_TYPE_GROUPINGS
                                                      ,NM_INV_ITEM_GROUPINGS
                                               WHERE  iit.iit_ne_id IN (SELECT iig_item_id
                                                                        FROM   NM_INV_ITEM_GROUPINGS
                                                                        START WITH iig_parent_id = qp_nm_ne_id_in
                                                                        CONNECT BY iig_parent_id = PRIOR iig_item_id
                                                                        )
                                               AND   iig_parent_id      = iit_p.iit_ne_id
                                               AND   iig_item_id        = iit.iit_ne_id
                                               AND   iit.iit_inv_type   = itg_inv_type
                                               AND   itg_relation = 'AT'                --LOG 713421
                                               AND   iit_p.iit_inv_type = itg_parent_inv_type
                                               ) 
                        AND    nm_type = 'I'       ;                     
                        l_child_nm_rec NM_MEMBERS%ROWTYPE  ;
                        --Log 713412:Linesh:End
                     BEGIN
                        l_rec_nm.nm_begin_mp   := l_pl.pl_start;
                        l_rec_nm.nm_end_mp     := l_pl.pl_end;
                        l_rec_nm.nm_start_date := p_effective_date;
--                      nm_debug.debug('IN : '||l_rec_nm.nm_ne_id_in||' : OF : '||l_rec_nm.nm_ne_id_of||' : BEGIN : '||l_rec_nm.nm_begin_mp||' : END : '||l_rec_nm.nm_end_mp);
                        xattr_off;
                        nm3net.ins_nm(l_rec_nm);
                        xattr_on;
                        --Log 713412:Linesh:Start
                        xattr_off;
                        Open c_child_nm(l_rec_nm.nm_ne_id_in) ;
                        Loop
                             Fetch c_child_nm INTO l_child_nm_rec ;
                             EXIT WHEN c_child_nm%NOTFOUND;
                             l_rec_chi_nm           := l_rec_nm ;
                             l_rec_chi_nm.nm_ne_id_in   := l_child_nm_rec.nm_ne_id_in ;
                             l_rec_chi_nm.nm_type       := l_child_nm_rec.nm_type ;    
                             l_rec_chi_nm.nm_obj_type   := l_child_nm_rec.nm_obj_type ;
                             nm3net.ins_nm(l_rec_chi_nm);
                        End Loop ;
                        Close c_child_nm ;            
                        xattr_on;                        
                        --Log 713412:Linesh:End
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX
                         THEN
                             --Log 713412:Linesh:Start
--                             hig.raise_ner(pi_appl               => 'NET'
--                                          ,pi_id                 => 104
--                                          ,pi_supplementary_info => Null);
                             --xattr_off;
                             --UPDATE NM_MEMBERS_ALL
                             --SET   nm_end_date = l_rec_nm.nm_end_date
                             --    ,nm_end_mp   = l_rec_nm.nm_end_mp
                             --WHERE  ROWID       = l_mem_rowid;
                             --xattr_on;
                             --Log 713412:Linesh:End
--                           g_homo_exc_code := -20516;
--                           g_homo_exc_msg  := 'Inventory Locations already exist for affected inventory at this point with this start date';
--                           RAISE g_homo_exception;

                        -- Task 0109972
                        -- Reverted this code back to how it used to be so that you can locate
                        -- the same asset on the same day twice without failure  
                           xattr_off;
                           UPDATE NM_MEMBERS_ALL
                            SET   nm_end_date = l_rec_nm.nm_end_date
                                 ,nm_end_mp   = l_rec_nm.nm_end_mp
                           WHERE  ROWID       = l_mem_rowid;
                           xattr_on;
                     END;
                  END LOOP;
               END IF;
   --
            EXCEPTION
               WHEN l_not_correct_xsp
                THEN
                  NULL;
            END;
         END LOOP;
      ELSE -- This is a POINT item
         FOR cs_rec IN cs_affected_point (l_remnant_job_id, l_rec_iit.iit_inv_type, p_iit_ne_id)
          LOOP
      --
            BEGIN
               IF is_affected_by_exclusivity (p_iit_ne_id => cs_rec.nm_ne_id_in
                                             ,p_rec_iit   => l_rec_iit
                                             ,p_exclusive => (l_rec_nit.nit_exclusive         = 'Y')
                                             ,p_x_sect    => (l_rec_nit.nit_x_sect_allow_flag = 'Y')
                                             )
                THEN
                  NULL;
               ELSE
                  RAISE l_not_correct_xsp;
               END IF;
--               IF l_rec_iit.iit_x_sect IS NOT NULL
--                THEN
--                  -- Check the XSP to make sure we're interested
--                  OPEN  cs_xsp (cs_rec.nm_ne_id_in);
--                  FETCH cs_xsp INTO l_xsp;
--                  CLOSE cs_xsp;
--                  IF l_xsp != l_rec_iit.iit_x_sect
--                   THEN
--                     RAISE l_not_correct_xsp;
--                  END IF;
--               END IF;
            --
               OPEN  cs_lock (cs_rec.nm_ne_id_in
                             ,cs_rec.nm_ne_id_of
                             ,cs_rec.nm_begin_mp
                             ,cs_rec.nm_start_date
                             );
               FETCH cs_lock INTO l_mem_rowid;
               CLOSE cs_lock;
   --
               xattr_off;
               UPDATE NM_MEMBERS
                SET   nm_end_date = p_effective_date
               WHERE  ROWID       = l_mem_rowid;
               xattr_on;
   --
               -- Record this iit_ne_id as having had it's location changed
               l_tab_iit_ne_id(l_tab_iit_ne_id.COUNT+1) := cs_rec.nm_ne_id_in;
   --
            EXCEPTION
               WHEN l_not_correct_xsp
                THEN
                  NULL;
            END;
   --
         END LOOP;
      END IF;
--
   END IF;
--
   -- ###############################################################################################
   -- Go through all of the inv_items we have
   --  just done some location changes on and end-date
   --  if there are no locations left
   -- ###############################################################################################
-- nm_debug.debug_on;
-- nm_debug.debug('Go through all of the inv_items we have just done some location changes on and end-date');
--RC - X attr can be switched off here since the items are being replaced - check the new ones only
   IF l_rec_nit.nit_end_loc_only != 'Y'
    THEN
      xattr_off;
      FORALL l_count IN 1..l_tab_iit_ne_id.COUNT
         UPDATE nm_inv_items
          SET   iit_end_date = p_effective_date
         WHERE  iit_ne_id    = l_tab_iit_ne_id(l_count)
          AND NOT EXISTS (SELECT 1                           -- item has no location currently
                           FROM  nm_members
                          WHERE  nm_ne_id_in = iit_ne_id
                         )
          AND NOT EXISTS (SELECT 1                           -- item has no pre-existing future location
                           FROM  nm_members_all
                          WHERE  nm_ne_id_in   = iit_ne_id
                           AND   nm_start_date > p_effective_date
                         );
      xattr_on;
   END IF;
--
-- Inserting membership records for the newly placed item
-- nm_debug.debug('Inserting membership records for the newly placed item');
--
   DECLARE
      l_nm_seq_no NM_MEMBERS.nm_seq_no%TYPE;
      CURSOR cs_nte (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT *
       FROM  NM_NW_TEMP_EXTENTS
      WHERE  nte_job_id = c_nte_job_id;
      l_rec_nm NM_MEMBERS%ROWTYPE;
   BEGIN
-- nm_debug.debug('Remnants later');
-- nm3extent.debug_temp_extents(l_remnant_job_id);
      FOR cs_rec IN cs_nte (l_remnant_job_id)
       LOOP
--
         BEGIN
--          nm_debug.debug('############ '||cs_nte%ROWCOUNT||' cs_nte count');
   --       Changed to be a cursor loop rather than a single INSERT statement as to not
   --        cause AU security to grind to a halt
   --
            l_nm_seq_no := NVL(get_seq_no_from_orig(cs_rec.nte_ne_id_of
                                                   ,cs_rec.nte_begin_mp
                                                   ,cs_rec.nte_end_mp
                                                   )
                              ,cs_rec.nte_seq_no
                              );
--            nm_debug.debug('############ '||cs_nte%ROWCOUNT||' pre insert');
   --
            l_rec_nm.nm_ne_id_in    := l_rec_iit.iit_ne_id;
            l_rec_nm.nm_ne_id_of    := cs_rec.nte_ne_id_of;
            l_rec_nm.nm_type        := 'I';
            l_rec_nm.nm_obj_type    := l_rec_iit.iit_inv_type;
            l_rec_nm.nm_begin_mp    := cs_rec.nte_begin_mp;
            l_rec_nm.nm_start_date  := p_effective_date;
            l_rec_nm.nm_end_date    := l_rec_iit.iit_end_date;
            l_rec_nm.nm_end_mp      := cs_rec.nte_end_mp;
            l_rec_nm.nm_slk         := NULL;
            l_rec_nm.nm_cardinality := 1;
            l_rec_nm.nm_admin_unit  := l_rec_iit.iit_admin_unit;
            l_rec_nm.nm_seq_no      := l_nm_seq_no;
            l_rec_nm.nm_seg_no      := NULL;
            l_rec_nm.nm_true        := NULL;
            nm3net.ins_nm (l_rec_nm);
--            nm_debug.debug('############ '||cs_nte%ROWCOUNT||' post insert');
         EXCEPTION
            WHEN DUP_VAL_ON_INDEX
             THEN
--               nm_debug.debug('############ dup_val_on_index caught');
               DELETE NM_MEMBERS_ALL
               WHERE  nm_ne_id_in   = l_rec_nm.nm_ne_id_in
                AND   nm_ne_id_of   = l_rec_nm.nm_ne_id_of
                AND   nm_begin_mp   = l_rec_nm.nm_begin_mp
                AND   nm_start_date = l_rec_nm.nm_start_date;
               nm3net.ins_nm (l_rec_nm);
         END;
--
      END LOOP;
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
       THEN
         g_homo_exc_code := -20517;
         g_homo_exc_msg  := 'Inventory Locations already exist for this item at this point with this start date';
         RAISE g_homo_exception;
   END;
--
-- nm_debug.debug('   -- Deal with any hierarchical children');
   -- Deal with any hierarchical children
   deal_with_hierarchical (p_ne_id          => l_rec_iit.iit_ne_id
                          ,p_effective_date => p_effective_date
                          );
   -- LOG 713421
   FOR j in 1..l_child_ne_tab.count 
   LOOP
       l_child_ne_rec := l_child_ne_tab(j) ;
       DECLARE
          l_found_par Boolean ;
          l_nit_rec nm_inv_types%ROWTYPE := nm3get.get_nit(l_child_ne_rec.child_obj_type ) ;
       BEGIN
         l_found_par := False;
         FOR i in (SELECT Distinct nm_ne_id_in 
                   FROM   nm_members
                         ,nm_inv_items 
                   WHERE  nm_obj_type = l_child_ne_rec.parent_obj_type 
                   AND    nm_ne_id_in = iit_ne_id
                   AND    (nm_ne_id_of,Decode(l_nit_rec.NIT_X_SECT_ALLOW_FLAG,'Y',Nvl(iit_x_sect,'-'),'-')) IN (SELECT nm_ne_id_of,Decode(l_nit_rec.NIT_X_SECT_ALLOW_FLAG,'Y',Nvl(iit_x_sect,'-'),'-') 
                                                                FROM   nm_members 
                                                                      ,nm_inv_items    
                                                                WHERE  nm_obj_type = l_child_ne_rec.child_obj_type  
                                                                AND    nm_ne_id_in = l_child_ne_rec.iit_ne_id 
                                                                AND    nm_ne_id_in = iit_ne_id))
         LOOP
             DECLARE
               --
               l_ne_id Number  ;
               BEGIN
                  --  
                  SELECT ne_id INTO l_ne_id
                  FROM
                      (SELECT x.pl_ne_id ne_id
                       from  table( NM3PLA.SUBTRACT_PL_FROM_PL( NM3PLA.GET_PLACEMENT_FROM_NE( l_child_ne_rec.iit_ne_id ), NM3PLA.GET_PLACEMENT_FROM_NE( i.nm_ne_id_in )).npa_placement_array) x
                       )
                  WHERE ne_id IS NOT NULL;   
                  --               
             EXCEPTION
                 WHEN NO_DATA_FOUND
                 THEN
                     l_found_par   := TRUE ;
                     DECLARE
                        --
                        l_iig_rec     nm_inv_item_groupings%ROWTYPE ;
                        CURSOR  c_parent IS
                        SELECT  iig_parent_id ,
                                iit.iit_inv_type 
                        FROM    nm_inv_item_groupings iig,
                                nm_inv_items          iit
                        WHERE   iig_item_id   =   l_child_ne_rec.iit_ne_id
                        AND     iig_parent_id = iit.iit_ne_id ;
                        l_rec  c_parent%ROWTYPE ; 
                        --
                     BEGIN
                        --
                        OPEN   c_parent;
                        FETCH  c_parent INTO l_rec ;
                        CLOSE  c_parent;
                        
                        IF l_rec.iig_parent_id != i.nm_ne_id_in
                        THEN
                            Update nm_inv_item_groupings
                            SET    iig_end_date = p_effective_date
                            WHERE  iig_item_id  = l_child_ne_rec.iit_ne_id ;
                            --
                            l_iig_rec.iig_top_id     := nm3invval.get_iig_top_id(i.nm_ne_id_in) ;
                            l_iig_rec.iig_item_id    := l_child_ne_rec.iit_ne_id ;
                            l_iig_rec.iig_parent_id  := i.nm_ne_id_in ;
                            l_iig_rec.iig_start_date := p_effective_date ;
                            BEGIN
                               nm3ins.ins_iig(l_iig_rec);                   
                            EXCEPTION
                                WHEN dup_val_on_index
                                THEN
                                    UPDATE nm_inv_item_groupings_all
                                    SET    iig_end_date = NULL
                                    WHERE  iig_item_id    = l_child_ne_rec.iit_ne_id
                                    AND    iig_parent_id  = i.nm_ne_id_in
                                    AND    iig_start_date = p_effective_date ;
                            END ;  
                        END IF ;
                        --
                     END ;
             END ;       
         END LOOP ;
         IF NOT l_found_par 
         THEN
             IF  l_child_ne_rec.child_location  = 'N'
             AND l_child_ne_rec.rel_mandatory   = 'N'
             AND l_child_ne_rec.itg_relation    = nm3invval.c_derived_relation 
             THEN
                 UPDATE nm_inv_item_groupings
                 SET    iig_end_date = p_effective_date
                 WHERE  iig_item_id  = l_child_ne_rec.iit_ne_id ;
             ELSIF l_child_ne_rec.child_location  = 'N'
             AND   l_child_ne_rec.rel_mandatory   = 'N'
             AND   l_child_ne_rec.itg_relation    = nm3invval.c_in_relation
             THEN
                 UPDATE nm_members
                 SET    nm_end_date = p_effective_date
                 WHERE  nm_ne_id_in  = l_child_ne_rec.iit_ne_id ;
             ELSIF l_child_ne_rec.child_location  = 'Y'
             AND   l_child_ne_rec.rel_mandatory   = 'N'
             THEN
                 UPDATE nm_inv_item_groupings
                 SET    iig_end_date = p_effective_date
                 WHERE  iig_item_id  = l_child_ne_rec.iit_ne_id ;
             ELSIF l_child_ne_rec.child_location  = 'N'
             AND   l_child_ne_rec.rel_mandatory   = 'Y'
             THEN
                 UPDATE nm_members
                 SET    nm_end_date = p_effective_date
                 WHERE  nm_ne_id_in  = l_child_ne_rec.iit_ne_id ;
             ELSE
                 g_homo_exc_code   := -20511;
                 g_homo_exc_msg    := 'Cannot locate Child Asset outside the bounds of Parent Location';
                 RAISE g_homo_exception;
             END IF ;

         END IF ;
      END ;
   END LOOP ;
   l_child_ne_tab.delete ;
   DECLARE
      l_par_iit_rec nm_inv_items%ROWTYPE ;
   BEGIN
      FOR i in 1..l_par_iit_tab.count
      LOOP
          l_par_iit_rec  := l_par_iit_tab(i);
          FOR j IN (SELECT  DISTINCT iit_ne_id 
                    FROM    nm_inv_items iit
                           ,nm_members nm
                    WHERE   iit.iit_ne_id = nm.nm_ne_id_in 
                    AND     nm.nm_ne_id_of IN (SELECT nm_ne_id_of 
                                               FROM    nm_members 
                                               WHERE   nm_ne_id_in = l_par_iit_rec.iit_ne_id)        
                    AND     EXISTS (SELECT 'x' 
                                    FROM   nm_inv_type_groupings 
                                    WHERE  itg_parent_inv_type = l_par_iit_rec.iit_inv_type  
                                    AND    itg_inv_type = iit.iit_inv_type 
                                    AND    ((itg_relation = nm3invval.c_derived_relation)
                                            OR 
                                           (itg_relation = nm3invval.c_in_relation
                                           AND 'Y' IN  (SELECT nin_loc_mandatory FROM nm_inv_nw WHERE nin_nit_inv_code = iit.iit_inv_type  ))
                                           )
                                   )
                    AND   NOT EXISTS (SELECT 'x' FROM nm_inv_item_groupings WHERE iig_item_ID = iit.iit_ne_id)
                    )      
          LOOP
              DECLARE
              --
                 l_ne_id Number  ;
              BEGIN
                 --  
                 SELECT ne_id INTO l_ne_id
                 FROM
                     (SELECT x.pl_ne_id ne_id
                      from  table( NM3PLA.SUBTRACT_PL_FROM_PL( NM3PLA.GET_PLACEMENT_FROM_NE( j.iit_ne_id ), NM3PLA.GET_PLACEMENT_FROM_NE( l_par_iit_rec.iit_ne_id )).npa_placement_array) x
                      )
                 WHERE ne_id IS NOT NULL;   
                 --               
              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                      DECLARE
                         --
                         l_iig_rec     nm_inv_item_groupings%ROWTYPE ;
                         CURSOR  c_parent IS
                         SELECT  iig_parent_id ,
                                 iit.iit_inv_type 
                         FROM    nm_inv_item_groupings iig,
                                 nm_inv_items          iit
                         WHERE   iig_item_id   =   l_child_ne_rec.iit_ne_id
                         AND     iig_parent_id = iit.iit_ne_id ;
                         l_rec  c_parent%ROWTYPE ; 
                         --
                      BEGIN
                         --
                         OPEN   c_parent;
                         FETCH  c_parent INTO l_rec ;
                         CLOSE  c_parent;                       
                         --
                         l_iig_rec.iig_top_id     := nm3invval.get_iig_top_id(l_par_iit_rec.iit_ne_id) ;
                         l_iig_rec.iig_item_id    := j.iit_ne_id ;
                         l_iig_rec.iig_parent_id  := l_par_iit_rec.iit_ne_id ;
                         l_iig_rec.iig_start_date := p_effective_date ;                                            
                         BEGIN
                            nm3ins.ins_iig(l_iig_rec);                  
                         EXCEPTION
                             WHEN dup_val_on_index
                             THEN
                                 UPDATE nm_inv_item_groupings_all
                                 SET    iig_end_date = NULL
                                 WHERE  iig_item_id    = j.iit_ne_id
                                 AND    iig_parent_id  = l_par_iit_rec.iit_ne_id
                                 AND    iig_start_date = p_effective_date ;
                         END ;
                         --
                      END ;
              END ;
          END LOOP;      
      END LOOP;
   END  ;
   l_par_iit_tab.delete ;
   -- LOG 713421

--
   IF  l_rec_nit.nit_contiguous        = 'Y'
    OR l_rec_nit.nit_multiple_allowed != 'Y'
    THEN
   -- nm_debug.debug('Check contig and multi_allowed');
      -- ##########################################################################################
      --  If this inv_type is contiguous then return
      --   warning if there are any resultant"holes"
      --   in the affected sections
      --  Also check multiple_allowed
      -- ##########################################################################################
      DECLARE
--
         CURSOR cs_elements (p_job_id NUMBER) IS
         SELECT ne_id
               ,ne_length
               ,ne_unique
          FROM  NM_ELEMENTS
         WHERE  ne_id IN (SELECT nte_ne_id_of
                           FROM  NM_NW_TEMP_EXTENTS
                          WHERE  nte_job_id = l_remnant_job_id
                         );
--
         CURSOR cs_members (p_ne_id_of   NUMBER
                           ,cp_iit_ne_id NUMBER
                           ,p_inv_type   VARCHAR2
                           ) IS
         SELECT nm_begin_mp
               ,nm_end_mp
          FROM  NM_MEMBERS
         WHERE  nm_ne_id_of                   = p_ne_id_of
          AND   nm_ne_id_in                   = cp_iit_ne_id
          AND   nm_obj_type||NULL             = p_inv_type
         ORDER BY nm_begin_mp;
--
         l_been_into_loop BOOLEAN;
--
         l_placement_arr  NM_PLACEMENT_ARRAY;
         l_pl             NM_PLACEMENT;
--
      BEGIN
--
         FOR cs_rec IN cs_elements(l_remnant_job_id)
          LOOP
--
            -- Initialise variables
            l_been_into_loop := FALSE;
            l_placement_arr  := nm3pla.initialise_placement_array;
--
            FOR cs_mem IN cs_members (cs_rec.ne_id
                                     ,l_rec_iit.iit_ne_id 
                                     ,l_rec_iit.iit_inv_type)
             LOOP
               --
               l_pl := l_placement_arr.npa_placement_array(l_placement_arr.npa_placement_array.COUNT);
               --
               -- If it's non-exclusive, but is contiguous make sure there are no overlaps
               IF   l_rec_nit.nit_exclusive  = 'N'
                AND l_rec_nit.nit_contiguous = 'Y'
                THEN
                  --
                  -- On exclusive inv_types there will be no overlaps because they'll have been taken care
                  --  of above (in the membership sorting of the old stuff)
                  IF   cs_mem.nm_begin_mp > l_pl.pl_start
                   AND cs_mem.nm_begin_mp < l_pl.pl_end
                   THEN
                     g_homo_exc_code := -20514;
                     g_homo_exc_msg  := 'Overlaps not allowed on inventory types which are marked as contiguous';
                     RAISE g_homo_exception;
                  END IF;
               END IF;
               --
               l_been_into_loop := TRUE;
               --
               l_placement_arr := l_placement_arr.add_element(pl_ne_id   => cs_rec.ne_id
                                                             ,pl_start   => cs_mem.nm_begin_mp
                                                             ,pl_end     => cs_mem.nm_end_mp
                                                             ,pl_measure => 0
                                                             ,pl_mrg_mem => TRUE
                                                             );
               --
            END LOOP; -- cs_mem
--
            -- Because when we added the members to the placement array
            --  we specfied that we wanted to merge contiguous elements
            --  if there is only 1 element then this is the a single bit, but not necessarily the whole section
            IF l_rec_nit.nit_contiguous = 'Y'
             THEN
               IF  l_placement_arr.npa_placement_array.COUNT        > 1
                OR l_placement_arr.npa_placement_array(1).pl_start != 0
                OR l_placement_arr.npa_placement_array(1).pl_end   != cs_rec.ne_length
                THEN
                  p_warning_code := c_contiguous_warning_code;
                  p_warning_msg  := p_warning_msg||','||cs_rec.ne_unique;
               END IF;
            END IF;
--
         END LOOP; -- cs_elements
--
      END;
   END IF;
--
   -- Check to make sure we've not left any dependent data invalid
   IF   l_inv_orig_location.placement_count > 0
    AND c_xattr_status
    THEN
      DECLARE
         l_pl_end_dated_portion NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
      BEGIN
         l_pl_end_dated_portion := nm3pla.subtract_pl_from_pl
                                              (p_pl_main      => l_inv_orig_location
                                              ,p_pl_to_remove => l_new_inv_location
                                              );
         IF l_pl_end_dated_portion.placement_count > 0
          THEN
            -- Call XITEM validation checker
            nm3inv_xattr.x_item_check_pl (pi_obj_type    => l_rec_iit.iit_inv_type
                                         ,pi_nm_ne_id_in => l_rec_iit.iit_ne_id
                                         ,pi_pl          => l_pl_end_dated_portion
                                         );
         END IF;
      END;
   END IF;
--
   reset_for_return;
--
   nm_debug.proc_end(g_package_name, 'homo_update');
--
EXCEPTION
--
   WHEN g_homo_exception
    THEN
      --
      reset_for_return;
      RAISE_APPLICATION_ERROR(g_homo_exc_code, g_homo_exc_msg);
   WHEN OTHERS
    THEN
      --
      reset_for_return;
      RAISE;
--
END homo_update_old;
--
-----------------------------------------------------------------------------
--
FUNCTION create_duplicate_nte(pi_nte_id in nm_nw_temp_extents.nte_job_id%type
                             ) RETURN nm_nw_temp_extents.nte_job_id%type IS

  l_retval nm_nw_temp_extents.nte_job_id%type := nm3net.get_next_nte_id;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_duplicate_nte');

  INSERT INTO NM_NW_TEMP_EXTENTS
          (nte_job_id
          ,nte_ne_id_of
          ,nte_begin_mp
          ,nte_end_mp
          ,nte_cardinality
          ,nte_seq_no
          ,nte_route_ne_id
          )
   SELECT  l_retval nte_job_id
          ,nte_ne_id_of
          ,nte_begin_mp
          ,nte_end_mp
          ,nte_cardinality
          ,nte_seq_no
          ,nte_route_ne_id
    FROM   NM_NW_TEMP_EXTENTS
   WHERE   nte_job_id = pi_nte_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_duplicate_nte');

  RETURN l_retval;

END create_duplicate_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION move_edited_datums_to_new_nte(pi_nte_id in nm_nw_temp_extents.nte_job_id%type
                                      ) RETURN nm_nw_temp_extents.nte_job_id%type IS

  c_nte_id_for_edited_datums CONSTANT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE := nm3net.get_next_nte_id;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'move_edited_datums_to_new_nte');

  update
    nm_nw_temp_extents nte
  set
    nte.nte_job_id = c_nte_id_for_edited_datums
  where
    nte.nte_job_id = pi_nte_id
  and
    exists (select
              1
            from
              nm_element_history neh
            where
              nte.nte_ne_id_of = neh.neh_ne_id_old
            and
              neh.neh_operation in (nm3net_history.c_neh_op_split
                                   ,nm3net_history.c_neh_op_merge
                                   ,nm3net_history.c_neh_op_replace
                                   ,nm3net_history.c_neh_op_close
                                   ,nm3net_history.c_neh_op_reclassify
                                   ,nm3net_history.c_neh_op_reverse));

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'move_edited_datums_to_new_nte');

  RETURN c_nte_id_for_edited_datums;

END move_edited_datums_to_new_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE lock_datums_membs_for_nte(pi_nte_job_id in NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                   ) IS

  CURSOR cs_nte_ele (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT ne.ROWID ne_rowid
       FROM  nm_elements_all    ne
            ,(SELECT nte.nte_ne_id_of -- get the distinct list of NE_IDs
               FROM  nm_nw_temp_extents nte
              WHERE  nte_job_id   = c_nte_job_id
              GROUP BY nte.nte_ne_id_of
             )
      WHERE  nte_ne_id_of = ne_id
      FOR UPDATE OF ne_date_modified NOWAIT;
      --
      CURSOR cs_nte_nm (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT /*+ INDEX (nm nm_ne_id_of_ind) */ nm.ROWID nm_rowid
       FROM  nm_members         nm
            ,(SELECT nte.nte_ne_id_of -- get the distinct list of NE_IDs
               FROM  nm_nw_temp_extents nte
              WHERE  nte_job_id   = c_nte_job_id
              GROUP BY nte.nte_ne_id_of
             )
      WHERE  nte_ne_id_of = nm.nm_ne_id_of
       AND   nm.nm_type   = 'G'
      FOR UPDATE OF nm_date_modified NOWAIT;
      --
      l_tab_ne_rowid nm3type.tab_rowid;
      l_tab_nm_rowid nm3type.tab_rowid;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'lock_datums_membs_for_nte');

  OPEN  cs_nte_ele (pi_nte_job_id);
      FETCH cs_nte_ele
       BULK COLLECT
       INTO l_tab_ne_rowid;
      CLOSE cs_nte_ele;
      --
      IF nm3ausec.get_status = nm3type.c_off
       THEN
         --
         -- JM - 25/03/03
         -- If AU Security is switched OFF then we are assuming (as other code does)
         --  that whatever is happening is "trusted". Therefore if the operation is "trusted"
         --  then the assumption may be made that the operation is running on an isolated
         --  database so we don't need to lock ALL the records up - this takes quite a
         --  long time to lock the members which becomes VERY noticible when running in
         --  batch mode (i.e. from the CSV loader), so we will just lock the element
         --  records - this would stop an "untrusted" homo running on the same element
         --
         Null;
      ELSE
--
--       Lock up any GROUP membership records
--        on which we are locating inventory.
--       This will prevent people rescaling etc when we are locating
--        (undesirable because we may well be locating by Route/SLK),
--        but it's not going to try and lock up all the inventory members
--        which will (and does!) take an age
--       This means that we do not NEED to switch off AUSEC in order to get the
--        majority of the performance benefit - good for bulk loading when the AU
--        is to be policed
--
         OPEN  cs_nte_nm (pi_nte_job_id);
         FETCH cs_nte_nm
          BULK COLLECT
          INTO l_tab_nm_rowid;
         CLOSE cs_nte_nm;
--      nm3extent.lock_temp_extent_datums(l_remnant_job_id);
      END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'lock_datums_membs_for_nte');

END lock_datums_membs_for_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_existing_locations(pi_iit_ne_id                 in nm_inv_items.iit_ne_id%type
                                     ,pi_effective_date            in date
                                     ,pi_nte_id_for_unchanged_locs in NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                     ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'end_date_existing_locations');

  xattr_off;
  
  UPDATE NM_MEMBERS nm
   SET   nm.nm_end_date = pi_effective_date
  WHERE  nm.nm_ne_id_in = pi_iit_ne_id
   AND NOT EXISTS (SELECT 1
                    FROM  NM_NW_TEMP_EXTENTS nte
                   WHERE  nte.nte_job_id   = pi_nte_id_for_unchanged_locs
                    AND   nte.nte_ne_id_of = nm.nm_ne_id_of
                    AND   nte.nte_begin_mp = nm.nm_begin_mp
                    AND   nte.nte_end_mp   = nm.nm_end_mp
                  );
  
  xattr_on;
  
  nm3extent.g_combine_temp_ne_called := FALSE;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'end_date_existing_locations');

END end_date_existing_locations;
--
-----------------------------------------------------------------------------
--
PROCEDURE replace_exclusive(pi_nit_rec        in nm_inv_types%rowtype
                           ,pi_iit_rec        in nm_inv_items%rowtype
                           ,pi_effective_date in date
                           ,pi_nte_job_id     in nm_nw_temp_extents.nte_job_id%type
                           ,pio_iit_ne_id_arr in out nocopy nm3type.tab_number
                           )  IS

  l_not_correct_xsp EXCEPTION;
  
  CURSOR cs_affected_inv
                (p_nte_job_id NUMBER
                ,p_inv_type   VARCHAR2
                ,p_iit_ne_id  NUMBER
                ) IS
   SELECT DISTINCT nm.*
    FROM  NM_MEMBERS          nm
         ,NM_NW_TEMP_EXTENTS  nte
   WHERE  nte.nte_job_id       = p_nte_job_id
    AND   nte.nte_ne_id_of     = nm.nm_ne_id_of
    AND   nte.nte_begin_mp     < nm.nm_end_mp
    AND   nte.nte_end_mp       > nm.nm_begin_mp
    AND   nm.nm_type           = 'I'
    AND   nm.nm_obj_type       = p_inv_type
    AND   nm.nm_ne_id_in      != p_iit_ne_id;

  CURSOR cs_lock (p_ne_id_in   NUMBER
                  ,p_ne_id_of   NUMBER
                  ,p_begin_mp   NUMBER
                  ,p_start_date DATE
                  ) IS
   SELECT ROWID mem_rowid
    FROM  NM_MEMBERS
   WHERE  nm_ne_id_in   = p_ne_id_in
    AND   nm_ne_id_of   = p_ne_id_of
    AND   nm_begin_mp   = p_begin_mp
    AND   nm_start_date = p_start_date
   FOR UPDATE OF nm_end_date NOWAIT;

  CURSOR cs_affected_point
                (p_nte_job_id NUMBER
                ,p_inv_type   VARCHAR2
                ,p_iit_ne_id  NUMBER
                ) IS
   SELECT DISTINCT nm.*
    FROM  NM_MEMBERS         nm
         ,NM_NW_TEMP_EXTENTS nte
   WHERE  nte.nte_job_id        = p_nte_job_id
    AND   nte.nte_ne_id_of      = nm.nm_ne_id_of
    AND   nte.nte_begin_mp      = nm.nm_begin_mp
    AND   nte.nte_end_mp        = nm.nm_end_mp
    AND   nm.nm_type            = 'I'
    AND   nm.nm_obj_type        = p_inv_type
    AND   nm.nm_ne_id_in       != p_iit_ne_id;

  l_mem_rowid ROWID;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'replace_exclusive');

--  #############################################################################
--   Replace existing inventory
--    Existing membership by existing membership
--  #############################################################################
-- nm_debug.debug('Replace existing inventory');
--
   IF pi_nit_rec.nit_exclusive = 'Y'
    THEN
      IF pi_nit_rec.nit_pnt_or_cont = 'C'
       THEN
         FOR cs_rec IN cs_affected_inv (pi_nte_job_id, pi_iit_rec.iit_inv_type, pi_iit_rec.iit_ne_id)
          LOOP -- This cursor returns affected membership records, independent of XSP
               -- The records with the "wrong" XSP are ignored
   --
            DECLARE
      --
               l_new_nm_reqd nm3type.tab_rec_nm;
               l_placed_begin_mp nm3type.tab_number;
               l_placed_end_mp   nm3type.tab_number;
      --
               c_orig_rec_nm CONSTANT NM_MEMBERS%ROWTYPE := cs_rec;
               l_mp              nm3type.tab_number;
      --
               l_placement_arr   NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
               l_member_arr      NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
               l_tab_dont_do     nm3type.tab_number;
   --
               l_pl_pos NUMBER;
      --
            BEGIN
      --
               IF is_affected_by_exclusivity (p_iit_ne_id => cs_rec.nm_ne_id_in
                                             ,p_rec_iit   => pi_iit_rec
                                             ,p_exclusive => (pi_nit_rec.nit_exclusive         = 'Y')
                                             ,p_x_sect    => (pi_nit_rec.nit_x_sect_allow_flag = 'Y')
                                             )
                THEN
                  NULL;
               ELSE
                  RAISE l_not_correct_xsp;
               END IF;
--               IF l_rec_iit.iit_x_sect IS NOT NULL
--                THEN
--                  -- Check the XSP to make sure we're interested
--                  OPEN  cs_xsp (cs_rec.nm_ne_id_in);
--                  FETCH cs_xsp INTO l_xsp;
--                  CLOSE cs_xsp;
--                  IF l_xsp != l_rec_iit.iit_x_sect
--                   THEN
--                     RAISE l_not_correct_xsp;
--                  END IF;
--               END IF;
            --
      --
            -- nm_debug.debug('Original');
            -- nm_debug.debug(cs_rec.nm_ne_id_in||':'||cs_rec.nm_ne_id_of||':'||cs_rec.nm_begin_mp||':'||cs_rec.nm_end_mp);
   --
               OPEN  cs_lock (cs_rec.nm_ne_id_in
                             ,cs_rec.nm_ne_id_of
                             ,cs_rec.nm_begin_mp
                             ,cs_rec.nm_start_date
                             );
               FETCH cs_lock INTO l_mem_rowid;
               CLOSE cs_lock;
   --
               xattr_off;
               UPDATE NM_MEMBERS
                SET   nm_end_date = pi_effective_date
               WHERE  ROWID       = l_mem_rowid;
               xattr_on;
   --
               -- Deal with any hierarchical children
               deal_with_hierarchical (p_ne_id          => cs_rec.nm_ne_id_in
                                      ,p_effective_date => pi_effective_date
                                      );
   --
   --
               -- Record this iit_ne_id as having had it's location changed
               pio_iit_ne_id_arr(pio_iit_ne_id_arr.COUNT+1) := cs_rec.nm_ne_id_in;
   --
               -- Get all of the MPs for this NE_ID_OF
               FOR cs_mp IN (SELECT nte_begin_mp mp
                              FROM  NM_NW_TEMP_EXTENTS
                             WHERE  nte_job_id   = pi_nte_job_id
                              AND   nte_ne_id_of = cs_rec.nm_ne_id_of
                             UNION
                             SELECT nte_end_mp mp
                              FROM  NM_NW_TEMP_EXTENTS
                             WHERE  nte_job_id   = pi_nte_job_id
                              AND   nte_ne_id_of = cs_rec.nm_ne_id_of
                             UNION
                             SELECT cs_rec.nm_begin_mp mp
                              FROM  dual
                             UNION
                             SELECT cs_rec.nm_end_mp mp
                              FROM  dual
                            )
                LOOP
                  l_mp(l_mp.COUNT+1) := cs_mp.mp;
               END LOOP;
            -- nm_debug.debug('Potential chunks');
               -- Assemble the MPs into potential chunks
               FOR l_count IN 1..l_mp.COUNT-1
                LOOP
                  l_placement_arr := l_placement_arr.add_element(pl_ne_id   => cs_rec.nm_ne_id_of
                                                                ,pl_start   => l_mp(l_count)
                                                                ,pl_end     => l_mp(l_count+1)
                                                                ,pl_measure => 0
                                                                ,pl_mrg_mem => FALSE
                                                                );
                  l_placed_begin_mp(l_count) := l_mp(l_count);
                  l_placed_end_mp(l_count)   := l_mp(l_count+1);
                -- nm_debug.debug(l_mp(l_count)||':'||l_mp(l_count+1));
               END LOOP;
   --
   --            nm3pla.dump_placement_array(l_placement_arr);
   --
               -- Mark any of those potential chunks as not to be reused if they are the location of the new item
               l_pl_pos := 1;
               FOR cs_placed IN (SELECT nte_begin_mp
                                       ,nte_end_mp
                                  FROM  NM_NW_TEMP_EXTENTS
                                 WHERE  nte_job_id   = pi_nte_job_id
                                  AND   nte_ne_id_of = cs_rec.nm_ne_id_of
                                 ORDER BY nte_begin_mp
                                )
                LOOP
                 -- nm_debug.debug('running thro '||cs_placed.nte_begin_mp||':'||cs_placed.nte_end_mp);
                  IF l_placement_arr.npa_placement_array(l_pl_pos).pl_start = cs_placed.nte_begin_mp
                   THEN
                  -- nm_debug.debug('S Dont do '||l_placement_arr.npa_placement_array(l_pl_pos).pl_start||':'||l_placement_arr.npa_placement_array(l_pl_pos).pl_end);
                     l_tab_dont_do(l_pl_pos) := l_pl_pos;
                  ELSE
                     l_pl_pos := l_pl_pos+1;
                  END IF;
                  LOOP
                    EXIT WHEN l_placement_arr.npa_placement_array(l_pl_pos).pl_start >= cs_placed.nte_begin_mp;
                    l_pl_pos := l_pl_pos+1;
                  END LOOP;
                  LOOP
                     IF l_placement_arr.npa_placement_array(l_pl_pos).pl_end <= cs_placed.nte_end_mp
                      THEN
                        l_tab_dont_do(l_pl_pos) := l_pl_pos;
                     -- nm_debug.debug('E Dont do '||l_placement_arr.npa_placement_array(l_pl_pos).pl_start||':'||l_placement_arr.npa_placement_array(l_pl_pos).pl_end);
                        IF l_placement_arr.npa_placement_array(l_pl_pos).pl_end = cs_placed.nte_end_mp
                         THEN
                           EXIT;
                        END IF;
                        l_pl_pos := l_pl_pos+1;
                     ELSE
                        EXIT;
                     END IF;
                  END LOOP;
               END LOOP;
   --
               -- Re-create any of the location records for existing inventory on this ne_id_of
               FOR l_count IN 1..l_placement_arr.npa_placement_array.COUNT
                LOOP
                  IF NOT l_tab_dont_do.EXISTS(l_count)
                   THEN
                     DECLARE
                        l_pl NM_PLACEMENT := l_placement_arr.npa_placement_array(l_count);
                     BEGIN
                        l_member_arr := l_member_arr.add_element(pl_ne_id   => l_pl.pl_ne_id
                                                                ,pl_start   => l_pl.pl_start
                                                                ,pl_end     => l_pl.pl_end
                                                                ,pl_measure => 0
                                                                ,pl_mrg_mem => FALSE
                                                                );
                     END;
                  END IF;
               END LOOP;
--             nm_debug.debug('Inserting replacements');
--             nm3pla.dump_placement_array(l_member_arr);
               IF NOT l_member_arr.is_empty
                THEN
                  FOR l_count IN 1..l_member_arr.npa_placement_array.COUNT
                   LOOP
                     DECLARE
                        l_pl     NM_PLACEMENT := l_member_arr.npa_placement_array(l_count);
                        l_rec_nm NM_MEMBERS%ROWTYPE := cs_rec;
                        l_rec_chi_nm NM_MEMBERS%ROWTYPE ;
                        --Log 713412:Linesh:Start
                        --Added Following to move the Subordinate Asset Location to that of the Parent
                        CURSOR  c_child_nm(qp_nm_ne_id_in nm_members.nm_ne_id_in%TYPE)
                        IS
                        SELECT Distinct nm_ne_id_in   
                                       ,Null nm_ne_id_of   
                                       ,nm_type  
                                       ,nm_obj_type   
                                       ,Null nm_begin_mp   
                                       ,Null nm_start_date   
                                       ,Null nm_end_date   
                                       ,Null nm_end_mp  
                                       ,Null nm_slk   
                                       ,Null nm_cardinality   
                                       ,Null nm_admin_unit   
                                       ,Null nm_date_created   
                                       ,Null nm_date_modified   
                                       ,Null nm_modified_by   
                                       ,Null nm_created_by   
                                       ,Null nm_seq_no     
                                       ,Null nm_seg_no   
                                       ,Null nm_true   
                                       ,Null nm_end_slk   
                                       ,Null nm_end_true
                        FROM   nm_members_all nm
                        WHERE  nm_ne_id_in IN (SELECT  iit.iit_ne_id
                                               FROM    NM_INV_ITEMS iit
                                                      ,NM_INV_ITEMS iit_p
                                                      ,NM_INV_TYPE_GROUPINGS
                                                      ,NM_INV_ITEM_GROUPINGS
                                               WHERE  iit.iit_ne_id IN (SELECT iig_item_id
                                                                        FROM   NM_INV_ITEM_GROUPINGS
                                                                        START WITH iig_parent_id = qp_nm_ne_id_in
                                                                        CONNECT BY iig_parent_id = PRIOR iig_item_id
                                                                        )
                                               AND   iig_parent_id      = iit_p.iit_ne_id
                                               AND   iig_item_id        = iit.iit_ne_id
                                               AND   iit.iit_inv_type   = itg_inv_type
                                               AND   itg_relation       = 'AT'                --LOG 713421
                                               AND   iit_p.iit_inv_type = itg_parent_inv_type
                                               ) 
                        AND    nm_type = 'I'       ;                     
                        l_child_nm_rec NM_MEMBERS%ROWTYPE  ;
                        --Log 713412:Linesh:End
                     BEGIN
                        l_rec_nm.nm_begin_mp   := l_pl.pl_start;
                        l_rec_nm.nm_end_mp     := l_pl.pl_end;
                        l_rec_nm.nm_start_date := pi_effective_date;
--                      nm_debug.debug('IN : '||l_rec_nm.nm_ne_id_in||' : OF : '||l_rec_nm.nm_ne_id_of||' : BEGIN : '||l_rec_nm.nm_begin_mp||' : END : '||l_rec_nm.nm_end_mp);
                        xattr_off;
                        nm3net.ins_nm(l_rec_nm);
                        xattr_on;
                        --Log 713412:Linesh:Start
                        xattr_off;
                        Open c_child_nm(l_rec_nm.nm_ne_id_in) ;
                        Loop
                             Fetch c_child_nm INTO l_child_nm_rec ;
                             EXIT WHEN c_child_nm%NOTFOUND;
                             l_rec_chi_nm             := l_rec_nm ;
                             l_rec_chi_nm.nm_ne_id_in := l_child_nm_rec.nm_ne_id_in ;
                             l_rec_chi_nm.nm_type     := l_child_nm_rec.nm_type ;    
                             l_rec_chi_nm.nm_obj_type := l_child_nm_rec.nm_obj_type ;
                             nm3net.ins_nm(l_rec_nm);
                        End Loop ;
                        Close c_child_nm ;            
                        xattr_on;                        
                        --Log 713412:Linesh:End
                     EXCEPTION
                        WHEN DUP_VAL_ON_INDEX
                         THEN
                             --Log 713412:Linesh:Start
                             hig.raise_ner(pi_appl               => 'NET'
                                          ,pi_id                 => 104
                                          ,pi_supplementary_info => Null);
                             --xattr_off;
                             --UPDATE NM_MEMBERS_ALL
                             --SET   nm_end_date = l_rec_nm.nm_end_date
                             --    ,nm_end_mp   = l_rec_nm.nm_end_mp
                             --WHERE  ROWID       = l_mem_rowid;
                             --xattr_on;
                             --Log 713412:Linesh:End
--                           g_homo_exc_code := -20516;
--                           g_homo_exc_msg  := 'Inventory Locations already exist for affected inventory at this point with this start date';
--                           RAISE g_homo_exception;
                     END;
                  END LOOP;
               END IF;
   --
            EXCEPTION
               WHEN l_not_correct_xsp
                THEN
                  NULL;
            END;
         END LOOP;
      ELSE -- This is a POINT item
         FOR cs_rec IN cs_affected_point (pi_nte_job_id, pi_iit_rec.iit_inv_type, pi_iit_rec.iit_ne_id)
          LOOP
      --
            BEGIN
               IF is_affected_by_exclusivity (p_iit_ne_id => cs_rec.nm_ne_id_in
                                             ,p_rec_iit   => pi_iit_rec
                                             ,p_exclusive => (pi_nit_rec.nit_exclusive         = 'Y')
                                             ,p_x_sect    => (pi_nit_rec.nit_x_sect_allow_flag = 'Y')
                                             )
                THEN
                  NULL;
               ELSE
                  RAISE l_not_correct_xsp;
               END IF;
--               IF l_rec_iit.iit_x_sect IS NOT NULL
--                THEN
--                  -- Check the XSP to make sure we're interested
--                  OPEN  cs_xsp (cs_rec.nm_ne_id_in);
--                  FETCH cs_xsp INTO l_xsp;
--                  CLOSE cs_xsp;
--                  IF l_xsp != l_rec_iit.iit_x_sect
--                   THEN
--                     RAISE l_not_correct_xsp;
--                  END IF;
--               END IF;
            --
               OPEN  cs_lock (cs_rec.nm_ne_id_in
                             ,cs_rec.nm_ne_id_of
                             ,cs_rec.nm_begin_mp
                             ,cs_rec.nm_start_date
                             );
               FETCH cs_lock INTO l_mem_rowid;
               CLOSE cs_lock;
   --
               xattr_off;
               UPDATE NM_MEMBERS
                SET   nm_end_date = pi_effective_date
               WHERE  ROWID       = l_mem_rowid;
               xattr_on;
   --
               -- Record this iit_ne_id as having had it's location changed
               pio_iit_ne_id_arr(pio_iit_ne_id_arr.COUNT+1) := cs_rec.nm_ne_id_in;
   --
            EXCEPTION
               WHEN l_not_correct_xsp
                THEN
                  NULL;
            END;
   --
         END LOOP;
      END IF;
--
   END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'replace_exclusive');

END replace_exclusive;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_pl_to_nte(pi_pl         IN nm_placement 
                       ,pi_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                       ) IS

  l_nte_rec nm_nw_temp_extents%ROWTYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'add_pl_to_nte');

  l_nte_rec.nte_job_id   := pi_nte_job_id;
  l_nte_rec.nte_ne_id_of := pi_pl.pl_ne_id;
  l_nte_rec.nte_begin_mp := pi_pl.pl_start;
  l_nte_rec.nte_end_mp   := pi_pl.pl_end;
  
  nm3extent.ins_nte(p_rec_nte => l_nte_rec);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'add_pl_to_nte');

END add_pl_to_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_chunk_to_array(pi_begin_mp   in            nm_members.nm_begin_mp%type
                            ,pi_end_mp     IN            nm_members.nm_end_mp%TYPE
                            ,pio_chunk_arr in out nocopy t_chunk_arr
                            ) IS

  c_idx constant pls_integer := pio_chunk_arr.count + 1;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'add_chunk_to_array');

  pio_chunk_arr(c_idx).begin_mp := pi_begin_mp;
  pio_chunk_arr(c_idx).end_mp := pi_end_mp;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'add_chunk_to_array');

END add_chunk_to_array;
--
-----------------------------------------------------------------------------
--
FUNCTION get_unprocessed_chunks(pi_ne_id      in nm_elements.ne_id%type
                               ,pi_begin_mp   IN nm_members.nm_begin_mp%TYPE
                               ,pi_end_mp     IN nm_members.nm_end_mp%TYPE
                               ,pi_chunk_arr  IN t_chunk_arr
                               ) RETURN nm_placement_array IS

  l_pl_arr nm_placement_array := nm3pla.initialise_placement_array(pi_ne_id => pi_ne_id
                                                                  ,pi_start => pi_begin_mp
                                                                  ,pi_end   => pi_end_mp);

  l_pl nm_placement;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_unprocessed_chunks');

  for i in 1..pi_chunk_arr.count
  loop
    IF   (pi_begin_mp >= pi_chunk_arr(i).begin_mp
          AND pi_begin_mp < pi_chunk_arr(i).end_mp)
      OR (pi_end_mp > pi_chunk_arr(i).begin_mp
          AND pi_end_mp <= pi_chunk_arr(i).end_mp)
    then
      --overlap
      
      if (pi_begin_mp between pi_chunk_arr(i).begin_mp and pi_chunk_arr(i).end_mp
          and pi_end_mp BETWEEN pi_chunk_arr(i).begin_mp AND pi_chunk_arr(i).end_mp)
      then
        --enitre chunk already processed
        l_pl_arr := nm3pla.initialise_placement_array;
        exit;
      end if;
    
      l_pl_arr := nm3pla.remove_pl_from_pl_arr(pi_pl_arr => l_pl_arr
                                              ,pi_pl     => l_pl);
      if l_pl_arr.placement_count = 0
      then
        --enitre chunk already processed
        EXIT;
      end if;
    end if;
  end loop;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_unprocessed_chunks');

  RETURN l_pl_arr;

END get_unprocessed_chunks;
--
-----------------------------------------------------------------------------
--
PROCEDURE cr8_mems_for_pl_arr(pi_pl_arr        IN nm_placement_array
                             ,pi_nm_rec        IN nm_members%ROWTYPE
                             ,pi_nte_for_chunk IN nm_nw_temp_extents.nte_job_id%TYPE DEFAULT NULL
                             ) IS

  l_pl nm_placement;

  l_nm_rec nm_members%ROWTYPE := pi_nm_rec;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'cr8_mems_for_pl_arr');

  db('cr8_mems_for_pl_arr');
  
  FOR i IN 1..pi_pl_arr.placement_count
  LOOP
    l_pl := pi_pl_arr.get_entry(i);
    
    l_nm_rec.nm_ne_id_of   := l_pl.pl_ne_id;
    l_nm_rec.nm_begin_mp   := l_pl.pl_start;
    l_nm_rec.nm_end_mp     := l_pl.pl_end;
          
    db('  inserting nm rec ' || l_nm_rec.nm_ne_id_of || ':' || l_pl.pl_start || ':' || l_pl.pl_end);
    nm3ins.ins_nm(p_rec_nm => l_nm_rec);

    IF pi_nte_for_chunk IS NOT NULL
    THEN
      db('  adding chunk to temp extent');
      add_pl_to_nte(pi_pl         => l_pl
                   ,pi_nte_job_id => pi_nte_for_chunk);
    END IF;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'cr8_mems_for_pl_arr');

END cr8_mems_for_pl_arr;
--
-----------------------------------------------------------------------------
--
FUNCTION cr8_mems_for_excl_affected(pi_pl      IN nm_placement
                                   ,pi_iit_rec IN nm_inv_items%ROWTYPE
                                   ,pi_nit_rec IN nm_inv_types%ROWTYPE
                                   ,pi_nm_rec  IN nm_members%ROWTYPE
                                   ) RETURN nm_placement_array IS

  l_pl_arr nm_placement_array := nm3pla.initialise_placement_array(pi_ne_id => pi_pl.pl_ne_id
                                                                  ,pi_start => pi_pl.pl_start
                                                                  ,pi_end   => pi_pl.pl_end);

  l_ne_id_in_arr   nm3type.tab_number;
  l_start_date_arr nm3type.tab_date;
  l_begin_mp_arr   nm3type.tab_number;
  l_end_mp_arr     nm3type.tab_number;
  
  l_nm_rec nm_members%ROWTYPE := pi_nm_rec;
  
  l_pl nm_placement := nm3pla.initialise_placement(pi_ne_id => pi_pl.pl_ne_id);
  
  l_unprocessed_pl_arr nm_placement_array := nm3pla.initialise_placement_array;
  
  l_chunk_arr t_chunk_arr; 

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'cr8_mems_for_excl_affected');

  db('*cr8_mems_for_excl_affected');
  
  l_nm_rec.nm_ne_id_of := pi_pl.pl_ne_id;
  
  IF pi_nit_rec.nit_pnt_or_cont = 'C'
  then
    --get all potentially exclusive inv chunks on this element
    SELECT
      nm.nm_ne_id_in,
      nm.nm_start_date,
      nm.nm_begin_mp,
      nm.nm_end_mp
    BULK COLLECT INTO
      l_ne_id_in_arr,
      l_start_date_arr,
      l_begin_mp_arr,
      l_end_mp_arr
    FROM
      nm_members_all nm
    WHERE
      nm.nm_ne_id_in <> pi_iit_rec.iit_ne_id
    AND
      nm.nm_ne_id_of = pi_pl.pl_ne_id
    AND
      nm.nm_type = 'I'
    AND
      nm.nm_obj_type = pi_nit_rec.nit_inv_type
    AND
      pi_pl.pl_start < nm.nm_end_mp
    AND
      pi_pl.pl_end > nm.nm_begin_mp
    and
      (nm.nm_end_date is NULL
       OR
       (nm.nm_end_date > pi_nm_rec.nm_start_date
        AND
        nm.nm_start_date <> nm.nm_end_date))
    order by
      nm.nm_start_date;
      
    db(' got ' ||  l_ne_id_in_arr.COUNT || ' potential exclusive conflicts');
      
    --go through chunks
    FOR i IN 1..l_ne_id_in_arr.COUNT
    LOOP
      db('processing asset ' || l_ne_id_in_arr(i) || ':' || l_begin_mp_arr(i) || ':' || l_end_mp_arr(i));
      IF is_affected_by_exclusivity(p_iit_ne_id => l_ne_id_in_arr(i)
                                   ,p_rec_iit   => pi_iit_rec
                                   ,p_exclusive => pi_nit_rec.nit_exclusive         = 'Y'
                                   ,p_x_sect    => pi_nit_rec.nit_x_sect_allow_flag = 'Y')
      THEN
        db('  affected');
        l_pl.pl_start := GREATEST(pi_pl.pl_start, l_begin_mp_arr(i));
        l_pl.pl_end   := LEAST(pi_pl.pl_end, l_end_mp_arr(i));
        
        db('  overlap - ' || l_pl.pl_start || ' to ' || l_pl.pl_end);
        
        --insert chunk of overlap with end date
        l_nm_rec.nm_begin_mp   := l_pl.pl_start;
        l_nm_rec.nm_end_mp     := l_pl.pl_end;
        l_nm_rec.nm_end_date   := l_start_date_arr(i);
        
        db('  start date= ' || to_char(l_nm_rec.nm_start_date, 'dd/mon/yyyy') || ' end date= ' || TO_CHAR(l_nm_rec.nm_end_date, 'dd/mon/yyyy'));
        
        if l_nm_rec.nm_start_date < l_nm_rec.nm_end_date 
        then
          --get all the bits that haven't already been processed
          l_unprocessed_pl_arr := get_unprocessed_chunks(pi_ne_id     => l_nm_rec.nm_ne_id_of
                                                        ,pi_begin_mp  => l_pl.pl_start
                                                        ,pi_end_mp    => l_pl.pl_end
                                                        ,pi_chunk_arr => l_chunk_arr);
          
          --create mems for all bits in overlap not already processed
          db('create mems for all bits in overlap not already processed');
          db('l_unprocessed_pl_arr:');
          nm3pla.dump_placement_array(p_pl_arr => l_unprocessed_pl_arr);
          cr8_mems_for_pl_arr(pi_pl_arr => l_unprocessed_pl_arr
                             ,pi_nm_rec => l_nm_rec);
          
  --        db('  inserting nm rec ' || l_nm_rec.nm_ne_id_of || ':' || l_pl.pl_start || ':' || l_pl.pl_end);
  --        nm3ins.ins_nm(p_rec_nm => l_nm_rec);
        end if;
        
        --record that we have processed this chunk
        db('record that we have processed this chunk');
        db('--' || l_nm_rec.nm_begin_mp || ' to' || l_nm_rec.nm_end_mp);
        add_chunk_to_array(pi_begin_mp   => l_nm_rec.nm_begin_mp
                          ,pi_end_mp     => l_nm_rec.nm_end_mp
                          ,pio_chunk_arr => l_chunk_arr);
        
        --remove overlap from pl_arr
        l_pl_arr := nm3pla.remove_pl_from_pl_arr(pi_pl_arr => l_pl_arr
                                                ,pi_pl     => l_pl);
        db('remove overlap from pl_arr');
        db('l_pl_arr with overlap removed:');
        nm3pla.dump_placement_array(p_pl_arr => l_pl_arr);
      END IF;
    END LOOP;
  else
    --point item
    --get all potentially exclusive inv chunks on this element
    SELECT
      nm.nm_ne_id_in,
      nm.nm_start_date,
      nm.nm_begin_mp,
      nm.nm_end_mp
    BULK COLLECT INTO
      l_ne_id_in_arr,
      l_start_date_arr,
      l_begin_mp_arr,
      l_end_mp_arr
    FROM
      nm_members_all nm
    WHERE
      nm.nm_ne_id_in <> pi_iit_rec.iit_ne_id
    AND
      nm.nm_ne_id_of = pi_pl.pl_ne_id
    AND
      nm.nm_type = 'I'
    AND
      nm.nm_obj_type = pi_nit_rec.nit_inv_type
    AND
      pi_pl.pl_start = nm.nm_end_mp
    AND
      pi_pl.pl_end = nm.nm_begin_mp
    and
      (nm.nm_end_date is NULL
       OR
       (nm.nm_end_date > pi_nm_rec.nm_start_date
        AND
        nm.nm_start_date <> nm.nm_end_date))
    ORDER BY
      nm.nm_start_date;
      
    db(' got ' ||  l_ne_id_in_arr.COUNT || ' potential exclusive conflicts');
      
    --go through chunks
    FOR i IN 1..l_ne_id_in_arr.COUNT
    LOOP
      db('processing asset ' || l_ne_id_in_arr(i) || ':' || l_begin_mp_arr(i) || ':' || l_end_mp_arr(i));
      IF is_affected_by_exclusivity(p_iit_ne_id => l_ne_id_in_arr(i)
                                   ,p_rec_iit   => pi_iit_rec
                                   ,p_exclusive => pi_nit_rec.nit_exclusive         = 'Y'
                                   ,p_x_sect    => pi_nit_rec.nit_x_sect_allow_flag = 'Y')
      THEN
        db('  affected');
        --insert chunk of overlap with end date
        l_nm_rec.nm_begin_mp   := pi_pl.pl_start;
        l_nm_rec.nm_end_mp     := pi_pl.pl_end;
        l_nm_rec.nm_end_date   := l_start_date_arr(i);
        
        db('creating member ' || l_nm_rec.nm_ne_id_of || ':' || pi_pl.pl_start || '->' || pi_pl.pl_end);
        nm3ins.ins_nm(p_rec_nm => l_nm_rec);
        
        --clear pl array as we have fully located this chunk
        l_pl_arr := nm3pla.initialise_placement_array;
        
        --this point is now located up to future exclusive item 
        --so dont need to do any more
        EXIT;
      END IF;
    end loop;
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'cr8_mems_for_excl_affected');

  RETURN l_pl_arr;

END cr8_mems_for_excl_affected;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_members(pi_nte_job_id     in nm_nw_temp_extents.nte_job_id%type
                        ,pi_iit_rec        in nm_inv_items%rowtype
                        ,pi_nit_rec        in nm_inv_types%rowtype
                        ,pi_effective_date in date
                        ,pi_ne_id_of       in nm_nw_temp_extents.nte_ne_id_of%type default null
                        ,pi_end_date       in date default null
                        ,pi_maintain_nte   in boolean default false
                        ) IS

  l_nm_seq_no NM_MEMBERS.nm_seq_no%TYPE;
      
--  CURSOR cs_nte (c_nte_job_id   NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
--                ,c_nte_ne_id_of nm_nw_temp_extents.nte_ne_id_of%type) IS
--  SELECT *
--   FROM  NM_NW_TEMP_EXTENTS
--  WHERE  nte_job_id = c_nte_job_id
--    and  c_nte_ne_id_of IS NULL
--         OR (nte_ne_id_of = c_nte_ne_id_of);
      
  l_rec_nm NM_MEMBERS%ROWTYPE;
  
  l_nm_end_date nm_members.nm_end_date%type;
  
  l_pl     nm_placement := nm3pla.initialise_placement;
  l_pl_arr nm_placement_array := nm3pla.initialise_placement_array;
  
  l_nte_to_maintain nm_nw_temp_extents.nte_job_id%TYPE;
  
  l_nte_arr nm3extent.tab_nte;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_members');

  db('create members');
  
--  if pi_maintain_nte
--  then
--    l_nte_to_maintain := pi_nte_job_id;
--  end if;
  
  if pi_end_date is not null
  then
    IF pi_iit_rec.iit_end_date is null
    then
      l_nm_end_date := pi_end_date;
    else
      l_nm_end_date := least(pi_end_date, pi_iit_rec.iit_end_date);
    end if;
  end if;
  
  SELECT *
  bulk collect into l_nte_arr
   FROM  nm_nw_temp_extents
  WHERE  nte_job_id = pi_nte_job_id
    AND  (pi_ne_id_of IS NULL
          OR nte_ne_id_of = pi_ne_id_of);
  
  db('checking nte before create members');
  
  nm3extent.debug_temp_extents(pi_nte_job_id);
  
  db('pi_end_date = ' || to_char(pi_end_date, 'DD-MON-YYYY'));
  db('c_nm_end_date = ' || to_char(l_nm_end_date, 'DD-MON-YYYY'));

  FOR i in 1..l_nte_arr.count
   LOOP
     db('loop count ' || i);
     db('nte rec ' || l_nte_arr(i).nte_ne_id_of || ':' || l_nte_arr(i).nte_begin_mp || ':' || l_nte_arr(i).nte_end_mp);
     
     l_nte_to_maintain := NULL;
     
     BEGIN
--          nm_debug.debug('############ '||cs_nte%ROWCOUNT||' cs_nte count');
--       Changed to be a cursor loop rather than a single INSERT statement as to not
--        cause AU security to grind to a halt
--
        l_nm_seq_no := NVL(get_seq_no_from_orig(l_nte_arr(i).nte_ne_id_of
                                               ,l_nte_arr(i).nte_begin_mp
                                               ,l_nte_arr(i).nte_end_mp
                                               )
                          ,l_nte_arr(i).nte_seq_no
                          );
--            nm_debug.debug('############ '||cs_nte%ROWCOUNT||' pre insert');
--
        l_rec_nm.nm_ne_id_in    := pi_iit_rec.iit_ne_id;
        l_rec_nm.nm_ne_id_of    := l_nte_arr(i).nte_ne_id_of;
        l_rec_nm.nm_type        := 'I';
        l_rec_nm.nm_obj_type    := pi_iit_rec.iit_inv_type;
        l_rec_nm.nm_begin_mp    := l_nte_arr(i).nte_begin_mp;
        l_rec_nm.nm_start_date  := pi_effective_date;
        l_rec_nm.nm_end_date    := l_nm_end_date;
        l_rec_nm.nm_end_mp      := l_nte_arr(i).nte_end_mp;
        l_rec_nm.nm_slk         := NULL;
        l_rec_nm.nm_cardinality := 1;
        l_rec_nm.nm_admin_unit  := pi_iit_rec.iit_admin_unit;
        l_rec_nm.nm_seq_no      := l_nm_seq_no;
        l_rec_nm.nm_seg_no      := NULL;
        l_rec_nm.nm_true        := NULL;
        
        if pi_nit_rec.nit_exclusive = 'Y'
        then
          l_pl.pl_ne_id := l_rec_nm.nm_ne_id_of;
          l_pl.pl_start := l_rec_nm.nm_begin_mp;
          l_pl.pl_end   := l_rec_nm.nm_end_mp;
          
          l_pl_arr := cr8_mems_for_excl_affected(pi_pl      => l_pl
                                                ,pi_iit_rec => pi_iit_rec
                                                ,pi_nit_rec => pi_nit_rec
                                                ,pi_nm_rec  => l_rec_nm);
            
          if pi_maintain_nte
            and l_pl_arr.placement_count <> 1
          then
            l_nte_to_maintain := pi_nte_job_id;
          
            --this chunk has been further chunked by future exclusive assets
            --or has been completely located up to future exclusive assets
            db('this chunk has been further chunked by future exclusive assets');
            db('deleting nte id ' || l_nte_to_maintain || ' where of:begin:end = '
               || l_nte_arr(i).nte_ne_id_of || ':' || l_nte_arr(i).nte_begin_mp || ':' || l_nte_arr(i).nte_end_mp);
            delete
              nm_nw_temp_extents nte
            where
              nte.nte_job_id = l_nte_to_maintain
            and
              nte.nte_ne_id_of = l_nte_arr(i).nte_ne_id_of
            and
              nte.nte_begin_mp = l_nte_arr(i).nte_begin_mp
            and
              nte.nte_end_mp = l_nte_arr(i).nte_end_mp;
              
            db('deleted ' || sql%rowcount || ' records');
          end if;
          
          --create mems not affected by exclusivity
          cr8_mems_for_pl_arr(pi_pl_arr        => l_pl_arr
                             ,pi_nm_rec        => l_rec_nm
                             ,pi_nte_for_chunk => l_nte_to_maintain);
        else
          nm3net.ins_nm (l_rec_nm);
        end if;
--            nm_debug.debug('############ '||cs_nte%ROWCOUNT||' post insert');
     EXCEPTION
        WHEN DUP_VAL_ON_INDEX
         THEN
--               nm_debug.debug('############ dup_val_on_index caught');
           DELETE NM_MEMBERS_ALL
           WHERE  nm_ne_id_in   = l_rec_nm.nm_ne_id_in
            AND   nm_ne_id_of   = l_rec_nm.nm_ne_id_of
            AND   nm_begin_mp   = l_rec_nm.nm_begin_mp
            AND   nm_start_date = l_rec_nm.nm_start_date;
           nm3net.ins_nm (l_rec_nm);
     END;
--
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_members');

EXCEPTION
      WHEN DUP_VAL_ON_INDEX
       THEN
         g_homo_exc_code := -20517;
         g_homo_exc_msg  := 'Inventory Locations already exist for this item at this point with this start date';
         RAISE g_homo_exception;
END create_members;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_no_longer_located(pi_end_loc_only   in nm_inv_types.nit_end_loc_only%type
                                 ,pi_iit_ne_id_arr  in nm3type.tab_number
                                 ,pi_effective_date in date
                                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'close_no_longer_located');

  IF pi_end_loc_only != 'Y'
   THEN
     xattr_off;
     FORALL l_count IN 1..pi_iit_ne_id_arr.COUNT
        UPDATE nm_inv_items
         SET   iit_end_date = pi_effective_date
        WHERE  iit_ne_id    = pi_iit_ne_id_arr(l_count)
         AND NOT EXISTS (SELECT 1                           -- item has no location currently
                          FROM  nm_members
                         WHERE  nm_ne_id_in = iit_ne_id
                        )
         AND NOT EXISTS (SELECT 1                           -- item has no pre-existing future location
                          FROM  nm_members_all
                         WHERE  nm_ne_id_in   = iit_ne_id
                          AND   nm_start_date > pi_effective_date
                        );
     xattr_on;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'close_no_longer_located');

END close_no_longer_located;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_for_holes(pi_nit_rec         in     nm_inv_types%rowtype
                         ,pi_iit_rec         in     nm_inv_items%rowtype
                         ,pi_nte_job_id      in     nm_nw_temp_extents.nte_job_id%type
                         ,pi_effective_date  in     date
                         ,pio_warning_code   in OUT VARCHAR2
                         ,pio_warning_msg    in OUT VARCHAR2
                         ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_for_holes');

  IF  pi_nit_rec.nit_contiguous        = 'Y'
    OR pi_nit_rec.nit_multiple_allowed != 'Y'
    THEN
   -- nm_debug.debug('Check contig and multi_allowed');
      -- ##########################################################################################
      --  If this inv_type is contiguous then return
      --   warning if there are any resultant"holes"
      --   in the affected sections
      --  Also check multiple_allowed
      -- ##########################################################################################
      DECLARE
--
         CURSOR cs_elements (p_job_id NUMBER) IS
         SELECT ne_id
               ,ne_length
               ,ne_unique
          FROM  NM_ELEMENTS
         WHERE  ne_id IN (SELECT nte_ne_id_of
                           FROM  NM_NW_TEMP_EXTENTS
                          WHERE  nte_job_id = pi_nte_job_id
                         );
--
         CURSOR cs_members (p_ne_id_of   NUMBER
                           ,cp_iit_ne_id NUMBER
                           ,p_inv_type   VARCHAR2
                           ) IS
         SELECT nm_begin_mp
               ,nm_end_mp
          FROM  NM_MEMBERS
         WHERE  nm_ne_id_of                   = p_ne_id_of
          AND   nm_ne_id_in                   = cp_iit_ne_id
          AND   nm_obj_type||NULL             = p_inv_type
         ORDER BY nm_begin_mp;
--
         l_been_into_loop BOOLEAN;
--
         l_placement_arr  NM_PLACEMENT_ARRAY;
         l_pl             NM_PLACEMENT;
--
      BEGIN
--
         FOR cs_rec IN cs_elements(pi_nte_job_id)
          LOOP
--
            -- Initialise variables
            l_been_into_loop := FALSE;
            l_placement_arr  := nm3pla.initialise_placement_array;
--
            FOR cs_mem IN cs_members (cs_rec.ne_id
                                     ,pi_iit_rec.iit_ne_id 
                                     ,pi_iit_rec.iit_inv_type)
             LOOP
               --
               l_pl := l_placement_arr.npa_placement_array(l_placement_arr.npa_placement_array.COUNT);
               --
               -- If it's non-exclusive, but is contiguous make sure there are no overlaps
               IF   pi_nit_rec.nit_exclusive  = 'N'
                AND pi_nit_rec.nit_contiguous = 'Y'
                THEN
                  --
                  -- On exclusive inv_types there will be no overlaps because they'll have been taken care
                  --  of above (in the membership sorting of the old stuff)
                  IF   cs_mem.nm_begin_mp > l_pl.pl_start
                   AND cs_mem.nm_begin_mp < l_pl.pl_end
                   THEN
                     g_homo_exc_code := -20514;
                     g_homo_exc_msg  := 'Overlaps not allowed on inventory types which are marked as contiguous';
                     RAISE g_homo_exception;
                  END IF;
               END IF;
               --
               l_been_into_loop := TRUE;
               --
               l_placement_arr := l_placement_arr.add_element(pl_ne_id   => cs_rec.ne_id
                                                             ,pl_start   => cs_mem.nm_begin_mp
                                                             ,pl_end     => cs_mem.nm_end_mp
                                                             ,pl_measure => 0
                                                             ,pl_mrg_mem => TRUE
                                                             );
               --
            END LOOP; -- cs_mem
--
            -- Because when we added the members to the placement array
            --  we specfied that we wanted to merge contiguous elements
            --  if there is only 1 element then this is the a single bit, but not necessarily the whole section
            IF pi_nit_rec.nit_contiguous = 'Y'
             THEN
               IF  l_placement_arr.npa_placement_array.COUNT        > 1
                OR l_placement_arr.npa_placement_array(1).pl_start != 0
                OR l_placement_arr.npa_placement_array(1).pl_end   != cs_rec.ne_length
                THEN
                  pio_warning_code := c_contiguous_warning_code;
                  pio_warning_msg  := pio_warning_msg||','||cs_rec.ne_unique||' (' || to_char(pi_effective_date, 'DD-MON-YYYY') || ')';
               END IF;
            END IF;
--
         END LOOP; -- cs_elements
--
      END;
   END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_for_holes');

END check_for_holes;
--
-----------------------------------------------------------------------------
--
FUNCTION get_locs_on_element(pi_ne_id      in nm_elements.ne_id%type
                            ,pi_nte_job_id in nm_nw_temp_extents.nte_job_id%type
                            ) RETURN nm3extent.tab_nte IS

  l_retval nm3extent.tab_nte;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_locs_on_element');

  select
   nte.*
  bulk collect into
    l_retval
  from
    nm_nw_temp_extents nte
  where
    nte.nte_job_id = pi_nte_job_id
  and
    nte.nte_ne_id_of = pi_ne_id;
  

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_locs_on_element');

  RETURN l_retval;

END get_locs_on_element;
--
-----------------------------------------------------------------------------
--
FUNCTION get_new_elements(pi_old_ne_id     in nm_elements.ne_id%type
                         ,pi_neh_operation in nm_element_history.neh_operation%type
                         ) RETURN t_ne_arr IS

  l_retval t_ne_arr;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_new_elements');

  select
    ne.*
  bulk collect into
    l_retval
  from
    nm_element_history neh,
    nm_elements_all    ne
  where
    neh.neh_ne_id_old = pi_old_ne_id
  and
    neh.neh_operation = pi_neh_operation
  and
    neh.neh_ne_id_new = ne.ne_id
  order by
    neh.neh_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_new_elements');

  RETURN l_retval;

END get_new_elements;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_split(pi_begin_mp           in nm_members.nm_begin_mp%type
                       ,pi_end_mp             in nm_members.nm_end_mp%type
                       ,pi_new_ne_1_id        in nm_elements.ne_id%type
                       ,pi_new_ne_1_length    in nm_elements.ne_length%type
                       ,pi_new_ne_2_id        in nm_elements.ne_id%type
                       ,pi_new_ne_2_length    in nm_elements.ne_length%type
                       ,po_new_pl_1              out nm_placement
                       ,po_new_pl_2              OUT nm_placement
                       ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_split');

  po_new_pl_1 := nm3pla.initialise_placement;
  po_new_pl_2 := nm3pla.initialise_placement;

  if pi_begin_mp < pi_new_ne_1_length
  then
    --begin mp is before split point
    --so create placement for first new element
    po_new_pl_1.pl_ne_id := pi_new_ne_1_id;
    po_new_pl_1.pl_start := pi_begin_mp;
    
    if pi_end_mp <= pi_new_ne_1_length
    then
      --placement is only on first new element
      po_new_pl_1.pl_end := pi_end_mp;
    else
      --placement spans both new elements
      po_new_pl_1.pl_end := pi_new_ne_1_length;
      
      --create placement for second new element
      po_new_pl_2.pl_ne_id := pi_new_ne_2_id;
      po_new_pl_2.pl_start := 0;
      po_new_pl_2.pl_end   := pi_end_mp - pi_new_ne_1_length;
    end if;
  else
    --begin mp is after split point
    --so create placement on second new element
    po_new_pl_1.pl_ne_id := pi_new_ne_2_id;
    po_new_pl_1.pl_start := pi_begin_mp - pi_new_ne_1_length;
    po_new_pl_1.pl_end   := pi_end_mp - pi_new_ne_1_length;
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_split');

END process_split;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_merge(pi_begin_mp         IN     nm_members.nm_begin_mp%TYPE
                       ,pi_end_mp           IN     nm_members.nm_end_mp%TYPE
                       ,pi_old_ne_length    IN     nm_elements.ne_length%TYPE
                       ,pi_element_in_merge in     pls_integer
                       ,pi_new_ne_id        IN     nm_elements.ne_id%TYPE
                       ,pi_new_ne_length    IN     nm_elements.ne_length%TYPE
                       ,po_new_pl              out nm_placement
                       ) IS

  l_element_1_length nm_elements.ne_length%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_merge');

  po_new_pl := nm3pla.initialise_placement(pi_ne_id => pi_new_ne_id);
  
  if pi_element_in_merge = 1
  then
    po_new_pl.pl_start := pi_begin_mp;
    po_new_pl.pl_end   := pi_end_mp;
  else
    l_element_1_length := pi_new_ne_length - pi_old_ne_length;
  
    po_new_pl.pl_start := l_element_1_length + pi_begin_mp;
    po_new_pl.pl_end   := l_element_1_length + pi_end_mp;
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_merge');

END process_merge;
--
-----------------------------------------------------------------------------
--
PROCEDURE apply_non_closing_edits(pio_pl in out nm_placement
                                 ,pi_non_closing_hist_arr nm3net_history.t_neh_rec_arr
                                 ) IS

  c_point constant boolean := pio_pl.pl_start = pio_pl.pl_end;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'apply_non_closing_edits');

  db('apply non closing edits');
  db('starting pl ' || pio_pl.pl_ne_id || ':' || pio_pl.pl_start || ':' || pio_pl.pl_end);
  
  FOR i IN 1..pi_non_closing_hist_arr.COUNT
  LOOP
    db('applying operation ' || pi_non_closing_hist_arr(i).neh_operation);
    CASE pi_non_closing_hist_arr(i).neh_operation
      WHEN nm3net_history.c_neh_op_shift
      THEN
        pio_pl.pl_start := nm3recal.get_mp_translation_shift(pi_mp             => pio_pl.pl_start
                                                            ,pi_element_length => pi_non_closing_hist_arr(i).neh_old_ne_length
                                                            ,pi_begin_mp       => pi_non_closing_hist_arr(i).neh_param_1
                                                            ,pi_shift_distance => pi_non_closing_hist_arr(i).neh_param_2);
      
        IF c_point
        then
          pio_pl.pl_end := pio_pl.pl_start;
        else
          pio_pl.pl_end := nm3recal.get_mp_translation_shift(pi_mp             => pio_pl.pl_end
                                                            ,pi_element_length => pi_non_closing_hist_arr(i).neh_old_ne_length
                                                            ,pi_begin_mp       => pi_non_closing_hist_arr(i).neh_param_1
                                                            ,pi_shift_distance => pi_non_closing_hist_arr(i).neh_param_2);
        end if;
      
      WHEN nm3net_history.c_neh_op_recalibrate
      THEN
        pio_pl.pl_start := nm3recal.get_mp_translation_recal(pi_mp                  => pio_pl.pl_start
                                                            ,pi_orig_element_length => pi_non_closing_hist_arr(i).neh_old_ne_length
                                                            ,pi_begin_mp            => pi_non_closing_hist_arr(i).neh_param_1
                                                            ,pi_new_length_to_end   => pi_non_closing_hist_arr(i).neh_param_2);
      
        IF c_point
        THEN
          pio_pl.pl_end := pio_pl.pl_start;
        ELSE
          pio_pl.pl_end := nm3recal.get_mp_translation_recal(pi_mp                  => pio_pl.pl_end
                                                            ,pi_orig_element_length => pi_non_closing_hist_arr(i).neh_old_ne_length
                                                            ,pi_begin_mp            => pi_non_closing_hist_arr(i).neh_param_1
                                                            ,pi_new_length_to_end   => pi_non_closing_hist_arr(i).neh_param_2);
        END IF;    
      ELSE
        hig.raise_ner(pi_appl => nm3type.c_hig
                     ,pi_id   => 110
                     ,pi_supplementary_info => 'apply_non_closing_edits: non-closing neh operation "' || pi_non_closing_hist_arr(i).neh_operation || '"');
    END CASE;
    db('updated pl ' || pio_pl.pl_ne_id || ':' || pio_pl.pl_start || ':' || pio_pl.pl_end);
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'apply_non_closing_edits');

END apply_non_closing_edits;
--
-----------------------------------------------------------------------------
--
PROCEDURE coalesce_members_chunks(pi_iit_ne_id      in nm_inv_items.iit_ne_id%type
                                 ,pi_effective_date in date
                                 ) IS

  l_ne_id_of_arr   nm3type.tab_number;
  l_begin_mp_arr   nm3type.tab_number;
  l_end_mp_arr     nm3type.tab_number;
  l_start_date_arr nm3type.tab_date;
  l_end_date_arr   nm3type.tab_date;
  
  l_nm_to_delete_rowid_arr nm3type.tab_rowid;
  
  l_new_end_mp      nm_members.nm_end_mp%type;
  l_extended_end_mp nm_members.nm_end_mp%TYPE;
  
  l_rowid rowid;
  
  procedure get_next_extension(pi_nm_ne_id_of in     nm_members.nm_ne_id_of%TYPE
                              ,pi_start_date  in     date
                              ,pi_end_date    in     date
                              ,pi_end_mp      in     nm_members.nm_end_mp%TYPE
                              ,po_rowid          out rowid
                              ,po_new_end_mp     out nm_members.nm_end_mp%TYPE
                              ) is
  
  BEGIN
    begin
      SELECT
        nm.rowid,
        nm.nm_end_mp
      into
        po_rowid,
        po_new_end_mp
      FROM
        nm_members_all nm
      WHERE
        nm.nm_ne_id_in = pi_iit_ne_id
      AND
        nm.nm_ne_id_of = pi_nm_ne_id_of
      AND
        nm.nm_start_date = pi_start_date
      AND
        NVL(nm.nm_end_date, nm3type.c_nvl_date) = NVL(pi_end_date, nm3type.c_nvl_date)
      AND
        nm.nm_begin_mp = pi_end_mp
      for update nowait;        
        
    exception
      when no_data_found
      then
        po_rowid       := NULL;
        po_new_end_mp  := NULL;
        
      when too_many_rows
      then
        raise_application_error(-20000, 'Member overlaps detected');
    
    end;
      
  end get_next_extension;
  
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'coalesce_members_chunks');

  db('coalesce_members_chunks');
  
  --get all members that are the start of a contiguous chunk
  SELECT
    nm1.nm_ne_id_of,
    nm1.nm_begin_mp,
    nm1.nm_end_mp,
    nm1.nm_start_date,
    nm1.nm_end_date
  BULK COLLECT INTO
    l_ne_id_of_arr,
    l_begin_mp_arr,
    l_end_mp_arr,
    l_start_date_arr,
    l_end_date_arr
  FROM
    nm_members_all nm1
  WHERE
    nm1.nm_ne_id_in = pi_iit_ne_id
  AND
    nm1.nm_start_date >= pi_effective_date
  AND
    NOT EXISTS (SELECT
                  1
                FROM
                  nm_members_all nm2
                WHERE
                  nm2.nm_ne_id_in = pi_iit_ne_id
                AND
                  nm2.nm_start_date >= pi_effective_date
                AND
                  nm2.nm_ne_id_of = nm1.nm_ne_id_of
                AND
                  nm2.nm_end_mp = nm1.nm_begin_mp);
  
  db('processing ' || l_ne_id_of_arr.COUNT || ' starting chunks');
  
  --for each starting member find all connected members
  for i in 1..l_ne_id_of_arr.count
  loop
    db('processing chunk ' || l_ne_id_of_arr(i) || ':' || l_begin_mp_arr(i) || ':' || l_end_mp_arr(i));
    l_new_end_mp := l_end_mp_arr(i);
    
    --find out how far this chunk extends
    loop
      get_next_extension(pi_nm_ne_id_of => l_ne_id_of_arr(i)
                        ,pi_start_date  => l_start_date_arr(i)
                        ,pi_end_date    => l_end_date_arr(i)
                        ,pi_end_mp      => l_new_end_mp
                        ,po_rowid       => l_rowid
                        ,po_new_end_mp  => l_extended_end_mp);
                        
      exit when l_extended_end_mp is null;
      
      db('--extending chunk to ' || l_extended_end_mp);
      
      l_new_end_mp := l_extended_end_mp;
      l_nm_to_delete_rowid_arr(l_nm_to_delete_rowid_arr.count + 1) := l_rowid;
    end loop;
    
    if l_new_end_mp <> l_end_mp_arr(i)
    then
      db('updating member end to ' || l_new_end_mp);
      update
        nm_members_all nm
      set
        nm.nm_end_mp = l_new_end_mp
      where
        nm.nm_ne_id_in = pi_iit_ne_id
      and
        nm.nm_ne_id_of = l_ne_id_of_arr(i)
      and
        nm.nm_begin_mp = l_begin_mp_arr(i)
      and
        nm.nm_start_date = l_start_date_arr(i); 
    end if;
  end loop;
  
  --delete all redundant member records
  db('deleting ' || l_nm_to_delete_rowid_arr.COUNT || ' redundant members');
  forall i in 1..l_nm_to_delete_rowid_arr.count
    delete
      nm_members_all nm
    where
      nm.rowid = l_nm_to_delete_rowid_arr(i);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'coalesce_members_chunks');

END coalesce_members_chunks;
--
-----------------------------------------------------------------------------
--
PROCEDURE homo_update_hist(p_temp_ne_id_in  IN     NUMBER
                          ,p_iit_ne_id      IN     NUMBER
                          ,p_effective_date IN     DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                          ,p_warning_code      OUT VARCHAR2
                          ,p_warning_msg       OUT VARCHAR2
                          ) IS

  --create a copy of the temp extent that is passed in
  c_nte_id                    CONSTANT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE := create_duplicate_nte(pi_nte_id => p_temp_ne_id_in);
  c_nte_id_for_unchanged_locs CONSTANT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE := nm3net.get_next_nte_id;
  
  c_initial_effective_date    CONSTANT date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
  
  l_inv_orig_location NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
  l_new_inv_location  NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
  l_new_inv_pl_arr    NM_PLACEMENT_ARRAY;
  
  l_rec_iit    NM_INV_ITEMS%ROWTYPE;
  l_rec_nit    NM_INV_TYPES%ROWTYPE;

  --nte for non-edited datums
  l_remnant_job_id        NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
  --nte for both full location at original effective date
  --including both edited and non-edited datums
  l_nte_for_eff_date_loc  nm_nw_temp_extents.nte_job_id%TYPE;
  --nte for edited datums
  l_nte_for_edited_datums NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
  --nte for location at future dates that have been processed
  l_loc_at_date_job_id    nm_nw_temp_extents.nte_job_id%TYPE;
  
  l_new_first_pl    NM_PLACEMENT;
  l_new_last_pl     NM_PLACEMENT;

  l_rec_ne     NM_ELEMENTS%ROWTYPE;
  l_rec_nin    NM_INV_NW%ROWTYPE;
  
  l_edited_ne_id_arr     nm3net_history.t_neh_ne_id_old_arr;
  l_edited_operation_arr nm3net_history.t_neh_operation_arr;
  l_edited_date_arr      nm3net_history.t_neh_effective_date_arr;
  
  l_tab_iit_ne_id nm3type.tab_number;
  
  l_closing_hist_arr          nm3net_history.t_neh_rec_arr;
  l_ne_1_closing_hist_arr     nm3net_history.t_neh_rec_arr;
  l_ne_2_closing_hist_arr     nm3net_history.t_neh_rec_arr;
  l_ne_1_non_closing_hist_arr nm3net_history.t_neh_rec_arr;
  l_ne_2_non_closing_hist_arr nm3net_history.t_neh_rec_arr;

  l_element_arr_idx pls_integer;
  
  l_locs_on_element_arr nm3extent.tab_nte;
  
  l_new_pl_1 nm_placement;
  l_new_pl_2 nm_placement;
  
  l_pl_arr nm_placement_array;
  
  l_new_ne_1_rec nm_elements%rowtype;
  l_new_ne_2_rec nm_elements%ROWTYPE;
  
  l_nm_rec nm_members%rowtype;
  
  l_date_arr t_date_arr;
  
  l_date_arr_idx varchar2(11);
  
  l_date_to_process date;
  
  PROCEDURE reset_for_return IS
   BEGIN
      --
      --  Reset the effective date
      --
      nm3user.set_effective_date (c_initial_effective_date);
      nm3extent.g_combine_temp_ne_called := FALSE;
      xattr_on;
   END reset_for_return;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'homo_update_hist');

  g_debug_on := TRUE;

  nm_debug.debug_on;

  get_xattr_status;
  
  db('nm3homo');
  
  nm3user.set_effective_date (p_effective_date);
  
  --get a Placement Array with the inventory items original location
  l_inv_orig_location := nm3pla.get_placement_from_ne (p_iit_ne_id);
   
  --get details of the asset item
  l_rec_iit := nm3inv.get_inv_item(p_iit_ne_id);
  IF l_rec_iit.iit_ne_id IS NULL
   THEN
     g_homo_exc_code := -20502;
     g_homo_exc_msg  := 'No NM_INV_ITEMS record found';
     RAISE g_homo_exception;
  END IF;
  
  IF g_homo_touch_flag 
   THEN
     nm3lock.lock_inv_item (pi_iit_ne_id      => p_iit_ne_id
                           ,p_lock_for_update => TRUE
                           );
   END IF;
   
-- #############################################################################
--   Get NM_INV_TYPES record
-- #############################################################################
-- nm_debug.debug('Get NM_INV_TYPES record');

  l_rec_nit := nm3get.get_nit (pi_nit_inv_type => l_rec_iit.iit_inv_type);

-- #############################################################################
--   Get rid of any distance break records in the Temp Extent
--    given that we don't want to locate any inventory on a DB
-- #############################################################################
--
  nm3extent.remove_db_from_temp_ne (c_nte_id);

-- #############################################################################
--  Check to make sure the structure of the temp ne is valid for either point of cont
-- #############################################################################

  check_temp_ne_for_pnt_or_cont (pi_nte_job_id  => c_nte_id
                                ,pi_pnt_or_cont => l_rec_nit.nit_pnt_or_cont
                                );

--#############################################################################
-- Check multiple allowed
--#############################################################################
  l_new_inv_pl_arr   := nm3pla.get_placement_from_temp_ne (c_nte_id);
  l_new_inv_location := l_new_inv_pl_arr;
  IF l_rec_nit.nit_multiple_allowed != 'Y'
   THEN
     DECLARE
        l_pl_arr           NM_PLACEMENT_ARRAY;
        l_pl               NM_PLACEMENT;
        fail_multi_allowed EXCEPTION;
     BEGIN
        IF   l_new_inv_pl_arr.placement_count > 1
         AND l_rec_nit.nit_pnt_or_cont = 'P'
         THEN
            -- If not multi_allowed and there is >1 loc for a point item fail immediately
           RAISE fail_multi_allowed;
        END IF;
        l_pl_arr := nm3pla.defrag_placement_array(l_new_inv_pl_arr);
        FOR i IN 2..l_pl_arr.placement_count
         LOOP
           l_pl := l_pl_arr.npa_placement_array(i);
           IF l_pl.pl_measure            = 0
            THEN
              -- If the measure is zero then the record is seperate from the last one
              RAISE fail_multi_allowed;
           END IF;
        END LOOP;
     EXCEPTION
        WHEN fail_multi_allowed
         THEN
           g_homo_exc_code := -20513;
           g_homo_exc_msg  := 'Inventory types not marked as "multiple allowed" must only have a single location';
           RAISE g_homo_exception;
     END;
  END IF;
  l_new_inv_pl_arr := nm3pla.initialise_placement_array;
  
--  #############################################################################
--   Check that the temp extents do not overlap
--  #############################################################################
--
   IF nm3extent.temp_ne_has_overlaps (c_nte_id)
    THEN
      g_homo_exc_code := -20519;
      g_homo_exc_msg  := 'NM_NW_TEMP_EXTENTS records with overlaps found';
      RAISE g_homo_exception;
   END IF;
   
   g_orig_new_inv_pl_arr := nm3pla.get_placement_from_temp_ne (c_nte_id);
--
--  #############################################################################
--   If the inventory already has a location
--    and we are therefore relocating, do not
--    relocate bits which are identical
--  #############################################################################
--
-- nm_debug.debug('Initial Temp Extent');
-- nm3extent.debug_temp_extents(c_nte_id);
--
   UPDATE NM_NW_TEMP_EXTENTS nte
    SET   nte.nte_job_id = c_nte_id_for_unchanged_locs
   WHERE  nte.nte_job_id = c_nte_id
    AND   EXISTS (SELECT 1
                   FROM  NM_MEMBERS nm
                  WHERE  nm.nm_ne_id_in = p_iit_ne_id
                   AND   nm.nm_ne_id_of = nte.nte_ne_id_of
                   AND   nm.nm_begin_mp = nte.nte_begin_mp
                   AND   nm.nm_end_mp   = nte.nte_end_mp
                 );
-- nm_debug.debug('Temp Extent with locations removed which are identical to existing inv loc');
---- nm3extent.debug_temp_extents(c_nte_id);
----    nm_debug.debug('Temp Extent with locations which are identical to existing inv loc');
--    nm3extent.debug_temp_extents(c_nte_id_for_unchanged_locs);
--
--  #############################################################################
--   Store the Temp Extent in a Placement array
--  #############################################################################
--
   l_new_inv_pl_arr := nm3pla.get_placement_from_temp_ne (c_nte_id);
--
--  #############################################################################
--   Defragment and re-store the rest of the placement array
--  #############################################################################
--
   l_new_inv_pl_arr := nm3pla.defrag_placement_array(l_new_inv_pl_arr);
   
  DECLARE
    skip_rest_of_val EXCEPTION;
  BEGIN
    IF l_new_inv_pl_arr.is_empty
    THEN
       IF   NOT nm3extent.g_combine_temp_ne_called -- This is not a "ADD TO LOCATION"
        THEN
          IF NOT nm3ausec.do_locations_exist(p_iit_ne_id)
           THEN  -- And there are no locations currently in existence
             g_homo_exc_code := -20501;
             g_homo_exc_msg  := 'No NM_NW_TEMP_EXTENTS records found';
             RAISE g_homo_exception;
          END IF;
       END IF;
       RAISE skip_rest_of_val;
  END IF;
  nm3extent_o.create_temp_ne_from_pl (l_new_inv_pl_arr, l_remnant_job_id);

  l_new_inv_pl_arr := nm3pla.get_placement_from_temp_ne (l_remnant_job_id);

  l_new_first_pl := l_new_inv_pl_arr.npa_placement_array(l_new_inv_pl_arr.npa_placement_array.FIRST);
  l_new_last_pl  := l_new_inv_pl_arr.npa_placement_array(l_new_inv_pl_arr.npa_placement_array.LAST);

  --
   --
   -- Validate where the Inventory is valid on the network, and whether or not
   --  the specified XSP is valid
   -- The code is in multiple anonymous blocks to allow us to trap all of the
   --  20001 errors returned by the atomic functions and return a more meaningful
   --  error to the calling transaction
      --
      -- Get the NW type from the first element in the placement array,
      --  they will all be the same
   -- nm_debug.debug('Get the NW type from the first element in the placement array');
      FOR i IN 1..l_new_inv_pl_arr.placement_count
       LOOP
         DECLARE
            l_pl NM_PLACEMENT := l_new_inv_pl_arr.get_entry(i);
         BEGIN
            l_rec_ne := nm3get.get_ne (pi_ne_id           => l_pl.pl_ne_id
                                      ,pi_raise_not_found => FALSE
                                      );
         END;
         EXIT WHEN l_rec_ne.ne_id IS NOT NULL;
      END LOOP;
   --
      IF l_rec_ne.ne_id IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => 'NM_ELEMENTS : Effective Date : '||TO_CHAR(p_effective_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                       );
--         g_homo_exc_code := -20510;
--         g_homo_exc_msg  := 'No NM_ELEMENTS record found for NE_ID "'||l_new_first_pl.pl_ne_id||'"';
--         RAISE g_homo_exception;
      END IF;
   --
   --  #############################################################################
   --   Get NM_INV_NW record
   --  #############################################################################
   -- nm_debug.debug('Get NM_INV_NW record');
   --
      DECLARE
         no_nin_found EXCEPTION;
         PRAGMA EXCEPTION_INIT (no_nin_found,-20001);
      BEGIN
         l_rec_nin := nm3inv.get_nm_inv_nw(l_rec_iit.iit_inv_type
                                          ,l_rec_ne.ne_nt_type
                                          );
      EXCEPTION
         WHEN no_nin_found
          THEN
            g_homo_exc_code := -20505;
            g_homo_exc_msg  := 'Inventory type "'||l_rec_iit.iit_inv_type||'"'
                               ||' invalid on NW_TYPE "'||l_rec_ne.ne_nt_type||'"';
            RAISE g_homo_exception;
      END;
   --
   -- ####################################################################################
   --  Do not allow location of Child AT records which have a parent
   -- ####################################################################################
   --
      IF   does_relation_exist(l_rec_nit.nit_inv_type,nm3invval.c_at_relation)
       AND has_parent (l_rec_iit.iit_ne_id)
       THEN
         g_homo_exc_code := -20518;
         g_homo_exc_msg  := 'Cannot locate Inventory records which are in a Child AT relationship';
         RAISE g_homo_exception;
      END IF;
   --
   --  #############################################################################
   --   Check to make sure continuous isn't placed at a point
   --  #############################################################################
   -- nm_debug.debug('Check to make sure continuous isnt placed at a point');
   --
      IF   l_rec_nit.nit_pnt_or_cont = 'C'
       AND l_new_first_pl.pl_ne_id = l_new_last_pl.pl_ne_id
       AND l_new_first_pl.pl_start = l_new_last_pl.pl_end
       THEN
         g_homo_exc_code := -20512;
         g_homo_exc_msg  := 'Continuous Inventory Items must not be placed at a single point';
         RAISE g_homo_exception;
      ELSIF l_rec_nit.nit_pnt_or_cont        = 'P'
        THEN
          FOR i IN 1..l_new_inv_pl_arr.placement_count
           LOOP
             DECLARE
                c_pl CONSTANT NM_PLACEMENT := l_new_inv_pl_arr.npa_placement_array(i);
             BEGIN
                IF c_pl.pl_start != c_pl.pl_end
                 THEN
                   g_homo_exc_code := -20515;
                   g_homo_exc_msg  := 'Point Inventory Items can only be placed at single points';
                   RAISE g_homo_exception;
                END IF;
             END;
          END LOOP;
      END IF;
   --
   --  #############################################################################
   --   Validate the XSP
   --  #############################################################################
   -- nm_debug.debug('Validate the XSP');
   --
      IF   l_rec_nit.nit_x_sect_allow_flag = 'N'
       AND l_rec_iit.iit_x_sect IS NOT NULL
       THEN
         g_homo_exc_code := -20506;
         g_homo_exc_msg  := 'XSP not allowed for Inventory type "'||l_rec_iit.iit_inv_type||'"';
         RAISE g_homo_exception;
      ELSIF l_rec_nit.nit_x_sect_allow_flag = 'Y'
       THEN
         IF l_rec_iit.iit_x_sect IS NULL
          THEN
            g_homo_exc_code := -20507;
            g_homo_exc_msg  := 'XSP must be specified for Inventory type "'||l_rec_iit.iit_inv_type||'"';
            RAISE g_homo_exception;
         ELSE
            --
            -- For all the elements on which this item is being located, check XSP restraints
            --
            DECLARE
               l_last_rec_ne  NM_ELEMENTS%ROWTYPE;
               l_local_rec_ne NM_ELEMENTS%ROWTYPE;
               l_ne_id        NM_ELEMENTS.ne_id%TYPE;
               l_tab_ne_id_ok nm3type.tab_boolean;
            BEGIN
               l_last_rec_ne.ne_nt_type   := nm3type.c_nvl;
               l_last_rec_ne.ne_sub_class := nm3type.c_nvl;
               FOR j IN 1..l_new_inv_pl_arr.placement_count
                LOOP
                  l_ne_id := l_new_inv_pl_arr.get_entry(j).pl_ne_id;
                  --
                  IF NOT l_tab_ne_id_ok.EXISTS(l_ne_id)
                   THEN -- Only check for NE_IDs we haven't already checked - no point wasting time
                  --
                     l_local_rec_ne := nm3net.get_ne (l_ne_id);
                     IF  l_local_rec_ne.ne_nt_type                      != l_last_rec_ne.ne_nt_type
                      OR NVL(l_local_rec_ne.ne_sub_class,nm3type.c_nvl) != NVL(l_last_rec_ne.ne_sub_class,nm3type.c_nvl)
                      THEN -- Only check if the NT_TYPE or the SUBCLASS has changed from the previous record. no point otherwise
                        DECLARE
                           l_xsr_descr  XSP_RESTRAINTS.xsr_descr%TYPE;
                           no_xsr_found EXCEPTION;
                           PRAGMA EXCEPTION_INIT (no_xsr_found,-20001);
                        BEGIN
                           l_xsr_descr := nm3inv.get_xsp_descr
                                             (p_inv_type   => l_rec_iit.iit_inv_type
                                             ,p_x_sect_val => l_rec_iit.iit_x_sect
                                             ,p_nw_type    => l_local_rec_ne.ne_nt_type
                                             ,p_scl_class  => l_local_rec_ne.ne_sub_class
                                             );
                        EXCEPTION
                           WHEN no_xsr_found
                            THEN
                              g_homo_exc_code := -20508;
                              g_homo_exc_msg  := 'XSP "'||l_rec_iit.iit_x_sect||'" is not allowed for Inventory type "'
                                                 ||l_rec_iit.iit_inv_type||'" on NW_TYPE "'||l_local_rec_ne.ne_nt_type||'"'
                                                 ||', SUB_CLASS "'||l_local_rec_ne.ne_sub_class||'"';
                              RAISE g_homo_exception;
                        END;
                     END IF;
                     l_last_rec_ne           := l_local_rec_ne;
                     l_tab_ne_id_ok(l_ne_id) := TRUE;
                  END IF;
                  --
               END LOOP;
                  --
            END;
         END IF;
      END IF;
   
   --  #############################################################################
   --   Check the item has no future locations
   --  #############################################################################
   --
   check_item_has_no_future_locs (p_iit_ne_id      => l_rec_iit.iit_ne_id
                                 ,p_effective_date => p_effective_date
                                 );
   
   IF NOT c_hist_loc_enabled
   THEN
     --
     --  #############################################################################
     --   Check for future affected inv
     --  #############################################################################
     -- nm_debug.debug('Check for future affected inv');
     --
     DECLARE
        l_future_ne_id_in nm3type.tab_number;
     BEGIN
        l_future_ne_id_in := get_future_affected_inv
                                         (p_nte_job_id     => l_remnant_job_id
                                         ,p_inv_type       => l_rec_iit.iit_inv_type
                                         ,p_effective_date => p_effective_date
                                         );
        FOR i IN 1..l_future_ne_id_in.COUNT
         LOOP
           IF is_affected_by_exclusivity (p_iit_ne_id => l_future_ne_id_in(i)
                                         ,p_rec_iit   => l_rec_iit
                                         ,p_exclusive => (l_rec_nit.nit_exclusive         = 'Y')
                                         ,p_x_sect    => (l_rec_nit.nit_x_sect_allow_flag = 'Y')
                                         )
            THEN
              g_homo_exc_code := -20503;
              g_homo_exc_msg  := 'There are future inventory locations which would be affected';
              RAISE g_homo_exception;
           END IF;
        END LOOP;
     END;
   END IF;

   -- ##############################################################
   --   End of the basic validation
   -- ##############################################################

  EXCEPTION
    WHEN skip_rest_of_val
    THEN
      NULL;
  END;

  nm_debug.debug_sql_string('select * from nm_nw_temp_extents where nte_job_id = ' || l_remnant_job_id);

  ------------------------------------------------------------
  --get details of any datums in temp ne that have been edited
  ------------------------------------------------------------
  db('get details of any datums in temp ne that have been edited');
  nm3net_history.get_edited_datums_in_nte(pi_nte_id              => l_remnant_job_id
                                        ,po_edited_ne_id_arr     => l_edited_ne_id_arr
                                        ,po_edited_operation_arr => l_edited_operation_arr
                                        ,po_edited_date_arr      => l_edited_date_arr);

  db('l_edited_ne_id_arr.COUNT = ' || l_edited_ne_id_arr.COUNT);
  
  --save full location before removing edited datums
  l_nte_for_eff_date_loc := create_duplicate_nte(pi_nte_id => l_remnant_job_id);
  
  if l_edited_ne_id_arr.count > 0
  then
    IF NOT c_hist_loc_enabled
    then
      hig.raise_ner(pi_appl => 'NET'
                   ,pi_id   => 452);
    end if;
  
    --move edited datums into new temp ne
    db('move edited datums into new temp ne');
    l_nte_for_edited_datums := move_edited_datums_to_new_nte(pi_nte_id => l_remnant_job_id);
    db('edited nte');
    nm_debug.debug_sql_string('select * from nm_nw_temp_extents where nte_job_id = ' || l_nte_for_edited_datums);
    db('remnant nte');
    nm_debug.debug_sql_string('select * from nm_nw_temp_extents where nte_job_id = ' || l_remnant_job_id);
  end if;
  
  --------------------------------------
  --locate non-future affected as normal
  --------------------------------------
  db('>locate non-future affected as normal');
  lock_datums_membs_for_nte(pi_nte_job_id => l_remnant_job_id);
  
  end_date_existing_locations(pi_iit_ne_id                 => p_iit_ne_id
                             ,pi_effective_date            => p_effective_date
                             ,pi_nte_id_for_unchanged_locs => c_nte_id_for_unchanged_locs);

  replace_exclusive(pi_nit_rec        => l_rec_nit
                   ,pi_iit_rec        => l_rec_iit
                   ,pi_effective_date => p_effective_date
                   ,pi_nte_job_id     => l_remnant_job_id
                   ,pio_iit_ne_id_arr => l_tab_iit_ne_id);

  create_members(pi_nte_job_id     => l_remnant_job_id
                ,pi_iit_rec        => l_rec_iit
                ,pi_nit_rec        => l_rec_nit
                ,pi_effective_date => p_effective_date
                ,pi_end_date       => NULL);

  if l_edited_ne_id_arr.count > 0
  then
    ------------------------
    --locate future affected
    ------------------------
    db('>locate future affected');
    lock_datums_membs_for_nte(pi_nte_job_id => l_nte_for_edited_datums);
    
    --end_date_existing_locations(pi_iit_ne_id                 => p_iit_ne_id
    --                           ,pi_effective_date            => p_effective_date
    --                           ,pi_nte_id_for_unchanged_locs => c_nte_id_for_unchanged_locs);

    replace_exclusive(pi_nit_rec        => l_rec_nit
                     ,pi_iit_rec        => l_rec_iit
                     ,pi_effective_date => p_effective_date
                     ,pi_nte_job_id     => l_nte_for_edited_datums
                     ,pio_iit_ne_id_arr => l_tab_iit_ne_id);

    for i in 1..l_edited_ne_id_arr.count
    loop
      --create members for each edited datum with appropriate end date
      create_members(pi_nte_job_id     => l_nte_for_edited_datums
                    ,pi_iit_rec        => l_rec_iit
                    ,pi_nit_rec        => l_rec_nit
                    ,pi_effective_date => p_effective_date
                    ,pi_ne_id_of       => l_edited_ne_id_arr(i)
                    ,pi_end_date       => l_edited_date_arr(i)
                    ,pi_maintain_nte   => true);
    end loop;
              
  end if;

  --copy members to any child items
  deal_with_hierarchical(p_ne_id          => l_rec_iit.iit_ne_id
                        ,p_effective_date => p_effective_date);

  close_no_longer_located(pi_end_loc_only   => l_rec_nit.nit_end_loc_only
                         ,pi_iit_ne_id_arr  => l_tab_iit_ne_id
                         ,pi_effective_date => p_effective_date);

  check_for_holes(pi_nit_rec         => l_rec_nit
                 ,pi_iit_rec         => l_rec_iit
                 ,pi_nte_job_id      => l_nte_for_eff_date_loc
                 ,pi_effective_date  => p_effective_date 
                 ,pio_warning_code   => p_warning_code 
                 ,pio_warning_msg    => p_warning_msg);

--  check_for_holes(pi_nit_rec         => l_rec_nit
--                 ,pi_iit_rec         => l_rec_iit
--                 ,pi_nte_job_id      => l_nte_for_edited_datums
--                 ,pi_effective_date  => p_effective_date 
--                 ,pio_warning_code   => p_warning_code 
--                 ,pio_warning_msg    => p_warning_msg);

  -- Check to make sure we've not left any dependent data invalid
   IF   l_inv_orig_location.placement_count > 0
    AND c_xattr_status
    THEN
      DECLARE
         l_pl_end_dated_portion nm_placement_array := nm3pla.initialise_placement_array;
      BEGIN
         l_pl_end_dated_portion := nm3pla.subtract_pl_from_pl
                                              (p_pl_main      => l_inv_orig_location
                                              ,p_pl_to_remove => l_new_inv_location
                                              );
         IF l_pl_end_dated_portion.placement_count > 0
          THEN
            -- Call XITEM validation checker
            nm3inv_xattr.x_item_check_pl (pi_obj_type    => l_rec_iit.iit_inv_type
                                         ,pi_nm_ne_id_in => l_rec_iit.iit_ne_id
                                         ,pi_pl          => l_pl_end_dated_portion
                                         );
         END IF;
      END;
   END IF;
   
  -----------------------
  --process edited datums
  -----------------------
  db('process edited datums');
  --initialise fields in nm rec
  l_nm_rec.nm_ne_id_in    := l_rec_iit.iit_ne_id;
  l_nm_rec.nm_obj_type    := l_rec_iit.iit_inv_type;
  l_nm_rec.nm_type        := 'I';
  l_nm_rec.nm_slk         := NULL;
  l_nm_rec.nm_cardinality := 1;
  l_nm_rec.nm_admin_unit  := l_rec_iit.iit_admin_unit;
  l_nm_rec.nm_seq_no      := 1;
  l_nm_rec.nm_seg_no      := NULL;
  l_nm_rec.nm_true        := NULL;
  
  db('l_edited_ne_id_arr.COUNT ' || l_edited_ne_id_arr.count);
  
  if l_edited_ne_id_arr.count > 0
  then
    l_element_arr_idx := 1;
    
    while not l_element_arr_idx > l_edited_ne_id_arr.count
    loop
      db('in loop idx ' || l_element_arr_idx);
      db('element idx ' || l_element_arr_idx 
         || ' ne_id=' || l_edited_ne_id_arr(l_element_arr_idx)
         || ' operation=' || l_edited_operation_arr(l_element_arr_idx)
         || ' date=' || to_char(l_edited_date_arr(l_element_arr_idx), 'DD-MON-YYYY'));
      
      if l_edited_operation_arr(l_element_arr_idx) <> nm3net_history.c_neh_op_close
      then
        -------------------------
        --get old element details
        -------------------------
        db('get old element details');
        --get details of edit that closed the element
        l_closing_hist_arr := nm3net_history.get_neh_for_closing_op(pi_ne_id => l_edited_ne_id_arr(l_element_arr_idx));
      
        db('l_closing_hist_arr.count = ' || l_closing_hist_arr.count);
      
        IF l_closing_hist_arr.count = 0
        then
          	 hig.raise_ner(pi_appl               => 'HIG'
                          ,pi_id                 => 67
                          ,pi_supplementary_info => 'NM_ELEMENT_HISTORY closing op for ne_id ' || to_char(l_edited_ne_id_arr(l_element_arr_idx)));
        end if;
        
        --set effective date to that of this edit
        nm3user.set_effective_date(l_edited_date_arr(l_element_arr_idx));
        
        --set start date for any members created
        l_nm_rec.nm_start_date := l_edited_date_arr(l_element_arr_idx);
        
        --get all chunks of location on the closed element
        db('get all chunks of location on the closed element');
        l_locs_on_element_arr := get_locs_on_element(pi_ne_id      => l_edited_ne_id_arr(l_element_arr_idx)
                                                    ,pi_nte_job_id => l_nte_for_edited_datums);
        
        db('got ' || l_locs_on_element_arr.count || ' chunks');
        
        -------------------------
        --get new element details
        -------------------------
        l_new_ne_1_rec := nm3get.get_ne(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new);
        --get non-closing edits to apply on new element
        db('get non-closing edits to apply on new element');
        l_ne_1_non_closing_hist_arr := nm3net_history.get_neh_for_non_closing_ops(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new);
        --get closing op if they exist
        l_ne_1_closing_hist_arr := nm3net_history.get_neh_for_closing_op(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new);
        
        if l_ne_1_closing_hist_arr.count > 0
        then
          --add to end of element array
          db('add to end of element array - ' || l_closing_hist_arr(1).neh_ne_id_new);
          l_edited_ne_id_arr(l_edited_ne_id_arr.count + 1) := l_ne_1_closing_hist_arr(1).neh_ne_id_old;
          l_edited_operation_arr(l_edited_ne_id_arr.COUNT) := l_ne_1_closing_hist_arr(1).neh_operation;
          l_edited_date_arr(l_edited_ne_id_arr.COUNT) := l_ne_1_closing_hist_arr(1).neh_effective_date;
        end if;
        
        IF l_closing_hist_arr(1).neh_operation = nm3net_history.c_neh_op_split
        then
          db('split so get second new element');
          l_new_ne_2_rec := nm3get.get_ne(pi_ne_id => l_closing_hist_arr(2).neh_ne_id_new);
          --get non-closing edits to apply for 2nd element
          l_ne_2_non_closing_hist_arr := nm3net_history.get_neh_for_non_closing_ops(pi_ne_id => l_closing_hist_arr(2).neh_ne_id_new);
          
          --get closing op if they exist
          l_ne_2_closing_hist_arr := nm3net_history.get_neh_for_closing_op(pi_ne_id => l_closing_hist_arr(2).neh_ne_id_new);
          
          if l_ne_2_closing_hist_arr.count > 0
          then
            --add to end of element array
            db('add to end of element array - ' || l_closing_hist_arr(2).neh_ne_id_new);
            l_edited_ne_id_arr(l_edited_ne_id_arr.count + 1) := l_ne_2_closing_hist_arr(2).neh_ne_id_old;
            l_edited_operation_arr(l_edited_ne_id_arr.COUNT) := l_ne_2_closing_hist_arr(2).neh_operation;
            l_edited_date_arr(l_edited_ne_id_arr.COUNT) := l_ne_2_closing_hist_arr(2).neh_effective_date;
          end if;
        end if;
        
        ----------------------
        --derive new locations
        ----------------------
        for i in 1..l_locs_on_element_arr.count
        loop
          db('processing chunk - ' || l_locs_on_element_arr(i).nte_ne_id_of 
             || ':' || l_locs_on_element_arr(i).nte_begin_mp
             || ':' || l_locs_on_element_arr(i).nte_end_mp);
             
          --get initial placement(s)
          CASE 
            WHEN l_edited_operation_arr(l_element_arr_idx) = nm3net_history.c_neh_op_split
            THEN
              process_split(pi_begin_mp           => l_locs_on_element_arr(i).nte_begin_mp
                           ,pi_end_mp             => l_locs_on_element_arr(i).nte_end_mp
                           ,pi_new_ne_1_id        => l_closing_hist_arr(1).neh_ne_id_new
                           ,pi_new_ne_1_length    => l_closing_hist_arr(1).neh_new_ne_length
                           ,pi_new_ne_2_id        => l_closing_hist_arr(2).neh_ne_id_new
                           ,pi_new_ne_2_length    => l_closing_hist_arr(2).neh_new_ne_length
                           ,po_new_pl_1           => l_new_pl_1
                           ,po_new_pl_2           => l_new_pl_2);
                     
            WHEN l_edited_operation_arr(l_element_arr_idx) = nm3net_history.c_neh_op_merge
            THEN
              process_merge(pi_begin_mp         => l_locs_on_element_arr(i).nte_begin_mp
                           ,pi_end_mp           => l_locs_on_element_arr(i).nte_end_mp
                           ,pi_old_ne_length    => l_closing_hist_arr(1).neh_old_ne_length
                           ,pi_element_in_merge => l_closing_hist_arr(1).neh_param_1
                           ,pi_new_ne_id        => l_closing_hist_arr(1).neh_ne_id_new
                           ,pi_new_ne_length    => l_closing_hist_arr(1).neh_new_ne_length
                           ,po_new_pl           => l_new_pl_1);
                     
            when l_edited_operation_arr(l_element_arr_idx) = nm3net_history.c_neh_op_reverse
            then
              l_new_pl_1 := nm3pla.initialise_placement(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new
                                                       ,pi_start => l_closing_hist_arr(1).neh_old_ne_length - l_locs_on_element_arr(i).nte_end_mp
                                                       ,pi_end   => l_closing_hist_arr(1).neh_old_ne_length - l_locs_on_element_arr(i).nte_begin_mp);
            
            WHEN l_edited_operation_arr(l_element_arr_idx) IN (nm3net_history.c_neh_op_replace
                                                              ,nm3net_history.c_neh_op_reclassify)
            THEN
              l_new_pl_1 := nm3pla.initialise_placement(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new
                                                       ,pi_start => l_locs_on_element_arr(i).nte_begin_mp
                                                       ,pi_end   => l_locs_on_element_arr(i).nte_end_mp);
            ELSE
              hig.raise_ner(pi_appl               => nm3type.c_hig
                           ,pi_id                 => 110
                           ,pi_supplementary_info => 'nm3homo: closing neh operation "' || l_edited_operation_arr(l_element_arr_idx) || '"');
          END CASE;
          
          db('pl 1 ' || l_new_pl_1.pl_ne_id || ':' || l_new_pl_1.pl_start || ':' || l_new_pl_1.pl_end);
          db('pl 2 ' || l_new_pl_2.pl_ne_id || ':' || l_new_pl_2.pl_start || ':' || l_new_pl_2.pl_end);
          
          -------------------------
          --apply non-closing edits
          -------------------------
          IF l_new_pl_1.pl_ne_id = l_closing_hist_arr(1).neh_ne_id_new
          then
            --pl 1 is on the first new element
            db('pl 1 is on the first new element');
            apply_non_closing_edits(pio_pl                  => l_new_pl_1
                                   ,pi_non_closing_hist_arr => l_ne_1_non_closing_hist_arr);
                                   
            --set end date for member
            l_nm_rec.nm_end_date := l_new_ne_1_rec.ne_end_date; 
          else
           --pl 1 is on the second new element
           db('pl 1 is on the second new element');
            apply_non_closing_edits(pio_pl                  => l_new_pl_1
                                   ,pi_non_closing_hist_arr => l_ne_2_non_closing_hist_arr);
            
            --set end date for member
            l_nm_rec.nm_end_date := l_new_ne_2_rec.ne_end_date; 
          end if;
          
          --create mems for exclusive conflicted chunks
          l_pl_arr := cr8_mems_for_excl_affected(pi_pl      => l_new_pl_1
                                                ,pi_iit_rec => l_rec_iit
                                                ,pi_nit_rec => l_rec_nit
                                                ,pi_nm_rec  => l_nm_rec);
          
          --create mems not affected by exclusivity
          cr8_mems_for_pl_arr(pi_pl_arr        => l_pl_arr
                             ,pi_nm_rec        => l_nm_rec
                             ,pi_nte_for_chunk => l_nte_for_edited_datums);
          
          if l_new_pl_2.pl_ne_id is not null
          then
            IF l_new_pl_2.pl_ne_id = l_closing_hist_arr(1).neh_ne_id_new
            THEN
              --pl 2 is on the first new element
              db('pl 2 is on the first new element');
              apply_non_closing_edits(pio_pl                  => l_new_pl_2
                                     ,pi_non_closing_hist_arr => l_ne_1_non_closing_hist_arr);
              
              --set end date for member
              l_nm_rec.nm_end_date := l_new_ne_1_rec.ne_end_date;
            ELSE
              --pl 2 is on the second new element
              db('pl 2 is on the second new element');
              apply_non_closing_edits(pio_pl                  => l_new_pl_2
                                     ,pi_non_closing_hist_arr => l_ne_2_non_closing_hist_arr);
              
              --set end date for member
              l_nm_rec.nm_end_date := l_new_ne_2_rec.ne_end_date;
            END IF;
            
            l_pl_arr := cr8_mems_for_excl_affected(pi_pl    => l_new_pl_2
                                                ,pi_iit_rec => l_rec_iit
                                                ,pi_nit_rec => l_rec_nit
                                                ,pi_nm_rec  => l_nm_rec);
          
            --create mems not affected by exclusivity
            cr8_mems_for_pl_arr(pi_pl_arr        => l_pl_arr
                               ,pi_nm_rec        => l_nm_rec
                               ,pi_nte_for_chunk => l_nte_for_edited_datums);
          end if;
        end loop;
      end if;
      
      --note this date for further processing
      l_date_arr(TO_CHAR(l_edited_date_arr(l_element_arr_idx), c_date_arr_format)) := 1; 
      
      l_element_arr_idx := l_element_arr_idx + 1;
    end loop;
    
    --rejoin member chunks artificially split when processing a merge
    coalesce_members_chunks(pi_iit_ne_id      => p_iit_ne_id
                           ,pi_effective_date => p_effective_date);
    
    ----------------------------------------------------------
    --do other processing at each date we have created members
    ----------------------------------------------------------
    l_date_arr_idx := l_date_arr.first;
    loop
      db('further processing at date ' || l_date_arr_idx);
      l_date_to_process := TO_DATE(l_date_arr_idx, c_date_arr_format);
      
      nm3user.set_effective_date(l_date_to_process);
      
      --copy members to any child items
      db('  dealing with hierarchical');
      deal_with_hierarchical(p_ne_id          => l_rec_iit.iit_ne_id
                            ,p_effective_date => l_date_to_process);
      

      --check for holes
      --get temp ne for location at this date
      db('  create nte for this date');
      nm3extent.create_temp_ne(pi_source_id => p_iit_ne_id
                              ,pi_source    => nm3extent.get_route
                              ,pi_begin_mp  => NULL
                              ,pi_end_mp    => NULL
                              ,po_job_id    => l_loc_at_date_job_id);
      
      db('  checking for holes');
      check_for_holes(pi_nit_rec         => l_rec_nit
                     ,pi_iit_rec         => l_rec_iit
                     ,pi_nte_job_id      => l_loc_at_date_job_id
                     ,pi_effective_date  => l_date_to_process 
                     ,pio_warning_code   => p_warning_code 
                     ,pio_warning_msg    => p_warning_msg);

      db('date processing done');

      exit when l_date_arr_idx = l_date_arr.last;
      l_date_arr_idx := l_date_arr.next(l_date_arr_idx);
    end loop;
  end if;

  reset_for_return;

  db('nm3homo all done');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'homo_update_hist');

EXCEPTION
--
   WHEN g_homo_exception
    THEN
      --
      reset_for_return;
      raise_application_error(g_homo_exc_code, g_homo_exc_msg);
   WHEN others
    THEN
      --
      reset_for_return;
      RAISE;

END homo_update_hist;
--
-----------------------------------------------------------------------------
--
PROCEDURE homo_update(p_temp_ne_id_in  IN     number
                     ,p_iit_ne_id      IN     number
                     ,p_effective_date IN     date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                     ,p_warning_code      OUT varchar2
                     ,p_warning_msg       OUT varchar2
                     ) IS

  c_use_orig_proc CONSTANT BOOLEAN := NVL(hig.get_sysopt(p_option_id => c_force_orig_hu), 'N') = 'Y';

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'homo_update');
  
  IF c_use_orig_proc
  THEN
    --revert to the original proc
    homo_update_old(p_temp_ne_id_in  => p_temp_ne_id_in
                   ,p_iit_ne_id      => p_iit_ne_id
                   ,p_effective_date => p_effective_date
                   ,p_warning_code   => p_warning_code
                   ,p_warning_msg    => p_warning_msg);
  ELSE
    --use new procedure including support for historic location
    homo_update_hist(p_temp_ne_id_in  => p_temp_ne_id_in
                    ,p_iit_ne_id      => p_iit_ne_id
                    ,p_effective_date => p_effective_date
                    ,p_warning_code   => p_warning_code
                    ,p_warning_msg    => p_warning_msg);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'homo_update');

END homo_update;
--
-----------------------------------------------------------------------------
--
FUNCTION has_children (pi_iit_ne_id IN NUMBER) RETURN BOOLEAN IS
--
   CURSOR cs_iig (c_parent_id NUMBER) IS
   SELECT 1
    FROM  dual
   WHERE EXISTS (SELECT 1
                  FROM  NM_INV_ITEM_GROUPINGS
                 WHERE  iig_parent_id = c_parent_id
                );
--
   l_retval BOOLEAN;
   l_dummy  BINARY_INTEGER;
--
BEGIN
--
   OPEN  cs_iig (pi_iit_ne_id);
   FETCH cs_iig INTO l_dummy;
   l_retval := cs_iig%FOUND;
   CLOSE cs_iig;
--
   RETURN l_retval;
--
END has_children;
--
-----------------------------------------------------------------------------
--
FUNCTION has_parent (pi_iit_ne_id IN NUMBER) RETURN BOOLEAN IS
--
   CURSOR cs_iig (c_child_id NUMBER) IS
   SELECT 1
    FROM  dual
   WHERE EXISTS (SELECT 1
                  FROM  NM_INV_ITEM_GROUPINGS
                 WHERE  iig_item_id = c_child_id
                );
--
   l_retval BOOLEAN;
   l_dummy  BINARY_INTEGER;
--
BEGIN
--
   OPEN  cs_iig (pi_iit_ne_id);
   FETCH cs_iig INTO l_dummy;
   l_retval := cs_iig%FOUND;
   CLOSE cs_iig;
--
   RETURN l_retval;
--
END has_parent;
--
-----------------------------------------------------------------------------
--
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
--
-----------------------------------------------------------------------------
--
FUNCTION get_contiguous_warning_const RETURN VARCHAR2 IS
BEGIN
--
   RETURN c_contiguous_warning_code;
--
END get_contiguous_warning_const;
--
-----------------------------------------------------------------------------
--
PROCEDURE deal_with_hierarchical (p_ne_id          NUMBER
                                 ,p_effective_date DATE
                                 ) IS
--
   CURSOR cs_lock (p_ne_id_in NUMBER) IS
   SELECT ROWID
    FROM  NM_MEMBERS
   WHERE  nm_ne_id_in = p_ne_id_in
   FOR UPDATE OF nm_end_date NOWAIT;
--
   l_tab_rowid nm3type.tab_rowid;
   l_rec nm_inv_items%ROWTYPE; -- Log 713421
   l_nit_rec nm_inv_types%ROWTYPE ;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'deal_with_hierarchical');
--
   l_rec := nm3get.get_iit(p_ne_id);                 -- Log 713421
   l_nit_rec := nm3get.get_nit(l_rec.iit_inv_type) ;
   l_par_iit_tab(l_par_iit_tab.count+1) := l_rec ;   -- Log 713421
   IF has_children (p_ne_id)
    THEN
      FOR cs_rec IN (SELECT iit.iit_ne_id
                           ,iit.iit_admin_unit
                           ,iit.iit_inv_type
                           ,itg_relation
                           ,nin_loc_mandatory             -- LOG 713421
                           ,iit_p.iit_inv_type parent_obj -- LOG 713421
                           ,itg_mandatory                 -- LOG 713421
                      FROM  NM_INV_ITEMS iit
                           ,NM_INV_ITEMS iit_p
                           ,NM_INV_TYPE_GROUPINGS
                           ,NM_INV_ITEM_GROUPINGS
                           ,nm_inv_nw   nin    -- LOG 713421         
                     WHERE  iit.iit_ne_id IN (SELECT iig_item_id
                                               FROM  NM_INV_ITEM_GROUPINGS
                                              START WITH iig_parent_id = p_ne_id
                                              CONNECT BY iig_parent_id = PRIOR iig_item_id
                                             )
                      AND   iig_parent_id      = iit_p.iit_ne_id
                      AND   iig_item_id        = iit.iit_ne_id
                      AND   iit.iit_inv_type   = itg_inv_type
                      AND   iit_p.iit_inv_type = itg_parent_inv_type
                      AND   iit.iit_inv_type   = nin_nit_inv_code(+)  -- LOG 713421
                      FOR UPDATE OF iit.iit_ne_id NOWAIT
                    ) -- Get details of all the inv which is located lower in the hierarchy
       LOOP
         --
         DECLARE
            couldnt_care_less EXCEPTION;
         BEGIN
         --          
            IF    cs_rec.itg_relation  = nm3invval.c_none_relation
             THEN  -- If it's a NONE relation when we aren't bothered for moving
               RAISE couldnt_care_less;
            --LOG 713421
            --ELSIF cs_rec.itg_relation != nm3invval.c_at_relation
            ELSIF cs_rec.itg_relation NOT IN ( nm3invval.c_at_relation,nm3invval.c_in_relation,nm3invval.c_derived_relation)
            THEN
                g_homo_exc_code := -20511;
                g_homo_exc_msg  := 'There are child inventory records which would be affected';
                RAISE g_homo_exception;
            END IF;
            -- LOG 713421
            IF  cs_rec.itg_relation IN ( nm3invval.c_in_relation,nm3invval.c_derived_relation)
            AND l_nit_rec.nit_pnt_or_cont = 'C'
            THEN
                DECLARE
                --
                  l_cnt Number ;
                  l_check_fur Boolean := False;
                BEGIN
                --
                   SELECT  count(0) 
                   INTO    l_cnt 
                   FROM    nm_members 
                   WHERE   nm_ne_id_in = cs_rec.iit_ne_id ;
                   IF l_cnt > 0
                   THEN 
                       DECLARE
                       --
                          l_ne_id Number  ;
                       BEGIN
                         --
                          SELECT ne_id INTO l_ne_id
                          FROM
                              (SELECT  x.pl_ne_id ne_id
                               FROM    table(nm3pla.get_ne_intersection( p_ne_id, cs_rec.iit_ne_id).npa_placement_array)  x 
                               )
                          WHERE ne_id IS NOT NULL;
                       EXCEPTION
                          WHEN Others  
                          THEN        
                              l_check_fur := TRUE ;
                              l_child_ne_rec.iit_ne_id       := cs_rec.iit_ne_id;
                              l_child_ne_rec.child_location  := NVL(cs_rec.nin_loc_mandatory,'N');
                              l_child_ne_rec.child_obj_type  := cs_rec.iit_inv_type ;
                              l_child_ne_rec.parent_obj_type := cs_rec.parent_obj ;
                              l_child_ne_rec.rel_mandatory   := Nvl(cs_rec.itg_mandatory,'N') ;
                              l_child_ne_rec.itg_relation    := cs_rec.itg_relation ;
                              l_child_ne_tab(l_child_ne_tab.count+1) :=l_child_ne_rec;
                       END ;
                       IF NOT l_check_fur
                       THEN
                           DECLARE
                           --
                              l_ne_id Number  ;
                           BEGIN
                              --  
                              SELECT ne_id INTO l_ne_id
                              FROM
                                  (SELECT x.pl_ne_id ne_id
                                   FROM   table( NM3PLA.SUBTRACT_PL_FROM_PL( nm3pla.get_ne_intersection( p_ne_id, cs_rec.iit_ne_id ), NM3PLA.GET_PLACEMENT_FROM_NE( p_ne_id )).npa_placement_array) x
                                   )
                              WHERE ne_id IS NOT NULL;   
                              --
                              l_child_ne_rec.iit_ne_id       := cs_rec.iit_ne_id;
                              l_child_ne_rec.child_location  := NVL(cs_rec.nin_loc_mandatory,'N');
                              l_child_ne_rec.child_obj_type  := cs_rec.iit_inv_type ;
                              l_child_ne_rec.parent_obj_type := cs_rec.parent_obj ;
                              l_child_ne_rec.rel_mandatory   := Nvl(cs_rec.itg_mandatory,'N') ;
                              l_child_ne_rec.itg_relation    := cs_rec.itg_relation ;
                              l_child_ne_tab(l_child_ne_tab.count+1) :=l_child_ne_rec;
                           EXCEPTION
                               WHEN No_Data_Found 
                               THEN
                                   Null ;
                               WHEN Others
                               THEN
                               Raise ;
                           END ;
                       END IF ;
                   END IF ;
                END ;   
            --
            ELSE    
               --
               --  Lock it's existing location records
               l_tab_rowid.DELETE;
               OPEN  cs_lock (cs_rec.iit_ne_id);
               FETCH cs_lock BULK COLLECT INTO l_tab_rowid;
               CLOSE cs_lock;
               --
               --  End date it's existing location
               xattr_off;
               FORALL i IN 1..l_tab_rowid.COUNT
               UPDATE NM_MEMBERS
               SET   nm_end_date    = p_effective_date
               WHERE  ROWID          = l_tab_rowid(i);
               xattr_on;
               --
               -- Create it's new location as a copy of the new one
               nm3invval.pc_duplicate_members
                     (pi_parent_ne_id     => p_ne_id
                     ,pi_child_ne_id      => cs_rec.iit_ne_id
                     ,pi_child_inv_type   => cs_rec.iit_inv_type
                     ,pi_child_admin_unit => cs_rec.iit_admin_unit
                     ,pi_child_start_date => p_effective_date
                     );
               --
            END IF ; 
         EXCEPTION
            WHEN couldnt_care_less
             THEN
               NULL;
         END;
         --
      END LOOP;
   END IF;
--
   nm_debug.proc_end(g_package_name,'deal_with_hierarchical');
--
END deal_with_hierarchical;
--
-----------------------------------------------------------------------------
--
FUNCTION get_seq_no_from_orig (nte_ne_id_of  IN NUMBER
                              ,nte_begin_mp  IN NUMBER
                              ,nte_end_mp    IN NUMBER
                              ) RETURN NUMBER IS
   l_retval NUMBER;
   l_pl     NM_PLACEMENT;
BEGIN
   FOR i IN 1..g_orig_new_inv_pl_arr.placement_count
    LOOP
      l_pl := g_orig_new_inv_pl_arr.get_entry(i);
      IF   l_pl.pl_ne_id  = nte_ne_id_of
       AND l_pl.pl_start <= nte_end_mp
       AND l_pl.pl_end   >= nte_begin_mp
       THEN
         l_retval := i;
         EXIT;
      END IF;
   END LOOP;
   RETURN l_retval;
END get_seq_no_from_orig;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_inv_location(pi_iit_ne_id            IN     NM_INV_ITEMS.iit_ne_id%TYPE
                          ,pi_effective_date       IN     DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                          ,pi_check_for_parent     IN     BOOLEAN DEFAULT TRUE
                          ,pi_ignore_item_loc_mand IN     BOOLEAN DEFAULT FALSE
                          ,po_warning_code            OUT VARCHAR2
                          ,po_warning_msg             OUT VARCHAR2
                          ) IS
--
   c_initial_effective_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;

   future_dated exception;
   pragma exception_init( future_dated, -20000 );    
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_inv_location');
--  
   begin
     check_item_has_no_future_locs(pi_iit_ne_id, pi_effective_date );
   exception
     when future_dated then
        hig.raise_ner (pi_appl => nm3type.c_net
                      ,pi_id   => 178
                      );
   end;
--
   --set effective date for this operation
   nm3user.set_effective_date(p_date => pi_effective_date);
--
   nm3extent.create_temp_ne (pi_source_id  => pi_iit_ne_id
                            ,pi_source     => nm3extent.c_route
                            ,pi_begin_mp   => NULL
                            ,pi_end_mp     => NULL
                            ,po_job_id     => l_nte_job_id
                            );
   --
   end_inv_location_by_temp_ne (pi_iit_ne_id            => pi_iit_ne_id
                               ,pi_nte_job_id           => l_nte_job_id
                               ,pi_effective_date       => pi_effective_date
                               ,pi_check_for_parent     => pi_check_for_parent
                               ,pi_ignore_item_loc_mand => pi_ignore_item_loc_mand
                               ,po_warning_code         => po_warning_code
                               ,po_warning_msg          => po_warning_msg
                               );
   --
   --reset effective date
   nm3user.set_effective_date(p_date => c_initial_effective_date);
--
   nm_debug.proc_end(g_package_name,'end_inv_location');
--
EXCEPTION
--
   WHEN OTHERS
    THEN
      --reset effective date
      nm3user.set_effective_date(p_date => c_initial_effective_date);
      RAISE;
--
END end_inv_location;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_inv_location_by_temp_ne (pi_iit_ne_id            IN     NM_INV_ITEMS.iit_ne_id%TYPE
                                      ,pi_nte_job_id           IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                      ,pi_effective_date       IN     DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                      ,pi_check_for_parent     IN     BOOLEAN DEFAULT TRUE
                                      ,pi_ignore_item_loc_mand IN     BOOLEAN DEFAULT FALSE
                                      ,pi_leave_child_items    IN     BOOLEAN DEFAULT FALSE
                                      ,po_warning_code            OUT VARCHAR2
                                      ,po_warning_msg             OUT VARCHAR2
                                      ) IS
--
   CURSOR cs_future_affected_inv(p_iit_ne_id   NM_INV_ITEMS.iit_ne_id%TYPE
                                ,p_eff_date    DATE
                                ,p_nte_job_id  NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                ) IS
   SELECT /*+ INDEX (nm nm_pk) */ 1
    FROM  NM_MEMBERS_ALL     nm
         ,NM_NW_TEMP_EXTENTS nte
   WHERE  nte.nte_job_id      = p_nte_job_id
    AND   nm.nm_ne_id_in      = p_iit_ne_id
    AND   nm.nm_ne_id_of      = nte.nte_ne_id_of
    AND   nm.nm_end_mp       >= nte.nte_begin_mp
    AND   nm.nm_begin_mp     <= nte.nte_end_mp
    AND   nm.nm_start_date   >  p_eff_date;
--
   CURSOR cs_future_affected_children (p_iit_ne_id NM_INV_ITEMS.iit_ne_id%TYPE
                                      ,p_eff_date  DATE
                                      ) IS
   SELECT 1
    FROM  NM_MEMBERS_ALL nm
         ,(SELECT iig_item_id
            FROM  NM_INV_ITEM_GROUPINGS_ALL iig
           CONNECT BY PRIOR iig_item_id = iig_parent_id
           START WITH iig_parent_id = p_iit_ne_id
          )
   WHERE  nm.nm_ne_id_in   = iig_item_id
    AND   nm.nm_start_date > p_eff_date;
--
-- DC cursor changed to select from nm_inv_items_all
-- as the inventory item will be end-dated before this cursor is called
-- if the location to be end-dated spans the entirety of the inventory location
   -- LOG 713421
   CURSOR cs_children(p_iit_ne_id NM_INV_ITEMS.iit_ne_id%TYPE) IS
   SELECT  iig.iig_item_id  child_id
          ,iit_inv_type
          ,nin.nin_loc_mandatory
   FROM    NM_INV_ITEM_GROUPINGS iig
          ,NM_INV_ITEMS
          ,nm_inv_nw nin
   WHERE   iig.iig_parent_id = p_iit_ne_id
   AND     iig.iig_item_id   = iit_ne_id
   AND     iit_inv_type = nin.nin_nit_inv_code(+);
--
   c_initial_effective_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_warning_code VARCHAR2(2000);
   l_warning_msg  VARCHAR2(2000);
--
   l_iit_rec NM_INV_ITEMS%ROWTYPE;
   l_nit_rec NM_INV_TYPES%ROWTYPE;
--
   l_dummy PLS_INTEGER;
--
   l_pl_current   NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
   l_pl_new       NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
   l_pl_to_remove NM_PLACEMENT_ARRAY := nm3pla.initialise_placement_array;
--
   l_new_location_temp_ne  NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_inv_location_by_temp_ne');
--
   get_xattr_status;
--
--   nm_debug.debug('   --set effective date for this operation '||pi_iit_ne_id);
   --set effective date for this operation
   nm3user.set_effective_date(p_date => pi_effective_date);
--
   --get inv item details
   l_iit_rec := nm3inv.get_inv_item(pi_ne_id => pi_iit_ne_id);
   --
   --check inv item exists
   --
   IF l_iit_rec.iit_ne_id IS NULL
   THEN
     g_homo_exc_code := -20502;
     g_homo_exc_msg  := 'No NM_INV_ITEMS record found iit_ne_id= ' || pi_iit_ne_id;
     RAISE g_homo_exception;
   END IF;
--
   --
   --check if end dating location will cause any x-attr validation to fail
   --
   nm3inv_xattr.trap_indep_end_date(pi_ne_id => pi_iit_ne_id);
--
   --
   --get inv type details
   --
   DECLARE
      e_no_nit_found EXCEPTION;
      PRAGMA EXCEPTION_INIT(e_no_nit_found, -20001);
   BEGIN
      l_nit_rec := nm3inv.get_inv_type(pi_inv_type => l_iit_rec.iit_inv_type);
   EXCEPTION
      WHEN e_no_nit_found
       THEN
         g_homo_exc_code := -20509;
         g_homo_exc_msg  := 'No NM_INV_TYPES record found for Inventory type "' || l_iit_rec.iit_inv_type || '"';
         RAISE g_homo_exception;
   END;
--   --
--   --check if location is mandatory
--   --
--   IF nm3inv.inv_location_is_mandatory (pi_inv_type => l_iit_rec.iit_inv_type)
--    AND NOT pi_ignore_item_loc_mand
--    THEN
--      g_homo_exc_code := -20530;
--      g_homo_exc_msg  := 'Location is mandatory for this item or its children.';
--      RAISE g_homo_exception;
--   END IF;
   --
   --check for future affected locations
   --
   OPEN cs_future_affected_inv(p_iit_ne_id  => pi_iit_ne_id
                              ,p_eff_date   => pi_effective_date
                              ,p_nte_job_id => pi_nte_job_id
                              );
   FETCH cs_future_affected_inv INTO l_dummy;
   IF cs_future_affected_inv%FOUND
    THEN
      CLOSE cs_future_affected_inv;
      g_homo_exc_code := -20503;
      g_homo_exc_msg  := 'There are future inventory locations which would be affected.';
      RAISE g_homo_exception;
   END IF;
   CLOSE cs_future_affected_inv;
   --
   --check hierarchy
   --
   IF pi_check_for_parent
     AND (does_relation_exist(p_inv_type => l_iit_rec.iit_inv_type
                             ,p_relation => nm3invval.c_at_relation)
          OR
          does_relation_exist(p_inv_type => l_iit_rec.iit_inv_type
                             ,p_relation => nm3invval.c_in_relation))
     AND has_parent(pi_iit_ne_id => l_iit_rec.iit_ne_id)
   THEN
     g_homo_exc_code := -20531;
     g_homo_exc_msg  := 'Cannot remove inventory locations which are in a Child AT or IN relationship';
     RAISE g_homo_exception;
   END IF;
   --
   --check children
   --
   IF has_children(pi_iit_ne_id => pi_iit_ne_id)
    THEN
      OPEN cs_future_affected_children(p_iit_ne_id => pi_iit_ne_id
                                      ,p_eff_date  => pi_effective_date
                                      );
      FETCH cs_future_affected_children INTO l_dummy;
      IF cs_future_affected_children%FOUND
       THEN
         CLOSE cs_future_affected_children;
         g_homo_exc_code := -20503;
         g_homo_exc_msg  := 'There are future inventory locations which would be affected.';
         RAISE g_homo_exception;
      END IF;
      CLOSE cs_future_affected_children;
   END IF;
   --
   -- All checks done now
   --
   nm3lock.lock_inv_item_and_members (pi_iit_ne_id      => pi_iit_ne_id
                                     ,p_lock_for_update => TRUE
                                     );
--
   l_pl_current   := nm3pla.get_placement_from_ne(pi_iit_ne_id);
   l_pl_to_remove := nm3pla.get_placement_from_temp_ne(pi_nte_job_id);
   l_pl_new       := nm3pla.subtract_pl_from_pl (l_pl_current,l_pl_to_remove);
   --
   IF l_pl_new.is_empty
    THEN
-- nm_debug.debug('      -- If there is no part of the inventory left');
      -- If there is no part of the inventory left
      xattr_off;
      UPDATE NM_MEMBERS
        SET  nm_end_date = pi_effective_date
      WHERE  nm_ne_id_in = pi_iit_ne_id;
      xattr_on;
      --Log 719384:Linesh:13-Mar-09:End
      --Stopped end dating of asset when location is end dated 
      --IF l_nit_rec.nit_end_loc_only = 'N'
      -- THEN
      --   UPDATE NM_INV_ITEMS
      --    SET   iit_end_date = pi_effective_date
      --   WHERE  iit_ne_id    = pi_iit_ne_id;
         
         -- DC end-date any links to parents from this item
--          UPDATE NM_INV_ITEM_GROUPINGS
--          SET    iig_end_date = pi_effective_date
--          WHERE  iig_item_id = pi_iit_ne_id;
      --END IF;
      --Log 719384:Linesh:13-Mar-09:End
   ELSE
-- nm_debug.debug('      nm3extent_o.create_temp_ne_from_pl (l_pl_new,l_new_location_temp_ne);');
      nm3extent_o.create_temp_ne_from_pl (l_pl_new,l_new_location_temp_ne);
-- nm_debug.debug('      homo_update (p_temp_ne_id_in  => l_new_location_temp_ne');
      homo_update (p_temp_ne_id_in  => l_new_location_temp_ne
                  ,p_iit_ne_id      => pi_iit_ne_id
                  ,p_effective_date => pi_effective_date
                  ,p_warning_code   => po_warning_code
                  ,p_warning_msg    => po_warning_msg
                  );
   END IF;
   --
-- nm_debug.debug('#############   --end location of children recursively');
   --end location of children recursively
   IF NOT pi_leave_child_items
    THEN
      FOR l_rec IN cs_children(p_iit_ne_id => pi_iit_ne_id)
       LOOP
--          nm_debug.debug('############# '||l_rec.child_id);
         DECLARE
    --
            l_rec_itg   NM_INV_TYPE_GROUPINGS%ROWTYPE;
            no_end_date EXCEPTION;
    --
         BEGIN
    --
            l_rec_itg := nm3inv.get_itg(pi_inv_type => l_rec.iit_inv_type);
    --
            -- LOG 713421
            IF  l_rec_itg.itg_relation  = nm3invval.c_none_relation
            THEN
               RAISE no_end_date;
            END IF;
            IF  l_rec_itg.itg_relation  IN (nm3invval.c_derived_relation,nm3invval.c_in_relation)                
            AND Nvl(l_rec.nin_loc_mandatory,'N') = 'Y'
            AND Nvl(l_rec_itg.itg_mandatory,'N') = 'N'
            THEN
                UPDATE nm_inv_item_groupings
                SET    iig_end_date = pi_effective_date
                WHERE  iig_item_id  = l_rec.child_id ;
                RAISE no_end_date;    
            ELSIF l_rec_itg.itg_relation  = (nm3invval.c_derived_relation)                
            AND   Nvl(l_rec.nin_loc_mandatory,'N') = 'Y'
            AND   Nvl(l_rec_itg.itg_mandatory,'N') = 'Y'
            THEN
                UPDATE nm_inv_item_groupings
                SET    iig_end_date = pi_effective_date
                WHERE  iig_item_id  = l_rec.child_id ;
            END IF;
            -- LOG 713421
         
--          nm_debug.debug('############# '||'Doing it!');
    --
            end_inv_location_by_temp_ne (pi_iit_ne_id        => l_rec.child_id
                                        ,pi_nte_job_id       => pi_nte_job_id
                                        ,pi_check_for_parent => FALSE
                                        ,po_warning_code     => l_warning_code
                                        ,po_warning_msg      => l_warning_msg
                                        );
--          nm_debug.debug('############# '||'DID it!');
    --
            IF l_warning_code IS NOT NULL
             THEN
               po_warning_code := l_warning_code;
            END IF;
    --
            IF l_warning_msg IS NOT NULL
             THEN
               po_warning_msg := l_warning_msg;
            END IF;
    --
         EXCEPTION
            WHEN no_end_date THEN NULL;
         END;
    --
      END LOOP;
   END IF;
   --
   --
   --give warning if inv type contiguous
   --
   IF l_nit_rec.nit_contiguous = 'Y'
    THEN
      po_warning_code := c_contiguous_warning_code;
      po_warning_msg  := NULL;
   END IF;
   --
   --reset effective date
   nm3user.set_effective_date(p_date => c_initial_effective_date);
   xattr_on;
   --
   nm_debug.proc_end(g_package_name,'end_inv_location_by_temp_ne');
   --
EXCEPTION
   WHEN g_homo_exception
    THEN
      --reset effective date
      nm3user.set_effective_date(p_date => c_initial_effective_date);
      xattr_on;
      RAISE_APPLICATION_ERROR(g_homo_exc_code, g_homo_exc_msg);
   WHEN OTHERS
    THEN
      --reset effective date
      nm3user.set_effective_date (c_initial_effective_date);
      xattr_on;
      RAISE;
END end_inv_location_by_temp_ne;
--
-----------------------------------------------------------------------------
--
--PROCEDURE end_date_dependent_inventory (pi_iit_ne_id  IN nm_inv_items.iit_ne_id%TYPE
--                                       ,pi_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
--                                       ) IS
----
--   l_inv_type nm_inv_types.nit_inv_type%TYPE;
----
--   CURSOR cs_nxl (c_inv_type nm_inv_types.nit_inv_type%TYPE) IS
--   SELECT *
--    FROM  nm_x_location_rules
--   WHERE  nxl_indep_type = c_inv_type;
----
--   TYPE tab_nxl IS TABLE OF nm_x_location_rules%ROWTYPE INDEX BY BINARY_INTEGER;
--   l_tab_nxl tab_nxl;
----
--   l_existing_pl  nm_placement_array;
--   l_new_pl       nm_placement_array;
--   l_end_dated_pl nm_placement_array;
----
--BEGIN
----
--   nm_debug.proc_start(g_package_name,'end_date_dependent_inventory');
----
--   l_inv_type := nm3inv.get_inv_type(pi_iit_ne_id);
----
--   FOR cs_rec IN cs_nxl(l_inv_type)
--    LOOP
--      l_tab_nxl(cs_nxl%ROWCOUNT) := cs_rec;
--   END LOOP;
----
--   DECLARE
--      not_an_independent    EXCEPTION;
--      no_locations_affected EXCEPTION;
--   BEGIN
--      --
--      IF l_tab_nxl.COUNT = 0
--       THEN
--         RAISE not_an_independent;
--      END IF;
--      --
--      l_existing_pl  := nm3pla.get_placement_from_ne      (pi_iit_ne_id);
--      l_new_pl       := nm3pla.get_placement_from_temp_ne (pi_nte_job_id);
--      l_end_dated_pl := nm3pla.subtract_pl_from_pl        (l_existing_pl,l_new_pl);
--      --
--      IF l_end_dated_pl.is_empty
--       THEN
--         RAISE no_locations_affected;
--      END IF;
--      --
--   EXCEPTION
--      WHEN not_an_independent
--       OR  no_locations_affected
--       THEN
--         Null;
--   END;
----
--   nm_debug.proc_end(g_package_name,'end_date_dependent_inventory');
----
--END end_date_dependent_inventory;
--
-----------------------------------------------------------------------------
--
FUNCTION future_affected_inv_exists (p_nte_job_id     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                    ,p_inv_type       NM_MEMBERS.nm_obj_type%TYPE
                                    ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                    ) RETURN BOOLEAN IS
BEGIN
   RETURN get_future_affected_inv (p_nte_job_id
                                  ,p_inv_type
                                  ,p_effective_date
                                  ).COUNT > 0;
END future_affected_inv_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION get_future_affected_inv (p_nte_job_id     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                 ,p_inv_type       NM_MEMBERS.nm_obj_type%TYPE
                                 ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 ) RETURN nm3type.tab_number IS
--
   CURSOR cs_future_affected_inv_cont
                (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                ,c_inv_type   NM_MEMBERS.nm_obj_type%TYPE
                ,c_eff_date   DATE
                ) IS
   SELECT /*+ RULE */ nm_ne_id_in
    FROM  NM_MEMBERS_ALL
         ,NM_NW_TEMP_EXTENTS
   WHERE  nte_job_id        = c_nte_job_id
    AND   nte_ne_id_of      = nm_ne_id_of
    AND   nte_begin_mp      < nm_end_mp
    AND   nte_end_mp        > nm_begin_mp
    AND   nm_type           = 'I'
    AND   nm_obj_type||NULL = c_inv_type
    AND   nm_start_date     >  c_eff_date;

   CURSOR cs_future_affected_inv_point
                (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                ,c_inv_type   NM_MEMBERS.nm_obj_type%TYPE
                ,c_eff_date   DATE
                ) IS
   SELECT /*+ RULE */ nm_ne_id_in
    FROM  NM_MEMBERS_ALL
         ,NM_NW_TEMP_EXTENTS
   WHERE  nte_job_id        = c_nte_job_id
    AND   nte_ne_id_of      = nm_ne_id_of
    AND   nte_begin_mp      = nm_end_mp
    AND   nte_end_mp        = nm_begin_mp
    AND   nm_type           = 'I'
    AND   nm_obj_type||NULL = c_inv_type
    AND   nm_start_date     >  c_eff_date;

--
   l_tab_ne_id_in nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_future_affected_inv');
--
--   nm_debug.debug ('p_nte_job_id     : '||p_nte_job_id);
--   nm_debug.debug ('p_inv_type       : '||p_inv_type);
--   nm_debug.debug ('p_effective_date : '||p_effective_date);
--   nm3extent.debug_temp_extents (p_nte_job_id);
--
   IF nm3inv.get_nit_pnt_or_cont(p_inv_type) = 'C'
     THEN
       OPEN  cs_future_affected_inv_cont (p_nte_job_id
                                         ,p_inv_type
                                         ,p_effective_date
                                         );

       FETCH cs_future_affected_inv_cont
        BULK COLLECT
        INTO l_tab_ne_id_in;
       CLOSE cs_future_affected_inv_cont;
   ELSE
       OPEN  cs_future_affected_inv_point (p_nte_job_id
                                         ,p_inv_type
                                         ,p_effective_date
                                         );

       FETCH cs_future_affected_inv_point
        BULK COLLECT
        INTO l_tab_ne_id_in;
       CLOSE cs_future_affected_inv_point;

   END IF;
--
--   FOR i iN 1..l_tab_ne_id_in.COUNT
--    LOOP
--      nm_debug.debug(i||'.'||l_tab_ne_id_in(i));
--   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_future_affected_inv');
--
   RETURN l_tab_ne_id_in;
--
END get_future_affected_inv;
--
-----------------------------------------------------------------------------
--
FUNCTION is_affected_by_exclusivity (p_iit_ne_id NM_INV_ITEMS.iit_ne_id%TYPE
                                    ,p_rec_iit   NM_INV_ITEMS%ROWTYPE
                                    ,p_exclusive BOOLEAN
                                    ,p_x_sect    BOOLEAN
                                    ) RETURN BOOLEAN IS
--
   l_retval  BOOLEAN;
   l_tab_ita nm3inv.tab_nita;
--
   -- Store the globals away in case they are being used elsewhere
   l_temp_rec_iit   CONSTANT NM_INV_ITEMS%ROWTYPE        := g_rec_iit;
   l_temp_iit_ne_id CONSTANT NM_INV_ITEMS.iit_ne_id%TYPE := g_iit_ne_id;
   l_temp_found     CONSTANT BOOLEAN                     := g_found;
--
   PROCEDURE append (p_text VARCHAR2
                    ,p_nl   BOOLEAN DEFAULT TRUE
                    ) IS
   BEGIN
      nm3ddl.append_tab_varchar(g_tab_vc,p_text,p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'is_affected_by_exclusivity');
--
   DECLARE
      l_not_affected EXCEPTION;
   BEGIN
   --
      IF NOT p_exclusive
       THEN
         RAISE l_not_affected;
      END IF;
   --
      IF p_rec_iit.iit_inv_type != g_tab_vc_inv_type
       THEN
         --
         -- Only rebuild this if the inv type is different from the last time
         --
         g_tab_vc_inv_type := p_rec_iit.iit_inv_type;
         g_tab_vc.DELETE;
   --
         append ('DECLARE',FALSE);
         append ('   CURSOR cs_inv IS');
         append ('   SELECT 1');
         append ('    FROM  nm_inv_items_all'); -- Select from _ALL so that we can check future ones
                                                -- Given that we're going in by IIT_NE_ID, there'll still just be a single match
         append ('   WHERE  iit_ne_id  = '||g_package_name||'.g_iit_ne_id');
      --
         IF p_x_sect
          THEN
            append('     AND   iit_x_sect = '||g_package_name||'.g_rec_iit.iit_x_sect');
         END IF;
      --
         l_tab_ita := nm3inv.get_tab_ita_exclusive (p_inv_type => p_rec_iit.iit_inv_type);
      --
         FOR i IN 1..l_tab_ita.COUNT
          LOOP
            append('     AND   '||l_tab_ita(i).ita_attrib_name||' = '||g_package_name||'.g_rec_iit.'||l_tab_ita(i).ita_attrib_name);
         END LOOP;
      --
         append (';',FALSE); -- Put the semi-colon at the end of the last line of the where clause
         append ('   l_dummy PLS_INTEGER;');
         append ('BEGIN');
         append ('   OPEN  cs_inv;');
         append ('   FETCH cs_inv INTO l_dummy;');
         append ('   '||g_package_name||'.g_found := cs_inv%FOUND;');
         append ('   CLOSE cs_inv;');
         append ('END;');
      END IF;
--
      g_rec_iit   := p_rec_iit;
      g_iit_ne_id := p_iit_ne_id;
--
      nm3ddl.execute_tab_varchar(g_tab_vc);
   --
      l_retval := g_found;
   --
   EXCEPTION
      WHEN l_not_affected
       THEN
         l_retval := FALSE;
   END;
--
   -- Restore the values which were in the globals
   g_rec_iit   := l_temp_rec_iit;
   g_iit_ne_id := l_temp_iit_ne_id;
   g_found     := l_temp_found;
--
   nm_debug.proc_end(g_package_name,'is_affected_by_exclusivity');
--
   RETURN l_retval;
--
END is_affected_by_exclusivity;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_xattr_status IS
BEGIN
   c_xattr_status  := nm3inv_xattr.g_xattr_active;
END get_xattr_status;
--
-----------------------------------------------------------------------------
--
PROCEDURE xattr_off IS
BEGIN
   nm3inv_xattr.g_xattr_active := FALSE;
END xattr_off;
--
-----------------------------------------------------------------------------
--
PROCEDURE xattr_on IS
BEGIN
   nm3inv_xattr.g_xattr_active := c_xattr_status;
END xattr_on;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_temp_ne_for_pnt_or_cont (pi_nte_job_id  NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                        ,pi_pnt_or_cont NM_INV_TYPES.nit_pnt_or_cont%TYPE
                                        ) IS
--
   CURSOR cs_check_cont  (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  NM_NW_TEMP_EXTENTS
                  WHERE  nte_job_id   = c_nte_job_id
                   AND   nte_begin_mp = nte_end_mp
                 );
--
   CURSOR cs_check_point (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  NM_NW_TEMP_EXTENTS
                  WHERE  nte_job_id    = c_nte_job_id
                   AND   nte_begin_mp != nte_end_mp
                 );
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'check_temp_ne_for_pnt_or_cont');
--
   IF pi_pnt_or_cont = 'C'
    THEN
      OPEN  cs_check_cont  (pi_nte_job_id);
      FETCH cs_check_cont  INTO l_dummy;
      l_found := cs_check_cont%FOUND;
      CLOSE cs_check_cont;
      IF l_found
       THEN
         hig.raise_ner (pi_appl  => nm3type.c_net
                       ,pi_id    => 86
                       );
      END IF;
   ELSE
      OPEN  cs_check_point (pi_nte_job_id);
      FETCH cs_check_point INTO l_dummy;
      l_found := cs_check_point%FOUND;
      CLOSE cs_check_point;
      IF l_found
       THEN
         hig.raise_ner (pi_appl  => nm3type.c_net
                       ,pi_id    => 105
                       );
      END IF;
   END IF;
--
   nm_debug.proc_end (g_package_name,'check_temp_ne_for_pnt_or_cont');
--
END check_temp_ne_for_pnt_or_cont;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_item_has_no_future_locs (p_iit_ne_id      nm_inv_items.iit_ne_id%TYPE
                                        ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                        ) IS
--
   CURSOR cs_future_locs (c_nm_ne_id_in    nm_members_all.nm_ne_id_in%TYPE
                         ,c_effective_date DATE
                         ) IS
   SELECT 1
    FROM  nm_members_all nm
   WHERE  nm_ne_id_in   = c_nm_ne_id_in
    AND   nm_start_date > c_effective_date
    AND   ROWNUM        = 1;
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'check_item_has_no_future_locs');
--
   OPEN  cs_future_locs (p_iit_ne_id, p_effective_date);
   FETCH cs_future_locs INTO l_dummy;
   l_found := cs_future_locs%FOUND;
   CLOSE cs_future_locs;
--
   IF l_found
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 355
                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'check_item_has_no_future_locs');
--
END check_item_has_no_future_locs;
--
-----------------------------------------------------------------------------
--
PROCEDURE historic_locate_init(pi_effective_date in date
                              ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'historic_locate_init');

  if c_hist_loc_enabled
  then
    --set the effective date to the start date of the load
    --this ensures we get the correct network at that date
    nm3user.set_effective_date(p_date => pi_effective_date);
  end if;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'historic_locate_init');

END historic_locate_init;
--
-----------------------------------------------------------------------------
--
PROCEDURE historic_locate_validation(pi_nte_job_id   in nm_nw_temp_extents.nte_job_id%type
                                    ,pi_user_ne_id   IN nm_elements.ne_id%TYPE DEFAULT NULL
                                    ,pi_user_ne_type in nm_elements.ne_type%type default null
                                    ) IS

  e_locate_blocked exception;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'historic_locate_validation');

  IF c_hist_loc_enabled
    AND nm3net_history.nte_has_non_blocking_edits(pi_nte_job_id => pi_nte_job_id)
  THEN
    if nm3net_history.nte_has_blocking_edits(pi_nte_job_id => pi_nte_job_id)
    then
      --elements in extent have been edited and at the time of this location
      --also were subject to error correcting edits.
      --therefore prevent the location
      RAISE e_locate_blocked;
    end if;
    
    if pi_user_ne_id is not null
      and pi_user_ne_type = 'G'
      and nm3net_history.group_has_blocking_edits(pi_ne_id => pi_user_ne_id)
    then
      raise e_locate_blocked;
    end if;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'historic_locate_validation');

exception
  when e_locate_blocked
  then
    hig.raise_ner(pi_appl => nm3type.c_net
                 ,pi_id   => 451);

END historic_locate_validation;
--
-----------------------------------------------------------------------------
--
PROCEDURE historic_locate_post(pi_init_effective_date in date
                              ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'historic_locate_post');

  nm3user.set_effective_date(p_date => pi_init_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'historic_locate_post');

END historic_locate_post;
--
-----------------------------------------------------------------------------
--
PROCEDURE remove_element_from_nte(pi_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                                 ,pi_ne_id  IN nm_elements.ne_id%TYPE
                                 ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'remove_element_from_nte');

  DELETE
    nm_nw_temp_extents nte
  WHERE
    nte.nte_job_id = pi_job_id
  AND
    nte.nte_ne_id_of = pi_ne_id;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'remove_element_from_nte');

END remove_element_from_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION translate_location_in_time(pi_job_id      IN nm_nw_temp_extents.nte_job_id%TYPE
                                   ,pi_target_date IN date
                                   ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS

  c_target_date CONSTANT date := TRUNC(pi_target_date); 
  
  l_target_job_id nm_nw_temp_extents.nte_job_id%TYPE := nm3seq.next_nte_id_seq;
  
  l_edited_ne_id_arr     nm3net_history.t_neh_ne_id_old_arr;
  l_edited_operation_arr nm3net_history.t_neh_operation_arr;
  l_edited_date_arr      nm3net_history.t_neh_effective_date_arr;
  
  l_element_arr_idx PLS_INTEGER;
  
  l_closing_hist_arr          nm3net_history.t_neh_rec_arr;
  l_ne_1_closing_hist_arr     nm3net_history.t_neh_rec_arr;
  l_ne_2_closing_hist_arr     nm3net_history.t_neh_rec_arr;
  l_ne_1_non_closing_hist_arr nm3net_history.t_neh_rec_arr;
  l_ne_2_non_closing_hist_arr nm3net_history.t_neh_rec_arr;
  
  l_locs_on_element_arr nm3extent.tab_nte;
  
  l_new_ne_1_rec nm_elements%ROWTYPE;
  l_new_ne_2_rec nm_elements%ROWTYPE;
  
  l_new_pl_1 nm_placement;
  l_new_pl_2 nm_placement;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'translate_location_in_time');

  g_debug_on := TRUE;
  
  db('translate_location_in_time');
  
  --create copy of temp extent
  l_target_job_id := create_duplicate_nte(pi_nte_id => pi_job_id);
  
  --get list of edited datums in temp extent
  nm3net_history.get_edited_datums_in_nte(pi_nte_id               => l_target_job_id
                                         ,po_edited_ne_id_arr     => l_edited_ne_id_arr
                                         ,po_edited_operation_arr => l_edited_operation_arr
                                         ,po_edited_date_arr      => l_edited_date_arr);
  
  db('l_edited_ne_id_arr.COUNT = ' || l_edited_ne_id_arr.COUNT);
  
  IF l_edited_ne_id_arr.COUNT > 0
  THEN
    l_element_arr_idx := 1;
    
    ---------------------------
    --process each edited datum
    ---------------------------
    WHILE NOT l_element_arr_idx > l_edited_ne_id_arr.COUNT
    LOOP
      db('in loop idx ' || l_element_arr_idx);
      db('element idx ' || l_element_arr_idx 
         || ' ne_id=' || l_edited_ne_id_arr(l_element_arr_idx)
         || ' operation=' || l_edited_operation_arr(l_element_arr_idx)
         || ' date=' || TO_CHAR(l_edited_date_arr(l_element_arr_idx), 'DD-MON-YYYY'));
         
      IF l_edited_date_arr(l_element_arr_idx) < c_target_date
      THEN
        --edit affects location we are interested in
        IF l_edited_operation_arr(l_element_arr_idx) <> nm3net_history.c_neh_op_close
        THEN
          ---------------------------
          --get old element details
          -------------------------
          db('get old element details');
          --get details of edit that closed the element
          l_closing_hist_arr := nm3net_history.get_neh_for_closing_op(pi_ne_id => l_edited_ne_id_arr(l_element_arr_idx));
          
          db('l_closing_hist_arr.count = ' || l_closing_hist_arr.COUNT);
      
          IF l_closing_hist_arr.COUNT = 0
          THEN
               hig.raise_ner(pi_appl               => 'HIG'
                            ,pi_id                 => 67
                            ,pi_supplementary_info => 'NM_ELEMENT_HISTORY closing op for ne_id ' || TO_CHAR(l_edited_ne_id_arr(l_element_arr_idx)));
          END IF;
          
          --get all chunks of location on the closed element
          db('get all chunks of location on the closed element');
          l_locs_on_element_arr := get_locs_on_element(pi_ne_id      => l_edited_ne_id_arr(l_element_arr_idx)
                                                      ,pi_nte_job_id => l_target_job_id);
          
          db('got ' || l_locs_on_element_arr.COUNT || ' chunks');
          
          -------------------------
          --get new element details
          -------------------------
          l_new_ne_1_rec := nm3get.get_ne(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new);
          
          --get non-closing edits to apply on new element
          db('get non-closing edits to apply on new element');
          l_ne_1_non_closing_hist_arr := nm3net_history.get_neh_for_non_closing_ops(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new);
          
          --get closing op if they exist
          l_ne_1_closing_hist_arr := nm3net_history.get_neh_for_closing_op(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new);
          
          IF l_ne_1_closing_hist_arr.COUNT > 0
          THEN
            --add to end of element array
            db('add to end of element array - ' || l_closing_hist_arr(1).neh_ne_id_new);
            l_edited_ne_id_arr(l_edited_ne_id_arr.COUNT + 1) := l_ne_1_closing_hist_arr(1).neh_ne_id_old;
            l_edited_operation_arr(l_edited_ne_id_arr.COUNT) := l_ne_1_closing_hist_arr(1).neh_operation;
            l_edited_date_arr(l_edited_ne_id_arr.COUNT) := l_ne_1_closing_hist_arr(1).neh_effective_date;
          END IF;
          
          IF l_closing_hist_arr(1).neh_operation = nm3net_history.c_neh_op_split
          THEN
            db('split so get second new element');
            l_new_ne_2_rec := nm3get.get_ne(pi_ne_id => l_closing_hist_arr(2).neh_ne_id_new);
            --get non-closing edits to apply for 2nd element
            l_ne_2_non_closing_hist_arr := nm3net_history.get_neh_for_non_closing_ops(pi_ne_id => l_closing_hist_arr(2).neh_ne_id_new);
            
            --get closing op if they exist
            l_ne_2_closing_hist_arr := nm3net_history.get_neh_for_closing_op(pi_ne_id => l_closing_hist_arr(2).neh_ne_id_new);
            
            IF l_ne_2_closing_hist_arr.COUNT > 0
            THEN
              --add to end of element array
              db('add to end of element array - ' || l_closing_hist_arr(2).neh_ne_id_new);
              l_edited_ne_id_arr(l_edited_ne_id_arr.COUNT + 1) := l_ne_2_closing_hist_arr(2).neh_ne_id_old;
              l_edited_operation_arr(l_edited_ne_id_arr.COUNT) := l_ne_2_closing_hist_arr(2).neh_operation;
              l_edited_date_arr(l_edited_ne_id_arr.COUNT) := l_ne_2_closing_hist_arr(2).neh_effective_date;
            END IF;
          END IF;
          
          ----------------------
          --derive new locations
          ----------------------
          FOR i IN 1..l_locs_on_element_arr.COUNT
          LOOP
            db('processing chunk - ' || l_locs_on_element_arr(i).nte_ne_id_of 
               || ':' || l_locs_on_element_arr(i).nte_begin_mp
               || ':' || l_locs_on_element_arr(i).nte_end_mp);
               
            --get initial placement(s)
            CASE 
              WHEN l_edited_operation_arr(l_element_arr_idx) = nm3net_history.c_neh_op_split
              THEN
                process_split(pi_begin_mp           => l_locs_on_element_arr(i).nte_begin_mp
                             ,pi_end_mp             => l_locs_on_element_arr(i).nte_end_mp
                             ,pi_new_ne_1_id        => l_closing_hist_arr(1).neh_ne_id_new
                             ,pi_new_ne_1_length    => l_closing_hist_arr(1).neh_new_ne_length
                             ,pi_new_ne_2_id        => l_closing_hist_arr(2).neh_ne_id_new
                             ,pi_new_ne_2_length    => l_closing_hist_arr(2).neh_new_ne_length
                             ,po_new_pl_1           => l_new_pl_1
                             ,po_new_pl_2           => l_new_pl_2);
                       
              WHEN l_edited_operation_arr(l_element_arr_idx) = nm3net_history.c_neh_op_merge
              THEN
                process_merge(pi_begin_mp         => l_locs_on_element_arr(i).nte_begin_mp
                             ,pi_end_mp           => l_locs_on_element_arr(i).nte_end_mp
                             ,pi_old_ne_length    => l_closing_hist_arr(1).neh_old_ne_length
                             ,pi_element_in_merge => l_closing_hist_arr(1).neh_param_1
                             ,pi_new_ne_id        => l_closing_hist_arr(1).neh_ne_id_new
                             ,pi_new_ne_length    => l_closing_hist_arr(1).neh_new_ne_length
                             ,po_new_pl           => l_new_pl_1);
                       
              WHEN l_edited_operation_arr(l_element_arr_idx) = nm3net_history.c_neh_op_reverse
              THEN
                l_new_pl_1 := nm3pla.initialise_placement(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new
                                                         ,pi_start => l_closing_hist_arr(1).neh_old_ne_length - l_locs_on_element_arr(i).nte_end_mp
                                                         ,pi_end   => l_closing_hist_arr(1).neh_old_ne_length - l_locs_on_element_arr(i).nte_begin_mp);
              
              WHEN l_edited_operation_arr(l_element_arr_idx) IN (nm3net_history.c_neh_op_replace
                                                                ,nm3net_history.c_neh_op_reclassify)
              THEN
                l_new_pl_1 := nm3pla.initialise_placement(pi_ne_id => l_closing_hist_arr(1).neh_ne_id_new
                                                         ,pi_start => l_locs_on_element_arr(i).nte_begin_mp
                                                         ,pi_end   => l_locs_on_element_arr(i).nte_end_mp);
              ELSE
                hig.raise_ner(pi_appl               => nm3type.c_hig
                             ,pi_id                 => 110
                             ,pi_supplementary_info => 'nm3homo: closing neh operation "' || l_edited_operation_arr(l_element_arr_idx) || '"');
            END CASE;
            
            db('pl 1 ' || l_new_pl_1.pl_ne_id || ':' || l_new_pl_1.pl_start || ':' || l_new_pl_1.pl_end);
            db('pl 2 ' || l_new_pl_2.pl_ne_id || ':' || l_new_pl_2.pl_start || ':' || l_new_pl_2.pl_end);
          
            -------------------------
            --apply non-closing edits
            -------------------------
            IF l_new_pl_1.pl_ne_id = l_closing_hist_arr(1).neh_ne_id_new
            THEN
              --pl 1 is on the first new element
              db('pl 1 is on the first new element');
              apply_non_closing_edits(pio_pl                  => l_new_pl_1
                                     ,pi_non_closing_hist_arr => l_ne_1_non_closing_hist_arr);
            ELSE
              --pl 1 is on the second new element
              db('pl 1 is on the second new element');
              apply_non_closing_edits(pio_pl                  => l_new_pl_1
                                     ,pi_non_closing_hist_arr => l_ne_2_non_closing_hist_arr); 
            END IF;
            
            --add new location to temp extent
            add_pl_to_nte(pi_pl         => l_new_pl_1
                         ,pi_nte_job_id => l_target_job_id);
            
            IF l_new_pl_2.pl_ne_id IS NOT NULL
            THEN
              IF l_new_pl_2.pl_ne_id = l_closing_hist_arr(1).neh_ne_id_new
              THEN
                --pl 2 is on the first new element
                db('pl 2 is on the first new element');
                apply_non_closing_edits(pio_pl                  => l_new_pl_2
                                       ,pi_non_closing_hist_arr => l_ne_1_non_closing_hist_arr);
              ELSE
                --pl 2 is on the second new element
                db('pl 2 is on the second new element');
                apply_non_closing_edits(pio_pl                  => l_new_pl_2
                                       ,pi_non_closing_hist_arr => l_ne_2_non_closing_hist_arr);
              END IF;
              
              --add new location to temp extent
              add_pl_to_nte(pi_pl         => l_new_pl_2
                           ,pi_nte_job_id => l_target_job_id);
            END IF;          
          END LOOP;
        END IF;
        
        ---------------------------------
        --remove chunks on edited element
        ---------------------------------
        remove_element_from_nte(pi_job_id => l_target_job_id
                               ,pi_ne_id  => l_edited_ne_id_arr(l_element_arr_idx));
      END IF;
      
      l_element_arr_idx := l_element_arr_idx + 1;
    END LOOP;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'translate_location_in_time');

  RETURN l_target_job_id;

END translate_location_in_time;
--
-----------------------------------------------------------------------------
--
END nm3homo;
/
