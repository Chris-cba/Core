CREATE OR REPLACE FUNCTION get_dim_element (
   p_index    IN   INTEGER,
   dimarray   IN   MDSYS.sdo_dim_array
)
   RETURN MDSYS.sdo_dim_element
IS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)get_dim_element.fnc	1.1 02/01/06
--       Module Name      : get_dim_element.fnc
--       Date into SCCS   : 06/02/01 14:23:05
--       Date fetched Out : 07/06/13 14:10:10
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   RETURN dimarray (p_index);
END;
/
