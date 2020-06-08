--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/log_nm_4700_fix71.sql-arc   1.0   Jun 08 2020 13:30:34   Rob.Coupe  $
--       Module Name      : $Workfile:   log_nm_4700_fix71.sql  $
--       Date into PVCS   : $Date:   Jun 08 2020 13:30:34  $
--       Date fetched Out : $Modtime:   Aug 16 2017 09:28:34  $
--       PVCS Version     : $Revision:   1.0  $
--
--------------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
--------------------------------------------------------------------------------
--
BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4700_fix56.sql'
              ,p_remarks        => 'NET 4700 FIX 56 Build 1'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
