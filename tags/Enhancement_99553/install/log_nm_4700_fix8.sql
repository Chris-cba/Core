--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/log_nm_4700_fix8.sql-arc   3.0   Sep 19 2014 17:38:42   Mike.Huitson  $
--       Module Name      : $Workfile:   log_nm_4700_fix8.sql  $
--       Date into PVCS   : $Date:   Sep 19 2014 17:38:42  $
--       Date fetched Out : $Modtime:   Sep 19 2014 17:35:46  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix8.sql'
              ,p_remarks        => 'NET 4700 FIX 8'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
