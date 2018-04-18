-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/imf_hig_install.sql-arc   3.3   Apr 18 2018 16:09:14   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   imf_hig_install.sql  $
--       Date into PVCS   : $Date:   Apr 18 2018 16:09:14  $
--       Date fetched Out : $Modtime:   Apr 18 2018 16:02:10  $
--       Version          : $Revision:   3.3  $
--
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
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
--SET TERM ON
--PROMPT View Constraints...
--SET TERM OFF
--SET DEFINE ON
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'imf_hig_views.con' run_file
--FROM dual
--/
--START '&run_file'
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
