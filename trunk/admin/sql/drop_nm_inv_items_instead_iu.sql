--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/drop_nm_inv_items_instead_iu.sql-arc   3.2   Apr 13 2018 13:21:46   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   drop_nm_inv_items_instead_iu.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 13:21:46  $
--       Date fetched Out : $Modtime:   Apr 13 2018 13:20:38  $
--       PVCS Version     : $Revision:   3.2  $
--
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
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

