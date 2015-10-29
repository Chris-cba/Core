--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/lb_register_units.sql-arc   1.1   Oct 29 2015 07:20:38   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_register_units.sql  $
--       Date into PVCS   : $Date:   Oct 29 2015 07:20:38  $
--       Date fetched Out : $Modtime:   Oct 29 2015 07:21:06  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe fro David Stow
--
--   Script for registration of unit translation metadata.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
------------------------------
BEGIN
   lb_reg.register_unit(50, 'METRE', 1);
   lb_reg.register_unit(236, 'KILOMETRE', 2 );
   lb_reg.register_unit(51, 'CENTIMETRE', 3 );
   lb_reg.register_unit(321, 'MILE', 4 );
   lb_reg.register_unit(77, 'DEGREE', 5 );
   lb_reg.register_unit(13, 'RADIAN', 6 );
END;
/
