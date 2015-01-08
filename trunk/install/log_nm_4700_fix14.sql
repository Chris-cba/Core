--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix14.sql-arc   1.0   Jan 08 2015 10:20:06   Stephen.Sewell  $
--       Module Name      : $Workfile:   log_nm_4700_fix14.sql  $
--       Date into PVCS   : $Date:   Jan 08 2015 10:20:06  $
--       Date fetched Out : $Modtime:   Jan 08 2015 10:12:32  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix14.sql'
              ,p_remarks        => 'NET 4700 FIX 14'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
