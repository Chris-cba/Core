create or replace package body sdl_inv_ddl as
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_inv_ddl.pkb-arc   1.0   Oct 13 2020 20:31:56   Rob.Coupe  $
   --       Module Name      : $Workfile:   sdl_inv_ddl.pkb  $
   --       Date into PVCS   : $Date:   Oct 13 2020 20:31:56  $
   --       Date fetched Out : $Modtime:   Oct 13 2020 20:05:44  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : Rob Coupe
   --
   --   <Descr>
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   1.0  $';
  
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--

procedure create_tdl_profile_tables (p_sp_id in number) is
begin
for irec in (select sp_id, sp_name, spfc_container
from sdl_profile_file_columns, sdl_profiles
where sp_id = spfc_sp_id
and sp_id = p_sp_id
group by sp_id, sp_name, spfc_container) loop
begin
create_tdl_container_table(irec.sp_name, irec.spfc_container);
end;
end loop;
end;


procedure create_tdl_container_table(p_sp_name in varchar2, p_container varchar2 ) is
l_sql varchar2(32767);
l_owner varchar2(30) := sys_context('NM3CORE', 'APPLICATION_OWNER');
l_table_name varchar2(60) := 'TDL_'||p_sp_name
         || '_'
         || p_container
         || '_LD';
l_pk_name varchar2(30) := 'TDL_'||p_sp_name
         || '_'
         || p_container
         || '_LD_PK';
l_uk_name varchar2(30) := 'TDL_'||p_sp_name
         || '_'
         || p_container
         || '_LD_UK';
 --
begin
  SELECT    'create table '||l_owner||'.'||l_table_name
         || ' ( '
         || ' tld_sfs_id number(38) not null, tld_id number(38) not null, '
         || LISTAGG (
                   spfc_col_name
                || ' '
                || spfc_col_datatype
                || CASE
                       WHEN spfc_col_size IS NOT NULL
                       THEN
                           '(' || spfc_col_size || ')'
                       ELSE
                           NULL
                   END,
                ',')
            WITHIN GROUP (ORDER BY spfc_col_id) ||')'
into l_sql            
    FROM sdl_profile_file_columns, sdl_profiles
   WHERE spfc_sp_id = sp_id
   and sp_name = p_sp_name
   and spfc_container = p_container
GROUP BY sp_name, spfc_container;
--
--nm_debug.debug(l_sql);
execute immediate l_sql;
--
l_sql := 'ALTER TABLE '||l_owner||'.'||l_table_name||' ADD '|| 
' CONSTRAINT '||l_pk_name||
' PRIMARY KEY (TLD_ID) '||
' ENABLE ';

execute immediate l_sql;
 
l_sql := 'ALTER TABLE '||l_owner||'.'||l_table_name||' ADD '|| 
' CONSTRAINT '||l_uk_name||
' UNIQUE (TLD_SFS_ID, TLD_ID) '||
' ENABLE ';

execute immediate l_sql;

l_sql := 'CREATE SEQUENCE '||l_owner||'.'||l_table_name||'_SEQ start with 1';

execute immediate l_sql;
 
--
end;


procedure create_tdl_profile_views ( p_sp_id in number) is
begin
for irec in (select sp_id, sp_name, sdh_id, sdh_destination_type
from V_TDL_DESTINATION_ORDER, sdl_profiles
where sp_id = sdh_sp_id
and sp_id = p_sp_id
order by sdh_seq_no
) loop
begin
NULL;
create_tdl_destination_view(irec.sp_id, irec.sdh_id);
end;
end loop;
end;


PROCEDURE create_tdl_destination_view (
    p_sp_id    IN NUMBER,
    p_sdh_id   IN NUMBER)
IS
    l_sp_row         sdl_profiles%ROWTYPE;
    l_sdh_row        sdl_destination_header%ROWTYPE;
    --
    l_view_name      VARCHAR2 (200);

    l_source_table   VARCHAR2 (200);
    l_source_alias   VARCHAR2 (30);

    l_column_list    VARCHAR2 (32767);
    l_source_list    VARCHAR2 (32767);
    
    l_relation_id    NUMBER(38);
    l_sequence_name  varchar2(30);

    l_sql            VARCHAR2 (32767);
BEGIN
    SELECT *
      INTO l_sp_row
      FROM sdl_profiles
     WHERE sp_id = p_sp_id;

    SELECT *
      INTO l_sdh_row
      FROM sdl_destination_header
     WHERE sdh_id = p_sdh_id;

    BEGIN
        SELECT parent_sam_id, sequence_name
          INTO l_relation_id, l_sequence_name
          FROM V_TDL_DESTINATION_RELATIONS
         WHERE sp_id = p_sp_id;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            NULL;
    END;

    l_view_name :=
           'V_TDL_'
        || p_sp_id
        || '_'
        || p_sdh_id
        || '_'
        || l_sdh_row.sdh_destination_type
        || '_LD';

    l_source_table :=
           'TDL_'
        || l_sp_row.sp_name
        || '_'
        || l_sdh_row.sdh_source_container
        || '_LD';

    l_source_alias := l_sdh_row.sdh_source_container;

    -- grab destination columns, formula, swap sequences for the sequence values in the link data - note that the link data will be populated with the parent SAM ID of the attribute

    WITH
        attribs
        AS
            (SELECT sam_id,
                    sam_col_id,
                    sam_file_attribute_name,
                    sam_view_column_name,
                    sam_ne_column_name,
                    sam_attribute_formula,
                    sam_default_value,
                    (SELECT parent_sam_id
                       FROM v_tdl_destination_relations
                      WHERE     sp_id = p_sp_id
                            AND parent_sdh_id = p_sdh_id
                            AND parent_sam_id = sam_id
                     UNION ALL
                     SELECT parent_sam_id
                       FROM v_tdl_destination_relations
                      WHERE     sp_id = p_sp_id
                            AND child_sdh_id = p_sdh_id
                            AND child_sam_id = sam_id)    p_sam_id
               FROM sdl_attribute_mapping
              WHERE sam_sdh_id = p_sdh_id AND sam_sp_id = p_sp_id),
        column_lists
        AS
            (SELECT sam_col_id,
                    sam_view_column_name    dest_column,
                    CASE
                        WHEN p_sam_id IS NOT NULL
                        THEN
                            'L.SDL_LINK_VALUE'
                        ELSE
                            CASE
                                WHEN sam_attribute_formula IS NOT NULL
                                THEN
                                    sam_attribute_formula
                                ELSE
                                    CASE
                                        WHEN sam_default_value IS NOT NULL
                                        THEN
                                            CASE
                                                WHEN sam_file_attribute_name
                                                         IS NOT NULL
                                                THEN
                                                       'NVL('
                                                    || sam_file_attribute_name
                                                    || ', '
                                                    || sam_default_value
                                                    || ')'
                                                ELSE
                                                    sam_default_value
                                            END
                                        ELSE
                                            sam_file_attribute_name
                                    END
                            END
                    END                     source_column
               FROM attribs)
    --
    SELECT LISTAGG (dest_column, ',') WITHIN GROUP (ORDER BY sam_col_id),
           LISTAGG (source_column, ',') WITHIN GROUP (ORDER BY sam_col_id)
      INTO l_column_list, l_source_list
      FROM column_lists;

    l_sql :=
           'create or replace view '
        || l_view_name
        || ' ( tld_sfs_id, tld_id, '
        || l_column_list
        || ' ) '
        || ' as '
        || ' select tld_sfs_id, tld_id, '
        || l_source_list
        || ' from '
        || l_source_table
        || ' '
        || l_source_alias
        || ','
        || ' sdl_destination_links L '
        || ' where '
        || l_source_alias
        || '.tld_sfs_id = L.sdl_sfs_id (+) '
        || ' and '
        || l_source_alias
        || '.tld_id = L.sdl_tld_id (+) '
        || ' and L.sdl_sdr_id (+) = '||l_relation_id;

    BEGIN
        nm_debug.debug (l_sql);
    END;

    EXECUTE IMMEDIATE l_sql;

END;
END;
/
