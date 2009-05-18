--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/drop_constraint_iig_uk.sql-arc   3.0   May 18 2009 12:25:58   lsorathia  $
--       Module Name      : $Workfile:   drop_constraint_iig_uk.sql  $
--       Date into PVCS   : $Date:   May 18 2009 12:25:58  $
--       Date fetched Out : $Modtime:   May 18 2009 11:25:04  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
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

