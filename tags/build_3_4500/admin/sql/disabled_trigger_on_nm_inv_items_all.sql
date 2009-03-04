-- Drop Tigger NM_INV_ITEMS_ALL_A_DT_TRG as the same code is called in NM_INV_ITEMS_ALL_A_INS_UPD
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/disabled_trigger_on_nm_inv_items_all.sql-arc   3.3   Mar 04 2009 09:03:18   lsorathia  $
--       Module Name      : $Workfile:   disabled_trigger_on_nm_inv_items_all.sql  $
--       Date into PVCS   : $Date:   Mar 04 2009 09:03:18  $
--       Date fetched Out : $Modtime:   Mar 04 2009 09:02:28  $
--       PVCS Version     : $Revision:   3.3  $
--
--------------------------------------------------------------------------------
--

PROMPT Drop Tigger NM_INV_ITEMS_ALL_A_DT_TRG as the same code is called in NM_INV_ITEMS_ALL_A_INS_UPD

BEGIN
   EXECUTE IMMEDIATE ('DROP TRIGGER NM_INV_ITEMS_ALL_A_DT_TRG');
EXCEPTION
  WHEN Others Then
   Null;
END; 
/












