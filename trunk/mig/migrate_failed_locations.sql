--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/mig/migrate_failed_locations.sql-arc   2.1   Jul 04 2013 16:49:08   James.Wadsworth  $
--       Module Name      : $Workfile:   migrate_failed_locations.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:48:08  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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


