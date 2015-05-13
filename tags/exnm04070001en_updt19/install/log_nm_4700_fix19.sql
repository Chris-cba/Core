--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix19.sql-arc   1.0   May 13 2015 09:59:28   Vikas.Mhetre  $
--       Module Name      : $Workfile:   log_nm_4700_fix19.sql  $
--       Date into PVCS   : $Date:   May 13 2015 09:59:28  $
--       Date fetched Out : $Modtime:   May 13 2015 09:18:12  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'AST'
              ,p_upgrade_script => 'log_nm_4700_fix19.sql'
              ,p_remarks        => 'AST 4700 FIX 19'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
