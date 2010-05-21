CREATE OR REPLACE FORCE VIEW v_nm_user_admin_units AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_user_admin_units.vw-arc   3.0   May 21 2010 10:52:14   gjohnson  $
--       Module Name      : $Workfile:   v_nm_user_admin_units.vw  $
--       Date into PVCS   : $Date:   May 21 2010 10:52:14  $
--       Date fetched Out : $Modtime:   May 21 2010 10:45:44  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
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