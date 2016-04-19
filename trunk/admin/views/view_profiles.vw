CREATE OR REPLACE FORCE VIEW VIEW_PROFILES
(
   PROFILE,
   RESOURCE_NAME,
   RESOURCE_TEXT,
   RESOURCE_TYPE,
   LIMIT,
   LIMIT_UNIT
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/view_profiles.vw-arc   1.0   Apr 19 2016 09:51:58   Vikas.Mhetre  $
--       Module Name      : $Workfile:   view_profiles.vw  $
--       Date into PVCS   : $Date:   Apr 19 2016 09:51:58  $
--       Date fetched Out : $Modtime:   Apr 19 2016 09:43:34  $
--       Version          : $Revision:   1.0  $
-----------------------------------------------------------------------------
--    Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   SELECT profile,
          resource_name,
          CASE
             WHEN resource_name = 'CONNECT_TIME'
             THEN
                'Specify the total elapsed time limit for a session'
             WHEN resource_name = 'IDLE_TIME'
             THEN
                'Specify the permitted periods of continuous inactive time during a session'
             WHEN resource_name = 'FAILED_LOGIN_ATTEMPTS'
             THEN
                'Maximum times the user is allowed in fail login before locking the user account'
             WHEN resource_name = 'PASSWORD_LIFE_TIME'
             THEN
                'Number of days the password is valid before expiry'
             WHEN resource_name = 'PASSWORD_REUSE_TIME'
             THEN
                'Number of day after the user can use the already used password'
             WHEN resource_name = 'PASSWORD_REUSE_MAX'
             THEN
                'Number of times the user can use the already used password'
             WHEN resource_name = 'PASSWORD_VERIFY_FUNCTION'
             THEN
                'PL/SQL that can be used for password verification'
             WHEN resource_name = 'PASSWORD_LOCK_TIME'
             THEN
                'Number of days the user account remains locked after failed login'
             WHEN resource_name = 'PASSWORD_GRACE_TIME'
             THEN
                'Number of grace days for user to change password'
             ELSE
                NULL
          END
             resource_text,
          resource_type,
          LIMIT,
          CASE
             WHEN resource_name = 'CONNECT_TIME' THEN 'minutes'
             WHEN resource_name = 'IDLE_TIME' THEN 'minutes'
             WHEN resource_name = 'FAILED_LOGIN_ATTEMPTS' THEN 'times'
             WHEN resource_name = 'PASSWORD_LIFE_TIME' THEN 'days'
             WHEN resource_name = 'PASSWORD_REUSE_TIME' THEN 'days'
             WHEN resource_name = 'PASSWORD_REUSE_MAX' THEN 'times'
             WHEN resource_name = 'PASSWORD_VERIFY_FUNCTION' THEN 'function name'
             WHEN resource_name = 'PASSWORD_LOCK_TIME' THEN 'days'
             WHEN resource_name = 'PASSWORD_GRACE_TIME' THEN 'days'
             ELSE NULL
          END
             limit_unit
     FROM dba_profiles
    WHERE (   resource_type = 'PASSWORD'
           OR (    resource_type = 'KERNEL'
               AND resource_name IN ('IDLE_TIME', 'CONNECT_TIME')))
/