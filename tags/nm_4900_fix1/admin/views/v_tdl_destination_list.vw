CREATE OR REPLACE FORCE VIEW V_TDL_DESTINATION_LIST
(
    SP_ID,
    LEVL,
    SDH_ID,
    DESTINATION_TYPE
)
BEQUEATH DEFINER
AS
    SELECT /*
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_tdl_destination_list.vw-arc   1.0   Oct 13 2020 20:47:32   Rob.Coupe  $
   --       Module Name      : $Workfile:   v_tdl_destination_list.vw  $
   --       Date into PVCS   : $Date:   Oct 13 2020 20:47:32  $
   --       Date fetched Out : $Modtime:   Oct 13 2020 20:47:00  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : Rob Coupe
   --
   --   A view to list the destinations and label the relationships as parent/child
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --    
*/    
           sp_id,
           'P'                         levl,
           parent_sdh_id               sdh_id,
           parent_destination_type     destination_type
      FROM v_tdl_destination_relations
    UNION ALL
    SELECT sp_id,
           'C',
           child_sdh_id,
           child_destination_type
      FROM v_tdl_destination_relations;
/