CREATE OR REPLACE TRIGGER nm_au_sub_types_as
AFTER INSERT OR UPDATE
ON NM_AU_SUB_TYPES
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_au_sub_types_as.trg	1.1 04/21/05
--       Module Name      : nm_au_sub_types_as.trg
--       Date into SCCS   : 05/04/21 11:23:30
--       Date fetched Out : 07/06/13 17:02:39
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3api_admin_unit.process_g_tab_nsty;
END nm_au_sub_types_as;
/

