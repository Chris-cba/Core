--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/drop_nm_inv_items_instead_iu.sql-arc   3.1   Jul 04 2013 09:33:38   James.Wadsworth  $
--       Module Name      : $Workfile:   drop_nm_inv_items_instead_iu.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:33:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:33:22  $
--       PVCS Version     : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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

