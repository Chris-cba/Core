CREATE OR REPLACE TRIGGER nm_group_inv_link_all_dt_trg
 BEFORE INSERT
  OR UPDATE OF ngil_start_date,ngil_end_date
 ON nm_group_inv_link_all
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_group_inv_link_all_dt_trg.trg	1.1 10/23/03
--       Module Name      : nm_group_inv_link_all_dt_trg.trg
--       Date into SCCS   : 03/10/23 11:36:40
--       Date fetched Out : 07/06/13 17:02:46
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_start_date date := :NEW.ngil_start_date;
   l_end_date   date := :NEW.ngil_end_date;
--
   l_old_start_date date := :OLD.ngil_start_date;
   l_old_end_date   date := :OLD.ngil_end_date;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_16 IS -- NGIL_FK_IIT
   SELECT iit_start_date
         ,iit_end_date
    FROM  nm_inv_items_all
   WHERE  iit_ne_id = :NEW.ngil_iit_ne_id;
--
   l_p_16_start_date date;
   l_p_16_end_date   date;
--
   CURSOR cs_p_17 IS -- NGIL_FK_NE
   SELECT ne_start_date
         ,ne_end_date
    FROM  nm_elements_all
   WHERE  ne_id = :NEW.ngil_ne_ne_id;
--
   l_p_17_start_date date;
   l_p_17_end_date   date;
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
   -- NGIL_FK_IIT
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
   -- NGIL_FK_NE
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
      RAISE_APPLICATION_ERROR(-20980,'NGIL_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NGIL_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NGIL_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NGIL_END_DATE cannot be before NGIL_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END nm_group_inv_link_all_dt_trg;
/
