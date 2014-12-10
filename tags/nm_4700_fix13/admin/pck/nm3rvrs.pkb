CREATE OR REPLACE PACKAGE BODY nm3rvrs AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3rvrs.pkb-arc   2.4   10 Dec 2014 11:03:12   Mike.Huitson  $
--       Module Name      : $Workfile:   nm3rvrs.pkb  $
--       Date into PVCS   : $Date:   10 Dec 2014 11:03:12  $
--       Date fetched Out : $Modtime:   24 Nov 2014 11:08:28  $
--       PVCS Version     : $Revision:   2.4  $
--
--
--   Author : R.A. Coupe
--
--   Package to reverse a route
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.4  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'NM3RVRS';
--
   g_rvrs_exception  EXCEPTION;
   g_rvrs_exc_code   number;
   g_rvrs_exc_msg    varchar2(2000);
   g_rvrs_circroute  varchar2(1) := 'N';
--
   -- Arrays for holding the REVERSAL MEMBERS
   g_tab_nm_ne_id_in      nm3type.tab_number;
   g_tab_nm_ne_id_of      nm3type.tab_number;
   g_tab_nm_type          nm3type.tab_varchar4;
   g_tab_nm_obj_type      nm3type.tab_varchar4;
   g_tab_nm_begin_mp      nm3type.tab_number;
   g_tab_nm_end_mp        nm3type.tab_number;
   g_tab_nm_admin_unit    nm3type.tab_number;
   g_tab_nm_cardinality   nm3type.tab_number;
   g_tab_ne_sub_class     nm3type.tab_varchar4;
   g_tab_nm_seq_no        nm3type.tab_number;
   g_tab_ne_sub_class_old nm3type.tab_varchar4;
--
   g_gis_call           boolean := FALSE;
--
   g_reverse_leg_no CONSTANT boolean := (hig.get_sysopt('REVLEGNO')='Y');
   g_use_inv_xsp    CONSTANT boolean := (hig.get_sysopt('USEINVXSP')='Y');
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
FUNCTION get_g_rvrs_circroute RETURN varchar2 IS
BEGIN
   RETURN g_rvrs_circroute;
END get_g_rvrs_circroute;
--
-----------------------------------------------------------------------------
--

PROCEDURE reverse_other_products ( pi_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') );
--
-----------------------------------------------------------------------------
PROCEDURE reverse_shapes ;
--
-----------------------------------------------------------------------------
--
--
-- function to return the reversal of the provided XSP for the given nw type and sub-class
FUNCTION reverse_xsp (pi_nt_type IN nm_types.nt_type%TYPE,
                      pi_sub_class  nm_type_subclass.nsc_sub_class%TYPE,
		      pi_xsp nm_xsp.nwx_x_sect%TYPE,
		      pi_error_flag varchar2 ) RETURN nm_xsp.nwx_x_sect%TYPE IS

retval  nm_xsp.nwx_x_sect%TYPE;

CURSOR c1 IS
  SELECT a.xrv_new_xsp
  FROM xsp_reversal a
  WHERE a.xrv_nw_type = pi_nt_type
  AND   a.xrv_old_sub_class = pi_sub_class
  AND   a.xrv_old_xsp = pi_xsp;

BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    IF pi_error_flag = 'Y'
     AND g_use_inv_xsp
     THEN
       Raise_Application_Error( -20251, 'XSP Reversal not found');
    ELSE
       retval := pi_xsp;
    END IF;
  ELSE
    CLOSE c1;
  END IF;

  RETURN retval;

END reverse_xsp;
--
-----------------------------------------------------------------------------
--
-- function to reverse the element sub-class
FUNCTION reverse_sub_class ( pi_nt_type IN nm_types.nt_type%TYPE,
                             pi_sub_class  nm_type_subclass.nsc_sub_class%TYPE,
                             pi_error_flag varchar2 ) RETURN nm_type_subclass.nsc_sub_class%TYPE IS

retval  nm_type_subclass.nsc_sub_class%TYPE;

CURSOR c1 IS
  SELECT a.xrv_new_sub_class
  FROM xsp_reversal a
  WHERE a.xrv_nw_type = pi_nt_type
  AND   a.xrv_old_sub_class = pi_sub_class;

BEGIN
  OPEN c1;
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    CLOSE c1;
    IF pi_error_flag = 'Y'
     AND g_use_inv_xsp
     THEN
       Raise_Application_Error( -20251, 'XSP Reversal not found');
    ELSE
       retval := pi_sub_class;
    END IF;
  ELSE
    CLOSE c1;
  END IF;

  RETURN retval;

END reverse_sub_class;
--
-----------------------------------------------------------------------------
--
-- function to return the length compliment of a position along an element of network
FUNCTION reverse_length ( pi_ne_id IN nm_elements_all.ne_id%TYPE,
                          pi_offset IN number ) RETURN number IS
BEGIN
  --RETURN nm3net.get_datum_element_length( pi_ne_id ) - pi_offset;
  RETURN nm3net.get_ne_length( pi_ne_id ) - pi_offset;
END reverse_length;
--
-----------------------------------------------------------------------------
--
-- function to return the sub-class of a particular inventory item - get the first record.

FUNCTION get_iit_sub_class ( pi_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE )
      RETURN nm_type_subclass.nsc_sub_class%TYPE IS
   retval nm_type_subclass.nsc_sub_class%TYPE := NULL;
BEGIN
   -- This is no longer used within this package, but I have modified it to
   --  work with the arrays for the sake of completeness - JM 5/6/01
   FOR l_count IN 1..g_tab_nm_ne_id_in.COUNT
    LOOP
      IF g_tab_nm_ne_id_in(l_count) = pi_iit_ne_id
       THEN
         retval := g_tab_ne_sub_class(l_count);
         EXIT;
      END IF;
   END LOOP;
   RETURN retval;
END get_iit_sub_class;
--
-----------------------------------------------------------------------------
--
FUNCTION leg_reversal( pi_leg IN number ) RETURN number IS
--
   retval number;
--
BEGIN
--
   IF pi_leg BETWEEN 1 AND 8
    AND g_reverse_leg_no
    THEN
--
      retval := MOD(pi_leg+4, 8);
--
      IF retval = 0
       THEN
         retval := 8;
      END IF;
--
   ELSE
--
     retval := pi_leg;
--
   END IF;
--
   RETURN retval;
--
END leg_reversal;
--
-----------------------------------------------------------------------------
--
PROCEDURE gis_reverse_route (pi_ne_id          IN nm_elements.ne_id%TYPE
                            ,pi_effective_date IN DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                            ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'gis_reverse_route');
--
   g_gis_call := TRUE;
   reverse_route (pi_ne_id
                 ,pi_effective_date
                 );
   g_gis_call := FALSE;
--
   nm_debug.proc_end(g_package_name,'gis_reverse_route');
--
END gis_reverse_route;
--
-----------------------------------------------------------------------------
--
-- procedure to reverse the whole route
PROCEDURE reverse_route (pi_ne_id          IN nm_elements.ne_id%TYPE
                        ,pi_effective_date IN DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                        ) IS
--
   CURSOR cs_route (c_route_ne_id NUMBER) IS
   SELECT ne_number
    FROM  nm_elements
   WHERE  ne_id = c_route_ne_id;
--
   CURSOR cs_original_grp (c_route_ne_id NUMBER) IS
   SELECT nm_ne_id_in
         ,ne_new_id nm_ne_id_of
         ,nm_type
         ,nm_obj_type
         ,0 nm_begin_mp
         ,ne_length nm_end_mp
         ,nm_admin_unit
         ,1 nm_cardinality
         ,ne_sub_class
         ,nm_seq_no
         ,ne_sub_class_old
    FROM  nm_members
         ,NM_REVERSAL
    WHERE nm_ne_id_of = ne_id
     AND  nm_ne_id_in = c_route_ne_id
    FOR UPDATE OF nm_ne_id_in NOWAIT;
--
   CURSOR cs_inv_and_prg IS
   SELECT /*+ RULE */
          nm_ne_id_in
         ,ne_new_id nm_ne_id_of
         ,nm_type
         ,nm_obj_type
         ,ne_length - nm_end_mp   -- Nm3rvrs.reverse_length( nm_ne_id_of, nm_end_mp )   -- NEW NM_BEGIN_MP
         ,ne_length - nm_begin_mp -- Nm3rvrs.reverse_length( nm_ne_id_of, nm_begin_mp ) -- NEW NM_END_MP
         ,nm_admin_unit
         ,nm_cardinality
	 ,ne_sub_class
         ,nm_seq_no
         ,ne_sub_class_old
    FROM  nm_members
         ,NM_REVERSAL
    WHERE nm_ne_id_of = ne_id
     AND  ( nm_type = 'I' OR ( nm_type = 'G' AND Nm3net.is_gty_partial( nm_obj_type ,'N' ) = 'Y' ))
    FOR UPDATE OF nm_ne_id_in NOWAIT;
--
   CURSOR cs_whole_element_groups (c_route_ne_id NUMBER) IS
   SELECT /*+ rule */
          nm_ne_id_in
         ,ne_new_id nm_ne_id_of
         ,nm_type
         ,nm_obj_type
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_admin_unit
         ,DECODE(ngt_linear_flag
                ,'Y',nm_cardinality * (-1)
                ,nm_cardinality
                ) nm_cardinality
         ,ne_sub_class
         ,nm_seq_no
         ,ne_sub_class_old
    FROM  nm_members
         ,nm_group_types
         ,NM_REVERSAL
    WHERE nm_ne_id_of  = ne_id
     AND  nm_type      = 'G'
     AND  nm_obj_type  = ngt_group_type
     AND  ngt_partial  = 'N'
     AND  nm_ne_id_in != c_route_ne_id -- Do not bring back the ones for the original group
    FOR UPDATE OF nm_ne_id_in NOWAIT;
--
   CURSOR cs_cardinality_swap_only (c_route_ne_id NUMBER) IS
   SELECT nm_ne_id_in
         ,nm_ne_id_of
         ,nm_type
         ,nm_obj_type
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_admin_unit
         ,nm_cardinality*(-1) nm_cardinality
         ,NULL ne_sub_class
         ,nm_seq_no
         ,NULL ne_sub_class_old
    FROM  nm_members
   WHERE  nm_ne_id_in = c_route_ne_id
    FOR UPDATE OF nm_ne_id_in NOWAIT;
--
   CURSOR cs_future_check_inclusion (c_route_ne_id NUMBER
                                    ,c_eff_date    DATE
                                    ) IS
   SELECT /*+ RULE */ 1
    FROM  dual
   WHERE  EXISTS (SELECT 1 -- cs_original_grp
                   FROM  NM_MEMBERS_ALL
                        ,NM_REVERSAL
                   WHERE nm_ne_id_of   = ne_id
                    AND  nm_ne_id_in   = c_route_ne_id
                    AND  nm_start_date > c_eff_date
                 )
     OR   EXISTS (SELECT 1 -- cs_inv_and_prg
                   FROM  NM_MEMBERS_ALL
                        ,NM_REVERSAL
                   WHERE nm_ne_id_of   = ne_id
                    AND  ( nm_type = 'I' OR ( nm_type = 'G' AND Nm3net.is_gty_partial( nm_obj_type ,'N' ) = 'Y' ))
                    AND  nm_start_date > c_eff_date
                 )
     OR   EXISTS (SELECT 1 -- cs_whole_element_groups
                   FROM  NM_MEMBERS_ALL
                        ,nm_group_types
                        ,NM_REVERSAL
                   WHERE nm_ne_id_of = ne_id
                    AND  nm_type     = 'G'
                    AND  nm_obj_type = ngt_group_type
                    AND  ngt_partial = 'N'
                    AND  nm_start_date > c_eff_date
                 );
--
   CURSOR cs_future_check_non_inclusion (c_route_ne_id NUMBER
                                        ,c_eff_date    DATE
                                        ) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1 -- cs_cardinality_swap_only
                   FROM  NM_MEMBERS_ALL
                  WHERE  nm_ne_id_in = c_route_ne_id
                   AND   nm_start_date > c_eff_date
                 );
--
   CURSOR cs_node_usages IS
   SELECT /*+ RULE */
          ne_new_id
         ,ne_length - nnu_chain /* Reverse the NNU_CHAIN */
         ,nnu_chain
         ,nnu_no_node_id
         ,nnu_leg_no
         ,leg_reversal(nnu_leg_no)
    FROM  nm_node_usages
         ,NM_REVERSAL
    WHERE nnu_ne_id = ne_id
     AND  nnu_leg_no BETWEEN 1 AND 8
    FOR UPDATE OF nnu_leg_no NOWAIT;
--
   l_dummy PLS_INTEGER;
--
   l_group_number nm_elements.ne_number%TYPE;
   l_unique       nm_elements.ne_unique%TYPE := Nm3net.get_ne_unique( pi_ne_id );
--
   l_nt     NM_TYPES.nt_type%TYPE := Nm3net.get_nt_type( pi_ne_id );
   l_sub_nt NM_TYPES.nt_type%TYPE := Nm3net.get_datum_nt(pi_gty => Nm3net.get_ne_gty( pi_ne_id ));
--
   c_initial_effective_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   
   c_allow_cardinality_flip CONSTANT BOOLEAN := nm3net.is_gty_reversible 
                                               ( nm3net.get_ne_gty( pi_ne_id ) ) = 'Y';
--
   -- Temporary arrays to BULK COLLECT the data into, because a
   --  BULK COLLECT blats the existing data rather than appending to it
   l_coll_tab_nm_ne_id_in      Nm3type.tab_number;
   l_coll_tab_nm_ne_id_of      Nm3type.tab_number;
   l_coll_tab_nm_type          Nm3type.tab_varchar4;
   l_coll_tab_nm_obj_type      Nm3type.tab_varchar4;
   l_coll_tab_nm_begin_mp      Nm3type.tab_number;
   l_coll_tab_nm_end_mp        Nm3type.tab_number;
   l_coll_tab_nm_admin_unit    Nm3type.tab_number;
   l_coll_tab_nm_cardinality   Nm3type.tab_number;
   l_coll_tab_ne_sub_class     Nm3type.tab_varchar4;
   l_coll_tab_nm_seq_no        Nm3type.tab_number;
   l_coll_tab_ne_sub_class_old Nm3type.tab_varchar4;
--
   l_tab_nnu_ne_id             Nm3type.tab_number;
   l_tab_new_chain             Nm3type.tab_number;
   l_tab_old_chain             Nm3type.tab_number;
   l_tab_no_node_id            Nm3type.tab_number;
   l_tab_old_leg_no            Nm3type.tab_number;
   l_tab_new_leg_no            Nm3type.tab_number;
--
   l_tab_inv_rowid             Nm3type.tab_rowid;
   l_tab_x_sect                Nm3type.tab_varchar4;
   l_tab_iit_ne_id_done        Nm3type.tab_number;

   --table for bulk collect of nm_reversal ne_ids for end dating
   l_rvrs_ne_id_tab            Nm3type.tab_number;
--
   -- Procedure local procedures
   PROCEDURE append_coll_arrays_to_normal IS
      l_ind BINARY_INTEGER := g_tab_nm_ne_id_in.COUNT;
   BEGIN
      -- ###########################################################
      --  You mast make sure that all of the cursors which are
      --  bulk collected all contain all of the columns, otherwise
      --  this will fall on it's @rse
      -- ###########################################################
      FOR l_count IN 1..l_coll_tab_nm_ne_id_in.COUNT
       LOOP
         l_ind := l_ind + 1;
         g_tab_nm_ne_id_in(l_ind)      := l_coll_tab_nm_ne_id_in(l_count);
         g_tab_nm_ne_id_of(l_ind)      := l_coll_tab_nm_ne_id_of(l_count);
         g_tab_nm_type(l_ind)          := l_coll_tab_nm_type(l_count);
         g_tab_nm_obj_type(l_ind)      := l_coll_tab_nm_obj_type(l_count);
         g_tab_nm_begin_mp(l_ind)      := l_coll_tab_nm_begin_mp(l_count);
         g_tab_nm_end_mp(l_ind)        := l_coll_tab_nm_end_mp(l_count);
         g_tab_nm_admin_unit(l_ind)    := l_coll_tab_nm_admin_unit(l_count);
         g_tab_nm_cardinality(l_ind)   := l_coll_tab_nm_cardinality(l_count);
         g_tab_ne_sub_class(l_ind)     := l_coll_tab_ne_sub_class(l_count);
         g_tab_nm_seq_no(l_ind)        := l_coll_tab_nm_seq_no(l_count);
         g_tab_ne_sub_class_old(l_ind) := l_coll_tab_ne_sub_class_old(l_count);
      END LOOP;
--
      l_coll_tab_nm_ne_id_in.DELETE;
      l_coll_tab_nm_ne_id_of.DELETE;
      l_coll_tab_nm_type.DELETE;
      l_coll_tab_nm_obj_type.DELETE;
      l_coll_tab_nm_begin_mp.DELETE;
      l_coll_tab_nm_end_mp.DELETE;
      l_coll_tab_nm_admin_unit.DELETE;
      l_coll_tab_nm_cardinality.DELETE;
      l_coll_tab_ne_sub_class.DELETE;
      l_coll_tab_nm_seq_no.DELETE;
      l_coll_tab_ne_sub_class_old.DELETE;
--
   END append_coll_arrays_to_normal;
--
  

  
   PROCEDURE insert_nm_members IS
   BEGIN
      FORALL i IN 1..g_tab_nm_ne_id_in.COUNT
         INSERT INTO nm_members
                (nm_ne_id_in
                ,nm_ne_id_of
                ,nm_type
                ,nm_obj_type
                ,nm_begin_mp
                ,nm_start_date
                ,nm_end_mp
                ,nm_admin_unit
                ,nm_cardinality
                ,nm_seq_no
                )
         VALUES (g_tab_nm_ne_id_in(i)
                ,g_tab_nm_ne_id_of(i)
                ,g_tab_nm_type(i)
                ,g_tab_nm_obj_type(i)
                ,g_tab_nm_begin_mp(i)
                ,pi_effective_date
                ,g_tab_nm_end_mp(i)
                ,g_tab_nm_admin_unit(i)
                ,g_tab_nm_cardinality(i)
                ,g_tab_nm_seq_no(i)
                );
   END insert_nm_members;
   --
   PROCEDURE empty_arrays IS
   BEGIN
--
      g_tab_nm_ne_id_in.DELETE;
      g_tab_nm_ne_id_of.DELETE;
      g_tab_nm_type.DELETE;
      g_tab_nm_obj_type.DELETE;
      g_tab_nm_begin_mp.DELETE;
      g_tab_nm_end_mp.DELETE;
      g_tab_nm_admin_unit.DELETE;
      g_tab_nm_cardinality.DELETE;
      g_tab_ne_sub_class.DELETE;
      g_tab_nm_seq_no.DELETE;
      g_tab_ne_sub_class_old.DELETE;
--
   END empty_arrays;
   --
   PROCEDURE set_for_return IS
     -- This procedure sets all values back for returning to the
     --  calling procedure
   BEGIN
      --
      -- Empty the arrays prior to returning to calling
      --
      empty_arrays;
      --
      -- Reset the effective date back to the original value
      --
      Nm3user.set_effective_date (c_initial_effective_date);
      --
      -- Set the AU Security status back
      --
      Nm3ausec.set_status(Nm3type.c_on);
      --
   END set_for_return;
   --
   -- End of Procedure local procedures
--
BEGIN
   g_rvrs_circroute := 'N';
   /*
   ||Allow other products to know what type of reversal
   ||is being executed and which group is being reversed
   ||in the case of a hierarchical network.
   */
   g_cardinality_flip := FALSE;
   g_route_ne_id := pi_ne_id;
   --
   Nm_Debug.proc_start(g_package_name,'reverse_route');
--
   Nm3nwval.network_operations_check( Nm3nwval.c_reverse );
--
   Nm3user.set_effective_date (pi_effective_date);
   Nm3ausec.set_status(Nm3type.c_off);
--
   Nm_Debug.delete_debug;
   Nm_Debug.debug_on;
--
   DELETE NM_REVERSAL;
   empty_arrays;
--
   -- nm_debug.debug('Select the route record. ('||nm3net.get_ne_unique(pi_ne_id)||')');
   OPEN  cs_route (pi_ne_id);
   FETCH cs_route INTO l_group_number;
   IF cs_route%NOTFOUND
    THEN
      CLOSE cs_route;
      g_rvrs_exc_code   := -20254;
      g_rvrs_exc_msg    := 'Route not found';
      RAISE g_rvrs_exception;
   END IF;
   CLOSE cs_route;
--
-- Lock the route record and make sure we have NORMAL access to it
   Nm3lock.lock_element_and_members (pi_ne_id, TRUE);
--
--
-- first check if any membership records exist on the route at a date
-- later than the effective date, if so report an error, If the elements are to be reversed
-- then all XSPs and elements in the route must be reversed.

-- First check the route type, if it is an inclusion group type, it indicates that
-- the route is a secondary referencing system and the elements must be reversed.
-- The copy of the data has reversed sub-class and reversed nodes

--   IF Nm3net.is_nt_inclusion ( l_nt )
   IF NOT c_allow_cardinality_flip
    -- We need to address each member as we can't just flip cardinality
    THEN
     --  
     -- If this is an inclusion route
     --
     -- Make sure there is no shape associated with it
--      IF  NOT g_gis_call
--       AND Higgis.route_has_shape(pi_ne_id)
--       THEN
--         g_rvrs_exc_code   := -20253;
--         g_rvrs_exc_msg    := 'Route '||Nm3net.get_ne_unique(pi_ne_id)||' has shape. Cannot reverse';
--         RAISE g_rvrs_exception;
--      END IF;
--

     --turn member auditing off for subsequent rescale of new elements
     nm_debug.debug('swiching off auditing_member_edits');
     nm3net_history.set_auditing_member_edits(pi_setting => FALSE);

     INSERT INTO NM_REVERSAL
           (ne_id
           ,ne_unique
           ,ne_type
           ,ne_nt_type
           ,ne_descr
           ,ne_length
           ,ne_admin_unit
           ,ne_owner
           ,ne_name_1
           ,ne_name_2
           ,ne_prefix
           ,ne_number
           ,ne_sub_type
           ,ne_group
           ,ne_no_start
           ,ne_no_end
           ,ne_sub_class
           ,ne_nsg_ref
           ,ne_version_no
           ,ne_new_id
           ,ne_sub_class_old
           )
     SELECT ne_id
           ,ne_unique
           ,ne_type
           ,ne_nt_type
           ,ne_descr
           ,ne_length
           ,ne_admin_unit
           ,ne_owner
           ,ne_name_1
           ,ne_name_2
           ,ne_prefix
           ,ne_number
           ,ne_sub_type
           ,ne_group
           ,ne_no_end
           ,ne_no_start
           ,DECODE(ne_type
                  ,'S',reverse_sub_class(ne_nt_type
                                        ,ne_sub_class
                                        ,'Y'
                                        )
                  ,ne_sub_class
                  )
           ,ne_nsg_ref
           ,ne_version_no
           ,ne_id_seq.NEXTVAL -- Nm3net.get_next_ne_id
           ,ne_sub_class
      FROM  nm_members
           ,nm_elements
     WHERE  nm_ne_id_in = pi_ne_id
      AND   nm_ne_id_of = ne_id;
--
     l_group_number := l_group_number + SQL%ROWCOUNT;
--
    
--   Now take a copy of the members of this route - switch the start and end on partial groups and inventory
--   locations. Make a copy with a reference to the new ne_id.
--
--   Split this into several insert statements, rather than forcing a single insert with
--   a lot of decode statements.
--
--   First take a copy of the members of all the original group
     OPEN  cs_original_grp(pi_ne_id);
     FETCH cs_original_grp
      BULK COLLECT INTO l_coll_tab_nm_ne_id_in
                       ,l_coll_tab_nm_ne_id_of
                       ,l_coll_tab_nm_type
                       ,l_coll_tab_nm_obj_type
                       ,l_coll_tab_nm_begin_mp
                       ,l_coll_tab_nm_end_mp
                       ,l_coll_tab_nm_admin_unit
                       ,l_coll_tab_nm_cardinality
                       ,l_coll_tab_ne_sub_class
                       ,l_coll_tab_nm_seq_no
                       ,l_coll_tab_ne_sub_class_old;
     CLOSE cs_original_grp;
     append_coll_arrays_to_normal;

--   Next deal with all the inventory and partial road groups
     OPEN  cs_inv_and_prg;
     FETCH cs_inv_and_prg
      BULK COLLECT INTO l_coll_tab_nm_ne_id_in
                       ,l_coll_tab_nm_ne_id_of
                       ,l_coll_tab_nm_type
                       ,l_coll_tab_nm_obj_type
                       ,l_coll_tab_nm_begin_mp
                       ,l_coll_tab_nm_end_mp
                       ,l_coll_tab_nm_admin_unit
                       ,l_coll_tab_nm_cardinality
                       ,l_coll_tab_ne_sub_class
                       ,l_coll_tab_nm_seq_no
                       ,l_coll_tab_ne_sub_class_old;
     CLOSE cs_inv_and_prg;
     append_coll_arrays_to_normal;
--
--   Now deal with all whole element (non-partial groups). The cardianlity must be reversed
--   if the group type is linear.
     OPEN  cs_whole_element_groups(pi_ne_id);
     FETCH cs_whole_element_groups
      BULK COLLECT INTO l_coll_tab_nm_ne_id_in
                       ,l_coll_tab_nm_ne_id_of
                       ,l_coll_tab_nm_type
                       ,l_coll_tab_nm_obj_type
                       ,l_coll_tab_nm_begin_mp
                       ,l_coll_tab_nm_end_mp
                       ,l_coll_tab_nm_admin_unit
                       ,l_coll_tab_nm_cardinality
                       ,l_coll_tab_ne_sub_class
                       ,l_coll_tab_nm_seq_no
                       ,l_coll_tab_ne_sub_class_old;
     CLOSE cs_whole_element_groups;
     append_coll_arrays_to_normal;
--
--   This should have created a full copy of all affected locations.
--
--   Check for future changes
--
     OPEN  cs_future_check_inclusion (pi_ne_id, pi_effective_date);
     FETCH cs_future_check_inclusion INTO l_dummy;
     IF cs_future_check_inclusion%FOUND
      THEN
        CLOSE cs_future_check_inclusion;
        g_rvrs_exc_code   := -20252;
        g_rvrs_exc_msg    := 'Future dated changes exist to affected membership records';
        RAISE g_rvrs_exception;
     END IF;
     CLOSE cs_future_check_inclusion;
--
--   We intend to create a whole raft of new elements, so update the group code control
--   MRWA Specific
     UPDATE nm_elements
      SET   ne_number = l_group_number
     WHERE  ne_id = pi_ne_id;

     
--   End-date all the affected locations

   -- nm_debug.debug(' UPDATE /*+ RULE */ NM_MEMBERS_ALL');
--      UPDATE /*+ RULE */ nm_members
--       SET  nm_end_date = pi_effective_date
--      WHERE nm_ne_id_of IN ( SELECT ne_id FROM nm_reversal );
--
     --above statement was causing FTS of nm_members so replaced with below
     SELECT ne_id
      BULK  COLLECT
      INTO  l_rvrs_ne_id_tab
      FROM  NM_REVERSAL;
--
  
     FORALL l_i IN 1..l_rvrs_ne_id_tab.COUNT
        UPDATE nm_members
         SET   nm_end_date = pi_effective_date
        WHERE  nm_ne_id_of = l_rvrs_ne_id_tab(l_i);

   
   -- nm_debug.debug('updated '||sql%ROWCOUNT);
--
   --
   -- Get the node usages for the existing elements for updating the new NNU recs afterwards
   --  This only selects NNU records where the LEG_NO is between 1 and 8
   -- Also LOCKS the existing NODE usage records
   --
   --  nm_debug.debug('OPEN  cs_node_usages');
     OPEN  cs_node_usages;
     FETCH cs_node_usages
      BULK COLLECT
      INTO l_tab_nnu_ne_id
          ,l_tab_new_chain
          ,l_tab_old_chain
          ,l_tab_no_node_id
          ,l_tab_old_leg_no
          ,l_tab_new_leg_no;
     CLOSE cs_node_usages;
   --  nm_debug.debug('CLOSE cs_node_usages');

--  we need to reverse the datum shapes before they get enddated
--  reverse_shapes;
--
--   End-date the affected elements - note that triggers will tidy up the leg numbers
--   These will have to be updated after the recreation of the node usages by the trigger
--
     UPDATE /*+ RULE */ NM_ELEMENTS_ALL
     SET ne_end_date = pi_effective_date
     WHERE ne_id IN ( SELECT /*+ RULE */ ne_id FROM NM_REVERSAL );

--   Create new elements - give new sequence numbers

     nm_debug.debug('creating elements');
     nm_debug.debug_sql_string('SELECT ne_new_id    ,ne_type           ,ne_nt_type           ,ne_descr           ,ne_length           ,ne_admin_unit           ,sysdate           ,ne_owner           ,ne_name_1           ,ne_name_2           ,ne_prefix           ,' || l_group_number || ' + 1 - ROWNUM           ,ne_sub_type           ,ne_group           ,ne_no_start           ,ne_no_end           ,ne_sub_class           ,ne_nsg_ref           ,ne_version_no	   ,ne_type	    FROM NM_REVERSAL');     
     INSERT INTO nm_elements
           (ne_id
           ,ne_type
           ,ne_nt_type
           ,ne_descr
           ,ne_length
           ,ne_admin_unit
           ,ne_start_date
           ,ne_owner
           ,ne_name_1
           ,ne_name_2
           ,ne_prefix
           ,ne_number
           ,ne_sub_type
           ,ne_group
           ,ne_no_start
           ,ne_no_end
           ,ne_sub_class
           ,ne_nsg_ref
           ,ne_version_no
           ,ne_unique
           )
     SELECT ne_new_id
           ,ne_type
           ,ne_nt_type
           ,ne_descr
           ,ne_length
           ,ne_admin_unit
           ,pi_effective_date
           ,ne_owner
           ,ne_name_1
           ,ne_name_2
           ,ne_prefix
           ,l_group_number + 1 - ROWNUM
           ,ne_sub_type
           ,ne_group
           ,ne_no_start
           ,ne_no_end
           ,ne_sub_class
           ,ne_nsg_ref
           ,ne_version_no
	   ,DECODE(ne_type
	          ,'D',Nm3net.get_db_name(l_unique)
	          ,NULL
	          )
     FROM NM_REVERSAL;
  
    nm_debug.debug('done insert');

     reverse_shapes;

--   recreate the locational data of all other objects

     insert_nm_members;

--   update the leg numbers to the reversed values.
  --   We don't need to worry about locking these records
  --    because they have just been inserted by the trigger on NM_ELEMENTS
      
      FORALL i IN 1..l_tab_nnu_ne_id.COUNT
       UPDATE NM_NODE_USAGES_ALL
        SET   nnu_leg_no     = l_tab_new_leg_no(i)
       WHERE  nnu_ne_id      = l_tab_nnu_ne_id(i)
        AND   nnu_chain      = l_tab_new_chain(i)
        AND   nnu_no_node_id = l_tab_no_node_id(i);
        
--
--   We can't END DATE the inventory - PKeys would be violated.
--
/*
     FORALL i IN 1..g_tab_nm_ne_id_in.COUNT
        update nm_inv_items_all
         set   iit_end_date = pi_effective_date
        where  iit_ne_id  = g_tab_nm_ne_id_in(i);
*/
--
-- This is a big hole in the design - carried over from NM 2
-- The XSPs should be held outside of the inventory
--
  
  
     DECLARE
        l_x_sect    nm_inv_items.iit_x_sect%TYPE;
        l_iit_rowid ROWID;
        l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;
        CURSOR cs_lock_inv (p_iit_ne_id NUMBER
                           ,p_nt_type   VARCHAR2
                           ,p_subclass  VARCHAR2
                           ) IS
        SELECT iit.ROWID iit_rowid
              ,reverse_xsp (p_nt_type,p_subclass,iit.iit_x_sect,'N') new_xsp
         FROM  nm_inv_items iit
        WHERE  iit.iit_ne_id             = p_iit_ne_id
        FOR UPDATE OF iit_x_sect NOWAIT;
     BEGIN
        FOR i IN 1..g_tab_nm_ne_id_in.COUNT
         LOOP
           l_iit_ne_id := g_tab_nm_ne_id_in(i);
           IF       g_tab_nm_type(i) = 'I'
            AND NOT l_tab_iit_ne_id_done.EXISTS(l_iit_ne_id)
            -- Check the pl/sql table to see if this IIT_NE_ID already done. no point locking it again
            THEN
              OPEN  cs_lock_inv (g_tab_nm_ne_id_in(i),l_sub_nt,g_tab_ne_sub_class_old(i));
              FETCH cs_lock_inv INTO l_iit_rowid,l_x_sect;
              CLOSE cs_lock_inv;
              l_tab_inv_rowid(l_tab_inv_rowid.COUNT+1):= l_iit_rowid;
              l_tab_x_sect(l_tab_x_sect.COUNT+1)      := l_x_sect;
              l_tab_iit_ne_id_done(l_iit_ne_id)       := l_iit_ne_id;
           END IF;
        END LOOP;
     END;
    --
     FORALL i IN 1..l_tab_inv_rowid.COUNT
       UPDATE nm_inv_items
        SET  iit_x_sect = l_tab_x_sect(i)
       WHERE ROWID      = l_tab_inv_rowid(i);
   --
      l_tab_inv_rowid.DELETE;
      l_tab_x_sect.DELETE;
      l_tab_iit_ne_id_done.DELETE;
   --
    --record the element history
    insert into
      nm_element_history(neh_id
                        ,neh_ne_id_old
                        ,neh_ne_id_new
                        ,neh_operation
                        ,neh_effective_date
                        ,neh_old_ne_length
                        ,neh_new_ne_length)
    select
      nm3seq.next_neh_id_seq,
      nmr.ne_id,
      nmr.ne_new_id,
      nm3net_history.c_neh_op_reverse,
      pi_effective_date,
      nmr.ne_length,
      nmr.ne_length
    from
      nm_reversal nmr;

--
  ELSE
    /*
    ||Allow other products to detect the type of reversal.
    */
    g_cardinality_flip := TRUE;
  -- Just flip the cardinality

     OPEN  cs_future_check_non_inclusion (pi_ne_id, pi_effective_date);
     FETCH cs_future_check_non_inclusion INTO l_dummy;
     IF cs_future_check_non_inclusion%FOUND
      THEN
        CLOSE cs_future_check_non_inclusion;
        g_rvrs_exc_code   := -20252;
        g_rvrs_exc_msg    := 'Future dated changes exist to affected membership records';
        RAISE g_rvrs_exception;
     END IF;
     CLOSE cs_future_check_non_inclusion;
--
--   The route is not a secondary linear referencing system, only the cardinality of each member
--   must be reversed. First, take a copy.
     OPEN  cs_cardinality_swap_only(pi_ne_id);
     FETCH cs_cardinality_swap_only
      BULK COLLECT INTO l_coll_tab_nm_ne_id_in
                       ,l_coll_tab_nm_ne_id_of
                       ,l_coll_tab_nm_type
                       ,l_coll_tab_nm_obj_type
                       ,l_coll_tab_nm_begin_mp
                       ,l_coll_tab_nm_end_mp
                       ,l_coll_tab_nm_admin_unit
                       ,l_coll_tab_nm_cardinality
                       ,l_coll_tab_ne_sub_class
                       ,l_coll_tab_nm_seq_no
                       ,l_coll_tab_ne_sub_class_old;
     CLOSE cs_cardinality_swap_only;
     append_coll_arrays_to_normal;
--
--   Next end-date the current members, and insert the new ones.
--
     UPDATE nm_members
      SET   nm_end_date = pi_effective_date
     WHERE  nm_ne_id_in = pi_ne_id;
--
     insert_nm_members;
--
  END IF;
--
--A full rescale cannot be performed since it will violate the members PK.
--It needs to be done from the rescale tables.
--
   --turn off member auditing during this

   DECLARE
      circroute EXCEPTION;
      PRAGMA    EXCEPTION_INIT( circroute, -20207 );
   BEGIN
      Nm3rsc.rescale_route( pi_ne_id, pi_effective_date, 0, NULL, 'N' );
   EXCEPTION
      WHEN circroute THEN
         g_rvrs_circroute := 'Y';
   END;
--nm3rsc.rescale_route( pi_ne_id, pi_effective_date, 0, NULL, 'N' );
--

  nm3net_history.set_auditing_member_edits(pi_setting => TRUE);

  -- reverse for other products
  reverse_other_products ( pi_effective_date => pi_effective_date );
--
  -- Set the effective date etc. back to it's original state for
  --  returning to calling procedure
  set_for_return;
--
  Nm_Debug.proc_end(g_package_name,'reverse_route');
--
EXCEPTION
--
   WHEN g_rvrs_exception
    THEN
      -- Set the effective date etc. back to it's original state for
      --  returning to calling procedure
      set_for_return;
      RAISE_APPLICATION_ERROR(g_rvrs_exc_code,g_rvrs_exc_msg);
--
   WHEN OTHERS
    THEN
      -- Set the effective date etc. back to it's original state for
      --  returning to calling procedure
      set_for_return;
      RAISE;
--
END reverse_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE reverse_other_products ( pi_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') ) IS
--
   PROCEDURE exec_rvrs (p_pack_proc varchar2) IS
   BEGIN
      IF p_pack_proc IS NOT NULL
       THEN
         EXECUTE IMMEDIATE
                      'BEGIN'
           ||CHR(10)||'   '||p_pack_proc||'(:pi_effective_date);'
           ||CHR(10)||'END;'
         USING IN pi_effective_date;
      END IF;
   END exec_rvrs;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'reverse_other_products');
--
   IF hig.is_product_licensed(nm3type.c_acc)
    THEN
      exec_rvrs ('accloc.acc_reversal');
   END IF;
--
   IF hig.is_product_licensed(nm3type.c_str)
    THEN
      exec_rvrs ('strrecal.str_reversal');
   END IF;
--
   IF hig.is_product_licensed(nm3type.c_mai)
    THEN
      exec_rvrs ('mairecal.mai_reversal');
   END IF;
--
   IF hig.is_product_licensed(nm3type.c_stp)
    THEN
      exec_rvrs ('stp_network_ops.do_reversal');
   END IF;
--
   nm_debug.proc_end(g_package_name,'reverse_other_products');
--
END reverse_other_products;
--
-----------------------------------------------------------------------------

PROCEDURE reverse_shapes is
  CURSOR c_elements is
    SELECT ne_id, ne_new_id
    FROM nm_reversal;
  BEGIN      
    FOR irec IN c_elements LOOP
  
      Nm3sdm.reverse_element_shape( p_ne_id_old => irec.ne_id
                                   ,p_ne_id_new => irec.ne_new_id );

    END LOOP;
    
END reverse_shapes;

--
-----------------------------------------------------------------------------
--
END nm3rvrs;
/

