------------------------------------------------------------------
-- nm4100_nm4101_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4100_nm4101_ddl_upg.sql-arc   3.0   Nov 12 2009 16:40:30   malexander  $
--       Module Name      : $Workfile:   nm4100_nm4101_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Nov 12 2009 16:40:30  $
--       Date fetched Out : $Modtime:   Nov 12 2009 16:36:42  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop NM_INV_ITEMS_INSTEAD_IU trigger
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108687
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Drop NM_INV_ITEMS_INSTEAD_IU trigger
-- 
------------------------------------------------------------------
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

------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

