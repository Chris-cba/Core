--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/log_nm_4500_fix39.sql-arc   3.0   Nov 19 2014 09:58:14   James.Wadsworth  $
--       Module Name      : $Workfile:   log_nm_4500_fix39.sql  $
--       Date into PVCS   : $Date:   Nov 19 2014 09:58:14  $
--       Date fetched Out : $Modtime:   Nov 19 2014 09:57:36  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4500_fix39.sql'
              ,p_remarks        => 'NET 4500 FIX 39'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
