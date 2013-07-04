REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)mig_trans_views.sql	1.6 06/16/05

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
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)mig_trans_views.sql	1.6 06/16/05
--       Module Name      : mig_trans_views.sql
--       Date into SCCS   : 05/06/16 16:31:07
--       Date fetched Out : 07/06/13 14:09:29
--       SCCS Version     : 1.6
--
--  Migration Translation view
--
-----------------------------------------------------------------------------
ne.ne_id,
ne.ne_unique,
ne.ne_admin_unit,
decode(ne.ne_gty_group_type, NULL, 'S', 'G'),
decode(ne.ne_gty_group_type,'LLNK','LINK','DLNK','LINK',ne.ne_gty_group_type),
decode(ne.ne_gty_group_type, NULL, substr(ne.ne_unique, 1, instr(ne.ne_unique, '/') -1), ne.ne_unique) rse_group,
ne.ne_prefix,
decode(decode(ne.ne_gty_group_type,'LLNK','Y','DLNK','Y',null,'Y','N'),'Y',ne.ne_owner,null),
decode(decode(ne.ne_gty_group_type,'LLNK','Y','DLNK','Y',null,'Y','N'),'Y',ne.ne_sub_type||ne.ne_name_1,null),
decode(ne.ne_gty_group_type,NULL, ne.ne_number, NULL),
ne.ne_group,
ne.ne_start_date,
ne.ne_end_date,
ne.ne_descr,
SUBSTR(iit_chr_attrib26
               ,1
               ,1) rse_adoption_status,
iit_num_attrib16 rse_alias,
SUBSTR(iit_chr_attrib27
               ,1
               ,3) rse_bh_hier_code,
SUBSTR(iit_chr_attrib28
               ,1
               ,1) RSE_CARRIAGEWAY_TYPE,
SUBSTR(iit_chr_attrib28
               ,1
               ,6) rse_class_index,
SUBSTR(iit_chr_attrib29
               ,1
               ,1) rse_coord_flag,
iit_date_attrib86 rse_date_adopted,
iit_date_attrib87 rse_date_opened,
SUBSTR(iit_chr_attrib31
               ,1
               ,2) rse_engineering_difficulty,
SUBSTR(iit_chr_attrib32
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
        ,iit_date_attrib89 rse_last_surveyed,
decode(ne.ne_gty_group_type, NULL,get_ne_length( ne.ne_id ), null),
SUBSTR(iit_chr_attrib34
               ,1
               ,2) rse_maint_category
        ,iit_num_attrib21 rse_max_chain
        ,SUBSTR(iit_chr_attrib35
               ,1
               ,2) rse_network_direction
        ,SUBSTR(iit_chr_attrib36
               ,1
               ,1) rse_nla_type
        ,iit_num_attrib22 rse_number_of_lanes,
get_node_name( ne.ne_no_end),
get_node_name( ne.ne_no_start),
SUBSTR(iit_chr_attrib37
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
        ,iit_num_attrib23 rse_search_group_no,
SUBSTR(iit_chr_attrib43
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
        ,iit_num_attrib81 rse_max_mp,
SUBSTR(iit_chr_attrib48
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
     ,nm_members_all  nm
     ,nm_inv_items_all iit
WHERE ne.ne_id = nm.nm_ne_id_of (+)
AND   nm.nm_ne_id_in = iit.iit_ne_id (+)
AND   nm_obj_type (+) = 'NETW'
AND   nm_type (+)     = 'I';

CREATE OR REPLACE FORCE VIEW ROAD_SEG_MEMBS_ALL
(RSM_RSE_HE_ID_IN, RSM_RSE_HE_ID_OF, RSM_START_DATE, RSM_END_DATE, RSM_SEQ_NO, 
 RSM_TYPE, RSM_BEGIN_MP, RSM_END_MP, RSM_ROUTE_BEGIN_MP, RSM_ROUTE_END_MP)
AS 
SELECT
--
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)mig_trans_views.sql	1.6 06/16/05
--       Module Name      : mig_trans_views.sql
--       Date into SCCS   : 05/06/16 16:31:07
--       Date fetched Out : 07/06/13 14:09:29
--       SCCS Version     : 1.6
--
--  Migration Translation view
--
-----------------------------------------------------------------------------
 nm.nm_ne_id_in,
 nm.nm_ne_id_of,
 nm.nm_start_date,
 nm.nm_end_date,
 nm.nm_seq_no,
 DECODE(get_nt_type(nm_ne_id_of), 'D', 'S', 'L', 'S', 'G'),
 nm.nm_begin_mp,
 nm.nm_end_mp,
 nm.nm_slk,
 nm.nm_end_slk
FROM  nm_members_all  nm
WHERE nm_type = 'G';


CREATE OR REPLACE FORCE VIEW SECTION_CLASSES
(SCL_SECT_CLASS, SCL_ROAD_CAT, SCL_DESCR)
AS 
select nsc_sub_class
      ,decode( substr(nsc_nw_type,1,1),'D','T','L','C')
      ,nsc_descr
from   nm_type_subclass;

