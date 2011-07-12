-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3pkh.sql-arc   2.34   Jul 12 2011 14:12:18   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3pkh.sql  $
--       Date into PVCS   : $Date:   Jul 12 2011 14:12:18  $
--       Date fetched Out : $Modtime:   Jul 12 2011 13:44:44  $
--       PVCS Version     : $Revision:   2.34  $
--
--
--   Author : Graeme Johnson
--
--   Run on product install/upgrade
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------


SET echo OFF
col run_file new_value run_file noprint

--                                                                                                                                                                                                                                                        
-----------------------------------  PROCEDURES  -----------------------------------------                                                                                                                                                                
--                                                                                                                                                                                                                                                        
SET TERM ON                                                                                                                                                                                                                                               
PROMPT grant_role_to_user.prw                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'grant_role_to_user.prw' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'                                                                                                                                                                                                                                         

SET TERM ON                                                                                                                                                                                                                                               
PROMPT get_theme_srid.prw                                                                                                                                                                                                                             
SET TERM OFF                                                                                                                                                                                                                                              
SET DEFINE ON                                                                                                                                                                                                                                             
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'get_theme_srid.prw' run_file                                                                                                                                
FROM dual                                                                                                                                                                                                                                                 
/                                                                                                                                                                                                                                                         
start '&run_file'  


--
-- New PROCEDURES above here
--




--                                                                                                                                                                                                                                                        
-------------------------------------  FUNCTIONS -----------------------------------------                                                                                                                                                                
--                                                                                                                                                                                                                                                        
SET TERM ON
PROMPT chk_inv_type_valid_for_role.fnw                                                                                                                                                                                                                    
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'chk_inv_type_valid_for_role.fnw' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
--
SET TERM ON
PROMPT drop_layer.fnw 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'drop_layer.fnw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT get_dim_element.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'get_dim_element.fnw' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT get_error_string.fnw 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'get_error_string.fnw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT get_ne_length.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'get_ne_length.fnw' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT get_node_name.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'get_node_name.fnw' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT get_nt_type.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'get_nt_type.fnw' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT get_search_group_no.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'get_search_group_no.fnw' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT getcent.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'getcent.fnw' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT getx.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'getx.fnw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT gety.fnw
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'gety.fnw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT style_from_xml.fnw 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'style_from_xml.fnw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
--
SET TERM ON
PROMPT group_chunk_no_seq.fnw 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'group_chunk_no_seq.fnw' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
--
SET TERM ON
PROMPT group_hash_value.fnw 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'group_hash_value.fnw' run_file
FROM dual
/
start '&run_file'


--
-- New FUNCTIONS above here
--


-- 
-----------------------------------PACKAGE HEADERS------------------------------------- 
-- 
SET TERM ON
PROMPT colour.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'colour.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT dm3query.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'dm3query.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT doc.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT doc_api.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_api.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT exor_version.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'exor_version.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig2.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig2.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig3.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig3.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_directories_api.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_directories_api.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_hd_extract.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_hd_extract.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_hd_insert.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_hd_insert.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_hd_query.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_hd_query.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_health.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_health.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_ole.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_ole.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_tab_fyr.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_tab_fyr.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT hig_web_context_help.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_web_context_help.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higct.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higct.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higddue.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higddue.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higdisco.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higdisco.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higfav.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higfav.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higgis.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgis.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higgri.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgri.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higgri_disco.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgri_disco.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higgrirp.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higgrirp.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT higpipe.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'higpipe.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT mapviewer.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'mapviewer.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm0590.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm0590.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3_tab_naw.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_tab_naw.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3_tab_nex.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_tab_nex.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3_xmldtd.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_xmldtd.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3api.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3api_admin_unit.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_admin_unit.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3api_inv.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_inv.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3api_net.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_net.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3api_trans.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3api_trans.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3assert.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3assert.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3asset.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3asset_display.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset_display.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3asset_rep.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset_rep.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3asset_set.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3asset_set.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3audit.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3audit.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3ausec.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ausec.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3ausec_maint.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ausec_maint.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3clob.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3clob.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3close.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3close.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3context.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3context.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3dbms_job.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3dbms_job.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3ddl.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ddl.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3debug.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3debug.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3del.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3del.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3disco.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3disco.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3eng_dynseg.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3eng_dynseg.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3event_log.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3event_log.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3extent.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3extent.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3extent_o.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3extent_o.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3extlov.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3extlov.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3file.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3file.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3flx.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3flx.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3gaz_qry.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3gaz_qry.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3get.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3get.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3get_gen.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3get_gen.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3globinv.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3globinv.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3group_inv.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3group_inv.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3homo.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3homo.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3homo_gis.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3homo_gis.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3homo_o.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3homo_o.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3ins.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ins.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3nw_edit.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nw_edit.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_api_gen.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_api_gen.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_bau.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_bau.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_composite.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_composite.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_copy.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_copy.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_extent.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_extent.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_ft.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_ft.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_load.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_load.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_security.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_security.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_temp.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_temp.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_update.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_update.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_view.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_view.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_xattr.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_xattr.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3inv_xattr_gen.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_xattr_gen.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3invband.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3invband.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3invval.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3invval.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3java.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3java.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3javautil.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3javautil.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3job.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3job.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3job_load.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3job_load.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3load.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3load.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3load_inv_failed.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3load_inv_failed.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3locator.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3locator.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3lock.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3lock.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3lock_gen.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3lock_gen.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3lrs.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3lrs.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mail.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mail.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mail_pop.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mail_pop.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mapcapture_ins_inv.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mapcapture_ins_inv.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mapcapture_int.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mapcapture_int.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3merge.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3merge.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg_output.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_output.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg_sdo.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_sdo.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg_security.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_security.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg_supplementary.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_supplementary.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg_toolkit.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_toolkit.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg_view.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_view.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3mrg_wrap.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mrg_wrap.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3net.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3net_api_gen.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_api_gen.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3net_load.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_load.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3net_o.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_o.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3nta.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nta.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3nwad.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nwad.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3nwval.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3nwval.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3pbi.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3pbi.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3pedif.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3pedif.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3pla.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3pla.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3progress.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3progress.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3recal.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3recal.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3reclass.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3reclass.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3replace.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3replace.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3route_check.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3route_check.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3route_ref.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3route_ref.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3rsc.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3rsc.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3rsc_o.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3rsc_o.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3rvrs.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3rvrs.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3sde.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sde.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3sdm.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdm.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3sdo.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3sdo_edit.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_edit.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3sdo_xml.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_xml.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3seq.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3seq.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3split.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3split.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3stats.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3stats.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3tab_varchar.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3tab_varchar.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3type.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3type.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3undo.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3undo.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3unit.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3unit.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3upload.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3upload.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3user.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3user.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3va.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3va.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web_apd.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_apd.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web_eng_dynseg.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_eng_dynseg.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web_fav.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_fav.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web_load.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_load.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web_mail.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_mail.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web_map.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_map.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3web_mrg.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3web_mrg.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3wrap.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3wrap.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3xml_load.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xml_load.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3xmlqry.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xmlqry.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm3xsp.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xsp.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT nm_debug.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_debug.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT run_gis.pkh
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'run_gis.pkh' run_file 
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON
PROMPT template.pkh 
SET TERM OFF
SET DEFINE ON
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'template.pkh' run_file
FROM dual
/
start '&run_file'
-- 
----------------------------------------------------------------------------------------- 
-- 
SET TERM ON 
PROMPT nm3array.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3array.pkh' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3reports.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3reports.pkh' run_file
FROM dual 
/ 
start '&run_file' 
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_sdo_util.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_sdo_util.pkh' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3layer_tool.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3layer_tool.pkh' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT timer.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'timer.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_cncts.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm_cncts.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ft_mapping.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ft_mapping.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm0575.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm0575.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mp_ref.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mp_ref.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3mp_ref_o.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3mp_ref_o.pkh' run_file
FROM dual 
/ 
start '&run_file'
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3analytic_connectivity.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3analytic_connectivity.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3net_history.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3net_history.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3dbg.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3dbg.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm3sql.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sql.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3dynsql.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3dynsql.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3bulk_mrg.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3bulk_mrg.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3inv_composite2.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3inv_composite2.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3eng_dynseg_util.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3eng_dynseg_util.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_links.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_links.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_std_text.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_std_text.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3xml.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3xml.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_gdo.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_gdo.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_check.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_check.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sde_check.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sde_check.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3msv_sec.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3msv_sec.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_geom.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_geom.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3data.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3data.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3jobs.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3jobs.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3_bulk_attrib_upd.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3_bulk_attrib_upd.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3gaz_query_saved.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3gaz_query_saved.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_users_utility.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_users_utility.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT webutil_db.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'webutil_db.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3ftp.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3ftp.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3webutil.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3webutil.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_framework_utils.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_process_framework_utils.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_framework.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_process_framework.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_api.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_process_api.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_svr_util.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_svr_util.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_flex_attribute.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_flex_attribute.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_qry_builder.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_qry_builder.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_nav.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_nav.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_audit.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_audit.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_alert.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_alert.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_bundle_loader.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_bundle_loader.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_file_transfer_api.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'hig_file_transfer_api.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_locations_api.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'doc_locations_api.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3doc_files.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3doc_files.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3info_tool.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3info_tool.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3acl.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3acl.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_dynseg.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_dynseg.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdo_util.pkh
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'pck'||'&terminator'||'nm3sdo_util.pkh' run_file
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
-- New PACKAGE HEADERS above here
--

SET term on


