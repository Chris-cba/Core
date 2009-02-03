------------------------------------------------------------------
-- nm4051_nm4052_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4051_nm4052_metadata_upg.sql-arc   3.0   Feb 03 2009 17:25:28   malexander  $
--       Module Name      : $Workfile:   nm4051_nm4052_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Feb 03 2009 17:25:28  $
--       Date fetched Out : $Modtime:   Feb 03 2009 17:24:40  $
--       Version          : $Revision:   3.0  $
--
------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2009

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

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

