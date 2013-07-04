CREATE OR REPLACE PACKAGE BODY dm3query AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/dm3query.pkb-arc   2.1   Jul 04 2013 14:31:26   James.Wadsworth  $
--       Module Name      : $Workfile:   dm3query.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:31:26  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:06  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on  SCCS Version     : 1.8
--
--
--   Author : Jonathan Mills
--
--   DM3 Query package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.1  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'dm3query';
--
-----------------------------------------------------------------------------
--
   g_tab_lines    nm3type.tab_varchar32767;
--
   c_this_module       CONSTANT hig_modules.hmo_module%TYPE := 'DOCWEB0010';
   c_this_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   g_sql          VARCHAR2(32767);
   g_tab_dqc      tab_dqc;
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
PROCEDURE replace_substring_js_func;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_dq (p_sql   VARCHAR2
                  ,p_title VARCHAR2
                  ,p_desc  VARCHAR2 DEFAULT NULL
                  ) IS
BEGIN
--
   INSERT INTO doc_query
          (dq_id
          ,dq_title
          ,dq_descr
          ,dq_sql
          )
   VALUES (dq_id_seq.nextval
          ,p_title
          ,p_desc
          ,p_sql
          );
--
END ins_dq;
--
-----------------------------------------------------------------------------
--
PROCEDURE run_sql_internal IS
--
   l_start_time NUMBER;
   l_end_time   NUMBER;
--
   l_rec_dq     doc_query_cols%ROWTYPE;
--
   l_tab_vc     nm3type.tab_varchar32767;
--
BEGIN
--
   l_tab_vc.DELETE;
--
   g_tab_lines.DELETE;
--
   nm3ddl.append_tab_varchar (l_tab_vc,'DECLARE',FALSE);
   nm3ddl.append_tab_varchar (l_tab_vc,'   CURSOR c_dq IS');
   nm3ddl.append_tab_varchar (l_tab_vc,'   '||g_sql||';');
   nm3ddl.append_tab_varchar (l_tab_vc,'BEGIN');
   nm3ddl.append_tab_varchar (l_tab_vc,'   FOR cs_rec IN c_dq');
   nm3ddl.append_tab_varchar (l_tab_vc,'    LOOP');
   nm3ddl.append_tab_varchar (l_tab_vc,'      '||g_package_name||'.write_line('||nm3flx.string('<TR>')||');');
   --
   write_line ('<TABLE BORDER="1">');
   write_line ('<TR>');
   --
   FOR i IN 1..g_tab_dqc.COUNT
    LOOP
      l_rec_dq := g_tab_dqc(i);
      write_line ('<TH>'||INITCAP(REPLACE(l_rec_dq.dqc_column_alias,'_',' '))||'</TH>');
      nm3ddl.append_tab_varchar (l_tab_vc,'      IF cs_rec.'||l_rec_dq.dqc_column||' IS NULL THEN');
      nm3ddl.append_tab_varchar (l_tab_vc,'         '||g_package_name||'.write_line('||nm3flx.string('<TD>')||'||nm3web.c_nbsp||'||nm3flx.string('</TD>')||');');
      nm3ddl.append_tab_varchar (l_tab_vc,'      ELSE');
      IF l_rec_dq.dqc_datatype = nm3type.c_varchar
       THEN
         nm3ddl.append_tab_varchar (l_tab_vc,'         '||g_package_name||'.write_line('||nm3flx.string('<TD>')||'||REPLACE(cs_rec.'||l_rec_dq.dqc_column||','||nm3flx.string('  ')||',nm3web.c_nbsp||nm3web.c_nbsp)||'||nm3flx.string('</TD>')||');');
      ELSE
         nm3ddl.append_tab_varchar (l_tab_vc,'         '||g_package_name||'.write_line('||nm3flx.string('<TD>')||'||cs_rec.'||l_rec_dq.dqc_column||'||'||nm3flx.string('</TD>')||');');
      END IF;
      nm3ddl.append_tab_varchar (l_tab_vc,'      END IF;');
   END LOOP;
   nm3ddl.append_tab_varchar (l_tab_vc,'      '||g_package_name||'.write_line('||nm3flx.string('</TR>')||');');
   write_line ('</TR>');
   --
   nm3ddl.append_tab_varchar (l_tab_vc,'   END LOOP;');
   nm3ddl.append_tab_varchar (l_tab_vc,'END;');

   l_start_time := dbms_utility.get_time;
   nm3ddl.execute_tab_varchar (l_tab_vc);
   l_end_time   := dbms_utility.get_time;
--
   write_line ('</TABLE>');
--
   nm3ddl.delete_tab_varchar;
--
END run_sql_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_line (p_line VARCHAR2) IS
BEGIN
   g_tab_lines(g_tab_lines.COUNT+1) := p_line;
END write_line;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_query_tab (p_dq_id    doc_query.dq_id%TYPE) IS
BEGIN
--
   g_sql     := get_rec_dq(p_dq_id).dq_sql;
   g_tab_dqc := get_tab_dqc(p_dq_id);
   --
   run_sql_internal;
--
EXCEPTION
   WHEN nm3type.g_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);
--
END execute_query_tab;
--
-----------------------------------------------------------------------------
--
FUNCTION execute_query_tab (p_dq_id    doc_query.dq_id%TYPE) RETURN nm3type.tab_varchar32767 IS
BEGIN
--
   execute_query_tab (p_dq_id => p_dq_id);
--
   RETURN g_tab_lines;
--
END execute_query_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_query_tab (p_dq_title doc_query.dq_title%TYPE) IS
BEGIN
--
   execute_query_tab (p_dq_id => get_dq_id(p_dq_title));
--
END execute_query_tab;
--
-----------------------------------------------------------------------------
--
FUNCTION execute_query_tab (p_dq_title doc_query.dq_title%TYPE) RETURN nm3type.tab_varchar32767 IS
--
BEGIN
--
   execute_query_tab (p_dq_title => p_dq_title);
--
   RETURN g_tab_lines;
--
END execute_query_tab;
--
-----------------------------------------------------------------------------
--
FUNCTION execute_query (p_dq_id    doc_query.dq_id%TYPE)    RETURN VARCHAR2 IS
--
   l_retval VARCHAR2(32767);
--
BEGIN
--
   execute_query_tab (p_dq_id => p_dq_id);
--
   FOR i IN 1..g_tab_lines.COUNT
    LOOP
      IF LENGTH(g_tab_lines(i)) + LENGTH(l_retval) > 32767
       THEN
         hig.raise_ner(pi_appl               => nm3type.c_net
                      ,pi_id                 => 255
                      );
      ELSE
         l_retval := l_retval||g_tab_lines(i);
      END IF;
   END LOOP;
--
   RETURN l_retval;
--
EXCEPTION
   WHEN nm3type.g_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);
END execute_query;
--
-----------------------------------------------------------------------------
--
FUNCTION execute_query (p_dq_title doc_query.dq_title%TYPE) RETURN VARCHAR2 IS
--
BEGIN
--
   RETURN execute_query (p_dq_id => get_dq_id(p_dq_title));
--
END execute_query;
--
-----------------------------------------------------------------------------
--
FUNCTION execute_query_sql (p_sql VARCHAR2) RETURN VARCHAR2 IS
--
   l_retval VARCHAR2(32767);
--
BEGIN
--
   execute_query_sql_tab (p_sql => p_sql);
--
   FOR i IN 1..g_tab_lines.COUNT
    LOOP
      IF LENGTH(g_tab_lines(i)) + LENGTH(l_retval) > 32767
       THEN
         hig.raise_ner(pi_appl               => nm3type.c_net
                      ,pi_id                 => 255
                      );
      ELSE
         l_retval := l_retval||g_tab_lines(i);
      END IF;
   END LOOP;
--
   RETURN l_retval;
--
EXCEPTION
   WHEN nm3type.g_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);
--
END execute_query_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION execute_query_sql_tab (p_sql VARCHAR2) RETURN nm3type.tab_varchar32767 IS
BEGIN
--
   execute_query_sql_tab (p_sql => p_sql);
   RETURN g_tab_lines;
--
END execute_query_sql_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_query_sql_tab (p_sql VARCHAR2) IS
BEGIN
--
   g_sql     := p_sql;
   g_tab_dqc := derive_tab_dqc_from_dq (g_sql);
   --
   run_sql_internal;
--
EXCEPTION
   WHEN nm3type.g_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);
--
END execute_query_sql_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE list_queries IS
BEGIN
--
   nm_debug.proc_start (g_package_name, 'list_queries');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_this_module_title
              );
--
   htp.bodyopen;
   nm3web.module_startup (c_this_module);
 --
 --
--   nm3web.header;
 --
   htp.tableopen (cattributes => 'ALIGN=CENTER');
   --
   htp.formopen(g_package_name||'.show_query_in_own_page');
--   htp.formhidden ('p_module',c_this_module);
--   htp.formhidden ('p_module_title',c_this_module_title);
   htp.tablerowopen;
   htp.tabledata('Select Query');
   htp.p('<TD>');
   --
   htp.p('<SELECT NAME="p_dq_id">');
   FOR cs_rec IN (SELECT * FROM doc_query ORDER BY dq_title)
    LOOP
      htp.p('<OPTION VALUE="'||cs_rec.dq_id||'">'||cs_rec.dq_title||' - '||cs_rec.dq_descr||'</OPTION>');
   END LOOP;
   htp.p('</SELECT>');
   htp.p('</TD>');
   htp.tabledata(htf.formsubmit (cvalue=>'Run'));
   htp.tablerowclose;
   htp.p('</FORM>');
   --
   htp.tableclose;
 --
   nm3web.CLOSE;
--
   nm_debug.proc_end (g_package_name, 'list_queries');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here THEN NULL;
END list_queries;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_query_in_own_page (p_dq_id        doc_query.dq_id%TYPE
                                 ,p_module       hig_modules.hmo_module%TYPE DEFAULT NULL
                                 ,p_module_title hig_modules.hmo_title%TYPE  DEFAULT NULL
                                 ) IS
--
   l_rec_dq                  doc_query%ROWTYPE;
--
   c_module         CONSTANT hig_modules.hmo_module%TYPE := NVL(p_module,c_this_module);
   c_module_title   CONSTANT hig_modules.hmo_title%TYPE  := NVL(p_module_title,c_this_module_title);
   c_procedure_name CONSTANT VARCHAR2(30)                := 'show_query_in_own_page';
--
BEGIN
--
   nm_debug.proc_start (g_package_name, c_procedure_name);
--
   nm3web.module_startup (c_module);
--
   l_rec_dq := get_rec_dq(p_dq_id);
--
   nm3web.head(p_close_head => FALSE
              ,p_title      => c_this_module_title
              );
--
   execute_query_tab(p_dq_id);
--
   main_js_for_dump_table (p_tab_vc => g_tab_lines);
--
   htp.headclose;
 --
   htp.bodyopen;
--
   do_save_button_and_params (p_window_title      => l_rec_dq.dq_title
                             ,p_calling_pack_proc => g_package_name||'.'||c_procedure_name
                             );
 --
   IF l_rec_dq.dq_descr IS NOT NULL
    THEN
      htp.p(l_rec_dq.dq_descr);
   END IF;
 --
   htp.tableopen(cattributes=>'ALIGN=CENTER');
   htp.tablerowopen;
   write_retrieved_js;
   htp.tablerowclose;
   htp.tableclose;
 --
   nm3web.CLOSE;
--
   nm_debug.proc_end (g_package_name, c_procedure_name);
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here THEN NULL;
END show_query_in_own_page;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_query_in_own_page (p_dq_title     doc_query.dq_title%TYPE
                                 ,p_module       hig_modules.hmo_module%TYPE DEFAULT NULL
                                 ,p_module_title hig_modules.hmo_title%TYPE  DEFAULT NULL
                                 ) IS
BEGIN
--
   show_query_in_own_page (p_dq_id        => get_dq_id (p_dq_title)
                          ,p_module       => p_module
                          ,p_module_title => p_module_title
                          );
--
END show_query_in_own_page;
--
-----------------------------------------------------------------------------
--
FUNCTION get_rec_dq(p_dq_id doc_query.dq_id%TYPE) RETURN doc_query%ROWTYPE IS
--
   CURSOR cs_dq (c_dq_id NUMBER) IS
   SELECT *
    FROM  doc_query
   WHERE  dq_id = c_dq_id;
--
   l_retval doc_query%ROWTYPE;
--
BEGIN
--
   OPEN  cs_dq (p_dq_id);
   FETCH cs_dq INTO l_retval;
   IF cs_dq%NOTFOUND
    THEN
      CLOSE cs_dq;
      hig.raise_ner(nm3type.c_net,57);
   END IF;
   CLOSE cs_dq;
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN nm3type.g_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);
--
END get_rec_dq;
--
-----------------------------------------------------------------------------
--
FUNCTION get_dq_id (p_dq_title doc_query.dq_title%TYPE) RETURN doc_query.dq_id%TYPE IS
--
   CURSOR cs_dq (c_dq_title doc_query.dq_title%TYPE) IS
   SELECT dq_id
    FROM  doc_query
   WHERE  dq_title = c_dq_title;
--
   l_dq_id doc_query.dq_id%TYPE;
--
BEGIN
--
   OPEN  cs_dq (p_dq_title);
   FETCH cs_dq INTO l_dq_id;
   IF cs_dq%NOTFOUND
    THEN
      CLOSE cs_dq;
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 57
                   ,pi_supplementary_info => p_dq_title
                   );
   END IF;
   CLOSE cs_dq;
--
   RETURN l_dq_id;
--
EXCEPTION
--
   WHEN nm3type.g_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3type.g_exception_code,nm3type.g_exception_msg);
--
END get_dq_id;
--
-----------------------------------------------------------------------------
--
FUNCTION derive_tab_dqc_from_dq (p_dq_sql VARCHAR2
                                ,p_dq_id  doc_query.dq_id%TYPE DEFAULT NULL
                                ) RETURN tab_dqc IS
--
   l_tab_dqc tab_dqc;
--
   l_rec_tab_col_dets dbms_sql.desc_tab;
   l_rec_col          dbms_sql.desc_rec;
   l_datatype         user_arguments.data_type%TYPE;
--
   l_rec_dqc doc_query_cols%ROWTYPE;
--
BEGIN
--
   l_rec_tab_col_dets := nm3flx.get_col_dets_from_sql(p_dq_sql);
--
   IF l_rec_tab_col_dets.COUNT = 0
    THEN
      hig.raise_ner(pi_appl => nm3type.c_net
                   ,pi_id   => 252
                   );
   END IF;
--
   FOR i IN 1..l_rec_tab_col_dets.COUNT
    LOOP
--
      l_rec_col  := l_rec_tab_col_dets(i);
      l_datatype := nm3flx.get_datatype_dbms_sql_desc_rec(l_rec_col);
--
      IF NOT nm3flx.is_string_valid_for_object(l_rec_col.col_name)
       THEN
         hig.raise_ner(pi_appl               => nm3type.c_net
                      ,pi_id                 => 253
                      ,pi_supplementary_info => l_rec_col.col_name
                      );
      ELSIF l_datatype NOT IN (nm3type.c_number, nm3type.c_date, nm3type.c_varchar, 'CHAR')
       THEN
         hig.raise_ner(pi_appl               => nm3type.c_net
                      ,pi_id                 => 254
                      ,pi_supplementary_info => l_rec_col.col_name||':'||l_datatype
                      );
      END IF;
--
      l_rec_dqc.dqc_dq_id        := p_dq_id;
      l_rec_dqc.dqc_seq_no       := i;
      l_rec_dqc.dqc_column       := l_rec_col.col_name;
      l_rec_dqc.dqc_column_alias := INITCAP(REPLACE(l_rec_col.col_name,'_',' '));
      l_rec_dqc.dqc_datatype     := l_datatype;
      l_rec_dqc.dqc_data_len     := l_rec_col.col_max_len;
      --
      l_tab_dqc(i) := l_rec_dqc;
--
   END LOOP;
--
   RETURN l_tab_dqc;
--
END derive_tab_dqc_from_dq;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_tab_dqc (p_tab_dqc tab_dqc) IS
--
   l_rec_dqc doc_query_cols%ROWTYPE;
--
BEGIN
--
   FOR i IN 1..p_tab_dqc.COUNT
    LOOP
      l_rec_dqc := p_tab_dqc(i);
      INSERT INTO doc_query_cols
             (dqc_dq_id
             ,dqc_seq_no
             ,dqc_column
             ,dqc_column_alias
             ,dqc_datatype
             ,dqc_data_len
             )
      VALUES (l_rec_dqc.dqc_dq_id
             ,l_rec_dqc.dqc_seq_no
             ,l_rec_dqc.dqc_column
             ,l_rec_dqc.dqc_column_alias
             ,l_rec_dqc.dqc_datatype
             ,l_rec_dqc.dqc_data_len
             );
   END LOOP;
--
END ins_tab_dqc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_dqc(p_dq_id doc_query.dq_id%TYPE) RETURN tab_dqc IS
--
   l_tab_dqc tab_dqc;
--
BEGIN
--
   FOR cs_rec IN (SELECT *
                   FROM  doc_query_cols
                  WHERE  dqc_dq_id = p_dq_id
                  ORDER BY dqc_seq_no
                 )
    LOOP
      l_tab_dqc(l_tab_dqc.COUNT+1) := cs_rec;
   END LOOP;
--
   RETURN l_tab_dqc;
--
END get_tab_dqc;
--
-----------------------------------------------------------------------------
--
PROCEDURE save_tab_varchar (p_tab_vc            nm3type.tab_varchar32767
                           ,p_window_title      VARCHAR2
                           ,p_calling_pack_proc VARCHAR2 DEFAULT NULL
                           ) IS
BEGIN
--
   htp.htmlopen;
   htp.headopen;
   htp.p ('<!--');
   htp.p ('Parameters as passed - ');
   htp.p ('p_tab_vc.COUNT      : '||p_tab_vc.COUNT);
   htp.p ('p_window_title      : '||p_window_title);
   htp.p ('p_calling_pack_proc : '||p_calling_pack_proc);
   htp.p ('-->');
   htp.title (p_window_title);
--
   IF p_calling_pack_proc IS NULL
    THEN -- if we don't know the referring package then make the "save" button available
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('function save_and_close()');
      htp.p('   {');
      htp.p('   document.execCommand("SaveAs",false,"'||p_window_title||'.html");');
      htp.p('   self.close();');
      htp.p('   }');
      htp.p('</SCRIPT>');
   END IF;
--
   htp.headclose;
   htp.bodyopen;
--
   IF p_calling_pack_proc IS NULL
    THEN -- if we don't know the referring package then make the "save" button available
      htp.p('<FORM>');
      htp.p('<input type=button onClick="save_and_close()" value="Save and Close">');
      htp.p('</FORM>');
   END IF;
--
   nm3web.htp_tab_varchar(p_tab_vc);
--
   IF p_calling_pack_proc IS NOT NULL
    THEN -- we know what to search the "referrer" for, so check for that, and if there save and close
      htp.p('<SCRIPT LANGUAGE="JavaScript">');
      htp.p('   var temp = document.referrer;');
      htp.p('   if (temp != '||nm3flx.string(Null)||')');
      htp.p('      {');
      htp.p('      if (temp.replace(temp,"'||p_calling_pack_proc||'","'||nm3type.c_nvl||'") != temp)');
      htp.p('         {');
      htp.p('         document.execCommand("SaveAs",false,"'||p_window_title||'.html");');
      htp.p('         self.close();');
      htp.p('         }');
      htp.p('      }');
      htp.p('</SCRIPT>');
   END IF;
--
   htp.bodyclose;
   htp.htmlclose;
--
END save_tab_varchar;
--
-----------------------------------------------------------------------------
--
PROCEDURE replace_substring_js_func IS
BEGIN
   htp.p('function replaceSubstring(inputString, fromString, toString) {');
   htp.p('   // Goes through the inputString and replaces every occurrence of fromString with toString');
   htp.p('   var temp = inputString;');
   htp.p('   if (fromString == "") {');
   htp.p('      return inputString;');
   htp.p('   }');
   htp.p('   if (toString.indexOf(fromString) == -1) { // If the string being replaced is not a part of the replacement string (normal situation)');
   htp.p('      while (temp.indexOf(fromString) != -1) {');
   htp.p('         var toTheLeft = temp.substring(0, temp.indexOf(fromString));');
   htp.p('         var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);');
   htp.p('         temp = toTheLeft + toString + toTheRight;');
   htp.p('      }');
   htp.p('   } else { // String being replaced is part of replacement string (like "+" being replaced with "++") - prevent an infinite loop');
   htp.p('      var midStrings = new Array("~", "`", "_", "^", "#");');
   htp.p('      var midStringLen = 1;');
   htp.p('      var midString = "";');
   htp.p('      // Find a string that doesnt exist in the inputString to be used');
   htp.p('      // as an "inbetween" string');
   htp.p('      while (midString == "") {');
   htp.p('         for (var i=0; i < midStrings.length; i++) {');
   htp.p('            var tempMidString = "";');
   htp.p('            for (var j=0; j < midStringLen; j++) { tempMidString += midStrings[i]; }');
   htp.p('            if (fromString.indexOf(tempMidString) == -1) {');
   htp.p('               midString = tempMidString;');
   htp.p('               i = midStrings.length + 1;');
   htp.p('            }');
   htp.p('         }');
   htp.p('      } // Keep on going until we build an "inbetween" string that doesnt exist');
   htp.p('      // Now go through and do two replaces - first, replace the "fromString" with the "inbetween" string');
   htp.p('      while (temp.indexOf(fromString) != -1) {');
   htp.p('         var toTheLeft = temp.substring(0, temp.indexOf(fromString));');
   htp.p('         var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);');
   htp.p('         temp = toTheLeft + midString + toTheRight;');
   htp.p('      }');
   htp.p('      // Next, replace the "inbetween" string with the "toString"');
   htp.p('      while (temp.indexOf(midString) != -1) {');
   htp.p('         var toTheLeft = temp.substring(0, temp.indexOf(midString));');
   htp.p('         var toTheRight = temp.substring(temp.indexOf(midString)+midString.length, temp.length);');
   htp.p('         temp = toTheLeft + toString + toTheRight;');
   htp.p('      }');
   htp.p('   } // Ends the check to see if the string being replaced is part of the replacement string or not');
   htp.p('   return temp; // Send the updated string back to the user');
   htp.p('} // Ends the "replaceSubstring" function');
END replace_substring_js_func;
--
-----------------------------------------------------------------------------
--
PROCEDURE main_js_for_dump_table (p_tab_vc nm3type.tab_varchar32767) IS
BEGIN
   htp.p('<script type="text/javascript">');
   htp.p('// <!--');
   htp.p('var retrieved_data=new Array('||p_tab_vc.COUNT||')');
   htp.p('var i = 0;');
   htp.p('//');
   htp.p('function initialise_form()');
   htp.p('   {');
   FOR i IN 1..p_tab_vc.COUNT
    LOOP
      htp.p('   retrieved_data['||(i-1)||'] = "'||nm3web.replace_chevrons(REPLACE(p_tab_vc(i),'"',CHR(38)||'#34;'))||'";');
   END LOOP;
   htp.p('   }');
   htp.p('//');
   replace_substring_js_func;
   htp.p('//');
   htp.p('function replaceChevronEscape(inputString) {');
   htp.p('   var temp = inputString;');
   htp.p('   temp = replaceSubstring(temp,"'||CHR(38)||'#34;",'||nm3flx.string('"')||');');
   htp.p('   temp = replaceSubstring(temp,"'||CHR(38)||'#60;","<");');
   htp.p('   temp = replaceSubstring(temp,"'||CHR(38)||'#62;",">");');
   htp.p('   return temp;');
   htp.p('}');
   htp.p('//');
   htp.p('function write_retrieved()');
   htp.p('   {');
   htp.p('   document.open ();');
   htp.p('   for (i=0;i<retrieved_data.length;i++)');
   htp.p('      {');
   htp.p('      document.write (replaceChevronEscape(retrieved_data[i]))');
   htp.p('      }');
   htp.p('   document.close ();');
   htp.p('   }');
   htp.p('//');
   htp.p('function write_hidden_params()');
   htp.p('   {');
   htp.p('   document.open ();');
   htp.p('   for (i=0;i<retrieved_data.length;i++)');
   htp.p('      {');
   htp.p('      var temp = '||nm3flx.string('<INPUT TYPE=HIDDEN NAME="p_tab_vc" VALUE="')||' + (retrieved_data[i]) + '||nm3flx.string('">'));
   htp.p('      document.write (temp)');
   htp.p('      }');
   htp.p('   document.close ();');
   htp.p('   }');
   htp.p('//');
   htp.p('//-->');
   htp.p('</script>');
END main_js_for_dump_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_save_button_and_params (p_window_title      VARCHAR2
                                    ,p_calling_pack_proc VARCHAR2
                                    ) IS
BEGIN
   htp.formopen(g_package_name||'.save_tab_varchar',cattributes=>'TARGET="_blank"');
   htp.formhidden('p_window_title',p_window_title);
   htp.formhidden('p_calling_pack_proc',p_calling_pack_proc);
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('   initialise_form();');
   htp.p('   write_hidden_params();');
   htp.p('</SCRIPT>');
   htp.formsubmit (cvalue => 'Save');
   htp.p('</FORM>');
END do_save_button_and_params;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_retrieved_js IS
BEGIN
   htp.p('<TD>');
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('   write_retrieved();');
   htp.p('</SCRIPT>');
   htp.p('</TD>');
END write_retrieved_js;
--
-----------------------------------------------------------------------------
--
END dm3query;
/
