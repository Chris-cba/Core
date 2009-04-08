-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/imf_hig_install.sql-arc   3.0   Apr 08 2009 16:23:48   smarshall  $
--       Module Name      : $Workfile:   imf_hig_install.sql  $
--       Date into PVCS   : $Date:   Apr 08 2009 16:23:48  $
--       Date fetched Out : $Modtime:   Apr 08 2009 16:23:32  $
--       Version          : $Revision:   3.0  $
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
PROMPT Highways
PROMPT ========
SET TERM OFF
--
-------------------------------------------------------------------------
--
SET TERM ON
PROMPT Foundation Views...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_hig_views.sql' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--
SET TERM ON
PROMPT View Constraints...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_hig_views.con' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--
SET TERM ON
PROMPT Package Headers...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_hig_pkh.sql' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--
SET TERM ON
PROMPT Package Bodies...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_hig_pkb.sql' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--