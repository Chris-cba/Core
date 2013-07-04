CREATE OR REPLACE TRIGGER nm_operation_data_chk_trg
   BEFORE INSERT OR UPDATE
   ON nm_operation_data
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_operation_data_chk_trg.trg	1.1 07/04/02
--       Module Name      : nm_operation_data_chk_trg.trg
--       Date into SCCS   : 02/07/04 13:48:08
--       Date fetched Out : 07/06/13 17:03:33
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--      TRIGGER nm_operation_data_chk_trg
--      BEFORE INSERT OR UPDATE
--      ON nm_operation_data
--      FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   IF NVL(:OLD.nod_query_sql,nm3type.c_nvl) != NVL(:NEW.nod_query_sql,nm3type.c_nvl)
    THEN
      nm3flx.is_select_statement_valid (:NEW.nod_query_sql);
   END IF;
END nm_operation_data_chk_trg;
/
