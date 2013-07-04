CREATE OR REPLACE PACKAGE BODY Nm2_Nm3_Migration AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/mig/nm2_nm3_migration.pkb-arc   2.13   Jul 04 2013 16:49:08   James.Wadsworth  $
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/mig/nm2_nm3_migration.pkb-arc   2.13   Jul 04 2013 16:49:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm2_nm3_migration.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:46:22  $
--       PVCS Version     : $Revision:   2.13  $
--
--   Author D.Cope
--
--   nm2_nm3_migration body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   2.13  $';
  g_package_name CONSTANT VARCHAR2(30) := 'nm2_nm3_migration';
  g_proc_name    VARCHAR2(50);
  g_log_file                UTL_FILE.FILE_TYPE;
  g_issue_commits           VARCHAR2(1) := 'Y';
  g_debug                   BOOLEAN;
  g_admin_type              CONSTANT nm_admin_units.nau_admin_type%TYPE := 'NETW';
--  g_node_type               CONSTANT NM_NODE_TYPES.nnt_type%TYPE        := 'ROAD';
  g_node_type               CONSTANT NM_NODE_TYPES.nnt_type%TYPE        := 'MAIN';
  g_errors                  PLS_INTEGER;
  g_mig_earliest_date       DATE;
  g_log_file_name           VARCHAR2(200);
  g_log_file_location       VARCHAR2(200);
  g_process_start_time      DATE;   -- start time of the current process
  g_l_network               BOOLEAN := FALSE;
  g_d_network               BOOLEAN := FALSE;
  g_welsh                   BOOLEAN;
  g_so_far                  PLS_INTEGER;
  g_total_todo              PLS_INTEGER;
   -- used when calculating long operations
  g_slno                    PLS_INTEGER;
  g_rindex                  PLS_INTEGER;
  inv_item_not_found        EXCEPTION;
    g_theme_max number;

  
--
  type old_new_type is table of number index by binary_integer;


  old_new_tab old_new_type;

--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
procedure populate_old_new_tab
is
   cursor c1
   is
  select *
  from mig_old_new_ne_id;
begin
   for c1rec in c1
    loop
       old_new_tab(c1rec.rse_he_id) := c1rec.ne_id;
   end loop;
end populate_old_new_tab;
--
-----------------------------------------------------------------------------
--
function get_new_ne_id(p_rse_he_id number)
return NUMBER
is
begin
   return old_new_tab(p_rse_he_id);
end get_new_ne_id;
--
-----------------------------------------------------------------------------
--
function get_new_nau(p_nau number)
return nm_admin_units.nau_unit_code%TYPE
is
begin
   FOR nau_rec IN (select hau_unit_code
                   from v2_hig_admin_units
                   where hau_admin_unit = p_nau) LOOP
   IF nau_rec.hau_unit_code is not null THEN
   return nau_rec.hau_unit_code;
   END IF;
   END LOOP;
end get_new_nau;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_log IS
BEGIN
  IF g_debug THEN
    Nm_Debug.debug_off;
  END IF;
  UTL_FILE.FFLUSH(g_log_file);
  UTL_FILE.FCLOSE(g_log_file);
  DBMS_OUTPUT.PUT_LINE('Log file '||g_log_file_name||' written to '||g_log_file_location);
END close_log;
--
-----------------------------------------------------------------------------
--
FUNCTION get_timestamp RETURN VARCHAR2 IS
BEGIN
  RETURN TO_CHAR(SYSDATE, 'DD-MM:HH24.mi.ss');
END get_timestamp;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_errors IS
BEGIN
  g_errors := 0;
END clear_errors;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_error IS
BEGIN
  g_errors := g_errors + 1;
END log_error;
--
-----------------------------------------------------------------------------
--
FUNCTION time_of_run(p_start_time DATE
                    ,p_end_time   DATE) RETURN VARCHAR2 IS
  days     PLS_INTEGER;
  day_part NUMBER;
  hrs      PLS_INTEGER;
  mins     PLS_INTEGER;
  secs     PLS_INTEGER;
  l_retval VARCHAR2(50);
BEGIN
  days     := TRUNC(p_end_time - ADD_MONTHS(p_start_time,TRUNC(MONTHS_BETWEEN(p_end_time,p_start_time) )));
  IF days >= 1 THEN
    l_retval := l_retval || days || ' Days ';
  END IF;
  day_part := MOD(ABS(p_end_time-p_start_time), 1);
  hrs      := TRUNC(day_part * 24);
  IF hrs >= 1 THEN
    l_retval := l_retval || hrs || ' Hours ';
  END IF;
  mins     := TRUNC((((day_part)*24)-(hrs))*60);
  IF mins >= 1 THEN
    l_retval := l_retval || mins || ' Minutes ';
  END IF;
  secs     := TRUNC(MOD((ABS(p_end_time-p_start_time))*86400,60));
  RETURN l_retval|| secs ||' Seconds';
END time_of_run;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_it(pi_text IN VARCHAR2) IS
BEGIN
  IF g_debug THEN
    Nm_Debug.DEBUG(pi_text);
  END IF;
END debug_it;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_log_content(pi_text      IN VARCHAR
                            ,pi_indent    IN VARCHAR2 DEFAULT 'Y'
                            ,pi_timestamp IN BOOLEAN  DEFAULT TRUE) IS
  l_timestamp VARCHAR2(30);
  l_indent    VARCHAR2(20);
BEGIN
   IF pi_timestamp THEN
     l_timestamp := get_timestamp||'>';
   ELSE
     l_timestamp := NULL;
   END IF;
   IF UPPER(pi_indent) = 'Y' THEN
      l_indent := '     ';
   ELSE
      l_indent := NULL;
   END IF;
   debug_it(l_timestamp||l_indent||pi_text);
   IF UTL_FILE.IS_OPEN(g_log_file) THEN
     UTL_FILE.PUT_LINE(FILE      => g_log_file
                      ,buffer    => l_timestamp||l_indent||pi_text
                      ,autoflush => TRUE);
   END IF;
EXCEPTION
   WHEN UTL_FILE.INVALID_PATH
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file location or name was invalid');
   WHEN UTL_FILE.INVALID_FILEHANDLE
    THEN
      RAISE_APPLICATION_ERROR(-20001,'not a valid file handle');
   WHEN UTL_FILE.INVALID_OPERATION
    THEN
      RAISE_APPLICATION_ERROR(-20001,'file is not open for reading');
   WHEN UTL_FILE.WRITE_ERROR
    THEN
      RAISE_APPLICATION_ERROR(-20001,'OS error occured during write operation');
END append_log_content;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_header(pi_text IN VARCHAR) IS
BEGIN
  append_log_content(pi_text      => pi_text
                    ,pi_indent    => 'N'
                    ,pi_timestamp => FALSE);
END append_header;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_proc_start_to_log IS
BEGIN
   append_log_content(pi_text   => ''
                     ,pi_indent => 'N');
   append_log_content(pi_text => '[START OF '||g_proc_name||']'
                     ,pi_indent => 'N');
END append_proc_start_to_log;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_proc_end_to_log IS
BEGIN
   append_log_content(pi_text => '[END OF '||g_proc_name||']'
                     ,pi_indent => 'N');
   append_log_content(pi_text   => ''
                     ,pi_indent => 'N');
END append_proc_end_to_log;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_mig_end_to_log IS
BEGIN
   append_header('');
   append_header('Execution time '||time_of_run(g_process_start_time, SYSDATE));
   append_header('');
   append_header('Done');
END append_mig_end_to_log;
--
-----------------------------------------------------------------------------
--
PROCEDURE report_any_errors(p_extra_text IN VARCHAR2 DEFAULT NULL) IS
BEGIN
  IF g_errors > 0 THEN
    append_log_content(NULL);
    append_header(g_errors||' errors have been handled during this phase.');
    IF p_extra_text IS NOT NULL THEN
      append_header(p_extra_text);
    END IF;
    append_header('Check logfile for details');
  END IF;
END report_any_errors;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_commit IS
BEGIN
  COMMIT;
  append_log_content('Changes Committed.');
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_optional_commit IS
BEGIN
  IF g_issue_commits = 'Y' THEN
    do_commit;
  END IF;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_rollback IS
BEGIN
  ROLLBACK;
  append_log_content('Rollback complete.');
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE stop_migration(p_error IN VARCHAR2) IS
BEGIN
  do_rollback;
  RAISE_APPLICATION_ERROR(-20000, p_error);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE start_longop(p_What         IN VARCHAR2
                      ,p_total_amount IN PLS_INTEGER DEFAULT g_total_todo) IS
BEGIN
  g_rindex := dbms_application_info.set_session_longops_nohint;
  dbms_application_info.set_session_longops (
   rindex       => g_rindex,
   slno         => g_slno,
   op_name      => 'Migration',
   target_desc  => p_What,
   totalwork    => p_total_amount);
   dbms_application_info.set_action(action_name => 'Migration : '||p_what);
   g_so_far := 0;
END start_longop;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_longop_progress(p_what         IN VARCHAR2
                             ,p_amount_done  IN PLS_INTEGER DEFAULT g_so_far
                             ,p_total_amount IN PLS_INTEGER DEFAULT g_total_todo) IS
BEGIN
  dbms_application_info.set_session_longops (
   rindex       => g_rindex,
   slno         => g_slno,
   op_name      => 'Migration',
   target_desc  => p_What,
   sofar        => p_amount_done,
   totalwork    => p_total_amount);
END set_longop_progress;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_progress IS
BEGIN
  g_so_far     := 0;
  g_total_todo := 0;
END clear_progress;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise(pi_log_file_location  IN VARCHAR2
                    ,pi_log_file_name      IN VARCHAR2
                    ,pi_first_stage        IN BOOLEAN DEFAULT FALSE
                    ,pi_with_debug         IN BOOLEAN DEFAULT FALSE) IS
--
   PROCEDURE init_log_file IS
   BEGIN
     g_log_file_name      := pi_log_file_name;
     g_log_file_location  := pi_log_file_location;
     g_log_file := Nm3file.fopen(LOCATION  => pi_log_file_location
                                ,filename  => pi_log_file_name
                                ,open_mode => Nm3file.c_write_mode);
     append_header('Highways by Exor');
     append_header('================');
     append_header(NULL);
     append_header('Using version '||g_body_sccsid);
     append_header(pi_log_file_location||'     '||pi_log_file_name);
     append_header('Started at '||get_timestamp);
     append_header(NULL);
   END init_log_file;
--
   PROCEDURE init_mig_dtp_local IS
    v_local  VARCHAR2(1) := NULL;
    v_dtp    VARCHAR2(1) := NULL;
   BEGIN
     append_log_content(pi_text => 'Deriving list of v2 Network Types');

     DELETE FROM MIG_DTP_LOCAL;

/*     INSERT INTO MIG_DTP_LOCAL
     SELECT 'L'
     FROM   dual
     WHERE  EXISTS (SELECT 1
                    FROM v2_road_segs
                    WHERE rse_sys_flag = 'L');
     INSERT INTO MIG_DTP_LOCAL
     SELECT 'D'
     FROM   dual
     WHERE EXISTS (SELECT 'x'
                   FROM v2_road_segs
                   WHERE rse_sys_flag = 'D');
*/

     INSERT INTO MIG_DTP_LOCAL
     SELECT rse_sys_flag, COUNT(*) rse_sys_flag_Count
     FROM v2_road_segs
     GROUP BY rse_sys_flag;

     BEGIN
  	   SELECT 'Y'
	   INTO   v_local
	   FROM   MIG_DTP_LOCAL
	   WHERE  rse_sys_flag = 'L';
	 EXCEPTION WHEN NO_DATA_FOUND THEN
	   g_l_network := FALSE;
	 END;
     BEGIN
  	   SELECT 'Y'
	   INTO   v_dtp
	   FROM   MIG_DTP_LOCAL
	   WHERE  rse_sys_flag = 'D';
     EXCEPTION WHEN NO_DATA_FOUND THEN
	   g_d_network := FALSE;
	 END;
     IF v_local IS NOT NULL THEN
       append_log_content(pi_text => 'Found type of [L]');
       g_l_network := TRUE;
	 END IF;
     IF v_dtp IS NOT NULL THEN
       append_log_content(pi_text => 'Found type of [D]');
       g_d_network := TRUE;
	 END IF;
     append_log_content('');
   END init_mig_dtp_local;
--
   PROCEDURE init_earliest_date IS
     CURSOR c1 IS
     SELECT MIN(pus_start_date)
     FROM v2_point_usages, v2_node_usages
     WHERE nou_pus_node_id = pus_node_id
     UNION
     SELECT MIN(rse_start_date)
     FROM v2_road_segs
     UNION
     SELECT MIN(iit_created_date)
     FROM v2_inv_items_all
     UNION
     SELECT MIN(iit_cre_date)
     FROM v2_inv_items_all
     UNION
     SELECT MIN(nau_start_date)
     FROM  NM_ADMIN_UNITS_ALL
     ORDER BY 1 ASC;
   BEGIN
    OPEN c1;
    FETCH c1 INTO g_mig_earliest_date;
    CLOSE c1;
   END init_earliest_date;
BEGIN
  g_proc_name := 'initialise';
--
  IF pi_with_debug THEN
    g_issue_commits := 'N';
    g_debug := TRUE;
    Nm_Debug.debug_on;
    Nm_Debug.set_level(4);
  ELSE
    g_issue_commits := 'Y';
    g_debug := FALSE;
    Nm_Debug.debug_off;
  END IF;
  g_process_start_time := SYSDATE;
--
  init_log_file;
  clear_errors;
  clear_progress;
--
  append_proc_start_to_log;
--
  init_mig_dtp_local;
--
-- if this is the first stage then derive the earliest date
-- otherwise use the date stored on the hig_user entry for the application owner
  append_log_content(pi_text => 'Deriving Earliest System Date');
  IF pi_first_stage THEN
    init_earliest_date;
  ELSE
    g_mig_earliest_date := Nm3get.get_hus(pi_hus_user_id => Hig.get_application_owner_id).hus_start_date;
  END IF;
  append_log_content(pi_text => TO_CHAR(g_mig_earliest_date,'DD-MON-YYYY'));
--
  append_proc_end_to_log;
--
END initialise;
--
-----------------------------------------------------------------------------
--
FUNCTION l_network RETURN BOOLEAN IS
BEGIN
  RETURN g_l_network;
END l_network;
--
-----------------------------------------------------------------------------
--
FUNCTION d_network RETURN BOOLEAN IS
BEGIN
  RETURN g_d_network;
END d_network;
--
-----------------------------------------------------------------------------
--
-- Welsh customers have specific differences to their network metamodel
-- This is indicated by the product option RMMSFLAG which is set to 4.
FUNCTION welsh RETURN BOOLEAN IS
BEGIN
  IF g_welsh IS NULL THEN
    g_welsh := NVL(Hig.get_sysopt(p_option_id => 'RMMSFLAG'),1) = 4;
  END IF;
  RETURN g_welsh;
END welsh;
--
-----------------------------------------------------------------------------
--
FUNCTION Get_New_Nm3_Inv_Type(p_inv_type IN NM_INV_TYPES_ALL.NIT_INV_TYPE%TYPE
                             ,p_sys_flag IN road_segs.rse_sys_flag%TYPE DEFAULT NULL)
                             RETURN NM_INV_TYPES_ALL.NIT_INV_TYPE%TYPE IS
  resv_word_excep EXCEPTION;
  PRAGMA EXCEPTION_INIT(resv_word_excep, -20001);
  resv_word BOOLEAN;
  l_retval NM_INV_TYPES_ALL.NIT_INV_TYPE%TYPE;
  l_check  NM_INV_TYPES_ALL%ROWTYPE;
--
  FUNCTION get_first_char(p_inv_type IN NM_INV_TYPES_ALL.nit_inv_type%TYPE) RETURN VARCHAR2 IS
  BEGIN
    RETURN SUBSTR(p_inv_type,1,1);
  END;
--
BEGIN
  l_retval := p_inv_type;
  l_check := Nm3get.get_nit(pi_nit_inv_type    => l_retval
                           ,pi_raise_not_found => FALSE);
  IF (l_check.nit_inv_type IS NOT NULL AND p_sys_flag IS NOT NULL)
     OR  (p_inv_type ='RC' AND p_sys_flag IS NOT NULL ) THEN
    l_retval := get_first_char(l_retval)||p_sys_flag;
    l_check := Nm3get.get_nit(pi_nit_inv_type    => l_retval
                             ,pi_raise_not_found => FALSE);
  END IF;
  BEGIN
    resv_word:=Nm3flx.is_string_valid_for_object(l_retval);
  EXCEPTION
    WHEN resv_word_excep THEN
	resv_word:=FALSE;
  END;
  IF l_check.nit_inv_type IS NOT NULL OR NOT resv_word THEN
    IF SUBSTR(l_retval, 2,1) = 'Z' THEN
      RETURN Get_New_Nm3_Inv_Type(p_inv_type => CHR(ASCII(get_first_char(l_retval)) + 1)||'A');
    ELSE
      RETURN Get_New_Nm3_Inv_Type(p_inv_type => get_first_char(l_retval)||CHR(ASCII(SUBSTR(l_retval,2,1)) + 1));
    END IF;
  ELSE
    RETURN l_retval;
  END IF;
END Get_New_Nm3_Inv_Type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nm3_inv_code(p_nm2_inv_code IN NM_INV_TYPES_ALL.nit_inv_type%TYPE
                         ,p_nm2_sys_flag IN VARCHAR2)
                          RETURN  NM_INV_TYPES_ALL.nit_inv_type%TYPE IS

l_sql VARCHAR2(2000);
/*
  CURSOR get_nm3_code (p_nm2_inv_code IN NM_INV_TYPES_ALL.nit_inv_type%TYPE
                      ,p_nm2_sys_flag IN VARCHAR2) IS

  SELECT nit_inv_Type
  FROM INV_TYPE_TRANSLATIONS
    WHERE ity_inv_code = p_nm2_inv_code
  AND   ity_sys_flag     = p_nm2_sys_flag;
/*
  SELECT itc_new_inv_code
  FROM NM2_NM3_INV_TYPE_CHANGES
  WHERE itc_old_inv_code = p_nm2_inv_code
  AND   itc_sys_flag     = p_nm2_sys_flag;
*/
  l_retval NM_INV_TYPES_ALL.nit_inv_type%TYPE;
BEGIN
  l_sql:='select nit_inv_Type from inv_type_translations where ity_inv_Code='''||p_nm2_inv_code||''' AND ity_sys_flag = '''||p_nm2_sys_flag||'''';
  EXECUTE IMMEDIATE (l_sql) INTO L_retval;
/*
  OPEN get_nm3_code(p_nm2_inv_code, p_nm2_sys_flag);
  FETCH get_nm3_code INTO l_retval;
  CLOSE get_nm3_code;
*/
  RETURN l_retval;
END get_nm3_inv_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nm2_inv_code (p_nm3_inv_code IN NM_INV_TYPES_ALL.nit_inv_type%TYPE)
                          RETURN  NM_INV_TYPES_ALL.nit_inv_type%TYPE IS
/*  CURSOR get_nm2_code (p_nm3_inv_code IN NM_INV_TYPES_ALL.nit_inv_type%TYPE)IS

  SELECT ity_inv_code
  FROM INV_TYPE_TRANSLATIONS
    WHERE nit_inv_Type = p_nm3_inv_code;
/*
  SELECT itc_old_inv_code
  FROM   NM2_NM3_INV_TYPE_CHANGES
  WHERE  itc_new_inv_code = p_nm3_inv_code;
*/
  l_retval NM_INV_TYPES_ALL.nit_inv_type%TYPE;
  l_found  BOOLEAN;
  l_sql VARCHAR2(2000);
BEGIN
/*  OPEN  get_nm2_code(p_nm3_inv_code);
  FETCH get_nm2_code INTO l_retval;
  IF get_nm2_code%NOTFOUND THEN
    l_found := FALSE;
  END IF;
  CLOSE get_nm2_code;
  -- if there is no type change then return nm3 code as the nm2 code
  IF NOT l_found THEN
    RETURN p_nm3_inv_code;
  ELSE
    -- return the nm2 code
    RETURN l_retval;
  END IF;
*/
  l_sql:='select ity_inv_code from inv_type_translations where nit_inv_Type = '''||p_nm3_inv_code||'''';
  EXECUTE IMMEDIATE (l_sql) INTO L_retval;
  RETURN l_retval;
END get_nm2_inv_code;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_admin_units (pi_v2_higowner VARCHAR2) IS
  CURSOR get_user_admin_units IS
  SELECT hus_user_id nua_user_id
        ,hus_admin_unit nua_admin_unit
        ,hus_start_date
        ,nau_start_date
        ,hus_end_date
        ,nau_end_date
        ,'NORMAL' nua_mode
  FROM   HIG_USERS
        ,NM_ADMIN_UNITS_ALL
  WHERE  hus_admin_unit = nau_admin_unit
  AND   NOT EXISTS (SELECT 1
                      FROM  NM_USER_AUS_ALL
                      WHERE  NUA_USER_ID = hus_user_id
		      AND    NUA_ADMIN_UNIT = hus_admin_unit
                      );

  CURSOR get_other_users IS
  SELECT hus_user_id
        ,hus_admin_unit
        ,hus_initials
        ,hus_name
        ,NVL(hus_username, 'NO_USERNAME'||ROWNUM) hus_username
        ,hus_job_title
        ,hus_agent_code
        ,hus_wor_flag
        ,hus_wor_value_min
        ,hus_wor_value_max
        ,hus_start_date
        ,hus_end_date
        ,hus_wor_aur_min
        ,hus_wor_aur_max
   FROM  v2_hig_users
   WHERE  NVL(hus_username, 'NO_USERNAME')  != UPPER(pi_v2_higowner);
  l_nua NM_USER_AUS_ALL%ROWTYPE;
  l_hus HIG_USERS%ROWTYPE;
 PROCEDURE tidy_existing_data IS
 BEGIN
    --Deleting existing data
    append_log_content(pi_text => 'Tidying existing data');
 --   UPDATE HIG_USERS
 --   SET  hus_admin_unit = NULL;
 --   DELETE FROM NM_INV_NW_ALL;
 --	DELETE FROM NM_ADMIN_GROUPS;
 --   DELETE FROM NM_USER_AUS_ALL;
 --	DELETE FROM DOC_TEMPLATE_USERS;
 --   DELETE FROM DOCS;
 --   DELETE FROM HIG_USERS
 --   WHERE  hus_is_hig_owner_flag != 'Y';
 --   DELETE FROM NM_MEMBERS_ALL;
 --   DELETE FROM NM_ELEMENTS_ALL;
 --   DELETE FROM NM_ADMIN_UNITS_ALL;
 --   DELETE FROM NM_TYPE_SUBCLASS;
 --   DELETE FROM NM_TYPE_COLUMNS;
 --   DELETE FROM NM_TYPE_INCLUSION;
 --   DELETE FROM NM_NT_GROUPINGS_ALL;
 --   DELETE FROM NM_TYPES;
 --   DELETE FROM NM_AU_TYPES;
 --   UPDATE HIG_USERS
 --   SET   hus_start_date = g_mig_earliest_date;
    append_log_content(pi_text => 'Done');
 END tidy_existing_data;
--
-----------------------------------------------------------------------------
--
 PROCEDURE sort_aus_dates IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   CURSOR cs_nua IS
   SELECT *
    FROM  NM_USER_AUS_ALL
   FOR UPDATE;
--
   CURSOR cs_nau (c_id NUMBER) IS
   SELECT NVL(nau_end_date,Nm3type.c_big_date)
         ,nau_start_date
    FROM  NM_ADMIN_UNITS_ALL
   WHERE  nau_admin_unit = c_id;
--
   CURSOR cs_hus (c_id NUMBER) IS
   SELECT NVL(hus_end_date,Nm3type.c_big_date)
         ,hus_start_date
    FROM  HIG_USERS
   WHERE  hus_user_id = c_id;
--
   l_end_date1   DATE;
   l_end_date2   DATE;
   l_start_date1 DATE;
   l_start_date2 DATE;
 BEGIN
 append_log_content(pi_text => 'Sorting AUS dates');
 EXECUTE IMMEDIATE 'ALTER TRIGGER NM_USER_AUS_ALL_DT_TRG DISABLE';
    FOR cs_rec IN cs_nua
    LOOP
      cs_rec.nua_end_date := NVL(cs_rec.nua_end_date,Nm3type.c_big_date);
      OPEN  cs_nau (cs_rec.nua_admin_unit);
      FETCH cs_nau INTO l_end_date1,l_start_date1;
      CLOSE cs_nau;
      IF l_start_date1 > cs_rec.nua_start_date
       THEN
         cs_rec.nua_start_date := l_start_date1;
      END IF;
      IF cs_rec.nua_end_date > l_end_date1
       THEN
         cs_rec.nua_end_date := l_end_date1;
      END IF;
      OPEN  cs_hus (cs_rec.nua_admin_unit);
      FETCH cs_hus INTO l_end_date2,l_start_date2;
      CLOSE cs_hus;
      IF l_start_date2 > cs_rec.nua_start_date
       THEN
         cs_rec.nua_start_date := l_start_date2;
      END IF;
      IF cs_rec.nua_end_date > l_end_date2
       THEN
         cs_rec.nua_end_date := l_end_date2;
      END IF;
      UPDATE NM_USER_AUS_ALL
       SET   nua_start_date = cs_rec.nua_start_date
            ,nua_end_date   = DECODE(cs_rec.nua_end_date,Nm3type.c_big_date,NULL,cs_rec.nua_end_date)
      WHERE  CURRENT OF cs_nua;
   END LOOP;
 EXECUTE IMMEDIATE 'ALTER TRIGGER NM_USER_AUS_ALL_DT_TRG ENABLE';
 append_log_content(pi_text => 'Done');
 EXCEPTION
   WHEN OTHERS THEN
      EXECUTE IMMEDIATE 'ALTER TRIGGER NM_USER_AUS_ALL_DT_TRG ENABLE';
      RAISE_APPLICATION_ERROR(-20001,SQLERRM);
 END sort_aus_dates;
--
-----------------------------------------------------------------------------
--
 PROCEDURE create_new_au_hierarchy IS
   PROCEDURE hig_admin_units_view IS
   BEGIN
      append_log_content(pi_text => 'Re-creating HIG_ADMIN_UNITS view');
      EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW hig_admin_units'
           || CHR(10) ||'('
           || CHR(10) ||'hau_admin_unit,'
           || CHR(10) ||'hau_unit_code,'
           || CHR(10) ||'hau_level,'
           || CHR(10) ||'hau_authority_code,'
           || CHR(10) ||'hau_name,'
           || CHR(10) ||'hau_address1,'
           || CHR(10) ||'hau_address2,'
           || CHR(10) ||'hau_address3,'
           || CHR(10) ||'hau_address4,'
           || CHR(10) ||'hau_address5,'
           || CHR(10) ||'hau_phone,'
           || CHR(10) ||'hau_fax,'
           || CHR(10) ||'hau_comments,'
           || CHR(10) ||'hau_last_wor_no,'
           || CHR(10) ||'hau_start_date,'
           || CHR(10) ||'hau_end_date )'
           || CHR(10) ||'AS SELECT'
           || CHR(10) ||'nau_admin_unit,'
           || CHR(10) ||'nau_unit_code,'
           || CHR(10) ||'nau_level,'
           || CHR(10) ||'nau_authority_code,'
           || CHR(10) ||'nau_name,'
           || CHR(10) ||'nau_address1,'
           || CHR(10) ||'nau_address2,'
           || CHR(10) ||'nau_address3,'
           || CHR(10) ||'nau_address4,'
           || CHR(10) ||'nau_address5,'
           || CHR(10) ||'nau_phone,'
           || CHR(10) ||'nau_fax,'
           || CHR(10) ||'nau_comments,'
           || CHR(10) ||'nau_last_wor_no,'
           || CHR(10) ||'nau_start_date,'
           || CHR(10) ||'nau_end_date'
           || CHR(10) ||'FROM nm_admin_units'
           || CHR(10) ||'WHERE nau_admin_type ='''||g_admin_type||'''';
   END hig_admin_units_view;
 BEGIN
  append_log_content(pi_text => 'Creating Admin Hierarchy ['||g_admin_type||']');
  append_log_content(pi_text => 'NM_AU_TYPES');
  INSERT INTO NM_AU_TYPES
     (nat_admin_type, nat_descr)
  SELECT g_admin_type
        ,'Admin Type For Migrated NM2 Hierarchy'
   FROM   dual
  WHERE   NOT EXISTS (SELECT 1
                      FROM  NM_AU_TYPES
                      WHERE  nat_admin_type = g_admin_type
                      );
  append_log_content(pi_text => 'NM_ADMIN_UNITS_ALL');
  INSERT INTO NM_ADMIN_UNITS_ALL
        (nau_admin_unit
        ,nau_unit_code
        ,nau_level
        ,nau_authority_code
        ,nau_name
        ,nau_address1
        ,nau_address2
        ,nau_address3
        ,nau_address4
        ,nau_address5
        ,nau_phone
        ,nau_fax
        ,nau_comments
        ,nau_last_wor_no
        ,nau_start_date
        ,nau_end_date
        ,nau_admin_type
        )
  SELECT nau_admin_unit_seq.nextval
        ,hau_unit_code
        ,hau_level
        ,hau_authority_code
        ,hau_name
        ,hau_address1
        ,hau_address2
        ,hau_address3
        ,hau_address4
        ,hau_address5
        ,hau_phone
        ,hau_fax
        ,hau_comments
        ,hau_last_wor_no
        ,g_mig_earliest_date
        ,hau_end_date
        ,g_admin_type
   FROM  v2_hig_admin_units
   WHERE NOT EXISTS (SELECT 1
                      FROM  NM_ADMIN_UNITS_ALL
                      WHERE  nau_unit_code = hau_unit_code
                      );

--
   append_log_content(pi_text => 'HIG_USERS (highways owner)');
   DELETE FROM NM_MAIL_USERS;
   DELETE FROM HIG_USER_FAVOURITES;
   DELETE FROM HIG_SYSTEM_FAVOURITES;
   UPDATE HIG_USERS
   SET  hus_admin_unit = (SELECT nau_admin_unit
                          FROM  nm_admin_units
                          WHERE  nau_level = 1
                          AND   nau_admin_type = g_admin_type
                         )
	,hus_user_id=(SELECT hus_user_id FROM v2_hig_users
	              WHERE hus_username=UPPER(pi_v2_higowner))
   WHERE hus_is_hig_owner_flag = 'Y';
   INSERT INTO HIG_USER_FAVOURITES
   SELECT HUs_USER_ID ,'ROOT', 'FAVOURITES', 'System Administrators Favourite Modules', 'F'
   FROM HIG_USERS WHERE hus_is_hig_owner_flag = 'Y';

   INSERT INTO HIG_SYSTEM_FAVOURITES
   SELECT HUs_USER_ID ,'ROOT', 'FAVOURITES', 'System Favourites', 'F'
   FROM HIG_USERS WHERE hus_is_hig_owner_flag = 'Y';

   INSERT INTO NM_MAIL_USERS
   SELECT 1, 'Network Manager 3', 'nm3@yourdomain.com', hus_user_id
   FROM HIG_USERS WHERE hus_is_hig_owner_flag = 'Y';

COMMIT;


COMMIT;


---
   append_log_content(pi_text => 'NM_ADMIN_GROUPS');
   INSERT INTO NM_ADMIN_GROUPS
      (nag_parent_admin_unit
      ,nag_child_admin_unit
      ,nag_direct_link
      )
   SELECT hag_parent_admin_unit
         ,hag_child_admin_unit
         ,hag_direct_link
   FROM   v2_hig_admin_groups
   WHERE NOT EXISTS (SELECT 1
                      FROM  NM_ADMIN_GROUPS
                      WHERE NAG_PARENT_ADMIN_UNIT = hag_parent_admin_unit
		      AND   NAG_CHILD_ADMIN_UNIT = hag_child_admin_unit
		      AND   NAG_DIRECT_LINK = hag_direct_link
                      )
   UNION
   select nau_admin_unit,nau_admin_unit,'N'
   from nm_admin_units,v2_hig_admin_units
   where nau_unit_code = hau_unit_code
   AND NOT EXISTS (SELECT 1
                      FROM  NM_ADMIN_GROUPS
                      WHERE NAG_PARENT_ADMIN_UNIT = nau_admin_unit
		      AND   NAG_CHILD_ADMIN_UNIT = nau_admin_unit
		      AND   NAG_DIRECT_LINK = 'N'
                      );
   --SELECT nm3get.get_nau(pi_nau_unit_code => get_new_nau(hau_admin_unit),pi_nau_admin_type => g_admin_type).nau_admin_unit
   --      ,nm3get.get_nau(pi_nau_unit_code => get_new_nau(hau_admin_unit),pi_nau_admin_type => g_admin_type).nau_admin_unit
   --      ,'N'
   --FROM   v2_hig_admin_units;
---
   append_log_content(pi_text => 'HIG_USERS (other)');
   FOR irec IN get_other_users LOOP
     l_hus.hus_user_id           := irec.hus_user_id;
     l_hus.hus_initials          := irec.hus_initials;
     l_hus.hus_name              := irec.hus_name;
     l_hus.hus_username          := UPPER(irec.hus_username);
     l_hus.hus_job_title         := irec.hus_job_title;
     l_hus.hus_agent_code        := irec.hus_agent_code;
     l_hus.hus_wor_flag          := irec.hus_wor_flag;
     l_hus.hus_wor_value_min     := irec.hus_wor_value_min;
     l_hus.hus_wor_value_max     := irec.hus_wor_value_max;
     IF irec.hus_start_date IS NULL THEN
       l_hus.hus_start_date := g_mig_earliest_date;
     ELSE
       l_hus.hus_start_date := TRUNC(LEAST(irec.hus_start_date, NVL(irec.hus_end_date, irec.hus_start_date)));
     END IF;
     IF irec.hus_end_date IS NOT NULL THEN
       l_hus.hus_end_date := GREATEST(irec.hus_end_date, NVL(irec.hus_start_date, g_mig_earliest_date));
     ELSE
        l_hus.hus_end_date := NULL;
     END IF;
     l_hus.hus_admin_unit        := nm3get.get_nau(pi_nau_unit_code => get_new_nau(irec.hus_admin_unit),pi_nau_admin_type => g_admin_type).nau_admin_unit;
     l_hus.hus_wor_aur_min       := irec.hus_wor_aur_min;
     l_hus.hus_wor_aur_max       := irec.hus_wor_aur_max;
     IF g_debug THEN
       Nm3debug.debug_hus(pi_rec_hus => l_hus);
     END IF;
     Nm3ins.ins_hus(l_hus);
   END LOOP;
--
  append_log_content(pi_text => 'HIG_PRODUCTS');
  INSERT INTO HIG_PRODUCTS
      (hpr_product
      ,hpr_product_name
      ,hpr_version
      ,hpr_path_name
      ,hpr_key
      ,hpr_sequence
      ,hpr_image
      ,hpr_user_menu
      ,hpr_launchpad_icon
      ,hpr_image_type
      )
  SELECT DECODE(hpr_product, 'STP', 'PMS', hpr_product) hpr_product
      ,hpr_product_name
      ,hpr_version
      ,hpr_path_name
      ,hpr_key
      ,hpr_sequence
      ,hpr_image
      ,hpr_user_menu
      ,hpr_launchpad_icon
      ,hpr_image_type
  FROM v2_hig_products hpr_r
  WHERE NOT EXISTS (SELECT 1
                    FROM  HIG_PRODUCTS hpr_g
                    WHERE  hpr_g.hpr_product = hpr_r.hpr_product
                   );
-- update hig_products with v2 hig product settings
/*  UPDATE HIG_PRODUCTS v3
  SET    (hpr_product_name
        ,hpr_path_name
        ,hpr_key
        ,hpr_sequence
        ,hpr_image
        ,hpr_image_type
        ,hpr_user_menu
        ,hpr_launchpad_icon) =
        (SELECT DECODE(hpr_product, 'STP', 'structural projects v2', hpr_product_name)
               ,hpr_path_name
               ,DECODE(v2.hpr_key, NULL, v3.hpr_key, v2.hpr_key) hpr_key -- for some street works customers NET may not be licenced
               ,hpr_sequence
               ,hpr_image
               ,hpr_image_type
               ,hpr_user_menu
               ,hpr_launchpad_icon
         FROM   v2_hig_products v2
         WHERE  DECODE(v3.hpr_product, 'STP', 'PMS', v3.hpr_product) = DECODE(v2.hpr_product, 'STP', 'PMS', v2.hpr_product)
         AND    v2.hpr_product != 'PMS'
         )
         WHERE EXISTS (SELECT 1
                       FROM   v2_hig_products v2_check
                       WHERE  DECODE(v2_check.hpr_product, 'STP', 'PMS', v2_check.hpr_product) = v3.hpr_product);
*/
--  now update the PMS code. It was Pavement Manager in V2 but in V3 its STP v2
  UPDATE HIG_PRODUCTS
  SET    hpr_product_name = 'structural projects v2'
  WHERE  hpr_product = 'PMS';
  append_log_content(pi_text => 'HIG_ROLES');
  INSERT INTO HIG_ROLES
      (hro_role
      ,hro_product
      ,hro_descr
      )
  SELECT hro_role
      ,hro_product
      ,hro_descr
  FROM  v2_hig_roles hro_r
  WHERE  NOT EXISTS (SELECT 1
                     FROM  HIG_ROLES hro_g
                     WHERE  hro_r.hro_role = hro_g.hro_role
                    );
--
  append_log_content(pi_text => 'HIG_USER_ROLES');
  INSERT INTO HIG_USER_ROLES(hur_username
                            ,hur_role
                            ,hur_start_date)
                     SELECT  v3_hus.hus_username
                            ,hro.hro_role
                            ,TRUNC(SYSDATE)
                     FROM    HIG_USERS         v3_hus
                            ,v2_hig_users      v2_hus
                            ,v2_dba_role_privs privs
                            ,HIG_ROLES hro
                     WHERE   v2_hus.hus_user_id = v3_hus.hus_user_id
                     AND     privs.grantee      = v2_hus.hus_username
                     AND     hro.hro_role       = privs.granted_role
                     AND NOT EXISTS (SELECT 'x'
                                     FROM   HIG_USER_ROLES
                                     WHERE  hur_username = v3_hus.hus_username
                                     AND    hur_role     = hro.hro_role);
  append_log_content(pi_text => 'NM_USER_AUS_ALL');
  FOR irec IN get_user_admin_units LOOP
    l_nua.nua_user_id    := irec.nua_user_id;
    l_nua.nua_admin_unit := irec.nua_admin_unit;
    l_nua.nua_start_date := GREATEST(NVL(irec.nau_start_date, g_mig_earliest_date), irec.hus_start_date);
    IF irec.hus_end_date IS NOT NULL THEN
      IF irec.nau_end_date IS NOT NULL THEN
        l_nua.nua_end_date := GREATEST(LEAST(irec.hus_end_date, irec.nau_end_date), l_nua.nua_start_date);
      ELSE
        l_nua.nua_end_date := irec.hus_end_date;
      END IF;
    ELSE
      IF irec.nau_end_date IS NOT NULL THEN
        l_nua.nua_end_date := irec.nau_end_date;
      ELSE
        l_nua.nua_end_date := NULL;
      END IF;
    END IF;
    l_nua.nua_mode       := irec.nua_mode;
    IF g_debug THEN
      Nm3debug.debug_nua(l_nua);
    END IF;
    Nm3ins.ins_nua(p_rec_nua => l_nua);
  END LOOP;
  --  sort_aus_dates;
  hig_admin_units_view;
  append_log_content(pi_text => 'Done');
 END create_new_au_hierarchy;
--
-----------------------------------------------------------------------------
--
BEGIN
--
 g_proc_name := 'process_admin_units';
 append_proc_start_to_log;
--
 tidy_existing_data;
 create_new_au_hierarchy;
 do_optional_commit;
--
 append_proc_end_to_log;
--
END process_admin_units;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_hig_data IS
  fin_year_count NUMBER;
  interval_count NUMBER;

BEGIN
--
  g_proc_name := 'process_hig_data';
  append_proc_start_to_log;
--
  append_log_content(pi_text => 'HIG_DOMAINS');
  INSERT INTO HIG_DOMAINS
      (hdo_domain
      ,hdo_product
      ,hdo_title
      ,hdo_code_length
      )
  SELECT hdo_domain
      ,hdo_product
      ,hdo_title
      ,hdo_code_length
  FROM  v2_hig_domains hdo_r
  WHERE  NOT EXISTS (SELECT 1
                    FROM  HIG_DOMAINS hdo_g
                   WHERE  hdo_g.hdo_domain = hdo_r.hdo_domain
                  );
--
   append_log_content(pi_text => 'HIG_CODES');
   INSERT INTO HIG_CODES
         (hco_domain
         ,hco_code
         ,hco_meaning
         ,hco_system
         ,hco_seq
         ,hco_start_date
         ,hco_end_date
         )
   SELECT hco_domain
         ,hco_code
         ,hco_meaning
         ,hco_system
         ,hco_seq
         ,TRUNC(hco_start_date)
         ,hco_end_date
    FROM  v2_hig_codes hco_r
   WHERE  NOT EXISTS (SELECT 1
                        FROM  HIG_CODES hco_g
                       WHERE  hco_r.hco_domain = hco_g.hco_domain
                         AND   hco_r.hco_code   = hco_g.hco_code
                     );
--
  append_log_content(pi_text => 'HIG_MODULES');
  INSERT INTO HIG_MODULES
      (hmo_module
      ,hmo_title
      ,hmo_filename
      ,hmo_module_type
      ,hmo_fastpath_opts
      ,hmo_fastpath_invalid
      ,hmo_use_gri
      ,hmo_application
      ,hmo_menu
      )
  SELECT hmo_module
      ,hmo_title
      ,hmo_filename
      ,hmo_module_type
      ,hmo_fastpath_opts
      ,hmo_fastpath_invalid
      ,hmo_use_gri
      ,DECODE(hmo_application, 'STP', 'PMS', hmo_application) hmo_application
      ,hmo_menu
 FROM  v2_hig_modules hmo_r
 WHERE  NOT EXISTS (SELECT 1
                    FROM  HIG_MODULES hmo_g
                   WHERE  hmo_r.hmo_module = hmo_g.hmo_module
                  );
--
  append_log_content(pi_text => 'HIG_MODULE_ROLES');
  INSERT INTO HIG_MODULE_ROLES
      (hmr_module
      ,hmr_role
      ,hmr_mode
      )
  SELECT hmr_module
      ,hmr_role
      ,hmr_mode
  FROM  v2_hig_module_roles hmr_r
  WHERE  NOT EXISTS (SELECT 1
                    FROM  HIG_MODULE_ROLES hmr_g
                   WHERE  hmr_r.hmr_module = hmr_g.hmr_module
                    AND   hmr_r.hmr_role   = hmr_g.hmr_role
                  );
--
  append_log_content(pi_text => 'HIG_STATUS_DOMAINS');
  INSERT INTO HIG_STATUS_DOMAINS
      (hsd_domain_code
      ,hsd_product
      ,hsd_description
      ,hsd_feature1
      ,hsd_feature2
      ,hsd_feature3
      ,hsd_feature4
      ,hsd_feature5
      ,hsd_feature6
      ,hsd_feature7
      ,hsd_feature8
      ,hsd_feature9
      )
  SELECT hsd_domain_code
      ,hsd_product
      ,hsd_description
      ,hsd_feature1
      ,hsd_feature2
      ,hsd_feature3
      ,hsd_feature4
      ,hsd_feature5
      ,hsd_feature6
      ,hsd_feature7
      ,hsd_feature8
      ,hsd_feature9
  FROM  v2_hig_status_domains hsd_r
  WHERE  NOT EXISTS (SELECT 1
                     FROM  HIG_STATUS_DOMAINS hsd_g
                     WHERE  hsd_r.hsd_domain_code = hsd_g.hsd_domain_code
                    );
--
  append_log_content(pi_text => 'HIG_STATUS_CODES');
  INSERT INTO HIG_STATUS_CODES
      (hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date
      )
  SELECT hsc_domain_code
      ,hsc_status_code
      ,hsc_status_name
      ,hsc_seq_no
      ,hsc_allow_feature1
      ,hsc_allow_feature2
      ,hsc_allow_feature3
      ,hsc_allow_feature4
      ,hsc_allow_feature5
      ,hsc_allow_feature6
      ,hsc_allow_feature7
      ,hsc_allow_feature8
      ,hsc_allow_feature9
      ,hsc_start_date
      ,hsc_end_date
  FROM v2_hig_status_codes hsc_r
  WHERE NOT EXISTS (SELECT 1
                    FROM   HIG_STATUS_CODES hsc_g
                    WHERE  hsc_r.hsc_domain_code = hsc_g.hsc_domain_code
                    AND    hsc_r.hsc_status_code = hsc_g.hsc_status_code
                   );
  append_log_content(pi_text => 'HIG_OPTIONS');
  INSERT INTO hig_options
        (hop_id
        ,hop_product
        ,hop_name
        ,hop_value
        ,hop_remarks
        ,hop_mixed_case
        )
  SELECT hop_id
        ,hop_product
        ,hop_name
        ,hop_value
        ,hop_remarks
        ,'Y' -- there was no concept of upper or middle case in nm2 so default to mixed
   FROM  v2_hig_options hop_r
  WHERE  NOT EXISTS (SELECT 1
                     FROM   hig_options hop_g
                     WHERE  hop_r.hop_id = hop_g.hop_id
                    );
  UPDATE HIG_OPTION_LIST
  SET hol_user_option = 'Y'
  WHERE EXISTS (SELECT 'x'
              FROM HIG_CODES
              WHERE hco_domain = 'USER_OPTIONS'
              AND  hco_code = hol_id);
-----------------------------------------------------------------------------
  INSERT INTO HIG_OPTION_VALUES
  (hov_id
  ,hov_value
  )
  SELECT hop_id
        ,UPPER(hop_value) hop_value
  FROM   v2_hig_options
  WHERE NOT EXISTS (SELECT 1
                    FROM HIG_OPTION_VALUES
                    WHERE hov_id = hop_id);
  UPDATE /*+ ORDERED USE_NL (hov v2where)  */ HIG_OPTION_VALUES hov
  SET hov.hov_value = (SELECT UPPER(hop_value) hop_value
                       FROM   v2_hig_options v2
                       WHERE  v2.hop_id = hov.hov_id)
  WHERE hov.hov_id IN (SELECT v2where.hop_id
                       FROM   v2_hig_options v2where
                       WHERE  hov.hov_id = v2where.hop_id
                       AND    v2where.hop_value != hov.hov_value);
--
  UPDATE hig_options
   SET   hop_value = 1
  WHERE  hop_id    = 'DEFUNITID';
--
  append_log_content(pi_text => 'HIG_USER_OPTIONS');
  DELETE FROM HIG_USER_OPTIONS;
--
  INSERT INTO HIG_USER_OPTIONS
        (huo_hus_user_id
        ,huo_id
        ,huo_value
        )
  SELECT huo_hus_user_id
        ,huo_id
        ,huo_value
  FROM  v2_hig_user_options
  WHERE  EXISTS (SELECT 1
                 FROM  HIG_USERS
                 WHERE  hus_user_id = huo_hus_user_id
                );
--
  append_log_content(pi_text => 'HIG_HOLIDAYS');
  DELETE FROM HIG_HOLIDAYS;
--
  INSERT INTO HIG_HOLIDAYS
        (hho_id
        ,hho_name
        )
  (SELECT hho_id
        ,hho_name
  FROM  v2_hig_holidays);
--
  append_log_content(pi_text => 'HIG_ADDRESS');
  INSERT INTO HIG_ADDRESS
        (had_id
        ,had_department
        ,had_po_box
        ,had_organisation
        ,had_sub_building_name_no
        ,had_building_name
        ,had_building_no
        ,had_dependent_thoroughfare
        ,had_thoroughfare
        ,had_double_dep_locality_name
        ,had_dependent_locality_name
        ,had_post_town
        ,had_county
        ,had_postcode
        ,had_osapr
        ,had_xco
        ,had_yco
        ,had_notes
        ,had_property_type
        )
  SELECT had_id
        ,had_department
        ,had_po_box
        ,had_organisation
        ,had_sub_building_name_no
        ,had_building_name
        ,had_building_no
        ,had_dependent_thoroughfare
        ,had_thoroughfare
        ,had_double_dep_locality_name
        ,had_dependent_locality_name
        ,had_post_town
        ,had_county
        ,had_postcode
        ,had_osapr
        ,had_xco
        ,had_yco
        ,had_notes
        ,had_property_type
  FROM  v2_hig_address had_2
  WHERE  NOT EXISTS (SELECT 1
                     FROM  HIG_ADDRESS had_3
                     WHERE  had_3.had_id = had_2.had_id);
--
  append_log_content(pi_text => 'HIG_CONTACTS');
  INSERT INTO HIG_CONTACTS(hct_id
                          ,hct_org_or_person_flag
                          ,hct_vip
                          ,hct_title
                          ,hct_salutation
                          ,hct_first_name
                          ,hct_middle_initial
                          ,hct_surname
                          ,hct_organisation
                          ,hct_home_phone
                          ,hct_work_phone
                          ,hct_mobile_phone
                          ,hct_fax
                          ,hct_pager
                          ,hct_email
                          ,hct_occupation
                          ,hct_employer
                          ,hct_date_of_birth
                          ,hct_start_date
                          ,hct_end_date
                          ,hct_notes
                          )
                 SELECT    hct_id
                          ,hct_org_or_person_flag
                          ,hct_vip
                          ,hct_title
                          ,hct_salutation
                          ,hct_first_name
                          ,hct_middle_initial
                          ,hct_surname
                          ,hct_organisation
                          ,hct_home_phone
                          ,hct_work_phone
                          ,hct_mobile_phone
                          ,hct_fax
                          ,hct_pager
                          ,hct_email
                          ,hct_occupation
                          ,hct_employer
                          ,hct_date_of_birth
                          ,hct_start_date
                          ,hct_end_date
                          ,hct_notes
     FROM  v2_hig_contacts hct_2
     WHERE  NOT EXISTS (SELECT 1
                        FROM  HIG_CONTACTS hct_3
                        WHERE  hct_3.hct_id = hct_2.hct_id);
--
  append_log_content(pi_text => 'HIG_CONTACT_ADDRESS');
  INSERT INTO HIG_CONTACT_ADDRESS(hca_hct_id
                                 ,hca_had_id
                                 )
                           SELECT DISTINCT hca_hct_id
                                           ,hca_had_id
                           FROM  v2_hig_contact_address hca_2
                           WHERE  NOT EXISTS (SELECT 1
                                              FROM  HIG_CONTACT_ADDRESS hca_3
                                              WHERE hca_3.hca_hct_id = hca_2.hca_hct_id
                                              AND   hca_3.hca_had_id = hca_2.hca_had_id);
--
  append_log_content(pi_text => 'HIG_ADDRESS_POINT');
  DELETE HIG_ADDRESS_POINT;
  INSERT INTO HIG_ADDRESS_POINT
  SELECT *
  FROM v2_hig_address_point ha;

  append_log_content(pi_text => 'INTERVALS');
  DELETE INTERVALS;
  INSERT INTO INTERVALS
  SELECT *
  FROM v2_intervals;

  SELECT COUNT(*)
  INTO interval_count
  FROM INTERVALS;

  IF interval_count=0 THEN  --insert some intervals
  INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '100'
       ,'None'
       ,NULL
       ,'None'
       ,NULL
       ,NULL
       ,NULL
       ,0
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '100');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '101'
       ,'Not Set'
       ,NULL
       ,'Not Set'
       ,NULL
       ,NULL
       ,NULL
       ,0
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '101');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '224'
       ,'24 Hours'
       ,NULL
       ,'24 Hours'
       ,NULL
       ,NULL
       ,NULL
       ,24
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '224');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '301'
       ,' 1 Days'
       ,1
       ,' 1 Days'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '301');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '305'
       ,' 5 Days'
       ,5
       ,' 5 Days'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '305');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '307'
       ,' 7 Days'
       ,7
       ,' 7 Days'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '307');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '314'
       ,'14 Days'
       ,14
       ,'14 Days'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '314');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '321'
       ,'21 Days'
       ,21
       ,'21 Days'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '321');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '328'
       ,'28 Days'
       ,28
       ,'28 Days'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '328');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '335'
       ,'35 Days'
       ,35
       ,'35 Days'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '335');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '401'
       ,' 1 Months'
       ,NULL
       ,' 1 Months'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,1
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '401');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '403'
       ,' 3 Months'
       ,NULL
       ,' 3 Months'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,3
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '403');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '406'
       ,' 6 Months'
       ,NULL
       ,' 6 Months'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,6
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '406');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '412'
       ,'12 Months'
       ,NULL
       ,'12 Months=4000hrs'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,12
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '412');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '418'
       ,'18 Months'
       ,NULL
       ,'18 Months=6000hrs'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,18
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '418');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '424'
       ,'24 Months'
       ,NULL
       ,'24 Months=8000hrs'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,24
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '424');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '430'
       ,'8000 Hr/9hr/Day'
       ,NULL
       ,'30 Months'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,30
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '430');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '501'
       ,' 1 Year'
       ,NULL
       ,' 1 Year'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,1
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '501');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '502'
       ,' 2 Years'
       ,NULL
       ,' 2 Years'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,2
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '502');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '503'
       ,' 3 Years'
       ,NULL
       ,' 3 Years'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,3
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '503');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '505'
       ,' 5 Years'
       ,NULL
       ,' 5 Years'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,5
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '505');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '506'
       ,' 6 Years'
       ,NULL
       ,' 6 Years'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,6
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '506');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '507'
       ,' 7 Years'
       ,NULL
       ,' 7 Years'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,7
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '507');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '510'
       ,'10 Years'
       ,NULL
       ,'10 Years'
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,10
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '510');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '700'
       ,'0 Per Year'
       ,NULL
       ,'Frequency  0 Per Year'
       ,NULL
       ,NULL
       ,0
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '700');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '701'
       ,'1 Per Year'
       ,NULL
       ,'Frequency  1 Per Year'
       ,NULL
       ,NULL
       ,1
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '701');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '702'
       ,'2 Per Year'
       ,NULL
       ,'Frequency  2 Per Year'
       ,NULL
       ,NULL
       ,2
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '702');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '703'
       ,'3 Per Year'
       ,NULL
       ,'Frequency  3 Per Year'
       ,NULL
       ,NULL
       ,3
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '703');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '704'
       ,'4 Per Year'
       ,NULL
       ,'Frequency  4 Per Year'
       ,NULL
       ,NULL
       ,4
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '704');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '705'
       ,'5 Per Year'
       ,NULL
       ,'Frequency  5 Per Year'
       ,NULL
       ,NULL
       ,5
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '705');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '706'
       ,'6 Per Year'
       ,NULL
       ,'Frequency  6 Per Year'
       ,NULL
       ,NULL
       ,6
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '706');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '707'
       ,'7 Per Year'
       ,NULL
       ,'Frequency  7 Per Year'
       ,NULL
       ,NULL
       ,7
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '707');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '708'
       ,'8 Per Year'
       ,NULL
       ,'Frequency  8 Per Year'
       ,NULL
       ,NULL
       ,8
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '708');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '709'
       ,'9 Per Year'
       ,NULL
       ,'Frequency  9 Per Year'
       ,NULL
       ,NULL
       ,9
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '709');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '710'
       ,'10 Per Year'
       ,NULL
       ,'Frequency 10 Per Year'
       ,NULL
       ,NULL
       ,10
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '710');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '801'
       ,'1 Per Month'
       ,NULL
       ,'Frequency 1 Per Month'
       ,1
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '801');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '901'
       ,'1 Per Week'
       ,NULL
       ,'Frequency 1 Per Week'
       ,NULL
       ,1
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '901');
--
INSERT INTO INTERVALS
       (INT_CODE
       ,INT_TRANSLATION
       ,INT_DAYS
       ,INT_DESCR
       ,INT_FREQ_PER_MONTH
       ,INT_FREQ_PER_WEEK
       ,INT_FREQ_PER_YEAR
       ,INT_HRS
       ,INT_MONTHS
       ,INT_YRS
       ,INT_START_DATE
       ,INT_END_DATE
       )
SELECT
        '999'
       ,'1 Hour'
       ,NULL
       ,'1 hour'
       ,NULL
       ,NULL
       ,NULL
       ,1
       ,NULL
       ,NULL
       ,NULL
       ,NULL FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM INTERVALS
                   WHERE INT_CODE = '999');

  END IF;


  append_log_content(pi_text => 'FINANCIAL_YEARS');
  DELETE FINANCIAL_YEARS;
  INSERT INTO FINANCIAL_YEARS
  SELECT *
  FROM v2_financial_years fy;

  SELECT COUNT(*)
  INTO fin_year_count
  FROM FINANCIAL_YEARS;

  IF fin_year_count=0 THEN  --insert some years

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1991'
   ,TO_DATE('19910401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19920331000000','YYYYMMDDHH24MISS')
   FROM dual;
   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1992'
   ,TO_DATE('19920401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19930331000000','YYYYMMDDHH24MISS')
   FROM dual;
   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1993'
   ,TO_DATE('19930401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19940331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1994'
   ,TO_DATE('19940401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19950331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1995'
   ,TO_DATE('19950401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19960331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1996'
   ,TO_DATE('19960401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19970331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1997'
   ,TO_DATE('19970401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19980331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1998'
   ,TO_DATE('19980401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('19990331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '1999'
   ,TO_DATE('19990401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20000331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2000'
   ,TO_DATE('20000401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20010331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2001'
   ,TO_DATE('20010401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20020331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2002'
   ,TO_DATE('20020401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20030331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2003'
   ,TO_DATE('20030401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20040331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2004'
   ,TO_DATE('20040401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20050331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2005'
   ,TO_DATE('20050401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20060331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2006'
   ,TO_DATE('20060401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20070331000000','YYYYMMDDHH24MISS')
   FROM dual;

   INSERT INTO FINANCIAL_YEARS (
   FYR_ID
   ,FYR_START_DATE
   ,FYR_END_DATE
   ) SELECT
   '2007'
   ,TO_DATE('20070401000000','YYYYMMDDHH24MISS')
   ,TO_DATE('20080331000000','YYYYMMDDHH24MISS')
   FROM dual;




  END IF;



--
  do_optional_commit;
--
 append_proc_end_to_log;
--
END process_hig_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE oracle_users_roles_privs IS
  CURSOR c_higowner IS
  SELECT *
  FROM   dba_users
  WHERE  username = USER;
  rec_higowner dba_users%ROWTYPE;
  -- get users
  -- we are only intessted in creating and updating existing users
  CURSOR get_users IS
  SELECT hus_user_id, username
  FROM   HIG_USERS
        ,all_users
  WHERE username (+) = hus_username
  AND SYSDATE BETWEEN hus_start_date AND NVL(hus_end_date, SYSDATE);
  CURSOR c2 IS
  SELECT *
  FROM  HIG_ROLES
  WHERE NOT EXISTS (SELECT 'oracle role'
                    FROM    dba_roles
                    WHERE   ROLE = hro_role);
  CURSOR c3(cp_role VARCHAR2) IS
  SELECT PRIVILEGE
  FROM  v2_role_sys_privs
  WHERE ROLE=cp_role;
  CURSOR c4 IS
  SELECT hus_username
        ,hur_role
  FROM   HIG_USERS  hus
        ,HIG_USER_ROLES hur
  WHERE  hus.hus_username = hur.hur_username
  AND SUBSTR(hus.hus_username,1,11)!='NO_USERNAME'
  AND SYSDATE BETWEEN hus_start_date AND NVL(hus_end_date, SYSDATE)
  AND NOT EXISTS (SELECT 'user has this oracle role'
                  FROM   dba_role_privs
                  WHERE  grantee=hus.hus_username);
  l_hus                   HIG_USERS%ROWTYPE;
  l_password              dba_users.PASSWORD%TYPE;
  success_with_comp_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(success_with_comp_error, -24344);
--
  FUNCTION get_password(pi_user      IN VARCHAR2
                       ,pio_password IN OUT VARCHAR2) RETURN BOOLEAN IS
    CURSOR get_pass(p_user IN VARCHAR2) IS
    SELECT PASSWORD
    FROM   v2_dba_users
    WHERE  username = p_user;
    l_found BOOLEAN := FALSE;
  BEGIN
    OPEN get_pass(pi_user);
    FETCH get_pass INTO pio_password;
    IF get_pass%FOUND THEN
      l_found := TRUE;
    END IF;
    CLOSE get_pass;
    RETURN l_found;
  END get_password;
--
BEGIN
--
  g_proc_name := 'oracle_users_roles_privs';
  append_proc_start_to_log;
--
  append_log_content(pi_text => 'CREATING ANY MISSING USERS');
  append_log_content(pi_text => '==========================');
  ----------------------
  -- Missing users
  ----------------------
  OPEN c_higowner;
  FETCH c_higowner INTO rec_higowner;
  CLOSE c_higowner;
  FOR i_rec IN get_users LOOP
    l_hus := Nm3get.get_hus(pi_hus_user_id => i_rec.hus_user_id);
    -- get_users is an outer joing to all_users
    -- so if the username column is null then the username does not exist
    -- otherwise it exists but is an NM2 user so it will not have the
    -- instanitate_user trigger
	--however we dont want to create a load of nousername accounts so
	IF SUBSTR(l_hus.hus_username,1,11)!='NO_USERNAME' THEN
      IF i_rec.username IS NULL THEN
         Nm3ddl.create_user (p_rec_hus            => l_hus
                            ,p_password           => l_hus.hus_username
                            ,p_default_tablespace => rec_higowner.default_tablespace
                            ,p_temp_tablespace    => rec_higowner.temporary_tablespace
                            ,p_default_quota      => 'UNLIMITED'
                            ,p_profile            => rec_higowner.PROFILE
                            );
         append_log_content(pi_text => 'CREATED USER ['||l_hus.hus_username||']  PASSWORD ['||l_hus.hus_username||']');
         Grant_Role_To_User(p_user => l_hus.hus_username
                           ,p_role => 'HIG_USER');

		 INSERT INTO HIG_USER_ROLES
		 (HUR_USERNAME, HUR_ROLE, HUR_START_DATE)
		 SELECT
		 l_hus.hus_username,'HIG_USER',l_hus.hus_start_date
		 FROM dual
		 WHERE NOT EXISTS
		 (SELECT 'x' FROM HIG_USER_ROLES
		 WHERE hur_username=l_hus.hus_username
		 AND hur_role='HIG_USER');


         IF get_password(l_hus.hus_username, l_password) THEN
           EXECUTE IMMEDIATE('ALTER USER '||l_hus.hus_username||' IDENTIFIED BY VALUES '''||l_password||'''');
         END IF;
      END IF;
      -- so for all users create this trigger
      BEGIN
        Nm3context.create_instantiate_user_trig(pi_new_trigger_owner => l_hus.hus_username);
      EXCEPTION
        -- ignore compilation errors on this
        -- as they should fall into place later
        WHEN success_with_comp_error THEN
          NULL;
      END;
	END IF;
  END LOOP;
  ----------------------
  -- Missing roles/privs
  ----------------------
  append_log_content(NULL);
  append_log_content(NULL);
  append_log_content(pi_text => 'CREATING ANY MISSING ROLES');
  append_log_content(pi_text => '==========================');
  FOR v_hro IN c2 LOOP
     EXECUTE IMMEDIATE('CREATE ROLE '||v_hro.hro_role);
     append_log_content(pi_text => 'CREATED ROLE ['||v_hro.hro_role||']');
     FOR v_privs IN c3(v_hro.hro_role) LOOP
       EXECUTE IMMEDIATE('GRANT '||v_privs.PRIVILEGE||' TO '||v_hro.hro_role);
     END LOOP;
  END LOOP;
  ---------------------------
  -- Assigning roles to users
  ---------------------------
  append_log_content(NULL);
  append_log_content(NULL);
  append_log_content(pi_text => 'ASSIGNING MISSING ROLES TO USERS');
  append_log_content(pi_text => '================================');
  FOR v_hur IN c4 LOOP
    Grant_Role_To_User(p_user => v_hur.hus_username
                      ,p_role => v_hur.hur_role);
  END LOOP;
--
 append_proc_end_to_log;
--
END oracle_users_roles_privs;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_doc_data IS
BEGIN
--
 g_proc_name := 'process_doc_data';
 append_proc_start_to_log;
--
append_log_content(pi_text => 'DOC_GATEWAYS');
INSERT INTO DOC_GATEWAYS
(
 dgt_table_name
,dgt_table_descr
,dgt_pk_col_name
,dgt_lov_descr_list
,dgt_lov_from_list
,dgt_lov_join_condition
,dgt_expand_module
,dgt_start_date
,dgt_end_date
)
SELECT
 dgt_table_name
,dgt_table_descr
,dgt_pk_col_name
,dgt_lov_descr_list
,dgt_lov_from_list
,dgt_lov_join_condition
,dgt_expand_module
,dgt_start_date
,dgt_end_date
FROM v2_doc_gateways v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_GATEWAYS v3
                  WHERE  v3.dgt_table_name= v2.dgt_table_name
                 );
--
--
--
append_log_content(pi_text => 'DOC_GATE_SYNS');
INSERT INTO DOC_GATE_SYNS
(
 dgs_dgt_table_name
,dgs_table_syn
)
SELECT
 dgs_dgt_table_name
,dgs_table_syn
FROM v2_doc_gate_syns v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_GATE_SYNS v3
                  WHERE  v3.dgs_dgt_table_name= v2.dgs_dgt_table_name
                  AND    v3.dgs_table_syn= v2.dgs_table_syn
                 );
--
--
--
append_log_content(pi_text => 'DOC_KEYWORDS');
INSERT INTO DOC_KEYWORDS
(
 dkw_key_id
)
SELECT
 dkw_key_id
FROM v2_doc_keywords v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_KEYWORDS v3
                  WHERE  v3.dkw_key_id= v2.dkw_key_id
                 );
--
append_log_content(pi_text => 'DOC_LOV_RECS');
INSERT INTO DOC_LOV_RECS
(
 dlr_rec_id
,dlr_rec_descr
,dlr_sessionid
)
SELECT
 dlr_rec_id
,dlr_rec_descr
,dlr_sessionid
FROM v2_doc_lov_recs v2;
--
append_log_content(pi_text => 'DOC_MEDIA');
INSERT INTO DOC_MEDIA
(
 dmd_id
,dmd_name
,dmd_descr
,dmd_display_command
,dmd_scan_command
,dmd_image_command1
,dmd_image_command2
,dmd_image_command3
,dmd_image_command4
,dmd_image_command5
,dmd_file_extension
,dmd_start_date
,dmd_end_date
)
SELECT
 dmd_id
,decode(dmd_name,'MORE','MORE v2',dmd_name)
,dmd_descr
,dmd_display_command
,dmd_scan_command
,dmd_image_command1
,dmd_image_command2
,dmd_image_command3
,dmd_image_command4
,dmd_image_command5
,dmd_file_extension
,dmd_start_date
,dmd_end_date
FROM v2_doc_media v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_MEDIA v3
                  WHERE  v3.dmd_id= v2.dmd_id
                 );
--
--
append_log_content(pi_text => 'DOC_LOCATIONS');
DELETE FROM DOC_TEMPLATE_COLUMNS;
delete from doc_template_users;
DELETE FROM DOC_TEMPLATE_GATEWAYS;
DELETE FROM DOC_LOCATIONS;
INSERT INTO DOC_LOCATIONS
(
 dlc_id
,dlc_name
,dlc_pathname
,dlc_dmd_id
,dlc_descr
,dlc_start_date
,dlc_end_date
,dlc_apps_pathname
,dlc_url_pathname
)
SELECT
 dlc_id
,dlc_name
,dlc_pathname
,dlc_dmd_id
,dlc_descr
,dlc_start_date
,dlc_end_date
,NULL
,NULL
FROM v2_doc_locations v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_LOCATIONS v3
                  WHERE  v3.dlc_id= v2.dlc_id
                 );
--
append_log_content(pi_text => 'DOC_SYNONYMS');
INSERT INTO DOC_SYNONYMS
(
 dsy_key_id
,dsy_dkw_key_id
)
SELECT
 dsy_key_id
,dsy_dkw_key_id
FROM v2_doc_synonyms v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_SYNONYMS v3
                  WHERE  v3.dsy_key_id= v2.dsy_key_id
                 );
--
--
--
append_log_content(pi_text => 'DOC_TEMPLATE_GATEWAYS');
INSERT INTO DOC_TEMPLATE_GATEWAYS
(
 dtg_dmd_id
,dtg_ole_type
,dtg_table_name
,dtg_template_name
,dtg_dlc_id
,dtg_template_descr
,dtg_post_run_procedure
)
SELECT
 dtg_dmd_id
,dtg_ole_type
,dtg_table_name
,dtg_template_name
,dtg_dlc_id
,dtg_template_descr
,dtg_post_run_procedure
FROM v2_doc_template_gateways v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_TEMPLATE_GATEWAYS v3
                  WHERE  v3.dtg_template_name= v2.dtg_template_name
                 );
--
--
--
append_log_content(pi_text => 'DOC_TEMPLATE_COLUMNS');
INSERT INTO DOC_TEMPLATE_COLUMNS
(
 dtc_template_name
,dtc_col_name
,dtc_col_type
,dtc_col_alias
,dtc_col_seq
,dtc_used_in_proc
,dtc_image_file
,dtc_function
)
SELECT
 dtc_template_name
,dtc_col_name
,dtc_col_type
,dtc_col_alias
,dtc_col_seq
,dtc_used_in_proc
,dtc_image_file
,dtc_function
FROM v2_doc_template_columns v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_TEMPLATE_COLUMNS v3
                  WHERE  v3.dtc_template_name= v2.dtc_template_name
                  AND    v3.dtc_col_alias= v2.dtc_col_alias
                 );
--
--
--
append_log_content(pi_text => 'DOC_TEMPLATE_USERS');
INSERT INTO DOC_TEMPLATE_USERS
(
 dtu_template_name
,dtu_user_id
,dtu_default_template
,dtu_print_immediately
,dtu_default_report_type
)
SELECT
 dtu_template_name
,dtu_user_id
,dtu_default_template
,dtu_print_immediately
,dtu_default_report_type
FROM v2_doc_template_users v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_TEMPLATE_USERS v3
                  WHERE  v3.dtu_user_id= v2.dtu_user_id
                  AND    v3.dtu_template_name= v2.dtu_template_name
                 );
--
--
--
append_log_content(pi_text => 'DOC_TYPES');
INSERT INTO DOC_TYPES
(
 dtp_code
,dtp_name
,dtp_descr
,dtp_allow_comments
,dtp_allow_complaints
,dtp_start_date
,dtp_end_date
)
SELECT
 dtp_code
,dtp_name
,dtp_descr
,dtp_allow_comments
,dtp_allow_complaints
,dtp_start_date
,dtp_end_date
FROM v2_doc_types v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_TYPES v3
                  WHERE  v3.dtp_code= v2.dtp_code
                 );
--
append_log_content(pi_text => 'DOC_CLASS');
-- dcl_name has dcl_code appended to make it unique - due to v3 having dcl_uk1 constraint that is not in v2
--CCH BUT This blows the column!!
INSERT INTO DOC_CLASS
(
 dcl_code
,dcl_name
,dcl_descr
,dcl_start_date
,dcl_end_date
,dcl_dtp_code
)
SELECT
 dcl_code
,dcl_name--||' ('||dcl_code||')'
,dcl_descr
,dcl_start_date
,dcl_end_date
,dcl_dtp_code
FROM v2_doc_class v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_CLASS v3
                  WHERE  v3.dcl_dtp_code= v2.dcl_dtp_code
                  AND    v3.dcl_code= v2.dcl_code
                 );
--
--
--
append_log_content(pi_text => 'DOCS');
INSERT INTO DOCS
(
 doc_id
,doc_title
,doc_dcl_code
,doc_dtp_code
,doc_date_expires
,doc_date_issued
,doc_file
,doc_reference_code
,doc_issue_number
,doc_dlc_id
,doc_dlc_dmd_id
,doc_descr
,doc_user_id
,doc_category
,doc_admin_unit
,doc_status_code
,doc_status_date
,doc_reason
,doc_compl_type
,doc_compl_source
,doc_compl_ack_flag
,doc_compl_ack_date
,doc_compl_flag
,doc_compl_cpr_id
,doc_compl_user_id
,doc_compl_peo_date
,doc_compl_target
,doc_compl_complete
,doc_compl_referred_to
,doc_compl_location
,doc_compl_remarks
,doc_compl_north
,doc_compl_east
,doc_compl_from
,doc_compl_to
,doc_compl_claim
,doc_compl_corresp_date
,doc_compl_corresp_deliv_date
,doc_compl_no_of_petitioners
,doc_compl_incident_date
,doc_compl_police_notif_flag
,doc_compl_date_police_notif
,doc_compl_cause
,doc_compl_injuries
,doc_compl_damage
,doc_compl_action
,doc_compl_litigation_flag
,doc_compl_litigation_reason
,doc_compl_claim_no
,doc_compl_determination
,doc_compl_est_cost
,doc_compl_adv_cost
,doc_compl_act_cost
,doc_compl_follow_up1
,doc_compl_follow_up2
,doc_compl_follow_up3
,doc_compl_insurance_claim
,doc_compl_summons_received
,doc_compl_user_type
)
SELECT
 doc_id
,doc_title
,doc_dcl_code
,doc_dtp_code
,doc_date_expires
,doc_date_issued
,doc_file
,doc_reference_code
,doc_issue_number
,doc_dlc_id
,doc_dlc_dmd_id
,doc_descr
,doc_user_id
,doc_category
,doc_admin_unit
,doc_status_code
,doc_status_date
,doc_reason
,doc_compl_type
,doc_compl_source
,doc_compl_ack_flag
,doc_compl_ack_date
,doc_compl_flag
,doc_compl_cpr_id
,doc_compl_user_id
,doc_compl_peo_date
,doc_compl_target
,doc_compl_complete
,doc_compl_referred_to
,doc_compl_location
,doc_compl_remarks
,doc_compl_north
,doc_compl_east
,doc_compl_from
,doc_compl_to
,doc_compl_claim
,doc_compl_corresp_date
,doc_compl_corresp_deliv_date
,doc_compl_no_of_petitioners
,doc_compl_incident_date
,doc_compl_police_notif_flag
,doc_compl_date_police_notif
,doc_compl_cause
,doc_compl_injuries
,doc_compl_damage
,doc_compl_action
,doc_compl_litigation_flag
,doc_compl_litigation_reason
,doc_compl_claim_no
,doc_compl_determination
,doc_compl_est_cost
,doc_compl_adv_cost
,doc_compl_act_cost
,doc_compl_follow_up1
,doc_compl_follow_up2
,doc_compl_follow_up3
,doc_compl_insurance_claim
,doc_compl_summons_received
,doc_compl_user_type
FROM v2_docs v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOCS v3
                  WHERE  v3.doc_id= v2.doc_id
                 );
--
--
append_log_content(pi_text => 'DOC_HISTORY');
INSERT INTO DOC_HISTORY
(
 dhi_doc_id
,dhi_date_changed
,dhi_status_code
,dhi_compl_type
,dhi_compl_cpr_id
,dhi_changed_by
,dhi_reason
,dhi_claim
,dhi_dtp_code
,dhi_dcl_code
,dhi_corresp_date
,dhi_ack_date
,dhi_incident_date
)
SELECT
 dhi_doc_id
,dhi_date_changed
,dhi_status_code
,dhi_compl_type
,dhi_compl_cpr_id
,dhi_changed_by
,dhi_reason
,dhi_claim
,dhi_dtp_code
,dhi_dcl_code
,dhi_corresp_date
,dhi_ack_date
,dhi_incident_date
FROM v2_doc_history v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_HISTORY v3
                  WHERE  v3.dhi_doc_id= v2.dhi_doc_id
                  AND    v3.dhi_date_changed= v2.dhi_date_changed
                 );
--
--
--
append_log_content(pi_text => 'DOC_KEYS');
INSERT INTO DOC_KEYS
(
 dky_doc_id
,dky_dkw_key_id
)
SELECT
 dky_doc_id
,dky_dkw_key_id
FROM v2_doc_keys v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_KEYS v3
                  WHERE  v3.dky_doc_id= v2.dky_doc_id
                  AND    v3.dky_dkw_key_id= v2.dky_dkw_key_id
                 );
--
--
--
append_log_content(pi_text => 'DOC_COPIES');
INSERT INTO DOC_COPIES
(
 dcp_doc_id
,dcp_id
,dcp_date_out
,dcp_user_id
,dcp_date_back
,dcp_remarks
)
SELECT
 dcp_doc_id
,dcp_id
,dcp_date_out
,dcp_user_id
,dcp_date_back
,dcp_remarks
FROM v2_doc_copies v2
WHERE NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_COPIES v3
                  WHERE  v3.dcp_doc_id= v2.dcp_doc_id
                  AND    v3.dcp_id= v2.dcp_id
                 );
--
do_optional_commit;
--
--
 append_proc_end_to_log;
--
END process_doc_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_gis_data IS
/* CURSOR get_route_theme IS
  SELECT gt_theme_id
  FROM   v2_gis_themes_all
  WHERE  gt_route_theme = 'Y';
*/
  l_theme_id    NM_THEMES_ALL.nth_theme_id%TYPE;
  l_theme_found BOOLEAN;
  l_ne_nt_count NUMBER;
  l_ne_nt_type NM_ELEMENTS_ALL.ne_nt_type%TYPE;


  PROCEDURE tidy_data IS
  BEGIN
    append_log_content(pi_text => 'Tidying existing data');
/*    DELETE FROM NM_NW_THEMES;
	DELETE FROM NM_THEME_GTYPES;
    DELETE FROM NM_THEME_FUNCTIONS_ALL;
    DELETE FROM NM_THEME_ROLES;
    DELETE FROM NM_THEMES_ALL;
    DELETE FROM GIS_PROJECTS;
	do_optional_commit;
*/    append_log_content(pi_text => 'Done');
  END tidy_data;
  PROCEDURE ins_linear_type(p_nt_type IN NM_TYPES.nt_type%TYPE
                           ,p_theme   IN NM_THEMES_ALL.nth_theme_id%TYPE) IS
  --
  CURSOR get_nlt_id (p_nt_type NM_TYPES.nt_type%TYPE) IS
  SELECT nlt_id
  FROM   NM_LINEAR_TYPES
  WHERE  nlt_nt_type = p_nt_type;
  --
  l_nnth        NM_NW_THEMES%ROWTYPE;
  BEGIN


    OPEN get_nlt_id(p_nt_type);
    FETCH get_nlt_id INTO l_nnth.nnth_nlt_id;
    CLOSE get_nlt_id;
    l_nnth.nnth_nth_theme_id := p_theme;
    IF g_debug THEN
      Nm3debug.debug_nnth(pi_rec_nnth => l_nnth);
    END IF;
    Nm3ins.ins_nnth(p_rec_nnth => l_nnth);
  END ins_linear_type;
BEGIN
--
 g_proc_name := 'process_gis_data';
 append_proc_start_to_log;
--
  tidy_data;
/*  append_log_content(pi_text => 'GIS_PROJECTS');
  INSERT INTO GIS_PROJECTS
      (gp_project
      ,gp_dir_path
      ,gp_dde_init_prog
      ,gp_dde_init_topic
      )
  SELECT gp_project
        ,gp_dir_path
        ,gp_dde_init_prog
        ,gp_dde_init_topic
  FROM   v2_gis_projects;
--
*/

  select nth_theme_id_seq.nextval
    into g_theme_max
    from dual;

append_log_content(pi_text => 'NM_THEMES_ALL');
  INSERT INTO NM_THEMES_ALL (
       nth_theme_id,
       nth_theme_name,
       nth_table_name,
       nth_where,
       nth_pk_column,
       nth_label_column,
       nth_rse_table_name,
       nth_rse_fk_column,
       nth_st_chain_column,
       nth_end_chain_column,
       nth_x_column,
       nth_y_column,
       nth_offset_field,
       nth_feature_table,
       nth_feature_pk_column,
       nth_feature_fk_column,
       nth_xsp_column,
       nth_feature_shape_column,
       nth_hpr_product,
       nth_location_updatable,
       nth_theme_type,
       nth_dependency,
       nth_storage,
       nth_update_on_edit,
	   NTH_USE_HISTORY,
--	   NTH_START_DATE_COLUMN,
--	   NTH_END_DATE_COLUMN,
--	   NTH_BASE_TABLE_THEME,
--	   NTH_SEQUENCE_NAME,
--	   NTH_SNAP_TO_THEME,
	   NTH_LREF_MANDATORY
--	   NTH_TOLERANCE,
--	   NTH_TOL_UNITS
--     NTH_DYNAMIC_THEME
       )
SELECT gt_theme_id +g_theme_max                                                   nth_theme_id
      ,gt_theme_name                                                  nth_theme_name
      ,DECODE( gt_route_theme, 'Y', 'NM_ELEMENTS'
	         , SUBSTR(gt_table_name,INSTR(gt_table_name,'.')+1) )     nth_table_name
      ,DECODE( gt_route_theme, 'Y', NULL,gt_where)                    nth_where
      ,DECODE( gt_route_theme, 'Y', 'NE_ID', gt_pk_column)            nth_pk_column
      ,DECODE( gt_route_theme, 'Y', 'NE_UNIQUE', gt_label_column)     nth_label_column
      ,DECODE( gt_route_theme, 'Y', 'NM_ELEMENTS'
	     , SUBSTR(gt_rse_table_name,INSTR(gt_rse_table_name,'.')+1) ) nth_rse_table_name
      ,DECODE( gt_route_theme, 'Y', 'NE_ID', gt_rse_fk_column)        nth_rse_fk_column
      ,gt_st_chain_column                                             nth_st_chain_column
      ,gt_end_chain_column                                            nth_end_chain_column
      ,gt_x_column                                                    nth_x_column
      ,gt_y_column                                                    nth_y_column
      ,gt_offset_field                                                nth_offset_field
      ,SUBSTR(gt_feature_table,INSTR(gt_feature_table,'.') +1)        nth_feature_table
      ,gt_feature_pk_column                                           nth_feature_pk_column
      ,NVL(gt_feature_fk_column, gt_feature_pk_column)                nth_feature_fk_column
      ,gt_xsp_column                                                  nth_xsp_column
      ,DECODE( gt_route_theme, 'Y','SHAPE')                           nth_feature_shape_column
      ,'NET'                                                          nth_hpr_product
      ,'N'                                                            nth_location_updatable
      ,DECODE( gt_route_theme, 'Y', 'SDO', DECODE( gt_feature_table, NULL, 'LOCL', 'SDE')) nth_theme_type
      ,DECODE( gt_route_theme, 'Y', 'I', 'D')                         nth_dependency
      ,DECODE( gt_route_theme, 'Y', 'S', 'D')                         nth_storage
      ,'N'                                                            nth_update_on_edit
      ,'N'                                                            NTH_USE_HISTORY
--	   NTH_START_DATE_COLUMN,
--	   NTH_END_DATE_COLUMN,
--	   NTH_BASE_TABLE_THEME,
--	   NTH_SEQUENCE_NAME,
--	   NTH_SNAP_TO_THEME,
      ,'N'                                                            NTH_LREF_MANDATORY
--	   NTH_TOLERANCE,
--	   NTH_TOL_UNITS
--     NTH_DYNAMIC_THEME
  FROM  v2_gis_themes_all;
--
  append_log_content(pi_text => 'NM_THEME_FUNCIONS_ALL');
  INSERT INTO NM_THEME_FUNCTIONS_ALL
   (ntf_nth_theme_id
   ,ntf_hmo_module
   ,ntf_parameter
   ,ntf_menu_option
   ,ntf_seen_in_gis )
  SELECT gtf_gt_theme_id+g_theme_max
       , gtf_hmo_module
       , gtf_parameter
       , gtf_menu_option
       , 'Y'
  FROM v2_gis_theme_functions
  WHERE EXISTS
  (SELECT 'x' FROM HIG_MODULES
  WHERE hmo_module=gtf_hmo_module);
--
  append_log_content(pi_text => 'NM_THEME_ROLES');
  INSERT INTO NM_THEME_ROLES
   (nthr_theme_id,
    nthr_role,
    nthr_mode )
  SELECT gthr_theme_id+g_theme_max
        ,gthr_role
        ,gthr_mode
  FROM   v2_gis_theme_roles;

  append_log_content(pi_text => 'NM_THEME_GTYPES');

  INSERT INTO NM_THEME_GTYPES
   (NTG_THEME_ID,
    NTG_GTYPE,
	NTG_SEQ_NO,
	NTG_XML_URL)
  SELECT gt_theme_id+g_theme_max
        ,DECODE(gt_route_Theme,'Y','3002'
		                      ,DECODE(NVL(gt_end_chain_Column,'POINT'),'POINT','2001','3002'))
        ,1
		,NULL
  FROM   v2_gis_themes_all
  ;

 append_log_content(pi_text => 'NM_NW_THEMES');

  INSERT INTO NM_NW_THEMES
  (NNTH_NLT_ID, NNTH_NTH_THEME_ID)
  SELECT nlt_id,gt_theme_id+g_theme_max
  FROM NM_LINEAR_TYPES
  ,v2_gis_themes_all
  WHERE nlt_nt_type IN ('D','L')
  AND gt_route_Theme='Y';

-- update the nth_theme_id_seq sequence
-- This is fixing a bug in 3110.
  INSERT INTO HIG_SEQUENCE_ASSOCIATIONS
  ( HSA_TABLE_NAME, HSA_COLUMN_NAME, HSA_SEQUENCE_NAME )
  SELECT 'NM_THEMES_ALL', 'NTH_THEME_ID', 'NTH_THEME_ID_SEQ'
  FROM dual
  WHERE NOT EXISTS
  (SELECT 'z' FROM HIG_SEQUENCE_ASSOCIATIONS
  WHERE hsa_table_name='NM_THEMES_ALL');
  -- check if there is a route them if so then we will deal with it
/*
   append_log_content('NM_LINEAR_TYPES');
  FOR c1rec IN
    (SELECT gt_theme_id,SUBSTR(gt_feature_table,INSTR(gt_feature_table,'.') +1) feature_table,  GT_FEATURE_PK_COLUMN
  FROM   v2_gis_themes_all
  WHERE  gt_feature_table IS NOT NULL
    AND gt_feature_pk_column IS NOT NULL
) LOOP
--we should have created a synonym for this so use some dyn sql to get the contents...
    EXECUTE IMMEDIATE 'SELECT COUNT(DISTINCT ne_nt_type) FROM nm_elements_all, v2_'||c1rec.feature_table||
	                  ' WHERE ne_id='||c1rec.gt_feature_pk_column INTO l_ne_nt_count;
	IF l_ne_nt_count>1 THEN  --we have an issue and need to split the data up - raise an error
      RAISE_APPLICATION_ERROR(-20001,'Spatial table contains D and L elements');
	ELSIF l_ne_nt_Count=1 THEN
      EXECUTE IMMEDIATE 'SELECT ne_nt_type FROM nm_elements_all, v2_'||c1rec.feature_table||
	                  ' WHERE ne_id='||c1rec.gt_feature_pk_column||' group by ne_nt_type' INTO l_ne_nt_type;
      ins_linear_type(l_ne_nt_type, c1rec.gt_theme_id);
	END IF;
  END LOOP;
  append_proc_end_to_log;
*/
--
  Nm3ddl.rebuild_all_sequences;

END process_gis_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_network_metamodel IS
  CURSOR get_v2_subtypes IS
--modified to bring over only the section classes that are in use on netowrk
  SELECT rse_sys_flag,scl_sect_class,scl_descr,ROWNUM scl_seq_no
  FROM
  (SELECT DISTINCT rse_sys_flag,scl_sect_class,scl_descr
  FROM v2_road_segs, v2_section_classes
  WHERE rse_scl_sect_class=scl_sect_class);
/*
  SELECT rse_sys_flag
        ,scl_sect_class
        ,scl_descr
        ,ROWNUM scl_seq_no
  FROM (SELECT DECODE(scl_road_cat, 'T', 'D', 'L') road_class
              ,scl_sect_class
              ,scl_descr
        FROM   v2_section_classes), MIG_DTP_LOCAL
        WHERE  rse_sys_flag = road_class;
*/
  l_nsc         NM_TYPE_SUBCLASS%ROWTYPE;
  l_ntc         NM_TYPE_COLUMNS%ROWTYPE;
  PROCEDURE tidy_data IS
  BEGIN
    append_log_content(pi_text => 'Tidying existing data');
   -- DELETE FROM NM_MEMBERS_ALL;
  --  DELETE FROM NM_ELEMENTS_ALL;
 --   DELETE FROM NM_NODES_ALL;
 --   DELETE FROM NM_NODE_USAGES_ALL;
 --   DELETE FROM NM_NT_GROUPINGS_ALL;
 --   DELETE FROM NM_GROUP_TYPES_ALL;
 --   DELETE FROM NM_TYPE_COLUMNS;
 --   DELETE FROM NM_TYPE_SUBCLASS;
  --  DELETE FROM NM_TYPE_INCLUSION;
  --  DELETE FROM NM_NW_THEMES;
  --  DELETE FROM NM_LINEAR_TYPES;
  --  DELETE FROM NM_TYPES;
  --  DELETE FROM NM_TYPES;
    DELETE FROM HIG_CODES WHERE hco_domain IN ('AGENCY_CODE', 'ROAD_CLASS', 'ROAD_SYS_FLAG');
    DELETE FROM HIG_DOMAINS WHERE hdo_domain IN ('AGENCY_CODE', 'ROAD_CLASS', 'ROAD_SYS_FLAG');
    do_optional_commit;
    append_log_content(pi_text => 'Done');
  END tidy_data;
  --
  PROCEDURE create_network_domains IS
  TYPE t_domains IS TABLE OF HIG_DOMAINS%ROWTYPE INDEX BY BINARY_INTEGER;
  l_tab_doms t_domains;
  l_hdo HIG_DOMAINS%ROWTYPE;
  BEGIN
    append_log_content(pi_text => 'Creating network domains');
    l_tab_doms(1).hdo_domain      := 'ROAD_SYS_FLAG';
    l_tab_doms(1).hdo_product     := Nm3type.c_hig;
    l_tab_doms(1).hdo_title       := 'Road System Flag';
    l_tab_doms(1).hdo_code_length := 1;
    IF NOT welsh THEN
      l_tab_doms(2).hdo_domain      := 'ROAD_CLASS';
      l_tab_doms(2).hdo_product     := Nm3type.c_hig;
      l_tab_doms(2).hdo_title       := 'Road Classes for Linkcode Prefix';
      l_tab_doms(2).hdo_code_length := 10;
    END IF;
    FOR i IN 1..l_tab_doms.COUNT LOOP
      l_hdo := Nm3get.get_hdo(pi_hdo_domain      => l_tab_doms(i).hdo_domain
                             ,pi_raise_not_found => FALSE);
      IF l_hdo.hdo_domain IS NULL THEN
        IF g_debug THEN
          Nm3debug.debug_hdo(pi_rec_hdo => l_tab_doms(i));
        END IF;
        Nm3ins.ins_hdo(p_rec_hdo => l_tab_doms(i));
      END IF;
    END LOOP;
    IF NOT welsh THEN
      INSERT INTO HIG_CODES (hco_domain
                            ,hco_code
                            ,hco_meaning
                            ,hco_system)
      (
      SELECT 'ROAD_CLASS' hco_domain
            ,SUBSTR(rse_linkcode,1,1) hco_code
            ,SUBSTR(rse_linkcode,1,1) hco_meaning
            ,'Y' hco_system
      FROM   v2_road_segs
      WHERE  (rse_gty_group_type IS NULL
             OR rse_gty_group_type = 'LINK')
      AND    SUBSTR(rse_linkcode,1,1) IS NOT NULL
      AND NOT EXISTS (SELECT 1
                      FROM  HIG_CODES
                      WHERE hco_domain = 'ROAD_CLASS'
                      AND   hco_code   = SUBSTR(rse_linkcode,1,1))
      GROUP BY SUBSTR(rse_linkcode,1,1));
    END IF;
    INSERT INTO HIG_CODES (hco_domain
                          ,hco_code
                          ,hco_meaning
                          ,hco_system)
    (
    SELECT 'ROAD_SYS_FLAG' hco_domain
          ,rse_sys_flag    hco_code
          ,DECODE(rse_sys_flag, 'L', 'Local'
                              , 'D', 'DTP'
                              , rse_sys_flag) hco_meaning
          ,'Y' hco_system
    FROM   v2_road_segs
    GROUP BY rse_sys_flag);
  END create_network_domains;
--
--
  PROCEDURE ins_ntc(p_rec_ntc IN OUT NM_TYPE_COLUMNS%ROWTYPE) IS
  BEGIN
    IF g_debug THEN
      Nm3debug.debug_ntc(pi_rec_ntc => p_rec_ntc);
    END IF;
    Nm3ins.ins_ntc(p_rec_ntc => p_rec_ntc);
  END ins_ntc;
--
BEGIN
--
 g_proc_name := 'create_network_metamodel';
 append_proc_start_to_log;
--
  tidy_data;
  append_log_content(pi_text => 'NM_TYPES');
  IF g_d_network THEN
    INSERT INTO NM_TYPES ( NT_TYPE
                       , NT_UNIQUE
	  				   , NT_LINEAR
		  			   , NT_NODE_TYPE
					   , NT_DESCR
					   , NT_ADMIN_TYPE
					   , NT_LENGTH_UNIT
					   , NT_DATUM
 					   , NT_POP_UNIQUE )
                SELECT
                        'D'
                       ,'DOT'
                        ,'Y'
--                       ,'ROAD'
                       , g_node_type
                       ,'DOT Section'
                       ,g_admin_type
                       ,1
                       ,'Y'
                       ,'Y'
    FROM  dual;
--
    INSERT INTO NM_TYPES ( NT_TYPE
                         , NT_UNIQUE
                         , NT_LINEAR
                         , NT_NODE_TYPE
                         , NT_DESCR
                         , NT_ADMIN_TYPE
                         , NT_LENGTH_UNIT
                         , NT_DATUM
                         , NT_POP_UNIQUE )
                SELECT
                        'DLNK'
                       ,'DOT LINKS'
                       ,'N'
                       ,NULL
                       ,'DOT LINKS'
                       ,g_admin_type
                       ,NULL
                       ,'N'
                       ,'N'
    FROM DUAL;
    --
  END IF;
--
  IF g_l_network THEN
    INSERT INTO NM_TYPES ( NT_TYPE
                         , NT_UNIQUE
                         , NT_LINEAR
                         , NT_NODE_TYPE
                         , NT_DESCR
                         , NT_ADMIN_TYPE
                         , NT_LENGTH_UNIT
                         , NT_DATUM
                         , NT_POP_UNIQUE )
                SELECT
                        'L'
                       ,'LOCAL'
                        ,'Y'
--                       ,'ROAD'
                       ,g_node_type
                       ,'LOCAL Section'
                       ,g_admin_type
                       ,1
                       ,'Y'
                       ,'Y'
    FROM  dual;
--
    INSERT INTO NM_TYPES ( NT_TYPE
                         , NT_UNIQUE
                         , NT_LINEAR
                         , NT_NODE_TYPE
                         , NT_DESCR
                         , NT_ADMIN_TYPE
                         , NT_LENGTH_UNIT
                         , NT_DATUM
                         , NT_POP_UNIQUE )
                SELECT
                        'LLNK'
                       ,'LOCAL LINKS'
                       ,'N'
                       ,NULL
                       ,'LOCAL LINKS'
                       ,g_admin_type
                       ,NULL
                       ,'N'
                       ,'N'
    FROM dual;
  END IF;
--
  append_log_content(pi_text => 'NM_TYPE_INCLUSION');
  IF g_d_network THEN
    INSERT INTO NM_TYPE_INCLUSION ( NTI_NW_PARENT_TYPE
                                  , NTI_NW_CHILD_TYPE
                                  , NTI_PARENT_COLUMN
                                  , NTI_CHILD_COLUMN
                                  , NTI_AUTO_INCLUDE
                                  , NTI_AUTO_CREATE
                                  , NTI_REVERSE_ALLOWED
                                  )
                          SELECT
                                   'DLNK'
                                 , 'D'
                                 , 'NE_UNIQUE'
                                 , 'NE_NAME_2'
                                 , 'N'
                                 , 'Y'
                                 , 'Y'
     FROM dual;
   END IF;
--
  IF g_l_network THEN
    INSERT INTO NM_TYPE_INCLUSION ( NTI_NW_PARENT_TYPE
                                  , NTI_NW_CHILD_TYPE
                                  , NTI_PARENT_COLUMN
                                  , NTI_CHILD_COLUMN
                                  , NTI_AUTO_INCLUDE
                                  , NTI_AUTO_CREATE
                                  , NTI_REVERSE_ALLOWED
                                  )
                           SELECT
                                   'LLNK'
                                 , 'L'
                                 , 'NE_UNIQUE'
                                 , 'NE_NAME_2'
                                 , 'N'
                                 , 'Y'
                                 , 'Y'
    FROM dual;
  END IF;
--
  append_log_content(pi_text => 'NM_GROUP_TYPES_ALL');
  INSERT INTO NM_GROUP_TYPES_ALL ( NGT_GROUP_TYPE
                               , NGT_DESCR
							   , NGT_EXCLUSIVE_FLAG
							   , NGT_SEARCH_GROUP_NO
                               , NGT_LINEAR_FLAG
							   , NGT_NT_TYPE
							   , NGT_PARTIAL
							   , NGT_START_DATE
							   , NGT_SUB_GROUP_ALLOWED
                               , NGT_MANDATORY
							   , NGT_REVERSE_ALLOWED )
                         SELECT
                                 'DLNK'
							   , 'DOT Links'
							   , 'Y'
							   , 1
							   , 'N'
							   , 'DLNK'
							   , 'N'
							   ,  g_mig_earliest_date
                               , 'N'
							   , 'Y'
							   , 'N'
  FROM dual
  WHERE EXISTS (SELECT 'D network'
              FROM   MIG_DTP_LOCAL
			  WHERE  rse_sys_flag = 'D');
--
  INSERT INTO NM_GROUP_TYPES_ALL ( NGT_GROUP_TYPE
                               , NGT_DESCR
							   , NGT_EXCLUSIVE_FLAG
							   , NGT_SEARCH_GROUP_NO
                               , NGT_LINEAR_FLAG
							   , NGT_NT_TYPE
							   , NGT_PARTIAL
							   , NGT_START_DATE
							   , NGT_SUB_GROUP_ALLOWED
                               , NGT_MANDATORY
							   , NGT_REVERSE_ALLOWED )
                          SELECT
                                 'LLNK'
							   , 'Local Links'
							   , 'Y'
							   , 1
							   , 'N'
							   , 'LLNK'
							   , 'N'
							   ,  g_mig_earliest_date
                               , 'N'
							   , 'Y'
							   , 'N'
  FROM dual
  WHERE EXISTS (SELECT 'L network'
              FROM   MIG_DTP_LOCAL
			  WHERE  rse_sys_flag = 'L');
--
  append_log_content(pi_text => 'NM_NT_GROUPINGS_ALL');
  INSERT INTO NM_NT_GROUPINGS_ALL ( NNG_GROUP_TYPE
                                  , NNG_NT_TYPE
								  , NNG_START_DATE )
 						  SELECT
                                   'DLNK'
                                 , 'D'
								 ,  g_mig_earliest_date
  FROM  dual
  WHERE EXISTS (SELECT 'D network'
              FROM   MIG_DTP_LOCAL
			  WHERE  rse_sys_flag = 'D');
--
  INSERT INTO NM_NT_GROUPINGS_ALL ( NNG_GROUP_TYPE
                                  , NNG_NT_TYPE
								  , NNG_START_DATE )
 						  SELECT
                                   'LLNK'
                                 , 'L'
								 ,  g_mig_earliest_date
  FROM  dual
  WHERE EXISTS (SELECT 'L network'
              FROM   MIG_DTP_LOCAL
			  WHERE  rse_sys_flag = 'L');
--
  append_log_content(pi_text => 'NM_TYPE_COLUMNS');
  IF g_d_network THEN
    l_ntc.ntc_nt_type     := 'D';
    l_ntc.ntc_column_name := 'NE_OWNER';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 1;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 4;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
if not welsh then
    l_ntc.ntc_query       := 'SELECT AGENCY_CODE, HAU_NAME,HAU_AUTHORITY_CODE FROM V_HIG_AGENCY_CODE';
else
    l_ntc.ntc_query       := null;
end if;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Agency Code';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := 1;
    l_ntc.ntc_updatable   := 'N';
    ins_ntc(p_rec_ntc => l_ntc);
--
    IF NOT welsh THEN
      l_ntc.ntc_nt_type     := 'D';
      l_ntc.ntc_column_name := 'NE_SUB_TYPE';
      l_ntc.ntc_column_type := 'VARCHAR2';
      l_ntc.ntc_seq_no      := 2;
      l_ntc.ntc_displayed   := 'Y';
      l_ntc.ntc_str_length  := 1;
      l_ntc.ntc_mandatory   := 'Y';
      l_ntc.ntc_domain      := 'ROAD_CLASS';
      l_ntc.ntc_query       := NULL;
      l_ntc.ntc_inherit     := 'Y';
      l_ntc.ntc_format      := NULL;
      l_ntc.ntc_default     := NULL;
      l_ntc.ntc_prompt      := 'Road Class';
      l_ntc.ntc_separator   := NULL;
      l_ntc.ntc_unique_seq  := 2;
      l_ntc.ntc_updatable   := 'N';
      ins_ntc(p_rec_ntc => l_ntc);
	END IF;
--
    l_ntc.ntc_nt_type     := 'D';
    l_ntc.ntc_column_name := 'NE_NAME_1';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 3;
    l_ntc.ntc_displayed   := 'Y';
    IF NOT welsh THEN
      l_ntc.ntc_str_length  := 5;
    ELSE
      l_ntc.ntc_str_length  := 3;
    END IF;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Link Number';
    l_ntc.ntc_separator   := '/';
    l_ntc.ntc_unique_seq  := 3;
    l_ntc.ntc_updatable   := 'N';
    l_ntc.ntc_unique_format   := 'RPAD(:NE_NAME_1,5,''_'')';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'D';
    l_ntc.ntc_column_name := 'NE_NUMBER';
    l_ntc.ntc_column_type := 'NUMBER';
    l_ntc.ntc_seq_no      := 4;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 2;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := '00';
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Section Number';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := 4;
    l_ntc.ntc_updatable   := 'N';
    l_ntc.ntc_unique_format   := NULL;
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'D';
    l_ntc.ntc_column_name := 'NE_SUB_CLASS';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 5;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 2;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''D''';
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Section Class';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'D';
    l_ntc.ntc_column_name := 'NE_NAME_2';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 10;
    l_ntc.ntc_displayed   := 'N';
    l_ntc.ntc_str_length  := 10;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := NULL;
if not welsh then
    l_ntc.ntc_default     := ':NE_OWNER||:NE_SUB_TYPE||RPAD(:NE_NAME_1,5,''_'')';
else
    l_ntc.ntc_default     := ':NE_OWNER||RPAD(:NE_NAME_1,5,''_'')';
end if;
    l_ntc.ntc_prompt      := 'AgencyLinkcode';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'N';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'D';
    l_ntc.ntc_column_name := 'NE_PREFIX';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 11;
    l_ntc.ntc_displayed   := 'N';
    l_ntc.ntc_str_length  := 1;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := '''D''';
    l_ntc.ntc_prompt      := 'Sys Flag';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'N';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'DLNK';
    l_ntc.ntc_column_name := 'NE_SUB_CLASS';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 1;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 2;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''D''';
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Section Class';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
--
    ins_ntc(p_rec_ntc => l_ntc);
    l_ntc.ntc_nt_type     := 'DLNK';
    l_ntc.ntc_column_name := 'NE_NAME_2';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 2;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 3;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'DoT Budget Code';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'DLNK';
    l_ntc.ntc_column_name := 'NE_PREFIX';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 10;
    l_ntc.ntc_displayed   := 'N';
    l_ntc.ntc_str_length  := 1;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := '''D''';
    l_ntc.ntc_prompt      := 'Sys Flag';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
    ins_ntc(p_rec_ntc => l_ntc);
  END IF;
--
-- L
--
  IF g_l_network THEN
    l_ntc.ntc_nt_type     := 'L';
    l_ntc.ntc_column_name := 'NE_OWNER';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 1;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 4;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
if not welsh then
    l_ntc.ntc_query       := 'SELECT AGENCY_CODE, HAU_NAME,HAU_AUTHORITY_CODE FROM V_HIG_AGENCY_CODE';
else
    l_ntc.ntc_query       := null;
end if;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Agency Code';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := 1;
    l_ntc.ntc_updatable   := 'N';
    ins_ntc(p_rec_ntc => l_ntc);
--
    IF NOT welsh THEN
      l_ntc.ntc_nt_type     := 'L';
      l_ntc.ntc_column_name := 'NE_SUB_TYPE';
      l_ntc.ntc_column_type := 'VARCHAR2';
      l_ntc.ntc_seq_no      := 2;
      l_ntc.ntc_displayed   := 'Y';
      l_ntc.ntc_str_length  := 1;
      l_ntc.ntc_mandatory   := 'Y';
      l_ntc.ntc_domain      := 'ROAD_CLASS';
      l_ntc.ntc_query       := NULL;
      l_ntc.ntc_inherit     := 'Y';
      l_ntc.ntc_format      := NULL;
      l_ntc.ntc_default     := NULL;
      l_ntc.ntc_prompt      := 'Road Class';
      l_ntc.ntc_separator   := NULL;
      l_ntc.ntc_unique_seq  := 2;
      l_ntc.ntc_updatable   := 'N';
      ins_ntc(p_rec_ntc => l_ntc);
	END IF;
--
    l_ntc.ntc_nt_type     := 'L';
    l_ntc.ntc_column_name := 'NE_NAME_1';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 3;
    l_ntc.ntc_displayed   := 'Y';
    IF NOT welsh THEN
      l_ntc.ntc_str_length  := 5;
    ELSE
      l_ntc.ntc_str_length  := 3;
    END IF;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Link Number';
    l_ntc.ntc_separator   := '/';
    l_ntc.ntc_unique_seq  := 3;
    l_ntc.ntc_updatable   := 'N';
    l_ntc.ntc_unique_format   := 'RPAD(:NE_NAME_1,5,''_'')';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'L';
    l_ntc.ntc_column_name := 'NE_NUMBER';
    l_ntc.ntc_column_type := 'NUMBER';
    l_ntc.ntc_seq_no      := 4;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 5;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := '00000';
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Section Number';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := 4;
    l_ntc.ntc_updatable   := 'N';
    l_ntc.ntc_unique_format   := NULL;
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'L';
    l_ntc.ntc_column_name := 'NE_SUB_CLASS';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 5;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 2;
    l_ntc.ntc_mandatory   := 'Y';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''L''';
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Section Class';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'L';
    l_ntc.ntc_column_name := 'NE_NAME_2';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 10;
    l_ntc.ntc_displayed   := 'N';
    l_ntc.ntc_str_length  := 10;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := NULL;
if not welsh then
    l_ntc.ntc_default     := ':NE_OWNER||:NE_SUB_TYPE||RPAD(:NE_NAME_1,5,''_'')';
else
    l_ntc.ntc_default     := ':NE_OWNER||RPAD(:NE_NAME_1,5,''_'')';
end if;
    l_ntc.ntc_prompt      := 'AgencyLinkcode';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'N';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'L';
    l_ntc.ntc_column_name := 'NE_PREFIX';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 11;
    l_ntc.ntc_displayed   := 'N';
    l_ntc.ntc_str_length  := 1;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := '''L''';
    l_ntc.ntc_prompt      := 'Sys Flag';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'N';
--
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'LLNK';
    l_ntc.ntc_column_name := 'NE_SUB_CLASS';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 1;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 2;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := 'SELECT NSC_SUB_CLASS NSC_CODE, NSC_DESCR NSC_MEANING, NSC_SUB_CLASS FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''L''';
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'Section Class';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'LLNK';
    l_ntc.ntc_column_name := 'NE_NAME_2';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 2;
    l_ntc.ntc_displayed   := 'Y';
    l_ntc.ntc_str_length  := 3;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'N';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := NULL;
    l_ntc.ntc_prompt      := 'DoT Budget Code';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
    ins_ntc(p_rec_ntc => l_ntc);
--
    l_ntc.ntc_nt_type     := 'LLNK';
    l_ntc.ntc_column_name := 'NE_PREFIX';
    l_ntc.ntc_column_type := 'VARCHAR2';
    l_ntc.ntc_seq_no      := 10;
    l_ntc.ntc_displayed   := 'N';
    l_ntc.ntc_str_length  := 1;
    l_ntc.ntc_mandatory   := 'N';
    l_ntc.ntc_domain      := NULL;
    l_ntc.ntc_query       := NULL;
    l_ntc.ntc_inherit     := 'Y';
    l_ntc.ntc_format      := NULL;
    l_ntc.ntc_default     := '''L''';
    l_ntc.ntc_prompt      := 'Sys Flag';
    l_ntc.ntc_separator   := NULL;
    l_ntc.ntc_unique_seq  := NULL;
    l_ntc.ntc_updatable   := 'Y';
    ins_ntc(p_rec_ntc => l_ntc);
  END IF;
--
--
  append_log_content(pi_text => 'NM_TYPE_SUBCLASS');
--
  FOR irec IN get_v2_subtypes LOOP
    l_nsc.nsc_nw_type   := irec.rse_sys_flag;
    l_nsc.nsc_sub_class := irec.scl_sect_class;
    l_nsc.nsc_descr     := irec.scl_descr;
    l_nsc.nsc_seq_no    := irec.scl_seq_no;
    IF g_debug THEN
      Nm3debug.debug_nsc(pi_rec_nsc => l_nsc);
    END IF;
    Nm3ins.ins_nsc(p_rec_nsc => l_nsc);
    -- and do it for LINKS
    l_nsc.nsc_nw_type := l_nsc.nsc_nw_type ||'LNK';
    Nm3ins.ins_nsc(p_rec_nsc => l_nsc);
  END LOOP;
  create_network_domains;
  -- update the checkroute option. This should be N but is set to Y in pre 3200 installs.
  -- When set incorrectly this option will prevent the creation of sections as it will check for
  -- inclusion before the inclusion columns are populated.
  UPDATE HIG_OPTION_VALUES
  SET    hov_value = 'N'
  WHERE  hov_id = 'CHECKROUTE';
--
  do_optional_commit;
--
 append_proc_end_to_log;
--
END create_network_metamodel;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_metamodel (pi_netw_inv_type IN VARCHAR2 DEFAULT 'NETW') IS
   CURSOR cs_ial IS
   SELECT ial1.ial_domain
         ,ial1.ial_dtp_code ial_value
         ,ial1.ial_dtp_code
         ,ial1.ial_meaning
         ,ial1.ial_start_date
         ,ial1.ial_end_date
         ,ial1.ial_seq
    FROM NM_INV_ATTRI_LOOKUP_ALL ial1
   WHERE ial1.ial_dtp_code IS NOT NULL
    AND  ial1.ial_dtp_code != ial1.ial_value
    AND  NOT EXISTS (SELECT 1
                      FROM  NM_INV_ATTRI_LOOKUP_ALL ial2
                     WHERE  ial2.ial_domain     = ial1.ial_domain
                      AND   ial2.ial_value      = ial1.ial_dtp_code
                      AND   ial2.ial_start_date = ial1.ial_start_date
                    );
   CURSOR cs_ita IS
   SELECT REPLACE(ita_view_col_name,' ', '_')
         ,ita_attrib_name
         ,NVL(nit_table_name,'NM_INV_ITEMS_ALL') nit_table_name
         ,ita.ROWID ita_rowid
    FROM  NM_INV_TYPE_ATTRIBS_ALL ita
         ,NM_INV_TYPES_ALL
   WHERE  ita_inv_type = nit_inv_type;
   l_tab_view_col_name Nm3type.tab_varchar30;
   l_tab_attrib_name   Nm3type.tab_varchar30;
   l_tab_table_name    Nm3type.tab_varchar30;
   l_tab_ita_rowid     Nm3type.tab_rowid;
   l_ntr               NM_INV_TYPE_ROLES%ROWTYPE;
   l_nit               NM_INV_TYPES_ALL%ROWTYPE;
   l_ita               NM_INV_TYPE_ATTRIBS_ALL%ROWTYPE;
   l_id                NM_INV_DOMAINS_ALL%ROWTYPE;
   l_ial               NM_INV_ATTRI_LOOKUP_ALL%ROWTYPE;
   l_nin               NM_INV_NW_ALL%ROWTYPE;
   l_xsr               NM_XSP_RESTRAINTS%ROWTYPE;
   l_nwx               NM_NW_XSP%ROWTYPE;
   l_itg               NM_INV_TYPE_GROUPINGS_ALL%ROWTYPE;
   v2_attrib           v2_inv_type_attribs%ROWTYPE;
   CURSOR get_v2_inv_types IS
/*   SELECT ity_elec_drain_carr
         ,ity_sys_flag
         ,ity_inv_code
         ,ity_pnt_or_cont
         ,DECODE(ity_x_sect_allow_flag
                ,'Y','Y'
                ,'N'
                ) ity_x_sect_allow_flag
         ,ity_contiguous
         ,ity_descr
         ,ity_screen_seq
         ,ity_view_name
         ,ity_start_date
         ,ity_end_date
         ,ity_multi_allowed
         ,ity_parent_ity
   FROM   v2_inv_item_types
   WHERE EXISTS (SELECT 'X'
                 FROM   MIG_DTP_LOCAL
                 WHERE  rse_sys_flag = ity_sys_flag)
   ORDER BY ity_inv_code DESC;*/
   SELECT ity_elec_drain_carr
         ,ity_sys_flag
         ,ity_inv_code
         ,ity_pnt_or_cont
         ,DECODE(ity_x_sect_allow_flag
                ,'Y','Y'
                ,'N'
                ) ity_x_sect_allow_flag
         ,ity_contiguous
         ,ity_descr
         ,ity_screen_seq
         ,ity_view_name
         ,ity_start_date
         ,ity_end_date
         ,ity_multi_allowed
         ,ity_parent_ity
   FROM   v2_inv_item_types,MIG_DTP_LOCAL
   WHERE  rse_sys_flag = ity_sys_flag
   ORDER BY ity_inv_code DESC, rse_sys_flag_Count DESC;

   CURSOR cs_itd IS
   SELECT ROWID ita_rowid
         ,ita_id_domain
         ,ita_fld_length
         ,ita_inv_type
         ,ita_attrib_name
    FROM  NM_INV_TYPE_ATTRIBS_ALL
   WHERE  ita_id_domain IS NOT NULL;
   --
   CURSOR cs_id (c_domain VARCHAR2) IS
   SELECT MAX(LENGTH(ial_value))
    FROM  nm_inv_attri_lookup
   WHERE  ial_domain = c_domain;
   --
   l_max_len PLS_INTEGER;
   --
   CURSOR cs_xsr IS
   SELECT xsr_ity_sys_flag
         ,xsr_x_sect_value
         ,xsr_scl_class
         ,xsr_descr
    FROM  v2_xsp_restraints
    WHERE EXISTS (SELECT 'X'
                FROM   MIG_DTP_LOCAL
                WHERE  rse_sys_flag = xsr_ity_sys_flag)
    AND xsr_ity_inv_code != '$$'
--modified to bring only those subclasses on network  as per subclass code
    AND EXISTS
    (SELECT 'x'
     FROM v2_road_segs, v2_section_classes
     WHERE rse_scl_sect_class=scl_sect_class
	 AND scl_Sect_class=xsr_scl_class
	 AND rse_sys_flag=xsr_ity_sys_flag
	 );



   CURSOR c1 IS
    SELECT xsr_ity_inv_code xsr_ity
          ,xsr_ity_sys_flag
          ,xsr_scl_class
          ,xsr_x_sect_value
          ,xsr_descr
      FROM v2_xsp_restraints
          ,v2_inv_item_types
    WHERE EXISTS (SELECT 'X'
                FROM   MIG_DTP_LOCAL
                WHERE  rse_sys_flag = xsr_ity_sys_flag)
    AND xsr_ity_inv_code = ity_inv_code
    AND xsr_ity_sys_flag = ity_sys_flag
    AND xsr_ity_inv_code != '$$'
--modified to bring only those subclasses on network  as per subclass code
    AND EXISTS
    (SELECT 'x'
     FROM v2_road_segs, v2_section_classes
     WHERE rse_scl_sect_class=scl_sect_class
	 AND scl_Sect_class=xsr_scl_class
     AND rse_sys_flag=xsr_ity_sys_flag
     );
--
   TYPE t_v2_inv_attribs IS REF CURSOR;
   c_v2_inv_attribs t_v2_inv_attribs;
   l_v2_inv_attribs VARCHAR2(2000) := 'SELECT * '||
                                      'FROM v2_inv_type_attribs '||
                                      'WHERE EXISTS (SELECT 1 '||
                                      '              FROM   inv_type_translations '||
                                      '              WHERE  ity_inv_code = ita_iit_inv_code'||
                                      '              AND    ity_sys_flag = ita_ity_sys_flag) ';
  CURSOR get_lookup_vals IS
  SELECT iad_ita_ity_sys_flag
        ,iad_ita_inv_code
        ,iad_ita_attrib_name
        ,iad_value
        ,iad_dtp_code
        ,iad_meaning
        ,iad_start_date
        ,iad_end_date
        ,ROWNUM row_num
  FROM   v2_inv_attri_domains
        ,v2_inv_type_attribs
        ,v2_inv_item_types
  WHERE EXISTS (SELECT 'X'
                FROM   MIG_DTP_LOCAL
                WHERE  rse_sys_flag = iad_ita_ity_sys_flag)
  AND   iad_ita_attrib_name  = ita_attrib_name
  AND   iad_ita_inv_code     = ita_iit_inv_code
  AND   iad_ita_ity_sys_flag = ita_ity_sys_flag
  AND   ita_iit_inv_code     = ity_inv_code
  AND   ita_ity_sys_flag     = ity_sys_flag;

  CURSOR get_v2_inv_attri_domains IS
  select iad_ita_attrib_name
         , iad_ita_inv_code
         , iad_ita_ity_sys_flag
		 ,min(nvl(iad_start_Date,g_mig_earliest_date)) iad_start_Date
		 ,max(iad_end_Date) iad_end_Date
		 from
( SELECT iad_ita_attrib_name
         , iad_ita_inv_code
         , iad_ita_ity_sys_flag
         , iad_start_date
         , iad_end_date
  FROM   v2_inv_attri_domains
        ,v2_inv_type_attribs
        ,v2_inv_item_types
  WHERE EXISTS (SELECT 'X'
                FROM   MIG_DTP_LOCAL
                WHERE  rse_sys_flag = iad_ita_ity_sys_flag)
  AND   iad_ita_attrib_name  = ita_attrib_name
  AND   iad_ita_inv_code     = ita_iit_inv_code
  AND   iad_ita_ity_sys_flag = ita_ity_sys_flag
  AND   ita_iit_inv_code     = ity_inv_code
  AND   ita_ity_sys_flag     = ity_sys_flag
  GROUP BY iad_ita_attrib_name
         , iad_ita_inv_code
         , iad_ita_ity_sys_flag
         , iad_start_date
         , iad_end_date
		 )
		 group by iad_ita_attrib_name
         , iad_ita_inv_code
         , iad_ita_ity_sys_flag;
--
  CURSOR get_hierarchy IS
  SELECT ity_inv_code
        ,ity_sys_flag
        ,ity_start_date
        ,ity_parent_ity
  FROM   v2_inv_item_types
  WHERE  ity_parent_ity IS NOT NULL;
  --
   FUNCTION col_exists (p_table VARCHAR2, p_col VARCHAR2) RETURN BOOLEAN IS
      CURSOR cs_atc (c_owner  VARCHAR2
                    ,c_table  VARCHAR2
                    ,c_column VARCHAR2
                    ) IS
      SELECT 1
       FROM  all_tab_columns
      WHERE  owner       = c_owner
       AND   table_name  = c_table
       AND   column_name = c_column;
      l_dummy  PLS_INTEGER;
      l_retval BOOLEAN;
   BEGIN
      OPEN  cs_atc (Hig.get_application_owner, p_table, p_col);
      FETCH cs_atc INTO l_dummy;
      l_retval := cs_atc%FOUND;
      CLOSE cs_atc;
      RETURN l_retval;
   END col_exists;
--
  PROCEDURE tidy_data IS
  BEGIN
     append_log_content(pi_text => 'Tidying existing data');
	 --DELETE FROM NM_NW_AD_LINK_ALL;
   --  DELETE FROM NM_NW_AD_TYPES;
   --  DELETE FROM NM_INV_ITEMS_ALL;
   --  DELETE FROM NM_INV_TYPE_GROUPINGS_ALL;
   --  DELETE FROM NM_INV_ATTRI_LOOKUP_ALL;
   --  DELETE FROM NM_INV_TYPE_ATTRIBS_ALL;
   --  DELETE FROM NM_INV_NW_ALL;
   --  DELETE FROM NM_XSP_RESTRAINTS;
   --  DELETE FROM NM_NW_XSP;
   --  DELETE FROM NM_INV_TYPE_ROLES;
   --  DELETE FROM NM_INV_TYPES_ALL;
   --  DELETE FROM NM_INV_DOMAINS_ALL;
     DELETE FROM NM2_NM3_INV_TYPE_CHANGES;
     do_optional_commit;
     append_log_content(pi_text => 'Done');
  END tidy_data;
--
  PROCEDURE do_inv_type_translations IS
  BEGIN
    --------------------------------------------------------------------------------
    -- create and populate inv_type_translations table to faciliate 2 to 4 character
    -- inventory codes
    --------------------------------------------------------------------------------
    append_log_content(pi_text => 'INV_TYPE_TRANSLATIONS');
    IF Nm3ddl.does_object_exist(p_object_name => 'INV_TYPE_TRANSLATIONS'
                               ,p_object_type => 'TABLE') THEN
      EXECUTE IMMEDIATE ('DROP TABLE inv_type_translations');
    END IF;
    EXECUTE IMMEDIATE ('CREATE TABLE inv_type_translations '||
                       'AS SELECT * '||
                       'FROM v2_inv_item_types '||
                       'WHERE EXISTS (SELECT 1 '||
                       'FROM   mig_dtp_local ' ||
                       'WHERE  rse_sys_flag = ity_sys_flag)');
    EXECUTE IMMEDIATE ('ALTER TABLE inv_type_translations ADD (nit_inv_type VARCHAR2(4))');
    EXECUTE IMMEDIATE ('UPDATE inv_type_translations SET    nit_inv_type = ity_inv_code');
    EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX ITY_INDEX_P1 ON INV_TYPE_TRANSLATIONS
                       (ITY_SYS_FLAG, ITY_INV_CODE)');
    EXECUTE IMMEDIATE ('CREATE INDEX ITY_INDEX_P2 ON INV_TYPE_TRANSLATIONS
                       (ITY_INV_CODE, ITY_PNT_OR_CONT)');
    -- create synonym for nm_units table
    IF NOT Nm3ddl.check_syn_exists(p_owner => USER
                                  ,p_name  => 'NM_UNITS') THEN
      Nm3ddl.create_synonym_for_object('NM_UNITS');
    END IF;
  END do_inv_type_translations;
  --
  FUNCTION get_v2_domain(p_nm2_inv_code IN NM_INV_TYPES_ALL.nit_inv_type%TYPE
                        ,p_attrib_name  IN VARCHAR2
                        ,p_sys_flag     IN VARCHAR2)
                        RETURN  NM_INV_DOMAINS_ALL.id_domain%TYPE IS
    CURSOR find_domain (p_nm2_inv_code IN NM_INV_TYPES_ALL.nit_inv_type%TYPE
                       ,p_attrib_name  IN VARCHAR2
                       ,p_sys_flag     IN VARCHAR2) IS
    SELECT 1
    FROM   v2_inv_attri_domains d
    WHERE  d.iad_ita_attrib_name  = p_attrib_name
    AND    d.iad_ita_inv_code     = p_nm2_inv_code
    AND    d.iad_ita_ity_sys_flag = p_sys_flag;
    l_dummy PLS_INTEGER;
    l_found BOOLEAN;
  BEGIN
    OPEN find_domain (p_nm2_inv_code, p_attrib_name, p_sys_flag);
    FETCH find_domain INTO l_dummy;
    l_found := find_domain%FOUND;
    CLOSE find_domain;
    IF l_found THEN
      RETURN get_nm3_inv_code(p_nm2_inv_code, p_sys_flag)||'_'||p_attrib_name;
    ELSE
      RETURN NULL;
    END IF;
  END get_v2_domain;
--
  PROCEDURE inv_load_tablespace_check IS
  CURSOR inv_tablespace IS
  SELECT tablespace_name
  FROM   user_tablespaces
  WHERE  tablespace_name = 'HHINV_LOAD_3_SPACE';
  l_dummy user_tablespaces.tablespace_name%TYPE;
  l_found BOOLEAN;
  BEGIN
    OPEN inv_tablespace;
    FETCH inv_tablespace INTO l_dummy;
    l_found := inv_tablespace%FOUND;
    CLOSE inv_tablespace;
    IF NOT l_found THEN
      append_log_content('NOTE: HHINV_LOAD_3_SPACE tablespace cannot be accessed. The inventory loader will not work without this. This does not affect the migration of inventory');
    END IF;
  END inv_load_tablespace_check;
--
  FUNCTION return_relation(p_inv_type    IN nm_inv_types.nit_inv_type%TYPE
                          ,p_parent_type IN nm_inv_types.nit_inv_type%TYPE)
  RETURN nm_inv_type_groupings.itg_relation%TYPE IS
    l_child  nm_inv_types.nit_pnt_or_cont%TYPE;
    l_parent nm_inv_types.nit_pnt_or_cont%TYPE;
    l_retval nm_inv_type_groupings.itg_relation%TYPE;
  BEGIN
    l_child := Nm3inv.get_nit_pnt_or_cont(p_inv_type);
    l_parent := Nm3inv.get_nit_pnt_or_cont(p_parent_type);
    IF l_parent = 'P' AND l_child = 'P' THEN
      l_retval := 'AT';
    ELSIF l_parent = 'P' AND l_child = 'C' THEN
      l_retval := 'NONE';
    ELSIF l_parent = 'C' AND l_child = 'C' THEN
      l_retval := 'IN';
    ELSIF l_parent = 'C' AND l_child = 'P' THEN
      l_retval := 'IN';
    END IF;
    RETURN l_retval;
  END return_relation;
--
  FUNCTION get_inv_type_start_Date(p_inv_type IN nm_inv_types.nit_inv_type%TYPE)
  RETURN DATE IS
  l_retval DATE;
  BEGIN
    SELECT nit_start_date
	INTO l_retval
	FROM NM_INV_TYPES_ALL
	WHERE nit_inv_type=p_inv_type;
	RETURN l_retval;
  END get_inv_type_start_Date;

  FUNCTION get_inv_domain_start_Date(p_domain IN NM_INV_DOMAINS_ALL.id_domain%TYPE)
  RETURN DATE IS
  l_retval DATE;
  BEGIN
    SELECT id_start_date
	INTO l_retval
	FROM NM_INV_DOMAINS_ALL
	WHERE id_domain=p_domain;
	RETURN l_retval;
  END get_inv_domain_start_Date;


BEGIN
--
 g_proc_name := 'create_inventory_metamodel';
 append_proc_start_to_log;
--
  inv_load_tablespace_check;
  tidy_data;
  do_inv_type_translations;
  --need to update the  'ELEC_DRAIN_CARR' from the 'INVENTORY_GROUPS' domain
  INSERT INTO HIG_CODES
  SELECT
  'ELEC_DRAIN_CARR',HCO_CODE, HCO_MEANING, HCO_SYSTEM, HCO_SEQ, HCO_START_DATE, HCO_END_DATE
  FROM HIG_CODES ig
  WHERE hco_domain='INVENTORY_GROUPS'
  AND NOT EXISTS
  (SELECT 'x' FROM HIG_CODES edc
   WHERE edc.HCO_DOMAIN='ELEC_DRAIN_CARR'
   AND edc.HCO_CODE=ig.hco_code);


  append_log_content(pi_text => 'NM_INV_TYPES');
  FOR i_rec IN get_v2_inv_types LOOP
    l_nit.nit_elec_drain_carr    := i_rec.ity_elec_drain_carr;
    l_nit.nit_inv_type           := Get_New_Nm3_Inv_Type(i_rec.ity_inv_code, i_rec.ity_sys_flag);
    l_nit.nit_pnt_or_cont        := i_rec.ity_pnt_or_cont;
    l_nit.nit_x_sect_allow_flag  := i_rec.ity_x_sect_allow_flag;
    l_nit.nit_contiguous         := NVL(i_rec.ity_contiguous,'N');
    l_nit.nit_descr              := i_rec.ity_descr;
    l_nit.nit_screen_seq         := i_rec.ity_screen_seq;
    l_nit.nit_view_name          := i_rec.ity_view_name;
    l_nit.nit_start_date         := trunc(NVL(i_rec.ity_start_date,g_mig_earliest_date));
    l_nit.nit_end_date           := trunc(i_rec.ity_end_date);
    l_nit.nit_multiple_allowed   := NVL(i_rec.ity_multi_allowed,'N');
    l_nit.nit_replaceable        := 'Y';
    l_nit.nit_exclusive          := 'N';
    l_nit.nit_category           := 'I';
    l_nit.nit_linear             := 'N';
    l_nit.nit_flex_item_flag     := 'N';
    l_nit.nit_admin_type         := g_admin_type;
    INSERT INTO NM2_NM3_INV_TYPE_CHANGES
    (itc_old_inv_code, itc_sys_flag, itc_new_inv_code)
    VALUES
    (i_rec.ity_inv_code, i_rec.ity_sys_flag, l_nit.nit_inv_type);
    IF l_nit.nit_inv_type != i_rec.ity_inv_code THEN
      append_log_content('Version 2 inventory type '||i_rec.ity_inv_code||' cannot be migrated. A new code of '||l_nit.nit_inv_type ||' has been created.');
    END IF;
    IF g_debug THEN
      Nm3debug.debug_nit(pi_rec_nit => l_nit);
    END IF;
    Nm3ins.ins_nit(p_rec_nit => l_nit);
    -- update inv_type_translations with this new nm3 inventory type
    EXECUTE IMMEDIATE 'UPDATE inv_type_translations '||
                      'SET nit_inv_type = :nit_inv_type '||
                      'WHERE ity_sys_flag = :ity_sys_flag '||
                      'AND   ity_inv_code = :ity_inv_code '
    USING l_nit.nit_inv_type, i_rec.ity_sys_flag, i_rec.ity_inv_code;
    -- and insert a role
    l_ntr.itr_inv_type := l_nit.nit_inv_type;
    l_ntr.itr_hro_role := 'NET_USER';
    l_ntr.itr_mode     := Nm3type.c_normal;
    IF g_debug THEN
      Nm3debug.debug_itr(pi_rec_itr => l_ntr);
    END IF;
    Nm3ins.ins_itr(p_rec_itr => l_ntr);
    -- and insert the network it can be placed on
    l_nin.nin_nw_type       := i_rec.ity_sys_flag;
    l_nin.nin_nit_inv_code  := l_nit.nit_inv_type;
    l_nin.nin_loc_mandatory := 'Y';
    l_nin.nin_start_date    :=trunc( NVL(i_rec.ity_start_date,get_inv_type_start_Date(l_nin.nin_nit_inv_code)));
    l_nin.nin_end_date      := trunc(i_rec.ity_end_date);
    IF g_debug THEN
      Nm3debug.debug_nin(pi_rec_nin => l_nin);
    END IF;
    Nm3ins.ins_nin(l_nin);
  END LOOP;
--
  append_log_content(pi_text => 'NM_INV_DOMAINS');
  FOR irec IN get_v2_inv_attri_domains LOOP
    l_id.id_domain     := get_nm3_inv_code(irec.iad_ita_inv_code, irec.iad_ita_ity_sys_flag)||'_'||irec.iad_ita_attrib_name;
    l_id.id_title      := l_id.id_domain;
    l_id.id_start_date := trunc(NVL(irec.iad_start_date,g_mig_earliest_date));
    l_id.id_end_date   := trunc(irec.iad_end_date);
    IF g_debug THEN
      Nm3debug.debug_id(pi_rec_id => l_id);
    END IF;
    Nm3ins.ins_id(l_id);
  END LOOP;
--
  append_log_content(pi_text => 'NM_INV_TYPE_ATTRIBS_ALL');
  OPEN c_v2_inv_attribs FOR l_v2_inv_attribs;
  LOOP
    FETCH c_v2_inv_attribs INTO v2_attrib;
    EXIT WHEN c_v2_inv_attribs%NOTFOUND;
    l_ita.ita_inv_type       := get_nm3_inv_code(v2_attrib.ita_iit_inv_code, v2_attrib.ita_ity_sys_flag);
    l_ita.ita_attrib_name    := UPPER(v2_attrib.ita_attrib_name);
    l_ita.ita_dec_places     := v2_attrib.ita_dec_places;
    l_ita.ita_dynamic_attrib := v2_attrib.ita_dynamic_attrib;
    l_ita.ita_fld_length     := v2_attrib.ita_fld_length;
    l_ita.ita_format         := v2_attrib.ita_format;
    l_ita.ita_scrn_text      := v2_attrib.ita_scrn_text;
    l_ita.ita_validate_yn    := v2_attrib.ita_validate_yn;
    l_ita.ita_disp_seq_no    := NVL(v2_attrib.ita_disp_seq_no,999);
    l_ita.ita_max            := v2_attrib.ita_max;
    l_ita.ita_min            := v2_attrib.ita_min;
    l_ita.ita_view_attri     := UPPER(v2_attrib.ita_attrib_name);
    l_ita.ita_view_col_name  := REPLACE(NVL(v2_attrib.ita_view_col_name,UPPER(v2_attrib.ita_attrib_name)),' ', '_');
    l_ita.ita_dtp_code       := v2_attrib.ita_dtp_code;
    l_ita.ita_start_date     := trunc(NVL(v2_attrib.ita_start_date,get_inv_type_start_Date(l_ita.ita_inv_type)));
    l_ita.ita_end_date       := trunc(v2_attrib.ita_end_date);
    l_ita.ita_queryable      := NVL(v2_attrib.ita_queryable,'N');
    l_ita.ita_ukpms_param_no := v2_attrib.ita_ukpms_param_no;
    l_ita.ita_units          := v2_attrib.ita_units;
	l_ita.ITA_EXCLUSIVE		 :='N';
	l_ita.ITA_displayed		 :='N';
    IF UPPER(v2_attrib.ita_attrib_name) = 'IIT_PRIMARY_KEY' THEN
      l_ita.ita_mandatory_yn   := 'Y';
    ELSE
      l_ita.ita_mandatory_yn   := NVL(v2_attrib.ita_manditory_yn,'N');
    END IF;
    l_ita.ita_id_domain      := get_v2_domain(v2_attrib.ita_iit_inv_code, v2_attrib.ita_attrib_name, v2_attrib.ita_ity_sys_flag);
    IF g_debug THEN
      Nm3debug.debug_ita(pi_rec_ita => l_ita);
    END IF;
    Nm3ins.ins_ita(l_ita);
  END LOOP;
--
  append_log_content(pi_text => 'NM_INV_ATTRI_LOOKUP');
  FOR irec IN get_lookup_vals LOOP
    l_ial.ial_domain     := get_nm3_inv_code(irec.iad_ita_inv_code, irec.iad_ita_ity_sys_flag)||'_'||irec.iad_ita_attrib_name;
    l_ial.ial_value      := irec.iad_value;
    l_ial.ial_dtp_code   := irec.iad_dtp_code;
    l_ial.ial_meaning    := irec.iad_meaning;
    l_ial.ial_start_date := trunc(NVL(irec.iad_start_date,get_inv_domain_start_Date(l_ial.ial_domain)));
    l_ial.ial_end_date   := trunc(irec.iad_end_date);
    l_ial.ial_seq        := irec.row_num;
    IF g_debug THEN
      Nm3debug.debug_ial(pi_rec_ial => l_ial);
    END IF;
    Nm3ins.ins_ial(l_ial);
  END LOOP;
--
   FOR cs_rec IN cs_ial LOOP
     BEGIN
       l_ial.ial_domain     := cs_rec.ial_domain;
       l_ial.ial_value      := cs_rec.ial_dtp_code;
       l_ial.ial_dtp_code   := cs_rec.ial_dtp_code;
       l_ial.ial_meaning    := cs_rec.ial_meaning;
       l_ial.ial_start_date := trunc(cs_rec.ial_start_date);
       l_ial.ial_end_date   := trunc(cs_rec.ial_end_date);
       l_ial.ial_seq        := cs_rec.ial_seq;
       IF g_debug THEN
         Nm3debug.debug_ial(pi_rec_ial => l_ial);
       END IF;
       Nm3ins.ins_ial(l_ial);
     EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN
         NULL;
       END;
   END LOOP;
--
   append_log_content(pi_text => 'NM_INV_TYPE_ATTRIBS_ALL (views)');
   OPEN  cs_ita;
   FETCH cs_ita
    BULK COLLECT
    INTO l_tab_view_col_name
        ,l_tab_attrib_name
        ,l_tab_table_name
        ,l_tab_ita_rowid;
   CLOSE cs_ita;
   FOR i IN 1..l_tab_ita_rowid.COUNT
    LOOP
      IF NOT col_exists (l_tab_table_name(i), l_tab_attrib_name(i))
       AND   col_exists (l_tab_table_name(i), l_tab_view_col_name(i))
       THEN
         -- If the specified one does not exist, but the view col does
         UPDATE NM_INV_TYPE_ATTRIBS_ALL
          SET   ita_attrib_name = l_tab_view_col_name(i)
         WHERE  ROWID           = l_tab_ita_rowid(i);
      END IF;
   END LOOP;
--
  UPDATE NM_INV_TYPE_ATTRIBS_ALL
   SET   ita_fld_length = (SELECT MAX(LENGTH(ial_value))
                            FROM  NM_INV_ATTRI_LOOKUP_ALL
                           WHERE  ial_domain = ita_id_domain
                          )
  WHERE  ita_id_domain IS NOT NULL;
--
   FOR cs_rec IN cs_itd
    LOOP
      l_max_len := NULL;
      OPEN  cs_id (cs_rec.ita_id_domain);
      FETCH cs_id INTO l_max_len;
      CLOSE cs_id;
      IF NVL(l_max_len,cs_rec.ita_fld_length) > cs_rec.ita_fld_length
       THEN
--         dbms_output.put_line(cs_rec.ita_inv_type||'.'||cs_rec.ita_attrib_name||' From '||cs_rec.ita_fld_length||' to '||l_max_len);
         UPDATE NM_INV_TYPE_ATTRIBS_ALL
          SET   ita_fld_length = l_max_len
         WHERE  ROWID          = cs_rec.ita_rowid;
      END IF;
   END LOOP;
--
   append_log_content(pi_text => 'NM_INV_TYPE_GROUPINGS');
   FOR irec IN get_hierarchy LOOP
     l_itg.itg_inv_type         := get_nm3_inv_code(irec.ity_inv_code, irec.ity_sys_flag);
     l_itg.itg_parent_inv_type  := get_nm3_inv_code(irec.ity_parent_ity, irec.ity_sys_flag);
     l_itg.itg_mandatory        := 'Y';
     l_itg.itg_relation         := return_relation(l_itg.itg_inv_type, l_itg.itg_parent_inv_type);
     l_itg.itg_start_date       := NVL(irec.ity_start_date,get_inv_type_start_Date(l_itg.itg_inv_type));
     IF g_debug THEN
       Nm3debug.debug_itg(l_itg);
     END IF;
     Nm3ins.ins_itg(l_itg);
   END LOOP;
--
   append_log_content(pi_text => 'NM_NW_XSP');
   FOR cs_rec IN cs_xsr
    LOOP
      BEGIN
         l_nwx.nwx_nw_type       := cs_rec.xsr_ity_sys_flag;
         l_nwx.nwx_x_sect        := cs_rec.xsr_x_sect_value;
         l_nwx.nwx_nsc_sub_class := cs_rec.xsr_scl_class;
         l_nwx.nwx_descr         := cs_rec.xsr_descr;
          IF g_debug THEN
            Nm3debug.debug_nwx(l_nwx);
          END IF;
          Nm3ins.ins_nwx(p_rec_nwx => l_nwx);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN NULL;
      END;
   END LOOP;
--
   append_log_content(pi_text => 'XSP_RESTRAINTS');
   FOR recs IN c1 LOOP
      BEGIN
         l_xsr.xsr_nw_type      := recs.xsr_ity_sys_flag;
         l_xsr.xsr_ity_inv_code := get_nm3_inv_code(recs.xsr_ity, recs.xsr_ity_sys_flag);
         l_xsr.xsr_scl_class    := recs.xsr_scl_class;
         l_xsr.xsr_x_sect_value := recs.xsr_x_sect_value;
         l_xsr.xsr_descr        := recs.xsr_descr;
         IF g_debug THEN
           Nm3debug.debug_xsr(l_xsr);
         END IF;
         Nm3ins.ins_xsr(l_xsr);
       END;
   END LOOP;
   -- update the version 2 inventory codes to match the version 3 codes
   EXECUTE IMMEDIATE 'UPDATE inv_type_translations SET ity_inv_code = nit_inv_type';
   -- and the parent inventory type references
   EXECUTE IMMEDIATE ' UPDATE inv_type_translations'||
                     ' SET ity_parent_ity = (SELECT itc_new_inv_code'||
                     '                       FROM   nm2_nm3_inv_type_changes'||
                     '                       WHERE  itc_old_inv_code = ity_parent_ity'||
                     '                       AND    itc_sys_flag     = ity_sys_flag)'||
                     ' WHERE ity_parent_ity IS NOT NULL';
   do_optional_commit;
   append_log_content('Creating index on inv_type_translations');
   EXECUTE IMMEDIATE ('CREATE UNIQUE INDEX ITY_NIT ON INV_TYPE_TRANSLATIONS (NIT_INV_TYPE, ITY_SYS_FLAG)');
--
 append_proc_end_to_log;
--
END create_inventory_metamodel;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_network_metamodel_inv(pi_netw_inv_type IN VARCHAR2 DEFAULT 'NETW') IS
   l_inv_type_rec NM_INV_TYPES_ALL%ROWTYPE;
   l_inv_type    nm_inv_type_attribs.ita_inv_type%TYPE;
   l_view_col    nm_inv_type_attribs.ita_view_col_name%TYPE;
   l_attrib_name nm_inv_type_attribs.ita_attrib_name%TYPE;
   --
   TYPE tab_ita IS TABLE OF nm_inv_type_attribs%ROWTYPE INDEX BY BINARY_INTEGER;
   l_rec_ita nm_inv_type_attribs%ROWTYPE;
   l_tab_ita tab_ita;
--
   l_admin_type nm_admin_units.nau_admin_type%TYPE;
--
   CURSOR cs_lock_nit (c_inv_type VARCHAR2) IS
   SELECT 1
    FROM  nm_inv_types
         ,nm_inv_type_attribs
         ,NM_INV_NW_ALL
         ,NM_INV_TYPE_ROLES
   WHERE  nit_inv_type = c_inv_type
    AND   nit_inv_type = ita_inv_type
    AND   nit_inv_type = nin_nit_inv_code
    AND   nit_inv_type = itr_inv_type
   FOR UPDATE NOWAIT;
--
   l_tab_dummy Nm3type.tab_number;
--
  PROCEDURE create_network_domain (p_domain NM_INV_TYPES_ALL.nit_inv_type%TYPE) IS
  CURSOR get_lookup_vals (p_domain NM_INV_TYPES_ALL.nit_inv_type%TYPE) IS
  SELECT *
  FROM   v2_hig_codes
  WHERE  hco_domain = p_domain
  ORDER BY hco_seq;
  l_id  NM_INV_DOMAINS_ALL%ROWTYPE;
  l_ial NM_INV_ATTRI_LOOKUP_ALL%ROWTYPE;
  BEGIN
    l_id.id_domain     := p_domain;
    l_id.id_title      := p_domain;
    l_id.id_start_date := g_mig_earliest_date;
    l_id.id_end_date   := NULL;
    IF g_debug THEN
      Nm3debug.debug_id(l_id);
    END IF;
    Nm3ins.ins_id(l_id);
    FOR irec IN get_lookup_vals(p_domain) LOOP
      l_ial.ial_domain     := irec.hco_domain;
      l_ial.ial_value      := irec.hco_code;
      l_ial.ial_meaning    := irec.hco_meaning;
      l_ial.ial_start_date := NVL(irec.hco_start_date,g_mig_earliest_date);
      l_ial.ial_end_date   := irec.hco_end_date;
      l_ial.ial_seq        := NVL(irec.hco_seq,1);
      IF g_debug THEN
        Nm3debug.debug_ial(l_ial);
      END IF;
      Nm3ins.ins_ial(l_ial);
    END LOOP;
  END create_network_domain;
--
   PROCEDURE ins_tab_ita IS
   BEGIN
      append_log_content(pi_text => 'NM_INV_TYPE_ATTRIBS_ALL');
      FOR i IN 1..l_tab_ita.COUNT
       LOOP
         l_rec_ita := l_tab_ita(i);
         IF l_rec_ita.ita_id_domain IS NOT NULL THEN
           -- create domain and lookup values
           create_network_domain(l_rec_ita.ita_id_domain);
         END IF;
         --
         IF g_debug THEN
           Nm3debug.debug_ita(l_rec_ita);
         END IF;
         Nm3ins.ins_ita(l_rec_ita);
     END LOOP;
     l_tab_ita.DELETE;
    do_optional_commit;
  END ins_tab_ita;
--
BEGIN
--
 g_proc_name := 'create_network_metamodel_inv';
 append_proc_start_to_log;
--
   append_log_content(pi_text => 'Checking that inventory type of '||pi_netw_inv_type||' does not already exist');
   ------------------------------------------------
   -- check to see if inventory type already exists
   -- if so then stop processing
   ------------------------------------------------
   l_inv_type_rec := Nm3get.get_nit(pi_nit_inv_type    => pi_netw_inv_type
                                   ,pi_raise_not_found => FALSE);
   IF l_inv_type_rec.nit_inv_type IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(-20001,'Inventory type '||pi_netw_inv_type||' cannot be used to store additional network attributes, since it is already in use.');
   END IF;
   --

--changed this cos AU 1 might be enddated -all we need is the type....
--   l_admin_type := Nm3get.get_nau(pi_nau_admin_unit => 1).nau_admin_type;

   SELECT nau_Admin_type
   INTO l_admin_type
   FROM NM_ADMIN_UNITS_ALL
   WHERE ROWNUM=1;

   --
   -- Use admin unit (1) start date here.
   --
   l_rec_ita.ita_inv_type           := UPPER(pi_netw_inv_type);
   l_rec_ita.ita_dynamic_attrib     := 'N';
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_rec_ita.ita_validate_yn        := 'N';
   l_rec_ita.ita_dtp_code           := NULL;
   l_rec_ita.ita_max                := NULL;
   l_rec_ita.ita_min                := NULL;
   l_rec_ita.ita_start_date         := g_mig_earliest_date;
   l_rec_ita.ita_end_date           := NULL;
   l_rec_ita.ita_queryable          := 'N';
   l_rec_ita.ita_ukpms_param_no     := NULL;
   l_rec_ita.ita_units              := NULL;
   l_rec_ita.ita_format_mask        := NULL;
   --
   OPEN  cs_lock_nit (l_rec_ita.ita_inv_type);
   FETCH cs_lock_nit BULK COLLECT INTO l_tab_dummy;
   CLOSE cs_lock_nit;
   --
   append_log_content(pi_text => 'NM_INV_TYPES_ALL');
   INSERT INTO NM_INV_TYPES_ALL
          (nit_inv_type
          ,nit_pnt_or_cont
          ,nit_x_sect_allow_flag
          ,nit_elec_drain_carr
          ,nit_contiguous
          ,nit_replaceable
          ,nit_exclusive
          ,nit_category
          ,nit_descr
          ,nit_linear
          ,nit_use_xy
          ,nit_multiple_allowed
          ,nit_end_loc_only
          ,nit_view_name
          ,nit_start_date
          ,nit_flex_item_flag
          ,nit_admin_type
          ,nit_top
          )
   VALUES (l_rec_ita.ita_inv_type
          ,'C'
          ,'N'
          ,'C'
          ,'N'
          ,'N'
          ,'N'
          ,'G'
          ,'NM2 Base Datum Inventory'
          ,'N'
          ,'N'
          ,'N'
          ,'N'
          ,NULL
          ,g_mig_earliest_date
          ,'N'
          ,l_admin_type
          ,'N'
          );
-- if you have got a role to see network then also create a role to see network attributes
-- stored as inventory
   append_log_content(pi_text => 'NM_INV_TYPE_ROLES');
   INSERT INTO NM_INV_TYPE_ROLES
         (itr_inv_type
         ,itr_hro_role
         ,itr_mode
         )
   SELECT l_rec_ita.ita_inv_type
         ,hro_role
         ,DECODE(INSTR(hro_role,Nm3type.c_readonly,1,1)
                ,0,Nm3type.c_normal
                ,Nm3type.c_readonly
                )
    FROM  HIG_ROLES
   WHERE  hro_product IN (Nm3type.c_net, Nm3type.c_hig);
--
--
--
   l_rec_ita.ita_exclusive       := 'N';
   l_rec_ita.ita_displayed       := 'N';
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB42';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Road Type';
   l_rec_ita.ita_view_col_name      := 'RSE_ROAD_TYPE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'Y';
   l_rec_ita.ita_id_domain          := 'ROAD_TYPE';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB45';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Open Status';
   l_rec_ita.ita_view_col_name      := 'RSE_STATUS';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'Y';
   l_rec_ita.ita_id_domain          := 'SECTION_STATUS';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_DATE_ATTRIB87';
   l_rec_ita.ita_format             := 'DATE';
   l_rec_ita.ita_fld_length         := 9;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Date Opened';
   l_rec_ita.ita_view_col_name      := 'RSE_DATE_OPENED';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB26';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Adoption Status';
   l_rec_ita.ita_view_col_name      := 'RSE_ADOPTION_STATUS';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := 'ADOPTION_STATUS';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_DATE_ATTRIB86';
   l_rec_ita.ita_format             := 'DATE';
   l_rec_ita.ita_fld_length         := 9;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Date Adopted';
   l_rec_ita.ita_view_col_name      := 'RSE_DATE_ADOPTED';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB28';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Carriageway Type';
   l_rec_ita.ita_view_col_name      := 'RSE_CARRIAGEWAY_TYPE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'Y';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB41';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Road Environment';
   l_rec_ita.ita_view_col_name      := 'RSE_ROAD_ENVIRONMENT';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'Y';
   l_rec_ita.ita_id_domain          := 'ROAD_ENVIRONMENT';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_DATE_ATTRIB89';
   l_rec_ita.ita_format             := 'DATE';
   l_rec_ita.ita_fld_length         := 9;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Last Surveyed';
   l_rec_ita.ita_view_col_name      := 'RSE_LAST_SURVEYED';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB25';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Speed Limit';
   l_rec_ita.ita_view_col_name      := 'RSE_SPEED_LIMIT';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB33';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 4;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Inspection Interval';
   l_rec_ita.ita_view_col_name      := 'RSE_INT_CODE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB76';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 6;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Vehicles Per Day';
   l_rec_ita.ita_view_col_name      := 'RSE_VEH_PER_DAY';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB34';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Maintenance Category';
   l_rec_ita.ita_view_col_name      := 'RSE_MAINT_CATEGORY';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'Y';
   l_rec_ita.ita_id_domain          := 'MAINTENANCE_CATEGORY';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB32';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Footway Category';
   l_rec_ita.ita_view_col_name      := 'RSE_FOOTWAY_CATEGORY';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := 'FOOTWAY_CATEGORY';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB20';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 4;
   l_rec_ita.ita_dec_places         := '1';
   l_rec_ita.ita_scrn_text          := 'HGV%';
   l_rec_ita.ita_view_col_name      := 'RSE_HGV_PERCENT';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB22';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Number Of Lanes';
   l_rec_ita.ita_view_col_name      := 'RSE_NUMBER_OF_LANES';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'Y';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB35';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Network Direction';
   l_rec_ita.ita_view_col_name      := 'RSE_NETWORK_DIRECTION';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := 'NETWORK_DIRECTION';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB24';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 4;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Skid Coefficient';
   l_rec_ita.ita_view_col_name      := 'RSE_SKID_RES';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB44';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Shared Items';
   l_rec_ita.ita_view_col_name      := 'RSE_SHARED_ITEMS';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB40';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Road Category';
   l_rec_ita.ita_view_col_name      := 'RSE_ROAD_CATEGORY';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'Y';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_DATE_ATTRIB88';
   l_rec_ita.ita_format             := 'DATE';
   l_rec_ita.ita_fld_length         := 9;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Last Inspected';
   l_rec_ita.ita_view_col_name      := 'RSE_LAST_INSPECTED';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB38';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Reflective Coating (Y/N)';
   l_rec_ita.ita_view_col_name      := 'RSE_REF_COAT_FLAG';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB37';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Record Inventory Reverse (Y/N)';
   l_rec_ita.ita_view_col_name      := 'RSE_RECORD_INVENT_REV';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB51';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Traffic Level';
   l_rec_ita.ita_view_col_name      := 'RSE_TRAFFIC_LEVEL';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB16';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 8;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Road Alias';
   l_rec_ita.ita_view_col_name      := 'RSE_ALIAS';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB78';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 4;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Cnt Code';
   l_rec_ita.ita_view_col_name      := 'RSE_CNT_CODE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB29';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Coord Flag';
   l_rec_ita.ita_view_col_name      := 'RSE_COORD_FLAG';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB39';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Reinstatement Category';
   l_rec_ita.ita_view_col_name      := 'RSE_REINSTATEMENT_CATEGORY';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
/*   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB23';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 3;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Search Group No';
   l_rec_ita.ita_view_col_name      := 'RSE_SEARCH_GROUP_NO';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
*/--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB43';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Seq Signif';
   l_rec_ita.ita_view_col_name      := 'RSE_SEQ_SIGNIF';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB21';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 6;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Max Chain';
   l_rec_ita.ita_view_col_name      := 'RSE_MAX_CHAIN';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB50';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Length Status';
   l_rec_ita.ita_view_col_name      := 'RSE_LENGTH_STATUS';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB83';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 8;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Usrn No';
   l_rec_ita.ita_view_col_name      := 'RSE_USRN_NO';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
/*
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB27';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 3;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Bh Hier Code';
   l_rec_ita.ita_view_col_name      := 'RSE_BH_HIER_CODE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB31';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Engineering Difficulty';
   l_rec_ita.ita_view_col_name      := 'RSE_ENGINEERING_DIFFICULTY';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB17';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 8;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Gis Mapid';
   l_rec_ita.ita_view_col_name      := 'RSE_GIS_MAPID';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB18';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 8;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Gis Mslink';
   l_rec_ita.ita_view_col_name      := 'RSE_GIS_MSLINK';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB19';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Gradient';
   l_rec_ita.ita_view_col_name      := 'RSE_GRADIENT';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB36';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Nla Type';
   l_rec_ita.ita_view_col_name      := 'RSE_NLA_TYPE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB42';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Road Type';
   l_rec_ita.ita_view_col_name      := 'RSE_ROAD_TYPE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := 'ROAD_TYPE';
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB46';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Traffic Sensitivity';
   l_rec_ita.ita_view_col_name      := 'RSE_TRAFFIC_SENSITIVITY';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB77';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 7;
   l_rec_ita.ita_dec_places         := '3';
   l_rec_ita.ita_scrn_text          := 'Begin Mp';
   l_rec_ita.ita_view_col_name      := 'RSE_BEGIN_MP';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB79';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 3;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Couplet Id';
   l_rec_ita.ita_view_col_name      := 'RSE_COUPLET_ID';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB80';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 7;
   l_rec_ita.ita_dec_places         := '3';
   l_rec_ita.ita_scrn_text          := 'End Mp';
   l_rec_ita.ita_view_col_name      := 'RSE_END_MP';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB47';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Gov Level';
   l_rec_ita.ita_view_col_name      := 'RSE_GOV_LEVEL';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB81';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 7;
   l_rec_ita.ita_dec_places         := '3';
   l_rec_ita.ita_scrn_text          := 'Max Mp';
   l_rec_ita.ita_view_col_name      := 'RSE_MAX_MP';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB48';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Prefix';
   l_rec_ita.ita_view_col_name      := 'RSE_PREFIX';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_NUM_ATTRIB82';
   l_rec_ita.ita_format             := 'NUMBER';
   l_rec_ita.ita_fld_length         := 4;
   l_rec_ita.ita_dec_places         := '0';
   l_rec_ita.ita_scrn_text          := 'Route';
   l_rec_ita.ita_view_col_name      := 'RSE_ROUTE';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB49';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 2;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Suffix';
   l_rec_ita.ita_view_col_name      := 'RSE_SUFFIX';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
--
   l_rec_ita.ita_disp_seq_no        := l_tab_ita.COUNT+1;
   l_rec_ita.ita_attrib_name        := 'IIT_CHR_ATTRIB52';
   l_rec_ita.ita_format             := 'VARCHAR2';
   l_rec_ita.ita_fld_length         := 1;
   l_rec_ita.ita_dec_places         := '';
   l_rec_ita.ita_scrn_text          := 'Net Sel Crt';
   l_rec_ita.ita_view_col_name      := 'RSE_NET_SEL_CRT';
   l_rec_ita.ita_view_attri         := l_rec_ita.ita_view_col_name;
   l_rec_ita.ita_mandatory_yn       := 'N';
   l_rec_ita.ita_id_domain          := NULL;
   l_tab_ita(l_rec_ita.ita_disp_seq_no) := l_rec_ita;
*/
   ins_tab_ita;
  append_log_content(pi_text => 'NM_NW_AD_TYPES');
   IF g_d_network THEN
     INSERT INTO NM_NW_AD_TYPES
     (NAD_ID
	 , NAD_INV_TYPE
	 , NAD_NT_TYPE
	 , NAD_GTY_TYPE
	 , NAD_DESCR
	 , NAD_START_DATE
	 , NAD_END_DATE
	 , NAD_PRIMARY_AD
	 , NAD_DISPLAY_ORDER
	 , NAD_SINGLE_ROW
	 , NAD_MANDATORY)
	 SELECT
	   nad_id_seq.NEXTVAL
	   ,l_rec_ita.ita_inv_type
	   ,'D'
	   ,NULL
	   ,l_rec_ita.ita_inv_type||'-D LINK'
	   ,g_mig_earliest_date
	   ,NULL
	   ,'Y'
	   ,1
	   ,'Y'
	   ,'Y'
	   FROM dual;
	 END IF;
   IF g_l_network THEN
     INSERT INTO NM_NW_AD_TYPES
     (NAD_ID
	 , NAD_INV_TYPE
	 , NAD_NT_TYPE
	 , NAD_GTY_TYPE
	 , NAD_DESCR
	 , NAD_START_DATE
	 , NAD_END_DATE
	 , NAD_PRIMARY_AD
	 , NAD_DISPLAY_ORDER
	 , NAD_SINGLE_ROW
	 , NAD_MANDATORY)
	 SELECT
	   nad_id_seq.NEXTVAL
	   ,l_rec_ita.ita_inv_type
	   ,'L'
	   ,NULL
	   ,l_rec_ita.ita_inv_type||'-L LINK'
	   ,g_mig_earliest_date
	   ,NULL
	   ,'Y'
	   ,1
	   ,'Y'
	   ,'Y'
	   FROM dual;
	 END IF;
  do_optional_commit;
--
 append_proc_end_to_log;
--
END create_network_metamodel_inv;
--
-----------------------------------------------------------------------------
--



PROCEDURE migrate_network IS
  l_rec_ne nm_elements%ROWTYPE;




  CURSOR datums_to_migrate IS
  SELECT COUNT(*)
  FROM   v2_road_segs
  WHERE  rse_type     = 'S';
  CURSOR cs_datums IS
  SELECT rse_he_id
        ,rse_unique
        ,rse_admin_unit
        ,rse_type
        ,rse_group
        ,rse_sys_flag
        ,rse_agency
        ,rse_linkcode
        ,rse_sect_no
        ,rse_road_number
        ,rse_start_date
        ,rse_end_date
        ,rse_descr
        ,rse_alias
        ,rse_length
        ,rse_max_chain
        ,rse_pus_node_id_end
        ,rse_pus_node_id_st
        ,rse_road_type
        ,rse_scl_sect_class
        ,rse_status
        ,rse_begin_mp
        ,rse_end_mp
        ,rse_max_mp
        ,rse_prefix
  FROM   v2_road_segs
  WHERE  rse_type     = 'S';
  c_eff_date CONSTANT DATE := Nm3user.get_effective_date;
  PROCEDURE check_node_dates (p_node_name VARCHAR2
                             ,p_st_date  DATE
                             ,p_end_date DATE
                             ,p_node_id  OUT NUMBER
                             ) IS
     CURSOR cs_no(p_node_name VARCHAR2) IS
     SELECT ROWID no_rowid
           ,no_start_date
           ,no_end_date
           ,no_node_id
      FROM  nm_nodes
     WHERE  no_node_name = p_node_name
     AND    no_node_type = g_node_type;
     CURSOR cs_no2(p_node_name VARCHAR2) IS
     SELECT ROWID no_rowid
           ,no_start_date
           ,no_end_date
           ,no_node_id
      FROM  NM_NODES_ALL
     WHERE  no_node_name = p_node_name
     AND    no_node_type = g_node_type;
     l_no_rec cs_no%ROWTYPE;
     l_change BOOLEAN := FALSE;
     l_found  BOOLEAN;
     l_rec_no NM_NODES_ALL%ROWTYPE;
  BEGIN
--   append_log_content(pi_text => 'Check node dates '||p_node_name||' '||p_node_id||' '||to_char(p_st_date,'dd-mon-yyyy')||' '||p_end_date );


    OPEN  cs_no(p_node_name);
    FETCH cs_no INTO l_no_rec;
    l_found := cs_no%FOUND;
    CLOSE cs_no;
    IF NOT l_found THEN
      OPEN  cs_no2(p_node_name);
      FETCH cs_no2 INTO l_no_rec;
      l_found := cs_no2%FOUND;
      CLOSE cs_no2;
    END IF;
    IF l_found THEN
      IF l_no_rec.no_start_date > p_st_date THEN
        l_change := TRUE;
        l_no_rec.no_start_date := p_st_date;
      END IF;
      IF   l_no_rec.no_end_date IS NOT NULL
       AND l_no_rec.no_end_date < NVL(p_end_date,Nm3type.c_big_date)
      THEN
        l_change := TRUE;
        l_no_rec.no_end_date   := p_end_date;
      END IF;
      -- now for the case where road start and end date are the same day
      -- we must set the node date to be one day after as otherwise
      -- it can never be seen by the date tracked view, which will prevbent placement
      IF p_st_date = p_end_date AND p_end_date = l_no_rec.no_end_date THEN
        l_change := TRUE;
        l_no_rec.no_end_date := p_end_date + 1;
      END IF;
      IF l_change THEN
        UPDATE NM_NODES_ALL
        SET   no_end_date   = l_no_rec.no_end_date
             ,no_start_date = l_no_rec.no_start_date
        WHERE  ROWID         = l_no_rec.no_rowid;
      END IF;
      p_node_id := l_no_rec.no_node_id;
    ELSE
      -- Not Found ....
      SELECT np_id_seq.NEXTVAL
            ,no_node_id_seq.NEXTVAL
      INTO  l_rec_no.no_np_id
           ,l_rec_no.no_node_id
      FROM  DUAL;
      l_rec_no.no_descr      := 'Created during migration';
      l_rec_no.no_node_name  := p_node_name;
      l_rec_no.no_start_date := p_st_date;
      l_rec_no.no_end_date   := p_end_date;
      l_rec_no.no_node_type  := g_node_type;
      INSERT INTO NM_POINTS (np_id, np_descr)
      VALUES (l_rec_no.no_np_id,l_rec_no.no_descr);
      Nm3ins.ins_no_all(l_rec_no);
      p_node_id := l_rec_no.no_node_id;
    END IF;
--       append_log_content(pi_text => 'Done check node dates');

  END check_node_dates;
  PROCEDURE tidy_data IS
  BEGIN
    append_log_content(pi_text => 'Tidying Existing Data');
  --  EXECUTE IMMEDIATE 'ALTER TRIGGER A_DEL_NM_ELEMENTS DISABLE';
  --  EXECUTE IMMEDIATE 'ALTER TRIGGER B_DEL_NM_ELEMENTS DISABLE';
	--DELETE FROM NM_NODE_USAGES_ALL;
   -- DELETE FROM NM_ELEMENTS_ALL
   -- WHERE ne_type = 'S';
   -- EXECUTE IMMEDIATE 'ALTER TRIGGER B_DEL_NM_ELEMENTS ENABLE';
   -- EXECUTE IMMEDIATE 'ALTER TRIGGER A_DEL_NM_ELEMENTS ENABLE';
    append_log_content(pi_text => 'Done');
  END tidy_data;

  function v2_v4_node(p_v2_node nm_nodes_all.no_node_name%type)
  return nm_nodes_all.no_node_id%type is
  l_v4_node nm_nodes_all.no_node_id%type;
  begin

--       append_log_content(pi_text => p_v2_node);

    select no_node_id
    into l_v4_node
    from nm_nodes_all
    where no_node_name=Nm3net.make_node_name(g_node_type, p_v2_node)
    and no_node_type=g_node_type;
    return l_v4_node;
  end v2_v4_node;
--

BEGIN
--
  g_proc_name := 'migrate_network';
  append_proc_start_to_log;
--
  tidy_data;
  OPEN datums_to_migrate;
  FETCH datums_to_migrate INTO g_total_todo;
  CLOSE datums_to_migrate;
  append_log_content(pi_text => 'Re-building all sequences');
  -- Fix bug in 3110 where the ESU_ID_SEQ was associated with ne_unique
--  DELETE FROM HIG_SEQUENCE_ASSOCIATIONS
--  WHERE hsa_column_name   = 'NE_UNIQUE'
--  AND   hsa_sequence_name = 'ESU_ID_SEQ';
--  Nm3ddl.rebuild_all_sequences;
  append_log_content(pi_text => 'Done');
--
  EXECUTE IMMEDIATE('ALTER TRIGGER NM_NODES_ALL_DT_TRG DISABLE');
  start_longop(p_what => 'Section Migration');
  BEGIN
--    EXECUTE IMMEDIATE('ALTER TRIGGER NM_ELEMENTS_ALL_AU_CHECK DISABLE');
     append_log_content(pi_text => 'NM_ELEMENTS_ALL');
     FOR cs_rec IN cs_datums
      LOOP
--             append_log_content(pi_text => 'start loop');

        Nm3user.set_effective_date(cs_rec.rse_start_date);
        l_rec_ne.ne_id                  := get_new_ne_id(p_rse_he_id => cs_rec.rse_he_id); --cs_rec.rse_he_id;
        l_rec_ne.ne_unique              := cs_rec.rse_unique;
        l_rec_ne.ne_type                := cs_rec.rse_type;
        l_rec_ne.ne_nt_type             := cs_rec.rse_sys_flag;
        l_rec_ne.ne_descr               := NVL(cs_rec.rse_descr,cs_rec.rse_unique);
        l_rec_ne.ne_length              := cs_rec.rse_length;
        l_rec_ne.ne_admin_unit          := nm3get.get_nau(pi_nau_unit_code => get_new_nau(cs_rec.rse_admin_unit),pi_nau_admin_type => g_admin_type).nau_admin_unit;
        l_rec_ne.ne_start_date          := TRUNC(cs_rec.rse_start_date);
        l_rec_ne.ne_end_date            := TRUNC(cs_rec.rse_end_date);
        l_rec_ne.ne_gty_group_type      := NULL;
--
        l_rec_ne.ne_owner               := cs_rec.rse_agency;
        IF NOT welsh THEN
          l_rec_ne.ne_sub_type            := SUBSTR(cs_rec.rse_linkcode,1,1);
          l_rec_ne.ne_name_1              := SUBSTR(cs_rec.rse_linkcode,2);
        ELSE
          l_rec_ne.ne_name_1              := cs_rec.rse_linkcode;
        END IF;
        l_rec_ne.ne_number              := cs_rec.rse_sect_no;
        l_rec_ne.ne_sub_class           := cs_rec.rse_scl_sect_class;
        l_rec_ne.ne_name_2              := cs_rec.rse_agency||cs_rec.rse_linkcode;
        l_rec_ne.ne_prefix              := cs_rec.rse_sys_flag;
--
        l_rec_ne.ne_group               := NULL;
--       append_log_content(pi_text => 'v2_v4');

        l_rec_ne.ne_no_start            :=v2_v4_node(cs_rec.rse_pus_node_id_st);
        l_rec_ne.ne_no_end              :=v2_v4_node(cs_rec.rse_pus_node_id_end);
--      append_log_content(pi_text => 'chec node dates');

        check_node_dates (Nm3net.make_node_name(g_node_type,cs_rec.rse_pus_node_id_st) ,l_rec_ne.ne_start_date,l_rec_ne.ne_end_date,l_rec_ne.ne_no_start);
        check_node_dates (Nm3net.make_node_name(g_node_type,cs_rec.rse_pus_node_id_end),l_rec_ne.ne_start_date,l_rec_ne.ne_end_date,l_rec_ne.ne_no_end);

--       append_log_content(pi_text => 'Done check node dates');


        l_rec_ne.ne_nsg_ref             := NULL;
        l_rec_ne.ne_version_no          := NULL;
--       append_log_content(pi_text => 'insert');

        BEGIN
           IF g_debug THEN
              Nm3debug.debug_ne(l_rec_ne);
           END IF;
           Nm3net.ins_ne (l_rec_ne);
        EXCEPTION
           WHEN OTHERS THEN
             append_log_content('Unique '||cs_rec.rse_unique);
             append_log_content('Start node '||cs_rec.rse_pus_node_id_st||' '||l_rec_ne.ne_no_start);
             append_log_content('End node '||cs_rec.rse_pus_node_id_end||' '||l_rec_ne.ne_no_end);
             append_log_content(SQLERRM);
             append_log_content('Was raised during processing of road '||l_rec_ne.ne_unique);
             RAISE;
        END;
        g_so_far := g_so_far + 1;
        set_longop_progress(p_what => 'Section Migration');
  --     append_log_content(pi_text => 'insert done');

     END LOOP;
   Nm3user.set_effective_date(c_eff_date);
   EXECUTE IMMEDIATE('ALTER TRIGGER NM_NODES_ALL_DT_TRG ENABLE');
   append_log_content(pi_text => 'Done');
   do_optional_commit;
   EXECUTE IMMEDIATE('ALTER TRIGGER NM_ELEMENTS_ALL_AU_CHECK ENABLE');
--
   append_proc_end_to_log;
--
  EXCEPTION
    WHEN OTHERS THEN
      append_log_content(SQLERRM);
      Nm3user.set_effective_date(c_eff_date);
      stop_migration('Section migration aborted');
      EXECUTE IMMEDIATE('ALTER TRIGGER NM_NODES_ALL_DT_TRG ENABLE');
  END;
END migrate_network;
--
-----------------------------------------------------------------------------
--
PROCEDURE migrate_links IS
   l_po NM_POINTS%ROWTYPE;
   l_no NM_NODES_ALL%ROWTYPE;

   CURSOR get_number_of_points IS
   SELECT COUNT(*)
   FROM v2_points;

   CURSOR cs_points IS
   SELECT poi_point_id
         ,poi_grid_east
         ,poi_grid_north
         ,NVL(poi_description,'E-"'||poi_grid_east||'":N-"'||poi_grid_north||'"') poi_description
    FROM  v2_points;

   CURSOR get_number_nodes IS
   SELECT COUNT(DISTINCT pus_node_id)
   FROM v2_point_usages;

   CURSOR get_all_point_usages IS
   SELECT pus_poi_point_id
   FROM   v2_point_usages
   GROUP BY pus_poi_point_id;

   CURSOR get_nodes IS
 --see comments in body of NODES code below
   SELECT PUS_NODE_ID, PUS_POI_POINT_ID, PUS_START_DATE, PUS_DESCRIPTION, PUS_END_DATE
   FROM v2_point_usages
   WHERE (pus_node_id,pus_poi_point_id) IN
     (SELECT pus_node_id,MIN(pus_poi_point_id)
      FROM
       (SELECT pus_node_id, pus_poi_point_id
        FROM v2_point_usages
        WHERE (pus_node_id, pus_start_Date) IN
         (SELECT pus_node_id, MAX(pus_start_Date)
          FROM v2_point_usages
          GROUP BY pus_node_id
         )
       )
       GROUP BY pus_node_id
     );


/*   CURSOR get_nodes_for_a_point (p_point v2_point_usages.pus_poi_point_id%TYPE) IS
   SELECT MAX(pus_node_id) pus_node_id
         ,MIN(pus_start_date) pus_start_date
         ,MAX(pus_end_date) pus_end_date
         ,MAX(pus_description) pus_description
   FROM   v2_point_usages
   WHERE  pus_poi_point_id = p_point;
/*   CURSOR cs_nodes IS
   SELECT DISTINCT pus_node_id
         ,MIN(pus_start_date) OVER (PARTITION BY pus_poi_point_id) pus_start_date
         ,FIRST_VALUE(pus_end_date) OVER (PARTITION BY pus_poi_point_id ORDER BY pus_end_date NULLS FIRST) pus_end_date
         ,FIRST_VALUE(pus_poi_point_id) OVER (PARTITION BY pus_poi_point_id ORDER BY pus_end_date NULLS FIRST) pus_poi_point_id
         ,NVL(FIRST_VALUE(pus_description) OVER (PARTITION BY pus_poi_point_id ORDER BY pus_end_date NULLS FIRST),pus_node_id) pus_description
   FROM   v2_point_usages;
*/
   CURSOR number_of_links IS
   SELECT COUNT(*)
    FROM  v2_road_segs
   WHERE  rse_gty_group_type = 'LINK';

   CURSOR cs_links IS
   SELECT *
    FROM  v2_road_segs
   WHERE  rse_gty_group_type = 'LINK'
 --  and 1=2
   ;
   l_rec_ne nm_elements%ROWTYPE;
   l_context_date_on_entry DATE := Nm3user.get_effective_date;
  PROCEDURE tidy_data IS
  BEGIN
    append_log_content(pi_text => 'Tidying Existing Data');
    --EXECUTE IMMEDIATE ('TRUNCATE TABLE nm_members_all');
    --EXECUTE IMMEDIATE ('TRUNCATE TABLE nm_node_usages_all');
    --EXECUTE IMMEDIATE 'ALTER TRIGGER A_DEL_NM_ELEMENTS DISABLE';
    --DELETE NM_ELEMENTS_ALL;
    --DELETE NM_NODES_ALL;
    --DELETE NM_POINTS;
    --EXECUTE IMMEDIATE 'ALTER TRIGGER A_DEL_NM_ELEMENTS ENABLE';
    append_log_content(pi_text => 'Done');
  END tidy_data;
BEGIN
--
 g_proc_name := 'migrate_links';
 append_proc_start_to_log;
--
  tidy_data;

 append_log_content(pi_text => 'NM_POINTS AND NODES');

  FOR l_rec IN
    (SELECT np_id_seq.nextval new_point_id, no_node_id_seq.nextval new_node_id, PUS_NODE_ID, PUS_POI_POINT_ID, PUS_START_DATE, PUS_DESCRIPTION, PUS_END_DATE,POI_GRID_EAST, POI_GRID_NORTH,poi_description
     FROM v2_point_usages
     ,v2_points
     WHERE
     pus_poi_point_id=poi_point_id
--and pus_node_id='000112'
     and (pus_node_id,pus_poi_point_id) IN
       (SELECT pus_node_id,MIN(pus_poi_point_id)
        FROM
         (SELECT pus_node_id, pus_poi_point_id
          FROM v2_point_usages
          WHERE (pus_node_id, pus_start_Date) IN
           (SELECT pus_node_id, MAX(pus_start_Date)
            FROM v2_point_usages
            GROUP BY pus_node_id
           )
         )
         GROUP BY pus_node_id
       ))
   LOOP


    l_po.np_id         := l_rec.new_point_id;
    l_po.np_grid_east  := l_rec.poi_grid_east;
    l_po.np_grid_north := l_rec.poi_grid_north;
    l_po.np_descr      := nvl(l_rec.poi_description,l_po.np_id);
    IF g_debug THEN
      Nm3debug.debug_np(l_po);
    END IF;
    Nm3ins.ins_np(l_po);

    l_no.no_node_id    := l_rec.new_node_id;
--    l_no.no_node_name  := Nm3net.make_node_name('ROAD', l_rec.pus_node_id);
    l_no.no_node_name  := Nm3net.make_node_name(g_node_type, l_rec.pus_node_id);
    l_no.no_start_date := TRUNC(LEAST(nvl(l_rec.pus_end_date,l_rec.pus_start_date), l_rec.pus_start_date));
    l_no.no_end_date   := TRUNC(l_rec.pus_end_date);
    l_no.no_np_id      := l_po.np_id;
    l_no.no_descr      := NVL(l_rec.pus_description,l_no.no_node_name);
    l_no.no_node_type  := g_node_type;
    IF g_debug THEN
      Nm3debug.debug_no_all(l_no);
    END IF;

    Nm3ins.ins_no_all(l_no);
/*    nm3net.create_or_reuse_point_and_node(
                                         pi_np_grid_east     =>l_rec.POI_GRID_EAST
                                        ,pi_np_grid_north    =>l_rec.POI_GRID_north
										,pi_no_start_date    =>l_no.no_start_Date
										,pi_no_node_type     =>g_node_type
										,pi_node_descr       =>l_no.no_descr
										,po_no_node_id       =>l_no.no_node_id
										,po_np_id            =>l_no.no_np_id
										);

-- append_log_content(pi_text => l_no.no_node_name||' '||l_no.no_node_id);

   update nm_nodes_all
   set no_node_name=l_no.no_node_name
   where no_node_id=l_no.no_node_id
   and no_node_type=g_node_type;
*/

    g_so_far := g_so_far + 1;
    set_longop_progress('Nodes');
  END LOOP;

/*  append_log_content(pi_text => 'NM_POINTS');
  OPEN get_number_of_points;
  FETCH get_number_of_points INTO g_total_todo;
  CLOSE get_number_of_points;
  start_longop('Points');
  FOR cs_rec IN cs_points LOOP
    l_po.np_id         := cs_rec.poi_point_id;
    l_po.np_grid_east  := cs_rec.poi_grid_east;
    l_po.np_grid_north := cs_rec.poi_grid_north;
    l_po.np_descr      := cs_rec.poi_description;
    IF g_debug THEN
      Nm3debug.debug_np(l_po);
    END IF;
    Nm3ins.ins_np(l_po);
    g_so_far := g_so_far + 1;
    set_longop_progress('Points');
  END LOOP;
--
  append_log_content(pi_text => 'NM_NODES_ALL');
  OPEN get_number_nodes;
  FETCH get_number_nodes INTO g_total_todo;
  CLOSE get_number_nodes;
  start_longop('Nodes');

--nodes can have more than 1 record in v2_point_usages, but cant do this in nm3.
--so we need to some jiggery pokery to get the 'best' record.  For those records with only 1 point
--its easy - however those with more than 1 point, we need to take the latest point assocaited with
--that node as it is more likely to be correct.
--Hence in the next cursor there is a far amount of grouping to get this data.



  FOR l_rec IN get_nodes LOOP
    l_no.no_node_id    := Nm3seq.next_no_node_id_seq;
--    l_no.no_node_name  := Nm3net.make_node_name('ROAD', l_rec.pus_node_id);
    l_no.no_node_name  := Nm3net.make_node_name(g_node_type, l_rec.pus_node_id);
    l_no.no_start_date := TRUNC(LEAST(nvl(l_rec.pus_end_date,l_rec.pus_start_date), l_rec.pus_start_date));
    l_no.no_end_date   := TRUNC(l_rec.pus_end_date);
    l_no.no_np_id      := l_rec.pus_poi_point_id;
    l_no.no_descr      := NVL(l_rec.pus_description,l_no.no_node_name);
    l_no.no_node_type  := g_node_type;
    IF g_debug THEN
      Nm3debug.debug_no_all(l_no);
    END IF;
    Nm3ins.ins_no_all(l_no);
    g_so_far := g_so_far + 1;
    set_longop_progress('Nodes');
  END LOOP;
*/


/*  FOR irec IN get_all_point_usages LOOP
    FOR l_rec IN get_nodes_for_a_point(irec.pus_poi_point_id) LOOP
       l_no.no_node_id    := Nm3seq.next_no_node_id_seq;
       l_no.no_node_name  := Nm3net.make_node_name('ROAD', l_rec.pus_node_id);
       l_no.no_start_date := TRUNC(LEAST(l_rec.pus_end_date, l_rec.pus_start_date));
       l_no.no_end_date   := TRUNC(l_rec.pus_end_date);
       l_no.no_np_id      := irec.pus_poi_point_id;
       l_no.no_descr      := NVL(l_rec.pus_description,l_no.no_node_name);
       l_no.no_node_type  := g_node_type;
       IF g_debug THEN
         Nm3debug.debug_no_all(l_no);
       END IF;
       Nm3ins.ins_no_all(l_no);
    END LOOP;
    g_so_far := g_so_far + 1;
    set_longop_progress('Nodes');
  END LOOP;
*/
--
EXECUTE IMMEDIATE('ALTER TRIGGER NM_ELEMENTS_ALL_AU_CHECK DISABLE');
 append_log_content(pi_text => 'NM_ELEMENTS_ALL');
  OPEN number_of_links;
  FETCH number_of_links INTO g_total_todo;
  CLOSE number_of_links;
  start_longop('Links');
  FOR cs_rec IN cs_links LOOP
    l_rec_ne.ne_id                  := get_new_ne_id(p_rse_he_id => cs_rec.rse_he_id); --cs_rec.rse_he_id;
    l_rec_ne.ne_unique              := UPPER(cs_rec.rse_unique);
    l_rec_ne.ne_type                := 'G';
    l_rec_ne.ne_descr               := NVL(cs_rec.rse_descr,cs_rec.rse_unique);
    l_rec_ne.ne_length              := NULL;--cs_rec.rse_length;
    l_rec_ne.ne_admin_unit          := nm3get.get_nau(pi_nau_unit_code => get_new_nau(cs_rec.rse_admin_unit),pi_nau_admin_type => g_admin_type).nau_admin_unit;
    l_rec_ne.ne_start_date          := TRUNC(cs_rec.rse_start_date);
    IF cs_rec.rse_end_date IS NOT NULL
     AND cs_rec.rse_end_date < cs_rec.rse_start_date
     THEN
       l_rec_ne.ne_end_date         := TRUNC(cs_rec.rse_start_date);
    ELSE
       l_rec_ne.ne_end_date         := TRUNC(cs_rec.rse_end_date);
    END IF;
    IF cs_rec.rse_sys_flag = 'D' THEN
      l_rec_ne.ne_nt_type             := 'DLNK';
      l_rec_ne.ne_gty_group_type      := 'DLNK';
    ELSE
      l_rec_ne.ne_nt_type             := 'LLNK';
      l_rec_ne.ne_gty_group_type      := 'LLNK';
    END IF;
--    l_rec_ne.ne_owner               := cs_rec.rse_agency;
--    IF NOT welsh THEN
--      l_rec_ne.ne_sub_type            := SUBSTR(cs_rec.rse_linkcode,1,1);
--    END IF;
--    l_rec_ne.ne_name_1              := SUBSTR(cs_rec.rse_linkcode, 2);
--    l_rec_ne.ne_group               := cs_rec.rse_road_number;
    l_rec_ne.ne_sub_class           := cs_rec.rse_scl_sect_class;
    l_rec_ne.ne_name_2              := cs_Rec.rse_bh_hier_code;
    l_rec_ne.ne_prefix              := cs_rec.rse_sys_flag;
--
    l_rec_ne.ne_owner              := NULL;
    l_rec_ne.ne_sub_type              := NULL;
    l_rec_ne.ne_name_1              := NULL;
    l_rec_ne.ne_group              := NULL;

    l_rec_ne.ne_number              := NULL;
    l_rec_ne.ne_no_start            := NULL;
    l_rec_ne.ne_no_end              := NULL;
    l_rec_ne.ne_nsg_ref             := NULL;
    l_rec_ne.ne_version_no          := NULL;
    Nm3user.set_effective_date(l_rec_ne.ne_start_date);
    BEGIN
      IF g_debug THEN
        Nm3debug.debug_ne(l_rec_ne);
      END IF;
      Nm3net.ins_ne (l_rec_ne);
    EXCEPTION
      WHEN OTHERS THEN
        append_log_content(cs_Rec.rse_unique);
        append_log_content(SQLERRM);
        append_log_content('Was raised during processing of road '||l_rec_ne.ne_unique);
        RAISE;
    END;
    g_so_far := g_so_far + 1;
    set_longop_progress('Links');
 END LOOP;
 do_optional_commit;
 EXECUTE IMMEDIATE('ALTER TRIGGER NM_ELEMENTS_ALL_AU_CHECK ENABLE');
 Nm3user.set_effective_date(l_context_date_on_entry);
--
 append_proc_end_to_log;
--
EXCEPTION
  WHEN OTHERS THEN
    append_log_content(SQLERRM);
    Nm3user.set_effective_date(l_context_date_on_entry);
    stop_migration('Link Migration aborted');
END migrate_links;
--
-----------------------------------------------------------------------------
--
PROCEDURE migrate_link_membs IS
   CURSOR cs_rsm IS
   SELECT rsm_rse_he_id_in
         ,rsm_rse_he_id_of
         ,rsm_begin_mp
         ,TRUNC(rsm_start_date) rsm_start_date
         ,TRUNC(rsm_end_date) rsm_end_date
         ,NVL(rsm_end_mp,rse_length) rsm_end_mp
         ,NVL(rsm_route_begin_mp,0) rsm_route_begin_mp
         ,rsm_seq_no
         ,NVL(rsm_route_begin_mp,0) rsm_true
    FROM  v2_road_seg_membs_all rsm
         ,v2_road_segs
    WHERE rsm_rse_he_id_of=rse_he_id;
--
   l_orig_st_date               DATE;
   l_orig_end_date              DATE;
   l_context_date_on_entry      DATE := Nm3user.get_effective_date;
--
   l_tab_nm_ne_id_in            Nm3type.tab_number;
   l_tab_nm_ne_id_of            Nm3type.tab_number;
   l_tab_nm_obj_type            Nm3type.tab_varchar4;
   l_tab_nm_begin_mp            Nm3type.tab_number;
   l_tab_nm_start_date          Nm3type.tab_date;
   l_tab_nm_end_date            Nm3type.tab_date;
   l_tab_nm_end_mp              Nm3type.tab_number;
   l_tab_nm_slk                 Nm3type.tab_number;
   l_tab_nm_admin_unit          Nm3type.tab_number;
   l_tab_nm_seq_no              Nm3type.tab_number;
   l_tab_nm_true                Nm3type.tab_number;
--
   l_rec_ne_of                  nm_elements%ROWTYPE;
   l_rec_ne_in                  nm_elements%ROWTYPE;
   l_nm                         NM_MEMBERS_ALL%ROWTYPE;
--
   PROCEDURE tidy_data IS
   BEGIN
        append_log_content(pi_text => 'Tidying Existing Data');
       -- DELETE FROM NM_MEMBERS_ALL
       -- WHERE nm_obj_type IN('LLNK','DLNK');
        append_log_content(pi_text => 'Done');
   END tidy_data;
BEGIN
--
 g_proc_name := 'migrate_link_membs';
 append_proc_start_to_log;
 g_debug:=TRUE;
--
-- Nm3ausec.set_status (Nm3type.c_off);
 tidy_data;
   OPEN  cs_rsm;
   FETCH cs_rsm
    BULK COLLECT
    INTO l_tab_nm_ne_id_in
        ,l_tab_nm_ne_id_of
        ,l_tab_nm_begin_mp
        ,l_tab_nm_start_date
        ,l_tab_nm_end_date
        ,l_tab_nm_end_mp
        ,l_tab_nm_slk
        ,l_tab_nm_seq_no
        ,l_tab_nm_true;
   CLOSE cs_rsm;
   append_log_content(pi_text => 'NM_MEMBERS_ALL');
   g_total_todo := l_tab_nm_ne_id_in.COUNT;
   start_longop('Members');
   FOR i IN 1..l_tab_nm_ne_id_in.COUNT
    LOOP
      DECLARE
        no_matching_element EXCEPTION;
      BEGIN
         l_orig_st_date         := l_tab_nm_start_date(i);
         l_orig_end_date        := l_tab_nm_end_date(i);
         --
         l_rec_ne_of            := Nm3get.get_ne_all(pi_ne_id           => get_new_ne_id(p_rse_he_id => l_tab_nm_ne_id_of(i))
                                                    ,pi_raise_not_found => FALSE);
         l_rec_ne_in            := Nm3get.get_ne_all(pi_ne_id           => get_new_ne_id(p_rse_he_id => l_tab_nm_ne_id_in(i))
                                                    ,pi_raise_not_found => FALSE);
         -- if either of the of or in ne id's cannot
         -- be found then do not process
         IF   l_rec_ne_in.ne_id IS NULL
           OR l_rec_ne_of.ne_id IS NULL THEN
            RAISE no_matching_element;
         END IF;
         l_tab_nm_obj_type(i)   := l_rec_ne_in.ne_gty_group_type;
         l_tab_nm_admin_unit(i) := l_rec_ne_in.ne_admin_unit;
         --
         IF  l_tab_nm_start_date(i) < l_rec_ne_in.ne_start_date
          THEN
            l_tab_nm_start_date(i) := l_rec_ne_in.ne_start_date;
         END IF;
         IF  l_tab_nm_start_date(i) < l_rec_ne_of.ne_start_date
          THEN
            l_tab_nm_start_date(i) := l_rec_ne_of.ne_start_date;
         END IF;
         IF  NVL(l_tab_nm_end_date(i),Nm3type.c_big_date) > NVL(l_rec_ne_in.ne_end_date,Nm3type.c_big_date)
          THEN
            l_tab_nm_end_date(i)   := l_rec_ne_in.ne_end_date;
         END IF;
         IF  NVL(l_tab_nm_end_date(i),Nm3type.c_big_date) > NVL(l_rec_ne_of.ne_end_date,Nm3type.c_big_date)
          THEN
            l_tab_nm_end_date(i)   := l_rec_ne_of.ne_end_date;
         END IF;
         l_nm.nm_ne_id_in    := get_new_ne_id(p_rse_he_id => l_tab_nm_ne_id_in(i));
         l_nm.nm_ne_id_of    := get_new_ne_id(p_rse_he_id => l_tab_nm_ne_id_of(i));
         l_nm.nm_type        := 'G';
         l_nm.nm_obj_type    := l_tab_nm_obj_type(i);
         l_nm.nm_begin_mp    := l_tab_nm_begin_mp(i);
         l_nm.nm_start_date  := l_tab_nm_start_date(i);
         l_nm.nm_end_date    := l_tab_nm_end_date(i);
         l_nm.nm_end_mp      := l_tab_nm_end_mp(i);
         l_nm.nm_slk         := NULL;--l_tab_nm_slk(i);
         l_nm.nm_cardinality := 1;
         l_nm.nm_admin_unit  := l_tab_nm_admin_unit(i);
         l_nm.nm_seq_no      := l_tab_nm_seq_no(i);
         l_nm.nm_seg_no      := 1;
         l_nm.nm_true        := NULL;--l_tab_nm_true(i);
         Nm3user.set_effective_date(l_nm.nm_start_date);
         IF g_debug THEN
            Nm3debug.debug_nm_all(l_nm);
         END IF;
         Nm3ins.ins_nm_all(l_nm);
      EXCEPTION
         WHEN no_matching_element THEN
           NULL; -- ignore just do not process the loop
         WHEN OTHERS
          THEN
            append_log_content(SQLERRM);
            append_log_content('Was raised during processing of road member '||l_tab_nm_ne_id_of(i));
            RAISE;
      END;
      g_so_far := g_so_far + 1;
      set_longop_progress('Members');
   END LOOP;
   do_optional_commit;
   Nm3user.set_effective_date(l_context_date_on_entry);
   Nm3ausec.set_status (Nm3type.c_on);
--
 append_proc_end_to_log;
--
EXCEPTION
  WHEN OTHERS THEN
    append_log_content(SQLERRM);
    Nm3user.set_effective_date(l_context_date_on_entry);
    Nm3ausec.set_status (Nm3type.c_on);
    stop_migration('Road link member migration aborted');
END migrate_link_membs;
--
-----------------------------------------------------------------------------
--
PROCEDURE migrate_other_groups IS
  c_linear_group CONSTANT NM_TYPES.NT_TYPE%TYPE := 'LGT';
  c_non_linear_group  CONSTANT NM_TYPES.NT_TYPE%TYPE := 'NLGT';
  CURSOR cs_group_types IS
  SELECT rse_gty_group_type
        ,DECODE(gty_linear_flag,'Y',c_linear_group,c_non_linear_group) nt_type
   FROM  v2_road_segs
        ,v2_group_types
  WHERE  rse_type != 'S'
   AND   rse_gty_group_type != 'LINK'
   AND   rse_gty_group_type IS NOT NULL
   AND   gty_group_type=rse_gty_group_type
  GROUP BY rse_gty_group_type, DECODE(gty_linear_flag,'Y',c_linear_group,c_non_linear_group);
--
  l_tab_gty_group_type Nm3type.tab_varchar4;
  l_tab_nt_type        Nm3type.tab_varchar4;
--
  TYPE tab_rec_nm  IS TABLE OF NM_MEMBERS_ALL%ROWTYPE     INDEX BY BINARY_INTEGER;
--
  l_tab_rec_nm  tab_rec_nm;
  l_rec_ne      nm_elements%ROWTYPE;
--
  l_context_date_on_entry      DATE := Nm3user.get_effective_date;
--
  e_element_exception EXCEPTION;
  e_member_exception  EXCEPTION;
--
  CURSOR get_groups IS
  SELECT gty_group_type
        ,gty_descr
        ,gty_exclusive_flag
        ,gty_search_group_no
        ,NVL(gty_linear_flag,'N') gty_linear_flag
        ,DECODE(gty_linear_flag,'Y',c_linear_group,c_non_linear_group) gty_nt_type
        ,gty_mandatory_flag
  FROM  v2_group_types
  WHERE gty_group_type!='LINK'
--and only migrate group types that have data in
  AND EXISTS
  (SELECT 'x' FROM v2_Road_segs
  WHERE rse_gty_group_type=gty_group_type);
  CURSOR get_count_for_group (p_group IN v2_road_segs.rse_gty_group_type%TYPE) IS
  SELECT COUNT(*)
  FROM   v2_road_segs
  WHERE  rse_gty_group_type = p_group
  AND    rse_type          != 'S';
--
   l_tab_child_groups Nm3type.tab_varchar4;
   l_top_group        NM_GROUP_TYPES_ALL.ngt_group_type%TYPE;
   l_rec_nm           NM_MEMBERS_ALL%ROWTYPE;
   l_nt               NM_TYPES%ROWTYPE;
   l_ngt              NM_GROUP_TYPES_ALL%ROWTYPE;
   l_ngr              NM_GROUP_RELATIONS_ALL%ROWTYPE;
   l_nng              NM_NT_GROUPINGS_ALL%ROWTYPE;
   l_ntc              NM_TYPE_COLUMNS%ROWTYPE;
   l_gog              NM_GROUP_TYPES_ALL.ngt_sub_group_allowed%TYPE;
--
  PROCEDURE tidy_data IS
  BEGIN
    append_log_content(pi_text => 'Tidying existing data');
   -- EXECUTE IMMEDIATE 'ALTER TRIGGER A_DEL_NM_ELEMENTS DISABLE';
   -- DELETE NM_MEMBERS_ALL WHERE nm_obj_type NOT IN ('LLNK','DLNK') AND nm_type='G';
   -- DELETE NM_ELEMENTS_ALL WHERE ne_nt_type IN ( c_linear_group,c_non_linear_group);
   -- DELETE NM_GROUP_RELATIONS_ALL;
   -- DELETE NM_NT_GROUPINGS_ALL WHERE nng_group_type NOT IN ('LLNK','DLNK');
   -- DELETE NM_GROUP_TYPES_ALL WHERE ngt_group_type NOT IN ('LLNK','DLNK');
   -- DELETE NM_TYPE_COLUMNS WHERE ntc_nt_type IN ( c_linear_group,c_non_linear_group);
   -- DELETE NM_TYPES WHERE nt_type IN ( c_linear_group,c_non_linear_group);
   -- EXECUTE IMMEDIATE 'ALTER TRIGGER A_DEL_NM_ELEMENTS ENABLE';
    do_optional_commit;
    append_log_content(pi_text => 'Done');
  END tidy_data;
--
  FUNCTION sub_group_allowed (p_group IN NM_GROUP_TYPES_ALL.ngt_group_type%TYPE) RETURN VARCHAR2 IS
  CURSOR get_group_type (p_group IN NM_GROUP_TYPES_ALL.ngt_group_type%TYPE) IS
/*
  SELECT DISTINCT DECODE(rse_type, 'P', 'G', rse_type)
  FROM   v2_road_segs
        ,v2_road_seg_membs_all
  WHERE  rse_he_id = rsm_rse_he_id_in
  AND    rse_gty_group_type = p_group;
*/
  SELECT DISTINCT gty_memb.rse_type
  FROM   v2_road_segs Gty
        ,v2_road_seg_membs_all
		,v2_road_segs gty_memb
  WHERE  gty.rse_he_id = rsm_rse_he_id_in
  AND    gty.rse_gty_group_type = p_group
  AND    rsm_rse_he_id_of=gty_memb.rse_he_id;
  l_type v2_road_seg_membs_all.rsm_type%TYPE;
  l_found BOOLEAN;
  more_than_one_group EXCEPTION;
  BEGIN
    OPEN  get_group_type(p_group);
    FETCH get_group_type INTO l_type;
    -- fetch again - if there is more than one type then error
    FETCH get_group_type INTO l_type;
    l_found := get_group_type%FOUND;
    CLOSE get_group_type;
    -- if we have found a second then error
    IF l_found THEN
      RAISE more_than_one_group;
    END IF;
    IF l_type = 'G' THEN
      RETURN 'Y';
    ELSE
      RETURN 'N';
    END IF;
  EXCEPTION
    WHEN more_than_one_group THEN
       append_log_content(pi_text => 'Error');
       append_log_content(pi_text => 'Group type '||p_group||' contains group and sections');
       RAISE_APPLICATION_ERROR(-20000, 'Group type '||p_group||' contains group and sections');
  END sub_group_allowed;
--
  FUNCTION get_child_groups (p_group IN NM_GROUP_TYPES_ALL.ngt_group_type%TYPE)
  RETURN Nm3type.tab_varchar4 IS
  CURSOR get_child_groups (p_group IN NM_GROUP_TYPES_ALL.ngt_group_type%TYPE) IS
  SELECT  rs2.rse_gty_group_type
  FROM    v2_road_segs      rs2
         ,v2_road_segs      rs1
         ,v2_road_seg_membs_All rsm
  WHERE   rs1.rse_gty_group_type = p_group
  AND     rsm.rsm_rse_he_id_in   = rs1.rse_he_id
  AND     rsm.rsm_rse_he_id_of   = rs2.rse_he_id
  AND     rs2.rse_gty_group_type NOT IN ( 'LINK',rs1.rse_gty_group_type )
  GROUP BY rs2.rse_gty_group_type;
  l_groups Nm3type.tab_varchar4;
  BEGIN
    OPEN get_child_groups(p_group);
    FETCH get_child_groups BULK COLLECT INTO l_groups;
    CLOSE get_child_groups;
    RETURN l_groups;
  END get_child_groups;
--
  PROCEDURE insert_child_groups (p_parent NM_GROUP_TYPES_ALL.ngt_group_type%TYPE
                                ,p_child  NM_GROUP_TYPES_ALL.ngt_group_type%TYPE) IS
  l_kids Nm3type.tab_varchar4;
  BEGIN
    append_log_content(pi_text => 'Creating '||p_parent||' child group of '|| p_child);
    l_ngr.ngr_parent_group_type := p_parent;
    l_ngr.ngr_child_group_type  := p_child;
    l_ngr.ngr_start_date        := g_mig_earliest_date;
    IF Nm3get.get_ngr_all(pi_ngr_parent_group_type =>  l_ngr.ngr_parent_group_type
                         ,pi_ngr_child_group_type      =>  l_ngr.ngr_child_group_type
                         ,pi_ngr_start_date            =>  l_ngr.ngr_start_date
                         ,pi_raise_not_found           =>  FALSE).ngr_parent_group_type IS NULL THEN
      -- if not found insert it
      IF g_debug THEN
        Nm3debug.debug_ngr(l_ngr);
      END IF;
      Nm3ins.ins_ngr(p_rec_ngr => l_ngr);
    END IF;
    -- now get any kids of this child
    l_kids := get_child_groups(p_child);
    FOR i IN 1..l_kids.COUNT LOOP
      -- recursively insert child relations
      insert_child_groups(p_parent => p_child
                         ,p_child  => l_kids(i));
    END LOOP;
  END insert_child_groups;
--
--
BEGIN
--
 g_proc_name := 'migrate_other_groups';
 append_proc_start_to_log;
 tidy_data;
--
  ---------------------------------------
  -- create network type for NM2 groupings
  ---------------------------------------
  append_log_content(pi_text => 'NM_TYPES');
  l_nt.nt_type        := c_non_linear_group;
  l_nt.nt_unique      := c_non_linear_group;
  l_nt.nt_linear      := 'N';
  l_nt.nt_node_type   := NULL;
  l_nt.nt_descr       := 'Non Linear Group Type';
  l_nt.nt_admin_type  := g_admin_type;
  l_nt.nt_length_unit := NULL;
  l_nt.nt_datum       := 'N';
  l_nt.nt_pop_unique  := 'N';
  IF g_debug THEN
    Nm3debug.debug_nt(l_nt);
  END IF;
  Nm3ins.ins_nt(l_nt);
  l_nt.nt_type        := c_linear_group;
  l_nt.nt_unique      := c_linear_group;
  l_nt.nt_linear      := 'Y';
  l_nt.nt_node_type   := NULL;
  l_nt.nt_descr       := 'Linear Group Type';
  l_nt.nt_admin_type  := g_admin_type;
  l_nt.nt_length_unit := Hig.get_sysopt('DEFUNITID');
  l_nt.nt_datum       := 'N';
  l_nt.nt_pop_unique  := 'N';
  IF g_debug THEN
    Nm3debug.debug_nt(l_nt);
  END IF;
  Nm3ins.ins_nt(l_nt);
  l_ntc.ntc_nt_type     :=  c_non_linear_group;
  l_ntc.ntc_column_name := 'NE_PREFIX';
  l_ntc.ntc_column_type := 'VARCHAR2';
  l_ntc.ntc_seq_no      := 1;
  l_ntc.ntc_displayed   := 'N';
  l_ntc.ntc_str_length  := 1;
  l_ntc.ntc_mandatory   := 'N';
  l_ntc.ntc_domain      := NULL;
  l_ntc.ntc_inherit     := 'N';
  l_ntc.ntc_format      := NULL;
--  l_ntc.ntc_default     := 'V2_SYS_FLAG(:NE_GTY_GROUP_TYPE)';
  IF g_l_network THEN
    l_ntc.ntc_default     := '''L''';
  ELSE
    l_ntc.ntc_default     := '''D''';
  END IF;

  l_ntc.ntc_prompt      := 'Sys Flag';
  l_ntc.ntc_separator   := NULL;
  l_ntc.ntc_unique_seq  := NULL;
  l_ntc.ntc_updatable   := 'Y';
  IF g_debug THEN
    Nm3debug.debug_ntc(l_ntc);
  END IF;
  Nm3ins.ins_ntc(p_rec_ntc => l_ntc);
  l_ntc.ntc_nt_type     := c_non_linear_group;
  l_ntc.ntc_column_name := 'NE_VERSION_NO';
  l_ntc.ntc_column_type := 'VARCHAR2';
  l_ntc.ntc_seq_no      := 2;
  l_ntc.ntc_displayed   := 'N';
  l_ntc.ntc_str_length  := 1;
  l_ntc.ntc_mandatory   := 'N';
  l_ntc.ntc_domain      := NULL;
  l_ntc.ntc_inherit     := 'N';
  l_ntc.ntc_format      := NULL;
  l_ntc.ntc_default     := '''N''';
  l_ntc.ntc_prompt      := 'Net Sel Crt';
  l_ntc.ntc_separator   := NULL;
  l_ntc.ntc_unique_seq  := NULL;
  l_ntc.ntc_updatable   := 'Y';
  IF g_debug THEN
    Nm3debug.debug_ntc(l_ntc);
  END IF;
  Nm3ins.ins_ntc(p_rec_ntc => l_ntc);
 l_ntc.ntc_nt_type     :=  c_linear_group;
  l_ntc.ntc_column_name := 'NE_PREFIX';
  l_ntc.ntc_column_type := 'VARCHAR2';
  l_ntc.ntc_seq_no      := 1;
  l_ntc.ntc_displayed   := 'N';
  l_ntc.ntc_str_length  := 1;
  l_ntc.ntc_mandatory   := 'N';
  l_ntc.ntc_domain      := NULL;
  l_ntc.ntc_inherit     := 'N';
  l_ntc.ntc_format      := NULL;
--  l_ntc.ntc_default     := 'V2_SYS_FLAG(:NE_GTY_GROUP_TYPE)';
  IF g_l_network THEN
    l_ntc.ntc_default     := '''L''';
  ELSE
    l_ntc.ntc_default     := '''D''';
  END IF;
  l_ntc.ntc_prompt      := 'Sys Flag';
  l_ntc.ntc_separator   := NULL;
  l_ntc.ntc_unique_seq  := NULL;
  l_ntc.ntc_updatable   := 'Y';
  IF g_debug THEN
    Nm3debug.debug_ntc(l_ntc);
  END IF;
  Nm3ins.ins_ntc(p_rec_ntc => l_ntc);
  l_ntc.ntc_nt_type     := c_linear_group;
  l_ntc.ntc_column_name := 'NE_VERSION_NO';
  l_ntc.ntc_column_type := 'VARCHAR2';
  l_ntc.ntc_seq_no      := 2;
  l_ntc.ntc_displayed   := 'N';
  l_ntc.ntc_str_length  := 1;
  l_ntc.ntc_mandatory   := 'N';
  l_ntc.ntc_domain      := NULL;
  l_ntc.ntc_inherit     := 'N';
  l_ntc.ntc_format      := NULL;
  l_ntc.ntc_default     := '''N''';
  l_ntc.ntc_prompt      := 'Net Sel Crt';
  l_ntc.ntc_separator   := NULL;
  l_ntc.ntc_unique_seq  := NULL;
  l_ntc.ntc_updatable   := 'Y';
  IF g_debug THEN
    Nm3debug.debug_ntc(l_ntc);
  END IF;
  Nm3ins.ins_ntc(p_rec_ntc => l_ntc);
  append_log_content(pi_text => 'NM_GROUP_TYPES');
  FOR irec IN get_groups LOOP
    l_ngt.ngt_group_type        := irec.gty_group_type;
    l_ngt.ngt_descr             := irec.gty_descr;
    l_ngt.ngt_exclusive_flag    := irec.gty_exclusive_flag;
    l_ngt.ngt_search_group_no   := irec.gty_search_group_no;
    l_ngt.ngt_linear_flag       := irec.gty_linear_flag;
    l_ngt.ngt_nt_type           := irec.gty_nt_type;
    l_ngt.ngt_partial           := 'N';
    l_ngt.ngt_start_date        := g_mig_earliest_date;
    l_ngt.ngt_sub_group_allowed := sub_group_allowed(l_ngt.ngt_group_type);
    l_ngt.ngt_mandatory         := irec.gty_mandatory_flag;
    IF l_ngt.ngt_linear_flag = 'Y' THEN
      l_ngt.ngt_reverse_allowed   := 'Y';
    ELSE
      l_ngt.ngt_reverse_allowed   := 'N';
    END IF;
    IF g_debug THEN
      Nm3debug.debug_ngt(l_ngt);
    END IF;
    Nm3ins.ins_ngt(p_rec_ngt => l_ngt);
    -- if group of sections then
    IF l_ngt.ngt_sub_group_allowed = 'N' THEN
	  FOR c_sys_Flag IN
	    (SELECT DISTINCT gty_memb.rse_sys_flag
         FROM v2_road_segs Gty
             ,v2_road_seg_membs_all
		     ,v2_road_segs gty_memb
         WHERE  gty.rse_he_id = rsm_rse_he_id_in
         AND    gty.rse_gty_group_type = l_ngt.ngt_group_type
         AND    rsm_rse_he_id_of=gty_memb.rse_he_id) LOOP
         l_nng.nng_group_type := l_ngt.ngt_group_type;
         l_nng.nng_nt_type    := c_sys_flag.rse_sys_flag;
         l_nng.nng_start_date := g_mig_earliest_date;
         IF g_debug THEN
           Nm3debug.debug_nng(l_nng);
         END IF;
         Nm3ins.ins_nng(p_rec_nng => l_nng);
       END LOOP;
    END IF;
  END LOOP;
  append_log_content(pi_text => 'NM_GROUP_RELATIONS_ALL');
--CH changed the way this works - it was being clever and step down the tree
--but this will fail if there are anby that arent realted to TOP
--so now just do it once and create all the records in 1 hit
-- start at the top
-- l_top_group := 'TOP';
/*
  l_tab_child_groups := get_child_groups;--(l_top_group);
  FOR i IN 1..l_tab_child_groups.COUNT LOOP
    insert_child_groups(p_parent => l_top_group
                       ,p_child  => l_tab_child_groups(i));
  END LOOP;
*/
  OPEN  cs_group_types;
  FETCH cs_group_types BULK COLLECT
  INTO  l_tab_gty_group_type
       ,l_tab_nt_type;
  CLOSE cs_group_types;
--
  FOR i IN
    (  SELECT  rs1.rse_gty_group_type p_parent,DECODE(rs2.rse_gty_group_type,'LINK',DECODE(rs2.rse_sys_Flag,'L','LLNK','D','DLNK'),rs2.rse_gty_group_type) p_child
     FROM    v2_road_segs      rs2
            ,v2_road_segs      rs1
            ,v2_road_seg_membs_all rsm
     WHERE   rsm.rsm_rse_he_id_in   = rs1.rse_he_id
     AND     rsm.rsm_rse_he_id_of   = rs2.rse_he_id
     AND     rs2.rse_gty_group_type != rs1.rse_gty_group_type
     GROUP BY rs1.rse_gty_group_type,DECODE(rs2.rse_gty_group_type,'LINK',DECODE(rs2.rse_sys_Flag,'L','LLNK','D','DLNK'),rs2.rse_gty_group_type)) LOOP
	l_ngr.ngr_parent_group_type := i.p_parent;
    l_ngr.ngr_child_group_type  := i.p_child;
    l_ngr.ngr_start_date        := g_mig_earliest_date;
    IF Nm3get.get_ngr_all(pi_ngr_parent_group_type =>  l_ngr.ngr_parent_group_type
                       ,pi_ngr_child_group_type      =>  l_ngr.ngr_child_group_type
                       ,pi_ngr_start_date            =>  l_ngr.ngr_start_date
                       ,pi_raise_not_found           =>  FALSE).ngr_parent_group_type IS NULL THEN
      -- if not found insert it
      IF g_debug THEN
        Nm3debug.debug_ngr(l_ngr);
      END IF;
      Nm3ins.ins_ngr(p_rec_ngr => l_ngr);
    END IF;
  END LOOP;
   append_log_content(pi_text => 'Processing...');
   FOR i IN 1..l_tab_gty_group_type.COUNT LOOP
   --
     append_log_content(pi_text => 'Creating elements for '||l_tab_gty_group_type(i));
     OPEN  get_count_for_group(l_tab_gty_group_type(i));
     FETCH get_count_for_group INTO g_total_todo;
     CLOSE get_count_for_group;
     start_longop('Elements for '||l_tab_gty_group_type(i));
     l_gog := Nm3get.get_ngt(pi_ngt_group_type => l_tab_gty_group_type(i)).ngt_sub_group_allowed;
     FOR cs_rec IN (SELECT *
                    FROM  v2_road_segs
                    WHERE  rse_gty_group_type = l_tab_gty_group_type(i)
                    AND   rse_type          != 'S'
                    )
     LOOP
       SAVEPOINT start_of_element;
       BEGIN
         l_rec_ne.ne_id             := get_new_ne_id(p_rse_he_id => cs_rec.rse_he_id);
         l_rec_ne.ne_unique         := UPPER(cs_rec.rse_unique);
         l_rec_ne.ne_admin_unit     := cs_rec.rse_admin_unit;
         IF l_gog = 'Y' THEN
           l_rec_ne.ne_type        := 'P';
         ELSE
           l_rec_ne.ne_type        := 'G';
         END IF;
         l_rec_ne.ne_nt_type        := l_tab_nt_type(i);
         l_rec_ne.ne_descr          := NVL(cs_rec.rse_descr,cs_rec.rse_unique);
         l_rec_ne.ne_length         := NULL;--cs_rec.rse_length;
         l_rec_ne.ne_start_date     := TRUNC(cs_rec.rse_start_date);
         l_rec_ne.ne_end_date       := TRUNC(cs_rec.rse_end_date);
         l_rec_ne.ne_gty_group_type := cs_rec.rse_gty_group_type;
         l_rec_ne.ne_version_no     := cs_rec.rse_net_sel_crt;
         l_rec_ne.ne_prefix         := cs_rec.rse_sys_flag;
         Nm3user.set_effective_date(l_rec_ne.ne_start_date);
         IF g_debug THEN
           Nm3debug.debug_ne(l_rec_ne);
         END IF;
         Nm3ins.ins_ne_all (l_rec_ne);
         g_so_far := g_so_far + 1;
         set_longop_progress('Elements for '||l_tab_gty_group_type(i));
         EXCEPTION
           WHEN OTHERS THEN
            append_log_content(SQLERRM);
            append_log_content('Was raised during processing of road '||l_rec_ne.ne_unique);
            RAISE;
         END;
      END LOOP;
   END LOOP;
   -- now all the elements are in do the members
   FOR i IN 1..l_tab_gty_group_type.COUNT LOOP
   --
     append_log_content(pi_text => 'Creating members for '||l_tab_gty_group_type(i));
     OPEN  get_count_for_group(l_tab_gty_group_type(i));
     FETCH get_count_for_group INTO g_total_todo;
     CLOSE get_count_for_group;
     start_longop('Members for '||l_tab_gty_group_type(i));
--     Nm3ausec.set_status(Nm3type.c_off);
     FOR cs_rec IN (SELECT rse_unique, rse_he_id, rse_admin_unit
                    FROM   v2_road_segs
                    WHERE  rse_gty_group_type = l_tab_gty_group_type(i)
                    AND    rse_type          != 'S'
                    )
     LOOP
       FOR cs_mem IN (SELECT rsm.*, rse.rse_length rse_length, rse_unique
                        FROM  v2_road_seg_membs_all rsm,
                              v2_road_segs rse
                        WHERE  rsm.rsm_rse_he_id_in = cs_rec.rse_he_id
                        AND   rsm.rsm_rse_he_id_of = rse.rse_he_id
                       )
       LOOP
         SAVEPOINT start_of_member;
         BEGIN
           l_rec_nm.nm_ne_id_in      := get_new_ne_id(p_rse_he_id => cs_mem.rsm_rse_he_id_in);
           l_rec_nm.nm_ne_id_of      := get_new_ne_id(p_rse_he_id => cs_mem.rsm_rse_he_id_of);
           l_rec_nm.nm_type          := 'G';
           l_rec_nm.nm_obj_type      := l_tab_gty_group_type(i);
           l_rec_nm.nm_begin_mp      := NVL(cs_mem.rsm_begin_mp,0);
           l_rec_nm.nm_start_date    := TRUNC(cs_mem.rsm_start_date);
           l_rec_nm.nm_end_date      := TRUNC(cs_mem.rsm_end_date);
           l_rec_nm.nm_end_mp        := NVL(cs_mem.rsm_end_mp, NVL(cs_mem.rse_length,l_rec_nm.nm_begin_mp));
           IF l_tab_nt_type(i) = c_linear_group THEN
             l_rec_nm.nm_slk           := cs_mem.rsm_route_begin_mp;
           ELSE
             l_rec_nm.nm_slk           := NULL;
           END IF;
           l_rec_nm.nm_cardinality   := 1;
           l_rec_nm.nm_admin_unit    := cs_Rec.rse_admin_unit;
           l_rec_nm.nm_seq_no        := cs_mem.rsm_seq_no;
           l_rec_nm.nm_seg_no        := cs_mem.rsm_seq_no;
           l_rec_nm.nm_true          := cs_mem.rsm_route_begin_mp;
           Nm3user.set_effective_date(l_rec_nm.nm_start_date);
           IF g_debug THEN
             Nm3debug.debug_nm(l_rec_nm);
           END IF;
           Nm3ins.ins_nm_all (l_rec_nm);
           append_log_content('in  : '||l_rec_nm.nm_ne_id_in);
           append_log_content('of  : '||l_rec_nm.nm_ne_id_of);
           append_log_content('type: '||l_rec_nm.nm_obj_type);
		do_commit;  --MGT
           EXCEPTION
           WHEN OTHERS THEN
             append_log_content(SQLERRM);
             append_log_content('Was raised during processing of road '||cs_rec.rse_unique||' with member '||cs_mem.rse_unique);
             RAISE;
           END;
        END LOOP;
        g_so_far := g_so_far + 1;
        set_longop_progress('Members for '||l_tab_gty_group_type(i));
     END LOOP;
   END LOOP;
--
   Nm3user.set_effective_date(l_context_date_on_entry);
   Nm3ausec.set_status(Nm3type.c_on);
   do_optional_commit;
   append_log_content(pi_text => 'Done...');
--
   append_proc_end_to_log;
--
EXCEPTION
  WHEN OTHERS THEN
    append_log_content(SQLERRM);
    Nm3user.set_effective_date(l_context_date_on_entry);
    stop_migration('Road group migration aborted');
    Nm3ausec.set_status(Nm3type.c_on);
END migrate_other_groups;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_location_exception(l_rec IN OUT NM2_NM3_INV_EXCEPTIONS_LOC%ROWTYPE) IS
BEGIN
  l_rec.TIMESTAMP := SYSDATE;
  INSERT INTO NM2_NM3_INV_EXCEPTIONS_LOC
  (iit_ne_id
  ,iit_start_date
  ,iit_rse_he_id
  ,iit_begin_mp
  ,iit_end_mp
  ,iit_inv_type
  ,iit_exception
  ,TIMESTAMP)
  VALUES
  (l_rec.iit_ne_id
  ,l_rec.iit_start_date
  ,l_rec.iit_rse_he_id
  ,l_rec.iit_begin_mp
  ,l_rec.iit_end_mp
  ,l_rec.iit_inv_type
  ,l_rec.iit_exception
  ,l_rec.TIMESTAMP);
  log_error;
END insert_location_exception;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_inv_exception(l_rec IN OUT NM2_NM3_INV_EXCEPTIONS%ROWTYPE) IS
BEGIN
  l_rec.TIMESTAMP := SYSDATE;
  INSERT INTO NM2_NM3_INV_EXCEPTIONS
  (iit_ne_id
  ,iit_start_date
  ,iit_rse_he_id
  ,iit_begin_mp
  ,iit_end_mp
  ,iit_inv_type
  ,iit_exception
  ,TIMESTAMP)
  VALUES
  (l_rec.iit_ne_id
  ,l_rec.iit_start_date
  ,l_rec.iit_rse_he_id
  ,l_rec.iit_begin_mp
  ,l_rec.iit_end_mp
  ,l_rec.iit_inv_type
  ,l_rec.iit_exception
  ,l_rec.TIMESTAMP);
  log_error;
END insert_inv_exception;
--
-----------------------------------------------------------------------------
--
/*PROCEDURE update_inventory_fk_vals IS
BEGIN
  append_log_content('Updating Inventory Document Associations');
  IF NOT Nm3ddl.does_object_exist('IIT_V2_ITEM_ID','INDEX') THEN
    EXECUTE IMMEDIATE 'CREATE INDEX iit_v2_item_id ON nm_inv_items_all(iit_num_attrib115)';
  END IF;
  UPDATE DOC_ASSOCS
  SET das_rec_id = (SELECT iit_ne_id
                    FROM   NM_INV_ITEMS_ALL
                    WHERE  das_rec_id = iit_num_attrib115)
  WHERE das_table_name = 'INV_ITEMS_ALL'
  AND EXISTS (SELECT 1
              FROM   NM_INV_ITEMS_ALL
              WHERE  das_rec_id = iit_num_attrib115);
END update_inventory_fk_vals;
*/--
-----------------------------------------------------------------------------
--
PROCEDURE analyse_inventory_tables (p_percent NUMBER DEFAULT 1) IS
BEGIN
   DBMS_STATS.GATHER_TABLE_STATS(ownname          => USER
                                ,tabname          => 'NM_INV_ITEMS_ALL'
                                ,partname         => NULL
                                ,estimate_percent => p_percent
                                ,block_sample     => FALSE);
   DBMS_STATS.GATHER_TABLE_STATS(ownname          => USER
                                ,tabname          => 'NM_MEMBERS_ALL'
                                ,partname         => NULL
                                ,estimate_percent => p_percent
                                ,block_sample     => FALSE);
END analyse_inventory_tables;
--
-----------------------------------------------------------------------------
--
FUNCTION pc_inv_mig_nm2_nm3 (p_rec_iit_nm v2_inv_items_all%ROWTYPE)
RETURN NM_INV_ITEMS_ALL.iit_ne_id%TYPE IS
   --
   CURSOR cs_nau (c_nau_admin_unit nm_admin_units.nau_admin_unit%TYPE) IS
   SELECT nau_start_date
         ,nau_end_date
         ,ROWID nau_rowid
    FROM  NM_ADMIN_UNITS_ALL
   WHERE  nau_admin_unit = c_nau_admin_unit;
   l_cs_nau_rec cs_nau%ROWTYPE;
   l_change     BOOLEAN := FALSE;
   l_key_in_use NUMBER:=1;
   --
   l_sqlerrm          NM2_NM3_INV_EXCEPTIONS.iit_exception%TYPE;
   l_inv_exception    NM2_NM3_INV_EXCEPTIONS%ROWTYPE;
   l_rec_nit          nm_inv_types%ROWTYPE;
   l_rec_iit          nm_inv_items%ROWTYPE;
   l_rec_ne           nm_elements%ROWTYPE;
   l_rec_nau          nm_admin_units%ROWTYPE;
   --
   c_au_dt_trg CONSTANT VARCHAR2(30) := 'NM_ADMIN_UNITS_ALL_DT_TRG';
   --
   PROCEDURE sort_trigger (p_trigger_name   VARCHAR2
                          ,p_enable_disable VARCHAR2
                          ) IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      EXECUTE IMMEDIATE 'ALTER TRIGGER '||p_trigger_name||' '||p_enable_disable;
   END sort_trigger;
   --
BEGIN
   BEGIN
--      Nm3ausec.set_status (Nm3type.c_off);
      Nm3user.set_effective_date(p_rec_iit_nm.iit_cre_date);
      --
      DELETE /*+ RULE */ NM2_NM3_INV_EXCEPTIONS
      WHERE  iit_ne_id = p_rec_iit_nm.iit_item_id;
      --
      SAVEPOINT top_of_loop;
      --
      l_rec_iit.iit_inv_type              := get_nm3_inv_code(p_rec_iit_nm.iit_ity_inv_code, p_rec_iit_nm.iit_ity_sys_flag);
      --
	  --need to check if there is an existing asset using this primary_key,
	  --if there is then we cant use this id, get a new one
	  WHILE l_key_in_use !=0 LOOP
	    l_rec_iit.iit_ne_id                 := Nm3net.get_next_ne_id;
	    SELECT COUNT(*)
		INTO l_key_in_use
		FROM v2_inv_items_all
        WHERE  iit_ity_sys_flag = p_rec_iit_nm.iit_ity_sys_flag
        AND    iit_ity_inv_code = p_rec_iit_nm.iit_ity_inv_code
		AND IIT_PRIMARY_KEY=TO_CHAR(l_rec_iit.iit_ne_id);
	  END LOOP;
      l_rec_iit.iit_start_date            := TRUNC(p_rec_iit_nm.iit_cre_date);
      l_rec_iit.iit_angle                 := p_rec_iit_nm.iit_angle;
      l_rec_iit.iit_angle_txt             := p_rec_iit_nm.iit_angle_txt;
      l_rec_iit.iit_class                 := p_rec_iit_nm.iit_class;
      l_rec_iit.iit_class_txt             := p_rec_iit_nm.iit_class_txt;
      l_rec_iit.iit_colour                := p_rec_iit_nm.iit_colour;
      l_rec_iit.iit_colour_txt            := p_rec_iit_nm.iit_colour_txt;
      l_rec_iit.iit_description           := p_rec_iit_nm.iit_description;
      l_rec_iit.iit_diagram               := p_rec_iit_nm.iit_diagram;
      l_rec_iit.iit_distance              := p_rec_iit_nm.iit_distance;
      l_rec_iit.iit_gap                   := p_rec_iit_nm.iit_gap;
      l_rec_iit.iit_height                := p_rec_iit_nm.iit_height;
      l_rec_iit.iit_height_2              := p_rec_iit_nm.iit_height_2;
      l_rec_iit.iit_id_code               := p_rec_iit_nm.iit_id_code;
      l_rec_iit.iit_instal_date           := p_rec_iit_nm.iit_instal_date;
      l_rec_iit.iit_invent_date           := p_rec_iit_nm.iit_invent_date;
      l_rec_iit.iit_itemcode              := p_rec_iit_nm.iit_itemcode;
      l_rec_iit.iit_lco_lamp_config_id    := p_rec_iit_nm.iit_lco_lamp_config_id;
      l_rec_iit.iit_length                := p_rec_iit_nm.iit_length;
      l_rec_iit.iit_material              := p_rec_iit_nm.iit_material;
      l_rec_iit.iit_material_txt          := p_rec_iit_nm.iit_material_txt;
      l_rec_iit.iit_method                := p_rec_iit_nm.iit_method;
      l_rec_iit.iit_method_txt            := p_rec_iit_nm.iit_method_txt;
      l_rec_iit.iit_note                  := p_rec_iit_nm.iit_note;
      l_rec_iit.iit_no_of_units           := p_rec_iit_nm.iit_no_of_units;
      l_rec_iit.iit_options               := p_rec_iit_nm.iit_options;
      l_rec_iit.iit_options_txt           := p_rec_iit_nm.iit_options_txt;
      l_rec_iit.iit_oun_org_id_elec_board := p_rec_iit_nm.iit_oun_org_id_elec_board;
      l_rec_iit.iit_owner                 := p_rec_iit_nm.iit_owner;
      l_rec_iit.iit_owner_txt             := p_rec_iit_nm.iit_owner_txt;
      l_rec_iit.iit_peo_invent_by_id      := p_rec_iit_nm.iit_peo_invent_by_id;
      l_rec_iit.iit_photo                 := p_rec_iit_nm.iit_photo;
      l_rec_iit.iit_power                 := p_rec_iit_nm.iit_power;
      l_rec_iit.iit_rev_by                := p_rec_iit_nm.iit_rev_by;
      l_rec_iit.iit_rev_date              := p_rec_iit_nm.iit_rev_date;
      l_rec_iit.iit_type                  := p_rec_iit_nm.iit_type;
      l_rec_iit.iit_type_txt              := p_rec_iit_nm.iit_type_txt;
      l_rec_iit.iit_width                 := p_rec_iit_nm.iit_width;
      l_rec_iit.iit_xtra_char_1           := p_rec_iit_nm.iit_xtra_char_1;
      l_rec_iit.iit_xtra_date_1           := p_rec_iit_nm.iit_xtra_date_1;
      l_rec_iit.iit_xtra_domain_1         := p_rec_iit_nm.iit_xtra_domain_1;
      l_rec_iit.iit_xtra_domain_txt_1     := p_rec_iit_nm.iit_xtra_domain_txt_1;
      l_rec_iit.iit_xtra_number_1         := p_rec_iit_nm.iit_xtra_number_1;
      l_rec_iit.iit_x_sect                := p_rec_iit_nm.iit_x_sect;
      l_rec_iit.iit_coord_flag            := p_rec_iit_nm.iit_coord_flag;
      l_rec_iit.iit_end_date              := TRUNC(p_rec_iit_nm.iit_end_date);
      l_rec_iit.iit_prov_flag             := p_rec_iit_nm.iit_prov_flag;
      l_rec_iit.iit_inv_ownership         := p_rec_iit_nm.iit_inv_ownership;

      SELECT COUNT(*)
		INTO l_key_in_use
		FROM nm_inv_type_attribs_all
        where ita_attrib_name='IIT_PRIMARY_KEY'
        and ita_inv_type=l_rec_iit.iit_inv_type;
      if l_key_in_use=0 then
        l_rec_iit.iit_primary_key           := l_rec_iit.iit_ne_id;
      else
        l_rec_iit.iit_primary_key           := NVL(p_rec_iit_nm.iit_primary_key,l_rec_iit.iit_ne_id);
      end if;
--      l_rec_iit.iit_primary_key           := NVL(p_rec_iit_nm.iit_primary_key,l_rec_iit.iit_ne_id);
      l_rec_iit.iit_foreign_key           := p_rec_iit_nm.iit_foreign_key;
      l_rec_iit.iit_num_attrib16          := p_rec_iit_nm.iit_num_attrib16;
      l_rec_iit.iit_num_attrib17          := p_rec_iit_nm.iit_num_attrib17;
      l_rec_iit.iit_num_attrib18          := p_rec_iit_nm.iit_num_attrib18;
      l_rec_iit.iit_num_attrib19          := p_rec_iit_nm.iit_num_attrib19;
      l_rec_iit.iit_num_attrib20          := p_rec_iit_nm.iit_num_attrib20;
      l_rec_iit.iit_num_attrib21          := p_rec_iit_nm.iit_num_attrib21;
      l_rec_iit.iit_num_attrib22          := p_rec_iit_nm.iit_num_attrib22;
      l_rec_iit.iit_num_attrib23          := p_rec_iit_nm.iit_num_attrib23;
      l_rec_iit.iit_num_attrib24          := p_rec_iit_nm.iit_num_attrib24;
      l_rec_iit.iit_num_attrib25          := p_rec_iit_nm.iit_num_attrib25;
      l_rec_iit.iit_chr_attrib26          := p_rec_iit_nm.iit_chr_attrib26;
      l_rec_iit.iit_chr_attrib27          := p_rec_iit_nm.iit_chr_attrib27;
      l_rec_iit.iit_chr_attrib28          := p_rec_iit_nm.iit_chr_attrib28;
      l_rec_iit.iit_chr_attrib29          := p_rec_iit_nm.iit_chr_attrib29;
      l_rec_iit.iit_chr_attrib30          := p_rec_iit_nm.iit_chr_attrib30;
      l_rec_iit.iit_chr_attrib31          := p_rec_iit_nm.iit_chr_attrib31;
      l_rec_iit.iit_chr_attrib32          := p_rec_iit_nm.iit_chr_attrib32;
      l_rec_iit.iit_chr_attrib33          := p_rec_iit_nm.iit_chr_attrib33;
      l_rec_iit.iit_chr_attrib34          := p_rec_iit_nm.iit_chr_attrib34;
      l_rec_iit.iit_chr_attrib35          := p_rec_iit_nm.iit_chr_attrib35;
      l_rec_iit.iit_chr_attrib36          := p_rec_iit_nm.iit_chr_attrib36;
      l_rec_iit.iit_chr_attrib37          := p_rec_iit_nm.iit_chr_attrib37;
      l_rec_iit.iit_chr_attrib38          := p_rec_iit_nm.iit_chr_attrib38;
      l_rec_iit.iit_chr_attrib39          := p_rec_iit_nm.iit_chr_attrib39;
      l_rec_iit.iit_chr_attrib40          := p_rec_iit_nm.iit_chr_attrib40;
      l_rec_iit.iit_chr_attrib41          := p_rec_iit_nm.iit_chr_attrib41;
      l_rec_iit.iit_chr_attrib42          := p_rec_iit_nm.iit_chr_attrib42;
      l_rec_iit.iit_chr_attrib43          := p_rec_iit_nm.iit_chr_attrib43;
      l_rec_iit.iit_chr_attrib44          := p_rec_iit_nm.iit_chr_attrib44;
      l_rec_iit.iit_chr_attrib45          := p_rec_iit_nm.iit_chr_attrib45;
      l_rec_iit.iit_chr_attrib46          := p_rec_iit_nm.iit_chr_attrib46;
      l_rec_iit.iit_chr_attrib47          := p_rec_iit_nm.iit_chr_attrib47;
      l_rec_iit.iit_chr_attrib48          := p_rec_iit_nm.iit_chr_attrib48;
      l_rec_iit.iit_chr_attrib49          := p_rec_iit_nm.iit_chr_attrib49;
      l_rec_iit.iit_chr_attrib50          := p_rec_iit_nm.iit_chr_attrib50;
      l_rec_iit.iit_chr_attrib51          := p_rec_iit_nm.iit_chr_attrib51;
      l_rec_iit.iit_chr_attrib52          := p_rec_iit_nm.iit_chr_attrib52;
      l_rec_iit.iit_chr_attrib53          := p_rec_iit_nm.iit_chr_attrib53;
      l_rec_iit.iit_chr_attrib54          := p_rec_iit_nm.iit_chr_attrib54;
      l_rec_iit.iit_chr_attrib55          := p_rec_iit_nm.iit_chr_attrib55;
      l_rec_iit.iit_chr_attrib56          := p_rec_iit_nm.iit_chr_attrib56;
      l_rec_iit.iit_chr_attrib57          := p_rec_iit_nm.iit_chr_attrib57;
      l_rec_iit.iit_chr_attrib58          := p_rec_iit_nm.iit_chr_attrib58;
      l_rec_iit.iit_chr_attrib59          := p_rec_iit_nm.iit_chr_attrib59;
      l_rec_iit.iit_chr_attrib60          := p_rec_iit_nm.iit_chr_attrib60;
      l_rec_iit.iit_chr_attrib61          := p_rec_iit_nm.iit_chr_attrib61;
      l_rec_iit.iit_chr_attrib62          := p_rec_iit_nm.iit_chr_attrib62;
      l_rec_iit.iit_chr_attrib63          := p_rec_iit_nm.iit_chr_attrib63;
      l_rec_iit.iit_chr_attrib64          := p_rec_iit_nm.iit_chr_attrib64;
      l_rec_iit.iit_chr_attrib65          := p_rec_iit_nm.iit_chr_attrib65;
      l_rec_iit.iit_chr_attrib66          := p_rec_iit_nm.iit_chr_attrib66;
      l_rec_iit.iit_chr_attrib67          := p_rec_iit_nm.iit_chr_attrib67;
      l_rec_iit.iit_chr_attrib68          := p_rec_iit_nm.iit_chr_attrib68;
      l_rec_iit.iit_chr_attrib69          := p_rec_iit_nm.iit_chr_attrib69;
      l_rec_iit.iit_chr_attrib70          := p_rec_iit_nm.iit_chr_attrib70;
      l_rec_iit.iit_chr_attrib71          := p_rec_iit_nm.iit_chr_attrib71;
      l_rec_iit.iit_chr_attrib72          := p_rec_iit_nm.iit_chr_attrib72;
      l_rec_iit.iit_chr_attrib73          := p_rec_iit_nm.iit_chr_attrib73;
      l_rec_iit.iit_chr_attrib74          := p_rec_iit_nm.iit_chr_attrib74;
      l_rec_iit.iit_chr_attrib75          := p_rec_iit_nm.iit_chr_attrib75;
      l_rec_iit.iit_det_xsp               := p_rec_iit_nm.iit_det_xsp;
      l_rec_iit.iit_offset                := p_rec_iit_nm.iit_offset;
      l_rec_iit.iit_num_attrib76          := p_rec_iit_nm.iit_num_attrib76;
      l_rec_iit.iit_num_attrib77          := p_rec_iit_nm.iit_num_attrib77;
      l_rec_iit.iit_num_attrib78          := p_rec_iit_nm.iit_num_attrib78;
      l_rec_iit.iit_num_attrib79          := p_rec_iit_nm.iit_num_attrib79;
      l_rec_iit.iit_num_attrib80          := p_rec_iit_nm.iit_num_attrib80;
      l_rec_iit.iit_num_attrib81          := p_rec_iit_nm.iit_num_attrib81;
      l_rec_iit.iit_num_attrib82          := p_rec_iit_nm.iit_num_attrib82;
      l_rec_iit.iit_num_attrib83          := p_rec_iit_nm.iit_num_attrib83;
      l_rec_iit.iit_num_attrib84          := p_rec_iit_nm.iit_num_attrib84;
      l_rec_iit.iit_num_attrib85          := p_rec_iit_nm.iit_num_attrib85;
      l_rec_iit.iit_date_attrib86         := p_rec_iit_nm.iit_date_attrib86;
      l_rec_iit.iit_date_attrib87         := p_rec_iit_nm.iit_date_attrib87;
      l_rec_iit.iit_date_attrib88         := p_rec_iit_nm.iit_date_attrib88;
      l_rec_iit.iit_date_attrib89         := p_rec_iit_nm.iit_date_attrib89;
      l_rec_iit.iit_date_attrib90         := p_rec_iit_nm.iit_date_attrib90;
      l_rec_iit.iit_date_attrib91         := p_rec_iit_nm.iit_date_attrib91;
      l_rec_iit.iit_date_attrib92         := p_rec_iit_nm.iit_date_attrib92;
      l_rec_iit.iit_date_attrib93         := p_rec_iit_nm.iit_date_attrib93;
      l_rec_iit.iit_date_attrib94         := p_rec_iit_nm.iit_date_attrib94;
      --
      -- Store the measured length of the inventory item
      -- On migrated data this could be longer than the section length
      -- Therefore the membership record will store the legnth realtive to the
      -- section and this will store the actual length
      l_rec_iit.iit_num_attrib114         := NVL(p_rec_iit_nm.iit_end_chain, p_rec_iit_nm.iit_st_chain) - p_rec_iit_nm.iit_st_chain;
      -- Store the original iit_item_id away just in case
      l_rec_iit.iit_num_attrib115         := p_rec_iit_nm.iit_item_id;
      --
      l_rec_nit := Nm3inv.get_inv_type (l_rec_iit.iit_inv_type);
      l_rec_ne  := Nm3net.get_ne_all_rowtype(get_new_ne_id(p_rse_he_id => p_rec_iit_nm.iit_rse_he_id));
      --
      l_rec_iit.iit_admin_unit            := l_rec_ne.ne_admin_unit;
      OPEN  cs_nau (l_rec_iit.iit_admin_unit);
      FETCH cs_nau INTO l_cs_nau_rec;
      CLOSE cs_nau;
      --
      IF l_cs_nau_rec.nau_start_date >  l_rec_iit.iit_start_date
       THEN
         l_change := TRUE;
         l_cs_nau_rec.nau_start_date := l_rec_iit.iit_start_date;
      END IF;
      --
      IF NVL(l_cs_nau_rec.nau_end_date,Nm3type.c_big_date) < NVL(l_rec_iit.iit_end_date,Nm3type.c_big_date)
       THEN
         l_change := TRUE;
         l_cs_nau_rec.nau_end_date   := l_rec_iit.iit_end_date;
      END IF;
      --
      IF l_change
       THEN
         sort_trigger (c_au_dt_trg,'DISABLE');
         UPDATE NM_ADMIN_UNITS_ALL
          SET   nau_start_date = l_cs_nau_rec.nau_start_date
               ,nau_end_date   = l_cs_nau_rec.nau_end_date
         WHERE  ROWID          = l_cs_nau_rec.nau_rowid;
         sort_trigger (c_au_dt_trg,'ENABLE');
      END IF;
      --
      Nm3inv.insert_nm_inv_items (l_rec_iit);
      --
      Nm3ausec.set_status (Nm3type.c_on);
      g_so_far := g_so_far + 1;
      RETURN l_rec_iit.iit_ne_id;
   EXCEPTION
   WHEN OTHERS
     THEN
       l_sqlerrm := SUBSTR(Nm3flx.parse_error_message(SQLERRM),1,4000);
       ROLLBACK TO top_of_loop;
       l_inv_exception.iit_ne_id      := p_rec_iit_nm.iit_item_id;
       l_inv_exception.iit_start_date := l_rec_iit.iit_start_date;
       l_inv_exception.iit_rse_he_id  := p_rec_iit_nm.iit_rse_he_id;
       l_inv_exception.iit_begin_mp   := p_rec_iit_nm.iit_st_chain;
       l_inv_exception.iit_end_mp     := p_rec_iit_nm.iit_end_chain;
       l_inv_exception.iit_inv_type   := l_rec_iit.iit_inv_type;
       l_inv_exception.iit_exception  := l_sqlerrm;
       insert_inv_exception(l_inv_exception);
       Nm3ausec.set_status (Nm3type.c_on);
       RETURN -1;
   END;
--
END pc_inv_mig_nm2_nm3;
--
------------------------------------------------------------------------------------
--
PROCEDURE locate_inventory (p_ne_id      IN NM_MEMBERS_ALL.nm_ne_id_of%TYPE
                           ,p_item_id    IN NM_MEMBERS_ALL.nm_ne_id_in%TYPE
                           ,p_start_mp   IN NM_MEMBERS_ALL.nm_begin_mp%TYPE
                           ,p_end_mp     IN NM_MEMBERS_ALL.nm_end_mp%TYPE
                           ,p_start_date IN NM_MEMBERS_ALL.nm_start_date%TYPE
                           ,p_end_date   IN NM_MEMBERS_ALL.nm_end_date%TYPE) IS
   e_member_date_prob   EXCEPTION;
   --
   l_inv_loc_exc      NM2_NM3_INV_EXCEPTIONS_LOC%ROWTYPE;
   l_rec_nm           nm_members%ROWTYPE;
   l_rec_ne           NM_ELEMENTS_ALL%ROWTYPE;
   l_inv_item         NM_INV_ITEMS_ALL%ROWTYPE;
BEGIN
--  Nm3ausec.set_status (Nm3type.c_off);
  DELETE /*+ RULE */ NM2_NM3_INV_EXCEPTIONS_LOC
  WHERE  iit_ne_id = p_item_id;
  SAVEPOINT top_of_loop;
  l_inv_item := Nm3get.get_iit_all(p_item_id);
  l_rec_ne := nm3get.get_ne_all(get_new_ne_id(p_rse_he_id => p_ne_id));
  l_rec_nm.nm_ne_id_in    := p_item_id;
  l_rec_nm.nm_ne_id_of    := get_new_ne_id(p_rse_he_id => p_ne_id);
  l_rec_nm.nm_type        := 'I';
  l_rec_nm.nm_obj_type    := l_inv_item.iit_inv_type;
  l_rec_nm.nm_begin_mp    := GREATEST(p_start_mp,0); -- inventory cannot start at a -ve position
  l_rec_nm.nm_start_date  := TRUNC(p_start_date);
  l_rec_nm.nm_end_date    := TRUNC(p_end_date);
  l_rec_nm.nm_end_mp      := LEAST(p_end_mp,l_rec_ne.ne_length); -- inventory cannot go beyond the length of the section
  l_rec_nm.nm_slk         := NULL;
  l_rec_nm.nm_cardinality := 1;
  l_rec_nm.nm_admin_unit  := l_inv_item.iit_admin_unit;
  l_rec_nm.nm_seq_no      := 1;
  l_rec_nm.nm_seg_no      := NULL;
  l_rec_nm.nm_true        := NULL;
  --
  IF l_rec_ne.ne_start_date > l_rec_nm.nm_start_date THEN
    l_rec_nm.nm_start_date := l_rec_ne.ne_start_date;
  END IF;
  --
  IF l_rec_ne.ne_end_date IS NOT NULL AND l_rec_nm.nm_end_date IS NOT NULL
  AND l_rec_ne.ne_end_date < l_rec_nm.nm_end_date THEN
    l_rec_nm.nm_end_date := l_rec_ne.ne_end_date;
  END IF;
  --
  IF  l_rec_nm.nm_start_date > l_rec_nm.nm_end_date
   OR l_rec_nm.nm_start_date < l_inv_item.iit_start_date THEN
    RAISE e_member_date_prob;
  END IF;
  --
  IF l_rec_nm.nm_end_mp < l_rec_nm.nm_begin_mp THEN
    l_rec_nm.nm_end_mp   := l_rec_nm.nm_begin_mp;
  END IF;
  --
  IF   Nm3inv.get_nit_pnt_or_cont(l_inv_item.iit_inv_type) = 'C'
   AND l_rec_nm.nm_begin_mp      = l_rec_nm.nm_end_mp THEN
    Hig.raise_ner(Nm3type.c_net,86);
  END IF;
  --
  Nm3net.ins_nm (l_rec_nm);
  Nm3ausec.set_status (Nm3type.c_on);
  EXCEPTION
    WHEN OTHERS THEN
       ROLLBACK TO top_of_loop;
       l_inv_loc_exc.iit_ne_id      := p_item_id;
       l_inv_loc_exc.iit_start_date := p_start_date;
       l_inv_loc_exc.iit_rse_he_id  := p_ne_id;
       l_inv_loc_exc.iit_begin_mp   := p_start_mp;
       l_inv_loc_exc.iit_end_mp     := nvl(p_end_mp,p_start_mp);
       l_inv_loc_exc.iit_inv_type   := l_inv_item.iit_inv_type;
       --l_inv_loc_exc.iit_exception  := SUBSTR(Nm3flx.parse_error_message(SQLERRM),1,4000);
       l_inv_loc_exc.iit_exception  := SUBSTR(SQLERRM,1,4000);
       insert_location_exception(l_inv_loc_exc);
       Nm3ausec.set_status (Nm3type.c_on);
--       raise;
END locate_inventory;
--
------------------------e-----------------------------------------------------
--
PROCEDURE pc_inv_mig_nm2_nm3_by_id (p_iit_item_id    NM_INV_ITEMS_ALL.iit_ne_id%TYPE) IS
   CURSOR cs_iit IS
   SELECT iit1.*
    FROM  v2_inv_items_all iit1
   WHERE  iit_item_id = p_iit_item_id;
   l_rec_iit v2_inv_items_all%ROWTYPE;
   l_ne_id   NM_INV_ITEMS_ALL.iit_ne_id%TYPE;
   l_found   BOOLEAN;
BEGIN
   OPEN  cs_iit;
   FETCH cs_iit INTO l_rec_iit;
   l_found := cs_iit%FOUND;
   CLOSE cs_iit;
   IF NOT l_found THEN
     RAISE inv_item_not_found;
   END IF;
   l_ne_id := pc_inv_mig_nm2_nm3 (l_rec_iit);
   IF l_ne_id != -1 THEN
     locate_inventory(p_ne_id      => l_rec_iit.iit_rse_he_id
                     ,p_item_id    => l_ne_id
                     ,p_start_mp   => l_rec_iit.iit_st_chain
                     ,p_end_mp     => l_rec_iit.iit_end_chain
                     ,p_start_date => l_rec_iit.iit_cre_date
                     ,p_end_date   => l_rec_iit.iit_end_date);
   END IF;
EXCEPTION
  WHEN inv_item_not_found THEN
    append_log_content('Inventory item '||p_iit_item_id||' not found in source data');
END pc_inv_mig_nm2_nm3_by_id;
--
------------------------------------------------------------------------------------
--
PROCEDURE pc_inv_mig_nm2_nm3_by_type (p_nit_inv_type NM_INV_ITEMS_ALL.iit_inv_type%TYPE
                                     ,p_nit_sys_flag VARCHAR2
                                     ,p_update_progress BOOLEAN DEFAULT FALSE
                                     ,p_open_only varchar2 default 'N'
                                     ) IS
   CURSOR cs_iit (c_inv_type nm_inv_types.nit_inv_type%TYPE
                 ,c_sys_flag v2_inv_item_types.ity_sys_flag%TYPE
                 ,c_open_only varchar2
                 ) IS
   SELECT iit1.iit_item_id
    FROM  v2_inv_items_all iit1
   WHERE  iit1.iit_ity_sys_flag = c_sys_flag
    AND   iit1.iit_ity_inv_code = c_inv_type
       and ((c_open_only='Y' and iit_end_Date is null)
      or (c_open_only='Y'))
    ;
   l_tab_item_id Nm3type.tab_number;
   l_count       PLS_INTEGER := 0;
BEGIN
   OPEN  cs_iit(get_nm2_inv_code(p_nit_inv_type),p_nit_sys_flag,upper(p_open_only));
   FETCH cs_iit BULK COLLECT INTO l_tab_item_id;
   CLOSE cs_iit;
   FOR i IN 1..l_tab_item_id.COUNT
    LOOP
      l_count      := l_count + 1;
      IF MOD(l_count,500) = 0 THEN
        do_optional_commit;
        IF p_update_progress THEN
          set_longop_progress(p_what         => 'Inventory Migration');
        END IF;
      END IF;
      IF MOD(g_so_far, 20000) = 0 OR g_so_far = 1000 THEN -- refresh statistics every 20000 rows or after first 1000
        append_log_content('Refreshing Inventory Statistics');
        analyse_inventory_tables(100);
      END IF;
      pc_inv_mig_nm2_nm3_by_id (l_tab_item_id(i));
   END LOOP;
   do_optional_commit;
END pc_inv_mig_nm2_nm3_by_type;
--
------------------------------------------------------------------------------------
--
PROCEDURE migrate_inventory(p_ukp_only varchar2 default 'A' ,p_open_only varchar2 default 'N') IS
--
  TYPE l_ref IS REF CURSOR;
--
   get_inv_types l_ref;
   l_sql_all Nm3type.max_varchar2 := 'SELECT ity_inv_code '||
                                 '      ,ity_sys_flag '||
                                 'FROM inv_type_translations '||
                                 'CONNECT BY PRIOR ity_inv_code = ity_parent_ity (+)'||
                                 'START WITH ity_parent_ity IS NULL ORDER BY ity_sys_flag,ity_inv_code';

   l_sql_ukp Nm3type.max_varchar2 := 'SELECT ity_inv_code '||
                                 '      ,ity_sys_flag '||
                                 'FROM inv_type_translations '||
'where  exists (select ''x'' from ukpms_view_Definitions where ity_inv_code= UVD_INV_CODE and ity_sys_flag= UVD_SYS_FLAG)'||
                                 'CONNECT BY PRIOR ity_inv_code = ity_parent_ity (+)'||
                                 'START WITH ity_parent_ity IS NULL ORDER BY ity_sys_flag,ity_inv_code';

   l_sql_no_ukp Nm3type.max_varchar2 := 'SELECT ity_inv_code '||
                                 '      ,ity_sys_flag '||
                                 'FROM inv_type_translations '||
'where not  exists (select ''x'' from ukpms_view_Definitions where ity_inv_code= UVD_INV_CODE and ity_sys_flag= UVD_SYS_FLAG)'||
                                 'CONNECT BY PRIOR ity_inv_code = ity_parent_ity (+)'||
                                 'START WITH ity_parent_ity IS NULL ORDER BY ity_sys_flag,ity_inv_code';


   l_tab_inv_type Nm3type.tab_varchar4;
   l_tab_sys_flag Nm3type.tab_varchar1;
   l_count_errors PLS_INTEGER;
--
   CURSOR get_work_to_do(p_inv_type varchar2,p_sys_flag varchar2) IS
   SELECT COUNT(*)
   FROM v2_inv_items_all
   WHERE  iit_ity_sys_flag = p_sys_flag
    AND   iit_ity_inv_code = p_inv_type
;
--
   CURSOR get_errors IS
   SELECT   'Inventory' issue
           ,iit_inv_type
           ,COUNT(*) num_issues
           ,iit_exception
   FROM     NM2_NM3_INV_EXCEPTIONS
   GROUP BY iit_inv_type, iit_exception
   UNION
   SELECT   'Locating'
           ,iit_inv_type
           ,COUNT(*)
           ,iit_exception
   FROM     NM2_NM3_INV_EXCEPTIONS_LOC
   GROUP BY iit_inv_type, iit_exception
   ORDER BY 1,2;
  PROCEDURE tidy_data IS
  BEGIN
    append_log_content(pi_text => 'Tidying Existing Data');
--    DELETE NM_MEMBERS_ALL WHERE nm_type = 'I';
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_group_inv_link_all DISABLE CONSTRAINT NGIL_FK_IIT');
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_inv_items_all disable CONSTRAINT IIT_LOCATED_FK');
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_inv_item_groupings_all DISABLE CONSTRAINT IIG_IIT_FK_PARENT');
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_inv_item_groupings_all DISABLE CONSTRAINT IIG_IIT_FK_TOP');
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_nw_ad_link_all DISABLE CONSTRAINT NADL_IIT_NE_ID_FK');
--    EXECUTE IMMEDIATE ('DELETE FROM nm_members_all WHERE nm_type = ''I''');
--    EXECUTE IMMEDIATE ('TRUNCATE TABLE nm_inv_item_groupings_all');
--    EXECUTE IMMEDIATE ('TRUNCATE TABLE nm_nw_ad_link_all');
--    EXECUTE IMMEDIATE ('TRUNCATE TABLE nm_inv_items_all');
--    EXECUTE IMMEDIATE ('TRUNCATE TABLE nm2_nm3_inv_exceptions');
--    EXECUTE IMMEDIATE ('TRUNCATE TABLE nm2_nm3_inv_exceptions_loc');
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_group_inv_link_all ENABLE CONSTRAINT NGIL_FK_IIT');
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_inv_items_all enable CONSTRAINT IIT_LOCATED_FK');
--    EXECUTE IMMEDIATE ('ALTER TABLE nm_inv_item_groupings_all ENABLE CONSTRAINT IIG_IIT_FK_PARENT');
 --   EXECUTE IMMEDIATE ('ALTER TABLE nm_inv_item_groupings_all ENABLE CONSTRAINT IIG_IIT_FK_TOP');
  --  EXECUTE IMMEDIATE ('ALTER TABLE nm_nw_ad_link_all enABLE CONSTRAINT NADL_IIT_NE_ID_FK');
    append_log_content(pi_text => 'Done');
  END tidy_data;
BEGIN
--
   g_proc_name := 'migrate_inventory';
   append_proc_start_to_log;
--
   tidy_data;


   if upper(p_ukp_only) ='A' then
     OPEN  get_inv_types FOR l_sql_all;
     FETCH get_inv_types BULK COLLECT INTO l_tab_inv_type, l_tab_sys_flag;
     CLOSE get_inv_types;
   elsif upper(p_ukp_only) ='U' then
     OPEN  get_inv_types FOR l_sql_ukp;
     FETCH get_inv_types BULK COLLECT INTO l_tab_inv_type, l_tab_sys_flag;
     CLOSE get_inv_types;
   elsif upper(p_ukp_only) ='N' then
     OPEN  get_inv_types FOR l_sql_no_ukp;
     FETCH get_inv_types BULK COLLECT INTO l_tab_inv_type, l_tab_sys_flag;
     CLOSE get_inv_types;
   end if;

   g_total_todo:=0;
   for i in 1..l_tab_inv_type.count loop
     OPEN get_work_to_do(l_tab_inv_type(i),l_tab_sys_flag(i));
     FETCH get_work_to_do INTO g_so_far;
     CLOSE get_work_to_do;
     g_total_todo:=g_total_todo+g_so_far;
     g_so_far:=0;
   end loop;




   -- set up the long op for inventory migration
   start_longop(p_what         => 'Inventory Migration'
               ,p_total_amount => g_total_todo);
   FOR i IN 1..l_tab_inv_type.COUNT
    LOOP
      append_log_content(pi_text => 'Processing Inventory Type ['||l_tab_inv_type(i)||'] on network '||l_tab_sys_flag(i));
      pc_inv_mig_nm2_nm3_by_type (l_tab_inv_type(i), l_tab_sys_flag(i), TRUE, p_open_only);
   END LOOP;
--
--   append_log_content('Analysing inventory tables');
--   analyse_inventory_tables(100);
   --
--   update_inventory_fk_vals;
   --
   report_any_errors;
   l_count_errors := 0;
   FOR irec IN get_errors LOOP
     IF l_count_errors = 0 THEN
       append_log_content('Summary of Errors:');
     END IF;
     l_count_errors := l_count_errors + 1;
     append_log_content(irec.num_issues||' '||irec.issue||' issues with '||irec.iit_inv_type||' error recorded, '||irec.iit_exception);
   END LOOP;
   append_proc_end_to_log;
--
EXCEPTION
 WHEN OTHERS THEN
   append_log_content(SQLERRM);
   stop_migration('Inventory migration aborted');
END migrate_inventory;
--
-----------------------------------------------------------------------------
--
PROCEDURE migrate_network_inv(pi_netw_inv_type   IN VARCHAR2 DEFAULT 'NETW') IS
  CURSOR get_count_road_dets IS
  SELECT COUNT(*)
  FROM   v2_road_segs
  WHERE  rse_type = 'S';
  CURSOR get_v2_road_dets IS
  SELECT *
  FROM   v2_road_segs
  WHERE  rse_type = 'S';
  CURSOR cs_rse IS
  SELECT rse_admin_unit, MIN(rse_start_date) min_st_date, MAX(rse_end_date) max_end_date
   FROM  v2_road_segs
  GROUP BY rse_admin_unit;
--
  CURSOR cs_au (c_admin_unit NUMBER) IS
  SELECT ROWID nau_rowid
        ,nau_start_date
        ,nau_end_date
   FROM  NM_ADMIN_UNITS_ALL
  WHERE  nau_admin_unit = c_admin_unit;
  l_rec              cs_au%ROWTYPE;
  l_iit              NM_INV_ITEMS_ALL%ROWTYPE;
  l_nm               NM_MEMBERS_ALL%ROWTYPE;
  l_sqlerrm          NM2_NM3_INV_EXCEPTIONS.iit_exception%TYPE;
  l_inv_exception    NM2_NM3_INV_EXCEPTIONS%ROWTYPE;
  l_inv_loc_exc      NM2_NM3_INV_EXCEPTIONS_LOC%ROWTYPE;
  l_nadl_row		 NM_NW_AD_LINK%ROWTYPE;
--
BEGIN
--
 g_proc_name := 'migrate_network_inv';
 append_proc_start_to_log;
--
 EXECUTE IMMEDIATE('ALTER TRIGGER NM_ADMIN_UNITS_ALL_DT_TRG DISABLE');
  append_log_content(pi_text => 'NM_ADMIN_UNITS_ALL');
  FOR cs_rec IN cs_rse
   LOOP
     OPEN  cs_au (cs_rec.rse_admin_unit);
     FETCH cs_au INTO l_rec;
     CLOSE cs_au;
     IF l_rec.nau_start_date > cs_rec.min_st_date
      THEN
        l_rec.nau_start_date := cs_rec.min_st_date;
     END IF;
     IF NVL(l_rec.nau_end_date,Nm3type.c_big_date) < NVL(cs_rec.max_end_date,Nm3type.c_big_date)
      THEN
        l_rec.nau_end_date   := cs_rec.max_end_date;
     END IF;
     UPDATE NM_ADMIN_UNITS_ALL
      SET   nau_start_date = l_rec.nau_start_date
           ,nau_end_date   = l_rec.nau_end_date
     WHERE  ROWID          = l_rec.nau_rowid;
  END LOOP;
--
 EXECUTE IMMEDIATE('ALTER TRIGGER NM_ADMIN_UNITS_ALL_DT_TRG ENABLE');
--
 do_optional_commit;
 append_log_content(pi_text => 'NM_INV_ITEMS_ALL');
 OPEN  get_count_road_dets;
 FETCH get_count_road_dets INTO g_total_todo;
 CLOSE get_count_road_dets;
 start_longop(p_what         => 'Road Section Attributes');
-- Nm3ausec.set_status (Nm3type.c_off);

-- make sure that inv type has correct admin type
update nm_inv_types_all
set nit_admin_type = 'NETW'
where nit_inv_type = 'NETW';

 FOR irec IN get_v2_road_dets LOOP
   BEGIN
     SAVEPOINT top_of_loop;

     Nm3user.set_effective_date(irec.rse_start_date);

     l_nm.nm_ne_id_in := NULL; -- clearing this out indicates that we are not dealing with the member
     l_iit.iit_ne_id         := Nm3seq.next_ne_id_seq;
     l_iit.iit_inv_type      := pi_netw_inv_type;
     l_iit.iit_primary_key   := l_iit.iit_ne_id ;
     l_iit.iit_start_date    := TRUNC(irec.rse_start_date);
     l_iit.iit_end_date    := TRUNC(irec.rse_end_date);
     l_iit.iit_admin_unit    := irec.rse_admin_unit;
     l_iit.iit_descr         := SUBSTR(irec.rse_descr,1,40);
--flex attribs
     l_iit.iit_chr_attrib42  := irec.rse_road_type;
     l_iit.iit_chr_attrib45  := irec.rse_status;
     l_iit.iit_date_attrib87 := irec.rse_date_opened;
     l_iit.iit_chr_attrib26  := irec.rse_adoption_status;
     l_iit.iit_date_attrib86 := irec.rse_date_adopted;
     l_iit.iit_chr_attrib28  := irec.rse_carriageway_type;
     l_iit.iit_chr_attrib41  := irec.rse_road_environment;
     l_iit.iit_date_attrib89 := irec.rse_last_surveyed;
     l_iit.iit_num_attrib25  := irec.rse_speed_limit;
     l_iit.iit_chr_attrib33  := irec.rse_int_code;
     l_iit.iit_num_attrib76  := irec.rse_veh_per_day;
     l_iit.iit_chr_attrib34  := irec.rse_maint_category;
     l_iit.iit_chr_attrib32  := irec.rse_footway_category;
     l_iit.iit_num_attrib20  := irec.rse_hgv_percent;
     l_iit.iit_num_attrib22  := irec.rse_number_of_lanes;
     l_iit.iit_chr_attrib35  := irec.rse_network_direction;
     l_iit.iit_num_attrib24  := irec.rse_skid_res;
     l_iit.iit_chr_attrib44  := irec.rse_shared_items;
     l_iit.iit_chr_attrib40  := irec.rse_road_category;
     l_iit.iit_date_attrib88 := irec.rse_last_inspected;
     l_iit.iit_chr_attrib38  := irec.rse_ref_coat_flag;
     l_iit.iit_chr_attrib37  := irec.rse_record_invent_rev;
     l_iit.iit_chr_attrib51  := irec.rse_traffic_level;
--
     l_iit.iit_num_attrib16  := irec.rse_alias;
--
     l_iit.iit_num_attrib78  := irec.rse_cnt_code;
     l_iit.iit_chr_attrib29  := irec.rse_coord_flag;
     l_iit.iit_chr_attrib39  := irec.rse_reinstatement_category;
--     l_iit.iit_num_attrib23  := irec.rse_search_group_no;
     l_iit.iit_chr_attrib43  := irec.rse_seq_signif;
     l_iit.iit_num_attrib21  := irec.rse_max_chain;
     l_iit.iit_chr_attrib50  := irec.rse_length_status;
     l_iit.iit_num_attrib83  := irec.rse_usrn_no;
/* the rest
     irec.rse_bh_hier_code;  --now a link based attribute
     irec.rse_class_index;   --derived
     l_iit.iit_chr_attrib31  := irec.rse_engineering_difficulty;
     l_iit.iit_num_attrib17  := irec.rse_gis_mapid;
     l_iit.iit_num_attrib18  := irec.rse_gis_mslink;
     l_iit.iit_num_attrib19  := irec.rse_gradient;
     l_iit.iit_chr_attrib36  := irec.rse_nla_type;
     l_iit.iit_chr_attrib46  := irec.rse_traffic_sensitivity;
     l_iit.iit_num_attrib77  := irec.rse_begin_mp;
     l_iit.iit_num_attrib79  := irec.rse_couplet_id;
     l_iit.iit_num_attrib80  := irec.rse_end_mp;
     l_iit.iit_chr_attrib47  := irec.rse_gov_level;
     l_iit.iit_num_attrib81  := irec.rse_max_mp;
     l_iit.iit_chr_attrib48  := irec.rse_prefix;
     l_iit.iit_num_attrib82  := irec.rse_route;
     l_iit.iit_chr_attrib49  := irec.rse_suffix;
     l_iit.iit_chr_attrib52  := irec.rse_net_sel_crt;
*/
     l_iit.iit_num_attrib113 := irec.rse_he_id;
     l_iit.iit_num_attrib114 := 0;
     l_iit.iit_num_attrib115 := irec.rse_length;
--     append_log_content('IIT_NE_ID '||l_iit.IIT_NE_ID);
--     append_log_content('IIT_ADMIN_UNIT '||l_iit.IIT_ADMIN_UNIT);
--     append_log_content('irec.rse_he_id '||irec.rse_he_id);
     Nm3ins.ins_iit_all(p_rec_iit_all => l_iit);
	 SELECT  NAD_ID
	 INTO l_nadl_row.NAD_ID
	 FROM NM_NW_AD_TYPES
	 WHERE nad_nt_type=irec.rse_sys_flag
	 AND nad_inv_type=l_iit.iit_inv_type
	 AND NAD_PRIMARY_AD='Y';
	 l_nadl_row.NAD_IIT_NE_ID  :=l_iit.iit_ne_id;
	 l_nadl_row.NAD_NE_ID      :=get_new_ne_id(p_rse_he_id => irec.rse_he_id);
	 l_nadl_row.NAD_START_DATE :=l_iit.iit_start_date;
	 l_nadl_row.NAD_END_DATE   :=l_iit.iit_end_date;
	 l_nadl_row.NAD_NT_TYPE    :=irec.rse_sys_flag;
	 l_nadl_row.NAD_GTY_TYPE   :=NULL;
	 l_nadl_row.NAD_INV_TYPE   :=l_iit.iit_inv_type;
	 Nm3nwad.ins_nadl(pi_nadl_rec => l_nadl_row);
     EXCEPTION
     WHEN OTHERS THEN

 --         append_log_content('IIT_NE_ID '||l_iit.IIT_NE_ID);
 --         append_log_content('IIT_ADMIN_UNIT '||l_iit.IIT_ADMIN_UNIT);
 --         append_log_content('irec.rse_he_id '||irec.rse_he_id);

      l_sqlerrm := SUBSTR(Nm3flx.parse_error_message(SQLERRM),1,4000);
      ROLLBACK TO top_of_loop;
      l_inv_exception.iit_ne_id      := l_iit.iit_ne_id;
      l_inv_exception.iit_start_date := l_iit.iit_start_date;
      l_inv_exception.iit_rse_he_id  := irec.rse_he_id;
      l_inv_exception.iit_begin_mp   := 0;
      l_inv_exception.iit_end_mp     := irec.rse_length;
      l_inv_exception.iit_inv_type   := l_iit.iit_inv_type;
      l_inv_exception.iit_exception  := l_sqlerrm;
      insert_inv_exception(l_inv_exception);
	  RAISE;
    END;
    g_so_far := g_so_far + 1;
    set_longop_progress('Road Section Attributes');
 END LOOP;
 Nm3ausec.set_status (Nm3type.c_on);
--
 do_optional_commit;
--
   report_any_errors;
   append_proc_end_to_log;
--
EXCEPTION
  WHEN OTHERS THEN
    append_log_content(SQLERRM);
    stop_migration('Inventory migration aborted');
    Nm3ausec.set_status (Nm3type.c_on);
END migrate_network_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE migrate_failed_inventory(pi_log_file_location   IN VARCHAR2) IS
l_tab_iit_ne_id Nm3type.tab_number;
l_sqlerrm  all_errors.text%TYPE;
BEGIN
--
  initialise(pi_log_file_location  => pi_log_file_location
            ,pi_log_file_name      => 'Failed_Inventory_'||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.LOG');
  SELECT iit_ne_id
  BULK COLLECT INTO l_tab_iit_ne_id
  FROM NM2_NM3_INV_EXCEPTIONS;
--
  g_total_todo := l_tab_iit_ne_id.COUNT;
  start_longop(p_what         => 'Failed Inventory Migration'
              ,p_total_amount => g_total_todo);
  FOR i IN 1..l_tab_iit_ne_id.COUNT LOOP
    BEGIN
      pc_inv_mig_nm2_nm3_by_id (l_tab_iit_ne_id(i));
      IF MOD(i, 500) = 0 THEN
        set_longop_progress(p_what => 'Failed Inventory Migration');
      END IF;
    EXCEPTION
      WHEN inv_item_not_found THEN
        NULL;
    END;
  END LOOP;
  do_optional_commit;
--  update_inventory_fk_vals;
  --
  report_any_errors;
  append_mig_end_to_log;
  close_log;
EXCEPTION
    WHEN OTHERS THEN
        append_log_content(SQLERRM);
        do_rollback;
        close_log;
        RAISE_APPLICATION_ERROR(-20001, l_sqlerrm);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE migrate_failed_inventory_loc(pi_log_file_location   IN VARCHAR2) IS
CURSOR get_failed_inv IS
SELECT l.iit_ne_id
      ,v2inv.iit_st_chain
      ,v2inv.iit_end_chain
      ,l.iit_rse_he_id
      ,l.iit_start_date
FROM   NM2_NM3_INV_EXCEPTIONS_LOC l
      ,v2_inv_items_all           v2inv
      ,NM_INV_ITEMS_ALL           v3inv
WHERE NOT EXISTS (SELECT 1
                  FROM   NM2_NM3_INV_EXCEPTIONS i
                  WHERE  i.iit_ne_id = l.iit_ne_id)
AND l.iit_ne_id       = v3inv.iit_ne_id
AND v2inv.iit_item_id = v3inv.iit_num_attrib115;
l_iit      NM_INV_ITEMS_ALL%ROWTYPE;
l_sqlerrm  all_errors.text%TYPE;
BEGIN
--
  initialise(pi_log_file_location  => pi_log_file_location
            ,pi_log_file_name      => 'Failed_Location_'||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.LOG');
  FOR irec IN get_failed_inv LOOP
    l_iit:= Nm3get.get_iit_all(pi_iit_ne_id => irec.iit_ne_id);
    locate_inventory(p_ne_id      => irec.iit_rse_he_id
                    ,p_item_id    => l_iit.iit_ne_id
                    ,p_start_mp   => irec.iit_st_chain
                    ,p_end_mp     => irec.iit_end_chain
                    ,p_start_date => irec.iit_start_date
                    ,p_end_date   => l_iit.iit_end_date);
  END LOOP;
  do_optional_commit;
  report_any_errors;
  append_mig_end_to_log;
  close_log;
EXCEPTION
    WHEN OTHERS THEN
        l_sqlerrm := SQLERRM;
        append_log_content(pi_text => l_sqlerrm);
        do_rollback;
        close_log;
        RAISE_APPLICATION_ERROR(-20001, l_sqlerrm);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE tidy_up_following_migration IS
   CURSOR cs_ita IS
   SELECT ita_id_domain
         ,ita_attrib_name
         ,ita_inv_type
    FROM  NM_INV_TYPE_ATTRIBS_ALL
   WHERE  ita_id_domain IS NOT NULL;
   l_tab_domain   Nm3type.tab_varchar30;
   l_tab_attrib   Nm3type.tab_varchar30;
   l_tab_inv_type Nm3type.tab_varchar4;
   l_sql          VARCHAR2(32767);
BEGIN
--
 g_proc_name := 'tidy_up_following_migration';
 append_proc_start_to_log;
--
   --------------------------------------------------
   -- Get rid of any INV_ATTRI_LOOKUPS we don't need
   --------------------------------------------------
   append_log_content(pi_text => 'NM_INV_ATTRI_LOOKUP_ALL');
   OPEN  cs_ita;
   FETCH cs_ita BULK COLLECT INTO l_tab_domain, l_tab_attrib, l_tab_inv_type;
   CLOSE cs_ita;
   FOR i IN 1..l_tab_attrib.COUNT
    LOOP
      l_sql := 'DELETE FROM nm_inv_attri_lookup_all';
      l_sql := l_sql||CHR(10)||'WHERE ial_domain = '||Nm3flx.string(l_tab_domain(i));
      l_sql := l_sql||CHR(10)||' AND  ial_value  = ial_dtp_code';
      l_sql := l_sql||CHR(10)||' AND  NOT EXISTS (SELECT 1';
      l_sql := l_sql||CHR(10)||'                   FROM  nm_inv_items_all';
      l_sql := l_sql||CHR(10)||'                  WHERE  iit_inv_type = '||Nm3flx.string(l_tab_inv_type(i));
      l_sql := l_sql||CHR(10)||'                   AND   '||l_tab_attrib(i)||' = ial_value';
      l_sql := l_sql||CHR(10)||'                 )';
      EXECUTE IMMEDIATE l_sql;
   END LOOP;
   do_optional_commit;
  BEGIN
    append_log_content(pi_text => 'REFRESH ALL SYNONYMS');
    Nm3ddl.refresh_all_synonyms;
  END;
  DECLARE
    succ_with_comp_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(succ_with_comp_error, -24344);
  BEGIN
    append_log_content(pi_text => 'CREATE ALL INV VIEWS');
    Nm3inv_View.create_all_inv_views;
    EXCEPTION
    WHEN succ_with_comp_error THEN
      NULL; -- dont report success with compilation error
  END;
  DECLARE
    succ_with_comp_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(succ_with_comp_error, -24344);
  BEGIN
    append_log_content(pi_text => 'CREATE ALL INV ON ROUTE VIEW');
    Nm3inv_View.create_all_inv_on_route_view;
    EXCEPTION
    WHEN succ_with_comp_error THEN
      NULL; -- dont report success with compilation error
  END;
  BEGIN
    append_log_content(pi_text => 'REBUILD ALL SEQUENCES');
    Nm3ddl.rebuild_all_sequences;
  END;
--
 append_proc_end_to_log;
--
END tidy_up_following_migration;
--
-----------------------------------------------------------------------------
--igrate_cor_doc_gis
PROCEDURE migrate_cor_doc_gis(pi_log_file_location   IN VARCHAR2
		  					 ,pi_v2_higowner 		 IN VARCHAR2
                             ,pi_with_debug          IN BOOLEAN) IS
BEGIN
  initialise(pi_log_file_location  => pi_log_file_location
            ,pi_log_file_name      => 'nm2_nm3_migration_part1_'||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.log'
            ,pi_first_stage        => TRUE
            ,pi_with_debug         => pi_with_debug);
  g_issue_commits := 'N';
 process_admin_units(pi_v2_higowner);
  oracle_users_roles_privs;
  process_hig_data;
 process_doc_data;
--  process_gis_data;  --now do this after the network has been migrated and the spatial table created
  do_commit;
  append_mig_end_to_log;
  close_log;
EXCEPTION
    WHEN OTHERS THEN
        append_log_content(pi_text => SQLERRM);
        do_rollback;
        close_log;
        RAISE_APPLICATION_ERROR(-20001,SQLERRM);
END migrate_cor_doc_gis;
---
PROCEDURE migrate_doc_assocs(pi_log_file_location   IN VARCHAR2
                             ,pi_with_debug          IN BOOLEAN) IS

l_das_type DOC_ASSOCS.das_table_name%TYPE;
l_das_network BOOLEAN;
l_das_asset BOOLEAN;
l_start_date DATE;
l_end_Date DATE;
l_context_date_on_entry DATE := Nm3user.get_effective_date;

l_das_Rec_id doc_Assocs.das_Rec_id%type;

l_new_ne_id  number;

BEGIN
  initialise(pi_log_file_location  => pi_log_file_location
            ,pi_log_file_name      => 'nm2_nm3_migration_part3_'||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.log'
            ,pi_first_stage        => TRUE
            ,pi_with_debug         => pi_with_debug);
  g_issue_commits := 'N';


  --need to do this AFTER the network and Assets have been migrated.
  append_log_content(pi_text => 'DOC_ASSOCS');
  --need to do this at the appropriate effective date due to triggers on doc_assocs

  IF NOT Nm3ddl.does_object_exist('IIT_V2_ITEM_ID','INDEX') THEN
    EXECUTE IMMEDIATE 'CREATE INDEX iit_v2_item_id ON nm_inv_items_all(iit_num_attrib115)';
  END IF;



  FOR c_das_type IN
    (SELECT DISTINCT das_table_name FROM v2_doc_Assocs) LOOP
    l_das_network:=Doc.das_against_network (pi_das_table_name => c_das_type.das_table_name);
    l_das_asset  :=Doc.das_against_asset   (pi_das_table_name => c_das_type.das_table_name);
	FOR c1rec IN
      (SELECT
       das_table_name
       ,das_rec_id
       ,das_doc_id
       FROM v2_doc_assocs v2
	   WHERE das_table_name=c_das_type.das_table_name
       AND NOT EXISTS (
                  SELECT 'record already exists'
                  FROM   DOC_ASSOCS v3
                  WHERE  v3.das_table_name= v2.das_table_name
                  AND    v3.das_rec_id= v2.das_rec_id
                  AND    v3.das_doc_id= v2.das_doc_id)
	   ) LOOP
      BEGIN
        l_das_rec_id:=c1rec.das_rec_id;

	    l_start_Date:=TO_DATE('01-JAN-1670','DD-MON-YYYY');
		l_end_date:=TO_DATE('31-dec-9999','DD-MON-YYYY');
  	    IF l_das_network THEN
        l_new_ne_id := get_new_ne_id( c1rec.das_rec_id);
	      SELECT ne_start_Date, ne_end_Date, ne_id
		  INTO l_start_date,l_end_Date, l_das_rec_id
		  FROM NM_ELEMENTS_ALL
		  WHERE ne_id=l_new_ne_id;
          Nm3user.set_effective_date(l_start_date);
	    ELSIF l_das_asset THEN
	      SELECT iit_ne_id,iit_start_Date,iit_end_Date
	      INTO l_das_rec_id,l_start_Date, l_end_date
		  FROM NM_INV_ITEMS_ALL
		  WHERE iit_num_attrib115=c1rec.das_rec_id;
          Nm3user.set_effective_date(l_start_date);
	    ELSE
          Nm3user.set_effective_date(l_context_date_on_entry);
        END IF;
        IF l_start_Date!=NVL(l_end_Date,TO_DATE('31-dec-9999','DD-MON-YYYY')) THEN
          INSERT INTO
          DOC_ASSOCS
          (
          das_table_name
          ,das_rec_id
          ,das_doc_id
          )
          VALUES
          (c1rec.das_table_name
          ,l_das_rec_id
          ,c1rec.das_doc_id);
		ELSE
		  append_log_content(pi_text => 'Not migrating '||c1rec.das_table_name||' REC_ID '||c1rec.das_rec_id||' DOC_ID '||c1rec.das_doc_id||' as start date matches end date '||l_start_date);
		END IF;
      EXCEPTION
	  when dup_val_on_index then
	    if l_das_rec_id!=c1rec.das_Rec_id then
		  null; --this is invnetory and has the id changed - ok to attempt to load more than once
		else
      append_log_content(pi_text => l_das_rec_id);
		  raise;
		end if;

	  WHEN NO_DATA_FOUND THEN
        --asset/netowrk has not been moigrated - cant find the start date
		--dont migrate the doc assoc
		  append_log_content(pi_text => 'Not migrating '||c1rec.das_table_name||' REC_ID '||c1rec.das_rec_id||' DOC_ID '||c1rec.das_doc_id||' as item not found');
     when others then append_log_content(pi_text => l_das_rec_id);
     raise;
	  END;
	END LOOP;
  END LOOP;

  do_commit;
  append_mig_end_to_log;
  close_log;
EXCEPTION
    WHEN OTHERS THEN
        append_log_content(pi_text => SQLERRM);
        do_rollback;
        close_log;
        RAISE_APPLICATION_ERROR(-20001,SQLERRM);
END migrate_doc_Assocs;
--
--
-----------------------------------------------------------------------------
--
PROCEDURE migrate_network_and_inventory (pi_log_file_location IN VARCHAR2
                                        ,pi_netw_inv_type     IN VARCHAR2 DEFAULT 'NETW'
                                        ,pi_step              IN NUMBER
                                        ,pi_with_debug        IN BOOLEAN
                                        ,pi_ukp_only          in varchar2 default 'A'
                                        ,pi_open_only         in varchar2 default 'N'

                                        ) IS
l_sqlerrm all_errors.text%TYPE;
BEGIN
    initialise(pi_log_file_location  => pi_log_file_location
              ,pi_log_file_name      => 'nm2_nm3_migration_part2_step'||pi_step||' '||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.LOG'
              ,pi_with_debug         => pi_with_debug);
    CASE pi_step
    WHEN 1 THEN
      create_network_metamodel;
    WHEN 2 THEN
      create_inventory_metamodel(pi_netw_inv_type => pi_netw_inv_type);
    WHEN 3 THEN
      create_network_metamodel_inv(pi_netw_inv_type => pi_netw_inv_type);
    WHEN 4 THEN
      migrate_links;
    WHEN 5 THEN
      migrate_network;
    WHEN 6 THEN
      migrate_link_membs;
    WHEN 7 THEN
      migrate_other_groups;
    WHEN 8 THEN
      migrate_inventory(pi_ukp_only,pi_open_only);
    WHEN 9 THEN
      migrate_network_inv(pi_netw_inv_type   => pi_netw_inv_type);
      tidy_up_following_migration;
    END CASE;
    append_mig_end_to_log;
    close_log;
EXCEPTION
   WHEN OTHERS THEN
       l_sqlerrm := SQLERRM;
       append_log_content(pi_text => l_sqlerrm);
       do_rollback;
       close_log;
       RAISE_APPLICATION_ERROR(-20001, l_sqlerrm);
END migrate_network_and_inventory;
--
-----------------------------------------------------------------------------
--

--SPATIAL
/*
FUNCTION remove_null_ords ( p_geom IN mdsys.sdo_geometry )
RETURN mdsys.sdo_geometry;

FUNCTION Make_Single_Part( p_geom IN mdsys.sdo_geometry, p_diminfo IN mdsys.sdo_dim_array )
RETURN mdsys.sdo_geometry;

FUNCTION Ignore_Measure( p_geom mdsys.sdo_geometry )
RETURN mdsys.sdo_geometry ;

FUNCTION Get_Table_Diminfo( p_table IN VARCHAR2, p_column IN VARCHAR2 DEFAULT NULL )
RETURN mdsys.sdo_dim_array;


FUNCTION Rescale_Geometry ( p_geom IN mdsys.sdo_geometry, p_diminfo IN mdsys.sdo_dim_array,p_length IN NUMBER )
RETURN mdsys.sdo_geometry;

FUNCTION Remove_Redundant_Pts( p_geom IN mdsys.sdo_geometry )
RETURN mdsys.sdo_geometry;

FUNCTION Get_No_Parts ( p_geom IN mdsys.sdo_geometry )
RETURN NUMBER ;

PROCEDURE Spatial_data_fixes;
*/

PROCEDURE Fix_Route_Theme;

FUNCTION Compare_Pt ( p_geom1 mdsys.sdo_geometry, p_geom2 mdsys.sdo_geometry, tol IN NUMBER )
RETURN VARCHAR2;


FUNCTION Compare_Pt ( p_geom1 mdsys.sdo_geometry, p_geom2 mdsys.sdo_geometry, tol IN NUMBER ) RETURN VARCHAR2 IS
retval VARCHAR2(10) := 'FALSE';
l_tol NUMBER := 0.5;
BEGIN
  Nm_Debug.DEBUG( 'compare '||TO_CHAR( p_geom1.sdo_point.x )||' with '||TO_CHAR( p_geom2.sdo_point.x )||' and  '||
                              TO_CHAR( p_geom1.sdo_point.y )||' with '||TO_CHAR( p_geom2.sdo_point.y ));
  IF ABS( p_geom1.sdo_point.x - p_geom2.sdo_point.x ) <= l_tol  AND
     ABS( p_geom1.sdo_point.y - p_geom2.sdo_point.y ) <= l_tol THEN

     retval := 'TRUE';
  END IF;
  RETURN retval;
END;



FUNCTION Get_Parts ( p_shape IN mdsys.sdo_geometry )
RETURN nm_geom_array;

FUNCTION Get_Parts ( p_shape IN mdsys.sdo_geometry ) RETURN nm_geom_array IS
retval nm_geom_array := Nm3array.INIT_NM_GEOM_ARRAY;
lp NUMBER;
BEGIN
  lp := Nm3sdo.get_no_parts( p_shape )/3;
  Nm_Debug.DEBUG('No of parts = '||TO_CHAR(lp));
  IF lp = 1 THEN
    retval.nga(1).ng_ne_id := 1;
    retval.nga(1).ng_geometry :=  p_shape;
  ELSIF lp < 1 THEN
    RAISE_APPLICATION_ERROR( -20001, 'Fault');
  ELSE
    Nm_Debug.DEBUG('Setting first bit');
    retval.nga(1).ng_ne_id := 1;
    retval.nga(1).ng_geometry :=  sdo_util.EXTRACT( p_shape, 1, 1);
    Nm_Debug.DEBUG('Last = '||TO_CHAR(retval.nga.LAST));
    FOR i IN 2..lp LOOP
      Nm_Debug.DEBUG('Setting bit '||TO_CHAR(i));
      retval.nga.EXTEND;
      Nm_Debug.DEBUG('Extend - Last = '||TO_CHAR(retval.nga.LAST));
      retval.nga(i) := nm_geom(i, sdo_util.EXTRACT( p_shape, i, 1));

    END LOOP;
  END IF;

  RETURN retval;
END;





FUNCTION Make_Single_Part3( p_geom IN mdsys.sdo_geometry, p_diminfo IN mdsys.sdo_dim_array )
RETURN mdsys.sdo_geometry;



FUNCTION Make_Single_Part3( p_geom IN mdsys.sdo_geometry, p_diminfo IN mdsys.sdo_dim_array ) RETURN mdsys.sdo_geometry IS

lp NUMBER;
ld NUMBER;
lnd NUMBER;
l_tol NUMBER := p_diminfo(1).sdo_tolerance;

l_geom  mdsys.sdo_geometry;

retval   mdsys.sdo_geometry;

lc      NUMBER := 0;
l_ga    nm_geom_array;

l_used  int_array := Nm3array.INIT_INT_ARRAY;

FUNCTION used ( l_ia IN OUT NOCOPY int_array, l_i IN INTEGER  ) RETURN BOOLEAN IS
l_dummy INTEGER;
BEGIN
  SELECT 1 INTO l_dummy FROM TABLE ( l_ia.ia ) a
  WHERE COLUMN_VALUE = l_i;
  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN FALSE;
END;

BEGIN

  Nm_Debug.debug_on;

  l_ga := Get_Parts( p_geom );

  lp := l_ga.nga.LAST;

  IF lp = 1 THEN
    RETURN p_geom;
  END IF;

  ld := p_geom.get_dims;

  retval := l_ga.nga(1).ng_geometry;

  l_used.ia(1) := 1;

  Nm_Debug.DEBUG('Set the first part');

  WHILE l_used.ia.LAST < lp LOOP

    IF lc > 20 THEN
      EXIT;
    END IF;

    lc := lc + 1;

    FOR i IN 2..lp LOOP

      IF NOT used( l_used, i ) THEN

        Nm_Debug.DEBUG('Part '||TO_CHAR(i)||' is unused');

        IF Compare_Pt( Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_end_pt( retval )), Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_start_pt( l_ga.nga(i).ng_geometry)) , l_tol ) = 'TRUE' THEN

          Nm_Debug.DEBUG('Part '||TO_CHAR(i)||' is connected');

          Nm3sdo.add_segments(retval, l_ga.nga(i).ng_geometry, p_diminfo, TRUE );
          l_used.ia.EXTEND;
          l_used.ia(l_used.ia.LAST) := i;
          EXIT;

        ELSIF Compare_Pt( Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_end_pt( retval )), Nm3sdo.get_2d_pt(sdo_lrs.geom_segment_end_pt( l_ga.nga(i).ng_geometry)), l_tol ) = 'TRUE' THEN

          Nm_Debug.DEBUG('Part '||TO_CHAR(i)||' is connected after reverse');

          l_geom := Nm3sdo.reverse_geometry(l_ga.nga(i).ng_geometry );
          Nm3sdo.add_segments(retval, l_geom, p_diminfo, TRUE);
          l_used.ia.EXTEND;
          l_used.ia(l_used.ia.LAST) := i;
          EXIT;

        ELSE

          Nm_Debug.DEBUG( 'No connection' );

        END IF;

      END IF;

    END LOOP;

  END LOOP;

  RETURN retval;

END;

PROCEDURE do_spatial_migration(pi_table_name IN user_tables.table_name%TYPE
                              ,pi_id_col_name IN user_tab_columns.COLUMN_NAME%TYPE
                              ,pi_shape_col_name IN user_tab_columns.COLUMN_NAME%TYPE
							  ,pi_log_file_location   IN VARCHAR2
                              ,pi_with_debug          IN BOOLEAN DEFAULT FALSE) IS
  L_sql VARCHAR2(2000);
  l_number NUMBER;
  l_unique NM_ELEMENTS_ALL.ne_unique%TYPE;
  l_layer NM_THEMES_ALL.nth_theme_id%TYPE;
  l_ne_id NM_ELEMENTS_ALL.ne_id%TYPE;

  l_length NUMBER;
  l_shape_length NUMBER;
  l_geom 	  mdsys.sdo_geometry;
  l_diminfo  mdsys.sdo_dim_array;

  l_base_srid NUMBER;
  p_x1 NUMBER;
  p_y1 NUMBER;
  p_x2 NUMBER;
  p_y2 NUMBER;
  l_base_diminfo mdsys.sdo_dim_array;
BEGIN

  initialise(pi_log_file_location  => pi_log_file_location
            ,pi_log_file_name      => 'nm2_nm3_migration_part4_'||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.log'
            ,pi_first_stage        => FALSE
            ,pi_with_debug         => pi_with_debug);
  g_issue_commits := 'N';

  SELECT COUNT(*)
  INTO l_number
  FROM user_tab_columns
  WHERE table_name=pi_table_name
  AND COLUMN_name=pi_id_col_name;

  IF l_number=0 THEN
    RAISE_APPLICATION_ERROR(-20001,'Spatial Table '||pi_table_name||' with feature column '||pi_id_col_name||' not found');
  END IF;

  SELECT COUNT(*)
  INTO l_number
  FROM user_tab_columns
  WHERE table_name=pi_table_name
  AND COLUMN_name=pi_shape_col_name;

  IF l_number=0 THEN
    RAISE_APPLICATION_ERROR(-20001,'Spatial Table '||pi_table_name||' with spatial column '||pi_shape_col_name||' not found');
  END IF;

  process_gis_data;  --now DO this AFTER THE NETWORK has been migrated AND THE spatial TABLE created

  SELECT COUNT(*)
  INTO l_number
  FROM NM_THEMES_ALL
  WHERE nth_feature_table=pi_table_name
  AND NTH_FEATURE_PK_COLUMN=pi_id_col_name;

  IF l_number=0 THEN
    RAISE_APPLICATION_ERROR(-20001,'GIS Themes entry for '||pi_table_name||' with feature column '||pi_id_col_name||' not found');
  ELSIF l_number>1 THEN
    RAISE_APPLICATION_ERROR(-20001,'Duplicate GIS Themes entry for '||pi_table_name);
  END IF;

--   append_log_content(pi_text => 'l number'||l_number);

  append_log_content(pi_text => 'Spatial Migration');

  append_log_content(pi_text => 'Populating MIGRATION_NET_MAP from '||pi_table_name);

  DELETE FROM user_sdo_geom_metadata
  WHERE table_name='MIGRATION_NET_MAP';

  --DELETE FROM MIGRATION_NET_MAP;
  l_sql:='truncate table migration_net_map';
  EXECUTE IMMEDIATE l_sql;
  l_sql:='truncate table migration_net_map_mp';
  EXECUTE IMMEDIATE l_sql;

  --Truncate Below Removed At CH's request.
  --l_sql:='truncate table migration_net_map_rev';
  --EXECUTE IMMEDIATE l_sql;

  L_sql:='insert into MIGRATION_NET_MAP SELECT nm2_nm3_migration.get_new_ne_id('||pi_id_col_name||') mig_ne_id ,'||pi_shape_col_name||' shape FROM '||pi_table_name;



  EXECUTE IMMEDIATE l_sql;

  --calc diminfo using default tolerance of 0.005
  l_diminfo := Nm3sdo.calculate_table_diminfo('MIGRATION_NET_MAP','SHAPE');


  INSERT INTO user_Sdo_geom_metadata
  SELECT 'MIGRATION_NET_MAP', 'SHAPE',l_diminfo,srid
  FROM user_sdo_geom_metadata
  WHERE table_name=pi_table_name;


  --now update the route theme so we can run all the checks against that.
append_log_content(pi_text => 'update theme');
  UPDATE NM_THEMES_ALL
  SET nth_feature_table='MIGRATION_NET_MAP'
  ,NTH_FEATURE_PK_COLUMN='MIG_NE_ID'
  ,nth_feature_fk_column='MIG_NE_ID'
  ,NTH_FEATURE_SHAPE_COLUMN='SHAPE'
  WHERE nth_feature_table=pi_table_name
  AND NTH_FEATURE_PK_COLUMN=pi_id_col_name;



  SELECT nth_theme_id
  INTO l_layer
  FROM NM_THEMES_ALL
  WHERE nth_feature_table='MIGRATION_NET_MAP';

  DELETE FROM MIGRATION_NET_MAP_MP;

  --now try and repair any bad data
append_log_content(pi_text =>' inseert into MIGRATION_NET_MAP_MP');
  INSERT INTO MIGRATION_NET_MAP_MP
  (MIG_NE_ID, SHAPE)
  SELECT  MIG_NE_ID, SHAPE
  FROM MIGRATION_NET_MAP
  WHERE Nm3sdo.get_no_parts(shape) > 3;


  FOR irec IN
    ( SELECT A.mig_ne_id,  A.ROWID
      FROM MIGRATION_NET_MAP A
      WHERE EXISTS
      (SELECT 'x' FROM NM_ELEMENTS_ALL
      WHERE ne_id=mig_ne_id)) LOOP
	BEGIN
	  SELECT shape, ne_length,sdo_lrs.geom_segment_end_measure( shape, l_diminfo ),ne_unique,ne_id
	  INTO l_geom,l_length,l_shape_length,l_unique, l_ne_id
	  FROM MIGRATION_NET_MAP,NM_ELEMENTS_ALL
	  WHERE mig_ne_id=irec.mig_ne_id
	  AND mig_ne_id=ne_id;

      IF l_shape_length!=l_length THEN
        append_log_content(pi_text => '  Shape Length (was '||l_shape_length||') will be updated to Element Length '||l_length||' for '||l_unique||'('||irec.mig_ne_id||')');
      END IF;

	  l_geom:=Nm3sdo.remove_redundant_pts(p_layer =>l_layer,p_geom =>l_geom);

      IF Nm3sdo.get_no_parts(l_geom) > 3 THEN
	    l_geom:=Make_Single_Part3( l_geom, l_diminfo);
	  END IF;

	  l_geom:=Nm3sdo.rescale_geometry(p_layer =>l_layer
                           			 ,p_ne_id =>l_ne_id
   					                 ,p_geom  =>l_geom);

--   	  l_geom:=Nm3sdo.ignore_measure(l_geom);



	  DELETE FROM MIGRATION_NET_MAP
	  WHERE mig_ne_id=irec.mig_ne_id;

      INSERT INTO MIGRATION_NET_MAP
      VALUES
	  (irec.mig_ne_id
  	  ,l_geom);


    EXCEPTION
 	  WHEN OTHERS THEN
      Nm_Debug.DEBUG(irec.mig_ne_id);
      append_log_content(pi_text => irec.mig_ne_id);
      RAISE;
    END;
  END LOOP;
--report all Mulitparts
  append_log_content(pi_text => 'MULTIPART RECORDS FOUND');
  l_number:=0;
  FOR c1rec IN
    (SELECT ne_unique,mig_ne_id
	FROM MIGRATION_NET_MAP_MP
	,NM_ELEMENTS_ALL
	WHERE ne_id=mig_ne_id) LOOP
    l_number:=l_number+1;
    append_log_content(pi_text => c1rec.ne_unique||'('||c1rec.mig_ne_id||')');
  END LOOP;
  IF l_number=0 THEN
    append_log_content(pi_text => '  (None Found)');
  END IF;


--report mulitparts that couldnt be fixed.
  append_log_content(pi_text => 'MULTIPART RECORDS THAT COULDNT BE REPAIRED - INVESTIGATE');
  l_number:=0;
  FOR c1rec IN
    (SELECT ne_unique,mig_ne_id
	FROM MIGRATION_NET_MAP
	,NM_ELEMENTS_ALL
	WHERE Nm3sdo.get_no_parts(shape) > 3
	AND ne_id=mig_ne_id) LOOP
    l_number:=l_number+1;
    append_log_content(pi_text => c1rec.ne_unique||'('||c1rec.mig_ne_id||')');
  END LOOP;
  IF l_number=0 THEN
    append_log_content(pi_text => '  (None Found)');
  END IF;

  --now try and do nodes
  append_log_content(pi_text => 'Populating NM_POINT_LOCATIONS');

  DELETE FROM user_sdo_geom_metadata
  WHERE table_name='NM_POINT_LOCATIONS';

  SELECT MIN( np_grid_east), MAX(np_grid_east)
       , MIN(np_grid_north), MAX(np_grid_north)
  INTO  p_x1, p_x2, p_y1, p_y2
  FROM NM_POINTS;

  l_base_diminfo := mdsys.sdo_dim_array(
                         mdsys.sdo_dim_element('X', p_x1, p_x2, .005),
                         mdsys.sdo_dim_element('Y', p_y1, p_y2, .005));



  SELECT srid
  INTO l_base_srid
  FROM useR_sdo_geom_metadata
  WHERE table_name='MIGRATION_NET_MAP';




  append_log_content(pi_text => '  Dropping Index');

  BEGIN
    SELECT 'drop index '||index_name
    INTO l_sql
    FROM useR_indexes
    WHERE table_name='NM_POINT_LOCATIONS'
    AND index_type='DOMAIN';
    EXECUTE IMMEDIATE (l_sql);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;

  append_log_content(pi_text => '  Inserting Geo metadata');

  INSERT INTO useR_sdo_geom_metadata
  (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID)
  VALUES
  ('NM_POINT_LOCATIONS'
  ,'NPL_LOCATION'
  , l_base_diminfo
  , l_base_srid);

  l_sql:='CREATE index NPL_SPIDX ON NM_POINT_LOCATIONS(NPL_LOCATION) INDEXTYPE IS MDSYS.SPATIAL_INDEX';

  append_log_content(pi_text => '  Re-creating Index');

   EXECUTE IMMEDIATE (l_sql);

  append_log_content(pi_text => '  Deleting Records');

  DELETE FROM NM_POINT_LOCATIONS;

  append_log_content(pi_text => '  Creating Records');

  BEGIN
     INSERT INTO NM_POINT_LOCATIONS ( npl_id, npl_location )
     SELECT np_id, mdsys.sdo_geometry(2001,l_base_srid,
     mdsys.sdo_point_type(np_grid_east, np_grid_north, NULL),NULL, NULL)
     FROM NM_POINTS
    WHERE np_grid_east IS NOT NULL
    AND   np_grid_north IS NOT NULL;
  END;


  append_log_content(pi_text => 'Checking Node Locations >2m from terminus');


  l_number:=0;
  FOR c1rec IN
    (SELECT ne_unique, DECODE(nnu_node_type,'E','End','S','Start',nnu_node_type) node_type, no_node_name, ne_length,mig_ne_id,
     sdo_geom.sdo_distance( npl_location, Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'S', sdo_lrs.geom_segment_start_pt(s.shape), 'E', sdo_lrs.geom_segment_end_pt(s.shape) )), .005) distance
     FROM nm_elements e, NM_POINT_LOCATIONS, nm_node_usages, nm_nodes, MIGRATION_NET_MAP s
     WHERE s.mig_ne_id = nnu_ne_id
     AND nnu_no_node_id = no_node_id
     AND no_np_id = npl_id
     AND s.mig_ne_id = e.ne_id
     AND sdo_filter( npl_location,
     sdo_geom.sdo_buffer( Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'S', sdo_lrs.geom_segment_start_pt(s.shape), 'E', sdo_lrs.geom_segment_end_pt(s.shape) )), 2, .005),
     'querytype=window') != 'TRUE'
     AND sdo_filter( npl_location,
     sdo_geom.sdo_buffer( Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'E', sdo_lrs.geom_segment_start_pt(s.shape), 'S', sdo_lrs.geom_segment_end_pt(s.shape) )), 2, .005),
     'querytype=window') = 'TRUE') LOOP
    append_log_content(pi_text => c1rec.ne_unique||'('||c1rec.mig_ne_id||'), length '||c1rec.ne_length||' '||c1rec.node_type||' Node('||c1rec.no_node_name||' is '||c1rec.distance);
  END LOOP;
  IF l_number=0 THEN
    append_log_content(pi_text => '  (None Found)');
  END IF;


  /*
  --find records that might need reversing...
  append_log_content(pi_text => 'Checking Spatial Direction against Node Locations');

  INSERT INTO MIGRATION_NET_MAP_REV
  (MIG_NE_ID, NNU_NODE_TYPE, NNU_NO_NODE_ID, NE_LENGTH, DISTANCE,SHAPE)
  SELECT s.mig_ne_id, nnu_node_type, nnu_no_node_id, ne_length,
       sdo_geom.sdo_distance( npl_location, Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'S', sdo_lrs.geom_segment_start_pt(s.shape), 'E', sdo_lrs.geom_segment_end_pt(s.shape) )), .005) distance
	   ,shape
    FROM nm_elements e, NM_POINT_LOCATIONS, nm_node_usages, nm_nodes, MIGRATION_NET_MAP s
    WHERE s.mig_ne_id = nnu_ne_id
    AND   nnu_no_node_id = no_node_id
    AND   no_np_id = npl_id
    AND   s.mig_ne_id = e.ne_id
    AND   sdo_filter( npl_location,
                 sdo_geom.sdo_buffer(  Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'S', sdo_lrs.geom_segment_start_pt(s.shape), 'E', sdo_lrs.geom_segment_end_pt(s.shape) )), 2, .005),
				  'querytype=window') != 'TRUE'
    AND   sdo_filter( npl_location,
                 sdo_geom.sdo_buffer(  Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'E', sdo_lrs.geom_segment_start_pt(s.shape), 'S', sdo_lrs.geom_segment_end_pt(s.shape) )), 2, .005),
				  'querytype=window') = 'TRUE';

	--perform the reversal
  DECLARE
    CURSOR c1 IS
      SELECT DISTINCT mig_ne_id FROM MIGRATION_NET_MAP_REV;
   BEGIN
    FOR irec IN c1 LOOP
      UPDATE MIGRATION_NET_MAP s
      SET s.SHAPE = Nm3sdo.reverse_geometry(s.shape )
      WHERE s.mig_NE_ID = irec.mig_ne_id;
    END LOOP;
  END;

 --report on issues
   append_log_content(pi_text => 'SPATIAL DATA REQUIRING REVERSAL');
  l_number:=0;
  FOR c1rec IN
    (SELECT ne_unique,mig_ne_id, DECODE(nnu_node_type,'E','End','S','Start',nnu_node_type) node_type
	FROM MIGRATION_NET_MAP_REV
	,NM_ELEMENTS_ALL
	WHERE ne_id=mig_ne_id) LOOP
    l_number:=l_number+1;
    append_log_content(pi_text => c1rec.ne_unique||'('||c1rec.mig_ne_id||') '||c1rec.node_type||' Node');
  END LOOP;
  IF l_number=0 THEN
    append_log_content(pi_text => '  (None Found)');
  END IF;

 --report on non resolved oned
 append_log_content(pi_text => 'SPATIAL DATA REQUIRING REVERSAL THAT COULDNT BE REPAIRED - INVESTIGATE');
  l_number:=0;
  FOR c1rec IN
    ( SELECT ne_unique,mig_ne_id, DECODE(nnu_node_type,'E','End','S','Start',nnu_node_type) node_type
           FROM nm_elements e, NM_POINT_LOCATIONS, nm_node_usages, nm_nodes, MIGRATION_NET_MAP s
    WHERE s.mig_ne_id = nnu_ne_id
    AND   nnu_no_node_id = no_node_id
    AND   no_np_id = npl_id
    AND   s.mig_ne_id = e.ne_id
    AND   sdo_filter( npl_location,
                 sdo_geom.sdo_buffer(  Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'S', sdo_lrs.geom_segment_start_pt(s.shape), 'E', sdo_lrs.geom_segment_end_pt(s.shape) )), 2, .005),
				  'querytype=window') != 'TRUE'
    AND   sdo_filter( npl_location,
                 sdo_geom.sdo_buffer(  Nm3sdo.get_2d_pt(DECODE( nnu_node_type, 'E', sdo_lrs.geom_segment_start_pt(s.shape), 'S', sdo_lrs.geom_segment_end_pt(s.shape) )), 2, .005),
				  'querytype=window') = 'TRUE') LOOP
    l_number:=l_number+1;
    append_log_content(pi_text => c1rec.ne_unique||'('||c1rec.mig_ne_id||')');
  END LOOP;
  IF l_number=0 THEN
    append_log_content(pi_text => '  (None Found)');
  END IF;

*/

  Fix_Route_Theme;



  do_commit;
  append_mig_end_to_log;
  close_log;

--EXCEPTION WHEN OTHERS THEN
--        append_log_content(pi_text => SQLERRM);
--        do_rollback;
--        close_log;
--        RAISE_APPLICATION_ERROR(-20001,SQLERRM);
END do_spatial_migration;


--
---------------------------------------------------------------------
--
/*FUNCTION remove_null_ords ( p_geom IN mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS
l_ords mdsys.sdo_ordinate_array := mdsys.sdo_ordinate_array(NULL);
ord_count INTEGER := 0;
BEGIN
  IF p_geom.sdo_elem_info.LAST > 3 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Cannot operate on multi-parts');
  END IF;

  FOR i IN 1..p_geom.sdo_ordinates.LAST LOOP
    IF p_geom.sdo_ordinates(i) IS NOT NULL THEN
      ord_count := ord_count + 1;
      IF ord_count = 1 THEN
 	    l_ords(1)  := p_geom.sdo_ordinates(i);
      ELSE
	    l_ords.EXTEND;
	    l_ords( ord_count ) := p_geom.sdo_ordinates(i);
	  END IF;
	END IF;
  END LOOP;

  RETURN mdsys.sdo_geometry( p_geom.sdo_gtype, p_geom.sdo_srid, p_geom.sdo_point, p_geom.sdo_elem_info, l_ords );

END remove_null_ords;

--
---------------------------------------------------------------------
--

FUNCTION Make_Single_Part( p_geom IN mdsys.sdo_geometry, p_diminfo IN mdsys.sdo_dim_array )
RETURN mdsys.sdo_geometry IS

lp NUMBER;
ld NUMBER;
lnd NUMBER;

l_geom2  mdsys.sdo_geometry;
retval   mdsys.sdo_geometry;

BEGIN
  lp := Get_No_Parts(p_geom);
  ld := p_geom.get_dims;
  retval := p_geom;
  FOR i IN 1..(lp/3 - 1) LOOP
    Nm_Debug.DEBUG('There are '||TO_CHAR(lp/3)||' parts');
    IF i = 1 THEN
	  retval := sdo_util.EXTRACT( p_geom, 1);
	END IF;
    l_geom2 :=  sdo_util.EXTRACT( p_geom, i+1);
	lnd := retval.sdo_ordinates.LAST;
	FOR j IN 1..ld LOOP
	  Nm_Debug.DEBUG('Compare '||TO_CHAR(l_geom2.sdo_ordinates(j))||' with '||TO_CHAR( retval.sdo_ordinates( lnd - ld + j)));
	  IF ABS(l_geom2.sdo_ordinates(j) - retval.sdo_ordinates( lnd - ld + j)) > p_diminfo(ld).sdo_tolerance THEN
         Nm_Debug.DEBUG('Changes');
 	     RAISE_APPLICATION_ERROR(-20001, 'Not a single part');
	  END IF;
	END LOOP;
    retval := sdo_lrs.concatenate_geom_segments( retval, p_diminfo, l_geom2, p_diminfo );
  END LOOP;

  RETURN retval;
END Make_Single_Part;

--
---------------------------------------------------------------------
--


FUNCTION Ignore_Measure( p_geom mdsys.sdo_geometry )
RETURN mdsys.sdo_geometry IS
BEGIN
  IF p_geom.sdo_gtype = 3302 THEN
    RETURN mdsys.sdo_geometry(3002, p_geom.sdo_srid, p_geom.sdo_point, p_geom.sdo_elem_info, p_geom.sdo_ordinates );
  ELSIF p_geom.sdo_gtype = 3301 THEN
    RETURN mdsys.sdo_geometry(3001, p_geom.sdo_srid, p_geom.sdo_point, p_geom.sdo_elem_info, p_geom.sdo_ordinates );
  ELSE
    RETURN p_geom;
  END IF;
END ignore_measure;

--
---------------------------------------------------------------------
--



FUNCTION Get_Table_Diminfo( p_table IN VARCHAR2, p_column IN VARCHAR2 DEFAULT NULL ) RETURN mdsys.sdo_dim_array IS
retval mdsys.sdo_dim_array;
CURSOR c1 ( c_table IN VARCHAR2,
            c_column IN VARCHAR2 ) IS
   SELECT diminfo
   FROM user_sdo_geom_metadata
   WHERE table_name = c_table
   AND NVL( c_column, 'A') = DECODE( c_column, NULL, 'A', column_name  );

BEGIN
  OPEN c1( p_table, p_column);
  FETCH c1 INTO retval;
  IF c1%NOTFOUND THEN
    retval := NULL;
    CLOSE c1;
      Hig.raise_ner(pi_appl                => Nm3type.c_hig
                    ,pi_id                 => 197
                    ,pi_sqlcode            => -20001
                    );
--	raise_application_error( -20001, 'SDO Metadata for layer  not found' );
  ELSE
    CLOSE c1;
  END IF;
  RETURN retval;
END;

--
---------------------------------------------------------------------
--
FUNCTION Rescale_Geometry ( p_geom IN mdsys.sdo_geometry, p_diminfo IN mdsys.sdo_dim_array,p_length IN NUMBER ) RETURN mdsys.sdo_geometry IS
l_geom mdsys.sdo_geometry := p_geom;
l_end  NUMBER;
BEGIN
  l_end:=NVL(p_length,sdo_lrs.geom_segment_end_measure( l_geom, p_diminfo ));
  sdo_lrs.redefine_geom_segment( l_geom, p_diminfo, 0, l_end );
  RETURN l_geom;
END;

--
---------------------------------------------------------------------
--


FUNCTION Remove_Redundant_Pts( p_geom IN mdsys.sdo_geometry ) RETURN mdsys.sdo_geometry IS
-- assumes 3D, single-part feature, based on pure geometry - no diminfo on which to base the interrogation of proximity - use the other procedure
-- if you know the layer.

retval mdsys.sdo_geometry := mdsys.sdo_geometry( 3002, p_geom.sdo_srid, p_geom.sdo_point,
                                    mdsys.sdo_elem_info_array(1,2,1),
                                    mdsys.sdo_ordinate_array(0)) ;
ret_count INTEGER;

r NUMBER;
r1 NUMBER;
r2 NUMBER;
r3 NUMBER;
r4 NUMBER;
r5 NUMBER;

BEGIN
  IF p_geom.sdo_ordinates.LAST > 3 THEN

    FOR ic IN 1..3 LOOP
      retval.sdo_ordinates(ic) := p_geom.sdo_ordinates(ic);
      retval.sdo_ordinates.EXTEND;
    END LOOP;

    ret_count := 3;

    FOR ic IN 4..p_geom.sdo_ordinates.LAST LOOP
      ret_count := ret_count + 1;

      IF ret_count <= retval.sdo_ordinates.LAST THEN
        retval.sdo_ordinates.EXTEND;
      END IF;

      retval.sdo_ordinates(ret_count) := p_geom.sdo_ordinates(ic);

      IF MOD( ic, 3 ) = 0 THEN
--use the tolerance
        r:=retval.sdo_ordinates( ret_count );
		r3:=retval.sdo_ordinates( ret_count - 3);

        r1:=retval.sdo_ordinates( ret_count );
		r4:=retval.sdo_ordinates( ret_count - 3);

        r2:=retval.sdo_ordinates( ret_count );
		r5:=retval.sdo_ordinates( ret_count - 3);


        IF ROUND(retval.sdo_ordinates( ret_count ),3)     = ROUND(retval.sdo_ordinates( ret_count - 3),3) AND
           ROUND(retval.sdo_ordinates( ret_count - 1 ),3) = ROUND(retval.sdo_ordinates( ret_count - 4),3) AND
           ROUND(retval.sdo_ordinates( ret_count - 2 ),3) = ROUND(retval.sdo_ordinates( ret_count - 5),3) THEN
--         redundant
          ret_count := ret_count - 3;
        ELSIF ROUND(ROUND(retval.sdo_ordinates( ret_count ),4) ,3)    = ROUND(ROUND(retval.sdo_ordinates( ret_count - 3),4),3) AND
           ROUND(ROUND(retval.sdo_ordinates( ret_count - 1 ),4),3) = ROUND(ROUND(retval.sdo_ordinates( ret_count - 4),4),3) AND
           ROUND(ROUND(retval.sdo_ordinates( ret_count - 2 ),4),3) = ROUND(ROUND(retval.sdo_ordinates( ret_count - 5),4),3) THEN
--         redundant
          ret_count := ret_count - 3;
        END IF;
      END IF;
    END LOOP;
    RETURN retval;
  ELSE
    RETURN p_geom;
  END IF;
END;


--
---------------------------------------------------------------------
--



FUNCTION Get_No_Parts ( p_geom IN mdsys.sdo_geometry ) RETURN NUMBER IS
BEGIN
  RETURN p_geom.sdo_elem_info.LAST;
END;



PROCEDURE Spatial_data_fixes IS

l_length NUMBER;
l_shape_length NUMBER;
l_geom 	  mdsys.sdo_geometry;
l_diminfo  mdsys.sdo_dim_array;
--l_shape mdsys.sdo_geometry;

 CURSOR c1 IS
/*  SELECT DISTINCT a.mig_ne_id,  a.ROWID
  FROM MIGRATION_NET_MAP a, BAD_MERGE_EX b
  WHERE a.ROWID = b.sdo_rowid;
*/
/*
  SELECT A.mig_ne_id,  A.ROWID
  FROM MIGRATION_NET_MAP A
  WHERE EXISTS
  (SELECT 'x' FROM NM_ELEMENTS_ALL
  WHERE ne_id=mig_ne_id);
--  WHERE mig_ne_id=20671532;

BEGIN



  l_diminfo := Get_Table_Diminfo( 'MIGRATION_NET_MAP','SHAPE');

--  DELETE FROM BAD_MERGE_EX;

--  sdo_geom.validate_layer_with_context( 'MIGRATION_NET_MAP', 'SHAPE', 'BAD_MERGE_EX' );

--  Nm_Debug.DEBUG('MULITPARTS');
     append_log_content(pi_text => 'Repairing Spatial Data');

  FOR irec IN c1 LOOP
    BEGIN
	  SELECT shape, ne_length,sdo_lrs.geom_segment_end_measure( shape, l_diminfo )
	  INTO l_geom,l_length,l_shape_length
	  FROM MIGRATION_NET_MAP,NM_ELEMENTS_ALL
	  WHERE mig_ne_id=irec.mig_ne_id
	  AND mig_ne_id=ne_id;
--      l_geom := Ignore_Measure(Make_Single_Part( l_shape, l_diminfo ));



      IF l_shape_length!=l_length THEN
        append_log_content(pi_text => '  Shape Length (was '||l_shape_length||') will be updated to Element Length '||l_length||' for element '||irec.mig_ne_id);

      END IF;
      l_geom:=Remove_Redundant_Pts(Rescale_Geometry( mdsys.sdo_geometry( 3002, NULL, NULL, mdsys.sdo_elem_info_array( 1,2,1), l_geom.sdo_ordinates ), l_diminfo,l_length) );
      l_geom:=remove_null_ords (l_geom);

      l_geom := Make_Single_Part( l_geom, l_diminfo );
      l_geom:=remove_null_ords (l_geom);

	  l_geom:=ignore_measure(l_geom);



	  DELETE FROM MIGRATION_NET_MAP
	  WHERE mig_ne_id=irec.mig_ne_id;

      INSERT INTO MIGRATION_NET_MAP
      VALUES
	  (irec.mig_ne_id
  	  ,l_geom);


    EXCEPTION
 	  WHEN OTHERS THEN
      Nm_Debug.DEBUG(irec.mig_ne_id);
      RAISE;
    END;
  END LOOP;



END Spatial_data_fixes;
*/
--

 PROCEDURE Fix_Route_Theme  IS

l_nth_row NM_THEMES_ALL%ROWTYPE;
l_nth_theme_id NM_THEMES_ALL.NTH_THEME_ID%TYPE;
l_nth_orig_id NM_THEMES_ALL.NTH_THEME_ID%TYPE;

l_tab_nt_type Nm3type.tab_varchar4;
l_sql VARCHAR2(2000);
BEGIN

  append_log_content(pi_text => 'Updating Themes');

  SELECT gt_theme_id+g_theme_max
  INTO l_nth_orig_id
  FROM v2_gis_themes_all
  WHERE gt_route_Theme='Y';

  SELECT DISTINCT ne_nt_type
  BULK COLLECT INTO l_tab_nt_type
  FROM MIGRATION_NET_MAP
  ,NM_ELEMENTS_ALL
  WHERE mig_ne_id=ne_id;
--
  IF l_tab_nt_type.COUNT=1 THEN
    append_log_content(pi_text => 'Creating Table '||USER||'_NET_MAP');

    BEGIN
	  l_sql:='DROP TABLE '||USER||'_NET_MAP';
      EXECUTE IMMEDIATE (l_sql);
	EXCEPTION WHEN OTHERS THEN
	  NULL;
	END;
    l_sql:='CREATE TABLE '||USER||'_NET_MAP AS SELECT mig_ne_id rse_he_id ,shape shape FROM MIGRATION_NET_MAP';
    EXECUTE IMMEDIATE (l_sql);

    DELETE FROM user_sdo_geom_metadata
	WHERE table_name=USER||'_NET_MAP';

	INSERT INTO useR_sdo_geom_metadata
	SELECT
	USER||'_NET_MAP'
	,column_name
	,diminfo
	,srid
	FROM useR_sdo_geom_metadata
	WHERE table_name='MIGRATION_NET_MAP';

	l_Sql:='CREATE UNIQUE INDEX '||SUBSTR(USER,1,1)||'nm_id ON '||USER||'_NET_MAP(RSE_HE_ID)';
    EXECUTE IMMEDIATE (l_sql);

    l_sql:='CREATE INDEX '||SUBSTR(USER,1,1)||'nm_spidx ON '||USER||'_NET_MAP(SHAPE) INDEXTYPE IS mdsys.spatial_index';
    EXECUTE IMMEDIATE (l_sql);

   UPDATE NM_THEMES_ALL
   SET nth_feature_table=USER||'_NET_MAP'
   ,NTH_FEATURE_PK_COLUMN='RSE_HE_ID'
   ,nth_feature_fk_column='RSE_HE_ID'
   ,nth_feature_shape_Column='SHAPE'
   WHERE nth_theme_id=l_nth_orig_id;




   --check nm_nw_themes
   DELETE FROM NM_NW_THEMES;

   INSERT INTO NM_NW_THEMES
   (NNTH_NLT_ID, NNTH_NTH_THEME_ID)
   SELECT nlt_id,l_nth_orig_id
   FROM NM_LINEAR_TYPES
   WHERE nlt_nt_type=l_tab_nt_type(1);

  ELSE
    FOR i IN 1..l_tab_nt_type.COUNT LOOP
      append_log_content(pi_text => 'Creating Table '||USER||'_NET_MAP_'||l_tab_nt_type(i));

      BEGIN
  	    l_sql:='DROP TABLE '||USER||'_NET_MAP_'||l_tab_nt_type(i);
        EXECUTE IMMEDIATE (l_sql);
	  EXCEPTION WHEN OTHERS THEN
	    NULL;
	  END;
      l_sql:='CREATE TABLE '||USER||'_NET_MAP_'||l_tab_nt_type(i)||' AS SELECT mig_ne_id rse_he_id ,shape shape FROM MIGRATION_NET_MAP';
      l_sql:=l_sql||',NM_ELEMENTS_ALL WHERE MIG_NE_ID=NE_ID AND NE_NT_TYPE='''||l_tab_nt_type(i)||'''';
      EXECUTE IMMEDIATE (l_sql);
      SELECT nth_theme_id_seq.NEXTVAL
	  INTO l_nth_Theme_id
	  FROM  dual;

	  SELECT *
	  INTO l_nth_row
	  FROM NM_THEMES_ALL
      WHERE nth_theme_id=l_nth_orig_id;


	  l_nth_row.nth_theme_name:=l_nth_row.nth_theme_name||'_'||l_tab_nt_type(i);
	  l_nth_row.nth_feature_table:=USER||'_NET_MAP_'||l_tab_nt_type(i);

	  l_nth_row.NTH_FEATURE_PK_COLUMN:='RSE_HE_ID';
	  l_nth_row.NTH_FEATURE_FK_COLUMN:='RSE_HE_ID';
	  l_nth_row.nth_feature_shape_Column:='SHAPE';


	  l_nth_row.nth_theme_id:=l_nth_theme_id;
	  Nm3ins.ins_nth(l_nth_row);

      INSERT INTO NM_THEME_FUNCTIONS_ALL
      (ntf_nth_theme_id
       ,ntf_hmo_module
       ,ntf_parameter
       ,ntf_menu_option
       ,ntf_seen_in_gis )
      SELECT
	  l_nth_theme_id
      ,NTF_HMO_MODULE
	  , NTF_PARAMETER
	  , NTF_MENU_OPTION
	  , NTF_SEEN_IN_GIS
	  FROM NM_THEME_FUNCTIONS_ALL
	  WHERE NTF_NTH_THEME_ID=l_nth_orig_id;

      INSERT INTO NM_THEME_ROLES
      (nthr_theme_id,
      nthr_role,
      nthr_mode )
      SELECT
      l_nth_theme_id
      ,nthr_role
      ,nthr_mode
	  FROM NM_THEME_ROLES
	  WHERE  nthr_theme_id=l_nth_orig_id;

      INSERT INTO NM_THEME_GTYPES
     (NTG_THEME_ID,
      NTG_GTYPE,
	  NTG_SEQ_NO,
  	  NTG_XML_URL)
      VALUES
	  (l_nth_theme_id
      ,'3002'
      ,1
      ,NULL);

      INSERT INTO NM_NW_THEMES
      (NNTH_NLT_ID, NNTH_NTH_THEME_ID)
      SELECT nlt_id,l_nth_theme_id
      FROM NM_LINEAR_TYPES
      WHERE nlt_nt_type =l_tab_nt_type(i);

	  DELETE FROM user_sdo_geom_metadata
	  WHERE table_name=USER||'_NET_MAP_'||l_tab_nt_type(i);

	  INSERT INTO useR_sdo_geom_metadata
	  SELECT
	  USER||'_NET_MAP_'||l_tab_nt_type(i)
	  ,column_name
	  ,diminfo
	  ,srid
	  FROM useR_sdo_geom_metadata
	  WHERE table_name='MIGRATION_NET_MAP';

   	  l_Sql:='CREATE UNIQUE INDEX '||SUBSTR(USER,1,1)||'nm'||l_tab_nt_type(i)||'_id ON '||USER||'_NET_MAP_'||l_tab_nt_type(i)||'(RSE_HE_ID)';
      EXECUTE IMMEDIATE (l_sql);

      l_sql:='CREATE INDEX '||SUBSTR(USER,1,1)||'nm'||l_tab_nt_type(i)||'_spidx ON '||USER||'_NET_MAP_'||l_tab_nt_type(i)||'(SHAPE) INDEXTYPE IS mdsys.spatial_index';
      EXECUTE IMMEDIATE (l_sql);

	  IF i=l_tab_nt_type.COUNT THEN
  	  --now delete the original
        DELETE FROM NM_NW_THEMES WHERE NNTH_NTH_THEME_ID=l_nth_orig_id;
	    DELETE FROM NM_THEME_GTYPES WHERE NTG_THEME_ID=l_nth_orig_id;
        DELETE FROM NM_THEME_FUNCTIONS_ALL WHERE NTF_NTH_THEME_ID=l_nth_orig_id;
        DELETE FROM NM_THEME_ROLES WHERE NTHR_THEME_ID=l_nth_orig_id;
        DELETE FROM NM_THEMES_ALL WHERE NTH_THEME_ID=l_nth_orig_id;


	  END IF;
    END LOOP;
  END IF;

END Fix_Route_Theme;





procedure resume_invent_migration
(pi_log_file_location IN VARCHAR2
,pi_inv_type              IN varchar2
,pi_sys_Flag              IN varchar2
,pi_go_on in boolean
,pi_ukp_only in varchar2 default 'A'
,pi_open_only varchar2 default 'N'
)  is

  TYPE l_ref IS REF CURSOR;
--
   get_inv_types l_ref;
   l_sql_all Nm3type.max_varchar2 := 'SELECT ity_inv_code '||
                                 '      ,ity_sys_flag '||
                                 'FROM inv_type_translations '||
'where ity_inv_Code>'''||pi_inv_type||''''||
                                 'CONNECT BY PRIOR ity_inv_code = ity_parent_ity (+)'||
                                 'START WITH ity_parent_ity IS NULL ORDER BY ity_sys_flag,ity_inv_code';

   l_sql_ukp Nm3type.max_varchar2 := 'SELECT ity_inv_code '||
                                 '      ,ity_sys_flag '||
                                 'FROM inv_type_translations '||
'where  exists (select ''x'' from ukpms_view_Definitions where ity_inv_code= UVD_INV_CODE and ity_sys_flag= UVD_SYS_FLAG)'||
'and ity_inv_Code>'''||pi_inv_type||''''||
                                 'CONNECT BY PRIOR ity_inv_code = ity_parent_ity (+)'||
                                 'START WITH ity_parent_ity IS NULL ORDER BY ity_sys_flag,ity_inv_code';

   l_sql_no_ukp Nm3type.max_varchar2 := 'SELECT ity_inv_code '||
                                 '      ,ity_sys_flag '||
                                 'FROM inv_type_translations '||
'where not  exists (select ''x'' from ukpms_view_Definitions where ity_inv_code= UVD_INV_CODE and ity_sys_flag= UVD_SYS_FLAG)'||
'and ity_inv_Code>'''||pi_inv_type||''''||
                                 'CONNECT BY PRIOR ity_inv_code = ity_parent_ity (+)'||
                                 'START WITH ity_parent_ity IS NULL ORDER BY ity_sys_flag,ity_inv_code';




   l_tab_inv_type Nm3type.tab_varchar4;
   l_tab_sys_flag Nm3type.tab_varchar1;
   l_count_errors PLS_INTEGER;
--
--
   CURSOR get_errors IS
   SELECT   'Inventory' issue
           ,iit_inv_type
           ,COUNT(*) num_issues
           ,iit_exception
   FROM     NM2_NM3_INV_EXCEPTIONS
   GROUP BY iit_inv_type, iit_exception
   UNION
   SELECT   'Locating'
           ,iit_inv_type
           ,COUNT(*)
           ,iit_exception
   FROM     NM2_NM3_INV_EXCEPTIONS_LOC
   GROUP BY iit_inv_type, iit_exception
   ORDER BY 1,2;

   CURSOR cs_iit (c_inv_type nm_inv_types.nit_inv_type%TYPE
                 ,c_sys_flag v2_inv_item_types.ity_sys_flag%TYPE
                 ) IS
   SELECT iit1.iit_item_id
    FROM  v2_inv_items_all iit1
   WHERE  iit1.iit_ity_sys_flag = c_sys_flag
    AND   iit1.iit_ity_inv_code = c_inv_type
	and not exists
	(select 'z' from nm_inv_items_all
	where iit_num_attrib115=iit_item_id
	and iit_inv_type=nm2_nm3_migration.get_nm3_inv_code(c_inv_type,c_sys_flag))
	;

   CURSOR get_work_to_do(p_inv_type varchar2,p_sys_flag varchar2) IS
   SELECT COUNT(*)
   FROM v2_inv_items_all
   WHERE  iit_ity_sys_flag = p_sys_flag
    AND   iit_ity_inv_code = p_inv_type;

  l_tab_item_id Nm3type.tab_number;
   l_count       PLS_INTEGER := 0;

BEGIN
--

   nm2_nm3_migration.initialise(pi_log_file_location  => pi_log_file_location
              ,pi_log_file_name      => 'resume_inventory_'||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.LOG'
              ,pi_with_debug         => FALSE);

   g_proc_name := 'migrate_inventory';
   nm2_nm3_migration.append_proc_start_to_log;
--
   nm2_nm3_migration.append_log_content('Resuming '||pi_inv_type);

   OPEN  cs_iit(nm2_nm3_migration.get_nm2_inv_code(pi_inv_type),pi_sys_flag);
   FETCH cs_iit BULK COLLECT INTO l_tab_item_id;
   CLOSE cs_iit;
   FOR i IN 1..l_tab_item_id.COUNT
    LOOP
      l_count      := l_count + 1;
      IF MOD(l_count,500) = 0 THEN
        nm2_nm3_migration.do_optional_commit;
      END IF;
      IF MOD(l_count, 20000) = 0 OR l_count = 1000 THEN -- refresh statistics every 20000 rows or after first 1000
        nm2_nm3_migration.append_log_content('Refreshing Inventory Statistics');
        nm2_nm3_migration.analyse_inventory_tables(100);
      END IF;
      nm2_nm3_migration.pc_inv_mig_nm2_nm3_by_id (l_tab_item_id(i));
   END LOOP;
   nm2_nm3_migration.do_optional_commit;




  if pi_go_on then

      if upper(pi_ukp_only) ='A' then
     OPEN  get_inv_types FOR l_sql_all;
     FETCH get_inv_types BULK COLLECT INTO l_tab_inv_type, l_tab_sys_flag;
     CLOSE get_inv_types;
   elsif upper(pi_ukp_only) ='U' then
     OPEN  get_inv_types FOR l_sql_ukp;
     FETCH get_inv_types BULK COLLECT INTO l_tab_inv_type, l_tab_sys_flag;
     CLOSE get_inv_types;
   elsif upper(pi_ukp_only) ='N' then
     OPEN  get_inv_types FOR l_sql_no_ukp;
     FETCH get_inv_types BULK COLLECT INTO l_tab_inv_type, l_tab_sys_flag;
     CLOSE get_inv_types;
   end if;

   g_total_todo:=0;
   for i in 1..l_tab_inv_type.count loop
     OPEN get_work_to_do(l_tab_inv_type(i),l_tab_sys_flag(i));
     FETCH get_work_to_do INTO g_so_far;
     CLOSE get_work_to_do;
     g_total_todo:=g_total_todo+g_so_far;
     g_so_far:=0;
   end loop;




   -- set up the long op for inventory migration
   start_longop(p_what         => 'Inventory Migration'
               ,p_total_amount => g_total_todo);




   -- set up the long op for inventory migration
   FOR i IN 1..l_tab_inv_type.COUNT
    LOOP
      nm2_nm3_migration.append_log_content(pi_text => 'Processing Inventory Type ['||l_tab_inv_type(i)||'] on network '||l_tab_sys_flag(i));
      nm2_nm3_migration.pc_inv_mig_nm2_nm3_by_type (l_tab_inv_type(i), l_tab_sys_flag(i), FALSE,pi_open_only);
   END LOOP;
--
--   nm2_nm3_migration.append_log_content('Analysing inventory tables');
--   nm2_nm3_migration.analyse_inventory_tables(100);
   --
--   update_inventory_fk_vals;
   --
   nm2_nm3_migration.report_any_errors;
   l_count_errors := 0;
   FOR irec IN get_errors LOOP
     IF l_count_errors = 0 THEN
       nm2_nm3_migration.append_log_content('Summary of Errors:');
     END IF;
     l_count_errors := l_count_errors + 1;
     nm2_nm3_migration.append_log_content(irec.num_issues||' '||irec.issue||' issues with '||irec.iit_inv_type||' error recorded, '||irec.iit_exception);
   END LOOP;
   nm2_nm3_migration.append_proc_end_to_log;
--
  end if;

EXCEPTION
 WHEN OTHERS THEN
   nm2_nm3_migration.append_log_content(SQLERRM);
   nm2_nm3_migration.stop_migration('Inventory migration aborted');
end   resume_invent_migration;


-- instatiate package procedure
begin
populate_old_new_tab;

END Nm2_Nm3_Migration;
/
