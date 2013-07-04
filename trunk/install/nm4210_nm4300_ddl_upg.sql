------------------------------------------------------------------
-- nm4210_nm4300_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4210_nm4300_ddl_upg.sql-arc   3.6   Jul 04 2013 14:16:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4210_nm4300_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:22  $
--       Version          : $Revision:   3.6  $
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
PROMPT NARSH_SOURCE_DESCR column size increase
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
PROMPT Merge Query Split Table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Merge Query Split Results table modification.
-- 
------------------------------------------------------------------
alter table NM_MRG_SPLIT_RESULTS_TMP
modify NM_NE_ID_IN number(38);

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New column  haud_description added to hig_audits
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110027
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New column  haud_description added to hig_audits
-- 
------------------------------------------------------------------
DECLARE
--
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-01430);
--
BEGIN
--
   EXECUTE IMMEDIATE ' ALTER TABLE hig_audits ADD (haud_description Varchar2(250))';

   EXECUTE IMMEDIATE 'COMMENT ON COLUMN hig_audits. haud_description IS ''This column holds the Audit Description''';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;    
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New column added in hig_alert_types
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110081
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New column added in hig_alert_types
-- 
------------------------------------------------------------------
DECLARE
--
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-01430);
--
BEGIN
--
   EXECUTE IMMEDIATE 'ALTER TABLE hig_alert_types ADD (halt_next_run_date Date)';

   EXECUTE IMMEDIATE 'COMMENT ON COLUMN hig_alert_types.halt_next_run_date IS ''This column holds the next run datetime for Scheduled Events''';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;    
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Navigator in sync with Product License
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110056
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- Navigator in sync with Product License
-- 
------------------------------------------------------------------
DECLARE
--
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-01430);
--
BEGIN
--
   EXECUTE IMMEDIATE ' ALTER table hig_navigator ADD (hnv_hpr_product VARCHAR2(6))';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;    
END;
/


DECLARE
--
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-02275);
--
BEGIN
--
   EXECUTE IMMEDIATE ' ALTER table hig_navigator ADD (CONSTRAINT hnv_hpr_fk FOREIGN KEY (hnv_hpr_product) REFERENCES hig_products(hpr_product))';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;    
END;
/


DECLARE
--
   l_exception  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_exception,-00955);
--
BEGIN
--
   EXECUTE IMMEDIATE ' CREATE INDEX HNV_HPR_FK_IND ON hig_navigator(hnv_hpr_product)';
--
EXCEPTION 
WHEN l_exception THEN
    NULL;
WHEN OTHERS THEN
    RAISE;    
END;
/


COMMENT ON COLUMN hig_navigator.hnv_hpr_product IS 'This column will hold the Product of the table defined in the hierarchy'
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT HIG_MODULE_LINK_CALLS table re-build
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109788
-- 
-- TASK DETAILS
-- Sometimes when the Works form (TMA1000) is called via a Link from Query Works form (TMA1040), Review Notices form (TMA1030) or Monitor Web Services form (TMA3000), the Works will not be queried in TMA1000.
-- 
-- 
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- To fix bug in the forms linking functionality.
-- 
-- The calling form fills the HIG_MODULE_LINK_CALLS table with one or more records so that in the called form it can work out a where clause.
-- 
-- Problem was that the called form would build the where clause looking at all of the rows in the table.
-- 
-- So when you had 2 calls going on at the same time the where clause that was being constructed would never be valid
-- 
-- 
------------------------------------------------------------------
drop table hig_module_link_calls cascade constraints
/

CREATE TABLE HIG_MODULE_LINK_CALLS
(
  HMLC_ID                      NUMBER(9)        NOT NULL,
  HMLC_SEQ                     NUMBER(9)        NOT NULL,
  HMLC_METHOD_ID               NUMBER(9)        NOT NULL,
  HMLC_PARAM_FROM_VALUE        VARCHAR2(4000),
  HMLC_PARAM_FROM_FORMAT_MASK  VARCHAR2(100)
)
/

COMMENT ON TABLE HIG_MODULE_LINK_CALLS IS 'Used by forms linking functionality.  Written to by calling form and then read from by called form to construct a where clause to apply to the relevant forms block.';

COMMENT ON COLUMN HIG_MODULE_LINK_CALLS.HMLC_ID IS 'Call ID.  Primary Key Column 1';

COMMENT ON COLUMN HIG_MODULE_LINK_CALLS.HMLC_SEQ IS 'Sequence Within Call.  Primary Key Column 2';

COMMENT ON COLUMN HIG_MODULE_LINK_CALLS.HMLC_METHOD_ID IS 'Linking Method ID';

COMMENT ON COLUMN HIG_MODULE_LINK_CALLS.HMLC_PARAM_FROM_VALUE IS 'Parameter From Value';

COMMENT ON COLUMN HIG_MODULE_LINK_CALLS.HMLC_PARAM_FROM_FORMAT_MASK IS 'Parameter From Format Mask';


ALTER TABLE HIG_MODULE_LINK_CALLS ADD (
  CONSTRAINT HMLC_PK
  PRIMARY KEY
  (HMLC_ID, HMLC_SEQ));

ALTER TABLE HIG_MODULE_LINK_CALLS ADD (
  CONSTRAINT HMLC_HMLM_FK 
  FOREIGN KEY (HMLC_METHOD_ID) 
  REFERENCES HIG_MODULE_LINK_METHODS (HMLM_ID));
  
CREATE INDEX HMLC_HMLM_FK_IND ON HIG_MODULE_LINK_CALLS
(HMLC_METHOD_ID);  
  

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Bulk Merge Banding Performance
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108738
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 108958
-- 
-- TASK DETAILS
-- This adds domain meaning lookup in storing merge query results.
-- 
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Bulk Merge Banding Performance
-- 
------------------------------------------------------------------
drop index itd_itb_fk_ind
/

create unique index itd_itb_fk_ind on nm_inv_type_attrib_band_dets (
  itd_inv_type, itd_attrib_name, itd_itb_banding_id, itd_band_min_value, itd_band_max_value, itd_band_seq, itd_band_description
)
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Table NM_DATUM_CRITERIA_PRE_TMP
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110172
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- New Table NM_DATUM_CRITERIA_PRE_TMPTable
-- 
------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE NM_DATUM_CRITERIA_PRE_TMP
(
  NM_NE_ID_OF        NUMBER(9),
  NM_NE_ID_IN        NUMBER(9),
  NM_BEGIN_MP        NUMBER,
  NM_END_MP          NUMBER,
  NE_GTY_GROUP_TYPE  VARCHAR2(4),
  NGT_GROUP_TYPE     VARCHAR2(4),
  GROUP_ID           NUMBER(9)
)
ON COMMIT PRESERVE ROWS
NOCACHE;




------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New FK Constraint and Index for NM_TYPES to NM_UNITS
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109624
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- New FK Constraint and Index for NM_TYPES to NM_UNITS
-- 
------------------------------------------------------------------
PROMPT Creating Foreign Key on 'NM_TYPES'
ALTER TABLE NM_TYPES ADD (CONSTRAINT
 NT_UN_FK FOREIGN KEY
  (NT_LENGTH_UNIT) REFERENCES NM_UNITS
  (UN_UNIT_ID))
/

PROMPT Creating Index 'NT_UN_FK_IND'
CREATE INDEX NT_UN_FK_IND ON NM_TYPES
 (NT_LENGTH_UNIT)
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop docs2view view
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 109999
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- View is no longer required in Core but is still needed in PEM.
-- 
------------------------------------------------------------------
DECLARE
--
   view_exists_not   EXCEPTION;
   PRAGMA EXCEPTION_INIT (view_exists_not, -942);
   l_dummy NUMBER;
--
    CURSOR c1 ( c_product varchar2) IS
    SELECT 1
      FROM hig_products
     WHERE hpr_product = c_product
       AND hpr_key IS NOT NULL;
BEGIN
--
   OPEN c1('ENQ');
   FETCH c1 INTO l_dummy;
      IF c1%NOTFOUND THEN
        EXECUTE IMMEDIATE 'Drop View docs2view';
      END IF;
   CLOSE c1;
--
EXCEPTION
   WHEN view_exists_not
   THEN
      NULL;
END;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Consolidate erroneus indexes
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADE EDWARDS)
-- Consolidate erroneus indexes
-- 
------------------------------------------------------------------
--
--------------------------------------
-- GRI_MODULES
--------------------------------------
--

PROMPT Dropping Constraint 'GRM_FK_HMO'
Alter Table GRI_MODULES
Drop Constraint GRM_FK_HMO
/

PROMPT Dropping Constraint 'GMP_FK_GRM'
Alter Table GRI_MODULE_PARAMS
Drop Constraint GMP_FK_GRM
/

PROMPT Dropping Constraint 'GSS_FK_GRM'
Alter Table GRI_SAVED_SETS
Drop Constraint GSS_FK_GRM
/

PROMPT Dropping Constraint 'GRM_PK'
Alter Table GRI_MODULES
Drop Constraint GRM_PK
/

PROMPT Dropping Index 'GRM_FK_HMO_IND'
Drop Index GRM_FK_HMO_IND
/

PROMPT Creating Primary Key on 'GRI_MODULES'
ALTER TABLE GRI_MODULES
ADD (CONSTRAINT GRM_PK PRIMARY KEY 
  (GRM_MODULE))
/

PROMPT Creating Foreign Key on 'GRI_MODULES'
ALTER TABLE GRI_MODULES ADD (CONSTRAINT
GRM_FK_HMO FOREIGN KEY 
  (GRM_MODULE) REFERENCES HIG_MODULES
  (HMO_MODULE))
/

PROMPT Creating Foreign Key on 'GRI_MODULE_PARAMS'
ALTER TABLE GRI_MODULE_PARAMS ADD (CONSTRAINT
GMP_FK_GRM FOREIGN KEY 
  (GMP_MODULE) REFERENCES GRI_MODULES
  (GRM_MODULE) ON DELETE CASCADE)
/

PROMPT Creating Foreign Key on 'GRI_SAVED_SETS'
ALTER TABLE GRI_SAVED_SETS ADD (CONSTRAINT
GSS_FK_GRM FOREIGN KEY 
  (GSS_MODULE) REFERENCES GRI_MODULES
  (GRM_MODULE) ON DELETE CASCADE DISABLE)
/


--
--------------------------------------
-- HIG_USER_HISTORY
--------------------------------------
--

PROMPT Dropping Constraint 'HUH_PK'
Alter Table HIG_USER_HISTORY
Drop Constraint HUH_PK
/

PROMPT Dropping Index 'HUH_HUS_FK_IND'
Drop Index HUH_HUS_FK_IND
/

PROMPT Creating Primary Key on 'HIG_USER_HISTORY'
ALTER TABLE HIG_USER_HISTORY
ADD (CONSTRAINT HUH_PK PRIMARY KEY 
  (HUH_USER_ID))
/

--
--------------------------------------
-- NM_GROUP_INV_LINK_ALL
--------------------------------------
--

PROMPT Dropping Constraint 'NGIL_PK'
Alter Table NM_GROUP_INV_LINK_ALL
Drop Constraint NGIL_PK
/

PROMPT Dropping Constraint 'NGIL_UK'
Alter Table NM_GROUP_INV_LINK_ALL
Drop Constraint NGIL_UK
/

PROMPT Dropping Index 'NGIL_FK_IIT_IND'
Drop Index NGIL_FK_IIT_IND
/

PROMPT Dropping Index 'NGIL_FK_NE_IND'
Drop Index NGIL_FK_NE_IND
/

PROMPT Creating Primary Key on 'NM_GROUP_INV_LINK_ALL'
ALTER TABLE NM_GROUP_INV_LINK_ALL
ADD (CONSTRAINT NGIL_PK PRIMARY KEY 
  (NGIL_NE_NE_ID
  ,NGIL_IIT_NE_ID))
/

PROMPT Creating Unique Key on 'NM_GROUP_INV_LINK_ALL'
ALTER TABLE NM_GROUP_INV_LINK_ALL
ADD (CONSTRAINT NGIL_UK UNIQUE 
  (NGIL_NE_NE_ID))
/

PROMPT Creating Index 'NGIL_FK_IIT_IND'
CREATE INDEX NGIL_FK_IIT_IND ON NM_GROUP_INV_LINK_ALL
(NGIL_IIT_NE_ID)
/

--
--------------------------------------
-- NM_GROUP_INV_TYPES
--------------------------------------
--

PROMPT Dropping Constraint 'NGIT_PK'
Alter Table NM_GROUP_INV_TYPES
Drop Constraint NGIT_PK
/

PROMPT Dropping Constraint 'NGIT_UK'
Alter Table NM_GROUP_INV_TYPES
Drop Constraint NGIT_UK
/

PROMPT Dropping Index 'NGIT_FK_NGT_IND'
Drop Index NGIT_FK_NGT_IND
/

PROMPT Dropping Index 'NGIT_FK_NIT_IND'
Drop Index NGIT_FK_NIT_IND
/

PROMPT Creating Primary Key on 'NM_GROUP_INV_TYPES'
ALTER TABLE NM_GROUP_INV_TYPES
ADD (CONSTRAINT NGIT_PK PRIMARY KEY 
  (NGIT_NGT_GROUP_TYPE
  ,NGIT_NIT_INV_TYPE))
/

PROMPT Creating Unique Key on 'NM_GROUP_INV_TYPES'
ALTER TABLE NM_GROUP_INV_TYPES
ADD (CONSTRAINT NGIT_UK UNIQUE 
  (NGIT_NGT_GROUP_TYPE))
/

Prompt Index NGIT_FK_NIT_IND;
CREATE INDEX NGIT_FK_NIT_IND ON NM_GROUP_INV_TYPES
(NGIT_NIT_INV_TYPE)
/

--
--------------------------------------
-- DOC_ENQUIRY_CONTACTS
--------------------------------------
--
PROMPT Dropping Constraint 'DEC_PK'
Alter Table DOC_ENQUIRY_CONTACTS
Drop Constraint Dec_Pk
/

PROMPT Dropping Index 'DEC_IND1'
Drop Index Dec_Ind1
/

PROMPT Creating Primary Key on 'DOC_ENQUIRY_CONTACTS'
ALTER TABLE DOC_ENQUIRY_CONTACTS
ADD (CONSTRAINT DEC_PK PRIMARY KEY 
  (DEC_HCT_ID
  ,DEC_DOC_ID
  ,DEC_TYPE))
/

PROMPT Creating Index 'DEC_IND1'
CREATE UNIQUE INDEX DEC_IND1 ON DOC_ENQUIRY_CONTACTS
(DEC_HCT_ID
,DEC_TYPE
,DEC_DOC_ID)
/

--
--------------------------------------
-- DOC_KEYS
--------------------------------------
--

PROMPT Dropping Constraint 'DKY_PK'
Alter Table DOC_KEYS
Drop Constraint DKY_PK
/

PROMPT Dropping Index 'DKW_IND1'
Drop Index DKW_IND1
/

PROMPT Dropping Index 'DKY_FK_DKW_IND'
Drop Index DKY_FK_DKW_IND
/

PROMPT Creating Primary Key on 'DOC_KEYS'
ALTER TABLE DOC_KEYS
ADD (CONSTRAINT DKY_PK PRIMARY KEY 
  (DKY_DOC_ID
  ,DKY_DKW_KEY_ID))
/

PROMPT Creating Index 'DKW_IND1'
CREATE UNIQUE INDEX DKW_IND1 ON DOC_KEYS
(DKY_DKW_KEY_ID
,DKY_DOC_ID)
/

PROMPT Creating Index 'DKY_FK_DKW_IND'
CREATE INDEX DKY_FK_DKW_IND ON DOC_KEYS
(DKY_DKW_KEY_ID)
/

--
--------------------------------------
-- HIG_CONTACT_ADDRESS
--------------------------------------
--

PROMPT Dropping Constraint 'HCA_PK'
Alter Table HIG_CONTACT_ADDRESS
Drop Constraint HCA_PK
/

PROMPT Dropping Index 'HCA_IND1'
Drop Index HCA_IND1
/

PROMPT Creating Primary Key on 'HIG_CONTACT_ADDRESS'
ALTER TABLE HIG_CONTACT_ADDRESS
ADD (CONSTRAINT HCA_PK PRIMARY KEY 
  (HCA_HCT_ID
  ,HCA_HAD_ID))
/

PROMPT Creating Index 'HCA_IND1'
CREATE UNIQUE INDEX HCA_IND1 ON HIG_CONTACT_ADDRESS
(HCA_HAD_ID
,HCA_HCT_ID)
/

------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

