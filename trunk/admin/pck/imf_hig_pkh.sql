-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/pck/imf_hig_pkh.sql-arc   3.2   Apr 16 2018 09:22:00   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   imf_hig_pkh.sql  $
--       Date into PVCS   : $Date:   Apr 16 2018 09:22:00  $
--       Date fetched Out : $Modtime:   Apr 16 2018 09:20:44  $
--       Version          : $Revision:   3.2  $
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
PROMPT imf_hig_foundation_layer
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_hig_foundation_layer.pkh' run_file
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
