CREATE OR REPLACE FORCE VIEW V_GROUP_INSTANCE_HIERARCHY
(
   DIRECTION,
   START_NT_TYPE,
   START_GROUP_TYPE,
   NT_TYPE,
   GROUP_TYPE
)
AS
   SELECT                                             --   PVCS Identifiers :-
                                                                            --
 --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/views/v_group_instance_hirarchy.vw-arc   1.0   Nov 30 2018 13:35:10   Rob.Coupe  $
       --       Module Name      : $Workfile:   v_group_instance_hirarchy.vw  $
                  --       Date into PVCS   : $Date:   Nov 30 2018 13:35:10  $
               --       Date fetched Out : $Modtime:   Nov 30 2018 13:33:36  $
                               --       PVCS Version     : $Revision:   1.0  $
                                                                            --
                                                      --   Author : R.A. Coupe
                                                                            --
 --   View to see all parent and child types for a specified NT/GTY pair
                                                                            --
 -----------------------------------------------------------------------------
      -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
  ----------------------------------------------------------------------------
   --
         'DOWN' direction,
          start_nt_type,
          start_group_type,
          nt_type,
          group_type                                              --, ngt_name
     FROM (WITH hier (start_nt_type,
                      start_group_type,
                      parent_nt_type,
                      parent_group_type,
                      child_nt_type,
                      child_group_type,
                      levl)
                AS (SELECT parent_nt_type start_nt_type,
                           parent_group_type start_group_type,
                           parent_nt_type,
                           parent_group_type,
                           child_nt_type,
                           child_group_type,
                           1 levl
                      FROM v_nm_group_structure
                    UNION ALL
                    SELECT p.start_nt_type,
                           p.start_group_type,
                           c.parent_nt_type,
                           c.parent_group_type,
                           c.child_nt_type,
                           c.child_group_type,
                           p.levl + 1
                      FROM hier p, v_nm_group_structure c
                     WHERE p.child_nt_type = c.parent_nt_type)
             SELECT start_nt_type,
                    start_group_type,
                    child_nt_type nt_type,
                    child_group_type group_type
               FROM hier
           --where start_group_type = 'AR20'
           --and start_nt_type = 'AR20'
           GROUP BY start_nt_type,
                    start_group_type,
                    child_nt_type,
                    child_group_type)
   UNION ALL
   (SELECT 'UP',
           start_nt_type,
           start_group_type,
           nt_type,
           group_type
      FROM (WITH hier (start_nt_type,
                       start_group_type,
                       parent_nt_type,
                       parent_group_type,
                       child_nt_type,
                       child_group_type,
                       levl)
                 AS (SELECT child_nt_type start_nt_type,
                            child_group_type start_group_type,
                            parent_nt_type,
                            parent_group_type,
                            child_nt_type,
                            child_group_type,
                            1 levl
                       FROM v_nm_group_structure
                     UNION ALL
                     SELECT p.start_nt_type,
                            p.start_group_type,
                            c.parent_nt_type,
                            c.parent_group_type,
                            c.child_nt_type,
                            c.child_group_type,
                            p.levl + 1
                       FROM hier p, v_nm_group_structure c
                      WHERE p.parent_nt_type = c.child_nt_type)
              SELECT start_nt_type,
                     start_group_type,
                     parent_nt_type nt_type,
                     parent_group_type group_type
                FROM hier
            --where start_group_type = 'AR20'
            --and start_nt_type = 'AR20'
            GROUP BY start_nt_type,
                     start_group_type,
                     parent_nt_type,
                     parent_group_type))
/					 
