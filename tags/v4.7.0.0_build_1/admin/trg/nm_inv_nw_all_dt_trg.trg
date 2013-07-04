CREATE OR REPLACE TRIGGER NM_INV_NW_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF NIN_START_DATE,NIN_END_DATE
 ON NM_INV_NW_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_nw_all_dt_trg.trg	1.2 04/04/01
--       Module Name      : nm_inv_nw_all_dt_trg.trg
--       Date into SCCS   : 01/04/04 15:54:04
--       Date fetched Out : 07/06/13 17:03:02
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_start_date DATE := :NEW.NIN_START_DATE;
   l_end_date   DATE := :NEW.NIN_END_DATE;
--
   l_old_start_date DATE := :OLD.NIN_START_DATE;
   l_old_end_date   DATE := :OLD.NIN_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_9 IS -- NIN_NIT_FK
   SELECT NIT_START_DATE
         ,NIT_END_DATE
    FROM  NM_INV_TYPES_ALL
   WHERE  NIT_INV_TYPE = :NEW.NIN_NIT_INV_CODE;
--
   l_p_9_start_date DATE;
   l_p_9_end_date   DATE;
--
BEGIN
--
   IF   UPDATING
    AND l_old_start_date <> l_start_date
    THEN
      RAISE l_cannot_update_start_date;
   END IF;
--
   IF   l_start_date > l_end_date
    AND l_end_date IS NOT NULL
    THEN
      RAISE l_start_date_gt_end_date;
   END IF;
--
   -- NIN_NIT_FK
   OPEN  cs_p_9;
   FETCH cs_p_9 INTO l_p_9_start_date, l_p_9_end_date;
   CLOSE cs_p_9;
   IF l_p_9_end_date IS NULL
    THEN
      Null; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_9_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_9_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'NIN_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NIN_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NIN_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NIN_END_DATE cannot be before NIN_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_INV_NW_ALL_DT_TRG;
/
