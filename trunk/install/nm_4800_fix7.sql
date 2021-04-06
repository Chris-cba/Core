----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix7.sql-arc   1.5   Apr 06 2021 15:17:26   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4800_fix7.sql  $ 
--       Date into PVCS   : $Date:   Apr 06 2021 15:17:26  $
--       Date fetched Out : $Modtime:   Mar 15 2021 11:53:02  $
--       Version     	  : $Revision:   1.5  $
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
DEFINE logfile1='nm_4800_fix7_&log_extension'
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

--
-- Check that TDL has not already been installed and existing SDL tables do not hold any data 
--
DECLARE
  ln_tdl_exists NUMBER(1);
  ln_sdl_cnt    NUMBER;
BEGIN
  BEGIN
    SELECT 1 
      INTO ln_tdl_exists
      FROM user_tables 
     WHERE table_name = 'SDL_PROFILE_FILE_COLUMNS';
    -- continue
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      SELECT COUNT(*) 
        INTO ln_sdl_cnt
        FROM sdl_profiles ;
      --
      IF ln_sdl_cnt >=1 THEN -- SDL system has been already configured
        RAISE_APPLICATION_ERROR(-20000,'SDL has already been configured and used on the database. Execute SDL clean up script before installing TDL.'); 
      END IF;   
  END;
END;
/

WHENEVER SQLERROR CONTINUE
--------------------------------------------------------------------------------
-- Types
--------------------------------------------------------------------------------
--

--
-- Drop Types prior to creation
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE t_clob_agg FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/

DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE BODY t_clob_agg';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
--
-- Create Types
--
SET TERM ON 
PROMPT Creating Type t_clob_agg
SET TERM OFF
--
SET FEEDBACK ON
start t_clob_agg.tyh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Type Body t_clob_agg
SET TERM OFF
--
SET FEEDBACK ON
start t_clob_agg.tyw
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- DDL
--------------------------------------------------------------------------------
DECLARE
  --
  name_exists  EXCEPTION;
  PRAGMA exception_init( name_exists, -955);
  --
BEGIN
  --
  DBMS_ERRLOG.create_error_log (dml_table_name => 'NM_ELEMENTS_ALL');
  --
EXCEPTION 
  WHEN name_exists THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/

SET TERM ON 
PROMPT DDL Changes
SET TERM OFF
--

SET FEEDBACK ON
start tdl_ddl_upg.sql
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Metadata
SET TERM OFF
--
SET FEEDBACK ON
start tdl_metadata_upg.sql
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT Creating View v_sdl_profile_nw_types
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_profile_nw_types.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_destination_sequence_columns
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_destination_sequence_columns.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_tdl_destination_relations
SET TERM OFF
--
SET FEEDBACK ON
start v_tdl_destination_relations.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_tdl_destination_list
SET TERM OFF
--
SET FEEDBACK ON
start v_tdl_destination_list.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_tdl_profile_containers
SET TERM OFF
--
SET FEEDBACK ON
start v_tdl_profile_containers.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_tdl_destination_order
SET TERM OFF
--
SET FEEDBACK ON
start v_tdl_destination_order.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_attrib_validation_result
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_attrib_validation_result.vw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Headers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Header nm3flx
SET TERM OFF
--
SET FEEDBACK ON
start nm3flx.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Header sdl_inv_ddl
SET TERM OFF
--
SET FEEDBACK ON
start sdl_inv_ddl.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Header sdl_inv_load
SET TERM OFF
--
SET FEEDBACK ON
start sdl_inv_load.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Header sdl_invval
SET TERM OFF
--
SET FEEDBACK ON
start sdl_invval.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Header sdl_ddl
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ddl.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Header sdl_inclusion
SET TERM OFF
--
SET FEEDBACK ON
start sdl_inclusion.pkh
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Functions
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Function clob_agg
SET TERM OFF
--
SET FEEDBACK ON
start clob_agg.fnw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body nm3flx
SET TERM OFF
--
SET FEEDBACK ON
start nm3flx.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_audit
SET TERM OFF
--
SET FEEDBACK ON
start sdl_audit.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_ddl
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ddl.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_inv_ddl
SET TERM OFF
--
SET FEEDBACK ON
start sdl_inv_ddl.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_inv_load
SET TERM OFF
--
SET FEEDBACK ON
start sdl_inv_load.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_invval
SET TERM OFF
--
SET FEEDBACK ON
start sdl_invval.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_stats
SET TERM OFF
--
SET FEEDBACK ON
start sdl_stats.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_topo
SET TERM OFF
--
SET FEEDBACK ON
start sdl_topo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_validate
SET TERM OFF
--
SET FEEDBACK ON
start sdl_validate.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_inclusion
SET TERM OFF
--
SET FEEDBACK ON
start sdl_inclusion.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_transfer
SET TERM OFF
--
SET FEEDBACK ON
start sdl_transfer.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_process
SET TERM OFF
--
SET FEEDBACK ON
start sdl_process.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3inv_view
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_view.pkw
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Trigger sdl_destination_header_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_destination_header_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_profile_file_columns_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_profile_file_columns_seq_trg.trg
SET FEEDBACK OFF
	
--
--------------------------------------------------------------------------------
-- Refresh Who Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Refresh Who Triggers
SET TERM OFF
--
SET FEEDBACK ON
start who_trg.sql
SET FEEDBACK OFF

--
-- Create synonyms
--
BEGIN
  nm3ddl.Create_synonym_for_object('ERR$_NM_ELEMENTS_ALL');
  nm3ddl.Create_synonym_for_object('SDL_INCLUSION');
END;
/

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4800_fix7.sql'
				,p_remarks        => 'NET 4800 FIX 7 (Build 2)'
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
