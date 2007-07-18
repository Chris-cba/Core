CREATE OR REPLACE TRIGGER nm_points_sdo
 BEFORE INSERT OR UPDATE OR DELETE
 ON nm_points
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_points_sdo.trg	1.2 05/21/04
--       Module Name      : nm_points_sdo.trg
--       Date into SCCS   : 04/05/21 15:25:06
--       Date fetched Out : 07/06/13 17:03:34
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
BEGIN
--
  DECLARE
    e_ora_20001 EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_ora_20001, -20001);
    
  BEGIN
    nm3sdo.set_point_srid;
    
    nm3sdo.g_sdo_layer_available := TRUE;
    
  EXCEPTION
    WHEN e_ora_20001
    THEN
      IF hig.check_last_ner(pi_appl => nm3type.c_hig
                           ,pi_id   => 197)
      THEN
        --SDO Metadata layer could not be found. Set flag to bypass further
        --processing for this statement
        nm3sdo.g_sdo_layer_available := FALSE;
      ELSE
        RAISE;
      END IF;
   END;
END;
/
