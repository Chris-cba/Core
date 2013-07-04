CREATE OR REPLACE PACKAGE BODY nm3analytic_connectivity AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3analytic_connectivity.pkb	1.1 02/01/07
--       Module Name      : nm3analytic_connectivity.pkb
--       Date into SCCS   : 07/02/01 15:45:26
--       Date fetched Out : 07/06/13 14:10:53
--       SCCS Version     : 1.1
--
--
--   Author : Priidu Tanava
--
--   Bulk merge functinality
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

  g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3analytic_connectivity.pkb	1.1 02/01/07"';
  g_package_name    CONSTANT  varchar2(30)   := 'nm3analytic_connectivity';
  
  mc_iterate      number;
  mc_terminate    number;
  mt_chunks       road_chunk_tbl;
  mt_chunk_dups   road_chunk_tbl;
  m_chunk_no      number := 0;
  m_chunk_offset  number := 0;
  
  
  procedure debug_chunks_tbl(
     p_tbl in road_chunk_tbl
  );
  
  
  ------------------------------------------------------
  
  
  
  procedure chunk_no_init
  is
    t road_chunk_tbl;
  begin
    --dbms_output.put_line(g_package_name||'.chunk_no_init');
    mc_iterate := 0;
    mc_terminate := 0;
    mt_chunks := t;
    mt_chunk_dups := t;
    m_chunk_no := 0;
    m_chunk_offset := 0;
  end;
  
  
  
  -- this is called by the nm_analytic_chunk_type.ODCIAggregateIterate()
  -- this is callec once for each aggregated record
  -- the value is a concatenation of 'CHILD ROW_NUM'_'PARENT ROW_NUM'
  --  where child is the current and parent is the previous connected record
  -- store the record in mt_chunks
  -- store the duplicates in mt_chunk_dups
  --  duplicates are children under same parent
  -- the index of mt_chunks is the parent id.
  --  this makes it easy to "loop" through the table using mt_chunks.exists() method
  --  (the limitation here is the largest binary_integer value: 2147483647)
  function chunk_no_iterate(
     p_value in varchar2
  ) return number
  is
    i_row           binary_integer;
    i_parent        binary_integer;
    
    
  begin
    --dbms_output.put_line(g_package_name||'.chunk_no_iterate('||p_value||')');
    
    mc_iterate := mc_iterate + 1;
    i_row := to_number(substr(p_value, 1, instr(p_value, '_') - 1));
    i_parent := to_number(substr(p_value, instr(p_value, '_') + 1));
    
    if i_parent is null then
      m_chunk_no := m_chunk_no + 1;
      i_parent := m_chunk_no * -1;
    end if;
    
    if mt_chunks.exists(i_parent) then
      mt_chunk_dups(i_row).ROW_NUM := i_parent;
      mt_chunk_dups(i_row).ROW_NUM2 := mc_iterate;
      
    else
      mt_chunks(i_parent).ROW_NUM :=  i_row;
      mt_chunks(i_parent).ROW_NUM2 := mc_iterate;
    
    end if;
   
    return mc_iterate;
  end;
  
  

  
  
  -- this processes the mt_chunks table created in chunk_no_iterate()
  --  this is the main processing logic.
  procedure process_mt_chunks
  is
    i           binary_integer;
    k           binary_integer;
    k2          binary_integer;
    n           binary_integer;
    l_chunk_no  number(6) := 0;
    l_order_by  number(6);
    t_chunks    road_chunk_tbl;
    
  begin
  
    /*
    debug_chunks_tbl(mt_chunk_dups);
    dbms_output.put_line('');
    debug_chunks_tbl(mt_chunks);
    dbms_output.put_line('');
    dbms_output.put_line('m_chunk_no='||m_chunk_no);
    dbms_output.put_line('');
    */
    
    
    -- deal with forked routes
    --  if an end node is start for more than one connecting node then
    --    the first chunk goes into mt_chunks
    --    all following chunks go into mt_chunk_dups
    --  here replace the parent connecting node with a new chunk index
    i := mt_chunk_dups.first;
    while i is not null loop
      m_chunk_no := m_chunk_no + 1;
      k := m_chunk_no * -1;
      mt_chunks(k).ROW_NUM := i;
      mt_chunks(k).ROW_NUM2 := mt_chunk_dups(i).ROW_NUM2;
      i := mt_chunk_dups.next(i);
    end loop;
    
    
    -- this outer loop is here to deal with independent circular groups within route
    while mt_chunks.count > 0 loop
    
    
      -- deal with circular routes
      --  in first loop iteration the m_chunk_no equals 0
      --    if there is no entry point into the route (only one or more circular groups)
      --  later loop iterations only happen if there are independent circular groups.
      --    in this case m_chunk_no always equals l_chunk_no
      if m_chunk_no = l_chunk_no then
        i := mt_chunks.first;
        m_chunk_no := m_chunk_no + 1;
        mt_chunks(m_chunk_no * -1) := mt_chunks(i);
        mt_chunks.delete(i);
      end if;
      
      
      -- loop through the chunks
      --  for each chunk_no there is a corresponding mt_chunks index with negative sign 
      for i in l_chunk_no + 1 .. m_chunk_no loop
        l_chunk_no := i;
        l_order_by := 0;
        k := i * -1;
        
        -- start with the chunk_no and loop through all connected chunks
        --  mt_chunks INDEX is the parent(previous) node id
        --    for the first iteration only it is the negatively signed chunk_no
        --  mt_chunks ROWNUM is the child(next) node id
        --  mt_chunks ROWNUM2 is the the true rownumber of the current chunk
        --    by this number the mt_chunks record is linked to the actual query results
        --  t_chunks INDEX is the mt_chunks.rownum2
        --  t_chunks CHUNK_NO is the chunk number assiged by this procedure
        --  t_chunks ORDER_BY is the order seq assigned to the chunk within chunk_no
        -- in the loop:
        --  create a valued t_chunks record
        --  see if there is a next child
        --  delete the "used" mt_chunks record
        while k is not null loop
          n := mt_chunks(k).ROW_NUM2;
          t_chunks(n) := mt_chunks(k);
          t_chunks(n).CHUNK_NO := i;
          l_order_by := l_order_by + 1;
          t_chunks(n).ORDER_BY := l_order_by;
          
          k2 := k;
          k := mt_chunks(k).ROW_NUM;
          if not mt_chunks.exists(k) then
            k := null;
          end if;
          mt_chunks.delete(k2);
  
        end loop;
      
      end loop;
    
      l_chunk_no := m_chunk_no;
    
    end loop;
    
    --debug_chunks_tbl(t_chunks);
    
    
    -- replace the source table with the results table
    --  this makes the results avalilable to chunk_terminate() procedure
    mt_chunks := t_chunks;
    
  end;
  
  
  
  -- this is called by the nm_analytic_chunk_type.ODCIAggregateTerminate()
  --  this is called once for each aggregate result record
  function chunk_terminate return varchar2
  is
  begin
    if mc_terminate = 0 then
      process_mt_chunks;
    end if;
    mc_terminate := mc_terminate + 1;
    if mc_terminate <= mc_iterate then
      return lpad(mt_chunks(mc_terminate).CHUNK_NO, 6, '0')
        ||'_'||lpad(mt_chunks(mc_terminate).ORDER_BY, 6, '0');
    end if;
    return null;
  exception
    -- this can only be that the mc_terminate is larger than mt_chunks.count
    --  meaning that some of the mt_chunks record were left unprocessed
    --  (the curent code in process_mt_chunks() should process all
    --  , so this error shouldn't happen any more)
    when others then
      return null;
  end;
  
  
  
  
  procedure debug_chunks_tbl(
     p_tbl in road_chunk_tbl
  )
  is
    i binary_integer;
  begin
    i := p_tbl.first;
    while i is not null loop
      dbms_output.put_line(i
        ||' '||p_tbl(i).row_num
        ||' '||p_tbl(i).chunk_no
        ||' '||p_tbl(i).order_by
        ||' '||p_tbl(i).row_num2
      );
      i := p_tbl.next(i);
    end loop;
  end;
  
  
--
-----------------------------------------------------------------------------
--
END;
/
