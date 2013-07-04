CREATE OR REPLACE FUNCTION getcent RETURN NUMBER IS
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)getcent.fnc	1.1 07/13/04
--       Module Name      : getcent.fnc
--       Date into SCCS   : 04/07/13 09:34:26
--       Date fetched Out : 07/06/13 14:10:13
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  DECLARE
    x number;
    y number;
    cent number;
    cursor c1 is 
      select col1 
        from centsize;
  BEGIN
    FOR r IN c1 LOOP
      x:=r.col1.sdo_point.x;
      y:=r.col1.sdo_point.y;
      cent:=r.col1.sdo_point.z;
      dbms_output.put_line(x);
      dbms_output.put_line(y);
      dbms_output.put_line(cent);
    END LOOP;
   RETURN(cent);
 END;
END;
/
