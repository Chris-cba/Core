CREATE OR REPLACE FORCE VIEW V_TDL_DESTINATION_ORDER
(
    SDH_SEQ_NO,
    SDH_ID,
    SDH_SP_ID,
    SDH_DESTINATION_TYPE,
    SDH_NLT_ID,
    SDH_SOURCE_CONTAINER,
    SDH_DESTINATION_LOCATION,
    SDH_NLD_ID,
    SDH_TABLE_NAME,
    SDH_INSERT_PROCEDURE,
    SDH_VALIDATION_PROCEDURE
)
BEQUEATH DEFINER
AS
      SELECT /*
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_tdl_destination_order.vw-arc   1.0   Oct 13 2020 20:48:46   Rob.Coupe  $
   --       Module Name      : $Workfile:   v_tdl_destination_order.vw  $
   --       Date into PVCS   : $Date:   Oct 13 2020 20:48:46  $
   --       Date fetched Out : $Modtime:   Oct 13 2020 20:48:06  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : Rob Coupe
   --
   --   The order of dependency of destination objects
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --    
*/    
             "SDH_SEQ_NO",
             "SDH_ID",
             "SDH_SP_ID",
             "SDH_DESTINATION_TYPE",
             "SDH_NLT_ID",
             "SDH_SOURCE_CONTAINER",
             "SDH_DESTINATION_LOCATION",
             "SDH_NLD_ID",
             "SDH_TABLE_NAME",
             "SDH_INSERT_PROCEDURE",
             "SDH_VALIDATION_PROCEDURE"
        FROM (SELECT ROW_NUMBER () OVER (PARTITION BY sp_id ORDER BY levl DESC)
                         sdh_seq_no,
                     h.*
                FROM sdl_destination_header h, v_tdl_destination_list d
               WHERE h.sdh_id = d.sdh_id
              UNION ALL
              SELECT 0, h.*
                FROM sdl_destination_header h
               WHERE NOT EXISTS
                         (SELECT 1
                            FROM v_tdl_destination_list d
                           WHERE h.sdh_id = d.sdh_id))
    ORDER BY sdh_sp_id, sdh_seq_no;
/
