-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm3trg.sql-arc   2.19   Jun 06 2011 09:42:30   Chris.Strettle  $
--       Module Name      : $Workfile:   nm3trg.sql  $
--       Date into PVCS   : $Date:   Jun 06 2011 09:42:30  $
--       Date fetched Out : $Modtime:   Jun 06 2011 09:28:16  $
--       PVCS Version     : $Revision:   2.19  $
--
--
--   Author : Graeme Johnson
--
--   Product install/upgrade script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------


SET echo OFF
col run_file new_value run_file noprint

SET TERM ON 
PROMPT doc_query_a_iu_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'doc_query_a_iu_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT financial_years_as_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'financial_years_as_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_directories_a_iud_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_directories_a_iud_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_directory_roles_a_iud_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_directory_roles_a_iud_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_user_roles_as_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_user_roles_as_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_user_roles_br_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_user_roles_br_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_user_roles_bs_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_user_roles_bs_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_users.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_users.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hig_users_a_upd_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_users_a_upd_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hol_b_u_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hol_b_u_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hop_instead_iud_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hop_instead_iud_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT hov_b_iu_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hov_b_iu_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT huol_b_u_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'huol_b_u_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT ins_nm_members.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'ins_nm_members.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT instantiate_user.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'instantiate_user.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT merge.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'merge.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nauall_attr_upd_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nauall_attr_upd_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm3sdm_dyn_seg_ex_b_row.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm3sdm_dyn_seg_ex_b_row.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_admin_units_all_as.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_admin_units_all_as.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_admin_units_all_br.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_admin_units_all_br.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_admin_units_all_bs.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_admin_units_all_bs.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_admin_units_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_admin_units_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_au_sub_types_as.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_au_sub_types_as.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_au_sub_types_br.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_au_sub_types_br.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_au_sub_types_bs.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_au_sub_types_bs.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_audit_when_bi.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_audit_when_bi.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_element_xrefs_aiu_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_element_xrefs_aiu_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_elements_all_a_u_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_elements_all_a_u_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_elements_all_au_check.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_elements_all_au_check.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_elements_all_del_mem_chk.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_elements_all_del_mem_chk.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_elements_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_elements_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_elements_trg.sql
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_elements_trg.sql' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_event_log_a_ins_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_event_log_a_ins_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_event_log_b_ins_row.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_event_log_b_ins_row.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_event_log_b_ins_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_event_log_b_ins_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_inv_link_all_biu_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_group_inv_link_all_biu_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_inv_link_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_group_inv_link_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_relations_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_group_relations_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_types_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_group_types_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_group_types_excl_nti.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_group_types_excl_nti.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_attri_lookup_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_attri_lookup_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_attri_lookup_b_iu_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_attri_lookup_b_iu_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_domains_all_b_u_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_domains_all_b_u_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_domains_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_domains_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_item_groupings_a_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_item_groupings_a_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--

--   AE/LS
--   Trigger dropped for 4053 release

--SET TERM ON 
--PROMPT nm_inv_items_all_a_dt_trg.trg
--SET TERM OFF
--SET DEFINE ON 
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_a_dt_trg.trg' run_file 
--FROM dual 
--/ 
--start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_au_val.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_au_val.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_b_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_b_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_del_mem_chk.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_del_mem_chk.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_excl_a_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_excl_a_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_excl_b_row.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_excl_b_row.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_excl_b_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_excl_b_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_role_sec.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_role_sec.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_sdo_b_upd.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_sdo_b_upd.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_sdo_b_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_sdo_b_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_sdo_a_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_sdo_a_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_xattr_a_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_xattr_a_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_xattr_b_row.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_xattr_b_row.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_all_xattr_b_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_all_xattr_b_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_items_jobs_b_ins_upd.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_items_jobs_b_ins_upd.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_nw_all_a_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_nw_all_a_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_nw_all_b_row.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_nw_all_b_row.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_nw_all_b_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_nw_all_b_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_nw_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_nw_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_attribs_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_attribs_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_attribs_as_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_attribs_as_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_attribs_b_iu_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_attribs_b_iu_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_attribs_bs_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_attribs_bs_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_attribs_excl_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_attribs_excl_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_groupings.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_groupings.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_groupings_a_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_groupings_a_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_groupings_role_sec.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_groupings_role_sec.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_type_validation_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_type_validation_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_types_all_a_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_types_all_a_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_types_all_b_row.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_types_all_b_row.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_types_all_b_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_types_all_b_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_types_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_types_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_types_all_role_sec.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_types_all_role_sec.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_inv_types_excl_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_inv_types_excl_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_job_control_b_ui_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_job_control_b_ui_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_job_op_data_value_b_iud_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_job_op_data_value_b_iud_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_job_operations_b_iud_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_job_operations_b_iud_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_batches_b_d_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_batches_b_d_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_dest_def_b_ui_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_dest_def_b_ui_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_destinations_b_ui_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_destinations_b_ui_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_file_col_dest_b_ui_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_file_col_dest_b_ui_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_file_cols_b_ui_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_file_cols_b_ui_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_file_dest_a_i_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_file_dest_a_i_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_files_b_ui_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_files_b_ui_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_load_files_del_nuf_cascade.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_load_files_del_nuf_cascade.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mail_pop_servers_v_inst_iud.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_mail_pop_servers_v_inst_iud.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_au_insert_check.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_au_insert_check.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_check_au_sec.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_check_au_sec.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_excl_a_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_excl_a_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_excl_b_row.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_excl_b_row.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_excl_b_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_excl_b_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_jobs_b_ins_upd.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_jobs_b_ins_upd.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_reset_au_check.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_reset_au_check.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_xattr_a_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_xattr_a_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_xattr_b_row.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_xattr_b_row.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_xattr_b_stm.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_xattr_b_stm.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_b_iu_end_slk_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_b_iu_end_slk_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_sdo_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_sdo_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_mrg_query_results_b_d_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_mrg_query_results_b_d_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_ngt_ins_nlt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_ngt_ins_nlt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_node_usages_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_node_usages_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nodes_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nodes_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nt_groupings_all_a_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nt_groupings_all_a_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nt_groupings_all_b_row.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nt_groupings_all_b_row.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nt_groupings_all_b_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nt_groupings_all_b_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nt_groupings_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nt_groupings_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_link_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_ad_link_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_link_as.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_ad_link_as.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_link_br.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_ad_link_br.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_types_as.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_ad_types_as.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_types_br.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_ad_types_br.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_xsp_validation_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_xsp_validation_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_operation_data_a_ins_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_operation_data_a_ins_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_operation_data_chk_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_operation_data_chk_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_points_sdo.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_points_sdo.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_points_sdo_row.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_points_sdo_row.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_theme_roles_as_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_theme_roles_as_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_theme_roles_br_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_theme_roles_br_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_theme_roles_bs_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_theme_roles_bs_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_themes_all_as_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_themes_all_as_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_themes_all_ai_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_themes_all_ai_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_themes_all_b_iu_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_themes_all_b_iu_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_themes_all_bs_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_themes_all_bs_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_type_columns_aiud_stm_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_type_columns_aiud_stm_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_type_columns_biud_row_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_type_columns_biud_row_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_type_columns_biud_stm_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_type_columns_biud_stm_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_type_inclusion_excl.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_type_inclusion_excl.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_type_layers_all_dt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_type_layers_all_dt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_types_ins_nlt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_types_ins_nlt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_user_aus_all_dt_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_user_aus_all_dt_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_x_location_rules_a_stm.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_x_location_rules_a_stm.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nmc_b_iu.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nmc_b_iu.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nmid_a_iu_stm_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nmid_a_iu_stm_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nmid_b_iu_row_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nmid_b_iu_row_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nmid_b_iu_stm_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nmid_b_iu_stm_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nmmr_b_i_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nmmr_b_i_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nmu_a_i_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nmu_a_i_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT node_point_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'node_point_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nsty_attr_upd_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nsty_attr_upd_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_load_elements_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'v_load_elements_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_members_d_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'v_nm_members_d_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT v_nm_members_i_trg.trg 
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'v_nm_members_i_trg.trg' run_file
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT who_trg.sql
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'who_trg.sql' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_types_del_nlt_trg_bs.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_types_del_nlt_trg_bs.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_types_del_nlt_trg_br.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_types_del_nlt_trg_br.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_types_del_nlt_trg_as.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_types_del_nlt_trg_as.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT doc_assocs_b_iu_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'doc_assocs_b_iu_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_link_all_bu_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_ad_link_all_bu_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_element_history_a_del.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_element_history_a_del.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_members_all_nw_edit_audit.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_members_all_nw_edit_audit.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
SET TERM ON 
PROMPT nm_nw_ad_link_whole_flag_trg.sql
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nw_ad_link_whole_flag_trg.sql' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--SET TERM ON 
--PROMPT user_sdo_maps_ins_trg.trg
--SET TERM OFF
--SET DEFINE ON 
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'user_sdo_maps_ins_trg.trg' run_file 
--FROM dual 
--/ 
--start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--SET TERM ON 
--PROMPT user_sdo_themes_ins_trg.trg
--SET TERM OFF
--SET DEFINE ON 
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'user_sdo_themes_ins_trg.trg' run_file 
--FROM dual 
--/ 
--start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--SET TERM ON 
--PROMPT user_sdo_styles_ins_trg.trg
--SET TERM OFF
--SET DEFINE ON 
--SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'user_sdo_styles_ins_trg.trg' run_file 
--FROM dual 
--/ 
--start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--
SET TERM ON 
PROMPT nm_gaz_query_b_upd.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_gaz_query_b_upd.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--
SET TERM ON 
PROMPT nm_gaz_query_b_ins.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_gaz_query_b_ins.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
----------------------------------------------------------------------------------------- 
--
--
SET TERM ON 
PROMPT nm_nt_gps_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_nt_gps_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT nm_ngr_ngt_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'nm_ngr_ngt_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hov_hol_length_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hov_hol_length_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hol_hov_length_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hol_hov_length_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT huo_huol_length_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'huo_huol_length_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT huol_huo_length_trg.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'huol_huo_length_trg.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_scheduling_frequencies_biu.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_scheduling_frequencies_biu.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_ftp_connections_b_ins_upd.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_ftp_connections_b_ins_upd.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT hig_hig_alert_recipients_a_ins.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'hig_alert_recipients_a_ins.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
SET TERM ON 
PROMPT doc_locations_b_upd_del_chk.trg
SET TERM OFF
SET DEFINE ON 
SELECT '&exor_base'||'nm3'||'&terminator'||'admin'||'&terminator'||'trg'||'&terminator'||'doc_locations_b_upd_del_chk.trg' run_file 
FROM dual 
/ 
start '&run_file' 
--
-----------------------------------------------------------------------------------------
--
-- new triggers above this
SET TERM ON
