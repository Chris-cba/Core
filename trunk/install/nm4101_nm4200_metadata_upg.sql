------------------------------------------------------------------
-- nm4100_nm4200_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4101_nm4200_metadata_upg.sql-arc   3.1   Jul 04 2013 14:16:24   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4101_nm4200_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:16:24  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.1  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

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
PROMPT HIG_CODE AND HIG_DOMAIN Changes for task 0108242
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
-- hig_code and hig_domain metadata which will be used by nm0410 to populate LOV.
-- 
------------------------------------------------------------------
INSERT INTO hig_domains( hdo_domain
                       , hdo_product
                       , hdo_title
                       , hdo_code_length)
                 SELECT 'ATTRIBUTE_CASE'
                       , 'HIG'
                       , 'Attribute Case'
                       , 7
                    FROM DUAL 
                   WHERE NOT EXISTS (SELECT 'x' 
                                       FROM hig_domains
                                      WHERE hdo_domain = 'ATTRIBUTE_CASE');
--
INSERT INTO hig_codes ( hco_domain
                      , hco_code
                      , hco_meaning
                      , hco_system
                      , hco_seq)
                  SELECT 'ATTRIBUTE_CASE'
                       , 'UPPER'
                       , 'Upper Case'
                       , 'N'
                       , 1
                    FROM DUAL 
                   WHERE NOT EXISTS (SELECT 'x' 
                                       FROM hig_codes
                                      WHERE hco_domain = 'ATTRIBUTE_CASE'
                                        AND hco_code = 'UPPER');
--
INSERT INTO hig_codes ( hco_domain
                      , hco_code
                      , hco_meaning
                      , hco_system
                      , hco_seq)
                  SELECT 'ATTRIBUTE_CASE'
                       , 'LOWER'
                       , 'Lower Case'
                       , 'N'
                       , 2
                    FROM DUAL 
                   WHERE NOT EXISTS (SELECT 'x' 
                                       FROM hig_codes
                                      WHERE hco_domain = 'ATTRIBUTE_CASE'
                                        AND hco_code = 'LOWER');
--
INSERT INTO hig_codes ( hco_domain
                      , hco_code
                      , hco_meaning
                      , hco_system
                      , hco_seq)
                  SELECT 'ATTRIBUTE_CASE'
                       , 'MIXED'
                       , 'Mixed Case'
                       , 'N'
                       , 3
                    FROM DUAL 
                   WHERE NOT EXISTS (SELECT 'x' 
                                       FROM hig_codes
                                      WHERE hco_domain = 'ATTRIBUTE_CASE'
                                        AND hco_code = 'MIXED');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Correction to WEEKEND metadata
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 711146  Gloucestershire County Council
-- 
-- ASSOCIATED DEVELOPMENT TASK
-- 107276
-- 
-- TASK DETAILS
-- Product Option WEEKEND requires modification to the weekend days from 1,7 to 6,7 due to an Oracle change
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS BAUGH)
-- Correction to WEEKEND metadata
-- 
------------------------------------------------------------------
update hig_option_list
set hol_remarks = 'This option must contain a list of numeric values in the range 1 to 7.
They define the days of the week which constitute the weekend in a particular country, for use in working day calculations.  The following convention must be adopted:
7=Sunday 1=Monday ... 6=Saturday.
Therefore in the UK this option will contain the value 6,7
In the Inspection Loader (MAI2200), when repairs are loaded a repair due date calculation takes place. This may be based on working days or calendar days as indicated by the defect priority rules.
In Maintain Defects (MAI3806) a similar calculation takes place when a repair is created.'
where HOL_ID = 'WEEKEND'
and HOL_PRODUCT = 'HIG';
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT hig 509 error message
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108789
-- 
-- TASK DETAILS
-- Users must now enter a HIG_USER role when creating a new user.
-- If the user fails to create for other reasons, a meaningful error is now returned and the user is locked.
-- 
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- User must be assigned HIG_USER role. Error message
-- 
------------------------------------------------------------------
INSERT INTO nm_errors ( ner_appl
                                    , ner_id
                                    , ner_her_no
                                    , ner_descr
                                    , ner_cause)   
SELECT 'HIG'
           ,509
           ,NULL
           ,'User must be assigned HIG_USER role.'
           ,NULL
  FROM  dual
WHERE NOT EXISTS (SELECT 'x'
                                  FROM  nm_errors
                                WHERE ner_appl = 'HIG'
                                     AND ner_id = 509);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT gis0020 tree metadata
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108566
-- 
-- TASK DETAILS
-- All spatial data will now be constructed in the themes forms and not on the group and asset types metadata forms.
-- Improvements will be made to the generation of foreign table themes by allowing a theme and a foreign table asset type to be created directly.
-- Interfaces will be provided to the various metadata checker scripts. Spatial index repair tools will be made available.
-- 
-- 
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- GIS0020 tree meta data
-- 
------------------------------------------------------------------
INSERT INTO NM_LAYER_TREE
 (NLTR_PARENT
 ,NLTR_CHILD
 ,NLTR_DESCR
 ,NLTR_TYPE 
 ,NLTR_ORDER)
(SELECT 'CUS'
      , 'RG1'
      , 'Register Table As Theme'
      , 'M'
      , '20' 
   FROM DUAL
   WHERE NOT EXISTS (SELECT 'X'
                       FROM NM_LAYER_TREE
                      WHERE NLTR_PARENT = 'CUS'
                        AND NLTR_CHILD = 'RG1'));
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT hig_code changes for task 0108386
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108386
-- 
-- TASK DETAILS
-- The advanced search in locator and find assets has no option to search on null or not null predicates. This will now be provided.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- task 0108386 metadata
-- 
------------------------------------------------------------------
INSERT INTO hig_codes ( HCO_DOMAIN,
                                 HCO_CODE,
                                 HCO_MEANING,
                                 HCO_SYSTEM,
                                 HCO_SEQ)
SELECT 'PBI_SR_COND', 'IS NOT NULL', 'Value is not Null', 'Y', 8 
FROM dual 
WHERE NOT EXISTS (SELECT 1 
                            FROM hig_codes 
                          WHERE hco_domain = 'PBI_SR_COND' AND hco_code = 'IS NOT NULL')
UNION ALL
SELECT 'PBI_SR_COND', 'IS NULL', 'Value is Null', 'Y', 9 
FROM dual 
WHERE NOT EXISTS (SELECT 1 
                            FROM hig_codes 
                          WHERE hco_domain = 'PBI_SR_COND' AND hco_code = 'IS NULL');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Theme metadata corrections
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 108957
-- 
-- TASK DETAILS
-- No details supplied
-- 
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Correct theme metadata for existing themes
-- 
------------------------------------------------------------------
UPDATE nm_themes_all
   SET nth_label_column = nth_pk_column
 WHERE NOT EXISTS
         (SELECT 'x'
            FROM user_tab_columns
           WHERE nth_table_name = table_name
             AND nth_label_column = column_name);

UPDATE nm_themes_all
   SET nth_rse_fk_column = NULL
     , nth_st_chain_column = NULL
     , nth_end_chain_column = NULL
     , nth_start_date_column = 'IIT_START_DATE'
     , nth_end_date_column = 'IIT_END_DATE'
 WHERE nth_table_name IN ('V_NM_TP21', 'V_NM_TP22', 'V_NM_TP23');  
  
UPDATE nm_themes_all
   SET nth_rse_fk_column = NULL
     , nth_st_chain_column = NULL
     , nth_end_chain_column = NULL
     , nth_start_date_column = 'TP21_START_DATE'
     , nth_end_date_column = 'TP21_END_DATE'
 WHERE nth_table_name = 'V_NM_NSG_ASD_TP21';


UPDATE nm_themes_all
   SET nth_rse_fk_column = NULL
     , nth_st_chain_column = NULL
     , nth_end_chain_column = NULL
     , nth_start_date_column = 'TP22_START_DATE'
     , nth_end_date_column = 'TP22_END_DATE'
 WHERE nth_table_name = 'V_NM_NSG_ASD_TP22'; 

UPDATE nm_themes_all
   SET nth_rse_fk_column = NULL
     , nth_st_chain_column = NULL
     , nth_end_chain_column = NULL
     , nth_start_date_column = 'TP23_START_DATE'
     , nth_end_date_column = 'TP23_END_DATE'
 WHERE nth_table_name = 'V_NM_NSG_ASD_TP23';

UPDATE nm_themes_all
   SET nth_label_column = 'NE_ID'
 WHERE nth_table_name IN
           ('NM_NAT_NSGN_OFFN_SDO'
          , 'V_NM_NAT_NSGN_OFFN_SDO'
          , 'NM_NAT_NSGN_RDNM_SDO'
          , 'V_NM_NAT_NSGN_RDNM_SDO'
          , 'NM_NAT_NSGN_UOFF_SDO'
          , 'V_NM_NAT_NSGN_UOFF_SDO');

UPDATE nm_themes_all
   SET nth_start_date_column = 'NE_START_DATE'
     , nth_end_date_column = NULL
 WHERE nth_table_name
    IN ('V_NM_NAT_NSGN_OFFN_SDO_DT'
       ,'V_NM_NAT_NSGN_RDNM_SDO_DT'
       ,'V_NM_NAT_NSGN_UOFF_SDO_DT');
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

