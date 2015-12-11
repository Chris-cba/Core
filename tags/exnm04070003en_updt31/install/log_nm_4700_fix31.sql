--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix31.sql-arc   1.2   Dec 11 2015 16:10:40   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix31.sql  $
--       Date into PVCS   : $Date:   Dec 11 2015 16:10:40  $
--       Date fetched Out : $Modtime:   Dec 11 2015 16:10:24  $
--       PVCS Version     : $Revision:   1.2  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix31.sql'
              ,p_remarks        => 'NET 4700 FIX 31 Build 3'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
