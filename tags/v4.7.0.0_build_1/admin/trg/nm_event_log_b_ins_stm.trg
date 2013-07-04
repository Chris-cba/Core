CREATE OR REPLACE TRIGGER nm_event_log_b_ins_stm
  BEFORE INSERT ON nm_event_log
DECLARE
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_event_log_b_ins_stm.trg	1.1 07/18/02
--       Module Name      : nm_event_log_b_ins_stm.trg
--       Date into SCCS   : 02/07/18 17:03:50
--       Date fetched Out : 07/06/13 17:02:45
--       SCCS Version     : 1.1
--
--
--   Author : Kevin Angus
--
--   nm_event_log_b_ins_stm trigger
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3event_log.g_nel_id_tab.DELETE;
  
END nm_event_log_b_ins_stm;
/ 
