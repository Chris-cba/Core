--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/728768_partial_ddl_upg.sql-arc   3.1   Jul 04 2013 10:29:56   James.Wadsworth  $
--       Module Name      : $Workfile:   728768_partial_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:19:34  $
--       PVCS Version     : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

alter table nm0575_matching_records add asset_wholly_enclosed number;

alter table nm0575_matching_records add asset_partially_enclosed number;

alter table nm0575_matching_records add asset_contiguous varchar2(1);
