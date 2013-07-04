CREATE OR REPLACE PACKAGE BODY imf_hig_foundation_layer
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/imf_hig_foundation_layer.pkb-arc   3.1   Jul 04 2013 15:04:18   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_hig_foundation_layer.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:04:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:02:38  $
--       Version          : $Revision:   3.1  $
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.1  $';

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
