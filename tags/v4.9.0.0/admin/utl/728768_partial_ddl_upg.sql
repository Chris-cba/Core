--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/utl/728768_partial_ddl_upg.sql-arc   3.2   Apr 13 2018 12:53:20   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   728768_partial_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 12:53:20  $
--       Date fetched Out : $Modtime:   Apr 13 2018 12:49:46  $
--       PVCS Version     : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

alter table nm0575_matching_records add asset_wholly_enclosed number;

alter table nm0575_matching_records add asset_partially_enclosed number;

alter table nm0575_matching_records add asset_contiguous varchar2(1);
