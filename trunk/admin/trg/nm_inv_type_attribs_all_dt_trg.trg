CREATE OR REPLACE TRIGGER nm_inv_type_attribs_all_dt_trg
 BEFORE INSERT
  OR UPDATE OF ITA_START_DATE,ITA_END_DATE
 ON NM_INV_TYPE_ATTRIBS_ALL
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
   l_start_date DATE := :NEW.ITA_START_DATE;
   l_end_date   DATE := :NEW.ITA_END_DATE;
--
   l_old_start_date DATE := :OLD.ITA_START_DATE;
   l_old_end_date   DATE := :OLD.ITA_END_DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_p_10 IS -- ITA_ID_FK
   SELECT ID_START_DATE
         ,ID_END_DATE
    FROM  NM_INV_DOMAINS_ALL
   WHERE  ID_DOMAIN = :NEW.ITA_ID_DOMAIN;
--
   l_p_10_start_date DATE;
   l_p_10_end_date   DATE;
--
   CURSOR cs_p_11 IS -- ITA_NIT_FK
   SELECT NIT_START_DATE
         ,NIT_END_DATE
    FROM  NM_INV_TYPES_ALL
   WHERE  NIT_INV_TYPE = :NEW.ITA_INV_TYPE;
--
   l_p_11_start_date DATE;
   l_p_11_end_date   DATE;
--
   CURSOR cs_children_no_dates (c_ita_inv_type     nm_inv_type_attribs_all.ita_inv_type%TYPE
                               ,c_ita_attrib_name  nm_inv_type_attribs_all.ita_attrib_name%TYPE
                               ) IS
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  nm_inv_type_attrib_bandings
                  WHERE  itb_inv_type    = c_ita_inv_type
                   AND   itb_attrib_name = c_ita_attrib_name
                 )
    OR    EXISTS (SELECT 1
                   FROM  nm_mrg_query_types
                        ,nm_mrg_query_attribs
                  WHERE  nqt_inv_type    = c_ita_inv_type
                   AND   nqt_nmq_id      = nqa_nmq_id
                   AND   nqt_seq_no      = nqa_nqt_seq_no
                   AND   nqa_attrib_name = c_ita_attrib_name
                 )
    OR    EXISTS (SELECT 1
                   FROM  nm_pbi_query_types
                        ,nm_pbi_query_attribs
                  WHERE  nqt_item_type_type  = nm3gaz_qry.c_ngqt_item_type_type_inv
                   AND   nqt_item_type       = c_ita_inv_type
                   AND   nqt_npq_id          = nqa_npq_id
                   AND   nqt_seq_no          = nqa_nqt_seq_no
                   AND   nqa_attrib_name     = c_ita_attrib_name
                 )
    OR    EXISTS (SELECT 1
                   FROM  nm_x_inv_conditions
                  WHERE  nxic_inv_type    = c_ita_inv_type
                   AND   nxic_column_name = c_ita_attrib_name
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
   -- ITA_ID_FK
   OPEN  cs_p_10;
   FETCH cs_p_10 INTO l_p_10_start_date, l_p_10_end_date;
   CLOSE cs_p_10;
   IF l_p_10_end_date IS NULL
    THEN
      Null; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_10_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_10_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
   -- ITA_NIT_FK
   OPEN  cs_p_11;
   FETCH cs_p_11 INTO l_p_11_start_date, l_p_11_end_date;
   CLOSE cs_p_11;
   IF l_p_11_end_date IS NULL
    THEN
      Null; -- Dont worry about it
   ELSIF l_end_date IS NULL
    OR   l_end_date >  l_p_11_end_date
    THEN
      RAISE l_end_date_out_of_range;
   END IF;
   IF l_start_date < l_p_11_start_date
    THEN
      RAISE l_start_date_out_of_range;
   END IF;
--
   IF   l_end_date     IS NOT NULL
    AND l_old_end_date IS     NULL
    THEN
      -- If we're setting the end-date make user there are no merge or pbi queries which use this attribute
      OPEN  cs_children_no_dates (:NEW.ita_inv_type, :NEW.ita_attrib_name);
      FETCH cs_children_no_dates INTO l_dummy;
      IF cs_children_no_dates%FOUND
       THEN
         CLOSE cs_children_no_dates;
         RAISE l_has_children;
      END IF;
      CLOSE cs_children_no_dates;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      RAISE_APPLICATION_ERROR(-20980,'ITA_START_DATE cannot be updated');
   WHEN l_start_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20981,'ITA_START_DATE out of range');
   WHEN l_end_date_out_of_range
    THEN
      RAISE_APPLICATION_ERROR(-20982,'ITA_END_DATE out of range');
   WHEN l_start_date_gt_end_date
    THEN
      RAISE_APPLICATION_ERROR(-20984,'ITA_END_DATE cannot be before ITA_START_DATE');
   WHEN l_has_children
    THEN
      RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END nm_inv_type_attribs_all_dt_trg;
/
