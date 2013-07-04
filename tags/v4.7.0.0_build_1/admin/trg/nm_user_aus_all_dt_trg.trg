CREATE OR REPLACE TRIGGER NM_USER_AUS_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF NUA_START_DATE,NUA_END_DATE
 ON NM_USER_AUS_ALL
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
   l_start_date DATE := :NEW.NUA_START_DATE;
   l_end_date   DATE := :NEW.NUA_END_DATE;
--
   l_old_start_date DATE := :OLD.NUA_START_DATE;
   l_old_end_date   DATE := :OLD.NUA_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_16 IS -- NUA_HUS_FK
   SELECT HUS_START_DATE
         ,HUS_END_DATE
    FROM  HIG_USERS
   WHERE  HUS_USER_ID = :NEW.NUA_USER_ID;
--
   l_p_16_start_date DATE;
   l_p_16_end_date   DATE;
--
   CURSOR cs_p_17 IS -- NUA_NAU_FK
   SELECT NAU_START_DATE
         ,NAU_END_DATE
    FROM  NM_ADMIN_UNITS_ALL
   WHERE  NAU_ADMIN_UNIT = :NEW.NUA_ADMIN_UNIT;
--
   l_p_17_start_date DATE;
   l_p_17_end_date   DATE;
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
   -- NUA_HUS_FK
   OPEN  cs_p_16;
   FETCH cs_p_16 INTO l_p_16_start_date, l_p_16_end_date;
   CLOSE cs_p_16;
   IF l_p_16_end_date IS NULL
    THEN
      NULL; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_16_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_16_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
   -- NUA_NAU_FK
   OPEN  cs_p_17;
   FETCH cs_p_17 INTO l_p_17_start_date, l_p_17_end_date;
   CLOSE cs_p_17;
   IF l_p_17_end_date IS NULL
    THEN
      NULL; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_17_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_17_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'NUA_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NUA_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NUA_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NUA_END_DATE cannot be before NUA_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_USER_AUS_ALL_DT_TRG;
/
