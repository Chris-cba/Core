--
-- GRI Metadata for the Kentucky inv on route voiew generation
--
-- sccs_id := '"@(#)xky_inv_views_metadata.sql	1.1 06/03/05"'
--


INSERT INTO HIG_MODULES ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'XKY_IA', 'Create All KY inv on route views', 'xky_inv_views', 'EXE', NULL, 'N', 'Y'
, 'NET', NULL); 
INSERT INTO HIG_MODULES ( hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_opts,
hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu ) VALUES ( 
'XKY_IV', 'Create KY inv on route views', 'xky_inv_views', 'EXE', NULL, 'N', 'Y', 'NET'
, NULL); 
COMMIT;


INSERT INTO GRI_MODULES ( grm_module, grm_module_type, grm_module_path, grm_file_type, grm_tag_flag,
grm_tag_table, grm_tag_column, grm_tag_where, grm_linesize, grm_pagesize,
grm_pre_process ) VALUES ( 
'XKY_IA', 'N/A', 'c:\exor\bin', 'lis', 'N', NULL, NULL, NULL, 80, 50, NULL); 
INSERT INTO GRI_MODULES ( grm_module, grm_module_type, grm_module_path, grm_file_type, grm_tag_flag,
grm_tag_table, grm_tag_column, grm_tag_where, grm_linesize, grm_pagesize,
grm_pre_process ) VALUES ( 
'XKY_IV', 'N/A', 'c:\exor\bin', 'lis', 'N', NULL, NULL, NULL, 80, 50, 'xky_inv_views.cre_view_and_synonym(pi_nit_inv_type =>  :P_INV_TYPES, pi_cre_synonym => :ANSWER)'); 
COMMIT;

INSERT INTO GRI_PARAMS ( gp_param, gp_param_type, gp_table, gp_column, gp_descr_column,
gp_shown_column, gp_shown_type, gp_descr_type, gp_order, gp_case,
gp_gaz_restriction ) VALUES ( 
'ANSWER2', 'CHAR', 'GRI_PARAM_LOOKUP', 'GPL_VALUE', 'GPL_DESCR', 'GPL_VALUE', 'CHAR'
, NULL, NULL, NULL, NULL); 
INSERT INTO GRI_PARAMS ( gp_param, gp_param_type, gp_table, gp_column, gp_descr_column,
gp_shown_column, gp_shown_type, gp_descr_type, gp_order, gp_case,
gp_gaz_restriction ) VALUES ( 
'P_INV_TYPES', 'CHAR', 'NM_INV_TYPES', 'NIT_INV_TYPE', 'NIT_DESCR', 'NIT_INV_TYPE'
, 'CHAR', 'CHAR', NULL, NULL, NULL); 
COMMIT;



INSERT INTO GRI_MODULE_PARAMS ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XKY_IA', 'ANSWER', 1, 'All Asset Types', 'Y', 1, 'GPL_PARAM = ''ANSWER''', 'N', NULL
, 'GRI_PARAM_LOOKUP', 'GPL_VALUE', 'GPL_PARAM = ''ANSWER'' AND GPL_VALUE = ''Y'''
, 'Y', 'N', 'Y', NULL, 'N', NULL, 'N', NULL, NULL, NULL); 
INSERT INTO GRI_MODULE_PARAMS ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XKY_IA', 'ANSWER2', 1, 'Create Synonyms', 'Y', 1, 'GPL_PARAM=''ANSWER''', 'N', NULL
, 'GRI_PARAM_LOOKUP', 'GPL_VALUE', 'GPL_PARAM = ''ANSWER'' AND GPL_VALUE = ''N'''
, 'Y', 'N', 'Y', NULL, 'N', NULL, 'N', NULL, NULL, NULL); 
INSERT INTO GRI_MODULE_PARAMS ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XKY_IV', 'ANSWER', 2, 'Create Synonym for asset type', 'Y', 1, 'GPL_PARAM = ''ANSWER'''
, 'N', NULL, 'GRI_PARAM_LOOKUP', 'GPL_VALUE', 'GPL_PARAM = ''ANSWER'' AND GPL_VALUE = ''Y'''
, 'Y', 'N', 'Y', NULL, 'N', 'Select from list', 'N', NULL, NULL, NULL); 
INSERT INTO GRI_MODULE_PARAMS ( gmp_module, gmp_param, gmp_seq, gmp_param_descr, gmp_mandatory,
gmp_no_allowed, gmp_where, gmp_tag_restriction, gmp_tag_where, gmp_default_table,
gmp_default_column, gmp_default_where, gmp_visible, gmp_gazetteer, gmp_lov, gmp_val_global,
gmp_wildcard, gmp_hint_text, gmp_allow_partial, gmp_base_table, gmp_base_table_column,
gmp_operator ) VALUES ( 
'XKY_IV', 'P_INV_TYPES', 1, 'Enter the asset type', 'Y', 1, NULL, 'N', NULL, NULL
, NULL, NULL, 'Y', 'N', 'Y', NULL, 'N', 'Enter the asset type to create a view for'
, 'N', NULL, NULL, NULL); 
COMMIT;


