--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix42.sql-arc   1.0   Aug 26 2016 10:21:08   Chris.Baugh  $
--       Module Name      : $Workfile:   log_nm_4500_fix42.sql  $
--       Date into PVCS   : $Date:   Aug 26 2016 10:21:08  $
--       Date fetched Out : $Modtime:   Mar 04 2015 14:15:22  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4500_fix42.sql'
              ,p_remarks        => 'NET 4500 FIX 42'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
