CREATE OR REPLACE PACKAGE BODY nm3eng_dynseg_util AS
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3eng_dynseg_util.pkb-arc   2.12   Jul 04 2013 15:33:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3eng_dynseg_util.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:33:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       PVCS Version     : $Revision:   2.12  $
--
--   Author : Priidu Tanava
--
--   Bulk processing functions for nm3eng_dynseg package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
/* History
  17.09.07 PT First delivery with get_first_value(), get_last_value(), get_most_frequent_value()
                , get_median_value(), get_biased_standard_deviation() and get_biased_variance() unimplemented.
              The calls must be visible in the defining metadata, cannot use inside custom plsql functions.
              All foreign tables must be without nm_members.
  24.09.07 PT Implemented get_first_value() and get_last_value()
  05.10.07 PT in sql_get_value() added invisible call error flag so that the error is logged only once
              in populate_tmp_table() fixed the crashing when no dynseg calls in the asset setup
  08.10.07 PT in populate_tmp_table() added autonomous commit to ensure pk creation
  10.10.07 PT added append hint to temp table inserts
  11.10.07 PT fixed an upper-lower case problem in get_calls_tbl()
              sql%rowcount before commit
  17.10.07 PT removed autonomous transaction
  18.12.07 PT in populate_tmp_table() changed the handling of 0 length in getting nm_length_pct
  15.01.09 PT in sql_main_q1_wrap() added order by to fix an attribute order inconsitency when q1 is used. (Paul Sheedy)
  13.01.09 PT in populate_tmp_table() added join to group nm_members to get the cardinality for proper first / last order
                (this is pending a schema change to have the nm_cardinality added to nm_mrg_section_members
                  unitl then there is restriction that must not be null which means that
                  all section member datums must be mebmers of a linear route)
  25.01.09 PT in in populate_tmp_table() re-applied the checks to ensure the inv datum begin_mp and end_mp
                are adusted to not reach outside the result section; this has bearing in calculations that use section lengh
  02.09.09 PT in populate_tmp_table() fixed begin_mp/end_mp handling with negative cardinality
                  also added cardinality performance hint for section members
  02.11.09 PT log 722941, put being_mp, end_mp back into the sql in populate_tmp_table(), needed by first_value(), last_value()
*/


  g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.12  $"';
  g_package_name    CONSTANT  varchar2(30)   := 'nm3eng_dynseg_util';
  
  cr            constant varchar2(1) := chr(10);
  
  mt_sql        nm_dynseg_sql_tbl;            
  m_inv_type    nm_inv_types_all.nit_inv_type%type;
  m_invisible_call  boolean := false;
  
  type          iit_column_type is record (
     col_name   varchar2(30)
    ,data_type  varchar2(10)
  );
  type          iit_column_tbl is table of iit_column_type index by varchar2(40);
  
  
  -- cache for derived assets
  --  these are set by the nm3inv_composite2
  --  and read by the nm3eng_dynseg
  m_context_mrg_job_id  number(9);
  m_context_inv_type    varchar2(4);
  mt_iit_cols           iit_column_tbl;


  --
  -----------------------------------------------------------------------------
  --
  function get_version return varchar2
  is
  begin
     return g_sccsid;
  end;
  --
  -----------------------------------------------------------------------------
  --
  function get_body_version return varchar2
  is
  begin
     return g_body_sccsid;
  end;
  
  

  function sql_iit_invtypes_list(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2;
  
  
  function sql_all_alias_list(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2;
  
  function sql_all_iit_attrib_list(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2;

  function sql_ft_tables(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2;
  
  function call_func_code(
     p_call_func in varchar2
  ) return varchar2;  
  
  function sql_main_q_where(
     p_inv_type in varchar2
    ,p_call_func in varchar2
    ,p_has_xsp in varchar2
    ,p_has_value in varchar2
  ) return varchar2;
  
  function sql_main_q_values(
     p_inv_type in varchar2
    ,p_call_func in varchar2
    ,p_has_xsp in varchar2
  ) return varchar2;
  
  function sql_main_call(
     p_inv_type   in varchar2         -- derived asset invtype
    ,p_call_func in varchar2          -- full function name
    ,p_has_xsp in varchar2            -- Y | N
    ,p_value_iit_attrib in varchar2   -- in value calls the iit attribute that is been valued
  ) return varchar2;
  
  
  function sql_main_calls(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2;
  
  
  function sql_main_q1_wrap(
     p_main_q_sql in varchar2
    ,p_inv_type in varchar2
    ,p_func_code in varchar2
    ,p_has_xsp in varchar2
  ) return varchar2;
  
  
  function sql_get_value(
     p_func_code      in varchar2
    ,p_mrg_section_id in nm_mrg_sections_all.nms_mrg_section_id%type
    ,p_inv_type       in nm_inv_types.nit_inv_type%type
    ,p_xsp            in out nm_mrg_section_inv_values_all.nsv_x_sect%type
    ,p_call_attrib    in out varchar2
    ,p_call_value     in out varchar2
  ) return varchar2;
  
  
  ---------------------
  -- IMPLEMENTATIONS --
  ---------------------
  
  -- this returns the all values build metadata table
  --  the table is cached for repeat calls
  function get_sql_build_tbl(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  ) return nm_dynseg_sql_tbl
  is
  begin
    if m_inv_type = p_inv_type then
      null;
      
    else
      select nm_dynseg_sql_type(
         c.function_name
        ,c.inv_type
        ,c.xsp
        ,c.column_name
        ,c.value
        ,c.nit_table_name
        ,c.ita_attrib_name
        ,nvl2(c.nit_table_name, mm.iit_attrib_name, c.ita_attrib_name)
        ,c.ita_format)
      bulk collect into
         mt_sql
      from
      (
      select /*+ cardinality(x, 20) */ distinct
         x.*
        ,t.nit_table_name
        ,ta.ita_attrib_name
        ,ta.ita_format
      from
         table(cast(nm3eng_dynseg_util.get_calls_tbl(p_inv_type) as nm_dynseg_call_tbl)) x
        ,nm_inv_types_all t
        ,nm_inv_type_attribs ta
      where x.inv_type = t.nit_inv_type
        and x.inv_type = ta.ita_inv_type (+)
        and x.column_name = ta.ita_view_col_name (+)
      order by x.function_name, x.inv_type, x.xsp, x.column_name, x.value
      ) c
      , v_nm_ft_attribute_mapping mm
      where c.inv_type = mm.ita_inv_type (+)
        and c.nit_table_name = mm.nit_table_name (+)
        and c.ita_attrib_name = mm.ita_attrib_name (+);
        
      m_inv_type := p_inv_type;
        
    end if;
  
    return mt_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_sql_build_tbl('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
      
  end;
  
  
  -- this parses the derived asset invtype setup to be selected as sql table
  function get_calls_tbl(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return nm_dynseg_call_tbl
  is
    t_ret nm_dynseg_call_tbl := new nm_dynseg_call_tbl();
    l_dynseg        constant varchar2(30)   := 'nm3eng_dynseg.';
    i_dynseg_length constant binary_integer := length(l_dynseg);
    i_start         binary_integer := 0;
    i_left_br       binary_integer;
    i_right_br      binary_integer;
    l_call          varchar2(200);
    t               nm_code_tbl;
    
  begin
    for r in (
      select d.nmid_derivation
      from nm_mrg_ita_derivation d
      where d.nmid_ita_inv_type = p_inv_type
        and nvl(instr(lower(d.nmid_derivation), 'nm3eng_dynseg.'), 0) > 0
    )
    loop
      
      loop
        i_start := nvl(instr(lower(r.nmid_derivation), l_dynseg, i_start + 1), 0);
        exit when i_start = 0;
        
        i_right_br  := instr(r.nmid_derivation, ')', i_start);
        l_call := substr(r.nmid_derivation
          , i_start + i_dynseg_length
          , i_right_br - i_start - i_dynseg_length
        );
        l_call := translate(l_call, '('||chr(39), ',');
        nm3sql.split_code_tbl(
           p_tbl    => t
          ,p_string => l_call
          ,p_delim  => ','
        );
        t_ret.extend;
        
        -- get_value_existance is same as get_value_count > 0
        if lower(trim(t(1))) in (
           'get_value_existance'
          ,'does_value_exist'
        )
        then
          t(1) := 'get_value_count';
        end if;
        
        -- functions with p_value argument
        if lower(trim(t(1))) = 'get_value_count' then
          if t.exists(7) then
            t_ret(t_ret.last) := 
              new nm_dynseg_call_type(trim(t(1)), trim(t(4)), trim(t(5)), trim(t(6)), t(7));
          else
            t_ret(t_ret.last) := 
              new nm_dynseg_call_type(trim(t(1)), trim(t(4)), null, trim(t(5)), t(6));
          end if;
        
        -- functions without p_value argument
        else
          if t.exists(6) then
            t_ret(t_ret.last) := 
              new nm_dynseg_call_type(trim(t(1)), trim(t(4)), trim(t(5)), trim(t(6)), null);
          else
            t_ret(t_ret.last) := 
              new nm_dynseg_call_type(trim(t(1)), trim(t(4)), null, trim(t(5)), null);
          end if;
        end if;
        
        i_start := i_start + 1;
      end loop;
      
    end loop;
    
    return t_ret;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_calls_tbl('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
      
  end;
  
  
  
  -- this translates the verbose dynseg function name into a short code
  --  where possible it mathces the oracle function used
  function call_func_code(
     p_call_func in varchar2
  ) return varchar2
  is
  begin
    
    -- the unimplemented ones
    if p_call_func in (
       'get_most_frequent_value'        -- to be implemented
      ,'get_median_value'               -- to be implemented
      ,'get_biased_standard_deviation'  -- logic not known
      ,'get_biased_variance'            -- logic not known
    )
    then 
      raise_application_error(-20099,
         'Function not implemented for derived assets bulk processing.');
    end if;
    
  
    -- the main case stement
    case p_call_func
    when 'get_length_weighted_ave'  then return 'lwa';    -- custom                         g_stat_array.nsa_y_weighted_ave_x
    when 'get_maximum_value'        then return 'max';    -- max()                          g_stat_array.nsa_max_x
    when 'get_minimum_value'        then return 'min';    -- min()                          g_stat_array.nsa_min_x
    when 'get_most_common_value'    then return 'mcv';    -- custom                         g_val_dist_arr.nvda_highest_pct (longest by length)
    when 'get_first_value'          then return 'first';  -- first_vaulue(by mesure, begin_mp desc) g_stat_array.nsa_first_x (by network connectivity)
    when 'get_last_value'           then return 'last';   -- first_vaulue(by mesure desc, end_mp desc) g_stat_array.nsa_last_x  (by network connectivity)
    when 'get_value_count'          then return 'count';  -- count() group by value         l_val_dist.nvd_item_count (loop and find)
    when 'get_sum'                  then return 'sum';    -- sum()                          g_stat_array.nsa_sum_x
    when 'get_most_frequent_value'  then return 'mfv';    -- first_value() order by count() desc   g_val_dist_arr.nvda_most_numerous (highest count)
    --
    when 'get_median_value'             then return 'median';   -- min(abs((row_num - avg(row_num)))   in the middle on order by
    when 'get_mean_value'               then return 'avg';      -- avg()    average
    when 'get_variance'                 then return 'variance'; -- variance()    variance
    when 'get_standard_deviation'       then return 'stddev';   -- stdev()  standard deviation
    when 'get_biased_standard_deviation' then return 'bstddev'; -- not implemented 
    when 'get_biased_variance'          then return 'bvariance';-- not implemented 
    --
    --when 'get_value_existance'            get_value_count is used
    --
    --when 'get_most_frequent_value_dets'   -- array
    --when 'get_most_common_value_dets'     -- array
    --when 'get_value_distributions'        -- array
    --when 'does_value_exist'               -- boolean  get_value_count is used
    --
    else
      raise subscript_outside_limit;
      
    end case;
      
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.call_func_code('
        ||'p_call_func='||p_call_func
        ||')');
      raise;
    
  end;
  

  
  
  -- this populates the temporarty results table
  --  this is the main data source for quick lookups later
  -- autonomous commit to ensure pk creation
  procedure populate_tmp_table(
     p_mrg_job_id in nm_mrg_query_results_all.nqr_mrg_job_id%type
    ,p_inv_type in nm_inv_types.nit_inv_type%type
    ,p_sqlcount out integer
  )
  is
    l_sql                   varchar2(32767);
    l_sql_iit_invtypes_list varchar2(1000);
    l_sql_iit_table         varchar2(1000);
    l_sql_all_alias_list    varchar2(4000);
    l_sql_ft_tables         varchar2(32767);
    l_sql_main_calls        varchar2(32767);
    l_iit_ft_union          varchar2(20);
    l_sm_cardinality        pls_integer;
    
  begin
    nm3dbg.putln(g_package_name||'.populate_tmp_table('
      ||'p_mrg_job_id='||p_mrg_job_id
      ||', p_inv_type='||p_inv_type
      ||')');
    nm3dbg.ind;
    
    if p_mrg_job_id is null or p_inv_type is null then
      raise_application_error(-20101, 'Invalid call parameter');
    end if;
    
    
    l_sql_all_alias_list  := sql_all_alias_list(p_inv_type);
    
    l_sql_iit_invtypes_list := sql_iit_invtypes_list(p_inv_type);
    if l_sql_iit_invtypes_list is not null then
      l_sql_iit_table := 
        cr||'select i.iit_ne_id, i.iit_x_sect, i.iit_inv_type inv_type'
      ||cr||l_sql_all_alias_list
      ||cr||'from nm_inv_items i'
      ||cr||'where i.iit_inv_type in ('||l_sql_iit_invtypes_list||')';
    end if;
    
    l_sql_ft_tables   := sql_ft_tables(p_inv_type);
    
    if l_sql_iit_table is not null and l_sql_ft_tables is not null then
      l_iit_ft_union := cr||'union all';
    end if;
    
    
    execute immediate 'truncate table nm_eng_dynseg_values_tmp';
    
    
    -- if no dynseg calls then exit early
    if l_sql_iit_table is null and l_sql_ft_tables is null then
      nm3dbg.putln('no dynseg calls');
      nm3dbg.deind;
      p_sqlcount := 0;
      return;
      
    end if;
    
    
    -- let optimizer know the section members count
    -- low count avoids full scan on nm_members_all
    select nm3sql.get_rounded_cardinality(qr.nqr_mrg_section_members_count)
    into l_sm_cardinality
    from nm_mrg_query_results_all qr
    where qr.nqr_mrg_job_id = p_mrg_job_id;
    nm3dbg.putln('l_sm_cardinality='||l_sm_cardinality);
    
  
    l_sql := 
          'select q2.*'
    ||cr||'from ('
    ||cr||'with q as ('
    ||cr||'select'
    ||cr||'   qm.section_id'
    ||cr||'  ,qm.nm_ne_id_in'
    ||cr||'  ,qm.nm_ne_id_of'
    ||cr||'  ,qm.nm_obj_type'
    --||cr||'  ,qm.nm_length / decode(nvl(qm.section_length, 0), 0, 1, qm.section_length) nm_length_pct'
    -- assuming section_length cannot be 0 if nm_length is > 0
    ||cr||'  ,decode(qm.nm_length, 0, null, qm.nm_length / qm.section_length) nm_length_pct'
    ||cr||'  ,qm.nsm_measure'
    ||cr||'  ,qm.begin_mp'
    ||cr||'  ,qm.end_mp'
    ||cr||'  ,im.*'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'   mm2.section_id'
    ||cr||'  ,mm2.nm_ne_id_in'
    ||cr||'  ,mm2.nm_ne_id_of'
    ||cr||'  ,mm2.nm_obj_type'
    ||cr||'  ,mm2.nm_length'
    ||cr||'  ,sum((mm2.max_mp_end - mm2.min_mp_begin) * mm2.row_num) over (partition by mm2.section_id) section_length'
    ||cr||'  ,mm2.nsm_measure'
    ||cr||'  ,mm2.begin_mp'
    ||cr||'  ,mm2.end_mp'
    ||cr||'from ('
    ||cr||'select mm.*'
    ||cr||'  ,mm.end_mp - mm.begin_mp nm_length'
    ||cr||'  ,min(mm.begin_mp) over (partition by mm.section_id, mm.nm_ne_id_of) min_mp_begin'
    ||cr||'  ,max(mm.end_mp) over (partition by mm.section_id, mm.nm_ne_id_of) max_mp_end'
    ||cr||'  ,decode(row_number() over (partition by mm.section_id, mm.nm_ne_id_of order by 1), 1, 1, 0) row_num'
    ||cr||'from ('
    ||cr||'select /*+ cardinality(sm '||l_sm_cardinality||') */ distinct'
    ||cr||'   sm.nsm_mrg_section_id section_id'
    ||cr||'  ,m.nm_ne_id_in'
    ||cr||'  ,m.nm_ne_id_of'
    ||cr||'  ,m.nm_obj_type'
    --||cr||'  ,decode(m2.nm_cardinality, -1, sm.nsm_measure - least(m.nm_end_mp, sm.nsm_end_mp), greatest(m.nm_begin_mp, sm.nsm_begin_mp)) begin_mp'
    --||cr||'  ,decode(m2.nm_cardinality, -1, sm.nsm_measure - greatest(m.nm_begin_mp, sm.nsm_begin_mp), least(m.nm_end_mp, sm.nsm_end_mp)) end_mp'
    ||cr||'  ,decode(m2.nm_cardinality, -1, e.ne_length - least(m.nm_end_mp, sm.nsm_end_mp), greatest(m.nm_begin_mp, sm.nsm_begin_mp)) begin_mp'
    ||cr||'  ,decode(m2.nm_cardinality, -1, e.ne_length - greatest(m.nm_begin_mp, sm.nsm_begin_mp), least(m.nm_end_mp, sm.nsm_end_mp)) end_mp'
    ||cr||'  ,sm.nsm_measure'
    ||cr||'from'
    ||cr||'   nm_mrg_section_members sm'
    ||cr||'  ,nm_mrg_sections_all s'
    ||cr||'  ,nm_members m'
    ||cr||'  ,nm_members m2'
    ||cr||'  ,nm_elements_all e'
    ||cr||'where sm.nsm_mrg_job_id = s.nms_mrg_job_id'
    ||cr||'  and sm.nsm_mrg_section_id = s.nms_mrg_section_id'
    ||cr||'  and sm.nsm_ne_id = m.nm_ne_id_of'
    ||cr||'  and sm.nsm_ne_id = m2.nm_ne_id_of'
    ||cr||'  and s.nms_offset_ne_id = m2.nm_ne_id_in'
    ||cr||'  and sm.nsm_ne_id = e.ne_id'
    ||cr||'  and m.nm_end_mp >= sm.nsm_begin_mp and m.nm_begin_mp <= sm.nsm_end_mp'
    ||cr||'  and not (m.nm_end_mp = sm.nsm_begin_mp and m.nm_begin_mp < sm.nsm_begin_mp)'
    ||cr||'  and not (m.nm_begin_mp = sm.nsm_end_mp and m.nm_end_mp > sm.nsm_end_mp)'
    ||cr||'  and m.nm_type = ''I'''
    ||cr||'  and sm.nsm_mrg_job_id = :p_mrg_job_id'
    ||cr||') mm'
    ||cr||') mm2'
    ||cr||') qm'
    ||cr||', ('
        ||l_sql_iit_table
        ||l_iit_ft_union
        ||l_sql_ft_tables
    ||cr||') im'
    ||cr||'where qm.nm_ne_id_in = im.iit_ne_id'
    ||cr||')'
        ||sql_main_calls(p_inv_type)
    ||cr||') q2'
    ||cr||'order by q2.section_id, q2.operation, q2.inv_type';

    
    l_sql := 
          'insert /*+ append */ into nm_eng_dynseg_values_tmp ('
    ||cr||'  grp_operation, grp_section_id, grp_inv_type, grp_xsp, grp_value_column, grp_value'
    ||cr||sql_all_iit_attrib_list(p_inv_type)
    ||cr||')'
    ||cr||l_sql;
    
    nm3dbg.putln(l_sql);
    
    execute immediate l_sql
      using p_mrg_job_id;
    p_sqlcount := sql%rowcount;
    commit;
    
    nm3dbg.putln('nm_eng_dynseg_values_tmp count:'||p_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.populate_tmp_table('
        ||'p_mrg_job_id='||p_mrg_job_id
        ||', p_inv_type='||p_inv_type
        ||')');
      raise;
      
  end;
  
  
 
  -- union alled list of call sql that uses the inline with select
  --  this is used to build sql to populate the temp table
  function sql_main_calls(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2
  is
    l_sql               varchar2(32767);
    l_comma             varchar2(1);
    l_union_all         varchar2(20);
    
  begin
    nm3dbg.putln(g_package_name||'.sql_main_calls('
      ||'p_inv_type='||p_inv_type
      ||')');
    nm3dbg.ind;
    
    
    -- a loop of distinc union all calls we have
    for r in (
      select distinct
         x.call_func
        ,nvl2(x.call_xsp, 'Y', 'N') has_xsp
        ,nvl2(x.call_value, 'Y', 'N') has_value
      from table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
      order by 1, 2, 3
    )
    loop
      
      -- value call. we must create a separte select for each attribute involved
      if r.has_value = 'Y' then
        
        
        for r2 in (
          select distinct x.iit_attrib
          from table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
          where x.call_func = r.call_func
            and x.call_value is not null
          order by 1
        )
        loop
          l_sql := l_sql||l_union_all
          ||cr||sql_main_call(
                   p_inv_type         => p_inv_type      
                  ,p_call_func        => r.call_func
                  ,p_has_xsp          => r.has_xsp  
                  ,p_value_iit_attrib => r2.iit_attrib
                );
        
          l_union_all := cr||'union all';
        end loop;
        
        
      -- non value call, one standard select
      else
        l_sql := l_sql||l_union_all
        ||cr||sql_main_call(
                 p_inv_type         => p_inv_type      
                ,p_call_func        => r.call_func
                ,p_has_xsp          => r.has_xsp  
                ,p_value_iit_attrib => null
              );
        
      end if;


      l_union_all := cr||'union all';
    end loop;
    
    
    nm3dbg.deind;
    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_main_calls('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  
  -- one call in the union all list of value calls to populate the temp table
  --  there is one call per function-invtype-xsp-column-value combination as parsed from the derived invtype setup
  function sql_main_call(
     p_inv_type   in varchar2         -- derived asset invtype
    ,p_call_func in varchar2          -- full function name
    ,p_has_xsp in varchar2            -- Y | N
    ,p_value_iit_attrib in varchar2   -- in value calls the iit attribute that is been valued, if null same as p_has_value = 'N'
  ) return varchar2
  is
    l_sql               varchar2(10000);
    l_sql_func_code     constant nm_eng_dynseg_values_tmp.grp_operation%type := call_func_code(p_call_func);
    l_sql_xsp           varchar2(20);
    l_sql_value_column  varchar2(50);
    l_sql_value         varchar2(40);
    l_sql_group_by      varchar2(200);
    l_has_value         varchar2(1);
    
  begin
    nm3dbg.putln(g_package_name||'.sql_main_call('
      ||'p_inv_type='||p_inv_type
      ||', p_call_func='||p_call_func
      ||', p_has_xsp='||p_has_xsp
      ||', p_value_iit_attrib='||p_value_iit_attrib
      ||')');
    nm3dbg.ind;
    
    l_sql_group_by := 'group by'
    ||cr||'   q.section_id'
    ||cr||'  ,q.inv_type';
  
    if p_has_xsp = 'Y' then
      l_sql_xsp := 'q.iit_x_sect';
      l_sql_group_by := l_sql_group_by
      ||cr||'  ,q.iit_x_sect';
      
    else
      l_sql_xsp := '''#'' iit_x_sect';
      
    end if;
    
    if p_value_iit_attrib is not null then
      l_sql_value_column  := ''''||p_value_iit_attrib||''' value_column';
      l_sql_value         := 'to_char(q.'||replace(p_value_iit_attrib, '_ATTRIB')||') value';
      l_sql_group_by      := l_sql_group_by
                          ||cr||'  ,q.'||replace(p_value_iit_attrib, '_ATTRIB');
      l_has_value := 'Y';
      
    else
      l_sql_value_column  := '''#'' value_column';
      l_sql_value         := '''#'' value';
      l_has_value         := 'N';
      
    end if;
    
    
    -- the calls with q1 wrapper don't need the group by in q
    if l_sql_func_code in (
       'mcv'
      ,'first'
      ,'last'
    )
    then
      l_sql_group_by := null;
      
    else
      l_sql_group_by := cr||l_sql_group_by;
      
    end if;
    
    
    -- q select
    l_sql := 'select'
    ||cr||'   '''||l_sql_func_code||''' operation'
    ||cr||'  ,q.section_id'
    ||cr||'  ,q.inv_type'
    ||cr||'  ,'||l_sql_xsp
    ||cr||'  ,'||l_sql_value_column
    ||cr||'  ,'||l_sql_value
        ||sql_main_q_values(
             p_inv_type   => p_inv_type
            ,p_call_func  => p_call_func
            ,p_has_xsp    => p_has_xsp
          )
    ||cr||'from q'
    ||cr||sql_main_q_where(
             p_inv_type   => p_inv_type
            ,p_call_func  => p_call_func
            ,p_has_xsp    => p_has_xsp
            ,p_has_value  => l_has_value
          )
        ||l_sql_group_by;
    
    
    
    -- apply the outer q1 wrapper where needed
    --  most_common_value(), most_frequent_value()
    if l_sql_func_code in (
       'mcv'
      ,'first'
      ,'last'
    )
    then
      l_sql := sql_main_q1_wrap(
         p_main_q_sql => l_sql
        ,p_inv_type   => p_inv_type
        ,p_func_code  => l_sql_func_code
        ,p_has_xsp    => p_has_xsp
      );

    end if;
    
    
    nm3dbg.deind;
    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_main_call('
        ||'p_inv_type='||p_inv_type
        ||', p_call_func='||p_call_func
        ||', p_has_xsp='||p_has_xsp
        ||', p_value_iit_attrib='||p_value_iit_attrib
        ||', l_sql_func_code='||l_sql_func_code
        ||', l_sql_xsp='||l_sql_xsp
        ||', l_sql_value_column='||l_sql_value_column
        ||', l_sql_value='||l_sql_value
        ||', l_sql_group_by='||l_sql_group_by
        ||')');
      raise;
    
  end;
  
  
  
  
  -- A little utility to format litterals in sql
  function formatted_value_literal(
     p_value in varchar2
    ,p_format in varchar2
  ) return varchar2
  is
  begin
    case p_format
    when 'VARCHAR2' then
      return ''''||p_value||'''';
    when 'NUMBER' then
      return p_value;
    when 'DATE' then
      --return 'to_date('||p_value||', ''YYYYMMDD'')';
      raise_application_error(-20099, g_package_name||': Litteral date values not supported in calls.');
    else
      raise subscript_outside_limit;
    end case;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.formatted_value_literal('
        ||'p_value='||p_value
        ||', p_format='||p_format
        ||')');
      raise;
  end;
  
  
  
  -- this wraps the base q select into a wrapper for some main call functions
  function sql_main_q1_wrap(
     p_main_q_sql in varchar2
    ,p_inv_type in varchar2
    ,p_func_code in varchar2
    ,p_has_xsp in varchar2
  ) return varchar2
  is
    l_sql           varchar2(4000);
    l_sql_list      varchar2(1000);
    l_sql_group     varchar2(100);
    l_sql_list_xsp  varchar2(20);
    l_sql_group_xsp varchar2(20);
    l_sql_values    varchar2(1000);
    
  begin
--     nm3dbg.putln(g_package_name||'.sql_main_q1_wrap('
--         ||'  p_inv_type='||p_inv_type
--         ||', p_func_code='||p_func_code
--         ||', p_has_xsp='||p_has_xsp
--       ||')');
    
    -- build the calculated values list
    for r in (
      select distinct
         replace(x.iit_attrib, '_ATTRIB') alias
        ,x.ita_format
      from
         table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
      order by 1
    )
    loop
      -- most common value
      if p_func_code in (
         'mcv'
        ,'first'
        ,'last'
      )   
      then
        l_sql_values := l_sql_values||', min(q1.'||r.alias||') '||r.alias;
        
        
      -- most frequent value
      elsif p_func_code = 'mfv' then
        null; -- not yet implemented
        
      -- most frequent value
      elsif p_func_code = 'median' then
        null; -- not yet implemented
        
      else
        raise subscript_outside_limit;
        
      end if;
      
    end loop;
    
    
    -- list and group by xsp
    if p_has_xsp = 'Y' then
      l_sql_list_xsp  := '  ,q1.iit_x_sect';
      l_sql_group_xsp := cr||'  ,q1.iit_x_sect';
    
    else
      l_sql_list_xsp  := '  ,''#'' iit_x_sect';
      
    end if;
        
    return  'select'
      ||cr||'   q1.operation'
      ||cr||'  ,q1.section_id'
      ||cr||'  ,q1.inv_type'
      ||cr||l_sql_list_xsp
      ||cr||'  ,''#'' value_column'
      ||cr||'  ,''#'' value'
      ||cr||'  '||l_sql_values
      ||cr||'from ('
      ||cr||p_main_q_sql
      ||cr||') q1'
      ||cr||'group by'
      ||cr||'   q1.operation'
      ||cr||'  ,q1.section_id'
      ||cr||'  ,q1.inv_type'
          ||l_sql_group_xsp;
        
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_main_q1_wrap('
        ||'p_main_q_sql='||p_main_q_sql
        ||', p_inv_type='||p_inv_type
        ||', p_func_code='||p_func_code
        ||', p_has_xsp='||p_has_xsp
        ||')');
      raise;
        
  end;

  
  
  
  -- this gives the list of value columns for the first ( q ) select
  --  with some functions a second ( q1 ) wrapper is added
  function sql_main_q_values(
     p_inv_type in varchar2
    ,p_call_func in varchar2
    ,p_has_xsp in varchar2
  ) return varchar2
  is
    l_sql       varchar2(4000);
    l_sql_list  varchar2(1000);
    l_func_code nm_eng_dynseg_values_tmp.grp_operation%type;
    cursor c_attr is
      select
         x2.alias
        ,x2.ita_format
        ,nvl2(x3.iit_attrib, 'Y', 'N') is_used
      from
         (
          select distinct
             x.iit_attrib
            ,replace(x.iit_attrib, '_ATTRIB') alias
            ,x.ita_format
          from
             table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
         ) x2
        ,(
          select distinct
             x.iit_attrib
          from  
             table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
          where x.call_func = p_call_func
         ) x3
      where x2.iit_attrib = x3.iit_attrib (+)
      order by 1;
    l_alias       varchar2(30);
    l_data_type   varchar2(10);
    l_is_used     varchar2(1);
    l_sql_x_sect  varchar2(20);
    l_value       varchar2(200);
    l_last_value_short boolean := false;
    l_curr_value_short boolean := false;
      
  
  begin
--     nm3dbg.putln(g_package_name||'.sql_main_q_values('
--       ||'p_inv_type='||p_inv_type
--       ||', p_call_func='||p_call_func
--       ||', p_has_xsp='||p_has_xsp
--       ||')');
    
    l_func_code := call_func_code(p_call_func);
    
    if p_has_xsp = 'Y' then
      l_sql_x_sect := ', q.iit_x_sect';
    end if;
    
    
    open c_attr;
    loop
      fetch c_attr into l_alias, l_data_type, l_is_used;
      exit when c_attr%notfound;
      
      l_curr_value_short := false;
      
      -- column used, select value
      if l_is_used = 'Y' then
        case
        
        -- standard oracle any function
        when l_func_code in ('max','min') then
          l_value := l_func_code||'(q.'||l_alias||')';
          l_curr_value_short := true;
          
        
        -- standard oracle any function result is number
        when l_func_code = 'count' then
          if l_data_type = 'VARCHAR2' then
            l_value := 'to_char(count(q.'||l_alias||'))';
          elsif l_data_type = 'DATE' then
            l_value := 'to_date((count(q.'||l_alias||'), ''J'')';
          end if;
          l_curr_value_short := true;
          
        
        -- standard oracle number function 
        when l_func_code in ('sum','avg','stdev','variance') then
          if l_data_type = 'NUMBER' then
            l_value := l_func_code||'(q.'||l_alias||')';
          else
            l_value := nm3sql.null_literal(l_data_type);
          end if;
          l_curr_value_short := true;
        
        
        -- length weighted average
        when l_func_code = 'lwa' then
          if l_data_type = 'NUMBER' then
            l_value := 'sum(q.'||l_alias||' * q.nm_length_pct) / sum(q.nm_length_pct)';
          
          else
            l_value := nm3sql.null_literal(l_data_type);
            l_curr_value_short := true;
          
          end if;
          
          
        -- most common value
        when l_func_code = 'mcv' then
          l_value := 'first_value(q.'||l_alias
            ||') over (partition by q.section_id, q.inv_type'||l_sql_x_sect||' order by q.nm_length_pct desc)';
          
          
        -- first value
        when l_func_code = 'first' then
          l_value := 'first_value(q.'||l_alias
            ||') over (partition by q.section_id, q.inv_type'||l_sql_x_sect||' order by q.nsm_measure, q.begin_mp)';
            
            
        -- last value
        when l_func_code = 'last' then
          l_value := 'first_value(q.'||l_alias
            ||') over (partition by q.section_id, q.inv_type'||l_sql_x_sect||' order by q.nsm_measure desc, q.end_mp desc)';
            
              
        -- median (order by middle)
        --when l_func_code = 'median' then
        --  null;
          
          
        else
          raise subscript_outside_limit;
        
        end case;
      
      
      -- column not used, select null
      else
        l_value := nm3sql.null_literal(l_data_type);
        l_curr_value_short := true;
        
      end if;
      
      
      -- add the value to the list of selected calculation values
      if l_curr_value_short and l_last_value_short then
        l_sql := l_sql||', '||l_value||' '||l_alias;
        
      else
        l_sql := l_sql||cr||'  ,'||l_value||' '||l_alias;
      end if;
      
      
      l_last_value_short := l_curr_value_short;
      
    end loop;
    close c_attr;
    

    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_main_q_values('
        ||'p_inv_type='||p_inv_type
        ||', p_call_func='||p_call_func
        ||', p_has_xsp='||p_has_xsp
        ||', l_func_code='||l_func_code
        ||', l_alias='||l_alias
        ||', l_data_type='||l_data_type
        ||', l_is_used='||l_is_used
        ||', l_sql_x_sect='||l_sql_x_sect
        ||', l_value='||l_value
        ||')');
      raise;
    
  end;
  
  
  
  
  
  -- this gives the where clause of one main analytic union all select
  function sql_main_q_where(
     p_inv_type in varchar2
    ,p_call_func in varchar2
    ,p_has_xsp in varchar2
    ,p_has_value in varchar2
  ) return varchar2
  is
    l_sql       varchar2(4000);
    l_sql_list  varchar2(1000);
    l_tmp       varchar2(1000);
    cur         sys_refcursor;
    l_comma     varchar2(1);
    l_or      varchar2(10);
  
  begin
--     nm3dbg.putln(g_package_name||'.sql_main_q_where('
--       ||'p_inv_type='||p_inv_type
--       ||', p_call_func='||p_call_func
--       ||', p_has_xsp='||p_has_xsp
--       ||', p_has_value='||p_has_value
--       ||')');
    
    -- loop through the combinations
    --  each combination becomes a distinct 'and' where clause
    
    -- a simple in() list of inv types
    if p_has_xsp = 'N' and p_has_value = 'N' then
      open cur for
        select distinct
           ''''||x.call_invtype||'''' inv_type_literal
        from
           table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
        where x.call_func = p_call_func
          and x.call_xsp is null
          and x.call_value is null
        order by 1;
        nm3sql.join_sys_refcursor(
           p_string => l_sql_list -- out
          ,p_cur    => cur
          ,p_delim  => ','
        );
      
      l_sql := 'q.inv_type in ('||l_sql_list||')';
      
      
      
    elsif p_has_xsp = 'Y' and p_has_value = 'N' then
      for r in (
        select distinct
            x.call_invtype inv_type
        from
           table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
        where x.call_func = p_call_func
          and x.call_xsp is not null
          and x.call_value is null
        order by 1
      )  
      loop
        open cur for
          select distinct
             ''''||x.call_xsp||'''' xsp_literal
          from
             table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
          where x.call_func = p_call_func
            and x.call_invtype = r.inv_type
            and x.call_xsp is not null
            and x.call_value is null
          order by 1;
          nm3sql.join_sys_refcursor(
             p_string => l_sql_list -- out
            ,p_cur    => cur
            ,p_delim  => ','
          );
      
        l_sql := l_sql
            ||l_or||'(q.inv_type = '''||r.inv_type||''''
                  ||' and q.iit_x_sect in ('||l_sql_list||'))';
        l_or := cr||'  or ';
        
      end loop;
      
      
    
    elsif p_has_xsp = 'Y' and p_has_value = 'Y' then
      for r in (
        select distinct
           x.call_invtype inv_type
          ,x.call_xsp xsp
          ,replace(x.iit_attrib, '_ATTRIB') alias
        from
           table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
        where x.call_func = p_call_func
          and x.call_xsp is not null
          and x.call_value is not null
        order by 1, 2, 3
      )  
      loop
        open cur for
          select distinct
             formatted_value_literal(x.call_value, x.ita_format) value_literal
          from
             table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
          where x.call_func = p_call_func
            and x.call_invtype = r.inv_type
            and x.call_xsp = r.xsp
            and x.call_value is not null
          order by 1;
          nm3sql.join_sys_refcursor(
             p_string => l_sql_list -- out
            ,p_cur    => cur
            ,p_delim  => ','
          );
      
        l_sql := l_sql
          ||l_or||'(q.inv_type = '''||r.inv_type||''''
                ||' and q.iit_x_sect = '''||r.xsp||''''
                ||' and q.'||r.alias||' in ('||l_sql_list||'))';
        l_or := cr||'  or ';
        
      end loop;
      

    elsif p_has_xsp = 'N' and p_has_value = 'Y' then
      for r in (
        select distinct
           x.call_invtype inv_type
          ,replace(x.iit_attrib, '_ATTRIB') alias
        from
           table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
        where x.call_func = p_call_func
          and x.call_xsp is null
          and x.call_value is not null
        order by 1, 2
      )  
      loop
        open cur for
          select distinct
             formatted_value_literal(x.call_value, x.ita_format) value_literal
          from
             table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
          where x.call_func = p_call_func
            and x.call_invtype = r.inv_type
            and x.call_xsp is null
            and x.call_value is not null
          order by 1;
          nm3sql.join_sys_refcursor(
             p_string => l_sql_list -- out
            ,p_cur    => cur
            ,p_delim  => ','
          );
          
        l_sql := l_sql
          ||l_or||'(q.inv_type = '''||r.inv_type||''''
                ||' and q.iit_x_sect is null'
                ||' and q.'||r.alias||' in ('||l_sql_list||'))';
        l_or := cr||'  or ';
        
      end loop;
      
    end if;
      
    return 'where '||l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_main_q_where('
        ||'p_inv_type='||p_inv_type
        ||', p_call_func='||p_call_func
        ||', p_has_xsp='||p_has_xsp
        ||', p_has_value='||p_has_value
        ||')');
      raise;
    
  end;
  
  
  
  
  -- comma delimited list of nm_inv_items_all inv_types
  function sql_iit_invtypes_list(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2
  is
    l_sql   varchar2(1000);
    l_comma varchar2(1);
    
  begin
    for r in (
      select distinct ''''||x.call_invtype||'''' inv_type
      from table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
      where x.nit_table is null
      order by 1
    )
    loop
      l_sql := l_sql||l_comma||r.inv_type;
      l_comma := ',';
      
    end loop;
    
    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_iit_invtypes_list('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  

  
  -- comma limited all destination iit_ aliases used
  function sql_all_alias_list(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2
  is
    l_sql   varchar2(4000);
    l_comma varchar2(1);
    
  begin
    for r in (
      select distinct
         x.iit_attrib attr
        ,replace(x.iit_attrib, '_ATTRIB') alias
      from table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
      order by 1
    )
    loop
      l_sql := l_sql||', i.'||r.attr||' '||r.alias;
      
    end loop;
    
    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_all_alias_list('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  
  
  -- comma limited all destination iit_ attributes used
  function sql_all_iit_attrib_list(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2
  is
    l_sql   varchar2(4000);
    l_comma varchar2(1);
    
  begin
    for r in (
      select distinct
         x.iit_attrib
      from table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
      order by 1
    )
    loop
      l_sql := l_sql||', '||r.iit_attrib;
      
    end loop;
    
    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_all_iit_attrib_list('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  
  
  -- union alled ft table selects; this is joined to the nm_inv_items select
  function sql_ft_tables(
     p_inv_type in nm_inv_types.nit_inv_type%type
  ) return varchar2
  is
    l_sql       varchar2(32767);
    l_sql_sel   varchar2(4000);
    l_comma     varchar2(2);
    l_union_all varchar2(20);
    l_fields    varchar2(4000);
    i_alias     pls_integer := 0;
    
    
  begin
    nm3dbg.putln(g_package_name||'.sql_ft_tables('
      ||'p_inv_type='||p_inv_type
      ||')');
    nm3dbg.ind;
  
    -- loop through the distinct list of ft invtypes
    for r in (
      select distinct 
         x.call_invtype inv_type
        ,t.nit_table_name
        --,t.nit_lr_ne_column_name
        ,t.nit_foreign_pk_column
      from
        table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
       ,nm_inv_types_all t
      where x.call_invtype = t.nit_inv_type
        and t.nit_table_name is not null
      order by 1
    )
    loop
      i_alias   := i_alias + 1;
      l_sql_sel := null;
      l_comma   := null;
    
      -- loop through the complete list of attributes
      --  that has all values needed to build the select
      for r2 in (
        select
           replace(x.iit_attrib, '_ATTRIB') alias
          ,x.ita_format data_type
          ,x2.ita_attrib ita_attrib
        from
           (select distinct iit_attrib, ita_format
            from table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl))
           ) x
          ,(select iit_attrib, ita_attrib
            from table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl))
            where call_invtype = r.inv_type
           ) x2
        where x.iit_attrib = x2.iit_attrib (+)
        order by 1
      )
      loop
        if r2.ita_attrib is not null then
          l_sql_sel := l_sql_sel||', '||r2.ita_attrib||' '||r2.alias;
        
        else
          case r2.data_type
          when 'VARCHAR2' then
            l_sql_sel := l_sql_sel||', null '||r2.alias;
          when 'NUMBER' then
            l_sql_sel := l_sql_sel||', to_number(null) '||r2.alias;
          when 'NUMBER' then
            l_sql_sel := l_sql_sel||', to_date(null) '||r2.alias;
          end case;
        
        end if;

        
      end loop; 
    
      l_sql := l_sql
          ||l_union_all
      ||cr||'select '||r.nit_foreign_pk_column||' iit_ne_id, null iit_x_sect, '''||r.inv_type||''' inv_type'
      ||cr||l_sql_sel
      ||cr||'from '||r.nit_table_name;
      
      l_union_all := cr||'union all';

    end loop;
    
    nm3dbg.deind;
    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_ft_tables('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  

  
  -- this is used by nm3eng_dynseg
  function get_num_value(
     p_call_func in varchar2
    ,p_mrg_section_id in nm_mrg_sections_all.nms_mrg_section_id%type
    ,p_inv_type in nm_inv_types.nit_inv_type%type
    ,p_xsp in nm_mrg_section_inv_values_all.nsv_x_sect%type
    ,p_call_attrib in varchar2
    ,p_call_value in varchar2
  ) return number
  is
    l_value   number;
    l_func    constant nm_eng_dynseg_values_tmp.grp_operation%type := call_func_code(p_call_func);
    l_xsp     nm_mrg_section_inv_values_all.nsv_x_sect%type := p_xsp;
    l_call_attrib  varchar2(30) := p_call_attrib;
    l_call_value   varchar2(50) := p_call_value;
    
  begin
    execute immediate 
      sql_get_value(
         p_func_code      => l_func
        ,p_mrg_section_id => p_mrg_section_id
        ,p_inv_type       => p_inv_type
        ,p_xsp            => l_xsp
        ,p_call_attrib    => l_call_attrib
        ,p_call_value     => l_call_value
      )
    into
      l_value
    using
       l_func
      ,p_mrg_section_id
      ,p_inv_type
      ,l_xsp
      ,l_call_attrib
      ,l_call_value;
      
    return l_value;
  exception
    when no_data_found then
--       nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_chr_value('
--         ||'p_call_func='||p_call_func
--         ||', p_mrg_section_id='||p_mrg_section_id
--         ||', p_inv_type='||p_inv_type
--         ||', l_func='||l_func
--         ||', l_xsp='||l_xsp
--         ||', l_call_attrib='||l_call_attrib
--         ||', l_call_value='||l_call_value
--         ||')');
      return null;
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_num_value('
        ||'p_call_func='||p_call_func
        ||', p_mrg_section_id='||p_mrg_section_id
        ||', p_inv_type='||p_inv_type
        ||', p_xsp='||p_xsp
        ||', p_call_attrib='||p_call_attrib
        ||', p_call_value='||p_call_value
        ||', l_func='||l_func
        ||', l_xsp='||l_xsp
        ||', l_call_attrib='||l_call_attrib
        ||', l_call_value='||l_call_value
        ||')');
      raise;
  end;
  
  
  -- this is used by nm3eng_dynseg
  function get_chr_value(
     p_call_func in varchar2
    ,p_mrg_section_id in nm_mrg_sections_all.nms_mrg_section_id%type
    ,p_inv_type in nm_inv_types.nit_inv_type%type
    ,p_xsp in nm_mrg_section_inv_values_all.nsv_x_sect%type
    ,p_call_attrib in varchar2
    ,p_call_value in varchar2
  ) return varchar2
  is
    l_value   varchar2(50);
    l_func    constant nm_eng_dynseg_values_tmp.grp_operation%type := call_func_code(p_call_func);
    l_xsp     nm_mrg_section_inv_values_all.nsv_x_sect%type := p_xsp;
    l_call_attrib  varchar2(30) := p_call_attrib;
    l_call_value   varchar2(50) := p_call_value;
    
  begin
--     nm3dbg.putln(g_package_name||'.get_chr_value('
--       ||'p_call_func='||p_call_func
--       ||', p_mrg_section_id='||p_mrg_section_id
--       ||', p_inv_type='||p_inv_type
--       ||', p_xsp='||p_xsp
--       ||', p_call_attrib='||p_call_attrib
--       ||', p_call_value='||p_call_value
--       ||')');
--     nm3dbg.ind;
    
    execute immediate 
      sql_get_value(
         p_func_code      => l_func
        ,p_mrg_section_id => p_mrg_section_id
        ,p_inv_type       => p_inv_type
        ,p_xsp            => l_xsp
        ,p_call_attrib    => l_call_attrib
        ,p_call_value     => l_call_value
      )
    into
      l_value
    using
       l_func
      ,p_mrg_section_id
      ,p_inv_type
      ,l_xsp
      ,l_call_attrib
      ,l_call_value;
      
    return l_value;
  exception
    when no_data_found then
--       nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_chr_value('
--         ||'p_call_func='||p_call_func
--         ||', p_mrg_section_id='||p_mrg_section_id
--         ||', p_inv_type='||p_inv_type
--         ||', l_func='||l_func
--         ||', l_xsp='||l_xsp
--         ||', l_call_attrib='||l_call_attrib
--         ||', l_call_value='||l_call_value
--         ||')');
      return null;
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_chr_value('
        ||'p_call_func='||p_call_func
        ||', p_mrg_section_id='||p_mrg_section_id
        ||', p_inv_type='||p_inv_type
        ||', p_xsp='||p_xsp
        ||', p_call_attrib='||p_call_attrib
        ||', p_call_value='||p_call_value
        ||', l_func='||l_func
        ||', l_xsp='||l_xsp
        ||', l_call_attrib='||l_call_attrib
        ||', l_call_value='||l_call_value
        ||')');
      raise;
  end;
  
  
  
  -- this loads the mapping of view_column attributes to the temp table iit_ attributes
  --  this must be loaded before staring to use the nm3eng_dynseg for lookups.
  procedure load_iit_mapping(
     p_inv_type in nm_inv_types.nit_inv_type%type
  )
  is
  begin
    nm3dbg.putln(g_package_name||'.load_iit_mapping('
      ||'p_inv_type='||p_inv_type
      ||')');
    nm3dbg.ind;
    
    mt_iit_cols.delete;
    
    for r in (
      select distinct x.call_invtype||' '||x.call_attrib idx, x.iit_attrib, x.ita_format
      from
      table(cast(nm3eng_dynseg_util.get_sql_build_tbl(p_inv_type) as nm_dynseg_sql_tbl)) x
    )
    loop
      mt_iit_cols(r.idx).col_name := r.iit_attrib;
      mt_iit_cols(r.idx).data_type := r.ita_format;
    end loop;
    
    nm3dbg.putln('mt_iit_cols.count='||mt_iit_cols.count);
  
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_iit_mapping('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
  end;
  
  
  
  -- this gives the sql for a quick select of one value form the preprocessing results temp table
  function sql_get_value(
     p_func_code      in varchar2
    ,p_mrg_section_id in nm_mrg_sections_all.nms_mrg_section_id%type
    ,p_inv_type       in nm_inv_types.nit_inv_type%type
    ,p_xsp            in out nm_mrg_section_inv_values_all.nsv_x_sect%type
    ,p_call_attrib    in out varchar2
    ,p_call_value     in out varchar2
  ) return varchar2
  is
    l_sql_column  varchar2(100);
    
  begin
    l_sql_column := mt_iit_cols(p_inv_type||' '||p_call_attrib).col_name;
    p_xsp := nvl(p_xsp, '#');
    p_call_value := nvl(p_call_value, '#');
    if p_func_code not in ('count') then
      p_call_attrib := '#';
    end if;
    
    
    nm3dbg.deind;
    return 
            'select '||l_sql_column
      ||cr||'from nm_eng_dynseg_values_tmp v'
      ||cr||'where v.grp_operation = :p_operation'
      ||cr||'  and v.grp_section_id = :p_section_id'
      ||cr||'  and v.grp_inv_type = :p_inv_type'
      ||cr||'  and v.grp_xsp = :p_xsp'
      ||cr||'  and v.grp_value_column = :p_value_column'
      ||cr||'  and v.grp_value = :p_value';
    
       
  exception
    -- invtype_column combination not found in mt_iit_cols
    when no_data_found then
      if m_invisible_call then
        nm3dbg.deind;
        return 
                'select null'
          ||cr||'from nm_eng_dynseg_values_tmp v'
          ||cr||'where v.grp_operation = :p_operation'
          ||cr||'  and v.grp_section_id = :p_section_id'
          ||cr||'  and v.grp_inv_type = :p_inv_type'
          ||cr||'  and v.grp_xsp = :p_xsp'
          ||cr||'  and v.grp_value_column = :p_value_column'
          ||cr||'  and v.grp_value = :p_value';
      else
        m_invisible_call := true;
        raise_application_error(-20010,
          'Invisible nm3eng_dynseg call');
      end if;
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_get_value('
        ||'p_func_code='||p_func_code
        ||', p_mrg_section_id='||p_mrg_section_id
        ||', p_inv_type='||p_inv_type
        ||', p_xsp='||p_xsp
        ||', p_call_attrib='||p_call_attrib
        ||', p_call_value='||p_call_value
        ||', p_func_code='||p_func_code
        ||', mt_iit_cols.count='||mt_iit_cols.count
        ||')');
      raise;
    
  end;
  
  
  
  -- this sets the mrg_job_id on what the temp preprocessing table has been loaded
  --  nm3eng_dynseg tests this value to see if it can use the quick lookups
  --  must be set before control is givent to nm3eng_dynseg
  procedure set_context_mrg_job_id(p_mrg_job_id in number)
  is
  begin
    nm3dbg.putln(g_package_name||'.set_context_mrg_job_id('
      ||'p_mrg_job_id='||p_mrg_job_id
      ||')');
    m_context_mrg_job_id := p_mrg_job_id;
  end;
  function get_context_mrg_job_id return number
  is
  begin
    return m_context_mrg_job_id;
  end;
  

  -- reset all cache
  --  call this at the end of dynseg processing
  procedure reset_cache
  is
    t_dummy   nm_dynseg_sql_tbl;
    t_dummy2  iit_column_tbl;
  begin
    nm3dbg.putln(g_package_name||'.reset_cache('
      ||')');
    mt_sql                := t_dummy;
    m_inv_type            := null;
    m_context_mrg_job_id  := null;
    m_context_inv_type    := null;
    --
    mt_iit_cols           := t_dummy2;
    m_invisible_call      := false;
  end;
  

  
END;
/
