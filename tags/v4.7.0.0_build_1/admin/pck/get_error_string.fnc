CREATE OR REPLACE function get_error_string (pi_err_id in nm_x_errors.nxe_id%TYPE ) return varchar2 is
--
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)get_error_string.fnc	1.1 08/01/01
--       Module Name      : get_error_string.fnc
--       Date into SCCS   : 01/08/01 14:56:33
--       Date fetched Out : 07/06/13 14:10:10
--       SCCS Version     : 1.1
--
--
--   Author : Rob Coupe
--
--   X-Attr Validation get_error_string function
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   cursor c1 (c_err_id nm_x_errors.nxe_id%TYPE) is
   SELECT nxe_error_class||'-'||TO_CHAR(nxe_id)||' '||nxe_error_text
    FROM  nm_x_errors
   WHERE  nxe_id = pi_err_id;
--
   retval VARCHAR2(100);
--
BEGIN
--
   OPEN  c1 (pi_err_id);
   FETCH c1 INTO retval;
   CLOSE c1;
--
   RETURN retval;
--
END get_error_string;
/

