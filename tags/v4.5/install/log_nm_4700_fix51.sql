--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/log_nm_4700_fix51.sql-arc   1.0   Jan 11 2017 22:45:26   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix51.sql  $
--       Date into PVCS   : $Date:   Jan 11 2017 22:45:26  $
--       Date fetched Out : $Modtime:   Jan 11 2017 22:17:34  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'LB'
              ,p_upgrade_script => 'log_nm_4700_fix51.sql'
              ,p_remarks        => 'NET 4700 FIX 51 Build 1 - LB version 4.5'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
