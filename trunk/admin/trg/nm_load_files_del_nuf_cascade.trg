CREATE OR REPLACE TRIGGER nm_load_files_del_nuf_cascade
    BEFORE DELETE
     ON    nm_load_files
    FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_load_files_del_nuf_cascade.trg	1.1 04/08/04
--       Module Name      : nm_load_files_del_nuf_cascade.trg
--       Date into SCCS   : 04/04/08 02:31:41
--       Date fetched Out : 07/06/13 17:03:15
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   NM_LOAD_FILES trigger to cascade delete associated NM_UPLOAD_FILES records
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3load.delete_nuf_for_nlf (pi_nlf_id => :OLD.nlf_id);
END;
/

