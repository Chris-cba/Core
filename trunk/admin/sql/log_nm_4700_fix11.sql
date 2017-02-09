--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/log_nm_4700_fix11.sql-arc   3.1   Feb 09 2017 10:30:48   James.Wadsworth  $
--       Module Name      : $Workfile:   log_nm_4700_fix11.sql  $
--       Date into PVCS   : $Date:   Feb 09 2017 10:30:48  $
--       Date fetched Out : $Modtime:   Feb 09 2017 09:49:44  $
--       PVCS Version     : $Revision:   3.1  $
--
--
--------------------------------------------------------------------------------
--   Copyright (c) 2017 Bentley Systems Incorporated.
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
