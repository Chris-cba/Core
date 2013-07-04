CREATE OR REPLACE PROCEDURE maintain_ntv 
                  ( pi_theme_id IN nm_themes_all.nth_theme_id%TYPE
                  , pi_mode     IN VARCHAR2)
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)maintain_ntv.prc	1.1 02/22/07
--       Module Name      : maintain_ntv.prc
--       Date into SCCS   : 07/02/22 10:13:55
--       Date fetched Out : 07/06/13 14:10:40
--       SCCS Version     : 1.1
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
IS
  l_default_vis VARCHAR2(1) := nvl(hig.get_user_or_sys_opt('DEFVISNTH'),'N');
BEGIN
--
  IF pi_mode = 'INSERTING'
  THEN
  --
    INSERT INTO nm_themes_visible (ntv_theme_id,ntv_visible)
    VALUES (pi_theme_id, l_default_vis);
  --
  ELSIF pi_mode = 'DELETING'
  THEN
  --
    DELETE nm_themes_visible
    WHERE ntv_theme_id = pi_theme_id;
  END IF;
--
END maintain_ntv;
/
