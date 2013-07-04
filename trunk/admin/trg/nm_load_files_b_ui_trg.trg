CREATE OR REPLACE TRIGGER nm_load_files_b_ui_trg
       BEFORE  INSERT OR UPDATE
       ON      nm_load_files
       FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_load_files_b_ui_trg.trg	1.2 09/17/02
--       Module Name      : nm_load_files_b_ui_trg.trg
--       Date into SCCS   : 02/09/17 08:02:16
--       Date fetched Out : 07/06/13 17:03:14
--       SCCS Version     : 1.2
--
--       TRIGGER nm_load_files_b_ui_trg
--         BEFORE  INSERT OR UPDATE
--         ON      nm_load_files
--         FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_check_short (c_short VARCHAR2) IS
   SELECT 1
    FROM  nm_load_destinations
   WHERE  nld_table_short_name = c_short;
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
BEGIN
--
   IF NOT nm3flx.is_string_valid_for_object (:NEW.nlf_unique)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 30
                    ,pi_supplementary_info => :NEW.nlf_unique
                    );
   END IF;
--
   OPEN  cs_check_short (:NEW.nlf_unique);
   FETCH cs_check_short INTO l_dummy;
   l_found := cs_check_short%FOUND;
   CLOSE cs_check_short;
   IF l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 166
                    ,pi_supplementary_info => :NEW.nlf_unique
                    );
   END IF;
--
END nm_load_files_b_ui_trg;
/
