CREATE OR REPLACE PACKAGE BODY nm3audit AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3audit.pkb-arc   2.3   May 16 2011 14:42:26   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3audit.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:42:26  $
--       Date fetched Out : $Modtime:   Apr 01 2011 16:06:20  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on SCCS version : 
--
--
--   Author : Jonathan Mills
--
--   NM3 Auditing package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.3  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3audit';
--
--all global package variables here
---
   g_audit_exc_code  binary_integer := -20001;
   g_audit_exc_msg   varchar2(4000) := 'Unspecified error within '||g_package_name;
   g_audit_exception EXCEPTION;
--
   c_old_type    CONSTANT nm_audit_temp.nat_old_or_new%TYPE := 'OLD';
   c_new_type    CONSTANT nm_audit_temp.nat_old_or_new%TYPE := 'NEW';
--
   c_date_format CONSTANT varchar2(30) := 'DD-Mon-YYYY HH24:MI:SS';
--
   CURSOR cs_aud_table (p_table_name nm_audit_tables.nat_table_name%TYPE) IS
   SELECT *
    FROM  nm_audit_tables
   WHERE  nat_table_name = p_table_name;
--
   CURSOR cs_aud_when (p_table_name nm_audit_when.naw_table_name%TYPE) IS
   SELECT *
    FROM  nm_audit_when
   WHERE  naw_table_name = p_table_name;

   g_rec_audit_table nm_audit_tables%ROWTYPE;
--
   g_rec_nat_to_use nm_audit_temp%ROWTYPE;
--
   TYPE tab_nac IS TABLE OF nm_audit_columns%ROWTYPE INDEX BY binary_integer;
   g_tab_nac tab_nac;
--
   TYPE tab_naw IS TABLE OF nm_audit_when%ROWTYPE INDEX BY binary_integer;
   g_tab_naw tab_naw;
--   
   TYPE nach_tab_t IS TABLE OF nm_audit_changes%ROWTYPE INDEX BY binary_integer;
   g_nach_tab nach_tab_t;

   TYPE tab_varchar200 IS TABLE OF varchar2(200) INDEX BY binary_integer;
   g_tab_inv_types tab_varchar200;
   g_tab_col_datatype tab_varchar200;
--
   TYPE tab_utc IS TABLE OF user_tab_columns%ROWTYPE INDEX BY binary_integer;
--
--
   TYPE rec_key_data IS RECORD
      (column_name  user_tab_columns.column_name%TYPE
      ,data_type    user_tab_columns.data_type%TYPE
      ,column_order user_tab_columns.column_id%TYPE
      ,data_length  user_tab_columns.data_length%TYPE
      );
--
   TYPE tab_rec_key_data IS TABLE OF rec_key_data INDEX BY binary_integer;
--
   g_tab_rec_key_data tab_rec_key_data;
--
   g_rec_old_nat    nm_audit_temp%ROWTYPE;
   g_rec_new_nat    nm_audit_temp%ROWTYPE;
--
   g_clob           clob;
--
-----------------------------------------------------------------------------
--
FUNCTION wrap_todate_around (pi_column_name IN varchar2
                            ,pi_data_type   IN varchar2
                            ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_individual_audit_pair (pi_audit_id IN nm_audit_temp.nat_audit_id%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE change_detected (pi_column_no     IN     number
                          ,pi_old_value     IN     varchar2
                          ,pi_new_value     IN     varchar2
                          );
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_na (pi_rec_na nm_audit_actions%ROWTYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nach(pi_nach_rec IN nm_audit_changes%ROWTYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nach_tab(pi_nach_tab IN nach_tab_t);
--
-----------------------------------------------------------------------------
--
PROCEDURE decode_inv_items (pi_value    IN OUT varchar2
                           ,pi_column   IN OUT varchar2
                           );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_key_cols (pi_table_name  user_tables.table_name%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE set_audit_pair_being_processed (pi_audit_id IN nm_audit_temp.nat_audit_id%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE compare_values  (pi_column_no   IN number
                          ,pi_old_value   IN varchar2
                          ,pi_new_value   IN varchar2
                          );
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_text     IN varchar2
                 ,p_new_line IN boolean DEFAULT TRUE
                 );
--
---- Global Procedures ------------------------------------------------------
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
PROCEDURE append (p_text     IN varchar2
                 ,p_new_line IN boolean DEFAULT TRUE
                 ) IS
BEGIN
   IF p_new_line
    THEN
      append (CHR(10),FALSE);
   END IF;
   nm3clob.append(g_clob,p_text);
END append;
--
-----------------------------------------------------------------------------
--
FUNCTION return_audit_trigger_text(pi_table_name IN user_tables.table_name%TYPE) RETURN CLOB IS


   CURSOR cs_table (p_table_name user_tables.table_name%TYPE) IS
   SELECT *
    FROM  user_tables
   WHERE  table_name = p_table_name;
--
   CURSOR cs_utc (p_table_name user_tables.table_name%TYPE) IS
   SELECT nac_column_name
         ,data_type
         ,nac_column_id
    FROM  nm_audit_columns nac
         ,user_tab_columns utc
   WHERE  nac.nac_table_name  = p_table_name
    AND   nac.nac_table_name  = utc.table_name
    AND   nac.nac_column_name = utc.column_name
    AND   utc.data_type IN ('CHAR','NUMBER','VARCHAR2','DATE')
   ORDER BY nac.nac_column_id;
--
   l_rec_ut  user_tables%ROWTYPE;
   l_rec_nat nm_audit_tables%ROWTYPE;
--
   l_trigger_name user_triggers.trigger_name%TYPE := get_trigger_name(pi_table_name);
--
   l_tab_utc tab_utc;
--
   l_line_start varchar2(20);
   l_old_or_new varchar2(3) := c_old_type;
--
   l_first_audit_type boolean;
   
   l_or VARCHAR2(2); 
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_audit_trigger');
--
   OPEN  cs_table (pi_table_name);
   FETCH cs_table INTO l_rec_ut;
--
   IF cs_table%NOTFOUND
    THEN
      CLOSE cs_table;
      g_audit_exc_code := -20011;
      g_audit_exc_msg  := 'Table does not exist';
      RAISE g_audit_exception;
   END IF;
--
   CLOSE cs_table;
--
   IF l_rec_ut.TEMPORARY = 'Y'
    THEN
      -- do not allow auditing of temporary tables - it just doesn't make sense!
      g_audit_exc_code := -20012;
      g_audit_exc_msg  := 'Cannot audit a temporary table';
      RAISE g_audit_exception;
   END IF;
--
   OPEN  cs_aud_table (pi_table_name);
   FETCH cs_aud_table INTO l_rec_nat;
   IF cs_aud_table%NOTFOUND
    THEN
      CLOSE cs_aud_table;
      g_audit_exc_code := -20015;
      g_audit_exc_msg  := 'No NM_AUDIT_TABLES record found for this table';
      RAISE g_audit_exception;
   END IF;
   CLOSE cs_aud_table;

--
-- get any when conditions which will be applied when trigger is created
--
   OPEN cs_aud_when(pi_table_name);
   FETCH cs_aud_when BULK COLLECT INTO g_tab_naw;
   CLOSE cs_aud_when;
   
--
   FOR cs_rec IN cs_utc (pi_table_name)
    LOOP
      l_tab_utc(cs_rec.nac_column_id).column_name := cs_rec.nac_column_name;
      l_tab_utc(cs_rec.nac_column_id).data_type   := cs_rec.data_type;
   END LOOP;
--
   get_key_cols (pi_table_name);
--
   nm3clob.nullify_clob(g_clob);
   append ('CREATE OR REPLACE TRIGGER '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_trigger_name,FALSE);
   append ('  BEFORE ');
--
   l_first_audit_type := TRUE;
   IF l_rec_nat.nat_audit_insert = 'Y'
    THEN
      append ('INSERT ',FALSE);
      l_first_audit_type := FALSE;
   END IF;
   IF l_rec_nat.nat_audit_update = 'Y'
    THEN
      IF NOT l_first_audit_type
       THEN
         append (' OR ',FALSE);
      END IF;
      append ('UPDATE ',FALSE);
      l_first_audit_type := FALSE;
   END IF;
   IF l_rec_nat.nat_audit_delete = 'Y'
    THEN
      IF NOT l_first_audit_type
       THEN
         append (' OR ',FALSE);
      END IF;
      append ('DELETE ',FALSE);
      l_first_audit_type := FALSE;
   END IF;
--
   IF l_first_audit_type
    THEN
      -- not specified insert update or delete
      -- Will never get in here, 'cos this is now enforced by a check constraint on the table
      g_audit_exc_code := -20016;
      g_audit_exc_msg  := 'Must specify at least 1 of INSERT,UPDATE or DELETE on NM_AUDIT_TABLES';
      RAISE g_audit_exception;
   END IF;
--
   append ('  ON '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||LOWER(pi_table_name));
   append ('  FOR EACH ROW');
   
   IF g_tab_naw.COUNT >0 THEN
     append ('  WHEN');
	 append ('       (');
     FOR i IN 1..g_tab_naw.COUNT LOOP
	 
	    IF i = 1 THEN
		   l_or := Null;
		ELSE
		   l_or := nm3type.c_or_operator;
		END IF;   
		   		
        append ('            '||NVL(l_or,'  ')||' (new.'||g_tab_naw(i).naw_column_name||' '||g_tab_naw(i).naw_operator||' '||g_tab_naw(i).naw_condition||')');
	 END LOOP;
     append ('       )');     
   END IF;
   

   append ('DECLARE');
   append ('--');
   append ('-- NM3 Auditing Trigger for '||pi_table_name);
   append ('--  Generated '||TO_CHAR(SYSDATE,c_date_format));
   append ('--   automatically by '||g_package_name);
   append ('--   '||g_package_name||' version information');
   append ('--   Header : '||get_version);
   append ('--   Body   : '||get_body_version);
   append ('--');
   append ('-----------------------------------------------------------------------------');
   append ('--	Copyright (c) exor corporation ltd, 2000');
   append ('-----------------------------------------------------------------------------');
   append ('--');
   append ('   l_aud_seq    nm_audit_temp.nat_audit_id%TYPE;');
   append ('   l_user       nm_audit_temp.nat_performed_by%TYPE;');
   append ('   l_session_id nm_audit_temp.nat_session_id%TYPE;');
   append ('   l_audit_type nm_audit_temp.nat_audit_type%TYPE;');
   append ('   l_old_or_new nm_audit_temp.nat_old_or_new%TYPE;');
   append ('--');
   append ('   c_table_name  CONSTANT VARCHAR2('||LENGTH(pi_table_name)||') := '||nm3flx.string(pi_table_name)||';');
   append ('   c_date_format CONSTANT VARCHAR2('||LENGTH(c_date_format)||') := '||nm3flx.string(c_date_format)||';');
   append ('--');
   append ('   CURSOR cs_nextval IS');
   append ('   SELECT nm_audit_temp_seq.NEXTVAL');
   append ('         ,USERENV('||nm3flx.string('SESSIONID')||')');
   append ('         ,user');
   append ('    FROM  dual;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   OPEN  cs_nextval;');
   append ('   FETCH cs_nextval INTO l_aud_seq, l_session_id, l_user;');
   append ('   CLOSE cs_nextval;');
   append ('--');
   append ('   IF INSERTING');
   append ('    THEN');
   append ('      l_audit_type := '||nm3flx.string('I')||';');
   append ('   ELSIF UPDATING');
   append ('    THEN');
   append ('      l_audit_type := '||nm3flx.string('U')||';');
   append ('   ELSE');
   append ('      l_audit_type := '||nm3flx.string('D')||';');
   append ('   END IF;');
   append ('--');
--
   FOR l_count IN 1..2
    LOOP
--
      append ('   l_old_or_new := '||nm3flx.string(l_old_or_new)||';');
      append ('-- INSERT THE "'||l_old_or_new||'" record');
      append ('   INSERT INTO nm_audit_temp');
--
      l_line_start := '          (';
      append (l_line_start||'nat_audit_id');
      l_line_start := '          ,';
      append (l_line_start||'nat_old_or_new');
      append (l_line_start||'nat_audit_type');
      append (l_line_start||'nat_audit_table');
      append (l_line_start||'nat_performed_by');
      append (l_line_start||'nat_session_id');
--
      FOR l_count IN 1..g_tab_rec_key_data.COUNT
       LOOP
         append (l_line_start||'nat_key_info_'||g_tab_rec_key_data(l_count).column_order||' -- '||g_tab_rec_key_data(l_count).column_name);
      END LOOP;
--
      DECLARE
         l_count binary_integer := l_tab_utc.first;
      BEGIN
         WHILE l_count IS NOT NULL
          LOOP
            append (l_line_start||'nat_column_'||l_count||' -- '||l_tab_utc(l_count).column_name);
            l_count := l_tab_utc.NEXT(l_count);
         END LOOP;
      END;
      append ('          )');
   --
      l_line_start := '   VALUES (';
      append (l_line_start||'l_aud_seq -- nat_audit_id');
      l_line_start := '          ,';
      append (l_line_start||'l_old_or_new -- nat_old_or_new');
      append (l_line_start||'l_audit_type -- nat_audit_type');
      append (l_line_start||'c_table_name -- nat_audit_table');
      append (l_line_start||'l_user -- nat_performed_by');
      append (l_line_start||'l_session_id -- nat_session_id');
--
      FOR l_count IN 1..g_tab_rec_key_data.COUNT
       LOOP
         append (l_line_start
                         ||wrap_todate_around(':'||l_old_or_new||'.'||g_tab_rec_key_data(l_count).column_name
                                             ,g_tab_rec_key_data(l_count).data_type
                                             )
                         ||' -- nat_key_info_'||l_count);
      END LOOP;
--
      DECLARE
         l_count binary_integer := l_tab_utc.first;
      BEGIN
         WHILE l_count IS NOT NULL
          LOOP
            append (l_line_start
                                  ||wrap_todate_around(':'||l_old_or_new||'.'||l_tab_utc(l_count).column_name
                                                      ,l_tab_utc(l_count).data_type
                                                      )
                                  ||' -- nat_column_'||l_count);
            l_count := l_tab_utc.NEXT(l_count);
         END LOOP;
      END;
--
      append ('          );');
      append ('--');
      l_old_or_new := c_new_type;
--
   END LOOP;
   append ('END '||l_trigger_name||';');
--

   RETURN(g_clob);
   
EXCEPTION
--
   WHEN g_audit_exception
    THEN
      ROLLBACK;
      Raise_Application_Error(g_audit_exc_code,g_audit_exc_msg);   

END return_audit_trigger_text;
--
-----------------------------------------------------------------------------
--
FUNCTION return_audit_trigger_text_str(pi_table_name IN user_tables.table_name%TYPE) RETURN VARCHAR2 IS

 l_clob CLOB;
 l_tab_vc nm3type.tab_varchar32767;
 l_retval nm3type.max_varchar2;

BEGIN

 l_clob :=  return_audit_trigger_text(pi_table_name => pi_table_name);
 l_tab_vc := nm3clob.clob_to_tab_varchar(l_clob);
 
 FOR i IN 1..l_tab_vc.COUNT LOOP
  l_retval := l_retval || l_tab_vc(i);
 END LOOP; 

 RETURN(l_retval);
 
END return_audit_trigger_text_str;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_audit_trigger (pi_table_name IN user_tables.table_name%TYPE) IS

BEGIN
--
  nm3clob.execute_immediate_clob(return_audit_trigger_text (pi_table_name => pi_table_name));
--
   EXECUTE IMMEDIATE 'ALTER TRIGGER '||get_trigger_name(pi_table_name => pi_table_name)||' COMPILE';
--
   nm_debug.proc_end(g_package_name,'build_audit_trigger');
--
EXCEPTION
--
   WHEN g_audit_exception
    THEN
      Raise_Application_Error(g_audit_exc_code,g_audit_exc_msg);
--
END build_audit_trigger;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_all_audit_triggers IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_all_audit_triggers');
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_audit_tables
                 )
    LOOP
      build_audit_trigger (cs_rec.nat_table_name);
   END LOOP;
--
   build_audit_views;
--
   nm_debug.proc_start(g_package_name,'build_all_audit_triggers');
--
END build_all_audit_triggers;
--
-----------------------------------------------------------------------------
--
FUNCTION wrap_todate_around (pi_column_name IN varchar2
                            ,pi_data_type   IN varchar2
                            ) RETURN varchar2 IS
--
   l_retval varchar2(500);
--
BEGIN
--
   IF pi_data_type = 'DATE'
    THEN
      l_retval := 'TO_CHAR('||pi_column_name||',c_date_format)';
   ELSIF pi_data_type = 'NUMBER'
    THEN
      l_retval := 'TO_CHAR('||pi_column_name||')';
   ELSE
      l_retval := pi_column_name;
   END IF;
--
   RETURN l_retval;
--
END wrap_todate_around;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_audited_data IS
--
   CURSOR cs_audited IS
   SELECT *
    FROM  nm_audit_temp
   WHERE  nat_processing_status = 0
   ORDER BY nat_audit_table ASC
           ,nat_audit_id    ASC
           ,nat_old_or_new  DESC;
--
   l_rec_nat nm_audit_temp%ROWTYPE;
--
   l_commit_count          binary_integer := 0;
   c_commit_after CONSTANT binary_integer := 200;
--
BEGIN
--
   g_tab_inv_types.DELETE;
--
   OPEN  cs_audited;
--
   LOOP
--
      FETCH cs_audited INTO l_rec_nat;
      EXIT WHEN cs_audited%NOTFOUND;
      IF l_rec_nat.nat_old_or_new <> c_old_type
       THEN
         g_audit_exc_code := -20021;
         g_audit_exc_msg  := '"'||c_old_type||'" record not found for nat_audit_id '||l_rec_nat.nat_audit_id;
         RAISE g_audit_exception;
      END IF;
--
      g_rec_old_nat := l_rec_nat;
--
      FETCH cs_audited INTO l_rec_nat;
      IF  cs_audited%NOTFOUND
       OR l_rec_nat.nat_old_or_new <> c_new_type
       OR l_rec_nat.nat_audit_id   <> g_rec_old_nat.nat_audit_id
       THEN
         g_audit_exc_code := -20022;
         g_audit_exc_msg  := '"'||c_new_type||'" record not found for nat_audit_id '||g_rec_old_nat.nat_audit_id;
         RAISE g_audit_exception;
      END IF;
--
      g_rec_new_nat := l_rec_nat;
--
      process_individual_audit_pair (g_rec_old_nat.nat_audit_id);
--
--    Commit if necessary
--
      l_commit_count := l_commit_count + 1;
      IF l_commit_count >= c_commit_after
       THEN
         COMMIT;
         l_commit_count := 0;
      END IF;
--
   END LOOP;
--
   CLOSE cs_audited;
--
   COMMIT;
--
EXCEPTION
--
   WHEN g_audit_exception
    THEN
      IF cs_audited%isopen
       THEN
         CLOSE cs_audited;
      END IF;
      ROLLBACK;
      Raise_Application_Error(g_audit_exc_code,g_audit_exc_msg);
--
END process_audited_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_audit_pair_being_processed (pi_audit_id IN nm_audit_temp.nat_audit_id%TYPE) IS
--
   PRAGMA autonomous_transaction;
--
BEGIN
--
   UPDATE nm_audit_temp
    SET   nat_processing_status = NULL
   WHERE  nat_audit_id          = pi_audit_id;
--
   COMMIT;
--
END set_audit_pair_being_processed;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_individual_audit_pair (pi_audit_id IN nm_audit_temp.nat_audit_id%TYPE) IS

  l_na_rec nm_audit_actions%ROWTYPE;

BEGIN
--
   IF g_rec_new_nat.nat_audit_type = 'D'
    THEN
      g_rec_nat_to_use := g_rec_old_nat;
   ELSE
      g_rec_nat_to_use := g_rec_new_nat;
   END IF;
--
   IF g_rec_nat_to_use.nat_audit_table <> NVL(g_rec_audit_table.nat_table_name,nm3type.c_nvl)
    THEN
--
--    Only bother going for the new data if we are dealing with a different table from
--     the last audit record processed.
--
      OPEN  cs_aud_table (g_rec_nat_to_use.nat_audit_table);
      FETCH cs_aud_table INTO g_rec_audit_table;
      IF cs_aud_table%NOTFOUND
       THEN
         CLOSE cs_aud_table;
         g_audit_exc_code := -20023;
         g_audit_exc_msg  := 'No NM_AUDIT_TABLES record found for nat_audit_id '||pi_audit_id;
         RAISE g_audit_exception;
      END IF;
      CLOSE cs_aud_table;
--
      g_tab_col_datatype.DELETE;
      g_tab_nac.DELETE;
--
      FOR cs_rec IN (SELECT *
                      FROM  nm_audit_columns
                     WHERE  nac_table_name = g_rec_nat_to_use.nat_audit_table
                    )
       LOOP
         g_tab_nac(cs_rec.nac_column_id) := cs_rec;
      END LOOP;
--
      FOR cs_rec IN (SELECT nac_column_id
                           ,data_type
                      FROM  nm_audit_columns
                           ,user_tab_columns
                     WHERE  nac_table_name  = g_rec_nat_to_use.nat_audit_table
                      AND   nac_table_name  = table_name
                      AND   nac_column_name = column_name
                    )
       LOOP
         g_tab_col_datatype(cs_rec.nac_column_id) := cs_rec.data_type;
      END LOOP;
--
   END IF;

   g_nach_tab.DELETE;
--
-- Compare all the values
--
   compare_values(1,   g_rec_old_nat.nat_column_1,   g_rec_new_nat.nat_column_1);
   compare_values(2,   g_rec_old_nat.nat_column_2,   g_rec_new_nat.nat_column_2);
   compare_values(3,   g_rec_old_nat.nat_column_3,   g_rec_new_nat.nat_column_3);
   compare_values(4,   g_rec_old_nat.nat_column_4,   g_rec_new_nat.nat_column_4);
   compare_values(5,   g_rec_old_nat.nat_column_5,   g_rec_new_nat.nat_column_5);
   compare_values(6,   g_rec_old_nat.nat_column_6,   g_rec_new_nat.nat_column_6);
   compare_values(7,   g_rec_old_nat.nat_column_7,   g_rec_new_nat.nat_column_7);
   compare_values(8,   g_rec_old_nat.nat_column_8,   g_rec_new_nat.nat_column_8);
   compare_values(9,   g_rec_old_nat.nat_column_9,   g_rec_new_nat.nat_column_9);
   compare_values(10,  g_rec_old_nat.nat_column_10,  g_rec_new_nat.nat_column_10);
   compare_values(11,  g_rec_old_nat.nat_column_11,  g_rec_new_nat.nat_column_11);
   compare_values(12,  g_rec_old_nat.nat_column_12,  g_rec_new_nat.nat_column_12);
   compare_values(13,  g_rec_old_nat.nat_column_13,  g_rec_new_nat.nat_column_13);
   compare_values(14,  g_rec_old_nat.nat_column_14,  g_rec_new_nat.nat_column_14);
   compare_values(15,  g_rec_old_nat.nat_column_15,  g_rec_new_nat.nat_column_15);
   compare_values(16,  g_rec_old_nat.nat_column_16,  g_rec_new_nat.nat_column_16);
   compare_values(17,  g_rec_old_nat.nat_column_17,  g_rec_new_nat.nat_column_17);
   compare_values(18,  g_rec_old_nat.nat_column_18,  g_rec_new_nat.nat_column_18);
   compare_values(19,  g_rec_old_nat.nat_column_19,  g_rec_new_nat.nat_column_19);
   compare_values(20,  g_rec_old_nat.nat_column_20,  g_rec_new_nat.nat_column_20);
   compare_values(21,  g_rec_old_nat.nat_column_21,  g_rec_new_nat.nat_column_21);
   compare_values(22,  g_rec_old_nat.nat_column_22,  g_rec_new_nat.nat_column_22);
   compare_values(23,  g_rec_old_nat.nat_column_23,  g_rec_new_nat.nat_column_23);
   compare_values(24,  g_rec_old_nat.nat_column_24,  g_rec_new_nat.nat_column_24);
   compare_values(25,  g_rec_old_nat.nat_column_25,  g_rec_new_nat.nat_column_25);
   compare_values(26,  g_rec_old_nat.nat_column_26,  g_rec_new_nat.nat_column_26);
   compare_values(27,  g_rec_old_nat.nat_column_27,  g_rec_new_nat.nat_column_27);
   compare_values(28,  g_rec_old_nat.nat_column_28,  g_rec_new_nat.nat_column_28);
   compare_values(29,  g_rec_old_nat.nat_column_29,  g_rec_new_nat.nat_column_29);
   compare_values(30,  g_rec_old_nat.nat_column_30,  g_rec_new_nat.nat_column_30);
   compare_values(31,  g_rec_old_nat.nat_column_31,  g_rec_new_nat.nat_column_31);
   compare_values(32,  g_rec_old_nat.nat_column_32,  g_rec_new_nat.nat_column_32);
   compare_values(33,  g_rec_old_nat.nat_column_33,  g_rec_new_nat.nat_column_33);
   compare_values(34,  g_rec_old_nat.nat_column_34,  g_rec_new_nat.nat_column_34);
   compare_values(35,  g_rec_old_nat.nat_column_35,  g_rec_new_nat.nat_column_35);
   compare_values(36,  g_rec_old_nat.nat_column_36,  g_rec_new_nat.nat_column_36);
   compare_values(37,  g_rec_old_nat.nat_column_37,  g_rec_new_nat.nat_column_37);
   compare_values(38,  g_rec_old_nat.nat_column_38,  g_rec_new_nat.nat_column_38);
   compare_values(39,  g_rec_old_nat.nat_column_39,  g_rec_new_nat.nat_column_39);
   compare_values(40,  g_rec_old_nat.nat_column_40,  g_rec_new_nat.nat_column_40);
   compare_values(41,  g_rec_old_nat.nat_column_41,  g_rec_new_nat.nat_column_41);
   compare_values(42,  g_rec_old_nat.nat_column_42,  g_rec_new_nat.nat_column_42);
   compare_values(43,  g_rec_old_nat.nat_column_43,  g_rec_new_nat.nat_column_43);
   compare_values(44,  g_rec_old_nat.nat_column_44,  g_rec_new_nat.nat_column_44);
   compare_values(45,  g_rec_old_nat.nat_column_45,  g_rec_new_nat.nat_column_45);
   compare_values(46,  g_rec_old_nat.nat_column_46,  g_rec_new_nat.nat_column_46);
   compare_values(47,  g_rec_old_nat.nat_column_47,  g_rec_new_nat.nat_column_47);
   compare_values(48,  g_rec_old_nat.nat_column_48,  g_rec_new_nat.nat_column_48);
   compare_values(49,  g_rec_old_nat.nat_column_49,  g_rec_new_nat.nat_column_49);
   compare_values(50,  g_rec_old_nat.nat_column_50,  g_rec_new_nat.nat_column_50);
   compare_values(51,  g_rec_old_nat.nat_column_51,  g_rec_new_nat.nat_column_51);
   compare_values(52,  g_rec_old_nat.nat_column_52,  g_rec_new_nat.nat_column_52);
   compare_values(53,  g_rec_old_nat.nat_column_53,  g_rec_new_nat.nat_column_53);
   compare_values(54,  g_rec_old_nat.nat_column_54,  g_rec_new_nat.nat_column_54);
   compare_values(55,  g_rec_old_nat.nat_column_55,  g_rec_new_nat.nat_column_55);
   compare_values(56,  g_rec_old_nat.nat_column_56,  g_rec_new_nat.nat_column_56);
   compare_values(57,  g_rec_old_nat.nat_column_57,  g_rec_new_nat.nat_column_57);
   compare_values(58,  g_rec_old_nat.nat_column_58,  g_rec_new_nat.nat_column_58);
   compare_values(59,  g_rec_old_nat.nat_column_59,  g_rec_new_nat.nat_column_59);
   compare_values(60,  g_rec_old_nat.nat_column_60,  g_rec_new_nat.nat_column_60);
   compare_values(61,  g_rec_old_nat.nat_column_61,  g_rec_new_nat.nat_column_61);
   compare_values(62,  g_rec_old_nat.nat_column_62,  g_rec_new_nat.nat_column_62);
   compare_values(63,  g_rec_old_nat.nat_column_63,  g_rec_new_nat.nat_column_63);
   compare_values(64,  g_rec_old_nat.nat_column_64,  g_rec_new_nat.nat_column_64);
   compare_values(65,  g_rec_old_nat.nat_column_65,  g_rec_new_nat.nat_column_65);
   compare_values(66,  g_rec_old_nat.nat_column_66,  g_rec_new_nat.nat_column_66);
   compare_values(67,  g_rec_old_nat.nat_column_67,  g_rec_new_nat.nat_column_67);
   compare_values(68,  g_rec_old_nat.nat_column_68,  g_rec_new_nat.nat_column_68);
   compare_values(69,  g_rec_old_nat.nat_column_69,  g_rec_new_nat.nat_column_69);
   compare_values(70,  g_rec_old_nat.nat_column_70,  g_rec_new_nat.nat_column_70);
   compare_values(71,  g_rec_old_nat.nat_column_71,  g_rec_new_nat.nat_column_71);
   compare_values(72,  g_rec_old_nat.nat_column_72,  g_rec_new_nat.nat_column_72);
   compare_values(73,  g_rec_old_nat.nat_column_73,  g_rec_new_nat.nat_column_73);
   compare_values(74,  g_rec_old_nat.nat_column_74,  g_rec_new_nat.nat_column_74);
   compare_values(75,  g_rec_old_nat.nat_column_75,  g_rec_new_nat.nat_column_75);
   compare_values(76,  g_rec_old_nat.nat_column_76,  g_rec_new_nat.nat_column_76);
   compare_values(77,  g_rec_old_nat.nat_column_77,  g_rec_new_nat.nat_column_77);
   compare_values(78,  g_rec_old_nat.nat_column_78,  g_rec_new_nat.nat_column_78);
   compare_values(79,  g_rec_old_nat.nat_column_79,  g_rec_new_nat.nat_column_79);
   compare_values(80,  g_rec_old_nat.nat_column_80,  g_rec_new_nat.nat_column_80);
   compare_values(81,  g_rec_old_nat.nat_column_81,  g_rec_new_nat.nat_column_81);
   compare_values(82,  g_rec_old_nat.nat_column_82,  g_rec_new_nat.nat_column_82);
   compare_values(83,  g_rec_old_nat.nat_column_83,  g_rec_new_nat.nat_column_83);
   compare_values(84,  g_rec_old_nat.nat_column_84,  g_rec_new_nat.nat_column_84);
   compare_values(85,  g_rec_old_nat.nat_column_85,  g_rec_new_nat.nat_column_85);
   compare_values(86,  g_rec_old_nat.nat_column_86,  g_rec_new_nat.nat_column_86);
   compare_values(87,  g_rec_old_nat.nat_column_87,  g_rec_new_nat.nat_column_87);
   compare_values(88,  g_rec_old_nat.nat_column_88,  g_rec_new_nat.nat_column_88);
   compare_values(89,  g_rec_old_nat.nat_column_89,  g_rec_new_nat.nat_column_89);
   compare_values(90,  g_rec_old_nat.nat_column_90,  g_rec_new_nat.nat_column_90);
   compare_values(91,  g_rec_old_nat.nat_column_91,  g_rec_new_nat.nat_column_91);
   compare_values(92,  g_rec_old_nat.nat_column_92,  g_rec_new_nat.nat_column_92);
   compare_values(93,  g_rec_old_nat.nat_column_93,  g_rec_new_nat.nat_column_93);
   compare_values(94,  g_rec_old_nat.nat_column_94,  g_rec_new_nat.nat_column_94);
   compare_values(95,  g_rec_old_nat.nat_column_95,  g_rec_new_nat.nat_column_95);
   compare_values(96,  g_rec_old_nat.nat_column_96,  g_rec_new_nat.nat_column_96);
   compare_values(97,  g_rec_old_nat.nat_column_97,  g_rec_new_nat.nat_column_97);
   compare_values(98,  g_rec_old_nat.nat_column_98,  g_rec_new_nat.nat_column_98);
   compare_values(99,  g_rec_old_nat.nat_column_99,  g_rec_new_nat.nat_column_99);
   compare_values(100, g_rec_old_nat.nat_column_100, g_rec_new_nat.nat_column_100);
   compare_values(101, g_rec_old_nat.nat_column_101, g_rec_new_nat.nat_column_101);
   compare_values(102, g_rec_old_nat.nat_column_102, g_rec_new_nat.nat_column_102);
   compare_values(103, g_rec_old_nat.nat_column_103, g_rec_new_nat.nat_column_103);
   compare_values(104, g_rec_old_nat.nat_column_104, g_rec_new_nat.nat_column_104);
   compare_values(105, g_rec_old_nat.nat_column_105, g_rec_new_nat.nat_column_105);
   compare_values(106, g_rec_old_nat.nat_column_106, g_rec_new_nat.nat_column_106);
   compare_values(107, g_rec_old_nat.nat_column_107, g_rec_new_nat.nat_column_107);
   compare_values(108, g_rec_old_nat.nat_column_108, g_rec_new_nat.nat_column_108);
   compare_values(109, g_rec_old_nat.nat_column_109, g_rec_new_nat.nat_column_109);
   compare_values(110, g_rec_old_nat.nat_column_110, g_rec_new_nat.nat_column_110);
   compare_values(111, g_rec_old_nat.nat_column_111, g_rec_new_nat.nat_column_111);
   compare_values(112, g_rec_old_nat.nat_column_112, g_rec_new_nat.nat_column_112);
   compare_values(113, g_rec_old_nat.nat_column_113, g_rec_new_nat.nat_column_113);
   compare_values(114, g_rec_old_nat.nat_column_114, g_rec_new_nat.nat_column_114);
   compare_values(115, g_rec_old_nat.nat_column_115, g_rec_new_nat.nat_column_115);
   compare_values(116, g_rec_old_nat.nat_column_116, g_rec_new_nat.nat_column_116);
   compare_values(117, g_rec_old_nat.nat_column_117, g_rec_new_nat.nat_column_117);
   compare_values(118, g_rec_old_nat.nat_column_118, g_rec_new_nat.nat_column_118);
   compare_values(119, g_rec_old_nat.nat_column_119, g_rec_new_nat.nat_column_119);
   compare_values(120, g_rec_old_nat.nat_column_120, g_rec_new_nat.nat_column_120);
   compare_values(121, g_rec_old_nat.nat_column_121, g_rec_new_nat.nat_column_121);
   compare_values(122, g_rec_old_nat.nat_column_122, g_rec_new_nat.nat_column_122);
   compare_values(123, g_rec_old_nat.nat_column_123, g_rec_new_nat.nat_column_123);
   compare_values(124, g_rec_old_nat.nat_column_124, g_rec_new_nat.nat_column_124);
   compare_values(125, g_rec_old_nat.nat_column_125, g_rec_new_nat.nat_column_125);
   compare_values(126, g_rec_old_nat.nat_column_126, g_rec_new_nat.nat_column_126);
   compare_values(127, g_rec_old_nat.nat_column_127, g_rec_new_nat.nat_column_127);
   compare_values(128, g_rec_old_nat.nat_column_128, g_rec_new_nat.nat_column_128);
   compare_values(129, g_rec_old_nat.nat_column_129, g_rec_new_nat.nat_column_129);
   compare_values(130, g_rec_old_nat.nat_column_130, g_rec_new_nat.nat_column_130);
   compare_values(131, g_rec_old_nat.nat_column_131, g_rec_new_nat.nat_column_131);
   compare_values(132, g_rec_old_nat.nat_column_132, g_rec_new_nat.nat_column_132);
   compare_values(133, g_rec_old_nat.nat_column_133, g_rec_new_nat.nat_column_133);
   compare_values(134, g_rec_old_nat.nat_column_134, g_rec_new_nat.nat_column_134);
   compare_values(135, g_rec_old_nat.nat_column_135, g_rec_new_nat.nat_column_135);
   compare_values(136, g_rec_old_nat.nat_column_136, g_rec_new_nat.nat_column_136);
   compare_values(137, g_rec_old_nat.nat_column_137, g_rec_new_nat.nat_column_137);
   compare_values(138, g_rec_old_nat.nat_column_138, g_rec_new_nat.nat_column_138);
   compare_values(139, g_rec_old_nat.nat_column_139, g_rec_new_nat.nat_column_139);
   compare_values(140, g_rec_old_nat.nat_column_140, g_rec_new_nat.nat_column_140);
   compare_values(141, g_rec_old_nat.nat_column_141, g_rec_new_nat.nat_column_141);
   compare_values(142, g_rec_old_nat.nat_column_142, g_rec_new_nat.nat_column_142);
   compare_values(143, g_rec_old_nat.nat_column_143, g_rec_new_nat.nat_column_143);
   compare_values(144, g_rec_old_nat.nat_column_144, g_rec_new_nat.nat_column_144);
   compare_values(145, g_rec_old_nat.nat_column_145, g_rec_new_nat.nat_column_145);
   compare_values(146, g_rec_old_nat.nat_column_146, g_rec_new_nat.nat_column_146);
   compare_values(147, g_rec_old_nat.nat_column_147, g_rec_new_nat.nat_column_147);
   compare_values(148, g_rec_old_nat.nat_column_148, g_rec_new_nat.nat_column_148);
   compare_values(149, g_rec_old_nat.nat_column_149, g_rec_new_nat.nat_column_149);
   compare_values(150, g_rec_old_nat.nat_column_150, g_rec_new_nat.nat_column_150);
   compare_values(151, g_rec_old_nat.nat_column_151, g_rec_new_nat.nat_column_151);
   compare_values(152, g_rec_old_nat.nat_column_152, g_rec_new_nat.nat_column_152);
   compare_values(153, g_rec_old_nat.nat_column_153, g_rec_new_nat.nat_column_153);
   compare_values(154, g_rec_old_nat.nat_column_154, g_rec_new_nat.nat_column_154);
   compare_values(155, g_rec_old_nat.nat_column_155, g_rec_new_nat.nat_column_155);
   compare_values(156, g_rec_old_nat.nat_column_156, g_rec_new_nat.nat_column_156);
   compare_values(157, g_rec_old_nat.nat_column_157, g_rec_new_nat.nat_column_157);
   compare_values(158, g_rec_old_nat.nat_column_158, g_rec_new_nat.nat_column_158);
   compare_values(159, g_rec_old_nat.nat_column_159, g_rec_new_nat.nat_column_159);
   compare_values(160, g_rec_old_nat.nat_column_160, g_rec_new_nat.nat_column_160);
   compare_values(161, g_rec_old_nat.nat_column_161, g_rec_new_nat.nat_column_161);
   compare_values(162, g_rec_old_nat.nat_column_162, g_rec_new_nat.nat_column_162);
   compare_values(163, g_rec_old_nat.nat_column_163, g_rec_new_nat.nat_column_163);
   compare_values(164, g_rec_old_nat.nat_column_164, g_rec_new_nat.nat_column_164);
   compare_values(165, g_rec_old_nat.nat_column_165, g_rec_new_nat.nat_column_165);
   compare_values(166, g_rec_old_nat.nat_column_166, g_rec_new_nat.nat_column_166);
   compare_values(167, g_rec_old_nat.nat_column_167, g_rec_new_nat.nat_column_167);
   compare_values(168, g_rec_old_nat.nat_column_168, g_rec_new_nat.nat_column_168);
   compare_values(169, g_rec_old_nat.nat_column_169, g_rec_new_nat.nat_column_169);
   compare_values(170, g_rec_old_nat.nat_column_170, g_rec_new_nat.nat_column_170);
   compare_values(171, g_rec_old_nat.nat_column_171, g_rec_new_nat.nat_column_171);
   compare_values(172, g_rec_old_nat.nat_column_172, g_rec_new_nat.nat_column_172);
   compare_values(173, g_rec_old_nat.nat_column_173, g_rec_new_nat.nat_column_173);
   compare_values(174, g_rec_old_nat.nat_column_174, g_rec_new_nat.nat_column_174);
   compare_values(175, g_rec_old_nat.nat_column_175, g_rec_new_nat.nat_column_175);
   compare_values(176, g_rec_old_nat.nat_column_176, g_rec_new_nat.nat_column_176);
   compare_values(177, g_rec_old_nat.nat_column_177, g_rec_new_nat.nat_column_177);
   compare_values(178, g_rec_old_nat.nat_column_178, g_rec_new_nat.nat_column_178);
   compare_values(179, g_rec_old_nat.nat_column_179, g_rec_new_nat.nat_column_179);
   compare_values(180, g_rec_old_nat.nat_column_180, g_rec_new_nat.nat_column_180);
   compare_values(181, g_rec_old_nat.nat_column_181, g_rec_new_nat.nat_column_181);
   compare_values(182, g_rec_old_nat.nat_column_182, g_rec_new_nat.nat_column_182);
   compare_values(183, g_rec_old_nat.nat_column_183, g_rec_new_nat.nat_column_183);
   compare_values(184, g_rec_old_nat.nat_column_184, g_rec_new_nat.nat_column_184);
   compare_values(185, g_rec_old_nat.nat_column_185, g_rec_new_nat.nat_column_185);
   compare_values(186, g_rec_old_nat.nat_column_186, g_rec_new_nat.nat_column_186);
   compare_values(187, g_rec_old_nat.nat_column_187, g_rec_new_nat.nat_column_187);
   compare_values(188, g_rec_old_nat.nat_column_188, g_rec_new_nat.nat_column_188);
   compare_values(189, g_rec_old_nat.nat_column_189, g_rec_new_nat.nat_column_189);
   compare_values(190, g_rec_old_nat.nat_column_190, g_rec_new_nat.nat_column_190);
   compare_values(191, g_rec_old_nat.nat_column_191, g_rec_new_nat.nat_column_191);
   compare_values(192, g_rec_old_nat.nat_column_192, g_rec_new_nat.nat_column_192);
   compare_values(193, g_rec_old_nat.nat_column_193, g_rec_new_nat.nat_column_193);
   compare_values(194, g_rec_old_nat.nat_column_194, g_rec_new_nat.nat_column_194);
   compare_values(195, g_rec_old_nat.nat_column_195, g_rec_new_nat.nat_column_195);
   compare_values(196, g_rec_old_nat.nat_column_196, g_rec_new_nat.nat_column_196);
   compare_values(197, g_rec_old_nat.nat_column_197, g_rec_new_nat.nat_column_197);
   compare_values(198, g_rec_old_nat.nat_column_198, g_rec_new_nat.nat_column_198);
   compare_values(199, g_rec_old_nat.nat_column_199, g_rec_new_nat.nat_column_199);
   compare_values(200, g_rec_old_nat.nat_column_200, g_rec_new_nat.nat_column_200);

  IF g_nach_tab.COUNT > 0
  THEN
    --create an nm_audit record
   l_na_rec.na_audit_id     := g_rec_nat_to_use.nat_audit_id;
   l_na_rec.na_timestamp    := g_rec_nat_to_use.nat_timestamp;
   l_na_rec.na_performed_by := g_rec_nat_to_use.nat_performed_by;
   l_na_rec.na_session_id   := g_rec_nat_to_use.nat_session_id;
   l_na_rec.na_table_name   := NVL(g_rec_audit_table.nat_table_alias
                                  ,g_rec_nat_to_use.nat_audit_table
                                  );
   l_na_rec.na_audit_type   := g_rec_nat_to_use.nat_audit_type;
   l_na_rec.na_key_info_1   := g_rec_nat_to_use.nat_key_info_1;
   l_na_rec.na_key_info_2   := g_rec_nat_to_use.nat_key_info_2;
   l_na_rec.na_key_info_3   := g_rec_nat_to_use.nat_key_info_3;
   l_na_rec.na_key_info_4   := g_rec_nat_to_use.nat_key_info_4;
   l_na_rec.na_key_info_5   := g_rec_nat_to_use.nat_key_info_5;
   l_na_rec.na_key_info_6   := g_rec_nat_to_use.nat_key_info_6;
   l_na_rec.na_key_info_7   := g_rec_nat_to_use.nat_key_info_7;
   l_na_rec.na_key_info_8   := g_rec_nat_to_use.nat_key_info_8;
   l_na_rec.na_key_info_9   := g_rec_nat_to_use.nat_key_info_9;
   l_na_rec.na_key_info_10  := g_rec_nat_to_use.nat_key_info_10;

   ins_na(pi_rec_na => l_na_rec);

    --insert nm_audit_changes records
    ins_nach_tab(pi_nach_tab => g_nach_tab);
  END IF;

--
-- Finished with these records so get rid of them
--
   DELETE FROM nm_audit_temp
   WHERE  nat_audit_id = pi_audit_id;
--
END process_individual_audit_pair;
--
-----------------------------------------------------------------------------
--
PROCEDURE compare_values  (pi_column_no   IN number
                          ,pi_old_value   IN varchar2
                          ,pi_new_value   IN varchar2
                          ) IS
BEGIN
--
  IF  NVL(pi_old_value,nm3type.c_nvl) != NVL(pi_new_value,nm3type.c_nvl)
   THEN
--
     change_detected (pi_column_no,pi_old_value,pi_new_value);
--
  END IF;
--
END compare_values;
--
-----------------------------------------------------------------------------
--
PROCEDURE change_detected (pi_column_no     IN     number
                          ,pi_old_value     IN     varchar2
                          ,pi_new_value     IN     varchar2
                          ) IS
--
   --l_rec_na  nm_audit%ROWTYPE;
   l_rec_nac nm_audit_columns%ROWTYPE;
--
   l_sql_string long;
--
   TYPE tab_varchar4000 IS TABLE OF varchar2(4000) INDEX BY binary_integer;
   l_tab_values tab_varchar4000;
   l_column_name nm_audit_changes.nach_column_name%TYPE;
--
  l_nach_tab_ix pls_integer := g_nach_tab.COUNT + 1;

BEGIN
--
   IF NOT g_tab_nac.EXISTS (pi_column_no)
    THEN
      g_audit_exc_code := -20024;
      g_audit_exc_msg  := 'No NM_AUDIT_COLUMNS record found for nat_audit_id '
                          ||g_rec_nat_to_use.nat_audit_id
                          ||' col '
                          ||pi_column_no;
      RAISE g_audit_exception;
   END IF;
--
   IF NOT g_tab_col_datatype.EXISTS(pi_column_no)
    THEN
      g_audit_exc_code := -20025;
      g_audit_exc_msg  := 'No USER_TAB_COLUMNS record found for nat_audit_id '
                          ||g_rec_nat_to_use.nat_audit_id
                          ||' col '
                          ||pi_column_no;
      RAISE g_audit_exception;
   END IF;
--
   l_rec_nac := g_tab_nac(pi_column_no);
--
   g_nach_tab(l_nach_tab_ix).nach_audit_id     := g_rec_nat_to_use.nat_audit_id;
   g_nach_tab(l_nach_tab_ix).nach_column_id    := pi_column_no;
   g_nach_tab(l_nach_tab_ix).nach_column_name  := NVL(l_rec_nac.nac_column_alias
                                  ,l_rec_nac.nac_column_name
                                  );
--
   l_tab_values(1)          := pi_old_value;
   l_tab_values(2)          := pi_new_value;
--
   FOR l_count IN 1..2
    LOOP
      l_column_name := g_nach_tab(l_nach_tab_ix).nach_column_name;
      IF l_tab_values(l_count) IS NULL
       THEN
         --
         -- If the value is null then don't bother doing anything else with it
         --
         NULL;
      ELSIF l_rec_nac.nac_decode_sql IS NOT NULL
       THEN
         l_sql_string := l_rec_nac.nac_decode_sql||nm3flx.string(l_tab_values(l_count));
         BEGIN
            EXECUTE IMMEDIATE l_sql_string INTO l_tab_values(l_count);
         EXCEPTION
            WHEN others
             THEN
               g_audit_exc_code := -20026;
               g_audit_exc_msg  := SQLERRM;
               RAISE g_audit_exception;
         END;
      ELSIF l_rec_nac.nac_table_name = 'NM_INV_ITEMS_ALL'
       THEN
         --
         -- NM_INV_ITEMS is a special case
         --
         decode_inv_items (l_tab_values(l_count)
                          ,l_column_name
                          );
      ELSE
         --
         -- All other data will be banged out as is
         --
         NULL;
      END IF;
      IF   g_tab_col_datatype(pi_column_no)                                = 'DATE'
       AND SUBSTR(l_tab_values(l_count),LENGTH(l_tab_values(l_count))-8,9) = ' 00:00:00'
       THEN
         --
         -- If this is a date field and this is at midnight then chop off the time portion
         --
         l_tab_values(l_count) := SUBSTR(l_tab_values(l_count),1,LENGTH(l_tab_values(l_count))-9);
      END IF;
   END LOOP;
--
   g_nach_tab(l_nach_tab_ix).nach_column_name := l_column_name;
--
   g_nach_tab(l_nach_tab_ix).nach_old_value  := l_tab_values(1);
   g_nach_tab(l_nach_tab_ix).nach_new_value  := l_tab_values(2);
--
END change_detected;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_na (pi_rec_na nm_audit_actions%ROWTYPE) IS
BEGIN
--
   INSERT INTO nm_audit_actions
          (na_audit_id
          ,na_timestamp
          ,na_performed_by
          ,na_session_id
          ,na_table_name
          ,na_audit_type
          ,na_key_info_1
          ,na_key_info_2
          ,na_key_info_3
          ,na_key_info_4
          ,na_key_info_5
          ,na_key_info_6
          ,na_key_info_7
          ,na_key_info_8
          ,na_key_info_9
          ,na_key_info_10
          )
   VALUES (pi_rec_na.na_audit_id
          ,pi_rec_na.na_timestamp
          ,pi_rec_na.na_performed_by
          ,pi_rec_na.na_session_id
          ,pi_rec_na.na_table_name
          ,pi_rec_na.na_audit_type
          ,pi_rec_na.na_key_info_1
          ,pi_rec_na.na_key_info_2
          ,pi_rec_na.na_key_info_3
          ,pi_rec_na.na_key_info_4
          ,pi_rec_na.na_key_info_5
          ,pi_rec_na.na_key_info_6
          ,pi_rec_na.na_key_info_7
          ,pi_rec_na.na_key_info_8
          ,pi_rec_na.na_key_info_9
          ,pi_rec_na.na_key_info_10
          );
--
END ins_na;
--
-----------------------------------------------------------------------------
--
PROCEDURE decode_inv_items (pi_value    IN OUT varchar2
                           ,pi_column   IN OUT varchar2
                           ) IS
--
   l_rec_nita nm_inv_type_attribs%ROWTYPE;
--
BEGIN
--
--   IF INSTR(pi_column,'ATTRIB',1,1) = 0
--    THEN
--      RETURN;
--   END IF;
--
   IF NOT g_tab_inv_types.EXISTS(g_rec_nat_to_use.nat_audit_id)
    THEN
      --
      -- If we haven't already found which inv_type this one is
      --
      FOR l_count IN 1..g_tab_nac.COUNT
       LOOP
         IF g_tab_nac(l_count).nac_column_name = 'IIT_INV_TYPE'
          THEN
            g_tab_inv_types(g_rec_nat_to_use.nat_audit_id) := NULL;
            EXECUTE IMMEDIATE 'SELECT nat_column_'||g_tab_nac(l_count).nac_column_id
                              ||' FROM nm_audit_temp '
                              ||'WHERE nat_audit_id = :nat_audit_id'
                              ||' AND  nat_old_or_new = :nat_old_or_new'
             INTO g_tab_inv_types(g_rec_nat_to_use.nat_audit_id)
             USING g_rec_nat_to_use.nat_audit_id, g_rec_nat_to_use.nat_old_or_new;
            EXIT;
         END IF;
      END LOOP;
   END IF;
--
   IF g_tab_inv_types.EXISTS(g_rec_nat_to_use.nat_audit_id)
    THEN
      DECLARE
         l_value    varchar2(4000);
         l_meaning  varchar2(4000);
      BEGIN
         nm3inv.validate_flex_inv (g_tab_inv_types(g_rec_nat_to_use.nat_audit_id)
                                  ,pi_column
                                  ,pi_value
                                  ,l_value
                                  ,l_meaning
                                  );
         pi_value := l_value;
         IF l_meaning IS NOT NULL
          THEN
            pi_value := pi_value||' ('||l_meaning||')';
         END IF;
      EXCEPTION
         WHEN others
          THEN
            --
            -- This is to catch any errors which validate_flex_inv may throw out, we're not interested
            --
            NULL;
      END;
   --
      l_rec_nita := nm3inv.get_inv_type_attr (g_tab_inv_types(g_rec_nat_to_use.nat_audit_id)
                                             ,pi_column
                                             );
      IF l_rec_nita.ita_scrn_text IS NOT NULL
       THEN
         pi_column := l_rec_nita.ita_scrn_text;
      END IF;
   END IF;
--
END decode_inv_items;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_process_job IS
   l_job_id binary_integer;
BEGIN
--
   dbms_job.submit
       (job       => l_job_id
       ,what      => g_package_name||'.process_audited_data;'
       ,next_date => TRUNC(SYSDATE) + 1 + (2/24)
       ,interval  => 'TRUNC(sysdate) + 1 + (2/24)' -- Re-run every day at 2 am
       );
--
   dbms_output.put_line('The job_id is : '||l_job_id);
--
   COMMIT;
--
END submit_process_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_audit_views IS
--
   l_view_sql_string    long;
   l_comment_sql_string long;
   l_view_name          varchar2(30);
--
BEGIN
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_audit_tables
                 )
    LOOP
      l_view_name := get_view_name(cs_rec.nat_table_name);
      get_key_cols (cs_rec.nat_table_name);
      l_view_sql_string := 'CREATE OR REPLACE VIEW '||l_view_name||' AS'
                           ||CHR(10)||'SELECT '
                           ||CHR(10)||' -- '
                           ||CHR(10)||' -- Generated '||TO_CHAR(SYSDATE,c_date_format)
                           ||CHR(10)||' -- '
                           ||CHR(10)||'        na_audit_id'
                           ||CHR(10)||'       ,na_column_id'
                           ||CHR(10)||'       ,na_timestamp'
                           ||CHR(10)||'       ,na_performed_by'
                           ||CHR(10)||'       ,na_session_id'
                           ||CHR(10)||'       ,na_audit_type';
--
      FOR l_count IN 1..g_tab_rec_key_data.COUNT
       LOOP
         DECLARE
            l_pre_string   varchar2(50);
            l_post_string  varchar2(50);
            l_rec_key_data rec_key_data;
         BEGIN
            l_rec_key_data := g_tab_rec_key_data(l_count);
            IF l_rec_key_data.data_type = 'DATE'
             THEN
               l_pre_string  := 'TO_DATE(';
               l_post_string := ','||nm3flx.string(c_date_format)||')';
            ELSIF l_rec_key_data.data_type = 'NUMBER'
             THEN
               l_pre_string  := 'TO_NUMBER(';
               l_post_string := ')';
            ELSE
               l_pre_string  := 'SUBSTR(';
               l_post_string := ',1,'||l_rec_key_data.data_length||')';
            END IF;
            l_view_sql_string := l_view_sql_string
                           ||CHR(10)||'       ,'||l_pre_string||'na_key_info_'||l_rec_key_data.column_order||l_post_string
                                                            ||' '||l_rec_key_data.column_name;
         END;
      END LOOP;
      l_view_sql_string := l_view_sql_string
                           ||CHR(10)||'       ,na_column_name'
                           ||CHR(10)||'       ,na_old_value'
                           ||CHR(10)||'       ,na_new_value'
                           ||CHR(10)||' FROM   nm_audit'
                           ||CHR(10)||' WHERE  na_table_name = '||nm3flx.string(NVL(cs_rec.nat_table_alias,cs_rec.nat_table_name))
                           ||CHR(10)||'WITH READ ONLY';
      EXECUTE IMMEDIATE l_view_sql_string;
--
      l_comment_sql_string := 'COMMENT ON TABLE '||l_view_name||' IS '
                              ||nm3flx.string('View of audited data for '||cs_rec.nat_table_name);
      EXECUTE IMMEDIATE l_comment_sql_string;
--
   END LOOP;
--
EXCEPTION
--
   WHEN g_audit_exception
    THEN
      Raise_Application_Error(g_audit_exc_code,g_audit_exc_msg);
--
END build_audit_views;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_key_cols (pi_table_name  user_tables.table_name%TYPE) IS
--
   CURSOR cs_count_key_cols IS
   SELECT COUNT(*)
    FROM  user_tab_columns
   WHERE  table_name  = 'NM_AUDIT_TEMP'
    AND   column_name LIKE 'NAT_KEY_INFO_%';
--
   CURSOR cs_nkc (p_table_name user_tables.table_name%TYPE) IS
   SELECT column_name
         ,data_type
         ,nkc_seq_no column_order
         ,data_length
    FROM  nm_audit_key_cols
         ,user_tab_columns
   WHERE  nkc_table_name = p_table_name
    AND   table_name     = nkc_table_name
    AND   column_name    = nkc_column_name
    AND   data_type IN ('CHAR','NUMBER','VARCHAR2','DATE')
   ORDER BY nkc_seq_no;
--
   CURSOR cs_pk_cols (p_table_name user_tables.table_name%TYPE) IS
   SELECT utc.column_name
         ,utc.data_type
         ,ucc.position column_order
         ,utc.data_length
    FROM  user_constraints uc
         ,user_cons_columns ucc
         ,user_tab_columns  utc
   WHERE  uc.table_name      = p_table_name
    AND   uc.constraint_type = 'P'
    AND   uc.constraint_name = ucc.constraint_name
    AND   uc.table_name      = utc.table_name
    AND   ucc.column_name    = utc.column_name;
--
   l_key_col_count number;
--
BEGIN
--
   g_tab_rec_key_data.DELETE;
--
   FOR cs_rec IN cs_nkc (pi_table_name)
    LOOP
      --
      -- Loop through any pre-defined key info for this table
      --
      DECLARE
         l_rec_key_data  rec_key_data;
      BEGIN
--
         l_rec_key_data.column_name  := cs_rec.column_name;
         l_rec_key_data.data_type    := cs_rec.data_type;
         l_rec_key_data.column_order := cs_rec.column_order;
         l_rec_key_data.data_length  := cs_rec.data_length;
--
         g_tab_rec_key_data(g_tab_rec_key_data.COUNT+1) := l_rec_key_data;
      END;
   END LOOP;
--
   IF g_tab_rec_key_data.COUNT = 0
    THEN
      --
      -- If there no data specified in nm_audit_key_cols
      --
      FOR cs_rec IN cs_pk_cols (pi_table_name)
       LOOP
         DECLARE
            l_rec_key_data  rec_key_data;
         BEGIN
--
            l_rec_key_data.column_name  := cs_rec.column_name;
            l_rec_key_data.data_type    := cs_rec.data_type;
            l_rec_key_data.column_order := cs_rec.column_order;
            l_rec_key_data.data_length  := cs_rec.data_length;
--
            g_tab_rec_key_data(g_tab_rec_key_data.COUNT+1) := l_rec_key_data;
         END;
      END LOOP;
   END IF;
--
   OPEN  cs_count_key_cols;
   FETCH cs_count_key_cols INTO l_key_col_count;
   CLOSE cs_count_key_cols;
--
   IF g_tab_rec_key_data.COUNT = 0
    THEN
      g_audit_exc_code := -20013;
      g_audit_exc_msg  := 'Cannot audit a table with no key columns specified';
      RAISE g_audit_exception;
   ELSIF g_tab_rec_key_data.COUNT > l_key_col_count
    THEN
      g_audit_exc_code := -20014;
      g_audit_exc_msg  := 'Too many key columns specified max '||l_key_col_count;
      RAISE g_audit_exception;
   END IF;
--
END get_key_cols;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_audit_temp_seq RETURN number IS
--
   CURSOR cs_nextval IS
   SELECT nm_audit_temp_seq.NEXTVAL
    FROM  dual;
--
   l_retval number;
--
BEGIN
--
   OPEN  cs_nextval;
   FETCH cs_nextval INTO l_retval;
   CLOSE cs_nextval;
--
   RETURN l_retval;
--
END get_next_audit_temp_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION get_key_cols(pi_table_name IN user_tables.table_name%TYPE
                     ) RETURN pls_integer IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_key_cols');

  get_key_cols(pi_table_name => pi_table_name);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_key_cols');

  RETURN g_tab_rec_key_data.COUNT;

END get_key_cols;
--
-----------------------------------------------------------------------------
--
FUNCTION get_key_col_name(pi_index IN pls_integer
                         ) RETURN nm_audit_key_cols.nkc_column_name%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_key_col_name');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_key_col_name');

  RETURN g_tab_rec_key_data(pi_index).column_name;

END get_key_col_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nach(pi_nach_rec IN nm_audit_changes%ROWTYPE
                  ) IS
BEGIN
  INSERT INTO
    nm_audit_changes
        (nach_audit_id
        ,nach_column_id
        ,nach_column_name
        ,nach_old_value
        ,nach_new_value
        )
  VALUES(pi_nach_rec.nach_audit_id
        ,pi_nach_rec.nach_column_id
        ,pi_nach_rec.nach_column_name
        ,pi_nach_rec.nach_old_value
        ,pi_nach_rec.nach_new_value
        );
END ins_nach;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nach_tab(pi_nach_tab IN nach_tab_t
                       ) IS
BEGIN
  FOR l_i IN 1..pi_nach_tab.COUNT
  LOOP
    ins_nach(pi_nach_rec => pi_nach_tab(l_i));
  END LOOP;
END ins_nach_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE reset_nkc_to_default (pi_table_name IN user_tables.table_name%TYPE) IS
--
   CURSOR cs_ac (c_table_name user_tables.table_name%TYPE
                ) IS
   SELECT constraint_name
    FROM  all_constraints
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = c_table_name
    AND   constraint_type IN ('P','U')
   ORDER BY constraint_type ASC;
--
   l_cons_name all_constraints.constraint_name%TYPE;
--
BEGIN
--
   OPEN  cs_ac (pi_table_name);
   FETCH cs_ac INTO l_cons_name;
   IF cs_ac%FOUND
    THEN
--
      DELETE FROM nm_audit_key_cols
      WHERE  nkc_table_name = pi_table_name;
--
      INSERT INTO nm_audit_key_cols
            (nkc_table_name
            ,nkc_seq_no
            ,nkc_column_name
            )
      SELECT pi_table_name
            ,position
            ,column_name
       FROM  all_cons_columns
      WHERE  owner           = Sys_Context('NM3CORE','APPLICATION_OWNER')
       AND   constraint_name = l_cons_name
       AND   table_name      = pi_table_name;
--
   END IF;
   CLOSE cs_ac;
--
END reset_nkc_to_default;
--
-----------------------------------------------------------------------------
--
PROCEDURE reset_nac_to_default (pi_table_name IN user_tables.table_name%TYPE) IS
BEGIN
--
   DELETE FROM nm_audit_columns
   WHERE  nac_table_name = pi_table_name;
--
   INSERT INTO nm_audit_columns
         (nac_table_name
         ,nac_column_id
         ,nac_column_name
         )
   SELECT pi_table_name
         ,column_id
         ,column_name
    FROM  all_tab_columns
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = pi_table_name
    AND   column_name NOT LIKE '%DATE_CREATED'
    AND   column_name NOT LIKE '%DATE_MODIFIED'
    AND   column_name NOT LIKE '%MODIFIED_BY'
    AND   column_name NOT LIKE '%CREATED_BY'
    AND   data_type IN ('VARCHAR2','DATE','NUMBER','CHAR','FLOAT');
--
END reset_nac_to_default;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_audit_trigger (pi_table_name IN user_tables.table_name%TYPE) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   c_trigger_name user_triggers.trigger_name%TYPE := get_trigger_name(pi_table_name);
   c_view_name    user_views.view_name%TYPE       := get_view_name(pi_table_name);
--
BEGIN
--
   IF nm3ddl.does_object_exist(c_trigger_name,'TRIGGER')
    THEN
      EXECUTE IMMEDIATE 'DROP TRIGGER '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_trigger_name;
   END IF;
--
   IF nm3ddl.does_object_exist(c_view_name,'VIEW')
    THEN
      EXECUTE IMMEDIATE 'DROP VIEW '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_view_name;
   END IF;
--
END drop_audit_trigger;
--
-----------------------------------------------------------------------------
--
FUNCTION get_trigger_name (pi_table_name IN user_tables.table_name%TYPE
                          ) RETURN user_triggers.trigger_name%TYPE IS
BEGIN
   RETURN SUBSTR(pi_table_name,1,26)||'_AUD';
END get_trigger_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_view_name (pi_table_name IN user_tables.table_name%TYPE
                       ) RETURN user_views.view_name%TYPE IS
BEGIN
   RETURN SUBSTR(pi_table_name,1,24)||'_AUD_V';
END get_view_name;
--
-----------------------------------------------------------------------------
--
END nm3audit;
/
