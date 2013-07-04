CREATE OR REPLACE TRIGGER nm_event_log_b_ins_row 
  BEFORE INSERT ON nm_event_log
  FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_event_log_b_ins_row.trg	1.1 07/18/02
--       Module Name      : nm_event_log_b_ins_row.trg
--       Date into SCCS   : 02/07/18 17:03:32
--       Date fetched Out : 07/06/13 17:02:45
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   nm_event_log_b_ins_row trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3event_log.g_nel_id_tab(nm3event_log.g_nel_id_tab.COUNT + 1) := :NEW.nel_id;
  
END nm_event_log_b_ins_row;
/
