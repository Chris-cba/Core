CREATE OR REPLACE TRIGGER NM_INV_ITEM_GROUPINGS_A_DT_TRG
 BEFORE INSERT
  OR UPDATE OF IIG_START_DATE,IIG_END_DATE
 ON NM_INV_ITEM_GROUPINGS_ALL
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
   l_start_date DATE := :NEW.IIG_START_DATE;
   l_end_date   DATE := :NEW.IIG_END_DATE;
--
   l_old_start_date DATE := :OLD.IIG_START_DATE;
   l_old_end_date   DATE := :OLD.IIG_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_7 IS -- IIG_IIT_FK_PARENT
   SELECT IIT_START_DATE
         ,IIT_END_DATE
    FROM  NM_INV_ITEMS_ALL
   WHERE  IIT_NE_ID = :NEW.IIG_PARENT_ID;
--
   l_p_7_start_date DATE;
   l_p_7_end_date   DATE;
--
   CURSOR cs_p_8 IS -- IIG_IIT_FK_TOP
   SELECT IIT_START_DATE
         ,IIT_END_DATE
    FROM  NM_INV_ITEMS_ALL
   WHERE  IIT_NE_ID = :NEW.IIG_TOP_ID;
--
   l_p_8_start_date DATE;
   l_p_8_end_date   DATE;
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
   -- IIG_IIT_FK_PARENT
   OPEN  cs_p_7;
   FETCH cs_p_7 INTO l_p_7_start_date, l_p_7_end_date;
   CLOSE cs_p_7;
   IF l_p_7_end_date IS NULL
    THEN
      Null; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_7_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_7_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
   -- IIG_IIT_FK_TOP
   OPEN  cs_p_8;
   FETCH cs_p_8 INTO l_p_8_start_date, l_p_8_end_date;
   CLOSE cs_p_8;
   IF l_p_8_end_date IS NULL
    THEN
      Null; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_8_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_8_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'IIG_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'IIG_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'IIG_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'IIG_END_DATE cannot be before IIG_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_INV_ITEM_GROUPINGS_A_DT_TRG;
/
