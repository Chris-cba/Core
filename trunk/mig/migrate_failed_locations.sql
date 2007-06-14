define sccsid = '"@(#)migrate_failed_locations.sql	1.1 12/24/04"'
PROMPT ==============================================================
PROMPT Migration of Failed Inventory Locations                       
PROMPT ==============================================================
PROMPT


set verify off feedback off 
undefine dir

accept dir prompt    "Enter the location on the database server where log files should be written  [E:\UTL_FILE]: " DEFAULT e:\utl_file

BEGIN
  nm2_nm3_migration.migrate_failed_inventory_loc (pi_log_file_location => '&dir');
END;
/

PROMPT Done
PROMPT Check log file on database server in directory &dir


