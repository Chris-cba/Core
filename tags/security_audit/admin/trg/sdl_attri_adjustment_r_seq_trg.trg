-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_attri_adjustment_r_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:30   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_attri_adjustment_r_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:30  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:52:22  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

--PROMPT Creating trigger on 'SDL_ATTRIBUTE_ADJUSTMENT_RULES'
CREATE OR REPLACE TRIGGER sdl_attri_adjustment_r_seq_trg
  BEFORE INSERT ON sdl_attribute_adjustment_rules
  FOR EACH ROW
BEGIN
  IF :NEW.saar_id IS NULL 
  THEN
    :NEW.saar_id := saar_id_seq.NEXTVAL;
  END IF;
END sdl_attri_adjustment_r_seq_trg;
/
