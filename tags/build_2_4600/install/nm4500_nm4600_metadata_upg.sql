------------------------------------------------------------------
-- nm4500_nm4600_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4500_nm4600_metadata_upg.sql-arc   1.0   Jul 18 2012 13:51:14   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4500_nm4600_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 18 2012 13:51:14  $
--       Date fetched Out : $Modtime:   Jul 18 2012 13:35:20  $
--       Version          : $Revision:   1.0  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011

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

