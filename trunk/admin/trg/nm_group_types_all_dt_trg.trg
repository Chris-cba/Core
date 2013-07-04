CREATE OR REPLACE TRIGGER NM_GROUP_TYPES_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF NGT_START_DATE,NGT_END_DATE
 ON NM_GROUP_TYPES_ALL
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
   l_start_date DATE := :NEW.NGT_START_DATE;
   l_end_date   DATE := :NEW.NGT_END_DATE;
--
   l_old_start_date DATE := :OLD.NGT_START_DATE;
   l_old_end_date   DATE := :OLD.NGT_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_children (c_ngt_group_type nm_group_types_all.ngt_group_type%TYPE
                      ,c_start_date     DATE
                      ,c_end_date       DATE
                      ) IS -- NE_NGT_FK + NGR_NGT_FK2 + NGR_NGT_FK + NNG_NGT_FK
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  NM_ELEMENTS_ALL
                  WHERE  NE_GTY_GROUP_TYPE = c_ngt_group_type
                   AND  (NE_START_DATE < c_start_date
                          OR (   (NE_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NE_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NE_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_GROUP_RELATIONS_ALL
                  WHERE  NGR_CHILD_GROUP_TYPE = c_ngt_group_type
                   AND  (NGR_START_DATE < c_start_date
                          OR (   (NGR_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NGR_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NGR_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_GROUP_RELATIONS_ALL
                  WHERE  NGR_PARENT_GROUP_TYPE = c_ngt_group_type
                   AND  (NGR_START_DATE < c_start_date
                          OR (   (NGR_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NGR_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NGR_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_NT_GROUPINGS_ALL
                  WHERE  NNG_GROUP_TYPE = c_ngt_group_type
                   AND  (NNG_START_DATE < c_start_date
                          OR (   (NNG_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NNG_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NNG_END_DATE > c_end_date)
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
   -- NE_NGT_FK
   -- NGR_NGT_FK2
   -- NGR_NGT_FK
   -- NNG_NGT_FK
   OPEN  cs_children (:NEW.ngt_group_type, l_start_date, l_end_date);
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
      RAISE_APPLICATION_ERROR(-20980,'NGT_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'NGT_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'NGT_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'NGT_END_DATE cannot be before NGT_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_GROUP_TYPES_ALL_DT_TRG;
/
