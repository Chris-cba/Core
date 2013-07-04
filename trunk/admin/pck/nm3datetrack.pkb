CREATE OR REPLACE PACKAGE BODY nm3datetrack AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3datetrack.pkb	1.2 10/23/03
--       Module Name      : nm3datetrack.pkb
--       Date into SCCS   : 03/10/23 11:30:30
--       Date fetched Out : 07/06/13 14:11:13
--       SCCS Version     : 1.2
--
--
--   Author : Jonathan Mills
--
--   Datetrack triggers package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3datetrack.pkb	1.2 10/23/03"';
--  g_body_sccsid is the SCCS ID for the package body
--
--all global package variables here
--
   TYPE tab_edt IS TABLE OF exor_datetracked_tables%ROWTYPE INDEX BY binary_integer;
   TYPE tab_edp IS TABLE OF exor_datetrack_parents%ROWTYPE INDEX BY binary_integer;
   TYPE tab_edc IS TABLE OF exor_datetrack_children%ROWTYPE INDEX BY binary_integer;
   TYPE tab_varchar30 IS TABLE OF varchar2(30) INDEX BY binary_integer;
--
   g_tab_tables tab_varchar30;
   g_tab_edt    tab_edt;
   g_tab_edp    tab_edp;
   g_tab_edc    tab_edc;
--
   c_start_date  CONSTANT varchar2(10) := 'START_DATE';
   c_end_date    CONSTANT varchar2(10) := 'END_DATE';
--
   c_all CONSTANT varchar2(4) := '_ALL';
--
   g_datetrack_exc_code  number    := -20001;
   g_datetrack_exc_msg   long      := 'Unspecified error within nm3datetrack';
   g_datetrack_exception EXCEPTION;
--
   g_trigger_sql         long;
--
   CURSOR cs_edt IS
   SELECT *
    FROM  exor_datetracked_tables
   FOR UPDATE OF edt_trigger_sql;
   
   CURSOR cs_edt2 IS
   SELECT *
    FROM  exor_datetracked_tables;
--
   CURSOR cs_tables IS
   SELECT table_name
    FROM  user_tables
   WHERE  table_name IN (SELECT table_name
                          FROM  user_tab_columns
                         WHERE  nm3flx.RIGHT(column_name,LENGTH(c_start_date)) = c_start_date
                        )
    AND   table_name IN (SELECT table_name
                          FROM  user_tab_columns
                         WHERE  nm3flx.RIGHT(column_name,LENGTH(c_end_date))   = c_end_date
                        )
    AND   table_name NOT IN (SELECT ede_table_name
                              FROM  exor_datetrack_exclusions
                            );
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_individual_table (pi_table_name IN varchar2);
--
-----------------------------------------------------------------------------
--
FUNCTION check_table_is_datetracked (pi_table_name IN varchar2) RETURN boolean;
--
-----------------------------------------------------------------------------
--
FUNCTION get_col_name_from_substring (pi_table_name    IN varchar2
                                     ,pi_col_substring IN varchar2
                                     ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_individual_trigger (p_rec_edt IN OUT exor_datetracked_tables%ROWTYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE append (pi_text    IN varchar2
                 ,pi_newline IN boolean DEFAULT TRUE
                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE comment_block;
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
PROCEDURE populate_table IS
--
   l_tab_tables_to_trunc tab_varchar30;
--
BEGIN
--
   l_tab_tables_to_trunc(1) := 'EXOR_DATETRACKED_TABLES';
   l_tab_tables_to_trunc(2) := 'EXOR_DATETRACK_PARENTS';
   l_tab_tables_to_trunc(3) := 'EXOR_DATETRACK_CHILDREN';
--
   FOR l_count IN 1..l_tab_tables_to_trunc.COUNT
    LOOP
      EXECUTE IMMEDIATE 'TRUNCATE TABLE '||l_tab_tables_to_trunc(l_count);
   END LOOP;
--
   g_tab_edt.DELETE;
   g_tab_edp.DELETE;
   g_tab_edc.DELETE;
--
   OPEN  cs_tables;
   FETCH cs_tables BULK COLLECT INTO g_tab_tables;
   CLOSE cs_tables;
--
   FOR l_count IN 1..g_tab_tables.COUNT
    LOOP
      populate_individual_table (g_tab_tables(l_count));
   END LOOP;
--
   FOR l_count IN 1..g_tab_edt.COUNT
    LOOP
      INSERT INTO exor_datetracked_tables
             (edt_table_name
             ,edt_start_date_col
             ,edt_end_date_col
             ,edt_trigger_name
             )
      VALUES (g_tab_edt(l_count).edt_table_name
             ,g_tab_edt(l_count).edt_start_date_col
             ,g_tab_edt(l_count).edt_end_date_col
             ,g_tab_edt(l_count).edt_trigger_name
             );
   END LOOP;
--
   FOR l_count IN 1..g_tab_edp.COUNT
    LOOP
      INSERT INTO exor_datetrack_parents
             (edp_table_name
             ,edp_parent_table_name
             ,edp_constraint_name
             ,edp_r_constraint_name
             ,edp_r_start_date_col
             ,edp_r_end_date_col
             ,edp_seq_no
             )
      VALUES (g_tab_edp(l_count).edp_table_name
             ,g_tab_edp(l_count).edp_parent_table_name
             ,g_tab_edp(l_count).edp_constraint_name
             ,g_tab_edp(l_count).edp_r_constraint_name
             ,g_tab_edp(l_count).edp_r_start_date_col
             ,g_tab_edp(l_count).edp_r_end_date_col
             ,l_count
             );
   END LOOP;
--
   FOR l_count IN 1..g_tab_edc.COUNT
    LOOP
      INSERT INTO exor_datetrack_children
             (edc_table_name
             ,edc_child_table_name
             ,edc_constraint_name
             ,edc_r_constraint_name
             ,edc_r_start_date_col
             ,edc_r_end_date_col
             ,edc_seq_no
             )
      VALUES (g_tab_edc(l_count).edc_table_name
             ,g_tab_edc(l_count).edc_child_table_name
             ,g_tab_edc(l_count).edc_constraint_name
             ,g_tab_edc(l_count).edc_r_constraint_name
             ,g_tab_edc(l_count).edc_r_start_date_col
             ,g_tab_edc(l_count).edc_r_end_date_col
             ,l_count
             );
   END LOOP;
--
   COMMIT;
--
EXCEPTION
--
   WHEN g_datetrack_exception
    THEN
      RAISE_APPLICATION_ERROR(g_datetrack_exc_code,g_datetrack_exc_msg);
--
END populate_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_individual_table (pi_table_name IN varchar2) IS
--
   l_been_in_loop boolean := FALSE;
   l_rec_edt exor_datetracked_tables%ROWTYPE;
--
BEGIN
--
   l_rec_edt.edt_table_name      := pi_table_name;
   l_rec_edt.edt_start_date_col  := get_col_name_from_substring (pi_table_name, c_start_date);
   l_rec_edt.edt_end_date_col    := get_col_name_from_substring (pi_table_name, c_end_date);
   l_rec_edt.edt_trigger_name    := SUBSTR(pi_table_name,1,23)||'_DT_TRG';
   -- Add the record into the global array
   g_tab_edt(g_tab_edt.COUNT+1)  := l_rec_edt;
--
   FOR cs_rec IN (SELECT *
                   FROM  user_constraints
                  WHERE  table_name      = pi_table_name
                   AND   constraint_type = 'R'
                 )
    LOOP
      DECLARE
--
         l_rec_edp exor_datetrack_parents%ROWTYPE;
--
         l_rec_uc  user_constraints%ROWTYPE;
--
         CURSOR cs_get_uc (c_constraint_name varchar2) IS
         SELECT *
          FROM  user_constraints
         WHERE  constraint_name = c_constraint_name;
--
      BEGIN
--
         OPEN  cs_get_uc (cs_rec.r_constraint_name);
         FETCH cs_get_uc INTO l_rec_uc;
         CLOSE cs_get_uc;
--
         l_rec_edp.edp_table_name        := pi_table_name;
         l_rec_edp.edp_parent_table_name := l_rec_uc.table_name;
         l_rec_edp.edp_constraint_name   := cs_rec.constraint_name;
         l_rec_edp.edp_r_constraint_name := cs_rec.r_constraint_name;
         l_rec_edp.edp_r_start_date_col  := get_col_name_from_substring (l_rec_uc.table_name, c_start_date);
         l_rec_edp.edp_r_end_date_col    := get_col_name_from_substring (l_rec_uc.table_name, c_end_date);
--
         IF   l_rec_edp.edp_r_start_date_col IS NOT NULL
          AND l_rec_edp.edp_r_end_date_col   IS NOT NULL
          THEN
            -- Add the record into the global array if this table is datetracked
            g_tab_edp(g_tab_edp.COUNT+1)    := l_rec_edp;
         END IF;
--
      END;
   END LOOP;
--
   FOR cs_rec IN (SELECT uc2.table_name      child_table_name
                        ,uc2.constraint_name r_constraint_name
                        ,uc1.constraint_name
                   FROM  user_constraints uc1
                        ,user_constraints uc2
                  WHERE  uc1.table_name      = pi_table_name
                   AND   uc1.constraint_name = uc2.r_constraint_name
                   AND   uc2.table_name IN (SELECT table_name
                                             FROM  user_tab_columns
                                            WHERE  nm3flx.RIGHT(column_name,LENGTH(c_start_date)) = c_start_date
                                           )
                   AND   uc2.table_name IN (SELECT table_name
                                             FROM  user_tab_columns
                                            WHERE  nm3flx.RIGHT(column_name,LENGTH(c_end_date)) = c_end_date
                                           )
                 )
    LOOP
      DECLARE
         l_rec_edc exor_datetrack_children%ROWTYPE;
      BEGIN
--
--       Create the child record
         l_rec_edc.edc_table_name        := pi_table_name;
         l_rec_edc.edc_child_table_name  := cs_rec.child_table_name;
         l_rec_edc.edc_constraint_name   := cs_rec.constraint_name;
         l_rec_edc.edc_r_constraint_name := cs_rec.r_constraint_name;
         l_rec_edc.edc_r_start_date_col  := get_col_name_from_substring (cs_rec.child_table_name, c_start_date);
         l_rec_edc.edc_r_end_date_col    := get_col_name_from_substring (cs_rec.child_table_name, c_start_date);
--
         -- Add the record into the global array
         g_tab_edc(g_tab_edc.COUNT+1)    := l_rec_edc;
      END;
   END LOOP;
--
END populate_individual_table;
--
-----------------------------------------------------------------------------
--
FUNCTION check_table_is_datetracked (pi_table_name IN varchar2) RETURN boolean IS
   l_exists boolean := FALSE;
BEGIN
--
   FOR l_count IN 1..g_tab_tables.COUNT
    LOOP
      IF g_tab_tables(l_count) = pi_table_name
       THEN
         l_exists := TRUE;
         EXIT;
      END IF;
   END LOOP;
--
   RETURN l_exists;
--
END check_table_is_datetracked;
--
-----------------------------------------------------------------------------
--
FUNCTION get_col_name_from_substring (pi_table_name    IN varchar2
                                     ,pi_col_substring IN varchar2
                                     ) RETURN varchar2 IS
--
   l_col_name user_tab_columns.column_name%TYPE := NULL;
--
   CURSOR cs_get_col_name (c_table_name varchar2
                          ,c_col_reqd   varchar2
                          ) IS
   SELECT column_name
    FROM  user_tab_columns
   WHERE  table_name = c_table_name
    AND   nm3flx.RIGHT(column_name, LENGTH(c_col_reqd)) = c_col_reqd;
--
BEGIN
--
   OPEN  cs_get_col_name (pi_table_name, pi_col_substring);
   FETCH cs_get_col_name INTO l_col_name;
   CLOSE cs_get_col_name;
--
   RETURN l_col_name;
--
END get_col_name_from_substring;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_all_triggers IS
   l_edt_trigger_status exor_datetracked_tables.edt_trigger_status%TYPE;
BEGIN
   FOR cs_rec IN cs_edt
    LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP TRIGGER '||cs_rec.edt_trigger_name;
         l_edt_trigger_status := 'Dropped OK - '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS');
      EXCEPTION
         WHEN others
          THEN
            l_edt_trigger_status := SQLERRM;
      END;
      UPDATE exor_datetracked_tables
       SET   edt_trigger_status = l_edt_trigger_status
      WHERE CURRENT OF cs_edt;
   END LOOP;
   COMMIT;
END drop_all_triggers;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_all_triggers IS
--
   l_edt_trigger_status exor_datetracked_tables.edt_trigger_status%TYPE;
--
BEGIN
--
   UPDATE exor_datetracked_tables
    SET   edt_trigger_sql = NULL;
   COMMIT;
--
   FOR cs_rec IN cs_edt
    LOOP
      build_individual_trigger (cs_rec);
      UPDATE exor_datetracked_tables
       SET   edt_trigger_sql = cs_rec.edt_trigger_sql
      WHERE CURRENT OF cs_edt;
   END LOOP;
--
   --COMMIT;
--
   FOR cs_rec IN cs_edt2
    LOOP
      DECLARE
         l_trigger_sql varchar2(32767) := cs_rec.edt_trigger_sql;
      BEGIN
         EXECUTE IMMEDIATE l_trigger_sql;
         l_edt_trigger_status := 'Created OK - '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS');
      EXCEPTION
         WHEN others
           THEN
            l_edt_trigger_status := SQLERRM;
      END;
      UPDATE exor_datetracked_tables
       SET   edt_trigger_status = l_edt_trigger_status
      WHERE edt_table_name = cs_rec.edt_table_name;
   END LOOP;
   COMMIT;
--
END build_all_triggers;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_individual_trigger (p_rec_edt IN OUT exor_datetracked_tables%ROWTYPE) IS
--
   CURSOR get_parents (p_table_name varchar2) IS
   SELECT *
    FROM  exor_datetrack_parents
   WHERE  edp_table_name = p_table_name
   ORDER BY edp_seq_no;
--
--
   CURSOR get_children (p_table_name varchar2) IS
   SELECT *
    FROM  exor_datetrack_children
   WHERE  edc_table_name = p_table_name
   ORDER BY edc_seq_no;
--
   CURSOR date_key_col ( cs_table_name varchar2
                        ,cs_start_date varchar2 ) IS
      SELECT a.column_name
      FROM user_cons_columns a
          ,user_constraints b
      WHERE a.constraint_name = b.constraint_name
        AND b.constraint_type = 'P'
       AND a.table_name = cs_table_name
       AND a.column_name LIKE '%'||cs_start_date;

   l_start_date_col varchar2(100);

--
   CURSOR date_key ( c_table_name varchar2 ) IS
      SELECT column_name
      FROM user_cons_columns a
          ,user_constraints b
      WHERE a.table_name = c_table_name
        AND a.constraint_name = b.constraint_name
        AND b.constraint_type = 'P'
      ORDER BY a.position;
--
   FIRST boolean := FALSE;
   date_key_found boolean := FALSE;
BEGIN
--
   g_trigger_sql := 'CREATE OR REPLACE TRIGGER '||p_rec_edt.edt_trigger_name;
   append(' BEFORE INSERT');
   append('  OR UPDATE OF '||p_rec_edt.edt_start_date_col||','||p_rec_edt.edt_end_date_col);
   append(' ON '||p_rec_edt.edt_table_name);
   append(' FOR EACH ROW');
--
   append('DECLARE');
   comment_block;
   append('--');
   append('-- #########################################################');
   append('-- #                                                       #');
   append('-- # DO NOT EDIT - This trigger is generated automatically #');
   append('-- #                                                       #');
   append('-- #            Generated - '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS')||'           #');
   append('-- #                                                       #');
   append('-- #########################################################');
   append('--');
   append('   l_start_date DATE := :NEW.'||p_rec_edt.edt_start_date_col||';');
   append('   l_end_date   DATE := :NEW.'||p_rec_edt.edt_end_date_col||';');
   append('--');
   append('   l_old_start_date DATE := :OLD.'||p_rec_edt.edt_start_date_col||';');
   append('   l_old_end_date   DATE := :OLD.'||p_rec_edt.edt_end_date_col||';');
   append('--');
   append('   l_start_date_out_of_range  EXCEPTION;');
   append('   l_end_date_out_of_range    EXCEPTION;');
   append('   l_cannot_update_start_date EXCEPTION;');
   append('   l_start_date_gt_end_date   EXCEPTION;');
   append('   l_has_children             EXCEPTION;');
   append('--');
--
   FOR cs_rec IN get_parents(p_rec_edt.edt_table_name)
    LOOP
      DECLARE
         l_line_start   varchar2(10) := '   WHERE  ';
      BEGIN
         append('   CURSOR cs_p_'||cs_rec.edp_seq_no||' IS -- '||cs_rec.edp_constraint_name);
         append('   SELECT '||cs_rec.edp_r_start_date_col);
         append('         ,'||cs_rec.edp_r_end_date_col);
         append('    FROM  '||cs_rec.edp_parent_table_name);
         FOR cs_inner_rec IN (SELECT *
                               FROM  user_cons_columns
                              WHERE  constraint_name = cs_rec.edp_r_constraint_name
                             ORDER BY position
                             )
          LOOP
            DECLARE
               CURSOR cs_con_col (p_con_name varchar2
                                 ,p_position number
                                 ) IS
               SELECT column_name
                FROM  user_cons_columns
               WHERE  constraint_name = p_con_name
                AND   position        = p_position;
               l_col_name varchar2(30);
            BEGIN
               OPEN  cs_con_col (cs_rec.edp_constraint_name
                                ,cs_inner_rec.position
                                );
               FETCH cs_con_col INTO l_col_name;
               CLOSE cs_con_col;
               append(l_line_start||cs_inner_rec.column_name||' = :NEW.'||l_col_name);
               l_line_start := '    AND   ';
            END;
         END LOOP;
         append(';',FALSE);
         append('--');
         append('   l_p_'||cs_rec.edp_seq_no||'_start_date DATE;');
         append('   l_p_'||cs_rec.edp_seq_no||'_end_date   DATE;');
         append('--');
      END;
   END LOOP;
--
   FOR cs_rec IN get_children(p_rec_edt.edt_table_name)
    LOOP
      DECLARE
         l_line_start   varchar2(10) := '   WHERE  ';
      BEGIN
         append('   CURSOR cs_c_'||cs_rec.edc_seq_no||' IS -- '||cs_rec.edc_r_constraint_name);
         append('   SELECT COUNT(*)');
         append('    FROM  '||cs_rec.edc_child_table_name);
         FOR cs_inner_rec IN (SELECT *
                               FROM  user_cons_columns
                              WHERE  constraint_name = cs_rec.edc_r_constraint_name
                             ORDER BY position
                             )
          LOOP
            DECLARE
               CURSOR cs_con_col (p_con_name varchar2
                                 ,p_position number
                                 ) IS
               SELECT column_name
                FROM  user_cons_columns
               WHERE  constraint_name = p_con_name
                AND   position        = p_position;
               l_col_name varchar2(30);
            BEGIN
               OPEN  cs_con_col (cs_rec.edc_constraint_name
                                ,cs_inner_rec.position
                                );
               FETCH cs_con_col INTO l_col_name;
               CLOSE cs_con_col;
               append(l_line_start||cs_inner_rec.column_name||' = :NEW.'||l_col_name);
               l_line_start := '    AND   ';
            END;
         END LOOP;
         append(l_line_start||'('||cs_rec.edc_r_start_date_col||' < l_start_date');
         append('        OR ('||cs_rec.edc_r_end_date_col||' IS NULL AND l_end_date IS NOT NULL');
         append('            OR '||cs_rec.edc_r_end_date_col||' > NVL(l_end_date,'||cs_rec.edc_r_end_date_col||')));');
         append('--');
         append('   l_c_'||cs_rec.edc_seq_no||'_count BINARY_INTEGER;');
         append('--');
      END;
   END LOOP;
--
   -- start date in primary key check
--
   date_key_found := FALSE;
   OPEN date_key_col ( p_rec_edt.edt_table_name
                      ,p_rec_edt.edt_start_date_col );
   FETCH date_key_col INTO l_start_date_col;
   IF date_key_col%FOUND THEN
      date_key_found := TRUE;
      append('   CURSOR cs_c_prm'||' IS -- Primary key check');
      append('   SELECT '|| p_rec_edt.edt_start_date_col||' start_date');
      append('         ,'|| p_rec_edt.edt_end_date_col||' end_date');
      append('    FROM  '|| p_rec_edt.edt_table_name);
      FIRST := TRUE;
      FOR c2rec IN date_key( p_rec_edt.edt_table_name ) LOOP
          IF c2rec.column_name NOT LIKE '%'||c_start_date THEN
             IF FIRST THEN
                append( '   WHERE ' || c2rec.column_name || ' = :NEW.'||c2rec.column_name );
                FIRST := FALSE;
             ELSE
                append( '     AND ' || c2rec.column_name  || ' = :NEW.'||c2rec.column_name );
             END IF;
          END IF ;
      END LOOP;
      append( '     ;' );
      append( '--');
   END IF;
   CLOSE date_key_col;
--
   append('BEGIN');
--
   append('--');
   append('   IF   UPDATING');
   append('    AND l_old_start_date <> l_start_date');
   append('    THEN');
   append('      RAISE l_cannot_update_start_date;');
   append('   END IF;');
   append('--');
   append('   IF   l_start_date > l_end_date');
   append('    AND l_end_date IS NOT NULL');
   append('    THEN');
   append('      RAISE l_start_date_gt_end_date;');
   append('   END IF;');
   append('--');
--
--  Primary key date check
   IF date_key_found THEN
      append('   FOR prm_rec in cs_c_prm LOOP');
      append('      IF prm_rec.end_date IS NULL THEN ');
      append('         RAISE  l_start_date_out_of_range;');
      append('       ELSIF l_start_date < prm_rec.end_date THEN');
      append('         RAISE  l_start_date_out_of_range;');
      append('       ELSIF l_start_date < prm_rec.start_date THEN');
      append('         RAISE l_start_date_out_of_range;');
      append('      END IF;');
      append('   END LOOP;');
      append('--');
   END IF;
--
   FOR cs_rec IN get_parents(p_rec_edt.edt_table_name)
    LOOP
      DECLARE
         l_cur_name varchar2(30) := 'cs_p_'||cs_rec.edp_seq_no;
         l_st_date  varchar2(30) := 'l_p_'||cs_rec.edp_seq_no||'_start_date';
         l_end_date varchar2(30) := 'l_p_'||cs_rec.edp_seq_no||'_end_date';
      BEGIN
         append('   -- '||cs_rec.edp_constraint_name);
         append('   OPEN  '||l_cur_name||';');
         append('   FETCH '||l_cur_name||' INTO '||l_st_date||', '||l_end_date||';');
         append('   CLOSE '||l_cur_name||';');
         append('   IF '||l_end_date||' IS NULL');
         append('    THEN');
         append('      Null; -- Dont worry about it');
         append('   ELSIF l_end_date IS NULL');
         append('    OR   l_end_date >  '||l_end_date);
         append('    THEN');
         append('      RAISE l_end_date_out_of_range;');
         append('   END IF;');
         append('   IF l_start_date < '||l_st_date);
         append('    THEN');
         append('      RAISE l_start_date_out_of_range;');
         append('   END IF;');
         append('--');
      END;
   END LOOP;
   FOR cs_rec IN get_children(p_rec_edt.edt_table_name)
    LOOP
      DECLARE
         l_cur_name varchar2(30) := 'cs_c_'||cs_rec.edc_seq_no;
         l_count    varchar2(30) := 'l_c_'||cs_rec.edc_seq_no||'_count';
      BEGIN
         append('   -- '||cs_rec.edc_r_constraint_name);
         append('   OPEN  '||l_cur_name||';');
         append('   FETCH '||l_cur_name||' INTO '||l_count||';');
         append('   CLOSE '||l_cur_name||';');
         append('   IF '||l_count||' > 0');
         append('    THEN');
         append('      RAISE l_has_children;');
         append('   END IF;');
         append('--');
      END;
   END LOOP;
--
   append('EXCEPTION');
   append('--');
   append('   WHEN l_cannot_update_start_date');
   append('    THEN');
   append('      RAISE_APPLICATION_ERROR(-20980,');
   append(CHR(39)||p_rec_edt.edt_start_date_col||' cannot be updated'||CHR(39)||');',FALSE);
   append('   WHEN l_start_date_out_of_range');
   append('    THEN');
   append('      RAISE_APPLICATION_ERROR(-20981,');
   append(CHR(39)||p_rec_edt.edt_start_date_col||' out of range'||CHR(39)||');',FALSE);
   append('   WHEN l_end_date_out_of_range');
   append('    THEN');
   append('      RAISE_APPLICATION_ERROR(-20982,');
   append(CHR(39)||p_rec_edt.edt_end_date_col||' out of range'||CHR(39)||');',FALSE);
   append('   WHEN l_start_date_gt_end_date');
   append('    THEN');
   append('      RAISE_APPLICATION_ERROR(-20984,');
   append(CHR(39)||p_rec_edt.edt_end_date_col||' cannot be before '||p_rec_edt.edt_start_date_col||CHR(39)||');',FALSE);
   append('   WHEN l_has_children');
   append('    THEN');
   append('      RAISE_APPLICATION_ERROR(-20983,');
   append(CHR(39)||'Record has children outside date range'||CHR(39)||');',FALSE);
   append('--');
   append('END '||p_rec_edt.edt_trigger_name||';');
--
   p_rec_edt.edt_trigger_sql := g_trigger_sql;
--
END build_individual_trigger;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (pi_text    IN varchar2
                 ,pi_newline IN boolean DEFAULT TRUE
                 ) IS
BEGIN
   IF pi_newline
    THEN
      append (CHR(10), FALSE);
   END IF;
   g_trigger_sql := g_trigger_sql||pi_text;
END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_datetrack_views IS
--
BEGIN
--
   FOR cs_rec IN (SELECT table_name
                   FROM  user_tables
                  WHERE  nm3flx.RIGHT(table_name,4) = c_all
                 )
    LOOP
      DECLARE
         l_start_date_col     varchar2(30);
         l_end_date_col       varchar2(30);
         l_view_name          varchar2(30);
         l_nvl_end_date       varchar2(100);
         no_start_or_end_date EXCEPTION;
--
         l_line_start         varchar2(20) := '       ';
--
      BEGIN
--
         l_start_date_col := LOWER(get_col_name_from_substring(cs_rec.table_name,c_start_date));
         l_end_date_col   := LOWER(get_col_name_from_substring(cs_rec.table_name,c_end_date));
         l_nvl_end_date   := 'NVL('||l_end_date_col||', to_date('||CHR(39)||'31/12/9999'||CHR(39)||','||CHR(39)||'DD/MM/YYYY'||CHR(39)||'))';
--
         IF  l_start_date_col IS NULL
          OR l_end_date_col   IS NULL
          THEN
            RAISE no_start_or_end_date;
         END IF;
--
         l_view_name      := LOWER(nm3flx.LEFT(cs_rec.table_name,LENGTH(cs_rec.table_name)-LENGTH(c_all)));
--
         g_trigger_sql    := 'CREATE OR REPLACE VIEW '||l_view_name||' AS';
         append('SELECT');
         comment_block;
         append('-- #########################################################');
         append('-- #                                                       #');
         append('-- #   DO NOT EDIT - This view is generated automatically  #');
         append('-- #                                                       #');
         append('-- #            Generated - '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS')||'           #');
         append('-- #                                                       #');
         append('-- #########################################################');
         append(l_line_start||'*');
         append(' FROM  '||LOWER(cs_rec.table_name));
         append('WHERE  '||l_start_date_col||' <= nm3context.get_effective_date');
         append(' AND  ('||l_end_date_col||' IS NULL');
         append('       OR '||l_end_date_col||' >  nm3context.get_effective_date');
         append('      )');
--
         nm_debug.DEBUG(g_trigger_sql);
         nm_debug.DEBUG('/');
--
         EXECUTE IMMEDIATE g_trigger_sql;
--
      EXCEPTION
         WHEN no_start_or_end_date
          THEN
            NULL;
      END;
   END LOOP;
--
END build_datetrack_views;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_datetrack_views IS
BEGIN
--
   OPEN  cs_tables;
   FETCH cs_tables BULK COLLECT INTO g_tab_tables;
   CLOSE cs_tables;
--
   FOR cs_rec IN (SELECT table_name
                        ,column_name
                   FROM  user_tab_columns
                  WHERE  table_name||c_all IN (SELECT table_name
                                                FROM  user_tables
                                              )
                  MINUS
                  SELECT nm3flx.LEFT(table_name,LENGTH(table_name)-LENGTH(c_all)) table_name
                        ,column_name
                   FROM  user_tab_columns
                  WHERE  nm3flx.LEFT(table_name,LENGTH(table_name)-LENGTH(c_all))
                                        IN (SELECT view_name
                                             FROM  user_views
                                            )
                 ORDER BY 1,2
                 )
    LOOP
      IF check_table_is_datetracked(cs_rec.table_name)
       THEN
         DBMS_OUTPUT.PUT_LINE(cs_rec.table_name||'.'||cs_rec.column_name);
      END IF;
   END LOOP;
END check_datetrack_views;
--
-----------------------------------------------------------------------------
--
PROCEDURE comment_block IS
BEGIN
--
   append('--');
   append('--   SCCS Identifiers :-');
   append('--');
   append('--       sccsid           : @(#)nm3datetrack.pkb	1.2 10/23/03');
   append('--       Module Name      : nm3datetrack.pkb');
   append('--       Date into SCCS   : 03/10/23 11:30:30');
   append('--       Date fetched Out : 07/06/13 14:11:13');
   append('--       SCCS Version     : 1.2');
   append('--');
   append('-----------------------------------------------------------------------------');
   append('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   append('-----------------------------------------------------------------------------');
   append('--');
--
END comment_block;
--
-----------------------------------------------------------------------------
--
END nm3datetrack;
/
