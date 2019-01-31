CREATE OR REPLACE FORCE VIEW v_all_contractor_users
  (oun_org_id
  ,hus_user_id
  ,hus_initials
  ,hus_name
  ,hus_username
  ,via_role)
AS
SELECT  
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_all_contractor_users.vw-arc   1.0   Jan 31 2019 09:23:18   Chris.Baugh  $
--       Module Name      : $Workfile:   v_all_contractor_users.vw  $
--       Date into PVCS   : $Date:   Jan 31 2019 09:23:18  $
--       Date fetched Out : $Modtime:   Jul 01 2013 14:19:24  $
--       Version          : $Revision:   1.0  $
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
       cou_oun_org_id oun_org_id
      ,hus_user_id
      ,hus_initials
      ,hus_name
      ,hus_username
      ,'N' via_role
  FROM contractor_users
      ,hig_users
 WHERE hus_user_id = cou_hus_user_id
 UNION
SELECT cor_oun_org_id oun_org_id
      ,hus_user_id
      ,hus_initials
      ,hus_name
      ,hus_username
      ,'Y' via_role
  FROM contractor_roles
      ,hig_user_roles
      ,hig_users
 WHERE hus_username = hur_username
   AND hur_role = cor_role
   AND NOT EXISTS(SELECT 1
                    FROM contractor_users
                   WHERE cou_hus_user_id = hus_user_id)
/
