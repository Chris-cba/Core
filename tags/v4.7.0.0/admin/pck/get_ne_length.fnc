-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)get_ne_length.fnc	1.1 10/27/03
--       Module Name      : get_ne_length.fnc
--       Date into SCCS   : 03/10/27 11:50:36
--       Date fetched Out : 07/06/13 14:10:11
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
CREATE OR REPLACE FUNCTION get_ne_length( p_ne_id IN number ) RETURN number IS

   CURSOR cs_mem (c_ne_id_in number) IS
   SELECT SUM(nm_end_mp - nm_begin_mp)
    FROM  nm_members
   WHERE  nm_ne_id_in = c_ne_id_in;
   
   cursor cs_ne (c_ne_id in number) IS
    select ne_type,
	       ne_length
	  from nm_elements_all
	 where ne_id = c_ne_id;
--
  l_rec_ne nm_elements%ROWTYPE;
--
  l_retval number := NULL;
  l_get_bare_member_len boolean := FALSE;
  v_ne_type				nm_elements_all.ne_type%type;
--
BEGIN
--
 -- nm_debug.proc_start(g_package_name,'get_ne_length');
--
--  l_rec_ne := nm3get.get_ne (pi_ne_id           => p_ne_id
 --                           ,pi_raise_not_found => FALSE
 --                           );
  OPEN cs_ne(c_ne_id => p_ne_id);
  FETCH cs_ne INTO v_ne_type, l_retval;
  CLOSE cs_ne;
 
--
--  IF l_rec_ne.ne_id IS NOT NULL
--   THEN
     IF v_ne_type IN ('S','D')
      THEN
--        l_retval := l_rec_ne.ne_length;
          null;
     ELSE
        l_get_bare_member_len := TRUE;
     END IF;
--  ELSE
--     l_get_bare_member_len := TRUE;
 -- END IF;
--
  IF l_get_bare_member_len
   THEN
     OPEN  cs_mem (p_ne_id);
     FETCH cs_mem INTO l_retval;
     CLOSE cs_mem;
  END IF;
--
 -- nm_debug.proc_end(g_package_name,'get_ne_length');
  RETURN l_retval;
--
END get_ne_length;
/
