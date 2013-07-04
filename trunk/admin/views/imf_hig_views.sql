-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_hig_views.sql-arc   3.3   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_hig_views.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:01:58  $
--       Version          : $Revision:   3.3  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
SET echo OFF
SET term OFF
--
COL run_file new_value run_file noprint
--
-------------------------------------------------------------------------
--
SET TERM ON
PROMPT imf_hig_financial_years
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_hig_financial_years.vw' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--
PROMPT imf_hig_alerts
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_hig_alerts.vw' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--
PROMPT imf_hig_audits
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_hig_audits.vw' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--
PROMPT imf_hig_process_executions
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_hig_process_executions.vw' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--








--
-------------------------------------------------------------------------
--
-- new views above this
--
-------------------------------------------------------------------------
--

set term on



