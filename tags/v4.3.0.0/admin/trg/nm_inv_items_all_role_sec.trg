CREATE OR REPLACE TRIGGER nm_inv_items_all_role_sec
       BEFORE  INSERT OR UPDATE OR DELETE
         ON    nm_inv_items_all
       FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_all_role_sec.trg-arc   2.1   Aug 31 2007 17:14:56   malexander  $
--       Module Name      : $Workfile:   nm_inv_items_all_role_sec.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 17:14:56  $
--       Date fetched Out : $Modtime:   Aug 31 2007 16:21:20  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
--
--      TRIGGER nm_inv_items_all_role_sec
--       BEFORE  INSERT OR UPDATE OR DELETE
--         ON    nm_inv_items_all
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
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3inv.bypass_inv_items_all_trgs
  Then 
    IF nm3user.is_user_unrestricted
    THEN
      RETURN;
    END IF;
--
    IF DELETING
    THEN
      l_inv_type := :OLD.iit_inv_type;
    ELSE
       l_inv_type := :NEW.iit_inv_type;
    END IF;
--
    IF NVL(nm3inv.get_inv_mode_by_role(l_inv_type,USER),nm3type.c_nvl) != nm3type.c_normal
    THEN
      RAISE_APPLICATION_ERROR(-20901,'You do not have permission via NM_INV_TYPE_ROLES to perform this action');
    END IF;
  End If;
--
END nm_inv_items_all_role_sec;
/
