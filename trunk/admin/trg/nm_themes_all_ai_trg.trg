CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AI_TRG
AFTER DELETE
ON NM_THEMES_ALL 
REFERENCING NEW AS NEW OLD AS OLD
DECLARE
-----------------------------------------------------------------------------
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/trg/nm_themes_all_ai_trg.trg-arc   2.0   Oct 02 2007 11:15:16   jwadsworth  $
-- Module Name : $Workfile:   nm_themes_all_ai_trg.trg  $
-- Date into PVCS : $Date:   Oct 02 2007 11:15:16  $
-- Date fetched Out : $Modtime:   Oct 02 2007 10:21:56  $
-- PVCS Version : $Revision:   2.0  $
-- Based on SCCS version :
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
BEGIN
  IF INSERTING 
  THEN 
    nm3sdm.maintain_ntv (:NEW.nth_theme_id,'INSERTING');
  END IF;
END NM_THEMES_ALL_AI_TRG;
/
