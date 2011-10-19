--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/pre_upgrade_meta_sync.sql-arc   3.0   Oct 19 2011 11:54:42   Mike.Alexander  $
--       Module Name      : $Workfile:   pre_upgrade_meta_sync.sql  $
--       Date into PVCS   : $Date:   Oct 19 2011 11:54:42  $
--       Date fetched Out : $Modtime:   Oct 19 2011 11:49:32  $
--       Version          : $Revision:   3.0  $
--
--   Product upgrade script
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
/*
 The upgrade process will need to refresh some of the system generated objects to remove occurrences of code which is in the 
 process of being deprecated. The process will refresh server generated APIs and triggers from the inventory metamodel. The APIs 
 and triggers will reference the inventory view through the use of a rowtype variable but the variables themselves will be driven 
 not from the existing view but from the metamodel.
 
 This means that if an asset description in the metamodel is out of sync with the view definitions used to describe the inventory item
 then there may be a resultant failure in the compilation. If this is the case, then the code that fails validation is not reliable 
 anyway and points towards the system being badly configured.
 
 Prior to the upgrade, the administrator may wish to check all occurrences where the asset metamodel describes an asset in a way that
 differs from the view definition.if these persist during the upgrade, then invalid objects will result after the upgrade.
 
 the occurrences of these invalid objects may be rectified by executing the scripts below to synchronise objecst and metadata 
 either before or after the upgrade. 
 
 */
 
select o.*, v.view_name nw_view, p.object_name API from (
select nit_inv_type, nit_descr, nit_view_name 
from nm_inv_types, user_views
where view_name = nit_view_name
and ( exists ( select 1 from nm_inv_type_attribs
             where ita_inv_type = nit_inv_type
             and not exists ( select 1 from user_tab_columns c
                              where c.table_name = nit_view_name
                              and  c.column_name = ita_view_col_name ))
   OR exists ( select 1 from user_tab_columns c
               where c.table_name = nit_view_name
               and column_name not in (  'IIT_NE_ID',
                                        'IIT_INV_TYPE',
                                        'IIT_PRIMARY_KEY',
                                        'IIT_START_DATE',
                                        'IIT_DATE_CREATED',
                                        'IIT_DATE_MODIFIED',
                                        'IIT_CREATED_BY',
                                        'IIT_MODIFIED_BY',
                                        'IIT_ADMIN_UNIT',
                                        'IIT_DESCR',
                                        'IIT_NOTE',
                                        'IIT_PEO_INVENT_BY_ID',
                                        'NAU_UNIT_CODE',
                                        'IIT_END_DATE',
                                        'IIT_X_SECT' )
               and not exists ( select 1 from nm_inv_type_attribs
                                where ita_inv_type = nit_inv_type
                                and  c.column_name = ita_view_col_name )) ) )o,
         user_views v, user_objects p
         where v.view_name (+)  = o.nit_view_name||'_NW'
         and p.object_name (+)  = 'NM3API_INV_'||nit_inv_type 
         and p.object_type = 'PACKAGE'
/

/*

 if there are results from the cursor above, then it is preferable to regenerate the objects to 
 re-synchronise the object with the metadata prior to the upgrade.
 
*/
 

declare
  cursor c1 is 
select o.*, v.view_name nw_view, p.object_name API from (
select nit_inv_type, nit_descr, nit_view_name 
from nm_inv_types, user_views
where view_name = nit_view_name
and ( exists ( select 1 from nm_inv_type_attribs
             where ita_inv_type = nit_inv_type
             and not exists ( select 1 from user_tab_columns c
                              where c.table_name = nit_view_name
                              and  c.column_name = ita_view_col_name ))
   OR exists ( select 1 from user_tab_columns c
               where c.table_name = nit_view_name
               and column_name not in (  'IIT_NE_ID',
                                        'IIT_INV_TYPE',
                                        'IIT_PRIMARY_KEY',
                                        'IIT_START_DATE',
                                        'IIT_DATE_CREATED',
                                        'IIT_DATE_MODIFIED',
                                        'IIT_CREATED_BY',
                                        'IIT_MODIFIED_BY',
                                        'IIT_ADMIN_UNIT',
                                        'IIT_DESCR',
                                        'IIT_NOTE',
                                        'IIT_PEO_INVENT_BY_ID',
                                        'NAU_UNIT_CODE',
                                        'IIT_END_DATE',
                                        'IIT_X_SECT' )
               and not exists ( select 1 from nm_inv_type_attribs
                                where ita_inv_type = nit_inv_type
                                and  c.column_name = ita_view_col_name )) ) )o,
         user_views v, user_objects p
         where v.view_name (+)  = o.nit_view_name||'_NW'
         and p.object_name (+)  = 'NM3API_INV_'||nit_inv_type 
         and p.object_type = 'PACKAGE';
--     
vname user_views.view_name%type;                               
begin
  for irec in c1 loop
    if irec.nw_view is not null then
      execute immediate 'drop view '||irec.nw_view;
    end if;
    execute immediate 'drop view '||irec.nit_view_name;
    begin
      NM3INV_VIEW.CREATE_INV_VIEW(irec.nit_inv_type, false, vname );
      if irec.nw_view is not null then
         NM3INV_VIEW.CREATE_INV_VIEW(irec.nit_inv_type, true, vname );
      end if;
      if irec.API is not null then
        NM3INV_API_GEN.BUILD_ONE(irec.nit_inv_type);
      end if;
    end;
  end loop;
end;      




                    
 