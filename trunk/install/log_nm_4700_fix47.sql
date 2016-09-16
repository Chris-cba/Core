--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/log_nm_4700_fix47.sql-arc   1.0   Sep 16 2016 22:55:34   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix47.sql  $
--       Date into PVCS   : $Date:   Sep 16 2016 22:55:34  $
--       Date fetched Out : $Modtime:   Sep 15 2016 13:48:42  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'LB'
              ,p_upgrade_script => 'log_nm_4700_fix47.sql'
              ,p_remarks        => 'NET 4700 FIX 47 Build 1'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
