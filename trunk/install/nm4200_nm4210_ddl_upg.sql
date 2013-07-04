------------------------------------------------------------------
-- nm4200_nm4210_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4200_nm4210_ddl_upg.sql-arc   3.13   Jul 04 2013 14:16:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4200_nm4210_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       Version          : $Revision:   3.13  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT max_length fields added
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108523
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- HOL_MAX_LENGTH and HUOL_MAX_LENGTH fields have been added to the HIG_OPTION_LIST and HIG_USER_OPTION_LIST table respectively
-- 
------------------------------------------------------------------
ALTER TABLE hig_option_list DISABLE ALL TRIGGERS;

ALTER TABLE hig_option_list ADD  (
hol_max_length NUMBER(7) DEFAULT 2000 NOT NULL
)
/

ALTER TABLE hig_option_list ENABLE ALL TRIGGERS;

ALTER TABLE hig_user_option_list DISABLE ALL TRIGGERS;

ALTER TABLE hig_user_option_list ADD (
huol_max_length NUMBER(7) DEFAULT 2000 NOT NULL
)
/

ALTER TABLE hig_user_option_list ENABLE ALL TRIGGERS;
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New table added
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108246
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- New table that stores the excluded reserve words for the NM3FLX.IS_RESERVE_WORD function.
-- 
------------------------------------------------------------------
CREATE TABLE NM_RESERVE_WORDS_EX
(
   NRWE_KEYWORD VARCHAR2(30)                NOT NULL
 , NRWE_EXCLUDE  VARCHAR2(1)   DEFAULT 'Y'  NOT NULL
)
/
ALTER TABLE NM_RESERVE_WORDS_EX ADD (
  CONSTRAINT NRWE_KEYWORD_UPPER_CHK
  CHECK (NRWE_KEYWORD = UPPER(NRWE_KEYWORD)),
  CONSTRAINT NRWE_EXCLUDE_YN_CHK
  CHECK (NRWE_EXCLUDE IN ('Y', 'N')), 
  CONSTRAINT NRWE_PK
  PRIMARY KEY
  (NRWE_KEYWORD))
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT new field added to nm_element_history
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108990
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Field holds description of the reason for change.
-- 
------------------------------------------------------------------
ALTER TABLE nm_element_history ADD 
(
neh_descr VARCHAR2(2000)
)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Removal of obsolete sdo objects
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109297
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Tables, Triggers and Packages previously used in Nm3 SDO removed as obsolete.
-- 
------------------------------------------------------------------
DECLARE
  e_table_nonexist exception;
  PRAGMA EXCEPTION_INIT(e_table_nonexist, -00942);
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE NM_SDE_TEMP_RESCALE';
EXCEPTION
WHEN e_table_nonexist THEN
  NULL;
WHEN OTHERS THEN
  RAISE;
END;
/
DECLARE
  e_table_nonexist exception;
  PRAGMA EXCEPTION_INIT(e_table_nonexist, -00942);
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE NM_MEMBERS_SDE_TEMP';
EXCEPTION
WHEN e_table_nonexist THEN
  NULL;
WHEN OTHERS THEN
  RAISE;
END;
/
DECLARE
  e_package_nonexist exception;
  PRAGMA EXCEPTION_INIT(e_package_nonexist, -04043);
BEGIN
  EXECUTE IMMEDIATE 'DROP PACKAGE NM3INV_SDE';
EXCEPTION
WHEN e_package_nonexist THEN
  NULL;
WHEN OTHERS THEN
  RAISE;
END;
/
DECLARE
  e_trigger_nonexist exception;
  PRAGMA EXCEPTION_INIT(e_trigger_nonexist, -04080);
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER NM_MEMBERS_SDE_TRG';
EXCEPTION
WHEN e_trigger_nonexist THEN
  NULL;
WHEN OTHERS THEN
  RAISE;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT removal of nm_sdo_trg_members
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109451
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Removes the obsolete table nm_sdo_trg_members
-- 
------------------------------------------------------------------
DECLARE
  e_table_nonexist exception;
  PRAGMA EXCEPTION_INIT(e_table_nonexist, -00942);
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE nm_sdo_trg_members';
EXCEPTION
WHEN e_table_nonexist THEN
  NULL;
WHEN OTHERS THEN
  RAISE;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT PROCESS_ADMIN, PROCESS_USER roles
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109363
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Roles to support execution of jobs and external jobs
-- 
------------------------------------------------------------------
DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE PROCESS_USER';
  EXCEPTION
    WHEN role_exists
    THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT CREATE JOB TO PROCESS_USER';
  EXECUTE IMMEDIATE 'GRANT CREATE EXTERNAL JOB TO PROCESS_USER';
  EXECUTE IMMEDIATE 'GRANT PROCESS_USER to '||USER;
  EXECUTE IMMEDIATE 'GRANT PROCESS_USER to '||USER||' WITH ADMIN OPTION';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/


DECLARE
  role_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT(role_exists, -1921); 
BEGIN
  BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE PROCESS_ADMIN';
  EXCEPTION
    WHEN role_exists
    THEN NULL;
  END;
  EXECUTE IMMEDIATE 'GRANT CREATE ANY JOB TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT CREATE EXTERNAL JOB TO PROCESS_ADMIN';
  EXECUTE IMMEDIATE 'GRANT PROCESS_ADMIN to '||USER;
  EXECUTE IMMEDIATE 'GRANT PROCESS_ADMIN to '||USER||' WITH ADMIN OPTION';
EXCEPTION
  WHEN role_exists
  THEN NULL;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT FTP Metadata Tables
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- FTP Metadata Tables
-- 
------------------------------------------------------------------
PROMPT Creating Table 'HIG_FTP_TYPES'

CREATE TABLE HIG_FTP_TYPES
 (HFT_ID NUMBER(38) NOT NULL
 ,HFT_TYPE VARCHAR2(20) NOT NULL
 ,HFT_DESCR VARCHAR2(500) NOT NULL
 ,HFT_DATE_CREATED DATE
 ,HFT_DATE_MODIFIED DATE
 ,HFT_MODIFIED_BY VARCHAR2(30)
 ,HFT_CREATED_BY VARCHAR2(30)
 )
/

PROMPT Creating Table 'HIG_FTP_CONNECTIONS'
CREATE TABLE HIG_FTP_CONNECTIONS
 (HFC_ID NUMBER(38) NOT NULL
 ,HFC_HFT_ID NUMBER(38) NOT NULL
 ,HFC_NAME VARCHAR2(50) NOT NULL
 ,HFC_NAU_ADMIN_UNIT NUMBER
 ,HFC_NAU_UNIT_CODE VARCHAR2(10)
 ,HFC_NAU_ADMIN_TYPE VARCHAR2(4)
 ,HFC_FTP_USERNAME VARCHAR2(500) NOT NULL
 ,HFC_FTP_PASSWORD VARCHAR2(500)
 ,HFC_FTP_HOST VARCHAR2(30) NOT NULL
 ,HFC_FTP_PORT VARCHAR2(50)
 ,HFC_FTP_IN_DIR VARCHAR2(500)
 ,HFC_FTP_OUT_DIR VARCHAR2(500)
 ,HFC_FTP_ARC_USERNAME VARCHAR2(500)
 ,HFC_FTP_ARC_PASSWORD VARCHAR2(500)
 ,HFC_FTP_ARC_HOST VARCHAR2(30)
 ,HFC_FTP_ARC_PORT VARCHAR2(50)
 ,HFC_FTP_ARC_IN_DIR VARCHAR2(500)
 ,HFC_FTP_ARC_OUT_DIR VARCHAR2(500)
 ,HFC_DATE_CREATED DATE
 ,HFC_DATE_MODIFIED DATE
 ,HFC_MODIFIED_BY VARCHAR2(30)
 ,HFC_CREATED_BY VARCHAR2(30)
 )
/

PROMPT Creating Primary Key on 'HIG_FTP_TYPES'

ALTER TABLE HIG_FTP_TYPES
 ADD (CONSTRAINT HFT_PK PRIMARY KEY
  (HFT_ID))
/

PROMPT Creating Unique Key on 'HIG_FTP_TYPES'

ALTER TABLE HIG_FTP_TYPES
 ADD (CONSTRAINT HFT_UK UNIQUE
  (HFT_TYPE))
/

PROMPT Creating Primary Key on 'HIG_FTP_CONNECTIONS'

ALTER TABLE HIG_FTP_CONNECTIONS
 ADD (CONSTRAINT HFC_PK PRIMARY KEY
  (HFC_ID))
/

PROMPT Creating Unique Key on 'HIG_FTP_CONNECTIONS'

ALTER TABLE HIG_FTP_CONNECTIONS
 ADD (CONSTRAINT HFC_UK UNIQUE
  (HFC_HFT_ID
  ,HFC_NAME))
/

PROMPT Creating Foreign Key on 'HIG_FTP_CONNECTIONS'

ALTER TABLE HIG_FTP_CONNECTIONS ADD (CONSTRAINT
 HFC_HFT_FK FOREIGN KEY
  (HFC_HFT_ID) REFERENCES HIG_FTP_TYPES
  (HFT_ID))
/

PROMPT Creating Sequence 'HFT_ID_SEQ'

CREATE SEQUENCE HFT_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/


PROMPT Creating Sequence 'HFC_ID_SEQ'

CREATE SEQUENCE HFC_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Doc Assoc - Rebuild Indexes and constraints
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109499
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Rebuild Doc Assocs Indexes and Constraints
-- 
------------------------------------------------------------------
DECLARE
  TYPE tab_varchar IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
  l_drop_con   tab_varchar;
  l_drop_index tab_varchar;
BEGIN
--
-- Gather constraint drop statements
--
  SELECT 'alter table doc_assocs drop constraint '||constraint_name
    BULK COLLECT INTO l_drop_con 
    FROM user_constraints
   WHERE table_name = 'DOC_ASSOCS'
     AND constraint_type IN ('R','P');
--
  FOR i IN 1..l_drop_con.COUNT
  LOOP
    BEGIN
      EXECUTE IMMEDIATE l_drop_con(i);
      dbms_output.put_line ('Dropped constraint '||l_drop_con(i));
    EXCEPTION
      WHEN OTHERS 
      THEN dbms_output.put_line ('Error dropping constraint '||l_drop_con(i)||' - '||SQLERRM);
    END;
  END LOOP;
--
-- Gather index drop statements
--
  SELECT 'drop index '||index_name
    BULK COLLECT INTO l_drop_index 
    FROM user_indexes
   WHERE table_name = 'DOC_ASSOCS';
--
  FOR i IN 1..l_drop_index.COUNT
  LOOP
    BEGIN
      EXECUTE IMMEDIATE l_drop_index(i);
      dbms_output.put_line ('Dropped index '||l_drop_index(i));
    EXCEPTION
      WHEN OTHERS 
      THEN dbms_output.put_line ('Error dropping index '||l_drop_index(i)||' - '||SQLERRM);
    END;
  END LOOP;
--
-- Restore index and contraint configuration 
--
  dbms_output.put_line ('Creating Primary Key on DOC_ASSOCS');
--
  BEGIN
    EXECUTE IMMEDIATE
      'ALTER TABLE DOC_ASSOCS ADD (CONSTRAINT DAS_PK PRIMARY KEY (DAS_TABLE_NAME '
                                                               ||',DAS_REC_ID '
                                                               ||',DAS_DOC_ID))';
  EXCEPTION
    WHEN OTHERS
    THEN dbms_output.put_line ('Creating Primary Key on DOC_ASSOCS error : '||SQLERRM);
  END;
--
  dbms_output.put_line ('Creating Foreign Key on DOC_ASSOCS');
--
  BEGIN
    EXECUTE IMMEDIATE 
      'ALTER TABLE DOC_ASSOCS ADD (CONSTRAINT DAS_FK_DGT FOREIGN KEY (DAS_TABLE_NAME) REFERENCES DOC_GATEWAYS (DGT_TABLE_NAME))';
  EXCEPTION
    WHEN OTHERS
    THEN dbms_output.put_line ('Creating Foreign Key on DOC_ASSOCS error : '||SQLERRM);
  END;
--
  dbms_output.put_line ('Creating Foreign Key on DOC_ASSOCS');
--
  BEGIN
    EXECUTE IMMEDIATE
      'ALTER TABLE DOC_ASSOCS ADD (CONSTRAINT DAS_FK_DOC FOREIGN KEY (DAS_DOC_ID) REFERENCES DOCS '
                                                                   ||' (DOC_ID) ON DELETE CASCADE) ';
  EXCEPTION
    WHEN OTHERS
    THEN dbms_output.put_line ('Creating Foreign Key on DOC_ASSOCS error : '||SQLERRM);
  END;
--
  dbms_output.put_line ('Creating Index DAS_IND1');
--
  BEGIN
    EXECUTE IMMEDIATE 
      'CREATE UNIQUE INDEX DAS_IND1 ON DOC_ASSOCS (DAS_DOC_ID,DAS_TABLE_NAME,DAS_REC_ID)';
  EXCEPTION
    WHEN OTHERS
    THEN dbms_output.put_line ('Creating Index DAS_IND1 : '||SQLERRM);
  END;
--
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Mapviewer - Highlighting objects
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Mapviewer - Highlighting objects
-- 
------------------------------------------------------------------
PROMPT Creating Table 'MV_HIGHLIGHT'
CREATE TABLE MV_HIGHLIGHT
 (MV_ID INTEGER NOT NULL
 ,MV_FEAT_TYPE VARCHAR2(10) NOT NULL
 ,MV_GEOMETRY SDO_GEOMETRY
 )
/

PROMPT Creating Primary Key on 'MV_HIGHLIGHT'
ALTER TABLE MV_HIGHLIGHT
 ADD (CONSTRAINT MV_HIGHLIGHT_PK PRIMARY KEY
  (MV_ID
  ,MV_FEAT_TYPE))
/

PROMPT Creating Sequence 'MV_ID_SEQ'
CREATE SEQUENCE MV_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Merge Query Split Table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Change NM_NE_ID_IN to be Number (38) on NM_MRG_SPLIT_RESULTS_TMP
-- 
------------------------------------------------------------------
alter table NM_MRG_SPLIT_RESULTS_TMP
modify NM_NE_ID_IN number(38);

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT File Transfer Queue - Tables
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- File Transfer Queue - Tables
-- 
------------------------------------------------------------------
PROMPT Creating Table 'HIG_FILE_TRANSFER_QUEUE'
CREATE TABLE HIG_FILE_TRANSFER_QUEUE
 (HFTQ_ID NUMBER(38) NOT NULL
 ,HFTQ_BATCH_NO NUMBER(38) NOT NULL
 ,HFTQ_DATE DATE NOT NULL
 ,HFTQ_INITIATED_BY VARCHAR2(30) NOT NULL
 ,HFTQ_DIRECTION VARCHAR2(10) NOT NULL
 ,HFTQ_TRANSFER_TYPE VARCHAR2(20) NOT NULL
 ,HFTQ_SOURCE VARCHAR2(2000) NOT NULL
 ,HFTQ_SOURCE_TYPE VARCHAR2(2000) NOT NULL
 ,HFTQ_SOURCE_FILENAME VARCHAR2(2000) NOT NULL
 ,HFTQ_SOURCE_COLUMN VARCHAR2(30)
 ,HFTQ_DESTINATION VARCHAR2(2000) NOT NULL
 ,HFTQ_DESTINATION_TYPE VARCHAR2(2000) NOT NULL
 ,HFTQ_DESTINATION_FILENAME VARCHAR2(2000) NOT NULL
 ,HFTQ_DESTINATION_COLUMN VARCHAR2(30)
 ,HFTQ_STATUS VARCHAR2(20) NOT NULL
 ,HFTQ_CONDITION VARCHAR2(2000)
 ,HFTQ_CONTENT BLOB
 ,HFTQ_COMMENTS VARCHAR2(2000)
 ,HFTQ_HP_PROCESS_ID NUMBER(38)
 ,HFTQ_DATE_CREATED DATE
 ,HFTQ_DATE_MODIFIED DATE
 ,HFTQ_MODIFIED_BY VARCHAR2(30)
 ,HFTQ_CREATED_BY VARCHAR2(30)
 )
/

COMMENT ON TABLE HIG_FILE_TRANSFER_QUEUE IS 'Exor File Transfer Queue.  Table to store files awaiting transfer'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_ID IS 'Primary Key. Populated from sequence ''HFTQ_ID_SEQ''.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_BATCH_NO IS 'Queue Batch No. Represents a batch of files.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DATE IS 'Queue Date. Date on which the queue was populated.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_INITIATED_BY IS 'Queue Initiator. User responsible for placing the files in the queue.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DIRECTION IS 'Queue Direction. Indicates whether the files is going IN or OUT of Exor system.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_TRANSFER_TYPE IS 'Queue Transfer Type. Indicates the transfer protocol.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_SOURCE IS 'Queue Source. Indicates the original source path of the file.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_SOURCE_TYPE IS 'Queue Source Type. Indicates the original source type of the file.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_SOURCE_FILENAME IS 'Queue Source Filename. Indicates the original source filename.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_SOURCE_COLUMN IS 'Queue Source Column. Indicates the original source column.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DESTINATION IS 'Queue File Destination Path. Indicates the destination path for the file.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DESTINATION_TYPE IS 'Queue Destination Type. Indicates the destination type for file.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DESTINATION_FILENAME IS 'Queue File Destination Filename. Indicates the destination filename.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DESTINATION_COLUMN IS 'Queue File Destination Column. Indicates the destination column.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_STATUS IS 'Queue File Transfer Status. Current status of the queued file.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_CONDITION IS 'Queue File Condition. Predicate used for table transfers.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_CONTENT IS 'Queue File Binary Content. Binary representation of the file stored in table.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_COMMENTS IS 'Queue File Process ID. Link back to a HIG Process.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DATE_CREATED IS 'Audit details.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_DATE_MODIFIED IS 'Audit details.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_MODIFIED_BY IS 'Audit details.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_QUEUE.HFTQ_CREATED_BY IS 'Audit details.'
/

PROMPT Creating Table 'HIG_FILE_TRANSFER_LOG'
CREATE TABLE HIG_FILE_TRANSFER_LOG
 (HFTL_ID NUMBER(38) NOT NULL
 ,HFTL_HFTQ_ID NUMBER(38) NOT NULL
 ,HFTL_HFTQ_BATCH_NO NUMBER(38) NOT NULL
 ,HFTL_DATE DATE NOT NULL
 ,HFTL_FILENAME VARCHAR2(2000) NOT NULL
 ,HFTL_DESTINATION_PATH VARCHAR2(2000) NOT NULL
 ,HFTL_MESSAGE VARCHAR2(2000) NOT NULL
 )
/

COMMENT ON TABLE HIG_FILE_TRANSFER_LOG IS 'Exor File Transfer Log. Log of the files queued for transfer'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_LOG.HFTL_ID IS 'Primary Key. Populated from sequence ''HFTL_ID_SEQ''.'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_LOG.HFTL_HFTQ_ID IS 'Queue ID Foreign Key. Points to the Queue Primary Key'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_LOG.HFTL_HFTQ_BATCH_NO IS 'Queue Batch No Foreign Key. Points to the Queue Batch No'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_LOG.HFTL_DATE IS 'Queue Log Date. Date of the file transfer log entry'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_LOG.HFTL_FILENAME IS 'Destination Filename. Filename being transfered'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_LOG.HFTL_DESTINATION_PATH IS 'Destination Path. Path being transfered to'
/

COMMENT ON COLUMN HIG_FILE_TRANSFER_LOG.HFTL_MESSAGE IS 'Queue Message. File transfer log'
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT File Transfer Queue - Constraints
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- File Transfer Queue - Constraints
-- 
------------------------------------------------------------------
PROMPT Creating Primary Key on 'HIG_FILE_TRANSFER_QUEUE'
ALTER TABLE HIG_FILE_TRANSFER_QUEUE
 ADD (CONSTRAINT HFTQ_PK PRIMARY KEY
  (HFTQ_ID))
/

PROMPT Creating Primary Key on 'HIG_FILE_TRANSFER_LOG'
ALTER TABLE HIG_FILE_TRANSFER_LOG
 ADD (CONSTRAINT HFTL_PK PRIMARY KEY
  (HFTL_ID))
/

PROMPT Creating Foreign Key on 'HIG_FILE_TRANSFER_LOG'
ALTER TABLE HIG_FILE_TRANSFER_LOG ADD (CONSTRAINT
 HFTL_HFTQ_FK FOREIGN KEY
  (HFTL_HFTQ_ID) REFERENCES HIG_FILE_TRANSFER_QUEUE
  (HFTQ_ID))
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT File Transfer Queue - Indexes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- File Transfer Queue - Indexes
-- 
------------------------------------------------------------------

PROMPT Creating Index 'HFTQ_BATCH_NO_STATUS_IND'
CREATE INDEX HFTQ_BATCH_NO_STATUS_IND ON HIG_FILE_TRANSFER_QUEUE
 (HFTQ_BATCH_NO
 ,HFTQ_STATUS
 ,HFTQ_TRANSFER_TYPE)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT File Transfer Queue - Sequences
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- File Transfer Queue - Sequences
-- 
------------------------------------------------------------------
PROMPT Creating Sequence 'HFTQ_BATCH_NO_SEQ'
CREATE SEQUENCE HFTQ_BATCH_NO_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'HFTQ_ID_SEQ'
CREATE SEQUENCE HFTQ_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'HFTL_ID_SEQ'
CREATE SEQUENCE HFTL_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Increase of narch_source_descr field
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 724425  Newfoundland DOT
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 109516
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Column size changed to be inline with nm_elements_all.ne_descr. This will prevent any error with large values.
-- 
------------------------------------------------------------------
ALTER TABLE nm_assets_on_route_store_head MODIFY
(
narsh_source_descr VARCHAR2(240)
)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Manager - Tables
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Document Manager - Tables - Changes and modifications
-- 
------------------------------------------------------------------
PROMPT Add DLC_LOCATION_NAME to DOC_LOCATIONS
ALTER TABLE doc_locations
ADD dlc_location_name VARCHAR2(2000)
/

PROMPT Add DLC_LOCATION_TYPE to DOC_LOCATIONS
ALTER TABLE doc_locations
ADD dlc_location_type VARCHAR2(30)
/

PROMPT Add DLC_LOCATION_TYPE and DLC_LOCATION_TYPE Values to DOC_LOCATIONS
UPDATE doc_locations
   SET dlc_location_name = NVL ( dlc_apps_pathname, dlc_pathname )
     , dlc_location_type = 'DB_SERVER';

PROMPT Set DOC_LOCATION_TYPE to Mandatory
ALTER TABLE DOC_LOCATIONS
MODIFY  dlc_location_type NOT NULL;

PROMPT Set DOC_LOCATION_NAME to Mandatory
ALTER TABLE DOC_LOCATIONS
MODIFY  dlc_location_name NOT NULL;

PROMPT Creating Table 'DOC_LOCATION_TABLES'
CREATE TABLE DOC_LOCATION_TABLES
 (DLT_ID NUMBER NOT NULL
 ,DLT_DLC_ID NUMBER NOT NULL
 ,DLT_TABLE VARCHAR2(30) NOT NULL
 ,DLT_DOC_ID_COL VARCHAR2(30) NOT NULL
 ,DLT_REVISION_COL VARCHAR2(30) NOT NULL
 ,DLT_CONTENT_COL VARCHAR2(30) NOT NULL
 ,DLT_START_DATE_COL VARCHAR2(30)
 ,DLT_END_DATE_COL VARCHAR2(30)
 ,DLT_FULL_PATH_COL VARCHAR2(30)
 ,DLT_FILENAME VARCHAR2(30)
 ,DLT_AUDIT_COL VARCHAR2(30)
 ,DLT_FILE_INFO_COL VARCHAR2(30)
 ,DLT_DATE_CREATED DATE
 ,DLT_DATE_MODIFIED DATE
 ,DLT_MODIFIED_BY VARCHAR2(30)
 ,DLT_CREATED_BY VARCHAR2(30)
 )
/

COMMENT ON TABLE DOC_LOCATION_TABLES IS 'Document Location Table metadata. Required when a Document Location is an Oracle table'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_ID IS 'Primary Key. Populated from sequence ''DLT_ID_SEQ''.'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_DLC_ID IS 'Foreign Key. Pointer to the DOC_LOCATION.DLC_ID column'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_TABLE IS 'Table Name. Refers to the table being used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_DOC_ID_COL IS 'Doc ID Column Name. Refers to the Foreign Key on the table to DOC_ID'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_REVISION_COL IS 'Revision Column Name. Refers to the Revision column on the table used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_CONTENT_COL IS 'BLOB Column Name. Refers to the BLOB column on the table used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_START_DATE_COL IS 'Start Date Column Name. Refers to the Start Date column on the table used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_END_DATE_COL IS 'End Date Column Name. Refers to the End Date column on the table used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_FULL_PATH_COL IS 'Full Path Column Name. Refers to the Full Path column on the table used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_FILENAME IS 'Filename Column Name. Refers to the Filename column on the table used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_AUDIT_COL IS 'File Info Column Name. Refers to the File Info column on the table used for the document storage'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_DATE_CREATED IS 'Audit details.'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_DATE_MODIFIED IS 'Audit details.'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_MODIFIED_BY IS 'Audit details.'
/

COMMENT ON COLUMN DOC_LOCATION_TABLES.DLT_CREATED_BY IS 'Audit details.'
/

PROMPT Creating Table 'DOC_FILE_LOCKS'
CREATE TABLE DOC_FILE_LOCKS
 (DFL_DOC_ID NUMBER NOT NULL
 ,DFL_REVISION NUMBER NOT NULL
 ,DFL_USERNAME VARCHAR2(30) NOT NULL
 ,DFL_DATE DATE NOT NULL
 ,DFL_TERMINAL VARCHAR2(2000) NOT NULL
 ,DFL_DATE_CREATED DATE
 ,DFL_DATE_MODIFIED DATE
 ,DFL_MODIFIED_BY VARCHAR2(30)
 ,DFL_CREATED_BY VARCHAR2(30)
 )
/

COMMENT ON TABLE DOC_FILE_LOCKS IS 'Document File Locks table. Stores editing locks on files associated with Documents'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_DOC_ID IS 'Primary Key Column 1. Document ID'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_REVISION IS 'Primary Key Column 2. Revision'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_USERNAME IS 'Terminal column. Logs the Terminal name of the machine the lock was taken out on'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_DATE IS 'Date column. Date the lock was taken out'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_DATE_CREATED IS 'Audit details.'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_DATE_MODIFIED IS 'Audit details.'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_MODIFIED_BY IS 'Audit details.'
/

COMMENT ON COLUMN DOC_FILE_LOCKS.DFL_CREATED_BY IS 'Audit details.'
/

PROMPT Creating Table 'DOC_FILE_TRANSFER_TEMP'
CREATE GLOBAL TEMPORARY TABLE DOC_FILE_TRANSFER_TEMP
 (DFTT_DOC_ID NUMBER NOT NULL
 ,DFTT_REVISION NUMBER NOT NULL
 ,DFTT_START_DATE DATE NOT NULL
 ,DFTT_FULL_PATH VARCHAR2(4000) NOT NULL
 ,DFTT_FILENAME VARCHAR2(4000) NOT NULL
 ,DFTT_END_DATE DATE
 ,DFTT_CONTENT BLOB
 ,DFTT_AUDIT VARCHAR2(4000)
 ,DFTT_FILE_INFO VARCHAR2(2000)
 ,DFTT_DATE_CREATED DATE
 ,DFTT_DATE_MODIFIED DATE
 ,DFTT_CREATED_BY VARCHAR2(30)
 ,DFTT_MODIFIED_BY VARCHAR2(30)
 )
 NOCACHE
/

COMMENT ON TABLE DOC_FILE_TRANSFER_TEMP IS 'Doc File Transfer table. A temporary file transfer table for database to client file transfers'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_DOC_ID IS 'Primary Key Column 1. Document ID'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_REVISION IS 'Primary Key Column 2. Revision'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_START_DATE IS 'Start Date. Column used to store Start Date of the file being loaded'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_END_DATE IS 'End Date. Column used to store End Date of the file being loaded'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_CONTENT IS 'BLOB Content. Column used to store BLOB for transfer from Client to Server'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_AUDIT IS 'Audit. Column used to audit details for debugging and error trapping'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_FILE_INFO IS 'File Info. Column used to store the File info such as size and other attributes'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_DATE_CREATED IS 'Audit details.'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_DATE_MODIFIED IS 'Audit details.'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_CREATED_BY IS 'Audit details.'
/

COMMENT ON COLUMN DOC_FILE_TRANSFER_TEMP.DFTT_MODIFIED_BY IS 'Audit details.'
/

PROMPT Creating Table 'DOC_LOCATION_ARCHIVES'
CREATE TABLE DOC_LOCATION_ARCHIVES
 (DLA_ID NUMBER(38) NOT NULL
 ,DLA_DLC_ID NUMBER(38) NOT NULL
 ,DLA_ARCHIVE_TYPE VARCHAR2(30) NOT NULL
 ,DLA_ARCHIVE_NAME VARCHAR2(2000) NOT NULL
 ,DLA_HFT_ID NUMBER(38)
 ,DLA_DLT_ID NUMBER(38)
 )
/

COMMENT ON TABLE DOC_LOCATION_ARCHIVES IS 'Document Location Archives, details of archive areas used for Document Locations'
/

COMMENT ON COLUMN DOC_LOCATION_ARCHIVES.DLA_ID IS 'Primary Key column, populated from sequence DLA_ID_SEQ'
/

COMMENT ON COLUMN DOC_LOCATION_ARCHIVES.DLA_DLC_ID IS 'Foreign Key column, pointer to DOC_LOCATIONS primary key'
/

COMMENT ON COLUMN DOC_LOCATION_ARCHIVES.DLA_ARCHIVE_TYPE IS 'Archive Type, indicates the type of archive being used.'
/

COMMENT ON COLUMN DOC_LOCATION_ARCHIVES.DLA_ARCHIVE_NAME IS 'Archive Name, a description of the archive being used'
/

COMMENT ON COLUMN DOC_LOCATION_ARCHIVES.DLA_HFT_ID IS 'Foreign Key column, pointer to HIG_FTP_TYPES Primary Key'
/

COMMENT ON COLUMN DOC_LOCATION_ARCHIVES.DLA_DLT_ID IS 'Foreign Key column, pointer to DOC_LOCATIONS_TABLES Primary Key'
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Manager - Constraints
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Document Manager - Constraints
-- 
------------------------------------------------------------------
PROMPT Creating Primary Key on 'DOC_LOCATION_TABLES'
ALTER TABLE DOC_LOCATION_TABLES
 ADD (CONSTRAINT DOC_LOCATION_TABLES_PK PRIMARY KEY
  (DLT_ID))
/

PROMPT Creating Unique Key on 'DOC_LOCATION_TABLES'
ALTER TABLE DOC_LOCATION_TABLES
 ADD (CONSTRAINT DOC_LOCATION_TABLES_UK UNIQUE
  (DLT_DLC_ID
  ,DLT_TABLE))
/

PROMPT Creating Foreign Key on 'DOC_LOCATION_TABLES'
ALTER TABLE DOC_LOCATION_TABLES ADD (CONSTRAINT
 DLT_DLC_ID_DLC_ID_FK FOREIGN KEY
  (DLT_DLC_ID) REFERENCES DOC_LOCATIONS
  (DLC_ID))
/

PROMPT Creating Primary Key on 'DOC_FILE_LOCKS'
ALTER TABLE DOC_FILE_LOCKS
 ADD (CONSTRAINT DFL_PK PRIMARY KEY
  (DFL_DOC_ID
  ,DFL_REVISION))
/

PROMPT Creating Primary Key on 'DOC_FILE_TRANSFER_TEMP'
ALTER TABLE DOC_FILE_TRANSFER_TEMP
 ADD (CONSTRAINT DFTT_PK PRIMARY KEY
  (DFTT_DOC_ID
  ,DFTT_REVISION))
/

PROMPT Creating Primary Key on 'DOC_LOCATION_ARCHIVES'
ALTER TABLE DOC_LOCATION_ARCHIVES
 ADD (CONSTRAINT DLA_PK PRIMARY KEY
  (DLA_ID))
/

PROMPT Creating Foreign Key on 'DOC_LOCATION_ARCHIVES'
ALTER TABLE DOC_LOCATION_ARCHIVES ADD (CONSTRAINT
 DLA_DLC_FK FOREIGN KEY
  (DLA_DLC_ID) REFERENCES DOC_LOCATIONS
  (DLC_ID))
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Manager - Indexes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Document Manager - Indexes
-- 
------------------------------------------------------------------
PROMPT Creating Index 'DLA_DLC_ID_IND'
CREATE INDEX DLA_DLC_ID_IND ON DOC_LOCATION_ARCHIVES
 (DLA_DLC_ID)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Manager - Sequences
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Document Manager - Sequences
-- 
------------------------------------------------------------------
PROMPT Creating Sequence 'DLT_ID_SEQ'
CREATE SEQUENCE DLT_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'DLA_ID_SEQ'
CREATE SEQUENCE DLA_ID_SEQ
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Sequences
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
CREATE SEQUENCE HPT_PROCESS_TYPE_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/
CREATE SEQUENCE HSFR_FREQUENCY_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/
CREATE SEQUENCE HFL_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/
CREATE SEQUENCE HP_PROCESS_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/
CREATE SEQUENCE HPTF_FILE_TYPE_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/
CREATE SEQUENCE HPF_FILE_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Tables
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
CREATE TABLE HIG_PROCESSES
 (HP_PROCESS_ID NUMBER(38) NOT NULL
 ,HP_PROCESS_TYPE_ID NUMBER(38) NOT NULL
 ,HP_INITIATED_BY_USERNAME VARCHAR2(30) NOT NULL
 ,HP_INITIATED_DATE DATE NOT NULL
 ,HP_INITIATORS_REF VARCHAR2(50)
 ,HP_JOB_NAME VARCHAR2(65) NOT NULL
 ,HP_FREQUENCY_ID NUMBER(38) DEFAULT -1 NOT NULL
 ,HP_WHAT_TO_CALL VARCHAR2(4000) NOT NULL
 ,HP_SUCCESS_FLAG VARCHAR2(3) DEFAULT 'TBD' NOT NULL
 ,HP_JOB_OWNER VARCHAR2(30) DEFAULT USER NOT NULL
 )
/





COMMENT ON TABLE HIG_PROCESSES IS 'Exor Process Framework table.  The instantiation of a process of a given process type'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_PROCESS_ID IS 'Primary Key.
Populated from sequence ''HP_PROCESS_ID_SEQ''.'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_PROCESS_TYPE_ID IS 'Process Type identifier.
Foreign key to HIG_PROCESS_TYPES.'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_INITIATED_BY_USERNAME IS 'Username of the user that submitted the process.'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_INITIATED_DATE IS 'Date and time of submission'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_INITIATORS_REF IS 'Initiators optional reference - so they can mark a process with a recognizable identifier.'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_JOB_NAME IS 'Name of the job which is created by dbms_scheduler execute the given process.
'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_FREQUENCY_ID IS 'Frequency at which this process is to repeat.  The default value of -1 signifies a non-repeating process.'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_WHAT_TO_CALL IS 'The pl/sql block to execute.
De-normalized from HIG_PROCESS_TYPES.'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_SUCCESS_FLAG IS 'Flag to denote the success of the latest execution of the process.'
/

COMMENT ON COLUMN HIG_PROCESSES.HP_JOB_OWNER IS 'The schema against which the scheduled job for this process will be executed.'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_FILES
 (HPF_FILE_ID NUMBER(38) NOT NULL
 ,HPF_PROCESS_ID NUMBER(38) NOT NULL
 ,HPF_JOB_RUN_SEQ NUMBER(38)
 ,HPF_FILE_TYPE_ID NUMBER(38) NOT NULL
 ,HPF_FILENAME VARCHAR2(255) NOT NULL
 ,HPF_DESTINATION VARCHAR2(500)
 ,HPF_DESTINATION_TYPE VARCHAR2(20)
 ,HPF_INPUT_OR_OUTPUT VARCHAR2(1) NOT NULL
 )
/

COMMENT ON TABLE HIG_PROCESS_FILES IS 'Exor Process Framework table.  This table stores the list input/output files associated with a process.'
/

COMMENT ON COLUMN HIG_PROCESS_FILES.HPF_FILE_ID IS 'Primary Key.
Populated from sequence ''HPF_FILE_ID_SEQ''.
'
/

COMMENT ON COLUMN HIG_PROCESS_FILES.HPF_PROCESS_ID IS 'Process Identifier.
Foreign Key to HIG_PROCESSES'
/

COMMENT ON COLUMN HIG_PROCESS_FILES.HPF_FILE_TYPE_ID IS 'File Type Identifier.
Foreign Key to HIG_PROCESS_TYPE_FILES'
/

COMMENT ON COLUMN HIG_PROCESS_FILES.HPF_FILENAME IS 'Filename.'
/

COMMENT ON COLUMN HIG_PROCESS_FILES.HPF_DESTINATION IS 'Destination.
Enforced via a check constraint.
'
/

COMMENT ON COLUMN HIG_PROCESS_FILES.HPF_DESTINATION_TYPE IS 'Destination Type.
Enforced via a check constraint.
'
/

COMMENT ON COLUMN HIG_PROCESS_FILES.HPF_INPUT_OR_OUTPUT IS 'Flag to denote whether this is an Input or Output file.
'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_FILE_BLOBS
 (HPFB_FILE_ID NUMBER(38) NOT NULL
 ,HPFB_CONTENT BLOB
 )
/

COMMENT ON TABLE HIG_PROCESS_FILE_BLOBS IS 'Exor Process Framework table.  Stores the binary content of process files (if the hpf_destination_type was ''DATABASE_TABLE'')'
/

COMMENT ON COLUMN HIG_PROCESS_FILE_BLOBS.HPFB_FILE_ID IS 'Primary Key.
Also foreign key to HIG_PROCESS_FILES.'
/

COMMENT ON COLUMN HIG_PROCESS_FILE_BLOBS.HPFB_CONTENT IS 'Binary content of the file.'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_JOB_RUNS
 (HPJR_PROCESS_ID NUMBER(38) NOT NULL
 ,HPJR_JOB_RUN_SEQ NUMBER(38) NOT NULL
 ,HPJR_START TIMESTAMP(6) WITH TIME ZONE NOT NULL
 ,HPJR_END TIMESTAMP(6) WITH TIME ZONE
 ,HPJR_SUCCESS_FLAG VARCHAR2(3) DEFAULT 'TBD' NOT NULL
 ,HPJR_ADDITIONAL_INFO VARCHAR2(500)
 ,HPJR_INTERNAL_REFERENCE VARCHAR2(500)
 )
/

COMMENT ON TABLE HIG_PROCESS_JOB_RUNS IS 'Exor Process Framework table.  Records details of the execution of a given process'
/

COMMENT ON COLUMN HIG_PROCESS_JOB_RUNS.HPJR_PROCESS_ID IS 'Process Identifier.
Foreign Key to HIG_PROCESSES.'
/

COMMENT ON COLUMN HIG_PROCESS_JOB_RUNS.HPJR_JOB_RUN_SEQ IS 'The execution iteration of the given process.'
/

COMMENT ON COLUMN HIG_PROCESS_JOB_RUNS.HPJR_START IS 'Start Date and Time.'
/

COMMENT ON COLUMN HIG_PROCESS_JOB_RUNS.HPJR_END IS 'End Date and Time.'
/

COMMENT ON COLUMN HIG_PROCESS_JOB_RUNS.HPJR_SUCCESS_FLAG IS 'Was the execution successful?'
/

COMMENT ON COLUMN HIG_PROCESS_JOB_RUNS.HPJR_ADDITIONAL_INFO IS 'Additional information relating to the execution e.g. a fatal error message when unsuccessful.'
/

COMMENT ON COLUMN HIG_PROCESS_JOB_RUNS.HPJR_INTERNAL_REFERENCE IS 'A reference to tie the execution of this process to a bespoke data structure for this type of process.'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_LOG
 (HPL_PROCESS_ID NUMBER(38) NOT NULL
 ,HPL_JOB_RUN_SEQ NUMBER(38) NOT NULL
 ,HPL_LOG_SEQ NUMBER(38) NOT NULL
 ,HPL_TIMESTAMP TIMESTAMP(6) WITH TIME ZONE DEFAULT systimestamp NOT NULL
 ,HPL_MESSAGE_TYPE VARCHAR2(1) DEFAULT 'I' NOT NULL
 ,HPL_SUMMARY_FLAG VARCHAR2(1) DEFAULT 'Y' NOT NULL
 ,HPL_MESSAGE VARCHAR2(500) NOT NULL
 )
/

COMMENT ON TABLE HIG_PROCESS_LOG IS 'Exor Process Framework table.  A logging table to store messages associated with the execution of a given process.'
/

COMMENT ON COLUMN HIG_PROCESS_LOG.HPL_PROCESS_ID IS 'Process Identifier.
Foreign Key to HIG_PROCESSES.'
/

COMMENT ON COLUMN HIG_PROCESS_LOG.HPL_JOB_RUN_SEQ IS 'Process Job Run Sequence Identifier.
Foreign Key to HIG_PROCESSES_JOB_RUNS.'
/

COMMENT ON COLUMN HIG_PROCESS_LOG.HPL_LOG_SEQ IS 'Sequence within this process job run of this log entry.'
/

COMMENT ON COLUMN HIG_PROCESS_LOG.HPL_TIMESTAMP IS 'Timestamp.'
/

COMMENT ON COLUMN HIG_PROCESS_LOG.HPL_MESSAGE_TYPE IS 'Message Type
Enforced by a check constraint.'
/

COMMENT ON COLUMN HIG_PROCESS_LOG.HPL_SUMMARY_FLAG IS '''Y'' or ''N'' flag to denote whether or not this message is a summary message.'
/

COMMENT ON COLUMN HIG_PROCESS_LOG.HPL_MESSAGE IS 'Message text.'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_PARAMS
 (HPP_PROCESS_ID NUMBER(38) NOT NULL
 ,HPP_SEQ NUMBER(38) NOT NULL
 ,HPP_PARAM_NAME VARCHAR2(30) NOT NULL
 ,HPP_PARAM_VALUE VARCHAR2(4000)
 )
/

COMMENT ON TABLE HIG_PROCESS_PARAMS IS 'Exor Process Framework table.  Parameter values are stored here and can be read by the code which executes a given process.'
/

COMMENT ON COLUMN HIG_PROCESS_PARAMS.HPP_PROCESS_ID IS 'Process Identifier.
Foreign Key to HIG_PROCESSES.'
/

COMMENT ON COLUMN HIG_PROCESS_PARAMS.HPP_SEQ IS 'Parameter order within process.'
/

COMMENT ON COLUMN HIG_PROCESS_PARAMS.HPP_PARAM_NAME IS 'Parameter Name.'
/

COMMENT ON COLUMN HIG_PROCESS_PARAMS.HPP_PARAM_VALUE IS 'Character value.'
/
--
---------------------------------------------------------
--
CREATE GLOBAL TEMPORARY TABLE HIG_PROCESS_TEMP_LOG
 (LOG_BLOB BLOB
 )
/

COMMENT ON TABLE HIG_PROCESS_TEMP_LOG IS 'Exor Process Framework table.  Used in HIG2540 to write the log records to a blob file which can then be extracted.'
/
--
---------------------------------------------------------
--
PROMPT Creating Table 'HIG_PROCESS_TYPES'
CREATE TABLE HIG_PROCESS_TYPES
 (HPT_PROCESS_TYPE_ID NUMBER(38) NOT NULL
 ,HPT_NAME VARCHAR2(50) NOT NULL
 ,HPT_DESCR VARCHAR2(500) NOT NULL
 ,HPT_WHAT_TO_CALL VARCHAR2(2000) NOT NULL
 ,HPT_INITIATION_MODULE VARCHAR2(30)
 ,HPT_INTERNAL_MODULE VARCHAR2(30)
 ,HPT_INTERNAL_MODULE_PARAM VARCHAR2(30)
 ,HPT_PROCESS_LIMIT NUMBER(38)
 ,HPT_RESTARTABLE VARCHAR2(1) DEFAULT 'Y' NOT NULL
 ,HPT_SEE_IN_HIG2510 VARCHAR2(1) DEFAULT 'Y' NOT NULL
 ,HPT_AREA_TYPE VARCHAR2(20)
 ,HPT_POLLING_ENABLED VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,HPT_POLLING_FTP_TYPE_ID NUMBER(38)
 )
/
COMMENT ON TABLE HIG_PROCESS_TYPES IS 'Exor Process Framework table. Defines each type of automated process for which jobs can be scheduled and executed.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_PROCESS_LIMIT IS 'The maximum number of processes of this type which can be scheduled to run running at any given time.  This is checked when submitting a process or enabling an existing process.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_RESTARTABLE IS '''Value is used when scheduling a process.  It indicates to the Oracle scheduling engine whether or not a process of this type can re-start following a database re-start.  If set to ''''N'''', processes of this type will be left as `Disabled¿ following a re-start.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_PROCESS_TYPE_ID IS 'Primary Key.  When a negative value it indicates that the process has been shipped as a standard process and is therefore marked as Protected in the Maintain Process Types module.  Otherwise when records are created the value of this column should be taken from sequence HPT_PROCESS_TYPE_ID_SEQ.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_NAME IS 'Process type name.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_DESCR IS 'Process type description.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_WHAT_TO_CALL IS 'The pl/sql code to call when a process of this type is executed.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_INITIATION_MODULE IS 'The HIG_MODULE that can be used to initiate the submission of a process of this type.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_INTERNAL_MODULE IS 'The HIG_MODULE that is used to manage process type specific data that is outside of the standard process framework.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_INTERNAL_MODULE_PARAM IS 'The name of the forms parameter accepted by the forms module named in HPT_INTERNAL_MODULE.'
/
COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_SEE_IN_HIG2510 IS 'Is this process visible in the Process Submission module?'
/
COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_AREA_TYPE IS 'Foreign key to the area type that can be used to parameterise the process'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_POLLING_ENABLED IS 'Flag to denote whether this process type can be initiated by polling of FTP folder(s)'
/

COMMENT ON COLUMN HIG_PROCESS_TYPES.HPT_POLLING_FTP_TYPE_ID IS 'Foreign key to the polling ftp type'
/


ALTER TABLE HIG_PROCESS_TYPES ADD 
CONSTRAINT HPT_HTF_FK
 FOREIGN KEY (HPT_POLLING_FTP_TYPE_ID)
 REFERENCES HIG_FTP_TYPES (HFT_ID)
 ON DELETE SET NULL
/

create index hpt_htf_fk_ind on hig_process_types(HPT_POLLING_FTP_TYPE_ID)
/

--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_TYPE_FILES
 (HPTF_FILE_TYPE_ID NUMBER(38) NOT NULL
 ,HPTF_NAME VARCHAR2(50) NOT NULL
 ,HPTF_PROCESS_TYPE_ID NUMBER(38) NOT NULL
 ,HPTF_INPUT VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,HPTF_OUTPUT VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,HPTF_INPUT_DESTINATION VARCHAR2(500)
 ,HPTF_INPUT_DESTINATION_TYPE VARCHAR2(20)
 ,HPTF_MIN_INPUT_FILES INTEGER
 ,HPTF_MAX_INPUT_FILES INTEGER
 ,HPTF_OUTPUT_DESTINATION VARCHAR2(500)
 ,HPTF_OUTPUT_DESTINATION_TYPE VARCHAR2(20)
 )
/

COMMENT ON TABLE HIG_PROCESS_TYPE_FILES IS 'Exor Process Framework table.  Defines the types of files attributed to a process.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_FILE_TYPE_ID IS 'Primary Key.
The value of this column should be taken from sequence ''HPTF_FILE_TYPE_ID_SEQ''.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_NAME IS 'File type name.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_PROCESS_TYPE_ID IS 'The ID of the process type to which this file type is associated.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_INPUT IS 'Flag to denote whether this file type is an input file which is read by a process of this type.
Allowable values are policed by a check constraint.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_OUTPUT IS 'Flag to denote whether this file type is an output file produced as a result of executing a process of this type.
Allowable values are policed by a check constraint.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_INPUT_DESTINATION IS 'Location where input file of this type will reside.
Only applicable when HPTF_INPUT = ''Y''.
A check constraint is used ensure the value entered into this column ends with a ''\'' or ''/'' delimiter where appropriate.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_INPUT_DESTINATION_TYPE IS 'Input destination type for this file type.
Allowable values are policed by a check constraint.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_MIN_INPUT_FILES IS 'The minimum number of input files of this file type for a process of this type.
'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_MAX_INPUT_FILES IS 'The maximum number of input files of this file type for a process of this type.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_OUTPUT_DESTINATION IS 'Location where an output file of this type will reside.
Only applicable when HPTF_OUTPUT = ''Y''.
A check constraint is used ensure the value entered into this column ends with a ''\'' or ''/'' delimiter where appropriate.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILES.HPTF_OUTPUT_DESTINATION_TYPE IS 'Output destination type for this file type.
Allowable values are policed by a check constraint.'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_TYPE_FILE_EXT
 (HPTE_FILE_TYPE_ID NUMBER(38) NOT NULL
 ,HPTE_EXTENSION VARCHAR2(20) NOT NULL
 )
/

COMMENT ON TABLE HIG_PROCESS_TYPE_FILE_EXT IS 'Exor Process Framework table.  Defines the file extensions attributed to a given file type.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILE_EXT.HPTE_FILE_TYPE_ID IS 'File Type Identifier.
Foreign Key to HIG_PROCESS_TYPE_FILES.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FILE_EXT.HPTE_EXTENSION IS 'Extension e.g csv (the *. is not required)'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_TYPE_FREQUENCIES
 (HPFR_PROCESS_TYPE_ID NUMBER(38) NOT NULL
 ,HPFR_FREQUENCY_ID NUMBER(38) NOT NULL
 ,HPFR_SEQ NUMBER(38)
 )
/

COMMENT ON TABLE HIG_PROCESS_TYPE_FREQUENCIES IS 'Exor Process Framework table.  Defines the sub-set of frequencies that can be used against a given process type.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FREQUENCIES.HPFR_PROCESS_TYPE_ID IS 'Process type identifier.
Foreign Key to HIG_PROCESS_TYPES.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FREQUENCIES.HPFR_FREQUENCY_ID IS 'Frequency identifier.
Foreign Key to HIG_SCHEDULING_FREQUENCIES.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_FREQUENCIES.HPFR_SEQ IS 'The display sequence of this frequency i.e. the order in which it is listed against the process type in the ''Process Submission'' module.'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_PROCESS_TYPE_ROLES
 (HPTR_PROCESS_TYPE_ID NUMBER(38) NOT NULL
 ,HPTR_ROLE VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_PROCESS_TYPE_ROLES IS 'Exor Process Framework table.  Defines relevant process type roles.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_ROLES.HPTR_PROCESS_TYPE_ID IS 'Identifies the process type. Foreign key to HIG_PROCESS_TYPES.'
/

COMMENT ON COLUMN HIG_PROCESS_TYPE_ROLES.HPTR_ROLE IS 'Identifies the role.
Foreign key to HIG_ROLES.'
/
--
---------------------------------------------------------
--
CREATE TABLE HIG_SCHEDULING_FREQUENCIES
 (HSFR_FREQUENCY_ID NUMBER(38) NOT NULL
 ,HSFR_MEANING VARCHAR2(100) NOT NULL
 ,HSFR_FREQUENCY VARCHAR2(200)
 ,HSFR_INTERVAL_IN_MINS NUMBER(38)
 )
/

COMMENT ON TABLE HIG_SCHEDULING_FREQUENCIES IS 'Exor Process Framework table.  Defines the set of frequencies that can be used for scheduling processes.'
/

COMMENT ON COLUMN HIG_SCHEDULING_FREQUENCIES.HSFR_FREQUENCY_ID IS 'Primary Key.
When a negative value it indicates that the frequency has been shipped as a standard frequency and is therefore marked as ''Protected'' in the Maintain Frequencies module.
Otherwise when records are created the value of this column should be taken from sequence ''HSFR_FREQUENCY_ID_SEQ''.'
/

COMMENT ON COLUMN HIG_SCHEDULING_FREQUENCIES.HSFR_MEANING IS 'A description for the frequency.'
/

COMMENT ON COLUMN HIG_SCHEDULING_FREQUENCIES.HSFR_FREQUENCY IS 'The repeat interval string that is recognizable by dbms_scheduler.'
/

COMMENT ON COLUMN HIG_SCHEDULING_FREQUENCIES.HSFR_INTERVAL_IN_MINS IS 'The frequency as an interval in minutes (where the frequency resolves to an interval in minutes).'
/
--
--------------------------------------------------------------------------
--
CREATE GLOBAL TEMPORARY TABLE HIG2510_FILE_LIST
 (HFL_ID NUMBER NOT NULL
 ,HFL_FILENAME VARCHAR2(2000) NOT NULL
 ,HFL_CONTENT BLOB
 ,HFL_FILE_TYPE_ID NUMBER(38)
 ,HFL_DESTINATION_TYPE VARCHAR2(20)
 ,HFL_DESTINATION VARCHAR2(500)
 ,HFL_READ_FLAG VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,HFL_ERROR_FLAG VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,HFL_ERROR_TEXT VARCHAR2(500)
 )
 ON COMMIT PRESERVE ROWS
/

COMMENT ON TABLE HIG2510_FILE_LIST IS 'Exor Process Framework table.
Global temporary table.
Used in the ''Process Submission'' module where files are selected to be included in a batch and then read into this holding table which stores the file details and then writes the files out to the correct location.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_ID IS 'Primary Key.
Populated from sequence ''HFL_ID_SEQ''.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_FILENAME IS 'Filename.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_CONTENT IS 'Binary file contents.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_FILE_TYPE_ID IS 'File Type Identifier.
Foreign Key to HIG_PROCESS_TYPE_FILES.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_DESTINATION_TYPE IS 'Destination Type - denormalized from HIG_PROCESS_TYPE_FILES.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_DESTINATION IS 'Destination - denormalized from HIG_PROCESS_TYPE_FILES.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_READ_FLAG IS 'Flag to denote whether or not the file has been read and moved to the destination.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_ERROR_FLAG IS 'Flag to denote whether an error was encountered when reading the file and moving it to its destination.'
/

COMMENT ON COLUMN HIG2510_FILE_LIST.HFL_ERROR_TEXT IS 'Error text which was raised when an error was encountered reading and moving the file to its destination.'
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Constraints
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
ALTER TABLE HIG_PROCESSES
 ADD (CONSTRAINT HP_PK PRIMARY KEY 
  (HP_PROCESS_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILES
 ADD (CONSTRAINT HPF_PK PRIMARY KEY 
  (HPF_FILE_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILE_BLOBS
 ADD (CONSTRAINT HPFB_PK PRIMARY KEY 
  (HPFB_FILE_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_JOB_RUNS
 ADD (CONSTRAINT HPJR_PK PRIMARY KEY 
  (HPJR_PROCESS_ID
  ,HPJR_JOB_RUN_SEQ))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_LOG
 ADD (CONSTRAINT HPL_PK PRIMARY KEY 
  (HPL_PROCESS_ID
  ,HPL_JOB_RUN_SEQ
  ,HPL_LOG_SEQ))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_PARAMS
 ADD (CONSTRAINT HPP_PK PRIMARY KEY 
  (HPP_PROCESS_ID
  ,HPP_SEQ))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPES
 ADD (CONSTRAINT HPT_PK PRIMARY KEY 
  (HPT_PROCESS_TYPE_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_PK PRIMARY KEY 
  (HPTF_FILE_TYPE_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILE_EXT
 ADD (CONSTRAINT HPTE_PK PRIMARY KEY 
  (HPTE_FILE_TYPE_ID
  ,HPTE_EXTENSION))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FREQUENCIES
 ADD (CONSTRAINT HPFR_PK PRIMARY KEY 
  (HPFR_PROCESS_TYPE_ID
  ,HPFR_FREQUENCY_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_ROLES
 ADD (CONSTRAINT HPTR_PK PRIMARY KEY 
  (HPTR_PROCESS_TYPE_ID
  ,HPTR_ROLE))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_SCHEDULING_FREQUENCIES
 ADD (CONSTRAINT HSFR_PK PRIMARY KEY 
  (HSFR_FREQUENCY_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPES
 ADD (CONSTRAINT HPT_NAME_UK UNIQUE 
  (HPT_NAME))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_UK1 UNIQUE 
  (HPTF_PROCESS_TYPE_ID
  ,HPTF_NAME))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESSES
 ADD (CONSTRAINT HP_SUCCESS_FLAG_CHK CHECK (hp_success_flag in ('Y','N','TBD')))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILES
 ADD (CONSTRAINT HPF_DESTINATION_CHK CHECK ((hpf_destination_type in ('DATABASE_SERVER','APP_SERVER') 
AND SUBSTR(hpf_destination,-1,1) IN ('\','/') ) 
OR (hpf_destination_type in ('ORACLE_DIRECTORY','DATABASE_TABLE') )))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILES
 ADD (CONSTRAINT HPF_DESTINATION_TYPE_CHK CHECK (hpf_destination_type 
in ('DATABASE_SERVER','ORACLE_DIRECTORY','APP_SERVER','DATABASE_TABLE'
)))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILES
 ADD (CONSTRAINT HPF_INPUT_OR_OUTPUT_CHK CHECK (hpf_input_or_output in ('I','O')))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_JOB_RUNS
 ADD (CONSTRAINT HPJR_SUCCESS_FLAG_CHK CHECK (hpjr_success_flag in ('Y','N','TBD')))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_LOG
 ADD (CONSTRAINT HPL_MESSAGE_TYPE_CHK CHECK (hpl_message_type IN ('I' ,'E' ,'W' )))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_LOG
 ADD (CONSTRAINT HPL_SUMMARY_FLAG_CHK CHECK (hpl_summary_flag IN ('Y' ,'N' )))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPES
 ADD (CONSTRAINT HPT_INTERNAL_CHK CHECK ((HPT_INTERNAL_MODULE IS NOT NULL 
AND HPT_INTERNAL_MODULE_PARAM IS NOT NULL) 
OR (HPT_INTERNAL_MODULE IS NULL 
AND HPT_INTERNAL_MODULE_PARAM IS NULL)))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPES
 ADD (CONSTRAINT HPT_RESTARTABLE_CHK CHECK (hpt_restartable in ('Y','N')))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPES
 ADD (CONSTRAINT HPT_SEE_IN_HIG2510_CHK CHECK (HPT_SEE_IN_HIG2510 in ('Y','N')))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_INPUT_CHK CHECK ((hptf_input = 'N' 
and hptf_input_destination is null 
and hptf_input_destination_type IS NULL 
AND hptf_min_input_files IS NULL 
AND hptf_max_input_files IS NULL ) OR (hptf_input = 'Y')))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_INPUT_DESTINATION_CHK CHECK ((hptf_input_destination_type in ('DATABASE_SERVER','APP_SERVER') 
AND SUBSTR(hptf_input_destination,-1,1) IN ('\','/') ) 
OR (hptf_input_destination_type 
in ('ORACLE_DIRECTORY','DATABASE_TABLE') )))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_INPUT_DEST_TYPE_CHK CHECK (hptf_input_destination_type 
in ('DATABASE_SERVER','ORACLE_DIRECTORY','APP_SERVER','DATABASE_TABLE'
)))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_OUTPUT_CHK CHECK ((hptf_output = 'N' 
and hptf_output_destination is null 
and hptf_output_destination_type IS NULL) OR (hptf_output = 'Y')))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_OUTPUT_DESTINATION_CHK CHECK ((hptf_output_destination_type in ('DATABASE_SERVER','APP_SERVER') 
AND SUBSTR(hptf_output_destination,-1,1) IN ('\','/') ) 
OR (hptf_output_destination_type 
in ('ORACLE_DIRECTORY','DATABASE_TABLE') )))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES
 ADD (CONSTRAINT HPTF_OUTPUT_DEST_TYPE_CHK CHECK (hptf_output_destination_type 
in ('DATABASE_SERVER','ORACLE_DIRECTORY','APP_SERVER','DATABASE_TABLE'
)))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILE_EXT
 ADD (CONSTRAINT HPTE_EXTENSION_CHARACTER_CHK CHECK (INSTR (hpte_extension,'%') + INSTR(hpte_extension,'*'
) + INSTR(hpte_extension,'.') = 0))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESSES ADD (CONSTRAINT
 HP_HPT_FK FOREIGN KEY 
  (HP_PROCESS_TYPE_ID) REFERENCES HIG_PROCESS_TYPES
  (HPT_PROCESS_TYPE_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESSES ADD (CONSTRAINT
 HP_HSFR_FK FOREIGN KEY 
  (HP_FREQUENCY_ID) REFERENCES HIG_SCHEDULING_FREQUENCIES
  (HSFR_FREQUENCY_ID))
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILES ADD (CONSTRAINT
 HPF_HPFT_FK FOREIGN KEY 
  (HPF_FILE_TYPE_ID) REFERENCES HIG_PROCESS_TYPE_FILES
  (HPTF_FILE_TYPE_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILES ADD (CONSTRAINT
 HPF_HPJR_FK FOREIGN KEY 
  (HPF_PROCESS_ID
  ,HPF_JOB_RUN_SEQ) REFERENCES HIG_PROCESS_JOB_RUNS
  (HPJR_PROCESS_ID
  ,HPJR_JOB_RUN_SEQ) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILES ADD (CONSTRAINT
 HPF_HPP_FK FOREIGN KEY 
  (HPF_PROCESS_ID) REFERENCES HIG_PROCESSES
  (HP_PROCESS_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_FILE_BLOBS ADD (CONSTRAINT
 HPFB_HPF_FK FOREIGN KEY 
  (HPFB_FILE_ID) REFERENCES HIG_PROCESS_FILES
  (HPF_FILE_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_JOB_RUNS ADD (CONSTRAINT
 HPJR_HP_FK FOREIGN KEY 
  (HPJR_PROCESS_ID) REFERENCES HIG_PROCESSES
  (HP_PROCESS_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_LOG ADD (CONSTRAINT
 HPL_HPJR_FK FOREIGN KEY 
  (HPL_PROCESS_ID
  ,HPL_JOB_RUN_SEQ) REFERENCES HIG_PROCESS_JOB_RUNS
  (HPJR_PROCESS_ID
  ,HPJR_JOB_RUN_SEQ) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_PARAMS ADD (CONSTRAINT
 HPP_HP_FK FOREIGN KEY 
  (HPP_PROCESS_ID) REFERENCES HIG_PROCESSES
  (HP_PROCESS_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPES ADD (CONSTRAINT
 HPT_HMO_FK1 FOREIGN KEY 
  (HPT_INITIATION_MODULE) REFERENCES HIG_MODULES
  (HMO_MODULE) ON DELETE SET NULL)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPES ADD (CONSTRAINT
 HPT_HMO_FK2 FOREIGN KEY 
  (HPT_INTERNAL_MODULE) REFERENCES HIG_MODULES
  (HMO_MODULE) ON DELETE SET NULL)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILES ADD (CONSTRAINT
 HPTF_HPT_FK FOREIGN KEY 
  (HPTF_PROCESS_TYPE_ID) REFERENCES HIG_PROCESS_TYPES
  (HPT_PROCESS_TYPE_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FILE_EXT ADD (CONSTRAINT
 HTPE_HPTF_FK FOREIGN KEY 
  (HPTE_FILE_TYPE_ID) REFERENCES HIG_PROCESS_TYPE_FILES
  (HPTF_FILE_TYPE_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FREQUENCIES ADD (CONSTRAINT
 HPFR_HPT_FK FOREIGN KEY 
  (HPFR_PROCESS_TYPE_ID) REFERENCES HIG_PROCESS_TYPES
  (HPT_PROCESS_TYPE_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_FREQUENCIES ADD (CONSTRAINT
 HPFR_HSFR_FK FOREIGN KEY 
  (HPFR_FREQUENCY_ID) REFERENCES HIG_SCHEDULING_FREQUENCIES
  (HSFR_FREQUENCY_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_ROLES ADD (CONSTRAINT
 HPTR_HPT_FK FOREIGN KEY 
  (HPTR_PROCESS_TYPE_ID) REFERENCES HIG_PROCESS_TYPES
  (HPT_PROCESS_TYPE_ID) ON DELETE CASCADE)
/
--
--------------------------------------------------------------------------
--
ALTER TABLE HIG_PROCESS_TYPE_ROLES ADD (CONSTRAINT
 HPTR_HRO_FK FOREIGN KEY 
  (HPTR_ROLE) REFERENCES HIG_ROLES
  (HRO_ROLE) ON DELETE CASCADE)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Indexes
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108982
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
CREATE INDEX HP_HPT_FK_IND ON HIG_PROCESSES
 (HP_PROCESS_TYPE_ID)
/
--
--------------------------------------------------------------------------
--
CREATE INDEX HP_HSFR_FK_IND ON HIG_PROCESSES
 (HP_FREQUENCY_ID)
/
--
--------------------------------------------------------------------------
--
CREATE INDEX HPF_HPJR_FK_IND ON HIG_PROCESS_FILES
 (HPF_PROCESS_ID
 ,HPF_JOB_RUN_SEQ)
/
--
--------------------------------------------------------------------------
--
CREATE INDEX HPF_HPTF_FK_IND ON HIG_PROCESS_FILES
 (HPF_FILE_TYPE_ID)
/
--
--------------------------------------------------------------------------
--
CREATE INDEX HPF_HP_FK_IND ON HIG_PROCESS_FILES
 (HPF_PROCESS_ID)
/
--
--------------------------------------------------------------------------
--
CREATE INDEX HPFR_HSFR_FK_IND ON HIG_PROCESS_TYPE_FREQUENCIES
 (HPFR_FREQUENCY_ID)
/
--
--------------------------------------------------------------------------
--
CREATE INDEX HTPR_HRO_FK_IND ON HIG_PROCESS_TYPE_ROLES
 (HPTR_ROLE)
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Framework - Other
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support process framework
-- 
------------------------------------------------------------------
CREATE TABLE HIG_PROCESS_AREAS
(
  HPA_AREA_TYPE                VARCHAR2(20) NOT NULL,
  HPA_DESCRIPTION              VARCHAR2(100) NOT NULL,
  HPA_TABLE                    VARCHAR2(30) NOT NULL,
  HPA_RESTRICTED_TABLE         VARCHAR2(30),
  HPA_WHERE_CLAUSE             VARCHAR2(500),
  HPA_RESTRICTED_WHERE_CLAUSE  VARCHAR2(500),
  HPA_ID_COLUMN                VARCHAR2(30) NOT NULL,
  HPA_MEANING_COLUMN           VARCHAR2(100) NOT NULL
)
/

COMMENT ON TABLE HIG_PROCESS_AREAS IS 'Defines how processes can be broken down by area'
/

COMMENT ON COLUMN HIG_PROCESS_AREAS.HPA_AREA_TYPE IS 'Primary Key'
/

COMMENT ON COLUMN HIG_PROCESS_AREAS.HPA_DESCRIPTION IS 'Description for area type'
/

COMMENT ON COLUMN HIG_PROCESS_AREAS.HPA_TABLE IS 'Name of table/view that is used to select areas from when configuring the process type'
/

COMMENT ON COLUMN HIG_PROCESS_AREAS.HPA_RESTRICTED_TABLE IS 'Name of table/view that is used to select areas from when submitting a process.  If null then the HPA_TABLE value is used.'
/

COMMENT ON COLUMN HIG_PROCESS_AREAS.HPA_WHERE_CLAUSE IS 'A where clause to apply to the HPA_TABLE'
/

COMMENT ON COLUMN HIG_PROCESS_AREAS.HPA_RESTRICTED_WHERE_CLAUSE IS 'A where clause to apply to the HPA_RESTRICTED_TABLE'
/

COMMENT ON COLUMN HIG_PROCESS_AREAS.HPA_ID_COLUMN IS 'The name of the primary key column on the table'
/

ALTER TABLE HIG_PROCESS_AREAS ADD (
  CONSTRAINT HPA_PK
 PRIMARY KEY
 (HPA_AREA_TYPE))
/

--
--
--
CREATE TABLE hig_process_conns_by_area
(
  HPTC_PROCESS_TYPE_ID    NUMBER(38)            NOT NULL,
  HPTC_FTP_CONNECTION_ID  NUMBER(38)            NOT NULL,
  HPTC_AREA_TYPE          VARCHAR2(20 BYTE)     NOT NULL,
  HPTC_AREA_ID_VALUE      VARCHAR2(100 BYTE)    NOT NULL
)
/

COMMENT ON TABLE HIG_PROCESS_CONNS_BY_AREA IS 'Defines how FTP connections can be polled by area'
/

COMMENT ON COLUMN HIG_PROCESS_CONNS_BY_AREA.HPTC_PROCESS_TYPE_ID IS 'Foreign Key To Process Type'
/

COMMENT ON COLUMN HIG_PROCESS_CONNS_BY_AREA.HPTC_FTP_CONNECTION_ID IS 'Foreign Key to FTP Connection'
/

COMMENT ON COLUMN HIG_PROCESS_CONNS_BY_AREA.HPTC_AREA_TYPE IS 'Foreign Key to Area Type'
/


CREATE INDEX HPTC_HPA_FK_IND ON HIG_PROCESS_CONNS_BY_AREA
(HPTC_AREA_TYPE)
/


CREATE INDEX HPTC_HTC_FK_IND ON HIG_PROCESS_CONNS_BY_AREA
(HPTC_FTP_CONNECTION_ID)
/


ALTER TABLE HIG_PROCESS_CONNS_BY_AREA ADD (
  CONSTRAINT HPTC_PK
 PRIMARY KEY
 (HPTC_PROCESS_TYPE_ID, HPTC_FTP_CONNECTION_ID))
/


ALTER TABLE HIG_PROCESS_CONNS_BY_AREA ADD (
  CONSTRAINT HPTC_HPA_FK 
 FOREIGN KEY (HPTC_AREA_TYPE) 
 REFERENCES HIG_PROCESS_AREAS (HPA_AREA_TYPE))
/

ALTER TABLE HIG_PROCESS_CONNS_BY_AREA ADD (
  CONSTRAINT HPTC_HPT_FK 
 FOREIGN KEY (HPTC_PROCESS_TYPE_ID) 
 REFERENCES HIG_PROCESS_TYPES (HPT_PROCESS_TYPE_ID))
/

ALTER TABLE HIG_PROCESS_CONNS_BY_AREA ADD (
  CONSTRAINT HPTC_HTC_FK 
 FOREIGN KEY (HPTC_FTP_CONNECTION_ID) 
 REFERENCES HIG_FTP_CONNECTIONS (HFC_ID))
/
--
--
--
alter table hig_processes add (hp_area_id varchar2(100) )
/
alter table hig_processes add (hp_area_meaning varchar2(100) )
/
alter table hig_processes add (hp_area_type varchar2(20) )
/
alter table hig_processes add (hp_polling_flag varchar2(1) DEFAULT 'N' NOT NULL)
/

COMMENT ON COLUMN HIG_PROCESSES.HP_POLLING_FLAG IS 'Flag to denote whether or not this process was called in ''polling mode'''
/
COMMENT ON COLUMN HIG_PROCESSES.HP_AREA_TYPE IS 'Foreign Key to area type against which this process was parameterised.  Is also on the HIG_PROCESS_TYPE record but denormalised onto HIG_PROCESSES.'
/
COMMENT ON COLUMN HIG_PROCESSES.HP_AREA_ID IS 'Area ID against which this process was parameterised.  The HP_AREA_TYPE value gives the context of the ID.'
/
COMMENT ON COLUMN HIG_PROCESSES.HP_AREA_MEANING IS 'Meaning derived from HP_AREA_TYPE and HP_AREA_ID.  This could be determined retrospectively, but for performance reasons it''s stamped onto the process when the process is created.'
/



ALTER TABLE hig_processes ADD 
CONSTRAINT HP_HPA_FK
 FOREIGN KEY (HP_AREA_TYPE)
 REFERENCES HIG_PROCESS_AREAS (HPA_AREA_TYPE)
/

create index HP_HPA_FK_IND on hig_processes(HP_AREA_TYPE)
/

ALTER TABLE HIG_PROCESS_TYPES ADD 
CONSTRAINT HPT_HPA_FK
 FOREIGN KEY (hpt_area_type)
 REFERENCES hig_process_areas (hpa_area_type)
 ON DELETE SET NULL
/

create index hpt_hpa_fk_ind on hig_process_types(hpt_area_type)
/

create index hpt_hmo_fk1_ind on hig_process_types(HPT_INITIATION_MODULE)
/
create index hpt_hmo_fk2_ind on hig_process_types(HPT_INTERNAL_MODULE)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Bundle Loader - Tables
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support document bundle loader
-- 
------------------------------------------------------------------
CREATE TABLE doc_bundles(
                         dbun_bundle_id         number(38) not null
                        ,dbun_filename          varchar2(256) not null         
                        ,dbun_location          varchar2(256) 
                        ,dbun_unzip_location    varchar2(256) 
                        ,dbun_unzip_log         clob
                        ,dbun_process_id        number(38)
                        ,dbun_success_flag      varchar2(1) DEFAULT 'N' not null 
                        ,dbun_error_text        varchar2(500)
                        ,dbun_date_created      date not null            
                        ,dbun_date_modified     date not null            
                        ,dbun_modified_by       varchar2(30) not null             
                        ,dbun_created_by        varchar2(30) not null
                        )
/


COMMENT ON TABLE DOC_BUNDLES IS 'List of document bundles'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_CREATED_BY IS 'Audit column'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_BUNDLE_ID IS 'Primary Key'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_FILENAME IS 'Bundle Filename'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_LOCATION IS 'File system path where the bundle can be located'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_UNZIP_LOCATION IS 'File system path where the bundle was unzipped to'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_UNZIP_LOG IS 'The unzip log file'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_PROCESS_ID IS 'Associated process ID'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_SUCCESS_FLAG IS 'Success or Failure flag'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_ERROR_TEXT IS 'Error text'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_DATE_CREATED IS 'Audit column'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_DATE_MODIFIED IS 'Audit column'
/

COMMENT ON COLUMN DOC_BUNDLES.DBUN_MODIFIED_BY IS 'Audit column'
/


CREATE TABLE doc_bundle_files(
                              dbf_file_id                   number(38) not null
                             ,dbf_bundle_id                 number(38) not null  
                             ,dbf_filename                  varchar2(240) not null
                             ,dbf_driving_file_flag         varchar2(1) DEFAULT 'N' not null
                             ,dbf_file_included_with_bundle varchar2(1) DEFAULT 'Y' not null
                             ,dbf_blob                      blob
                              )
/


COMMENT ON TABLE DOC_BUNDLE_FILES IS 'List of the files in a document bundle'
/

COMMENT ON COLUMN DOC_BUNDLE_FILES.DBF_FILE_ID IS 'Primary Key'
/

COMMENT ON COLUMN DOC_BUNDLE_FILES.DBF_BUNDLE_ID IS 'Foreign Key to DOC_BUNDLES'
/

COMMENT ON COLUMN DOC_BUNDLE_FILES.DBF_FILENAME IS 'Filename'
/

COMMENT ON COLUMN DOC_BUNDLE_FILES.DBF_DRIVING_FILE_FLAG IS 'Flag to indicate whether or not this file is a driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILES.DBF_FILE_INCLUDED_WITH_BUNDLE IS 'Flag to indicate where or not this file was part of the bundle (Y) or was just referenced in a driving file (N)'
/

COMMENT ON COLUMN DOC_BUNDLE_FILES.DBF_BLOB IS 'The file content'
/



CREATE TABLE doc_bundle_file_relations(dbfr_relationship_id      number(38) not null
                                     ,dbfr_driving_file_id       number(38) not null
                                     ,dbfr_driving_file_recno    number(38) not null
                                     ,dbfr_child_file_id         number(38) not null
                                     ,dbfr_doc_title             varchar2(60)
                                     ,dbfr_doc_descr             varchar2(2000)
                                     ,dbfr_doc_type              varchar2(4) 
                                     ,dbfr_dlc_name              varchar2(30)
                                     ,dbfr_gateway_table_name    varchar2(30)
                                     ,dbfr_rec_id                varchar2(30)
                                     ,dbfr_x_coordinate          number(38)
                                     ,dbfr_y_coordinate          number(38) 
                                     ,dbfr_doc_id                number(38)
                                     ,dbfr_doc_filename          varchar2(254)
                                     ,dbfr_hftq_batch_no         number(38) 
                                     ,dbfr_error_text            varchar2(500)
                                    )
/


COMMENT ON TABLE DOC_BUNDLE_FILE_RELATIONS IS 'Defines the relationships between the files in a document bundle and the data read from each of the driving files'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_RELATIONSHIP_ID IS 'Primary Key'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DRIVING_FILE_ID IS 'Foreign Key to DOC_BUNDLE_FILES'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DRIVING_FILE_RECNO IS 'The line number within the driving file that this record relates to'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_CHILD_FILE_ID IS 'Foreign Key to DOC_BUNDLE_FILES'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DOC_TITLE IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DOC_DESCR IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DOC_TYPE IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DLC_NAME IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_GATEWAY_TABLE_NAME IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_REC_ID IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_X_COORDINATE IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_Y_COORDINATE IS 'Attribute as supplied in driving file'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DOC_ID IS 'Resultant DOC_ID of any DOCS record created'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_DOC_FILENAME IS 'The unique filename that the file referred to in DOC_BUNDLE_FILES was renamed to'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_HFTQ_BATCH_NO IS 'Pointer to entries in HIG_FILE_TRANSFER_QUEUE table'
/

COMMENT ON COLUMN DOC_BUNDLE_FILE_RELATIONS.DBFR_ERROR_TEXT IS 'Error Text'
/



CREATE GLOBAL TEMPORARY TABLE doc_bundle_discard_blobs(id       number(38)
                                                      ,filename varchar2(240)
                                                      ,the_blob blob) ON COMMIT DELETE ROWS
NOCACHE
/

COMMENT ON TABLE DOC_BUNDLE_DISCARD_BLOBS IS 'Temporary table used to store blobs of discarded files to write to a location on the client machine.  Drives the Discards functionality in DOC0310-Manage Document Bundles'
/
COMMENT ON COLUMN DOC_BUNDLE_DISCARD_BLOBS.ID IS 'Unique identifier for the record'
/

COMMENT ON COLUMN DOC_BUNDLE_DISCARD_BLOBS.FILENAME IS 'Filename to be written out'
/

COMMENT ON COLUMN DOC_BUNDLE_DISCARD_BLOBS.THE_BLOB IS 'File content'
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Bundle Loader - Constraints
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support document bundle loader
-- 
------------------------------------------------------------------
ALTER TABLE doc_bundles ADD (
  CONSTRAINT dbun_pk
 PRIMARY KEY
 (dbun_bundle_id))
/
ALTER TABLE doc_bundles ADD (
  CONSTRAINT dbun_hp_fk 
 FOREIGN KEY (dbun_process_id) 
 REFERENCES HIG_PROCESSES (HP_PROCESS_ID)
    ON DELETE SET NULL)
/
ALTER TABLE doc_bundle_files ADD (
  CONSTRAINT dbf_pk
 PRIMARY KEY
 (dbf_file_id))
/
ALTER TABLE doc_bundle_files ADD (
  CONSTRAINT dbdf_dbun_fk 
 FOREIGN KEY (dbf_bundle_id) 
 REFERENCES doc_bundles (dbun_bundle_id)
    ON DELETE CASCADE)
/
ALTER TABLE doc_bundle_file_relations ADD (
  CONSTRAINT dbfr_pk
 PRIMARY KEY
 (dbfr_relationship_id))
/
ALTER TABLE doc_bundle_file_relations ADD (
  CONSTRAINT dbfr_uk
 UNIQUE
 (dbfr_driving_file_id,dbfr_driving_file_recno, dbfr_child_file_id))
/
ALTER TABLE doc_bundle_file_relations ADD (
  CONSTRAINT dbfr_dbf_fk1 
 FOREIGN KEY (dbfr_driving_file_id) 
 REFERENCES doc_bundle_files (dbf_file_id)
    ON DELETE CASCADE)
/

ALTER TABLE doc_bundle_file_relations ADD (
  CONSTRAINT dbfr_dbf_fk2
 FOREIGN KEY (dbfr_child_file_id) 
 REFERENCES doc_bundle_files (dbf_file_id)
    ON DELETE CASCADE)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Bundle Loader - Indexes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support document bundle loader
-- 
------------------------------------------------------------------
CREATE INDEX dbun_hp_fk_ind ON doc_bundles(dbun_process_id)
/
CREATE INDEX dbf_dbun_fk_ind ON doc_bundle_files(dbf_bundle_id)
/
CREATE INDEX dbfr_dbf_fk2_ind ON doc_bundle_file_relations(dbfr_child_file_id)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Document Bundle Loader - Sequences
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To support document bundle loader
-- 
------------------------------------------------------------------
CREATE SEQUENCE dbun_bundle_id_seq nocache
/
CREATE SEQUENCE dbf_file_id_seq nocache
/
create sequence dbfr_relationship_id_seq nocache
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator and Query Builder -  Tables and Types
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator and Query Builder Tables and Types
-- 
------------------------------------------------------------------
PROMPT Creating Table 'HIG_QUERY_TYPES'
CREATE TABLE HIG_QUERY_TYPES
 (HQT_ID NUMBER(9) NOT NULL
 ,HQT_NIT_INV_TYPE VARCHAR2(4) NOT NULL
 ,HQT_NAME VARCHAR2(100) NOT NULL
 ,HQT_DESCR VARCHAR2(500)
 ,HQT_QUERY_TYPE VARCHAR2(1) NOT NULL
 ,HQT_SECURITY VARCHAR2(1) NOT NULL
 ,HQT_IGNORE_CASE VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,HQT_WHERE_CLAUSE VARCHAR2(4000)
 ,HQT_DATE_CREATED DATE NOT NULL
 ,HQT_CREATED_BY VARCHAR2(30) NOT NULL
 ,HQT_DATE_MODIFIED DATE NOT NULL
 ,HQT_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_QUERY_TYPES IS 'User defined SQL queries for use in various applications'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_NIT_INV_TYPE IS 'Identifies the asset metamodel used in building the query'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_NAME IS 'Name of the query'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_DESCR IS 'Describes the query and its purpose'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_SECURITY IS 'Determines access rights for the query - Private (R) or Public (P).  Private queries are only be executed or amended by the owner.'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_IGNORE_CASE IS 'Determines if the query is executed with case restriction or to ignore the case.'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_WHERE_CLAUSE IS 'WHERE clause that will be appended to the SQL statement at runtime'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_CREATED_BY IS 'Audit details.  Also identifies the owner of a Private query'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_QUERY_TYPES.HQT_MODIFIED_BY IS 'Audit details'
/



PROMPT Creating Table 'HIG_QUERY_TYPE_ATTRIBUTES'
CREATE TABLE HIG_QUERY_TYPE_ATTRIBUTES
 (HQTA_ID NUMBER(38) NOT NULL
 ,HQTA_HQT_ID NUMBER(9) NOT NULL
 ,HQTA_PRE_BRACKET VARCHAR2(10)
 ,HQTA_OPERATOR VARCHAR(10) NOT NULL
 ,HQTA_ATTRIBUTE_NAME VARCHAR(30) NOT NULL
 ,HQTA_CONDITION VARCHAR(20) NOT NULL
 ,HQTA_DATA_VALUE VARCHAR(1000)
 ,HQTA_POST_BRACKET VARCHAR2(10)
 ,HQTA_DATE_CREATED DATE NOT NULL
 ,HQTA_CREATED_BY VARCHAR2(30) NOT NULL
 ,HQTA_DATE_MODIFIED DATE NOT NULL
 ,HQTA_MODIFIED_BY VARCHAR2(30) NOT NULL
,HQTA_INV_TYPE VARCHAR2(4) NOT NULL
 )
/

COMMENT ON TABLE HIG_QUERY_TYPE_ATTRIBUTES IS 'User defined conditions for constructing a WHERE clause'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_HQT_ID IS 'Identifies a particular query'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_PRE_BRACKET IS 'Opening brackets for an advanced query'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_OPERATOR IS 'The operator to be included in the WHERE clause - must be AND or OR'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_ATTRIBUTE_NAME IS 'The attribute upon which the WHERE clause is based'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_CONDITION IS 'The SQL condition to be included in the WHERE clause  eg =, >, >='
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_DATA_VALUE IS 'The value to be included in the WHERE clause'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_POST_BRACKET IS 'Closing brackets for an advanced query'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.HQTA_MODIFIED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_QUERY_TYPE_ATTRIBUTES.hqta_inv_type IS 'Identifies the asset metamodel used for the selected column'
/

PROMPT Creating Table 'HIG_FLEX_ATTRIBUTES'
CREATE TABLE HIG_FLEX_ATTRIBUTES
 (HFA_ID NUMBER(9) NOT NULL
 ,HFA_TABLE_NAME VARCHAR2(30) NOT NULL
 ,HFA_ATTRIBUTE1 VARCHAR2(30) NOT NULL
 ,HFA_ATTRIBUTE2 VARCHAR2(30)
 ,HFA_ATTRIBUTE3 VARCHAR2(30)
 ,HFA_ATTRIBUTE4 VARCHAR2(30)
 ,HFA_ATTRIBUTE5 VARCHAR2(30)
 ,HFA_DATE_CREATED DATE NOT NULL
 ,HFA_CREATED_BY VARCHAR2(30) NOT NULL
 ,HFA_DATE_MODIFIED DATE NOT NULL
 ,HFA_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_FLEX_ATTRIBUTES IS 'Defines how flexible attributes are stored on application tables'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_TABLE_NAME IS 'Identifies a table that contains a number of flexible attributes'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_ATTRIBUTE1 IS 'Identifies a driving column for flexible attribution'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_ATTRIBUTE2 IS 'Identifies a driving column for flexible attribution'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_ATTRIBUTE3 IS 'Identifies a driving column for flexible attribution'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_ATTRIBUTE4 IS 'Identifies a driving column for flexible attribution'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_ATTRIBUTE5 IS 'Identifies a driving column for flexible attribution'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTES.HFA_MODIFIED_BY IS 'Audit details'
/


PROMPT Creating Table 'HIG_FLEX_ATTRIBUTE_INV_MAPPING'
CREATE TABLE HIG_FLEX_ATTRIBUTE_INV_MAPPING
 (HFAM_ID NUMBER(9) NOT NULL
 ,HFAM_HFA_ID NUMBER(9) NOT NULL
 ,HFAM_ATTRIBUTE_DATA1 VARCHAR2(100) NOT NULL
 ,HFAM_ATTRIBUTE_DATA2 VARCHAR2(100)
 ,HFAM_ATTRIBUTE_DATA3 VARCHAR2(100)
 ,HFAM_ATTRIBUTE_DATA4 VARCHAR2(100)
 ,HFAM_ATTRIBUTE_DATA5 VARCHAR2(100)
 ,HFAM_NIT_INV_TYPE VARCHAR2(4) NOT NULL
 ,HFAM_DATE_CREATED DATE NOT NULL
 ,HFAM_CREATED_BY VARCHAR2(30) NOT NULL
 ,HFAM_DATE_MODIFIED DATE NOT NULL
 ,HFAM_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_HFA_ID IS 'Identifies the flexible attribute driving columns'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_ATTRIBUTE_DATA1 IS 'Data value for a driving column'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_ATTRIBUTE_DATA2 IS 'Data value for a driving column'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_ATTRIBUTE_DATA3 IS 'Data value for a driving column'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_ATTRIBUTE_DATA4 IS 'Data value for a driving column'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_ATTRIBUTE_DATA5 IS 'Data value for a driving column'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_NIT_INV_TYPE IS 'Identifies the asset metamodel that defines the flexible attribution for this combination of driving column values'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_FLEX_ATTRIBUTE_INV_MAPPING.HFAM_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_NAVIGATOR'
CREATE TABLE HIG_NAVIGATOR
 (HNV_HIERARCHY_TYPE VARCHAR2(50) NOT NULL
 ,HNV_PARENT_TABLE VARCHAR2(500)
 ,HNV_PARENT_COLUMN VARCHAR2(1000)
 ,HNV_CHILD_TABLE VARCHAR2(500) NOT NULL
 ,HNV_CHILD_COLUMN VARCHAR2(1000) NOT NULL
 ,HNV_HIERARCHY_LEVEL NUMBER(9) NOT NULL
 ,HNV_HIERARCHY_LABEL VARCHAR2(100) NOT NULL
 ,HNV_PARENT_ID VARCHAR2(100)
 ,HNV_CHILD_ID VARCHAR2(100) NOT NULL
 ,HNV_PARENT_ALIAS VARCHAR2(10)
 ,HNV_CHILD_ALIAS VARCHAR2(10) NOT NULL
 ,HNV_ICON_NAME VARCHAR2(50)
 ,HNV_ADDITIONAL_COND VARCHAR2(2000)
 ,HNV_PRIMARY_HIERARCHY VARCHAR2(1) DEFAULT 'N'
 ,HNV_HIER_LABEL_1 VARCHAR2(500) NOT NULL
 ,HNV_HIER_LABEL_2 VARCHAR2(500)
 ,HNV_HIER_LABEL_3 VARCHAR2(500)
 ,HNV_HIER_LABEL_4 VARCHAR2(500)
 ,HNV_HIER_LABEL_5 VARCHAR2(500)
 ,HNV_HIER_LABEL_6 VARCHAR2(500)
 ,HNV_HIER_LABEL_7 VARCHAR2(500)
 ,HNV_HIER_LABEL_8 VARCHAR2(500)
 ,HNV_HIER_LABEL_9 VARCHAR2(500)
 ,HNV_HIER_LABEL_10 VARCHAR2(500)
 ,HNV_HIERARCHY_SEQ NUMBER(9)
 ,HNV_DATE_CREATED DATE NOT NULL
 ,HNV_CREATED_BY VARCHAR2(30) NOT NULL
 ,HNV_DATE_MODIFIED DATE NOT NULL
 ,HNV_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_NAVIGATOR IS 'Defines the Navigator hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_HIERARCHY_TYPE IS 'Name for a type of record that may be shown in a Navigator hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_PARENT_TABLE IS 'Identifies the parent table for joins to build a hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_PARENT_COLUMN IS 'Identifies the parent column for joins to build a hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_CHILD_TABLE IS 'Identifies the child table for joins to build a hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_CHILD_COLUMN IS 'Identifies the child column for joins to build a hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_HIERARCHY_LEVEL IS 'The level of a row in the hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_HIERARCHY_LABEL IS 'The label displayed in the hierarchy menu'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_PARENT_ID IS 'Identifies the parent column for building a CONNECT BY query'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_CHILD_ID IS 'Identifies the child column for building a CONNECT BY query'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_ICON_NAME IS 'Additional where clauses for building a hierarchy query (if needed)'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_PRIMARY_HIERARCHY IS 'Determines whether this is the primary hierarchy (Y or N) as there may be multiple hierarchies for a particular table'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_HIER_LABEL_1 IS 'Identifies a column whose value will be included in the label shown on the row in a Navigator hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_HIER_LABEL_2 IS 'Identifies a column whose value will be included in the label shown on the row in a Navigator hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_HIERARCHY_SEQ IS 'Sequence in which the row is shown for a given level in the hierarchy'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_NAVIGATOR.HNV_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_NAVIGATOR_MODULES'
CREATE TABLE HIG_NAVIGATOR_MODULES
 (HNM_MODULE_NAME VARCHAR2(50) NOT NULL
 ,HNM_MODULE_PARAM VARCHAR2(50) NOT NULL
 ,HNM_PRIMARY_MODULE VARCHAR2(1) DEFAULT 'N'
 ,HNM_SEQUENCE NUMBER(9)
 ,HNM_TABLE_NAME VARCHAR2(50)
 ,HNM_FIELD_NAME VARCHAR2(100)
 ,HNM_HIERARCHY_LABEL VARCHAR2(100) NOT NULL
 ,HNM_DATE_CREATED DATE NOT NULL
 ,HNM_CREATED_BY VARCHAR2(30) NOT NULL
 ,HNM_DATE_MODIFIED DATE NOT NULL
 ,HNM_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_NAVIGATOR_MODULES IS 'Defines the modules that can be dynamically invoked from Navigator or from a Links menu.'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_MODULE_NAME IS 'Identifies a module that can be invoked'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_MODULE_PARAM IS 'Identifies a parameter that should be passed into the form for autoquery purposes'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_PRIMARY_MODULE IS 'Determines whether the module should be executed by default when double clicking on a record in Navigator - Y or N'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_SEQUENCE IS 'Sequence to use when displaying a list of modules'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_TABLE_NAME IS 'Identifies a base tablename in the calling form to determine whether a module appears in the Links menu'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_FIELD_NAME IS 'Identifies a column in the calling form to determine whether a module appears in the Links menu'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_HIERARCHY_LABEL IS 'Identifies the Navigator hierarchy label to which the associated module setup is done'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_NAVIGATOR_MODULES.HNM_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_NAVIGATOR_RESULT_TAB'
CREATE GLOBAL TEMPORARY TABLE HIG_NAVIGATOR_RESULT_TAB
 (COL_1 VARCHAR2(500)
 ,COL_2 VARCHAR2(500)
 ,COL_3 VARCHAR2(500)
 ,COL_4 VARCHAR2(500)
 ,COL_5 VARCHAR2(500)
 ,COL_6 VARCHAR2(500)
 ,COL_7 VARCHAR2(500)
 ,COL_8 VARCHAR2(500)
 ,COL_9 VARCHAR2(500)
 ,COL_10 VARCHAR2(500)
 ,COL_11 VARCHAR2(500)
 ,COL_12 VARCHAR2(500)
 ,COL_13 VARCHAR2(500)
 ,COL_14 VARCHAR2(500)
 ,COL_15 VARCHAR2(500)
 ,COL_16 VARCHAR2(500)
 ,COL_17 VARCHAR2(500)
 ,COL_18 VARCHAR2(500)
 ,COL_19 VARCHAR2(500)
 ,COL_20 VARCHAR2(500)
 ,COL_21 VARCHAR2(500)
 ,COL_22 VARCHAR2(500)
 ,COL_23 VARCHAR2(500)
 ,COL_24 VARCHAR2(500)
 ,COL_25 VARCHAR2(500)
 ,COL_26 VARCHAR2(500)
 ,COL_27 VARCHAR2(500)
 ,COL_28 VARCHAR2(500)
 ,COL_29 VARCHAR2(500)
 ,COL_30 VARCHAR2(500)
 ,COL_31 VARCHAR2(500)
 ,COL_32 VARCHAR2(500)
 ,COL_33 VARCHAR2(500)
 ,COL_34 VARCHAR2(500)
 ,COL_35 VARCHAR2(500)
 ,COL_36 VARCHAR2(500)
 ,COL_37 VARCHAR2(500)
 ,COL_38 VARCHAR2(500)
 ,COL_39 VARCHAR2(500)
 ,COL_40 VARCHAR2(500)
 ,COL_41 VARCHAR2(500)
 ,COL_42 VARCHAR2(500)
 ,COL_43 VARCHAR2(500)
 ,COL_44 VARCHAR2(500)
 ,COL_45 VARCHAR2(500)
 ,COL_46 VARCHAR2(500)
 ,COL_47 VARCHAR2(500)
 ,COL_48 VARCHAR2(500)
 ,COL_49 VARCHAR2(500)
 ,COL_50 VARCHAR2(500)
 ,COL_51 VARCHAR2(500)
 ,COL_52 VARCHAR2(500)
 ,COL_53 VARCHAR2(500)
 ,COL_54 VARCHAR2(500)
 ,COL_55 VARCHAR2(500)
 ,COL_56 VARCHAR2(500)
 ,COL_57 VARCHAR2(500)
 ,COL_58 VARCHAR2(500)
 ,COL_59 VARCHAR2(500)
 ,COL_60 VARCHAR2(500)
 ,COL_61 VARCHAR2(500)
 ,COL_62 VARCHAR2(500)
 ,COL_63 VARCHAR2(500)
 ,COL_64 VARCHAR2(500)
 ,COL_65 VARCHAR2(500)
 ,COL_66 VARCHAR2(500)
 ,COL_67 VARCHAR2(500)
 ,COL_68 VARCHAR2(500)
 ,COL_69 VARCHAR2(500)
 ,COL_70 VARCHAR2(500)
 ,COL_71 VARCHAR2(500)
 ,COL_72 VARCHAR2(500)
 ,COL_73 VARCHAR2(500)
 ,COL_74 VARCHAR2(500)
 ,COL_75 VARCHAR2(500)
 ,COL_76 VARCHAR2(500)
 ,COL_77 VARCHAR2(500)
 ,COL_78 VARCHAR2(500)
 ,COL_79 VARCHAR2(500)
 ,COL_80 VARCHAR2(500)
 ,COL_81 VARCHAR2(500)
 ,COL_82 VARCHAR2(500)
 ,COL_83 VARCHAR2(500)
 ,COL_84 VARCHAR2(500)
 ,COL_85 VARCHAR2(500)
 ,COL_86 VARCHAR2(500)
 ,COL_87 VARCHAR2(500)
 ,COL_88 VARCHAR2(500)
 ,COL_89 VARCHAR2(500)
 ,COL_90 VARCHAR2(500)
 ,COL_91 VARCHAR2(500)
 ,COL_92 VARCHAR2(500)
 ,COL_93 VARCHAR2(500)
 ,COL_94 VARCHAR2(500)
 ,COL_95 VARCHAR2(500)
 ,COL_96 VARCHAR2(500)
 ,COL_97 VARCHAR2(500)
 ,COL_98 VARCHAR2(500)
 ,COL_99 VARCHAR2(500)
 ,COL_100 VARCHAR2(500)
 ,COL_101 VARCHAR2(500)
 ,COL_102 VARCHAR2(500)
 ,COL_103 VARCHAR2(500)
 ,COL_104 VARCHAR2(500)
 ,COL_105 VARCHAR2(500)
 ,COL_106 VARCHAR2(500)
 ,COL_107 VARCHAR2(500)
 ,COL_108 VARCHAR2(500)
 ,COL_109 VARCHAR2(500)
 ,COL_110 VARCHAR2(500)
 ,COL_111 VARCHAR2(500)
 ,COL_112 VARCHAR2(500)
 ,COL_113 VARCHAR2(500)
 ,COL_114 VARCHAR2(500)
 ,COL_115 VARCHAR2(500)
 ,COL_116 VARCHAR2(500)
 ,COL_117 VARCHAR2(500)
 ,COL_118 VARCHAR2(500)
 ,COL_119 VARCHAR2(500)
 ,COL_120 VARCHAR2(500)
 ,COL_121 VARCHAR2(500)
 ,COL_122 VARCHAR2(500)
 ,COL_123 VARCHAR2(500)
 ,COL_124 VARCHAR2(500)
 ,COL_125 VARCHAR2(500)
 ,COL_126 VARCHAR2(500)
 ,COL_127 VARCHAR2(500)
 ,COL_128 VARCHAR2(500)
 ,COL_129 VARCHAR2(500)
 ,COL_130 VARCHAR2(500)
 ,COL_131 VARCHAR2(500)
 ,COL_132 VARCHAR2(500)
 ,COL_133 VARCHAR2(500)
 ,COL_134 VARCHAR2(500)
 ,COL_135 VARCHAR2(500)
 ,COL_136 VARCHAR2(500)
 ,COL_137 VARCHAR2(500)
 ,COL_138 VARCHAR2(500)
 ,COL_139 VARCHAR2(500)
 ,COL_140 VARCHAR2(500)
 ,COL_141 VARCHAR2(500)
 ,COL_142 VARCHAR2(500)
 ,COL_143 VARCHAR2(500)
 ,COL_144 VARCHAR2(500)
 ,COL_145 VARCHAR2(500)
 ,COL_146 VARCHAR2(500)
 ,COL_147 VARCHAR2(500)
 ,COL_148 VARCHAR2(500)
 ,COL_149 VARCHAR2(500)
 ,COL_150 VARCHAR2(500)
 ,COL_151 VARCHAR2(500)
 ,COL_152 VARCHAR2(500)
 ,COL_153 VARCHAR2(500)
 ,COL_154 VARCHAR2(500)
 ,COL_155 VARCHAR2(500)
 ,COL_156 VARCHAR2(500)
 ,COL_157 VARCHAR2(500)
 ,COL_158 VARCHAR2(500)
 ,COL_159 VARCHAR2(500)
 ,COL_160 VARCHAR2(500)
 ,COL_161 VARCHAR2(500)
 ,COL_162 VARCHAR2(500)
 ,COL_163 VARCHAR2(500)
 ,COL_164 VARCHAR2(500)
 ,COL_165 VARCHAR2(500)
 ,COL_166 VARCHAR2(500)
 ,COL_167 VARCHAR2(500)
 ,COL_168 VARCHAR2(500)
 )
 ON COMMIT PRESERVE ROWS
 NOCACHE
/

COMMENT ON TABLE HIG_NAVIGATOR_RESULT_TAB IS 'This is a temporary table to hold result data when a query is executed in Navigator'
/

COMMENT ON COLUMN HIG_NAVIGATOR_RESULT_TAB.COL_1 IS 'Column data values returned when a query is executed'
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator and Query Builder - Constraints
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator and Query Builder Constraints
-- 
------------------------------------------------------------------
PROMPT Creating Primary Key on 'HIG_QUERY_TYPES'
ALTER TABLE HIG_QUERY_TYPES
 ADD (CONSTRAINT HQT_PK PRIMARY KEY
  (HQT_ID))
/

PROMPT Creating Check Constraint on 'HIG_QUERY_TYPES'
ALTER TABLE HIG_QUERY_TYPES
 ADD (CONSTRAINT HQT_IGNORE_CASE_CHK CHECK (hqt_ignore_case IN ('Y','N')))
/

PROMPT Creating Check Constraint on 'HIG_QUERY_TYPES'
ALTER TABLE HIG_QUERY_TYPES
 ADD (CONSTRAINT HQT_QUERY_TYPE_CHK CHECK (HQT_QUERY_TYPE IN ('S','A')))
/

PROMPT Creating Check Constraint on 'HIG_QUERY_TYPES'
ALTER TABLE HIG_QUERY_TYPES
 ADD (CONSTRAINT HQT_SECURITY_CHK CHECK (HQT_SECURITY IN ('R','P')))
/

PROMPT Creating Foreign Key on 'HIG_QUERY_TYPES'
ALTER TABLE HIG_QUERY_TYPES ADD (CONSTRAINT
 HQT_NIT_FK FOREIGN KEY
  (HQT_NIT_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))
/

PROMPT Creating Primary Key on 'HIG_QUERY_TYPE_ATTRIBUTES'
ALTER TABLE HIG_QUERY_TYPE_ATTRIBUTES
 ADD (CONSTRAINT HQTA_PK PRIMARY KEY
  (HQTA_ID))
/

PROMPT Creating Foreign Key on 'HIG_QUERY_TYPE_ATTRIBUTES'
ALTER TABLE HIG_QUERY_TYPE_ATTRIBUTES ADD (CONSTRAINT
 HQTA_HQT_FK FOREIGN KEY
  (HQTA_HQT_ID) REFERENCES HIG_QUERY_TYPES
  (HQT_ID))
/

PROMPT Creating Foreign Key on 'HIG_QUERY_TYPE_ATTRIBUTES'
ALTER TABLE HIG_QUERY_TYPE_ATTRIBUTES ADD (CONSTRAINT
 HQTA_NIT_FK FOREIGN KEY
  (HQTA_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))
/

PROMPT Creating Primary Key on 'HIG_FLEX_ATTRIBUTES'
ALTER TABLE HIG_FLEX_ATTRIBUTES
 ADD (CONSTRAINT HFA_PK PRIMARY KEY
  (HFA_ID))
/

PROMPT Creating Unique Key on 'HIG_FLEX_ATTRIBUTES'
ALTER TABLE HIG_FLEX_ATTRIBUTES
 ADD (CONSTRAINT HFA_UK UNIQUE
  (HFA_TABLE_NAME))
/

PROMPT Creating Primary Key on 'HIG_FLEX_ATTRIBUTE_INV_MAPPING'
ALTER TABLE HIG_FLEX_ATTRIBUTE_INV_MAPPING
 ADD (CONSTRAINT HFAM_PK PRIMARY KEY
  (HFAM_ID))
/

PROMPT Creating Foreign Key on 'HIG_FLEX_ATTRIBUTE_INV_MAPPING'
ALTER TABLE HIG_FLEX_ATTRIBUTE_INV_MAPPING ADD (CONSTRAINT
 HFAM_HFA_FK FOREIGN KEY
  (HFAM_HFA_ID) REFERENCES HIG_FLEX_ATTRIBUTES
  (HFA_ID))
/

PROMPT Creating Foreign Key on 'HIG_FLEX_ATTRIBUTE_INV_MAPPING'
ALTER TABLE HIG_FLEX_ATTRIBUTE_INV_MAPPING ADD (CONSTRAINT
 HFAM_NIT_FK FOREIGN KEY
  (HFAM_NIT_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))
/

PROMPT Creating Unique Key on 'HIG_FLEX_ATTRIBUTE_INV_MAPPING'
ALTER TABLE HIG_FLEX_ATTRIBUTE_INV_MAPPING
 ADD (CONSTRAINT HFAM_UK UNIQUE
  (HFAM_HFA_ID
  ,HFAM_ATTRIBUTE_DATA1
  ,HFAM_ATTRIBUTE_DATA2
  ,HFAM_ATTRIBUTE_DATA3
  ,HFAM_ATTRIBUTE_DATA4
  ,HFAM_ATTRIBUTE_DATA5))
/

PROMPT Creating Primary Key on 'HIG_NAVIGATOR'
ALTER TABLE HIG_NAVIGATOR
 ADD (CONSTRAINT HNV_PK PRIMARY KEY
  (HNV_CHILD_ALIAS))
/

PROMPT Creating Check Constraint on 'HIG_NAVIGATOR'
ALTER TABLE HIG_NAVIGATOR
 ADD (CONSTRAINT HNV_PRIMARY_HIERARCHY_CKH CHECK (HNV_PRIMARY_HIERARCHY IN ('Y','N')))
/

PROMPT Creating Primary Key on 'HIG_NAVIGATOR_MODULES'
ALTER TABLE HIG_NAVIGATOR_MODULES
 ADD (CONSTRAINT HNM_PK PRIMARY KEY
  (HNM_MODULE_NAME
  ,HNM_MODULE_PARAM
  ,HNM_HIERARCHY_LABEL))
/

PROMPT Creating Check Constraint on 'HIG_NAVIGATOR_MODULES'
ALTER TABLE HIG_NAVIGATOR_MODULES
 ADD (CONSTRAINT HNM_PRIMARY_MODULE_CKH CHECK (HNM_PRIMARY_MODULE IN ('Y','N')))
/

PROMPT Creating Foreign Key on 'HIG_NAVIGATOR_MODULES'
ALTER TABLE HIG_NAVIGATOR_MODULES ADD (CONSTRAINT
 HNM_HMO_FK FOREIGN KEY
  (HNM_MODULE_NAME) REFERENCES HIG_MODULES
  (HMO_MODULE))
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator and Query Builder - Sequences
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator and Query Builder Sequences
-- 
------------------------------------------------------------------
PROMPT Creating Sequence 'HQT_ID_SEQ'
CREATE SEQUENCE HQT_ID_SEQ
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HQTA_ID_SEQ'
CREATE SEQUENCE HQTA_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

CREATE SEQUENCE HFA_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

CREATE SEQUENCE HFAM_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator and Query Builder - Indexes
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108984
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator and Query Builder - Indexes
-- 
------------------------------------------------------------------
PROMPT Creating Index 'HNM_HIERARCHY_LABEL_IND'
CREATE INDEX HNM_HIERARCHY_LABEL_IND ON HIG_NAVIGATOR_MODULES
 (HNM_HIERARCHY_LABEL)
/


PROMPT Creating Index 'HQTA_NIT_FK_IND'
CREATE INDEX HQTA_NIT_FK_IND ON HIG_QUERY_TYPE_ATTRIBUTES
 (HQTA_INV_TYPE)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Audit - Tables
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108985
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Audit Tables
-- 
------------------------------------------------------------------
PROMPT Creating Table 'HIG_AUDIT_TYPES'
CREATE TABLE HIG_AUDIT_TYPES
 (HAUT_ID NUMBER(9) NOT NULL
 ,HAUT_NIT_INV_TYPE VARCHAR2(4) NOT NULL
 ,HAUT_TABLE_NAME VARCHAR2(30) NOT NULL
 ,HAUT_DESCRIPTION VARCHAR2(250)
 ,HAUT_OPERATION VARCHAR2(20) NOT NULL
 ,HAUT_TRIGGER_NAME VARCHAR2(30)
 ,HAUT_DATE_CREATED DATE NOT NULL
 ,HAUT_CREATED_BY VARCHAR2(30) NOT NULL
 ,HAUT_DATE_MODIFIED DATE NOT NULL
 ,HAUT_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_AUDIT_TYPES IS 'Defines the types of audit that have been configured'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_NIT_INV_TYPE IS 'Identifies the asset metamodel used in specifying the audit conditions'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_TABLE_NAME IS 'Identifies the table name on which a database trigger will be executed to generate audit records'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_DESCRIPTION IS 'Describes the type of audit and its purpose'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_OPERATION IS 'Determines the database operation on which the trigger will be executed (Insert, Update or Delete)'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_TRIGGER_NAME IS 'The name of the database trigger'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_TYPES.HAUT_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_AUDIT_ATTRIBUTES'
CREATE TABLE HIG_AUDIT_ATTRIBUTES
 (HAAT_ID NUMBER(9) NOT NULL
 ,HAAT_HAUT_ID NUMBER(9) NOT NULL
 ,HAAT_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL
 ,HAAT_DATE_CREATED DATE NOT NULL
 ,HAAT_CREATED_BY VARCHAR2(30) NOT NULL
 ,HAAT_DATE_MODIFIED DATE NOT NULL
 ,HAAT_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_AUDIT_ATTRIBUTES IS 'Defines the database columns that generate audit records when updated'
/

COMMENT ON COLUMN HIG_AUDIT_ATTRIBUTES.HAAT_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_AUDIT_ATTRIBUTES.HAAT_HAUT_ID IS 'Identifies the type of audit'
/

COMMENT ON COLUMN HIG_AUDIT_ATTRIBUTES.HAAT_ATTRIBUTE_NAME IS 'The attribute upon which the database trigger is based'
/

COMMENT ON COLUMN HIG_AUDIT_ATTRIBUTES.HAAT_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_ATTRIBUTES.HAAT_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_ATTRIBUTES.HAAT_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_ATTRIBUTES.HAAT_MODIFIED_BY IS 'Audit details'
/


PROMPT Creating Table 'HIG_AUDIT_CONDITIONS'
CREATE TABLE HIG_AUDIT_CONDITIONS
 (HAC_ID NUMBER(9) NOT NULL
 ,HAC_HAUT_ID NUMBER(9) NOT NULL
 ,HAC_PRE_BRACKET VARCHAR2(10)
 ,HAC_OPERATOR VARCHAR2(10) NOT NULL
 ,HAC_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL
 ,HAC_CONDITION VARCHAR2(20) NOT NULL
 ,HAC_ATTRIBUTE_VALUE VARCHAR2(500)
 ,HAC_POST_BRACKET VARCHAR2(10)
 ,HAC_OLD_NEW_TYPE VARCHAR2(1) NOT NULL
 ,HAC_DATE_CREATED DATE NOT NULL
 ,HAC_CREATED_BY VARCHAR2(30) NOT NULL
 ,HAC_DATE_MODIFIED DATE NOT NULL
 ,HAC_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_AUDIT_CONDITIONS IS 'Defines the conditions for generating audit records'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_HAUT_ID IS 'Identifies the type of audit'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_PRE_BRACKET IS 'Opening brackets for an advanced query'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_OPERATOR IS 'The operator to be included in the WHERE clause - must be AND or OR'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_ATTRIBUTE_NAME IS 'The attribute upon which the WHERE clause is based'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_CONDITION IS 'The SQL condition to be included in the WHERE clause  eg =, >, >='
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_ATTRIBUTE_VALUE IS 'The value to be included in the WHERE clause'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_POST_BRACKET IS 'Closing brackets for an advanced query'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_OLD_NEW_TYPE IS 'Specifies whether to reference Old, New or Both values in update triggers - must be O, N or B'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_AUDIT_CONDITIONS.HAC_MODIFIED_BY IS 'Audit details'
/


PROMPT Creating Table 'HIG_AUDITS'
CREATE TABLE HIG_AUDITS
 (HAUD_ID NUMBER(38) NOT NULL
 ,HAUD_NIT_INV_TYPE VARCHAR2(4) NOT NULL
 ,HAUD_TABLE_NAME VARCHAR2(30) NOT NULL
 ,HAUD_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL
 ,HAUD_PK_ID VARCHAR2(100) NOT NULL
 ,HAUD_OLD_VALUE VARCHAR2(4000)
 ,HAUD_NEW_VALUE VARCHAR2(4000)
 ,HAUD_TIMESTAMP DATE NOT NULL
 ,HAUD_OPERATION VARCHAR2(1) NOT NULL
 ,HAUD_HUS_USER_ID NUMBER(9) NOT NULL
 ,HAUD_TERMINAL VARCHAR2(100)
 ,HAUD_OS_USER VARCHAR2(100)
 )
/

COMMENT ON TABLE HIG_AUDITS IS 'Record of actual audits that have been generated'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_NIT_INV_TYPE IS 'Identifies the asset metamodel used when the audit trigger was created'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_TABLE_NAME IS 'Identifies the table which triggered the audit'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_ATTRIBUTE_NAME IS 'Identifies the attribute which triggered the audit.  This will be the primary key column for audits on Insert or Delete'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_PK_ID IS 'Identifies the database record which triggered the audit'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_OLD_VALUE IS 'Old value of the audited column'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_NEW_VALUE IS 'New value of the audited column'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_TIMESTAMP IS 'Timestamp of the audit created'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_OPERATION IS 'Identifies the database operation which triggered the audit (Insert, Update or Delete)'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_HUS_USER_ID IS 'Identifies the user who triggered the audit'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_TERMINAL IS 'Identifies the terminal from which the database operation was performed'
/

COMMENT ON COLUMN HIG_AUDITS.HAUD_OS_USER IS 'Identifies the operating system username under which the database operation was performed'
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Audit - Constraints
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108985
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Audit Constraints
-- 
------------------------------------------------------------------
PROMPT Creating Primary Key on 'HIG_AUDIT_TYPES'
ALTER TABLE HIG_AUDIT_TYPES
 ADD (CONSTRAINT HAUT_PK PRIMARY KEY
  (HAUT_ID))
/

PROMPT Creating Check Constraint on 'HIG_AUDIT_TYPES'
ALTER TABLE HIG_AUDIT_TYPES
 ADD (CONSTRAINT HAUT_OPERATION_CHK CHECK (haut_operation IN ('Insert','Update','Delete')))
/

PROMPT Creating Foreign Key on 'HIG_AUDIT_TYPES'
ALTER TABLE HIG_AUDIT_TYPES ADD (CONSTRAINT
 HAUT_NIT_FK FOREIGN KEY
  (HAUT_NIT_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))
/

PROMPT Creating Primary Key on 'HIG_AUDIT_ATTRIBUTES'
ALTER TABLE HIG_AUDIT_ATTRIBUTES
 ADD (CONSTRAINT HAAT_PK PRIMARY KEY
  (HAAT_ID))
/

PROMPT Creating Foreign Key on 'HIG_AUDIT_ATTRIBUTES'
ALTER TABLE HIG_AUDIT_ATTRIBUTES ADD (CONSTRAINT
 HAAT_HAUT_FK FOREIGN KEY
  (HAAT_HAUT_ID) REFERENCES HIG_AUDIT_TYPES
  (HAUT_ID))
/

PROMPT Creating Primary Key on 'HIG_AUDIT_CONDITIONS'
ALTER TABLE HIG_AUDIT_CONDITIONS
 ADD (CONSTRAINT HAC_PK PRIMARY KEY
  (HAC_ID))
/

PROMPT Creating Check Constraint on 'HIG_AUDIT_CONDITIONS'
ALTER TABLE HIG_AUDIT_CONDITIONS
 ADD (CONSTRAINT HAC_OLD_NEW_TYPE_CHK CHECK (hac_old_new_type IN ('O','N','B')))
/

PROMPT Creating Foreign Key on 'HIG_AUDIT_CONDITIONS'
ALTER TABLE HIG_AUDIT_CONDITIONS ADD (CONSTRAINT
 HAC_HAUT_FK FOREIGN KEY
  (HAC_HAUT_ID) REFERENCES HIG_AUDIT_TYPES
  (HAUT_ID))
/

PROMPT Creating Primary Key on 'HIG_AUDITS'
ALTER TABLE HIG_AUDITS
 ADD (CONSTRAINT HAUD_PK PRIMARY KEY
  (HAUD_ID))
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Audit - Sequences
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108985
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Audit Sequences
-- 
------------------------------------------------------------------
PROMPT Creating Sequence 'HAUT_ID_SEQ'
CREATE SEQUENCE HAUT_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HAAT_ID_SEQ'
CREATE SEQUENCE HAAT_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HAC_ID_SEQ'
CREATE SEQUENCE HAC_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HAUD_ID_SEQ'
CREATE SEQUENCE HAUD_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Audit - Indexes
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108985
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Audit - Indexes
-- 
------------------------------------------------------------------
PROMPT Creating Index 'HAUT_NIT_FK_IND'
CREATE INDEX HAUT_NIT_FK_IND ON HIG_AUDIT_TYPES
 (HAUT_NIT_INV_TYPE)
/

PROMPT Creating Index 'HAAT_HAUT_FK_IND'
CREATE INDEX HAAT_HAUT_FK_IND ON HIG_AUDIT_ATTRIBUTES
 (HAAT_HAUT_ID)
/

PROMPT Creating Index 'HAC_HAUT_FK_IND'
CREATE INDEX HAC_HAUT_FK_IND ON HIG_AUDIT_CONDITIONS
 (HAC_HAUT_ID)
/

PROMPT Creating Index 'HAUD_PK_ID_IND'
CREATE INDEX HAUD_PK_ID_IND ON HIG_AUDITS
 (HAUD_PK_ID)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Alert - Tables
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108986
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Alert Tables
-- 
------------------------------------------------------------------
PROMPT Creating Table 'HIG_ALERT_RECIPIENT_RULES'
CREATE TABLE HIG_ALERT_RECIPIENT_RULES
 (HARR_ID NUMBER(9) NOT NULL
 ,HARR_NIT_INV_TYPE VARCHAR2(4) NOT NULL
 ,HARR_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL
 ,HARR_LABEL VARCHAR2(30)
 ,HARR_RECIPIENT_TYPE VARCHAR2(30) NOT NULL
 ,HARR_SQL VARCHAR2(4000)
 ,HARR_DATE_CREATED DATE NOT NULL
 ,HARR_CREATED_BY VARCHAR2(30) NOT NULL
 ,HARR_DATE_MODIFIED DATE NOT NULL
 ,HARR_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERT_RECIPIENT_RULES IS 'Defines the rules for deriving recipient email addresses'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_NIT_INV_TYPE IS 'Identifies the asset metamodel to use for deriving a recipient'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_ATTRIBUTE_NAME IS 'The attribute to use for deriving a recipient'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_LABEL IS 'The attribute to describe the Recipient, this will be displayed in the recipient field and the LOV'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_RECIPIENT_TYPE IS 'Defines the method to use for deriving a recipient email. When set to USER_ID the email will be derived from HIG_USERS, when set to HIG_CONTACT the email will be derived from HIG_CONTACTS.'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_SQL IS 'The SQL statement to derive the recipient email address'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENT_RULES.HARR_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_ALERT_TYPES'
CREATE TABLE HIG_ALERT_TYPES
 (HALT_ID NUMBER(9) NOT NULL
 ,HALT_ALERT_TYPE VARCHAR2(1) NOT NULL
 ,HALT_NIT_INV_TYPE VARCHAR2(4) NOT NULL
 ,HALT_TABLE_NAME VARCHAR2(30)
 ,HALT_HQT_ID NUMBER(9)
 ,HALT_DESCRIPTION VARCHAR2(250)
 ,HALT_OPERATION VARCHAR2(20)
 ,HALT_TRIGGER_NAME VARCHAR2(30)
 ,HALT_IMMEDIATE VARCHAR2(1) NOT NULL
 ,HALT_TRIGGER_COUNT NUMBER(9)
 ,HALT_FREQUENCY_ID NUMBER(9)
 ,HALT_LAST_RUN_DATE DATE
 ,HALT_SUSPEND_QUERY VARCHAR2(1) NOT NULL
 ,HALT_DATE_CREATED DATE NOT NULL
 ,HALT_CREATED_BY VARCHAR2(30) NOT NULL
 ,HALT_DATE_MODIFIED DATE NOT NULL
 ,HALT_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERT_TYPES IS 'Defines the types of alerts that have been configured for sending emails'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_ALERT_TYPE IS 'Determines if the alert is generated from a database trigger (T) or saved query (Q)'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_NIT_INV_TYPE IS 'Identifies the asset metamodel used in specifying the alert conditions'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_TABLE_NAME IS 'Identifies the table name on which a database trigger will be executed to generate alerts'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_HQT_ID IS 'Identifies the saved query which will be executed to generate alerts'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_DESCRIPTION IS 'Describes the type of alert and its purpose'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_OPERATION IS 'Determines the database operation on which the trigger will be executed (Insert, Update or Delete)'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_TRIGGER_NAME IS 'The name of the database trigger'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_IMMEDIATE IS 'Specifies whether triggered alerts can be sent immediately (Y or N).  Not allowed in conjunction with counted or scheduled alerts.'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_TRIGGER_COUNT IS 'Specifies an alert count which must be exceeded before triggered alerts are sent.  Not allowed in conjunction with immediate or scheduled alerts.'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_LAST_RUN_DATE IS 'Shows the last date and time on which a query was executed'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_SUSPEND_QUERY IS 'Determines whether a saved query is suspended.  Set to Y to prevent further execution of the query.'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPES.HALT_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_ALERT_TYPE_ATTRIBUTES'
CREATE TABLE HIG_ALERT_TYPE_ATTRIBUTES
 (HATA_ID NUMBER(9) NOT NULL
 ,HATA_HALT_ID NUMBER(9) NOT NULL
 ,HATA_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL
 ,HATA_DATE_CREATED DATE NOT NULL
 ,HATA_CREATED_BY VARCHAR2(30) NOT NULL
 ,HATA_DATE_MODIFIED DATE NOT NULL
 ,HATA_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERT_TYPE_ATTRIBUTES IS 'Defines the database columns that generate trigger based alerts when updated'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_ATTRIBUTES.HATA_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_ATTRIBUTES.HATA_HALT_ID IS 'Identifies the type of alert'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_ATTRIBUTES.HATA_ATTRIBUTE_NAME IS 'The attribute upon which the database trigger is based'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_ATTRIBUTES.HATA_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_ATTRIBUTES.HATA_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_ATTRIBUTES.HATA_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_ATTRIBUTES.HATA_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_ALERT_TYPE_CONDITIONS'
CREATE TABLE HIG_ALERT_TYPE_CONDITIONS
 (HATC_ID NUMBER(9) NOT NULL
 ,HATC_HALT_ID NUMBER(9) NOT NULL
 ,HATC_PRE_BRACKET VARCHAR2(10)
 ,HATC_OPERATOR VARCHAR2(10) NOT NULL
 ,HATC_ATTRIBUTE_NAME VARCHAR2(30) NOT NULL
 ,HATC_CONDITION VARCHAR2(20) NOT NULL
 ,HATC_ATTRIBUTE_VALUE VARCHAR2(500)
 ,HATC_POST_BRACKET VARCHAR2(10)
 ,HATC_OLD_NEW_TYPE VARCHAR2(1) NOT NULL
 ,HATC_DATE_CREATED DATE NOT NULL
 ,HATC_CREATED_BY VARCHAR2(30) NOT NULL
 ,HATC_DATE_MODIFIED DATE NOT NULL
 ,HATC_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERT_TYPE_CONDITIONS IS 'Defines the conditions for generating trigger based alerts'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_HALT_ID IS 'Identifies the type of alert'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_PRE_BRACKET IS 'Opening brackets for an advanced query'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_OPERATOR IS 'The operator to be included in the WHERE clause - must be AND or OR'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_ATTRIBUTE_NAME IS 'The attribute upon which the WHERE clause is based'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_CONDITION IS 'The SQL condition to be included in the WHERE clause  eg =, >, >='
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_ATTRIBUTE_VALUE IS 'The value to be included in the WHERE clause'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_POST_BRACKET IS 'Closing brackets for an advanced query'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_OLD_NEW_TYPE IS 'Specifies whether to reference Old, New or Both values in update triggers - must be O, N or B'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_CONDITIONS.HATC_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_ALERT_TYPE_MAIL'
CREATE TABLE HIG_ALERT_TYPE_MAIL
 (HATM_ID NUMBER(9) NOT NULL
 ,HATM_HALT_ID NUMBER(9) NOT NULL
 ,HATM_SUBJECT VARCHAR2(1000) NOT NULL
 ,HATM_MAIL_TEXT VARCHAR2(4000)
 ,HATM_MAIL_TYPE VARCHAR2(1) NOT NULL
 ,HATM_PARAM_1 VARCHAR2(500)
 ,HATM_PARAM_2 VARCHAR2(500)
 ,HATM_PARAM_3 VARCHAR2(500)
 ,HATM_PARAM_4 VARCHAR2(500)
 ,HATM_PARAM_5 VARCHAR2(500)
 ,HATM_PARAM_6 VARCHAR2(500)
 ,HATM_PARAM_7 VARCHAR2(500)
 ,HATM_PARAM_8 VARCHAR2(500)
 ,HATM_PARAM_9 VARCHAR2(500)
 ,HATM_PARAM_10 VARCHAR2(500)
 ,HATM_DATE_CREATED DATE NOT NULL
 ,HATM_CREATED_BY VARCHAR2(30) NOT NULL
 ,HATM_DATE_MODIFIED DATE NOT NULL
 ,HATM_MODIFIED_BY VARCHAR2(30) NOT NULL
 ,HATM_MAIL_FROM VARCHAR2(100)
 )
/

COMMENT ON TABLE HIG_ALERT_TYPE_MAIL IS 'Defines the mail subject and body for a given type of alert, along with up to 10 parameters for inclusion in the mail'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_HALT_ID IS 'Identifies the type of alert'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_SUBJECT IS 'The text for the mail subject'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_MAIL_TEXT IS 'The text for the mail body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_MAIL_TYPE IS 'The mail format - must be HTML (H) or Plain Text (T)'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_1 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_2 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_3 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_4 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_5 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_6 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_7 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_8 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_9 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_PARAM_10 IS 'Identifies an attribute whose value can be bound into the mail subject and body'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_MAIL.HATM_MODIFIED_BY IS 'Audit details'
/

COMMENT ON COLUMN hig_alert_type_mail.hatm_mail_from IS 'This field will hold the Sender detail, the FROM field in the email Alert will show the data stored in this field.'
/


PROMPT Creating Table 'HIG_ALERT_TYPE_RECIPIENTS'
CREATE TABLE HIG_ALERT_TYPE_RECIPIENTS
 (HATR_ID NUMBER(9) NOT NULL
 ,HATR_HALT_ID NUMBER(9) NOT NULL
 ,HATR_TYPE VARCHAR2(10) NOT NULL
 ,HATR_HARR_ID NUMBER(9)
 ,HATR_NMU_ID NUMBER(9)
 ,HATR_NMG_ID NUMBER(9)
 ,HATR_DATE_CREATED DATE NOT NULL
 ,HATR_CREATED_BY VARCHAR2(30) NOT NULL
 ,HATR_DATE_MODIFIED DATE NOT NULL
 ,HATR_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERT_TYPE_RECIPIENTS IS 'Defines the recipients for a given type of alert'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_HALT_ID IS 'Identifies the type of alert'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_TYPE IS 'Determines the type of recipient - To, Cc or Bcc'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_HARR_ID IS 'The attribute to use when deriving the recipient email address'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_NMU_ID IS 'Identifies a recipient on the NM_MAIL_USERS table'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_NMG_ID IS 'Identifies a group of recipients on the NM_MAIL_GROUPS table'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_TYPE_RECIPIENTS.HATR_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_ALERTS'
CREATE TABLE HIG_ALERTS
 (HAL_ID NUMBER(38) NOT NULL
 ,HAL_HALT_ID NUMBER(9) NOT NULL
 ,HAL_PK_ID VARCHAR2(50) NOT NULL
 ,HAL_SUBJECT VARCHAR2(500) NOT NULL
 ,HAL_MAIL_TEXT VARCHAR2(4000)
 ,HAL_STATUS VARCHAR2(10) NOT NULL
 ,HAL_DATE_CREATED DATE NOT NULL
 ,HAL_CREATED_BY VARCHAR2(30) NOT NULL
 ,HAL_DATE_MODIFIED DATE NOT NULL
 ,HAL_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERTS IS 'Record of actual alerts that have been generated'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_HALT_ID IS 'Identifies the type of alert'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_PK_ID IS 'Identifies the database record which caused the alert'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_SUBJECT IS 'Email subject with bind parameters replaced'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_MAIL_TEXT IS 'Email body with bind parameters replaced'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_STATUS IS 'Flags the alert status as Pending, Running or Completed.  Completed means all recipient emails have completed or failed.'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERTS.HAL_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_ALERT_RECIPIENTS'
CREATE TABLE HIG_ALERT_RECIPIENTS
 (HAR_ID NUMBER(38) NOT NULL
 ,HAR_HATR_ID NUMBER(9) NOT NULL
 ,HAR_HAL_ID NUMBER(38) NOT NULL
 ,HAR_RECIPIENT_EMAIL VARCHAR2(100)
 ,HAR_STATUS VARCHAR(10) NOT NULL
 ,HAR_COMMENTS VARCHAR(4000)
 ,HAR_DATE_CREATED DATE NOT NULL
 ,HAR_CREATED_BY VARCHAR2(30) NOT NULL
 ,HAR_DATE_MODIFIED DATE NOT NULL
 ,HAR_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERT_RECIPIENTS IS 'Record of the recipients on each alert'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_HATR_ID IS 'Identifies the recipient from the alert type'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_HAL_ID IS 'Identifies the alert'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_RECIPIENT_EMAIL IS 'Email address for a particular recipient'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_STATUS IS 'Flags each email as Pending, Failed or Completed.  Pending means the email has not yet been sent.'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_COMMENTS IS 'Comments are automatically recorded when an email cannot be sent'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_RECIPIENTS.HAR_MODIFIED_BY IS 'Audit details'
/

PROMPT Creating Table 'HIG_ALERT_ERROR_LOGS'
CREATE TABLE HIG_ALERT_ERROR_LOGS
 (HAEL_ID NUMBER(38) NOT NULL
 ,HAEL_NIT_INV_TYPE VARCHAR2(4)
 ,HAEL_HAR_ID NUMBER(9)
 ,HAEL_BATCH_NAME VARCHAR2(50)
 ,HAEL_ALERT_DESCRIPTION VARCHAR2(250)
 ,HAEL_PK_ID VARCHAR2(50)
 ,HAEL_DESCRIPTION VARCHAR2(4000)
 ,HAEL_DATE_CREATED DATE NOT NULL
 ,HAEL_CREATED_BY VARCHAR2(30) NOT NULL
 ,HAEL_DATE_MODIFIED DATE NOT NULL
 ,HAEL_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

COMMENT ON TABLE HIG_ALERT_ERROR_LOGS IS 'Record of email failures'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_ID IS 'Unique identifier generated from a sequence'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_NIT_INV_TYPE IS 'Identifies the asset metamodel for the alert type'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_HAR_ID IS 'Identifies the email recipient'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_BATCH_NAME IS 'Not currently used'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_ALERT_DESCRIPTION IS 'Description of the failed alert'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_PK_ID IS 'Identifies the database record which caused the alert'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_DESCRIPTION IS 'Email body with bind parameters replaced'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_DATE_CREATED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_CREATED_BY IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_DATE_MODIFIED IS 'Audit details'
/

COMMENT ON COLUMN HIG_ALERT_ERROR_LOGS.HAEL_MODIFIED_BY IS 'Audit details'
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Alert - Constraints
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108986
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Alert Constraints
-- 
------------------------------------------------------------------
PROMPT Creating Primary Key on 'HIG_ALERT_RECIPIENT_RULES'
ALTER TABLE HIG_ALERT_RECIPIENT_RULES
 ADD (CONSTRAINT HARR_PK PRIMARY KEY
  (HARR_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_RECIPIENT_RULES'
ALTER TABLE HIG_ALERT_RECIPIENT_RULES ADD (CONSTRAINT
 HARR_ITA_FK FOREIGN KEY
  (HARR_NIT_INV_TYPE
  ,HARR_ATTRIBUTE_NAME) REFERENCES NM_INV_TYPE_ATTRIBS_ALL
  (ITA_INV_TYPE
  ,ITA_ATTRIB_NAME))
/

PROMPT Creating Primary Key on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES
 ADD (CONSTRAINT HALT_PK PRIMARY KEY
  (HALT_ID))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES
 ADD (CONSTRAINT HALT_ALERT_TYPE_CHK CHECK (halt_alert_type IN ('T','Q')))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES
 ADD (CONSTRAINT HALT_IMMEDIATE_CHK CHECK (halt_immediate IN ('Y','N')))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES
 ADD (CONSTRAINT HALT_OPERATION_CHK CHECK (halt_operation IN ('Insert','Update','Delete')))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES
 ADD (CONSTRAINT HALT_SCHEDULE_DTLS_CHK CHECK ((halt_immediate = 'Y'
AND Nvl(halt_frequency_id,Nvl(halt_trigger_count,0)) = 0 )
OR ( halt_immediate = 'N'
AND Nvl(halt_frequency_id,Nvl(halt_trigger_count,0)) != 0 )))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES
 ADD (CONSTRAINT HALT_SUSPEND_QUERY_CHK CHECK (halt_suspend_query IN ('Y','N')))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES ADD (CONSTRAINT
 HALT_HQT_FK FOREIGN KEY
  (HALT_HQT_ID) REFERENCES HIG_QUERY_TYPES
  (HQT_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES ADD (CONSTRAINT
 HALT_HSFR_FK FOREIGN KEY
  (HALT_FREQUENCY_ID) REFERENCES HIG_SCHEDULING_FREQUENCIES
  (HSFR_FREQUENCY_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPES'
ALTER TABLE HIG_ALERT_TYPES ADD (CONSTRAINT
 HALT_NIT_FK FOREIGN KEY
  (HALT_NIT_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))
/

PROMPT Creating Primary Key on 'HIG_ALERT_TYPE_ATTRIBUTES'
ALTER TABLE HIG_ALERT_TYPE_ATTRIBUTES
 ADD (CONSTRAINT HATA_PK PRIMARY KEY
  (HATA_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPE_ATTRIBUTES'
ALTER TABLE HIG_ALERT_TYPE_ATTRIBUTES ADD (CONSTRAINT
 HATA_HALT_FK FOREIGN KEY
  (HATA_HALT_ID) REFERENCES HIG_ALERT_TYPES
  (HALT_ID))
/

PROMPT Creating Primary Key on 'HIG_ALERT_TYPE_CONDITIONS'
ALTER TABLE HIG_ALERT_TYPE_CONDITIONS
 ADD (CONSTRAINT HATC_PK PRIMARY KEY
  (HATC_ID))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPE_CONDITIONS'
ALTER TABLE HIG_ALERT_TYPE_CONDITIONS
 ADD (CONSTRAINT HATC_OLD_NEW_TYPE_CHK CHECK (hatc_old_new_type IN ('O','N','B')))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPE_CONDITIONS'
ALTER TABLE HIG_ALERT_TYPE_CONDITIONS ADD (CONSTRAINT
 HATC_HALT_FK FOREIGN KEY
  (HATC_HALT_ID) REFERENCES HIG_ALERT_TYPES
  (HALT_ID))
/

PROMPT Creating Primary Key on 'HIG_ALERT_TYPE_RECIPIENTS'
ALTER TABLE HIG_ALERT_TYPE_RECIPIENTS
 ADD (CONSTRAINT HATR_PK PRIMARY KEY
  (HATR_ID))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPE_RECIPIENTS'
ALTER TABLE HIG_ALERT_TYPE_RECIPIENTS
 ADD (CONSTRAINT HATR_1_RECIPIENT_MAND_CHK CHECK (Nvl(hatr_harr_id,NVl(hatr_nmu_id,Nvl(hatr_nmg_id,-1))) != -1))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPE_RECIPIENTS'
ALTER TABLE HIG_ALERT_TYPE_RECIPIENTS
 ADD (CONSTRAINT HATR_TYPE_CHK CHECK (hatr_type IN ('To :','Cc :','Bcc :')))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPE_RECIPIENTS'
ALTER TABLE HIG_ALERT_TYPE_RECIPIENTS ADD (CONSTRAINT
 HATR_HALT_FK FOREIGN KEY
  (HATR_HALT_ID) REFERENCES HIG_ALERT_TYPES
  (HALT_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPE_RECIPIENTS'
ALTER TABLE HIG_ALERT_TYPE_RECIPIENTS ADD (CONSTRAINT
 HATR_HARR_FK FOREIGN KEY
  (HATR_HARR_ID) REFERENCES HIG_ALERT_RECIPIENT_RULES
  (HARR_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPE_RECIPIENTS'
ALTER TABLE HIG_ALERT_TYPE_RECIPIENTS ADD (CONSTRAINT
 HATR_NMG_FK FOREIGN KEY
  (HATR_NMG_ID) REFERENCES NM_MAIL_GROUPS
  (NMG_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPE_RECIPIENTS'
ALTER TABLE HIG_ALERT_TYPE_RECIPIENTS ADD (CONSTRAINT
 HATR_NMU_FK FOREIGN KEY
  (HATR_NMU_ID) REFERENCES NM_MAIL_USERS
  (NMU_ID))
/

PROMPT Creating Primary Key on 'HIG_ALERT_TYPE_MAIL'
ALTER TABLE HIG_ALERT_TYPE_MAIL
 ADD (CONSTRAINT HATM_PK PRIMARY KEY
  (HATM_ID))
/

PROMPT Creating Check Constraint on 'HIG_ALERT_TYPE_MAIL'
ALTER TABLE HIG_ALERT_TYPE_MAIL
 ADD (CONSTRAINT HATM_MAIL_TYPE_CHK CHECK (hatm_mail_type IN ('T','H')))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_TYPE_MAIL'
ALTER TABLE HIG_ALERT_TYPE_MAIL ADD (CONSTRAINT
 HATM_HALT_FK FOREIGN KEY
  (HATM_HALT_ID) REFERENCES HIG_ALERT_TYPES
  (HALT_ID))
/

PROMPT Creating Primary Key on 'HIG_ALERTS'
ALTER TABLE HIG_ALERTS
 ADD (CONSTRAINT HAL_PK PRIMARY KEY
  (HAL_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERTS'
ALTER TABLE HIG_ALERTS ADD (CONSTRAINT
 HAL_HALT_FK FOREIGN KEY
  (HAL_HALT_ID) REFERENCES HIG_ALERT_TYPES
  (HALT_ID))
/

PROMPT Creating Primary Key on 'HIG_ALERT_RECIPIENTS'
ALTER TABLE HIG_ALERT_RECIPIENTS
 ADD (CONSTRAINT HAR_PK PRIMARY KEY
  (HAR_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_RECIPIENTS'
ALTER TABLE HIG_ALERT_RECIPIENTS ADD (CONSTRAINT
 HAR_HAL_FK FOREIGN KEY
  (HAR_HAL_ID) REFERENCES HIG_ALERTS
  (HAL_ID))
/

PROMPT Creating Primary Key on 'HIG_ALERT_ERROR_LOGS'
ALTER TABLE HIG_ALERT_ERROR_LOGS
 ADD (CONSTRAINT HAEL_PK PRIMARY KEY
  (HAEL_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_ERROR_LOGS'
ALTER TABLE HIG_ALERT_ERROR_LOGS ADD (CONSTRAINT
 HAEL_HAR_FK FOREIGN KEY
  (HAEL_HAR_ID) REFERENCES HIG_ALERT_RECIPIENTS
  (HAR_ID))
/

PROMPT Creating Foreign Key on 'HIG_ALERT_ERROR_LOGS'
ALTER TABLE HIG_ALERT_ERROR_LOGS ADD (CONSTRAINT
 HAEL_NIT_FK FOREIGN KEY
  (HAEL_NIT_INV_TYPE) REFERENCES NM_INV_TYPES_ALL
  (NIT_INV_TYPE))
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Alert - Sequences
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108986
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Alert Sequences
-- 
------------------------------------------------------------------
PROMPT Creating Sequence 'HARR_ID_SEQ'
CREATE SEQUENCE HARR_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'HALT_ID_SEQ'
CREATE SEQUENCE HALT_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HATA_ID_SEQ'
CREATE SEQUENCE HATA_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HATC_ID_SEQ'
CREATE SEQUENCE HATC_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HATR_ID_SEQ'
CREATE SEQUENCE HATR_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/


PROMPT Creating Sequence 'HATM_ID_SEQ'
CREATE SEQUENCE HATM_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

PROMPT Creating Sequence 'HAL_ID_SEQ'
CREATE SEQUENCE HAL_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'HAR_ID_SEQ'
CREATE SEQUENCE HAR_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

PROMPT Creating Sequence 'HAEL_ID_SEQ'
CREATE SEQUENCE HAEL_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Alert - Indexes
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108986
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Alert Indexes
-- 
------------------------------------------------------------------
PROMPT Creating Index 'HAL_HALT_ID_PK_ID_IND'
CREATE INDEX HAL_HALT_ID_PK_ID_IND ON HIG_ALERTS
 (HAL_HALT_ID
 ,HAL_PK_ID)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Increased length of ITA_QUERY
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109336
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Increase length of ITA_QUERY
-- 
------------------------------------------------------------------
begin
EXECUTE IMMEDIATE ('ALTER TABLE nm_inv_type_attribs_all MODIFY (ita_query Varchar2(4000) )');
end ;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT hig_status_codes extra feature flag.
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109186
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (MIKE HUITSON)
-- Additional feature flag column to be used with WOL and Defect Status Codes.
-- 
------------------------------------------------------------------
BEGIN
  /*
  ||Alter hig_status_domains.
  */
  EXECUTE IMMEDIATE 'ALTER TABLE hig_status_domains ADD(hsd_feature10 VARCHAR2(254))';
  --
  EXECUTE IMMEDIATE 'UPDATE hig_status_domains SET hsd_feature10 = ''Not Used''';
  --
  COMMIT;
  --
  EXECUTE IMMEDIATE 'ALTER TABLE hig_status_domains MODIFY(hsd_feature10 VARCHAR2(254) NOT NULL)';
  /*
  ||Alter hig_status_domains.
  */
  EXECUTE IMMEDIATE 'ALTER TABLE hig_status_codes ADD(hsc_allow_feature10 VARCHAR2(1))';
  --
  EXECUTE IMMEDIATE 'UPDATE hig_status_codes SET hsc_allow_feature10 = ''N''';
  --
  COMMIT;
  --
  EXECUTE IMMEDIATE 'ALTER TABLE hig_status_codes MODIFY(hsc_allow_feature10 VARCHAR2(1) NOT NULL)';
  --
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Process Alert Log
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New meta model to trigger process alerts
-- 
------------------------------------------------------------------
PROMPT Creating Table 'hig_process_alert_log'
CREATE TABLE hig_process_alert_log(
 hpal_id              NUMBER(38)  NOT NULL
,hpal_success_flag    VARCHAR2(1) NOT NULL
,hpal_process_type_id NUMBER(38)
,hpal_process_id      NUMBER(38)
,hpal_job_run_seq     NUMBER(38) 
,hpal_admin_unit      NUMBER(9) 
,hpal_unit_code       VARCHAR2(10)
,hpal_unit_name       VARCHAR2(40)
,hpal_initiated_user  VARCHAR2(30)
,hpal_con_code        VARCHAR2(10)
,hpal_con_name        VARCHAR2(40)
,hpal_contract_id     VARCHAR2(10)    
,hpal_email_subject   VARCHAR2(1000)
,hpal_email_body      VARCHAR2(1000)
);

ALTER TABLE hig_process_alert_log Add (Constraint hpal_pk Primary Key  (hpal_id));

ALTER TABLE hig_process_alert_log Add (Constraint hpal_hpal_success_flag_chk Check (hpal_success_flag IN ('Y','N','I')));

PROMPT Creating Foreign Key on 'HIG_PROCESS_ALERT_LOG'
ALTER TABLE HIG_PROCESS_ALERT_LOG ADD (CONSTRAINT
 HPAL_HPT_FK FOREIGN KEY
  (HPAL_PROCESS_TYPE_ID) REFERENCES HIG_PROCESS_TYPES
  (HPT_PROCESS_TYPE_ID) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'HIG_PROCESS_ALERT_LOG'
ALTER TABLE HIG_PROCESS_ALERT_LOG ADD (CONSTRAINT
 HPAL_HP_FK FOREIGN KEY
  (HPAL_PROCESS_ID) REFERENCES HIG_PROCESSES
  (HP_PROCESS_ID) ON DELETE CASCADE)
/

CREATE INDEX hpa_hpt_fk_ind ON hig_process_alert_log (hpal_process_type_id);

CREATE INDEX hpa_hp_fk_ind ON hig_process_alert_log (hpal_process_id);

COMMENT ON TABLE HIG_PROCESS_ALERT_LOG IS 'A log of process events which may be used to trigger alert emails.  These will typically be used to warn of process failures.'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_id  IS 'Unique identifier generated from a sequence'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_success_flag  IS 'Flag to indicate the status of the alert log'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_process_type_id IS 'Process Type identifier'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_process_id IS 'Process Identifier'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_job_run_seq IS 'The execution iteration of the given process.'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_admin_unit IS 'Admin Unit'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_unit_code IS 'Admin Unit Code'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_unit_name IS 'Admin Unit Name'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_initiated_user IS 'Process Initiator'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_con_code IS 'Contractor code'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_con_name IS 'Contractor Name'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_contract_id IS 'Contractor Id'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_email_subject IS 'Text that can be used as parameter in Alert configuration'
/
COMMENT ON COLUMN hig_process_alert_log.hpal_email_body IS 'Text that can be used as parameter in Alert configuration'
/

Create Sequence hpal_id_seq ;
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator/Audit/Alert FKand composite Indexes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator/Audit/Alert FK Indexes
-- 
------------------------------------------------------------------
CREATE INDEX hal_halt_fk_ind ON HIG_ALERTS(hal_halt_id);

CREATE INDEX hael_nit_fk_ind ON HIG_ALERT_ERROR_LOGS(hael_nit_inv_type);

CREATE INDEX hael_har_fk_ind ON HIG_ALERT_ERROR_LOGS(hael_har_id);

CREATE INDEX har_hal_fk_ind ON HIG_ALERT_RECIPIENTS(har_hal_id);

CREATE INDEX har_hatr_fk_ind ON HIG_ALERT_RECIPIENTS(har_hatr_id);

CREATE INDEX harr_ita_fk_ind ON HIG_ALERT_RECIPIENT_RULES(harr_nit_inv_type,harr_attribute_name);

CREATE INDEX halt_nit_fk_ind ON HIG_ALERT_TYPES(halt_nit_inv_type);

CREATE INDEX halt_hsfr_fk_ind ON HIG_ALERT_TYPES(halt_frequency_id);

CREATE INDEX halt_hqt_fk_ind ON HIG_ALERT_TYPES(halt_hqt_id);

CREATE INDEX hata_halt_fk_ind ON HIG_ALERT_TYPE_ATTRIBUTES(hata_halt_id);

CREATE INDEX hatc_halt_fk_ind ON HIG_ALERT_TYPE_CONDITIONS(hatc_halt_id);

CREATE INDEX hatm_halt_fk_ind ON HIG_ALERT_TYPE_MAIL(hatm_halt_id);

CREATE INDEX hatr_halt_fk_ind ON HIG_ALERT_TYPE_RECIPIENTS(hatr_halt_id);

CREATE INDEX hatr_nmu_fk_ind ON HIG_ALERT_TYPE_RECIPIENTS(hatr_nmu_id);

CREATE INDEX hatr_nmg_fk_ind ON HIG_ALERT_TYPE_RECIPIENTS(hatr_nmg_id);

CREATE INDEX hatr_harr_fk_ind ON HIG_ALERT_TYPE_RECIPIENTS(hatr_harr_id);

CREATE INDEX hfam_nit_fk_ind ON HIG_FLEX_ATTRIBUTE_INV_MAPPING(hfam_nit_inv_type); 

CREATE INDEX hfam_hfa_fk_ind ON HIG_FLEX_ATTRIBUTE_INV_MAPPING(hfam_hfa_id); 

CREATE INDEX hnm_hmo_fk_ind ON HIG_NAVIGATOR_MODULES(hnm_module_name); 

CREATE INDEX hnm_nit_fk_ind ON HIG_QUERY_TYPES(hqt_nit_inv_type); 

CREATE INDEX hnm_hqt_fk_ind ON HIG_QUERY_TYPE_ATTRIBUTES(hqta_hqt_id);

CREATE INDEX hal_halt_id_hal_status_ind ON HIG_ALERTS(hal_halt_id,hal_status);

CREATE INDEX har_har_id_har_status_ind ON HIG_ALERT_RECIPIENTS(har_hal_id,har_status);

CREATE INDEX haud_inv_type_pk_id_ind ON HIG_AUDITS(haud_nit_inv_type,haud_pk_id);


------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

