CREATE OR REPLACE package body nm3sql as
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sql.pkb-arc   2.4   Jul 04 2013 16:32:58   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3sql.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:32:58  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
--       PVCS Version     : $Revision:   2.4  $
--       Based on sccs version : 
--
--   Author : Priidu Tanava
--
--   package for generic context 'sql' used to pass bind variables into views
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
/*History
  07.09.07 PT added implementation for split_code_tbl()
  13.09.07 PT added join_sys_refcursor() and null_literal()
*/


  g_body_sccsid     constant  varchar2(30) := '"$Revision:   2.4  $"';
  g_package_name    constant  varchar2(30) := 'nm3sql';

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
  
  
  -- this joins the values from an open cursor that selects one column
  --  varchar2(80) expected, indirect conversion otherwise.
  --  the cursor is closed upon successful completion.
  --  upon error it is the calleres responsability to close the cursror.
  procedure join_sys_refcursor(
     p_string out varchar2
    ,p_cur in sys_refcursor
    ,p_delim in varchar2
  )
  is
    l_delim   varchar2(5);
    l_value   varchar2(80);
  begin
    if p_delim is null then
      return;
    end if;
    loop
      fetch p_cur into l_value;
      exit when p_cur%notfound;
      p_string := p_string||l_delim||l_value;
      l_delim := p_delim;
    end loop;
    close p_cur;
  end;
  
  
  procedure split_code_tbl(
     p_tbl out nm_code_tbl
    ,p_string in varchar2
    ,p_delim in varchar2
  )
  is
    d       integer := length(p_delim);
    s       integer := length(p_string) + 1;
    i       integer := 1;
    i_last  integer := 1;
  begin
    p_tbl := new nm_code_tbl();
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
  
  
  
  -- this returns null literal for sql wrapped in an apropriate format function
  function null_literal(
     p_data_type in varchar2
    ,p_format in varchar2
  ) return varchar2
  is
    l_alias varchar2(32);
  begin
    case upper(p_data_type)
    when 'VARCHAR2' then
      return 'null'||l_alias;
    when 'NUMBER' then
      return 'to_number(null)';
    when 'DATE' then
      if p_format is null then
        return 'to_date(null)';
      else
        return 'to_date(null, '''||p_format||''')';
      end if;
    else
      raise subscript_outside_limit;
    end case;
  end;

end;
/
