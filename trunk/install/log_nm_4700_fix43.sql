--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix43.sql-arc   1.5   Aug 22 2017 20:23:14   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix43.sql  $
--       Date into PVCS   : $Date:   Aug 22 2017 20:23:14  $
--       Date fetched Out : $Modtime:   Aug 22 2017 20:22:46  $
--       PVCS Version     : $Revision:   1.5  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix43.sql'
              ,p_remarks        => 'NET 4700 FIX 43 Build 6'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
