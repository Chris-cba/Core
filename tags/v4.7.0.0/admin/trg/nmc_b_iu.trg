CREATE OR REPLACE TRIGGER nmc_b_iu
  BEFORE INSERT OR UPDATE
  ON nm_mrg_output_cols
  FOR EACH ROW
BEGIN
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nmc_b_iu.trg	1.1 11/14/01
--       Module Name      : nmc_b_iu.trg
--       Date into SCCS   : 01/11/14 17:08:10
--       Date fetched Out : 07/06/13 17:03:45
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nmc_b_iu
--    BEFORE INSERT OR UPDATE
--    ON nm_mrg_output_cols
--    FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   IF :new.nmc_sec_or_val = 'VAL'
    AND NOT nm3mrg_output.col_ok_for_query(nm3mrg_output.get_nmf(:new.nmc_nmf_id).nmf_nmq_id
                                          ,:new.nmc_column_name
                                          )
    AND INSTR(:new.nmc_column_name,',')+INSTR(:new.nmc_column_name,'(')+INSTR(:new.nmc_column_name,'+') = 0
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Column '||:new.nmc_column_name||' not valid for this query');
   END IF;
   IF   :NEW.nmc_view_col_name IS NOT NULL
    THEN
      IF nm3flx.is_reserved_word (:NEW.nmc_view_col_name)
       THEN
         RAISE_APPLICATION_ERROR(-20002,'View column '||:new.nmc_column_name||' not a valid column name (reserved word)');
      ELSIF NOT nm3flx.is_string_valid_for_object (:NEW.nmc_view_col_name)
       THEN
         RAISE_APPLICATION_ERROR(-20003,'View column '||:new.nmc_column_name||' not a valid column name (is_string_valid_for_object)');
      END IF;
   END IF;
END nmc_b_iu;
/
