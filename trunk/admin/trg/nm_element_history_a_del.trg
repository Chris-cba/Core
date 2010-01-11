CREATE OR REPLACE TRIGGER nm_element_history_a_del
   AFTER INSERT OR DELETE ON nm_element_history
FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_element_history_a_del.trg-arc   2.1   Jan 11 2010 12:44:42   cstrettle  $
--       Module Name      : $Workfile:   NM_ELEMENT_HISTORY_A_DEL.trg  $
--       Date into PVCS   : $Date:   Jan 11 2010 12:44:42  $
--       Date fetched Out : $Modtime:   Aug 21 2009 14:49:10  $
--       PVCS Version     : $Revision:   2.1  $
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
  IF DELETING
  THEN
    nm3net_history.cascade_neh_delete(pi_neh_id        => :old.neh_id
                                     ,pi_neh_ne_id_old => :old.neh_ne_id_old
                                     ,pi_neh_ne_id_new => :old.neh_ne_id_new);
  --
    nm3element_history_text.del_neht (pi_neht_neh_id   => :old.neh_id);
  ELSIF INSERTING
  THEN
    nm3element_history_text.create_neht ( pi_neht_neh_id => :new.neh_id);
  END IF;
--
END nm_element_history_a_del;
/
