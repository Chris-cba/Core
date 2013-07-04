CREATE OR REPLACE PACKAGE BODY hig_health AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_health.pkb	1.1 06/26/03
--       Module Name      : hig_health.pkb
--       Date into SCCS   : 03/06/26 10:42:38
--       Date fetched Out : 07/06/13 14:10:23
--       SCCS Version     : 1.1
--
--
--   Author : G Johnson
--
--   Contains functions/procedures required to perform database healthcheck
--   Package is called through the GRI (module HIG2100) and the use of wrapper script (HIG2100.sql)
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)hig_health.pkb	1.1 06/26/03"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'hig_health';
--
   g_tab_lines        nm3type.tab_varchar32767;
--
-- Globals that are used to store the parameter values for this GRI report run
   g_param_customer_name        gri_run_parameters.grp_value%TYPE;
   g_param_customer_contact     gri_run_parameters.grp_value%TYPE;
   g_param_server_make_type     gri_run_parameters.grp_value%TYPE;
   g_param_available_memory     gri_run_parameters.grp_value%TYPE;
   g_param_disk_space           gri_run_parameters.grp_value%TYPE;
   g_param_higowner             gri_run_parameters.grp_value%TYPE;
   g_param_threshold            gri_run_parameters.grp_value%TYPE;
--
-- Globals that are used to identify returned data from the checks

   g_identifier                 VARCHAR2(1) :=':';
   
--
   TYPE t_check_rec IS RECORD(check_name   nm3type.max_varchar2
                             ,check_sql    nm3type.max_varchar2);
                                

   TYPE t_check_tab IS TABLE of t_check_rec INDEX BY BINARY_INTEGER;                                                                         

   g_check_tab    t_check_tab;
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
PROCEDURE get_params(pi_job_id IN gri_run_parameters.grp_job_id%TYPE)
IS

BEGIN
  --
  nm_debug.proc_start(g_package_name,'get_params');

  
  g_param_customer_name        := UPPER(higgrirp.get_parameter_value(a_job_id  => pi_job_id
                                                                    ,a_param   => 'P_TEXT_PARAM_1'));

  g_param_customer_contact     := UPPER(higgrirp.get_parameter_value(a_job_id  => pi_job_id
                                                                    ,a_param   => 'P_HUS_NAME'));

  g_param_server_make_type     := UPPER(higgrirp.get_parameter_value(a_job_id  => pi_job_id
                                                                    ,a_param   => 'P_TEXT_PARAM_2'));

  g_param_available_memory     := higgrirp.get_parameter_value(a_job_id  => pi_job_id
                                                              ,a_param   => 'P_TEXT_PARAM_3');

  g_param_disk_space           := higgrirp.get_parameter_value(a_job_id  => pi_job_id
                                                              ,a_param   => 'P_TEXT_PARAM_4');

  g_param_higowner             := UPPER(higgrirp.get_parameter_value(a_job_id  => pi_job_id
                                                                    ,a_param   => 'P_HUS_USERNAME'));
                                                                    
  g_param_threshold            := higgrirp.get_parameter_value(a_job_id  => pi_job_id
                                                              ,a_param   => 'A_NUMBER');

  --
  --
  nm_debug.proc_end(g_package_name,'get_params');
  --
END get_params;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (pi_text IN nm3type.max_varchar2) IS
 
BEGIN
  nm_debug.proc_start(g_package_name,'append');
   g_tab_lines(g_tab_lines.COUNT +1) := pi_text;
  nm_debug.proc_end(g_package_name,'append');
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_check_record(pi_check_name IN nm3type.max_varchar2
                          ,pi_check_sql  IN nm3type.max_varchar2) IS
                          

  v_new_record_id PLS_INTEGER;

BEGIN
-- 
  nm_debug.proc_start(g_package_name,'add_check_record');
--
  v_new_record_id := g_check_tab.COUNT+1;
  g_check_tab(v_new_record_id).check_name := pi_check_name;
  g_check_tab(v_new_record_id).check_sql := pi_check_sql;
-- 
   nm_debug.proc_end(g_package_name,'add_check_record');
-- 
END add_check_record;        
--
-----------------------------------------------------------------------------
--
PROCEDURE define_checks IS 

 v_sql nm3type.max_varchar2;
  
 v_delim_start                VARCHAR2(1) :='<';
 v_delim_end                  VARCHAR2(1) :='>';
 
 FUNCTION quoted_str(pi_string IN varchar2
                   ) RETURN varchar2 IS
 BEGIN
  RETURN CHR(39) || pi_string || CHR(39);
 END; 

 FUNCTION add_delims(p_col IN varchar2) RETURN VARCHAR2 IS

  v_string nm3type.max_varchar2;
 
 BEGIN

  v_string := quoted_str(v_delim_start);
  v_string := v_string||'||';
  v_string := v_string||p_col;
  v_string := v_string||'||';
  v_string := v_string||quoted_str(v_delim_end);
  RETURN(v_string);   
 
 END;


BEGIN

-- 
  nm_debug.proc_start(g_package_name,'define_checks');
--

  ------------------------------------------------------------------------------------
  -- Note: I know that the following checks could be data driven - BUT because we want
  -- to shield the actual SQL from users it has to be hard coded
  ------------------------------------------------------------------------------------
  
  -----------------------------------------------------------------------------------------------
  -- IMPORTANT:
  -- When you have a straightforward select of database columns you can call function add_delims
  -- to prefix a '<' and suffix a '>' to each column that you select
  --
  -- When referencing non-database columns in the sql statement e.g. g_ variables as in checks 1 and 2
  -- you need to faff about referencing v_delim_start/v_delim end in the sql that you build up
  --
  -----------------------------------------------------------------------------------------------  
  
  g_check_tab.DELETE;
--
-----------------------------------------------------------------------------
--
 
  v_sql := 'SELECT  '''||v_delim_start||g_param_customer_name||v_delim_end
                       ||v_delim_start||g_param_customer_contact||v_delim_end  
                       ||v_delim_start||to_char(sysdate,'DD-MON-YYYY')||v_delim_end||''''
                       ||' from dual'; 
  add_check_record(
                   pi_check_name => 'CUSTOMER DETAILS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '''||v_delim_start||g_param_server_make_type||v_delim_end
                       ||v_delim_start||g_param_available_memory||v_delim_end
                       ||v_delim_start||g_param_disk_space||v_delim_end||'''||'
                       ||add_delims('i.instance_name')||'||'                       
                       ||add_delims('gn.global_name')||'||'''
                       ||v_delim_start||g_param_higowner||v_delim_end||''''
                       ||' from global_name gn, v$instance  i';                        
                                              
  add_check_record(
                   pi_check_name => 'DATABASE OVERVIEW'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--                
  v_sql := 'SELECT  '||add_delims('hpr_product')||'||'                       
                     ||add_delims('hpr_product_name')||'||'
                     ||add_delims('hpr_version')                     
                     ||' from hig_products'
                     ||' WHERE     hpr_key is not null'
                     ||' ORDER BY  hpr_product';
  add_check_record(
                   pi_check_name => 'INSTALLED EXOR PRODUCTS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.name')||'||'                       
                     ||add_delims('a.created')||'||'
                     ||add_delims('a.log_mode')||'||'
                     ||add_delims('to_char(a.checkpoint_change#)')||'||'                       
                     ||add_delims('to_char(a.archive_change#)')||'||'
                     ||add_delims('to_char(b.startup_time,''DD-MON-YYYY'')')
                     ||' from v$database a ,v$instance b';

  add_check_record(
                   pi_check_name => 'DATABASE DETAILS'
                  ,pi_check_sql  => v_sql 
                  );

--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('banner')                       
                     ||' from v$version';
                       
  add_check_record(
                   pi_check_name => 'INSTALLED ORACLE PRODUCTS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('name')||'||'                       
                     ||add_delims('value')
                     ||' from v$sga';
                       
  add_check_record(
                   pi_check_name => 'SGA'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('to_char(sessions_max)')||'||'                       
                     ||add_delims('to_char(sessions_warning)')||'||'
                     ||add_delims('to_char(sessions_current)')||'||'
                     ||add_delims('to_char(sessions_highwater)')||'||'                                          
                     ||add_delims('to_char(users_max)')                   
                     ||' from v$license';
                       
  add_check_record(
                   pi_check_name => 'SESSION CONNECTIONS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('tablespace_name')||'||'                       
                     ||add_delims('file_name')||'||'
                     ||add_delims('TO_CHAR(bytes/(1024*1024))')                                         
                     ||' from dba_data_files'
                     ||' ORDER BY tablespace_name, file_name';
                       
  add_check_record(
                   pi_check_name => 'TABLESPACES'
                  ,pi_check_sql  => v_sql 
                  );
                  
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('SUM(bytes)')                       
                     ||' FROM dba_data_files';
                       
  add_check_record(
                   pi_check_name => 'TABLESPACE SIZE (BYTES)'
                  ,pi_check_sql  => v_sql 
                  );                  
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('tablespace_name')||'||'                       
                     ||add_delims('sum(bytes/(1024*1024))')
                     ||' from dba_free_space'
                     ||' GROUP BY tablespace_name ORDER BY tablespace_name';
                       
  add_check_record(
                   pi_check_name => 'FREE SPACE'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('segment_name')||'||'                       
                     ||add_delims('status')||'||'
                     ||add_delims('initial_extent')||'||'  
                     ||add_delims('next_extent')||'||'  
                     ||add_delims('min_extents')||'||'
                     ||add_delims('max_extents')||'||'                     
                     ||add_delims('tablespace_name')                     
                     ||' from dba_rollback_segs'
                     ||' ORDER BY status, segment_name';

  add_check_record(
                   pi_check_name => 'ROLLBACK SEGMENTS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('usn')||'||'                       
                     ||add_delims('extents')||'||'
                     ||add_delims('rssize')||'||'  
                     ||add_delims('writes')||'||'  
                     ||add_delims('xacts')||'||'
                     ||add_delims('gets')||'||'
                     ||add_delims('waits')||'||'
                     ||add_delims('optsize')||'||'
                     ||add_delims('shrinks')||'||'
                     ||add_delims('extends')||'||'
                     ||add_delims('aveshrink')||'||'
                     ||add_delims('decode(status,''ONLINE'',''ON'',''OFF'')')
                     ||' from v$rollstat'
                     ||' ORDER BY decode(status,''ONLINE'',''ON'',''OFF''),usn DESC';

  add_check_record(
                   pi_check_name => 'ROLLBACK STATS'
                  ,pi_check_sql  => v_sql 
                  );

--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('group#')||'||'                       
                     ||add_delims('status')||'||'
                     ||add_delims('member')  
                     ||' from v$logfile'
                     ||' ORDER BY group#, member';

  add_check_record(
                   pi_check_name => 'LOG FILES'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('status')||'||'                       
                     ||add_delims('name')  
                     ||' from v$controlfile'
                     ||' ORDER BY name';
                     
  add_check_record(
                   pi_check_name => 'CONTROL FILES'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('username')||'||'                       
                     ||add_delims('default_tablespace')||'||'
                     ||add_delims('temporary_tablespace')  
                     ||' FROM  dba_users,hig_users '
                     ||' WHERE username=hus_username '
                     ||' ORDER BY username';


  add_check_record(
                   pi_check_name => 'USER ACCOUNTS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('name')||'||'                       
                     ||add_delims('value')  
                     ||' FROM  v$parameter'
                     ||' ORDER BY name';

  add_check_record(
                   pi_check_name => 'ORACLE PARAMETERS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('owner')||'||'                       
                     ||add_delims('table_name')  
                     ||' FROM  all_tables'
                     ||' WHERE tablespace_name=''SYSTEM'''
                     ||' AND   owner not in (''SYS'',''SYSTEM'')'                                          
                     ||' ORDER BY table_name';

  add_check_record(
                   pi_check_name => 'SYSTEM OBJECTS NOT IN SYSTEM - TABLES'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('owner')||'||'                       
                     ||add_delims('index_name')  
                     ||' FROM  all_indexes'
                     ||' WHERE tablespace_name=''SYSTEM'''
                     ||' AND   owner not in (''SYS'',''SYSTEM'')'                                          
                     ||' ORDER BY index_name';

  add_check_record(
                   pi_check_name => 'SYSTEM OBJECTS NOT IN SYSTEM - INDEXES'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('name')||'||'                       
                     ||add_delims('bytes')  
                     ||' FROM  v$sgastat'
                     ||' ORDER BY UPPER(name)';

  add_check_record(
                   pi_check_name => 'SGA IN DETAIL'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('name')||'||'                       
                     ||add_delims('value')  
                     ||' FROM  v$sysstat'
                     ||' WHERE UPPER(name) in (''DB BLOCK GETS'',''CONSISTENT GETS'',''PHYSICAL READS'')'
                     ||' ORDER BY UPPER(name)';

  add_check_record(
                   pi_check_name => 'BUFFER CACHE RATIO - PART 1'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('ROUND(1-(a.value/(b.value+c.value)),5)')                       
                     ||' FROM  v$sysstat a'
                     ||'     , v$sysstat b'                     
                     ||'     , v$sysstat c'                     
                     ||' where UPPER(a.name) =''DB BLOCK GETS'''
                     ||' and   UPPER(b.name) =''CONSISTENT GETS'''
                     ||' and   UPPER(c.name) =''PHYSICAL READS''';
                     
  add_check_record(
                   pi_check_name => 'BUFFER CACHE RATIO - PART 2'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.name')
                     ||add_delims('a.value')||'||'
                     ||add_delims('b.name')||'||'
                     ||add_delims('b.value')                                                                   
                     ||' FROM  v$sysstat a'
                     ||'     , v$parameter b'                     
                     ||' WHERE UPPER(a.name)=''REDO LOG SPACE REQUESTS'''
                     ||' AND   UPPER(b.name)=''LOG_BUFFER'''; 
                     
  add_check_record(
                   pi_check_name => 'REDO LOG SPACE REQUESTS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('SUM(getmisses)')||'||'
                     ||add_delims('SUM(gets)')||'||'
                     ||add_delims('ROUND(SUM(getmisses)/(sum(gets)),5)')
                     ||' FROM  v$rowcache';
                     
  add_check_record(
                   pi_check_name => 'DICTIONARY CACHE HIT RATIO'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('SUM(pins)')||'||'
                     ||add_delims('SUM(reloads)')||'||'
                     ||add_delims('ROUND((100*(sum(reloads)/sum(pins))),5)||''%''')
                     ||' FROM  v$librarycache';
                     
                     
  add_check_record(
                   pi_check_name => 'LIBRARY CACHE HIT RATIO'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('name')||'||'
                     ||add_delims('value')
                     ||' FROM  v$sysstat'
                     ||' WHERE INSTR(name,''sorts'')>0';                     
                     
  add_check_record(
                   pi_check_name => 'SORT I/O'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('ROUND(b.value/a.value,5)')
                     ||' FROM  v$sysstat a'
                     ||'     , v$sysstat b'                     
                     ||' WHERE a.name=''sorts (memory)'''
                     ||' AND   b.name=''sorts (disk)''';                                          
                     
  add_check_record(
                   pi_check_name => 'SORT I/O - RATIO MEMORY TO DISK'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('group#')||'||'
                     ||add_delims('thread#')||'||'
                     ||add_delims('sequence#')||'||'                     
                     ||add_delims('bytes')||'||'                     
                     ||add_delims('members')||'||'
                     ||add_delims('archived')||'||'                     
                     ||add_delims('status')||'||'                     
                     ||add_delims('first_change#')||'||'                     
                     ||add_delims('first_time')                     
                     ||' FROM  v$log';

  add_check_record(
                   pi_check_name => 'LOG FILE SIZES'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('thread#')||'||'
                     ||add_delims('sequence#')||'||'                     
                     ||add_delims('first_change#')||'||'                     
                     ||add_delims('first_time')||'||'
                     ||add_delims('switch_change#')                                          
                     ||' FROM  v$loghist';

  add_check_record(
                   pi_check_name => 'LOG FILE HISTORY'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.Tablespace_name')||'||'
                     ||add_delims('a.table_name')                     
                     ||' FROM all_tables a'
                     ||' WHERE  owner = UPPER('''||g_param_higowner||''')'                   
                     ||' ORDER BY tablespace_name, table_name';

  add_check_record(
                   pi_check_name => 'TABLES OWNED BY HIGHWAYS OWNER ['||g_param_higowner||']'
                  ,pi_check_sql  => v_sql 
                  );


--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.Tablespace_name')||'||'
                     ||add_delims('COUNT(a.table_name)')                     
                     ||' FROM all_tables a'
                     ||' WHERE  a.owner = UPPER('''||g_param_higowner||''')'                   
                     ||' GROUP BY a.tablespace_name'
                     ||' ORDER BY a.tablespace_name';

  add_check_record(
                   pi_check_name => 'COUNT OF TABLES BY TABLESPACE FOR HIGHWAYS OWNER ['||g_param_higowner||']'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.Tablespace_name')||'||'
                     ||add_delims('a.index_name')||'||'
                     ||add_delims('b.column_name')||'||'                     
                     ||add_delims('b.column_position')                                          
                     ||' FROM all_indexes a'
                     ||'    , all_ind_columns b'                     
                     ||' WHERE  a.owner = UPPER('''||g_param_higowner||''')'
                     ||' AND    a.index_name = b.index_name'
                     ||' AND    b.index_owner = UPPER('''||g_param_higowner||''')'                                                             
                     ||' ORDER BY a.tablespace_name, a.index_name, b.column_position';

  add_check_record(
                   pi_check_name => 'INDEXES OWNED BY HIGHWAYS OWNER ['||g_param_higowner||']'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.Tablespace_name')||'||'
                     ||add_delims('COUNT(a.table_name)')                     
                     ||' FROM all_indexes a'
                     ||' WHERE  a.owner = UPPER('''||g_param_higowner||''')'                   
                     ||' GROUP BY a.tablespace_name'
                     ||' ORDER BY a.tablespace_name';

  add_check_record(
                   pi_check_name => 'COUNT OF INDEXES BY TABLESPACE FOR HIGHWAYS OWNER ['||g_param_higowner||']'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('owner')
                     ||' FROM all_tables'                     
                     ||' WHERE  table_name=''HIG_USERS'''
                     ||' ORDER BY owner';
                     
  add_check_record(
                   pi_check_name => 'ALL HIGHWAYS OWNER ACCOUNTS'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.segment_name')||'||'
                     ||add_delims('a.segment_type')||'||'
                     ||add_delims('count(a.segment_name)')                       
                     ||' FROM dba_extents a'                     
                     ||' WHERE  a.owner = UPPER('''||g_param_higowner||''')'                   
                     ||' AND    a.segment_type in (''INDEX'',''TABLE'')'
                     ||' GROUP BY a.segment_name, a.segment_type'
                     ||' HAVING COUNT(*) > '||g_param_threshold  
                     ||' ORDER BY COUNT(a.segment_name) DESC';
                     
  add_check_record(
                   pi_check_name => 'OBJECTS EXTENDED MORE TIMES THAN THRESHOLD ['||g_param_threshold||']'
                  ,pi_check_sql  => v_sql 
                  );
--
-----------------------------------------------------------------------------
--
  v_sql := 'SELECT  '||add_delims('a.object_type')||'||'
                     ||add_delims('a.object_name')
                     ||' FROM all_objects a'                     
                     ||' WHERE  a.owner = UPPER('''||g_param_higowner||''')'
                     ||' AND    a.status = ''INVALID'''                                        
                     ||' ORDER BY a.object_type, a.object_name';
                     
  add_check_record(
                   pi_check_name => 'INVALID OBJECTS'
                  ,pi_check_sql  => v_sql 
                  );
                  
-- 
  nm_debug.proc_end(g_package_name,'define_checks');
--

END define_checks;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_checks IS 

 refcur        nm3type.ref_cursor;
 
 v_check_title nm3type.max_varchar2;
 v_curr_sql    nm3type.max_varchar2;
 
 v_module_rec  hig_modules%ROWTYPE :=nm3get.get_hmo(pi_hmo_module      => 'HIG2100'
                                                   ,pi_raise_not_found => FALSE);  
 

BEGIN 
-- 
  nm_debug.proc_start(g_package_name,'perform_checks');
--

  ---------------------------
  -- Start with a clean slate
  ---------------------------  
  g_tab_lines.DELETE;

  ----------------------------------------------------------
  -- Add the script name and sccs version to the output file
  ----------------------------------------------------------  
  append('Highways By Exor');
  append('================');
  append(UPPER(v_module_rec.hmo_title)||' Version '||g_sccsid);
  append('=========================================================');
  append('');


  --------------------------------------------------------------------
  -- Loop through all checks in the check table and display check name
  --------------------------------------------------------------------
  append('Checks');
  append('======');
        
  FOR v_index IN 1.. g_check_tab.COUNT LOOP
   append(RPAD(to_char(v_index)||'.',4)||g_check_tab(v_index).check_name);
--   append(RPAD(to_char(v_index)||'.',4)||g_check_tab(v_index).check_sql);   
  END LOOP;

  append('');
  
  ---------------------------------------------
  -- Loop through all checks in the check table
  ---------------------------------------------  
  FOR v_index IN 1.. g_check_tab.COUNT LOOP

  ---------------------------------------------
  -- Open the SQL statement in the check as a cursor
  -- and grab all of the records returned by the cursor
  -- and place into pl/sql table g_tab_lines)
  ---------------------------------------------
   v_curr_sql := g_check_tab(v_index).check_sql;  
   OPEN refcur FOR v_curr_sql;

   ----------------------------------------------------------
   -- Fetch results of the check directly into the PL/SQL table
   ----------------------------------------------------------
   LOOP

     FETCH refcur INTO g_tab_lines(g_tab_lines.count+1);
     IF refcur%NOTFOUND THEN 
        EXIT;  -- exit the loop and carry on processing
     END IF;
     
     g_tab_lines(g_tab_lines.count) := TO_CHAR(v_index)||g_identifier||g_tab_lines(g_tab_lines.count);
     
   END LOOP;  -- end loop of records returned by a check
   
   CLOSE refcur;

 END LOOP; -- end loop of checks                  

-- 
  nm_debug.proc_end(g_package_name,'perform_checks');
--
EXCEPTION
  WHEN others THEN
        RAISE_APPLICATION_ERROR(-20001,sqlerrm||chr(10)||v_curr_sql); 

END perform_checks;
--
-----------------------------------------------------------------------------
--
PROCEDURE main(pi_job_id      IN     gri_run_parameters.grp_job_id%TYPE)
IS

 v_destination VARCHAR2(80);
 v_filename    VARCHAR2(80);
 
 ex_invalid_destination EXCEPTION;
 
 
BEGIN
  --
  nm_debug.proc_start(g_package_name,'main');

  higgrirp.write_gri_spool(pi_job_id,'Starting');  

  nm_debug.debug_on;
  --
  ----------------------------------------
  -- Get the parameter values for this run
  ----------------------------------------
  get_params(pi_job_id => pi_job_id );

  -------------------------------------------------------------------------------------------
  -- Define all of the dynamic sql that will be executed in order to produce the output file
  -------------------------------------------------------------------------------------------  
  higgrirp.write_gri_spool(pi_job_id,'Defining checks');
  define_checks;  
  higgrirp.write_gri_spool(pi_job_id,'Done');

  -------------------------------------------------------------------------------------------
  -- Cycle through the pl/sql table populated by define_checks - and execute the dynamic sql
  -- appending the output into pl/sql table g_tab_lines
  -------------------------------------------------------------------------------------------
  higgrirp.write_gri_spool(pi_job_id,'Performing checks');
  perform_checks;  
  higgrirp.write_gri_spool(pi_job_id,'Done');         

  -----------------------------------------------------------
  -- Write the contents of pl/sql table g_tab_lines to a file
  -----------------------------------------------------------

  --------------------------------------------------------------------------------------
  -- Grab destination of where to write the file
  --------------------------------------------------------------------------------------
  v_destination := hig.get_user_or_sys_opt('REPOUTPATH');

  ---------------------------------------------------------------------------------
  -- ensure that directory separator is not included in the output destination name
  ---------------------------------------------------------------------------------    
  IF substr(v_destination,length(v_destination),1) IN ('\','/') THEN
     v_destination := SUBSTR(v_destination,1,LENGTH(v_destination)-1);
  END IF;
  
  IF v_destination IS NULL THEN
     RAISE ex_invalid_destination;
  END IF;


  v_filename    := higgrirp.get_module_spoolfile(a_job_id => pi_job_id);
  higgrirp.write_gri_spool(pi_job_id,'Writing file');
  higgrirp.write_gri_spool(pi_job_id,'Filename    ['||v_filename||']');  
  higgrirp.write_gri_spool(pi_job_id,'Destination (user/product option ''REPOUTPATH'') ['||v_destination||']');  

  
  nm3file.write_file (location     => v_destination
                     ,filename     => v_filename
                     ,max_linesize => 32767
                     ,all_lines    => g_tab_lines
                      );                      

  UPDATE gri_report_runs
  SET    grr_end_date = SYSDATE
  WHERE  grr_job_id = pi_job_id;
  
  COMMIT;
                      
  higgrirp.write_gri_spool(pi_job_id,'Finished.');  
                      
  nm_debug.debug_off;  
  nm_debug.proc_end(g_package_name,'main');
  --
EXCEPTION

 WHEN ex_invalid_destination THEN
   higgrirp.write_gri_spool(pi_job_id,'Cannot determine where to write the output file.  Product/user option of ''UTLFILEDIR'' possibly missing.');
      
 WHEN others THEN
   higgrirp.write_gri_spool(pi_job_id,sqlerrm);  
END main;
--
-----------------------------------------------------------------------------
--
END hig_health;
/

