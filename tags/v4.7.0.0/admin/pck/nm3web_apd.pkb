CREATE OR REPLACE PACKAGE BODY nm3web_apd AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web_apd.pkb-arc   2.3   Jul 04 2013 16:35:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3web_apd.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:54:26  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on         : 1.2
--
--
--   Author : Jonathan Mills
--
--   NM3 Web APD Package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.3  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web_apd';
--
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0005';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   CURSOR cs_obj (c_type VARCHAR2
                 ) IS
   SELECT object_name
    FROM  all_objects
   WHERE  owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   object_type = c_type
   ORDER BY object_name;
--
   TYPE tab_atc IS TABLE OF all_tab_columns%ROWTYPE INDEX BY BINARY_INTEGER;
--
   g_tab_text nm3type.tab_varchar4000;
--
   c_user_opt_depend  CONSTANT hig_user_options.huo_id%TYPE          := 'WEBAPDDEP';
   c_user_opt_radio   CONSTANT hig_user_options.huo_id%TYPE          := 'WEBAPDRAD';
   dont_do_it  EXCEPTION;
--
   c_checked   CONSTANT VARCHAR2(8) := ' CHECKED';
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_page_of_radios (p_proc_to_call    VARCHAR2
                                ,p_page_title      VARCHAR2
                                ,p_tab_object_name nm3type.tab_varchar30
                                );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_listbox_of_items (p_proc_to_call    VARCHAR2
                                  ,p_page_title      VARCHAR2
                                  ,p_tab_object_name nm3type.tab_varchar30
                                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_tab_cols (p_table_name   IN     VARCHAR2
                       ,p_tab_atc         OUT tab_atc
                       ,p_tab_not_null    OUT nm3type.tab_varchar30
                       ,p_tab_datatype    OUT nm3type.tab_varchar2000
                       ,p_tab_comment     OUT nm3type.tab_varchar32767
                       );
--
----------------------------------------------------------------------------------------------------------------
--
FUNCTION fn_datatype(p_data_type      IN user_tab_columns.data_type%TYPE
                    ,p_data_length    IN user_tab_columns.data_length%TYPE
                    ,p_data_precision IN user_tab_columns.data_precision%TYPE
                    ,p_data_scale     IN user_tab_columns.data_scale%TYPE
                    ) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_and_display_cols (p_table_name VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE display_table_name_and_comment (p_table_name VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE display_constraints (p_table_name VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE display_statistics (p_table_name VARCHAR2);
--
-----------------------------------------------------------------------------
--
FUNCTION replace_spaces_and_lf (p_text VARCHAR2) RETURN VARCHAR2;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_cons_cols (p_con_name VARCHAR2
                       ,p_table    VARCHAR2
                       );
--
-----------------------------------------------------------------------------
--
PROCEDURE do_references (p_name VARCHAR2
                        ,p_type VARCHAR2
                        );
--
-----------------------------------------------------------------------------
--
PROCEDURE do_referenced_by (p_name VARCHAR2
                           ,p_type VARCHAR2
                           );
--
-----------------------------------------------------------------------------
--
FUNCTION proc_exists (p_type VARCHAR2) RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
--
PROCEDURE output_varchar_as_html_code (p_text VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE output_varchar_as_html (p_text VARCHAR2);
--
-----------------------------------------------------------------------------
--
PROCEDURE do_package_procedures (p_package_name VARCHAR2);
--
-----------------------------------------------------------------------------
--
FUNCTION get_from_source (p_name VARCHAR2
                         ,p_type VARCHAR2 DEFAULT 'PACKAGE'
                         ) RETURN nm3type.tab_varchar4000;
--
-----------------------------------------------------------------------------
--
PROCEDURE extract_tagged_text (pi_tag    VARCHAR2
                              ,pi_colour VARCHAR2
                              ,pi_name   VARCHAR2 DEFAULT NULL
                              );
--
-----------------------------------------------------------------------------
--
FUNCTION do_dependencies RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
--
FUNCTION do_radio RETURN BOOLEAN;
--
-----------------------------------------------------------------------------
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
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   SCCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : @(#)nm3web_apd.pkb	1.2 08/27/02');
   htp.p('--       Module Name      : nm3web_apd.pkb');
   htp.p('--       Date into SCCS   : 02/08/27 14:44:58');
   htp.p('--       Date fetched Out : 07/06/13 14:13:47');
   htp.p('--       SCCS Version     : 1.2');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--   Web APD');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
--
-----------------------------------------------------------------------------
--
PROCEDURE launch_apd IS
--
   l_tab_proc nm3type.tab_varchar30;
   l_tab_desc nm3type.tab_varchar30;
   l_checked VARCHAR2(10) := c_checked;
--
   PROCEDURE add_proc (p_proc VARCHAR2, p_desc VARCHAR2) IS
      l_c CONSTANT PLS_INTEGER := l_tab_proc.COUNT+1;
   BEGIN
      l_tab_proc(l_c) := p_proc;
      l_tab_desc(l_c) := p_desc;
   END add_proc;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'launch_apd');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   nm3web.module_startup(pi_module => c_this_module);
--
   add_proc ('package_details', 'Packages');
   add_proc ('table_details', 'Tables');
   add_proc ('view_details', 'Views');
   add_proc ('trigger_details', 'Triggers');
--
   htp.p('<TABLE ALIGN=CENTER>');
   htp.formopen(g_package_name||'.launch_something');
   --
   FOR i IN 1..l_tab_proc.COUNT
    LOOP
      htp.tablerowopen(calign => 'CENTER');
      htp.tabledata(l_tab_desc(i));
      htp.tabledata('<INPUT TYPE=RADIO NAME="p_pack_proc" VALUE="'||g_package_name||'.'||l_tab_proc(i)||'"'||l_checked||'>');
      l_checked := Null;
      htp.tablerowclose;
   END LOOP;
   htp.tablerowopen(calign => 'CENTER');
   htp.tabledata(nm3web.c_nbsp,cattributes=>'COLSPAN=2');
   htp.tablerowclose;
   htp.tablerowopen(calign => 'CENTER');
   IF do_dependencies
    THEN
      l_checked := c_checked;
   ELSE
      l_checked := Null;
   END IF;
   htp.tabledata(htf.small(NVL(nm3get.get_hco (pi_hco_domain      => 'USER_OPTIONS'
                                              ,pi_hco_code        => c_user_opt_depend
                                              ,pi_raise_not_found => FALSE
                                              ).hco_meaning
                              ,'Calculate Dependencies'
                              )
                          )
                );
   htp.tabledata('<INPUT TYPE=CHECKBOX NAME="p_dependency" VALUE="Y"'||l_checked||'>');
   htp.tablerowclose;
   htp.tablerowopen(calign => 'CENTER');
   IF do_radio
    THEN
      l_checked := c_checked;
   ELSE
      l_checked := Null;
   END IF;
   htp.tabledata(htf.small(NVL(nm3get.get_hco (pi_hco_domain      => 'USER_OPTIONS'
                                              ,pi_hco_code        => c_user_opt_radio
                                              ,pi_raise_not_found => FALSE
                                              ).hco_meaning
                              ,'Use Radio Buttons'
                              )
                          )
                );
   htp.tabledata('<INPUT TYPE=CHECKBOX NAME="p_radio" VALUE="Y"'||l_checked||'>');
   htp.tablerowclose;
   htp.tablerowopen(calign => 'CENTER');
   htp.tabledata(htf.formsubmit (cvalue=>'Continue'),cattributes=>'COLSPAN=2');
   htp.formclose;
   htp.tablerowclose;
   htp.tableclose;
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'launch_apd');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END launch_apd;
--
-----------------------------------------------------------------------------
--
PROCEDURE launch_something (p_pack_proc  VARCHAR2
                           ,p_dependency VARCHAR2 DEFAULT 'N'
                           ,p_radio      VARCHAR2 DEFAULT 'N'
                           ) IS
   l_val VARCHAR2(1);
BEGIN
   IF p_dependency = 'Y'
    THEN
      l_val := 'Y';
   ELSE
      l_val := 'N';
   END IF;
   nm3user.set_user_option (pi_huo_hus_user_id => To_Number(Sys_Context('NM3CORE','USER_ID'))
                           ,pi_huo_id          => c_user_opt_depend
                           ,pi_huo_value       => l_val
                           );
   IF p_radio = 'Y'
    THEN
      l_val := 'Y';
   ELSE
      l_val := 'N';
   END IF;
   nm3user.set_user_option (pi_huo_hus_user_id => To_Number(Sys_Context('NM3CORE','USER_ID'))
                           ,pi_huo_id          => c_user_opt_radio
                           ,pi_huo_value       => l_val
                           );
   EXECUTE IMMEDIATE 'BEGIN '||p_pack_proc||'; END;';
END launch_something;
--
-----------------------------------------------------------------------------
--
PROCEDURE table_details IS
--
   l_tab_tabs nm3type.tab_varchar30;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'table_details');
--
   nm3web.module_startup(pi_module => c_this_module);
--
   OPEN  cs_obj (c_type => 'TABLE'
                );
   FETCH cs_obj BULK COLLECT INTO l_tab_tabs;
   CLOSE cs_obj;
--
   IF do_radio
    THEN
      create_page_of_radios   (p_proc_to_call    => g_package_name||'.individual_table_detail'
                              ,p_page_title      => 'Tables'
                              ,p_tab_object_name => l_tab_tabs
                              );
   ELSE
      create_listbox_of_items (p_proc_to_call    => g_package_name||'.individual_table_detail'
                              ,p_page_title      => 'Tables'
                              ,p_tab_object_name => l_tab_tabs
                              );
   END IF;
--
   nm_debug.proc_end(g_package_name,'table_details');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END table_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE trigger_details IS
--
   l_tab_trigs nm3type.tab_varchar30;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'trigger_details');
--
   nm3web.module_startup(pi_module => c_this_module);
--
   OPEN  cs_obj (c_type => 'TRIGGER'
                );
   FETCH cs_obj BULK COLLECT INTO l_tab_trigs;
   CLOSE cs_obj;
--
   IF do_radio
    THEN
      create_page_of_radios   (p_proc_to_call    => g_package_name||'.individual_trigger_detail'
                              ,p_page_title      => 'Triggers'
                              ,p_tab_object_name => l_tab_trigs
                              );
   ELSE
      create_listbox_of_items (p_proc_to_call    => g_package_name||'.individual_trigger_detail'
                              ,p_page_title      => 'Triggers'
                              ,p_tab_object_name => l_tab_trigs
                              );
   END IF;
--
   nm_debug.proc_end(g_package_name,'trigger_details');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END trigger_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE individual_trigger_detail (p_trigger_name VARCHAR2) IS
--
   CURSOR cs_trigger_dets (c_trig  VARCHAR2
                          ) IS
   SELECT trigger_type
         ,triggering_event
         ,table_owner
         ,base_object_type
         ,table_name
         ,column_name
         ,referencing_names
         ,when_clause
         ,status
         ,description
         ,action_type
    FROM  all_triggers
   WHERE  owner        = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   trigger_name = c_trig;
--
   l_rec_trg cs_trigger_dets%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'individual_trigger_detail');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   nm3web.module_startup(pi_module => c_this_module);
--
   OPEN  cs_trigger_dets (p_trigger_name);
   FETCH cs_trigger_dets INTO l_rec_trg;
   CLOSE cs_trigger_dets;
--
   htp.p(replace_spaces_and_lf(l_rec_trg.description));
--
   htp.br;
   htp.hr(cattributes=>'WIDTH=75%');
   htp.br;
--
   DECLARE
      l_too_big EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_too_big,-6502);
      CURSOR cs_trig_text (c_trig  VARCHAR2
                          ) IS
      SELECT trigger_body
       FROM  all_triggers
      WHERE  owner        = Sys_Context('NM3CORE','APPLICATION_OWNER')
       AND   trigger_name = c_trig;
      l_trigger_text VARCHAR2(32767);
   BEGIN
      OPEN  cs_trig_text (p_trigger_name);
      FETCH cs_trig_text INTO l_trigger_text;
      CLOSE cs_trig_text;
      output_varchar_as_html_code(l_trigger_text);
   EXCEPTION
      WHEN l_too_big
       THEN
         htp.br;
         htp.p(htf.small('Trigger body > 32K'));
         htp.br;
   END;
--
   htp.br;
   htp.hr(cattributes=>'WIDTH=75%');
   htp.br;
--
   do_references (p_name => p_trigger_name
                 ,p_type => 'TRIGGER'
                 );
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'individual_trigger_detail');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END individual_trigger_detail;
--
-----------------------------------------------------------------------------
--
PROCEDURE individual_table_detail (p_table_name VARCHAR2) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'individual_table_detail');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   nm3web.module_startup(pi_module => c_this_module);
--
   display_table_name_and_comment(p_table_name);
--
   get_and_display_cols (p_table_name => p_table_name);
--
   display_constraints (p_table_name);
--
   do_referenced_by (p_name => p_table_name
                    ,p_type => 'TABLE'
                    );
--
   display_statistics (p_table_name);
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'individual_table_detail');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END individual_table_detail;
--
-----------------------------------------------------------------------------
--
PROCEDURE package_details IS
--
   l_tab_packs nm3type.tab_varchar30;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'package_details');
--
   nm3web.module_startup(pi_module => c_this_module);
--
   OPEN  cs_obj (c_type => 'PACKAGE'
                );
   FETCH cs_obj BULK COLLECT INTO l_tab_packs;
   CLOSE cs_obj;
--
   IF do_radio
    THEN
      create_page_of_radios   (p_proc_to_call    => g_package_name||'.individual_package_detail'
                              ,p_page_title      => 'Packages'
                              ,p_tab_object_name => l_tab_packs
                              );
   ELSE
      create_listbox_of_items (p_proc_to_call    => g_package_name||'.individual_package_detail'
                              ,p_page_title      => 'Packages'
                              ,p_tab_object_name => l_tab_packs
                              );
   END IF;
--
   nm_debug.proc_end(g_package_name,'package_details');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END package_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE individual_package_detail (p_package_name VARCHAR2) IS
--
   PROCEDURE get_version_int (p_func VARCHAR2) IS
      l_version VARCHAR2(4000) := nm3web.c_nbsp;
      l_cur     nm3type.ref_cursor;
   BEGIN
      BEGIN
         OPEN  l_cur FOR 'SELECT '||p_package_name||'.'||p_func||' From dual';
         FETCH l_cur INTO l_version;
      EXCEPTION
         WHEN OTHERS
          THEN
            l_version := 'Version function not defined';
      END;
      IF l_cur%ISOPEN
       THEN
         CLOSE l_cur;
      END IF;
      htp.tabledata(htf.small(l_version));
   END get_version_int;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'individual_package_detail');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   nm3web.module_startup(pi_module => c_this_module);
--
   g_tab_text := get_from_source (p_package_name);
--
   htp.p(p_package_name);
--
   htp.br;
   htp.br;
   htp.tableopen;
   htp.tablerowopen;
   htp.tableheader(htf.small('Header Version'));
   get_version_int('get_version');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader(htf.small('Body Version'));
   get_version_int('get_body_version');
   htp.tablerowclose;
   htp.tableclose;
   htp.br;
--
   extract_tagged_text('PACKAGE','DARKBLUE');
   extract_tagged_text('GLOBVAR','DARKRED');
   extract_tagged_text('PRAGMA','DARKGREEN');
--
   do_package_procedures (p_package_name);
--
   do_references (p_name => p_package_name
                 ,p_type => 'PACKAGE'
                 );
   do_referenced_by (p_name => p_package_name
                    ,p_type => 'PACKAGE'
                    );
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'individual_package_detail');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END individual_package_detail;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_individual (p_proc_to_call VARCHAR2
                         ,p_object_name  VARCHAR2
                         ) IS
BEGIN
   EXECUTE IMMEDIATE 'BEGIN '||p_proc_to_call||'(:p_obj); END;' USING p_object_name;
END get_individual;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_listbox_of_items (p_proc_to_call    VARCHAR2
                                  ,p_page_title      VARCHAR2
                                  ,p_tab_object_name nm3type.tab_varchar30
                                  ) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_listbox_of_items');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   nm3web.module_startup(pi_module => c_this_module);
--
   htp.p('<DIV ALIGN=CENTER>');
   htp.tableopen(calign => 'CENTER');
   htp.formopen(g_package_name||'.get_individual');
   htp.p('<INPUT TYPE=HIDDEN NAME="p_proc_to_call" VALUE="'||p_proc_to_call||'">');
   --
   htp.tablerowopen(calign => 'CENTER');
   htp.tableheader(p_page_title);
   htp.tablerowclose;
   --
   htp.tablerowopen(calign => 'CENTER');
   htp.p('<TD>');
   htp.formselectopen (cname => 'p_object_name');
   FOR i IN 1..p_tab_object_name.COUNT
    LOOP
      htp.formselectoption(p_tab_object_name(i));
   END LOOP;
   htp.formselectclose;
   htp.p('</TD>');
   htp.tablerowclose;
   --
   htp.tablerowopen(calign => 'CENTER');
   htp.tabledata(htf.formsubmit (cvalue=>'Continue'));
   htp.tablerowclose;
   --
   htp.formclose;
   htp.tableclose;
   htp.p('</DIV>');
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'create_listbox_of_items');
--
END create_listbox_of_items;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_page_of_radios (p_proc_to_call    VARCHAR2
                                ,p_page_title      VARCHAR2
                                ,p_tab_object_name nm3type.tab_varchar30
                                ) IS
--
   l_count   PLS_INTEGER;
   l_checked VARCHAR2(10) := c_checked;
   c_cols    CONSTANT PLS_INTEGER := 3;
   c_colspan CONSTANT PLS_INTEGER := c_cols*2;
   l_blank_cells_to_do PLS_INTEGER;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_page_of_radios');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   nm3web.module_startup(pi_module => c_this_module);
--
--
   htp.p('<DIV ALIGN=CENTER>');
   htp.tableopen(calign => 'CENTER');
   htp.formopen(g_package_name||'.get_individual');
   htp.p('<INPUT TYPE=HIDDEN NAME="p_proc_to_call" VALUE="'||p_proc_to_call||'">');
   --
   htp.tablerowopen(calign => 'CENTER');
   --htp.tableheader(p_page_title,cattributes=>'COLSPAN='||c_colspan);
   htp.tableheader(p_page_title);
   htp.tablerowclose;
   --
   l_count := 0;
   htp.tablerowopen;
   htp.p('<TD>');
   htp.p('<TABLE BORDER=1>');
   WHILE l_count <= p_tab_object_name.COUNT
    LOOP
      htp.tablerowopen(calign => 'CENTER');
      FOR i IN 1..c_cols
       LOOP
         l_count := l_count + 1;
         EXIT WHEN NOT p_tab_object_name.EXISTS(l_count);
         htp.p('<TD>');
         htp.p('<TABLE WIDTH=100%>');
         htp.tablerowopen;
         htp.tabledata('<FONT SIZE=-1>'||p_tab_object_name(l_count)||'</FONT>');
         htp.tabledata('<INPUT TYPE=RADIO NAME="p_object_name" VALUE="'||p_tab_object_name(l_count)||'"'||l_checked||'>',cattributes=>'ALIGN=RIGHT');
         htp.tablerowclose;
         l_checked := Null;
         htp.p('</TABLE>');
         htp.p('</TD>');
         l_blank_cells_to_do := c_cols-i;
      END LOOP;
      --
      -- put some empty cells in
      --
      IF NOT p_tab_object_name.EXISTS(l_count)
       THEN
         FOR i IN 1..l_blank_cells_to_do
          LOOP
            htp.tabledata (nm3web.c_nbsp);
         END LOOP;
      END IF;
      htp.tablerowclose;
   END LOOP;
   --
   htp.p('</TABLE>');
   htp.p('</TD>');
   --
   htp.tablerowopen(calign => 'CENTER');
   htp.tabledata(htf.formsubmit (cvalue=>'Continue'),cattributes=>'COLSPAN='||c_colspan);
   htp.tablerowclose;
   --
   htp.formclose;
   htp.tableclose;
   htp.p('</DIV>');
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'create_page_of_radios');
--
END create_page_of_radios;
--
-----------------------------------------------------------------------------
--
PROCEDURE view_details IS
--
   l_tab_views nm3type.tab_varchar30;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'view_details');
--
   nm3web.module_startup(pi_module => c_this_module);
--
   OPEN  cs_obj (c_type => 'VIEW'
                );
   FETCH cs_obj BULK COLLECT INTO l_tab_views;
   CLOSE cs_obj;
--
   IF do_radio
    THEN
      create_page_of_radios   (p_proc_to_call    => g_package_name||'.individual_view_detail'
                              ,p_page_title      => 'Views'
                              ,p_tab_object_name => l_tab_views
                              );
   ELSE
      create_listbox_of_items (p_proc_to_call    => g_package_name||'.individual_view_detail'
                              ,p_page_title      => 'Views'
                              ,p_tab_object_name => l_tab_views
                              );
   END IF;
--
   nm_debug.proc_end(g_package_name,'view_details');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END view_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE individual_view_detail (p_view_name VARCHAR2) IS
--
   CURSOR cs_view_len (c_view  VARCHAR2
                      ) IS
   SELECT text_length
    FROM  all_views
   WHERE  owner     = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   view_name = c_view;
--
   CURSOR cs_view_text (c_view  VARCHAR2
                       ) IS
   SELECT text
    FROM  all_views
   WHERE  owner     = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   view_name = c_view;
--
   l_view_text_length PLS_INTEGER;
--
   l_view_text        VARCHAR2(32767);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'individual_view_detail');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
   sccs_tags;
   htp.bodyopen;
   nm3web.module_startup(pi_module => c_this_module);
--
   display_table_name_and_comment(p_view_name);
--
   OPEN  cs_view_len (p_view_name);
   FETCH cs_view_len INTO l_view_text_length;
   CLOSE cs_view_len;
--
   get_and_display_cols (p_table_name => p_view_name);
--
   IF l_view_text_length <= 32767
    THEN
      OPEN  cs_view_text (p_view_name);
      FETCH cs_view_text INTO l_view_text;
      CLOSE cs_view_text;
      --
      htp.br;
      htp.hr(cattributes=>'WIDTH=75%');
      htp.br;
      output_varchar_as_html_code(l_view_text);
      --
   END IF;
--
   htp.br;
   htp.hr(cattributes=>'WIDTH=75%');
   htp.br;
--
   do_references (p_name => p_view_name
                 ,p_type => 'VIEW'
                 );
   do_referenced_by (p_name => p_view_name
                    ,p_type => 'VIEW'
                    );
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'individual_view_detail');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
END individual_view_detail;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_tab_cols (p_table_name   IN     VARCHAR2
                       ,p_tab_atc         OUT tab_atc
                       ,p_tab_not_null    OUT nm3type.tab_varchar30
                       ,p_tab_datatype    OUT nm3type.tab_varchar2000
                       ,p_tab_comment     OUT nm3type.tab_varchar32767
                       ) IS
--
   CURSOR cs_utc (c_tab_name VARCHAR2
                 ) IS
   SELECT *
    FROM  all_tab_columns
   WHERE  owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = c_tab_name
   ORDER BY column_id;
--
   CURSOR cs_comments (c_table  VARCHAR2
                      ,c_column VARCHAR2
                      ) IS
   SELECT comments
    FROM  all_col_comments
   WHERE  owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name  = c_table
    AND   column_name = c_column;
--
   l_comment VARCHAR2(4000);
--
   l_count   PLS_INTEGER := 0;
   l_nullable VARCHAR2(8);
--
BEGIN
--
   FOR cs_rec IN cs_utc (p_table_name)
    LOOP
--
      l_count   := l_count + 1;
      l_comment := Null;
--
      p_tab_atc (l_count)      := cs_rec;
      IF cs_rec.nullable = 'N'
       THEN
         l_nullable := 'NOT NULL';
      ELSE
         l_nullable := nm3web.c_nbsp;
      END IF;
      p_tab_not_null (l_count) := l_nullable;
      p_tab_datatype (l_count) := fn_datatype(p_data_type      => cs_rec.data_type
                                             ,p_data_length    => cs_rec.data_length
                                             ,p_data_precision => cs_rec.data_precision
                                             ,p_data_scale     => cs_rec.data_scale
                                             );
      OPEN  cs_comments (p_table_name, cs_rec.column_name);
      FETCH cs_comments INTO l_comment;
      CLOSE cs_comments;
      IF l_comment IS NOT NULL
       THEN
         p_tab_comment (l_count) := replace_spaces_and_lf(l_comment);
      ELSE
         p_tab_comment (l_count) := nm3web.c_nbsp;
      END IF;
--
   END LOOP;
--
END get_tab_cols;
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
-----------------------------------------------------------------------------
--
PROCEDURE get_and_display_cols (p_table_name VARCHAR2) IS
--
   l_tab_atc          tab_atc;
   l_tab_not_null     nm3type.tab_varchar30;
   l_tab_datatype     nm3type.tab_varchar2000;
   l_tab_comment      nm3type.tab_varchar32767;
--
   l_rec_atc          all_tab_columns%ROWTYPE;
--
   l_display_default  BOOLEAN := FALSE;
   l_display_comment  BOOLEAN := FALSE;
--
BEGIN
--
   get_tab_cols (p_table_name
                ,l_tab_atc
                ,l_tab_not_null
                ,l_tab_datatype
                ,l_tab_comment
                );
--
   FOR i IN 1..l_tab_atc.COUNT
    LOOP
      IF l_tab_atc(i).data_default IS NOT NULL
       THEN
         l_display_default := TRUE;
      END IF;
      IF l_tab_comment(i) != nm3web.c_nbsp
       THEN
         l_display_comment := TRUE;
      END IF;
   END LOOP;
--
   htp.tableopen(cattributes=>'BORDER=1');
   htp.tablerowopen;
   htp.tableheader (htf.small('Column Name'));
   htp.tableheader (htf.small(nm3web.c_nbsp));
   htp.tableheader (htf.small('Data Type'));
   IF l_display_default
    THEN
      htp.tableheader (htf.small('Default'));
   END IF;
   IF l_display_comment
    THEN
      htp.tableheader (htf.small('Comments'));
   END IF;
   htp.tablerowclose;
   FOR i IN 1..l_tab_atc.COUNT
    LOOP
      l_rec_atc := l_tab_atc(i);
      htp.tablerowopen;
      htp.tabledata(htf.small(l_rec_atc.column_name));
      htp.tabledata(htf.small(l_tab_not_null(i)));
      htp.tabledata(htf.small(l_tab_datatype(i)));
      IF l_display_default
       THEN
         htp.tabledata(htf.small(NVL(l_rec_atc.data_default,nm3web.c_nbsp)));
      END IF;
      IF l_display_comment
       THEN
         htp.tabledata(htf.small(l_tab_comment(i)));
      END IF;
      htp.tablerowclose;
   END LOOP;
   htp.tableclose;
--
END get_and_display_cols;
--
-----------------------------------------------------------------------------
--
PROCEDURE display_table_name_and_comment (p_table_name VARCHAR2) IS
--
   CURSOR cs_tab_comments (c_table VARCHAR2
                          ) IS
   SELECT comments
    FROM  all_tab_comments
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = c_table;
--
   l_comments VARCHAR2(4000);
--
BEGIN
--
   htp.header(2,p_table_name);
--
   OPEN  cs_tab_comments (p_table_name);
   FETCH cs_tab_comments INTO l_comments;
   IF cs_tab_comments%FOUND
    THEN
      htp.p(htf.small(replace_spaces_and_lf(l_comments)));
      htp.br;
   END IF;
   CLOSE cs_tab_comments;
--
END display_table_name_and_comment;
--
-----------------------------------------------------------------------------
--
PROCEDURE display_constraints (p_table_name VARCHAR2) IS
--
   CURSOR cs_cons (c_table VARCHAR2
                  ,c_type  VARCHAR2
                  ) IS
   SELECT *
    FROM  all_constraints
   WHERE  owner           = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name      = c_table
    AND   constraint_type = NVL(c_type,constraint_type)
    AND   generated       = 'USER NAME';
--
   CURSOR cs_cons2 (c_owner    VARCHAR2
                   ,c_con_name VARCHAR2
                   ) IS
   SELECT *
    FROM  all_constraints
   WHERE  owner           = c_owner
    AND   constraint_name = c_con_name;
--
   l_rec_ac        all_constraints%ROWTYPE;
--
   l_tab_type nm3type.tab_varchar4;
   l_tab_desc nm3type.tab_varchar30;
--
   l_been_in_loop BOOLEAN;
--
BEGIN
--
   l_tab_type(1) := 'P';
   l_tab_desc(1) := 'Primary Key';
   l_tab_type(2) := 'U';
   l_tab_desc(2) := 'Unique Key';
   l_tab_type(3) := 'R';
   l_tab_desc(3) := 'Referential Integrity';
   l_tab_type(4) := 'C';
   l_tab_desc(4) := 'Check';
--
   htp.br;
--
   FOR i IN 1..l_tab_type.COUNT
    LOOP
   --
      l_been_in_loop := FALSE;
      FOR cs_rec IN cs_cons ( p_table_name, l_tab_type(i))
       LOOP
         IF cs_cons%ROWCOUNT = 1
          THEN
            l_been_in_loop := TRUE;
            htp.bold (l_tab_desc(i));
            htp.br;
      --
            htp.tableopen(cattributes=>'BORDER=1');
            htp.tablerowopen;
            htp.tableheader(htf.small('Constraint'));
            htp.tableheader(htf.small('Columns'));
            IF l_tab_type(i) = 'C'
             THEN
               htp.tableheader(htf.small('Search Condition'));
            ELSIF l_tab_type(i) = 'R'
             THEN
               htp.tableheader(htf.small('Ref Table'));
               htp.tableheader(htf.small('Ref Cons'));
               htp.tableheader(htf.small('Ref Cols'));
               htp.tableheader(htf.small('Delete Rule'));
            END IF;
            htp.tablerowclose;
         END IF;
         htp.tablerowopen;
         htp.tabledata(htf.small(cs_rec.constraint_name));
         htp.p('<TD>');
         do_cons_cols (cs_rec.constraint_name, p_table_name);
         htp.p('</TD>');
         IF l_tab_type(i) = 'C'
          THEN
            htp.tabledata(htf.small(replace_spaces_and_lf(cs_rec.search_condition)));
         ELSIF l_tab_type(i) = 'R'
          THEN
            OPEN  cs_cons2 (cs_rec.r_owner, cs_rec.r_constraint_name);
            FETCH cs_cons2 INTO l_rec_ac;
            CLOSE cs_cons2;
            htp.tabledata(htf.small(cs_rec.r_owner||'.'||l_rec_ac.table_name));
            htp.tabledata(htf.small(cs_rec.r_constraint_name));
            htp.p('<TD>');
            do_cons_cols (l_rec_ac.constraint_name, l_rec_ac.table_name);
            htp.p('</TD>');
            htp.tabledata(htf.small(cs_rec.delete_rule));
         END IF;
         htp.tablerowclose;
      END LOOP;
      --
      IF l_been_in_loop
       THEN
         htp.tableclose;
         htp.br;
      END IF;
   END LOOP;
   --
   htp.hr(cattributes=>'WIDTH=75%');
   htp.br;
--
END display_constraints;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_cons_cols (p_con_name VARCHAR2
                       ,p_table    VARCHAR2
                       ) IS
--
   CURSOR cs_cons_cols (c_table VARCHAR2
                       ,c_con   VARCHAR2
                       ) IS
   SELECT column_name
    FROM  all_cons_columns
   WHERE  owner           = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name      = c_table
    AND   constraint_name = c_con
   ORDER BY position;
--
   l_tab_cons_cols nm3type.tab_varchar30;
--
BEGIN
   OPEN  cs_cons_cols (p_table, p_con_name);
   FETCH cs_cons_cols BULK COLLECT INTO l_tab_cons_cols;
   CLOSE cs_cons_cols;
   IF l_tab_cons_cols.COUNT = 0
    THEN
      htp.p(nm3web.c_nbsp);
   ELSIF l_tab_cons_cols.COUNT = 1
    THEN
      htp.p(htf.small(l_tab_cons_cols(1)));
   ELSE
      htp.tableopen(cattributes=> 'BORDER=1');
      FOR i IN 1..l_tab_cons_cols.COUNT
       LOOP
         htp.tablerowopen;
         htp.tabledata(htf.small(l_tab_cons_cols(i)));
         htp.tablerowclose;
      END LOOP;
      htp.tableclose;
   END IF;
END do_cons_cols;
--
-----------------------------------------------------------------------------
--
FUNCTION replace_spaces_and_lf (p_text VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN REPLACE(REPLACE(nm3web.replace_chevrons(p_text),' ',nm3web.c_nbsp),CHR(10),'<BR>');
END replace_spaces_and_lf;
--
-----------------------------------------------------------------------------
--
PROCEDURE display_statistics (p_table_name VARCHAR2) IS
--
   CURSOR cs_at (c_table_name VARCHAR2
                ) IS
   SELECT *
    FROM  all_tables
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = c_table_name;
--
   l_rec_at all_tables%ROWTYPE;
--
BEGIN
--
   OPEN  cs_at (p_table_name);
   FETCH cs_at INTO l_rec_at;
   CLOSE cs_at;
--
   IF l_rec_at.last_analyzed IS NULL
    THEN
      htp.p(htf.small('Table has never been analysed'));
   ELSE
      htp.tableopen(cattributes=> 'BORDER=1');
      htp.tablerowopen;
      htp.tableheader(htf.small('Last Analysed'));
      htp.tableheader(htf.small('Num Rows'));
      htp.tableheader(htf.small('Blocks'));
      htp.tableheader(htf.small('Empty Blocks'));
      htp.tableheader(htf.small('Avg Space'));
      htp.tableheader(htf.small('Chain Cnt'));
      htp.tableheader(htf.small('Avg Row Len'));
      htp.tablerowclose;
      --
      htp.tablerowopen;
      htp.tabledata(htf.small(TO_CHAR(l_rec_at.last_analyzed,'DD-Mon-YYYY HH24:MI:SS')));
      htp.tabledata(htf.small(l_rec_at.num_rows));
      htp.tabledata(htf.small(l_rec_at.blocks));
      htp.tabledata(htf.small(l_rec_at.empty_blocks));
      htp.tabledata(htf.small(l_rec_at.avg_space));
      htp.tabledata(htf.small(l_rec_at.chain_cnt));
      htp.tabledata(htf.small(l_rec_at.avg_row_len));
      htp.tablerowclose;
   --
      htp.tableclose;
   END IF;
--
   htp.hr(cattributes=>'WIDTH=75%');
   htp.br;
--
END display_statistics;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_references (p_name VARCHAR2
                        ,p_type VARCHAR2
                        ) IS
--
   CURSOR cs_ad (c_name  VARCHAR2
                ,c_type  VARCHAR2
                ) IS
   SELECT *
    FROM  all_dependencies
   WHERE  owner            = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   name             = c_name
    AND   SUBSTR(type,1,7) = SUBSTR(c_type,1,7)
    AND   referenced_type != 'NON-EXISTENT'
    AND   EXISTS (SELECT 1
                   FROM  hig_users
                  WHERE  hus_username = referenced_owner
                 )
   ORDER BY referenced_owner, referenced_type, referenced_name;
--
   l_been_in_loop BOOLEAN := FALSE;
--
   l_name_text    VARCHAR2(4000);
--
BEGIN
--
   IF NOT do_dependencies
    THEN
      RAISE dont_do_it;
   END IF;
--
   FOR cs_rec IN cs_ad (p_name, p_type)
    LOOP
      IF NOT l_been_in_loop
       THEN
         l_been_in_loop := TRUE;
         htp.p('References');
         htp.br;
         htp.br;
         htp.tableopen(cattributes=>'BORDER=1');
         htp.tablerowopen;
         htp.tableheader(htf.small('Ref Owner'));
         htp.tableheader(htf.small('Ref Name'));
         htp.tableheader(htf.small('Ref Type'));
         htp.tablerowclose;
      END IF;
      htp.tablerowopen;
      htp.tabledata(htf.small(cs_rec.referenced_owner));
      IF  cs_rec.referenced_owner                != Sys_Context('NM3CORE','APPLICATION_OWNER')
       OR (cs_rec.referenced_owner                = Sys_Context('NM3CORE','APPLICATION_OWNER')
           AND cs_rec.referenced_name             = p_name
           AND SUBSTR(cs_rec.referenced_type,1,7) = SUBSTR(p_type,1,7)
          )
       OR NOT proc_exists (cs_rec.referenced_type)
       THEN
         l_name_text := cs_rec.referenced_name;
      ELSE
         l_name_text := htf.anchor(curl  => g_package_name||'.individual_'||cs_rec.referenced_type||'_detail?p_'||cs_rec.referenced_type||'_name='||cs_rec.referenced_name
                                  ,ctext => cs_rec.referenced_name
                                  );
      END IF;
      htp.tabledata(htf.small(l_name_text));
      htp.tabledata(htf.small(cs_rec.referenced_type));
      htp.tablerowClose;
   END LOOP;
   IF l_been_in_loop
    THEN
      htp.tableclose;
      htp.br;
      htp.hr(cattributes=>'WIDTH=75%');
      htp.br;
   END IF;
--
EXCEPTION
--
   WHEN dont_do_it
    THEN
      Null;
--
END do_references;
--
-----------------------------------------------------------------------------
--
FUNCTION proc_exists (p_type VARCHAR2) RETURN BOOLEAN IS
--
   CURSOR cs_proc (c_package VARCHAR2
                  ,c_proc    VARCHAR2
                  ) IS
   SELECT 1
    FROM  dual
   WHERE EXISTS (SELECT 1
                  FROM  all_arguments
                 WHERE  owner        = Sys_Context('NM3CORE','APPLICATION_OWNER')
                  AND   package_name = c_package
                  AND   object_name  = c_proc
                );
--
   l_retval BOOLEAN;
   l_dummy  PLS_INTEGER;
--
BEGIN
--
   OPEN  cs_proc (UPPER(g_package_name)
                 ,'INDIVIDUAL_'||p_type||'_DETAIL'
                 );
   FETCH cs_proc INTO l_dummy;
   l_retval := cs_proc%FOUND;
   CLOSE cs_proc;
--
   RETURN l_retval;
--
END proc_exists;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_referenced_by (p_name VARCHAR2
                           ,p_type VARCHAR2
                           ) IS
--
   CURSOR cs_ad (c_name  VARCHAR2
                ,c_type  VARCHAR2
                ) IS
   SELECT *
    FROM  all_dependencies
   WHERE  referenced_owner            = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   referenced_name             = c_name
    AND   SUBSTR(referenced_type,1,7) = SUBSTR(c_type,1,7)
    AND   type != 'NON-EXISTENT'
    AND   EXISTS (SELECT 1
                   FROM  hig_users
                  WHERE  hus_username = owner
                 )
   ORDER BY owner, type, name;
--
   l_been_in_loop BOOLEAN := FALSE;
--
   l_name_text    VARCHAR2(4000);
--
   l_type         VARCHAR2(30);
--
BEGIN
--
   IF NOT do_dependencies
    THEN
      RAISE dont_do_it;
   END IF;
--
   FOR cs_rec IN cs_ad (p_name, p_type)
    LOOP
      IF NOT l_been_in_loop
       THEN
         l_been_in_loop := TRUE;
         htp.p('Referenced by');
         htp.br;
         htp.br;
         htp.tableopen(cattributes=>'BORDER=1');
         htp.tablerowopen;
         htp.tableheader(htf.small('Owner'));
         htp.tableheader(htf.small('Name'));
         htp.tableheader(htf.small('Type'));
         htp.tablerowclose;
      END IF;
      htp.tablerowopen;
      htp.tabledata(htf.small(cs_rec.owner));
      IF cs_rec.type = 'PACKAGE BODY'
       THEN
         l_type := 'PACKAGE';
      ELSE
         l_type := cs_rec.type;
      END IF;
--
      IF  cs_rec.owner                != Sys_Context('NM3CORE','APPLICATION_OWNER')
       OR (cs_rec.owner                = Sys_Context('NM3CORE','APPLICATION_OWNER')
           AND cs_rec.name             = p_name
           AND SUBSTR(cs_rec.type,1,7) = SUBSTR(p_type,1,7)
          )
       OR NOT proc_exists (l_type)
       THEN
         l_name_text := cs_rec.name;
      ELSE
         l_name_text := htf.anchor(curl  => g_package_name||'.individual_'||l_type||'_detail?p_'||l_type||'_name='||cs_rec.name
                                  ,ctext => cs_rec.name
                                  );
      END IF;
      htp.tabledata(htf.small(l_name_text));
      htp.tabledata(htf.small(cs_rec.type));
      htp.tablerowClose;
   END LOOP;
   IF l_been_in_loop
    THEN
      htp.tableclose;
      htp.br;
      htp.hr(cattributes=>'WIDTH=75%');
      htp.br;
   END IF;
--
EXCEPTION
--
   WHEN dont_do_it
    THEN
      null;
--
END do_referenced_by;
--
-----------------------------------------------------------------------------
--
PROCEDURE output_varchar_as_html_code (p_text VARCHAR2) IS
BEGIN
--
   htp.p('<CODE>');
   output_varchar_as_html(p_text);
   htp.p('</CODE>');
--
END output_varchar_as_html_code;
--
-----------------------------------------------------------------------------
--
PROCEDURE output_varchar_as_html (p_text VARCHAR2) IS
   i                PLS_INTEGER;
   c_chunk CONSTANT PLS_INTEGER := 5000;
BEGIN
--
   DECLARE
      l_too_big EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_too_big,-6502);
   BEGIN
      htp.p(replace_spaces_and_lf(p_text));
   EXCEPTION
      WHEN l_too_big
       THEN
         i := 1;
         WHILE i <= LENGTH(p_text)
          LOOP
            output_varchar_as_html (SUBSTR(p_text,i,c_chunk));
            i:= i + c_chunk;
         END LOOP;
   END;
--
END output_varchar_as_html;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_package_procedures (p_package_name VARCHAR2) IS
--
   CURSOR cs_distinct (c_pack  VARCHAR2
                      ) IS
   SELECT object_name
    FROM  all_arguments
   WHERE  owner        = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   package_name = c_pack
   GROUP BY object_name;
--
   CURSOR cs_overload (c_pack  VARCHAR2
                      ,c_proc  VARCHAR2
                      ) IS
   SELECT overload
    FROM  all_arguments
   WHERE  owner        = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   package_name = c_pack
    AND   object_name  = c_proc
   GROUP BY overload;
--
   CURSOR cs_args (c_pack  VARCHAR2
                  ,c_proc  VARCHAR2
                  ,c_over  NUMBER
                  ) IS
   SELECT *
    FROM  all_arguments
   WHERE  owner           = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   package_name    = c_pack
    AND   object_name     = c_proc
    AND   NVL(overload,0) = NVL(c_over,0)
   ORDER BY sequence;
--
   l_tab_procs    nm3type.tab_varchar30;
   l_tab_overload nm3type.tab_number;
--
   l_arg_name     VARCHAR2(100);
   l_tab_open     BOOLEAN;
   l_data_type    VARCHAR2(100);
--
BEGIN
--
   OPEN  cs_distinct (p_package_name);
   FETCH cs_distinct BULK COLLECT INTO l_tab_procs;
   CLOSE cs_distinct;
--
   FOR i IN 1..l_tab_procs.COUNT
    LOOP
      htp.br;
      htp.bold(l_tab_procs(i));
      l_tab_overload.DELETE;
      OPEN  cs_overload (p_package_name, l_tab_procs(i));
      FETCH cs_overload BULK COLLECT INTO l_tab_overload;
      CLOSE cs_overload;
      IF l_tab_overload.COUNT = 0
       THEN
         htp.small('No Parameters');
      END IF;
      FOR j IN 1..l_tab_overload.COUNT
       LOOP
         htp.br;
         IF l_tab_overload.COUNT > 1
          THEN
            htp.italic('Overload '||j||'.');
         END IF;
         l_tab_open := FALSE;
         FOR cs_rec IN cs_args (p_package_name, l_tab_procs(i), l_tab_overload(j))
          LOOP
            IF   cs_args%ROWCOUNT = 1
             AND cs_rec.data_type IS NOT NULL
             THEN
               l_tab_open := TRUE;
               htp.tableopen(cattributes=>'BORDER=1');
            END IF;
            IF cs_rec.data_type IS NOT NULL
             THEN
               htp.tablerowopen;
               l_arg_name := LPAD('-',cs_rec.data_level,'-');
               IF cs_rec.argument_name IS NULL
                THEN
                  l_arg_name := htf.bold(l_arg_name||nm3web.c_nbsp);
               ELSE
                  l_arg_name := l_arg_name||cs_rec.argument_name;
               END IF;
               htp.tabledata(NVL(htf.small(l_arg_name),nm3web.c_nbsp));
               htp.tabledata(htf.small(cs_rec.in_out));
               IF cs_rec.data_type = 'OBJECT'
                THEN
                  IF cs_rec.type_owner != Sys_Context('NM3CORE','APPLICATION_OWNER')
                   THEN
                     l_data_type := cs_rec.type_owner||'.';
                  ELSE
                     l_data_type := Null;
                  END IF;
                  l_data_type := l_data_type||cs_rec.type_name;
               ELSE
                  l_data_type := cs_rec.data_type;
               END IF;
               htp.tabledata(htf.small(l_data_type));
               htp.tablerowclose;
            END IF;
         END LOOP;
         IF l_tab_open
          THEN
            htp.tableclose;
         ELSE
            htp.small('No Parameters');
         END IF;
         htp.br;
      END LOOP;
      extract_tagged_text (pi_tag    => 'PROC'
                          ,pi_colour => 'DARKBLUE'
                          ,pi_name   => l_tab_procs(i)
                          );
      htp.br;
   END LOOP;
--
   htp.hr(cattributes=>'WIDTH=75%');
   htp.br;
--
END do_package_procedures;
--
-----------------------------------------------------------------------------
--
FUNCTION get_from_source (p_name VARCHAR2
                         ,p_type VARCHAR2 DEFAULT 'PACKAGE'
                         ) RETURN nm3type.tab_varchar4000 IS
--
   CURSOR cs_as (c_name  VARCHAR2
                ,c_type  VARCHAR2
                ) IS
   SELECT text
    FROM  all_source
   WHERE  owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   name  = c_name
    AND   type  = c_type
   ORDER BY line;
--
   l_tab_text nm3type.tab_varchar4000;
--
BEGIN
--
   OPEN  cs_as (p_name, p_type);
   FETCH cs_as BULK COLLECT INTO l_tab_text;
   CLOSE cs_as;
--
   RETURN l_tab_text;
--
END get_from_source;
--
-----------------------------------------------------------------------------
--
PROCEDURE extract_tagged_text (pi_tag    VARCHAR2
                              ,pi_colour VARCHAR2
                              ,pi_name   VARCHAR2 DEFAULT NULL
                              ) IS
--
   l_switch_on          BOOLEAN       := FALSE;
   c_tag       CONSTANT VARCHAR2(100) := UPPER(pi_tag);
--
   l_text               VARCHAR2(4000);
--
BEGIN
--
   htp.p('<P style="color: '||pi_colour||'">');
   FOR i IN 1..g_tab_text.COUNT
    LOOP
      l_text := REPLACE(UPPER(g_tab_text(i)),' ',Null);
      IF NVL(INSTR(l_text
                  ,'</'||c_tag||'>'
                  ,1,1
                  )
               ,0) != 0
       AND l_switch_on
       THEN
         l_switch_on := FALSE;
         EXIT;
      END IF;
      IF l_switch_on
       THEN
         output_varchar_as_html_code (g_tab_text(i));
      END IF;
      IF NVL(INSTR(l_text
                  ,'<'||c_tag||'>'
                  ,1,1)
            ,0) != 0
       AND pi_name IS NULL
       THEN
         l_switch_on := TRUE;
      ELSIF NVL(INSTR(l_text
                     ,'<'||c_tag
                     ,1,1)
               ,0) != 0
       AND  NVL(INSTR(l_text
                     ,pi_name
                     ,1,1)
               ,0) != 0
       AND  NVL(INSTR(l_text
                     ,'NAME='
                     ,1,1)
               ,0) != 0
       AND pi_name IS NOT NULL
       THEN
         l_switch_on := TRUE;
      END IF;
   END LOOP;
   htp.p('</P>');
--
END extract_tagged_text;
--
-----------------------------------------------------------------------------
--
FUNCTION do_dependencies RETURN BOOLEAN IS
   l_retval BOOLEAN := FALSE;
   l_opt    VARCHAR2(100);
BEGIN
   l_opt    := NVL(hig.get_useopt(c_user_opt_depend,Sys_Context('NM3_SECURITY_CTX','USERNAME')),'N');
   l_retval := (l_opt = 'Y');
   RETURN l_retval;
END do_dependencies;
--
-----------------------------------------------------------------------------
--
FUNCTION do_radio RETURN BOOLEAN IS
   l_retval BOOLEAN := FALSE;
   l_opt    VARCHAR2(100);
BEGIN
   l_opt    := NVL(hig.get_useopt(c_user_opt_radio,Sys_Context('NM3_SECURITY_CTX','USERNAME')),'N');
   l_retval := (l_opt = 'Y');
   RETURN l_retval;
END do_radio;
--
-----------------------------------------------------------------------------
--
END nm3web_apd;
/
