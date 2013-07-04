CREATE OR REPLACE TRIGGER nm_load_file_cols_b_ui_trg
       BEFORE  INSERT OR UPDATE
       ON      nm_load_file_cols
       FOR EACH ROW
BEGIN
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_load_file_cols_b_ui_trg.trg	1.1 09/16/02
--       Module Name      : nm_load_file_cols_b_ui_trg.trg
--       Date into SCCS   : 02/09/16 11:21:40
--       Date fetched Out : 07/06/13 17:03:13
--       SCCS Version     : 1.1
--
--       TRIGGER nm_load_file_cols_b_ui_trg
--         BEFORE  INSERT OR UPDATE
--         ON      nm_load_file_cols
--         FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   IF NOT nm3flx.is_string_valid_for_object (:NEW.nlfc_holding_col)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 30
                    ,pi_supplementary_info => :NEW.nlfc_holding_col
                    );
   END IF;
--
END nm_load_file_cols_b_ui_trg;
/
