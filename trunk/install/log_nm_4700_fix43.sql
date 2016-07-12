--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix43.sql-arc   1.3   Jul 12 2016 14:31:38   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix43.sql  $
--       Date into PVCS   : $Date:   Jul 12 2016 14:31:38  $
--       Date fetched Out : $Modtime:   Jul 12 2016 14:32:00  $
--       PVCS Version     : $Revision:   1.3  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix43.sql'
              ,p_remarks        => 'NET 4700 FIX 43 Build 4'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
