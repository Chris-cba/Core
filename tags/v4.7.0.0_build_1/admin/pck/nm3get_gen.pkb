CREATE OR REPLACE PACKAGE BODY nm3get_gen AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3get_gen.pkb-arc   2.3   Jul 04 2013 16:04:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3get_gen.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:40:50  $
--       PVCS Version     : $Revision:   2.3  $
--
--
--   Author : Jonathan Mills
--
--   nm3get generation package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.3  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3get_gen';
--
   
   g_tab_table              tab_varchar30;
   g_tab_base_table_for_dt  tab_varchar30;
   g_tab_prefix             tab_varchar30;
   g_table_count            pls_integer := 0;
   g_insert_allowed         boolean;
   --
   g_tab_seq         tab_varchar30;
--
   TYPE tab_rec_atc IS TABLE OF all_tab_columns%ROWTYPE INDEX BY binary_integer;
   g_current_tab_vc   tab_varchar32767;
   g_tab_get_header   tab_varchar32767;
   g_tab_get_body     tab_varchar32767;
   g_tab_ins_header   tab_varchar32767;
   g_tab_ins_body     tab_varchar32767;
   g_tab_lock_header  tab_varchar32767;
   g_tab_lock_body    tab_varchar32767;
   g_tab_del_header   tab_varchar32767;
   g_tab_del_body     tab_varchar32767;
   g_tab_debug_header tab_varchar32767;
   g_tab_debug_body   tab_varchar32767;
   g_tab_seq_header   tab_varchar32767;
   g_tab_seq_body     tab_varchar32767;
--
   g_start_date_not_in_pk_ignore EXCEPTION;
   g_pk_no_cols                  EXCEPTION;
--
   c_nm3_package_prefix  CONSTANT varchar2(3) := 'nm3';
   c_package_prefix         varchar2(30);
--
   c_get_package            varchar2(30);
   c_del_package            varchar2(30);
   c_ins_package            varchar2(30);
   c_lock_package           varchar2(30);
   c_debug_package          varchar2(30);
   c_seq_package            varchar2(30);
--
-----------------------------------------------------------------------------
--
FUNCTION create_lock_procedure (p_table_name varchar2) RETURN boolean;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_data_nm3;
--
-----------------------------------------------------------------------------
--
FUNCTION get_alias_from_array (p_table_name varchar2) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_one (p_table_name varchar2
                       ,p_base_table varchar2
                       );
--
-----------------------------------------------------------------------------
--
FUNCTION get_columns (p_table_name varchar2
                     ,p_base_table varchar2
                     ) RETURN tab_rec_atc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pk_columns (p_constraint_name   varchar2
                        ,p_ignore_start_date boolean DEFAULT FALSE
                        ) RETURN tab_varchar30;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_primary_unique_cons (pi_table_name           IN     varchar2
                                  ,po_tab_constraint_name     OUT tab_varchar30
                                  ,po_tab_constraint_index    OUT tab_varchar30
                                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_tab_vc_to_tab_vc (p_tab_vc_in  IN     tab_varchar32767
                                  ,p_tab_vc_out IN OUT tab_varchar32767
                                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE seperator;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_text varchar2);
--
-----------------------------------------------------------------------------
--
PROCEDURE do_sequences;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_each_seq (pi_seq_name varchar2);
--
-----------------------------------------------------------------------------
--
PROCEDURE set_package_names (pi_product_name varchar2);
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_from_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_tab (p_table  varchar2
                  ,p_prefix varchar2
                  ,p_base   varchar2 DEFAULT NULL
                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE add_seq (p_seq varchar2);
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_data_nm3 IS
   --
BEGIN
   --
   set_package_names (pi_product_name => c_nm3_package_prefix);
   --
   g_table_count := 0;
   g_tab_table.DELETE;
   g_tab_prefix.DELETE;
   g_tab_seq.DELETE;
   --
   add_tab('DOCS','DOC');
   add_tab('DOC_ACTIONS','DAC');
   add_tab('DOC_ACTION_HISTORY','DAH');
   add_tab('DOC_ASSOCS','DAS');
   add_tab('DOC_CLASS','DCL');
   add_tab('DOC_CONTACT','DEC');
   add_tab('DOC_CONTACT_ADDRESS','HCT');
   add_tab('DOC_COPIES','DCP');
   add_tab('DOC_DAMAGE','DDG');
   add_tab('DOC_DAMAGE_COSTS','DDC');
   add_tab('DOC_ENQUIRY_CONTACTS','DEC');
   add_tab('DOC_ENQUIRY_TYPES','DET');
   add_tab('DOC_GATEWAYS','DGT');
   add_tab('DOC_GATE_SYNS','DGS');
   add_tab('DOC_HISTORY','DHI');
   add_tab('DOC_KEYS','DKY');
   add_tab('DOC_KEYWORDS','DKW');
   add_tab('DOC_LOCATIONS','DLC');
   add_tab('DOC_LOV_RECS','DLR');
   add_tab('DOC_MEDIA','DMD');
   add_tab('DOC_QUERY','DQ');
   add_tab('DOC_QUERY_COLS','DQC');
   add_tab('DOC_STD_ACTIONS','DSA');
   add_tab('DOC_STD_COSTS','DSC');
   add_tab('DOC_SYNONYMS','DSY');
   add_tab('DOC_TEMPLATE_COLUMNS','DTC');
   add_tab('DOC_TEMPLATE_GATEWAYS','DTG');
   add_tab('DOC_TEMPLATE_USERS','DTU');
   add_tab('DOC_TYPES','DTP');
   --
--   add_tab('GIS_THEMES_ALL','GT');
--   add_tab('GIS_THEME_FUNCTIONS_ALL','GTF');
--   add_tab('GIS_THEME_ROLES','GTHR');
   --
   add_tab('GRI_LOV','GL');
   add_tab('GRI_MODULES','GRM');
   add_tab('GRI_MODULE_PARAMS','GMP');
   add_tab('GRI_PARAMS','GP');
   add_tab('GRI_PARAM_DEPENDENCIES','GPD');
   add_tab('GRI_PARAM_LOOKUP','GPL');
   add_tab('GRI_REPORT_RUNS','GRR');
   add_tab('GRI_RUN_PARAMETERS','GRP');
   add_tab('GRI_SAVED_PARAMS','GSP');
   add_tab('GRI_SAVED_SETS','GSS');
   add_tab('GRI_SPOOL','GRS');
   --
   add_tab('HIG_ADDRESS','HAD');
   add_tab('HIG_CODES','HCO');
   add_tab('HIG_COLOURS','HCL');
   add_tab('HIG_CONTACTS','HCT');
   add_tab('HIG_CONTACT_ADDRESS','HCA');
   add_tab('HIG_DOMAINS','HDO');
   add_tab('HIG_ERRORS','HER');
--
   add_tab('HIG_HD_JOIN_DEFS','HHT');
   add_tab('HIG_HD_LOOKUP_JOIN_COLS','HHO');
   add_tab('HIG_HD_LOOKUP_JOIN_DEFS','HHL');
   add_tab('HIG_HD_MODULES','HHM');
   add_tab('HIG_HD_MOD_USES','HHU');
   add_tab('HIG_HD_SELECTED_COLS','HHC');
   add_tab('HIG_HD_TABLE_JOIN_COLS','HHJ');
--
   add_tab('HIG_HOLIDAYS','HHO');
   add_tab('HIG_MODULES','HMO');
   add_tab('HIG_MODULE_HISTORY','HMH');
   add_tab('HIG_MODULE_KEYWORDS','HMK');
   add_tab('HIG_MODULE_ROLES','HMR');
   add_tab('HIG_MODULE_USAGES','HMU');
   add_tab('HIG_OPTION_LIST','HOL');
   add_tab('HIG_OPTIONS','HOP');
   add_tab('HIG_OPTION_VALUES','HOV');
   add_tab('HIG_PRODUCTS','HPR');
   add_tab('HIG_REPORT_STYLES', 'HRS');
   add_tab('HIG_ROLES','HRO');
   add_tab('HIG_STATUS_CODES','HSC');
   add_tab('HIG_STATUS_DOMAINS','HSD');
   add_tab('HIG_UPGRADES','HUP');
   add_tab('HIG_URL_MODULES','HUM');
   add_tab('HIG_USERS','HUS');
   add_tab('HIG_USER_HISTORY','HUH');
   add_tab('HIG_USER_OPTIONS','HUO');
   add_tab('HIG_USER_ROLES','HUR');
   --
   add_tab('NM_ADMIN_GROUPS','NAG');
   add_tab('NM_ADMIN_UNITS','NAU','NM_ADMIN_UNITS_ALL');
   add_tab('NM_ADMIN_UNITS_ALL','NAU_ALL');
   add_tab('NM_AREA_LOCK','NAL');   
   add_tab('NM_ASSETS_ON_ROUTE_STORE', 'NARS');
   add_tab('NM_ASSETS_ON_ROUTE_STORE_ATT', 'NARSA');
   add_tab('NM_ASSETS_ON_ROUTE_STORE_ATT_D', 'NARSD');
   add_tab('NM_ASSETS_ON_ROUTE_STORE_HEAD', 'NARSH');
   add_tab('NM_ASSETS_ON_ROUTE_STORE_TOTAL', 'NARST');
   add_tab('NM_AUDIT_ACTIONS','NAA');
   add_tab('NM_AUDIT_CHANGES','NACH');
   add_tab('NM_AUDIT_COLUMNS','NAC');
   add_tab('NM_AUDIT_KEY_COLS','NKC');
   add_tab('NM_AUDIT_TABLES','NATAB');
   add_tab('NM_AUDIT_TEMP','NATMP');
   add_tab('NM_AU_TYPES','NAT');
   add_tab('NM_AU_SUB_TYPES','NSTY');
   add_tab('NM_AU_TYPES_GROUPINGS','NATG');      
   add_tab('NM_DBUG','ND');
   add_tab('NM_ELEMENTS','NE','NM_ELEMENTS_ALL');
   add_tab('NM_ELEMENTS_ALL','NE_ALL');
   add_tab('NM_ELEMENT_HISTORY','NEH');
   add_tab('NM_ERRORS','NER');
   add_tab('NM_EVENT_ALERT_MAILS', 'NEA');
   add_tab('NM_EVENT_LOG', 'NEL');
   add_tab('NM_EVENT_TYPES', 'NET');
   add_tab('NM_FILL_PATTERNS', 'NFP');
   add_tab('NM_GAZ_QUERY','NGQ');
   add_tab('NM_GAZ_QUERY_TYPES','NGQT');
   add_tab('NM_GAZ_QUERY_ATTRIBS','NGQA');
   add_tab('NM_GAZ_QUERY_VALUES','NGQV');
   add_tab('NM_GROUP_INV_TYPES','NGIT');
   add_tab('NM_GROUP_INV_LINK','NGIL','NM_GROUP_INV_LINK_ALL');
   add_tab('NM_GROUP_INV_LINK_ALL','NGIL_ALL');
   add_tab('NM_GROUP_RELATIONS','NGR','NM_GROUP_RELATIONS_ALL');
   add_tab('NM_GROUP_RELATIONS_ALL','NGR_ALL');
   add_tab('NM_GROUP_TYPES','NGT','NM_GROUP_TYPES_ALL');
   add_tab('NM_GROUP_TYPES_ALL','NGT_ALL');
   add_tab('NM_INV_ATTRI_LOOKUP','IAL','NM_INV_ATTRI_LOOKUP_ALL');
   add_tab('NM_INV_ATTRI_LOOKUP_ALL','IAL_ALL');
   add_tab('NM_INV_CATEGORIES', 'NIC');
   add_tab('NM_INV_CATEGORY_MODULES', 'ICM');
   add_tab('NM_INV_DOMAINS','ID','NM_INV_DOMAINS_ALL');
   add_tab('NM_INV_DOMAINS_ALL','ID_ALL');
   add_tab('NM_INV_ITEMS','IIT','NM_INV_ITEMS_ALL');
   add_tab('NM_INV_ITEMS_ALL','IIT_ALL');
   add_tab('NM_INV_ITEM_GROUPINGS','IIG','NM_INV_ITEM_GROUPINGS_ALL');
   add_tab('NM_INV_ITEM_GROUPINGS_ALL','IIG_ALL');
   add_tab('NM_INV_NW','NIN','NM_INV_NW_ALL');
   add_tab('NM_INV_NW_ALL','NIN_ALL');
   add_tab('NM_INV_THEMES','NITH');
   add_tab('NM_INV_TYPES','NIT','NM_INV_TYPES_ALL');
   add_tab('NM_INV_TYPES_ALL','NIT_ALL');
   add_tab('NM_INV_TYPE_ATTRIBS','ITA','NM_INV_TYPE_ATTRIBS_ALL');
   add_tab('NM_INV_TYPE_ATTRIBS_ALL','ITA_ALL');
   add_tab('NM_INV_TYPE_ATTRIB_BANDINGS','ITB');
   add_tab('NM_INV_TYPE_ATTRIB_BAND_DETS','ITD');
   add_tab('NM_INV_ATTRIBUTE_SETS', 'NIAS');
   add_tab('NM_INV_ATTRIBUTE_SET_INV_TYPES', 'NSIT');
   add_tab('NM_INV_ATTRIBUTE_SET_INV_ATTR', 'NSIA');
   add_tab('NM_INV_TYPE_COLOURS','NITC');
   add_tab('NM_INV_TYPE_GROUPINGS','ITG','NM_INV_TYPE_GROUPINGS_ALL');
   add_tab('NM_INV_TYPE_GROUPINGS_ALL','ITG_ALL');
   add_tab('NM_INV_TYPE_ROLES','ITR');
   --add_tab('NM_JOBS','NMJ');
   add_tab('NM_JOB_CONTROL','NJC');
   add_tab('NM_JOB_OPERATIONS','NJO');
   add_tab('NM_JOB_OPERATION_DATA_VALUES','NJV');
   add_tab('NM_JOB_TYPES','NJT');
   add_tab('NM_JOB_TYPES_OPERATIONS','JTO');
--   add_tab('NM_LAYERS','NL');       -- GJ removed at release 3211 
--   add_tab('NM_LAYER_SETS','NLS');  -- GJ removed at release 3211
   --
   add_tab('NM_LD_MC_ALL_INV_TMP','NLM');
   --
   add_tab('NM_LINEAR_TYPES','NLT');
   --
   add_tab('NM_LOAD_BATCHES','NLB');
   add_tab('NM_LOAD_BATCH_STATUS','NLBS');
   add_tab('NM_LOAD_DESTINATIONS','NLD');
   add_tab('NM_LOAD_DESTINATION_DEFAULTS','NLDD');
   add_tab('NM_LOAD_FILES','NLF');
   add_tab('NM_LOAD_FILE_COLS','NLFC');
   add_tab('NM_LOAD_FILE_COL_DESTINATIONS','NLCD');
   add_tab('NM_LOAD_FILE_DESTINATIONS','NLFD');
   --add_tab('NM_LOCATION_TYPES','NLT');
   add_tab('NM_MAIL_GROUPS','NMG');
   add_tab('NM_MAIL_GROUP_MEMBERSHIP','NMGM');
   add_tab('NM_MAIL_MESSAGE','NMM');
   add_tab('NM_MAIL_MESSAGE_RECIPIENTS','NMMR');
   add_tab('NM_MAIL_MESSAGE_TEXT','NMMT');
   add_tab('NM_MAIL_USERS','NMU');
   add_tab('NM_MEMBERS','NM','NM_MEMBERS_ALL');
   add_tab('NM_MEMBERS_ALL','NM_ALL');
   add_tab('NM_MEMBER_HISTORY','NMH');
   add_tab('NM_MRG_DEFAULT_QUERY_ATTRIBS','NDA');
   add_tab('NM_MRG_DEFAULT_QUERY_TYPES','NDQ','NM_MRG_DEFAULT_QUERY_TYPES_ALL');
   add_tab('NM_MRG_DEFAULT_QUERY_TYPES_ALL','NDQ_ALL');
   add_tab('NM_MRG_INV_DERIVATION','NMID');
   add_tab('NM_MRG_OUTPUT_COLS','NMC');
   add_tab('NM_MRG_OUTPUT_COL_DECODE','NMCD');
   add_tab('NM_MRG_OUTPUT_FILE','NMF');
   add_tab('NM_MRG_QUERY','NMQ','NM_MRG_QUERY_ALL');
   add_tab('NM_MRG_QUERY_ALL','NMQ_ALL');
   add_tab('NM_MRG_QUERY_ATTRIBS','NMQA');
   add_tab('NM_MRG_QUERY_RESULTS','NMQR','NM_MRG_QUERY_RESULTS_ALL');
   add_tab('NM_MRG_QUERY_RESULTS_ALL','NMQR_ALL');
   add_tab('NM_MRG_QUERY_ROLES','NQRO');
   add_tab('NM_MRG_QUERY_TYPES','NMQT','NM_MRG_QUERY_TYPES_ALL');
   add_tab('NM_MRG_QUERY_TYPES_ALL','NMQT_ALL');
   add_tab('NM_MRG_QUERY_VALUES','NMQV');
   add_tab('NM_MRG_SECTIONS','NMS','NM_MRG_SECTIONS_ALL');
   add_tab('NM_MRG_SECTIONS_ALL','NMS_ALL');
   add_tab('NM_MRG_SECTION_INV_VALUES','NSV','NM_MRG_SECTION_INV_VALUES_ALL');
   add_tab('NM_MRG_SECTION_INV_VALUES_ALL','NSV_ALL');
   add_tab('NM_MRG_SECTION_MEMBERS','NMSM');
   add_tab('NM_NODES','NO','NM_NODES_ALL');
   add_tab('NM_NODES_ALL','NO_ALL');
   add_tab('NM_NODE_TYPES','NNT');
   add_tab('NM_NODE_USAGES','NNU','NM_NODE_USAGES_ALL');
   add_tab('NM_NODE_USAGES_ALL','NNU_ALL');
   add_tab('NM_NT_GROUPINGS','NNG','NM_NT_GROUPINGS_ALL');
   add_tab('NM_NT_GROUPINGS_ALL','NNG_ALL');
   add_tab('NM_NW_AD_TYPES','NAD');   
   add_tab('NM_NW_PERSISTENT_EXTENTS','NPE');
   add_tab('NM_NW_THEMES','NNTH');
   add_tab('NM_OPERATIONS','NMO');
   add_tab('NM_OPERATION_DATA','NOD');
   add_tab('NM_PBI_QUERY','NPQ');
   add_tab('NM_PBI_QUERY_ATTRIBS','NPQA');
   add_tab('NM_PBI_QUERY_RESULTS','NPQR');
   add_tab('NM_PBI_QUERY_TYPES','NPQT');
   add_tab('NM_PBI_QUERY_VALUES','NPQV');
   add_tab('NM_PBI_SECTIONS','NPS');
   add_tab('NM_PBI_SECTION_MEMBERS','NPSM');
   add_tab('NM_POINTS','NP');
--   add_tab('NM_POINT_LOCATIONS','NPL');  -- table can be dropped when dropping spatial layers
   add_tab('NM_RECLASS_DETAILS','NRD');
   add_tab('NM_REVERSAL','NREV');
   add_tab('NM_SAVED_EXTENTS','NSE');
   add_tab('NM_SAVED_EXTENT_MEMBERS','NSM');
   add_tab('NM_SAVED_EXTENT_MEMBER_DATUMS','NSD');
   add_tab('NM_TEMP_INV_ITEMS','TII');
   add_tab('NM_TEMP_INV_ITEMS_TEMP','TIIT');
   add_tab('NM_TEMP_INV_MEMBERS','TIM');
   add_tab('NM_TEMP_INV_MEMBERS_TEMP','TIMT');
   add_tab('NM_TEMP_NODES','NTN');
   --
   add_tab('NM_THEMES_ALL','NTH');
   add_tab('NM_THEME_GTYPES','NTG');   
   add_tab('NM_THEME_FUNCTIONS_ALL','NTF');
   add_tab('NM_THEME_ROLES','NTHR');
   add_tab('NM_THEME_SNAPS','NTS');
   --
   add_tab('NM_TYPES','NT');
   add_tab('NM_TYPE_COLUMNS','NTC');
   add_tab('NM_TYPE_INCLUSION','NTI');
   add_tab('NM_TYPE_LAYERS','NTL','NM_TYPE_LAYERS_ALL');
   add_tab('NM_TYPE_LAYERS_ALL','NTL_ALL');
   add_tab('NM_TYPE_SUBCLASS','NSC');
   add_tab('NM_TYPE_SUBCLASS_RESTRICTIONS','NSR');
   add_tab('NM_UNITS','UN');
   add_tab('NM_UNIT_CONVERSIONS','UC');
   add_tab('NM_UNIT_DOMAINS','UD');
   add_tab('NM_UPLOAD_FILES','NUF');
   add_tab('NM_UPLOAD_FILESPART','NUFP');
   add_tab('NM_USER_AUS','NUA','NM_USER_AUS_ALL');
   add_tab('NM_USER_AUS_ALL','NUA_ALL');
   add_tab('NM_VISUAL_ATTRIBUTES', 'NVA');
   add_tab('NM_XML_FILES','NXF');
   add_tab('NM_XML_LOAD_BATCHES','NXB');
   add_tab('NM_XML_LOAD_ERRORS','NXLE');
   add_tab('NM_NW_XSP','NWX');
   add_tab('NM_X_DRIVING_CONDITIONS','NXD');
   add_tab('NM_X_ERRORS','NXE');
   add_tab('NM_X_INV_CONDITIONS','NXIC');
   add_tab('NM_X_LOCATION_RULES','NXL');
   add_tab('NM_X_NW_RULES','NXN');
   add_tab('NM_X_RULES','NXR');
   add_tab('NM_X_VAL_CONDITIONS','NXV');
   --
   add_tab('NM_XSP_RESTRAINTS','XSR');
   add_tab('NM_XSP_REVERSAL','XRV');
   --
   add_seq ('DAC_ID_SEQ');
   add_seq ('DDC_ID_SEQ');
   add_seq ('DDG_ID_SEQ');
   add_seq ('DLC_ID_SEQ');
   add_seq ('DMD_ID_SEQ');
   add_seq ('DOC_ID_SEQ');
   add_seq ('DQ_ID_SEQ');
   --add_seq ('ENQUIRY_SEQ');
   add_seq ('GIS_SESSION_ID');
   add_seq ('GSS_ID_SEQ');
 --  add_seq ('GT_THEME_ID');
   add_seq ('HAD_ID_SEQ');
   add_seq ('HCT_ID_SEQ');
   add_seq ('HUS_USER_ID_SEQ');
   add_seq ('IID_ITEM_ID_SEQ');
   add_seq ('ITB_BANDING_ID_SEQ');
   add_seq ('ITD_BAND_SEQ_SEQ');
   --add_seq ('LDR_ITEM_ID_SEQ');
   add_seq ('NAL_SEQ');   
   add_seq ('NAU_ADMIN_UNIT_SEQ');
   add_seq ('NSTY_ID_SEQ');   
   add_seq ('ND_ID_SEQ');
   --add_seq ('NEAT_ID_SEQ');
   add_seq ('NEH_ID_SEQ');
   add_seq ('NEL_ID_SEQ');
   add_seq ('NE_ID_SEQ');
   add_seq ('NGQ_ID_SEQ');
   add_seq ('NGQA_SEQ_NO_SEQ');
   add_seq ('NGQT_SEQ_NO_SEQ');
   --add_seq ('NHQ_ID_SEQ');
   add_seq ('NIAS_ID_SEQ');
   add_seq ('NJC_JOB_ID_SEQ');
   add_seq ('NJO_ID_SEQ');
   add_seq ('NL_LAYER_ID_SEQ');
   add_seq ('NLD_ID_SEQ');
   add_seq ('NLF_ID_SEQ');
   add_seq ('NLT_ID_SEQ');
   add_seq ('NMF_ID_SEQ');
   add_seq ('NMG_ID_SEQ');
   --add_seq ('NMJ_ID_SEQ');
   add_seq ('NMMT_LINE_ID_SEQ');
   add_seq ('NMM_ID_SEQ');
   add_seq ('NMQ_ID_SEQ');
   add_seq ('NMU_ID_SEQ');
   add_seq ('NM_AUDIT_TEMP_SEQ');
   add_seq ('NM_DB_SEQ');
   add_seq ('NM_MRG_QUERY_STAGING_SEQ');
   add_seq ('NM_MRG_QUERY_VALUES_SEQ');
   add_seq ('NO_NODE_ID_SEQ');
   add_seq ('NPQ_ID_SEQ');
   add_seq ('NP_ID_SEQ');
   add_seq ('NQT_SEQ_NO_SEQ');
   add_seq ('NSE_ID_SEQ');
   add_seq ('NSM_ID_SEQ');
   add_seq ('NTE_ID_SEQ');
   add_seq ('NTH_THEME_ID_SEQ');
   --add_seq ('NT_ID_SEQ');
   add_seq ('NXIC_ID_SEQ');
   add_seq ('NXR_ID_SEQ');
   --add_seq ('OBS_ID_SEQ');
   add_seq ('RTG_JOB_ID_SEQ');
   add_seq ('UD_DOMAIN_ID_SEQ');
   add_seq ('UN_UNIT_ID_SEQ');
--
END populate_data_nm3;
--
-----------------------------------------------------------------------------
--  Procs lifted from nm3 to remove dependencies
FUNCTION string(pi_string IN varchar2) RETURN varchar2 IS
BEGIN
--
   RETURN CHR(39)||pi_string||CHR(39); -- Return 'pi_string'
--
END string;
--
-----------------------------------------------------------------------------
--
FUNCTION LEFT(pi_string     IN varchar2
             ,pi_chars_reqd IN number
             ) RETURN varchar2 IS
BEGIN
--
   RETURN SUBSTR(pi_string,1,pi_chars_reqd);
--
END LEFT;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_file (LOCATION     IN     VARCHAR2
                     ,filename     IN     VARCHAR2
                     ,max_linesize IN     BINARY_INTEGER DEFAULT 32767
                     ,write_mode   IN     VARCHAR2 DEFAULT 'W'
                     ,all_lines    IN     tab_varchar32767
                     ) IS
--
   l_file   UTL_FILE.FILE_TYPE;
   l_count  PLS_INTEGER;
--
BEGIN
--
   l_file := utl_file.fopen (LOCATION,filename,write_mode,max_linesize);
--
   l_count := all_lines.FIRST;
--
   WHILE l_count IS NOT NULL
    LOOP
      utl_file.put_line(l_file,all_lines(l_count));
      l_count := all_lines.NEXT(l_count);
   END LOOP;
--
   utl_file.fclose(l_file);
--
END create_file;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sysopt
        (p_option_id         varchar2)
         RETURN varchar2 IS

CURSOR c_sys_opt IS
   SELECT hov_value
   FROM hig_option_values
   WHERE hov_id = p_option_id;

l_option_value varchar2(30);

BEGIN

   OPEN c_sys_opt;
   FETCH c_sys_opt INTO l_option_value;
   CLOSE c_sys_opt;

   RETURN( l_option_value );
END get_sysopt;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_all IS
BEGIN
--
   populate_data_nm3;
   generate_from_globals;
--
END generate_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_from_globals IS
--
   c_pkh           CONSTANT varchar2(4)  := '.pkh';
   c_pkb           CONSTANT varchar2(4)  := '.pkb';
--
   l_tab_names     tab_varchar30;
--
   l_tab_load      tab_varchar32767;
   l_tab_resv      tab_varchar32767;
   l_tab_repl      tab_varchar32767;
--
   l_filename      varchar2(80);
--
   PROCEDURE pvcs_tags IS
   BEGIN
      seperator;
      append('--   PVCS Identifiers :-');
      append('--');
      append('--       pvcsid           : ' || chr(36) || 'Header:' || chr(36) || '');
      append('--       Module Name      : ' || chr(36) || 'Workfile:' || chr(36) || '');
      append('--       Date into PVCS   : ' || chr(36) || 'Date:' || chr(36) || '');
      append('--       Date fetched Out : ' || chr(36) || 'Modtime:' || chr(36) || '');
      append('--       PVCS Version     : ' || chr(36) || 'Revision:' || chr(36) || '');
      append('--');
      append('--');
      append('--   Author : Jonathan Mills');
      append('--');
      append('--   Generated package DO NOT MODIFY');
      append('--');
      append('--   '||g_package_name||' header : '||get_version);
      append('--   '||g_package_name||' body   : '||get_body_version);
      seperator;
      append('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
      seperator;
   END pvcs_tags;
--
   PROCEDURE build_top_of_package_header (p_package_name IN     varchar2
                                         ,p_tab_vc       IN OUT tab_varchar32767
                                         ) IS
   BEGIN
      append ('CREATE OR REPLACE PACKAGE '||p_package_name||' IS');
      append ('--<PACKAGE>');
      pvcs_tags;
      append('--</PACKAGE>');
      append('--<GLOBVAR>');
      append('   g_sccsid          CONSTANT  VARCHAR2(2000) := '||string('"' || chr(36) || 'Revision:' || chr(36) || '"')||';');
      append('--  g_sccsid is the SCCS ID for the package');
      append('--');
      append('--</GLOBVAR>');
      seperator;
      append('--<PROC NAME="GET_VERSION">');
      append('-- This function returns the current SCCS version');
      append('FUNCTION get_version RETURN varchar2;');
      append('--</PROC>');
      seperator;
      append('--<PROC NAME="GET_BODY_VERSION">');
      append('-- This function returns the current SCCS version of the package body');
      append('FUNCTION get_body_version RETURN varchar2;');
      append('--</PROC>');
      --
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => p_tab_vc
                              );
      g_current_tab_vc.DELETE;
   END build_top_of_package_header;
   PROCEDURE build_top_of_package_body (p_package_name IN     varchar2
                                       ,p_tab_vc       IN OUT tab_varchar32767
                                       ) IS
   BEGIN
      append ('CREATE OR REPLACE PACKAGE BODY '||p_package_name||' IS');
      pvcs_tags;
      append('   g_body_sccsid CONSTANT  VARCHAR2(2000) := '||string('"' || chr(36) || 'Revision:' || chr(36) || '"')||';');
      append('--  g_body_sccsid is the SCCS ID for the package body');
      append('--');
      append('   g_package_name    CONSTANT  varchar2(30)   := '||string(p_package_name)||';');
      seperator;
      append('FUNCTION get_version RETURN varchar2 IS');
      append('BEGIN');
      append('   RETURN g_sccsid;');
      append('END get_version;');
      seperator;
      append('FUNCTION get_body_version RETURN varchar2 IS');
      append('BEGIN');
      append('   RETURN g_body_sccsid;');
      append('END get_body_version;');
      --
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => p_tab_vc
                              );
      g_current_tab_vc.DELETE;
   END build_top_of_package_body;
   PROCEDURE build_bottom_of_package (p_package_name IN     varchar2
                                     ,p_header       IN     boolean
                                     ,p_tab_vc       IN OUT tab_varchar32767
                                     ) IS
   BEGIN
      seperator;
      IF p_header
       THEN
         append('--<PRAGMA>');
         append('   PRAGMA RESTRICT_REFERENCES (get_version, RNDS, WNPS, WNDS);');
         append('   PRAGMA RESTRICT_REFERENCES (get_body_version, RNDS, WNPS, WNDS);');
         append('--</PRAGMA>');
         seperator;
      END IF;
      append ('END '||p_package_name||';');
      append ('/');
----
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => p_tab_vc
                              );
      g_current_tab_vc.DELETE;
   END build_bottom_of_package;
   PROCEDURE write_file (p_filename varchar2
                        ,p_tab_vc   tab_varchar32767
                        ) IS
   BEGIN
      create_file (location     => get_sysopt('UTLFILEDIR') 
	             ,filename     => p_filename
                 ,max_linesize => 32767
                 ,all_lines    => p_tab_vc
                 );
      l_tab_names(l_tab_names.COUNT+1) := p_filename;
   END write_file;
BEGIN
--
   g_current_tab_vc.DELETE;
   g_tab_get_header.DELETE;
   g_tab_get_body.DELETE;
   g_tab_ins_header.DELETE;
   g_tab_ins_body.DELETE;
   g_tab_lock_header.DELETE;
   g_tab_lock_body.DELETE;
   g_tab_del_header.DELETE;
   g_tab_del_body.DELETE;
   g_tab_debug_header.DELETE;
   g_tab_debug_body.DELETE;
   g_tab_seq_header.DELETE;
   g_tab_seq_body.DELETE;
--
   build_top_of_package_header (c_get_package,g_tab_get_header);
   build_top_of_package_body   (c_get_package,g_tab_get_body);
   build_top_of_package_header (c_del_package,g_tab_del_header);
   build_top_of_package_body   (c_del_package,g_tab_del_body);
   build_top_of_package_header (c_lock_package,g_tab_lock_header);
   build_top_of_package_body   (c_lock_package,g_tab_lock_body);
   build_top_of_package_header (c_ins_package,g_tab_ins_header);
   build_top_of_package_body   (c_ins_package,g_tab_ins_body);
   build_top_of_package_header (c_debug_package,g_tab_debug_header);
   build_top_of_package_body   (c_debug_package,g_tab_debug_body);
   build_top_of_package_header (c_seq_package,g_tab_seq_header);
   build_top_of_package_body   (c_seq_package,g_tab_seq_body);
--
   FOR i IN 1..g_tab_table.COUNT
    LOOP
      generate_one (g_tab_table(i),g_tab_base_table_for_dt(i));
   END LOOP;
   --
   do_sequences;
   --
   build_bottom_of_package (c_get_package,TRUE,g_tab_get_header);
   build_bottom_of_package (c_get_package,FALSE,g_tab_get_body);
   build_bottom_of_package (c_del_package,TRUE,g_tab_del_header);
   build_bottom_of_package (c_del_package,FALSE,g_tab_del_body);
   build_bottom_of_package (c_lock_package,TRUE,g_tab_lock_header);
   build_bottom_of_package (c_lock_package,FALSE,g_tab_lock_body);
   build_bottom_of_package (c_ins_package,TRUE,g_tab_ins_header);
   build_bottom_of_package (c_ins_package,FALSE,g_tab_ins_body);
   build_bottom_of_package (c_debug_package,TRUE,g_tab_debug_header);
   build_bottom_of_package (c_debug_package,FALSE,g_tab_debug_body);
   build_bottom_of_package (c_seq_package,TRUE,g_tab_seq_header);
   build_bottom_of_package (c_seq_package,FALSE,g_tab_seq_body);
--
   write_file (c_get_package||c_pkh, g_tab_get_header);
   write_file (c_del_package||c_pkh, g_tab_del_header);
   write_file (c_lock_package||c_pkh, g_tab_lock_header);
   write_file (c_ins_package||c_pkh, g_tab_ins_header);
   write_file (c_debug_package||c_pkh, g_tab_debug_header);
   write_file (c_seq_package||c_pkh, g_tab_seq_header);
--
   write_file (c_get_package||c_pkb, g_tab_get_body);
   write_file (c_del_package||c_pkb, g_tab_del_body);
   write_file (c_lock_package||c_pkb, g_tab_lock_body);
   write_file (c_ins_package||c_pkb, g_tab_ins_body);
   write_file (c_debug_package||c_pkb, g_tab_debug_body);
   write_file (c_seq_package||c_pkb, g_tab_seq_body);
--
   l_tab_resv(1) := '# remember to convert this file to UNIX format before running';
   l_tab_repl(1) := l_tab_resv(1);
   FOR i IN 1..l_tab_names.COUNT
    LOOP
      --
      l_tab_load(l_tab_load.COUNT+1) := 'PROMPT '||l_tab_names(i);
      l_tab_load(l_tab_load.COUNT+1) := '@@'||l_tab_names(i);
      l_tab_load(l_tab_load.COUNT+1) := 'sho err';
      --
      l_tab_resv(l_tab_resv.COUNT+1) := 'resv '||l_tab_names(i);
      l_tab_resv(l_tab_resv.COUNT+1) := 'chmod 777 '||l_tab_names(i);
      --
      l_tab_repl(l_tab_repl.COUNT+1) := 'repl -y Generated '||l_tab_names(i);
      l_tab_repl(l_tab_repl.COUNT+1) := 'fetch '||l_tab_names(i);
      l_tab_repl(l_tab_repl.COUNT+1) := 'chmod 777 '||l_tab_names(i);
      --
   END LOOP;
--
   IF c_package_prefix != c_nm3_package_prefix
    THEN
      l_filename := g_package_name||'_'||c_package_prefix;
   ELSE
      l_filename := g_package_name;
   END IF;
--
   write_file (l_filename||'.sql', l_tab_load);
   write_file (l_filename||'_resv.sh', l_tab_resv);
   write_file (l_filename||'_repl.sh', l_tab_repl);
--
END generate_from_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_one (p_table_name varchar2
                       ,p_base_table varchar2
                       ) IS
--
   c_raise_not_found   CONSTANT varchar2(30) := 'pi_raise_not_found';
   c_not_found_sqlcode CONSTANT varchar2(30) := 'pi_not_found_sqlcode';
   c_locked_sqlcode    CONSTANT varchar2(30) := 'pi_locked_sqlcode';
   c_table_name CONSTANT varchar2(30) := LOWER(p_table_name);
   l_alias               varchar2(30);
   l_create_lock         boolean;
--
   l_tab_cols            tab_rec_atc;
   l_tab_pks             tab_varchar30;
   l_tab_pk_indexes      tab_varchar30;
   l_tab_pk_cols         tab_varchar30;
   l_tab_pk_cols_orig    tab_varchar30;
--
   l_max_col_len         pls_integer := 0;
   l_max_pk_col_len      pls_integer := 0;
   l_max_pk_attr_len     pls_integer := 0;

   l_proc_name             varchar2(30);
   l_constraint_name       varchar2(30);
   l_constraint_index_name varchar2(30);
--
   l_start               varchar2(100);
   l_start2              varchar2(100);
   l_indent              varchar2(100);
   l_end                 varchar2(100);
--
   l_loop_count             pls_integer := 1;
   l_current_dt_loop_count  pls_integer;
   l_without_start_date     boolean;
--
   PROCEDURE raise_error_with_params (pi_appl    varchar2 DEFAULT 'nm3type.c_hig'
                                     ,pi_id      number   DEFAULT 67
                                     ,pi_sqlcode varchar2 DEFAULT c_not_found_sqlcode
                                     ) IS
   BEGIN
      append ('      hig.raise_ner (pi_appl               => '||pi_appl);
      append ('                    ,pi_id                 => '||pi_id);
      append ('                    ,pi_sqlcode            => '||pi_sqlcode);
      append ('                    ,pi_supplementary_info => '||string(c_table_name||' ('||l_constraint_name||')'));
      FOR i IN 1..l_tab_pk_cols.COUNT
       LOOP
         append ('                                              ||CHR(10)||'
                 ||string(RPAD(l_tab_pk_cols(i),l_max_pk_col_len)||' => ')
                 ||'||'||'pi_'||SUBSTR(l_tab_pk_cols(i),1,27)
                );
      END LOOP;
      append ('                    );');
   END raise_error_with_params;
--
   PROCEDURE build_get_params (p_body boolean
                              ,p_type varchar2
                              ,p_type_for_comment varchar2 DEFAULT NULL
                              ) IS
      l_is varchar2(3) := ';';
      l_func_or_proc varchar2(11) := 'FUNCTION ';
      l_without      varchar2(40) := NULL;
   BEGIN
      l_max_pk_attr_len := GREATEST(l_max_pk_attr_len
                                   ,LENGTH(c_raise_not_found)
                                   ,LENGTH(c_not_found_sqlcode)
                                   );
      IF p_body
       THEN
         l_is := ' IS';
      END IF;
      IF p_type = 'DEL'
       THEN
         l_func_or_proc := 'PROCEDURE ';
      END IF;
      IF l_without_start_date
       THEN
         l_without := ' (without start date for Datetrack View)';
      END IF;
      append ('--');
      append ('--   '||INITCAP(l_func_or_proc)||'to '||LOWER(NVL(p_type_for_comment,p_type))||' using '||l_constraint_name||' constraint'||l_without);
      append ('--');
      l_start     := l_func_or_proc||l_proc_name||' (';
      l_indent    := RPAD(' ',LENGTH(l_func_or_proc)+1+LENGTH(l_proc_name),' ');
      FOR i IN 1..l_tab_pk_cols.COUNT
       LOOP
         append (l_start||RPAD('pi_'||SUBSTR(l_tab_pk_cols(i),1,27),l_max_pk_attr_len)||' '||c_table_name||'.'||l_tab_pk_cols(i)||'%TYPE');
         l_start := l_indent||',';
      END LOOP;
      l_start := l_indent||',';
      append (l_start||RPAD(c_raise_not_found,l_max_pk_attr_len)  ||' BOOLEAN     DEFAULT TRUE');
      append (l_start||RPAD(c_not_found_sqlcode,l_max_pk_attr_len)||' PLS_INTEGER DEFAULT -20000');
      IF p_type = 'GET'
       THEN
         append (l_indent||') RETURN '||c_table_name||'%ROWTYPE'||l_is);
      ELSIF p_type = 'LOCK'
       THEN
         append (l_start||RPAD(c_locked_sqlcode,l_max_pk_attr_len)||' PLS_INTEGER DEFAULT -20000');
         append (l_indent||') RETURN ROWID'||l_is);
      ELSIF p_type = 'DEL'
       THEN
         append (l_start||RPAD(c_locked_sqlcode,l_max_pk_attr_len)||' PLS_INTEGER DEFAULT -20000');
         append (l_indent||')'||l_is);
      END IF;
   END build_get_params;
--
   PROCEDURE build_get_header (p_con_count pls_integer) IS
   BEGIN
      IF p_con_count = 1
       AND l_current_dt_loop_count = 1
       THEN
         seperator;
         append ('--<PROC NAME="'||l_proc_name||'">');
      END IF;
      build_get_params (FALSE,'GET');
      append('PRAGMA RESTRICT_REFERENCES ('||l_proc_name||', WNPS, WNDS);');
      IF p_con_count = l_tab_pks.COUNT
       AND l_loop_count = l_current_dt_loop_count
       THEN
         append ('--</PROC>');
      END IF;
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_get_header
                              );
      g_current_tab_vc.DELETE;
   END build_get_header;
   --
   PROCEDURE do_where_clause (p_lock boolean DEFAULT FALSE) IS
   BEGIN
      l_start := '   WHERE  ';
      l_end   := NULL;
      FOR i IN 1..l_tab_pk_cols.COUNT
       LOOP
         IF i = l_tab_pk_cols.COUNT
          AND NOT p_lock
          THEN
            l_end := ';';
         END IF;
         append (l_start||l_alias||'.'||RPAD(l_tab_pk_cols(i),l_max_pk_col_len)||' = '||'pi_'||SUBSTR(l_tab_pk_cols(i),1,27)||l_end);
         l_start := '    AND   ';
      END LOOP;
      IF p_lock
       THEN
         append ('   FOR UPDATE NOWAIT;');
      END IF;
   END do_where_clause;
--
   PROCEDURE build_get_body IS
   BEGIN
      seperator;
      build_get_params (TRUE,'GET');
      append ('--');
      append ('   CURSOR cs_'||l_alias||' IS');
      append ('   SELECT /*+ INDEX ('||l_alias||' '||l_constraint_index_name||') */ *');
      append ('    FROM  '||c_table_name||' '||l_alias);
      do_where_clause;
      append ('--');
      append ('   l_found  BOOLEAN;');
      append ('   l_retval '||c_table_name||'%ROWTYPE;');
      append ('--');
      append ('BEGIN');
      append ('--');
      append ('   nm_debug.proc_start(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('   OPEN  cs_'||l_alias||';');
      append ('   FETCH cs_'||l_alias||' INTO l_retval;');
      append ('   l_found := cs_'||l_alias||'%FOUND;');
      append ('   CLOSE cs_'||l_alias||';');
      append ('--');
      append ('   IF '||c_raise_not_found||' AND NOT l_found');
      append ('    THEN');
      raise_error_with_params;
      append ('   END IF;');
      append ('--');
      append ('   nm_debug.proc_end(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('   RETURN l_retval;');
      append ('--');
      append ('END '||l_proc_name||';');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_get_body
                              );
      g_current_tab_vc.DELETE;
   END build_get_body;
--
   PROCEDURE build_del_header (p_con_count pls_integer) IS
   BEGIN
      IF p_con_count = 1
       AND l_current_dt_loop_count = 1
       THEN
         seperator;
         append ('--<PROC NAME="'||l_proc_name||'">');
      END IF;
      build_get_params (FALSE,'DEL');
      IF p_con_count = l_tab_pks.COUNT
       AND l_loop_count = l_current_dt_loop_count
       THEN
         append ('--</PROC>');
      END IF;
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_del_header
                              );
      g_current_tab_vc.DELETE;
   END build_del_header;
--
   PROCEDURE build_del_body IS
   BEGIN
      seperator;
      build_get_params (TRUE,'DEL');
      IF l_create_lock
       THEN
         append ('   l_rowid ROWID;');
      END IF;
      append ('BEGIN');
      append ('--');
      append ('   nm_debug.proc_start(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      IF l_create_lock
       THEN
         append ('   -- Lock the row first');
         append ('   l_rowid := '||c_lock_package||'.lock_'||l_alias);
         l_start     := '(';
         l_indent    := RPAD(' ',19,' ');
         FOR i IN 1..l_tab_pk_cols.COUNT
          LOOP
            append (l_indent||l_start||RPAD('pi_'||SUBSTR(l_tab_pk_cols(i),1,27),l_max_pk_attr_len)||' => '||'pi_'||SUBSTR(l_tab_pk_cols(i),1,27));
            l_start := ',';
         END LOOP;
         append (l_indent||','||RPAD(c_raise_not_found,l_max_pk_attr_len)||' => '||c_raise_not_found);
         append (l_indent||','||RPAD(c_not_found_sqlcode,l_max_pk_attr_len)||' => '||c_not_found_sqlcode);
         append (l_indent||','||RPAD(c_locked_sqlcode,l_max_pk_attr_len)||' => '||c_locked_sqlcode);
         append (l_indent||');');
         append ('--');
         append ('   IF l_rowid IS NOT NULL');
         append ('    THEN');
         append ('      DELETE '||c_table_name||' '||l_alias);
         append ('      WHERE ROWID = l_rowid;');
         append ('   END IF;');
      ELSE
         append ('   -- No lock procedure - a temporary table');
         append ('   DELETE /*+ INDEX ('||l_alias||' '||l_constraint_index_name||') */ '||c_table_name||' '||l_alias);
         do_where_clause;
         append ('   IF SQL%ROWCOUNT = 0 AND '||c_raise_not_found);
         append ('    THEN');
         raise_error_with_params;
         append ('   END IF;');
      append ('--');
      END IF;
      append ('--');
      append ('   nm_debug.proc_end(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('END '||l_proc_name||';');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_del_body
                              );
      g_current_tab_vc.DELETE;
   END build_del_body;
--
   PROCEDURE build_lock_header (p_con_count pls_integer) IS
   BEGIN
      IF p_con_count = 1
       AND l_current_dt_loop_count = 1
       THEN
         seperator;
         append ('--<PROC NAME="'||l_proc_name||'">');
      END IF;
      build_get_params (FALSE,'LOCK');
      build_get_params (FALSE,'DEL','LOCK');
      IF   p_con_count  = l_tab_pks.COUNT
       AND l_loop_count = l_current_dt_loop_count
       THEN
         append ('--</PROC>');
      END IF;
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_lock_header
                              );
      g_current_tab_vc.DELETE;
   END build_lock_header;
--
   PROCEDURE build_lock_body IS
   BEGIN
      seperator;
      build_get_params (TRUE,'LOCK');
      append ('--');
      append ('   CURSOR cs_'||l_alias||' IS');
      append ('   SELECT /*+ INDEX ('||l_alias||' '||l_constraint_index_name||') */ ROWID');
      append ('    FROM  '||c_table_name||' '||l_alias);
      do_where_clause(TRUE);
      append ('--');
      append ('   l_found         BOOLEAN;');
      append ('   l_retval        ROWID;');
      append ('   l_record_locked EXCEPTION;');
      append ('   PRAGMA EXCEPTION_INIT (l_record_locked,-54);');
      append ('--');
      append ('BEGIN');
      append ('--');
      append ('   nm_debug.proc_start(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('   OPEN  cs_'||l_alias||';');
      append ('   FETCH cs_'||l_alias||' INTO l_retval;');
      append ('   l_found := cs_'||l_alias||'%FOUND;');
      append ('   CLOSE cs_'||l_alias||';');
      append ('--');
      append ('   IF '||c_raise_not_found||' AND NOT l_found');
      append ('    THEN');
      raise_error_with_params;
      append ('   END IF;');
      append ('--');
      append ('   nm_debug.proc_end(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('   RETURN l_retval;');
      append ('--');
      append ('EXCEPTION');
      append ('--');
      append ('   WHEN l_record_locked');
      append ('    THEN');
      raise_error_with_params(pi_id      => 33
                             ,pi_sqlcode => c_locked_sqlcode
                             );
      append ('--');
      append ('END '||l_proc_name||';');
      seperator;
      build_get_params (TRUE,'DEL','LOCK');
      append ('--');
      append ('   l_rowid ROWID;');
      append ('--');
      append ('BEGIN');
      append ('--');
      append ('   nm_debug.proc_start(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('   l_rowid := '||l_proc_name);
      l_start     := '(';
      l_indent    := RPAD(' ',19,' ');
      FOR i IN 1..l_tab_pk_cols.COUNT
       LOOP
         append (l_indent||l_start||RPAD('pi_'||SUBSTR(l_tab_pk_cols(i),1,27),l_max_pk_attr_len)||' => '||'pi_'||SUBSTR(l_tab_pk_cols(i),1,27));
         l_start := ',';
      END LOOP;
      append (l_indent||','||RPAD(c_raise_not_found,l_max_pk_attr_len)||' => '||c_raise_not_found);
      append (l_indent||','||RPAD(c_not_found_sqlcode,l_max_pk_attr_len)||' => '||c_not_found_sqlcode);
      append (l_indent||');');
      append ('--');
      append ('   nm_debug.proc_end(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('END '||l_proc_name||';');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_lock_body
                              );
      g_current_tab_vc.DELETE;
   END build_lock_body;
--
   PROCEDURE build_ins_header IS
   BEGIN
      seperator;
      append ('--<PROC NAME="'||l_proc_name||'">');
      append ('-- Inserts a ROWTYPE record into '||c_table_name);
      append ('-- Returns the ROWTYPE record as inserted - trigger modified values');
      append ('--');
      append ('PROCEDURE '||l_proc_name||' (p_rec_'||l_alias||' IN OUT '||c_table_name||'%ROWTYPE);');
      append ('--</PROC>');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_ins_header
                              );
      g_current_tab_vc.DELETE;
   END build_ins_header;
--
   PROCEDURE build_ins_body IS
      l_rec_name varchar2(30) := 'p_rec_'||l_alias;
      l_returning_col tab_varchar30;
      l_base_alias   varchar2(30) := LOWER(get_alias_from_array (p_base_table));
   BEGIN
      seperator;
      append ('PROCEDURE '||l_proc_name||' ('||l_rec_name||' IN OUT '||c_table_name||'%ROWTYPE) IS');
      append ('BEGIN');
      append ('--');
      append ('   nm_debug.proc_start(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      FOR i IN 1..l_tab_cols.COUNT
       LOOP
         IF l_tab_cols(i).data_default IS NOT NULL
          THEN
           l_start := 'NVL(';
           l_end   := ','||l_tab_cols(i).data_default||')';
         ELSE
           l_start := NULL;
           l_end   := NULL;
         END IF;
         IF l_start IS NOT NULL
          THEN
            append ('   '||l_rec_name||'.'||RPAD(LOWER(l_tab_cols(i).column_name),30)||' := '||l_start||l_rec_name||'.'||LOWER(l_tab_cols(i).column_name)||l_end||';');
         END IF;
      END LOOP;
      append ('--');
      append ('   INSERT INTO '||c_table_name);
      l_indent := '            (';
      FOR i IN 1..l_tab_cols.COUNT
       LOOP
         append (l_indent||LOWER(l_tab_cols(i).column_name));
         l_indent := '            ,';
      END LOOP;
      append ('            )');
      l_indent := '     VALUES (';
      FOR i IN 1..l_tab_cols.COUNT
       LOOP
         append (l_indent||l_rec_name||'.'||LOWER(l_tab_cols(i).column_name));
         l_indent := '            ,';
         --
         IF l_tab_cols(i).data_type IN ('VARCHAR2','DATE','NUMBER','CHAR')
          THEN -- Can we use this in the RETURNING clause
            l_returning_col(l_returning_col.COUNT+1) := LOWER(l_tab_cols(i).column_name);
         END IF;
         --
      END LOOP;
      IF l_returning_col.COUNT = 0
       THEN
         append ('            );');
      ELSE
         IF p_table_name != p_base_table
          THEN
            append ('            );');
            append ('--');
            append ('   '||l_rec_name||' := '||c_get_package||'.get_'||l_alias);
            l_start     := '(';
            l_indent    := RPAD(' ',19,' ');
            FOR i IN 1..l_tab_pk_cols_orig.COUNT
             LOOP
               append (l_indent||l_start||RPAD('pi_'||SUBSTR(l_tab_pk_cols_orig(i),1,27),l_max_pk_attr_len)||' => '||l_rec_name||'.'||l_tab_pk_cols_orig(i));
               l_start := ',';
            END LOOP;
            append (l_indent||','||RPAD(c_raise_not_found,l_max_pk_attr_len)||' => FALSE');
            append (l_indent||');');
         ELSE
            append ('            )');
            l_indent := '   RETURNING ';
            FOR i IN 1..l_returning_col.COUNT
             LOOP
               append (l_indent||l_returning_col(i));
               l_indent := '            ,';
            END LOOP;
            l_indent := '      INTO   ';
            l_end    := NULL;
            FOR i IN 1..l_returning_col.COUNT
             LOOP
               IF i = l_returning_col.COUNT
                THEN
                  l_end := ';';
               END IF;
               append (l_indent||l_rec_name||'.'||l_returning_col(i)||l_end);
               l_indent := '            ,';
            END LOOP;
         END IF;
      END IF;
      append ('--');
      append ('   nm_debug.proc_end(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('END '||l_proc_name||';');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_ins_body
                              );
      g_current_tab_vc.DELETE;
   END build_ins_body;
--
   PROCEDURE build_debug_header IS
   BEGIN
      seperator;
      append ('--<PROC NAME="'||l_proc_name||'">');
      append ('-- Debug a ROWTYPE record');
      append ('PROCEDURE '||l_proc_name||' (pi_rec_'||l_alias||' '||c_table_name||'%ROWTYPE,p_level PLS_INTEGER DEFAULT 3);');
      append ('--</PROC>');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_debug_header
                              );
      g_current_tab_vc.DELETE;
   END build_debug_header;
--
   PROCEDURE build_debug_body IS
      l_rec_name varchar2(30) := 'pi_rec_'||l_alias;
   BEGIN
      seperator;
      append ('PROCEDURE '||l_proc_name||' ('||l_rec_name||' '||c_table_name||'%ROWTYPE,p_level PLS_INTEGER DEFAULT 3) IS');
      append ('BEGIN');
      append ('--');
      append ('   nm_debug.proc_start(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      FOR i IN 1..l_tab_cols.COUNT
       LOOP
         IF l_tab_cols(i).data_type IN ('VARCHAR2','DATE','NUMBER')
          THEN
            append ('   nm_debug.debug('||string(RPAD(LOWER(l_tab_cols(i).column_name),l_max_col_len,' ')||' : ')||'||'||l_rec_name||'.'||LOWER(l_tab_cols(i).column_name)||',p_level);');
         END IF;
      END LOOP;
      append ('--');
      append ('   nm_debug.proc_end(g_package_name,'||string(l_proc_name)||');');
      append ('--');
      append ('END '||l_proc_name||';');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_debug_body
                              );
      g_current_tab_vc.DELETE;
   END build_debug_body;
--
BEGIN
--
   l_alias       := LOWER(get_alias_from_array (p_table_name));
--
   l_create_lock := create_lock_procedure   (p_table_name);
   l_tab_cols    := get_columns (p_table_name => p_table_name
                                ,p_base_table => p_base_table
                                );
   get_primary_unique_cons (pi_table_name           => p_base_table
                           ,po_tab_constraint_name  => l_tab_pks
                           ,po_tab_constraint_index => l_tab_pk_indexes
                           );
--
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      IF LENGTH(l_tab_cols(i).column_name) > l_max_col_len
       THEN
         l_max_col_len := LENGTH(l_tab_cols(i).column_name);
      END IF;
   END LOOP;
--
   IF p_table_name != p_base_table
    THEN
      l_loop_count := 2;
   END IF;
--
   FOR q IN 1..l_loop_count
    LOOP
      --
      l_current_dt_loop_count := q;
      l_without_start_date    := (l_current_dt_loop_count=2);
      --
      FOR j IN 1..l_tab_pks.COUNT
       LOOP
         BEGIN
            l_constraint_name       := l_tab_pks(j);
            l_constraint_index_name := l_tab_pk_indexes(j);
--
            --
            -- If this is the second time through here then this is
            --  for a view with a base table (i.e. a date-based view) so remove any _START_DATE cols mentioned in
            --  a PK
            --
            l_tab_pk_cols     := get_pk_columns (l_constraint_name,l_without_start_date);
            IF   q = 1
             AND j = 1
             THEN
               l_tab_pk_cols_orig := l_tab_pk_cols;
            END IF;
            l_max_pk_col_len  := 0;
            FOR i IN 1..l_tab_pk_cols.COUNT
             LOOP
               IF LENGTH(l_tab_pk_cols(i)) > l_max_pk_col_len
                THEN
                  l_max_pk_col_len := LENGTH(l_tab_pk_cols(i));
               END IF;
            END LOOP;
            l_max_pk_attr_len := LEAST (l_max_pk_col_len+3,30);
         --
            l_proc_name := 'get_'||l_alias;
            build_get_header(j);
            build_get_body;
            --
            l_proc_name := 'del_'||l_alias;
            build_del_header(j);
            build_del_body;
            --
            IF l_create_lock
             THEN
               l_proc_name := 'lock_'||l_alias;
               build_lock_header(j);
               build_lock_body;
            END IF;
         EXCEPTION
            WHEN g_start_date_not_in_pk_ignore
             THEN
               NULL; -- Start date wasnt in this PK/UK - therefore we've already done it
            WHEN g_pk_no_cols
             THEN
               NULL; -- Start date was the only column in this PK/UK - therefore we've already done it
         END;
   --
      END LOOP;
   END LOOP;
--
   IF g_insert_allowed
    THEN
      l_proc_name := 'ins_'||l_alias;
      build_ins_header;
      build_ins_body;
   END IF;
--
   l_proc_name := 'debug_'||l_alias;
   build_debug_header;
   build_debug_body;
--
END generate_one;
--
-----------------------------------------------------------------------------
--
FUNCTION create_lock_procedure (p_table_name varchar2) RETURN boolean IS
--
   CURSOR cs_at (c_table varchar2
                ) IS
   SELECT table_name
         ,TEMPORARY
    FROM  all_tables
   WHERE  owner      = Sys_Context('NM3_SECURITY_CTX','USERNAME')
    AND   table_name = c_table;
--
   l_at cs_at%ROWTYPE;
--
   CURSOR cs_av (c_view  varchar2
                ) IS
   SELECT view_name
    FROM  all_views
   WHERE  owner     = Sys_Context('NM3_SECURITY_CTX','USERNAME')
    AND   view_name = c_view;
--
   l_av     cs_av%ROWTYPE;
--
   l_retval boolean;
   l_found  boolean;
--
BEGIN
--
   g_insert_allowed := TRUE;
--
   OPEN  cs_at (p_table_name);
   FETCH cs_at INTO l_at;
   l_found := cs_at%FOUND;
   CLOSE cs_at;
--
   IF NOT l_found
    THEN
      OPEN  cs_av ( p_table_name);
      FETCH cs_av INTO l_av;
      l_found  := cs_av%FOUND;
      CLOSE cs_av;
      IF NOT l_found
       THEN
         RAISE_APPLICATION_ERROR(20000,  'Record not found - ALL_TABLES/ALL_VIEWS owner : '||Sys_Context('NM3_SECURITY_CTX','USERNAME')||' name : '||p_table_name);
      END IF;
      --
      -- This is a view - see if we can select a rowid from there - if so we will be able to create the lock procedure
      --
      DECLARE
         l_not_key_preserved EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_not_key_preserved,-1445);
               TYPE ref_cursor IS REF CURSOR;
               l_cur   ref_cursor;
               l_sql   varchar2(2000);
               l_dummy rowid;
      BEGIN
         l_sql :=            'SELECT ROWID'
                  ||CHR(10)||' FROM  '||p_table_name
                  ||CHR(10)||'WHERE  ROWNUM = 1';
         OPEN  l_cur FOR  l_sql;
         FOR i IN 1..3
          LOOP
            DECLARE
               l_failed_exec_policy EXCEPTION;
               PRAGMA EXCEPTION_INIT (l_failed_exec_policy,-28112);
            BEGIN
               FETCH l_cur INTO l_dummy;
               l_retval         := TRUE;
               g_insert_allowed := TRUE;
               EXIT;
            EXCEPTION
               WHEN l_failed_exec_policy
                THEN
                  IF i = 3
                   THEN
                     l_retval         := FALSE;
                     g_insert_allowed := FALSE;
                     dbms_output.put_line(p_table_name);
                     RAISE;
                  END IF;
            END;
         END LOOP;
         CLOSE l_cur;
      EXCEPTION
         WHEN l_not_key_preserved
          THEN
            l_retval         := FALSE;
            g_insert_allowed := FALSE;
            IF l_cur%isopen
             THEN
               CLOSE l_cur;
            END IF;
      END;
      --
      IF NOT g_insert_allowed
       THEN
         -- We may still be allowed to insert by virtue of an INSTEAD OF INSERT trigger being there
         DECLARE
            CURSOR cs_trig IS
            SELECT 1
             FROM  all_triggers
            WHERE  owner        = Sys_Context('NM3_SECURITY_CTX','USERNAME')
             AND   table_name   = p_table_name
             AND   trigger_type = 'INSTEAD OF'
             AND   triggering_event LIKE '%INSERT%';
            l_dummy pls_integer;
         BEGIN
            OPEN  cs_trig;
            FETCH cs_trig INTO l_dummy;
            g_insert_allowed := cs_trig%FOUND;
            CLOSE cs_trig;
         END;
      END IF;
      --
   ELSE
      l_retval := NOT (l_at.TEMPORARY = 'Y');
   END IF;
--
   RETURN l_retval;
--
END create_lock_procedure;
--
-----------------------------------------------------------------------------
--
FUNCTION get_columns (p_table_name varchar2
                     ,p_base_table varchar2
                     ) RETURN tab_rec_atc IS
--
   CURSOR cs_columns (c_table varchar2
                     ) IS
   SELECT *
    FROM  all_tab_columns
   WHERE  owner      = Sys_Context('NM3_SECURITY_CTX','USERNAME')
    AND   table_name = c_table
   ORDER BY column_id;
--
   CURSOR cs_col (c_table varchar2
                 ,c_col   varchar2
                 ) IS
   SELECT data_default
    FROM  all_tab_columns
   WHERE  owner       = Sys_Context('NM3_SECURITY_CTX','USERNAME')
    AND   table_name  = c_table
    AND   column_name = c_col;
--
   l_retval tab_rec_atc;
--
BEGIN
--
   FOR cs_rec IN cs_columns (p_table_name)
    LOOP
      l_retval (cs_columns%rowcount) := cs_rec;
   END LOOP;
--
   IF p_base_table != p_table_name
    THEN
      --
      -- If the base table is different from the table (view) then
      --  get the data default from the base table to be used in the INS_xxxx procedure
      --
      FOR i IN 1..l_retval.COUNT
       LOOP
         OPEN  cs_col (p_base_table, l_retval(i).column_name);
         FETCH cs_col INTO l_retval(i).data_default;
         CLOSE cs_col;
      END LOOP;
   END IF;
--
   RETURN l_retval;
--
END get_columns;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pk_columns (p_constraint_name   varchar2
                        ,p_ignore_start_date boolean DEFAULT FALSE
                        ) RETURN tab_varchar30 IS
--
   CURSOR cs_pk_cols (c_con_name varchar2
                     ) IS
   SELECT LOWER(column_name)
    FROM  all_cons_columns acc
   WHERE  owner              = Sys_Context('NM3_SECURITY_CTX','USERNAME')
    AND   constraint_name    = c_con_name
   ORDER BY position;
--
   l_tab_cols   tab_varchar30;
   l_retval     tab_varchar30;
   l_st_date_found boolean;
--
BEGIN
--
   OPEN  cs_pk_cols ( p_constraint_name);
   FETCH cs_pk_cols BULK COLLECT INTO l_tab_cols;
   CLOSE cs_pk_cols;
--
   IF p_ignore_start_date
    THEN
      l_st_date_found := FALSE;
      FOR i IN 1..l_tab_cols.COUNT
       LOOP
         IF l_tab_cols(i) LIKE '%_start_date'
          THEN
            l_st_date_found := TRUE;
         ELSE
            l_retval(l_retval.COUNT+1) := l_tab_cols(i);
         END IF;
      END LOOP;
      IF l_retval.COUNT = 0
       THEN
         RAISE g_pk_no_cols;
      ELSIF NOT l_st_date_found
       THEN
         RAISE g_start_date_not_in_pk_ignore;
      END IF;
   ELSE
      l_retval := l_tab_cols;
   END IF;
--
   RETURN l_retval;
--
END get_pk_columns;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_primary_unique_cons (pi_table_name           IN     varchar2
                                  ,po_tab_constraint_name     OUT tab_varchar30
                                  ,po_tab_constraint_index    OUT tab_varchar30
                                  ) IS
--
   CURSOR cs_pk (c_table varchar2
                ) IS
   SELECT constraint_name
         ,index_name
    FROM  all_constraints  ac
   WHERE  ac.owner           = Sys_Context('NM3_SECURITY_CTX','USERNAME')
    AND   ac.table_name      = c_table
    AND   ac.constraint_type IN ('P','U')
   ORDER BY ac.constraint_type ASC;
--
BEGIN
--
   OPEN  cs_pk (pi_table_name);
   FETCH cs_pk
    BULK COLLECT
    INTO po_tab_constraint_name, po_tab_constraint_index;
   CLOSE cs_pk;
--
END get_primary_unique_cons;
--
-----------------------------------------------------------------------------
--
FUNCTION get_alias_from_array (p_table_name varchar2) RETURN varchar2 IS
--
   l_retval varchar2(30);
--
BEGIN
--
   FOR i IN 1..g_table_count
    LOOP
      IF p_table_name = g_tab_table(i)
       THEN
         l_retval := g_tab_prefix(i);
         EXIT;
      END IF;
   END LOOP;
--
   IF l_retval IS NULL
    THEN
      RAISE_APPLICATION_ERROR(20000, 'Cannot generate get_ function for '||p_table_name);
   END IF;
--
   RETURN l_retval;
--
END get_alias_from_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_tab_vc_to_tab_vc (p_tab_vc_in  IN     tab_varchar32767
                                  ,p_tab_vc_out IN OUT tab_varchar32767
                                  ) IS
--
   l_count pls_integer := p_tab_vc_out.COUNT;
--
BEGIN
--
   FOR i IN 1..p_tab_vc_in.COUNT
    LOOP
      l_count               := l_count + 1;
      p_tab_vc_out(l_count) := p_tab_vc_in(i);
   END LOOP;
--
END append_tab_vc_to_tab_vc;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_text varchar2) IS
--
   l_count pls_integer := g_current_tab_vc.COUNT+1;
--
BEGIN
   g_current_tab_vc(l_count) := p_text;
END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE seperator IS
BEGIN
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--');
END seperator;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_sequences IS
BEGIN
--
   FOR i IN 1..g_tab_seq.COUNT
    LOOP
      do_each_seq (g_tab_seq(i));
   END LOOP;
--
END do_sequences;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_each_seq (pi_seq_name varchar2) IS
--
   l_tab_name         tab_varchar30;
   l_tab_curr_or_next tab_varchar30;
--
   l_proc_name        varchar2(30);
--
BEGIN
--
   l_tab_name (1) := 'next_'||left(LOWER(pi_seq_name),25);
   l_tab_name (2) := 'curr_'||left(LOWER(pi_seq_name),25);
   l_tab_curr_or_next(1) := 'NEXTVAL';
   l_tab_curr_or_next(2) := 'CURRVAL';
--
   FOR i IN 1..2
    LOOP
      l_proc_name := l_tab_name(i);
      seperator;
      append ('--<PROC NAME="'||l_proc_name||'">');
      append ('-- Returns '||pi_seq_name||'.'||l_tab_curr_or_next(i));
      append ('FUNCTION '||l_proc_name||' RETURN PLS_INTEGER;');
      append ('--');
      append ('PRAGMA RESTRICT_REFERENCES ('||l_proc_name||', WNPS, WNDS);');
      append ('--');
      append ('--</PROC>');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_seq_header
                              );
      g_current_tab_vc.DELETE;
      seperator;
      append ('FUNCTION '||l_proc_name||' RETURN PLS_INTEGER IS');
      append ('-- Get '||pi_seq_name||'.'||l_tab_curr_or_next(i));
      append ('   l_retval PLS_INTEGER;');
      append ('BEGIN');
      append ('   SELECT '||pi_seq_name||'.'||l_tab_curr_or_next(i));
      append ('    INTO  l_retval');
      append ('    FROM  dual;');
      append ('   RETURN l_retval;');
      append ('END '||l_proc_name||';');
      append_tab_vc_to_tab_vc (p_tab_vc_in  => g_current_tab_vc
                              ,p_tab_vc_out => g_tab_seq_body
                              );
      g_current_tab_vc.DELETE;
   END LOOP;
--
END do_each_seq;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_package_names (pi_product_name varchar2) IS
BEGIN
--
   IF LENGTH(pi_product_name) > 22
    THEN
      RAISE_APPLICATION_ERROR(20000, 'Invalid string length - LENGTH(pi_product_name) > 22 ('||LENGTH(pi_product_name)||')');
   END IF;
--
   c_package_prefix := pi_product_name;
--
   c_get_package    := c_package_prefix||'get';
   c_del_package    := c_package_prefix||'del';
   c_ins_package    := c_package_prefix||'ins';
   c_lock_package   := c_package_prefix||'lock_gen';
   c_debug_package  := c_package_prefix||'debug';
   c_seq_package    := c_package_prefix||'seq';
--
END set_package_names;
--
-----------------------------------------------------------------------------
--
PROCEDURE generate_other (pi_product_name varchar2
                         ,pi_tab_tables   tab_rec_tab
                         ,pi_tab_seq      tab_varchar30
                         ) IS
BEGIN
--
   IF UPPER(pi_product_name) = UPPER (c_nm3_package_prefix)
    THEN
      RAISE_APPLICATION_ERROR(20000, 'pi_product_name cannot be "'||c_nm3_package_prefix||'"');
   END IF;
--
   set_package_names (pi_product_name => pi_product_name);
--
   g_table_count := 0;
   g_tab_table.DELETE;
   g_tab_prefix.DELETE;
   g_tab_seq.DELETE;
--
   FOR i IN 1..pi_tab_tables.COUNT
    LOOP
      add_tab (p_table  => pi_tab_tables(i).table_name
              ,p_prefix => pi_tab_tables(i).table_alias
              ,p_base   => pi_tab_tables(i).base_table_name
              );
   END LOOP;
--
   FOR i IN 1..pi_tab_seq.COUNT
    LOOP
      add_seq (p_seq => pi_tab_seq(i));
   END LOOP;
--
   generate_from_globals;
--
END generate_other;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_tab (p_table  varchar2
                  ,p_prefix varchar2
                  ,p_base   varchar2 DEFAULT NULL
                  ) IS
--
   PROCEDURE check_table IS
   BEGIN
      IF p_table IS NULL
       THEN
         RAISE_APPLICATION_ERROR(20000, 'TABLE NAME must be supplied');
      END IF;
      FOR i IN 1..g_tab_table.COUNT
       LOOP
         IF UPPER(g_tab_table (i)) = UPPER(p_table)
          THEN
            RAISE_APPLICATION_ERROR(20000, 'TABLE NAME "'||p_prefix||'" already specified');
         END IF;
      END LOOP;
   END check_table;
--
   PROCEDURE check_prefix IS
   BEGIN
      IF p_prefix IS NULL
       THEN
         RAISE_APPLICATION_ERROR(20000, 'TABLE ALIAS');
      END IF;
      FOR i IN 1..g_tab_prefix.COUNT
       LOOP
         IF UPPER(g_tab_prefix (i)) = UPPER(p_prefix)
          THEN
            RAISE_APPLICATION_ERROR(20000, 'TABLE ALIAS "'||p_prefix||'" already specified');
         END IF;
      END LOOP;
   END check_prefix;
--
BEGIN
--
   check_table;
--
   IF c_package_prefix != c_nm3_package_prefix
    THEN
       -- Check non "nm3" data for trustworthiness on the alias
       -- The NM3 data SHOULD go through this as well, but cannot
       --  as there are already duplicate aliases in there
      check_prefix;
   END IF;
--
   g_table_count                          := g_table_count + 1;
   g_tab_table(g_table_count)             := UPPER(p_table);
   g_tab_prefix(g_table_count)            := UPPER(p_prefix);
   g_tab_base_table_for_dt(g_table_count) := UPPER(NVL(p_base,p_table));
--
END add_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_seq (p_seq varchar2) IS
BEGIN
   g_tab_seq (g_tab_seq.COUNT+1) := p_seq;
END add_seq;
--
-----------------------------------------------------------------------------
--
END nm3get_gen;
/
