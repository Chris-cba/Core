set termout on
set pages 1000
clear screen

-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/mig/nm2_nm3_script_setup.sql-arc   2.3   Jul 04 2013 16:49:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm2_nm3_script_setup.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:46:22  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on SCCS version :
--
-----------------------------------------------------------------------------

PROMPT =================================================================
PROMPT Migration of Core Highways and Network Manager - Script Generator
PROMPT =================================================================
PROMPT

set verify off head off feedback off term on serveroutput on define on 

undefine dir
undefine inv_type
undefine v2_owner
undefine spatial_table
undefine spatial_column
undefine spatial_id

undefine tma_yn
undefine open_only
undefine ukp_only

undefine p_part1
undefine p_part2_step1
undefine p_part2_step2
undefine p_part2_step3
undefine p_part2_step4
undefine p_part2_step5
undefine p_part2_step6
undefine p_part2_step7
undefine p_part2_step8
undefine p_part2_step9
undefine p_part3
undefine p_part4
undefine p_fail_inv
undefine p_fail_loc

col p_part1       new_value p_part1       noprint
col p_part2_step1 new_value p_part2_step1 noprint
col p_part2_step2 new_value p_part2_step2 noprint
col p_part2_step3 new_value p_part2_step3 noprint
col p_part2_step4 new_value p_part2_step4 noprint 
col p_part2_step5 new_value p_part2_step5 noprint
col p_part2_step6 new_value p_part2_step6 noprint
col p_part2_step7 new_value p_part2_step7 noprint
col p_part2_step8 new_value p_part2_step8 noprint
col p_part2_step9 new_value p_part2_step9 noprint
col p_part3       new_value p_part3       noprint
col p_part4       new_value p_part4       noprint
col p_fail_inv    new_value p_fail_inv    noprint
col p_fail_loc    new_value p_fail_loc    noprint


accept dir prompt    "Enter the location on the database server where log files should be written  [E:\UTL_FILE]: " DEFAULT e:\utl_file
accept inv_type prompt  "Inventory Type to Associated with Network [NETW]: " DEFAULT NETW
accept v2_owner prompt  "Enter the v2 Application owner [HIGHWAYS] : " DEFAULT HIGHWAYS
accept spatial_table prompt "Enter the Spatial Table Name [HIG_NET_MAP] : " DEFAULT HIG_NET_MAP
accept spatial_column prompt "Enter the Spatial Column Name [SHAPE] : " DEFAULT SHAPE
accept spatial_id prompt "Enter the Spatial Road ID Column Name [RSE_HE_ID] : " DEFAULT RSE_HE_ID

accept tma_yn prompt "Are you migrating into an existing TMA System (Y/N) [Y] : " DEFAULT Y
accept open_only prompt "Do you wish to migrate open assets only (Y) or all assets(N) [N] : " DEFAULT N
accept ukp_only prompt "Do you wish to migrate all assets (A), UKP only (U) or Non UKP assets only (N) [A] : " DEFAULT A

--
---------------------------------------------------------------------------------------------------------------
--
Prompt
Prompt Working....
SET TERM Off
--
---------------------------------------------------------------------------------------------------------------
--
select  'PROMPT ======================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 1'||chr(10) 
      ||'PROMPT ======================================================='||chr(10)	         
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_cor_doc_gis (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_v2_higowner     => '''||UPPER('&v2_owner')||''');'||chr(10)
      ||'END;'||chr(10)||'/' ||chr(10)||chr(10)
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part1	  	  
from dual 
where upper('&tma_yn')='N'
union all
select  'PROMPT ======================================================='||chr(10)
      ||'PROMPT Do not run Part 1 when migrating into an existing system'||chr(10) 
      ||'PROMPT ======================================================='||chr(10)	         
from dual 
where upper('&tma_yn')='Y'
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 1'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 1);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step1	  	  
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 2'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 2);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step2
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 3'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 3);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step3
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 4'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 4);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step4
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 5'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 5);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step5
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 6'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 6);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step6
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 7'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 7);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step7
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--

SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 8'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_ukp_only	       => '''||UPPER('&ukp_only')||''''||CHR(10)
      ||'                                                ,pi_open_only	       => '''||UPPER('&open_only')||''''||CHR(10)
      ||'                                                ,pi_step	       => 8);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step8
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 2 Step 9'||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_network_and_inventory (pi_log_file_location => ''&dir'''||chr(10)
      ||'                                                ,pi_netw_inv_type     => '''||UPPER('&inv_type')||''''||CHR(10)
      ||'                                                ,pi_step	       => 9);'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part2_step9
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Core Highways and Network Manager - Part 3       '||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_doc_assocs (pi_log_file_location => ''&dir'');'||chr(10)
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_part3
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||CHR(10)
      ||'PROMPT Migration of Spatial Layer  - Part 4                          '||CHR(10)
      ||'PROMPT =============================================================='||CHR(10)	   
      ||'PROMPT' ||CHR(10)
      ||'PROMPT Working....'||CHR(10)||CHR(10)
      ||'BEGIN'||CHR(10)
      ||'nm2_nm3_migration.do_spatial_migration (pi_log_file_location => ''&dir'''||CHR(10)
      ||'                                                ,pi_table_name =>'''||UPPER('&spatial_table')||''''||CHR(10)
      ||'                                                ,pi_id_col_name => '''||UPPER('&spatial_id')||''''||CHR(10)
      ||'                                                ,pi_shape_col_name => '''||UPPER('&spatial_column')||''');'||CHR(10)
      ||'END;'||CHR(10)||'/'||CHR(10)||CHR(10) 	  
      ||'PROMPT Done' ||CHR(10)
      ||'PROMPT Check log file on database server in directory &dir' ||CHR(10)||CHR(10) p_part4
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Failed Inventory                                 '||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_failed_inventory (pi_log_file_location => ''&dir'');'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_fail_inv
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
SELECT  'PROMPT =============================================================='||chr(10)
      ||'PROMPT Migration of Failed Inventory Locations                       '||chr(10)
      ||'PROMPT =============================================================='||chr(10)	   
      ||'PROMPT' ||chr(10)
      ||'PROMPT Working....'||chr(10)||chr(10)
      ||'BEGIN'||chr(10)
      ||'nm2_nm3_migration.migrate_failed_inventory_loc (pi_log_file_location => ''&dir'');'||chr(10)	
      ||'END;'||chr(10)||'/'||chr(10)||chr(10) 	  
      ||'PROMPT Done' ||chr(10)
      ||'PROMPT Check log file on database server in directory &dir' ||chr(10)||chr(10) p_fail_loc
FROM dual
/
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part1.sql
prompt &p_part1
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step1.sql
prompt &p_part2_step1
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step2.sql
prompt &p_part2_step2
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step3.sql
prompt &p_part2_step3
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step4.sql
prompt &p_part2_step4
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step5.sql
prompt &p_part2_step5
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step6.sql
prompt &p_part2_step6
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step7.sql
prompt &p_part2_step7
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step8.sql
prompt &p_part2_step8
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part2_step9.sql
prompt &p_part2_step9
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part3.sql
prompt &p_part3
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool do_migration_part4.sql
prompt &p_part4
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool migrate_failed_inventory.sql
prompt &p_fail_inv
spool off
--
---------------------------------------------------------------------------------------------------------------
--
spool migrate_failed_locations.sql
prompt &p_fail_loc
spool off
--
---------------------------------------------------------------------------------------------------------------
--
set term on

Prompt 
Prompt Created the following scripts in the working directory.....
Prompt do_migration_part1.sql
Prompt do_migration_part2_step1.sql
Prompt do_migration_part2_step2.sql
Prompt do_migration_part2_step3.sql
Prompt do_migration_part2_step4.sql
Prompt do_migration_part2_step5.sql
Prompt do_migration_part2_step6.sql
Prompt do_migration_part2_step7.sql
Prompt do_migration_part2_step8.sql
Prompt do_migration_part2_step9.sql
Prompt do_migration_part3.sql
Prompt do_migration_part4.sql
Prompt migrate_failed_inventory.sql
Prompt migrate_failed_locations.sql
Prompt

