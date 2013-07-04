------------------------------------------------------------------
-- nm4040_nm4046_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4040_nm4046_metadata_upg.sql-arc   3.1   Jul 04 2013 14:10:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm4040_nm4046_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:10:26  $
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
PROMPT Repair invalid base theme records
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (ADRIAN EDWARDS)
-- Update the NM_BASE_THEME record to point at the base table theme
-- where the base theme is incorrectly set to a view based theme
-- 
-- 
------------------------------------------------------------------
UPDATE nm_base_themes
   SET nbth_base_theme =(SELECT nth_base_table_theme
                           FROM nm_themes_all
                          WHERE nth_theme_id = nbth_base_theme)
 WHERE EXISTS
  (SELECT 1 FROM nm_themes_all
    WHERE nth_theme_id = nbth_base_theme
      AND nth_base_table_theme IS NOT NULL);
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

