DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_address_remove_orphans.sql	1.1 04/20/06
--       Module Name      : hig_address_remove_orphans.sql
--       Date into SCCS   : 06/04/20 14:09:56
--       Date fetched Out : 07/06/13 17:02:05
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
CURSOR cs_had IS
  SELECT hig_address.rowid
  FROM 	 hig_address,
  	   	 hig_contact_address
  WHERE  had_id = hca_had_id(+)
  AND	 hca_had_id IS NULL;

TYPE tab_rowid IS TABLE OF rowid INDEX BY BINARY_INTEGER;
l_tab_rowid tab_rowid;

BEGIN

  OPEN cs_had;
  FETCH cs_had BULK COLLECT INTO l_tab_rowid;
  CLOSE cs_had;

  FOR i IN 1..l_tab_rowid.COUNT 
  LOOP -- hig address 'orphans'
 
	-- delete the orphan
	DELETE FROM hig_address
	WHERE rowid = l_tab_rowid(i);

	IF MOD(i,100) = 0
	THEN
	  COMMIT;
	END IF;
  
  END LOOP;

  COMMIT;
 
END;
/
