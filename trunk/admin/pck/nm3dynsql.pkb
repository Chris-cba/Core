CREATE OR REPLACE package body nm3dynsql as
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3dynsql.pkb-arc   2.13   Jul 04 2013 15:33:46   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3dynsql.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:33:46  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:28:16  $
--       PVCS Version     : $Revision:   2.13  $
--       Based on sccs version :
--
--
--   Author : Priidu Tanava
--
--   Package for standard reusable dynamic sql
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
/* History
  24.05.07  PT in is_cicular() added logic to cope with data where two nodes
                are connected by more than one element - same direction and lane
  04.10.07  PT changed sql_route_connectivity() to work with the nm_datum_criteria_tmp table
  09.01.08  PT added nm3dbg.deind to sql_route_connectivity()
  30.01.09  PT in connection with log 718691
                in sql_route_connectivity replaced references to m.nm_begin_mp and m.nm_end_mp with those of d.begin_mp and d.end_mp
                this ensures that nm_datum_criteria mp values are observed and avoids overlaps in nm_route_connectivity_tmp
                requires nm3bulk_mrg 2.17 or later
  27.05.10  RC Task 0109651 - comment out line to restrict query to only live elements (ecdm log 726355)
  17.06.10  PT task 0109816: in sql_route_connectivity() further replacing m.nm_begin_mp and m.nm_end_mp with those of d.begin_mp and d.end_mp
                to avoid expanding datum lengths
  07.07.10  PT task 0109941: in sql_route_connectivity() changed the logic of q4.chunk_no
                to avoid gaps when connectivity works over connecting datum pieces
  27.07.10  PT task 0109941: in sql_route_connectivity() changed the logic of nm_begin_mp and nm_end_mp
                to correctly calculate the values when connecting through datum pieces
  13.08.10  PT task: 0110102: changed is_circular() to use with subquery logic for performance
                in sql_route_connectivity() added connectivity check to ensure pieces of same datum are connected
*/

  g_body_sccsid     constant  varchar2(30) := '"$Revision:   2.13  $"';
  g_package_name    constant  varchar2(30) := 'nm3dynsql';


  -- exception used by is_circular() function
  connect_by_loop exception; -- CONNECT BY loop in user data
  pragma exception_init(connect_by_loop, -1436);

  cr  constant varchar2(10) := chr(10);
  qt  constant varchar2(39) := chr(39); -- single quote

  m_date_format constant varchar2(20) := 'DD-MON-YYYY';
  m_debug constant number(1) := 3;

  mt_id       nm_id_tbl       := new nm_id_tbl();
  mt_code     nm_code_tbl     := new nm_code_tbl();
  mt_id_code  nm_id_code_tbl  := new nm_id_code_tbl();



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


  -- this returns the effective date criteria string using bind variables
  -- the bind count is incremented in p_bind_count
  --  (it is recommended to use the sys_context version of this function)
  function sql_effective_date(
     p_bind_count in out integer
    ,p_date in date
    ,p_start_date_column in varchar2
    ,p_end_date_column in varchar2
  ) return varchar2
  is
    l_bind_count integer := nvl(p_bind_count, 0);
  begin
    if p_date = trunc(sysdate) then
      p_bind_count := l_bind_count + 0;
      return p_end_date_column||' is null';
    else
      p_bind_count := l_bind_count + 2;
      return p_start_date_column||' <= :p_effective_date and '
        ||'('||p_end_date_column||' is null or '||p_end_date_column||' > :p_effective_date)';
    end if;
  end;


  -- this returns the effective date criteria string using the sys_context 'effective_date'
  function sql_effective_date(
     p_date in date
    ,p_start_date_column in varchar2
    ,p_end_date_column in varchar2
  ) return varchar2
  is
  begin
    if p_date = trunc(sysdate) then
      return p_end_date_column||' is null';
    else
      Nm3Ctx.Set_Context('effective_date', to_char(trunc(p_date), 'YYYYMMDD'));
      return p_start_date_column||' <= To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'') and '
        ||'('||p_end_date_column||' is null or '||p_end_date_column||' > To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY''))';
    end if;
  end;


  function sql_effective_date_tbl return varchar2
  is
  begin
    return '(select /*+ cardinality(dd 1) */ To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'') effective_date from dual dd)';
  end;




  -- this returns the sql select statement for route connectivity.
  --  the nm_datum_criteria_tmp must be filled before the sql is used
  --  p_criteria_rowcount: the record count in nm_datum_criteria_tmp
  --  p_ignore_poe: if true then the poe's are not treated as discontinuities.
  function sql_route_connectivity(
     p_criteria_rowcount in integer
    ,p_ignore_poe in boolean
  ) return varchar2
  is
    l_sql             varchar2(32767);
    l_cardinality     integer;
    l_sql_ignore_poe  varchar2(300);
    l_sql_route_where varchar2(300);
    l_sql_effective_date_tbl  varchar2(200);
    l_sql_effective_date_join varchar2(500);

  begin
    nm3dbg.putln(g_package_name||'.sql_route_connectivity('
      ||'p_criteria_rowcount='||p_criteria_rowcount
      ||', p_ignore_poe='||nm3flx.boolean_to_char(p_ignore_poe)
      ||')');
    nm3dbg.ind;


    l_cardinality := nm3sql.get_rounded_cardinality(p_criteria_rowcount);


    if p_ignore_poe then null;
    else
      l_sql_ignore_poe := cr||'          and s1.nm_end_slk = s2.nm_slk';
    end if;


    -- effective date
    -- (this can be skipped if the datums table has values
    --    and they can be relied on to be valid for the current effective date)
    if To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY') = trunc(sysdate) then
      l_sql_effective_date_join :=
          cr||'  and m.nm_end_date is null'
        ||cr||'  and e.ne_end_date is null';
    else
      l_sql_effective_date_tbl := '  ,'||sql_effective_date_tbl||' ed';
      l_sql_effective_date_join :=
          cr||'  and m.nm_start_date <= ed.effective_date and (m.nm_end_date is null or m.nm_end_date > ed.effective_date)'
        ||cr||'  and e.ne_start_date <= ed.effective_date and (e.ne_end_date is null or e.ne_end_date > ed.effective_date)';
        --||cr||'  and gt.ngt_start_date <= gt.ngt_start_date and (gt.ngt_end_date is null or gt.ngt_end_date > ed.effective_date)'
    end if;

    l_sql :=
          'select'
    ||cr||'   q4.nm_ne_id_in'
    ||cr||'  ,q4.chunk_no'
    --||cr||'  ,q4.chunk_seq'
    ||cr||'  ,row_number() over (partition by q4.nm_ne_id_in, q4.chunk_no order by q4.chunk_seq) chunk_seq'
    ||cr||'  ,q4.nm_ne_id_of'
    ||cr||'  ,q4.min_begin_mp nm_begin_mp'
    ||cr||'  ,q4.max_end_mp nm_end_mp'
    ||cr||'  ,lag(q4.measure, 1, 0) over'
    ||cr||'    (partition by q4.nm_ne_id_in, q4.chunk_no order by q4.chunk_seq) measure'
    ||cr||'  ,q4.measure end_measure'
    ||cr||'  ,q4.nt_unit_in'
    ||cr||'  ,q4.nt_unit_of'
    ||cr||'  ,q4.nm_slk'
    ||cr||'  ,q4.nm_end_slk'
    ||cr||'  ,q4.nm_seg_no'
    ||cr||'  ,q4.nm_seq_no'
    ||cr||'  ,q4.nm_cardinality'
    ||cr||'  ,q4.nm_obj_type'
    ||cr||'  ,q4.ne_type'
    ||cr||'  ,q4.ne_sub_class'
    ||cr||'  ,q4.cd_start_node start_node'
    ||cr||'  ,q4.cd_end_node end_node'
    ||cr||'  ,q4.nsc_seq_no'
    ||cr||'  ,q4.single_start_node_count'
    ||cr||'  ,q4.single_end_node_count'
    ||cr||'  ,q4.dual_start_node_count'
    ||cr||'  ,q4.dual_end_node_count'
    ||cr||'  ,count(distinct decode(q4.nsc_seq_no, 1, q4.chunk_no)) over (partition by q4.nm_ne_id_in) single_chunk_count'
    ||cr||'  ,count(distinct decode(q4.nsc_seq_no, 2, q4.chunk_no)) over (partition by q4.nm_ne_id_in) dual_chunk_count'
    ||cr||'from ('
    ||cr||'select q3.*'
    ||cr||'  ,sum(q3.nm_end_mp - q3.nm_begin_mp)'
    ||cr||'    over (partition by q3.nm_ne_id_in, q3.chunk_no'
    ||cr||'     order by q3.chunk_seq, q3.nm_begin_mp rows unbounded preceding'
    ||cr||'   ) measure'
    ||cr||'  ,row_number() over (partition by  q3.nm_ne_id_of, q3.nm_ne_id_in, q3.chunk_no order by q3.chunk_seq) member_rownum'
    ||cr||'  ,min(q3.nm_begin_mp) over (partition by q3.nm_ne_id_of, q3.nm_ne_id_in, q3.chunk_no) min_begin_mp'
    ||cr||'  ,max(q3.nm_end_mp) over (partition by q3.nm_ne_id_of, q3.nm_ne_id_in, q3.chunk_no) max_end_mp'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'   q2.nm_ne_id_in'
    ||cr||'  ,to_number(substr(q2.chunk_no_seq, 1, 6)) chunk_no'
    ||cr||'  ,to_number(substr(q2.chunk_no_seq, 8)) chunk_seq'
    ||cr||'  ,q2.nm_ne_id_of'
    ||cr||'  ,q2.nm_begin_mp'
    ||cr||'  ,q2.nm_end_mp'
    ||cr||'  ,q2.nt_unit_in'
    ||cr||'  ,q2.nt_unit_of'
    ||cr||'  ,q2.nm_slk'
    ||cr||'  ,q2.nm_end_slk'
    ||cr||'  ,q2.nm_seg_no'
    ||cr||'  ,q2.nm_seq_no'
    ||cr||'  ,q2.nm_cardinality'
    ||cr||'  ,q2.nm_obj_type'
    ||cr||'  ,q2.ne_type'
    ||cr||'  ,q2.ne_sub_class'
    ||cr||'  ,q2.cd_start_node'
    ||cr||'  ,q2.cd_end_node'
    ||cr||'  ,q2.nsc_seq_no'
    ||cr||'  ,q2.single_start_node_count'
    ||cr||'  ,q2.single_end_node_count'
    ||cr||'  ,q2.dual_start_node_count'
    ||cr||'  ,q2.dual_end_node_count'
    ||cr||'from ('
    ||cr||'with src as ('
    ||cr||'select q0.*'
    ||cr||',count(distinct decode(nvl(q0.nsc_seq_no, 1), 1, q0.nm_ne_id_of))'
    ||cr||'  over (partition by q0.nm_ne_id_in, cd_start_node)'
    ||cr||' single_start_node_count'
    ||cr||',count(distinct decode(nvl(q0.nsc_seq_no, 1), 1, q0.nm_ne_id_of))'
    ||cr||'  over (partition by q0.nm_ne_id_in, cd_end_node)'
    ||cr||' single_end_node_count'
    ||cr||',count(distinct decode(nvl(q0.nsc_seq_no, 2), 2, q0.nm_ne_id_of))'
    ||cr||'  over (partition by q0.nm_ne_id_in, cd_start_node)'
    ||cr||' dual_start_node_count'
    ||cr||',count(distinct decode(nvl(q0.nsc_seq_no, 2), 2, q0.nm_ne_id_of))'
    ||cr||'  over (partition by q0.nm_ne_id_in, cd_start_node)'
    ||cr||' dual_end_node_count'
    ||cr||'from ('
    ||cr||'select /*+ cardinality(d '||l_cardinality||') */'
    ||cr||'   rownum row_num'
    ||cr||'  ,m.nm_ne_id_in'
    ||cr||'  ,m.nm_ne_id_of'
    ||cr||'  ,m.nm_obj_type'
    ||cr||'  ,e.ne_type'
    ||cr||'  ,m.nm_cardinality'
    ||cr||'  ,d.begin_mp nm_begin_mp'
    ||cr||'  ,d.end_mp nm_end_mp'
    ||cr||'  ,e.ne_length'
    ||cr||'  ,nvl(m.nm_slk, -1) nm_slk'
    ||cr||'  ,nvl(m.nm_end_slk, -1) nm_end_slk'
    ||cr||'  ,m.nm_seg_no'
    ||cr||'  ,m.nm_seq_no'
    ||cr||'  ,decode(m.nm_cardinality, 1, e.ne_no_start, e.ne_no_end) cd_start_node'
    ||cr||'  ,decode(m.nm_cardinality, 1, e.ne_no_end, e.ne_no_start) cd_end_node'
    ||cr||'  ,decode(m.nm_cardinality, 1, d.begin_mp, d.end_mp) cd_begin_mp'
    ||cr||'  ,decode(m.nm_cardinality, 1, d.end_mp, d.begin_mp) cd_end_mp'
    ||cr||'  ,case'
    ||cr||'   when m.nm_cardinality = 1 and d.begin_mp = 0 then 1'
    ||cr||'   when m.nm_cardinality = -1 and d.end_mp = nvl(e.ne_length, d.end_mp) then 1'
    ||cr||'   else null'
    ||cr||'   end begin_mp_con'
    ||cr||'  ,case'
    ||cr||'   when m.nm_cardinality = 1 and d.end_mp = nvl(e.ne_length, d.end_mp) then 1'
    ||cr||'   when m.nm_cardinality = -1 and d.begin_mp = 0 then 1'
    ||cr||'   else null'
    ||cr||'   end end_mp_con'
    --||cr||'  ,t.nt_length_unit nt_unit_of'
    --||cr||'  ,t2.nt_length_unit nt_unit_in'
    ||cr||'  ,(select nt_length_unit from nm_types where nt_type = e.ne_nt_type) nt_unit_of'
    ||cr||'  ,(select nt_length_unit from nm_types where nt_type = gt.ngt_nt_type) nt_unit_in'
    ||cr||'  ,e.ne_sub_class'
    ||cr||'  ,decode(e.ne_type, ''D'', null, nvl((select case when nsc_seq_no <= 2 then 1 else 2 end'
    ||cr||'    from nm_type_subclass'
    ||cr||'    where nsc_sub_class = e.ne_sub_class and nsc_nw_type = e.ne_nt_type'
    ||cr||'   ), 1)) nsc_seq_no'
    ||cr||'from'
    ||cr||'   nm_datum_criteria_tmp d'
    ||cr||'  ,nm_members_all m'
    ||cr||'  ,nm_elements_all e'
    ||cr||'  ,nm_group_types_all gt'
    --||cr||'  ,nm_types t'
    --||cr||'  ,nm_types t2'
        ||l_sql_effective_date_tbl
    ||cr||'where d.datum_id = m.nm_ne_id_of'
    ||cr||'  and d.group_id = m.nm_ne_id_in'
    ||cr||'  and m.nm_ne_id_of = e.ne_id'
    ||cr||'  and m.nm_obj_type = gt.ngt_group_type'
    --||cr||'  and e.ne_nt_type = t.nt_type'
    --||cr||'  and gt.ngt_nt_type = t2.nt_type'
        ||l_sql_effective_date_join
--  ||cr||'  and e.ne_end_date is null'  -- RAC change to allow software to work as past effective dates.
    --||cr||'  and gt.ngt_end_date is null'
    --||cr||'  and m.nm_type = ''G'''
    ||cr||'  and gt.ngt_linear_flag = ''Y''' -- only consider linear groups
    -- join individual datum pieces
    ||cr||'  and (d.begin_mp = m.nm_begin_mp and d.end_mp = m.nm_end_mp' -- exact match covers uncut liear chunks and detatched point sections
    ||cr||'  or (d.begin_mp < m.nm_end_mp and d.end_mp > m.nm_begin_mp))' -- chunks smaller than in nm_members
    ||cr||') q0'
    ||cr||'order by q0.nm_seg_no, q0.nm_seq_no'
    ||cr||')'
    ||cr||'select'
    ||cr||'   s.row_num'
    ||cr||'  ,s.nm_ne_id_in'
    ||cr||'  ,s.nm_ne_id_of'
    ||cr||'  ,s.nm_obj_type'
    ||cr||'  ,s.ne_type'
    ||cr||'  ,s.nm_cardinality'
    ||cr||'  ,s.nm_begin_mp'
    ||cr||'  ,s.nm_end_mp'
    ||cr||'  ,s.nm_slk'
    ||cr||'  ,s.nm_end_slk'
    ||cr||'  ,s.nm_seg_no'
    ||cr||'  ,s.nm_seq_no'
    ||cr||'  ,s.ne_sub_class'
    ||cr||'  ,s.cd_start_node'
    ||cr||'  ,s.cd_end_node'
    ||cr||'  ,q.row_num row_num2'
    ||cr||'  ,group_chunk_no_seq(s.row_num||''_''||q.row_num) over (partition by s.nm_ne_id_in) chunk_no_seq'
    ||cr||'  ,s.nt_unit_of'
    ||cr||'  ,s.nt_unit_in'
    ||cr||'  ,s.nsc_seq_no'
    ||cr||'  ,s.single_start_node_count'
    ||cr||'  ,s.single_end_node_count'
    ||cr||'  ,s.dual_start_node_count'
    ||cr||'  ,s.dual_end_node_count'
    ||cr||'from ('
    ||cr||'select'
    ||cr||'   s1.*'
    ||cr||'  ,s2.row_num row_num2'
    ||cr||'from'
    ||cr||'   src s1'
    ||cr||'  ,src s2'
    ||cr||'where s1.nm_ne_id_in = s2.nm_ne_id_in'
    ||cr||'  and s1.row_num != s2.row_num'
    ||cr||'  and ('
    ||cr||'        ('
    ||cr||'              s1.nm_ne_id_of != s2.nm_ne_id_of'
    ||cr||'          and s1.cd_end_node = s2.cd_start_node'
    ||cr||'          and s1.end_mp_con = s2.begin_mp_con'
    ||cr||'          and (s1.nm_ne_id_of != s2.nm_ne_id_of or s1.cd_end_mp = s2.cd_begin_mp)'
        ||l_sql_ignore_poe
    ||cr||'          and s1.single_end_node_count <= 2 and s2.single_start_node_count <= 2'
    ||cr||'          and s1.dual_end_node_count <= 2 and s2.dual_start_node_count <= 2'
    ||cr||'          and (s1.single_end_node_count <= 1 or s2.cd_start_node = s2.cd_end_node'
    ||cr||'            or nm3dynsql.is_circular(s2.nm_ne_id_in, s2.nm_ne_id_of, s1.nm_ne_id_of) = 1)'
    ||cr||'          and (s2.single_start_node_count <= 1 or s1.cd_start_node = s1.cd_end_node'
    ||cr||'            or nm3dynsql.is_circular(s1.nm_ne_id_in, s1.nm_ne_id_of, s2.nm_ne_id_of) = 1)'
    ||cr||'          and (s1.dual_end_node_count <= 1 or s2.cd_start_node = s2.cd_end_node'
    ||cr||'            or nm3dynsql.is_circular(s2.nm_ne_id_in, s2.nm_ne_id_of, s1.nm_ne_id_of) = 1)'
    ||cr||'          and (s2.dual_start_node_count <= 1 or s1.cd_start_node = s1.cd_end_node'
    ||cr||'            or nm3dynsql.is_circular(s1.nm_ne_id_in, s1.nm_ne_id_of, s2.nm_ne_id_of) = 1)'
    ||cr||'          and ((s1.nsc_seq_no = s2.nsc_seq_no'
    ||cr||'              or s1.nsc_seq_no is null or s2.nsc_seq_no is null)'
    ||cr||'            or (s1.single_end_node_count + s1.dual_end_node_count = 1'
    ||cr||'              and s2.single_start_node_count + s2.dual_start_node_count = 1))'
    ||cr||'        )'
    ||cr||'    or'
    ||cr||'        ('
    ||cr||'              s1.nm_ne_id_of = s2.nm_ne_id_of'
    ||cr||'          and s1.cd_end_mp = s2.cd_begin_mp'
    ||cr||'        )'
    ||cr||'    )'
    ||cr||') q'
    ||cr||', src s'
    ||cr||'where s.row_num = q.row_num2 (+)'
    ||cr||') q2'
    ||cr||') q3'
    ||cr||') q4'
    ||cr||'where q4.member_rownum = 1 or nm_begin_mp = nm_end_mp'
    ;
    nm3dbg.deind;
    return l_sql;

  end;



  -- this tests if a piece or route starting at p_nm_ne_id_of is circular
  --  used by sql_route_connectivity() and the connectivity views
  -- returns 1 when circular, 0 when not
  function is_circular(
     p_nm_ne_id_in in nm_members_all.nm_ne_id_in%type
    ,p_nm_ne_id_of in nm_members_all.nm_ne_id_of%type
    ,p_connecting_nm_ne_id_of in nm_members_all.nm_ne_id_of%type
  ) return integer
  is
    l_count number(6);
  begin

    -- this query tires to issue a connect by select
    --  fails if there is circluar connectivity
    --  deals gracefully with duplicate same lane connections between nodes
    with src as (
    select
       q4.nm_ne_id_of
      ,q4.ne_no_start, q4.ne_no_end, q4.nsc_seq_no
    from (
    select
       first_value(q3.nm_ne_id_of)
        over (partition by q3.ne_no_start, q3.ne_no_end, q3.nsc_seq_no
          order by decode(q3.nm_ne_id_of, p_nm_ne_id_of, 1, 2)) nm_ne_id_of
      ,q3.ne_no_start, q3.ne_no_end, q3.nsc_seq_no
    from (
    select q2.*
    ,case when nsc_seq_no <= 2 then 1 when nsc_seq_no > 2 then 2 end nsc_seq_no
    from (
    select nm_ne_id_of, ne_nt_type, ne_sub_class --, nm_slk
      ,decode(nm_cardinality, 1, ne_no_start, ne_no_end) ne_no_start
      ,decode(nm_cardinality, 1, ne_no_end, ne_no_start) ne_no_end
      ,decode(nm_cardinality, 1, nm_begin_mp, nm_end_mp) nm_begin_mp
      ,decode(nm_cardinality, 1, nm_end_mp, nm_begin_mp) nm_end_mp
    from nm_elements, nm_members
    where ne_id = nm_ne_id_of
      and nm_ne_id_in = p_nm_ne_id_in
      and nm_ne_id_of != p_connecting_nm_ne_id_of
    ) q2
    , nm_type_subclass
    where q2.ne_sub_class = nsc_sub_class (+)
      and q2.ne_nt_type = nsc_nw_type (+)
    ) q3
    ) q4
    group by
       q4.nm_ne_id_of
      ,q4.ne_no_start, q4.ne_no_end, q4.nsc_seq_no
    )
    select count(*) into l_count
    from src q
    connect by prior q.ne_no_start = q.ne_no_end
      and q.ne_no_start != q.ne_no_end
      and (prior q.nsc_seq_no = q.nsc_seq_no
        or prior q.nsc_seq_no is null or q.nsc_seq_no is null)
    start with q.nm_ne_id_of = p_nm_ne_id_of;

    --dbms_output.put_line('is_circular('||p_nm_ne_id_in
    --  ||', '||p_nm_ne_id_of||', '||p_connecting_nm_ne_id_of||')=0');
    return 0;
  exception
    when connect_by_loop then
      --dbms_output.put_line('is_circular('||p_nm_ne_id_in
      --  ||', '||p_nm_ne_id_of||', '||p_connecting_nm_ne_id_of||')=1');
      return 1;
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.is_circular('
        ||'p_nm_ne_id_in='||p_nm_ne_id_in
        ||', p_nm_ne_id_of='||p_nm_ne_id_of
        ||', p_connecting_nm_ne_id_of='||p_connecting_nm_ne_id_of
        ||')');
      raise;

  end;




end;
/
