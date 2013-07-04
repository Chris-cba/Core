CREATE OR REPLACE FORCE VIEW imf_net_maint_sections 
AS 
SELECT  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_net_maint_sections.vw-arc   3.1   Jul 04 2013 11:20:30   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_maint_sections.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:02:40  $
--       Version          : $Revision:   3.1  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
    network_element_id
  , network_element_reference
  , network_element_description
  , admin_unit_id
  , admin_unit_code
  , admin_unit_name
  , parent_element_description
  , sys_flag
  , agency_code
  , agency_code_descr
  , linkcode
  , section_number
  , road_number
  , start_date
  , end_date
  , date_adopted
  , date_opened
  , last_inspected_date
  , last_surveyed_date
  , adoption_status
  , adoption_status_descr
  , network_element_alias
  , carriageway_type
  , class_index
  , engineering_difficulty
  , footway_category
  , footway_category_descr
  , hgv_percent
  , interval_code
  , network_element_length
  , maintenance_category
  , maint_category_descr
  , network_direction
  , network_direction_descr
  , number_of_lanes
  , reinstatement_category
  , road_category
  , road_environment
  , road_environment_descr
  , road_type
  , road_type_descr
  , section_class
  , section_class_descr
  , shared_items
  , skid_resistance
  , speed_limit
  , status
  , status_descr
  , traffic_sensitivity
  , vehicles_per_day
  , traffic_level
  , gov_level
  , prefix
  , route
  , suffix
  , usrn
FROM imf_net_maint_sections_all
WHERE end_date IS NULL
WITH READ ONLY
/


COMMENT ON TABLE  imf_net_maint_sections is 'Maintenance section network (non-end dated sections only)';
COMMENT ON COLUMN imf_net_maint_sections."NETWORK_ELEMENT_ID" is 'Network Element Id';
COMMENT ON COLUMN imf_net_maint_sections."NETWORK_ELEMENT_REFERENCE" is 'Network Element Reference';
COMMENT ON COLUMN imf_net_maint_sections."NETWORK_ELEMENT_DESCRIPTION" is 'Network Element Description';
COMMENT ON COLUMN imf_net_maint_sections."ADMIN_UNIT_ID" is 'Admin Unit Id';
COMMENT ON COLUMN imf_net_maint_sections."ADMIN_UNIT_CODE" is 'Admin Unit Code';
COMMENT ON COLUMN imf_net_maint_sections."ADMIN_UNIT_NAME" is 'Admin Unit Name';
COMMENT ON COLUMN imf_net_maint_sections."PARENT_ELEMENT_DESCRIPTION" is 'Parent Element Description';
COMMENT ON COLUMN imf_net_maint_sections."SYS_FLAG" is 'Sys Flag';
COMMENT ON COLUMN imf_net_maint_sections."AGENCY_CODE" is 'Agency Code';
COMMENT ON COLUMN imf_net_maint_sections."AGENCY_CODE_DESCR" is 'Agency Code Descr';
COMMENT ON COLUMN imf_net_maint_sections."LINKCODE" is 'Linkcode';
COMMENT ON COLUMN imf_net_maint_sections."SECTION_NUMBER" is 'Section Number';
COMMENT ON COLUMN imf_net_maint_sections."ROAD_NUMBER" is 'Road Number';
COMMENT ON COLUMN imf_net_maint_sections."START_DATE" is 'Start Date';
COMMENT ON COLUMN imf_net_maint_sections."END_DATE" is 'End Date';
COMMENT ON COLUMN imf_net_maint_sections."DATE_ADOPTED" is 'Date Adopted';
COMMENT ON COLUMN imf_net_maint_sections."DATE_OPENED" is 'Date Opened';
COMMENT ON COLUMN imf_net_maint_sections."LAST_INSPECTED_DATE" is 'Last Inspected Date';
COMMENT ON COLUMN imf_net_maint_sections."LAST_SURVEYED_DATE" is 'Last Surveyed Date';
COMMENT ON COLUMN imf_net_maint_sections."ADOPTION_STATUS" is 'Adoption Status';
COMMENT ON COLUMN imf_net_maint_sections."ADOPTION_STATUS_DESCR" is 'Adoption Status Descr';
COMMENT ON COLUMN imf_net_maint_sections."NETWORK_ELEMENT_ALIAS" is 'Network Element Alias';
COMMENT ON COLUMN imf_net_maint_sections."CARRIAGEWAY_TYPE" is 'Carriageway Type';
COMMENT ON COLUMN imf_net_maint_sections."CLASS_INDEX" is 'Class Index';
COMMENT ON COLUMN imf_net_maint_sections."ENGINEERING_DIFFICULTY" is 'Engineering Difficulty';
COMMENT ON COLUMN imf_net_maint_sections."FOOTWAY_CATEGORY" is 'Footway Category';
COMMENT ON COLUMN imf_net_maint_sections."FOOTWAY_CATEGORY_DESCR" is 'Footway Category Descr';
COMMENT ON COLUMN imf_net_maint_sections."HGV_PERCENT" is 'Hgv Percent';
COMMENT ON COLUMN imf_net_maint_sections."INTERVAL_CODE" is 'Interval Code';
COMMENT ON COLUMN imf_net_maint_sections."NETWORK_ELEMENT_LENGTH" is 'Network Element Length';
COMMENT ON COLUMN imf_net_maint_sections."MAINTENANCE_CATEGORY" is 'Maintenance Category';
COMMENT ON COLUMN imf_net_maint_sections."MAINT_CATEGORY_DESCR" is 'Maint Category Descr';
COMMENT ON COLUMN imf_net_maint_sections."NETWORK_DIRECTION" is 'Network Direction';
COMMENT ON COLUMN imf_net_maint_sections."NETWORK_DIRECTION_DESCR" is 'Network Direction Descr';
COMMENT ON COLUMN imf_net_maint_sections."NUMBER_OF_LANES" is 'Number Of Lanes';
COMMENT ON COLUMN imf_net_maint_sections."REINSTATEMENT_CATEGORY" is 'Reinstatement Category';
COMMENT ON COLUMN imf_net_maint_sections."ROAD_CATEGORY" is 'Road Category';
COMMENT ON COLUMN imf_net_maint_sections."ROAD_ENVIRONMENT" is 'Road Environment';
COMMENT ON COLUMN imf_net_maint_sections."ROAD_ENVIRONMENT_DESCR" is 'Road Environment Descr';
COMMENT ON COLUMN imf_net_maint_sections."ROAD_TYPE" is 'Road Type';
COMMENT ON COLUMN imf_net_maint_sections."ROAD_TYPE_DESCR" is 'Road Type Descr';
COMMENT ON COLUMN imf_net_maint_sections."SECTION_CLASS" is 'Section Class';
COMMENT ON COLUMN imf_net_maint_sections."SECTION_CLASS_DESCR" is 'Section Class Descr';
COMMENT ON COLUMN imf_net_maint_sections."SHARED_ITEMS" is 'Shared Items';
COMMENT ON COLUMN imf_net_maint_sections."SKID_RESISTANCE" is 'Skid Resistance';
COMMENT ON COLUMN imf_net_maint_sections."SPEED_LIMIT" is 'Speed Limit';
COMMENT ON COLUMN imf_net_maint_sections."STATUS" is 'Status';
COMMENT ON COLUMN imf_net_maint_sections."STATUS_DESCR" is 'Status Descr';
COMMENT ON COLUMN imf_net_maint_sections."TRAFFIC_SENSITIVITY" is 'Traffic Sensitivity';
COMMENT ON COLUMN imf_net_maint_sections."VEHICLES_PER_DAY" is 'Vehicles Per Day';
COMMENT ON COLUMN imf_net_maint_sections."TRAFFIC_LEVEL" is 'Traffic Level';
COMMENT ON COLUMN imf_net_maint_sections."GOV_LEVEL" is 'Gov Level';
COMMENT ON COLUMN imf_net_maint_sections."PREFIX" is 'Prefix';
COMMENT ON COLUMN imf_net_maint_sections."ROUTE" is 'Route';
COMMENT ON COLUMN imf_net_maint_sections."SUFFIX" is 'Suffix';
COMMENT ON COLUMN imf_net_maint_sections."USRN" is 'USRN';
