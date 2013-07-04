CREATE OR REPLACE PACKAGE BODY nm3sdo_gdr
AS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_gdr.pkb-arc   3.2   Jul 04 2013 16:29:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3sdo_gdr.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:29:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:28:18  $
--       PVCS Version     : $Revision:   3.2  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT VARCHAR2(2000) := '"$Revision:   3.2  $"';
   g_package_name    CONSTANT VARCHAR2 (30)  := 'NM3SDO_GDR';
--
-----------------------------------------------------------------------------
--
  FUNCTION get_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_sccsid;
  END get_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN VARCHAR2 IS
  BEGIN
     RETURN g_body_sccsid;
  END get_body_version;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_gdr ( pi_gdr_gdo_session_id IN gis_data_restrictions.gdr_gdo_session_id%TYPE )
    RETURN gis_data_restrictions%ROWTYPE
  IS
    retval gis_data_restrictions%ROWTYPE;
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'get_gdr');
  --
    SELECT * INTO retval FROM gis_data_restrictions
     WHERE gdr_gdo_session_id = pi_gdr_gdo_session_id;
  --
    RETURN retval;
  --
    nm_debug.proc_end (g_package_name, 'get_gdr');
  --
  END get_gdr;
--
--------------------------------------------------------------------------------
--
  FUNCTION get_gdr ( pi_gdr_username     IN gis_data_restrictions.gdr_username%TYPE
                   , pi_gdr_nth_theme_id IN gis_data_restrictions.gdr_nth_theme_id%TYPE
                   , pi_raise_not_found  IN BOOLEAN DEFAULT FALSE )
    RETURN gis_data_restrictions%ROWTYPE
  IS
    retval gis_data_restrictions%ROWTYPE;
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'get_gdr');
  --
    SELECT * INTO retval FROM gis_data_restrictions
     WHERE gdr_username = pi_gdr_username
       AND gdr_nth_theme_id = pi_gdr_nth_theme_id;
  --
    RETURN retval;
  --
    nm_debug.proc_end (g_package_name, 'get_gdr');
  --
  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      IF pi_raise_not_found THEN RAISE;
      ELSE RETURN retval;
      END IF;
  END get_gdr;
--
--------------------------------------------------------------------------------
--
  PROCEDURE ins_gdr ( pi_rec_gdr IN gis_data_restrictions%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'ins_gdr');
  --
    INSERT INTO gis_data_restrictions
    VALUES pi_rec_gdr;
  --
    nm_debug.proc_end (g_package_name, 'ins_gdr');
  --
  END ins_gdr;
--
--------------------------------------------------------------------------------
--
  PROCEDURE del_gdr ( pi_gdr_gdo_session_id IN gis_data_restrictions.gdr_gdo_session_id%TYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'del_gdr');
  --
    DELETE gis_data_restrictions
     WHERE gdr_gdo_session_id = pi_gdr_gdo_session_id;
  --
    nm_debug.proc_end (g_package_name, 'del_gdr');
  --
  END del_gdr;
--
--------------------------------------------------------------------------------
--
  PROCEDURE del_gdr ( pi_gdr_username IN gis_data_restrictions.gdr_username%TYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'del_gdr');
  --
    DELETE gis_data_restrictions
     WHERE gdr_username = pi_gdr_username;
  --
    nm_debug.proc_end (g_package_name, 'del_gdr');
  --
  END del_gdr;
--
--------------------------------------------------------------------------------
--
  PROCEDURE cleardown_gdr
  IS
  BEGIN
  --
    nm_debug.proc_start (g_package_name, 'cleardown_gdr');
  --
    DELETE gis_data_restrictions;
  --
    nm_debug.proc_end (g_package_name, 'cleardown_gdr');
  --
  END cleardown_gdr;
--
--------------------------------------------------------------------------------
--
  FUNCTION is_subselect_enabled
  RETURN BOOLEAN
  IS
  BEGIN
    RETURN (NVL(hig.get_user_or_sys_opt('GDRSUBSEL'),'N') = 'Y');
  END is_subselect_enabled;
--
--------------------------------------------------------------------------------
--
END nm3sdo_gdr;
/
