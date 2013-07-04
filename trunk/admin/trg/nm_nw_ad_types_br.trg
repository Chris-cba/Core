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
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
DECLARE

l_rec_nwad     NM_NW_AD_TYPES%ROWTYPE;
l_has_children VARCHAR2(1);

  CURSOR check_for_children_cur( p_nad_inv_type VARCHAR2
                               , p_nad_nt_type VARCHAR2
                               , p_nad_gty_type VARCHAR2 
                               ) IS
  SELECT 'Y'
  FROM nm_nw_ad_link_all 
  WHERE nad_nt_type = p_nad_nt_type
  AND NVL(nad_gty_type, '-1') = NVL(p_nad_gty_type, '-1')
  AND nad_inv_type = p_nad_inv_type
  AND ROWNUM = 1;

BEGIN

  IF   UPDATING 
  AND (:OLD.nad_inv_type <> :NEW.nad_inv_type 
   OR  :OLD.nad_nt_type  <> :NEW.nad_nt_type 
   OR  nvl(:OLD.nad_gty_type, '-1') <> nvl(:NEW.nad_gty_type, '-1'))
  THEN
  --
    OPEN check_for_children_cur(:OLD.nad_inv_type, :OLD.nad_nt_type, :OLD.nad_gty_type);
    FETCH check_for_children_cur INTO l_has_children;
    CLOSE check_for_children_cur;
    
    IF nvl(l_has_children, 'N') = 'Y'
    THEN
      hig.raise_ner( 'NET'
                   , 556);
    END IF;
  --
  END IF;

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
