-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/imf_net_install.sql-arc   3.0   Mar 13 2009 14:35:42   gjohnson  $
--       Module Name      : $Workfile:   imf_net_install.sql  $
--       Date into PVCS   : $Date:   Mar 13 2009 14:35:42  $
--       Date fetched Out : $Modtime:   Mar 13 2009 14:35:26  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
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
PROMPT Network Manager
PROMPT ===============
SET TERM OFF
--
-------------------------------------------------------------------------
--
SET TERM ON
PROMPT Foundation Views...
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_net_views.sql' run_file
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
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_net_views.con' run_file
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
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_net_pkh.sql' run_file
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
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_net_pkb.sql' run_file
FROM dual
/
START '&run_file'
--
-------------------------------------------------------------------------
--