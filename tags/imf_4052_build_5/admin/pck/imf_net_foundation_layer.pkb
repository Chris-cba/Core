CREATE OR REPLACE PACKAGE BODY imf_net_foundation_layer
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/imf_net_foundation_layer.pkb-arc   3.0   Mar 13 2009 14:36:58   gjohnson  $
--       Module Name      : $Workfile:   imf_net_foundation_layer.pkb  $
--       Date into PVCS   : $Date:   Mar 13 2009 14:36:58  $
--       Date fetched Out : $Modtime:   Mar 13 2009 14:36:30  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.0  $';

  g_package_name CONSTANT varchar2(30) := 'imf_net_foundation_layer';
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
END imf_net_foundation_layer;
/
