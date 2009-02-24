-- Disable Tigger NM_INV_ITEMS_ALL_A_DT_TRG as the same code is called in NM_INV_ITEMS_ALL_A_INS_UPD
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/disabled_trigger_on_nm_inv_items_all.sql-arc   3.0   Feb 24 2009 15:30:58   lsorathia  $
--       Module Name      : $Workfile:   disabled_trigger_on_nm_inv_items_all.sql  $
--       Date into PVCS   : $Date:   Feb 24 2009 15:30:58  $
--       Date fetched Out : $Modtime:   Feb 24 2009 15:29:12  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

PROMPT Disable Tigger NM_INV_ITEMS_ALL_A_DT_TRG as the same code is called in NM_INV_ITEMS_ALL_A_INS_UPD

ALTER TRIGGER NM_INV_ITEMS_ALL_A_DT_TRG DISABLE 
/











