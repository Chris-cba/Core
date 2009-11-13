------------------------------------------------------------------
-- nm4100_nm4101_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4100_nm4101_ddl_upg.sql-arc   3.1   Nov 13 2009 11:41:40   malexander  $
--       Module Name      : $Workfile:   nm4100_nm4101_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Nov 13 2009 11:41:40  $
--       Date fetched Out : $Modtime:   Nov 13 2009 11:38:00  $
--       Version          : $Revision:   3.1  $
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
SET TERM ON
PROMPT Create MDSYS.SDO_GEOM_METADATA_TABLE synonym
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Create MDSYS.SDO_GEOM_METADATA_TABLE synonym
-- 
------------------------------------------------------------------
Create Or Replace Public Synonym sdo_geom_metadata_table for mdsys.sdo_geom_metadata_table;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

