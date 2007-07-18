CREATE OR REPLACE TRIGGER NM_NW_AD_TYPES_BR
BEFORE INSERT OR UPDATE
ON NM_NW_AD_TYPES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_types_br.trg	1.2 01/10/05
--       Module Name      : nm_nw_ad_types_br.trg
--       Date into SCCS   : 05/01/10 15:15:52
--       Date fetched Out : 07/06/13 17:03:32
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
DECLARE

l_rec_nwad NM_NW_AD_TYPEs%ROWTYPE;

BEGIN

  nm3nwad.g_tab_nadt.DELETE;

  l_rec_nwad.nad_id             := :NEW.nad_id;
  l_rec_nwad.nad_inv_type       := :NEW.nad_inv_type;
  l_rec_nwad.nad_nt_type        := :NEW.nad_nt_type;
  l_rec_nwad.nad_gty_type       := :NEW.nad_gty_type;
  l_rec_nwad.nad_descr          := :NEW.nad_descr;
  l_rec_nwad.nad_start_date     := :NEW.nad_start_date;
  l_rec_nwad.nad_end_date       := :NEW.nad_end_date;
  l_rec_nwad.nad_primary_ad     := :NEW.nad_primary_ad;
  l_rec_nwad.nad_display_order  := :NEW.nad_display_order;
  l_rec_nwad.nad_single_row     := :NEW.nad_single_row;
  l_rec_nwad.nad_mandatory      := :NEW.nad_mandatory;

  nm3nwad.g_tab_nadt(nm3nwad.g_tab_nadt.COUNT+1) := l_rec_nwad;

END nm_nw_ad_types_br;
/
