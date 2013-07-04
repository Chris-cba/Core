CREATE OR REPLACE FORCE VIEW imf_net_maint_sections_all 
AS 
SELECT  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_net_maint_sections_all.vw-arc   3.1   Jul 04 2013 11:35:12   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_maint_sections_all.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:35:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:28:30  $
--       Version          : $Revision:   3.1  $
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
         rse_he_id                            as "NETWORK_ELEMENT_ID"
        ,rse_unique                           as "NETWORK_ELEMENT_REFERENCE"
        ,rse_descr                            as "NETWORK_ELEMENT_DESCRIPTION"
        ,rse_admin_unit                       as "ADMIN_UNIT_ID"
        ,nau_unit_code                        as "ADMIN_UNIT_CODE"
        ,nau_name                             as "ADMIN_UNIT_NAME"                         
        ,rse_group                            as "PARENT_ELEMENT_DESCRIPTION"
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
        ,rse_date_adopted                     as "DATE_ADOPTED"
        ,rse_date_opened                      as "DATE_OPENED"
        ,rse_last_inspected                   as "LAST_INSPECTED_DATE"
        ,rse_last_surveyed                    as "LAST_SURVEYED_DATE"
        ,rse_adoption_status                  as "ADOPTION_STATUS"
        ,(SELECT ial_meaning
            FROM nm_inv_attri_lookup
           WHERE ial_domain = 'ADOPTION_STATUS'
             AND ial_value = rse_adoption_status
             AND ROWNUM = 1)                  as "ADOPTION_STATUS_DESCR"        
        ,rse_alias                            as "NETWORK_ELEMENT_ALIAS"
        ,rse_carriageway_type                 as "CARRIAGEWAY_TYPE"
        ,rse_class_index                      as "CLASS_INDEX" 
        ,rse_engineering_difficulty           as "ENGINEERING_DIFFICULTY"
        ,rse_footway_category                 as "FOOTWAY_CATEGORY"
        ,(SELECT ial_meaning
            FROM nm_inv_attri_lookup
           WHERE ial_domain = 'FOOTWAY_CATEGORY'
             AND ial_value = rse_footway_category
             AND ROWNUM = 1)                  as "FOOTWAY_CATEGORY_DESCR"        
        ,rse_hgv_percent                      as "HGV_PERCENT"
        ,rse_int_code                         as "INTERVAL_CODE"
        ,rse_length                           as "NETWORK_ELEMENT_LENGTH"
        ,rse_maint_category                   as "MAINTENANCE_CATEGORY"
        ,(SELECT ial_meaning
            FROM nm_inv_attri_lookup
           WHERE ial_domain = 'MAINTENANCE_CATEGORY'
             AND ial_value = rse_maint_category
             AND ROWNUM = 1)                  as "MAINT_CATEGORY_DESCR"        
        ,rse_network_direction                as "NETWORK_DIRECTION"
       ,(SELECT ial_meaning
           FROM nm_inv_attri_lookup
          WHERE ial_domain = 'NETWORK_DIRECTION'
            AND ial_value = rse_network_direction
             AND ROWNUM = 1)                  as "NETWORK_DIRECTION_DESCR"        
        ,rse_number_of_lanes                  as "NUMBER_OF_LANES"
        ,rse_reinstatement_category           as "REINSTATEMENT_CATEGORY"
        ,rse_road_category                    as "ROAD_CATEGORY"
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
        ,rse_scl_sect_class                   as "SECTION_CLASS"
        ,(SELECT hco_meaning lup_description
            FROM hig_codes
           WHERE hco_domain = 'SECTIONS'
             AND hco_code = rse_scl_sect_class
             AND ROWNUM = 1)                  as "SECTION_CLASS_DESCR"        
        ,rse_shared_items                     as "SHARED_ITEMS"
        ,rse_skid_res                         as "SKID_RESISTANCE"
        ,rse_speed_limit                      as "SPEED_LIMIT" 
        ,rse_status                           as "STATUS"
        ,(SELECT ial_meaning
            FROM nm_inv_attri_lookup
           WHERE     ial_domain = 'SECTION_STATUS'
             AND ial_value = rse_status
             AND ROWNUM = 1)                  as "STATUS_DESCR"        
        ,rse_traffic_sensitivity              as "TRAFFIC_SENSITIVITY"
        ,rse_veh_per_day                      as "VEHICLES_PER_DAY"
        ,rse_traffic_level                    as "TRAFFIC_LEVEL"
        ,rse_gov_level                        as "GOV_LEVEL"
        ,rse_prefix                           as "PREFIX" 
        ,rse_route                            as "ROUTE"
        ,rse_suffix                           as "SUFFIX"
        ,rse_usrn_no                          as "USRN"
FROM road_sections_all rse
    ,nm_admin_units_all nau
WHERE nau.nau_admin_unit = rse.rse_admin_unit
WITH READ ONLY
/


COMMENT ON TABLE  imf_net_maint_sections_all is 'All maintenance section network';
COMMENT ON COLUMN imf_net_maint_sections_all."NETWORK_ELEMENT_ID" is 'Network Element Id';
COMMENT ON COLUMN imf_net_maint_sections_all."NETWORK_ELEMENT_REFERENCE" is 'Network Element Reference';
COMMENT ON COLUMN imf_net_maint_sections_all."NETWORK_ELEMENT_DESCRIPTION" is 'Network Element Description';
COMMENT ON COLUMN imf_net_maint_sections_all."ADMIN_UNIT_ID" is 'Admin Unit Id';
COMMENT ON COLUMN imf_net_maint_sections_all."ADMIN_UNIT_CODE" is 'Admin Unit Code';
COMMENT ON COLUMN imf_net_maint_sections_all."ADMIN_UNIT_NAME" is 'Admin Unit Name';
COMMENT ON COLUMN imf_net_maint_sections_all."PARENT_ELEMENT_DESCRIPTION" is 'Parent Element Description';
COMMENT ON COLUMN imf_net_maint_sections_all."SYS_FLAG" is 'Sys Flag';
COMMENT ON COLUMN imf_net_maint_sections_all."AGENCY_CODE" is 'Agency Code';
COMMENT ON COLUMN imf_net_maint_sections_all."AGENCY_CODE_DESCR" is 'Agency Code Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."LINKCODE" is 'Linkcode';
COMMENT ON COLUMN imf_net_maint_sections_all."SECTION_NUMBER" is 'Section Number';
COMMENT ON COLUMN imf_net_maint_sections_all."ROAD_NUMBER" is 'Road Number';
COMMENT ON COLUMN imf_net_maint_sections_all."START_DATE" is 'Start Date';
COMMENT ON COLUMN imf_net_maint_sections_all."END_DATE" is 'End Date';
COMMENT ON COLUMN imf_net_maint_sections_all."DATE_ADOPTED" is 'Date Adopted';
COMMENT ON COLUMN imf_net_maint_sections_all."DATE_OPENED" is 'Date Opened';
COMMENT ON COLUMN imf_net_maint_sections_all."LAST_INSPECTED_DATE" is 'Last Inspected Date';
COMMENT ON COLUMN imf_net_maint_sections_all."LAST_SURVEYED_DATE" is 'Last Surveyed Date';
COMMENT ON COLUMN imf_net_maint_sections_all."ADOPTION_STATUS" is 'Adoption Status';
COMMENT ON COLUMN imf_net_maint_sections_all."ADOPTION_STATUS_DESCR" is 'Adoption Status Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."NETWORK_ELEMENT_ALIAS" is 'Network Element Alias';
COMMENT ON COLUMN imf_net_maint_sections_all."CARRIAGEWAY_TYPE" is 'Carriageway Type';
COMMENT ON COLUMN imf_net_maint_sections_all."CLASS_INDEX" is 'Class Index';
COMMENT ON COLUMN imf_net_maint_sections_all."ENGINEERING_DIFFICULTY" is 'Engineering Difficulty';
COMMENT ON COLUMN imf_net_maint_sections_all."FOOTWAY_CATEGORY" is 'Footway Category';
COMMENT ON COLUMN imf_net_maint_sections_all."FOOTWAY_CATEGORY_DESCR" is 'Footway Category Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."HGV_PERCENT" is 'Hgv Percent';
COMMENT ON COLUMN imf_net_maint_sections_all."INTERVAL_CODE" is 'Interval Code';
COMMENT ON COLUMN imf_net_maint_sections_all."NETWORK_ELEMENT_LENGTH" is 'Network Element Length';
COMMENT ON COLUMN imf_net_maint_sections_all."MAINTENANCE_CATEGORY" is 'Maintenance Category';
COMMENT ON COLUMN imf_net_maint_sections_all."MAINT_CATEGORY_DESCR" is 'Maint Category Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."NETWORK_DIRECTION" is 'Network Direction';
COMMENT ON COLUMN imf_net_maint_sections_all."NETWORK_DIRECTION_DESCR" is 'Network Direction Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."NUMBER_OF_LANES" is 'Number Of Lanes';
COMMENT ON COLUMN imf_net_maint_sections_all."REINSTATEMENT_CATEGORY" is 'Reinstatement Category';
COMMENT ON COLUMN imf_net_maint_sections_all."ROAD_CATEGORY" is 'Road Category';
COMMENT ON COLUMN imf_net_maint_sections_all."ROAD_ENVIRONMENT" is 'Road Environment';
COMMENT ON COLUMN imf_net_maint_sections_all."ROAD_ENVIRONMENT_DESCR" is 'Road Environment Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."ROAD_TYPE" is 'Road Type';
COMMENT ON COLUMN imf_net_maint_sections_all."ROAD_TYPE_DESCR" is 'Road Type Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."SECTION_CLASS" is 'Section Class';
COMMENT ON COLUMN imf_net_maint_sections_all."SECTION_CLASS_DESCR" is 'Section Class Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."SHARED_ITEMS" is 'Shared Items';
COMMENT ON COLUMN imf_net_maint_sections_all."SKID_RESISTANCE" is 'Skid Resistance';
COMMENT ON COLUMN imf_net_maint_sections_all."SPEED_LIMIT" is 'Speed Limit';
COMMENT ON COLUMN imf_net_maint_sections_all."STATUS" is 'Status';
COMMENT ON COLUMN imf_net_maint_sections_all."STATUS_DESCR" is 'Status Descr';
COMMENT ON COLUMN imf_net_maint_sections_all."TRAFFIC_SENSITIVITY" is 'Traffic Sensitivity';
COMMENT ON COLUMN imf_net_maint_sections_all."VEHICLES_PER_DAY" is 'Vehicles Per Day';
COMMENT ON COLUMN imf_net_maint_sections_all."TRAFFIC_LEVEL" is 'Traffic Level';
COMMENT ON COLUMN imf_net_maint_sections_all."GOV_LEVEL" is 'Gov Level';
COMMENT ON COLUMN imf_net_maint_sections_all."PREFIX" is 'Prefix';
COMMENT ON COLUMN imf_net_maint_sections_all."ROUTE" is 'Route';
COMMENT ON COLUMN imf_net_maint_sections_all."SUFFIX" is 'Suffix';
COMMENT ON COLUMN imf_net_maint_sections_all."USRN" is 'USRN';
