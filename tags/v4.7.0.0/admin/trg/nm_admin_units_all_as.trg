CREATE OR REPLACE TRIGGER nm_admin_units_all_as
AFTER DELETE OR INSERT OR UPDATE
ON NM_ADMIN_UNITS_ALL

-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_admin_units_all_as.trg	1.3 11/24/05
--       Module Name      : nm_admin_units_all_as.trg
--       Date into SCCS   : 05/11/24 09:24:19
--       Date fetched Out : 07/06/13 17:02:37
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

  nm3api_admin_unit.process_g_tab_nau;
  
END nm_admin_units_all_as;
/
