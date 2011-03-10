CREATE OR REPLACE FORCE VIEW gis_themes AS
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)gis_themes.vw	1.2 03/24/05
--       Module Name      : gis_themes.vw
--       Date into SCCS   : 05/03/24 16:13:56
--       Date fetched Out : 07/06/13 17:07:59
--       SCCS Version     : 1.2
--
--   gis_themes View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
       *
 FROM  gis_themes_all
WHERE EXISTS (SELECT 1
               FROM  gis_theme_roles
                    ,hig_user_roles
               WHERE gthr_theme_id   = gt_theme_id
                AND  hur_username    = USER
                AND  gthr_role       = hur_role 
             )
/
