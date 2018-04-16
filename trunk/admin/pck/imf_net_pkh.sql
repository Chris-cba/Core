-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/imf_net_pkh.sql-arc   3.2   Apr 16 2018 09:22:02   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   imf_net_pkh.sql  $
--       Date into PVCS   : $Date:   Apr 16 2018 09:22:02  $
--       Date fetched Out : $Modtime:   Apr 16 2018 09:20:44  $
--       Version          : $Revision:   3.2  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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

