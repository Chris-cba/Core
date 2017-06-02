----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix52.sql-arc   1.0   Jun 02 2017 11:22:26   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix52.sql  $ 
--       Date into PVCS   : $Date:   Jun 02 2017 11:22:26  $
--       Date fetched Out : $Modtime:   Jun 01 2017 10:24:30  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
--
-- Grab date/time to append to log file name
--
UNDEFINE log_extension
COL      log_extension NEW_VALUE log_extension NOPRINT
SET TERM OFF
SELECT  TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS') || '.LOG' log_extension FROM DUAL
/
SET TERM ON
--
--------------------------------------------------------------------------------
--
-- Spool to Logfile
--
DEFINE logfile1='nm_4700_fix52_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
SELECT 'Fix Date ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') FROM DUAL;

SELECT 'Install Running on ' || LOWER(USER || '@' || instance_name || '.' || host_name) || ' - DB ver : ' || version
FROM v$instance;
--
SELECT 'Current version of ' || hpr_product || ' ' || hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG', 'NET');
--
WHENEVER SQLERROR EXIT
--
BEGIN
 --
 -- Check that the user isn't SYS or SYSTEM
 --
 IF USER IN ('SYS', 'SYSTEM')
 THEN
	RAISE_APPLICATION_ERROR(-20000, 'You cannot install this product as ' || USER);
 END IF;
 --
 -- Check that NET has been installed @ v4.7.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.7.0.0'
                                );

END;
/
WHENEVER SQLERROR CONTINUE
--
--------------------------------------------------------------------------------
-- Table Definitions
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating HIG_USER_ACCESS_SECURITY table
SET TERM OFF
--
DECLARE
 table_exists exception;
 pragma exception_init (table_exists,-955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE hig_user_access_security '         ||CHR(10)||
                    '( huas_hus_user_id     NUMBER(9) NOT NULL,'     ||CHR(10)||
                    '  huas_ques_code       NUMBER(2) NOT NULL,'     ||CHR(10)||
                    '  huas_answer          VARCHAR2(1000) NOT NULL,'||CHR(10)||
                    '  huas_birthdate       DATE NOT NULL,'          ||CHR(10)||
                    '  huas_date_created    DATE NOT NULL,'          ||CHR(10)||
                    '  huas_created_by      VARCHAR2(30) NOT NULL,'  ||CHR(10)||
                    '  huas_date_modified   DATE NOT NULL,'          ||CHR(10)||
                    '  huas_modified_by     VARCHAR2(30) NOT NULL'   ||CHR(10)||
                    ')';
EXCEPTION
  WHEN table_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/
--
-- Add PK constraint
--

DECLARE
 constraint_exists exception;
 pragma exception_init (constraint_exists,-2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE hig_user_access_security'||CHR(10)||
                    'ADD CONSTRAINT huas_pk PRIMARY KEY (huas_hus_user_id)';
EXCEPTION
  WHEN constraint_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/
--
--
--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
PROMPT Creating view view_huas
--
SET FEEDBACK ON
start view_huas.vw
SET FEEDBACK OFF
--
PROMPT Creating view view_profiles
--
SET FEEDBACK ON
start view_profiles.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Header hig_user_login_util.pkh
SET TERM OFF
--
SET FEEDBACK ON
START hig_user_login_util.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header nm3user_admin.pkh
SET TERM OFF
--
SET FEEDBACK ON
START nm3user_admin.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header nm3_doc_man.pkh
SET TERM OFF
--
SET FEEDBACK ON
START nm3_doc_man.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body hig_user_login_util.pkw
SET TERM OFF
--
SET FEEDBACK ON
START hig_user_login_util.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3user_admin.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3user_admin.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header nm3_doc_man.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3_doc_man.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- HIG_DOMAINS
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_domains
SET TERM OFF

INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN
       ,HDO_PRODUCT
       ,HDO_TITLE
       ,HDO_CODE_LENGTH
       )
SELECT 
        'SECURITY_QUESTIONS'
       ,'HIG'
       ,'Security Questions'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'SECURITY_QUESTIONS');
--
--------------------------------------------------------------------------------
-- HIG_CODES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_codes
SET TERM OFF

INSERT INTO HIG_CODES 
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ) 
SELECT  
       'SECURITY_QUESTIONS'
      ,'1'
      ,'What was the model of your first car?'
      ,'N'
      ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                    WHERE HCO_DOMAIN = 'SECURITY_QUESTIONS'
                      AND HCO_CODE = '1');
--           
INSERT INTO HIG_CODES 
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ) 
SELECT  
       'SECURITY_QUESTIONS'
      ,'2'
      ,'Where would you most like to live when you retire?'
      ,'N'
      ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                    WHERE HCO_DOMAIN = 'SECURITY_QUESTIONS'
                      AND HCO_CODE = '2');
--           
INSERT INTO HIG_CODES 
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ) 
SELECT  
       'SECURITY_QUESTIONS'
      ,'3'
      ,'Where did you go on your most memorable vacation?'
      ,'N'
      ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                    WHERE HCO_DOMAIN = 'SECURITY_QUESTIONS'
                      AND HCO_CODE = '3');
--           
INSERT INTO HIG_CODES 
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ) 
SELECT  
       'SECURITY_QUESTIONS'
      ,'4'
      ,'What was the name of your favorite school teacher?'
      ,'N'
      ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                    WHERE HCO_DOMAIN = 'SECURITY_QUESTIONS'
                      AND HCO_CODE = '4');
--           
INSERT INTO HIG_CODES 
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ) 
SELECT  
       'SECURITY_QUESTIONS'
      ,'5'
      ,'What is the last name of your first boss?'
      ,'N'
      ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                    WHERE HCO_DOMAIN = 'SECURITY_QUESTIONS'
                      AND HCO_CODE = '5');
--           
INSERT INTO HIG_CODES 
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ) 
SELECT  
       'SECURITY_QUESTIONS'
      ,'6'
      ,'Who is your favorite actor?'
      ,'N'
      ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                    WHERE HCO_DOMAIN = 'SECURITY_QUESTIONS'
                      AND HCO_CODE = '6');
--           
INSERT INTO HIG_CODES 
      (HCO_DOMAIN
      ,HCO_CODE
      ,HCO_MEANING
      ,HCO_SYSTEM
      ,HCO_SEQ
      ) 
SELECT  
       'SECURITY_QUESTIONS'
      ,'7'
      ,'What was the name of your favorite childhood friend?'
      ,'N'
      ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                    WHERE HCO_DOMAIN = 'SECURITY_QUESTIONS'
                      AND HCO_CODE = '7');
--
--------------------------------------------------------------------------------
-- HIG_ROLES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_roles
SET TERM OFF

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE PROFILE_ADMIN';
  NULL;
EXCEPTION
WHEN role_exists
THEN 
  Null;
END;
/

INSERT INTO HIG_ROLES
      (HRO_ROLE
      ,HRO_PRODUCT
      ,HRO_DESCR
      ) 
SELECT  
       'PROFILE_ADMIN'
      ,'HIG'
      ,'Profile Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                    WHERE HRO_ROLE = 'PROFILE_ADMIN');
                      
--
--------------------------------------------------------------------------------
-- HIG_MODULES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_modules
SET TERM OFF

INSERT INTO HIG_MODULES 
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ) 
SELECT 
       'HIGLOGN'
      ,'Exor Login'
      ,'higlogn.fmx'
      ,'FMX'
      ,'Y'
      ,'N'
      ,'HIG' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                    WHERE HMO_MODULE = 'HIGLOGN');
--
INSERT INTO HIG_MODULES 
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT 
       'HIGPROF'
      ,'Maintain Profiles'
      ,'higprof.fmx'
      ,'FMX'
      ,'N'
      ,'N'
      ,'HIG'
      ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                    WHERE HMO_MODULE = 'HIGPROF');
--
--------------------------------------------------------------------------------
-- HIG_MODULE_ROLES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_module_roles
SET TERM OFF

INSERT INTO HIG_MODULE_ROLES 
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE) 
SELECT 
        'HIGPROF'
       ,'PROFILE_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                    WHERE HMR_MODULE = 'HIGPROF'
                      AND HMR_ROLE = 'PROFILE_ADMIN');

--
--------------------------------------------------------------------------------
-- HIG_STANDARD_FAVOURITES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_standard_favourites
SET TERM OFF

INSERT INTO HIG_STANDARD_FAVOURITES 
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER) 
SELECT 
        'HIG_SECURITY'
       ,'HIGPROF'
       ,'Maintain Profiles'
       ,'M'
       ,'0.5' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                    WHERE HSTF_PARENT = 'HIG_SECURITY'
                      AND HSTF_CHILD = 'HIGPROF');
--
COMMIT;

--
--------------------------------------------------------------------------------
-- Synonyms
--------------------------------------------------------------------------------
--
SET FEEDBACK ON
--
BEGIN
  nm3ddl.refresh_all_synonyms;
END;
/
--
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Grants
--------------------------------------------------------------------------------
--
GRANT execute ON hig_user_login_util to HIG_USER;
--
--------------------------------------------------------------------------------
-- Who Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Calling Who_Trg.sql
SET TERM OFF

SET FEEDBACK ON
start who_trg.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix52.sql'
				,p_remarks        => 'NET 4700 FIX 52 (Build 1)'
				,p_to_version     => NULL
				);
	--
	COMMIT;
	--
EXCEPTION 
	WHEN OTHERS THEN
	--
		NULL;
	--
END;
/
COMMIT;
--

SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
