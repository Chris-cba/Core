create or replace view lb_dependencies as
SELECT 
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/utl/lb_dependencies.vw-arc   1.0   Aug 10 2017 15:26:58   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_dependencies.vw  $
--       Date into PVCS   : $Date:   Aug 10 2017 15:26:58  $
--       Date fetched Out : $Modtime:   Aug 10 2017 15:26:12  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Rob Coupe
--
--   Location Bridge drop script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
	 object_name, object_type, dep_sequence, ref_object, ref_type, is_cycle
       FROM (WITH r1 (object_name, object_type, dep_sequence, ref_object, ref_type)
                  AS (SELECT object_name, object_type, 1 dep_sequence, NULL, NULL
                        FROM lb_objects l1
                       WHERE NOT EXISTS
                                    (SELECT 1
                                       FROM user_dependencies, lb_objects l2
                                      WHERE     l2.object_name =
                                                   referenced_name
                                            AND l2.object_type =
                                                   referenced_type
                                            AND l1.object_name = name
                                            AND l1.object_type = TYPE
                                            ) 
             UNION ALL
             SELECT l2.object_name name, l2.object_type type, dep_sequence + 1 seq, l1.object_name ref_object, l1.object_type ref_type
               FROM r1 l1, user_dependencies, lb_objects l2
              WHERE l2.object_name = name 
              and l2.object_type = type
              and referenced_name = l1.object_name
              and referenced_type = l1.object_type
              and name != referenced_name ) cycle object_name set is_cycle to '1' default '0' 
 select * from r1 )
 /