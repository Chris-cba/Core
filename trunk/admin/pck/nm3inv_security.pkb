CREATE OR REPLACE PACKAGE BODY nm3inv_security AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_security.pkb-arc   2.2   Sep 21 2010 15:04:26   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3inv_security.pkb  $
--       Date into PVCS   : $Date:   Sep 21 2010 15:04:26  $
--       Date fetched Out : $Modtime:   Sep 21 2010 14:47:00  $
--       Version          : $Revision:   2.2  $
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
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.2  $';
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
  SELECT DISTINCT 1
    FROM nm_members i, nm_members r
   WHERE i.nm_type = 'I'
     AND i.nm_ne_id_of = r.nm_ne_id_of
     AND r.nm_ne_id_in = c_ne_id_of
     AND NOT EXISTS ( SELECT 1 
                        FROM nm_inv_items 
                       WHERE iit_ne_id = i.nm_ne_id_in );

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
