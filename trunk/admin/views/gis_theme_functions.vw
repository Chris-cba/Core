CREATE OR REPLACE FORCE VIEW gis_theme_functions AS
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)gis_theme_functions.vw	1.2 12/03/03
--       Module Name      : gis_theme_functions.vw
--       Date into SCCS   : 03/12/03 10:01:17
--       Date fetched Out : 07/06/13 17:07:58
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       gtf_gt_theme_id
      ,gtf_hmo_module
      ,gtf_parameter
      ,gtf_menu_option
 FROM  gis_theme_functions_all
WHERE  gtf_seen_in_gis  = 'Y'
/
