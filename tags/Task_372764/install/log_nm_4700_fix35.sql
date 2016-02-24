--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix35.sql-arc   1.2   Feb 17 2016 16:58:14   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix35.sql  $
--       Date into PVCS   : $Date:   Feb 17 2016 16:58:14  $
--       Date fetched Out : $Modtime:   Feb 17 2016 16:58:12  $
--       PVCS Version     : $Revision:   1.2  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix35.sql'
              ,p_remarks        => 'NET 4700 FIX 35 Build 3'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/