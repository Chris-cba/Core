--
CREATE OR REPLACE TRIGGER nm_inv_items_all_b_upd
       BEFORE  UPDATE OF iit_foreign_key, iit_x_sect
         ON    NM_INV_ITEMS_ALL
       FOR EACH ROW
DECLARE
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items.trg-arc   2.6   Nov 10 2011 09:28:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm_inv_items.trg  $
--       Date into PVCS   : $Date:   Nov 10 2011 09:28:36  $
--       Date fetched Out : $Modtime:   Nov 10 2011 09:27:42  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.8
-------------------------------------------------------------------------
BEGIN
   IF NVL(:OLD.iit_foreign_key,nm3type.c_nvl) <> NVL(:NEW.iit_foreign_key,nm3type.c_nvl)
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Update of IIT_FOREIGN_KEY not allowed');
   END IF;
   IF NVL(:OLD.iit_x_sect,nm3type.c_nvl) <> NVL(:NEW.iit_x_sect,nm3type.c_nvl)
    THEN
      nm3invval.check_xsp_valid_on_inv_loc
                         (pi_iit_ne_id    => :NEW.iit_ne_id
                         ,pi_iit_inv_type => :NEW.iit_inv_type
                         ,pi_iit_x_sect   => :NEW.iit_x_sect
                         );
   END IF;
END nm_inv_items_all_b_upd;
/
--
CREATE OR REPLACE TRIGGER nm_inv_items_all_b_ins_upd
       BEFORE INSERT OR UPDATE OF iit_end_date
       ON      NM_INV_ITEMS_ALL
BEGIN
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items.trg-arc   2.6   Nov 10 2011 09:28:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm_inv_items.trg  $
--       Date into PVCS   : $Date:   Nov 10 2011 09:28:36  $
--       Date fetched Out : $Modtime:   Nov 10 2011 09:27:42  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.8
-------------------------------------------------------------------------
   --
   -- Clear any rows out of the PL/SQL Table (just in case)
   --
   IF (UPDATING AND nm3invval.g_process_update_trigger)
    OR INSERTING
    OR nm3invval.g_statement_in_progress
    THEN
      nm3invval.g_tab_rec_nii.DELETE;
      nm3invval.g_tab_rec_date_chk.DELETE;
   END IF;
END nm_inv_items_all_b_ins_upd;
/
--
CREATE OR REPLACE TRIGGER nm_inv_items_all_b_ins_upd_row
       BEFORE  INSERT OR UPDATE OF iit_end_date
       ON      NM_INV_ITEMS_ALL
       FOR     EACH ROW
DECLARE
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items.trg-arc   2.6   Nov 10 2011 09:28:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm_inv_items.trg  $
--       Date into PVCS   : $Date:   Nov 10 2011 09:28:36  $
--       Date fetched Out : $Modtime:   Nov 10 2011 09:27:42  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.8
-------------------------------------------------------------------------
--
   l_rec_nii nm_inv_items%ROWTYPE;
   l_rec_nii_old nm_inv_items%ROWTYPE;      
--
   l_mode    VARCHAR2(30) := NULL;
--
   l_nvl_date CONSTANT DATE := TO_DATE('01/01/0001','DD/MM/YYYY');
--
BEGIN
--
-- Populate any required values in the rowtype record
--
   IF NOT nm3invval.g_suppress_hierarchy_trigger
    THEN
      IF INSERTING
       THEN
         -- If we are inserting a row
         l_mode := nm3invval.c_insert_mode;
      ELSIF (UPDATING AND nm3invval.g_process_update_trigger)
       AND  NVL(:OLD.iit_end_date,l_nvl_date) <> NVL(:NEW.iit_end_date,l_nvl_date)
       THEN
         -- Or we are updating, want to execute the trigger (i.e. it's not already running)
         --  and the iit_end_date has actually changed
         l_mode := nm3invval.c_update_mode;
      END IF;
   --
      IF l_mode IS NOT NULL
       THEN
   --
         l_rec_nii.iit_ne_id       := :NEW.iit_ne_id;
         l_rec_nii.iit_start_date  := :NEW.iit_start_date;
         l_rec_nii.iit_end_date    := :NEW.iit_end_date;
         l_rec_nii.iit_primary_key := :NEW.iit_primary_key;
         l_rec_nii.iit_foreign_key := :NEW.iit_foreign_key;
         l_rec_nii.iit_inv_type    := :NEW.iit_inv_type;
         l_rec_nii.iit_admin_unit  := :NEW.iit_admin_unit;
   --
         nm3invval.pc_pop_nit_tab (l_rec_nii
                                  ,l_mode
                                  );
         -- task 0108705 CWS Global set so the members table can be updated on the after trigger
         nm3invval.g_nii_end_date_old:= :OLD.iit_end_date;
      END IF;
   END IF;
--
END nm_inv_items_all_b_ins_upd_row;
/
--
CREATE OR REPLACE TRIGGER nm_inv_items_all_a_ins_upd
       AFTER   INSERT OR UPDATE OF iit_start_date, iit_end_date
       ON      NM_INV_ITEMS_ALL
BEGIN
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items.trg-arc   2.6   Nov 10 2011 09:28:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm_inv_items.trg  $
--       Date into PVCS   : $Date:   Nov 10 2011 09:28:36  $
--       Date fetched Out : $Modtime:   Nov 10 2011 09:27:42  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.8
-------------------------------------------------------------------------
--
   IF (UPDATING AND nm3invval.g_process_update_trigger)
    OR INSERTING
    THEN
      nm3invval.pc_process_nit_tab;
      --
      nm3invval.process_date_chk_tab;
   END IF;
--
END nm_inv_items_all_a_ins_upd;
/
--
CREATE OR REPLACE TRIGGER nm_inv_items_mand_check
       BEFORE INSERT OR UPDATE
       ON     NM_INV_ITEMS_ALL
       FOR    EACH ROW
BEGIN
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/trg/nm_inv_items.trg-arc   2.6   Nov 10 2011 09:28:36   Ade.Edwards  $
--       Module Name      : $Workfile:   nm_inv_items.trg  $
--       Date into PVCS   : $Date:   Nov 10 2011 09:28:36  $
--       Date fetched Out : $Modtime:   Nov 10 2011 09:27:42  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.8
-------------------------------------------------------------------------
--

  IF NOT nm3inv.bypass_inv_items_all_trgs THEN

--
   nm3inv.g_rec_iit.iit_ne_id                 := :NEW.iit_ne_id;
   nm3inv.g_rec_iit.iit_inv_type              := :NEW.iit_inv_type;
   nm3inv.g_rec_iit.iit_primary_key           := :NEW.iit_primary_key;
   nm3inv.g_rec_iit.iit_start_date            := :NEW.iit_start_date;
   nm3inv.g_rec_iit.iit_admin_unit            := :NEW.iit_admin_unit;
   nm3inv.g_rec_iit.iit_descr                 := :NEW.iit_descr;
   nm3inv.g_rec_iit.iit_end_date              := :NEW.iit_end_date;
   nm3inv.g_rec_iit.iit_foreign_key           := :NEW.iit_foreign_key;
   nm3inv.g_rec_iit.iit_located_by            := :NEW.iit_located_by;
   nm3inv.g_rec_iit.iit_position              := :NEW.iit_position;
   nm3inv.g_rec_iit.iit_x_coord               := :NEW.iit_x_coord;
   nm3inv.g_rec_iit.iit_y_coord               := :NEW.iit_y_coord;
   nm3inv.g_rec_iit.iit_num_attrib16          := :NEW.iit_num_attrib16;
   nm3inv.g_rec_iit.iit_num_attrib17          := :NEW.iit_num_attrib17;
   nm3inv.g_rec_iit.iit_num_attrib18          := :NEW.iit_num_attrib18;
   nm3inv.g_rec_iit.iit_num_attrib19          := :NEW.iit_num_attrib19;
   nm3inv.g_rec_iit.iit_num_attrib20          := :NEW.iit_num_attrib20;
   nm3inv.g_rec_iit.iit_num_attrib21          := :NEW.iit_num_attrib21;
   nm3inv.g_rec_iit.iit_num_attrib22          := :NEW.iit_num_attrib22;
   nm3inv.g_rec_iit.iit_num_attrib23          := :NEW.iit_num_attrib23;
   nm3inv.g_rec_iit.iit_num_attrib24          := :NEW.iit_num_attrib24;
   nm3inv.g_rec_iit.iit_num_attrib25          := :NEW.iit_num_attrib25;
   nm3inv.g_rec_iit.iit_chr_attrib26          := :NEW.iit_chr_attrib26;
   nm3inv.g_rec_iit.iit_chr_attrib27          := :NEW.iit_chr_attrib27;
   nm3inv.g_rec_iit.iit_chr_attrib28          := :NEW.iit_chr_attrib28;
   nm3inv.g_rec_iit.iit_chr_attrib29          := :NEW.iit_chr_attrib29;
   nm3inv.g_rec_iit.iit_chr_attrib30          := :NEW.iit_chr_attrib30;
   nm3inv.g_rec_iit.iit_chr_attrib31          := :NEW.iit_chr_attrib31;
   nm3inv.g_rec_iit.iit_chr_attrib32          := :NEW.iit_chr_attrib32;
   nm3inv.g_rec_iit.iit_chr_attrib33          := :NEW.iit_chr_attrib33;
   nm3inv.g_rec_iit.iit_chr_attrib34          := :NEW.iit_chr_attrib34;
   nm3inv.g_rec_iit.iit_chr_attrib35          := :NEW.iit_chr_attrib35;
   nm3inv.g_rec_iit.iit_chr_attrib36          := :NEW.iit_chr_attrib36;
   nm3inv.g_rec_iit.iit_chr_attrib37          := :NEW.iit_chr_attrib37;
   nm3inv.g_rec_iit.iit_chr_attrib38          := :NEW.iit_chr_attrib38;
   nm3inv.g_rec_iit.iit_chr_attrib39          := :NEW.iit_chr_attrib39;
   nm3inv.g_rec_iit.iit_chr_attrib40          := :NEW.iit_chr_attrib40;
   nm3inv.g_rec_iit.iit_chr_attrib41          := :NEW.iit_chr_attrib41;
   nm3inv.g_rec_iit.iit_chr_attrib42          := :NEW.iit_chr_attrib42;
   nm3inv.g_rec_iit.iit_chr_attrib43          := :NEW.iit_chr_attrib43;
   nm3inv.g_rec_iit.iit_chr_attrib44          := :NEW.iit_chr_attrib44;
   nm3inv.g_rec_iit.iit_chr_attrib45          := :NEW.iit_chr_attrib45;
   nm3inv.g_rec_iit.iit_chr_attrib46          := :NEW.iit_chr_attrib46;
   nm3inv.g_rec_iit.iit_chr_attrib47          := :NEW.iit_chr_attrib47;
   nm3inv.g_rec_iit.iit_chr_attrib48          := :NEW.iit_chr_attrib48;
   nm3inv.g_rec_iit.iit_chr_attrib49          := :NEW.iit_chr_attrib49;
   nm3inv.g_rec_iit.iit_chr_attrib50          := :NEW.iit_chr_attrib50;
   nm3inv.g_rec_iit.iit_chr_attrib51          := :NEW.iit_chr_attrib51;
   nm3inv.g_rec_iit.iit_chr_attrib52          := :NEW.iit_chr_attrib52;
   nm3inv.g_rec_iit.iit_chr_attrib53          := :NEW.iit_chr_attrib53;
   nm3inv.g_rec_iit.iit_chr_attrib54          := :NEW.iit_chr_attrib54;
   nm3inv.g_rec_iit.iit_chr_attrib55          := :NEW.iit_chr_attrib55;
   nm3inv.g_rec_iit.iit_chr_attrib56          := :NEW.iit_chr_attrib56;
   nm3inv.g_rec_iit.iit_chr_attrib57          := :NEW.iit_chr_attrib57;
   nm3inv.g_rec_iit.iit_chr_attrib58          := :NEW.iit_chr_attrib58;
   nm3inv.g_rec_iit.iit_chr_attrib59          := :NEW.iit_chr_attrib59;
   nm3inv.g_rec_iit.iit_chr_attrib60          := :NEW.iit_chr_attrib60;
   nm3inv.g_rec_iit.iit_chr_attrib61          := :NEW.iit_chr_attrib61;
   nm3inv.g_rec_iit.iit_chr_attrib62          := :NEW.iit_chr_attrib62;
   nm3inv.g_rec_iit.iit_chr_attrib63          := :NEW.iit_chr_attrib63;
   nm3inv.g_rec_iit.iit_chr_attrib64          := :NEW.iit_chr_attrib64;
   nm3inv.g_rec_iit.iit_chr_attrib65          := :NEW.iit_chr_attrib65;
   nm3inv.g_rec_iit.iit_chr_attrib66          := :NEW.iit_chr_attrib66;
   nm3inv.g_rec_iit.iit_chr_attrib67          := :NEW.iit_chr_attrib67;
   nm3inv.g_rec_iit.iit_chr_attrib68          := :NEW.iit_chr_attrib68;
   nm3inv.g_rec_iit.iit_chr_attrib69          := :NEW.iit_chr_attrib69;
   nm3inv.g_rec_iit.iit_chr_attrib70          := :NEW.iit_chr_attrib70;
   nm3inv.g_rec_iit.iit_chr_attrib71          := :NEW.iit_chr_attrib71;
   nm3inv.g_rec_iit.iit_chr_attrib72          := :NEW.iit_chr_attrib72;
   nm3inv.g_rec_iit.iit_chr_attrib73          := :NEW.iit_chr_attrib73;
   nm3inv.g_rec_iit.iit_chr_attrib74          := :NEW.iit_chr_attrib74;
   nm3inv.g_rec_iit.iit_chr_attrib75          := :NEW.iit_chr_attrib75;
   nm3inv.g_rec_iit.iit_num_attrib76          := :NEW.iit_num_attrib76;
   nm3inv.g_rec_iit.iit_num_attrib77          := :NEW.iit_num_attrib77;
   nm3inv.g_rec_iit.iit_num_attrib78          := :NEW.iit_num_attrib78;
   nm3inv.g_rec_iit.iit_num_attrib79          := :NEW.iit_num_attrib79;
   nm3inv.g_rec_iit.iit_num_attrib80          := :NEW.iit_num_attrib80;
   nm3inv.g_rec_iit.iit_num_attrib81          := :NEW.iit_num_attrib81;
   nm3inv.g_rec_iit.iit_num_attrib82          := :NEW.iit_num_attrib82;
   nm3inv.g_rec_iit.iit_num_attrib83          := :NEW.iit_num_attrib83;
   nm3inv.g_rec_iit.iit_num_attrib84          := :NEW.iit_num_attrib84;
   nm3inv.g_rec_iit.iit_num_attrib85          := :NEW.iit_num_attrib85;
   nm3inv.g_rec_iit.iit_date_attrib86         := :NEW.iit_date_attrib86;
   nm3inv.g_rec_iit.iit_date_attrib87         := :NEW.iit_date_attrib87;
   nm3inv.g_rec_iit.iit_date_attrib88         := :NEW.iit_date_attrib88;
   nm3inv.g_rec_iit.iit_date_attrib89         := :NEW.iit_date_attrib89;
   nm3inv.g_rec_iit.iit_date_attrib90         := :NEW.iit_date_attrib90;
   nm3inv.g_rec_iit.iit_date_attrib91         := :NEW.iit_date_attrib91;
   nm3inv.g_rec_iit.iit_date_attrib92         := :NEW.iit_date_attrib92;
   nm3inv.g_rec_iit.iit_date_attrib93         := :NEW.iit_date_attrib93;
   nm3inv.g_rec_iit.iit_date_attrib94         := :NEW.iit_date_attrib94;
   nm3inv.g_rec_iit.iit_date_attrib95         := :NEW.iit_date_attrib95;
   nm3inv.g_rec_iit.iit_angle                 := :NEW.iit_angle;
   nm3inv.g_rec_iit.iit_angle_txt             := :NEW.iit_angle_txt;
   nm3inv.g_rec_iit.iit_class                 := :NEW.iit_class;
   nm3inv.g_rec_iit.iit_class_txt             := :NEW.iit_class_txt;
   nm3inv.g_rec_iit.iit_colour                := :NEW.iit_colour;
   nm3inv.g_rec_iit.iit_colour_txt            := :NEW.iit_colour_txt;
   nm3inv.g_rec_iit.iit_coord_flag            := :NEW.iit_coord_flag;
   nm3inv.g_rec_iit.iit_description           := :NEW.iit_description;
   nm3inv.g_rec_iit.iit_diagram               := :NEW.iit_diagram;
   nm3inv.g_rec_iit.iit_distance              := :NEW.iit_distance;
   nm3inv.g_rec_iit.iit_end_chain             := :NEW.iit_end_chain;
   nm3inv.g_rec_iit.iit_gap                   := :NEW.iit_gap;
   nm3inv.g_rec_iit.iit_height                := :NEW.iit_height;
   nm3inv.g_rec_iit.iit_height_2              := :NEW.iit_height_2;
   nm3inv.g_rec_iit.iit_id_code               := :NEW.iit_id_code;
   nm3inv.g_rec_iit.iit_instal_date           := :NEW.iit_instal_date;
   nm3inv.g_rec_iit.iit_invent_date           := :NEW.iit_invent_date;
   nm3inv.g_rec_iit.iit_inv_ownership         := :NEW.iit_inv_ownership;
   nm3inv.g_rec_iit.iit_itemcode              := :NEW.iit_itemcode;
   nm3inv.g_rec_iit.iit_lco_lamp_config_id    := :NEW.iit_lco_lamp_config_id;
   nm3inv.g_rec_iit.iit_length                := :NEW.iit_length;
   nm3inv.g_rec_iit.iit_material              := :NEW.iit_material;
   nm3inv.g_rec_iit.iit_material_txt          := :NEW.iit_material_txt;
   nm3inv.g_rec_iit.iit_method                := :NEW.iit_method;
   nm3inv.g_rec_iit.iit_method_txt            := :NEW.iit_method_txt;
   nm3inv.g_rec_iit.iit_note                  := :NEW.iit_note;
   nm3inv.g_rec_iit.iit_no_of_units           := :NEW.iit_no_of_units;
   nm3inv.g_rec_iit.iit_options               := :NEW.iit_options;
   nm3inv.g_rec_iit.iit_options_txt           := :NEW.iit_options_txt;
   nm3inv.g_rec_iit.iit_oun_org_id_elec_board := :NEW.iit_oun_org_id_elec_board;
   nm3inv.g_rec_iit.iit_owner                 := :NEW.iit_owner;
   nm3inv.g_rec_iit.iit_owner_txt             := :NEW.iit_owner_txt;
   nm3inv.g_rec_iit.iit_peo_invent_by_id      := :NEW.iit_peo_invent_by_id;
   nm3inv.g_rec_iit.iit_photo                 := :NEW.iit_photo;
   nm3inv.g_rec_iit.iit_power                 := :NEW.iit_power;
   nm3inv.g_rec_iit.iit_prov_flag             := :NEW.iit_prov_flag;
   nm3inv.g_rec_iit.iit_rev_by                := :NEW.iit_rev_by;
   nm3inv.g_rec_iit.iit_rev_date              := :NEW.iit_rev_date;
   nm3inv.g_rec_iit.iit_type                  := :NEW.iit_type;
   nm3inv.g_rec_iit.iit_type_txt              := :NEW.iit_type_txt;
   nm3inv.g_rec_iit.iit_width                 := :NEW.iit_width;
   nm3inv.g_rec_iit.iit_xtra_char_1           := :NEW.iit_xtra_char_1;
   nm3inv.g_rec_iit.iit_xtra_date_1           := :NEW.iit_xtra_date_1;
   nm3inv.g_rec_iit.iit_xtra_domain_1         := :NEW.iit_xtra_domain_1;
   nm3inv.g_rec_iit.iit_xtra_domain_txt_1     := :NEW.iit_xtra_domain_txt_1;
   nm3inv.g_rec_iit.iit_xtra_number_1         := :NEW.iit_xtra_number_1;
   nm3inv.g_rec_iit.iit_x_sect                := :NEW.iit_x_sect;
   nm3inv.g_rec_iit.iit_det_xsp               := :NEW.iit_det_xsp;
   nm3inv.g_rec_iit.iit_offset                := :NEW.iit_offset;
   nm3inv.g_rec_iit.iit_x                     := :NEW.iit_x;
   nm3inv.g_rec_iit.iit_y                     := :NEW.iit_y;
   nm3inv.g_rec_iit.iit_z                     := :NEW.iit_z;
   nm3inv.g_rec_iit.iit_num_attrib96          := :NEW.iit_num_attrib96;
   nm3inv.g_rec_iit.iit_num_attrib97          := :NEW.iit_num_attrib97;
   nm3inv.g_rec_iit.iit_num_attrib98          := :NEW.iit_num_attrib98;
   nm3inv.g_rec_iit.iit_num_attrib99          := :NEW.iit_num_attrib99;
   nm3inv.g_rec_iit.iit_num_attrib100         := :NEW.iit_num_attrib100;
   nm3inv.g_rec_iit.iit_num_attrib101         := :NEW.iit_num_attrib101;
   nm3inv.g_rec_iit.iit_num_attrib102         := :NEW.iit_num_attrib102;
   nm3inv.g_rec_iit.iit_num_attrib103         := :NEW.iit_num_attrib103;
   nm3inv.g_rec_iit.iit_num_attrib104         := :NEW.iit_num_attrib104;
   nm3inv.g_rec_iit.iit_num_attrib105         := :NEW.iit_num_attrib105;
   nm3inv.g_rec_iit.iit_num_attrib106         := :NEW.iit_num_attrib106;
   nm3inv.g_rec_iit.iit_num_attrib107         := :NEW.iit_num_attrib107;
   nm3inv.g_rec_iit.iit_num_attrib108         := :NEW.iit_num_attrib108;
   nm3inv.g_rec_iit.iit_num_attrib109         := :NEW.iit_num_attrib109;
   nm3inv.g_rec_iit.iit_num_attrib110         := :NEW.iit_num_attrib110;
   nm3inv.g_rec_iit.iit_num_attrib111         := :NEW.iit_num_attrib111;
   nm3inv.g_rec_iit.iit_num_attrib112         := :NEW.iit_num_attrib112;
   nm3inv.g_rec_iit.iit_num_attrib113         := :NEW.iit_num_attrib113;
   nm3inv.g_rec_iit.iit_num_attrib114         := :NEW.iit_num_attrib114;
   nm3inv.g_rec_iit.iit_num_attrib115         := :NEW.iit_num_attrib115;
   nm3inv.g_rec_iit.iit_date_created          := :NEW.iit_date_created;
   nm3inv.g_rec_iit.iit_date_modified         := :NEW.iit_date_modified;
   nm3inv.g_rec_iit.iit_created_by            := :NEW.iit_created_by;
   nm3inv.g_rec_iit.iit_modified_by           := :NEW.iit_modified_by;
   --
   nm3inv.validate_rec_iit;
   --
   :NEW.iit_ne_id                             := nm3inv.g_rec_iit.iit_ne_id;
   :NEW.iit_inv_type                          := nm3inv.g_rec_iit.iit_inv_type;
   :NEW.iit_primary_key                       := nm3inv.g_rec_iit.iit_primary_key;
   :NEW.iit_start_date                        := nm3inv.g_rec_iit.iit_start_date;
   :NEW.iit_date_created                      := nm3inv.g_rec_iit.iit_date_created;
   :NEW.iit_date_modified                     := nm3inv.g_rec_iit.iit_date_modified;
   :NEW.iit_created_by                        := nm3inv.g_rec_iit.iit_created_by;
   :NEW.iit_modified_by                       := nm3inv.g_rec_iit.iit_modified_by;
   :NEW.iit_admin_unit                        := nm3inv.g_rec_iit.iit_admin_unit;
   :NEW.iit_descr                             := nm3inv.g_rec_iit.iit_descr;
   :NEW.iit_end_date                          := nm3inv.g_rec_iit.iit_end_date;
   :NEW.iit_foreign_key                       := nm3inv.g_rec_iit.iit_foreign_key;
   :NEW.iit_located_by                        := nm3inv.g_rec_iit.iit_located_by;
   :NEW.iit_position                          := nm3inv.g_rec_iit.iit_position;
   :NEW.iit_x_coord                           := nm3inv.g_rec_iit.iit_x_coord;
   :NEW.iit_y_coord                           := nm3inv.g_rec_iit.iit_y_coord;
   :NEW.iit_num_attrib16                      := nm3inv.g_rec_iit.iit_num_attrib16;
   :NEW.iit_num_attrib17                      := nm3inv.g_rec_iit.iit_num_attrib17;
   :NEW.iit_num_attrib18                      := nm3inv.g_rec_iit.iit_num_attrib18;
   :NEW.iit_num_attrib19                      := nm3inv.g_rec_iit.iit_num_attrib19;
   :NEW.iit_num_attrib20                      := nm3inv.g_rec_iit.iit_num_attrib20;
   :NEW.iit_num_attrib21                      := nm3inv.g_rec_iit.iit_num_attrib21;
   :NEW.iit_num_attrib22                      := nm3inv.g_rec_iit.iit_num_attrib22;
   :NEW.iit_num_attrib23                      := nm3inv.g_rec_iit.iit_num_attrib23;
   :NEW.iit_num_attrib24                      := nm3inv.g_rec_iit.iit_num_attrib24;
   :NEW.iit_num_attrib25                      := nm3inv.g_rec_iit.iit_num_attrib25;
   :NEW.iit_chr_attrib26                      := nm3inv.g_rec_iit.iit_chr_attrib26;
   :NEW.iit_chr_attrib27                      := nm3inv.g_rec_iit.iit_chr_attrib27;
   :NEW.iit_chr_attrib28                      := nm3inv.g_rec_iit.iit_chr_attrib28;
   :NEW.iit_chr_attrib29                      := nm3inv.g_rec_iit.iit_chr_attrib29;
   :NEW.iit_chr_attrib30                      := nm3inv.g_rec_iit.iit_chr_attrib30;
   :NEW.iit_chr_attrib31                      := nm3inv.g_rec_iit.iit_chr_attrib31;
   :NEW.iit_chr_attrib32                      := nm3inv.g_rec_iit.iit_chr_attrib32;
   :NEW.iit_chr_attrib33                      := nm3inv.g_rec_iit.iit_chr_attrib33;
   :NEW.iit_chr_attrib34                      := nm3inv.g_rec_iit.iit_chr_attrib34;
   :NEW.iit_chr_attrib35                      := nm3inv.g_rec_iit.iit_chr_attrib35;
   :NEW.iit_chr_attrib36                      := nm3inv.g_rec_iit.iit_chr_attrib36;
   :NEW.iit_chr_attrib37                      := nm3inv.g_rec_iit.iit_chr_attrib37;
   :NEW.iit_chr_attrib38                      := nm3inv.g_rec_iit.iit_chr_attrib38;
   :NEW.iit_chr_attrib39                      := nm3inv.g_rec_iit.iit_chr_attrib39;
   :NEW.iit_chr_attrib40                      := nm3inv.g_rec_iit.iit_chr_attrib40;
   :NEW.iit_chr_attrib41                      := nm3inv.g_rec_iit.iit_chr_attrib41;
   :NEW.iit_chr_attrib42                      := nm3inv.g_rec_iit.iit_chr_attrib42;
   :NEW.iit_chr_attrib43                      := nm3inv.g_rec_iit.iit_chr_attrib43;
   :NEW.iit_chr_attrib44                      := nm3inv.g_rec_iit.iit_chr_attrib44;
   :NEW.iit_chr_attrib45                      := nm3inv.g_rec_iit.iit_chr_attrib45;
   :NEW.iit_chr_attrib46                      := nm3inv.g_rec_iit.iit_chr_attrib46;
   :NEW.iit_chr_attrib47                      := nm3inv.g_rec_iit.iit_chr_attrib47;
   :NEW.iit_chr_attrib48                      := nm3inv.g_rec_iit.iit_chr_attrib48;
   :NEW.iit_chr_attrib49                      := nm3inv.g_rec_iit.iit_chr_attrib49;
   :NEW.iit_chr_attrib50                      := nm3inv.g_rec_iit.iit_chr_attrib50;
   :NEW.iit_chr_attrib51                      := nm3inv.g_rec_iit.iit_chr_attrib51;
   :NEW.iit_chr_attrib52                      := nm3inv.g_rec_iit.iit_chr_attrib52;
   :NEW.iit_chr_attrib53                      := nm3inv.g_rec_iit.iit_chr_attrib53;
   :NEW.iit_chr_attrib54                      := nm3inv.g_rec_iit.iit_chr_attrib54;
   :NEW.iit_chr_attrib55                      := nm3inv.g_rec_iit.iit_chr_attrib55;
   :NEW.iit_chr_attrib56                      := nm3inv.g_rec_iit.iit_chr_attrib56;
   :NEW.iit_chr_attrib57                      := nm3inv.g_rec_iit.iit_chr_attrib57;
   :NEW.iit_chr_attrib58                      := nm3inv.g_rec_iit.iit_chr_attrib58;
   :NEW.iit_chr_attrib59                      := nm3inv.g_rec_iit.iit_chr_attrib59;
   :NEW.iit_chr_attrib60                      := nm3inv.g_rec_iit.iit_chr_attrib60;
   :NEW.iit_chr_attrib61                      := nm3inv.g_rec_iit.iit_chr_attrib61;
   :NEW.iit_chr_attrib62                      := nm3inv.g_rec_iit.iit_chr_attrib62;
   :NEW.iit_chr_attrib63                      := nm3inv.g_rec_iit.iit_chr_attrib63;
   :NEW.iit_chr_attrib64                      := nm3inv.g_rec_iit.iit_chr_attrib64;
   :NEW.iit_chr_attrib65                      := nm3inv.g_rec_iit.iit_chr_attrib65;
   :NEW.iit_chr_attrib66                      := nm3inv.g_rec_iit.iit_chr_attrib66;
   :NEW.iit_chr_attrib67                      := nm3inv.g_rec_iit.iit_chr_attrib67;
   :NEW.iit_chr_attrib68                      := nm3inv.g_rec_iit.iit_chr_attrib68;
   :NEW.iit_chr_attrib69                      := nm3inv.g_rec_iit.iit_chr_attrib69;
   :NEW.iit_chr_attrib70                      := nm3inv.g_rec_iit.iit_chr_attrib70;
   :NEW.iit_chr_attrib71                      := nm3inv.g_rec_iit.iit_chr_attrib71;
   :NEW.iit_chr_attrib72                      := nm3inv.g_rec_iit.iit_chr_attrib72;
   :NEW.iit_chr_attrib73                      := nm3inv.g_rec_iit.iit_chr_attrib73;
   :NEW.iit_chr_attrib74                      := nm3inv.g_rec_iit.iit_chr_attrib74;
   :NEW.iit_chr_attrib75                      := nm3inv.g_rec_iit.iit_chr_attrib75;
   :NEW.iit_num_attrib76                      := nm3inv.g_rec_iit.iit_num_attrib76;
   :NEW.iit_num_attrib77                      := nm3inv.g_rec_iit.iit_num_attrib77;
   :NEW.iit_num_attrib78                      := nm3inv.g_rec_iit.iit_num_attrib78;
   :NEW.iit_num_attrib79                      := nm3inv.g_rec_iit.iit_num_attrib79;
   :NEW.iit_num_attrib80                      := nm3inv.g_rec_iit.iit_num_attrib80;
   :NEW.iit_num_attrib81                      := nm3inv.g_rec_iit.iit_num_attrib81;
   :NEW.iit_num_attrib82                      := nm3inv.g_rec_iit.iit_num_attrib82;
   :NEW.iit_num_attrib83                      := nm3inv.g_rec_iit.iit_num_attrib83;
   :NEW.iit_num_attrib84                      := nm3inv.g_rec_iit.iit_num_attrib84;
   :NEW.iit_num_attrib85                      := nm3inv.g_rec_iit.iit_num_attrib85;
   :NEW.iit_date_attrib86                     := nm3inv.g_rec_iit.iit_date_attrib86;
   :NEW.iit_date_attrib87                     := nm3inv.g_rec_iit.iit_date_attrib87;
   :NEW.iit_date_attrib88                     := nm3inv.g_rec_iit.iit_date_attrib88;
   :NEW.iit_date_attrib89                     := nm3inv.g_rec_iit.iit_date_attrib89;
   :NEW.iit_date_attrib90                     := nm3inv.g_rec_iit.iit_date_attrib90;
   :NEW.iit_date_attrib91                     := nm3inv.g_rec_iit.iit_date_attrib91;
   :NEW.iit_date_attrib92                     := nm3inv.g_rec_iit.iit_date_attrib92;
   :NEW.iit_date_attrib93                     := nm3inv.g_rec_iit.iit_date_attrib93;
   :NEW.iit_date_attrib94                     := nm3inv.g_rec_iit.iit_date_attrib94;
   :NEW.iit_date_attrib95                     := nm3inv.g_rec_iit.iit_date_attrib95;
   :NEW.iit_angle                             := nm3inv.g_rec_iit.iit_angle;
   :NEW.iit_angle_txt                         := nm3inv.g_rec_iit.iit_angle_txt;
   :NEW.iit_class                             := nm3inv.g_rec_iit.iit_class;
   :NEW.iit_class_txt                         := nm3inv.g_rec_iit.iit_class_txt;
   :NEW.iit_colour                            := nm3inv.g_rec_iit.iit_colour;
   :NEW.iit_colour_txt                        := nm3inv.g_rec_iit.iit_colour_txt;
   :NEW.iit_coord_flag                        := nm3inv.g_rec_iit.iit_coord_flag;
   :NEW.iit_description                       := nm3inv.g_rec_iit.iit_description;
   :NEW.iit_diagram                           := nm3inv.g_rec_iit.iit_diagram;
   :NEW.iit_distance                          := nm3inv.g_rec_iit.iit_distance;
   :NEW.iit_end_chain                         := nm3inv.g_rec_iit.iit_end_chain;
   :NEW.iit_gap                               := nm3inv.g_rec_iit.iit_gap;
   :NEW.iit_height                            := nm3inv.g_rec_iit.iit_height;
   :NEW.iit_height_2                          := nm3inv.g_rec_iit.iit_height_2;
   :NEW.iit_id_code                           := nm3inv.g_rec_iit.iit_id_code;
   :NEW.iit_instal_date                       := nm3inv.g_rec_iit.iit_instal_date;
   :NEW.iit_invent_date                       := nm3inv.g_rec_iit.iit_invent_date;
   :NEW.iit_inv_ownership                     := nm3inv.g_rec_iit.iit_inv_ownership;
   :NEW.iit_itemcode                          := nm3inv.g_rec_iit.iit_itemcode;
   :NEW.iit_lco_lamp_config_id                := nm3inv.g_rec_iit.iit_lco_lamp_config_id;
   :NEW.iit_length                            := nm3inv.g_rec_iit.iit_length;
   :NEW.iit_material                          := nm3inv.g_rec_iit.iit_material;
   :NEW.iit_material_txt                      := nm3inv.g_rec_iit.iit_material_txt;
   :NEW.iit_method                            := nm3inv.g_rec_iit.iit_method;
   :NEW.iit_method_txt                        := nm3inv.g_rec_iit.iit_method_txt;
   :NEW.iit_note                              := nm3inv.g_rec_iit.iit_note;
   :NEW.iit_no_of_units                       := nm3inv.g_rec_iit.iit_no_of_units;
   :NEW.iit_options                           := nm3inv.g_rec_iit.iit_options;
   :NEW.iit_options_txt                       := nm3inv.g_rec_iit.iit_options_txt;
   :NEW.iit_oun_org_id_elec_board             := nm3inv.g_rec_iit.iit_oun_org_id_elec_board;
   :NEW.iit_owner                             := nm3inv.g_rec_iit.iit_owner;
   :NEW.iit_owner_txt                         := nm3inv.g_rec_iit.iit_owner_txt;
   :NEW.iit_peo_invent_by_id                  := nm3inv.g_rec_iit.iit_peo_invent_by_id;
   :NEW.iit_photo                             := nm3inv.g_rec_iit.iit_photo;
   :NEW.iit_power                             := nm3inv.g_rec_iit.iit_power;
   :NEW.iit_prov_flag                         := nm3inv.g_rec_iit.iit_prov_flag;
   :NEW.iit_rev_by                            := nm3inv.g_rec_iit.iit_rev_by;
   :NEW.iit_rev_date                          := nm3inv.g_rec_iit.iit_rev_date;
   :NEW.iit_type                              := nm3inv.g_rec_iit.iit_type;
   :NEW.iit_type_txt                          := nm3inv.g_rec_iit.iit_type_txt;
   :NEW.iit_width                             := nm3inv.g_rec_iit.iit_width;
   :NEW.iit_xtra_char_1                       := nm3inv.g_rec_iit.iit_xtra_char_1;
   :NEW.iit_xtra_date_1                       := nm3inv.g_rec_iit.iit_xtra_date_1;
   :NEW.iit_xtra_domain_1                     := nm3inv.g_rec_iit.iit_xtra_domain_1;
   :NEW.iit_xtra_domain_txt_1                 := nm3inv.g_rec_iit.iit_xtra_domain_txt_1;
   :NEW.iit_xtra_number_1                     := nm3inv.g_rec_iit.iit_xtra_number_1;
   :NEW.iit_x_sect                            := nm3inv.g_rec_iit.iit_x_sect;
   :NEW.iit_det_xsp                           := nm3inv.g_rec_iit.iit_det_xsp;
   :NEW.iit_offset                            := nm3inv.g_rec_iit.iit_offset;
   :NEW.iit_x                                 := nm3inv.g_rec_iit.iit_x;
   :NEW.iit_y                                 := nm3inv.g_rec_iit.iit_y;
   :NEW.iit_z                                 := nm3inv.g_rec_iit.iit_z;
   :NEW.iit_num_attrib96                      := nm3inv.g_rec_iit.iit_num_attrib96;
   :NEW.iit_num_attrib97                      := nm3inv.g_rec_iit.iit_num_attrib97;
   :NEW.iit_num_attrib98                      := nm3inv.g_rec_iit.iit_num_attrib98;
   :NEW.iit_num_attrib99                      := nm3inv.g_rec_iit.iit_num_attrib99;
   :NEW.iit_num_attrib100                     := nm3inv.g_rec_iit.iit_num_attrib100;
   :NEW.iit_num_attrib101                     := nm3inv.g_rec_iit.iit_num_attrib101;
   :NEW.iit_num_attrib102                     := nm3inv.g_rec_iit.iit_num_attrib102;
   :NEW.iit_num_attrib103                     := nm3inv.g_rec_iit.iit_num_attrib103;
   :NEW.iit_num_attrib104                     := nm3inv.g_rec_iit.iit_num_attrib104;
   :NEW.iit_num_attrib105                     := nm3inv.g_rec_iit.iit_num_attrib105;
   :NEW.iit_num_attrib106                     := nm3inv.g_rec_iit.iit_num_attrib106;
   :NEW.iit_num_attrib107                     := nm3inv.g_rec_iit.iit_num_attrib107;
   :NEW.iit_num_attrib108                     := nm3inv.g_rec_iit.iit_num_attrib108;
   :NEW.iit_num_attrib109                     := nm3inv.g_rec_iit.iit_num_attrib109;
   :NEW.iit_num_attrib110                     := nm3inv.g_rec_iit.iit_num_attrib110;
   :NEW.iit_num_attrib111                     := nm3inv.g_rec_iit.iit_num_attrib111;
   :NEW.iit_num_attrib112                     := nm3inv.g_rec_iit.iit_num_attrib112;
   :NEW.iit_num_attrib113                     := nm3inv.g_rec_iit.iit_num_attrib113;
   :NEW.iit_num_attrib114                     := nm3inv.g_rec_iit.iit_num_attrib114;
   :NEW.iit_num_attrib115                     := nm3inv.g_rec_iit.iit_num_attrib115;


  END IF;
     
END nm_inv_items_mand_check;
/
