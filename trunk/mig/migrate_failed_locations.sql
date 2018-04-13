--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/mig/migrate_failed_locations.sql-arc   2.2   Apr 13 2018 07:38:08   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   migrate_failed_locations.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 07:38:08  $
--       Date fetched Out : $Modtime:   Apr 13 2018 07:24:28  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
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


