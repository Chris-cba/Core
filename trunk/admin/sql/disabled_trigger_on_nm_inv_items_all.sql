-- Drop Tigger NM_INV_ITEMS_ALL_A_DT_TRG as the same code is called in NM_INV_ITEMS_ALL_A_INS_UPD
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/disabled_trigger_on_nm_inv_items_all.sql-arc   3.5   Apr 13 2018 13:21:46   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   disabled_trigger_on_nm_inv_items_all.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 13:21:46  $
--       Date fetched Out : $Modtime:   Apr 13 2018 13:20:38  $
--       PVCS Version     : $Revision:   3.5  $
--
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--

PROMPT Drop Tigger NM_INV_ITEMS_ALL_A_DT_TRG as the same code is called in NM_INV_ITEMS_ALL_A_INS_UPD

BEGIN
   EXECUTE IMMEDIATE ('DROP TRIGGER NM_INV_ITEMS_ALL_A_DT_TRG');
EXCEPTION
  WHEN Others Then
   Null;
END; 
/












