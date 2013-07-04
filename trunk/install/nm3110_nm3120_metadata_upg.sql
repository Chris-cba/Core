-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3110_nm3120_metadata_upg.sql	1.1 07/14/04
--       Module Name      : nm3110_nm3120_metadata_upg.sql
--       Date into SCCS   : 04/07/14 15:12:20
--       Date fetched Out : 07/06/13 13:57:46
--       SCCS Version     : 1.1
--
--   Product metadata upgrade script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

SET FEEDBACK OFF
--
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
----------------------------------------------------------------------------
--Call a proc in nm_debug to instantiate it before calling metadata scripts.
--
--If this is not done any inserts into hig_option_values may fail due to
-- mutating trigger when nm_debug checks DEBUGAUTON.
----------------------------------------------------------------------------
BEGIN
  nm_debug.debug_off;
END;
/

--
-------------------------------------------------------------------------------------------------
--
DECLARE
   --
   -- NM_ERRORS
   --
   l_tab_ner_id    nm3type.tab_number;
   l_tab_ner_descr nm3type.tab_varchar2000;
   l_tab_appl      nm3type.tab_varchar30;
   --
   l_tab_dodgy_ner_id    nm3type.tab_number;
   l_tab_dodgy_ner_appl  nm3type.tab_varchar30;
   l_tab_dodgy_descr_old nm3type.tab_varchar2000;
   l_tab_dodgy_descr_new nm3type.tab_varchar2000;
   --
   l_current_type  nm_errors.ner_appl%TYPE;
   --
   PROCEDURE add_ner (p_ner_id    number
                     ,p_ner_descr varchar2
                     ,p_app       varchar2 DEFAULT l_current_type
                     ) IS
      c_count CONSTANT pls_integer := l_tab_ner_id.COUNT+1;
   BEGIN
      l_tab_ner_id(c_count)    := p_ner_id;
      l_tab_ner_descr(c_count) := p_ner_descr;
      l_tab_appl(c_count)      := p_app;
   END add_ner;
   --
   PROCEDURE add_dodgy (p_ner_id        number
                       ,p_ner_descr_old varchar2
                       ,p_ner_descr_new varchar2
                       ,p_app           varchar2 DEFAULT l_current_type
                       ) IS
      c_count CONSTANT pls_integer := l_tab_dodgy_ner_id.COUNT+1;
   BEGIN
      l_tab_dodgy_ner_id(c_count)    := p_ner_id;
      l_tab_dodgy_descr_old(c_count) := p_ner_descr_old;
      l_tab_dodgy_descr_new(c_count) := NVL(p_ner_descr_new,p_ner_descr_old);
      l_tab_dodgy_ner_appl(c_count)  := p_app;
   END add_dodgy;
   --
BEGIN
   --
   -- HIG errors
   --
   l_current_type := nm3type.c_hig;
   --
   add_ner(231, 'Detail');


   --
   -- Fix dodgy NM_ERRORS records
   --
   l_current_type := nm3type.c_net;
   
--   add_dodgy (p_ner_id        => 
--             ,p_ner_descr_old => 
--             ,p_ner_descr_new => 
--             );


   FORALL i IN 1..l_tab_ner_id.COUNT
      INSERT INTO nm_errors
            (ner_appl
            ,ner_id
            ,ner_descr
            )
      SELECT l_tab_appl(i)
            ,l_tab_ner_id(i)
            ,l_tab_ner_descr(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  nm_errors
                         WHERE  ner_id   = l_tab_ner_id(i)
                          AND   ner_appl = l_tab_appl(i)
                        )
       AND   l_tab_ner_descr(i) IS NOT NULL;
   --
   FORALL i IN 1..l_tab_dodgy_ner_id.COUNT
      UPDATE nm_errors
       SET   ner_descr = l_tab_dodgy_descr_new (i)
      WHERE  ner_id    = l_tab_dodgy_ner_id(i)
       AND   ner_appl  = l_tab_dodgy_ner_appl(i)
       AND   ner_descr = l_tab_dodgy_descr_old(i);
   --
END;
/
--
-------------------------------------------------------------------------------------------------
-- Mapserver V3 Upgrade
-------------------------------------------------------------------------------------------------
--
INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPMSV', 'URL to specify the Oracle Mapviewer Servlet', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPMSV')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPNAME', 'Base Map Name', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPNAME')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPDSRC', 'Data Source Name', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPDSRC')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPDBUG', 'Web Mapping Debug Level', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPDBUG')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'WEBMAPTITL', 'Web Map Banner', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'WEBMAPTITL')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'OVRVWSTYLE', 'Web Map Overview Rectangle Line Style', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'OVRVWSTYLE')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'LINESTYLE', 'Web Map Highlight Line Style', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'LINESTYLE')
/

INSERT INTO HIG_CODES (HCO_DOMAIN, HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE)
SELECT 'USER_OPTIONS', 'POINTSTYLE', 'Web Map Highlight Point Style', 'Y', 99, null, null 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_CODES
                   WHERE HCO_DOMAIN = 'USER_OPTIONS'
                    AND  HCO_CODE = 'POINTSTYLE')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WEBMAPMSV', 'HIG', 'OMV Servlet URL', 'URL to specify the Oracle Mapviewer Servlet', '', 'VARCHAR2', 'Y' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPMSV')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WEBMAPNAME', 'HIG', 'Base Map', 'Name of the Base Map as defined in Oracle metadata', '', 'VARCHAR2', 'N' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPNAME')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WEBMAPDSRC', 'HIG', 'Data Source', 'Name of the JDBC Data Source connecting map server to RDBMS', '', 'VARCHAR2', 'N' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPDSRC')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WEBMAPDBUG', 'HIG', 'Map Debug', 'Debug Level for Web Mapping. 0 is off - 1 is on', '', 'VARCHAR2', 'N' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPDBUG')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'WEBMAPTITL', 'HIG', 'Map Banner', 'Title Text for Web Mapping', '', 'VARCHAR2', 'N' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'WEBMAPTITL')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'OVRVWSTYLE', 'HIG', 'Overview Line Style', 'Line style for overview map boundary indicator', '', 'VARCHAR2', 'N' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'OVRVWSTYLE')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'LINESTYLE', 'HIG', 'Map Highlight Line Style', 'Line style for Map Highlight', '', 'VARCHAR2', 'N' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'LINESTYLE')
/

INSERT INTO HIG_OPTION_LIST (HOL_ID, HOL_PRODUCT, HOL_NAME, HOL_REMARKS, HOL_DOMAIN, HOL_DATATYPE, HOL_MIXED_CASE)
SELECT 'POINTSTYLE', 'HIG', 'Map Highlight Point Style', 'Point style for Map Highlight', '', 'VARCHAR2', 'N' 
FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM HIG_OPTION_LIST
                   WHERE HOL_ID = 'POINTSTYLE')
/
--
-------------------------------------------------------------------------------------------------
--
SET FEEDBACK ON


