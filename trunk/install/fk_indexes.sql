--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/fk_indexes.sql-arc   2.1   Jul 04 2013 13:45:30   James.Wadsworth  $
--       Module Name      : $Workfile:   fk_indexes.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:00:10  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
-- '@(#)fk_indexes.sql	1.1 04/18/01'
SET FEEDBACK OFF
--
PROMPT Creating FK indexes for ACC_ATTR_BANDS
--
CREATE INDEX aab_fk_aat_ind ON acc_attr_bands
(aab_aat_id                     -- aab_fk_aat_ind
);
--
--
PROMPT Creating FK indexes for ACC_ATTR_GROUPS
--
CREATE INDEX aag_fk_ait_ind ON acc_attr_groups
(aag_ait_id                     -- aag_fk_ait_ind
);
--
CREATE INDEX aag_fk_hus_ind ON acc_attr_groups
(aag_peo_person_id              -- aag_fk_hus_ind
);
--
--
PROMPT Creating FK indexes for ACC_ATTR_LOOKUP
--
CREATE INDEX aal_fk_aad_ind ON acc_attr_lookup
(aal_aad_id                     -- aal_fk_aad_ind
);
--
--
PROMPT Creating FK indexes for ACC_ATTR_MEMBS
--
CREATE INDEX aam_fk_aag_ind ON acc_attr_membs
(aam_aag_id                     -- aam_fk_aag_ind
);
--
CREATE INDEX aam_fk_aav_ind ON acc_attr_membs
(aam_ait_id                     -- aam_fk_aav_ind
,aam_aat_id                     -- aam_fk_aav_ind
);
--
--
PROMPT Creating FK indexes for ACC_ATTR_TYPES
--
CREATE INDEX aat_fk_aad_ind ON acc_attr_types
(aat_aad_id                     -- aat_fk_aad_ind
);
--
--
PROMPT Creating FK indexes for ACC_ATTR_VALID
--
CREATE INDEX aav_fk_aat_ind ON acc_attr_valid
(aav_aat_id                     -- aav_fk_aat_ind
);
--
CREATE INDEX aav_fk_ait_ind ON acc_attr_valid
(aav_ait_id                     -- aav_fk_ait_ind
);
--
--
PROMPT Creating FK indexes for ACC_BATCH_FILES
--
CREATE INDEX abf_fk_alb_ind ON acc_batch_files
(abf_alb_id                     -- abf_fk_alb_ind
);
--
CREATE INDEX abf_fk_alf_ind ON acc_batch_files
(abf_alf_file_id                -- abf_fk_alf_ind
);
--
--
PROMPT Creating FK indexes for ACC_FACTOR_GRID
--
CREATE INDEX afg_fk_aag_ind ON acc_factor_grid
(aag_id                         -- afg_fk_aag_ind
);
--
CREATE INDEX afg_fk_agr_ind ON acc_factor_grid
(site_id                        -- afg_fk_agr_ind
);
--
--
PROMPT Creating FK indexes for ACC_FACTOR_GRID_ATTR
--
CREATE INDEX afga_fk_afg_ind ON acc_factor_grid_attr
(grid_id                        -- afga_fk_afg_ind
);
--
--
PROMPT Creating FK indexes for ACC_FACTOR_GRID_HEADER
--
CREATE INDEX afgh_fk_afg_ind ON acc_factor_grid_header
(grid_id                        -- afgh_fk_afg_ind
);
--
--
PROMPT Creating FK indexes for ACC_FACTOR_GRID_PAGE
--
CREATE INDEX afgp_fk_afgh_ind ON acc_factor_grid_page
(grid_id                        -- afgp_fk_afgh_ind
,page_no                        -- afgp_fk_afgh_ind
);
--
--
PROMPT Creating FK indexes for ACC_GROUPS
--
CREATE INDEX agr_fk_agr_ind ON acc_groups
(agr_agr_id                     -- agr_fk_agr_ind
);
--
CREATE INDEX agr_fk_alb_ind ON acc_groups
(agr_alb_id                     -- agr_fk_alb_ind
);
--
CREATE INDEX agr_fk_hus_ind ON acc_groups
(agr_peo_person_id              -- agr_fk_hus_ind
);
--
CREATE INDEX agr_fk_qry_ind ON acc_groups
(agr_pbi_query_id               -- agr_fk_qry_ind
);
--
--
PROMPT Creating FK indexes for ACC_GROUP_ACCIDENTS
--
CREATE INDEX aga_fk_acc_ind ON acc_group_accidents
(aga_acc_id                     -- aga_fk_acc_ind
);
--
CREATE INDEX aga_fk_agr_ind ON acc_group_accidents
(aga_agr_id                     -- aga_fk_agr_ind
);
--
--
PROMPT Creating FK indexes for ACC_GROUP_BS_DATES
--
CREATE INDEX agb_fk_agr_ind ON acc_group_bs_dates
(agb_agr_id                     -- agb_fk_agr_ind
);
--
--
PROMPT Creating FK indexes for ACC_GROUP_MATRIX
--
CREATE INDEX agm_fk_aav_1_ind ON acc_group_matrix
(agm_ait_id_1                   -- agm_fk_aav_1_ind
,agm_aat_id_1                   -- agm_fk_aav_1_ind
);
--
CREATE INDEX agm_fk_agr_ind ON acc_group_matrix
(agm_agr_id                     -- agm_fk_agr_ind
);
--
--
PROMPT Creating FK indexes for ACC_ITEMS_ALL
--
CREATE INDEX acc_fk_ai_ind ON acc_items_all
(acc_ai_id                      -- acc_fk_ai_ind
);
--
CREATE INDEX acc_fk_ait_ind ON acc_items_all
(acc_ait_id                     -- acc_fk_ait_ind
);
--
CREATE INDEX acc_fk_alb_ind ON acc_items_all
(acc_last_alb_id                -- acc_fk_alb_ind
);
--
CREATE INDEX acc_fk_parent_ind ON acc_items_all
(acc_parent_id                  -- acc_fk_parent_ind
);
--
CREATE INDEX acc_fk_top_ind ON acc_items_all
(acc_top_id                     -- acc_fk_top_ind
);
--
--
PROMPT Creating FK indexes for ACC_ITEMS_ALL_LOAD
--
CREATE INDEX accl_fk_acc_ind ON acc_items_all_load
(acc_acc_id                     -- accl_fk_acc_ind
);
--
CREATE INDEX accl_fk_ai_ind ON acc_items_all_load
(acc_ai_id                      -- accl_fk_ai_ind
);
--
CREATE INDEX accl_fk_ait_ind ON acc_items_all_load
(acc_ait_id                     -- accl_fk_ait_ind
);
--
CREATE INDEX accl_fk_alb_ind ON acc_items_all_load
(acc_alb_id                     -- accl_fk_alb_ind
);
--
--
PROMPT Creating FK indexes for ACC_ITEM_ATTR
--
CREATE INDEX aia_fk_aav_ind ON acc_item_attr
(aia_ait_id                     -- aia_fk_aav_ind
,aia_aat_id                     -- aia_fk_aav_ind
);
--
CREATE INDEX aia_fk_acc_ind ON acc_item_attr
(aia_acc_id                     -- aia_fk_acc_ind
);
--
--
PROMPT Creating FK indexes for ACC_ITEM_ATTR_LOAD
--
CREATE INDEX aial_fk_aav_ind ON acc_item_attr_load
(aia_ait_id                     -- aial_fk_aav_ind
,aia_aat_id                     -- aial_fk_aav_ind
);
--
--
PROMPT Creating FK indexes for ACC_LOAD_BATCHES
--
CREATE INDEX alb_fk_hus_ind ON acc_load_batches
(alb_peo_person_id              -- alb_fk_hus_ind
);
--
--
PROMPT Creating FK indexes for ACC_LOAD_DECODE
--
CREATE INDEX ald_fk_alr_ind ON acc_load_decode
(ald_alr_rule_id                -- ald_fk_alr_ind
);
--
--
PROMPT Creating FK indexes for ACC_LOAD_RECORD_TYPES
--
CREATE INDEX alrt_fk_alf_ind ON acc_load_record_types
(alt_alf_file_id                -- alrt_fk_alf_ind
);
--
--
PROMPT Creating FK indexes for ACC_LOAD_RULES
--
CREATE INDEX alr_fk_aav_ind ON acc_load_rules
(alr_ait_id                     -- alr_fk_aav_ind
,alr_aat_id                     -- alr_fk_aav_ind
);
--
CREATE INDEX alr_fk_alrt_ind ON acc_load_rules
(alr_alf_file_id                -- alr_fk_alrt_ind
,alr_alt_record_id              -- alr_fk_alrt_ind
);
--
--
PROMPT Creating FK indexes for ACC_PBI_QUERY
--
CREATE INDEX qry_fk_hus_ind ON acc_pbi_query
(qry_peo_person_id              -- qry_fk_hus_ind
);
--
--
PROMPT Creating FK indexes for ACC_PBI_SQL
--
CREATE INDEX pbs_fk_pbi_ind ON acc_pbi_sql
(pbs_qry_id                     -- pbs_fk_pbi_ind
);
--
--
PROMPT Creating FK indexes for ACC_QRY_CRITERIA
--
CREATE INDEX aqc_fk_qry_ind ON acc_qry_criteria
(aqc_qry_id                     -- aqc_fk_qry_ind
);
--
--
PROMPT Creating FK indexes for ACC_SITE_PARAMETERS
--
CREATE INDEX asp_fk_ast_ind ON acc_site_parameters
(asp_site_type                  -- asp_fk_ast_ind
);
--
CREATE INDEX asp_fk_hus_ind ON acc_site_parameters
(asp_peo_person_id              -- asp_fk_hus_ind
);
--
--
PROMPT Creating FK indexes for ACC_SITE_THRESHOLDS
--
CREATE INDEX ath_fk_ast_ind ON acc_site_thresholds
(site_type                      -- ath_fk_ast_ind
);
--
--
PROMPT Creating FK indexes for ACC_VALID_DEP
--
CREATE INDEX avd_fk_aav_ind ON acc_valid_dep
(avd_ait_id                     -- avd_fk_aav_ind
,avd_aat_id                     -- avd_fk_aav_ind
);
--
--
PROMPT Creating FK indexes for ACC_VALID_DEP_VALUES
--
CREATE INDEX adv_fk_avi_ind ON acc_valid_dep_values
(adv_avd_ait_id                 -- adv_fk_avi_ind
,adv_avd_aat_id                 -- adv_fk_avi_ind
,adv_avi_ait_id                 -- adv_fk_avi_ind
,adv_avi_aat_id                 -- adv_fk_avi_ind
,adv_aiv_i_value                -- adv_fk_avi_ind
);
--
--
PROMPT Creating FK indexes for ACC_VALID_INDEP
--
CREATE INDEX avi_fk_aav_ind ON acc_valid_indep
(avi_ait_id                     -- avi_fk_aav_ind
,avi_aat_id                     -- avi_fk_aav_ind
);
--
CREATE INDEX avi_fk_avd_ind ON acc_valid_indep
(avi_avd_ait_id                 -- avi_fk_avd_ind
,avi_avd_aat_id                 -- avi_fk_avd_ind
);
--
--
PROMPT Creating FK indexes for ACC_VALID_INDEP_VALUES
--
CREATE INDEX aiv_fk_avi_ind ON acc_valid_indep_values
(aiv_avd_ait_id                 -- aiv_fk_avi_ind
,aiv_avd_aat_id                 -- aiv_fk_avi_ind
,aiv_avi_ait_id                 -- aiv_fk_avi_ind
,aiv_avi_aat_id                 -- aiv_fk_avi_ind
);
--
--
PROMPT Creating FK indexes for ACC_VALID_SQL
--
CREATE INDEX avs1_fk_aav_ind ON acc_valid_sql
(avs_d_ait_id                   -- avs1_fk_aav_ind
,avs_d_aat_id                   -- avs1_fk_aav_ind
);
--
CREATE INDEX avs2_fk_aav_ind ON acc_valid_sql
(avs_i_ait_id                   -- avs2_fk_aav_ind
,avs_i_aat_id                   -- avs2_fk_aav_ind
);
--
CREATE INDEX avs_fk_avd_ind ON acc_valid_sql
(avs_d_ait_id                   -- avs_fk_avd_ind
,avs_d_aat_id                   -- avs_fk_avd_ind
);
--
--
PROMPT Creating FK indexes for DOCS
--
CREATE INDEX doc_fk_dlc_ind ON docs
(doc_dlc_id                     -- doc_fk_dlc_ind
);
--
CREATE INDEX doc_fk_dmd_ind ON docs
(doc_dlc_dmd_id                 -- doc_fk_dmd_ind
);
--
CREATE INDEX doc_fk_dtp_ind ON docs
(doc_dtp_code                   -- doc_fk_dtp_ind
);
--
CREATE INDEX doc_fk_hau_ind ON docs
(doc_admin_unit                 -- doc_fk_hau_ind
);
--
CREATE INDEX doc_fk_hus1_ind ON docs
(doc_user_id                    -- doc_fk_hus1_ind
);
--
CREATE INDEX doc_fk_hus2_ind ON docs
(doc_compl_user_id              -- doc_fk_hus2_ind
);
--
--
PROMPT Creating FK indexes for DOC_ASSOCS
--
CREATE INDEX das_fk_dgt_ind ON doc_assocs
(das_table_name                 -- das_fk_dgt_ind
);
--
CREATE INDEX das_fk_doc_ind ON doc_assocs
(das_doc_id                     -- das_fk_doc_ind
);
--
--
PROMPT Creating FK indexes for DOC_CLASS
--
CREATE INDEX dcl_fk_dtp_ind ON doc_class
(dcl_dtp_code                   -- dcl_fk_dtp_ind
);
--
--
PROMPT Creating FK indexes for DOC_COPIES
--
CREATE INDEX dcp_fk_doc_ind ON doc_copies
(dcp_doc_id                     -- dcp_fk_doc_ind
);
--
--
PROMPT Creating FK indexes for DOC_DAMAGE
--
CREATE INDEX ddg_fk_doc_ind ON doc_damage
(ddg_doc_id                     -- ddg_fk_doc_ind
);
--
--
PROMPT Creating FK indexes for DOC_DAMAGE_COSTS
--
CREATE INDEX ddc_fk_ddg_ind ON doc_damage_costs
(ddc_ddg_id                     -- ddc_fk_ddg_ind
);
--
--
PROMPT Creating FK indexes for DOC_ENQUIRY_CONTACTS
--
CREATE INDEX dec_fk_doc_ind ON doc_enquiry_contacts
(dec_doc_id                     -- dec_fk_doc_ind
);
--
CREATE INDEX dec_fk_hct_ind ON doc_enquiry_contacts
(dec_hct_id                     -- dec_fk_hct_ind
);
--
--
PROMPT Creating FK indexes for DOC_ENQUIRY_TYPES
--
CREATE INDEX det_fk_dtp_ind ON doc_enquiry_types
(det_dtp_code                   -- det_fk_dtp_ind
);
--
--
PROMPT Creating FK indexes for DOC_GATE_SYNS
--
CREATE INDEX dgs_fk_dgt_ind ON doc_gate_syns
(dgs_dgt_table_name             -- dgs_fk_dgt_ind
);
--
--
PROMPT Creating FK indexes for DOC_KEYS
--
CREATE INDEX dky_fk_dkw_ind ON doc_keys
(dky_dkw_key_id                 -- dky_fk_dkw_ind
);
--
CREATE INDEX dky_fk_doc_ind ON doc_keys
(dky_doc_id                     -- dky_fk_doc_ind
);
--
--
PROMPT Creating FK indexes for DOC_LOCATIONS
--
CREATE INDEX dlc_fk_dmd_ind ON doc_locations
(dlc_dmd_id                     -- dlc_fk_dmd_ind
);
--
--
PROMPT Creating FK indexes for DOC_STD_ACTIONS
--
CREATE INDEX dsa_fk_dtp_ind ON doc_std_actions
(dsa_dtp_code                   -- dsa_fk_dtp_ind
);
--
--
PROMPT Creating FK indexes for DOC_SYNONYMS
--
CREATE INDEX dsy_fk_dkw_ind ON doc_synonyms
(dsy_dkw_key_id                 -- dsy_fk_dkw_ind
);
--
--
PROMPT Creating FK indexes for DOC_TEMPLATE_COLUMNS
--
CREATE INDEX dtc_fk_dtg_ind ON doc_template_columns
(dtc_template_name              -- dtc_fk_dtg_ind
);
--
--
PROMPT Creating FK indexes for DOC_TEMPLATE_GATEWAYS
--
CREATE INDEX dtg_fk_dgt_ind ON doc_template_gateways
(dtg_table_name                 -- dtg_fk_dgt_ind
);
--
CREATE INDEX dtg_fk_dlc_ind ON doc_template_gateways
(dtg_dlc_id                     -- dtg_fk_dlc_ind
);
--
CREATE INDEX dtg_fk_dmd_ind ON doc_template_gateways
(dtg_dmd_id                     -- dtg_fk_dmd_ind
);
--
--
PROMPT Creating FK indexes for DOC_TEMPLATE_USERS
--
CREATE INDEX dtu_fk_dtg_ind ON doc_template_users
(dtu_template_name              -- dtu_fk_dtg_ind
);
--
CREATE INDEX dtu_fk_dtp_ind ON doc_template_users
(dtu_default_report_type        -- dtu_fk_dtp_ind
);
--
CREATE INDEX dtu_fk_hus_ind ON doc_template_users
(dtu_user_id                    -- dtu_fk_hus_ind
);
--
--
PROMPT Creating FK indexes for EXOR_DICT_SNAPSHOT_EXTRA_COLS
--
CREATE INDEX exor_dict_snapshot_ext_col_ind ON exor_dict_snapshot_extra_cols
(object_name                    -- exor_dict_snapshot_ext_col_ind
,extension                      -- exor_dict_snapshot_ext_col_ind
);
--
--
PROMPT Creating FK indexes for EXOR_DICT_SNAPSHOT_OBJ_COLS
--
CREATE INDEX exor_dict_snapshot_obj_col_ind ON exor_dict_snapshot_obj_cols
(object_name                    -- exor_dict_snapshot_obj_col_ind
,extension                      -- exor_dict_snapshot_obj_col_ind
);
--
--
PROMPT Creating FK indexes for GIS_THEME_ROLES
--
CREATE INDEX gthr_fk_hro_ind ON gis_theme_roles
(gthr_role                      -- gthr_fk_hro_ind
);
--
--
PROMPT Creating FK indexes for GRI_MODULES
--
CREATE INDEX grm_fk_hmo_ind ON gri_modules
(grm_module                     -- grm_fk_hmo_ind
);
--
--
PROMPT Creating FK indexes for GRI_MODULE_PARAMS
--
CREATE INDEX gmp_fk_gp_ind ON gri_module_params
(gmp_param                      -- gmp_fk_gp_ind
);
--
CREATE INDEX gmp_fk_grm_ind ON gri_module_params
(gmp_module                     -- gmp_fk_grm_ind
);
--
--
PROMPT Creating FK indexes for GRI_PARAM_DEPENDENCIES
--
CREATE INDEX gpd_fk_gmp1_ind ON gri_param_dependencies
(gpd_module                     -- gpd_fk_gmp1_ind
,gpd_dep_param                  -- gpd_fk_gmp1_ind
);
--
CREATE INDEX gpd_fk_gmp2_ind ON gri_param_dependencies
(gpd_module                     -- gpd_fk_gmp2_ind
,gpd_indep_param                -- gpd_fk_gmp2_ind
);
--
--
PROMPT Creating FK indexes for GRI_PARAM_LOOKUP
--
CREATE INDEX gpl_fk_gp_ind ON gri_param_lookup
(gpl_param                      -- gpl_fk_gp_ind
);
--
--
PROMPT Creating FK indexes for GRI_RUN_PARAMETERS
--
CREATE INDEX grp_fk_grr_ind ON gri_run_parameters
(grp_job_id                     -- grp_fk_grr_ind
);
--
--
PROMPT Creating FK indexes for GRI_SAVED_PARAMS
--
CREATE INDEX gsp_fk_gss_ind ON gri_saved_params
(gsp_gss_id                     -- gsp_fk_gss_ind
);
--
--
PROMPT Creating FK indexes for GRI_SAVED_SETS
--
CREATE INDEX gss_fk_grm_ind ON gri_saved_sets
(gss_module                     -- gss_fk_grm_ind
);
--
--
PROMPT Creating FK indexes for HIG_CODES
--
CREATE INDEX hco_fk_hdo_ind ON hig_codes
(hco_domain                     -- hco_fk_hdo_ind
);
--
--
PROMPT Creating FK indexes for HIG_CONTACT_ADDRESS
--
CREATE INDEX hca_fk_had_ind ON hig_contact_address
(hca_had_id                     -- hca_fk_had_ind
);
--
CREATE INDEX hca_fk_hct_ind ON hig_contact_address
(hca_hct_id                     -- hca_fk_hct_ind
);
--
--
PROMPT Creating FK indexes for HIG_DOMAINS
--
CREATE INDEX hdo_fk_hpr_ind ON hig_domains
(hdo_product                    -- hdo_fk_hpr_ind
);
--
--
PROMPT Creating FK indexes for HIG_ERRORS
--
CREATE INDEX her_fk_hpr_ind ON hig_errors
(her_appl                       -- her_fk_hpr_ind
);
--
--
PROMPT Creating FK indexes for HIG_MODULE_HISTORY
--
CREATE INDEX hmh_hus_fk_ind ON hig_module_history
(hmh_user_id                    -- hmh_hus_fk_ind
);
--
--
PROMPT Creating FK indexes for HIG_MODULE_KEYWORDS
--
CREATE INDEX hmk_hmo_fk_ind ON hig_module_keywords
(hmk_hmo_module                 -- hmk_hmo_fk_ind
);
--
--
PROMPT Creating FK indexes for HIG_MODULE_ROLES
--
CREATE INDEX hmr_hmo_fk_ind ON hig_module_roles
(hmr_module                     -- hmr_hmo_fk_ind
);
--
CREATE INDEX hmr_hro_fk_ind ON hig_module_roles
(hmr_role                       -- hmr_hro_fk_ind
);
--
--
PROMPT Creating FK indexes for HIG_MODULE_USAGES
--
CREATE INDEX hmu_hmo_fk_ind ON hig_module_usages
(hmu_module                     -- hmu_hmo_fk_ind
);
--
--
PROMPT Creating FK indexes for HIG_OPTIONS
--
CREATE INDEX hop_fk_hpr_ind ON hig_options
(hop_product                    -- hop_fk_hpr_ind
);
--
--
PROMPT Creating FK indexes for HIG_ROLES
--
CREATE INDEX hro_hpr_fk_ind ON hig_roles
(hro_product                    -- hro_hpr_fk_ind
);
--
--
PROMPT Creating FK indexes for HIG_STATUS_CODES
--
CREATE INDEX hsc_fk_hsd_ind ON hig_status_codes
(hsc_domain_code                -- hsc_fk_hsd_ind
);
--
--
PROMPT Creating FK indexes for HIG_STATUS_DOMAINS
--
CREATE INDEX hsd_fk_hpr_ind ON hig_status_domains
(hsd_product                    -- hsd_fk_hpr_ind
);
--
--
PROMPT Creating FK indexes for HIG_UPGRADES
--
CREATE INDEX hup_fk_hpr_ind ON hig_upgrades
(hup_product                    -- hup_fk_hpr_ind
);
--
--
PROMPT Creating FK indexes for HIG_USER_FAVOURITES
--
CREATE INDEX huf_hus_fk_ind ON hig_user_favourites
(huf_user_id                    -- huf_hus_fk_ind
);
--
--
PROMPT Creating FK indexes for HIG_USER_HISTORY
--
CREATE INDEX huh_hus_fk_ind ON hig_user_history
(huh_user_id                    -- huh_hus_fk_ind
);
--
--
PROMPT Creating FK indexes for HIG_USER_OPTIONS
--
CREATE INDEX huo_fk_hus_ind ON hig_user_options
(huo_hus_user_id                -- huo_fk_hus_ind
);
--
--
PROMPT Creating FK indexes for HIG_USER_ROLES
--
CREATE INDEX hur_hro_fk_ind ON hig_user_roles
(hur_role                       -- hur_hro_fk_ind
);
--
CREATE INDEX hur_hus_fk_ind ON hig_user_roles
(hur_username                   -- hur_hus_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_ADMIN_GROUPS
--
CREATE INDEX hag_fk1_hau_ind ON nm_admin_groups
(nag_parent_admin_unit          -- hag_fk1_hau_ind
);
--
CREATE INDEX hag_fk2_hau_ind ON nm_admin_groups
(nag_child_admin_unit           -- hag_fk2_hau_ind
);
--
--
PROMPT Creating FK indexes for NM_ADMIN_UNITS_ALL
--
CREATE INDEX nau_nat_fk_ind ON nm_admin_units_all
(nau_admin_type                 -- nau_nat_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_AUDIT_COLUMNS
--
CREATE INDEX nac_nat_fk_ind ON nm_audit_columns
(nac_table_name                 -- nac_nat_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_AUDIT_KEY_COLS
--
CREATE INDEX nkc_nat_fk_ind ON nm_audit_key_cols
(nkc_table_name                 -- nkc_nat_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_ELEMENTS_ALL
--
CREATE INDEX ne_ngt_fk_ind ON nm_elements_all
(ne_gty_group_type              -- ne_ngt_fk_ind
);
--
CREATE INDEX ne_no_fk_end_ind ON nm_elements_all
(ne_no_end                      -- ne_no_fk_end_ind
);
--
CREATE INDEX ne_no_fk_st_ind ON nm_elements_all
(ne_no_start                    -- ne_no_fk_st_ind
);
--
CREATE INDEX ne_nt_fk_ind ON nm_elements_all
(ne_nt_type                     -- ne_nt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_ELEMENT_HISTORY
--
CREATE INDEX neh_ne_fk_new_ind ON nm_element_history
(neh_ne_id_new                  -- neh_ne_fk_new_ind
);
--
CREATE INDEX neh_ne_fk_old_ind ON nm_element_history
(neh_ne_id_old                  -- neh_ne_fk_old_ind
);
--
--
PROMPT Creating FK indexes for NM_GROUP_RELATIONS_ALL
--
CREATE INDEX ngr_ngt_fk_ind ON nm_group_relations_all
(ngr_parent_group_type          -- ngr_ngt_fk_ind
);
--
CREATE INDEX ngr_ngt_fk2_ind ON nm_group_relations_all
(ngr_child_group_type           -- ngr_ngt_fk2_ind
);
--
--
PROMPT Creating FK indexes for NM_GROUP_TYPES_ALL
--
CREATE INDEX ngt_nt_fk_ind ON nm_group_types_all
(ngt_nt_type                    -- ngt_nt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_ATTRI_LOOKUP_ALL
--
CREATE INDEX iad_id_fk_ind ON nm_inv_attri_lookup_all
(ial_domain                     -- iad_id_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_ITEMS_ALL
--
CREATE INDEX iit_located_fk_ind ON nm_inv_items_all
(iit_located_by                 -- iit_located_fk_ind
);
--
CREATE INDEX iit_nau_fk_ind ON nm_inv_items_all
(iit_admin_unit                 -- iit_nau_fk_ind
);
--
CREATE INDEX iit_nit_fk_ind ON nm_inv_items_all
(iit_inv_type                   -- iit_nit_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_ITEM_GROUPINGS_ALL
--
CREATE INDEX iig_iit_fk_parent_ind ON nm_inv_item_groupings_all
(iig_parent_id                  -- iig_iit_fk_parent_ind
);
--
CREATE INDEX iig_iit_fk_top_ind ON nm_inv_item_groupings_all
(iig_top_id                     -- iig_iit_fk_top_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_NW_ALL
--
CREATE INDEX nin_nit_fk_ind ON nm_inv_nw_all
(nin_nit_inv_code               -- nin_nit_fk_ind
);
--
CREATE INDEX nin_nt_fk_ind ON nm_inv_nw_all
(nin_nw_type                    -- nin_nt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_TYPES_ALL
--
CREATE INDEX nit_nat_fk_ind ON nm_inv_types_all
(nit_admin_type                 -- nit_nat_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_TYPE_ATTRIBS_ALL
--
CREATE INDEX ita_id_fk_ind ON nm_inv_type_attribs_all
(ita_id_domain                  -- ita_id_fk_ind
);
--
CREATE INDEX ita_nit_fk_ind ON nm_inv_type_attribs_all
(ita_inv_type                   -- ita_nit_fk_ind
);
--
CREATE INDEX ita_nmu_fk_ind ON nm_inv_type_attribs_all
(ita_units                      -- ita_nmu_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_TYPE_GROUPINGS_ALL
--
CREATE INDEX itg_nit_fk_ind ON nm_inv_type_groupings_all
(itg_inv_type                   -- itg_nit_fk_ind
);
--
CREATE INDEX itg_nit_fk_parent_ind ON nm_inv_type_groupings_all
(itg_parent_inv_type            -- itg_nit_fk_parent_ind
);
--
--
PROMPT Creating FK indexes for NM_INV_TYPE_ROLES
--
CREATE INDEX itr_nit_fk_ind ON nm_inv_type_roles
(itr_inv_type                   -- itr_nit_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_LAYER_SETS
--
CREATE INDEX nls_nl_fk_ind ON nm_layer_sets
(nls_layer_id                   -- nls_nl_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_LOCATION_TYPES
--
CREATE INDEX nlt_aut_fk_ind ON nm_location_types
(nlt_admin_type                 -- nlt_aut_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MEMBERS_ALL
--
CREATE INDEX nm_ne_fk_of_ind ON nm_members_all
(nm_ne_id_of                    -- nm_ne_fk_of_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_DEFAULT_QUERY_ATTRIBS
--
CREATE INDEX ndqa_ndq_fk_ind ON nm_mrg_default_query_attribs
(nda_seq_no                     -- ndqa_ndq_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_QUERY_ATTRIBS
--
CREATE INDEX nmqa_nqt_fk_ind ON nm_mrg_query_attribs
(nqa_nmq_id                     -- nmqa_nqt_fk_ind
,nqa_nqt_seq_no                 -- nmqa_nqt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_QUERY_RESULTS
--
CREATE INDEX nmqr_nmq_fk_ind ON nm_mrg_query_results
(nqr_nmq_id                     -- nmqr_nmq_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_QUERY_TYPES
--
CREATE INDEX nmqt_nmq_fk_ind ON nm_mrg_query_types
(nqt_nmq_id                     -- nmqt_nmq_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_QUERY_USERS
--
CREATE INDEX nqu_hus_fk_ind ON nm_mrg_query_users
(nqu_username                   -- nqu_hus_fk_ind
);
--
CREATE INDEX nqu_nmq_fk_ind ON nm_mrg_query_users
(nqu_nmq_id                     -- nqu_nmq_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_QUERY_VALUES
--
CREATE INDEX nmqv_nqa_fk_ind ON nm_mrg_query_values
(nqv_nmq_id                     -- nmqv_nqa_fk_ind
,nqv_nqt_seq_no                 -- nmqv_nqa_fk_ind
,nqv_attrib_name                -- nmqv_nqa_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_SECTIONS
--
CREATE INDEX nms_nqr_fk_ind ON nm_mrg_sections
(nms_mrg_job_id                 -- nms_nqr_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_SECTION_INV_VALUES
--
CREATE INDEX nmsiv_nmq_fk_ind ON nm_mrg_section_inv_values
(nsv_mrg_job_id                 -- nmsiv_nmq_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_SECTION_MEMBERS
--
CREATE INDEX nmsm_nms_fk_ind ON nm_mrg_section_members
(nsm_mrg_job_id                 -- nmsm_nms_fk_ind
,nsm_mrg_section_id             -- nmsm_nms_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_MRG_SECTION_MEMBER_INV
--
CREATE INDEX nmsmi_nmsiv_fk_ind ON nm_mrg_section_member_inv
(nsi_mrg_job_id                 -- nmsmi_nmsiv_fk_ind
,nsi_value_id                   -- nmsmi_nmsiv_fk_ind
);
--
CREATE INDEX nmsmi_nms_fk_ind ON nm_mrg_section_member_inv
(nsi_mrg_job_id                 -- nmsmi_nms_fk_ind
,nsi_mrg_section_id             -- nmsmi_nms_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_NODES_ALL
--
CREATE INDEX nn_nnt_fk_ind ON nm_nodes_all
(no_node_type                   -- nn_nnt_fk_ind
);
--
CREATE INDEX nn_np_fk_ind ON nm_nodes_all
(no_np_id                       -- nn_np_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_NODE_USAGES_ALL
--
CREATE INDEX nnu_ne_fk_ind ON nm_node_usages_all
(nnu_ne_id                      -- nnu_ne_fk_ind
);
--
CREATE INDEX nnu_nn_fk_ind ON nm_node_usages_all
(nnu_no_node_id                 -- nnu_nn_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_NT_GROUPINGS_ALL
--
CREATE INDEX nng_ngt_fk_ind ON nm_nt_groupings_all
(nng_group_type                 -- nng_ngt_fk_ind
);
--
CREATE INDEX nng_nt_fk_ind ON nm_nt_groupings_all
(nng_nt_type                    -- nng_nt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_PBI_QUERY_ATTRIBS
--
CREATE INDEX nqa_nqt_fk_ind ON nm_pbi_query_attribs
(nqa_npq_id                     -- nqa_nqt_fk_ind
,nqa_nqt_seq_no                 -- nqa_nqt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_PBI_QUERY_RESULTS
--
CREATE INDEX nqr_npq_fk_ind ON nm_pbi_query_results
(nqr_npq_id                     -- nqr_npq_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_PBI_QUERY_TYPES
--
CREATE INDEX nqt_nit_fk_ind ON nm_pbi_query_types
(nqt_inv_type                   -- nqt_nit_fk_ind
);
--
CREATE INDEX nqt_npq_fk_ind ON nm_pbi_query_types
(nqt_npq_id                     -- nqt_npq_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_PBI_QUERY_VALUES
--
CREATE INDEX nqv_nqa_fk_ind ON nm_pbi_query_values
(nqv_npq_id                     -- nqv_nqa_fk_ind
,nqv_nqt_seq_no                 -- nqv_nqa_fk_ind
,nqv_attrib_name                -- nqv_nqa_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_PBI_SECTIONS
--
CREATE INDEX nqs_npr_fk_ind ON nm_pbi_sections
(nps_npq_id                     -- nqs_npr_fk_ind
,nps_nqr_job_id                 -- nqs_npr_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_PBI_SECTION_MEMBERS
--
CREATE INDEX npm_nps_fk_ind ON nm_pbi_section_members
(npm_npq_id                     -- npm_nps_fk_ind
,npm_nqr_job_id                 -- npm_nps_fk_ind
,npm_nps_section_id             -- npm_nps_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_SAVED_EXTENT_MEMBERS
--
CREATE INDEX nsu_nse_fk_ind ON nm_saved_extent_members
(nsm_nse_id                     -- nsu_nse_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_SAVED_EXTENT_MEMBER_DATUMS
--
CREATE INDEX nsd_nsm_fk_ind ON nm_saved_extent_member_datums
(nsd_nse_id                     -- nsd_nsm_fk_ind
,nsd_nsm_id                     -- nsd_nsm_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_SHAPES_1
--
CREATE INDEX ns_ne_fk_ind ON nm_shapes_1
(ns_ne_id                       -- ns_ne_fk_ind
);
--
CREATE INDEX ns_nl_fk_ind ON nm_shapes_1
(ns_layer_id                    -- ns_nl_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_TYPES
--
CREATE INDEX nt_nat_fk_ind ON nm_types
(nt_admin_type                  -- nt_nat_fk_ind
);
--
CREATE INDEX nt_nnt_fk_ind ON nm_types
(nt_node_type                   -- nt_nnt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_TYPE_COLUMNS
--
CREATE INDEX ntc_nt_fk_ind ON nm_type_columns
(ntc_nt_type                    -- ntc_nt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_TYPE_INCLUSION
--
CREATE INDEX nti_nt_fk_child_ind ON nm_type_inclusion
(nti_nw_child_type              -- nti_nt_fk_child_ind
);
--
CREATE INDEX nti_nt_fk_parent_ind ON nm_type_inclusion
(nti_nw_parent_type             -- nti_nt_fk_parent_ind
);
--
--
PROMPT Creating FK indexes for NM_TYPE_LAYERS_ALL
--
CREATE INDEX ntl_nl_fk_ind ON nm_type_layers_all
(ntl_layer_id                   -- ntl_nl_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_TYPE_SUBCLASS
--
CREATE INDEX nsc_nt_fk_ind ON nm_type_subclass
(nsc_nw_type                    -- nsc_nt_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_TYPE_SUBCLASS_RESTRICTIONS
--
CREATE INDEX nsr_nsc_fk_exist_ind ON nm_type_subclass_restrictions
(nsr_nw_type                    -- nsr_nsc_fk_exist_ind
,nsr_sub_class_existing         -- nsr_nsc_fk_exist_ind
);
--
CREATE INDEX nsr_nsc_fk_new_ind ON nm_type_subclass_restrictions
(nsr_nw_type                    -- nsr_nsc_fk_new_ind
,nsr_sub_class_new              -- nsr_nsc_fk_new_ind
);
--
--
PROMPT Creating FK indexes for NM_UNITS
--
CREATE INDEX un_fk_ud_ind ON nm_units
(un_domain_id                   -- un_fk_ud_ind
);
--
--
PROMPT Creating FK indexes for NM_UNIT_CONVERSIONS
--
CREATE INDEX uc_fk_un_from_ind ON nm_unit_conversions
(uc_unit_id_in                  -- uc_fk_un_from_ind
);
--
CREATE INDEX uc_fk_un_to_ind ON nm_unit_conversions
(uc_unit_id_out                 -- uc_fk_un_to_ind
);
--
--
PROMPT Creating FK indexes for NM_USER_AUS_ALL
--
CREATE INDEX nua_hus_fk_ind ON nm_user_aus_all
(nua_user_id                    -- nua_hus_fk_ind
);
--
CREATE INDEX nua_nau_fk_ind ON nm_user_aus_all
(nua_admin_unit                 -- nua_nau_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_XSP
--
CREATE INDEX nwx_nsc_fk_ind ON nm_xsp
(nwx_nw_type                    -- nwx_nsc_fk_ind
,nwx_nsc_sub_class              -- nwx_nsc_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_X_DEPENDENCIES
--
CREATE INDEX xd_xiv_fk_ind ON nm_x_dependencies
(xd_xi_id                       -- xd_xiv_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_X_DEP_VALUES
--
CREATE INDEX xdv_xd_fk_ind ON nm_x_dep_values
(xdv_dep_id                     -- xdv_xd_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_X_INDEP
--
CREATE INDEX xi_ita_fk_ind ON nm_x_indep
(xi_ita_inv_type                -- xi_ita_fk_ind
,xi_ita_attrib_name             -- xi_ita_fk_ind
);
--
--
PROMPT Creating FK indexes for NM_X_INDEP_VALUES
--
CREATE INDEX xiv_xi_fk_ind ON nm_x_indep_values
(xiv_xi_id                      -- xiv_xi_fk_ind
);
--
--
PROMPT Creating FK indexes for OBSTRUCTIONS
--
CREATE INDEX obs_fk_obt_ind ON obstructions
(obs_obt_id                     -- obs_fk_obt_ind
);
--
CREATE INDEX obs_fk_rin_ind ON obstructions
(obs_rin_id                     -- obs_fk_rin_ind
);
--
--
PROMPT Creating FK indexes for ROAD_INTERSECTIONS
--
CREATE INDEX rin_fk_str_ind ON road_intersections
(rin_str_id                     -- rin_fk_str_ind
);
--
--
PROMPT Creating FK indexes for STR_ATTR_GROUPS
--
CREATE INDEX sag_fk_sit_ind ON str_attr_groups
(sag_sit_id                     -- sag_fk_sit_ind
);
--
--
PROMPT Creating FK indexes for STR_ATTR_LOG
--
CREATE INDEX slg_fk_sia_ind ON str_attr_log
(slg_str_id                     -- slg_fk_sia_ind
,slg_sat_id                     -- slg_fk_sia_ind
,slg_sav_occurence              -- slg_fk_sia_ind
);
--
--
PROMPT Creating FK indexes for STR_ATTR_LOOKUP
--
CREATE INDEX sal_fk_sad_ind ON str_attr_lookup
(sal_sad_id                     -- sal_fk_sad_ind
);
--
--
PROMPT Creating FK indexes for STR_ATTR_MEMBS
--
CREATE INDEX sam_fk_sag_ind ON str_attr_membs
(sam_sag_id                     -- sam_fk_sag_ind
);
--
CREATE INDEX sam_fk_sat_ind ON str_attr_membs
(sam_sat_id                     -- sam_fk_sat_ind
);
--
CREATE INDEX sam_fk_sit_ind ON str_attr_membs
(sam_sit_id                     -- sam_fk_sit_ind
);
--
--
PROMPT Creating FK indexes for STR_ATTR_TYPES
--
CREATE INDEX sat_fk_sad_ind ON str_attr_types
(sat_sad_id                     -- sat_fk_sad_ind
);
--
--
PROMPT Creating FK indexes for STR_ATTR_USERS
--
CREATE INDEX sua_fk_sag_ind ON str_attr_users
(sau_sag_id                     -- sua_fk_sag_ind
);
--
--
PROMPT Creating FK indexes for STR_ATTR_VALID
--
CREATE INDEX sav_fk_sat_ind ON str_attr_valid
(sav_sat_id                     -- sav_fk_sat_ind
);
--
CREATE INDEX sav_fk_sit_ind ON str_attr_valid
(sav_sit_id                     -- sav_fk_sit_ind
);
--
--
PROMPT Creating FK indexes for STR_EQPT_LIST
--
CREATE INDEX sel_fk_seq_ind ON str_eqpt_list
(sel_seq_id                     -- sel_fk_seq_ind
);
--
CREATE INDEX sel_fk_snt_ind ON str_eqpt_list
(sel_snt_id                     -- sel_fk_snt_ind
);
--
CREATE INDEX sel_fk_str_ind ON str_eqpt_list
(sel_str_id                     -- sel_fk_str_ind
);
--
--
PROMPT Creating FK indexes for STR_INSP
--
CREATE INDEX sip_fk_sib_ind ON str_insp
(sip_sib_id                     -- sip_fk_sib_ind
);
--
CREATE INDEX sip_fk_snt_ind ON str_insp
(sip_snt_id                     -- sip_fk_snt_ind
);
--
CREATE INDEX sip_fk_str_ind ON str_insp
(sip_str_id                     -- sip_fk_str_ind
);
--
--
PROMPT Creating FK indexes for STR_INSP_DEF_CMP
--
CREATE INDEX sid_fk_sit_ind ON str_insp_def_cmp
(sid_cmp_sit_id                 -- sid_fk_sit_ind
);
--
CREATE INDEX sid_fk_siv_ind ON str_insp_def_cmp
(sid_str_sit_id                 -- sid_fk_siv_ind
,sid_snt_id                     -- sid_fk_siv_ind
);
--
--
PROMPT Creating FK indexes for STR_INSP_INTERVALS
--
CREATE INDEX sii_fk_snt_ind ON str_insp_intervals
(sii_snt_id                     -- sii_fk_snt_ind
);
--
CREATE INDEX sii_fk_str_ind ON str_insp_intervals
(sii_str_id                     -- sii_fk_str_ind
);
--
--
PROMPT Creating FK indexes for STR_INSP_LINES
--
CREATE INDEX sil_fk_sip_ind ON str_insp_lines
(sil_sip_id                     -- sil_fk_sip_ind
);
--
CREATE INDEX sil_fk_str_ind ON str_insp_lines
(sil_cmp_str_id                 -- sil_fk_str_ind
);
--
--
PROMPT Creating FK indexes for STR_INSP_NOTICES
--
CREATE INDEX sin_fk_sii_ind ON str_insp_notices
(sin_str_id                     -- sin_fk_sii_ind
,sin_snt_id                     -- sin_fk_sii_ind
);
--
--
PROMPT Creating FK indexes for STR_INSP_TYPES
--
CREATE INDEX snt_fk_sis_ind ON str_insp_types
(snt_sis_id                     -- snt_fk_sis_ind
);
--
--
PROMPT Creating FK indexes for STR_INSP_VALID
--
CREATE INDEX siv_fk_sit_ind ON str_insp_valid
(siv_sit_id                     -- siv_fk_sit_ind
);
--
CREATE INDEX siv_fk_snt_ind ON str_insp_valid
(siv_snt_id                     -- siv_fk_snt_ind
);
--
--
PROMPT Creating FK indexes for STR_ITEMS_ALL
--
CREATE INDEX str_fk_sic_ind ON str_items_all
(str_sic_id                     -- str_fk_sic_ind
);
--
CREATE INDEX str_fk_sit_ind ON str_items_all
(str_sit_id                     -- str_fk_sit_ind
);
--
CREATE INDEX str_fk_str_parent_ind ON str_items_all
(str_parent_id                  -- str_fk_str_parent_ind
);
--
CREATE INDEX str_fk_str_top_ind ON str_items_all
(str_top_id                     -- str_fk_str_top_ind
);
--
--
PROMPT Creating FK indexes for STR_ITEM_ATTR
--
CREATE INDEX sia_fk_sat_ind ON str_item_attr
(sia_sat_id                     -- sia_fk_sat_ind
);
--
CREATE INDEX sia_fk_str_ind ON str_item_attr
(sia_str_id                     -- sia_fk_str_ind
);
--
--
PROMPT Creating FK indexes for STR_PBI_QUERY
--
CREATE INDEX spq_fk_sit_ind ON str_pbi_query
(qry_sit_id                     -- spq_fk_sit_ind
);
--
--
PROMPT Creating FK indexes for STR_PBI_QUERY_ATTRIBS
--
CREATE INDEX sqra_fk_qrt_ind ON str_pbi_query_attribs
(qra_qry_id                     -- sqra_fk_qrt_ind
,qra_qrt_sit_id                 -- sqra_fk_qrt_ind
);
--
CREATE INDEX sqra_fk_sat_ind ON str_pbi_query_attribs
(qra_sat_id                     -- sqra_fk_sat_ind
);
--
--
PROMPT Creating FK indexes for STR_PBI_QUERY_TYPES
--
CREATE INDEX sqrt_fk_qry_ind ON str_pbi_query_types
(qrt_qry_id                     -- sqrt_fk_qry_ind
);
--
CREATE INDEX sqrt_fk_sit_ind ON str_pbi_query_types
(qrt_sit_id                     -- sqrt_fk_sit_ind
);
--
--
PROMPT Creating FK indexes for STR_PBI_RESULTS
--
CREATE INDEX pbi_fk_qry_ind ON str_pbi_results
(pbi_qry_id                     -- pbi_fk_qry_ind
);
--
--
PROMPT Creating FK indexes for STR_TEMPLATES
--
CREATE INDEX ste_fk_sit_ind ON str_templates
(ste_sit_id                     -- ste_fk_sit_ind
);
--
CREATE INDEX ste_fk_ste_ind ON str_templates
(ste_parent_id                  -- ste_fk_ste_ind
);
--
--
PROMPT Creating FK indexes for STR_VALID_INSP_ATTR
--
CREATE INDEX svi_fk_siv_ind ON str_valid_insp_attr
(svi_str_sit_id                 -- svi_fk_siv_ind
,svi_snt_id                     -- svi_fk_siv_ind
);
--
--
PROMPT Creating FK indexes for XSP_RESTRAINTS
--
CREATE INDEX xsr_nwx_fk_ind ON xsp_restraints
(xsr_nw_type                    -- xsr_nwx_fk_ind
,xsr_x_sect_value               -- xsr_nwx_fk_ind
,xsr_scl_class                  -- xsr_nwx_fk_ind
);
--
SET FEEDBACK ON
