CREATE OR REPLACE TRIGGER NM_INV_TYPE_GROUPINGS_A_DT_TRG
 BEFORE INSERT
  OR UPDATE OF ITG_START_DATE,ITG_END_DATE
 ON NM_INV_TYPE_GROUPINGS_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : %W% %G%
--       Module Name      : %M%
--       Date into SCCS   : %E% %U%
--       Date fetched Out : %D% %T%
--       SCCS Version     : %I%
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_start_date DATE := :NEW.ITG_START_DATE;
   l_end_date   DATE := :NEW.ITG_END_DATE;
--
   l_old_start_date DATE := :OLD.ITG_START_DATE;
   l_old_end_date   DATE := :OLD.ITG_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_12 IS -- ITG_NIT_FK_PARENT
   SELECT NIT_START_DATE
         ,NIT_END_DATE
    FROM  NM_INV_TYPES_ALL
   WHERE  NIT_INV_TYPE = :NEW.ITG_PARENT_INV_TYPE;
--
   l_p_12_start_date DATE;
   l_p_12_end_date   DATE;
--
   CURSOR cs_p_13 IS -- ITG_NIT_FK
   SELECT NIT_START_DATE
         ,NIT_END_DATE
    FROM  NM_INV_TYPES_ALL
   WHERE  NIT_INV_TYPE = :NEW.ITG_INV_TYPE;
--
   l_p_13_start_date DATE;
   l_p_13_end_date   DATE;
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
   IF   l_old_end_date IS NOT NULL
    AND UPDATING
    AND l_old_end_date <> l_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
--
   -- ITG_NIT_FK_PARENT
   OPEN  cs_p_12;
   FETCH cs_p_12 INTO l_p_12_start_date, l_p_12_end_date;
   CLOSE cs_p_12;
   IF l_p_12_end_date IS NULL
    THEN
      NULL; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_12_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_12_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
   -- ITG_NIT_FK
   OPEN  cs_p_13;
   FETCH cs_p_13 INTO l_p_13_start_date, l_p_13_end_date;
   CLOSE cs_p_13;
   IF l_p_13_end_date IS NULL
    THEN
      NULL; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_13_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_13_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'ITG_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'ITG_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'ITG_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'ITG_END_DATE cannot be before ITG_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_INV_TYPE_GROUPINGS_A_DT_TRG;
/
