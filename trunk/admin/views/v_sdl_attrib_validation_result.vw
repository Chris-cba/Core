CREATE OR REPLACE VIEW v_sdl_attrib_validation_result
( val_id
,sld_key
,batch_id
,swd_id
,rule_id
,show_option
,validation_type
,sam_id
,attribute_name
,original_value
,adjusted_value
,status
,status_code
,message 
)
AS 
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_sdl_attrib_validation_result.vw-arc   1.2   Jan 19 2021 14:02:10   Vikas.Mhetre  $
--       Module Name      : $Workfile:   v_sdl_attrib_validation_result.vw  $
--       Date into PVCS   : $Date:   Jan 19 2021 14:02:10  $
--       Date fetched Out : $Modtime:   Jan 19 2021 10:42:20  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : Vikas Mhetre
--
--   A view to show validation failed, rejected OR attribute adjusted records of 
--   SDL submission data based on the selected show_option 
--
-----------------------------------------------------------------------------
-- Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
-- 
-- Validation failures
SELECT svr.svr_id val_id
      ,svr.svr_sld_key sld_key
      ,svr.svr_sfs_id batch_id
      ,svr.svr_swd_id swd_id
      ,NULL rule_id
      ,'INVALID' show_option
      ,CASE WHEN svr.svr_validation_type = 'D'
            THEN 'Domain'
            WHEN svr.svr_validation_type = 'M'
            THEN 'Mandatory'
            WHEN svr.svr_validation_type = 'L'
            THEN 'Datum Mapping'
            ELSE 'Unknown'
        END validation_type
      ,svr.svr_sam_id sam_id
      ,svr.svr_column_name attribute_name
      ,svr.svr_current_value original_value
      ,'' adjusted_value
      ,sld.sld_status status
      ,svr.svr_status_code status_code
      ,svr.svr_message message
  FROM sdl_validation_results svr
      ,sdl_load_data sld
 WHERE svr.svr_sld_key = sld.sld_key
   AND svr_validation_type IN ('D','M','L')
   AND sld.sld_status = 'INVALID'
UNION ALL
-- Rejected Validation failed records
SELECT svr.svr_id val_id
      ,svr.svr_sld_key sld_key
      ,svr.svr_sfs_id batch_id
      ,svr.svr_swd_id swd_id
      ,NULL rule_id
      ,'REJECTED' show_option
      ,CASE WHEN svr.svr_validation_type = 'D'
            THEN 'Domain'
            WHEN svr.svr_validation_type = 'M'
            THEN 'Mandatory'
            WHEN svr.svr_validation_type = 'L'
            THEN 'Datum Mapping'
            WHEN svr.svr_validation_type = 'S'
            THEN 'Geometry'
            ELSE 'Unknown'
        END validation_type
      ,svr.svr_sam_id sam_id
      ,svr.svr_column_name attribute_name
      ,svr.svr_current_value original_value
      ,'' adjusted_value
      ,sld.sld_status status
      ,svr.svr_status_code status_code
      ,svr.svr_message message
  FROM sdl_validation_results svr
      ,sdl_load_data sld
 WHERE svr.svr_sld_key = sld.sld_key
   AND svr.svr_validation_type IN ('D','M','L', 'S')
   AND sld.sld_status = 'REJECTED'
UNION ALL
-- Geometry Validation Failures
SELECT svr.svr_id val_id
      ,svr.svr_sld_key sld_key
      ,svr.svr_sfs_id batch_id
      ,svr.svr_swd_id swd_id
      ,NULL rule_id
      ,'GEOMINVALID' show_option
      ,CASE WHEN svr.svr_validation_type = 'S'
            THEN 'Geometry'
            ELSE 'Unknown'
        END validation_type
      ,svr.svr_sam_id sam_id
      ,svr.svr_column_name attribute_name
      ,svr.svr_current_value original_value
      ,'' adjusted_value
      ,CASE WHEN svr.svr_swd_id IS NOT NULL
            THEN swd.status
            ELSE sld.sld_status
       END status
      ,svr.svr_status_code status_code
      ,svr.svr_message message
  FROM sdl_validation_results svr
      ,sdl_load_data sld
      ,sdl_wip_datums swd
 WHERE svr.svr_sld_key = sld.sld_key
   AND sld.sld_key = swd.sld_key(+)
   AND sld.sld_sfs_id = swd.batch_id(+)
   AND svr.svr_swd_id = swd.swd_id(+)
   AND svr.svr_validation_type = 'S'
   AND sld.sld_status = 'INVALID'
UNION ALL
-- Attribute adjustments
SELECT saaa.saaa_id val_id
      ,saaa.saaa_sld_key sld_key
      ,saaa.saaa_sfs_id batch_id
      ,NULL swd_id
      ,saaa.saaa_saar_id rule_id
      ,'ADJUSTED' show_option
      ,'Adjustment Rule' validation_type
      ,saaa.saaa_sam_id sam_id
      ,sam.sam_view_column_name attribute_name
      ,saaa.saaa_original_value original_value
      ,saaa.saaa_adjusted_value adjusted_value
      ,sld.sld_status status
      ,-990 status_code
      ,'Attribute Adjustment Rule ' || saaa.saaa_saar_id || ' applied' message
  FROM sdl_attribute_adjustment_audit saaa
      ,sdl_attribute_mapping sam
      ,sdl_destination_header sdh
      ,sdl_load_data sld
 WHERE saaa.saaa_sam_id = sam.sam_id
   AND saaa.saaa_sld_key = sld.sld_key
   AND sam.sam_sdh_id = sdh.sdh_id
   AND sdh.sdh_destination_location = 'N'
   AND sld.sld_adjustment_rule_applied = 'Y'
/
