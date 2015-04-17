--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4500_fix43.sql-arc   1.0   Apr 17 2015 10:20:12   Vikas.Mhetre  $
--       Module Name      : $Workfile:   log_nm_4500_fix43.sql  $
--       Date into PVCS   : $Date:   Apr 17 2015 10:20:12  $
--       Date fetched Out : $Modtime:   Apr 17 2015 08:32:50  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4500_fix43.sql'
              ,p_remarks        => 'NET 4500 FIX 43'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
