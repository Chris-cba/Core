--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/lb_register_units.sql-arc   1.0   Oct 19 2015 17:37:56   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_register_units.sql  $
--       Date into PVCS   : $Date:   Oct 19 2015 17:37:56  $
--       Date fetched Out : $Modtime:   Oct 19 2015 17:37:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe fro David Stow
--
--   Script for registration of unit translation metadata.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
------------------------------
BEGIN
   lb_register_unit(50, 'METRE', 1);
   lb_register_unit(236, 'KILOMETRE', 2 );
   lb_register_unit(51, 'CENTIMETRE', 3 );
   lb_register_unit(321, 'MILE', 4 );
   lb_register_unit(77, 'DEGREE', 5 );
   lb_register_unit(13, 'RADIAN', 6 );
END;
/
