CREATE OR REPLACE TRIGGER nm_points_sdo
 BEFORE INSERT OR UPDATE OR DELETE
 ON nm_points
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_points_sdo.trg-arc   2.3   Apr 13 2018 11:06:38   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_points_sdo.trg  $
--       Date into SCCS   : $Date:   Apr 13 2018 11:06:38  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:00:30  $
--       SCCS Version     : $Revision:   2.3  $
--       Based on 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3net.bypass_nm_points_trgs
  Then 
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
  End If;
END;
/
