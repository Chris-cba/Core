CREATE OR REPLACE TRIGGER nmid_b_iu_row_trg
   BEFORE INSERT OR UPDATE
   ON nm_mrg_ita_derivation
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nmid_b_iu_row_trg.trg	1.1 09/06/05
--       Module Name      : nmid_b_iu_row_trg.trg
--       Date into SCCS   : 05/09/06 10:24:37
--       Date fetched Out : 07/06/13 17:03:46
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Composite Inventory trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_nmid nm_mrg_ita_derivation%ROWTYPE;
--
BEGIN
--
   l_rec_nmid.nmid_ita_inv_type      := :NEW.nmid_ita_inv_type;
   l_rec_nmid.nmid_ita_attrib_name   := :NEW.nmid_ita_attrib_name;
   l_rec_nmid.nmid_seq_no            := :NEW.nmid_seq_no;
   l_rec_nmid.nmid_derivation        := :NEW.nmid_derivation;
--
   nm3inv_composite.nmid_b_iu_row_trg (p_rec_nmid => l_rec_nmid);
--
END nmid_b_iu_row_trg;
/
