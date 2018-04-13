CREATE OR REPLACE TRIGGER NM_THEMES_ALL_AI_TRG
AFTER INSERT
ON NM_THEMES_ALL 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_themes_all_ai_trg.trg-arc   2.3   Apr 13 2018 11:06:38   Gaurav.Gaurkar  $
-- Module Name : $Workfile:   nm_themes_all_ai_trg.trg  $
-- Date into PVCS : $Date:   Apr 13 2018 11:06:38  $
-- Date fetched Out : $Modtime:   Apr 13 2018 11:01:50  $
-- PVCS Version : $Revision:   2.3  $
-- Based on SCCS version :
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  IF INSERTING 
  THEN 
    nm3sdm.maintain_ntv (:NEW.nth_theme_id,'INSERTING');
  END IF;
END NM_THEMES_ALL_AI_TRG;
/
