--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/drop_nm3_cons.sql-arc   2.3   Jul 04 2013 13:45:00   James.Wadsworth  $
--       Module Name      : $Workfile:   drop_nm3_cons.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:00  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:57:38  $
--       Version          : $Revision:   2.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE

CURSOR C1 IS
  SELECT constraint_name, table_name
    FROM user_constraints
   WHERE constraint_type = 'C'
     AND table_name IN 
	 ('ANALYSE_ALL_TABS_LOG'
	 ,'CENTSIZE'
	 ,'COLOURS'
	 ,'DOCS'
	 ,'DOC_ACTIONS'
	 ,'DOC_ACTION_HISTORY'
	 ,'DOC_ASSOCS'
	 ,'DOC_CLASS'
	 ,'DOC_COPIES'
	 ,'DOC_DAMAGE'
	 ,'DOC_DAMAGE_COSTS'
	 ,'DOC_ENQUIRY_CONTACTS'
	 ,'DOC_ENQUIRY_TYPES'
	 ,'DOC_GATEWAYS'
	 ,'DOC_GATE_SYNS'
	 ,'DOC_HISTORY'
	 ,'DOC_KEYS'
	 ,'DOC_KEYWORDS'
	 ,'DOC_LOCATIONS'
	 ,'DOC_LOV_RECS'
	 ,'DOC_MEDIA'
	 ,'DOC_QUERY'
	 ,'DOC_QUERY_COLS'
	 ,'DOC_REDIR_PRIOR'
	 ,'DOC_STD_ACTIONS'
	 ,'DOC_STD_COSTS'
 	 ,'DOC_SYNONYMS'
	 ,'DOC_TEMPLATE_COLUMNS'
	 ,'DOC_TEMPLATE_GATEWAYS'
	 ,'DOC_TEMPLATE_USERS'
	 ,'DOC_TYPES'
	 ,'EXOR_LOCK'
	 ,'EXOR_LSNR'
	 ,'EXOR_PRODUCT_TXT'
	 ,'EXOR_VERSION_TAB'
	 ,'FINANCIAL_YEARS'
	 ,'GIS_DATA_OBJECTS'
	 ,'GIS_PROJECTS'
	 ,'GRI_LOV'
	 ,'GRI_MODULES'
	 ,'GRI_MODULE_PARAMS'
	 ,'GRI_PARAMS'
	 ,'GRI_PARAM_DEPENDENCIES'
	 ,'GRI_PARAM_LOOKUP'
	 ,'GRI_REPORT_RUNS'
	 ,'GRI_RUN_PARAMETERS'
	 ,'GRI_SAVED_PARAMS'
	 ,'GRI_SAVED_SETS'
	 ,'GRI_SPOOL'
	 ,'GROUP_TYPE_ROLES'
	 ,'HIG_ADDRESS'
	 ,'HIG_ADDRESS_POINT'
	 ,'HIG_CHECK_CONSTRAINT_ASSOCS'
	 ,'HIG_CODES'
	 ,'HIG_COLOURS'
	 ,'HIG_CONTACTS'
	 ,'HIG_CONTACT_ADDRESS'
	 ,'HIG_DIRECTORIES'
	 ,'HIG_DIRECTORY_ROLES'
	 ,'HIG_DISCO_BUSINESS_AREAS'
	 ,'HIG_DISCO_COL_VALUES'
	 ,'HIG_DISCO_FOREIGN_KEYS'
	 ,'HIG_DISCO_FOREIGN_KEY_COLS'
	 ,'HIG_DISCO_TABLES'
	 ,'HIG_DISCO_TAB_COLUMNS'
	 ,'HIG_DOMAINS'
	 ,'HIG_ERRORS'
	 ,'HIG_HD_COMMON_GATEWAYS'
	 ,'HIG_HD_JOIN_DEFS'
	 ,'HIG_HD_LOOKUP_JOIN_COLS'
	 ,'HIG_HD_LOOKUP_JOIN_DEFS'
	 ,'HIG_HD_MODULES'
	 ,'HIG_HD_MOD_PARAMETERS'
	 ,'HIG_HD_MOD_USES'
	 ,'HIG_HD_SELECTED_COLS'
	 ,'HIG_HD_TABLE_JOIN_COLS'
	 ,'HIG_HOLIDAYS'
	 ,'HIG_MODULES'
	 ,'HIG_MODULE_HISTORY'
	 ,'HIG_MODULE_KEYWORDS'
	 ,'HIG_MODULE_ROLES'
	 ,'HIG_MODULE_USAGES'
	 ,'HIG_OPTION_LIST'
	 ,'HIG_OPTION_VALUES'
	 ,'HIG_PRODUCTS'
	 ,'HIG_PU'
	 ,'HIG_REPORT_STYLES'
	 ,'HIG_ROLES'
	 ,'HIG_SEQUENCE_ASSOCIATIONS'
 	 ,'HIG_STANDARD_FAVOURITES'
	 ,'HIG_STATUS_CODES'
	 ,'HIG_STATUS_DOMAINS'
	 ,'HIG_SYSTEM_FAVOURITES'
	 ,'HIG_UPGRADES'
	 ,'HIG_URL_MODULES'
	 ,'HIG_USERS'
	 ,'HIG_USER_FAVOURITES'
	 ,'HIG_USER_HISTORY'
	 ,'HIG_USER_OPTIONS'
	 ,'HIG_USER_OPTION_LIST'
	 ,'HIG_USER_ROLES'
	 ,'HIG_WEB_CONTXT_HLP'
	 ,'IM_GAZ_PARAMETERS'
	 ,'IM_JUMP_NODES'
	 ,'INTERVALS'
	 ,'MV_ERRORS'
	 ,'NAD_START_DATE_LOG_TEMP'
	 ,'NM0575_EVENT_LOG'
	 ,'NM0575_POSSIBLE_XSPS'
	 ,'NM2_INV_LOCATIONS_TAB'
	 ,'NM3SDM_DYN_SEG_EX'
	 ,'NM3_SECTOR_GROUPS'
	 ,'NM_ADMIN_GROUPS'
	 ,'NM_ADMIN_UNITS_ALL'
	 ,'NM_AREA_LOCK'
	 ,'NM_AREA_THEMES'
	 ,'NM_AREA_TYPES'
	 ,'NM_ASSETS_ON_ROUTE'
	 ,'NM_ASSETS_ON_ROUTE_HOLDING'
	 ,'NM_ASSETS_ON_ROUTE_STORE'
	 ,'NM_ASSETS_ON_ROUTE_STORE_ATT'
	 ,'NM_ASSETS_ON_ROUTE_STORE_ATT_D'
	 ,'NM_ASSETS_ON_ROUTE_STORE_HEAD'
	 ,'NM_ASSETS_ON_ROUTE_STORE_TOTAL'
	 ,'NM_ASSET_RESULTS'
	 ,'NM_AUDIT_ACTIONS'
	 ,'NM_AUDIT_CHANGES'
	 ,'NM_AUDIT_COLUMNS'
	 ,'NM_AUDIT_KEY_COLS'
	 ,'NM_AUDIT_TABLES'
	 ,'NM_AUDIT_TEMP'
	 ,'NM_AUDIT_WHEN'
	 ,'NM_AU_SECURITY_TEMP'
	 ,'NM_AU_SUB_TYPES'
	 ,'NM_AU_TYPES'
	 ,'NM_AU_TYPES_GROUPINGS'
	 ,'NM_BASE_THEMES'
	 ,'NM_CHARACTER_SETS'
	 ,'NM_CHARACTER_SET_MEMBERS'
	 ,'NM_CREATE_GROUP_TEMP'
	 ,'NM_DATUM_CRITERIA_TMP'
	 ,'NM_DBUG'
	 ,'NM_ELEMENTS_ALL'
	 ,'NM_ELEMENT_HISTORY'
	 ,'NM_ELEMENT_XREFS'
	 ,'NM_ENG_DYNSEG_VALUES_TMP'
	 ,'NM_ERRORS'
	 ,'NM_EVENT_ALERT_MAILS'
	 ,'NM_EVENT_LOG'
	 ,'NM_EVENT_TYPES'
	 ,'NM_FILL_PATTERNS'
	 ,'NM_GAZ_QUERY'
	 ,'NM_GAZ_QUERY_ATTRIBS'
	 ,'NM_GAZ_QUERY_ITEM_LIST'
	 ,'NM_GAZ_QUERY_TYPES'
	 ,'NM_GAZ_QUERY_VALUES'
	 ,'NM_GIS_AREA_OF_INTEREST'
	 ,'NM_GROUP_INV_LINK_ALL'
	 ,'NM_GROUP_INV_TYPES'
	 ,'NM_GROUP_RELATIONS_ALL'
	 ,'NM_GROUP_TYPES_ALL'
	 ,'NM_INV_ATTRIBUTE_SETS'
	 ,'NM_INV_ATTRIBUTE_SET_INV_ATTR'
	 ,'NM_INV_ATTRIBUTE_SET_INV_TYPES'
	 ,'NM_INV_ATTRI_LOOKUP_ALL'
	 ,'NM_INV_CATEGORIES'
	 ,'NM_INV_CATEGORY_MODULES'
	 ,'NM_INV_DOMAINS_ALL'
	 ,'NM_INV_ITEMS_ALL'
	 ,'NM_INV_ITEM_GROUPINGS_ALL'
	 ,'NM_INV_NW_ALL'
	 ,'NM_INV_THEMES'
	 ,'NM_INV_TYPES_ALL'
	 ,'NM_INV_TYPE_ATTRIBS_ALL'
	 ,'NM_INV_TYPE_ATTRIB_BANDINGS'
	 ,'NM_INV_TYPE_ATTRIB_BAND_DETS'
	 ,'NM_INV_TYPE_COLOURS'
	 ,'NM_INV_TYPE_GROUPINGS_ALL'
	 ,'NM_INV_TYPE_ROLES'
	 ,'NM_JOB_CONTROL'
	 ,'NM_JOB_OPERATIONS'
	 ,'NM_JOB_OPERATION_DATA_VALUES'
	 ,'NM_JOB_TYPES'
	 ,'NM_JOB_TYPES_OPERATIONS'
	 ,'NM_LAYER_TREE'
	 ,'NM_LD_MC_ALL_INV_TMP'
	 ,'NM_LINEAR_TYPES'
	 ,'NM_LOAD_BATCHES'
	 ,'NM_LOAD_BATCH_LOCK'
	 ,'NM_LOAD_BATCH_STATUS'
	 ,'NM_LOAD_DESTINATIONS'
	 ,'NM_LOAD_DESTINATION_DEFAULTS'
	 ,'NM_LOAD_FILES'
	 ,'NM_LOAD_FILE_COLS'
	 ,'NM_LOAD_FILE_COL_DESTINATIONS'
	 ,'NM_LOAD_FILE_DESTINATIONS'
	 ,'NM_LOCATOR_RESULTS'
	 ,'NM_MAIL_GROUPS'
	 ,'NM_MAIL_GROUP_MEMBERSHIP'
	 ,'NM_MAIL_MESSAGE'
	 ,'NM_MAIL_MESSAGE_RECIPIENTS'
	 ,'NM_MAIL_MESSAGE_TEXT'
	 ,'NM_MAIL_POP_MESSAGES'
	 ,'NM_MAIL_POP_MESSAGE_DETAILS'
	 ,'NM_MAIL_POP_MESSAGE_HEADERS'
	 ,'NM_MAIL_POP_MESSAGE_RAW'
	 ,'NM_MAIL_POP_PROCESSES'
	 ,'NM_MAIL_POP_PROCESSING_ERRORS'
	 ,'NM_MAIL_POP_PROCESS_CONDITIONS'
	 ,'NM_MAIL_POP_SERVERS'
	 ,'NM_MAIL_USERS'
	 ,'NM_MAPCAP_LOAD_ERR'
	 ,'NM_MEMBERS_ALL'
	 ,'NM_MEMBER_HISTORY'
	 ,'NM_MERGE_MEMBERS'
	 ,'NM_MRG_DATUM_HOMO_CHUNKS_TMP'
	 ,'NM_MRG_DEFAULT_QUERY_ATTRIBS'
	 ,'NM_MRG_DEFAULT_QUERY_TYPES_ALL'
	 ,'NM_MRG_DERIVED_INV_VALUES_TMP'
	 ,'NM_MRG_GEOMETRY'
	 ,'NM_MRG_INV_DERIVATION'
	 ,'NM_MRG_INV_DERIVATION_NTE_TEMP'
	 ,'NM_MRG_INV_ITEMS'
	 ,'NM_MRG_ITA_DERIVATION'
	 ,'NM_MRG_MEMBERS'
	  ,'NM_MRG_MEMBERS2'
	 ,'NM_MRG_NIT_DERIVATION'
	 ,'NM_MRG_NIT_DERIVATION_NW'
	 ,'NM_MRG_NIT_DERIVATION_REFRESH'
	 ,'NM_MRG_OUTPUT_COLS'
	 ,'NM_MRG_OUTPUT_COL_DECODE'
	 ,'NM_MRG_OUTPUT_FILE'
	 ,'NM_MRG_QUERY_ALL'
	 ,'NM_MRG_QUERY_ATTRIBS'
	 ,'NM_MRG_QUERY_MEMBERS_TEMP'
	 ,'NM_MRG_QUERY_RESULTS_ALL'
	 ,'NM_MRG_QUERY_RESULTS_TEMP'
	 ,'NM_MRG_QUERY_RESULTS_TEMP2'
	 ,'NM_MRG_QUERY_ROLES'
	 ,'NM_MRG_QUERY_TYPES_ALL'
	 ,'NM_MRG_QUERY_USERS'
	 ,'NM_MRG_QUERY_VALUES'
	 ,'NM_MRG_SECTIONS_ALL'
	 ,'NM_MRG_SECTION_INV_VALUES_ALL'
	 ,'NM_MRG_SECTION_INV_VALUES_TMP'
	 ,'NM_MRG_SECTION_MEMBERS'
	 ,'NM_MRG_SECTION_MEMBER_INV'
	 ,'NM_MRG_SPLIT_RESULTS_TMP'
	 ,'NM_NM0150'
	 ,'NM_NM0151'
	 ,'NM_NM0153'
	 ,'NM_NM0154'
	 ,'NM_NODES_ALL'
	 ,'NM_NODES_AT_XY_TMP'
	 ,'NM_NODE_TYPES'
	 ,'NM_NODE_USAGES_ALL'
	 ,'NM_NT_GROUPINGS_ALL'
	 ,'NM_NW_AD_LINK_ALL'
	 ,'NM_NW_AD_TYPES'
	 ,'NM_NW_PERSISTENT_EXTENTS'
	 ,'NM_NW_TEMP_EXTENTS'
	 ,'NM_NW_THEMES'
	 ,'NM_NW_XSP'
	 ,'NM_OPERATIONS'
	 ,'NM_OPERATION_DATA'
	 ,'NM_PBI_QUERY'
	 ,'NM_PBI_QUERY_ATTRIBS'
	 ,'NM_PBI_QUERY_RESULTS'
	 ,'NM_PBI_QUERY_TYPES'
	 ,'NM_PBI_QUERY_VALUES'
	 ,'NM_PBI_SECTIONS'
	 ,'NM_PBI_SECTION_MEMBERS'
	 ,'NM_POINTS'
	 ,'NM_POINT_LOCATIONS'
	 ,'NM_PROGRESS'
	 ,'NM_RECLASS_DETAILS'
	 ,'NM_RESCALE_READ'
	 ,'NM_RESCALE_SEG_TREE'
	 ,'NM_RESCALE_WRITE'
	 ,'NM_REVERSAL'
	 ,'NM_ROUTE_CONNECTIVITY_TMP'
	 ,'NM_SAVED_EXTENTS'
	 ,'NM_SAVED_EXTENT_MEMBERS'
	 ,'NM_SAVED_EXTENT_MEMBER_DATUMS'
	 ,'NM_SPATIAL_EXTENTS'
	 ,'NM_TEMP_INV_ITEMS'
	 ,'NM_TEMP_INV_ITEMS_LIST'
	 ,'NM_TEMP_INV_ITEMS_TEMP'
	 ,'NM_TEMP_INV_MEMBERS'
	 ,'NM_TEMP_INV_MEMBERS_TEMP'
	 ,'NM_TEMP_NODES'
	 ,'NM_THEMES_ALL'
	 ,'NM_THEMES_VISIBLE'
	 ,'NM_THEME_FUNCTIONS_ALL'
	 ,'NM_THEME_GTYPES'
	 ,'NM_THEME_ROLES'
	 ,'NM_THEME_SNAPS'
	 ,'NM_TYPES'
	 ,'NM_TYPE_COLUMNS'
	 ,'NM_TYPE_INCLUSION'
	 ,'NM_TYPE_LAYERS_ALL'
	 ,'NM_TYPE_SPECIFIC_MODULES'
	 ,'NM_TYPE_SUBCLASS'
	 ,'NM_TYPE_SUBCLASS_RESTRICTIONS'
	 ,'NM_TYPE_XREFS'
	 ,'NM_UNITS'
	 ,'NM_UNIT_CONVERSIONS'
	 ,'NM_UNIT_DOMAINS'
	 ,'NM_UPLOAD_FILES'
	 ,'NM_UPLOAD_FILESPART'
	 ,'NM_UPLOAD_FILE_GATEWAYS'
	 ,'NM_UPLOAD_FILE_GATEWAY_COLS'
	 ,'NM_USER_AUS_ALL'
	 ,'NM_VISUAL_ATTRIBUTES'
	 ,'NM_XML_FILES'
	 ,'NM_XML_LOAD_BATCHES'
	 ,'NM_XML_LOAD_ERRORS'
	 ,'NM_XSP_RESTRAINTS'
	 ,'NM_XSP_REVERSAL'
	 ,'NM_X_DRIVING_CONDITIONS'
	 ,'NM_X_ERRORS'
	 ,'NM_X_INV_CONDITIONS'
	 ,'NM_X_LOCATION_RULES'
	 ,'NM_X_NW_RULES'
	 ,'NM_X_RULES'
	 ,'NM_X_VAL_CONDITIONS'
	 ,'REPORT_PARAMS'
	 ,'REPORT_TAGS')
	 AND generated = 'USER NAME';

BEGIN

  FOR crec IN c1 LOOP
  
    BEGIN
	   EXECUTE IMMEDIATE('Alter table '||crec.table_name||' drop constraint '||crec.constraint_name);
	EXCEPTION
	   WHEN OTHERS THEN NULL;
	END;
	
  END LOOP;
  
END;
/
