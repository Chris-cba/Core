-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_process_audit_seq.trg-arc   1.0   Mar 17 2020 10:04:36   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_process_audit_seq.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:36  $
--       Date fetched Out : $Modtime:   Mar 17 2020 10:00:08  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

--PROMPT Creating trigger on 'SDL_PROCESS_AUDIT' 
CREATE OR REPLACE TRIGGER sdl_process_audit_seq
  BEFORE INSERT ON sdl_process_audit
  FOR EACH ROW
BEGIN
  IF :NEW.spa_id IS NULL 
  THEN
    :NEW.spa_id := spa_id_seq.NEXTVAL;
  END IF;
END sdl_process_audit_seq;
/
