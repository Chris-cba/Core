------------------------------------------------------------------
-- nm4051_nm4052_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4051_nm4052_metadata_upg.sql-arc   3.2   Jul 04 2013 14:11:14   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4051_nm4052_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:11:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:20  $
--       Version          : $Revision:   3.2  $
--
------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.

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
PROMPT New error message
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- **** COMMENTS TO BE ADDED BY ADRIAN EDWARDS ****
-- 
------------------------------------------------------------------
INSERT INTO nm_errors
SELECT 'NET'
      , 455
      , NULL
      , 'The name you have chosen is a reserved word in Oracle - please choose a non-reserved word'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'NET'
       AND ner_id = 455);
--
INSERT INTO nm_errors
SELECT 'HIG'
      , 506
      , NULL
      , 'Cannot create Point. Please select a single point from the map to create a Point.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 506);
--
INSERT INTO nm_errors
SELECT 'HIG'
      , 507
      , NULL
      , 'Cannot create Line. Please select two or more points from the map to create a Line.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 507);
--
INSERT INTO nm_errors
SELECT 'HIG'
      , 508
      , NULL
      , 'Cannot create Polygon. Please select three or more points from the map to create a Polygon.'
      , NULL
  FROM dual
 WHERE NOT EXISTS
   (SELECT 1 FROM nm_errors
     WHERE ner_appl = 'HIG'
       AND ner_id = 508);
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT GIS0020 new metadata
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Adding metadata for Work Order Lines layer in MAI
-- 
------------------------------------------------------------------
INSERT INTO nm_layer_tree
   SELECT   'MAI',
            'WOL',
            'Work Order Lines Layer',
            'M',
            '20'
     FROM   DUAL
    WHERE   NOT EXISTS (SELECT   1
                          FROM   nm_layer_tree
                         WHERE   nltr_parent = 'MAI' 
                           AND nltr_child = 'WOL');
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

