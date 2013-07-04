CREATE OR REPLACE PACKAGE BODY apd IS
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/apd.pkb-arc   2.1   Jul 04 2013 14:27:34   James.Wadsworth  $
--       Module Name      : $Workfile:   apd.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:27:34  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:27:16  $
--       SCCS Version     : $Revision:   2.1  $
--      SCCS Version     : 1.4
--
--
--   Author : Jonathan Mills
--
--     apd package. exor Automatic Schema Documentor
--
------------------------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------------------------------------
--all global package variables here
  g_body_sccsid      CONSTANT  VARCHAR2(80) := '"$Revision:   2.1  $"';
--  g_body_sccsid is the SCCS_ID for the package body
--
   g_package_name    CONSTANT VARCHAR2(30) := 'apd';
--
--
   g_in_production BOOLEAN := FALSE;
--
   g_apd_sequence    BINARY_INTEGER := 0;
--
   c_title                     VARCHAR2(500) := 'exor Schema Browser';
   c_exor_url                  VARCHAR2(30)  := 'http://www.exor.co.uk';
   c_exor_information          VARCHAR2(200) := 'highways by exor - the world'||CHR(39)||'s leading highways management systems';
--
   c_exor_orange               VARCHAR2(7)   := '#FF9900';
   c_exor_green                VARCHAR2(7)   := '#006666';
--
   l_db_name            v$database.name%TYPE;
   l_machine_name       v$session.machine%TYPE;
   l_rdbms_version      nls_database_parameters.value%TYPE;
   l_character_set      nls_database_parameters.value%TYPE;
   l_packages_done      dbms_describe.varchar2_table;
--
   g_item_type apd_tab.item_type%TYPE := 'UNSPECIFIED';
--
----------------------------------------------------------------------------------------------------------------
--
   c_up_arrow_img_tag   CONSTANT VARCHAR2(2000) := '<IMG SRC="images/arrowup.gif" alt="Top" BORDER=0 WIDTH=19 HEIGHT=25>';
   c_left_arrow_img_tag CONSTANT VARCHAR2(2000) := '<IMG SRC="images/arrowleft.gif" alt="%package%" BORDER=0 WIDTH=25 HEIGHT=19>';
   c_new_img_tag        CONSTANT VARCHAR2(2000) := '<IMG SRC="images/new.gif" alt="New" BORDER=0>';
   c_nbsp               CONSTANT VARCHAR2(6)    := CHR(38)||'nbsp;';
--
----------------------------------------------------------------------------------------------------------------
--
   TYPE tab_source_text IS TABLE OF user_source.text%TYPE INDEX BY BINARY_INTEGER;
--
   l_tab_source_header_text tab_source_text;
   l_tab_source_temp_text   tab_source_text;
--
   l_tab_left_image         tab_source_text;
   l_tab_left_alt           tab_source_text;
   l_tab_left_dest          tab_source_text;
--
----------------------------------------------------------------------------------------------------------------
--
   c_package_tag      CONSTANT VARCHAR2(10) := 'PACKAGE';
   c_globvar_tag      CONSTANT VARCHAR2(10) := 'GLOBVAR';
   c_procedure_tag    CONSTANT VARCHAR2(10) := 'PROC';
   c_pragma_tag       CONSTANT VARCHAR2(10) := 'PRAGMA';
--
   c_package_colour   CONSTANT VARCHAR2(30) := 'DARKBLUE';
   c_globvar_colour   CONSTANT VARCHAR2(30) := 'DARKGREEN';
   c_procedure_colour CONSTANT VARCHAR2(30) := '#6600FF';
   c_pragma_colour    CONSTANT VARCHAR2(30) := 'DARKRED';
--
   c_default_package_name CONSTANT VARCHAR2(30) := 'Standalone';
   c_table_details        CONSTANT VARCHAR2(30) := 'TABLE_DETAILS';
   c_view_details         CONSTANT VARCHAR2(30) := 'VIEW_DETAILS';
   c_trigger_details      CONSTANT VARCHAR2(30) := 'TRIGGER_DETAILS';
   c_type_details         CONSTANT VARCHAR2(30) := 'TYPE_DETAILS';
   c_package_details      CONSTANT VARCHAR2(30) := 'PACKAGE_DETAILS';
   c_right_frame          CONSTANT VARCHAR2(30) := 'RIGHT_FRAME';
--
   g_package_name_to_bar VARCHAR2(30) := 'APD';
--
  CURSOR cs_text (p_package_name VARCHAR2, p_type VARCHAR2) IS
  SELECT text
   FROM  user_source
  WHERE  name = p_package_name
   AND  (type = p_type
         OR     p_type IS NULL
        )
  ORDER BY type, line;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_pack_dets(pi_package_name IN VARCHAR2);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_proc_dets(pi_package_name   IN VARCHAR2
                            ,pi_procedure_name IN VARCHAR2
                            ,pi_procedure_type IN VARCHAR2
                            );
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_references(pi_package_name IN VARCHAR2);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_tag(pi_text IN VARCHAR2);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_code(pi_text IN VARCHAR2);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_comments(pi_comment_type   IN VARCHAR2
                            ,pi_procedure_name IN VARCHAR2 DEFAULT NULL
                            );
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_html_header;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_html_footer;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_create_spool_file;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_line(pi_text IN VARCHAR2);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_left_frame;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_code (pi_package_name IN VARCHAR2);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_all_proc_page;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_tables_page;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_views_page;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_types_page;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_right_frame;
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION fn_nullable (p_nullable IN user_tab_columns.nullable%TYPE) RETURN VARCHAR2;
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION fn_datatype(p_data_type      IN user_tab_columns.data_type%TYPE
                    ,p_data_length    IN user_tab_columns.data_length%TYPE
                    ,p_data_precision IN user_tab_columns.data_precision%TYPE
                    ,p_data_scale     IN user_tab_columns.data_scale%TYPE
                    ) RETURN VARCHAR2;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_triggers;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_long (p_text IN LONG);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_do_references (p_name IN VARCHAR2);
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_comment_block;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_index_file;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_top_frame;
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION fn_make_link_to_exor(p_text IN VARCHAR2) RETURN VARCHAR2;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_table_comments (p_table_name IN VARCHAR2
                            ,p_table_type IN VARCHAR2
                            );
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_details IS
--
   l_temp_count NUMBER := 0;
--
   c_cols_in_table CONSTANT NUMBER := 4;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_details');
--
   IF NOT g_in_production
    THEN
      g_package_name_to_bar := '??!!BADGER!!??';
   END IF;
--
   l_packages_done.DELETE;
--
-- Populate rows into the temporary table to use as it's quicker than using all_deps constantly
--
   INSERT INTO apd_dependencies
          (owner
          ,name
          ,type
          ,referenced_owner
          ,referenced_name
          ,referenced_type
          )
   SELECT  owner
          ,name
          ,type
          ,referenced_owner
          ,referenced_name
          ,referenced_type
    FROM   all_dependencies
   WHERE   referenced_type  <> 'NON-EXISTENT'
    AND    referenced_owner <> 'SYS'
    AND    referenced_name NOT IN ('PLITBLM','DUAL');
--
   g_item_type := c_package_details;
--
   pc_write_html_header;
--
   pc_tag('H3');
   pc_line('Packages');
   pc_tag('/H3');
--
   pc_tag('TABLE BORDER=1 WIDTH=90%');
--
   pc_tag('TR');
--
   FOR cs_rec IN (SELECT object_name        package_name
                        ,last_ddl_time
                   FROM  user_objects
                  WHERE  object_type =  'PACKAGE'
                   AND   object_name <> g_package_name_to_bar
                  ORDER BY DECODE(object_name
                                 ,'PACKAGE_TEMPLATE',1
                                 ,2
                                 )
                          ,object_name
                 )
    LOOP
      IF l_temp_count = c_cols_in_table
       THEN
         pc_tag('/TR');
         pc_tag('TR');
         l_temp_count := 0;
      END IF;
      l_temp_count := l_temp_count + 1;
--    pc_line('<TD WIDTH='||100/c_cols_in_table||'% ALIGN=CENTER '
--            ||'ONCLICK="location.href='||CHR(39)||cs_rec.x_package||'.htm'||CHR(39)||'">');
--    pc_line('<DIV ID="'||cs_rec.x_package||'"'
--           ||' ONMOUSEOVER="on( '||CHR(39)||cs_rec.x_package||CHR(39)||','||CHR(39)||'Package '||cs_rec.x_package||CHR(39)||' )"'
--           ||' ONMOUSEOUT="off( '||CHR(39)||cs_rec.x_package||CHR(39)||','||CHR(39)||CHR(39)||' )"'
--           ||'>');
--    pc_line(cs_rec.x_package);
--    pc_line('</DIV>');
--    pc_line('</TD>');
      pc_tag('TD WIDTH='||100/c_cols_in_table||'%');
      pc_line('<A HREF="'||cs_rec.package_name||'.htm"> '||cs_rec.package_name||'</A>');
--
      pc_tag('/TD');
   END LOOP;
--
   pc_tag('/TABLE');
--
   pc_tag('BR');
   pc_tag('HR WIDTH=75%');
   pc_tag('BR');
--
   pc_tag('H3');

   pc_line('<A HREF="'||c_default_package_name||'.htm"> '||c_default_package_name||'</A>');
--
   pc_tag('BR');
--
   pc_line('<A HREF="ALL_PROCS.htm"> All Procedures/Functions</A>');
--
   l_tab_left_image(1) := 'images/button-Pack.gif';
   l_tab_left_alt(1)   := 'Packages';
   l_tab_left_dest(1)  := c_package_details||'.htm';
--
   l_tab_left_image(2) := 'images/button-Tables.gif';
   l_tab_left_alt(2)   := 'Tables';
   l_tab_left_dest(2)  := c_table_details||'.htm';
--
   l_tab_left_image(3) := 'images/button-Triggers.gif';
   l_tab_left_alt(3)   := 'Triggers';
   l_tab_left_dest(3)  := c_trigger_details||'.htm';
--
   l_tab_left_image(4) := 'images/button-Objects.gif';
   l_tab_left_alt(4)   := 'Objects';
   l_tab_left_dest(4)  := c_type_details||'.htm';
--
   l_tab_left_image(5) := 'images/button-Views.gif';
   l_tab_left_alt(5)   := 'Views';
   l_tab_left_dest(5)  := c_view_details||'.htm';
--
   FOR l_count IN 2..l_tab_left_image.COUNT
    LOOP
      pc_tag('BR');
      pc_line('<A HREF="'||l_tab_left_dest(l_count)||'">'||l_tab_left_alt(l_count)||'</A>');
   END LOOP;
--
   pc_tag('/H3');
--
   pc_write_html_footer;
--
   FOR cs_rec IN (SELECT DISTINCT NVL(package_name,c_default_package_name) package_name
                   FROM  user_arguments
                  WHERE  NVL(package_name,c_default_package_name) != g_package_name_to_bar
--                  ORDER BY package_name
                 )
    LOOP
      pc_write_pack_dets(cs_rec.package_name);
   END LOOP;
--
   pc_write_all_proc_page;
--
   pc_write_tables_page;
--
   pc_write_views_page;
--
   pc_output_triggers;
--
   pc_write_types_page;
--
   pc_write_left_frame;
--
   pc_write_right_frame;
--
   pc_write_index_file;
--
   pc_write_top_frame;
--
   pc_create_spool_file;
--
   nm_debug.proc_end(g_package_name,'pc_write_details');
--
END pc_write_details;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_pack_dets(pi_package_name IN VARCHAR2)IS
--
   l_procs     dbms_describe.varchar2_table;
   l_proc_type dbms_describe.varchar2_table;
--
   l_counter number := 0;
   l_temp_count NUMBER := 0;
--
   c_cols_in_table CONSTANT NUMBER := 2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_pack_dets('||pi_package_name||')');
--
-- Populate local pl/sql tables with stuff from user_source to avoid keep hitting the DB
--
   l_tab_source_header_text.DELETE;
--
-- BULK COLLECT into a temporary variable, then copy it as the bulk collected variable only
--  exists until the cursor is re-used, then it is trashed
--
   OPEN  cs_text(pi_package_name, 'PACKAGE');
   FETCH cs_text BULK COLLECT INTO l_tab_source_temp_text;
   CLOSE cs_text;
--
   l_tab_source_header_text := l_tab_source_temp_text;
--
   g_item_type := pi_package_name;
--
   l_packages_done(l_packages_done.COUNT+1) := pi_package_name;
--
   pc_write_html_header;
--
   pc_tag('B');
   pc_tag('I');
   pc_line(pi_package_name);
   pc_tag('/B');
   pc_tag('/I');
   pc_line('<A HREF="javascript:history.back(1)">'
           ||REPLACE(c_left_arrow_img_tag,'%package%','Index')||'</A>'
          );
--
   pc_tag('BR');
--
   pc_output_comments(pi_comment_type => c_package_tag);
--
   pc_output_comments(pi_comment_type => c_globvar_tag);
--
   pc_output_comments(pi_comment_type => c_pragma_tag);
--
   pc_tag('BR');
   FOR cs_rec IN (SELECT INITCAP(object_type) object_type
                        ,to_char(last_ddl_time,'HH24:MI:SS DD Mon YYYY') last_ddl_time
                        ,DECODE(object_type
                               ,'PACKAGE',pi_package_name||'_spec.htm'
                               ,'PACKAGE BODY',pi_package_name||'_body.htm'
                               ) href_name
                   FROM  user_objects
                  WHERE  object_name = pi_package_name
                 )
    LOOP
      IF NOT (UPPER(cs_rec.object_type) = 'PACKAGE BODY'
              AND g_in_production
             )
       THEN
         pc_line('<A HREF="'||cs_rec.href_name||'">'||cs_rec.object_type||'</A> last DDL time '||cs_rec.last_ddl_time);
         pc_tag('BR');
      END IF;
   END LOOP;
--
   pc_line('<A HREF="#'||pi_package_name||'.referenceslink">References</A>');
   pc_tag('BR');
   pc_line('<A HREF="#'||pi_package_name||'.referencedbylink">Referenced By</A>');
   pc_tag('BR');
--
   pc_tag('BR');
   pc_tag('TABLE BORDER=1 WIDTH=90%');

   pc_tag('TR');
--
   FOR cs_rec IN (SELECT object_name x_procedure
                        ,min(NVL(position,0)) min_position
                   FROM  user_arguments
                  WHERE  NVL(package_name,c_default_package_name) = NVL(pi_package_name,c_default_package_name)
                  GROUP BY object_name
                 )
    LOOP
--
      IF l_temp_count = c_cols_in_table
       THEN
         pc_tag('/TR');
         pc_tag('TR');
         l_temp_count := 0;
      END IF;
      l_temp_count := l_temp_count + 1;
--
      l_counter := l_counter + 1;
--
      l_procs(l_counter) := cs_rec.x_procedure;
--
      IF cs_rec.min_position = 0
       THEN
--
         l_proc_type(l_counter) := 'FUNCTION';
--
--       If this is derived as a function, there still may be an o/loaded procedure
--
         FOR cs_inner_rec IN (SELECT overload
                                    ,min(NVL(position,0)) min_position
                               FROM  user_arguments
                              WHERE  NVL(package_name,c_default_package_name) = NVL(pi_package_name,c_default_package_name)
                               AND   objecT_name = cs_rec.x_procedure
                              GROUP BY overload
                             )
          LOOP
--
--          For each overload instance, check the minimum position
--          If non-zero then there is a procedure for this as well as a function
--
            IF cs_inner_rec.min_position <> 0
             THEN
               l_proc_type(l_counter) := 'FUNC/PROC';
               EXIT;
            END IF;
--
         END LOOP;
--
      ELSE
         l_proc_type(l_counter) := 'PROCEDURE';
      END IF;
--
--    pc_line('<TD WIDTH='||100/c_cols_in_table||'% ALIGN=CENTER '
--            ||'ONCLICK="location.href='||CHR(39)||'#'||pi_package_name||'.'||cs_rec.x_procedure||CHR(39)||'">');
--    pc_line('<DIV ID="'||pi_package_name||'.'||cs_rec.x_procedure||'"'
--           ||' ONMOUSEOVER="on( '||CHR(39)||pi_package_name||'.'||cs_rec.x_procedure||CHR(39)||','||CHR(39)||l_proc_type(l_counter)||' '||cs_rec.x_procedure||CHR(39)||' )"'
--           ||' ONMOUSEOUT="off( '||CHR(39)||pi_package_name||'.'||cs_rec.x_procedure||CHR(39)||','||CHR(39)||CHR(39)||' )"'
--           ||'>');
--    pc_line(l_proc_type(l_counter)||' '||cs_rec.x_procedure);
--    pc_line('</DIV>');
--    pc_line('</TD>');
      pc_tag('TD WIDTH='||100/c_cols_in_table||'%');
      pc_line('<A HREF="#'||pi_package_name||'.'||cs_rec.x_procedure||'">'||l_proc_type(l_counter)||' '||cs_rec.x_procedure||'</A>');
      pc_tag('/TD');
--
   end loop;
--
   pc_tag('/TABLE');
--
   pc_write_references(pi_package_name);
--
   FOR l_count in 1..l_counter
    LOOP
      pc_write_proc_dets(pi_package_name, l_procs(l_count), l_proc_type(l_count));
   END LOOP;
--
   pc_tag('BR');
   pc_tag('HR WIDTH=75%');
   pc_tag('BR');
--
   pc_write_html_footer;
--
   pc_output_code (pi_package_name);
--
   nm_debug.proc_end(g_package_name,'pc_write_pack_dets('||pi_package_name||')');
--
END pc_write_pack_dets;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_proc_dets(pi_package_name   IN VARCHAR2
                            ,pi_procedure_name IN VARCHAR2
                            ,pi_procedure_type IN VARCHAR2
                            ) IS
--
--------------------------------------------------------------------------
--
   l_overload       number := Null;
--
   l_datatype       varchar2(2000);
--
   l_been_into_loop BOOLEAN;
--
   l_temp_arg_name  VARCHAR2(2000);
--
   l_use_small_text BOOLEAN;
--
   l_has_defaults BOOLEAN;
--
   l_tab_overload             dbms_describe.number_table;
   l_tab_position             dbms_describe.number_table;
   l_tab_level                dbms_describe.number_table;
   l_tab_argument_name        dbms_describe.varchar2_table;
   l_tab_datatype             dbms_describe.number_table;
   l_tab_default_value        dbms_describe.number_table;
   l_tab_in_out               dbms_describe.number_table;
   l_tab_length               dbms_describe.number_table;
   l_tab_precision            dbms_describe.number_table;
   l_tab_scale                dbms_describe.number_table;
   l_tab_radix                dbms_describe.number_table;
   l_tab_spare                dbms_describe.number_table;
--
--------------------------------------------------------------------------
--
   FUNCTION fn_make_small (pi_text IN VARCHAR2) RETURN VARCHAR2 IS
     l_retval VARCHAR2(2000) := pi_text;
   BEGIN
     IF l_use_small_text
      THEN
        l_retval := '<SMALL>'||l_retval||'</SMALL>';
     END IF;
     RETURN l_retval;
   END fn_make_small;
--
--------------------------------------------------------------------------
--
   FUNCTION fn_has_defaults (pi_overload IN NUMBER) RETURN BOOLEAN IS
--
      l_retval BOOLEAN := FALSE;
--
   BEGIN
--
      FOR l_counter IN 1..l_tab_default_value.COUNT
       LOOP
         IF NVL(l_tab_default_value(l_counter),0) <> 0
          THEN
            l_retval := TRUE;
            EXIT;
         END IF;
      END LOOP;
--
      RETURN l_retval;
--
   END fn_has_defaults;
--
--------------------------------------------------------------------------
--
   FUNCTION fn_get_default (pi_overload IN NUMBER
                           ,pi_position IN NUMBER
                           ,pi_level    IN NUMBER
                           ) RETURN VARCHAR2 IS
--
      l_retval VARCHAR2(100) := c_nbsp;
--
   BEGIN
--
      FOR l_counter IN 1..l_tab_default_value.COUNT
       LOOP
         IF   l_tab_overload(l_counter) = NVL(pi_overload,0)
          AND l_tab_position(l_counter) = pi_position
          AND l_tab_level(l_counter)    = pi_level
          THEN
            IF NVL(l_tab_default_value(l_counter),0) <> 0
             THEN
               l_retval := 'DEFAULT';
            END IF;
            EXIT;
         END IF;
      END LOOP;
--
      RETURN l_retval;
--
   END fn_get_default;
--
--------------------------------------------------------------------------
--
   PROCEDURE pc_get_dbms_describe IS
      l_object_name  VARCHAR2(61);
   BEGIN
--
      --
      -- We have this in here, because we still have to call DBMS_DESCRIBE
      --  to get the fact whether a procedure has any DEFAULTs for it's parameters
      --
--
      IF pi_package_name <> c_default_package_name
       THEN
         l_object_name := pi_package_name||'.'||pi_procedure_name;
      ELSE
         l_object_name := pi_procedure_name;
      END IF;
--
      dbms_describe.describe_procedure
           (object_name          => l_object_name       -- varchar2              in
           ,reserved1            => Null                -- varchar2              in
           ,reserved2            => Null                -- varchar2              in
           ,overload             => l_tab_overload      -- table of number       out
           ,position             => l_tab_position      -- table of number       out
           ,level                => l_tab_level         -- table of number       out
           ,argument_name        => l_tab_argument_name -- table of varchar2(30) out
           ,datatype             => l_tab_datatype      -- table of number       out
           ,default_value        => l_tab_default_value -- table of number       out
           ,in_out               => l_tab_in_out        -- table of number       out
           ,length               => l_tab_length        -- table of number       out
           ,precision            => l_tab_precision     -- table of number       out
           ,scale                => l_tab_scale         -- table of number       out
           ,radix                => l_tab_radix         -- table of number       out
           ,spare                => l_tab_spare         -- table of number       out
           );
--
   EXCEPTION
--
      WHEN others
       THEN
         Null;
--
   END pc_get_dbms_describe;
--
--------------------------------------------------------------------------
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_proc_dets('||pi_package_name||'.'||pi_procedure_name||')');
--
   pc_get_dbms_describe;
--
   pc_tag('HR WIDTH=40% align="left"');
--
   pc_tag('B');
   pc_line('<A NAME="'||pi_package_name||'.'||pi_procedure_name||'">'||pi_procedure_type||' '||pi_procedure_name||'</A>');
   pc_line('<A HREF="#top">'||c_up_arrow_img_tag||'</A>');
   pc_tag('/B');
--
   pc_tag('BR');
--
   pc_output_comments(pi_comment_type   => c_procedure_tag
                     ,pi_procedure_name => pi_procedure_name
                     );
--
   l_been_into_loop := FALSE;
--
   FOR cs_rec IN (SELECT object_name
                        ,package_name
                        ,object_id
                        ,overload
                        ,argument_name
                        ,position
                        ,level
                        ,sequence
                        ,data_level
                        ,data_type
                        ,default_value
                        ,default_length
                        ,in_out
                        ,data_length
                        ,data_precision
                        ,data_scale
                        ,radix
                        ,character_set_name
                        ,type_owner
                        ,type_name
                        ,type_subname
                        ,type_link
                        ,pls_type
                        ,DECODE(type_name
                               ,Null,NVL(pls_type,data_type)
                               ,DECODE(type_owner
                                      ,user,type_name
                                      ,type_owner||'.'||type_name
                                      )
                               ) derived_datatype
                   FROM  user_arguments
                  WHERE  NVL(package_name,c_default_package_name)   = NVL(pi_package_name,c_default_package_name)
                   AND   object_name = pi_procedure_name
                   AND   data_type IS NOT NULL
                  ORDER BY nvl(overload,0), sequence
                 )
    LOOP
--
      l_use_small_text := (cs_rec.data_level > 0);
--
      IF NOT l_been_into_loop
       THEN
--
         pc_tag('TABLE BORDER=1');
--
         l_has_defaults := fn_has_defaults (cs_rec.overload);
--
      END IF;
--
      l_been_into_loop := TRUE;
--
      if l_overload is not null
       and l_overload <> cs_rec.overload
       then
         pc_tag('/TABLE');
         pc_tag('HR WIDTH=40% align="left"');
         pc_tag('TABLE BORDER=1');
--
         l_has_defaults := fn_has_defaults (cs_rec.overload);
--
      end if;
      l_overload := cs_rec.overload;
--
      pc_tag('TR');
--
      pc_tag('TD');
      IF cs_rec.position = 0 --argument_name IS NULL
       THEN
         pc_tag('B');
         pc_code('RETURN');
         pc_tag('/B');
      ELSE
         l_temp_arg_name    := cs_rec.argument_name;
         IF cs_rec.data_level > 0
          THEN
            l_temp_arg_name := c_nbsp||RPAD('-',cs_rec.data_level,'-')
                               ||c_nbsp||cs_rec.argument_name;
         END IF;
         pc_code(fn_make_small(l_temp_arg_name));
      END IF;
      pc_tag('/TD');
--
      pc_tag('TD');
      pc_code(fn_make_small(cs_rec.in_out));
      pc_tag('/TD');
--
      pc_tag('TD');
--
      l_datatype := fn_datatype(p_data_type      => cs_rec.derived_datatype
                               ,p_data_length    => cs_rec.data_length
                               ,p_data_precision => cs_rec.data_precision
                               ,p_data_scale     => cs_rec.data_scale
                               );
--
      pc_code(fn_make_small(l_datatype));
      pc_tag('/TD');
--
      IF l_has_defaults
       THEN
         pc_tag('TD');
         pc_code(fn_make_small(fn_get_default (pi_overload => cs_rec.overload
                                              ,pi_position => cs_rec.position
                                              ,pi_level    => cs_rec.level
                                              )
                              )
                );
         pc_tag('/TD');
      END IF;
--
      pc_tag('/TR');
--
   END LOOP;
--
   IF l_been_into_loop
    THEN
      pc_tag('/TABLE');
   ELSE
      pc_line('<I><SMALL>No Parameters</SMALL></I>');
   END IF;
--
   IF pi_package_name = c_default_package_name
    THEN
      DECLARE
         l_tab_varchar2 nm3type.tab_varchar32767;
      BEGIN
         OPEN  cs_text(pi_procedure_name, Null);
         FETCH cs_text BULK COLLECT INTO l_tab_varchar2;
         CLOSE cs_text;
         FOR i IN 1..(l_tab_varchar2.COUNT-1)
          LOOP
            pc_code(REPLACE(l_tab_varchar2(i),' ',c_nbsp));
            pc_tag('BR');
         END LOOP;
      END;
   END IF;
--
   nm_debug.proc_end(g_package_name,'pc_write_proc_dets');
--
END pc_write_proc_dets;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_references(pi_package_name IN VARCHAR2) IS
--
   l_type        varchar2(30) := 'fred';
   l_output_type varchar2(30);
   --
   -- -------- Local procedure for writing references --------------------
   --
   PROCEDURE local_write_ref (pi_type1  IN VARCHAR2
                       ,pi_type2  IN VARCHAR2
                       ,pi_owner  IN VARCHAR2
                       ,pi_name   IN VARCHAR2
                       ) IS
--
      l_name        varchar2(2000);
--
   BEGIN
--
      pc_tag('TR');
--
      IF l_type <> pi_type1
       THEN
         l_type        := pi_type1;
         l_output_type := INITCAP(pi_type1);
      ELSE
         l_output_type := c_nbsp;
      END IF;
--
      pc_tag('TD');
      pc_code(l_output_type);
      pc_tag('/TD');
--
      pc_tag('TD');
      pc_code(pi_owner);
      pc_tag('/TD');
--
      l_name := pi_name;
      IF pi_owner = USER
       THEN
         IF pi_type2 = 'TABLE'
          THEN
            l_name := '<A HREF="'||c_table_details||'.htm#'||c_table_details||'.'||pi_name||'">'||pi_name||'</A>';
         ELSIF pi_type2 = 'VIEW'
          THEN
            l_name := '<A HREF="'||c_view_details||'.htm#'||c_view_details||'.'||pi_name||'">'||pi_name||'</A>';
         ELSIF pi_type2 = 'TRIGGER'
          THEN
            l_name := '<A HREF="'||c_trigger_details||'.htm#'||c_trigger_details||'.'||pi_name||'">'||pi_name||'</A>';
         ELSIF pi_type2 = 'TYPE'
          THEN
            l_name := '<A HREF="'||c_type_details||'.htm#'||c_type_details||'.'||pi_name||'">'||pi_name||'</A>';
         ELSIF SUBSTR(pi_type2,1,7) = 'PACKAGE'
          AND pi_name <> pi_package_name
          THEN
            l_name := '<A HREF="'||pi_name||'.htm'||'">'||pi_name||'</A>';
         END IF;
      END IF;
--
      pc_tag('TD');
      pc_code(l_name);
      pc_tag('/TD');
--
      pc_tag('TD');
      pc_code(pi_type2);
      pc_tag('/TD');
--
      pc_tag('/TR');
--
   END local_write_ref;
   --
   -- -------- End of local procedure for writing references --------------------
   --
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_references('||pi_package_name||')');
--
   pc_line('<A NAME="'||pi_package_name||'.referenceslink">References</A>');
   pc_line('<A HREF="#top">'||c_up_arrow_img_tag||'</A>');
--
   pc_tag('TABLE BORDER=1');
   pc_tag('TR');
--
   FOR cs_rec IN (SELECT referenced_owner
                        ,referenced_name
                        ,referenced_type
                        ,type
                   FROM  apd_dependencies
                  WHERE  owner = USER
                   AND   name = pi_package_name
                  ORDER BY type, referenced_owner, referenced_name, referenced_type
                 )
    LOOP
--
      local_write_ref (pi_type1  => cs_rec.type
                      ,pi_type2  => cs_rec.referenced_type
                      ,pi_owner  => cs_rec.referenced_owner
                      ,pi_name   => cs_rec.referenced_name
                      );
--
   END LOOP;
--
   pc_tag('/TABLE');
--
--
--
   pc_line('<A NAME="'||pi_package_name||'.referencedbylink">Referenced By</A>');
   pc_line('<A HREF="#top">'||c_up_arrow_img_tag||'</A>');
--
   pc_tag('TABLE BORDER=1');
   pc_tag('TR');
--
   FOR cs_rec IN (SELECT owner
                        ,name
                        ,type
                        ,referenced_type
                   FROM  apd_dependencies
                  WHERE  referenced_name = pi_package_name
                  ORDER BY referenced_type, owner, name, type
                 )
    LOOP
--
      local_write_ref (pi_type1  => cs_rec.referenced_type
                      ,pi_type2  => cs_rec.type
                      ,pi_owner  => cs_rec.owner
                      ,pi_name   => cs_rec.name
                      );
--
   END LOOP;
--
   pc_tag('/TABLE');
--
   nm_debug.proc_end(g_package_name,'pc_write_references('||pi_package_name||')');
--
END pc_write_references;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_comments(pi_comment_type   IN VARCHAR2
                            ,pi_procedure_name IN VARCHAR2 DEFAULT NULL
                            ) IS
--
   l_tag_start_line NUMBER := Null;
   l_tag_end_line   NUMBER := Null;
--
   l_current_text_line user_source.text%TYPE;
--
   l_colour         VARCHAR2(30);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_output_comments('||pi_comment_type||','||pi_procedure_name||')');
--
   FOR l_counter IN 1..l_tab_source_header_text.COUNT
    LOOP
--
      l_current_text_line := UPPER(l_tab_source_header_text(l_counter));
--
      IF    INSTR(l_current_text_line,'<'||pi_comment_type||'>' ,1,1) <> 0
       AND  pi_comment_type                                           <> c_procedure_tag
       THEN
--
         l_tag_start_line := l_counter;
--
      ELSIF INSTR(l_current_text_line,'<'||pi_comment_type,1,1)       <> 0
       AND  INSTR(l_current_text_line,'NAME=',1,1)                    <> 0
       AND  INSTR(l_current_text_line,UPPER(pi_procedure_name),1,1)   <> 0
       AND  pi_comment_type                                           =  c_procedure_tag
       THEN
--
         l_tag_start_line := l_counter;
--
      ELSIF INSTR(l_current_text_line,'</'||pi_comment_type||'>',1,1) <> 0
       AND l_tag_start_line                                           IS NOT NULL
       THEN
--
         l_tag_end_line   := l_counter;
         exit; -- got the end tag so exit loop
--
      END IF;
--
   END LOOP;
--
   IF   l_tag_start_line IS NOT NULL
    AND l_tag_end_line   IS NOT NULL
    THEN -- If we've found both tags
--
      IF    pi_comment_type = c_package_tag
       THEN
         l_colour := c_package_colour;
      ELSIF pi_comment_type = c_globvar_tag
       THEN
         l_colour := c_globvar_colour;
      ELSIF  pi_comment_type = c_procedure_tag
       THEN
         l_colour := c_procedure_colour;
      ELSIF  pi_comment_type = c_pragma_tag
       THEN
         l_colour := c_pragma_colour;
      ELSE
         l_colour := 'BLACK';
      END IF;
--
      pc_tag('FONT COLOR="'||l_colour||'"');
--
      pc_tag('PRE');
--
      FOR l_counter IN (l_tag_start_line+1)..(l_tag_end_line-1)
       LOOP
         pc_line(ltrim(replace(l_tab_source_header_text(l_counter),' ',c_nbsp),'--'));
--         pc_tag('BR');
--
      END LOOP;
--
      pc_tag('/PRE');
--
      pc_tag('/FONT');
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'pc_output_comments('||pi_comment_type||','||pi_procedure_name||')');
--
END pc_output_comments;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_line(pi_text IN VARCHAR2) IS
--
   l_text VARCHAR2(4000);
--
   c_chunk CONSTANT PLS_INTEGER := 3950;
   l_start          PLS_INTEGER := 1;
--
   PROCEDURE write_ (p_text VARCHAR2) IS
   BEGIN
      g_apd_sequence := g_apd_sequence + 1;
      INSERT INTO apd_tab
            (id
            ,item_type
            ,text
            )
       VALUES
            (g_apd_sequence
            ,g_item_type
            ,p_text
            );
   END write_;
--
   PROCEDURE next_chunk IS
   BEGIN
      l_text  := SUBSTR(pi_text,l_start,c_chunk);
      l_start := l_start + c_chunk;
   END next_chunk;
--
BEGIN
   IF length(pi_text) < c_chunk
    THEN
      write_ (pi_text);
   ELSE
      next_chunk;
      WHILE l_start < length(pi_text)
       LOOP
         write_ (l_text);
         next_chunk;
      END LOOP;
      write_ (l_text);
   END IF;
END pc_line;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_tag(pi_text IN VARCHAR2) IS
BEGIN
   pc_line('<'||pi_text||'>');
END pc_tag;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_code(pi_text IN VARCHAR2) IS
BEGIN
    pc_line('<CODE>'||pi_text||'</CODE>');
END pc_code;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_html_header IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_html_header');
--
   pc_write_comment_block;
--
   pc_tag('TITLE');
   pc_line(c_title);
   pc_tag('/TITLE');
   pc_line('<A NAME="top"></A>');
--
   pc_line('<!--   SCCS Identifiers :- -->');
   pc_line('<!-- -->');
   pc_line('<!--       sccsid           : @(#)apd.pkb	1.4 03/08/02 -->');
   pc_line('<!--       Module Name      : apd.pkb -->');
   pc_line('<!--       Date into SCCS   : 02/03/08 16:27:48 -->');
   pc_line('<!--       Date fetched Out : 07/06/13 14:10:00 -->');
   pc_line('<!--       SCCS Version     : 1.4 -->');
   pc_line('<!-- -->');
   pc_line('<!-- -->');
   pc_line('<!--   Author : Jonathan Mills -->');
   pc_line('<!-- -->');
   pc_line('<!--     Generated by apd package. exor Automatic Schema Documentor -->');
   pc_line('<!-- -->');
   pc_line('<!------------------------------------------------------------------------------------------------ -->');
   pc_line('<!--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved. -->');
   pc_line('<!------------------------------------------------------------------------------------------------ -->');
-- pc_line('<SCRIPT type="text/JavaScript">');
-- pc_line('<!--');
-- pc_line('// turn on text highlighting');
-- pc_line('function on(val, text) {');
-- pc_line('   // get specific div item, identified by node index');
-- pc_line('   var itm = document.getElementById(val);');
-- pc_line('   // set style properties');
-- pc_line('   itm.style.backgroundColor="yellow";');
-- pc_line('   status=text');
-- pc_line('}');
-- pc_line('// turn off menu highlighting');
-- pc_line('function off(val, text) {');
-- pc_line('   // get specific div item, identified by node index');
-- pc_line('   var itm = document.getElementById(val);');
-- pc_line('   // set style properties');
-- pc_line('   itm.style.backgroundColor="white";');
-- pc_line('   status=text');
-- pc_line('}');
-- pc_line('//-->');
-- pc_line('</SCRIPT>');
--
-- pc_line('<NOSCRIPT>');
-- pc_line('You must have javascript enabled');
-- pc_line('</NOSCRIPT>');
--
   pc_tag('/HEAD');
--
   pc_tag('BODY BGCOLOR="'||c_exor_orange||'" TEXT="BLACK" LINK="'||c_exor_green||'" ALINK="'||c_exor_green||'" VLINK="'||c_exor_green||'"');
--
   IF nm3flx.right(g_item_type,5) NOT IN ('_BODY','_SPEC')
    THEN
--
      pc_tag('TABLE WIDTH=100% BORDER=0');
      pc_tag('TR');
      pc_tag('TD WIDTH=40');
      pc_line(c_nbsp);
      pc_tag('/TD');
      pc_tag('TD');
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'pc_write_html_header');
--
END pc_write_html_header;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_html_footer IS
BEGIN
--
   pc_tag('/TD');
   pc_tag('/TR');
   pc_tag('/TABLE');
--
   pc_tag('/BODY');
   pc_tag('/HTML');
--
END pc_write_html_footer;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_create_spool_file IS
BEGIN
--
   g_item_type := 'SPOOLER';
--
   pc_line('set termout off');
   pc_line('set feedback off');
   pc_line('set pages 0');
   pc_line('set lines 2000');
   pc_line('set trimspool on');
--
   FOR cs_rec IN (SELECT distinct item_type
                  FROM   apd_tab
                  WHERE  item_type <> g_item_type
                 )
    LOOP
      pc_line('spool '||lower(cs_rec.item_type)||'.htm');
      pc_line('select text');
      pc_line('from apd_tab');
      pc_line('where item_type='||CHR(39)||cs_rec.item_type||CHR(39));
      pc_line('order by id;');
      pc_line('spool off');
   END LOOP;
--
END pc_create_spool_file;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_left_frame IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_left_frame');
--
   g_item_type := 'LEFT_FRAME';
--
   pc_line('<HTML>');
--
   pc_write_comment_block;
--
   pc_line('</HEAD>');
--
   pc_line('<BODY BGCOLOR="'||c_exor_green||'" LEFTMARGIN="5">');
--
   pc_line('<P>'||c_nbsp||'</P>');
--
   pc_line('<P><a href="'||c_right_frame||'.htm" target="main1"><img border="0" src="images/button-Home.gif" width="124" height="23"></a></P>');
--
   FOR l_count IN 1..l_tab_left_image.COUNT
    LOOP
      pc_line('<P>'||c_nbsp||'</P>');
      pc_line('<P><a href="'||l_tab_left_dest(l_count)||'" target="main1"><img border="0" src="'||l_tab_left_image(l_count)||'" alt="'||l_tab_left_alt(l_count)||'" width="124" height="23"></a></P>');
   END LOOP;
--
   pc_line('</BODY>');
--
   pc_line('</HTML>');
--
   nm_debug.proc_end(g_package_name,'pc_write_left_frame');
--
END pc_write_left_frame;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_code (pi_package_name IN VARCHAR2) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_output_code ('||pi_package_name||')');
--
   g_item_type := pi_package_name||'_SPEC';
--
   pc_write_html_header;
--
   pc_line('<A HREF="javascript:history.back(1)">'
           ||REPLACE(c_left_arrow_img_tag,'%package%','Package '||pi_package_name)||'</A>'
          );
--
   pc_tag('PLAINTEXT');
--
   FOR l_counter IN 1..l_tab_source_header_text.COUNT
    LOOP
      pc_line(l_tab_source_header_text(l_counter));
   END LOOP;
--
   IF NOT g_in_production
    THEN
--
      g_item_type := pi_package_name||'_BODY';
--
      pc_write_html_header;
--
      pc_line('<A HREF="javascript:history.back(1)">'
              ||REPLACE(c_left_arrow_img_tag,'%package%','Package '||pi_package_name)||'</A>'
             );
   --
      pc_tag('PLAINTEXT');
   --
      FOR cs_rec IN cs_text(pi_package_name, 'PACKAGE BODY')
       LOOP
         pc_line(cs_rec.text);
      END LOOP;
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'pc_output_code ('||pi_package_name||')');
--
END pc_output_code;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_all_proc_page IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_all_proc_page');
--
   g_item_type := 'ALL_PROCS';
--
   pc_write_html_header;
--
   pc_tag('H3');
   pc_line('All Procedures/Functions');
   pc_line('<A HREF="javascript:history.back(1)">'
           ||REPLACE(c_left_arrow_img_tag,'%package%','Index')||'</A>'
          );
   pc_tag('/H3');
--
   pc_tag('TABLE BORDER=1');
--
   FOR cs_rec IN (SELECT object_name procedure_name
                        ,NVL(package_name,c_default_package_name) package_name
                        ,overload
                        ,DECODE(MIN(position)
                               ,0,'Function '
                               ,'Procedure '
                               ) proc_type
                   FROM  user_arguments
                  WHERE  NVL(package_name,c_default_package_name) <> g_package_name_to_bar
                  GROUP BY object_name
                          ,NVL(package_name,c_default_package_name)
                          ,overload
                 )
    LOOP
--
      pc_tag('TR');
--
      pc_tag('TD');
      pc_line('<A HREF="'||cs_rec.package_name||'.htm#'||cs_rec.package_name||'.'||cs_rec.procedure_name||'"> '
               ||cs_rec.proc_type||cs_rec.procedure_name||'</A>'
             );
      pc_tag('/TD');
      pc_tag('TD');
      pc_line('<A HREF="'||cs_rec.package_name||'.htm"> '||cs_rec.package_name||'</A>');
      pc_tag('/TD');
--
      pc_tag('/TR');
--
   END LOOP;
--
   pc_tag('/TABLE');
--
   pc_write_html_footer;
--
   nm_debug.proc_end(g_package_name,'pc_write_all_proc_page');
--
END pc_write_all_proc_page;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_tables_page IS
--
   CURSOR cs_tables IS
   SELECT table_name
         ,DECODE(temporary
                ,'N',Null
                ,' - Temporary Table ('||DECODE(duration
                                               ,'SYS$SESSION','Session'
                                               ,'SYS$TRANSACTION','Transaction'
                                               ,duration
                                               )
                                       ||')'
                ) temporary
    FROM  user_tables
   WHERE  table_name NOT LIKE g_package_name_to_bar||'%'
  ORDER BY table_name;
--
   CURSOR cs_has_defaults (p_table_name  user_tab_columns.table_name%TYPE) IS
   SELECT table_name
    FROM  user_tab_columns
   WHERE  table_name   =  p_table_name
    AND   data_default IS NOT NULL;
--
   l_dummy        cs_has_defaults%ROWTYPE;
   l_has_defaults BOOLEAN;
--
   l_temp_counter              NUMBER := 1;
   c_cols_per_row     CONSTANT NUMBER := 3;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_tables_page');
--
   g_item_type := c_table_details;
--
   pc_write_html_header;
--
   pc_tag('H3');
   pc_line('<A NAME="top"> Tables</A>');
   pc_line('<A HREF="javascript:history.back(1)">'
           ||REPLACE(c_left_arrow_img_tag,'%package%','Index')||'</A>'
          );
   pc_tag('/H3');
--
   pc_tag('TABLE BORDER=1');
--
   pc_tag('TR');
--
   FOR cs_rec IN cs_tables
    LOOP
--
      IF l_temp_counter > c_cols_per_row
       THEN
         pc_tag('/TR');
         pc_tag('TR');
         l_temp_counter := 1;
      end if;
--
      pc_tag('TD');
      pc_line('<A HREF="#'||g_item_type||'.'||cs_rec.table_name||'"> '||cs_rec.table_name||'</A>');
      pc_tag('/TD');
--
      l_temp_counter := l_temp_counter + 1;
--
   END LOOP;
--
   pc_tag('/TABLE');
--
   FOR cs_rec IN cs_tables
    LOOP
--
      pc_tag('HR WIDTH=55%');
--
      pc_tag('B');
      pc_line('<A NAME="'||g_item_type||'.'||cs_rec.table_name||'">'||cs_rec.table_name||cs_rec.temporary||'</A>');
      pc_line('<A HREF="#top">'||c_up_arrow_img_tag||'</A>');
      pc_tag('/B');
--
      pc_table_comments (p_table_name => cs_rec.table_name
                        ,p_table_type => 'TABLE'
                        );
--
      OPEN  cs_has_defaults (cs_rec.table_name);
      FETCH cs_has_defaults INTO l_dummy;
      l_has_defaults := cs_has_defaults%FOUND;
      CLOSE cs_has_defaults;
--
      pc_tag('TABLE BORDER=1');
--
      FOR cs_col_rec IN (SELECT *
                          FROM  user_tab_columns
                         WHERE  table_name = cs_rec.table_name
                         ORDER BY column_id
                        )
       LOOP
--
         pc_tag('TR');
--
         pc_tag('TD');
         pc_line(cs_col_rec.column_name);
         pc_tag('/TD');
--
         pc_tag('TD');
         pc_line(fn_nullable(cs_col_rec.nullable));
         pc_tag('/TD');
--
         pc_tag('TD');
         pc_line(fn_datatype(cs_col_rec.data_type
                            ,cs_col_rec.data_length
                            ,cs_col_rec.data_precision
                            ,cs_col_rec.data_scale
                            )
                );
         pc_tag('/TD');
--
         IF l_has_defaults
          THEN
--
            pc_tag('TD');
            pc_line(NVL(cs_col_rec.data_default,c_nbsp));
            pc_tag('/TD');
--
         END IF;
--
         pc_tag('/TR');
--
      END LOOP;
--
      pc_tag('/TABLE');
--
      pc_do_references (cs_rec.table_name);
--
   END LOOP;
--
   pc_write_html_footer;
--
   nm_debug.proc_end(g_package_name,'pc_write_tables_page');
--
END pc_write_tables_page;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_views_page IS
--
   CURSOR cs_views IS
   SELECT view_name
    FROM  user_views
   WHERE  view_name NOT LIKE g_package_name_to_bar||'%'
  ORDER BY view_name;
--
   CURSOR cs_view_text (p_view_name VARCHAR2) IS
   SELECT text
    FROM  user_views
   WHERE  view_name = p_view_name;
   l_text cs_view_text%ROWTYPE;
--
   l_temp_counter          NUMBER;
   c_cols_per_row CONSTANT NUMBER := 3;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_views_page');
--
   g_item_type := c_view_details;
--
   pc_write_html_header;
--
   pc_tag('H3');
   pc_line('<A NAME="top"> Views</A>');
   pc_line('<A HREF="javascript:history.back(1)">'
           ||REPLACE(c_left_arrow_img_tag,'%package%','Index')||'</A>'
          );
   pc_tag('/H3');
--
   pc_line('<TABLE BORDER=1><TR>');
--
   l_temp_counter := 1;
--
   FOR cs_rec IN cs_views
    LOOP
--
      IF l_temp_counter > c_cols_per_row
       THEN
         pc_line('</TR><TR>');
         l_temp_counter := 1;
      end if;
--
      pc_line('<TD><A HREF="#'||g_item_type||'.'||cs_rec.view_name||'"> '||cs_rec.view_name||'</A></TD>');
--
      l_temp_counter := l_temp_counter + 1;
--
   END LOOP;
--
   pc_line('</TR></TABLE><BR>');
--
   FOR cs_rec IN cs_views
    LOOP
--
      pc_line('<BR><HR WIDTH=55%><B>');
--
      pc_line('<A NAME="'||g_item_type||'.'||cs_rec.view_name||'">'||cs_rec.view_name||'</A>');
      pc_line('<A HREF="#top">'||c_up_arrow_img_tag||'</A>');
--
      pc_line('</B>');
--
      pc_table_comments (p_table_name => cs_rec.view_name
                        ,p_table_type => 'VIEW'
                        );
--
      BEGIN
         OPEN  cs_view_text (cs_rec.view_name);
         FETCH cs_view_text INTO l_text.text;
         pc_output_long(l_text.text);
      EXCEPTION
         WHEN OTHERS
          THEN
            Null;
      END;
      CLOSE cs_view_text;
--
      pc_do_references(cs_rec.view_name);
--
   END LOOP;
--
   pc_tag('HR WIDTH=55%');
--
   pc_write_html_footer;
--
   nm_debug.proc_end(g_package_name,'pc_write_views_page');
--
END pc_write_views_page;
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION fn_nullable (p_nullable IN user_tab_columns.nullable%TYPE) RETURN VARCHAR2 IS
   l_retval VARCHAR2(8) := c_nbsp;
BEGIN
   IF p_nullable = 'N'
    THEN
      l_retval := 'NOT NULL';
   END IF;
   RETURN l_retval;
END fn_nullable;
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION fn_datatype(p_data_type      IN user_tab_columns.data_type%TYPE
                    ,p_data_length    IN user_tab_columns.data_length%TYPE
                    ,p_data_precision IN user_tab_columns.data_precision%TYPE
                    ,p_data_scale     IN user_tab_columns.data_scale%TYPE
                    ) RETURN VARCHAR2 IS
--
   l_datatype VARCHAR2(40) := p_data_type;
--
BEGIN
--
   IF p_data_length IS NOT NULL
    THEN
      IF   l_datatype IN ('CHAR','VARCHAR2')
       OR (l_datatype = 'NUMBER' AND p_data_precision IS NOT NULL)
       THEN
         l_datatype := l_datatype||'(';
         IF p_data_precision IS NOT NULL
          THEN
            l_datatype := l_datatype||p_data_precision;
            IF NVL(p_data_scale,0) <> 0
             THEN
               l_datatype := l_datatype||','||p_data_scale;
            END IF;
         ELSE
            l_datatype := l_datatype||p_data_length;
         END IF;
         l_datatype := l_datatype||')';
      END IF;
   END IF;
--
   RETURN l_datatype;
--
END fn_datatype;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_long (p_text IN LONG) IS
--
   l_counter              NUMBER;
   l_pos                  NUMBER;
--
   l_temp                 LONG;
--
   TYPE tab_long IS TABLE OF LONG INDEX BY BINARY_INTEGER;
--
   l_orig_lines      tab_long;
   l_new_lines       tab_long;
--
   l_line_count      BINARY_INTEGER;
   l_last_pos        BINARY_INTEGER;
   l_nl_pos          BINARY_INTEGER;
   l_nl_pos2         BINARY_INTEGER;
--
   l_text_line       LONG;
   c_max_line_len    CONSTANT NUMBER := 100;
   l_count2          BINARY_INTEGER;
--
   l_id              BINARY_INTEGER := 0;
   l_actual_line_len BINARY_INTEGER;
--
   function return_len (p_text IN VARCHAR) RETURN number IS
      l_retval NUMBER := LENGTH(p_text);
   BEGIN
      FOR l_counter IN 1..LENGTH(p_text)
       LOOP
         IF SUBSTR(p_text,l_counter,1) IN (','
                                          ,';'
                                          ,' '
                                          )
          THEN
            l_retval := l_counter;
         END IF;
      END LOOP;
      RETURN l_retval;
   END;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_output_long');
--
   IF length(p_text) IS NULL
    THEN
      RETURN;
   END IF;
--
   l_line_count := 1;
   l_last_pos   := 1;
--
   LOOP
      l_nl_pos  := NVL(INSTR(p_text,CHR(10),l_last_pos,1),-1);
      l_nl_pos2 := NVL(INSTR(p_text,CHR(13),l_last_pos,1),-1);
      IF l_nl_pos > l_nl_pos2 AND l_nl_pos2 > 0
       THEN
         l_nl_pos := l_nl_pos2;
      END IF;
      IF l_nl_pos IN (0,-1) THEN
         l_nl_pos := LENGTH(p_text);
      END IF;
      l_orig_lines(l_line_count) := SUBSTR(p_text,l_last_pos,l_nl_pos-l_last_pos);
      nm_debug.debug(l_nl_pos||' '||length(p_text));
      EXIT WHEN (l_nl_pos = LENGTH(p_text) OR l_nl_pos IS NULL);
      l_line_count := l_line_count+1;
      l_last_pos   := l_nl_pos + 1;
   END LOOP;
--
   FOR l_count IN 1..l_orig_lines.COUNT
    LOOP
      l_text_line := l_orig_lines(l_count);
      l_count2    := 1;
      IF l_text_line IS NOT NULL
       THEN
         LOOP
           IF (l_count2+c_max_line_len) < LENGTH(l_text_line)
            THEN
              l_actual_line_len := return_len(substr(l_text_line,l_count2,c_max_line_len));
           ELSE
              l_actual_line_len := c_max_line_len;
           END IF;
           l_new_lines(l_new_lines.COUNT+1) := substr(l_text_line,l_count2,l_actual_line_len);
           IF l_count2 + l_actual_line_len >= NVL(length(l_text_line),0)
            THEN
              EXIT;
            ELSE
              l_count2 := l_count2 + l_actual_line_len;
            END IF;
         END LOOP;
      END IF;
   END LOOP;
--
   IF l_new_lines.COUNT > 0
    THEN
      pc_tag('PRE');
      FOR l_count IN 1..l_new_lines.COUNT
       LOOP
         IF LTRIM(RTRIM(l_new_lines(l_count))) IS NOT NULL
          THEN
            pc_line(l_new_lines(l_count));
         END IF;
      END LOOP;
      pc_tag('/PRE');
   END IF;
--
   nm_debug.proc_end(g_package_name,'pc_output_long');
--
END pc_output_long;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_output_triggers IS
--
   CURSOR cs_trigger IS
   SELECT trigger_name
         ,base_object_type
         ,triggering_event
         ,trigger_type
         ,column_name
         ,when_clause
         ,table_name
    FROM  user_triggers
   ORDER BY base_object_type, table_name, trigger_name;
--
   l_temp_counter          BINARY_INTEGER;
   c_cols_per_row CONSTANT NUMBER := 1;
--
   l_name                  VARCHAR2(240);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_output_triggers');
--
   g_item_type := c_trigger_details;
--
   pc_write_html_header;
--
   pc_tag('H3');
   pc_line('<A NAME="top"> Triggers</A>');
   pc_line('<A HREF="javascript:history.back(1)">'
           ||REPLACE(c_left_arrow_img_tag,'%package%','Index')||'</A>'
          );
   pc_tag('/H3');
--
   pc_tag('TABLE BORDER=1');
--
   pc_tag('TR');
--
   l_temp_counter := 1;
--
   FOR cs_rec IN cs_trigger
    LOOP
--
      IF l_temp_counter > c_cols_per_row
       THEN
         pc_tag('/TR');
         pc_tag('TR');
         l_temp_counter := 1;
      end if;
--
      pc_tag('TD');
--
      IF cs_rec.base_object_type IN ('TABLE','VIEW')
       THEN
         l_name := cs_rec.table_name||'.';
      ELSE
         l_name := cs_rec.base_object_type||' ';
      END IF;
      l_name := l_name||cs_rec.trigger_name;
--
      pc_line('<A HREF="#'||g_item_type||'.'||cs_rec.trigger_name||'"> '||l_name||'</A>');
      pc_tag('/TD');
--
      l_temp_counter := l_temp_counter + 1;
--
   END LOOP;
--
   pc_tag('/TR');
   pc_tag('/TABLE');
--
   pc_tag('BR');
--
   FOR cs_rec IN cs_trigger
    LOOP
--
      pc_tag('BR');
--
      pc_tag('HR WIDTH=55%');
--
      pc_tag('B');
      IF cs_rec.base_object_type IN ('TABLE','VIEW')
       THEN
         l_name := cs_rec.table_name||'.';
      ELSE
         l_name := cs_rec.base_object_type||' ';
      END IF;
      l_name := l_name||cs_rec.trigger_name;
--
      pc_line('<A NAME="'||g_item_type||'.'||cs_rec.trigger_name||'">'||l_name||'</A>');
      pc_line('<A HREF="#top">'||c_up_arrow_img_tag||'</A>');
      pc_tag('/B');
--
      pc_tag('BR');
--
      pc_line(cs_rec.trigger_type||' - '||cs_rec.triggering_event);
--
      IF cs_rec.column_name IS NOT NULL
       THEN
         pc_line ('Column '||cs_rec.column_name);
      END IF;
--
      IF cs_rec.when_clause IS NOT NULL
       THEN
         pc_output_long(cs_rec.when_clause);
      END IF;
--
      DECLARE
         CURSOR cs_trig_body IS
         SELECT trigger_body
          FROM  user_triggers
         WHERE  trigger_name = cs_rec.trigger_name;
         l_trig_body user_triggers.trigger_body%TYPE := Null;
      BEGIN
         OPEN  cs_trig_body;
         FETCH cs_trig_body INTO l_trig_body;
         CLOSE cs_trig_body;
         pc_output_long (l_trig_body);
      EXCEPTION
         WHEN others
          THEN
            IF cs_trig_body%ISOPEN
             THEN
               CLOSE cs_trig_body;
            END IF;
      END;
--
   END LOOP;
--
   pc_tag('HR WIDTH=55%');
--
   pc_write_html_footer;
--
   nm_debug.proc_end(g_package_name,'pc_output_triggers');
--
END pc_output_triggers;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_do_references (p_name IN VARCHAR2) IS
--
   CURSOR cs_dependencies (p_table_name  user_tab_columns.table_name%TYPE) IS
   SELECT *
    FROM  apd_dependencies
   WHERE  referenced_owner = USER
    AND   referenced_name  = p_table_name
    AND   referenced_type  = 'TABLE'
   ORDER BY owner, name, type;
--
   l_dummy_ref      cs_dependencies%ROWTYPE;
   l_has_references BOOLEAN;
--
   l_temp_counter              NUMBER := 1;
   c_cols_per_row     CONSTANT NUMBER := 3;
   c_dep_cols_per_row CONSTANT NUMBER := 2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_do_references ('||p_name||')');
--
   OPEN  cs_dependencies (p_name);
   FETCH cs_dependencies INTO l_dummy_ref;
   l_has_references := cs_dependencies%FOUND;
   CLOSE cs_dependencies;
--
   IF l_has_references
    THEN
--
      pc_line('Referenced By');
--
      pc_tag('TABLE BORDER=1');
      pc_tag('TR');
--
   END IF;
--
   l_temp_counter := 1;
--
   FOR cs_dep_rec IN cs_dependencies(p_name)
    LOOP
--
      IF l_temp_counter > c_dep_cols_per_row
       THEN
         pc_tag('/TR');
         pc_tag('TR');
         l_temp_counter := 1;
      END IF;
--
      pc_tag('TD');
--
      IF   cs_dep_rec.owner <> USER
       THEN
         pc_line(cs_dep_rec.type||' '||cs_dep_rec.owner||'.'||cs_dep_rec.name);
      ELSIF cs_dep_rec.type = 'TABLE'
       THEN
         pc_line('<A HREF="'||c_table_details||'.htm#'||c_table_details||'.'||cs_dep_rec.name||'">'||cs_dep_rec.type||' '||cs_dep_rec.name||'</A>');
      ELSIF cs_dep_rec.type = 'VIEW'
       THEN
         pc_line('<A HREF="'||c_view_details||'.htm#'||c_view_details||'.'||cs_dep_rec.name||'">'||cs_dep_rec.type||' '||cs_dep_rec.name||'</A>');
      ELSIF cs_dep_rec.type = 'TRIGGER'
       THEN
         pc_line('<A HREF="'||c_trigger_details||'.htm#'||c_trigger_details||'.'||cs_dep_rec.name||'">'||cs_dep_rec.type||' '||cs_dep_rec.name||'</A>');
      ELSIF cs_dep_rec.type IN ('PACKAGE','PACKAGE BODY')
       THEN
         pc_line('<A HREF="'||cs_dep_rec.name||'.htm"> '||cs_dep_rec.type||' '||cs_dep_rec.name||'</A>');
      ELSIF cs_dep_rec.type IN ('PROCEDURE','FUNCTION')
       THEN
         pc_line('<A HREF="'||c_default_package_name||'.htm#'||cs_dep_rec.name||'"> '||cs_dep_rec.type||' '||cs_dep_rec.name||'</A>');
      ELSIF cs_dep_rec.type = 'TYPE'
       THEN
         pc_line('<A HREF="'||c_type_details||'.htm#'||c_type_details||'.'||cs_dep_rec.name||'"> '||cs_dep_rec.type||' '||cs_dep_rec.name||'</A>');
      ELSE
         pc_line(cs_dep_rec.type||' '||cs_dep_rec.name);
      END IF;
--
      pc_tag('/TD');
--
      l_temp_counter := l_temp_counter + 1;
--
   END LOOP;
--
   IF l_has_references
    THEN
--
      pc_tag('/TR');
      pc_tag('/TABLE');
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'pc_do_references ('||p_name||')');
--
END pc_do_references;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_types_page IS
--
   CURSOR cs_types IS
   SELECT *
    FROM  user_types
  ORDER BY type_name;
--
   l_temp_counter          NUMBER;
   c_cols_per_row CONSTANT NUMBER := 3;
--
   CURSOR cs_type_body (p_type_name VARCHAR2) IS
   SELECT COUNT(*)
    FROM  user_source
   WHERE  name = p_type_name
    AND   type = 'TYPE BODY';
   l_count BINARY_INTEGER;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_types_page');
--
   g_item_type := c_type_details;
--
   pc_write_html_header;
--
   pc_tag('H3');
   pc_line('<A NAME="top"> Objects</A>');
   pc_line('<A HREF="javascript:history.back(1)">'
           ||REPLACE(c_left_arrow_img_tag,'%package%','Index')||'</A>'
          );
   pc_tag('/H3');
--
   pc_tag('TABLE BORDER=1');
--
   pc_tag('TR');
--
   l_temp_counter := 1;
--
   FOR cs_rec IN cs_types
    LOOP
--
      IF l_temp_counter > c_cols_per_row
       THEN
         pc_tag('/TR');
         pc_tag('TR');
         l_temp_counter := 1;
      end if;
--
      pc_tag('TD');
--
      pc_line('<A HREF="#'||g_item_type||'.'||cs_rec.type_name||'"> '||cs_rec.type_name||'</A>');
      pc_tag('/TD');
--
      l_temp_counter := l_temp_counter + 1;
--
   END LOOP;
--
   pc_tag('/TR');
   pc_tag('/TABLE');
--
   pc_tag('BR');
--
   FOR cs_rec IN cs_types
    LOOP
--
      pc_tag('BR');
--
      pc_tag('HR WIDTH=55%');
--
      pc_tag('B');
--
      pc_line('<A NAME="'||g_item_type||'.'||cs_rec.type_name||'">'||cs_rec.type_name||'</A>');
      pc_line('<A HREF="#top">'||c_up_arrow_img_tag||'</A>');
--
      pc_tag('/B');
--
      pc_tag('BR');
--
      pc_line(cs_rec.typecode);
--
      pc_tag('BR');
--
      IF cs_rec.attributes > 0
	   THEN
	     pc_tag ('TABLE BORDER=1');
--
         FOR cs_inner_rec IN (SELECT *
		                       FROM  user_type_attrs
                              WHERE  type_name = cs_rec.type_name
                             ORDER BY attr_no
                             )
          LOOP
            DECLARE
               l_type VARCHAR2(50);
            BEGIN
               pc_tag('TR');
               pc_tag('TD');
               pc_line(cs_inner_rec.attr_name);
               pc_tag('/TD');
               pc_tag('TD');
--
               l_type := fn_datatype(p_data_type      => cs_inner_rec.attr_type_name
                                    ,p_data_length    => cs_inner_rec.length
                                    ,p_data_precision => cs_inner_rec.precision
                                    ,p_data_scale     => cs_inner_rec.scale
                                    );
--
               IF NVL(cs_inner_rec.attr_type_owner,USER) <> USER
                THEN
                  l_type := cs_inner_rec.attr_type_owner||'.'||l_type;
               END IF;
--
               pc_line(l_type);
               pc_tag('/TD');
               pc_tag('/TR');
            END;
         END LOOP;
--
	     pc_tag ('/TABLE');
--
	  END IF;
--
      IF cs_rec.methods > 0
	   THEN
--
	     pc_tag ('TABLE BORDER=1');
--
         FOR cs_inner_rec IN (SELECT *
		                       FROM  user_type_methods
                              WHERE  type_name = cs_rec.type_name
                             ORDER BY method_no
                             )
          LOOP
            DECLARE
               l_meth_type VARCHAR2(15);
            BEGIN
               pc_tag('TR');
               pc_tag('TD');
   --
               IF cs_inner_rec.results = 0
                THEN
                  l_meth_type := 'PROCEDURE';
               ELSE
                  l_meth_type := 'FUNCTION';
               END IF;
--
               pc_line(l_meth_type||' '||cs_inner_rec.method_name);
--
               pc_tag('/TD');
               pc_tag('/TR');
            END;
         END LOOP;
--
	     pc_tag ('/TABLE');
--
      END IF;
--
      pc_line('<A HREF="'||cs_rec.type_name||'_SPEC.htm"> Type</A>');
--
      IF NOT g_in_production
       THEN
         OPEN  cs_type_body (cs_rec.type_name);
         FETCH cs_type_body INTO l_count;
         CLOSE cs_type_body;
         IF l_count > 0
          THEN
            pc_line('<A HREF="'||cs_rec.type_name||'_BODY.htm"> Type Body</A>');
         END IF;
      END IF;
--
   END LOOP;
--
   pc_write_html_footer;
--
   FOR cs_rec IN cs_types
    LOOP
      g_item_type := cs_rec.type_name||'_SPEC';
   --
      pc_write_html_header;
   --
      pc_line('<A HREF="javascript:history.back(1)">'
              ||REPLACE(c_left_arrow_img_tag,'%package%','Back')||'</A>'
             );
   --
      pc_tag('PLAINTEXT');
   --
      FOR cs_inner_rec IN cs_text(cs_rec.type_name, 'TYPE')
       LOOP
         pc_line(cs_inner_rec.text);
      END LOOP;
   --
      IF NOT g_in_production
       THEN
         OPEN  cs_type_body (cs_rec.type_name);
         FETCH cs_type_body INTO l_count;
         CLOSE cs_type_body;
         IF l_count > 0
          THEN
            g_item_type := cs_rec.type_name||'_BODY';
         --
            pc_write_html_header;
         --
            pc_line('<A HREF="javascript:history.back(1)">'
                    ||REPLACE(c_left_arrow_img_tag,'%package%','Back')||'</A>'
                   );
         --
            pc_tag('PLAINTEXT');
         --
            FOR cs_inner_rec IN cs_text(cs_rec.type_name, 'TYPE BODY')
             LOOP
               pc_line(cs_inner_rec.text);
            END LOOP;
         END IF;
      END IF;
   --
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'pc_write_types_page');
--
END pc_write_types_page;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_comment_block IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_comment_block');
--
   IF l_db_name IS NULL
    THEN
      FOR cs_rec IN (SELECT *
                      FROM  v$instance
                    )
       LOOP
         l_db_name       := cs_rec.instance_name;
         l_machine_name  := cs_rec.host_name;
         l_rdbms_version := cs_rec.version;
      END LOOP;
      FOR cs_rec IN (SELECT value
                      FROM  nls_database_parameters
                     WHERE  parameter = 'NLS_CHARACTERSET'
                    )
       LOOP
         l_character_set := cs_rec.value;
      END LOOP;
      IF NOT g_in_production
       THEN
         c_title            := LOWER(USER||'.'||l_db_name||'@'||l_machine_name);
         IF UPPER(l_machine_name) = 'EXDL3'
          THEN
            c_exor_url         := 'http://devanet.exor.co.uk';
            c_exor_information := 'exor Internal Oracle Development Intranet';
         END IF;
      END IF;
   END IF;
--
   pc_tag('HTML');
   pc_tag('HEAD');
   pc_line('<!-- ******************************************* -->');
   pc_line('<!-- * Do not edit this HTML file. Any changes * -->');
   pc_line('<!-- * made will be overwritten the next time  * -->');
   pc_line('<!-- *      these files are generated.         * -->');
   pc_line('<!-- ******************************************* -->');
   pc_line('<!-- *             Copyright 2000              * -->');
   pc_line('<!-- *             Jonathan Mills              * -->');
   pc_line('<!-- *             exor Corp. Ltd.             * -->');
   pc_line('<!-- ******************************************* -->');
   pc_line('<!-- *     This HTML file was generated at     * -->');
   pc_line('<!-- *           '||to_char(sysdate,'HH24:MI:SS DD Mon YYYY')||'          * -->');
   pc_line('<!-- ******************************************* -->');
   pc_line('<!-- * Schema : '||rpad(user,30)||' * -->');
   pc_line('<!-- * DB     : '||rpad(l_db_name,30)||' * -->');
   pc_line('<!-- * Version: '||rpad(l_rdbms_version,30)||' * -->');
   pc_line('<!-- * CharSet: '||rpad(l_character_set,30)||' * -->');
   pc_line('<!-- * Machine: '||rpad(l_machine_name,30)||' * -->');
   pc_line('<!-- ******************************************* -->');
--
   nm_debug.proc_end(g_package_name,'pc_write_comment_block');
--
END pc_write_comment_block;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_index_file IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_index_file');
--
   g_item_type := 'INDEX';
--
   pc_write_comment_block;
   pc_line('<TITLE>');
   pc_line(c_title);
   pc_line('</TITLE>');
   pc_line('</HEAD>');
   pc_line('</HTML>');
--
   pc_line(' <frameset framespacing=0 frameborder=0 border=0 cols="140,1*">');
   pc_line('   <frame name=contents src="left_frame.htm" noresize>');
   pc_line('   <frameset framespacing=0 frameborder=0 border=0 rows="100,*">');
   pc_line('      <frame name=top_frame src="top_frame.htm">');
   pc_line('      <frame name=main1 src="'||c_right_frame ||'.htm">');
   pc_line('   </frameset>');
   pc_line(' <noframes>');
   pc_line('   <body lang=EN-GB style='||CHR(39)||'tab-interval:.5in'||CHR(39)||'>');
   pc_line('   <div class=Section1>');
   pc_line('   <p>This page uses frames, but your browser doesn'||CHR(39)||'t support them.</p>');
   pc_line('   </div>');
   pc_line('   </body>');
   pc_line(' </noframes>');
   pc_line('</frameset>');
--
   nm_debug.proc_end(g_package_name,'pc_write_index_file');
--
END pc_write_index_file;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_top_frame IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_top_frame');
--
   g_item_type := 'TOP_FRAME';
--
   pc_write_comment_block;
--
   pc_line('</head>');
--
   pc_tag('BODY BGCOLOR="'||c_exor_green||'" TEXT="'||c_exor_orange||'" LINK="'||c_exor_orange||'" ALINK="'||c_exor_orange||'" VLINK="'||c_exor_orange||'"');
--
   pc_tag('TABLE WIDTH=100% BORDER=0');
   pc_tag('TR');
   pc_tag('TD WIDTH=40');
   pc_line(c_nbsp);
   pc_tag('/TD');
   pc_tag('TD');
--
   pc_line('<table border="0" width="100%" cellspacing="0" cellpadding="0">');
   pc_line('  <tr>');
   pc_line('    <td>');
   pc_line('<DIV ALIGN="LEFT">');
   pc_line('<form name="f">');
   pc_line('<select onChange="parent.parent.main1.location.href=(this[this.selectedIndex].value)">');
   pc_line('    <option value="'||c_right_frame||'.htm" selected>Select...</option>');
--
   pc_line('    <option value="'||c_package_details||'.htm">Packages</option>');
--
   FOR l_counter IN 1..l_packages_done.COUNT
    LOOP
      pc_line('    <option value="'||lower(l_packages_done(l_counter))||'.htm" >'||c_nbsp||'-'||lower(l_packages_done(l_counter))||'</option>');
      IF l_packages_done(l_counter) <> c_default_package_name
       THEN
         pc_line('    <option value="'||lower(l_packages_done(l_counter))||'_spec.htm" >'||c_nbsp||c_nbsp||'-'||'Spec</option>');
--
         IF NOT g_in_production
          THEN
            pc_line('    <option value="'||lower(l_packages_done(l_counter))||'_body.htm" >'||c_nbsp||c_nbsp||'-'||'Body</option>');
         END IF;
--
      END IF;
   END LOOP;
--
   pc_line('    <option value="'||c_type_details||'.htm" >Objects</option>');
   pc_line('    <option value="'||c_table_details||'.htm" >Tables</option>');
   pc_line('    <option value="'||c_trigger_details||'.htm" >Triggers</option>');
   pc_line('    <option value="'||c_view_details||'.htm" >Views</option>');
--
   pc_line('  </select>');
   pc_line('</form>');
   pc_line('</DIV>');
   pc_line('</TD>');
   pc_line('<TD NOWRAP>');
   pc_line('<DIV ALIGN="CENTER">');
   pc_line('<H2>');
   pc_line(c_title);
   pc_line('</H2>');
   pc_line('<A HREF="'||c_exor_url||'" TARGET="_top"><I>©2000 exor Corporation Ltd</I></A>');
   pc_line('</DIV>');
   pc_line('</TD>');
   pc_line('<TD>');
   pc_line(fn_make_link_to_exor('<IMG SRC="images/exor_green_on_orange.gif" ALT="'||c_exor_information||'" BORDER=0 ALIGN="RIGHT">'));
   pc_line('</TD>');
   pc_line('</TR>');
   pc_line('</TABLE>');
--
   pc_write_html_footer;
--
   nm_debug.proc_end(g_package_name,'pc_write_top_frame');
--
END pc_write_top_frame;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_write_right_frame IS
--
   c_num_cols NUMBER := 4;
--
   PROCEDURE pc_local_blank_tab_line IS
   BEGIN
      pc_line('</TR><TR><TD COLSPAN='||c_num_cols||'>'||c_nbsp||'</TD></TR><TR>');
   END pc_local_blank_tab_line;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_write_right_frame');
--
   g_item_type := c_right_frame;
--
   pc_write_html_header;
--
   pc_line('<TABLE BGCOLOR="WHITE" BORDER=0 WIDTH=100%><TR>');
--
   IF NOT g_in_production
    THEN
      pc_line('<TR><TD ALIGN="CENTER" COLSPAN='||c_num_cols||'>');
      pc_line('<I><BIG>Generated '||to_char(sysdate,'HH24:MI:SS DD Mon YYYY')||'</BIG></I>');
      pc_line('</TD></TR>');
   ELSE
      pc_local_blank_tab_line;
   END IF;
--
   pc_local_blank_tab_line;
--
   pc_line('<TD COLSPAN='||c_num_cols||' ALIGN="CENTER" VALIGN="MIDDLE">');
   pc_line(fn_make_link_to_exor('<IMG SRC="images/exor-big.gif" ALT="'||c_exor_information||'" BORDER=0 ALIGN="CENTER">'));
   pc_line('</TD>');
--
   pc_local_blank_tab_line;
--
   pc_line('<TD COLSPAN='||c_num_cols||' VALIGN="MIDDLE">');
   pc_line('<DIV ALIGN="CENTER"><H1><A HREF="'||c_package_details||'.htm">'||c_title||'</A></H1></DIV>');
   pc_line('</TD>');
--
   pc_local_blank_tab_line;
--
   pc_line('<TD ALIGN="CENTER" VALIGN="MIDDLE">');
   pc_line(fn_make_link_to_exor('<IMG SRC="images/highways.gif" ALT="Highways powered by Oracle" BORDER=0 ALIGN="CENTER">'));
   pc_line('</TD>');
   pc_line('<TD ALIGN="CENTER" VALIGN="MIDDLE">');
   pc_line(fn_make_link_to_exor('<IMG SRC="images/esri.gif" ALT="ESRI" BORDER=0 ALIGN="CENTER">'));
   pc_line('</TD>');
   pc_line('<TD ALIGN="CENTER" VALIGN="MIDDLE">');
   pc_line(fn_make_link_to_exor('<IMG SRC="images/sdepower2.gif" ALT="Powered by SDE" BORDER=0 ALIGN="CENTER">'));
   pc_line('</TD>');
   pc_line('<TD ALIGN="CENTER" VALIGN="MIDDLE">');
   pc_line(fn_make_link_to_exor('<IMG SRC="images/on-oracle.gif" ALT="On Oracle" BORDER=0 ALIGN="CENTER">'));
   pc_line('</TD>');
--
   IF NOT g_in_production
    AND UPPER(l_machine_name) = 'EXDL3'
    THEN
--
      pc_local_blank_tab_line;
      pc_line('<TD ALIGN="CENTER" COLSPAN='||c_num_cols||' VALIGN="MIDDLE">');
      pc_line('<IMG SRC="images/apache_pb.gif" ALT="Powered By Apache" BORDER=0 ALIGN="CENTER">');
      pc_line('</TD>');
--
   END IF;
--
   pc_line('</TR>');
--
   pc_line('</TABLE>');
--
   pc_write_html_footer;
--
   nm_debug.proc_end(g_package_name,'pc_write_right_frame');
--
END pc_write_right_frame;
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION fn_make_link_to_exor(p_text IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN '<A HREF="'||c_exor_url||'" TARGET="_top">'
           ||p_text
           ||'</A>';
END fn_make_link_to_exor;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE pc_table_comments (p_table_name IN VARCHAR2
                            ,p_table_type IN VARCHAR2
                            ) IS
--
   CURSOR cs_comments (c_table_name VARCHAR2
                      ,c_table_type VARCHAR2
                      ) IS
   SELECT comments
    FROM  user_tab_comments
   WHERE  table_name = c_table_name
    AND   table_type = c_table_type
    AND   comments   IS NOT NULL;
--
   l_comments user_tab_comments.comments%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'pc_table_comments ('||p_table_name||','||p_table_type||')');
--
   OPEN  cs_comments (p_table_name, p_table_type);
   FETCH cs_comments INTO l_comments;
   IF cs_comments%FOUND
    THEN
      pc_tag('BR');
      pc_tag('FONT COLOR="'||c_procedure_colour||'"');
      pc_line(l_comments);
      pc_tag('/FONT');
      pc_tag('BR');
   END IF;
   CLOSE cs_comments;
--
   nm_debug.proc_end(g_package_name,'pc_table_comments ('||p_table_name||','||p_table_type||')');
--
END pc_table_comments;
--
----------------------------------------------------------------------------------------------------------------
--
PROCEDURE in_production IS
BEGIN
   g_in_production := TRUE;
END in_production;
--
----------------------------------------------------------------------------------------------------------------
--
END apd;
/
