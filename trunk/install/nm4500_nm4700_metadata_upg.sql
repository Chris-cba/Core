------------------------------------------------------------------
-- nm4500_nm4700_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4500_nm4700_metadata_upg.sql-arc   1.0   Aug 19 2013 17:34:36   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4500_nm4700_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Aug 19 2013 17:34:36  $
--       Date fetched Out : $Modtime:   Aug 19 2013 17:25:14  $
--       Version          : $Revision:   1.0  $
--
------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

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
PROMPT New process to clean up forms parameter table everyday
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New process to clean up forms parameter table everyday
-- 
------------------------------------------------------------------
Begin
  Insert Into Hig_Process_Types
  (
  Hpt_Process_Type_Id,
  Hpt_Name,
  Hpt_Descr,
  Hpt_What_To_Call,
  Hpt_Initiation_Module,
  Hpt_Internal_Module,
  Hpt_Internal_Module_Param,
  Hpt_Process_Limit,
  Hpt_Restartable,
  Hpt_See_In_Hig2510,
  Hpt_Polling_Enabled,
  Hpt_Polling_Ftp_Type_Id,
  Hpt_Area_Type
  )
  Values
  ( 
  -3,
  'Core Housekeeping',
  'A general collection of Core housekeeping routines.',
  'Hig_Router_Params_Utils.Clear_Down_Old_Params;',
  Null,
  Null,
  Null,
  Null,
  'N',
  'Y',
  'N',
  Null,
  Null
  ); 
Exception
  When Dup_Val_On_Index Then
    Null;
End;  
/

Begin                   
  Insert Into Hig_Process_Type_Roles
  (
  Hptr_Process_Type_Id,
  Hptr_Role
  )
  Values
  ( 
  -3,
  'NET_ADMIN' 
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

Begin
  Insert Into Hig_Process_Type_Frequencies
  (
  Hpfr_Process_Type_Id,
  Hpfr_Frequency_Id,
  Hpfr_Seq
  )
  Values 
  (
  -3,
  -11,
  1
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

Declare
  l_Process_Id            Hig_Processes.Hp_Process_Id%Type;
  l_Job_Name              Hig_Processes.Hp_Job_Name%Type;
  l_Scheduled_Start_Date  Date;
Begin
  dbms_scheduler.set_scheduler_attribute('SCHEDULER_DISABLED', 'FALSE');
--
  Hig_Process_Api.Create_And_Schedule_Process (
                                              pi_Process_Type_Id           =>   -3,
                                              pi_Initiators_Ref            =>   'COREHOUSE',
                                              pi_Start_Date                =>   Sysdate,
                                              pi_Frequency_Id              =>   -11,
                                              po_Process_Id                =>   l_Process_Id,
                                              po_Job_Name                  =>   l_Job_Name,
                                              po_Scheduled_Start_Date      =>   l_Scheduled_Start_Date
                                              );
  dbms_scheduler.set_scheduler_attribute('SCHEDULER_DISABLED', 'TRUE');
--
   Commit;
  Dbms_Output.Put_Line('Created Core Houseleeping Process');                                              
  Dbms_Output.Put_Line('Process_Id:'            || To_Char(l_Process_Id) );
  Dbms_Output.Put_Line('Job_Name:'              || l_Job_Name);
  Dbms_Output.Put_Line('Scheduled_Start_Date:'  || To_Char(l_Scheduled_Start_Date,'dd-mm-yyyy hh24:mi.ss'));  
End;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New messages used within the user form hig1832.
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New messages used within the user form hig1832.
-- 
------------------------------------------------------------------
Begin
  Insert Into Nm_Errors
  (
  Ner_Appl,
  Ner_Id,
  Ner_Descr
  )
  Values
  (
  'NET',
  559,
  'User Successfully Unlocked'
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
  Ner_Descr
  )
  Values
  (
  'NET',
  560,
  'Invalid Username'
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Error Messages
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New error message for Navigator and error messages that may not be present due to possible failure of previous upgrade.
-- 
------------------------------------------------------------------
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'HIG'
     , 557
     , 'Asset is end dated'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'HIG'
                       AND NER_ID = 557)
/

INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,453
       ,null
       ,'Invalid module'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 453)
/

INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,465
       ,null
       ,'You cannot perform a network based query without at least the LR NE_ID column set on the asset metamodel.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 465)
/
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,466
       ,null
       ,'Cannot find Document Gateway table or appropriate synonym.'
       ,'Add the relevant table and/or synonym using the Document Gateway form (DOC0130)' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 466)
/
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,467
       ,null
       ,'The User has not been assigned the correct admin units to carry out this action.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 467)
/
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,468
       ,null
       ,'Please ensure all datum networks are registered with 3D diminfo.'
       ,'Subscript beyond count' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 468)
/
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,469
       ,null
       ,'The selected network and asset item do not exist at this effective date.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 469)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT add metadata for navigator
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ROB COUPE)
-- Metadata to support the querying of asset and related data in the Navigator module
-- 
------------------------------------------------------------------
SET TERM ON
PROMPT hig_navigator
SET TERM OFF

INSERT INTO HIG_NAVIGATOR
       (HNV_HIERARCHY_TYPE
       ,HNV_PARENT_TABLE
       ,HNV_PARENT_COLUMN
       ,HNV_CHILD_TABLE
       ,HNV_CHILD_COLUMN
       ,HNV_HIERARCHY_LEVEL
       ,HNV_HIERARCHY_LABEL
       ,HNV_PARENT_ID
       ,HNV_CHILD_ID
       ,HNV_PARENT_ALIAS
       ,HNV_CHILD_ALIAS
       ,HNV_ICON_NAME
       ,HNV_ADDITIONAL_COND
       ,HNV_PRIMARY_HIERARCHY
       ,HNV_HIER_LABEL_1
       ,HNV_HIER_LABEL_2
       ,HNV_HIER_LABEL_3
       ,HNV_HIER_LABEL_4
       ,HNV_HIER_LABEL_5
       ,HNV_HIER_LABEL_6
       ,HNV_HIER_LABEL_7
       ,HNV_HIER_LABEL_8
       ,HNV_HIER_LABEL_9
       ,HNV_HIER_LABEL_10
       ,HNV_HIERARCHY_SEQ
       ,HNV_DATE_CREATED
       ,HNV_CREATED_BY
       ,HNV_DATE_MODIFIED
       ,HNV_MODIFIED_BY
       ,HNV_HPR_PRODUCT
       )
SELECT 
        'Assets'
       ,''
       ,''
       ,'nm_inv_items_all'
       ,'iit_ne_id'
       ,1
       ,'Asset'
       ,''
       ,'nm_inv_items_all.iit_ne_id'
       ,''
       ,'-AST1'
       ,'asset'
       ,''
       ,'Y'
       ,'iit_inv_type'
       ,'hig_nav.concate_label(hig_nav.get_asset_type_descr(iit_inv_type))'
       ,'hig_nav.concate_label(iit_ne_id)'
       ,'hig_nav.concate_label(iit_primary_key)'
       ,'hig_nav.concate_label(hig_nav.get_admin_unit_name(iit_admin_unit))'
       ,'hig_nav.concate_label(iit_start_date)'
       ,'hig_nav.concate_label(iit_end_date)'
       ,''
       ,''
       ,''
       ,null
       ,sysdate
       ,user
       ,sysdate
       ,user
       ,'AST' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_NAVIGATOR
                   WHERE HNV_CHILD_ALIAS = '-AST1');
/

SET TERM ON
PROMPT hig_navigator_modules
SET TERM OFF

INSERT INTO HIG_NAVIGATOR_MODULES
       (HNM_MODULE_NAME
       ,HNM_MODULE_PARAM
       ,HNM_PRIMARY_MODULE
       ,HNM_SEQUENCE
       ,HNM_TABLE_NAME
       ,HNM_FIELD_NAME
       ,HNM_HIERARCHY_LABEL
       ,HNM_DATE_CREATED
       ,HNM_CREATED_BY
       ,HNM_DATE_MODIFIED
       ,HNM_MODIFIED_BY
       )
SELECT 
        'NM0510'
       ,'query_inv_item'
       ,'Y'
       ,1
       ,''
       ,''
       ,'Asset'
       ,sysdate
       ,user
       ,sysdate
       ,user FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_NAVIGATOR_MODULES
                   WHERE HNM_MODULE_NAME = 'NM0510'
                    AND  HNM_MODULE_PARAM = 'query_inv_item'
                    AND  HNM_HIERARCHY_LABEL = 'Asset')
/
--
INSERT INTO HIG_NAVIGATOR_MODULES
       (HNM_MODULE_NAME
       ,HNM_MODULE_PARAM
       ,HNM_PRIMARY_MODULE
       ,HNM_SEQUENCE
       ,HNM_TABLE_NAME
       ,HNM_FIELD_NAME
       ,HNM_HIERARCHY_LABEL
       ,HNM_DATE_CREATED
       ,HNM_CREATED_BY
       ,HNM_DATE_MODIFIED
       ,HNM_MODIFIED_BY
       )
SELECT 
        'NM0590'
       ,'query_inv_item'
       ,'N'
       ,2
       ,''
       ,''
       ,'Asset'
       ,sysdate
       ,user
       ,sysdate
       ,user FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_NAVIGATOR_MODULES
                   WHERE HNM_MODULE_NAME = 'NM0590'
                    AND  HNM_MODULE_PARAM = 'query_inv_item'
                    AND  HNM_HIERARCHY_LABEL = 'Asset')
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

