--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_instead_iu.trg-arc   2.1   Jul 04 2013 09:53:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_items_instead_iu.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:53:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:50:12  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
create or replace trigger nm_inv_items_instead_iu
instead of insert or update
on nm_inv_items
for each row
declare
  rec nm_inv_items_all%rowtype;
--   PVCS Identifiers :-
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items_instead_iu.trg-arc   2.1   Jul 04 2013 09:53:26   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_items_instead_iu.trg  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:53:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:50:12  $
--       PVCS Version     : $Revision:   2.1  $ 
begin
  rec.iit_ne_id := :new.iit_ne_id;
  rec.iit_inv_type := :new.iit_inv_type;
  rec.iit_primary_key := :new.iit_primary_key;
  rec.iit_start_date := :new.iit_start_date;
  rec.iit_date_created := :new.iit_date_created;
  rec.iit_date_modified := :new.iit_date_modified;
  rec.iit_created_by := :new.iit_created_by;
  rec.iit_modified_by := :new.iit_modified_by;
  rec.iit_admin_unit := :new.iit_admin_unit;
  rec.iit_descr := :new.iit_descr;
  rec.iit_end_date := :new.iit_end_date;
  rec.iit_foreign_key := :new.iit_foreign_key;
  rec.iit_located_by := :new.iit_located_by;
  rec.iit_position := :new.iit_position;
  rec.iit_x_coord := :new.iit_x_coord;
  rec.iit_y_coord := :new.iit_y_coord;
  rec.iit_num_attrib16 := :new.iit_num_attrib16;
  rec.iit_num_attrib17 := :new.iit_num_attrib17;
  rec.iit_num_attrib18 := :new.iit_num_attrib18;
  rec.iit_num_attrib19 := :new.iit_num_attrib19;
  rec.iit_num_attrib20 := :new.iit_num_attrib20;
  rec.iit_num_attrib21 := :new.iit_num_attrib21;
  rec.iit_num_attrib22 := :new.iit_num_attrib22;
  rec.iit_num_attrib23 := :new.iit_num_attrib23;
  rec.iit_num_attrib24 := :new.iit_num_attrib24;
  rec.iit_num_attrib25 := :new.iit_num_attrib25;
  rec.iit_chr_attrib26 := :new.iit_chr_attrib26;
  rec.iit_chr_attrib27 := :new.iit_chr_attrib27;
  rec.iit_chr_attrib28 := :new.iit_chr_attrib28;
  rec.iit_chr_attrib29 := :new.iit_chr_attrib29;
  rec.iit_chr_attrib30 := :new.iit_chr_attrib30;
  rec.iit_chr_attrib31 := :new.iit_chr_attrib31;
  rec.iit_chr_attrib32 := :new.iit_chr_attrib32;
  rec.iit_chr_attrib33 := :new.iit_chr_attrib33;
  rec.iit_chr_attrib34 := :new.iit_chr_attrib34;
  rec.iit_chr_attrib35 := :new.iit_chr_attrib35;
  rec.iit_chr_attrib36 := :new.iit_chr_attrib36;
  rec.iit_chr_attrib37 := :new.iit_chr_attrib37;
  rec.iit_chr_attrib38 := :new.iit_chr_attrib38;
  rec.iit_chr_attrib39 := :new.iit_chr_attrib39;
  rec.iit_chr_attrib40 := :new.iit_chr_attrib40;
  rec.iit_chr_attrib41 := :new.iit_chr_attrib41;
  rec.iit_chr_attrib42 := :new.iit_chr_attrib42;
  rec.iit_chr_attrib43 := :new.iit_chr_attrib43;
  rec.iit_chr_attrib44 := :new.iit_chr_attrib44;
  rec.iit_chr_attrib45 := :new.iit_chr_attrib45;
  rec.iit_chr_attrib46 := :new.iit_chr_attrib46;
  rec.iit_chr_attrib47 := :new.iit_chr_attrib47;
  rec.iit_chr_attrib48 := :new.iit_chr_attrib48;
  rec.iit_chr_attrib49 := :new.iit_chr_attrib49;
  rec.iit_chr_attrib50 := :new.iit_chr_attrib50;
  rec.iit_chr_attrib51 := :new.iit_chr_attrib51;
  rec.iit_chr_attrib52 := :new.iit_chr_attrib52;
  rec.iit_chr_attrib53 := :new.iit_chr_attrib53;
  rec.iit_chr_attrib54 := :new.iit_chr_attrib54;
  rec.iit_chr_attrib55 := :new.iit_chr_attrib55;
  rec.iit_chr_attrib56 := :new.iit_chr_attrib56;
  rec.iit_chr_attrib57 := :new.iit_chr_attrib57;
  rec.iit_chr_attrib58 := :new.iit_chr_attrib58;
  rec.iit_chr_attrib59 := :new.iit_chr_attrib59;
  rec.iit_chr_attrib60 := :new.iit_chr_attrib60;
  rec.iit_chr_attrib61 := :new.iit_chr_attrib61;
  rec.iit_chr_attrib62 := :new.iit_chr_attrib62;
  rec.iit_chr_attrib63 := :new.iit_chr_attrib63;
  rec.iit_chr_attrib64 := :new.iit_chr_attrib64;
  rec.iit_chr_attrib65 := :new.iit_chr_attrib65;
  rec.iit_chr_attrib66 := :new.iit_chr_attrib66;
  rec.iit_chr_attrib67 := :new.iit_chr_attrib67;
  rec.iit_chr_attrib68 := :new.iit_chr_attrib68;
  rec.iit_chr_attrib69 := :new.iit_chr_attrib69;
  rec.iit_chr_attrib70 := :new.iit_chr_attrib70;
  rec.iit_chr_attrib71 := :new.iit_chr_attrib71;
  rec.iit_chr_attrib72 := :new.iit_chr_attrib72;
  rec.iit_chr_attrib73 := :new.iit_chr_attrib73;
  rec.iit_chr_attrib74 := :new.iit_chr_attrib74;
  rec.iit_chr_attrib75 := :new.iit_chr_attrib75;
  rec.iit_num_attrib76 := :new.iit_num_attrib76;
  rec.iit_num_attrib77 := :new.iit_num_attrib77;
  rec.iit_num_attrib78 := :new.iit_num_attrib78;
  rec.iit_num_attrib79 := :new.iit_num_attrib79;
  rec.iit_num_attrib80 := :new.iit_num_attrib80;
  rec.iit_num_attrib81 := :new.iit_num_attrib81;
  rec.iit_num_attrib82 := :new.iit_num_attrib82;
  rec.iit_num_attrib83 := :new.iit_num_attrib83;
  rec.iit_num_attrib84 := :new.iit_num_attrib84;
  rec.iit_num_attrib85 := :new.iit_num_attrib85;
  rec.iit_date_attrib86 := :new.iit_date_attrib86;
  rec.iit_date_attrib87 := :new.iit_date_attrib87;
  rec.iit_date_attrib88 := :new.iit_date_attrib88;
  rec.iit_date_attrib89 := :new.iit_date_attrib89;
  rec.iit_date_attrib90 := :new.iit_date_attrib90;
  rec.iit_date_attrib91 := :new.iit_date_attrib91;
  rec.iit_date_attrib92 := :new.iit_date_attrib92;
  rec.iit_date_attrib93 := :new.iit_date_attrib93;
  rec.iit_date_attrib94 := :new.iit_date_attrib94;
  rec.iit_date_attrib95 := :new.iit_date_attrib95;
  rec.iit_angle := :new.iit_angle;
  rec.iit_angle_txt := :new.iit_angle_txt;
  rec.iit_class := :new.iit_class;
  rec.iit_class_txt := :new.iit_class_txt;
  rec.iit_colour := :new.iit_colour;
  rec.iit_colour_txt := :new.iit_colour_txt;
  rec.iit_coord_flag := :new.iit_coord_flag;
  rec.iit_description := :new.iit_description;
  rec.iit_diagram := :new.iit_diagram;
  rec.iit_distance := :new.iit_distance;
  rec.iit_end_chain := :new.iit_end_chain;
  rec.iit_gap := :new.iit_gap;
  rec.iit_height := :new.iit_height;
  rec.iit_height_2 := :new.iit_height_2;
  rec.iit_id_code := :new.iit_id_code;
  rec.iit_instal_date := :new.iit_instal_date;
  rec.iit_invent_date := :new.iit_invent_date;
  rec.iit_inv_ownership := :new.iit_inv_ownership;
  rec.iit_itemcode := :new.iit_itemcode;
  rec.iit_lco_lamp_config_id := :new.iit_lco_lamp_config_id;
  rec.iit_length := :new.iit_length;
  rec.iit_material := :new.iit_material;
  rec.iit_material_txt := :new.iit_material_txt;
  rec.iit_method := :new.iit_method;
  rec.iit_method_txt := :new.iit_method_txt;
  rec.iit_note := :new.iit_note;
  rec.iit_no_of_units := :new.iit_no_of_units;
  rec.iit_options := :new.iit_options;
  rec.iit_options_txt := :new.iit_options_txt;
  rec.iit_oun_org_id_elec_board := :new.iit_oun_org_id_elec_board;
  rec.iit_owner := :new.iit_owner;
  rec.iit_owner_txt := :new.iit_owner_txt;
  rec.iit_peo_invent_by_id := :new.iit_peo_invent_by_id;
  rec.iit_photo := :new.iit_photo;
  rec.iit_power := :new.iit_power;
  rec.iit_prov_flag := :new.iit_prov_flag;
  rec.iit_rev_by := :new.iit_rev_by;
  rec.iit_rev_date := :new.iit_rev_date;
  rec.iit_type := :new.iit_type;
  rec.iit_type_txt := :new.iit_type_txt;
  rec.iit_width := :new.iit_width;
  rec.iit_xtra_char_1 := :new.iit_xtra_char_1;
  rec.iit_xtra_date_1 := :new.iit_xtra_date_1;
  rec.iit_xtra_domain_1 := :new.iit_xtra_domain_1;
  rec.iit_xtra_domain_txt_1 := :new.iit_xtra_domain_txt_1;
  rec.iit_xtra_number_1 := :new.iit_xtra_number_1;
  rec.iit_x_sect := :new.iit_x_sect;
  rec.iit_det_xsp := :new.iit_det_xsp;
  rec.iit_offset := :new.iit_offset;
  rec.iit_x := :new.iit_x;
  rec.iit_y := :new.iit_y;
  rec.iit_z := :new.iit_z;
  rec.iit_num_attrib96 := :new.iit_num_attrib96;
  rec.iit_num_attrib97 := :new.iit_num_attrib97;
  rec.iit_num_attrib98 := :new.iit_num_attrib98;
  rec.iit_num_attrib99 := :new.iit_num_attrib99;
  rec.iit_num_attrib100 := :new.iit_num_attrib100;
  rec.iit_num_attrib101 := :new.iit_num_attrib101;
  rec.iit_num_attrib102 := :new.iit_num_attrib102;
  rec.iit_num_attrib103 := :new.iit_num_attrib103;
  rec.iit_num_attrib104 := :new.iit_num_attrib104;
  rec.iit_num_attrib105 := :new.iit_num_attrib105;
  rec.iit_num_attrib106 := :new.iit_num_attrib106;
  rec.iit_num_attrib107 := :new.iit_num_attrib107;
  rec.iit_num_attrib108 := :new.iit_num_attrib108;
  rec.iit_num_attrib109 := :new.iit_num_attrib109;
  rec.iit_num_attrib110 := :new.iit_num_attrib110;
  rec.iit_num_attrib111 := :new.iit_num_attrib111;
  rec.iit_num_attrib112 := :new.iit_num_attrib112;
  rec.iit_num_attrib113 := :new.iit_num_attrib113;
  rec.iit_num_attrib114 := :new.iit_num_attrib114;
  rec.iit_num_attrib115 := :new.iit_num_attrib115;
  if inserting then
    -- set table default values
    rec.iit_start_date := nvl(rec.iit_start_date, to_date('05111605','DDMMYYYY'));
    insert into nm_inv_items_all values rec;
  elsif updating then
    update nm_inv_items_all set row = rec
    where iit_ne_id = :new.iit_ne_id;
  end if;
end;
/
