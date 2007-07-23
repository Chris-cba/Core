CREATE OR REPLACE package body nm3sql as
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sql.pkb-arc   2.0   Jul 23 2007 16:46:54   smarshall  $
--       Module Name      : $Workfile:   nm3sql.pkb  $
--       Date into PVCS   : $Date:   Jul 23 2007 16:46:54  $
--       Date fetched Out : $Modtime:   Jul 23 2007 16:46:34  $
--       PVCS Version     : $Revision:   2.0  $
--       Based on sccs version : 
--
--   Author : Priidu Tanava
--
--   package for generic context 'sql' used to pass bind variables into views
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
  g_body_sccsid     constant  varchar2(30) := '"$Revision:   2.0  $"';
  g_package_name    constant  varchar2(30) := 'nm3sql';

  m_date_format constant varchar2(20) := 'DD-MON-YYYY';
  m_debug constant number(1) := 3;
  
  MC_NAMESPACE constant varchar2(6) := 'NM_SQL';
  
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
  
  

  
  procedure set_context_value(p_attribute in varchar2, p_value in varchar2)
  is
  begin
    dbms_session.set_context('NM_SQL', p_attribute, p_value);
  end;
  
  
  
  procedure debug_sql_context
  is
    l_comma varchar2(2);
    l_put   varchar2(1000);
  begin
    
    for r in (
      select c.attribute, c.value
      from session_context c
      where c.namespace = 'NM_SQL'
      order by c.attribute
    )
    loop
      l_put := l_put||l_comma||r.attribute||'='||r.value;
      l_comma := '  ';
    end loop;
    nm_debug.debug('Context NM_SQL: '||l_put);
  end;
  
  
  -------------------------------------------------------------------------------------
  -- The table getters
  --  Note that these functions should be turned into pipelined ones
  --  once in Oracle version where the pipelined data dictionary bug is fixed
  
  
  -- Straight return of the id_tbl. The table must have been filled separately before
  function get_id_tbl return nm_id_tbl
  is
  begin
    return mt_id;
  end;
  
  
  -- This return the id_tbl with one id record - the passed in p_id
  function get_id_tbl(p_id in id_type) return nm_id_tbl
  is
  begin
    mt_id := new nm_id_tbl(p_id);
    return mt_id;
  end;
  
  
  -- This return the id_tbl from a hard coded sys_refcursor
  --  The cursor must be open. It will be closed by the function.
  -- Can be used straight in sql e.g.
  -- select
  --   q.column_value
  -- from 
  --   table(cast(nm3sql.get_id_tbl(cursor(
  --  select e.ne_id
  --  from nm_elements e, nm_types t
  --  where e.ne_nt_type = t.nt_type
  --    and t.nt_datum = 'N'
  --    and t.nt_linear = 'Y')) as nm_id_tbl)
  --   ) q
  function get_id_tbl(p_cur in sys_refcursor) return nm_id_tbl
  is
  begin
    load_id_tbl(p_cur);
    return mt_id;
  end;
  
  
  -- This return the id_tbl from a dynamic sql string
  function get_dynamic_id_tbl(p_cur in varchar2) return nm_id_tbl
  is
  begin
    load_dynamic_id_tbl(p_cur);
    return mt_id;
  end;
  
  
  -- This return the id_tbl from a delimited string of id values
  function get_delim_id_tbl(
     p_string in varchar2
    ,p_delim in varchar2
  ) return nm_id_tbl
  is
  begin
    load_delim_id_tbl(
       p_string => p_string
      ,p_delim  => p_delim
    );
    return mt_id;
  end;
  
  
  
 -- Code table getters
  
  function get_code_tbl return nm_code_tbl
  is
  begin
    return mt_code;
  end;
  --
  function get_code_tbl(p_code in code_type) return nm_code_tbl
  is
  begin
    mt_code := new nm_code_tbl(p_code);
    return mt_code;
  end;
  --
  function get_code_tbl(p_cur in sys_refcursor) return nm_code_tbl
  is
  begin
    load_code_tbl(p_cur);
    return mt_code;
  end;
  --
  function get_dynamic_code_tbl(p_cur in varchar2) return nm_code_tbl
  is
  begin
    load_dynamic_code_tbl(p_cur);
    return mt_code;
  end;
  --
  function get_delim_code_tbl(
     p_string in varchar2
    ,p_delim in varchar2
  ) return nm_code_tbl
  is
  begin
    load_delim_code_tbl(
       p_string => p_string
      ,p_delim  => p_delim
    );
    return mt_code;
  end;
  
  
  -- ID_CODE table getters
  
  function get_id_code_tbl return nm_id_code_tbl
  is
  begin
    return mt_id_code;
  end;
  --
  function get_id_code_tbl(p_rec in nm_id_code_type) return nm_id_code_tbl
  is
  begin
    mt_id_code := new nm_id_code_tbl(p_rec);
    return mt_id_code;
  end;
  --
  function get_id_code_tbl(p_cur in sys_refcursor) return nm_id_code_tbl
  is
  begin
    load_id_code_tbl(p_cur);
    return mt_id_code;
  end;
  --
  function get_dynamic_id_code_tbl(p_cur in varchar2) return nm_id_code_tbl
  is
  begin
    load_dynamic_id_code_tbl(p_cur);
    return mt_id_code;
  end;
  
  
    
  -----------------------------------------
  -- The table loaders
  
  procedure load_id_tbl(p_cur in sys_refcursor)
  is
  begin
    fetch p_cur bulk collect into mt_id;
    close p_cur;
  end;
  --
  procedure load_id_tbl(p_tbl in nm_id_tbl)
  is
  begin
    mt_id := p_tbl;
  end;
  --
  procedure load_dynamic_id_tbl(p_cur in varchar2)
  is
  begin
    execute immediate p_cur bulk collect into mt_id;
  end;
  --
  procedure load_delim_id_tbl(
     p_string in varchar2
    ,p_delim in varchar2
  )
  is
  begin
    split_id_tbl(
       p_tbl    => mt_id      -- out
      ,p_string => p_string   -- in
      ,p_delim  => p_delim    -- in
    );
  end;
  
  
  procedure load_code_tbl(p_cur in sys_refcursor)
  is
  begin
    fetch p_cur bulk collect into mt_code;
    close p_cur;
  end;
  --
  procedure load_code_tbl(p_tbl in nm_code_tbl)
  is
  begin
    mt_code := p_tbl;
  end;
  --
  procedure load_dynamic_code_tbl(p_cur in varchar2)
  is
  begin
    execute immediate p_cur bulk collect into mt_code;
  end;
  --
  procedure load_delim_code_tbl(
     p_string in varchar2
    ,p_delim in varchar2
  )
  is
  begin
    split_code_tbl(
       p_tbl    => mt_code    -- out
      ,p_string => p_string   -- in
      ,p_delim  => p_delim    -- in
    );
  end;
  
  
  
  procedure load_id_code_tbl(p_cur in sys_refcursor)
  is
  begin
    fetch p_cur bulk collect into mt_id_code;
    close p_cur;
  end;
  --
  procedure load_id_code_tbl(p_tbl in nm_id_code_tbl)
  is
  begin
    mt_id_code := p_tbl;
  end;
  --
  procedure load_dynamic_id_code_tbl(p_cur in varchar2)
  is
  begin
    execute immediate p_cur bulk collect into mt_id_code;
  end;
  
  
  
  
  --------------------------------------------------------
  -- counters
  function get_id_tbl_count return number
  is
  begin
    return mt_id.count;
  end;
  --
  function get_code_tbl_count return number
  is
  begin
    return mt_code.count;
  end;
  --
  function get_id_code_tbl_count return number
  is
  begin
    return mt_id_code.count;
  end;
  
  
  --------------------------------------------------------
  -- splitters and joiners

  procedure split_id_tbl(
     p_tbl out nm_id_tbl
    ,p_string in varchar2
    ,p_delim in varchar2
  )
  is
    d       integer := length(p_delim);
    s       integer := length(p_string) + 1;
    i       integer := 1;
    i_last  integer := 1;
  begin
    p_tbl := new nm_id_tbl();
    if p_string is null or p_delim is null then
      return;
    end if;
    loop
      i := instr(p_string, p_delim, i, 1);
      exit when i = 0;
      p_tbl.extend;
      p_tbl(p_tbl.last) := substr(p_string, i_last, i-i_last);
      i := i + d;
      i_last := i;
    end loop;
    p_tbl.extend;
    p_tbl(p_tbl.last) := substr(p_string, i_last, s);
  end;
  --
  procedure join_id_tbl(
     p_string out varchar2
    ,p_tbl in nm_id_tbl
    ,p_delim in varchar2
  )
  is
    i         integer := p_tbl.first;
    l_delim   varchar2(5);
  begin
    if p_delim is null then
      return;
    end if;
    while i is not null loop
      p_string := p_string||l_delim||p_tbl(i);
      l_delim := p_delim;
      i := p_tbl.next(i);
    end loop;
  end;
  
  
  procedure split_code_tbl(
     p_tbl out nm_code_tbl
    ,p_string in varchar2
    ,p_delim in varchar2
  )
  is
  begin
    raise_application_error(-20001, 'Not implemeted');
  end;
  --
  procedure join_code_tbl(
     p_string out varchar2
    ,p_tbl in nm_code_tbl
    ,p_delim in varchar2
  )
  is
  begin
    raise_application_error(-20001, 'Not implemeted');
  end;
  
  
  
  ------------------------------------------------------
  
  
  function get_rounded_cardinality(
     p_cardinality in integer
  ) return integer
  is
    l_cardinality integer;
    
  begin
    l_cardinality := round(p_cardinality, (length(to_char(p_cardinality))-1)*-1);
    case
    when l_cardinality < 2 then null;
    when l_cardinality < 8 then l_cardinality := 5;
    when l_cardinality < 10 then l_cardinality := 10;
    else null;
    end case;
    return l_cardinality;
  end;
  
  
  -- this creates/updates the line in session longops system view
  --  does nothing if rindex is null
  --  starts a new longop row if rindex is -1 (set_session_longops_nohint)
  --  increments the sofar value by p_increment
  -- The idea of this procedure and the longops_rec parameter type is
  --  that subroutines can contribute to the parent procedure's longop
  procedure set_longops(
     p_rec in out longops_rec
    ,p_increment in pls_integer
  )
  is
  begin
    if p_rec.rindex is not null then
      if p_rec.rindex != dbms_application_info.set_session_longops_nohint then
        p_rec.sofar := p_rec.sofar + p_increment;
      end if;
      dbms_application_info.set_session_longops(
         rindex      => p_rec.rindex  -- in out
        ,slno        => p_rec.slno    -- in out
        ,op_name     => p_rec.op_name
        ,context     => p_rec.context
        ,sofar       => p_rec.sofar
        ,totalwork   => p_rec.totalwork
        ,target_desc => p_rec.target_desc
      );
    end if;
  end;

end;
/
