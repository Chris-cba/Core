-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_type_columns_biud_row_trg.trg	1.1 10/22/03
--       Module Name      : nm_type_columns_biud_row_trg.trg
--       Date into SCCS   : 03/10/22 19:03:33
--       Date fetched Out : 07/06/13 17:03:38
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--    nm_type_columns_biu_row_trg
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
CREATE OR REPLACE TRIGGER huol_huo_length_trg
  BEFORE UPDATE
  ON hig_user_option_list
  FOR EACH ROW
DECLARE
  --
  CURSOR max_length_cur(p_huol_id IN VARCHAR2)
  IS
    SELECT max(huol_value) huol_value
      FROM (SELECT length(huo_value) huol_value
              FROM hig_user_options
             WHERE huo_id = p_huol_id
            UNION
            SELECT length(hop_value) huol_value
              FROM hig_options
             WHERE hop_id = p_huol_id);
--
  l_longest_value  NUMBER(8);
--
BEGIN
  --
  OPEN max_length_cur(p_huol_id => :new.huol_id);
  FETCH max_length_cur INTO l_longest_value;
  CLOSE max_length_cur;
  --
  IF :new.huol_max_length < l_longest_value THEN
    hig.
    raise_ner(
      pi_appl                 => nm3type.c_hig
     ,pi_id                   => 76
     ,pi_supplementary_info   => l_longest_value ||
                                '. An option value exists that is longer than the specified length.');
  END IF;
--
END huol_huo_length_trg;
/
