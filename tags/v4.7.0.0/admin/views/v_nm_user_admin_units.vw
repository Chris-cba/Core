CREATE OR REPLACE FORCE VIEW v_nm_user_admin_units AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_user_admin_units.vw-arc   3.1   Jul 04 2013 11:25:02   James.Wadsworth  $
--       Module Name      : $Workfile:   v_nm_user_admin_units.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:25:02  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:42  $
--       Version          : $Revision:   3.1  $
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
