create or replace FUNCTION get_node_name ( p_no_id IN number ) RETURN varchar2 IS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)get_node_name.fnc	1.1 09/03/03
--       Module Name      : get_node_name.fnc
--       Date into SCCS   : 03/09/03 14:38:11
--       Date fetched Out : 07/06/13 14:10:11
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Originally taken from 
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   RETURN nm3get.get_no (pi_no_node_id      => p_no_id
                        ,pi_raise_not_found => FALSE
                        ).no_node_name;
END get_node_name;
/

