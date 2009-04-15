--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/drop_nm_inv_items_instead_iu.sql-arc   3.0   Apr 15 2009 12:03:40   aedwards  $
--       Module Name      : $Workfile:   drop_nm_inv_items_instead_iu.sql  $
--       Date into PVCS   : $Date:   Apr 15 2009 12:03:40  $
--       Date fetched Out : $Modtime:   Apr 15 2009 12:02:48  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

PROMPT Drop Trigger NM_INV_ITEMS_INSTEAD_IU

DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-4080);
BEGIN
 EXECUTE IMMEDIATE('DROP TRIGGER NM_INV_ITEMS_INSTEAD_IU');
EXCEPTION
 WHEN ex_not_exists 
 THEN
    NULL;
 WHEN OTHERS 
 THEN
    RAISE;
END;
/

