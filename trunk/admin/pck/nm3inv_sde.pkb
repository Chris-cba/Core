CREATE OR REPLACE PACKAGE BODY nm3inv_sde AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_sde.pkb-arc   2.2   Jul 04 2013 16:08:46   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_sde.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:08:46  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:43:32  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.14
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   NM3 Inventory for SDE package body
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.2  $';
  g_package_name    CONSTANT  varchar2(30)   := 'nm3inv_sde';
--
   c_application_owner CONSTANT user_users.username%TYPE  := hig.get_application_owner;
   c_server_name       CONSTANT v$instance.host_name%TYPE := NVL(hig.get_sysopt('SDESERVER')
                                                                ,nm3context.get_context(pi_attribute=>'HOST_NAME')
                                                                );
   c_sde_service       CONSTANT varchar2(80)              := NVL(hig.get_sysopt('SDEINST')
                                                                ,'esri_sde'
                                                                );
   c_file_dest         CONSTANT hig_option_values.hov_value%TYPE := NVL(hig.get_sysopt('SDEBATDIR'),'c:');
   c_utlfiledir_set    CONSTANT BOOLEAN      := hig.get_sysopt('UTLFILEDIR') IS NOT NULL;
   c_run_now           CONSTANT boolean      := hig.get_sysopt('SDERUNLE')='Y';
   c_inv_view_slk      CONSTANT boolean      := hig.get_sysopt('INVVIEWSLK') = 'Y';
   c_carot             CONSTANT varchar2(2)  := '^';
   c_dirrepstrn CONSTANT varchar2(1) := hig.get_sysopt(p_option_id => 'DIRREPSTRN');
--
   c_line_feed  CONSTANT VARCHAR2(2) := nm3flx.i_t_e (c_utlfiledir_set
                                                     ,nm3mail.c_lf
                                                     ,nm3mail.c_crlf
                                                     );
--
-----------------------------------------------------------------------------
--
PROCEDURE exec_command( pi_command  varchar2
                       ,pi_username varchar2 DEFAULT USER
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE write_file_internal (p_filename  VARCHAR2
                              ,p_tab_lines nm3type.tab_varchar32767
                              );
--
-----------------------------------------------------------------------------
--
PROCEDURE put_line_feed_on_end (p_tab_lines IN OUT NOCOPY nm3type.tab_varchar32767
                               ,p_size      IN OUT number
                               ,p_lf        IN     varchar2 DEFAULT c_line_feed
                               );
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
PROCEDURE create_all_sde_inv_shp_tables (p_app_owner_pwd varchar2 DEFAULT USER) IS
--
   CURSOR cs_inv_types IS
   SELECT nit_inv_type
    FROM  nm_inv_types
   WHERE  EXISTS (SELECT 1
                   FROM  all_views
                  WHERE  owner     = c_application_owner
                   AND   view_name = nm3inv_view.derive_nw_inv_type_view_name(nit_inv_type)
                 )
    AND   nit_table_name IS NULL
   ORDER BY nit_inv_type;
--
   l_tab_nit     nm3type.tab_varchar30;
--
   l_tab_varchar nm3type.tab_varchar32767;
--
BEGIN
--
-- nm_debug.delete_debug(TRUE);
-- nm_debug.debug_on;
   nm_debug.proc_start(g_package_name,'create_all_sde_inv_shp_tables');
--
   -- Put these all into an array so we don't have bother with Snapshot too old
   OPEN  cs_inv_types;
   FETCH cs_inv_types BULK COLLECT INTO l_tab_nit;
   CLOSE cs_inv_types;
--
   FOR i IN 1..l_tab_nit.COUNT
    LOOP
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'REM Starting Generation  : '||TO_CHAR(SYSDATE,'HH24:MI:SS DD-MON-YYYY');
      create_sde_inv_shape_table (l_tab_nit(i),p_app_owner_pwd);
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'call loadevents_'||l_tab_nit(i);
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'REM Finishing Generation : '||TO_CHAR(SYSDATE,'HH24:MI:SS DD-MON-YYYY');
   END LOOP;
--
   write_file_internal (p_filename  => 'all_sde_inv.bat'
                       ,p_tab_lines => l_tab_varchar
                       );
--
   nm_debug.proc_end(g_package_name,'create_all_sde_inv_shp_tables');
--
END create_all_sde_inv_shp_tables;
--
-----------------------------------------------------------------------------
--
FUNCTION get_update_batch_file_name (p_inv_type VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN 'update_loadevents_'||p_inv_type||'.bat';
END get_update_batch_file_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_sde_inv_shape_table (p_inv_type      nm_inv_types.nit_inv_type%TYPE
                                     ,p_app_owner_pwd varchar2 DEFAULT USER
                                     ) IS
--
   CURSOR cs_batchfile (c_events_table  user_tables.table_name%TYPE
                       ,c_feature_table user_tables.table_name%TYPE
                       ,c_server        v$instance.host_name%TYPE
                       ,c_username      user_users.username%TYPE
                       ,c_pwd           varchar2
                       ,c_service       varchar2
                       ) IS
   SELECT 1 row_order
         ,'Loadevents -l1 '
          ||c_events_table
          ||',shape '
          ||'-l2 '
          ||n.gt_feature_table
          ||',shape -from '
          ||t.gt_st_chain_column
          ||DECODE(t.gt_end_chain_column,NULL,NULL,' -to ')
          ||t.gt_end_chain_column
          ||'  -to_is_offset'
          ||' -w "'
          ||c_events_table
          ||'.ne_id_of='
          ||n.gt_feature_table
          ||'.'||n.gt_feature_pk_column||'"'
          ||' -s '
          ||c_server
          ||' -i '||c_service||' -u '
          ||c_username
          ||' -p '
          ||c_pwd
          ||' -v -N' DATA
    FROM  gis_themes_all t
         ,gis_themes_all n
   WHERE n.gt_route_theme   = 'Y'
    AND  t.gt_route_theme   = 'N'
    AND  t.gt_feature_table = c_username||'.'||c_feature_table;
--
   l_tab_row_order nm3type.tab_number;
   l_tab_data      nm3type.tab_varchar32767;
--
   l_string varchar2(32767);
   l_tab_varchar nm3type.tab_varchar32767;
--
   l_rec_nit            nm_inv_types%ROWTYPE;
   l_table_name         user_tables.table_name%TYPE;
   l_feature_table_name user_tables.table_name%TYPE;
   l_inv_view_name      user_tables.table_name%TYPE;
--
   l_line_start      varchar2(10);
--
   TYPE sde_tab_dets IS RECORD
       (col_name    user_tab_columns.column_name%TYPE
       ,col_type    varchar2(30)
       ,SOURCE      user_tab_columns.column_name%TYPE
       ,def_val     varchar2(60)
       );
--
   l_rec_sde_tab_dets sde_tab_dets;
--
   TYPE tab_sde_tab_dets IS TABLE OF sde_tab_dets INDEX BY binary_integer;
--
   l_tab_sde_tab_dets tab_sde_tab_dets;
--
   l_tab_vc nm3type.tab_varchar32767;
--
   CURSOR cs_route_gt IS
   SELECT *
    FROM  gis_themes
   WHERE  gt_route_theme = 'Y';
   l_rec_route_gt gis_themes%ROWTYPE;
--
   CURSOR cs_check_nin (c_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   SELECT 1
    FROM  nm_inv_nw
   WHERE  nin_nit_inv_code = c_inv_type;
   l_dummy     pls_integer;
   l_nin_found boolean;
--
   c_redirect CONSTANT nm3type.max_varchar2 := ' >> '||c_file_dest||c_dirrepstrn||p_inv_type||'.txt';
--
   PROCEDURE append (p_text varchar2
                    ,p_nl   boolean DEFAULT TRUE
                    ) IS
   BEGIN
      nm3ddl.append_tab_varchar (l_tab_vc, p_text, p_nl);
   END append;
--
   PROCEDURE start_rows IS
   BEGIN
      l_tab_varchar.DELETE;
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'echo Starting > '||c_file_dest||c_dirrepstrn||p_inv_type||'.txt';
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'date /t'||c_redirect;
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'time /t'||c_redirect;
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'REM ';
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'REM Inventory type '||p_inv_type||'('||l_rec_nit.nit_descr||')';
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'REM Generated '||TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS');
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'REM ';
   END start_rows;
--
   PROCEDURE end_rows IS
   BEGIN
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'echo Finishing'||c_redirect;
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'date /t'||c_redirect;
      l_tab_varchar(l_tab_varchar.COUNT+1) := 'time /t'||c_redirect;
   END end_rows;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_sde_inv_shape_table');
--
--   nm_debug.DEBUG(p_inv_type);
--
   l_rec_nit    := nm3inv.get_inv_type (p_inv_type);
   l_table_name := get_inv_sde_table_name (p_inv_type);
--
   OPEN  cs_check_nin (p_inv_type);
   FETCH cs_check_nin INTO l_dummy;
   l_nin_found := cs_check_nin%FOUND;
   CLOSE cs_check_nin;
   IF NOT l_nin_found
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_hig
                    ,pi_id                  => 67
                    ,pi_supplementary_info  => 'nm_inv_nw'
                    );
   END IF;
--
   -- Crethe the GIS theme where necessary
   nm3inv_view.create_gis_theme_for_inv_type (p_inv_type);
--
   l_rec_sde_tab_dets.col_name := 'IIT_NE_ID';
   l_rec_sde_tab_dets.col_type := 'NUMBER(9)';
   l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
   l_rec_sde_tab_dets.def_val  := NULL;
   l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;
--
   l_rec_sde_tab_dets.col_name := 'NE_ID_OF';
   l_rec_sde_tab_dets.col_type := 'NUMBER(9)';
   l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
   l_rec_sde_tab_dets.def_val  := NULL;
   l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;
--
   l_rec_sde_tab_dets.col_name := 'NM_BEGIN_MP';
   l_rec_sde_tab_dets.col_type := 'NUMBER';
   l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
   l_rec_sde_tab_dets.def_val  := NULL;
   l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;
--
   l_rec_sde_tab_dets.col_name := 'NM_END_MP';
   l_rec_sde_tab_dets.col_type := 'NUMBER';
   l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
   l_rec_sde_tab_dets.def_val  := NULL;
   l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;
--

--RAC - here, deliver the datum unique, route ne_id, route unique, route start and end slk, depending
--      on the setting of the invviewslk option

   IF c_inv_view_slk
    THEN
      l_rec_sde_tab_dets.col_name := 'DATUM_NE_UNIQUE';
      l_rec_sde_tab_dets.col_type := 'VARCHAR2(30)';
      l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
      l_rec_sde_tab_dets.def_val  := NULL;
      l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;

      l_rec_sde_tab_dets.col_name := 'ROUTE_NE_ID';
      l_rec_sde_tab_dets.col_type := 'NUMBER';
      l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
      l_rec_sde_tab_dets.def_val  := NULL;
      l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;

      l_rec_sde_tab_dets.col_name := 'ROUTE_NE_UNIQUE';
      l_rec_sde_tab_dets.col_type := 'VARCHAR2(30)';
      l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
      l_rec_sde_tab_dets.def_val  := NULL;
      l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;
--
      l_rec_sde_tab_dets.col_name := 'ROUTE_SLK_START';
      l_rec_sde_tab_dets.col_type := 'NUMBER';
      l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
      l_rec_sde_tab_dets.def_val  := NULL;
      l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;
--
      l_rec_sde_tab_dets.col_name := 'ROUTE_SLK_END';
      l_rec_sde_tab_dets.col_type := 'NUMBER';
      l_rec_sde_tab_dets.source   := 'a.'||l_rec_sde_tab_dets.col_name;
      l_rec_sde_tab_dets.def_val  := NULL;
      l_tab_sde_tab_dets(l_tab_sde_tab_dets.COUNT+1) := l_rec_sde_tab_dets;

   END IF;
--
   l_tab_vc.DELETE;
   IF nm3ddl.does_object_exist(l_table_name,'TABLE')
    THEN
      append ('TRUNCATE TABLE '||c_application_owner||'.'||l_table_name,FALSE);
      nm3ddl.debug_tab_varchar (l_tab_vc);
      nm3ddl.execute_tab_varchar (l_tab_vc);
   ELSE
--
      l_line_start := '   (';
      append ('CREATE TABLE '||c_application_owner||'.'||l_table_name,FALSE);
      FOR i IN 1..l_tab_sde_tab_dets.COUNT
       LOOP
         l_rec_sde_tab_dets := l_tab_sde_tab_dets(i);
         append (l_line_start||RPAD(l_rec_sde_tab_dets.col_name,31,' ')||l_rec_sde_tab_dets.col_type||' '||l_rec_sde_tab_dets.def_val);
         l_line_start := '   ,';
      END LOOP;
      append ('   )');
      nm3ddl.debug_tab_varchar (l_tab_vc);
      nm3ddl.execute_tab_varchar (l_tab_vc);
      --
      l_tab_vc.DELETE;
      append ('ALTER TABLE '||c_application_owner||'.'||l_table_name||' ADD CONSTRAINT '||l_table_name||'_PK PRIMARY KEY (iit_ne_id,ne_id_of,nm_begin_mp)',FALSE);
      nm3ddl.debug_tab_varchar (l_tab_vc);
      nm3ddl.execute_tab_varchar (l_tab_vc);
      --
      l_tab_vc.DELETE;
      append ('CREATE INDEX '||c_application_owner||'.'||l_table_name||'_IX ON '||c_application_owner||'.'||l_table_name||'(ne_id_of)',FALSE);
      nm3ddl.debug_tab_varchar (l_tab_vc);
      nm3ddl.execute_tab_varchar (l_tab_vc);
      --
   END IF;
--
--   nm_debug.DEBUG('Create the batch file necessary for loadevents');
--
   l_feature_table_name := get_inv_sde_view_name(p_inv_type);
--
   start_rows;
--
   OPEN  cs_batchfile (c_events_table  => l_table_name
                      ,c_feature_table => l_feature_table_name
                      ,c_server        => c_server_name
                      ,c_username      => c_application_owner
                      ,c_pwd           => p_app_owner_pwd
                      ,c_service       => c_sde_service
                      );
   FETCH cs_batchfile
    BULK COLLECT
    INTO l_tab_row_order
        ,l_tab_data;
   CLOSE cs_batchfile;
--
   FOR i IN 1..l_tab_data.COUNT
    LOOP
      l_tab_varchar(l_tab_varchar.COUNT+1) := l_tab_data(i);
   END LOOP;
--
   l_inv_view_name := nm3inv.derive_inv_type_view_name(p_inv_type);
--
   l_string :=   'sdelayer'
               ||' -o alter -l '||l_table_name||',shape'
               ||' -e n';
   IF l_rec_nit.nit_pnt_or_cont = 'P'
    THEN
      l_string := l_string||'p';
   ELSE
      l_string := l_string||'ls';
   END IF;
   l_string :=   l_string
               ||'M+'
               ||' -q -N'
               ||' -u '||c_application_owner
               ||' -p '||p_app_owner_pwd
               ||' -s '||c_server_name
               ||' -i '||c_sde_service;
--
   l_tab_varchar(l_tab_varchar.COUNT+1) := l_string;
--
   l_string :=   'sdetable'
               ||' -o create_view'||c_carot||c_line_feed
               ||' -T '||l_feature_table_name||c_carot||c_line_feed
               ||' -t "'||l_table_name||','||l_inv_view_name||'"'||c_carot||c_line_feed
               ||' -w "'||l_table_name||'.iit_ne_id='||l_inv_view_name||'.iit_ne_id"'||c_carot||c_line_feed;
   l_line_start := ' -c ';
   FOR i IN 1..l_tab_sde_tab_dets.COUNT
    LOOP
      l_rec_sde_tab_dets := l_tab_sde_tab_dets(i);
      l_string := l_string||l_line_start||l_table_name||'.'||l_rec_sde_tab_dets.col_name||c_carot||c_line_feed;
      l_line_start := ',';
   END LOOP;
   FOR cs_rec IN (SELECT column_name
                   FROM  all_tab_columns
                  WHERE  owner        = c_application_owner
                   AND   table_name   = l_inv_view_name
                   AND   column_name != 'IIT_NE_ID'
                  ORDER BY column_id
                 )
    LOOP
      l_string := l_string||l_line_start||l_inv_view_name||'.'||cs_rec.column_name||c_carot||c_line_feed;
   END LOOP;
   l_string := l_string||l_line_start||l_table_name||'.shape'
                       ||' -u '||c_application_owner
                       ||' -p '||p_app_owner_pwd
                       ||' -s '||c_server_name
                       ||' -i '||c_sde_service;
--
   l_tab_varchar(l_tab_varchar.COUNT+1) := l_string;
--
   end_rows;
--
   write_file_internal (p_filename  => 'loadevents_'||p_inv_type||'.bat'
                       ,p_tab_lines => l_tab_varchar
                       );
--
   start_rows;
--
   FOR i IN 1..l_tab_data.COUNT
    LOOP
      l_tab_varchar(l_tab_varchar.COUNT+1) := l_tab_data(i)||' -nilsonly'||c_redirect;
   END LOOP;
--
   end_rows;
--
   write_file_internal (p_filename  => get_update_batch_file_name(p_inv_type)
                       ,p_tab_lines => l_tab_varchar
                       );
--
--   nm_debug.DEBUG('Insert the data into the table');
--
   l_tab_vc.DELETE;
   append ('INSERT INTO '||c_application_owner||'.'||l_table_name,FALSE);
   l_line_start := '      (';
   FOR i IN 1..l_tab_sde_tab_dets.COUNT
    LOOP
      l_rec_sde_tab_dets := l_tab_sde_tab_dets(i);
      append (l_line_start||l_rec_sde_tab_dets.col_name);
      l_line_start := '      ,';
   END LOOP;
   append ('      )');
   l_line_start := 'SELECT ';
   FOR i IN 1..l_tab_sde_tab_dets.COUNT
    LOOP
      l_rec_sde_tab_dets := l_tab_sde_tab_dets(i);
      append (l_line_start||l_rec_sde_tab_dets.source);
      l_line_start := '      ,';
   END LOOP;
   append (' FROM  '||nm3inv_view.derive_nw_inv_type_view_name(p_inv_type)||' a');
   OPEN  cs_route_gt;
   FETCH cs_route_gt
    INTO l_rec_route_gt;
   CLOSE cs_route_gt;
   append ('      ,'||l_rec_route_gt.gt_feature_table||' b');
   append ('WHERE  a.ne_id_of = b.'||l_rec_route_gt.gt_feature_pk_column);
--
--   nm3ddl.debug_tab_varchar (l_tab_vc);
--
   nm3ddl.execute_tab_varchar (l_tab_vc);
--
--   nm_debug.DEBUG('Compute the stats');
--
   l_tab_vc.DELETE;
   append ('ANALYZE TABLE '||c_application_owner||'.'||l_table_name||' COMPUTE STATISTICS',FALSE);
 --  nm3ddl.debug_tab_varchar (l_tab_vc);
   nm3ddl.execute_tab_varchar (l_tab_vc);
--
  exec_command( pi_command  => 'loadevents_'||p_inv_type||'.bat'
               ,pi_username => c_application_owner
              );
--
   nm_debug.proc_end(g_package_name,'create_sde_inv_shape_table');
--
END create_sde_inv_shape_table;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_sde_table_name (p_inv_type nm_inv_types.nit_inv_type%TYPE
                                ) RETURN user_tables.table_name%TYPE IS
BEGIN
   RETURN nm3inv_view.derive_nw_inv_type_view_name(p_inv_type)||'_SDE';
END get_inv_sde_table_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_sde_view_name (p_inv_type nm_inv_types.nit_inv_type%TYPE
                               ) RETURN user_tables.table_name%TYPE IS
BEGIN
   RETURN get_inv_sde_table_name(p_inv_type)||'_VIEW';
END get_inv_sde_view_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_process_mem_change_job (p_first    date     DEFAULT SYSDATE
                                        ,p_interval varchar2 DEFAULT 'SYSDATE+1'
                                        ) IS
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
   l_existing_job_id      user_jobs.job%TYPE;
   l_job_id               user_jobs.job%TYPE;
   l_job_command CONSTANT user_jobs.what%TYPE := c_application_owner||'.'||g_package_name||'.process_membership_changes;';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'submit_process_mem_change_job');
--
   OPEN  cs_job (l_job_command);
   FETCH cs_job INTO l_existing_job_id;
   IF cs_job%FOUND
    THEN
      CLOSE cs_job;
      RAISE_APPLICATION_ERROR(-20001,'Such a job already exists - JOB_ID : '||l_existing_job_id);
   END IF;
   CLOSE cs_job;
--
   DBMS_JOB.SUBMIT
       (job       => l_job_id
       ,what      => l_job_command
       ,next_date => p_first
       ,INTERVAL  => p_interval
       );
--
   nm_debug.proc_end(g_package_name,'submit_process_mem_change_job');
--
END submit_process_mem_change_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_membership_changes IS
--
   CURSOR cs_nmst IS
   SELECT nmst_id
         ,nmst_ne_id_in
         ,nmst_ne_id_of
         ,nmst_begin_mp
         ,nmst_end_mp
         ,nmst_obj_type
         ,nmst_start_date
         ,nmst_end_date
         ,nmst_action
         ,ROWID
    FROM  nm_members_sde_temp
    ORDER BY nmst_id
   FOR UPDATE OF nmst_id NOWAIT;
--
   CURSOR cs_inv_types IS
   SELECT nmst_obj_type
    FROM nm_members_sde_temp
   GROUP BY nmst_obj_type;
--
   l_tab_nmst_id           nm3type.tab_number;
   l_tab_nmst_ne_id_in     nm3type.tab_number;
   l_tab_nmst_ne_id_of     nm3type.tab_number;
   l_tab_nmst_begin_mp     nm3type.tab_number;
   l_tab_nmst_end_mp       nm3type.tab_number;
   l_tab_nmst_obj_type     nm3type.tab_varchar4;
   l_tab_nmst_start_date   nm3type.tab_date;
   l_tab_nmst_end_date     nm3type.tab_date;
   l_tab_nmst_action       nm3type.tab_varchar4;
   l_tab_nmst_process_type nm3type.tab_varchar30;
   l_tab_rowid             nm3type.tab_rowid;
--
   l_tab_obj_type_nullify  nm3type.tab_varchar4;
   l_tab_obj_type_insert   nm3type.tab_varchar4;
   l_tab_obj_type_delete   nm3type.tab_varchar4;
   l_tab_inv_types         nm3type.tab_varchar4;
--
   c_sysdate CONSTANT      date := TRUNC(SYSDATE);
--
   c_del_record     CONSTANT varchar2(10) := 'DELETE';
   c_ins_record     CONSTANT varchar2(10) := 'INSERT';
   c_nullify_record CONSTANT varchar2(10) := 'UPDATE';
--
   l_some_to_do              boolean := FALSE;
--
   l_sql                   varchar2(4000);
--
   l_in    number;
   l_of    number;
   l_begin number;
   l_end   number;
   l_d_unq varchar2(30);
   l_r_unq varchar2(30);
   l_r_id  number;
   l_r_s   number;
   l_r_e   number;
--
   l_dummy   PLS_INTEGER;
   l_cur     nm3type.ref_cursor;
   l_found   BOOLEAN;
--
   PROCEDURE put_obj_type_into_array (pi_obj_type     IN            varchar2
                                     ,po_obj_type_arr IN OUT NOCOPY nm3type.tab_varchar4
                                     ) IS
      l_obj_type_found      boolean := FALSE;
   BEGIN
--
      FOR j IN 1..po_obj_type_arr.COUNT
       LOOP
         IF po_obj_type_arr(j) = pi_obj_type
           THEN
             l_obj_type_found := TRUE;
            EXIT;
         END IF;
      END LOOP;
--
      IF NOT l_obj_type_found
       THEN
          po_obj_type_arr(po_obj_type_arr.COUNT+1) := pi_obj_type;
      END IF;
--
   END put_obj_type_into_array;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_membership_changes');
--
-- Get all of the records in the table
--
   OPEN  cs_nmst;
   FETCH cs_nmst BULK COLLECT INTO l_tab_nmst_id
                                  ,l_tab_nmst_ne_id_in
                                  ,l_tab_nmst_ne_id_of
                                  ,l_tab_nmst_begin_mp
                                  ,l_tab_nmst_end_mp
                                  ,l_tab_nmst_obj_type
                                  ,l_tab_nmst_start_date
                                  ,l_tab_nmst_end_date
                                  ,l_tab_nmst_action
                                  ,l_tab_rowid;
   CLOSE cs_nmst;
--
-- Loop through the records
--
   FOR i IN 1..l_tab_nmst_id.COUNT
    LOOP
--
      IF    l_tab_nmst_action(i)        = 'D'
       OR   l_tab_nmst_end_date(i)     <= c_sysdate
--       OR  (l_tab_nmst_action(i)        = 'X'
--            AND l_tab_nmst_end_date(i) <= c_sysdate
--           )
       THEN
         --
         -- If this is a delete, then get rid of the spatial record altogether
         --
         l_tab_nmst_process_type(i) := c_del_record;
         l_some_to_do               := TRUE;
         --
      ELSIF l_tab_nmst_action(i)     = 'I'
       AND  l_tab_nmst_start_date(i) <= c_sysdate
       THEN
         --
         -- If this is an insert then create the record in the spatial table
         --
         l_tab_nmst_process_type(i) := c_ins_record;
         l_some_to_do               := TRUE;
      ELSIF l_tab_nmst_start_date(i) > c_sysdate
       OR   l_tab_nmst_end_date(i)   > c_sysdate
       THEN
         --
         -- If this is a update/insert which takes effect in the future
         --  then leave the record alone, and it'll get processed later
         --
         l_tab_nmst_process_type(i) := NULL;
      ELSE
         --
         -- This is an update so nullify the shape in the spatial table
         --
         l_tab_nmst_process_type(i) := c_nullify_record;
         l_some_to_do               := TRUE;
      END IF;
--
      l_in    := l_tab_nmst_ne_id_in(i);
      l_of    := l_tab_nmst_ne_id_of(i);
      l_begin := l_tab_nmst_begin_mp(i);
      l_end   := l_tab_nmst_end_mp(i);
--
--RAC - here, compute the datum unique, route ne_id, route unique, route start and end slk
--      when the invviewslk option is set.
--

      IF c_inv_view_slk
           THEN
         IF l_tab_nmst_process_type(i)    = c_del_record

          THEN
            l_sql :=           'DELETE '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
                    ||CHR(10)||'WHERE  iit_ne_id   = :ne_id_in '
                    ||CHR(10)||' AND   ne_id_of    = :ne_id_of '
                    ||CHR(10)||' AND   nm_begin_mp = :begin_mp ';
            EXECUTE IMMEDIATE l_sql USING l_in
                                         ,l_of
                                         ,l_begin;
         ELSE
            l_d_unq := nm3net.get_ne_unique( l_of );
            l_r_id  := nm3net.get_parent_ne_id(l_of, nm3net.get_parent_type( nm3net.get_nt_type(l_of)));
            l_r_unq := nm3net.get_ne_unique( l_r_id );
            l_r_s   := nm3lrs.get_set_offset( l_r_id, l_of, l_begin );
            l_r_e   := nm3lrs.get_set_offset( l_r_id, l_of, l_end );

            IF l_tab_nmst_process_type(i) = c_ins_record
             THEN
               l_sql :=   'DECLARE'
               ||CHR(10)||'   l_nmst_ne_id_in NUMBER := :nmst_ne_id_in;'
               ||CHR(10)||'   l_nmst_ne_id_of NUMBER := :nmst_ne_id_of;'
               ||CHR(10)||'   l_nmst_begin_mp NUMBER := :nmst_begin_mp;'
               ||CHR(10)||'   l_nmst_end_mp   NUMBER := :nmst_end_mp;'
               ||CHR(10)||'   l_datum_unique  nm_elements.ne_unique%TYPE := :datum_unique;'
               ||CHR(10)||'   l_route_ne      NUMBER := :route_ne;'
               ||CHR(10)||'   l_route_ne_unique  nm_elements.ne_unique%TYPE := :route_ne_unique;'
               ||CHR(10)||'   l_st_slk        NUMBER := :st_slk;'
               ||CHR(10)||'   l_end_slk       NUMBER := :end_slk;'
               ||CHR(10)||'   l_rec '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))||'%ROWTYPE;'
               ||CHR(10)||'BEGIN'
               ||CHR(10)||'   l_rec.iit_ne_id              := l_nmst_ne_id_in;'
               ||CHR(10)||'   l_rec.ne_id_of               := l_nmst_ne_id_of;'
               ||CHR(10)||'   l_rec.nm_begin_mp            := least(l_nmst_begin_mp, l_nmst_end_mp);'
               ||CHR(10)||'   l_rec.nm_end_mp              := greatest(l_nmst_begin_mp, l_nmst_end_mp);'
               ||CHR(10)||'   l_rec.datum_ne_unique        := l_datum_unique;'
               ||CHR(10)||'   l_rec.route_ne_id            := l_route_ne;'
               ||CHR(10)||'   l_rec.route_ne_unique        := l_route_ne_unique;'
               ||CHR(10)||'   l_rec.route_slk_start        := l_st_slk;'
               ||CHR(10)||'   l_rec.route_slk_end          := l_end_slk;'
               ||CHR(10)||'   INSERT INTO '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
               ||CHR(10)||'          (iit_ne_id, ne_id_of, nm_begin_mp, nm_end_mp, '
               ||CHR(10)||'           datum_ne_unique, route_ne_id, route_ne_unique, route_slk_start, route_slk_end )'
               ||CHR(10)||'   VALUES (l_rec.iit_ne_id, l_rec.ne_id_of, l_rec.nm_begin_mp, l_rec.nm_end_mp, '
               ||CHR(10)||'           l_rec.datum_ne_unique, l_rec.route_ne_id, l_rec.route_ne_unique, l_rec.route_slk_start, l_rec.route_slk_end );'
               ||CHR(10)||'EXCEPTION'
               ||CHR(10)||'   WHEN dup_val_on_index'
               ||CHR(10)||'    THEN'
               ||CHR(10)||'      UPDATE '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
               ||CHR(10)||'       SET   nm_end_mp         = l_rec.nm_end_mp'
               ||CHR(10)||'            ,datum_ne_unique   = l_rec.datum_ne_unique'
               ||CHR(10)||'            ,route_ne_id       = l_rec.route_ne_id'
               ||CHR(10)||'            ,route_ne_unique   = l_rec.route_ne_unique'
               ||CHR(10)||'            ,route_slk_start   = l_rec.route_slk_start'
               ||CHR(10)||'            ,route_slk_end     = l_rec.route_slk_end'
               ||CHR(10)||'      WHERE  iit_ne_id         = l_rec.iit_ne_id'
               ||CHR(10)||'       AND   ne_id_of          = l_rec.ne_id_of'
               ||CHR(10)||'       AND   nm_begin_mp       = l_rec.nm_begin_mp;'
               ||CHR(10)||'END;';
               EXECUTE IMMEDIATE l_sql USING l_in
                                            ,l_of
                                            ,l_begin
                                            ,l_end
                                            ,l_d_unq
                                            ,l_r_id
                                            ,l_r_unq
                                            ,l_r_s
                                            ,l_r_e;

            ELSIF l_tab_nmst_process_type(i) = c_nullify_record
             THEN
               l_sql :=           'UPDATE '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
                       ||CHR(10)||' SET   shape       = Null'
                       ||CHR(10)||'      ,nm_begin_mp = :begin_mp'
                       ||CHR(10)||'      ,nm_end_mp   = :end_mp'
                       ||CHR(10)||'      ,route_slk_start   = :st_slk'
                       ||CHR(10)||'      ,route_slk_end   = :end_slk'
                       ||CHR(10)||'WHERE  iit_ne_id   = :ne_id_in'
                       ||CHR(10)||' AND   ne_id_of    = :ne_id_of';
               EXECUTE IMMEDIATE l_sql USING l_begin
                                            ,l_end
                                            ,l_r_s
                                            ,l_r_e
                                            ,l_in
                                            ,l_of;
            END IF;
             END IF;

      ELSE

--RAC Do not use the route stuff

         IF l_tab_nmst_process_type(i)    = c_del_record
          THEN
            l_sql :=           'DELETE '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
                    ||CHR(10)||'WHERE  iit_ne_id   = :ne_id_in '
                    ||CHR(10)||' AND   ne_id_of    = :ne_id_of '
                    ||CHR(10)||' AND   nm_begin_mp = :begin_mp ';
            EXECUTE IMMEDIATE l_sql USING l_in
                                         ,l_of
                                         ,l_begin;
         ELSIF l_tab_nmst_process_type(i) = c_ins_record
          THEN
               l_sql :=   'DECLARE'
               ||CHR(10)||'   l_nmst_ne_id_in NUMBER := :nmst_ne_id_in;'
               ||CHR(10)||'   l_nmst_ne_id_of NUMBER := :nmst_ne_id_of;'
               ||CHR(10)||'   l_nmst_begin_mp NUMBER := :nmst_begin_mp;'
               ||CHR(10)||'   l_nmst_end_mp   NUMBER := :nmst_end_mp;'
               ||CHR(10)||'   l_rec '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))||'%ROWTYPE;'
               ||CHR(10)||'BEGIN'
               ||CHR(10)||'   l_rec.iit_ne_id              := l_nmst_ne_id_in;'
               ||CHR(10)||'   l_rec.ne_id_of               := l_nmst_ne_id_of;'
               ||CHR(10)||'   l_rec.nm_begin_mp            := least(l_nmst_begin_mp, l_nmst_end_mp);'
               ||CHR(10)||'   l_rec.nm_end_mp              := greatest(l_nmst_begin_mp, l_nmst_end_mp);'
               ||CHR(10)||'   INSERT INTO '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
               ||CHR(10)||'          (iit_ne_id, ne_id_of, nm_begin_mp, nm_end_mp)'
               ||CHR(10)||'   VALUES (l_rec.iit_ne_id, l_rec.ne_id_of, l_rec.nm_begin_mp, l_rec.nm_end_mp );'
               ||CHR(10)||'EXCEPTION'
               ||CHR(10)||'   WHEN dup_val_on_index'
               ||CHR(10)||'    THEN'
               ||CHR(10)||'      UPDATE '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
               ||CHR(10)||'       SET   nm_end_mp         = l_rec.nm_end_mp'
               ||CHR(10)||'      WHERE  iit_ne_id         = l_rec.iit_ne_id'
               ||CHR(10)||'       AND   ne_id_of          = l_rec.ne_id_of'
               ||CHR(10)||'       AND   nm_begin_mp       = l_rec.nm_begin_mp;'
               ||CHR(10)||'END;';
            EXECUTE IMMEDIATE l_sql USING l_in
                                         ,l_of
                                         ,l_begin
                                         ,l_end;
         ELSIF l_tab_nmst_process_type(i) = c_nullify_record
          THEN
            l_sql :=           'UPDATE '||get_inv_sde_table_name(l_tab_nmst_obj_type(i))
                    ||CHR(10)||' SET   shape       = Null'
                    ||CHR(10)||'WHERE  iit_ne_id   = :ne_id_in'
                    ||CHR(10)||' AND   ne_id_of    = :ne_id_of'
                    ||CHR(10)||' AND   nm_begin_mp = :begin_mp';
            EXECUTE IMMEDIATE l_sql USING l_in
                                         ,l_of
                                         ,l_begin;
         END IF;
          END IF;
--
   END LOOP;
--
  -- If required to run then update_loadevents batch file.
  -- get then inv_types affected an run
  -- update_loadevents_batch file for each inv_type(nm_obj_type)
  --
  IF l_some_to_do
   THEN
     --
     OPEN  cs_inv_types;
     FETCH cs_inv_types
      BULK COLLECT
      INTO l_tab_inv_types;
     CLOSE cs_inv_types;
     --
     -- commit the changes so that the batch file will pick them up
     -- otherwise loadevents in
     -- its new session will be locked out.
     COMMIT;
     --
     IF c_run_now
     THEN
        FOR i IN 1..l_tab_inv_types.COUNT
         LOOP
           exec_command ( pi_command  =>  get_update_batch_file_name(l_tab_inv_types(i))
                         ,pi_username => c_application_owner
                        );
        END LOOP;
     END IF;
     --
     -- Get rid of the records out of the transient table
     --
      FORALL i IN 1..l_tab_rowid.COUNT
         DELETE nm_members_sde_temp
         WHERE  ROWID = l_tab_rowid(i)
          AND   l_tab_nmst_process_type(i) IS NOT NULL;
   --
      IF c_inv_view_slk
       THEN
         change_sde_measures;
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'process_membership_changes');
--
END process_membership_changes;
--
-------------------------------------------------------------------------------------
--

PROCEDURE change_sde_measures IS

CURSOR get_affected_tables IS

  SELECT gt_feature_table
  FROM gis_themes_all
  WHERE gt_feature_table IS NOT NULL
  AND   gt_route_theme = 'N';

v_tab_names nm3type.tab_varchar30;

BEGIN

  nm_debug.proc_start(g_package_name,'change_sde_measures');

  LOCK TABLE nm_sde_temp_rescale IN EXCLUSIVE MODE NOWAIT;

--nm_debug.debug_on;

  OPEN get_affected_tables;
  FETCH get_affected_tables BULK COLLECT INTO v_tab_names;
  CLOSE get_affected_tables;

  FOR i IN 1..v_tab_names.COUNT LOOP

/*
    nm_debug.debug(   'update '||v_tab_names(i)||
                 chr(10)||'set route_slk_start = least(   nm3lrs.get_set_offset( route_ne_id, ne_id_of, nm_begin_mp )),'||
                         chr(10)||'    route_slk_end   = greatest(nm3lrs.get_set_offset( route_ne_id, ne_id_of, nm_end_mp ))'||
                         chr(10)||'where exists ( select 1 from nm_sde_temp_rescale '||
                         chr(10)||'               where nmtr_ne_id_of = ne_id_of )');
*/
    EXECUTE IMMEDIATE 'update '||v_tab_names(i)||
                 CHR(10)||'set route_slk_start = least(   nm3lrs.get_set_offset( route_ne_id, ne_id_of, nm_begin_mp )),'||
                         CHR(10)||'    route_slk_end   = greatest(nm3lrs.get_set_offset( route_ne_id, ne_id_of, nm_end_mp ))'||
                         CHR(10)||'where exists ( select 1 from nm_sde_temp_rescale '||
                         CHR(10)||'               where nmtr_ne_id_of = ne_id_of )';

  END LOOP;

  DELETE nm_sde_temp_rescale;

  nm_debug.proc_end(g_package_name,'change_sde_measures');

EXCEPTION
--
-- The rather drastic exception handler is due to the fact that the tables may not have been
-- generated, some (as in development) have been generated with no route measure attributes
-- on the table.
--
  WHEN others THEN
    DELETE nm_sde_temp_rescale;

END change_sde_measures;
--
-------------------------------------------------------------------------------------
--
PROCEDURE exec_command( pi_command  varchar2
                       ,pi_username varchar2 DEFAULT USER
                      )
IS
  l_rtrn number;
BEGIN
  nm_debug.proc_start(g_package_name , 'exec_command');

  IF c_run_now
  THEN

    nm3javautil.exec_sde_bat_file( pi_filename => pi_command
                                 , pi_username => pi_username);

  END IF;

  nm_debug.proc_end(g_package_name , 'exec_command');
END exec_command;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_file_internal (p_filename  VARCHAR2
                              ,p_tab_lines nm3type.tab_varchar32767
                              ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_rec_nuf               nm_upload_files%ROWTYPE;
   c_mime_type    CONSTANT varchar2(30) := 'application/unknown';
   c_sysdate      CONSTANT date         := SYSDATE;
   c_content_type CONSTANT varchar2(4)  := 'BLOB';
   c_dad_charset  CONSTANT varchar2(5)  := 'ascii';
   l_tab_lines             nm3type.tab_varchar32767 := p_tab_lines;
--
BEGIN
--
   IF c_utlfiledir_set
    THEN
      nm3file.write_file
            (location     => c_file_dest
            ,filename     => p_filename
            ,max_linesize => 32767
            ,all_lines    => p_tab_lines
            );
   ELSE
--
      l_rec_nuf.name         := p_filename;
      l_rec_nuf.mime_type    := c_mime_type;
      l_rec_nuf.dad_charset  := c_dad_charset;
      l_rec_nuf.last_updated := c_sysdate;
      l_rec_nuf.content_type := c_content_type;
      l_rec_nuf.doc_size     := 0;
      put_line_feed_on_end (l_tab_lines,l_rec_nuf.doc_size);
      l_rec_nuf.blob_content := nm3clob.clob_to_blob(nm3clob.tab_varchar_to_clob (pi_tab_vc => l_tab_lines));
--
      nm3del.del_nuf (pi_name            => l_rec_nuf.name
                     ,pi_raise_not_found => FALSE
                     );
      nm3ins.ins_nuf (l_rec_nuf);
--
   END IF;
--
   COMMIT;
--
END write_file_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE put_line_feed_on_end (p_tab_lines IN OUT NOCOPY nm3type.tab_varchar32767
                               ,p_size      IN OUT number
                               ,p_lf        IN     varchar2 DEFAULT c_line_feed
                               ) IS
BEGIN
   FOR i IN 1..p_tab_lines.COUNT
    LOOP
      p_tab_lines(i) := p_tab_lines(i)||p_lf;
      p_size         := p_size + LENGTH(p_tab_lines(i));
   END LOOP;
END put_line_feed_on_end;
--
-----------------------------------------------------------------------------
--
END nm3inv_sde;
/
