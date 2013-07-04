CREATE OR REPLACE PACKAGE BODY nm3reports
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3reports.pkb-arc   2.2   Jul 04 2013 16:21:10   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3reports.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:10  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.3
-------------------------------------------------------------------------
--
--   Author : Sarah Scanlon
--
--   NM3REPORTS BODY
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

-----------
--constants
-----------
--g_body_sccsid is the SCCS ID for the package body
     g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
     g_package_name CONSTANT VARCHAR2 (30) := 'nm3reports';
   lf                     VARCHAR2 (1) := CHR (10);

--
-----------------------------------------------------------------------------
--
   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

--
-----------------------------------------------------------------------------
--
   PROCEDURE auton_commit
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      COMMIT;
   END auton_commit;

--
-----------------------------------------------------------------------------
--
   FUNCTION check_partial (
      pi_nm_ne_id_of IN nm_elements.ne_id%TYPE
     ,pi_nm_ne_id_in IN nm_elements.ne_id%TYPE)
      RETURN VARCHAR
   IS
      CURSOR c1 (
         cp_nm_ne_id_of IN nm_elements.ne_id%TYPE
        ,cp_nm_ne_id_in IN nm_elements.ne_id%TYPE)
      IS
         SELECT DECODE ((  nm3net.get_ne_length (nm_ne_id_of)
                         - (  nm_end_mp
                            - nm_begin_mp))
                       ,0, 'N'
                       ,'Y') AS partial
         FROM   nm_members
         WHERE  nm_ne_id_in = cp_nm_ne_id_in
         AND    nm_ne_id_of = cp_nm_ne_id_of;

      v_partial              VARCHAR2 (1);
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'check_partial');

      --
      OPEN c1 (pi_nm_ne_id_of, pi_nm_ne_id_in);

      FETCH c1
      INTO  v_partial;

      CLOSE c1;

      RETURN (v_partial);
      --
      nm_debug.proc_end (g_package_name, 'check_partial');
      --
   END check_partial;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_group_type (
      pi_job_id IN NUMBER)
      RETURN VARCHAR2
   IS
      l_group_type           VARCHAR2 (1) NULL;
   BEGIN
      --
      nm_debug.proc_start (g_package_name, 'get_group_type');
      --   
      SELECT DECODE (UPPER (grp_value)
                    ,'DATUM', 'S'
                    ,'GROUP', 'G'
                    ,'DISTANCE_BREAK', 'D')
      INTO   l_group_type
      FROM   gri_run_parameters
      WHERE  grp_job_id = pi_job_id
      AND    grp_param = 'ELEMENT_TYPE';

      IF l_group_type IS NULL THEN
         RETURN ('S');
      ELSE
         RETURN (l_group_type);
      END IF;
      --
      nm_debug.proc_end (g_package_name, 'get_group_type');
      --        
   END get_group_type;

--
-----------------------------------------------------------------------------
--
   PROCEDURE initialise_data (
      pi_module IN hig_modules.hmo_module%TYPE
     ,pi_job_id IN NUMBER)
   IS
--
-----------------------------------------------------------------------
--
      PROCEDURE initialise_nm150 (
         pi_job_id IN NUMBER)
      IS
         TYPE tab_nm0150 IS TABLE OF nm_nm0150%ROWTYPE
            INDEX BY BINARY_INTEGER;

         l_tab_nm0150           tab_nm0150;
         l_start_ne_id          nm_elements.ne_id%TYPE;
         l_element_type         nm_elements.ne_type%TYPE;
         l_sql                  nm3type.max_varchar2;

         --
         FUNCTION get_start_ne_id (
            pi_job_id IN NUMBER)
            RETURN NUMBER
         IS
            l_ne_id                NUMBER NULL;
         BEGIN
            SELECT grp_value
            INTO   l_ne_id
            FROM   gri_run_parameters
            WHERE  grp_job_id = pi_job_id
            AND    grp_param = 'REGION_OF_INTEREST';

            RETURN (l_ne_id);
         END get_start_ne_id;
      --
      BEGIN
         --
         l_start_ne_id := get_start_ne_id (pi_job_id);

         --
         IF l_start_ne_id IS NOT NULL THEN
            l_element_type := get_group_type (pi_job_id);
         ELSE
            --it's a datum and query below will not run
            l_element_type := 'S';
         END IF;

         --
         l_sql :=
               'SELECT nm_ne_id_of'
            || ' ,nm_begin_mp'
            || ' ,nm_end_mp'
            || ' ,nm_cardinality'
            || ' ,ne_unique'
            || ' ,ne_nt_type'
            || ' ,ne_descr'
            || ' ,ne_no_start'
            || ' ,ne_no_end';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' FROM   (SELECT nm_ne_id_in'
               || ' ,nm_ne_id_of'
               || ' ,nm_begin_mp'
               || ' ,nm_end_mp'
               || ' ,nm_cardinality'
               || ' ,nm_seq_no'
               || ' ,ne.*'
               || ' FROM   (SELECT     nm_ne_id_in'
               || ' ,nm_ne_id_of'
               || ' ,nm_begin_mp'
               || ' ,nm_end_mp'
               || ' ,nm_cardinality'
               || ' ,nm_seq_no';
         END IF;

         l_sql :=    l_sql
                  || ' FROM       nm_members';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in'
               || ' START WITH nm_ne_id_in = NVL ('
               || l_start_ne_id
               || ', nm_ne_id_in))';
         END IF;

         l_sql :=
               l_sql
            || ' ,nm_elements ne'
            || ' WHERE  nm_ne_id_of = ne_id'
            || ' AND    ne_type = '''
            || l_element_type
            || '''';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=    l_sql
                     || ')';
         END IF;

         --
         EXECUTE IMMEDIATE (l_sql)
         BULK COLLECT INTO l_tab_nm0150;

         --
         FORALL i IN 1 .. l_tab_nm0150.COUNT
            INSERT INTO nm_nm0150
                 VALUES l_tab_nm0150 (i);
      --
      END initialise_nm150;

--
-----------------------------------------------------------------------
--
      PROCEDURE initialise_nm151 (
         pi_job_id IN NUMBER)
      IS
         TYPE tab_nm0151 IS TABLE OF nm_nm0151%ROWTYPE
            INDEX BY BINARY_INTEGER;

         l_tab_nm0151           tab_nm0151;
         l_start_ne_id          nm_elements.ne_id%TYPE;
         l_element_type         nm_elements.ne_type%TYPE;
         l_sql                  nm3type.max_varchar2;

         --
         FUNCTION get_start_ne_id (
            pi_job_id IN NUMBER)
            RETURN NUMBER
         IS
            l_ne_id                NUMBER;
         BEGIN
            SELECT grp_value
            INTO   l_ne_id
            FROM   gri_run_parameters
            WHERE  grp_job_id = pi_job_id
            AND    grp_param = 'REGION_OF_INTEREST';

            RETURN (l_ne_id);
         END get_start_ne_id;
      --
      BEGIN
         --
         l_start_ne_id := get_start_ne_id (pi_job_id);

         --
         IF l_start_ne_id IS NOT NULL THEN
            l_element_type := get_group_type (pi_job_id);
         ELSE
            --it's a datum and query below will not run
            l_element_type := 'S';
         END IF;

         --
         l_sql :=
               'SELECT nm_ne_id_of'
            || ' ,nm_begin_mp'
            || ' ,nm_end_mp'
            || ' ,nm_cardinality'
            || ' ,ne_unique'
            || ' ,ne_nt_type'
            || ' ,ne_descr'
            || ' ,ne_no_start'
            || ' ,ne_no_end';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' FROM   (SELECT nm_ne_id_in'
               || ' ,nm_ne_id_of'
               || ' ,nm_begin_mp'
               || ' ,nm_end_mp'
               || ' ,nm_cardinality'
               || ' ,nm_seq_no'
               || ' ,ne.*'
               || ' FROM   (SELECT     nm_ne_id_in'
               || ' ,nm_ne_id_of'
               || ' ,nm_begin_mp'
               || ' ,nm_end_mp'
               || ' ,nm_cardinality'
               || ' ,nm_seq_no';
         END IF;

         l_sql :=    l_sql
                  || ' FROM       nm_members';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in'
               || ' START WITH nm_ne_id_in = '
               || l_start_ne_id
               || ')';
         END IF;

         l_sql :=
               l_sql
            || ' ,nm_elements ne'
            || ' WHERE  nm_ne_id_of = ne_id'
            || ' AND    ne_type = '''
            || l_element_type
            || '''';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=    l_sql
                     || ')';
         END IF;

         EXECUTE IMMEDIATE (l_sql)
         BULK COLLECT INTO l_tab_nm0151;

         --
         FORALL i IN 1 .. l_tab_nm0151.COUNT
            INSERT INTO nm_nm0151
                 VALUES l_tab_nm0151 (i);
      --
      END initialise_nm151;

--
-----------------------------------------------------------------------
--
      PROCEDURE initialise_nm153 (
         pi_job_id IN NUMBER)
      IS
         TYPE tab_nm0153 IS TABLE OF nm_nm0153%ROWTYPE
            INDEX BY BINARY_INTEGER;

         l_tab_nm0153           tab_nm0153;
         l_start_ne_id          nm_elements.ne_id%TYPE;
         l_start_ne_type        nm_elements.ne_type%TYPE;
         l_order_by             nm3type.max_varchar2;
         l_sql                  nm3type.max_varchar2;

         --
         FUNCTION get_start_ne_id (
            pi_job_id IN NUMBER)
            RETURN NUMBER
         IS
            l_ne_id                NUMBER;
         BEGIN
            SELECT grp_value
            INTO   l_ne_id
            FROM   gri_run_parameters
            WHERE  grp_job_id = pi_job_id
            AND    grp_param = 'REGION_OF_INTEREST';

            RETURN (l_ne_id);
         END get_start_ne_id;
      --
      BEGIN
         l_start_ne_id := get_start_ne_id (pi_job_id);

         IF l_start_ne_id IS NOT NULL THEN
            SELECT ne_type
            INTO   l_start_ne_type
            FROM   nm_elements
            WHERE  ne_id = l_start_ne_id;
         END IF;

         --
         l_sql :=
               'SELECT nm_ne_id_of,'
            || ' nm_begin_mp,'
            || ' nm_end_mp,'
            || ' nm_cardinality,'
            || ' ne_unique,'
            || ' ne_nt_type,'
            || ' ne_descr,'
            || ' ne_no_start,'
            || ' ne_no_end';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' FROM (SELECT nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp,'
               || ' nm_cardinality, nm_seq_no, ne.*'
               || ' FROM (SELECT     nm_ne_id_in, nm_ne_id_of, nm_begin_mp,'
               || ' nm_end_mp, nm_cardinality, nm_seq_no';
         END IF;

         l_sql :=    l_sql
                  || ' FROM nm_members';

         IF     l_start_ne_type != 'G'
            AND l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in'
               || ' START WITH nm_ne_id_in ='
               || l_start_ne_id;
         END IF;

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=    l_sql
                     || ' )';
         END IF;

         l_sql :=    l_sql
                  || ' ,nm_elements ne'
                  || ' WHERE nm_ne_id_of = ne_id';

         IF l_start_ne_type = 'G' THEN
            l_sql :=    l_sql
                     || ' AND ne_id = '
                     || l_start_ne_id
                     || ')';
         ELSE
            l_sql :=    l_sql
                     || ' AND ne_type = ''G''';
         END IF;

         IF     l_start_ne_type IS NOT NULL
            AND l_start_ne_type != 'G' THEN
            l_sql :=    l_sql
                     || ')';
         END IF;

         EXECUTE IMMEDIATE (l_sql)
         BULK COLLECT INTO l_tab_nm0153;

         FORALL i IN 1 .. l_tab_nm0153.COUNT
            INSERT INTO nm_nm0153
                 VALUES l_tab_nm0153 (i);
      END initialise_nm153;

--
-----------------------------------------------------------------------
--
      PROCEDURE initialise_nm154 (
         pi_job_id IN NUMBER)
      IS
         TYPE tab_nm0154 IS TABLE OF nm_nm0154%ROWTYPE
            INDEX BY BINARY_INTEGER;

         l_tab_nm0154           tab_nm0154;
         l_start_ne_id          nm_elements.ne_id%TYPE;
         l_start_ne_type        nm_elements.ne_type%TYPE;
         l_order_by             nm3type.max_varchar2;
         l_sql                  nm3type.max_varchar2;

         --
         FUNCTION get_start_ne_id (
            pi_job_id IN NUMBER)
            RETURN NUMBER
         IS
            l_ne_id                NUMBER;
         BEGIN
            SELECT grp_value
            INTO   l_ne_id
            FROM   gri_run_parameters
            WHERE  grp_job_id = pi_job_id
            AND    grp_param = 'REGION_OF_INTEREST';

            RETURN (l_ne_id);
         END get_start_ne_id;
      --
      BEGIN
         l_start_ne_id := get_start_ne_id (pi_job_id);

         if l_start_ne_id is not null then
         SELECT ne_type
         INTO   l_start_ne_type
         FROM   nm_elements
         WHERE  ne_id = l_start_ne_id;
         end if;

         --
         l_sql :=
               'select ne_id, ne_unique'
            || ' , ne_descr'
            || ' , nm3net.get_ne_length(ne_id)'
            || ' , to_number(nm3net.get_max_slk(ne_id),9999.9999)'
            || ' , nm_ne_id_in, nm_ne_id_of, ne_type';

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' FROM (SELECT nm_ne_id_in, nm_ne_id_of, nm_begin_mp, nm_end_mp,'
               || ' nm_cardinality, nm_seq_no, ne.*'
               || ' FROM (SELECT     nm_ne_id_in, nm_ne_id_of, nm_begin_mp,'
               || ' nm_end_mp, nm_cardinality, nm_seq_no';
         END IF;

         l_sql :=    l_sql
                  || ' FROM nm_members';

         IF     l_start_ne_type != 'G'
            AND l_start_ne_id IS NOT NULL THEN
            l_sql :=
                  l_sql
               || ' CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in'
               || ' START WITH nm_ne_id_in = '
               || l_start_ne_id;
         END IF;

         IF l_start_ne_id IS NOT NULL THEN
            l_sql :=    l_sql
                     || ' )';
         END IF;

         l_sql :=    l_sql
                  || ' ,nm_elements ne'
                  || ' WHERE nm_ne_id_of = ne_id';

         IF l_start_ne_type = 'G' THEN
            l_sql :=    l_sql
                     || ' AND ne_id = '
                     || l_start_ne_id
                     || ')';
         ELSE
            l_sql :=    l_sql
                     || ' AND ne_type in (''G'',''P'')';
         END IF;

         IF     l_start_ne_type IS NOT NULL
            AND l_start_ne_type != 'G' THEN
            l_sql :=    l_sql
                     || ')';
         END IF;

         nm_debug.debug_on;
         nm_debug.DEBUG (l_sql);         
         
         EXECUTE IMMEDIATE (l_sql)
         BULK COLLECT INTO l_tab_nm0154;

         FORALL i IN 1 .. l_tab_nm0154.COUNT
            INSERT INTO nm_nm0154
                 VALUES l_tab_nm0154 (i);
      END initialise_nm154;
--
-----------------------------------------------------------------------
--
   BEGIN
--
      nm_debug.proc_start (g_package_name, 'initialise_data');

--
      IF pi_module = 'NM0150' THEN
         initialise_nm150 (pi_job_id);
      ELSIF pi_module = 'NM0151' THEN
         initialise_nm151 (pi_job_id);
      ELSIF pi_module = 'NM0153' THEN
         initialise_nm153 (pi_job_id);
      ELSIF pi_module = 'NM0154' THEN
         initialise_nm154 (pi_job_id);
      ELSE
         NULL;
      END IF;

--
      nm_debug.proc_end (g_package_name, 'initialise_data');
--
   END initialise_data;
END nm3reports;
/
