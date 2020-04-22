-----------------------------------------------------------------------------
-- sdl_ddl_upg.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_ddl_upg.sql-arc   1.1   Apr 22 2020 19:36:06   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Apr 22 2020 19:36:06  $
--       Date fetched Out : $Modtime:   Apr 22 2020 19:09:24  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------
SET TERM ON
PROMPT SDL DDL Objects - tables/sequences/indexes/constraints
---------------------------------------
-- Tables
---------------------------------------
PROMPT Creating table 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_PROFILES'
                  ||'(SP_ID                NUMBER(38) NOT NULL,'
                  ||' SP_NAME              VARCHAR2(12) NOT NULL,'
                  ||' SP_DESC              VARCHAR2(2000),'
                  ||' SP_IMPORT_FILE_TYPE  VARCHAR2(20) NOT NULL,'
                  ||' SP_MAX_IMPORT_LEVEL  VARCHAR2(50) NOT NULL,'
                  ||' SP_DEFAULT_TOLERANCE NUMBER,'
                  ||' SP_TOPOLOGY_LEVEL    VARCHAR2(50) NOT NULL,'
                  ||' SP_NLT_ID            NUMBER NOT NULL,'
                  ||' SP_LOADING_VIEW_NAME VARCHAR2(30),'
                  ||' SP_TOL_LOAD_SEARCH   NUMBER DEFAULT 1 NOT NULL,'
                  ||' SP_TOL_NW_SEARCH     NUMBER DEFAULT 1 NOT NULL,'
                  ||' SP_TOL_SEARCH_UNIT   NUMBER(4) DEFAULT 1 NOT NULL,'
                  ||' SP_STOP_COUNT        NUMBER(10) DEFAULT 0 NOT NULL,'  
                  ||' SP_DATE_CREATED      DATE NOT NULL,'
                  ||' SP_CREATED_BY        VARCHAR2(30) NOT NULL,'
                  ||' SP_DATE_MODIFIED     DATE,'
                  ||' SP_MODIFIED_BY       VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
COMMENT ON COLUMN SDL_PROFILES.SP_TOL_LOAD_SEARCH
  IS 'The search radius to associate load geometries with other load geometries'
/
COMMENT ON COLUMN SDL_PROFILES.SP_TOL_NW_SEARCH
  IS 'The search radius to associate load geometries with other existing network geometries'
/ 
COMMENT ON COLUMN SDL_PROFILES.SP_TOL_SEARCH_UNIT
  IS 'The unit of measure of the search tolerance values'
/ 
COMMENT ON COLUMN SDL_PROFILES.SP_STOP_COUNT
  IS 'The stop count on the number of intersections between a load geometry and existing network above which new nodes are not created'
/
PROMPT Creating table 'SDL_USER_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_USER_PROFILES'
                  ||'(SUP_ID                   NUMBER(38) NOT NULL,'
                  ||' SUP_USER_ID              NUMBER(9) NOT NULL,'
                  ||' SUP_SP_ID                NUMBER(38) NOT NULL,'
                  ||' SUP_DATE_CREATED         DATE NOT NULL,'
                  ||' SUP_CREATED_BY           VARCHAR2(30) NOT NULL,'
                  ||' SUP_DATE_MODIFIED        DATE,'
                  ||' SUP_MODIFIED_BY          VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_ATTRIBUTE_MAPPING'
                  ||'(SAM_ID                  NUMBER(38) NOT NULL,'
                  ||' SAM_SP_ID               NUMBER(38) NOT NULL,'
                  ||' SAM_COL_ID              NUMBER(38) NOT NULL,'
                  ||' SAM_FILE_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL,'
                  ||' SAM_VIEW_COLUMN_NAME    VARCHAR2(32) NOT NULL,'
                  ||' SAM_NE_COLUMN_NAME      VARCHAR2(32),'
                  ||' SAM_ATTRIBUTE_FORMULA   VARCHAR2(500),'
                  ||' SAM_DATE_CREATED        DATE,'
                  ||' SAM_CREATED_BY          VARCHAR2(30),'
                  ||' SAM_DATE_MODIFIED       DATE,'
                  ||' SAM_MODIFIED_BY         VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_FILE_SUBMISSIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_FILE_SUBMISSIONS'
                  ||'(SFS_ID                         NUMBER(38) NOT NULL,'
                  ||' SFS_NAME                       VARCHAR2(254) NOT NULL,'
                  ||' SFS_SP_ID                      NUMBER(38) NOT NULL,'
                  ||' SFS_USER_ID                    NUMBER(38) NOT NULL,'
                  ||' SFS_FILE_NAME                  VARCHAR2(254) NOT NULL,'
                  ||' SFS_LAYER_NAME                 VARCHAR2(254) NOT NULL,'
                  ||' SFS_STATUS                     VARCHAR2(20) DEFAULT ''NEW'' NOT NULL,'
                  ||' SFS_ATTRI_VALIDATION_COMPLETED VARCHAR2(1) DEFAULT ''N'' NOT NULL,'
                  ||' SFS_SPATIAL_ANALYSIS_COMPLETED VARCHAR2(1) DEFAULT ''N'' NOT NULL,'
                  ||' SFS_LOAD_DATA_COMPLETED        VARCHAR2(1) DEFAULT ''N'' NOT NULL,'
                  ||' SFS_FILE_PATH                  VARCHAR2(2000),'
                  ||' SFS_MBR_GEOMETRY               SDO_GEOMETRY,'
                  ||' SFS_DATE_CREATED               DATE NOT NULL,'
                  ||' SFS_CREATED_BY                 VARCHAR2(30) NOT NULL,'
                  ||' SFS_DATE_MODIFIED              DATE,'
                  ||' SFS_MODIFIED_BY                VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_LOAD_DATA'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_LOAD_DATA'
                  ||'(SLD_KEY              NUMBER(38),'
                  ||' SLD_SFS_ID           NUMBER(38),'
                  ||' SLD_ID               NUMBER(38),'
                  ||' SLD_COL_1            VARCHAR2(2000),'
                  ||' SLD_COL_2            VARCHAR2(2000),'
                  ||' SLD_COL_3            VARCHAR2(2000),'
                  ||' SLD_COL_4            VARCHAR2(2000),'
                  ||' SLD_COL_5            VARCHAR2(2000),'
                  ||' SLD_COL_6            VARCHAR2(2000),'
                  ||' SLD_COL_7            VARCHAR2(2000),'
                  ||' SLD_COL_8            VARCHAR2(2000),'
                  ||' SLD_COL_9            VARCHAR2(2000),'
                  ||' SLD_COL_10           VARCHAR2(2000),'
                  ||' SLD_COL_11           VARCHAR2(2000),'
                  ||' SLD_COL_12           VARCHAR2(2000),'
                  ||' SLD_COL_13           VARCHAR2(2000),'
                  ||' SLD_COL_14           VARCHAR2(2000),'
                  ||' SLD_COL_15           VARCHAR2(2000),'
                  ||' SLD_COL_16           VARCHAR2(2000),'
                  ||' SLD_COL_17           VARCHAR2(2000),'
                  ||' SLD_COL_18           VARCHAR2(2000),'
                  ||' SLD_COL_19           VARCHAR2(2000),'
                  ||' SLD_COL_21           VARCHAR2(2000),'
                  ||' SLD_COL_22           VARCHAR2(2000),'
                  ||' SLD_COL_23           VARCHAR2(2000),'
                  ||' SLD_COL_24           VARCHAR2(2000),'
                  ||' SLD_COL_25           VARCHAR2(2000),'
                  ||' SLD_COL_26           VARCHAR2(2000),'
                  ||' SLD_COL_27           VARCHAR2(2000),'
                  ||' SLD_COL_28           VARCHAR2(2000),'
                  ||' SLD_COL_29           VARCHAR2(2000),'
                  ||' SLD_COL_31           VARCHAR2(2000),'
                  ||' SLD_COL_32           VARCHAR2(2000),'
                  ||' SLD_COL_33           VARCHAR2(2000),'
                  ||' SLD_COL_34           VARCHAR2(2000),'
                  ||' SLD_COL_35           VARCHAR2(2000),'
                  ||' SLD_COL_36           VARCHAR2(2000),'
                  ||' SLD_COL_37           VARCHAR2(2000),'
                  ||' SLD_COL_38           VARCHAR2(2000),'
                  ||' SLD_COL_39           VARCHAR2(2000),'
                  ||' SLD_COL_40           VARCHAR2(2000),'
                  ||' SLD_LOAD_GEOMETRY    MDSYS.SDO_GEOMETRY,'
                  ||' SLD_WORKING_GEOMETRY MDSYS.SDO_GEOMETRY,'
                  ||' SLD_STATUS           VARCHAR2(30) DEFAULT ''NEW'' NOT NULL,'
                  ||' SLD_ADJUSTMENT_RULE_APPLIED VARCHAR2(1) DEFAULT ''N''  NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES'
                  ||'(SAAR_ID                    NUMBER(38) NOT NULL,'
                  ||' SAAR_SP_ID                 NUMBER(38) NOT NULL,'
                  ||' SAAR_TARGET_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL,'
                  ||' SAAR_SOURCE_VALUE          VARCHAR2(50),'
                  ||' SAAR_ADJUST_TO_VALUE       VARCHAR2(50),'
                  ||' SAAR_DATE_CREATED          DATE NOT NULL,'
                  ||' SAAR_CREATED_BY            VARCHAR2(30) NOT NULL,'
                  ||' SAAR_DATE_MODIFIED         DATE,'
                  ||' SAAR_MODIFIED_BY           VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_SPATIAL_REVIEW_LEVELS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_SPATIAL_REVIEW_LEVELS'
                  ||'(SSRL_ID                 NUMBER(38) NOT NULL,'
                  ||' SSRL_SP_ID              NUMBER(38) NOT NULL,'
                  ||' SSRL_PERCENT_FROM       NUMBER(6,3),'
                  ||' SSRL_PERCENT_TO         NUMBER(6,3),'
                  ||' SSRL_COVERAGE_LEVEL     VARCHAR2(20),'
                  ||' SSRL_DEFAULT_ACTION     VARCHAR2(30),'
                  ||' SSRL_DATE_CREATED       DATE NOT NULL,'
                  ||' SSRL_CREATED_BY         VARCHAR2(30) NOT NULL,'
                  ||' SSRL_DATE_MODIFIED      DATE,'
                  ||' SSRL_MODIFIED_BY        VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_DATUM_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_DATUM_ATTRIBUTE_MAPPING'
                  ||'(SDAM_PROFILE_ID    NUMBER(38) NOT NULL,'
                  ||' SDAM_NW_TYPE       VARCHAR2(4) NOT NULL,'
                  ||' SDAM_SEQ_NO        NUMBER(38) NOT NULL,'
                  ||' SDAM_COLUMN_NAME   VARCHAR2(30) NOT NULL,'
                  ||' SDAM_DEFAULT_VALUE VARCHAR2(30),'
                  ||' SDAM_FORMULA       VARCHAR2(2000))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_GEOM_ACCURACY'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_GEOM_ACCURACY'
                  ||'(SLGA_ID           NUMBER(38)  NOT NULL,'
                  ||' SLGA_SLD_KEY      NUMBER(38)  NOT NULL,'
                  ||' SLGA_DATUM_ID     NUMBER(38),'
                  ||' SLGA_SEG_ID       NUMBER(38),'
                  ||' SLGA_BUFFER_SIZE  NUMBER(10,3),'
                  ||' SLGA_PCT_INSIDE   NUMBER(10,3),'
                  ||' SLGA_MIN_OFFSET   NUMBER,'
                  ||' SLGA_MAX_OFFSET   NUMBER,'
                  ||' SLGA_SD           NUMBER,'
                  ||' SLGA_MEAN         NUMBER)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
-- ADD COMMENTS TO THE COLUMNS 
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_ID
  IS 'ARTIFICAL KEY FOR THE ACCURAY DATA'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_SLD_KEY
  IS 'THE LOAD FILE RECORD ARTIFICIAL KEY FOR WHICH THE ACCURACY STATISTICS ARE CALCULATED'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_DATUM_ID
  IS 'THE LOAD FILE DERIVED DATUM FOR WHICH THE ACCURACY STATISTICS ARE CALCULATED'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_SEG_ID
  IS 'THE SUB-GEOMETRY IDENTIFIER FOR WHICH THE ACCURACY STATISTICS ARE CALCULATED'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_BUFFER_SIZE
  IS 'THE SPATIAL BUFFER SIZE'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_PCT_INSIDE
  IS 'THE PROPORTION OF EXISTING NETWORK INSIDE THE BUFFER AROUND THE SPATIAL FEATURE OR FRAGMENT OF FEATURE EXPRESSED AS A PERCENTAGE.'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_MIN_OFFSET
  IS 'THE MINIMUM OFFSET OF THE EXISTING NETWORK FROM THE SPATIAL FEATURE OR SUB-FEATURE'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_MAX_OFFSET
  IS 'THE MAXIMUM OFFSET OF THE EXISTING NETWORK FROM THE SPATIAL FEATURE OR SUB-FEATURE'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_SD
  IS 'THE STANDARD DEVIATION OF THE PERCENTAGES RELATING TO ALL SUB-FEATURES OF THE SPATIAL FEATURE'
/
COMMENT ON COLUMN SDL_GEOM_ACCURACY.SLGA_MEAN
  IS 'THE MEAN PERCENTAGE RELATING TO ALL SUB-FEATURES OF THE SPATIAL FEATURE'
/
PROMPT Creating table 'SDL_WIP_DATUMS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_DATUMS'
                  ||'(SWD_ID          NUMBER(38) NOT NULL,'
                  ||' BATCH_ID        NUMBER(38),'
                  ||' SLD_KEY         NUMBER(38),'
                  ||' DATUM_ID        NUMBER(38),'
                  ||' PCT_MATCH       NUMBER(10,3),'
                  ||' STATUS          VARCHAR2(30) DEFAULT ''NEW'',' 
                  ||' MANUAL_OVERRIDE VARCHAR2(1) DEFAULT ''N'','
                  ||' NEW_NE_ID       NUMBER,'
                  ||' GEOM            SDO_GEOMETRY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_PLINE_STATISTICS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_PLINE_STATISTICS'
                  ||'(SLPS_PLINE_ID          NUMBER(38) NOT NULL,'
                  ||' SLPS_SLD_KEY           NUMBER(38) NOT NULL,'
                  ||' SLPS_SWD_ID            NUMBER(38),'
                  ||' SLPS_PLINE_SEGMENT_ID  NUMBER(38),'
                  ||' SLPS_PCT_ACCURACY      NUMBER(10,3) NOT NULL,'
                  ||' SLPS_BUFFER            NUMBER(10,3) NOT NULL,'
                  ||' SLPS_PLINE_GEOMETRY    MDSYS.SDO_GEOMETRY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_INTSCT_GEOM'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_INTSCT_GEOM'
                  ||'(BATCH_ID      NUMBER(38) NOT NULL,'
                  ||' R_ID          NUMBER(38),'
                  ||' SLD_KEY1      NUMBER(38),'
                  ||' SLD_KEY2      NUMBER(38),'
                  ||' RELATION      VARCHAR2(20),'
                  ||' INTSCT_TYPE   VARCHAR2(30) NOT NULL,'
                  ||' TERMINAL_TYPE VARCHAR2(1),'
                  ||' NE_ID         NUMBER(9),'
                  ||' NE_NT_TYPE    VARCHAR2(4),'
                  ||' GEOM          MDSYS.SDO_GEOMETRY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_PT_GEOM'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_PT_GEOM'
                  ||'(BATCH_ID NUMBER(38) NOT NULL,'
                  ||' ID       NUMBER(38),'
                  ||' PT_TYPE  VARCHAR2(30),'
                  ||' GEOM     MDSYS.SDO_GEOMETRY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_PT_ARRAYS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_PT_ARRAYS'
                  ||'(BATCH_ID    NUMBER(38) NOT NULL,'
                  ||' IA          INT_ARRAY_TYPE,'
                  ||' HASHCODE    VARCHAR2(20),'
                  ||' EXISTING_NW VARCHAR2(1))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_NODES'
                  ||'(NODE_ID          NUMBER(38),'
                  ||' BATCH_ID         NUMBER(38),'
                  ||' HASHCODE         VARCHAR2(20),'
                  ||' EXISTING_NODE_ID NUMBER(38),'
                  ||' DISTANCE_FROM    NUMBER,'
                  ||' EXISTING_NW      VARCHAR2(1),'
                  ||' NODE_GEOM        MDSYS.SDO_GEOMETRY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_DATUM_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_DATUM_NODES'
                  ||'(SWD_ID       NUMBER(38),'
                  ||' BATCH_ID     NUMBER(38),'
                  ||' HASHCODE     VARCHAR2(20),'
                  ||' NODE_TYPE    VARCHAR2(1),'
                  ||' NODE_MEASURE NUMBER)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_ROUTE_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_ROUTE_NODES'
                  ||'(BATCH_ID NUMBER(38),'
                  ||' SLD_KEY  NUMBER(38),'
                  ||' HASHCODE VARCHAR2(20))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_SELF_INTERSECTIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_SELF_INTERSECTIONS'
                  ||'(SLD_KEY   NUMBER(38),'
                  ||' PLINE_ID1 NUMBER(38),'
                  ||' PLINE_ID2 NUMBER(38),'
                  ||' RELATION  VARCHAR2(20),'
                  ||' GEOM      MDSYS.SDO_GEOMETRY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_WIP_GRADE_SEPARATIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_WIP_GRADE_SEPARATIONS'
                 ||'(SGS_ID   NUMBER(38) NOT NULL,'
                 ||' SGS_GEOM SDO_GEOMETRY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_VALIDATION_RESULTS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_VALIDATION_RESULTS'
                 ||'(SVR_ID              NUMBER(38) NOT NULL,'
                 ||' SVR_SLD_KEY         NUMBER(38) NOT NULL,'
                 ||' SVR_SFS_ID          NUMBER(38) NOT NULL,'
                 ||' SVR_SWD_ID          NUMBER(38),'
                 ||' SVR_VALIDATION_TYPE VARCHAR2(1),'
                 ||' SVR_SAM_ID          NUMBER(38),'
                 ||' SVR_COLUMN_NAME     VARCHAR2(30),'
                 ||' SVR_CURRENT_VALUE   VARCHAR2(254),'
                 ||' SVR_STATUS_CODE     NUMBER(10) NOT NULL,'
                 ||' SVR_MESSAGE         VARCHAR2(254),'
                 ||' SVR_DATE_CREATED    DATE NOT NULL,'
                 ||' SVR_CREATED_BY      VARCHAR2(30) NOT NULL,'
                 ||' SVR_DATE_MODIFIED   DATE,'
                 ||' SVR_MODIFIED_BY     VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/

PROMPT Creating table 'SDL_PROCESS_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_PROCESS_AUDIT'
                 ||'(SPA_ID               NUMBER(38) NOT NULL,'
                 ||' SPA_PROCESS          VARCHAR2(30) NOT NULL,'
                 ||' SPA_SFS_ID           NUMBER(38) NOT NULL,'
                 ||' SPA_SLD_KEY          NUMBER(38),'
                 ||' SPA_TOLERANCE        NUMBER,'
                 ||' SPA_MATCH_TOLERANCE  NUMBER,'
                 ||' SPA_BUFFER           NUMBER(10,3),' 
                 ||' SPA_STARTED          TIMESTAMP(6) NOT NULL,'
                 ||' SPA_ENDED            TIMESTAMP(6),'
                 ||' SPA_DATE_CREATED     DATE,'
                 ||' SPA_CREATED_BY       VARCHAR2(30),'
                 ||' SPA_DATE_MODIFIED    DATE,'
                 ||' SPA_MODIFIED_BY      VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_ATTRIBUTE_ADJUSTMENT_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_ATTRIBUTE_ADJUSTMENT_AUDIT'
                 ||'(SAAA_ID               NUMBER(38) NOT NULL,'
                 ||' SAAA_SLD_KEY          NUMBER(38) NOT NULL,'
                 ||' SAAA_SFS_ID           NUMBER(38) NOT NULL,'
                 ||' SAAA_SAAR_ID          NUMBER(38) NOT NULL,'
                 ||' SAAA_SAM_ID           NUMBER(38) NOT NULL,'
                 ||' SAAA_ORIGINAL_VALUE   VARCHAR2(254),'
                 ||' SAAA_ADJUSTED_VALUE   VARCHAR2(254),'
                 ||' SAAA_DATE_CREATED     DATE NOT NULL,'
                 ||' SAAA_CREATED_BY       VARCHAR2(30) NOT NULL,'
                 ||' SAAA_DATE_MODIFIED    DATE,'
                 ||' SAAA_MODIFIED_BY      VARCHAR2(30))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
---------------------------------------
-- Sequences
---------------------------------------
PROMPT Creating sequence 'SP_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SP_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SUP_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SUP_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SAM_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SAM_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SFS_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SFS_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SLD_KEY_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SLD_KEY_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SAAR_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SAAR_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SSRL_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SSRL_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SLGA_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SLGA_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SWD_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SWD_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SLPS_PLINE_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SLPS_PLINE_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SDL_NODE_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SDL_NODE_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SVR_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SVR_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SPA_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SPA_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SAAA_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SAAA_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating sequence 'SLD_INTSCT_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SLD_INTSCT_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
---------------------------------------
-- Indexes
---------------------------------------
PROMPT Creating unique index on 'SDL_DATUM_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  execute immediate 'create unique index sdam_uk on sdl_datum_attribute_mapping (sdam_profile_id, sdam_nw_type, sdam_column_name)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating unique index on 'SDL_WIP_DATUMS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX SWD_SLD_UK ON SDL_WIP_DATUMS (SLD_KEY, DATUM_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating unique index on 'SDL_WIP_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX SWN_NO_UK ON SDL_WIP_NODES (NODE_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating unique index on 'SDL_WIP_DATUM_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX SWDN_UK ON SDL_WIP_DATUM_NODES (SWD_ID, HASHCODE, NODE_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating index on 'SDL_DATUM_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SDAM_NT_FK_IDX ON SDL_DATUM_ATTRIBUTE_MAPPING (SDAM_NW_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating indexes on 'SDL_WIP_DATUMS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SWD_BATCH_IDX ON SDL_WIP_DATUMS (BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SWD_NEW_NE_IDX ON SDL_WIP_DATUMS (NEW_NE_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating indexes on 'SDL_WIP_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SDL_WIP_NODES_BATCH_IDX ON SDL_WIP_NODES (BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating indexes on 'SDL_WIP_SELF_INTERSECTIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SDL_WIP_SELF_INTERSECTIONS_IDX ON SDL_WIP_SELF_INTERSECTIONS (SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating index on 'SDL_PLINE_STATISTICS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SLPS_SLD_FK_IDX ON SDL_PLINE_STATISTICS(SLPS_SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SLPS_SWD_FK_IDX ON SDL_PLINE_STATISTICS(SLPS_SWD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating index on 'SDL_WIP_INTSCT_GEOM'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SDL_WIP_INTSCT_GEOM_IDX ON SDL_WIP_INTSCT_GEOM (BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating index on 'SDL_WIP_PT_GEOM'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SDL_WIP_PT_GEOM_IDX ON SDL_WIP_PT_GEOM (BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating index on 'SDL_WIP_PT_ARRAYS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SDL_WIP_PT_ARRAYS_IDX ON SDL_WIP_PT_ARRAYS (HASHCODE, BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating index on 'SDL_WIP_DATUM_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SWDN_SWN_FK_IDX ON SDL_WIP_DATUM_NODES (HASHCODE, BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating indexes on 'SDL_WIP_ROUTE_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SWRN_NO_IDX ON SDL_WIP_ROUTE_NODES (HASHCODE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SWRN_SLD_IDX ON SDL_WIP_ROUTE_NODES (SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating indexes on 'SDL_VALIDATION_RESULTS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SVR_SAM_FK_IDX ON SDL_VALIDATION_RESULTS (SVR_SAM_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SVR_SLD_FK_IDX ON SDL_VALIDATION_RESULTS (SVR_SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SVR_SWD_FK_IDX ON SDL_VALIDATION_RESULTS (SVR_SWD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SVR_BATCH_IDX ON SDL_VALIDATION_RESULTS (SVR_SFS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating indexes on 'SDL_PROCESS_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SPA_SFS_IDX ON SDL_PROCESS_AUDIT (SPA_SFS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE INDEX SPA_SLD_IDX ON SDL_PROCESS_AUDIT (SPA_SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
---------------------------------------
-- Constraints
---------------------------------------
PROMPT Creating Primary Key on 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD CONSTRAINT SP_PK PRIMARY KEY (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_USER_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_USER_PROFILES ADD CONSTRAINT SUP_PK PRIMARY KEY (SUP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SLAM_PK PRIMARY KEY (SAM_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_FILE_SUBMISSIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD CONSTRAINT SFS_PK PRIMARY KEY (SFS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD CONSTRAINT SAAR_PK PRIMARY KEY (SAAR_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_SPATIAL_REVIEW_LEVELS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_SPATIAL_REVIEW_LEVELS ADD CONSTRAINT SSRL_PK PRIMARY KEY (SSRL_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_GEOM_ACCURACY'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_GEOM_ACCURACY ADD CONSTRAINT SLGA_PK PRIMARY KEY (SLGA_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_WIP_DATUMS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUMS ADD CONSTRAINT SWD_PK PRIMARY KEY (SWD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_PLINE_STATISTICS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PLINE_STATISTICS ADD CONSTRAINT SLPS_PK PRIMARY KEY (SLPS_PLINE_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_WIP_GRADE_SEPARATIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_GRADE_SEPARATIONS ADD PRIMARY KEY (SGS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_VALIDATION_RESULTS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_VALIDATION_RESULTS ADD CONSTRAINT SVR_PK PRIMARY KEY (SVR_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_PROCESS_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROCESS_AUDIT ADD CONSTRAINT SPA_PK PRIMARY KEY (SPA_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Primary Key on 'SDL_ATTRIBUTE_ADJUSTMENT_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_AUDIT ADD CONSTRAINT SAAA_PK PRIMARY KEY (SAAA_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Unique Key on 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD CONSTRAINT SP_UK UNIQUE (SP_NAME)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_USER_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_USER_PROFILES ADD CONSTRAINT SUP_UK UNIQUE (SUP_USER_ID, SUP_SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SNAM_UK1 UNIQUE (SAM_SP_ID, SAM_COL_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SNAM_UK2 UNIQUE (SAM_SP_ID, SAM_FILE_ATTRIBUTE_NAME)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SNAM_UK3 UNIQUE (SAM_SP_ID, SAM_VIEW_COLUMN_NAME)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_FILE_SUBMISSIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD CONSTRAINT SFS_UK UNIQUE (SFS_NAME)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_LOAD_DATA'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_LOAD_DATA ADD CONSTRAINT SLD_UK1 UNIQUE (SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_LOAD_DATA ADD CONSTRAINT SLD_UK2 UNIQUE (SLD_SFS_ID, SLD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD CONSTRAINT SAAR_UK UNIQUE (SAAR_SP_ID, SAAR_TARGET_ATTRIBUTE_NAME, SAAR_SOURCE_VALUE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_SPATIAL_REVIEW_LEVELS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_SPATIAL_REVIEW_LEVELS ADD CONSTRAINT SSRL_UK UNIQUE (SSRL_SP_ID, SSRL_PERCENT_FROM, SSRL_PERCENT_TO)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_WIP_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_NODES ADD CONSTRAINT SWN_UK UNIQUE (HASHCODE, BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Unique Key on 'SDL_VALIDATION_RESULTS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_VALIDATION_RESULTS ADD CONSTRAINT SVR_UK UNIQUE (SVR_SLD_KEY, SVR_VALIDATION_TYPE, SVR_SAM_ID, SVR_SWD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD CONSTRAINT SP_NLT_FK FOREIGN KEY (SP_NLT_ID) REFERENCES NM_LINEAR_TYPES (NLT_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE sdl_profiles ADD CONSTRAINT SP_UN_FK FOREIGN KEY (SP_TOL_SEARCH_UNIT) REFERENCES NM_UNITS (UN_UNIT_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_USER_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_USER_PROFILES ADD CONSTRAINT SUP_HUS_FK FOREIGN KEY (SUP_USER_ID) REFERENCES HIG_USERS (HUS_USER_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_USER_PROFILES ADD CONSTRAINT SUP_SP_FK FOREIGN KEY (SUP_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SNAM_SP_FK FOREIGN KEY (SAM_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_FILE_SUBMISSIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD CONSTRAINT SFS_HUS_FK FOREIGN KEY (SFS_USER_ID) REFERENCES HIG_USERS (HUS_USER_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD CONSTRAINT SFS_SP_FK FOREIGN KEY (SFS_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_LOAD_DATA'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_LOAD_DATA ADD CONSTRAINT SDL_SFS_FK FOREIGN KEY (SLD_SFS_ID) REFERENCES SDL_FILE_SUBMISSIONS (SFS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD CONSTRAINT SAAR_SAM_FK FOREIGN KEY (SAAR_SP_ID, SAAR_TARGET_ATTRIBUTE_NAME) REFERENCES SDL_ATTRIBUTE_MAPPING (SAM_SP_ID, SAM_VIEW_COLUMN_NAME)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD CONSTRAINT SAAR_SP_FK FOREIGN KEY (SAAR_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_SPATIAL_REVIEW_LEVELS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_SPATIAL_REVIEW_LEVELS ADD CONSTRAINT SSRL_SP_FK FOREIGN KEY (SSRL_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_DATUM_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DATUM_ATTRIBUTE_MAPPING ADD CONSTRAINT SDAM_NT_FK FOREIGN KEY (SDAM_NW_TYPE) REFERENCES NM_TYPES (NT_TYPE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DATUM_ATTRIBUTE_MAPPING ADD CONSTRAINT SDAM_SP_FK FOREIGN KEY (SDAM_PROFILE_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_GEOM_ACCURACY'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_GEOM_ACCURACY ADD CONSTRAINT SLGA_SLD_FK FOREIGN KEY (SLGA_SLD_KEY) REFERENCES SDL_LOAD_DATA (SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_PLINE_STATISTICS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PLINE_STATISTICS ADD CONSTRAINT SLPS_SLD_FK FOREIGN KEY (SLPS_SLD_KEY) REFERENCES SDL_LOAD_DATA (SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PLINE_STATISTICS ADD CONSTRAINT SLPS_SWD_FK FOREIGN KEY (SLPS_SWD_ID) REFERENCES SDL_WIP_DATUMS (SWD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_WIP_DATUM_NODES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUM_NODES ADD CONSTRAINT SWDN_SWD_FK FOREIGN KEY (SWD_ID) REFERENCES SDL_WIP_DATUMS (SWD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUM_NODES ADD CONSTRAINT SWDN_SWN_FK FOREIGN KEY (HASHCODE, BATCH_ID) REFERENCES SDL_WIP_NODES (HASHCODE, BATCH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_VALIDATION_RESULTS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_VALIDATION_RESULTS ADD CONSTRAINT SVR_SFS_FK FOREIGN KEY (SVR_SFS_ID) REFERENCES SDL_FILE_SUBMISSIONS (SFS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_VALIDATION_RESULTS ADD CONSTRAINT SVR_SAM_FK FOREIGN KEY (SVR_SAM_ID) REFERENCES SDL_ATTRIBUTE_MAPPING (SAM_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_VALIDATION_RESULTS ADD CONSTRAINT SVR_SWD_FK FOREIGN KEY (SVR_SWD_ID) REFERENCES SDL_WIP_DATUMS (SWD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_PROCESS_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROCESS_AUDIT ADD CONSTRAINT SPA_SFS_FK FOREIGN KEY (SPA_SFS_ID) REFERENCES SDL_FILE_SUBMISSIONS (SFS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROCESS_AUDIT ADD CONSTRAINT SPA_SLD_FK FOREIGN KEY (SPA_SLD_KEY) REFERENCES SDL_LOAD_DATA (SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating Foreign Key on 'SDL_ATTRIBUTE_ADJUSTMENT_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_AUDIT ADD CONSTRAINT SAAA_SLD_FK FOREIGN KEY (SAAA_SLD_KEY) REFERENCES SDL_LOAD_DATA (SLD_KEY)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/  
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_AUDIT ADD CONSTRAINT SAAA_SFS_FK FOREIGN KEY (SAAA_SFS_ID) REFERENCES SDL_FILE_SUBMISSIONS (SFS_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/  
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_AUDIT ADD CONSTRAINT SAAA_SAAR_FK FOREIGN KEY (SAAA_SAAR_ID) REFERENCES SDL_ATTRIBUTE_ADJUSTMENT_RULES (SAAR_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/  
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_AUDIT ADD CONSTRAINT SAAA_SAM_FK FOREIGN KEY (SAAA_SAM_ID) REFERENCES SDL_ATTRIBUTE_MAPPING (SAM_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating check constraint on 'SDL_FILE_SUBMISSIONS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD CONSTRAINT SFS_VAL_COMPLETE_CHK CHECK (SFS_ATTRI_VALIDATION_COMPLETED IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD CONSTRAINT SFS_ANALYSIS_COMPLETE_CHK CHECK (SFS_SPATIAL_ANALYSIS_COMPLETED IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD CONSTRAINT SFS_LOAD_DATA_CHK CHECK (SFS_LOAD_DATA_COMPLETED IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating check constraint on 'SDL_SPATIAL_REVIEW_LEVELS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_SPATIAL_REVIEW_LEVELS ADD CONSTRAINT SSRL_PERCENT_CHK CHECK (SSRL_PERCENT_TO >= SSRL_PERCENT_FROM)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating check constraint on 'SDL_WIP_DATUMS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUMS ADD CONSTRAINT SWD_MANUAL_OVERRIDE_CHK CHECK (MANUAL_OVERRIDE IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_WIP_DATUMS ADD CONSTRAINT SWD_STATUS_CHK CHECK (STATUS IN (''NEW'',''VALID'',''INVALID'',''NO_ACTION'',''REVIEW'',''LOAD'',''SKIP'',''TRANSFERRED'',''REJECTED''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating check constraint on 'SDL_PROCESS_AUDIT'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROCESS_AUDIT ADD CONSTRAINT SPA_PROCESS_CHK CHECK (SPA_PROCESS IN (''NEW'',''ADJUST'',''ANALYSIS'',''DATUM_VALIDATION'',''LOAD'',''LOAD_VALIDATION'',''REJECT'',''TOPO_GENERATION'',''TRANSFER''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROCESS_AUDIT ADD CONSTRAINT SPA_TIMESTAMP_CHK CHECK (SPA_ENDED >= SPA_STARTED)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
SET TERM OFF
------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------