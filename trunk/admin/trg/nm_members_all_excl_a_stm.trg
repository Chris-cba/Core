CREATE OR REPLACE TRIGGER nm_members_all_excl_a_stm
 AFTER INSERT
  OR UPDATE
 ON NM_MEMBERS_ALL
BEGIN
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_members_all_excl_a_stm.trg-arc   2.1   Aug 31 2007 16:26:30   malexander  $
--       Module Name      : $Workfile:   nm_members_all_excl_a_stm.trg  $
--       Date into SCCS   : $Date:   Aug 31 2007 16:26:30  $
--       Date fetched Out : $Modtime:   Aug 31 2007 15:25:42  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on 
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
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
