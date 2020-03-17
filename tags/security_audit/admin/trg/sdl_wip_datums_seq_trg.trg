-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_wip_datums_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:42   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_wip_datums_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:42  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:55:28  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

--PROMPT Creating trigger on 'SDL_WIP_DATUMS'
CREATE OR REPLACE TRIGGER sdl_wip_datums_seq_trg 
  BEFORE INSERT ON sdl_wip_datums
  FOR EACH ROW
BEGIN
  IF :NEW.swd_id IS NULL 
  THEN
    :NEW.swd_id := swd_id_seq.NEXTVAL;
  END IF;
END sdl_wip_datums_seq_trg;
/
