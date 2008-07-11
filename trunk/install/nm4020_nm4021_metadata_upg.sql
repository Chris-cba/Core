------------------------------------------------------------------
-- nm4020_nm4021_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4020_nm4021_metadata_upg.sql-arc   3.0   Jul 11 2008 12:30:32   aedwards  $
--       Module Name      : $Workfile:   nm4020_nm4021_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 11 2008 12:30:32  $
--       Date fetched Out : $Modtime:   Jul 11 2008 12:21:14  $
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

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

