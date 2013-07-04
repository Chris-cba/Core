CREATE OR REPLACE TRIGGER nm_inv_types_all_b_row
 BEFORE INSERT OR UPDATE
 ON nm_inv_types_all
 FOR EACH ROW
DECLARE
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_types_all_b_row.trg	1.1 05/14/02
--       Module Name      : nm_inv_types_all_b_row.trg
--       Date into SCCS   : 02/05/14 09:55:41
--       Date fetched Out : 07/06/13 17:03:07
--       SCCS Version     : 1.1
--
--   Author : Jonathan Mills
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_rec_nit nm_inv_types%ROWTYPE;
--
BEGIN
--
   l_rec_nit.nit_inv_type           := :NEW.nit_inv_type;
   l_rec_nit.nit_pnt_or_cont        := :NEW.nit_pnt_or_cont;
   l_rec_nit.nit_x_sect_allow_flag  := :NEW.nit_x_sect_allow_flag;
   l_rec_nit.nit_elec_drain_carr    := :NEW.nit_elec_drain_carr;
   l_rec_nit.nit_contiguous         := :NEW.nit_contiguous;
   l_rec_nit.nit_replaceable        := :NEW.nit_replaceable;
   l_rec_nit.nit_exclusive          := :NEW.nit_exclusive;
   l_rec_nit.nit_category           := :NEW.nit_category;
   l_rec_nit.nit_descr              := :NEW.nit_descr;
   l_rec_nit.nit_linear             := :NEW.nit_linear;
   l_rec_nit.nit_use_xy             := :NEW.nit_use_xy;
   l_rec_nit.nit_multiple_allowed   := :NEW.nit_multiple_allowed;
   l_rec_nit.nit_end_loc_only       := :NEW.nit_end_loc_only;
   l_rec_nit.nit_screen_seq         := :NEW.nit_screen_seq;
   l_rec_nit.nit_view_name          := :NEW.nit_view_name;
   l_rec_nit.nit_start_date         := :NEW.nit_start_date;
   l_rec_nit.nit_end_date           := :NEW.nit_end_date;
   l_rec_nit.nit_short_descr        := :NEW.nit_short_descr;
   l_rec_nit.nit_flex_item_flag     := :NEW.nit_flex_item_flag;
   l_rec_nit.nit_table_name         := :NEW.nit_table_name;
   l_rec_nit.nit_lr_ne_column_name  := :NEW.nit_lr_ne_column_name;
   l_rec_nit.nit_lr_st_chain        := :NEW.nit_lr_st_chain;
   l_rec_nit.nit_lr_end_chain       := :NEW.nit_lr_end_chain;
   l_rec_nit.nit_admin_type         := :NEW.nit_admin_type;
   l_rec_nit.nit_icon_name          := :NEW.nit_icon_name;
   l_rec_nit.nit_top                := :NEW.nit_top;
   l_rec_nit.nit_foreign_pk_column  := :NEW.nit_foreign_pk_column;
   l_rec_nit.nit_update_allowed     := :NEW.nit_update_allowed;
--
   nm3invval.pop_inv_type_chk_tab (l_rec_nit);
--
END nm_inv_types_all_b_row;
/
