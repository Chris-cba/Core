CREATE OR REPLACE FORCE VIEW V_NM_USER_INV_MODE
(
   INV_TYPE,
   ACCESS_MODE
)
AS
   SELECT                                                                   --
                                                      --   PVCS Identifiers :-
                                                                            --
 --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_user_inv_mode.vw-arc   1.2   Dec 15 2015 20:37:58   Rob.Coupe  $
                  --       Module Name      : $Workfile:   v_nm_user_inv_mode.vw  $
                  --       Date into SCCS   : $Date:   Dec 15 2015 20:37:58  $
               --       Date fetched Out : $Modtime:   Dec 15 2015 20:37:40  $
                               --       SCCS Version     : $Revision:   1.2  $
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


begin
  if NVL(hig.get_sysopt('HIGPUBSYN'), 'Y' ) = 'Y' then
     declare
        already_exists exception;
        pragma exception_init (already_exists, -955);
     begin
        execute immediate 'create public synonym v_nm_user_inv_mode for '||sys_context('NM3CORE', 'APPLICATION_OWNER')||'.V_NM_USER_INV_MODE';
     exception 
       when already_exists then NULL;
     end;
  else
    for i in ( select hus_username from hig_users, dba_users
               where hus_username = username
               and hus_is_hig_owner_flag  = 'N'  ) loop
        begin
           execute immediate 'create synonym '||i.hus_username||'.V_NM_USER_INV_MODE for '||sys_context('NM3_SECURITY_CTX', 'HIG_OWNER')||'.V_NM_USER_INV_MODE';
        exception
           when others then NULL;
        end;
    end loop;
  end if;
end;
/
