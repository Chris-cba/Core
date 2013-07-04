CREATE OR REPLACE TRIGGER nm_elements_all_au_check
   BEFORE INSERT OR UPDATE
    ON nm_elements_all
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_elements_all_au_check.trg-arc   2.2   Jul 04 2013 09:53:20   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_elements_all_au_check.trg  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:53:20  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on 
--
--   TRIGGER NM_ELEMENTS_ALL_AU_CHECK
--   BEFORE INSERT OR UPDATE ON nm_elements_all
--   FOR EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_ne_old nm_elements_all%ROWTYPE;
   l_rec_ne_new nm_elements_all%ROWTYPE;
   l_db_action  VARCHAR2(10);
--
BEGIN
--
  --MJA add 31-Aug-07
  --New functionality to allow override
  If Not nm3net.bypass_nm_elements_trgs
  Then 
    l_rec_ne_old.ne_id                  := :OLD.ne_id;
    l_rec_ne_old.ne_unique              := :OLD.ne_unique;
    l_rec_ne_old.ne_type                := :OLD.ne_type;
    l_rec_ne_old.ne_nt_type             := :OLD.ne_nt_type;
    l_rec_ne_old.ne_descr               := :OLD.ne_descr;
    l_rec_ne_old.ne_length              := :OLD.ne_length;
    l_rec_ne_old.ne_admin_unit          := :OLD.ne_admin_unit;
    l_rec_ne_old.ne_date_created        := :OLD.ne_date_created;
    l_rec_ne_old.ne_date_modified       := :OLD.ne_date_modified;
    l_rec_ne_old.ne_modified_by         := :OLD.ne_modified_by;
    l_rec_ne_old.ne_created_by          := :OLD.ne_created_by;
    l_rec_ne_old.ne_start_date          := :OLD.ne_start_date;
    l_rec_ne_old.ne_end_date            := :OLD.ne_end_date;
    l_rec_ne_old.ne_gty_group_type      := :OLD.ne_gty_group_type;
    l_rec_ne_old.ne_owner               := :OLD.ne_owner;
    l_rec_ne_old.ne_name_1              := :OLD.ne_name_1;
    l_rec_ne_old.ne_name_2              := :OLD.ne_name_2;
    l_rec_ne_old.ne_prefix              := :OLD.ne_prefix;
    l_rec_ne_old.ne_number              := :OLD.ne_number;
    l_rec_ne_old.ne_sub_type            := :OLD.ne_sub_type;
    l_rec_ne_old.ne_group               := :OLD.ne_group;
    l_rec_ne_old.ne_no_start            := :OLD.ne_no_start;
    l_rec_ne_old.ne_no_end              := :OLD.ne_no_end;
    l_rec_ne_old.ne_sub_class           := :OLD.ne_sub_class;
    l_rec_ne_old.ne_nsg_ref             := :OLD.ne_nsg_ref;
    l_rec_ne_old.ne_version_no          := :OLD.ne_version_no;
 --
    l_rec_ne_new.ne_id                  := :NEW.ne_id;
    l_rec_ne_new.ne_unique              := :NEW.ne_unique;
    l_rec_ne_new.ne_type                := :NEW.ne_type;
    l_rec_ne_new.ne_nt_type             := :NEW.ne_nt_type;
    l_rec_ne_new.ne_descr               := :NEW.ne_descr;
    l_rec_ne_new.ne_length              := :NEW.ne_length;
    l_rec_ne_new.ne_admin_unit          := :NEW.ne_admin_unit;
    l_rec_ne_new.ne_date_created        := :NEW.ne_date_created;
    l_rec_ne_new.ne_date_modified       := :NEW.ne_date_modified;
    l_rec_ne_new.ne_modified_by         := :NEW.ne_modified_by;
    l_rec_ne_new.ne_created_by          := :NEW.ne_created_by;
    l_rec_ne_new.ne_start_date          := :NEW.ne_start_date;
    l_rec_ne_new.ne_end_date            := :NEW.ne_end_date;
    l_rec_ne_new.ne_gty_group_type      := :NEW.ne_gty_group_type;
    l_rec_ne_new.ne_owner               := :NEW.ne_owner;
    l_rec_ne_new.ne_name_1              := :NEW.ne_name_1;
    l_rec_ne_new.ne_name_2              := :NEW.ne_name_2;
    l_rec_ne_new.ne_prefix              := :NEW.ne_prefix;
    l_rec_ne_new.ne_number              := :NEW.ne_number;
    l_rec_ne_new.ne_sub_type            := :NEW.ne_sub_type;
    l_rec_ne_new.ne_group               := :NEW.ne_group;
    l_rec_ne_new.ne_no_start            := :NEW.ne_no_start;
    l_rec_ne_new.ne_no_end              := :NEW.ne_no_end;
    l_rec_ne_new.ne_sub_class           := :NEW.ne_sub_class;
    l_rec_ne_new.ne_nsg_ref             := :NEW.ne_nsg_ref;
    l_rec_ne_new.ne_version_no          := :NEW.ne_version_no;
 --
    IF updating
     THEN
       l_db_action := nm3type.c_updating;
    ELSIF inserting
     THEN
       l_db_action := nm3type.c_inserting;
    ELSIF deleting
     THEN
       l_db_action := nm3type.c_deleting;
    END IF;
 --
    nm3nwval.check_element_b4_row_trigger
                           (p_rec_ne_old => l_rec_ne_old
                           ,p_rec_ne_new => l_rec_ne_new
                           ,p_db_action  => l_db_action
                           );
 --
  End If;
END nm_elements_all_au_check;
/
