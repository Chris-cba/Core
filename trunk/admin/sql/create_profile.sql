--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/sql/create_profile.sql-arc   1.0   Apr 19 2016 09:57:34   Vikas.Mhetre  $
--       Module Name      : $Workfile:   create_profile.sql  $
--       Date into PVCS   : $Date:   Apr 19 2016 09:57:34  $
--       Date fetched Out : $Modtime:   Apr 19 2016 09:57:02  $
--       Version          : $Revision:   1.0  $
--       
--  Create new profile to enforce password complexity
------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
CREATE PROFILE ENFORCE    LIMIT
IDLE_TIME                 20
FAILED_LOGIN_ATTEMPTS     5
PASSWORD_LIFE_TIME        90
PASSWORD_REUSE_TIME       90
PASSWORD_REUSE_MAX        UNLIMITED
PASSWORD_VERIFY_FUNCTION  F_PASSWORD_VERIFY
PASSWORD_LOCK_TIME        DEFAULT
PASSWORD_GRACE_TIME       10
/