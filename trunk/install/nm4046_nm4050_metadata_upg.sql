------------------------------------------------------------------
-- nm4046_nm4050_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4046_nm4050_metadata_upg.sql-arc   3.1   Aug 11 2008 09:58:36   malexander  $
--       Module Name      : $Workfile:   nm4046_nm4050_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Aug 11 2008 09:58:36  $
--       Date fetched Out : $Modtime:   Aug 11 2008 09:55:14  $
--       Version          : $Revision:   3.1  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
------------------------------------------------------------------


------------------------------------------------------------------

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF
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
PROMPT Log712606, New product option (USEGRPSEC)
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STUART MARSHALL)
-- New product option 'USEGRPSEC'. Added to hig_option_list and hig_option_values.
-- 
------------------------------------------------------------------
Insert into HIG_OPTION_LIST
   (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, 
    HOL_DATATYPE, HOL_MIXED_CASE, HOL_USER_OPTION)
 select 'USEGRPSEC', 'NET', 'Use Group Admin Unit Security', 'Setting this option to ''N'' will ignore the group members admin unit security.', NULL, 
    'VARCHAR2', 'Y', 'N'
    from dual
    where not exists (select 1 from hig_option_list where hol_id = 'USEGRPSEC');

Insert into HIG_OPTION_VALUES
   (HOV_ID, HOV_VALUE)
 select 'USEGRPSEC', 'Y'
 from dual
 where not exists (select 1 from hig_option_values where hov_id = 'USEGRPSEC');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New NM_ERRORS message 454
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED PROBLEM MANAGER LOG#
-- 703811
-- 
-- CUSTOMER
-- Exor Corporation Ltd
-- 
-- PROBLEM
-- hig.pll requires enhancement to handle no theme functions
-- 
------------------------------------------------------------------

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (JAMES WADSWORTH)
-- New error message for log 703811
-- 
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
       ,454
       ,null
       ,'This item has no shape available'
       ,'' 
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM NM_ERRORS
                   WHERE NER_APPL = 'NET'
                    AND  NER_ID = 454);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT NM_NW_AD_LINK_ALL correction
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- End date any NM_NW_AD_LINK_ALL records that refer to end-dated Elements
-- 
------------------------------------------------------------------
ALTER TABLE nm_nw_ad_link_all DISABLE ALL TRIGGERS;

UPDATE nm_nw_ad_link_all
   SET nad_end_date = (SELECT ne_end_date 
                         FROM nm_elements_all
                        WHERE ne_id = nad_ne_id)
 WHERE nad_end_date IS NULL
   AND EXISTS
         (SELECT 1 
            FROM NM_ELEMENTS_ALL
           WHERE ne_end_date IS NOT NULL
             AND ne_id = nad_ne_id);

ALTER TABLE nm_nw_ad_link_all ENABLE ALL TRIGGERS;

------------------------------------------------------------------


------------------------------------------------------------------

COMMIT
/
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

