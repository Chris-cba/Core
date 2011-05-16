CREATE OR REPLACE PACKAGE BODY nm3inv_security AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_security.pkb-arc   2.5   May 16 2011 14:44:56   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3inv_security.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:44:56  $
--       Date fetched Out : $Modtime:   May 05 2011 09:14:34  $
--       Version          : $Revision:   2.5  $
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
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   2.5  $';
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
FUNCTION can_usr_see_all_inv_on_element ( pi_ne_id IN nm_members.nm_ne_id_of%TYPE
                                        , pi_check_grandchildren BOOLEAN DEFAULT FALSE
                                        --, pi_check_datum BOOLEAN DEFAULT FALSE
                                        ) RETURN BOOLEAN IS
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
  CURSOR cur_missing_children(c_ne_id_of  nm_members.nm_ne_id_of%TYPE)
  IS
-- Check the users admin unit is allowed
  WITH all_visable_au AS
   (SELECT nag_child_admin_unit 
      FROM nm_admin_groups
         , nm_user_aus
         , hig_users
     WHERE nua_admin_unit = nag_parent_admin_unit
       AND nua_mode = 'NORMAL'
       AND nua_user_id = hus_user_id
       AND hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME'))
    SELECT 1
      FROM nm_elements
     WHERE ne_id = c_ne_id_of
       AND NOT EXISTS (SELECT 'X' FROM all_visable_au where nag_child_admin_unit = ne_admin_unit)
    UNION
  -- Check the members admin units are allowed
    SELECT 1
      FROM nm_members a
         , nm_members b
     WHERE a.nm_ne_id_in = c_ne_id_of
       AND b.nm_ne_id_of = a.nm_ne_id_of
       AND NOT EXISTS (SELECT 'X' FROM all_visable_au where nag_child_admin_unit = b.nm_admin_unit)
    UNION
  -- Check the inventory items belonging to these members are allowed
    SELECT 1
      FROM nm_members a
         , nm_members b
     WHERE a.nm_ne_id_in = c_ne_id_of
       AND b.nm_ne_id_of = a.nm_ne_id_of
       AND b.nm_type = 'I'
       AND NOT EXISTS (SELECT 'X' FROM all_visable_au WHERE nag_child_admin_unit = b.nm_admin_unit);
        --
  CURSOR cur_missing_grandchildren(c_ne_id_of  nm_members.nm_ne_id_of%TYPE) 
  IS
  WITH 
  -- A list of all the children members
   all_children_members
   AS
   (SELECT *
    FROM nm_members
    START WITH nm_ne_id_in = c_ne_id_of
    CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in)
  -- List of all the admin units the usre has access to
  , all_visable_au
   AS
   (SELECT nag_child_admin_unit
      FROM nm_admin_groups
         , nm_user_aus
         , hig_users
     WHERE nua_admin_unit = nag_parent_admin_unit
       AND nua_mode = 'NORMAL'
       AND nua_user_id = hus_user_id
       AND hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME'))
  -- Check the users admin unit is allowed
    SELECT 1
      FROM nm_elements
     WHERE ne_id = c_ne_id_of
       AND NOT EXISTS (SELECT 'X' FROM all_visable_au where nag_child_admin_unit = ne_admin_unit)
    UNION
  -- Check the members admin units are allowed
    SELECT 1
      FROM all_children_members a
         , nm_members b
     WHERE b.nm_ne_id_of = a.nm_ne_id_of
       AND NOT EXISTS (SELECT 'X' FROM all_visable_au where nag_child_admin_unit = b.nm_admin_unit)
    UNION
  -- Check the inventory items belonging to these members are allowed
    SELECT 1
      FROM all_children_members a
         , nm_members b
     WHERE b.nm_ne_id_of = a.nm_ne_id_of
       AND b.nm_type = 'I'
       AND NOT EXISTS
      (SELECT *
         FROM nm_inv_type_roles, hig_user_roles
        WHERE hur_role = itr_hro_role
          AND b.nm_obj_type = itr_inv_type
          AND itr_mode = 'NORMAL'
          AND hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME'))
       AND NOT EXISTS (SELECT 'X' FROM all_visable_au WHERE nag_child_admin_unit = b.nm_admin_unit);
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
   IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE'
   THEN
      l_retval := TRUE;
   ELSIF l_ne_rec.ne_type = 'S' 
   THEN
        OPEN  cur_dat_missing (pi_ne_id);
        FETCH cur_dat_missing INTO l_dummy;
          l_retval := cur_dat_missing%NOTFOUND;
        CLOSE cur_dat_missing;
   ELSIF l_ne_rec.ne_type = 'G'
   THEN
        OPEN  cur_missing_children (pi_ne_id);
        FETCH cur_missing_children INTO l_dummy;
          l_retval := cur_missing_children%NOTFOUND;
        CLOSE cur_missing_children;
   ELSIF l_ne_rec.ne_type = 'P'
   THEN
     IF pi_check_grandchildren 
     THEN
        OPEN  cur_missing_grandchildren (pi_ne_id);
        FETCH cur_missing_grandchildren INTO l_dummy;
          l_retval := cur_missing_grandchildren%NOTFOUND;
        CLOSE cur_missing_grandchildren;
     ELSE
        OPEN  cur_missing_children (pi_ne_id);
        FETCH cur_missing_children INTO l_dummy;
          l_retval := cur_missing_children%NOTFOUND;
        CLOSE cur_missing_children;
     END IF;
   --
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
