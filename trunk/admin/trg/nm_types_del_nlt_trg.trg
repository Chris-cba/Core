CREATE OR REPLACE TRIGGER nm_types_del_nlt_trg
 AFTER DELETE
 ON NM_TYPES
 FOR EACH ROW
DECLARE
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_types_del_nlt_trg.trg	1.1 09/03/03
--       Module Name      : nm_types_del_nlt_trg.trg
--       Date into SCCS   : 03/09/03 14:28:17
--       Date fetched Out : 07/06/13 17:03:40
--       SCCS Version     : 1.1
--
--
--   Author : Adrian Edwards
--
--   Create NM_LINEAR_TYPES trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

  CURSOR c_get_nlt_id(cp_nlt_nt_type IN nm_types.nt_type%TYPE) IS
    SELECT nlt_id 
	  FROM nm_linear_types
	 WHERE nlt_nt_type = cp_nlt_nt_type;
	 
   v_nlt_id_recs c_get_nlt_id%ROWTYPE;

BEGIN
--
   IF DELETING THEN
     FOR v_nlt_id_recs IN c_get_nlt_id(:OLD.nt_type) LOOP
	   nm3del.del_nlt(v_nlt_id_recs.nlt_id);
	 END LOOP;
   END IF;
--
END nm_types_del_nlt_trg;
/
