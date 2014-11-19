--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/log_nm_4700_fix11.sql-arc   3.0   Nov 19 2014 10:05:00   James.Wadsworth  $
--       Module Name      : $Workfile:   log_nm_4700_fix11.sql  $
--       Date into PVCS   : $Date:   Nov 19 2014 10:05:00  $
--       Date fetched Out : $Modtime:   Nov 19 2014 10:04:24  $
--       PVCS Version     : $Revision:   3.0  $
--
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
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
