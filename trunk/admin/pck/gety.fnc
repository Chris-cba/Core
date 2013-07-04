CREATE OR REPLACE FUNCTION gety RETURN NUMBER IS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)gety.fnc	1.1 07/13/04
--       Module Name      : gety.fnc
--       Date into SCCS   : 04/07/13 09:35:31
--       Date fetched Out : 07/06/13 14:10:14
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
 DECLARE
  i number;
  x number;
  y number;
  cent number;
  CURSOR c1 IS 
   SELECT col1 
     FROM centsize;
 BEGIN
  FOR r IN c1 LOOP
    x:=r.col1.sdo_point.x;
    y:=r.col1.sdo_point.y;
    cent:=r.col1.sdo_point.z;
    dbms_output.put_line(x);
    dbms_output.put_line(y);
    dbms_output.put_line(cent);
  END LOOP;
  RETURN(y);
 END;
END;
/
