CREATE OR REPLACE FORCE VIEW v_std_text_modules (hmi_module_item_id,
                                                 hmi_module_name,
                                                 hmo_title,
                                                 hmi_field_desc,
                                                 hmi_block_name,
                                                 hmi_item_name
                                                 )
AS
   SELECT
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_std_text_modules.vw-arc   1.2   Apr 13 2018 11:47:26   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   v_std_text_modules.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:26  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:44:38  $
--       Version          : $Revision:   1.2  $
--       Based on SCCS version : 
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- 
     hmi_module_item_id, hmi_module_name, hmo_title, hmi_field_desc,
            hmi_block_name, hmi_item_name
       FROM hig_module_items, hig_modules
      WHERE hmi_module_name = hmo_module
   ORDER BY hmi_module_name ASC, hmi_field_desc ASC;


