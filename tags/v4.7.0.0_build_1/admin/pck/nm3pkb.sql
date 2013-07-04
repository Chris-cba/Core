-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3pkb.sql-arc   2.41   Jul 04 2013 16:21:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3pkb.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       PVCS Version     : $Revision:   2.41  $
--
--
--   Author : Graeme Johnson
--
--   Run on product install/upgrade
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

SET echo OFF
col run_file new_value run_file noprint

SET TERM ON 
PROMPT colour.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'colour.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT dm3query.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'dm3query.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_api.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_api.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT exor_version.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'exor_version.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig2.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig2.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig3.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig3.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_directories_api.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_directories_api.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_hd_extract.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_hd_extract.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_hd_insert.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_hd_insert.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_hd_query.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_hd_query.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_health.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_health.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_ole.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_ole.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_tab_fyr.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_tab_fyr.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_web_context_help.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_web_context_help.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higct.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higct.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higddue.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higddue.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higdisco.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higdisco.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higfav.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higfav.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higgis.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgis.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higgri.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgri.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higgri_disco.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgri_disco.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higgrirp.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgrirp.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT higpipe.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higpipe.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT mapviewer.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'mapviewer.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm0590.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm0590.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3_tab_naw.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_tab_naw.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3_tab_nex.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_tab_nex.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3_xmldtd.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_xmldtd.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3api.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3api_admin_unit.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_admin_unit.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3api_inv.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_inv.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3api_net.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_net.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3api_trans.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_trans.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3assert.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3assert.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3asset.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3asset_display.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset_display.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3asset_rep.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset_rep.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3asset_set.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset_set.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3audit.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3audit.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ausec.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ausec.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ausec_maint.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ausec_maint.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3clob.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3clob.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3close.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3close.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3context.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3context.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3dbms_job.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3dbms_job.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ddl.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ddl.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3debug.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3debug.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3del.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3del.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3disco.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3disco.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3eng_dynseg.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3eng_dynseg.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3event_log.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3event_log.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3extent.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3extent.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3extent_o.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3extent_o.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3extlov.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3extlov.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3file.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3file.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3flx.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3flx.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3gaz_qry.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3gaz_qry.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3get.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3get.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3get_gen.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3get_gen.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3globinv.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3globinv.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3group_inv.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3group_inv.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3homo.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3homo.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3homo_gis.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3homo_gis.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3homo_o.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3homo_o.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ins.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ins.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3nw_edit.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nw_edit.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_api_gen.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_api_gen.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_bau.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_bau.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_composite.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_composite.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_copy.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_copy.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_extent.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_extent.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_ft.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_ft.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_load.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_load.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_security.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_security.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_temp.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_temp.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_update.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_update.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_view.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_view.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_xattr.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_xattr.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_xattr_gen.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_xattr_gen.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3invband.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3invband.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3invval.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3invval.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3javautil.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3javautil.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3job.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3job.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3job_load.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3job_load.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3load.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3load.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3load_inv_failed.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3load_inv_failed.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3locator.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3locator.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3lock.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3lock.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3lock_gen.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3lock_gen.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3lrs.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3lrs.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mail.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mail.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mail_pop.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mail_pop.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mapcapture_ins_inv.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mapcapture_ins_inv.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mapcapture_int.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mapcapture_int.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3merge.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3merge.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg_output.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_output.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg_sdo.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_sdo.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg_security.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_security.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg_supplementary.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_supplementary.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg_toolkit.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_toolkit.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg_view.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_view.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mrg_wrap.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_wrap.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3net.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3net_api_gen.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_api_gen.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3net_load.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_load.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3net_o.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_o.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3nta.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nta.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3nwad.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nwad.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3nwval.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nwval.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3pbi.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3pbi.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3pedif.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3pedif.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3pla.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3pla.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3progress.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3progress.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3recal.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3recal.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3reclass.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3reclass.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3replace.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3replace.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3route_check.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3route_check.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3route_ref.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3route_ref.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3rsc.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3rsc.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3rsc_o.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3rsc_o.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3rvrs.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3rvrs.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sde.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sde.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdm.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdm.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_edit.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_edit.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_xml.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_xml.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3seq.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3seq.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3split.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3split.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3stats.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3stats.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3tab_varchar.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3tab_varchar.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3type.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3type.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3undo.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3undo.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3unit.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3unit.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3upload.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3upload.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3user.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3user.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3va.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3va.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web_apd.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_apd.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web_eng_dynseg.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_eng_dynseg.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web_fav.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_fav.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web_load.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_load.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web_mail.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_mail.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web_map.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_map.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3web_mrg.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_mrg.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3wrap.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3wrap.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3xml_load.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xml_load.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3xmlqry.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xmlqry.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3xsp.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xsp.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_debug.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_debug.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT run_gis.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'run_gis.pkw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT template.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'template.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3array.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3array.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3reports.pkw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3reports.pkw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3layer_tool.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3layer_tool.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3layer_tool.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3layer_tool.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT timer.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'timer.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_cncts.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_cncts.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ft_mapping.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ft_mapping.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm0575.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm0575.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mp_ref.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mp_ref.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mp_ref_o.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mp_ref_o.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3analytic_connectivity.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3analytic_connectivity.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3net_history.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_history.pkw' run_file
FROM dual 
/ 
start '&run_file'

--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3dbg.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3dbg.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sql.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sql.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3dynsql.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3dynsql.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3bulk_mrg.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3bulk_mrg.pkw' run_file
FROM dual 
/ 
start '&run_file'
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_composite2.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_composite2.pkw' run_file
FROM dual 
/ 
start '&run_file'
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3eng_dynseg_util.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3eng_dynseg_util.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_links.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_links.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_std_text.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_std_text.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3xml.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xml.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_gdo.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_gdo.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_check.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_check.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sde_check.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sde_check.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3msv_sec.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3msv_sec.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_geom.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_geom.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3data.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3data.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3jobs.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3jobs.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3_bulk_attrib_upd.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_bulk_attrib_upd.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3gaz_query_saved.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3gaz_query_saved.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_users_utility.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_users_utility.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT webutil_db.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'webutil_db.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ftp.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ftp.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3webutil.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3webutil.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_framework_utils.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_process_framework_utils.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_framework.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_process_framework.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_api.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_process_api.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_svr_util.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_svr_util.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_flex_attribute.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_flex_attribute.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_qry_builder.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_qry_builder.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_nav.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_nav.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_audit.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_audit.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_alert.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_alert.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_bundle_loader.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_bundle_loader.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_file_transfer_api.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_file_transfer_api.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_locations_api.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_locations_api.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3doc_files.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3doc_files.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3info_tool.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3info_tool.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_sdo_util.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_sdo_util.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3acl.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3acl.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_dynseg.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_dynseg.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_util.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_util.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3user_admin.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3user_admin.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_router_params_utils.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_router_params_utils.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT web_user_info.pkw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'web_user_info.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_ops.pkw	
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_ops.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig2520.pkw	
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig2520.pkw' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
--
-- New PACKAGE BODIES above here
--
SET term on


