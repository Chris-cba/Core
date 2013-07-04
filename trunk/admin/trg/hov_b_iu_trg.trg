CREATE OR REPLACE TRIGGER hov_b_iu_trg
   BEFORE INSERT OR UPDATE
   ON hig_option_values
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hov_b_iu_trg.trg	1.2 09/04/02
--       Module Name      : hov_b_iu_trg.trg
--       Date into SCCS   : 02/09/04 12:18:13
--       Date fetched Out : 07/06/13 17:02:34
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   TRIGGER hov_b_iu_trg
--      BEFORE INSERT OR UPDATE
--      ON hig_option_values
--      FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_hol            hig_option_list%ROWTYPE;
   c_hov_value CONSTANT hig_option_values.hov_value%TYPE := :NEW.hov_value;
--
--
   CURSOR cs_hol(pi_hol_id in hig_option_list.hol_id%type) IS
   SELECT /*+ INDEX (hol HOL_PK) */ *
    FROM  hig_option_list hol
   WHERE  hol.hol_id = pi_hol_id;
--
BEGIN
--
   OPEN  cs_hol(pi_hol_id => :NEW.hov_id);
   FETCH cs_hol INTO l_rec_hol;
   CLOSE cs_hol; 
--
   IF l_rec_hol.hol_domain IS NOT NULL
    THEN
      DECLARE
         l_invalid EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_invalid,-20001);
      BEGIN
         hig.valid_fk_hco (pi_hco_domain => l_rec_hol.hol_domain
                          ,pi_hco_code   => c_hov_value
                          );
      EXCEPTION
         WHEN l_invalid
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 109
                          ,pi_supplementary_info => '"'||l_rec_hol.hol_domain||'" -> "'||c_hov_value||'"'
                          );
      END;
   END IF;
--
   IF    l_rec_hol.hol_datatype = nm3type.c_varchar
    THEN
      IF   l_rec_hol.hol_mixed_case  = 'N'
       AND c_hov_value              != UPPER(c_hov_value)
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 159
                       ,pi_supplementary_info => c_hov_value
                       );
      END IF;
   ELSIF l_rec_hol.hol_datatype = nm3type.c_number
    THEN
      IF NOT nm3flx.is_numeric (c_hov_value)
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 111
                       ,pi_supplementary_info => c_hov_value
                       );
      END IF;
   ELSIF l_rec_hol.hol_datatype = nm3type.c_date
    THEN
      IF hig.date_convert (c_hov_value) IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 148
                       ,pi_supplementary_info => c_hov_value
                       );
      END IF;
   END IF;
--
END hov_b_iu_trg;
/
