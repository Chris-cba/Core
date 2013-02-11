--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/log_nm_4500_fix30.sql-arc   1.0   Feb 11 2013 11:29:06   Steve.Cooper  $
--       Module Name      : $Workfile:   log_nm_4500_fix30.sql  $ 
--       Date into PVCS   : $Date:   Feb 11 2013 11:29:06  $
--       Date fetched Out : $Modtime:   Feb 11 2013 10:31:04  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
----------------------------------------------------------------------------
--

BEGIN
--
  hig2.upgrade(p_product        => 'NET'
              ,p_upgrade_script => 'log_nm_4500_fix30.sql'
              ,p_remarks        => 'NET 4500 FIX 30'
              ,p_to_version     => Null);
--
  commit;
--
EXCEPTION
  WHEN others THEN Null;
END;
/
