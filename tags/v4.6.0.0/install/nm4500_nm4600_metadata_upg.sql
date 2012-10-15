------------------------------------------------------------------
-- nm4500_nm4600_metadata_upg.sql
------------------------------------------------------------------

------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4500_nm4600_metadata_upg.sql-arc   1.3   Oct 15 2012 10:10:48   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4500_nm4600_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Oct 15 2012 10:10:48  $
--       Date fetched Out : $Modtime:   Oct 15 2012 10:10:20  $
--       Version          : $Revision:   1.3  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011


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

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

