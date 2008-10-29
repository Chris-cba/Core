------------------------------------------------------------------
-- nm4050_nm4051_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4050_nm4051_metadata_upg.sql-arc   3.0   Oct 29 2008 14:59:10   malexander  $
--       Module Name      : $Workfile:   nm4050_nm4051_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Oct 29 2008 14:59:10  $
--       Date fetched Out : $Modtime:   Oct 29 2008 14:53:16  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2008

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
PROMPT HIG_STANDARD_FAVOURITES
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (GRAEME JOHNSON)
-- New data
-- 
------------------------------------------------------------------
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG'
       ,'NSG_ADMINISTRATION'
       ,'Administration'
       ,'F'
       ,3 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NSG'
                    AND  HSTF_CHILD = 'NSG_ADMINISTRATION');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_ADMINISTRATION'
       ,'NSG0120'
       ,'Administer User Districts'
       ,'M'
       ,10 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NSG_ADMINISTRATION'
                    AND  HSTF_CHILD = 'NSG0120');
--
INSERT INTO HIG_STANDARD_FAVOURITES
       (HSTF_PARENT
       ,HSTF_CHILD
       ,HSTF_DESCR
       ,HSTF_TYPE
       ,HSTF_ORDER
       )
SELECT 
        'NSG_ADMINISTRATION'
       ,'NSG0130'
       ,'My Districts'
       ,'M'
       ,20 FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_STANDARD_FAVOURITES
                   WHERE HSTF_PARENT = 'NSG_ADMINISTRATION'
                    AND  HSTF_CHILD = 'NSG0130');

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Add Oracle LRS Geometry Types to HIG_CODES
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Add Oracle LRS Geometry Types to HIG_CODES
-- 
------------------------------------------------------------------
INSERT INTO hig_codes
SELECT 'GEOMETRY_TYPE',
       TO_NUMBER (hco_code) + 300,
       hco_meaning || ' LRS',
       hco_system,
       hco_seq + 7,
       NULL,
       NULL
  FROM hig_codes a
 WHERE hco_domain = 'GEOMETRY_TYPE' 
   AND hco_code LIKE '300%'
   AND NOT EXISTS
     (SELECT 1 FROM hig_codes b
       WHERE TO_NUMBER(b.hco_code) = TO_NUMBER (a.hco_code) + 300
         AND b.hco_domain = 'GEOMETRY_TYPE');
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

