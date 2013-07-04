CREATE OR REPLACE TRIGGER nm_au_sub_types_bs
BEFORE INSERT OR UPDATE
ON NM_AU_SUB_TYPES

-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_au_sub_types_bs.trg	1.1 04/21/05
--       Module Name      : nm_au_sub_types_bs.trg
--       Date into SCCS   : 05/04/21 11:15:32
--       Date fetched Out : 07/06/13 17:02:40
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
  nm3api_admin_unit.g_tab_nsty_old.DELETE;
  nm3api_admin_unit.g_tab_nsty_new.DELETE;  
END nm_au_sub_types_bs;
/
