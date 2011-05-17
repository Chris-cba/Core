CREATE OR REPLACE TRIGGER nm_elements_all_dt_trg
 BEFORE INSERT
  OR UPDATE OF NE_START_DATE,NE_END_DATE
 ON NM_ELEMENTS_ALL
 FOR EACH ROW
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_elements_all_dt_trg.trg-arc   2.2   May 17 2011 08:32:02   Steve.Cooper  $
--       Module Name      : $Workfile:   nm_elements_all_dt_trg.trg  $
--       Date into SCCS   : $Date:   May 17 2011 08:32:02  $
--       Date fetched Out : $Modtime:   Apr 01 2011 14:52:16  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   l_start_date DATE := :NEW.NE_START_DATE;
   l_end_date   DATE := :NEW.NE_END_DATE;
--
   l_old_start_date DATE := :OLD.NE_START_DATE;
   l_old_end_date   DATE := :OLD.NE_END_DATE;
--
   l_parent_start_date DATE;
   l_parent_end_date   DATE;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_ne_no_fk_end IS -- NE_NO_FK_END
   SELECT NO_START_DATE
         ,NO_END_DATE
    FROM  NM_NODES_ALL
   WHERE  NO_NODE_ID = :NEW.NE_NO_END;
--
   CURSOR cs_ne_no_fk_st IS -- ne_no_fk_st
   SELECT NO_START_DATE
         ,NO_END_DATE
    FROM  NM_NODES_ALL
   WHERE  NO_NODE_ID = :NEW.NE_NO_START;
--
   CURSOR cs_ne_ngt_fk IS -- ne_ngt_fk
   SELECT NGT_START_DATE
         ,NGT_END_DATE
    FROM  NM_GROUP_TYPES_ALL
   WHERE  NGT_GROUP_TYPE = :NEW.NE_GTY_GROUP_TYPE;
--
   CURSOR cs_ne_nau_fk IS -- ne_nau_fk
   SELECT nau_start_date
         ,nau_end_date
    FROM  nm_admin_units_all
   WHERE  nau_admin_unit = :NEW.ne_admin_unit;
--
   l_ner_id             nm_errors.ner_id%TYPE;
   l_ner_appl           nm_errors.ner_appl%TYPE := nm3type.c_net;
   l_supplementary_info VARCHAR2(500) := 'NM_ELEMENTS_ALL('||:new.ne_id||')';
--
   CURSOR cs_children_nm_of (c_ne_id      nm_elements_all.ne_id%TYPE
                            ,c_start_date DATE -- NM_ELEMENTS.NE_START_DATE
                            ,c_end_date   DATE -- NM_ELEMENTS.NE_END_DATE
                            ) IS -- NM_NE_FK_OF + NS_NE_FK
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  NM_MEMBERS_ALL
                  WHERE  NM_NE_ID_OF = c_ne_id
                   AND  (NM_START_DATE < c_start_date
                          OR (   (NM_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NM_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND nm_end_date > c_end_date)
                             )
                        )
                 );
--
   CURSOR cs_children_nm_in (c_ne_id      nm_elements_all.ne_id%TYPE
                            ,c_start_date DATE -- NM_ELEMENTS.NE_START_DATE
                            ,c_end_date   DATE -- NM_ELEMENTS.NE_END_DATE
                            ) IS -- NM_NE_FK_OF + NS_NE_FK
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  NM_MEMBERS_ALL
                  WHERE  NM_NE_ID_IN = c_ne_id
                   AND  (NM_START_DATE < c_start_date
                          OR (   (NM_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NM_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND nm_end_date > c_end_date)
                             )
                        )
                 );
--
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
BEGIN
--
    --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3net.bypass_nm_elements_trgs
  Then 
    IF   UPDATING
     AND l_old_start_date <> l_start_date AND :NEW.ne_nt_type != 'NSGN' -- GJ 15-AUG-2006 update of NSGN start dates is a requirement
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
    -- NE_NO_FK_END
    OPEN  cs_ne_no_fk_end;
    FETCH cs_ne_no_fk_end INTO l_parent_start_date, l_parent_end_date;
    CLOSE cs_ne_no_fk_end;
    IF l_parent_end_date IS NULL
     THEN
       Null; -- Dont worry about it
    ELSIF l_end_date IS NULL
     OR   l_end_date >  l_parent_end_date
     THEN
       l_ner_id             := 12;
       l_supplementary_info := l_supplementary_info||'.NE_NO_END - NM_NODES_ALL';
       RAISE l_end_date_out_of_range;
    END IF;
    IF l_start_date < l_parent_start_date
     THEN
       l_ner_id             := 11;
       l_supplementary_info := l_supplementary_info||'.NE_NO_END - NM_NODES_ALL';
       RAISE l_start_date_out_of_range;
    END IF;
 --
    -- NE_NO_FK_ST
    OPEN  cs_ne_no_fk_st;
    FETCH cs_ne_no_fk_st INTO l_parent_start_date, l_parent_end_date;
    CLOSE cs_ne_no_fk_st;
    IF l_parent_end_date IS NULL
     THEN
       Null; -- Dont worry about it
    ELSIF l_end_date IS NULL
     OR   l_end_date >  l_parent_end_date
     THEN
       l_ner_id             := 12;
       l_supplementary_info := l_supplementary_info||'.NE_NO_START - NM_NODES_ALL';
       RAISE l_end_date_out_of_range;
    END IF;
    IF l_start_date < l_parent_start_date
     THEN
       l_ner_id             := 11;
       l_supplementary_info := l_supplementary_info||'.NE_NO_START - NM_NODES_ALL';
       RAISE l_start_date_out_of_range;
    END IF;
 --
    -- NE_NGT_FK
    OPEN  cs_ne_ngt_fk;
    FETCH cs_ne_ngt_fk INTO l_parent_start_date, l_parent_end_date;
    CLOSE cs_ne_ngt_fk;
    IF l_parent_end_date IS NULL
     THEN
       Null; -- Dont worry about it
    ELSIF l_end_date IS NULL
     OR   l_end_date >  l_parent_end_date
     THEN
       l_ner_id             := 12;
       l_supplementary_info := l_supplementary_info||'.NGT_GROUP_TYPE - NM_GROUP_TYPES_ALL';
       RAISE l_end_date_out_of_range;
    END IF;
    IF l_start_date < l_parent_start_date
     THEN
       l_ner_id             := 11;
       l_supplementary_info := l_supplementary_info||'.NGT_GROUP_TYPE - NM_GROUP_TYPES_ALL';
       RAISE l_start_date_out_of_range;
    END IF;
 --
    -- NE_NAU_FK
    OPEN  cs_ne_nau_fk;
    FETCH cs_ne_nau_fk INTO l_parent_start_date, l_parent_end_date;
    CLOSE cs_ne_nau_fk;
    IF l_parent_end_date IS NULL
     THEN
       Null; -- Dont worry about it
    ELSIF l_end_date IS NULL
     OR   l_end_date >  l_parent_end_date
     THEN
       l_ner_id             := 12;
       l_supplementary_info := l_supplementary_info||'.NE_ADMIN_UNIT - NM_ADMIN_UNITS_ALL';
       RAISE l_end_date_out_of_range;
    END IF;
    IF l_start_date < l_parent_start_date
     THEN
       l_ner_id             := 11;
       l_supplementary_info := l_supplementary_info||'.NE_ADMIN_UNIT - NM_ADMIN_UNITS_ALL';
       RAISE l_start_date_out_of_range;
    END IF;
 --
    -- NM_NE_FK_OF
    -- NS_NE_FK
    OPEN  cs_children_nm_of (:NEW.NE_ID, l_start_date, l_end_date);
    FETCH cs_children_nm_of INTO l_dummy;
    l_found := cs_children_nm_of%FOUND;
    CLOSE cs_children_nm_of;
    IF l_found
     THEN
       l_ner_id             := 13;
       l_supplementary_info := l_supplementary_info||' - NM_MEMBERS_ALL.NM_NE_ID_OF';
       RAISE l_has_children;
    END IF;
    --
    OPEN  cs_children_nm_in (:NEW.NE_ID, l_start_date, l_end_date);
    FETCH cs_children_nm_in INTO l_dummy;
    l_found := cs_children_nm_in%FOUND;
    CLOSE cs_children_nm_in;
    IF l_found
     THEN
       l_ner_id             := 13;
       l_supplementary_info := l_supplementary_info||' - NM_MEMBERS_ALL.NM_NE_ID_IN';
       RAISE l_has_children;
    END IF;
  End If;
 --
 EXCEPTION
 --
    WHEN l_cannot_update_start_date
     OR  l_start_date_gt_end_date
     OR  l_has_children
     THEN
       hig.raise_ner (pi_appl               => l_ner_appl
                     ,pi_id                 => l_ner_id
                     ,pi_supplementary_info => l_supplementary_info
                     );
    WHEN l_start_date_out_of_range
     THEN
       hig.raise_ner (pi_appl               => l_ner_appl
                     ,pi_id                 => l_ner_id
                     ,pi_supplementary_info => l_supplementary_info||' '||TO_CHAR(l_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))||' > '||TO_CHAR(l_parent_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                     );
    WHEN l_end_date_out_of_range
     THEN
       hig.raise_ner (pi_appl               => l_ner_appl
                     ,pi_id                 => l_ner_id
                     ,pi_supplementary_info => l_supplementary_info||' '||NVL(TO_CHAR(l_end_date,Sys_Context('NM3CORE','USER_DATE_MASK')),'Null')||' > '||TO_CHAR(l_parent_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                     );
 --
END nm_elements_all_dt_trg;
/
