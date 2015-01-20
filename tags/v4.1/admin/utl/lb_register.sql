--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/utl/lb_register.sql-arc   1.1   Jan 20 2015 20:05:34   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_register.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 20:05:34  $
--       Date fetched Out : $Modtime:   Jan 20 2015 20:05:12  $
--       PVCS Version     : $Revision:   1.1  $
--
--       Author:  Rob Coupe
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
/*
The script below will merely throw a set of asset types into an exor system. The asset types will be registered as
Location Bridge asset types and will be mapped to a numeric asset type originating in an external system such as eB.

The hard-coded value of 1 is a network type (from the Exor Linear Types NLT_ID). The value of 1 may not exist on the
server being used so it is important that the data is editted to suit the source system. If th escript is executed without
having modified the NLT_ID parameter, th euser may elect to enter the relationship in NM_INV_NW in SQL*Plus or
use the Exor forms.

*/


DECLARE
   l_start_date   DATE;

   CURSOR c1
   IS
      SELECT t.*
        FROM TABLE (
                ptr_vc_array_type (ptr_vc (61, 'BRIDGE_AND_LARGE_CULVERT'),
                                   ptr_vc (94, 'MAST'),
                                   ptr_vc (96, 'MAST_SCHEME'),
                                   ptr_vc (105, 'RETAINING_WALL'),
                                   ptr_vc (108, 'SERVICE_CROSSING'),
                                   ptr_vc (109, 'SIGN_GANTRY'),
                                   ptr_vc (112, 'SMALL_SPAN_STRUCTURE'),
                                   ptr_vc (124, 'TUNNEL'))) t;
BEGIN
   SELECT MIN (nau_start_date) INTO l_start_date FROM nm_admin_units;

   FOR irec IN c1
   LOOP
      LB_REG.REGISTER_LB_ASSET_TYPE (irec.ptr_id,
                                     irec.ptr_value,
                                     'L' || TO_CHAR (irec.ptr_id),
                                     FALSE,
                                     1,
                                     'HIG_USER',
                                     'NORMAL',
                                     l_start_date,
                                     'C',
                                     'NONE');
   END LOOP;
END;
/

