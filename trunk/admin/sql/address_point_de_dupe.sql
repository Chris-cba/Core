DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)address_point_de_dupe.sql	1.1 04/20/06
--       Module Name      : address_point_de_dupe.sql
--       Date into SCCS   : 06/04/20 14:05:18
--       Date fetched Out : 07/06/13 17:02:03
--       SCCS Version     : 1.1
--
--
--   Author : %USERNAME%
--
--    %YourObjectname%
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
CURSOR cs_hap IS
  SELECT MIN(rowid)
  FROM   hig_address_point
  GROUP BY hdp_osapr
  HAVING COUNT(rowid)>1;

TYPE t_tab_rowid IS TABLE OF rowid INDEX BY binary_integer;
l_tab_rowid t_tab_rowid;  
  
BEGIN

  OPEN cs_hap;
  FETCH cs_hap BULK COLLECT INTO l_tab_rowid;  
  CLOSE cs_hap;

  FOR i IN 1..l_tab_rowid.COUNT
  LOOP

    DELETE FROM hig_address_point
    WHERE rowid = l_tab_rowid(i);

	IF MOD(i,100) = 0 
	THEN
	  COMMIT;
	END IF;
  
  END LOOP;

  COMMIT;

END;
/
