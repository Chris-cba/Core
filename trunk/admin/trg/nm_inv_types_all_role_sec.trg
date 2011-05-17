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
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   l_inv_type nm_inv_types.nit_inv_type%TYPE;
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
   IF NVL(nm3inv.get_inv_mode_by_role(l_inv_type,Sys_Context('NM3_SECURITY_CTX','USERNAME')),nm3type.c_nvl) != nm3type.c_normal
    THEN
      RAISE_APPLICATION_ERROR(-20901,'You do not have permission via NM_INV_TYPE_ROLES to perform this action');
   END IF;
--
END nm_inv_types_all_role_sec;
/
