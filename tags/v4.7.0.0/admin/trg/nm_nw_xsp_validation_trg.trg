CREATE OR REPLACE TRIGGER nm_xsp_validation_trg
       BEFORE  INSERT OR UPDATE OF nwx_x_sect
       ON      nm_nw_xsp
       FOR EACH ROW
BEGIN
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_nw_xsp_validation_trg.trg	1.1 04/15/04
--       Module Name      : nm_nw_xsp_validation_trg.trg
--       Date into SCCS   : 04/04/15 11:52:16
--       Date fetched Out : 07/06/13 17:03:32
--       SCCS Version     : 1.1
--
--       TRIGGER nm_nw_xsp_validation_trg
--         BEFORE  INSERT OR UPDATE OF nwx_x_sect
--         ON      nm_nw_xsp
--         FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   IF NOT nm3flx.is_string_valid_for_object ('_'||:NEW.nwx_x_sect) -- Put the _ on the front because numeric only is ok in this case
    THEN
      RAISE_APPLICATION_ERROR(-20001,'"'||:NEW.nwx_x_sect||'" is not a valid name for a XSP. Use only alphanumeric and _ chars');
   END IF;
--
END nm_nw_xsp_validation_trg;
/
