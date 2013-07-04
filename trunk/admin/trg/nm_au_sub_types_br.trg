CREATE OR REPLACE TRIGGER nm_au_sub_types_br
BEFORE INSERT OR UPDATE
ON NM_AU_SUB_TYPES
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW

-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_au_sub_types_br.trg	1.1 04/21/05
--       Module Name      : nm_au_sub_types_br.trg
--       Date into SCCS   : 05/04/21 11:15:17
--       Date fetched Out : 07/06/13 17:02:40
--       SCCS Version     : 1.1
--
--
--   Author : Graeme Johnson
--
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

DECLARE

 l_rec_nsty_old nm_au_sub_types%ROWTYPE; 
 l_rec_nsty_new nm_au_sub_types%ROWTYPE;

BEGIN

--
-- generate primary key column value from sequence if not specified
--
 IF :new.nsty_id IS NULL THEN
    :new.nsty_id := nm3seq.next_nsty_id_seq;
 END IF;


  l_rec_nsty_old.nsty_id               := :OLD.nsty_id;
  l_rec_nsty_old.nsty_nat_admin_type   := :OLD.nsty_nat_admin_type;
  l_rec_nsty_old.nsty_sub_type         := :OLD.nsty_sub_type;
  l_rec_nsty_old.nsty_descr            := :OLD.nsty_descr;
  l_rec_nsty_old.nsty_parent_sub_type  := :OLD.nsty_parent_sub_type;
  l_rec_nsty_old.nsty_ngt_group_type   := :OLD.nsty_ngt_group_type;

  nm3api_admin_unit.g_tab_nsty_old(nm3api_admin_unit.g_tab_nsty_old.COUNT+1) := l_rec_nsty_old;  
 
  l_rec_nsty_new.nsty_id               := :NEW.nsty_id;
  l_rec_nsty_new.nsty_nat_admin_type   := :NEW.nsty_nat_admin_type;
  l_rec_nsty_new.nsty_sub_type         := :NEW.nsty_sub_type;
  l_rec_nsty_new.nsty_descr            := :NEW.nsty_descr;
  l_rec_nsty_new.nsty_parent_sub_type  := :NEW.nsty_parent_sub_type;
  l_rec_nsty_new.nsty_ngt_group_type   := :NEW.nsty_ngt_group_type;
  

  nm3api_admin_unit.g_tab_nsty_new(nm3api_admin_unit.g_tab_nsty_new.COUNT+1) := l_rec_nsty_new;

END nm_au_sub_types_br;
/
