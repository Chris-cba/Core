CREATE OR REPLACE TRIGGER nm_inv_items_all_b_dt_trg
 BEFORE INSERT
  OR UPDATE OF IIT_START_DATE, IIT_END_DATE
 ON NM_INV_ITEMS_ALL
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_items_all_b_dt_trg.trg	1.3 01/07/03
--       Module Name      : nm_inv_items_all_b_dt_trg.trg
--       Date into SCCS   : 03/01/07 16:38:21
--       Date fetched Out : 07/06/13 17:02:53
--       SCCS Version     : 1.3
--
-- TRIGGER nm_inv_items_all_b_dt_trg
-- BEFORE INSERT
--  OR UPDATE OF IIT_START_DATE, IIT_END_DATE
-- ON NM_INV_ITEMS_ALL
-- FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_start_date     DATE := :NEW.IIT_START_DATE;
   l_end_date       DATE := :NEW.IIT_END_DATE;
--
   l_old_start_date DATE := :OLD.IIT_START_DATE;
   l_old_end_date   DATE := :OLD.IIT_END_DATE;
--
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
--
   l_rec_nii nm_inv_items%ROWTYPE;
--
   l_ner_id             nm_errors.ner_id%TYPE;
   l_ner_appl           nm_errors.ner_appl%TYPE := nm3type.c_net;
   l_supplementary_info VARCHAR2(500) := 'NM_INV_ITEMS_ALL('||:new.iit_ne_id||')';
--
   l_mode    VARCHAR2(30) := NULL;
--
   l_nvl_date CONSTANT DATE := TO_DATE('01/01/0001','DD/MM/YYYY');
--
BEGIN
   IF UPDATING
    AND l_old_start_date <> l_start_date
    THEN
      l_ner_id             := 10;
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
-- Populate any required values in the rowtype record
--
   IF INSERTING
    THEN
      l_mode := Nm3invval.c_insert_mode;
   ELSE
      l_mode := Nm3invval.c_update_mode;
   END IF;
--
   IF l_mode IS NOT NULL
    THEN
--
      l_rec_nii.iit_ne_id       := :NEW.iit_ne_id;
      l_rec_nii.iit_start_date  := :NEW.iit_start_date;
      l_rec_nii.iit_end_date    := :NEW.iit_end_date;
      l_rec_nii.iit_admin_unit  := :NEW.iit_admin_unit;
      l_rec_nii.iit_located_by  := :NEW.iit_located_by;
      l_rec_nii.iit_inv_type    := :NEW.iit_inv_type;
      l_rec_nii.iit_primary_key := :NEW.iit_primary_key;
--
      Nm3invval.pop_date_chk_tab (l_rec_nii
                                 ,l_mode
                                 );
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    OR  l_start_date_gt_end_date
    THEN
      hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info
                    );

END nm_inv_items_all_b_dt_trg;
/
