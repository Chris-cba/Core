CREATE OR REPLACE TRIGGER nm_inv_attri_lookup_b_iu_trg
   BEFORE INSERT OR UPDATE
    ON    nm_inv_attri_lookup_all
    FOR   EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_attri_lookup_b_iu_trg.trg	1.2 09/06/02
--       Module Name      : nm_inv_attri_lookup_b_iu_trg.trg
--       Date into SCCS   : 02/09/06 15:17:59
--       Date fetched Out : 07/06/13 17:02:50
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_inv_attri_lookup_b_iu_trg
--      BEFORE INSERT OR UPDATE
--       ON    nm_inv_attri_lookup_all
--       FOR   EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_id nm_inv_domains_all%ROWTYPE;
--
BEGIN
--
   l_rec_id := nm3get.get_id_all (pi_id_domain => :NEW.ial_domain);
--
   IF    l_rec_id.id_datatype  = nm3type.c_varchar
    THEN
      Null;
   ELSIF l_rec_id.id_datatype  = nm3type.c_number
    THEN
      IF  NOT nm3flx.is_numeric (:NEW.ial_value)                      -- Not a number
       OR :NEW.ial_value != LTRIM(TO_CHAR(TO_NUMBER(:NEW.ial_value))) -- Prevent entering of "01" for instance in a NUMBER domain
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 111
                       ,pi_supplementary_info => :NEW.ial_value
                       );
      END IF;
   ELSIF l_rec_id.id_datatype  = nm3type.c_date
    THEN
      IF hig.date_convert (:NEW.ial_value) IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 148
                       ,pi_supplementary_info => :NEW.ial_value
                       );
      END IF;
   END IF;
--
END nm_inv_attri_lookup_b_iu_trg;
/
