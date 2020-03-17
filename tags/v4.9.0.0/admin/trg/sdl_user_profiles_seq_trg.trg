-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_user_profiles_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:40   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_user_profiles_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:40  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:49:38  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_USER_PROFILES'
CREATE OR REPLACE TRIGGER sdl_user_profiles_seq_trg
  BEFORE INSERT ON sdl_user_profiles
  FOR EACH ROW
BEGIN
  IF :NEW.sup_id IS NULL
  THEN
    :NEW.sup_id := sup_id_seq.NEXTVAL;
  END IF;
END sdl_user_profiles_seq_trg;
/
