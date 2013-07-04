create or replace package body apitest is
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/apitest.pkb-arc   2.1   Jul 04 2013 14:27:34   James.Wadsworth  $
--       Module Name      : $Workfile:   apitest.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:27:34  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:06  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on SCCS Version     : 1.2
--
--
--   Author : F J Fish
--
--   Package for testing PL/SQL APIs. Delivered as a series of HTML forms.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- all global package variables here
--
  g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.1  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
  TYPE tab_number       IS TABLE OF number          INDEX BY binary_integer;
  g_package_name    CONSTANT  varchar2(30)   := 'apitest';
  g_page big_varchar2 := 
'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>${title}</title>
  ${script}
</head>
<body>
<h1>${title}</h1>
<form id="apiForm" action="./${target}" method="post">
${form_body}
</form>
</body>' ;
--
-----------------------------------------------------------------------------
--
--
-------------------------------------------------------------------- ---------
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
-----------------------------------------------------------------------------
--

  procedure send_in_bits
    ( p_thing in varchar2
    ) is
  start_ integer := 1 ;
  end_   integer := 1 ;
  part_size constant integer := 256 ;
  begin
    while start_ < length(p_thing)
    loop
      end_ := start_ + part_size ;
      htp.p( substr( p_thing, start_, part_size )) ;
      start_ := end_ + 1 ;
    end loop;
  end ;
  procedure render_page
    ( p_title     in varchar2 
    , p_action    in varchar2
    , p_form_body in varchar2
    , p_script    in varchar2 default null
    ) is
  work_string big_varchar2 := g_page ;
  begin
    work_string := replace ( work_string , '${title}' , p_title ) ;
    work_string := replace ( work_string , '${form_body}' , p_form_body ) ;
    work_string := replace ( work_string , '${target}' , p_action ) ;
    work_string := replace ( work_string , '${script}' , p_script ) ;
    htp.p(work_string ) ;
  end;
  procedure render_page
    ( p_title     in varchar2 
    , p_action    in varchar2
    , p_form_body in owa_util.vc_arr 
    , p_script    in varchar2 default null
    ) is
  l_page_part big_varchar2 := g_page ;
  begin
    l_page_part := replace ( l_page_part , '${title}' , p_title ) ;
    l_page_part := replace ( l_page_part , '${target}' , p_action ) ;
    l_page_part := replace ( l_page_part , '${script}' , p_script ) ;
    htp.p( substr( l_page_part, 1, instr( l_page_part, '${form_body}' ) - 1 ) ) ;
    for i in  1..p_form_body.count
    loop
      htp.p( p_form_body(i) ) ;
    end loop;
    l_page_part := substr( l_page_part, instr( l_page_part, '${form_body}' ) + length('${form_body}')  ) ;
    htp.p( l_page_part ) ;
  end;
--
-----------------------------------------------------------------------------
--
-- This private function will return who owns the package
-- used for any call backs to prevent the use of synoynms picking up the
-- wrong guy...
-- Needs to get it from dual to get what permissions we are running with
-- not who we are running it as - confused? You will be ...
--
  function get_callback_schema( p_object_name in varchar2 default null ) return varchar2
  is
  q varchar2(200);
  begin
    select sys_context( 'userenv', 'current_schema') || '.' || p_object_name
    into q from dual ;
    return q ;
  end get_callback_schema ;
--
-----------------------------------------------------------------------------
--
  procedure ask_for_procedure 
  is
  begin
    render_page
    ( p_title     => 'Specify package and procedure to run'
    , p_action    => get_callback_schema( g_package_name || '.show_parameters' )
    , p_form_body => '<table>' || chr(10) || 
                     '<tr><td>Owner                </td><td><input type="text" name="p_package_owner" id="p_package_owner" value="' || replace(get_callback_schema,'.','') || '"/></td></tr>' || chr(10) ||
                     '<tr><td>Package (optional)   </td><td><input type="text" name="p_package_name" id="p_package_name" /></td></tr>' || chr(10) ||
                     '<tr><td>Procedure or function</td><td><input type="text" name="p_proc_name" id="p_proc_name" /></td></tr>' || chr(10) ||
                     '<tr><td colspan="2"><input type="submit" value="proceed" /></td></tr>' || chr(10) ||
                     '</table>' || chr(10)
    ) ;
  end ask_for_procedure ;
--
-----------------------------------------------------------------------------
--
  procedure show_parameters
    ( p_package_owner in varchar2
    , p_package_name  in varchar2
    , p_proc_name     in varchar2
    ) is
  l_package_owner varchar2(50) := upper(p_package_owner) ;
  l_package_name varchar2(50) := upper(p_package_name) ;
  l_proc_name varchar2(50) := upper(p_proc_name) ;
  l_name varchar2(200) := l_package_owner || '.' || l_package_name || '.' || l_proc_name ;
  l_form_body owa_util.vc_arr ;
  l_form_body_count integer := 1 ;
  l_script    big_varchar2 ;
  CURSOR cs_overload 
    ( c_owner varchar2
    , c_pack  varchar2
    , c_proc  varchar2
    ) IS
  SELECT overload
  FROM  all_arguments
  WHERE  owner        = c_owner
  AND   package_name = c_pack
  AND   object_name  = c_proc
  GROUP BY overload;
  CURSOR cs_args 
    ( c_owner varchar2
    , c_pack  varchar2
    , c_proc  varchar2
    , c_over  NUMBER
    , c_arg   varchar2
    ) IS
  SELECT *
  FROM  all_arguments
  WHERE  owner           = c_owner
  AND   package_name    = c_pack
  AND   object_name     = c_proc
  AND   argument_name   = c_arg
  AND   NVL(overload,'0') = NVL(c_over,'0')
  ORDER BY sequence;
  cs_rec all_arguments%rowtype ;
  l_tab_overload tab_number;
--
  l_data_type    varchar2(100);
  l_overload     dbms_describe.number_table;
  l_position     dbms_describe.number_table;
  l_c_level      dbms_describe.number_table;
  l_arg_name     dbms_describe.varchar2_table;
  l_dty          dbms_describe.number_table;
  l_def_val      dbms_describe.number_table;
  l_p_mode       dbms_describe.number_table;
  l_length       dbms_describe.number_table;
  l_precision    dbms_describe.number_table;
  l_scale        dbms_describe.number_table;
  l_radix        dbms_describe.number_table;
  l_spare        dbms_describe.number_table;
  l_idx          integer := 0;
  
  procedure append( p_stuff in varchar2 ) is
  begin
    l_form_body(l_form_body_count) := p_stuff ;
    l_form_body_count := l_form_body_count + 1 ;
  end append ;
  procedure append_script( p_stuff in varchar2 ) is
  begin
    if l_script is null
    then
      l_script := '<script type="text/javascript">' ;
    end if ;
    l_script := l_script || chr(10) || p_stuff ;
  end append_script ;
  begin
    append_script( 'function  doCheck( checkBox, id ) {' ) ;
    append_script( '  if(checkBox.checked){ ' ) ;
    append_script( '    document.forms.apiForm.p_use_default[id].value = "Y";' ) ;
    append_script( '  }else{' ) ;
    append_script( '    document.forms.apiForm.p_use_default[id].value = "N";' ) ;
    append_script( '  }' ) ;
    append_script( '}' ) ;
    append(
'<input type="hidden" id="p_package_name" name="p_package_name" value="' || l_package_name ||'" />
<input type="hidden" id="p_package_owner" name="p_package_owner" value="' || l_package_owner ||'" />
<input type="hidden" id="p_proc_name" name="p_proc_name" value="' || l_proc_name ||'" />
<table>
<tr>
<th colspan="4">Run ' || l_package_owner || '.' || l_package_name || '.' || l_proc_name ||' </th>
</tr>') ;
      OPEN  cs_overload (l_package_owner, l_package_name, l_proc_name);
      FETCH cs_overload BULK COLLECT INTO l_tab_overload;
      CLOSE cs_overload;
      IF l_tab_overload.COUNT = 0
      THEN
        append(htf.small('Could not find this procedure, please press the back button and try again'));
      ELSIF l_tab_overload.COUNT > 1
      THEN
        append( '*** Overloaded functions and procedures are not supported ***' ) ;
      else
        append(
'<tr>
  <th>Position</th>
  <th>Argument</th>
  <th>Value</th>
  <th>Use<br />Default</th>
  <th>Has<br />Default</th>
  <th>In/Out</th>
  <th>Type</th>
</tr>' 
        ) ;
      DBMS_DESCRIBE.DESCRIBE_PROCEDURE
        ( OBJECT_NAME    =>  l_name
        , RESERVED1      => null
        , RESERVED2      => null
        , OVERLOAD       => l_overload
        , POSITION       => l_position
        , LEVEL          => l_c_level
        , ARGUMENT_NAME  => l_arg_name
        , DATATYPE       => l_dty
        , DEFAULT_VALUE  => l_def_val
        , IN_OUT         => l_p_mode
        , LENGTH         => l_length
        , PRECISION      => l_precision
        , SCALE          => l_scale
        , RADIX          => l_radix
        , SPARE          => l_spare
        );
       for i in  1..l_position.count
       LOOP
         append(htf.tablerowopen) ;
         open cs_args (l_package_owner, l_package_name, l_proc_name, l_tab_overload(1),l_arg_name(i));
         fetch cs_args 
         into cs_rec 
         ;
         close cs_args ;
         append(htf.tabledata(l_position(i)));
         append('<td>');
         append('<input type="hidden" name="p_arg_names" id="p_arg_names" value="' || l_arg_name(i) || '" />' ) ;
         append('<input type="hidden" name="p_arg_in_out" id="p_arg_in_out" value="' || cs_rec.in_out || '" />' ) ;
         append(l_arg_name(i));
         append('</td>');
         append(htf.tabledata('<input type="text" name="p_arg_values" id="p_arg_values" />'));
         
         if l_def_val(i) = 1
         then
           append(htf.tabledata('<input type="hidden" name="p_use_default" id="p_use_default" value="Y" checked="checked" />'||
                                '<input type="checkbox" value="Y" checked="checked" onClick="doCheck(this,' || to_char(i-1) || ');"/>'));
           append(htf.tabledata(htf.small('Y')));
         else
           append(htf.tabledata('<input type="hidden" name="p_use_default" id="p_use_default" value="N" checked="checked" />&' || 'nbsp;'));
           append(htf.tabledata(htf.small('N')));
         end if;
         append(htf.tabledata(htf.small(cs_rec.in_out)));
         IF cs_rec.data_type = 'OBJECT'
          THEN
            IF cs_rec.type_owner != l_package_owner
             THEN
               l_data_type := cs_rec.type_owner||'.';
            ELSE
               l_data_type := Null;
            END IF;
            l_data_type := l_data_type||cs_rec.type_name;
         ELSE
            l_data_type := cs_rec.data_type;
         END IF;
         append(htf.tabledata(htf.small(l_data_type)));
         append(htf.tablerowclose);
       END LOOP;
       IF l_position.count > 0
       THEN
          append(htf.tablerowopen);
          append('<td colspan="7">' ) ;
          append('<input type="submit" value="Run procedure" />');
          append('</td>');
          append(htf.tablerowclose);
          append(htf.tableclose);
       ELSE
          append(htf.small('No Parameters'));
          append('<br />' ) ;
          append('<input type="submit" value="Run procedure" />');
       END IF;
    END IF;
    if l_script is not null
    then
      append_script('</script>');
    end if;
    render_page
    ( p_title     => 'Set up parameters to run'
    , p_action    => get_callback_schema( g_package_name || '.execute_proc' )
    , p_form_body => l_form_body
    , p_script    => l_script
    ) ;
  end show_parameters ;
--
-----------------------------------------------------------------------------
--
  procedure execute_proc
    ( p_package_owner in varchar2
    , p_package_name  in varchar2
    , p_proc_name     in varchar2
    , p_arg_names     in owa_util.vc_arr default g_empty_vc_arr
    , p_arg_in_out    in owa_util.vc_arr default g_empty_vc_arr 
    , p_arg_values    in owa_util.vc_arr default g_empty_vc_arr
    , p_use_default   in owa_util.vc_arr default g_empty_vc_arr
    ) is
  l_package_owner varchar2(50) := upper(p_package_owner) ;
  l_package_name varchar2(50) := upper(p_package_name) ;
  l_proc_name varchar2(50) := upper(p_proc_name) ;
  l_name varchar2(200) := l_package_owner || '.' || l_package_name || '.' || l_proc_name ;
  l_before_args owa_util.vc_arr ;
  l_form_body owa_util.vc_arr ;
  l_form_body_count integer := 1 ;
  l_run_string big_varchar2 ;
  l_print_string big_varchar2 ;
  l_overload     dbms_describe.number_table;
  l_position     dbms_describe.number_table;
  l_c_level      dbms_describe.number_table;
  l_arg_name     dbms_describe.varchar2_table;
  l_dty          dbms_describe.number_table;
  l_def_val      dbms_describe.number_table;
  l_p_mode       dbms_describe.number_table;
  l_length       dbms_describe.number_table;
  l_precision    dbms_describe.number_table;
  l_scale        dbms_describe.number_table;
  l_radix        dbms_describe.number_table;
  l_spare        dbms_describe.number_table;
  l_idx          integer := 0;
  l_delimiter    char(1) := '(' ;
  procedure append_form( p_stuff in varchar2 ) is
  begin
    l_form_body(l_form_body_count) := p_stuff ;
    l_form_body_count := l_form_body_count + 1 ;
  end append_form ;
  procedure append_run( p_stuff in varchar2 ) is
  begin
    l_run_string := l_run_string || ' ' || p_stuff ;
    l_print_string := l_print_string || '<br />' || p_stuff ;
  end append_run ;
  begin
    append_run( 'begin' ) ;
    DBMS_DESCRIBE.DESCRIBE_PROCEDURE
      ( OBJECT_NAME    => l_name
      , RESERVED1      => null
      , RESERVED2      => null
      , OVERLOAD       => l_overload
      , POSITION       => l_position
      , LEVEL          => l_c_level
      , ARGUMENT_NAME  => l_arg_name
      , DATATYPE       => l_dty
      , DEFAULT_VALUE  => l_def_val
      , IN_OUT         => l_p_mode
      , LENGTH         => l_length
      , PRECISION      => l_precision
      , SCALE          => l_scale
      , RADIX          => l_radix
      , SPARE          => l_spare
      );
    if l_position.exists(0)
    then
      -- we have a function
      append_run( 'apitest.g_function_result := ' || l_name ) ;
    else
      append_run( l_name ) ;
    end if;
    --htp.p('<table border="1">');
    for i in  1..p_arg_names.count
    loop
      --htp.p('<tr>');
      --htp.p('<td>' || (i) || '</td>') ;
      --htp.p('<td>' || l_arg_name(i) || '</td>') ;
      --htp.p('<td>' || p_arg_names(i) || '</td>') ;
      --htp.p('<td>' || p_arg_values(i) || '</td>') ;
      --htp.p('<td>' || p_use_default(i) || '</td>') ;
      --htp.p('</tr>');
      -- If the argument is set use it
      -- if use default isn't set and we have a null use it anyway
      -- Note that you only get checkbox arrays up to the last one that was set
      -- hence the exists clause
      g_proc_arguments(i) :=  p_arg_values(i) ;
      l_before_args(i)    :=  p_arg_values(i) ;
      if g_proc_arguments(i) is not null
      then
        append_run( l_delimiter || p_arg_names(i) || '=>apitest.g_proc_arguments(' || to_char(i) || ')' ) ;
        l_delimiter := ',';
      elsif p_use_default(i) = 'N'
      then
        append_run( l_delimiter || p_arg_names(i) || '=>apitest.g_proc_arguments(' || to_char(i) || ')' ) ;
        l_delimiter := ',';
      end if;
    end loop;
    --htp.p('</table>');
    if l_delimiter <> '('
    then
      append_run(')');
    end if;
    append_run('; end;') ;
    append_form('<br />Running the following:<br />') ;
    append_form('<br />' || l_print_string || '<br />');
    begin
      execute immediate l_run_string  ;
    exception
    when others then
      append_form('Error encountered:<br />') ;
      append_form('<pre>');
      append_form(sqlerrm) ;
      append_form('</pre>');
    end ;
    append_form(
'<input type="hidden" id="p_package_name" name="p_package_name" value="' || l_package_name ||'" />
<input type="hidden" id="p_package_owner" name="p_package_owner" value="' || l_package_owner ||'" />
<input type="hidden" id="p_proc_name" name="p_proc_name" value="' || l_proc_name ||'" />
<table>
<tr>
<th>Position</th>
<th>Parameter</th>
<th>Before Value</th>
<th>After Value</th>
</tr>'
    ) ;
    if l_position.exists(0)
    then
      -- we have a function
      append_form( '<tr><td>Function returned</td>' ) ;
      append_form( '<td>&' || 'nbsp;</td>' ) ;
      append_form( '<td>'||g_function_result || '</td></tr>' ) ;
    end if;
    for i in  1..p_arg_names.count
    loop
      if l_before_args(i) is not null or p_use_default(i) = 'N'
      then
        append_form( '<tr>' ) ;
        append_form( '<td>'|| i || '</td>' ) ;
        append_form( '<td>'|| p_arg_names(i) || '</td>' ) ;
        append_form( '<td>'|| nvl(l_before_args(i),'-Null-') || '</td>' ) ;
        append_form( '<td>'|| nvl(g_proc_arguments(i),'-Null-') || '</td></tr>' ) ;
      end if ;
    end loop;
    append_form('<td colspan="3"><input type="submit" value="Back" /></td>');
    append_form('</table>');
    render_page
    ( p_title     => 'Display Results'
    , p_action    => get_callback_schema( g_package_name || '.show_parameters' )
    , p_form_body => l_form_body
    ) ;
  exception
    when others then
      htp.p(l_print_string);
      htp.p('<pre>');
      htp.p(sqlerrm) ;
      htp.p('</pre>');
  end execute_proc ;
--
-----------------------------------------------------------------------------
--
  procedure menu
  is
  begin
    render_page
    ( p_title     => 'API Test Menu'
    , p_action    => '#' 
    , p_form_body => 
'<table>
<tr>
  <td><a href="' || get_callback_schema( g_package_name || '.ask_for_procedure') || '">Run a procedure or function</a></td>
<tr>
</tr>
  <td><a href="'|| get_callback_schema( 'generic_handler.web_browse_rows') || '">Browse table data</a></td>
<tr>
</tr>
</table>
'
    ) ;
  end menu;
end apitest ;
/
