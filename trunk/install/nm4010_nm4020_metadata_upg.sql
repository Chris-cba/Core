------------------------------------------------------------------
-- nm4010_nm4020_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4010_nm4020_metadata_upg.sql-arc   2.1   Jul 19 2007 10:21:30   gjohnson  $
--       Module Name      : $Workfile:   nm4010_nm4020_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 19 2007 10:21:30  $
--       Date fetched Out : $Modtime:   Jul 19 2007 10:13:54  $
--       Version          : $Revision:   2.1  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
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

------------------------------------------------------------------
COMMIT
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

