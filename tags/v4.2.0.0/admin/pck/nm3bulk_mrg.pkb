CREATE OR REPLACE PACKAGE BODY nm3bulk_mrg AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3bulk_mrg.pkb-arc   2.33   Dec 02 2009 15:01:20   cstrettle  $
--       Module Name      : $Workfile:   nm3bulk_mrg_fix.pkb  $
--       Date into PVCS   : $Date:   Dec 02 2009 15:01:20  $
--       Date fetched Out : $Modtime:   Dec 02 2009 14:52:46  $
--       PVCS Version     : $Revision:   2.33  $
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
  03.10.07  PT in ins_splits() fixed the FT nm_obj_type problem
  04.10.07  PT rewrote the datum criteria to use nm_datum_criteria_tmp, rewrote criteria loading,
                introduced nm_route_connectivity_tmp to separate out the route connectivity results
  05.10.07  PT fixed a bad reference to nm3dynsql2 package. must be nm3dynsql
                renamed nm_datum_connectivity_tmp to nm_route_connectivity_tmp
  10.10.07  PT added append hints to temp table inserts (where applicable)
                sql%rowcount before commit
  17.10.07  PT removed autonomous transactions
                added grups of groups support to load_group_datums() and load_gaz_list_datums()
                added both ways FT support to ins_datum_homo_chunks() and std_insert_invitems()
                added FT key preserved check (more work needed) to ins_splits()
  19.10.07  PT added merge security, au seccurity, 'MRGPOE' option
  29.10.07  PT ins_route_connectivity() made independent from std_run()
  17.12.07  PT added rowid_with_group_by exception to test_key_preserved(), fixed a typo in exception init
  04.01.08  PT fixed the missing 'last one after loop' error in ins_datum_homo_chunks() and std_insert_invitems()
  09.01.08  PT fixed xsp handling in ins_datum_homo_chunks()
  19.05.08  PT in std_populate() removed the 'No merge results' error
  23.06.08  PT fixed an error in cacluclating group_id in sql_load_datum_criteria_tmp()
                load_group_datums() now uses explicit hard coded sql for linear groups
  03.10.08  PT modified sql_load_nm_datum_criteria_tmp() so that partial datums are not cut off by the assigned route
                this in responce to a problem Sarah Kristulinec brought up in New Brunswick
  30.01.09  PT log 718691 changed ins_datum_homo_chunks() to remove nm_type = 'I'
                this allows FT asset members to be those of a group
  30.01.09  PT log 718691 fixed problem (null mp values) in loading nt_type and all network introduced with the change 03.10.08
                removed append hint from insert into nm_route_connectivity_tmp - causes internal error on BC large group 2172417
  25.02.09  PT make use of nvl() instead of explicit null comparisons in std_insert_invitems() for performance
  26.02.09  PT corrected nvl() datatype mismatch introduced in the above change
  03.03.09  PT fixed: ita_format not observed in std_insert_invitems() with potential date corruption
                moved the nsv_attribxx formatting from the with source into i2 subquery
  24.03.09  PT in std_run() added order by subclass and slk to get the result sections in connectivity order
                this now matches the order produced by the old merge query
  01.04.09  PT in load_attrib_metadata() applied qta.nqa_attrib_name default to iit_attrib_name
                this should fix the problem when colums like IIT_END_DATE are specified in NM_MRG_QUERY_ATTRIBS but not in NM_INV_TYPE_ATTRIBS
                the m_mrg_date_format (value copied from nm3mrg.g_mrg_date_format) is used for undeclared date columns
  05.05.09  PT in std_populate() fixed a bug in merging connecting chunks:
                added lag_datum_gap = 0 check, plus extra check to not merge point chunks
  06.05.09  PT in std_insert_invitems() corrected date conversion
                in second insert replaced min() group by with row_number() = 1 logic
               in ins_datum_homo_chunks() corrected ambiguous column error - happens when FT primary key is splitting attribute
                added $ suffix to the FT pk column
               in get_where_sql() fixed date formating for where condition values
No query types defined.
  07.05.09  PT in ins_route_connectivity() added nm_cardinality - requires NM_ROUTE_CONNECTIVITY_TMP with NM_CARDINALITY column
                nm_cardinality is now used by std_populate() to order pieces within datum according to route cardinality
  11.05.09  PT in std_populate() modified query to translate the first and last mp references according to route cardinality
                made end_mp equal to begin_mp for point sections to avoid gap caused by unit conversion rounding
               added $ suffix to the FT pk column also in std_insert_invitems()
               fixed the std_populate() query: wrong value in lag_nm_ne_id_in introduced with changes to section order
               fixed a problem in ins_datum_homo_chunks(): chunks incorrectly merged when point placements are involved
  13.05.09  PT added xsp as default splitting agent in ins_datum_homo_chunks()
  15.05.09  PT in std_populate() fixed the first missing section problem caused by bad ordering in analytic functions
  03.06.09  PT fixed a problem in load_attrb_metadata() where attribute order was not identical with the one in result views
                this was caused by columns e.g. IIT_END_DATE not being specified in nm_inv_type_attribs
  24.07.09  PT log 721736 changed load_group_datums() for single datums so that route is no longer assigned
                datum references, instead of route references, are now put into NMS_BEGIN_OFFSET and NMS_END_OFFSET
  29.10.09  PT logs 723109 and 722950: increased the varchar2 buffer size inside
                ins_datum_homo_chunks() and std_insert_invitems() sql string functions
  
  Todo: std_run without longops parameter
        load_group_datums() with begin and end parameters
        add ita_format_mask to ita_mapping_rec
        add nm_route_connect_tmp_ordered view with the next schema change
        in nm3dynsql replace the use of nm3sql.set_context_value() with that of nm3ctx
*/
  g_body_sccsid     constant  varchar2(30)  :='"$Revision:   2.33  $"';
  g_package_name    constant  varchar2(30)  := 'nm3bulk_mrg';
  
  cr  constant varchar2(1) := chr(10);
  qt  constant varchar2(1) := chr(39);  -- single quote
  m_mrg_date_format constant varchar2(15) := 'DD-MON-YYYY'; -- this is same as nm3mrg.g_mrg_date_format
  
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
    
    
  mt_datum_id nm_id_tbl;
  mt_group_id nm_id_tbl;
  mt_gg_id    nm_id_tbl;
  mt_nse_id   nm_id_tbl;
    
    
  connect_by_loop exception; -- CONNECT BY loop in user data
  pragma exception_init(connect_by_loop, -1436);
  
  key_not_preserved exception; -- ORA-01445: cannot select ROWID from a join view without a key-preserved table
  pragma exception_init(key_not_preserved, -1445);
  
  invalid_rowid exception; -- ORA-01410: invalid ROWID (e.g. materialized view)
  pragma exception_init(invalid_rowid, -1410);
  
  rowid_with_group_by exception; -- ORA-01446 cannot select ROWID from view with DISTINCT, GROUP BY, etc.
  pragma exception_init(rowid_with_group_by, -1446);
  
  
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
  
  
  function sql_load_nm_datum_criteria_tmp(
     p_elements_sql in varchar2
  ) return varchar2;
  
  procedure ensure_group_type_linear(
     p_group_type_in in nm_group_types.ngt_group_type%type
    ,p_group_type_out out nm_group_types.ngt_group_type%type
  );
  
  function is_key_preserved(
     p_table_name in varchar2
  ) return boolean;
  
  
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
  
  
  -- this id table functions are used by load_gaz_list_datums()
  function get_datum_id_tbl return nm_id_tbl
  is
  begin
    return mt_datum_id;
  end;
  function get_group_id_tbl return nm_id_tbl
  is
  begin
    return mt_group_id;
  end;
  -- groups of groups
  function get_gg_id_tbl return nm_id_tbl
  is
  begin
    return mt_gg_id;
  end;
  function get_nse_id_tbl return nm_id_tbl
  is
  begin
    return mt_nse_id;
  end;
  
  
 
  -- this executes the main bulk source query
  --  the results are put into nm_mrg_split_results_tmp, previous results truncated
  --  autonomous transaction
  procedure ins_splits(
     pt_attr in ita_mapping_tbl
    ,p_effective_date in date
    ,p_criteria_rowcount in integer
    ,p_rowcount_out out integer
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
    l_key_preserved             boolean;
    
    
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
      return cr||p_connector||l_alias||lower(p_column)||' = x.datum_id';
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
 
    
  begin
    nm3dbg.putln(g_package_name||'.ins_splits('
      ||'pt_attr.count='||pt_attr.count
      ||', p_effective_date='||p_effective_date
      ||', p_criteria_rowcount='||p_criteria_rowcount
      ||')');
    nm3dbg.ind;
    -- nm_mrg_split_results_tmp is global temporary on commit preserve rows
    -- (implicit commit)
    execute immediate
      'truncate table nm_mrg_split_results_tmp';
  
      
    -- effective date is used directly as bind variable in the sql
    if l_effective_date is null then
      l_effective_date := trunc(sysdate);
    end if;
    
     
      
    -- calculate the cardinality hint value
    l_cardinality := nm3sql.get_rounded_cardinality(p_criteria_rowcount);
    
    l_sql_cardinality := ' /*+ cardinality(x '||l_cardinality||') */';
    
    l_sql_route_datums_tbl := cr||'  ,nm_datum_criteria_tmp x';
    
    
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
                  -- CWS 23/OCT/2009 
                    l_sql_tmp := l_sql_tmp
                    ||' and '||pt_attr(j).where_sql;
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
       p_date               => l_effective_date
      ,p_start_date_column  => 'nm_start_date'
      ,p_end_date_column    => 'nm_end_date'
    );
    l_sql_iit_effective_date := nm3dynsql.sql_effective_date(
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
        ||cr||'  ,nm_datum_criteria_tmp x'
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
    
      l_key_preserved := is_key_preserved(t_ft(i).table_name);
    
      -- it is a virtual nm_inv_items_all table
      if t_ft(i).table_iit_flag = 'Y' then
      
        
        -- check that the table does not include nm_members
        if not l_key_preserved then
          raise_application_error(-20001,
            'External assets placed on the network must have a true primary key: '||t_ft(i).inv_type);
        end if;
            
        a1 := 'm'||i;
        a2 := 'i'||i;
        l_sql_ft := l_sql_ft
              ||l_union_all
          ||cr||'select'||l_sql_cardinality
          ||cr||'    '''||t_ft(i).inv_type||''' nm_obj_type, '||a1||'.nm_ne_id_in, '||a1||'.nm_ne_id_of, '||a1||'.nm_begin_mp, '||a1||'.nm_end_mp'
          ||cr||'  , '||a1||'.nm_date_modified, '||a1||'.nm_type, null iit_rowid, cast(null as date) iit_date_modified'
          ||cr||'from'
          ||cr||'   nm_members_all '||a1
          ||cr||'  ,'||t_ft(i).table_name||' '||a2
          ||cr||'  ,nm_datum_criteria_tmp x'
          ||cr||'where '||a1||'.nm_ne_id_in = '||a2||'.'||t_ft(i).table_pk_column
              ||sql_datum_tbl_join('nm_ne_id_of', '  and ', a1)
          ||cr||'  and '||l_sql_nm_effective_date
              ||sql_ft_criteria(l_where_and, t_ft(i).where_sql, a2);
      
      
      -- it is a true foreign table
      else
      
        -- check that the FT view includes a join to nm_members
        -- TODO: the current key preserved check returns false positives, not used
--         if l_key_preserved then
--           raise_application_error(-20001,
--             'External assets not placed on the network must use a join to nm_members for positioning: '||t_ft(i).inv_type);
--         end if;
        
      
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
          ||cr||'  ,nm_datum_criteria_tmp x'
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
    p_rowcount_out := sql%rowcount;
    commit;
    
    nm3dbg.putln('nm_mrg_split_results_tmp count: '||p_rowcount_out);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.ins_splits('
        ||'pt_attr.count='||pt_attr.count
        ||', p_effective_date='||p_effective_date
        ||', p_criteria_rowcount='||p_criteria_rowcount
        ||')');
      raise;
    
  end;
  
  
  
  
  -- This populates the nm_mrg_datum_homo_chunks_tmp table
  --  Homogenous datum chunk is a datum piece with same derived values
  procedure ins_datum_homo_chunks(
     pt_attr  in ita_mapping_tbl
    ,pt_itd   in itd_tbl
    ,p_inner_join in boolean
    ,p_splits_rowcount in integer
    ,p_rowcount_out out integer
  )
  is
    i                 binary_integer;
    l_sql             varchar2(32767);
    l_cardinality     integer;
    l_sql_inner_join  varchar2(100);
    l_inv_type_count  number(4) := 0;
    
    
    -- this appends xsp to the attribute name observing the 30 char length limit
    function attribute_xsp_name(p_attr_name in varchar2, p_xsp in varchar2) return varchar2
    is
    begin
      return substr(p_attr_name, 1
        , 30 - case when p_xsp is null then 0 else length(p_xsp) + 1 end)
        ||case when p_xsp is null then null else '_'||p_xsp end;
    end;
        
    
    --       q.RCON_MATERIAL
    --||','||case
    --       when q.RCON_LAYER between 1 and 2 then '1'
    --       when q.RCON_LAYER between 3 and 5 then '2'
    --       when q.RCON_LAYER between 6 and 1000 then '3'
    --       else null end
    --||','||q.AD_IIT_ID_CODE
    function sql_hashcode_cols(
       p_alias in varchar2
    ) return varchar2
    is
      s varchar2(32767);
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
                ||cr||'           when '||p_alias||'.'||attribute_xsp_name(pt_attr(i).mrg_attrib, pt_attr(i).xsp)||' between '
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
          s := s||l_cr||p_alias||'.'||attribute_xsp_name(pt_attr(i).mrg_attrib, pt_attr(i).xsp);
        end if;
        
        l_cr := cr||'    ||'',''||';
        
        i := pt_attr.next(i);
      end loop;
      return s;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_hashcode_cols('
        ||'p_alias='||p_alias
        ||', l_band_value='||l_band_value
        ||', l_case='||l_case
        ||', i='||i
        ||', length(s)='||length(s)
        ||', s='||s
        ||')');
      raise;
    end;
    
    
    --  ,case when t.nm_type = 'I' and t.nm_obj_type = 'FA' then i.IIT_NUM_ATTRIB100 end FA_NHS
    function sql_case_cols return varchar2
    is
      s       varchar2(32767);
      l_inv_alias varchar(3);
      l_attrib    varchar2(30);
      k       binary_integer := 1;
    begin
      i := pt_attr.first;
      while i is not null loop
        -- ft assets have no xsp
        if pt_attr(i).table_name is null then
          l_inv_alias := 'i';
          l_attrib := pt_attr(i).iit_attrib_name;
          
        -- standard assets (may have xsp)
        else
          if pt_attr(i).seq = 1 then
            k := k + 1;
          end if;
          l_inv_alias := 'i'||k;
          l_attrib := pt_attr(i).ita_attrib_name;
        end if;
        -- PT 30.01.09
        -- s := s||cr||'  ,case when t.nm_type = ''I'' and t.nm_obj_type = '''||pt_attr(i).inv_type||'''';
        s := s||cr||'  ,case when t.nm_obj_type = '''||pt_attr(i).inv_type||'''';
        if pt_attr(i).xsp is not null then
          s := s||' and i.iit_x_sect = '''||pt_attr(i).xsp||'''';
        end if;
        s := s||' then '||l_inv_alias||'.'||l_attrib||' end '||attribute_xsp_name(pt_attr(i).mrg_attrib, pt_attr(i).xsp);
        
        i := pt_attr.next(i);
      end loop;
      return s;
    exception
      when others then
        nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_case_cols('
          ||'l_inv_alias='||l_inv_alias
          ||', l_attrib='||l_attrib
          ||', k='||k
          ||', i='||i
          ||', length(s)='||length(s)
          ||', s='||s
          ||')');
        raise;
    end;
    
    --  ,(select 'XNAA' ft_inv_type, ft2.FT_PK_COL, ft2.NAA_DESCR from XNMDOT_NAA ft2) i2
    --  ,(select  distinct 'SEGM' ft_inv_type, ft8.NE_FT_PK_COL, ft8.GROUP_TYPE, ft8.ROUTE from XNMDOT_V_SEGM ft8) i8
    function sql_ft_sources return varchar2
    is
      s       varchar2(32767);
      k       binary_integer := 1;
      s_tmp   varchar2(4000);
      s_tmp_tbl varchar2(30);
      
    begin
      i := pt_attr.first;
      while i is not null loop
      
        -- finish the previous if present
        if pt_attr(i).seq = 1 and s_tmp is not null then
          s := s||cr||s_tmp||' from '||s_tmp_tbl||' ft'||k||') i'||k;
          s_tmp := null;
          s_tmp_tbl := null;
        end if; 
      
        -- it is an FT 
        if pt_attr(i).table_name is not null then
          
          -- start new
          if pt_attr(i).seq = 1 then
            k := k + 1;
            s_tmp := '    ,(select distinct '''||pt_attr(i).inv_type||''' ft_inv_type, '
              --||'ft'||k||'.'||pt_attr(i).table_pk_column||', ft'||k||'.'||pt_attr(i).ita_attrib_name;
              ||'ft'||k||'.'||pt_attr(i).table_pk_column||' '||pt_attr(i).table_pk_column||'$, ft'||k||'.'||pt_attr(i).ita_attrib_name;
            s_tmp_tbl := pt_attr(i).table_name;
              
          -- add column to existing
          else
            s_tmp := s_tmp||', ft'||k||'.'||pt_attr(i).ita_attrib_name;
          
          end if;
        end if;
        
        i := pt_attr.next(i);
      end loop;
      
      -- last one after loop
      if s_tmp is not null then
        s := s||cr||s_tmp||' from '||s_tmp_tbl||' ft'||k||') i'||k;
      end if; 

      return s;
    exception
      when others then
        nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_ft_sources('
          ||'s_tmp_tbl='||s_tmp_tbl
          ||', s_tmp='||s_tmp
          ||', k='||k
          ||', i='||i
          ||', length(s)='||length(s)
          ||', s='||s
          ||')');
        raise;
    end;
    
    --  and t.nm_obj_type = i2.ft_inv_type (+)
    --  and t.nm_ne_id_in = i2.ne_id (+)
    function sql_ft_outer_joins return varchar2
    is
      s       varchar2(32767);
      k       binary_integer := 1;
      l_cr    varchar2(10) := '  ,';
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).seq = 1 and pt_attr(i).table_name is not null then
          k := k + 1;
          s := s||cr||'    and t.nm_obj_type = i'||k||'.ft_inv_type (+)'
                ||cr||'    and t.nm_ne_id_in = i'||k||'.'||pt_attr(i).table_pk_column||'$ (+)';
        end if;
        i := pt_attr.next(i);
      end loop;
      return s;
    exception
      when others then
        nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_ft_outer_joins('
          ||'l_cr='||l_cr
          ||', k='||k
          ||', i='||i
          ||', length(s)='||length(s)
          ||', s='||s
          ||')');
        raise;
    end;
    
  -- main procedure body starts here
  begin
    nm3dbg.putln(g_package_name||'.ins_datum_homo_chunks('
      ||'pt_attr.count='||pt_attr.count
      ||', pt_itd.count='||pt_itd.count
      ||', p_inner_join='||nm3flx.boolean_to_char(p_inner_join)
      ||', p_splits_rowcount='||p_splits_rowcount
      ||')');
    nm3dbg.ind;
    
    -- truncate (implicit commit)
    -- nm_mrg_datum_homo_chunks_tmp is global temporary on commit preserve rows
    execute immediate 
      'truncate table nm_mrg_datum_homo_chunks_tmp';
    
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
    ||cr||'  ,case q3.nm_begin_mp||''-''||q3.hash_value'
    ||cr||'   when lag(q3.nm_end_mp||''-''||q3.hash_value, 1)'
    ||cr||'    over (partition by q3.nm_ne_id_of order by q3.nm_begin_mp) then null'
    ||cr||'   else q3.nm_begin_mp'
    ||cr||'   end begin_mp'
    ||cr||'  ,case q3.nm_end_mp||''-''||q3.hash_value'
    ||cr||'   when lead(q3.nm_begin_mp||''-''||q3.hash_value, 1)'
    ||cr||'    over (partition by q3.nm_ne_id_of order by q3.nm_begin_mp) then null'
    ||cr||'   else q3.nm_end_mp'
    ||cr||'   end end_mp'
--    ||cr||'  ,to_number(decode(q3.nm_begin_mp'
--    ||cr||'     ,lag(q3.nm_end_mp, 1) over (partition by q3.nm_ne_id_of, q3.hash_value order by q3.nm_begin_mp)'
--    ||cr||'     ,null'
--    ||cr||'     ,q3.nm_begin_mp'
--    ||cr||'   )) begin_mp'
--    ||cr||'  ,to_number(decode(q3.nm_end_mp'
--    ||cr||'     ,lead(q3.nm_begin_mp, 1) over (partition by q3.nm_ne_id_of, q3.hash_value order by q3.nm_begin_mp)'
--    ||cr||'     ,null'
--    ||cr||'     ,q3.nm_end_mp'
--    ||cr||'   )) end_mp'
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
    ||cr||'  to_char(dbms_utility.get_hash_value(q.xsp$||'',''||'
        ||sql_hashcode_cols('q')
    ||cr||'    ,0, 262144))'
    ||cr||'  ||''_''||dbms_utility.get_hash_value(q.xsp$||'',''||'
        ||sql_hashcode_cols('q')||'||'',xxx'''
    ||cr||'    ,0, 262144) hash_value'
    ||cr||'  ,q.*'
    ||cr||'from ('
    ||cr||'select /*+ cardinality(t '||l_cardinality||') */'
    ||cr||'   t.*'
    ||cr||'  ,i.iit_x_sect xsp$'
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
   
    nm3dbg.putln(l_sql);
    
    
    -- insert
    execute immediate 
      'insert /*+ append */ into nm_mrg_datum_homo_chunks_tmp'
      ||cr||l_sql;
    p_rowcount_out := sql%rowcount;
    commit;
      
      
    nm3dbg.putln('nm_mrg_datum_homo_chunks_tmp count: '||p_rowcount_out);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.ins_datum_homo_chunks('
        ||'pt_attr.count='||pt_attr.count
        ||', pt_itd.count='||pt_itd.count
        ||', p_inner_join='||nm3flx.boolean_to_char(p_inner_join)
        ||', p_splits_rowcount='||p_splits_rowcount
        ||', l_inv_type_count='||l_inv_type_count
        ||', l_sql_inner_join='||l_sql_inner_join
        ||', l_cardinality='||l_cardinality
        ||', i='||i
        ||')');
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
    q1      varchar2(40);
    q2      varchar2(40);
    l_comma varchar2(2);
    t       nm_code_tbl;
    
    
  begin
    if p_ita_format = 'VARCHAR2' then
      q1 := chr(39); -- single quote
      q2 := chr(39);
      
    elsif p_ita_format = 'NUMBER' then
      q1 := 'to_number('; 
      q2 := ')';
      
    elsif p_ita_format = 'DATE' then
      q1 := 'to_date('''; 
      q2 := ''', '''||m_mrg_date_format||''')';
      
    end if;
     -- CWS 23/OCT/2009 
     if nm3gaz_qry.get_ignore_case and p_ita_format = 'VARCHAR2' then  
        case
        when p_operator is null then
          return null;
          
        when p_operator in ('IN','NOT IN') then
          select q1||nqv_value||q2 value
          bulk collect into t
          from nm_mrg_query_values
          where nqv_nmq_id = p_nmq_id
            and nqv_nqt_seq_no = p_nqt_seq_no
            and nqv_attrib_name = p_attrib_name
          order by nqv_sequence;
          for i in 1 .. t.count loop
            l_sql := l_sql||l_comma|| ' UPPER(' ||t(i) || ') ';
            l_comma := ', ';
          end loop;
          l_sql := ' UPPER(i.'|| p_attrib_name||') '||lower(p_operator)||' ('||l_sql||')';
        
        when p_operator in ('BETWEEN', 'NOT BETWEEN') then
          l_sql := ' UPPER(i.'||p_attrib_name||') '||lower(p_operator)||' UPPER( '||q1||p_value1||q2||') and UPPER('||q1||p_value2||q2||') ';
        
        when p_operator in ('IS NULL', 'IS NOT NULL') then
          l_sql := ' i.'||p_attrib_name||' '||lower(p_operator);
        
        else
          l_sql := ' UPPER(i.'||p_attrib_name||') '||lower(p_operator)||' UPPER( '||q1||p_value1||q2||') ';
        end case;     
     
     else
        case
        when p_operator is null then
          return null;
          
        when p_operator in ('IN','NOT IN') then
          select q1||nqv_value||q2 value
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
          l_sql := ' i.'||p_attrib_name||' '||lower(p_operator)||' ('||l_sql||')';
        
        when p_operator in ('BETWEEN', 'NOT BETWEEN') then
          l_sql := ' i.'||p_attrib_name||' '||lower(p_operator)||' '||q1||p_value1||q2||' and '||q1||p_value2||q2;
        
        when p_operator in ('IS NULL', 'IS NOT NULL') then
          l_sql := ' i.'||p_attrib_name||' '||lower(p_operator);
        
        else
          l_sql := ' i.'||p_attrib_name||' '||lower(p_operator)||' '||q1||p_value1||q2;
        
        end case;
    end if;
    
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
    l_hig_owner constant varchar2(30) := hig.get_application_owner;
    
  begin
    nm3dbg.putln(g_package_name||'.load_attrib_metadata('
      ||'p_nmq_id='||p_nmq_id
      ||')');
    nm3dbg.ind;
  
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
      select q.*
      from (
      select
         qta.nqt_inv_type
        ,qta.nqt_inv_type||'_'||nvl(ta.ita_view_attri, qta.nqa_attrib_name) mrg_attrib_name
        ,nvl2(t.nit_table_name, nvl(ta.ita_attrib_name, qta.nqa_attrib_name), ta.ita_view_attri) ita_attrib_name
        ,nvl(nvl(fta.iit_attrib_name, ta.ita_attrib_name), qta.nqa_attrib_name) iit_attrib_name
        ,nvl(decode(ta.ita_format, null
          ,(select data_type from all_tab_cols
            where owner = l_hig_owner
              and table_name = 'NM_INV_ITEMS_ALL'
              and column_name = qta.nqa_attrib_name)
          , ta.ita_format
         ), 'VARCHAR2') ita_format
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
        ,row_number() over (partition by qta.nqt_inv_type order by nvl(ta.ita_attrib_name, qta.nqa_attrib_name)) attrib_seq
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
      ) q
      order by q.nqt_seq_no, q.attrib_seq
    )
    loop
      i := i + 1;
      pt_attr(i).inv_type           := r.nqt_inv_type;
      pt_attr(i).seq                := r.attrib_seq;
      pt_attr(i).mrg_attrib         := r.mrg_attrib_name;
      pt_attr(i).ita_attrib_name    := r.ita_attrib_name;
      pt_attr(i).iit_attrib_name    := r.iit_attrib_name;
      pt_attr(i).ita_format         := r.ita_format;
      pt_attr(i).table_name         := r.nit_table_name;
      pt_attr(i).table_iit_flag     := r.table_iit_flag;
      pt_attr(i).table_pk_column    := r.nit_foreign_pk_column;
      pt_attr(i).table_ne_column    := r.nit_lr_ne_column_name;
      pt_attr(i).table_begin_column := r.nit_lr_st_chain;
      pt_attr(i).table_end_column   := r.nit_lr_end_chain;
      pt_attr(i).pnt_or_cont        := r.nit_pnt_or_cont;
      pt_attr(i).xsp                := r.nqt_x_sect;
      
      
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
    
    nm3dbg.putln('pt_attr.count='||pt_attr.count||', pt_itd.count='||pt_itd.count);
    nm3dbg.deind;
--  exception
--    when others then
--      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_attrib_metadata('
--        ||'p_nmq_id='||p_nmq_id
--        ||')');
--      raise;
      
  end;
  
  
  -- this populates the route connectivity temp table nm_route_connectivity_tmp
  --  this can be run independetly, it only needs the criterea table to be populated
  procedure ins_route_connectivity(
     p_criteria_rowcount in integer
    ,p_ignore_poe in boolean
  )
  is
    l_sql         varchar2(10000);
    l_sql_outer   varchar2(1000);
    l_sql_conn    varchar2(10000);
    l_sqlcount    pls_integer;
    l_ignore_poe  boolean := p_ignore_poe;
    
  begin
    nm3dbg.putln(g_package_name||'.ins_route_connectivity('
      ||'p_criteria_rowcount='||p_criteria_rowcount
      ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
      ||')');
    nm3dbg.ind;
    
 
    
    -- assign POE flag if null
    if l_ignore_poe is null then
      l_ignore_poe := (nvl(hig.get_sysopt('MRGPOE'),'N') = 'N');
      nm3dbg.putln('l_ignore_poe='||nm3dbg.to_char(l_ignore_poe));
    end if;
    
    
    l_sql_conn := nm3dynsql.sql_route_connectivity(
                     p_criteria_rowcount => p_criteria_rowcount
                    ,p_ignore_poe => l_ignore_poe
                  );
             
    l_sql_outer := 'insert into nm_route_connectivity_tmp ('
       ||cr||'  nm_ne_id_in, chunk_no, chunk_seq, nm_ne_id_of, nm_begin_mp, nm_end_mp'
       ||cr||', measure, end_measure, nm_slk, nm_end_slk, nm_cardinality, nt_unit_in, nt_unit_of'
       ||cr||')'
       ||cr||'select'
       ||cr||'  nm_ne_id_in, chunk_no, chunk_seq, nm_ne_id_of, nm_begin_mp, nm_end_mp'
       ||cr||', measure, end_measure, nm_slk, nm_end_slk, nm_cardinality, nt_unit_in, nt_unit_of'
       ||cr||'from (';
       
    l_sql := l_sql_outer
       ||cr||l_sql_conn
       ||cr||')';
       
    execute immediate 'truncate table nm_route_connectivity_tmp';
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql;
    l_sqlcount := sql%rowcount;
    commit;
    
    
    nm3dbg.putln('nm_route_connectivity_tmp routes count: '||l_sqlcount);
    
    
    -- take care of single datums
    --  TODO: change needed for 03.10.08 sql_load_nm_datum_criteria_tmp() modification
    --  need to only insert partial datum if other part is covered by a route
    l_sql_conn :=
            'select'
      ||cr||'   d.datum_id nm_ne_id_in'   -- the datum is the route
      ||cr||'  ,1 chunk_no'
      ||cr||'  ,1 chunk_seq'
      ||cr||'  ,d.datum_id nm_ne_id_of'
      ||cr||'  ,d.begin_mp nm_begin_mp'
      ||cr||'  ,d.end_mp nm_end_mp'
      ||cr||'  ,d.begin_mp measure'
      ||cr||'  ,d.end_mp end_measure'
      ||cr||'  ,cast(null as number) nm_slk'
      ||cr||'  ,cast(null as number) nm_end_slk'
      ||cr||'  ,1 nm_cardinality'
      ||cr||'  ,-1 nt_unit_in'
      ||cr||'  ,-1 nt_unit_of'
      ||cr||'from'
      ||cr||'   nm_datum_criteria_tmp d'
      ||cr||'where d.group_id is null'
      ||cr||'order by d.datum_id';
                  
    l_sql := l_sql_outer
       ||cr||l_sql_conn
       ||cr||')';
       
    nm3dbg.putln(l_sql);
    execute immediate l_sql;
    l_sqlcount := sql%rowcount;
    commit;
    
    nm3dbg.putln('nm_route_connectivity_tmp datums count: '||l_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.ins_route_connectivity('
        ||'p_criteria_rowcount='||p_criteria_rowcount
        ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
        ||', l_ignore_poe='||nm3flx.boolean_to_char(l_ignore_poe)
        ||')');
      raise;
    
  end;
    
    
  
  
  -- this populates the standard results table
  -- TODO: more comments
  procedure std_populate(
     p_nmq_id in nm_mrg_query_all.nmq_id%type
    ,pt_attr in ita_mapping_tbl
    ,p_admin_unit_id in nm_admin_units_all.nau_admin_unit%type
    ,p_splits_rowcount in integer
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
    l_nqr_memb_count    integer := 0;
    l_section_id        nm_mrg_sections_all.nms_mrg_section_id%type := 0;
    l_nsm_measure       mp_type := 0;
    j           pls_integer := 0;
    lc_sect     pls_integer := 0;
    lc_memb     pls_integer := 0;
  begin
    nm3dbg.putln(g_package_name||'.std_populate('
      ||'p_nmq_id='||p_nmq_id
      ||', pt_attr.count='||pt_attr.count
      ||', p_admin_unit_id='||p_admin_unit_id
      ||', p_splits_rowcount='||p_splits_rowcount
      ||', p_description='||p_description
      ||')');
    nm3dbg.ind;
    
    
    if pt_attr.count = 0 then
      p_mrg_job_id := nm3seq.next_rtg_job_id_seq;
      
    end if;
    
    -- init static vaules
    r_res.nqr_nmq_id := p_nmq_id;
    r_res.nqr_source := 'ROUTE';
    r_res.nqr_admin_unit := p_admin_unit_id;
    
    nm3dbg.putln('open populate query');
    
    
    -- chunk_no identifies the connected chunk within route
    --  (each route can have many distinct connected chunks
    --    because of breaks in connectivity)
    -- cunk_seq is the order by of the pieces within chunk
    for r in (        
        select
           q3.nm_ne_id_in
          ,q3.chunk_no
          ,q3.chunk_seq
          ,q3.nm_ne_id_of
          ,q3.inv_begin_mp
          ,q3.inv_end_mp
          ,q3.nm_inv_begin_mp
          ,q3.nm_inv_end_mp
          ,q3.hash_value
          ,q3.nm_begin_mp
          ,q3.nm_end_mp
          ,q3.nt_unit_in
          ,q3.nt_unit_of
          ,q3.measure
          ,q3.end_measure
          ,q3.nm_slk
          ,q3.nm_end_slk
          ,q3.lag_nm_ne_id_in
          ,q3.lag_chunk_no
          ,q3.lag_chunk_seq
          ,lag(q3.hash_value, 1, null) over
            (partition by q3.nm_ne_id_in, q3.chunk_no order by q3.chunk_seq, q3.inv_begin_mp, q3.inv_end_mp) lag_hash_value
          ,lag(q3.nm_end_mp - q3.inv_end_mp, 1, 0) over
            (partition by q3.nm_ne_id_in, q3.chunk_no order by q3.chunk_seq, q3.inv_begin_mp, q3.inv_end_mp) lag_datum_gap
        from (
        select q2.*
          ,decode(q2.nm_cardinality, 1, q2.begin_mp, q2.nm_end_mp - q2.end_mp) inv_begin_mp
          ,decode(q2.nm_cardinality, 1, q2.end_mp, q2.nm_end_mp - q2.begin_mp) inv_end_mp
        from (
        select
           qq.*
          ,greatest(inv.nm_begin_mp, qq.nm_begin_mp) begin_mp
          ,least(inv.nm_end_mp, qq.nm_end_mp) end_mp
          ,lag(qq.nm_ne_id_in, 1, null) over
            (order by qq.nm_ne_id_in, qq.chunk_no, qq.chunk_seq, inv.nm_begin_mp * qq.nm_cardinality, inv.nm_end_mp * qq.nm_cardinality) lag_nm_ne_id_in
          ,lag(qq.chunk_no, 1, null) over
            (partition by qq.nm_ne_id_in order by qq.chunk_no, qq.chunk_seq, inv.nm_begin_mp * qq.nm_cardinality, inv.nm_end_mp * qq.nm_cardinality) lag_chunk_no
          ,lag(qq.chunk_seq, 1, null) over
            (partition by qq.nm_ne_id_in, qq.chunk_no order by qq.chunk_seq, inv.nm_begin_mp * qq.nm_cardinality, inv.nm_end_mp * qq.nm_cardinality) lag_chunk_seq
          ,inv.hash_value
          ,inv.nm_begin_mp nm_inv_begin_mp
          ,inv.nm_end_mp nm_inv_end_mp
        from
          (
          select
             q.nm_ne_id_in
            ,dense_rank() over (partition by q.nm_ne_id_in order by q.nsc_seq_no, q.min_slk_measure) chunk_no
            ,q.chunk_seq, q.nm_ne_id_of, q.nm_begin_mp, q.nm_end_mp, q.measure, q.end_measure
            ,q.nm_slk, q.nm_end_slk, nvl(q.nm_cardinality, 1) nm_cardinality, q.nt_unit_in, q.nt_unit_of
          from (
          select
             t.*
            ,min(nvl(t.nm_slk, t.measure)) over (partition by t.nm_ne_id_in, t.chunk_no) min_slk_measure
            ,decode(e.ne_type, 'D', null, nvl((select case when nsc_seq_no <= 2 then 1 else 2 end
                from nm_type_subclass
                where nsc_sub_class = e.ne_sub_class and nsc_nw_type = e.ne_nt_type
               ), 1)) nsc_seq_no
          from
             nm_route_connectivity_tmp t
            ,nm_elements_all e
          where t.nm_ne_id_of = e.ne_id
          ) q
          ) qq
          ,nm_mrg_datum_homo_chunks_tmp inv
        where qq.nm_ne_id_of = inv.nm_ne_id_of
          and ((qq.nm_begin_mp < inv.nm_end_mp and qq.nm_end_mp > inv.nm_begin_mp)
            or ((qq.nm_begin_mp = qq.nm_end_mp or inv.nm_begin_mp = inv.nm_end_mp)
              and (qq.nm_begin_mp = inv.nm_end_mp or qq.nm_end_mp = inv.nm_begin_mp)))
        ) q2
        ) q3
        order by
           q3.nm_ne_id_in
          ,q3.chunk_no
          ,q3.chunk_seq
          ,q3.inv_begin_mp
    )
    loop
      j := j + 1;
      
--      nm3dbg.putln('r('||j||'): '
--        ||'nm_ne_id_of='||r.nm_ne_id_of
--        --||', lag_nm_ne_id_in='||r.lag_nm_ne_id_in
--        --||', chunk_no='||r.chunk_no
--        --||', lag_chunk_no='||r.lag_chunk_no
--        ||', hash_value='||r.hash_value
--        ||', lag_hash_value='||r.lag_hash_value
--        ||', lag_datum_gap='||r.lag_datum_gap
--        ||', inv_begin_mp='||r.inv_begin_mp
--        ||', inv_end_mp='||r.inv_end_mp
--        ||', chunk_seq='||r.chunk_seq
--        ||', lag_chunk_seq='||r.lag_chunk_seq
--        );
      
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
          lc_sect := lc_sect + sql%rowcount;
          forall i in 1 .. t_memb.count
            insert into nm_mrg_section_members values t_memb(i);
          lc_memb := lc_memb + sql%rowcount;
          
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
          r_res.nqr_source_id := r.nm_ne_id_in;
          r_res.nqr_mrg_section_members_count := 0;
          r_res.nqr_admin_unit := p_admin_unit_id;
          insert into nm_mrg_query_results_all values r_res;
          nm3dbg.putln('ins nm_mrg_query_results_all (nqr_mrg_job_id='||r_res.nqr_mrg_job_id||'): '||sql%rowcount);
        end if;
        
      end if;
      
      -- PT 05.05.09
      --  the lag_datum_gap = 0 is a nautrual single check for inv chunk connectivity
      --  to produce same results as old code the point chunks must not connect
      --  this code still connects a previous point chunk to next continuous chunk
      --  in reality this doesn't happen unless same asset type is both point and continuous
      
      -- same section 
      if r.nm_ne_id_in = r.lag_nm_ne_id_in        -- new route
        and r.chunk_no = r.lag_chunk_no           -- new route chunk
        and r.hash_value = r.lag_hash_value       -- different inv attribute values
        and r.lag_datum_gap = 0                   -- prevous chunk does not reach the datum end
        and r.inv_begin_mp < r.inv_end_mp         -- do not connect point chunks (differ from old code results)
        and r.chunk_seq - r.lag_chunk_seq <= 1    -- gap between chunk sequences
        
      then
        null;
         
      
      -- new section
      else
--        nm3dbg.putln('new section i='||i);
      
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
          t_sect(i).nms_begin_offset  := nvl(r.nm_slk, r.measure) + (r.inv_begin_mp - r.nm_begin_mp);
        else
          if r.nm_slk is null then
            t_sect(i).nms_begin_offset  := nm3unit.convert_unit(
                r.nt_unit_of, r.nt_unit_in, r.measure + (r.inv_begin_mp - r.nm_begin_mp));
          else
            t_sect(i).nms_begin_offset  := r.nm_slk + nm3unit.convert_unit(
                r.nt_unit_of, r.nt_unit_in, (r.inv_begin_mp - r.nm_begin_mp));
          end if;      
        end if;
        t_sect(i).nms_end_offset      := null;
        t_sect(i).nms_ne_id_first     := r.nm_ne_id_of;
        t_sect(i).nms_begin_mp_first  := r.inv_begin_mp; --r.inv_begin_mp;
        t_sect(i).nms_ne_id_last      := null;
        t_sect(i).nms_end_mp_last     := null;
        t_sect(i).nms_in_results      := 'Y';
        t_sect(i).nms_orig_sect_id    := l_chunk_no;
      end if;
      
      
      -- carry forward the section end values
      t_sect(i).nms_ne_id_last  := r.nm_ne_id_of;
      t_sect(i).nms_end_mp_last := r.inv_end_mp; --r.inv_end_mp;
      
      -- end offset
      --  special case point section, use begin value
      if r.nm_inv_begin_mp = r.nm_inv_end_mp then
        t_sect(i).nms_end_offset := t_sect(i).nms_begin_offset;
      -- standard section, calcualte
      elsif r.nt_unit_in = r.nt_unit_of then
        t_sect(i).nms_end_offset  := nvl(r.nm_end_slk, r.end_measure) - (r.nm_end_mp - r.inv_end_mp);
      else
        if r.nm_end_slk is null then
          t_sect(i).nms_end_offset  := nm3unit.convert_unit(
              r.nt_unit_of, r.nt_unit_in, r.end_measure - (r.nm_end_mp - r.inv_end_mp));
        else
          t_sect(i).nms_end_offset  := r.nm_end_slk - nm3unit.convert_unit(
              r.nt_unit_of, r.nt_unit_in, (r.nm_end_mp - r.inv_end_mp));
        end if;
      end if;
    
      
      -- handle the section member record
      k := t_memb.count + 1;
      t_memb(k).nsm_mrg_job_id      := t_sect(i).nms_mrg_job_id;
      t_memb(k).nsm_mrg_section_id  := t_sect(i).nms_mrg_section_id;
      t_memb(k).nsm_ne_id           := r.nm_ne_id_of;
      t_memb(k).nsm_begin_mp        := r.nm_inv_begin_mp; --r.inv_begin_mp;
      t_memb(k).nsm_end_mp          := r.nm_inv_end_mp; --r.inv_end_mp;
      t_memb(k).nsm_measure         := l_nsm_measure;
      
      l_nsm_measure := l_nsm_measure + (r.nm_inv_end_mp - r.nm_inv_begin_mp);
      
      
    end loop;
    
    
--    -- test the loop count
--    nm3dbg.putln('populate count: '||j);
--    if j = 0 then
--      raise_application_error(-20001,
--        'No merge results');
--    end if;
    
    
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
      lc_sect := lc_sect + sql%rowcount;
      forall i in 1 .. t_memb.count
        insert into nm_mrg_section_members values t_memb(i);
      lc_memb := lc_memb + sql%rowcount;
      
      nm3dbg.putln('ins nm_mrg_sections_all: '||lc_sect);
      nm3dbg.putln('ins nm_mrg_section_members: '||lc_memb);
      
      -- insert all invitems
      std_insert_invitems(
         p_mrg_job_id => r_res.nqr_mrg_job_id
        ,pt_attr => pt_attr
        ,p_splits_rowcount => p_splits_rowcount
      );
          
    end if;
    
    -- assign the out value
    p_mrg_job_id := r_res.nqr_mrg_job_id;
    if p_mrg_job_id is null then
      p_mrg_job_id := nm3seq.next_rtg_job_id_seq;
    end if;
  
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.std_populate('
        ||'p_nmq_id='||p_nmq_id
        ||', pt_attr.count='||pt_attr.count
        ||', p_admin_unit_id='||p_admin_unit_id
        ||', p_splits_rowcount='||p_splits_rowcount
        ||', j='||j
        ||', i='||i
        ||', k='||k
        ||', l_section_id='||l_section_id
        ||', l_chunk_no='||l_chunk_no
        ||', l_nqr_memb_count='||l_nqr_memb_count
        ||', l_nsm_measure='||l_nsm_measure
        ||')');
      raise;
   
  end;
  
  
  
  -- This is the main procedure to be called from outside
  -- The road connectivity loading has been taken out from here
  --  Before this procedure is called both datum criteria and road connectivity must be loaded!
  -- NB! to ensure absolute consistency precede the call to this procedure with
  --  set transaction isolation lelvel serializable
  procedure std_run(
     p_nmq_id in nm_mrg_query_all.nmq_id%type
    ,p_nqr_admin_unit in nm_mrg_query_results_all.nqr_admin_unit%type
    ,p_nmq_descr in nm_mrg_query_all.nmq_descr%type
    ,p_ignore_poe in boolean
    ,p_criteria_rowcount in integer
    ,p_mrg_job_id out nm_mrg_query_results_all.nqr_mrg_job_id%type
    ,p_longops_rec in out nm3sql.longops_rec
  )
  is
    t_inv               ita_mapping_tbl;
    t_idt               itd_tbl;
    l_inner_join        boolean;
    l_effective_date    constant date := nm3user.get_effective_date;
    l_splits_rowcount   integer;
    l_homo_rowcount     integer;
    l_connect_rowcount  integer;
    l_nau_admin_type    nm_admin_units.nau_admin_type%type; -- varchar2(4)
    
  begin
    nm3dbg.putln(g_package_name||'.std_run('
      ||'p_nmq_id='||p_nmq_id
      ||', p_nqr_admin_unit='||p_nqr_admin_unit
      ||', p_nmq_descr='||p_nmq_descr
      ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
      ||', p_criteria_rowcount='||p_criteria_rowcount
      ||', l_effective_date='||l_effective_date
      ||')');
    nm3dbg.ind;
    
    -- assert
    if p_nmq_id is null or p_nqr_admin_unit is null or p_nmq_descr is null or p_criteria_rowcount is null then
      raise_application_error(-200099, 'Invalid call parameter');
    end if;
    
    
    -- merge query security
    if not nm3mrg_security.is_query_executable(
       p_nmq_id => p_nmq_id
    )
    then
      raise_application_error(-20917
        ,'You are not allowed to execute this merge query');
    end if;
    
    -- au security
    l_nau_admin_type := hig.get_sysopt('MRGAUTYPE');
    if l_nau_admin_type is not null then
      if nm3ausec.get_au_type(p_au => p_nqr_admin_unit) = l_nau_admin_type then
        null;
      else
        raise_application_error(-20918
          ,'Admin Unit Type must be: '||l_nau_admin_type);
      end if;
    end if;
   
        
    -- 1
    load_attrib_metadata(
       pt_attr  => t_inv
      ,pt_itd   => t_idt
      ,p_inner_join => l_inner_join
      ,p_nmq_id => p_nmq_id
    );
    -- no inv types defined for the merge query
    if t_inv.count = 0 then
      hig.raise_ner(
         pi_appl => 'NET'
        ,pi_id => 120 -- No query types defined.
      );
    end if;
    
    ins_splits(
       pt_attr            => t_inv
      ,p_effective_date   => l_effective_date
      ,p_criteria_rowcount  => p_criteria_rowcount
      ,p_rowcount_out     => l_splits_rowcount    -- out
    );
    nm3sql.set_longops(p_rec => p_longops_rec, p_increment => 1);
    -- 2
    ins_datum_homo_chunks(
       pt_attr          => t_inv
      ,pt_itd           => t_idt
      ,p_inner_join     => l_inner_join
      ,p_splits_rowcount => l_splits_rowcount -- in
      ,p_rowcount_out   => l_homo_rowcount    -- out
    );
    nm3sql.set_longops(p_rec => p_longops_rec, p_increment => 1);
    -- 3
    std_populate(
       p_nmq_id         => p_nmq_id
      ,pt_attr          => t_inv
      ,p_admin_unit_id  => p_nqr_admin_unit
      ,p_splits_rowcount => l_splits_rowcount -- in
      ,p_description    => p_nmq_descr
      ,p_mrg_job_id     => p_mrg_job_id       -- out
    );
    nm3sql.set_longops(p_rec => p_longops_rec, p_increment => 1);
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.std_run('
        ||'p_nmq_id='||p_nmq_id
        ||', p_nqr_admin_unit='||p_nqr_admin_unit
        ||', p_nmq_descr='||p_nmq_descr
        ||', p_ignore_poe='||nm3dbg.to_char(p_ignore_poe)
        ||', p_criteria_rowcount='||p_criteria_rowcount
        ||', l_inner_join='||nm3dbg.to_char(l_inner_join)
        ||', l_splits_rowcount='||l_splits_rowcount
        ||', l_homo_rowcount='||l_homo_rowcount
        ||', l_connect_rowcount='||l_connect_rowcount
        ||')');
      raise;
      
  end;
    
  
  
  
  
  -- this populates the section_inv_values and section_member_inv tables
  --  called from within std_populate()
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
      s           varchar2(32767);
      l_inv_alias varchar(3);
      k           binary_integer := 1;
      j           binary_integer := 0;
      l_attrib    varchar2(100);
    begin
      i := pt_attr.first;
      while i is not null loop
        j := j + 1;
        if pt_attr(i).table_name is null then
          l_inv_alias := 'i';
          l_attrib := pt_attr(i).iit_attrib_name;
        else
          if pt_attr(i).seq = 1 then
            k := k + 1;
          end if;
          l_inv_alias := 'i'||k;
          l_attrib := pt_attr(i).ita_attrib_name;
        end if;
        -- CWS test 0108614 03/11/2009
        -- Change made to prevent the year 1949 appearing as 2049 in the Merge Query Module.
        IF pt_attr(i).ita_format = 'DATE' 
        THEN 
          s := s||cr||'  ,case t.nm_obj_type'
          ||cr||'    when '''||pt_attr(i).inv_type
          ||''' then to_char('||l_inv_alias||'.'||l_attrib||', '''|| nm3user.get_user_date_mask ||''') end NSV_ATTRIB'||j;
        ELSE
          s := s||cr||'  ,case t.nm_obj_type'
          ||cr||'    when '''||pt_attr(i).inv_type
          ||''' then '||l_inv_alias||'.'||l_attrib||' end NSV_ATTRIB'||j;
        END IF;   
        --  
        i := pt_attr.next(i);
      end loop;
      return s;
      
    end;
    
    --  ,(select 'XNAA' ft_inv_type, ft2.FT_PK_COL, ft2.NAA_DESCR from XNMDOT_NAA ft2) i2
    --  ,(select  distinct 'SEGM' ft_inv_type, ft8.NE_FT_PK_COL, ft8.GROUP_TYPE, ft8.ROUTE from XNMDOT_V_SEGM ft8) i8
    -- repeate from ins_datum_homo_chunks()
    function sql_ft_sources return varchar2
    is
      s           varchar2(32767);
      k           binary_integer := 1;
      s_tmp       varchar2(1000);
      s_tmp_tbl   varchar2(30);
    begin
      i := pt_attr.first;
      while i is not null loop
      
        -- finish the previous if present
        if pt_attr(i).seq = 1 and s_tmp is not null then
          s := s||cr||s_tmp||' from '||s_tmp_tbl||' ft'||k||') i'||k;
          s_tmp := null;
          s_tmp_tbl := null;
        end if;
        -- it is an FT
        if pt_attr(i).table_name is not null then
        
          -- start new
          if pt_attr(i).seq = 1 then
            k := k + 1;
            s_tmp := '    ,(select distinct '''||pt_attr(i).inv_type||''' ft_inv_type, '
              --||'ft'||k||'.'||pt_attr(i).table_pk_column||', ft'||k||'.'||pt_attr(i).ita_attrib_name;
              ||'ft'||k||'.'||pt_attr(i).table_pk_column||' '||pt_attr(i).table_pk_column||'$, ft'||k||'.'||pt_attr(i).ita_attrib_name;
            s_tmp_tbl := pt_attr(i).table_name;
              
          -- add column to existing
          else
            s_tmp := s_tmp||', ft'||k||'.'||pt_attr(i).ita_attrib_name;
          
          end if;
        end if;
        
        i := pt_attr.next(i);
      end loop;
      
      -- last one after loop
      if s_tmp is not null then
        s := s||cr||s_tmp||' from '||s_tmp_tbl||' ft'||k||') i'||k;
      end if;
      
      return s;
    end;
    
    
    --  and t.nm_obj_type = i2.ft_inv_type (+)
    --  and t.nm_ne_id_in = i2.ne_id (+)
    function sql_ft_outer_joins return varchar2
    is
      s       varchar2(32767);
      k       binary_integer := 1;
      l_cr    varchar2(10) := '  ,';
    begin
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).seq = 1 and pt_attr(i).table_name is not null then
          k := k + 1;
          s := s||cr||'    and t.nm_obj_type = i'||k||'.ft_inv_type (+)'
                ||cr||'    and t.nm_ne_id_in = i'||k||'.'||pt_attr(i).table_pk_column||'$ (+)';
        end if;
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    --, nsv_attrib1, nsv_attrib2, nsv_attrib3
    function sql_nsv_attrib_cols(
       p_format in boolean
    ) return varchar2
    is
      s         varchar2(32767);
      j         binary_integer := 0;
      l_conversion varchar2(20);
      l_cr      varchar2(1);
      l_attrib  varchar2(100);
      l_ita_format_mask nm_inv_type_attribs_all.ita_format_mask%type;
      
    begin
      i := pt_attr.first;
      while i is not null loop
        j := j + 1;
        l_attrib := 'nsv_attrib'||j;
        l_ita_format_mask := null;
        
        if p_format then
          -- manually select ita_format_mask until it is made part of ita_mapping_rec
          
          if pt_attr(i).ita_format in ('NUMBER', 'DATE') then
            l_conversion := lower('to_'||pt_attr(i).ita_format);
          
            -- some columns like iit_end_date are not declared in nm_inv_type_attribs_all
            begin
              select ta.ita_format_mask
              into l_ita_format_mask
              from
                 nm_inv_type_attribs_all ta
              where ta.ita_inv_type = pt_attr(i).inv_type
                and ta.ita_attrib_name = nvl2(pt_attr(i).table_name, pt_attr(i).ita_attrib_name, pt_attr(i).iit_attrib_name);
            exception
              when no_data_found then
                null;
            end;
       
          end if;
          
          if pt_attr(i).ita_format = 'DATE' then
            l_ita_format_mask := nvl(l_ita_format_mask, m_mrg_date_format);
          end if;
        end if;
        
        -- date, number conversion
        --  conversions into nm_mrg_section_inv_values_tmp are done with database default format
        --  read out with default format and then convert into given format
        if l_ita_format_mask is not null then
          -- , to_char(to_date(nsv_attrib1), 'DD-MON-YYYY') nsv_attrib1
          s := s||l_cr||', to_char('||l_conversion||'('||l_attrib||'), '''||l_ita_format_mask||''')'||' '||l_attrib;
          
        -- no conversion
        else
          s := s||l_cr||', '||l_attrib;
        end if;
        
        if p_format then
          l_cr := cr;
        end if;
        
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    --  ,case
    --   when i.nm_obj_type in ('SAMP','SAMP','SAMP') then 'C'
    --   end pnt_or_cont
    function sql_pnt_or_cont return varchar2
    is
      s         varchar2(32767);
      s_pnt     varchar2(32767);
      s_cont    varchar2(32767);
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
      s       varchar2(32767);
      j       binary_integer := 0;
      l_nval  varchar2(40);
    begin
      i := pt_attr.first;
      while i is not null loop
        j := j + 1;
        if pt_attr(i).ita_format = 'VARCHAR2' then
          l_nval := '''-999''';
        elsif pt_attr(i).ita_format = 'NUMBER' then
          l_nval := '-999';
        elsif pt_attr(i).ita_format = 'DATE' then
          l_nval := 'to_date(''13430101'', ''YYYYMMDD'')';
        end if;
        
        s := s||cr||'  and nvl('||p_a1||'.nsv_attrib'||j||', '||l_nval||') = nvl('||p_a2||'.nsv_attrib'||j||', '||l_nval||')';
--        s := s||cr||'  and (('||p_a1||'.nsv_attrib'||j||' is null and '||p_a2||'.nsv_attrib'||j
--          ||' is null) or '||p_a1||'.nsv_attrib'||j||' = '||p_a2||'.nsv_attrib'||j||')';
        i := pt_attr.next(i);
      end loop;
      return s;
    end;
    
    
    
  -- main procedure body starts here
  begin
    nm3dbg.putln(g_package_name||'.std_insert_invitems('
      ||'p_mrg_job_id='||p_mrg_job_id
      ||', pt_attr.count='||pt_attr.count
      ||', p_splits_rowcount='||p_splits_rowcount
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
    --      don't use append hint here as the table does not preserve rows
    --      the dates are inserted with default database format
    l_sql := 
          'insert into nm_mrg_section_inv_values_tmp('
    ||cr||'  nsi_mrg_section_id, nsv_mrg_job_id, nsv_value_id, nsv_inv_type, nsv_x_sect, nsv_pnt_or_cont'
    ||cr||sql_nsv_attrib_cols(p_format => false)
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
--    ||cr||'    or (t.nm_begin_mp = t.nm_end_mp and t.nm_begin_mp = m.nsm_begin_mp and t.nm_begin_mp = m.nsm_end_mp))'
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
    ||cr||sql_nsv_attrib_cols(p_format => false)
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
    
    nm3dbg.putln('nm_mrg_section_inv_values_tmp rowcount='||sql%rowcount);
    
    
    -- 2. insert the item values
    --      the dates are read out with default database format and then converted explicitly
    l_sql := 
      'insert into nm_mrg_section_inv_values_all('
    ||cr||'  nsv_mrg_job_id, nsv_value_id, nsv_inv_type, nsv_x_sect, nsv_pnt_or_cont'
    ||cr||sql_nsv_attrib_cols(p_format => false)
    ||cr||')'
    ||cr||'select q.nsv_mrg_job_id, q.nsv_value_id, q.nsv_inv_type, q.nsv_x_sect, q.nsv_pnt_or_cont'
    ||cr||sql_nsv_attrib_cols(p_format => false)
    ||cr||'from ('
    ||cr||'select'
    ||cr||'  nsv_mrg_job_id, nsv_value_id, nsv_inv_type, nsv_x_sect, nsv_pnt_or_cont'
    ||cr||sql_nsv_attrib_cols(p_format => true)
    ||cr||', row_number() over (partition by nsv_mrg_job_id, nsv_value_id order by 1) row_num'
    ||cr||'from nm_mrg_section_inv_values_tmp'
    ||cr||') q'
    ||cr||'where q.row_num = 1';
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql;
    
    nm3dbg.putln('nm_mrg_section_inv_values_all rowcount='||sql%rowcount);
    
    
    
    -- 3. insert item member records
    insert into nm_mrg_section_member_inv (
      nsi_mrg_job_id, nsi_mrg_section_id, nsi_inv_type, nsi_x_sect, nsi_value_id
    )
    select
      nsv_mrg_job_id, nsi_mrg_section_id, nsv_inv_type, nsv_x_sect, nsv_value_id
    from nm_mrg_section_inv_values_tmp;
    
    nm3dbg.putln('nm_mrg_section_member_inv rowcount='||sql%rowcount);
    
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.std_insert_invitems('
        ||'p_mrg_job_id='||p_mrg_job_id
        ||', pt_attr.count='||pt_attr.count
        ||', p_splits_rowcount='||p_splits_rowcount
        ||', l_splits_cardinality='||l_splits_cardinality
        ||')');
      raise;
  end;
  
  
  
  -- loads datum criteria for as single group or datum
  --  the group can be linear or non linear
  --  TODO: add support for group of groups
  procedure load_group_datums(
     p_group_id in nm_elements_all.ne_id%type
    ,p_sqlcount out pls_integer
  )
  is
    l_sql               varchar2(10000);
    l_group_type        nm_group_types.ngt_group_type%type;
    l_ne_type           nm_elements.ne_type%type;
    l_ngt_linear_flag   nm_group_types.ngt_linear_flag%type;
    
  begin
    nm3dbg.putln(g_package_name||'.load_group_datums('
      ||'p_group_id='||p_group_id
      ||')');
      
    l_ne_type := nm3net.get_ne_type(p_group_id);
    nm3dbg.putln('l_ne_type='||l_ne_type);
    
    execute immediate 'truncate table nm_datum_criteria_tmp';
    
    case 
    
    -- linear or non-linear group
    when l_ne_type = 'G' then
      l_group_type := nm3net.get_gty_type(p_group_id);
      
      -- this nullifies the l_group_type if not linear
      ensure_group_type_linear(
         p_group_type_in  => l_group_type
        ,p_group_type_out => l_group_type
      );
      
      -- linear group
      if l_group_type is not null then
      
        -- special hard coded handling of a linear group
        insert /*+ append */ into nm_datum_criteria_tmp (
          datum_id, begin_mp, end_mp, group_id
        )
        select nm_ne_id_of, min(nm_begin_mp) begin_mp, max(nm_end_mp) end_mp, p_group_id group_id
        from nm_members
        where nm_ne_id_in = p_group_id
        group by nm_ne_id_of;
        p_sqlcount := sql%rowcount;
       
      -- non linear group 
      else
        l_sql :=
          sql_load_nm_datum_criteria_tmp(
             p_elements_sql => 
                    '    select nm_ne_id_of, min(nm_begin_mp) begin_mp, max(nm_end_mp) end_mp'
              ||cr||'    from nm_members'
              ||cr||'    where nm_ne_id_in = :p_group_id'
              ||cr||'    group by nm_ne_id_of' 
          );
      
      end if;
    -- datum or distance breake
    when l_ne_type in ('S','D') then
      insert into nm_datum_criteria_tmp(
        datum_id, begin_mp, end_mp, group_id
      )
      select ne_id nm_ne_id_of, 0 begin_mp, ne_length end_mp, null
      from nm_elements
      where ne_id = p_group_id;
      p_sqlcount := sql%rowcount;
--      l_sql :=
--        sql_load_nm_datum_criteria_tmp(
--           p_elements_sql => 
--                  '    select ne_id nm_ne_id_of, 0 begin_mp, ne_length end_mp'
--            ||cr||'    from nm_elements'
--            ||cr||'    where ne_id = :p_group_id' 
--        );
    
    -- group of groups
    when l_ne_type = 'P' then
      l_sql :=
        sql_load_nm_datum_criteria_tmp(
           p_elements_sql => 
                  '    select nm_ne_id_of, min(nm_begin_mp) begin_mp, max(nm_end_mp) end_mp'
            ||cr||'    from'
            ||cr||'       nm_members'
            ||cr||'    where nm_ne_id_of in ('
            ||cr||'      select ne_id'
            ||cr||'      from'
            ||cr||'         nm_elements'
            ||cr||'      where ne_id in (select nm_ne_id_of from nm_members'
            ||cr||'                        connect by nm_ne_id_in = prior nm_ne_id_of'
            ||cr||'                        start with nm_ne_id_in = :p_group_id)'
            ||cr||'        and ne_type = ''S'''
            ||cr||'      )'
            ||cr||'    group by nm_ne_id_of'
         );
    
    end case;
    
    if l_sql is not null then
      nm3dbg.putln(l_sql);
      execute immediate l_sql
      using
         p_group_id
        ,l_group_type;
      p_sqlcount := sql%rowcount;
      
    end if;
    
    commit;
   
    nm3dbg.putln('nm_datum_criteria_tmp rowcount='||p_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_group_datums('
        ||'p_group_id='||p_group_id
        ||', l_group_type='||l_group_type
        ||', l_ne_type='||l_ne_type
        ||')');
      raise;
      
  end;
  
  
  
  -- load datum criteria for a single saved extent
  procedure load_extent_datums(
     p_group_type in nm_group_types.ngt_group_type%type
    ,p_nse_id in nm_saved_extents.nse_id%type
    ,p_sqlcount out pls_integer
  )
  is
    l_sql     constant varchar2(10000) :=
      sql_load_nm_datum_criteria_tmp(
         p_elements_sql => 
                '    select d.nsd_ne_id nm_ne_id_of, min(d.nsd_begin_mp) begin_mp, max(d.nsd_end_mp) end_mp'
          ||cr||'    from nm_saved_extent_member_datums d'
          ||cr||'    where d.nsd_nse_id = :p_nse_id'
          ||cr||'    group by d.nsd_ne_id' 
      );
    l_group_type nm_group_types.ngt_group_type%type;
    
  begin
    nm3dbg.putln(g_package_name||'.load_extent_datums('
      ||'p_group_type='||p_group_type
      ||', p_nse_id='||p_nse_id
      ||')');
    nm3dbg.ind;
    
    ensure_group_type_linear(
       p_group_type_in  => p_group_type
      ,p_group_type_out => l_group_type
    );
    
    execute immediate 'truncate table nm_datum_criteria_tmp';
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql
    using
       p_nse_id
      ,l_group_type;
    p_sqlcount := sql%rowcount;
    commit;
    
    nm3dbg.putln('nm_mrg_section_member_inv rowcount='||p_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_extent_datums('
        ||'p_nse_id='||p_nse_id
        ||', l_group_type='||l_group_type
        ||')');
      raise;
  
  end;
  
  
  -- load datum criteria for a single group type
  --  the group type can be linear or non-linear
  --  if linear then the type is used for route connectivity
  procedure load_group_type_datums(
     p_group_type in nm_members_all.nm_obj_type%type
    ,p_sqlcount out pls_integer
  )
  is
    l_sql     constant varchar2(10000) :=
      sql_load_nm_datum_criteria_tmp(
         p_elements_sql => 
                '    select nm_ne_id_of, min(nm_begin_mp) begin_mp, max(nm_end_mp) end_mp'
          ||cr||'    from nm_members'
          ||cr||'    where nm_obj_type = :p_group_type'
          ||cr||'    group by nm_ne_id_of' 
      );
    l_group_type nm_group_types.ngt_group_type%type;
      
  begin
    nm3dbg.putln(g_package_name||'.load_group_type_datums('
      ||'p_group_type='||p_group_type
      ||')');
    nm3dbg.ind;
    
    -- check that the type given is linear group type
    --  if not then don't use it for route connectivity
    ensure_group_type_linear(
       p_group_type_in  => p_group_type
      ,p_group_type_out => l_group_type
    );
    
    execute immediate 'truncate table nm_datum_criteria_tmp';
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql
    using
       p_group_type
      ,l_group_type;
    p_sqlcount := sql%rowcount;
    commit;
    
    nm3dbg.putln('nm_datum_criteria_tmp rowcount='||p_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_group_type_datums('
        ||'p_group_type='||p_group_type
        ||', l_group_type='||l_group_type
        ||')');
      raise;
      
  end;
  
  -- load datum criteria for one network type
  --  the type must be linear datum type
  procedure load_nt_type_datums(
     p_group_type in varchar2
    ,p_nt_type in nm_types.nt_type%type
    ,p_sqlcount out pls_integer
  )
  is
    l_nt_type     nm_types.nt_type%type;
    l_group_type  nm_group_types.ngt_group_type%type;
    l_sql         constant varchar2(10000) :=
      sql_load_nm_datum_criteria_tmp(
         p_elements_sql => 
                '    select e.ne_id nm_ne_id_of, 0 begin_mp, ne_length end_mp'
          ||cr||'    from nm_elements e'
          ||cr||'    where e.ne_nt_type in ('
          ||cr||'      select nt_type from nm_types' 
          ||cr||'      where nt_datum = ''Y'''
          ||cr||'        and nt_linear = ''Y'''
          ||cr||'        and nt_type = :l_nt_type'
          ||cr||'    )'
      );
    
  begin
    nm3dbg.putln(g_package_name||'.load_nt_type_datums('
      ||'p_group_type='||p_group_type
      ||', p_nt_type='||p_nt_type
      ||')');
    nm3dbg.ind;
    
    execute immediate 'truncate table nm_datum_criteria_tmp';
    -- check that the type given is linear datum type
    begin
      select nt_type into l_nt_type
      from nm_types where nt_type = p_nt_type
        and nt_datum = 'Y' and nt_linear = 'Y';
    exception
      when no_data_found then
        raise_application_error(-20301
          ,'Invalid parameter: nt_type must be a linear datm network type: '||p_nt_type);
    end;
    
    ensure_group_type_linear(
       p_group_type_in  => p_group_type
      ,p_group_type_out => l_group_type
    );
      
    nm3dbg.putln(l_sql);
    execute immediate l_sql
    using
       l_nt_type
      ,l_group_type;
    p_sqlcount := sql%rowcount;
    commit;
      
    nm3dbg.putln('nm_datum_criteria_tmp rowcount='||p_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_nt_type_datums('
        ||'p_group_type='||p_group_type
        ||', p_nt_type='||p_nt_type
        ||', l_group_type='||l_group_type
        ||')');
      raise;
      
  end;
  
  
  -- load datum ctriteria for the whole network
  procedure load_all_network_datums(
     p_group_type in varchar2
    ,p_sqlcount out pls_integer
  )
  is
    l_group_type  nm_group_types.ngt_group_type%type;
    l_sql constant varchar2(10000) :=
      sql_load_nm_datum_criteria_tmp(
         p_elements_sql => 
                '    select e.ne_id nm_ne_id_of, 0 begin_mp, ne_length end_mp'
          ||cr||'    from nm_elements e'
          ||cr||'    where e.ne_nt_type in ('
          ||cr||'      select nt_type from nm_types' 
          ||cr||'      where nt_datum = ''Y'''
          ||cr||'        and nt_linear = ''Y'''
          ||cr||'    )'
      );
  begin
    nm3dbg.putln(g_package_name||'.load_all_network_datums('
      ||'p_group_type='||p_group_type
      ||')');
    nm3dbg.ind;
      
    execute immediate 'truncate table nm_datum_criteria_tmp';
    
    ensure_group_type_linear(
       p_group_type_in  => p_group_type
      ,p_group_type_out => l_group_type
    );
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql
    using
       l_group_type;
    p_sqlcount := sql%rowcount;
    commit;
       
    nm3dbg.putln('nm_datum_criteria_tmp rowcount='||p_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_all_network_datums('
        ||'p_group_type='||p_group_type
        ||', l_group_type='||l_group_type
        ||')');
      raise;
      
  end;
  
  
  
  
  -- this is called from nm3inv_composite2
  procedure load_gaz_list_datums(
     p_group_type in varchar2
    ,pt_ne in nm_id_tbl
    ,pt_nse in nm_id_tbl
    ,p_sqlcount out pls_integer
  )
  is
    l_group_type  nm_group_types.ngt_group_type%type;
    i             binary_integer := pt_ne.first;
    l_inner_sql   varchar2(4000);
    l_sql         varchar2(10000);
    l_union_all   varchar2(20);
    l_union_count pls_integer := 0;
    l_other_count pls_integer;
    l_gg_count    pls_integer;
    
    l_ne_type     nm_elements.ne_type%type;
    
  begin
    nm3dbg.putln(g_package_name||'.load_gaz_list_datums('
      ||'p_group_type='||p_group_type
      ||', pt_ne.count='||pt_ne.count
      ||', pt_nse.count='||pt_nse.count
      ||')');
    nm3dbg.ind;
    
    -- reset the cached id tables
    mt_datum_id := new nm_id_tbl();
    mt_group_id := new nm_id_tbl();
    mt_gg_id    := new nm_id_tbl();
    mt_nse_id   := new nm_id_tbl();
      
    -- 1 saved extents
    if pt_nse.count > 0 then
      mt_nse_id := pt_nse;
      l_inner_sql := 
             '    select /*+ cardinality(x 2) */'
       ||cr||'      d.nsd_ne_id nm_ne_id_of, min(d.nsd_begin_mp) begin_mp, max(d.nsd_end_mp) end_mp'
       ||cr||'    from'
       ||cr||'       nm_saved_extent_member_datums d'
       ||cr||'      ,table(cast('||g_package_name||'.get_nse_id_tbl as nm_id_tbl)) x'
       ||cr||'    where d.nsd_nse_id = x.column_value'
       ||cr||'    group by d.nsd_ne_id';
       
       
      l_union_all := cr||'    union all'||cr;
      l_union_count := l_union_count + 1;
      
    end if;
  
  
  
    -- 2 routes and single datums
    if pt_ne.count > 0 then
      -- divide the datum and group elements into different tables
      while i is not null loop
        l_ne_type := nm3net.get_ne_type(pt_ne(i));
        case l_ne_type
        -- datum
        when 'S' then
          mt_datum_id.extend;
          mt_datum_id(mt_datum_id.last) := pt_ne(i);
        -- distance break
        when 'D' then
          mt_datum_id.extend;
          mt_datum_id(mt_datum_id.last) := pt_ne(i);
        -- group
        when 'G' then
          mt_group_id.extend;
          mt_group_id(mt_group_id.last) := pt_ne(i);
        -- group of groups
        when 'P' then
          mt_gg_id.extend;
          mt_gg_id(mt_gg_id.last) := pt_ne(i);
        end case;
        i := pt_ne.next(i);
      end loop;
      
      -- 2.1 datums (and distance breaks)
      if mt_datum_id.count > 0 then
        l_inner_sql := l_inner_sql
              ||l_union_all
              ||'    select /*+ cardinality(x 1) */'
          ||cr||'       ne_id nm_ne_id_of, 0 begin_mp, ne_length end_mp'
          ||cr||'    from'
          ||cr||'       nm_elements'
          ||cr||'      ,table(cast('||g_package_name||'.get_datum_id_tbl as nm_id_tbl)) x'
          ||cr||'    where ne_id = x.column_value';
        
          l_union_all := cr||'    union all'||cr;
          l_union_count := l_union_count + 1;
            
      end if;
      
      
      -- 2.2 groups
      if mt_group_id.count > 0 then
        l_inner_sql := l_inner_sql
              ||l_union_all
              ||'    select /*+ cardinality(x 1) */'
          ||cr||'      nm_ne_id_of, min(nm_begin_mp) begin_mp, max(nm_end_mp) end_mp'
          ||cr||'    from'
          ||cr||'       nm_members'
          ||cr||'      ,table(cast('||g_package_name||'.get_group_id_tbl as nm_id_tbl)) x'
          ||cr||'    where nm_ne_id_in = x.column_value'
          ||cr||'    group by nm_ne_id_of';
          
          l_union_all := cr||'    union all'||cr;
          l_union_count := l_union_count + 1;
      
      end if;
      
      
      -- 2.3 groups of groups
      if mt_gg_id.count > 0 then
        l_inner_sql := l_inner_sql
              ||l_union_all
              ||'    select nm_ne_id_of, min(nm_begin_mp) begin_mp, max(nm_end_mp) end_mp'
          ||cr||'    from'
          ||cr||'       nm_members'
          ||cr||'    where nm_ne_id_of in ('
          ||cr||'      select ne_id'
          ||cr||'      from'
          ||cr||'         nm_elements'
          ||cr||'      where ne_id in (select nm_ne_id_of from nm_members'
          ||cr||'                        connect by nm_ne_id_in = prior nm_ne_id_of'
          ||cr||'                        start with nm_ne_id_in in (select /*+ cardinality(x 1) */ x.column_value from table(cast('
                                                                   ||g_package_name||'.get_gg_id_tbl as nm_id_tbl)) x))'
          ||cr||'        and ne_type = ''S'''
          ||cr||'      )'
          ||cr||'    group by nm_ne_id_of';
        
          l_union_all := cr||'    union all'||cr;
          l_union_count := l_union_count + 1;
      
      end if;
    
    end if;
    
    
    -- if more than one source then wrap all into another group by to ensure distinct nm_ne_id_of
    if l_union_count > 1 then
      
      l_inner_sql := 
              '    select nm_ne_id_of, min(begin_mp) begin_mp, max(end_mp) end_mp'
        ||cr||'    from ('
        ||cr||l_inner_sql
        ||cr||'    )'
        ||cr||'    group by nm_ne_id_of';
        
    end if;
      
      
    l_sql :=
      sql_load_nm_datum_criteria_tmp(
         p_elements_sql => l_inner_sql
      );
    execute immediate 'truncate table nm_datum_criteria_tmp';
    
    ensure_group_type_linear(
       p_group_type_in  => p_group_type
      ,p_group_type_out => l_group_type
    );
    
    nm3dbg.putln(l_sql);
    execute immediate l_sql
    using 
       l_group_type;
    p_sqlcount := sql%rowcount;
    commit;
    
    nm3dbg.putln('nm_datum_criteria_tmp rowcount='||p_sqlcount);
    nm3dbg.deind;
--   exception
--     when others then
--       nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_gaz_list_datums('
--         ||'p_group_type='||p_group_type
--         ||', pt_ne.count='||pt_ne.count
--         ||', pt_nse.count='||pt_nse.count
--         ||', l_group_type='||l_group_type
--         ||')');
--       raise;
    
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
  
  
  
  -- TODO: this is no longer used, take out with the next header version
  procedure process_datums_group_type(
     p_group_type_in  in nm_group_types_all.ngt_group_type%type
    ,p_group_type_out out nm_group_types_all.ngt_group_type%type
  )
  is
    l_count       integer := nm3sql.get_id_tbl_count;
    l_cardinality integer := nm3sql.get_rounded_cardinality(l_count);
    l_sql_q_where varchar2(100);
  begin
    nm3dbg.putln(g_package_name||'.process_datums_group_type('
      ||'p_group_type_in='||p_group_type_in
      ||')');
    nm3dbg.ind;
    
    raise_application_error(-20999, 'Dead plsql code');
  end;
  
  
  
  -- this nullifies the passed passed in group type if it is not linear
  procedure ensure_group_type_linear(
     p_group_type_in in nm_group_types.ngt_group_type%type
    ,p_group_type_out out nm_group_types.ngt_group_type%type
  )
  is
  begin
    if p_group_type_in is not null then
      select ngt_group_type into p_group_type_out
      from nm_group_types where ngt_group_type = p_group_type_in
        and ngt_linear_flag = 'Y';
    end if;
  exception
    -- silent here, only log
    when no_data_found then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.ensure_group_type_linear('
        ||'p_group_type_in='||p_group_type_in
        ||')');
  end;
  
  
  
  -- this is the sql wrapper that inserts into nm_datum_criteria_tmp
  --  and calculates the group_id for each datum returned by the p_elements_sql
  -- this is called for each datum criteria load procedure
  -- TODO: consider turning this into a procedure that also executes the sql.
  function sql_load_nm_datum_criteria_tmp(
     p_elements_sql in varchar2
  ) return varchar2
  is
  begin
  
    -- this selects the member counts for each datum for every linear group that the datum is member of
    --  the group id with the highest member count is retunred in the group_id column
    --  if l_group_type has value then the the groups of this type have preference
    --  if two groups have equal highest count of members then the lowest nm_ne_id_in value is returned
    -- the spitting logic is copied from ins_splits()
    -- TODO:
    
    return
            'insert into nm_datum_criteria_tmp ('
      ||cr||'  datum_id, begin_mp, end_mp, group_id'
      ||cr||')'
      ||cr||'with rc as ('
      ||cr||'  select'
      ||cr||'     m.nm_ne_id_of'
      ||cr||'    ,m.nm_ne_id_in'
      ||cr||'    ,e.ne_gty_group_type'
      ||cr||'    ,greatest(m.nm_begin_mp, dc.begin_mp) nm_begin_mp'
      ||cr||'    ,least(m.nm_end_mp, dc.end_mp) nm_end_mp'
      ||cr||'  from'
      ||cr||'     ('
      ||cr||p_elements_sql
      ||cr||'     ) dc'
      ||cr||'    ,nm_members m'
      ||cr||'    ,nm_elements e'
      ||cr||'    ,nm_group_types_all gt'
      ||cr||'  where dc.nm_ne_id_of = m.nm_ne_id_of'
      ||cr||'    and m.nm_ne_id_in = e.ne_id'
      ||cr||'    and e.ne_gty_group_type = gt.ngt_group_type'
      ||cr||'    and gt.ngt_linear_flag = ''Y'''
      ||cr||'    and dc.begin_mp <= m.nm_end_mp'
      ||cr||'    and dc.end_mp >= m.nm_begin_mp'
      ||cr||')'
      ||cr||'select distinct'
      ||cr||'   q2.nm_ne_id_of'
      ||cr||'  ,q2.begin_mp'
      ||cr||'  ,q2.end_mp'
      ||cr||'  ,first_value(q2.nm_ne_id_in) over (partition by q2.nm_ne_id_of, q2.begin_mp order by q2.gty_order, q2.val_count desc, q2.nm_ne_id_in) group_id'
      ||cr||'from ('
      ||cr||'select'
      ||cr||'   q1.*'
      ||cr||'  ,m.nm_ne_id_in'
      ||cr||'  ,m.ne_gty_group_type'
      ||cr||'  ,decode(m.ne_gty_group_type, :l_group_type, 1, 2) gty_order'
      ||cr||'  ,count(*) over (partition by m.nm_ne_id_in) val_count'
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
      ||cr||'   rc.nm_ne_id_of'
      ||cr||'  ,rc.nm_begin_mp pos'
      ||cr||'  ,rc.nm_end_mp pos2'
      ||cr||'  ,decode(rc.nm_begin_mp, rc.nm_end_mp, 1, 0) is_point'
      ||cr||'from rc'
      ||cr||'union all'
      ||cr||'select distinct'
      ||cr||'   rc.nm_ne_id_of'
      ||cr||'  ,rc.nm_end_mp pos'
      ||cr||'  ,rc.nm_end_mp pos2'
      ||cr||'  ,decode(rc.nm_begin_mp, rc.nm_end_mp, 1, 0) is_point'
      ||cr||'from rc'
      ||cr||') m2'
      ||cr||') m3'
      ||cr||'where m3.end_mp is not null'
      ||cr||'  and (m3.end_mp != m3.begin_mp or m3.is_point = 1)'
      ||cr||') q1'
      ||cr||'right outer join'
      ||cr||'rc m'
      ||cr||'on q1.nm_ne_id_of = m.nm_ne_id_of'
      ||cr||'  and q1.begin_mp between m.nm_begin_mp and m.nm_end_mp'
      ||cr||'  and q1.end_mp between m.nm_begin_mp and m.nm_end_mp'
      ||cr||') q2';
      --||cr||'order by q2.nm_ne_id_of, q2.begin_mp, q2.end_mp'
    
--    return
--            'insert into nm_datum_criteria_tmp ('
--      ||cr||'  datum_id, begin_mp, end_mp, group_id'
--      ||cr||')'
--      ||cr||'with dc as ('
--      ||cr||p_elements_sql
--      ||cr||')'
--      ||cr||'select'
--      ||cr||'   dc.nm_ne_id_of'
--      ||cr||'  ,dc.begin_mp'
--      ||cr||'  ,dc.end_mp'
--      ||cr||'  ,q2.group_id'
--      ||cr||'from'
--      ||cr||'   dc'
--      ||cr||'  ,('
--      ||cr||'select distinct'
--      ||cr||'   q.nm_ne_id_of'
--      ||cr||'  ,first_value(q.nm_ne_id_in) over (partition by q.nm_ne_id_of order by q.gty_order, q.val_count desc, q.nm_ne_id_in) group_id'
--      ||cr||'from ('
--      ||cr||'select'
--      ||cr||'   m.nm_ne_id_of'
--      ||cr||'  ,m.nm_ne_id_in'
--      ||cr||'  ,decode(e.ne_gty_group_type, :l_group_type, 1, 2) gty_order'
--      ||cr||'  ,count(*) over (partition by m.nm_ne_id_in) val_count'
--      ||cr||'from'
--      ||cr||'   dc'
--      ||cr||'  ,nm_members m'
--      ||cr||'  ,nm_elements e'
--      ||cr||'  ,nm_group_types_all gt'
--      ||cr||'where dc.nm_ne_id_of = m.nm_ne_id_of'
--      ||cr||'  and m.nm_ne_id_in = e.ne_id'
--      ||cr||'  and e.ne_gty_group_type = gt.ngt_group_type'
--      ||cr||'  and gt.ngt_linear_flag = ''y'''
--      ||cr||') q'
--      ||cr||') q2'
--      ||cr||'where dc.nm_ne_id_of = q2.nm_ne_id_of (+)';
  
      
  end;
  
  
  
  -- this tries to select rowid from an FT table
  --  if succeeds then the table has a proper preserved pk
  --  if not then it is deflated by a join to nm_members or its native positioning data
  -- TODO: need to properly deal with materialized views, index organized and external tables
  procedure test_key_preserved(
     p_table_name in varchar2
  )
  is
    l_rowid rowid;
    l_dummy varchar2(1);
  begin
    execute immediate 'select rowid from '||p_table_name||' where rownum = 1' into l_rowid;
    -- if the next line does not raise invalid_rowid then the rowid is from nm_members
    select 'x' into l_dummy from nm_members_all where rowid = l_rowid;
    raise key_not_preserved;
  exception
    when no_data_found then
      null;
    when invalid_rowid then
      null;
    when rowid_with_group_by then
      null;
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.test_key_preserved('
        ||'p_table_name='||p_table_name
        ||')');
      raise;
  end;
  
  
  function is_key_preserved(
     p_table_name in varchar2
  ) return boolean
  is
  begin
    test_key_preserved(p_table_name);
    return true;
  exception
    when key_not_preserved then
      return false;
  end;
  
  
--
-----------------------------------------------------------------------------
--
END;
/
