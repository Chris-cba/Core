------------------------------------------------------------------
-- nm4053_nm4054_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4053_nm4054_metadata_upg.sql-arc   3.0   Mar 23 2009 12:22:30   malexander  $
--       Module Name      : $Workfile:   nm4053_nm4054_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Mar 23 2009 12:22:30  $
--       Date fetched Out : $Modtime:   Mar 23 2009 12:09:50  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
 Null;
END;
/

BEGIN
  nm_debug.debug_off;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Error Messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 702388
-- 
-- CUSTOMER
-- British Columbia
-- 
-- PROBLEM
-- This call is being kept open only so it doesn't fall off Exor's bug fix to-do list.
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- This message is added to validate the Number Attribute
-- 
------------------------------------------------------------------
INSERT INTO nm_errors
SELECT 'NET'
      , 457
      , NULL
      , 'Value larger than the precision allowed for this column'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 457);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Error Messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 702388
-- 
-- CUSTOMER
-- British Columbia
-- 
-- PROBLEM
-- This call is being kept open only so it doesn't fall off Exor's bug fix to-do list.
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- This message is added to validate the Number Attribute
-- 
------------------------------------------------------------------
INSERT INTO nm_errors
SELECT 'NET'
      , 458
      , NULL
      , 'Value is of invalid format'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 458);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Error Message
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- **** COMMENTS TO BE ADDED BY LINESH SORATHIA ****
-- 
------------------------------------------------------------------
INSERT INTO nm_errors
SELECT 'NET'
      , 459
      , NULL
      , 'Warning - Location of this item is mandatory'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 459);
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

