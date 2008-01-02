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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_std_text_modules.vw-arc   1.0   Jan 02 2008 16:13:56   bodriscoll  $
--       Module Name      : $Workfile:   v_std_text_modules.vw  $
--       Date into PVCS   : $Date:   Jan 02 2008 16:13:56  $
--       Date fetched Out : $Modtime:   Jan 02 2008 15:45:22  $
--       Version          : $Revision:   1.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
-- 
     hmi_module_item_id, hmi_module_name, hmo_title, hmi_field_desc,
            hmi_block_name, hmi_item_name
       FROM hig_module_items, hig_modules
      WHERE hmi_module_name = hmo_module
   ORDER BY hmi_module_name ASC, hmi_field_desc ASC;


