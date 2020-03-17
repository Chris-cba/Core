-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_attribute_mapping_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:32   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_attribute_mapping_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:32  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:50:30  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_ATTRIBUTE_MAPPING'
CREATE OR REPLACE TRIGGER sdl_attribute_mapping_seq_trg
  BEFORE INSERT ON sdl_attribute_mapping
  FOR EACH ROW
BEGIN
  IF :NEW.sam_id IS NULL
  THEN
    :NEW.sam_id := sam_id_seq.NEXTVAL;
  END IF;
END sdl_attribute_mapping_seq_trg;
/
