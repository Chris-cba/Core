--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_install.sql-arc   1.0   Jan 14 2015 15:57:26   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_install.sql  $
--       Date into PVCS   : $Date:   Jan 14 2015 15:57:26  $
--       Date fetched Out : $Modtime:   Jan 14 2015 15:56:56  $
--       PVCS Version     : $Revision:   1.0  $
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

start LB_GET.pkh;
start LB_LOAD.pkh;
start LB_LOC.pkh;
start LB_OPS.pkh;
start LB_PATH.pkh;
start LB_REF.pkh;
start LB_REG.pkh;
start LB_PATH_REG.pkh;

start lb_views.sql;


start get_lb_rpt_d_tab.prc;
start get_lb_rpt_r_tab.prc;
start create_nlt_geometry_view.prc;

begin
CREATE_NLT_GEOMETRY_VIEW;
end;
/


start LB_GET.pkb;
start LB_LOAD.pkb;
start LB_LOC.pkb;
start LB_OPS.pkb
start LB_PATH.pkb;
start LB_REF.pkb;
start LB_REG.pkb;
start LB_PATH_REG.pkb;

