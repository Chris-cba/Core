CREATE OR REPLACE procedure mig_step_8_ind_inv
(pi_log_file_location IN VARCHAR2
,pi_inv_type              IN varchar2
,pi_sys_Flag              IN varchar2
,pi_go_on in boolean
) IS
--
--  Replacement for the Step 8 code migrate inv
-- this will call the package code but for specified inv types
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/mig/mig_step_8_ind_inv.prc-arc   2.1   Jul 04 2013 16:49:08   James.Wadsworth  $
--       Module Name      : $Workfile:   mig_step_8_ind_inv.prc  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:47:38  $
--       PVCS Version     : $Revision:   2.1  $
--       Based on SCCS version :
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   2.1  $';
  g_package_name CONSTANT VARCHAR2(30) := 'mig_step_8_ind_inv';
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
--
  TYPE l_ref IS REF CURSOR;
--
   get_inv_types l_ref;
   l_sql Nm3type.max_varchar2 := 'SELECT ity_inv_code '||
                                 '      ,ity_sys_flag '||
                                 'FROM inv_type_translations '||
 'WHERE ity_inv_Code>'''||pi_inv_type||''''||
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

  l_tab_item_id Nm3type.tab_number;
   l_count       PLS_INTEGER := 0;

BEGIN
--

   nm2_nm3_migration.initialise(pi_log_file_location  => pi_log_file_location
              ,pi_log_file_name      => 'worcs_mig_bits'||TO_CHAR(SYSDATE, 'DDMONYYYY_HH24MISS')||'.LOG'
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
        nm2_nm3_migration.analyse_inventory_tables(1);
      END IF;
      nm2_nm3_migration.pc_inv_mig_nm2_nm3_by_id (l_tab_item_id(i));
   END LOOP;
   nm2_nm3_migration.do_optional_commit;




  if pi_go_on then

   OPEN  get_inv_types FOR l_sql;
   FETCH get_inv_types BULK COLLECT INTO l_tab_inv_type, l_tab_sys_flag;
   CLOSE get_inv_types;
   -- set up the long op for inventory migration
   FOR i IN 1..l_tab_inv_type.COUNT
    LOOP
      nm2_nm3_migration.append_log_content(pi_text => 'Processing Inventory Type ['||l_tab_inv_type(i)||'] on network '||l_tab_sys_flag(i));
      nm2_nm3_migration.pc_inv_mig_nm2_nm3_by_type (l_tab_inv_type(i), l_tab_sys_flag(i), FALSE);
   END LOOP;
--
   nm2_nm3_migration.append_log_content('Analysing inventory tables');
   nm2_nm3_migration.analyse_inventory_tables(100);
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
END worcs_mig_bits;
/
