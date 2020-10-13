CREATE OR REPLACE FORCE VIEW V_TDL_PROFILE_CONTAINERS
(
    TPC_SP_ID,
    TPC_PROFILE_NAME,
    TPC_CONTAINER,
    TPC_NO_OF_CONTAINERS,
    TPC_SEQ_NO
)
BEQUEATH DEFINER
AS
    SELECT /*
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_tdl_profile_containers.vw-arc   1.0   Oct 13 2020 20:49:48   Rob.Coupe  $
   --       Module Name      : $Workfile:   v_tdl_profile_containers.vw  $
   --       Date into PVCS   : $Date:   Oct 13 2020 20:49:48  $
   --       Date fetched Out : $Modtime:   Oct 13 2020 20:49:20  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : Rob Coupe
   --
   --   A view to provide a list of containers within a load profile
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --    
*/    
           spfc_sp_id,
           sp_name,
           spfc_container,
           COUNT (*) OVER (PARTITION BY spfc_sp_id),
           ROW_NUMBER () OVER (PARTITION BY spfc_sp_id ORDER BY min_id)
      FROM (  SELECT spfc_sp_id,
                     sp_name,
                     spfc_container,
                     min_id
                FROM (SELECT spfc_sp_id,
                             sp_name,
                             spfc_container,
                             MIN (spfc_id)
                                 OVER (PARTITION BY spfc_sp_id, spfc_container)    min_id
                        FROM sdl_profile_file_columns, sdl_profiles
                       WHERE spfc_sp_id = sp_id)
            GROUP BY spfc_sp_id,
                     sp_name,
                     spfc_container,
                     min_id);
