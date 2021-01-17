-----------------------------------------------------------------------------
-- tdl_ddl_upg.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/tdl_ddl_upg.sql-arc   1.0   Jan 17 2021 10:33:10   Vikas.Mhetre  $
--       Module Name      : $Workfile:   tdl_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jan 17 2021 10:33:10  $
--       Date fetched Out : $Modtime:   Jan 17 2021 10:27:24  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
PROMPT Creating table 'SDL_PROFILE_FILE_COLUMNS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_PROFILE_FILE_COLUMNS'
                  ||'(SPFC_ID           NUMBER(38) NOT NULL,'
                  ||' SPFC_SP_ID        NUMBER(38) NOT NULL,'
                  ||' SPFC_COL_ID       NUMBER(38) NOT NULL,'
                  ||' SPFC_COL_NAME     VARCHAR2(30) NOT NULL,'
                  ||' SPFC_COL_DATATYPE VARCHAR2(8),'
                  ||' SPFC_COL_SIZE     NUMBER(4),'
                  ||' SPFC_CONTAINER    VARCHAR2(30),'
                  ||' SPFC_DATE_FORMAT  VARCHAR2(20),'
                  ||' SPFC_MANDATORY    VARCHAR2(1) DEFAULT ''N'' NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating table 'SDL_SOURCE_TYPE_ATTRIBS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_SOURCE_TYPE_ATTRIBS'
                  ||'(SSTA_ID              NUMBER(38) NOT NULL,'
                  ||' SSTA_SOURCE_TYPE     VARCHAR2(20) NOT NULL,'
                  ||' SSTA_ATTRIBUTE       VARCHAR2(20) NOT NULL,'
                  ||' SSTA_ATTRIBUTE_TEXT  VARCHAR2(30),'				  
                  ||' SSTA_DATATYPE        VARCHAR2(8),'
                  ||' SSTA_SIZE            NUMBER(4),'
                  ||' SSTA_DEFAULT	       VARCHAR2(400),'
                  ||' SSTA_DOMAIN	       VARCHAR2(20),'
				  ||' SSTA_MANDATORY       VARCHAR2(1) DEFAULT ''N'' NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating table 'SDL_SOURCE_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_PROFILE_SOURCE_HEADER'
                  ||'(SPSH_ID            NUMBER(38) NOT NULL,'
                  ||' SPSH_SP_ID         NUMBER(38) NOT NULL,'
                  ||' SPSH_SSTA_ID       NUMBER(38) NOT NULL,'
                  ||' SPSH_ATTRIB_VALUE  VARCHAR2(1000))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating table 'SDL_DESTINATION_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_DESTINATION_HEADER'
                  ||'(SDH_ID                   NUMBER(38) NOT NULL,'
                  ||' SDH_SP_ID                NUMBER(38) NOT NULL,'
				  ||' SDH_TYPE                 VARCHAR2(1),'
                  ||' SDH_DESTINATION_TYPE     VARCHAR2(4) NOT NULL,'
				  ||' SDH_NLT_ID               NUMBER,'
                  ||' SDH_SOURCE_CONTAINER     VARCHAR2(30),'
                  ||' SDH_DESTINATION_LOCATION VARCHAR2(1) DEFAULT ''N'' NOT NULL,'
                  ||' SDH_NLD_ID               NUMBER(9),'
                  ||' SDH_TABLE_NAME           VARCHAR2(30),'
                  ||' SDH_INSERT_PROCEDURE     VARCHAR2(61),'
                  ||' SDH_VALIDATION_PROCEDURE VARCHAR2(61))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating table 'SDL_XSP_DATA'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN

  EXECUTE IMMEDIATE 'CREATE GLOBAL TEMPORARY TABLE SDL_XSP_DATA'
                  ||'(SDH_ID           NUMBER,'
                  ||' TLD_SFS_ID       NUMBER,'
                  ||' TLD_ID           NUMBER,'
                  ||' INV_TYPE         VARCHAR2(4),'
                  ||' XSP              VARCHAR2(4),'
                  ||' SOURCE_NE_ID     NUMBER,'
                  ||' SOURCE_NLT_ID    NUMBER,'
                  ||' SOURCE_NT_TYPE   VARCHAR2(4),'
                  ||' SOURCE_GTY_TYPE  VARCHAR2(4))'
                  ||' ON COMMIT PRESERVE ROWS NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating table 'SDL_ROW_STATUS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_ROW_STATUS'
                  ||'(SRS_SP_ID      NUMBER(38) NOT NULL,'
                  ||' SRS_SFS_ID     NUMBER(38) NOT NULL,'
                  ||' SRS_TLD_ID     NUMBER(38) NOT NULL,'
                  ||' SRS_RECORD_NO  NUMBER NOT NULL,'
                  ||' SRS_STATUS     VARCHAR2(1))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
PROMPT Creating table 'SDL_DESTINATION_LINKS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE SDL_DESTINATION_LINKS'
                  ||'(SDL_LINK_ID     NUMBER(38) NOT NULL,'
                  ||' SDL_SDR_ID      NUMBER(38) NOT NULL,'
                  ||' SDL_SFS_ID      NUMBER(38) NOT NULL,'
                  ||' SDL_TLD_ID      NUMBER(38) NOT NULL,'
                  ||' SDL_LINK_VALUE  NUMBER(38) NOT NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Alter Table 'SDL_USER_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_USER_PROFILES ADD SUP_ACCESS_TYPE VARCHAR2(50) DEFAULT ''UPLOAD'' NOT NULL';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Alter Table 'SDL_PROFILES' modify to NULL
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1451);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES MODIFY (SP_TOPOLOGY_LEVEL NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1451);
  obj_exists1 EXCEPTION;
  PRAGMA exception_init( obj_exists1, -904);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES MODIFY (SP_NLT_ID NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
  WHEN obj_exists1 THEN
    NULL;
END;
/
--
PROMPT Alter Table 'SDL_PROFILES' add columns
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD SP_SOURCE_CS NUMBER(10)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD SP_DESTINATION_CS NUMBER(10)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD SP_API_ROWTYPE VARCHAR2(1) DEFAULT ''N'' NOT NULL';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Alter Table 'SDL_ATTRIBUTE_MAPPING' add columns
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD SAM_SDH_ID NUMBER(38) NOT NULL';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD SAM_DEFAULT_VALUE VARCHAR2(500)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Alter Table 'SDL_ATTRIBUTE_ADJUSTMENT_RULES' add columns
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD SAAR_SDH_ID NUMBER(38) NOT NULL';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD SAAR_USER_ID NUMBER(9) DEFAULT -1 NOT NULL';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Alter Table 'SDL_FILE_SUBMISSIONS' add columns
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1430);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_FILE_SUBMISSIONS ADD SFS_SDH_ID NUMBER(38)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Dropping columns from 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -904);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES DROP COLUMN SP_DEFAULT_TOLERANCE'; -- unused
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -904);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES DROP COLUMN SP_MAX_IMPORT_LEVEL'; -- access type moved to user profile
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -904);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES DROP COLUMN SP_NLT_ID'; -- destination type moved to destination header
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -1451);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING MODIFY (SAM_FILE_ATTRIBUTE_NAME NULL)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
---------------------------------------
-- Sequences
---------------------------------------
PROMPT Creating sequence 'SPFC_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SPFC_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating sequence 'SSTA_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SSTA_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating sequence 'SPSH_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SPSH_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating sequence 'SDH_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SDH_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating sequence 'SDL_LINK_ID_SEQ'
DECLARE
obj_exists EXCEPTION;
PRAGMA EXCEPTION_INIT( obj_exists, -955);
BEGIN
EXECUTE IMMEDIATE 'CREATE SEQUENCE SDL_LINK_ID_SEQ MINVALUE 1 NOMAXVALUE START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
---------------------------------------
-- Indexes
---------------------------------------
PROMPT Creating unique index on 'SDL_ROW_STATUS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX SRS_PK ON SDL_ROW_STATUS (SRS_SFS_ID, SRS_TLD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating unique index on 'SDL_DESTINATION_LINKS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX SDL_PK ON SDL_DESTINATION_LINKS(SDL_LINK_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating unique index on 'SDL_DESTINATION_LINKS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX SDL_SDR_LINK_UK ON SDL_DESTINATION_LINKS(SDL_SDR_ID, SDL_LINK_VALUE)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating unique index on 'SDL_DESTINATION_LINKS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -955);
BEGIN
  EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX SDL_UK ON SDL_DESTINATION_LINKS(SDL_SFS_ID, SDL_TLD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
---------------------------------------
-- Constraints
---------------------------------------
PROMPT Creating Primary Key on 'SDL_PROFILE_FILE_COLUMNS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_FILE_COLUMNS ADD CONSTRAINT SPFC_PK PRIMARY KEY (SPFC_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Primary Key on 'SDL_SOURCE_TYPE_ATTRIBS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_SOURCE_TYPE_ATTRIBS ADD CONSTRAINT SSTA_PK PRIMARY KEY (SSTA_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Primary Key on 'SDL_PROFILE_SOURCE_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_SOURCE_HEADER ADD CONSTRAINT SPSH_PK PRIMARY KEY (SPSH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Primary Key on 'SDL_DESTINATION_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_HEADER ADD CONSTRAINT SDH_PK PRIMARY KEY (SDH_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Primary Key on 'SDL_ROW_STATUS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ROW_STATUS ADD (CONSTRAINT SRS_PK PRIMARY KEY (SRS_SFS_ID, SRS_TLD_ID))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Primary Key on 'SDL_DESTINATION_LINKS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2260);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_LINKS ADD (CONSTRAINT SDL_PK PRIMARY KEY (SDL_LINK_ID))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Unique Key on 'SDL_PROFILE_FILE_COLUMNS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_FILE_COLUMNS ADD CONSTRAINT SPFC_UK UNIQUE (SPFC_SP_ID, SPFC_COL_NAME, SPFC_CONTAINER)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_FILE_COLUMNS ADD CONSTRAINT SPFC_UK1 UNIQUE (SPFC_SP_ID, SPFC_COL_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Unique Key on 'SDL_PROFILE_SOURCE_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_SOURCE_HEADER ADD CONSTRAINT SPSH_UK UNIQUE (SPSH_SP_ID, SPSH_SSTA_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Unique Key on 'SDL_DESTINATION_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_HEADER ADD CONSTRAINT SDH_UK1 UNIQUE (SDH_ID, SDH_SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_HEADER ADD CONSTRAINT SDH_UK2 UNIQUE (SDH_SP_ID, SDH_DESTINATION_TYPE, SDH_DESTINATION_LOCATION)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Unique Key on 'SDL_ROW_STATUS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ROW_STATUS ADD (CONSTRAINT SRS_UK UNIQUE (SRS_SFS_ID, SRS_RECORD_NO))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Unique Key on 'SDL_DESTINATION_LINKS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_LINKS ADD (CONSTRAINT SDL_SDR_LINK_UK UNIQUE (SDL_SDR_ID, SDL_LINK_VALUE))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_LINKS ADD (CONSTRAINT SDL_UK UNIQUE (SDL_SFS_ID, SDL_TLD_ID))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_PROFILE_FILE_COLUMNS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_FILE_COLUMNS ADD CONSTRAINT SPFC_SP_FK FOREIGN KEY (SPFC_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_PROFILE_SOURCE_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_SOURCE_HEADER ADD CONSTRAINT SPSH_SP_FK FOREIGN KEY (SPSH_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_SOURCE_HEADER ADD CONSTRAINT SPSH_SSTA_FK FOREIGN KEY (SPSH_SSTA_ID) REFERENCES SDL_SOURCE_TYPE_ATTRIBS (SSTA_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_DESTINATION_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_HEADER ADD CONSTRAINT SDH_SP_FK FOREIGN KEY (SDH_SP_ID) REFERENCES SDL_PROFILES (SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_DESTINATION_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_HEADER ADD CONSTRAINT SDH_NLT_FK FOREIGN KEY (SDH_NLT_ID) REFERENCES NM_LINEAR_TYPES (NLT_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_HEADER ADD CONSTRAINT SDH_NLD_FK FOREIGN KEY (SDH_NLD_ID) REFERENCES NM_LOAD_DESTINATIONS (NLD_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_ATTRIBUTE_MAPPING'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SNAM_SDH_FK FOREIGN KEY (SAM_SDH_ID, SAM_SP_ID) REFERENCES SDL_DESTINATION_HEADER (SDH_ID, SDH_SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD CONSTRAINT SAAR_SDH_FK FOREIGN KEY (SAAR_SDH_ID, SAAR_SP_ID) REFERENCES SDL_DESTINATION_HEADER (SDH_ID, SDH_SP_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_ROW_STATUS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ROW_STATUS ADD (CONSTRAINT SRS_FK_SFS FOREIGN KEY (SRS_SFS_ID) REFERENCES SDL_FILE_SUBMISSIONS (SFS_ID))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ROW_STATUS ADD (CONSTRAINT SRS_FK_SP FOREIGN KEY (SRS_SP_ID) REFERENCES SDL_PROFILES (SP_ID))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating check constraint on 'SDL_PROFILES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILES ADD CONSTRAINT SP_API_ROWTYPE_CHK CHECK (SP_API_ROWTYPE IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating check constraint on 'SDL_PROFILE_FILE_COLUMNS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_PROFILE_FILE_COLUMNS ADD CONSTRAINT SPFC_MANDATORY_CHK CHECK (SPFC_MANDATORY IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating check constraint on 'SDL_SOURCE_TYPE_ATTRIBS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_SOURCE_TYPE_ATTRIBS ADD CONSTRAINT SSTA_MANDATORY_CHK CHECK (SSTA_MANDATORY IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating check constraint on 'SDL_DESTINATION_HEADER'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_DESTINATION_HEADER ADD CONSTRAINT SDH_DESTINATION_LOCATION_CHK CHECK (SDH_DESTINATION_LOCATION IN (''Y'',''N''))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating check constraint on 'SDL_ROW_STATUS'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2264);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ROW_STATUS ADD (CONSTRAINT SRS_STATUS_CHK CHECK (SRS_STATUS IN (''X'', ''H'', ''E'', ''V'', ''I'')))';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT DROP constraint SNAM_UK1 if exists and re-create
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2443);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING DROP CONSTRAINT SNAM_UK1';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT DROP constraint SNAM_UK2 if exists
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2443);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING DROP CONSTRAINT SNAM_UK2';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT DROP constraint SAAR_SAM_FK if exists and re-create with name SAAR_SNAM_FK
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2443);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES DROP CONSTRAINT SAAR_SAM_FK';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT DROP constraint SAAR_SNAM_FK if exists
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2443);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES DROP CONSTRAINT SAAR_SNAM_FK';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT DROP constraint SNAM_UK3 if exists and re-create
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2443);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING DROP CONSTRAINT SNAM_UK3';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Re-add unique constraint SNAM_UK1
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SNAM_UK1 UNIQUE (SAM_SP_ID, SAM_SDH_ID, SAM_COL_ID)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Re-add unique constraint SNAM_UK3
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2261);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_MAPPING ADD CONSTRAINT SNAM_UK3 UNIQUE (SAM_SP_ID, SAM_SDH_ID, SAM_VIEW_COLUMN_NAME)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/
--
PROMPT Creating Foreign Key on 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
DECLARE
  obj_exists EXCEPTION;
  PRAGMA exception_init( obj_exists, -2275);
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE SDL_ATTRIBUTE_ADJUSTMENT_RULES ADD CONSTRAINT SAAR_SNAM_FK FOREIGN KEY (SAAR_SP_ID, SAAR_SDH_ID, SAAR_TARGET_ATTRIBUTE_NAME)  REFERENCES SDL_ATTRIBUTE_MAPPING (SAM_SP_ID, SAM_SDH_ID, SAM_VIEW_COLUMN_NAME)';
EXCEPTION
  WHEN obj_exists THEN
    NULL;
END;
/