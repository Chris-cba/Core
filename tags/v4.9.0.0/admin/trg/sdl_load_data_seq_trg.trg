-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_load_data_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:34   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_load_data_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:34  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:51:26  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_LOAD_DATA' 
CREATE OR REPLACE TRIGGER sdl_load_data_seq_trg
  BEFORE INSERT ON sdl_load_data
  FOR EACH ROW
BEGIN
  IF :NEW.sld_key IS NULL 
  THEN
    :NEW.sld_key:= sld_key_seq.NEXTVAL;
  END IF;
END sdl_load_data_seq_trg;
/
