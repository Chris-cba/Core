--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix15.sql-arc   1.0   Aug 26 2016 10:30:06   Chris.Baugh  $
--       Module Name      : $Workfile:   log_nm_4700_fix15.sql  $
--       Date into PVCS   : $Date:   Aug 26 2016 10:30:06  $
--       Date fetched Out : $Modtime:   Mar 04 2015 09:58:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix15.sql'
              ,p_remarks        => 'NET 4700 FIX 15'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
