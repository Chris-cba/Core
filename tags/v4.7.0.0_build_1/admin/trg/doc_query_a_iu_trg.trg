CREATE OR REPLACE TRIGGER doc_query_a_iu_trg
 AFTER INSERT
   OR  UPDATE OF dq_sql
   ON  doc_query
  FOR  EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)doc_query_a_iu_trg.trg	1.1 02/28/02
--       Module Name      : doc_query_a_iu_trg.trg
--       Date into SCCS   : 02/02/28 10:35:49
--       Date fetched Out : 07/06/13 17:02:28
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TRIGGER doc_query_a_iu_trg
--    AFTER INSERT
--      OR  UPDATE OF dq_sql
--      ON  doc_query
--     FOR  EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
--
   IF UPDATING
    AND :NEW.dq_id != :OLD.dq_id
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Cannot update dq_ID');
   END IF;
--
   DELETE FROM doc_query_cols
   WHERE dqc_dq_id = :NEW.dq_id;
--
   dm3query.ins_tab_dqc (dm3query.derive_tab_dqc_from_dq(:NEW.dq_sql,:NEW.dq_id));
--
END doc_query_a_iu_trg;
/
