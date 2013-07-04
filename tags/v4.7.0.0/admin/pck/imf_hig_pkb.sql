-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/imf_hig_pkb.sql-arc   3.1   Jul 04 2013 15:04:18   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_hig_pkb.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:04:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:03:00  $
--       Version          : $Revision:   3.1  $
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
PROMPT imf_hig_foundation_layer
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_hig_foundation_layer.pkw' run_file
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
