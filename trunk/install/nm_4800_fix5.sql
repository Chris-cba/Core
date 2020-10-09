----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix5.sql-arc   1.0   Oct 09 2020 15:02:06   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4800_fix5.sql  $ 
--       Date into PVCS   : $Date:   Oct 09 2020 15:02:06  $
--       Date fetched Out : $Modtime:   Oct 09 2020 14:52:44  $
--       Version     	  : $Revision:   1.0  $
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
DEFINE logfile1='nm_4800_fix5_&log_extension'
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
--
--------------------------------------------------------------------------------
-- DDL
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Applying DDL changes
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ddl.sql
SET FEEDBACK OFF	
--
--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Trigger sdl_profiles_ai
SET TERM OFF
--
SET FEEDBACK ON
start sdl_profiles_ai.trg
SET FEEDBACK OFF	
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package nm_sdo                                                          
SET TERM OFF
--
SET FEEDBACK ON
start nm_sdo.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_edit                                                          
SET TERM OFF
--
SET FEEDBACK ON
start sdl_edit.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_validate                                                          
SET TERM OFF
--
SET FEEDBACK ON
start sdl_validate.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_process                                                          
SET TERM OFF
--
SET FEEDBACK ON
start sdl_process.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body nm_sdo
SET TERM OFF
--
SET FEEDBACK ON
start nm_sdo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_ddl
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ddl.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_edit
SET TERM OFF
--
SET FEEDBACK ON
start sdl_edit.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_process
SET TERM OFF
--
SET FEEDBACK ON
start sdl_process.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_transfer
SET TERM OFF
--
SET FEEDBACK ON
start sdl_transfer.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_validate
SET TERM OFF
--
SET FEEDBACK ON
start sdl_validate.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Procedures
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Procedure create_nlt_geometry_view                           
SET TERM OFF
--
SET FEEDBACK ON
start create_nlt_geometry_view.prw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Function get_rdbms_error_message
SET TERM OFF
--
SET FEEDBACK ON
start get_rdbms_error_message.fnw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Applying Metadata Changes
SET TERM OFF
--
SET FEEDBACK ON
start sdl_dml.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Themes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Themes
SET TERM OFF
--
SET FEEDBACK ON
start sdl_themes.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Roles
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Role
SET TERM OFF
--
SET FEEDBACK ON
start sdl_role.sql
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4800_fix5.sql'
				,p_remarks        => 'NET 4800 FIX 5 (Build 1)'
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
