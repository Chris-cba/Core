CREATE OR REPLACE TRIGGER nm_element_history_a_del
   AFTER DELETE ON nm_element_history
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_element_history_a_del.trg-arc   2.0   Jul 18 2007 15:37:06   smarshall  $
--       Module Name      : $Workfile:   nm_element_history_a_del.trg  $
--       Date into PVCS   : $Date:   Jul 18 2007 15:37:06  $
--       Date fetched Out : $Modtime:   Jul 18 2007 14:47:32  $
--       PVCS Version     : $Revision:   2.0  $
--
--
--   Author : Kevin Angus
--
--    nm_element_history_a_del
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
BEGIN
  nm3net_history.cascade_neh_delete(pi_neh_id        => :old.neh_id
                                   ,pi_neh_ne_id_old => :old.neh_ne_id_old
                                   ,pi_neh_ne_id_new => :old.neh_ne_id_new);

END nm_element_history_a_del;
/

