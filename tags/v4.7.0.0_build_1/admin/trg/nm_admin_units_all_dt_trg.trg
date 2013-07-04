CREATE OR REPLACE TRIGGER NM_ADMIN_UNITS_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF NAU_START_DATE,NAU_END_DATE
 ON NM_ADMIN_UNITS_ALL
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
   l_start_date DATE := :NEW.NAU_START_DATE;
   l_end_date   DATE := :NEW.NAU_END_DATE;
--
   l_old_start_date DATE := :OLD.NAU_START_DATE;
   l_old_end_date   DATE := :OLD.NAU_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_children (c_nau_admin_unit nm_admin_units_all.nau_admin_unit%TYPE
                      ,c_start_date    DATE
                      ,c_end_date      DATE
                      ) IS -- IIT_NAU_FK + NUA_NAU_FK
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  NM_INV_ITEMS_ALL
                  WHERE  IIT_ADMIN_UNIT = c_nau_admin_unit
                   AND  (IIT_START_DATE < c_start_date
                          OR (   (IIT_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (IIT_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND IIT_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_USER_AUS_ALL
                  WHERE  NUA_ADMIN_UNIT = c_nau_admin_unit
                   AND  (NUA_START_DATE < c_start_date
                          OR (   (NUA_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NUA_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NUA_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_ELEMENTS_ALL
                  WHERE  NE_ADMIN_UNIT = c_nau_admin_unit
                   AND  (NE_START_DATE < c_start_date
                          OR (   (NE_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NE_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NE_END_DATE > c_end_date)
                             )
                        )
                 );
--
   l_dummy BINARY_INTEGER;
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
   -- IIT_NAU_FK
   -- NUA_NAU_FK
   OPEN  cs_children (:NEW.nau_admin_unit, l_start_date, l_end_date);
   FETCH cs_children INTO l_dummy;
   IF cs_children%FOUND
    THEN
      CLOSE cs_children;
      RAISE l_has_children;
   END IF;
   CLOSE cs_children;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'NAU_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NAU_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NAU_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NAU_END_DATE cannot be before NAU_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_ADMIN_UNITS_ALL_DT_TRG;
/
