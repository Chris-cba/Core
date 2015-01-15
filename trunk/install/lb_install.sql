--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_install.sql-arc   1.1   Jan 15 2015 21:47:46   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_install.sql  $
--       Date into PVCS   : $Date:   Jan 15 2015 21:47:46  $
--       Date fetched Out : $Modtime:   Jan 15 2015 21:24:18  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe
--
--   Script for initial installation of LB - to be replaced by formal product 
--   install and upgrade scripts
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

/* LB Install file */

--Need to upgrade int_array

drop type int_array force;
--
start int_array.tyh;
start int_array.tyb;

start lb_data_types.sql;

start lb_ddl.sql;

start ..\admin\pck\LB_GET.pkh;
start ..\admin\pck\LB_LOAD.pkh;
start ..\admin\pck\LB_LOC.pkh;
start ..\admin\pck\LB_OPS.pkh;
start ..\admin\pck\LB_PATH.pkh;
start ..\admin\pck\LB_REF.pkh;
start ..\admin\pck\LB_REG.pkh;
start ..\admin\pck\LB_PATH_REG.pkh;

start lb_views.sql;


--start ..\admin\pck\get_lb_rpt_d_tab.prc;
--start ..\admin\pck\get_lb_rpt_r_tab.prc;
start ..\admin\pck\create_nlt_geometry_view.prc;

begin
CREATE_NLT_GEOMETRY_VIEW;
end;
/

start ..\admin\pck\LB_PATH_REG.pkb;
start ..\admin\pck\LB_OPS.pkb
start ..\admin\pck\LB_REG.pkb;
start ..\admin\pck\LB_REF.pkb;
start ..\admin\pck\LB_GET.pkb;
start ..\admin\pck\LB_LOAD.pkb;
start ..\admin\pck\LB_LOC.pkb;
start ..\admin\pck\LB_PATH.pkb;

