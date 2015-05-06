CREATE OR REPLACE FORCE VIEW V_NM_GROUP_HIERARCHY
(
   TOP_GROUP_TYPE,
   PARENT_GROUP_TYPE,
   CHILD_GROUP_TYPE,
   CHILD_TYPE,
   PARENT_NT_TYPE,
   CHILD_NT_TYPE,
   LEVL,
   ORD,
   IS_CYCLE,
   IS_LEAF,
   PARENT_COUNT,
   CHILD_COUNT
)
AS
     SELECT 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_group_hierarchy.vw-arc   1.1   May 06 2015 09:17:28   Chris.Baugh  $
--       Module Name      : $Workfile:   v_nm_group_hierarchy.vw  $
--       Date into PVCS   : $Date:   May 06 2015 09:17:28  $
--       Date fetched Out : $Modtime:   May 06 2015 09:15:44  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe
--
--   A view used to expose the full hierarchy of groups of groups of datums. 
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
 	          t."TOP_GROUP_TYPE",
            t."PARENT_GROUP_TYPE",
            t."CHILD_GROUP_TYPE",
            t."CHILD_TYPE",
            t."PARENT_NT_TYPE",
            t."CHILD_NT_TYPE",
            t."LEVL",
            t."ORD",
            t."IS_CYCLE",
            t."IS_LEAF",
            COUNT (*) OVER (PARTITION BY parent_group_type) parent_count,
            COUNT (*) OVER (PARTITION BY child_group_type) child_count
       FROM (WITH group_data (top_group_type,
                              parent_group_type,
                              child_group_type,
                              child_type,
                              parent_nt_type,
                              child_nt_type,
                              levl)
                  AS (SELECT p.parent_group_type top_group_type,
                             p.parent_group_type,
                             p.child_group_type,
                             p.child_type,
                             p.parent_nt_type,
                             p.child_nt_type,
                             p.levl
                        FROM v_nm_group_structure p
                       WHERE p.parent_group_type IN (SELECT ngt_group_type
                                                       FROM nm_group_types
                                                      WHERE     ngt_sub_group_allowed =
                                                                   'Y'
                                                            AND NOT EXISTS
                                                                       (SELECT 1
                                                                          FROM nm_group_relations
                                                                         WHERE ngr_child_group_type =
                                                                                  ngt_group_type))
                      UNION ALL
                      SELECT p.top_group_type,
                             c.parent_group_type,
                             c.child_group_type,
                             c.child_type,
                             c.parent_nt_type,
                             c.child_nt_type,
                             p.levl + 1
                        FROM v_nm_group_structure c, group_data p
                       WHERE p.child_group_type = c.parent_group_type)
                        SEARCH breadth FIRST BY parent_group_type SET ord
                        CYCLE parent_group_type SET is_cycle TO '1' DEFAULT '0'
             SELECT g."TOP_GROUP_TYPE",
                    g."PARENT_GROUP_TYPE",
                    g."CHILD_GROUP_TYPE",
                    g."CHILD_TYPE",
                    g."PARENT_NT_TYPE",
                    g."CHILD_NT_TYPE",
                    g."LEVL",
                    g."ORD",
                    g."IS_CYCLE",
                    CASE
                       WHEN (levl - LEAD (levl) OVER (ORDER BY ord)) < 0 THEN 0
                       ELSE 1
                    END
                       is_leaf
               FROM group_data g) t
   ORDER BY ord;
