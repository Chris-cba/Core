CREATE OR REPLACE TRIGGER NM_THEMES_ALL_BS_TRG
BEFORE DELETE
ON NM_THEMES_ALL 
REFERENCING NEW AS NEW OLD AS OLD
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_themes_all_bs_trg.trg	1.2 08/02/05
--       Module Name      : nm_themes_all_bs_trg.trg
--       Date into SCCS   : 05/08/02 09:59:55
--       Date fetched Out : 07/06/13 17:03:37
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
   Nm3sdm.g_del_theme := TRUE;
END NM_THEMES_ALL_BS_TRG;
/
