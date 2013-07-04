------------------------------------------------------------------
-- nm4210_nm4300_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4210_nm4300_metadata_upg.sql-arc   3.10   Jul 04 2013 14:16:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4210_nm4300_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       Version          : $Revision:   3.10  $
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
PROMPT SDOBATSIZE product option reintroduced
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109470
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Adding product option SDOBATSIZE with a default value of 100
-- 
------------------------------------------------------------------
INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks      
                            ,hol_datatype     
                            ,hol_mixed_case   
                            ,hol_user_option  
                            ,hol_max_length)
SELECT 'SDOBATSIZE'
     , 'HIG'
     , 'Batch size used in SDO'
     , 'This value is used as an array fetch size in some SDO cursors. It should be increased from the default in situations where large volumes of data have been end-dated or where view definitions are very restrictive over and above the native base spatial table'
     , 'VARCHAR2'
     , 'N'
     , 'N'
     , '10'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'SDOBATSIZE')
/

INSERT INTO hig_option_values ( hov_id
                                                   , hov_value)
SELECT 'SDOBATSIZE'
     , '10'
  FROM dual
 WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_values
                    WHERE hov_id = 'SDOBATSIZE')
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT EDITENDDAT product option
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109041
-- 
-- TASK DETAILS
-- Requirements BR2.1.022 and BR2.1.023 for TFL
-- The system will allow querying of closed assets when setting the Effective Date to an appropriate date when the Asset was still 'open'.
-- The system will then allow editing of this Asset (attributes only) if it is the latest occurance of this Asset, checked by Primary Key value.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Product option to determine if Edit Latest Asset functionality is enabled.
-- .
-- 
------------------------------------------------------------------
INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks      
                            ,hol_datatype     
                            ,hol_domain
                            ,hol_mixed_case   
                            ,hol_user_option  
                            ,hol_max_length)
SELECT 'EDITENDDAT'
     , 'NET'
     , 'Allow Latest Asset Edit'
     , 'If set to Y the user will be allowed to edit the latest asset even if the effective date is not today. When it is set to N then the effective date will need to be set to today for edits to take place.'
     , 'VARCHAR2'
     , 'Y_OR_N'
     , 'N'
     , 'N'
     , '1'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'EDITENDDAT')
/

INSERT INTO hig_option_values ( hov_id
                              , hov_value)
SELECT 'EDITENDDAT'
     , 'N'
  FROM dual
 WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_values
                    WHERE hov_id = 'EDITENDDAT')
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Error Messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109041
-- 
-- TASK DETAILS
-- Requirements BR2.1.022 and BR2.1.023 for TFL
-- The system will allow querying of closed assets when setting the Effective Date to an appropriate date when the Asset was still 'open'.
-- The system will then allow editing of this Asset (attributes only) if it is the latest occurance of this Asset, checked by Primary Key value.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- New Error Messages
-- 
------------------------------------------------------------------
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 464
     , 'Update is not allowed. This is not the latest occurrence of the asset.'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 464)
/

INSERT INTO nm_errors
  SELECT 'HIG'
       , 547
       , NULL
       , 'Invalid geometry.'
       , NULL
    FROM dual
   WHERE NOT EXISTS
               (SELECT 1
                  FROM nm_errors
                 WHERE ner_appl = 'HIG' AND ner_id = 547)
/

INSERT INTO nm_errors
SELECT 'NET',465,NULL,'You cannot perform a network based query without at least the LR NE_ID column set on the asset metamodel.',NULL
  FROM dual
 WHERE NOT EXISTS
  (SELECT 1 FROM nm_errors
    WHERE ner_id = 465
      AND ner_appl = 'NET')
/

INSERT INTO nm_errors
   SELECT 'NET',
          466,
          NULL,
          'Cannot find Document Gateway table or appropriate synonym.',
          'Add the relevant table and/or synonym using the Document Gateway form (DOC0130)'
     FROM DUAL
    WHERE NOT EXISTS
             (SELECT 1
                FROM nm_errors
               WHERE ner_appl = 'NET' AND ner_id = 466)
/

INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 467
     , 'The User has not been assigned the correct admin units to carry out this action.'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 467)
/

INSERT INTO nm_errors ( ner_appl
                      , ner_id
                      , ner_descr
                      , ner_cause)
SELECT 'NET'
      , 468
      , 'Please ensure all datum networks are registered with 3D diminfo.'
      , 'Subscript beyond count'
  FROM dual
 WHERE NOT EXISTS (SELECT 'X' 
                     FROM nm_errors
                    WHERE ner_appl = 'NET'
                      AND ner_id = 468)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator Ref data
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110107
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Road Unique displayed instead of Road ID
-- 
------------------------------------------------------------------
UPDATE hig_navigator 
SET     hnv_hier_label_3 = 'hig_nav.concate_label(hig_nav.get_road_unique(wol_rse_he_id))'
WHERE Upper(hnv_child_table) = 'WORK_ORDER_LINES';

Insert into HIG_NAVIGATOR_MODULES
   (HNM_MODULE_NAME, HNM_MODULE_PARAM, HNM_PRIMARY_MODULE, HNM_SEQUENCE, HNM_TABLE_NAME, 
    HNM_FIELD_NAME, HNM_HIERARCHY_LABEL, HNM_DATE_CREATED, HNM_CREATED_BY, HNM_DATE_MODIFIED, 
    HNM_MODIFIED_BY)
Select 'NM0510', 'query_inv_item', 'Y', 1, NULL, 
    NULL, 'Asset', TO_DATE('02/22/2010 16:53:43', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', TO_DATE('02/22/2010 16:53:43', 'MM/DD/YYYY HH24:MI:SS'), 
    'DORSET'
From Dual
Where Not Exists (Select 1 From HIG_NAVIGATOR_MODULES Where HNM_MODULE_NAME = 'NM0510' And HNM_MODULE_PARAM = 'query_inv_item' And HNM_HIERARCHY_LABEL = 'Asset');
    
Insert into HIG_NAVIGATOR_MODULES
   (HNM_MODULE_NAME, HNM_MODULE_PARAM, HNM_PRIMARY_MODULE, HNM_SEQUENCE, HNM_TABLE_NAME, 
    HNM_FIELD_NAME, HNM_HIERARCHY_LABEL, HNM_DATE_CREATED, HNM_CREATED_BY, HNM_DATE_MODIFIED, 
    HNM_MODIFIED_BY)
Select 'NM0590', 'query_inv_item', 'N', 2, NULL, 
    NULL, 'Asset', TO_DATE('03/30/2010 17:43:05', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', TO_DATE('03/30/2010 17:43:05', 'MM/DD/YYYY HH24:MI:SS'), 
    'DORSET'
From Dual
Where Not Exists (Select 1 From HIG_NAVIGATOR_MODULES Where HNM_MODULE_NAME = 'NM0590' And HNM_MODULE_PARAM = 'query_inv_item' And HNM_HIERARCHY_LABEL = 'Asset');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Changed the error message
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110131
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Changed the error message
-- 
------------------------------------------------------------------
UPDATE nm_errors 
SET       ner_descr = 'The trigger has been dropped. Please use the Create Trigger button to reflect changes made to the definition.'
WHERE  ner_id       = 527
AND      ner_appl   = 'HIG';


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT ID Tool Product Option
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- ID Tool Product Option
-- 
------------------------------------------------------------------
Insert Into hig_option_list( hol_id
                           , hol_product
                           , hol_name
                           , hol_remarks
                           , hol_domain
                           , hol_datatype
                           , hol_mixed_case
                           , hol_user_option
                           , hol_max_length
                           )
                      Select 'WEBMAPIDBF'
                           , 'WMP'
                           , 'ID Tool Buffer'
                           , 'Buffer used when selecting features for the ID Tool'
                           , Null
                           , 'VARCHAR2'
                           , 'N'
                           , 'N'
                           , 2000
                      From   Dual
                      Where Not Exists (Select 1
                                        From   hig_option_list
                                        Where  hol_id = 'WEBMAPIDBF'
                                       );
                                        

Insert Into hig_option_values( hov_id
                             , hov_value
                             )
                        Select 'WEBMAPIDBF'
                             , '20'
                        From   Dual
                        Where Not Exists (Select 1
                                          From   hig_option_values
                                          Where  hov_id = 'WEBMAPIDBF'
                                         );

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Error for Framework
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110221
-- 
-- TASK DETAILS
-- TMA supporting database jobs have now been converted to run via the Process Framework in order to give visibility and also to allow all these processes to be easily amended, disabled, enabled.
-- 
-- In particular the driving requirement behind this is so that an administrator could disable the processes which send/recieve transactions whilst system maintenance and or gazetteer loading is taking place.
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- Called when checking existence of a process of a given type which is either Running or Scheduled
-- 
------------------------------------------------------------------
delete from nm_errors
where ner_appl = 'HIG'
and ner_id = 548
/

Insert into NM_ERRORS
   (NER_APPL, NER_ID, NER_DESCR)
 Values
   ('HIG', 548, 'Application is not configured correctly.');


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT PRO$ meta model setup
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109686
-- 
-- TASK DETAILS
-- N/A
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- **** COMMENTS TO BE ADDED BY LINESH SORATHIA ****
-- 
------------------------------------------------------------------
Prompt Inserting into  NM_INV_TYPES_ALL
INSERT INTO NM_INV_TYPES_ALL
       (NIT_INV_TYPE
       ,NIT_PNT_OR_CONT
       ,NIT_X_SECT_ALLOW_FLAG
       ,NIT_ELEC_DRAIN_CARR
       ,NIT_CONTIGUOUS
       ,NIT_REPLACEABLE
       ,NIT_EXCLUSIVE
       ,NIT_CATEGORY
       ,NIT_DESCR
       ,NIT_LINEAR
       ,NIT_USE_XY
       ,NIT_MULTIPLE_ALLOWED
       ,NIT_END_LOC_ONLY
       ,NIT_SCREEN_SEQ
       ,NIT_VIEW_NAME
       ,NIT_START_DATE
       ,NIT_END_DATE
       ,NIT_SHORT_DESCR
       ,NIT_FLEX_ITEM_FLAG
       ,NIT_TABLE_NAME
       ,NIT_LR_NE_COLUMN_NAME
       ,NIT_LR_ST_CHAIN
       ,NIT_LR_END_CHAIN
       ,NIT_ADMIN_TYPE
       ,NIT_ICON_NAME
       ,NIT_TOP
       ,NIT_FOREIGN_PK_COLUMN
       ,NIT_UPDATE_ALLOWED
       ,NIT_DATE_CREATED
       ,NIT_DATE_MODIFIED
       ,NIT_MODIFIED_BY
       ,NIT_CREATED_BY
       ,NIT_NOTES
       )
SELECT 
        'PRO$'
       ,'P'
       ,'N'
       ,'C'
       ,'N'
       ,'N'
       ,'N'
       ,'A'
       ,'Process Alerts'
       ,'N'
       ,'N'
       ,'N'
       ,'N'
       ,null
       ,'V_NM_PRO$'
       ,to_date('19010101000000','YYYYMMDDHH24MISS')
       ,null
       ,''
       ,'N'
       ,'HIG_PROCESS_ALERT_LOG'
       ,''
       ,''
       ,''
       ,'EXT$'
       ,''
       ,'N'
       ,'HPAL_ID'
       ,'Y'
       ,Sysdate
       ,sysdate
       ,USER
       ,USER
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_INV_TYPES_ALL
                   WHERE NIT_INV_TYPE = 'PRO$');

Delete FROM NM_INV_TYPE_ATTRIBS_ALL
WHERE ita_inv_type = 'PRO$';


Prompt Inserting into  NM_INV_TYPE_ATTRIBS_ALL
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_ID', 'N', 1, 'N', 
    'NUMBER', 38, NULL, 'Primary Key', NULL, 
    'N', NULL, NULL, NULL, 'ID', 
    'ID', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:34:32', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:34:32', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', NULL, 'N', 
    NULL, 'N', 'UPPER');
  Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_ADMIN_UNIT', 'N', 2, 'N', 
    'NUMBER', 9, NULL, 'Admin Unit ID', NULL, 
    'N', NULL, NULL, NULL, 'ADMIN_UNIT', 
    'ADMIN_UNIT', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:34:52', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:34:52', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', 'select nau_unit_code,nau_name,nau_admin_unit 
  from nm_admin_units', 'N', 
    NULL, 'N', 'UPPER');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_CONTRACT_ID', 'N', 3, 'N', 
    'VARCHAR2', 10, NULL, 'Contract ID', NULL, 
    'N', NULL, NULL, NULL, 'CON_ID', 
    'CON_ID', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:35:39', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:35:39', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', Null, 'N', 
    NULL, 'N', 'MIXED');
  Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_CON_CODE', 'N', 4, 'N', 
    'VARCHAR2', 10, NULL, 'Contract Code', NULL, 
    'N', NULL, NULL, NULL, 'CON_CODE', 
    'CON_CODE', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:35:39', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:35:39', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET',null, 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_CON_NAME', 'N', 5, 'N', 
    'VARCHAR2', 40, NULL, 'Contractor Name', NULL, 
    'N', NULL, NULL, NULL, 'CON_NAME', 
    'CON_NAME', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:36:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:36:00', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET',null, 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_EMAIL_BODY', 'N', 6, 'N', 
    'VARCHAR2', 500, NULL, 'Text 2', NULL, 
    'N', NULL, NULL, NULL, 'TEXT_2', 
    'TEXT_2', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:36:36', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:36:36', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', NULL, 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_EMAIL_SUBJECT', 'N', 7, 'N', 
    'VARCHAR2', 100, NULL, 'Text 1', NULL, 
    'N', NULL, NULL, NULL, 'TEXT_1', 
    'TEXT_1', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:37:02', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:37:02', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', NULL, 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_INITIATED_USER', 'N', 8, 'N', 
    'VARCHAR2', 30, NULL, 'Initiator', NULL, 
    'N', NULL, NULL, NULL, 'INITIATOR', 
    'INITIATOR', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:38:00', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:38:00', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', 'SELECT hus_initials,hus_name,hus_username
    FROM hig_users
    WHERE hus_end_date is null', 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_PROCESS_TYPE_ID', 'N', 9, 'N', 
    'NUMBER', 38, NULL, 'Process Type ID', NULL, 
    'N', NULL, NULL, NULL, 'PROCESS_TYPE', 
    'PROCESS_TYPE', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:38:29', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:39:47', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', 'SELECT HPT_NAME,HPT_DESCR,HPT_PROCESS_TYPE_ID FROM HIG_PROCESS_TYPES
ORDER BY HPT_NAME', 'N', 
    NULL, 'N', 'UPPER');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_UNIT_CODE', 'N', 10, 'N', 
    'VARCHAR2', 10, NULL, 'Admin Unit Code', NULL, 
    'N', NULL, NULL, NULL, 'UNIT_CODE', 
    'UNIT_CODE', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:40:40', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:40:40', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', 'SELECT nau_unit_code,nau_name,nau_unit_code
    FROM   nm_admin_units', 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_UNIT_NAME', 'N', 11, 'N', 
    'VARCHAR2', 40, NULL, 'Admin Unit Name', NULL, 
    'N', NULL, NULL, NULL, 'UNIT_NAME', 
    'UNIT_NAME', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:40:40', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:40:40', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', 'SELECT nau_unit_code,nau_name,nau_name
    FROM   nm_admin_units', 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_PROCESS_ID', 'N', 12, 'N', 
    'NUMBER', 38, NULL, 'Process ID', NULL, 
    'N', NULL, NULL, NULL, 'Process_ID', 
    'Process_ID', TO_DATE('05/05/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/05/2010 17:40:40', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/05/2010 17:40:40', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', 'DORSET', NULL, 'N', 
    NULL, 'N', 'MIXED');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_JOB_RUN_SEQ', 'N', 13, 'N', 
    'NUMBER', 38, NULL, 'Job Run Seq', NULL, 
    'N', NULL, NULL, NULL, 'JOB_RUN_SEQ', 
    'JOB_RUN_SEQ', TO_DATE('05/10/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/10/2010 14:07:14', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/10/2010 14:07:14', 'MM/DD/YYYY HH24:MI:SS'), 'HIGHWAYS', 'HIGHWAYS', NULL, 'N', 
    NULL, 'N', 'UPPER');
Insert into NM_INV_TYPE_ATTRIBS_ALL
   (ITA_INV_TYPE, ITA_ATTRIB_NAME, ITA_DYNAMIC_ATTRIB, ITA_DISP_SEQ_NO, ITA_MANDATORY_YN, 
    ITA_FORMAT, ITA_FLD_LENGTH, ITA_DEC_PLACES, ITA_SCRN_TEXT, ITA_ID_DOMAIN, 
    ITA_VALIDATE_YN, ITA_DTP_CODE, ITA_MAX, ITA_MIN, ITA_VIEW_ATTRI, 
    ITA_VIEW_COL_NAME, ITA_START_DATE, ITA_END_DATE, ITA_QUERYABLE, ITA_UKPMS_PARAM_NO, 
    ITA_UNITS, ITA_FORMAT_MASK, ITA_EXCLUSIVE, ITA_KEEP_HISTORY_YN, ITA_DATE_CREATED, 
    ITA_DATE_MODIFIED, ITA_MODIFIED_BY, ITA_CREATED_BY, ITA_QUERY, ITA_DISPLAYED, 
    ITA_DISP_WIDTH, ITA_INSPECTABLE, ITA_CASE)
 Values
   ('PRO$', 'HPAL_SUCCESS_FLAG', 'N', 14, 'N', 
    'VARCHAR2', 1, NULL, 'Outcome', NULL, 
    'N', NULL, NULL, NULL, 'OUTCOME', 
    'OUTCOME', TO_DATE('05/10/2010 00:00:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 'N', NULL, 
    NULL, NULL, 'N', 'N', TO_DATE('05/10/2010 14:08:05', 'MM/DD/YYYY HH24:MI:SS'), 
    TO_DATE('05/10/2010 14:11:18', 'MM/DD/YYYY HH24:MI:SS'), 'HIGHWAYS', 'HIGHWAYS', 'SELECT HCO_CODE,HCO_MEANING,HCO_CODE CODE FROM HIG_CODES WHERE 
HCO_DOMAIN = ''PROCESS_SUCCESS_FLAG'' AND HCO_CODE != ''TBD'' 
ORDER BY HCO_SEQ', 'N', 
    NULL, 'N', 'MIXED');

INSERT INTO NM_INV_TYPE_ROLES
SELECT 'PRO$','HIG_USER','NORMAL'
FROM dual 
WHERE NOT EXISTS  (SELECT 'x' FROM NM_INV_TYPE_ROLES
                   WHERE  itr_inv_type ='PRO$'
                   AND    itr_hro_role = 'HIG_USER'
                   AND    itr_mode = 'NORMAL');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Refresh Processes due to Process Framework changes
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110229
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS BAUGH)
-- Changes to hig_process_framework package requires refresh of scheduled processes to incorporate changes made
-- 
------------------------------------------------------------------
DECLARE

   CURSOR C_amend IS
   SELECT *
     FROM hig_processes_v
    WHERE hpj_schedule_type = 'CALENDAR';
BEGIN
  
  FOR l_process_rec IN C_amend LOOP

     nm3jobs.amend_job_action(pi_job_name => l_process_rec.hp_full_job_name
                             ,pi_value    => hig_process_framework.wrapper_around_what(pi_what_to_call  => l_process_rec.hp_what_to_call
                                                                                      ,pi_process_id    => l_process_rec.hp_process_id));                                                      
  END LOOP;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Character Sets metadata
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Character Sets metadata
-- 
------------------------------------------------------------------
INSERT INTO NM_CHARACTER_SETS
       (NCS_CODE
       ,NCS_DESCRIPTION
       )
SELECT 
        'INVALID_FOR_DDL'
       ,'Invalid Characters for DDL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SETS
                   WHERE NCS_CODE = 'INVALID_FOR_DDL');

INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,32 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 32);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,33 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 33);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,34 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 34);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,35 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 35);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,36 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 36);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,37 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 37);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,38 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 38);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,39 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 39);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 40);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,41 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 41);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,42 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 42);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,43 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 43);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,44 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 44);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,45 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 45);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,46 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 46);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,47 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 47);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,58 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 58);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,59 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 59);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 60);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,61 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 61);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,62 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 62);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,63 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 63);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 64);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,91 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 91);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,92 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 92);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,93 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 93);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,94 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 94);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,96 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 96);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,123 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 123);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,124 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 124);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,125 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 125);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,126 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 126);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,127 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 127);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,128 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 128);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,129 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 129);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,130 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 130);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,131 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 131);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,132 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 132);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,133 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 133);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,134 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 134);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,135 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 135);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,136 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 136);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,137 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 137);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,138 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 138);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,139 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 139);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,140 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 140);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,141 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 141);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,142 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 142);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,143 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 143);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,144 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 144);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,145 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 145);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,146 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 146);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,147 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 147);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,148 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 148);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,149 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 149);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,150 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 150);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,151 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 151);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,152 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 152);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,153 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 153);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,154 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 154);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,155 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 155);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,156 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 156);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,157 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 157);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,158 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 158);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 159);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,160 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 160);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,161 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 161);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,162 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 162);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,163 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 163);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,164 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 164);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,165 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 165);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,166 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 166);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,167 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 167);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 168);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,169 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 169);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,170 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 170);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 171);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,172 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 172);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New error message NET 469
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108684
-- 
-- TASK DETAILS
-- Asset modules - Locating an asset on a date before the network was open now being handled with a sensible error message.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- New Error Message
-- 
------------------------------------------------------------------
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 469
     , 'The selected network does not exist at this effective date.'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 469)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Error Message HIG 549
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110222
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- New Error Message
-- 
------------------------------------------------------------------
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'HIG'
     , 549
     , 'It is not possible to create a document when enquiries product is at a version before 4.3.0.0'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'HIG'
                       AND NER_ID = 549)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Remove redundant Hig_Sequence_Assoc records
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (MICHAEL ALEXANDER)
-- This statement was first issued in the 4050 upgrade but not aplied to the metadata account.  It has now been applied to the metadata account and the statement re-issued to remove the obsolete metadata in respect of any occurrences of 4100 or 4200 installations of TMA (data should not have been in this account).
-- 
------------------------------------------------------------------
delete from HIG_SEQUENCE_ASSOCIATIONS where HSA_SEQUENCE_NAME like 'TMA_CNT%'
/

------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

