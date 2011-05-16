CREATE OR REPLACE PACKAGE BODY nm3web IS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web.pkb-arc   2.2   May 16 2011 14:24:12   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3web.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:24:12  $
--       Date fetched Out : $Modtime:   Apr 01 2011 10:12:34  $
--       PVCS Version     : $Revision:   2.2  $
--       Based on         : 1.55
--
--
--   Author : Jonathan Mills + Kevin Angus
--
--   NM3 Web Standard Components package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.2  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web';
   --
   g_highways_product_name  CONSTANT hig_products.hpr_product_name%TYPE := nm3get.get_hpr(pi_hpr_product=>nm3type.c_hig).hpr_product_name;
   g_default_title          CONSTANT hig_options.hop_value%TYPE         := NVL(hig.get_sysopt('HIGWINTITL'),g_highways_product_name);
   g_exor_home_page         CONSTANT varchar2(100)                      := 'http://www.exorcorp.com';
   --
   g_css CONSTANT varchar2(2000) := NVL(hig.get_sysopt('NM3WEBCSS'),get_download_url('exor.css'));

   c_about_module              CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0001';
   c_help_module               CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0002';
--
   c_about_server_module       CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0003';
   c_about_server_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_about_server_module);
   c_idwintitle                CONSTANT boolean                     := (hig.get_sysopt('IDWINTITLE')='Y');
   c_dbwintitle                CONSTANT boolean                     := (hig.get_sysopt('DBWINTITLE')='Y');
--
   c_top_frame_image           CONSTANT nm3type.max_varchar2        := NVL(hig.get_user_or_sys_opt('WEBTOPIMG'),get_download_url('exor_small.gif'));
   c_main_menu_image           CONSTANT nm3type.max_varchar2        := NVL(hig.get_user_or_sys_opt('WEBMAINIMG'),get_download_url('exor.gif'));
   c_main_menu_image_url       CONSTANT nm3type.max_varchar2        := NVL(hig.get_user_or_sys_opt('WEBMAINURL'),g_exor_home_page);
--
   c_default_main_menu_module  CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0000';
   g_main_menu_module          CONSTANT hig_modules.hmo_module%TYPE := NVL(UPPER(hig.get_user_or_sys_opt('WEBMENUMOD')),c_default_main_menu_module);
   g_main_menu_module_title    CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(g_main_menu_module);
--
   c_close                     CONSTANT VARCHAR2(5) := 'Close';
--
  TYPE translate_rec IS RECORD(original     varchar2(2000)
                              ,replacement  varchar2(2000));
  TYPE translate_t IS TABLE OF translate_rec INDEX BY binary_integer;
--
----------------------------------------------------------------------------------------
--
PROCEDURE check_nuf_visible_via_gateway (pi_name varchar2);
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
FUNCTION ampersand RETURN varchar2 IS
BEGIN
  RETURN CHR(38);
END ampersand;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_css_link IS
BEGIN
   htp.p('<link rel="stylesheet" href="'||g_css||'">');
END do_css_link;
--
-----------------------------------------------------------------------------
--
FUNCTION get_escape_char (p_char varchar2) RETURN varchar2 IS
BEGIN
--
   RETURN CHR(38)||'#'||ASCII(p_char)||';';
--
END get_escape_char;
--
-----------------------------------------------------------------------------
--
FUNCTION replace_chevrons( pi_text IN  varchar2)
RETURN varchar2
IS
   l_text nm3type.max_varchar2;
BEGIN

   l_text := pi_text;

   replace_chevrons( l_text );

   RETURN l_text ;

END replace_chevrons;
--
-----------------------------------------------------------------------------
--
PROCEDURE replace_chevrons( pi_text IN OUT varchar2)
IS
   -- Constants
   c_open_chevron      CONSTANT varchar2(5) := '<';
   c_close_chevron     CONSTANT varchar2(5) := '>';

BEGIN
    pi_text := REPLACE(pi_text, c_open_chevron, get_escape_char(c_open_chevron));
    pi_text := REPLACE(pi_text, c_close_chevron, get_escape_char(c_close_chevron));
END replace_chevrons;
--
-----------------------------------------------------------------------------
--
PROCEDURE head(p_close_head IN boolean  DEFAULT TRUE
              ,p_title      IN varchar2 DEFAULT NULL
              ,pi_vml       IN boolean  DEFAULT FALSE
              ) IS
--
   c_null_string       CONSTANT varchar2(30) := '#Null#';
   l_current_namespace          varchar2(30) := c_null_string;
--
BEGIN
--
--   IF p_title IS NOT NULL
--    THEN
--      htp.p('<SCRIPT LANGUAGE="JavaScript">');
--      htp.p('   parent.nm3web_top_frame.title_def.p_title.value = "'||p_title||'"');
--      htp.p('</SCRIPT>');
--   END IF;
--
   IF pi_vml
   THEN
     htp.p('<html xmlns:v="urn:schemas-microsoft-com:vml">');
   ELSE
     htp.htmlopen;
   END IF;

   htp.headopen;

   IF pi_vml
   THEN
     htp.p('<object id="VMLRender" classid="CLSID:10072CEC-8CC1-11D1-986E-00A0C955B42E"></object>');
     htp.p('<style>');
     htp.p('v\:* { behavior: url(#VMLRender); }');
     htp.p('</style>');
   END IF;

   htp.COMMENT('   SCCS Identifiers :-');
   htp.COMMENT(NULL);
   htp.COMMENT('       sccsid           : @(#)nm3web.pkb	1.55 06/04/05');
   htp.COMMENT('       Module Name      : nm3web.pkb');
   htp.COMMENT('       Date into SCCS   : 05/06/04 14:11:22');
   htp.COMMENT('       Date fetched Out : 07/06/13 14:13:46');
   htp.COMMENT('       SCCS Version     : 1.55');
   htp.COMMENT(NULL);
   htp.COMMENT('-----------------------------------------------------------------------------');
   htp.COMMENT('	Copyright (c) exor corporation ltd, 2002-2004');
   htp.COMMENT('-----------------------------------------------------------------------------');
   htp.COMMENT(NULL);
--
   FOR cs_rec IN (SELECT *
                   FROM  session_context
                  WHERE  namespace = 'NM3CORE'
                  ORDER BY namespace
                          ,ATTRIBUTE
                 )
    LOOP
      IF l_current_namespace <> cs_rec.namespace
       THEN
         l_current_namespace := cs_rec.namespace;
         htp.COMMENT(l_current_namespace);
         htp.COMMENT(RPAD('-',LENGTH(l_current_namespace),'-'));
      END IF;
      htp.COMMENT(RPAD(cs_rec.ATTRIBUTE,31)
                  ||': '
                  ||NVL(cs_rec.VALUE,c_null_string)
                 );
   END LOOP;
--
   htp.COMMENT(NULL);
   htp.COMMENT('Session ID  - '||USERENV('SESSIONID'));
   htp.COMMENT('Sysdate     - '||TO_CHAR(SYSDATE,'HH24:MI:SS DD-Mon-YYYY'));
   htp.COMMENT('IP Address  - '||get_client_ip_address);
   htp.COMMENT(NULL);
   DECLARE
      l_max_len pls_integer := 0;
   BEGIN
      FOR i IN 1..owa.num_cgi_vars
       LOOP
         l_max_len := GREATEST(LENGTH(owa.cgi_var_name(i)),l_max_len);
      END LOOP;
      FOR i IN 1..owa.num_cgi_vars
       LOOP
         htp.COMMENT(RPAD(owa.cgi_var_name(i),l_max_len,' ')||' - '||owa.cgi_var_val(i));
      END LOOP;
   END;
   htp.COMMENT(NULL);
--
   htp.title(p_title);
--
   do_css_link;
--
   IF p_close_head
    THEN
      htp.headclose;
   END IF;
--
END head;
--
----------------------------------------------------------------------------------------
--
PROCEDURE empty_frame (p_text varchar2 DEFAULT NULL) IS
BEGIN
--
   head;
   do_css_link;
   htp.bodyopen;
   htp.p(p_text);
   htp.bodyclose;
   htp.htmlclose;
--
END empty_frame;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_option (p_name     IN varchar2
                    ,p_sql      IN varchar2
                    ,p_nullable IN boolean  DEFAULT FALSE
                    ,p_value    IN varchar2 DEFAULT NULL
                    ) IS
--
   l_code    varchar2(2000);
   l_meaning varchar2(2000);
   l_cur  ref_cur;
--
   l_selected varchar2(10);
--
BEGIN
--
   htp.formselectopen(p_name);
--
   IF p_nullable
    THEN
      htp.formselectoption(NULL);
   END IF;
--
--   ins_ibo(p_sql);
   OPEN  l_cur FOR p_sql;
--
   FETCH l_cur INTO l_code, l_meaning;
--
   LOOP
      EXIT WHEN l_cur%NOTFOUND;
      IF NVL(l_code,c_nbsp) = NVL(p_value,c_nbsp)
       THEN
         l_selected := 'SELECTED ';
      ELSE
         l_selected := NULL;
      END IF;
      htp.p('<OPTION '||l_selected||'VALUE="'||l_code||'">'||l_meaning||'</OPTION>');
      FETCH l_cur INTO l_code, l_meaning;
   END LOOP;
--
   CLOSE l_cur;
--
   htp.formselectclose;
--
END do_option;
--
----------------------------------------------------------------------------------------
--
PROCEDURE CLOSE IS
BEGIN
   htp.bodyclose;
   htp.htmlclose;
END CLOSE;
--
----------------------------------------------------------------------------------------
--
PROCEDURE display_table (p_table_name IN varchar2) IS
--
   CURSOR user_cons_cols (p_table_name varchar2
                         ,p_col_name   varchar2
                         ) IS
   SELECT ref_c.column_name
         ,ref_c.table_name
    FROM  user_constraints  this_t
         ,user_cons_columns this_c
         ,user_constraints  ref_t
         ,user_cons_columns ref_c
   WHERE  this_t.table_name        = p_table_name
    AND   this_t.constraint_name   = this_c.constraint_name
    AND   this_c.column_name       = p_col_name
    AND   this_t.r_constraint_name = ref_t.constraint_name
    AND   ref_t.constraint_name    = ref_c.constraint_name;
--
   CURSOR meaning_col (p_table_name varchar2
                      ,p_col_name   varchar2
                      ) IS
   SELECT column_name
    FROM  user_tab_columns
   WHERE  table_name   = p_table_name
    AND   column_name != p_col_name
   ORDER BY column_id;
--
   l_ref_table   varchar2(30);
   l_ref_col     varchar2(30);
   l_meaning_col varchar2(30);
--
   l_nullable  boolean;
   l_cur  ref_cur;
--
BEGIN
--
   htp.tableopen;
--
   FOR cs_rec IN (SELECT *
                   FROM  user_tab_columns
                  WHERE  table_name = p_table_name
                  ORDER BY column_id
                 )
    LOOP
--
      htp.tablerowopen;
      htp.tableheader(REPLACE(cs_rec.column_name,'_',' '));
      htp.p('<TD>');
      OPEN  user_cons_cols (p_table_name,cs_rec.column_name);
      FETCH user_cons_cols INTO l_ref_col,l_ref_table;
      IF user_cons_cols%FOUND
       THEN
         l_nullable := (cs_rec.nullable = 'Y');
         l_meaning_col := l_ref_col;
         OPEN  meaning_col (l_ref_table, l_ref_col);
         FETCH meaning_col INTO l_meaning_col;
         CLOSE meaning_col;
         do_option(cs_rec.column_name
                  ,'SELECT '||l_ref_col||', '||l_meaning_col||' a FROM '||l_ref_table||' ORDER BY a'
                  ,l_nullable
                  );
      ELSE
         IF cs_rec.data_type = 'DATE'
          THEN
            cs_rec.data_length := 11;
         END IF;
         IF cs_rec.data_length > 100
          THEN
            htp.formtextarea
               (cname      => cs_rec.column_name
               ,nrows      => 5
               ,ncolumns   => 100
               );
         ELSE
            htp.formtext(cname      => cs_rec.column_name
                        ,cmaxlength => cs_rec.data_length
                        ,csize      => cs_rec.data_length
                        );
         END IF;
      END IF;
      CLOSE user_cons_cols;
      htp.p('</TD>');
      htp.tablerowclose;
--
   END LOOP;
--
   htp.tableclose;
--
END display_table;
--
----------------------------------------------------------------------------------------
--
PROCEDURE js_open IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'js_open');

  htp.p('<SCRIPT LANGUAGE="JavaScript">');
  htp.p('<!-- Hide JS Code from old browsers');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'js_open');

END js_open;
--
----------------------------------------------------------------------------------------
--
PROCEDURE js_close IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'js_close');

  htp.p('// -->');
  htp.p('</script>');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'js_close');

END js_close;
--
----------------------------------------------------------------------------------------
--
PROCEDURE js_funcs IS
BEGIN
   js_open;

   htp.p('function isBlank(testStr)');
   htp.p('   {');
   htp.p('   if (testStr.length == 0)                  // Null string');
   htp.p('      return true');
   htp.p('   for (var i=0; i <= testStr.length-1; i++) // All spaces');
   htp.p('      if (testStr.charAt(i) != " ")');
   htp.p('         return false');
   htp.p('   return true');
   htp.p('   }');
   htp.p('function isNumber(testNum)');
   htp.p('   {');
   htp.p('   if (isBlank(testNum))');
   htp.p('      {');
   htp.p('      return true');
   htp.p('      }');
   htp.p('   for (var i=0; i < testNum.length; i++)');
   htp.p('      {');
   htp.p('      var testChar = testNum.charAt(i)');
   htp.p('      if (testChar < "0" || testChar > "9")');
   htp.p('         if (!(testChar == "." || testChar == "-" || testChar == "," ))');
   htp.p('            {');
   htp.p('            return false');
   htp.p('            }');
   htp.p('      }');
   htp.p('   return true');
   htp.p('   }');
   htp.p('function MinMax(testNum, minVal, MaxVal)');
   htp.p('   {');
   htp.p('   if (isBlank(testNum))');
   htp.p('      {');
   htp.p('      return true');
   htp.p('      }');
   htp.p('   if (testNum < minVal || testNum > MaxVal)');
   htp.p('      {');
   htp.p('      return false');
   htp.p('      }');
   htp.p('   return true');
   htp.p('   }');
   htp.p('function popUp(URL) {');
   htp.p('day = new Date();');
   htp.p('id = day.getTime();');
   htp.p('eval("page" + id + " = window.open(URL, '||nm3flx.string('" + id + "')||', '||nm3flx.string('toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=1,width=800,height=600')||');");');
   htp.p('}');
END js_funcs;
--
----------------------------------------------------------------------------------------
--
PROCEDURE js_alert_ner(pi_appl       IN nm_errors.ner_appl%TYPE
                      ,pi_id         IN nm_errors.ner_id%TYPE
                      ,pi_extra_text IN varchar2    DEFAULT NULL
                      ,pi_indent     IN pls_integer DEFAULT 0
                      ,pi_return_var IN varchar2    DEFAULT NULL
                      ) IS

  l_alert_txt nm3type.max_varchar2;

  l_function_txt nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'js_alert_ner');

  DECLARE
    e_caught EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_caught,-20666);

  BEGIN
     hig.raise_ner(pi_appl               => pi_appl
                  ,pi_id                 => pi_id
                  ,pi_sqlcode            => -20666
                  ,pi_supplementary_info => pi_extra_text);

  EXCEPTION
    WHEN e_caught
    THEN
      l_alert_txt := nm3flx.parse_error_message(SQLERRM,'ORA',1);
  END;

  IF pi_return_var IS NOT NULL
  THEN
    l_function_txt := pi_return_var || ' = confirm';
  ELSE
    l_function_txt := 'alert';
  END IF;

  l_alert_txt := l_function_txt || '("' || REPLACE(l_alert_txt,'"',NULL) || '");';

  FOR l_i IN 1..pi_indent
  LOOP
    l_alert_txt := ' ' || l_alert_txt;
  END LOOP;

  htp.p(l_alert_txt);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'js_alert_ner');

END js_alert_ner;
--
----------------------------------------------------------------------------------------
--
PROCEDURE default_page IS
   CURSOR cs_user (c_user varchar2) IS
   SELECT hus_name
         ,hus_username
    FROM  hig_users
   WHERE  hus_username = c_user;
--
   CURSOR cs_outer_role (c_user varchar2) IS
   SELECT DISTINCT
          hpr_product
         ,hpr_product_name
         ,hpr_version
         ,hpr_sequence
    FROM  hig_products
   WHERE hpr_product IN (SELECT hro_product
                          FROM  hig_roles
                               ,hig_user_roles
                         WHERE  hur_username = c_user
                          AND   hur_role     = hro_role
                        )
     AND hpr_key IS NOT NULL
   ORDER BY hpr_sequence;
--
   CURSOR cs_inner_role (c_user    varchar2
                        ,c_product varchar2
                        ) IS
   SELECT hro_role
         ,DECODE(hro_descr
                ,NULL,NULL
                ,' - '||hro_descr
                ) hro_descr
    FROM hig_roles
        ,hig_user_roles
   WHERE hur_username = c_user
    AND  hro_product  = c_product
    AND  hur_role     = hro_role;
--
   l_username varchar2(30) := USER;
   l_user     varchar2(30) := l_username;
BEGIN
   OPEN  cs_user (l_username);
   FETCH cs_user INTO l_username, l_user;
   CLOSE cs_user;
   head (p_close_head => TRUE
        ,p_title      => 'NM3 Web'
        );
   htp.bodyopen;
   HEADER;
   htp.tableopen(cborder     => 'BORDER=0'
                ,calign      => 'CENTER'
             --   ,cattributes => 'width=100%'
                );
   htp.tablerowopen;
   htp.p('<TD ALIGN=CENTER>');
   htp.img(curl        => c_main_menu_image
          ,calign      => 'CENTER'
          ,calt        => g_highways_product_name
          ,cismap      => NULL
          ,cattributes => NULL
          );
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tablerowopen;
   htp.tableheader('<H1>Welcome '||SUBSTR(l_username,1,INSTR(l_username,' ',1,1))||'</H1>');
   FOR cs_rec IN (SELECT 'Connected to '||instance_name||'(v'||VERSION||') on '||host_name txt
                   FROM  v$instance
                 )
    LOOP
      htp.tablerowopen;
      htp.tabledata('<DIV ALIGN=CENTER>Oracle username is "'||l_user||'"</DIV>');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata('<DIV ALIGN=CENTER>'||cs_rec.txt||'</DIV>');
      htp.tablerowclose;
   END LOOP;
   htp.tablerowopen;
   htp.tabledata(c_nbsp);
   htp.tablerowclose;
   htp.tablerowopen;
   htp.p('<TD ALIGN=CENTER>');
   htp.p('You have the following roles :');
   htp.tableopen;
   FOR cs_outer IN cs_outer_role (l_user)
    LOOP
      htp.tablerowopen;
      htp.tableheader(cs_outer.hpr_product||' - '||cs_outer.hpr_product_name||' v'||cs_outer.hpr_version);
      htp.tablerowclose;
      FOR cs_rec IN cs_inner_role(l_user, cs_outer.hpr_product)
       LOOP
         htp.tablerowopen;
         htp.tabledata('<B>'||cs_rec.hro_role||'</B><I>'||cs_rec.hro_descr||'</I>');
         htp.tablerowclose;
      END LOOP;
   END LOOP;
   htp.tableclose;
   htp.p('</TD>');
   htp.tablerowclose;
   htp.tableclose;
   footer(pi_back_link => FALSE);
   htp.bodyclose;
   htp.htmlclose;
END default_page;
--
----------------------------------------------------------------------------------------
--
FUNCTION string_to_url(pi_str              IN varchar2
                      ,pi_leave_ampersands IN boolean DEFAULT FALSE
                      ) RETURN varchar2 IS

  l_translate_tab translate_t;

  l_new_str nm3type.max_varchar2 := pi_str;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'string_to_url');

  l_translate_tab(1).original    := ' ';
  l_translate_tab(1).replacement := '%20';

  l_translate_tab(2).original    := '#';
  l_translate_tab(2).replacement := '%23';

  l_translate_tab(3).original    := '+';
  l_translate_tab(3).replacement := '%43';


  IF NOT(pi_leave_ampersands)
  THEN
    l_translate_tab(4).original    := CHR(38);
    l_translate_tab(4).replacement := '%26';
  END IF;

  FOR l_i IN 1..l_translate_tab.LAST
  LOOP
    l_new_str := REPLACE(l_new_str
                        ,l_translate_tab(l_i).original
                        ,l_translate_tab(l_i).replacement);
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'string_to_url');

  RETURN l_new_str;

END string_to_url;
--
----------------------------------------------------------------------------------------
--
FUNCTION url_to_string(pi_str              IN varchar2
                      ,pi_leave_ampersands IN boolean DEFAULT FALSE
                      ) RETURN varchar2 IS

  l_translate_tab translate_t;

  l_new_str nm3type.max_varchar2 := pi_str;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'string_to_url');

  l_translate_tab(1).original    := '%20';
  l_translate_tab(1).replacement := ' ';

  l_translate_tab(2).original    := '%23';
  l_translate_tab(2).replacement := '#';

  l_translate_tab(3).original    := '%43';
  l_translate_tab(3).replacement := '+';


  IF NOT(pi_leave_ampersands)
  THEN
    l_translate_tab(4).original    := '%26';
    l_translate_tab(4).replacement := CHR(38);
  END IF;

  FOR l_i IN 1..l_translate_tab.LAST
  LOOP
    l_new_str := REPLACE(l_new_str
                        ,l_translate_tab(l_i).original
                        ,l_translate_tab(l_i).replacement);
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'url_to_string');

  RETURN l_new_str;

END url_to_string;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_db_info_str(pi_product IN hig_products.hpr_product%TYPE
                        ) RETURN varchar2 IS

  l_retval nm3type.max_varchar2;

BEGIN
  --get db info
  IF c_dbwintitle
   THEN
     l_retval :=    Sys_Context('NM3_SECURITY_CTX','USERNAME')
                 || '@'
                 || Sys_Context('NM3CORE','INSTANCE_NAME');
                 --|| '.'
                 --|| nm3context.get_context(pi_namespace => nm3context.get_namespace
                                          --,pi_attribute => 'HOST_NAME');
   END IF;
  --get product info
	--l_hpr_rec := hig.get_hpr(pi_product => pi_product);
	--l_retval :=    l_retval
	 --           || ' '
	 --           || pi_product
	 --           || ' v'
	  --          || l_hpr_rec.hpr_version;

  RETURN l_retval;
END;
--
----------------------------------------------------------------------------------------
--
PROCEDURE HEADER(p_title  IN varchar2 DEFAULT NULL
                ,p_title2 IN varchar2 DEFAULT NULL
                ,p_module IN hig_modules.hmo_module%TYPE DEFAULT NULL
                ) IS

  l_help_url   nm3type.max_varchar2;
  l_right_data nm3type.max_varchar2;
BEGIN
  htp.p('<HTML>');
  htp.p('<HEAD>');
  htp.p('<BASE TARGET="nm3web_main_frame">');
  do_css_link;
  htp.p('</HEAD>');
  htp.p('<BODY>');

  htp.tableopen(cborder     => 'BORDER=0'
               ,calign      => 'CENTER'
               ,cattributes => 'width=100%');
    ---------
    --top row
    ---------
    htp.tablerowopen;
      --left justified items
      htp.tabledata(cvalue => htf.img(curl        => c_top_frame_image
                                     ,calign      => 'top'
                                     ,calt        => g_highways_product_name
                                     ,cattributes => 'UNITS=pixels HEIGHT=22 WIDTH=79'
                                     )
                              ||'  '
                              ||htf.bold(p_title)
                   ,calign => 'left'
                   );

      --right justified items
      htp.tabledata(cvalue => get_db_info_str(NULL)
                              || ' ' ||
                              htf.anchor2(curl    => g_package_name||'.logoff'
                                         ,ctext   => 'Log Off'
                                         ,ctarget => '_top')
                   ,calign => 'right');
    htp.tablerowclose;

    ------------
    --bottom row
    ------------
    htp.tablerowopen(calign      => 'center'
                    ,cattributes => 'colspan=2');
      --left justified items
      htp.tabledata(cvalue => htf.bold(p_title2)
                   ,calign => 'left');

      --right justified items
      l_help_url := get_web_run_module_cmd || c_help_module;
      IF p_module IS NOT NULL
      THEN
        l_help_url := l_help_url || ampersand || 'pi_param_name1=pi_module' || ampersand ||'pi_param_value1=' || p_module;
      END IF;
      l_right_data := NULL;
--      l_right_data := htf.anchor(curl     => l_help_url
--                                ,ctext   => 'Help')
--                      || '  ' ;
      l_right_data := l_right_data||htf.anchor(curl     => get_web_run_module_cmd || c_about_module
                                              ,ctext   => 'About'
                                              );
      htp.tabledata(cvalue => l_right_data
                   ,calign => 'right'
                   );
    htp.tablerowclose;
  htp.tableclose;

  htp.hr;

  nm3web.CLOSE;

END HEADER;
--
----------------------------------------------------------------------------------------
--
PROCEDURE footer(pi_main_link IN boolean DEFAULT TRUE
                ,pi_back_link IN boolean DEFAULT TRUE
                ) IS
  l_right_text                 nm3type.max_varchar2;
  l_doing_right_text_as_module BOOLEAN;
BEGIN
   htp.p('<HTML>');
   htp.p('<HEAD>');
   htp.p('<BASE TARGET="nm3web_main_frame">');
   do_css_link;
   htp.p('</HEAD>');
   htp.p('<BODY>');
   htp.hr;

  htp.tableopen(cborder     => 'BORDER=0'
               ,calign      => 'CENTER'
               ,cattributes => 'width=100%');
    htp.tablerowopen;
      htp.tabledata(cvalue => CHR(169)
--                              || '2002 '
                              || htf.anchor2(curl    => g_exor_home_page
                                            ,ctext   => 'Exor Corporation'
                                            ,ctarget => '_blank')
                   ,calign => 'left');

      IF pi_back_link
        OR pi_main_link
      THEN
        IF pi_back_link
        THEN
          l_right_text := htf.anchor(curl        => 'javascript:parent.nm3web_main_frame.history.back()'
                                    ,cname       => 'Back'
                                    ,ctext       => 'Back'
                                    );
        END IF;

        IF pi_main_link
        THEN
          l_doing_right_text_as_module := g_main_menu_module != c_default_main_menu_module;
          IF l_doing_right_text_as_module
           THEN
             l_doing_right_text_as_module := nm3user.user_can_run_module (g_main_menu_module);
          END IF;
          IF l_doing_right_text_as_module
           THEN
             l_right_text :=    l_right_text || ' '
                          || htf.anchor(curl    => get_web_run_module_cmd||g_main_menu_module
                                       ,ctext   => g_main_menu_module_title
                                       );
          ELSE
             l_right_text :=    l_right_text || ' '
                          || htf.anchor(curl    => g_package_name||'.main_menu_frame'
                                       ,ctext   => 'Main Menu'
                                       );
          END IF;
        END IF;

        htp.tabledata(cvalue => l_right_text
                     ,calign => 'right');
      END IF;
    htp.tablerowclose;
  htp.tableclose;
   htp.p('</BODY>');
   htp.p('</HTML>');

END footer;
--
----------------------------------------------------------------------------------------
--
PROCEDURE failure(pi_error IN varchar2
                 ) IS

  l_text nm3type.max_varchar2;

BEGIN
  -------------------------------------
  --build the standard failure web page
  -------------------------------------

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'failure');

  htp.p('</SCRIPT>');
  --
  nm3web.head(p_close_head => TRUE
             ,p_title      => g_default_title);
  do_css_link;
  htp.bodyopen;
--
--  nm3web.header;
--

   htp.p('<SCRIPT>');
   htp.p('   alert("'||RTRIM(nm3flx.parse_error_message(REPLACE(pi_error,CHR(10),'\n')),'\')||'")');
   htp.p('   history.go(-1);');
   htp.p('</SCRIPT>');
   htp.bodyclose;
   htp.htmlclose;
--
   l_text := 'Error occurred:';
--
   htp.HEADER(1, l_text);
--
   htp.br;
--
  htp.p(pi_error);
--
--  --htp.br;
--  --htp.br;
--
--  --htp.anchor(curl  => 'nm3upload.xml_upload'
--  --          ,ctext => 'Back');
--
--  htp.br;
--
----  nm3web.footer;
  nm3web.CLOSE;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'failure');
END failure;
--
----------------------------------------------------------------------------------------
--
PROCEDURE run_module(pi_module       IN hig_modules.hmo_module%TYPE
                    ,pi_param_name1  IN varchar2 DEFAULT NULL
                    ,pi_param_value1 IN varchar2 DEFAULT NULL
                    ,pi_param_name2  IN varchar2 DEFAULT NULL
                    ,pi_param_value2 IN varchar2 DEFAULT NULL
                    ,pi_param_name3  IN varchar2 DEFAULT NULL
                    ,pi_param_value3 IN varchar2 DEFAULT NULL
                    ,pi_param_name4  IN varchar2 DEFAULT NULL
                    ,pi_param_value4 IN varchar2 DEFAULT NULL
                    ,pi_param_name5  IN varchar2 DEFAULT NULL
                    ,pi_param_value5 IN varchar2 DEFAULT NULL
                    ,pi_param_name6  IN varchar2 DEFAULT NULL
                    ,pi_param_value6 IN varchar2 DEFAULT NULL
                    ) IS

--  pragma authid ?

  e_no_permission EXCEPTION;
  e_not_web_module EXCEPTION;

  c_nl CONSTANT varchar2(1) := CHR(10);

  l_hmo_rec hig_modules%ROWTYPE;
  l_mode    hig_module_roles.hmr_role%TYPE;

  l_exe_str nm3type.max_varchar2;

BEGIN
  IF NOT(nm3user.user_can_run_module(p_module => pi_module))
  THEN
    RAISE e_no_permission;
  END IF;

  hig.get_module_details(pi_module => pi_module
                        ,po_hmo    => l_hmo_rec
                        ,po_mode   => l_mode);

  IF l_hmo_rec.hmo_module_type <> 'WEB'
  THEN
    RAISE e_not_web_module;
  END IF;

  l_exe_str := l_hmo_rec.hmo_filename;

  --add parameters
  IF pi_param_name1 IS NOT NULL
  THEN
    l_exe_str :=    l_exe_str
                 || '(' || pi_param_name1 || ' => ' || nm3flx.string(pi_string => pi_param_value1);

    IF pi_param_name2 IS NOT NULL
    THEN
      l_exe_str :=    l_exe_str
                   || c_nl || ',' || pi_param_name2 || ' => ' || nm3flx.string(pi_string => pi_param_value2);

      IF pi_param_name3 IS NOT NULL
      THEN
        l_exe_str :=    l_exe_str
                     || c_nl || ',' || pi_param_name3 || ' => ' || nm3flx.string(pi_string => pi_param_value3);

        IF pi_param_name4 IS NOT NULL
        THEN
          l_exe_str :=    l_exe_str
                       || c_nl || ',' || pi_param_name4 || ' => ' || nm3flx.string(pi_string => pi_param_value4);
           IF pi_param_name5 IS NOT NULL
           THEN
             l_exe_str :=    l_exe_str
                          || c_nl || ',' || pi_param_name5 || ' => ' || nm3flx.string(pi_string => pi_param_value5);
              IF pi_param_name6 IS NOT NULL
              THEN
                l_exe_str :=    l_exe_str
                             || c_nl || ',' || pi_param_name6 || ' => ' || nm3flx.string(pi_string => pi_param_value6);
              END IF;
           END IF;
        END IF;
      END IF;
    END IF;

    l_exe_str := l_exe_str || ')';
  END IF;

  --execute module code
  EXECUTE IMMEDIATE 'BEGIN ' || l_exe_str  || '; END;';

EXCEPTION
  WHEN e_no_permission
  THEN
    failure('You do not have permission to run module '
            || pi_module
            || '. Contact your system administrator.');

  WHEN e_not_web_module
  THEN
    failure(pi_module || ' cannot by run on the web.');

  WHEN others
  THEN
    failure(SQLERRM);

END run_module;
--
----------------------------------------------------------------------------------------
--
PROCEDURE available_modules (p_except varchar2 DEFAULT NULL) IS

  e_no_products EXCEPTION;

  CURSOR c_hpr IS
    SELECT
      *
    FROM
      hig_products hpr
    WHERE hpr_key IS NOT NULL
     AND
      EXISTS (SELECT
                1
              FROM
                hig_modules      hmo,
                hig_module_roles hmr,
                hig_user_roles   hur
              WHERE
                hmo.hmo_application = hpr.hpr_product
              AND
                hmo.hmo_module_type = 'WEB'
              AND
                hmo.hmo_fastpath_invalid = 'N'
              AND
                hmr.hmr_module = hmo.hmo_module
              AND
                hmr.hmr_role = hur.hur_role
              AND
                (p_except IS NULL OR hmr.hmr_module != p_except)
              AND
                hur.hur_username = USER)
   ORDER BY hpr_sequence;

  l_hpr_rec hig_products%ROWTYPE;

  CURSOR c_hmo(p_app hig_modules.hmo_application%TYPE
              ) IS
    SELECT
      *
    FROM
      hig_modules hmo
    WHERE
      hmo.hmo_module_type = 'WEB'
    AND
      hmo.hmo_application = p_app
    AND
      hmo.hmo_fastpath_invalid = 'N'
    AND
      (p_except IS NULL OR hmo.hmo_module != p_except)
     AND
      EXISTS (SELECT
                1
              FROM
                hig_module_roles hmr,
                hig_user_roles   hur
              WHERE
                hmo.hmo_module_type = 'WEB'
              AND
                hmo.hmo_fastpath_invalid = 'N'
              AND
                hmr.hmr_module = hmo.hmo_module
              AND
                hmr.hmr_role = hur.hur_role
              AND
                (p_except IS NULL OR hmr.hmr_module != p_except)
              AND
                hur.hur_username = USER);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'available_modules');

  OPEN c_hpr;
  FETCH c_hpr INTO l_hpr_rec;
  IF c_hpr%NOTFOUND
  THEN
    RAISE e_no_products;
  END IF;

  LOOP
    htp.tablerowopen;
      htp.tableheader(cvalue => htf.HEADER(2, l_hpr_rec.hpr_product_name));
    htp.tablerowclose;

    FOR l_rec IN c_hmo(p_app => l_hpr_rec.hpr_product)
    LOOP
      htp.tablerowopen;
        htp.tabledata(cvalue => htf.anchor(curl  => g_package_name||'.run_module?pi_module='
                                                    || l_rec.hmo_module
                                          ,ctext => l_rec.hmo_title)
                     ,calign => 'CENTER');
      htp.tablerowclose;
    END LOOP;

    FETCH c_hpr INTO l_hpr_rec;
    EXIT WHEN c_hpr%NOTFOUND;
  END LOOP;

  CLOSE c_hpr;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'available_modules');

EXCEPTION
  WHEN e_no_products
  THEN
    htp.tablerowopen;
      htp.tableheader(cvalue => htf.HEADER(2, 'No modules available.'));
    htp.tablerowclose;

END available_modules;
--
----------------------------------------------------------------------------------------
--
PROCEDURE LOGOFF IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'logoff');

  head(p_close_head => TRUE
      ,p_title      => g_default_title);
  htp.bodyopen;

  htp.tableopen(cborder => 'BORDER=0'
               ,calign  => 'center');

    htp.tablerowopen;
      htp.tableheader(cvalue => htf.anchor(curl => c_main_menu_image_url
                     ,ctext  => htf.img(curl        => c_main_menu_image
                                       ,calt        => 'Exor Corporation'
                                       ,cismap      => NULL
                                       ,cattributes => 'border=0')));
    htp.tablerowclose;

    htp.tablerowopen;
      htp.tabledata(cvalue => c_nbsp);
    htp.tablerowclose;

    htp.tablerowopen;
      htp.tableheader(cvalue => 'Are you sure you wish to log out of highways?');
    htp.tablerowclose;

    htp.tablerowopen;
      htp.tabledata(cvalue => c_nbsp);
    htp.tablerowclose;

    htp.tablerowopen;
      htp.formopen(curl => 'logmeoff');
      htp.tabledata(cvalue =>    '<input TYPE="button" name="back" value="Back" onclick="history.go(-1)">  '
                              || htf.formsubmit(cname  => 'LogOff'
                                               ,cvalue => 'Log Off')
                   ,calign => 'center');
      htp.formclose;
    htp.tablerowclose;
  htp.tableclose;

--  footer(pi_main_link => FALSE
--        ,pi_back_link => FALSE);
  nm3web.CLOSE;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'logoff');
END LOGOFF;
--
----------------------------------------------------------------------------------------
--
PROCEDURE show_clob(pi_clob IN clob
                   ) IS

  l_clob_chunk nm3type.max_varchar2;

  c_len CONSTANT pls_integer := dbms_lob.getlength(pi_clob);

  l_count pls_integer := 1;
  c_chunk_size CONSTANT pls_integer := 32767;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'show_clob');

  WHILE l_count <= c_len
  LOOP
    l_clob_chunk := dbms_lob.SUBSTR(lob_loc => pi_clob
                                   ,offset  => l_count
                                   ,amount  => c_chunk_size);

    replace_chevrons(l_clob_chunk);
    htp.p(l_clob_chunk);

    l_count := l_count + c_chunk_size;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'show_clob');

END show_clob;
--
----------------------------------------------------------------------------------------
--
PROCEDURE main_menu(pi_main_url varchar2 DEFAULT NULL
                   ) IS

  c_default_main_url CONSTANT varchar2(2000) := g_package_name||'.main_menu_frame';

  l_main_url nm3type.max_varchar2 := NVL(pi_main_url, c_default_main_url);

BEGIN
   l_main_url := REPLACE(l_main_url,'~',ampersand);
   l_main_url := LTRIM(l_main_url,'"');
   l_main_url := RTRIM(l_main_url,'"');
   htp.headopen;
   htp.title(ctitle => g_default_title);
   htp.headclose;
   htp.p('<frameset framespacing=0 frameborder=0 border=0 rows="70,*,50">');
   htp.p('   <frame name="nm3web_top_frame" src="'||g_package_name||'.header" noresize>');
   htp.p('   <frame name="nm3web_main_frame" src="' || l_main_url || '" noresize>');
   htp.p('   <frame name="nm3web_bottom_frame" src="'||g_package_name||'.footer" noresize>');
   htp.p('   <noframes>');
   htp.p('      <body>');
   htp.p('         <div class=Section1>');
   htp.p('            <p>This page uses frames, but your browser does not support them.</p>');
   htp.p('         </div>');
   htp.p('      </body>');
   htp.p('  </noframes>');
   htp.p('</frameset>');
END main_menu;
--
-----------------------------------------------------------------------------
--
PROCEDURE main_menu_frame IS
--
  CURSOR cs_user (c_user varchar2) IS
   SELECT hus_name
         ,hus_username
    FROM  hig_users
   WHERE  hus_username = c_user;
--
   l_username varchar2(30) := USER;
   l_user     varchar2(30) := l_username;
--
   c_this_module CONSTANT hig_modules.hmo_module%TYPE := 'NMWEB0000';
--
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'main_menu_frame');

  head(p_close_head => TRUE
      ,p_title      => g_default_title);
  htp.bodyopen;

  nm3web.module_startup(pi_module => c_this_module);

  htp.tableopen(cborder     => 'BORDER=0'
               ,calign      => 'CENTER');

    htp.tablerowopen;
      htp.tableheader(cvalue => htf.anchor2(curl  => c_main_menu_image_url
                                           ,ctarget => '_top'
                                           ,ctext => htf.img(curl        => c_main_menu_image
                                                            ,calign      => 'CENTER'
                                                            ,calt        => 'Exor Corporation'
                                                            ,cismap      => NULL
                                                            ,cattributes => 'border=0'
                                                            )
                                           )
                     );
    htp.tablerowclose;

    available_modules (c_this_module);
  htp.tableclose;
--
--  footer(pi_main_link => FALSE
--        ,pi_back_link => FALSE);
  nm3web.CLOSE;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'main_menu_frame');
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here THEN NULL;
END main_menu_frame;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_host RETURN varchar2 IS

  c_host_option CONSTANT hig_options.hop_id%TYPE := 'NM3WEBHOST';

  l_retval hig_options.hop_value%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_host');

  l_retval := hig.get_sysopt(p_option_id => c_host_option);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_host');

  RETURN l_retval;

END get_host;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_path RETURN varchar2 IS

  c_path_option CONSTANT hig_options.hop_id%TYPE := 'NM3WEBPATH';

  l_retval hig_options.hop_value%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_path');

  l_retval := hig.get_sysopt(p_option_id => c_path_option);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_path');

  RETURN l_retval;

END get_path;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_web_run_module_cmd (pi_param_name1  varchar2 DEFAULT NULL
                                ,pi_param_value1 varchar2 DEFAULT NULL
                                ,pi_param_name2  varchar2 DEFAULT NULL
                                ,pi_param_value2 varchar2 DEFAULT NULL
                                ,pi_param_name3  varchar2 DEFAULT NULL
                                ,pi_param_value3 varchar2 DEFAULT NULL
                                ,pi_param_name4  varchar2 DEFAULT NULL
                                ,pi_param_value4 varchar2 DEFAULT NULL
                                ,pi_param_name5  varchar2 DEFAULT NULL
                                ,pi_param_value5 varchar2 DEFAULT NULL
                                ,pi_param_name6  varchar2 DEFAULT NULL
                                ,pi_param_value6 varchar2 DEFAULT NULL
                                ) RETURN varchar2 IS
   l_retval nm3type.max_varchar2;
   --ampersand VARCHAR2(1) := '~';
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_web_run_module_cmd');
--
   l_retval := g_package_name||'.run_module?';
--
   IF pi_param_name1 IS NOT NULL
    THEN
      l_retval := l_retval||'pi_param_name1='||pi_param_name1||ampersand;
      l_retval := l_retval||'pi_param_value1='||pi_param_value1||ampersand;
      IF pi_param_name2 IS NOT NULL
       THEN
         l_retval := l_retval||'pi_param_name2='||pi_param_name2||ampersand;
         l_retval := l_retval||'pi_param_value2='||pi_param_value2||ampersand;
         IF pi_param_name3 IS NOT NULL
          THEN
            l_retval := l_retval||'pi_param_name3='||pi_param_name3||ampersand;
            l_retval := l_retval||'pi_param_value3='||pi_param_value3||ampersand;
            IF pi_param_name4 IS NOT NULL
             THEN
               l_retval := l_retval||'pi_param_name4='||pi_param_name4||ampersand;
               l_retval := l_retval||'pi_param_value4='||pi_param_value4||ampersand;
               IF pi_param_name5 IS NOT NULL
                THEN
                  l_retval := l_retval||'pi_param_name5='||pi_param_name5||ampersand;
                  l_retval := l_retval||'pi_param_value5='||pi_param_value5||ampersand;
                  IF pi_param_name6 IS NOT NULL
                   THEN
                     l_retval := l_retval||'pi_param_name6='||pi_param_name6||ampersand;
                     l_retval := l_retval||'pi_param_value6='||pi_param_value6||ampersand;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
--
   l_retval := l_retval||'pi_module=';
   --
   --l_retval := string_to_url (l_retval);
   --
   nm_debug.proc_end(g_package_name,'get_web_run_module_cmd');
--
   RETURN l_retval;
--
END get_web_run_module_cmd;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_browser_cmd RETURN varchar2 IS

  c_browser_exe_option CONSTANT hig_options.hop_id%TYPE := 'BROWSERPTH';
  c_default_cmd        CONSTANT varchar2(20)            := 'start "Exor" ';

  l_cmd nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_browser_cmd');

  --try user/system option for browser path
  l_cmd := hig.get_user_or_sys_opt(pi_option => c_browser_exe_option);

  IF l_cmd IS NULL
  THEN
    --no path to exe specified so use default
    l_cmd := c_default_cmd;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_browser_cmd');

  RETURN l_cmd || ' ';

END get_browser_cmd;
--
----------------------------------------------------------------------------------------
--
PROCEDURE user_can_run_module_web (p_module varchar2) IS
BEGIN
   IF NOT nm3user.user_can_run_module (p_module)
    THEN
      DECLARE
         l_20901 EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_20901, -20901);
      BEGIN
         hig.raise_ner ('HIG',126,-20901);
      EXCEPTION
         WHEN l_20901
          THEN
            failure('<H1><FONT COLOR="FF0000">'||nm3flx.parse_error_message(SQLERRM,'ORA',1)||'</FONT></H1>');
            RAISE g_you_should_not_be_here;
      END;
   END IF;
END user_can_run_module_web;
--
-----------------------------------------------------------------------------
--
PROCEDURE htp_tab_varchar (p_tab_vc         nm3type.tab_varchar32767
                          ,p_br_each_line   boolean DEFAULT FALSE
                          ,p_replace_spaces boolean DEFAULT FALSE
                          ) IS
   i pls_integer;
BEGIN
   i := p_tab_vc.FIRST;
   WHILE i IS NOT NULL
    LOOP
      IF p_br_each_line
       THEN
         htp.br;
      END IF;
      IF p_replace_spaces
       THEN
         htp.p(REPLACE(p_tab_vc(i),' ',c_nbsp));
      ELSE
         htp.p(p_tab_vc(i));
      END IF;
      i := p_tab_vc.NEXT(i);
   END LOOP;
END htp_tab_varchar;
--
----------------------------------------------------------------------------------------
--
PROCEDURE process_download ( pi_name IN varchar2 ) IS
BEGIN
   --
   IF get_document_table = nm3upload.c_nm_upload_files
    THEN
      check_nuf_visible_via_gateway (pi_name=>pi_name);
   END IF;
   --
   --owa_util.mime_header(nm3get.get_nuf(pi_name=>pi_name).mime_type,FALSE);
   owa_util.mime_header(get_owa_document_mime_type(pi_name=>pi_name),FALSE);
   --
   htp.p('Content-disposition: filename=' || pi_name);
   owa_util.http_header_close;
   wpg_docload.download_file(pi_name);
END process_download;
--
----------------------------------------------------------------------------------------
--
FUNCTION getfilepath RETURN varchar2 IS
   l_path_info   nm3type.max_varchar2;
BEGIN
  -- getfilepath() uses the SCRIPT_NAME and PATH_INFO cgi
  -- environment variables to construct the full pathname of

  -- the file URL, and then returns the part of the pathname
  -- following `/docs/'
   l_path_info   := owa_util.get_cgi_env(param_name => 'PATH_INFO');
   RETURN SUBSTR(l_path_info,2);
END getfilepath;
--
----------------------------------------------------------------------------------------
--
PROCEDURE process_download IS
BEGIN
  process_download (pi_name => getfilepath);
END process_download;
--
-----------------------------------------------------------------------------
--
PROCEDURE download_file_to_client (pi_name    IN varchar2 ) IS

l_nuf nm_upload_files%ROWTYPE;
BEGIN
   IF get_document_table = nm3upload.c_nm_upload_files
    THEN
      check_nuf_visible_via_gateway (pi_name=>pi_name);
   END IF;
   
   l_nuf := nm3get.get_nuf(pi_name);
   --
   owa_util.mime_header('application/octet',FALSE);
   --
   htp.p('Content-length: ' || dbms_lob.getlength(l_nuf.blob_content));
   htp.p('Content-disposition: filename=' || pi_name);
   owa_util.http_header_close;

   wpg_docload.download_file(l_nuf.blob_content);

END download_file_to_client;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_download_url( pi_name varchar2 ) RETURN varchar2 IS
BEGIN
   RETURN nm3flx.i_t_e (g_web_doc_path IS NOT NULL
                       ,g_web_doc_path||'/'
                       ,g_package_name||'.process_download?pi_name='
                       )||string_to_url(pi_name);
END get_download_url;
--
----------------------------------------------------------------------------------------
--
PROCEDURE about IS

  c_nl CONSTANT varchar2(1) := CHR(10);

  l_qry nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'about');

  head(p_close_head => TRUE
      ,p_title      => g_default_title);
  htp.bodyopen;

  module_startup(pi_module => c_about_module);

  htp.div(calign => 'center');

  htp.HEADER(nsize   => 2
            ,cheader => 'Products');

  l_qry :=            'SELECT'
           || c_nl || '  hpr_product_name product,'
           || c_nl || '  hpr_version      installed_version'
           || c_nl || 'FROM'
           || c_nl || '  hig_products'
           || c_nl || 'WHERE'
           || c_nl || '  hpr_key IS NOT NULL'
           || c_nl || 'ORDER BY'
           || c_nl || '  hpr_sequence';

  nm3web.htp_tab_varchar(p_tab_vc => dm3query.execute_query_sql_tab(p_sql => l_qry));

  IF nm3user.user_can_run_module (c_about_server_module)
   THEN
     htp.br;
     htp.tableopen;
     htp.tablerowopen;
     htp.p('<TD>');
     htp.anchor(  curl  => g_package_name||'.run_module?pi_module='||c_about_server_module
                , ctext => c_about_server_module_title
                );
     htp.p('</TD>');
     htp.tablerowclose;
     htp.tableclose;
  END IF;

  nm3web.CLOSE;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'about');

END about;
--
----------------------------------------------------------------------------------------
--
PROCEDURE about_server_objects ( pi_refresh varchar2 DEFAULT NULL )
IS

  c_nl CONSTANT varchar2(1) := CHR(10);
  l_qry nm3type.max_varchar2;

BEGIN
   nm_debug.proc_start(g_package_name , 'about_server_objects');

   nm3web.head(p_close_head => TRUE
              ,p_title      => c_about_server_module_title);

   htp.bodyopen;

   nm3web.module_startup(pi_module => c_about_server_module);

   htp.tableopen(cborder => 'border=0');

   htp.formopen(curl     => g_package_name||'.about_server_objects');
   htp.tabledata(htf.formsubmit(cvalue => 'Refresh',cname => 'pi_refresh'));

   htp.formclose;

   htp.tableclose;

   IF pi_refresh IS NOT NULL THEN
      exor_version.get_versions;
   END IF;

   l_qry :=            'SELECT'
            || c_nl || '  package_name object_name,'
            || c_nl || '  package_type object_type,'
            || c_nl || '  version_text version_,'
            || c_nl || '  TO_CHAR(last_ddl_time,'||nm3flx.string('DD-Mon-YYYY HH24:MI:SS')||') last_ddl_time'
            || c_nl || 'FROM'
            || c_nl || '  exor_version_tab'
            || c_nl || 'ORDER BY package_name, package_type';

   nm3web.htp_tab_varchar(p_tab_vc => dm3query.execute_query_sql_tab(p_sql => l_qry));

   nm3web.CLOSE;

   nm_debug.proc_end(g_package_name , 'about_server_objects');

   EXCEPTION
      WHEN nm3web.g_you_should_not_be_here
      THEN
        NULL;

END about_server_objects;
--
----------------------------------------------------------------------------------------
--
PROCEDURE load_header_from_main(pi_title  IN varchar2 DEFAULT NULL
                               ,pi_title2 IN varchar2 DEFAULT NULL
                               ,pi_module IN hig_modules.hmo_module%TYPE DEFAULT NULL
                               ) IS

  l_param_str nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'load_header_from_main');

  IF pi_title IS NOT NULL
  THEN
    l_param_str := '?p_title=' || string_to_url(pi_str => pi_title);
  END IF;

  IF pi_title2 IS NOT NULL
  THEN
    IF l_param_str IS NULL
    THEN
      l_param_str := l_param_str || '?';
    ELSE
      l_param_str := l_param_str || ampersand;
    END IF;

    l_param_str := l_param_str || 'p_title2=' || string_to_url(pi_str => pi_title2);
  END IF;

  IF pi_module IS NOT NULL
  THEN
    IF l_param_str IS NULL
    THEN
      l_param_str := l_param_str || '?';
    ELSE
      l_param_str := l_param_str || ampersand;
    END IF;

    l_param_str := l_param_str || 'p_module=' || string_to_url(pi_str => pi_module);
  END IF;

  htp.p('<SCRIPT LANGUAGE="JavaScript">');
  htp.p('<!-- Hide JS Code from old browsers');
  --find correct frame
  htp.p('for (nm3web_parent = parent; nm3web_parent.nm3web_top_frame == undefined; nm3web_parent = nm3web_parent.parent){};');
  --Changed below to use replace method as it seems to preserve history better. Before
  --when the back link on the footer was hit IE (Netscape was OK) did a back on the header.
  --  htp.p('  parent.nm3web_top_frame.location.href = "'||g_package_name||'.header' || l_param_str || '";');
  htp.p('nm3web_parent.nm3web_top_frame.location.replace("'||g_package_name||'.header' || l_param_str || '");');
  htp.p('// -->');
  htp.p('</SCRIPT>');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'load_header_from_main');

END load_header_from_main;
--
----------------------------------------------------------------------------------------
--
PROCEDURE check_frames IS
BEGIN
  --if current page is not in standard frameset then put it into them
  js_open;

  htp.p(' var doc_location;');
  htp.p('if (parent.frames.length == 0){');
  htp.p('  doc_location = ''"'' + document.location + ''"'';');
  FOR i IN 1..13
   LOOP
  htp.p('  doc_location = doc_location.replace("'||CHR(38)||'","~");');
  END LOOP;
  htp.p('  window.location.replace('||nm3flx.string(g_package_name||'.main_menu?pi_main_url=')||' + doc_location);');
  htp.p('}');

  js_close;
END;
--
----------------------------------------------------------------------------------------
--
PROCEDURE module_startup(pi_module IN hig_modules.hmo_module%TYPE
                        ) IS

  l_hmo_rec hig_modules%ROWTYPE;
  l_hpr_rec hig_products%ROWTYPE;
  l_mode    hig_module_roles.hmr_mode%TYPE;
  l_title1  nm3type.max_varchar2;
  l_title2  nm3type.max_varchar2;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'module_startup');

  --module security
  user_can_run_module_web(p_module => pi_module);

  --get module details
  hig.get_module_details(pi_module => pi_module
                        ,po_hmo    => l_hmo_rec
                        ,po_mode   => l_mode);
--
  --check module has been launched in standard NM3 Web frameset
  check_frames;

  l_hpr_rec := hig.get_hpr(pi_product => l_hmo_rec.hmo_application);

  --set module details in v%session
  dbms_application_info.set_module(module_name => l_hmo_rec.hmo_application
                                  ,action_name => pi_module);

  --reload header with details of module
  --
  l_title1 := l_hpr_rec.hpr_product_name;
  IF c_dbwintitle
   THEN
     l_title1 := l_title1||' v'||l_hpr_rec.hpr_version;
  END IF;
  l_title2 := l_hmo_rec.hmo_title;
  IF c_idwintitle
   THEN
     l_title2 := l_title2||' - '||pi_module;
  END IF;
  --
  load_header_from_main(pi_title  => l_title1
                       ,pi_title2 => l_title2
                       ,pi_module => pi_module);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'module_startup');

END module_startup;
--
----------------------------------------------------------------------------------------
--
PROCEDURE help(pi_module IN hig_modules.hmo_module%TYPE DEFAULT NULL
              ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'help');

  head(p_close_head => TRUE
      ,p_title      => g_default_title);
  htp.bodyopen;

  module_startup(pi_module => c_help_module);

  htp.HEADER(nsize   => 2
            ,cheader => 'Help not available.');

  htp.HEADER(nsize   => 2
            ,cheader => pi_module);

  nm3web.CLOSE;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'help');

END help;
--
----------------------------------------------------------------------------------------
--
PROCEDURE auto_refresh(pi_interval IN pls_integer
                      ,pi_url      IN varchar2
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'auto_refresh');

  htp.p(   '<META HTTP-EQUIV="REFRESH" CONTENT="'
        || pi_interval || '; URL=' || pi_url || '">');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'auto_refresh');

END auto_refresh;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_client_ip_address RETURN varchar2 IS
BEGIN
   RETURN owa_util.get_cgi_env(param_name => 'REMOTE_ADDR');
END get_client_ip_address;
--
----------------------------------------------------------------------------------------
--
PROCEDURE pop_url_and_back (p_url          IN varchar2
                           ,p_window_title IN varchar2
                           ,p_width        IN pls_integer
                           ,p_height       IN pls_integer
                           ,p_toolbar      IN boolean DEFAULT FALSE
                           ,p_location     IN boolean DEFAULT FALSE
                           ,p_directories  IN boolean DEFAULT FALSE
                           ,p_status       IN boolean DEFAULT FALSE
                           ,p_menubar      IN boolean DEFAULT FALSE
                           ,p_scrollbars   IN boolean DEFAULT FALSE
                           ,p_resizable    IN boolean DEFAULT FALSE
                           ) IS
   FUNCTION bool_to_0_1 (p_boolean boolean) RETURN pls_integer IS
   BEGIN
      RETURN nm3flx.i_t_e(p_boolean,1,0);
   END bool_to_0_1;
BEGIN
   head(p_close_head => FALSE
       ,p_title      => p_window_title
       ,pi_vml       => FALSE
       );
   htp.p('  <SCRIPT language="JavaScript">');
   htp.p('    function PopAndBack()');
   htp.p('    {');
   htp.p('      CurrencyWindow = window.open ("", "'||REPLACE(p_window_title,' ',NULL)||'", "toolbar='||bool_to_0_1(p_toolbar)
                                                                        ||',location='||bool_to_0_1(p_location)
                                                                        ||',directories='||bool_to_0_1(p_directories)
                                                                        ||',status='||bool_to_0_1(p_status)
                                                                        ||',menubar='||bool_to_0_1(p_menubar)
                                                                        ||',scrollbars='||bool_to_0_1(p_scrollbars)
                                                                        ||',resizable='||bool_to_0_1(p_resizable)
                                                                        ||',height='||p_height
                                                                        ||',width='||p_width
                                                                        ||'")');
   htp.p('      CurrencyWindow.focus()');
   htp.p('      CurrencyWindow.location.href = "'||p_url||'"');
   htp.p('      history.back()');
   htp.p('    }');
   htp.p('  </SCRIPT>');
   htp.p('</HEAD>');
   htp.p('<BODY onLoad=PopAndBack()>');
   htp.p('Click to open <A HREF="'||p_url||'">'||p_window_title||'</A>');
   htp.p('</BODY>');
   htp.p('</HTML>');
END pop_url_and_back;
--
----------------------------------------------------------------------------------------
--
PROCEDURE pop_module_and_back (p_module       IN hig_modules.hmo_module%TYPE
                              ,p_width        IN pls_integer
                              ,p_height       IN pls_integer
                              ,p_toolbar      IN boolean DEFAULT FALSE
                              ,p_location     IN boolean DEFAULT FALSE
                              ,p_directories  IN boolean DEFAULT FALSE
                              ,p_status       IN boolean DEFAULT FALSE
                              ,p_menubar      IN boolean DEFAULT FALSE
                              ,p_scrollbars   IN boolean DEFAULT FALSE
                              ,p_resizable    IN boolean DEFAULT FALSE
                              ) IS
   l_rec_hmo hig_modules%ROWTYPE;
   l_mode    hig_module_roles.hmr_mode%TYPE;
BEGIN
--
   hig.get_module_details (pi_module => p_module
                          ,po_hmo    => l_rec_hmo
                          ,po_mode   => l_mode
                          );
   pop_url_and_back (p_url          => l_rec_hmo.hmo_filename
                    ,p_window_title => l_rec_hmo.hmo_title
                    ,p_width        => p_width
                    ,p_height       => p_height
                    ,p_toolbar      => p_toolbar
                    ,p_location     => p_location
                    ,p_directories  => p_directories
                    ,p_status       => p_status
                    ,p_menubar      => p_menubar
                    ,p_scrollbars   => p_scrollbars
                    ,p_resizable    => p_resizable
                    );
END pop_module_and_back;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_owa_document_mime_type(pi_name varchar2
                                   ) RETURN varchar2 IS

   l_retval              varchar2(128);
   c_table_name CONSTANT varchar2(30)  := get_document_table;
   l_cur nm3type.ref_cursor;
   l_found boolean;

BEGIN
   OPEN  l_cur
    FOR             'SELECT mime_type'
         ||CHR(10)||' FROM  '||c_table_name
         ||CHR(10)||'WHERE  name = :a'
   USING pi_name;
   FETCH l_cur
    INTO l_retval;
   l_found := l_cur%FOUND;
   CLOSE l_cur;
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => c_table_name||'.name = '||nm3flx.string(pi_name)
                    );
   END IF;

   RETURN l_retval;

END get_owa_document_mime_type;
--
----------------------------------------------------------------------------------------
--
FUNCTION get_document_table RETURN varchar2 IS
BEGIN
   RETURN UPPER(owa_util.get_cgi_env(param_name => 'DOCUMENT_TABLE'));
END get_document_table;
--
----------------------------------------------------------------------------------------
--
PROCEDURE check_nuf_visible_via_gateway (pi_name varchar2) IS
--
   l_rec_nuf nm_upload_files%ROWTYPE;
--
   l_cur     nm3type.ref_cursor;
   l_sql     nm3type.max_varchar2;
--
   l_tab_nufgc_seq             nm3type.tab_number;
   l_tab_nufgc_column_name     nm3type.tab_varchar30;
   l_tab_nufgc_column_datatype nm3type.tab_varchar30;
   l_start varchar2(30);
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_sql := l_sql||p_text;
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_nuf_visible_via_gateway');
--
   l_rec_nuf := nm3get.get_nuf (pi_name => pi_name);
--
   IF l_rec_nuf.nuf_nufg_table_name IS NOT NULL
    THEN
      append ('DECLARE',FALSE);
      append ('--');
      FOR i IN 1..5
       LOOP
         append ('   c_val_'||i||' CONSTANT nm_upload_files.nuf_nufgc_column_val_'||i||'%TYPE := :val'||i||';');
      END LOOP;
      append ('--');
      append ('   CURSOR cs_exists IS');
      append ('   SELECT 1');
      append ('    FROM  dual');
      append ('   WHERE  EXISTS (SELECT 1');
      append ('                   FROM  '||l_rec_nuf.nuf_nufg_table_name||' a');
      SELECT nufgc_seq
            ,nufgc_column_name
            ,nufgc_column_datatype
       BULK  COLLECT
       INTO  l_tab_nufgc_seq
            ,l_tab_nufgc_column_name
            ,l_tab_nufgc_column_datatype
       FROM  nm_upload_file_gateway_cols
      WHERE  nufgc_nufg_table_name = l_rec_nuf.nuf_nufg_table_name
      ORDER BY nufgc_seq;
      l_start := 'WHERE  ';
      FOR i IN 1..l_tab_nufgc_seq.COUNT
       LOOP
         append ('                  '||l_start||'a.'||l_tab_nufgc_column_name(i)||' = ');
         IF    l_tab_nufgc_column_datatype(i) = nm3type.c_number
          THEN
           append ('to_number(c_val_'||l_tab_nufgc_seq(i)||')');
         ELSIF l_tab_nufgc_column_datatype(i) = nm3type.c_date
          THEN
           append ('hig.date_convert(c_val_'||l_tab_nufgc_seq(i)||')');
         ELSE
           append ('c_val_'||l_tab_nufgc_seq(i));
         END IF;
         l_start := ' AND   ';
      END LOOP;
      append ('                 );');
      append ('--');
      append ('   l_dummy PLS_INTEGER;');
      append ('   l_found BOOLEAN;');
      append ('--');
      append ('BEGIN');
      append ('--');
      append ('   OPEN  cs_exists;');
      append ('   FETCH cs_exists INTO l_dummy;');
      append ('   l_found := cs_exists%FOUND;');
      append ('   CLOSE cs_exists;');
      append ('--');
      append ('   IF NOT l_found');
      append ('    THEN');
      append ('      RAISE no_data_found;');
      append ('   END IF;');
      append ('--');
      append ('END;');
      BEGIN
         EXECUTE IMMEDIATE l_sql
          USING  l_rec_nuf.nuf_nufgc_column_val_1
                ,l_rec_nuf.nuf_nufgc_column_val_2
                ,l_rec_nuf.nuf_nufgc_column_val_3
                ,l_rec_nuf.nuf_nufgc_column_val_4
                ,l_rec_nuf.nuf_nufgc_column_val_5;
      EXCEPTION
         WHEN no_data_found
          THEN
            hig.raise_ner (pi_appl => nm3type.c_hig
                          ,pi_id   => 126
                          );
      END;
   END IF;
--
   nm_debug.proc_end(g_package_name,'check_nuf_visible_via_gateway');
--
END check_nuf_visible_via_gateway;
--
----------------------------------------------------------------------------------------
--
PROCEDURE do_close_window_button  IS
BEGIN
   htp.p('<DIV ALIGN=RIGHT>');
   htp.p('<form>');
   htp.p('<input type="button" value="'||c_close||'" onClick="window.close();">');
   htp.p('</form>');
   htp.p('</DIV>');
END do_close_window_button;
--
----------------------------------------------------------------------------------------
--
END nm3web;
/
