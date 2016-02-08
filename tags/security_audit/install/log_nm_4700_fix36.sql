--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix36.sql-arc   1.0   Feb 08 2016 13:07:52   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   log_nm_4700_fix36.sql  $
--       Date into PVCS   : $Date:   Feb 08 2016 13:07:52  $
--       Date fetched Out : $Modtime:   Feb 08 2016 11:49:36  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix36.sql'
              ,p_remarks        => 'NET 4700 FIX 36 (Build 1)'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/