--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix31.sql-arc   1.4   Jan 28 2016 12:49:16   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix31.sql  $
--       Date into PVCS   : $Date:   Jan 28 2016 12:49:16  $
--       Date fetched Out : $Modtime:   Jan 28 2016 12:49:50  $
--       PVCS Version     : $Revision:   1.4  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix31.sql'
              ,p_remarks        => 'NET 4700 FIX 31 Build 7'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
