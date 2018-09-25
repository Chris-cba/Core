--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix56.sql-arc   1.2   Sep 25 2018 10:05:04   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix56.sql  $
--       Date into PVCS   : $Date:   Sep 25 2018 10:05:04  $
--       Date fetched Out : $Modtime:   Sep 25 2018 10:04:46  $
--       PVCS Version     : $Revision:   1.2  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix56.sql'
              ,p_remarks        => 'NET 4700 FIX 56 Build 3'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
