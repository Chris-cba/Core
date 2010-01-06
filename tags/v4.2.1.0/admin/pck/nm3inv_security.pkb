CREATE OR REPLACE PACKAGE BODY nm3inv_security AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_security.pkb-arc   2.1   Jan 06 2010 16:38:28   cstrettle  $
--       Module Name      : $Workfile:   nm3inv_security.pkb  $
--       Date into PVCS   : $Date:   Jan 06 2010 16:38:28  $
--       Date fetched Out : $Modtime:   Jan 06 2010 11:02:30  $
--       Version          : $Revision:   2.1  $
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
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.1  $';
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
   CURSOR cs_missing (c_ne_id_of nm_members.nm_ne_id_of%TYPE) IS
   SELECT 1
    FROM  nm_members
   WHERE  nm_ne_id_of = c_ne_id_of
    AND   nm_type     = 'I'
    AND   NOT EXISTS (SELECT 1
                       FROM  nm_inv_items
                      WHERE  iit_ne_id = nm_ne_id_in
                     );
--
   l_dummy  BINARY_INTEGER;
--
   l_retval BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'can_usr_see_all_inv_on_element');
--
   IF nm3user.is_user_unrestricted
    THEN
      l_retval := TRUE;
   ELSE
      OPEN  cs_missing (pi_ne_id);
      FETCH cs_missing INTO l_dummy;
      -- If the cursor finds something then
      --  there are some rows which cannot be seen
      -- so to return TRUE use cs%NOTFOUND
      l_retval := cs_missing%NOTFOUND;
      CLOSE cs_missing;
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
