------------------------------------------------------------------
-- nm4600_nm4700_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4600_nm4700_metadata_upg.sql-arc   1.2   Jul 12 2013 13:03:08   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4600_nm4700_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 12 2013 13:03:08  $
--       Date fetched Out : $Modtime:   Jul 12 2013 13:02:52  $
--       Version          : $Revision:   1.2  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2013

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
PROMPT New Error messages for Monitor Processes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New Error messages for Monitor Processes
-- 
------------------------------------------------------------------

Begin
  Insert Into Nm_Errors
  (
  Ner_Appl,
  Ner_Id,
  Ner_Her_No,
  Ner_Descr,
  Ner_Cause
  )
  Values
  (
  'HIG',
  558,
  Null,
  'Not all selections could be deleted',
  Null
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;  
/

Begin
  Insert Into Nm_Errors
  (
  Ner_Appl,
  Ner_Id,
  Ner_Her_No,
  Ner_Descr,
  Ner_Cause
  )
  Values
  (
  'HIG',
  559,
  Null,
  'All selections deleted',
  Null
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Product Options to support unzipping of files by the Document Bundle Loader
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- Also scripted in NM 4600 Fix 7
-- Referenced in the HIG_SVR_UTIL package
-- 
------------------------------------------------------------------
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'UNZIPCMD' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Command line to invoke unzip' as HOL_NAME,
  'Command line to invoke unzip such as ''c:\tools\unzip\unzip or /bin/unzip''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'GUNZIPCMD' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Command line to invoke gunzip' as HOL_NAME,
  'Command line to invoke gunzip such as ''/bin/gunzip''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'TARCMD' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Command line to invoke tar' as HOL_NAME,
  'Command line to invoke tar such as ''/bin/tar''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_LIST A USING
 (SELECT
  'CMDSHELL' as HOL_ID,
  'HIG' as HOL_PRODUCT,
  'Location of Windows cmd shell' as HOL_NAME,
  'Location of Windows cmd shell such as ''C:\WINDOWS\system32\cmd.exe''' as HOL_REMARKS,
  NULL as HOL_DOMAIN,
  'VARCHAR2' as HOL_DATATYPE,
  'Y' as HOL_MIXED_CASE,
  'Y' as HOL_USER_OPTION,
  2000 as HOL_MAX_LENGTH
  FROM DUAL) B
ON (A.HOL_ID = B.HOL_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
  HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION, HOL_MAX_LENGTH)
VALUES (
  B.HOL_ID, B.HOL_PRODUCT, B.HOL_NAME, B.HOL_REMARKS, B.HOL_DOMAIN, 
  B.HOL_DATATYPE, B.HOL_MIXED_CASE, B.HOL_USER_OPTION, B.HOL_MAX_LENGTH)
WHEN MATCHED THEN
UPDATE SET 
  A.HOL_PRODUCT = B.HOL_PRODUCT,
  A.HOL_NAME = B.HOL_NAME,
  A.HOL_REMARKS = B.HOL_REMARKS,
  A.HOL_DOMAIN = B.HOL_DOMAIN,
  A.HOL_DATATYPE = B.HOL_DATATYPE,
  A.HOL_MIXED_CASE = B.HOL_MIXED_CASE,
  A.HOL_USER_OPTION = B.HOL_USER_OPTION,
  A.HOL_MAX_LENGTH = B.HOL_MAX_LENGTH;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'UNZIPCMD' as HOV_ID,
  'unzip' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'GUNZIPCMD' as HOV_ID,
  '/bin/gunzip' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;
  
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'TARCMD' as HOV_ID,
  '/bin/tar' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;  
--
----------------------------------------------------------------------------------------
--
MERGE INTO HIG_OPTION_VALUES A USING
 (SELECT
  'CMDSHELL' as HOV_ID,
  'C:\WINDOWS\system32\cmd.exe' as HOV_VALUE
  FROM DUAL) B
ON (A.HOV_ID = B.HOV_ID)
WHEN NOT MATCHED THEN 
INSERT (
  HOV_ID, HOV_VALUE)
VALUES (
  B.HOV_ID, B.HOV_VALUE)
WHEN MATCHED THEN
UPDATE SET 
  A.HOV_VALUE = B.HOV_VALUE;
--
----------------------------------------------------------------------------------------
--
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT SDE Sub-layer exemption
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- sde sub-layer exemptions to support MCI using highways owner schema. In NM_4600_fix3
-- 
------------------------------------------------------------------
--
----------------------------------------------------------------------------------------
--
Insert into NM_SDE_SUB_LAYER_EXEMPT
( NSSL_OBJECT_NAME, NSSL_OBJECT_TYPE)
select 'V_MCP_EXTRACT%', 'VIEW'
from dual
where not exists ( select 1 from NM_SDE_SUB_LAYER_EXEMPT
                   where  NSSL_OBJECT_NAME = 'V_MCP_EXTRACT%'
				   and    NSSL_OBJECT_TYPE = 'VIEW' )
/				   
				   
--
----------------------------------------------------------------------------------------
--

Insert into NM_SDE_SUB_LAYER_EXEMPT
( NSSL_OBJECT_NAME, NSSL_OBJECT_TYPE)
select 'V_MCP_UPLOAD%', 'VIEW'
from dual
where not exists ( select 1 from NM_SDE_SUB_LAYER_EXEMPT
                   where  NSSL_OBJECT_NAME = 'V_MCP_UPLOAD%'
				   and    NSSL_OBJECT_TYPE = 'VIEW' )
/				   

--
----------------------------------------------------------------------------------------
--

SET TERM ON
PROMPT Bentley Select Licesning Metadata
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- Metadata to support Bentley Select Licensing
-- 
------------------------------------------------------------------
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1370
       ,'Exor Accidents Manager'
       ,'ACC' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'ACC'
                    AND  BS_PRODUCT_ID = 1370);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1339
       ,'Exor Asset Manager'
       ,'AST' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'AST'
                    AND  BS_PRODUCT_ID = 1339);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1371
       ,'Exor Street Lighting Manager'
       ,'CLM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'CLM'
                    AND  BS_PRODUCT_ID = 1371);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1340
       ,'Exor Enquiry Manager'
       ,'ENQ' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'ENQ'
                    AND  BS_PRODUCT_ID = 1340);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1341
       ,'Exor Information Manager'
       ,'IM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'IM'
                    AND  BS_PRODUCT_ID = 1341);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1342
       ,'Exor Maintenance Manager'
       ,'MAI' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'MAI'
                    AND  BS_PRODUCT_ID = 1342);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1344
       ,'Exor MapCapture'
       ,'MCP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'MCP'
                    AND  BS_PRODUCT_ID = 1344);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1343
       ,'Exor Maintenance Mobile'
       ,'MMO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'MMO'
                    AND  BS_PRODUCT_ID = 1343);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1345
       ,'Exor Network Event Manager'
       ,'NEM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'NEM'
                    AND  BS_PRODUCT_ID = 1345);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1346
       ,'Exor Network Manager'
       ,'NET' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'NET'
                    AND  BS_PRODUCT_ID = 1346);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1351
       ,'Exor Street Gazetteer Manager'
       ,'NSG' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'NSG'
                    AND  BS_PRODUCT_ID = 1351);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1348
       ,'Exor Public Rights of Way'
       ,'PROW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'PROW'
                    AND  BS_PRODUCT_ID = 1348);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1350
       ,'Exor Spatial Manager'
       ,'SM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'SM'
                    AND  BS_PRODUCT_ID = 1350);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1466
       ,'Exor Spatial Manager'
       ,'SM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'SM'
                    AND  BS_PRODUCT_ID = 1466);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1352
       ,'Exor Streetworks Mobile'
       ,'SMO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'SMO'
                    AND  BS_PRODUCT_ID = 1352);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1349
       ,'Exor Schemes Manager'
       ,'STP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'STP'
                    AND  BS_PRODUCT_ID = 1349);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1353
       ,'Exor Structures Manager'
       ,'STR' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'STR'
                    AND  BS_PRODUCT_ID = 1353);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1372
       ,'Exor Streetworks Manager'
       ,'SWR' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'SWR'
                    AND  BS_PRODUCT_ID = 1372);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1355
       ,'Exor Traffic Interface Manager'
       ,'TM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'TM'
                    AND  BS_PRODUCT_ID = 1355);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1347
       ,'Exor TMA Manager'
       ,'TMA' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'TMA'
                    AND  BS_PRODUCT_ID = 1347);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1354
       ,'Exor TMA API and Web Service'
       ,'TMA' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'TMA'
                    AND  BS_PRODUCT_ID = 1354);
--
INSERT INTO BENTLEY_SELECT
       (BS_PRODUCT_ID
       ,BS_PRODUCT_NAME
       ,BS_HPR_PRODUCT
       )
SELECT 
        1356
       ,'Exor UKPMS'
       ,'UKP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM BENTLEY_SELECT
                   WHERE BS_HPR_PRODUCT = 'UKP'
                    AND  BS_PRODUCT_ID = 1356);
--

------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

