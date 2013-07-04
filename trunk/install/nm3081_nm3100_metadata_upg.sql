REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)nm3081_nm3100_metadata_upg.sql	1.22 01/09/04

SET FEEDBACK OFF
--
DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
     Null;
END;
/
----------------------------------------------------------------------------
--Call a proc in nm_debug to instantiate it before calling metadata scripts.
--
--If this is not done any inserts into hig_option_values may fail due to
-- mutating trigger when nm_debug checks DEBUGAUTON.
----------------------------------------------------------------------------
BEGIN
  nm_debug.debug_off;
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
   --
   -- NM_ERRORS
   --
   l_tab_ner_id    nm3type.tab_number;
   l_tab_ner_descr nm3type.tab_varchar2000;
   l_tab_appl      nm3type.tab_varchar30;
   --
   l_tab_dodgy_ner_id    nm3type.tab_number;
   l_tab_dodgy_ner_appl  nm3type.tab_varchar30;
   l_tab_dodgy_descr_old nm3type.tab_varchar2000;
   l_tab_dodgy_descr_new nm3type.tab_varchar2000;
   --
   l_current_type  nm_errors.ner_appl%TYPE;
   --
   PROCEDURE add_ner (p_ner_id    number
                     ,p_ner_descr varchar2
                     ,p_app       varchar2 DEFAULT l_current_type
                     ) IS
      c_count CONSTANT pls_integer := l_tab_ner_id.COUNT+1;
   BEGIN
      l_tab_ner_id(c_count)    := p_ner_id;
      l_tab_ner_descr(c_count) := p_ner_descr;
      l_tab_appl(c_count)      := p_app;
   END add_ner;
   --
   PROCEDURE add_dodgy (p_ner_id        number
                       ,p_ner_descr_old varchar2
                       ,p_ner_descr_new varchar2
                       ,p_app           varchar2 DEFAULT l_current_type
                       ) IS
      c_count CONSTANT pls_integer := l_tab_dodgy_ner_id.COUNT+1;
   BEGIN
      l_tab_dodgy_ner_id(c_count)    := p_ner_id;
      l_tab_dodgy_descr_old(c_count) := p_ner_descr_old;
      l_tab_dodgy_descr_new(c_count) := NVL(p_ner_descr_new,p_ner_descr_old);
      l_tab_dodgy_ner_appl(c_count)  := p_app;
   END add_dodgy;
   --
BEGIN
   --
   -- HIG errors
   --
   l_current_type := nm3type.c_hig;
   --
   add_ner(188, 'User Created. Do you want to view this user?');
   add_ner(189, 'SDE data not present - cloning is not possible');
   add_ner(190, 'SDE Layer generator failure');
   add_ner(191, 'SDE Table registration id generator failure');
   add_ner(192, 'Theme is not related to a network');
   add_ner(193, 'Point location data not found - clone is not possible');
   add_ner(194, 'No base theme is available');
   add_ner(195, 'No datum theme found');
   add_ner(196, 'Layer table not found' );
   add_ner(197, 'SDO Metadata for layer  not found' );
   add_ner(198, 'Geometry not found - ');
   add_ner(199, 'Element shapes not connected');
   add_ner(201, 'Only one element has shape - merge prevented');
   add_ner(202, 'points are the same - no distance between them');
   add_ner(203, 'points are not on same network element');
   add_ner(204, 'Lengths of element and shape are inconsistent' );
   add_ner(205, 'Single part asset shapes are not supported yet');
   add_ner(206, 'Load Aborted. Metadata changes have been made since the edif file was generated.');
   add_ner(207, 'Load Aborted. Error found during MapCapture Load.');
   add_ner(208, 'Inventory Update conflict. Changes have been made to the inventory in the database.');
   add_ner(209, 'The file containing exor product version numbers could not be found.  Please check the ''EXOR_VERSION'' registry setting');   
   add_ner(210, 'Inconsistency detected in exor product version numbers');
   add_ner(211, 'Switch Route Theme to Current Theme?');
   add_ner(212, 'Theme must be of type SDE/SDO to be Route Theme'); 

   --
   -- NET errors
   --
   l_current_type := nm3type.c_net;
   --
   add_ner(345, 'A parent inclusion group type can only have one child network type');
   add_ner(346, 'A column that is displayed and used to build the unique must be mandatory');
   add_ner(347, 'The unique for this element will be populated automatically');
   add_ner(348, 'Elements and inventory items of these types cannot be linked');
   add_ner(349, 'This group type is not associated with an inventory type');
   add_ner(350, 'This element has no associated inventory item');
   add_ner(351, 'The value you have entered is not unique across all network types.' || Chr(10) || Chr(10) || 'Please use the Gazetteer to select a specific item.');
   add_ner(352, 'You cannot specify a Unique Format for a column with no Unique Sequence set');
   add_ner(353, 'Value must be an NM_ELEMENTS column, something that can be selected from DUAL or something that can be selected from NM_ELEMENTS (with column names as bind variables).');
   add_ner(354, 'All bind variables must be named after NM_ELEMENTS columns');
   add_ner(355, 'Cannot locate inventory - the item has future locations which would be affected.');
   add_ner(356, 'Inventory types used for group attributes must be continuous.');
   --
   -- Fix dodgy NM_ERRORS records
   --
   l_current_type := nm3type.c_hig;
   add_dodgy (p_ner_id        => 126
             ,p_ner_descr_old => 'You should not be here.'
             ,p_ner_descr_new => 'You do not have privileges to perform this action');

   l_current_type := nm3type.c_net;
   add_dodgy (p_ner_id        => 236
             ,p_ner_descr_old => 'You should not be here'
             ,p_ner_descr_new => 'You do not have privileges to perform this action');


   FORALL i IN 1..l_tab_ner_id.COUNT
      INSERT INTO nm_errors
            (ner_appl
            ,ner_id
            ,ner_descr
            )
      SELECT l_tab_appl(i)
            ,l_tab_ner_id(i)
            ,l_tab_ner_descr(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  nm_errors
                         WHERE  ner_id   = l_tab_ner_id(i)
                          AND   ner_appl = l_tab_appl(i)
                        )
       AND   l_tab_ner_descr(i) IS NOT NULL;
   --
   FORALL i IN 1..l_tab_dodgy_ner_id.COUNT
      UPDATE nm_errors
       SET   ner_descr = l_tab_dodgy_descr_new (i)
      WHERE  ner_id    = l_tab_dodgy_ner_id(i)
       AND   ner_appl  = l_tab_dodgy_ner_appl(i)
       AND   ner_descr = l_tab_dodgy_descr_old(i);
   --
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
--  hig_sequence_associations
--   (hsa_table_name        VARCHAR2(30) NOT NULL
--   ,hsa_column_name       VARCHAR2(30) NOT NULL
--   ,hsa_sequence_name     VARCHAR2(30) NOT NULL
--
   l_tab_hsa_table_name     nm3type.tab_varchar30;
   l_tab_hsa_column_name    nm3type.tab_varchar30;
   l_tab_hsa_sequence_name  nm3type.tab_varchar30;
--
   PROCEDURE add_hsa (p_table VARCHAR2, p_col VARCHAR2, p_seq VARCHAR2) IS
      c_count CONSTANT PLS_INTEGER := l_tab_hsa_table_name.COUNT+1;
   BEGIN
      l_tab_hsa_table_name(c_count)    := p_table;
      l_tab_hsa_column_name(c_count)   := p_col;
      l_tab_hsa_sequence_name(c_count) := p_seq;
   END add_hsa;
--
BEGIN
--
   --add_hsa ('DOC_ACTIONS','DAC_ID','DAC_ID_SEQ');

--
   FORALL i IN 1..l_tab_hsa_table_name.COUNT
      INSERT INTO hig_sequence_associations
            (hsa_table_name
            ,hsa_column_name
            ,hsa_sequence_name
            )
      SELECT l_tab_hsa_table_name(i)
            ,l_tab_hsa_column_name(i)
            ,l_tab_hsa_sequence_name(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_sequence_associations
                         WHERE  hsa_table_name  = l_tab_hsa_table_name(i)
                          AND   hsa_column_name = l_tab_hsa_column_name(i)
                        );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
--  HIG_CHECK_CONSTRAINT_ASSOCS
--
   l_tab_hcca_constraint_name nm3type.tab_varchar30;
   l_tab_hcca_table_name      nm3type.tab_varchar30;
   l_tab_hcca_ner_appl        nm3type.tab_varchar30;
   l_tab_hcca_ner_id          nm3type.tab_number;
--
   PROCEDURE add_hcca (p_hcca_constraint_name VARCHAR2
                      ,p_hcca_table_name      VARCHAR2
                      ,p_hcca_ner_appl        VARCHAR2
                      ,p_hcca_ner_id          VARCHAR2
                      ) IS
      c_count CONSTANT PLS_INTEGER := l_tab_hcca_constraint_name.COUNT+1;
   BEGIN
      l_tab_hcca_constraint_name(c_count) := p_hcca_constraint_name;
      l_tab_hcca_table_name(c_count)      := p_hcca_table_name;
      l_tab_hcca_ner_appl(c_count)        := p_hcca_ner_appl;
      l_tab_hcca_ner_id(c_count)          := p_hcca_ner_id;
   END add_hcca;
--
BEGIN
--
   add_hcca ('NTC_UNIQUE_SEQ_MAND_CHK', 'NM_TYPE_COLUMNS', nm3type.c_net, 346);
   add_hcca('ANALYSE_ALL_TABS_LOG_PK', 'ANALYSE_ALL_TABS_LOG', nm3type.c_hig, 64);
   add_hcca('COLOURS_PK', 'COLOURS', nm3type.c_hig, 64);
   add_hcca('COL_UK', 'COLOURS', nm3type.c_hig, 64);
   add_hcca('DOC_PK', 'DOCS', nm3type.c_hig, 64);
   add_hcca('DAC_PK', 'DOC_ACTIONS', nm3type.c_hig, 64);
   add_hcca('DAS_PK', 'DOC_ASSOCS', nm3type.c_hig, 64);
   add_hcca('DCL_PK', 'DOC_CLASS', nm3type.c_hig, 64);
   add_hcca('DCL_UK1', 'DOC_CLASS', nm3type.c_hig, 64);
   add_hcca('DCP_PK', 'DOC_COPIES', nm3type.c_hig, 64);
   add_hcca('DDG_PK', 'DOC_DAMAGE', nm3type.c_hig, 64);
   add_hcca('DDC_PK', 'DOC_DAMAGE_COSTS', nm3type.c_hig, 64);
   add_hcca('DEC_PK', 'DOC_ENQUIRY_CONTACTS', nm3type.c_hig, 64);
   add_hcca('DET_PK', 'DOC_ENQUIRY_TYPES', nm3type.c_hig, 64);
   add_hcca('DET_UNQ', 'DOC_ENQUIRY_TYPES', nm3type.c_hig, 64);
   add_hcca('DGT_PK', 'DOC_GATEWAYS', nm3type.c_hig, 64);
   add_hcca('DGT_UK1', 'DOC_GATEWAYS', nm3type.c_hig, 64);
   add_hcca('DGS_PK', 'DOC_GATE_SYNS', nm3type.c_hig, 64);
   add_hcca('DHI_PK', 'DOC_HISTORY', nm3type.c_hig, 64);
   add_hcca('DKY_PK', 'DOC_KEYS', nm3type.c_hig, 64);
   add_hcca('DKW_PK', 'DOC_KEYWORDS', nm3type.c_hig, 64);
   add_hcca('DLC_PK', 'DOC_LOCATIONS', nm3type.c_hig, 64);
   add_hcca('DLC_UK', 'DOC_LOCATIONS', nm3type.c_hig, 64);
   add_hcca('DMD_PK', 'DOC_MEDIA', nm3type.c_hig, 64);
   add_hcca('DMD_UK', 'DOC_MEDIA', nm3type.c_hig, 64);
   add_hcca('DQ_PK', 'DOC_QUERY', nm3type.c_hig, 64);
   add_hcca('DQ_UK', 'DOC_QUERY', nm3type.c_hig, 64);
   add_hcca('DQC_PK', 'DOC_QUERY_COLS', nm3type.c_hig, 64);
   add_hcca('DRP_PK', 'DOC_REDIR_PRIOR', nm3type.c_hig, 64);
   add_hcca('DSC_PK', 'DOC_STD_COSTS', nm3type.c_hig, 64);
   add_hcca('DSY_PK', 'DOC_SYNONYMS', nm3type.c_hig, 64);
   add_hcca('DTC_PK', 'DOC_TEMPLATE_COLUMNS', nm3type.c_hig, 64);
   add_hcca('DTG_PK', 'DOC_TEMPLATE_GATEWAYS', nm3type.c_hig, 64);
   add_hcca('DTU_PK', 'DOC_TEMPLATE_USERS', nm3type.c_hig, 64);
   add_hcca('DTP_PK', 'DOC_TYPES', nm3type.c_hig, 64);
   add_hcca('DTP_UK', 'DOC_TYPES', nm3type.c_hig, 64);
   add_hcca('EXOR_VERSION_TAB_PK', 'EXOR_VERSION_TAB', nm3type.c_hig, 64);
   add_hcca('GDOBJ_PK', 'GIS_DATA_OBJECTS', nm3type.c_hig, 64);
   add_hcca('GIS_PROJECTS_PK', 'GIS_PROJECTS', nm3type.c_hig, 64);
   add_hcca('GT_PK', 'GIS_THEMES_ALL', nm3type.c_hig, 64);
   add_hcca('GT_UK', 'GIS_THEMES_ALL', nm3type.c_hig, 64);
   add_hcca('GTF_PK', 'GIS_THEME_FUNCTIONS_ALL', nm3type.c_hig, 64);
   add_hcca('GTHR_PK', 'GIS_THEME_ROLES', nm3type.c_hig, 64);
   add_hcca('GL_PK', 'GRI_LOV', nm3type.c_hig, 64);
   add_hcca('GRM_PK', 'GRI_MODULES', nm3type.c_hig, 64);
   add_hcca('GMP_PK', 'GRI_MODULE_PARAMS', nm3type.c_hig, 64);
   add_hcca('GP_PK', 'GRI_PARAMS', nm3type.c_hig, 64);
   add_hcca('GPD_PK', 'GRI_PARAM_DEPENDENCIES', nm3type.c_hig, 64);
   add_hcca('GPL_PK', 'GRI_PARAM_LOOKUP', nm3type.c_hig, 64);
   add_hcca('GRR_PK', 'GRI_REPORT_RUNS', nm3type.c_hig, 64);
   add_hcca('GRP_PK', 'GRI_RUN_PARAMETERS', nm3type.c_hig, 64);
   add_hcca('GSP_PK', 'GRI_SAVED_PARAMS', nm3type.c_hig, 64);
   add_hcca('GSS_PK', 'GRI_SAVED_SETS', nm3type.c_hig, 64);
   add_hcca('GRS_PK', 'GRI_SPOOL', nm3type.c_hig, 64);
   add_hcca('GTR_PK', 'GROUP_TYPE_ROLES', nm3type.c_hig, 64);
   add_hcca('HAD_PK', 'HIG_ADDRESS', nm3type.c_hig, 64);
   add_hcca('HCCA_PK', 'HIG_CHECK_CONSTRAINT_ASSOCS', nm3type.c_hig, 64);
   add_hcca('HCO_PK', 'HIG_CODES', nm3type.c_hig, 64);
   add_hcca('HCL_PK', 'HIG_COLOURS', nm3type.c_hig, 64);
   add_hcca('HCT_PK', 'HIG_CONTACTS', nm3type.c_hig, 64);
   add_hcca('HCA_PK', 'HIG_CONTACT_ADDRESS', nm3type.c_hig, 64);
   add_hcca('HDBA_PK', 'HIG_DISCO_BUSINESS_AREAS', nm3type.c_hig, 64);
   add_hcca('HDBA_UK', 'HIG_DISCO_BUSINESS_AREAS', nm3type.c_hig, 64);
   add_hcca('HDCV_PK', 'HIG_DISCO_COL_VALUES', nm3type.c_hig, 64);
   add_hcca('HDCV_UK', 'HIG_DISCO_COL_VALUES', nm3type.c_hig, 64);
   add_hcca('HDFK_PK', 'HIG_DISCO_FOREIGN_KEYS', nm3type.c_hig, 64);
   add_hcca('HDFK_UK', 'HIG_DISCO_FOREIGN_KEYS', nm3type.c_hig, 64);
   add_hcca('HDKC_PK', 'HIG_DISCO_FOREIGN_KEY_COLS', nm3type.c_hig, 64);
   add_hcca('HDT_PK', 'HIG_DISCO_TABLES', nm3type.c_hig, 64);
   add_hcca('HDT_UK1', 'HIG_DISCO_TABLES', nm3type.c_hig, 64);
   add_hcca('HDT_UK2', 'HIG_DISCO_TABLES', nm3type.c_hig, 64);
   add_hcca('HDTC_PK', 'HIG_DISCO_TAB_COLUMNS', nm3type.c_hig, 64);
   add_hcca('HDO_PK', 'HIG_DOMAINS', nm3type.c_hig, 64);
   add_hcca('HER_PK', 'HIG_ERRORS', nm3type.c_hig, 64);
   add_hcca('HHO_PK', 'HIG_HOLIDAYS', nm3type.c_hig, 64);
   add_hcca('HIG_MODULES_PK', 'HIG_MODULES', nm3type.c_hig, 64);
   add_hcca('HMH_PK', 'HIG_MODULE_HISTORY', nm3type.c_hig, 64);
   add_hcca('HMH_UK', 'HIG_MODULE_HISTORY', nm3type.c_hig, 64);
   add_hcca('HMK_PK', 'HIG_MODULE_KEYWORDS', nm3type.c_hig, 64);
   add_hcca('HMR_PK', 'HIG_MODULE_ROLES', nm3type.c_hig, 64);
   add_hcca('HMU_PK', 'HIG_MODULE_USAGES', nm3type.c_hig, 64);
   add_hcca('HOL_PK', 'HIG_OPTION_LIST', nm3type.c_hig, 64);
   add_hcca('HOV_PK', 'HIG_OPTION_VALUES', nm3type.c_hig, 64);
   add_hcca('HPR_PK', 'HIG_PRODUCTS', nm3type.c_hig, 64);
   add_hcca('HPR_UK1', 'HIG_PRODUCTS', nm3type.c_hig, 64);
   add_hcca('HRS_PK', 'HIG_REPORT_STYLES', nm3type.c_hig, 64);
   add_hcca('HIG_ROLES_PK', 'HIG_ROLES', nm3type.c_hig, 64);
   add_hcca('HSA_PK', 'HIG_SEQUENCE_ASSOCIATIONS', nm3type.c_hig, 64);
   add_hcca('HSC_PK', 'HIG_STATUS_CODES', nm3type.c_hig, 64);
   add_hcca('HSC_UK1', 'HIG_STATUS_CODES', nm3type.c_hig, 64);
   add_hcca('HSD_PK', 'HIG_STATUS_DOMAINS', nm3type.c_hig, 64);
   add_hcca('HSF_PK', 'HIG_SYSTEM_FAVOURITES', nm3type.c_hig, 64);
   add_hcca('HUP_PK', 'HIG_UPGRADES', nm3type.c_hig, 64);
   add_hcca('HIG_USERS_PK', 'HIG_USERS', nm3type.c_hig, 64);
   add_hcca('HUS_UK', 'HIG_USERS', nm3type.c_hig, 64);
   add_hcca('HUF_PK', 'HIG_USER_FAVOURITES', nm3type.c_hig, 64);
   add_hcca('HUH_PK', 'HIG_USER_HISTORY', nm3type.c_hig, 64);
   add_hcca('HUO_PK', 'HIG_USER_OPTIONS', nm3type.c_hig, 64);
   add_hcca('HUR_PK', 'HIG_USER_ROLES', nm3type.c_hig, 64);
   add_hcca('HWCH_PK', 'HIG_WEB_CONTXT_HLP', nm3type.c_hig, 64);
   add_hcca('HAG_PK', 'NM_ADMIN_GROUPS', nm3type.c_hig, 64);
   add_hcca('HAU_PK', 'NM_ADMIN_UNITS_ALL', nm3type.c_hig, 64);
   add_hcca('HAU_UK1', 'NM_ADMIN_UNITS_ALL', nm3type.c_hig, 64);
   add_hcca('HAU_UK2', 'NM_ADMIN_UNITS_ALL', nm3type.c_hig, 64);
   add_hcca('NARH_PK', 'NM_ASSETS_ON_ROUTE_HOLDING', nm3type.c_hig, 64);
   add_hcca('NARS_PK', 'NM_ASSETS_ON_ROUTE_STORE', nm3type.c_hig, 64);
   add_hcca('NARSA_PK', 'NM_ASSETS_ON_ROUTE_STORE_ATT', nm3type.c_hig, 64);
   add_hcca('NARSD_PK', 'NM_ASSETS_ON_ROUTE_STORE_ATT_D', nm3type.c_hig, 64);
   add_hcca('NARSH_PK', 'NM_ASSETS_ON_ROUTE_STORE_HEAD', nm3type.c_hig, 64);
   add_hcca('NARST_PK', 'NM_ASSETS_ON_ROUTE_STORE_TOTAL', nm3type.c_hig, 64);
   add_hcca('NM_AUDIT_PK', 'NM_AUDIT_ACTIONS', nm3type.c_hig, 64);
   add_hcca('NACH_PK', 'NM_AUDIT_CHANGES', nm3type.c_hig, 64);
   add_hcca('NM_AUDIT_COLUMNS_PK', 'NM_AUDIT_COLUMNS', nm3type.c_hig, 64);
   add_hcca('NM_AUDIT_KEY_COLS_PK', 'NM_AUDIT_KEY_COLS', nm3type.c_hig, 64);
   add_hcca('NM_AUDIT_TABLES_PK', 'NM_AUDIT_TABLES', nm3type.c_hig, 64);
   add_hcca('NM_AUDIT_TEMP_PK', 'NM_AUDIT_TEMP', nm3type.c_hig, 64);
   add_hcca('NAT_PK', 'NM_AU_TYPES', nm3type.c_hig, 64);
   add_hcca('ND_PK', 'NM_DBUG', nm3type.c_hig, 64);
   add_hcca('NE_PK', 'NM_ELEMENTS_ALL', nm3type.c_hig, 64);
   add_hcca('NE_UK', 'NM_ELEMENTS_ALL', nm3type.c_hig, 64);
   add_hcca('NEH_PK', 'NM_ELEMENT_HISTORY', nm3type.c_hig, 64);
   add_hcca('NER_PK', 'NM_ERRORS', nm3type.c_hig, 64);
   add_hcca('NEL_PK', 'NM_EVENT_LOG', nm3type.c_hig, 64);
   add_hcca('NET_PK', 'NM_EVENT_TYPES', nm3type.c_hig, 64);
   add_hcca('NET_UK', 'NM_EVENT_TYPES', nm3type.c_hig, 64);
   add_hcca('NFP_PK', 'NM_FILL_PATTERNS', nm3type.c_hig, 64);
   add_hcca('NGQ_PK', 'NM_GAZ_QUERY', nm3type.c_hig, 64);
   add_hcca('NGQA_PK', 'NM_GAZ_QUERY_ATTRIBS', nm3type.c_hig, 64);
   add_hcca('NGQI_PK', 'NM_GAZ_QUERY_ITEM_LIST', nm3type.c_hig, 64);
   add_hcca('NGQT_PK', 'NM_GAZ_QUERY_TYPES', nm3type.c_hig, 64);
   add_hcca('NGQV_PK', 'NM_GAZ_QUERY_VALUES', nm3type.c_hig, 64);
   add_hcca('NGA_PK', 'NM_GIS_AREA_OF_INTEREST', nm3type.c_hig, 64);
   add_hcca('NGR_PK', 'NM_GROUP_RELATIONS_ALL', nm3type.c_hig, 64);
   add_hcca('NGT_PK', 'NM_GROUP_TYPES_ALL', nm3type.c_hig, 64);
   add_hcca('NIAS_PK', 'NM_INV_ATTRIBUTE_SETS', nm3type.c_hig, 64);
   add_hcca('NSIA_PK', 'NM_INV_ATTRIBUTE_SET_INV_ATTR', nm3type.c_hig, 64);
   add_hcca('NSIT_PK', 'NM_INV_ATTRIBUTE_SET_INV_TYPES', nm3type.c_hig, 64);
   add_hcca('IAL_PK', 'NM_INV_ATTRI_LOOKUP_ALL', nm3type.c_hig, 64);
   add_hcca('NIC_PK', 'NM_INV_CATEGORIES', nm3type.c_hig, 64);
   add_hcca('ICM_PK', 'NM_INV_CATEGORY_MODULES', nm3type.c_hig, 64);
   add_hcca('ID_PK', 'NM_INV_DOMAINS_ALL', nm3type.c_hig, 64);
   add_hcca('INV_ITEMS_ALL_PK', 'NM_INV_ITEMS_ALL', nm3type.c_hig, 64);
   add_hcca('IIT_UK', 'NM_INV_ITEMS_ALL', nm3type.c_hig, 64);
   add_hcca('IIG_PK', 'NM_INV_ITEM_GROUPINGS_ALL', nm3type.c_hig, 64);
   add_hcca('IIG_UK', 'NM_INV_ITEM_GROUPINGS_ALL', nm3type.c_hig, 64);
   add_hcca('NIN_PK', 'NM_INV_NW_ALL', nm3type.c_hig, 64);
   add_hcca('ITY_PK', 'NM_INV_TYPES_ALL', nm3type.c_hig, 64);
   add_hcca('ITA_PK', 'NM_INV_TYPE_ATTRIBS_ALL', nm3type.c_hig, 64);
   add_hcca('ITA_UK_VIEW_ATTRI', 'NM_INV_TYPE_ATTRIBS_ALL', nm3type.c_hig, 64);
   add_hcca('ITA_UK_VIEW_COL', 'NM_INV_TYPE_ATTRIBS_ALL', nm3type.c_hig, 64);
   add_hcca('ITB_PK', 'NM_INV_TYPE_ATTRIB_BANDINGS', nm3type.c_hig, 64);
   add_hcca('ITB_UK', 'NM_INV_TYPE_ATTRIB_BANDINGS', nm3type.c_hig, 64);
   add_hcca('ITD_PK', 'NM_INV_TYPE_ATTRIB_BAND_DETS', nm3type.c_hig, 64);
   add_hcca('NM_INV_TYPE_COLOURS_PK', 'NM_INV_TYPE_COLOURS', nm3type.c_hig, 64);
   add_hcca('ITG_PK', 'NM_INV_TYPE_GROUPINGS_ALL', nm3type.c_hig, 64);
   add_hcca('ITR_PK', 'NM_INV_TYPE_ROLES', nm3type.c_hig, 64);
   add_hcca('NJC_PK', 'NM_JOB_CONTROL', nm3type.c_hig, 64);
   add_hcca('NM_JOB_CONTROL_UK', 'NM_JOB_CONTROL', nm3type.c_hig, 64);
   add_hcca('NJO_PK', 'NM_JOB_OPERATIONS', nm3type.c_hig, 64);
   add_hcca('NJO_UK', 'NM_JOB_OPERATIONS', nm3type.c_hig, 64);
   add_hcca('NJV_PK', 'NM_JOB_OPERATION_DATA_VALUES', nm3type.c_hig, 64);
   add_hcca('NJT_PK', 'NM_JOB_TYPES', nm3type.c_hig, 64);
   add_hcca('JTO_PK', 'NM_JOB_TYPES_OPERATIONS', nm3type.c_hig, 64);
   add_hcca('NL_PK', 'NM_LAYERS', nm3type.c_hig, 64);
   add_hcca('NLS_PK', 'NM_LAYER_SETS', nm3type.c_hig, 64);
   add_hcca('NLB_PK', 'NM_LOAD_BATCHES', nm3type.c_hig, 64);
   add_hcca('NLBS_PK', 'NM_LOAD_BATCH_STATUS', nm3type.c_hig, 64);
   add_hcca('NLD_PK', 'NM_LOAD_DESTINATIONS', nm3type.c_hig, 64);
   add_hcca('NLD_UK1', 'NM_LOAD_DESTINATIONS', nm3type.c_hig, 64);
   add_hcca('NLD_UK2', 'NM_LOAD_DESTINATIONS', nm3type.c_hig, 64);
   add_hcca('NLDD_PK', 'NM_LOAD_DESTINATION_DEFAULTS', nm3type.c_hig, 64);
   add_hcca('NLF_PK', 'NM_LOAD_FILES', nm3type.c_hig, 64);
   add_hcca('NLF_UK', 'NM_LOAD_FILES', nm3type.c_hig, 64);
   add_hcca('NLFC_PK', 'NM_LOAD_FILE_COLS', nm3type.c_hig, 64);
   add_hcca('NLFC_UK', 'NM_LOAD_FILE_COLS', nm3type.c_hig, 64);
   add_hcca('NLCD_PK', 'NM_LOAD_FILE_COL_DESTINATIONS', nm3type.c_hig, 64);
   add_hcca('NLCD_UK', 'NM_LOAD_FILE_COL_DESTINATIONS', nm3type.c_hig, 64);
   add_hcca('NLFD_PK', 'NM_LOAD_FILE_DESTINATIONS', nm3type.c_hig, 64);
   add_hcca('NLFD_UK', 'NM_LOAD_FILE_DESTINATIONS', nm3type.c_hig, 64);
   add_hcca('NMG_PK', 'NM_MAIL_GROUPS', nm3type.c_hig, 64);
   add_hcca('NMGM_PK', 'NM_MAIL_GROUP_MEMBERSHIP', nm3type.c_hig, 64);
   add_hcca('NMM_PK', 'NM_MAIL_MESSAGE', nm3type.c_hig, 64);
   add_hcca('NMMR_PK', 'NM_MAIL_MESSAGE_RECIPIENTS', nm3type.c_hig, 64);
   add_hcca('NMMT_PK', 'NM_MAIL_MESSAGE_TEXT', nm3type.c_hig, 64);
   add_hcca('NMU_PK', 'NM_MAIL_USERS', nm3type.c_hig, 64);
   add_hcca('NM_PK', 'NM_MEMBERS_ALL', nm3type.c_hig, 64);
   add_hcca('NMST_PK', 'NM_MEMBERS_SDE_TEMP', nm3type.c_hig, 64);
   add_hcca('NMH_PK', 'NM_MEMBER_HISTORY', nm3type.c_hig, 64);
   add_hcca('NDQA_PK', 'NM_MRG_DEFAULT_QUERY_ATTRIBS', nm3type.c_hig, 64);
   add_hcca('NDQT_PK', 'NM_MRG_DEFAULT_QUERY_TYPES_ALL', nm3type.c_hig, 64);
   add_hcca('NMID_PK', 'NM_MRG_INV_DERIVATION', nm3type.c_hig, 64);
   add_hcca('NMM2_UK', 'NM_MRG_MEMBERS2', nm3type.c_hig, 64);
   add_hcca('NMC_PK', 'NM_MRG_OUTPUT_COLS', nm3type.c_hig, 64);
   add_hcca('NMC_UK', 'NM_MRG_OUTPUT_COLS', nm3type.c_hig, 64);
   add_hcca('NMCD_PK', 'NM_MRG_OUTPUT_COL_DECODE', nm3type.c_hig, 64);
   add_hcca('NMF_PK', 'NM_MRG_OUTPUT_FILE', nm3type.c_hig, 64);
   add_hcca('NMF_UK', 'NM_MRG_OUTPUT_FILE', nm3type.c_hig, 64);
   add_hcca('NMQ_PK', 'NM_MRG_QUERY_ALL', nm3type.c_hig, 64);
   add_hcca('NMQ_UK', 'NM_MRG_QUERY_ALL', nm3type.c_hig, 64);
   add_hcca('NMQA_PK', 'NM_MRG_QUERY_ATTRIBS', nm3type.c_hig, 64);
   add_hcca('NMQR_PK', 'NM_MRG_QUERY_RESULTS_ALL', nm3type.c_hig, 64);
   add_hcca('NMQRT2_PK', 'NM_MRG_QUERY_RESULTS_TEMP2', nm3type.c_hig, 64);
   add_hcca('NQRO_PK', 'NM_MRG_QUERY_ROLES', nm3type.c_hig, 64);
   add_hcca('NMQT_PK', 'NM_MRG_QUERY_TYPES_ALL', nm3type.c_hig, 64);
   add_hcca('NQU_PK', 'NM_MRG_QUERY_USERS', nm3type.c_hig, 64);
   add_hcca('NMQV_PK', 'NM_MRG_QUERY_VALUES', nm3type.c_hig, 64);
   add_hcca('NMS_PK', 'NM_MRG_SECTIONS_ALL', nm3type.c_hig, 64);
   add_hcca('NMSIV_PK', 'NM_MRG_SECTION_INV_VALUES_ALL', nm3type.c_hig, 64);
   add_hcca('NMSM_PK', 'NM_MRG_SECTION_MEMBERS', nm3type.c_hig, 64);
   add_hcca('NN_PK', 'NM_NODES_ALL', nm3type.c_hig, 64);
   add_hcca('NN_UK', 'NM_NODES_ALL', nm3type.c_hig, 64);
   add_hcca('NNT_PK', 'NM_NODE_TYPES', nm3type.c_hig, 64);
   add_hcca('NNU_PK', 'NM_NODE_USAGES_ALL', nm3type.c_hig, 64);
   add_hcca('NNG_PK', 'NM_NT_GROUPINGS_ALL', nm3type.c_hig, 64);
   add_hcca('NPE_PK', 'NM_NW_PERSISTENT_EXTENTS', nm3type.c_hig, 64);
   add_hcca('NMO_PK', 'NM_OPERATIONS', nm3type.c_hig, 64);
   add_hcca('NOD_PK', 'NM_OPERATION_DATA', nm3type.c_hig, 64);
   add_hcca('NOD_UK', 'NM_OPERATION_DATA', nm3type.c_hig, 64);
   add_hcca('NOD_SCRN_TEXT_UK', 'NM_OPERATION_DATA', nm3type.c_hig, 64);
   add_hcca('NPQ_PK', 'NM_PBI_QUERY', nm3type.c_hig, 64);
   add_hcca('NPQ_UK', 'NM_PBI_QUERY', nm3type.c_hig, 64);
   add_hcca('NQA_PK', 'NM_PBI_QUERY_ATTRIBS', nm3type.c_hig, 64);
   add_hcca('NQR_PK', 'NM_PBI_QUERY_RESULTS', nm3type.c_hig, 64);
   add_hcca('NQT_PK', 'NM_PBI_QUERY_TYPES', nm3type.c_hig, 64);
   add_hcca('NQV_PK', 'NM_PBI_QUERY_VALUES', nm3type.c_hig, 64);
   add_hcca('NPS_PK', 'NM_PBI_SECTIONS', nm3type.c_hig, 64);
   add_hcca('NPM_PK', 'NM_PBI_SECTION_MEMBERS', nm3type.c_hig, 64);
   add_hcca('NP_PK', 'NM_POINTS', nm3type.c_hig, 64);
   add_hcca('NRD_UK', 'NM_RECLASS_DETAILS', nm3type.c_hig, 64);
   add_hcca('NRD_PK', 'NM_RECLASS_DETAILS', nm3type.c_hig, 64);
   add_hcca('NRT_PK', 'NM_RESCALE_SEG_TREE', nm3type.c_hig, 64);
   add_hcca('NRT_UK', 'NM_RESCALE_SEG_TREE', nm3type.c_hig, 64);
   add_hcca('NMR_PK', 'NM_REVERSAL', nm3type.c_hig, 64);
   add_hcca('NSE_PK', 'NM_SAVED_EXTENTS', nm3type.c_hig, 64);
   add_hcca('NSE_UK', 'NM_SAVED_EXTENTS', nm3type.c_hig, 64);
   add_hcca('NSM_PK', 'NM_SAVED_EXTENT_MEMBERS', nm3type.c_hig, 64);
   add_hcca('NSD_PK', 'NM_SAVED_EXTENT_MEMBER_DATUMS', nm3type.c_hig, 64);
   add_hcca('NMTR_PK', 'NM_SDE_TEMP_RESCALE', nm3type.c_hig, 64);
   add_hcca('NS_PK', 'NM_SHAPES_1', nm3type.c_hig, 64);
   add_hcca('TII_PK', 'NM_TEMP_INV_ITEMS', nm3type.c_hig, 64);
   add_hcca('TIL_PK', 'NM_TEMP_INV_ITEMS_LIST', nm3type.c_hig, 64);
   add_hcca('TII_TEMP_PK', 'NM_TEMP_INV_ITEMS_TEMP', nm3type.c_hig, 64);
   add_hcca('TIM_PK', 'NM_TEMP_INV_MEMBERS', nm3type.c_hig, 64);
   add_hcca('TIM_TEMP_PK', 'NM_TEMP_INV_MEMBERS_TEMP', nm3type.c_hig, 64);
   add_hcca('NM_TEMP_NODES_PK', 'NM_TEMP_NODES', nm3type.c_hig, 64);
   add_hcca('NT_PK', 'NM_TYPES', nm3type.c_hig, 64);
   add_hcca('NT_UK', 'NM_TYPES', nm3type.c_hig, 64);
   add_hcca('NTC_PK', 'NM_TYPE_COLUMNS', nm3type.c_hig, 64);
   add_hcca('NTI_PK', 'NM_TYPE_INCLUSION', nm3type.c_hig, 64);
   add_hcca('NTI_UK', 'NM_TYPE_INCLUSION', nm3type.c_hig, 64);
   add_hcca('NTL_PK', 'NM_TYPE_LAYERS_ALL', nm3type.c_hig, 64);
   add_hcca('NSC_PK', 'NM_TYPE_SUBCLASS', nm3type.c_hig, 64);
   add_hcca('NSR_PK', 'NM_TYPE_SUBCLASS_RESTRICTIONS', nm3type.c_hig, 64);
   add_hcca('UN_PK', 'NM_UNITS', nm3type.c_hig, 64);
   add_hcca('UC_PK', 'NM_UNIT_CONVERSIONS', nm3type.c_hig, 64);
   add_hcca('UK_PK', 'NM_UNIT_DOMAINS', nm3type.c_hig, 64);
   add_hcca('NUF_PK', 'NM_UPLOAD_FILES', nm3type.c_hig, 64);
   add_hcca('NUA_PK', 'NM_USER_AUS_ALL', nm3type.c_hig, 64);
   add_hcca('NVA_PK', 'NM_VISUAL_ATTRIBUTES', nm3type.c_hig, 64);
   add_hcca('NM_XML_FILES_PK', 'NM_XML_FILES', nm3type.c_hig, 64);
   add_hcca('NM_XML_BATCHES_PK', 'NM_XML_LOAD_BATCHES', nm3type.c_hig, 64);
   add_hcca('NM_XML_LOAD_ERRORS_PK', 'NM_XML_LOAD_ERRORS', nm3type.c_hig, 64);
   add_hcca('NWX_PK', 'NM_XSP', nm3type.c_hig, 64);
   add_hcca('NXD_PK', 'NM_X_DRIVING_CONDITIONS', nm3type.c_hig, 64);
   add_hcca('NXE_PK', 'NM_X_ERRORS', nm3type.c_hig, 64);
   add_hcca('NXIC_PK', 'NM_X_INV_CONDITIONS', nm3type.c_hig, 64);
   add_hcca('NXL_PK', 'NM_X_LOCATION_RULES', nm3type.c_hig, 64);
   add_hcca('NXN_PK', 'NM_X_NW_RULES', nm3type.c_hig, 64);
   add_hcca('PK_NM_X_RULES', 'NM_X_RULES', nm3type.c_hig, 64);
   add_hcca('NXV_PK', 'NM_X_VAL_CONDITIONS', nm3type.c_hig, 64);
   add_hcca('XSR_PK', 'XSP_RESTRAINTS', nm3type.c_hig, 64);
   add_hcca('XRV_PK', 'XSP_REVERSAL', nm3type.c_hig, 64);
   add_hcca('NTC_UNIQUE_FORMAT_CHK', 'NM_TYPE_COLUMNS', nm3type.c_net, 352);
   add_hcca('NIT_CAT_PNT_CONT_CHK', 'NM_INV_TYPES_ALL', nm3type.c_net, 356);
--
   FORALL i IN 1..l_tab_hcca_constraint_name.COUNT
      INSERT INTO hig_check_constraint_assocs
            (hcca_constraint_name
            ,hcca_table_name
            ,hcca_ner_appl
            ,hcca_ner_id
            )
      SELECT l_tab_hcca_constraint_name(i)
            ,l_tab_hcca_table_name(i)
            ,l_tab_hcca_ner_appl(i)
            ,l_tab_hcca_ner_id(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_check_constraint_assocs
                         WHERE  hcca_constraint_name = l_tab_hcca_constraint_name(i)
                        );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
--  HIG_MODULES and HIG_MODULE_ROLES
--
   TYPE tab_rec_module IS TABLE OF hig_modules%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_hmo     hig_modules%ROWTYPE;
   l_tab_rec_hmo tab_rec_module;
--
   l_tab_hmr_module nm3type.tab_varchar30;
   l_tab_hmr_role   nm3type.tab_varchar30;
   l_tab_hmr_mode   nm3type.tab_varchar30;
--
   l_hmo_count      PLS_INTEGER := 0;
   l_hmr_count      PLS_INTEGER := 0;
--
   PROCEDURE add_hmo IS
   BEGIN
      l_hmo_count := l_hmo_count + 1;
      l_tab_rec_hmo(l_hmo_count) := l_rec_hmo;
   END add_hmo;
--
   PROCEDURE add_hmr (p_role   VARCHAR2
                     ,p_mode   VARCHAR2
                     ,p_module VARCHAR2 DEFAULT l_rec_hmo.hmo_module
                     ) IS
   BEGIN
      l_hmr_count := l_hmr_count + 1;
      l_tab_hmr_module(l_hmr_count) := UPPER(p_module);
      l_tab_hmr_role(l_hmr_count)   := UPPER(p_role);
      l_tab_hmr_mode(l_hmr_count)   := UPPER(p_mode);
   END add_hmr;
--
BEGIN
--
   l_rec_hmo.hmo_module           := 'HIG2100';
   l_rec_hmo.hmo_title            := 'Produce Database Healthcheck File';
   l_rec_hmo.hmo_filename         := 'HIG2100';
   l_rec_hmo.hmo_module_type      := 'SQL';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := nm3type.c_hig;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
--
   add_hmr('HIG_ADMIN',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'GIS';
   l_rec_hmo.hmo_title            := 'GIS Availability (dummy module)';
   l_rec_hmo.hmo_filename         := 'GIS';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'Y';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_hig;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
--
   add_hmr('HIG_ADMIN',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'HIG1885';
   l_rec_hmo.hmo_title            := 'Maintain URL Modules';
   l_rec_hmo.hmo_filename         := 'HIG1885';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_hig;
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
--
   add_hmr('HIG_ADMIN',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'HIG5000';
   l_rec_hmo.hmo_title            := 'Maintain Entry Points';
   l_rec_hmo.hmo_filename         := 'HIG5000';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_hig;
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
--
   add_hmr('HIG_ADMIN',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'HIG1868';
   l_rec_hmo.hmo_title            := 'User Roles';
   l_rec_hmo.hmo_filename         := 'hig1868';
   l_rec_hmo.hmo_module_type      := 'R25';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := nm3type.c_hig;
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
--
   add_hmr('HIG_ADMIN',nm3type.c_normal);   
--
   l_rec_hmo.hmo_module           := 'HIG1866';
   l_rec_hmo.hmo_title            := 'Users By Admin Unit';
   l_rec_hmo.hmo_filename         := 'hig1866';
   l_rec_hmo.hmo_module_type      := 'R25';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := nm3type.c_hig;
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
--
   add_hmr('HIG_ADMIN',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'NMWEB7057';
   l_rec_hmo.hmo_title            := 'Submit Merge Query in batch';
   l_rec_hmo.hmo_filename         := 'nm3web_mrg.main';
   l_rec_hmo.hmo_module_type      := 'WEB';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := Null;
   add_hmo;
   add_hmr('WEB_USER',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'NM0511';
   l_rec_hmo.hmo_title            := 'Reconcile MapCapture Load Errors';
   l_rec_hmo.hmo_filename         := 'nm0511.fmx';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr('HIG_ADMIN',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'NET1100';
   l_rec_hmo.hmo_title            := 'Gazetteer';
   l_rec_hmo.hmo_filename         := 'net1100';
   l_rec_hmo.hmo_module_type      := 'FMX';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'N';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := 'FORM';
   add_hmo;
   add_hmr('HIG_ADMIN',nm3type.c_normal);
   add_hmr('HIG_USER',nm3type.c_normal);
--
   l_rec_hmo.hmo_module           := 'NM0580';
   l_rec_hmo.hmo_title            := 'Create MapCapture Metadata File';
   l_rec_hmo.hmo_filename         := 'nm0580';
   l_rec_hmo.hmo_module_type      := 'SQL';
   l_rec_hmo.hmo_fastpath_opts    := Null;
   l_rec_hmo.hmo_fastpath_invalid := 'N';
   l_rec_hmo.hmo_use_gri          := 'Y';
   l_rec_hmo.hmo_application      := nm3type.c_net;
   l_rec_hmo.hmo_menu             := NULL;
   add_hmo;
   add_hmr('NET_ADMIN',nm3type.c_normal);   
-- 
-- module role that should have gone in prior release
   add_hmr('HIG_ADMIN',nm3type.c_normal,'HIG1950');   
--     
   FOR i IN 1..l_hmo_count
    LOOP
      l_rec_hmo := l_tab_rec_hmo(i);
      INSERT INTO hig_modules
            (hmo_module
            ,hmo_title
            ,hmo_filename
            ,hmo_module_type
            ,hmo_fastpath_opts
            ,hmo_fastpath_invalid
            ,hmo_use_gri
            ,hmo_application
            ,hmo_menu
            )
      SELECT l_rec_hmo.hmo_module
            ,l_rec_hmo.hmo_title
            ,l_rec_hmo.hmo_filename
            ,l_rec_hmo.hmo_module_type
            ,l_rec_hmo.hmo_fastpath_opts
            ,l_rec_hmo.hmo_fastpath_invalid
            ,l_rec_hmo.hmo_use_gri
            ,l_rec_hmo.hmo_application
            ,l_rec_hmo.hmo_menu
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_rec_hmo.hmo_module
                       );
   END LOOP;
--
   FORALL i IN 1..l_hmr_count
      INSERT INTO hig_module_roles
            (hmr_module
            ,hmr_role
            ,hmr_mode
            )
      SELECT l_tab_hmr_module(i)
            ,l_tab_hmr_role(i)
            ,l_tab_hmr_mode(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_module_roles
                        WHERE  hmr_module = l_tab_hmr_module(i)
                         AND   hmr_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_roles
                        WHERE  hro_role   = l_tab_hmr_role(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_modules
                        WHERE  hmo_module = l_tab_hmr_module(i)
                       );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- HIG_DOMAINS and HIG_CODES
--
   l_tab_hdo_domain     nm3type.tab_varchar30;
   l_tab_hdo_product    nm3type.tab_varchar30;
   l_tab_hdo_title      nm3type.tab_varchar2000;
   l_tab_hdo_code_len   nm3type.tab_number;
--
   l_tab_hco_domain     nm3type.tab_varchar30;
   l_tab_hco_code       nm3type.tab_varchar30;
   l_tab_hco_meaning    nm3type.tab_varchar2000;
   l_tab_hco_system     nm3type.tab_varchar4;
   l_tab_hco_seq        nm3type.tab_number;
   l_tab_hco_start_date nm3type.tab_date;
   l_tab_hco_end_date   nm3type.tab_date;
--
   l_hdo_count        PLS_INTEGER := 0;
   l_hco_count        PLS_INTEGER := 0;
--
   PROCEDURE add_hdo (p_domain   VARCHAR2
                     ,p_product  VARCHAR2
                     ,p_title    VARCHAR2
                     ,p_code_len NUMBER
                     ) IS
   BEGIN
      l_hdo_count := l_hdo_count + 1;
      l_tab_hdo_domain(l_hdo_count)   := UPPER(p_domain);
      l_tab_hdo_product(l_hdo_count)  := UPPER(p_product);
      l_tab_hdo_title(l_hdo_count)    := p_title;
      l_tab_hdo_code_len(l_hdo_count) := p_code_len;
   END add_hdo;
--
   PROCEDURE add_hco (p_domain     VARCHAR2
                     ,p_code       VARCHAR2
                     ,p_meaning    VARCHAR2
                     ,p_system     VARCHAR2 DEFAULT 'Y'
                     ,p_seq        NUMBER   DEFAULT NULL
                     ,p_start_date DATE     DEFAULT NULL
                     ,p_end_date   DATE     DEFAULT NULL
                     ) IS
   BEGIN
      l_hco_count := l_hco_count + 1;
      l_tab_hco_domain(l_hco_count)     := UPPER(p_domain);
      l_tab_hco_code(l_hco_count)       := p_code;
      l_tab_hco_meaning(l_hco_count)    := p_meaning;
      l_tab_hco_system(l_hco_count)     := p_system;
      l_tab_hco_seq(l_hco_count)        := p_seq;
      l_tab_hco_start_date(l_hco_count) := p_start_date;
      l_tab_hco_end_date(l_hco_count)   := p_end_date;
   END add_hco;
--
BEGIN
--
   add_hco ('CSV_PROCESS_SUBTYPE','F','Produce Log Files','Y',3);
--
   add_hco ('MODULE_TYPE','EPT','Entry Point','Y');
   add_hco ('MODULE_TYPE','URL','URL','Y');
--
   add_hdo ('HDN_JOIN_TYPES',nm3type.c_hig,'HDN Join Types',30);
   add_hco ('HDN_JOIN_TYPES','TABLE','HDN Table Join','Y');
   
   add_hdo ('MRG_OUTPUT_TYPE',nm3type.c_net,'Merge Output Type',6);
   add_hco ('MRG_OUTPUT_TYPE','CLIENT','Client','Y',1);
   add_hco ('MRG_OUTPUT_TYPE','SERVER','Server','Y',2);
   add_hco ('MRG_OUTPUT_TYPE','C/S','Client '||CHR(38)||' Server','Y',3);
--
   add_hdo ('MC_INV_LD_ERR_STATUS',nm3type.c_hig,'MapCapture Inventory Loader Error Status',1);
   add_hco ('MC_INV_LD_ERR_STATUS','0','No Error','Y',1);
   add_hco ('MC_INV_LD_ERR_STATUS','1','General Error','Y',2);
   add_hco ('MC_INV_LD_ERR_STATUS','2','Conflict','Y',3);
   add_hco ('MC_INV_LD_ERR_STATUS','3','Conflict Resolved','Y',4);         
      
--   
   FORALL i IN 1..l_hdo_count
      INSERT INTO hig_domains
            (hdo_domain
            ,hdo_product
            ,hdo_title
            ,hdo_code_length
            )
      SELECT l_tab_hdo_domain(i)
            ,l_tab_hdo_product(i)
            ,l_tab_hdo_title(i)
            ,l_tab_hdo_code_len(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hdo_domain(i)
                       );
   FORALL i IN 1..l_hco_count
      INSERT INTO hig_codes
            (hco_domain
            ,hco_code
            ,hco_meaning
            ,hco_system
            ,hco_seq
            ,hco_start_date
            ,hco_end_date
            )
      SELECT l_tab_hco_domain(i)
            ,l_tab_hco_code(i)
            ,l_tab_hco_meaning(i)
            ,l_tab_hco_system(i)
            ,l_tab_hco_seq(i)
            ,l_tab_hco_start_date(i)
            ,l_tab_hco_end_date(i)
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  hig_codes
                        WHERE  hco_domain = l_tab_hco_domain(i)
                         AND   hco_code   = l_tab_hco_code(i)
                       )
       AND  EXISTS     (SELECT 1
                         FROM  hig_domains
                        WHERE  hdo_domain = l_tab_hco_domain(i)
                       );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- HIG_OPTION_LIST and HIG_OPTION_VALUES
--
   l_tab_hol_id         nm3type.tab_varchar30;
   l_tab_hol_product    nm3type.tab_varchar30;
   l_tab_hol_name       nm3type.tab_varchar30;
   l_tab_hol_remarks    nm3type.tab_varchar2000;
   l_tab_hol_domain     nm3type.tab_varchar30;
   l_tab_hol_datatype   nm3type.tab_varchar30;
   l_tab_hol_mixed_case nm3type.tab_varchar30;
   l_tab_hov_value      nm3type.tab_varchar2000;
--
   c_y_or_n CONSTANT    hig_domains.hdo_domain%TYPE := 'Y_OR_N';
--
   PROCEDURE add (p_hol_id         VARCHAR2
                 ,p_hol_product    VARCHAR2
                 ,p_hol_name       VARCHAR2
                 ,p_hol_remarks    VARCHAR2
                 ,p_hol_domain     VARCHAR2 DEFAULT Null
                 ,p_hol_datatype   VARCHAR2 DEFAULT nm3type.c_varchar
                 ,p_hol_mixed_case VARCHAR2 DEFAULT 'N'
                 ,p_hov_value      VARCHAR2 DEFAULT NULL
                 ) IS
      c_count PLS_INTEGER := l_tab_hol_id.COUNT+1;
   BEGIN
      l_tab_hol_id(c_count)         := p_hol_id;
      l_tab_hol_product(c_count)    := p_hol_product;
      l_tab_hol_name(c_count)       := p_hol_name;
      l_tab_hol_remarks(c_count)    := p_hol_remarks;
      l_tab_hol_domain(c_count)     := p_hol_domain;
      l_tab_hol_datatype(c_count)   := p_hol_datatype;
      l_tab_hol_mixed_case(c_count) := p_hol_mixed_case;
      l_tab_hov_value(c_count)      := p_hov_value;
   END add;
BEGIN
--
   add (p_hol_id         => 'HIGWINTITL'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'Window title for Highways'
       ,p_hol_remarks    => 'This is the window title for Highways by exor'
       ,p_hol_domain     => NULL
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => NULL
       );
       
   add (p_hol_id         => 'SDOSINGSHP'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'Single Shape Inv'
       ,p_hol_remarks    => 'If this is "Y", then inventory shapes will be constructed for each'
                          ||' inventory record as multipart shapes. Otherwise they will be '
                          ||' constructed as single shapes for each location.'
       ,p_hol_domain     => c_y_or_n
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'N'
       );   

   add (p_hol_id         => 'SDODATEVW'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'Date Views as Themes'
       ,p_hol_remarks    => 'If this is "Y", then inventory and route shapes will be registered as'
                          ||' date-tracked views otherwise the date logic is performed by the client GIS'
       ,p_hol_domain     => c_y_or_n
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'N'
       );
       
   add (p_hol_id         => 'REGSDELAY'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'Registration of SDE Layers'
       ,p_hol_remarks    => 'Should the derived Spatial Layers be registered in the SDE schema'
       ,p_hol_domain     => c_y_or_n
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => 'N'
       );

   add (p_hol_id         => 'MAPCAP_DIR'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'The MapCapture Load directory'
       ,p_hol_remarks    => 'The directory on the server where MapCapture survey files will be placed ready for loading into NM3.'
       ,p_hol_domain     => NULL
       ,p_hol_datatype   => nm3type.c_varchar
       ,p_hol_mixed_case => 'Y'
       ,p_hov_value      => NULL
       );
       
   add (p_hol_id         => 'MAPCAP_INT'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'MapCapture load proces timeout'
       ,p_hol_remarks    => 'The interval (in minutes) between MapCapture loads.'
       ,p_hol_domain     => NULL
       ,p_hol_datatype   => nm3type.c_number
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => NULL
       );
    
   add (p_hol_id         => 'MAPCAP_EML'
       ,p_hol_product    => nm3type.c_hig
       ,p_hol_name       => 'MapCapture email address'
       ,p_hol_remarks    => 'The email group id the MapCapture loader will send emails to.'
       ,p_hol_domain     => NULL
       ,p_hol_datatype   => nm3type.c_number
       ,p_hol_mixed_case => 'N'
       ,p_hov_value      => NULL
       );

   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_list
            (hol_id
            ,hol_product
            ,hol_name
            ,hol_remarks
            ,hol_domain
            ,hol_datatype
            ,hol_mixed_case
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hol_product(i)
            ,l_tab_hol_name(i)
            ,l_tab_hol_remarks(i)
            ,l_tab_hol_domain(i)
            ,l_tab_hol_datatype(i)
            ,l_tab_hol_mixed_case(i)
        FROM dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  hig_option_list
                         WHERE  hol_id = l_tab_hol_id(i)
                        );
--
   FORALL i IN 1..l_tab_hol_id.COUNT
      INSERT INTO hig_option_values
            (hov_id
            ,hov_value
            )
      SELECT l_tab_hol_id(i)
            ,l_tab_hov_value(i)
        FROM dual
      WHERE  l_tab_hov_value(i) IS NOT NULL
       AND   NOT EXISTS (SELECT 1
                          FROM  hig_option_values
                         WHERE  hov_id = l_tab_hol_id(i)
                        );
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- ****************
-- *  GRI_PARAMS  *
-- ****************
--
   TYPE tab_rec_grp IS TABLE OF gri_params%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_grp     gri_params%ROWTYPE;
   l_tab_rec_grp tab_rec_grp;
--
   l_grp_count      PLS_INTEGER := 0;
--
   PROCEDURE add_grp IS
   BEGIN
      l_grp_count := l_grp_count + 1;
      l_tab_rec_grp(l_grp_count) := l_rec_grp;
   END add_grp;
--
BEGIN
--

  l_rec_grp.gp_param            := 'P_TEXT_PARAM_1';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := Null;
  l_rec_grp.gp_column           := Null;
  l_rec_grp.gp_descr_column     := Null;
  l_rec_grp.gp_shown_column     := Null;
  l_rec_grp.gp_shown_type       := Null;
  l_rec_grp.gp_descr_type       := Null;
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := Null;
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_TEXT_PARAM_2';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := Null;
  l_rec_grp.gp_column           := Null;
  l_rec_grp.gp_descr_column     := Null;
  l_rec_grp.gp_shown_column     := Null;
  l_rec_grp.gp_shown_type       := Null;
  l_rec_grp.gp_descr_type       := Null;
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := Null;
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_TEXT_PARAM_3';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := Null;
  l_rec_grp.gp_column           := Null;
  l_rec_grp.gp_descr_column     := Null;
  l_rec_grp.gp_shown_column     := Null;
  l_rec_grp.gp_shown_type       := Null;
  l_rec_grp.gp_descr_type       := Null;
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := Null;
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_TEXT_PARAM_4';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := Null;
  l_rec_grp.gp_column           := Null;
  l_rec_grp.gp_descr_column     := Null;
  l_rec_grp.gp_shown_column     := Null;
  l_rec_grp.gp_shown_type       := Null;
  l_rec_grp.gp_descr_type       := Null;
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := Null;
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_HUS_NAME';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := 'HIG_USERS';
  l_rec_grp.gp_column           := 'HUS_NAME';
  l_rec_grp.gp_descr_column     := 'HUS_NAME';
  l_rec_grp.gp_shown_column     := 'HUS_NAME';
  l_rec_grp.gp_shown_type       := 'CHAR';
  l_rec_grp.gp_descr_type       := 'CHAR';
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := 'UPPER';
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_HUS_USERNAME';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := 'HIG_USERS';
  l_rec_grp.gp_column           := 'HUS_USERNAME';
  l_rec_grp.gp_descr_column     := 'HUS_NAME';
  l_rec_grp.gp_shown_column     := 'HUS_USERNAME';
  l_rec_grp.gp_shown_type       := 'CHAR';
  l_rec_grp.gp_descr_type       := 'CHAR';
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := 'UPPER';
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_PRODUCT';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := 'HIG_PRODUCTS';
  l_rec_grp.gp_column           := 'HPR_PRODUCT';
  l_rec_grp.gp_descr_column     := 'HPR_PRODUCT_NAME';
  l_rec_grp.gp_shown_column     := 'HPR_PRODUCT';
  l_rec_grp.gp_shown_type       := 'CHAR';
  l_rec_grp.gp_descr_type       := 'CHAR';
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := 'UPPER';
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_1866_MODE';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := 'GRI_PARAM_LOOKUP';
  l_rec_grp.gp_column           := 'GPL_VALUE';
  l_rec_grp.gp_descr_column     := 'GPL_DESCR';
  l_rec_grp.gp_shown_column     := 'GPL_VALUE';
  l_rec_grp.gp_shown_type       := 'CHAR';
  l_rec_grp.gp_descr_type       := 'CHAR';
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := 'UPPER';
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'P_1868_MODE';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := 'GRI_PARAM_LOOKUP';
  l_rec_grp.gp_column           := 'GPL_VALUE';
  l_rec_grp.gp_descr_column     := 'GPL_DESCR';
  l_rec_grp.gp_shown_column     := 'GPL_VALUE';
  l_rec_grp.gp_shown_type       := 'CHAR';
  l_rec_grp.gp_descr_type       := 'CHAR';
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := 'UPPER';
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'HIG_USER_ID';
  l_rec_grp.gp_param_type       := 'NUMBER';
  l_rec_grp.gp_table            := 'HIG_USERS';
  l_rec_grp.gp_column           := 'HUS_USER_ID';
  l_rec_grp.gp_descr_column     := 'HUS_USERNAME';
  l_rec_grp.gp_shown_column     := 'HUS_INITIALS';
  l_rec_grp.gp_shown_type       := 'CHAR';
  l_rec_grp.gp_descr_type       := Null;
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := Null;
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--
  l_rec_grp.gp_param            := 'DETAIL_OR_SUMMARY';
  l_rec_grp.gp_param_type       := 'CHAR';
  l_rec_grp.gp_table            := 'GRI_PARAM_LOOKUP';
  l_rec_grp.gp_column           := 'GPL_VALUE';
  l_rec_grp.gp_descr_column     := 'GPL_DESCR';
  l_rec_grp.gp_shown_column     := 'GPL_VALUE';
  l_rec_grp.gp_shown_type       := 'CHAR';
  l_rec_grp.gp_descr_type       := 'CHAR';
  l_rec_grp.gp_order            := Null;
  l_rec_grp.gp_case             := Null;
  l_rec_grp.gp_gaz_restriction  := Null;
  add_grp;
--

   FOR i IN 1..l_grp_count
    LOOP
      l_rec_grp := l_tab_rec_grp(i);
      INSERT INTO gri_params
            (
             gp_param
            ,gp_param_type
            ,gp_table
            ,gp_column
            ,gp_descr_column
            ,gp_shown_column
            ,gp_shown_type
            ,gp_descr_type
            ,gp_order
            ,gp_case
            ,gp_gaz_restriction
            )
      SELECT
            l_rec_grp.gp_param
          , l_rec_grp.gp_param_type
          , l_rec_grp.gp_table
          , l_rec_grp.gp_column
          , l_rec_grp.gp_descr_column
          , l_rec_grp.gp_shown_column
          , l_rec_grp.gp_shown_type
          , l_rec_grp.gp_descr_type
          , l_rec_grp.gp_order
          , l_rec_grp.gp_case
          , l_rec_grp.gp_gaz_restriction
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  gri_params
                        WHERE  gp_param = l_rec_grp.gp_param
                       );
   END LOOP;
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- ****************
-- *  GRI_MODULES *
-- ****************
--
   TYPE tab_rec_grm IS TABLE OF gri_modules%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_grm     gri_modules%ROWTYPE;
   l_tab_rec_grm tab_rec_grm;
--
   l_grm_count      PLS_INTEGER := 0;
--
   PROCEDURE add_grm IS
   BEGIN
      l_grm_count := l_grm_count + 1;
      l_tab_rec_grm(l_grm_count) := l_rec_grm;
   END add_grm;
--
BEGIN
--
  l_rec_grm.grm_module       := 'HIG2100';
  l_rec_grm.grm_module_type  := 'SQL';
  l_rec_grm.grm_module_path  := '$PROD_HOME\bin';
  l_rec_grm.grm_file_type    := 'lis';
  l_rec_grm.grm_tag_flag     := 'N';
  l_rec_grm.grm_tag_table    := Null;
  l_rec_grm.grm_tag_column   := Null;
  l_rec_grm.grm_tag_where    := Null;
  l_rec_grm.grm_linesize     := 132;
  l_rec_grm.grm_pagesize     := 66;
  l_rec_grm.grm_pre_process  := Null;
  add_grm;
--
  l_rec_grm.grm_module       := 'HIG1866';
  l_rec_grm.grm_module_type  := 'R25';
  l_rec_grm.grm_module_path  := '$PROD_HOME\bin';
  l_rec_grm.grm_file_type    := 'lis';
  l_rec_grm.grm_tag_flag     := 'N';
  l_rec_grm.grm_tag_table    := Null;
  l_rec_grm.grm_tag_column   := Null;
  l_rec_grm.grm_tag_where    := Null;
  l_rec_grm.grm_linesize     := 132;
  l_rec_grm.grm_pagesize     := 66;
  l_rec_grm.grm_pre_process  := Null;
  add_grm;
--
  l_rec_grm.grm_module       := 'HIG1868';
  l_rec_grm.grm_module_type  := 'R25';
  l_rec_grm.grm_module_path  := '$PROD_HOME\bin';
  l_rec_grm.grm_file_type    := 'lis';
  l_rec_grm.grm_tag_flag     := 'N';
  l_rec_grm.grm_tag_table    := Null;
  l_rec_grm.grm_tag_column   := Null;
  l_rec_grm.grm_tag_where    := Null;
  l_rec_grm.grm_linesize     := 132;
  l_rec_grm.grm_pagesize     := 66;
  l_rec_grm.grm_pre_process  := Null;
  add_grm;
--
l_rec_grm.grm_module       := 'NM0580';
l_rec_grm.grm_module_type  := 'SQL';
l_rec_grm.grm_module_path  := '$PROD_HOME\bin';
l_rec_grm.grm_file_type    := 'lis';
l_rec_grm.grm_tag_flag     := 'N';
l_rec_grm.grm_tag_table    := Null;
l_rec_grm.grm_tag_column   := Null;
l_rec_grm.grm_tag_where    := Null;
l_rec_grm.grm_linesize     := 132;
l_rec_grm.grm_pagesize     := 66;
l_rec_grm.grm_pre_process  := Null;
add_grm;
--
   FOR i IN 1..l_grm_count
    LOOP
      l_rec_grm := l_tab_rec_grm(i);
      INSERT INTO gri_modules
            (
             grm_module
            ,grm_module_type
            ,grm_module_path
            ,grm_file_type
            ,grm_tag_flag
            ,grm_tag_table
            ,grm_tag_column
            ,grm_tag_where
            ,grm_linesize
            ,grm_pagesize
            ,grm_pre_process
            )
      SELECT
             l_rec_grm.grm_module
            ,l_rec_grm.grm_module_type
            ,l_rec_grm.grm_module_path
            ,l_rec_grm.grm_file_type
            ,l_rec_grm.grm_tag_flag
            ,l_rec_grm.grm_tag_table
            ,l_rec_grm.grm_tag_column
            ,l_rec_grm.grm_tag_where
            ,l_rec_grm.grm_linesize
            ,l_rec_grm.grm_pagesize
            ,l_rec_grm.grm_pre_process
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  gri_modules
                        WHERE  grm_module = l_rec_grm.grm_module
                       );
   END LOOP;
--
END;
/
--
-------------------------------------------------------------------------------------------------
--
DECLARE
--
-- **********************
-- *  GRI_MODULE_PARAMS *
-- **********************
--
   TYPE tab_rec_gmp IS TABLE OF gri_module_params%ROWTYPE INDEX BY BINARY_INTEGER;
--
   l_rec_gmp     gri_module_params%ROWTYPE;
   l_tab_rec_gmp tab_rec_gmp;
--
   l_gmp_count      PLS_INTEGER := 0;
--
   PROCEDURE add_gmp IS
   BEGIN
      l_gmp_count := l_gmp_count + 1;
      l_tab_rec_gmp(l_gmp_count) := l_rec_gmp;
   END add_gmp;
--
BEGIN
--
  l_rec_gmp.gmp_module           := 'HIG2100';
  l_rec_gmp.gmp_param            := 'P_TEXT_PARAM_1';
  l_rec_gmp.gmp_seq              := 10;
  l_rec_gmp.gmp_param_descr      := 'Organisation Name';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := 'N';
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Organisation Name';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG2100';
  l_rec_gmp.gmp_param            := 'P_HUS_NAME';
  l_rec_gmp.gmp_seq              := 20;
  l_rec_gmp.gmp_param_descr      := 'Contact Name';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := 'HIG_USERS';
  l_rec_gmp.gmp_default_column   := 'HUS_NAME';
  l_rec_gmp.gmp_default_where    := 'HUS_USERNAME = USER';
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := 'N';
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Contact Name';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG2100';
  l_rec_gmp.gmp_param            := 'P_TEXT_PARAM_2';
  l_rec_gmp.gmp_seq              := 30;
  l_rec_gmp.gmp_param_descr      := 'Server Make/Type';
  l_rec_gmp.gmp_mandatory        := 'N';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := 'N';
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Server Make/Type';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG2100';
  l_rec_gmp.gmp_param            := 'P_TEXT_PARAM_3';
  l_rec_gmp.gmp_seq              := 40;
  l_rec_gmp.gmp_param_descr      := 'Available Memory';
  l_rec_gmp.gmp_mandatory        := 'N';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := 'N';
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Available Memory';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG2100';
  l_rec_gmp.gmp_param            := 'P_TEXT_PARAM_4';
  l_rec_gmp.gmp_seq              := 50;
  l_rec_gmp.gmp_param_descr      := 'Disk Space';
  l_rec_gmp.gmp_mandatory        := 'N';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := 'N';
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Disk Space';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG2100';
  l_rec_gmp.gmp_param            := 'P_HUS_USERNAME';
  l_rec_gmp.gmp_seq              := 60;
  l_rec_gmp.gmp_param_descr      := 'Highways Owner';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := 'HIG_USERS';
  l_rec_gmp.gmp_default_column   := 'HUS_USERNAME';
  l_rec_gmp.gmp_default_where    := 'HUS_IS_HIG_OWNER_FLAG = ''Y''';
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := 'N';
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Highways Owner, for example, HIGHWAYS';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG2100';
  l_rec_gmp.gmp_param            := 'A_NUMBER';
  l_rec_gmp.gmp_seq              := 70;
  l_rec_gmp.gmp_param_descr      := 'Extent Threshold';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := 'DUAL';
  l_rec_gmp.gmp_default_column   := '''25''';
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := 'N';
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Objects that have extended greater than the given threshold will be highlighted';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;

--
-- REMOVE redundant hig1862 params and replace 
--
DELETE FROM GRI_MODULE_PARAMS
 WHERE GMP_MODULE = 'HIG1862'
  AND  GMP_PARAM = 'P_ADMIN_UNIT';
  
DELETE FROM GRI_MODULE_PARAMS
 WHERE GMP_MODULE = 'HIG1862'
  AND  GMP_PARAM = 'P_ADMIN_UNIT_TYPE';
--
--
--    
  l_rec_gmp.gmp_module           := 'HIG1862';
  l_rec_gmp.gmp_param            := 'P_ADMIN_UNIT_TYPE';
  l_rec_gmp.gmp_seq              := 1;
  l_rec_gmp.gmp_param_descr      := 'Admin Unit Type';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := '(NAT_ADMIN_TYPE IN (SELECT NAT_ADMIN_TYPE FROM NM_AU_TYPES))';
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Admin Type';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--    
  l_rec_gmp.gmp_module           := 'HIG1862';
  l_rec_gmp.gmp_param            := 'DETAIL_OR_SUMMARY';
  l_rec_gmp.gmp_seq              := 2;
  l_rec_gmp.gmp_param_descr      := 'Detail or Summary Mode';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := 'GPL_PARAM=''DETAIL_OR_SUMMARY''';
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Report Mode';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--    
  l_rec_gmp.gmp_module           := 'HIG1862';
  l_rec_gmp.gmp_param            := 'EFFECTIVE_DATE';
  l_rec_gmp.gmp_seq              := 3;
  l_rec_gmp.gmp_param_descr      := 'Effective Date';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := 'DUAL';
  l_rec_gmp.gmp_default_column   := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Effective Date';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--  
  l_rec_gmp.gmp_module           := 'HIG1866';
  l_rec_gmp.gmp_param            := 'P_1866_MODE';
  l_rec_gmp.gmp_seq              := 1;
  l_rec_gmp.gmp_param_descr      := 'Report Mode';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := 'GPL_PARAM=''P_1866_MODE''';
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Report Mode';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG1866';
  l_rec_gmp.gmp_param            := 'P_ADMIN_UNIT_TYPE';
  l_rec_gmp.gmp_seq              := 2;
  l_rec_gmp.gmp_param_descr      := 'Admin Unit Type';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Admin Unit Type';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG1866';
  l_rec_gmp.gmp_param            := 'HIG_USER_ID';
  l_rec_gmp.gmp_seq              := 3;
  l_rec_gmp.gmp_param_descr      := 'Username';
  l_rec_gmp.gmp_mandatory        := 'N';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Username';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG1866';
  l_rec_gmp.gmp_param            := 'EFFECTIVE_DATE';
  l_rec_gmp.gmp_seq              := 4;
  l_rec_gmp.gmp_param_descr      := 'Effective Date';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := 'DUAL';
  l_rec_gmp.gmp_default_column   := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Effective Date';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG1868';
  l_rec_gmp.gmp_param            := 'P_1868_MODE';
  l_rec_gmp.gmp_seq              := 1;
  l_rec_gmp.gmp_param_descr      := 'Report Mode';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := 'GPL_PARAM=''P_1868_MODE''';
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Report Mode';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG1868';
  l_rec_gmp.gmp_param            := 'P_PRODUCT';
  l_rec_gmp.gmp_seq              := 2;
  l_rec_gmp.gmp_param_descr      := 'Product';
  l_rec_gmp.gmp_mandatory        := 'N';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Product';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--
  l_rec_gmp.gmp_module           := 'HIG1868';
  l_rec_gmp.gmp_param            := 'HIG_MODULE_ROLE';
  l_rec_gmp.gmp_seq              := 3;
  l_rec_gmp.gmp_param_descr      := 'Role';
  l_rec_gmp.gmp_mandatory        := 'N';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := 'HRO_PRODUCT = NVL(:P_PRODUCT,HRO_PRODUCT)';
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Role';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--  
  l_rec_gmp.gmp_module           := 'HIG1868';
  l_rec_gmp.gmp_param            := 'P_HUS_NAME';
  l_rec_gmp.gmp_seq              := 4;
  l_rec_gmp.gmp_param_descr      := 'Username';
  l_rec_gmp.gmp_mandatory        := 'N';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := Null;
  l_rec_gmp.gmp_default_column   := Null;
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'Y';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Username';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
--  
  l_rec_gmp.gmp_module           := 'HIG1868';
  l_rec_gmp.gmp_param            := 'EFFECTIVE_DATE';
  l_rec_gmp.gmp_seq              := 5;
  l_rec_gmp.gmp_param_descr      := 'Effective Date';
  l_rec_gmp.gmp_mandatory        := 'Y';
  l_rec_gmp.gmp_no_allowed       := 1;
  l_rec_gmp.gmp_where            := Null;
  l_rec_gmp.gmp_tag_restriction  := 'N';
  l_rec_gmp.gmp_tag_where        := Null;
  l_rec_gmp.gmp_default_table    := 'DUAL';
  l_rec_gmp.gmp_default_column   := 'TO_CHAR(SYSDATE,''DD-MON-YYYY'')';
  l_rec_gmp.gmp_default_where    := Null;
  l_rec_gmp.gmp_visible          := 'Y';
  l_rec_gmp.gmp_gazetteer        := 'N';
  l_rec_gmp.gmp_lov              := 'N';
  l_rec_gmp.gmp_val_global       := Null;
  l_rec_gmp.gmp_wildcard         := 'N';
  l_rec_gmp.gmp_hint_text        := 'Please enter Effective Date';
  l_rec_gmp.gmp_allow_partial    := 'N';
  add_gmp;
-- 

   FOR i IN 1..l_gmp_count
    LOOP
      l_rec_gmp := l_tab_rec_gmp(i);
      INSERT INTO gri_module_params
            (
             gmp_module
            ,gmp_param
            ,gmp_seq
            ,gmp_param_descr
            ,gmp_mandatory
            ,gmp_no_allowed
            ,gmp_where
            ,gmp_tag_restriction
            ,gmp_tag_where
            ,gmp_default_table
            ,gmp_default_column
            ,gmp_default_where
            ,gmp_visible
            ,gmp_gazetteer
            ,gmp_lov
            ,gmp_val_global
            ,gmp_wildcard
            ,gmp_hint_text
            ,gmp_allow_partial
            )
      SELECT
            l_rec_gmp.gmp_module
           ,l_rec_gmp.gmp_param
           ,l_rec_gmp.gmp_seq
           ,l_rec_gmp.gmp_param_descr
           ,l_rec_gmp.gmp_mandatory
           ,l_rec_gmp.gmp_no_allowed
           ,l_rec_gmp.gmp_where
           ,l_rec_gmp.gmp_tag_restriction
           ,l_rec_gmp.gmp_tag_where
           ,l_rec_gmp.gmp_default_table
           ,l_rec_gmp.gmp_default_column
           ,l_rec_gmp.gmp_default_where
           ,l_rec_gmp.gmp_visible
           ,l_rec_gmp.gmp_gazetteer
           ,l_rec_gmp.gmp_lov
           ,l_rec_gmp.gmp_val_global
           ,l_rec_gmp.gmp_wildcard
           ,l_rec_gmp.gmp_hint_text
           ,l_rec_gmp.gmp_allow_partial
       FROM  dual
      WHERE NOT EXISTS (SELECT 1
                         FROM  gri_module_params
                        WHERE  gmp_module = l_rec_gmp.gmp_module
                        AND    gmp_param  = l_rec_gmp.gmp_param
                       );
   END LOOP;
--
END;
/

-- 
-- GRI_PARAM_DEPENDANCIES
--
INSERT INTO GRI_PARAM_DEPENDENCIES ( GPD_MODULE, GPD_DEP_PARAM,
GPD_INDEP_PARAM ) VALUES ( 
'HIG1868', 'HIG_MODULE_ROLE', 'P_PRODUCT'); 

-- 
-- GRI_PARAM_LOOKUP 
--
INSERT INTO GRI_PARAM_LOOKUP ( GPL_PARAM, GPL_VALUE, GPL_DESCR ) VALUES ( 
'DETAIL_OR_SUMMARY', 'D', 'Detail Mode'); 
INSERT INTO GRI_PARAM_LOOKUP ( GPL_PARAM, GPL_VALUE, GPL_DESCR ) VALUES ( 
'DETAIL_OR_SUMMARY', 'S', 'Summary Mode'); 
INSERT INTO GRI_PARAM_LOOKUP ( GPL_PARAM, GPL_VALUE, GPL_DESCR ) VALUES ( 
'P_1866_MODE', 'A', 'List of Users by Admin Unit'); 
INSERT INTO GRI_PARAM_LOOKUP ( GPL_PARAM, GPL_VALUE, GPL_DESCR ) VALUES ( 
'P_1866_MODE', 'B', 'List of Admin Units by User'); 
INSERT INTO GRI_PARAM_LOOKUP ( GPL_PARAM, GPL_VALUE, GPL_DESCR ) VALUES ( 
'P_1868_MODE', 'A', 'List of Users by Role'); 
INSERT INTO GRI_PARAM_LOOKUP ( GPL_PARAM, GPL_VALUE, GPL_DESCR ) VALUES ( 
'P_1868_MODE', 'B', 'List of Roles by User'); 

--

INSERT INTO hig_option_values
      (hov_id
      ,hov_value
      )
SELECT 'HIGWINTITL'
      ,hau_name
 FROM  hig_admin_units
WHERE  hau_level = 1
 AND   ROWNUM    = 1
 AND   NOT EXISTS (SELECT 1
                    FROM  hig_option_values
                   WHERE  hov_id = 'HIGWINTITL'
                  )
/

INSERT INTO  nm_upload_file_gateways
   (nufg_table_name)
selECT 'NM_MRG_QUERY_RESULTS'
 FROM  dual
WHERE  NOT EXISTS (SELECT 1
                   FROM  nm_upload_file_gateways
                   WHERE  nufg_table_name = 'NM_MRG_QUERY_RESULTS'
                 )
/

INSERT INTO nm_upload_file_gateway_cols
    (nufgc_nufg_table_name
    ,nufgc_seq
    ,nufgc_column_name
    ,nufgc_column_datatype
    )
SELECT 'NM_MRG_QUERY_RESULTS'
      ,1
      ,'NQR_MRG_JOB_ID'
      ,'NUMBER'
 FROM  dual
 WHERE NOT EXISTS (SELECT 1
                    FROM nm_upload_file_gateway_cols
                   WHERE nufgc_nufg_table_name = 'NM_MRG_QUERY_RESULTS'
                    AND (nufgc_seq = 1 OR nufgc_column_name = 'NQR_MRG_JOB_ID')
                  )
/

INSERT INTO nm_inv_categories ( nic_category, nic_descr )
SELECT 'G', 'Group Attribute Inventory'
FROM dual
WHERE NOT EXISTS(SELECT 1 FROM nm_inv_categories WHERE nic_category = 'G');

INSERT INTO nm_inv_category_modules ( icm_nic_category, icm_hmo_module,
icm_updatable ) SELECT
'G', 'NM0510', 'N' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM nm_inv_category_modules
                  WHERE icm_nic_category = 'G'
                  AND icm_hmo_module = 'NM0510');
                  
INSERT INTO nm_inv_category_modules ( icm_nic_category, icm_hmo_module,
icm_updatable ) SELECT
'G', 'NM0560', 'N' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM nm_inv_category_modules
                  WHERE icm_nic_category = 'G'
                  AND icm_hmo_module = 'NM0560');

INSERT INTO nm_inv_category_modules ( icm_nic_category, icm_hmo_module,
icm_updatable ) SELECT
'G', 'NM0570', 'N' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM nm_inv_category_modules
                  WHERE icm_nic_category = 'G'
                  AND icm_hmo_module = 'NM0570');
                  
INSERT INTO nm_inv_category_modules ( icm_nic_category, icm_hmo_module,
icm_updatable ) SELECT
'G', 'NM0110', 'Y' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM nm_inv_category_modules
                  WHERE icm_nic_category = 'G'
                  AND icm_hmo_module = 'NM0110');

INSERT INTO nm_inv_category_modules ( icm_nic_category, icm_hmo_module,
icm_updatable ) SELECT
'G', 'NM0115', 'Y' FROM dual
WHERE NOT EXISTS (SELECT 1 FROM nm_inv_category_modules
                  WHERE icm_nic_category = 'G'
                  AND icm_hmo_module = 'NM0115');

-- Adding hig_option for MapCapture group

declare
l_mc_group nm_mail_groups%ROWTYPE;
begin
  l_mc_group.nmg_id   := nm3seq.next_nmg_id_seq;
  l_mc_group.nmg_name := 'MapCapture Loader Admin';
   
  nm3ins.ins_nmg(p_rec_nmg => l_mc_group);

  INSERT INTO HIG_OPTION_VALUES ( HOV_ID, HOV_VALUE ) VALUES ( 
  'MAPCAP_EML', l_mc_group.nmg_id); 
end;
/
-- 
---REFRESH OF DOC_TYPES -------------------------------------------------------------------------------------
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'CLAM'
       ,'CLAIM'
       ,'Claim'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'CLAM');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'COMM'
       ,'Comments'
       ,'Comment documents allow up to 2000 characters of text to be stored within the document record itself.  They may be recorded using the "View Associated Documents" module.'
       ,'Y'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'COMM');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'COMP'
       ,'Complaints'
       ,'Complaints must be entered through the "Maintain Complaints" module, as there are numerous additional fields to be entered.'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'COMP');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'CORR'
       ,'CORRESPONDENCE'
       ,'Correspondence'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'CORR');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'CPLI'
       ,'COMPLIMENT'
       ,'Compliment'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'CPLI');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'PETI'
       ,'PETITION'
       ,'Petition'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'PETI');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'REPT'
       ,'Report'
       ,'Report'
       ,'N'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'REPT');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'REQS'
       ,'REQUEST_FOR_SERVICE'
       ,'Request For Service'
       ,'N'
       ,'Y'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'REQS');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'TRO'
       ,'Traffic Regulation Order'
       ,'Traffic Regulation Order'
       ,'N'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'TRO');
--
INSERT INTO DOC_TYPES
       (DTP_CODE
       ,DTP_NAME
       ,DTP_DESCR
       ,DTP_ALLOW_COMMENTS
       ,DTP_ALLOW_COMPLAINTS
       ,DTP_START_DATE
       ,DTP_END_DATE
       )
SELECT 
        'UKNW'
       ,'Unknown Document Type'
       ,'Document upgraded at Oracle*Highways V1.6.2.0'
       ,'N'
       ,'N'
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_TYPES
                   WHERE DTP_CODE = 'UKNW');
                   
COMMIT;                                       
-- 
---REFRESH OF DOC_CLASS--------------------------------------------------------------------------------
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'WOLF'
       ,'Woolf'
       ,'Woolf Claim'
       ,null
       ,null
       ,'CLAM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'CLAM'
                    AND  DCL_CODE = 'WOLF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'APPL'
       ,'Appeal'
       ,'Appeal'
       ,null
       ,null
       ,'COMP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'COMP'
                    AND  DCL_CODE = 'APPL');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'FRML'
       ,'Formal'
       ,'Formal'
       ,null
       ,null
       ,'COMP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'COMP'
                    AND  DCL_CODE = 'FRML');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'IFRM'
       ,'Informal'
       ,'Informal'
       ,null
       ,null
       ,'COMP' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'COMP'
                    AND  DCL_CODE = 'IFRM');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CINC'
       ,'Commercial in Confidence'
       ,''
       ,null
       ,null
       ,'REPT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'REPT'
                    AND  DCL_CODE = 'CINC');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CONF'
       ,'Confidential'
       ,''
       ,null
       ,null
       ,'REPT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'REPT'
                    AND  DCL_CODE = 'CONF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'NONE'
       ,'Unclassified'
       ,''
       ,null
       ,null
       ,'REPT' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'REPT'
                    AND  DCL_CODE = 'NONE');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CINC'
       ,'Commercial in Confidence'
       ,''
       ,null
       ,null
       ,'TRO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'TRO'
                    AND  DCL_CODE = 'CINC');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CONF'
       ,'Confidential'
       ,''
       ,null
       ,null
       ,'TRO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'TRO'
                    AND  DCL_CODE = 'CONF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'NONE'
       ,'Unclassified'
       ,''
       ,null
       ,null
       ,'TRO' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'TRO'
                    AND  DCL_CODE = 'NONE');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'APPL'
       ,'Appeal'
       ,'Appeal'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'APPL');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CINC'
       ,'Commercial in Confidence'
       ,''
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'CINC');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'CONF'
       ,'Confidential'
       ,''
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'CONF');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'FRML'
       ,'Formal'
       ,'Formal'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'FRML');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'IFRM'
       ,'Informal'
       ,'Informal'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'IFRM');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'NONE'
       ,'Unclassified'
       ,''
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'NONE');
--
INSERT INTO DOC_CLASS
       (DCL_CODE
       ,DCL_NAME
       ,DCL_DESCR
       ,DCL_START_DATE
       ,DCL_END_DATE
       ,DCL_DTP_CODE
       )
SELECT 
        'WOLF'
       ,'Woolf'
       ,'Woolf Claim'
       ,null
       ,null
       ,'UKNW' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM DOC_CLASS
                   WHERE DCL_DTP_CODE = 'UKNW'
                    AND  DCL_CODE = 'WOLF');
COMMIT;                    
-- 
--- HIG_STANDARD_FAVOURITES ---------------------------------------------------------------------------------
--
--
-- Columns
-- HSTF_PARENT                    NOT NULL VARCHAR2(30)
--   HSTF_PK (Pos 1)
-- HSTF_CHILD                     NOT NULL VARCHAR2(30)
--   HSTF_PK (Pos 2)
-- HSTF_DESCR                     NOT NULL VARCHAR2(80)
-- HSTF_TYPE                      NOT NULL VARCHAR2(1)
-- HSTF_ORDER                              NUMBER(22)
--
-- Constraints
-- HSTF_PK - Primary Key
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ROOT'
       ,'FAVOURITES'
       ,'Launchpad'
       ,'F'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ROOT'
                    AND  HSTF_CHILD = 'FAVOURITES');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_ORGS'
       ,'Organisations'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_ORGS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'MRWA'
       ,'MRWA Specifics'
       ,'F'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'MRWA');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS'
       ,'SWR_ORG_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS'
                    AND  HSTF_CHILD = 'SWR_ORG_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'ACC'
       ,'accidents manager'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'ACC');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'DOC'
       ,'document manager'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'DOC');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG'
       ,'highways'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'HIG');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'MAI'
       ,'maintenance manager'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'MAI');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'NET'
       ,'network manager'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'NET');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'PMS'
       ,'structural projects v2'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'PMS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'ENQ'
       ,'public enquiry manager'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'ENQ');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'CLM'
       ,'street lighting manager'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'CLM');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'SWR'
       ,'street works manager'
       ,'F'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'SWR');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'STP'
       ,'structural projects v3'
       ,'F'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'STP');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'STR'
       ,'structures manager'
       ,'F'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'STR');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'TM'
       ,'traffic manager'
       ,'F'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'TM');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS'
       ,'SWR_WORKS_QUERY'
       ,'Query'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS'
                    AND  HSTF_CHILD = 'SWR_WORKS_QUERY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_WORKS'
       ,'Works'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_WORKS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_COMMENTS'
       ,'Comments'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_COMMENTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_INSP'
       ,'Inspections'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_INSP');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_GAZ'
       ,'Gazetteer'
       ,'F'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_GAZ');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_COORD'
       ,'Coordindation'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_COORD');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_BATCH'
       ,'Batch Processing'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_BATCH');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_REPORTS'
       ,'SWR1780'
       ,'Batch File Listing'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_REPORTS'
                    AND  HSTF_CHILD = 'SWR1780');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1710'
       ,'Maintain Inspection Item Status Codes'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1710');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1700'
       ,'Maintain Defect Notice Messages'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1700');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1690'
       ,'Maintain Inspection Outcomes'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1690');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1680'
       ,'Maintain Inpection Types'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1680');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1670'
       ,'Maintain Sample Inspection Categories'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1670');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1660'
       ,'Maintain Inpection Categories'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1660');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1350'
       ,'Maintain ASD Coordinates'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1350');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1220'
       ,'Print Works Details'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1220');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1570'
       ,'Maintain Works/Sites Combinations'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1570');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1560'
       ,'Maintain Allowable Site Updates'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1560');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1159'
       ,'Works with a Section 74 Duration Challenge'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1159');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1158'
       ,'Works Due a Section 74 Start'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1158');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1157'
       ,'Works Due to Complete'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1157');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_REPORTS'
       ,'SWR1610'
       ,'Batch Files Processed'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_REPORTS'
                    AND  HSTF_CHILD = 'SWR1610');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1650'
       ,'Section 74 Charges Invoice'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1650');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1640'
       ,'Maintain Section 74 Charging Profile'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1640');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1630'
       ,'Maintain Section 74 Charges'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1630');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1225'
       ,'Generic Works Report'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1225');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COMMENTS_ADMIN'
       ,'SWR1112'
       ,'Comments Sent/Received'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COMMENTS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1112');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1620'
       ,'Maintain Batch Messages'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1620');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1305'
       ,'Inspection History'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1305');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1230'
       ,'Generic Inspections Report'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1230');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1770'
       ,'View Inspection Defects'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1770');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1760'
       ,'View Inspections History'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1760');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1750'
       ,'Inspections Sent / Received'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1750');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1720'
       ,'Maintain Allowable Inpection Items'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1720');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1339'
       ,'Maintain Special Designation Coordinates'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1339');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1370'
       ,'Maintain Towns / Localities'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1370');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1380'
       ,'Non Works Activity'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1380');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_QUERY'
       ,'SWR1390'
       ,'View Non Works Activity'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
                    AND  HSTF_CHILD = 'SWR1390');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1400'
       ,'Allocate Provisional Works'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1400');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1401'
       ,'Maintain Work Types'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1401');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1403'
       ,'Maintain Notice Types'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1403');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1450'
       ,'SWA Organisations'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1450');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORG_REPORTS'
       ,'SWR1451'
       ,'Organisation Data Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORG_REPORTS'
                    AND  HSTF_CHILD = 'SWR1451');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1461'
       ,'Maintain District Hierarchy'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1461');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1471'
       ,'Contact List'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1471');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR1480'
       ,'Coordination Groups'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1480');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN_REF'
       ,'SWR1490'
       ,'Standard Text'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1490');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1500'
       ,'Reference Data'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1500');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_REPORTS'
       ,'SWR1501'
       ,'Reference Data Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_REPORTS'
                    AND  HSTF_CHILD = 'SWR1501');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ADMIN'
       ,'SWR1510'
       ,'Maintain Interface Mappings'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ADMIN'
                    AND  HSTF_CHILD = 'SWR1510');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN_REF'
       ,'SWR1511'
       ,'Maintain Reinstatement Categories'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1511');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1512'
       ,'Maintain Works Rules'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1512');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1513'
       ,'Maintain Site Rules'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1513');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN_REF'
       ,'SWR1514'
       ,'Maintain Sample Inspection Category Items'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1514');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1515'
       ,'Maintain System Options'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1515');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1517'
       ,'Maintain Defect Inspection Schedule'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1517');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1338'
       ,'Maintain Reinstatement Designation Coordinates'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1338');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1290'
       ,'Schedule Inspections'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1290');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1292'
       ,'Works Inspection Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1292');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1294'
       ,'Prospective Inspections Report'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1294');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1325'
       ,'Sample Inspections Invoice Report'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1325');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1326'
       ,'Inspections Invoice'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1326');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1328'
       ,'Chargeable Notices Invoice'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1328');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1330'
       ,'Maintain Street Gazetteer'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1330');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1332'
       ,'Maintain Street Coordinates'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1332');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1333'
       ,'Maintain Street Reinstatement Designations'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1333');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN_REF'
       ,'SWR1334'
       ,'Maintain Designation Types'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1334');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1335'
       ,'Maintain Street Special Designations'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1335');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1336'
       ,'Maintain Street Naming Authorities'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1336');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1337'
       ,'Maintain Additional Street Data'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1337');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1209'
       ,'Expiring Reinstatement Guarantees'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1209');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1212'
       ,'Interim Reinstatements > 6 Months Old'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1212');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1240'
       ,'Maintain Annual Inspection Profiles'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1240');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR1250'
       ,'Maintain Inspection Details'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR1250');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1255'
       ,'Annual Inspection Profiles'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1255');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1256'
       ,'Sample Inspection Quotas Report'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1256');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_REPORTS'
       ,'SWR1257'
       ,'Inspection Performance'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_REPORTS'
                    AND  HSTF_CHILD = 'SWR1257');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1060'
       ,'System Definitions'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1060');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_QUERY'
       ,'SWR1070'
       ,'Query Works/Sites'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
                    AND  HSTF_CHILD = 'SWR1070');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COMMENTS_ADMIN'
       ,'SWR1111'
       ,'Maintain Works Comments'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COMMENTS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1111');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1120'
       ,'Notices Sent/Received'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF_ADMIN'
       ,'SWR1051'
       ,'Maintain User Definitions'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF_ADMIN'
                    AND  HSTF_CHILD = 'SWR1051');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1156'
       ,'Works History'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1156');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1180'
       ,'Merge Unattributable Works'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1180');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_QUERY'
       ,'SWR1189'
       ,'Query Works History'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_QUERY'
                    AND  HSTF_CHILD = 'SWR1189');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR1190'
       ,'Maintain Works / Reinstatement Details'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR1190');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1193'
       ,'Works Overdue'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1193');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_REPORTS'
       ,'SWR1195'
       ,'Notice Analysis Report'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'SWR1195');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COORD_REPORTS'
       ,'SWR1197'
       ,'Coordination Planning'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COORD_REPORTS'
                    AND  HSTF_CHILD = 'SWR1197');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COORD_REPORTS'
       ,'SWR1198'
       ,'Conflicting Works'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COORD_REPORTS'
                    AND  HSTF_CHILD = 'SWR1198');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR1530'
       ,'Streets of Interest'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR1530');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_REPORTS'
       ,'SWR1550'
       ,'SOI Gazetteer Data Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_REPORTS'
                    AND  HSTF_CHILD = 'SWR1550');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_REPORTS'
       ,'SWR1551'
       ,'Authority Gazetteer Data Report'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_REPORTS'
                    AND  HSTF_CHILD = 'SWR1551');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR1600'
       ,'Upload/Download Utility'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR1600');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR1601'
       ,'Automatic Upload/Download Utility'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR1601');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1602'
       ,'Maintain Automatic Batch Processes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1602');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1603'
       ,'Maintain Automatic Batch Rules'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1603');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN_REF'
       ,'SWR1604'
       ,'Maintain Automatic Batch Operations'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1604');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR1605'
       ,'Monitor Batch File Status'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR1605');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN_REF'
       ,'SWR1519'
       ,'Maintain Notice Charges'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN_REF'
                    AND  HSTF_CHILD = 'SWR1519');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP'
       ,'SWR_INSP_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP'
                    AND  HSTF_CHILD = 'SWR_INSP_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS'
       ,'SWR_WORKS_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS'
                    AND  HSTF_CHILD = 'SWR_WORKS_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS'
       ,'SWR_WORKS_REPORTS'
       ,'Reports'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS'
                    AND  HSTF_CHILD = 'SWR_WORKS_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP'
       ,'SWR_INSP_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP'
                    AND  HSTF_CHILD = 'SWR_INSP_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COMMENTS'
       ,'SWR_COMMENTS_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COMMENTS'
                    AND  HSTF_CHILD = 'SWR_COMMENTS_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS'
       ,'SWR_ORGS_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS'
                    AND  HSTF_CHILD = 'SWR_ORGS_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ'
       ,'SWR_GAZ_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ'
                    AND  HSTF_CHILD = 'SWR_GAZ_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ'
       ,'SWR_GAZ_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ'
                    AND  HSTF_CHILD = 'SWR_GAZ_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_COORD'
       ,'SWR_COORD_REPORTS'
       ,'Reports'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_COORD'
                    AND  HSTF_CHILD = 'SWR_COORD_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR'
       ,'SWR_REF'
       ,'Reference Data'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR'
                    AND  HSTF_CHILD = 'SWR_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF'
       ,'SWR_REF_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF'
                    AND  HSTF_CHILD = 'SWR_REF_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_WORKS_ADMIN'
       ,'SWR_WORKS_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_WORKS_ADMIN'
                    AND  HSTF_CHILD = 'SWR_WORKS_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_INSP_ADMIN'
       ,'SWR_INSP_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_INSP_ADMIN'
                    AND  HSTF_CHILD = 'SWR_INSP_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_GAZ_ADMIN'
       ,'SWR_GAZ_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_GAZ_ADMIN'
                    AND  HSTF_CHILD = 'SWR_GAZ_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH'
       ,'SWR_BATCH_ADMIN'
       ,'Admin'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH'
                    AND  HSTF_CHILD = 'SWR_BATCH_ADMIN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH_ADMIN'
       ,'SWR_BATCH_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH_ADMIN'
                    AND  HSTF_CHILD = 'SWR_BATCH_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_BATCH'
       ,'SWR_BATCH_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_BATCH'
                    AND  HSTF_CHILD = 'SWR_BATCH_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_ORGS_ADMIN'
       ,'SWR_ORGS_ADMIN_REF'
       ,'Reference Data'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_ORGS_ADMIN'
                    AND  HSTF_CHILD = 'SWR_ORGS_ADMIN_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'SWR_REF'
       ,'SWR_REF_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'SWR_REF'
                    AND  HSTF_CHILD = 'SWR_REF_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_NET_MANAGEMENT'
       ,'Network Management'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET'
                    AND  HSTF_CHILD = 'NET_NET_MANAGEMENT');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_NETWORK'
       ,'Network'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET'
                    AND  HSTF_CHILD = 'NET_NETWORK');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_INVENTORY'
       ,'Inventory'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET'
                    AND  HSTF_CHILD = 'NET_INVENTORY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_QUERIES'
       ,'Queries'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET'
                    AND  HSTF_CHILD = 'NET_QUERIES');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET'
       ,'NET_REF'
       ,'Reference Data'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET'
                    AND  HSTF_CHILD = 'NET_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_NETWORK'
       ,'NM0001'
       ,'Node Types'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_NETWORK'
                    AND  HSTF_CHILD = 'NM0001');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_NETWORK'
       ,'NM0002'
       ,'Network Types'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_NETWORK'
                    AND  HSTF_CHILD = 'NM0002');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_'
       ,'NM0003'
       ,'Layers'
       ,'M'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_'
                    AND  HSTF_CHILD = 'NM0003');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_NETWORK'
       ,'NM0004'
       ,'Group Types'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_NETWORK'
                    AND  HSTF_CHILD = 'NM0004');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0101'
       ,'Nodes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
                    AND  HSTF_CHILD = 'NM0101');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0105'
       ,'Elements'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
                    AND  HSTF_CHILD = 'NM0105');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0110'
       ,'Groups of Sections'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
                    AND  HSTF_CHILD = 'NM0110');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NET_MANAGEMENT'
       ,'NM0115'
       ,'Groups of Groups'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NET_MANAGEMENT'
                    AND  HSTF_CHILD = 'NM0115');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0120'
       ,'Create Network Extent'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0200'
       ,'Split Element'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0200');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0201'
       ,'Merge Elements'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0201');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0202'
       ,'Replace Element'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0202');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0203'
       ,'Undo Split'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0203');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0204'
       ,'Undo Merge'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0204');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0205'
       ,'Undo Replace'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0205');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0206'
       ,'Close Element'
       ,'M'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0206');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0207'
       ,'Unclose Element'
       ,'M'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0207');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0220'
       ,'Reclassify Element'
       ,'M'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0220');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0301'
       ,'Inventory Domains'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0301');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0305'
       ,'XSP and Reversal Rules'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0305');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0306'
       ,'Inventory XSPs'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0306');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0410'
       ,'Inventory Metamodel'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0410');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM0500'
       ,'Network Walker'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM0500');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0510'
       ,'Inventory Items'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY'
                    AND  HSTF_CHILD = 'NM0510');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0530'
       ,'Global Inventory Update'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY'
                    AND  HSTF_CHILD = 'NM0530');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0550'
       ,'Cross Attribute Validation Setup'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0550');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0560'
       ,'Assets On A Route'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY'
                    AND  HSTF_CHILD = 'NM0560');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM1200'
       ,'SLK Calculator'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM1200');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM2000'
       ,'Recalibrate Element'
       ,'M'
       ,14 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM2000');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7040'
       ,'PBI Queries'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM7040');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7041'
       ,'PBI Query Results'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM7041');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7050'
       ,'Merge Query Setup'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM7050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7051'
       ,'Merge Query Results'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM7051');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7053'
       ,'Merge Query Defaults'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM7053');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7055'
       ,'Merge File Definition'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM7055');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM7057'
       ,'Merge Results Extract'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM7057');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM1201'
       ,'Offset Calculator'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM1201');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0551'
       ,'Cross Item Validation Setup'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0551');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0411'
       ,'Inventory Exclusive View Creation'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0411');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NMWEB0020'
       ,'Engineering Dynamic Segmentation'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NMWEB0020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM1861'
       ,'Inventory Admin Unit Security Maintenance'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY'
                    AND  HSTF_CHILD = 'NM1861');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_JOB'
       ,'NM3010'
       ,'Job Operations'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_JOB'
                    AND  HSTF_CHILD = 'NM3010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_JOB'
       ,'NM3020'
       ,'Job Types'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_JOB'
                    AND  HSTF_CHILD = 'NM3020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NM0570'
       ,'Find Inventory'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY'
                    AND  HSTF_CHILD = 'NM0570');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_REPORTS'
       ,'NM0562'
       ,'Assets On Route Report - By Offset'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'NM0562');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_REPORTS'
       ,'NM0563'
       ,'Assets On Route Report- By Type and Offset'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'NM0563');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF_INVENTORY'
       ,'NM0415'
       ,'Inventory Attribute Sets'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF_INVENTORY'
                    AND  HSTF_CHILD = 'NM0415');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_MAPCAP'
       ,'NM0511'
       ,'Reconcile MapCapture Load Errors'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY_MAPCAP'
                    AND  HSTF_CHILD = 'NM0511');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_NETWORK'
       ,'NM1100'
       ,'Gazetteer'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_NETWORK'
                    AND  HSTF_CHILD = 'NM1100');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NET_INVENTORY_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY'
                    AND  HSTF_CHILD = 'NET_INVENTORY_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY'
       ,'NET_INVENTORY_MAPCAP'
       ,'MapCapture Asset Loader'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY'
                    AND  HSTF_CHILD = 'NET_INVENTORY_MAPCAP');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_INVENTORY_MAPCAP'
       ,'NM0580'
       ,'Create MapCapture Metadata File'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_INVENTORY_MAPCAP'
                    AND  HSTF_CHILD = 'NM0580');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_QUERIES'
       ,'NM0120'
       ,'Create Network Extent'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_QUERIES'
                    AND  HSTF_CHILD = 'NM0120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF'
       ,'NET_REF_NETWORK'
       ,'Network'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF'
                    AND  HSTF_CHILD = 'NET_REF_NETWORK');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF'
       ,'NET_REF_INVENTORY'
       ,'Inventory'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF'
                    AND  HSTF_CHILD = 'NET_REF_INVENTORY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NET_REF'
       ,'NET_REF_JOB'
       ,'Job'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NET_REF'
                    AND  HSTF_CHILD = 'NET_REF_JOB');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC'
       ,'DOC_DOCUMENTS'
       ,'Documents'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC'
                    AND  HSTF_CHILD = 'DOC_DOCUMENTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC'
       ,'DOC_REF'
       ,'Reference Data'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC'
                    AND  HSTF_CHILD = 'DOC_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_DOCUMENTS'
       ,'DOC0100'
       ,'Documents'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_DOCUMENTS'
                    AND  HSTF_CHILD = 'DOC0100');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0110'
       ,'Document Types/Classes/Enquiry Types'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_REF'
                    AND  HSTF_CHILD = 'DOC0110');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_DOCUMENTS'
       ,'DOC0114'
       ,'Circulation by Person'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_DOCUMENTS'
                    AND  HSTF_CHILD = 'DOC0114');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_DOCUMENTS'
       ,'DOC0115'
       ,'Circulation by Document'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_DOCUMENTS'
                    AND  HSTF_CHILD = 'DOC0115');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0116'
       ,'Keywords'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_REF'
                    AND  HSTF_CHILD = 'DOC0116');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0118'
       ,'Media/Locations'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_REF'
                    AND  HSTF_CHILD = 'DOC0118');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS'
       ,'MAI_LOADERS_INSPECTIONS'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS'
                    AND  HSTF_CHILD = 'MAI_LOADERS_INSPECTIONS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS'
       ,'MAI_REPORTS_AUDIT'
       ,'Audit'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS'
                    AND  HSTF_CHILD = 'MAI_REPORTS_AUDIT');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC0130'
       ,'Document Gateways'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_REF'
                    AND  HSTF_CHILD = 'DOC0130');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS'
       ,'MAI_REPORTS_HIST'
       ,'Historical'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS'
                    AND  HSTF_CHILD = 'MAI_REPORTS_HIST');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF_TEMPLATES'
       ,'DOC0201'
       ,'Templates'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_REF_TEMPLATES'
                    AND  HSTF_CHILD = 'DOC0201');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF_TEMPLATES'
       ,'DOC0202'
       ,'Template Users'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_REF_TEMPLATES'
                    AND  HSTF_CHILD = 'DOC0202');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI_FINANCIAL_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI_FINANCIAL_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI_CONTRACTS_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI_CONTRACTS_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI_WORKS_REPORTS'
       ,'Reports'
       ,'F'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI_WORKS_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI_INSP_REPORTS'
       ,'Reports'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI_INSP_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV'
       ,'MAI_INV_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV'
                    AND  HSTF_CHILD = 'MAI_INV_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1830'
       ,'People'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI1830');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1870'
       ,'Organisations'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI1870');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3664'
       ,'Financial Years'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3664');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3825'
       ,'Maintenance Report'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3825');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI1930'
       ,'IHMS Allocated Amounts'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI1930');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI5032'
       ,'Print Cyclic Maintenance Done'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI5032');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'DOC_REF'
       ,'DOC_REF_TEMPLATES'
       ,'Templates'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'DOC_REF'
                    AND  HSTF_CHILD = 'DOC_REF_TEMPLATES');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_INV'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_INV');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_INSP'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_INSP');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_WORKS'
       ,'Works'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_WORKS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_CONTRACTS'
       ,'Contracts'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_CONTRACTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_INTERFACES'
       ,'Interfaces'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_INTERFACES');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_FINANCIAL'
       ,'Financial'
       ,'F'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_FINANCIAL');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_REF'
       ,'Reference'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'MAI_LOADERS'
       ,'Loaders'
       ,'F'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'MAI_LOADERS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_INVENTORY'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF'
                    AND  HSTF_CHILD = 'MAI_REF_INVENTORY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_INSPECTIONS'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF'
                    AND  HSTF_CHILD = 'MAI_REF_INSPECTIONS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_MAINTENANCE'
       ,'Maintenance'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF'
                    AND  HSTF_CHILD = 'MAI_REF_MAINTENANCE');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF'
       ,'MAI_REF_FINANCIAL'
       ,'Financial'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF'
                    AND  HSTF_CHILD = 'MAI_REF_FINANCIAL');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI_REF_FINANCIAL_REPORTS'
       ,'Reports'
       ,'F'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI_REF_FINANCIAL_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI_REF_MAINTENANCE_REPORTS'
       ,'Reports'
       ,'F'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI_REF_MAINTENANCE_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI_REF_INSPECTIONS_REPORTS'
       ,'Reports'
       ,'F'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI_REF_INSPECTIONS_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI_REF_INVENTORY_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
                    AND  HSTF_CHILD = 'MAI_REF_INVENTORY_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS'
       ,'MAI_LOADERS_INVENTORY'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS'
                    AND  HSTF_CHILD = 'MAI_LOADERS_INVENTORY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3626'
       ,'Cyclic Maintenance Inventory Rules'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI3626');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5024'
       ,'Print Local Frequencies and Intervals'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
                    AND  HSTF_CHILD = 'MAI5024');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3842'
       ,'Deselect Items for Payment'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3842');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3940'
       ,'Query Payment Run Details'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3940');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3660'
       ,'Budgets'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3660');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3662'
       ,'Generate Budgets for Next Year'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3662');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3942'
       ,'List of Items for Payment'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
                    AND  HSTF_CHILD = 'MAI3942');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3944'
       ,'List of Completed Rechargeable Defects'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
                    AND  HSTF_CHILD = 'MAI3944');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3690'
       ,'Print Budget Exceptions Report'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
                    AND  HSTF_CHILD = 'MAI3690');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3666'
       ,'Job Size Codes'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3666');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3844'
       ,'Cost Centre Codes'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3844');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI3846'
       ,'VAT Rates'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3846');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL_REPORTS'
       ,'MAI3946'
       ,'List of VAT Rates'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL_REPORTS'
                    AND  HSTF_CHILD = 'MAI3946');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5022'
       ,'Print Inspectors Pocket Book'
       ,'M'
       ,19 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5022');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5011'
       ,'Print Road Markings - Longitudinal'
       ,'M'
       ,16 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5011');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5015'
       ,'Print Road Markings - Transverse and Special'
       ,'M'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5015');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5018'
       ,'Print Sign Areas'
       ,'M'
       ,14 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5018');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI30060'
       ,'Print Historical Inventory Data'
       ,'M'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI30060');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1430'
       ,'Lamp Configurations'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
                    AND  HSTF_CHILD = 'MAI1430');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1920'
       ,'Inventory XSPs'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
                    AND  HSTF_CHILD = 'MAI1920');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1240'
       ,'Default Section Intervals'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI1240');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1210'
       ,'Local Activity Frequencies'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI1210');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1205'
       ,'Activity Groups'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI1205');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3440'
       ,'Valid For Maintenance Rules'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI3440');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3628'
       ,'Related Maintenance Activities'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI3628');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5031'
       ,'Print Electrical Inventory'
       ,'M'
       ,18 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5031');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV'
       ,'MAI2310'
       ,'Inventory Items'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV'
                    AND  HSTF_CHILD = 'MAI2310');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV'
       ,'MAI2140'
       ,'Query Network/Inventory Data'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV'
                    AND  HSTF_CHILD = 'MAI2140');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5035A'
       ,'Print C Audit - Actions by Activity Area'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5035A');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5034B'
       ,'Print B Audit - Defects by Activity,Type and Time'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5034B');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5035B'
       ,'Print D Audit - Actions by Defect Type'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5035B');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2315'
       ,'Print Inventory Items (matrix format)'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI2315');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5060'
       ,'Print F Audit - Defect for Point and Cont. Inv Items'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5060');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3490'
       ,'Review Raised Works Orders'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3490');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5070'
       ,'Print M Audit - Analysis of Cyclic Maintenance Activities'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5070');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI6110'
       ,'Print Inventory Lengths'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI6110');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3905'
       ,'Print Roadstud Defects not Set to Mandatory or Advisory'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3905');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5037A'
       ,'Print E Audit - Electrical Report by Link'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5037A');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2325'
       ,'Print Inventory Summary'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI2325');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5010'
       ,'Print Road Markings - Hatched Type Area'
       ,'M'
       ,17 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2224'
       ,'Download Network Data for DCD Inspections'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI2224');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI5100'
       ,'Print Defect Details (At-a-Glance)'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI5100');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5038'
       ,'Print T Audit - Audit Of Costs'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5038');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3960'
       ,'Print Cyclic Maintenance Schedules'
       ,'M'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3960');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI2790'
       ,'Insurance Claims Reporting'
       ,'M'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI2790');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3900'
       ,'Print Inspection Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3900');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3904'
       ,'Print Defect Notices'
       ,'M'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3904');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3910'
       ,'List of Defects by Inspection Date'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3910');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3912'
       ,'List of Notifiable Defects'
       ,'M'
       ,14 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3912');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3916'
       ,'Summary of Notifiable/Rechargeable Defects'
       ,'M'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3916');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1300'
       ,'Defect Control Data'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI1300');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1315'
       ,'Treatment Data'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI1315');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3150'
       ,'Default Treatments'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI3150');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3814'
       ,'Treatment Models'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI3814');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3988'
       ,'List of Standard Items'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3988');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3986'
       ,'List of Standard Item Sections and Sub-Sections'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3986');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3954'
       ,'Contractor Performance Report'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3954');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3932'
       ,'Summary of Work Instructed by Standard Item'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3932');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3934'
       ,'Summary of Work Volumes by Standard Item'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3934');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3948'
       ,'Summary of Expenditure by Contract'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3948');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_HIST'
       ,'MAI3992'
       ,'Road Section Historical Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_HIST'
                    AND  HSTF_CHILD = 'MAI3992');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_HIST'
       ,'MAI3994'
       ,'Road Section Historical Statistics'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_HIST'
                    AND  HSTF_CHILD = 'MAI3994');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3808'
       ,'Inspections'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI3808');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3806'
       ,'Defects'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI3806');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3810'
       ,'View Defects'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI3810');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3816'
       ,'Responses to Notices'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI3816');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2730'
       ,'Match Duplicate Defects'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI2730');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2760'
       ,'Unmatch Duplicate Defects'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI2760');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2470'
       ,'Delete Inspections'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI2470');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI2775'
       ,'Batch Setting of Repair Dates'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI2775');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2220'
       ,'Download Static Ref Data for DCD Inspections'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI2220');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2222'
       ,'Download Standard Item Data for DCD Inspections'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI2222');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3981'
       ,'List of Contractors'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3981');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3888'
       ,'Standard Items'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI3888');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3886'
       ,'Standard Item Sections and Sub-Sections'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI3886');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3881'
       ,'Contractors'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI3881');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3880'
       ,'Contracts'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI3880');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3882'
       ,'Copy a Contract'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI3882');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3884'
       ,'Bulk Update of Contract Items'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI3884');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS'
       ,'MAI3624'
       ,'Discount Groups'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS'
                    AND  HSTF_CHILD = 'MAI3624');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3980'
       ,'Contract Details Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3980');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3984'
       ,'List of Contract Rates'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3984');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_CONTRACTS_REPORTS'
       ,'MAI3982'
       ,'List of Contract Liabilities'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_CONTRACTS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3982');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3820'
       ,'Quality Inspection Results'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3820');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3804'
       ,'View Cyclic Maintenance Work'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3804');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3610'
       ,'Cancel Work Orders'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3610');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3860'
       ,'Cyclic Maintenance Schedules'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3860');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3862'
       ,'Cyclic Maintenance Schedules by Road Section'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3862');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI1280'
       ,'External Activities'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI1280');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3906'
       ,'Print BOQ Work Order (Defects)'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3906');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3922'
       ,'List of Defects Not Yet Instructed'
       ,'M'
       ,14 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3922');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3924'
       ,'List of Instructed Work by Status'
       ,'M'
       ,16 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3924');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3926'
       ,'List of Instructed Defects due for Completion'
       ,'M'
       ,17 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3926');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3950'
       ,'List of Work for Quality Inspection'
       ,'M'
       ,19 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3950');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3930'
       ,'List of Inventory Updates'
       ,'M'
       ,18 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3930');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3920'
       ,'Summary of Defects Not Yet Instructed'
       ,'M'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3920');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3956'
       ,'Admin Unit Performance Report'
       ,'M'
       ,21 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3956');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3952'
       ,'Quality Inspection Performance Report'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3952');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL'
       ,'MAI3840'
       ,'Payment Run'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI3840');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI3250'
       ,'Print Defect Movements'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3250');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3470'
       ,'Print Defect Details ( Work Orders )'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3470');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC_REF_ITEM_ATTRIB'
       ,'Item/Attribute'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF'
                    AND  HSTF_CHILD = 'ACC_REF_ITEM_ATTRIB');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2500'
       ,'Download Data for Inventory Survey on DCD'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
                    AND  HSTF_CHILD = 'MAI2500');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI2501'
       ,'Inventory Interface'
       ,'M'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI2501');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2200C'
       ,'Inspection Loader (Part 1)'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI2200C');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2200D'
       ,'Inspection Loader (Part 2)'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI2200D');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1910'
       ,'XSP Values'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
                    AND  HSTF_CHILD = 'MAI1910');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI1840'
       ,'List of People'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'MAI1840');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2115'
       ,'Print Potential Inventory Duplicates'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI2115');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI5065'
       ,'Print Batch with Downloaded Inventory Items'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
                    AND  HSTF_CHILD = 'MAI5065');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY_REPORTS'
       ,'MAI5200'
       ,'Print Lamp Configurations'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'MAI5200');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5205'
       ,'Print Activity Frequencies'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
                    AND  HSTF_CHILD = 'MAI5205');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY_REPORTS'
       ,'MAI5210'
       ,'Print Electricity Boards'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'MAI5210');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5215'
       ,'Print Interval Codes'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
                    AND  HSTF_CHILD = 'MAI5215');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI5220'
       ,'Print Valid Defect Types'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'MAI5220');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5225'
       ,'Print Activities'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
                    AND  HSTF_CHILD = 'MAI5225');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI6100'
       ,'Print Inventory Statistics'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI6100');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI5235'
       ,'Print Defect Item Types'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'MAI5235');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI5240'
       ,'Print Treatment Codes'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'MAI5240');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI9020'
       ,'Print Inventory Gap/Overlap'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI9020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL_REPORTS'
       ,'MAI2780'
       ,'Print Item Code Breakdowns'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL_REPORTS'
                    AND  HSTF_CHILD = 'MAI2780');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI5125'
       ,'Print Defect Details (Strip Plan)'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI5125');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI2210'
       ,'Print Defective Advisory Roadstuds Report'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI2210');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC_REF_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF'
                    AND  HSTF_CHILD = 'ACC_REF_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2105C'
       ,'Reformat Road Group Inventory Data'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
                    AND  HSTF_CHILD = 'MAI2105C');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY_REPORTS'
       ,'MAI5050'
       ,'Print List of Inventory Item Types, Attributes and Values'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'MAI5050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5075'
       ,'Print Inventory Item Report'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5075');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2330'
       ,'Print Summary of Inventory Changes'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI2330');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI9010'
       ,'Detect Inventory Gap/Overlap'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI9010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI2320'
       ,'Print Inventory Map'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI2320');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3480'
       ,'Print Works Order (Priced)'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3480');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3500'
       ,'Print Works Orders Detail'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3500');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3505'
       ,'Print Works Orders (Summary)'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3505');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3485'
       ,'Print Works Order (Unpriced)'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3485');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI5130'
       ,'Print Works Orders (Strip Plan)'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI5130');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2200R'
       ,'Bulk Inspection Load - Stage 2 Report'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI2200R');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5034A'
       ,'Print A Audit - Defects by Type, Activity and Time'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5034A');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI5027'
       ,'Print Defects by Defect Type'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI5027');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3907'
       ,'Print BOQ Work Order (Cyclic)'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3907');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3909'
       ,'Print Works Order (NMA)'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3909');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5080'
       ,'Print I Audit - 7 and 28 day Safety Inspection Statistics'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5080');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2100C'
       ,'Inventory Loader (Part 1)'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
                    AND  HSTF_CHILD = 'MAI2100C');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2110C'
       ,'Inventory Loader (Part 2)'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
                    AND  HSTF_CHILD = 'MAI2110C');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3802'
       ,'Maintain Work Orders - Contractor Interface'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3802');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP'
       ,'MAI3899'
       ,'Inspections by Group'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP'
                    AND  HSTF_CHILD = 'MAI3899');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3830'
       ,'Works Order File Extract'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INTERFACES'
                    AND  HSTF_CHILD = 'MAI3830');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3834'
       ,'Financial Commitment File'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INTERFACES'
                    AND  HSTF_CHILD = 'MAI3834');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3856'
       ,'Payment Approval form'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INTERFACES'
                    AND  HSTF_CHILD = 'MAI3856');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3854'
       ,'Invoice Verification form'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INTERFACES'
                    AND  HSTF_CHILD = 'MAI3854');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3850'
       ,'Completions file'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INTERFACES'
                    AND  HSTF_CHILD = 'MAI3850');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3852'
       ,'Invoice file'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INTERFACES'
                    AND  HSTF_CHILD = 'MAI3852');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INTERFACES'
       ,'MAI3858'
       ,'Payment Transaction file'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INTERFACES'
                    AND  HSTF_CHILD = 'MAI3858');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1320'
       ,'Enquiry/Treatment Types'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI1320');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI1325'
       ,'Enquiry/Defect Priorities'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI1325');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC_ANALYSIS_REPORTS'
       ,'Reports'
       ,'F'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC_ANALYSIS_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO'
       ,'ACC_IO_LOAD_REPORTS'
       ,'Load Reports'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_IO'
                    AND  HSTF_CHILD = 'ACC_IO_LOAD_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI5090'
       ,'Remove Successfully Loaded Inventory Batches'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
                    AND  HSTF_CHILD = 'MAI5090');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI5091'
       ,'Remove Phase 1 Inspection Batches'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI5091');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1440'
       ,'Inventory Colour Map'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
                    AND  HSTF_CHILD = 'MAI1440');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3105'
       ,'Print: Cyclic Maintenance Activities'
       ,'M'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3105');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI3863'
       ,'Download Inspection by Assets'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI3863');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5021'
       ,'Print Inventory Areas - Trapezium Rule'
       ,'M'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5021');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3100'
       ,'Print Inspection Schedules'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3100');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INSP_REPORTS'
       ,'MAI3902'
       ,'Print Defect Details'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INSP_REPORTS'
                    AND  HSTF_CHILD = 'MAI3902');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2010'
       ,'Domains'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
                    AND  HSTF_CHILD = 'ACC2010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3848'
       ,'Work Orders Authorisation'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3848');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI3803'
       ,'Work Order Auditing Maintenance'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI3803');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_INV_REPORTS'
       ,'MAI5001'
       ,'Inventory Item Details'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_INV_REPORTS'
                    AND  HSTF_CHILD = 'MAI5001');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2020'
       ,'Attributes'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
                    AND  HSTF_CHILD = 'ACC2020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2024'
       ,'Attribute Group'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
                    AND  HSTF_CHILD = 'ACC2024');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2030'
       ,'Item Control Data'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
                    AND  HSTF_CHILD = 'ACC2030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2050'
       ,'Cross Attribute Validation Rules'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF'
                    AND  HSTF_CHILD = 'ACC2050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2060'
       ,'Hotspot Dates'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF'
                    AND  HSTF_CHILD = 'ACC2060');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2070'
       ,'Accident Images'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF'
                    AND  HSTF_CHILD = 'ACC2070');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS_REPORTS'
       ,'MAI3919'
       ,'Print Works Order (Enhanced)'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS_REPORTS'
                    AND  HSTF_CHILD = 'MAI3919');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC3020'
       ,'Accidents v2'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
                    AND  HSTF_CHILD = 'ACC3020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC3021'
       ,'Accidents'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
                    AND  HSTF_CHILD = 'ACC3021');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT_ATTRIB'
       ,'ACC3040'
       ,'Bulk Initialisation'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_MANAGEMENT_ATTRIB'
                    AND  HSTF_CHILD = 'ACC3040');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT_ATTRIB'
       ,'ACC3050'
       ,'Bulk Maintenance'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_MANAGEMENT_ATTRIB'
                    AND  HSTF_CHILD = 'ACC3050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3813'
       ,'Maintain Automatic Defect Prioritisation'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI3813');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC7045'
       ,'Queries'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC7045');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT_REPORTS'
       ,'ACC8001'
       ,'Profile Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_MANAGEMENT_REPORTS'
                    AND  HSTF_CHILD = 'ACC8001');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8004'
       ,'List of Attribute Domains'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
                    AND  HSTF_CHILD = 'ACC8004');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3800'
       ,'Works Orders (Defects)'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3800');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI'
       ,'DOC0206'
       ,'Batch Works Order Printing'
       ,'M'
       ,21 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI'
                    AND  HSTF_CHILD = 'DOC0206');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_FINANCIAL_REPORTS'
       ,'MAI3692'
       ,'Print Cost Code Exceptions Report'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_FINANCIAL_REPORTS'
                    AND  HSTF_CHILD = 'MAI3692');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS'
       ,'MAI7040'
       ,'Parameter Based Inquiry (PBI)'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS'
                    AND  HSTF_CHILD = 'MAI7040');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5037'
       ,'Print E Audit - Electrical Report by Ownership'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5037');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REPORTS_AUDIT'
       ,'MAI5027'
       ,'Print Defects by Defect Type'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REPORTS_AUDIT'
                    AND  HSTF_CHILD = 'MAI5027');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INVENTORY'
       ,'MAI1400'
       ,'Inventory Control Data'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INVENTORY'
                    AND  HSTF_CHILD = 'MAI1400');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS'
       ,'MAI3812'
       ,'Defect Priorities'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI3812');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_INSPECTIONS_REPORTS'
       ,'MAI1808'
       ,'List of Organisations'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'MAI1808');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1200'
       ,'Activities'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI1200');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE'
       ,'MAI1230'
       ,'Default Section Intervals Calculation'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE'
                    AND  HSTF_CHILD = 'MAI1230');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_MAINTENANCE_REPORTS'
       ,'MAI5030'
       ,'Print Default Intervals and Frequencies'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_MAINTENANCE_REPORTS'
                    AND  HSTF_CHILD = 'MAI5030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_REF_FINANCIAL'
       ,'MAI1940'
       ,'Item Code Breakdowns'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_REF_FINANCIAL'
                    AND  HSTF_CHILD = 'MAI1940');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INVENTORY'
       ,'MAI2120'
       ,'Correct Inventory Load Errors'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INVENTORY'
                    AND  HSTF_CHILD = 'MAI2120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_LOADERS_INSPECTIONS'
       ,'MAI2250'
       ,'Correct Inspection Load Errors'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_LOADERS_INSPECTIONS'
                    AND  HSTF_CHILD = 'MAI2250');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_MANAGEMENT'
       ,'Management'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC'
                    AND  HSTF_CHILD = 'ACC_MANAGEMENT');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_REF'
       ,'Reference'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC'
                    AND  HSTF_CHILD = 'ACC_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_ANALYSIS'
       ,'Analysis'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC'
                    AND  HSTF_CHILD = 'ACC_ANALYSIS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC'
       ,'ACC_IO'
       ,'Data i/o'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC'
                    AND  HSTF_CHILD = 'ACC_IO');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC_MANAGEMENT_ATTRIB'
       ,'Attribute'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
                    AND  HSTF_CHILD = 'ACC_MANAGEMENT_ATTRIB');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_MANAGEMENT'
       ,'ACC_MANAGEMENT_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_MANAGEMENT'
                    AND  HSTF_CHILD = 'ACC_MANAGEMENT_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8005'
       ,'List of Attribute Types'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
                    AND  HSTF_CHILD = 'ACC8005');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8006'
       ,'List of Item Types'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
                    AND  HSTF_CHILD = 'ACC8006');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8007'
       ,'List of Attribute Groups'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
                    AND  HSTF_CHILD = 'ACC8007');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_REPORTS'
       ,'ACC8008'
       ,'List of Valid Items and Attributes'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_REPORTS'
                    AND  HSTF_CHILD = 'ACC8008');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8800'
       ,'Identify Sites'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC8800');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8810'
       ,'Factor Grid'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC8810');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8811'
       ,'Factor Grid Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
                    AND  HSTF_CHILD = 'ACC8811');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8812'
       ,'Statistical Summary'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC8812');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC8820'
       ,'Site Parameters'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF'
                    AND  HSTF_CHILD = 'ACC8820');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8825'
       ,'Accident Groups'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC8825');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8830'
       ,'Create Accident Groups'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC8830');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8835'
       ,'Accident Group Hieracrchies'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC8835');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8840'
       ,'Hotspot Report'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
                    AND  HSTF_CHILD = 'ACC8840');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_INSPECTIONS'
       ,'Inspections'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR'
                    AND  HSTF_CHILD = 'STR_INSPECTIONS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8842'
       ,'Accident Group Refresh Utility'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
                    AND  HSTF_CHILD = 'ACC8842');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO'
       ,'ACC8890'
       ,'Load Accidents'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_IO'
                    AND  HSTF_CHILD = 'ACC8890');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO'
       ,'ACC8891'
       ,'Accident File Load Rules'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_IO'
                    AND  HSTF_CHILD = 'ACC8891');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_IO_LOAD_REPORTS'
       ,'ACC8892'
       ,'External File Description'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_IO_LOAD_REPORTS'
                    AND  HSTF_CHILD = 'ACC8892');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_REFERENCE'
       ,'Reference Data'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR'
                    AND  HSTF_CHILD = 'STR_REFERENCE');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_BULK'
       ,'Bulk Data Loading'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR'
                    AND  HSTF_CHILD = 'STR_BULK');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_DART'
       ,'D.A.R.T.'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR'
                    AND  HSTF_CHILD = 'STR_DART');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_DART'
       ,'STR7045'
       ,'Dynamic Attribute Reporting Tool'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_DART'
                    AND  HSTF_CHILD = 'STR7045');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3022'
       ,'Inspection Controls for a Structure'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS'
                    AND  HSTF_CHILD = 'STR3022');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3070'
       ,'Auto-Schedule Inspections'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS'
                    AND  HSTF_CHILD = 'STR3070');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3072'
       ,'Scheduled Inspections for a Structure'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS'
                    AND  HSTF_CHILD = 'STR3072');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF'
       ,'ACC2080'
       ,'Discoverer Interface'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF'
                    AND  HSTF_CHILD = 'ACC2080');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_REF_ITEM_ATTRIB'
       ,'ACC2090'
       ,'Accident Attribute Bands'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_REF_ITEM_ATTRIB'
                    AND  HSTF_CHILD = 'ACC2090');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS'
       ,'ACC8827'
       ,'Group Removal'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS'
                    AND  HSTF_CHILD = 'ACC8827');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3080'
       ,'Inspection Batches'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS'
                    AND  HSTF_CHILD = 'STR3080');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ACC_ANALYSIS_REPORTS'
       ,'ACC8001'
       ,'Profile Report'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ACC_ANALYSIS_REPORTS'
                    AND  HSTF_CHILD = 'ACC8001');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR'
       ,'STR_INVENTORY'
       ,'Inventory'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR'
                    AND  HSTF_CHILD = 'STR_INVENTORY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3086'
       ,'Inspection Records for a Structure'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS'
                    AND  HSTF_CHILD = 'STR3086');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5015'
       ,'Profile of an Inspection'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5015');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5042'
       ,'List of Structures needing Specialist Equipment'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5042');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5070'
       ,'List of Scheduled Inspections by Date'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5070');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5072'
       ,'List of Inspections by Batch'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5072');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5074'
       ,'List of Scheduled Inspections by Cycle'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5074');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5076'
       ,'Summary of Scheduled Inspections by Cycle'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5076');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5078'
       ,'List of Inspections later than Scheduled Date'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5078');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5080'
       ,'List of Inspections later than Mandated Date'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5080');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5082'
       ,'List of Inspection Ratings'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5082');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS_REPORTS'
       ,'STR5084'
       ,'List of Inspection Rating Exceptions'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS_REPORTS'
                    AND  HSTF_CHILD = 'STR5084');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3020'
       ,'Structure Hierarchies and Attributes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR3020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3024'
       ,'Structure Attributes'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR3024');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'NM7050'
       ,'Merge Queries'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE'
                    AND  HSTF_CHILD = 'NM7050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3060'
       ,'Resequence Structure Hierarchies'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR3060');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3010'
       ,'Create Structures from a Template'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR3010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3030'
       ,'Delete Structures'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR3030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3040'
       ,'Bulk Initialisation of Attribute Values'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR3040');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR3050'
       ,'Bulk Maintenance of Attribute Values'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR3050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5010'
       ,'Profile of a Structure'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'STR5010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5050'
       ,'List of Structures on a Route'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'STR5050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5040'
       ,'List of Structures with Named Attributes'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'STR5040');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5020'
       ,'List of Obstructions with Active TROs'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'STR5020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY_REPORTS'
       ,'STR5030'
       ,'List of Obstructions on a Route'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY_REPORTS'
                    AND  HSTF_CHILD = 'STR5030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2010'
       ,'Attribute Domains'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2020'
       ,'Attribute Types'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2024'
       ,'Attribute Groups'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2024');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2030'
       ,'Structure Item Types'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2040'
       ,'Templates'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2040');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2050'
       ,'Obstruction Types'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2050');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2068'
       ,'Inspection Sets'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2068');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2060'
       ,'Inspection Types'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2060');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2062'
       ,'Inspection Cycles'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2062');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2064'
       ,'Inspection Equipment'
       ,'M'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2064');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5004'
       ,'List of Attribute Domains'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'STR5004');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5005'
       ,'List of Attribute Types'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'STR5005');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5006'
       ,'List of Item Types'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'STR5006');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5007'
       ,'List of Attribute Groups'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'STR5007');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5008'
       ,'List of Valid Item/Attributes'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'STR5008');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE_REPORTS'
       ,'STR5009'
       ,'List of Valid Item/Inspections'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'STR5009');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1001'
       ,'Download Control Data into DCD File'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_BULK'
                    AND  HSTF_CHILD = 'STR1001');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1002'
       ,'Download Inspection Parameters into DCD File'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_BULK'
                    AND  HSTF_CHILD = 'STR1002');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1003'
       ,'Upload Inspection Records from DCD File'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_BULK'
                    AND  HSTF_CHILD = 'STR1003');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_BULK'
       ,'STR1004'
       ,'Load Structures Inventory onto Database'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_BULK'
                    AND  HSTF_CHILD = 'STR1004');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR2070'
       ,'Organisations'
       ,'M'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR2070');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'STP_REFERENCE_INVENTORY'
       ,'Inventory'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE'
                    AND  HSTF_CHILD = 'STP_REFERENCE_INVENTORY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR3001'
       ,'Calculate Bridge Condition Indicators'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS'
                    AND  HSTF_CHILD = 'STR3001');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR3002'
       ,'Bridge Condition Reference Data'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR3002');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR3003'
       ,'Defect Code Maintenance'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR3003');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INVENTORY'
       ,'STR_INVENTORY_REPORTS'
       ,'Reports'
       ,'F'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INVENTORY'
                    AND  HSTF_CHILD = 'STR_INVENTORY_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_INSPECTIONS'
       ,'STR_INSPECTIONS_REPORTS'
       ,'Reports'
       ,'F'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_INSPECTIONS'
                    AND  HSTF_CHILD = 'STR_INSPECTIONS_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STR_REFERENCE'
       ,'STR_REFERENCE_REPORTS'
       ,'Reports'
       ,'F'
       ,14 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STR_REFERENCE'
                    AND  HSTF_CHILD = 'STR_REFERENCE_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_ROAD'
       ,'STP1000'
       ,'Road Construction'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_ROAD'
                    AND  HSTF_CHILD = 'STP1000');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'STP0010'
       ,'Road Construction Attributes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE'
                    AND  HSTF_CHILD = 'STP0010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_ROAD'
       ,'STP3030'
       ,'Road Construction Schemes'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_ROAD'
                    AND  HSTF_CHILD = 'STP3030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP'
       ,'STP_ROAD'
       ,'Road Construction '
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP'
                    AND  HSTF_CHILD = 'STP_ROAD');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP'
       ,'STP_REFERENCE'
       ,'Reference'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP'
                    AND  HSTF_CHILD = 'STP_REFERENCE');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0301'
       ,'Inventory Domains'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
                    AND  HSTF_CHILD = 'NM0301');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0410'
       ,'Inventory Metamodel'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
                    AND  HSTF_CHILD = 'NM0410');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0411'
       ,'Inventory Exclusive View Creation'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
                    AND  HSTF_CHILD = 'NM0411');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0305'
       ,'XSP and Reversal Rules'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
                    AND  HSTF_CHILD = 'NM0305');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0306'
       ,'Inventory XSPs'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
                    AND  HSTF_CHILD = 'NM0306');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0550'
       ,'Cross Attribute Validation Setup'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
                    AND  HSTF_CHILD = 'NM0550');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_INVENTORY'
       ,'NM0551'
       ,'Cross Item Validation Setup'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_INVENTORY'
                    AND  HSTF_CHILD = 'NM0551');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE'
       ,'STP_REFERENCE_JOB'
       ,'Job Metadata'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE'
                    AND  HSTF_CHILD = 'STP_REFERENCE_JOB');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_JOB'
       ,'NM3020'
       ,'Job Types'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_JOB'
                    AND  HSTF_CHILD = 'NM3020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'STP_REFERENCE_JOB'
       ,'NM3010'
       ,'Job Operations'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'STP_REFERENCE_JOB'
                    AND  HSTF_CHILD = 'NM3010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'PMS4408'
       ,'Road Construction Data'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD'
                    AND  HSTF_CHILD = 'PMS4408');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'PMS4404'
       ,'Aggregate Deflectograph Results into Bands'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD'
                    AND  HSTF_CHILD = 'PMS4404');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'PMS4440'
       ,'Road Condition Report'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
                    AND  HSTF_CHILD = 'PMS4440');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_'
       ,'PMS4448'
       ,'Machine Survey Results'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_'
                    AND  HSTF_CHILD = 'PMS4448');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'PMS4442'
       ,'March Treatment Costs'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
                    AND  HSTF_CHILD = 'PMS4442');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'PMS4444'
       ,'Deflectograph Summary by Admin Unit'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
                    AND  HSTF_CHILD = 'PMS4444');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS4400'
       ,'Structural Schemes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_SCHEME'
                    AND  HSTF_CHILD = 'PMS4400');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS4402'
       ,'Allocate Priorities to Schemes'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_SCHEME'
                    AND  HSTF_CHILD = 'PMS4402');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS4406'
       ,'Delete Structural Schemes'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_SCHEME'
                    AND  HSTF_CHILD = 'PMS4406');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME_REPORTS'
       ,'PMS4410'
       ,'List of Structural Schemes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_SCHEME_REPORTS'
                    AND  HSTF_CHILD = 'PMS4410');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_ROAD'
       ,'Road Condition'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS'
                    AND  HSTF_CHILD = 'PMS_ROAD');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_SCHEME'
       ,'Scheme Manager'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS'
                    AND  HSTF_CHILD = 'PMS_SCHEME');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_LOADERS'
       ,'Loaders'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS'
                    AND  HSTF_CHILD = 'PMS_LOADERS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS'
       ,'PMS_REFERENCE'
       ,'Reference'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS'
                    AND  HSTF_CHILD = 'PMS_REFERENCE');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'MAI2310A'
       ,'View Condition Data'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD'
                    AND  HSTF_CHILD = 'MAI2310A');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD'
       ,'PMS_ROAD_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD'
                    AND  HSTF_CHILD = 'PMS_ROAD_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_ROAD_REPORTS'
       ,'MAI7040'
       ,'Parameter Based Inquiry (PBI)'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_ROAD_REPORTS'
                    AND  HSTF_CHILD = 'MAI7040');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_SCHEME'
       ,'PMS_SCHEME_REPORTS'
       ,'Reports'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_SCHEME'
                    AND  HSTF_CHILD = 'PMS_SCHEME_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_LOADERS'
       ,'MAI2100C'
       ,'Inventory Loader (Part 1)'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_LOADERS'
                    AND  HSTF_CHILD = 'MAI2100C');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_LOADERS'
       ,'MAI2110C'
       ,'Inventory Loader (Part 2)'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_LOADERS'
                    AND  HSTF_CHILD = 'MAI2110C');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_LOADERS'
       ,'MAI2120'
       ,'Correct Inventory Load Errors'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_LOADERS'
                    AND  HSTF_CHILD = 'MAI2120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI3886'
       ,'Standard Item Sections and Sub-Sections'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_REFERENCE'
                    AND  HSTF_CHILD = 'MAI3886');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI3881'
       ,'Contractors'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_REFERENCE'
                    AND  HSTF_CHILD = 'MAI3881');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI1400'
       ,'Inventory Control Data'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_REFERENCE'
                    AND  HSTF_CHILD = 'MAI1400');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI1920'
       ,'Inventory XSPs'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_REFERENCE'
                    AND  HSTF_CHILD = 'MAI1920');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI1910'
       ,'XSP Values'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_REFERENCE'
                    AND  HSTF_CHILD = 'MAI1910');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PMS_REFERENCE'
       ,'MAI3664'
       ,'Financial Years'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PMS_REFERENCE'
                    AND  HSTF_CHILD = 'MAI3664');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM'
       ,'TM_PUBLISH'
       ,'Publish'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'TM'
                    AND  HSTF_CHILD = 'TM_PUBLISH');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM'
       ,'TM_REFERENCE'
       ,'Reference'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'TM'
                    AND  HSTF_CHILD = 'TM_REFERENCE');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM_PUBLISH'
       ,'TMWEB0010'
       ,'Publish Traffic Data'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'TM_PUBLISH'
                    AND  HSTF_CHILD = 'TMWEB0010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG1808'
       ,'Search'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'HIG1808');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'TM_REFERENCE'
       ,'TM0001'
       ,'Traffic Manager Metadata Maintenance'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'TM_REFERENCE'
                    AND  HSTF_CHILD = 'TM0001');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG1806'
       ,'Fastpath'
       ,'M'
       ,51 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'HIG1806');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'FAVOURITES'
       ,'HIG1833'
       ,'Change Password'
       ,'M'
       ,52 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'FAVOURITES'
                    AND  HSTF_CHILD = 'HIG1833');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA'
       ,'MRWA_ROMAN'
       ,'ROMAN Interface'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MRWA'
                    AND  HSTF_CHILD = 'MRWA_ROMAN');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA'
       ,'MRWA_NETWORK_EXTRACTS'
       ,'Network Extracts'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MRWA'
                    AND  HSTF_CHILD = 'MRWA_NETWORK_EXTRACTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_ROMAN'
       ,'PCUIS0010'
       ,'File Import'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MRWA_ROMAN'
                    AND  HSTF_CHILD = 'PCUIS0010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_ROMAN'
       ,'PCUIS0020'
       ,'Network Integrity Check'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MRWA_ROMAN'
                    AND  HSTF_CHILD = 'PCUIS0020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_ROMAN'
       ,'PCUIS0030'
       ,'Inventory Replace and File Output'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MRWA_ROMAN'
                    AND  HSTF_CHILD = 'PCUIS0030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MRWA_NETWORK_EXTRACTS'
       ,'CLASS0010'
       ,'Classified Roads Extract'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MRWA_NETWORK_EXTRACTS'
                    AND  HSTF_CHILD = 'CLASS0010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ENQ'
       ,'PEM_ENQ'
       ,'Public Enquiries'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ENQ'
                    AND  HSTF_CHILD = 'PEM_ENQ');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ'
       ,'PEM_ENQ_REPORTS'
       ,'Reports'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ'
                    AND  HSTF_CHILD = 'PEM_ENQ_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'ENQ'
       ,'PEM_REF'
       ,'Reference Data'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'ENQ'
                    AND  HSTF_CHILD = 'PEM_REF');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ'
       ,'DOC0150'
       ,'Public Enquiries'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ'
                    AND  HSTF_CHILD = 'DOC0150');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0166'
       ,'List of Enquiries'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0166');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0160'
       ,'Enquiry Details'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0160');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0162'
       ,'Enquiry Acknowledgements'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0162');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0164'
       ,'Summary of Enquiries by Status'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0164');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0165'
       ,'Summary of Complaints by Type'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0165');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0205'
       ,'Batch Complaint Printing'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0205');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0167'
       ,'Enquiry Actions'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0167');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_ENQ_REPORTS'
       ,'DOC0168'
       ,'Enquiry Damage'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_ENQ_REPORTS'
                    AND  HSTF_CHILD = 'DOC0168');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0110'
       ,'Document Types/Classes/Enquiry Types'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_REF'
                    AND  HSTF_CHILD = 'DOC0110');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0157'
       ,'Enquiry Redirection'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_REF'
                    AND  HSTF_CHILD = 'DOC0157');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0132'
       ,'Enquiry Priorities'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_REF'
                    AND  HSTF_CHILD = 'DOC0132');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0155'
       ,'Standard Actions'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_REF'
                    AND  HSTF_CHILD = 'DOC0155');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'DOC0156'
       ,'Standard Costs'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_REF'
                    AND  HSTF_CHILD = 'DOC0156');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'PEM_REF'
       ,'HIG1815'
       ,'Contacts'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'PEM_REF'
                    AND  HSTF_CHILD = 'HIG1815');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_SECURITY'
       ,'Security'
       ,'F'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG'
                    AND  HSTF_CHILD = 'HIG_SECURITY');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_REFERENCE'
       ,'Reference Data'
       ,'F'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG'
                    AND  HSTF_CHILD = 'HIG_REFERENCE');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_GRI'
       ,'GRI Data'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG'
                    AND  HSTF_CHILD = 'HIG_GRI');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_GIS'
       ,'GIS Data'
       ,'F'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG'
                    AND  HSTF_CHILD = 'HIG_GIS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG'
       ,'HIG_CSV'
       ,'CSV Loader'
       ,'F'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG'
                    AND  HSTF_CHILD = 'HIG_CSV');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY'
       ,'HIG1860'
       ,'Admin Units'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY'
                    AND  HSTF_CHILD = 'HIG1860');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY'
       ,'HIG1832'
       ,'Users'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY'
                    AND  HSTF_CHILD = 'HIG1832');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY'
       ,'HIG1836'
       ,'Roles'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY'
                    AND  HSTF_CHILD = 'HIG1836');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY'
       ,'HIG1880'
       ,'Modules'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY'
                    AND  HSTF_CHILD = 'HIG1880');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY'
       ,'HIG1890'
       ,'Products'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY'
                    AND  HSTF_CHILD = 'HIG1890');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY'
       ,'HIG_SECURITY_REPORTS'
       ,'Reports'
       ,'F'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY'
                    AND  HSTF_CHILD = 'HIG_SECURITY_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1802'
       ,'Menu Options for a User'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
                    AND  HSTF_CHILD = 'HIG1802');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1804'
       ,'Menu Options for a Role'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
                    AND  HSTF_CHILD = 'HIG1804');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1864'
       ,'Users Report'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
                    AND  HSTF_CHILD = 'HIG1864');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1862'
       ,'Admin Units'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
                    AND  HSTF_CHILD = 'HIG1862');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1866'
       ,'Users By Admin Unit'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
                    AND  HSTF_CHILD = 'HIG1866');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG1868'
       ,'User Roles'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
                    AND  HSTF_CHILD = 'HIG1868');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_SECURITY_REPORTS'
       ,'HIG2100'
       ,'Produce Database Healthcheck File'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_SECURITY_REPORTS'
                    AND  HSTF_CHILD = 'HIG2100');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9110'
       ,'Status Codes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9110');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9120'
       ,'Domains'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9135'
       ,'Product Option List'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9135');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9130'
       ,'Product Options'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9130');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1838'
       ,'User Options'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG1838');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1837'
       ,'User Option Administration'
       ,'M'
       ,7 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG1837');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1839'
       ,'Module Keywords'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG1839');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1881'
       ,'Module Usages'
       ,'M'
       ,9 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG1881');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1885'
       ,'Maintain URL Modules'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG1885');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG5000'
       ,'Maintain Entry Points'
       ,'M'
       ,11 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG5000');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9170'
       ,'Holidays'
       ,'M'
       ,12 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9170');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9180'
       ,'v2 Errors'
       ,'M'
       ,13 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9180');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9185'
       ,'v3 Errors'
       ,'M'
       ,14 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9185');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1220'
       ,'Intervals'
       ,'M'
       ,15 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG1220');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG1820'
       ,'Units and Conversions'
       ,'M'
       ,16 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG1820');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG_REFERENCE_MAIL'
       ,'Mail'
       ,'F'
       ,17 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG_REFERENCE_MAIL');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG_REFERENCE_REPORTS'
       ,'Reports'
       ,'F'
       ,18 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG_REFERENCE_REPORTS');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1900'
       ,'Mail Users'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
                    AND  HSTF_CHILD = 'HIG1900');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIG1901'
       ,'Mail Groups'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
                    AND  HSTF_CHILD = 'HIG1901');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_MAIL'
       ,'HIGWEB1902'
       ,'Mail'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE_MAIL'
                    AND  HSTF_CHILD = 'HIGWEB1902');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_REPORTS'
       ,'HIG9125'
       ,'List of Static Reference Data'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'HIG9125');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE_REPORTS'
       ,'HIG9115'
       ,'List of Status Codes'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE_REPORTS'
                    AND  HSTF_CHILD = 'HIG9115');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0220'
       ,'GRI Modules'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GRI'
                    AND  HSTF_CHILD = 'GRI0220');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0230'
       ,'GRI Parameters'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GRI'
                    AND  HSTF_CHILD = 'GRI0230');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0240'
       ,'GRI Module Parameters'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GRI'
                    AND  HSTF_CHILD = 'GRI0240');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'GRI0250'
       ,'GRI Parameter Dependencies'
       ,'M'
       ,4 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GRI'
                    AND  HSTF_CHILD = 'GRI0250');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'HIG1950'
       ,'Discoverer API Definition'
       ,'M'
       ,6 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GRI'
                    AND  HSTF_CHILD = 'HIG1950');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GRI'
       ,'HIG1850'
       ,'Report Styles'
       ,'M'
       ,5 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GRI'
                    AND  HSTF_CHILD = 'HIG1850');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GIS'
       ,'GIS0005'
       ,'GIS Projects'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GIS'
                    AND  HSTF_CHILD = 'GIS0005');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_GIS'
       ,'GIS0010'
       ,'GIS Themes'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_GIS'
                    AND  HSTF_CHILD = 'GIS0010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_CSV'
       ,'HIG2010'
       ,'CSV Loader Destination Tables'
       ,'M'
       ,1 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_CSV'
                    AND  HSTF_CHILD = 'HIG2010');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_CSV'
       ,'HIG2020'
       ,'CSV Loader File Definitions Tables'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_CSV'
                    AND  HSTF_CHILD = 'HIG2020');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_CSV'
       ,'HIGWEB2030'
       ,'CSV File Upload'
       ,'M'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_CSV'
                    AND  HSTF_CHILD = 'HIGWEB2030');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'MAI_WORKS'
       ,'MAI3800A'
       ,'Works Orders (Cyclic)'
       ,'M'
       ,2 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'MAI_WORKS'
                    AND  HSTF_CHILD = 'MAI3800A');
                    
commit;                    
-- 
---HIG_MODULE_KEYWORDS------------------------------------------------------------------------------
--                    
   INSERT INTO HIG_MODULE_KEYWORDS
       (HMK_HMO_MODULE
       ,HMK_KEYWORD
       ,HMK_OWNER
       )
   SELECT 
        'NET1100'
       ,'GAZETTEER'
       ,1 FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_KEYWORDS
                     WHERE HMK_HMO_MODULE = 'NET1100'
                     AND  HMK_KEYWORD = 'GAZETTEER'
                     AND  HMK_OWNER = 1);

commit;                     
-- 
---HIG_PRODUCTS----------------------------------------------------------------------------------------
--                    
UPDATE hig_products
SET    hpr_product_name = 'structural projects v2'
WHERE  hpr_product = 'PMS';

COMMIT;
-- 
---HIG_ERRORS----------------------------------------------------------------------------------------
--                    
DELETE FROM HIG_ERRORS
 WHERE HER_APPL = 'M_MGR'
  AND  HER_NO = 261;
--
INSERT INTO HIG_ERRORS
       (HER_APPL
       ,HER_NO
       ,HER_TYPE
       ,HER_DESCR
       ,HER_ACTION_1
       ,HER_ACTION_2
       ,HER_ACTION_3
       ,HER_ACTION_4
       ,HER_ACTION_5
       ,HER_ACTION_6
       ,HER_ACTION_7
       )
SELECT 
        'M_MGR'
       ,261
       ,'A'
       ,'Invalid Group'
       ,''
       ,''
       ,''
       ,''
       ,''
       ,''
       ,'' FROM DUAL;

COMMIT;
-- 
---HIG_OPTION_LIST--------------------------------------------------------------------------------
--    
UPDATE HIG_OPTION_LIST
SET    HOL_MIXED_CASE = 'Y'
WHERE  HOL_ID = 'UTLFILEDIR';

COMMIT;
-- 
---------------------------------------------------------------------------------------------------
--    

SET FEEDBACK ON

