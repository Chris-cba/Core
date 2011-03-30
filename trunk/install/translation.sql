REM MAI Translation View creation Script.
REM
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------


CREATE OR REPLACE FORCE VIEW group_types (
gty_group_type,
gty_descr,
gty_exclusive_flag,
gty_mandatory_flag,
gty_search_group_no,
gty_oun_level,
gty_start_date,
gty_end_date,
gty_linear_flag,
gty_linear_units
)
AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
DECODE(ngt.ngt_group_type, 'LLNK', 'LINK', 'DLNK', 'LINK', ngt.ngt_group_type),
ngt.ngt_descr,
ngt.ngt_exclusive_flag,
NULL,
ngt.ngt_search_group_no,
TO_NUMBER(NULL),
ngt.ngt_start_date,
ngt.ngt_end_date,
ngt.ngt_linear_flag,
nt.nt_length_unit
FROM
  nm_group_types ngt,
  nm_types       nt
WHERE
  nt.nt_type = ngt.ngt_nt_type;


CREATE OR REPLACE FORCE VIEW section_classes(
 scl_sect_class,
 scl_road_cat,
 scl_descr
)
as select
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
       nsc_sub_class
      ,decode( substr(nsc_nw_type,1,1),'D','T','L','C')
      ,nsc_descr
from   nm_type_subclass;




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
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
ne.ne_id                                                                                               RSE_HE_ID,
ne.ne_unique                                                                                           rse_unique,
ne.ne_admin_unit 									               rse_admin_unit,
DECODE(ne.ne_gty_group_type, NULL, 'S', 'G') 							       rse_type,
DECODE(ne.ne_gty_group_type,'LLNK','LINK','DLNK','LINK',ne.ne_gty_group_type) 		  	               rse_gty_group_type,
DECODE(ne.ne_gty_group_type, NULL, SUBSTR(ne.ne_unique, 1, INSTR(ne.ne_unique, '/') -1), ne.ne_unique) rse_group,
ne.ne_prefix                                                                                           rse_sys_flag,
DECODE(DECODE(ne.ne_gty_group_type,'LLNK','Y','DLNK','Y',NULL,'Y','N')
             ,'Y',ne.ne_owner,NULL)                                                                    rse_agency,
DECODE(DECODE(ne.ne_gty_group_type,'LLNK','Y','DLNK','Y',NULL,'Y','N')
			 ,'Y',ne.ne_sub_type||ne.ne_name_1,NULL)                                                   rse_linkcode,
DECODE(ne.ne_gty_group_type,NULL, ne.ne_number, NULL)                                                  rse_sect_no,
DECODE(ne.ne_nt_type,'L',linkcode.ne_group,'D',linkcode.ne_group,ne.ne_Group)                          rse_road_number,
ne.ne_start_date                                                                                       rse_start_Date,
ne.ne_end_date                                                                                         rse_end_Date,
ne.ne_descr                                                                                            rse_descr,
SUBSTR(iit_chr_attrib26,1,1)                                                                           rse_adoption_status,
iit_num_attrib16                                                                                       rse_alias,
DECODE(ne.ne_gty_group_type,'LLNK',ne.ne_name_2,'DLNK',ne.ne_name_2)                                   rse_bh_hier_code,
SUBSTR(iit_chr_attrib28,1,1)                                                                           RSE_CARRIAGEWAY_TYPE,
DECODE(ne.ne_nt_type
  ,'L',SUBSTR(iit_chr_attrib28,1,6)   --rse_carriageway_type
      ||iit_num_attrib22             --rse_number_of_lanes
      ||ne.ne_sub_class              --rse_scl_sect_class
      ||SUBSTR(iit_chr_attrib41,1,1) --rse_road_environment
      ||SUBSTR(iit_chr_attrib44,1,1) --rse_shared_items
  ,'D',SUBSTR(iit_chr_attrib28,1,6)   --rse_carriageway_type
      ||iit_num_attrib22             --rse_number_of_lanes
      ||ne.ne_sub_class              --rse_scl_sect_class
      ||SUBSTR(iit_chr_attrib41,1,1) --rse_road_environment
      ||SUBSTR(iit_chr_attrib44,1,1) --rse_shared_items
)                                                                                                      rse_class_index,
SUBSTR(iit_chr_attrib29,1,1)                                                                           rse_coord_flag,
iit_date_attrib86                                                                                      rse_date_adopted,
iit_date_attrib87                                                                                      rse_date_opened,
SUBSTR(iit_chr_attrib31,1,2)                                                                           rse_engineering_difficulty,
SUBSTR(iit_chr_attrib32,1,1)                                                                           rse_footway_category,
TO_NUMBER(NULL)                                                                                        rse_gis_mapid,
TO_NUMBER(NULL)                                                                                        rse_gis_mslink,
TO_NUMBER(NULL)                                                                                        rse_gradient,
iit_num_attrib20                                                                                       rse_hgv_percent,
SUBSTR(iit_chr_attrib33,1,4)                                                                           rse_int_code,
iit_date_attrib88                                                                                      rse_last_inspected,
iit_date_attrib89                                                                                      rse_last_surveyed,
DECODE(ne.ne_gty_group_type, NULL,Get_Ne_Length( ne.ne_id ), NULL)                                     rse_length,
SUBSTR(iit_chr_attrib34,1,2)                                                                           rse_maint_category,
TO_NUMBER(NULL)                                                                                        rse_max_chain,
SUBSTR(iit_chr_attrib35,1,2)                                                                           rse_network_direction,
SUBSTR(iit_chr_attrib36,1,1)                                                                           rse_nla_type,
iit_num_attrib22                                                                                       rse_number_of_lanes,
Get_Node_Name( ne.ne_no_end)                                                                           RSE_PUS_NODE_ID_END,
Get_Node_Name( ne.ne_no_start)                                                                         RSE_PUS_NODE_ID_ST,
SUBSTR(iit_chr_attrib37,1,1)                                                                           rse_record_invent_rev,
SUBSTR(iit_chr_attrib38,1,1)                                                                           rse_ref_coat_flag,
SUBSTR(iit_chr_attrib39,1,2)                                                                           rse_reinstatement_category,
SUBSTR(iit_chr_attrib40,1,1)                                                                           rse_road_category,
SUBSTR(iit_chr_attrib41,1,1)                                                                           rse_road_environment,
SUBSTR(iit_chr_attrib42,1,2)                                                                           rse_road_type,
ne.ne_sub_class                                                                                        RSE_SCL_SECT_CLASS,
iit_num_attrib23                                                                                       rse_search_group_no,
SUBSTR(iit_chr_attrib43,1,1)                                                                           rse_seq_signif,
SUBSTR(iit_chr_attrib44,1,1)                                                                           rse_shared_items,
iit_num_attrib24                                                                                       rse_skid_res,
iit_num_attrib25                                                                                       rse_speed_limit,
SUBSTR(iit_chr_attrib45,1,1)                                                                           rse_status,
SUBSTR(iit_chr_attrib46,1,2)                                                                           rse_traffic_sensitivity,
iit_num_attrib76                                                                                       rse_veh_per_day,
iit_num_attrib77                                                                                       rse_begin_mp,
iit_num_attrib78                                                                                       rse_cnt_code,
iit_num_attrib79                                                                                       rse_couplet_id,
iit_num_attrib80                                                                                       rse_end_mp,
SUBSTR(iit_chr_attrib47,1,2)                                                                           rse_gov_level,
iit_num_attrib81                                                                                       rse_max_mp,
SUBSTR(iit_chr_attrib48,1,2)                                                                           rse_prefix,
iit_num_attrib82                                                                                       rse_route,
SUBSTR(iit_chr_attrib49,1,2)                                                                           rse_suffix,
SUBSTR(iit_chr_attrib50,1,1)                                                                           rse_length_status,
SUBSTR(iit_chr_attrib51,1,1)                                                                           rse_traffic_level,
DECODE(ne.ne_nt_type,'LGT',ne.ne_version_no,'NLGT',ne.ne_version_no,'N')                               rse_net_sel_crt,
iit_num_attrib83                                                                                       rse_usrn_no
FROM  NM_ELEMENTS_ALL ne
     ,NM_NW_AD_LINK_ALL nad
     ,NM_INV_ITEMS_ALL iit
	 ,NM_ELEMENTS_ALL LINKcode
WHERE ne.ne_id = nad.nad_ne_id (+)
AND   nad.nad_iit_ne_id = iit.iit_ne_id (+)
AND   nad.nad_primary_ad(+) = 'Y'
AND   ne.ne_name_2 = linkcode.ne_unique(+);





CREATE OR REPLACE force VIEW road_segments_all
AS
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
*
FROM   road_segs
WHERE  rse_admin_unit IN
     ( SELECT hag_child_admin_unit
       FROM   hig_admin_groups,
              hig_users
       WHERE  hag_parent_admin_unit = hus_admin_unit
       AND    hus_username = USER )
OR
       rse_admin_unit IN
     ( SELECT hau_admin_unit
       FROM   hig_admin_units
       WHERE  hau_level = 1 );


CREATE OR REPLACE FORCE VIEW road_sections_all
AS
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
*
FROM   road_segments_all
WHERE rse_type = 'S';

CREATE OR REPLACE FORCE VIEW hig_admin_groups
(
hag_parent_admin_unit,
hag_child_admin_unit,
hag_direct_link )
AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
nag_parent_admin_unit,
nag_child_admin_unit,
nag_direct_link
FROM nm_admin_groups;


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
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
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


CREATE OR REPLACE FORCE VIEW road_seg_membs
AS
SELECT 
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
* FROM road_seg_membs_all
WHERE RSM_TYPE <> 'P';


--CREATE OR REPLACE FORCE VIEW gis_themes AS
--SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--       *
 --FROM  gis_themes_all
--WHERE EXISTS (SELECT 1
--               FROM  gis_theme_roles
--                    ,hig_user_roles
--               WHERE gthr_theme_id   = gt_theme_id
--                AND  hur_username    = USER
--                AND  gthr_role       = hur_role
--                AND  hur_start_date <= nm3context.get_effective_date
--             );


CREATE OR REPLACE FORCE VIEW frm50_enabled_roles
( ROLE, flag )
AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
       urp.granted_role ROLE,
       SUM(DISTINCT DECODE(rrp.granted_role,
   			'ORAFORMS$OSC',2,
     			'ORAFORMS$BGM',4,
	 		'ORAFORMS$DBG',1,0)) flag
FROM  sys.user_role_privs urp, role_role_privs rrp
WHERE urp.granted_role = rrp.ROLE (+)
  AND urp.granted_role NOT LIKE 'ORAFORMS$%'
  GROUP BY urp.granted_role
UNION
SELECT hmr_module ROLE, 0 flag
FROM hig_module_roles, session_roles, hig_roles, hig_products
WHERE hpr_key IS NOT NULL
AND hpr_product = hro_product
AND hro_role = ROLE
AND hro_role = hmr_role;


CREATE OR REPLACE FORCE VIEW road_segments_all
AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
 *
FROM road_segs
where  rse_admin_unit in
     ( select hag_child_admin_unit
       from   hig_admin_groups,
              hig_users
       where  hag_parent_admin_unit = hus_admin_unit
       and    hus_username = user )
or
       rse_admin_unit in
     ( select hau_admin_unit
       from   hig_admin_units
       where  hau_level = 1 );


CREATE OR REPLACE FORCE VIEW road_segments AS
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
 * FROM road_segments_all
 WHERE RSE_END_DATE IS NULL;


CREATE SYNONYM rse_he_id_seq FOR ne_id_seq;


CREATE OR REPLACE FORCE VIEW road_sections
AS
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
 *
FROM   road_segments_all
WHERE rse_type = 'S'
AND RSE_END_DATE IS NULL;

CREATE SYNONYM road_seg_membs_partial FOR road_seg_membs_all;

CREATE OR REPLACE FORCE VIEW road_groups_all (rse_he_id              ,
rse_unique             ,
rse_admin_unit         ,
rse_type               ,
rse_gty_group_type     ,
rse_group              ,
rse_sys_flag           ,
rse_agency             ,
rse_linkcode           ,
rse_sect_no            ,
rse_start_date         ,
rse_end_date           ,
rse_descr              ,
rse_length             ,
rse_pus_node_id_st     ,
rse_pus_node_id_end,
rse_scl_sect_class  ,
rse_road_type ,
rse_road_environment,
rse_road_number,
rse_net_sel_crt)
AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
rse_he_id              ,
rse_unique             ,
rse_admin_unit         ,
rse_type               ,
rse_gty_group_type     ,
rse_group              ,
rse_sys_flag           ,
rse_agency             ,
rse_linkcode           ,
rse_sect_no            ,
rse_start_date         ,
rse_end_date           ,
rse_descr              ,
rse_length             ,
rse_pus_node_id_st     ,
rse_pus_node_id_end,
rse_scl_sect_class  ,
rse_road_type ,
rse_road_environment,
rse_road_number,
rse_net_sel_crt
FROM road_segments_all, nm_group_types_all
WHERE rse_type in ('G','P')
and rse_gty_group_type = DECODE(ngt_group_type, 'LLNK', 'LINK', 'DLNK', 'LINK', ngt_group_type)
and ngt_partial = 'N';


CREATE OR REPLACE FORCE VIEW road_groups (rse_he_id              ,
rse_unique             ,
rse_admin_unit         ,
rse_type               ,
rse_gty_group_type     ,
rse_group              ,
rse_sys_flag           ,
rse_agency             ,
rse_linkcode           ,
rse_sect_no            ,
rse_start_date         ,
rse_end_date           ,
rse_descr              ,
rse_length             ,
rse_pus_node_id_st     ,
rse_pus_node_id_end,
rse_scl_sect_class  ,
rse_road_type ,
rse_road_environment,
rse_road_number,
rse_net_sel_crt)
AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
* 
FROM  road_groups_all
WHERE RSE_END_DATE IS NULL;

CREATE OR REPLACE FORCE VIEW name_usages
( nus_str_street_id
 ,nus_descr
 ,nus_rse_he_id
) AS
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
 1,'1',1
FROM dual;

CREATE OR REPLACE FORCE VIEW node_usages ( nou_rse_he_id,
nou_pus_node_id, nou_chainage, nou_node_type ) AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
        nnu.nnu_ne_id
       ,no.no_node_name
       ,nnu.nnu_chain
       ,nnu.nnu_node_type
FROM nm_node_usages nnu, nm_nodes no
WHERE nnu.nnu_no_node_id = no.no_node_id;

CREATE OR REPLACE FORCE VIEW point_usages(
 pus_node_id,
 pus_poi_point_id,
 pus_start_date,
 pus_description,
 pus_end_date,
 pus_nis_node_id,
 pus_purpose )
AS
SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
 no_node_name,
no_np_id,
no_start_date,
no_descr,
no_end_date,
NULL,
NULL
FROM nm_nodes_all;

CREATE OR REPLACE FORCE VIEW points
(  poi_point_id,
 poi_description,
 poi_grid_east,
 poi_grid_north)
AS SELECT
-----------------------------------------------------------------------------
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-- Translation View
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
np_id, np_descr, np_grid_east, np_grid_north
FROM nm_points;

prompt Creating View ROAD_TYPES

CREATE OR REPLACE FORCE VIEW ROAD_TYPES as
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)translation.sql	1.41 11/10/06
--       Module Name      : translation.sql
--       Date into SCCS   : 06/11/10 11:55:59
--       Date fetched Out : 07/06/13 13:59:30
--       SCCS Version     : 1.41
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
       select GTY_GROUP_TYPE
             ,GTY_DESCR
             ,GTY_EXCLUSIVE_FLAG
             ,GTY_MANDATORY_FLAG
             ,GTY_SEARCH_GROUP_NO
	     ,GTY_OUN_LEVEL
             ,GTY_START_DATE
             ,GTY_END_DATE
       from   GROUP_TYPES
       union
       select 'SECT'
             ,'ROAD SECTIONS'
             ,'N'
             ,'N'
             ,0
             ,9
             ,to_date('')
             ,to_date('')
       from   dual;
