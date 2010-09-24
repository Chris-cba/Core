CREATE OR REPLACE PACKAGE BODY nm3inv_security AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_security.pkb-arc   2.3   Sep 24 2010 12:51:34   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3inv_security.pkb  $
--       Date into PVCS   : $Date:   Sep 24 2010 12:51:34  $
--       Date fetched Out : $Modtime:   Sep 24 2010 12:48:54  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   NM3 Inventory Security body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3inv_security';
--
   l_dummy_package_variable number;
--
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
FUNCTION can_usr_see_all_inv_on_element (pi_ne_id IN nm_members.nm_ne_id_of%TYPE) RETURN BOOLEAN IS
--
  CURSOR  cur_dat_missing (c_ne_id_of nm_members.nm_ne_id_of%TYPE) IS
  SELECT  1
    FROM  nm_members
   WHERE  nm_ne_id_of = c_ne_id_of
     AND  nm_type     = 'I'
     AND  NOT EXISTS (SELECT  1
                        FROM  nm_inv_items
                       WHERE  iit_ne_id = nm_ne_id_in);
--
  CURSOR cur_grp_missing(c_ne_id_of  nm_members.nm_ne_id_of%TYPE) is
  -- Check the elements AU
  SELECT 1
    FROM nm_elements
   WHERE ne_id = c_ne_id_of
     AND NOT EXISTS 
 (SELECT 1
    FROM nm_admin_groups
       , nm_user_aus
       , hig_users
   WHERE nag_child_admin_unit = ne_admin_unit
     AND nua_admin_unit = nag_parent_admin_unit
     AND nua_mode = 'NORMAL'
     AND nua_user_id = hus_user_id 
     AND hus_username = USER)
  UNION ALL
  -- Check groups/routes
  SELECT 1
    FROM nm_members a
       , nm_members b
   WHERE a.nm_ne_id_in = c_ne_id_of
     AND b.nm_ne_id_of = a.nm_ne_id_of
     AND NOT EXISTS
   (SELECT nua_admin_unit
      FROM nm_admin_groups
         , nm_user_aus
         , hig_users
     WHERE nua_admin_unit = nag_parent_admin_unit
       AND nag_child_admin_unit = b.nm_admin_unit
       AND nua_mode = 'NORMAL'
       AND nua_user_id = hus_user_id
       AND hus_username = USER)
  UNION ALL
  -- Check Inv items admin unit
  SELECT 1
    FROM nm_members a, nm_members b
   WHERE a.nm_ne_id_in = c_ne_id_of
     AND b.nm_ne_id_of = a.nm_ne_id_of
     AND b.nm_type = 'I'
     AND NOT EXISTS
    (SELECT *
       FROM nm_inv_type_roles, hig_user_roles
      WHERE hur_role = itr_hro_role
        AND b.nm_obj_type = itr_inv_type
        AND itr_mode = 'NORMAL'
        AND hur_username = USER);

--
   l_dummy  BINARY_INTEGER;
--
   l_retval BOOLEAN;
--
   l_ne_rec nm_elements%ROWTYPE := Nm3get.get_ne_all( pi_ne_id => pi_ne_id
                                                    , pi_raise_not_found => FALSE);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'can_usr_see_all_inv_on_element');
--
   IF nm3user.is_user_unrestricted
   THEN
      l_retval := TRUE;
   ELSIF l_ne_rec.ne_type = 'S' 
   THEN
      OPEN  cur_dat_missing (pi_ne_id);
      FETCH cur_dat_missing INTO l_dummy;
      -- If the cursor finds something then
      --  there are some rows which cannot be seen
      -- so to return TRUE use cs%NOTFOUND
      l_retval := cur_dat_missing%NOTFOUND;
      CLOSE cur_dat_missing;
   ELSE
      OPEN  cur_grp_missing (pi_ne_id);
      FETCH cur_grp_missing INTO l_dummy;
      --
      l_retval := cur_grp_missing%NOTFOUND;
      --
      CLOSE cur_grp_missing;
   END IF;
--
   nm_debug.proc_end(g_package_name,'can_usr_see_all_inv_on_element');
--
   RETURN l_retval;
--
END can_usr_see_all_inv_on_element;
--
-----------------------------------------------------------------------------
--
END nm3inv_security;
/
