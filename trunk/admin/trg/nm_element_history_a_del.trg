CREATE OR REPLACE TRIGGER nm_element_history_a_del
   AFTER DELETE ON nm_element_history
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_element_history_a_del.trg-arc   2.3   Jul 04 2013 09:53:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_element_history_a_del.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:53:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       PVCS Version     : $Revision:   2.3  $
--
--
--   Author : Kevin Angus
--
--    nm_element_history_a_del
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3net_history.cascade_neh_delete(pi_neh_id        => :old.neh_id
                                   ,pi_neh_ne_id_old => :old.neh_ne_id_old
                                   ,pi_neh_ne_id_new => :old.neh_ne_id_new);

END nm_element_history_a_del;
/

