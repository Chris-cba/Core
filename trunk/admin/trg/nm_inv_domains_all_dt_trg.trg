CREATE OR REPLACE TRIGGER NM_INV_DOMAINS_ALL_DT_TRG
 BEFORE INSERT
  OR UPDATE OF ID_START_DATE,ID_END_DATE
 ON NM_INV_DOMAINS_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_domains_all_dt_trg.trg	1.2 03/30/01
--       Module Name      : nm_inv_domains_all_dt_trg.trg
--       Date into SCCS   : 01/03/30 12:23:08
--       Date fetched Out : 07/06/13 17:02:51
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_start_date DATE := :NEW.ID_START_DATE;
   l_end_date   DATE := :NEW.ID_END_DATE;
--
   l_old_start_date DATE := :OLD.ID_START_DATE;
   l_old_end_date   DATE := :OLD.ID_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_children (c_id_domain      nm_inv_domains_all.id_domain%TYPE
                      ,c_start_date     DATE
                      ,c_end_date       DATE
                      ) IS -- IAD_ID_FK + ITA_ID_FK
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  NM_INV_ATTRI_LOOKUP_ALL
                  WHERE  IAL_DOMAIN = c_id_domain
                   AND  (IAL_START_DATE < c_start_date
                          OR (   (IAL_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (IAL_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND IAL_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_INV_TYPE_ATTRIBS_ALL
                  WHERE  ITA_ID_DOMAIN = c_id_domain
                   AND  (ITA_START_DATE < c_start_date
                          OR (   (ITA_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (ITA_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND ITA_END_DATE > c_end_date)
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
   -- IAD_ID_FK
   -- ITA_ID_FK
   OPEN  cs_children (:NEW.id_domain, l_start_date, l_end_date);
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
      RAISE_APPLICATION_ERROR(-20980,'ID_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'ID_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'ID_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'ID_END_DATE cannot be before ID_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END NM_INV_DOMAINS_ALL_DT_TRG;
/
