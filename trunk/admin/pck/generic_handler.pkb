--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/generic_handler.pkb-arc   2.1   Jul 04 2013 14:36:16   James.Wadsworth  $
--       Module Name      : $Workfile:   generic_handler.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:36:16  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:34:22  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
/* Formatted on 2004/08/27 14:22 (Formatter Plus v4.8.5) */
Create Or Replace Package Body generic_handler
Is
  nbsp   Constant Varchar (6) := '&' || 'nbsp;';
  type sys_refcursor is ref cursor ; -- Delete for 9i!

  -- local helpers
  Procedure append (
    p_target   In Out   Varchar
  , p_string   In       Varchar
  , p_separator in varchar default ' '
  )
  Is
  Begin
--      print (p_string);
    p_target := p_target || p_separator || p_string;
  End append;

  Function enquote (
    p_string   In   Varchar
  )
    Return Varchar
  Is
  Begin
    Return '''' || p_string || '''';
  End enquote;

  function key_part
    ( p_name in varchar
    , p_keys vc_arr
    ) return boolean
    is
  begin
    for i in  1..p_keys.count
    loop
      if upper(p_keys(i)) = upper(p_name)
      then
        return true ;
      end if;
    end loop;
    return false ;
  end key_part ;
  --
  function gen_composite_key_names
    ( p_key_names vc_arr
    )
  return varchar
  is
  delimiter delim_string ;
  out_string big_string ;
  begin
    delimiter := '(' ;
    for i in  1..p_key_names.count
    loop
      append( out_string, delimiter|| p_key_names(i) );
      delimiter := ',' ;
    end loop;
    if out_string is not null
    then
      append(out_string ,')' ) ;
    end if;
    return out_string ;
  end gen_composite_key_names;
  function gen_composite_key_select
    ( p_key_names vc_arr
    )
  return varchar
  is
  delimiter delim_string ;
  out_string big_string ;
  begin
    delimiter := '''(''||' ;
    for i in  1..p_key_names.count
    loop
      append( out_string, delimiter|| p_key_names(i) );
      delimiter := '||'',''||' ;
    end loop;
    if out_string is not null
    then
      append(out_string ,'||'')''' ) ;
    end if;
    return out_string ;
  end gen_composite_key_select;
  function gen_composite_key_values
    ( p_key_values vc_arr
    )
  return varchar
  is
  delimiter delim_string ;
  out_string big_string ;
  begin
    delimiter := '(' ;
    for i in  1..p_key_values.count
    loop
      append( out_string, delimiter || enquote(p_key_values(i)) );
      delimiter := ',' ;
    end loop;
    if out_string is not null
    then
      append(out_string ,')' ) ;
    end if;
    return out_string ;
  end gen_composite_key_values;
  Procedure print (
    p_mesg   In   Varchar
  )
  Is
  Begin
    htp.p (p_mesg);
  End print ;

  -- If the key values are in the string they will be of the form
  -- ('x','y'..)
  -- otherwise they'll be in the key_values table
  Function get_by_key (
    p_query_table   In   table_handler
  , p_key_values    In   vc_arr
  , p_composite_key_values In   varchar default null
  )
    Return table_handler
  Is
    query_string   big_string;
    into_clause    big_string;
    return_th      table_handler;
    delimiter      delim_string;
    cursor_i       Integer;
    offset         Integer;
    n_rows         Integer;
    composite_key_values  big_string := p_composite_key_values ;
    composite_key_names   big_string ;
    
  Begin
--    print (p_key_string);

    return_th := p_query_table ;

    g_return_values.delete ;

    if composite_key_values is null
    then
      composite_key_values := gen_composite_key_values( p_key_values ) ;
    else
      -- Put quotes around what's in the generated composite key
      composite_key_values := replace( composite_key_values, ',', ''',''' ) ;
      composite_key_values := replace( composite_key_values, '(', '(''' ) ;
      composite_key_values := replace( composite_key_values, ')', ''')' ) ;
    end if;

    if composite_key_values is null
    then
      raise_application_error(-20001,'Could not find key');
    end if;

    -- in order to do a query ( x, y, z ) = ( 'q', 'r', 's' )
    -- we need to select it from somewhere to make the syntax
    -- right
    composite_key_values := replace( composite_key_values, '(', '( select ' ) ;
    composite_key_values := replace( composite_key_values, ')', ' from dual )' ) ;

    composite_key_names := gen_composite_key_names( p_query_table.primary_key_name ) ;

    append (query_string, 'select * ');
    delimiter := '';

    -- Query back name and actual value
    For i In
      p_query_table.names_values.Name.First .. p_query_table.names_values.Name.Last
    Loop
      If p_query_table.names_values.Name.Exists (i)
      Then
        g_return_values(i) := '' ;
        append( into_clause, delimiter || 'generic_handler.g_return_values( ' || i || ') ' ) ;
        delimiter := ',';
      End If;
    End Loop;

    append (query_string, 'into ' || into_clause ) ;
    append (query_string, 'from ' || p_query_table.table_owner || '.' || p_query_table.table_name);
    append (query_string, 'where  ' || composite_key_names || ' = ' || composite_key_values ) ;
    append (query_string, '  and rownum < 20 ' ) ;
    
    --htp.p( query_string ) ;
    execute immediate 'begin ' || query_string || ' ; end;' ;

    return_th.names_values.value := g_return_values ;
    
    for i in  1..return_th.primary_key_name.count
    loop
      return_th.primary_key_value(i) := get_column( return_th.primary_key_name(i), return_th.names_values ) ;
    end loop;

    Return return_th;
  Exception
    When Others
    Then
      If dbms_sql.is_open (cursor_i)
      Then
        dbms_sql.close_cursor (cursor_i);
      End If;
      htp.p(query_string) ;
      Raise;
  End get_by_key ;

  -- Helper functions
  Function get_primary_key_name (
    p_table_name   In   Varchar
  , p_table_owner  In   Varchar default user  
  )
    Return vc_arr
  Is
    key_names   vc_arr;
  Begin
    Select   acc.column_name
    Bulk Collect Into key_names
    From     all_cons_columns acc, all_constraints ac
    Where    ac.constraint_type = 'P'
    And      acc.constraint_name = ac.constraint_name
    And      acc.table_name = ac.table_name
    And      acc.table_name = upper (p_table_name)
    and      ac.owner = acc.owner
    and      acc.owner = p_table_owner
    Order By acc.Position;

    Return key_names ;
  End get_primary_key_name;

  -- gimme an empty table handler type
  Function construct_table (
    p_table_name          In   Varchar
  , p_primary_key_name    In   vc_arr
  , p_primary_key_value   In   vc_arr
  , p_table_owner         In   Varchar default user
  )
    Return table_handler
  Is
    new_handler    table_handler;
    column_names   vc_arr;
  Begin
    new_handler.table_owner := upper (p_table_owner);
    new_handler.table_name := upper (p_table_name);
    new_handler.primary_key_name := p_primary_key_name;
    new_handler.primary_key_value := p_primary_key_value;

    If new_handler.primary_key_name.count = 0
    Then
      new_handler.primary_key_name := get_primary_key_name (p_table_name,p_table_owner);
    End If;

    Select   column_name, Null
    Bulk Collect Into new_handler.names_values.Name, new_handler.names_values.Value
    From     all_tab_columns
    Where    table_name = new_handler.table_name
    and      owner      = new_handler.table_owner
    Order By column_id;

    If Sql%Rowcount = 0
    Then
      raise_application_error (-20001
      , 'Could not get column names for table ' || new_handler.table_owner || '.' || new_handler.table_name);
    End If;

    Return new_handler;
  End construct_table;

  Function construct_table (
    p_table_name          In   Varchar
  , p_primary_key_value   In   vc_arr default empty_vc_arr
  , p_table_owner         In   Varchar default user
  )
    Return table_handler
  Is
  Begin
    Return construct_table (
            p_table_name
          , empty_vc_arr
          , p_primary_key_value
          , p_table_owner
          );
  End construct_table;

  Procedure set_column (
    p_column_name    In       Varchar
  , p_column_value   In       Varchar
  , p_nv_list        In Out   name_value
  )
  Is
  Begin

    <<search>>
    For i In p_nv_list.Name.First .. p_nv_list.Name.Last
    Loop
      If p_nv_list.Name.Exists (i)
      Then
        If upper (p_nv_list.Name (i)) = upper (p_column_name)
        Then
          p_nv_list.Value (i) := p_column_value;
          Exit search;
        End If;
      End If;
    End Loop;
  End set_column;

  Procedure remove_column (
    p_column_name   In       Varchar
  , p_nv_list       In Out   name_value
  )
  Is
  Begin

    <<search>>
    For i In p_nv_list.Name.First .. p_nv_list.Name.Last
    Loop
      If p_nv_list.Name.Exists (i)
      Then
        If upper (p_nv_list.Name (i)) = upper (p_column_name)
        Then
          p_nv_list.Name.Delete (i);
          p_nv_list.Value.Delete (i);
          Exit search;
        End If;
      End If;
    End Loop;
  End remove_column;

  Procedure add_column (
    p_column_name    In       Varchar
  , p_column_value   In       Varchar
  , p_nv_list        In Out   name_value
  )
  Is
  Begin
    p_nv_list.Name (p_nv_list.Name.Last + 1) := p_column_name;
    p_nv_list.Value (p_nv_list.Value.Last + 1) := p_column_value;
  End  add_column;

  Function get_column (
    p_column_name   In       Varchar
  , p_nv_list       In Out   name_value
  )
    Return Varchar
  Is
  Begin

    <<search>>
    For i In p_nv_list.Name.First .. p_nv_list.Name.Last
    Loop
      If p_nv_list.Name.Exists (i)
      Then
        If upper (p_nv_list.Name (i)) = upper (p_column_name)
        Then
          Return p_nv_list.Value (i);
        End If;
      End If;
    End Loop;
    return '' ;
  End get_column ;

  -- Main functions - convention is that error messages
  Function get_row (
    p_table_name   In   Varchar
  , p_key_name     In   vc_arr
  , p_key_value    In   vc_arr
  , p_table_owner  In   Varchar default user
  )
    Return table_handler
  Is
    new_handler   table_handler;
  Begin

    new_handler := get_by_key( construct_table(p_table_name=>p_table_name,p_table_owner=>p_table_owner), p_key_value ) ;

    Return new_handler;
  End get_row;

  Function get_row_key_list (
    p_query_table   In   table_handler
  )
    Return key_list
  Is
    return_set     key_list;
    query_string   big_string;
    delimiter      delim_string;
    fetch_cursr    sys_refcursor ;
    counter        binary_integer ;

  Begin
 
    If p_query_table.names_values.Name.Count = 0
     or p_query_table.names_values.Value.Count = 0
    Then
      raise_application_error (-20001
      , 'get_row_key_list: Table handler has no names/values');
    End If;

    append (query_string, 'select ' || gen_composite_key_select(p_query_table.primary_key_name) || ' ' );
    append (query_string, 'from ' || p_query_table.table_owner || '.' || p_query_table.table_name);
    delimiter := 'where ';

    For i In
      p_query_table.names_values.Name.First .. p_query_table.names_values.Name.Last
    Loop
      If     p_query_table.names_values.Name.Exists (i)
         And p_query_table.names_values.Value (i) Is Not Null
      Then
        append (query_string
        , delimiter || p_query_table.names_values.Name (i));

        If instr (p_query_table.names_values.Value (i), '%') = 0
        Then
          append (query_string, '=');
        Else
          append (query_string, 'like');
        End If;

        append (query_string, enquote (p_query_table.names_values.Value (i)));
        delimiter := 'and ';
      End If;
    End Loop;


    /* 9i
    Execute Immediate query_string
    Bulk Collect Into return_set;
    */
    counter := 0 ;
    open fetch_cursr for query_string ;
    loop
      counter := counter + 1 ;
      fetch fetch_cursr into return_set(counter) ;
      exit when fetch_cursr%notfound ;
    end loop ;
    close fetch_cursr ;
    Return return_set;
  exception
    when others then 
      raise_application_error(-20001, 'get_row_key_list: error fetching ' || query_string || ' : ' || sqlerrm ) ;
  End get_row_key_list;

  Procedure update_row (
    p_table_handler   In   table_handler
  )
  Is
    update_string   big_string;
    delimiter       delim_string;
  Begin
    append (update_string, 'update ' || p_table_handler.table_owner || '.' || p_table_handler.table_name);
    delimiter := 'set ';

    For i In
      p_table_handler.names_values.Name.First .. p_table_handler.names_values.Name.Last
    Loop
      If     p_table_handler.names_values.Name.Exists (i)
         And not key_part(p_table_handler.names_values.Name(i),p_table_handler.primary_key_name)
                                         
      Then
        append (update_string
        ,    delimiter
          || p_table_handler.names_values.Name (i)
          || '='
          || enquote (p_table_handler.names_values.Value (i)));
        delimiter := ',';
      End If;
    End Loop;

    delimiter := ' where ' ;
    for i in 1..p_table_handler.primary_key_name.count
    loop
      append (update_string
      ,    delimiter
        || p_table_handler.primary_key_name(i)
        || '='
        || enquote (p_table_handler.primary_key_value(i)));
      delimiter := ' and ' ;
    end loop ;

    Execute Immediate update_string;

    --htp.p('Update called - ' || update_string ) ;
    commit ;

  End update_row;

  Procedure delete_row (
    p_table_handler   In   table_handler
  )
  Is
    delete_string   big_string;
    delimiter       delim_string;
  Begin
    delete_string :=
         'delete '
      || p_table_handler.table_owner || '.' || p_table_handler.table_name ;

    delimiter :=  ' where ' ;
    for i in  1..p_table_handler.primary_key_name.count
    loop
      append( delete_string,
        p_table_handler.primary_key_name(i)
        || '='
        || enquote (p_table_handler.primary_key_value(i))
        );
    end loop;

    Execute Immediate delete_string;
  End delete_row;

  -- Dummy implementation
  Function get_next_key (
    p_table_name   In   Varchar
  )
    Return Integer
  Is
  Begin
    raise_application_error(-20001,'Get next key not supported');
    Return dbms_random.random;
  End get_next_key;

  -- Key is returned in the string
  Function insert_row (
    p_table_handler   In   table_handler
  )
    Return table_handler
  Is
    new_handler     table_handler := p_table_handler;
    insert_string   big_string;
    delimiter       delim_string;
  Begin
    raise_application_error(-20001,'*** Insert Function not supported - no support for generating proper keys ***' ) ;
    for i in 1..p_table_handler.primary_key_value.count
    loop
      -- ERROR HERE NEED TO GET OWNER OF TABLE TOO
      new_handler.primary_key_value(i) := get_next_key (new_handler.table_name);
      set_column (
        new_handler.primary_key_name(i)
      , new_handler.primary_key_value(i)
      , new_handler.names_values
      );
    end loop ;
    dump_handler (p_table_handler);
    dump_handler (new_handler);
    append (insert_string, 'insert into ' || new_handler.table_owner || '.' || new_handler.table_name);
    delimiter := '(';

    For i In
      p_table_handler.names_values.Name.First .. p_table_handler.names_values.Name.Last
    Loop
      If p_table_handler.names_values.Name.Exists (i)
      Then
        append (insert_string
        , delimiter || new_handler.names_values.Name (i));
        delimiter := ',';
      End If;
    End Loop;

    append (insert_string, ') values ');
    delimiter := '(';

    For i In
      p_table_handler.names_values.Name.First .. p_table_handler.names_values.Name.Last
    Loop
      If p_table_handler.names_values.Name.Exists (i)
      Then
        append (insert_string
        , delimiter || enquote (new_handler.names_values.Value (i)));
        delimiter := ',';
      End If;
    End Loop;

    append (insert_string, ')');

    --print (insert_string);
    Execute Immediate insert_string;

    Return new_handler;
  End insert_row;

  -- Debug procedures
  Procedure dump_handler (
    p_table_handler   In   table_handler
  )
  Is
  Begin
    If p_table_handler.names_values.Name.Count = 0
    Then
      raise_application_error
                           (-20001
      , 'dump_handler: Table handler has no names/values');
    End If;

    print ('table = ' || p_table_handler.table_owner || '.' || p_table_handler.table_name);
    for i in  1..p_table_handler.primary_key_name.count
    loop
      print ('primary key name = ' || p_table_handler.primary_key_name(i));
      print ('primary key value = ' || p_table_handler.primary_key_value(i));
    end loop;

    For i In
      p_table_handler.names_values.Name.First .. p_table_handler.names_values.Name.Last
    Loop
      If p_table_handler.names_values.Name.Exists (i)
      Then
        print ('column '
          || i
          || ' '
          || p_table_handler.names_values.Name (i)
          || ' = '
          || p_table_handler.names_values.Value (i));
      End If;
    End Loop;
  End dump_handler;

  Procedure dump_key_list (
    p_key_list   In   key_list
  )
  Is
  Begin
    If p_key_list.Count = 0
    Then
      print ('EMPTY SET');
      Return;
    End If;

    For i In p_key_list.First .. p_key_list.Last
    Loop
      If p_key_list.Exists (i)
      Then
        print ('------- ROW ' || i || ' ------');
        print (p_key_list (i));
      End If;
    End Loop;
  End dump_key_list;

  Procedure html_open
  Is
  Begin
    htp.p ('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
    htp.p ('<html>');
    htp.p ('<title>Generic table handler web application</title>');
    htp.p ('<head>');
    htp.p ('</head>');
    htp.p ('<body>');
  End html_open;

  Procedure html_close
  Is
  Begin
    htp.p ('</body>');
    htp.p ('</html>');
  End html_close;

  Procedure nullspace (
    p_arg   In   Varchar
  )
  Is
  Begin
    If p_arg Is Not Null
    Then
      htp.p (p_arg);
    Else
      htp.p (nbsp);
    End If;
  End nullspace;

  Procedure print_pair (
    p_left    Varchar
  , p_right   Varchar
  )
  Is
  Begin
    htp.p ('<tr>');
    htp.p ('<td>');
    nullspace (p_left);
    htp.p ('</td>');
    htp.p ('<td>');
    nullspace (p_right);
    htp.p ('</td>');
    htp.p ('</tr>');
  End print_pair;

  Procedure display_row (
    p_names              vc_arr
  , p_values             vc_arr
  , p_primary_key_name   vc_arr
  , p_do_edit            Boolean Default False
  , p_query_screen       Boolean Default False
  )
  Is
  Begin
    For i In p_names.First .. p_names.Last
    Loop
      htp.p ('<tr>');
      htp.p ('<td>');
      htp.p (p_names (i));
      htp.p ('</td>');
      htp.p ('<td>');

      If p_do_edit
      Then
        htp.p ('<input type="hidden" name="p_column_names" value="'
          || p_names (i)
          || '">');

        If     key_part(p_names (i), p_primary_key_name )
           And Not p_query_screen
        Then
          htp.p ('<input type="hidden" name="p_column_values" value="'
            || p_values (i)
            || '">');
          htp.p (p_values (i));
        Else
          htp.p ('<input type="text" name="p_column_values" value="'
            || p_values (i)
            || '" size="50">');
        End If;
      Else
        htp.p (p_values (i));
      End If;

      htp.p ('</td>');
      htp.p ('</tr>');
    End Loop;
  End display_row;

  Procedure web_edit_row (
    p_table_name    In   Varchar
  , p_primary_key   In   vc_arr
  )
  Is
    handler   table_handler;
    delimiter delim_string ;
  Begin
    html_open;

    Begin
      handler :=
        get_row (
          p_table_name
        , get_primary_key_name (p_table_name)
        , p_primary_key
        );
      htp.p ('<form name="table" action="./generic_handler.web_save_row" method="post" >');
      htp.p ('<table>');
      htp.p ('<tr>');
      htp.p ('<td colspan="2"><a href="javascript:window.close();">Close this window</a></td>');
      htp.p ('</tr>');
      htp.p ('<tr>');
      htp.p ('<td>');
      htp.p (handler.table_owner || '.' || handler.table_name);
      htp.p ('<input type="hidden" name="p_table_name" value="'
        || handler.table_name
        || '">');
      htp.p ('<input type="hidden" owner="p_table_owner" value="'
        || handler.table_owner
        || '">');
      htp.p ('</td>');
      htp.p ('<td>(');
      delimiter := '' ;
      for i in  1..p_primary_key.count
      loop
        htp.p (delimiter||p_primary_key(i));
        delimiter := ',';
      end loop;
      htp.p (')</td></tr>');
      display_row (
        handler.names_values.Name
      , handler.names_values.Value
      , handler.primary_key_name
      , True
      );
      print_pair ('<input type="submit" value="Save Changes">'
      , '<input type="reset">');
      htp.p ('</table>');
      htp.p ('</form>');
    Exception
      When Others
      Then
        htp.p (sqlerrm);
    End;
  End web_edit_row;

  Procedure web_show_row (
    p_table_name    In   Varchar
  , p_primary_key   In   vc_arr
  , p_edit          In   Boolean Default False
  , p_standalone    In   Boolean Default True
  , p_table_owner   In   varchar
  , p_table         in   table_handler default empty_handler
  )
  Is
    handler   table_handler := p_table ;
    work_buffer big_string ;
    delimiter delim_string ;
    primary_key_values vc_arr ;
  Begin
    If Not p_standalone
    Then
      html_open;
    End If;

    Begin
      if handler.table_name is null
      then
        handler :=
          get_row (
            p_table_name
          , get_primary_key_name (p_table_name)
          , p_primary_key
          , p_table_owner
          );
      end if ;
      htp.p ('<table>');
      htp.p ('<tr>');
      htp.p ('<td>' || handler.table_owner || '.' || handler.table_name || ' ');
      delimiter := '' ;
      for i in  1..p_primary_key.count
      loop
        htp.p (delimiter||p_primary_key(i));
        delimiter := ',';
      end loop;
      If p_edit
      Then
        work_buffer := '<a href="./generic_handler.web_edit_row?p_table_name=' || p_table_name ;
        delimiter := '&' ;
        primary_key_values := p_primary_key ;
        if primary_key_values.count = 0
        then
          primary_key_values := handler.primary_key_value ;
        end if;
        for i in  1..primary_key_values.count
        loop
          append (work_buffer,delimiter||'p_primary_key='||primary_key_values(i),'');
        end loop;

        append( work_buffer,'" target="_new">Edit</a>' ) ;
        htp.p( work_buffer ) ;
      End If;

      htp.p ('</td>');
      display_row (
        handler.names_values.Name
      , handler.names_values.Value
      , handler.primary_key_name
      , False
      );
      htp.p ('</table>');

      If Not p_standalone
      Then
        html_close;
      End If;
    Exception
      When Others
      Then
        htp.p (sqlerrm);
    End;
  End web_show_row;

  Procedure web_save_row (
    p_table_name      In   Varchar
  , p_column_names    In   vc_arr
  , p_column_values   In   vc_arr
  , p_table_owner  In   Varchar default user
  )
  Is
    handler   table_handler;
  Begin
    handler := construct_table (p_table_name=>p_table_name,p_table_owner=>p_table_owner);
    handler.names_values.Name := p_column_names;
    handler.names_values.Value := p_column_values;
    for i in  1..handler.primary_key_name.count
    loop
      handler.primary_key_value(i) :=
                  get_column (handler.primary_key_name(i), handler.names_values);
    end loop;
    update_row (handler);
    web_show_row (
      p_table_name =>      handler.table_name
    , p_table_owner =>     handler.table_owner
    , p_primary_key =>     handler.primary_key_value
    , p_edit =>            True
    , p_standalone =>      False
    );
  Exception
    When Others
    Then
      htp.p (sqlerrm);
  End web_save_row;

  Procedure web_browse_rows (
    p_table_name      In   Varchar Default Null
  , p_column_names    In   vc_arr Default empty_vc_arr
  , p_column_values   In   vc_arr Default empty_vc_arr
  , p_table_owner  In   Varchar default user
  )
  Is
    query_handler   table_handler;
    display_table   table_handler;
    output_ds       key_list;
  Begin
    html_open;
    /*
    for i in 1..p_column_names.count
    loop
      htp.p( p_column_names(i) || '=' || p_column_values(i) || '<br />' ) ;
    end loop ;
    */
    htp.p
      ('<form name="browse_rows" action="./generic_handler.web_browse_rows" method="post" >');
    htp.p ('<table>');

    If p_table_name Is Null
    Then
      -- Get table name
      print_pair ('Please input table name to browse data'
      , '<input name="p_table_name" type="text">');
    Else
      query_handler := construct_table (p_table_name=>p_table_name,p_table_owner=>p_table_owner);
      If p_column_values.Count <> 0
      Then
        query_handler.names_values.Name := p_column_names;
        query_handler.names_values.Value := p_column_values;
        output_ds := get_row_key_list (query_handler);
        If output_ds.Count > 0
        Then
          For i In output_ds.First .. output_ds.Last
          Loop
            htp.p ('<tr>');
            htp.p ('<td colspan="2">');
            display_table := get_by_key( query_handler, empty_vc_arr, output_ds(i) ) ;
            web_show_row (
              p_table_name =>      display_table.table_name
            , p_table_owner =>     display_table.table_owner
            , p_primary_key =>     display_table.primary_key_value
            , p_edit =>            True
            , p_standalone =>      False
            , p_table      =>      display_table
            );
            htp.p ('</td>');
            htp.p ('</tr>');
          End Loop;
        else
          htp.p ('<tr>');
          htp.p ('<td colspan="2">');
          htp.p ('*** No data found for your query criteria ***' ) ;
          htp.p ('</td>');
          htp.p ('</tr>');
        End If;

      End If;

      print_pair
             ('Browse data for table'
      ,    '<input name="p_table_name" type="hidden" value="'
        || p_table_name
        || '">'
        || p_table_name
        || ' <a href="./generic_handler.web_browse_rows">Change table</a>');

      print_pair ('Please enter your query criteria:', '');
      htp.p ('<tr>');
      htp.p ('<td colspan="2">');
      display_row (
        p_names =>                query_handler.names_values.Name
      , p_values =>               query_handler.names_values.Value
      , p_primary_key_name =>     query_handler.primary_key_name
      , p_do_edit =>              True
      , p_query_screen =>         True
      );
      htp.p ('</td>');
      htp.p ('</tr>');
    End If;

    print_pair ('<input type="submit" value="Send Query">'
    , '<input type="reset">');

    htp.p ('</table>');
    htp.p ('</form>');
    html_close;
  Exception
    When Others
    Then
      htp.p (sqlerrm);
  End web_browse_rows;
End generic_handler;
/
sho err
