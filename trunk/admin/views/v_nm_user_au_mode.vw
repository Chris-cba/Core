CREATE OR REPLACE FORCE VIEW V_NM_USER_AU_MODE
(
   ADMIN_UNIT,
   ACCESS_MODE
)
AS
   SELECT                                                                   --
                                                      --   PVCS Identifiers :-
                                                                            --
 --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_user_au_mode.vw-arc   1.4   Dec 15 2015 20:39:44   Rob.Coupe  $
                  --       Module Name      : $Workfile:   v_nm_user_au_mode.vw  $
                  --       Date into SCCS   : $Date:   Dec 15 2015 20:39:44  $
               --       Date fetched Out : $Modtime:   Dec 15 2015 20:39:34  $
                               --       SCCS Version     : $Revision:   1.4  $
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


begin
  if NVL(hig.get_sysopt('HIGPUBSYN'), 'Y' ) = 'Y' then
     declare
        already_exists exception;
        pragma exception_init (already_exists, -955);
     begin
        execute immediate 'create public synonym v_nm_user_au_mode for '||sys_context('NM3CORE', 'APPLICATION_OWNER')||'.V_NM_USER_AU_MODE';
     exception 
       when already_exists then NULL;
     end;
  else
    for i in ( select hus_username from hig_users, dba_users
               where hus_username = username
               and hus_is_hig_owner_flag  = 'N'  ) loop
        begin
           execute immediate 'create synonym '||i.hus_username||'.V_NM_USER_AU_MODE for '||sys_context('NM3_SECURITY_CTX', 'HIG_OWNER')||'.V_NM_USER_AU_MODE';
        exception
           when others then NULL;
        end;
    end loop;
  end if;
end;
/
