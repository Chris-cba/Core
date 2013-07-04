CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AI_TRG
AFTER INSERT
ON NM_THEMES_ALL 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/trg/nm_themes_all_ai_trg.trg-arc   2.2   Jul 04 2013 09:54:30   James.Wadsworth  $
-- Module Name : $Workfile:   nm_themes_all_ai_trg.trg  $
-- Date into PVCS : $Date:   Jul 04 2013 09:54:30  $
-- Date fetched Out : $Modtime:   Jul 04 2013 09:40:06  $
-- PVCS Version : $Revision:   2.2  $
-- Based on SCCS version :
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  IF INSERTING 
  THEN 
    nm3sdm.maintain_ntv (:NEW.nth_theme_id,'INSERTING');
  END IF;
END NM_THEMES_ALL_AI_TRG;
/
