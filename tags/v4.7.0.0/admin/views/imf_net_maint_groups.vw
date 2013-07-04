CREATE OR REPLACE FORCE VIEW imf_net_maint_groups
AS
SELECT  
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/imf_net_maint_groups.vw-arc   3.1   Jul 04 2013 11:20:08   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_net_maint_groups.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:02:14  $
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
   , group_type
   , sys_flag
   , agency_code
   , agency_code_descr
   , linkcode
   , section_number
   , road_number
   , start_date
   , end_date
   , length
   , section_class
   , section_class_descr
   , road_environment
   , road_environment_descr
   , road_type
   , road_type_descr          
FROM imf_net_maint_groups_all
WHERE end_date IS NULL
WITH READ ONLY
/

COMMENT ON TABLE  imf_net_maint_groups is 'Maintenance group network (non-end dated groups only)';
COMMENT ON COLUMN imf_net_maint_groups."NETWORK_ELEMENT_ID" is 'Network Element Id';
COMMENT ON COLUMN imf_net_maint_groups."NETWORK_ELEMENT_REFERENCE" is 'Network Element Reference';
COMMENT ON COLUMN imf_net_maint_groups."NETWORK_ELEMENT_DESCRIPTION" is 'Network Element Description';
COMMENT ON COLUMN imf_net_maint_groups."ADMIN_UNIT_ID" is 'Admin Unit Id';
COMMENT ON COLUMN imf_net_maint_groups."ADMIN_UNIT_CODE" is 'Admin Unit Code';
COMMENT ON COLUMN imf_net_maint_groups."ADMIN_UNIT_NAME" is 'Admin Unit Name';
COMMENT ON COLUMN imf_net_maint_groups."GROUP_TYPE" is 'Group Type';
COMMENT ON COLUMN imf_net_maint_groups."SYS_FLAG" is 'Sys Flag';
COMMENT ON COLUMN imf_net_maint_groups."AGENCY_CODE" is 'Agency Code';
COMMENT ON COLUMN imf_net_maint_groups."AGENCY_CODE_DESCR" is 'Agency Code Descr';
COMMENT ON COLUMN imf_net_maint_groups."LINKCODE" is 'Linkcode';
COMMENT ON COLUMN imf_net_maint_groups."SECTION_NUMBER" is 'Section Number';
COMMENT ON COLUMN imf_net_maint_groups."ROAD_NUMBER" is 'Road Number';
COMMENT ON COLUMN imf_net_maint_groups."START_DATE" is 'Start Date';
COMMENT ON COLUMN imf_net_maint_groups."END_DATE" is 'End Date';
COMMENT ON COLUMN imf_net_maint_groups."LENGTH" is 'Length';
COMMENT ON COLUMN imf_net_maint_groups."SECTION_CLASS" is 'Section Class';
COMMENT ON COLUMN imf_net_maint_groups."SECTION_CLASS_DESCR" is 'Section Class Descr';
COMMENT ON COLUMN imf_net_maint_groups."ROAD_ENVIRONMENT" is 'Road Environment';
COMMENT ON COLUMN imf_net_maint_groups."ROAD_ENVIRONMENT_DESCR" is 'Road Environment Descr';
COMMENT ON COLUMN imf_net_maint_groups."ROAD_TYPE" is 'Road Type';
COMMENT ON COLUMN imf_net_maint_groups."ROAD_TYPE_DESCR" is 'Road Type Descr';
