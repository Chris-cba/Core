----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4700_fix59.sql-arc   1.0   Apr 06 2018 15:07:10   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4700_fix59.sql  $ 
--       Date into PVCS   : $Date:   Apr 06 2018 15:07:10  $
--       Date fetched Out : $Modtime:   Mar 27 2018 10:09:34  $
--       Version     	  : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
DEFINE logfile1='nm_4700_fix59_&log_extension'
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


--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating Package Body hig_alert.pkw
SET TERM OFF
--
SET FEEDBACK ON
START hig_alert.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3homo.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3homo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT creating Package Body nm3rsc.pkw
SET TERM OFF
--
SET FEEDBACK ON
START nm3rsc.pkw
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT creating View hig_processes_all_v.vw
SET TERM OFF
--
SET FEEDBACK ON
START hig_processes_all_v.vw
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Indexes
--------------------------------------------------------------------------------
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX nex_ind1 ON nm_elements_xrefs(nex_id1)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX nex_ind2 ON nm_elements_xrefs(nex_id2)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
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
  EXECUTE IMMEDIATE 'CREATE ROLE ALERT_ADMIN';
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
       'ALERT_ADMIN'
      ,'HIG'
      ,'Alert Administration' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                    WHERE HRO_ROLE = 'ALERT_ADMIN');
                      
--
--------------------------------------------------------------------------------
-- Grants
--------------------------------------------------------------------------------
--
GRANT CREATE TRIGGER TO ALERT_ADMIN;

GRANT DROP ANY TRIGGER TO ALERT_ADMIN;
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4700_fix59.sql'
				,p_remarks        => 'NET 4700 FIX 59 (Build 1)'
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
