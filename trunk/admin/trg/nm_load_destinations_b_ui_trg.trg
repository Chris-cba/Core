CREATE OR REPLACE TRIGGER nm_load_destinations_b_iu_trg
       BEFORE  INSERT OR UPDATE
       ON      nm_load_destinations
       FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_load_destinations_b_ui_trg.trg	1.3 09/17/02
--       Module Name      : nm_load_destinations_b_ui_trg.trg
--       Date into SCCS   : 02/09/17 08:04:19
--       Date fetched Out : 07/06/13 17:03:12
--       SCCS Version     : 1.3
--
--       TRIGGER nm_load_destinations_b_iu_trg
--         BEFORE  INSERT OR UPDATE
--         ON      nm_load_destinations
--         FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_check_short (c_short VARCHAR2) IS
   SELECT 1
    FROM  nm_load_files
   WHERE  nlf_unique = c_short;
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
   PROCEDURE check_string (p_string VARCHAR2) IS
   BEGIN
      IF NOT nm3flx.is_string_valid_for_object (p_string)
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 30
                       ,pi_supplementary_info => p_string
                       );
      END IF;
   END check_string;
BEGIN
   check_string (:NEW.nld_table_name);
   check_string (:NEW.nld_table_short_name);
   OPEN  cs_check_short (:NEW.nld_table_short_name);
   FETCH cs_check_short INTO l_dummy;
   l_found := cs_check_short%FOUND;
   CLOSE cs_check_short;
   IF l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 166
                    ,pi_supplementary_info => :NEW.nld_table_short_name
                    );
   END IF;
END nm_load_destinations_b_iu_trg;
/
