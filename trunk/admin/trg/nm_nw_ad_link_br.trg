CREATE OR REPLACE TRIGGER NM_NW_AD_LINK_BR
BEFORE INSERT OR UPDATE
ON NM_NW_AD_LINK_ALL
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_nw_ad_link_br.trg-arc   2.3   Jul 04 2013 09:58:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_nw_ad_link_br.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:58:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:57:28  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.6
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
DECLARE

l_rec_nwad NM_NW_AD_LINK_ALL%ROWTYPE;
l_rec_nadt nm_nw_ad_types%ROWTYPE;

BEGIN
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3nwad.bypass_nw_ad_link_all
  Then 
    nm3nwad.g_tab_nadl.DELETE;
   
-- GJ - squeeze as much performance as possible.....
-- there are 4 denormalised columns on the nm_nw_ad_link_all table 
-- if a value for the first of these is explicitly passed in as part of the insert/update
-- then assume that all four of the denormalised values have already been determined
-- so do not bother going to the expense of undertaking an nm3get
-- 
-- Note: it's important to ensure that when a nad_id changes the columns are re-evaluated
--
   IF :NEW.nad_nt_type IS NULL
    OR
      :NEW.nad_id != NVL(:OLD.nad_id,:NEW.nad_id) THEN 
      
     l_rec_nadt := nm3get.get_nad(pi_nad_id => :NEW.nad_id
                                 ,pi_raise_not_found => TRUE);
                                 
     :NEW.nad_nt_type    := l_rec_nadt.nad_nt_type;
     :NEW.nad_gty_type   := l_rec_nadt.nad_gty_type;
     :NEW.nad_inv_type   := l_rec_nadt.nad_inv_type;
     :NEW.nad_primary_ad := l_rec_nadt.nad_primary_ad;
     
   END IF;              						   
                            
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
 End If;
END nm_nw_ad_link_br;
/

