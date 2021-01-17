-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_destination_header_seq_trg.trg-arc   1.0   Jan 17 2021 10:07:46   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_destination_header_seq_trg.trg  $
--       Date into PVCS   : $Date:   Jan 17 2021 10:07:46  $
--       Date fetched Out : $Modtime:   Jan 14 2021 19:27:22  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2021 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_DESTINATION_HEADER'
CREATE OR REPLACE TRIGGER sdl_destination_header_seq_trg
  BEFORE INSERT ON sdl_destination_header
  FOR EACH ROW
BEGIN
  IF :NEW.sdh_id IS NULL
  THEN
    :NEW.sdh_id := sdh_id_seq.NEXTVAL;
  END IF;
END sdl_destination_header_seq_trg;
/