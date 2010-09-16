------------------------------------------------------------------
-- nm4210_nm4300_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4210_nm4300_metadata_upg.sql-arc   3.1   Sep 16 2010 17:42:00   Mike.Alexander  $
--       Module Name      : $Workfile:   nm4210_nm4300_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Sep 16 2010 17:42:00  $
--       Date fetched Out : $Modtime:   Sep 16 2010 17:40:52  $
--       Version          : $Revision:   3.1  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010

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
     , 'Y'
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


DELETE FROM hig_navigator_modules WHERE HNM_MODULE_NAME IN  ('NM0510','NM0590') ;

INSERT INTO HIG_NAVIGATOR_MODULES
   (HNM_MODULE_NAME, HNM_MODULE_PARAM, HNM_PRIMARY_MODULE, HNM_SEQUENCE, HNM_TABLE_NAME, 
    HNM_FIELD_NAME, HNM_HIERARCHY_LABEL, HNM_DATE_CREATED, HNM_CREATED_BY, HNM_DATE_MODIFIED, 
    HNM_MODIFIED_BY)
 VALUES
   ('NM0510', 'query_inv_item', 'Y', 1, NULL, 
    NULL, 'Asset', To_Date('02/22/2010 16:53:43', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', To_Date('02/22/2010 16:53:43', 'MM/DD/YYYY HH24:MI:SS'), 
    'DORSET');
    
INSERT INTO HIG_NAVIGATOR_MODULES
   (HNM_MODULE_NAME, HNM_MODULE_PARAM, HNM_PRIMARY_MODULE, HNM_SEQUENCE, HNM_TABLE_NAME, 
    HNM_FIELD_NAME, HNM_HIERARCHY_LABEL, HNM_DATE_CREATED, HNM_CREATED_BY, HNM_DATE_MODIFIED, 
    HNM_MODIFIED_BY)
 VALUES
   ('NM0590', 'query_inv_item', 'N', 2, NULL, 
    NULL, 'Asset', To_Date('03/30/2010 17:43:05', 'MM/DD/YYYY HH24:MI:SS'), 'DORSET', To_Date('03/30/2010 17:43:05', 'MM/DD/YYYY HH24:MI:SS'), 
    'DORSET');


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
PROMPT New Error Message
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109750
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- New Error Message for doc0120 form.
-- 
------------------------------------------------------------------
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

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

