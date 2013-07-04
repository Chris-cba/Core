CREATE OR REPLACE TRIGGER nm_element_xrefs_aiu_trg
  AFTER INSERT OR UPDATE ON NM_ELEMENT_XREFS
FOR EACH ROW  
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_element_xrefs_aiu_trg.trg	1.1 11/24/05
--       Module Name      : nm_element_xrefs_aiu_trg.trg
--       Date into SCCS   : 05/11/24 09:25:37
--       Date fetched Out : 07/06/13 17:02:41
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

 l_nex_rec nm_element_xrefs%ROWTYPE;

BEGIN

 l_nex_rec.nex_relationship_type := :NEW.nex_relationship_type;
 l_nex_rec.nex_id1               := :NEW.nex_id1; 
 l_nex_rec.nex_id2               := :NEW.nex_id2; 
 
 nm3_tab_nex.check_ntx_rules(pi_nex_rec => l_nex_rec); 

END nm_element_xrefs_aiu_trg;
/
