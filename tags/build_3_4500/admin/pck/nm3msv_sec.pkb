CREATE OR REPLACE PACKAGE BODY nm3msv_sec
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3msv_sec.pkb-arc   3.1   May 16 2011 14:45:02   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3msv_sec.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:45:02  $
--       Date fetched Out : $Modtime:   May 05 2011 13:31:34  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   3.1  $';
--
  g_package_name CONSTANT VARCHAR2(30) := 'nm3msv_sec';
--
  c_module                hig_modules.hmo_module%TYPE := 'MAPBUILDER';
  c_role                  hig_roles.hro_role%TYPE     := 'GIS_SUPERUSER';
--
  ex_no_perm_usm          EXCEPTION;
  ex_no_perm_ust          EXCEPTION;
  ex_no_perm_uss          EXCEPTION;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_version RETURN varchar2 IS
  BEGIN
     RETURN g_sccsid;
  END get_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_body_version RETURN varchar2 IS
  BEGIN
     RETURN g_body_sccsid;
  END get_body_version;
--
-----------------------------------------------------------------------------
--
  FUNCTION user_has_permission ( pi_username IN VARCHAR2 )
  RETURN BOOLEAN
  IS
    l_count NUMBER;
    CURSOR c1 IS
      SELECT count(*)
        FROM hig_module_roles, hig_user_roles
       WHERE hmr_module   = c_module
         AND hmr_role     = c_role
         AND hmr_role     = hur_role
         AND hur_username = pi_username;
  BEGIN
  --
    OPEN c1;
    FETCH c1 INTO l_count;
    CLOSE c1;
  --
    RETURN (l_count>0);
  --
  END user_has_permission;
--
-----------------------------------------------------------------------------
--
--  USER_SDO_MAPS logic
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_usm_ins ( pi_username IN VARCHAR2
                       , pi_rec_usm  IN user_sdo_maps%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_usm_ins');
  --
    IF user_has_permission (pi_username)
    THEN
      INSERT INTO mdsys.sdo_maps_table
      VALUES ( Sys_Context('NM3CORE','APPLICATION_OWNER')
             , pi_rec_usm.name
             , pi_rec_usm.description
             , pi_rec_usm.definition );
    ELSE
      RAISE ex_no_perm_usm;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_usm_ins');
  --
  EXCEPTION
    WHEN ex_no_perm_usm
    THEN
      RAISE_APPLICATION_ERROR (-20501, pi_username||' does not have permission to operate on USER_SDO_MAPS');
  END do_usm_ins;
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_usm_del ( pi_username IN VARCHAR2
                       , pi_rec_usm  IN user_sdo_maps%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_usm_del');
  --
    IF user_has_permission (pi_username)
    THEN
      DELETE mdsys.sdo_maps_table
       WHERE sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND name = pi_rec_usm.name;
    ELSE
      RAISE ex_no_perm_usm;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_usm_ins');
  --
  EXCEPTION
    WHEN ex_no_perm_usm
    THEN
      RAISE_APPLICATION_ERROR (-20501, pi_username||' does not have permission to operate on USER_SDO_MAPS');
  END do_usm_del;
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_usm_upd ( pi_username IN VARCHAR2
                       , pi_rec_usm  IN user_sdo_maps%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_usm_upd');
  --
    IF user_has_permission (pi_username)
    THEN
      UPDATE mdsys.sdo_maps_table
         SET name        = pi_rec_usm.name
           , description = pi_rec_usm.description
           , definition  = pi_rec_usm.definition
       WHERE sdo_owner   = Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND name        = pi_rec_usm.name;
    ELSE
      RAISE ex_no_perm_usm;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_usm_upd');
  --
  EXCEPTION
    WHEN ex_no_perm_usm
    THEN
      RAISE_APPLICATION_ERROR (-20501, pi_username||' does not have permission to operate on USER_SDO_MAPS');
  END do_usm_upd;
--
-----------------------------------------------------------------------------
--
--  USER_SDO_THEMES logic
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_ust_ins ( pi_username IN VARCHAR2
                       , pi_rec_ust  IN user_sdo_themes%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_ust_ins');
  --
    IF user_has_permission (pi_username)
    THEN
      INSERT INTO mdsys.sdo_themes_table
        VALUES ( Sys_Context('NM3CORE','APPLICATION_OWNER')
               , pi_rec_ust.name
               , pi_rec_ust.description
               , pi_rec_ust.base_table
               , pi_rec_ust.geometry_column
               , pi_rec_ust.styling_rules );
    ELSE
      RAISE ex_no_perm_ust;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_ust_ins');
  --
--
  EXCEPTION
    WHEN ex_no_perm_ust
    THEN
      RAISE_APPLICATION_ERROR (-20502, pi_username||' does not have permission to operate on USER_SDO_THEMES');
  END do_ust_ins;
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_ust_del ( pi_rec_ust  IN user_sdo_themes%ROWTYPE 
                       , pi_username IN VARCHAR2)
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_ust_del');
  --
    IF user_has_permission (pi_username)
    THEN
      DELETE mdsys.sdo_themes_table
       WHERE sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND name = pi_rec_ust.name;
    ELSE
      RAISE ex_no_perm_ust;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_ust_del');
  --
  EXCEPTION
    WHEN ex_no_perm_ust
    THEN
      RAISE_APPLICATION_ERROR (-20502, pi_username||' does not have permission to operate on USER_SDO_THEMES');
  END do_ust_del;
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_ust_upd ( pi_username IN VARCHAR2
                       , pi_rec_ust  IN user_sdo_themes%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_ust_upd');
  --
    IF user_has_permission (pi_username)
    THEN
      UPDATE mdsys.sdo_themes_table
         SET name            = pi_rec_ust.name
           , description     = pi_rec_ust.description
           , base_table      = pi_rec_ust.base_table
           , geometry_column = pi_rec_ust.geometry_column
           , styling_rules   = pi_rec_ust.styling_rules
       WHERE sdo_owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND name            = pi_rec_ust.name;
    ELSE
      RAISE ex_no_perm_ust;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_ust_upd');
  --
  EXCEPTION
    WHEN ex_no_perm_ust
    THEN
      RAISE_APPLICATION_ERROR (-20502, pi_username||' does not have permission to operate on USER_SDO_THEMES');
  END do_ust_upd;
--
-----------------------------------------------------------------------------
--
--  USER_SDO_STYLES logic
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_uss_ins ( pi_username IN VARCHAR2
                       , pi_rec_uss  IN user_sdo_styles%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_uss_ins');
  --
    IF user_has_permission (pi_username)
    THEN
      INSERT INTO mdsys.sdo_styles_table
      VALUES ( Sys_Context('NM3CORE','APPLICATION_OWNER')
             , pi_rec_uss.name
             , pi_rec_uss.type
             , pi_rec_uss.description
             , pi_rec_uss.definition
             , pi_rec_uss.image
             , pi_rec_uss.geometry );
    ELSE
      RAISE ex_no_perm_uss;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_uss_ins');
  --
  EXCEPTION
    WHEN ex_no_perm_uss
    THEN
      RAISE_APPLICATION_ERROR (-20503, pi_username||' does not have permission to operate on USER_SDO_STYLES');
  END do_uss_ins;
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_uss_del ( pi_username IN VARCHAR2
                       , pi_rec_uss  IN user_sdo_styles%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_uss_del');
  --
    IF user_has_permission (pi_username)
    THEN
      DELETE mdsys.sdo_styles_table
       WHERE sdo_owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND name = pi_rec_uss.name;
    ELSE
      RAISE ex_no_perm_uss;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_uss_del');
  --
  EXCEPTION
    WHEN ex_no_perm_uss
    THEN
      RAISE_APPLICATION_ERROR (-20503, pi_username||' does not have permission to operate on USER_SDO_STYLES');
  END do_uss_del;
--
-----------------------------------------------------------------------------
--
  PROCEDURE do_uss_upd ( pi_username IN VARCHAR2
                       , pi_rec_uss  IN user_sdo_styles%ROWTYPE )
  IS
  BEGIN
  --
    nm_debug.proc_start(g_package_name,'do_uss_upd');
  --
    IF user_has_permission (pi_username)
    THEN
      UPDATE mdsys.sdo_styles_table
         SET name        = pi_rec_uss.name
           , type        = pi_rec_uss.type
           , description = pi_rec_uss.description
           , definition  = pi_rec_uss.definition
           , image       = pi_rec_uss.image
           , geometry    = pi_rec_uss.geometry
       WHERE sdo_owner   = Sys_Context('NM3CORE','APPLICATION_OWNER')
         AND name        = pi_rec_uss.name;
    ELSE
      RAISE ex_no_perm_uss;
    END IF;
  --
    nm_debug.proc_end(g_package_name,'do_uss_upd');
  --
  EXCEPTION
    WHEN ex_no_perm_uss
    THEN
      RAISE_APPLICATION_ERROR (-20503, pi_username||' does not have permission to operate on USER_SDO_STYLES');
  END do_uss_upd;
--
-----------------------------------------------------------------------------
--
END nm3msv_sec;
/
