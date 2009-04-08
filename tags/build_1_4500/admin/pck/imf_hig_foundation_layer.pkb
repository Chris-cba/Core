CREATE OR REPLACE PACKAGE BODY imf_hig_foundation_layer
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/imf_hig_foundation_layer.pkb-arc   3.0   Apr 08 2009 16:17:16   smarshall  $
--       Module Name      : $Workfile:   imf_hig_foundation_layer.pkb  $
--       Date into PVCS   : $Date:   Apr 08 2009 16:17:16  $
--       Date fetched Out : $Modtime:   Apr 08 2009 16:16:38  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.0  $';

  g_package_name CONSTANT varchar2(30) := 'imf_hig_foundation_layer';
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
END imf_hig_foundation_layer;
/
