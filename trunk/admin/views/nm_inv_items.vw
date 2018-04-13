--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_inv_items.vw-arc   2.9   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_inv_items.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:34:00  $
--       Version          : $Revision:   2.9  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
   append ('--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_inv_items.vw-arc   2.9   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $');
   append ('--       Module Name      : $Workfile:   nm_inv_items.vw  $');
   append ('--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $');
   append ('--       Date fetched Out : $Modtime:   Apr 13 2018 11:34:00  $');
   append ('--       PVCS Version     : $Revision:   2.9  $');
   append ('--       Based on SCCS version : 1.6');
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('  niia.iit_ne_id, niie.iit_inv_type, niie.iit_primary_key, niia.iit_start_date');
   append (', niie.iit_date_created, niie.iit_date_modified, niie.iit_created_by, niie.iit_modified_by');
   append (', niie.iit_admin_unit, niie.iit_descr, niia.iit_end_date, niie.iit_foreign_key, niie.iit_located_by');
   append (', niie.iit_position, niie.iit_x_coord, niie.iit_y_coord');
   append (', niie.iit_num_attrib16, niie.iit_num_attrib17, niie.iit_num_attrib18, niie.iit_num_attrib19, niie.iit_num_attrib20');
   append (', niie.iit_num_attrib21, niie.iit_num_attrib22, niie.iit_num_attrib23, niie.iit_num_attrib24, niie.iit_num_attrib25');
   append (', niie.iit_chr_attrib26, niie.iit_chr_attrib27, niie.iit_chr_attrib28, niie.iit_chr_attrib29, niie.iit_chr_attrib30');
   append (', niie.iit_chr_attrib31, niie.iit_chr_attrib32, niie.iit_chr_attrib33, niie.iit_chr_attrib34, niie.iit_chr_attrib35');
   append (', niie.iit_chr_attrib36, niie.iit_chr_attrib37, niie.iit_chr_attrib38, niie.iit_chr_attrib39, niie.iit_chr_attrib40');
   append (', niie.iit_chr_attrib41, niie.iit_chr_attrib42, niie.iit_chr_attrib43, niie.iit_chr_attrib44, niie.iit_chr_attrib45');
   append (', niie.iit_chr_attrib46, niie.iit_chr_attrib47, niie.iit_chr_attrib48, niie.iit_chr_attrib49, niie.iit_chr_attrib50');
   append (', niie.iit_chr_attrib51, niie.iit_chr_attrib52, niie.iit_chr_attrib53, niie.iit_chr_attrib54, niie.iit_chr_attrib55');
   append (', niie.iit_chr_attrib56, niie.iit_chr_attrib57, niie.iit_chr_attrib58, niie.iit_chr_attrib59, niie.iit_chr_attrib60');
   append (', niie.iit_chr_attrib61, niie.iit_chr_attrib62, niie.iit_chr_attrib63, niie.iit_chr_attrib64, niie.iit_chr_attrib65');
   append (', niie.iit_chr_attrib66, niie.iit_chr_attrib67, niie.iit_chr_attrib68, niie.iit_chr_attrib69, niie.iit_chr_attrib70');
   append (', niie.iit_chr_attrib71, niie.iit_chr_attrib72, niie.iit_chr_attrib73, niie.iit_chr_attrib74, niie.iit_chr_attrib75');
   append (', niie.iit_num_attrib76, niie.iit_num_attrib77, niie.iit_num_attrib78, niie.iit_num_attrib79, niie.iit_num_attrib80');
   append (', niie.iit_num_attrib81, niie.iit_num_attrib82, niie.iit_num_attrib83, niie.iit_num_attrib84, niie.iit_num_attrib85');
   append (', niie.iit_date_attrib86, niie.iit_date_attrib87, niie.iit_date_attrib88, niie.iit_date_attrib89, niie.iit_date_attrib90');
   append (', niie.iit_date_attrib91, niie.iit_date_attrib92, niie.iit_date_attrib93, niie.iit_date_attrib94, niie.iit_date_attrib95');
   append (', niie.iit_angle, niie.iit_angle_txt, niie.iit_class, niie.iit_class_txt, niie.iit_colour, niie.iit_colour_txt, niie.iit_coord_flag');
   append (', niie.iit_description, niie.iit_diagram, niie.iit_distance, niie.iit_end_chain, niie.iit_gap, niie.iit_height, niie.iit_height_2');
   append (', niie.iit_id_code, niie.iit_instal_date, niie.iit_invent_date, niie.iit_inv_ownership, niie.iit_itemcode, niie.iit_lco_lamp_config_id');
--   append (', cast(niie.iit_length as number(6)) niie.iit_length');
   append (', niie.iit_length');
   append (', niie.iit_material, niie.iit_material_txt');
   append (', niie.iit_method, niie.iit_method_txt, niie.iit_note, niie.iit_no_of_units, niie.iit_options, niie.iit_options_txt');
   append (', niie.iit_oun_org_id_elec_board, niie.iit_owner, niie.iit_owner_txt, niie.iit_peo_invent_by_id, niie.iit_photo');
   append (', niie.iit_power, niie.iit_prov_flag, niie.iit_rev_by, niie.iit_rev_date, niie.iit_type, niie.iit_type_txt, niie.iit_width');
   append (', niie.iit_xtra_char_1, niie.iit_xtra_date_1, niie.iit_xtra_domain_1, niie.iit_xtra_domain_txt_1');
   append (', niie.iit_xtra_number_1, niie.iit_x_sect, niie.iit_det_xsp, niie.iit_offset, niie.iit_x, niie.iit_y, niie.iit_z');
   append (', niie.iit_num_attrib96, niie.iit_num_attrib97, niie.iit_num_attrib98, niie.iit_num_attrib99, niie.iit_num_attrib100');
   append (', niie.iit_num_attrib101, niie.iit_num_attrib102, niie.iit_num_attrib103, niie.iit_num_attrib104, niie.iit_num_attrib105');
   append (', niie.iit_num_attrib106, niie.iit_num_attrib107, niie.iit_num_attrib108, niie.iit_num_attrib109, niie.iit_num_attrib110');
   append (', niie.iit_num_attrib111, niie.iit_num_attrib112, niie.iit_num_attrib113, niie.iit_num_attrib114, niie.iit_num_attrib115');
   append (', niie.iit_audit_type');
   append (' FROM nm_inv_items_eff niie');
   append ('     ,nm_inv_items_all niia');
   append ('WHERE niia.iit_ne_id = niie.parent_ne_id');
   append (' AND niie.iit_start_date <= To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append (' AND NVL(niie.iit_end_date,TO_DATE('||CHR(39)||'99991231'||CHR(39)||','||CHR(39)||'YYYYMMDD'||CHR(39)||')) >  To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append (' AND niie.iit_start_date = (select max(niie2.iit_start_date) from nm_inv_items_eff niie2 where niie2.parent_ne_id = niie.parent_ne_id');
   append (' AND niie2.iit_start_date <= To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append (' AND NVL(niie.iit_end_date,TO_DATE('||CHR(39)||'99991231'||CHR(39)||','||CHR(39)||'YYYYMMDD'||CHR(39)||')) > To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY''))');
   append (' AND NVL(niie.date_created,sysdate) = (select max(NVL(niie3.date_created,sysdate)) FROM nm_inv_items_eff niie3 where niie3.parent_ne_id = niie.parent_ne_id');
   append (' AND niie3.iit_start_date = niie.iit_start_date)');
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
      append ('                               AND   NAG_CHILD_ADMIN_UNIT = niie.iit_admin_unit');
      append ('                             )');
      append ('                       AND');
      append ('                      exists (SELECT 1');
      append ('                               FROM  HIG_USER_ROLES');
      append ('                                    ,NM_INV_TYPE_ROLES');
      append ('                               WHERE ITR_INV_TYPE = niie.iit_inv_type');
      append ('                                AND  ITR_HRO_ROLE = HUR_ROLE');
      append ('                                AND  HUR_USERNAME = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') ');
      append ('                             )');
      append ('              )');
   END IF;
--
  dbms_output.put_line(l_view);
   EXECUTE IMMEDIATE l_view;
--
END;
/

