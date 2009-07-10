CREATE OR REPLACE PACKAGE BODY nm3data AS
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3data.pkb-arc   3.0   Jul 10 2009 11:02:48   aedwards  $
--       Module Name      : $Workfile:   nm3data.pkb  $
--       Date into PVCS   : $Date:   Jul 10 2009 11:02:48  $
--       Date fetched Out : $Modtime:   Jul 10 2009 10:57:28  $
--       PVCS Version     : $Revision:   3.0  $
--
--   Author : A Edwards
--
--   NM3 Data maintenance package
--
--------------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) :='"$Revision:   3.0  $"';
  g_package_name CONSTANT varchar2(30)   := 'nm3data';
--
  g_gdo          CONSTANT varchar2(30)   := 'GIS_DATA_OBJECTS';
  g_ngqi         CONSTANT varchar2(30)   := 'NM_GAZ_QUERY_ITEM_LIST';
  g_nd           CONSTANT varchar2(30)   := 'NM_DBUG';
--
--  ORA-00054: resource busy and acquire with NOWAIT specified
--
  ex_resource_busy        EXCEPTION;
  PRAGMA                  EXCEPTION_INIT(ex_resource_busy,-54);
--
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
  PROCEDURE cleardown ( pi_table_name IN user_tables.table_name%TYPE )
  IS
  BEGIN
    EXECUTE IMMEDIATE 'LOCK TABLE '||pi_table_name||' IN EXCLUSIVE MODE NOWAIT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||pi_table_name;
  EXCEPTION
    WHEN ex_resource_busy
    THEN
      RAISE_APPLICATION_ERROR (-20101,'Cannot lock table '
                               ||pi_table_name||
                               ' - transaction(s) are still active');
  END cleardown;
--
--------------------------------------------------------------------------------
--
  PROCEDURE cleardown_gdo IS
  BEGIN
    cleardown ( pi_table_name => g_gdo );
  END cleardown_gdo;
--
--------------------------------------------------------------------------------
--
  PROCEDURE cleardown_ngqi IS
  BEGIN
    cleardown ( pi_table_name => g_ngqi );
  END cleardown_ngqi;
--
--------------------------------------------------------------------------------
--
  PROCEDURE cleardown_nd IS
  BEGIN
    cleardown ( pi_table_name => g_nd );
  END cleardown_nd;
--
--------------------------------------------------------------------------------
--
END nm3data;
/
