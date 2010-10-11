-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_hig_views.sql-arc   3.2   Oct 11 2010 10:41:38   Linesh.Sorathia  $
--       Module Name      : $Workfile:   imf_hig_views.sql  $
--       Date into PVCS   : $Date:   Oct 11 2010 10:41:38  $
--       Date fetched Out : $Modtime:   Oct 11 2010 10:40:00  $
--       Version          : $Revision:   3.2  $
-------------------------------------------------------------------------
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



