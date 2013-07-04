CREATE OR REPLACE PACKAGE BODY Pre_Migration_Check AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/mig/pre_migration_check.pkb-arc   2.4   Jul 04 2013 16:49:10   James.Wadsworth  $
--       Module Name      : $Workfile:   pre_migration_check.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:49:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:46:22  $
--       PVCS Version     : $Revision:   2.4  $
--
--
--   Author : Darren Cope/Stuart Marshall/Graeme Johnson
--
--   pre_migration_check body
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
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '"$Revision:   2.4  $"';

  g_package_name CONSTANT VARCHAR2(30) := 'pre_migration_check';

  g_proc_name    VARCHAR2(50);

  g_error      VARCHAR2(2000);

  g_pass       VARCHAR2(10) := 'PASS';
  g_fail       VARCHAR2(10) := 'FAIL';
  g_untested   VARCHAR2(10) := 'UNTESTED';
  g_note       VARCHAR2(10) := 'NOTE';


 CURSOR c_chk_class IS
 SELECT pmcl_code
       ,pmcl_label
 FROM   PRE_MIGRATION_CHK_CLASSES
 ORDER BY pmcl_order ASC;


 CURSOR c_chks(pi_pmcl_code PRE_MIGRATION_CHK_CLASSES.pmcl_code%TYPE) IS
 SELECT pmc_ref
       ,pmc_description
       ,pmc_check_label
       ,pmc_outcome
       ,pmc_notes
       ,ROUND(DECODE(pmc_end
                    ,pmc_start,1
                    ,(pmc_end - pmc_start) * (60*60*24)
                     ),1) pmc_execution_time
       ,Pre_Migration_Check.get_count_issues (pmc_ref)
 FROM   PRE_MIGRATION_CHK
 WHERE  pmc_pmcl_code = NVL(pi_pmcl_code,pmc_pmcl_code)
 ORDER  BY pmc_outcome,pmc_order ASC;

 CURSOR c_chk_labels(cp_pmci_pmc_ref IN PRE_MIGRATION_CHK_ISSUES.pmci_pmc_ref%TYPE) IS
 SELECT DISTINCT pmci_issue_label
 FROM   PRE_MIGRATION_CHK_ISSUES
 WHERE  pmci_pmc_ref = cp_pmci_pmc_ref;


 CURSOR c_chk_issues(cp_pmci_pmc_ref     IN PRE_MIGRATION_CHK_ISSUES.pmci_pmc_ref%TYPE
                    ,cp_pmci_issue_label IN PRE_MIGRATION_CHK_ISSUES.pmci_issue_label%TYPE) IS
 SELECT REPLACE(pmci_details,CHR(10),'<BR>')
 FROM   PRE_MIGRATION_CHK_ISSUES
 WHERE  pmci_pmc_ref = cp_pmci_pmc_ref
 AND    pmci_issue_label = cp_pmci_issue_label;


 TYPE tab_pmcl_code        IS TABLE OF PRE_MIGRATION_CHK_CLASSES.pmcl_code%TYPE INDEX BY BINARY_INTEGER;
 TYPE tab_pmcl_label       IS TABLE OF PRE_MIGRATION_CHK_CLASSES.pmcl_label%TYPE INDEX BY BINARY_INTEGER;

 TYPE tab_pmc_ref          IS TABLE OF PRE_MIGRATION_CHK.pmc_ref%TYPE INDEX BY BINARY_INTEGER;
 TYPE tab_pmc_description  IS TABLE OF PRE_MIGRATION_CHK.pmc_description%TYPE INDEX BY BINARY_INTEGER;
 TYPE tab_pmc_outcome      IS TABLE OF PRE_MIGRATION_CHK.pmc_outcome%TYPE INDEX BY BINARY_INTEGER;
 TYPE tab_pmc_notes        IS TABLE OF PRE_MIGRATION_CHK.pmc_notes%TYPE INDEX BY BINARY_INTEGER;
 TYPE tab_number           IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

 TYPE tab_pmci_issue_label IS TABLE OF PRE_MIGRATION_CHK_ISSUES.pmci_issue_label%TYPE INDEX BY BINARY_INTEGER;
 TYPE tab_pmci_details     IS TABLE OF PRE_MIGRATION_CHK_ISSUES.pmci_details%TYPE INDEX BY BINARY_INTEGER;


 g_tab_pmcl_code                 tab_pmcl_code;
 g_tab_pmcl_label                tab_pmcl_label;
 g_tab_pmc_ref                   tab_pmc_ref;
 g_tab_pmc_description           tab_pmc_description;
 g_tab_pmc_label                 tab_pmc_description;
 g_tab_pmc_outcome               tab_pmc_outcome;
 g_tab_pmc_notes                 tab_pmc_notes;
 g_tab_pmc_execution_time        tab_number;
 g_tab_pmc_count_issues          tab_number;

 g_tab_pmci_issue_label    tab_pmci_issue_label;
 g_tab_pmci_details        tab_pmci_details;

 g_report UTL_FILE.FILE_TYPE;
 g_file_content            tab_varchar32767;

 g_instance_details        VARCHAR2(2000);

 TYPE tab_hpr_product      IS TABLE OF HIG_PRODUCTS.hpr_product%TYPE INDEX BY BINARY_INTEGER;
 TYPE tab_hpr_version      IS TABLE OF HIG_PRODUCTS.hpr_version%TYPE INDEX BY BINARY_INTEGER;

 g_tab_hpr_product         tab_hpr_product;
 g_tab_hpr_version         tab_hpr_version;
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
PROCEDURE append( p_text VARCHAR2 ) IS

BEGIN
  g_sql := g_sql || p_text || CHR(10);
END;
--
-----------------------------------------------------------------------------
--
FUNCTION string(pi_string IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
--
   RETURN CHR(39)||pi_string||CHR(39); -- Return 'pi_string'
--
END string;
--
-----------------------------------------------------------------------------
--
FUNCTION get_count_issues(pi_pmci_pmc_ref IN PRE_MIGRATION_CHK_ISSUES.pmci_pmc_ref%TYPE) RETURN NUMBER IS

 l_retval NUMBER;

BEGIN

   SELECT COUNT(pmci_pmc_ref)
   INTO   l_retval
   FROM   PRE_MIGRATION_CHK_ISSUES
   WHERE  pmci_pmc_ref = pi_pmci_pmc_ref;

   RETURN(l_retval);

END get_count_issues;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_pmc_start(pi_pmc_ref     IN PRE_MIGRATION_CHK.pmc_ref%TYPE) IS

BEGIN

  UPDATE PRE_MIGRATION_CHK
  SET    pmc_start = SYSDATE
  WHERE  pmc_ref = pi_pmc_ref;

  COMMIT;

END set_pmc_start;
--
-----------------------------------------------------------------------------
--
PROCEDURE update_pmc_outcome(pi_pmc_ref        IN PRE_MIGRATION_CHK.pmc_ref%TYPE
                            ,pi_pmc_notes      IN PRE_MIGRATION_CHK.pmc_notes%TYPE
                            ,pi_note_over_fail IN BOOLEAN DEFAULT FALSE) IS
PRAGMA AUTONOMOUS_TRANSACTION;

  l_outcome VARCHAR2(10);
BEGIN

 IF get_count_issues(pi_pmci_pmc_ref => g_proc_name) > 0 THEN

  IF pi_note_over_fail THEN
    l_outcome := g_note;
  ELSE
    l_outcome := g_fail;
  END IF;

  UPDATE PRE_MIGRATION_CHK
  SET    pmc_outcome = l_outcome
        ,pmc_notes   = pi_pmc_notes
        ,pmc_end     = SYSDATE
  WHERE  pmc_ref = pi_pmc_ref;

 ELSE

  UPDATE PRE_MIGRATION_CHK
  SET    pmc_outcome = g_pass
        ,pmc_notes   = pi_pmc_notes
        ,pmc_end     = SYSDATE
  WHERE  pmc_ref = pi_pmc_ref;

 END IF;

 COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END update_pmc_outcome;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise_pmc  IS

BEGIN
  g_file_content.DELETE;

  EXECUTE IMMEDIATE('TRUNCATE TABLE PRE_MIGRATION_CHK_ISSUES');

  COMMIT;

  UPDATE PRE_MIGRATION_CHK
  SET    pmc_outcome = g_untested
        ,pmc_notes   = NULL
        ,pmc_start   = NULL
        ,pmc_end     = NULL;

  COMMIT;

  BEGIN
     EXECUTE IMMEDIATE('CREATE INDEX PUS_MIGRATION_IND ON POINT_USAGES(PUS_NODE_ID)');
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

END initialise_pmc;
--
-----------------------------------------------------------------------------
--
PROCEDURE pmci_ins(pi_pmci_pmc_ref     IN PRE_MIGRATION_CHK_ISSUES.pmci_pmc_ref%TYPE
                  ,pi_pmci_issue_label IN PRE_MIGRATION_CHK_ISSUES.pmci_issue_label%TYPE
                  ,pi_pmci_details     IN PRE_MIGRATION_CHK_ISSUES.pmci_details%TYPE
                  ) IS

BEGIN

  INSERT INTO  PRE_MIGRATION_CHK_ISSUES (pmci_pmc_ref
                                       , pmci_issue_label
                                       , pmci_details)
  VALUES (pi_pmci_pmc_ref
         ,NVL(pi_pmci_issue_label,'List of failures (if any)')
         ,SUBSTR(pi_pmci_details, 1, 500));

  COMMIT;
END pmci_ins;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_instance_details IS

 CURSOR c1 IS
 SELECT LOWER(USER||'@'||instance_name||'.'||host_name)||' - DB ver : '||VERSION  v_instance
 FROM v$instance;


BEGIN

  OPEN c1;
  FETCH c1 INTO g_instance_details;
  CLOSE c1;

END set_instance_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_hpr_details  IS

 CURSOR c1 IS
 SELECT hpr_product
       ,hpr_version
 FROM HIG_PRODUCTS
 WHERE hpr_key IS NOT NULL
 ORDER BY 1 ASC;


BEGIN

  OPEN c1;
  FETCH c1 BULK COLLECT INTO g_tab_hpr_product, g_tab_hpr_version;
  CLOSE c1;

END set_hpr_details;
--
-----------------------------------------------------------------------------
--
FUNCTION Get_Unique(p_rse_he_id IN ROAD_SEGS.rse_he_id%TYPE) RETURN VARCHAR2 IS
  CURSOR get_rse_unique (p_rse_he_id IN ROAD_SEGS.rse_he_id%TYPE) IS
  SELECT rse_unique
  FROM   ROAD_SEGS
  WHERE  rse_he_id = p_rse_he_id;

  l_retval ROAD_SEGS.rse_unique%TYPE;
BEGIN
  OPEN  get_rse_unique(p_rse_he_id);
  FETCH get_rse_unique INTO l_retval;
  CLOSE get_rse_unique;

  RETURN l_retval;

END Get_Unique;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_points IS--1
--
---------------------------------------------------------------------------
-- 1.	Points need X,Y (ideally). This is not mandatory but if the system
-- 	is to be used with a GIS then it will be a pre-requisite of
--	successful operation of SDM.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT poi_point_id, poi_grid_east, poi_grid_north
  FROM POINTS;
--

BEGIN

  g_proc_name := 'check_points';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    IF c1rec.poi_grid_east IS NULL
      OR c1rec.poi_grid_north IS NULL
      THEN

        g_error := 'Point ID ('||c1rec.poi_point_id||')';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'List of Invalid Points'
                ,pi_pmci_details     => g_error);


    END IF;
  END LOOP;


  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL
                    ,pi_note_over_fail => TRUE);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE system_start_dates IS --2
--
---------------------------------------------------------------------------
-- 2.	Start dates of everything cannot pre-date the system start date
-- 	(hard-coded). This should be ascertained before onset of migration.
--	The start date should be the earliest possible date that any data
--      may exist in the system. Many of the scripts will reset this date
-- 	to match the occurrence of a date within the NM2 schema. This is
--	prone to difficulties however, especially if some network pre-dates
--	the Norman Conquest as it did in the case of the Warwickshire data.
--	Query the minimum start date on NODES, ROAD_SEGS and INV_ITEMS_ALL.
--	Use this as an appropriate system start date. If this date is
--	nonsense then repair it.
---------------------------------------------------------------------------


  CURSOR c1 IS
  SELECT MIN(pus_start_date)
  FROM POINT_USAGES, NODE_USAGES
  WHERE nou_pus_node_id = pus_node_id
  UNION
  SELECT MIN(rse_start_date)
  FROM ROAD_SEGS
  UNION
  SELECT MIN(iit_created_date)
  FROM INV_ITEMS_ALL
  UNION
  SELECT MIN(iit_cre_date)
  FROM INV_ITEMS_ALL
  ORDER BY 1 ASC;
--
  l_note  PRE_MIGRATION_CHK.pmc_notes%TYPE;
  l_date DATE;
--
BEGIN

  g_proc_name := 'system_start_dates';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1;
  FETCH c1 INTO l_date;
  CLOSE c1;

  l_note := 'Earliest date from nodes, road_segs and inv_items_all is '||NVL(TO_CHAR(l_date, 'DD MON YYYY'),'NO DATE FOUND');

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => l_note);

END;
--
-----------------------------------------------------------------------------
--

PROCEDURE date_triggers IS --3
--
---------------------------------------------------------------------------
-- 3.	Standard date triggers are auto-generated on NM3 tables with
-- 	a start and END date to comply with basic date integrity. Any
--	tables in NM2 (such as HIG_ADMIN_UNITS) with such fields should be
--	tested as much as possible to be valid prior to validation.
-- 4.	Test Node start and END date for discrepancies.
---------------------------------------------------------------------------
--
  TYPE tab_varchar80    IS TABLE OF VARCHAR2(80)    INDEX BY BINARY_INTEGER;
  TYPE tab_date         IS TABLE OF DATE	        INDEX BY BINARY_INTEGER;
--
  l_table_name tab_varchar80;
  l_start_column tab_varchar80;
  l_END_column tab_varchar80;
  l_start_date tab_date;
  l_END_date tab_date;


  CURSOR c1 IS
  SELECT table_name
        ,column_name
  FROM   user_tab_columns u
  WHERE  data_type = 'DATE'
    AND  column_name LIKE '%START_DATE'
    AND EXISTS (SELECT 1
                FROM   PRE_MIGRATION_CHECK_OBJS p
                WHERE  p.product = 'HIG'
                AND    p.object_type = 'T'
                AND    p.object_name = u.table_name);
--
  CURSOR c2( p_table_name     user_tab_columns.table_name%TYPE
            ,p_start_date_col user_tab_columns.column_name%TYPE
           ) IS
  SELECT column_name
  FROM user_tab_columns
  WHERE data_type = 'DATE'
    AND column_name = REPLACE(p_start_date_col, 'START_DATE','END_DATE')
    AND table_name = p_table_name;
--
  TYPE ref_cursor IS REF CURSOR;
  ref_cur ref_cursor;
--
  l_count NUMBER := 0;

  l_column_name user_tab_columns.column_name%TYPE;
  l_dum NUMBER;
--
BEGIN

  g_proc_name := 'date_triggers';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1;
  FETCH c1 BULK COLLECT INTO l_table_name, l_start_column;
  CLOSE c1;

  FOR I IN 1..l_table_name.COUNT LOOP

    OPEN c2(l_table_name(I),l_start_column(I));
    FETCH c2 INTO l_column_name;
    IF c2%NOTFOUND THEN
      CLOSE c2;
    ELSE
      CLOSE c2;
      l_END_column(I) := l_column_name;

      g_sql := NULL;
      append( 'declare' );
      append( 'cursor c1 is' );
      append( 'select 1');
      append( 'from dual' );
      append( 'where exists (select 1' );
      append( '              from  '||l_table_name(I));
      append( '              where '||l_start_column(I)||' > '||l_end_column(I)||');');
      append( 'l_dum number := 0;' );
      append( 'g_error varchar2(2000);' );
      append( 'BEGIN' );
      append( 'open c1;' );
      append( 'fetch c1 into l_dum;' );
      append( 'close c1;' );
      append( 'if l_dum >0 then' );
      append( '   g_error := '''||l_table_name(I)||'.'||l_start_column(I)||' > '||l_table_name(I)||'.'||l_end_column(I)||''';');
      append( '   g_error := g_error ||chr(10)||''select * '||CHR(10)||'from '||LOWER(l_table_name(I))||CHR(10)||'where '||LOWER(l_start_column(I))||' > '||LOWER(l_table_name(I)||'.'||l_end_column(I))||''';');
      append( '   pre_migration_check.pmci_ins (''date_triggers'',null,g_error);' );
      append( 'END if;' );
      append( 'END;' );


      EXECUTE IMMEDIATE g_sql;
    END IF;
  END LOOP;
--

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);



END;
--
-----------------------------------------------------------------------------
--
PROCEDURE nodes_FK_points IS --5
--
---------------------------------------------------------------------------
-- 5.	Nodes need a valid FK to points; points need to be created where
-- 	they don't exist This is performed inside the script but the extent
-- 	of missing points should be ascertained.
---------------------------------------------------------------------------
  CURSOR c_chk1 IS -- node usages with invalid point
  SELECT nou_rse_he_id
        ,nou_pus_node_id
  FROM NODE_USAGES
  WHERE NOT EXISTS (SELECT 'x'
                    FROM   POINT_USAGES
                    WHERE  pus_node_id = nou_pus_node_id);

  CURSOR c_chk2 IS -- node usages with rse
  SELECT nou_rse_he_id
  FROM NODE_USAGES
  WHERE NOT EXISTS (SELECT 'x'
                    FROM   ROAD_SEGS
                    WHERE  rse_he_id = nou_rse_he_id);
--
  CURSOR get_duplicate_nodes IS
  SELECT *
  FROM POINT_USAGES
  WHERE pus_poi_point_id IN (SELECT pus_poi_point_id
                             FROM   POINT_USAGES
                             WHERE  pus_node_id IN (SELECT pus_node_id
                                                    FROM   POINT_USAGES
                                                    GROUP BY pus_node_id
                                                    HAVING COUNT(*) > 1)
                             GROUP BY pus_poi_point_id
                             HAVING COUNT(*) > 1);
--

  TYPE tab_nou_rse_he_id     IS TABLE OF NODE_USAGES.nou_rse_he_id%TYPE      INDEX BY BINARY_INTEGER;
  TYPE tab_nou_pus_node_id   IS TABLE OF NODE_USAGES.nou_pus_node_id%TYPE    INDEX BY BINARY_INTEGER;

  v_tab_nou_rse_he_id        tab_nou_rse_he_id;
  v_tab_nou_pus_node_id      tab_nou_pus_node_id;


  l_pus_node_id POINT_USAGES.pus_node_id%TYPE;
--
BEGIN

  g_proc_name := 'nodes_FK_points';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c_chk1;
  FETCH c_chk1 BULK COLLECT INTO v_tab_nou_rse_he_id
                                ,v_tab_nou_pus_node_id;
  CLOSE c_chk1;


  FOR I IN 1..v_tab_nou_rse_he_id.COUNT LOOP

        g_error := 'RSE_HE_ID ('||v_tab_nou_rse_he_id(I)||') NOU_PUS_NODE_ID ('||v_tab_nou_pus_node_id(I)||')';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Node Usages Associated With Non-Existent Points'
                ,pi_pmci_details     => g_error);


  END LOOP;


  OPEN c_chk2;
  FETCH c_chk2 BULK COLLECT INTO v_tab_nou_rse_he_id;
  CLOSE c_chk2;

  FOR I IN 1..v_tab_nou_rse_he_id.COUNT LOOP


        g_error := 'RSE_HE_ID ('||v_tab_nou_rse_he_id(I)||') ';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Node Usages Associated With Non-Existent Road Segs'
                ,pi_pmci_details     => g_error);

  END LOOP;


  FOR irec IN get_duplicate_nodes LOOP


        g_error := 'Node '||irec.pus_node_id||' points at different points '||irec.pus_poi_point_id;

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Point uages where the same node id points at different points'
                ,pi_pmci_details     => g_error);

  END LOOP;
  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
   update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL
                    ,pi_note_over_fail => TRUE);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE rse_node_date_check IS --6
--
---------------------------------------------------------------------------
-- 6.	node/section date check
---------------------------------------------------------------------------
--
  CURSOR c1 IS
  SELECT nou_rse_he_id
       , nou_pus_node_id
       , pus_start_date
       , rse_start_date
       , rse_unique
  FROM   NODE_USAGES
       , POINT_USAGES
       , ROAD_SEGS
  WHERE nou_node_type IN ('S','E')
  AND   nou_pus_node_id = pus_node_id
  AND   rse_he_id = nou_rse_he_id
  AND   pus_start_date > rse_start_date;

  TYPE tab_nou_rse_he_id     IS TABLE OF NODE_USAGES.nou_rse_he_id%TYPE      INDEX BY BINARY_INTEGER;
  TYPE tab_nou_pus_node_id   IS TABLE OF NODE_USAGES.nou_pus_node_id%TYPE    INDEX BY BINARY_INTEGER;
  TYPE tab_pus_start_date    IS TABLE OF POINT_USAGES.pus_start_date%TYPE    INDEX BY BINARY_INTEGER;
  TYPE tab_rse_start_date    IS TABLE OF ROAD_SEGS.rse_start_date%TYPE       INDEX BY BINARY_INTEGER;
  TYPE tab_rse_unique        IS TABLE OF ROAD_SEGS.rse_unique%TYPE           INDEX BY BINARY_INTEGER;

  v_tab_nou_rse_he_id       tab_nou_rse_he_id;
  v_tab_nou_pus_node_id     tab_nou_pus_node_id;
  v_tab_pus_start_date      tab_pus_start_date;
  v_tab_rse_start_date      tab_rse_start_date;
  v_tab_rse_unique          tab_rse_unique;

--
BEGIN


  g_proc_name :='rse_node_date_check';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1;
  FETCH c1 BULK COLLECT INTO
           v_tab_nou_rse_he_id
         , v_tab_nou_pus_node_id
         , v_tab_pus_start_date
         , v_tab_rse_start_date
         , v_tab_rse_unique;
  CLOSE c1;

  FOR I IN 1..v_tab_nou_rse_he_id.COUNT LOOP

          g_error := 'Node id - '||v_tab_nou_pus_node_id(I)||' start date of '||TO_DATE(v_tab_pus_start_date(I),'DD-MON-RRRR')||' post-dates the start date of.';
          g_error := g_error ||CHR(10)||'Road - '||v_tab_rse_unique(I)||', with a start date of - '||TO_DATE(v_tab_rse_start_date(I),'DD-MON-RRRR');

          ----------------------------------------------------------
          -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
          ----------------------------------------------------------
           pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                   ,pi_pmci_issue_label => NULL
                   ,pi_pmci_details     => g_error);


  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL
                    ,pi_note_over_fail => TRUE);


END;

---------------------------------------------------------------------------
-- 7.	NM_ELEMENT attributes may not be defined correctly in the NM3
-- 	metamodel. Care should be taken that the NM3 metamodel is created
--	correctly to support the NM2 attributes.
---------------------------------------------------------------------------
-- THIS SHOULD BE DONE AS PART OF THE MIGRATION ITSELF AND NOT THE CHECKER.
---------------------------------------------------------------------------

--
-----------------------------------------------------------------------------
--
PROCEDURE check_section_class IS --8
--
---------------------------------------------------------------------------
-- 8.	Section Classes need to be defined in NM3 metamodel. Check section
-- 	classes FK is imposed on source data.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT rse_sys_flag
        ,NVL(rse_scl_sect_class, 'NULL') rse_scl_sect_class
        ,COUNT(*) COUNT
  FROM   ROAD_SEGS
  WHERE NOT EXISTS (SELECT 1
                    FROM   SECTION_CLASSES
                    WHERE  1=1
--removed this line as there is no way to insert the missing data
--the user has no control over the value on scl_road_cat in section class
--migration will resolve as long as there is a value in section classes
--                    and DECODE(scl_road_cat, 'T', 'D', 'L') = rse_sys_flag
                    AND    scl_sect_class = rse_scl_sect_class)
  AND (rse_type = 'S'
  OR (rse_type = 'G' AND rse_gty_group_type = 'LINK'))
  GROUP BY rse_sys_flag, rse_scl_sect_class;
--
  CURSOR no_class IS
  SELECT rse_he_id
        ,rse_unique
        ,rse_scl_sect_class
        ,rse_linkcode
        ,rse_sect_no
        ,rse_agency
  FROM   ROAD_SEGS
  WHERE  (rse_scl_sect_class IS NULL
         OR rse_linkcode IS NULL
         OR rse_sect_no IS NULL
         OR rse_agency IS NULL)
  AND    rse_type = 'S';
--
  l_label PRE_MIGRATION_CHK_ISSUES.pmci_issue_label%TYPE;
BEGIN

  g_proc_name := 'check_section_class';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR v_recs IN c1 LOOP
        g_error := v_recs.rse_sys_flag|| ' '|| v_recs.rse_scl_sect_class||' has '||v_recs.COUNT||' sections defined.';

            ----------------------------------------------------------
            -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
            ----------------------------------------------------------
             pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                     ,pi_pmci_issue_label => 'Records not defined in SECTION_CLASSES'
                     ,pi_pmci_details     => g_error);

  END LOOP;

  FOR irec IN no_class LOOP

    IF irec.rse_scl_sect_class IS NULL THEN
       l_label := 'Sections with no section class defined';
    ELSIF irec.rse_agency IS NULL THEN
       l_label := 'Sections with no agency defined';
    ELSIF irec.rse_linkcode IS NULL THEN
       l_label := 'Sections with no link code defined';
    ELSIF irec.rse_sect_no IS NULL THEN
       l_label := 'Sections with no section number defined';
    END IF;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => l_label
            ,pi_pmci_details     => irec.rse_unique|| ' ('|| irec.rse_he_id||')');

  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END check_section_class;
--
---------------------------------------------------------------------------
-- 9.	Network attributes will be defined as NM3 events, domains will be
-- 	copied to inventory domains, consistency must be checked across all
--	NM2 section attributes such as road environment, carriageway types
--	etc.
---------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
PROCEDURE section_and_group_lengths IS --10
--
---------------------------------------------------------------------------
-- 10.	Section lengths must be non-zero and not null and be an integer
--      Group length must be null
---------------------------------------------------------------------------

  -- sections with invalid length values
  CURSOR c1 IS
  SELECT rse_he_id
       , rse_unique
	   , rse_length
  FROM   ROAD_SEGS RSE
  WHERE  RSE.RSE_TYPE = 'S'
  AND    (
             rse_length < 1
         OR
		     rse_length IS NULL
	 	 OR
		     FLOOR(rse_length) != rse_length
		 );


  -- groups with invalid length values
  CURSOR c2 IS
  SELECT rse_he_id
       , rse_unique
	   , rse_length
  FROM   ROAD_SEGS RSE
  WHERE  RSE.RSE_TYPE = 'G'
  AND    rse_length IS NOT NULL;

--
--
BEGIN

  g_proc_name := 'section_and_group_lengths';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  -----------------
  -- dodgy sections
  -----------------
  FOR c1rec IN c1 LOOP

        g_error := 'Road '||c1rec.rse_unique||' has length '||c1rec.rse_length;

         ----------------------------------------------------------
         -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
         ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Sections with Invalid Length'
                  ,pi_pmci_details     => g_error);

  END LOOP;


  FOR c2rec IN c2 LOOP

        g_error := 'Road '||c2rec.rse_unique||') has length '||c2rec.rse_length;

         ----------------------------------------------------------
         -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
         ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Groups with Length Specified'
                  ,pi_pmci_details     => g_error);

  END LOOP;


  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------------
--
PROCEDURE check_intervals IS --11
--
---------------------------------------------------------------------------
-- 11.	Intervals must exist for each network element, interval must be
-- 	migrated into a flexible attribute of the ROAD_SECTION so proper
-- 	integrity (through NTC_QUERY) can be guaranteed.
---------------------------------------------------------------------------
--
  CURSOR c1 IS
  SELECT rse_he_id, rse_unique, rse_int_code
  FROM ROAD_SEGS
  WHERE rse_int_code IS NOT NULL
  AND NOT EXISTS (SELECT 'interval code'
                  FROM    INTERVALS
                  WHERE   int_code = rse_int_code);
--
BEGIN

  g_proc_name := 'check_intervals';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR v_recs IN c1 LOOP
          g_error := 'Road '||v_recs.rse_unique||' has an interval code ('||v_recs.rse_int_code||') that is invalid';

         ----------------------------------------------------------
         -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
         ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);

  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------------
--
PROCEDURE check_rse_admin_unit_fk IS
--
---------------------------------------------------------------------------
-- Check that admin unit specified against a section/group exists.
---------------------------------------------------------------------------
--
  CURSOR c1 IS
  SELECT rse_admin_unit
        ,NVL(rse_gty_group_type, 'SECT')  group_type
        ,COUNT(*)      record_count
  FROM   ROAD_SEGS
  WHERE NOT EXISTS
        (SELECT 'x'
         FROM HIG_ADMIN_UNITS
         WHERE hau_admin_unit=rse_admin_unit)
  GROUP BY rse_admin_unit
          ,rse_gty_group_type;

--child is a member of more than one parent where the parents admin units are not related.
--This places the member is two or more distinct and competeing admin units.
/*
  CURSOR c2 IS  SELECT s.rse_unique--, s.rse_he_id, g1.rse_admin_unit, g2.rse_admin_unit
  ,h1.hau_name h1_hau_name, h2.hau_name h2_hau_name
  FROM ROAD_SEGS s, ROAD_SEGS g1, ROAD_SEG_MEMBS_ALL m1, ROAD_SEG_MEMBS_ALL m2, ROAD_SEGS g2
  ,HIG_ADMIN_UNITS h1, HIG_ADMIN_UNITS h2
  WHERE s.rse_he_id = m1.rsm_rse_he_id_of
  AND   g1.rse_he_id = m1.rsm_rse_he_id_in
  AND   s.rse_he_id = m2.rsm_rse_he_id_of
  AND   g2.rse_he_id = m2.rsm_rse_he_id_in
  AND g1.rse_he_id != g2.rse_he_id
  AND ( NOT EXISTS ( SELECT 1 FROM HIG_ADMIN_GROUPS
                 WHERE hag_parent_admin_unit = g1.rse_admin_unit
                 AND   hag_child_admin_unit  = g2.rse_admin_unit )
  AND    NOT EXISTS ( SELECT 1 FROM HIG_ADMIN_GROUPS
                 WHERE hag_parent_admin_unit = g2.rse_admin_unit
                 AND   hag_child_admin_unit  = g1.rse_admin_unit ) )
  AND g1.rse_admin_unit> g2.rse_admin_unit
  AND g1.rse_admin_unit=h1.hau_admin_unit
  AND g2.rse_admin_unit=h2.hau_admin_unit
  GROUP BY s.rse_unique, s.rse_he_id, g1.rse_admin_unit, g2.rse_admin_unit,h1.hau_name, h2.hau_name ;
*/

 TYPE tab_varchar40    IS TABLE OF VARCHAR2(40)    INDEX BY BINARY_INTEGER;
  TYPE tab_date         IS TABLE OF DATE	        INDEX BY BINARY_INTEGER;
--

  l_tab_unit_code tab_varchar40;
  l_tab_hau_name  tab_varchar40;
  l_tab_start_date tab_date;
  l_tab_end_date   tab_date;

  l_start_Date DATE;
  l_end_Date DATE;

  c_big_date  CONSTANT DATE :='31-DEC-9999';

  CURSOR c2 IS
  SELECT
  c.rse_unique,p_au.hau_level, COUNT(DISTINCT p_au.HAU_ADMIN_UNIT)
   FROM ROAD_SEG_MEMBS_ALL
  ,ROAD_SEGS p  --parent
  ,ROAD_SEGS c  --child
  ,HIG_ADMIN_UNITS p_au
  --,HIG_ADMIN_UNITS c_au
  WHERE rsm_rse_he_id_in=p.rsE_he_id
  AND rsm_rse_he_id_of=c.rse_he_id
  AND p_au.HAU_ADMIN_UNIT=p.rse_admin_unit
  --AND c_au.hau_admin_unit=c.RSE_ADMIN_UNIT
  GROUP BY c.rse_unique,p_au.hau_level
  HAVING COUNT(DISTINCT p_au.HAU_ADMIN_UNIT)>1;


--
-------------------------------------------------------------------
-- Check that road section end dates are not outside admin unit end dates
-------------------------------------------------------------------
CURSOR get_outdate_sects IS
SELECT rse_unique
      ,rse_start_date
      ,rse_end_date
      ,hau_start_date
      ,hau_end_date
      ,hau_admin_unit
FROM   ROAD_SEGS
      ,HIG_ADMIN_UNITS
WHERE (rse_start_date NOT BETWEEN NVL(hau_start_date, rse_start_date) AND NVL(hau_end_date, rse_start_date)
    OR rse_end_date NOT BETWEEN NVL(hau_start_date, rse_end_date) AND NVL(hau_end_date, rse_end_date)
    OR (hau_end_date IS NOT NULL AND rse_end_date IS NULL))
AND    hau_admin_unit = rse_admin_unit;
--
--
CURSOR invalid_au_rel IS
SELECT COUNT(*) num_invalid, g.rse_gty_group_type--, g.rse_he_id, g.rse_admin_unit, e.rse_admin_unit
FROM ROAD_SEGS g, ROAD_SEGS e, road_seg_membs m
WHERE m.rsm_rse_he_id_in = g.rse_he_id
AND m.rsm_rse_he_id_of = e.rse_he_id
AND NOT EXISTS ( SELECT 1 FROM HIG_ADMIN_GROUPS
WHERE hag_parent_admin_unit = g.rse_admin_unit
AND hag_child_admin_unit = e.rse_admin_unit )
--AND g.rse_gty_group_type = 'TOP'
GROUP BY g.rse_gty_group_type--, g.rse_he_id, g.rse_admin_unit, e.rse_admin_unit
;

CURSOR invalid_au_rel_details IS
SELECT  g.rse_gty_group_type, g.rse_unique, g.rse_admin_unit g_au, e.rse_admin_unit e_au,COUNT(*) num_invalid
,p_au.hau_unit_code p_unit_code,p_au.HAU_NAME p_au_name,c_au.hau_unit_code c_unit_code,c_au.HAU_NAME c_au_name
FROM ROAD_SEGS g, ROAD_SEGS e, road_seg_membs m
,HIG_ADMIN_UNITS p_au
,HIG_ADMIN_UNITS c_au
WHERE m.rsm_rse_he_id_in = g.rse_he_id
AND m.rsm_rse_he_id_of = e.rse_he_id
AND NOT EXISTS ( SELECT 1 FROM HIG_ADMIN_GROUPS
WHERE hag_parent_admin_unit = g.rse_admin_unit
AND hag_child_admin_unit = e.rse_admin_unit )
--AND g.rse_gty_group_type = 'TOP'
   AND p_au.HAU_ADMIN_UNIT=g.rse_admin_unit
    AND c_au.hau_admin_unit=e.RSE_ADMIN_UNIT
GROUP BY g.rse_gty_group_type, g.rse_unique, g.rse_admin_unit, e.rse_admin_unit
,p_au.hau_unit_code,p_au.HAU_NAME,c_au.hau_unit_code,c_au.HAU_NAME;

BEGIN

  g_proc_name := 'check_rse_admin_unit_fk';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR v_recs IN c1 LOOP
          g_error := v_recs.record_count||' invalid ocurrences of admin unit ('||v_recs.rse_admin_unit||')';

         ----------------------------------------------------------
         -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
         ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Count of Records Where Admin Unit Specified Against a Section/Group Does Not Exist - Within Group Type of '||v_recs.group_type
                  ,pi_pmci_details     => g_error);

  END LOOP;


  FOR v_recs IN  invalid_au_rel LOOP
          g_error := 'Group Type '||v_recs.rse_gty_group_type||' has '||v_recs.num_invalid||' Members which are not related by Admin Unit';

         ----------------------------------------------------------
         -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
         ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Groups with memberships not related by Admin Unit hierarchy Summary'
                  ,pi_pmci_details     => g_error);

  END LOOP;

  FOR v_recs IN  invalid_au_rel_details LOOP
          g_error := 'Group '||v_recs.rse_unique||'('||v_recs.rse_gty_group_type||') admin unit '||v_recs.p_unit_code||'('||v_recs.p_au_name||') has '||v_recs.num_invalid||' Members with admin unit '||v_recs.c_unit_code||'('||v_recs.c_au_name||')';

         ----------------------------------------------------------
         -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
         ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Groups with memberships not related by Admin Unit hierarchy Details'
                  ,pi_pmci_details     => g_error);

  END LOOP;


  FOR c2rec IN c2 LOOP  --these have the potential, now need to check dates
    SELECT
--    c.rse_unique
--    ,p.rse_unique
     p_au.hau_unit_code,
    -- p.rse_unique,p.rse_admin_unit,
    p_au.HAU_NAME
    --c.rse_unique,c.rse_admin_unit,
    --c_au.HAU_NAME,c_au.hau_level
    ,MIN(rsm_start_Date),MAX(rsm_end_date)
	BULK COLLECT INTO
	l_tab_unit_code
	,l_tab_hau_name
	,l_tab_start_Date
	,l_tab_end_Date
	 FROM ROAD_SEG_MEMBS_ALL
    ,ROAD_SEGS p  --parent
    ,ROAD_SEGS c  --child
    ,HIG_ADMIN_UNITS p_au
    ,HIG_ADMIN_UNITS c_au
    WHERE rsm_rse_he_id_in=p.rsE_he_id
    AND rsm_rse_he_id_of=c.rse_he_id
    AND p_au.HAU_ADMIN_UNIT=p.rse_admin_unit
    AND c_au.hau_admin_unit=c.RSE_ADMIN_UNIT
    AND c.rse_unique =c2rec.rse_unique
    AND p_au.hau_level=c2rec.hau_level
    GROUP BY  p_au.hau_unit_code, p_au.HAU_NAME
	ORDER BY MIN(rsm_start_date),p_au.hau_unit_code;


    FOR I IN 1..l_tab_unit_code.COUNT LOOP
	  IF I>1 THEN
	   IF l_tab_start_date(I)<l_end_date AND NVL(l_tab_end_date(I),c_big_Date)>l_start_date THEN
       g_error := c2rec.rse_unique||' is a member of groups with Admin Units '||l_tab_unit_code(I-1)||'('||l_tab_hau_name(I-1)||') and '||l_tab_unit_code(I)||'('||l_tab_hau_name(I)||')';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Child is a member of 2 Groups of Different Admin Units at the Same level in the AU Hierarchy'
                ,pi_pmci_details     => g_error);

	    END IF;
	  END IF;
      l_start_date:=l_tab_start_Date(I);
	  l_end_Date:=NVL(l_tab_end_date(I),c_big_Date);



	END LOOP;
  END LOOP;





  FOR irec IN get_outdate_sects LOOP
          g_error := 'RSE_UNIQUE ('||irec.rse_unique||')  dates are outside admin unit ('||irec.hau_admin_unit||')';

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Road segment dates are not within that of the admin unit'
                  ,pi_pmci_details     => g_error);

  END LOOP;
  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_rse_unique_uppercase IS
--
---------------------------------------------------------------------------
-- Check that RSE_UNIQUE is in upper case
---------------------------------------------------------------------------
--
  CURSOR c1 IS
  SELECT rse_unique
  FROM   ROAD_SEGS
  WHERE  rse_unique != UPPER(rse_unique)
  ORDER BY rse_unique;
--
--
--
BEGIN

  g_proc_name := 'check_rse_unique_uppercase';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR v_recs IN c1 LOOP
          g_error := 'RSE_UNIQUE ('||v_recs.rse_unique||')';

         ----------------------------------------------------------
         -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
         ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);

  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE sections_links_relate IS--14
--
---------------------------------------------------------------------------
-- 14.	Group and members must adhere to any auto-inclusion methods that
--	are to be introduced. If it is not possible to strictly adhere to
--	this, then disable the auto-inclusion.
---------------------------------------------------------------------------

  CURSOR c1 IS
  SELECT *
  FROM   ROAD_SEGS rse1
  WHERE  rse_group IS NOT NULL
  AND    rse_type = 'S'
  AND NOT EXISTS (SELECT 'road group'
                  FROM   ROAD_SEGS rse2
                  WHERE  rse2.rse_unique = rse1.rse_group);

  CURSOR missing_vals IS
  SELECT rse_he_id
        ,rse_unique
        ,rse_agency
        ,rse_linkcode
  FROM   ROAD_SEGS
  WHERE  (rse_gty_group_type IS NULL
       OR rse_gty_group_type = 'LINK')
  AND    (rse_agency IS NULL
       OR rse_linkcode IS NULL);
--

BEGIN

  g_proc_name := 'sections_links_relate';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR v_recs IN c1 LOOP
    g_error := v_recs.rse_unique||' ('||v_recs.rse_he_id||') '''||v_recs.rse_descr||''' has an invalid group of '''||v_recs.rse_group||'''';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => g_error);

  END LOOP;

  FOR irec IN missing_vals LOOP

    g_error := irec.rse_unique||' ('||irec.rse_he_id||') is missing the  agency and/or linkcode ';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => g_error);

  END LOOP;
  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL
                    ,pi_note_over_fail => TRUE);


END;
--
-----------------------------------------------------------------------------
--
PROCEDURE groups_members IS --15
--
---------------------------------------------------------------------------
-- 12.	Group members must post-date both the group and the member elements
-- 15.	Groups of groups should not contain any sections - NM3 hierarchy is
--      strict. Prior knowledge of how this is to modelled in the NM3
--      schema will be advantageous.
-- 16.	Groups of sections should not contain any groups. The definition of
--      groups of groups and groups of sections must be identified prior to
--      migration.
---------------------------------------------------------------------------
BEGIN

  g_proc_name := 'groups_members';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN
    --Groups that have memberships starting before the group started
    (SELECT rsm_rse_he_id_of, rsm_rse_he_id_in, rsm_start_date, rse_start_Date, rse_unique
     FROM   ROAD_SEG_MEMBS_ALL
           ,ROAD_SEGS
    WHERE
            rsm_rse_he_id_in = rse_he_id
    AND     TRUNC(rsm_start_date)<TRUNC(rse_start_date)) LOOP

	  g_error := c1rec.rse_unique||' ('||c1rec.rsm_rse_he_id_in||')';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Groups that have memberships starting before the group started'
              ,pi_pmci_details     => g_error);
    END LOOP;

  FOR c1rec IN
    --groups that have memberships open/end-date after the group is ended
    (SELECT rsm_rse_he_id_of, rsm_rse_he_id_in, rsm_end_date, rse_end_Date, rse_unique
     FROM   ROAD_SEG_MEMBS_ALL
           ,ROAD_SEGS
     WHERE
            rsm_rse_he_id_in = rse_he_id
     AND    TRUNC(NVL(rsm_end_date,SYSDATE))>TRUNC(NVL(rse_end_date,SYSDATE))) LOOP

      g_error := c1rec.rse_unique||' rsm_rse_he_id_in ('||c1rec.rsm_rse_he_id_in||') rsm_rse_he_id_of ('||c1rec.rsm_rse_he_id_of||')';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Groups that have memberships open/end-dated after the group is ended'
              ,pi_pmci_details     => g_error);
  END LOOP;

  FOR c1rec IN
    --memberships of groups before the member started
    (SELECT rsm_rse_he_id_of, rsm_rse_he_id_in, rsm_start_date, rse_start_Date, rse_unique
    FROM ROAD_SEG_MEMBS_ALL
    ,ROAD_SEGS
    WHERE
    rsm_rse_he_id_of = rse_he_id
    AND TRUNC(rsm_start_date)<TRUNC(rse_start_date)) LOOP
      g_error := c1rec.rse_unique||' rsm_rse_he_id_in ('||c1rec.rsm_rse_he_id_in||') rsm_rse_he_id_of ('||c1rec.rsm_rse_he_id_of||')';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Memberships of groups before the member started'
              ,pi_pmci_details     => g_error);
  END LOOP;

   FOR c1rec IN
    --memberships of groups ended before the member started
    (SELECT rsm_rse_he_id_of, rsm_rse_he_id_in, rsm_start_date, rsm_end_Date, m.rse_unique m_unique, g.rse_unique g_unique
    FROM ROAD_SEG_MEMBS_ALL
    ,ROAD_SEGS g
	,ROAD_SEGS m
    WHERE rsm_rse_he_id_of = m.rse_he_id
    AND rsm_rse_he_id_in = g.rse_he_id
    AND TRUNC(rsm_start_date)>TRUNC(rsm_end_date)) LOOP
      g_error := c1rec.m_unique||' rsm_rse_he_id_of ('||c1rec.rsm_rse_he_id_of||') '||c1rec.g_unique||' rsm_rse_he_id_in ('||c1rec.rsm_rse_he_id_in||') '||c1rec.rsm_start_Date||' '||c1rec.rsm_end_date;
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Memberships of groups ended before the member started'
              ,pi_pmci_details     => g_error);
  END LOOP;


  FOR c1rec IN
    --memberships of groups open/end-dated after the member is ended
    (SELECT rsm_rse_he_id_of, rsm_rse_he_id_in, rsm_end_date, rse_end_Date, rse_unique
    FROM ROAD_SEG_MEMBS_ALL
    ,ROAD_SEGS
    WHERE
    rsm_rse_he_id_of = rse_he_id
    AND TRUNC(NVL(rsm_end_date,SYSDATE))>TRUNC(NVL(rse_end_date,SYSDATE))) LOOP
      g_error := c1rec.rse_unique||' rsm_rse_he_id_in ('||c1rec.rsm_rse_he_id_in||') rsm_rse_he_id_of ('||c1rec.rsm_rse_he_id_of||')';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Memberships of groups open/end-dated after the member is ended'
              ,pi_pmci_details     => g_error);
  END LOOP;

  FOR c1rec IN
    --groups memberships type of the appropraite type for group type
    (SELECT rsm_rse_he_id_in, rsm_rse_he_id_of,rsm_type,rse_type, rse_unique
    FROM ROAD_SEG_MEMBS_ALL
    ,ROAD_SEGS
    WHERE rsm_rse_he_id_of=rse_he_id
    AND DECODE(rsm_type,'P','S',rsm_type)!=DECODE(rse_type,'P','S',rse_type)) LOOP
      g_error := c1rec.rse_unique||' rsm_rse_he_id_in ('||c1rec.rsm_rse_he_id_in||') rsm_rse_he_id_of ('||c1rec.rsm_rse_he_id_of||')';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Groups memberships type of the appropraite type for Group type'
              ,pi_pmci_details     => g_error);
  END LOOP;

  FOR c1rec IN
    --GoG only with groups/GoS only with sections
    (SELECT rsm_rse_he_id_in,COUNT( DISTINCT DECODE(rsm_type,'P','S',rsm_type))
    FROM ROAD_SEG_MEMBS_ALL
    GROUP BY rsm_rse_he_id_in
    HAVING COUNT (DISTINCT DECODE(rsm_type,'P','S',rsm_type))>1) LOOP

     g_error := 'rsm_rse_he_id_in ('||c1rec.rsm_rse_he_id_in||')';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'GoG only with groups/GoS only with sections'
              ,pi_pmci_details     => g_error);

  END LOOP;

  FOR c1rec IN
    --group types that contain secitons only or groups only - but in the same group type
    (SELECT gty.rse_gty_group_type,COUNT (DISTINCT gty_memb.rse_type)
     FROM   ROAD_SEGS Gty
           ,ROAD_SEG_MEMBS_ALL
		   ,ROAD_SEGS gty_memb
     WHERE  gty.rse_he_id = rsm_rse_he_id_in
--  AND    gty.rse_gty_group_type = 'AREA'
     AND    rsm_rse_he_id_of=gty_memb.rse_he_id
    GROUP BY  gty.rse_gty_group_type--,gty_memb.rse_type
    HAVING COUNT (DISTINCT gty_memb.rse_type)>1) LOOP

     g_error := 'Group Type '||c1rec.rse_gty_group_type||' Contains Groups of Groups and Groups Of Sections';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'GoG only with groups/GoS only with sections'
              ,pi_pmci_details     => g_error);

  END LOOP;


  FOR c1rec IN
    --groups that have memberships started after the member ended
    (SELECT rsm_rse_he_id_of, rsm_rse_he_id_in, rsm_start_date, rse_END_Date, rse_unique
     FROM ROAD_SEG_MEMBS_ALL
    ,ROAD_SEGS
    WHERE
    rsm_rse_he_id_of = rse_he_id
    AND TRUNC(rsm_start_date)>TRUNC(rse_end_date)) LOOP

      g_error := c1rec.rse_unique||' rsm_rse_he_id_in ('||c1rec.rsm_rse_he_id_in||') rsm_rse_he_id_of ('||c1rec.rsm_rse_he_id_of||')';
      ---------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ---------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Groups that have memberships started after the member has ended'
              ,pi_pmci_details     => g_error);

  END LOOP;
  -- check that groups do not repeat in the hierarchy

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE group_exclusivity IS

  TYPE nine_i_cur    IS REF CURSOR;

  rep_gog nine_i_cur;
  l_group_type ROAD_SEGS.rse_gty_group_type%TYPE;
  l_unique     ROAD_SEGS.rse_unique%TYPE;
  l_hier       VARCHAR2(500);

  l_get_dups_in_hier VARCHAR2(2000) :=  'SELECT rse_gty_group_type '||
  '      , rse_unique '||
  '      , hier     FROM '||
  '(SELECT  /*+ NO_FILTERING*/ rse_gty_group_type '||
  '       ,rse_unique '||
  '       ,rse_he_id '||
  '       ,SYS_CONNECT_BY_PATH(rse_gty_group_type, ''/'') hier '||
  ' FROM   road_seg_membs_all rsm '||
  '       ,road_segs rse '||
  ' WHERE rsm_type != ''S'' '||
  ' AND   rsm_rse_he_id_of = rse_he_id '||
  ' AND   level > 1 '|| -- cant have duplicates at level 1
  ' CONNECT BY PRIOR rsm_rse_he_id_of = rsm_rse_he_id_in '||
  ' START WITH rsm_rse_he_id_in IN (SELECT rse_he_id  '||
  '                                 FROM road_segs '||
  '                                 WHERE rse_gty_group_type = ''TOP'')) '||
  'WHERE INSTR(hier, rse_gty_group_type, 1, 2) > 0 ';

  CURSOR is_version_9 IS
  SELECT 1
  FROM   v$instance
  WHERE TO_NUMBER(SUBSTR(VERSION, 1, INSTR(VERSION, '.') -1)) > 8;

/*
  CURSOR potential_offenders IS
  SELECT rsm_rse_he_id_of
  FROM   ROAD_SEG_MEMBS_ALL rsm
        ,ROAD_SEGS rse
  WHERE  rsm_rse_he_id_of IN (SELECT rsm_rse_he_id_of
                              FROM ROAD_SEG_MEMBS_ALL
                              GROUP BY rsm_rse_he_id_of
                              HAVING COUNT(rsm_rse_he_id_of) > 1)
  AND rsm_rse_he_id_in = rse_he_id
  AND rse_gty_group_type IN (SELECT gty_group_type
                             FROM GROUP_TYPES
                             WHERE gty_exclusive_flag='Y')
  GROUP BY rsm.rsm_rse_he_id_of
  HAVING COUNT(rsm.rsm_rse_he_id_of) > 1;


  CURSOR get_exclusivity(p_rse_he_id IN ROAD_SEGS.rse_he_id%TYPE) IS
  SELECT rse_gty_group_type, COUNT(*) COUNT
  FROM   ROAD_SEG_MEMBS_ALL rsm1
        ,ROAD_SEGS rse
  WHERE rsm1.rsm_rse_he_id_of = p_rse_he_id
  AND   rsm1.rsm_rse_he_id_in = rse_he_id
  AND   rse.rse_gty_group_type IN (SELECT gty_group_type
                                   FROM   GROUP_TYPES
                                   WHERE  gty_exclusive_flag='Y')
  AND ( (rsm1.rsm_end_date IS NULL
      AND EXISTS (SELECT 1
                  FROM ROAD_SEG_MEMBS_ALL rsm3
                      ,ROAD_SEGS
                  WHERE rsm3.rsm_rse_he_id_of = rsm1.rsm_rse_he_id_of
                  AND   rsm3.ROWID != rsm1.ROWID
                  AND   rsm_end_date IS NULL
                  AND   rse_he_id = rsm_rse_he_id_in
                  AND   rse_gty_group_type IN (SELECT gty_group_type
                                               FROM   GROUP_TYPES
                                               WHERE  gty_exclusive_flag='Y'
                                               UNION
                                               SELECT 'LINK' FROM dual)))
  OR EXISTS (SELECT 1
             FROM  ROAD_SEG_MEMBS_ALL rsm2
                  ,ROAD_SEGS
             WHERE rsm2.rsm_rse_he_id_of = rsm1.rsm_rse_he_id_of
             AND   rsm2.ROWID != rsm1.ROWID
             AND   rse_he_id = rsm_rse_he_id_in
             AND   rse_gty_group_type IN (SELECT gty_group_type
                                          FROM   GROUP_TYPES
                                          WHERE  gty_exclusive_flag='Y'
                                          UNION
                                          SELECT 'LINK' FROM dual)
           AND   rsm1.rsm_end_date BETWEEN rsm2.rsm_start_date AND  NVL(rsm2.rsm_end_date, rsm1.rsm_end_date)
           ))
   GROUP BY rse_gty_group_type
   HAVING COUNT(*) > 1;
*/



  CURSOR potential_offenders IS
  SELECT rse_gty_group_type,rsm_rse_he_id_of,COUNT(*) FROM
   ROAD_SEGS
  ,ROAD_SEG_MEMBS_ALL
  ,GROUP_TYPES
  WHERE rse_gty_group_type =gty_group_type
  AND gty_exclusive_flag='Y'
  AND rsm_rse_he_id_in=rse_he_id
  GROUP BY rse_gty_group_type,rsm_rse_he_id_of
  HAVING COUNT(*)>1 ;

  CURSOR check_dates (p_of IN NUMBER, p_gtype IN GROUP_TYPES.gty_group_Type%TYPE) IS
  SELECT p.rse_unique p_unique, c.rse_unique c_unique,rsm_start_date,rsm_end_date FROM ROAD_SEG_MEMBS_ALL
  ,ROAD_SEGS p
  ,ROAD_SEGS c
  WHERE rsm_rse_he_id_of=p_of
  AND rsm_rse_he_id_in=p.rse_he_id
  AND rsm_rse_he_id_of=c.rse_he_id
  AND p.rse_gty_group_type=p_gtype
  ORDER BY rsm_start_Date,rsm_end_date;

--
  CURSOR get_segs(p_rse_he_id  IN ROAD_SEGS.rse_he_id%TYPE
                 ,p_group_type IN ROAD_SEGS.rse_gty_group_type%TYPE) IS
  SELECT rse_unique
  FROM   ROAD_SEG_MEMBS_ALL rsm1
        ,ROAD_SEGS RSE
  WHERE rsm1.rsm_rse_he_id_of = p_rse_he_id
  AND   rsm1.rsm_rse_he_id_in = rse_he_id
  AND   RSE.rse_gty_group_type  = p_group_type
  AND ( (rsm1.rsm_end_date IS NULL
      AND EXISTS (SELECT 1
                  FROM ROAD_SEG_MEMBS_ALL rsm3
                      ,ROAD_SEGS
                  WHERE rsm3.rsm_rse_he_id_of = rsm1.rsm_rse_he_id_of
                  AND   rsm3.ROWID != rsm1.ROWID
                  AND   rsm_end_date IS NULL
                  AND   rse_he_id = rsm_rse_he_id_in
                  AND   rse_gty_group_type IN (SELECT gty_group_type
                                               FROM   GROUP_TYPES
                                               WHERE  gty_exclusive_flag='Y'
                                               UNION
                                               SELECT 'LINK' FROM dual)))
  OR EXISTS (SELECT 1
             FROM  ROAD_SEG_MEMBS_ALL rsm2
                  ,ROAD_SEGS
             WHERE rsm2.rsm_rse_he_id_of = rsm1.rsm_rse_he_id_of
             AND   rsm2.ROWID != rsm1.ROWID
             AND   rse_he_id = rsm_rse_he_id_in
             AND   rse_gty_group_type IN (SELECT gty_group_type
                                          FROM   GROUP_TYPES
                                          WHERE  gty_exclusive_flag='Y'
                                          UNION
                                          SELECT 'LINK' FROM dual)
           AND   rsm1.rsm_end_date BETWEEN rsm2.rsm_start_date AND  NVL(rsm2.rsm_end_date, rsm1.rsm_end_date)
           ));

  l_dummy      PLS_INTEGER;
  l_ver_9      BOOLEAN;
  l_sep        VARCHAR2(1);

  last_date DATE;
  I NUMBER;
  last_unique ROAD_SEGS.rse_unique%TYPE;
BEGIN

  g_proc_name := 'group_exclusivity';
  set_pmc_start(pi_pmc_ref => g_proc_name);

/*  FOR irec IN potential_offenders LOOP

    FOR by_group IN get_exclusivity(irec.rsm_rse_he_id_of) LOOP
      g_error := 'Road '||Get_Unique(irec.rsm_rse_he_id_of)||' is linked to '||by_group.COUNT||' '||by_group.rse_gty_group_type||'''s (';
      l_sep := NULL;
      FOR problem_sects IN get_segs(irec.rsm_rse_he_id_of, by_group.rse_gty_group_type) LOOP
         g_error := g_error ||l_sep||problem_sects.rse_unique;
         l_sep := ',';
      END LOOP;
      g_error := g_error ||')';

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Violations of Group Exclusivity'
              ,pi_pmci_details     => g_error);
    END LOOP;
  END LOOP;
*/

  FOR irec IN potential_offenders LOOP
   I:=0;
   last_date:=NULL;
   last_unique:=NULL;
   FOR jrec IN check_Dates(irec.rsm_rse_he_id_of, irec.rse_gty_group_type) LOOP
     IF I>0 THEN
	   IF TRUNC(jrec.rsm_start_Date)<TRUNC(last_date) THEN
	   --error
          g_error := 'Road '||jrec.c_unique||' is linked both to '||last_unique||' and '||jrec.p_unique||' (type '||irec.rse_gty_group_type||') on '||TO_CHAR(TRUNC(last_date),'DD-MON-YYYY');

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Violations of Group Exclusivity'
              ,pi_pmci_details     => g_error);
	   END IF;
	 END IF;
     last_date:=TRUNC(jrec.rsm_end_date);
	 last_unique:=jrec.p_unique;
	 I:=I+1;
   END LOOP;
 END LOOP;

  OPEN is_version_9;
  FETCH is_version_9 INTO l_dummy;
  l_ver_9 := is_version_9%FOUND;
  CLOSE is_version_9;

  IF l_ver_9 THEN
    OPEN rep_gog FOR l_get_dups_in_hier;
    LOOP
      FETCH rep_gog INTO l_group_type, l_unique, l_hier;
      EXIT WHEN rep_gog%NOTFOUND;

      g_error := l_unique||' of type '|| l_group_type ||' appears in the network hierarchy ('||l_hier||') more than once';

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Repeating groups in network hierarchy. This could cause looping'
              ,pi_pmci_details     => g_error);
    END LOOP;
  END IF;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END group_exclusivity;
--
-----------------------------------------------------------------------------
--
PROCEDURE point_contiguous IS --17
--
---------------------------------------------------------------------------
-- 17.	Check that point data types are not flagged as contiguous.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT COUNT(1)
  FROM INV_ITEM_TYPES
  WHERE ity_pnt_or_cont = 'P'
  AND ity_contiguous = 'Y';
--
  l_dum NUMBER;
--
BEGIN

   g_proc_name := 'point_contiguous';
   set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1;
  FETCH c1 INTO l_dum;
  CLOSE c1;
  IF l_dum > 0
    THEN
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Count of point data types that are flagged as contiguous'
              ,pi_pmci_details     => TO_CHAR(l_dum));
  END IF;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
---------------------------------------------------------------------------
-- 18.	Confirm that the inventory unique key may be applied.
---------------------------------------------------------------------------
PROCEDURE inv_uniqueness IS

 -- check for duplicate IIT_PRIMARY_KEY's
 CURSOR c1 IS
 SELECT  iit_primary_key
       ,iit_ity_sys_flag
       , iit_ity_inv_code
       , TRUNC(iit_cre_date)
       , COUNT(*)            iit_count
 FROM INV_ITEMS_ALL
 WHERE iit_primary_key IS NOT NULL
 GROUP BY   iit_primary_key
          , iit_ity_sys_flag
          , iit_ity_inv_code
          , TRUNC(iit_cre_date)
 HAVING COUNT(*) > 1;

 TYPE t_tab_iit_primary_key  IS TABLE OF INV_ITEMS_ALL.iit_primary_key%TYPE INDEX BY BINARY_INTEGER;
 TYPE t_tab_iit_ity_inv_code IS TABLE OF INV_ITEMS_ALL.iit_ity_inv_code%TYPE INDEX BY BINARY_INTEGER;
 TYPE t_tab_iit_ity_sys_flag IS TABLE OF INV_ITEMS_ALL.iit_ity_sys_flag%TYPE INDEX BY BINARY_INTEGER;
 TYPE t_tab_date             IS TABLE OF DATE INDEX BY BINARY_INTEGER;
 TYPE t_tab_count            IS TABLE OF NUMBER(38) INDEX BY BINARY_INTEGER;

 v_tab_iit_primary_key  t_tab_iit_primary_key;
 v_tab_iit_ity_inv_code t_tab_iit_ity_inv_code;
 v_tab_iit_ity_sys_flag t_tab_iit_ity_sys_flag;
 v_tab_date             t_tab_date;
 v_tab_count            t_tab_count;

BEGIN

  g_proc_name := 'inv_uniqueness';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1;
  FETCH c1 BULK COLLECT INTO v_tab_iit_primary_key
  		   				    ,v_tab_iit_ity_sys_flag
                            ,v_tab_iit_ity_inv_code
                            ,v_tab_date
                            ,v_tab_count;
  CLOSE c1;

  FOR I IN 1..v_tab_iit_primary_key.COUNT LOOP

      g_error := 'IIT_PRIMARY_KEY ('||v_tab_iit_primary_key(I)||') - IIT_ITY_INV_CODE ('||v_tab_iit_ity_inv_code(I)||') IIT_CRE_DATE ('||v_tab_date(I)||') Count of matching records ('||v_tab_count(I)||')';

      ----------------------------------------------------------
      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
      ----------------------------------------------------------
      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Inventory Records With Duplicate Primary Key Columns'
              ,pi_pmci_details     => g_error);

  END LOOP;
--
  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);



END inv_uniqueness;
--
---------------------------------------------------------------------------
--
PROCEDURE inv_type_valid IS

  CURSOR c1 IS
  SELECT
        iit_ity_inv_code,
        iit_ity_sys_flag,
        COUNT(*)
  FROM
        INV_ITEMS_ALL
  WHERE
  NOT EXISTS  (SELECT 'x'
               FROM   INV_ITEM_TYPES
               WHERE  iit_ity_inv_code=ity_inv_code
               AND    iit_ity_sys_flag=ity_sys_flag)
  GROUP BY
         iit_ity_inv_code
        ,iit_ity_sys_flag;

 TYPE t_tab_iit_ity_inv_code IS TABLE OF INV_ITEMS_ALL.iit_ity_inv_code%TYPE INDEX BY BINARY_INTEGER;
 TYPE t_tab_iit_ity_sys_flag IS TABLE OF INV_ITEMS_ALL.iit_ity_sys_flag%TYPE INDEX BY BINARY_INTEGER;
 TYPE t_tab_count            IS TABLE OF NUMBER(38) INDEX BY BINARY_INTEGER;


 v_tab_iit_ity_inv_code t_tab_iit_ity_inv_code;
 v_tab_iit_ity_sys_flag t_tab_iit_ity_sys_flag;
 v_tab_count            t_tab_count;


BEGIN

  g_proc_name := 'inv_type_valid';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1;
  FETCH c1 BULK COLLECT INTO v_tab_iit_ity_inv_code
                            ,v_tab_iit_ity_sys_flag
                            ,v_tab_count;
  CLOSE c1;

  FOR I IN 1..v_tab_iit_ity_inv_code.COUNT LOOP

      g_error := 'IIT_ITY_INV_CODE ('||v_tab_iit_ity_inv_code(I)||') IIT_ITY_SYS_FLAG ('||v_tab_iit_ity_sys_flag(I)||') Count of matching records ('||v_tab_count(I)||')';

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Inventory Records With Invalid Inventory Type'
              ,pi_pmci_details     => g_error);

  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END inv_type_valid;
--
---------------------------------------------------------------------------
--
PROCEDURE inv_locations IS --19
--
---------------------------------------------------------------------------
-- 19.	Confirm that all inventory locations are valid
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT iit_rse_he_id
        ,COUNT(*) COUNT
  FROM   INV_ITEMS_ALL
  WHERE NOT EXISTS (
                    SELECT 'a road seg'
                    FROM   ROAD_SEGS
                    WHERE  iit_rse_he_id = rse_he_id
                    )
  GROUP BY iit_rse_he_id;


  CURSOR c2 IS
  SELECT iit_rse_he_id
        ,COUNT(*) COUNT
  FROM   INV_ITEMS_ALL
        ,ROAD_SEGS
  WHERE iit_rse_he_id = rse_he_id
  AND   rse_type = 'G'
  GROUP BY iit_rse_he_id;


  CURSOR c3start IS
  SELECT iit_item_id
       , iit_rse_he_id
       , iit_cre_date
       , rse_end_date
       , rse_start_date
       , iit_end_date
       , rse_unique
  FROM   INV_ITEMS_ALL
        ,ROAD_SEGS
  WHERE  iit_rse_he_id = rse_he_id
  AND    TRUNC(iit_cre_date) NOT BETWEEN TRUNC(rse_start_date) AND TRUNC(
                                    NVL(rse_end_Date,iit_Cre_Date))
  ORDER BY iit_rse_he_id, iit_cre_date;

  CURSOR c3end IS
  SELECT iit_item_id
       , iit_rse_he_id
       , iit_cre_date
       , rse_end_date
       , rse_start_date
       , iit_end_date
       , rse_unique
  FROM   INV_ITEMS_ALL
        ,ROAD_SEGS
  WHERE  iit_rse_he_id = rse_he_id
  AND TRUNC(NVL(iit_end_date,'31-dec-9999')) NOT BETWEEN TRUNC(rse_start_date) AND TRUNC(
                                    NVL(rse_end_Date,NVL(iit_end_Date,'31-DEC-9999')))
  ORDER BY iit_rse_he_id, iit_cre_date;


--
  CURSOR c4 IS
  SELECT iit_item_id, iit_ity_inv_code, iit_cre_date
  FROM   INV_ITEMS_ALL
  WHERE iit_cre_date > SYSDATE
  ORDER BY 2,3;

  TYPE t_tab_iit_rse_he_id    IS TABLE OF INV_ITEMS_ALL.iit_rse_he_id%TYPE INDEX BY BINARY_INTEGER;
  TYPE t_tab_iit_item_id      IS TABLE OF INV_ITEMS_ALL.iit_item_id%TYPE INDEX BY BINARY_INTEGER;
  TYPE t_tab_date             IS TABLE OF DATE INDEX BY BINARY_INTEGER;
  TYPE t_tab_count            IS TABLE OF NUMBER(38) INDEX BY BINARY_INTEGER;

  v_tab_count            t_tab_count;

--
BEGIN

  g_proc_name := 'inv_locations';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  -------------------------------------------
  -- Inventory placed on non-existent network
  -------------------------------------------

  FOR I IN c1 LOOP

          g_error := 'Location ('||I.iit_rse_he_id||') Count of Inventory Items ('||I.COUNT||')';

          ----------------------------------------------------------
          -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
          ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Inventory Items Located on Non-Existent Network'
                  ,pi_pmci_details     => g_error);

  END LOOP;

  ------------------------------------------------------------
  -- Inventory located against a group - rather than a section
  ------------------------------------------------------------

  FOR I IN c2 LOOP

          g_error := 'Location ('||I.iit_rse_he_id||') Count of Inventory Items ('||I.COUNT||')';

          ----------------------------------------------------------
          -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
          ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Inventory items located against a group rather than a section'
                  ,pi_pmci_details     => g_error);

  END LOOP;

  ---------------------------------------------------------
  -- Inventory with a start date before network start date
  ---------------------------------------------------------

  FOR I IN c3start LOOP

    g_error := 'Inventory item ('||I.iit_item_id||') located on ('||I.rse_unique||', '||TO_CHAR(I.rse_start_date,'DD-MON-YYYY');
    IF I.rse_end_date IS NOT NULL THEN
      g_error := g_error || ' to '||TO_CHAR(I.rse_end_date,'DD-MON-YYYY');
    END IF;
    g_error := g_error || ') item starts on '||TO_CHAR(I.iit_cre_date,'DD-MON-YYYY');
    IF I.iit_end_date IS NOT NULL THEN
      g_error := g_error || ' and ends on '||TO_CHAR(I.iit_end_date,'DD-MON-YYYY');
    END IF;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Inventory items that exist outside the Start date bounds of the inventory location'
            ,pi_pmci_details     => g_error);

  END LOOP;

 FOR I IN c3end LOOP

    g_error := 'Inventory item ('||I.iit_item_id||') located on ('||I.rse_unique||', '||TO_CHAR(I.rse_start_date,'DD-MON-YYYY');
    IF I.rse_end_date IS NOT NULL THEN
      g_error := g_error || ' to '||TO_CHAR(I.rse_end_date,'DD-MON-YYYY');
    END IF;
    g_error := g_error || ') item starts on '||TO_CHAR(I.iit_cre_date,'DD-MON-YYYY');
    IF I.iit_end_date IS NOT NULL THEN
      g_error := g_error || ' and ends on '||TO_CHAR(I.iit_end_date,'DD-MON-YYYY');
	ELSE
      g_error := g_error || ' and has no end date';
    END IF;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Inventory items that exist outside the End date bounds of the inventory location'
            ,pi_pmci_details     => g_error);

  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END inv_locations;
--
-----------------------------------------------------------------------------
--
PROCEDURE inv_start_end_check IS -- 20,21,22
--
  CURSOR c1_count IS
  SELECT ity_inv_code
       , ity_descr
	   , ity_sys_flag
       , COUNT(*)
  FROM INV_ITEMS_ALL
      ,INV_ITEM_TYPES
  WHERE   ity_pnt_or_cont = 'P'
  AND     NVL(iit_st_chain,-1) != NVL(iit_END_chain,NVL(iit_st_chain,0))
  AND     iit_ity_inv_code = ity_inv_code
  AND     ity_sys_flag = iit_ity_sys_flag
  GROUP BY
          ity_inv_code
        , ity_descr
		, ity_sys_flag;
--
--
--
  CURSOR c2_count IS
  SELECT ity_inv_code
       , ity_descr
	   , iit_ity_sys_flag
       , COUNT(*)
  FROM INV_ITEMS_ALL
      ,INV_ITEM_TYPES
  WHERE   ity_pnt_or_cont = 'C'
  AND     NVL(iit_st_chain,999999) >= NVL(iit_END_chain,NVL(iit_st_chain,0))
  AND     iit_ity_inv_code = ity_inv_code
  AND     ity_sys_flag = iit_ity_sys_flag
  GROUP BY
          ity_inv_code
        , ity_descr
		, iit_ity_sys_flag;
--

  l_dum NUMBER;

  TYPE tab_ity_inv_code  IS TABLE OF INV_ITEM_TYPES.ity_inv_code%TYPE INDEX BY BINARY_INTEGER;
  TYPE tab_ity_descr     IS TABLE OF INV_ITEM_TYPES.ity_descr%TYPE INDEX BY BINARY_INTEGER;
  TYPE tab_ity_sys_flag  IS TABLE OF INV_ITEM_TYPES.ity_sys_flag%TYPE INDEX BY BINARY_INTEGER;
  TYPE tab_number        IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

  v_tab_ity_inv_code  tab_ity_inv_code;
  v_tab_ity_descr     tab_ity_descr;
  v_tab_ity_sys_flag  tab_ity_sys_flag;
  v_tab_number1       tab_number;
  v_tab_number2       tab_number;

BEGIN

  g_proc_name := 'inv_start_end_check';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1_count;
  FETCH c1_count
  BULK COLLECT INTO v_tab_ity_inv_code
                   ,v_tab_ity_descr
				   ,v_tab_ity_sys_flag
	               ,v_tab_number1;
  CLOSE c1_count;

  FOR I IN 1..v_tab_ity_inv_code.COUNT LOOP
        g_error := 'Inventory Type - ('||v_tab_ity_inv_code(I)||')   Description - ('||v_tab_ity_descr(I)||')   ITY_SYS_FLAG - ('||v_tab_ity_sys_flag(I)||')   Count - ('||v_tab_number1(I)||')';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Count of Point Items with Multiple Locations - Grouped by Inventory Type/ITY_SYS_FLAG'
                ,pi_pmci_details     => g_error);

  END LOOP;
--
  OPEN c2_count;
  FETCH c2_count
  BULK COLLECT INTO v_tab_ity_inv_code
                   ,v_tab_ity_descr
				   ,v_tab_ity_sys_flag
	               ,v_tab_number2;

  CLOSE c2_count;

  FOR I IN 1..v_tab_ity_inv_code.COUNT LOOP
        g_error := 'Inventory Type - ('||v_tab_ity_inv_code(I)||')   Description - ('||v_tab_ity_descr(I)||')   ITY_SYS_FLAG - ('||v_tab_ity_sys_flag(I)||')   Count - ('||v_tab_number2(I)||')';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Count of Linear Items With Start Chain >= End Chain - Grouped by Inventory Type/ITY_SYS_FLAG'
                ,pi_pmci_details     => g_error);
  END LOOP;
--
  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE inv_start_end_count IS --23
--
---------------------------------------------------------------------------
-- 23.	Check that all inventory start and END measures are consistent with
--	the length of the section. If any END measures are greater than
--	section length (to within an acceptable tolerance) then flag and
--	repair. The scripts will currently fail any inventory measures that
--	are greater than the section length. The lengths must then be reset
--	to the length of section.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT iit_st_chain
       , iit_END_chain
       , iit_item_id
       , iit_ity_inv_code
	   , NVL(iit_END_chain,0) - NVL(iit_st_chain,0)  inv_length
       , rse_length
       , rse_unique
  FROM   INV_ITEMS_ALL
       , ROAD_SEGS
  WHERE  rse_he_id = iit_rse_he_id
  AND   (NVL(iit_END_chain,0) - NVL(iit_st_chain,0) > rse_length
  OR     GREATEST(iit_st_chain, NVL(iit_end_chain, iit_st_chain)) > rse_length
  OR     iit_st_chain < 0
  OR     iit_end_chain < 0)
  ORDER BY 4;

--
  l_inv_length  NUMBER;
--
BEGIN

  g_proc_name := 'inv_start_end_count';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
     IF c1rec.inv_length > c1rec.rse_length THEN
        g_error := 'Item id ('||c1rec.iit_item_id||') with a length of '||c1rec.inv_length||' is located on road section ('||c1rec.rse_unique||') of length ('||c1rec.rse_length||')';

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Items with a length greater than the road length'
                ,pi_pmci_details     => g_error);
     ELSE

        g_error := c1rec.iit_ity_inv_code||' Item id ('||c1rec.iit_item_id||') at position '||c1rec.iit_st_chain||', '||c1rec.iit_end_chain||' cannot be located on road ('||c1rec.rse_unique||') with length ('||c1rec.rse_length||')';

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Items located outside the length of the road section. Either the road section length or the inventory item position needs modifying.'
                ,pi_pmci_details     => g_error);
     END IF;
  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL
                    ,pi_note_over_fail => TRUE);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE valid_xsp IS -- 24
--
---------------------------------------------------------------------------
-- 24.      Confirm that all XSP related inventory has a valid XSP value.
---------------------------------------------------------------------------
  CURSOR get_invalid_xsp_items IS
  SELECT iit_item_id
        ,iit_ity_inv_code
        ,iit_ity_sys_flag
        ,rse_unique
        ,iit_st_chain
        ,iit_end_chain
        ,iit_primary_key
        ,iit_x_sect
  FROM   INV_ITEMS_ALL
        ,ROAD_SEGS
  WHERE (iit_ity_inv_code, iit_ity_sys_flag)
     IN (SELECT ity_inv_code, ity_sys_flag
         FROM INV_ITEM_TYPES
         WHERE ity_x_sect_allow_flag = 'N')
  AND    iit_rse_he_id = rse_he_id
  AND    iit_x_sect IS NOT NULL;

BEGIN

  g_proc_name := 'valid_xsp';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR v_recs IN
    (SELECT ity.ity_sys_flag           ity_sys_flag
          , ity.ity_inv_code           ity_inv_code
          , NVL(invt.iit_x_sect,'NULL') iit_x_sect
          , COUNT(*)                    record_count
     FROM INV_ITEM_TYPES  ity
         ,INV_ITEMS_ALL   invt
     WHERE ity.ity_x_sect_allow_flag='Y'
     AND   invt.iit_ity_inv_code=ity.ity_inv_code
     AND   invt.iit_ity_sys_flag=ity.ity_sys_flag
     AND   NOT EXISTS
                  (
                   SELECT   'valid xsp'
                   FROM     XSP_RESTRAINTS xsr
                   WHERE    xsr.xsr_ity_inv_code = invt.iit_ity_inv_code
                   AND      xsr.xsr_ity_sys_flag = invt.iit_ity_sys_flag
                   AND      xsr.xsr_x_sect_value = NVL(invt.iit_x_sect,'NULL')
                   )
     GROUP BY ity.ity_sys_flag
            , ity.ity_inv_code
            , invt.iit_x_sect)
   LOOP
--
      g_error := 'Inventory type ('||v_recs.ity_inv_code||') - iit_ity_sys_flag('||v_recs.ity_sys_flag||') -  XSP ('||v_recs.iit_x_sect||') , '||v_recs.record_count||' items';

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Records with No valid XSP in XSP_RESTRAINTS'
              ,pi_pmci_details     => g_error);

   END LOOP;

   FOR irec IN get_invalid_xsp_items LOOP
--
     g_error := 'Inventory Type '||irec.iit_ity_inv_code||' on road - ('||irec.rse_unique||','||irec.iit_st_chain||', to '||irec.iit_end_chain||'). Item ('||irec.iit_item_id||') has XSP  ('||irec.iit_x_sect||')';

     pmci_ins(pi_pmci_pmc_ref     => g_proc_name
             ,pi_pmci_issue_label => 'Items with XSP specified despite inventory type definition not allowing XSP'
             ,pi_pmci_details     => g_error);

   END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END valid_xsp;
--
-----------------------------------------------------------------------------
--
PROCEDURE inv_type_exclusive IS
--
---------------------------------------------------------------------------
-- 25.	Is inventory type exclusive and does it overlap? If so, then
--	repair.
---------------------------------------------------------------------------
/*  CURSOR c1 IS
  SELECT a.iit_ity_inv_code
        ,Hignet.get_rse_unique(a.iit_rse_he_id) road
        ,a.iit_st_chain a_start
        ,a.iit_end_chain a_end
        ,a.iit_item_id item_a
        ,b.iit_item_id item_b
        ,b.iit_st_chain b_start
        ,b.iit_end_chain b_end
  FROM   INV_ITEMS_ALL a
        ,INV_ITEMS_ALL b
  WHERE  b.iit_rse_he_id = a.iit_rse_he_id
  AND    b.iit_ity_inv_code = a.iit_ity_inv_code
  AND    b.iit_ity_sys_flag = a.iit_ity_sys_flag
  AND    a.iit_item_id != b.iit_item_id
  AND    (a.iit_x_sect = b.iit_x_sect
          OR (a.iit_x_sect IS NULL AND b.iit_x_sect IS NULL))
  AND    ((b.iit_st_chain BETWEEN a.iit_st_chain+1 AND a.iit_end_chain-1)
        OR (b.iit_end_chain BETWEEN a.iit_st_chain+1 AND a.iit_end_chain-1))
  AND   (a.iit_end_date IS NULL
        OR (a.iit_end_date IS NOT NULL AND a.iit_end_date BETWEEN b.iit_cre_date AND NVL(b.iit_end_date, a.iit_end_date)) )
  AND   a.iit_cre_date BETWEEN b.iit_cre_date AND NVL(b.iit_end_date, b.iit_cre_date)
  AND (a.iit_ity_inv_code, a.iit_rse_he_id) IN (SELECT iit_ity_inv_code
                                                     , iit_rse_he_id
                                                  FROM INV_ITEMS_ALL
                                                     , INV_ITEM_TYPES
                                                  WHERE iit_ity_inv_code = ity_inv_code
                                                  AND ity_contiguous = 'C'
                                                  GROUP BY iit_ity_inv_code, iit_rse_he_id
                                                  HAVING COUNT(*) > 1)
  ORDER BY 1, 2;
*/


CURSOR c_candidates IS
  SELECT iit_rse_he_id,iit_ity_inv_code,iit_ity_sys_flag,COUNT(*)
  FROM INV_ITEMS_ALL
  ,INV_ITEM_TYPES
  WHERE iit_ity_inv_code=ity_inv_code
  AND iit_ity_sys_flag=ity_dtp_flag
  AND ity_contiguous IN ('Y','C')
  GROUP BY iit_rse_he_id,iit_ity_inv_code,iit_ity_sys_flag
  HAVING COUNT(*)>1;

CURSOR c1(pi_rse_he_id NUMBER, pi_inv_code VARCHAR, pi_sys_flag VARCHAR) IS
SELECT a.iit_ity_inv_code
        ,Hignet.get_rse_unique(a.iit_rse_he_id) road
        ,a.iit_st_chain a_start
        ,a.iit_end_chain a_end
        ,a.iit_item_id item_a
        ,b.iit_item_id item_b
        ,b.iit_st_chain b_start
        ,b.iit_end_chain b_end
  FROM   INV_ITEMS_ALL a
        ,INV_ITEMS_ALL b
  WHERE  b.iit_rse_he_id = a.iit_rse_he_id
  AND    b.iit_ity_inv_code = a.iit_ity_inv_code
  AND    b.iit_ity_sys_flag = a.iit_ity_sys_flag
  AND    a.iit_item_id != b.iit_item_id
  AND    (a.iit_x_sect = b.iit_x_sect
          OR (a.iit_x_sect IS NULL AND b.iit_x_sect IS NULL))
  AND    ((b.iit_st_chain BETWEEN a.iit_st_chain+1 AND a.iit_end_chain-1)
        OR (b.iit_end_chain BETWEEN a.iit_st_chain+1 AND a.iit_end_chain-1))
  AND   (a.iit_end_date IS NULL
        OR (a.iit_end_date IS NOT NULL AND a.iit_end_date BETWEEN b.iit_cre_date AND NVL(b.iit_end_date, a.iit_end_date)) )
  AND   a.iit_cre_date BETWEEN b.iit_cre_date AND NVL(b.iit_end_date, b.iit_cre_date)
  AND a.iit_rse_he_id=pi_rse_he_id
  AND a.iit_ity_inv_code=pi_inv_code
  AND a.iit_ity_sys_flag=pi_sys_flag;

--
BEGIN

  g_proc_name := 'inv_type_exclusive';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c_can IN c_candidates LOOP
    FOR c1rec IN c1(c_can.iit_rse_he_id, c_can.iit_ity_inv_code,c_can.iit_ity_sys_flag) LOOP
      g_error := 'Inventory Type '||c1rec.iit_ity_inv_code||' on road - ('||c1rec.road||'). Item '||c1rec.item_a||' ('||c1rec.a_start||','||c1rec.a_end||') overlaps with '||c1rec.item_b||' ('||c1rec.b_start||','||c1rec.b_end||')';

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'List of Exclusive Inventory Type Overlaps'
                ,pi_pmci_details     => g_error);

    END LOOP;
  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE inventory_hierarchy IS --26
--
---------------------------------------------------------------------------
-- 26.	If inventory type is hierarchical, are the type relationships in
--	existence, if not fail - these should be identified in advance of
--	any attempt to migrate or migration needs to insert the hierarchy
--	rules during execution. Former approach preferred.
---------------------------------------------------------------------------
 CURSOR get_invalid_parent_types IS
  SELECT ity_c.ity_inv_code
        ,ity_c.ity_sys_flag
        ,ity_c.ity_parent_ity
  FROM   INV_ITEM_TYPES ity_c
        ,INV_ITEM_TYPES ity_p
  WHERE  ity_c.ity_parent_ity = ity_p.ity_inv_code (+)
  AND    ity_c.ity_sys_flag   = ity_p.ity_sys_flag (+)
  AND    ity_c.ity_parent_ity IS NOT NULL
  AND    ity_p.ity_inv_code IS NULL;
--
BEGIN

  g_proc_name := 'inventory_hierarchy';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN get_invalid_parent_types LOOP
    g_error := 'Item Type ('||irec.ity_inv_code||') Sys Flag  ('||irec.ity_sys_flag||') has an invalid parent type of '||irec.ity_parent_ity;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Inventory Types with invalid parent types'
            ,pi_pmci_details     => g_error);
  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END inventory_hierarchy;
--
-----------------------------------------------------------------------------
--
PROCEDURE hier_inv_dangling IS
--
---------------------------------------------------------------------------
-- 27.	Confirm that all hierarchies are as expected - no dangling
--	sub-items.
---------------------------------------------------------------------------
  CURSOR invalid_relations IS -- orphaned children or invalid parents
  SELECT iit.iit_ity_inv_code child_inv_code
        ,iit.iit_ity_sys_flag
        ,iit.iit_item_id
        ,iit.iit_rse_he_id
        ,iit.iit_foreign_key
        ,iit_link.iit_item_id      parent_item
        ,iit_link.iit_ity_inv_code parent_inv_code
        ,iit_link.iit_ity_sys_flag parent_sys_flag
        ,ity_c_p.ity_parent_ity proper_parent
  FROM INV_ITEMS_ALL iit_link
      ,INV_ITEM_TYPES ity_c_p
      ,(SELECT /*+ ALL_ROWS */
               iit.iit_ity_inv_code
              ,iit.iit_ity_sys_flag
              ,iit.iit_item_id
              ,iit.iit_rse_he_id
              ,iit.iit_foreign_key
        FROM   INV_ITEMS_ALL iit
              ,INV_ITEM_TYPES ity
        WHERE  iit.iit_ity_inv_code = ity.ity_inv_code
        AND    iit.iit_ity_sys_flag = ity.ity_sys_flag
        AND    ity.ity_parent_ity IS NOT NULL
        AND NOT EXISTS (SELECT 1
                        FROM  INV_ITEMS_ALL p_iit
                        WHERE p_iit.iit_ity_inv_code = ity.ity_parent_ity
                        AND   p_iit.iit_ity_sys_flag = ity.ity_sys_flag
                        AND   p_iit.iit_primary_key = iit.iit_foreign_key)) iit
  WHERE iit_link.iit_primary_key (+) = iit.iit_foreign_key
  AND   iit.iit_ity_inv_code = ity_c_p.ity_inv_code
  AND   iit.iit_ity_sys_flag = ity_c_p.ity_sys_flag;
--
BEGIN

  g_proc_name := 'hier_inv_dangling';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN invalid_relations LOOP
    IF irec.parent_item IS NULL THEN
      -- no parent
      g_error := 'Item ('||irec.iit_item_id||') of type  ('||irec.child_inv_code||','||irec.iit_ity_sys_flag||') is orphaned ';

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
              ,pi_pmci_issue_label => 'Orphan inventory items'
              ,pi_pmci_details     => g_error);

    ELSIF irec.parent_inv_code != irec.proper_parent
        OR irec.parent_sys_flag != irec.iit_ity_sys_flag THEN

        -- invalid parent type;

        g_error := 'Item Type ('||irec.child_inv_code||') Sys Flag  ('||irec.iit_ity_sys_flag||') has invalid parent type of '||irec.parent_inv_code||','||irec.parent_sys_flag;

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Inventory Types with invalid parent types'
                ,pi_pmci_details     => g_error);
    END IF;
  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END hier_inv_dangling;
--
-----------------------------------------------------------------------------
--
PROCEDURE fk_incorrect1 IS
--
---------------------------------------------------------------------------
-- 28.	If fk field is not set and item is a mandatory sub-item - fail.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT iit_item_id
  FROM  INV_ITEMS_ALL, INV_ITEM_TYPES
  WHERE ity_parent_ity IS NOT NULL
  AND ity_inv_code = iit_ity_inv_code
  AND ity_sys_flag = iit_ity_sys_flag
  AND iit_foreign_key IS NULL;
--

--
BEGIN

  g_proc_name := 'fk_incorrect1';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    g_error := 'Item ID - '||c1rec.iit_item_id;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Items of Type Hierarchical But Foriegn Key Not Specified'
            ,pi_pmci_details     => g_error);


  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END;
--
-----------------------------------------------------------------------------
--
PROCEDURE hier_inv_locations IS
--
---------------------------------------------------------------------------
-- 29.	Check that locations of child items match that of the parent
--	(depENDing on anticipated ITG relationship).
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT iit_item_id, iit_ity_sys_flag, iit_rse_he_id
  FROM INV_ITEMS_ALL
  WHERE iit_foreign_key IS NOT NULL;
--
  CURSOR c2( p_item_code INV_ITEMS_ALL.iit_item_id%TYPE
           , p_sys_flag INV_ITEMS_ALL.iit_ity_sys_flag%TYPE
           ) IS
  SELECT iit_item_id, iit_ity_sys_flag, iit_rse_he_id
  FROM INV_ITEMS_ALL
  WHERE iit_item_id = p_item_code
  AND iit_ity_sys_flag = p_sys_flag;
--

  l_start_date DATE;
  l_END_date DATE;
--
BEGIN

  g_proc_name := 'hier_inv_locations';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    FOR c2rec IN c2( c1rec.iit_item_id, c1rec.iit_ity_sys_flag ) LOOP
      IF c1rec.iit_rse_he_id != c2rec.iit_rse_he_id
        THEN
          g_error := 'Item ID ('||c2rec.iit_item_id||') Parent location ('||c2rec.iit_rse_he_id||') Child location ('||c1rec.iit_rse_he_id||')';

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Items Where Parent Location Does Not Match Child Location'
                  ,pi_pmci_details     => g_error);

      END IF;
    END LOOP;
  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE fk_incorrect2 IS
--
---------------------------------------------------------------------------
-- 30.	If not hierarchical and FK is specified fail - this should not be
-- 	used as another flexible attribute.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT iit_item_id
  FROM INV_ITEM_TYPES, INV_ITEMS_ALL
  WHERE ity_parent_ity IS NULL
  AND ity_inv_code = iit_ity_inv_code
  AND ity_sys_flag = iit_ity_sys_flag
  AND iit_foreign_key IS NOT NULL;
--

  l_dum NUMBER;
  l_iit_item_id INV_ITEMS_ALL.iit_item_id%TYPE;
--
BEGIN

  g_proc_name := 'fk_incorrect2';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    g_error := 'Item ID - '||c1rec.iit_item_id;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Items NOT of Type Hierarchical But Foriegn Key Specified'
            ,pi_pmci_details     => g_error);


  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE hier_inv_dates IS
--
---------------------------------------------------------------------------
-- 31.	Parent END date may not be less that child END date, parent start
--	date may not be greater than child start date.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT ity_inv_code, ity_sys_flag, ity_start_date, ity_END_date
  FROM INV_ITEM_TYPES
  WHERE ity_parent_ity IS NOT NULL;
--
  CURSOR c2( p_inv_code INV_ITEM_TYPES.ity_inv_code%TYPE
           , p_sys_flag INV_ITEM_TYPES.ity_sys_flag%TYPE
           ) IS --returns the child item where has a parent
  SELECT ity_inv_code, ity_sys_flag, ity_start_date, ity_END_date
  FROM INV_ITEM_TYPES
  WHERE ity_inv_code = p_inv_code
  AND ity_sys_flag = p_sys_flag;
--
  CURSOR c3 IS
  SELECT iit_item_id, iit_ity_sys_flag, iit_cre_date, iit_END_date
  FROM INV_ITEMS_ALL
  WHERE iit_foreign_key IS NOT NULL;
--
  CURSOR c4( p_item_code INV_ITEMS_ALL.iit_item_id%TYPE
           , p_sys_flag INV_ITEMS_ALL.iit_ity_sys_flag%TYPE
           ) IS
  SELECT iit_item_id, iit_ity_sys_flag, iit_cre_date, iit_END_date
  FROM INV_ITEMS_ALL
  WHERE iit_item_id = p_item_code
  AND iit_ity_sys_flag = p_sys_flag;
--

  l_start_date DATE;
  l_END_date DATE;
--
BEGIN

  g_proc_name := 'hier_inv_dates';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    FOR c2rec IN c2( c1rec.ity_inv_code, c1rec.ity_sys_flag ) LOOP
      IF c2rec.ity_END_date < c1rec.ity_END_date
        THEN

          g_error := 'Type Parent('||c2rec.ity_inv_code||'.'||c2rec.ity_sys_flag||
                     ') END date ('||c2rec.ity_END_date||') > Child('||c1rec.ity_inv_code||'.'||c1rec.ity_sys_flag||
                     ') END date ('||c1rec.ity_END_date||')';

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);

      END IF;
      --
      IF c1rec.ity_start_date < c2rec.ity_start_date
        THEN
          g_error := 'Type Parent('||c2rec.ity_inv_code||'.'||c2rec.ity_sys_flag||
                     ') END date ('||c2rec.ity_start_date||') < Child('||c1rec.ity_inv_code||'.'||c1rec.ity_sys_flag||
                     ') END date ('||c1rec.ity_start_date||')';

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);
      END IF;
    END LOOP;
  END LOOP;
--
  FOR c3rec IN c3 LOOP
    FOR c4rec IN c4( c3rec.iit_item_id, c3rec.iit_ity_sys_flag ) LOOP
      IF c4rec.iit_END_date < c3rec.iit_END_date
        THEN
          g_error := 'Item Parent('||c4rec.iit_item_id||'.'||c4rec.iit_ity_sys_flag||
                     ') END date ('||c4rec.iit_END_date||') > Child('||c3rec.iit_item_id||'.'||c3rec.iit_ity_sys_flag||
                     ') END date ('||c3rec.iit_END_date||')';

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);
      END IF;
      --
      IF c3rec.iit_cre_date < c4rec.iit_cre_date
        THEN
          g_error := 'Item Parent('||c4rec.iit_item_id||'.'||c4rec.iit_ity_sys_flag||
                     ') END date ('||c4rec.iit_cre_date||') < Child('||c3rec.iit_item_id||'.'||c3rec.iit_ity_sys_flag||
                     ') END date ('||c3rec.iit_cre_date||')';

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);
      END IF;
    END LOOP;
  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
---------------------------------------------------------------------------
-- 32.	Admin units of child and parent should be the same. This should be
--	mandated due to the derivation of AU from inventory location.
---------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
PROCEDURE check_roles IS
--
---------------------------------------------------------------------------
-- 33.	Migration INV_CATEGORY_ROLES to individual NM_INV_TYPE_ROLES - all
--	roles must exist as HIG_ROLES and exist as roles in the database.
-- Added by DC
-- Checking if the role exists can only be done by checking dba_roles
--  querying session_roles jst lists active roles for the current user
---------------------------------------------------------------------------
  CURSOR role_check IS
  SELECT icr_role
  FROM   ITY_CATEGORY_ROLES
  WHERE NOT EXISTS (SELECT 1 FROM HIG_ROLES
                                 ,dba_roles
                    WHERE hro_role = icr_role
                    AND   hro_role = ROLE);

  l_dum NUMBER;
--
BEGIN

  g_proc_name := 'check_roles';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN role_check LOOP
      g_error := 'Role - '||c1rec.icr_role;
          ----------------------------------------------------------
          -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
          ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Inventory Category Roles Missing From HIG_ROLES/SESSION_ROLES'
                  ,pi_pmci_details     => g_error);

  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_inv_attr_valid_col IS
--
-- Ensure that valid columns on inv_items are being used to store
-- flexible attribute values
--
  CURSOR c1 IS
  SELECT
         atc.column_name,
         ita_ity_sys_flag,
         ita_iit_inv_code,
         ita_scrn_text
  FROM
         INV_TYPE_ATTRIBS ita,
         all_tab_columns  atc
  WHERE  atc.owner= USER
  AND    atc.table_name = 'INV_ITEMS_ALL'
  AND    nullable='N'
  AND    atc.column_name = ita.ita_attrib_name;

  CURSOR c_nm3_view_cols IS
  SELECT ita_iit_inv_code
        ,ita_ity_sys_flag
        ,ita_attrib_name
        ,ita_scrn_text
  FROM   INV_TYPE_ATTRIBS
  WHERE  ita_view_col_name IN (
  'IIT_ADMIN_UNIT'
  ,'IIT_CREATED_BY'
  ,'IIT_DATE_CREATED'
  ,'IIT_DATE_MODIFIED'
  ,'IIT_DESCR'
  ,'IIT_END_DATE'
  ,'IIT_INV_TYPE'
  ,'IIT_MODIFIED_BY'
  ,'IIT_NE_ID'
  ,'IIT_NOTE'
  ,'IIT_PEO_INVENT_BY_ID'
  ,'IIT_PRIMARY_KEY'
  ,'IIT_START_DATE'
  ,'IIT_X_SECT'
  ,'MEMBER_UNIQUE'
  ,'NAU_UNIT_CODE'
  ,'NE_ID'
  ,'NE_ID_OF'
  ,'NM_ADMIN_UNIT'
  ,'NM_BEGIN_MP'
  ,'NM_END'
  ,'NM_END_DATE'
  ,'NM_END_MP'
  ,'NM_SEQ_NO'
  ,'NM_START'
  ,'NM_START_DATE');

  CURSOR get_dup_disp_seq IS
  SELECT ita_iit_inv_code
        ,ita_ity_sys_flag
        ,ita_disp_seq_no
        ,COUNT(*)
  FROM   INV_TYPE_ATTRIBS
  WHERE  ita_disp_seq_no IS NOT NULL
  GROUP BY  ita_iit_inv_code
           ,ita_ity_sys_flag
           ,ita_disp_seq_no
  HAVING COUNT(*) > 1;

BEGIN

  g_proc_name := 'check_inv_attr_valid_col';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP

    g_error := 'Inventory Type ('||c1rec.ita_iit_inv_code||'),('||c1rec.ita_ity_sys_flag||')  Attribute Screen Text ('||c1rec.ita_scrn_text||')   INV_ITEMS_ALL Column ('||c1rec.column_name||')';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Inventory Flexible Attribute(s) Using Invalid Column on INV_ITEMS_ALL'
            ,pi_pmci_details     => g_error);

  END LOOP;

  FOR irec IN c_nm3_view_cols LOOP

    g_error := 'Inventory Type ('||irec.ita_iit_inv_code||'),('||irec.ita_ity_sys_flag||')    Attribute ('||irec.ita_attrib_name||') ';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'NM3 Reserved Inventory View Column Names'
            ,pi_pmci_details     => g_error);

  END LOOP;

  FOR irec IN get_dup_disp_seq LOOP

    g_error := 'Inventory Type ('||irec.ita_iit_inv_code||'),('||irec.ita_ity_sys_flag||')  has duplicates of display sequence '||irec.ita_disp_seq_no;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Duplicate Attribute Display Sequence Numbers'
            ,pi_pmci_details     => g_error);

  END LOOP;
  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END check_inv_attr_valid_col;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_inv_attr IS
--
---------------------------------------------------------------------------
-- 34.	Check that the column data type in which the attribute resides
-- 	supports the format of the inv attr data.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT ita_attrib_name, ita_format, ita_iit_inv_code, ita_ity_sys_flag
  FROM INV_TYPE_ATTRIBS;
--
  CURSOR c2( p_column_name user_tab_columns.column_name%TYPE
           ) IS
  SELECT table_name, column_name, data_type
  FROM user_tab_columns
  WHERE table_name = 'INV_ITEMS_ALL'
    AND column_name = p_column_name;
--
  CURSOR attribs_missing_domains IS
  SELECT ita_ity_sys_flag
        ,ita_iit_inv_code
        ,ita_attrib_name
  FROM   INV_TYPE_ATTRIBS
  WHERE  ita_validate_yn = 'Y'
  AND NOT EXISTS (SELECT 1
                  FROM   INV_ATTRI_DOMAINS
                  WHERE  iad_ita_attrib_name  = ita_attrib_name
                  AND    iad_ita_inv_code     = ita_iit_inv_code
                  AND    iad_ita_ity_sys_flag = ita_ity_sys_flag)
  ORDER BY 1,2,3;

  CURSOR orphaned_lookup_vals IS
  SELECT  iad_ita_attrib_name
         ,iad_ita_inv_code
         ,iad_ita_ity_sys_flag
         ,COUNT(*) COUNT
  FROM INV_ATTRI_DOMAINS
  WHERE NOT EXISTS (SELECT 1
                    FROM   INV_TYPE_ATTRIBS
                    WHERE  iad_ita_attrib_name  = ita_attrib_name
                    AND    iad_ita_inv_code     = ita_iit_inv_code
                    AND    iad_ita_ity_sys_flag = ita_ity_sys_flag)
  GROUP BY iad_ita_inv_code
          ,iad_ita_ity_sys_flag
          ,iad_ita_attrib_name;

  CURSOR invalid_view_names IS
  SELECT ity_view_name, ity_inv_code, ity_sys_flag
  FROM   INV_ITEM_TYPES
  WHERE  INSTR(TRANSLATE(ity_view_name, ' &|:,-=>[<(.+])!/*^@', '&'), '&') > 0
  OR     ASCII(SUBSTR(ity_view_name, 1, 1)) BETWEEN 48 AND 57
  OR     EXISTS (SELECT 1
                 FROM   v$reserved_words
                 WHERE  keyword = ity_view_name);

  CURSOR invalid_view_cols IS
  SELECT ita_iit_inv_code
        ,ita_ity_sys_flag
        ,ita_attrib_name
        ,ita_view_col_name
  FROM   INV_TYPE_ATTRIBS
  WHERE  INSTR(TRANSLATE(ita_view_col_name, ' &|:,-=>[<(.+])!/*^@', '&'), '&') > 0
  OR     ASCII(SUBSTR(ita_view_col_name, 1, 1)) BETWEEN 48 AND 57
  ORDER BY 2,1,3;

  CURSOR dup_view_cols IS
  SELECT    ita_view_col_name, ita_ity_sys_flag, ita_iit_inv_code, COUNT(*)
  FROM      INV_TYPE_ATTRIBS
  GROUP BY  ita_iit_inv_code, ita_ity_sys_flag, ita_view_col_name
  HAVING    COUNT(*) > 1;

  l_table_name user_tab_columns.table_name%TYPE;
  l_column_name user_tab_columns.column_name%TYPE;
  l_data_type user_tab_columns.data_type%TYPE;

--
BEGIN

  g_proc_name := 'check_inv_attr';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    OPEN c2( c1rec.ita_attrib_name );
    FETCH c2 INTO l_table_name, l_column_name, l_data_type;
    IF c2%NOTFOUND
      THEN
        CLOSE c2;
        g_error := 'Inventory Type ('||c1rec.ita_iit_inv_code||') Sys Flag ('||c1rec.ita_ity_sys_Flag||') Attribute ('||c1rec.ita_attrib_name||')';

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Inventory Attribute Column Missing from INV_ITEMS_ALL'
                ,pi_pmci_details     => g_error);

    ELSE
      CLOSE c2;
      IF c1rec.ita_format != l_data_type
        THEN

          g_error := 'Inventory Type ('||c1rec.ita_iit_inv_code||') Sys Flag ('||c1rec.ita_ity_sys_Flag||') Attribute ('||c1rec.ita_attrib_name||') inv_type_attribs ('||c1rec.ita_format||')  inv_items_all('||l_data_type||')';

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Data Types Do Not Match - inv_type_attribs'
                  ,pi_pmci_details     => g_error);

      END IF;
    END IF;
  END LOOP;

  FOR irec IN attribs_missing_domains LOOP

    g_error := 'Inventory Type ('||irec.ita_iit_inv_code||')  Attribute ('||irec.ita_attrib_name||') on sys flag ('||irec.ita_ity_sys_flag||') is missing a domain';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Attribute is flagged as validate but there are no values to validate against'
            ,pi_pmci_details     => g_error);
  END LOOP;

  FOR irec IN orphaned_lookup_vals LOOP

    g_error := 'Inventory Type ('||irec.iad_ita_inv_code||')  Attribute ('||irec.iad_ita_attrib_name||') on sys flag ('||irec.iad_ita_ity_sys_flag||') has '||irec.COUNT||' orphaned values';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Domain lookup values that do not match a inventory attribute'
            ,pi_pmci_details     => g_error);
  END LOOP;

  FOR irec IN invalid_view_names LOOP

    g_error := 'Inventory type '||irec.ity_inv_code||' on sys flag '||irec.ity_sys_flag||' has an invalid view name of '||irec.ity_view_name;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Invalid view name.'
            ,pi_pmci_details     => g_error);
  END LOOP;

  FOR irec IN invalid_view_cols LOOP

    g_error := 'Inventory type '||irec.ita_iit_inv_code||' on sys flag '||irec.ita_ity_sys_flag||' attribute '||irec.ita_attrib_name||' has an invalid view column name of '||irec.ita_view_col_name;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Invalid view column.'
            ,pi_pmci_details     => g_error);
  END LOOP;

  FOR irec IN dup_view_cols LOOP

    g_error := 'Inventory type '||irec.ita_iit_inv_code||' on sys flag '||irec.ita_ity_sys_flag||' has a duplicate column name of '||irec.ita_view_col_name;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Invalid view name.'
            ,pi_pmci_details     => g_error);
  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_lookup_varchar IS
--
---------------------------------------------------------------------------
-- 35.	Domain lookup values are in character columns.
---------------------------------------------------------------------------
  ---------------------------------------------
  -- select attribute column name and inv code
  -- where the column exists on inv_Items_all
  -- but it is not a varchar2 column
  ---------------------------------------------
  CURSOR c1 IS
  SELECT UNIQUE iad_ita_attrib_name, iad_ita_inv_code
  FROM INV_ATTRI_DOMAINS
  WHERE EXISTS(SELECT 'x'
               FROM   user_tab_columns utc
		       WHERE  table_name = 'INV_ITEMS_ALL'
			   AND    column_name = iad_ita_attrib_name)
  AND NOT EXISTS(SELECT 'x'
                   FROM   user_tab_columns utc
				   WHERE  table_name = 'INV_ITEMS_ALL'
				   AND    column_name = iad_ita_attrib_name
				   AND    data_type = 'VARCHAR2')
   ORDER BY 1,2;

  l_dum NUMBER;
  l_count NUMBER := 0;


--
BEGIN

  g_proc_name := 'check_lookup_varchar';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP

        g_error := 'Attribute ('||c1rec.iad_ita_attrib_name||') Inventory Type ('||c1rec.iad_ita_inv_code||')';

          ----------------------------------------------------------
          -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
          ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'List of Non VARCHAR2 Domain Lookup Attributes - Ordered by Inventory Type'
                  ,pi_pmci_details     => g_error);

  END LOOP;



  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_inv_min_max IS
--
---------------------------------------------------------------------------
-- 36.	Check that the range/domain values are mutually exclusive.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT ita_format, ita_attrib_name,ITA_IIT_INV_CODE, ITA_ITY_SYS_FLAG
  FROM INV_TYPE_ATTRIBS
  WHERE ita_min IS NOT NULL
  OR ita_max IS NOT NULL;
--
  CURSOR c2( p_attrib_name INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
            ,p_inv_code INV_TYPE_ATTRIBS.ITA_IIT_INV_CODE%TYPE
            ,p_sys_flag INV_TYPE_ATTRIBS.ITA_ITY_SYS_FLAG%TYPE
           ) IS
  SELECT COUNT(1)
  FROM INV_ATTRI_DOMAINS
  WHERE iad_ita_attrib_name = p_attrib_name
  AND IAD_ITA_INV_CODE=p_inv_code
  AND IAD_ITA_ITY_SYS_FLAG=p_sys_flag ;

--
  l_dum NUMBER;
  l_count NUMBER := 0;

--
BEGIN


  g_proc_name := 'check_inv_min_max';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    IF c1rec.ita_format = 'VARCHAR2'
      THEN

        g_error := 'Type '||c1rec.ita_iit_inv_code||' Sys Flag '||c1rec.ita_ity_sys_Flag||' Attribute ('||c1rec.ita_attrib_name||')';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'VARCHAR2 Attributes that have  min/max values'
                ,pi_pmci_details     => g_error);

    END IF;
    --
    OPEN c2( c1rec.ita_attrib_name, c1rec.ita_iit_inv_code, c1rec.ita_ity_sys_Flag );
    FETCH c2 INTO l_dum;
    CLOSE c2;
    IF l_dum > 0
      THEN


        g_error := 'Type '||c1rec.ita_iit_inv_code||' Sys Flag '||c1rec.ita_ity_sys_Flag||' Attribute ('||c1rec.ita_attrib_name||')  Count ('||l_dum||')';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Count of Domain Entries for Attributes that have min/max values'
                ,pi_pmci_details     => g_error);

    END IF;
  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_reserved_words IS
--
---------------------------------------------------------------------------
-- 37.	Check for keywords in view column definitions, this includes nm3
--	reserved column names such as 'IIT_NE_ID'.
---------------------------------------------------------------------------
--
  CURSOR c1 IS
  SELECT ita_iit_inv_code, ita_attrib_name
  FROM   INV_TYPE_ATTRIBS
  WHERE  ita_attrib_name IN ('IIT_NE_ID'
                            ,'IIT_ITEM_ID'
                            ,'IIT_INV_TYPE'
                            ,'IIT_ITY_INV_CODE'
                            ,'IIT_START_DATE'
                            ,'IIT_DATE_CREATED'
                            ,'IIT_DATE_MODIFIED'
                            ,'IIT_CREATED_BY'
                            ,'IIT_MODIFIED_BY'
                            ,'IIT_ADMIN_UNIT'
                            ,'IIT_DESCR'
                            ,'IIT_NOTE'
                            ,'IIT_PEO_INVENT_BY_ID'
                            ,'NE_ID_OF'
                            ,'NE_UNIQUE'
                            ,'NM_BEGIN_MP'
                            ,'IIT_ST_CHAIN'
                            ,'NM_END_MP'
                            ,'NM_SEQ_NO'
                            ,'NM_START_DATE'
                            ,'NM_END_DATE'
                            ,'NM_ADMIN_UNIT'
                            ,'IIT_X_SECT'
                            ,'IIT_END_DATE'
                            ,'NAU_UNIT_CODE'
                            ,'NE_ID'
                            ,'IIT_RSE_HE_ID'
                            ,'NM_START'
                            ,'NM_END'
                            ,'NLM_INVENT_DATE'
                            ,'NLM_ACTION_CODE')
  GROUP BY ita_iit_inv_code, ita_attrib_name;
--
BEGIN

  g_proc_name := 'check_reserved_words';
  set_pmc_start(pi_pmc_ref => g_proc_name);
--
  FOR I IN c1 LOOP
    g_error := '('||I.ita_iit_inv_code||') '||I.ita_attrib_name||' is an NM3 reserved column name';
    ----------------------------------------------------------
    -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
    ----------------------------------------------------------
    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => g_error);
  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE domain_lookup_failure IS
---------------------------------------------------------------------------
-- 38.	Domain lookup failure - inconsistency between lookup and actual
-- 	value
---------------------------------------------------------------------------
--
  TYPE ref_cursor IS REF CURSOR;
  ref_cur ref_cursor;
--
  CURSOR c_inval IS
  SELECT iad_ita_attrib_name
       , iad_ita_inv_code
  FROM INV_ATTRI_DOMAINS
  WHERE NOT EXISTS (SELECT 'column is valid'
                    FROM   user_tab_columns
                    WHERE  table_name = 'INV_ITEMS_ALL'
                    AND    column_name = iad_ita_attrib_name)
  GROUP BY iad_ita_inv_code, iad_ita_attrib_name;

  CURSOR c_ad IS
  SELECT DISTINCT iad_ita_attrib_name
                , iad_ita_inv_code
				, iad_ita_ity_sys_flag
  FROM INV_ATTRI_DOMAINS
  WHERE EXISTS (SELECT 'column is valid'
                FROM   user_tab_columns
		        WHERE  table_name = 'INV_ITEMS_ALL'
				AND    column_name = iad_ita_attrib_name);


  TYPE t_tab_iad_attrib_name      IS TABLE OF INV_ATTRI_DOMAINS.iad_ita_attrib_name%TYPE INDEX BY BINARY_INTEGER;
  TYPE t_tab_iad_ita_inv_code     IS TABLE OF INV_ATTRI_DOMAINS.iad_ita_inv_code%TYPE    INDEX BY BINARY_INTEGER;
  TYPE t_tab_iad_ita_ity_sys_flag IS TABLE OF INV_ATTRI_DOMAINS.iad_ita_ity_sys_flag%TYPE    INDEX BY BINARY_INTEGER;

  v_tab_iad_attrib_name       t_tab_iad_attrib_name;
  v_tab_iad_ita_inv_code      t_tab_iad_ita_inv_code;
  v_tab_iad_ita_ity_sys_flag  t_tab_iad_ita_inv_code;

  v_dummy                  VARCHAR2(1000);
--

BEGIN

  g_proc_name := 'domain_lookup_failure';
  set_pmc_start(pi_pmc_ref => g_proc_name);


  FOR i_rec IN c_inval LOOP

        g_error := 'Inventory type '||i_rec.iad_ita_inv_code||' Attribute -  '||i_rec.iad_ita_attrib_name;

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Attributes That Are Not Using a Valid Column in INV_ITEMS_ALL'
                ,pi_pmci_details     => g_error);

  END LOOP;  -- through invalid attribs

  OPEN c_ad;
  FETCH c_ad BULK COLLECT INTO v_tab_iad_attrib_name
                              ,v_tab_iad_ita_inv_code
							  ,v_tab_iad_ita_ity_sys_flag;
  CLOSE c_ad;

  FOR ad IN 1..v_tab_iad_attrib_name.COUNT  LOOP

    v_dummy := NULL;
--    g_sql := 'select DISTINCT iit.'||v_tab_iad_attrib_name(ad)||' from inv_items_all iit where iit.iit_ity_inv_code = '''||v_tab_iad_ita_inv_code(ad)||'''                                                               and iit.'||v_tab_iad_attrib_name(ad)||' is not null and not exists (select 1 from inv_attri_domains iad where iad.iad_ita_inv_code='''||v_tab_iad_ita_inv_code(ad)||'''  and iad.iad_ita_attrib_name='''||v_tab_iad_attrib_name(ad)||'''                                                                    and iad.iad_value =iit.'||v_tab_iad_attrib_name(ad)||')';

    g_sql:=  'SELECT DISTINCT iit.'||v_tab_iad_attrib_name(ad)||' FROM INV_ITEMS_ALL iit WHERE iit.iit_ity_inv_code = '''||v_tab_iad_ita_inv_code(ad)||''' AND iit.iit_ity_sys_flag='''||v_tab_iad_ita_ity_sys_flag(ad)||''' AND iit.'||v_tab_iad_attrib_name(ad)||' IS NOT NULL AND NOT EXISTS (SELECT 1 FROM INV_ATTRI_DOMAINS iad WHERE iad.iad_ita_inv_code='''||v_tab_iad_ita_inv_code(ad)||'''  AND iad.iad_ita_attrib_name='''||v_tab_iad_attrib_name(ad)||''' AND iad.iad_ita_ity_sys_flag='''||v_tab_iad_ita_ity_sys_flag(ad)||'''  AND iad.iad_value =iit.'||v_tab_iad_attrib_name(ad)||')';

    OPEN ref_cur FOR g_sql;
    LOOP

      FETCH ref_cur INTO v_dummy;
      EXIT WHEN ref_cur%NOTFOUND;

      IF v_dummy IS NOT NULL THEN

        g_error := 'Attribute ('||v_tab_iad_attrib_name(ad)||') Inventory Type ('||v_tab_iad_ita_inv_code(ad)||') Sys Flag ('||v_tab_iad_ita_ity_sys_flag(ad)||') has an invalid value of '||v_dummy;

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Inventory Attributes With Value Not in Domain'
                ,pi_pmci_details     => g_error);

      END IF;
    END LOOP;
    CLOSE ref_cur;

  END LOOP; -- loop through attribute name/inv type

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);
EXCEPTION
  WHEN OTHERS THEN

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => SQLERRM);

    update_pmc_outcome(pi_pmc_ref     => g_proc_name
                      ,pi_pmc_notes   => NULL);
END;
---------------------------------------------------------------------------
-- 39.	Attribute data type conflicts with value
---------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
PROCEDURE check_attr_range IS
--
---------------------------------------------------------------------------
-- 40.	Specified attribute range conflicts with value
---------------------------------------------------------------------------
  TYPE tab_varchar80    IS TABLE OF VARCHAR2(80)    INDEX BY BINARY_INTEGER;
--
  l_item_id tab_varchar80;
  l_value tab_varchar80;
--
  CURSOR c1 IS
  SELECT ita_attrib_name
       , ita_min
	   , ita_max
	   , ita_iit_inv_code
	   ,ita_ity_sys_Flag
  FROM INV_TYPE_ATTRIBS
  WHERE ita_min IS NOT NULL
  AND ita_max IS NOT NULL
  AND EXISTS (SELECT 'there is inventory to check'
              FROM INV_ITEMS_ALL
              WHERE iit_ity_inv_code = ita_iit_inv_code
              AND iit_ity_sys_flag=ita_ity_sys_Flag)
  ORDER BY ita_iit_inv_code;
--

--

--
  TYPE ref_cursor IS REF CURSOR;
  ref_cur ref_cursor;

  TYPE rec_min_max IS RECORD
     (inv_type                   INV_ITEM_TYPES.ity_inv_code%TYPE
     ,ita_sys_flag		 INV_TYPE_ATTRIBS.ita_ity_sys_Flag%TYPE
     ,ita_attrib_name            INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
     ,min_value                  INV_TYPE_ATTRIBS.ita_min%TYPE
     ,max_value                  INV_TYPE_ATTRIBS.ita_max%TYPE
     ,min_value_encountered      INV_TYPE_ATTRIBS.ita_min%TYPE
     ,max_value_encountered      INV_TYPE_ATTRIBS.ita_max%TYPE
     );
  g_rec_min_max rec_min_max;


  TYPE tab_rec_min_max IS TABLE OF rec_min_max INDEX BY BINARY_INTEGER;
  g_tab_rec_min_max tab_rec_min_max;


  PROCEDURE append_min_max(pi_rec_min_max           IN rec_min_max) IS
     v_subscript PLS_INTEGER := g_tab_rec_min_max.COUNT + 1;
  BEGIN
    g_tab_rec_min_max(v_subscript) := pi_rec_min_max;
  END;


--
BEGIN

  g_proc_name := 'check_attr_range';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP

      g_sql :=    ' select      iit_ity_inv_code'||CHR(10)
	            ||'        ,'''||c1rec.ita_ity_sys_Flag||''''||CHR(10)
	            ||'        ,'''||c1rec.ita_attrib_name||''''||CHR(10)
                ||'        ,'||c1rec.ita_min||CHR(10)
                ||'        ,'||c1rec.ita_max||CHR(10)
                ||'        ,MIN('||c1rec.ita_attrib_name||')'||CHR(10)
                ||'        ,MAX('||c1rec.ita_attrib_name||')'||CHR(10)
                ||' from inv_items_all'||CHR(10)
                ||' where '||c1rec.ita_attrib_name||' is not null'||CHR(10)
	            ||' and  iit_ity_inv_code = '''||c1rec.ita_iit_inv_code||''''||CHR(10)
	            ||' and  iit_ity_sys_flag = '''||c1rec.ita_ity_sys_Flag||''''||CHR(10)
                ||' group by iit_ity_inv_code'||CHR(10)
	            ||'        ,'''||c1rec.ita_ity_sys_Flag||''''||CHR(10)
	            ||'        ,'''||c1rec.ita_attrib_name||''''||CHR(10)
                ||'        ,'||c1rec.ita_min||CHR(10)
                ||'        ,'||c1rec.ita_max||CHR(10);

      OPEN ref_cur FOR g_sql;
	  FETCH ref_cur INTO g_rec_min_max;
	  IF ref_cur%FOUND THEN
    	  CLOSE ref_cur;
          append_min_max(pi_rec_min_max               => g_rec_min_max);
      ELSE
          CLOSE ref_cur;
      END IF;
  END LOOP;

  FOR I IN 1..g_tab_rec_min_max.COUNT LOOP

        IF  g_tab_rec_min_max(I).min_value_encountered < g_tab_rec_min_max(I).min_value THEN

	       g_error := 'Inventory Type ('||g_tab_rec_min_max(I).inv_type||') Sys Flag ('||g_tab_rec_min_max(I).ita_sys_flag||') Attribute ('||g_tab_rec_min_max(I).ita_attrib_name||') Permitted MIN value ('||g_tab_rec_min_max(I).min_value||') Lowest value encountered ('||g_tab_rec_min_max(I).min_value_encountered||')';

           ----------------------------------------------------------
           -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
           ----------------------------------------------------------
           pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                   ,pi_pmci_issue_label => 'MIN Value Violations'
                   ,pi_pmci_details     => g_error);

        END IF;

        IF  g_tab_rec_min_max(I).max_value_encountered > g_tab_rec_min_max(I).max_value THEN

	       g_error := 'Inventory Type ('||g_tab_rec_min_max(I).inv_type||') Sys Flag ('||g_tab_rec_min_max(I).ita_sys_flag||') Attribute ('||g_tab_rec_min_max(I).ita_attrib_name||') Permitted MAX value ('||g_tab_rec_min_max(I).max_value||') Highest value encountered ('||g_tab_rec_min_max(I).max_value_encountered||')';

           ----------------------------------------------------------
           -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
           ----------------------------------------------------------
           pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                   ,pi_pmci_issue_label => 'MAX Value Violations'
                   ,pi_pmci_details     => g_error);

        END IF;


  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

EXCEPTION
  WHEN OTHERS THEN

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => SQLERRM);

    update_pmc_outcome(pi_pmc_ref     => g_proc_name
                      ,pi_pmc_notes   => NULL);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_attr_length IS
--
---------------------------------------------------------------------------
-- 41.	Specified attribute length conflicts with value
---------------------------------------------------------------------------
  TYPE tab_varchar80    IS TABLE OF VARCHAR2(80)    INDEX BY BINARY_INTEGER;
--
  l_item_id tab_varchar80;
  l_value tab_varchar80;
--
  CURSOR c1 IS
  SELECT ita_attrib_name
       , ita_fld_length
	   , ita_iit_inv_code
	   ,ita_ity_sys_Flag
  FROM INV_TYPE_ATTRIBS
  WHERE EXISTS (SELECT 'there is inventory to check'
                FROM INV_ITEMS_ALL
                WHERE iit_ity_inv_code = ita_iit_inv_code
                AND iit_ity_sys_flag=ita_ity_sys_Flag)
  ORDER BY ita_iit_inv_code
          ,ita_ity_sys_Flag
          ,ita_iit_inv_code;
--

--

--
  TYPE ref_cursor IS REF CURSOR;
  ref_cur ref_cursor;

  TYPE rec_fld_length IS RECORD
     (inv_type                   INV_ITEM_TYPES.ity_inv_code%TYPE
     ,ita_sys_flag		 INV_TYPE_ATTRIBS.ita_ity_sys_Flag%TYPE
     ,ita_attrib_name            INV_TYPE_ATTRIBS.ita_attrib_name%TYPE
     ,ita_fld_length             INV_TYPE_ATTRIBS.ita_fld_length%TYPE
     ,max_length_encountered     NUMBER(38)
     );
  g_rec_fld_length rec_fld_length;


  TYPE tab_rec_fld_length IS TABLE OF rec_fld_length INDEX BY BINARY_INTEGER;
  g_tab_rec_fld_length tab_rec_fld_length;


  PROCEDURE append_rec(pi_rec_fld_length           IN rec_fld_length) IS
     v_subscript PLS_INTEGER := g_tab_rec_fld_length.COUNT + 1;
  BEGIN
    g_tab_rec_fld_length(v_subscript) := pi_rec_fld_length;
  END;


--
BEGIN


  g_proc_name := 'check_attr_length';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP

      g_sql :=    ' select      iit_ity_inv_code'||CHR(10)
	            ||'        ,'''||c1rec.ita_ity_sys_Flag||''''||CHR(10)
	            ||'        ,'''||c1rec.ita_attrib_name||''''||CHR(10)
                ||'        ,'||c1rec.ita_fld_length||CHR(10)
                ||'        ,MAX( LENGTH('||c1rec.ita_attrib_name||') )'||CHR(10)
                ||' from inv_items_all'||CHR(10)
                ||' where '||c1rec.ita_attrib_name||' is not null'||CHR(10)
	            ||' and  iit_ity_inv_code = '''||c1rec.ita_iit_inv_code||''''||CHR(10)
	            ||' and  iit_ity_sys_flag = '''||c1rec.ita_ity_sys_Flag||''''||CHR(10)
                ||' and  LENGTH('||c1rec.ita_attrib_name||') > '||c1rec.ita_fld_length||CHR(10)
                ||' group by iit_ity_inv_code'||CHR(10)
	            ||'        ,'''||c1rec.ita_ity_sys_Flag||''''||CHR(10)
	            ||'        ,'''||c1rec.ita_attrib_name||''''||CHR(10)
	            ||'        ,'||c1rec.ita_fld_length;


      OPEN ref_cur FOR g_sql;
	  FETCH ref_cur INTO g_rec_fld_length;
	  IF ref_cur%FOUND THEN
    	  CLOSE ref_cur;
          append_rec(pi_rec_fld_length               => g_rec_fld_length);
      ELSE
          CLOSE ref_cur;
      END IF;

  END LOOP;

  FOR I IN 1..g_tab_rec_fld_length.COUNT LOOP

	       g_error := 'Inventory Type ('||g_tab_rec_fld_length(I).inv_type||') Sys Flag ('||g_tab_rec_fld_length(I).ita_sys_flag||')  Attribute ('||g_tab_rec_fld_length(I).ita_attrib_name||') Permitted Length ('||g_tab_rec_fld_length(I).ita_fld_length||') Maximum Length Encountered ('||g_tab_rec_fld_length(I).max_length_encountered||')';

           ----------------------------------------------------------
           -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
           ----------------------------------------------------------
           pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                   ,pi_pmci_issue_label => 'Length Violations'
                   ,pi_pmci_details     => g_error);

  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

EXCEPTION
  WHEN OTHERS THEN

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => SQLERRM);

    update_pmc_outcome(pi_pmc_ref     => g_proc_name
                      ,pi_pmc_notes   => NULL);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_mandatory_attr IS
--
---------------------------------------------------------------------------
-- Ensure that mandatory attributes are populated
---------------------------------------------------------------------------
--
  TYPE ref_cursor IS REF CURSOR;
  ref_cur ref_cursor;
  v_dummy NUMBER;
--
BEGIN


  g_proc_name := 'check_mandatory_attr';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR csrec IN
    (

      SELECT ita_attrib_name
	        ,ita_iit_inv_code
			,ita_ity_sys_flag
        FROM INV_TYPE_ATTRIBS
       WHERE ita_manditory_yn='Y'
	   ORDER BY ita_iit_inv_code
      ) LOOP

        g_sql:='select count(*) from inv_items_all  where iit_ity_inv_code ='''||csrec.ita_iit_inv_code
               ||''' and '||csrec.ita_attrib_name||' is null and IIT_ITY_SYS_FLAG='''||csrec.ita_ity_sys_flag||'''';

        OPEN ref_cur FOR g_sql;
        FETCH ref_cur INTO v_dummy;
        CLOSE ref_cur;

        IF v_dummy >0 THEN
          g_error := 'Attribute ('||csrec.ita_attrib_name||') Inventory Type ('||csrec.ita_iit_inv_code||') Sys Flag ('||csrec.ita_ity_sys_Flag||')Count ('||v_dummy||')';

           ----------------------------------------------------------
           -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
           ----------------------------------------------------------
           pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                   ,pi_pmci_issue_label => 'Mandatory Inventory Attributes Not Set'
                   ,pi_pmci_details     => g_error);
        END IF;

  END LOOP;


  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

EXCEPTION
  WHEN OTHERS THEN

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => SQLERRM);

    update_pmc_outcome(pi_pmc_ref     => g_proc_name
                      ,pi_pmc_notes   => NULL);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_shape IS
---------------------------------------------------------------------------
-- 42.	Each road section should have only one shape
---------------------------------------------------------------------------
--
  TYPE tab_varchar80    IS TABLE OF VARCHAR2(80)    INDEX BY BINARY_INTEGER;
  TYPE tab_number       IS TABLE OF NUMBER          INDEX BY BINARY_INTEGER;
--
  l_rse_he_id tab_number;
  l_shape tab_number;
  l_rse_he_id3 NUMBER;
  l_shape3 NUMBER;
--
  CURSOR c1 IS
  SELECT gt_feature_table, gt_feature_pk_column
  FROM GIS_THEMES_ALL
  WHERE gt_route_theme = 'Y';
--
  l_feature_pk_column GIS_THEMES.gt_feature_pk_column%TYPE;
  l_feature_table GIS_THEMES.gt_feature_table%TYPE;
  l_count NUMBER := 0;

  l_layer_id INTEGER;
  l_dum NUMBER;
  l_dum2 NUMBER;
  l_dum3 NUMBER;
--
  TYPE ref_cursor IS REF CURSOR;
  ref_cur   ref_cursor;
  ref_cur2  ref_cursor;
  ref_cur3  ref_cursor;
  ref_cur3a ref_cursor;
  ref_cur4  ref_cursor;
--
  CURSOR c2( p_rse_he_id ROAD_SEGS.rse_he_id%TYPE ) IS
  SELECT COUNT(1)
  FROM ROAD_SEGS
  WHERE rse_he_id = p_rse_he_id;
--

  FUNCTION sde_layers_table_exists RETURN BOOLEAN IS

    v_dummy VARCHAR2(20) := NULL;

  BEGIN

    SELECT 'sde.layers exists'
	INTO   v_dummy
    FROM   all_objects
    WHERE  object_type = 'TABLE'
    AND    object_name = 'LAYERS'
    AND    owner = 'SDE';

	IF v_dummy IS NOT NULL THEN
	   RETURN(TRUE);
	ELSE
	   RETURN(FALSE);
	END IF;

  END;

BEGIN

  g_proc_name := 'check_shape';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  OPEN c1;
  FETCH c1 INTO l_feature_table, l_feature_pk_column;
  IF c1%NOTFOUND
    THEN
      CLOSE c1;
      g_error := 'No GIS feature table in GIS_THEMES table';

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => NULL
                ,pi_pmci_details     => g_error);

  ELSE
    CLOSE c1;
    OPEN ref_cur FOR 'select unique '||l_feature_pk_column||' from '||l_feature_table;
    FETCH ref_cur BULK COLLECT INTO l_rse_he_id;
    CLOSE ref_cur;
  END IF;

  FOR I IN 1..l_rse_he_id.COUNT LOOP
    OPEN ref_cur2 FOR 'select count(1) from '||l_feature_table||' where '||l_feature_pk_column||' = '||l_rse_he_id(I);
    FETCH ref_cur2 INTO l_dum;
    CLOSE ref_cur2;

    IF l_dum > 1
      THEN

        g_error := 'Duplicate '||l_feature_pk_column||' entries of('||l_rse_he_id(I)||') in '||l_feature_table;

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => NULL
                ,pi_pmci_details     => g_error);
    ELSE
  ---------------------------------------------------------------------------
  -- 43. Stranded shapes should not exist - they should all relate to road
  --	 sections
  ---------------------------------------------------------------------------
      OPEN c2( l_rse_he_id(I) );
      FETCH c2 INTO l_dum2;
      IF l_dum2 < 1
        THEN
          CLOSE c2;
          g_error := 'Feature table '||l_feature_table||' has entry for non existent road section '||l_rse_he_id(I);

          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);
      ELSE
        CLOSE c2;
      END IF;
    END IF;
    --
    ---------------------------------------------------------------------------
    -- 44.	No null shapes
    ---------------------------------------------------------------------------

	IF sde_layers_table_exists THEN

       OPEN ref_cur3 FOR 'select '||l_feature_pk_column||', shape from '||l_feature_table||' where '||l_feature_pk_column||' = '||l_rse_he_id(I);
       FETCH ref_cur3 INTO l_rse_he_id3, l_shape3;
       CLOSE ref_cur3;
    --
       OPEN ref_cur3a FOR 'select layer_id from sde.layers where table_name = '''||l_feature_table||'''';
       FETCH ref_cur3a INTO l_layer_id;

       IF ref_cur3a%NOTFOUND
         THEN
           CLOSE ref_cur3a;
       ELSE
         CLOSE ref_cur3a;

            OPEN ref_cur4 FOR 'select count(*) from F'||l_layer_id||' where FID = '||l_shape3
                         ||' and EMINX is null and EMINY is null and EMAXX is null and EMAXY is null and EMINZ is null'
                         ||' and EMAXZ is null and MIN_MEASURE = 0';
         FETCH ref_cur4 INTO l_dum3;
         CLOSE ref_cur4;

         IF l_dum3 >= 0
           THEN
             NULL;
         ELSE
           g_error := '('||l_count||') Null shape('||l_shape3||'), rse_he_id('||l_rse_he_id3||')';

           pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                   ,pi_pmci_issue_label => NULL
                  ,pi_pmci_details     => g_error);
         END IF;

      END IF;
   END IF;

  END LOOP;

  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL
                    ,pi_note_over_fail => TRUE);

EXCEPTION
  WHEN OTHERS THEN

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => NULL
            ,pi_pmci_details     => SQLERRM);

    update_pmc_outcome(pi_pmc_ref     => g_proc_name
                      ,pi_pmc_notes   => NULL
                      ,pi_note_over_fail => TRUE);
END;
---------------------------------------------------------------------------
-- 45.	Shape data should have a single PK on rse_he_id
---------------------------------------------------------------------------

---------------------------------------------------------------------------
-- 46. 	Hig_codes needs an update script to add a timestamp to any start
-- 	data entered through the form - there is a check constraint on nm3
--	hig_codes that will fail if there is no timestamp - the form will
--	(Status Codes) need a fix also.
---------------------------------------------------------------------------

--
-----------------------------------------------------------------------------
--
PROCEDURE admin_unit_hierarchy IS
--
---------------------------------------------------------------------------
--
l_number NUMBER;

BEGIN

  g_proc_name := 'admin_unit_hierarchy';

  set_pmc_start(pi_pmc_ref => g_proc_name);


  --------------------------------------------------
  -- Check that there is only 1 top level admin unit
  --------------------------------------------------
  SELECT  COUNT(*)
  INTO    l_number
  FROM    HIG_ADMIN_UNITS
  WHERE   hau_level=1;

  IF l_number!=1 THEN
    g_error := 'There must be 1 and only 1 Top Level Admin Unit - detected '||l_number;

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Incorrect Number of Top Level Admin Units'
                ,pi_pmci_details     => g_error);

  END IF;

  -----------------------------------------------------------------------------
  -- See if there are any 'hidden' admin units that cannot be seen by top level
  -----------------------------------------------------------------------------
  FOR csrec IN
          (SELECT
                 hau_unit_Code,
                 hau_name,
                 hau_level
           FROM
                 HIG_ADMIN_UNITS hau
           WHERE
           NOT EXISTS (
		               SELECT 'admin unit can be seen by top level admin unit'
                       FROM  HIG_ADMIN_GROUPS
                            ,HIG_ADMIN_UNITS hau2
                       WHERE hag_parent_admin_unit = hau2.hau_Admin_unit
                       AND   hau2.hau_level=1
                       AND   hag_child_admin_unit  = hau.hau_admin_unit)
					   )
					     LOOP

                         g_error := 'Admin Unit Code ('||csrec.hau_unit_code||')  - Admin Unit Name ('||csrec.hau_name||') Level - ('||csrec.hau_level||')';

                      ----------------------------------------------------------
                      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
                      ----------------------------------------------------------
                      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                              ,pi_pmci_issue_label => 'Admin Unit(s) Cannot Be Seen By Top Level Admin Unit'
                              ,pi_pmci_details     => g_error);

  END LOOP;


  --------------------------------------------------------------------
  -- See if there are any admin units that do not have a direct parent
  --------------------------------------------------------------------
  FOR csrec IN
          (SELECT hau_unit_Code
                 ,hau_name,hau_level
           FROM   HIG_ADMIN_UNITS CHILD
           WHERE NOT EXISTS
               (SELECT 'we have a direct parent admin unit'
                FROM   HIG_ADMIN_GROUPS hag
                      ,HIG_ADMIN_UNITS  PARENT
                WHERE  hag_parent_admin_unit = PARENT.hau_admin_unit
                AND    hag_child_admin_unit  = CHILD.hau_admin_unit
                AND    hag_direct_link='Y'
                AND    PARENT.hau_level        = CHILD.hau_level-1)
           AND CHILD.hau_level != 1)
  	       LOOP

           g_error := 'Admin Unit Code ('||csrec.hau_unit_code||')  - Admin Unit Name ('||csrec.hau_name||') Level - ('||csrec.hau_level||')';

                      ----------------------------------------------------------
                      -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
                      ----------------------------------------------------------
                      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                              ,pi_pmci_issue_label => 'Admin Unit(s) That Do Not Have A Parent Admin Unit'
                              ,pi_pmci_details     => g_error);

  END LOOP;


  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END admin_unit_hierarchy;
--
--
-----------------------------------------------------------------------------
--
/*PROCEDURE admin_unit_relationships IS

l_number NUMBER;
l_hau_top NUMBER;

BEGIN

  g_proc_name := 'admin_unit_relationships';

  set_pmc_start(pi_pmc_ref => g_proc_name);

  --------------------------------------------------------------------
  -- See if there are any admin units that do not have a direct parent
  --------------------------------------------------------------------
  FOR csrec IN
    (SELECT rse_in.rse_unique in_unique ,rse_in.rse_admin_unit in_au
    ,rse_of.rse_unique of_unique , rse_of.rse_admin_unit of_au
    FROM ROAD_SEG_MEMBS_ALL
    ,ROAD_SEGS rse_in
    ,ROAD_SEGS rse_of
    ,HIG_ADMIN_UNITS hau_in
    ,HIG_ADMIN_UNITS hau_of
    WHERE rsm_rse_he_id_in=rse_in.rse_he_id
    AND rsm_rse_he_id_of=rse_of.rse_he_id
    AND rse_in.rse_admin_unit=hau_in.hau_admin_unit
    AND rse_of.rse_admin_unit=hau_of.hau_admin_unit
    AND NOT EXISTS
    (SELECT 'x' FROM HIG_ADMIN_GROUPS
    WHERE hag_parent_admin_unit=hau_in.hau_admin_unit
    AND hag_child_admin_unit=hau_of.hau_admin_unit))
  	       LOOP

             g_error := 'Parent ('||csrec.in_unique||') Admin Unit ('||csrec.in_au||') - Child ('||csrec.of_unique||') Admin Unit ('||csrec.of_au||')';

             pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                     ,pi_pmci_issue_label => 'Parent Child relationships that violate Admin Unit Security'
                     ,pi_pmci_details     => g_error);

  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END admin_unit_relationships;
*/
--

-----------------------------------
--
PROCEDURE check_xsp_sys_flag IS
--
---------------------------------------------------------------------------
-- 48.	Ensure xsp_restraints sys_flag is either L or D, because these are
--	the only network types we create during migration.
---------------------------------------------------------------------------
  CURSOR c1 IS
  SELECT xsr_ity_sys_flag, COUNT(*) num
  FROM XSP_RESTRAINTS
  WHERE xsr_ity_sys_flag NOT IN ('L','D')
  AND    xsr_ity_inv_code != '$$'
  GROUP BY xsr_ity_sys_flag;
--
  CURSOR no_section_class IS
  SELECT xsr_scl_class
        ,xsr_ity_sys_flag
   FROM  XSP_RESTRAINTS
   WHERE NOT EXISTS (SELECT 1
                     FROM   SECTION_CLASSES
                     WHERE  1=1
--see fix for section classes above
--					 and DECODE(scl_road_cat, 'T', 'D', 'L') = xsr_ity_sys_flag
                     AND    scl_sect_class = xsr_scl_class)
   AND    xsr_ity_inv_code != '$$'
   GROUP BY xsr_scl_class
           ,xsr_ity_sys_flag;
--
  CURSOR no_xsp_restraint IS
  SELECT iit_ity_sys_flag
       , iit_x_sect
       , rse_scl_sect_class
       , iit_ity_inv_code
       , COUNT(*) COUNT
  FROM   INV_ITEMS_ALL
        ,ROAD_SEGS
  WHERE  rse_he_id  = iit_rse_he_id
  AND    iit_x_sect IS NOT NULL
  AND NOT EXISTS (SELECT 1
                  FROM   XSP_RESTRAINTS
                  WHERE  xsr_ity_inv_code = iit_ity_inv_code
                  AND    xsr_scl_class    = rse_scl_sect_class
                  AND    xsr_x_sect_value = iit_x_sect
                  AND    xsr_ity_sys_flag = iit_ity_sys_flag
                  AND    xsr_ity_inv_code != '$$')
  GROUP BY iit_ity_sys_flag, iit_ity_inv_code, rse_scl_sect_class, iit_x_sect;

BEGIN

  g_proc_name := 'check_xsp_sys_flag';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN c1 LOOP

    g_error := 'There are '||irec.num||' records with a sys flag of '||irec.xsr_ity_sys_flag;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'sys flag is not D or L'
            ,pi_pmci_details     => g_error);

  END LOOP;

  FOR irec IN no_section_class LOOP

    g_error := 'Section class '||irec.xsr_scl_class ||' on sys flag of '||irec.xsr_ity_sys_flag||' is missing';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Incorrect xsp values or missing section class.'
            ,pi_pmci_details     => g_error);

  END LOOP;

  FOR irec IN no_xsp_restraint LOOP

    g_error := 'XSP '||irec.iit_x_sect||' is used by inventory type '||irec.iit_ity_inv_code||', System Flag '||irec.iit_ity_sys_flag||' on a section class of '||irec.rse_scl_sect_class||'. '||irec.COUNT||' offending items';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Invalid inventory xsp values. This could be due to the section class not being defined for the road section or the xsp not being defined for the inventory item'
            ,pi_pmci_details     => g_error);

  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);


END;
--
-----------------------------------------------------------------------------
--
PROCEDURE contact_addresses IS

CURSOR get_addresses IS
SELECT hca_hct_id
      ,hca_had_id
FROM   HIG_CONTACT_ADDRESS
WHERE NOT EXISTS (SELECT 1
                  FROM HIG_ADDRESS
                  WHERE hca_had_id = had_id);

BEGIN
  g_proc_name := 'contact_addresses';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN get_addresses LOOP
    g_error := 'Contact '||irec.hca_hct_id||' is missing address '||irec.hca_had_id;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Contacts with missing addresses'
            ,pi_pmci_details     => g_error);
  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);
END contact_addresses;
--
-----------------------------------------------------------------------------
--
PROCEDURE missing_docs IS

CURSOR get_das IS
SELECT d.das_doc_id, das_rec_id, das_table_name
FROM   DOC_ASSOCS d
WHERE NOT EXISTS (SELECT 1
                  FROM   DOCS
                  WHERE  doc_id = das_doc_id)
ORDER BY das_table_name, das_rec_id;

TYPE ref_cursor IS REF CURSOR;
ref_cur ref_cursor;

l_count NUMBER;
l_sql VARCHAR2(1000);

l_table_name DOC_GATEWAYS.DGT_TABLE_NAME%TYPE;
l_col_name DOC_GATEWAYS.DGT_PK_COL_NAME%TYPE;

l_das_doc_id DOC_ASSOCS.Das_doc_ID%TYPE;
l_das_REc_id DOC_ASSOCS.DAS_REC_ID%TYPE;
l_das_table_name DOC_ASSOCS.DAS_table_name%TYPE;

BEGIN
  g_proc_name := 'missing_docs';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN get_das LOOP
    g_error := irec.das_table_name||' '||irec.das_rec_id||' linked to document '||irec.das_doc_id;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Missing documents'
            ,pi_pmci_details     => g_error);
  END LOOP;


  FOR irec IN
  (SELECT DISTINCT das_table_name FROM DOC_ASSOCS) LOOP
--
    BEGIN
	  SELECT dgt_table_name,dgt_pk_col_name  --,das_doc_id,das_rec_id
      INTO l_table_name, l_col_name
      FROM
      DOC_GATEWAYS dgt  --,DOC_ASSOCS
      WHERE
      (dgt_table_name = UPPER(irec.das_table_name));
	EXCEPTION WHEN NO_DATA_FOUND THEN --look in synonyms
      BEGIN
	    SELECT dgt_table_name,dgt_pk_col_name  --,das_doc_id,das_rec_id
        INTO l_table_name, l_col_name
        FROM
        DOC_GATEWAYS dgt  --,DOC_ASSOCS
        WHERE EXISTS      ( SELECT 'document gateway synonym'
                         FROM   DOC_GATE_SYNS dgs
                         WHERE  dgs.dgs_table_syn      = UPPER(irec.das_table_name)
                         AND    dgs.dgs_dgt_table_name = dgt.dgt_table_name );
	  EXCEPTION WHEN NO_DATA_FOUND THEN
	    NULL;
	  END;
	END;
--
    l_sql:='SELECT DAS_DOC_ID, DAS_REC_ID, DAS_TABLE_NAME FROM DOC_ASSOCS '||
           ' WHERE das_table_name='''||l_table_name||''''||
           ' AND NOT EXISTS'||
           ' (SELECT ''x'' FROM '||l_table_name||
           ' WHERE '||l_Col_name||'=das_rec_id)';


     OPEN ref_cur FOR l_sql;
     LOOP

      FETCH ref_cur INTO l_das_doc_id,l_das_rec_id,l_das_table_name;
      EXIT WHEN ref_cur%NOTFOUND;

      IF l_das_doc_id IS NOT NULL THEN

      g_error := l_das_table_name||' '||l_das_rec_id||' linked to document '||l_das_doc_id;

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Missing Associated Item'
            ,pi_pmci_details     => g_error);

      END IF;
    END LOOP;
    CLOSE ref_cur;

  END LOOP;
/*
  FOR irec IN missing_assoc LOOP  -- these are all the assocs, need to check they exist
    l_sql:='select count(*) from '||irec.dgt_table_name||' where '||irec.dgt_pk_col_name||'='''||irec.das_rec_id||'''';
	EXECUTE IMMEDIATE l_sql INTO l_count;
	IF l_count=0 THEN
      g_error := irec.dgt_table_name||' '||irec.das_rec_id||' linked to document '||irec.das_doc_id;

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Missing Associated Item'
            ,pi_pmci_details     => g_error);


    END IF;
  END LOOP;
 */

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);
END missing_docs;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_users IS

CURSOR get_invalid_users IS
SELECT hus_username
FROM   HIG_USERS
WHERE  INSTR(TRANSLATE(hus_username, ' &|:,-=>[<(.+])!/*^@', '&'), '&') > 0
OR ASCII(SUBSTR(hus_username, 1, 1)) BETWEEN 48 AND 57
OR EXISTS (SELECT 1
           FROM   v$reserved_words
           WHERE  keyword = hus_username);

-- this cursor is not linked to v$reserved_words
-- as roles can be named by some of the reserved words, and also there is no check
-- in nm3 against reserved words as there is for users
CURSOR get_invalid_roles IS
SELECT hro_role
FROM   HIG_ROLES
WHERE  INSTR(TRANSLATE(hro_role, ' &|:,-=>[<(.+])!/*^@', '&'), '&') > 0
OR ASCII(SUBSTR(hro_role, 1, 1)) BETWEEN 48 AND 57;

BEGIN
  g_proc_name := 'check_users';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN get_invalid_users LOOP
    g_error := irec.hus_username||' is not a valid Oracle username ';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Invalid Users'
            ,pi_pmci_details     => g_error);
  END LOOP;

  FOR irec IN get_invalid_roles LOOP
    g_error := irec.hro_role||' is not a valid role ';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Invalid Roles'
            ,pi_pmci_details     => g_error);

  END LOOP;
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);
END check_users;
--
-----------------------------------------------------------------------------
--
PROCEDURE future_items IS

  CURSOR future_inv IS
  SELECT iit_item_id
        ,iit_ity_inv_code
        ,iit_cre_date
  FROM   INV_ITEMS_ALL
  WHERE  iit_cre_date > SYSDATE
  ORDER BY 2,3;

  CURSOR future_roads IS
  SELECT rse_unique
        ,rse_start_date
  FROM   ROAD_SEGS
  WHERE  rse_start_date > SYSDATE
  ORDER BY 2,1;

BEGIN
  g_proc_name := 'future_items';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN future_inv LOOP
    g_error := 'Inventory item ('||irec.iit_item_id||') of type '||irec.iit_ity_inv_code||' starts on '||TO_CHAR(irec.iit_cre_date, 'DD-MON-YYYY');

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Future Inventory'
            ,pi_pmci_details     => g_error);

  END LOOP;

  FOR irec IN future_roads LOOP
    g_error := 'Road '||irec.rse_unique||' starts on '||TO_CHAR(irec.rse_start_date, 'DD-MON-YYYY');

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Future Roads'
            ,pi_pmci_details     => g_error);

  END LOOP;
  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL
                    ,pi_note_over_fail => TRUE);
END future_items;
--
-----------------------------------------------------------------------------
--
PROCEDURE disabled_constraints IS

CURSOR get_dis_cons IS
SELECT u.table_name
      ,u.constraint_name
      ,DECODE(u.constraint_type, 'P', 'Primary key', 'R', 'Foreign key', 'C', 'Check', 'U', 'Unique Key') constraint_type
FROM   user_constraints u
WHERE  u.status = 'DISABLED'
AND    u.table_name NOT LIKE 'SWR%' -- ignore SWR tables they are intentionally disabled
AND    u.table_name NOT IN ('BATCH_CSV_FILES'
                           ,'BATCH_FILE_ERRORS'
                           ,'BATCH_LOAD_ERRORS'
                           ,'CSV_FILE_ERRORS'
                           ,'CSV_LOAD_ERRORS')
AND u.constraint_name NOT IN ('GDOBJ_PK'
                             ,'PUS_PK'
                             ,'RPA_PK'
                             ,'GDO_FK_GR'
                             ,'GR_FK_GTF'
                             ,'GTF_FK_GT'
                             ,'GRP_FK_GRR'
                             ,'GSS_FK_GRM'
                             ,'HER_FK_HPR'
                             ,'NUS_FK_STREET'
                             ,'NOU_FK_PUS'
                             ,'RSE_FK_POI2'
                             ,'RSE_FK_POI1'
                             ,'STR_FK_STR_PARENT'
                             ,'STE_FK_STE'
                             ,'ATJ_PK'
                             ,'ATR_PK'
                             ,'AFGP_FK_AFGH')
AND EXISTS (SELECT 1
            FROM   PRE_MIGRATION_CHECK_OBJS p
            WHERE  object_type = 'C'
            AND    p.object_name = u.constraint_name);

BEGIN
  g_proc_name := 'disabled_constraints';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN get_dis_cons LOOP
    g_error := irec.constraint_type||' constraint ('||irec.constraint_name||') on table '||irec.table_name||' is disabled';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Disabled Constraint'
            ,pi_pmci_details     => g_error);
  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);
END disabled_constraints;
--
-----------------------------------------------------------------------------
--
PROCEDURE exor_objects IS

CURSOR get_missing_objs IS
SELECT DECODE(p.object_type, 'T', 'Table'
                           , 'I', 'Index'
                           , 'G', 'Trigger'
                           , 'S', 'Sequence'
                           , 'V', 'View'
                           , 'P', 'Package'
                           , 'R', 'Procedure'
                           , 'F', 'Function') object_type
      ,object_name
FROM PRE_MIGRATION_CHECK_OBJS p
WHERE p.product IN (SELECT hpr_product
                    FROM HIG_PRODUCTS
                    WHERE hpr_key IS NOT NULL)
AND p.object_type NOT IN ('C' -- constraints are not in user objects
				  	      ,'I','G','V','P','R','F') --these get recreated
AND NOT EXISTS (SELECT 1
                FROM user_objects u
                WHERE u.object_name = p.object_name
                AND   u.object_type = DECODE(p.object_type, 'T', 'TABLE'
                                                          , 'I', 'INDEX'
                                                          , 'G', 'TRIGGER'
                                                          , 'S', 'SEQUENCE'
                                                          , 'V', 'VIEW'
                                                          , 'P', 'PACKAGE'
                                                          , 'R', 'PROCEDURE'
                                                          , 'F', 'FUNCTION'))
UNION
SELECT 'Constraint', object_name
FROM PRE_MIGRATION_CHECK_OBJS p
WHERE p.object_type = 'C'
AND   p.product IN (SELECT hpr_product
                    FROM HIG_PRODUCTS
                    WHERE hpr_key IS NOT NULL)
AND NOT EXISTS (SELECT 1
                FROM user_constraints u
                WHERE u.constraint_name = p.object_name
                AND NOT (u.constraint_type = 'C'
                         AND u.constraint_name LIKE 'SYS%'));


BEGIN
  g_proc_name := 'exor_objects';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN get_missing_objs LOOP
    g_error := irec.object_name||' ('||irec.object_type||') is missing.';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Missing Highways objects'
            ,pi_pmci_details     => g_error);

  END LOOP;

  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);
END exor_objects;
--
-----------------------------------------------------------------------------
--
PROCEDURE Extra_objects IS

CURSOR extra_objs IS
SELECT u.object_name
      ,u.object_type
FROM  user_objects u
WHERE u.object_type NOT IN ('PACKAGE BODY', 'SYNONYM') -- we check for packages so no need to include bodies
AND NOT (u.object_type = 'TABLE' AND u.object_name IN ('PRE_MIGRATION_CHECK_OBJS'
                                                     ,'PRE_MIGRATION_CHK'
                                                     ,'PRE_MIGRATION_CHK_CLASSES'
                                                     ,'PRE_MIGRATION_CHK_ISSUES'))
AND NOT (u.object_type = 'INDEX' AND u.object_name IN ('PK_PRE_MIGRATION_CHK_CLASSES'
                                                      ,'PMCI_IND1'
                                                      ,'PMC_PK'
                                                      ,'PMC_UK1'))
AND NOT EXISTS (SELECT 1
                FROM   PRE_MIGRATION_CHECK_OBJS p
                WHERE  p.object_name = u.object_name
                AND    (p.product IN (SELECT hpr_product
                                     FROM HIG_PRODUCTS
                                     WHERE hpr_key IS NOT NULL)
                        OR (p.product = 'MAI'
                            AND u.object_type IN ('TABLE', 'VIEW'))-- mai tables and views are installed with COR
                        OR ((p.product, u.object_type) = (SELECT 'UKP', 'VIEW'
                                                          FROM   HIG_PRODUCTS
                                                          WHERE  hpr_key IS NOT NULL
                                                          AND    hpr_product = 'MAI'))) -- ukp views are installed with MAI
                AND    u.object_type = DECODE(p.object_type, 'T', 'TABLE'
                                                           , 'I', 'INDEX'
                                                           , 'G', 'TRIGGER'
                                                           , 'S', 'SEQUENCE'
                                                           , 'V', 'VIEW'
                                                           , 'P', 'PACKAGE'
                                                           , 'R', 'PROCEDURE'
                                                           , 'F', 'FUNCTION'))
AND NOT (u.object_type = 'VIEW' AND u.object_name IN (SELECT ity_view_name FROM INV_ITEM_TYPES))
UNION
SELECT constraint_name, 'CONSTRAINT'
FROM user_constraints u
WHERE NOT (constraint_type = 'C'
           AND constraint_name LIKE 'SYS%')
AND NOT (constraint_name IN ('PK_PRE_MIGRATION_CHK_CLASSES'
                            ,'PMC_PK'))
AND  NOT EXISTS (SELECT 1
                 FROM   PRE_MIGRATION_CHECK_OBJS p
                 WHERE  p.object_name = u.constraint_name
                 AND    p.product IN (SELECT hpr_product
                                      FROM HIG_PRODUCTS
                                      WHERE hpr_key IS NOT NULL)
                 AND    p.object_type = 'C');

BEGIN
  g_proc_name := 'extra_objects';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN extra_objs LOOP
    g_error := irec.object_name ||' ('||irec.object_type||')';

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Extra items over standard Exor 2220 release. These items will not be migrated.'
            ,pi_pmci_details     => g_error);
  END LOOP;

  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL
                    ,pi_note_over_fail => TRUE);
END extra_objects;
--
-----------------------------------------------------------------------------
-- Some road section attributes are constrained based on domain values
-- Ensure that there are no spurious values in road_segs

PROCEDURE section_domain_validity IS

CURSOR get_vals IS
SELECT rse_status       extra_value
      ,rse_unique        road
      ,'SECTION_STATUS' domain
FROM   ROAD_SEGS
WHERE  rse_status NOT IN (SELECT hco_code
                          FROM   HIG_CODES
                          WHERE  hco_domain = ('SECTION_STATUS'))
AND rse_type = 'S'
UNION
SELECT rse_adoption_status
      ,rse_unique
      ,'ADOPTION_STATUS'
FROM   ROAD_SEGS
WHERE  rse_adoption_status NOT IN (SELECT hco_code
                                   FROM   HIG_CODES
                                   WHERE  hco_domain = ('ADOPTION_STATUS'))
AND rse_type = 'S'
UNION
SELECT rse_carriageway_type
      ,rse_unique
      ,'ROAD_CARRIAGEWAY'
FROM   ROAD_SEGS
WHERE  rse_carriageway_type NOT IN (SELECT hco_code
                                    FROM   HIG_CODES
                                    WHERE  hco_domain = ('ROAD_CARRIAGEWAY'))
AND rse_type = 'S'
UNION
SELECT rse_road_environment
      ,rse_unique
      ,'ROAD_ENVIRONMENT'
FROM   ROAD_SEGS
WHERE  rse_road_environment NOT IN (SELECT hco_code
                                    FROM   HIG_CODES
                                    WHERE  hco_domain = ('ROAD_ENVIRONMENT'))
AND rse_type = 'S'
UNION
SELECT rse_maint_category
      ,rse_unique
      ,'MAINTENANCE_CATEGORY'
FROM   ROAD_SEGS
WHERE  rse_maint_category NOT IN (SELECT hco_code
                                  FROM   HIG_CODES
                                  WHERE  hco_domain = ('MAINTENANCE_CATEGORY'))
AND rse_type = 'S'
UNION
SELECT rse_footway_category
      ,rse_unique
      ,'FOOTWAY_CATEGORY'
FROM   ROAD_SEGS
WHERE  rse_footway_category NOT IN (SELECT hco_code
                                    FROM   HIG_CODES
                                    WHERE  hco_domain = ('FOOTWAY_CATEGORY'))
AND rse_type = 'S'
UNION
SELECT rse_network_direction
      ,rse_unique
      ,'NETWORK_DIRECTION'
FROM   ROAD_SEGS
WHERE  rse_network_direction NOT IN (SELECT hco_code
                                     FROM   HIG_CODES
                                     WHERE  hco_domain = ('NETWORK_DIRECTION'))
AND rse_type = 'S'
UNION
SELECT rse_road_type
      ,rse_unique
      ,'ROAD_TYPE'
FROM   ROAD_SEGS
WHERE  rse_road_type NOT IN (SELECT hco_code
                             FROM   HIG_CODES
                             WHERE  hco_domain = ('ROAD_TYPE'))
AND rse_type = 'S'
ORDER BY 3;

BEGIN
  g_proc_name := 'section_domain_validity';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR irec IN get_vals LOOP
    g_error := 'Road '||irec.road||' has invalid value of '||irec.extra_value||' for the '||irec.domain;

    pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Section values not in the corresponding domain. These values should be reviewed and modified or added to the domain'
            ,pi_pmci_details     => g_error);
  END LOOP;

  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL);

END section_domain_validity;
--
-----------------------------------------------------------------------------
--

PROCEDURE section_mandatory_values IS

CURSOR c1 IS
SELECT 'RSE_ROAD_TYPE' bad_item,COUNT(*) bad_count
FROM ROAD_SEGS
WHERE rse_road_type IS NULL
AND rse_type='S'
UNION ALL
SELECT 'RSE_STATUS',COUNT(*) 
FROM ROAD_SEGS
WHERE rse_status IS NULL
AND rse_type='S'
UNION ALL
SELECT 'RSE_CARRIAGEWAY_TYPE',COUNT(*) 
FROM ROAD_SEGS
WHERE rse_carriageway_type IS NULL
AND rse_type='S'
UNION ALL
SELECT 'RSE_ROAD_ENVIRONMENT',COUNT(*) 
FROM ROAD_SEGS
WHERE rse_road_environment IS NULL
AND rse_type='S'
UNION ALL
SELECT 'RSE_MAINT_CATEGORY',COUNT(*) 
FROM ROAD_SEGS
WHERE rse_maint_category IS NULL
AND rse_type='S'
UNION ALL
SELECT 'RSE_NUMBER_OF_LANES',COUNT(*) 
FROM ROAD_SEGS
WHERE rse_number_of_lanes IS NULL
AND rse_type='S'
UNION ALL
SELECT 'RSE_ROAD_CATEGORY',COUNT(*) 
FROM ROAD_SEGS
WHERE rse_road_category IS NULL
AND rse_type='S';



BEGIN
  g_proc_name := 'section_mandatory_values';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    IF c1rec.bad_count>0 THEN
      g_error := 'Found '||c1rec.bad_count||' Sections with null '||c1rec.bad_item;

      pmci_ins(pi_pmci_pmc_ref     => g_proc_name
            ,pi_pmci_issue_label => 'Null Section attribute values.'
            ,pi_pmci_details     => g_error);
    END IF;
  END LOOP;

  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL);

END section_mandatory_values;





--
-----------------------------------------------------------------------------
--

PROCEDURE open_file(pi_filename      VARCHAR2
                  , pi_location      VARCHAR2) IS
v_filename VARCHAR2(200);
BEGIN
  IF pi_filename IS NULL
    OR pi_location IS NULL
    THEN
      RAISE UTL_FILE.INVALID_PATH;
  END IF;

  IF INSTR(pi_filename,'.') >0 THEN
    v_filename := SUBSTR(pi_filename,1,INSTR(pi_filename,'.')-1);
  ELSE
    v_filename := pi_filename;
  END IF;
  v_filename := v_filename||'_'||TO_CHAR(SYSDATE,'DDMONYYYY_HH24MISS')||'.html';

  ---------------------------------------
  --  Open file for Writing
  ---------------------------------------
  g_report := UTL_FILE.FOPEN( pi_location, v_filename, c_write_mode );
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
END open_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE  write_to_file(pi_all_lines     tab_varchar32767) IS
--

l_count PLS_INTEGER;

--
BEGIN

 --------------------------------------------------
 -- loop through all lines and append into the file
 --------------------------------------------------
 FOR I IN 1..pi_all_lines.COUNT LOOP
        UTL_FILE.PUT_LINE(g_report, pi_all_lines(I));
 END LOOP;

 --
 UTL_FILE.FCLOSE(g_report);
--
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
END;
--
---------------------------------------------------------------------------
--
PROCEDURE append_file_content(pi_text  IN VARCHAR) IS

  v_subscript PLS_INTEGER;

BEGIN

   v_subscript := g_file_content.COUNT + 1;

   g_file_content(v_subscript) := pi_text;

END append_file_content;
--
---------------------------------------------------------------------------
--
PROCEDURE build_html(pi_max_check_issues IN NUMBER) IS


 v_max_issues_to_list PLS_INTEGER;

BEGIN

 g_file_content.DELETE;

 append_file_content('<HTML>');
 append_file_content(' <style>');
 append_file_content('.title {font-family: Arial, Helvetica, sans-serif; font-SIZE: 10pt;	color: 000000; font : bold; }');
 append_file_content('.big_title {font-family: Arial, Helvetica, sans-serif; font-SIZE: 10pt;	color: white; font : bold; }');
 append_file_content('.table_val {font-family: Arial, Helvetica, sans-serif;	font-SIZE: 9pt; color: black; font : normal; }');
 append_file_content('.table_val_highlighted {font-family: Arial, Helvetica, sans-serif;	font-SIZE: 9pt; color: red; font : normal; }');
 append_file_content(' </style>');
 append_file_content('<HEAD>');
 append_file_content('<TITLE> Highways By Exor Pre-Migration Checks </TITLE>');
 append_file_content('</HEAD>');
 append_file_content('<BODY>');

-------------------
-- PRE-MIGRATION VERSION
-------------------
 append_file_content('<TABLE border="0" cellpadding="2" cellspacing="1">');

 append_file_content('<tr bgcolor="006666">');
 append_file_content('   <td align="CENTER" colspan="2" CLASS="big_title"><b>   Exor pre-migration checker   <b></td>');
 append_file_content('</tr>');

 append_file_content('<tr bgcolor="#ffe1aa">');
 append_file_content('   <td align="CENTER" colspan="2" CLASS="table_val"> Version '||g_body_sccsid||'</td>');
 append_file_content('</tr>');

-------------------
-- INSTANCE DETAILS
-------------------

 append_file_content('<tr bgcolor="006666">');
 append_file_content('   <td align="CENTER" colspan="2" CLASS="big_title"><b> Checks Executed Against </b></td>');
 append_file_content('</tr>');

 append_file_content('<tr bgcolor="#ffe1aa">');
 append_file_content('   <td align="CENTER" colspan="2" CLASS="table_val">'||g_instance_details||'</td>');
 append_file_content('</tr>');


----------
-- SYSDATE
----------
 append_file_content('<tr bgcolor="006666">');
 append_file_content('   <td align="CENTER" colspan="2" CLASS="big_title"><b> Checks Executed On </b></td>');
 append_file_content('</tr>');

 append_file_content('<tr bgcolor="#ffe1aa">');
 append_file_content('   <td align="CENTER" colspan="2" CLASS="table_val">'||TO_CHAR(SYSDATE,'DAY DD MONTH YYYY HH24:MI')||'</td>');
 append_file_content('</tr>');


----------------------
-- HIG PRODUCT DETAILS
----------------------
 append_file_content('<tr bgcolor="006666">');
 append_file_content('   <td align="CENTER" colspan="2" CLASS="big_title"><b> Licenced Highways Products </b></td>');
 append_file_content('</tr>');
 append_file_content('<tr bgcolor="#FF9900">');
 append_file_content('   <td align="CENTER" colspan="1" CLASS="title"><b> Product Code </b></td>');
 append_file_content('   <td align="CENTER" colspan="1" CLASS="title"><b> Version </b></td>');
 append_file_content('</tr>');

 FOR I IN 1..g_tab_hpr_product.COUNT LOOP
    append_file_content('<tr bgcolor="#ffe1aa">');
    append_file_content('   <td align="CENTER" CLASS="table_val">'||g_tab_hpr_product(I)||'</td>');
    append_file_content('   <td align="CENTER" CLASS="table_val">'||g_tab_hpr_version(I)||'</td>');
    append_file_content('</tr>');
 END LOOP;
 append_file_content('</TABLE>');
 append_file_content('<BR> </BR>');

 ----------------
 -- All CHECK DETAILS
 ----------------
 OPEN c_chks(NULL);
 FETCH c_chks BULK COLLECT INTO  g_tab_pmc_ref
                                ,g_tab_pmc_description
                                ,g_tab_pmc_label
                                ,g_tab_pmc_outcome
                                ,g_tab_pmc_notes
                                ,g_tab_pmc_execution_time
                                ,g_tab_pmc_count_issues;
 CLOSE c_chks;

 ----------------
 -- Check Summary
 ----------------
 append_file_content('<TABLE border="0" cellpadding="2" cellspacing="1">');
 append_file_content('<tr bgcolor="006666">');
 append_file_content('   <td align="CENTER" width="640" colspan="4" CLASS="big_title"><b> Check Summary </b></td>');
 append_file_content('</tr>');

 append_file_content('<tr bgcolor="#FF9900">');
 append_file_content('   <td colspan="1" CLASS="title"><b> Check Description </b></td>');
 append_file_content('   <td colspan="1" CLASS="title"><b> Outcome </b></td>');
 append_file_content('   <td colspan="1" CLASS="title"><b> Execution Time (seconds) </b></td>');
 append_file_content('   <td colspan="1" CLASS="title"><b> Issue Count </b></td>');
 append_file_content('</tr>');

   FOR I IN 1..g_tab_pmc_ref.COUNT LOOP

    -- check description  and outcome column headings
    append_file_content('<tr bgcolor="#ffe1aa">');

    append_file_content('   <td CLASS="table_val"> <a href="#'||g_tab_pmc_label(I)||'">'||g_tab_pmc_label(I)||'</a> </td>');
    IF g_tab_pmc_outcome(I) = g_pass THEN
      append_file_content('   <td CLASS="table_val">'||g_tab_pmc_outcome(I)||'</td>');
    ELSE
      append_file_content('   <td CLASS="table_val_highlighted">'||g_tab_pmc_outcome(I)||'</td>');
    END IF;

    append_file_content('   <td CLASS="table_val">'||g_tab_pmc_execution_time(I)||'</td>');

    append_file_content('   <td CLASS="table_val">'||g_tab_pmc_count_issues(I)||'</td>');

  append_file_content('</tr>');

 END LOOP;

 append_file_content('</TABLE>');
 append_file_content('</BR>');


 --------------------------------------------
 -- Each Class and the relevant checks within
 --------------------------------------------
 OPEN c_chk_class;
 FETCH c_chk_class BULK COLLECT INTO g_tab_pmcl_code
                                    ,g_tab_pmcl_label;
 CLOSE c_chk_class;

 FOR cl IN 1..g_tab_pmcl_code.COUNT LOOP

  ------------------------
  -- CHECKS IN GIVEN CLASS
  ------------------------
  OPEN c_chks(g_tab_pmcl_code(cl));
  FETCH c_chks BULK COLLECT INTO  g_tab_pmc_ref
                                 ,g_tab_pmc_description
                                 ,g_tab_pmc_label
                                 ,g_tab_pmc_outcome
                                 ,g_tab_pmc_notes
                                 ,g_tab_pmc_execution_time
                                 ,g_tab_pmc_count_issues;
  CLOSE c_chks;


  -----------------------------------------------------
  -- Table for each Check with listing of issues if any
  -----------------------------------------------------
  append_file_content('<TABLE width="1040" border="0" cellpadding="2" cellspacing="1">');
  append_file_content('<tr bgcolor="006666">');
  append_file_content('   <td align="LEFT" width="640" colspan="3" CLASS="big_title"> <b> '||UPPER(g_tab_pmcl_label(cl))||' </b> </a> </td>');
  append_file_content('</tr>');
  append_file_content('</TABLE>');


  FOR I IN 1..g_tab_pmc_ref.COUNT LOOP

    append_file_content('<TABLE width="1040" border="0" cellpadding="2" cellspacing="1">');

   -- check description  and outcome column headings
    append_file_content('<tr bgcolor="#FF9900">');
    append_file_content('   <td width="640" colspan="1" CLASS="title"> <a name="'||g_tab_pmc_label(I)||'"> <b> Check Description </b> </a> </td>');
    append_file_content('   <td width="100" colspan="1" CLASS="title"><b> Outcome </b></td>');
    append_file_content('   <td width="300" colspan="1" CLASS="title"><b> Notes </b></td>');
    append_file_content('</tr>');


   -- check description  and outcome values
    append_file_content('<tr bgcolor="#ffe1aa">');
    append_file_content('   <td width="640" CLASS="table_val">'||g_tab_pmc_label(I)||'<BR>'||REPLACE(g_tab_pmc_description(I),CHR(10),'<BR>')||' </td>');

    IF g_tab_pmc_outcome(I) = g_pass THEN
      append_file_content('   <td width="100" CLASS="table_val">'||g_tab_pmc_outcome(I)||'</td>');
    ELSE
      append_file_content('   <td width="100" CLASS="table_val_highlighted">'||g_tab_pmc_outcome(I)||'</td>');
    END IF;

    append_file_content('   <td width="300"CLASS="table_val">'||NVL(g_tab_pmc_notes(I),'None')||'</td>');
    append_file_content('</tr>');

      OPEN c_chk_labels(g_tab_pmc_ref(I));
      FETCH c_chk_labels BULK COLLECT INTO g_tab_pmci_issue_label;
      CLOSE c_chk_labels;


      FOR l IN 1..g_tab_pmci_issue_label.COUNT LOOP

        OPEN c_chk_issues(g_tab_pmc_ref(I)
                         ,g_tab_pmci_issue_label(l)
                         );
        FETCH c_chk_issues BULK COLLECT INTO g_tab_pmci_details;
        CLOSE c_chk_issues;


	    -----------------------------------------------------------------------------------------------------------
   	    -- Do not show more than the number of given issues for a given check - otherwise log file could be massive
	    -----------------------------------------------------------------------------------------------------------
        append_file_content('<tr bgcolor="#fff1df">');

        IF g_tab_pmci_details.COUNT <= pi_max_check_issues THEN
           v_max_issues_to_list := g_tab_pmci_details.COUNT;
           append_file_content('   <td align="CENTER" colspan="3" CLASS="title"><b>'||g_tab_pmci_issue_label(l)||'</b></td>');
   	    ELSE
	       v_max_issues_to_list := pi_max_check_issues;
           append_file_content('   <td align="CENTER" colspan="3" CLASS="title"><b>'||g_tab_pmci_issue_label(l)||'  (first '||pi_max_check_issues||' issues of '||g_tab_pmci_details.COUNT||')</b></td>');
  	    END IF;

        append_file_content('</tr>');

        -- issue no and issue details column headings
        append_file_content('<tr bgcolor="#fff1df">');
        append_file_content('   <td colspan="2" align="LEFT" colspan="1" CLASS="title"><b> Details </b></td>');
        append_file_content('   <td colspan="1" align="LEFT" colspan="1" CLASS="title"><b> Issue Ref</b></td>');
        append_file_content('</tr>');


        FOR d IN 1..v_max_issues_to_list LOOP
         -- issue no and issue details
         append_file_content('<tr bgcolor="#fff1df">');
         append_file_content('   <td colspan="2" align="LEFT" colspan="1" CLASS="table_val">'||g_tab_pmci_details(d)||'</td>');
         append_file_content('   <td colspan="1" align="LEFT" colspan="1" CLASS="table_val">'||d||'</td>');
         append_file_content('</tr>');
        END LOOP;  -- through issues in given label

     END LOOP; -- through labels in given check

     append_file_content('</TABLE>');
     append_file_content('</BR>');

   END LOOP; -- through checks in given class
 append_file_content('<BR> </BR>');
 END LOOP; -- through classes

 append_file_content('</BODY>');
 append_file_content('</HTML>');

 write_to_file(pi_all_lines     => g_file_content);

END build_html;
--
---------------------------------------------------------------------------
--
PROCEDURE build_text_file(pi_max_check_issues IN NUMBER) IS

  v_max_issues_to_list PLS_INTEGER;

BEGIN


 append_file_content('Highways By Exor Pre-Migration Checks');
 append_file_content(' ');

-------------------
-- INSTANCE DETAILS
-------------------

 append_file_content('Checks Executed Against');
 append_file_content('=======================');
 append_file_content(g_instance_details);
 append_file_content('');

----------
-- SYSDATE
----------
 append_file_content('Checks Executed On');
 append_file_content('==================');
 append_file_content(TO_CHAR(SYSDATE,'DAY DD MONTH YYYY HH24:MI'));
 append_file_content('');


----------------------
-- HIG PRODUCT DETAILS
----------------------

 append_file_content('Licenced Highways Products');
 append_file_content('==========================');

 FOR I IN 1..g_tab_hpr_product.COUNT LOOP
    append_file_content(g_tab_hpr_product(I)||' - '||g_tab_hpr_version(I));
 END LOOP;
 append_file_content('');

----------------
-- CHECK DETAILS
----------------
 OPEN c_chks(NULL);
 FETCH c_chks BULK COLLECT INTO  g_tab_pmc_ref
                                ,g_tab_pmc_description
                                ,g_tab_pmc_label
                                ,g_tab_pmc_outcome
                                ,g_tab_pmc_notes
                                ,g_tab_pmc_execution_time
                                ,g_tab_pmc_count_issues;
 CLOSE c_chks;


 ----------------
 -- Check Summary
 ----------------
 append_file_content('============================================================================================');
 append_file_content('Check Summary');
 append_file_content(' ');
 FOR I IN 1..g_tab_pmc_ref.COUNT LOOP
  append_file_content('  '||g_tab_pmc_label(I)||'  -  '||g_tab_pmc_outcome(I)||'   - Execution Time  '||g_tab_pmc_execution_time(I)||' seconds  Issue Count -'||g_tab_pmc_count_issues(I));
 END LOOP;
 append_file_content('============================================================================================');
 append_file_content(' ');
 append_file_content(' ');
 append_file_content(' ');

 --------------------------------------------
 -- Each Class and the relevant checks within
 --------------------------------------------
 OPEN c_chk_class;
 FETCH c_chk_class BULK COLLECT INTO g_tab_pmcl_code
                                    ,g_tab_pmcl_label;
 CLOSE c_chk_class;

 FOR cl IN 1..g_tab_pmcl_code.COUNT LOOP


  ------------------------
  -- CHECKS IN GIVEN CLASS
  ------------------------
  OPEN c_chks(g_tab_pmcl_code(cl));
  FETCH c_chks BULK COLLECT INTO  g_tab_pmc_ref
                                 ,g_tab_pmc_description
                                 ,g_tab_pmc_label
                                 ,g_tab_pmc_outcome
                                 ,g_tab_pmc_notes
                                 ,g_tab_pmc_execution_time
                                 ,g_tab_pmc_count_issues;
  CLOSE c_chks;


 -----------------------------------------------------
 -- Table for each Check with listing of issues if any
 -----------------------------------------------------
 FOR I IN 1..g_tab_pmc_ref.COUNT LOOP


-- check description  and outcome values
 append_file_content('============================================================================================');
 append_file_content('Start of check');
 append_file_content('');
 append_file_content('  Check Class');
 append_file_content('  -----------------');
 append_file_content('  '|| UPPER(g_tab_pmcl_label(cl)));
 append_file_content('');
 append_file_content('  Check Description');
 append_file_content('  -----------------');
 append_file_content('  '||g_tab_pmc_label(I)||CHR(10)||g_tab_pmc_description(I));
 append_file_content('');
 append_file_content('  Outcome');
 append_file_content('  -------');
 append_file_content('  '||g_tab_pmc_outcome(I));
 append_file_content('');
 append_file_content('  Notes');
 append_file_content('  -----');
 append_file_content('  '||NVL(REPLACE(g_tab_pmc_notes(I),'<BR>',CHR(10)||'  '),'None'));


 OPEN c_chk_labels(g_tab_pmc_ref(I));
 FETCH c_chk_labels BULK COLLECT INTO g_tab_pmci_issue_label;
 CLOSE c_chk_labels;


 FOR l IN 1..g_tab_pmci_issue_label.COUNT LOOP

     OPEN c_chk_issues(g_tab_pmc_ref(I)
                      ,g_tab_pmci_issue_label(l)
                      );
     FETCH c_chk_issues BULK COLLECT INTO g_tab_pmci_details;
     CLOSE c_chk_issues;

	 -----------------------------------------------------------------------------------------------------------
	 -- Do not show more than the number of given issues for a given check - otherwise log file could be massive
	 -----------------------------------------------------------------------------------------------------------
     append_file_content('    ');

     IF g_tab_pmci_details.COUNT <= pi_max_check_issues THEN
        v_max_issues_to_list := g_tab_pmci_details.COUNT;
        append_file_content('    '|| g_tab_pmci_issue_label(l));
	 ELSE
	    v_max_issues_to_list := pi_max_check_issues;
        append_file_content('    '|| g_tab_pmci_issue_label(l)||'  (first '||pi_max_check_issues||' issues of '||g_tab_pmci_details.COUNT||')');
	 END IF;

     FOR d IN 1..v_max_issues_to_list LOOP

      -- issue no and issue details
      append_file_content('    '||d||'     '|| g_tab_pmci_details(d));

     END LOOP;  -- issues in given check label

  END LOOP; -- through lables in given check

 append_file_content('');
 append_file_content('End of check');
 append_file_content('============================================================================================');
 append_file_content('');
 append_file_content('');
 END LOOP; -- through checks in given class

 append_file_content('');
 append_file_content('');

 END LOOP; -- through classes
 write_to_file(pi_all_lines     => g_file_content);


END build_text_file;
--
---------------------------------------------------------------------------
--
PROCEDURE build_html_checklist IS

BEGIN

 g_file_content.DELETE;

 append_file_content('<HTML>');
 append_file_content(' <style>');
 append_file_content('.title {font-family: Arial, Helvetica, sans-serif; font-SIZE: 10pt;	color: 000000; font : bold; }');
 append_file_content('.big_title {font-family: Arial, Helvetica, sans-serif; font-SIZE: 10pt;	color: white; font : bold; }');
 append_file_content('.table_val {font-family: Arial, Helvetica, sans-serif;	font-SIZE: 9pt; color: black; font : normal; }');
 append_file_content('.table_val_highlighted {font-family: Arial, Helvetica, sans-serif;	font-SIZE: 9pt; color: red; font : normal; }');
 append_file_content(' </style>');
 append_file_content('<HEAD>');
 append_file_content('<TITLE> Highways By Exor Pre-Migration Checks </TITLE>');
 append_file_content('</HEAD>');
 append_file_content('<BODY>');


 --------------------------------------------
 -- Each Class and the relevant checks within
 --------------------------------------------
 OPEN c_chk_class;
 FETCH c_chk_class BULK COLLECT INTO g_tab_pmcl_code
                                    ,g_tab_pmcl_label;
 CLOSE c_chk_class;

 FOR cl IN 1..g_tab_pmcl_code.COUNT LOOP

  ------------------------
  -- CHECKS IN GIVEN CLASS
  ------------------------
  OPEN c_chks(g_tab_pmcl_code(cl));
  FETCH c_chks BULK COLLECT INTO  g_tab_pmc_ref
                                 ,g_tab_pmc_description
                                 ,g_tab_pmc_label
                                 ,g_tab_pmc_outcome
                                 ,g_tab_pmc_notes
                                 ,g_tab_pmc_execution_time
                                 ,g_tab_pmc_count_issues;
  CLOSE c_chks;


  -----------------------------------------------------
  -- Table for each Check with listing of issues if any
  -----------------------------------------------------
  append_file_content('<TABLE width="1000" border="0" cellpadding="2" cellspacing="1">');
  append_file_content('<tr bgcolor="006666">');
  append_file_content('   <td align="LEFT" width="1000" colspan="3" CLASS="big_title"> <b> '||UPPER(g_tab_pmcl_label(cl))||' </b> </a> </td>');
  append_file_content('</tr>');
  append_file_content('<tr bgcolor="#FF9900">');
  append_file_content('   <td width="250" colspan="1" CLASS="title"> <b> Check</b> </td>');
  append_file_content('   <td width="650" colspan="1" CLASS="title"> <b> Description </b> </td>');
  append_file_content('   <td width="100" colspan="1" CLASS="title"> <b> Implemented in Procedure </b></td>');
  append_file_content('</tr>');


--  append_file_content('</TABLE>');


  FOR I IN 1..g_tab_pmc_ref.COUNT LOOP

--    append_file_content('<TABLE width="1000" border="0" cellpadding="2" cellspacing="1">');

   -- check description  and outcome values
    append_file_content('<tr bgcolor="#ffe1aa">');
    append_file_content('   <td width="250" CLASS="table_val">'||g_tab_pmc_label(I)||' </td>');
    append_file_content('   <td width="650" CLASS="table_val">'||REPLACE(g_tab_pmc_description(I),CHR(10),'<BR>')||'</td>');
    append_file_content('   <td width="100" CLASS="table_val">'||g_tab_pmc_ref(I)||'</td>');
    append_file_content('</tr>');

   END LOOP; -- through checks in given class
   append_file_content('</TABLE>');
 append_file_content('<BR> </BR>');

 END LOOP; -- through classes

 append_file_content('</BODY>');
 append_file_content('</HTML>');


 write_to_file(pi_all_lines     => g_file_content);


END build_html_checklist;
--
-----------------------------------------------------------------------------
--
PROCEDURE report_from_existing_results( pi_filename         VARCHAR2
                                      , pi_location         VARCHAR2
                                      , pi_max_check_issues NUMBER DEFAULT 50) IS
BEGIN
  open_file(pi_filename
          , pi_location);

  set_instance_details;
  set_hpr_details;
  build_html(pi_max_check_issues);

END report_from_existing_results;
--
----------------------------------------------------------------------------
--
PROCEDURE run_check( pi_filename         VARCHAR2
                   , pi_location         VARCHAR2
                   , pi_max_check_issues NUMBER   DEFAULT 50
                   , pi_chk_road_network VARCHAR2 DEFAULT 'Y'
                   , pi_chk_groups       VARCHAR2 DEFAULT 'Y'
                   , pi_chk_inv          VARCHAR2 DEFAULT 'Y'
                   , pi_chk_inv_hier     VARCHAR2 DEFAULT 'Y'
                   , pi_chk_inv_attribs  VARCHAR2 DEFAULT 'Y'
                   , pi_chk_spatial      VARCHAR2 DEFAULT 'Y'
                   , pi_chk_doc          VARCHAR2 DEFAULT 'Y'
                   , pi_chk_misc         VARCHAR2 DEFAULT 'Y'
                   ) IS
--
  l_count NUMBER := 0;

  l_dum NUMBER;

  v_filename VARCHAR2(100);

  CURSOR c_procs IS
  SELECT pmc_ref
  FROM   PRE_MIGRATION_CHK
  WHERE
         (pmc_pmcl_code = 'RN'  AND UPPER(pi_chk_road_network) = 'Y')
  OR     (pmc_pmcl_code = 'GRP' AND UPPER(pi_chk_groups) = 'Y')
  OR     (pmc_pmcl_code = 'INV' AND UPPER(pi_chk_inv) = 'Y')
  OR     (pmc_pmcl_code = 'INH' AND UPPER(pi_chk_inv_hier) = 'Y')
  OR     (pmc_pmcl_code = 'INF' AND UPPER(pi_chk_inv_attribs) = 'Y')
  OR     (pmc_pmcl_code = 'SPA' AND UPPER(pi_chk_spatial) = 'Y')
  OR     (pmc_pmcl_code = 'DOC' AND UPPER(pi_chk_doc) = 'Y')
  OR     (pmc_pmcl_code = 'MSC' AND UPPER(pi_chk_misc) = 'Y')
  ORDER BY pmc_order;

  t_tab_procs_to_run tab_pmc_ref;

BEGIN

  initialise_pmc;

  open_file(pi_filename
          , pi_location); -- open the file before running the checks so that we know that it can be written to

  OPEN c_procs;
  FETCH c_procs BULK COLLECT INTO t_tab_procs_to_run;
  CLOSE c_procs;

  FOR I IN 1..t_tab_procs_to_run.COUNT LOOP
     EXECUTE IMMEDIATE('BEGIN '||g_package_name||'.'||t_tab_procs_to_run(I)||'; END;');
  END LOOP;

  set_instance_details;
  set_hpr_details;

  build_html(pi_max_check_issues);

  --------------------------------------------------------------------
  -- drop index that we created on POINT_USAGES to improve performance
  --------------------------------------------------------------------
  BEGIN
     EXECUTE IMMEDIATE('DROP INDEX PUS_MIGRATION_IND');
  EXCEPTION
     WHEN OTHERS THEN
        NULL;
  END;


END;
--
----------------------------------------------------------------------------
--


PROCEDURE other_locations IS
--
---------------------------------------------------------------------------
-- 	Check that measures are consistent with
--	the length of the section. If any measures are greater than
--	section length then flag and
--	repair. The scripts will currently fail any items that
--	are greater than the section length. The lengths must then be reset
--	to the length of section.

--'DEFECTS','MAI'
--'ACTIVITIES_REPORT','MAI'
--'INSURANCE_CLAIM_PARAMETERS','MAI'
--'LOCAL_FREQS','MAI'
--'SCHEDULE','MAI'
--'WORK_ORDER_LINES','MAI'
--'ROAD_INTERSECTIONS','STR'
--'ACC_ITEMS_ALL','ACC'
--'SCHEME_ROADS','STP'

---------------------------------------------------------------------------

  l_inv_length  NUMBER;
  l_count NUMBER;

  TYPE tab_varchar80    IS TABLE OF VARCHAR2(80)    INDEX BY BINARY_INTEGER;
  TYPE tab_date         IS TABLE OF DATE	        INDEX BY BINARY_INTEGER;
  TYPE tab_number       IS TABLE OF NUMBER	        INDEX BY BINARY_INTEGER;
--
  l_tab_st_chain tab_number;
  l_tab_end_chain tab_number;
  l_tab_id	   tab_number;
  l_tab_code   tab_varchar80;
  l_tab_length	   tab_number;
  l_tab_unique	   tab_varchar80;


  l_st_chain NUMBER;
  l_end_chain NUMBER;
  l_id	   NUMBER;
  l_code   VARCHAR2(80);
  l_length	   NUMBER;
  l_unique	   VARCHAR2(80);

  TYPE ref_cursor IS REF CURSOR;
  ref_cur ref_cursor;

  I NUMBER;

--
BEGIN


  g_proc_name := 'other_locations';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN
    (SELECT table_name
	FROM user_tables,HIG_PRODUCTS
	WHERE hpr_key IS NOT NULL
	AND table_name IN ('DEFECTS','ROAD_INTERSECTIONS','ACC_ITEMS_ALL','ACTIVITIES_REPORT'
	                  ,'INSURANCE_CLAIM_PARAMETERS','LOCAL_FREQS','SCHEDULE','WORK_ORDER_LINES','SCHEME_ROADS')
	AND DECODE(table_name,'DEFECTS','MAI'
	                     ,'ACTIVITIES_REPORT','MAI'
						 ,'INSURANCE_CLAIM_PARAMETERS','MAI'
						 ,'LOCAL_FREQS','MAI'
						 ,'SCHEDULE','MAI'
						 ,'WORK_ORDER_LINES','MAI'
						 ,'ROAD_INTERSECTIONS','STR'
						 ,'SCHEME_ROADS','STP'
						 ,'ACC_ITEMS_ALL','ACC')=hpr_product)
	LOOP

	I:=0;
	l_tab_st_chain.DELETE;
    l_tab_end_chain.DELETE;
    l_tab_id.DELETE;
    l_tab_code.DELETE;
    l_tab_length.DELETE;
    l_tab_unique.DELETE;

    IF c1rec.table_name='DEFECTS' THEN
      g_sql := 'SELECT def_st_chain'||
	           ' ,to_number(null)'||
    		   ' ,def_defect_id'||
  		       ' ,def_defect_code'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM   DEFECTS'||
  		       ' ,ROAD_SEGS'||
  		       '   WHERE  rse_he_id = def_rse_he_id'||
  		       '   AND def_rse_he_id IS NOT NULL'||
  		       '   AND (def_St_chain>rse_length or def_st_Chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='ACTIVITIES_REPORT' THEN
      g_sql := 'SELECT are_st_chain'||
	           ' ,are_end_chain'||
    		   ' ,are_report_id'||
  		       ' ,are_batch_id'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM   activities_report'||
  		       ' ,ROAD_SEGS'||
  		       '   WHERE  rse_he_id = are_rse_he_id'||
  		       '   AND (are_St_chain>rse_length'||
  		       '   or are_end_chain>rse_length'||
  		       '   or are_st_chain>are_end_chain or are_st_chain<0 or are_end_chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='INSURANCE_CLAIM_PARAMETERS' THEN
      g_sql := 'SELECT icp_start_chain'||
	           ' ,icp_end_chain'||
    		   ' ,icp_report_id'||
  		       ' ,icp_report_name'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM  INSURANCE_CLAIM_PARAMETERS'||
  		       ' ,ROAD_SEGS'||
  		       '   WHERE  rse_he_id = icp_rse_he_id'||
  		       '   AND (icp_Start_chain>rse_length'||
  		       '   or icp_end_chain>rse_length'||
  		       '   or icp_start_chain>icp_end_chain or icp_start_chain<0 or icp_end_chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='LOCAL_FREQS' THEN
      g_sql := 'SELECT lfr_start_chain'||
	           ' ,lfr_end_chain'||
    		   ' ,LFR_ATV_ACTY_AREA_CODE'||
  		       ' ,LFR_INT_CODE'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM  LOCAL_FREQS'||
  		       ' ,ROAD_SEGS'||
  		       '   WHERE  rse_he_id = lfr_rse_he_id'||
  		       '   AND (lfr_Start_chain>rse_length'||
  		       '   or lfr_end_chain>rse_length'||
  		       '   or lfr_start_chain>lfr_end_chain or lfr_start_chain<0 or lfr_end_Chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='SCHEDULE' THEN
      g_sql := 'SELECT st_chain'||
	           ' ,end_chain'||
    		   ' ,SFR_ATV_ACTY_AREA_CODE'||
  		       ' ,SFR_INT_CODE'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM  SCHEDULE'||
  		       ' ,ROAD_SEGS'||
  		       '   WHERE  rse_he_id = sfr_rse_he_id'||
  		       '   AND (St_chain>rse_length'||
  		       '   or end_chain>rse_length'||
  		       '   or st_chain>end_chain or st_chain<0 or end_chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='WORK_ORDER_LINES' THEN
      g_sql := 'SELECT wol_are_st_chain'||
	           ' ,wol_are_end_chain'||
    		   ' ,wol_id'||
  		       ' ,wol_works_order_no'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM  WORK_ORDER_LINES'||
  		       ' ,ROAD_SEGS'||
  		       '   WHERE  rse_he_id = wol_rse_he_id'||
  		       '   AND (wol_are_St_chain>rse_length'||
  		       '   or wol_are_end_chain>rse_length'||
  		       '   or wol_are_st_chain>wol_Are_end_chain or wol_Are_st_chain<0 or wol_are_end_Chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='ROAD_INTERSECTIONS' THEN
      g_sql := 'SELECT rin_st_chain'||
	           ' ,rin_end_chain'||
    		   ' ,str_id'||
  		       ' ,Str_name'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM   road_intersections'||
  		       ' ,ROAD_SEGS'||
  		       ' ,STR_ITEMS_ALL'||
  		       '   WHERE  rse_he_id = rin_rse_he_id'||
  		       '   AND rin_Str_id=str_id'||
  		       '   AND (rin_St_chain>rse_length'||
  		       '   or rin_end_chain>rse_length'||
  		       '   or rin_st_chain>rin_end_chain or rin_st_chain<0 or rin_End_chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='ACC_ITEMS_ALL' THEN
      g_sql := 'SELECT acc_chain'||
	           ' ,to_number(null)'||
    		   ' ,acc_id'||
  		       ' ,acc_name'||
  		       ' ,rse_length'||
  		       ' ,rse_unique'||
  		       ' FROM   ACC_ITEMS_ALL'||
  		       ' ,ROAD_SEGS'||
  		       '   WHERE  rse_he_id = acc_rse_he_id'||
  		       '   AND acc_rse_he_id IS NOT NULL'||
  		       '   AND (acc_chain>rse_length or acc_chain<0)'||
  		       '   ORDER BY 4';
	ELSIF c1rec.table_name='SCHEME_ROADS' THEN
      g_sql := 'SELECT start_point'||
	           ' ,end_point '||
    		   ' ,s.scheme_id '||
  		       ' ,s.scheme_name '||
  		       ' ,rse_length '||
  		       ' ,rse_unique '||
  		       ' FROM   SCHEME_ROADS sr'||
  		       ' ,ROAD_SEGS r '||
  		       ' ,SCHEMES s '||
  		       '   WHERE  r.rse_he_id = sr.rse_he_id'||
  		       '   AND sr.scheme_id=s.SCHEME_ID '||
  		       '   AND (start_point>rse_length'||
  		       '   OR end_point>rse_length '||
  		       '   OR start_point>end_point or start_point<0 or end_point<0)'||
  		       '  ORDER BY 4';
    END IF;

--    EXECUTE IMMEDIATE g_sql BULK COLLECT INTO l_tab_st_chain,l_tab_end_chain, l_tab_id,l_tab_code,l_tab_length,l_tab_unique;


	 OPEN ref_cur FOR g_sql;
	 LOOP
	  FETCH ref_cur INTO l_st_chain, l_end_chain, l_id,l_code, l_length, l_unique;
      EXIT WHEN ref_cur%NOTFOUND;
	  
	  IF ref_cur%FOUND THEN
          I:=I+1;
          l_tab_st_chain(I):=l_st_chain;
          l_tab_end_chain(I):=l_end_chain;
          l_tab_id(I):=l_id;
          l_tab_code(I):=l_code;
          l_tab_length(I):=l_length;
          l_tab_unique(I):=l_unique;
      END IF;
    END LOOP;
	CLOSE ref_cur; 

	  
	  

    FOR I IN 1..l_tab_id.COUNT LOOP
        g_error := c1rec.table_name||' '||l_tab_code(I)||' id ('||l_tab_id(I)||') at position '||l_tab_st_chain(I);
		IF l_tab_end_chain(I) IS NOT NULL THEN
		  g_error:=g_error||' to '||l_tab_end_Chain(I);
		END IF;
		g_error:=g_error||' cannot be located on road ('||l_tab_unique(I)||') with length ('||l_tab_length(I)||')';

        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'Items located outside the length of the road section. Either the road section length or the item position needs modifying.'
                ,pi_pmci_details     => g_error);

    END LOOP;
	COMMIT;
  END LOOP;

  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref        => g_proc_name
                    ,pi_pmc_notes      => NULL);

END other_locations;
--


PROCEDURE orphan_hig_codes IS
--
  CURSOR c1 IS
  SELECT DISTINCT(hco_domain) hco_domain FROM HIG_CODES
  WHERE NOT EXISTS
  (SELECT 'x' FROM HIG_DOMAINS
  WHERE hco_domain=hdo_domain);
--

BEGIN

  g_proc_name := 'orphan_hig_codes';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP
    g_error := c1rec.hco_domain;

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'List of HIG_CODES without entry in HIG_DOMAINS'
                ,pi_pmci_details     => g_error);


  END LOOP;


  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END orphan_hig_Codes;
--
-----------------------------------------------------------------------------
--

PROCEDURE invalid_load_columns IS
--
l_sql VARCHAR2(32000);

--
  TYPE tab_varchar4    IS TABLE OF VARCHAR2(4)    INDEX BY BINARY_INTEGER;
  TYPE tab_varchar30   IS TABLE OF VARCHAR2(30)    INDEX BY BINARY_INTEGER;

--
  l_tab_inv_Code tab_varchar4;
  l_tab_sys_flag tab_varchar4;
  l_tab_hhpos tab_varchar30;

  l_inv_Code VARCHAR2(4);
  l_sys_flag VARCHAR2(4);
  l_hhpos VARCHAR2(30);

 TYPE ref_cursor IS REF CURSOR;
  ref_cur ref_cursor;

 I NUMBER;

BEGIN

  g_proc_name := 'invalid_load_columns';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  IF product_licensed('MAI') THEN

    FOR c1rec IN
      (SELECT column_name
       FROM user_tab_columns
       WHERE table_name='INV_ITEM_TYPES'
       AND column_name LIKE 'ITY_HHPOS%'
       ORDER BY 1) LOOP

       l_sql:=l_sql||'select distinct ITY_INV_CODE, ITY_SYS_FLAG, '||c1rec.column_name||' hhpos from inv_item_types union ';
    END LOOP;
    l_sql:=SUBSTR(l_sql,1,LENGTH(l_sql)-6);

    l_sql:='select * from ('||l_sql||') where ''IIT_''||hhpos in';

    l_sql:=l_sql||'(''IIT_ANGLE_TXT'', ''IIT_CLASS_TXT'', ''IIT_COLOUR_TXT'',''IIT_COORD_FLAG'',';
    l_sql:=l_sql||'''IIT_END_DATE'', ''IIT_INV_OWNERSHIP'', ''IIT_LCO_LAMP_CONFIG_ID'',';
    l_sql:=l_sql||'''IIT_MATERIAL_TXT'', ''IIT_METHOD_TXT'', ''IIT_OFFSET'', ''IIT_OPTIONS_TXT'',';
    l_sql:=l_sql||'''IIT_OUN_ORG_ID_ELEC_BOARD'', ''IIT_OWNER_TXT'', ''IIT_PROV_FLAG'',';
    l_sql:=l_sql||'''IIT_REV_BY'', ''IIT_REV_DATE'', ''IIT_TYPE_TXT'', ''IIT_XTRA_DOMAIN_TXT_1'')';

--    EXECUTE IMMEDIATE l_sql BULK COLLECT INTO
--    l_tab_inv_code,l_tab_sys_flag,l_tab_hhpos;
    I:=0;

     OPEN ref_cur FOR l_sql;
	 LOOP
	  FETCH ref_cur INTO l_inv_code,l_sys_flag,l_hhpos;
      EXIT WHEN ref_cur%NOTFOUND;
	  
	  IF ref_cur%FOUND THEN
    	  I:=I+1;
          l_tab_inv_code(I):=l_inv_code;
		  l_tab_sys_flag(I):=l_sys_flag;
		  l_tab_hhpos(I):=l_hhpos;
      END IF;
    END LOOP;
	CLOSE ref_cur; 

	  
	  


    FOR I IN 1..l_tab_inv_code.COUNT LOOP


       g_error := l_tab_inv_Code(I)||' '||l_tab_sys_flag(I)||' cant load into '||l_tab_hhpos(I);

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label =>'INVALID INVENTORY LOAD COLUMN'
                ,pi_pmci_details     => g_error);

    END LOOP;
 END IF;
   -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END invalid_load_columns;
--
-----------------------------------------------------------------------------
--

PROCEDURE check_mai_table_columns IS

TYPE rec_cols IS RECORD (table_name VARCHAR2(30)
                             ,column_name VARCHAR2(30)
							 ,column_id   NUMBER);

 TYPE tab_rec_cols IS TABLE OF rec_cols INDEX BY BINARY_INTEGER;

 l_tab_rec_cols tab_rec_cols;


 PROCEDURE ADD(pi_table_name IN VARCHAR2
              ,pi_column_name IN VARCHAR2
			  ,pi_column_id   IN NUMBER) IS

  l_subscript PLS_INTEGER := l_tab_rec_cols.COUNT+1;

 BEGIN

  l_tab_rec_cols(l_subscript).table_name := pi_table_name;
  l_tab_rec_cols(l_subscript).column_name := pi_column_name;
  l_tab_rec_cols(l_subscript).column_id := pi_column_id;

 END ADD;

 FUNCTION column_ok(pi_rec_cols rec_cols) RETURN BOOLEAN IS

  CURSOR c1 IS
  SELECT 'x'
  FROM   user_tab_colUMNs
  WHERE  table_name = pi_rec_cols.table_name
  AND    column_name = pi_rec_cols.column_name
  AND    column_id = pi_rec_cols.column_id;

  l_dummy VARCHAR2(1) := NULL;

 BEGIN

  OPEN c1;
  FETCH c1 INTO l_dummy;
  CLOSE c1;

  IF l_dummy IS NULL THEN
    RETURN(FALSE);
  ELSE
    RETURN(TRUE);
  END IF;

 END column_ok;

BEGIN
  g_proc_name := 'check_mai_table_columns';
  set_pmc_start(pi_pmc_ref => g_proc_name);


  IF product_licensed('MAI') THEN

ADD('ACTIVITIES', 'ATV_ACTY_AREA_CODE',    '1' ) ;
ADD('ACTIVITIES', 'ATV_DTP_FLAG',          '2' ) ;
ADD('ACTIVITIES', 'ATV_IF_SCHEDULED_FLAG', '3' ) ;
ADD('ACTIVITIES', 'ATV_MAINT_INSP_FLAG',   '4' ) ;
ADD('ACTIVITIES', 'ATV_SEQUENCE_NO',       '5' ) ;
ADD('ACTIVITIES', 'ATV_SPECIALIST_FLAG',   '6' ) ;
ADD('ACTIVITIES', 'ATV_CALC_TYPE',         '7' ) ;
ADD('ACTIVITIES', 'ATV_CAT1P_INT_CODE',    '8' ) ;
ADD('ACTIVITIES', 'ATV_CAT1T_INT_CODE',    '9' ) ;
ADD('ACTIVITIES', 'ATV_CAT2_1P_INT_CODE',  '10' ) ;
ADD('ACTIVITIES', 'ATV_CAT2_2P_INT_CODE',  '11' ) ;
ADD('ACTIVITIES', 'ATV_CAT2_3P_INT_CODE',  '12' ) ;
ADD('ACTIVITIES', 'ATV_DESCR',             '13' ) ;
ADD('ACTIVITIES', 'ATV_DTP_EXP_CODE',      '14' ) ;
ADD('ACTIVITIES', 'ATV_LA_EXP_CODE',       '15' ) ;
ADD('ACTIVITIES', 'ATV_MAINT_COST',        '16' ) ;
ADD('ACTIVITIES', 'ATV_SEASONAL_FLAG',     '17' ) ;
ADD('ACTIVITIES', 'ATV_UNIT',              '18' ) ;
ADD('ACTIVITIES', 'ATV_ACTIVITY_DURATION', '19' ) ;
ADD('ACTIVITIES', 'ATV_START_DATE',        '20' ) ;
ADD('ACTIVITIES', 'ATV_END_DATE',          '21' ) ;

ADD('ACTIVITIES_REPORT','ARE_REPORT_ID','1');
ADD('ACTIVITIES_REPORT','ARE_RSE_HE_ID','2');
ADD('ACTIVITIES_REPORT','ARE_BATCH_ID','3');
ADD('ACTIVITIES_REPORT','ARE_CREATED_DATE','4');
ADD('ACTIVITIES_REPORT','ARE_LAST_UPDATED_DATE','5');
ADD('ACTIVITIES_REPORT','ARE_MAINT_INSP_FLAG','6');
ADD('ACTIVITIES_REPORT','ARE_SCHED_ACT_FLAG','7');
ADD('ACTIVITIES_REPORT','ARE_DATE_WORK_DONE','8');
ADD('ACTIVITIES_REPORT','ARE_END_CHAIN','9');
ADD('ACTIVITIES_REPORT','ARE_INITIATION_TYPE','10');
ADD('ACTIVITIES_REPORT','ARE_INSP_LOAD_DATE','11');
ADD('ACTIVITIES_REPORT','ARE_PEO_PERSON_ID_ACTIONED','12');
ADD('ACTIVITIES_REPORT','ARE_PEO_PERSON_ID_INSP2','13');
ADD('ACTIVITIES_REPORT','ARE_ST_CHAIN','14');
ADD('ACTIVITIES_REPORT','ARE_SURFACE_CONDITION','15');
ADD('ACTIVITIES_REPORT','ARE_WEATHER_CONDITION','16');
ADD('ACTIVITIES_REPORT','ARE_WOL_WORKS_ORDER_NO','17');

ADD('DEFECTS','DEF_EASTING','47');
ADD('DEFECTS','DEF_NORTHING','48');
ADD('DEFECTS','DEF_RESPONSE_CATEGORY','49');
ADD('DEFECTS','DEF_DEFECT_ID','1');
ADD('DEFECTS','DEF_RSE_HE_ID','2');
ADD('DEFECTS','DEF_IIT_ITEM_ID','3');
ADD('DEFECTS','DEF_ST_CHAIN','4');
ADD('DEFECTS','DEF_ARE_REPORT_ID','5');
ADD('DEFECTS','DEF_ATV_ACTY_AREA_CODE','6');
ADD('DEFECTS','DEF_SISS_ID','7');
ADD('DEFECTS','DEF_WORKS_ORDER_NO','8');
ADD('DEFECTS','DEF_CREATED_DATE','9');
ADD('DEFECTS','DEF_DEFECT_CODE','10');
ADD('DEFECTS','DEF_LAST_UPDATED_DATE','11');
ADD('DEFECTS','DEF_ORIG_PRIORITY','12');
ADD('DEFECTS','DEF_PRIORITY','13');
ADD('DEFECTS','DEF_STATUS_CODE','14');
ADD('DEFECTS','DEF_SUPERSEDED_FLAG','15');
ADD('DEFECTS','DEF_AREA','16');
ADD('DEFECTS','DEF_ARE_ID_NOT_FOUND','17');
ADD('DEFECTS','DEF_COORD_FLAG','18');
ADD('DEFECTS','DEF_DATE_COMPL','19');
ADD('DEFECTS','DEF_DATE_NOT_FOUND','20');
ADD('DEFECTS','DEF_DEFECT_CLASS','21');
ADD('DEFECTS','DEF_DEFECT_DESCR','22');
ADD('DEFECTS','DEF_DEFECT_TYPE_DESCR','23');
ADD('DEFECTS','DEF_DIAGRAM_NO','24');
ADD('DEFECTS','DEF_HEIGHT','25');
ADD('DEFECTS','DEF_IDENT_CODE','26');
ADD('DEFECTS','DEF_ITY_INV_CODE','27');
ADD('DEFECTS','DEF_ITY_SYS_FLAG','28');
ADD('DEFECTS','DEF_LENGTH','29');
ADD('DEFECTS','DEF_LOCN_DESCR','30');
ADD('DEFECTS','DEF_MAINT_WO','31');
ADD('DEFECTS','DEF_MAND_ADV','32');
ADD('DEFECTS','DEF_NOTIFY_ORG_ID','33');
ADD('DEFECTS','DEF_NUMBER','34');
ADD('DEFECTS','DEF_PER_CENT','35');
ADD('DEFECTS','DEF_PER_CENT_ORIG','36');
ADD('DEFECTS','DEF_PER_CENT_REM','37');
ADD('DEFECTS','DEF_RECHAR_ORG_ID','38');
ADD('DEFECTS','DEF_SERIAL_NO','39');
ADD('DEFECTS','DEF_SKID_COEFF','40');
ADD('DEFECTS','DEF_SPECIAL_INSTR','41');
ADD('DEFECTS','DEF_SUPERSEDED_ID','42');
ADD('DEFECTS','DEF_TIME_HRS','43');
ADD('DEFECTS','DEF_TIME_MINS','44');
ADD('DEFECTS','DEF_UPDATE_INV','45');
ADD('DEFECTS','DEF_X_SECT','46');



ADD('INV_ITEM_TYPES', 'ITY_DTP_FLAG',              '1' ) ;
ADD('INV_ITEM_TYPES', 'ITY_ELEC_DRAIN_CARR',       '2' ) ;
ADD('INV_ITEM_TYPES', 'ITY_INV_CODE',              '3' ) ;
ADD('INV_ITEM_TYPES', 'ITY_PNT_OR_CONT',           '4' ) ;
ADD('INV_ITEM_TYPES', 'ITY_SYS_FLAG',              '5' ) ;
ADD('INV_ITEM_TYPES', 'ITY_X_SECT_ALLOW_FLAG',     '6' ) ;
ADD('INV_ITEM_TYPES', 'ITY_CONTIGUOUS',            '7' ) ;
ADD('INV_ITEM_TYPES', 'ITY_DESCR',                 '8' ) ;
ADD('INV_ITEM_TYPES', 'ITY_DUPLICATE',             '9' ) ;
ADD('INV_ITEM_TYPES', 'ITY_FEA_CODE',              '10' ) ;
ADD('INV_ITEM_TYPES', 'ITY_PARENT_ITY',            '11' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS1',                '12' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS10',               '13' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS11',               '14' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS12',               '15' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS13',               '16' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS14',               '17' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS15',               '18' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS2',                '19' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS3',                '20' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS4',                '21' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS5',                '22' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS6',                '23' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS7',                '24' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS8',                '25' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS9',                '26' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSTRLNGTH',            '27' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG1',             '28' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG10',            '29' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG2',             '30' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG3',             '31' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG4',             '32' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG5',             '33' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG6',             '34' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG7',             '35' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG8',             '36' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBLNG9',             '37' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTATS',            '38' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT1',            '39' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT10',           '40' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT2',            '41' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT3',            '42' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT4',            '43' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT5',            '44' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT6',            '45' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT7',            '46' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT8',            '47' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHSUBSTRT9',            '48' ) ;
ADD('INV_ITEM_TYPES', 'ITY_MAX_ATTR_REQ',          '49' ) ;
ADD('INV_ITEM_TYPES', 'ITY_MIN_ATTR_REQ',          '50' ) ;
ADD('INV_ITEM_TYPES', 'ITY_ROAD_CHARACTERISTIC',   '51' ) ;
ADD('INV_ITEM_TYPES', 'ITY_SCREEN_SEQ',            '52' ) ;
ADD('INV_ITEM_TYPES', 'ITY_TOLERANCE',             '53' ) ;
ADD('INV_ITEM_TYPES', 'ITY_VIEW_NAME',             '54' ) ;
ADD('INV_ITEM_TYPES', 'ITY_START_DATE',            '55' ) ;
ADD('INV_ITEM_TYPES', 'ITY_END_DATE',              '56' ) ;
ADD('INV_ITEM_TYPES', 'ITY_CONTIG_JOINS_GAP',      '57' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS16',               '58' ) ;
ADD('INV_ITEM_TYPES', 'ITY_SURVEY',                '59' ) ;
ADD('INV_ITEM_TYPES', 'ITY_MULTI_ALLOWED',         '60' ) ;
ADD('INV_ITEM_TYPES', 'ITY_SHORT_DESCR',           '61' ) ;
ADD('INV_ITEM_TYPES', 'ITY_AREA_OR_LENGTH',        '62' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS17',               '63' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS18',               '64' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS19',               '65' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS20',               '66' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS21',               '67' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS22',               '68' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS23',               '69' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS24',               '70' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS25',               '71' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS26',               '72' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS27',               '73' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS28',               '74' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS29',               '75' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS30',               '76' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS31',               '77' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS32',               '78' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS33',               '79' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS34',               '80' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS35',               '81' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS36',               '82' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS37',               '83' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS38',               '84' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS39',               '85' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS40',               '86' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS41',               '87' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS42',               '88' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS43',               '89' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS44',               '90' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS45',               '91' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS46',               '92' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS47',               '93' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS48',               '94' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS49',               '95' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS50',               '96' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS51',               '97' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS52',               '98' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS53',               '99' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS54',               '100' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS55',               '101' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS56',               '102' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS57',               '103' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS58',               '104' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS59',               '105' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS60',               '106' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS61',               '107' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS62',               '108' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS63',               '109' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS64',               '110' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS65',               '111' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS66',               '112' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS67',               '113' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS68',               '114' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS69',               '115' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS70',               '116' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS71',               '117' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS72',               '118' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS73',               '119' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS74',               '120' ) ;
ADD('INV_ITEM_TYPES', 'ITY_HHPOS75',               '121' ) ;
ADD('INV_ITEM_TYPES', 'ITY_CLOSE_EXISTING',        '122' ) ;
ADD('INV_ITEM_TYPES', 'ITY_INCL_ROAD_SEGS',        '123' ) ;

ADD('REPAIRS','REP_DEF_DEFECT_ID','1');
ADD('REPAIRS','REP_ACTION_CAT','2');
ADD('REPAIRS','REP_RSE_HE_ID','3');
ADD('REPAIRS','REP_TRE_TREAT_CODE','4');
ADD('REPAIRS','REP_ATV_ACTY_AREA_CODE','5');
ADD('REPAIRS','REP_CREATED_DATE','6');
ADD('REPAIRS','REP_DATE_DUE','7');
ADD('REPAIRS','REP_LAST_UPDATED_DATE','8');
ADD('REPAIRS','REP_SUPERSEDED_FLAG','9');
ADD('REPAIRS','REP_COMPLETED_HRS','10');
ADD('REPAIRS','REP_COMPLETED_MINS','11');
ADD('REPAIRS','REP_DATE_COMPLETED','12');
ADD('REPAIRS','REP_DESCR','13');
ADD('REPAIRS','REP_LOCAL_DATE_DUE','14');
ADD('REPAIRS','REP_OLD_DUE_DATE','15');


 FOR I IN 1..l_tab_rec_cols.COUNT LOOP
  IF NOT column_ok(l_tab_rec_cols(I)) THEN

       g_error := l_tab_rec_cols(I).table_name||'.'||l_tab_rec_cols(I).column_name||' is incorrectly defined - table requires a rebuild - contact exor';

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label =>'MAI TABLE COLUMNS'
                ,pi_pmci_details     => g_error);



  END IF;
 END LOOP;



  END IF;
   -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => 'As part of the migration you will need to run the mai_table_rebuild.sql script'
                    ,pi_note_over_fail => TRUE);

END check_mai_table_columns;
--
-----------------------------------------------------------------------------
--

FUNCTION product_licensed(pi_product IN HIG_PRODUCTS.HPR_PRODUCT%TYPE)
RETURN BOOLEAN IS
l_key NUMBER;
BEGIN
SELECT hpr_key
INTO l_key
FROM HIG_PRODUCTS
WHERE hpr_product=pi_product;

IF l_key IS NOT NULL THEN
  RETURN TRUE;
ELSE
  RETURN FALSE;
END IF;
EXCEPTION WHEN OTHERS THEN
 RETURN FALSE;
END product_licensed ;


PROCEDURE check_wo IS
--
--

  BEGIN

  g_proc_name := 'check_wo';
  set_pmc_start(pi_pmc_ref => g_proc_name);

 IF product_licensed('MAI') THEN

   FOR c1rec IN
    (SELECT * FROM WORK_ORDERS
     WHERE NOT EXISTS
     (SELECT 'z' FROM ROAD_SEGS
     WHERE rse_he_id=wor_rse_he_id_group)) LOOP
    g_error := c1rec.wor_works_order_no;

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'List of Work Orders without a valid Road'
                ,pi_pmci_details     => g_error);


    END LOOP;

    FOR c2rec IN
    (SELECT * FROM WORK_ORDERS
     WHERE wor_rse_he_id_group IS NULL) LOOP
    g_error := c2rec.wor_works_order_no;

        ----------------------------------------------------------
        -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
        ----------------------------------------------------------
        pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                ,pi_pmci_issue_label => 'List of Work Orders with No Road'
                ,pi_pmci_details     => g_error);


    END LOOP;
  END IF;
  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END check_wo;
--
-----------------------------------------------------------------------------
--




PROCEDURE check_INSP_INITIALS IS
--
---------------------------------------------------------------------------

  CURSOR c1 IS
  SELECT iit_peo_invent_by_id ,COUNT(*) item_count
  FROM INV_ITEMS_ALL
    WHERE iit_peo_invent_by_id NOT IN
   (SELECT hus_user_id FROM HIG_USERS)
   GROUP BY iit_peo_invent_by_id;

  l_dum NUMBER;
  l_count NUMBER := 0;


--
BEGIN

  g_proc_name := 'check_insp_initials';
  set_pmc_start(pi_pmc_ref => g_proc_name);

  FOR c1rec IN c1 LOOP

        g_error := 'Inspector ID '||c1rec.iit_peo_invent_by_id||' is unknown and is responsible for '||c1rec.item_count||' inventory items';

          ----------------------------------------------------------
          -- Insert details of failure into PRE_MIGRATION_CHK_ISSUES
          ----------------------------------------------------------
          pmci_ins(pi_pmci_pmc_ref     => g_proc_name
                  ,pi_pmci_issue_label => 'Unknown Inspectors'
                  ,pi_pmci_details     => g_error);

  END LOOP;



  -------------------------------------------------------------
  -- Update the outcome of the check in PRE_MIGRATION_CHK table
  ------------------------------------------------------------
  update_pmc_outcome(pi_pmc_ref     => g_proc_name
                    ,pi_pmc_notes   => NULL);

END;
--





END Pre_Migration_Check;
/
