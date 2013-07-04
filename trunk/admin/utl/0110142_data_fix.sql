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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/0110142_data_fix.sql-arc   3.1   Jul 04 2013 10:29:56   James.Wadsworth  $
--       Module Name      : $Workfile:   0110142_data_fix.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:18:56  $
--       Version          : $Revision:   3.1  $
--
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  DELETE
    FROM hig_user_contacts_all
   WHERE (huc_hus_user_id, huc_date_modified) NOT IN  
 (SELECT huc_hus_user_id, MAX(huc_date_modified) huc_date_modified 
    FROM hig_user_contacts_all 
GROUP BY huc_hus_user_id);
--
COMMIT;
