--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/road_segments_all.vw-arc   1.3   Feb 15 2016 12:08:28   Rob.Coupe  $
--       Module Name      : $Workfile:   road_segments_all.vw  $
--       Date into SCCS   : $Date:   Feb 15 2016 12:08:28  $
--       Date fetched Out : $Modtime:   Feb 15 2016 12:08:20  $
--       SCCS Version     : $Revision:   1.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

-- script to create new, unrestricted views for use in Locator on HE systems
--

CREATE OR REPLACE FORCE VIEW ROAD_SEGMENTS_ALL
(
   RSE_HE_ID,
   RSE_UNIQUE,
   RSE_ADMIN_UNIT,
   RSE_TYPE,
   RSE_GTY_GROUP_TYPE,
   RSE_GROUP,
   RSE_SYS_FLAG,
   RSE_AGENCY,
   RSE_LINKCODE,
   RSE_SECT_NO,
   RSE_ROAD_NUMBER,
   RSE_START_DATE,
   RSE_END_DATE,
   RSE_DESCR,
   RSE_ADOPTION_STATUS,
   RSE_ALIAS,
   RSE_BH_HIER_CODE,
   RSE_CARRIAGEWAY_TYPE,
   RSE_CLASS_INDEX,
   RSE_COORD_FLAG,
   RSE_DATE_ADOPTED,
   RSE_DATE_OPENED,
   RSE_ENGINEERING_DIFFICULTY,
   RSE_FOOTWAY_CATEGORY,
   RSE_GIS_MAPID,
   RSE_GIS_MSLINK,
   RSE_GRADIENT,
   RSE_HGV_PERCENT,
   RSE_INT_CODE,
   RSE_LAST_INSPECTED,
   RSE_LAST_SURVEYED,
   RSE_LENGTH,
   RSE_MAINT_CATEGORY,
   RSE_MAX_CHAIN,
   RSE_NETWORK_DIRECTION,
   RSE_NLA_TYPE,
   RSE_NUMBER_OF_LANES,
   RSE_PUS_NODE_ID_END,
   RSE_PUS_NODE_ID_ST,
   RSE_RECORD_INVENT_REV,
   RSE_REF_COAT_FLAG,
   RSE_REINSTATEMENT_CATEGORY,
   RSE_ROAD_CATEGORY,
   RSE_ROAD_ENVIRONMENT,
   RSE_ROAD_TYPE,
   RSE_SCL_SECT_CLASS,
   RSE_SEARCH_GROUP_NO,
   RSE_SEQ_SIGNIF,
   RSE_SHARED_ITEMS,
   RSE_SKID_RES,
   RSE_SPEED_LIMIT,
   RSE_STATUS,
   RSE_TRAFFIC_SENSITIVITY,
   RSE_VEH_PER_DAY,
   RSE_BEGIN_MP,
   RSE_CNT_CODE,
   RSE_COUPLET_ID,
   RSE_END_MP,
   RSE_GOV_LEVEL,
   RSE_MAX_MP,
   RSE_PREFIX,
   RSE_ROUTE,
   RSE_SUFFIX,
   RSE_LENGTH_STATUS,
   RSE_TRAFFIC_LEVEL,
   RSE_NET_SEL_CRT,
   RSE_USRN_NO,
   RSE_SECT_FUNC
)
AS
SELECT 
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/road_segments_all.vw-arc   1.3   Feb 15 2016 12:08:28   Rob.Coupe  $
--       Module Name      : $Workfile:   road_segments_all.vw  $
--       Date into SCCS   : $Date:   Feb 15 2016 12:08:28  $
--       Date fetched Out : $Modtime:   Feb 15 2016 12:08:20  $
--       SCCS Version     : $Revision:   1.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- script to create new view definition to work with unrestricted network on HE systems
--
         "RSE_HE_ID",
         "RSE_UNIQUE",
         "RSE_ADMIN_UNIT",
         "RSE_TYPE",
         "RSE_GTY_GROUP_TYPE",
         "RSE_GROUP",
         "RSE_SYS_FLAG",
         "RSE_AGENCY",
         "RSE_LINKCODE",
         "RSE_SECT_NO",
         "RSE_ROAD_NUMBER",
         "RSE_START_DATE",
         "RSE_END_DATE",
         "RSE_DESCR",
         "RSE_ADOPTION_STATUS",
         "RSE_ALIAS",
         "RSE_BH_HIER_CODE",
         "RSE_CARRIAGEWAY_TYPE",
         "RSE_CLASS_INDEX",
         "RSE_COORD_FLAG",
         "RSE_DATE_ADOPTED",
         "RSE_DATE_OPENED",
         "RSE_ENGINEERING_DIFFICULTY",
         "RSE_FOOTWAY_CATEGORY",
         "RSE_GIS_MAPID",
         "RSE_GIS_MSLINK",
         "RSE_GRADIENT",
         "RSE_HGV_PERCENT",
         "RSE_INT_CODE",
         "RSE_LAST_INSPECTED",
         "RSE_LAST_SURVEYED",
         "RSE_LENGTH",
         "RSE_MAINT_CATEGORY",
         "RSE_MAX_CHAIN",
         "RSE_NETWORK_DIRECTION",
         "RSE_NLA_TYPE",
         "RSE_NUMBER_OF_LANES",
         "RSE_PUS_NODE_ID_END",
         "RSE_PUS_NODE_ID_ST",
         "RSE_RECORD_INVENT_REV",
         "RSE_REF_COAT_FLAG",
         "RSE_REINSTATEMENT_CATEGORY",
         "RSE_ROAD_CATEGORY",
         "RSE_ROAD_ENVIRONMENT",
         "RSE_ROAD_TYPE",
         "RSE_SCL_SECT_CLASS",
         "RSE_SEARCH_GROUP_NO",
         "RSE_SEQ_SIGNIF",
         "RSE_SHARED_ITEMS",
         "RSE_SKID_RES",
         "RSE_SPEED_LIMIT",
         "RSE_STATUS",
         "RSE_TRAFFIC_SENSITIVITY",
         "RSE_VEH_PER_DAY",
         "RSE_BEGIN_MP",
         "RSE_CNT_CODE",
         "RSE_COUPLET_ID",
         "RSE_END_MP",
         "RSE_GOV_LEVEL",
         "RSE_MAX_MP",
         "RSE_PREFIX",
         "RSE_ROUTE",
         "RSE_SUFFIX",
         "RSE_LENGTH_STATUS",
         "RSE_TRAFFIC_LEVEL",
         "RSE_NET_SEL_CRT",
         "RSE_USRN_NO",
         "RSE_SECT_FUNC"
   FROM road_segs;
   
