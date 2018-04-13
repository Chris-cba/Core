CREATE OR REPLACE FORCE VIEW v_nm_user_admin_units AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_user_admin_units.vw-arc   3.2   Apr 13 2018 11:47:26   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_nm_user_admin_units.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:26  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:44:38  $
--       Version          : $Revision:   3.2  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
       nau_admin_type
      ,nau_admin_unit
      ,nau_unit_code
      ,nau_name
      ,au_mode
FROM   nm_admin_units
      ,v_nm_user_au_modes   
WHERE nau_admin_unit = admin_unit
/
COMMENT ON TABLE v_nm_user_admin_units IS 'List of admin units that the logged on user has permission to work with'
/
