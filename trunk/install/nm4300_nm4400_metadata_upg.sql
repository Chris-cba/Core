------------------------------------------------------------------
-- nm4300_nm4400_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4300_nm4400_metadata_upg.sql-arc   3.3   Jul 04 2013 14:16:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4300_nm4400_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       Version          : $Revision:   3.3  $
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
PROMPT Error messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108684
-- 
-- TASK DETAILS
-- Asset modules - Locating an asset on a date before the network was open now being handled with a sensible error message.
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 110245
-- 
-- TASK DETAILS
-- Create group from Extent - The extended LOV now returns the correct selected fields all the time.
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 110486
-- 
-- TASK DETAILS
-- Changes in Oracle 11.2  require that access control lists (ACLs) are defined for any host the database attempts to communicate with via FTP or Email protocols. Highways will now maintain an ACL for both FTP and Email, and access is given to users via two new roles, FTP_USER and EMAIL_USER. During the 4.4 upgrade, all users will be given these roles. The roles can be revoked to control usage of FTP and EMail.
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 110665
-- 
-- TASK DETAILS
-- Standard Text functionality has been enhanced to allow for standard text to be appended to details already present in a field. An 'Append Value' button has been added to the Standard Text form (HIG4030), to provide this functionality. A check is made to ensure that appending the text will not exceed the available field width. Error  'NET-0471:Maximum permitted length of text string exceeded' will be produced in such cases
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- New error messages
-- 
------------------------------------------------------------------
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 471
     , 'Maximum permitted length of text string exceeded'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 471)
/

INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 470
     , 'No query has been provided by the calling form. Extended LOV cannot be opened'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 470)
/

UPDATE NM_ERRORS 
SET NER_DESCR = 'The selected network and asset item do not exist at this effective date.'
WHERE NER_APPL = 'NET'
AND NER_ID = 469
/

INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 555
     , 'The password you have entered is invalid.'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X'
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 555)
/
-----------------------------------------------------
-- ACL Errors
-----------------------------------------------------
DELETE nm_errors
 WHERE ner_appl = 'HIG'
   AND ner_id = 550;

INSERT INTO nm_errors
SELECT 'HIG',550,NULL,'Connection to the FTP server is not permitted without FTP_USER role',''
  FROM dual;
  
DELETE nm_errors
 WHERE ner_appl = 'HIG'
   AND ner_id = 551;

INSERT INTO nm_errors
SELECT 'HIG',551,NULL,'Connection to the Email server is not permitted without EMAIL_USER role',''
  FROM dual; 

DELETE nm_errors
 WHERE ner_appl = 'HIG'
   AND ner_id = 552;

INSERT INTO nm_errors
SELECT 'HIG',552,NULL,'The ACL you are trying to create already exists',''
  FROM dual;  

DELETE nm_errors
 WHERE ner_appl = 'HIG'
   AND ner_id = 553;

INSERT INTO nm_errors
SELECT 'HIG',553,NULL,'The ACL privilege you are trying to grant already exists',''
  FROM dual;

DELETE nm_errors
 WHERE ner_appl = 'HIG'
   AND ner_id = 554;

INSERT INTO nm_errors
SELECT 'HIG',554,NULL,'The ACL you are trying to reference does not exist',''
  FROM dual;
-----------------------------------------------------
-- ACL Errors finished
-----------------------------------------------------
-- CWS Process Framework error
--
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'HIG'
     , 555
     , 'The Process Framework is shutting down/shut down. This operation is not currently permitted'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'HIG'
                       AND NER_ID = 555)
/

INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'HIG'
     , 556
     , 'Unable to execute this process'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'HIG'
                       AND NER_ID = 556)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Product Options
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 729255  New Brunswick DOT
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 110688
-- 
-- TASK DETAILS
-- Resequence - A new Product Option SDORESEQ has been introduced to control the way in which shapes are maintained when resequencing a route.
-- 
-- 1.       "H" - Reshape (create new shape)
-- 2.       "U" - Reshape (updated with no history)
-- 3.       "N" - Do nothing with shape
-- 
-- The default is "H" to maintain existing functionality, and if the option is unset, or set to any other value it will default to "H".
-- 
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- New product options.
-- 
------------------------------------------------------------------
--
--  SDORESEQ - Shape options on resequence
--

DELETE hig_option_values WHERE hov_id = 'SDORESEQ';
DELETE hig_option_list WHERE hol_id = 'SDORESEQ';
DELETE hig_codes WHERE hco_domain = 'SDORESEQ';
DELETE hig_domains WHERE hdo_domain = 'SDORESEQ';


INSERT INTO hig_domains
SELECT 'SDORESEQ','HIG','Resequence Shape Options',1 FROM DUAL;

INSERT INTO HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 VALUES
   ('SDORESEQ', 'H', 'Reshape - create new shape', 'Y', 10);
INSERT INTO HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 VALUES
   ('SDORESEQ', 'U', 'Reshape - update with no history', 'Y', 20);
INSERT INTO HIG_CODES
   (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ)
 VALUES
   ('SDORESEQ', 'N', 'Do nothing with the shape', 'Y', 30);

INSERT INTO hig_option_list (hol_id
                            ,hol_product      
                            ,hol_name         
                            ,hol_remarks
                            ,hol_domain
                            ,hol_datatype     
                            ,hol_mixed_case   
                            ,hol_user_option  
                            ,hol_max_length)
SELECT 'SDORESEQ'
     , 'HIG'
     , 'Shape options on resequence'
     , 'When performing a route resequence "H" value (default) will maintain history on the route shapes, "U" value will update shape with no history, "N" value will do nothing with the shape'
     , 'SDORESEQ'
     , 'VARCHAR2'
     , 'N'
     , 'N'
     , '1'
  FROM dual
  WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_list
                    WHERE HOL_ID = 'USEHISTRSQ')
/

INSERT INTO hig_option_values ( hov_id
                              , hov_value)
SELECT 'SDORESEQ'
     , 'H'
  FROM dual
WHERE NOT EXISTS (SELECT 'X' 
                     FROM hig_option_values
                    WHERE hov_id = 'Y')
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hig_module_blocks changes for TMA Linking purposes
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110270
-- 
-- TASK DETAILS
-- Need to associate photos (1 or more) taken by the inspector against the inspection.  Further details found in release notes.
-- 
-- 
-- 
-- DEVELOPMENT COMMENTS (BARBARA O'DRISCOLL)
-- Changes to support TMA Mobile Inspection Photos functionality, need to be able to link to the Document Bundles module.
-- 
------------------------------------------------------------------
INSERT INTO HIG_MODULE_BLOCKS
       (HMB_MODULE_NAME
       ,HMB_BLOCK_NAME
       )
SELECT 
        'DOC0310'
       ,'DOC_BUNDLES_V' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_BLOCKS
                   WHERE HMB_MODULE_NAME = 'DOC0310'
                   AND   HMB_BLOCK_NAME  = 'DOC_BUNDLES_V')
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Update any existing dba_scheduler_jobs which are for exor process types
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110504
-- 
-- TASK DETAILS
-- Set all shipped processes to be non-restartable by default.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Update any existing dba_scheduler_jobs which are for exor process types.
-- 
------------------------------------------------------------------
--
-- Mark existing process types shipped with exor products are non-restartable
--
update hig_process_types
set hpt_restartable = 'N'
where hpt_process_type_id < 1
/
--
-- update any existing dba_scheduler_jobs which are for exor process types which are marked as restartable
--
BEGIN

    FOR p IN (select b.job_name 
                from hig_processes a
                   , dba_scheduler_jobs b
               where a.hp_process_type_id < 1
                 and a.hp_job_name = b.job_name
                and restartable = 'TRUE') 
    LOOP          
              BEGIN              
                NM3JOBS.AMEND_JOB_RESTARTABLE(p.job_name, FALSE);                
              EXCEPTION
                WHEN others THEN
                   Null;
              END;              
    END LOOP;          
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New module hig2550
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109403
-- 
-- TASK DETAILS
-- Introduced functionalty to allow the Process Framework to be switched off.
-- 
-- A new Form HIG2550 Process Framework Administration has been introduced to show the Status of the Process Framework and to allow it to be shut down/started.
-- 
-- Additional pre-upgrade/pre-install checks have been added to product upgrade and install scripts to shut down the framework and to ensure that there are no running processes.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Metadata for new module hig2550
-- 
------------------------------------------------------------------
INSERT INTO hig_modules ( hmo_module
                        , hmo_title
                        , hmo_filename
                        , hmo_module_type
                        , hmo_fastpath_invalid
                        , hmo_use_gri
                        , hmo_application
                        , hmo_menu)
SELECT 'HIG2550' hmo_module
          , 'Process Framework Administration' hmo_title
          , 'hig2550' hmo_filename
          , 'FMX' hmo_module_type
          , 'N' hmo_fastpath_invalid
          , 'N' hmo_use_gri
          , 'HIG'hmo_application
          , 'FORM' hmo_menu
  FROM  dual
WHERE NOT EXISTS (SELECT 'X' 
                  FROM hig_modules
                  WHERE hmo_module = 'HIG2550')
/
--
INSERT INTO hig_module_roles( HMR_MODULE
                            , HMR_ROLE
                            , HMR_MODE)
SELECT 'HIG2550'
     , 'PROCESS_ADMIN'
     , 'NORMAL' 
FROM dual 
WHERE NOT EXISTS  (SELECT 'X' 
                                FROM hig_module_roles 
                                WHERE hmr_module = 'HIG2550' 
                                AND hmr_role = 'PROCESS_ADMIN')
/
--
INSERT INTO hig_standard_favourites(hstf_parent
                                   ,hstf_child
                                   ,hstf_descr
                                   ,hstf_type
                                   ,hstf_order)
  SELECT 'HIG_PROCESSES'
        ,'HIG2550'
        ,'Process Framework Administration'
        ,'M'
        ,5
    FROM dual
   WHERE NOT EXISTS
 (SELECT 'X'
 FROM hig_standard_favourites
 WHERE hstf_child = 'HIG2550')
/
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

