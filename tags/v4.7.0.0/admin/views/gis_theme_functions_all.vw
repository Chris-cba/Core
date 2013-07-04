CREATE or replace force view GIS_THEME_FUNCTIONS_ALL
( GTF_GT_THEME_ID,
  GTF_HMO_MODULE,
  GTF_PARAMETER,
  GTF_MENU_OPTION,
  GTF_SEEN_IN_GIS )
as select 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)gis_theme_functions_all.vw	1.1 10/28/03
--       Module Name      : gis_theme_functions_all.vw
--       Date into SCCS   : 03/10/28 15:11:36
--       Date fetched Out : 07/06/13 17:07:58
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  NTF_NTH_THEME_ID,
  NTF_HMO_MODULE,
  NTF_PARAMETER,
  NTF_MENU_OPTION,
  NTF_SEEN_IN_GIS
from nm_theme_functions_all;
