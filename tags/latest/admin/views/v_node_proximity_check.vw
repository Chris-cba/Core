CREATE OR REPLACE FORCE VIEW v_node_proximity_check AS
SELECT
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_node_proximity_check.vw-arc   1.0   Mar 12 2015 13:51:10   Chris.Baugh  $
--       Module Name      : $Workfile:   v_node_proximity_check.vw  $
--       Date into PVCS   : $Date:   Mar 12 2015 13:51:10  $
--       Date fetched Out : $Modtime:   Mar 11 2015 10:42:58  $
--       Version          : $Revision:   1.0  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       ROW_NUMBER () OVER (ORDER BY ne_id, distance) objectid,
       ROW_NUMBER () OVER (PARTITION BY ne_id ORDER BY distance) rn,
       ne_id,
       no_node_id,
       no_node_name,
       no_descr,
       distance,
       npl_location
  FROM (SELECT ne_id,
               no_node_id,
               no_node_name,
               no_descr,
               sdo_nn_distance (1) distance,
               unit_M,
               npl_location
          FROM (WITH geom_data
                  AS  (SELECT ne_id,
                              CASE NVL(t.elem_shape.sdo_srid, -99) 
                                WHEN -99 THEN 
                                  NULL
                                ELSE 
                                  ' UNIT=M '
                              END unit_M, 
                              elem_shape
                        FROM ( SELECT ne_id, 
                                      CASE NVL(ne_gty_group_type, '£$%^') 
                                        WHEN '£$%^' 
                                          THEN 
                                            nm3sdo.get_layer_element_geometry(ne_id)
                                        ELSE 
                                            nm3sdo.get_route_shape (ne_id) 
                                      END elem_shape 
                                 FROM nm_elements  
                                WHERE ne_id = TO_NUMBER(SYS_CONTEXT('NM3SQL', 'PROX_NE_ID')))t ) 
              SELECT ne_id,
                     n.no_node_id,
                     n.no_node_name,
                     no_descr,
                     unit_M,
                     sdo_nn_distance (1) distance,
                     npl_location,
                     sdo_lrs.geom_segment_end_measure (sdo_lrs.project_pt(elem_shape,
                                                       npl_location,
                                                       0.005))       proj_measure,
                     sdo_lrs.geom_segment_end_measure (elem_shape)   end_measure,
                     sdo_lrs.geom_segment_start_measure (elem_shape) start_measure
                FROM nm_nodes n, 
                     nm_point_locations p, 
                     geom_data g
               WHERE sdo_nn (p.npl_location,
                             elem_shape, 
                             'distance='||NVL (hig.get_sysopt ('SDOPROXTOL'), 50)||unit_M||' sdo_batch_size = 50',1) = 'TRUE'
                             AND npl_id = no_np_id )
         WHERE ABS (proj_measure - start_measure) > TO_NUMBER (NVL (hig.get_sysopt ('SDOMINPROJ'), 0.5))
           AND ABS (end_measure  - proj_measure)  > TO_NUMBER (NVL (hig.get_sysopt ('SDOMINPROJ'), 0.5))
      ORDER BY distance)
/              
