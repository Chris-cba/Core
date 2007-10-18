CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AI_TRG
AFTER INSERT
ON NM_THEMES_ALL 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/trg/nm_themes_all_ai_trg.trg-arc   2.1   Oct 18 2007 15:56:38   aedwards  $
-- Module Name : $Workfile:   nm_themes_all_ai_trg.trg  $
-- Date into PVCS : $Date:   Oct 18 2007 15:56:38  $
-- Date fetched Out : $Modtime:   Oct 18 2007 15:55:32  $
-- PVCS Version : $Revision:   2.1  $
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
