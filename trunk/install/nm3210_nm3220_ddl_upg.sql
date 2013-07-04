--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3210_nm3220_ddl_upg.sql	1.25 02/07/06
--       Module Name      : nm3210_nm3220_ddl_upg.sql
--       Date into SCCS   : 06/02/07 13:51:37
--       Date fetched Out : 07/06/13 13:58:03
--       SCCS Version     : 1.25
--
--   Product upgrade script
--   Note: nm3210_nm3211_ddl_upg also contains DDL changes that will be ran in at this upgrade
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
--
SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

---------------------------------------------------------------------------
-- Start of changes for HIG1807/nm3user.pkb Changes   - Paul
--
CREATE GLOBAL TEMPORARY TABLE EXOR_PRODUCT_TXT
(
  HPR_PRODUCT        VARCHAR2(6),
  EXOR_FILE_VERSION  VARCHAR2(20)
)
ON COMMIT PRESERVE ROWS
/
--
-- End of changes for HIG1807/nm3user.pkb Changes   - Paul
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Start of Directories Changes - Graeme
--
GRANT DROP ANY DIRECTORY TO HIG_ADMIN
/
GRANT CREATE ANY DIRECTORY TO HIG_ADMIN
/

--
-- explicity grant the privs to all users who have HIG_ADMIN - as is done in the "Maintain Roles" module HIG1836
--
set serveroutput on size 99999
BEGIN
  FOR i IN (select grantee  from   dba_role_privs where  granted_role = 'HIG_ADMIN') LOOP
    BEGIN
      execute immediate ('GRANT DROP ANY DIRECTORY TO '||i.grantee);
      execute immediate ('GRANT CREATE ANY DIRECTORY TO '||i.grantee);   
    EXCEPTION
     WHEN others THEN
       dbms_output.put_line('Problem granting directory privs to '||i.grantee||chr(10)||sqlerrm||chr(10));
    END;
  END LOOP;
END;
/

CREATE TABLE hig_directories(hdir_name VARCHAR2(30)      NOT NULL
                            ,hdir_path VARCHAR2(4000)    NOT NULL
                            ,hdir_url  VARCHAR2(500)
                            ,hdir_comments VARCHAR2(4000)
                            ,hdir_protected VARCHAR2(1)  DEFAULT 'N' NOT NULL 
                             )
/
ALTER TABLE hig_directories ADD (
  CONSTRAINT HDIR_PK PRIMARY KEY (hdir_name))
/
CREATE TABLE hig_directory_roles
(
  HDR_NAME   VARCHAR2(30)                 NOT NULL,
  HDR_ROLE   VARCHAR2(30)                 NOT NULL,
  HDR_MODE   VARCHAR2(10)                 NOT NULL
)
/
ALTER TABLE HIG_DIRECTORY_ROLES ADD (
  CONSTRAINT HDR_PK PRIMARY KEY (HDR_NAME, HDR_ROLE))
/
ALTER TABLE HIG_DIRECTORY_ROLES ADD (
  CONSTRAINT HDR_HDIR_FK FOREIGN KEY (HDR_NAME)
    REFERENCES HIG_DIRECTORIES (HDIR_NAME)
    ON DELETE CASCADE)
/
ALTER TABLE HIG_DIRECTORY_ROLES ADD (
  CONSTRAINT HDR_HRO_FK FOREIGN KEY (HDR_ROLE)
    REFERENCES HIG_ROLES (HRO_ROLE)
    ON DELETE CASCADE)
/
--
-- End of Directories Changes - Graeme
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Start of Financial Years changes - Graeme
-- Need to wrap this up in a procedure and handle object already exists cos
-- the table was previously installed with MAI so could already exist at some
-- customer sites
DECLARE
  ex_exists exception;
  pragma exception_init(ex_exists,-955);
BEGIN

 EXECUTE IMMEDIATE('
CREATE TABLE FINANCIAL_YEARS
 (FYR_ID VARCHAR2(5) NOT NULL
 ,FYR_START_DATE DATE NOT NULL
 ,FYR_END_DATE DATE NOT NULL
 )');
 
 EXECUTE IMMEDIATE('COMMENT ON TABLE FINANCIAL_YEARS IS ''Valid Years and their date ranges''');

 EXECUTE IMMEDIATE ('ALTER TABLE FINANCIAL_YEARS ADD (CONSTRAINT FYR_PK PRIMARY KEY (FYR_ID))');
 
EXCEPTION
 WHEN ex_exists THEN
    Null;
 WHEN others THEN
    RAISE_APPLICATION_ERROR(-20001,sqlerrm);
END;
/

--
-- This is completely new - checking used to be done via the module MAI3664
--
ALTER TABLE FINANCIAL_YEARS ADD (CONSTRAINT FYR_CHK1 CHECK (fyr_start_date<fyr_end_date))
/
--
-- End of Financial Years Changes - Graeme
---------------------------------------------------------------------------



---------------------------------------------------------------------------
-- Start of Changes driven by NSG Data Manager requirements
--
-- NE_DESCR 240 CHARS
--
alter table nm_elements_all
modify(ne_descr VARCHAR2(240))
/
CREATE INDEX NE_DESCR_IND
ON NM_ELEMENTS_ALL(NE_NT_TYPE,NE_DESCR)
/
--
-- NM_TYPE_XREFS MOVED TO COR AND SIMPLIFIED
--
DECLARE
 ex_no_bother EXCEPTION;
 pragma exception_init(ex_no_bother,-942);
BEGIN
 EXECUTE IMMEDIATE ('DROP TABLE NM_TYPE_XREFS CASCADE CONSTRAINTS');
EXCEPTION
  WHEN ex_no_bother THEN 
   Null;
END; 
/
CREATE TABLE NM_TYPE_XREFS
(
  NTX_RELATIONSHIP_TYPE  VARCHAR2(30)      NOT NULL
 ,NTX_NT_TYPE1           VARCHAR2(4)       NOT NULL
 ,NTX_GTY_TYPE1          VARCHAR2(4)
 ,NTX_NT_TYPE2           VARCHAR2(4)       NOT NULL
 ,NTX_GTY_TYPE2          VARCHAR2(4)
)
/
ALTER TABLE NM_TYPE_XREFS ADD (
  CONSTRAINT NM_TYPE_XREFS_FK FOREIGN KEY (NTX_NT_TYPE1) 
    REFERENCES NM_TYPES (NT_TYPE))
/
ALTER TABLE NM_TYPE_XREFS ADD (
  CONSTRAINT NM_TYPE_XREFS_FK0 FOREIGN KEY (NTX_NT_TYPE2) 
    REFERENCES NM_TYPES (NT_TYPE))
/
ALTER TABLE NM_TYPE_XREFS ADD (
  CONSTRAINT NM_TYPE_XREFS_FK1 FOREIGN KEY (NTX_GTY_TYPE1) 
    REFERENCES NM_GROUP_TYPES_ALL (NGT_GROUP_TYPE))
/
ALTER TABLE NM_TYPE_XREFS ADD (
  CONSTRAINT NM_TYPE_XREFS_FK2 FOREIGN KEY (NTX_GTY_TYPE2) 
    REFERENCES NM_GROUP_TYPES_ALL (NGT_GROUP_TYPE))
/	
--
-- NM_ELEMENT_XREFS MOVED TO CORE AND SIMPLIFIED
--
DECLARE
 ex_no_bother EXCEPTION;
 pragma exception_init(ex_no_bother,-4043);
BEGIN
 EXECUTE IMMEDIATE('RENAME NM_ELEMENT_XREFS TO NM_ELEMENT_XREFS_3210');
 EXECUTE IMMEDIATE('ALTER TABLE NM_ELEMENT_XREFS_3210 DROP CONSTRAINT NM_ELEMENT_XREFS_FK');
 EXECUTE IMMEDIATE('ALTER TABLE NM_ELEMENT_XREFS_3210 DROP CONSTRAINT NM_ELEMENT_XREFS_FK0');
EXCEPTION
  WHEN ex_no_bother THEN 
   Null;
END;
/
CREATE TABLE NM_ELEMENT_XREFS
(
  NEX_RELATIONSHIP_TYPE  VARCHAR2(30)      NOT NULL,
  NEX_ID1                NUMBER(9)         NOT NULL,
  NEX_ID2                NUMBER(9)         NOT NULL
)
/
ALTER TABLE NM_ELEMENT_XREFS ADD (
CONSTRAINT NEX_PK PRIMARY KEY (NEX_RELATIONSHIP_TYPE, NEX_ID1, NEX_ID2))
/
ALTER TABLE NM_ELEMENT_XREFS ADD (
CONSTRAINT NM_ELEMENT_XREFS_FK FOREIGN KEY (NEX_ID1) 
REFERENCES NM_ELEMENTS_ALL (NE_ID)
ON DELETE CASCADE)
/	
ALTER TABLE NM_ELEMENT_XREFS ADD (
CONSTRAINT NM_ELEMENT_XREFS_FK0 FOREIGN KEY (NEX_ID2) 
REFERENCES NM_ELEMENTS_ALL (NE_ID)
ON DELETE CASCADE)
/

--
-- New table to lock NSGN network type out of NM0105, NM0110 and NM0115
--
CREATE TABLE NM_TYPE_SPECIFIC_MODULES
(
  NTSM_NT_TYPE     VARCHAR2(4)             NOT NULL,
  NTSM_HMO_MODULE  VARCHAR2(30)            NOT NULL
)
/
ALTER TABLE NM_TYPE_SPECIFIC_MODULES ADD (
  CONSTRAINT NTSM_PK PRIMARY KEY (NTSM_NT_TYPE, NTSM_HMO_MODULE))
/  

ALTER TABLE NM_TYPE_SPECIFIC_MODULES ADD 
CONSTRAINT NTSM_HMO_FK
 FOREIGN KEY (NTSM_HMO_MODULE)
 REFERENCES HIG_MODULES (HMO_MODULE) ON DELETE CASCADE
/ 

-- 
-- End of Changes driven by NSG Data Manager requirements
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Start of product/user option changes
--
ALTER TABLE hig_option_list
ADD (hol_user_option VARCHAR2(1))
/
ALTER TABLE HIG_OPTION_LIST ADD (
  CONSTRAINT HOL_USER_OPTION_CHK CHECK (HOL_USER_OPTION IN ('Y','N')))
/
UPDATE hig_option_list
SET hol_user_option = 'Y'
WHERE EXISTS (SELECT 'x'
              FROM hig_codes
              WHERE hco_domain = 'USER_OPTIONS'
              AND  hco_code = hol_id)
/		  
UPDATE hig_option_list
SET hol_user_option = 'N'
WHERE NOT EXISTS (SELECT 'x'
                  FROM hig_codes
                  WHERE hco_domain = 'USER_OPTIONS'
                  AND  hco_code = hol_id)
/		
ALTER TABLE hig_option_list modify (hol_user_option DEFAULT 'N' NOT NULL)
/

CREATE TABLE HIG_USER_OPTION_LIST
(
  HUOL_ID          VARCHAR2(10)            NOT NULL,
  HUOL_PRODUCT     VARCHAR2(6)             NOT NULL,
  HUOL_NAME        VARCHAR2(30)            NOT NULL,
  HUOL_REMARKS     VARCHAR2(2000)          NOT NULL,
  HUOL_DOMAIN      VARCHAR2(20),
  HUOL_DATATYPE    VARCHAR2(8)             DEFAULT 'VARCHAR2'            NOT NULL,
  HUOL_MIXED_CASE  VARCHAR2(1)             DEFAULT 'N'                   NOT NULL
)
/
CREATE INDEX HUOL_HPR_FK_IND ON HIG_USER_OPTION_LIST
(HUOL_PRODUCT)
/
CREATE UNIQUE INDEX HUOL_PK ON HIG_USER_OPTION_LIST
(HUOL_ID)
/



-- 
-- End of product/user option changes
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Start of AD LINK changes
--
ALTER TABLE nm_nw_ad_link_all ADD (nad_nt_type VARCHAR2(4))
/
ALTER TABLE nm_nw_ad_link_all ADD (nad_gty_type VARCHAR2(4))
/
ALTER TABLE nm_nw_ad_link_all ADD (nad_inv_type VARCHAR2(4))
/
ALTER TRIGGER nm_nw_ad_link_br DISABLE
/
ALTER TRIGGER nm_nw_ad_link_as DISABLE
/
UPDATE nm_nw_ad_Link_all nadl
SET nad_nt_type = (select nad_nt_type from nm_nw_ad_types typ where typ.nad_id = nadl.nad_id)
   ,nad_gty_type = (select nad_gty_type from nm_nw_ad_types typ where typ.nad_id = nadl.nad_id)
   ,nad_inv_type = (select nad_inv_type from nm_nw_ad_types typ where typ.nad_id = nadl.nad_id)
/
ALTER TABLE nm_nw_ad_Link_all MODIFY (nad_nt_type NOT NULL)
/
ALTER TABLE nm_nw_ad_Link_all MODIFY (nad_inv_type NOT NULL)
/   
ALTER TRIGGER nm_nw_ad_link_br ENABLE
/
ALTER TRIGGER nm_nw_ad_link_as ENABLE
/
CREATE INDEX NAD_NT_GTY_TYPE_IND ON NM_NW_AD_LINK_ALL
(NAD_NT_TYPE, NAD_INV_TYPE)
/
CREATE INDEX NAD_INV_TYPE_IND ON NM_NW_AD_LINK_ALL
(NAD_INV_TYPE)
/

--
-- End of AD LINK changes
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Start of Progress Indicator changes
--
CREATE TABLE NM_PROGRESS
(
  PRG_PROGRESS_ID     NUMBER                    NOT NULL,
  PRG_TOTAL_STAGES    NUMBER                    NOT NULL,
  PRG_CURRENT_STAGE   NUMBER                    NOT NULL,
  PRG_OPERATION       VARCHAR2(100),
  PRG_ERROR_MESSAGE   VARCHAR2(1000),
  PRG_TOTAL_COUNT      NUMBER,
  PRG_CURRENT_POSITION  NUMBER
)
/
ALTER TABLE NM_PROGRESS
ADD CONSTRAINT PRG_UK UNIQUE (PRG_PROGRESS_ID)
/

CREATE SEQUENCE prg_id_seq
/
--
-- End of Progress Indicator changes
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- Start of Admin units changes:
-- Support use of address1 for org name and address2 for alias
--
CREATE INDEX NAU_ADDRESS1_IND ON NM_ADMIN_UNITS_ALL (NAU_ADDRESS1) 
/
--
CREATE INDEX NAU_ADDRESS2_IND ON NM_ADMIN_UNITS_ALL (NAU_ADDRESS2) 
/
--
--
-- End of Admin units changes
---------------------------------------------------------------------------


-----------------------------------------------------------------------------
-- Start of Audit Changes - allow restriction to be applied in audit metadata
--
CREATE TABLE NM_AUDIT_WHEN
(
  NAW_ID           NUMBER                  NOT NULL,
  NAW_TABLE_NAME   VARCHAR2(30)            NOT NULL,
  NAW_COLUMN_NAME  VARCHAR2(30)            NOT NULL,
  NAW_OPERATOR     VARCHAR2(20)            DEFAULT '='                   NOT NULL,
  NAW_CONDITION    VARCHAR2(2000)
)
/

CREATE INDEX NAW_IND1 ON NM_AUDIT_WHEN
(NAW_TABLE_NAME)
/

ALTER TABLE NM_AUDIT_WHEN ADD (
  CONSTRAINT NAW_PK PRIMARY KEY (NAW_ID))
/  


ALTER TABLE NM_AUDIT_WHEN ADD (
  CONSTRAINT NAW_NAT_FK FOREIGN KEY (NAW_TABLE_NAME) 
    REFERENCES NM_AUDIT_TABLES (NAT_TABLE_NAME)
    ON DELETE CASCADE)
/    

CREATE SEQUENCE NAW_ID_SEQ
/
--
-- End of Audit Changes - allow restriction to be applied in audit metadata
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Start of PMS log 703686 - remove trigger that duplicates a cascade trigger
-- and causes mutating table error
drop trigger nm_ngt_del_nlt_trg
/
--
-- End of PMS log 703686 
-----------------------------------------------------------------------------

--
---------------------------------------------------------------------------------------------------
-- Increase nm_dbug table for better logging of terminal info
-- Corresponds to the latest nm_debug package changes.
ALTER TABLE nm_dbug MODIFY nd_terminal VARCHAR2(250)
/
--
---------------------------------------------------------------------------------------------------
--                        ****************   END OF SCRIPT   *******************

