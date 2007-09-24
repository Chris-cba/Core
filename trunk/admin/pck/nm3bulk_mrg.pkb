CREATE OR REPLACE PACKAGE BODY nm3bulk_mrg AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3bulk_mrg.pkb-arc   2.1   Sep 24 2007 08:50:44   ptanava  $
--       Module Name      : $Workfile:   nm3bulk_mrg.pkb  $
--       Date into PVCS   : $Date:   Sep 24 2007 08:50:44  $
--       Date fetched Out : $Modtime:   Sep 21 2007 14:50:18  $
--       PVCS Version     : $Revision:   2.1  $
--       Based on sccs version : 
--
--
--   Author : Priidu Tanava
--
--   Bulk merge functinality
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------

/* History
  17.04.07  PT change in std_populate(), now uses slk values to
                calculate begin and end offsets
  23.04.07  PT fixed a bug in ins_datum_homo_chunks(): in q3 rownum without order by
  27.05.07  PT changed the cartesian overlap criteria in both
                std_populate() and std_insert_invitems()
                now accommodates the point items - they were left out before
                => =< are now logically used instead of ><
  23.07.07  PT fixed a bug in the above change - missing brackets with OR
  21.09.07  PT implemented the std_run() without the p_group_type specified: assemble by datum homo chunks;
                added process_datums_group_type()
*/
  g_body_sccsid     constant  varchar2(30)  :='"$Revision:   2.1  $"';
  g_package_name    constant  varchar2(30)  := 'nm3bulk_mrg';
  
  cr  constant varchar2(1) := chr(10);
  qt  constant varchar2(1) := chr(39);  -- single quote
  
  subtype id_type is number(9);
  subtype hash_type is varchar2(20);
  subtype mp_type is number;
  
  type  nm_inv_types_tbl is table of
    nm_inv_types_all%rowtype index by binary_integer;
  
  
  -- types to populate the standard mrg results tables
  type nm_mrg_sections_tbl is table of
    nm_mrg_sections_all%rowtype index by binary_integer;
  type nm_mrg_section_member_inv_tbl is table of
    nm_mrg_section_member_inv%rowtype index by binary_integer;
  type nm_mrg_section_members_tbl is table of
    nm_mrg_section_members%rowtype index by binary_integer;
  type nm_mrg_section_inv_values_tbl is table of
    nm_mrg_section_inv_values_all%rowtype index by binary_integer;
    
    
  connect_by_loop exception; -- CONNECT BY loop in user data
  pragma exception_init(connect_by_loop, -1436);
    
  
  procedure std_insert_invitems(
     p_mrg_job_id in nm_mrg_query_results_all.nqr_mrg_job_id%type
    ,pt_attr in ita_mapping_tbl
    ,p_splits_rowcount in integer
  );
  
  
  procedure make_sql_effective_date(
     p_sql out varchar2
    ,p_bind_count in out integer
    ,p_date in date
    ,p_start_date_column in varchar2
    ,p_end_date_column in varchar2
  );
  
  
  function get_attrib_name(
     p_table_name in varchar2
    ,p_ita_attrib_name in varchar2
    ,p_iit_attrib_name in varchar2
  ) return varchar2;
  
  
  
  function get_version return varchar2 is
  begin
     return g_sccsid;
  end get_version;
  --
  -----------------------------------------------------------------------------
  --
  function get_body_version return varchar2 is
  begin
     return g_body_sccsid;
  end get_body_version;
  
  
  -----------------------------------------------------------------
  
 
  -- this executes the main bulk source query
  --  the results are put into nm_mrg_split_results_tmp, previous results truncated
  --  autonomous transaction
  procedure ins_splits(
     pt_attr in ita_mapping_tbl
    ,p_effective_date in date
    ,p_all_routes in boolean
    ,p_splits_rowcount out integer
  )
  is
    type ft_where_rec is record (
       inv_type nm_inv_types_all.nit_inv_type%type
      ,where_sql varchar2(4000)
    );
    type ft_where_tbl is table of ft_where_rec index by binary_integer;
    
    l_comma                     varchar2(1);
    l_and                       varchar2(5);
    l_where_and                 varchar2(7);
    l_or                        varchar2(15);
    a1                          varchar2(4);    -- alias 1
    a2                          varchar2(4);    -- alias 2
    --
    l_sql                       varchar2(32767);
    l_sql_obj_types             varchar2(1000);
    l_sql_ft                    varchar2(32767);
    l_sql_members               varchar2(1000);
    l_sql_iit_criteria          varchar2(32767);
    l_sql_tmp                   varchar2(4000);
    l_sql_route_datums_tbl      varchar2(200);
    l_sql_nm_effective_date     varchar2(200);
    l_sql_iit_effective_date    varchar2(200);
    --
    t_ft                        ita_mapping_tbl;
    k                           binary_integer;
    l_cardinality               integer;
    l_sql_cardinality           varchar2(40);
    l_union_all                 varchar2(10);
    l_effective_date            date := p_effective_date;
    
    
    function sql_datum_tbl_join(
       p_column in varchar2
      ,p_connector in varchar2
      ,p_alias in varchar2 default null
    ) return varchar2
    is
      l_alias varchar2(10) := p_alias;
    begin
      if l_alias is not null then
        l_alias := l_alias||'.';
      end if;
      if p_all_routes then return null;
      else
        return cr||p_connector||l_alias||lower(p_column)||' = x.column_value';
      end if;
    end;
    
     function sql_ft_criteria(
       p_connector in varchar2
      ,p_where_sql in varchar2
      ,p_alias in varchar2 default null
    ) return varchar2
    is
      l_alias varchar2(10) := p_alias;
    begin    
      if p_where_sql is null then
        return null;
      end if;
      if l_alias is not null then
        l_alias := l_alias||'.';
      end if;
      return cr||p_connector||l_alias||p_where_sql;
    end;
    
    --pragma autonomous_transaction;  
    
  begin
    nm3dbg.putln(g_package_name||'.ins_splits('
      ||'pt_attr.count='||pt_attr.count
      ||', p_effective_date='||p_effective_date
      ||', p_all_routes='||nm3flx.boolean_to_char(p_all_routes)
      ||')');
    nm3dbg.ind;
  

    -- nm_mrg_split_results_tmp is global temporary on commit preserve rows
    execute immediate
      'truncate table nm_mrg_split_results_tmp';      
      
      
    -- effective date is used directly as bind variable in the sql
    if l_effective_date is null then
      l_effective_date := trunc(sysdate);
    end if;
    
     
      
    -- calculate the cardinality hint value
    --  for the route datum criterium table
    l_cardinality := nm3sql.get_rounded_cardinality(nm3sql.get_id_tbl_count);
      
    
    
    if p_all_routes then null;
    else
      if l_cardinality = 0 then
        raise_application_error(-20066,
          'Cannot run merge query. ''All routes'' parameter false'
            ||' and the datum criteria table has no elements.'
        );
      end if;
    
      --l_sql_route_datums_tbl := 
      --  cr||'  ,(select /*+ cardinality(x '||l_cardinality||') */ x.column_value'
      --    ||' from table(cast(nm3sql.get_id_tbl as nm_id_tbl)) x)';
      
      l_sql_cardinality := ' /*+ cardinality(x '||l_cardinality||') */';

      l_sql_route_datums_tbl := 
        cr||'  ,(select column_value'
          ||' from table(cast(nm3sql.get_id_tbl as nm_id_tbl))) x';
          
    end if;    
    
    
    -- build the obj_types and inv item attributes criteria
    --  for standard invitems
    for i in 1 .. pt_attr.count loop
    
      -- process the inv type if this is the first attribute (not already processed)
      if pt_attr(i).seq = 1 then 
      
      
      
        -- standard invitem
        if pt_attr(i).table_name is null then
            
          -- add the xsp criterium
          if pt_attr(i).xsp is not null then
            l_sql_tmp := ' and i.iit_x_sect = '||qt||pt_attr(i).xsp||qt;
          end if;
          
          -- add other criteria
          --  for this do a secondary loop thorough all attributes
          for j in 1 .. pt_attr.count loop
            if pt_attr(j).inv_type = pt_attr(i).inv_type then
              if pt_attr(j).where_sql is not null then
                l_sql_tmp := l_sql_tmp
                  ||' and i.'||pt_attr(j).where_sql;
              end if;
            end if;
          
          end loop;
          
          -- append this inv_type's criteria  
          l_sql_iit_criteria := l_sql_iit_criteria
                ||l_or||'(i.iit_inv_type = '||qt||pt_attr(i).inv_type||qt
                ||l_sql_tmp||')';
          l_or := cr||'      or ';
          l_sql_tmp := null;



        
        -- it is a foreign table
        else
        
          -- store the distinct ft_invitems in a separate table
          --  (to keep the pt_attr read-only)
          k := t_ft.count + 1;
          t_ft(k) := pt_attr(i);
          
          -- add ft criteria
          --  by doing a secondary loop
          for j in 1 .. pt_attr.count loop
            if pt_attr(j).inv_type = pt_attr(i).inv_type 
              and j != i
            then
              if pt_attr(j).where_sql is not null then
                t_ft(k).where_sql := t_ft(k).where_sql
                  ||l_and||pt_attr(j).where_sql;
                l_and := ' and ';
              end if;
              
            end if;
          
          end loop;
        
        end if;
        
      end if;
      
    end loop;
    
    
    -- build the effective date where sql
    l_sql_nm_effective_date := nm3dynsql.sql_effective_date(
       --p_bind_count         => l_effective_date_bind_count
       p_date               => l_effective_date
      ,p_start_date_column  => 'nm_start_date'
      ,p_end_date_column    => 'nm_end_date'
    );
    l_sql_iit_effective_date := nm3dynsql.sql_effective_date(
       --p_bind_count         => l_effective_date_bind_count
       p_date               => l_effective_date
      ,p_start_date_column  => 'i.iit_start_date'
      ,p_end_date_column    => 'i.iit_end_date'
    );
    
    
    -- build the standard invitem table source
    if l_sql_iit_criteria is not null then        
      l_sql_members := 
          cr||'select'||l_sql_cardinality
        ||cr||'    nm_obj_type, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp'
        ||cr||'  , nm_date_modified, nm_type, i.rowid iit_rowid, i.iit_date_modified'
        ||cr||'from'
        ||cr||'   nm_members_all'
        ||cr||'  ,nm_inv_items_all i'
            ||l_sql_route_datums_tbl
        ||cr||'where nm_ne_id_in = i.iit_ne_id'
            ||sql_datum_tbl_join('nm_ne_id_of', '  and ')
        ||cr||'  and '||l_sql_nm_effective_date
        ||cr||'  and '||l_sql_iit_effective_date
        ||cr||'  and ('
            ||l_sql_iit_criteria
        ||cr||'    )';
      l_union_all := cr||'union all';
        
    end if;
    
    
    -- connector for ft tables criteria
    if l_sql_route_datums_tbl is null then
      l_where_and := cr||'where ';
    else
      l_where_and := ' and ';
    end if;

    
    -- build the ft table sources
    for i in 1 .. t_ft.count loop
    
      -- it is a virutal nm_inv_items_all table
      if t_ft(i).table_iit_flag = 'Y' then
      
        a1 := 'm'||i;
        a2 := 'i'||i;

        l_sql_ft := l_sql_ft
              ||l_union_all
          ||cr||'select'||l_sql_cardinality
          ||cr||'    '||a1||'.nm_obj_type, '||a1||'.nm_ne_id_in, '||a1||'.nm_ne_id_of, '||a1||'.nm_begin_mp, '||a1||'.nm_end_mp'
          ||cr||'  , '||a1||'.nm_date_modified, '||a1||'.nm_type, null iit_rowid, cast(null as date) iit_date_modified'
          ||cr||'from'
          ||cr||'   nm_members_all '||a1
          ||cr||'  ,'||t_ft(i).table_name||' '||a2
              ||l_sql_route_datums_tbl
          ||cr||'where '||a1||'.nm_ne_id_in = '||a2||'.'||t_ft(i).table_pk_column
              ||sql_datum_tbl_join('nm_ne_id_of', '  and ', a1)
          ||cr||'  and '||l_sql_nm_effective_date
              ||sql_ft_criteria(l_where_and, t_ft(i).where_sql, a2);
      
      
      -- it is a true foreign table
      else
      
        if t_ft(i).table_ne_column is null then
          raise_application_error(-20001,
            'Cannot run merge query. The inventory type '||t_ft(i).inv_type
              ||' is not attatched to network.');
        end if;

        l_sql_ft := l_sql_ft
              ||l_union_all
          ||cr||'select'||l_sql_cardinality
          ||cr||'   '''||t_ft(i).inv_type||''' nm_obj_type'
          ||cr||'  ,'||t_ft(i).table_pk_column||' nm_ne_id_in'
          ||cr||'  ,'||t_ft(i).table_ne_column||' nm_ne_id_of'
          ||cr||'  ,'||t_ft(i).table_begin_column||' nm_begin_mp'
          ||cr||'  ,'||t_ft(i).table_end_column||' nm_end_mp'
          ||cr||'  ,cast(null as date) nm_date_modified'
          ||cr||'  ,''I'' nm_type'
          ||cr||'  ,null iit_rowid'
          ||cr||'  ,cast(null as date) iit_date_modified'
          ||cr||'from'
          ||cr||'   '||t_ft(i).table_name
              ||l_sql_route_datums_tbl
              ||sql_datum_tbl_join(t_ft(i).table_ne_column, 'where ')
              ||sql_ft_criteria(l_where_and, t_ft(i).where_sql);
            
      end if;
            
      l_union_all := cr||'union all';
      
      
    end loop;
    

    
    

    l_sql := 'insert /*+ append */ into nm_mrg_split_results_tmp'
    ||cr||'with mrg as ('
        ||l_sql_members
        ||l_sql_ft
    ||cr||')'
    ||cr||'select' 
    ||cr||'   q1.nm_ne_id_of'
    ||cr||'  ,q1.begin_mp'
    ||cr||'  ,q1.end_mp'
    ||cr||'  ,m.nm_ne_id_in'
    ||cr||'  ,m.nm_obj_type'
    ||cr||'  ,m.nm_type'
    ||cr||'  ,m.nm_date_modified'
    ||cr||'  ,m.iit_rowid'
    ||cr||'  ,m.iit_date_modified'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'   m3.nm_ne_id_of, m3.begin_mp, m3.end_mp'
    ||cr||'from ('
    ||cr||'select distinct'
    ||cr||'   m2.nm_ne_id_of'
    ||cr||'  ,m2.pos begin_mp'
    ||cr||'  ,lead(m2.pos, 1) over (partition by m2.nm_ne_id_of order by m2.pos, m2.pos2) end_mp'
    ||cr||'  ,m2.is_point'
    ||cr||'from ('
    ||cr||'select distinct'
    ||cr||'   nm_ne_id_of'
    ||cr||'  ,nm_begin_mp pos'
    ||cr||'  ,nm_end_mp pos2'
    ||cr||'  ,decode(nm_begin_mp, nm_end_mp, 1, 0) is_point'
    ||cr||'from mrg'
    ||cr||'union all'
    ||cr||'select distinct'
    ||cr||'   nm_ne_id_of'
    ||cr||'  ,nm_end_mp pos'
    ||cr||'  ,nm_end_mp pos2'
    ||cr||'  ,decode(nm_begin_mp, nm_end_mp, 1, 0) is_point'
    ||cr||'from mrg'
    ||cr||') m2'
    ||cr||') m3'
    ||cr||'where m3.end_mp is not null'
    ||cr||'  and (m3.is_point = 1 or m3.end_mp != m3.begin_mp)'
    ||cr||') q1'
    ||cr||',mrg m'
    ||cr||'where q1.nm_ne_id_of = m.nm_ne_id_of'
    ||cr||'  and q1.begin_mp between m.nm_begin_mp and m.nm_end_mp'
    ||cr||'  and q1.end_mp between m.nm_begin_mp and m.nm_end_mp'
    ||cr||'order by q1.nm_ne_id_of, q1.begin_mp, q1.end_mp, m.nm_type, m.nm_obj_type';
    
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql;

    p_splits_rowcount := sql%rowcount;
    commit;
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.ins_splits('
        ||'pt_attr.count='||pt_attr.count
        ||', p_effective_date='||p_effective_date
        ||', p_all_routes='||nm3flx.boolean_to_char(p_all_routes)
        ||')');
      --rollback;
      raise;
    
  end;
  
  
  
  
  -- This populates the nm_mrg_datum_homo_chunks_tmp table
  --  Homogenous datum chunk is a datum piece with same derived values
  procedure ins_datum_homo_chunks(
     pt_attr  in ita_mapping_tbl
    ,pt_itd   in itd_tbl
    ,p_inner_join in boolean
    ,p_splits_rowcount in integer
    ,p_homo_rowcount out integer
  )
  is
    i                 binary_integer;
    l_sql             varchar2(32767);
    l_invitems_where  varchar2(32767);
    l_table_name constant varchar2(30) := 'nm_mrg_datum_homo_chunks_tmp';
    l_cardinality     integer;
    l_sql_inner_join  varchar2(100);
    l_inv_type_count  number(4) := 0;
        
    
    --       q.RCON_MATERIAL
    --||','||case
    --       when q.RCON_LAYER between 1 and 2 then '1'
    --       when q.RCON_LAYER between 3 and 5 then '2'
    --       when q.RCON_LAYER between 6 and 1000 then '3'
    --       else null end
    --||','||q.AD_IIT_ID_CODE
    function sql_hascode_cols(
       p_alias in varchar2
    ) return varchar2
    is
      s varchar2(4000);
      l_cr varchar2(20) := cr||'           ';
      l_band_value  number(4);
      l_case        varchar2(4000);
      k binary_integer;
    begin
      i := pt_attr.first;
      while i is not null loop
        l_band_value := 0;
        l_case := null;
        k := pt_itd.first;
        while k is not null loop
          if pt_attr(i).inv_type = pt_itd(k).itd_inv_type then
            if get_attrib_name(
               p_table_name => pt_attr(i).table_name
              ,p_ita_attrib_name => pt_attr(i).ita_attrib_name
              ,p_iit_attrib_name => pt_attr(i).iit_attrib_name
              ) = pt_itd(k).itd_attrib_name
            then
              l_band_value := l_band_value + 1;
              l_case := l_case
                ||cr||'           when '||p_alias||'.'||pt_attr(i).MRG_ATTRIB||' between '
                    ||pt_itd(k).itd_band_min_value||' and '
                    ||pt_itd(k).itd_band_max_value||' then '||qt||l_band_value||qt;
            end if;
          end if;
          k := pt_itd.next(k);
        end loop;
        
        if l_case is not null then
             s := s||l_cr||'case'||l_case
          ||cr||'           else null end';
        else
          s := s||l_cr||p_alias||'.'||pt_attr(i).MRG_ATTRIB;
        end if;
        
        l_cr := cr||'    ||'',''||';
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    --  ,case when t.nm_type = 'I' and t.nm_obj_type = 'FA' then i.IIT_NUM_ATTRIB100 end FA_NHS
    function sql_case_cols return varchar2
    is
      s       varchar2(4000);
      l_inv_alias varchar(3);
      l_attrib    varchar2(30);
      k       binary_integer := 1;
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).table_name is null then
          l_inv_alias := 'i';
          l_attrib := pt_attr(i).IIT_ATTRIB_NAME;
        else
          if pt_attr(i).seq = 1 then
            k := k + 1;
          end if;
          l_inv_alias := 'i'||k;
          l_attrib := pt_attr(i).ITA_ATTRIB_NAME;
        end if;
        s := s||cr||'  ,case when t.nm_type = ''I'' and t.nm_obj_type = '''||pt_attr(i).INV_TYPE
          ||''' then '||l_inv_alias||'.'||l_attrib||' end '||pt_attr(i).MRG_ATTRIB;
        i := pt_attr.next(i);
      end loop;
      --i := p_groups.first;
      --while i is not null loop
      --  s := s||cr||'  ,case when t.nm_type = ''G'' and t.nm_obj_type = '''||p_groups(i)
      --    ||''' then t.nm_ne_id_in end GROUP_'||p_groups(i)||'_ID';
      --  i := p_groups.next(i);
      --end loop;
      return s;
      
    end;



    --  ,(select 'SECT' ft_inv_type, ft2.* from v_nm_sect ft2) i2
    function sql_ft_sources return varchar2
    is
      s       varchar2(4000);
      k       binary_integer := 1;
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).seq = 1 and pt_attr(i).table_name is not null then
          k := k + 1;
          s := s||cr||'    ,(select '''||pt_attr(i).INV_TYPE||''' ft_inv_type, ft'||k||'.* from '
            ||pt_attr(i).TABLE_NAME||' ft'||k||') i'||k;
        end if;
        i := pt_attr.next(i);
      end loop;
      return s;
    end;

    --  and t.nm_obj_type = i2.ft_inv_type (+)
    --  and t.nm_ne_id_in = i2.ne_id (+)
    function sql_ft_outer_joins return varchar2
    is
      s       varchar2(4000);
      k       binary_integer := 1;
      l_cr    varchar2(10) := '  ,';
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).seq = 1 and pt_attr(i).table_name is not null then
          k := k + 1;
          s := s||cr||'    and t.nm_obj_type = i'||k||'.ft_inv_type (+)'
                ||cr||'    and t.nm_ne_id_in = i'||k||'.'||pt_attr(i).TABLE_PK_COLUMN||' (+)';
        end if;
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    --pragma autonomous_transaction;

  -- main procedure body starts here
  begin
    nm3dbg.putln(g_package_name||'.ins_datum_homo_chunks('
      ||'pt_attr.count='||pt_attr.count
      ||', pt_itd.count='||pt_itd.count
      ||', p_inner_join='||nm3flx.boolean_to_char(p_inner_join)
      ||', p_splits_rowcount='||p_splits_rowcount
      ||')');
    nm3dbg.ind;

    
    l_cardinality := nm3sql.get_rounded_cardinality(p_splits_rowcount);
    
    -- if inner join then add criteria that only chunks 
    --  where all invtypes are present are returned
    if p_inner_join then
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).seq = 1 then
          l_inv_type_count := l_inv_type_count + 1;
        end if;
        i := pt_attr.next(i);
      end loop;
      l_sql_inner_join := cr||'where q6.obj_type_count = '||l_inv_type_count;
      
    end if;
    
    
    l_sql := 
          'select'
    ||cr||'   q6.nm_ne_id_of'
    ||cr||'  ,decode(q6.begin_mp, null, nvl(q6.lag_begin_1, q6.lag_begin_2), q6.begin_mp) nm_begin_mp'
    ||cr||'  ,decode(q6.end_mp, null, nvl(q6.lead_end_1, q6.lead_end_2), q6.end_mp) nm_end_mp'
    ||cr||'  ,min(q6.hash_value) hash_value'
    ||cr||'  ,count(*) chunk_count'
    ||cr||'  ,min(q6.obj_type_count) obj_type_count'
    ||cr||'  ,min(q6.row_count) obj_count'
    ||cr||'  ,max(q6.nm_date_modified) nm_date_modified'
    ||cr||'  ,max(q6.iit_date_modified) iit_date_modified'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'   lag(q5.begin_mp, 1) over (partition by nm_ne_id_of order by q5.rnum ) lag_begin_1'
    ||cr||'  ,lag(q5.begin_mp, 2) over (partition by nm_ne_id_of order by q5.rnum ) lag_begin_2'
    ||cr||'  ,lead(q5.end_mp, 1) over (partition by nm_ne_id_of order by q5.rnum ) lead_end_1'
    ||cr||'  ,lead(q5.end_mp, 2) over (partition by nm_ne_id_of order by q5.rnum ) lead_end_2'
    ||cr||'  ,q5.*'
    ||cr||'from ('
    ||cr||'select q4.nm_ne_id_of, q4.begin_mp, q4.end_mp, q4.hash_value, q4.row_count'
    ||cr||'  ,min(q4.rnum) rnum'
    ||cr||'  ,min(q4.obj_type_count) obj_type_count'
    ||cr||'  ,max(q4.nm_date_modified) nm_date_modified'
    ||cr||'  ,max(q4.iit_date_modified) iit_date_modified'
    ||cr||'from ('
    ||cr||'select'
    --||cr||'   rownum rnum'
    ||cr||'   row_number() over (partition by q3.nm_ne_id_of order by q3.nm_begin_mp) rnum'
    ||cr||'  ,to_number(decode(q3.nm_begin_mp'
    ||cr||'     ,lag(q3.nm_end_mp, 1) over (partition by q3.nm_ne_id_of, q3.hash_value order by q3.nm_begin_mp)'
    ||cr||'     ,null'
    ||cr||'     ,q3.nm_begin_mp'
    ||cr||'   )) begin_mp'
    ||cr||'  ,to_number(decode(q3.nm_end_mp'
    ||cr||'     ,lead(q3.nm_begin_mp, 1) over (partition by q3.nm_ne_id_of, q3.hash_value order by q3.nm_begin_mp)'
    ||cr||'     ,null'
    ||cr||'     ,q3.nm_end_mp'
    ||cr||'   )) end_mp'
    ||cr||'  ,q3.*'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'   q2.nm_ne_id_of'
    ||cr||'  ,q2.nm_begin_mp'
    ||cr||'  ,q2.nm_end_mp'
    ||cr||'  ,group_hash_value(q2.hash_value) hash_value'
    ||cr||'  ,max(q2.nm_date_modified) nm_date_modified'
    ||cr||'  ,max(q2.iit_date_modified) iit_date_modified'
    ||cr||'  ,count(*) row_count'
    ||cr||'  ,count(distinct q2.nm_obj_type) obj_type_count'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'  to_char(dbms_utility.get_hash_value('
        ||sql_hascode_cols('q')
    ||cr||'    ,0, 262144))'
    ||cr||'  ||''_''||dbms_utility.get_hash_value('
        ||sql_hascode_cols('q')||'||'',xxx'''
    ||cr||'    ,0, 262144) hash_value'
    ||cr||'  ,q.*'
    ||cr||'from ('
    ||cr||'select /*+ cardinality(t '||l_cardinality||') */'
    ||cr||'   t.*'
        ||sql_case_cols
    ||cr||'from'
    ||cr||'   nm_mrg_split_results_tmp t'
    ||cr||'  ,nm_inv_items_all i'
        ||sql_ft_sources
    ||cr||'where t.nm_obj_type = i.iit_inv_type (+)'
    ||cr||'  and t.iit_rowid = i.rowid (+)'
        ||sql_ft_outer_joins
    ||cr||') q'
    ||cr||') q2'
    ||cr||'group by q2.nm_ne_id_of, q2.nm_begin_mp, q2.nm_end_mp'
    ||cr||') q3'
    ||cr||') q4'
    ||cr||'group by q4.nm_ne_id_of, q4.begin_mp, q4.end_mp, q4.hash_value, q4.row_count'
    ||cr||') q5'
    ||cr||') q6'
        ||l_sql_inner_join
    ||cr||'group by'
    ||cr||'   q6.nm_ne_id_of'
    ||cr||'  ,decode(q6.begin_mp, null, nvl(q6.lag_begin_1, q6.lag_begin_2), q6.begin_mp)'
    ||cr||'  ,decode(q6.end_mp, null, nvl(q6.lead_end_1, q6.lead_end_2), q6.end_mp)'
    ||cr||'order by'
    ||cr||'   q6.nm_ne_id_of'
    ||cr||'  ,decode(q6.begin_mp, null, nvl(q6.lag_begin_1, q6.lag_begin_2), q6.begin_mp)'
    ||cr||'  ,decode(q6.end_mp, null, nvl(q6.lead_end_1, q6.lead_end_2), q6.end_mp)';
        
    
    -- truncate
    -- nm_mrg_datum_homo_chunks_tmp is global temporary on commit preserve rows
    execute immediate 
      'truncate table nm_mrg_datum_homo_chunks_tmp';
    
    nm3dbg.putln(l_sql);
    
    -- insert
    execute immediate 
      'insert /*+ append */ into '||l_table_name
      ||cr||l_sql;
      
    p_homo_rowcount := sql%rowcount;
      
    commit;
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||'; '||g_package_name||'.ins_datum_homo_chunks('
        ||'pt_attr.count='||pt_attr.count
        ||', pt_itd.count='||pt_itd.count
        ||', p_inner_join='||nm3flx.boolean_to_char(p_inner_join)
        ||', p_splits_rowcount='||p_splits_rowcount
        ||')');
      --rollback;
      raise;

  end;
  

  
  
  function get_where_sql(
     p_operator in nm_mrg_query_attribs.nqa_condition%type
    ,p_ita_format in nm_inv_type_attribs_all.ita_format%type
    ,p_value1 in nm_mrg_query_values.nqv_value%type
    ,p_value2 in nm_mrg_query_values.nqv_value%type
    ,p_nmq_id in nm_mrg_query_all.nmq_id%type
    ,p_nqt_seq_no in nm_mrg_query_types_all.nqt_seq_no%type
    ,p_attrib_name in nm_mrg_query_attribs.nqa_attrib_name%type
  ) return varchar2
  is
    l_sql   varchar2(4000);
    q       varchar2(1);
    l_comma varchar2(2);
    t       nm_code_tbl;
    
  begin
    if p_ita_format = 'VARCHAR2' then
      q := chr(39); -- single quote
    end if;
  
  
    case
    when p_operator is null then
      return null;
      
    when p_operator in ('IN','NOT IN') then
      select q||nqv_value||q value
      bulk collect into t
      from nm_mrg_query_values
      where nqv_nmq_id = p_nmq_id
        and nqv_nqt_seq_no = p_nqt_seq_no
        and nqv_attrib_name = p_attrib_name
      order by nqv_sequence;
      for i in 1 .. t.count loop
        l_sql := l_sql||l_comma||t(i);
        l_comma := ', ';
      end loop;
      l_sql := p_attrib_name||' '||lower(p_operator)||' ('||l_sql||')';
    
    when p_operator in ('BETWEEN', 'NOT BETWEEN') then
      l_sql := p_attrib_name||' '||lower(p_operator)||' '||q||p_value1||q||' and '||q||p_value2||q;
    
    when p_operator in ('IS NULL', 'IS NOT NULL') then
      l_sql := p_attrib_name||' '||lower(p_operator);
    
    else
      l_sql := p_attrib_name||' '||lower(p_operator)||' '||q||p_value1||q;
    
    end case;
    
    return l_sql;
    
  end;
  
 
  
  -- this loads the column mapping to translate a MRG.attribte_name into a IIT_column_name.
  --  Full mapping is given for FT columns.
  -- loaded once per whole processing
  -- It gives the first and second value for attribute where criteria
  -- If IN, or NOT IN is the operator then values need to be looked up separately
  -- If Banding Id is given then bandings need to be looked up for the homo datum merge (step 2)
  procedure load_attrib_metadata(
     pt_attr    out ita_mapping_tbl
    ,pt_itd     out itd_tbl
    ,p_inner_join out boolean
    ,p_nmq_id   in nm_mrg_query_all.nmq_id%type
  )
  is
    i   binary_integer := 0;
    k   binary_integer := 0;
    l_where_attrib varchar2(30);
    l_nmq_inner_outer_join nm_mrg_query_all.nmq_inner_outer_join%type;
    
  begin
    nm3dbg.putln(g_package_name||'.load_attrib_metadata('
      ||'p_nmq_id='||p_nmq_id
      ||')');
  
    -- read the inner/outer join flag
    select nmq_inner_outer_join into l_nmq_inner_outer_join
    from nm_mrg_query_all
    where nmq_id = p_nmq_id;
    if l_nmq_inner_outer_join = 'I' then
      p_inner_join := true;
    else
      p_inner_join := false;
    end if;
        
    -- attribute load loop
    for r in (
      select
         qta.nqt_inv_type
        ,qta.nqt_inv_type||'_'||nvl(ta.ita_view_attri, qta.nqa_attrib_name) mrg_attrib_name
        ,nvl2(t.nit_table_name, nvl(ta.ita_attrib_name, qta.nqa_attrib_name), ta.ita_view_attri) ita_attrib_name
        ,nvl(fta.iit_attrib_name, ta.ita_attrib_name) iit_attrib_name
        ,nvl(ta.ita_format, 'VARCHAR2') ita_format
        ,t.nit_table_name
        ,decode(t.nit_table_name, null, null
          ,nvl((select 'Y' from nm_inv_nw
                where nin_nit_inv_code = qta.nqt_inv_type
                group by nin_nit_inv_code), 'N')
         ) table_iit_flag
        ,t.nit_foreign_pk_column
        ,t.nit_lr_ne_column_name
        ,t.nit_lr_st_chain
        ,t.nit_lr_end_chain
        ,decode(t.nit_table_name,null,ta.ita_view_attri,ta.ita_attrib_name) ita_view_attri
        ,t.nit_pnt_or_cont
        ,qta.nqt_x_sect
        ,qta.nqa_condition
        ,(select min(decode(v.nqv_sequence, 1, v.nqv_value))
          from nm_mrg_query_values v
          where v.nqv_nmq_id = qta.nqa_nmq_id
            and v.nqv_nqt_seq_no = qta.nqa_nqt_seq_no
            and v.nqv_attrib_name = qta.nqa_attrib_name
          ) first_value
        ,(select min(decode(v.nqv_sequence, 2, v.nqv_value))
          from nm_mrg_query_values v
          where v.nqv_nmq_id = qta.nqa_nmq_id
            and v.nqv_nqt_seq_no = qta.nqa_nqt_seq_no
            and v.nqv_attrib_name = qta.nqa_attrib_name
          ) second_value
        ,qta.nqa_itb_banding_id
        ,qta.nqt_seq_no
        ,row_number() over (partition by qta.nqt_inv_type order by ta.ita_attrib_name) attrib_seq
      from
         (select * from nm_mrg_query_attribs, nm_mrg_query_types
          where nqa_nmq_id = nqt_nmq_id
            and nqa_nqt_seq_no = nqt_seq_no
            and nqa_nmq_id = p_nmq_id
         ) qta
        ,nm_inv_type_attribs ta
        ,nm_inv_types_all t
        ,v_nm_ft_attribute_mapping fta
      where qta.nqa_attrib_name = ta.ita_attrib_name (+)
        and qta.nqt_inv_type = ta.ita_inv_type (+)
        and ta.ita_inv_type = fta.ita_inv_type (+)
        and ta.ita_attrib_name = fta.ita_attrib_name (+)
        and qta.nqt_inv_type = t.nit_inv_type
      order by qta.nqt_seq_no, ta.ita_attrib_name
    )
    loop
      i := i + 1;
      pt_attr(i).INV_TYPE           := r.nqt_inv_type;
      pt_attr(i).seq                := r.attrib_seq;
      pt_attr(i).MRG_ATTRIB         := r.mrg_attrib_name;
      pt_attr(i).ITA_ATTRIB_NAME    := r.ita_attrib_name;
      pt_attr(i).IIT_ATTRIB_NAME    := r.iit_attrib_name;
      pt_attr(i).ITA_FORMAT         := r.ita_format;
      pt_attr(i).TABLE_NAME         := r.nit_table_name;
      pt_attr(i).TABLE_IIT_FLAG     := r.table_iit_flag;
      pt_attr(i).TABLE_PK_COLUMN    := r.nit_foreign_pk_column;
      pt_attr(i).TABLE_NE_COLUMN    := r.nit_lr_ne_column_name;
      pt_attr(i).TABLE_BEGIN_COLUMN := r.nit_lr_st_chain;
      pt_attr(i).TABLE_END_COLUMN   := r.nit_lr_end_chain;
      pt_attr(i).PNT_OR_CONT        := r.nit_pnt_or_cont;
      pt_attr(i).XSP                := r.nqt_x_sect;
      
      
      l_where_attrib := get_attrib_name(
         p_table_name => r.nit_table_name
        ,p_ita_attrib_name => r.ita_attrib_name
        ,p_iit_attrib_name => r.iit_attrib_name
      );
      
      pt_attr(i).where_sql := get_where_sql(
           p_operator => r.nqa_condition
          ,p_ita_format => r.ita_format
          ,p_value1 => r.first_value
          ,p_value2 => r.second_value
          ,p_nmq_id => p_nmq_id
          ,p_nqt_seq_no => r.nqt_seq_no
          ,p_attrib_name => l_where_attrib
      );
      
      
      if r.nqa_itb_banding_id is not null then
        for r2 in ( 
          select *
          from nm_inv_type_attrib_band_dets
          where itd_inv_type = r.nqt_inv_type
            and itd_attrib_name = l_where_attrib
            and itd_itb_banding_id = r.nqa_itb_banding_id
          order by itd_band_seq
        )
        loop
          k := k + 1;
          pt_itd(k).itd_inv_type          := r2.itd_inv_type;
          pt_itd(k).itd_attrib_name       := r2.itd_attrib_name;
          pt_itd(k).itd_band_min_value    := r2.itd_band_min_value;
          pt_itd(k).itd_band_max_value    := r2.itd_band_max_value;
          pt_itd(k).itd_band_description  := r2.itd_band_description;
          
        end loop;
          
      end if;

    end loop;
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_attrib_metadata('
        ||'p_nmq_id='||p_nmq_id
        ||')');
      raise;
      
  end;
  
  
  
  -- this populates the standard results table by route connectivity
  --  todo: 
  procedure std_populate(
     p_nmq_id in nm_mrg_query_all.nmq_id%type
    ,pt_attr in ita_mapping_tbl
    ,p_admin_unit_id in nm_admin_units_all.nau_admin_unit%type
    ,p_splits_rowcount in integer
    ,p_homo_rowcount in integer
    ,p_route_id in nm_elements_all.ne_id%type
    ,p_group_type in nm_members_all.nm_obj_type%type
    ,p_all_routes in boolean
    ,p_ignore_poe in boolean
    ,p_description in varchar2
    ,p_mrg_job_id out nm_mrg_query_results_all.nqr_mrg_job_id%type
  )
  is
    type route_inv_rec is record (
       nm_ne_id_in      id_type
      ,chunk_no         number(6)
      ,chunk_seq        number(6)
      ,nm_ne_id_of      id_type
      ,begin_mp         mp_type
      ,end_mp           mp_type
      ,hash_value       hash_type
      ,nm_begin_mp      mp_type
      ,nm_end_mp        mp_type
      ,nt_unit_in       id_type
      ,nt_unit_of       id_type
      ,measure          mp_type
      ,end_measure      mp_type
      ,nm_slk           mp_type
      ,nm_end_slk       mp_type
      ,lag_nm_ne_id_in  id_type
      ,lag_chunk_no     number(6)
      ,lag_chunk_seq    number(6)
      ,lag_hash_value   hash_type
    );
  
    r_res       nm_mrg_query_results_all%rowtype;
    t_sect      nm_mrg_sections_tbl;
    t_memb      nm_mrg_section_members_tbl;
    t_minv      nm_mrg_section_member_inv_tbl;
    t_ival      nm_mrg_section_inv_values_tbl;
    l_chunk_no  number(6);
    i           binary_integer;
    k           binary_integer;
    
    l_sql               varchar2(32767);
    cur                 sys_refcursor;
    l_homo_cardinality  integer;
    r                   route_inv_rec;
    l_nqr_memb_count    integer := 0;
    l_section_id        nm_mrg_sections_all.nms_mrg_section_id%type := 0;
    l_nsm_measure       mp_type := 0;
    
    l_sql_lag_nm_ne_id_in   varchar2(200);

  begin
    nm3dbg.putln(g_package_name||'.std_populate('
      ||'p_nmq_id='||p_nmq_id
      ||', pt_attr.count='||pt_attr.count
      ||', p_admin_unit_id='||p_admin_unit_id
      ||', p_splits_rowcount='||p_splits_rowcount
      ||', p_homo_rowcount='||p_homo_rowcount
      ||', p_route_id='||p_route_id
      ||', p_group_type='||p_group_type
      ||', p_all_routes='||nm3flx.boolean_to_char(p_all_routes)
      ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
      ||', p_description='||p_description
      ||')');
    nm3dbg.ind;
    
    
    l_homo_cardinality := nm3sql.get_rounded_cardinality(p_homo_rowcount);
    
    
    -- assemble by route
    if p_group_type is not null then
      l_sql := nm3dynsql.sql_route_connectivity(
         p_all_routes => p_all_routes
        ,p_route_id   => p_route_id
        ,p_route_type => p_group_type
        ,p_ignore_poe => p_ignore_poe
      );
      
      l_sql_lag_nm_ne_id_in := 
              '  ,lag(qq.nm_ne_id_in, 1, null) over'
        ||cr||'    (order by qq.nm_ne_id_in)';

      
    -- assemble by datum
    else
      l_sql :=
            'select'
      ||cr||'   hc2.*'
      ||cr||'  ,rownum chunk_no'
      ||cr||'from ('
      ||cr||'select'
      ||cr||'   hc.nm_ne_id_of nm_ne_id_in'   -- the datum is the route
      ||cr||'  ,1 chunk_seq'
      ||cr||'  ,hc.nm_ne_id_of'
      ||cr||'  ,hc.nm_begin_mp begin_mp'
      ||cr||'  ,hc.nm_end_mp end_mp'
      ||cr||'  ,hc.hash_value'
      ||cr||'  ,hc.nm_begin_mp'
      ||cr||'  ,hc.nm_end_mp'
      ||cr||'  ,-1 nt_unit_in'
      ||cr||'  ,-1 nt_unit_of'
      ||cr||'  ,hc.nm_begin_mp measure'
      ||cr||'  ,hc.nm_end_mp end_measure'
      ||cr||'  ,cast(null as number) nm_slk'
      ||cr||'  ,cast(null as number) nm_end_slk'
      ||cr||'from nm_mrg_datum_homo_chunks_tmp hc'
      ||cr||'order by hc.nm_ne_id_of, hc.nm_begin_mp'
      ||cr||') hc2';
      
      l_sql_lag_nm_ne_id_in := '  ,to_number(null)';
    
    end if;
    
    l_sql :=
          'select /*+ cardinality(inv '||l_homo_cardinality||') */'
    ||cr||'   qq.nm_ne_id_in'
    ||cr||'  ,qq.chunk_no'
    ||cr||'  ,qq.chunk_seq'
    ||cr||'  ,qq.nm_ne_id_of'
    ||cr||'  ,greatest(inv.nm_begin_mp, qq.nm_begin_mp) begin_mp'
    ||cr||'  ,least(inv.nm_end_mp, qq.nm_end_mp) end_mp'
    ||cr||'  ,inv.hash_value'
    ||cr||'  ,qq.nm_begin_mp'
    ||cr||'  ,qq.nm_end_mp'
    ||cr||'  ,qq.nt_unit_in'
    ||cr||'  ,qq.nt_unit_of'
    ||cr||'  ,qq.measure'
    ||cr||'  ,qq.end_measure'
    ||cr||'  ,qq.nm_slk'
    ||cr||'  ,qq.nm_end_slk'
    ||cr||'  ,lag(qq.nm_ne_id_in, 1, null) over'
    ||cr||'    (order by qq.nm_ne_id_in) lag_nm_ne_id_in'
    ||cr||'  ,lag(qq.chunk_no, 1, null) over'
    ||cr||'    (partition by qq.nm_ne_id_in order by qq.chunk_no) lag_chunk_no'
    ||cr||'  ,lag(qq.chunk_seq, 1, null) over'
    ||cr||'    (partition by qq.nm_ne_id_in, qq.chunk_no order by qq.chunk_seq, inv.nm_begin_mp) lag_chunk_seq'
    ||cr||'  ,lag(inv.hash_value, 1, null) over'
    ||cr||'    (partition by qq.nm_ne_id_in, qq.chunk_no order by qq.chunk_seq, inv.nm_begin_mp) lag_hash_value'
    ||cr||'from'
    ||cr||'('
    ||cr||l_sql
    ||cr||') qq'
    ||cr||', nm_mrg_datum_homo_chunks_tmp inv'
    ||cr||'where qq.nm_ne_id_of = inv.nm_ne_id_of'    
    ||cr||'  and ((qq.nm_begin_mp < inv.nm_end_mp and qq.nm_end_mp > inv.nm_begin_mp)'
    ||cr||'    or ((qq.nm_begin_mp = qq.nm_end_mp or inv.nm_begin_mp = inv.nm_end_mp)'
    ||cr||'      and (qq.nm_begin_mp = inv.nm_end_mp or qq.nm_end_mp = inv.nm_begin_mp)))'
    ||cr||'order by 1, 2, 3, 5'
    ;
    

    nm3dbg.putln(l_sql);
    
    
    -- init static vaules
    r_res.NQR_NMQ_ID := p_nmq_id;
    r_res.NQR_SOURCE := 'ROUTE';
    r_res.NQR_ADMIN_UNIT := p_admin_unit_id;
    
    
    nm3dbg.putln('open route connectivity query');
    
    
    -- chunk_no identifies the connected chunk within route
    --  (each route can have many distinct connected chunks
    --    because of breaks in connectivity)
    -- cunk_seq is the order by of the pieces within chunk
  

    open cur for l_sql;
    loop
      fetch cur into r;
      exit when cur%notfound;

      -- same route
      if r.nm_ne_id_in = r.lag_nm_ne_id_in then null;
        --nm3dbg.putln('null: '||r.nm_ne_id_in||'  '||r.lag_nm_ne_id_in);
        
      -- new route (new results record)
      else
        --nm3dbg.putln('r_res.nqr_mrg_job_id='||r_res.nqr_mrg_job_id);
        
        if r_res.nqr_mrg_job_id is not null then
        
          -- add the final values
          r_res.nqr_mrg_section_members_count := t_memb.count;
          
          -- insert the previous route results into the tables
          forall i in 1 .. t_sect.count
            insert into nm_mrg_sections_all values t_sect(i);
          forall i in 1 .. t_memb.count
            insert into nm_mrg_section_members values t_memb(i);
          
        end if;
        
        -- init the new results record
        l_nqr_memb_count := l_nqr_memb_count + t_memb.count;
        t_sect.delete;
        t_minv.delete;
        t_memb.delete;
        t_ival.delete;
        l_chunk_no := 0;
        
        if r_res.nqr_mrg_job_id is null then
          r_res.nqr_mrg_job_id := nm3seq.next_rtg_job_id_seq;
          r_res.nqr_description := p_description;
          r_res.nqr_source_id := r.NM_NE_ID_IN;
          r_res.nqr_mrg_section_members_count := 0;
          r_res.nqr_admin_unit := p_admin_unit_id;
          insert into nm_mrg_query_results_all values r_res;
        end if;
        
      end if;
      
      
      
      
      -- same section 
      if r.nm_ne_id_in = r.lag_nm_ne_id_in        -- new route
        and r.chunk_no = r.lag_chunk_no           -- new route chunk
        and r.hash_value = r.lag_hash_value       -- different inv attribute values
        and r.begin_mp <= r.nm_begin_mp           -- gap between same inv attribute values
        and r.chunk_seq - r.lag_chunk_seq <= 1    -- gap between chunk sequences
        
      then
        null;
         
      
      -- new section
      else
        --nm3dbg.putln('new section i='||i);
      
        -- start new section
        i             := t_sect.count + 1;
        l_section_id  := l_section_id + 1;
        l_chunk_no    := l_chunk_no + 1;
        l_nsm_measure := 0;
        
        t_sect(i).nms_mrg_job_id      := r_res.nqr_mrg_job_id;
        t_sect(i).nms_mrg_section_id  := l_section_id;
        t_sect(i).nms_offset_ne_id    := r.nm_ne_id_in;
        
        -- begin offset
        if r.nt_unit_in = r.nt_unit_of then
          t_sect(i).nms_begin_offset  := nvl(r.nm_slk, r.measure) + (r.begin_mp - r.nm_begin_mp);
        else
          if r.nm_slk is null then
            t_sect(i).nms_begin_offset  := nm3unit.convert_unit(
                r.nt_unit_of, r.nt_unit_in, r.measure + (r.begin_mp - r.nm_begin_mp));
          else
            t_sect(i).nms_begin_offset  := r.nm_slk + nm3unit.convert_unit(
                r.nt_unit_of, r.nt_unit_in, (r.begin_mp - r.nm_begin_mp));
          end if;      
        end if;

        t_sect(i).nms_end_offset      := null;
        t_sect(i).nms_ne_id_first     := r.nm_ne_id_of;
        t_sect(i).nms_begin_mp_first  := r.begin_mp;
        t_sect(i).nms_ne_id_last      := null;
        t_sect(i).nms_end_mp_last     := null;
        t_sect(i).nms_in_results      := 'Y';
        t_sect(i).nms_orig_sect_id    := l_chunk_no;

      end if;
      
      
      -- carry forward the section end values
      t_sect(i).nms_ne_id_last  := r.nm_ne_id_of;
      t_sect(i).nms_end_mp_last := r.end_mp;
      
      -- end offset
      if r.nt_unit_in = r.nt_unit_of then
        t_sect(i).nms_end_offset  := nvl(r.nm_end_slk, r.end_measure) - (r.nm_end_mp - r.end_mp);
      else
        if r.nm_end_slk is null then
          t_sect(i).nms_end_offset  := nm3unit.convert_unit(
              r.nt_unit_of, r.nt_unit_in, r.end_measure - (r.nm_end_mp - r.end_mp));
        else
          t_sect(i).nms_end_offset  := r.nm_end_slk - nm3unit.convert_unit(
              r.nt_unit_of, r.nt_unit_in, (r.nm_end_mp - r.end_mp));
        end if;      
      end if;
    
      
      -- handle the section member record
      k := t_memb.count + 1;
      t_memb(k).nsm_mrg_job_id      := t_sect(i).nms_mrg_job_id;
      t_memb(k).nsm_mrg_section_id  := t_sect(i).nms_mrg_section_id;
      t_memb(k).nsm_ne_id           := r.nm_ne_id_of;
      t_memb(k).nsm_begin_mp        := r.begin_mp;
      t_memb(k).nsm_end_mp          := r.end_mp;
      t_memb(k).nsm_measure         := l_nsm_measure;
      
      l_nsm_measure := l_nsm_measure + (r.end_mp - r.begin_mp);
      
      
    end loop;
    
    close cur;
    
    
    
    -- last one after loop        
    if r_res.nqr_mrg_job_id is not null then
    
      -- set the members count
      l_nqr_memb_count := l_nqr_memb_count + t_memb.count;
      update nm_mrg_query_results_all
        set nqr_mrg_section_members_count = l_nqr_memb_count
      where nqr_mrg_job_id = r_res.nqr_mrg_job_id;
      
      -- insert the last route results into the tables
      forall i in 1 .. t_sect.count
        insert into nm_mrg_sections_all values t_sect(i);
      forall i in 1 .. t_memb.count
        insert into nm_mrg_section_members values t_memb(i);
      
      -- insert all invitems
      std_insert_invitems(
         p_mrg_job_id => r_res.nqr_mrg_job_id
        ,pt_attr => pt_attr
        ,p_splits_rowcount => p_splits_rowcount
      );
          
    end if;
    
    -- assign the out value
    p_mrg_job_id := r_res.nqr_mrg_job_id;
  
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.std_populate('
        ||'p_nmq_id='||p_nmq_id
        ||', pt_attr.count='||pt_attr.count
        ||', p_admin_unit_id='||p_admin_unit_id
        ||', p_splits_rowcount='||p_splits_rowcount
        ||', p_homo_rowcount='||p_homo_rowcount
        ||', p_route_id='||p_route_id
        ||', p_group_type='||p_group_type
        ||', p_all_routes='||nm3flx.boolean_to_char(p_all_routes)
        ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
        ||', l_homo_cardinality='||l_homo_cardinality
        ||')');
      raise;
   
  end;
  
  
  
  -- This is the main procedure to be called from outside
  -- NB! to ensure absolute consistency precede the call to this procedure with
  --  set transaction isolation lelvel serializable
  procedure std_run(
     p_nmq_id in nm_mrg_query_all.nmq_id%type
    ,p_nqr_admin_unit in nm_mrg_query_results_all.nqr_admin_unit%type
    ,p_nmq_descr in nm_mrg_query_all.nmq_descr%type
    ,p_route_id in nm_elements_all.ne_id%type
    ,p_group_type in nm_members_all.nm_obj_type%type
    ,p_all_routes in boolean
    ,p_ignore_poe in boolean
    ,p_mrg_job_id out nm_mrg_query_results_all.nqr_mrg_job_id%type
    ,p_longops_rec in out nm3sql.longops_rec
  )
  is
    t_inv             nm3bulk_mrg.ita_mapping_tbl;
    t_idt             nm3bulk_mrg.itd_tbl;
    l_inner_join      boolean;
    l_effective_date  constant date := nm3user.get_effective_date;
    l_all_routes      boolean := false;
    l_ignore_poe      boolean := true;
    l_splits_rowcount integer;
    l_homo_rowcount   integer;
    
    pragma autonomous_transaction;
    
  begin
    nm3dbg.putln(g_package_name||'.std_run('
      ||'p_nmq_id='||p_nmq_id
      ||', p_nqr_admin_unit='||p_nqr_admin_unit
      ||', p_nmq_descr='||p_nmq_descr
      ||', p_route_id='||p_route_id
      ||', p_group_type='||p_group_type
      ||', p_all_routes='||nm3flx.boolean_to_char(p_all_routes)
      ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
      ||')');
    nm3dbg.ind;
        
    load_attrib_metadata(
       pt_attr  => t_inv
      ,pt_itd   => t_idt
      ,p_inner_join => l_inner_join
      ,p_nmq_id => p_nmq_id
    );
    ins_splits(
       pt_attr            => t_inv
      ,p_effective_date   => l_effective_date
      ,p_all_routes       => false
      ,p_splits_rowcount  => l_splits_rowcount    -- out
    );
    commit;
    nm3sql.set_longops(p_rec => p_longops_rec, p_increment => 1);
    ins_datum_homo_chunks(
       pt_attr          => t_inv
      ,pt_itd           => t_idt
      ,p_inner_join     => l_inner_join
      ,p_splits_rowcount => l_splits_rowcount -- in
      ,p_homo_rowcount  => l_homo_rowcount    -- out
    );
    commit;
    nm3sql.set_longops(p_rec => p_longops_rec, p_increment => 1);
    std_populate(
       p_nmq_id         => p_nmq_id
      ,pt_attr          => t_inv
      ,p_admin_unit_id  => p_nqr_admin_unit
      ,p_splits_rowcount => l_splits_rowcount -- in
      ,p_homo_rowcount  => l_homo_rowcount    -- in
      ,p_route_id       => p_route_id
      ,p_group_type     => p_group_type
      ,p_all_routes     => l_all_routes
      ,p_ignore_poe     => l_ignore_poe
      ,p_description    => p_nmq_descr
      ,p_mrg_job_id     => p_mrg_job_id       -- out
    );
    commit;
    nm3sql.set_longops(p_rec => p_longops_rec, p_increment => 1);
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.std_run('
        ||'p_nmq_id='||p_nmq_id
        ||', p_nqr_admin_unit='||p_nqr_admin_unit
        ||', p_nmq_descr='||p_nmq_descr
        ||', p_route_id='||p_route_id
        ||', p_group_type='||p_group_type
        ||', p_all_routes='||nm3flx.boolean_to_char(p_all_routes)
        ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
        ||')');
      rollback;
      raise;
      
  end;
    
  
  
  
  
  -- this populates the section_inv_values and section_member_inv tables
  --  todo: 
  procedure std_insert_invitems(
     p_mrg_job_id in nm_mrg_query_results_all.nqr_mrg_job_id%type
    ,pt_attr in ita_mapping_tbl
    ,p_splits_rowcount in integer
  )
  is
    cr            constant varchar2(1) := chr(10);
    l_sql         varchar2(32767);
    i             binary_integer;
    l_splits_cardinality integer;
    
    
    -- This is used in bulk insert
    --  ,case i.iit_inv_type
    --   when 'RSCS' then i.IIT_MATERIAL
    --   end NSV_ATTRIB1
    function sql_case_cols return varchar2
    is
      s       varchar2(4000);
      l_inv_alias varchar(3);
      l_attrib    varchar2(30);
      k       binary_integer := 1;
      j       binary_integer := 0;
    begin
      i := pt_attr.first;
      while i is not null loop
        j := j + 1;
        if pt_attr(i).table_name is null then
          l_inv_alias := 'i';
          l_attrib := pt_attr(i).IIT_ATTRIB_NAME;
        else
          if pt_attr(i).seq = 1 then
            k := k + 1;
          end if;
          l_inv_alias := 'i'||k;
          l_attrib := pt_attr(i).ITA_ATTRIB_NAME;
        end if;
        s := s||cr||'  ,case t.nm_obj_type'
          ||cr||'    when '''||pt_attr(i).INV_TYPE
          ||''' then '||l_inv_alias||'.'||l_attrib||' end NSV_ATTRIB'||j;
        i := pt_attr.next(i);
      end loop;
      return s;
      
    end;
    
    
    --  ,(select 'SECT' ft_inv_type, ft2.* from v_nm_sect ft2) i2
    function sql_ft_sources return varchar2
    is
      s       varchar2(4000);
      k       binary_integer := 1;
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).seq = 1 and pt_attr(i).table_name is not null then
          k := k + 1;
          s := s||cr||'    ,(select '''||pt_attr(i).INV_TYPE||''' ft_inv_type, ft'||k||'.* from '
            ||pt_attr(i).TABLE_NAME||' ft'||k||') i'||k;
        end if;
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    --  and t.nm_obj_type = i2.ft_inv_type (+)
    --  and t.nm_ne_id_in = i2.ne_id (+)
    function sql_ft_outer_joins return varchar2
    is
      s       varchar2(4000);
      k       binary_integer := 1;
      l_cr    varchar2(10) := '  ,';
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).seq = 1 and pt_attr(i).table_name is not null then
          k := k + 1;
          s := s||cr||'    and t.nm_obj_type = i'||k||'.ft_inv_type (+)'
                ||cr||'    and t.nm_ne_id_in = i'||k||'.'||pt_attr(i).TABLE_PK_COLUMN||' (+)';
        end if;
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    

    
    --, nsv_attrib1, nsv_attrib2, nsv_attrib3
    function sql_nsv_attrib_cols(
       p_min in boolean
    ) return varchar2
    is
      s       varchar2(4000);
      j       binary_integer := 0;
      l_min   varchar2(4);
      l_min2  varchar2(1);
      l_cr    varchar2(1);
    begin
      i := pt_attr.first;
      if p_min then
        l_min := 'min(';
        l_min2 := ')';
      end if;
      while i is not null loop
        j := j + 1;
        if j mod 5 = 0 then
          l_cr := cr;
        else
          l_cr := null;
        end if;
        s := s||', '||l_min||'nsv_attrib'||j||l_min2;
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    --  ,case
    --   when i.nm_obj_type in ('SAMP','SAMP','SAMP') then 'C'
    --   end pnt_or_cont
    function sql_pnt_or_cont return varchar2
    is
      s         varchar2(4000);
      s_pnt     varchar2(4000);
      s_cont    varchar2(4000);
      l_pnt_comma varchar2(1);
      l_cont_comma varchar2(1);
      j         binary_integer := 0;
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).pnt_or_cont = 'P' then
          s_pnt := s_pnt||l_pnt_comma||''''||pt_attr(i).inv_type||'''';
          l_pnt_comma := ',';
        elsif pt_attr(i).pnt_or_cont = 'C' then
          s_cont := s_cont||l_cont_comma||''''||pt_attr(i).inv_type||'''';
          l_cont_comma := ',';
        end if;
        if s_cont is not null and s_pnt is not null then
          s :=  cr||'  ,case'
              ||cr||'   when i.nm_obj_type in ('||s_cont||') then ''C'''
              ||cr||'   when i.nm_obj_type in ('||s_pnt||') then ''P'''
              ||cr||'   end pnt_or_cont';
        elsif s_cont is not null then
          s := cr||'  ,''C'' pnt_or_cont';
        elsif s_pnt is not null then
          s := cr||'  ,''P'' pnt_or_cont';
        else
          s := cr||'  ,null pnt_or_cont';
        end if;
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    
    -- and ((q.nsv_attrib1 is null and q2.nsv_attrib1 is null) or q.nsv_attrib1 = q2.nsv_attrib1)
    function sql_nsv_attrib_join(
       p_a1 in varchar2
      ,p_a2 in varchar2
    ) return varchar2
    is
      s       varchar2(4000);
      j       binary_integer := 0;
    begin
      i := pt_attr.first;
      while i is not null loop
        j := j + 1;
        s := s||cr||'  and (('||p_a1||'.nsv_attrib'||j||' is null and '||p_a2||'.nsv_attrib'||j
          ||' is null) or '||p_a1||'.nsv_attrib'||j||' = '||p_a2||'.nsv_attrib'||j||')';
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    
  -- main procedure body starts here
  begin
    nm3dbg.putln(g_package_name||'.std_insert_invitems('
      ||'p_mrg_job_id='||p_mrg_job_id
      ||', pt_attr.count='||pt_attr.count
      ||', pt_attr.count='||p_splits_rowcount 
      ||')');
    nm3dbg.ind;
    
    l_splits_cardinality := nm3sql.get_rounded_cardinality(p_splits_rowcount);
    
    
    -- the inv items insert is a 3 step process:
    --  1) work out all the inv item values toghter with the mrg_section_id values
    --      insert this all into a temp table (non-preserving)
    --  2) from the temp results select and insert all distinct inv values
    --  3) from the temp results select and insert the section members records
    --
    --  when handling FT tables the logic logic here is optimized for a single route
    --  there are two ways of getting FT values:
    --    1) perform inline selects on ft table pk
    --    2) outer-join all ft tables
    --  the inline selects are better for small amounts of data, joins are better for large
    
    
    
    -- 1. insert into the temp table
    --      nm_mrg_section_inv_values_tmp is temporary table with on commit delete rows
    l_sql := 
          'insert into nm_mrg_section_inv_values_tmp('
    ||cr||'  nsi_mrg_section_id, nsv_mrg_job_id, nsv_value_id, nsv_inv_type, nsv_x_sect, nsv_pnt_or_cont'
    ||cr||sql_nsv_attrib_cols(p_min => false)
    ||cr||')'
    ||cr||'with src as ('
    ||cr||'select /*+ cardinality(t '||l_splits_cardinality||') */'
    ||cr||'   t.nm_obj_type'
    ||cr||'  ,i.iit_x_sect'
    ||cr||'  ,m.nsm_mrg_section_id'
    ||cr||'  ,m.nsm_ne_id'
    ||cr||'  ,m.nsm_begin_mp'
    ||cr||'  ,m.nsm_end_mp'
        --||sql_inline_case_cols
        ||sql_case_cols
    ||cr||'from'
    ||cr||'   nm_mrg_section_members m'
    ||cr||'  ,nm_mrg_split_results_tmp t'
    ||cr||'  ,nm_inv_items_all i'
        ||sql_ft_sources
    ||cr||'where m.nsm_mrg_job_id = :p_mrg_job_id'
    ||cr||'  and m.nsm_ne_id = t.nm_ne_id_of'
    ||cr||'  and ((t.nm_begin_mp < m.nsm_end_mp and t.nm_end_mp > m.nsm_begin_mp)'
    ||cr||'    or ((t.nm_begin_mp = t.nm_end_mp or m.nsm_begin_mp = m.nsm_end_mp)'
    ||cr||'      and (t.nm_begin_mp = m.nsm_end_mp or t.nm_end_mp = m.nsm_begin_mp)))'
    ||cr||'  and t.iit_rowid = i.rowid (+)'
        ||sql_ft_outer_joins
    ||cr||')'
    ||cr||'select distinct'
    ||cr||'   m1.nsm_mrg_section_id'
    ||cr||'  ,i3.*'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'  :p_mrg_job_id mrg_job_id'
    ||cr||'  ,rownum value_id'
    ||cr||'  ,i2.*'
    ||cr||'from ('
    ||cr||'select distinct'
    ||cr||'   i.nm_obj_type'
    ||cr||'  ,i.iit_x_sect'
        ||sql_pnt_or_cont
    ||cr||sql_nsv_attrib_cols(p_min => false)
    ||cr||'from'
    ||cr||'   src i'
    ||cr||') i2'
    ||cr||') i3'
    ||cr||',('
    ||cr||'  select'
    ||cr||'     :p_mrg_job_id mrg_job_id'
    ||cr||'    ,m.*'
    ||cr||'  from src m'
    ||cr||'  ) m1'
    ||cr||'where i3.mrg_job_id = m1.mrg_job_id'
    ||cr||'  and i3.nm_obj_type = m1.nm_obj_type'
    ||cr||'  and ((i3.iit_x_sect is null and m1.iit_x_sect is null) or i3.iit_x_sect = m1.iit_x_sect)'
        ||sql_nsv_attrib_join('i3','m1');

    nm3dbg.putln(l_sql);
    execute immediate l_sql using p_mrg_job_id, p_mrg_job_id, p_mrg_job_id;
    
    nm3dbg.putln('1 sql%rowcount='||sql%rowcount);
    
    
    
    -- 2. insert the item values
    l_sql := 
      'insert into nm_mrg_section_inv_values_all('
    ||cr||'  nsv_mrg_job_id, nsv_value_id, nsv_inv_type, nsv_x_sect, nsv_pnt_or_cont'
    ||cr||sql_nsv_attrib_cols(p_min => false)
    ||cr||')'
    ||cr||'select'
    ||cr||'  nsv_mrg_job_id, nsv_value_id, min(nsv_inv_type), min(nsv_x_sect), min(nsv_pnt_or_cont)'
    ||cr||sql_nsv_attrib_cols(p_min => true)
    ||cr||'from nm_mrg_section_inv_values_tmp'
    ||cr||'group by nsv_mrg_job_id, nsv_value_id';
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql;
    
    nm3dbg.putln('2 sql%rowcount='||sql%rowcount);
    
    
    
    -- 3. insert item member records
    insert into nm_mrg_section_member_inv (
      nsi_mrg_job_id, nsi_mrg_section_id, nsi_inv_type, nsi_x_sect, nsi_value_id
    )
    select
      nsv_mrg_job_id, nsi_mrg_section_id, nsv_inv_type, nsv_x_sect, nsv_value_id
    from nm_mrg_section_inv_values_tmp;
    
    nm3dbg.putln('3 sql%rowcount='||sql%rowcount);
    
  
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.std_insert_invitems('
        ||'p_mrg_job_id='||p_mrg_job_id
        ||', pt_attr.count='||pt_attr.count
        ||', pt_attr.count='||p_splits_rowcount 
        ||')');
      raise;

  end;
  
  
  
  procedure load_group_datums(
     p_group_id in nm_elements_all.ne_id%type
  )
  is
    cur sys_refcursor;
  begin
    open cur for
      select distinct nm_ne_id_of
      from nm_members
      where nm_ne_id_in = p_group_id;
    nm3sql.load_id_tbl(cur);
  end;
  
  
  procedure load_group_type_datums(
     p_group_type in nm_members_all.nm_obj_type%type
  )
  is
    cur sys_refcursor;
  begin
    open cur for
      select distinct nm_ne_id_of
      from nm_members
      where nm_obj_type = p_group_type;
    nm3sql.load_id_tbl(cur);
  end;
  
  
  procedure load_extent_datums(
     p_nse_id in nm_saved_extents.nse_id%type
  )
  is
    cur sys_refcursor;
  begin
    open cur for
      select distinct d.nsd_ne_id
      from nm_saved_extent_member_datums d
      where d.nsd_nse_id = p_nse_id;
    nm3sql.load_id_tbl(cur);
  end;  
  
  
  
  
  -- this builds the effective date where clause for dynamic sql
  procedure make_sql_effective_date(
     p_sql out varchar2
    ,p_bind_count in out integer
    ,p_date in date
    ,p_start_date_column in varchar2
    ,p_end_date_column in varchar2
  )
  is
    l_bind_count integer := nvl(p_bind_count, 0);
  begin
    if p_date = trunc(sysdate) then
      p_sql := p_end_date_column||' is null';
      p_bind_count := l_bind_count + 0;
    else
      p_sql := p_start_date_column||' <= :p_effective_date and '
        ||'nvl('||p_end_date_column||', :p_effective_date) > :p_effective_date';
      p_bind_count := l_bind_count + 3;
    end if;
  end;
  
  
  
  --
  function get_attrib_name(
     p_table_name in varchar2
    ,p_ita_attrib_name in varchar2
    ,p_iit_attrib_name in varchar2
  ) return varchar2
  is
  begin
    if p_table_name is null then
      return p_iit_attrib_name;
    else
      return p_ita_attrib_name;
    end if;
  end;
  
  
  

  
  -- debug to_string
  function to_string_ita_mapping_rec(
     p_rec in ita_mapping_rec
  ) return varchar2
  is
    s varchar2(4000);
  begin
    select '('
      ||'inv_type='||p_rec.inv_type
      ||', seq='||p_rec.seq
      ||', mrg_attrib='||p_rec.mrg_attrib
      ||', ita_attrib_name='||p_rec.ita_attrib_name
      ||', iit_attrib_name='||p_rec.iit_attrib_name
      ||', ita_format='||p_rec.ita_format
      ||nvl2(p_rec.table_name, ', table_name='||p_rec.table_name, null)
      ||nvl2(p_rec.table_iit_flag, ', table_iit_flag='||p_rec.table_iit_flag, null)
      ||nvl2(p_rec.table_pk_column, ', table_pk_column='||p_rec.table_pk_column, null)
      ||nvl2(p_rec.table_ne_column, ', table_ne_column='||p_rec.table_ne_column, null)
      ||nvl2(p_rec.table_begin_column, ', table_begin_column='||p_rec.table_begin_column, null)
      ||nvl2(p_rec.table_end_column, ', table_end_column='||p_rec.table_end_column, null)
      ||', pnt_or_cont='||p_rec.pnt_or_cont
      ||nvl2(p_rec.xsp, ', xsp='||p_rec.xsp, null)
      ||nvl2(p_rec.where_sql, ', where_sql='||p_rec.where_sql, null)
      ||')'
      into s from dual;
      return s;
  end;
  
  function to_string_itd_rec(
     p_rec in nm_inv_type_attrib_band_dets%rowtype
  ) return varchar2
  is
  begin
    return '('
      ||'inv_type='||p_rec.itd_inv_type
      ||', attrib_name='||p_rec.itd_attrib_name
      ||', band_min_value='||p_rec.itd_band_min_value
      ||', band_max_value='||p_rec.itd_band_max_value
      ||', band_description='||p_rec.itd_band_description
      ||')';
  end;

  
  
  function to_string_nm_obj_type_tbl(
     p_tbl in nm_obj_type_tbl
  ) return varchar2
  is
    i         binary_integer := p_tbl.first;
    l_comma   varchar2(2);
    s         varchar2(4000);
    
  begin
    while i is not null loop
      s := s||l_comma||p_tbl(i);
      l_comma := ', ';
      i := p_tbl.next(i);
    end loop;
    return '('||s||')';
    
  end;
  
  
  
  -- this assignes the group type based on the group types of the loaded criteria datums
  --  if the p_group_type_in is found and fully covered the this is returned
  --  if any other type is the only group type covering the datums fully then this is returned
  --  p_group_type_out is null in any other cases
  procedure process_datums_group_type(
     p_group_type_in  in nm_group_types_all.ngt_group_type%type
    ,p_group_type_out out nm_group_types_all.ngt_group_type%type
  )
  is
    l_count       integer := nm3sql.get_id_tbl_count;
    l_cardinality integer := nm3sql.get_rounded_cardinality(l_count);

    type  group_type_tbl  is table of nm_group_types_all.ngt_group_type%type index by binary_integer;
    type  count_tbl       is table of integer index by binary_integer;
    t_group_types group_type_tbl;
    t_counts      count_tbl;
    
  begin
    execute immediate
            'select /*+ cardinality(x '||l_cardinality||') */'
      ||cr||'   nm_obj_type'
      ||cr||'  ,count(*) cnt'
      ||cr||'from'
      ||cr||'   table(cast(nm3sql.get_id_tbl as nm_id_tbl)) x'
      ||cr||'  ,nm_members m'
      ||cr||'  ,nm_group_types gt'
      ||cr||'where x.column_value = m.nm_ne_id_of'
      ||cr||'  and m.nm_obj_type = gt.ngt_group_type'
      ||cr||'  and m.nm_type = ''G'''
      ||cr||'  and gt.ngt_linear_flag = ''Y'''
      ||cr||'  and gt.ngt_exclusive_flag = ''Y'''
      ||cr||'group by nm_obj_type'
      ||cr||'having count(*) = :p_count'
      ||cr||'order by decode(nm_obj_type, :p_group_type, 1, 2)'
    bulk collect into
       t_group_types
      ,t_counts
    using
       l_count
      ,p_group_type_in;
      
    
    -- if p_group_type_in is found then return this in any case
    --  return any other group type only if it is they only one found
    for i in 1 .. t_group_types.count loop
      if i = 1 then
        p_group_type_out := p_group_type_in;
        
      elsif p_group_type_out != p_group_type_in then
        p_group_type_out := null;

      end if;
    
    end loop;
    
    nm3dbg.putln(g_package_name||'.process_group_type('
      ||'p_group_type_in='||p_group_type_in
      ||', p_group_type_out='||p_group_type_out
      ||')');
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.process_group_type('
        ||'p_group_type_in='||p_group_type_in
        ||', p_group_type_out='||p_group_type_out
        ||')');
      raise;

  end;
  


  
/* exec_splits_query

select 
   q1.nm_ne_id_of
  ,q1.begin_mp
  ,q1.end_mp
  ,m.nm_ne_id_in
  ,m.nm_obj_type
  ,m.nm_type
  ,m.nm_date_modified
  ,i.rowid iit_rowid
  ,i.iit_date_modified
from
   (
    select m3.nm_ne_id_of, m3.begin_mp, m3.end_mp
    from
       (
        select distinct m2.nm_ne_id_of
          ,m2.pos begin_mp
          ,lead(m2.pos, 1) over (partition by m2.nm_ne_id_of order by m2.pos, m2.pos2) end_mp
          ,m2.is_point
        from 
           (
            with mrg as (
            select distinct m.nm_ne_id_of, m.nm_begin_mp, m.nm_end_mp
            from
               nm_members_all m
            where m.nm_end_date is null
              and m.nm_obj_type in (
                'SECT','SAMP','FC','MET','THRU','POP','FA','RUTP','NONA','SSYS','DNUT'
                )
        union all
        select
           NE_ID nm_ne_id_of
          ,NE_BEGIN_MP nm_begin_mp
          ,NE_LENGTH nm_end_mp
        from V_NM_SECT
        )
         select distinct
            nm_ne_id_of
           ,nm_begin_mp pos
           ,nm_end_mp pos2
           ,decode(nm_begin_mp, nm_end_mp, 1, 0) is_point
         from mrg
         union all
         select distinct
            nm_ne_id_of
           ,nm_end_mp pos
           ,nm_end_mp pos2
           ,decode(nm_begin_mp, nm_end_mp, 1, 0) is_point
         from mrg
        ) m2
      ) m3
      where m3.end_mp is not null
       and (m3.is_point = 1 or m3.end_mp != m3.begin_mp)
  ) q1
 ,(
   select nm_obj_type, nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp
     , nm_date_modified, nm_type
   from nm_members_all
   where nm_end_date is null
     and nm_obj_type in (
       'SECT','SAMP','FC','MET','THRU','POP','FA','RUTP','NONA','SSYS','DNUT'
       )
   union all
   select
      'SECT' nm_obj_type
     ,NE_FT_PK_COL nm_ne_id_in
     ,NE_ID nm_ne_id_of
     ,NE_BEGIN_MP nm_begin_mp
     ,NE_LENGTH nm_end_mp
     ,to_date(null) nm_date_modified
     ,'I' nm_type
   from V_NM_SECT
  ) m
  ,nm_inv_items_all i
where q1.nm_ne_id_of = m.nm_ne_id_of
  and m.nm_ne_id_in = i.iit_ne_id (+)
  and q1.begin_mp between m.nm_begin_mp and m.nm_end_mp
  and q1.end_mp between m.nm_begin_mp and m.nm_end_mp
  and i.iit_end_date is null
order by q1.nm_ne_id_of, q1.begin_mp, q1.end_mp, m.nm_type, m.nm_obj_type
*/

  
  
  
  
/* exec_homo_results_query

select
   q6.nm_ne_id_of
  ,decode(q6.begin_mp, null, nvl(q6.lag_begin_1, q6.lag_begin_2), q6.begin_mp) nm_begin_mp
  ,decode(q6.end_mp, null, nvl(q6.lead_end_1, q6.lead_end_2), q6.end_mp) nm_end_mp
  ,min(q6.hash_value) hash_value
  ,count(*) chunk_count
  ,min(q6.obj_type_count) obj_type_count
  ,min(q6.row_count) obj_count
  ,max(q6.nm_date_modified) nm_date_modified
  ,max(q6.iit_date_modified) iit_date_modified
from (
select
   lag(q5.begin_mp, 1) over (partition by nm_ne_id_of order by q5.rnum ) lag_begin_1
  ,lag(q5.begin_mp, 2) over (partition by nm_ne_id_of order by q5.rnum ) lag_begin_2
  ,lead(q5.end_mp, 1) over (partition by nm_ne_id_of order by q5.rnum ) lead_end_1
  ,lead(q5.end_mp, 2) over (partition by nm_ne_id_of order by q5.rnum ) lead_end_2
  ,q5.*
from (
select q4.nm_ne_id_of, q4.begin_mp, q4.end_mp, q4.hash_value, q4.row_count
  ,min(q4.rnum) rnum
  ,min(q4.obj_type_count) obj_type_count
  ,max(q4.nm_date_modified) nm_date_modified
  ,max(q4.iit_date_modified) iit_date_modified
from (
select
   rownum rnum
  ,to_number(decode(q3.nm_begin_mp
     ,lag(q3.nm_end_mp, 1) over (partition by q3.nm_ne_id_of, q3.hash_value order by q3.nm_begin_mp)
     ,null
     ,q3.nm_begin_mp
   )) begin_mp
  ,to_number(decode(q3.nm_end_mp
     ,lead(q3.nm_begin_mp, 1) over (partition by q3.nm_ne_id_of, q3.hash_value order by q3.nm_begin_mp)
     ,null
     ,q3.nm_end_mp
   )) end_mp
  ,q3.*
from (
select
   q2.nm_ne_id_of
  ,q2.nm_begin_mp
  ,q2.nm_end_mp
  ,group_hash_value(q2.hash_value) hash_value
  ,max(q2.nm_date_modified) nm_date_modified
  ,max(q2.iit_date_modified) iit_date_modified
  ,count(*) row_count
  ,count(distinct q2.nm_obj_type) obj_type_count
from (
select
  to_char(dbms_utility.get_hash_value(
           q.RCON_MATERIAL
    ||','||case
           when q.RCON_LAYER between 1 and 2 then '1'
           when q.RCON_LAYER between 3 and 5 then '2'
           when q.RCON_LAYER between 6 and 1000 then '3'
           else null end
    ||','||q.AD_IIT_ID_CODE
    ||','||q.L_NE_LENGTH
    ,0, 262144))
  ||'_'||dbms_utility.get_hash_value(
           q.RCON_MATERIAL
    ||','||case
           when q.RCON_LAYER between 1 and 2 then '1'
           when q.RCON_LAYER between 3 and 5 then '2'
           when q.RCON_LAYER between 6 and 1000 then '3'
           else null end
    ||','||q.AD_IIT_ID_CODE
    ||','||q.L_NE_LENGTH||',xxx'
    ,0, 262144) hash_value
  ,q.*
from (
select /+ cardinality(t 5) /
   t.*
  ,case when t.nm_type = 'I' and t.nm_obj_type = 'RCON' then i.IIT_MATERIAL end RCON_MATERIAL
  ,case when t.nm_type = 'I' and t.nm_obj_type = 'RCON' then i.IIT_NO_OF_UNITS end RCON_LAYER
  ,case when t.nm_type = 'I' and t.nm_obj_type = 'AD' then i.IIT_ID_CODE end AD_IIT_ID_CODE
  ,case when t.nm_type = 'I' and t.nm_obj_type = 'L' then i2.NE_LENGTH end L_NE_LENGTH
from
   nm_mrg_split_results_tmp t
  ,nm_inv_items_all i
    ,(select 'L' ft_inv_type, ft2.* from V_NM_L ft2) i2
where t.nm_obj_type = i.iit_inv_type (+)
  and t.iit_rowid = i.rowid (+)
    and t.nm_obj_type = i2.ft_inv_type (+)
    and t.nm_ne_id_in = i2.NE_FT_PK_COL (+)
) q
) q2
group by q2.nm_ne_id_of, q2.nm_begin_mp, q2.nm_end_mp
) q3
) q4
group by q4.nm_ne_id_of, q4.begin_mp, q4.end_mp, q4.hash_value, q4.row_count
) q5
) q6
group by
   q6.nm_ne_id_of
  ,decode(q6.begin_mp, null, nvl(q6.lag_begin_1, q6.lag_begin_2), q6.begin_mp)
  ,decode(q6.end_mp, null, nvl(q6.lead_end_1, q6.lead_end_2), q6.end_mp)
order by
   q6.nm_ne_id_of
  ,decode(q6.begin_mp, null, nvl(q6.lag_begin_1, q6.lag_begin_2), q6.begin_mp)
  ,decode(q6.end_mp, null, nvl(q6.lead_end_1, q6.lead_end_2), q6.end_mp)     
*/
  
  
/*
    -- This is used in one-route-only insert
    --  ,case t.nm_obj_type
    --   when 'SAMP' then i.IIT_CHR_ATTRIB26 end NSV_ATTRIB3
    --  ,case t.nm_obj_type
    --   when 'XNAA' then (select NAA_DESCR from XNMDOT_NAA where FT_PK_COL = t.nm_ne_id_in) end NSV_ATTRIB4
    function sql_inline_case_cols return varchar2
    is
      s       varchar2(4000);
      l_inv_alias varchar(3);
      l_attrib    varchar2(30);
      k       binary_integer := 1;
      j       binary_integer := 0;
    begin
      i := pt_attr.first;
      while i is not null loop
        j := j + 1;
        s := s||cr||'  ,case t.nm_obj_type'
          ||cr||'    when '''||pt_attr(i).INV_TYPE||''' then ';
          
        if pt_attr(i).table_name is null then
          s := s||' i.'||pt_attr(i).IIT_ATTRIB_NAME;
        else
          s := s||' (select '||pt_attr(i).ITA_ATTRIB_NAME
            ||' from '||pt_attr(i).table_name
            ||' where '||pt_attr(i).TABLE_PK_COLUMN||' = t.nm_ne_id_in)';
        end if;
        s := s||' end NSV_ATTRIB'||j;

        i := pt_attr.next(i);
      end loop;
      return s;
      
    end;
*/
  
  
--
-----------------------------------------------------------------------------
--
END;
/
