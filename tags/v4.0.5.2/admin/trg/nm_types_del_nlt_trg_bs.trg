CREATE OR REPLACE TRIGGER nm_types_del_nlt_trg_bs
   BEFORE DELETE
   ON nm_types
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_types_del_nlt_trg_bs.trg	1.2 04/20/06
--       Module Name      : nm_types_del_nlt_trg_bs.trg
--       Date into SCCS   : 06/04/20 10:37:06
--       Date fetched Out : 07/06/13 17:03:42
--       SCCS Version     : 1.2
--
--
--   Author : Sarah Scanlon
--
--    Create NM_LINEAR_TYPE trigger
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
BEGIN
   --remove any left over records in the temporary table
   --before new data is called into the table
   nm3net.g_tab_nt.DELETE;
END nm_types_del_nlt_trg_bs;
/
