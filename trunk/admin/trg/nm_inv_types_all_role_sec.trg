CREATE OR REPLACE TRIGGER nm_inv_types_all_role_sec
       BEFORE  UPDATE OR DELETE
         ON    nm_inv_types_all
       FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_types_all_role_sec.trg	1.1 10/01/01
--       Module Name      : nm_inv_types_all_role_sec.trg
--       Date into SCCS   : 01/10/01 10:07:50
--       Date fetched Out : 07/06/13 17:03:09
--       SCCS Version     : 1.1
--
--      TRIGGER nm_inv_types_all_role_sec
--       BEFORE  UPDATE OR DELETE
--         ON    nm_inv_types_all
--       FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_mode (c_inv_type NM_INV_TYPE_ATTRIBS.ita_inv_type%TYPE
                  ,c_username user_users.username%TYPE
                  ) IS
   SELECT NVL(DECODE(nad_nt_type, NULL, nad_nt_type, 'NORMAL' ),itr_mode)
    FROM  NM_INV_TYPE_ROLES
         ,HIG_USER_ROLES
         ,nm_nw_ad_types
   WHERE  itr_inv_type  (+) = c_inv_type     
    AND   itr_hro_role = hur_role (+)
    AND   hur_username (+) = c_username
    and   nad_inv_type (+) = itr_inv_type
    order by itr_mode;

   l_inv_type nm_inv_types.nit_inv_type%TYPE;
   l_retval NM_INV_TYPE_ROLES.itr_mode%TYPE := NULL;
--
BEGIN
--
   IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE'
    THEN
      RETURN;
   END IF;
--
   IF DELETING
    THEN
      l_inv_type := :OLD.nit_inv_type;
   ELSE
      l_inv_type := :NEW.nit_inv_type;
   END IF;
--
   OPEN  cs_mode (l_inv_type, Sys_Context('NM3_SECURITY_CTX','USERNAME'));
   FETCH cs_mode INTO l_retval;
   CLOSE cs_mode;
   

   IF l_retval != nm3type.c_normal
    THEN
      RAISE_APPLICATION_ERROR(-20901,'You do not have permission via NM_INV_TYPE_ROLES to perform this action');
   END IF;
--
END nm_inv_types_all_role_sec;
/