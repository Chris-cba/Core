--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/webhelp_hig_modules.sql-arc   3.2   Apr 13 2018 13:21:48   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   webhelp_hig_modules.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 13:21:48  $
--       Date fetched Out : $Modtime:   Apr 13 2018 13:20:38  $
--       PVCS Version     : $Revision:   3.2  $
--
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
REM @(#)webhelp_hig_modules.sql	1.1 02/23/05

CREATE OR REPLACE VIEW WEBHELP_HIG_MODULES
(HMO_MODULE, HMO_TITLE, HMO_FILENAME, HMO_MODULE_TYPE, HMO_FASTPATH_OPTS, 
 HMO_FASTPATH_INVALID, HMO_USE_GRI, HMO_APPLICATION, HMO_MENU)
AS 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from nm3data.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from accdata.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from slmdata.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from pemdata31.hig_modules 
--UNION 
--select * from imdata.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from maidata31.hig_modules 
UNION 
--select * from maidata_dot.hig_modules 
--UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from nsgdata.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from stpdata.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from strdata.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from swrdata.hig_modules 
--UNION 
--select * from swrdata_w.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from tm3data.hig_modules 
UNION 
select "HMO_MODULE","HMO_TITLE","HMO_FILENAME","HMO_MODULE_TYPE","HMO_FASTPATH_OPTS","HMO_FASTPATH_INVALID","HMO_USE_GRI","HMO_APPLICATION","HMO_MENU" from ukpdata31.hig_modules;


