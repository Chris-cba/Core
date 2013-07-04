CREATE OR REPLACE TRIGGER NM_NODE_USAGES_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF NNU_START_DATE,NNU_END_DATE
 ON NM_NODE_USAGES_ALL
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
   l_start_date DATE := :NEW.NNU_START_DATE;
   l_end_date   DATE := :NEW.NNU_END_DATE;
--
   l_old_start_date DATE := :OLD.NNU_START_DATE;
   l_old_end_date   DATE := :OLD.NNU_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_14 IS -- NNU_NN_FK
   SELECT NO_START_DATE
         ,NO_END_DATE
    FROM  NM_NODES_ALL
   WHERE  NO_NODE_ID = :NEW.NNU_NO_NODE_ID;
--
   l_p_14_start_date DATE;
   l_p_14_end_date   DATE;
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
   -- NNU_NN_FK
   OPEN  cs_p_14;
   FETCH cs_p_14 INTO l_p_14_start_date, l_p_14_end_date;
   CLOSE cs_p_14;
   IF l_p_14_end_date IS NULL
    THEN
      Null; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_14_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_14_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'NNU_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NNU_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NNU_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NNU_END_DATE cannot be before NNU_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_NODE_USAGES_ALL_DT_TRG;
/
