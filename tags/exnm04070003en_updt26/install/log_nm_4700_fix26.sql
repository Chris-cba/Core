--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix26.sql-arc   1.0   Jul 16 2015 14:35:18   Vikas.Mhetre  $
--       Module Name      : $Workfile:   log_nm_4700_fix26.sql  $
--       Date into PVCS   : $Date:   Jul 16 2015 14:35:18  $
--       Date fetched Out : $Modtime:   Jul 16 2015 11:17:24  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix26.sql'
              ,p_remarks        => 'NET 4700 FIX 26'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/