CREATE OR REPLACE TRIGGER nm_xsp_validation_trg
       BEFORE  INSERT OR UPDATE OF nwx_x_sect
       ON      nm_xsp
       FOR EACH ROW
BEGIN
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_xsp_validation_trg.trg	1.2 05/28/02
--       Module Name      : nm_xsp_validation_trg.trg
--       Date into SCCS   : 02/05/28 14:44:35
--       Date fetched Out : 07/06/13 17:03:44
--       SCCS Version     : 1.2
--
--       TRIGGER nm_xsp_validation_trg
--         BEFORE  INSERT OR UPDATE OF nwx_x_sect
--         ON      nm_xsp
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
END nm_xsp_validation_trg;
/
