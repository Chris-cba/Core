CREATE OR REPLACE PACKAGE BODY nm_debug AS
THIS IS NOT BRANCHED
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/andy.pkb-arc   2.1   Jul 04 2013 14:27:32   James.Wadsworth  $
--       Module Name      : $Workfile:   andy.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 14:27:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:06  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on SCCS Version     : 1.7
--
--
--   Author : Jonathan Mills
--
--   Debug Package body
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
   g_debug_mode_on  boolean := FALSE;
   g_debug_level    number  := c_default_level;
--
   g_session_id CONSTANT number       := NVL(USERENV('SESSIONID'),-1);
   g_terminal   CONSTANT varchar2(30) := NVL(USERENV('TERMINAL'),'Unknown');
--
   c_chunk   CONSTANT number := 3500;
--
   TYPE rec_callstack IS RECORD
      (package_name   user_arguments.package_name%TYPE
      ,procedure_name user_arguments.object_name%TYPE
      ,client_info    v$session.client_info%TYPE
      );
   TYPE tab_rec_callstack IS TABLE OF rec_callstack INDEX BY binary_integer;
--
   g_tab_rec_callstack tab_rec_callstack;
   g_maintain_callstack boolean := TRUE;
--
   TYPE tab_varchar30 IS TABLE OF varchar2(30) INDEX BY binary_integer;
--
   l_tab_userenv_reqd tab_varchar30;
--
   c_procedure_level CONSTANT number := 4;
--
-----------------------------------------------------------------------------
--
FUNCTION get_rec_callstack (p_package_name   IN varchar2
                           ,p_procedure_name IN varchar2
                           ) RETURN rec_callstack IS
--
   l_rec_callstack rec_callstack;
--
BEGIN
--
   l_rec_callstack.package_name   := SUBSTR(UPPER(p_package_name  ),1,30);
   l_rec_callstack.procedure_name := SUBSTR(UPPER(p_procedure_name),1,30);
--
   IF l_rec_callstack.package_name IS NOT NULL
    THEN
      l_rec_callstack.client_info := p_package_name||'.';
   END IF;
   l_rec_callstack.client_info := UPPER(SUBSTR(l_rec_callstack.client_info||p_procedure_name,1,64));
--
   RETURN l_rec_callstack;
--
END get_rec_callstack;
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
PROCEDURE debug_on IS
--
   l_text_line nm_dbug.nd_text%TYPE;
--
BEGIN
--
   g_debug_mode_on := TRUE;
--
   l_text_line := '### Debugging started ';
--
   debug(l_text_line ,0);
--
END debug_on;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_off IS
BEGIN
   debug('### Debugging stopped',0);
   g_debug_mode_on := FALSE;
END debug_off;
--
-----------------------------------------------------------------------------
--
FUNCTION is_debug_on RETURN boolean IS
BEGIN
   RETURN g_debug_mode_on;
END is_debug_on;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_level (p_level number) IS
BEGIN
   g_debug_level := p_level;
END set_level;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug (p_text  IN varchar2
                ,p_level IN number  DEFAULT NULL
                ) IS
--
   ----------------------------------------------------------------------
   --autonomous transactions removed as they cannot be used with DB links
   --until v9.0.2. A separate package body is maintained with automonous
   --transactions in the file nm_debug_autonomous.pkb.
   ----------------------------------------------------------------------
   --PRAGMA autonomous_transaction;
--
   l_vc               varchar2(32767);
   l_count            number := 1;
   c_txt_len CONSTANT number := LENGTH(p_text);
--
   c_level   CONSTANT number := NVL(p_level,c_default_level);
--
BEGIN
--
   IF   g_debug_mode_on
    AND c_level <= g_debug_level
    THEN
--
      IF c_txt_len > c_chunk
       THEN
         WHILE l_count <= c_txt_len
          LOOP
            l_vc    := SUBSTR(p_text,l_count,c_chunk);
            l_count := l_count + c_chunk;
            debug(l_vc, c_level);
         END LOOP;
      ELSE
         INSERT INTO nm_dbug
                (nd_id
                ,nd_terminal
                ,nd_session_id
                ,nd_level
                ,nd_text
                )
         VALUES (get_next_nd_id_seq
                ,g_terminal
                ,g_session_id
                ,c_level
                ,p_text
                );
      END IF;
--
   END IF;
--
   --COMMIT;
--
END debug;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_debug (p_remove_all IN boolean DEFAULT FALSE) IS
--
   ----------------------------------------------------------------------
   --autonomous transactions removed as they cannot be used with DB links
   --until v9.0.2. A separate package body is maintained with automonous
   --transactions in the file nm_debug_autonomous.pkb.
   ----------------------------------------------------------------------
   --PRAGMA autonomous_transaction;
--
BEGIN
--
   IF p_remove_all
    THEN
      DELETE nm_dbug
       WHERE nd_terminal   = g_terminal;
   ELSE
      DELETE nm_dbug
       WHERE nd_session_id = g_session_id;
   END IF;
--
   --COMMIT;
--
END delete_debug;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nd_id_seq RETURN number IS
--
   CURSOR cs_nextval IS
   SELECT nd_id_seq.NEXTVAL
    FROM  dual;
--
   l_retval binary_integer;
--
BEGIN
--
   OPEN  cs_nextval;
   FETCH cs_nextval INTO l_retval;
   CLOSE cs_nextval;
--
   RETURN l_retval;
--
END get_next_nd_id_seq;
--
-----------------------------------------------------------------------------
--
PROCEDURE proc_start (p_package_name   IN varchar2
                     ,p_procedure_name IN varchar2
                     ) IS
--
   l_rec_callstack rec_callstack := get_rec_callstack (p_package_name,p_procedure_name);
--
BEGIN
--
   add_to_callstack(l_rec_callstack.client_info);
--
   debug ('Entering '||l_rec_callstack.client_info,c_procedure_level);
--
END proc_start;
--
-----------------------------------------------------------------------------
--
PROCEDURE proc_end (p_package_name   IN varchar2
                   ,p_procedure_name IN varchar2
                   ) IS
--
   l_rec_callstack rec_callstack := get_rec_callstack (p_package_name,p_procedure_name);
--
BEGIN
--
   debug ('Leaving  '||l_rec_callstack.client_info,c_procedure_level);
--
   delete_from_callstack (l_rec_callstack.client_info);
--
END proc_end;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_sql_string (p_sql varchar2) IS
--
   l_tab          nm3type.tab_varchar30;
   l_block        varchar2(32767);
   l_max_col      pls_integer := 0;
--
BEGIN
--
   nm_debug.debug(p_sql);
--
   l_tab := nm3flx.get_cols_from_sql(p_sql);
--
   FOR i IN 1..l_tab.COUNT
    LOOP
      IF l_max_col < LENGTH(l_tab(i))
       THEN
         l_max_col := LENGTH(l_tab(i));
      END IF;
   END LOOP;
   l_max_col := l_max_col + 1;
--
   l_block :=            'DECLARE'
              ||CHR(10)||'   CURSOR c1 IS'
              ||CHR(10)||'   '||p_sql||';'
              ||CHR(10)||'   l_rc PLS_INTEGER := 0;'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||'   FOR cs_rec IN c1'
              ||CHR(10)||'    LOOP'
              ||CHR(10)||'      l_rc := l_rc + 1;'
              ||CHR(10)||'      nm_debug.debug('||nm3flx.string('Row ')||'||l_rc);';
--
   FOR i IN 1..l_tab.COUNT
    LOOP
      l_block := l_block
              ||CHR(10)||'      nm_debug.debug('||nm3flx.string(l_tab(i))||'||RPAD('||nm3flx.string(' ')||','||l_max_col||'-LENGTH('||nm3flx.string(l_tab(i))||'),'||nm3flx.string(' ')||')||'||nm3flx.string(': ')||'||cs_rec.'||l_tab(i)||');';
   END LOOP;
--
   l_block := l_block
              ||CHR(10)||'   END LOOP;'
              ||CHR(10)||'END;';
--
   EXECUTE IMMEDIATE l_block;
--
EXCEPTION
--
   WHEN others
    THEN
      nm_debug.debug('Dont like that string');
--
END debug_sql_string;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_clob (p_clob clob
                     ,p_level IN number  DEFAULT NULL
                     ) IS
--
   l_varchar            nm_dbug.nd_text%TYPE;
   l_offset             binary_integer := 1;
   c_clob_len  CONSTANT binary_integer := dbms_lob.getlength(p_clob);
--
BEGIN
--
   WHILE l_offset <= c_clob_len
    LOOP
--
      l_varchar   := dbms_lob.SUBSTR(p_clob,c_chunk,l_offset);
      l_offset    := l_offset + c_chunk;
--
      debug(l_varchar,p_level);
--
   END LOOP;
--
END debug_clob;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_call_stack (p_level IN number DEFAULT NULL) IS
BEGIN
   debug('Call stack - '||g_tab_rec_callstack.COUNT||' entries',p_level);
   FOR i IN 1..g_tab_rec_callstack.COUNT
    LOOP
      debug(i||'. '||g_tab_rec_callstack(i).client_info,p_level);
   END LOOP;
END dump_call_stack;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_level RETURN number IS
BEGIN
   RETURN c_default_level;
END get_default_level;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_callstack (p_client_info varchar2) IS
--
   l_rec_callstack rec_callstack;
--
   l_curr_count CONSTANT binary_integer := g_tab_rec_callstack.COUNT;
--
BEGIN
--
   IF NOT g_maintain_callstack
    THEN
      RETURN;
   END IF;
--
   IF l_curr_count > 0
    THEN
      l_rec_callstack.package_name   := g_tab_rec_callstack(l_curr_count).package_name;
      l_rec_callstack.procedure_name := g_tab_rec_callstack(l_curr_count).procedure_name;
   END IF;
   l_rec_callstack.client_info := UPPER(SUBSTR(p_client_info,1,64));
--
   dbms_application_info.set_client_info(l_rec_callstack.client_info);
   g_tab_rec_callstack(l_curr_count+1) := l_rec_callstack;
--
END add_to_callstack;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_from_callstack (p_client_info varchar2) IS
--
   l_rec_callstack rec_callstack;
--
   l_arr_pos binary_integer := g_tab_rec_callstack.last;
--
   c_current_client_info v$session.client_info%TYPE;
--
   l_found_it boolean := FALSE;
--
   l_client_info v$session.client_info%TYPE;
--
BEGIN
--
   IF NOT g_maintain_callstack
    THEN
      RETURN;
   END IF;
--
   l_rec_callstack.client_info := UPPER(SUBSTR(p_client_info,1,64));
--
   WHILE l_arr_pos IS NOT NULL
    LOOP
      IF l_rec_callstack.client_info = g_tab_rec_callstack(l_arr_pos).client_info
       THEN
         l_found_it := TRUE;
         EXIT;
      END IF;
      l_arr_pos := g_tab_rec_callstack.PRIOR(l_arr_pos);
   END LOOP;
--
   IF l_found_it
    THEN
      FOR i IN l_arr_pos..g_tab_rec_callstack.last
       LOOP
         g_tab_rec_callstack.DELETE(i);
      END LOOP;
      IF g_tab_rec_callstack.COUNT = 0
       THEN
         l_client_info := NULL;
      ELSE
         l_client_info := g_tab_rec_callstack(g_tab_rec_callstack.last).client_info;
      END IF;
      dbms_application_info.set_client_info(l_client_info);
   END IF;
--
   IF g_tab_rec_callstack.COUNT = 0
    THEN
      dbms_application_info.set_client_info(NULL);
   END IF;
--
END delete_from_callstack;
--
-----------------------------------------------------------------------------
--
PROCEDURE truncate_callstack IS
BEGIN
   g_tab_rec_callstack.DELETE;
END truncate_callstack;
--
-----------------------------------------------------------------------------
--
END nm_debug;
/
