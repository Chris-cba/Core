CREATE OR REPLACE TRIGGER nm_inv_type_validation_trg
       BEFORE  INSERT OR UPDATE OF nit_inv_type
       ON      nm_inv_types_all
       FOR EACH ROW
BEGIN
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_type_validation_trg.trg	1.1 01/28/02
--       Module Name      : nm_inv_type_validation_trg.trg
--       Date into SCCS   : 02/01/28 10:31:23
--       Date fetched Out : 07/06/13 17:03:06
--       SCCS Version     : 1.1
--
--       TRIGGER nm_inv_type_validation_trg
--         BEFORE  INSERT OR UPDATE OF nit_inv_type
--         ON      nm_inv_types_all
--         FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   IF NOT nm3flx.is_string_valid_for_object (:NEW.nit_inv_type)
    THEN
      RAISE_APPLICATION_ERROR(-20001,'"'||:NEW.nit_inv_type||'" is not a valid name for an Inv_Type. Use only alphanumeric and _ chars');
   END IF;
--
END nm_inv_type_validation_trg;
/
