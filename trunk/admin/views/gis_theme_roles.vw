create or replace Force view gis_theme_roles
( GTHR_THEME_ID,
  GTHR_ROLE,
  GTHR_MODE )
as select   
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)gis_theme_roles.vw	1.1 10/28/03
--       Module Name      : gis_theme_roles.vw
--       Date into SCCS   : 03/10/28 15:12:05
--       Date fetched Out : 07/06/13 17:07:59
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  NTHR_THEME_ID,
  NTHR_ROLE,
  NTHR_MODE 
from nm_theme_roles;
