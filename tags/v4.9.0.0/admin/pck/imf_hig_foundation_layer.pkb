CREATE OR REPLACE PACKAGE BODY imf_hig_foundation_layer
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/imf_hig_foundation_layer.pkb-arc   3.2   Apr 16 2018 09:22:00   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   imf_hig_foundation_layer.pkb  $
--       Date into PVCS   : $Date:   Apr 16 2018 09:22:00  $
--       Date fetched Out : $Modtime:   Apr 16 2018 08:54:24  $
--       Version          : $Revision:   3.2  $
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   3.2  $';

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
