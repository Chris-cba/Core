CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AS_TRG
AFTER DELETE
ON NM_THEMES_ALL 
REFERENCING NEW AS NEW OLD AS OLD
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_as_trg.trg	1.2 08/02/05
--       Module Name      : nm_themes_all_as_trg.trg
--       Date into SCCS   : 05/08/02 09:59:20
--       Date fetched Out : 07/06/13 17:03:36
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   Nm3sdm.g_del_theme := FALSE;
END NM_THEMES_ALL_AS_TRG;
/
