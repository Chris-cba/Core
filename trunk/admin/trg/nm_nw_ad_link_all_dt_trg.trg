CREATE OR REPLACE TRIGGER nm_nw_ad_link_all_dt_trg
 BEFORE INSERT
  OR UPDATE OF NAD_START_DATE ,NAD_END_DATE
 ON NM_NW_AD_LINK_ALL
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid            :  @(#)nm_nw_ad_link_all_dt_trg.trg	1.1 08/02/05
--       Module Name       :  nm_nw_ad_link_all_dt_trg.trg
--       Date into SCCS    :  05/08/02 11:32:27
--       Date fetched Out  :  07/06/13 17:03:30
--       SCCS Version      :  1.1
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
   l_start_date               DATE := :NEW.NAD_START_DATE;
   l_end_date                 DATE := :NEW.NAD_END_DATE;
--
   l_old_start_date           DATE := :OLD.NAD_START_DATE;
   l_old_end_date             DATE := :OLD.NAD_END_DATE;
--
   l_parent_start_date        DATE;
   l_parent_end_date          DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   l_ner_id                   NM_ERRORS.ner_id%TYPE;
   l_ner_appl                 NM_ERRORS.ner_appl%TYPE := Nm3type.c_net;
--
   l_dummy                    PLS_INTEGER;
   l_found                    BOOLEAN;
   l_supplementary_info       VARCHAR2(500);
--
   CURSOR cs_ne
            (c_ne_id  nm_elements_all.ne_id%TYPE
            ,c_start_date DATE )
   IS
     SELECT 1
       FROM DUAL
      WHERE EXISTS
             (SELECT 1
                FROM nm_elements_all
               WHERE ne_id = c_ne_id
                 AND ne_start_date > c_start_date);
--
   CURSOR cs_iit
            (c_iit_ne_id  nm_inv_items_all.iit_ne_id%TYPE
            ,c_start_date DATE )
   IS
     SELECT 1
       FROM DUAL
      WHERE EXISTS
             (SELECT 1
                FROM nm_inv_items_all
               WHERE iit_ne_id = c_iit_ne_id
                 AND iit_start_date > c_start_date);
--
BEGIN
--
   IF   UPDATING
    AND l_old_start_date <> l_start_date
    THEN
      l_ner_id := 10;
      RAISE l_cannot_update_start_date;
   END IF;
--
   IF   l_start_date > l_end_date
    AND l_end_date IS NOT NULL
    THEN
      l_ner_id             := 14;
      l_supplementary_info := l_supplementary_info||TO_CHAR(l_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))||' > '||TO_CHAR(l_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
      RAISE l_start_date_gt_end_date;
   END IF;
--
   OPEN  cs_ne (:NEW.NAD_NE_ID, l_start_date );
   FETCH cs_ne INTO l_dummy;
   l_found := cs_ne%FOUND;
   CLOSE cs_ne;
   IF l_found
    THEN
      l_ner_id             := 11;
      l_supplementary_info := l_supplementary_info||' - NM_NW_AD_LINK_ALL.NAD_NE_ID';
      RAISE l_start_date_out_of_range;
   END IF;
--
   OPEN  cs_iit (:NEW.NAD_IIT_NE_ID, l_start_date );
   FETCH cs_iit INTO l_dummy;
   l_found := cs_iit%FOUND;
   CLOSE cs_iit;
   IF l_found
    THEN
      l_ner_id             := 11;
      l_supplementary_info := l_supplementary_info||' - NM_NW_AD_LINK_ALL.NAD_IIT_NE_ID';
      RAISE l_start_date_out_of_range;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    OR  l_start_date_gt_end_date
    OR  l_has_children
    THEN
      Hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info
                    );
   WHEN l_start_date_out_of_range
    THEN
      Hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info||' '||TO_CHAR(l_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))||' > '||TO_CHAR(l_parent_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                    );
   WHEN l_end_date_out_of_range
    THEN
      Hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info||' '||NVL(TO_CHAR(l_end_date,Sys_Context('NM3CORE','USER_DATE_MASK')),'Null')||' > '||TO_CHAR(l_parent_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                    );
--
END nm_nw_ad_link_all_dt_trg;
/


