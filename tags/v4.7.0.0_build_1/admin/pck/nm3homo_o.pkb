CREATE OR REPLACE PACKAGE BODY nm3homo_o AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3homo_o.pkb-arc   2.3   Jul 04 2013 16:04:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3homo_o.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:12  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   Homogenous Inventory Update Object package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3homo_o';
--
   l_warning_code       VARCHAR2(4000);
   l_warning_msg        VARCHAR2(4000);
--
-----------------------------------------------------------------------------
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
-----------------------------------------------------------------------------
--

FUNCTION get_inv_in_pl_by_obj_type
                       (p_placement_array  nm_placement_array
                       ,p_nm_obj_type      nm_members.nm_obj_type%TYPE
                       ) RETURN nm3type.tab_number IS
--
   CURSOR cs_matches (c_obj_type nm_members.nm_obj_type%TYPE) IS
   SELECT /*+ RULE */
          nm.nm_ne_id_in
    FROM  TABLE(CAST(p_placement_array.npa_placement_array AS nm_placement_array_type)) pl
         ,nm_members  nm
   WHERE  nm.nm_ne_id_of        = pl.pl_ne_id
    AND   nm.nm_obj_type        = c_obj_type
    AND  (nm.nm_begin_mp        < pl.pl_end
         OR (nm.nm_begin_mp     = pl.pl_end
             AND nm.nm_begin_mp = nm.nm_end_mp
            )
         )
   GROUP BY nm.nm_ne_id_in;
--
   l_tab_ne_id_in nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_inv_in_pl_by_obj_type');
--
   OPEN  cs_matches (p_nm_obj_type);
   FETCH cs_matches BULK COLLECT INTO l_tab_ne_id_in;
   CLOSE cs_matches;
--
   nm_debug.proc_end(g_package_name,'get_inv_in_pl_by_obj_type');
--
   RETURN l_tab_ne_id_in;
--
END get_inv_in_pl_by_obj_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_location_by_pl_and_objtype
                       (p_placement_array  nm_placement_array
                       ,p_nm_obj_type      nm_members.nm_obj_type%TYPE
                       ,p_effective_date   DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                       ) IS
--
   l_tab_ne_id_in nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_location_by_pl_and_objtype');
--
   l_tab_ne_id_in := get_inv_in_pl_by_obj_type (p_placement_array,p_nm_obj_type);
--
   FOR i IN 1..l_tab_ne_id_in.COUNT
    LOOP
      end_inv_location_in_pl (l_tab_ne_id_in(i), p_placement_array, p_effective_date);
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'end_location_by_pl_and_objtype');
--
END end_location_by_pl_and_objtype;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_inv_location_in_pl (p_nm_ne_id_in      nm_members.nm_ne_id_in%TYPE
                                 ,p_placement_array  nm_placement_array
                                 ,p_effective_date   DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 ) IS
--
   l_pl_before nm_placement_array := nm3pla.initialise_placement_array;
   l_pl_after  nm_placement_array := nm3pla.initialise_placement_array;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_inv_location_in_pl');
--
   DECLARE
      l_nothing_else_to_do EXCEPTION;
   BEGIN
      --
      IF p_placement_array.is_empty
       THEN
         RAISE l_nothing_else_to_do;
      END IF;
      --
      l_pl_before := nm3pla.get_placement_from_ne (p_nm_ne_id_in);
      --
      IF l_pl_before.is_empty
       THEN
         RAISE l_nothing_else_to_do;
      END IF;
      --
      l_pl_after := nm3pla.subtract_pl_from_pl (l_pl_before,p_placement_array);
      --
      IF l_pl_after.is_empty
       THEN
         -- If this was the whole location of the inventory
         nm3homo.end_inv_location (pi_iit_ne_id            => p_nm_ne_id_in
                                  ,pi_effective_date       => p_effective_date
                                  ,pi_check_for_parent     => FALSE
                                  ,pi_ignore_item_loc_mand => TRUE
                                  ,po_warning_code         => l_warning_code
                                  ,po_warning_msg          => l_warning_msg
                                  );
         -- Nothing else to do, so just finish
         RAISE l_nothing_else_to_do;
      END IF;
      --
   EXCEPTION
      WHEN l_nothing_else_to_do
       THEN
         Null;
   END;
--
   nm_debug.proc_end(g_package_name,'end_inv_location_in_pl');
--
END end_inv_location_in_pl;
--
-----------------------------------------------------------------------------
--
PROCEDURE relocate_inv_at_pl (p_nm_ne_id_in      nm_members.nm_ne_id_in%TYPE
                             ,p_placement_array  nm_placement_array
                             ,p_effective_date   DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                             ) IS
--
   c_effective_date  CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_pl              nm_placement;
   l_rec_iit         nm_inv_items%ROWTYPE;
--
   l_tab_nm_ne_id_of nm3type.tab_number;
   l_tab_nm_begin_mp nm3type.tab_number;
   l_tab_nm_end_mp   nm3type.tab_number;
   l_tab_nm_seq_no   nm3type.tab_number;
--
   l_existing_pl     nm_placement_array;
--
   l_count           PLS_INTEGER := 0;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'relocate_inv_at_pl');
--
   --
   -- Set effective date to passed date
   --
   nm3user.set_effective_date (p_effective_date);
   --
   -- Check to make sure there's no future location changes for this inventory item
   --  across this location
   --
   IF future_affected_inv_exists (p_placement_array => p_placement_array
                                 ,p_iit_ne_id       => p_nm_ne_id_in
                                 ,p_effective_date  => p_effective_date
                                 )
    THEN
      -- Future inventory exists so stop this from continuing
      hig.raise_ner (nm3type.c_net,178);
   END IF;
   --
   -- Get the NM_INV_ITEMS record
   --
   l_rec_iit := nm3inv.get_inv_item (p_nm_ne_id_in);
   --
   -- Attempt to lock (and kick the tires of) the inventory record
   --
   nm3lock.lock_inv_item (pi_iit_ne_id      => p_nm_ne_id_in
                         ,p_lock_for_update => TRUE
                         );
   --
   -- If the new location for this item is null (empty placement array)
   --  then call the end location procedure in nm3homo, so this will deal
   --  with potentially end-dating the item record as well for us
   --
   IF p_placement_array.is_empty
    THEN
      --
      nm3homo.end_inv_location (pi_iit_ne_id            => p_nm_ne_id_in
                               ,pi_effective_date       => p_effective_date
                               ,pi_check_for_parent     => FALSE
                               ,pi_ignore_item_loc_mand => TRUE
                               ,po_warning_code         => l_warning_code
                               ,po_warning_msg          => l_warning_msg
                               );
      --
   ELSE
      --
      -- Get the existing location of the item
      --
      l_existing_pl := nm3pla.get_placement_from_ne (p_nm_ne_id_in);
      --
      -- Make sure they aren't trying to locate the inventory somewhere where
      --  it wasn't already (i.e. only allow this to shrink the location)
      --
--      IF  l_existing_pl.is_empty
--       OR NOT nm3pla.subtract_pl_from_pl (p_placement_array,l_existing_pl).is_empty
--       THEN
--         hig.raise_ner(nm3type.c_net,1); -- ########################################################
--      END IF;
      --
      -- End Date all existing membership records
      --
      UPDATE nm_members
       SET   nm_end_date = p_effective_date
      WHERE  nm_ne_id_in = p_nm_ne_id_in;
      --
      -- Populate simple arrays for the item's new location
      --
      FOR i IN 1..p_placement_array.placement_count
       LOOP
         --
         l_pl := p_placement_array.get_entry(i);
         --
         IF l_pl.pl_ne_id IS NOT NULL
          THEN
            l_count                    := l_count + 1;
            l_tab_nm_ne_id_of(l_count) := l_pl.pl_ne_id;
            l_tab_nm_begin_mp(l_count) := l_pl.pl_start;
            l_tab_nm_end_mp(l_count)   := l_pl.pl_end;
            l_tab_nm_seq_no(l_count)   := l_count;
         END IF;
         --
      END LOOP;
      --
      -- Insert the location using bulk binds
      --
      FORALL i IN 1..l_count
         INSERT INTO nm_members
                (nm_ne_id_in
                ,nm_ne_id_of
                ,nm_type
                ,nm_obj_type
                ,nm_begin_mp
                ,nm_start_date
                ,nm_end_date
                ,nm_end_mp
                ,nm_cardinality
                ,nm_admin_unit
                ,nm_seq_no
                )
         VALUES (p_nm_ne_id_in            -- nm_ne_id_in
                ,l_tab_nm_ne_id_of(i)     -- nm_ne_id_of
                ,'I'                      -- nm_type
                ,l_rec_iit.iit_inv_type   -- nm_obj_type
                ,l_tab_nm_begin_mp(i)     -- nm_begin_mp
                ,p_effective_date         -- nm_start_date
                ,l_rec_iit.iit_end_date   -- nm_end_date
                ,l_tab_nm_end_mp(i)       -- nm_end_mp
                ,1                        -- nm_cardinality
                ,l_rec_iit.iit_admin_unit -- nm_admin_unit
                ,l_tab_nm_seq_no(i)       -- nm_seq_no
                );
   END IF;
   --
   -- Set effective date back to original value
   --
   nm3user.set_effective_date (c_effective_date);
--
   nm_debug.proc_end(g_package_name,'relocate_inv_at_pl');
--
EXCEPTION
--
   WHEN OTHERS
    THEN
      --
      -- Set effective date back to original value
      --
      nm3user.set_effective_date (c_effective_date);
      --
      -- Re-Raise the error
      --
      RAISE;
--
END relocate_inv_at_pl;
--
-----------------------------------------------------------------------------
--
FUNCTION future_affected_inv_exists (p_placement_array nm_placement_array
                                    ,p_inv_type        nm_members.nm_obj_type%TYPE
                                    ,p_effective_date  DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                    ) RETURN BOOLEAN IS
BEGIN
--
   RETURN get_future_affected_inv (p_placement_array
                                  ,p_inv_type
                                  ,p_effective_date
                                  ).COUNT > 0;
--
END future_affected_inv_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION future_affected_inv_exists (p_placement_array nm_placement_array
                                    ,p_iit_ne_id       nm_members.nm_ne_id_in%TYPE
                                    ,p_effective_date  DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                    ) RETURN BOOLEAN IS
BEGIN
--
   RETURN get_future_affected_inv (p_placement_array
                                  ,p_iit_ne_id
                                  ,p_effective_date
                                  ).COUNT > 0;
--
END future_affected_inv_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION get_future_affected_inv (p_placement_array nm_placement_array
                                 ,p_inv_type        nm_members.nm_obj_type%TYPE
                                 ,p_effective_date  DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 ) RETURN nm3type.tab_number IS
--
   CURSOR cs_future_affected_inv
                (p_inv_type   varchar2
                ,p_eff_date   date
                ) IS
   SELECT /*+ RULE */ nm_ne_id_in
    FROM  nm_members_all
         ,TABLE(CAST(p_placement_array.npa_placement_array AS nm_placement_array_type)) pl
   WHERE  pl.pl_ne_id   =  nm_ne_id_of
    AND   pl.pl_start   <= nm_end_mp
    AND   pl.pl_end     >= nm_begin_mp
    AND   nm_type       =  'I'
    AND   nm_obj_type   =  p_inv_type
    AND   nm_start_date >  p_eff_date;
--
   l_tab_ne_id_in nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_future_affected_inv');
--
   OPEN  cs_future_affected_inv (p_inv_type
                                ,p_effective_date
                                );
   FETCH cs_future_affected_inv
    BULK COLLECT INTO l_tab_ne_id_in;
   CLOSE cs_future_affected_inv;
--
   nm_debug.proc_end(g_package_name,'get_future_affected_inv');
--
   RETURN l_tab_ne_id_in;
--
END get_future_affected_inv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_future_affected_inv (p_placement_array nm_placement_array
                                 ,p_iit_ne_id       nm_members.nm_ne_id_in%TYPE
                                 ,p_effective_date  DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 ) RETURN nm3type.tab_rowid IS
--
   CURSOR cs_future_affected_inv
                (p_ne_id_in   varchar2
                ,p_eff_date   date
                ) IS
   SELECT /*+ RULE */ nm.ROWID
    FROM  nm_members_all nm
         ,TABLE(CAST(p_placement_array.npa_placement_array AS nm_placement_array_type)) pl
   WHERE  nm_ne_id_in    = p_ne_id_in
    AND   pl.pl_ne_id   =  nm_ne_id_of
    AND   pl.pl_start   <= nm_end_mp
    AND   pl.pl_end     >= nm_begin_mp
    AND   nm_start_date >  p_eff_date;
--
   l_tab_rowid nm3type.tab_rowid;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_future_affected_inv');
--
   OPEN  cs_future_affected_inv (p_iit_ne_id
                                ,p_effective_date
                                );
   FETCH cs_future_affected_inv
    BULK COLLECT INTO l_tab_rowid;
   CLOSE cs_future_affected_inv;
--
   nm_debug.proc_end(g_package_name,'get_future_affected_inv');
--
   RETURN l_tab_rowid;
--
END get_future_affected_inv;
--
-----------------------------------------------------------------------------
--
END nm3homo_o;
/
