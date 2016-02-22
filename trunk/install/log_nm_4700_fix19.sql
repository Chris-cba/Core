--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix19.sql-arc   1.1   Feb 22 2016 11:38:34   Vikas.Mhetre  $
--       Module Name      : $Workfile:   log_nm_4700_fix19.sql  $
--       Date into PVCS   : $Date:   Feb 22 2016 11:38:34  $
--       Date fetched Out : $Modtime:   Feb 22 2016 10:44:26  $
--       PVCS Version     : $Revision:   1.1  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2016 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix19.sql'
              ,p_remarks        => 'NET 4700 FIX 19 (Build 2)'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
