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
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/utl/lb_dependency_order.vw-arc   1.1   Aug 10 2017 15:29:08   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_dependency_order.vw  $
   --       Date into PVCS   : $Date:   Aug 10 2017 15:29:08  $
   --       Date fetched Out : $Modtime:   Aug 10 2017 15:28:20  $
   --       PVCS Version     : $Revision:   1.1  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge - script for compilation in dependency order
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------	
 object_name, object_type, min(dep_sequence) dep_sequence
 from lb_dependencies
 group by object_name, object_type
 /