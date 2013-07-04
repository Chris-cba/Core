CREATE OR REPLACE TRIGGER nm_nodes_all_dt_trg
 BEFORE INSERT
  OR UPDATE OF NO_START_DATE,NO_END_DATE
 ON NM_NODES_ALL
 FOR EACH ROW
DECLARE

--
-----------------------------------------------------------------------------
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

   l_start_date DATE := :NEW.NO_START_DATE;
   l_end_date   DATE := :NEW.NO_END_DATE;
--
   l_old_start_date DATE := :OLD.NO_START_DATE;
   l_old_end_date   DATE := :OLD.NO_END_DATE;
--
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
--
   CURSOR cs_children (c_no_node_id    nm_nodes_all.no_node_id%TYPE
                      ,c_start_date    DATE -- NM_ELEMENTS.NE_START_DATE
                      ,c_end_date      DATE -- NM_ELEMENTS.NE_END_DATE
                      ) IS -- NE_NO_FK_END + NE_NO_FK_ST + NNU_NN_FK
   SELECT 1
    FROM  DUAL
   WHERE  EXISTS (SELECT 1
                   FROM  NM_ELEMENTS_ALL
                  WHERE  NE_NO_END = c_no_node_id
                   AND  (NE_START_DATE < c_start_date
                          OR (   (NE_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NE_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NE_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_ELEMENTS_ALL
                  WHERE  NE_NO_START = c_no_node_id
                   AND  (NE_START_DATE < c_start_date
                          OR (   (NE_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NE_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NE_END_DATE > c_end_date)
                             )
                        )
                 )
    OR    EXISTS (SELECT 1
                   FROM  NM_NODE_USAGES_ALL
                  WHERE  NNU_NO_NODE_ID = c_no_node_id
                   AND  (NNU_START_DATE < c_start_date
                          OR (   (NNU_END_DATE IS     NULL AND c_end_date IS NOT NULL)
                              OR (NNU_END_DATE IS NOT NULL AND c_end_date IS NOT NULL AND NNU_END_DATE > c_end_date)
                             )
                        )
                 );
--
   l_dummy          PLS_INTEGER;
   l_children_found BOOLEAN;
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
   -- NE_NO_FK_END
   -- NE_NO_FK_ST
   -- NNU_NN_FK
   OPEN  cs_children (:NEW.no_node_id, l_start_date, l_end_date);
   FETCH cs_children INTO l_dummy;
   l_children_found := cs_children%FOUND;
   CLOSE cs_children;
   IF l_children_found
    THEN
      RAISE l_has_children;
   END IF;
--
EXCEPTION
--
   WHEN l_cannot_update_start_date
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 10
                    );
     -- RAISE_APPLICATION_ERROR(-20980,'NO_START_DATE cannot be updated');
   WHEN l_start_date_gt_end_date
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 14
                    ,pi_supplementary_info => TO_CHAR(l_start_date,'DD-MON-YYYY')||' > '||TO_CHAR(l_end_date,'DD-MON-YYYY')
                    );
     -- RAISE_APPLICATION_ERROR(-20984,'NO_END_DATE cannot be before NO_START_DATE');
   WHEN l_has_children
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 13
                    );
     -- RAISE_APPLICATION_ERROR(-20983,'Record has children outside date range');
--
END nm_nodes_all_dt_trg;
/


