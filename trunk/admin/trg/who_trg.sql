--
-- This script creates all of the table_name_who triggers
--
set serveroutput on size 100000
--
DECLARE
--
   TYPE tab_comments IS TABLE of VARCHAR2(100) INDEX BY BINARY_INTEGER;
   l_tab_comments tab_comments;
--
   CURSOR cs_cols (p_table_name VARCHAR2, p_type VARCHAR2) IS
   SELECT column_name
         ,DECODE(data_type
                ,'DATE','sysdate'
                ,'VARCHAR2','user'
                ,'null'
                ) new_value
     from user_tab_columns
   where  table_name = p_table_name
    AND  (column_name    like '%'||p_type||'_BY'
          or column_name like '%DATE_'||p_type);
--
   l_trigger_name VARCHAR2(30);
--
   l_sql VARCHAR2(32767);
--
BEGIN
--
--  Stick the SCCS delta comments all into an array so that we can output this
--   as a comment within the trigger itself
   l_tab_comments(1)  := '--';
   l_tab_comments(2)  := '--   SCCS Identifiers :-';
   l_tab_comments(3)  := '--';
   l_tab_comments(4)  := '--       sccsid           : @(#)who_trg.sql	1.4 09/16/02';
   l_tab_comments(5)  := '--       Module Name      : who_trg.sql';
   l_tab_comments(6)  := '--       Date into SCCS   : 02/09/16 10:32:58';
   l_tab_comments(7)  := '--       Date fetched Out : 07/06/13 17:03:54';
   l_tab_comments(8)  := '--       SCCS Version     : 1.4';
   l_tab_comments(9)  := '--';
   l_tab_comments(10) := '--   table_name_WHO trigger';
   l_tab_comments(11) := '--';
   l_tab_comments(12) := '-----------------------------------------------------------------------------';
   l_tab_comments(13) := '--	Copyright (c) exor corporation ltd, 2001';
   l_tab_comments(14) := '-----------------------------------------------------------------------------';
   l_tab_comments(15) := '--';
--
   dbms_output.put_line('Started WHO trigger creation');
--
   FOR cs_rec IN (SELECT utc.table_name
                        ,max(length(utc.column_name)) max_col_name_length
                   FROM  user_tab_columns utc
                        ,user_objects     ut
                  where  utc.table_name  = ut.object_name
                    AND  ut.object_type  = 'TABLE'
                    AND  ut.temporary    = 'N'
                    AND (utc.column_name    like '%CREATED_BY'
                         or utc.column_name like '%MODIFIED_BY'
                         or utc.column_name like '%DATE_CREATED'
                         or utc.column_name like '%DATE_MODIFIED'
                        )
                  GROUP BY utc.TABLE_NAME
                  HAVING COUNT(*) = 4
                 )
    LOOP
--
      l_trigger_name := LOWER(SUBSTR(cs_rec.table_name,1,26)||'_who');
--
      l_sql := 'CREATE OR REPLACE TRIGGER '||l_trigger_name;
      l_sql := l_sql||CHR(10)||' BEFORE insert OR update';
      l_sql := l_sql||CHR(10)||' ON '||cs_rec.table_name;
      l_sql := l_sql||CHR(10)||' FOR each row';
      l_sql := l_sql||CHR(10)||'DECLARE';
      --
      FOR l_count IN 1..l_tab_comments.COUNT
       LOOP
         l_sql := l_sql||CHR(10)||l_tab_comments(l_count);
      END LOOP;
      --
      l_sql := l_sql||CHR(10)||'   l_sysdate DATE;';
      l_sql := l_sql||CHR(10)||'   l_user    VARCHAR2(30);';
      l_sql := l_sql||CHR(10)||'BEGIN';
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'-- Generated '||to_char(sysdate,'HH24:MI:SS DD-MON-YYYY');
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'   SELECT sysdate';
      l_sql := l_sql||CHR(10)||'         ,user';
      l_sql := l_sql||CHR(10)||'    INTO  l_sysdate';
      l_sql := l_sql||CHR(10)||'         ,l_user';
      l_sql := l_sql||CHR(10)||'    FROM  dual;';
      l_sql := l_sql||CHR(10)||'--';
      l_sql := l_sql||CHR(10)||'   IF inserting';
      l_sql := l_sql||CHR(10)||'    THEN';
--
      FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'CREATED')
       LOOP
         l_sql := l_sql||CHR(10)||'      :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
      END LOOP;
--
      l_sql := l_sql||CHR(10)||'   END IF;';
      l_sql := l_sql||CHR(10)||'--';
--
      FOR cs_inner_rec IN cs_cols(cs_rec.table_name,'MODIFIED')
       LOOP
         l_sql := l_sql||CHR(10)||'   :new.'||RPAD(cs_inner_rec.column_name,cs_rec.max_col_name_length,' ')||' := l_'||cs_inner_rec.new_value||';';
      END LOOP;
--
      l_sql := l_sql||CHR(10)||'--';
--
      l_sql := l_sql||CHR(10)||'END '||l_trigger_name||';';
--
      execute immediate l_sql;
--
      l_sql := 'ALTER TRIGGER '||l_trigger_name||' COMPILE';
--
      execute immediate l_sql;
--
      dbms_output.put_line('Created trigger '||l_trigger_name);
--
   END LOOP;
--
   dbms_output.put_line('Finished WHO trigger creation');
--
END;
/
