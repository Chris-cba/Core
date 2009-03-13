-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/imf_net_pkb.sql-arc   3.0   Mar 13 2009 14:36:58   gjohnson  $
--       Module Name      : $Workfile:   imf_net_pkb.sql  $
--       Date into PVCS   : $Date:   Mar 13 2009 14:36:58  $
--       Date fetched Out : $Modtime:   Mar 13 2009 14:36:30  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
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
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'imf_net_foundation_layer.pkw' run_file
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

