-- Drop Tigger NM_INV_ITEMS_ALL_A_DT_TRG as the same code is called in NM_INV_ITEMS_ALL_A_INS_UPD
--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/sql/disabled_trigger_on_nm_inv_items_all.sql-arc   3.4   Jul 04 2013 09:32:42   James.Wadsworth  $
--       Module Name      : $Workfile:   disabled_trigger_on_nm_inv_items_all.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:32:42  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:27:46  $
--       PVCS Version     : $Revision:   3.4  $
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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












