-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_pline_statistics_seq_trg.trg-arc   1.0   Mar 17 2020 10:04:36   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_pline_statistics_seq_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:36  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:57:04  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--PROMPT Creating trigger on 'SDL_PLINE_STATISTICS' 
CREATE OR REPLACE TRIGGER sdl_pline_statistics_seq_trg 
  BEFORE INSERT ON sdl_pline_statistics
  FOR EACH ROW
BEGIN
  IF :NEW.slps_pline_id IS NULL THEN
    :NEW.slps_pline_id := slps_pline_id_seq.NEXTVAL;
  END IF;
END sdl_pline_statistics_seq_trg;
/
