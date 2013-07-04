--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/licence_check.sql-arc   2.1   Jul 04 2013 10:30:12   James.Wadsworth  $
--       Module Name      : $Workfile:   licence_check.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:24:00  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- Licence check script. Output contents of HIG_PU table.
-- If the Maximum number of concurrent users for any Product exceeds the number of 
-- concurrently licensed users for that Product then the terms of Exor's licence have
-- been broken
--
select hpu_product "Prod.", max(hpu_current) "Max Concurrent Users"
from   hig_pu
group by hpu_product;

