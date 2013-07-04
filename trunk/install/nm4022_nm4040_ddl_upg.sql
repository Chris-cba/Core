------------------------------------------------------------------
-- nm4022_nm4040_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4022_nm4040_ddl_upg.sql-arc   2.6   Jul 04 2013 14:10:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4022_nm4040_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:10:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   2.6  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Tab/Seq/Ind/Con for Linking technology
SET TERM OFF

-- SSC  19-DEC-2007
-- 
-- DEVELOPMENT COMMENTS
-- Tables for Linking (originally created in PROW v4020) moved into Core.
-- HIG_MODULE_BLOCKS
-- HIG_MODULE_LINKS
-- HIG_MODULE_LINK_METHODS
-- HIG_MODULE_LINK_CALLS
-- 
-- These tables will be dropped and then re-created.  Any products which require data in these tables (currently only PROW and TMA) will need to popuate the data in these tables on Install (TMA) or on upgrade (PROW).
------------------------------------------------------------------
--
-- Drop existing tables
--
DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-942);
BEGIN
 EXECUTE IMMEDIATE('DROP TABLE HIG_MODULE_LINK_CALLS');
EXCEPTION
 WHEN ex_not_exists THEN
    Null;
 WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,sqlerrm);
END;
/

DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-942);
BEGIN
 EXECUTE IMMEDIATE('DROP TABLE HIG_MODULE_LINK_METHODS');
EXCEPTION
 WHEN ex_not_exists THEN
    Null;
 WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,sqlerrm);
END;
/

DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-942);
BEGIN
 EXECUTE IMMEDIATE('DROP TABLE HIG_MODULE_LINKS');
EXCEPTION
 WHEN ex_not_exists THEN
    Null;
 WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,sqlerrm);
END;
/

DECLARE
  ex_not_exists exception;
  pragma exception_init(ex_not_exists,-942);
BEGIN
 EXECUTE IMMEDIATE('DROP TABLE HIG_MODULE_BLOCKS');
EXCEPTION
 WHEN ex_not_exists THEN
    Null;
 WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,sqlerrm);
END;
/

--
-- Create New Tables
--
PROMPT Creating Table 'HIG_MODULE_BLOCKS'
CREATE TABLE HIG_MODULE_BLOCKS
 (HMB_MODULE_NAME VARCHAR2(30) NOT NULL
 ,HMB_BLOCK_NAME VARCHAR2(30) NOT NULL
 ,HMB_DATE_CREATED DATE NOT NULL
 ,HMB_DATE_MODIFIED DATE NOT NULL
 ,HMB_CREATED_BY VARCHAR2(30) NOT NULL
 ,HMB_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Table 'HIG_MODULE_LINKS'
CREATE TABLE HIG_MODULE_LINKS
 (HML_ID NUMBER(9) NOT NULL
 ,HML_MODULE_NAME_FROM VARCHAR2(30) NOT NULL
 ,HML_BLOCK_NAME_FROM VARCHAR2(30) NOT NULL
 ,HML_MODULE_NAME_TO VARCHAR2(30) NOT NULL
 ,HML_BLOCK_NAME_TO VARCHAR2(30) NOT NULL
 ,HML_FORCE_COMMIT VARCHAR2(1) DEFAULT 'N' NOT NULL
 ,HML_MENU_ITEM_LABEL VARCHAR2(50) NOT NULL
 ,HML_SHOW_ON_MENU VARCHAR2(1) DEFAULT 'Y' NOT NULL
 ,HML_DATE_CREATED DATE NOT NULL
 ,HML_DATE_MODIFIED DATE NOT NULL
 ,HML_CREATED_BY VARCHAR2(30) NOT NULL
 ,HML_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Table 'HIG_MODULE_LINK_CALLS'
CREATE TABLE HIG_MODULE_LINK_CALLS
 (HMLC_ID NUMBER(9) NOT NULL
 ,HMLC_METHOD_ID NUMBER(9) NOT NULL
 ,HMLC_PARAM_FROM_VALUE VARCHAR2(4000)
 ,HMLC_PARAM_FROM_FORMAT_MASK VARCHAR2(100)
 ,HMLC_CALLED_BLOCK_WHERE VARCHAR2(4000)
 ,HMLC_DATE_CREATED DATE NOT NULL
 ,HMLC_CREATED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Table 'HIG_MODULE_LINK_METHODS'
CREATE TABLE HIG_MODULE_LINK_METHODS
 (HMLM_ID NUMBER(9) NOT NULL
 ,HMLM_MODULE_LINK_ID NUMBER(9) NOT NULL
 ,HMLM_PARAM_FROM VARCHAR2(50) NOT NULL
 ,HMLM_PARAM_FROM_TYPE VARCHAR2(20) NOT NULL
 ,HMLM_PARAM_TO VARCHAR2(50) NOT NULL
 ,HMLM_PARAM_TO_TYPE VARCHAR2(20) NOT NULL
 ,HMLM_METHOD_SQL VARCHAR2(4000) NOT NULL
 ,HMLM_DATE_CREATED DATE NOT NULL
 ,HMLM_DATE_MODIFIED DATE NOT NULL
 ,HMLM_CREATED_BY VARCHAR2(30) NOT NULL
 ,HMLM_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

--
-- Create New Sequences
--
DECLARE
  ex_exists exception;
  pragma exception_init(ex_exists,-955);
BEGIN
 EXECUTE IMMEDIATE('CREATE SEQUENCE HMLC_ID_SEQ
                                    NOMAXVALUE
                                    NOMINVALUE
                                    NOCYCLE
                                    NOCACHE');
EXCEPTION
 WHEN ex_exists THEN
    Null;
 WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,sqlerrm);
END;
/

--
-- Create New Indexes
--

/* No Indexes */

--
-- Create New Constraints
--
PROMPT Creating Primary Key on 'HIG_MODULE_BLOCKS'
ALTER TABLE HIG_MODULE_BLOCKS
 ADD (CONSTRAINT HMB_PK PRIMARY KEY 
  (HMB_MODULE_NAME
  ,HMB_BLOCK_NAME))
/

PROMPT Creating Primary Key on 'HIG_MODULE_LINKS'
ALTER TABLE HIG_MODULE_LINKS
 ADD (CONSTRAINT HML_PK PRIMARY KEY 
  (HML_ID))
/

PROMPT Creating Primary Key on 'HIG_MODULE_LINK_CALLS'
ALTER TABLE HIG_MODULE_LINK_CALLS
 ADD (CONSTRAINT HMLC_PK PRIMARY KEY 
  (HMLC_ID))
/

PROMPT Creating Primary Key on 'HIG_MODULE_LINK_METHODS'
ALTER TABLE HIG_MODULE_LINK_METHODS
 ADD (CONSTRAINT HMLM_PK PRIMARY KEY 
  (HMLM_ID))
/

PROMPT Creating Unique Key on 'HIG_MODULE_LINKS'
ALTER TABLE HIG_MODULE_LINKS
 ADD (CONSTRAINT HML_UK UNIQUE 
  (HML_MODULE_NAME_FROM
  ,HML_BLOCK_NAME_FROM
  ,HML_MENU_ITEM_LABEL))
/

PROMPT Creating Unique Key on 'HIG_MODULE_LINK_METHODS'
ALTER TABLE HIG_MODULE_LINK_METHODS
 ADD (CONSTRAINT HMLM_UK1 UNIQUE 
  (HMLM_MODULE_LINK_ID
  ,HMLM_PARAM_FROM
  ,HMLM_PARAM_TO))
/

PROMPT Creating Check Constraint on 'HIG_MODULE_LINKS'
ALTER TABLE HIG_MODULE_LINKS
 ADD (CONSTRAINT HML_FORCE_COMMIT_CHK CHECK (hml_force_commit in ('Y','N')))
/

PROMPT Creating Check Constraint on 'HIG_MODULE_LINKS'
ALTER TABLE HIG_MODULE_LINKS
 ADD (CONSTRAINT HML_SHOW_ON_MENU_CHK CHECK (HML_SHOW_ON_MENU IN ('Y','N')))
/
  
PROMPT Creating Check Constraint on 'HIG_MODULE_LINK_METHODS'
ALTER TABLE HIG_MODULE_LINK_METHODS
 ADD (CONSTRAINT HMLM_CK1 CHECK (hmlm_param_from_type in ('DATE','NUMBER','VARCHAR2')))
/

PROMPT Creating Check Constraint on 'HIG_MODULE_LINK_METHODS'
ALTER TABLE HIG_MODULE_LINK_METHODS
 ADD (CONSTRAINT HMLM_CK2 CHECK (hmlm_param_to_type in ('DATE','NUMBER','VARCHAR2')))
/

PROMPT Creating Foreign Key on 'HIG_MODULE_BLOCKS'
ALTER TABLE HIG_MODULE_BLOCKS ADD (CONSTRAINT
 HMB_HMO_FK FOREIGN KEY 
  (HMB_MODULE_NAME) REFERENCES HIG_MODULES
  (HMO_MODULE))
/

PROMPT Creating Foreign Key on 'HIG_MODULE_LINKS'
ALTER TABLE HIG_MODULE_LINKS ADD (CONSTRAINT
 HML_HMB_FK1 FOREIGN KEY 
  (HML_MODULE_NAME_FROM
  ,HML_BLOCK_NAME_FROM) REFERENCES HIG_MODULE_BLOCKS
  (HMB_MODULE_NAME
  ,HMB_BLOCK_NAME))
/

PROMPT Creating Foreign Key on 'HIG_MODULE_LINKS'
ALTER TABLE HIG_MODULE_LINKS ADD (CONSTRAINT
 HML_HMB_FK2 FOREIGN KEY 
  (HML_MODULE_NAME_TO
  ,HML_BLOCK_NAME_TO) REFERENCES HIG_MODULE_BLOCKS
  (HMB_MODULE_NAME
  ,HMB_BLOCK_NAME))
/

PROMPT Creating Foreign Key on 'HIG_MODULE_LINK_CALLS'
ALTER TABLE HIG_MODULE_LINK_CALLS ADD (CONSTRAINT
 HMLC_HMLM_FK FOREIGN KEY 
  (HMLC_METHOD_ID) REFERENCES HIG_MODULE_LINK_METHODS
  (HMLM_ID))
/

PROMPT Creating Foreign Key on 'HIG_MODULE_LINK_METHODS'
ALTER TABLE HIG_MODULE_LINK_METHODS ADD (CONSTRAINT
 HMLM_HML_FK FOREIGN KEY 
  (HMLM_MODULE_LINK_ID) REFERENCES HIG_MODULE_LINKS
  (HML_ID))
/

--
-- Populate the tables with NM3 linking data
-- Other Products using Linking will have to populate the data
-- in their own install/upgrade scripts

/* No data to populate */


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Tab/Seq/Ind/Con for Standard Text technology
SET TERM OFF

-- SSC  19-DEC-2007
-- 
-- DEVELOPMENT COMMENTS
-- Standard Text Technology has been added.
-- This will create the tables, constraints, indexes and sequences.
------------------------------------------------------------------
------------------------------------
-- tables
------------------------------------
PROMPT Creating Table 'HIG_STANDARD_TEXT'
CREATE TABLE HIG_STANDARD_TEXT
 (HST_TEXT_ID NUMBER(9) NOT NULL
 ,HST_MODULE_ITEM_ID NUMBER(9) NOT NULL
 ,HST_DATE_CREATED DATE NOT NULL
 ,HST_DATE_MODIFIED DATE NOT NULL
 ,HST_CREATED_BY VARCHAR2(30) NOT NULL
 ,HST_MODIFIED_BY VARCHAR2(30) NOT NULL
 ,HST_TEXT VARCHAR2(500) NOT NULL
 )
/

PROMPT Creating Table 'HIG_MODULE_ITEMS'
CREATE TABLE HIG_MODULE_ITEMS
 (HMI_MODULE_ITEM_ID NUMBER(9) NOT NULL
 ,HMI_MODULE_NAME VARCHAR2(30) NOT NULL
 ,HMI_BLOCK_NAME VARCHAR2(30) NOT NULL
 ,HMI_ITEM_NAME VARCHAR2(30) NOT NULL
 ,HMI_TABLE_NAME VARCHAR2(30) NOT NULL
 ,HMI_COLUMN_NAME VARCHAR2(30) NOT NULL
 ,HMI_FIELD_DESC VARCHAR2(30) NOT NULL
 ,HMI_DATE_CREATED DATE NOT NULL
 ,HMI_DATE_MODIFIED DATE NOT NULL
 ,HMI_CREATED_BY VARCHAR2(30) NOT NULL
 ,HMI_MODIFIED_BY VARCHAR2(30) NOT NULL
 )
/

PROMPT Creating Table 'HIG_STANDARD_TEXT_USAGE'
CREATE TABLE HIG_STANDARD_TEXT_USAGE
 (HSTU_USER_ID NUMBER(9) NOT NULL
 ,HSTU_MODULE_ITEM_ID NUMBER(9) NOT NULL
 ,HSTU_TEXT_ID NUMBER(9) NOT NULL
 ,HSTU_TOP_RANKING VARCHAR2(1) NOT NULL
 )
/

------------------------------------
-- sequences
------------------------------------
PROMPT Creating Sequence 'HST_TEXT_ID_SEQ'
CREATE SEQUENCE HST_TEXT_ID_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
 NOCACHE
/

------------------------------------
-- indexs
------------------------------------
PROMPT Creating Index 'HST_HMI_FK_IND'
CREATE INDEX HST_HMI_FK_IND ON HIG_STANDARD_TEXT
 (HST_MODULE_ITEM_ID)
/

PROMPT Creating Index 'HSTU_HMI_FK_IND'
CREATE INDEX HSTU_HMI_FK_IND ON HIG_STANDARD_TEXT_USAGE
 (HSTU_MODULE_ITEM_ID)
/

PROMPT Creating Index 'HSTU_HST_FK_IND'
CREATE INDEX HSTU_HST_FK_IND ON HIG_STANDARD_TEXT_USAGE
 (HSTU_TEXT_ID)
/

------------------------------------
-- constraints
------------------------------------
PROMPT Creating Primary Key on 'HIG_STANDARD_TEXT'
ALTER TABLE HIG_STANDARD_TEXT
 ADD (CONSTRAINT HST_PK PRIMARY KEY 
  (HST_TEXT_ID))
/

PROMPT Creating Primary Key on 'HIG_STANDARD_TEXT_USAGE'
ALTER TABLE HIG_STANDARD_TEXT_USAGE
 ADD (CONSTRAINT HSTU_PK PRIMARY KEY 
  (HSTU_USER_ID
  ,HSTU_MODULE_ITEM_ID
  ,HSTU_TEXT_ID))
/

PROMPT Creating Primary Key on 'HIG_MODULE_ITEMS'
ALTER TABLE HIG_MODULE_ITEMS
 ADD (CONSTRAINT HMI_PK PRIMARY KEY 
  (HMI_MODULE_ITEM_ID))
/

PROMPT Creating Unique Key on 'HIG_MODULE_ITEMS'
ALTER TABLE HIG_MODULE_ITEMS
 ADD (CONSTRAINT HMI_UK UNIQUE 
  (HMI_MODULE_NAME
  ,HMI_BLOCK_NAME
  ,HMI_ITEM_NAME))
/

PROMPT Creating Check Constraint on 'HIG_STANDARD_TEXT_USAGE'
ALTER TABLE HIG_STANDARD_TEXT_USAGE
 ADD (CONSTRAINT HSTU_TOP_RANKING_CHK CHECK (HSTU_TOP_RANKING IN ('Y','N')))
/

PROMPT Creating Foreign Key on 'HIG_STANDARD_TEXT'
ALTER TABLE HIG_STANDARD_TEXT ADD (CONSTRAINT
 HST_HMI_FK FOREIGN KEY 
  (HST_MODULE_ITEM_ID) REFERENCES HIG_MODULE_ITEMS
  (HMI_MODULE_ITEM_ID))
/

PROMPT Creating Foreign Key on 'HIG_STANDARD_TEXT_USAGE'
ALTER TABLE HIG_STANDARD_TEXT_USAGE ADD (CONSTRAINT
 HSTU_HMI_FK FOREIGN KEY 
  (HSTU_MODULE_ITEM_ID) REFERENCES HIG_MODULE_ITEMS
  (HMI_MODULE_ITEM_ID))
/

PROMPT Creating Foreign Key on 'HIG_STANDARD_TEXT_USAGE'
ALTER TABLE HIG_STANDARD_TEXT_USAGE ADD (CONSTRAINT
 HSTU_HUS_FK FOREIGN KEY 
  (HSTU_USER_ID) REFERENCES HIG_USERS
  (HUS_USER_ID))
/

PROMPT Creating Foreign Key on 'HIG_STANDARD_TEXT_USAGE'
ALTER TABLE HIG_STANDARD_TEXT_USAGE ADD (CONSTRAINT
 HSTU_HST_FK FOREIGN KEY 
  (HSTU_TEXT_ID) REFERENCES HIG_STANDARD_TEXT
  (HST_TEXT_ID))
/

PROMPT Creating Foreign Key on 'HIG_MODULE_ITEMS'
ALTER TABLE HIG_MODULE_ITEMS ADD (CONSTRAINT
 HMI_HMB_FK FOREIGN KEY 
  (HMI_MODULE_NAME
  ,HMI_BLOCK_NAME) REFERENCES HIG_MODULE_BLOCKS
  (HMB_MODULE_NAME
  ,HMB_BLOCK_NAME))
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_THEMES_ALL add missing default values
SET TERM OFF

-- SSC  17-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- NM-THEMES_ALL was missing default values on 3 columns.
-- These have been added here.
------------------------------------------------------------------
alter table nm_themes_all modify NTH_LREF_MANDATORY default 'N'
/

alter table nm_themes_all modify NTH_USE_HISTORY default 'N'
/

alter table nm_themes_all modify nth_location_updatable default 'N'
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New sequence GRS_LINE_NO_SEQ
SET TERM OFF

-- JWA  23-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- New sequence required for higgrip.
------------------------------------------------------------------
CREATE SEQUENCE GRS_LINE_NO_SEQ
 START WITH 1
 MAXVALUE 999999
 MINVALUE 1
 CYCLE
 NOCACHE
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM0575 Matching Records
SET TERM OFF

-- JWA  23-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- Creating temporary table
------------------------------------------------------------------
drop view nm0575_matching_records
/
create global temporary table nm0575_matching_records
(
  asset_category    varchar2(1),
  asset_type        varchar2(4),
  asset_type_descr  varchar2(80),
  asset_count       number
)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop GRS_PK Constraint
SET TERM OFF

-- JWA  28-JAN-2008
-- 
-- DEVELOPMENT COMMENTS
-- Dropping GRS_PK constraint.
------------------------------------------------------------------
alter table gri_spool drop constraint grs_pk;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

