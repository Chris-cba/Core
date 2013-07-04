CREATE OR REPLACE PACKAGE BODY nm3inv_composite2 AS
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_composite2.pkb-arc   2.14   Jul 04 2013 16:04:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_composite2.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       PVCS Version     : $Revision:   2.14  $
--       Based on sccs version :
--
--   Author : Priidu Tanava
--
--   Bulk Merge Composite Inventory package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
/* History:
  24.07.07 PT added set_job_broken(), improved progress reporting in get_progress_text()
  27.07.07 PT fixed a bug in process_from_iit_tmp() to cope with empty nm_mrg_derived_inv_values_tmp table.
  21.09.07 PT in do_rebuild() added the eng_dynseg bulk processing (total number of steps now 7)
                copied get_nmu_id_for_hig_owner() from nm3inv_composite.pkb.
                this package makes no reference to the old code now.
  04.10.07 PT accommodated nm3bulk_mrg changes in handling datum criteria
  08.10.07 PT in call_rebuild() merge results view name is now built from the merge unique.
  10.10.07 PT cleanup of dead code and variables
  17.10.07 PT removed autonomous transaction
  26.10.07 PT added procedure validate_nt_type() used in do_rebuild() to check p_nt_type allowed
                nm3bulk_mrg.ins_route_connectivity() now called separately in do_rebuild()
  08.08.08 PT in call_rebuild() made the admin unit lookup to go via nm_mail_users
  12.08.08 PT added p_admin_unit_id to ins_iit_tmp_values()
                added get_admin_unit() local proc to get value corresponding to asset inv type
  20.01.09 PT in ins_iit_tmp_values() ignore SYS_% columns - these are hidden columns created e.g. for function based indexes
  25.02.09 PT added nm3net.bypass_members_triggers() to process_from_iit_tmp()
  27.04.10 PT in do_rebuild() added parameters added parameters p_nqr_source and p_nqr_source_id to the call to nm3bulk_mrg.std_run()
                NB! requires nm3bulk_mrg.pkh version 2.6 or higher
  12.05.10 PT added parameter p_domain_return  => 'C' to the call to nm3bulk_mrg.std_run()
                NB! requires nm3bulk_mrg_pkh 2.7 or higher (logs 723574, 724275)
*/

  g_body_sccsid   constant  varchar2(30) := '"$Revision:   2.14  $"';
  g_package_name  constant  varchar2(30) := 'nm3inv_composite2';
  
  cant_serialize exception;
  pragma exception_init(cant_serialize, -8177);

  -- Bulk merge types
  type xsp_tbl is table of nm_inv_items_all.iit_x_sect%type index by binary_integer;
  type mp_tbl is table of nm_members_all.nm_begin_mp%type index by binary_integer;
  type id_tbl is table of nm_members_all.nm_ne_id_of%type index by binary_integer;
  type obj_type_tbl is table of nm_members_all.nm_obj_type%type index by binary_integer;
  type rowid_tbl is table of rowid index by binary_integer;
  type merge_tbl_rec is record(
     --xsp xsp_tbl
     ne_id id_tbl
    ,begin_mp mp_tbl
    ,end_mp mp_tbl
    ,iit_id id_tbl
    ,obj_type obj_type_tbl
    ,iit_rowid rowid_tbl
  );
  
  function get_iit_tmp_rec(
     p_rowid in rowid
  ) return nm_inv_items_all%rowtype;
  
  
  procedure release_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  );
  procedure get_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  );
  
  
  function get_nmu_id_for_hig_owner
  return nm_mail_users.nmu_id%type;
  
  procedure send_mail2(
     p_title in varchar2
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_user_id in nm_mail_users.nmu_id%type
    ,pt_lines in nm3type.tab_varchar32767
  );
  
  function to_string_attrib_tbl(p_tbl in attrib_tbl) return varchar2;
  
  procedure process_exclusive_attrs(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,pt_attr in out attrib_tbl
  );
  
  procedure set_job_broken(p_job in number);

  procedure validate_nt_type(
     p_inv_type in varchar2
    ,p_nt_type in varchar2
  );
  
  
  function get_admin_unit(
     p_inv_type in varchar2
  ) return number;
   
  cr  constant varchar2(1) := chr(10);
   
  m_next_iit_ne_id      nm_inv_items_all.iit_ne_id%type;
  m_next_iit_ne_id_flag pls_integer := 0;
  
  --
  m_ad_hoc_job      number;
  m_ad_hoc_sqlerrm  varchar2(32767);




--
-----------------------------------------------------------------------------
--

  
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
  


  --------------------------------------------------------------------
  -- Call and job submit procedures
  --------------------------------------------------------------------
  
  
  
  -- A dbms_job_submit wrapper
  -- The only added value is the logging of the call
  -- Use sql_dbms_job_what() to get the WHAT sql 
  procedure submit_job(
     p_job out binary_integer
    ,p_what_hint in varchar2
    ,p_what in varchar2
    ,p_next_date in date
    ,p_interval in varchar2
  )
  is
    l_len         binary_integer := length(p_what_hint);
    cur           sys_refcursor;
    
    --pragma autonomous_transaction;
  begin
    nm3dbg.debug_on;
    nm3dbg.putln(g_package_name||'.submit_job('
      ||'p_what_hint='||p_what_hint
      ||', p_what='||p_what
      ||', p_next_date='||p_next_date
      ||', p_interval='||p_interval
      ||')');
      
    if p_what_hint is null
      or p_what is null
      or p_next_date is null
    then
      raise_application_error(-20001, 'Bad attribute');
    end if;
      
      
    -- select the current jobs of this hint in order
    -- 1)broken, 2)not running 3)running
    for r in (
      select j.job, j.broken, j.this_date, j.interval, j.failures
      from sys.user_jobs j
      where substr(j.what, 4, l_len) = p_what_hint
      order by j.broken desc, j.this_date nulls first, j.next_date
    )
    loop
      if r.broken = 'Y' then
        dbms_job.remove(r.job);
      
      elsif r.this_date is null then
        dbms_job.remove(r.job);
        
      else
        raise_application_error(-20001
          ,p_what_hint||' is currently running');
          
      end if;

    end loop;
      
    dbms_job.submit(
       job       => p_job
      ,what      => '-- '||p_what_hint||chr(10)||p_what
      ,next_date => p_next_date
      ,interval  => p_interval
    );
    commit;
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.submit_job('
        ||'p_what_hint='||p_what_hint
        ||', p_what='||p_what
        ||', p_next_date='||p_next_date
        ||', p_interval='||p_interval
        ||')');
      rollback;
      raise;
    
  end;
  
  
  
  -- this does not set the job broken but sets the next run date to year 4000
  --  (oracle resets the broken flag if set on a running job)
  -- also adds the error message at the end of job's what
  -- called from within the error handler of call_rebuild()
  procedure set_job_broken(p_job in number)
  is
    l_what   varchar2(4000);
    l_errmsg varchar2(4000);
    i binary_integer;
    --pragma autonomous_transaction;
  begin
    nm3dbg.putln(g_package_name||'.set_job_broken('
      ||'p_job='||p_job
      ||')');
    select what
    into l_what
    from all_jobs
    where job = p_job;
    l_errmsg := substr(l_what, instr(l_what, ';') + 1);
    if l_errmsg is not null then
      l_what := null;
    else
      l_what := l_what||chr(10)||'/*'||chr(10)||substr(sqlerrm, 1, 3500)||chr(10)||'*/';
      nm3dbg.putln(l_what);
    end if;
    dbms_job.change(
        job       => p_job
       ,what      => l_what
       ,next_date => to_date('01/01/4000', 'DD/MM/YYYY')
       ,interval  => null
    );
    commit;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.set_job_broken('
        ||'p_job='||p_job
        ||', l_what='||l_what
        ||', l_errmsg='||l_errmsg
        ||')');
      rollback;
      raise;
  end;
  
  
  
  -- This builds a hint to the dbms_job WHAT sql
  -- the hint will be the first line in WHAT
  -- the hint can be used to determine if a job is already submitted
  function sql_dbms_job_what_hint(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_interval in varchar2
  ) return varchar2
  is
  begin
    if p_interval is null then
      return 'Derived Assets ad hoc: '||p_inv_type;
    else
      return 'Derived Assets regular: '||p_inv_type;
    end if;
  end;
  
  
  -- This returns the plsql code block to be submitted with dbms_job
  --  if p_effective_date is null then sysdate will be used
  --    leave null when submitting the standard recurring job
  function sql_dbms_job_what(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_send_mail in boolean
    ,p_ne_delim in varchar2
    ,p_nse_delim in varchar2
    ,p_attr1 in varchar2
    ,p_value1 in varchar2
    ,p_attr2 in varchar2
    ,p_value2 in varchar2
    ,p_attr3 in varchar2
    ,p_value3 in varchar2
  ) return varchar2
  is
    l_sql   varchar2(32767);
    cr      constant varchar2(1) := chr(10);
    l_effective_date varchar2(40);
    
  begin
    if p_effective_date is null then
      l_effective_date := 'trunc(sysdate)';
    else
      l_effective_date := 'to_date('''||to_char(p_effective_date, 'YYYYMMDD')||''', ''YYYYMMDD'')';
    end if;
    
    if p_send_mail is not null then
      l_sql := l_sql
        ||cr||'  ,p_send_mail => '||nm3flx.boolean_to_char(p_send_mail);
    end if;
    if p_ne_delim is not null then
      l_sql := l_sql
        ||cr||'  ,p_ne_delim => '''||p_ne_delim||'''';
    end if;
    if p_nse_delim is not null then
      l_sql := l_sql
        ||cr||'  ,p_nse_delim => '''||p_nse_delim||'''';
    end if;
    if p_attr1 is not null then
      l_sql := l_sql
        ||cr||'  ,p_attr1 => '''||p_attr1||''''
        ||cr||'  ,p_value1 => '''||p_value1||'''';
    end if;
    if p_attr2 is not null then
      l_sql := l_sql
        ||cr||'  ,p_attr2 => '''||p_attr2||''''
        ||cr||'  ,p_value2 => '''||p_value2||'''';
    end if;
    if p_attr3 is not null then
      l_sql := l_sql
        ||cr||'  ,p_attr3 => '''||p_attr3||''''
        ||cr||'  ,p_value3 => '''||p_value3||'''';
    end if;
    
    -- note: the first parameter is special parameter recognized by dbms_job
    --  this gives the call_rebuild() a chance to remove the job on failure
    return    'nm3inv_composite2.call_rebuild('
        ||cr||'   p_dbms_job_no => job'
        ||cr||'  ,p_inv_type => '''||p_inv_type||''''
        ||cr||'  ,p_effective_date => '||l_effective_date
            ||l_sql
        ||cr||');';
  end;
  

  
  -- this is the access point for both the dmbs_job and direct calling
  --  the p_attr0 and p_value0 are paris of merge query exclusive attributes
  --  the p_ne_id and p_nse_id come from the from
  --    that makes a direct call to run rebuild
  --    (in theory, they could be specified in dbms_job as well)
  -- This procedure is called inside dbms_job plsql block
  procedure call_rebuild(
     p_dbms_job_no in binary_integer
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_send_mail in boolean
    ,p_ne_delim in varchar2
    ,p_nse_delim in varchar2
    ,p_attr1 in varchar2
    ,p_value1 in varchar2
    ,p_attr2 in varchar2
    ,p_value2 in varchar2
    ,p_attr3 in varchar2
    ,p_value3 in varchar2
  )
  is
    r_nmnd        nm_mrg_nit_derivation%rowtype;
    l_nmq_unique  nm_mrg_query_all.nmq_unique%type;
    l_keep_history boolean := false;
    t_attr        attrib_tbl;
    i             binary_integer := 0;
    l_admin_unit_id hig_users.hus_admin_unit%type;
    t_ne          nm_id_tbl;
    t_nse         nm_id_tbl;
    l_job_failures number := 0;
    
  begin
    nm3dbg.debug_on; nm3dbg.timing_on;
    nm3dbg.putln(g_package_name||'.call_rebuild('
      ||'p_dbms_job_no='||p_dbms_job_no
      ||', p_inv_type='||p_inv_type
      ||', p_effective_date='||p_effective_date
      ||', p_send_mail='||nm3dbg.to_char(p_send_mail)
      ||', p_ne_delim='||p_ne_delim
      ||', p_nse_delim='||p_nse_delim
      ||', p_attr1='||p_attr1
      ||', p_value1='||p_value1
      ||', p_attr2='||p_attr2
      ||', p_value2='||p_value2
      ||', p_attr3='||p_attr3
      ||', p_value3='||p_value3
      ||')');
    nm3dbg.ind;
    
    if p_dbms_job_no is not null then
      select j.failures
      into l_job_failures
      from all_jobs j
      where j.job = p_dbms_job_no;
    end if;
    if l_job_failures > 0 then
      raise_application_error(-20001
        , 'Job '||p_dbms_job_no||' is failing. Attempt '||to_char(l_job_failures + 1)||'. Check and resubmit');
    end if;
    
    select * into r_nmnd 
    from nm_mrg_nit_derivation
    where nmnd_nit_inv_type = p_inv_type;
    
    -- lookup merge query name
    select nmq_unique into l_nmq_unique
    from nm_mrg_query_all
    where nmq_id = r_nmnd.nmnd_nmq_id;
    
    -- look up admin unit
    -- PT 08.08.08 made this to go via nm_mail_users
    --  NB! r_nmnd.nmnd_nmu_id_admin is mail user id
--    select u.hus_admin_unit into l_admin_unit_id
--    from
--       nm_mail_users mu
--      ,hig_users u
--    where mu.nmu_hus_user_id = u.hus_user_id
--      and mu.nmu_id = r_nmnd.nmnd_nmu_id_admin;
     
    -- This returns the admin unit corresponding to the asset admin type
    --  raises error if not found
    --  if multiple found then min value
    l_admin_unit_id := get_admin_unit(p_inv_type);

    
    if r_nmnd.nmnd_maintain_history = 'Y' then
      l_keep_history := true;
    end if;
    
    
    -- fill the t_attr with merge query exclusive attributes
    for r in (
      select upper(a.ita_attrib_name) ita_attrib_name
      from nm_inv_type_attribs_all a
      where a.ita_inv_type = p_inv_type
        and a.ita_exclusive = 'Y'
    )
    loop
      i := i + 1;
      t_attr(i).name := r.ita_attrib_name;
      if upper(p_attr1) = t_attr(i).name then
        t_attr(i).value := p_value1;
      elsif upper(p_attr2) = t_attr(i).name then
        t_attr(i).value := p_value2;
      elsif upper(p_attr3) = t_attr(i).name then
        t_attr(i).value := p_value3;
      elsif p_attr1||p_attr2||p_attr3 is not null then
        raise_application_error(-20101
          ,'Invalid merge query exclusive attribute specified');
      end if;
      
    end loop;
    
    
    -- split the ne and nse criteria delimited id strings into tables
    nm3sql.split_id_tbl(
       p_tbl    => t_ne
      ,p_string => p_ne_delim
      ,p_delim  => ','
    );
    nm3sql.split_id_tbl(
       p_tbl    => t_nse
      ,p_string => p_nse_delim
      ,p_delim  => ','
    );
  
  
    -- call the main rebuild processing function 
    do_rebuild(
       p_op_context     => p_dbms_job_no
      ,p_inv_type       => r_nmnd.nmnd_nit_inv_type
      ,p_nmq_id         => r_nmnd.nmnd_nmq_id
      ,p_effective_date => p_effective_date
      ,p_admin_unit_id  => l_admin_unit_id
      ,p_admin_id       => r_nmnd.nmnd_nmu_id_admin
      ,p_mrg_view       => 'V_MRG_'||l_nmq_unique||'_SVL'
      ,p_mrg_view_where => r_nmnd.nmnd_where_clause
      ,pt_unique_attr   => t_attr
      ,p_keep_history   => l_keep_history
      ,p_send_mail      => p_send_mail
      ,p_nt_type        => r_nmnd.nmnd_nt_type
      ,p_ngt_group_type => r_nmnd.nmnd_ngt_group_type
      ,pt_ne            => t_ne
      ,pt_nse           => t_nse
      ,p_ignore_poe     => true
    );


    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.call_rebuild('
        ||'p_dbms_job_no='||p_dbms_job_no
        ||', p_inv_type='||p_inv_type
        ||', p_send_mail='||nm3dbg.to_char(p_send_mail)
        ||', p_ne_delim='||p_ne_delim
        ||', p_nse_delim='||p_nse_delim
        ||', p_attr1='||p_attr1
        ||', p_value1='||p_value1
        ||', p_attr2='||p_attr2
        ||', p_value2='||p_value2
        ||', p_attr3='||p_attr3
        ||', p_value3='||p_value3
        ||', r_nmnd.nmnd_nmq_id='||r_nmnd.nmnd_nmq_id
        ||', l_nmq_unique='||l_nmq_unique
        ||', l_admin_unit_id='||l_admin_unit_id
        ||', i='||i
        ||', l_job_failures='||l_job_failures
        ||')');
      if p_dbms_job_no is not null then
        set_job_broken(p_job => p_dbms_job_no);
        --dbms_job.remove(p_dbms_job_no);
      end if;
      raise;
  end;
  

  
  

  -----------------------------------------------------------------------
  -- The main work procedures
  -----------------------------------------------------------------------
  
  -- This is the main work procedure
  -- normally this proc is always running in its own session
  --  as it is called via the dbms_job.submit procedure
  procedure do_rebuild(
     p_op_context in pls_integer
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_nmq_id in nm_mrg_query_all.nmq_id%type
    ,p_effective_date in date
    ,p_admin_unit_id in nm_admin_units_all.nau_admin_unit%type
    ,p_admin_id in hig_users.hus_user_id%type
    ,p_mrg_view in varchar2
    ,p_mrg_view_where in varchar2
    ,pt_unique_attr in attrib_tbl
    ,p_keep_history in boolean
    ,p_send_mail in boolean
    ,p_nt_type in nm_types.nt_type%type
    ,p_ngt_group_type in nm_group_types_all.ngt_group_type%type
    ,pt_ne in nm_id_tbl
    ,pt_nse in nm_id_tbl
    ,p_ignore_poe in boolean
  )
  is
    l_mrg_job_id    nm_mrg_query_results_all.nqr_mrg_job_id%type;
    l_nqr_description nm_mrg_query_results_all.nqr_description%type;
    l_sqlcount      number(8);
    l_sqlcount2     number(8);
    t_attr          attrib_tbl := pt_unique_attr;
    l_effective_date constant date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
    t_events        nm3type.tab_varchar32767;
    r_longops       nm3sql.longops_rec;
    l_group_type    nm_group_types_all.ngt_group_type%type;
    l_nqr_source    nm_mrg_query_results_all.nqr_source%type;
    l_nqr_source_id nm_mrg_query_results_all.nqr_source_id%type;
    i               binary_integer;
    
  begin
    nm3dbg.putln(g_package_name||'.do_rebuild('
      ||'p_op_context='||p_op_context
      ||', p_inv_type='||p_inv_type
      ||', p_nmq_id='||p_nmq_id
      ||', p_effective_date='||p_effective_date
      ||', p_admin_unit_id='||p_admin_unit_id
      ||', p_admin_id='||p_admin_id
      ||', p_mrg_view='||p_mrg_view
      ||', p_mrg_view_where='||p_mrg_view_where
      ||', pt_unique_attr.count='||pt_unique_attr.count
      ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
      ||', p_nt_type='||p_nt_type
      ||', p_ngt_group_type='||p_ngt_group_type
      ||', pt_ne.count='||pt_ne.count
      ||', pt_nse.count='||pt_nse.count
      ||', p_ignore_poe='||nm3dbg.to_char(p_ignore_poe)
      ||')');
    nm3dbg.ind;
    
    
    -- validate input parameters
    if p_inv_type is null
      or p_effective_date is null
    then
      raise_application_error(-20101, 'Invalid or missimg parameters');
    end if;
    
    
    
    l_nqr_description := 'Derived Asset '''||p_inv_type||''' rebuild';
    
    t_events(t_events.count+1) := 'Rebuild job parameters: '
      ||'job_context='||p_op_context
      ||', inv_type='||p_inv_type
      ||', effective_date='||p_effective_date
      ||', admin_id='||p_admin_id
      ||', keep_history='||nm3dbg.to_char(p_keep_history)
      ||', exclusive_attributes='||to_string_attrib_tbl(pt_unique_attr)
      ||', network_type='||p_nt_type
      ||', group_type='||p_ngt_group_type
      ||', route_count='||pt_ne.count
      ||', saved_extent_count='||pt_nse.count;
    
    
    -- process the unique attributes
    --  this validates and builds the value sql string(s)
    process_exclusive_attrs(
       p_inv_type => p_inv_type
      ,pt_attr => t_attr
    );
    
    
    
    if l_effective_date = p_effective_date then null;
    else
      nm3user.set_effective_date(p_effective_date);
    end if;
    
    
    -- the serializable ensures that we don't see invitem edits between the merge query steps
    -- possible error: ORA-08177 can't serialize access for this transaction
    --  this is happens when somenone else has modified the nm_inv_items_all or nm_members_all
    --  the modification must be on the same block. it is possible to happen. retry.
    -- NB! autonomous transactions cannot be used with temp table inserts within the serializable transaction
    --  as it makes the results invisible.
    set transaction isolation level serializable;
    

    
    -- 0 initialize
    r_longops.rindex      := dbms_application_info.set_session_longops_nohint;
    r_longops.op_name     := 'Derived asset rebuild';
    r_longops.context     := p_op_context;
    r_longops.sofar       := 0;
    r_longops.totalwork   := 8;
    r_longops.target_desc  := p_inv_type;
    nm3sql.set_longops(p_rec => r_longops, p_increment => 0);
    
    


    -- 1. Populate the network criteria
    
    -- 1.1 We have datums/routes/extents selected via Gazetteer
    if pt_ne.count > 0 or pt_nse.count > 0 then
    
      nm3bulk_mrg.load_gaz_list_datums(
         p_group_type => p_ngt_group_type
        ,pt_ne        => pt_ne
        ,pt_nse       => pt_nse
        ,p_sqlcount   => l_sqlcount
      );
      
      -- assign merge results source arguments
      -- if both specified then group takes precedence over saved extent
      
      -- group
      i := pt_ne.first;
      if i is not null then
        l_nqr_source    := nm3bulk_mrg.NQR_SOURCE_ROUTE;
        l_nqr_source_id := pt_ne(i);
      end if;
      
      -- saved extent
      i := pt_nse.first;
      if i is not null and l_nqr_source_id is null then
        l_nqr_source    := nm3bulk_mrg.NQR_SOURCE_SAVED;
        l_nqr_source_id := pt_nse(i);
      end if;

  

    -- 1.2 we have a group type (linear)
    elsif p_ngt_group_type is not null then
      nm3bulk_mrg.load_group_type_datums(
         p_group_type => p_ngt_group_type
        ,p_route_group_type => null
        ,p_sqlcount => l_sqlcount
      );
      
      
    -- 1.3 we have a network type
    elsif p_nt_type is not null then

      -- network type must be linear datum type and allwed for the inv_type
      validate_nt_type(
         p_inv_type => p_inv_type
        ,p_nt_type  => p_nt_type
      );
      
      -- load datums of the given nt_type
      nm3bulk_mrg.load_nt_type_datums(
         p_group_type => null
        ,p_nt_type => p_nt_type
        ,p_sqlcount => l_sqlcount
      );
        
        
    -- 1.4 no network criteria specified
    else
      -- load all datums of datum nt_type
      nm3bulk_mrg.load_all_network_datums(
         p_group_type => null
        ,p_sqlcount => l_sqlcount
      );
      
    
    end if;
    
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    t_events(t_events.count+1) := 'Loaded criteria datum count: '||l_sqlcount;
    
    
    -- 2 populate route connectivity
    nm3bulk_mrg.ins_route_connectivity(
       p_criteria_rowcount  => l_sqlcount
      ,p_ignore_poe         => p_ignore_poe
    );
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    
    
    -- 3,4,5. Run the bulk merge query
    nm3bulk_mrg.std_run(
       p_nmq_id         => p_nmq_id
      ,p_nqr_admin_unit => p_admin_unit_id
      ,p_nqr_source     => l_nqr_source
      ,p_nqr_source_id  => l_nqr_source_id
      ,p_domain_return  => 'C' -- CODE
      ,p_nmq_descr      => l_nqr_description
      ,p_criteria_rowcount => l_sqlcount
      ,p_mrg_job_id     => l_mrg_job_id
      ,p_longops_rec    => r_longops
    );
    
    commit;
    t_events(t_events.count+1) := 'Merge job committed with id: '||l_mrg_job_id;
    
    
    
    -- 6. Preprocess engineering dynseg
    nm3eng_dynseg_util.populate_tmp_table(
       p_mrg_job_id => l_mrg_job_id
      ,p_inv_type   => p_inv_type
      ,p_sqlcount   => l_sqlcount -- out
    );
    nm3eng_dynseg_util.set_context_mrg_job_id(l_mrg_job_id);
    nm3eng_dynseg_util.load_iit_mapping(p_inv_type);
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    t_events(t_events.count+1) := 'Preprocessed dynseg records count: '||l_sqlcount;
    
    
    -- 7. Popluate the iit temp table
    ins_iit_tmp_values(
       p_inv_type => p_inv_type
      ,p_mrg_view => p_mrg_view
      ,p_mrg_view_where => p_mrg_view_where
      ,p_admin_unit_id => p_admin_unit_id
      ,p_effective_date => p_effective_date
      ,p_mrg_job_id => l_mrg_job_id
      ,pt_attr => t_attr
      ,p_sqlcount => l_sqlcount
    );
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    t_events(t_events.count+1) := 'Loaded temporary invitems count: '||l_sqlcount;
    
    
    -- 8. Create the composite inv items and placements
    process_from_iit_tmp(
       p_inv_type       => p_inv_type
      ,p_mrg_job_id     => l_mrg_job_id
      ,p_effective_date => p_effective_date
      ,pt_attr          => t_attr
      ,p_iit_tmp_cardinality => l_sqlcount
      ,p_keep_history   => p_keep_history
      ,p_item_count     => l_sqlcount
      ,p_member_count   => l_sqlcount2
    );
    --commit;
    t_events(t_events.count+1) := 'Final invitems count: '||l_sqlcount
      ||', member count: '||l_sqlcount2;
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    
    if p_send_mail then
      send_mail2(
         p_title => 'Run Derived Assets Complete'
        ,p_inv_type => p_inv_type
        ,p_effective_date => p_effective_date
        ,p_user_id => p_admin_id
        ,pt_lines => t_events
      );
    end if;
    
    nm3dbg.deind;
  exception
    when cant_serialize then
      rollback;
      nm3user.set_effective_date(l_effective_date);
      if p_send_mail then
        t_events(t_events.count+1) := sqlerrm;
        send_mail2(
           p_title => 'Run Derived Assets Error'
          ,p_inv_type => p_inv_type
          ,p_effective_date => p_effective_date
          ,p_user_id => p_admin_id
          ,pt_lines => t_events
        );
      end if;
      raise_application_error(-20001,
        'Other edits have affected the consistency of the results. Transaction rolled back. Please retry.');
        
    when others then
      nm3dbg.puterr(sqlerrm||'; '||g_package_name||'.do_rebuild('
        ||'p_op_context='||p_op_context
        ||', p_inv_type='||p_inv_type
        ||', p_nmq_id='||p_nmq_id
        ||', p_effective_date='||p_effective_date
        ||', p_admin_unit_id='||p_admin_unit_id
        ||', p_mrg_view='||p_mrg_view
        ||', p_mrg_view_where='||p_mrg_view_where
        ||', pt_unique_attr.count='||pt_unique_attr.count
        ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
        ||', p_nt_type='||p_nt_type
        ||', p_ngt_group_type='||p_ngt_group_type
        ||', pt_ne.count='||pt_ne.count
        ||', pt_nse.count='||pt_nse.count
        ||', p_ignore_poe='||nm3dbg.to_char(p_ignore_poe)
        ||', l_mrg_job_id='||l_mrg_job_id
        ||', l_sqlcount='||l_sqlcount
        ||', l_sqlcount2='||l_sqlcount2
        ||', l_effective_date='||l_effective_date
        ||', l_group_type='||l_group_type
        ||', l_nqr_source='||l_nqr_source
        ||', l_nqr_source_id='||l_nqr_source_id
        ||')');
        rollback;
        nm3user.set_effective_date(l_effective_date);
        if p_send_mail then
          t_events(t_events.count+1) := sqlerrm;
          send_mail2(
             p_title => 'Run Derived Assets Error'
            ,p_inv_type => p_inv_type
            ,p_effective_date => p_effective_date
            ,p_user_id => p_admin_id
            ,pt_lines => t_events
          );
        end if;
        raise;
    
  end;
  
  
  
  procedure process_exclusive_attrs(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,pt_attr in out attrib_tbl
  )
  is
    l_count pls_integer := 0;
    l_found boolean := false;
    i       binary_integer;
    r_ita   nm_inv_type_attribs_all%rowtype;
      
    function sql_format_attr_value(
       p_value in varchar2
      ,p_format in varchar2
      ,p_format_mask in varchar2) return varchar2
    is
    begin
      if p_value is null then
        return null;
      end if;
      case p_format
      when 'NUMBER' then
        return p_value;
      when 'DATE' then
        if p_format_mask is not null then
          return 'to_date('''||p_value||''','''||p_format_mask||''')';
        else
          return 'to_date('''||p_value||''')';
        end if;
      else
        return ''''||p_value||'''';
      end case;
    end;
    
  begin
    nm3dbg.putln(g_package_name||'.process_exclusive_attrs('
      ||'p_inv_type='||p_inv_type
      ||', pt_attr='||to_string_attrib_tbl(pt_attr)
      ||')');
    nm3dbg.ind;
  
    -- compare the passed in parameters table to the exclusive attributes specified in metadata
    --  if not all passed in then raise error    
    for r in (
      select upper(a.ita_attrib_name) ita_attrib_name
      from nm_inv_type_attribs_all a
      where a.ita_inv_type = p_inv_type
        and a.ita_exclusive = 'Y'
    )
    loop
      l_found := false;
      for i in 1 .. pt_attr.count loop
        if upper(pt_attr(i).name) = r.ita_attrib_name then
          l_found := true;
          exit;
        end if;
      end loop;
      if not l_found then
        raise_application_error(-20040, 'Exclusive attribue not specified');
      end if;
      l_count := l_count + 1;
    end loop;
    if l_count = pt_attr.count then null;
    else
      raise_application_error(-20040, 'Invalid exclusive attribute specified');
    end if;
    nm3dbg.putln('exclusive attribute count: '||l_count);

  
    -- build the unique attributes where string
    i := pt_attr.first;
    while i is not null loop
      select * into r_ita
      from nm_inv_type_attribs_all a
      where a.ita_inv_type = p_inv_type
        and a.ita_attrib_name = upper(pt_attr(i).name);
              
      pt_attr(i).sql_value := sql_format_attr_value(
          p_value       => pt_attr(i).value
         ,p_format      => r_ita.ita_format
         ,p_format_mask => r_ita.ita_format_mask
      );
            
      i := pt_attr.next(i);
    end loop;
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.process_exclusive_attrs('
        ||'p_inv_type='||p_inv_type
        ||', pt_attr='||to_string_attrib_tbl(pt_attr)
        ||', l_count='||l_count
        ||', l_found='||nm3dbg.to_char(l_found)
        ||', i='||i
        ||')');
      raise;
  
  end;
  
  
  -- this is the main processing function
  --  that creates the invitem and member records
  procedure process_from_iit_tmp(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_mrg_job_id in id_type
    ,p_effective_date in date
    ,pt_attr in attrib_tbl
    ,p_iit_tmp_cardinality in number
    ,p_keep_history in boolean
    ,p_item_count out pls_integer
    ,p_member_count out pls_integer
  )
  is
    type rowid_tbl  is table of rowid index by binary_integer;
    t_rowid         rowid_tbl;
    l_enddate_count pls_integer;
    l_delete_count  pls_integer;
    l_invitem_count pls_integer;

    l_sql         varchar2(32767);
    l_sql_where   varchar2(4000);
    i             binary_integer;

  begin
    nm3dbg.putln(g_package_name||'.process_from_iit_tmp('
      ||'p_inv_type='||p_inv_type
      ||', p_mrg_job_id='||p_mrg_job_id
      ||', pt_attr='||to_string_attrib_tbl(pt_attr)
      ||', p_iit_tmp_cardinality='||p_iit_tmp_cardinality
      ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
      ||')');
    nm3dbg.ind;
    
    p_item_count := 0;
    
    -- PT 25.02.09
    nm3net.bypass_nm_members_trgs(pi_mode => true);

    -- build the exclusive attribute where string
    --  this is used in enddating/deleting existing members and invitems    
    i := pt_attr.first;
    while i is not null loop
      l_sql_where := l_sql_where
        ||cr||'  and i.'||lower(pt_attr(i).name)||' = v.'||lower(pt_attr(i).name);
      i := pt_attr.next(i);
    end loop;
    

    
    -- the sql to select the existing nm_members_records
    --  affected by the rebuild
    l_sql := 
            'select'
      ||cr||'   m.rowid row_id'
      ||cr||'from'
      ||cr||'   nm_mrg_section_members sm'
      ||cr||'  ,nm_mrg_derived_inv_values_tmp v'
      ||cr||'  ,nm_members m'
      ||cr||'  ,nm_inv_items_all i'
      ||cr||'where sm.nsm_mrg_job_id = :p_mrg_job_id'
      ||cr||'  and sm.nsm_mrg_section_id = v.mrg_section_id'
      ||cr||'  and m.nm_ne_id_of = sm.nsm_ne_id'
      ||cr||'  and m.nm_obj_type = :p_inv_type'
      ||cr||'  and m.nm_ne_id_in = i.iit_ne_id'
      ||cr||'  and ((sm.nsm_begin_mp < m.nm_end_mp'
      ||cr||'      and sm.nsm_end_mp > m.nm_begin_mp)'
      ||cr||'    or (sm.nsm_begin_mp = m.nm_begin_mp'
      ||cr||'      and sm.nsm_end_mp = m.nm_end_mp))'
          ||l_sql_where;
    nm3dbg.putln(l_sql);
    
    
    -- 1. delete or enddate the existing member records
    -- 1.1 end date
    if p_keep_history then
      
      -- select the rowids of existng member records affected by the rebuild
      execute immediate l_sql
      bulk collect into t_rowid
      using p_mrg_job_id, p_inv_type;
      nm3dbg.putln('existing members collect count: '||sql%rowcount);
            
            
      -- 2.1.1 end date the members whose start date is not rebuild's effective date
      -- if the effective date is same as old start date (two edits in same day)
      --  then we must delete, not enddate
      forall i in 1 .. t_rowid.count
        delete from nm_members_all
        where rowid = t_rowid(i)
          and nm_start_date = p_effective_date;
      l_delete_count := sql%rowcount;
      nm3dbg.putln('existing members delete count: '||l_delete_count);
          
          
      -- set the enddate for the rest (the normal processing)
      forall i in 1 .. t_rowid.count
        update nm_members_all
          set nm_end_date = p_effective_date
        where rowid = t_rowid(i)
          and nm_start_date != p_effective_date;
      l_enddate_count := sql%rowcount;
      nm3dbg.putln('existing members enddate count: '||l_enddate_count);
    
    
    
    -- 2.2 no history, delete
    else
      execute immediate
              'delete from nm_members'
        ||cr||'where rowid in ('
        ||cr||l_sql
        ||cr||')'
      using p_mrg_job_id, p_inv_type;

      l_delete_count := sql%rowcount;
      nm3dbg.putln('existing members delete count: '||l_delete_count);
      
    end if;
    
    
    -- 2. Insert the new invitems and members
    
    -- 2.1 Insert invitems
    insert into nm_inv_items_all(
      iit_ne_id, iit_inv_type, iit_primary_key, iit_start_date, iit_admin_unit, iit_descr
      , iit_foreign_key, iit_located_by, iit_position, iit_x_coord, iit_y_coord
      , iit_num_attrib16, iit_num_attrib17, iit_num_attrib18, iit_num_attrib19, iit_num_attrib20
      , iit_num_attrib21, iit_num_attrib22, iit_num_attrib23, iit_num_attrib24, iit_num_attrib25
      , iit_chr_attrib26, iit_chr_attrib27, iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30
      , iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33, iit_chr_attrib34, iit_chr_attrib35
      , iit_chr_attrib36, iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39, iit_chr_attrib40
      , iit_chr_attrib41, iit_chr_attrib42, iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45
      , iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48, iit_chr_attrib49, iit_chr_attrib50
      , iit_chr_attrib51, iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54, iit_chr_attrib55
      , iit_chr_attrib56, iit_chr_attrib57, iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60
      , iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63, iit_chr_attrib64, iit_chr_attrib65
      , iit_chr_attrib66, iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69, iit_chr_attrib70
      , iit_chr_attrib71, iit_chr_attrib72, iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75
      , iit_num_attrib76, iit_num_attrib77, iit_num_attrib78, iit_num_attrib79, iit_num_attrib80
      , iit_num_attrib81, iit_num_attrib82, iit_num_attrib83, iit_num_attrib84, iit_num_attrib85
      , iit_date_attrib86, iit_date_attrib87, iit_date_attrib88, iit_date_attrib89, iit_date_attrib90
      , iit_date_attrib91, iit_date_attrib92, iit_date_attrib93, iit_date_attrib94, iit_date_attrib95
      , iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour, iit_colour_txt, iit_coord_flag
      , iit_description, iit_diagram, iit_distance, iit_end_chain, iit_gap, iit_height, iit_height_2
      , iit_id_code, iit_instal_date, iit_invent_date, iit_inv_ownership, iit_itemcode, iit_lco_lamp_config_id
      , iit_length, iit_material, iit_material_txt, iit_method, iit_method_txt, iit_note, iit_no_of_units
      , iit_options, iit_options_txt, iit_oun_org_id_elec_board, iit_owner, iit_owner_txt
      , iit_peo_invent_by_id, iit_photo, iit_power, iit_prov_flag, iit_rev_by, iit_rev_date
      , iit_type, iit_type_txt, iit_width, iit_xtra_char_1
      , iit_xtra_date_1, iit_xtra_domain_1, iit_xtra_domain_txt_1, iit_xtra_number_1
      , iit_x_sect, iit_det_xsp, iit_offset, iit_x, iit_y, iit_z
      , iit_num_attrib96, iit_num_attrib97, iit_num_attrib98, iit_num_attrib99, iit_num_attrib100
      , iit_num_attrib101, iit_num_attrib102, iit_num_attrib103, iit_num_attrib104, iit_num_attrib105
      , iit_num_attrib106, iit_num_attrib107, iit_num_attrib108, iit_num_attrib109, iit_num_attrib110
      , iit_num_attrib111, iit_num_attrib112, iit_num_attrib113, iit_num_attrib114, iit_num_attrib115
    )
    select
      iit_ne_id, iit_inv_type, iit_ne_id, p_effective_date, iit_admin_unit, iit_descr
      , iit_foreign_key, iit_located_by, iit_position, iit_x_coord, iit_y_coord
      , iit_num_attrib16, iit_num_attrib17, iit_num_attrib18, iit_num_attrib19, iit_num_attrib20
      , iit_num_attrib21, iit_num_attrib22, iit_num_attrib23, iit_num_attrib24, iit_num_attrib25
      , iit_chr_attrib26, iit_chr_attrib27, iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30
      , iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33, iit_chr_attrib34, iit_chr_attrib35
      , iit_chr_attrib36, iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39, iit_chr_attrib40
      , iit_chr_attrib41, iit_chr_attrib42, iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45
      , iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48, iit_chr_attrib49, iit_chr_attrib50
      , iit_chr_attrib51, iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54, iit_chr_attrib55
      , iit_chr_attrib56, iit_chr_attrib57, iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60
      , iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63, iit_chr_attrib64, iit_chr_attrib65
      , iit_chr_attrib66, iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69, iit_chr_attrib70
      , iit_chr_attrib71, iit_chr_attrib72, iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75
      , iit_num_attrib76, iit_num_attrib77, iit_num_attrib78, iit_num_attrib79, iit_num_attrib80
      , iit_num_attrib81, iit_num_attrib82, iit_num_attrib83, iit_num_attrib84, iit_num_attrib85
      , iit_date_attrib86, iit_date_attrib87, iit_date_attrib88, iit_date_attrib89, iit_date_attrib90
      , iit_date_attrib91, iit_date_attrib92, iit_date_attrib93, iit_date_attrib94, iit_date_attrib95
      , iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour, iit_colour_txt, iit_coord_flag
      , iit_description, iit_diagram, iit_distance, iit_end_chain, iit_gap, iit_height, iit_height_2
      , iit_id_code, iit_instal_date, iit_invent_date, iit_inv_ownership, iit_itemcode, iit_lco_lamp_config_id
      , iit_length, iit_material, iit_material_txt, iit_method, iit_method_txt, iit_note, iit_no_of_units
      , iit_options, iit_options_txt, iit_oun_org_id_elec_board, iit_owner, iit_owner_txt
      , iit_peo_invent_by_id, iit_photo, iit_power, iit_prov_flag, iit_rev_by, iit_rev_date
      , iit_type, iit_type_txt, iit_width, iit_xtra_char_1
      , iit_xtra_date_1, iit_xtra_domain_1, iit_xtra_domain_txt_1, iit_xtra_number_1
      , iit_x_sect, iit_det_xsp, iit_offset, iit_x, iit_y, iit_z
      , iit_num_attrib96, iit_num_attrib97, iit_num_attrib98, iit_num_attrib99, iit_num_attrib100
      , iit_num_attrib101, iit_num_attrib102, iit_num_attrib103, iit_num_attrib104, iit_num_attrib105
      , iit_num_attrib106, iit_num_attrib107, iit_num_attrib108, iit_num_attrib109, iit_num_attrib110
      , iit_num_attrib111, iit_num_attrib112, iit_num_attrib113, iit_num_attrib114, iit_num_attrib115
    from
      nm_mrg_derived_inv_values_tmp;
    nm3dbg.putln('inserted invitems count: '||sql%rowcount);
      
      
    -- 2.2 insert members
    insert into nm_members_all (
      nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type
      , nm_begin_mp, nm_start_date, nm_end_mp
      , nm_cardinality, nm_admin_unit
    )
    select
       v.iit_ne_id, sm.nsm_ne_id, 'I', p_inv_type
      ,sm.nsm_begin_mp, p_effective_date, sm.nsm_end_mp
      ,1, v.iit_admin_unit
    from
       nm_mrg_section_members sm
      ,nm_mrg_derived_inv_values_tmp v
    where sm.nsm_mrg_section_id = v.mrg_section_id
      and sm.nsm_mrg_job_id = p_mrg_job_id;
    nm3dbg.putln('inserted memebers count: '||sql%rowcount);
  
  
  
    -- 3. enddate/delete the invitems that may have been left without placement
    if p_keep_history then
      update nm_inv_items_all i
        set i.iit_end_date = p_effective_date
      where i.iit_inv_type = p_inv_type
        and i.iit_end_date is null
        and not exists (
          select null from nm_members
          where nm_ne_id_in = i.iit_ne_id
        );
      nm3dbg.putln('enddated childless invitem count: '||sql%rowcount);
      
    else
      delete from nm_inv_items_all i
      where i.iit_inv_type = p_inv_type
        and i.iit_end_date is null
        and not exists (
          select null from nm_members
          where nm_ne_id_in = i.iit_ne_id
        );
      nm3dbg.putln('deleted childless invitem count: '||sql%rowcount);
    end if;
    
    -- PT 25.02.09
    nm3net.bypass_nm_members_trgs(pi_mode => false);

    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.process_from_iit_tmp('
        ||'p_inv_type='||p_inv_type
        ||', p_mrg_job_id='||p_mrg_job_id
        ||', pt_attr='||to_string_attrib_tbl(pt_attr)
        ||', p_iit_tmp_cardinality='||p_iit_tmp_cardinality
        ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
        ||', i='||i
        ||')');
      nm3net.bypass_nm_members_trgs(pi_mode => false);
      raise;
  end;
  
  
  
  
  -- this loads the iit records with correct drived values
  --  into a temp table nm_mrg_derived_inv_values_tmp
  -- autonomous transaction
  procedure ins_iit_tmp_values(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_mrg_job_id in nm_mrg_query_results_all.nqr_mrg_job_id%type
    ,p_mrg_view in varchar2
    ,p_mrg_view_where in varchar2
    ,p_admin_unit_id in nm_admin_units_all.nau_admin_unit%type
    ,p_effective_date in date
    ,pt_attr in attrib_tbl
    ,p_sqlcount out number
  )
  is
    l_sql   varchar2(32767);
    l_sql_mrg_view_where varchar2(4000) := p_mrg_view_where;
    cr      constant varchar2(1) := chr(10);
    i       binary_integer;
    l_derivation  varchar2(4000);
    
  begin
    nm3dbg.putln(g_package_name||'.ins_iit_tmp_values('
      ||'p_inv_type='||p_inv_type
      ||', p_mrg_job_id='||p_mrg_job_id
      ||', p_mrg_view='||p_mrg_view
      ||', p_mrg_view_where='||p_mrg_view_where
      ||', p_admin_unit_id='||p_admin_unit_id
      ||', p_effective_date='||p_effective_date
      ||', pt_attr='||to_string_attrib_tbl(pt_attr)
      ||')');
    nm3dbg.ind;
    
    -- nm_mrg_derived_inv_values_tmp is global temporary on commit preserve rows
    -- (implicit commit)
    execute immediate
      'truncate table nm_mrg_derived_inv_values_tmp';

      
    -- build the load sql string
    -- mrg is assumed to be alias in the derivation strings
    for r in (
       select
          case tc.column_name
          when 'IIT_NE_ID' then 'nm3net.get_next_ne_id'
          when 'IIT_INV_TYPE' then ''''||p_inv_type||''''
          when 'IIT_START_DATE' then ':p_effective_date'
          when 'IIT_ADMIN_UNIT' then ':p_admin_unit_id'
          else nvl(d.nmid_derivation, 'null')
          end nmid_derivation
         ,tc.column_name
       from
          (select * from nm_mrg_ita_derivation where nmid_ita_inv_type = p_inv_type) d
         ,( select column_name, column_id
            from user_tab_cols            
            where table_name  = 'NM_INV_ITEMS_ALL'
              and column_name not like 'SYS_%'
          ) tc
       where tc.column_name = d.nmid_ita_attrib_name (+)
       order by tc.column_id
    )
    loop
      -- for exclusive attribute replace the derivation with the user value if given
      l_derivation := r.nmid_derivation;
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).name = r.column_name and pt_attr(i).value is not null then
          l_derivation := pt_attr(i).sql_value;
          i := null;
        else
          i := pt_attr.next(i);
        end if;
      end loop;
      l_sql := l_sql||cr||','||l_derivation||' '||r.column_name;
      
    end loop;
    
    
    if l_sql_mrg_view_where is not null then
      l_sql_mrg_view_where :=
        cr||'  and '||l_sql_mrg_view_where;
    end if;
    
    l_sql := 'insert /*+ append */ into nm_mrg_derived_inv_values_tmp'
       ||cr||'select'
       ||cr||' mrg.nqr_mrg_job_id'
       ||cr||',mrg.nms_mrg_section_id'
           ||l_sql
       ||cr||'from '||p_mrg_view||' mrg'
       ||cr||'where mrg.nqr_mrg_job_id = :p_mrg_job_id'
           ||l_sql_mrg_view_where;
       
    nm3dbg.putln(l_sql);
       
    execute immediate l_sql using p_effective_date, p_admin_unit_id, p_mrg_job_id;
    p_sqlcount := sql%rowcount;
    commit;
    
    nm3dbg.putln('nm_mrg_derived_inv_values_tmp count:'||p_sqlcount);
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.ins_iit_tmp_values('
        ||'p_inv_type='||p_inv_type
        ||', p_mrg_job_id='||p_mrg_job_id
        ||', p_mrg_view='||p_mrg_view
        ||', p_mrg_view_where='||p_mrg_view_where
        ||', p_admin_unit_id='||p_admin_unit_id
        ||', p_effective_date='||p_effective_date
        ||')');
      raise;

  end;

  
  
  ----------------------------------------------------------------------
  -- Support procedures
  ----------------------------------------------------------------------


  function sql_mrg_iit_record(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  ) return varchar2
  is
    l_sql varchar2(32767);
    cr    constant varchar2(1) := chr(10);
  begin
    for r in (
       select
          nvl(d.nmid_derivation, 'null') nmid_derivation
         ,tc.column_name
       from
          nm_mrg_ita_derivation d
         ,(select column_name, column_id
          from User_tab_cols
          where table_name  = 'NM_INV_ITEMS_ALL'
          ) tc
       where tc.column_name = d.nmid_ita_attrib_name (+)
         and (d.nmid_ita_inv_type = p_inv_type or d.nmid_ita_inv_type is null)
       order by tc.column_id
    )
    loop
      l_sql := l_sql||cr||','||r.nmid_derivation||' '||r.column_name;
    end loop;
    return l_sql;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.sql_mrg_iit_record('
        ||'p_inv_type='||p_inv_type
        ||', l_sql='||l_sql
        ||')');
      raise;
  end;
  
  
  
  
  function get_iit_tmp_rec(
     p_rowid in rowid
  ) return nm_inv_items_all%rowtype
  is
    l_rec nm_inv_items_all%rowtype;
  begin
    select
      iit_ne_id, iit_inv_type, iit_primary_key, iit_start_date, iit_date_created
    , iit_date_modified, iit_created_by, iit_modified_by, iit_admin_unit, iit_descr
    , iit_end_date, iit_foreign_key, iit_located_by, iit_position, iit_x_coord, iit_y_coord
    , iit_num_attrib16, iit_num_attrib17, iit_num_attrib18, iit_num_attrib19, iit_num_attrib20
    , iit_num_attrib21, iit_num_attrib22, iit_num_attrib23, iit_num_attrib24, iit_num_attrib25
    , iit_chr_attrib26, iit_chr_attrib27, iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30
    , iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33, iit_chr_attrib34, iit_chr_attrib35
    , iit_chr_attrib36, iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39, iit_chr_attrib40
    , iit_chr_attrib41, iit_chr_attrib42, iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45
    , iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48, iit_chr_attrib49, iit_chr_attrib50
    , iit_chr_attrib51, iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54, iit_chr_attrib55
    , iit_chr_attrib56, iit_chr_attrib57, iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60
    , iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63, iit_chr_attrib64, iit_chr_attrib65
    , iit_chr_attrib66, iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69, iit_chr_attrib70
    , iit_chr_attrib71, iit_chr_attrib72, iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75
    , iit_num_attrib76, iit_num_attrib77, iit_num_attrib78, iit_num_attrib79, iit_num_attrib80
    , iit_num_attrib81, iit_num_attrib82, iit_num_attrib83, iit_num_attrib84, iit_num_attrib85
    , iit_date_attrib86, iit_date_attrib87, iit_date_attrib88, iit_date_attrib89, iit_date_attrib90
    , iit_date_attrib91, iit_date_attrib92, iit_date_attrib93, iit_date_attrib94, iit_date_attrib95
    , iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour, iit_colour_txt
    , iit_coord_flag, iit_description, iit_diagram, iit_distance, iit_end_chain, iit_gap
    , iit_height, iit_height_2, iit_id_code, iit_instal_date, iit_invent_date, iit_inv_ownership
    , iit_itemcode, iit_lco_lamp_config_id, iit_length, iit_material, iit_material_txt, iit_method
    , iit_method_txt, iit_note, iit_no_of_units, iit_options, iit_options_txt
    , iit_oun_org_id_elec_board, iit_owner, iit_owner_txt, iit_peo_invent_by_id, iit_photo
    , iit_power, iit_prov_flag, iit_rev_by, iit_rev_date, iit_type, iit_type_txt, iit_width
    , iit_xtra_char_1, iit_xtra_date_1, iit_xtra_domain_1, iit_xtra_domain_txt_1, iit_xtra_number_1
    , iit_x_sect, iit_det_xsp, iit_offset, iit_x, iit_y, iit_z
    , iit_num_attrib96, iit_num_attrib97, iit_num_attrib98, iit_num_attrib99, iit_num_attrib100
    , iit_num_attrib101, iit_num_attrib102, iit_num_attrib103, iit_num_attrib104, iit_num_attrib105
    , iit_num_attrib106, iit_num_attrib107, iit_num_attrib108, iit_num_attrib109, iit_num_attrib110
    , iit_num_attrib111, iit_num_attrib112, iit_num_attrib113, iit_num_attrib114, iit_num_attrib115
    into l_rec
    from nm_mrg_derived_inv_values_tmp
    where rowid = p_rowid;
    return l_rec;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_iit_tmp_rec('
        ||'p_rowid='||p_rowid
        ||')');
      raise;
  end;
  
  
  -- this returns the lowes id admin unit
  --  of type corresponding to the asset type admin type
  function get_admin_unit(
     p_inv_type in varchar2
  ) return number
  is
    l_admin_unit_id     integer;
  begin
    select
       min(q.admin_unit_id) admin_unit_id
    into
       l_admin_unit_id
    from (
    select
       u.hus_admin_unit admin_unit_id
    from
       nm_inv_types_all t
      ,nm_mrg_nit_derivation nt
      ,nm_mail_users mu
      ,hig_users u
      ,nm_admin_units au
    where t.nit_inv_type = nt.nmnd_nit_inv_type
      and mu.nmu_id = nt.nmnd_nmu_id_admin
      and mu.nmu_hus_user_id = u.hus_user_id
      and u.hus_admin_unit = au.nau_admin_unit
      and t.nit_admin_type = au.nau_admin_type
      and t.nit_inv_type = p_inv_type
    union all
    select
       ua.nua_admin_unit admin_unit_id
    from
       nm_inv_types_all t
      ,nm_mrg_nit_derivation nt
      ,nm_mail_users mu
      ,hig_users u
      ,nm_user_aus ua
      ,nm_admin_units au
    where t.nit_inv_type = nt.nmnd_nit_inv_type
      and mu.nmu_id = nt.nmnd_nmu_id_admin
      and mu.nmu_hus_user_id = u.hus_user_id
      and u.hus_user_id = ua.nua_user_id
      and ua.nua_admin_unit = au.nau_admin_unit
      and t.nit_admin_type = au.nau_admin_type
      and t.nit_inv_type = p_inv_type
    ) q;
    return l_admin_unit_id;
  exception
    when no_data_found then
      raise_application_error(-20001, 'No Admin Unit found for Admin Type '''
        ||nm3inv.get_inv_admin_type(p_inv_type)
        ||''' required for the Derived Asset Type.'
        ||' Check Admin Units for the Administrator mail user for '''||p_inv_type||'''.'
      );
  end;
  
  
  
  

  procedure send_mail2(
     p_title in varchar2
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_user_id in nm_mail_users.nmu_id%type
    ,pt_lines in nm3type.tab_varchar32767
  )
  is
    t_mail        nm3type.tab_varchar32767;
    t_mail_to     nm3mail.tab_recipient;
    t_mail_cc     nm3mail.tab_recipient;
    t_mail_bcc    nm3mail.tab_recipient;
    l_css         varchar2(500);
    
    procedure putln(p_line in varchar2)
    is
    begin
      t_mail(t_mail.count+1) := p_line;
    end;
    
  begin
    nm3dbg.putln(g_package_name||'.send_mail2('
      ||'p_title='||p_title
      ||', p_inv_type='||p_inv_type
      ||', p_effective_date='||p_effective_date
      ||', p_user_id='||p_user_id
      ||', pt_lines.count='||pt_lines.count
      ||')');
    nm3dbg.ind;
    
     --This returns the value of the HIG_ST_CSS product option. this option
     --  is in place for sites who wish to use a static (i.e. not from within the RDBMS)
     --  CSS document.
     -- The text returned is in the format
     --  <LINK REL="STYLESHEET" HREF="\\Dachom17\iris\Public\iris.css">
    l_css := hig.get_sysopt('hig_st_css');
    if l_css is not null then
      l_css := htf.linkrel(
         crel => 'stylesheet'
        ,curl => l_css
      );
    end if;
  
    putln(htf.htmlopen);
    putln(htf.headopen);
    putln(htf.title(p_title));
    putln(l_css);
    putln(htf.headclose);
    putln(htf.bodyopen);
    putln(htf.tableopen(cattributes=>'border=1'));
    --
    putln(htf.tablerowopen);
    putln(htf.tableheader('inv Type'));
    putln(htf.tabledata(p_inv_type));
    putln(htf.tablerowclose);
    --
    putln(htf.tablerowopen);
    putln(htf.tableheader('effective Date'));
    putln(htf.tabledata(to_char(p_effective_date, Sys_Context('NM3CORE','USER_DATE_MASK'))));
    putln(htf.tablerowclose);
    
    -- put out the event lines
    for i in 1 .. pt_lines.count loop
      putln(htf.tablerowopen);
      putln(htf.tableheader(i));
      putln(htf.tabledata(pt_lines(i)));
      putln(htf.tablerowclose);
    end loop;

    putln(htf.tableclose);
    putln(htf.bodyclose);
    putln(htf.htmlclose);
      
    t_mail_to(1).rcpt_id   := p_user_id;
    t_mail_to(1).rcpt_type := nm3mail.c_user;
    t_mail_cc(1)           := t_mail_to(1);
    t_mail_cc(1).rcpt_id   := get_nmu_id_for_hig_owner;
    if t_mail_cc(1).rcpt_id = t_mail_to(1).rcpt_id then
      t_mail_cc.delete;
    end if;
    
    nm3mail.write_mail_complete(
       p_from_user        => p_user_id
      ,p_subject          => ltrim(p_title||' '||p_inv_type||' rebuild')
      ,p_html_mail        => true
      ,p_tab_to           => t_mail_to
      ,p_tab_cc           => t_mail_cc
      ,p_tab_bcc          => t_mail_bcc
      ,p_tab_message_text => t_mail
    );
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.send_mail2('
        ||'p_title='||p_title
        ||', p_inv_type='||p_inv_type
        ||', p_effective_date='||p_effective_date
        ||', p_user_id='||p_user_id
        ||', pt_lines.count='||pt_lines.count
        ||')');
      -- fail quietly here, the error is logged
      -- raise;
  end;

  
  
  
  
  -- this aquires a custom exclusive lock for running the rebuild on given inv type
  --  second attempt by same session also raises error
  procedure get_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  )
  is    
    l_lock_name    constant varchar2(30) := 'da_'||p_inv_type;
    l_lock_handle  varchar2(128);
    l_lock_value   integer;
 
  begin
    nm3dbg.putln(g_package_name||'.get_lock('
      ||'p_inv_type='||p_inv_type
      ||')');
    
    if p_inv_type is null then
      raise_application_error(-20001, g_package_name||'.get_lock: bad call');
    end if;
     
    dbms_lock.allocate_unique(
       lockname         => l_lock_name
      ,lockhandle       => l_lock_handle  -- out
      ,expiration_secs  => 864000         -- default
    );
    
    l_lock_value := dbms_lock.request(
       lockhandle         => l_lock_handle
      ,lockmode           => dbms_lock.x_mode
      ,timeout            => 1
      ,release_on_commit  => false
    );
    
    -- success
    if l_lock_value = 0 then
      null;
      
    -- 1 locked by other session, 4 locked by ourselves
    elsif l_lock_value in (1, 4) then
      hig.raise_ner (
          pi_appl               => nm3type.c_net
         ,pi_id                 => 408
         ,pi_supplementary_info => p_inv_type --||' started '||to_char(l_date,nm3type.c_full_date_Time_format)
      );
    else
      raise_application_error(-20099, 'internal dbms_lock error: '||l_lock_value);
    end if;
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_lock('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  
  procedure release_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  )
  is    
    l_lock_name    constant varchar2(30) := 'da_'||p_inv_type;
    l_lock_handle  varchar2(128);
    l_lock_value   integer;
 
  begin
    nm3dbg.putln(g_package_name||'.release_lock('
      ||'p_inv_type='||p_inv_type
      ||')');
      
    if p_inv_type is null then
      raise_application_error(-20001, g_package_name||'.release_lock: bad call');
    end if;
     
    dbms_lock.allocate_unique(
       lockname         => l_lock_name
      ,lockhandle       => l_lock_handle  -- out
      ,expiration_secs  => 864000         -- default
    );
    
    l_lock_value := dbms_lock.release(
       lockhandle       => l_lock_handle
    );
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.release_lock('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  
  
  
  
  -- this returns the progress message from session_longops system view
  --  the do_rebuild is updating the longops record as it progresses
  --  the p_context is user specified number
  --    in our case it is the job_no of the dbms_job that that started the rebuild
  function get_progress_text(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_job_no in binary_integer
  ) return varchar2
  is
    l_text    varchar2(512 byte);
    l_sqlerrm varchar2(4000);
  begin
    if p_job_no is not null then
      select o.message into l_text
      from sys.v_$session_longops o
      where o.target_desc = p_inv_type
        and o.context = p_job_no;
    end if;
    return l_text;
  exception
    when no_data_found then
      declare
        l_job_failures number;
      begin
        select j.failures, replace(substr(j.what, instr(j.what, ';')+5), chr(10)||'*/') errmsg
        into l_job_failures, l_sqlerrm
        from all_jobs j
        where j.job = p_job_no;
        if l_job_failures > 0 then
          return 'Job '||p_job_no||' has failed: '||l_sqlerrm;
        else
          return 'unable to report progess on job '||p_job_no;
        end if;
      exception
        when no_data_found then null;
      end;
      return '#error: Job '||p_job_no||' not found';
    when too_many_rows then
      return '#error: duplicate job '||p_job_no;
  end;
    
    
    

  function to_string_attrib_tbl(p_tbl in attrib_tbl) return varchar2
  is
    l_ret varchar2(32767);
    i     binary_integer := p_tbl.first;
  begin
    while i is not null loop
      l_ret := l_ret||'('||p_tbl(i).name||' '||p_tbl(i).value||')';
      i := p_tbl.next(i);
    end loop;
    return '('||l_ret||')';
  end;

  
  
  -- the logic of this one is copied from the old nm3inv_composite.pkb
  --  returns the mail user id
  --  if more than one defined then returns the first one by id
  function get_nmu_id_for_hig_owner
  return nm_mail_users.nmu_id%type
  is
     l_nmu_id nm_mail_users.nmu_id%type;
  begin
    select nmu_id into l_nmu_id
    from (
    select mu.nmu_id
    from
       nm_mail_users mu
      ,hig_users u
    where u.hus_user_id  = mu.nmu_hus_user_id
      and u.hus_username = Sys_Context('NM3CORE','APPLICATION_OWNER')
    order by mu.nmu_id
    ) where rownum = 1;
    return l_nmu_id;
  exception
    when no_data_found then
      return null;
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_nmu_id_for_hig_owner('
        ||')');
      raise;
  end;
  
  
  -- this validates the network type parameter, called from do_rebuild()
  procedure validate_nt_type(
     p_inv_type in varchar2
    ,p_nt_type in varchar2
  )
  is
    l_dummy varchar2(1);
    l_msg   varchar2(100);
  begin
    l_msg := 'The network type must a linear datum type';
    select 'x' dummy into l_dummy
    from nm_types t
    where t.nt_type = p_nt_type
      and t.nt_datum = 'y'
      and t.nt_linear = 'y';
    --
    l_msg := 'The network type is not allowed for the derived asset type';
    select 'x' dummy into l_dummy
    from nm_inv_nw n
    where n.nin_nit_inv_code = p_inv_type
      and n.nin_nw_type = p_nt_type;
   exception
     when no_data_found then
       raise_application_error(-20001, l_msg);
   end;
  

--
-----------------------------------------------------------------------------
--
END;
/
