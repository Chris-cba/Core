CREATE OR REPLACE PACKAGE BODY hig_process_framework_utils
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/hig_process_framework_utils.pkb-arc   3.1   Jul 04 2013 14:52:08   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_process_framework_utils.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:52:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:51:14  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   3.1  $';

  g_package_name CONSTANT varchar2(30) := 'hig_process_framework_utils';
  
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
FUNCTION formatted_process_id(pi_process_id IN hig_processes.hp_process_id%TYPE) RETURN VARCHAR2 IS

BEGIN

  RETURN LTRIM (TO_CHAR (pi_process_id, '00000000'));

END formatted_process_id;
--
-----------------------------------------------------------------------------
--
END hig_process_framework_utils;
/


