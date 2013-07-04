--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_inv_items.vw-arc   2.4   Jul 04 2013 11:20:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_inv_items.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:43:30  $
--       Version          : $Revision:   2.4  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
   l_view VARCHAR2(32767);
--
   CURSOR cs_enterprise_edn IS
   SELECT 'x'
    FROM  v$version
   WHERE  banner LIKE '%Enterprise Edition%'
    OR    banner LIKE '%Personal%';
--
   l_dummy cs_enterprise_edn%ROWTYPE;
--
   l_enterprise_edn BOOLEAN;
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_view := l_view||p_text;
   END append;
BEGIN
--
    FOR cs_rec IN (SELECT view_name
                    FROM  user_views
                   WHERE  view_name = 'NM_INV_ITEMS'
                  )
     LOOP
       EXECUTE IMMEDIATE 'DROP VIEW '||cs_rec.view_name;
    END LOOP;
--
   append ('CREATE OR replace force view nm_inv_items AS',FALSE);
   append ('SELECT');
   append ('--');
   append ('--   PVCS Identifiers :-');
   append ('--');
   append ('--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/views/nm_inv_items.vw-arc   2.4   Jul 04 2013 11:20:32   James.Wadsworth  $');
   append ('--       Module Name      : $Workfile:   nm_inv_items.vw  $');
   append ('--       Date into PVCS   : $Date:   Jul 04 2013 11:20:32  $');
   append ('--       Date fetched Out : $Modtime:   Jul 04 2013 10:43:30  $');
   append ('--       PVCS Version     : $Revision:   2.4  $');
   append ('--       Based on SCCS version : 1.6');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('  iit_ne_id, iit_inv_type, iit_primary_key, iit_start_date');
   append (', iit_date_created, iit_date_modified, iit_created_by, iit_modified_by');
   append (', iit_admin_unit, iit_descr, iit_end_date, iit_foreign_key, iit_located_by');
   append (', iit_position, iit_x_coord, iit_y_coord');
   append (', iit_num_attrib16, iit_num_attrib17, iit_num_attrib18, iit_num_attrib19, iit_num_attrib20');
   append (', iit_num_attrib21, iit_num_attrib22, iit_num_attrib23, iit_num_attrib24, iit_num_attrib25');
   append (', iit_chr_attrib26, iit_chr_attrib27, iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30');
   append (', iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33, iit_chr_attrib34, iit_chr_attrib35');
   append (', iit_chr_attrib36, iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39, iit_chr_attrib40');
   append (', iit_chr_attrib41, iit_chr_attrib42, iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45');
   append (', iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48, iit_chr_attrib49, iit_chr_attrib50');
   append (', iit_chr_attrib51, iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54, iit_chr_attrib55');
   append (', iit_chr_attrib56, iit_chr_attrib57, iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60');
   append (', iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63, iit_chr_attrib64, iit_chr_attrib65');
   append (', iit_chr_attrib66, iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69, iit_chr_attrib70');
   append (', iit_chr_attrib71, iit_chr_attrib72, iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75');
   append (', iit_num_attrib76, iit_num_attrib77, iit_num_attrib78, iit_num_attrib79, iit_num_attrib80');
   append (', iit_num_attrib81, iit_num_attrib82, iit_num_attrib83, iit_num_attrib84, iit_num_attrib85');
   append (', iit_date_attrib86, iit_date_attrib87, iit_date_attrib88, iit_date_attrib89, iit_date_attrib90');
   append (', iit_date_attrib91, iit_date_attrib92, iit_date_attrib93, iit_date_attrib94, iit_date_attrib95');
   append (', iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour, iit_colour_txt, iit_coord_flag');
   append (', iit_description, iit_diagram, iit_distance, iit_end_chain, iit_gap, iit_height, iit_height_2');
   append (', iit_id_code, iit_instal_date, iit_invent_date, iit_inv_ownership, iit_itemcode, iit_lco_lamp_config_id');
--   append (', cast(iit_length as number(6)) iit_length');
   append (', iit_length');
   append (', iit_material, iit_material_txt');
   append (', iit_method, iit_method_txt, iit_note, iit_no_of_units, iit_options, iit_options_txt');
   append (', iit_oun_org_id_elec_board, iit_owner, iit_owner_txt, iit_peo_invent_by_id, iit_photo');
   append (', iit_power, iit_prov_flag, iit_rev_by, iit_rev_date, iit_type, iit_type_txt, iit_width');
   append (', iit_xtra_char_1, iit_xtra_date_1, iit_xtra_domain_1, iit_xtra_domain_txt_1');
   append (', iit_xtra_number_1, iit_x_sect, iit_det_xsp, iit_offset, iit_x, iit_y, iit_z');
   append (', iit_num_attrib96, iit_num_attrib97, iit_num_attrib98, iit_num_attrib99, iit_num_attrib100');
   append (', iit_num_attrib101, iit_num_attrib102, iit_num_attrib103, iit_num_attrib104, iit_num_attrib105');
   append (', iit_num_attrib106, iit_num_attrib107, iit_num_attrib108, iit_num_attrib109, iit_num_attrib110');
   append (', iit_num_attrib111, iit_num_attrib112, iit_num_attrib113, iit_num_attrib114, iit_num_attrib115');
   append (' FROM  nm_inv_items_all');
   append ('WHERE  iit_start_date <= To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append (' AND   NVL(iit_end_date,TO_DATE('||CHR(39)||'99991231'||CHR(39)||','||CHR(39)||'YYYYMMDD'||CHR(39)||')) >  To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
--
   OPEN  cs_enterprise_edn;
   FETCH cs_enterprise_edn INTO l_dummy;
   l_enterprise_edn := cs_enterprise_edn%FOUND;
   CLOSE cs_enterprise_edn;
--
   IF NOT l_enterprise_edn
    THEN
      --
      -- If we are running on Standard Edn then put the restrictions which are normally
      --  sorted by the Policies into the views
      --
      append (' AND   EXISTS (SELECT 1');
      append ('                FROM  hig_users');
      append ('               WHERE  hus_username     = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') ');
      append ('                AND   hus_unrestricted = '||CHR(39)||'Y'||CHR(39));
      append ('               UNION');
      append ('               SELECT 1');
      append ('                FROM  dual');
      append ('               WHERE  exists (SELECT 1');
      append ('                               FROM  NM_USER_AUS');
      append ('                                    ,NM_ADMIN_GROUPS');
      append ('                                    ,HIG_USERS');
      append ('                              WHERE  HUS_USERNAME         = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') ');
      append ('                                AND  NUA_USER_ID          = HUS_USER_ID');
      append ('                               AND   NUA_ADMIN_UNIT       = NAG_PARENT_ADMIN_UNIT');
      append ('                               AND   NAG_CHILD_ADMIN_UNIT = iit_admin_unit');
      append ('                             )');
      append ('                       AND');
      append ('                      exists (SELECT 1');
      append ('                               FROM  HIG_USER_ROLES');
      append ('                                    ,NM_INV_TYPE_ROLES');
      append ('                               WHERE ITR_INV_TYPE = iit_inv_type');
      append ('                                AND  ITR_HRO_ROLE = HUR_ROLE');
      append ('                                AND  HUR_USERNAME = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') ');
      append ('                             )');
      append ('              )');
   END IF;
--
   EXECUTE IMMEDIATE l_view;
--
END;
/

