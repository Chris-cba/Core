--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix41.sql-arc   1.0   Aug 26 2016 10:18:36   Chris.Baugh  $
--       Module Name      : $Workfile:   log_nm_4500_fix41.sql  $
--       Date into PVCS   : $Date:   Aug 26 2016 10:18:36  $
--       Date fetched Out : $Modtime:   Dec 16 2014 15:38:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4500_fix41.sql'
              ,p_remarks        => 'NET 4500 FIX 41'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
