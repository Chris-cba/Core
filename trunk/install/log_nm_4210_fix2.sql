--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/log_nm_4210_fix2.sql-arc   3.0   Aug 04 2010 12:08:56   malexander  $
--       Module Name      : $Workfile:   log_nm_4210_fix2.sql  $
--       Date into PVCS   : $Date:   Aug 04 2010 12:08:56  $
--       Date fetched Out : $Modtime:   Aug 04 2010 12:08:40  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2010
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4210_fix2.sql'
              ,p_remarks        => 'NET 4210 FIX 2'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
