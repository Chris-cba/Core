-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/imf_net_pkh.sql-arc   3.1   Jul 04 2013 15:04:18   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_pkh.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:04:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:03:54  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
SET echo OFF
SET term OFF
--
col run_file new_value run_file noprint
--
SET TERM ON
PROMPT imf_net_foundation_layer
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_net_foundation_layer.pkh' run_file
FROM dual
/
START '&run_file'
/
--
---------------------------------------------------------------------------------
--

--
-- New proc above here
--
SET term ON

