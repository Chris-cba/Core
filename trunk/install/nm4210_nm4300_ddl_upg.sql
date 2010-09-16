------------------------------------------------------------------
-- nm4210_nm4300_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4210_nm4300_ddl_upg.sql-arc   3.0   Sep 16 2010 15:54:18   Mike.Alexander  $
--       Module Name      : $Workfile:   nm4210_nm4300_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Sep 16 2010 15:54:18  $
--       Date fetched Out : $Modtime:   Sep 16 2010 15:52:06  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2010

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
-- end of script 
------------------------------------------------------------------

