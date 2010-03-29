CREATE OR REPLACE FORCE VIEW hig_process_types_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_types_v.vw-arc   3.0   Mar 29 2010 17:14:50   gjohnson  $
--       Module Name      : $Workfile:   hig_process_types_v.vw  $
--       Date into PVCS   : $Date:   Mar 29 2010 17:14:50  $
--       Date fetched Out : $Modtime:   Mar 29 2010 17:14:16  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
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
      FROM hig_process_types
/

COMMENT ON TABLE hig_process_types_v IS 'Exor Process Framework view.  Process type details'
/                                    
             
             