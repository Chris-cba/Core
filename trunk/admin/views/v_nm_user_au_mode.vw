CREATE OR REPLACE FORCE VIEW V_NM_USER_AU_MODE
(
   ADMIN_UNIT,
   ACCESS_MODE
)
AS
   SELECT 
                                                      --   SCCS Identifiers :-
                                                                            --
                   --       sccsid           : @(#)nm_elements.vw 1.3 03/24/05
                                    --       Module Name      : nm_elements.vw
                                 --       Date into SCCS   : 05/03/24 16:15:06
                                 --       Date fetched Out : 07/06/13 17:08:05
                                               --       SCCS Version     : 1.3
                                                                            --
 -----------------------------------------------------------------------------
    --   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
 -----------------------------------------------------------------------------                                                                            --
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
      'V_NM_USER_INV_MODE', 'PUBLIC' );
  else
    for i in ( select hus_username from hig_users, dba_users
               where hus_username = username
               and hus_is_hig_owner_flag  = 'N'  ) loop
        begin
           execute immediate 'create synonym '||i.hus_username||' for '||sys_context('NM3_SECURITY_CTX', 'HIG_OWNER')||'.V_NM_USER_INV_MODE';
        exception
           when others then NULL;
        end;
    end loop;
  end if;
end;
/
