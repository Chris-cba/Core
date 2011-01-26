--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/728768_partial_ddl_upg.sql-arc   3.0   Jan 26 2011 13:38:28   Ade.Edwards  $
--       Module Name      : $Workfile:   728768_partial_ddl_upg.sql  $
--       Date into PVCS   : $Date:   Jan 26 2011 13:38:28  $
--       Date fetched Out : $Modtime:   Jan 26 2011 13:34:36  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

alter table nm0575_matching_records add asset_wholly_enclosed number;

alter table nm0575_matching_records add asset_partially_enclosed number;

alter table nm0575_matching_records add asset_contiguous varchar2(1);