-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_hig_views.sql-arc   3.1   Apr 09 2009 14:09:26   smarshall  $
--       Module Name      : $Workfile:   imf_hig_views.sql  $
--       Date into PVCS   : $Date:   Apr 09 2009 14:09:26  $
--       Date fetched Out : $Modtime:   Apr 09 2009 14:09:16  $
--       Version          : $Revision:   3.1  $
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










--
-------------------------------------------------------------------------
--
-- new views above this
--
-------------------------------------------------------------------------
--

set term on



