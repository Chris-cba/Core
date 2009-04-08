-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/imf_hig_pkh.sql-arc   3.0   Apr 08 2009 16:26:40   smarshall  $
--       Module Name      : $Workfile:   imf_hig_pkh.sql  $
--       Date into PVCS   : $Date:   Apr 08 2009 16:26:40  $
--       Date fetched Out : $Modtime:   Apr 08 2009 16:26:10  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
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
