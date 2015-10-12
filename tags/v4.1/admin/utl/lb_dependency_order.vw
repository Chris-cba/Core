CREATE OR REPLACE FORCE VIEW LB_DEPENDENCY_ORDER
(
   OBJECT_NAME,
   OBJECT_TYPE,
   DEP_SEQUENCE
)
AS
     SELECT 
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/utl/lb_dependency_order.vw-arc   1.0   Oct 12 2015 16:28:06   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_dependency_order.vw  $
   --       Date into PVCS   : $Date:   Oct 12 2015 16:28:06  $
   --       Date fetched Out : $Modtime:   Oct 08 2015 09:00:48  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge - script for compilation in dependency order
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------	 
	 object_name, object_type, MIN (dep_sequence) dep_sequence
       FROM (WITH r1 (object_name, object_type, dep_sequence)
                  AS (SELECT object_name, object_type, 1 dep_sequence
                        FROM lb_objects l1
                       WHERE NOT EXISTS
                                    (SELECT 1
                                       FROM user_dependencies, lb_objects l2
                                      WHERE     l2.object_name =
                                                   referenced_name
                                            AND l2.object_type =
                                                   referenced_type
                                            AND l1.object_name = name
                                            AND l1.object_type = TYPE))
             SELECT object_name, object_type, dep_sequence FROM r1
             UNION ALL
             SELECT l2.object_name, l2.object_type, dep_sequence + 1
               FROM r1 l1, user_dependencies, lb_objects l2
              WHERE l2.object_name = name AND l2.object_type = TYPE)
   GROUP BY object_name, object_type;
