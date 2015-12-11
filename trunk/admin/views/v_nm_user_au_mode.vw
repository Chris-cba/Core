CREATE OR REPLACE FORCE VIEW V_NM_USER_AU_MODE
(
   ADMIN_UNIT,
   ACCESS_MODE
)
AS
   SELECT                                                                   --
                                                      --   PVCS Identifiers :-
                                                                            --
 --       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_user_au_mode.vw-arc   1.1   Dec 11 2015 16:37:50   Rob.Coupe  $
                  --       Module Name      : $Workfile:   v_nm_user_au_mode.vw  $
                  --       Date into SCCS   : $Date:   Dec 11 2015 16:37:50  $
               --       Date fetched Out : $Modtime:   Dec 11 2015 16:36:04  $
                               --       SCCS Version     : $Revision:   1.1  $
                                                                            --
 -----------------------------------------------------------------------------
   --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
 -----------------------------------------------------------------------------
  -- script to create new, unrestricted views for use in Locator on HE systems
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
      nm3ddl.create_synonym_for_object (
      'V_NM_USER_AU_MODE', 'PUBLIC' );
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
