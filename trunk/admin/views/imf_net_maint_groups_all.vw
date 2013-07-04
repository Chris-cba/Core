CREATE OR REPLACE FORCE VIEW imf_net_maint_groups_all
AS
SELECT  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_net_maint_groups_all.vw-arc   3.1   Jul 04 2013 11:20:08   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_maint_groups_all.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:02:24  $
--       Version          : $Revision:   3.1  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
         rse_he_id                            as "NETWORK_ELEMENT_ID"
        ,rse_unique                           as "NETWORK_ELEMENT_REFERENCE"
        ,rse_descr                            as "NETWORK_ELEMENT_DESCRIPTION"
        ,rse_admin_unit                       as "ADMIN_UNIT_ID"
        ,nau_unit_code                        as "ADMIN_UNIT_CODE"
        ,nau_name                             as "ADMIN_UNIT_NAME"        
        ,rse_gty_group_type                   as "GROUP_TYPE"
        ,rse_sys_flag                         as "SYS_FLAG"
        ,rse_agency                           as "AGENCY_CODE"
        ,(SELECT hau_name
          FROM v_hig_agency_code
          WHERE hau_authority_code = rse_agency 
            AND ROWNUM = 1)                   as "AGENCY_CODE_DESCR"        
        ,rse_linkcode                         as "LINKCODE"
        ,rse_sect_no                          as "SECTION_NUMBER" 
        ,rse_road_number                      as "ROAD_NUMBER"
        ,rse_start_date                       as "START_DATE"
        ,rse_end_date                         as "END_DATE" 
        ,rse_length                           as "LENGTH"
        ,rse_scl_sect_class                   as "SECTION_CLASS"
        ,(SELECT hco_meaning lup_description
            FROM hig_codes
           WHERE hco_domain = 'SECTIONS'
             AND hco_code = rse_scl_sect_class
             AND ROWNUM = 1)                  as "SECTION_CLASS_DESCR"        
        ,rse_road_environment                 as "ROAD_ENVIRONMENT"
       ,(SELECT ial_meaning
           FROM nm_inv_attri_lookup
          WHERE ial_domain = 'ROAD_ENVIRONMENT'
            AND ial_value = rse_road_environment
            AND ROWNUM = 1)                   as "ROAD_ENVIRONMENT_DESCR"        
        ,rse_road_type                        as "ROAD_TYPE"
       ,(SELECT ial_meaning
           FROM nm_inv_attri_lookup
          WHERE ial_domain = 'ROAD_TYPE'
            AND ial_value = rse_road_type
            AND ROWNUM = 1)                   as "ROAD_TYPE_DESCR"          
FROM road_groups_all rse
   ,nm_admin_units_all nau
WHERE nau.nau_admin_unit = rse.rse_admin_unit
WITH READ ONLY
/

COMMENT ON TABLE imf_net_maint_groups_all is 'All maintenance groups of sections';
COMMENT ON COLUMN imf_net_maint_groups_all."NETWORK_ELEMENT_ID" is 'Network Element Id';
COMMENT ON COLUMN imf_net_maint_groups_all."NETWORK_ELEMENT_REFERENCE" is 'Network Element Reference';
COMMENT ON COLUMN imf_net_maint_groups_all."NETWORK_ELEMENT_DESCRIPTION" is 'Network Element Description';
COMMENT ON COLUMN imf_net_maint_groups_all."ADMIN_UNIT_ID" is 'Admin Unit Id';
COMMENT ON COLUMN imf_net_maint_groups_all."ADMIN_UNIT_CODE" is 'Admin Unit Code';
COMMENT ON COLUMN imf_net_maint_groups_all."ADMIN_UNIT_NAME" is 'Admin Unit Name';
COMMENT ON COLUMN imf_net_maint_groups_all."GROUP_TYPE" is 'Group Type';
COMMENT ON COLUMN imf_net_maint_groups_all."SYS_FLAG" is 'Sys Flag';
COMMENT ON COLUMN imf_net_maint_groups_all."AGENCY_CODE" is 'Agency Code';
COMMENT ON COLUMN imf_net_maint_groups_all."AGENCY_CODE_DESCR" is 'Agency Code Descr';
COMMENT ON COLUMN imf_net_maint_groups_all."LINKCODE" is 'Linkcode';
COMMENT ON COLUMN imf_net_maint_groups_all."SECTION_NUMBER" is 'Section Number';
COMMENT ON COLUMN imf_net_maint_groups_all."ROAD_NUMBER" is 'Road Number';
COMMENT ON COLUMN imf_net_maint_groups_all."START_DATE" is 'Start Date';
COMMENT ON COLUMN imf_net_maint_groups_all."END_DATE" is 'End Date';
COMMENT ON COLUMN imf_net_maint_groups_all."LENGTH" is 'Length';
COMMENT ON COLUMN imf_net_maint_groups_all."SECTION_CLASS" is 'Section Class';
COMMENT ON COLUMN imf_net_maint_groups_all."SECTION_CLASS_DESCR" is 'Section Class Descr';
COMMENT ON COLUMN imf_net_maint_groups_all."ROAD_ENVIRONMENT" is 'Road Environment';
COMMENT ON COLUMN imf_net_maint_groups_all."ROAD_ENVIRONMENT_DESCR" is 'Road Environment Descr';
COMMENT ON COLUMN imf_net_maint_groups_all."ROAD_TYPE" is 'Road Type';
COMMENT ON COLUMN imf_net_maint_groups_all."ROAD_TYPE_DESCR" is 'Road Type Descr';
