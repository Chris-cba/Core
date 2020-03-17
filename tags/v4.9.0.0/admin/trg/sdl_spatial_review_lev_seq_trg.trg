-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_spatial_review_lev_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:40   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_spatial_review_lev_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:40  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:53:40  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_SPATIAL_REVIEW_LEVELS'
CREATE OR REPLACE TRIGGER sdl_spatial_review_lev_seq_trg
  BEFORE INSERT ON sdl_spatial_review_levels
  FOR EACH ROW
BEGIN
  IF :NEW.ssrl_id IS NULL
  THEN
    :NEW.ssrl_id := ssrl_id_seq.NEXTVAL;
  END IF;
END sdl_spatial_review_lev_seq_trg;
/
