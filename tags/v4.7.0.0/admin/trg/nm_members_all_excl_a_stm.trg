CREATE OR REPLACE TRIGGER nm_members_all_excl_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
BEGIN
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_members_all_excl_a_stm.trg-arc   2.2   Jul 04 2013 09:53:30   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_members_all_excl_a_stm.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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
