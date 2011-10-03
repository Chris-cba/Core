-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3views.sql	1.50 12/22/06
--       Module Name      : nm3views.sql
--       Date into SCCS   : 06/12/22 15:57:40
--       Date fetched Out : 07/06/13 17:08:24
--       SCCS Version     : 1.50
--
--
--   Author : Graeme Johnson
--
--   Product install/upgrade script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------


SET echo OFF
col run_file new_value run_file noprint


SET TERM ON 
PROMPT frm50_enabled_roles.sql
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'frm50_enabled_roles.sql' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT gis_theme_functions.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'gis_theme_functions.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT gis_theme_functions_all.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'gis_theme_functions_all.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT gis_theme_roles.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'gis_theme_roles.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT gis_themes.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'gis_themes.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT gis_themes_all.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'gis_themes_all.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_directories_read_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_directories_read_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_directories_v.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_directories_v.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_directories_write_v.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_directories_write_v.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_options.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_options.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_user_option_list_all.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_user_option_list_all.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hist_undo_views.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hist_undo_views.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_admin_units.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_admin_units.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_audit.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_audit.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_elements.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_elements.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_inv_link.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_group_inv_link.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_relations.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_group_relations.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_types.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_group_types.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_attri_lookup.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_attri_lookup.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_domains.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_domains.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_item_groupings.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_item_groupings.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_items.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_nw.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_nw.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_attribs.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_type_attribs.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_groupings.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_type_groupings.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_types.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_inv_types.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mail_pop_messages_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mail_pop_messages_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mail_pop_servers_v.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mail_pop_servers_v.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_members.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_default_query_types.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_default_query_types.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_output_file_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_output_file_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_query.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_query.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_query_executable.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_query_executable.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_query_results.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_query_results.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_query_types.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_query_types.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_section_inv_values.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_section_inv_values.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_sections.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_mrg_sections.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_node_usages.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_node_usages.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nodes.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_nodes.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nt_groupings.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_nt_groupings.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_link.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_nw_ad_link.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_route_nodes.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_route_nodes.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_route_nodes_o.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_route_nodes_o.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_type_layers.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_type_layers.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_user_aus.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_user_aus.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_xsp.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_xsp.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_distance_break.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_distance_break.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_elements.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_elements.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_inv_mem_ele_mp_ambig.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_inv_mem_ele_mp_ambig.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_inv_mem_ele_mp_excl.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_inv_mem_ele_mp_excl.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_inv_mem_ele_mp_true_amb.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_inv_mem_ele_mp_true_amb.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_inv_mem_ele_mp_true_exc.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_inv_mem_ele_mp_true_exc.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_inv_mem_on_element.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_inv_mem_on_element.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_point_inv_mem_on_ele.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_point_inv_mem_on_ele.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_rescale_route.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_rescale_route.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_reseq_route.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_reseq_route.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_module_keywords.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_module_keywords.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_element_history.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_element_history.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_gaz_query_item_list.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_gaz_query_item_list.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_ld_mc_all_inv_batches.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_ld_mc_all_inv_batches.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_mail_group_membership.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_mail_group_membership.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_members.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_members.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_user_au_modes.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_user_au_modes.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_node_points.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_node_points.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nse_datums.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nse_datums.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT vdat_nm_elements.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'vdat_nm_elements.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT vnm_assets_on_route.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'vnm_assets_on_route.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT vnm_linear_types.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'vnm_linear_types.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT vnm_x_location_rules.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'vnm_x_location_rules.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT vus_nm_elements.vw 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'vus_nm_elements.vw' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT xsp_restraints.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'xsp_restraints.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT xsp_reversal.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'xsp_reversal.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_msv_map_def.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_msv_map_def.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_msv_maps.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_msv_maps.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_msv_theme_def.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_msv_theme_def.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_msv_themes.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_msv_themes.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_net_themes_all.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_net_themes_all.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_net_themes.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_net_themes.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_address_point_as_address.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_address_point_as_address.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_hig_agency_code.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_hig_agency_code.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_resize_route.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_resize_route.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_locate_inv_by_ref.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_locate_inv_by_ref.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_ft_attribute_mapping.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_ft_attribute_mapping.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_sql_context.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_sql_context.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_inv_mem_on_element_xy.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_load_inv_mem_on_element_xy.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_std_text_modules.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_std_text_modules.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_reserve_words_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_reserve_words_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_user_details_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_user_details_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_attrib_view_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_attrib_view_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_elements_view_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_elements_view_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_datum_route_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_datum_route_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--
SET TERM ON 
PROMPT v_nm_gaz_query_saved_all.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_gaz_query_saved_all.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_gaz_query_saved.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_gaz_query_saved.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_gaz_query_attribs_saved.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_gaz_query_attribs_saved.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_candidate_process_types_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_candidate_process_types_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_processes_all_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_processes_all_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_processes_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_processes_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_files_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_files_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_job_runs_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_job_runs_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_log_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_log_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_types_restricted_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_types_restricted_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_types_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_types_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_type_frequencies_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_type_frequencies_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_type_users_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_type_users_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_scheduling_frequencies_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_scheduling_frequencies_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_scheduling_intervals_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_scheduling_intervals_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_doc_documents.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_doc_documents.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_audits_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_audits_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_alert_manager_logs_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_alert_manager_logs_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_bundles_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'doc_bundles_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_bundle_files_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'doc_bundle_files_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_bundle_file_relations_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'doc_bundle_file_relations_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_file_transfer_log_latest_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_file_transfer_log_latest_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_file_transfer_details.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_file_transfer_details.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_file_transfer_batch.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_file_transfer_batch.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_upgrade_vw.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_upgrade_vw.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_user_admin_units.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_user_admin_units.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_polled_conns_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_polled_conns_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_process_conns_by_area_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'hig_process_conns_by_area_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_theme_details_v.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'nm_theme_details_v.vw' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_rebuild_all_inv_sdo_join.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_rebuild_all_inv_sdo_join.vw' run_file 
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_rebuild_all_nat_sdo_join.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_rebuild_all_nat_sdo_join.vw' run_file 
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_rebuild_all_nlt_sdo_join.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_rebuild_all_nlt_sdo_join.vw' run_file 
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_hig_users.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_hig_users.vw' run_file 
FROM dual 
/ 
start '&run_file'
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_hig1832_user_ts_rg.vw
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'views'||'&terminator'||'v_nm_hig1832_user_ts_rg.vw' run_file 
FROM dual 
/ 
start '&run_file'


