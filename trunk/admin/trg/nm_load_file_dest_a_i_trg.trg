CREATE OR REPLACE TRIGGER nm_load_file_dest_a_i_trg
       AFTER INSERT
       ON      nm_load_file_destinations
       FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_load_file_dest_a_i_trg.trg	1.1 09/17/02
--       Module Name      : nm_load_file_dest_a_i_trg.trg
--       Date into SCCS   : 02/09/17 08:01:01
--       Date fetched Out : 07/06/13 17:03:14
--       SCCS Version     : 1.1
--
--       TRIGGER nm_load_file_dest_a_i_trg
--            AFTER INSERT
--            ON      nm_load_file_destinations
--            FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
BEGIN
   nm3load.add_columns_for_destinations (:NEW.nlfd_nlf_id,:NEW.nlfd_nld_id);
END nm_load_file_dest_a_i_trg;
/
