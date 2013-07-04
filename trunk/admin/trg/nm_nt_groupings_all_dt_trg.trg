CREATE OR REPLACE TRIGGER NM_NT_GROUPINGS_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF NNG_START_DATE,NNG_END_DATE
 ON NM_NT_GROUPINGS_ALL
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
   l_start_date DATE := :NEW.NNG_START_DATE;
   l_end_date   DATE := :NEW.NNG_END_DATE;
--
   l_old_start_date DATE := :OLD.NNG_START_DATE;
   l_old_end_date   DATE := :OLD.NNG_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_15 IS -- NNG_NGT_FK
   SELECT NGT_START_DATE
         ,NGT_END_DATE
    FROM  NM_GROUP_TYPES_ALL
   WHERE  NGT_GROUP_TYPE = :NEW.NNG_GROUP_TYPE;
--
   l_p_15_start_date DATE;
   l_p_15_end_date   DATE;
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
   -- NNG_NGT_FK
   OPEN  cs_p_15;
   FETCH cs_p_15 INTO l_p_15_start_date, l_p_15_end_date;
   CLOSE cs_p_15;
   IF l_p_15_end_date IS NULL
    THEN
      Null; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_15_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_15_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'NNG_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NNG_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NNG_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NNG_END_DATE cannot be before NNG_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_NT_GROUPINGS_ALL_DT_TRG;
/
