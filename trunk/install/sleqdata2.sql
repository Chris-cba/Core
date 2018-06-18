-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sleqdata2.sql-arc   1.0   Jun 18 2018 16:26:50   Chris.Baugh  $
--       Module Name      : $Workfile:   sleqdata2.sql  $
--       Date into PVCS   : $Date:   Jun 18 2018 16:26:50  $
--       Date fetched Out : $Modtime:   May 30 2018 10:33:46  $
--       Version          : $Revision:   1.0  $
--       Table Owner      : NM3_SLM_METADATA
--       Generation Date  : 30-MAY-2018 10:33
--
--   Product metadata script
--   As at Release 4.7.1.0
--
-------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-------------------------------------------------------------------------
--
--   TABLES PROCESSED
--   ================
--   HIG_MODULES
--   HIG_MODULE_ROLES
--   GRI_PARAMS
--   GRI_MODULES
--   GRI_MODULE_PARAMS
--   HIG_HD_MODULES
--   HIG_HD_MOD_USES
--   HIG_HD_SELECTED_COLS
--
-----------------------------------------------------------------------------
--
SET define OFF;
SET feedback OFF;
---------------------------------
-- START OF GENERATED METADATA --
---------------------------------
--
----------------------------------------------------------------------------------------
-- HIG_MODULES
--
-- select * from nm3_slm_metadata.hig_modules
-- order by hmo_module
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT hig_modules
SET TERM OFF
--
INSERT
  INTO HIG_MODULES
      (HMO_MODULE
      ,HMO_TITLE
      ,HMO_FILENAME
      ,HMO_MODULE_TYPE
      ,HMO_FASTPATH_OPTS
      ,HMO_FASTPATH_INVALID
      ,HMO_USE_GRI
      ,HMO_APPLICATION
      ,HMO_MENU)
SELECT 'NMSLEQ0010'
      ,'Atkins Odlin Energy Procurement'
      ,'N/A'
      ,'PRC'
      ,''
      ,'N'
      ,'Y'
      ,'AST'
      ,'FORM'
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NMSLEQ0010');
--
----------------------------------------------------------------------------------------
-- HIG_MODULE_ROLES
--
-- select * from nm3_slm_metadata.hig_module_roles
-- order by hmr_module
--         ,hmr_role
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT hig_module_roles
SET TERM OFF
--
INSERT
  INTO HIG_MODULE_ROLES
      (HMR_MODULE
      ,HMR_ROLE
      ,HMR_MODE)
SELECT 'NMSLEQ0010'
      ,'HIG_USER'
      ,'NORMAL'
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'NMSLEQ0010'
                     AND HMR_ROLE = 'HIG_USER');
--
----------------------------------------------------------------------------------------
-- GRI_PARAMS
--
-- select * from nm3_slm_metadata.gri_params
-- order by gp_param
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT gri_params
SET TERM OFF
--
INSERT
  INTO GRI_PARAMS
      (GP_PARAM
      ,GP_PARAM_TYPE
      ,GP_TABLE
      ,GP_COLUMN
      ,GP_DESCR_COLUMN
      ,GP_SHOWN_COLUMN
      ,GP_SHOWN_TYPE
      ,GP_DESCR_TYPE
      ,GP_ORDER
      ,GP_CASE
      ,GP_GAZ_RESTRICTION)
SELECT 'DIRECTORY'
      ,'CHAR'
      ,''
      ,''
      ,''
      ,''
      ,''
      ,''
      ,''
      ,'LOWER'
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM GRI_PARAMS
                   WHERE GP_PARAM = 'DIRECTORY');
--
INSERT
  INTO GRI_PARAMS
      (GP_PARAM
      ,GP_PARAM_TYPE
      ,GP_TABLE
      ,GP_COLUMN
      ,GP_DESCR_COLUMN
      ,GP_SHOWN_COLUMN
      ,GP_SHOWN_TYPE
      ,GP_DESCR_TYPE
      ,GP_ORDER
      ,GP_CASE
      ,GP_GAZ_RESTRICTION)
SELECT 'FILENAME'
      ,'CHAR'
      ,''
      ,''
      ,''
      ,''
      ,''
      ,''
      ,''
      ,'LOWER'
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM GRI_PARAMS
                   WHERE GP_PARAM = 'FILENAME');
--
----------------------------------------------------------------------------------------
-- GRI_MODULES
--
-- select * from nm3_slm_metadata.gri_modules
-- order by grm_module
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT gri_modules
SET TERM OFF
--
INSERT
  INTO GRI_MODULES
      (GRM_MODULE
      ,GRM_MODULE_TYPE
      ,GRM_MODULE_PATH
      ,GRM_FILE_TYPE
      ,GRM_TAG_FLAG
      ,GRM_TAG_TABLE
      ,GRM_TAG_COLUMN
      ,GRM_TAG_WHERE
      ,GRM_LINESIZE
      ,GRM_PAGESIZE
      ,GRM_PRE_PROCESS)
SELECT 'NMSLEQ0010'
      ,'PRC'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'N'
      ,''
      ,''
      ,''
      ,132
      ,66
      ,'hig_hd_extract.output_csv(p_module => ''NMSLEQ0010'', p_dir => :directory, p_filename => :filename, p_include_headers => TRUE)'
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NMSLEQ0010');
--
----------------------------------------------------------------------------------------
-- GRI_MODULE_PARAMS
--
-- select * from nm3_slm_metadata.gri_module_params
-- order by gmp_module
--         ,gmp_param
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT gri_module_params
SET TERM OFF
--
INSERT
  INTO GRI_MODULE_PARAMS
      (GMP_MODULE
      ,GMP_PARAM
      ,GMP_SEQ
      ,GMP_PARAM_DESCR
      ,GMP_MANDATORY
      ,GMP_NO_ALLOWED
      ,GMP_WHERE
      ,GMP_TAG_RESTRICTION
      ,GMP_TAG_WHERE
      ,GMP_DEFAULT_TABLE
      ,GMP_DEFAULT_COLUMN
      ,GMP_DEFAULT_WHERE
      ,GMP_VISIBLE
      ,GMP_GAZETTEER
      ,GMP_LOV
      ,GMP_VAL_GLOBAL
      ,GMP_WILDCARD
      ,GMP_HINT_TEXT
      ,GMP_ALLOW_PARTIAL
      ,GMP_BASE_TABLE
      ,GMP_BASE_TABLE_COLUMN
      ,GMP_OPERATOR)
SELECT 'NMSLEQ0010'
      ,'DIRECTORY'
      ,10
      ,'Output Directory'
      ,'N'
      ,1
      ,''
      ,'N'
      ,''
      ,'DUAL'
      ,'HIG.GET_SYSOPT(''UTLFILEDIR'')'
      ,''
      ,'Y'
      ,'N'
      ,'N'
      ,''
      ,'N'
      ,'Output Directory'
      ,'N'
      ,''
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NMSLEQ0010'
                     AND GMP_PARAM = 'DIRECTORY');
--
INSERT
  INTO GRI_MODULE_PARAMS
      (GMP_MODULE
      ,GMP_PARAM
      ,GMP_SEQ
      ,GMP_PARAM_DESCR
      ,GMP_MANDATORY
      ,GMP_NO_ALLOWED
      ,GMP_WHERE
      ,GMP_TAG_RESTRICTION
      ,GMP_TAG_WHERE
      ,GMP_DEFAULT_TABLE
      ,GMP_DEFAULT_COLUMN
      ,GMP_DEFAULT_WHERE
      ,GMP_VISIBLE
      ,GMP_GAZETTEER
      ,GMP_LOV
      ,GMP_VAL_GLOBAL
      ,GMP_WILDCARD
      ,GMP_HINT_TEXT
      ,GMP_ALLOW_PARTIAL
      ,GMP_BASE_TABLE
      ,GMP_BASE_TABLE_COLUMN
      ,GMP_OPERATOR)
SELECT 'NMSLEQ0010'
      ,'FILENAME'
      ,20
      ,'Filename'
      ,'Y'
      ,1
      ,''
      ,'N'
      ,''
      ,'DUAL'
      ,'''AA''||TO_CHAR(SYSDATE,''DDMMYY'')||''.csv'''
      ,''
      ,'Y'
      ,'N'
      ,'N'
      ,''
      ,'N'
      ,'Filename'
      ,'N'
      ,''
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NMSLEQ0010'
                     AND GMP_PARAM = 'FILENAME');
--
----------------------------------------------------------------------------------------
-- HIG_HD_MODULES
--
-- select * from nm3_slm_metadata.hig_hd_modules
-- order by hhm_module
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT hig_hd_modules
SET TERM OFF
--
INSERT
  INTO HIG_HD_MODULES
      (HHM_MODULE
      ,HHM_TAG)
SELECT 'NMSLEQ0010'
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_MODULES
                   WHERE HHM_MODULE = 'NMSLEQ0010');
--
----------------------------------------------------------------------------------------
-- HIG_HD_MOD_USES
--
-- select * from nm3_slm_metadata.hig_hd_mod_uses
-- order by hhu_hhm_module
--         ,hhu_seq
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT hig_hd_mod_uses
SET TERM OFF
--
INSERT
  INTO HIG_HD_MOD_USES
      (HHU_HHM_MODULE
      ,HHU_TABLE_NAME
      ,HHU_SEQ
      ,HHU_ALIAS
      ,HHU_PARENT_SEQ
      ,HHU_FIXED_WHERE_CLAUSE
      ,HHU_LOAD_DATA
      ,HHU_HINT_TEXT
      ,HHU_TAG)
SELECT 'NMSLEQ0010'
      ,'SLEQ_AO_ENERGY_PROCUREMENT_V'
      ,10
      ,'SLEQ'
      ,null
      ,''
      ,'N'
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_MOD_USES
                   WHERE HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHU_SEQ = 10);
--
----------------------------------------------------------------------------------------
-- HIG_HD_SELECTED_COLS
--
-- select * from nm3_slm_metadata.hig_hd_selected_cols
-- order by hhc_hhu_hhm_module
--         ,hhc_hhu_seq
--         ,hhc_column_seq
--
----------------------------------------------------------------------------------------
SET TERM ON
PROMPT hig_hd_selected_cols
SET TERM OFF
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,10
      ,'V_IDENTIFIER'
      ,'Y'
      ,'Y'
      ,'V_IDENTIFIER'
      ,''
      ,null
      ,1
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 10);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,20
      ,'V_AGENTS_RECORD_NUMBER'
      ,'Y'
      ,'Y'
      ,'V_AGENTS_RECORD_NUMBER'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 20);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,30
      ,'V_LAMP_EQUIVALENT_NUMBER'
      ,'Y'
      ,'Y'
      ,'V_LAMP_EQUIVALENT_NUMBER'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 30);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,40
      ,'V_ITEM_CLASS_CODE'
      ,'Y'
      ,'Y'
      ,'V_ITEM_CLASS_CODE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 40);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,50
      ,'V_NO_OF_LAMPS'
      ,'Y'
      ,'Y'
      ,'V_NO_OF_LAMPS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 50);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,60
      ,'V_NO_OF_PECUS'
      ,'Y'
      ,'Y'
      ,'V_NO_OF_PECUS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 60);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,70
      ,'V_PECU_TYPE'
      ,'Y'
      ,'Y'
      ,'V_PECU_TYPE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 70);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,80
      ,'V_PECU_LUX_ON'
      ,'Y'
      ,'Y'
      ,'V_PECU_LUX_ON'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 80);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,90
      ,'V_PECU_LUX_OFF'
      ,'Y'
      ,'Y'
      ,'V_PECU_LUX_OFF'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 90);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,100
      ,'V_SWITCH_TYPE'
      ,'Y'
      ,'Y'
      ,'V_SWITCH_TYPE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 100);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,110
      ,'V_TIME_ON'
      ,'Y'
      ,'Y'
      ,'V_TIME_ON'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 110);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,120
      ,'V_TIME_OFF'
      ,'Y'
      ,'Y'
      ,'V_TIME_OFF'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 120);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,130
      ,'V_LAMP_TYPE'
      ,'Y'
      ,'Y'
      ,'V_LAMP_TYPE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 130);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,140
      ,'V_LAMP_MAX_WATTAGE'
      ,'Y'
      ,'Y'
      ,'V_LAMP_MAX_WATTAGE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 140);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,150
      ,'V_GEAR_TYPE'
      ,'Y'
      ,'Y'
      ,'V_GEAR_TYPE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 150);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,160
      ,'V_LOCATION'
      ,'Y'
      ,'Y'
      ,'V_LOCATION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 160);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,170
      ,'V_ROAD_NAME'
      ,'Y'
      ,'Y'
      ,'V_ROAD_NAME'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 170);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,180
      ,'V_PARISH'
      ,'Y'
      ,'Y'
      ,'V_PARISH'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 180);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,190
      ,'V_POSTAL_TOWN_COUNTY'
      ,'Y'
      ,'Y'
      ,'V_POSTAL_TOWN_COUNTY'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 190);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,200
      ,'V_GRID_REF_LETTERS'
      ,'Y'
      ,'Y'
      ,'V_GRID_REF_LETTERS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 200);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,210
      ,'V_GRID_REF_EASTINGS'
      ,'Y'
      ,'Y'
      ,'V_GRID_REF_EASTINGS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 210);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,220
      ,'V_GRID_REF_NORTHINGS'
      ,'Y'
      ,'Y'
      ,'V_GRID_REF_NORTHINGS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 220);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,230
      ,'V_GRID_SUPPLY_POINT'
      ,'Y'
      ,'Y'
      ,'V_GRID_SUPPLY_POINT'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 230);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,240
      ,'V_FEEDER_PILLAR_ID'
      ,'Y'
      ,'Y'
      ,'V_FEEDER_PILLAR_ID'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 240);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,250
      ,'V_INDIVIDUAL_OR_GROUP_CONTROL'
      ,'Y'
      ,'Y'
      ,'V_INDIVIDUAL_OR_GROUP_CONTROL'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 250);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,260
      ,'V_OPERATING_PERCENT_PER_DAY'
      ,'Y'
      ,'Y'
      ,'V_OPERATING_PERCENT_PER_DAY'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 260);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,270
      ,'V_IS_ITEM_AN_EXIT_POINT'
      ,'Y'
      ,'Y'
      ,'V_IS_ITEM_AN_EXIT_POINT'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 270);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,280
      ,'V_GRID_REF_OF_EXIT_POINT'
      ,'Y'
      ,'Y'
      ,'V_GRID_REF_OF_EXIT_POINT'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 280);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,290
      ,'V_EXIT_POINT_CAPACITY_3KVA'
      ,'Y'
      ,'Y'
      ,'V_EXIT_POINT_CAPACITY_3KVA'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 290);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,300
      ,'V_METERED_OR_UNMETERED'
      ,'Y'
      ,'Y'
      ,'V_METERED_OR_UNMETERED'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 300);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,310
      ,'V_REC_NAME'
      ,'Y'
      ,'Y'
      ,'V_REC_NAME'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 310);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,320
      ,'V_EQUIPMENT_COMMISSION_DATE'
      ,'Y'
      ,'Y'
      ,'V_EQUIPMENT_COMMISSION_DATE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 320);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,330
      ,'V_INSTALLATION_CAPITAL_COST'
      ,'Y'
      ,'Y'
      ,'V_INSTALLATION_CAPITAL_COST'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 330);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,340
      ,'V_COLUMN_MANUFACTURER'
      ,'Y'
      ,'Y'
      ,'V_COLUMN_MANUFACTURER'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 340);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,350
      ,'V_MOUNTING_HEIGHT'
      ,'Y'
      ,'Y'
      ,'V_MOUNTING_HEIGHT'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 350);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,360
      ,'V_COLUMN_MATERIAL'
      ,'Y'
      ,'Y'
      ,'V_COLUMN_MATERIAL'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 360);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,370
      ,'V_PROTECTIVE_COATING'
      ,'Y'
      ,'Y'
      ,'V_PROTECTIVE_COATING'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 370);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,380
      ,'V_PAINT_COLOUR'
      ,'Y'
      ,'Y'
      ,'V_PAINT_COLOUR'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 380);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,390
      ,'V_COLUMN_FIXING'
      ,'Y'
      ,'Y'
      ,'V_COLUMN_FIXING'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 390);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,400
      ,'V_COLUMN_CROSS_SECTION'
      ,'Y'
      ,'Y'
      ,'V_COLUMN_CROSS_SECTION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 400);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,410
      ,'V_NUMBER_OF_BRACKETS'
      ,'Y'
      ,'Y'
      ,'V_NUMBER_OF_BRACKETS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 410);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,420
      ,'V_BRACKET_PROJECTION'
      ,'Y'
      ,'Y'
      ,'V_BRACKET_PROJECTION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 420);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,430
      ,'V_LANTERN_MANUFACTURER'
      ,'Y'
      ,'Y'
      ,'V_LANTERN_MANUFACTURER'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 430);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,440
      ,'V_LANTERN_MODEL_REFERENCE'
      ,'Y'
      ,'Y'
      ,'V_LANTERN_MODEL_REFERENCE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 440);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,450
      ,'V_LANTERN_DISTRIBUTION'
      ,'Y'
      ,'Y'
      ,'V_LANTERN_DISTRIBUTION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 450);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,460
      ,'V_LANTERN_SETTING'
      ,'Y'
      ,'Y'
      ,'V_LANTERN_SETTING'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 460);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,470
      ,'V_LANTERN_PROTECTION'
      ,'Y'
      ,'Y'
      ,'V_LANTERN_PROTECTION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 470);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,480
      ,'V_LAST_LAMP_CHANGE_DATE'
      ,'Y'
      ,'Y'
      ,'V_LAST_LAMP_CHANGE_DATE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 480);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,490
      ,'V_LAST_ELECTRICAL_TEST'
      ,'Y'
      ,'Y'
      ,'V_LAST_ELECTRICAL_TEST'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 490);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,500
      ,'V_LAST_DETAILED_INSPECTION'
      ,'Y'
      ,'Y'
      ,'V_LAST_DETAILED_INSPECTION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 500);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,510
      ,'V_SIGN_SIZE'
      ,'Y'
      ,'Y'
      ,'V_SIGN_SIZE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 510);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,520
      ,'V_SIGN_DIAGRAM_NO'
      ,'Y'
      ,'Y'
      ,'V_SIGN_DIAGRAM_NO'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 520);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,530
      ,'V_COLUMN_ROOT_PROTECTION'
      ,'Y'
      ,'Y'
      ,'V_COLUMN_ROOT_PROTECTION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 530);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,540
      ,'V_FLANGE_BASE'
      ,'Y'
      ,'Y'
      ,'V_FLANGE_BASE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 540);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,550
      ,'V_COLUMN_LOCATION'
      ,'Y'
      ,'Y'
      ,'V_COLUMN_LOCATION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 550);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,560
      ,'V_ROAD_ENVIRONMENT'
      ,'Y'
      ,'Y'
      ,'V_ROAD_ENVIRONMENT'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 560);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,570
      ,'V_GROUND_CONDITIONS'
      ,'Y'
      ,'Y'
      ,'V_GROUND_CONDITIONS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 570);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,580
      ,'V_WIND_EXPOSURE'
      ,'Y'
      ,'Y'
      ,'V_WIND_EXPOSURE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 580);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,590
      ,'V_ENVIRONMENT_SITUATION'
      ,'Y'
      ,'Y'
      ,'V_ENVIRONMENT_SITUATION'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 590);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,600
      ,'V_DESIGNED_FOR_FATIGUE'
      ,'Y'
      ,'Y'
      ,'V_DESIGNED_FOR_FATIGUE'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 600);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,610
      ,'V_ATTACHMENTS'
      ,'Y'
      ,'Y'
      ,'V_ATTACHMENTS'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 610);
--
INSERT
  INTO HIG_HD_SELECTED_COLS
      (HHC_HHU_HHM_MODULE
      ,HHC_HHU_SEQ
      ,HHC_COLUMN_SEQ
      ,HHC_COLUMN_NAME
      ,HHC_SUMMARY_VIEW
      ,HHC_DISPLAYED
      ,HHC_ALIAS
      ,HHC_FUNCTION
      ,HHC_ORDER_BY_SEQ
      ,HHC_UNIQUE_IDENTIFIER_SEQ
      ,HHC_HHL_JOIN_SEQ
      ,HHC_CALC_RATIO
      ,HHC_FORMAT)
SELECT 'NMSLEQ0010'
      ,10
      ,620
      ,'V_EXTERNAL_INFLUENCES'
      ,'Y'
      ,'Y'
      ,'V_EXTERNAL_INFLUENCES'
      ,''
      ,null
      ,null
      ,null
      ,''
      ,''
  FROM DUAL
 WHERE NOT EXISTS(SELECT 1
                    FROM HIG_HD_SELECTED_COLS
                   WHERE HHC_HHU_HHM_MODULE = 'NMSLEQ0010'
                     AND HHC_HHU_SEQ = 10
                     AND HHC_COLUMN_SEQ = 620);
--
----------------------------------------------------------------------------------------
--
COMMIT;
--
SET feedback ON
SET define ON
--
-------------------------------
-- END OF GENERATED METADATA --
-------------------------------
--
