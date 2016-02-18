--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix37.sql-arc   1.0   Feb 18 2016 16:41:56   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix37.sql  $
--       Date into PVCS   : $Date:   Feb 18 2016 16:41:56  $
--       Date fetched Out : $Modtime:   Feb 18 2016 15:55:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix37.sql'
              ,p_remarks        => 'NET 4700 FIX 37 Build 1'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
