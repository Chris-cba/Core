--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/lb_register_units.sql-arc   1.2   Jan 02 2019 11:41:04   Chris.Baugh  $
--       Module Name      : $Workfile:   lb_register_units.sql  $
--       Date into PVCS   : $Date:   Jan 02 2019 11:41:04  $
--       Date fetched Out : $Modtime:   Jan 02 2019 11:40:50  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe fro David Stow
--
--   Script for registration of unit translation metadata.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
