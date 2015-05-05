CREATE OR REPLACE FORCE VIEW V_NM_SUB_GROUP_STRUCTURE
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
select 
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_sub_group_structure.vw-arc   1.0   May 05 2015 12:10:48   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_sub_group_structure.vw  $
--       Date into PVCS   : $Date:   May 05 2015 12:10:48  $
--       Date fetched Out : $Modtime:   May 05 2015 12:09:50  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   A context driven view to expose components of a group type hierarchy, used in the generation of groups of groups layers
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
t.*, 
count(*) over (partition by parent_group_type) parent_count, 
count(*) over (partition by child_group_type) child_count 
from (
   WITH group_data (top_group_type,
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
             WHERE p.parent_group_type =
                      SYS_CONTEXT ('NM3SQL', 'PARENT_GROUP_TYPE')
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
              SEARCH DEPTH FIRST BY parent_group_type SET ord
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
     FROM group_data g ) t;
