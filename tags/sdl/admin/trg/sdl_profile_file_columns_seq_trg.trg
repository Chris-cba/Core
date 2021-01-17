-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_profile_file_columns_seq_trg.trg-arc   1.0   Jan 17 2021 11:33:56   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_profile_file_columns_seq_trg.trg  $
--       Date into PVCS   : $Date:   Jan 17 2021 11:33:56  $
--       Date fetched Out : $Modtime:   Jan 17 2021 11:29:42  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_PROFILE_FILE_COLUMNS'
CREATE OR REPLACE TRIGGER sdl_profile_file_columns_seq_trg
  BEFORE INSERT ON sdl_profile_file_columns
  FOR EACH ROW
BEGIN
    IF :NEW.SPFC_ID IS NULL
    THEN
      :NEW.SPFC_ID := spfc_id_seq.NEXTVAL;
    END IF;
END sdl_profile_file_columns_seq_trg;
/