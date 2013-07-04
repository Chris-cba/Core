--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/drop_constraint_iig_uk.sql-arc   3.1   Jul 04 2013 09:32:42   James.Wadsworth  $
--       Module Name      : $Workfile:   drop_constraint_iig_uk.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:42  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:27:58  $
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
 EXECUTE IMMEDIATE('ALTER TABLE NM_INV_ITEM_GROUPINGS_ALL DROP CONSTRAINT IIG_UK');
EXCEPTION
 WHEN ex_not_exists 
 THEN
    NULL;
 WHEN OTHERS 
 THEN
    RAISE;
END;
/

