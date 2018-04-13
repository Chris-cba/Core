--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/utl/licence_check.sql-arc   2.2   Apr 13 2018 12:53:22   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   licence_check.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:22  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:51:54  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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

