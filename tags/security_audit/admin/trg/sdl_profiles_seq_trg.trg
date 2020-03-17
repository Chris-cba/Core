-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_profiles_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:38   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_profiles_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:38  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:48:48  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_PROFILES'
CREATE OR REPLACE TRIGGER sdl_profiles_seq_trg
  BEFORE INSERT ON sdl_profiles
  FOR EACH ROW
BEGIN
  IF :NEW.sp_id IS NULL
  THEN
    :NEW.sp_id := sp_id_seq.NEXTVAL;
  END IF;
END sdl_profiles_seq_trg;
/
