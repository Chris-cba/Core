CREATE OR REPLACE PACKAGE BODY Timer AS
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/timer.pkb-arc   2.3   May 10 2018 11:27:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   timer.pkb  $
--       Date into SCCS   : $Date:   May 10 2018 11:27:16  $
--       Date fetched Out : $Modtime:   May 10 2018 11:25:54  $
--       SCCS Version     : $Revision:   2.3  $
--
--
--   Author : Rob Coupe
--
--   Timer package
-------------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.3  $';

  g_package_name CONSTANT varchar2(30) := 'timer';
  
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------

PROCEDURE set_timer IS
BEGIN

  g_time_values := Nm3array.init_ptr_num_array;
  g_time_text   := Nm3array.init_ptr_vc_array;
  g_id          := 1;
  
  g_start       := DBMS_UTILITY.GET_TIME;

  g_time_values.pa(g_id) := ptr_num(g_id, 0);
  
  g_time_text.pa(g_id)   := ptr_vc(g_id, 'Instantiation of timer at time '||TO_CHAR(g_start));
  
END;    
 
PROCEDURE set_time  ( p_text IN VARCHAR2 ) IS
BEGIN
  g_time_values.pa.EXTEND;
  g_time_text.pa.EXTEND;
  g_id := g_id+1;
  g_time_values.pa(g_id) := ptr_num( g_id, DBMS_UTILITY.GET_TIME - g_start - g_time_values.pa(g_id-1).ptr_value);
  g_time_text.pa( g_id ) := ptr_vc( g_id, p_text );
--  debug_timer;
END;
  
FUNCTION  get_timer_values RETURN ptr_num_array IS
BEGIN
  RETURN g_time_values;
END;
  
FUNCTION  get_timer_text   RETURN ptr_vc_array IS
BEGIN
  RETURN g_time_text;
END;  

PROCEDURE debug_timer IS
BEGIN
  Nm_Debug.DEBUG('Timer '||TO_CHAR(g_id)||' started at '||TO_CHAR(g_start)||' now at '||TO_CHAR(DBMS_UTILITY.GET_TIME)||' increment '||
                 TO_CHAR( g_time_values.pa(g_id).ptr_value)||' - '||g_time_text.pa(g_id).ptr_value);
END;
               
END;
/
