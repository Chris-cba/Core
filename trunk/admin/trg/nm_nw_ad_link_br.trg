CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_BR
BEFORE INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_ad_link_br.trg	1.6 05/15/06
--       Module Name      : nm_nw_ad_link_br.trg
--       Date into SCCS   : 06/05/15 11:46:32
--       Date fetched Out : 07/06/13 17:03:31
--       SCCS Version     : 1.6
--
-----------------------------------------------------------------------------
--Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
DECLARE

l_rec_nwad NM_NW_AD_LINK_ALL%ROWTYPE;
l_rec_nadt nm_nw_ad_types%ROWTYPE;

BEGIN

   nm3nwad.g_tab_nadl.DELETE;
   
   l_rec_nadt := nm3get.get_nad(pi_nad_id => :NEW.nad_id
                               ,pi_raise_not_found => TRUE);

   :NEW.nad_nt_type    := l_rec_nadt.nad_nt_type;
   :NEW.nad_gty_type   := l_rec_nadt.nad_gty_type;
   :NEW.nad_inv_type   := l_rec_nadt.nad_inv_type;
   :NEW.nad_primary_ad := l_rec_nadt.nad_primary_ad;         						   
							   
   l_rec_nwad.nad_id             := :NEW.nad_id;
   l_rec_nwad.nad_iit_ne_id      := :NEW.nad_iit_ne_id;
   l_rec_nwad.nad_ne_id          := :NEW.nad_ne_id;

   l_rec_nwad.nad_end_date       := :NEW.nad_end_date;
   l_rec_nwad.nad_start_date     := :NEW.nad_start_date;   
   l_rec_nwad.nad_nt_type        := :NEW.nad_nt_type;
   l_rec_nwad.nad_gty_type       := :NEW.nad_gty_type;
   l_rec_nwad.nad_inv_type       := :NEW.nad_inv_type;
   l_rec_nwad.nad_primary_ad     := :NEW.nad_primary_ad;
   
   nm3nwad.g_tab_nadl(nm3nwad.g_tab_nadl.COUNT+1) := l_rec_nwad;

END nm_nw_ad_link_br;
/

