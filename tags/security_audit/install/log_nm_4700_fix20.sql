--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix20.sql-arc   1.0   Aug 26 2016 10:33:52   Chris.Baugh  $
--       Module Name      : $Workfile:   log_nm_4700_fix20.sql  $
--       Date into PVCS   : $Date:   Aug 26 2016 10:33:52  $
--       Date fetched Out : $Modtime:   Apr 27 2015 09:15:22  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix20.sql'
              ,p_remarks        => 'NET 4700 FIX 20'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
