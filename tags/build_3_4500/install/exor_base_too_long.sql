-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)exor_base_too_long.sql	1.1 04/19/04
--       Module Name      : exor_base_too_long.sql
--       Date into SCCS   : 04/04/19 14:46:53
--       Date fetched Out : 07/06/13 13:57:01
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
undefine leave_it
col leave_it new_value leave_it noprint
set term on
prompt
prompt &exor_base was specified as the exor base location.
prompt
prompt Value entered for exor base is greater than the permitted length of 30 characters
prompt
prompt Please re-run the script and enter a valid exor base value.
prompt
prompt
prompt
accept leave_it prompt "Press RETURN to exit SQL*PLUS"
prompt
exit;
