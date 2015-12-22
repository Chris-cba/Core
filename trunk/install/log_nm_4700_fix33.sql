--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix33.sql-arc   1.0   Dec 22 2015 14:25:06   Sarah.Williams  $
--       Module Name      : $Workfile:   log_nm_4700_fix33.sql  $
--       Date into PVCS   : $Date:   Dec 22 2015 14:25:06  $
--       Date fetched Out : $Modtime:   Dec 22 2015 14:24:52  $
--       PVCS Version     : $Revision:   1.0  $

--
--------------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'exnm04070000en_updt33.sql'
              ,p_remarks        => 'NET 4700 FIX 33'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
