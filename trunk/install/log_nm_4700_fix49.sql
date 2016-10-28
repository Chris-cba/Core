--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/install/log_nm_4700_fix49.sql-arc   1.0   Oct 28 2016 16:30:04   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix49.sql  $
--       Date into PVCS   : $Date:   Oct 28 2016 16:30:04  $
--       Date fetched Out : $Modtime:   Oct 28 2016 14:50:06  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'LB'
              ,p_upgrade_script => 'log_nm_4700_fix49.sql'
              ,p_remarks        => 'NET 4700 FIX 49 Build 1 - LB version 4.4'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
