CREATE OR REPLACE FUNCTION chk_inv_type_valid_for_role (p_inv_type IN varchar2)
  RETURN varchar2 IS
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/chk_inv_type_valid_for_role.fnc-arc   2.0   Jun 14 2007 14:59:46   smarshall  $
--       Module Name      : $Workfile:   chk_inv_type_valid_for_role.fnc  $
--       Date into SCCS   : $Date:   Jun 14 2007 14:59:46  $
--       Date fetched Out : $Modtime:   Jun 14 2007 14:59:00  $
--       SCCS Version     : $Revision:   2.0  $
--       Based on SCCS Version     : 1.6
--
--
--   Author : Jonathan Mills
--
--   Role Based Inventory Function
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   CURSOR cs_inv_type_valid_for_role (p_inv_type varchar2) IS
   SELECT itr_mode
    FROM  hig_user_roles
         ,nm_inv_type_roles
   WHERE  itr_inv_type = p_inv_type
    AND   itr_hro_role = hur_role
    AND   hur_username = USER;
    
   CURSOR cs_user_restricted IS
   SELECT hus_unrestricted
   FROM hig_users
   WHERE hus_username = USER;
    
--
-- Assign FALSE to the return value, then if the cursor is %NOTFOUND then
--  FALSE will be returned
--
   c_normal              CONSTANT varchar2(6)  := 'NORMAL';
   c_false               CONSTANT varchar2(5)  := 'FALSE';   
   
   l_unrestricted       varchar2(1);
   l_retval   varchar2(12) := c_false;
--
BEGIN
--
   OPEN cs_user_restricted;
   FETCH cs_user_restricted INTO l_unrestricted;
   CLOSE cs_user_restricted;
   
    IF l_unrestricted = 'Y'  
     THEN
       RETURN c_normal;
    END IF;
--
   OPEN  cs_inv_type_valid_for_role (p_inv_type);
   FETCH cs_inv_type_valid_for_role INTO l_retval;
   CLOSE cs_inv_type_valid_for_role;
--
   RETURN l_retval;
--
END chk_inv_type_valid_for_role;
/
