----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix53.sql-arc   1.0   Mar 31 2017 16:27:40   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix53.sql  $ 
--       Date into PVCS   : $Date:   Mar 31 2017 16:27:40  $
--       Date fetched Out : $Modtime:   Mar 20 2017 09:36:10  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
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
DEFINE logfile1='nm_4700_fix53_&log_extension'
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
PROMPT Creating HIG_RELATIONSHIP table
SET TERM OFF
--
DECLARE
 table_exists exception;
 pragma exception_init (table_exists,-955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE HIG_RELATIONSHIP                        '||CHR(10)||
                    '( HIR_ATTRIBUTE1  VARCHAR2(50)               NOT NULL'||CHR(10)|| -- Email Address 
                    ' ,HIR_ATTRIBUTE2  RAW(2000)                  NOT NULL'||CHR(10)|| -- Encrypted Username
                    ' ,HIR_ATTRIBUTE3  VARCHAR2(1)  DEFAULT ''Y'' NOT NULL'||CHR(10)|| -- Automatic Management enabled (Y/N)
                    ' ,HIR_ATTRIBUTE4  RAW(2000)                          '||CHR(10)|| -- Salt
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
  EXECUTE IMMEDIATE 'ALTER TABLE HIG_RELATIONSHIP'||CHR(10)||
                    'ADD CONSTRAINT HIR_PK PRIMARY KEY (HIR_ATTRIBUTE1)';
EXCEPTION
  WHEN constraint_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/

--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Header hig_relationship_api.pkh
SET TERM OFF
--
SET FEEDBACK ON
START hig_relationship_api.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Header hig_sso_api.pkh
SET TERM OFF
--
SET FEEDBACK ON
START hig_sso_api.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body hig_relationship_api.pkw
SET TERM OFF
--
SET FEEDBACK ON
START hig_relationship_api.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body hig_sso_api.pkw
SET TERM OFF
--
SET FEEDBACK ON
START hig_sso_api.pkw
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- HIG_PROCESS_TYPES
--------------------------------------------------------------------------------
--
--
SET TERM ON
PROMPT hig_process_types
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPES
       (HPT_PROCESS_TYPE_ID
       ,HPT_NAME
       ,HPT_DESCR
       ,HPT_WHAT_TO_CALL
       ,HPT_INITIATION_MODULE
       ,HPT_INTERNAL_MODULE
       ,HPT_INTERNAL_MODULE_PARAM
       ,HPT_PROCESS_LIMIT
       ,HPT_RESTARTABLE
       ,HPT_SEE_IN_HIG2510
       ,HPT_POLLING_ENABLED
       ,HPT_POLLING_FTP_TYPE_ID
       ,HPT_AREA_TYPE
       )
SELECT 
        -6
       ,'Refresh Auto-generated Passwords'
       ,'Refreshes User passwords for users where the password is automatically generated'
       ,'hig_relationship_api.refresh_auto_passwords;'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,null
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPES
                   WHERE HPT_PROCESS_TYPE_ID = -6);

--
--------------------------------------------------------------------------------
-- HIG_PROCESS_TYPE_ROLES
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_process_type_roles
SET TERM OFF

INSERT INTO HIG_PROCESS_TYPE_ROLES
       (HPTR_PROCESS_TYPE_ID
       ,HPTR_ROLE
       )
SELECT 
        -6
       ,'HIG_ADMIN' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_PROCESS_TYPE_ROLES
                   WHERE HPTR_PROCESS_TYPE_ID = -6
                    AND  HPTR_ROLE = 'HIG_ADMIN');
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
-- CREATE PROXY_OWNER role
--------------------------------------------------------------------------------
--
SET TERM ON
PROMPT hig_roles
SET TERM OFF

DECLARE
  role_exists Exception;
  Pragma Exception_Init(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'CREATE ROLE PROXY_OWNER';
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
       'PROXY_OWNER'
      ,'HIG'
      ,'Role which allows proxy connections for users, with this user as the Proxy Owner' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                    WHERE HRO_ROLE = 'PROXY_OWNER');
                      
--
--------------------------------------------------------------------------------
-- Grants
--------------------------------------------------------------------------------
--
GRANT execute ON hig_relationship_api to HIG_USER;
GRANT execute ON hig_sso_api to HIG_USER;

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
SET TERM ON 
PROMPT log_nm_4700_fix53.sql
SET TERM OFF
--
SET FEEDBACK ON
START log_nm_4700_fix53.sql
SET FEEDBACK OFF
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix53.sql'
				,p_remarks        => 'NET 4700 FIX 53 (Build 1)'
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

SPOOL OFF
--
EXIT
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
---------------------------------------------------------------------------------------------------
--
