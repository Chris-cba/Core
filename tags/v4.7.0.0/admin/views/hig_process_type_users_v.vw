CREATE OR REPLACE FORCE VIEW hig_process_type_users_v AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_type_users_v.vw-arc   3.2   Jul 04 2013 11:20:04   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_process_type_users_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:54:44  $
--       Version          : $Revision:   3.2  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hpt_process_type_id
     , hus_name 
     , hus_username 
  FROM hig_users
     , dba_users
     , hig_process_types
WHERE hus_username = username
AND   (
        (hus_unrestricted = 'Y')
      OR
      ( EXISTS (
                SELECT 'user shares a role with the process type' 
                  FROM hig_user_roles 
                      ,hig_process_type_roles 
                 WHERE hur_role = hptr_role 
                   AND hur_username = hus_username 
                   AND hptr_process_type_id = hpt_process_type_id
                )
       )         
      )          
ORDER BY DECODE(hus_username, Sys_Context('NM3_SECURITY_CTX','USERNAME'),1,2),hus_username, hpt_process_type_id
/

COMMENT ON TABLE hig_process_type_users_v IS 'Exor Process Framework view.  Process types which are visible to all users.'
/ 
