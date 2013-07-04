CREATE OR REPLACE TRIGGER nm_types_del_nlt_trg_as
   AFTER DELETE
   ON nm_types
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_types_del_nlt_trg_as.trg	1.2 04/20/06
--       Module Name      : nm_types_del_nlt_trg_as.trg
--       Date into SCCS   : 06/04/20 10:38:55
--       Date fetched Out : 07/06/13 17:03:41
--       SCCS Version     : 1.2
--
--
--   Author : Sarah Scanlon
--
--    Create NM_LINEAR_TYPE trigger
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
--begin deleting records from table nm_linear_types which are linked to the
--record from nm_types which is being deleted
   nm3net.process_table_nt;
END nm_types_del_nlt_trg_as;
/
