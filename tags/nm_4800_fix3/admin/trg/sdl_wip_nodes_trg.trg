-----------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/sdl_wip_nodes_trg.trg-arc   1.0   Mar 17 2020 10:04:44   Chris.Baugh  $
--       Module Name      : $Workfile:   sdl_wip_nodes_trg.trg  $
--       Date into PVCS   : $Date:   Mar 17 2020 10:04:44  $
--       Date fetched Out : $Modtime:   Mar 17 2020 09:58:04  $
--       PVCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

--PROMPT Creating trigger on 'SDL_WIP_NODES'
CREATE OR REPLACE TRIGGER sdl_wip_nodes_trg 
  BEFORE INSERT ON sdl_wip_nodes
  FOR EACH ROW
BEGIN
  IF :NEW.node_id IS NULL 
  THEN      
    :NEW.node_id := sdl_node_id_seq.NEXTVAL;
  END IF;
END sdl_wip_nodes_trg;
/
