CREATE OR REPLACE FORCE VIEW V_ELEMENT_HIERARCHY_DOWN
(
   LEVL,               --An indicator of the level abovethe starting element  
   START_ID,           --The starting point of the drilling up the hierarchy
   NE_ID,              --The element/group in the hierarchy
   NE_UNIQUE,          --The unique key of the element/group in the hierarchy
   NE_DESCR,           --The description f the  element/group
   NE_NT_TYPE,         --The network type of the element/group
   NE_GTY_GROUP_TYPE,  --The group type of the element/group
   NE_START_DATE,      --The start date of the element/group
   NE_END_DATE,        --The end date of the element/group
   HIER_PATH,          --The path of ids upwards from the starting element
   ORDER_BY,           --An ordering identifier (depth first)
   IS_CYCLE            --Set to '1' to indicate if there is a cycle in the hierarchy, '0' otherwise.
)
AS
 --   PVCS Identifiers :-
 --
 --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_element_hierarchy_down.vw-arc   1.0   Mar 07 2019 15:43:22   Rob.Coupe  $
 --       Module Name      : $Workfile:   v_element_hierarchy_down.vw  $
 --       Date into PVCS   : $Date:   Mar 07 2019 15:43:22  $
 --       Date fetched Out : $Modtime:   Mar 07 2019 15:41:02  $
 --       PVCS Version     : $Revision:   1.0  $
 --   Author : R.A. Coupe
 --
 --   A view to provide the group hierarchy below a known starting point
                                                                            --
 -----------------------------------------------------------------------------
      -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
 ----------------------------------------------------------------------------
   WITH group_hier (levl,
                    start_id,
                    ne_id,
                    ne_unique,
                    ne_descr,
                    ne_nt_type,
                    ne_gty_group_type,
                    ne_start_date,
                    ne_end_date,
                    hier_path)
        AS (SELECT 1,
                   ne_id,
                   ne_id,
                   ne_unique,
                   ne_descr,
                   ne_nt_type,
                   ne_gty_group_type,
                   ne_start_date,
                   ne_end_date,
                   TO_CHAR (ne_id)
              FROM nm_elements
             WHERE ne_id = SYS_CONTEXT ('NM3SQL', 'GROUP_HIERARCHY_DOWN_ID')
            UNION ALL
            SELECT levl + 1,
                   start_id,
                   nm_ne_id_of,
                   e.ne_unique,
                   e.ne_descr,
                   e.ne_nt_type,
                   e.ne_gty_group_type,
                   e.ne_start_date,
                   e.ne_end_date,
                   hier_path || '-' || TO_CHAR (nm_ne_id_of)
              FROM group_hier h, nm_members, nm_elements e
             WHERE     nm_ne_id_in = h.ne_id
                   AND nm_ne_id_of = e.ne_id
                   AND nm_type = 'G'
                   AND levl <
                          TO_NUMBER (
                             NVL (SYS_CONTEXT ('NM3SQL', 'HIER_LEVEL_STOP'),
                                  levl + 1)))
              SEARCH DEPTH FIRST BY ne_id SET order_by
              CYCLE ne_id SET cycle TO '1' DEFAULT '0'
   SELECT "LEVL",
          "START_ID",
          "NE_ID",
          "NE_UNIQUE",
          "NE_DESCR",
          "NE_NT_TYPE",
          "NE_GTY_GROUP_TYPE",
          "NE_START_DATE",
          "NE_END_DATE",
          "HIER_PATH",
          "ORDER_BY",
          "CYCLE"
     FROM group_hier;
