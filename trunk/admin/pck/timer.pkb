CREATE OR REPLACE PACKAGE BODY Timer AS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)timer.pkb	1.1 07/18/06
--       Module Name      : timer.pkb
--       Date into SCCS   : 06/07/18 15:55:37
--       Date fetched Out : 07/06/13 14:14:03
--       SCCS Version     : 1.1
--
--   Author : Rob Coupe
--
--   Timer package
--
-------------------------------------------------------------------------------

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
