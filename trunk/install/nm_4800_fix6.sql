-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix6.sql-arc   1.0   Oct 06 2020 15:19:26   Chris.Baugh  $
--       Date into PVCS   : $Date:   Oct 06 2020 15:19:26  $
--       Module Name      : $Workfile:   nm_4800_fix6.sql  $
--       Date fetched Out : $Modtime:   Oct 06 2020 15:13:10  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2019 Bentley Systems Incorporated.  All rights reserved.
-----------------------------------------------------------------------------------
--
set echo off
set linesize 120
set heading off
set feedback off
--
-- Grab date/time to append to log file name
--
undefine log_extension
col      log_extension new_value log_extension noprint
set term off
select  TO_CHAR(sysdate,'DDMONYYYY_HH24MISS')||'.LOG' log_extension from dual
/
set term on
--
--------------------------------------------------------------------------------
--
--
-- Spool to Logfile
--
define logfile1='exmc04070003en_updt6_&log_extension'
spool &logfile1
--
--------------------------------------------------------------------------------
--
select 'Fix Date ' || to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

SELECT 'Install Running on ' ||LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||version
FROM v$instance;
--
SELECT 'Current version of '||hpr_product||' ' ||hpr_version
FROM hig_products
WHERE hpr_product IN ('HIG','NET','MCP');

WHENEVER SQLERROR EXIT

DECLARE
  not_licensed   EXCEPTION;
  PRAGMA EXCEPTION_INIT (not_licensed, -20000);
BEGIN
 --
 -- Check that the user isn't sys or system
 --
 IF USER IN ('SYS','SYSTEM')
 THEN
   RAISE_APPLICATION_ERROR(-20000,'You cannot install this product as ' || USER);
 END IF;
 --
 -- Check that MCP has been installed @ v4.8.0.0
 --
 hig2.product_exists_at_version  (
                                 p_product        => 'MCP',
                                 p_version        => '4.8.0.1'
                                 );
EXCEPTION
  WHEN not_licensed THEN
     Hig2.Upgrade  (
                   p_Product        => 'NET', 
                   p_Upgrade_Script => 'nm_4800_fix6.sql', 
                   p_Remarks        => 'NET 4800 FIX 6 (Build 1)', 
                   p_To_Version     => Null 
                   );
     --
     Commit;
	 --
     RAISE_APPLICATION_ERROR(-20000,CHR(10)||'MCP is not a licensed product at 4.8.0.0, this fix can be ignored'||CHR(10));
	 --
  WHEN OTHERS THEN
     RAISE;
END;
/
--
--------------------------------------------------------------------------------
-- DDL
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Remove SHPJAVABIN Product Option
SET TERM OFF
--
SET FEEDBACK ON
--
DELETE FROM hig_option_values WHERE hov_id = 'SHPJAVABIN'; 
DELETE FROM hig_option_list WHERE hol_id = 'SHPJAVABIN'; 
--
COMMIT; 
SET FEEDBACK OFF

SET TERM ON 
PROMPT Create table NM_MCP_KEY
SET TERM OFF

SET FEEDBACK ON
DECLARE
	v_sql VARCHAR2(32767);
BEGIN
	v_sql := 'Create Table Nm_Mcp_Key
		     (
				Key_Id      Number,
				Key_String  Varchar2(2078) Not Null,
				Constraint  Nm_Mcp_Key_Pk Primary Key (Key_Id),
				Constraint  Nm_Mcp_Key_FK Foreign Key (Key_Id) References Nm_User_Passwords(Nup_Userid) On Delete Cascade
		     )
		     Organization Index'; 
	--
	EXECUTE IMMEDIATE v_sql;
EXCEPTION
    WHEN OTHERS THEN
		IF SQLCODE = -955 THEN
			NULL; -- suppresses ORA-00955 exception
		ELSE
			RAISE;
		END IF;
END; 
/
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Functions
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling mcp_pre_match_duplicates.fnw
SET TERM OFF
--
SET FEEDBACK ON
start mcp_pre_match_duplicates.fnw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Procedures
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Procedures
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling clone_inv_type_subset.prw
SET TERM OFF
--
SET FEEDBACK ON
start clone_inv_type_subset.prw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling drop_subset_asset_type.prw
SET TERM OFF
--
SET FEEDBACK ON
start drop_subset_asset_type.prw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Package Headers
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling mcp_security.pkh
SET TERM OFF
--
SET FEEDBACK ON
start mcp_security.pkh
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp0200.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp0200.pkh
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_sde.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_sde.pkh
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_process_insert.pkh
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_process_insert.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Package Bodies
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling mcp_security.pkw
SET TERM OFF
--
SET FEEDBACK ON
start mcp_security.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_sde.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_sde.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp0200.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp0200.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_ftp.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_ftp.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_process_api.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_process_api.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_process_insert.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_process_insert.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling mcp_pre_process.pkw
SET TERM OFF
--
SET FEEDBACK ON
start mcp_pre_process.pkw
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm3mcp_sdo_load.pkw
SET TERM OFF
--
SET FEEDBACK ON
start nm3mcp_sdo_load.pkw
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Triggers
SET TERM OFF
--
SET TERM ON 
PROMPT Compiling nm_user_pwd_biud_stmnt.trg
SET TERM OFF
--
SET FEEDBACK ON
start nm_user_pwd_biud_stmnt.trg
SET FEEDBACK OFF
--
SET TERM ON 
PROMPT Compiling nm_mcp_key_biud_stmnt.trg
SET TERM OFF
--
SET FEEDBACK ON
start nm_mcp_key_biud_stmnt.trg
SET FEEDBACK OFF
--
--
--------------------------------------------------------------------------------
-- POLICIES
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Policies
SET TERM OFF
--
SET FEEDBACK ON
start add_policy.sql
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- SYNONYMS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Synonyms
SET TERM OFF

Begin
  Nm3ddl.Refresh_All_Synonyms;
End;
/
--
--------------------------------------------------------------------------------
-- RE-ENCRYPT PASSWORDS WITH NEW KEYS
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Key Encryption
SET TERM OFF


Declare
  g_Key Varchar2(2078) := 'I9ir93FJd92jd';
Begin
  For x In  (
            Select  *
            From    Nm_User_Passwords
            )
  Loop
	BEGIN
		Insert Into Nm_Mcp_Key
		(
		Key_Id,
		Key_String
		)
		Values
		(
		x.Nup_Userid,
		g_key
		); 
	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN 
			NULL; 
	END; 
  End Loop; 
End; 
/ 

SET TERM ON 
PROMPT Rotate Keys
SET TERM OFF

Begin
  Mcp_Security.Rotate_Keys;
End;
/

--
--  
--
--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
Begin
  --
  Hig2.Upgrade  (
                p_Product        => 'NET', 
                p_Upgrade_Script => 'nm_4800_fix6', 
                p_Remarks        => 'NET 4800 FIX 6 (Build 1)', 
                p_To_Version     => Null 
                );
  --
  Commit;
  --
Exception
  When Others Then Null;
End;
/


SPOOL OFF
--
EXIT
--
--
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************
