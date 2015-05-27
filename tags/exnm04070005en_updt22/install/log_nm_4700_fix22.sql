--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix22.sql-arc   1.0   May 27 2015 12:50:40   Vikas.Mhetre  $
--       Module Name      : $Workfile:   log_nm_4700_fix22.sql  $
--       Date into PVCS   : $Date:   May 27 2015 12:50:40  $
--       Date fetched Out : $Modtime:   May 27 2015 12:33:18  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix22.sql'
              ,p_remarks        => 'NET 4700 FIX 22'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/