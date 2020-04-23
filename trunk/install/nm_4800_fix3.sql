----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/nm_4800_fix3.sql-arc   1.2   Apr 23 2020 09:28:28   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_4800_fix3.sql  $ 
--       Date into PVCS   : $Date:   Apr 23 2020 09:28:28  $
--       Date fetched Out : $Modtime:   Apr 23 2020 09:27:50  $
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
DEFINE logfile1='nm_4800_fix3_&log_extension'
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
  EXECUTE IMMEDIATE 'DROP TYPE vc_array FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE pline_box FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE pline_box_tab FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE topo_nw_geom_id FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE topo_nw_geom_id_tab FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE sdl_ne_data FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE sdl_ne_tab FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE nm_vertex_tab FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE geom_id_tab FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE nm_vertex FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE geom_id FORCE';
  --
EXCEPTION 
  WHEN type_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
--
DECLARE
  --
  type_not_exist  EXCEPTION;
  PRAGMA exception_init( type_not_exist, -4043);
  --
BEGIN
  --
  EXECUTE IMMEDIATE 'DROP TYPE nm_geom_terminations FORCE';
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
PROMPT Creating Type vc_array
SET TERM OFF
--
SET FEEDBACK ON
start vc_array.tyh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Type pline_box
SET TERM OFF
--
SET FEEDBACK ON
start pline_box.tyh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Type pline_box_tab
SET TERM OFF
--
SET FEEDBACK ON
start pline_box_tab.tyh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Type topo_nw_geom_id
SET TERM OFF
--
SET FEEDBACK ON
start topo_nw_geom_id.tyh
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Type topo_nw_geom_id_tab
SET TERM OFF
--
SET FEEDBACK ON
start topo_nw_geom_id_tab.tyh
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Type sdl_ne_data
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ne_data.tyh
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Type sdl_ne_data
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ne_tab.tyh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Type nm_vertex header
SET TERM OFF
--
SET FEEDBACK ON
start nm_vertex.tyh
SET FEEDBACK OFF


SET TERM ON 
PROMPT Creating Type nm_vertex_tab header
SET TERM OFF
--
SET FEEDBACK ON
start nm_vertex_tab.tyh
SET FEEDBACK OFF


SET TERM ON 
PROMPT Creating Type geom_id header
SET TERM OFF
--
SET FEEDBACK ON
start geom_id.tyh
SET FEEDBACK OFF


SET TERM ON 
PROMPT Creating Type geom_id_tab header
SET TERM OFF
--
SET FEEDBACK ON
start geom_id_tab.tyh
SET FEEDBACK OFF


SET TERM ON 
PROMPT Creating Type nm_geom_terminations header
SET TERM OFF
--
SET FEEDBACK ON
start nm_geom_terminations.tyh
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- DDL
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT Applying DDL changes
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ddl_upg.sql
SET FEEDBACK OFF	

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
PROMPT Creating Package nm_sdo_geom
SET TERM OFF
--
SET FEEDBACK ON
start nm_sdo_geom.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_audit
SET TERM OFF
--
SET FEEDBACK ON
start sdl_audit.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_ddl
SET TERM OFF
--
SET FEEDBACK ON
start sdl_ddl.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_process
SET TERM OFF
--
SET FEEDBACK ON
start sdl_process.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_stats
SET TERM OFF
--
SET FEEDBACK ON
start sdl_stats.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_topo
SET TERM OFF
--
SET FEEDBACK ON
start sdl_topo.pkh
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating Package sdl_transfer
SET TERM OFF
--
SET FEEDBACK ON
start sdl_transfer.pkh
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Package sdl_validate
SET TERM OFF
--
SET FEEDBACK ON
start sdl_validate.pkh
SET FEEDBACK OFF

--------------------------------------------------------------------------------
-- Views
--------------------------------------------------------------------------------
SET TERM ON 
PROMPT Creating View v_nm_nw_columns
SET TERM OFF
--
SET FEEDBACK ON
start v_nm_nw_columns.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_batch_accuracy
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_batch_accuracy.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_datum_accuracy
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_datum_accuracy.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_datum_stats_working
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_datum_stats_working.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_disconnected_network
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_disconnected_network.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_load_data
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_load_data.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_new_intersections
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_new_intersections.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_node_usages
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_node_usages.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_pline_stats
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_pline_stats.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_profile_nw_types
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_profile_nw_types.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_wip_nodes
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_wip_nodes.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_actual_load_data
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_actual_load_data.vw
SET FEEDBACK OFF

SET TERM ON 
PROMPT Creating View v_sdl_attrib_validation_result
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_attrib_validation_result.vw
SET FEEDBACK OFF


SET TERM ON 
PROMPT Creating View v_sdl_transferred_datums
SET TERM OFF
--
SET FEEDBACK ON
start v_sdl_transferred_datums.vw
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
PROMPT Creating Package Body nm_sdo_geom
SET TERM OFF
--
SET FEEDBACK ON
start nm_sdo_geom.pkw
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
PROMPT Creating Package Body sdl_process
SET TERM OFF
--
SET FEEDBACK ON
start sdl_process.pkw
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
-- Install SDO_LRS package if required
--                        
COL run_file new_value run_file noprint

SET TERM ON
Prompt Applying SDO_LRS replacement, if Oracle Spatial not installed...
SET TERM OFF

select decode(count(*), 0 , 'sdo_lrs.pkh',
                            'dummy.sql') run_file
from dba_registry 
where comp_name='Spatial'
and status = 'VALID'
/

SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

select decode(count(*), 0 , 'sdo_lrs.pkw',
                            'dummy.sql') run_file
from dba_registry 
where comp_name='Spatial'
and status = 'VALID'
/

SET FEEDBACK ON
start '&&run_file'
SET FEEDBACK OFF

--
-- DROP SDO_LRS package if installed and Spatial is valid
--
DECLARE
  --
  CURSOR c1 IS
  select count(*)
   from dba_registry 
  where comp_name='Spatial'
    and status = 'VALID';
  --
  lv_return      PLS_INTEGER;
  obj_not_exist  EXCEPTION;
  PRAGMA exception_init( obj_not_exist, -4043);
  --
BEGIN
--
  OPEN c1;
  FETCH c1 INTO lv_return;
  CLOSE c1;
  
  IF lv_return = 1
  THEN
    --
	EXECUTE IMMEDIATE 'DROP package sdo_lrs';
  END IF;
  --
EXCEPTION 
  WHEN obj_not_exist THEN
    NULL;
  WHEN OTHERS THEN
    RAISE;
END;
/
  
--
--------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Trigger sdl_attribute_mapping_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_attribute_mapping_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_attri_adjustment_r_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_attri_adjustment_r_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_attri_adjust_audit_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_attri_adjust_audit_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_geom_accuracy_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_geom_accuracy_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_load_data_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_load_data_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_pline_statistics_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_pline_statistics_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_process_audit_seq
SET TERM OFF
--
SET FEEDBACK ON
start sdl_process_audit_seq.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_profiles_ai
SET TERM OFF
--
SET FEEDBACK ON
start sdl_profiles_ai.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_profiles_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_profiles_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_spatial_review_lev_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_spatial_review_lev_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_user_profiles_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_user_profiles_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_validation_results_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_validation_results_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_wip_datums_seq_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_wip_datums_seq_trg.trg
SET FEEDBACK OFF
	
SET TERM ON 
PROMPT Creating Trigger sdl_wip_nodes_trg
SET TERM OFF
--
SET FEEDBACK ON
start sdl_wip_nodes_trg.trg
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
--------------------------------------------------------------------------------
-- Metadata
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Creating Metadata
SET TERM OFF
--
SET FEEDBACK ON
start sdl_metadata_upg.sql
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
-- Spatial Indexes
--------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT Spatial Indexes
SET TERM OFF
--
SET FEEDBACK ON
start sdl_spidx.sql
SET FEEDBACK OFF

--
--------------------------------------------------------------------------------
-- Update hig_upgrades with fix ID
--------------------------------------------------------------------------------
--
BEGIN
	--
	hig2.upgrade(p_product        => 'NET'
				,p_upgrade_script => 'log_nm_4800_fix3.sql'
				,p_remarks        => 'NET 4800 FIX 3 (Build 1)'
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
