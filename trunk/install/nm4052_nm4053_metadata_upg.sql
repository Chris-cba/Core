------------------------------------------------------------------
-- nm4052_nm4053_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4052_nm4053_metadata_upg.sql-arc   3.1   Jul 04 2013 14:15:38   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4052_nm4053_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:15:38  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

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
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- When the unit type and field length attributes on an Asset attribute are not compatible, raise a NER instead of the unhandled ORA-06502 raised from nm3inv.
-- 
------------------------------------------------------------------
INSERT INTO nm_errors
SELECT 'NET'
      , 456
      , NULL
      , 'Mismatch between field length definition and unit type '
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 456);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Product Option
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Added on behalf of JW
-- 
------------------------------------------------------------------
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       )
SELECT 
        'EDSNULLEXC'
       ,'NET'
       ,'Eng Dyn Seg - use of NULL'
       ,'When Y raise exceptions on use of Nulls in eng dyn seg otherwise ignore NULL values'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'EDSNULLEXC')
/
INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'EDSNULLEXC'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'EDSNULLEXC')
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hierarchical Asset repair
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 717947
-- 
-- CUSTOMER
-- City of York Council
-- 
-- PROBLEM
-- Error message querying new inventory type set up.
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- LS - Repair for 717947
-- 
------------------------------------------------------------------
SET TERM ON
PROMPT Hierarchical Asset repair...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||
        '&terminator'||'sql'||'&terminator'||'update_iig_defect_717947.sql' run_file
FROM dual
/
SET FEEDBACK ON
start &&run_file
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

