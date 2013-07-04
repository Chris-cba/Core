CREATE OR REPLACE TRIGGER NM_INV_ATTRI_LOOKUP_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF IAL_START_DATE,IAL_END_DATE
 ON NM_INV_ATTRI_LOOKUP_ALL
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
--
   l_start_date DATE := :NEW.IAL_START_DATE;
   l_end_date   DATE := :NEW.IAL_END_DATE;
--
   l_old_start_date DATE := :OLD.IAL_START_DATE;
   l_old_end_date   DATE := :OLD.IAL_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_6 IS -- IAD_ID_FK
   SELECT ID_START_DATE
         ,ID_END_DATE
    FROM  NM_INV_DOMAINS_ALL
   WHERE  ID_DOMAIN = :NEW.IAL_DOMAIN;
--
   l_p_6_start_date DATE;
   l_p_6_end_date   DATE;
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
   -- IAD_ID_FK
   OPEN  cs_p_6;
   FETCH cs_p_6 INTO l_p_6_start_date, l_p_6_end_date;
   CLOSE cs_p_6;
   IF l_p_6_end_date IS NULL
    THEN
      NULL; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_6_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_6_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'IAL_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'IAL_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'IAL_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'IAL_END_DATE cannot be before IAL_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_INV_ATTRI_LOOKUP_ALL_DT_TRG;
/
