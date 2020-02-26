----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix2.sql-arc   1.2   Feb 26 2020 11:50:34   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4800_fix2.sql  $ 
--       Date into PVCS   : $Date:   Feb 26 2020 11:50:34  $
--       Date fetched Out : $Modtime:   Feb 26 2020 11:49:16  $
--       Version     	  : $Revision:   1.2  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
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
DEFINE logfile1='nm_4800_fix2_&log_extension'
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
 -- Check that NET has been installed @ v4.8.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.8.0.0'
                                );

END;
/

WHENEVER SQLERROR CONTINUE


--------------------------------------------------------------------------------
-- Drop Exor Proxy User details
--------------------------------------------------------------------------------

prompt Drop Exor Proxy User details

DECLARE
  --
  CURSOR c1 IS
  SELECT hus_username
    FROM hig_users b,
         hig_user_roles
   WHERE hur_username = b.hus_username 
   AND hur_role = 'PROXY_OWNER';
  --
BEGIN
  --
  FOR l_rec IN c1 LOOP
    --
    EXECUTE IMMEDIATE 'DELETE FROM hig_users WHERE hus_username = '''||l_rec.hus_username||''' AND hus_is_hig_owner_flag != ''Y''';
    EXECUTE IMMEDIATE 'DELETE FROM hig_user_roles WHERE hur_username = '''||l_rec.hus_username||''' AND hur_role = ''PROXY_OWNER''';
    --
  END LOOP;
    
  EXECUTE IMMEDIATE 'DELETE FROM hig_roles WHERE hro_role = ''PROXY_OWNER''';
  -- 
END;
/

--------------------------------------------------------------------------------
-- Grant privileges to PROXY_OWNER Role
--------------------------------------------------------------------------------

prompt Grant privileges to PROXY_OWNER Role

DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  EXECUTE IMMEDIATE 'GRANT CREATE SESSION to PROXY_OWNER';
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON hig_sso_api to PROXY_OWNER';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body hig_relationship_api
SET TERM OFF
--
SET FEEDBACK ON
start hig_relationship_api.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4800_fix2.sql'
				,p_remarks        => 'NET 4800 FIX 2 (Build 1)'
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
