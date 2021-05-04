----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4900_fix1.sql-arc   1.1   May 04 2021 11:21:36   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4900_fix1.sql  $ 
--       Date into PVCS   : $Date:   May 04 2021 11:21:36  $
--       Date fetched Out : $Modtime:   May 04 2021 11:15:06  $
--       Version     	  : $Revision:   1.1  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
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
DEFINE logfile1='nm_4900_fix1_&log_extension'
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
 -- Check that NET has been installed @ v4.9.0.0
 --
 hig2.product_exists_at_version (p_product        => 'NET'
                                ,p_VERSION        => '4.9.0.0'
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

BEGIN
  INSERT INTO hig_products (hpr_product,
                            hpr_product_name,
                            hpr_version,
                            hpr_key,
                            hpr_sequence)
       VALUES ('LB',
               'Location Bridge',
               '4.9.0.0',
               '76',
               99);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX
    THEN
        UPDATE hig_products
           SET hpr_version = '4.9.0.0'
         WHERE hpr_product = 'LB';
END;
/

INSERT INTO NM_ERRORS (NER_APPL,
                       NER_ID,
                       NER_DESCR,
                       NER_CAUSE)
SELECT 'NET',
        561,
        'The chosen node is inconsistent with direction of first element in merge',
        'The resultant merged element inherits attributes, including direction, from the first element of the two. '||
            'The supplied node and the inherited direction are in conflict. '||
            'The user should either not use the node and have the system work out which node to dissolve or choose the other node or reverse the order of element selection'
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                     AND NER_ID = 561);

SET TERM ON 
PROMPT Creating Metadata
SET TERM OFF
--
SET FEEDBACK ON
start tdl_metadata_upg.sql
SET FEEDBACK OFF

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

SET TERM ON 
PROMPT Add HUS_ACK_TC to HIG_USERS
SET TERM OFF
--

DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE hig_users ADD hus_ack_tc DATE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

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
-- Views
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating view v_sdl_datum_stats_working
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_datum_stats_working.vw
SET FEEDBACK OFF	

SET TERM ON 
PROMPT Creating View v_node_proximity_check
SET TERM OFF
--
SET FEEDBACK ON
start v_node_proximity_check.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_nm_hig_users
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_hig_users.vw
SET FEEDBACK OFF

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

SET TERM ON 
PROMPT Creating Trigger nm_asset_locations_all_who
SET TERM OFF
--
SET FEEDBACK ON
start nm_asset_locations_all_who.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger nm_asset_locations_b_ins
SET TERM OFF
--
SET FEEDBACK ON
start nm_asset_locations_b_ins.trg
SET FEEDBACK OFF

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

SET TERM ON 
PROMPT Creating Package Header hig_alert
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert.pkh
SET FEEDBACK OFF
--
--------------------------------------------------------------------------------
-- Package Bodies
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Package Body nm3invval
SET TERM OFF
--
SET FEEDBACK ON
start nm3invval.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3split
SET TERM OFF
--
SET FEEDBACK ON
start nm3split.pkw
SET FEEDBACK OFF

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

SET TERM ON 
PROMPT Creating Package Body sdl_stats
SET TERM OFF
--
SET FEEDBACK ON
start sdl_stats.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body lb_get
SET TERM OFF
--
SET FEEDBACK ON
start lb_get.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3merge
SET TERM OFF
--
SET FEEDBACK ON
start nm3merge.pkw
SET FEEDBACK OFF

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
PROMPT Creating Package Body sdl_topo
SET TERM OFF
--
SET FEEDBACK ON
start sdl_topo.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body sdl_inclusion
SET TERM OFF
--
SET FEEDBACK ON
start sdl_inclusion.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body nm3inv_view
SET TERM OFF
--
SET FEEDBACK ON
start nm3inv_view.pkw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package Body hig_alert
SET TERM OFF
--
SET FEEDBACK ON
start hig_alert.pkw
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

SET TERM ON 
PROMPT Creating Function clob_agg
SET TERM OFF
--
SET FEEDBACK ON
start clob_agg.fnw
SET FEEDBACK OFF
COMMIT;
--
-- Requires HIG2 recompile, otherwise upgrade not logged
ALTER PACKAGE hig2 COMPILE PACKAGE; 
ALTER PACKAGE hig COMPILE PACKAGE; 

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
				,p_upgrade_script => 'log_nm_4900_fix1.sql'
				,p_remarks        => 'NET 4900 FIX 1 (Build 1)'
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
