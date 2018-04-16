CREATE OR REPLACE PACKAGE BODY nm_debug AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_debug.pkb	1.18 02/07/07
--       Module Name      : nm_debug.pkb
--       Date into SCCS   : 07/02/07 10:26:32
--       Date fetched Out : 07/06/13 14:10:43
--       SCCS Version     : 1.18
--
--
--   Author : Jonathan Mills
--
--   Debug Package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm_debug.pkb	1.18 02/07/07"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_debug_mode_on              BOOLEAN                     := FALSE;
   g_debug_level                PLS_INTEGER                 := c_default_level;
--
   g_session_id        CONSTANT NUMBER                      := NVL(USERENV('SESSIONID'),-1);
   g_terminal          CONSTANT nm_dbug.nd_terminal%TYPE    := NVL(SYS_CONTEXT ('USERENV', 'HOST'),'Unknown');
   c_sysopt_name_auton CONSTANT hig_option_list.hol_id%TYPE := 'DEBUGAUTON';
--
   c_procedure_level   CONSTANT NUMBER                      := 4;
   g_autonomous                 BOOLEAN;
--
   c_chunk             CONSTANT PLS_INTEGER                 := 3500;
--
   TYPE rec_callstack IS RECORD
      (package_name   user_arguments.package_name%TYPE
      ,procedure_name user_arguments.object_name%TYPE
      ,client_info    v$session.client_info%TYPE
      );
   TYPE tab_rec_callstack IS TABLE OF rec_callstack INDEX BY binary_integer;
--
   g_tab_rec_callstack          tab_rec_callstack;
   g_maintain_callstack         BOOLEAN                     := TRUE;
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
PROCEDURE local_debug (p_text  IN varchar2
                      ,p_level IN number  DEFAULT NULL
                      ) IS
--
   l_vc               nm3type.max_varchar2;
   l_count            PLS_INTEGER := 1;
   c_txt_len CONSTANT PLS_INTEGER := LENGTH(p_text);
   c_level   CONSTANT PLS_INTEGER := NVL(p_level,c_default_level);
--
BEGIN
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
END local_debug;
--
-----------------------------------------------------------------------------
--
PROCEDURE local_debug_autonomous (p_text  IN varchar2
                                 ,p_level IN number  DEFAULT NULL
                                 ) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   local_debug (p_text
               ,p_level
               );
   COMMIT;
END local_debug_autonomous;
--
-----------------------------------------------------------------------------
--
PROCEDURE local_del (p_remove_all IN BOOLEAN DEFAULT FALSE) IS
BEGIN
   IF p_remove_all
    THEN
      DELETE nm_dbug
       WHERE nd_terminal   = g_terminal;
   ELSE
      DELETE nm_dbug
       WHERE nd_session_id = g_session_id;
   END IF;
END local_del;
--
-----------------------------------------------------------------------------
--
PROCEDURE local_del_autonomous (p_remove_all IN BOOLEAN DEFAULT FALSE) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   local_del (p_remove_all);
   COMMIT;
END local_del_autonomous;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_autonomous IS
BEGIN
   g_autonomous := hig.get_sysopt(c_sysopt_name_auton)='Y';
END check_autonomous;
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
BEGIN

 g_debug_mode_on := FALSE; -- GJ default it to off

 IF NVL(hig.get_user_or_sys_opt(pi_option => 'ALLOWDEBUG'),'N') = 'Y' THEN -- GJ only switch it on if new product option is set
   g_debug_mode_on := TRUE;
   check_autonomous;
   debug('### Debugging started' ,0);
 END IF;   
 
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
BEGIN
--
   IF g_autonomous
    THEN
      local_debug_autonomous (p_text, p_level);
   ELSE
      local_debug (p_text, p_level);
   END IF;
--
END debug;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_debug (p_remove_all IN boolean DEFAULT FALSE) IS
--
BEGIN
--
   IF g_autonomous
    THEN
      local_del_autonomous (p_remove_all);
   ELSE
      local_del (p_remove_all);
   END IF;
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
   l_retval pls_integer;
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
   l_block        nm3type.max_varchar2;
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
   l_rec_callstack       rec_callstack;
   l_arr_pos             PLS_INTEGER := g_tab_rec_callstack.last;
   c_current_client_info v$session.client_info%TYPE;
   l_found_it            BOOLEAN     := FALSE;
   l_client_info         v$session.client_info%TYPE;
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
BEGIN
   check_autonomous;
END nm_debug;
/
