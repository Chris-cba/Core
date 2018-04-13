--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/log_nm_4700_fix11.sql-arc   3.2   Apr 13 2018 13:21:46   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   log_nm_4700_fix11.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 13:21:46  $
--       Date fetched Out : $Modtime:   Apr 13 2018 13:20:38  $
--       PVCS Version     : $Revision:   3.2  $
--
--
--------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix11.sql'
              ,p_remarks        => 'NET 4700 FIX 11'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
