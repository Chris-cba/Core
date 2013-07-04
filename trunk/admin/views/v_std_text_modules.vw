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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_std_text_modules.vw-arc   1.1   Jul 04 2013 11:35:14   James.Wadsworth  $
--       Module Name      : $Workfile:   v_std_text_modules.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:33:48  $
--       Version          : $Revision:   1.1  $
--       Based on SCCS version : 
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- 
     hmi_module_item_id, hmi_module_name, hmo_title, hmi_field_desc,
            hmi_block_name, hmi_item_name
       FROM hig_module_items, hig_modules
      WHERE hmi_module_name = hmo_module
   ORDER BY hmi_module_name ASC, hmi_field_desc ASC;


