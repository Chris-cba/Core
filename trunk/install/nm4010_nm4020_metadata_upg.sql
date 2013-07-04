------------------------------------------------------------------
-- nm4010_nm4020_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4010_nm4020_metadata_upg.sql-arc   2.9   Jul 04 2013 14:09:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4010_nm4020_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:09:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:18  $
--       Version          : $Revision:   2.9  $
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
PROMPT New module insert (UKP0027) for hig_standard_favourites
SET TERM OFF

-- GJ  11-MAY-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added at previous UKP release - but need ensure the data is there
------------------------------------------------------------------
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_LOAD_DATA'
       ,'UKP0027'
       ,'Weighting Set Maintenance'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'UKP_LOAD_DATA'
                    AND  HSTF_CHILD = 'UKP0027');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New module insert (ukp0043) for hig_standard_favourites
SET TERM OFF

-- GJ  11-MAY-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added at previous UKP release - but need ensure the data is there
------------------------------------------------------------------
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP'
       ,'UKP0043'
       ,'Road Condition Indicator Coverage'
       ,'M'
       ,8 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'UKP'
                    AND  HSTF_CHILD = 'UKP0043');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Update NMWEB0043 HIG_MODULES
SET TERM OFF

-- JWA  25-MAY-2007
-- 
-- DEVELOPMENT COMMENTS
-- <Null>
------------------------------------------------------------------
update hig_modules set hmo_filename = 'nm3file.web_upload_to_dir' where hmo_module = 'NMWEB0043';
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_ERRORS 449 and 450
SET TERM OFF

-- GJ  01-JUN-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added by KA
-- Related to the shift operation within nm3recal.
------------------------------------------------------------------
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,449
       ,null
       ,'Shift causes overhang at beginning of the section'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 449);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,450
       ,null
       ,'Shift causes overhang at end of the section'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 450);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New HIG_CODES for HISTORY_OPERATION domain.
SET TERM OFF

-- AE  03-JUL-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added by KA. Added records to HIG_CODES for new entries in the HISTORY_OPERATION domain.
------------------------------------------------------------------
INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'HISTORY_OPERATION'
       ,'B'
       ,'Recalibrate'
       ,'Y'
       ,7
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'HISTORY_OPERATION'
                    AND  HCO_CODE = 'B');

INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'HISTORY_OPERATION'
       ,'H'
       ,'Shift'
       ,'Y'
       ,8
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'HISTORY_OPERATION'
                    AND  HCO_CODE = 'H');

INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'HISTORY_OPERATION'
       ,'E'
       ,'Manual Edit'
       ,'Y'
       ,9
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'HISTORY_OPERATION'
                    AND  HCO_CODE = 'E');

INSERT INTO HIG_CODES
       (HCO_DOMAIN
       ,HCO_CODE
       ,HCO_MEANING
       ,HCO_SYSTEM
       ,HCO_SEQ
       ,HCO_START_DATE
       ,HCO_END_DATE
       )
SELECT 
        'HISTORY_OPERATION'
       ,'V'
       ,'Reverse'
       ,'Y'
       ,10
       ,null
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'HISTORY_OPERATION'
                    AND  HCO_CODE = 'V');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_ERRORS NET 451 and 452
SET TERM OFF

-- AE  19-JUL-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added by KA for historic asset locations.
------------------------------------------------------------------
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,451
       ,null
       ,'Cannot locate asset on this network as its measures have been modified'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 451);
--
INSERT INTO NM_ERRORS
       (NER_APPL
       ,NER_ID
       ,NER_HER_NO
       ,NER_DESCR
       ,NER_CAUSE
       )
SELECT 
        'NET'
       ,452
       ,null
       ,'Cannot locate asset on this network as it has been edited.'
       ,'' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 452);

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Sequence assoc for neh_id_seq
SET TERM OFF

-- AE  19-JUL-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added by KA for historic asset locations.
------------------------------------------------------------------
INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
       (HSA_TABLE_NAME
       ,HSA_COLUMN_NAME
       ,HSA_SEQUENCE_NAME
       ,HSA_LAST_REBUILD_DATE
       )
SELECT 
        'NM_ELEMENT_HISTORY'
       ,'NEH_ID'
       ,'NEH_ID_SEQ'
       ,null FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_SEQUENCE_ASSOCIATIONS
                   WHERE HSA_TABLE_NAME = 'NM_ELEMENT_HISTORY'
                    AND  HSA_COLUMN_NAME = 'NEH_ID');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Historic Asset Loader Product Options
SET TERM OFF

-- AE  24-JUL-2007
-- 
-- DEVELOPMENT COMMENTS
-- Added by KA for historic asset locations.
------------------------------------------------------------------
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       )
SELECT 
        'USEORIGHU'
       ,'NET'
       ,'Use original homo update'
       ,'Used in the historic asset loader, if set to Y this reverts to the original homo update code completely'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'USEORIGHU');
--
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       )
SELECT 
        'HISTINVLOC'
       ,'NET'
       ,'Enable Historic Asset Location'
       ,'Set to Y to enable historic loation of assets when the network has been edited.'
       ,'Y_OR_N'
       ,'VARCHAR2'
       ,'N'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'HISTINVLOC');
--
INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'USEORIGHU'
       ,'Y' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'USEORIGHU');
--
INSERT INTO HIG_OPTION_VALUES
       (HOV_ID
       ,HOV_VALUE
       )
SELECT 
        'HISTINVLOC'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES
                   WHERE HOV_ID = 'HISTINVLOC');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_ERROR HIG-444
SET TERM OFF

-- GJ  06-AUG-2007
-- 
-- ASSOCIATED LOG#
-- 709074
-- 
-- CUSTOMER
-- Hampshire County Council
-- 
-- PROBLEM
-- Two issues within SM/NM3. 1. Invalid characters in earlier closed version of USRNs and 2. Identical version of USRNs
-- 
-- DEVELOPMENT COMMENTS
-- Generic error message for use when checking strings and characters sets
------------------------------------------------------------------
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_HER_NO
                      , NER_DESCR
                      , NER_CAUSE )
SELECT 'HIG'
      , 444
      , NULL
      , 'Invalid character(s) detected in string'
      , NULL
FROM dual
WHERE NOT EXISTS (SELECT 'already there'
                  FROM   nm_errors
                  WHERE  ner_appl = 'HIG'
                  AND    ner_id = 444)
/
commit
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT nm_character_sets
SET TERM OFF

-- MAX  07-AUG-2007
-- 
-- ASSOCIATED LOG#
-- 709074
-- 
-- CUSTOMER
-- Hampshire County Council
-- 
-- PROBLEM
-- Two issues within SM/NM3. 1. Invalid characters in earlier closed version of USRNs and 2. Identical version of USRNs
-- 
-- DEVELOPMENT COMMENTS
-- Metadata to support and maintain nm_character_sets
------------------------------------------------------------------
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
        'HIG9150'
       ,'Maintain Character Sets'
       ,'hig9150'
       ,'FMX'
       ,''
       ,'N'
       ,'N'
       ,'HIG'
       ,'FORM' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULES
                   WHERE HMO_MODULE = 'HIG9150');
--
--
UPDATE HIG_STANDARD_FAVOURITES
SET    HSTF_ORDER  = 180
WHERE  HSTF_PARENT = 'HIG_REFERENCE'
AND    HSTF_CHILD  = 'HIG_REFERENCE_MAIL'
AND    HSTF_ORDER  = 18;
--
UPDATE HIG_STANDARD_FAVOURITES
SET    HSTF_ORDER  = 190
WHERE  HSTF_PARENT = 'HIG_REFERENCE'
AND    HSTF_CHILD  = 'HIG_REFERENCE_REPORTS'
AND    HSTF_ORDER  = 19;
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'HIG_REFERENCE'
       ,'HIG9150'
       ,'Maintain Character Sets'
       ,'M'
       ,18 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'HIG_REFERENCE'
                    AND  HSTF_CHILD = 'HIG9150');
--
INSERT INTO HIG_MODULE_ROLES
       (HMR_MODULE
       ,HMR_ROLE
       ,HMR_MODE
       )
SELECT 
        'HIG9150'
       ,'HIG_ADMIN'
       ,'NORMAL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_MODULE_ROLES
                   WHERE HMR_MODULE = 'HIG9150'
                    AND  HMR_ROLE = 'HIG_ADMIN');
--
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NCSM_PK'
       ,'NM_CHARACTER_SET_MEMBERS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NCSM_PK');
--
--
INSERT INTO HIG_CHECK_CONSTRAINT_ASSOCS
       (HCCA_CONSTRAINT_NAME
       ,HCCA_TABLE_NAME
       ,HCCA_NER_APPL
       ,HCCA_NER_ID
       )
SELECT 
        'NCS_PK'
       ,'NM_CHARACTER_SETS'
       ,'HIG'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CHECK_CONSTRAINT_ASSOCS
                   WHERE HCCA_CONSTRAINT_NAME = 'NCS_PK');
--
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add nm_special_chars data to nm_character_set functionalitty
SET TERM OFF

-- MAX  08-AUG-2007
-- 
-- ASSOCIATED LOG#
-- 709074
-- 
-- CUSTOMER
-- Hampshire County Council
-- 
-- PROBLEM
-- Two issues within SM/NM3. 1. Invalid characters in earlier closed version of USRNs and 2. Identical version of USRNs
-- 
-- DEVELOPMENT COMMENTS
-- Table nm_special_chars dropped and contents now part of nm_character_sets and nm_character_set_members table structures and functionality under ncs_code = 'INVALID_FOR_DDL'.  This is the insert fromk table to be dropped sql.
------------------------------------------------------------------
--
--********** NM_CHARACTER_SETS **********--
PROMPT nm_character_sets
--
-- Columns
-- NCS_CODE                       NOT NULL VARCHAR2(20)
--   NCS_PK (Pos 1)
-- NCS_DESCRIPTION                NOT NULL VARCHAR2(100)
--
--
INSERT INTO NM_CHARACTER_SETS
       (NCS_CODE
       ,NCS_DESCRIPTION
       )
SELECT 
        'INVALID_FOR_DDL'
       ,'Invalid Characters for DDL' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SETS
                   WHERE NCS_CODE = 'INVALID_FOR_DDL');
--
--
--********** NM_CHARACTER_SET_MEMBERS **********--
PROMPT nm_character_set_members
--
-- Columns
-- NCSM_NCS_CODE                  NOT NULL VARCHAR2(20)
--   NCSM_PK (Pos 1)
--   NCSM_NCS_FK (Pos 1)
-- NCSM_ASCII_CHARACTER           NOT NULL NUMBER(3)
--   NCSM_PK (Pos 2)
--
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,32 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 32);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,33 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 33);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,34 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 34);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,35 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 35);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,36 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 36);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,37 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 37);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,38 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 38);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,39 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 39);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 40);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,41 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 41);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,42 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 42);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,43 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 43);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,44 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 44);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,45 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 45);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,46 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 46);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,47 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 47);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,58 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 58);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,59 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 59);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,60 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 60);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,61 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 61);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,62 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 62);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,63 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 63);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,64 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 64);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,91 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 91);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,92 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 92);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,93 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 93);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,94 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 94);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,96 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 96);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,123 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 123);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,124 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 124);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,125 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 125);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,126 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 126);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,127 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 127);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,128 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 128);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,129 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 129);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,130 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 130);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,131 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 131);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,132 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 132);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,133 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 133);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,134 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 134);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,135 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 135);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,136 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 136);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,137 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 137);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,138 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 138);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,139 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 139);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,140 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 140);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,141 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 141);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,142 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 142);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,143 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 143);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,144 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 144);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,145 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 145);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,146 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 146);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,147 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 147);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,148 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 148);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,149 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 149);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,150 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 150);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,151 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 151);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,152 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 152);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,153 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 153);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,154 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 154);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,155 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 155);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,156 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 156);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,157 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 157);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,158 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 158);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,159 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 159);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,160 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 160);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,161 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 161);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,162 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 162);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,163 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 163);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,164 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 164);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,165 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 165);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,166 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 166);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,167 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 167);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,168 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 168);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,169 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 169);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,170 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 170);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,171 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 171);
--
INSERT INTO NM_CHARACTER_SET_MEMBERS
       (NCSM_NCS_CODE
       ,NCSM_ASCII_CHARACTER
       )
SELECT 
        'INVALID_FOR_DDL'
       ,172 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM NM_CHARACTER_SET_MEMBERS
                   WHERE NCSM_NCS_CODE = 'INVALID_FOR_DDL'
                    AND  NCSM_ASCII_CHARACTER = 172);
--

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New Domain - ROAD_SYS_FLAG
SET TERM OFF

-- JWA  31-JUL-2007
-- 
-- DEVELOPMENT COMMENTS
-- New domain and associated codes added for UKPMS upgrade.
------------------------------------------------------------------
INSERT INTO HIG_DOMAINS
       (HDO_DOMAIN 
       ,HDO_PRODUCT 	
       ,HDO_TITLE    
       ,HDO_CODE_LENGTH 
       )
SELECT 'ROAD_SYS_FLAG'
       ,'HIG'
       ,'Road System Flag'
       ,1
FROM  DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_DOMAINS
                   WHERE HDO_DOMAIN = 'ROAD_SYS_FLAG'
);

INSERT INTO HIG_CODES
       (HCO_DOMAIN 
       ,HCO_CODE 
	   ,HCO_MEANING
	   ,HCO_SYSTEM
	   ,HCO_SEQ
	   ,HCO_START_DATE
	   ,HCO_END_DATE
	   )
SELECT 'ROAD_SYS_FLAG'
       ,'D'
       ,'DTP'
       ,'Y'
	   ,NULL
	   ,NULL
	   ,NULL
FROM  DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'ROAD_SYS_FLAG'
				     AND HCO_CODE = 'D'
);

INSERT INTO HIG_CODES
       (HCO_DOMAIN 
       ,HCO_CODE 
	   ,HCO_MEANING
	   ,HCO_SYSTEM
	   ,HCO_SEQ
	   ,HCO_START_DATE
	   ,HCO_END_DATE
	   )
SELECT 'ROAD_SYS_FLAG'
       ,'L'
       ,'Local'
       ,'Y'
	   ,NULL
	   ,NULL
	   ,NULL
FROM  DUAL
WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'ROAD_SYS_FLAG'
				     AND HCO_CODE = 'L'
);


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT HIG_STANDARD_FAVOURITES for NSG0090
SET TERM OFF

-- GJ  13-AUG-2007
-- 
-- DEVELOPMENT COMMENTS
-- Part of the "Street Gazetteer Manager to support Scottish ASD" enhancement
------------------------------------------------------------------
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_DATA'
       ,'NSG0090'
       ,'Configure ASD'
       ,'M'
       ,50 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NSG_DATA'
                    AND  HSTF_CHILD = 'NSG0090');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT HIG_STANDARD_FAVOURITES for UKP_MAINTAIN_DATA
SET TERM OFF

-- GJ  21-AUG-2007
-- 
-- DEVELOPMENT COMMENTS
-- Ensure all of the correct menu options that appear under the UKP_MAINTAIN_DATA branch of the favourites tree are present.
------------------------------------------------------------------
delete from hig_standard_favourites
where hstf_parent = 'UKP_MAINTAIN_DATA'
/
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_MAINTAIN_DATA'
       ,'MAI2140'
       ,'Query Network/Inventory Data'
       ,'M'
       ,30 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'UKP_MAINTAIN_DATA'
                    AND  HSTF_CHILD = 'MAI2140');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_MAINTAIN_DATA'
       ,'MAI2310'
       ,'Inventory'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'UKP_MAINTAIN_DATA'
                    AND  HSTF_CHILD = 'MAI2310');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_MAINTAIN_DATA'
       ,'MAI2310A'
       ,'Condition Data'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'UKP_MAINTAIN_DATA'
                    AND  HSTF_CHILD = 'MAI2310A');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'UKP_MAINTAIN_DATA'
       ,'NET1119'
       ,'Network Selection'
       ,'M'
       ,40 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'UKP_MAINTAIN_DATA'
                    AND  HSTF_CHILD = 'NET1119');
                    
commit;
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT nm_errors hig 445
SET TERM OFF

-- SSC  28-AUG-2007
-- 
-- ASSOCIATED LOG#
-- 704527
-- 
-- CUSTOMER
-- Exor Corporation Ltd
-- 
-- PROBLEM
-- Duplicate users problem
-- 
-- DEVELOPMENT COMMENTS
-- Users could create a new user with a username which already existed on an alternate schema on the same database and the form would allow this.  Changes made to hig1832 and nmddl.pkb to call this error.
------------------------------------------------------------------
INSERT INTO nm_errors
            (ner_appl
            , ner_id
            , ner_her_no
            , ner_descr
            , ner_cause)
   SELECT 'HIG'
         , 445
         , NULL
         ,'This username currently exists on this database, but within another schema.  Either enter an alternate username or contact your System Administrator.'
         ,NULL
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM nm_errors
                       WHERE ner_appl = 'HIG' AND ner_id = 445);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Metadata for GIS0011
SET TERM OFF

-- AE  12-SEP-2007
-- 
-- DEVELOPMENT COMMENTS
-- Metadata required for new form, GIS0011
------------------------------------------------------------------
insert into hig_modules
	(hmo_module
	,hmo_title
	,hmo_filename
    ,hmo_module_type
	,hmo_fastpath_opts
	,hmo_fastpath_invalid
	,hmo_use_gri
	,hmo_application
	,hmo_menu)
select 'GIS0011'
       ,'Maintain Visible Themes'
	   ,'gis0011'
	   ,'FMX'
	   ,NULL
	   ,'N'
	   ,'N'
	   ,'HIG'
	   ,'FORM'
from dual
where not exists (select 1
                    from hig_modules
				   where hmo_module = 'GIS0011');

insert into hig_modules
     (hmo_module
	 ,hmo_title
	 ,hmo_filename
	 ,hmo_module_type
	 ,hmo_fastpath_opts
	 ,hmo_fastpath_invalid
	 ,hmo_use_gri
	 ,hmo_application
	 ,hmo_menu)
select 'GIS0011'
      ,'Maintain Visible Themes'
	  ,'gis0011'
	  ,'FMX'
	  ,NULL
	  ,'N'
	  ,'N'
	  ,'HIG'
	  ,'FORM'
  from dual
  where not exists (select 1
                      from hig_modules
					 where hmo_module = 'GIS0011');

insert into hig_module_roles
     (hmr_module
	  ,hmr_role
	  ,hmr_mode)
select 'GIS0011'
       ,'HIG_USER'
	   ,'NORMAL'
from dual
where not exists (select 1
                    from hig_module_roles
				   where hmr_module = 'GIS0011'
				     and hmr_role = 'HIG_USER');

insert into hig_standard_favourites
   (hstf_parent
   ,hstf_child
   ,hstf_descr
   ,hstf_type
   ,hstf_order)
select 'HIG_GIS'
       ,'GIS0011'
	   ,'Maintain Visible Themes'
	   ,'M'
	   ,3
from dual where not exists (select 1
                              from hig_standard_favourites
							 where hstf_parent = 'HIG_GIS'
							   and hstf_child = 'GIS0011');

insert into nm_themes_visible
select nth_theme_id, 'Y'
from nm_themes_all
where nth_theme_type = 'SDO';
     
INSERT
  INTO hig_option_list
      (hol_id
      ,hol_product
      ,hol_name
      ,hol_remarks
      ,hol_domain
      ,hol_datatype
      ,hol_mixed_case
      ,hol_user_option) 
SELECT 'DEFVISNTH'
      ,'HIG'
      ,'Default Visible Theme Flag'
      ,'This option must be Y or N'
      ,'Y_OR_N'
      ,'VARCHAR2'
      ,'N'
      ,'N'
  FROM dual
 WHERE NOT EXISTS(SELECT 1
                    FROM hig_option_list
                   WHERE hol_id = 'DEFVISNTH');

INSERT
  INTO hig_option_values
      (hov_id
      ,hov_value)
SELECT 'DEFVISNTH'
      ,'N'
  FROM dual
 WHERE NOT EXISTS(SELECT 1
                    FROM  hig_option_values
                   WHERE  hov_id = 'DEFVISNTH');


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT new product option WEBCONFIG
SET TERM OFF

-- DY  14-SEP-2007
-- 
-- DEVELOPMENT COMMENTS
-- New Product Option WEBCONFIG for use with Oracle Single Sign On in HIG.pll
------------------------------------------------------------------
INSERT
  INTO hig_option_list
      (hol_id
      ,hol_product
      ,hol_name
      ,hol_remarks
      ,hol_domain
      ,hol_datatype
      ,hol_mixed_case
      ,hol_user_option) 
SELECT 'WEBCONFIG'
      ,'HIG'
      ,'Config Value'      
      ,'Set this to the required sso_userid - A maximum of 30 characters'
      ,NULL
      ,'VARCHAR2'
      ,'Y'
      ,'Y'
  FROM dual
 WHERE NOT EXISTS(SELECT 1
                    FROM hig_option_list
                   WHERE hol_id = 'WEBCONFIG')
/

INSERT
  INTO hig_option_values
      (hov_id
      ,hov_value)
SELECT 'WEBCONFIG'
      ,'Y'
  FROM dual
 WHERE NOT EXISTS(SELECT 1
                    FROM  hig_option_values
                   WHERE  hov_id = 'WEBCONFIG')
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT product option WMSDEFSTAT
SET TERM OFF

-- SSC  18-SEP-2007
-- 
-- DEVELOPMENT COMMENTS
-- New production option added to 4020 upgrade script as requested by Andy Rowlinson via Mike Huitson.
-- New product option WMSDEFSTAT.
------------------------------------------------------------------
INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE) 
SELECT 'WMSDEFSTAT', 'HIG', 'WMS Default State', 'Set to 0 if WMS is not to be displayed at startup. Set to 1 if WMS is to be displayed at startup',
 '', 'VARCHAR2', 'Y'
FROM DUAL 
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST 
                   WHERE HOL_ID = 'WMSDEFSTAT'); 
 

Insert into hig_option_values 
Select 'WMSDEFSTAT','0' 
From dual 
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_VALUES 
                   WHERE HOV_ID = 'WMSDEFSTAT');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Product option for 31 type recs in EDIF file
SET TERM OFF

-- MAX  21-SEP-2007
-- 
-- DEVELOPMENT COMMENTS
-- Product option for 31 type recs in EDIF file: Type 31 recs now restrict by product option EDIFDLROLE when a valid role is entered as the value.  This will restrict by users with the role set in the product option or all users.
------------------------------------------------------------------
INSERT INTO HIG_OPTION_LIST
       (HOL_ID
       ,HOL_PRODUCT
       ,HOL_NAME
       ,HOL_REMARKS
       ,HOL_DOMAIN
       ,HOL_DATATYPE
       ,HOL_MIXED_CASE
       ,HOL_USER_OPTION
       )
SELECT 
        'EDIFDLROLE'
       ,'HIG'
       ,'EDIF Download Users Role'
       ,'EDIF Download Users Role restricts to users with specified role (all users apply when null).'
       ,''
       ,'VARCHAR2'
       ,'N'
       ,'N' FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'EDIFDLROLE');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Hig_standard_favourites for AVM
SET TERM OFF

-- SSC  25-SEP-2007
-- 
-- DEVELOPMENT COMMENTS
-- AVM product changed to install at v4.0.2.0.
-- The hig_standard_favourites data must be included in the nm3 upgrade to v4.0.2.0 script to ensure the menu is available.
------------------------------------------------------------------
-- Create AVM main menu

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'FAVOURITES', 'AVM', 'Asset Valuation Manager', 'F', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'AVM' AND hstf_parent = 'FAVOURITES');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'AVM', 'VM_VAL', 'Valuations', 'F', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM_VAL' AND hstf_parent = 'AVM');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'AVM', 'VM_REP', 'Reports', 'F', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM_REP' AND hstf_parent = 'AVM');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'AVM', 'VM_REF', 'Reference Data', 'F', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM_REF' AND hstf_parent = 'AVM');


-------------------------------------------------------------------------------------------
-- Create AVM Valuations menu

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_VAL', 'VM1040', 'Asset Valuations', 'M', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1040' AND hstf_parent = 'VM_VAL');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_VAL', 'VM1030', 'Asset Registers', 'M', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1030' AND hstf_parent = 'VM_VAL');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_VAL', 'NM0510', 'Asset Items', 'M', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'NM0510' AND hstf_parent = 'VM_VAL');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_VAL', 'VM1044', 'Close a Valuation', 'M', 4
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1044' AND hstf_parent = 'VM_VAL');

-------------------------------------------------------------------------------------------
-- Create AVM Reports menu

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REP', 'VM1050', 'Asset Valuation Report', 'M', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1050' AND hstf_parent = 'VM_REP');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REP', 'VM1052', 'Asset Movements Report', 'M', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1052' AND hstf_parent = 'VM_REP');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REP', 'VM1054', 'Valuation Ruleset Report', 'M', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1054' AND hstf_parent = 'VM_REP');

-------------------------------------------------------------------------------------------
-- Create AVM Reference Data menu

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REF', 'VM1000', 'Valuation Attribute Types', 'M', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1000' AND hstf_parent = 'VM_REF');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REF', 'VM1010', 'Valuation Rulesets', 'M', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1010' AND hstf_parent = 'VM_REF');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REF', 'VM1060', 'Valuation Report Definitions', 'M', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1060' AND hstf_parent = 'VM_REF');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REF', 'VM1020', 'Asset Register Types', 'M', 4
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'VM1020' AND hstf_parent = 'VM_REF');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REF', 'NM0410', 'Asset Metamodel', 'M', 5
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'NM0410' AND hstf_parent = 'VM_REF');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'VM_REF', 'HIG1820', 'Units And Conversions', 'M', 6
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_child = 'HIG1820' AND hstf_parent = 'VM_REF');
-------------------------------------------------------------------------------------------
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT hig_standard_favourites for PROW
SET TERM OFF

-- SSC  26-SEP-2007
-- 
-- DEVELOPMENT COMMENTS
-- **** COMMENTS TO BE ADDED BY SSC ****
------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Create PROW main menu

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'FAVOURITES', 'PROW', 'Public Rights Of Way Manager', 'F', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'FAVOURITES' AND hstf_child = 'PROW');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW', 'PROW_OPERATIONS', 'Operations', 'F', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW' AND hstf_child = 'PROW_OPERATIONS');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW', 'PROW_DEFINITIVE', 'Definitive Map', 'F', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW' AND hstf_child = 'PROW_DEFINITIVE');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW', 'PROW_REFERENCE', 'Reference Data', 'F', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW' AND hstf_child = 'PROW_REFERENCE');


----------------------------------------------------------------------------------
-- Create PROW Operations menu

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6000', 'Worktray', 'M', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6000');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6012', 'Enquiry Summary', 'M', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6012');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'DOC0150', 'Enquiries', 'M', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'DOC0150');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6022', 'Contacts', 'M', 4
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6022');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'NM0510', 'Asset Items', 'M', 5
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'NM0510');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6021', 'Land Ownership Summary', 'M', 6
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6021');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6020', 'Land Ownership', 'M', 7
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6020');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6030', 'Access Land', 'M', 8
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6030');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6050', 'Access Land History', 'M', 9
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6050');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6222', 'Enforcement Summary', 'M', 10
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6222');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6220', 'Enforcements', 'M', 11
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6220');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6230', 'Prosecutions', 'M', 12
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6230');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6210', 'Vehicle Use Licences', 'M', 13
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6210');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_OPERATIONS', 'PROW6060', 'Path History', 'M', 14
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_OPERATIONS' AND hstf_child = 'PROW6060');


----------------------------------------------------------------------------------
-- Create PROW Definitive Map menu

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6000', 'Worktray', 'M', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6000');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6012', 'Enquiry Summary', 'M', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6012');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'DOC0150', 'Enquiries', 'M', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'DOC0150');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6022', 'Contacts', 'M', 4
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6022');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6240', 'Depositions', 'M', 5
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6240');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6250', 'Definitive Statement', 'M', 6
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6250');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6261', 'Public Path Order Summary', 'M', 7
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6261');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6260', 'Public Path Orders', 'M', 8
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6260');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6271', 'Modification Order Summary', 'M', 9
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6271');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6270', 'Modification Orders', 'M', 10
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6270');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6281', 'Path Closure Summary', 'M', 11
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6281');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6280', 'Path Closures', 'M', 12
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6280');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_DEFINITIVE', 'PROW6060', 'Path History', 'M', 13
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_DEFINITIVE' AND hstf_child = 'PROW6060');


----------------------------------------------------------------------------------
-- Create PROW Reference Data menu


INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_REFERENCE', 'PROW9120', 'Domains', 'M', 1
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_REFERENCE' AND hstf_child = 'PROW9120');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_REFERENCE', 'NM0410', 'Asset Metamodel', 'M', 2
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_REFERENCE' AND hstf_child = 'NM0410');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_REFERENCE', 'PROW6002', 'Worktray Blocks', 'M', 3
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_REFERENCE' AND hstf_child = 'PROW6002');

INSERT INTO hig_standard_favourites
            (hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order)
   SELECT 'PROW_REFERENCE', 'PROW6292', 'Audit Options', 'M', 4
     FROM DUAL
    WHERE NOT EXISTS (SELECT 1
                        FROM hig_standard_favourites
                       WHERE hstf_parent = 'PROW_REFERENCE' AND hstf_child = 'PROW6292');
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Derived Assets Mrg Query menu changes
SET TERM OFF

-- PT  11-OCT-2007
-- 
-- DEVELOPMENT COMMENTS
-- Remove nm0420 and nm7051, add nm0430, nm0435, nm7051b to modules and standard favourites
------------------------------------------------------------------

-- deletes
delete from hig_module_keywords d
where d.hmk_hmo_module in ('NM0420','NM0430','NM0435','NM7051','NM7051B')
/
delete from hig_module_roles d
where d.hmr_module in ('NM0420','NM0430','NM0435','NM7051','NM7051B')
/
delete from hig_standard_favourites d
where d.hstf_child in ('NM0420','NM0430','NM0435','NM7051','NM7051B')
/
delete from hig_modules d
where d.hmo_module in ('NM0420','NM0430','NM0435','NM7051','NM7051B')
/

-- inserts --

-- 1 hig_modules
insert into hig_modules (
  hmo_module, hmo_title, hmo_filename, hmo_module_type, hmo_fastpath_invalid, hmo_use_gri, hmo_application, hmo_menu
)
select 'NM0430', 'Derived Asset Setup', 'nm0430', 'FMX', 'N', 'N', 'AST', 'FORM' from dual
union all
select 'NM0435', 'Create Derived Assets', 'nm0435', 'FMX', 'N', 'N', 'AST', 'FORM' from dual
union all
select 'NM7051B', 'Merge Query Results', 'nm7051b', 'FMX', 'N', 'N', 'AST', 'FORM' from dual
/

-- 2 hig_module_keywords
insert into hig_module_keywords (
  hmk_hmo_module, hmk_keyword, hmk_owner
)
select 'NM7051B', 'MERGE QUERY RESULTS', 1 from dual
/

-- 3 hig_module_roles
insert into hig_module_roles (
  hmr_module, hmr_role, hmr_mode
)
select 'NM0430', 'HIG_ADMIN', 'NORMAL' from dual
union all
select 'NM0435', 'HIG_ADMIN', 'NORMAL' from dual
union all
select 'NM7051B', 'HIG_USER', 'NORMAL' from dual
/

-- 4 hig_standard_favourites
insert into hig_standard_favourites (
  hstf_parent, hstf_child, hstf_descr, hstf_type, hstf_order
)
select 'AST_REF', 'NM0430', 'Derived Asset Setup', 'M', 9 from dual
union all
select 'AST_REF', 'NM0435', 'Create Derived Assets', 'M', 10 from dual
union all
select 'NET_QUERIES', 'NM7051B', 'Merge Query Results', 'M', 6 from dual
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

