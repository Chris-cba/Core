REM MAI Norfolk Translation View creation Script.
REM

CREATE OR REPLACE function get_nt_type (pi_ne_id IN nm_elements_all.ne_id%TYPE) RETURN nm_types.nt_type%TYPE IS
BEGIN
  RETURN(nm3net.get_nt_type(pi_ne_id));
END;
/

CREATE OR REPLACE FORCE VIEW ROAD_SEGS
(RSE_HE_ID, RSE_UNIQUE, RSE_ADMIN_UNIT, RSE_TYPE, RSE_GTY_GROUP_TYPE, 
 RSE_GROUP, RSE_SYS_FLAG, RSE_AGENCY, RSE_LINKCODE, RSE_SECT_NO, 
 RSE_ROAD_NUMBER, RSE_START_DATE, RSE_END_DATE, RSE_DESCR, RSE_ADOPTION_STATUS, 
 RSE_ALIAS, RSE_BH_HIER_CODE, RSE_CARRIAGEWAY_TYPE, RSE_CLASS_INDEX, RSE_COORD_FLAG, 
 RSE_DATE_ADOPTED, RSE_DATE_OPENED, RSE_ENGINEERING_DIFFICULTY, RSE_FOOTWAY_CATEGORY, RSE_GIS_MAPID, 
 RSE_GIS_MSLINK, RSE_GRADIENT, RSE_HGV_PERCENT, RSE_INT_CODE, RSE_LAST_INSPECTED, 
 RSE_LAST_SURVEYED, RSE_LENGTH, RSE_MAINT_CATEGORY, RSE_MAX_CHAIN, RSE_NETWORK_DIRECTION, 
 RSE_NLA_TYPE, RSE_NUMBER_OF_LANES, RSE_PUS_NODE_ID_END, RSE_PUS_NODE_ID_ST, RSE_RECORD_INVENT_REV, 
 RSE_REF_COAT_FLAG, RSE_REINSTATEMENT_CATEGORY, RSE_ROAD_CATEGORY, RSE_ROAD_ENVIRONMENT, RSE_ROAD_TYPE, 
 RSE_SCL_SECT_CLASS, RSE_SEARCH_GROUP_NO, RSE_SEQ_SIGNIF, RSE_SHARED_ITEMS, RSE_SKID_RES, 
 RSE_SPEED_LIMIT, RSE_STATUS, RSE_TRAFFIC_SENSITIVITY, RSE_VEH_PER_DAY, RSE_BEGIN_MP, 
 RSE_CNT_CODE, RSE_COUPLET_ID, RSE_END_MP, RSE_GOV_LEVEL, RSE_MAX_MP, 
 RSE_PREFIX, RSE_ROUTE, RSE_SUFFIX, RSE_LENGTH_STATUS, RSE_TRAFFIC_LEVEL, 
 RSE_NET_SEL_CRT, RSE_USRN_NO)
AS 
select 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)norfolk_trans_views.sql	1.5 06/16/05
--       Module Name      : norfolk_trans_views.sql
--       Date into SCCS   : 05/06/16 16:34:49
--       Date fetched Out : 07/06/13 17:07:25
--       SCCS Version     : 1.5
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
ne.ne_id, 
ne.ne_unique, 
ne.ne_admin_unit, 
decode(ne.ne_gty_group_type,NULL,'S', 'SECT', 'S','G'),
decode(ne.ne_gty_group_type, 'D', NULL, 'L', NULL, 'SECT', NULL, ne.ne_gty_group_type), 
decode(ne.ne_gty_group_type, NULL, ne.ne_group, 'SECT', ne.ne_group, ne.ne_group), 
substr(get_sub_type( ne_gty_group_type, ne_nt_type ),1,1) , 
substr(ne.ne_group,1,4), 
substr(ne.ne_group, 5), 
ne.ne_number, 
substr(ne.ne_group, 5, 5), 
ne.ne_start_date, 
ne.ne_end_date, 
ne.ne_descr
        ,SUBSTR(iit_chr_attrib26
               ,1
               ,1) rse_adoption_status
        ,iit_num_attrib16 rse_alias
        ,SUBSTR(iit_chr_attrib27
               ,1
               ,3) rse_bh_hier_code
        ,ne.ne_sub_type
        ,SUBSTR(iit_chr_attrib28
               ,1
               ,6) rse_class_index
        ,SUBSTR(iit_chr_attrib29
               ,1
               ,1) rse_coord_flag 
        ,iit_date_attrib86 rse_date_adopted 
        ,iit_date_attrib87 rse_date_opened
        ,SUBSTR(iit_chr_attrib31
               ,1
               ,2) rse_engineering_difficulty
        ,SUBSTR(iit_chr_attrib32
               ,1
               ,1) rse_footway_category
        ,iit_num_attrib17 rse_gis_mapid
        ,iit_num_attrib18 rse_gis_mslink
        ,iit_num_attrib19 rse_gradient
        ,iit_num_attrib20 rse_hgv_percent
        ,SUBSTR(iit_chr_attrib33
               ,1
               ,4) rse_int_code
        ,iit_date_attrib88 rse_last_inspected
        ,iit_date_attrib89 rse_last_surveyed
        ,get_ne_length( ne.ne_id )
        ,SUBSTR(iit_chr_attrib34
               ,1
               ,2) rse_maint_category
        ,iit_num_attrib21 rse_max_chain
        ,SUBSTR(iit_chr_attrib35
               ,1
               ,2) rse_network_direction
        ,SUBSTR(iit_chr_attrib36
               ,1
               ,1) rse_nla_type
        ,iit_num_attrib22 rse_number_of_lanes
        ,get_node_name( ne.ne_no_end)
        ,get_node_name( ne.ne_no_start)
        ,SUBSTR(iit_chr_attrib37
               ,1
               ,1) rse_record_invent_rev
        ,SUBSTR(iit_chr_attrib38
               ,1
               ,1) rse_ref_coat_flag
        ,SUBSTR(iit_chr_attrib39
               ,1
               ,2) rse_reinstatement_category
        ,SUBSTR(iit_chr_attrib40
               ,1
               ,1) rse_road_category
        ,SUBSTR(iit_chr_attrib41
               ,1
               ,1) rse_road_environment
        ,SUBSTR(iit_chr_attrib42
               ,1
               ,2) rse_road_type
        ,ne.ne_sub_class
        ,iit_num_attrib23 rse_search_group_no
        ,SUBSTR(iit_chr_attrib43
               ,1
               ,1) rse_seq_signif
        ,SUBSTR(iit_chr_attrib44
               ,1
               ,1) rse_shared_items
        ,iit_num_attrib24 rse_skid_res
        ,iit_num_attrib25 rse_speed_limit
        ,SUBSTR(iit_chr_attrib45
               ,1
               ,1) rse_status
        ,SUBSTR(iit_chr_attrib46
               ,1
               ,2) rse_traffic_sensitivity
        ,iit_num_attrib76 rse_veh_per_day
        ,iit_num_attrib77 rse_begin_mp
        ,iit_num_attrib78 rse_cnt_code
        ,iit_num_attrib79 rse_couplet_id
        ,iit_num_attrib80 rse_end_mp
        ,SUBSTR(iit_chr_attrib47
               ,1
               ,2) rse_gov_level
        ,iit_num_attrib81 rse_max_mp
        ,SUBSTR(iit_chr_attrib48
               ,1
               ,2) rse_prefix
        ,iit_num_attrib82 rse_route
        ,SUBSTR(iit_chr_attrib49
               ,1
               ,2) rse_suffix
        ,SUBSTR(iit_chr_attrib50
               ,1
               ,1) rse_length_status
        ,SUBSTR(iit_chr_attrib51
               ,1
               ,1) rse_traffic_level
        ,SUBSTR(iit_chr_attrib52
               ,1
               ,1) rse_net_sel_crt
        ,iit_num_attrib83 rse_usrn_no
FROM  nm_elements_all ne
     ,nm_nw_ad_link_all nad
     ,nm_inv_items_all iit
WHERE ne.ne_id = nad.nad_ne_id (+)
AND   nad.nad_iit_ne_id = iit.iit_ne_id (+);

CREATE OR REPLACE FORCE VIEW road_seg_membs_all(
 rsm_rse_he_id_in,
 rsm_rse_he_id_of,
 rsm_start_date,
 rsm_end_date,
 rsm_seq_no,
 rsm_type,
 rsm_begin_mp,
 rsm_end_mp,
 rsm_route_begin_mp,
 rsm_route_end_mp
)
AS SELECT
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)norfolk_trans_views.sql	1.5 06/16/05
--       Module Name      : norfolk_trans_views.sql
--       Date into SCCS   : 05/06/16 16:34:49
--       Date fetched Out : 07/06/13 17:07:25
--       SCCS Version     : 1.5
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
 nm.nm_ne_id_in,
 nm.nm_ne_id_of,
 nm.nm_start_date,
 nm.nm_end_date,
 nm.nm_seq_no,
 DECODE(get_nt_type(nm_ne_id_of), 'HERM', 'S', 'G'),
 nm.nm_begin_mp,
 nm.nm_end_mp,
 nm.nm_slk,
 nm.nm_end_slk
FROM  nm_members_all  nm
WHERE nm_type = 'G';


CREATE OR REPLACE VIEW INV_ITEMS_ALL
(IIT_CREATED_DATE, IIT_CRE_DATE, IIT_ITEM_ID, IIT_ITY_INV_CODE, IIT_ITY_SYS_FLAG, 
 IIT_LAST_UPDATED_DATE, IIT_RSE_HE_ID, IIT_ST_CHAIN, IIT_ANGLE, IIT_ANGLE_TXT, 
 IIT_CLASS, IIT_CLASS_TXT, IIT_COLOUR, IIT_COLOUR_TXT, IIT_COORD_FLAG, 
 IIT_DESCRIPTION, IIT_DIAGRAM, IIT_DISTANCE, IIT_END_CHAIN, IIT_END_DATE, 
 IIT_GAP, IIT_HEIGHT, IIT_HEIGHT_2, IIT_ID_CODE, IIT_INSTAL_DATE, 
 IIT_INVENT_DATE, IIT_INV_OWNERSHIP, IIT_ITEMCODE, IIT_LCO_LAMP_CONFIG_ID, IIT_LENGTH, 
 IIT_MATERIAL, IIT_MATERIAL_TXT, IIT_METHOD, IIT_METHOD_TXT, IIT_NOTE, 
 IIT_NO_OF_UNITS, IIT_OPTIONS, IIT_OPTIONS_TXT, IIT_OUN_ORG_ID_ELEC_BOARD, IIT_OWNER, 
 IIT_OWNER_TXT, IIT_PEO_INVENT_BY_ID, IIT_PHOTO, IIT_POWER, IIT_PROV_FLAG, 
 IIT_REV_BY, IIT_REV_DATE, IIT_TYPE, IIT_TYPE_TXT, IIT_WIDTH, 
 IIT_XTRA_CHAR_1, IIT_XTRA_DATE_1, IIT_XTRA_DOMAIN_1, IIT_XTRA_DOMAIN_TXT_1, IIT_XTRA_NUMBER_1, 
 IIT_X_SECT, IIT_PRIMARY_KEY, IIT_FOREIGN_KEY, IIT_DET_XSP, IIT_OFFSET, 
 IIT_NUM_ATTRIB16, IIT_NUM_ATTRIB17, IIT_NUM_ATTRIB18, IIT_NUM_ATTRIB19, IIT_NUM_ATTRIB20, 
 IIT_NUM_ATTRIB21, IIT_NUM_ATTRIB22, IIT_NUM_ATTRIB23, IIT_NUM_ATTRIB24, IIT_NUM_ATTRIB25, 
 IIT_CHR_ATTRIB26, IIT_CHR_ATTRIB27, IIT_CHR_ATTRIB28, IIT_CHR_ATTRIB29, IIT_CHR_ATTRIB30, 
 IIT_CHR_ATTRIB31, IIT_CHR_ATTRIB32, IIT_CHR_ATTRIB33, IIT_CHR_ATTRIB34, IIT_CHR_ATTRIB35, 
 IIT_CHR_ATTRIB36, IIT_CHR_ATTRIB37, IIT_CHR_ATTRIB38, IIT_CHR_ATTRIB39, IIT_CHR_ATTRIB40, 
 IIT_CHR_ATTRIB41, IIT_CHR_ATTRIB42, IIT_CHR_ATTRIB43, IIT_CHR_ATTRIB44, IIT_CHR_ATTRIB45, 
 IIT_CHR_ATTRIB46, IIT_CHR_ATTRIB47, IIT_CHR_ATTRIB48, IIT_CHR_ATTRIB49, IIT_CHR_ATTRIB50, 
 IIT_CHR_ATTRIB51, IIT_CHR_ATTRIB52, IIT_CHR_ATTRIB53, IIT_CHR_ATTRIB54, IIT_CHR_ATTRIB55, 
 IIT_CHR_ATTRIB56, IIT_CHR_ATTRIB57, IIT_CHR_ATTRIB58, IIT_CHR_ATTRIB59, IIT_CHR_ATTRIB60, 
 IIT_CHR_ATTRIB61, IIT_CHR_ATTRIB62, IIT_CHR_ATTRIB63, IIT_CHR_ATTRIB64, IIT_CHR_ATTRIB65, 
 IIT_CHR_ATTRIB66, IIT_CHR_ATTRIB67, IIT_CHR_ATTRIB68, IIT_CHR_ATTRIB69, IIT_CHR_ATTRIB70, 
 IIT_CHR_ATTRIB71, IIT_CHR_ATTRIB72, IIT_CHR_ATTRIB73, IIT_CHR_ATTRIB74, IIT_CHR_ATTRIB75, 
 IIT_NUM_ATTRIB76, IIT_NUM_ATTRIB77, IIT_NUM_ATTRIB78, IIT_NUM_ATTRIB79, IIT_NUM_ATTRIB80, 
 IIT_NUM_ATTRIB81, IIT_NUM_ATTRIB82, IIT_NUM_ATTRIB83, IIT_NUM_ATTRIB84, IIT_NUM_ATTRIB85, 
 IIT_DATE_ATTRIB86, IIT_DATE_ATTRIB87, IIT_DATE_ATTRIB88, IIT_DATE_ATTRIB89, IIT_DATE_ATTRIB90, 
 IIT_DATE_ATTRIB91, IIT_DATE_ATTRIB92, IIT_DATE_ATTRIB93, IIT_DATE_ATTRIB94, IIT_DATE_ATTRIB95)
AS 
SELECT 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)norfolk_trans_views.sql	1.5 06/16/05
--       Module Name      : norfolk_trans_views.sql
--       Date into SCCS   : 05/06/16 16:34:49
--       Date fetched Out : 07/06/13 17:07:25
--       SCCS Version     : 1.5
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
          iit_date_created iit_created_date, iit_start_date iit_cre_date
        , inv.iit_ne_id iit_item_id, itt.ity_inv_code iit_ity_inv_code
        , itt.ity_sys_flag iit_ity_sys_flag
        , iit_date_modified iit_last_updated_date
        , inv_loc.pl_ne_id iit_rse_he_id, inv_loc.pl_start iit_st_chain
        , iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour
        , iit_colour_txt, iit_coord_flag, iit_description, iit_diagram
        , iit_distance, inv_loc.pl_end iit_end_chain, iit_end_date, iit_gap
        , iit_height, iit_height_2, iit_id_code, iit_instal_date
        , iit_invent_date, iit_inv_ownership, iit_itemcode
        , iit_lco_lamp_config_id, iit_length, iit_material, iit_material_txt
        , iit_method, iit_method_txt, iit_note, iit_no_of_units, iit_options
        , iit_options_txt, iit_oun_org_id_elec_board, iit_owner
        , iit_owner_txt, iit_peo_invent_by_id, iit_photo, iit_power
        , iit_prov_flag, iit_rev_by, iit_rev_date, iit_type, iit_type_txt
        , iit_width, iit_xtra_char_1, iit_xtra_date_1, iit_xtra_domain_1
        , iit_xtra_domain_txt_1, iit_xtra_number_1, iit_x_sect
        , iit_primary_key, iit_foreign_key, iit_det_xsp, iit_offset
        , iit_num_attrib16, iit_num_attrib17, iit_num_attrib18
        , iit_num_attrib19, iit_num_attrib20, iit_num_attrib21
        , iit_num_attrib22, iit_num_attrib23, iit_num_attrib24
        , iit_num_attrib25, iit_chr_attrib26, iit_chr_attrib27
        , iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30
        , iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33
        , iit_chr_attrib34, iit_chr_attrib35, iit_chr_attrib36
        , iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39
        , iit_chr_attrib40, iit_chr_attrib41, iit_chr_attrib42
        , iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45
        , iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48
        , iit_chr_attrib49, iit_chr_attrib50, iit_chr_attrib51
        , iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54
        , iit_chr_attrib55, iit_chr_attrib56, iit_chr_attrib57
        , iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60
        , iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63
        , iit_chr_attrib64, iit_chr_attrib65, iit_chr_attrib66
        , iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69
        , iit_chr_attrib70, iit_chr_attrib71, iit_chr_attrib72
        , iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75
        , iit_num_attrib76, iit_num_attrib77, iit_num_attrib78
        , iit_num_attrib79, iit_num_attrib80, iit_num_attrib81
        , iit_num_attrib82, iit_num_attrib83, iit_num_attrib84
        , iit_num_attrib85, iit_date_attrib86, iit_date_attrib87
        , iit_date_attrib88, iit_date_attrib89, iit_date_attrib90
        , iit_date_attrib91, iit_date_attrib92, iit_date_attrib93
        , iit_date_attrib94, iit_date_attrib95
     FROM nm_inv_items_all inv
        , nm2_inv_locations_tab inv_loc
        , inv_type_translations itt
    WHERE inv_loc.iit_ne_id = inv.iit_ne_id
          AND itt.nit_inv_type = iit_inv_type;
          
CREATE OR REPLACE TRIGGER INV_ITEMS_I_TRG
 INSTEAD OF INSERT
 ON INV_ITEMS_ALL
 FOR EACH ROW
DECLARE
--
   CURSOR cs_check (c_pk       nm_inv_items.iit_primary_key%TYPE
                   ,c_inv_type nm_inv_items.iit_inv_type%TYPE
                   ) IS
   SELECT ROWID
    FROM  nm_inv_items
   WHERE  iit_primary_key = c_pk
    AND   iit_inv_type    = c_inv_type;
--
   l_rec_iit    nm_inv_items%ROWTYPE;
   l_temp_ne_id NUMBER;
   l_inv_rowid  UROWID;
   l_effective_date DATE;
   l_warning_code VARCHAR2(80);
   l_warning_msg  VARCHAR2(80);
   l_pl_arr nm_placement_array;
--
BEGIN
--
   l_effective_date := nm3user.get_effective_date;
   nm3user.set_effective_date(:NEW.IIT_CRE_DATE);

--
   l_rec_iit.iit_ne_id := nm3net.get_next_ne_id;
--
   l_rec_iit.iit_start_date := TRUNC(:NEW.IIT_CRE_DATE);
   l_rec_iit.iit_inv_type := ity_to_nit(:NEW.IIT_ITY_INV_CODE);
   l_rec_iit.iit_ANGLE := :NEW.IIT_ANGLE;
   l_rec_iit.iit_ANGLE_TXT := :NEW.IIT_ANGLE_TXT;
   l_rec_iit.iit_CLASS := :NEW.IIT_CLASS;
   l_rec_iit.iit_CLASS_TXT := :NEW.IIT_CLASS_TXT;
   l_rec_iit.iit_COLOUR := :NEW.IIT_COLOUR;
   l_rec_iit.iit_COLOUR_TXT := :NEW.IIT_COLOUR_TXT;
   l_rec_iit.iit_COORD_FLAG := :NEW.IIT_COORD_FLAG;
   l_rec_iit.iit_DESCRIPTION := :NEW.IIT_DESCRIPTION;
   l_rec_iit.iit_DIAGRAM := :NEW.IIT_DIAGRAM;
   l_rec_iit.iit_DISTANCE := :NEW.IIT_DISTANCE;
   l_rec_iit.iit_END_DATE := :NEW.IIT_END_DATE;
   l_rec_iit.iit_GAP:= :NEW.IIT_GAP;
   l_rec_iit.iit_HEIGHT := :NEW.IIT_HEIGHT;
   l_rec_iit.iit_HEIGHT_2 := :NEW.IIT_HEIGHT_2;
   l_rec_iit.iit_ID_CODE := :NEW.IIT_ID_CODE;
   l_rec_iit.iit_INSTAL_DATE := :NEW.IIT_INSTAL_DATE;
   l_rec_iit.iit_INVENT_DATE := :NEW.IIT_INVENT_DATE;
   l_rec_iit.iit_INV_OWNERSHIP := :NEW.IIT_INV_OWNERSHIP;
   l_rec_iit.iit_ITEMCODE := :NEW.IIT_ITEMCODE;
   l_rec_iit.iit_LCO_LAMP_CONFIG_ID := :NEW.IIT_LCO_LAMP_CONFIG_ID;
   l_rec_iit.iit_LENGTH := :NEW.IIT_LENGTH;
   l_rec_iit.iit_MATERIAL := :NEW.IIT_MATERIAL;
   l_rec_iit.iit_MATERIAL_TXT := :NEW.IIT_MATERIAL_TXT;
   l_rec_iit.iit_METHOD := :NEW.IIT_METHOD;
   l_rec_iit.iit_METHOD_TXT := :NEW.IIT_METHOD_TXT;
   l_rec_iit.iit_NOTE := :NEW.IIT_NOTE;
   l_rec_iit.iit_NO_OF_UNITS := :NEW.IIT_NO_OF_UNITS;
   l_rec_iit.iit_OPTIONS := :NEW.IIT_OPTIONS;
   l_rec_iit.iit_OPTIONS_TXT := :NEW.IIT_OPTIONS_TXT;
   l_rec_iit.iit_OUN_ORG_ID_ELEC_BOARD := :NEW.IIT_OUN_ORG_ID_ELEC_BOARD;
   l_rec_iit.iit_OWNER := :NEW.IIT_OWNER;
   l_rec_iit.iit_OWNER_TXT := :NEW.IIT_OWNER_TXT;
   l_rec_iit.iit_PEO_INVENT_BY_ID := :NEW.IIT_PEO_INVENT_BY_ID;
   l_rec_iit.iit_PHOTO := :NEW.IIT_PHOTO;
   l_rec_iit.iit_POWER := :NEW.IIT_POWER;
   l_rec_iit.iit_PROV_FLAG := :NEW.IIT_PROV_FLAG;
   l_rec_iit.iit_REV_BY := :NEW.IIT_REV_BY;
   l_rec_iit.iit_REV_DATE := :NEW.IIT_REV_DATE;
   l_rec_iit.iit_TYPE := :NEW.IIT_TYPE;
   l_rec_iit.iit_TYPE_TXT := :NEW.IIT_TYPE_TXT;
   l_rec_iit.iit_WIDTH := :NEW.IIT_WIDTH;
   l_rec_iit.iit_XTRA_CHAR_1 := :NEW.IIT_XTRA_CHAR_1;
   l_rec_iit.iit_XTRA_DATE_1 := :NEW.IIT_XTRA_DATE_1;
   l_rec_iit.iit_XTRA_DOMAIN_1 := :NEW.IIT_XTRA_DOMAIN_1;
   l_rec_iit.iit_XTRA_DOMAIN_TXT_1 := :NEW.IIT_XTRA_DOMAIN_TXT_1;
   l_rec_iit.iit_XTRA_NUMBER_1 := :NEW.IIT_XTRA_NUMBER_1;
   l_rec_iit.iit_X_SECT := :NEW.IIT_X_SECT;
   l_rec_iit.iit_PRIMARY_KEY := :NEW.IIT_PRIMARY_KEY;
   l_rec_iit.iit_FOREIGN_KEY := :NEW.IIT_FOREIGN_KEY;
   l_rec_iit.iit_DET_XSP := :NEW.IIT_DET_XSP;
   l_rec_iit.iit_OFFSET := :NEW.IIT_OFFSET;
   l_rec_iit.iit_NUM_ATTRIB16 := :NEW.IIT_NUM_ATTRIB16;
   l_rec_iit.iit_NUM_ATTRIB17 := :NEW.IIT_NUM_ATTRIB17;
   l_rec_iit.iit_NUM_ATTRIB18 := :NEW.IIT_NUM_ATTRIB18;
   l_rec_iit.iit_NUM_ATTRIB19 := :NEW.IIT_NUM_ATTRIB19;
   l_rec_iit.iit_NUM_ATTRIB20 := :NEW.IIT_NUM_ATTRIB20;
   l_rec_iit.iit_NUM_ATTRIB21 := :NEW.IIT_NUM_ATTRIB21;
   l_rec_iit.iit_NUM_ATTRIB22 := :NEW.IIT_NUM_ATTRIB22;
   l_rec_iit.iit_NUM_ATTRIB23 := :NEW.IIT_NUM_ATTRIB23;
   l_rec_iit.iit_NUM_ATTRIB24 := :NEW.IIT_NUM_ATTRIB24;
   l_rec_iit.iit_NUM_ATTRIB25 := :NEW.IIT_NUM_ATTRIB25;
   l_rec_iit.iit_CHR_ATTRIB26 := :NEW.IIT_CHR_ATTRIB26;
   l_rec_iit.iit_CHR_ATTRIB27 := :NEW.IIT_CHR_ATTRIB27;
   l_rec_iit.iit_CHR_ATTRIB28 := :NEW.IIT_CHR_ATTRIB28;
   l_rec_iit.iit_CHR_ATTRIB29 := :NEW.IIT_CHR_ATTRIB29;
   l_rec_iit.iit_CHR_ATTRIB30 := :NEW.IIT_CHR_ATTRIB30;
   l_rec_iit.iit_CHR_ATTRIB31 := :NEW.IIT_CHR_ATTRIB31;
   l_rec_iit.iit_CHR_ATTRIB32 := :NEW.IIT_CHR_ATTRIB32;
   l_rec_iit.iit_CHR_ATTRIB33 := :NEW.IIT_CHR_ATTRIB33;
   l_rec_iit.iit_CHR_ATTRIB34 := :NEW.IIT_CHR_ATTRIB34;
   l_rec_iit.iit_CHR_ATTRIB35 := :NEW.IIT_CHR_ATTRIB35;
   l_rec_iit.iit_CHR_ATTRIB36 := :NEW.IIT_CHR_ATTRIB36;
   l_rec_iit.iit_CHR_ATTRIB37 := :NEW.IIT_CHR_ATTRIB37;
   l_rec_iit.iit_CHR_ATTRIB38 := :NEW.IIT_CHR_ATTRIB38;
   l_rec_iit.iit_CHR_ATTRIB39 := :NEW.IIT_CHR_ATTRIB39;
   l_rec_iit.iit_CHR_ATTRIB40 := :NEW.IIT_CHR_ATTRIB40;
   l_rec_iit.iit_CHR_ATTRIB41 := :NEW.IIT_CHR_ATTRIB41;
   l_rec_iit.iit_CHR_ATTRIB42 := :NEW.IIT_CHR_ATTRIB42;
   l_rec_iit.iit_CHR_ATTRIB43 := :NEW.IIT_CHR_ATTRIB43;
   l_rec_iit.iit_CHR_ATTRIB44 := :NEW.IIT_CHR_ATTRIB44;
   l_rec_iit.iit_CHR_ATTRIB45 := :NEW.IIT_CHR_ATTRIB45;
   l_rec_iit.iit_CHR_ATTRIB46 := :NEW.IIT_CHR_ATTRIB46;
   l_rec_iit.iit_CHR_ATTRIB47 := :NEW.IIT_CHR_ATTRIB47;
   l_rec_iit.iit_CHR_ATTRIB48 := :NEW.IIT_CHR_ATTRIB48;
   l_rec_iit.iit_CHR_ATTRIB49 := :NEW.IIT_CHR_ATTRIB49;
   l_rec_iit.iit_CHR_ATTRIB50 := :NEW.IIT_CHR_ATTRIB50;
   l_rec_iit.iit_CHR_ATTRIB51 := :NEW.IIT_CHR_ATTRIB51;
   l_rec_iit.iit_CHR_ATTRIB52 := :NEW.IIT_CHR_ATTRIB52;
   l_rec_iit.iit_CHR_ATTRIB53 := :NEW.IIT_CHR_ATTRIB53;
   l_rec_iit.iit_CHR_ATTRIB54 := :NEW.IIT_CHR_ATTRIB54;
   l_rec_iit.iit_CHR_ATTRIB55 := :NEW.IIT_CHR_ATTRIB55;
   l_rec_iit.iit_CHR_ATTRIB56 := :NEW.IIT_CHR_ATTRIB56;
   l_rec_iit.iit_CHR_ATTRIB57 := :NEW.IIT_CHR_ATTRIB57;
   l_rec_iit.iit_CHR_ATTRIB58 := :NEW.IIT_CHR_ATTRIB58;
   l_rec_iit.iit_CHR_ATTRIB59 := :NEW.IIT_CHR_ATTRIB59;
   l_rec_iit.iit_CHR_ATTRIB60 := :NEW.IIT_CHR_ATTRIB60;
   l_rec_iit.iit_CHR_ATTRIB61 := :NEW.IIT_CHR_ATTRIB61;
   l_rec_iit.iit_CHR_ATTRIB62 := :NEW.IIT_CHR_ATTRIB62;
   l_rec_iit.iit_CHR_ATTRIB63 := :NEW.IIT_CHR_ATTRIB63;
   l_rec_iit.iit_CHR_ATTRIB64 := :NEW.IIT_CHR_ATTRIB64;
   l_rec_iit.iit_CHR_ATTRIB65 := :NEW.IIT_CHR_ATTRIB65;
   l_rec_iit.iit_CHR_ATTRIB66 := :NEW.IIT_CHR_ATTRIB66;
   l_rec_iit.iit_CHR_ATTRIB67 := :NEW.IIT_CHR_ATTRIB67;
   l_rec_iit.iit_CHR_ATTRIB68 := :NEW.IIT_CHR_ATTRIB68;
   l_rec_iit.iit_CHR_ATTRIB69 := :NEW.IIT_CHR_ATTRIB69;
   l_rec_iit.iit_CHR_ATTRIB70 := :NEW.IIT_CHR_ATTRIB70;
   l_rec_iit.iit_CHR_ATTRIB71 := :NEW.IIT_CHR_ATTRIB71;
   l_rec_iit.iit_CHR_ATTRIB72 := :NEW.IIT_CHR_ATTRIB72;
   l_rec_iit.iit_CHR_ATTRIB73 := :NEW.IIT_CHR_ATTRIB73;
   l_rec_iit.iit_CHR_ATTRIB74 := :NEW.IIT_CHR_ATTRIB74;
   l_rec_iit.iit_CHR_ATTRIB75 := :NEW.IIT_CHR_ATTRIB75;
   l_rec_iit.iit_NUM_ATTRIB76 := :NEW.IIT_NUM_ATTRIB76;
   l_rec_iit.iit_NUM_ATTRIB77 := :NEW.IIT_NUM_ATTRIB77;
   l_rec_iit.iit_NUM_ATTRIB78 := :NEW.IIT_NUM_ATTRIB78;
   l_rec_iit.iit_NUM_ATTRIB79 := :NEW.IIT_NUM_ATTRIB79;
   l_rec_iit.iit_NUM_ATTRIB80 := :NEW.IIT_NUM_ATTRIB80;
   l_rec_iit.iit_NUM_ATTRIB81 := :NEW.IIT_NUM_ATTRIB81;
   l_rec_iit.iit_NUM_ATTRIB82 := :NEW.IIT_NUM_ATTRIB82;
   l_rec_iit.iit_NUM_ATTRIB83 := :NEW.IIT_NUM_ATTRIB83;
   l_rec_iit.iit_NUM_ATTRIB84 := :NEW.IIT_NUM_ATTRIB84;
   l_rec_iit.iit_NUM_ATTRIB85 := :NEW.IIT_NUM_ATTRIB85;
   l_rec_iit.iit_DATE_ATTRIB86 := :NEW.IIT_DATE_ATTRIB86;
   l_rec_iit.iit_DATE_ATTRIB87 := :NEW.IIT_DATE_ATTRIB87;
   l_rec_iit.iit_DATE_ATTRIB88 := :NEW.IIT_DATE_ATTRIB88;
   l_rec_iit.iit_DATE_ATTRIB89 := :NEW.IIT_DATE_ATTRIB89;
   l_rec_iit.iit_DATE_ATTRIB90 := :NEW.IIT_DATE_ATTRIB90;
   l_rec_iit.iit_DATE_ATTRIB91 := :NEW.IIT_DATE_ATTRIB91;
   l_rec_iit.iit_DATE_ATTRIB92 := :NEW.IIT_DATE_ATTRIB92;
   l_rec_iit.iit_DATE_ATTRIB93 := :NEW.IIT_DATE_ATTRIB93;
   l_rec_iit.iit_DATE_ATTRIB94 := :NEW.IIT_DATE_ATTRIB94;
   l_rec_iit.iit_DATE_ATTRIB95 := :NEW.IIT_DATE_ATTRIB95;
--
   IF l_rec_iit.iit_start_date IS NULL
    THEN
      l_rec_iit.iit_start_date := nm3user.get_effective_date;
   END IF;
--
   IF l_rec_iit.iit_primary_key IS NULL
    THEN
      l_rec_iit.iit_primary_key := l_rec_iit.iit_ne_id;
   END IF;
--
-- Derive admin unit from road
--
   IF l_rec_iit.iit_admin_unit IS NULL
    THEN
	   l_rec_iit.iit_admin_unit := nvl(nm3get.get_ne (pi_ne_id => :NEW.iit_rse_he_id).ne_admin_unit,1);
--      l_rec_iit.iit_admin_unit  := 1;
   END IF;
--
--
   OPEN  cs_check (l_rec_iit.iit_primary_key, l_rec_iit.iit_inv_type);
   FETCH cs_check INTO l_inv_rowid;
   IF cs_check%FOUND
    THEN
      UPDATE nm_inv_items
       SET   iit_end_date = nvl(l_rec_iit.iit_start_date,l_rec_iit.iit_end_date)
      WHERE  ROWID        = l_inv_rowid
        AND  l_rec_iit.iit_end_date IS NULL;
   END IF;
   CLOSE cs_check;
--
   IF l_rec_iit.iit_end_date IS NULL THEN
      nm3inv.insert_nm_inv_items (l_rec_iit);
   END IF;
--
--
   IF l_rec_iit.iit_end_date IS NOT NULL THEN
      l_rec_iit.iit_ne_id :=
      nm3xml_load.get_existing_inv_item( pi_inv_type   => l_rec_iit.iit_inv_type
                                        ,pi_nte_job_id => l_temp_ne_id
                                        ,pi_end_date => l_rec_iit.iit_end_date
                                       );
--
      l_temp_ne_id := NM3XML_LOAD.GET_TEMP_EXTENT( pi_iit_ne_id  => l_rec_iit.iit_ne_id
                                                  ,pi_nte_job_id => l_temp_ne_id
                                                 );
--
      l_rec_iit.iit_start_date := l_rec_iit.iit_END_date;
--
   END IF;
--
   if :new.iit_rse_he_id is null then
     raise_application_error(-20099, 'Inventory view requires a location');
   else


--   create a temp extent from the rse_he_id of the object and locate the asset relativeto this.

     nm3extent.create_temp_ne
        (pi_source_id => :new.iit_rse_he_id
        ,pi_source    => nm3extent.c_route
        ,pi_begin_mp  => :NEW.iit_st_chain
        ,pi_end_mp    => :NEW.iit_end_chain
        ,po_job_id    => l_temp_ne_id
       );

   end if;

   IF l_temp_ne_id = -1 THEN

      nm3homo.end_inv_location( pi_iit_ne_id      => l_rec_iit.iit_ne_id
                               ,pi_effective_date => l_rec_iit.iit_start_date
                               ,po_warning_code   => l_warning_code
                               ,po_warning_msg    => l_warning_msg
                               ,pi_ignore_item_loc_mand => true
                              );
   ELSE
      IF l_temp_ne_id IS NOT NULL THEN

         nm3homo.homo_update
           (p_temp_ne_id_in  => l_temp_ne_id
           ,p_iit_ne_id      => l_rec_iit.iit_ne_id
           ,p_effective_date => l_rec_iit.iit_start_date
           );
      END IF;
   END IF;
--
   nm3user.set_effective_date(l_effective_date);
--
EXCEPTION
   WHEN OTHERS THEN
       nm3user.set_effective_date(l_effective_date);
       RAISE;
END inv_items_i_trg;
/

CREATE OR REPLACE TRIGGER inv_items_u_trg
 INSTEAD OF UPDATE
 ON inv_items_all
 FOR EACH ROW
DECLARE
--
   l_rec_iit        nm_inv_items%ROWTYPE;
   l_temp_ne_id     NUMBER;
   l_warning_code   VARCHAR2(80);
   l_warning_msg    VARCHAR2(80);
   l_pl_arr nm_placement_array;
--
BEGIN
--
   IF :NEW.iit_item_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001
	                         , 'No item id');
   END IF;
--
   IF :NEW.iit_item_id != :OLD.iit_item_id THEN
      RAISE_APPLICATION_ERROR(-20002
	                         , 'Update of item id not allowed');
   END IF;
--
   IF :NEW.iit_rse_he_id != :OLD.iit_rse_he_id THEN
      RAISE_APPLICATION_ERROR(-20003
	                         , 'Update of rse_he_id not allowed');
   END IF;
--
   IF :NEW.iit_rse_he_id IS NULL THEN
      RAISE_APPLICATION_ERROR(-20004
	                         , 'Inventory view requires a location');
   END IF;
   
    
--
   l_rec_iit.iit_ne_id         := :NEW.iit_item_id;
   l_rec_iit.iit_start_date    := :NEW.iit_cre_date;
   l_rec_iit.iit_ne_id         := :NEW.iit_item_id;
   l_rec_iit.iit_inv_type      := ity_to_nit(:NEW.iit_ity_inv_code);
   l_rec_iit.iit_angle         := :NEW.iit_angle;
   l_rec_iit.iit_angle_txt     := :NEW.iit_angle_txt;
   l_rec_iit.iit_class         := :NEW.iit_class;
   l_rec_iit.iit_class_txt     := :NEW.iit_class_txt;
   l_rec_iit.iit_colour        := :NEW.iit_colour;
   l_rec_iit.iit_colour_txt    := :NEW.iit_colour_txt;
   l_rec_iit.iit_coord_flag    := :NEW.iit_coord_flag;
   l_rec_iit.iit_description   := :NEW.iit_description;
   l_rec_iit.iit_diagram       := :NEW.iit_diagram;
   l_rec_iit.iit_distance      := :NEW.iit_distance;
   l_rec_iit.iit_end_date      :=  TRUNC(:NEW.iit_end_date);
   l_rec_iit.iit_gap           := :NEW.iit_gap;
   l_rec_iit.iit_height        := :NEW.iit_height;
   l_rec_iit.iit_height_2      := :NEW.iit_height_2;
   l_rec_iit.iit_id_code       := :NEW.iit_id_code;
   l_rec_iit.iit_instal_date   := :NEW.iit_instal_date;
   l_rec_iit.iit_invent_date   := :NEW.iit_invent_date;
   l_rec_iit.iit_inv_ownership := :NEW.iit_inv_ownership;
   l_rec_iit.iit_itemcode      := :NEW.iit_itemcode;
   l_rec_iit.iit_lco_lamp_config_id :=
                                  :NEW.iit_lco_lamp_config_id;
   l_rec_iit.iit_length        := :NEW.iit_length;
   l_rec_iit.iit_material      := :NEW.iit_material;
   l_rec_iit.iit_material_txt  := :NEW.iit_material_txt;
   l_rec_iit.iit_method        := :NEW.iit_method;
   l_rec_iit.iit_method_txt    := :NEW.iit_method_txt;
   l_rec_iit.iit_note          := :NEW.iit_note;
   l_rec_iit.iit_no_of_units   := :NEW.iit_no_of_units;
   l_rec_iit.iit_options       := :NEW.iit_options;
   l_rec_iit.iit_options_txt   := :NEW.iit_options_txt;
   l_rec_iit.iit_oun_org_id_elec_board :=
                                  :NEW.iit_oun_org_id_elec_board;
   l_rec_iit.iit_owner         := :NEW.iit_owner;
   l_rec_iit.iit_owner_txt     := :NEW.iit_owner_txt;
   l_rec_iit.iit_peo_invent_by_id :=
                                  :NEW.iit_peo_invent_by_id;
   l_rec_iit.iit_photo         := :NEW.iit_photo;
   l_rec_iit.iit_power         := :NEW.iit_power;
   l_rec_iit.iit_prov_flag     := :NEW.iit_prov_flag;
   l_rec_iit.iit_rev_by        := :NEW.iit_rev_by;
   l_rec_iit.iit_rev_date      := :NEW.iit_rev_date;
   l_rec_iit.iit_type          := :NEW.iit_type;
   l_rec_iit.iit_type_txt      := :NEW.iit_type_txt;
   l_rec_iit.iit_width         := :NEW.iit_width;
   l_rec_iit.iit_xtra_char_1   := :NEW.iit_xtra_char_1;
   l_rec_iit.iit_xtra_date_1   := :NEW.iit_xtra_date_1;
   l_rec_iit.iit_xtra_domain_1 := :NEW.iit_xtra_domain_1;
   l_rec_iit.iit_xtra_domain_txt_1 :=
                                  :NEW.iit_xtra_domain_txt_1;
   l_rec_iit.iit_xtra_number_1 := :NEW.iit_xtra_number_1;
   l_rec_iit.iit_x_sect        := :NEW.iit_x_sect;
   l_rec_iit.iit_primary_key   := :NEW.iit_primary_key;
   l_rec_iit.iit_foreign_key   := :NEW.iit_foreign_key;
   l_rec_iit.iit_det_xsp       := :NEW.iit_det_xsp;
   l_rec_iit.iit_offset        := :NEW.iit_offset;
   l_rec_iit.iit_num_attrib16  := :NEW.iit_num_attrib16;
   l_rec_iit.iit_num_attrib17  := :NEW.iit_num_attrib17;
   l_rec_iit.iit_num_attrib18  := :NEW.iit_num_attrib18;
   l_rec_iit.iit_num_attrib19  := :NEW.iit_num_attrib19;
   l_rec_iit.iit_num_attrib20  := :NEW.iit_num_attrib20;
   l_rec_iit.iit_num_attrib21  := :NEW.iit_num_attrib21;
   l_rec_iit.iit_num_attrib22  := :NEW.iit_num_attrib22;
   l_rec_iit.iit_num_attrib23  := :NEW.iit_num_attrib23;
   l_rec_iit.iit_num_attrib24  := :NEW.iit_num_attrib24;
   l_rec_iit.iit_num_attrib25  := :NEW.iit_num_attrib25;
   l_rec_iit.iit_chr_attrib26  := :NEW.iit_chr_attrib26;
   l_rec_iit.iit_chr_attrib27  := :NEW.iit_chr_attrib27;
   l_rec_iit.iit_chr_attrib28  := :NEW.iit_chr_attrib28;
   l_rec_iit.iit_chr_attrib29  := :NEW.iit_chr_attrib29;
   l_rec_iit.iit_chr_attrib30  := :NEW.iit_chr_attrib30;
   l_rec_iit.iit_chr_attrib31  := :NEW.iit_chr_attrib31;
   l_rec_iit.iit_chr_attrib32  := :NEW.iit_chr_attrib32;
   l_rec_iit.iit_chr_attrib33  := :NEW.iit_chr_attrib33;
   l_rec_iit.iit_chr_attrib34  := :NEW.iit_chr_attrib34;
   l_rec_iit.iit_chr_attrib35  := :NEW.iit_chr_attrib35;
   l_rec_iit.iit_chr_attrib36  := :NEW.iit_chr_attrib36;
   l_rec_iit.iit_chr_attrib37  := :NEW.iit_chr_attrib37;
   l_rec_iit.iit_chr_attrib38  := :NEW.iit_chr_attrib38;
   l_rec_iit.iit_chr_attrib39  := :NEW.iit_chr_attrib39;
   l_rec_iit.iit_chr_attrib40  := :NEW.iit_chr_attrib40;
   l_rec_iit.iit_chr_attrib41  := :NEW.iit_chr_attrib41;
   l_rec_iit.iit_chr_attrib42  := :NEW.iit_chr_attrib42;
   l_rec_iit.iit_chr_attrib43  := :NEW.iit_chr_attrib43;
   l_rec_iit.iit_chr_attrib44  := :NEW.iit_chr_attrib44;
   l_rec_iit.iit_chr_attrib45  := :NEW.iit_chr_attrib45;
   l_rec_iit.iit_chr_attrib46  := :NEW.iit_chr_attrib46;
   l_rec_iit.iit_chr_attrib47  := :NEW.iit_chr_attrib47;
   l_rec_iit.iit_chr_attrib48  := :NEW.iit_chr_attrib48;
   l_rec_iit.iit_chr_attrib49  := :NEW.iit_chr_attrib49;
   l_rec_iit.iit_chr_attrib50  := :NEW.iit_chr_attrib50;
   l_rec_iit.iit_chr_attrib51  := :NEW.iit_chr_attrib51;
   l_rec_iit.iit_chr_attrib52  := :NEW.iit_chr_attrib52;
   l_rec_iit.iit_chr_attrib53  := :NEW.iit_chr_attrib53;
   l_rec_iit.iit_chr_attrib54  := :NEW.iit_chr_attrib54;
   l_rec_iit.iit_chr_attrib55  := :NEW.iit_chr_attrib55;
   l_rec_iit.iit_chr_attrib56  := :NEW.iit_chr_attrib56;
   l_rec_iit.iit_chr_attrib57  := :NEW.iit_chr_attrib57;
   l_rec_iit.iit_chr_attrib58  := :NEW.iit_chr_attrib58;
   l_rec_iit.iit_chr_attrib59  := :NEW.iit_chr_attrib59;
   l_rec_iit.iit_chr_attrib60  := :NEW.iit_chr_attrib60;
   l_rec_iit.iit_chr_attrib61  := :NEW.iit_chr_attrib61;
   l_rec_iit.iit_chr_attrib62  := :NEW.iit_chr_attrib62;
   l_rec_iit.iit_chr_attrib63  := :NEW.iit_chr_attrib63;
   l_rec_iit.iit_chr_attrib64  := :NEW.iit_chr_attrib64;
   l_rec_iit.iit_chr_attrib65  := :NEW.iit_chr_attrib65;
   l_rec_iit.iit_chr_attrib66  := :NEW.iit_chr_attrib66;
   l_rec_iit.iit_chr_attrib67  := :NEW.iit_chr_attrib67;
   l_rec_iit.iit_chr_attrib68  := :NEW.iit_chr_attrib68;
   l_rec_iit.iit_chr_attrib69  := :NEW.iit_chr_attrib69;
   l_rec_iit.iit_chr_attrib70  := :NEW.iit_chr_attrib70;
   l_rec_iit.iit_chr_attrib71  := :NEW.iit_chr_attrib71;
   l_rec_iit.iit_chr_attrib72  := :NEW.iit_chr_attrib72;
   l_rec_iit.iit_chr_attrib73  := :NEW.iit_chr_attrib73;
   l_rec_iit.iit_chr_attrib74  := :NEW.iit_chr_attrib74;
   l_rec_iit.iit_chr_attrib75  := :NEW.iit_chr_attrib75;
   l_rec_iit.iit_num_attrib76  := :NEW.iit_num_attrib76;
   l_rec_iit.iit_num_attrib77  := :NEW.iit_num_attrib77;
   l_rec_iit.iit_num_attrib78  := :NEW.iit_num_attrib78;
   l_rec_iit.iit_num_attrib79  := :NEW.iit_num_attrib79;
   l_rec_iit.iit_num_attrib80  := :NEW.iit_num_attrib80;
   l_rec_iit.iit_num_attrib81  := :NEW.iit_num_attrib81;
   l_rec_iit.iit_num_attrib82  := :NEW.iit_num_attrib82;
   l_rec_iit.iit_num_attrib83  := :NEW.iit_num_attrib83;
   l_rec_iit.iit_num_attrib84  := :NEW.iit_num_attrib84;
   l_rec_iit.iit_num_attrib85  := :NEW.iit_num_attrib85;
   l_rec_iit.iit_date_attrib86 := :NEW.iit_date_attrib86;
   l_rec_iit.iit_date_attrib87 := :NEW.iit_date_attrib87;
   l_rec_iit.iit_date_attrib88 := :NEW.iit_date_attrib88;
   l_rec_iit.iit_date_attrib89 := :NEW.iit_date_attrib89;
   l_rec_iit.iit_date_attrib90 := :NEW.iit_date_attrib90;
   l_rec_iit.iit_date_attrib91 := :NEW.iit_date_attrib91;
   l_rec_iit.iit_date_attrib92 := :NEW.iit_date_attrib92;
   l_rec_iit.iit_date_attrib93 := :NEW.iit_date_attrib93;
   l_rec_iit.iit_date_attrib94 := :NEW.iit_date_attrib94;
   l_rec_iit.iit_date_attrib95 := :NEW.iit_date_attrib95;
--
   IF l_rec_iit.iit_primary_key IS NULL THEN
      l_rec_iit.iit_primary_key := l_rec_iit.iit_ne_id;
   END IF;

   IF :NEW.iit_st_chain  != :OLD.iit_st_chain
   OR :NEW.iit_end_chain != :OLD.iit_end_chain THEN

      l_temp_ne_id := nm3xml_load.get_temp_extent
          ( pi_iit_ne_id  => l_rec_iit.iit_ne_id
          , pi_nte_job_id => l_temp_ne_id );

      nm3extent.create_temp_ne
          ( pi_source_id  => :NEW.iit_rse_he_id
          , pi_source     => nm3extent.c_route
          , pi_begin_mp   => :NEW.iit_st_chain
          , pi_end_mp     => :NEW.iit_end_chain
          , po_job_id     => l_temp_ne_id );

       IF l_temp_ne_id = -1 THEN
              nm3homo.end_inv_location( pi_iit_ne_id      => l_rec_iit.iit_ne_id
                                   ,pi_effective_date => l_rec_iit.iit_start_date
                                   ,po_warning_code   => l_warning_code
                                   ,po_warning_msg    => l_warning_msg
                                   ,pi_ignore_item_loc_mand => TRUE
                                  );
       ELSE
           nm3homo.homo_update
               (p_temp_ne_id_in  => l_temp_ne_id
               ,p_iit_ne_id      => l_rec_iit.iit_ne_id
               ,p_effective_date => l_rec_iit.iit_start_date
               );
       END IF;
    
       -- refresh the nm3 inventory locations table
        
   END IF;
   
      
   UPDATE nm_inv_items
      SET iit_angle         = :NEW.iit_angle
         ,iit_angle_txt     = :NEW.iit_angle_txt
         ,iit_class         = :NEW.iit_class
         ,iit_class_txt     = :NEW.iit_class_txt
         ,iit_colour        = :NEW.iit_colour
         ,iit_colour_txt    = :NEW.iit_colour_txt
         ,iit_coord_flag    = :NEW.iit_coord_flag
         ,iit_description   = :NEW.iit_description
         ,iit_diagram       = :NEW.iit_diagram
         ,iit_distance      = :NEW.iit_distance
         ,iit_end_date      = TRUNC(:NEW.iit_end_date)
         ,iit_gap           = :NEW.iit_gap
         ,iit_height        = :NEW.iit_height
         ,iit_height_2      = :NEW.iit_height_2
         ,iit_id_code       = :NEW.iit_id_code
         ,iit_instal_date   = :NEW.iit_instal_date
         ,iit_invent_date   = :NEW.iit_invent_date
         ,iit_inv_ownership = :NEW.iit_inv_ownership
         ,iit_itemcode      = :NEW.iit_itemcode
         ,iit_lco_lamp_config_id = :NEW.iit_lco_lamp_config_id
         ,iit_length        = :NEW.iit_length
         ,iit_material      = :NEW.iit_material
         ,iit_material_txt  = :NEW.iit_material_txt
         ,iit_method        = :NEW.iit_method
         ,iit_method_txt    = :NEW.iit_method_txt
         ,iit_note          = :NEW.iit_note
         ,iit_no_of_units   = :NEW.iit_no_of_units
         ,iit_options       = :NEW.iit_options
         ,iit_options_txt   = :NEW.iit_options_txt
         ,iit_oun_org_id_elec_board = :NEW.iit_oun_org_id_elec_board
         ,iit_owner         = :NEW.iit_owner
         ,iit_owner_txt     = :NEW.iit_owner_txt
         ,iit_peo_invent_by_id = :NEW.iit_peo_invent_by_id
         ,iit_photo         = :NEW.iit_photo
         ,iit_power         = :NEW.iit_power
         ,iit_prov_flag     = :NEW.iit_prov_flag
         ,iit_rev_by        = :NEW.iit_rev_by
         ,iit_rev_date      = :NEW.iit_rev_date
         ,iit_type          = :NEW.iit_type
         ,iit_type_txt      = :NEW.iit_type_txt
         ,iit_width         = :NEW.iit_width
         ,iit_xtra_char_1   = :NEW.iit_xtra_char_1
         ,iit_xtra_date_1   = :NEW.iit_xtra_date_1
         ,iit_xtra_domain_1 = :NEW.iit_xtra_domain_1
         ,iit_xtra_domain_txt_1 = :NEW.iit_xtra_domain_txt_1
         ,iit_xtra_number_1 = :NEW.iit_xtra_number_1
         ,iit_x_sect        = :NEW.iit_x_sect
         ,iit_primary_key   = :NEW.iit_primary_key
         ,iit_foreign_key   = :NEW.iit_foreign_key
         ,iit_det_xsp       = :NEW.iit_det_xsp
         ,iit_offset        = :NEW.iit_offset
         ,iit_num_attrib16  = :NEW.iit_num_attrib16
         ,iit_num_attrib17  = :NEW.iit_num_attrib17
         ,iit_num_attrib18  = :NEW.iit_num_attrib18
         ,iit_num_attrib19  = :NEW.iit_num_attrib19
         ,iit_num_attrib20  = :NEW.iit_num_attrib20
         ,iit_num_attrib21  = :NEW.iit_num_attrib21
         ,iit_num_attrib22  = :NEW.iit_num_attrib22
         ,iit_num_attrib23  = :NEW.iit_num_attrib23
         ,iit_num_attrib24  = :NEW.iit_num_attrib24
         ,iit_num_attrib25  = :NEW.iit_num_attrib25
         ,iit_chr_attrib26  = :NEW.iit_chr_attrib26
         ,iit_chr_attrib27  = :NEW.iit_chr_attrib27
         ,iit_chr_attrib28  = :NEW.iit_chr_attrib28
         ,iit_chr_attrib29  = :NEW.iit_chr_attrib29
         ,iit_chr_attrib30  = :NEW.iit_chr_attrib30
         ,iit_chr_attrib31  = :NEW.iit_chr_attrib31
         ,iit_chr_attrib32  = :NEW.iit_chr_attrib32
         ,iit_chr_attrib33  = :NEW.iit_chr_attrib33
         ,iit_chr_attrib34  = :NEW.iit_chr_attrib34
         ,iit_chr_attrib35  = :NEW.iit_chr_attrib35
         ,iit_chr_attrib36  = :NEW.iit_chr_attrib36
         ,iit_chr_attrib37  = :NEW.iit_chr_attrib37
         ,iit_chr_attrib38  = :NEW.iit_chr_attrib38
         ,iit_chr_attrib39  = :NEW.iit_chr_attrib39
         ,iit_chr_attrib40  = :NEW.iit_chr_attrib40
         ,iit_chr_attrib41  = :NEW.iit_chr_attrib41
         ,iit_chr_attrib42  = :NEW.iit_chr_attrib42
         ,iit_chr_attrib43  = :NEW.iit_chr_attrib43
         ,iit_chr_attrib44  = :NEW.iit_chr_attrib44
         ,iit_chr_attrib45  = :NEW.iit_chr_attrib45
         ,iit_chr_attrib46  = :NEW.iit_chr_attrib46
         ,iit_chr_attrib47  = :NEW.iit_chr_attrib47
         ,iit_chr_attrib48  = :NEW.iit_chr_attrib48
         ,iit_chr_attrib49  = :NEW.iit_chr_attrib49
         ,iit_chr_attrib50  = :NEW.iit_chr_attrib50
         ,iit_chr_attrib51  = :NEW.iit_chr_attrib51
         ,iit_chr_attrib52  = :NEW.iit_chr_attrib52
         ,iit_chr_attrib53  = :NEW.iit_chr_attrib53
         ,iit_chr_attrib54  = :NEW.iit_chr_attrib54
         ,iit_chr_attrib55  = :NEW.iit_chr_attrib55
         ,iit_chr_attrib56  = :NEW.iit_chr_attrib56
         ,iit_chr_attrib57  = :NEW.iit_chr_attrib57
         ,iit_chr_attrib58  = :NEW.iit_chr_attrib58
         ,iit_chr_attrib59  = :NEW.iit_chr_attrib59
         ,iit_chr_attrib60  = :NEW.iit_chr_attrib60
         ,iit_chr_attrib61  = :NEW.iit_chr_attrib61
         ,iit_chr_attrib62  = :NEW.iit_chr_attrib62
         ,iit_chr_attrib63  = :NEW.iit_chr_attrib63
         ,iit_chr_attrib64  = :NEW.iit_chr_attrib64
         ,iit_chr_attrib65  = :NEW.iit_chr_attrib65
         ,iit_chr_attrib66  = :NEW.iit_chr_attrib66
         ,iit_chr_attrib67  = :NEW.iit_chr_attrib67
         ,iit_chr_attrib68  = :NEW.iit_chr_attrib68
         ,iit_chr_attrib69  = :NEW.iit_chr_attrib69
         ,iit_chr_attrib70  = :NEW.iit_chr_attrib70
         ,iit_chr_attrib71  = :NEW.iit_chr_attrib71
         ,iit_chr_attrib72  = :NEW.iit_chr_attrib72
         ,iit_chr_attrib73  = :NEW.iit_chr_attrib73
         ,iit_chr_attrib74  = :NEW.iit_chr_attrib74
         ,iit_chr_attrib75  = :NEW.iit_chr_attrib75
         ,iit_num_attrib76  = :NEW.iit_num_attrib76
         ,iit_num_attrib77  = :NEW.iit_num_attrib77
         ,iit_num_attrib78  = :NEW.iit_num_attrib78
         ,iit_num_attrib79  = :NEW.iit_num_attrib79
         ,iit_num_attrib80  = :NEW.iit_num_attrib80
         ,iit_num_attrib81  = :NEW.iit_num_attrib81
         ,iit_num_attrib82  = :NEW.iit_num_attrib82
         ,iit_num_attrib83  = :NEW.iit_num_attrib83
         ,iit_num_attrib84  = :NEW.iit_num_attrib84
         ,iit_num_attrib85  = :NEW.iit_num_attrib85
         ,iit_date_attrib86 = :NEW.iit_date_attrib86
         ,iit_date_attrib87 = :NEW.iit_date_attrib87
         ,iit_date_attrib88 = :NEW.iit_date_attrib88
         ,iit_date_attrib89 = :NEW.iit_date_attrib89
         ,iit_date_attrib90 = :NEW.iit_date_attrib90
         ,iit_date_attrib91 = :NEW.iit_date_attrib91
         ,iit_date_attrib92 = :NEW.iit_date_attrib92
         ,iit_date_attrib93 = :NEW.iit_date_attrib93
         ,iit_date_attrib94 = :NEW.iit_date_attrib94
         ,iit_date_attrib95 = :NEW.iit_date_attrib95
       WHERE iit_ne_id         = :NEW.iit_item_id;

END inv_items_u_trg;
/

CREATE OR REPLACE TRIGGER INV_ITEMS_D_TRG
 INSTEAD OF DELETE
 ON INV_ITEMS_ALL
 FOR EACH ROW
--
BEGIN
--
   nm3inv.delete_inv_items(pi_inv_type        => :OLD.iit_ity_inv_code
                          ,pi_cascade         => TRUE
                          ,pi_where           => 'iit_ne_id = '||:old.iit_item_id);
--

END inv_items_d_trg;
/
