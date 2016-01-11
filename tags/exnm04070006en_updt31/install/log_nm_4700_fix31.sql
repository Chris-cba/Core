--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix31.sql-arc   1.3   Jan 11 2016 11:59:36   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix31.sql  $
--       Date into PVCS   : $Date:   Jan 11 2016 11:59:36  $
--       Date fetched Out : $Modtime:   Jan 11 2016 12:00:38  $
--       PVCS Version     : $Revision:   1.3  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix31.sql'
              ,p_remarks        => 'NET 4700 FIX 31 Build 6'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
