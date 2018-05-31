CREATE OR REPLACE FORCE VIEW V_NM_USER_AU_MODE
(
   ADMIN_UNIT,
   ACCESS_MODE
)
AS
   SELECT                                                                   --
                                                      --   PVCS Identifiers :-
                                                                            --
 --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_user_au_mode.vw-arc   1.5   May 31 2018 15:28:48   Chris.Baugh  $
                  --       Module Name      : $Workfile:   v_nm_user_au_mode.vw  $
                  --       Date into SCCS   : $Date:   May 31 2018 15:28:48  $
               --       Date fetched Out : $Modtime:   May 31 2018 15:27:14  $
                               --       SCCS Version     : $Revision:   1.5  $
                                                                            --
 -----------------------------------------------------------------------------
   --    Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
 -----------------------------------------------------------------------------
  -- script to create a view to show available admin-units and maximum mode for a user
                                                                            --
          DISTINCT
          nag_child_admin_unit admin_unit,
          FIRST_VALUE (nua_mode)
             OVER (PARTITION BY nag_child_admin_unit ORDER BY nua_mode)
             access_mode
     FROM nm_user_aus, nm_admin_groups
    WHERE     nag_parent_admin_unit = nua_admin_unit
          AND nua_user_id = SYS_CONTEXT ('NM3CORE', 'USER_ID');
/

