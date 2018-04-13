CREATE OR REPLACE FORCE VIEW hig_process_types_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_process_types_v.vw-arc   3.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_process_types_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.3  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
             hpt_process_type_id,
             hpt_name,
             hpt_descr,
             hpt_what_to_call
            ,hpt_process_limit
            ,hpt_restartable
            ,case when hpt_process_type_id < 0 THEN
               'Y'
              else
                'N'
              end hpt_system
            ,hpt_initiation_module
            ,(select hmo_title from hig_modules where hmo_module = hpt_initiation_module) hpt_initiation_module_title
            ,hpt_internal_module
            ,(select hmo_title from hig_modules where hmo_module = hpt_internal_module) hpt_internal_module_title
            , hpt_internal_module_param
            ,hpt_see_in_hig2510
            ,hpt_polling_enabled
            ,hpt_polling_ftp_type_id 
            ,(select hft_type from hig_ftp_types where hft_id = hpt_polling_ftp_type_id) hpt_polling_ftp_type_descr 
            ,hpt_area_type
            ,(select hpa_description from hig_process_areas where hpa_area_type = hpt_area_type) hpt_area_type_meaning  
      FROM hig_process_types
/

COMMENT ON TABLE hig_process_types_v IS 'Exor Process Framework view.  Process type details'
/                                    
             
             