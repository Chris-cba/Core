------------------------------------------------------------------
-- nm4101_nm4200_ddl_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4101_nm4200_ddl_upg.sql-arc   3.3   Jul 04 2013 14:16:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4101_nm4200_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.3  $
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
PROMPT NM_INV_TYPE_ATTRIBS_ALL.ITA_CASE field and constraint
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108242
-- 
-- TASK DETAILS
-- A number of customers including Newfoundland require asset attributes to be held in either mixed, lower or upper case. This is a requirement that goes back to the first days of NM3 and was originally declined as an option due to difficulty. Tools may be more available nowadays but the impact is enormous due to the complexity and number of forms.
-- 
-- This includes the following.
-- 
-- NM0410 - Asset Metamodel (The form that allows you to set the case restriction)
-- 
-- NM0105 - Elements
-- NM0110 - Group of Sections
-- NM0115 - Group of Groups
-- NM0116 - Bulk Network Update
-- NM0510 - Asset Items
-- NM0511 - Correct Load Errors
-- NM0512 - Correct Load Errors (MCI)
-- NM0530 - Global Asset Update
-- NM0535 - Bulk Asset Update
-- NM0560 - Assets on a Route
-- NM0570 - Find Assets
-- NM0572 - Locator
-- NM0573 - Asset Grid
-- NM0590 - Asset Maintenance
-- NM1100 - Gazetteer
-- NM7040 - PBI Queries
-- NM7050 - Merge Query
-- NM7051(B) - Merge Query Results
-- 
-- The changes made allows the users to enter and display asset attributes in mixed case. Values for attributes (if editable) are formatted on validated of the field.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- Added for task 0108242 Asset attributes to deal with mixed-case
-- 
------------------------------------------------------------------
DECLARE
--
  already_exists exception;
  pragma exception_init (already_exists, -01430);
--
BEGIN
--
  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_type_attribs_all DISABLE ALL TRIGGERS';
  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_type_attribs_all ADD
                    (
                    ITA_CASE VARCHAR2(5) DEFAULT ''UPPER'' NOT NULL
                    )';
EXCEPTION
WHEN already_exists THEN
NULL;
END;
/

--
ALTER TABLE nm_inv_type_attribs_all ENABLE ALL TRIGGERS;
--

DECLARE
--
  already_exists exception;
  pragma exception_init (already_exists, -02264);
--
BEGIN  
--
  EXECUTE IMMEDIATE 'ALTER TABLE nm_inv_type_attribs_all ADD
                     (
                     CONSTRAINT ITA_CASE_CHK
                          CHECK ((ITA_ID_DOMAIN IS NULL AND ITA_CASE IN (''UPPER'',''LOWER'', ''MIXED'')) OR ITA_ID_DOMAIN IS NOT NULL AND ITA_CASE IN (''UPPER''))
                     )';
--
EXCEPTION
WHEN already_exists THEN
  NULL;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Drop Public Synonym MDSYS.SDO_GEOM_METADATA_TABLE
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108674
-- 
-- TASK DETAILS
-- Public synonyms for referencing SDO_GEOM_METADATA table in Spatial Server are not required and can cause problems. It should be replaced with a direct reference, i.e. MDSYS.SDO_GEOM_METADATA table in package(s) that reference it  and the synonym dropped ideally.
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Drop Public Synonym MDSYS.SDO_GEOM_METADATA_TABLE
-- 
------------------------------------------------------------------
DECLARE
  ex_not_found EXCEPTION;
  PRAGMA EXCEPTION_INIT (ex_not_found,-01432);
BEGIN
  EXECUTE IMMEDIATE 'drop public synonym sdo_geom_metadata_table';
EXCEPTION
  WHEN ex_not_found THEN NULL;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Index to control Highways Owner Flag
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Index to control Highways Owner Flag
-- 
------------------------------------------------------------------
CREATE UNIQUE INDEX HUS_OWNER_UNIQUE_FBI ON HIG_USERS
 (decode(hus_is_hig_owner_flag, 'Y', -999, hus_user_id ))
/



------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT GRANT ANALYZE ANY TO hig_user/admin
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108303
-- 
-- TASK DETAILS
-- Performance improvements for NSG loader during 4.2.0.0 requires each user that executes the loading process to have the  ANALYZE ANY privilege. This will be assigned to all users with a specific role. Surreptitious generation of statistics is rare but the NSG loader has the potential to create vast numbers of records and the statistics must be kept up to date for the CBI to make an effective assessment of performance.
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- GRANT ANALYZE ANY TO hig_user/admin
-- 
------------------------------------------------------------------
BEGIN
  EXECUTE IMMEDIATE 'GRANT ANALYZE ANY TO hig_user';
  EXECUTE IMMEDIATE 'GRANT ANALYZE ANY TO '||USER||' with admin option';
END;
/

BEGIN
  EXECUTE IMMEDIATE 'GRANT ANALYZE ANY TO hig_admin';
  EXECUTE IMMEDIATE 'GRANT ANALYZE ANY TO '||USER||' with admin option';
END;
/

BEGIN
  FOR i IN
    (SELECT 'GRANT ANALYZE ANY TO '||username l_sql
       FROM all_users, dba_role_privs, hig_users
      WHERE grantee = username
        AND granted_role IN ('HIG_USER','HIG_ADMIN')
        AND hus_username = username
        AND hus_is_hig_owner_flag = 'N')
  LOOP
    EXECUTE IMMEDIATE i.l_sql;
  END LOOP;
END;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New column and index on DOC_REDIR_PRIOR
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108058
-- 
-- TASK DETAILS
-- After creating a Group of Groups, within Network Manager, the new group does not appear within the gazetteer called from the Enquiry Redirection form (DOC0157).
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- New column on DOC_REDIR_PRIOR
-- 
------------------------------------------------------------------
DECLARE
-- 
  already_exists Exception;
  Pragma Exception_INIT( already_exists,-01430); 
-- 
BEGIN
--
  EXECUTE IMMEDIATE 'ALTER TABLE doc_redir_prior ADD (drp_ne_id  NUMBER(9))';
--
  EXECUTE IMMEDIATE 'CREATE INDEX DRP_NE_IND ON DOC_REDIR_PRIOR (DRP_NE_ID)';
--
  EXECUTE IMMEDIATE ' UPDATE doc_redir_prior '||
                       ' SET drp_ne_id = (SELECT MIN(ne_id) '||
                                          ' FROM nm_elements_all '|| 
                                         ' WHERE ne_unique = drp_road_unique) ';
--
  EXECUTE IMMEDIATE 'ALTER TABLE doc_redir_prior DROP COLUMN drp_road_unique';
--
EXCEPTION
   WHEN already_exists 
   THEN
       Null;
   WHEN OTHERS
   THEN
       RAISE;
END ;
/

------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

