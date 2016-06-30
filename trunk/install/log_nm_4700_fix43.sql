--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix43.sql-arc   1.1   Jun 30 2016 16:28:22   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix43.sql  $
--       Date into PVCS   : $Date:   Jun 30 2016 16:28:22  $
--       Date fetched Out : $Modtime:   Jun 30 2016 16:28:56  $
--       PVCS Version     : $Revision:   1.1  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix43.sql'
              ,p_remarks        => 'NET 4700 FIX 43 Build 2'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
