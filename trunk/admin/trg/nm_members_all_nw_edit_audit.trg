CREATE OR REPLACE TRIGGER nm_members_all_nw_edit_audit
  AFTER UPDATE
  of nm_begin_mp, nm_end_mp, nm_slk, nm_cardinality
  ON nm_members_all
  FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_members_all_nw_edit_audit.trg-arc   2.2   Apr 13 2018 11:06:34   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_members_all_nw_edit_audit.trg  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:06:34  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:58:46  $
--       PVCS Version     : $Revision:   2.2  $
--
--
--   Author : Kevin Angus
--
--    nm_members_all_nw_edit_audit
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
BEGIN
  if    :new.nm_type = 'G'
    AND     nm3net_history.auditing_member_edits
    and not nm3merge.is_nw_operation_in_progress
    and (   nm3net_history.value_has_changed(pi_old_value => :old.nm_begin_mp
                                            ,pi_new_value => :NEW.nm_begin_mp)
         or nm3net_history.value_has_changed(pi_old_value => :old.nm_end_mp
                                            ,pi_new_value => :NEW.nm_end_mp)
         or nm3net_history.value_has_changed(pi_old_value => :old.nm_slk
                                            ,pi_new_value => :NEW.nm_slk)
         or nm3net_history.value_has_changed(pi_old_value => :old.nm_cardinality
                                            ,pi_new_value => :NEW.nm_cardinality))
  then
    --a manual edit has occurred so audit it
    nm3net_history.audit_member_mp_edit(pi_nm_ne_id_in   => :NEW.nm_ne_id_in
                                       ,pi_nm_ne_id_of   => :NEW.nm_ne_id_of
                                       ,pi_nm_begin_mp   => :new.nm_begin_mp
                                       ,pi_nm_start_date => :NEW.nm_start_date);
  end if;

END nm_members_all_nw_edit_audit;
/


