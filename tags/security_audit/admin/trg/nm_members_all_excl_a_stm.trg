CREATE OR REPLACE TRIGGER nm_members_all_excl_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
BEGIN
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_members_all_excl_a_stm.trg-arc   2.3   Apr 13 2018 11:06:34   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_members_all_excl_a_stm.trg  $
--       Date into SCCS   : $Date:   Apr 13 2018 11:06:34  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:58:46  $
--       SCCS Version     : $Revision:   2.3  $
--       Based on 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
  -- MJA add 31-Aug-07
  -- New functionality to allow override of triggers
  If Not nm3net.bypass_nm_members_trgs
  Then
    nm3nwval.process_tab_excl;
  End If;
--
END nm_members_all_excl_a_stm;
/
