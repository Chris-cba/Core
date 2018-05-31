CREATE OR REPLACE FORCE VIEW V_NM_USER_INV_MODE
(
   INV_TYPE,
   ACCESS_MODE
)
AS
   SELECT                                                                   --
                                                      --   PVCS Identifiers :-
                                                                            --
 --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_user_inv_mode.vw-arc   1.3   May 31 2018 15:30:06   Chris.Baugh  $
                  --       Module Name      : $Workfile:   v_nm_user_inv_mode.vw  $
                  --       Date into SCCS   : $Date:   May 31 2018 15:30:06  $
               --       Date fetched Out : $Modtime:   May 31 2018 15:29:24  $
                               --       SCCS Version     : $Revision:   1.3  $
                                                                            --
 -----------------------------------------------------------------------------
   --    Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
 -----------------------------------------------------------------------------
  -- script to create a view to show asset types and maximum access mode for a user
                                                                            --
          DISTINCT
          itr_inv_type inv_type,
          FIRST_VALUE (itr_mode)
             OVER (PARTITION BY itr_inv_type ORDER BY itr_mode)
             access_mode
     FROM nm_inv_type_roles, hig_user_roles
    WHERE     hur_username = SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
          AND hur_role = itr_hro_role
/          
