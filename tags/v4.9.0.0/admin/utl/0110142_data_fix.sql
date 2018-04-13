-----------------------------------------------------------------------------
-- This script removes duplicate user details caused by an issue with details 
-- being created erroneously when updating existing records. The script will 
-- remove duplicate user details and keep the most recently modified details.
-- WARNING:PLEASE ENSURE THE LASET MODIFIED DETAIL IS THE ONE YOU WISH TO KEEP 
-- BEFORE RUNNING THIS SCRIPT.
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/0110142_data_fix.sql-arc   3.2   Apr 13 2018 12:53:20   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   0110142_data_fix.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:20  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
--       Version          : $Revision:   3.2  $
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  DELETE
    FROM hig_user_contacts_all
   WHERE (huc_hus_user_id, huc_date_modified) NOT IN  
 (SELECT huc_hus_user_id, MAX(huc_date_modified) huc_date_modified 
    FROM hig_user_contacts_all 
GROUP BY huc_hus_user_id);
--
COMMIT;
