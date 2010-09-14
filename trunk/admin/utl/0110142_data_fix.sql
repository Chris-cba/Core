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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/0110142_data_fix.sql-arc   3.0   Sep 14 2010 10:43:32   Mike.Alexander  $
--       Module Name      : $Workfile:   0110142_data_fix.sql  $
--       Date into PVCS   : $Date:   Sep 14 2010 10:43:32  $
--       Date fetched Out : $Modtime:   Sep 14 2010 10:43:06  $
--       Version          : $Revision:   3.0  $
--
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2010
-----------------------------------------------------------------------------
  DELETE
    FROM hig_user_contacts_all
   WHERE (huc_hus_user_id, huc_date_modified) NOT IN  
 (SELECT huc_hus_user_id, MAX(huc_date_modified) huc_date_modified 
    FROM hig_user_contacts_all 
GROUP BY huc_hus_user_id);
--
COMMIT;