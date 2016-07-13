--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix44.sql-arc   1.0   Jul 13 2016 11:47:58   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix44.sql  $
--       Date into PVCS   : $Date:   Jul 13 2016 11:47:58  $
--       Date fetched Out : $Modtime:   Jul 13 2016 11:47:04  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix44.sql'
              ,p_remarks        => 'NET 4700 FIX 44 Build 1'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
