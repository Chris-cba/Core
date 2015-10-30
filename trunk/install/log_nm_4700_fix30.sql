----------------------------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix30.sql-arc   1.0   Oct 30 2015 09:09:18   Vikas.Mhetre  $
--       Module Name      : $Workfile:   log_nm_4700_fix30.sql  $ 
--       Date into PVCS   : $Date:   Oct 30 2015 09:09:18  $
--       Date fetched Out : $Modtime:   Oct 30 2015 08:42:26  $
--       Version          : $Revision:   1.0  $
--
----------------------------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'AST'
              ,p_upgrade_script => 'log_nm_4700_fix30.sql'
              ,p_remarks        => 'AST 4700 FIX 30'
              ,p_to_version     => NULL
              );
--
COMMIT;
--
EXCEPTION 
  WHEN OTHERS THEN
--
  NULL;
--
END;
/