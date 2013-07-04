CREATE OR REPLACE TRIGGER nm_admin_units_all_bs
BEFORE DELETE OR INSERT OR UPDATE
ON NM_ADMIN_UNITS_ALL

-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_admin_units_all_bs.trg	1.3 11/24/05
--       Module Name      : nm_admin_units_all_bs.trg
--       Date into SCCS   : 05/11/24 09:25:13
--       Date fetched Out : 07/06/13 17:02:38
--       SCCS Version     : 1.3
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------


BEGIN
  nm3api_admin_unit.g_tab_nau_old.DELETE;
  nm3api_admin_unit.g_tab_nau_new.DELETE;  
  nm3api_admin_unit.g_tab_nau_actions.DELETE;
END nm_admin_units_all_bs;
/
