CREATE OR REPLACE PACKAGE BODY lb_aggr
IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_aggr.pkb-arc   1.0   Apr 09 2015 15:24:28   Chris.Baugh  $
--       Module Name      : $Workfile:   lb_aggr.pkb  $
--       Date into SCCS   : $Date:   Apr 09 2015 15:24:28  $
--       Date fetched Out : $Modtime:   Mar 27 2015 10:30:44  $
--       SCCS Version     : $Revision:   1.0  $
--
--   Author : Ade Edwards
--
--   nm3mcp_sde body
--
--   SDE registration code taken from NM3SDE package
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  g_body_sccsid      CONSTANT VARCHAR2(2000)  := '$Revision:   1.0  $';
  g_package_name     CONSTANT VARCHAR2(30)    := 'lb_aggr';
--
-----------------------------------------------------------------------------
--
FUNCTION get_version
   RETURN VARCHAR2
IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version
   RETURN VARCHAR2
IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--

PROCEDURE refresh_route_views IS
BEGIN
  nm_debug.debug_on;
  nm_debug.debug('V_OBJ_ON_ROUTE refresh started ');
  
  NM3CTX.SET_CONTEXT('MV_ROUTE_TYPE', hig.get_sysopt('SHPJAVARTE'));
  Hig_Process_Api.Log_It(pi_Message => 'V_OBJ_ON_ROUTE refresh started - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
  
  dbms_snapshot.refresh ('V_OBJ_ON_ROUTE');
  
  nm_debug.debug('V_OBJ_ON_ROUTE refresh finished');
  Hig_Process_Api.Log_It(pi_Message => 'V_OBJ_ON_ROUTE refresh finished - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
  
  nm_debug.debug('V_OBJ_ON_ROUTE gather stats started');
  Hig_Process_Api.Log_It(pi_Message => 'V_OBJ_ON_ROUTE gather stats started - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
  
  dbms_stats.gather_table_stats (
                                Ownname     =>  Sys_Context('NM3CORE','APPLICATION_OWNER'),
                                Tabname     =>  'V_OBJ_ON_ROUTE',
                                Method_Opt  =>  'FOR ALL INDEXED COLUMNS',
                                Cascade     =>  True
                                );                                
  
  nm_debug.debug('V_OBJ_ON_ROUTE gather stats finished');
  Hig_Process_Api.Log_It(pi_Message => 'V_OBJ_ON_ROUTE gather stats finished - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );

  nm_debug.debug('V_GEOM_ON_ROUTE refresh started ');
  Hig_Process_Api.Log_It(pi_Message => 'V_GEOM_ON_ROUTE refresh started - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
  dbms_snapshot.refresh ('V_GEOM_ON_ROUTE');
  
  nm_debug.debug('V_GEOM_ON_ROUTE refresh finished');
  Hig_Process_Api.Log_It(pi_Message => 'V_GEOM_ON_ROUTE refresh finished - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
  
  nm_debug.debug('V_GEOM_ON_ROUTE gather stats started');
  Hig_Process_Api.Log_It(pi_Message => 'V_GEOM_ON_ROUTE gather stats started - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
  
  dbms_stats.gather_table_stats (
                                Ownname     =>  Sys_Context('NM3CORE','APPLICATION_OWNER'),
                                Tabname     =>  'V_GEOM_ON_ROUTE',
                                Method_Opt  =>  'FOR ALL INDEXED COLUMNS',
                                Cascade     =>  True
                                );                                
  
  nm_debug.debug('V_GEOM_ON_ROUTE gather stats finished');
  Hig_Process_Api.Log_It(pi_Message => 'V_GEOM_ON_ROUTE gather stats finished - ' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') );
  
END refresh_route_views;
--
-----------------------------------------------------------------------------
--
END lb_aggr;
/