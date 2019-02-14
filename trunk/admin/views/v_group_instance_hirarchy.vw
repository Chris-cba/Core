          --   PVCS Identifiers :-
          --
          --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_group_instance_hirarchy.vw-arc   1.1   Feb 14 2019 12:19:12   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_group_instance_hirarchy.vw  $
          --       Date into PVCS   : $Date:   Feb 14 2019 12:19:12  $
          --       Date fetched Out : $Modtime:   Feb 14 2019 12:18:40  $
          --       PVCS Version     : $Revision:   1.1  $
          --
          --   Author : R.A. Coupe
          --
          --   View to see all parent and child types for a specified NT/GTY pair
          --
          --   DIRECTION,           --'An indicator as to whether the target group type is above or below the start group type in the hierarchy';
          --   START_NT_TYPE,       --'The starting network type';
          --   START_GROUP_TYPE,    --'The starting group type';
          --   NT_TYPE,             --'The target network type ';
          --   GROUP_TYPE           --'The target group type';
          --
          --
          -----------------------------------------------------------------------------
          -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
          ----------------------------------------------------------------------------
          --
CREATE OR REPLACE FORCE VIEW V_GROUP_INSTANCE_HIERARCHY
(
   DIRECTION,
   START_NT_TYPE,
   START_GROUP_TYPE,
   NT_TYPE,
   GROUP_TYPE
)
AS
   SELECT                                                                   --
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
                     parent_group_type));
/


COMMENT ON COLUMN V_GROUP_INSTANCE_HIERARCHY.direction IS
   'An indicator as to whether the target group type is above or below the start group type in the hierarchy';

COMMENT ON COLUMN V_GROUP_INSTANCE_HIERARCHY.start_nt_type IS
   'The starting network type';

COMMENT ON COLUMN V_GROUP_INSTANCE_HIERARCHY.start_group_type IS
   'The starting group type';

COMMENT ON COLUMN V_GROUP_INSTANCE_HIERARCHY.nt_type IS
   'The target network type ';

COMMENT ON COLUMN V_GROUP_INSTANCE_HIERARCHY.group_type IS
   'The target group type';
   