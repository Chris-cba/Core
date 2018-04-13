CREATE OR REPLACE TRIGGER nm_element_history_a_del
   AFTER DELETE ON nm_element_history
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_element_history_a_del.trg-arc   2.4   Apr 13 2018 11:06:24   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_element_history_a_del.trg  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:06:24  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:54:38  $
--       PVCS Version     : $Revision:   2.4  $
--
--
--   Author : Kevin Angus
--
--    nm_element_history_a_del
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  nm3net_history.cascade_neh_delete(pi_neh_id        => :old.neh_id
                                   ,pi_neh_ne_id_old => :old.neh_ne_id_old
                                   ,pi_neh_ne_id_new => :old.neh_ne_id_new);

END nm_element_history_a_del;
/

