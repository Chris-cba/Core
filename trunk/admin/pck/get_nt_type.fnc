-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)get_nt_type.fnc	1.1 06/23/05
--       Module Name      : get_nt_type.fnc
--       Date into SCCS   : 05/06/23 16:09:52
--       Date fetched Out : 07/06/13 14:10:12
--       SCCS Version     : 1.1
--
-- Translation View function
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

CREATE OR REPLACE function get_nt_type (pi_ne_id IN nm_elements_all.ne_id%TYPE) RETURN nm_types.nt_type%TYPE IS
BEGIN
  RETURN(nm3net.get_nt_type(pi_ne_id));
END get_nt_type;
/

