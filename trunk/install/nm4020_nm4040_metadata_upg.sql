------------------------------------------------------------------
-- nm4020_nm4040_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4020_nm4040_metadata_upg.sql-arc   3.3   Jan 25 2008 13:35:26   jwadsworth  $
--       Module Name      : $Workfile:   nm4020_nm4040_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jan 25 2008 13:35:26  $
--       Date fetched Out : $Modtime:   Jan 25 2008 13:10:58  $
--       Version          : $Revision:   3.3  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
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

BEGIN
  nm_debug.debug_off;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New modules for Standard Text
SET TERM OFF

-- SSC  17-DEC-2007
-- 
-- DEVELOPMENT COMMENTS
-- Changes to hig_modules to include Standard Text modules:
-- HIG4010
-- Standard Text Maintenance
-- 
-- HIG4020
-- Standard Text Usage
-- 
-- HIG4025
-- My Standard Text Usuage (actually calls HIG4020 but acts differently)
-- 
-- HIG4030
-- Standard Text
------------------------------------------------------------------
Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4010', 'Standard Text Maintenance', 'hig4010', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4010');

Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4020', 'Standard Text Usage', 'hig4020', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4020');

Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4025', 'My Standard Text Usuage', 'hig4020', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4025');

Insert into HIG_MODULES (HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
                         HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
select 'HIG4030', 'Standard Text', 'hig4020', 'FMX', NULL, 'N', 'N', 'HIG', 'FORM'
  from dual
 where not exists (select 1 from HIG_MODULES where HMO_MODULE = 'HIG4030');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Module Roles for Standard Text
SET TERM OFF

-- SSC  17-DEC-2007
-- 
-- DEVELOPMENT COMMENTS
-- New modules added into hig_modules, these are the roles assigned to these modules:
-- HIG4010	HIG_ADMIN
-- HIG4020	HIG_ADMIN
-- HIG4025	HIG_USER
-- HIG4030	HIG_USER
------------------------------------------------------------------
Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4010', 'HIG_ADMIN', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4010' and HMR_ROLE = 'HIG_ADMIN');

Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4020', 'HIG_ADMIN', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4010' and HMR_ROLE = 'HIG_ADMIN');

Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4025', 'HIG_USER', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4010' and HMR_ROLE = 'HIG_USER');

Insert into HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
select 'HIG4030', 'HIG_USER', 'NORMAL'
  from dual
 where not exists (select 1 from HIG_MODULE_ROLES where HMR_MODULE = 'HIG4010' and HMR_ROLE = 'HIG_USER');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT script to port version 2 reports to version 4
SET TERM OFF

-- DY  09-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- Script to copy version 2 reports into version 4.  
-- 
-- Inserts into:
-- 
-- hig_modules
-- gri_modules,
-- gri_params,
-- gri_module_params,
-- gri_param_dependencies,
-- gri_param_lookup,
-- hig_module_roles
------------------------------------------------------------------
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5002'
       ,'Print Road Groups and their Membership'
       ,'net5002'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT '1' FROM HIG_MODULES
                   WHERE HMO_MODULE = 'NET5002');
--                   
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5003'
       ,'Print Full Sections within a Group'
       ,'net5003'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT '1' FROM HIG_MODULES
                  WHERE HMO_MODULE = 'NET5003');
--                  
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5085'
       ,'Print Road Parts and their Membership'
       ,'net5085'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT '1' FROM HIG_MODULES
                  WHERE HMO_MODULE = 'NET5085');
--                  
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5090'
       ,'Print Road Parts with No Sections'
       ,'net5090'
       ,'R25'
       ,'' 
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
WHERE NOT EXISTS (SELECT '1'
                  FROM HIG_MODULES
                  where HMO_MODULE = 'NET5090');
--                  
INSERT INTO HIG_MODULES
       (HMO_MODULE
       ,HMO_TITLE
       ,HMO_FILENAME
       ,HMO_MODULE_TYPE
       ,HMO_FASTPATH_OPTS
       ,HMO_FASTPATH_INVALID
       ,HMO_USE_GRI
       ,HMO_APPLICATION
       ,HMO_MENU
       ) 
SELECT
        'NET5095'
       ,'Print Sections not Allocated to a Road Part'
       ,'net5095'
       ,'R25'
       ,''
       ,'N'
       ,'Y'
       ,'NET'
       ,'FORM' FROM DUAL
       WHERE NOT EXISTS (SELECT '1'
                         FROM HIG_MODULES
                         WHERE HMO_MODULE = 'NET5095');  
--
INSERT INTO GRI_MODULES
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
       )
SELECT 
        'NET5002'
       ,'N/A'
       ,'$PROD_HOME/bin'
       ,'lis'
       ,'N'
       ,''
       ,''
       ,''
       ,132
       ,66 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5002');        
--
INSERT INTO GRI_MODULES
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
       ,GRM_PRE_PROCESS
       )
SELECT 
       'NET5003'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'Y'
      ,'ROAD_SEGS'
      ,'RSE_HE_ID'
      ,''
      ,132
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5003'); 
--
INSERT INTO GRI_MODULES
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
       ,GRM_PRE_PROCESS
       )
SELECT
       'NET5085'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'N'
      ,''
      ,''
      ,''
      ,80
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5085');      
--
INSERT INTO GRI_MODULES
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
       ,GRM_PRE_PROCESS
       )
SELECT
       'NET5090'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'N'
      ,''
      ,''
      ,''
      ,132
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5090');      
--      
INSERT INTO GRI_MODULES
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
       ,GRM_PRE_PROCESS
       )
SELECT
       'NET5095'
      ,'N/A'
      ,'$PROD_HOME/bin'
      ,'lis'
      ,'N'
      ,''
      ,''
      ,''
      ,132
      ,66
      ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULES
                   WHERE GRM_MODULE = 'NET5095');  
--
INSERT INTO GRI_PARAMS
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
       ,GP_GAZ_RESTRICTION
       )
SELECT 
        'ADMIN_UNIT'
       ,'NUMBER'
       ,'HIG_ADMIN_UNITS'
       ,'HAU_ADMIN_UNIT'
       ,'HAU_NAME'
       ,'HAU_UNIT_CODE'
       ,'CHAR'
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAMS
                   WHERE GP_PARAM = 'ADMIN_UNIT');       
--
INSERT INTO GRI_PARAMS
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
       ,GP_GAZ_RESTRICTION
       )
SELECT
        'ROAD_ID'
       ,'NUMBER'
       ,'ROAD_SEGMENTS_ALL'
       ,'RSE_HE_ID'
       ,'RSE_DESCR'
       ,'RSE_UNIQUE'
       ,'CHAR'
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAMS
                   WHERE GP_PARAM = 'ROAD_ID');     
--
INSERT INTO GRI_PARAMS
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
       ,GP_GAZ_RESTRICTION
       )
SELECT
        'ALL_ROAD_GPS'
       ,'CHAR'
       ,'GRI_PARAM_LOOKUP'
       ,'GPL_VALUE'
       ,'GPL_DESCR'
       ,'GPL_VALUE'
       ,'CHAR'
       ,''
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAMS
                   WHERE GP_PARAM = 'ALL_ROAD_GPS');                                              
-- 
INSERT INTO GRI_MODULE_PARAMS 
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
       ,GMP_OPERATOR
       )
SELECT 
        'NET5002'
       ,'ALL_ROAD_GPS'
       ,3
       ,'Include all Road Groups (Y/N)'
       ,'Y'
       ,1
       ,'GPL_PARAM=''ALL_ROAD_GPS'''
       ,'N'
       ,''
       ,'GRI_PARAM_LOOKUP'
       ,'GPL_VALUE'
       ,'GPL_VALUE=''N'' AND GPL_PARAM=''ALL_ROAD_GPS'''
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5002'
                    AND  GMP_PARAM = 'ALL_ROAD_GPS');        
--
INSERT INTO GRI_MODULE_PARAMS 
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
       ,GMP_OPERATOR
       )
SELECT 
        'NET5002'
       ,'ADMIN_UNIT'
       ,1
       ,'Admin Unit'
       ,'Y'
       ,1
       ,'(HAU_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT IN (SELECT HUS_ADMIN_UNIT FROM HIG_USERS WHERE HUS_USERNAME = USER)))'
       ,'N'
       ,''
       ,'HIG_ADMIN_UNITS'
       ,'HAU_ADMIN_UNIT'
       ,'HAU_ADMIN_UNIT = (SELECT MAX(HUS_ADMIN_UNIT) FROM HIG_USERS WHERE HUS_USERNAME = USER)'
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
      ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5002'
                    AND  GMP_PARAM = 'ADMIN_UNIT');       
--
INSERT INTO GRI_MODULE_PARAMS 
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
       ,GMP_OPERATOR
       )
SELECT 
        'NET5002'
       ,'ROAD_ID'
       ,2
       ,'Road Id'
       ,'N'
       ,1
       ,'RSE_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT = :ADMIN_UNIT)'
       ,'N'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,'road_id'
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5002'
                    AND  GMP_PARAM = 'ROAD_ID'); 
--                       
INSERT INTO GRI_MODULE_PARAMS 
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
       ,GMP_OPERATOR
       )
SELECT 
        'NET5003'
       ,'ADMIN_UNIT'
       ,1
       ,'Admin Unit'
       ,'Y'
       ,1
       ,'(HAU_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT IN (SELECT HUS_ADMIN_UNIT FROM HIG_USERS WHERE HUS_USERNAME = USER)))'
       ,'N'
       ,''
       ,'HIG_ADMIN_UNITS'
       ,'HAU_ADMIN_UNIT'
       ,'HAU_ADMIN_UNIT = (SELECT MAX(HUS_ADMIN_UNIT) FROM HIG_USERS WHERE HUS_USERNAME = USER)'
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5003'
                    AND  GMP_PARAM = 'ADMIN_UNIT');
--
INSERT INTO GRI_MODULE_PARAMS 
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
       ,GMP_OPERATOR
       )
SELECT 
        'NET5003'
       ,'ROAD_ID'
       ,2
       ,'Road Id'
       ,'Y'
       ,1
       ,'RSE_ADMIN_UNIT IN (SELECT HAG_CHILD_ADMIN_UNIT FROM HIG_ADMIN_GROUPS WHERE HAG_PARENT_ADMIN_UNIT = :ADMIN_UNIT)'
       ,'Y'
       ,'RSE_HE_ID IN (SELECT :ROAD_ID FROM DUAL UNION SELECT RSM_RSE_HE_ID_OF FROM ROAD_SEG_MEMBS WHERE RSM_END_DATE IS NULL CONNECT BY PRIOR RSM_RSE_HE_ID_OF = RSM_RSE_HE_ID_IN START WITH RSM_RSE_HE_ID_IN = :ROAD_ID)'
       ,''
       ,''
       ,''
       ,'Y'
       ,'Y'
       ,'N'
       ,'road_id'
       ,'N'
       ,''
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5003'
                    AND  GMP_PARAM = 'ROAD_ID');
--                     
INSERT INTO GRI_MODULE_PARAMS 
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
       ,GMP_OPERATOR
       )
SELECT
        'NET5085'
       ,'ROAD_ID'
       ,1
       ,'Road Part'
       ,'N'
       ,1
       ,'RSE_GTY_GROUP_TYPE=''RP'''
       ,'N'
       ,''
       ,''
       ,''
       ,''
       ,'Y'
       ,'N'
       ,'Y'
       ,''
       ,'N'
       ,'Enter the Road Part'
       ,'N'
       ,''
       ,''
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_MODULE_PARAMS
                   WHERE GMP_MODULE = 'NET5085'
                    AND  GMP_PARAM = 'ROAD_ID');                           
--         
INSERT INTO GRI_PARAM_DEPENDENCIES
       (GPD_MODULE
       ,GPD_DEP_PARAM
       ,GPD_INDEP_PARAM
       )
SELECT
        'NET5002'
       ,'ROAD_ID'
       ,'ADMIN_UNIT' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_DEPENDENCIES
                   WHERE GPD_MODULE = 'NET5002'
                    AND  GPD_DEP_PARAM = 'ROAD_ID'
                    AND  GPD_INDEP_PARAM = 'ADMIN_UNIT');
--
INSERT INTO GRI_PARAM_DEPENDENCIES
       (GPD_MODULE
       ,GPD_DEP_PARAM
       ,GPD_INDEP_PARAM
       )
SELECT
        'NET5003'
       ,'ROAD_ID'
       ,'ADMIN_UNIT' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_DEPENDENCIES
                   WHERE GPD_MODULE = 'NET5003'
                    AND  GPD_DEP_PARAM = 'ROAD_ID'
                    AND  GPD_INDEP_PARAM = 'ADMIN_UNIT');
--                              
INSERT INTO GRI_PARAM_LOOKUP
       (GPL_PARAM
       ,GPL_VALUE
       ,GPL_DESCR
       )
SELECT 
        'ALL_ROAD_GPS'
       ,'N'
       ,'No' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_LOOKUP
                   WHERE GPL_PARAM = 'ALL_ROAD_GPS'
                    AND  GPL_VALUE = 'N');
--
INSERT INTO GRI_PARAM_LOOKUP
       (GPL_PARAM
       ,GPL_VALUE
       ,GPL_DESCR
       )
SELECT 
        'ALL_ROAD_GPS'
       ,'Y'
       ,'Yes' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM GRI_PARAM_LOOKUP
                   WHERE GPL_PARAM = 'ALL_ROAD_GPS'
                    AND  GPL_VALUE = 'Y');   
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'NET5002'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5002'
                  AND HMR_ROLE = 'NET_ADMIN');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       ) 
SELECT
        'NET5003'
       ,'HIG_USER'
       ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5003'
                  AND HMR_ROLE = 'HIG_USER');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       ) 
SELECT
        'NET5085'
       ,'NET_ADMIN'
       ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5085'
                  AND HMR_ROLE = 'NET_ADMIN');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT
       'NET5090'
      ,'NET_ADMIN'
      ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5090'
                  AND HMR_ROLE = 'NET_ADMIN');
--                  
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT
       'NET5095'
      ,'NET_ADMIN'
      ,'NORMAL' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'NET5095'
                  AND HMR_ROLE = 'NET_ADMIN');
                                    

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT nm_error 501
SET TERM OFF

-- GJ  15-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- New error - called in nm3xml package
------------------------------------------------------------------
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'HIG'
       ,501
       ,null
       ,'XML Read error'
       ,'Error suggests XML is not ''well formed''' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'HIG'
                    AND  NER_ID = 501);

commit;
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
COMMIT
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

