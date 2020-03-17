-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_geom_accuracy_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:32   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_geom_accuracy_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:32  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:54:24  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_GEOM_ACCURACY'
CREATE OR REPLACE TRIGGER sdl_geom_accuracy_seq_trg 
  BEFORE INSERT ON sdl_geom_accuracy
  FOR EACH ROW
BEGIN
  IF :NEW.slga_id IS NULL 
  THEN
    :NEW.slga_id := slga_id_seq.NEXTVAL;
  END IF;
END sdl_geom_accuracy_seq_trg;
/
