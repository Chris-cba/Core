--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/log_nm_4700_fix48.sql-arc   1.0   Oct 21 2016 12:04:30   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix48.sql  $
--       Date into PVCS   : $Date:   Oct 21 2016 12:04:30  $
--       Date fetched Out : $Modtime:   Oct 21 2016 12:01:00  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'LB'
              ,p_upgrade_script => 'log_nm_4700_fix48.sql'
              ,p_remarks        => 'NET 4700 FIX 48 Build 1 - LB version 4.3'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
