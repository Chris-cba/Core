create or replace package body nm3mrg_supplementary as
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg_supplementary.pkb-arc   2.3   Jul 04 2013 16:16:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3mrg_supplementary.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:16:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:16  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.16
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   nm3mrg Supplementary Package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.3  $';
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3mrg_supplementary';
--
   c_nvl    CONSTANT varchar2(30) := nm3type.c_nvl;
--
   g_matching_loc VARCHAR2(32767);
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_results_by_value_id (pi_nmq_id        IN     nm_mrg_query_results.nqr_nmq_id%TYPE
                                  ,pi_job_id        IN     nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                  ,pi_value_id      IN     nm_mrg_section_inv_values.nsv_value_id%TYPE
                                  ,po_tab_scrn_text    OUT nm3type.tab_varchar2000
                                  ,po_tab_value        OUT nm3type.tab_varchar2000
                                  ) IS
--
   CURSOR cs_nsv (p_job_id number
                 ,p_val_id number
                 ) IS
   SELECT *
    FROM  nm_mrg_section_inv_values
   WHERE  nsv_mrg_job_id = p_job_id
    AND   nsv_value_id   = p_val_id;
--
   CURSOR cs_nqt (p_nmq_id   number
                 ,p_inv_type varchar2
                 ,p_x_sect   varchar2
                 ,p_nvl      varchar2 DEFAULT nm3type.c_nvl
                 ) IS
   SELECT *
    FROM  nm_mrg_query_types
   WHERE  nqt_nmq_id            = p_nmq_id
    AND   nqt_inv_type          = p_inv_type
    AND   NVL(nqt_x_sect,p_nvl) = NVL(p_x_sect,p_nvl);
--
   l_rec_nqt  nm_mrg_query_types%ROWTYPE;
--
   l_count binary_integer := 0;
--
   l_found_some boolean := FALSE;
--
   l_val        varchar2(2000);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_results_by_value_id');
--
   IF  pi_nmq_id   IS NULL
    OR pi_job_id   IS NULL
    OR pi_value_id IS NULL
    THEN
      nm_debug.proc_end(g_package_name,'get_results_by_value_id');
      RETURN;
   END IF;
--
   OPEN  cs_nsv (pi_job_id, pi_value_id);
   FETCH cs_nsv INTO g_rec_nsv;
   IF cs_nsv%NOTFOUND
    THEN
      CLOSE cs_nsv;
      nm3mrg.g_mrg_exc_code := -20913;
      nm3mrg.g_mrg_exc_msg  := 'Values record not found';
      RAISE nm3mrg.g_mrg_exception;
   END IF;
   CLOSE cs_nsv;
--
   OPEN  cs_nqt  (pi_nmq_id, g_rec_nsv.nsv_inv_type, g_rec_nsv.nsv_x_sect);
   FETCH cs_nqt INTO l_rec_nqt;
   IF   cs_nqt%NOTFOUND
    AND g_rec_nsv.nsv_x_sect IS NOT NULL
    THEN
      -- Not found with the actual XSP, so have a look for one with null (i.e. query run over all XSP)
      CLOSE cs_nqt;
      OPEN  cs_nqt  (pi_nmq_id, g_rec_nsv.nsv_inv_type, NULL);
      FETCH cs_nqt INTO l_rec_nqt;
   END IF;
   IF cs_nqt%NOTFOUND
    THEN
      CLOSE cs_nqt;
      nm3mrg.g_mrg_exc_code := -20914;
      nm3mrg.g_mrg_exc_msg  := 'NM_MRG_QUERY_TYPES record not found';
      RAISE nm3mrg.g_mrg_exception;
   END IF;
   CLOSE cs_nqt;
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_mrg_query_attribs
                  WHERE  nqa_nmq_id = pi_nmq_id
                  ORDER BY 1,2,3
                 )
    LOOP
--
      l_count := l_count + 1;
--
      IF cs_rec.nqa_nqt_seq_no = l_rec_nqt.nqt_seq_no
       THEN
--
         l_found_some := TRUE;
--
         po_tab_scrn_text(po_tab_scrn_text.COUNT+1) := nm3inv.get_inv_type_attr(g_rec_nsv.nsv_inv_type
                                                                               ,cs_rec.nqa_attrib_name
                                                                               ).ita_scrn_text;
         po_tab_value(po_tab_value.COUNT+1)         := get_val_from_rec_nsv (l_count);
--
      ELSIF l_found_some
       THEN
         -- We've done some but aren't doing this one. Therefore we've finished given that the data is ordered
         EXIT;
      END IF;
--
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_results_by_value_id');
--
EXCEPTION
--
   WHEN nm3mrg.g_mrg_exception
    THEN
      Raise_Application_Error(nm3mrg.g_mrg_exc_code,nm3mrg.g_mrg_exc_msg);
--
END get_results_by_value_id;
--
------------------------------------------------------------------------------------------------
--
FUNCTION select_nqr (pi_job_id IN nm_mrg_query_results.nqr_mrg_job_id%TYPE) RETURN nm_mrg_query_results%ROWTYPE IS
--
   CURSOR cs_nqr (c_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE) IS
   SELECT *
    FROM  nm_mrg_query_results
   WHERE  nqr_mrg_job_id = c_job_id;
--
   l_rec_nqr nm_mrg_query_results%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nqr (pi_job_id);
   FETCH cs_nqr INTO l_rec_nqr;
   CLOSE cs_nqr;
--
   RETURN l_rec_nqr;
--
END select_nqr;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_invalid_mrg_qry_defaults RETURN nm3type.tab_number IS
--
   CURSOR cs_inv IS
   SELECT ndq_seq_no
    FROM  nm_mrg_default_query_types
   WHERE NOT EXISTS (SELECT 1
                      FROM  nm_mrg_default_query_attribs
                     WHERE  ndq_seq_no = nda_seq_no
                    );
--
   l_retval nm3type.tab_number;
--
BEGIN
--
   OPEN  cs_inv;
   FETCH cs_inv BULK COLLECT INTO l_retval;
   CLOSE cs_inv;
--
   RETURN l_retval;
--
END get_invalid_mrg_qry_defaults;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_ndq(pi_ndq_seq_no IN nm_mrg_default_query_types.ndq_seq_no%TYPE
                ) RETURN nm_mrg_default_query_types%ROWTYPE IS
--
  CURSOR c_ndq(p_ndq_seq_no IN nm_mrg_default_query_types.ndq_seq_no%TYPE) IS
    SELECT *
     FROM  nm_mrg_default_query_types ndq
    WHERE  ndq.ndq_seq_no = p_ndq_seq_no;
--
   l_retval nm_mrg_default_query_types%ROWTYPE;
--
BEGIN
--
   OPEN  c_ndq(p_ndq_seq_no => pi_ndq_seq_no);
   FETCH c_ndq INTO l_retval;
   IF c_ndq%NOTFOUND
    THEN
      CLOSE c_ndq;
      nm3mrg.g_mrg_exc_code := -20915;
      nm3mrg.g_mrg_exc_msg  := 'NM_MRG_DEFAULT_QUERY_TYPES record not found';
      RAISE nm3mrg.g_mrg_exception;
   END IF;
   CLOSE c_ndq;
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN nm3mrg.g_mrg_exception
    THEN
      Raise_Application_Error(nm3mrg.g_mrg_exc_code,nm3mrg.g_mrg_exc_msg);
--
END get_ndq;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_nmq_id_from_unique (p_nmq_unique nm_mrg_query.nmq_unique%TYPE
                                ) RETURN nm_mrg_query.nmq_id%TYPE IS
--
   CURSOR cs_nmq (p_unique nm_mrg_query.nmq_unique%TYPE) IS
   SELECT nmq_id
    FROM  nm_mrg_query
   WHERE  nmq_unique = p_unique;
--
   l_nmq_id nm_mrg_query.nmq_id%TYPE;
--
BEGIN
--
   OPEN  cs_nmq (p_nmq_unique);
   FETCH cs_nmq INTO l_nmq_id;
--
   IF cs_nmq%NOTFOUND
    THEN
      CLOSE cs_nmq;
      nm3mrg.g_mrg_exc_code := -20901;
      nm3mrg.g_mrg_exc_msg  := 'Query not found';
      RAISE nm3mrg.g_mrg_exception;
   END IF;
--
   CLOSE cs_nmq;
--
   RETURN l_nmq_id;
--
EXCEPTION
--
   WHEN nm3mrg.g_mrg_exception
    THEN
      Raise_Application_Error(nm3mrg.g_mrg_exc_code,nm3mrg.g_mrg_exc_msg);
--
END get_nmq_id_from_unique;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_mrg_section (p_mrg_job_id     IN nm_mrg_sections.nms_mrg_job_id%TYPE
                         ,p_mrg_section_id IN nm_mrg_sections.nms_mrg_section_id%TYPE
                         ) RETURN nm_mrg_sections%ROWTYPE IS
--
   CURSOR cs_nms (p_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE
                 ,p_section_id nm_mrg_sections.nms_mrg_section_id%TYPE
                 ) IS
   SELECT *
    FROM  nm_mrg_sections
   WHERE  nms_mrg_job_id     = p_job_id
    AND   nms_mrg_section_id = p_section_id;
--
   l_rec_nms nm_mrg_sections%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nms (p_mrg_job_id, p_mrg_section_id);
   FETCH cs_nms INTO l_rec_nms;
   IF cs_nms%NOTFOUND
    THEN
      CLOSE cs_nms;
      Raise_Application_Error(-20910,'NM_MRG_SECTIONS record not found - '||p_mrg_job_id||':'||p_mrg_section_id);
   END IF;
   CLOSE cs_nms;
--
   RETURN l_rec_nms;
--
END get_mrg_section;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_parent_ne_id_from_temp (p_ne_id IN number) RETURN number IS
--
   CURSOR cs_parent (p_ne_id nm_mrg_members.nm_ne_id_of%TYPE) IS
   SELECT route_ne_id
    FROM  nm_mrg_members
   WHERE  nm_ne_id_of = p_ne_id;
--
   l_retval number := -1;
--
BEGIN
--
   OPEN  cs_parent (p_ne_id);
   FETCH cs_parent INTO l_retval;
   CLOSE cs_parent;
--
   RETURN l_retval;
--
END get_parent_ne_id_from_temp;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE create_remove_transient_job (p_first_run DATE     DEFAULT TRUNC(SYSDATE+1)
                                      ,p_next_run  varchar2 DEFAULT 'trunc(sysdate)+1'
                                      ) IS
--
   CURSOR cs_job (p_what user_jobs.what%TYPE) IS
   SELECT job
    FROM  user_jobs
   WHERE  UPPER(what) = UPPER(p_what);
--
   l_existing_job_id user_jobs.job%TYPE;
--
   l_job_id      binary_integer;
--
   l_job_command CONSTANT varchar2(32) := 'nm3mrg.remove_transient_results;';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_remove_transient_job');
--
   OPEN  cs_job (l_job_command);
   FETCH cs_job INTO l_existing_job_id;
   IF cs_job%FOUND
    THEN
      CLOSE cs_job;
      Raise_Application_Error(-20001,'Such a job already exists - JOB_ID : '||l_existing_job_id);
   END IF;
   CLOSE cs_job;
--
   dbms_job.submit
       (job       => l_job_id
       ,what      => l_job_command
       ,next_date => p_first_run
       ,interval  => p_next_run
       );
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'create_remove_transient_job');
--
END create_remove_transient_job;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE remove_transient_results IS
--
   CURSOR cs_transient_queries IS
   SELECT nmq_id
         ,nmq_unique
    FROM  nm_mrg_query
   WHERE  nmq_transient_query = 'Y';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'remove_transient_results');
--
   FOR cs_rec IN cs_transient_queries
    LOOP
--
      -- nm_debug.debug('Removing results for : '||cs_rec.nmq_unique);
--
      -- Delete the results
      DELETE FROM nm_mrg_query_results
      WHERE  nqr_nmq_id = cs_rec.nmq_id;
      -- Refresh the snapshot (so there are now no rows in it)
      nm3mrg_view.refresh_merge_results_snapshot(cs_rec.nmq_id);
--
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'remove_transient_results');
--
END remove_transient_results;
--
------------------------------------------------------------------------------------------------
--
FUNCTION defaults_exist RETURN boolean IS

  CURSOR c1 IS
    SELECT
      1
    FROM
      nm_mrg_default_query_types;

  l_dummy pls_integer;
  l_retval boolean;

BEGIN
  OPEN c1;
    FETCH c1 INTO l_dummy;
    IF c1%FOUND
    THEN
      l_retval := TRUE;
    ELSE
      l_retval := FALSE;
    END IF;
  CLOSE c1;

  RETURN l_retval;
END defaults_exist;
--
------------------------------------------------------------------------------------------------
--
FUNCTION defaults_in_query(pi_query_id IN nm_mrg_query.nmq_id%TYPE
                          ) RETURN boolean IS
--
   CURSOR cs_defaults_exist (p_query_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT 'x'
    FROM  nm_mrg_query_types
   WHERE  nqt_nmq_id  = p_query_id
    AND   nqt_default = 'Y';
--
   l_dummy varchar2(1);
--
   l_retval boolean;
--
BEGIN
--
   OPEN  cs_defaults_exist (pi_query_id);
   FETCH cs_defaults_exist INTO l_dummy;
   IF cs_defaults_exist%FOUND
    THEN
      l_retval := TRUE;
   ELSE
      l_retval := FALSE;
   END IF;
   CLOSE cs_defaults_exist;
--
   RETURN l_retval;
--
END defaults_in_query;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE add_defaults (pi_query_id IN nm_mrg_query.nmq_id%TYPE) IS
--
   l_rec_nmq nm_mrg_query%ROWTYPE;
--
   CURSOR cs_defaults_exist (p_query_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT 'x'
    FROM  nm_mrg_query_types
   WHERE  nqt_nmq_id  = p_query_id
    AND   nqt_default = 'Y';
--
   l_dummy varchar2(1);
--
BEGIN
--
   l_rec_nmq := select_mrg_query (pi_query_id);
--
   OPEN  cs_defaults_exist (pi_query_id);
   FETCH cs_defaults_exist INTO l_dummy;
   IF cs_defaults_exist%FOUND
    THEN
      CLOSE cs_defaults_exist;
      nm3mrg.g_mrg_exc_code := -20911;
      nm3mrg.g_mrg_exc_msg  := 'Query already has defaults. Use REFRESH_DEFAULTS procedure';
      RAISE nm3mrg.g_mrg_exception;
   END IF;
   CLOSE cs_defaults_exist;
--
   INSERT INTO nm_mrg_query_types
          (nqt_nmq_id
          ,nqt_seq_no
          ,nqt_inv_type
          ,nqt_x_sect
          ,nqt_default
          )
   SELECT  pi_query_id
          ,ndq_seq_no
          ,ndq_inv_type
          ,ndq_x_sect
          ,'Y'
     FROM  nm_mrg_default_query_types;
--
   INSERT INTO nm_mrg_query_attribs
          (nqa_nmq_id
          ,nqa_nqt_seq_no
          ,nqa_attrib_name
          ,nqa_itb_banding_id
          )
   SELECT  pi_query_id
          ,nda_seq_no
          ,nda_attrib_name
          ,nda_itb_banding_id
     FROM  nm_mrg_default_query_attribs;
--
EXCEPTION
   WHEN nm3mrg.g_mrg_exception
    THEN
      Raise_Application_Error(nm3mrg.g_mrg_exc_code, nm3mrg.g_mrg_exc_msg);
END add_defaults;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE refresh_defaults (pi_query_id IN nm_mrg_query.nmq_id%TYPE) IS
--
BEGIN
--
-- Delete the NM_MRG_QUERY_TYPES for the defaults and the NM_MRG_QUERY_ATTRIBS will be deleted
--  by the cascade delete
--
   DELETE FROM nm_mrg_query_types
    WHERE nqt_nmq_id  = pi_query_id
     AND  nqt_default = 'Y';
--
   add_defaults (pi_query_id);
--
END refresh_defaults;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE refresh_all_defaults IS
BEGIN
--
   FOR cs_rec IN (SELECT nmq_id
                   FROM  nm_mrg_query
                 )
    LOOP
      refresh_defaults (cs_rec.nmq_id);
   END LOOP;
--
END refresh_all_defaults;
--
------------------------------------------------------------------------------------------------
--
FUNCTION select_mrg_query (pi_query_id IN nm_mrg_query.nmq_id%TYPE) RETURN nm_mrg_query%ROWTYPE IS
--
   CURSOR cs_query (p_query_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT *
    FROM  nm_mrg_query
   WHERE  nmq_id = p_query_id;
--
   l_rec_nmq nm_mrg_query%ROWTYPE;
--
BEGIN
--
   OPEN  cs_query (pi_query_id);
   FETCH cs_query INTO l_rec_nmq;
--
   IF cs_query%NOTFOUND
    THEN
      CLOSE cs_query;
      nm3mrg.g_mrg_exc_code := -20901;
      nm3mrg.g_mrg_exc_msg  := 'Query not found';
      RAISE nm3mrg.g_mrg_exception;
   END IF;
--
   CLOSE cs_query;
--
   RETURN l_rec_nmq;
--
EXCEPTION
--
   WHEN nm3mrg.g_mrg_exception
    THEN
      Raise_Application_Error(nm3mrg.g_mrg_exc_code,nm3mrg.g_mrg_exc_msg);
--
END select_mrg_query;
--
------------------------------------------------------------------------------------------------
--
FUNCTION count_query_results (p_nmq_id IN number) RETURN number IS
--
   CURSOR cs_run_results (p_query_id number) IS
   SELECT COUNT(*)
    FROM  nm_mrg_query_results
   WHERE  nqr_nmq_id = p_query_id;
--
   l_retval number;
--
BEGIN
--
   OPEN  cs_run_results (p_nmq_id);
   FETCH cs_run_results INTO l_retval;
   CLOSE cs_run_results;
--
   RETURN l_retval;
--
END count_query_results;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE delete_query_results (p_nmq_id IN number) IS
--
   CURSOR cs_run_results (p_query_id number) IS
   SELECT nqr_mrg_job_id
    FROM  nm_mrg_query_results
   WHERE  nqr_nmq_id = p_query_id
   FOR UPDATE OF nqr_mrg_job_id NOWAIT;
--
   record_already_locked EXCEPTION;
   PRAGMA EXCEPTION_INIT (record_already_locked,-54);
--
BEGIN
--
   FOR cs_rec IN cs_run_results (p_nmq_id)
    LOOP
      DELETE FROM nm_mrg_query_results
      WHERE CURRENT OF cs_run_results;
   END LOOP;
--
EXCEPTION
--
   WHEN record_already_locked
    THEN
      Raise_Application_Error(-20912,'Another user has a nm_mrg_query_results record locked');
--
END delete_query_results;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmq_id RETURN number IS
--
   CURSOR cs_nextval IS
   SELECT nmq_id_seq.NEXTVAL
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
END get_nmq_id;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_nmqv_id RETURN number IS
--
   CURSOR cs_nextval IS
   SELECT nm_mrg_query_values_seq.NEXTVAL
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
END get_nmqv_id;
--
------------------------------------------------------------------------------------------------
--
FUNCTION fn_get_element_length (pi_ne_id IN nm_mrg_members.nm_ne_id_of%TYPE
                               ) RETURN nm_mrg_members.element_length%TYPE IS
--
   CURSOR cs_element_len (p_ne_id nm_mrg_members.nm_ne_id_of%TYPE) IS
   SELECT element_length
    FROM  nm_mrg_members
   WHERE  nm_ne_id_of = p_ne_id;
--
   l_retval nm_mrg_members.element_length%TYPE := -1;
--
BEGIN
--
   OPEN  cs_element_len (pi_ne_id);
   FETCH cs_element_len INTO l_retval;
   CLOSE cs_element_len;
--
   RETURN l_retval;
--
END fn_get_element_length;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE validate_data IS
--
   l_found_attribs         boolean;
   l_matching_values_count number;
--
BEGIN
--
   FOR l_count IN 1..nm3mrg.g_tab_rec_query_types.COUNT
    LOOP
      --
      -- For each INV_TYPE
      --
      l_found_attribs := FALSE;
--
      FOR l_count2 IN 1..nm3mrg.g_tab_rec_query_attribs.COUNT
       LOOP
--
         IF nm3mrg.g_tab_rec_query_attribs(l_count2).nqa_nqt_seq_no = nm3mrg.g_tab_rec_query_types(l_count).nqt_seq_no
          THEN
            --
            -- If we've found a NM_MRG_QUERY_ATTRIBS record to match
            --
            l_found_attribs := TRUE;
            --
            -- If there's a condition then Validate it
            --
            IF nm3mrg.g_tab_rec_query_attribs(l_count2).nqa_condition IS NOT NULL
             THEN
               --
               l_matching_values_count := 0;
--
               FOR l_count3 IN 1..nm3mrg.g_tab_rec_query_values.COUNT
                LOOP
--
                  IF   nm3mrg.g_tab_rec_query_values(l_count3).nqv_nqt_seq_no  = nm3mrg.g_tab_rec_query_types(l_count).nqt_seq_no
                   AND nm3mrg.g_tab_rec_query_values(l_count3).nqv_attrib_name = nm3mrg.g_tab_rec_query_attribs(l_count2).nqa_attrib_name
                   THEN
                     --
                     -- If this is for the correct attribute
                     --
                     l_matching_values_count := l_matching_values_count + 1;
--
                  END IF;
--
               END LOOP;
--
               IF NOT valid_pbi_condition_values (nm3mrg.g_tab_rec_query_attribs(l_count2).nqa_condition
                                                 ,l_matching_values_count
                                                 )
                THEN
                  nm3mrg.g_mrg_exc_code := -20904;
                  nm3mrg.g_mrg_exc_msg  := 'NM_MRG_QUERY_ATTRIBS has condition but invalid number of NM_MRG_QUERY_VALUES defined';
                  RAISE nm3mrg.g_mrg_exception;
               END IF;
--
            END IF;
--
         END IF;
--
      END LOOP;
--
      IF NOT l_found_attribs
       THEN
         nm3mrg.g_mrg_exc_code := -20905;
         nm3mrg.g_mrg_exc_msg  := 'NM_MRG_QUERY_TYPES has no NM_MRG_QUERY_ATTRIBS defined';
         RAISE nm3mrg.g_mrg_exception;
      END IF;
--
   END LOOP;
--
END validate_data;
--
------------------------------------------------------------------------------------------------
--
FUNCTION valid_pbi_condition_values (pi_condition    IN varchar2
                                    ,pi_values_count IN number
                                    ) RETURN boolean IS
--
   l_retval boolean := FALSE;
   l_count  PLS_INTEGER;
--
BEGIN
--
   l_count  :=  get_pbi_condition_value_count (pi_condition);
   l_retval :=  (l_count    =  pi_values_count
                 OR (l_count IS NULL
                     AND pi_values_count > 0
                    )
                );
--
   RETURN l_retval;
--
END valid_pbi_condition_values;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_pbi_condition_value_count (pi_condition    IN varchar2
                                       ) RETURN PLS_INTEGER IS
   l_retval PLS_INTEGER;
   l_found  BOOLEAN := FALSE;
BEGIN
--
   FOR l_counter IN 1..nm3mrg.g_tab_pbi_conditions.COUNT
    LOOP
      IF nm3mrg.g_tab_pbi_conditions(l_counter) = pi_condition
       THEN
         l_retval := nm3mrg.g_tab_pbi_cond_values_reqd(l_counter);
         l_found  := TRUE;
         EXIT;
      END IF;
   END LOOP;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 305
                    ,pi_supplementary_info => pi_condition
                    );
   END IF;
--
   RETURN l_retval;
--
END get_pbi_condition_value_count;
--
------------------------------------------------------------------------------------------------
--
FUNCTION build_value_list(pi_condition   IN nm_mrg_query_attribs.nqa_condition%TYPE
                         ,pi_seq_no      IN nm_mrg_query_attribs.nqa_nqt_seq_no%TYPE
                         ,pi_attrib_name IN nm_mrg_query_attribs.nqa_attrib_name%TYPE
                         ,pi_format      IN nm_inv_type_attribs.ita_format%TYPE
                         ) RETURN long IS
--
   l_in      boolean := INSTR(pi_condition,'IN',1,1)      <> 0;
   l_between boolean := INSTR(pi_condition,'BETWEEN',1,1) <> 0;
--
   l_retval  long;
--
BEGIN
--
   l_retval := NULL;
--
   IF l_in
    THEN
      l_retval := l_retval||'(';
   END IF;
--
   FOR l_counter IN 1..nm3mrg.g_tab_rec_query_values.COUNT
    LOOP
--
      IF   pi_seq_no      = nm3mrg.g_tab_rec_query_values(l_counter).nqv_nqt_seq_no
       AND pi_attrib_name = nm3mrg.g_tab_rec_query_values(l_counter).nqv_attrib_name
       THEN
--
         IF    l_between AND nm3mrg.g_tab_rec_query_values(l_counter).nqv_sequence <> 1
          THEN
--
            l_retval := l_retval||' AND ';
--
         ELSIF l_in      AND nm3mrg.g_tab_rec_query_values(l_counter).nqv_sequence <> 1
          THEN
--
            l_retval := l_retval||',';
--
         END IF;
--
      IF nm3gaz_qry.get_ignore_case THEN
         l_retval := l_retval||'upper('||nm3pbi.fn_convert_attrib_value(nm3mrg.g_tab_rec_query_values(l_counter).nqv_value
                                                             ,pi_format
                                                             ) ||')';
      ELSE
         l_retval := l_retval||nm3pbi.fn_convert_attrib_value(nm3mrg.g_tab_rec_query_values(l_counter).nqv_value
                                                             ,pi_format
                                                             );
      END IF;
--
      END IF;
--
   END LOOP;
--
   IF l_in
    THEN
      l_retval := l_retval||')';
   END IF;
--
   RETURN l_retval;
--
END build_value_list;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_tab_column_details (pi_table_name  IN user_tab_columns.table_name%TYPE
                                ,pi_column_name IN user_tab_columns.column_name%TYPE
                                ) RETURN user_tab_columns%ROWTYPE IS
--
   CURSOR cs_utc (p_table_name  user_tab_columns.table_name%TYPE
                 ,p_column_name user_tab_columns.column_name%TYPE
                 ) IS
   SELECT *
    FROM  user_tab_columns
   WHERE  table_name  = p_table_name
    AND   column_name = p_column_name;
--
   l_rec_utc user_tab_columns%ROWTYPE;
--
BEGIN
--
   OPEN  cs_utc (pi_table_name, pi_column_name);
   FETCH cs_utc INTO l_rec_utc;
--
   IF cs_utc%NOTFOUND
    THEN
      CLOSE cs_utc;
      Raise_Application_Error(-20001,pi_table_name||'.'||pi_column_name||' does not exist');
   END IF;
--
   CLOSE cs_utc;
--
   RETURN l_rec_utc;
--
END get_tab_column_details;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_nm_mrg_sections (pi_job_id         IN nm_mrg_sections.nms_mrg_job_id%TYPE
                              ,pi_mrg_section_id IN nm_mrg_sections.nms_mrg_section_id%TYPE
                              ,pi_nte_job_id     IN nm_mrg_sections.nms_offset_ne_id%TYPE
                              ,pi_ne_id_first    IN nm_mrg_sections.nms_ne_id_first%TYPE
                              ,pi_begin_mp_first IN nm_mrg_sections.nms_begin_mp_first%TYPE
                              ,pi_ne_id_last     IN nm_mrg_sections.nms_ne_id_last%TYPE
                              ,pi_end_mp_last    IN nm_mrg_sections.nms_end_mp_last%TYPE
                              ,pi_orig_sect_id   IN nm_mrg_sections.nms_orig_sect_id%TYPE
                              ,pi_in_results     IN nm_mrg_sections.nms_in_results%TYPE DEFAULT 'N'
                              ) IS
--
BEGIN
--
-- Create nm_mrg_sections records with begin_offset and end_offset of -1, this will be updated later.
--  The purpose of this is to save working out the offsets for rows which we will later delete because
--  of a possible inner join
--
   INSERT INTO nm_mrg_sections
               (nms_mrg_job_id
               ,nms_mrg_section_id
               ,nms_offset_ne_id
               ,nms_begin_offset
               ,nms_end_offset
               ,nms_ne_id_first
               ,nms_begin_mp_first
               ,nms_ne_id_last
               ,nms_end_mp_last
               ,nms_orig_sect_id
               ,nms_in_results
               )
   VALUES      (pi_job_id
               ,pi_mrg_section_id
               ,-1 --pi_nte_job_id
               ,-1
               ,-1
               ,pi_ne_id_first
               ,pi_begin_mp_first
               ,pi_ne_id_last
               ,pi_end_mp_last
               ,pi_orig_sect_id
               ,pi_in_results
               );
--
END ins_nm_mrg_sections;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_nm_mrg_section_members (pi_tab_rec_nsm    IN nm3mrg.tab_mrg_sect_members) IS
--
   l_tab_mrg_job_id     nm3type.tab_number;
   l_tab_mrg_section_id nm3type.tab_number;
   l_tab_ne_id          nm3type.tab_number;
   l_tab_begin_mp       nm3type.tab_number;
   l_tab_end_mp         nm3type.tab_number;
   l_tab_measure        nm3type.tab_number;
--
BEGIN
--
   FOR i IN 1..pi_tab_rec_nsm.COUNT
    LOOP
      l_tab_mrg_job_id(i)     := pi_tab_rec_nsm(i).nsm_mrg_job_id;
      l_tab_mrg_section_id(i) := pi_tab_rec_nsm(i).nsm_mrg_section_id;
      l_tab_ne_id(i)          := pi_tab_rec_nsm(i).nsm_ne_id;
      l_tab_begin_mp(i)       := pi_tab_rec_nsm(i).nsm_begin_mp;
      l_tab_end_mp(i)         := pi_tab_rec_nsm(i).nsm_end_mp;
      l_tab_measure(i)        := pi_tab_rec_nsm(i).nsm_measure;
   END LOOP;
--
   ins_nm_mrg_section_members (pi_mrg_job_id     => l_tab_mrg_job_id
                              ,pi_mrg_section_id => l_tab_mrg_section_id
                              ,pi_ne_id          => l_tab_ne_id
                              ,pi_begin_mp       => l_tab_begin_mp
                              ,pi_end_mp         => l_tab_end_mp
                              ,pi_measure        => l_tab_measure
                              );
--
END ins_nm_mrg_section_members;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_nm_mrg_section_members (pi_mrg_job_id     IN nm3type.tab_number
                                     ,pi_mrg_section_id IN nm3type.tab_number
                                     ,pi_ne_id          IN nm3type.tab_number
                                     ,pi_begin_mp       IN nm3type.tab_number
                                     ,pi_end_mp         IN nm3type.tab_number
                                     ,pi_measure        IN nm3type.tab_number
                                     ) IS
BEGIN
--
   FORALL i IN 1..pi_mrg_job_id.COUNT
      INSERT INTO nm_mrg_section_members
             (nsm_mrg_job_id
             ,nsm_mrg_section_id
             ,nsm_ne_id
             ,nsm_begin_mp
             ,nsm_end_mp
             ,nsm_measure
             )
      VALUES (pi_mrg_job_id(i)
             ,pi_mrg_section_id(i)
             ,pi_ne_id(i)
             ,pi_begin_mp(i)
             ,pi_end_mp(i)
             ,pi_measure(i)
             );
--
END ins_nm_mrg_section_members;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_nm_mrg_section_members (pi_mrg_job_id     IN nm_mrg_section_members.nsm_mrg_job_id%TYPE
                                     ,pi_mrg_section_id IN nm_mrg_section_members.nsm_mrg_section_id%TYPE
                                     ,pi_ne_id          IN nm_mrg_section_members.nsm_ne_id%TYPE
                                     ,pi_begin_mp       IN nm_mrg_section_members.nsm_begin_mp%TYPE
                                     ,pi_end_mp         IN nm_mrg_section_members.nsm_end_mp%TYPE
                                     ,pi_measure        IN nm_mrg_section_members.nsm_measure%TYPE
                                     ) IS
--
   l_tab_mrg_job_id     nm3type.tab_number;
   l_tab_mrg_section_id nm3type.tab_number;
   l_tab_ne_id          nm3type.tab_number;
   l_tab_begin_mp       nm3type.tab_number;
   l_tab_end_mp         nm3type.tab_number;
   l_tab_measure        nm3type.tab_number;
--
BEGIN
--
   l_tab_mrg_job_id(1)     := pi_mrg_job_id;
   l_tab_mrg_section_id(1) := pi_mrg_section_id;
   l_tab_ne_id(1)          := pi_ne_id;
   l_tab_begin_mp(1)       := pi_begin_mp;
   l_tab_end_mp(1)         := pi_end_mp;
   l_tab_measure(1)        := pi_measure;
--
   ins_nm_mrg_section_members (pi_mrg_job_id     => l_tab_mrg_job_id
                              ,pi_mrg_section_id => l_tab_mrg_section_id
                              ,pi_ne_id          => l_tab_ne_id
                              ,pi_begin_mp       => l_tab_begin_mp
                              ,pi_end_mp         => l_tab_end_mp
                              ,pi_measure        => l_tab_measure
                              );
--
END ins_nm_mrg_section_members;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_nm_mrg_section_members (pi_mrg_job_id     IN nm_mrg_section_members.nsm_mrg_job_id%TYPE
                                     ,pi_mrg_section_id IN nm_mrg_section_members.nsm_mrg_section_id%TYPE
                                     ,pi_pl_arr         IN nm_placement_array
                                     ) IS
--
   l_pl nm_placement;
--
   l_tab_mrg_job_id     nm3type.tab_number;
   l_tab_mrg_section_id nm3type.tab_number;
   l_tab_ne_id          nm3type.tab_number;
   l_tab_begin_mp       nm3type.tab_number;
   l_tab_end_mp         nm3type.tab_number;
   l_tab_measure        nm3type.tab_number;
--
BEGIN
--
   IF NOT pi_pl_arr.is_empty
    THEN
         --
      FOR i IN 1..pi_pl_arr.npa_placement_array.COUNT
       LOOP
         --
         l_pl := pi_pl_arr.npa_placement_array(i);
--
         l_tab_mrg_job_id(i)     := pi_mrg_job_id;
         l_tab_mrg_section_id(i) := pi_mrg_section_id;
         l_tab_ne_id(i)          := l_pl.pl_ne_id;
         l_tab_begin_mp(i)       := l_pl.pl_start;
         l_tab_end_mp(i)         := l_pl.pl_end;
         l_tab_measure(i)        := l_pl.pl_measure;
         --
      END LOOP;
--
      ins_nm_mrg_section_members (pi_mrg_job_id     => l_tab_mrg_job_id
                                 ,pi_mrg_section_id => l_tab_mrg_section_id
                                 ,pi_ne_id          => l_tab_ne_id
                                 ,pi_begin_mp       => l_tab_begin_mp
                                 ,pi_end_mp         => l_tab_end_mp
                                 ,pi_measure        => l_tab_measure
                                 );
         --
   END IF;
--
END ins_nm_mrg_section_members;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_nm_mrg_section_inv_values (pi_rec_nsv IN OUT nm_mrg_section_inv_values%ROWTYPE) IS
BEGIN
--
   INSERT INTO nm_mrg_section_inv_values
          (nsv_mrg_job_id, nsv_value_id,nsv_inv_type,nsv_x_sect  ,nsv_pnt_or_cont
          ,nsv_attrib1 ,nsv_attrib2 ,nsv_attrib3 ,nsv_attrib4 ,nsv_attrib5
          ,nsv_attrib6 ,nsv_attrib7 ,nsv_attrib8 ,nsv_attrib9 ,nsv_attrib10
          ,nsv_attrib11,nsv_attrib12,nsv_attrib13,nsv_attrib14,nsv_attrib15
          ,nsv_attrib16,nsv_attrib17,nsv_attrib18,nsv_attrib19,nsv_attrib20
          ,nsv_attrib21,nsv_attrib22,nsv_attrib23,nsv_attrib24,nsv_attrib25
          ,nsv_attrib26,nsv_attrib27,nsv_attrib28,nsv_attrib29,nsv_attrib30
          ,nsv_attrib31,nsv_attrib32,nsv_attrib33,nsv_attrib34,nsv_attrib35
          ,nsv_attrib36,nsv_attrib37,nsv_attrib38,nsv_attrib39,nsv_attrib40
          ,nsv_attrib41,nsv_attrib42,nsv_attrib43,nsv_attrib44,nsv_attrib45
          ,nsv_attrib46,nsv_attrib47,nsv_attrib48,nsv_attrib49,nsv_attrib50
          ,nsv_attrib51,nsv_attrib52,nsv_attrib53,nsv_attrib54,nsv_attrib55
          ,nsv_attrib56,nsv_attrib57,nsv_attrib58,nsv_attrib59,nsv_attrib60
          ,nsv_attrib61,nsv_attrib62,nsv_attrib63,nsv_attrib64,nsv_attrib65
          ,nsv_attrib66,nsv_attrib67,nsv_attrib68,nsv_attrib69,nsv_attrib70
          ,nsv_attrib71,nsv_attrib72,nsv_attrib73,nsv_attrib74,nsv_attrib75
          ,nsv_attrib76,nsv_attrib77,nsv_attrib78,nsv_attrib79,nsv_attrib80
          ,nsv_attrib81,nsv_attrib82,nsv_attrib83,nsv_attrib84,nsv_attrib85
          ,nsv_attrib86,nsv_attrib87,nsv_attrib88,nsv_attrib89,nsv_attrib90
          ,nsv_attrib91,nsv_attrib92,nsv_attrib93,nsv_attrib94,nsv_attrib95
          ,nsv_attrib96,nsv_attrib97,nsv_attrib98,nsv_attrib99,nsv_attrib100
          ,nsv_attrib101,nsv_attrib102,nsv_attrib103,nsv_attrib104,nsv_attrib105
          ,nsv_attrib106,nsv_attrib107,nsv_attrib108,nsv_attrib109,nsv_attrib110
          ,nsv_attrib111,nsv_attrib112,nsv_attrib113,nsv_attrib114,nsv_attrib115
          ,nsv_attrib116,nsv_attrib117,nsv_attrib118,nsv_attrib119,nsv_attrib120
          ,nsv_attrib121,nsv_attrib122,nsv_attrib123,nsv_attrib124,nsv_attrib125
          ,nsv_attrib126,nsv_attrib127,nsv_attrib128,nsv_attrib129,nsv_attrib130
          ,nsv_attrib131,nsv_attrib132,nsv_attrib133,nsv_attrib134,nsv_attrib135
          ,nsv_attrib136,nsv_attrib137,nsv_attrib138,nsv_attrib139,nsv_attrib140
          ,nsv_attrib141,nsv_attrib142,nsv_attrib143,nsv_attrib144,nsv_attrib145
          ,nsv_attrib146,nsv_attrib147,nsv_attrib148,nsv_attrib149,nsv_attrib150
          ,nsv_attrib151,nsv_attrib152,nsv_attrib153,nsv_attrib154,nsv_attrib155
          ,nsv_attrib156,nsv_attrib157,nsv_attrib158,nsv_attrib159,nsv_attrib160
          ,nsv_attrib161,nsv_attrib162,nsv_attrib163,nsv_attrib164,nsv_attrib165
          ,nsv_attrib166,nsv_attrib167,nsv_attrib168,nsv_attrib169,nsv_attrib170
          ,nsv_attrib171,nsv_attrib172,nsv_attrib173,nsv_attrib174,nsv_attrib175
          ,nsv_attrib176,nsv_attrib177,nsv_attrib178,nsv_attrib179,nsv_attrib180
          ,nsv_attrib181,nsv_attrib182,nsv_attrib183,nsv_attrib184,nsv_attrib185
          ,nsv_attrib186,nsv_attrib187,nsv_attrib188,nsv_attrib189,nsv_attrib190
          ,nsv_attrib191,nsv_attrib192,nsv_attrib193,nsv_attrib194,nsv_attrib195
          ,nsv_attrib196,nsv_attrib197,nsv_attrib198,nsv_attrib199,nsv_attrib200
          ,nsv_attrib201,nsv_attrib202,nsv_attrib203,nsv_attrib204,nsv_attrib205
          ,nsv_attrib206,nsv_attrib207,nsv_attrib208,nsv_attrib209,nsv_attrib210
          ,nsv_attrib211,nsv_attrib212,nsv_attrib213,nsv_attrib214,nsv_attrib215
          ,nsv_attrib216,nsv_attrib217,nsv_attrib218,nsv_attrib219,nsv_attrib220
          ,nsv_attrib221,nsv_attrib222,nsv_attrib223,nsv_attrib224,nsv_attrib225
          ,nsv_attrib226,nsv_attrib227,nsv_attrib228,nsv_attrib229,nsv_attrib230
          ,nsv_attrib231,nsv_attrib232,nsv_attrib233,nsv_attrib234,nsv_attrib235
          ,nsv_attrib236,nsv_attrib237,nsv_attrib238,nsv_attrib239,nsv_attrib240
          ,nsv_attrib241,nsv_attrib242,nsv_attrib243,nsv_attrib244,nsv_attrib245
          ,nsv_attrib246,nsv_attrib247,nsv_attrib248,nsv_attrib249,nsv_attrib250
          ,nsv_attrib251,nsv_attrib252,nsv_attrib253,nsv_attrib254,nsv_attrib255
          ,nsv_attrib256,nsv_attrib257,nsv_attrib258,nsv_attrib259,nsv_attrib260
          ,nsv_attrib261,nsv_attrib262,nsv_attrib263,nsv_attrib264,nsv_attrib265
          ,nsv_attrib266,nsv_attrib267,nsv_attrib268,nsv_attrib269,nsv_attrib270
          ,nsv_attrib271,nsv_attrib272,nsv_attrib273,nsv_attrib274,nsv_attrib275
          ,nsv_attrib276,nsv_attrib277,nsv_attrib278,nsv_attrib279,nsv_attrib280
          ,nsv_attrib281,nsv_attrib282,nsv_attrib283,nsv_attrib284,nsv_attrib285
          ,nsv_attrib286,nsv_attrib287,nsv_attrib288,nsv_attrib289,nsv_attrib290
          ,nsv_attrib291,nsv_attrib292,nsv_attrib293,nsv_attrib294,nsv_attrib295
          ,nsv_attrib296,nsv_attrib297,nsv_attrib298,nsv_attrib299,nsv_attrib300
          ,nsv_attrib301,nsv_attrib302,nsv_attrib303,nsv_attrib304,nsv_attrib305
          ,nsv_attrib306,nsv_attrib307,nsv_attrib308,nsv_attrib309,nsv_attrib310
          ,nsv_attrib311,nsv_attrib312,nsv_attrib313,nsv_attrib314,nsv_attrib315
          ,nsv_attrib316,nsv_attrib317,nsv_attrib318,nsv_attrib319,nsv_attrib320
          ,nsv_attrib321,nsv_attrib322,nsv_attrib323,nsv_attrib324,nsv_attrib325
          ,nsv_attrib326,nsv_attrib327,nsv_attrib328,nsv_attrib329,nsv_attrib330
          ,nsv_attrib331,nsv_attrib332,nsv_attrib333,nsv_attrib334,nsv_attrib335
          ,nsv_attrib336,nsv_attrib337,nsv_attrib338,nsv_attrib339,nsv_attrib340
          ,nsv_attrib341,nsv_attrib342,nsv_attrib343,nsv_attrib344,nsv_attrib345
          ,nsv_attrib346,nsv_attrib347,nsv_attrib348,nsv_attrib349,nsv_attrib350
          ,nsv_attrib351,nsv_attrib352,nsv_attrib353,nsv_attrib354,nsv_attrib355
          ,nsv_attrib356,nsv_attrib357,nsv_attrib358,nsv_attrib359,nsv_attrib360
          ,nsv_attrib361,nsv_attrib362,nsv_attrib363,nsv_attrib364,nsv_attrib365
          ,nsv_attrib366,nsv_attrib367,nsv_attrib368,nsv_attrib369,nsv_attrib370
          ,nsv_attrib371,nsv_attrib372,nsv_attrib373,nsv_attrib374,nsv_attrib375
          ,nsv_attrib376,nsv_attrib377,nsv_attrib378,nsv_attrib379,nsv_attrib380
          ,nsv_attrib381,nsv_attrib382,nsv_attrib383,nsv_attrib384,nsv_attrib385
          ,nsv_attrib386,nsv_attrib387,nsv_attrib388,nsv_attrib389,nsv_attrib390
          ,nsv_attrib391,nsv_attrib392,nsv_attrib393,nsv_attrib394,nsv_attrib395
          ,nsv_attrib396,nsv_attrib397,nsv_attrib398,nsv_attrib399,nsv_attrib400
          ,nsv_attrib401,nsv_attrib402,nsv_attrib403,nsv_attrib404,nsv_attrib405
          ,nsv_attrib406,nsv_attrib407,nsv_attrib408,nsv_attrib409,nsv_attrib410
          ,nsv_attrib411,nsv_attrib412,nsv_attrib413,nsv_attrib414,nsv_attrib415
          ,nsv_attrib416,nsv_attrib417,nsv_attrib418,nsv_attrib419,nsv_attrib420
          ,nsv_attrib421,nsv_attrib422,nsv_attrib423,nsv_attrib424,nsv_attrib425
          ,nsv_attrib426,nsv_attrib427,nsv_attrib428,nsv_attrib429,nsv_attrib430
          ,nsv_attrib431,nsv_attrib432,nsv_attrib433,nsv_attrib434,nsv_attrib435
          ,nsv_attrib436,nsv_attrib437,nsv_attrib438,nsv_attrib439,nsv_attrib440
          ,nsv_attrib441,nsv_attrib442,nsv_attrib443,nsv_attrib444,nsv_attrib445
          ,nsv_attrib446,nsv_attrib447,nsv_attrib448,nsv_attrib449,nsv_attrib450
          ,nsv_attrib451,nsv_attrib452,nsv_attrib453,nsv_attrib454,nsv_attrib455
          ,nsv_attrib456,nsv_attrib457,nsv_attrib458,nsv_attrib459,nsv_attrib460
          ,nsv_attrib461,nsv_attrib462,nsv_attrib463,nsv_attrib464,nsv_attrib465
          ,nsv_attrib466,nsv_attrib467,nsv_attrib468,nsv_attrib469,nsv_attrib470
          ,nsv_attrib471,nsv_attrib472,nsv_attrib473,nsv_attrib474,nsv_attrib475
          ,nsv_attrib476,nsv_attrib477,nsv_attrib478,nsv_attrib479,nsv_attrib480
          ,nsv_attrib481,nsv_attrib482,nsv_attrib483,nsv_attrib484,nsv_attrib485
          ,nsv_attrib486,nsv_attrib487,nsv_attrib488,nsv_attrib489,nsv_attrib490
          ,nsv_attrib491,nsv_attrib492,nsv_attrib493,nsv_attrib494,nsv_attrib495
          ,nsv_attrib496,nsv_attrib497,nsv_attrib498,nsv_attrib499,nsv_attrib500
          )
   VALUES (pi_rec_nsv.nsv_mrg_job_id,nm_mrg_query_values_seq.NEXTVAL,pi_rec_nsv.nsv_inv_type,pi_rec_nsv.nsv_x_sect  ,pi_rec_nsv.nsv_pnt_or_cont
          ,pi_rec_nsv.nsv_attrib1 ,pi_rec_nsv.nsv_attrib2 ,pi_rec_nsv.nsv_attrib3 ,pi_rec_nsv.nsv_attrib4 ,pi_rec_nsv.nsv_attrib5
          ,pi_rec_nsv.nsv_attrib6 ,pi_rec_nsv.nsv_attrib7 ,pi_rec_nsv.nsv_attrib8 ,pi_rec_nsv.nsv_attrib9 ,pi_rec_nsv.nsv_attrib10
          ,pi_rec_nsv.nsv_attrib11,pi_rec_nsv.nsv_attrib12,pi_rec_nsv.nsv_attrib13,pi_rec_nsv.nsv_attrib14,pi_rec_nsv.nsv_attrib15
          ,pi_rec_nsv.nsv_attrib16,pi_rec_nsv.nsv_attrib17,pi_rec_nsv.nsv_attrib18,pi_rec_nsv.nsv_attrib19,pi_rec_nsv.nsv_attrib20
          ,pi_rec_nsv.nsv_attrib21,pi_rec_nsv.nsv_attrib22,pi_rec_nsv.nsv_attrib23,pi_rec_nsv.nsv_attrib24,pi_rec_nsv.nsv_attrib25
          ,pi_rec_nsv.nsv_attrib26,pi_rec_nsv.nsv_attrib27,pi_rec_nsv.nsv_attrib28,pi_rec_nsv.nsv_attrib29,pi_rec_nsv.nsv_attrib30
          ,pi_rec_nsv.nsv_attrib31,pi_rec_nsv.nsv_attrib32,pi_rec_nsv.nsv_attrib33,pi_rec_nsv.nsv_attrib34,pi_rec_nsv.nsv_attrib35
          ,pi_rec_nsv.nsv_attrib36,pi_rec_nsv.nsv_attrib37,pi_rec_nsv.nsv_attrib38,pi_rec_nsv.nsv_attrib39,pi_rec_nsv.nsv_attrib40
          ,pi_rec_nsv.nsv_attrib41,pi_rec_nsv.nsv_attrib42,pi_rec_nsv.nsv_attrib43,pi_rec_nsv.nsv_attrib44,pi_rec_nsv.nsv_attrib45
          ,pi_rec_nsv.nsv_attrib46,pi_rec_nsv.nsv_attrib47,pi_rec_nsv.nsv_attrib48,pi_rec_nsv.nsv_attrib49,pi_rec_nsv.nsv_attrib50
          ,pi_rec_nsv.nsv_attrib51,pi_rec_nsv.nsv_attrib52,pi_rec_nsv.nsv_attrib53,pi_rec_nsv.nsv_attrib54,pi_rec_nsv.nsv_attrib55
          ,pi_rec_nsv.nsv_attrib56,pi_rec_nsv.nsv_attrib57,pi_rec_nsv.nsv_attrib58,pi_rec_nsv.nsv_attrib59,pi_rec_nsv.nsv_attrib60
          ,pi_rec_nsv.nsv_attrib61,pi_rec_nsv.nsv_attrib62,pi_rec_nsv.nsv_attrib63,pi_rec_nsv.nsv_attrib64,pi_rec_nsv.nsv_attrib65
          ,pi_rec_nsv.nsv_attrib66,pi_rec_nsv.nsv_attrib67,pi_rec_nsv.nsv_attrib68,pi_rec_nsv.nsv_attrib69,pi_rec_nsv.nsv_attrib70
          ,pi_rec_nsv.nsv_attrib71,pi_rec_nsv.nsv_attrib72,pi_rec_nsv.nsv_attrib73,pi_rec_nsv.nsv_attrib74,pi_rec_nsv.nsv_attrib75
          ,pi_rec_nsv.nsv_attrib76,pi_rec_nsv.nsv_attrib77,pi_rec_nsv.nsv_attrib78,pi_rec_nsv.nsv_attrib79,pi_rec_nsv.nsv_attrib80
          ,pi_rec_nsv.nsv_attrib81,pi_rec_nsv.nsv_attrib82,pi_rec_nsv.nsv_attrib83,pi_rec_nsv.nsv_attrib84,pi_rec_nsv.nsv_attrib85
          ,pi_rec_nsv.nsv_attrib86,pi_rec_nsv.nsv_attrib87,pi_rec_nsv.nsv_attrib88,pi_rec_nsv.nsv_attrib89,pi_rec_nsv.nsv_attrib90
          ,pi_rec_nsv.nsv_attrib91,pi_rec_nsv.nsv_attrib92,pi_rec_nsv.nsv_attrib93,pi_rec_nsv.nsv_attrib94,pi_rec_nsv.nsv_attrib95
          ,pi_rec_nsv.nsv_attrib96,pi_rec_nsv.nsv_attrib97,pi_rec_nsv.nsv_attrib98,pi_rec_nsv.nsv_attrib99,pi_rec_nsv.nsv_attrib100
          ,pi_rec_nsv.nsv_attrib101,pi_rec_nsv.nsv_attrib102,pi_rec_nsv.nsv_attrib103,pi_rec_nsv.nsv_attrib104,pi_rec_nsv.nsv_attrib105
          ,pi_rec_nsv.nsv_attrib106,pi_rec_nsv.nsv_attrib107,pi_rec_nsv.nsv_attrib108,pi_rec_nsv.nsv_attrib109,pi_rec_nsv.nsv_attrib110
          ,pi_rec_nsv.nsv_attrib111,pi_rec_nsv.nsv_attrib112,pi_rec_nsv.nsv_attrib113,pi_rec_nsv.nsv_attrib114,pi_rec_nsv.nsv_attrib115
          ,pi_rec_nsv.nsv_attrib116,pi_rec_nsv.nsv_attrib117,pi_rec_nsv.nsv_attrib118,pi_rec_nsv.nsv_attrib119,pi_rec_nsv.nsv_attrib120
          ,pi_rec_nsv.nsv_attrib121,pi_rec_nsv.nsv_attrib122,pi_rec_nsv.nsv_attrib123,pi_rec_nsv.nsv_attrib124,pi_rec_nsv.nsv_attrib125
          ,pi_rec_nsv.nsv_attrib126,pi_rec_nsv.nsv_attrib127,pi_rec_nsv.nsv_attrib128,pi_rec_nsv.nsv_attrib129,pi_rec_nsv.nsv_attrib130
          ,pi_rec_nsv.nsv_attrib131,pi_rec_nsv.nsv_attrib132,pi_rec_nsv.nsv_attrib133,pi_rec_nsv.nsv_attrib134,pi_rec_nsv.nsv_attrib135
          ,pi_rec_nsv.nsv_attrib136,pi_rec_nsv.nsv_attrib137,pi_rec_nsv.nsv_attrib138,pi_rec_nsv.nsv_attrib139,pi_rec_nsv.nsv_attrib140
          ,pi_rec_nsv.nsv_attrib141,pi_rec_nsv.nsv_attrib142,pi_rec_nsv.nsv_attrib143,pi_rec_nsv.nsv_attrib144,pi_rec_nsv.nsv_attrib145
          ,pi_rec_nsv.nsv_attrib146,pi_rec_nsv.nsv_attrib147,pi_rec_nsv.nsv_attrib148,pi_rec_nsv.nsv_attrib149,pi_rec_nsv.nsv_attrib150
          ,pi_rec_nsv.nsv_attrib151,pi_rec_nsv.nsv_attrib152,pi_rec_nsv.nsv_attrib153,pi_rec_nsv.nsv_attrib154,pi_rec_nsv.nsv_attrib155
          ,pi_rec_nsv.nsv_attrib156,pi_rec_nsv.nsv_attrib157,pi_rec_nsv.nsv_attrib158,pi_rec_nsv.nsv_attrib159,pi_rec_nsv.nsv_attrib160
          ,pi_rec_nsv.nsv_attrib161,pi_rec_nsv.nsv_attrib162,pi_rec_nsv.nsv_attrib163,pi_rec_nsv.nsv_attrib164,pi_rec_nsv.nsv_attrib165
          ,pi_rec_nsv.nsv_attrib166,pi_rec_nsv.nsv_attrib167,pi_rec_nsv.nsv_attrib168,pi_rec_nsv.nsv_attrib169,pi_rec_nsv.nsv_attrib170
          ,pi_rec_nsv.nsv_attrib171,pi_rec_nsv.nsv_attrib172,pi_rec_nsv.nsv_attrib173,pi_rec_nsv.nsv_attrib174,pi_rec_nsv.nsv_attrib175
          ,pi_rec_nsv.nsv_attrib176,pi_rec_nsv.nsv_attrib177,pi_rec_nsv.nsv_attrib178,pi_rec_nsv.nsv_attrib179,pi_rec_nsv.nsv_attrib180
          ,pi_rec_nsv.nsv_attrib181,pi_rec_nsv.nsv_attrib182,pi_rec_nsv.nsv_attrib183,pi_rec_nsv.nsv_attrib184,pi_rec_nsv.nsv_attrib185
          ,pi_rec_nsv.nsv_attrib186,pi_rec_nsv.nsv_attrib187,pi_rec_nsv.nsv_attrib188,pi_rec_nsv.nsv_attrib189,pi_rec_nsv.nsv_attrib190
          ,pi_rec_nsv.nsv_attrib191,pi_rec_nsv.nsv_attrib192,pi_rec_nsv.nsv_attrib193,pi_rec_nsv.nsv_attrib194,pi_rec_nsv.nsv_attrib195
          ,pi_rec_nsv.nsv_attrib196,pi_rec_nsv.nsv_attrib197,pi_rec_nsv.nsv_attrib198,pi_rec_nsv.nsv_attrib199,pi_rec_nsv.nsv_attrib200
          ,pi_rec_nsv.nsv_attrib201,pi_rec_nsv.nsv_attrib202,pi_rec_nsv.nsv_attrib203,pi_rec_nsv.nsv_attrib204,pi_rec_nsv.nsv_attrib205
          ,pi_rec_nsv.nsv_attrib206,pi_rec_nsv.nsv_attrib207,pi_rec_nsv.nsv_attrib208,pi_rec_nsv.nsv_attrib209,pi_rec_nsv.nsv_attrib210
          ,pi_rec_nsv.nsv_attrib211,pi_rec_nsv.nsv_attrib212,pi_rec_nsv.nsv_attrib213,pi_rec_nsv.nsv_attrib214,pi_rec_nsv.nsv_attrib215
          ,pi_rec_nsv.nsv_attrib216,pi_rec_nsv.nsv_attrib217,pi_rec_nsv.nsv_attrib218,pi_rec_nsv.nsv_attrib219,pi_rec_nsv.nsv_attrib220
          ,pi_rec_nsv.nsv_attrib221,pi_rec_nsv.nsv_attrib222,pi_rec_nsv.nsv_attrib223,pi_rec_nsv.nsv_attrib224,pi_rec_nsv.nsv_attrib225
          ,pi_rec_nsv.nsv_attrib226,pi_rec_nsv.nsv_attrib227,pi_rec_nsv.nsv_attrib228,pi_rec_nsv.nsv_attrib229,pi_rec_nsv.nsv_attrib230
          ,pi_rec_nsv.nsv_attrib231,pi_rec_nsv.nsv_attrib232,pi_rec_nsv.nsv_attrib233,pi_rec_nsv.nsv_attrib234,pi_rec_nsv.nsv_attrib235
          ,pi_rec_nsv.nsv_attrib236,pi_rec_nsv.nsv_attrib237,pi_rec_nsv.nsv_attrib238,pi_rec_nsv.nsv_attrib239,pi_rec_nsv.nsv_attrib240
          ,pi_rec_nsv.nsv_attrib241,pi_rec_nsv.nsv_attrib242,pi_rec_nsv.nsv_attrib243,pi_rec_nsv.nsv_attrib244,pi_rec_nsv.nsv_attrib245
          ,pi_rec_nsv.nsv_attrib246,pi_rec_nsv.nsv_attrib247,pi_rec_nsv.nsv_attrib248,pi_rec_nsv.nsv_attrib249,pi_rec_nsv.nsv_attrib250
          ,pi_rec_nsv.nsv_attrib251,pi_rec_nsv.nsv_attrib252,pi_rec_nsv.nsv_attrib253,pi_rec_nsv.nsv_attrib254,pi_rec_nsv.nsv_attrib255
          ,pi_rec_nsv.nsv_attrib256,pi_rec_nsv.nsv_attrib257,pi_rec_nsv.nsv_attrib258,pi_rec_nsv.nsv_attrib259,pi_rec_nsv.nsv_attrib260
          ,pi_rec_nsv.nsv_attrib261,pi_rec_nsv.nsv_attrib262,pi_rec_nsv.nsv_attrib263,pi_rec_nsv.nsv_attrib264,pi_rec_nsv.nsv_attrib265
          ,pi_rec_nsv.nsv_attrib266,pi_rec_nsv.nsv_attrib267,pi_rec_nsv.nsv_attrib268,pi_rec_nsv.nsv_attrib269,pi_rec_nsv.nsv_attrib270
          ,pi_rec_nsv.nsv_attrib271,pi_rec_nsv.nsv_attrib272,pi_rec_nsv.nsv_attrib273,pi_rec_nsv.nsv_attrib274,pi_rec_nsv.nsv_attrib275
          ,pi_rec_nsv.nsv_attrib276,pi_rec_nsv.nsv_attrib277,pi_rec_nsv.nsv_attrib278,pi_rec_nsv.nsv_attrib279,pi_rec_nsv.nsv_attrib280
          ,pi_rec_nsv.nsv_attrib281,pi_rec_nsv.nsv_attrib282,pi_rec_nsv.nsv_attrib283,pi_rec_nsv.nsv_attrib284,pi_rec_nsv.nsv_attrib285
          ,pi_rec_nsv.nsv_attrib286,pi_rec_nsv.nsv_attrib287,pi_rec_nsv.nsv_attrib288,pi_rec_nsv.nsv_attrib289,pi_rec_nsv.nsv_attrib290
          ,pi_rec_nsv.nsv_attrib291,pi_rec_nsv.nsv_attrib292,pi_rec_nsv.nsv_attrib293,pi_rec_nsv.nsv_attrib294,pi_rec_nsv.nsv_attrib295
          ,pi_rec_nsv.nsv_attrib296,pi_rec_nsv.nsv_attrib297,pi_rec_nsv.nsv_attrib298,pi_rec_nsv.nsv_attrib299,pi_rec_nsv.nsv_attrib300
          ,pi_rec_nsv.nsv_attrib301,pi_rec_nsv.nsv_attrib302,pi_rec_nsv.nsv_attrib303,pi_rec_nsv.nsv_attrib304,pi_rec_nsv.nsv_attrib305
          ,pi_rec_nsv.nsv_attrib306,pi_rec_nsv.nsv_attrib307,pi_rec_nsv.nsv_attrib308,pi_rec_nsv.nsv_attrib309,pi_rec_nsv.nsv_attrib310
          ,pi_rec_nsv.nsv_attrib311,pi_rec_nsv.nsv_attrib312,pi_rec_nsv.nsv_attrib313,pi_rec_nsv.nsv_attrib314,pi_rec_nsv.nsv_attrib315
          ,pi_rec_nsv.nsv_attrib316,pi_rec_nsv.nsv_attrib317,pi_rec_nsv.nsv_attrib318,pi_rec_nsv.nsv_attrib319,pi_rec_nsv.nsv_attrib320
          ,pi_rec_nsv.nsv_attrib321,pi_rec_nsv.nsv_attrib322,pi_rec_nsv.nsv_attrib323,pi_rec_nsv.nsv_attrib324,pi_rec_nsv.nsv_attrib325
          ,pi_rec_nsv.nsv_attrib326,pi_rec_nsv.nsv_attrib327,pi_rec_nsv.nsv_attrib328,pi_rec_nsv.nsv_attrib329,pi_rec_nsv.nsv_attrib330
          ,pi_rec_nsv.nsv_attrib331,pi_rec_nsv.nsv_attrib332,pi_rec_nsv.nsv_attrib333,pi_rec_nsv.nsv_attrib334,pi_rec_nsv.nsv_attrib335
          ,pi_rec_nsv.nsv_attrib336,pi_rec_nsv.nsv_attrib337,pi_rec_nsv.nsv_attrib338,pi_rec_nsv.nsv_attrib339,pi_rec_nsv.nsv_attrib340
          ,pi_rec_nsv.nsv_attrib341,pi_rec_nsv.nsv_attrib342,pi_rec_nsv.nsv_attrib343,pi_rec_nsv.nsv_attrib344,pi_rec_nsv.nsv_attrib345
          ,pi_rec_nsv.nsv_attrib346,pi_rec_nsv.nsv_attrib347,pi_rec_nsv.nsv_attrib348,pi_rec_nsv.nsv_attrib349,pi_rec_nsv.nsv_attrib350
          ,pi_rec_nsv.nsv_attrib351,pi_rec_nsv.nsv_attrib352,pi_rec_nsv.nsv_attrib353,pi_rec_nsv.nsv_attrib354,pi_rec_nsv.nsv_attrib355
          ,pi_rec_nsv.nsv_attrib356,pi_rec_nsv.nsv_attrib357,pi_rec_nsv.nsv_attrib358,pi_rec_nsv.nsv_attrib359,pi_rec_nsv.nsv_attrib360
          ,pi_rec_nsv.nsv_attrib361,pi_rec_nsv.nsv_attrib362,pi_rec_nsv.nsv_attrib363,pi_rec_nsv.nsv_attrib364,pi_rec_nsv.nsv_attrib365
          ,pi_rec_nsv.nsv_attrib366,pi_rec_nsv.nsv_attrib367,pi_rec_nsv.nsv_attrib368,pi_rec_nsv.nsv_attrib369,pi_rec_nsv.nsv_attrib370
          ,pi_rec_nsv.nsv_attrib371,pi_rec_nsv.nsv_attrib372,pi_rec_nsv.nsv_attrib373,pi_rec_nsv.nsv_attrib374,pi_rec_nsv.nsv_attrib375
          ,pi_rec_nsv.nsv_attrib376,pi_rec_nsv.nsv_attrib377,pi_rec_nsv.nsv_attrib378,pi_rec_nsv.nsv_attrib379,pi_rec_nsv.nsv_attrib380
          ,pi_rec_nsv.nsv_attrib381,pi_rec_nsv.nsv_attrib382,pi_rec_nsv.nsv_attrib383,pi_rec_nsv.nsv_attrib384,pi_rec_nsv.nsv_attrib385
          ,pi_rec_nsv.nsv_attrib386,pi_rec_nsv.nsv_attrib387,pi_rec_nsv.nsv_attrib388,pi_rec_nsv.nsv_attrib389,pi_rec_nsv.nsv_attrib390
          ,pi_rec_nsv.nsv_attrib391,pi_rec_nsv.nsv_attrib392,pi_rec_nsv.nsv_attrib393,pi_rec_nsv.nsv_attrib394,pi_rec_nsv.nsv_attrib395
          ,pi_rec_nsv.nsv_attrib396,pi_rec_nsv.nsv_attrib397,pi_rec_nsv.nsv_attrib398,pi_rec_nsv.nsv_attrib399,pi_rec_nsv.nsv_attrib400
          ,pi_rec_nsv.nsv_attrib401,pi_rec_nsv.nsv_attrib402,pi_rec_nsv.nsv_attrib403,pi_rec_nsv.nsv_attrib404,pi_rec_nsv.nsv_attrib405
          ,pi_rec_nsv.nsv_attrib406,pi_rec_nsv.nsv_attrib407,pi_rec_nsv.nsv_attrib408,pi_rec_nsv.nsv_attrib409,pi_rec_nsv.nsv_attrib410
          ,pi_rec_nsv.nsv_attrib411,pi_rec_nsv.nsv_attrib412,pi_rec_nsv.nsv_attrib413,pi_rec_nsv.nsv_attrib414,pi_rec_nsv.nsv_attrib415
          ,pi_rec_nsv.nsv_attrib416,pi_rec_nsv.nsv_attrib417,pi_rec_nsv.nsv_attrib418,pi_rec_nsv.nsv_attrib419,pi_rec_nsv.nsv_attrib420
          ,pi_rec_nsv.nsv_attrib421,pi_rec_nsv.nsv_attrib422,pi_rec_nsv.nsv_attrib423,pi_rec_nsv.nsv_attrib424,pi_rec_nsv.nsv_attrib425
          ,pi_rec_nsv.nsv_attrib426,pi_rec_nsv.nsv_attrib427,pi_rec_nsv.nsv_attrib428,pi_rec_nsv.nsv_attrib429,pi_rec_nsv.nsv_attrib430
          ,pi_rec_nsv.nsv_attrib431,pi_rec_nsv.nsv_attrib432,pi_rec_nsv.nsv_attrib433,pi_rec_nsv.nsv_attrib434,pi_rec_nsv.nsv_attrib435
          ,pi_rec_nsv.nsv_attrib436,pi_rec_nsv.nsv_attrib437,pi_rec_nsv.nsv_attrib438,pi_rec_nsv.nsv_attrib439,pi_rec_nsv.nsv_attrib440
          ,pi_rec_nsv.nsv_attrib441,pi_rec_nsv.nsv_attrib442,pi_rec_nsv.nsv_attrib443,pi_rec_nsv.nsv_attrib444,pi_rec_nsv.nsv_attrib445
          ,pi_rec_nsv.nsv_attrib446,pi_rec_nsv.nsv_attrib447,pi_rec_nsv.nsv_attrib448,pi_rec_nsv.nsv_attrib449,pi_rec_nsv.nsv_attrib450
          ,pi_rec_nsv.nsv_attrib451,pi_rec_nsv.nsv_attrib452,pi_rec_nsv.nsv_attrib453,pi_rec_nsv.nsv_attrib454,pi_rec_nsv.nsv_attrib455
          ,pi_rec_nsv.nsv_attrib456,pi_rec_nsv.nsv_attrib457,pi_rec_nsv.nsv_attrib458,pi_rec_nsv.nsv_attrib459,pi_rec_nsv.nsv_attrib460
          ,pi_rec_nsv.nsv_attrib461,pi_rec_nsv.nsv_attrib462,pi_rec_nsv.nsv_attrib463,pi_rec_nsv.nsv_attrib464,pi_rec_nsv.nsv_attrib465
          ,pi_rec_nsv.nsv_attrib466,pi_rec_nsv.nsv_attrib467,pi_rec_nsv.nsv_attrib468,pi_rec_nsv.nsv_attrib469,pi_rec_nsv.nsv_attrib470
          ,pi_rec_nsv.nsv_attrib471,pi_rec_nsv.nsv_attrib472,pi_rec_nsv.nsv_attrib473,pi_rec_nsv.nsv_attrib474,pi_rec_nsv.nsv_attrib475
          ,pi_rec_nsv.nsv_attrib476,pi_rec_nsv.nsv_attrib477,pi_rec_nsv.nsv_attrib478,pi_rec_nsv.nsv_attrib479,pi_rec_nsv.nsv_attrib480
          ,pi_rec_nsv.nsv_attrib481,pi_rec_nsv.nsv_attrib482,pi_rec_nsv.nsv_attrib483,pi_rec_nsv.nsv_attrib484,pi_rec_nsv.nsv_attrib485
          ,pi_rec_nsv.nsv_attrib486,pi_rec_nsv.nsv_attrib487,pi_rec_nsv.nsv_attrib488,pi_rec_nsv.nsv_attrib489,pi_rec_nsv.nsv_attrib490
          ,pi_rec_nsv.nsv_attrib491,pi_rec_nsv.nsv_attrib492,pi_rec_nsv.nsv_attrib493,pi_rec_nsv.nsv_attrib494,pi_rec_nsv.nsv_attrib495
          ,pi_rec_nsv.nsv_attrib496,pi_rec_nsv.nsv_attrib497,pi_rec_nsv.nsv_attrib498,pi_rec_nsv.nsv_attrib499,pi_rec_nsv.nsv_attrib500
          )
     RETURNING nsv_value_id INTO pi_rec_nsv.nsv_value_id;
--
END ins_nm_mrg_section_inv_values;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE ins_nm_mrg_section_member_inv (pi_rec_nsi IN nm_mrg_section_member_inv%ROWTYPE) IS
--
--   CURSOR cs_check_exists IS
--   SELECT 1
--    FROM  nm_mrg_section_member_inv
--   WHERE  nsi_mrg_job_id     = pi_rec_nsi.nsi_mrg_job_id
--    AND   nsi_mrg_section_id = pi_rec_nsi.nsi_mrg_section_id
--    AND   nsi_inv_type       = pi_rec_nsi.nsi_inv_type
--    AND   nsi_x_sect         = pi_rec_nsi.nsi_x_sect
--    AND   nsi_value_id       = pi_rec_nsi.nsi_value_id;
----
--   l_dummy  PLS_INTEGER;
--   l_insert BOOLEAN;
--
BEGIN
--
--   OPEN  cs_check_exists;
--   FETCH cs_check_exists INTO l_dummy;
--   l_insert := cs_check_exists%NOTFOUND;
--   CLOSE cs_check_exists;
----
--   IF l_insert
--    THEN
      INSERT INTO nm_mrg_section_member_inv
              (nsi_mrg_job_id
              ,nsi_mrg_section_id
              ,nsi_inv_type
              ,nsi_x_sect
              ,nsi_value_id
              )
      VALUES  (pi_rec_nsi.nsi_mrg_job_id
              ,pi_rec_nsi.nsi_mrg_section_id
              ,pi_rec_nsi.nsi_inv_type
              ,pi_rec_nsi.nsi_x_sect
              ,pi_rec_nsi.nsi_value_id
              );
--   END IF;
--
END ins_nm_mrg_section_member_inv;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE do_cascading_sect_update (p_rec_nms            nm_mrg_sections%ROWTYPE
                                   ,p_new_mrg_section_id number
                                   ) IS
BEGIN
--
-- Insert a new MRG_SECTION
--
   ins_nm_mrg_sections (pi_job_id         => p_rec_nms.nms_mrg_job_id
                       ,pi_mrg_section_id => p_new_mrg_section_id
                       ,pi_nte_job_id     => p_rec_nms.nms_offset_ne_id
                       ,pi_ne_id_first    => p_rec_nms.nms_ne_id_first
                       ,pi_begin_mp_first => p_rec_nms.nms_begin_mp_first
                       ,pi_ne_id_last     => p_rec_nms.nms_ne_id_last
                       ,pi_end_mp_last    => p_rec_nms.nms_end_mp_last
                       ,pi_orig_sect_id   => p_rec_nms.nms_orig_sect_id
                       ,pi_in_results     => p_rec_nms.nms_in_results
                       );
--
-- update the existing MRG_SECTION_MEMBERS to point to the new MRG_SECTION
--
   UPDATE nm_mrg_section_members
    SET   nsm_mrg_section_id = p_new_mrg_section_id
   WHERE  nsm_mrg_job_id     = p_rec_nms.nms_mrg_job_id
    AND   nsm_mrg_section_id = p_rec_nms.nms_mrg_section_id;
--
-- update the existing nm_mrg_section_member_inv to point to the new MRG_SECTION
--
   UPDATE nm_mrg_section_member_inv
    SET   nsi_mrg_section_id = p_new_mrg_section_id
   WHERE  nsi_mrg_job_id     = p_rec_nms.nms_mrg_job_id
    AND   nsi_mrg_section_id = p_rec_nms.nms_mrg_section_id;
--
--  Delete the "OLD" MRG_SECTION now that nothing is pointing at it
--
   DELETE FROM nm_mrg_sections
   WHERE  nms_mrg_job_id     = p_rec_nms.nms_mrg_job_id
    AND   nms_mrg_section_id = p_rec_nms.nms_mrg_section_id;
--
END do_cascading_sect_update;
--
------------------------------------------------------------------------------------------------
--
FUNCTION compare_rec_nsv (pi_rec_1 nm_mrg_section_inv_values%ROWTYPE
                         ,pi_rec_2 nm_mrg_section_inv_values%ROWTYPE
                         ) RETURN boolean IS
BEGIN
--
   RETURN  pi_rec_1.nsv_inv_type                   = pi_rec_2.nsv_inv_type
           AND NVL(pi_rec_1.nsv_x_sect,c_nvl)      = NVL(pi_rec_2.nsv_x_sect,c_nvl)
           AND pi_rec_1.nsv_pnt_or_cont            = pi_rec_2.nsv_pnt_or_cont
           AND NVL(pi_rec_1.nsv_attrib1,c_nvl)     = NVL(pi_rec_2.nsv_attrib1,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib2,c_nvl)     = NVL(pi_rec_2.nsv_attrib2,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib3,c_nvl)     = NVL(pi_rec_2.nsv_attrib3,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib4,c_nvl)     = NVL(pi_rec_2.nsv_attrib4,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib5,c_nvl)     = NVL(pi_rec_2.nsv_attrib5,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib6,c_nvl)     = NVL(pi_rec_2.nsv_attrib6,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib7,c_nvl)     = NVL(pi_rec_2.nsv_attrib7,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib8,c_nvl)     = NVL(pi_rec_2.nsv_attrib8,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib9,c_nvl)     = NVL(pi_rec_2.nsv_attrib9,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib10,c_nvl)    = NVL(pi_rec_2.nsv_attrib10,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib11,c_nvl)    = NVL(pi_rec_2.nsv_attrib11,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib12,c_nvl)    = NVL(pi_rec_2.nsv_attrib12,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib13,c_nvl)    = NVL(pi_rec_2.nsv_attrib13,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib14,c_nvl)    = NVL(pi_rec_2.nsv_attrib14,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib15,c_nvl)    = NVL(pi_rec_2.nsv_attrib15,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib16,c_nvl)    = NVL(pi_rec_2.nsv_attrib16,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib17,c_nvl)    = NVL(pi_rec_2.nsv_attrib17,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib18,c_nvl)    = NVL(pi_rec_2.nsv_attrib18,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib19,c_nvl)    = NVL(pi_rec_2.nsv_attrib19,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib20,c_nvl)    = NVL(pi_rec_2.nsv_attrib20,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib21,c_nvl)    = NVL(pi_rec_2.nsv_attrib21,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib22,c_nvl)    = NVL(pi_rec_2.nsv_attrib22,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib23,c_nvl)    = NVL(pi_rec_2.nsv_attrib23,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib24,c_nvl)    = NVL(pi_rec_2.nsv_attrib24,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib25,c_nvl)    = NVL(pi_rec_2.nsv_attrib25,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib26,c_nvl)    = NVL(pi_rec_2.nsv_attrib26,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib27,c_nvl)    = NVL(pi_rec_2.nsv_attrib27,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib28,c_nvl)    = NVL(pi_rec_2.nsv_attrib28,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib29,c_nvl)    = NVL(pi_rec_2.nsv_attrib29,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib30,c_nvl)    = NVL(pi_rec_2.nsv_attrib30,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib31,c_nvl)    = NVL(pi_rec_2.nsv_attrib31,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib32,c_nvl)    = NVL(pi_rec_2.nsv_attrib32,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib33,c_nvl)    = NVL(pi_rec_2.nsv_attrib33,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib34,c_nvl)    = NVL(pi_rec_2.nsv_attrib34,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib35,c_nvl)    = NVL(pi_rec_2.nsv_attrib35,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib36,c_nvl)    = NVL(pi_rec_2.nsv_attrib36,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib37,c_nvl)    = NVL(pi_rec_2.nsv_attrib37,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib38,c_nvl)    = NVL(pi_rec_2.nsv_attrib38,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib39,c_nvl)    = NVL(pi_rec_2.nsv_attrib39,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib40,c_nvl)    = NVL(pi_rec_2.nsv_attrib40,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib41,c_nvl)    = NVL(pi_rec_2.nsv_attrib41,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib42,c_nvl)    = NVL(pi_rec_2.nsv_attrib42,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib43,c_nvl)    = NVL(pi_rec_2.nsv_attrib43,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib44,c_nvl)    = NVL(pi_rec_2.nsv_attrib44,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib45,c_nvl)    = NVL(pi_rec_2.nsv_attrib45,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib46,c_nvl)    = NVL(pi_rec_2.nsv_attrib46,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib47,c_nvl)    = NVL(pi_rec_2.nsv_attrib47,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib48,c_nvl)    = NVL(pi_rec_2.nsv_attrib48,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib49,c_nvl)    = NVL(pi_rec_2.nsv_attrib49,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib50,c_nvl)    = NVL(pi_rec_2.nsv_attrib50,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib51,c_nvl)    = NVL(pi_rec_2.nsv_attrib51,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib52,c_nvl)    = NVL(pi_rec_2.nsv_attrib52,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib53,c_nvl)    = NVL(pi_rec_2.nsv_attrib53,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib54,c_nvl)    = NVL(pi_rec_2.nsv_attrib54,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib55,c_nvl)    = NVL(pi_rec_2.nsv_attrib55,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib56,c_nvl)    = NVL(pi_rec_2.nsv_attrib56,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib57,c_nvl)    = NVL(pi_rec_2.nsv_attrib57,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib58,c_nvl)    = NVL(pi_rec_2.nsv_attrib58,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib59,c_nvl)    = NVL(pi_rec_2.nsv_attrib59,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib60,c_nvl)    = NVL(pi_rec_2.nsv_attrib60,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib61,c_nvl)    = NVL(pi_rec_2.nsv_attrib61,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib62,c_nvl)    = NVL(pi_rec_2.nsv_attrib62,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib63,c_nvl)    = NVL(pi_rec_2.nsv_attrib63,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib64,c_nvl)    = NVL(pi_rec_2.nsv_attrib64,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib65,c_nvl)    = NVL(pi_rec_2.nsv_attrib65,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib66,c_nvl)    = NVL(pi_rec_2.nsv_attrib66,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib67,c_nvl)    = NVL(pi_rec_2.nsv_attrib67,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib68,c_nvl)    = NVL(pi_rec_2.nsv_attrib68,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib69,c_nvl)    = NVL(pi_rec_2.nsv_attrib69,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib70,c_nvl)    = NVL(pi_rec_2.nsv_attrib70,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib71,c_nvl)    = NVL(pi_rec_2.nsv_attrib71,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib72,c_nvl)    = NVL(pi_rec_2.nsv_attrib72,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib73,c_nvl)    = NVL(pi_rec_2.nsv_attrib73,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib74,c_nvl)    = NVL(pi_rec_2.nsv_attrib74,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib75,c_nvl)    = NVL(pi_rec_2.nsv_attrib75,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib76,c_nvl)    = NVL(pi_rec_2.nsv_attrib76,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib77,c_nvl)    = NVL(pi_rec_2.nsv_attrib77,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib78,c_nvl)    = NVL(pi_rec_2.nsv_attrib78,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib79,c_nvl)    = NVL(pi_rec_2.nsv_attrib79,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib80,c_nvl)    = NVL(pi_rec_2.nsv_attrib80,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib81,c_nvl)    = NVL(pi_rec_2.nsv_attrib81,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib82,c_nvl)    = NVL(pi_rec_2.nsv_attrib82,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib83,c_nvl)    = NVL(pi_rec_2.nsv_attrib83,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib84,c_nvl)    = NVL(pi_rec_2.nsv_attrib84,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib85,c_nvl)    = NVL(pi_rec_2.nsv_attrib85,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib86,c_nvl)    = NVL(pi_rec_2.nsv_attrib86,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib87,c_nvl)    = NVL(pi_rec_2.nsv_attrib87,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib88,c_nvl)    = NVL(pi_rec_2.nsv_attrib88,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib89,c_nvl)    = NVL(pi_rec_2.nsv_attrib89,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib90,c_nvl)    = NVL(pi_rec_2.nsv_attrib90,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib91,c_nvl)    = NVL(pi_rec_2.nsv_attrib91,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib92,c_nvl)    = NVL(pi_rec_2.nsv_attrib92,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib93,c_nvl)    = NVL(pi_rec_2.nsv_attrib93,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib94,c_nvl)    = NVL(pi_rec_2.nsv_attrib94,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib95,c_nvl)    = NVL(pi_rec_2.nsv_attrib95,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib96,c_nvl)    = NVL(pi_rec_2.nsv_attrib96,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib97,c_nvl)    = NVL(pi_rec_2.nsv_attrib97,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib98,c_nvl)    = NVL(pi_rec_2.nsv_attrib98,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib99,c_nvl)    = NVL(pi_rec_2.nsv_attrib99,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib100,c_nvl)   = NVL(pi_rec_2.nsv_attrib100,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib101,c_nvl)   = NVL(pi_rec_2.nsv_attrib101,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib102,c_nvl)   = NVL(pi_rec_2.nsv_attrib102,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib103,c_nvl)   = NVL(pi_rec_2.nsv_attrib103,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib104,c_nvl)   = NVL(pi_rec_2.nsv_attrib104,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib105,c_nvl)   = NVL(pi_rec_2.nsv_attrib105,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib106,c_nvl)   = NVL(pi_rec_2.nsv_attrib106,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib107,c_nvl)   = NVL(pi_rec_2.nsv_attrib107,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib108,c_nvl)   = NVL(pi_rec_2.nsv_attrib108,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib109,c_nvl)   = NVL(pi_rec_2.nsv_attrib109,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib110,c_nvl)   = NVL(pi_rec_2.nsv_attrib110,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib111,c_nvl)   = NVL(pi_rec_2.nsv_attrib111,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib112,c_nvl)   = NVL(pi_rec_2.nsv_attrib112,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib113,c_nvl)   = NVL(pi_rec_2.nsv_attrib113,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib114,c_nvl)   = NVL(pi_rec_2.nsv_attrib114,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib115,c_nvl)   = NVL(pi_rec_2.nsv_attrib115,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib116,c_nvl)   = NVL(pi_rec_2.nsv_attrib116,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib117,c_nvl)   = NVL(pi_rec_2.nsv_attrib117,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib118,c_nvl)   = NVL(pi_rec_2.nsv_attrib118,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib119,c_nvl)   = NVL(pi_rec_2.nsv_attrib119,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib120,c_nvl)   = NVL(pi_rec_2.nsv_attrib120,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib121,c_nvl)   = NVL(pi_rec_2.nsv_attrib121,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib122,c_nvl)   = NVL(pi_rec_2.nsv_attrib122,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib123,c_nvl)   = NVL(pi_rec_2.nsv_attrib123,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib124,c_nvl)   = NVL(pi_rec_2.nsv_attrib124,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib125,c_nvl)   = NVL(pi_rec_2.nsv_attrib125,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib126,c_nvl)   = NVL(pi_rec_2.nsv_attrib126,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib127,c_nvl)   = NVL(pi_rec_2.nsv_attrib127,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib128,c_nvl)   = NVL(pi_rec_2.nsv_attrib128,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib129,c_nvl)   = NVL(pi_rec_2.nsv_attrib129,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib130,c_nvl)   = NVL(pi_rec_2.nsv_attrib130,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib131,c_nvl)   = NVL(pi_rec_2.nsv_attrib131,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib132,c_nvl)   = NVL(pi_rec_2.nsv_attrib132,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib133,c_nvl)   = NVL(pi_rec_2.nsv_attrib133,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib134,c_nvl)   = NVL(pi_rec_2.nsv_attrib134,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib135,c_nvl)   = NVL(pi_rec_2.nsv_attrib135,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib136,c_nvl)   = NVL(pi_rec_2.nsv_attrib136,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib137,c_nvl)   = NVL(pi_rec_2.nsv_attrib137,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib138,c_nvl)   = NVL(pi_rec_2.nsv_attrib138,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib139,c_nvl)   = NVL(pi_rec_2.nsv_attrib139,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib140,c_nvl)   = NVL(pi_rec_2.nsv_attrib140,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib141,c_nvl)   = NVL(pi_rec_2.nsv_attrib141,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib142,c_nvl)   = NVL(pi_rec_2.nsv_attrib142,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib143,c_nvl)   = NVL(pi_rec_2.nsv_attrib143,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib144,c_nvl)   = NVL(pi_rec_2.nsv_attrib144,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib145,c_nvl)   = NVL(pi_rec_2.nsv_attrib145,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib146,c_nvl)   = NVL(pi_rec_2.nsv_attrib146,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib147,c_nvl)   = NVL(pi_rec_2.nsv_attrib147,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib148,c_nvl)   = NVL(pi_rec_2.nsv_attrib148,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib149,c_nvl)   = NVL(pi_rec_2.nsv_attrib149,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib150,c_nvl)   = NVL(pi_rec_2.nsv_attrib150,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib151,c_nvl)   = NVL(pi_rec_2.nsv_attrib151,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib152,c_nvl)   = NVL(pi_rec_2.nsv_attrib152,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib153,c_nvl)   = NVL(pi_rec_2.nsv_attrib153,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib154,c_nvl)   = NVL(pi_rec_2.nsv_attrib154,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib155,c_nvl)   = NVL(pi_rec_2.nsv_attrib155,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib156,c_nvl)   = NVL(pi_rec_2.nsv_attrib156,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib157,c_nvl)   = NVL(pi_rec_2.nsv_attrib157,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib158,c_nvl)   = NVL(pi_rec_2.nsv_attrib158,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib159,c_nvl)   = NVL(pi_rec_2.nsv_attrib159,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib160,c_nvl)   = NVL(pi_rec_2.nsv_attrib160,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib161,c_nvl)   = NVL(pi_rec_2.nsv_attrib161,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib162,c_nvl)   = NVL(pi_rec_2.nsv_attrib162,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib163,c_nvl)   = NVL(pi_rec_2.nsv_attrib163,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib164,c_nvl)   = NVL(pi_rec_2.nsv_attrib164,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib165,c_nvl)   = NVL(pi_rec_2.nsv_attrib165,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib166,c_nvl)   = NVL(pi_rec_2.nsv_attrib166,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib167,c_nvl)   = NVL(pi_rec_2.nsv_attrib167,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib168,c_nvl)   = NVL(pi_rec_2.nsv_attrib168,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib169,c_nvl)   = NVL(pi_rec_2.nsv_attrib169,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib170,c_nvl)   = NVL(pi_rec_2.nsv_attrib170,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib171,c_nvl)   = NVL(pi_rec_2.nsv_attrib171,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib172,c_nvl)   = NVL(pi_rec_2.nsv_attrib172,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib173,c_nvl)   = NVL(pi_rec_2.nsv_attrib173,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib174,c_nvl)   = NVL(pi_rec_2.nsv_attrib174,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib175,c_nvl)   = NVL(pi_rec_2.nsv_attrib175,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib176,c_nvl)   = NVL(pi_rec_2.nsv_attrib176,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib177,c_nvl)   = NVL(pi_rec_2.nsv_attrib177,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib178,c_nvl)   = NVL(pi_rec_2.nsv_attrib178,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib179,c_nvl)   = NVL(pi_rec_2.nsv_attrib179,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib180,c_nvl)   = NVL(pi_rec_2.nsv_attrib180,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib181,c_nvl)   = NVL(pi_rec_2.nsv_attrib181,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib182,c_nvl)   = NVL(pi_rec_2.nsv_attrib182,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib183,c_nvl)   = NVL(pi_rec_2.nsv_attrib183,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib184,c_nvl)   = NVL(pi_rec_2.nsv_attrib184,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib185,c_nvl)   = NVL(pi_rec_2.nsv_attrib185,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib186,c_nvl)   = NVL(pi_rec_2.nsv_attrib186,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib187,c_nvl)   = NVL(pi_rec_2.nsv_attrib187,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib188,c_nvl)   = NVL(pi_rec_2.nsv_attrib188,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib189,c_nvl)   = NVL(pi_rec_2.nsv_attrib189,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib190,c_nvl)   = NVL(pi_rec_2.nsv_attrib190,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib191,c_nvl)   = NVL(pi_rec_2.nsv_attrib191,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib192,c_nvl)   = NVL(pi_rec_2.nsv_attrib192,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib193,c_nvl)   = NVL(pi_rec_2.nsv_attrib193,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib194,c_nvl)   = NVL(pi_rec_2.nsv_attrib194,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib195,c_nvl)   = NVL(pi_rec_2.nsv_attrib195,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib196,c_nvl)   = NVL(pi_rec_2.nsv_attrib196,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib197,c_nvl)   = NVL(pi_rec_2.nsv_attrib197,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib198,c_nvl)   = NVL(pi_rec_2.nsv_attrib198,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib199,c_nvl)   = NVL(pi_rec_2.nsv_attrib199,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib200,c_nvl)   = NVL(pi_rec_2.nsv_attrib200,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib201,c_nvl)   = NVL(pi_rec_2.nsv_attrib201,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib202,c_nvl)   = NVL(pi_rec_2.nsv_attrib202,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib203,c_nvl)   = NVL(pi_rec_2.nsv_attrib203,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib204,c_nvl)   = NVL(pi_rec_2.nsv_attrib204,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib205,c_nvl)   = NVL(pi_rec_2.nsv_attrib205,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib206,c_nvl)   = NVL(pi_rec_2.nsv_attrib206,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib207,c_nvl)   = NVL(pi_rec_2.nsv_attrib207,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib208,c_nvl)   = NVL(pi_rec_2.nsv_attrib208,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib209,c_nvl)   = NVL(pi_rec_2.nsv_attrib209,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib210,c_nvl)   = NVL(pi_rec_2.nsv_attrib210,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib211,c_nvl)   = NVL(pi_rec_2.nsv_attrib211,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib212,c_nvl)   = NVL(pi_rec_2.nsv_attrib212,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib213,c_nvl)   = NVL(pi_rec_2.nsv_attrib213,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib214,c_nvl)   = NVL(pi_rec_2.nsv_attrib214,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib215,c_nvl)   = NVL(pi_rec_2.nsv_attrib215,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib216,c_nvl)   = NVL(pi_rec_2.nsv_attrib216,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib217,c_nvl)   = NVL(pi_rec_2.nsv_attrib217,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib218,c_nvl)   = NVL(pi_rec_2.nsv_attrib218,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib219,c_nvl)   = NVL(pi_rec_2.nsv_attrib219,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib220,c_nvl)   = NVL(pi_rec_2.nsv_attrib220,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib221,c_nvl)   = NVL(pi_rec_2.nsv_attrib221,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib222,c_nvl)   = NVL(pi_rec_2.nsv_attrib222,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib223,c_nvl)   = NVL(pi_rec_2.nsv_attrib223,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib224,c_nvl)   = NVL(pi_rec_2.nsv_attrib224,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib225,c_nvl)   = NVL(pi_rec_2.nsv_attrib225,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib226,c_nvl)   = NVL(pi_rec_2.nsv_attrib226,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib227,c_nvl)   = NVL(pi_rec_2.nsv_attrib227,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib228,c_nvl)   = NVL(pi_rec_2.nsv_attrib228,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib229,c_nvl)   = NVL(pi_rec_2.nsv_attrib229,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib230,c_nvl)   = NVL(pi_rec_2.nsv_attrib230,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib231,c_nvl)   = NVL(pi_rec_2.nsv_attrib231,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib232,c_nvl)   = NVL(pi_rec_2.nsv_attrib232,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib233,c_nvl)   = NVL(pi_rec_2.nsv_attrib233,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib234,c_nvl)   = NVL(pi_rec_2.nsv_attrib234,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib235,c_nvl)   = NVL(pi_rec_2.nsv_attrib235,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib236,c_nvl)   = NVL(pi_rec_2.nsv_attrib236,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib237,c_nvl)   = NVL(pi_rec_2.nsv_attrib237,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib238,c_nvl)   = NVL(pi_rec_2.nsv_attrib238,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib239,c_nvl)   = NVL(pi_rec_2.nsv_attrib239,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib240,c_nvl)   = NVL(pi_rec_2.nsv_attrib240,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib241,c_nvl)   = NVL(pi_rec_2.nsv_attrib241,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib242,c_nvl)   = NVL(pi_rec_2.nsv_attrib242,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib243,c_nvl)   = NVL(pi_rec_2.nsv_attrib243,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib244,c_nvl)   = NVL(pi_rec_2.nsv_attrib244,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib245,c_nvl)   = NVL(pi_rec_2.nsv_attrib245,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib246,c_nvl)   = NVL(pi_rec_2.nsv_attrib246,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib247,c_nvl)   = NVL(pi_rec_2.nsv_attrib247,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib248,c_nvl)   = NVL(pi_rec_2.nsv_attrib248,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib249,c_nvl)   = NVL(pi_rec_2.nsv_attrib249,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib250,c_nvl)   = NVL(pi_rec_2.nsv_attrib250,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib251,c_nvl)   = NVL(pi_rec_2.nsv_attrib251,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib252,c_nvl)   = NVL(pi_rec_2.nsv_attrib252,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib253,c_nvl)   = NVL(pi_rec_2.nsv_attrib253,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib254,c_nvl)   = NVL(pi_rec_2.nsv_attrib254,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib255,c_nvl)   = NVL(pi_rec_2.nsv_attrib255,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib256,c_nvl)   = NVL(pi_rec_2.nsv_attrib256,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib257,c_nvl)   = NVL(pi_rec_2.nsv_attrib257,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib258,c_nvl)   = NVL(pi_rec_2.nsv_attrib258,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib259,c_nvl)   = NVL(pi_rec_2.nsv_attrib259,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib260,c_nvl)   = NVL(pi_rec_2.nsv_attrib260,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib261,c_nvl)   = NVL(pi_rec_2.nsv_attrib261,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib262,c_nvl)   = NVL(pi_rec_2.nsv_attrib262,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib263,c_nvl)   = NVL(pi_rec_2.nsv_attrib263,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib264,c_nvl)   = NVL(pi_rec_2.nsv_attrib264,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib265,c_nvl)   = NVL(pi_rec_2.nsv_attrib265,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib266,c_nvl)   = NVL(pi_rec_2.nsv_attrib266,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib267,c_nvl)   = NVL(pi_rec_2.nsv_attrib267,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib268,c_nvl)   = NVL(pi_rec_2.nsv_attrib268,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib269,c_nvl)   = NVL(pi_rec_2.nsv_attrib269,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib270,c_nvl)   = NVL(pi_rec_2.nsv_attrib270,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib271,c_nvl)   = NVL(pi_rec_2.nsv_attrib271,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib272,c_nvl)   = NVL(pi_rec_2.nsv_attrib272,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib273,c_nvl)   = NVL(pi_rec_2.nsv_attrib273,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib274,c_nvl)   = NVL(pi_rec_2.nsv_attrib274,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib275,c_nvl)   = NVL(pi_rec_2.nsv_attrib275,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib276,c_nvl)   = NVL(pi_rec_2.nsv_attrib276,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib277,c_nvl)   = NVL(pi_rec_2.nsv_attrib277,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib278,c_nvl)   = NVL(pi_rec_2.nsv_attrib278,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib279,c_nvl)   = NVL(pi_rec_2.nsv_attrib279,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib280,c_nvl)   = NVL(pi_rec_2.nsv_attrib280,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib281,c_nvl)   = NVL(pi_rec_2.nsv_attrib281,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib282,c_nvl)   = NVL(pi_rec_2.nsv_attrib282,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib283,c_nvl)   = NVL(pi_rec_2.nsv_attrib283,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib284,c_nvl)   = NVL(pi_rec_2.nsv_attrib284,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib285,c_nvl)   = NVL(pi_rec_2.nsv_attrib285,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib286,c_nvl)   = NVL(pi_rec_2.nsv_attrib286,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib287,c_nvl)   = NVL(pi_rec_2.nsv_attrib287,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib288,c_nvl)   = NVL(pi_rec_2.nsv_attrib288,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib289,c_nvl)   = NVL(pi_rec_2.nsv_attrib289,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib290,c_nvl)   = NVL(pi_rec_2.nsv_attrib290,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib291,c_nvl)   = NVL(pi_rec_2.nsv_attrib291,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib292,c_nvl)   = NVL(pi_rec_2.nsv_attrib292,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib293,c_nvl)   = NVL(pi_rec_2.nsv_attrib293,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib294,c_nvl)   = NVL(pi_rec_2.nsv_attrib294,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib295,c_nvl)   = NVL(pi_rec_2.nsv_attrib295,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib296,c_nvl)   = NVL(pi_rec_2.nsv_attrib296,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib297,c_nvl)   = NVL(pi_rec_2.nsv_attrib297,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib298,c_nvl)   = NVL(pi_rec_2.nsv_attrib298,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib299,c_nvl)   = NVL(pi_rec_2.nsv_attrib299,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib300,c_nvl)   = NVL(pi_rec_2.nsv_attrib300,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib301,c_nvl)   = NVL(pi_rec_2.nsv_attrib301,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib302,c_nvl)   = NVL(pi_rec_2.nsv_attrib302,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib303,c_nvl)   = NVL(pi_rec_2.nsv_attrib303,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib304,c_nvl)   = NVL(pi_rec_2.nsv_attrib304,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib305,c_nvl)   = NVL(pi_rec_2.nsv_attrib305,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib306,c_nvl)   = NVL(pi_rec_2.nsv_attrib306,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib307,c_nvl)   = NVL(pi_rec_2.nsv_attrib307,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib308,c_nvl)   = NVL(pi_rec_2.nsv_attrib308,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib309,c_nvl)   = NVL(pi_rec_2.nsv_attrib309,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib310,c_nvl)   = NVL(pi_rec_2.nsv_attrib310,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib311,c_nvl)   = NVL(pi_rec_2.nsv_attrib311,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib312,c_nvl)   = NVL(pi_rec_2.nsv_attrib312,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib313,c_nvl)   = NVL(pi_rec_2.nsv_attrib313,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib314,c_nvl)   = NVL(pi_rec_2.nsv_attrib314,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib315,c_nvl)   = NVL(pi_rec_2.nsv_attrib315,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib316,c_nvl)   = NVL(pi_rec_2.nsv_attrib316,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib317,c_nvl)   = NVL(pi_rec_2.nsv_attrib317,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib318,c_nvl)   = NVL(pi_rec_2.nsv_attrib318,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib319,c_nvl)   = NVL(pi_rec_2.nsv_attrib319,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib320,c_nvl)   = NVL(pi_rec_2.nsv_attrib320,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib321,c_nvl)   = NVL(pi_rec_2.nsv_attrib321,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib322,c_nvl)   = NVL(pi_rec_2.nsv_attrib322,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib323,c_nvl)   = NVL(pi_rec_2.nsv_attrib323,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib324,c_nvl)   = NVL(pi_rec_2.nsv_attrib324,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib325,c_nvl)   = NVL(pi_rec_2.nsv_attrib325,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib326,c_nvl)   = NVL(pi_rec_2.nsv_attrib326,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib327,c_nvl)   = NVL(pi_rec_2.nsv_attrib327,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib328,c_nvl)   = NVL(pi_rec_2.nsv_attrib328,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib329,c_nvl)   = NVL(pi_rec_2.nsv_attrib329,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib330,c_nvl)   = NVL(pi_rec_2.nsv_attrib330,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib331,c_nvl)   = NVL(pi_rec_2.nsv_attrib331,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib332,c_nvl)   = NVL(pi_rec_2.nsv_attrib332,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib333,c_nvl)   = NVL(pi_rec_2.nsv_attrib333,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib334,c_nvl)   = NVL(pi_rec_2.nsv_attrib334,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib335,c_nvl)   = NVL(pi_rec_2.nsv_attrib335,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib336,c_nvl)   = NVL(pi_rec_2.nsv_attrib336,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib337,c_nvl)   = NVL(pi_rec_2.nsv_attrib337,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib338,c_nvl)   = NVL(pi_rec_2.nsv_attrib338,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib339,c_nvl)   = NVL(pi_rec_2.nsv_attrib339,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib340,c_nvl)   = NVL(pi_rec_2.nsv_attrib340,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib341,c_nvl)   = NVL(pi_rec_2.nsv_attrib341,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib342,c_nvl)   = NVL(pi_rec_2.nsv_attrib342,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib343,c_nvl)   = NVL(pi_rec_2.nsv_attrib343,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib344,c_nvl)   = NVL(pi_rec_2.nsv_attrib344,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib345,c_nvl)   = NVL(pi_rec_2.nsv_attrib345,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib346,c_nvl)   = NVL(pi_rec_2.nsv_attrib346,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib347,c_nvl)   = NVL(pi_rec_2.nsv_attrib347,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib348,c_nvl)   = NVL(pi_rec_2.nsv_attrib348,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib349,c_nvl)   = NVL(pi_rec_2.nsv_attrib349,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib350,c_nvl)   = NVL(pi_rec_2.nsv_attrib350,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib351,c_nvl)   = NVL(pi_rec_2.nsv_attrib351,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib352,c_nvl)   = NVL(pi_rec_2.nsv_attrib352,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib353,c_nvl)   = NVL(pi_rec_2.nsv_attrib353,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib354,c_nvl)   = NVL(pi_rec_2.nsv_attrib354,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib355,c_nvl)   = NVL(pi_rec_2.nsv_attrib355,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib356,c_nvl)   = NVL(pi_rec_2.nsv_attrib356,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib357,c_nvl)   = NVL(pi_rec_2.nsv_attrib357,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib358,c_nvl)   = NVL(pi_rec_2.nsv_attrib358,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib359,c_nvl)   = NVL(pi_rec_2.nsv_attrib359,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib360,c_nvl)   = NVL(pi_rec_2.nsv_attrib360,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib361,c_nvl)   = NVL(pi_rec_2.nsv_attrib361,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib362,c_nvl)   = NVL(pi_rec_2.nsv_attrib362,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib363,c_nvl)   = NVL(pi_rec_2.nsv_attrib363,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib364,c_nvl)   = NVL(pi_rec_2.nsv_attrib364,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib365,c_nvl)   = NVL(pi_rec_2.nsv_attrib365,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib366,c_nvl)   = NVL(pi_rec_2.nsv_attrib366,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib367,c_nvl)   = NVL(pi_rec_2.nsv_attrib367,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib368,c_nvl)   = NVL(pi_rec_2.nsv_attrib368,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib369,c_nvl)   = NVL(pi_rec_2.nsv_attrib369,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib370,c_nvl)   = NVL(pi_rec_2.nsv_attrib370,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib371,c_nvl)   = NVL(pi_rec_2.nsv_attrib371,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib372,c_nvl)   = NVL(pi_rec_2.nsv_attrib372,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib373,c_nvl)   = NVL(pi_rec_2.nsv_attrib373,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib374,c_nvl)   = NVL(pi_rec_2.nsv_attrib374,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib375,c_nvl)   = NVL(pi_rec_2.nsv_attrib375,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib376,c_nvl)   = NVL(pi_rec_2.nsv_attrib376,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib377,c_nvl)   = NVL(pi_rec_2.nsv_attrib377,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib378,c_nvl)   = NVL(pi_rec_2.nsv_attrib378,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib379,c_nvl)   = NVL(pi_rec_2.nsv_attrib379,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib380,c_nvl)   = NVL(pi_rec_2.nsv_attrib380,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib381,c_nvl)   = NVL(pi_rec_2.nsv_attrib381,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib382,c_nvl)   = NVL(pi_rec_2.nsv_attrib382,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib383,c_nvl)   = NVL(pi_rec_2.nsv_attrib383,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib384,c_nvl)   = NVL(pi_rec_2.nsv_attrib384,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib385,c_nvl)   = NVL(pi_rec_2.nsv_attrib385,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib386,c_nvl)   = NVL(pi_rec_2.nsv_attrib386,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib387,c_nvl)   = NVL(pi_rec_2.nsv_attrib387,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib388,c_nvl)   = NVL(pi_rec_2.nsv_attrib388,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib389,c_nvl)   = NVL(pi_rec_2.nsv_attrib389,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib390,c_nvl)   = NVL(pi_rec_2.nsv_attrib390,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib391,c_nvl)   = NVL(pi_rec_2.nsv_attrib391,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib392,c_nvl)   = NVL(pi_rec_2.nsv_attrib392,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib393,c_nvl)   = NVL(pi_rec_2.nsv_attrib393,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib394,c_nvl)   = NVL(pi_rec_2.nsv_attrib394,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib395,c_nvl)   = NVL(pi_rec_2.nsv_attrib395,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib396,c_nvl)   = NVL(pi_rec_2.nsv_attrib396,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib397,c_nvl)   = NVL(pi_rec_2.nsv_attrib397,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib398,c_nvl)   = NVL(pi_rec_2.nsv_attrib398,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib399,c_nvl)   = NVL(pi_rec_2.nsv_attrib399,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib400,c_nvl)   = NVL(pi_rec_2.nsv_attrib400,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib401,c_nvl)   = NVL(pi_rec_2.nsv_attrib401,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib402,c_nvl)   = NVL(pi_rec_2.nsv_attrib402,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib403,c_nvl)   = NVL(pi_rec_2.nsv_attrib403,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib404,c_nvl)   = NVL(pi_rec_2.nsv_attrib404,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib405,c_nvl)   = NVL(pi_rec_2.nsv_attrib405,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib406,c_nvl)   = NVL(pi_rec_2.nsv_attrib406,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib407,c_nvl)   = NVL(pi_rec_2.nsv_attrib407,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib408,c_nvl)   = NVL(pi_rec_2.nsv_attrib408,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib409,c_nvl)   = NVL(pi_rec_2.nsv_attrib409,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib410,c_nvl)   = NVL(pi_rec_2.nsv_attrib410,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib411,c_nvl)   = NVL(pi_rec_2.nsv_attrib411,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib412,c_nvl)   = NVL(pi_rec_2.nsv_attrib412,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib413,c_nvl)   = NVL(pi_rec_2.nsv_attrib413,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib414,c_nvl)   = NVL(pi_rec_2.nsv_attrib414,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib415,c_nvl)   = NVL(pi_rec_2.nsv_attrib415,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib416,c_nvl)   = NVL(pi_rec_2.nsv_attrib416,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib417,c_nvl)   = NVL(pi_rec_2.nsv_attrib417,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib418,c_nvl)   = NVL(pi_rec_2.nsv_attrib418,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib419,c_nvl)   = NVL(pi_rec_2.nsv_attrib419,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib420,c_nvl)   = NVL(pi_rec_2.nsv_attrib420,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib421,c_nvl)   = NVL(pi_rec_2.nsv_attrib421,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib422,c_nvl)   = NVL(pi_rec_2.nsv_attrib422,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib423,c_nvl)   = NVL(pi_rec_2.nsv_attrib423,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib424,c_nvl)   = NVL(pi_rec_2.nsv_attrib424,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib425,c_nvl)   = NVL(pi_rec_2.nsv_attrib425,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib426,c_nvl)   = NVL(pi_rec_2.nsv_attrib426,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib427,c_nvl)   = NVL(pi_rec_2.nsv_attrib427,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib428,c_nvl)   = NVL(pi_rec_2.nsv_attrib428,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib429,c_nvl)   = NVL(pi_rec_2.nsv_attrib429,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib430,c_nvl)   = NVL(pi_rec_2.nsv_attrib430,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib431,c_nvl)   = NVL(pi_rec_2.nsv_attrib431,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib432,c_nvl)   = NVL(pi_rec_2.nsv_attrib432,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib433,c_nvl)   = NVL(pi_rec_2.nsv_attrib433,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib434,c_nvl)   = NVL(pi_rec_2.nsv_attrib434,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib435,c_nvl)   = NVL(pi_rec_2.nsv_attrib435,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib436,c_nvl)   = NVL(pi_rec_2.nsv_attrib436,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib437,c_nvl)   = NVL(pi_rec_2.nsv_attrib437,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib438,c_nvl)   = NVL(pi_rec_2.nsv_attrib438,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib439,c_nvl)   = NVL(pi_rec_2.nsv_attrib439,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib440,c_nvl)   = NVL(pi_rec_2.nsv_attrib440,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib441,c_nvl)   = NVL(pi_rec_2.nsv_attrib441,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib442,c_nvl)   = NVL(pi_rec_2.nsv_attrib442,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib443,c_nvl)   = NVL(pi_rec_2.nsv_attrib443,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib444,c_nvl)   = NVL(pi_rec_2.nsv_attrib444,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib445,c_nvl)   = NVL(pi_rec_2.nsv_attrib445,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib446,c_nvl)   = NVL(pi_rec_2.nsv_attrib446,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib447,c_nvl)   = NVL(pi_rec_2.nsv_attrib447,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib448,c_nvl)   = NVL(pi_rec_2.nsv_attrib448,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib449,c_nvl)   = NVL(pi_rec_2.nsv_attrib449,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib450,c_nvl)   = NVL(pi_rec_2.nsv_attrib450,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib451,c_nvl)   = NVL(pi_rec_2.nsv_attrib451,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib452,c_nvl)   = NVL(pi_rec_2.nsv_attrib452,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib453,c_nvl)   = NVL(pi_rec_2.nsv_attrib453,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib454,c_nvl)   = NVL(pi_rec_2.nsv_attrib454,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib455,c_nvl)   = NVL(pi_rec_2.nsv_attrib455,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib456,c_nvl)   = NVL(pi_rec_2.nsv_attrib456,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib457,c_nvl)   = NVL(pi_rec_2.nsv_attrib457,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib458,c_nvl)   = NVL(pi_rec_2.nsv_attrib458,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib459,c_nvl)   = NVL(pi_rec_2.nsv_attrib459,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib460,c_nvl)   = NVL(pi_rec_2.nsv_attrib460,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib461,c_nvl)   = NVL(pi_rec_2.nsv_attrib461,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib462,c_nvl)   = NVL(pi_rec_2.nsv_attrib462,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib463,c_nvl)   = NVL(pi_rec_2.nsv_attrib463,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib464,c_nvl)   = NVL(pi_rec_2.nsv_attrib464,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib465,c_nvl)   = NVL(pi_rec_2.nsv_attrib465,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib466,c_nvl)   = NVL(pi_rec_2.nsv_attrib466,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib467,c_nvl)   = NVL(pi_rec_2.nsv_attrib467,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib468,c_nvl)   = NVL(pi_rec_2.nsv_attrib468,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib469,c_nvl)   = NVL(pi_rec_2.nsv_attrib469,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib470,c_nvl)   = NVL(pi_rec_2.nsv_attrib470,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib471,c_nvl)   = NVL(pi_rec_2.nsv_attrib471,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib472,c_nvl)   = NVL(pi_rec_2.nsv_attrib472,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib473,c_nvl)   = NVL(pi_rec_2.nsv_attrib473,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib474,c_nvl)   = NVL(pi_rec_2.nsv_attrib474,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib475,c_nvl)   = NVL(pi_rec_2.nsv_attrib475,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib476,c_nvl)   = NVL(pi_rec_2.nsv_attrib476,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib477,c_nvl)   = NVL(pi_rec_2.nsv_attrib477,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib478,c_nvl)   = NVL(pi_rec_2.nsv_attrib478,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib479,c_nvl)   = NVL(pi_rec_2.nsv_attrib479,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib480,c_nvl)   = NVL(pi_rec_2.nsv_attrib480,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib481,c_nvl)   = NVL(pi_rec_2.nsv_attrib481,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib482,c_nvl)   = NVL(pi_rec_2.nsv_attrib482,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib483,c_nvl)   = NVL(pi_rec_2.nsv_attrib483,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib484,c_nvl)   = NVL(pi_rec_2.nsv_attrib484,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib485,c_nvl)   = NVL(pi_rec_2.nsv_attrib485,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib486,c_nvl)   = NVL(pi_rec_2.nsv_attrib486,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib487,c_nvl)   = NVL(pi_rec_2.nsv_attrib487,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib488,c_nvl)   = NVL(pi_rec_2.nsv_attrib488,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib489,c_nvl)   = NVL(pi_rec_2.nsv_attrib489,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib490,c_nvl)   = NVL(pi_rec_2.nsv_attrib490,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib491,c_nvl)   = NVL(pi_rec_2.nsv_attrib491,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib492,c_nvl)   = NVL(pi_rec_2.nsv_attrib492,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib493,c_nvl)   = NVL(pi_rec_2.nsv_attrib493,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib494,c_nvl)   = NVL(pi_rec_2.nsv_attrib494,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib495,c_nvl)   = NVL(pi_rec_2.nsv_attrib495,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib496,c_nvl)   = NVL(pi_rec_2.nsv_attrib496,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib497,c_nvl)   = NVL(pi_rec_2.nsv_attrib497,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib498,c_nvl)   = NVL(pi_rec_2.nsv_attrib498,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib499,c_nvl)   = NVL(pi_rec_2.nsv_attrib499,c_nvl)
           AND NVL(pi_rec_1.nsv_attrib500,c_nvl)   = NVL(pi_rec_2.nsv_attrib500,c_nvl);
--
END compare_rec_nsv;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE assess_inner_join (pi_job_id       IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                            ) IS
--
   l_sql_string       long;
   l_dyn_sql_rowcount binary_integer;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'assess_inner_join');
--
--
   IF  nm3mrg.g_rec_query.nmq_inner_outer_join      = 'O'
    OR nm3mrg.g_rec_query.nmq_inv_type_x_sect_count = 1
    THEN -- If an outer join or there is only 1 inv_type/xsp defined
         -- then all results are required so update then exit this procedure
--
      UPDATE nm_mrg_sections
       SET   nms_in_results = 'Y'
      WHERE  nms_mrg_job_id = pi_job_id;
--
      nm_debug.proc_end(g_package_name,'assess_inner_join');
--
      RETURN;
--
   END IF;
--
-- This is an inner join so update the matching values to 'Y'
--
   l_sql_string :=            'UPDATE nm_mrg_sections nms'
                   ||CHR(10)||' SET   nms.nms_in_results = '||nm3flx.string('Y')
                   ||CHR(10)||'WHERE  nms.nms_mrg_job_id = '||pi_job_id;
--
   FOR l_count IN 1..nm3mrg.g_tab_rec_query_types.COUNT
    LOOP
--
--      IF g_tab_rec_nit(l_count).nit_pnt_or_cont = 'C'
--       THEN
--
         l_sql_string := l_sql_string
                         ||CHR(10)||' AND   EXISTS (SELECT 1'
                         ||CHR(10)||'                FROM  nm_mrg_section_member_inv nmsmi'
                         ||CHR(10)||'               WHERE  nmsmi.nsi_mrg_job_id     = nms.nms_mrg_job_id'
                         ||CHR(10)||'                AND   nmsmi.nsi_mrg_section_id = nms.nms_mrg_section_id'
                         ||CHR(10)||'                AND   nmsmi.nsi_inv_type       = '
                                                         ||nm3flx.string(nm3mrg.g_tab_rec_query_types(l_count).nqt_inv_type);
--
         IF nm3mrg.g_tab_rec_query_types(l_count).nqt_x_sect IS NOT NULL
          THEN
            l_sql_string := l_sql_string
                            ||CHR(10)||'                AND   nmsmi.nsi_x_sect         LIKE '
                                                         ||nm3flx.string(nm3mrg.g_tab_rec_query_types(l_count).nqt_x_sect);
         END IF;
--
         l_sql_string := l_sql_string
                         ||CHR(10)||'              )';
--
--      END IF;
--
   END LOOP;
--
   l_dyn_sql_rowcount := nm3mrg.execute_sql(l_sql_string);
--
-- Get rid of any contiguous sections which are not in the inner join
--
   DELETE FROM nm_mrg_sections
   WHERE  nms_mrg_job_id = pi_job_id
    AND   nms_in_results = 'N';
--
   nm_debug.proc_end(g_package_name,'assess_inner_join');
--
END assess_inner_join;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE pop_rec_nsv_from_cs_distinct
                            (pi_rowtype IN     rec_distinct
                            ,po_rec_nsv IN OUT nm_mrg_section_inv_values%ROWTYPE
                            ) IS
BEGIN
--
   po_rec_nsv.nsv_inv_type    := pi_rowtype.inv_type;
   po_rec_nsv.nsv_x_sect      := pi_rowtype.x_sect;
   po_rec_nsv.nsv_pnt_or_cont := pi_rowtype.pnt_or_cont;
   po_rec_nsv.nsv_attrib1     := pi_rowtype.attrib1;
   po_rec_nsv.nsv_attrib2     := pi_rowtype.attrib2;
   po_rec_nsv.nsv_attrib3     := pi_rowtype.attrib3;
   po_rec_nsv.nsv_attrib4     := pi_rowtype.attrib4;
   po_rec_nsv.nsv_attrib5     := pi_rowtype.attrib5;
   po_rec_nsv.nsv_attrib6     := pi_rowtype.attrib6;
   po_rec_nsv.nsv_attrib7     := pi_rowtype.attrib7;
   po_rec_nsv.nsv_attrib8     := pi_rowtype.attrib8;
   po_rec_nsv.nsv_attrib9     := pi_rowtype.attrib9;
   po_rec_nsv.nsv_attrib10    := pi_rowtype.attrib10;
   po_rec_nsv.nsv_attrib11    := pi_rowtype.attrib11;
   po_rec_nsv.nsv_attrib12    := pi_rowtype.attrib12;
   po_rec_nsv.nsv_attrib13    := pi_rowtype.attrib13;
   po_rec_nsv.nsv_attrib14    := pi_rowtype.attrib14;
   po_rec_nsv.nsv_attrib15    := pi_rowtype.attrib15;
   po_rec_nsv.nsv_attrib16    := pi_rowtype.attrib16;
   po_rec_nsv.nsv_attrib17    := pi_rowtype.attrib17;
   po_rec_nsv.nsv_attrib18    := pi_rowtype.attrib18;
   po_rec_nsv.nsv_attrib19    := pi_rowtype.attrib19;
   po_rec_nsv.nsv_attrib20    := pi_rowtype.attrib20;
   po_rec_nsv.nsv_attrib21    := pi_rowtype.attrib21;
   po_rec_nsv.nsv_attrib22    := pi_rowtype.attrib22;
   po_rec_nsv.nsv_attrib23    := pi_rowtype.attrib23;
   po_rec_nsv.nsv_attrib24    := pi_rowtype.attrib24;
   po_rec_nsv.nsv_attrib25    := pi_rowtype.attrib25;
   po_rec_nsv.nsv_attrib26    := pi_rowtype.attrib26;
   po_rec_nsv.nsv_attrib27    := pi_rowtype.attrib27;
   po_rec_nsv.nsv_attrib28    := pi_rowtype.attrib28;
   po_rec_nsv.nsv_attrib29    := pi_rowtype.attrib29;
   po_rec_nsv.nsv_attrib30    := pi_rowtype.attrib30;
   po_rec_nsv.nsv_attrib31    := pi_rowtype.attrib31;
   po_rec_nsv.nsv_attrib32    := pi_rowtype.attrib32;
   po_rec_nsv.nsv_attrib33    := pi_rowtype.attrib33;
   po_rec_nsv.nsv_attrib34    := pi_rowtype.attrib34;
   po_rec_nsv.nsv_attrib35    := pi_rowtype.attrib35;
   po_rec_nsv.nsv_attrib36    := pi_rowtype.attrib36;
   po_rec_nsv.nsv_attrib37    := pi_rowtype.attrib37;
   po_rec_nsv.nsv_attrib38    := pi_rowtype.attrib38;
   po_rec_nsv.nsv_attrib39    := pi_rowtype.attrib39;
   po_rec_nsv.nsv_attrib40    := pi_rowtype.attrib40;
   po_rec_nsv.nsv_attrib41    := pi_rowtype.attrib41;
   po_rec_nsv.nsv_attrib42    := pi_rowtype.attrib42;
   po_rec_nsv.nsv_attrib43    := pi_rowtype.attrib43;
   po_rec_nsv.nsv_attrib44    := pi_rowtype.attrib44;
   po_rec_nsv.nsv_attrib45    := pi_rowtype.attrib45;
   po_rec_nsv.nsv_attrib46    := pi_rowtype.attrib46;
   po_rec_nsv.nsv_attrib47    := pi_rowtype.attrib47;
   po_rec_nsv.nsv_attrib48    := pi_rowtype.attrib48;
   po_rec_nsv.nsv_attrib49    := pi_rowtype.attrib49;
   po_rec_nsv.nsv_attrib50    := pi_rowtype.attrib50;
   po_rec_nsv.nsv_attrib51    := pi_rowtype.attrib51;
   po_rec_nsv.nsv_attrib52    := pi_rowtype.attrib52;
   po_rec_nsv.nsv_attrib53    := pi_rowtype.attrib53;
   po_rec_nsv.nsv_attrib54    := pi_rowtype.attrib54;
   po_rec_nsv.nsv_attrib55    := pi_rowtype.attrib55;
   po_rec_nsv.nsv_attrib56    := pi_rowtype.attrib56;
   po_rec_nsv.nsv_attrib57    := pi_rowtype.attrib57;
   po_rec_nsv.nsv_attrib58    := pi_rowtype.attrib58;
   po_rec_nsv.nsv_attrib59    := pi_rowtype.attrib59;
   po_rec_nsv.nsv_attrib60    := pi_rowtype.attrib60;
   po_rec_nsv.nsv_attrib61    := pi_rowtype.attrib61;
   po_rec_nsv.nsv_attrib62    := pi_rowtype.attrib62;
   po_rec_nsv.nsv_attrib63    := pi_rowtype.attrib63;
   po_rec_nsv.nsv_attrib64    := pi_rowtype.attrib64;
   po_rec_nsv.nsv_attrib65    := pi_rowtype.attrib65;
   po_rec_nsv.nsv_attrib66    := pi_rowtype.attrib66;
   po_rec_nsv.nsv_attrib67    := pi_rowtype.attrib67;
   po_rec_nsv.nsv_attrib68    := pi_rowtype.attrib68;
   po_rec_nsv.nsv_attrib69    := pi_rowtype.attrib69;
   po_rec_nsv.nsv_attrib70    := pi_rowtype.attrib70;
   po_rec_nsv.nsv_attrib71    := pi_rowtype.attrib71;
   po_rec_nsv.nsv_attrib72    := pi_rowtype.attrib72;
   po_rec_nsv.nsv_attrib73    := pi_rowtype.attrib73;
   po_rec_nsv.nsv_attrib74    := pi_rowtype.attrib74;
   po_rec_nsv.nsv_attrib75    := pi_rowtype.attrib75;
   po_rec_nsv.nsv_attrib76    := pi_rowtype.attrib76;
   po_rec_nsv.nsv_attrib77    := pi_rowtype.attrib77;
   po_rec_nsv.nsv_attrib78    := pi_rowtype.attrib78;
   po_rec_nsv.nsv_attrib79    := pi_rowtype.attrib79;
   po_rec_nsv.nsv_attrib80    := pi_rowtype.attrib80;
   po_rec_nsv.nsv_attrib81    := pi_rowtype.attrib81;
   po_rec_nsv.nsv_attrib82    := pi_rowtype.attrib82;
   po_rec_nsv.nsv_attrib83    := pi_rowtype.attrib83;
   po_rec_nsv.nsv_attrib84    := pi_rowtype.attrib84;
   po_rec_nsv.nsv_attrib85    := pi_rowtype.attrib85;
   po_rec_nsv.nsv_attrib86    := pi_rowtype.attrib86;
   po_rec_nsv.nsv_attrib87    := pi_rowtype.attrib87;
   po_rec_nsv.nsv_attrib88    := pi_rowtype.attrib88;
   po_rec_nsv.nsv_attrib89    := pi_rowtype.attrib89;
   po_rec_nsv.nsv_attrib90    := pi_rowtype.attrib90;
   po_rec_nsv.nsv_attrib91    := pi_rowtype.attrib91;
   po_rec_nsv.nsv_attrib92    := pi_rowtype.attrib92;
   po_rec_nsv.nsv_attrib93    := pi_rowtype.attrib93;
   po_rec_nsv.nsv_attrib94    := pi_rowtype.attrib94;
   po_rec_nsv.nsv_attrib95    := pi_rowtype.attrib95;
   po_rec_nsv.nsv_attrib96    := pi_rowtype.attrib96;
   po_rec_nsv.nsv_attrib97    := pi_rowtype.attrib97;
   po_rec_nsv.nsv_attrib98    := pi_rowtype.attrib98;
   po_rec_nsv.nsv_attrib99    := pi_rowtype.attrib99;
   po_rec_nsv.nsv_attrib100   := pi_rowtype.attrib100;
   po_rec_nsv.nsv_attrib101   := pi_rowtype.attrib101;
   po_rec_nsv.nsv_attrib102   := pi_rowtype.attrib102;
   po_rec_nsv.nsv_attrib103   := pi_rowtype.attrib103;
   po_rec_nsv.nsv_attrib104   := pi_rowtype.attrib104;
   po_rec_nsv.nsv_attrib105   := pi_rowtype.attrib105;
   po_rec_nsv.nsv_attrib106   := pi_rowtype.attrib106;
   po_rec_nsv.nsv_attrib107   := pi_rowtype.attrib107;
   po_rec_nsv.nsv_attrib108   := pi_rowtype.attrib108;
   po_rec_nsv.nsv_attrib109   := pi_rowtype.attrib109;
   po_rec_nsv.nsv_attrib110   := pi_rowtype.attrib110;
   po_rec_nsv.nsv_attrib111   := pi_rowtype.attrib111;
   po_rec_nsv.nsv_attrib112   := pi_rowtype.attrib112;
   po_rec_nsv.nsv_attrib113   := pi_rowtype.attrib113;
   po_rec_nsv.nsv_attrib114   := pi_rowtype.attrib114;
   po_rec_nsv.nsv_attrib115   := pi_rowtype.attrib115;
   po_rec_nsv.nsv_attrib116   := pi_rowtype.attrib116;
   po_rec_nsv.nsv_attrib117   := pi_rowtype.attrib117;
   po_rec_nsv.nsv_attrib118   := pi_rowtype.attrib118;
   po_rec_nsv.nsv_attrib119   := pi_rowtype.attrib119;
   po_rec_nsv.nsv_attrib120   := pi_rowtype.attrib120;
   po_rec_nsv.nsv_attrib121   := pi_rowtype.attrib121;
   po_rec_nsv.nsv_attrib122   := pi_rowtype.attrib122;
   po_rec_nsv.nsv_attrib123   := pi_rowtype.attrib123;
   po_rec_nsv.nsv_attrib124   := pi_rowtype.attrib124;
   po_rec_nsv.nsv_attrib125   := pi_rowtype.attrib125;
   po_rec_nsv.nsv_attrib126   := pi_rowtype.attrib126;
   po_rec_nsv.nsv_attrib127   := pi_rowtype.attrib127;
   po_rec_nsv.nsv_attrib128   := pi_rowtype.attrib128;
   po_rec_nsv.nsv_attrib129   := pi_rowtype.attrib129;
   po_rec_nsv.nsv_attrib130   := pi_rowtype.attrib130;
   po_rec_nsv.nsv_attrib131   := pi_rowtype.attrib131;
   po_rec_nsv.nsv_attrib132   := pi_rowtype.attrib132;
   po_rec_nsv.nsv_attrib133   := pi_rowtype.attrib133;
   po_rec_nsv.nsv_attrib134   := pi_rowtype.attrib134;
   po_rec_nsv.nsv_attrib135   := pi_rowtype.attrib135;
   po_rec_nsv.nsv_attrib136   := pi_rowtype.attrib136;
   po_rec_nsv.nsv_attrib137   := pi_rowtype.attrib137;
   po_rec_nsv.nsv_attrib138   := pi_rowtype.attrib138;
   po_rec_nsv.nsv_attrib139   := pi_rowtype.attrib139;
   po_rec_nsv.nsv_attrib140   := pi_rowtype.attrib140;
   po_rec_nsv.nsv_attrib141   := pi_rowtype.attrib141;
   po_rec_nsv.nsv_attrib142   := pi_rowtype.attrib142;
   po_rec_nsv.nsv_attrib143   := pi_rowtype.attrib143;
   po_rec_nsv.nsv_attrib144   := pi_rowtype.attrib144;
   po_rec_nsv.nsv_attrib145   := pi_rowtype.attrib145;
   po_rec_nsv.nsv_attrib146   := pi_rowtype.attrib146;
   po_rec_nsv.nsv_attrib147   := pi_rowtype.attrib147;
   po_rec_nsv.nsv_attrib148   := pi_rowtype.attrib148;
   po_rec_nsv.nsv_attrib149   := pi_rowtype.attrib149;
   po_rec_nsv.nsv_attrib150   := pi_rowtype.attrib150;
   po_rec_nsv.nsv_attrib151   := pi_rowtype.attrib151;
   po_rec_nsv.nsv_attrib152   := pi_rowtype.attrib152;
   po_rec_nsv.nsv_attrib153   := pi_rowtype.attrib153;
   po_rec_nsv.nsv_attrib154   := pi_rowtype.attrib154;
   po_rec_nsv.nsv_attrib155   := pi_rowtype.attrib155;
   po_rec_nsv.nsv_attrib156   := pi_rowtype.attrib156;
   po_rec_nsv.nsv_attrib157   := pi_rowtype.attrib157;
   po_rec_nsv.nsv_attrib158   := pi_rowtype.attrib158;
   po_rec_nsv.nsv_attrib159   := pi_rowtype.attrib159;
   po_rec_nsv.nsv_attrib160   := pi_rowtype.attrib160;
   po_rec_nsv.nsv_attrib161   := pi_rowtype.attrib161;
   po_rec_nsv.nsv_attrib162   := pi_rowtype.attrib162;
   po_rec_nsv.nsv_attrib163   := pi_rowtype.attrib163;
   po_rec_nsv.nsv_attrib164   := pi_rowtype.attrib164;
   po_rec_nsv.nsv_attrib165   := pi_rowtype.attrib165;
   po_rec_nsv.nsv_attrib166   := pi_rowtype.attrib166;
   po_rec_nsv.nsv_attrib167   := pi_rowtype.attrib167;
   po_rec_nsv.nsv_attrib168   := pi_rowtype.attrib168;
   po_rec_nsv.nsv_attrib169   := pi_rowtype.attrib169;
   po_rec_nsv.nsv_attrib170   := pi_rowtype.attrib170;
   po_rec_nsv.nsv_attrib171   := pi_rowtype.attrib171;
   po_rec_nsv.nsv_attrib172   := pi_rowtype.attrib172;
   po_rec_nsv.nsv_attrib173   := pi_rowtype.attrib173;
   po_rec_nsv.nsv_attrib174   := pi_rowtype.attrib174;
   po_rec_nsv.nsv_attrib175   := pi_rowtype.attrib175;
   po_rec_nsv.nsv_attrib176   := pi_rowtype.attrib176;
   po_rec_nsv.nsv_attrib177   := pi_rowtype.attrib177;
   po_rec_nsv.nsv_attrib178   := pi_rowtype.attrib178;
   po_rec_nsv.nsv_attrib179   := pi_rowtype.attrib179;
   po_rec_nsv.nsv_attrib180   := pi_rowtype.attrib180;
   po_rec_nsv.nsv_attrib181   := pi_rowtype.attrib181;
   po_rec_nsv.nsv_attrib182   := pi_rowtype.attrib182;
   po_rec_nsv.nsv_attrib183   := pi_rowtype.attrib183;
   po_rec_nsv.nsv_attrib184   := pi_rowtype.attrib184;
   po_rec_nsv.nsv_attrib185   := pi_rowtype.attrib185;
   po_rec_nsv.nsv_attrib186   := pi_rowtype.attrib186;
   po_rec_nsv.nsv_attrib187   := pi_rowtype.attrib187;
   po_rec_nsv.nsv_attrib188   := pi_rowtype.attrib188;
   po_rec_nsv.nsv_attrib189   := pi_rowtype.attrib189;
   po_rec_nsv.nsv_attrib190   := pi_rowtype.attrib190;
   po_rec_nsv.nsv_attrib191   := pi_rowtype.attrib191;
   po_rec_nsv.nsv_attrib192   := pi_rowtype.attrib192;
   po_rec_nsv.nsv_attrib193   := pi_rowtype.attrib193;
   po_rec_nsv.nsv_attrib194   := pi_rowtype.attrib194;
   po_rec_nsv.nsv_attrib195   := pi_rowtype.attrib195;
   po_rec_nsv.nsv_attrib196   := pi_rowtype.attrib196;
   po_rec_nsv.nsv_attrib197   := pi_rowtype.attrib197;
   po_rec_nsv.nsv_attrib198   := pi_rowtype.attrib198;
   po_rec_nsv.nsv_attrib199   := pi_rowtype.attrib199;
   po_rec_nsv.nsv_attrib200   := pi_rowtype.attrib200;
   po_rec_nsv.nsv_attrib201   := pi_rowtype.attrib201;
   po_rec_nsv.nsv_attrib202   := pi_rowtype.attrib202;
   po_rec_nsv.nsv_attrib203   := pi_rowtype.attrib203;
   po_rec_nsv.nsv_attrib204   := pi_rowtype.attrib204;
   po_rec_nsv.nsv_attrib205   := pi_rowtype.attrib205;
   po_rec_nsv.nsv_attrib206   := pi_rowtype.attrib206;
   po_rec_nsv.nsv_attrib207   := pi_rowtype.attrib207;
   po_rec_nsv.nsv_attrib208   := pi_rowtype.attrib208;
   po_rec_nsv.nsv_attrib209   := pi_rowtype.attrib209;
   po_rec_nsv.nsv_attrib210   := pi_rowtype.attrib210;
   po_rec_nsv.nsv_attrib211   := pi_rowtype.attrib211;
   po_rec_nsv.nsv_attrib212   := pi_rowtype.attrib212;
   po_rec_nsv.nsv_attrib213   := pi_rowtype.attrib213;
   po_rec_nsv.nsv_attrib214   := pi_rowtype.attrib214;
   po_rec_nsv.nsv_attrib215   := pi_rowtype.attrib215;
   po_rec_nsv.nsv_attrib216   := pi_rowtype.attrib216;
   po_rec_nsv.nsv_attrib217   := pi_rowtype.attrib217;
   po_rec_nsv.nsv_attrib218   := pi_rowtype.attrib218;
   po_rec_nsv.nsv_attrib219   := pi_rowtype.attrib219;
   po_rec_nsv.nsv_attrib220   := pi_rowtype.attrib220;
   po_rec_nsv.nsv_attrib221   := pi_rowtype.attrib221;
   po_rec_nsv.nsv_attrib222   := pi_rowtype.attrib222;
   po_rec_nsv.nsv_attrib223   := pi_rowtype.attrib223;
   po_rec_nsv.nsv_attrib224   := pi_rowtype.attrib224;
   po_rec_nsv.nsv_attrib225   := pi_rowtype.attrib225;
   po_rec_nsv.nsv_attrib226   := pi_rowtype.attrib226;
   po_rec_nsv.nsv_attrib227   := pi_rowtype.attrib227;
   po_rec_nsv.nsv_attrib228   := pi_rowtype.attrib228;
   po_rec_nsv.nsv_attrib229   := pi_rowtype.attrib229;
   po_rec_nsv.nsv_attrib230   := pi_rowtype.attrib230;
   po_rec_nsv.nsv_attrib231   := pi_rowtype.attrib231;
   po_rec_nsv.nsv_attrib232   := pi_rowtype.attrib232;
   po_rec_nsv.nsv_attrib233   := pi_rowtype.attrib233;
   po_rec_nsv.nsv_attrib234   := pi_rowtype.attrib234;
   po_rec_nsv.nsv_attrib235   := pi_rowtype.attrib235;
   po_rec_nsv.nsv_attrib236   := pi_rowtype.attrib236;
   po_rec_nsv.nsv_attrib237   := pi_rowtype.attrib237;
   po_rec_nsv.nsv_attrib238   := pi_rowtype.attrib238;
   po_rec_nsv.nsv_attrib239   := pi_rowtype.attrib239;
   po_rec_nsv.nsv_attrib240   := pi_rowtype.attrib240;
   po_rec_nsv.nsv_attrib241   := pi_rowtype.attrib241;
   po_rec_nsv.nsv_attrib242   := pi_rowtype.attrib242;
   po_rec_nsv.nsv_attrib243   := pi_rowtype.attrib243;
   po_rec_nsv.nsv_attrib244   := pi_rowtype.attrib244;
   po_rec_nsv.nsv_attrib245   := pi_rowtype.attrib245;
   po_rec_nsv.nsv_attrib246   := pi_rowtype.attrib246;
   po_rec_nsv.nsv_attrib247   := pi_rowtype.attrib247;
   po_rec_nsv.nsv_attrib248   := pi_rowtype.attrib248;
   po_rec_nsv.nsv_attrib249   := pi_rowtype.attrib249;
   po_rec_nsv.nsv_attrib250   := pi_rowtype.attrib250;
   po_rec_nsv.nsv_attrib251   := pi_rowtype.attrib251;
   po_rec_nsv.nsv_attrib252   := pi_rowtype.attrib252;
   po_rec_nsv.nsv_attrib253   := pi_rowtype.attrib253;
   po_rec_nsv.nsv_attrib254   := pi_rowtype.attrib254;
   po_rec_nsv.nsv_attrib255   := pi_rowtype.attrib255;
   po_rec_nsv.nsv_attrib256   := pi_rowtype.attrib256;
   po_rec_nsv.nsv_attrib257   := pi_rowtype.attrib257;
   po_rec_nsv.nsv_attrib258   := pi_rowtype.attrib258;
   po_rec_nsv.nsv_attrib259   := pi_rowtype.attrib259;
   po_rec_nsv.nsv_attrib260   := pi_rowtype.attrib260;
   po_rec_nsv.nsv_attrib261   := pi_rowtype.attrib261;
   po_rec_nsv.nsv_attrib262   := pi_rowtype.attrib262;
   po_rec_nsv.nsv_attrib263   := pi_rowtype.attrib263;
   po_rec_nsv.nsv_attrib264   := pi_rowtype.attrib264;
   po_rec_nsv.nsv_attrib265   := pi_rowtype.attrib265;
   po_rec_nsv.nsv_attrib266   := pi_rowtype.attrib266;
   po_rec_nsv.nsv_attrib267   := pi_rowtype.attrib267;
   po_rec_nsv.nsv_attrib268   := pi_rowtype.attrib268;
   po_rec_nsv.nsv_attrib269   := pi_rowtype.attrib269;
   po_rec_nsv.nsv_attrib270   := pi_rowtype.attrib270;
   po_rec_nsv.nsv_attrib271   := pi_rowtype.attrib271;
   po_rec_nsv.nsv_attrib272   := pi_rowtype.attrib272;
   po_rec_nsv.nsv_attrib273   := pi_rowtype.attrib273;
   po_rec_nsv.nsv_attrib274   := pi_rowtype.attrib274;
   po_rec_nsv.nsv_attrib275   := pi_rowtype.attrib275;
   po_rec_nsv.nsv_attrib276   := pi_rowtype.attrib276;
   po_rec_nsv.nsv_attrib277   := pi_rowtype.attrib277;
   po_rec_nsv.nsv_attrib278   := pi_rowtype.attrib278;
   po_rec_nsv.nsv_attrib279   := pi_rowtype.attrib279;
   po_rec_nsv.nsv_attrib280   := pi_rowtype.attrib280;
   po_rec_nsv.nsv_attrib281   := pi_rowtype.attrib281;
   po_rec_nsv.nsv_attrib282   := pi_rowtype.attrib282;
   po_rec_nsv.nsv_attrib283   := pi_rowtype.attrib283;
   po_rec_nsv.nsv_attrib284   := pi_rowtype.attrib284;
   po_rec_nsv.nsv_attrib285   := pi_rowtype.attrib285;
   po_rec_nsv.nsv_attrib286   := pi_rowtype.attrib286;
   po_rec_nsv.nsv_attrib287   := pi_rowtype.attrib287;
   po_rec_nsv.nsv_attrib288   := pi_rowtype.attrib288;
   po_rec_nsv.nsv_attrib289   := pi_rowtype.attrib289;
   po_rec_nsv.nsv_attrib290   := pi_rowtype.attrib290;
   po_rec_nsv.nsv_attrib291   := pi_rowtype.attrib291;
   po_rec_nsv.nsv_attrib292   := pi_rowtype.attrib292;
   po_rec_nsv.nsv_attrib293   := pi_rowtype.attrib293;
   po_rec_nsv.nsv_attrib294   := pi_rowtype.attrib294;
   po_rec_nsv.nsv_attrib295   := pi_rowtype.attrib295;
   po_rec_nsv.nsv_attrib296   := pi_rowtype.attrib296;
   po_rec_nsv.nsv_attrib297   := pi_rowtype.attrib297;
   po_rec_nsv.nsv_attrib298   := pi_rowtype.attrib298;
   po_rec_nsv.nsv_attrib299   := pi_rowtype.attrib299;
   po_rec_nsv.nsv_attrib300   := pi_rowtype.attrib300;
   po_rec_nsv.nsv_attrib301   := pi_rowtype.attrib301;
   po_rec_nsv.nsv_attrib302   := pi_rowtype.attrib302;
   po_rec_nsv.nsv_attrib303   := pi_rowtype.attrib303;
   po_rec_nsv.nsv_attrib304   := pi_rowtype.attrib304;
   po_rec_nsv.nsv_attrib305   := pi_rowtype.attrib305;
   po_rec_nsv.nsv_attrib306   := pi_rowtype.attrib306;
   po_rec_nsv.nsv_attrib307   := pi_rowtype.attrib307;
   po_rec_nsv.nsv_attrib308   := pi_rowtype.attrib308;
   po_rec_nsv.nsv_attrib309   := pi_rowtype.attrib309;
   po_rec_nsv.nsv_attrib310   := pi_rowtype.attrib310;
   po_rec_nsv.nsv_attrib311   := pi_rowtype.attrib311;
   po_rec_nsv.nsv_attrib312   := pi_rowtype.attrib312;
   po_rec_nsv.nsv_attrib313   := pi_rowtype.attrib313;
   po_rec_nsv.nsv_attrib314   := pi_rowtype.attrib314;
   po_rec_nsv.nsv_attrib315   := pi_rowtype.attrib315;
   po_rec_nsv.nsv_attrib316   := pi_rowtype.attrib316;
   po_rec_nsv.nsv_attrib317   := pi_rowtype.attrib317;
   po_rec_nsv.nsv_attrib318   := pi_rowtype.attrib318;
   po_rec_nsv.nsv_attrib319   := pi_rowtype.attrib319;
   po_rec_nsv.nsv_attrib320   := pi_rowtype.attrib320;
   po_rec_nsv.nsv_attrib321   := pi_rowtype.attrib321;
   po_rec_nsv.nsv_attrib322   := pi_rowtype.attrib322;
   po_rec_nsv.nsv_attrib323   := pi_rowtype.attrib323;
   po_rec_nsv.nsv_attrib324   := pi_rowtype.attrib324;
   po_rec_nsv.nsv_attrib325   := pi_rowtype.attrib325;
   po_rec_nsv.nsv_attrib326   := pi_rowtype.attrib326;
   po_rec_nsv.nsv_attrib327   := pi_rowtype.attrib327;
   po_rec_nsv.nsv_attrib328   := pi_rowtype.attrib328;
   po_rec_nsv.nsv_attrib329   := pi_rowtype.attrib329;
   po_rec_nsv.nsv_attrib330   := pi_rowtype.attrib330;
   po_rec_nsv.nsv_attrib331   := pi_rowtype.attrib331;
   po_rec_nsv.nsv_attrib332   := pi_rowtype.attrib332;
   po_rec_nsv.nsv_attrib333   := pi_rowtype.attrib333;
   po_rec_nsv.nsv_attrib334   := pi_rowtype.attrib334;
   po_rec_nsv.nsv_attrib335   := pi_rowtype.attrib335;
   po_rec_nsv.nsv_attrib336   := pi_rowtype.attrib336;
   po_rec_nsv.nsv_attrib337   := pi_rowtype.attrib337;
   po_rec_nsv.nsv_attrib338   := pi_rowtype.attrib338;
   po_rec_nsv.nsv_attrib339   := pi_rowtype.attrib339;
   po_rec_nsv.nsv_attrib340   := pi_rowtype.attrib340;
   po_rec_nsv.nsv_attrib341   := pi_rowtype.attrib341;
   po_rec_nsv.nsv_attrib342   := pi_rowtype.attrib342;
   po_rec_nsv.nsv_attrib343   := pi_rowtype.attrib343;
   po_rec_nsv.nsv_attrib344   := pi_rowtype.attrib344;
   po_rec_nsv.nsv_attrib345   := pi_rowtype.attrib345;
   po_rec_nsv.nsv_attrib346   := pi_rowtype.attrib346;
   po_rec_nsv.nsv_attrib347   := pi_rowtype.attrib347;
   po_rec_nsv.nsv_attrib348   := pi_rowtype.attrib348;
   po_rec_nsv.nsv_attrib349   := pi_rowtype.attrib349;
   po_rec_nsv.nsv_attrib350   := pi_rowtype.attrib350;
   po_rec_nsv.nsv_attrib351   := pi_rowtype.attrib351;
   po_rec_nsv.nsv_attrib352   := pi_rowtype.attrib352;
   po_rec_nsv.nsv_attrib353   := pi_rowtype.attrib353;
   po_rec_nsv.nsv_attrib354   := pi_rowtype.attrib354;
   po_rec_nsv.nsv_attrib355   := pi_rowtype.attrib355;
   po_rec_nsv.nsv_attrib356   := pi_rowtype.attrib356;
   po_rec_nsv.nsv_attrib357   := pi_rowtype.attrib357;
   po_rec_nsv.nsv_attrib358   := pi_rowtype.attrib358;
   po_rec_nsv.nsv_attrib359   := pi_rowtype.attrib359;
   po_rec_nsv.nsv_attrib360   := pi_rowtype.attrib360;
   po_rec_nsv.nsv_attrib361   := pi_rowtype.attrib361;
   po_rec_nsv.nsv_attrib362   := pi_rowtype.attrib362;
   po_rec_nsv.nsv_attrib363   := pi_rowtype.attrib363;
   po_rec_nsv.nsv_attrib364   := pi_rowtype.attrib364;
   po_rec_nsv.nsv_attrib365   := pi_rowtype.attrib365;
   po_rec_nsv.nsv_attrib366   := pi_rowtype.attrib366;
   po_rec_nsv.nsv_attrib367   := pi_rowtype.attrib367;
   po_rec_nsv.nsv_attrib368   := pi_rowtype.attrib368;
   po_rec_nsv.nsv_attrib369   := pi_rowtype.attrib369;
   po_rec_nsv.nsv_attrib370   := pi_rowtype.attrib370;
   po_rec_nsv.nsv_attrib371   := pi_rowtype.attrib371;
   po_rec_nsv.nsv_attrib372   := pi_rowtype.attrib372;
   po_rec_nsv.nsv_attrib373   := pi_rowtype.attrib373;
   po_rec_nsv.nsv_attrib374   := pi_rowtype.attrib374;
   po_rec_nsv.nsv_attrib375   := pi_rowtype.attrib375;
   po_rec_nsv.nsv_attrib376   := pi_rowtype.attrib376;
   po_rec_nsv.nsv_attrib377   := pi_rowtype.attrib377;
   po_rec_nsv.nsv_attrib378   := pi_rowtype.attrib378;
   po_rec_nsv.nsv_attrib379   := pi_rowtype.attrib379;
   po_rec_nsv.nsv_attrib380   := pi_rowtype.attrib380;
   po_rec_nsv.nsv_attrib381   := pi_rowtype.attrib381;
   po_rec_nsv.nsv_attrib382   := pi_rowtype.attrib382;
   po_rec_nsv.nsv_attrib383   := pi_rowtype.attrib383;
   po_rec_nsv.nsv_attrib384   := pi_rowtype.attrib384;
   po_rec_nsv.nsv_attrib385   := pi_rowtype.attrib385;
   po_rec_nsv.nsv_attrib386   := pi_rowtype.attrib386;
   po_rec_nsv.nsv_attrib387   := pi_rowtype.attrib387;
   po_rec_nsv.nsv_attrib388   := pi_rowtype.attrib388;
   po_rec_nsv.nsv_attrib389   := pi_rowtype.attrib389;
   po_rec_nsv.nsv_attrib390   := pi_rowtype.attrib390;
   po_rec_nsv.nsv_attrib391   := pi_rowtype.attrib391;
   po_rec_nsv.nsv_attrib392   := pi_rowtype.attrib392;
   po_rec_nsv.nsv_attrib393   := pi_rowtype.attrib393;
   po_rec_nsv.nsv_attrib394   := pi_rowtype.attrib394;
   po_rec_nsv.nsv_attrib395   := pi_rowtype.attrib395;
   po_rec_nsv.nsv_attrib396   := pi_rowtype.attrib396;
   po_rec_nsv.nsv_attrib397   := pi_rowtype.attrib397;
   po_rec_nsv.nsv_attrib398   := pi_rowtype.attrib398;
   po_rec_nsv.nsv_attrib399   := pi_rowtype.attrib399;
   po_rec_nsv.nsv_attrib400   := pi_rowtype.attrib400;
   po_rec_nsv.nsv_attrib401   := pi_rowtype.attrib401;
   po_rec_nsv.nsv_attrib402   := pi_rowtype.attrib402;
   po_rec_nsv.nsv_attrib403   := pi_rowtype.attrib403;
   po_rec_nsv.nsv_attrib404   := pi_rowtype.attrib404;
   po_rec_nsv.nsv_attrib405   := pi_rowtype.attrib405;
   po_rec_nsv.nsv_attrib406   := pi_rowtype.attrib406;
   po_rec_nsv.nsv_attrib407   := pi_rowtype.attrib407;
   po_rec_nsv.nsv_attrib408   := pi_rowtype.attrib408;
   po_rec_nsv.nsv_attrib409   := pi_rowtype.attrib409;
   po_rec_nsv.nsv_attrib410   := pi_rowtype.attrib410;
   po_rec_nsv.nsv_attrib411   := pi_rowtype.attrib411;
   po_rec_nsv.nsv_attrib412   := pi_rowtype.attrib412;
   po_rec_nsv.nsv_attrib413   := pi_rowtype.attrib413;
   po_rec_nsv.nsv_attrib414   := pi_rowtype.attrib414;
   po_rec_nsv.nsv_attrib415   := pi_rowtype.attrib415;
   po_rec_nsv.nsv_attrib416   := pi_rowtype.attrib416;
   po_rec_nsv.nsv_attrib417   := pi_rowtype.attrib417;
   po_rec_nsv.nsv_attrib418   := pi_rowtype.attrib418;
   po_rec_nsv.nsv_attrib419   := pi_rowtype.attrib419;
   po_rec_nsv.nsv_attrib420   := pi_rowtype.attrib420;
   po_rec_nsv.nsv_attrib421   := pi_rowtype.attrib421;
   po_rec_nsv.nsv_attrib422   := pi_rowtype.attrib422;
   po_rec_nsv.nsv_attrib423   := pi_rowtype.attrib423;
   po_rec_nsv.nsv_attrib424   := pi_rowtype.attrib424;
   po_rec_nsv.nsv_attrib425   := pi_rowtype.attrib425;
   po_rec_nsv.nsv_attrib426   := pi_rowtype.attrib426;
   po_rec_nsv.nsv_attrib427   := pi_rowtype.attrib427;
   po_rec_nsv.nsv_attrib428   := pi_rowtype.attrib428;
   po_rec_nsv.nsv_attrib429   := pi_rowtype.attrib429;
   po_rec_nsv.nsv_attrib430   := pi_rowtype.attrib430;
   po_rec_nsv.nsv_attrib431   := pi_rowtype.attrib431;
   po_rec_nsv.nsv_attrib432   := pi_rowtype.attrib432;
   po_rec_nsv.nsv_attrib433   := pi_rowtype.attrib433;
   po_rec_nsv.nsv_attrib434   := pi_rowtype.attrib434;
   po_rec_nsv.nsv_attrib435   := pi_rowtype.attrib435;
   po_rec_nsv.nsv_attrib436   := pi_rowtype.attrib436;
   po_rec_nsv.nsv_attrib437   := pi_rowtype.attrib437;
   po_rec_nsv.nsv_attrib438   := pi_rowtype.attrib438;
   po_rec_nsv.nsv_attrib439   := pi_rowtype.attrib439;
   po_rec_nsv.nsv_attrib440   := pi_rowtype.attrib440;
   po_rec_nsv.nsv_attrib441   := pi_rowtype.attrib441;
   po_rec_nsv.nsv_attrib442   := pi_rowtype.attrib442;
   po_rec_nsv.nsv_attrib443   := pi_rowtype.attrib443;
   po_rec_nsv.nsv_attrib444   := pi_rowtype.attrib444;
   po_rec_nsv.nsv_attrib445   := pi_rowtype.attrib445;
   po_rec_nsv.nsv_attrib446   := pi_rowtype.attrib446;
   po_rec_nsv.nsv_attrib447   := pi_rowtype.attrib447;
   po_rec_nsv.nsv_attrib448   := pi_rowtype.attrib448;
   po_rec_nsv.nsv_attrib449   := pi_rowtype.attrib449;
   po_rec_nsv.nsv_attrib450   := pi_rowtype.attrib450;
   po_rec_nsv.nsv_attrib451   := pi_rowtype.attrib451;
   po_rec_nsv.nsv_attrib452   := pi_rowtype.attrib452;
   po_rec_nsv.nsv_attrib453   := pi_rowtype.attrib453;
   po_rec_nsv.nsv_attrib454   := pi_rowtype.attrib454;
   po_rec_nsv.nsv_attrib455   := pi_rowtype.attrib455;
   po_rec_nsv.nsv_attrib456   := pi_rowtype.attrib456;
   po_rec_nsv.nsv_attrib457   := pi_rowtype.attrib457;
   po_rec_nsv.nsv_attrib458   := pi_rowtype.attrib458;
   po_rec_nsv.nsv_attrib459   := pi_rowtype.attrib459;
   po_rec_nsv.nsv_attrib460   := pi_rowtype.attrib460;
   po_rec_nsv.nsv_attrib461   := pi_rowtype.attrib461;
   po_rec_nsv.nsv_attrib462   := pi_rowtype.attrib462;
   po_rec_nsv.nsv_attrib463   := pi_rowtype.attrib463;
   po_rec_nsv.nsv_attrib464   := pi_rowtype.attrib464;
   po_rec_nsv.nsv_attrib465   := pi_rowtype.attrib465;
   po_rec_nsv.nsv_attrib466   := pi_rowtype.attrib466;
   po_rec_nsv.nsv_attrib467   := pi_rowtype.attrib467;
   po_rec_nsv.nsv_attrib468   := pi_rowtype.attrib468;
   po_rec_nsv.nsv_attrib469   := pi_rowtype.attrib469;
   po_rec_nsv.nsv_attrib470   := pi_rowtype.attrib470;
   po_rec_nsv.nsv_attrib471   := pi_rowtype.attrib471;
   po_rec_nsv.nsv_attrib472   := pi_rowtype.attrib472;
   po_rec_nsv.nsv_attrib473   := pi_rowtype.attrib473;
   po_rec_nsv.nsv_attrib474   := pi_rowtype.attrib474;
   po_rec_nsv.nsv_attrib475   := pi_rowtype.attrib475;
   po_rec_nsv.nsv_attrib476   := pi_rowtype.attrib476;
   po_rec_nsv.nsv_attrib477   := pi_rowtype.attrib477;
   po_rec_nsv.nsv_attrib478   := pi_rowtype.attrib478;
   po_rec_nsv.nsv_attrib479   := pi_rowtype.attrib479;
   po_rec_nsv.nsv_attrib480   := pi_rowtype.attrib480;
   po_rec_nsv.nsv_attrib481   := pi_rowtype.attrib481;
   po_rec_nsv.nsv_attrib482   := pi_rowtype.attrib482;
   po_rec_nsv.nsv_attrib483   := pi_rowtype.attrib483;
   po_rec_nsv.nsv_attrib484   := pi_rowtype.attrib484;
   po_rec_nsv.nsv_attrib485   := pi_rowtype.attrib485;
   po_rec_nsv.nsv_attrib486   := pi_rowtype.attrib486;
   po_rec_nsv.nsv_attrib487   := pi_rowtype.attrib487;
   po_rec_nsv.nsv_attrib488   := pi_rowtype.attrib488;
   po_rec_nsv.nsv_attrib489   := pi_rowtype.attrib489;
   po_rec_nsv.nsv_attrib490   := pi_rowtype.attrib490;
   po_rec_nsv.nsv_attrib491   := pi_rowtype.attrib491;
   po_rec_nsv.nsv_attrib492   := pi_rowtype.attrib492;
   po_rec_nsv.nsv_attrib493   := pi_rowtype.attrib493;
   po_rec_nsv.nsv_attrib494   := pi_rowtype.attrib494;
   po_rec_nsv.nsv_attrib495   := pi_rowtype.attrib495;
   po_rec_nsv.nsv_attrib496   := pi_rowtype.attrib496;
   po_rec_nsv.nsv_attrib497   := pi_rowtype.attrib497;
   po_rec_nsv.nsv_attrib498   := pi_rowtype.attrib498;
   po_rec_nsv.nsv_attrib499   := pi_rowtype.attrib499;
   po_rec_nsv.nsv_attrib500   := pi_rowtype.attrib500;
--
END pop_rec_nsv_from_cs_distinct;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE pop_rec_nsv_from_inv_val_mem
                            (pi_rowtype IN     cs_inv_val_by_mem%ROWTYPE
                            ,po_rec_nsv IN OUT nm_mrg_section_inv_values%ROWTYPE
                            ) IS
BEGIN
--
   po_rec_nsv.nsv_value_id    := NULL;
   po_rec_nsv.nsv_inv_type    := pi_rowtype.inv_type;
   po_rec_nsv.nsv_x_sect      := pi_rowtype.x_sect;
   po_rec_nsv.nsv_pnt_or_cont := pi_rowtype.pnt_or_cont;
   po_rec_nsv.nsv_attrib1     := pi_rowtype.attrib1;
   po_rec_nsv.nsv_attrib2     := pi_rowtype.attrib2;
   po_rec_nsv.nsv_attrib3     := pi_rowtype.attrib3;
   po_rec_nsv.nsv_attrib4     := pi_rowtype.attrib4;
   po_rec_nsv.nsv_attrib5     := pi_rowtype.attrib5;
   po_rec_nsv.nsv_attrib6     := pi_rowtype.attrib6;
   po_rec_nsv.nsv_attrib7     := pi_rowtype.attrib7;
   po_rec_nsv.nsv_attrib8     := pi_rowtype.attrib8;
   po_rec_nsv.nsv_attrib9     := pi_rowtype.attrib9;
   po_rec_nsv.nsv_attrib10    := pi_rowtype.attrib10;
   po_rec_nsv.nsv_attrib11    := pi_rowtype.attrib11;
   po_rec_nsv.nsv_attrib12    := pi_rowtype.attrib12;
   po_rec_nsv.nsv_attrib13    := pi_rowtype.attrib13;
   po_rec_nsv.nsv_attrib14    := pi_rowtype.attrib14;
   po_rec_nsv.nsv_attrib15    := pi_rowtype.attrib15;
   po_rec_nsv.nsv_attrib16    := pi_rowtype.attrib16;
   po_rec_nsv.nsv_attrib17    := pi_rowtype.attrib17;
   po_rec_nsv.nsv_attrib18    := pi_rowtype.attrib18;
   po_rec_nsv.nsv_attrib19    := pi_rowtype.attrib19;
   po_rec_nsv.nsv_attrib20    := pi_rowtype.attrib20;
   po_rec_nsv.nsv_attrib21    := pi_rowtype.attrib21;
   po_rec_nsv.nsv_attrib22    := pi_rowtype.attrib22;
   po_rec_nsv.nsv_attrib23    := pi_rowtype.attrib23;
   po_rec_nsv.nsv_attrib24    := pi_rowtype.attrib24;
   po_rec_nsv.nsv_attrib25    := pi_rowtype.attrib25;
   po_rec_nsv.nsv_attrib26    := pi_rowtype.attrib26;
   po_rec_nsv.nsv_attrib27    := pi_rowtype.attrib27;
   po_rec_nsv.nsv_attrib28    := pi_rowtype.attrib28;
   po_rec_nsv.nsv_attrib29    := pi_rowtype.attrib29;
   po_rec_nsv.nsv_attrib30    := pi_rowtype.attrib30;
   po_rec_nsv.nsv_attrib31    := pi_rowtype.attrib31;
   po_rec_nsv.nsv_attrib32    := pi_rowtype.attrib32;
   po_rec_nsv.nsv_attrib33    := pi_rowtype.attrib33;
   po_rec_nsv.nsv_attrib34    := pi_rowtype.attrib34;
   po_rec_nsv.nsv_attrib35    := pi_rowtype.attrib35;
   po_rec_nsv.nsv_attrib36    := pi_rowtype.attrib36;
   po_rec_nsv.nsv_attrib37    := pi_rowtype.attrib37;
   po_rec_nsv.nsv_attrib38    := pi_rowtype.attrib38;
   po_rec_nsv.nsv_attrib39    := pi_rowtype.attrib39;
   po_rec_nsv.nsv_attrib40    := pi_rowtype.attrib40;
   po_rec_nsv.nsv_attrib41    := pi_rowtype.attrib41;
   po_rec_nsv.nsv_attrib42    := pi_rowtype.attrib42;
   po_rec_nsv.nsv_attrib43    := pi_rowtype.attrib43;
   po_rec_nsv.nsv_attrib44    := pi_rowtype.attrib44;
   po_rec_nsv.nsv_attrib45    := pi_rowtype.attrib45;
   po_rec_nsv.nsv_attrib46    := pi_rowtype.attrib46;
   po_rec_nsv.nsv_attrib47    := pi_rowtype.attrib47;
   po_rec_nsv.nsv_attrib48    := pi_rowtype.attrib48;
   po_rec_nsv.nsv_attrib49    := pi_rowtype.attrib49;
   po_rec_nsv.nsv_attrib50    := pi_rowtype.attrib50;
   po_rec_nsv.nsv_attrib51    := pi_rowtype.attrib51;
   po_rec_nsv.nsv_attrib52    := pi_rowtype.attrib52;
   po_rec_nsv.nsv_attrib53    := pi_rowtype.attrib53;
   po_rec_nsv.nsv_attrib54    := pi_rowtype.attrib54;
   po_rec_nsv.nsv_attrib55    := pi_rowtype.attrib55;
   po_rec_nsv.nsv_attrib56    := pi_rowtype.attrib56;
   po_rec_nsv.nsv_attrib57    := pi_rowtype.attrib57;
   po_rec_nsv.nsv_attrib58    := pi_rowtype.attrib58;
   po_rec_nsv.nsv_attrib59    := pi_rowtype.attrib59;
   po_rec_nsv.nsv_attrib60    := pi_rowtype.attrib60;
   po_rec_nsv.nsv_attrib61    := pi_rowtype.attrib61;
   po_rec_nsv.nsv_attrib62    := pi_rowtype.attrib62;
   po_rec_nsv.nsv_attrib63    := pi_rowtype.attrib63;
   po_rec_nsv.nsv_attrib64    := pi_rowtype.attrib64;
   po_rec_nsv.nsv_attrib65    := pi_rowtype.attrib65;
   po_rec_nsv.nsv_attrib66    := pi_rowtype.attrib66;
   po_rec_nsv.nsv_attrib67    := pi_rowtype.attrib67;
   po_rec_nsv.nsv_attrib68    := pi_rowtype.attrib68;
   po_rec_nsv.nsv_attrib69    := pi_rowtype.attrib69;
   po_rec_nsv.nsv_attrib70    := pi_rowtype.attrib70;
   po_rec_nsv.nsv_attrib71    := pi_rowtype.attrib71;
   po_rec_nsv.nsv_attrib72    := pi_rowtype.attrib72;
   po_rec_nsv.nsv_attrib73    := pi_rowtype.attrib73;
   po_rec_nsv.nsv_attrib74    := pi_rowtype.attrib74;
   po_rec_nsv.nsv_attrib75    := pi_rowtype.attrib75;
   po_rec_nsv.nsv_attrib76    := pi_rowtype.attrib76;
   po_rec_nsv.nsv_attrib77    := pi_rowtype.attrib77;
   po_rec_nsv.nsv_attrib78    := pi_rowtype.attrib78;
   po_rec_nsv.nsv_attrib79    := pi_rowtype.attrib79;
   po_rec_nsv.nsv_attrib80    := pi_rowtype.attrib80;
   po_rec_nsv.nsv_attrib81    := pi_rowtype.attrib81;
   po_rec_nsv.nsv_attrib82    := pi_rowtype.attrib82;
   po_rec_nsv.nsv_attrib83    := pi_rowtype.attrib83;
   po_rec_nsv.nsv_attrib84    := pi_rowtype.attrib84;
   po_rec_nsv.nsv_attrib85    := pi_rowtype.attrib85;
   po_rec_nsv.nsv_attrib86    := pi_rowtype.attrib86;
   po_rec_nsv.nsv_attrib87    := pi_rowtype.attrib87;
   po_rec_nsv.nsv_attrib88    := pi_rowtype.attrib88;
   po_rec_nsv.nsv_attrib89    := pi_rowtype.attrib89;
   po_rec_nsv.nsv_attrib90    := pi_rowtype.attrib90;
   po_rec_nsv.nsv_attrib91    := pi_rowtype.attrib91;
   po_rec_nsv.nsv_attrib92    := pi_rowtype.attrib92;
   po_rec_nsv.nsv_attrib93    := pi_rowtype.attrib93;
   po_rec_nsv.nsv_attrib94    := pi_rowtype.attrib94;
   po_rec_nsv.nsv_attrib95    := pi_rowtype.attrib95;
   po_rec_nsv.nsv_attrib96    := pi_rowtype.attrib96;
   po_rec_nsv.nsv_attrib97    := pi_rowtype.attrib97;
   po_rec_nsv.nsv_attrib98    := pi_rowtype.attrib98;
   po_rec_nsv.nsv_attrib99    := pi_rowtype.attrib99;
   po_rec_nsv.nsv_attrib100   := pi_rowtype.attrib100;
   po_rec_nsv.nsv_attrib101   := pi_rowtype.attrib101;
   po_rec_nsv.nsv_attrib102   := pi_rowtype.attrib102;
   po_rec_nsv.nsv_attrib103   := pi_rowtype.attrib103;
   po_rec_nsv.nsv_attrib104   := pi_rowtype.attrib104;
   po_rec_nsv.nsv_attrib105   := pi_rowtype.attrib105;
   po_rec_nsv.nsv_attrib106   := pi_rowtype.attrib106;
   po_rec_nsv.nsv_attrib107   := pi_rowtype.attrib107;
   po_rec_nsv.nsv_attrib108   := pi_rowtype.attrib108;
   po_rec_nsv.nsv_attrib109   := pi_rowtype.attrib109;
   po_rec_nsv.nsv_attrib110   := pi_rowtype.attrib110;
   po_rec_nsv.nsv_attrib111   := pi_rowtype.attrib111;
   po_rec_nsv.nsv_attrib112   := pi_rowtype.attrib112;
   po_rec_nsv.nsv_attrib113   := pi_rowtype.attrib113;
   po_rec_nsv.nsv_attrib114   := pi_rowtype.attrib114;
   po_rec_nsv.nsv_attrib115   := pi_rowtype.attrib115;
   po_rec_nsv.nsv_attrib116   := pi_rowtype.attrib116;
   po_rec_nsv.nsv_attrib117   := pi_rowtype.attrib117;
   po_rec_nsv.nsv_attrib118   := pi_rowtype.attrib118;
   po_rec_nsv.nsv_attrib119   := pi_rowtype.attrib119;
   po_rec_nsv.nsv_attrib120   := pi_rowtype.attrib120;
   po_rec_nsv.nsv_attrib121   := pi_rowtype.attrib121;
   po_rec_nsv.nsv_attrib122   := pi_rowtype.attrib122;
   po_rec_nsv.nsv_attrib123   := pi_rowtype.attrib123;
   po_rec_nsv.nsv_attrib124   := pi_rowtype.attrib124;
   po_rec_nsv.nsv_attrib125   := pi_rowtype.attrib125;
   po_rec_nsv.nsv_attrib126   := pi_rowtype.attrib126;
   po_rec_nsv.nsv_attrib127   := pi_rowtype.attrib127;
   po_rec_nsv.nsv_attrib128   := pi_rowtype.attrib128;
   po_rec_nsv.nsv_attrib129   := pi_rowtype.attrib129;
   po_rec_nsv.nsv_attrib130   := pi_rowtype.attrib130;
   po_rec_nsv.nsv_attrib131   := pi_rowtype.attrib131;
   po_rec_nsv.nsv_attrib132   := pi_rowtype.attrib132;
   po_rec_nsv.nsv_attrib133   := pi_rowtype.attrib133;
   po_rec_nsv.nsv_attrib134   := pi_rowtype.attrib134;
   po_rec_nsv.nsv_attrib135   := pi_rowtype.attrib135;
   po_rec_nsv.nsv_attrib136   := pi_rowtype.attrib136;
   po_rec_nsv.nsv_attrib137   := pi_rowtype.attrib137;
   po_rec_nsv.nsv_attrib138   := pi_rowtype.attrib138;
   po_rec_nsv.nsv_attrib139   := pi_rowtype.attrib139;
   po_rec_nsv.nsv_attrib140   := pi_rowtype.attrib140;
   po_rec_nsv.nsv_attrib141   := pi_rowtype.attrib141;
   po_rec_nsv.nsv_attrib142   := pi_rowtype.attrib142;
   po_rec_nsv.nsv_attrib143   := pi_rowtype.attrib143;
   po_rec_nsv.nsv_attrib144   := pi_rowtype.attrib144;
   po_rec_nsv.nsv_attrib145   := pi_rowtype.attrib145;
   po_rec_nsv.nsv_attrib146   := pi_rowtype.attrib146;
   po_rec_nsv.nsv_attrib147   := pi_rowtype.attrib147;
   po_rec_nsv.nsv_attrib148   := pi_rowtype.attrib148;
   po_rec_nsv.nsv_attrib149   := pi_rowtype.attrib149;
   po_rec_nsv.nsv_attrib150   := pi_rowtype.attrib150;
   po_rec_nsv.nsv_attrib151   := pi_rowtype.attrib151;
   po_rec_nsv.nsv_attrib152   := pi_rowtype.attrib152;
   po_rec_nsv.nsv_attrib153   := pi_rowtype.attrib153;
   po_rec_nsv.nsv_attrib154   := pi_rowtype.attrib154;
   po_rec_nsv.nsv_attrib155   := pi_rowtype.attrib155;
   po_rec_nsv.nsv_attrib156   := pi_rowtype.attrib156;
   po_rec_nsv.nsv_attrib157   := pi_rowtype.attrib157;
   po_rec_nsv.nsv_attrib158   := pi_rowtype.attrib158;
   po_rec_nsv.nsv_attrib159   := pi_rowtype.attrib159;
   po_rec_nsv.nsv_attrib160   := pi_rowtype.attrib160;
   po_rec_nsv.nsv_attrib161   := pi_rowtype.attrib161;
   po_rec_nsv.nsv_attrib162   := pi_rowtype.attrib162;
   po_rec_nsv.nsv_attrib163   := pi_rowtype.attrib163;
   po_rec_nsv.nsv_attrib164   := pi_rowtype.attrib164;
   po_rec_nsv.nsv_attrib165   := pi_rowtype.attrib165;
   po_rec_nsv.nsv_attrib166   := pi_rowtype.attrib166;
   po_rec_nsv.nsv_attrib167   := pi_rowtype.attrib167;
   po_rec_nsv.nsv_attrib168   := pi_rowtype.attrib168;
   po_rec_nsv.nsv_attrib169   := pi_rowtype.attrib169;
   po_rec_nsv.nsv_attrib170   := pi_rowtype.attrib170;
   po_rec_nsv.nsv_attrib171   := pi_rowtype.attrib171;
   po_rec_nsv.nsv_attrib172   := pi_rowtype.attrib172;
   po_rec_nsv.nsv_attrib173   := pi_rowtype.attrib173;
   po_rec_nsv.nsv_attrib174   := pi_rowtype.attrib174;
   po_rec_nsv.nsv_attrib175   := pi_rowtype.attrib175;
   po_rec_nsv.nsv_attrib176   := pi_rowtype.attrib176;
   po_rec_nsv.nsv_attrib177   := pi_rowtype.attrib177;
   po_rec_nsv.nsv_attrib178   := pi_rowtype.attrib178;
   po_rec_nsv.nsv_attrib179   := pi_rowtype.attrib179;
   po_rec_nsv.nsv_attrib180   := pi_rowtype.attrib180;
   po_rec_nsv.nsv_attrib181   := pi_rowtype.attrib181;
   po_rec_nsv.nsv_attrib182   := pi_rowtype.attrib182;
   po_rec_nsv.nsv_attrib183   := pi_rowtype.attrib183;
   po_rec_nsv.nsv_attrib184   := pi_rowtype.attrib184;
   po_rec_nsv.nsv_attrib185   := pi_rowtype.attrib185;
   po_rec_nsv.nsv_attrib186   := pi_rowtype.attrib186;
   po_rec_nsv.nsv_attrib187   := pi_rowtype.attrib187;
   po_rec_nsv.nsv_attrib188   := pi_rowtype.attrib188;
   po_rec_nsv.nsv_attrib189   := pi_rowtype.attrib189;
   po_rec_nsv.nsv_attrib190   := pi_rowtype.attrib190;
   po_rec_nsv.nsv_attrib191   := pi_rowtype.attrib191;
   po_rec_nsv.nsv_attrib192   := pi_rowtype.attrib192;
   po_rec_nsv.nsv_attrib193   := pi_rowtype.attrib193;
   po_rec_nsv.nsv_attrib194   := pi_rowtype.attrib194;
   po_rec_nsv.nsv_attrib195   := pi_rowtype.attrib195;
   po_rec_nsv.nsv_attrib196   := pi_rowtype.attrib196;
   po_rec_nsv.nsv_attrib197   := pi_rowtype.attrib197;
   po_rec_nsv.nsv_attrib198   := pi_rowtype.attrib198;
   po_rec_nsv.nsv_attrib199   := pi_rowtype.attrib199;
   po_rec_nsv.nsv_attrib200   := pi_rowtype.attrib200;
   po_rec_nsv.nsv_attrib201   := pi_rowtype.attrib201;
   po_rec_nsv.nsv_attrib202   := pi_rowtype.attrib202;
   po_rec_nsv.nsv_attrib203   := pi_rowtype.attrib203;
   po_rec_nsv.nsv_attrib204   := pi_rowtype.attrib204;
   po_rec_nsv.nsv_attrib205   := pi_rowtype.attrib205;
   po_rec_nsv.nsv_attrib206   := pi_rowtype.attrib206;
   po_rec_nsv.nsv_attrib207   := pi_rowtype.attrib207;
   po_rec_nsv.nsv_attrib208   := pi_rowtype.attrib208;
   po_rec_nsv.nsv_attrib209   := pi_rowtype.attrib209;
   po_rec_nsv.nsv_attrib210   := pi_rowtype.attrib210;
   po_rec_nsv.nsv_attrib211   := pi_rowtype.attrib211;
   po_rec_nsv.nsv_attrib212   := pi_rowtype.attrib212;
   po_rec_nsv.nsv_attrib213   := pi_rowtype.attrib213;
   po_rec_nsv.nsv_attrib214   := pi_rowtype.attrib214;
   po_rec_nsv.nsv_attrib215   := pi_rowtype.attrib215;
   po_rec_nsv.nsv_attrib216   := pi_rowtype.attrib216;
   po_rec_nsv.nsv_attrib217   := pi_rowtype.attrib217;
   po_rec_nsv.nsv_attrib218   := pi_rowtype.attrib218;
   po_rec_nsv.nsv_attrib219   := pi_rowtype.attrib219;
   po_rec_nsv.nsv_attrib220   := pi_rowtype.attrib220;
   po_rec_nsv.nsv_attrib221   := pi_rowtype.attrib221;
   po_rec_nsv.nsv_attrib222   := pi_rowtype.attrib222;
   po_rec_nsv.nsv_attrib223   := pi_rowtype.attrib223;
   po_rec_nsv.nsv_attrib224   := pi_rowtype.attrib224;
   po_rec_nsv.nsv_attrib225   := pi_rowtype.attrib225;
   po_rec_nsv.nsv_attrib226   := pi_rowtype.attrib226;
   po_rec_nsv.nsv_attrib227   := pi_rowtype.attrib227;
   po_rec_nsv.nsv_attrib228   := pi_rowtype.attrib228;
   po_rec_nsv.nsv_attrib229   := pi_rowtype.attrib229;
   po_rec_nsv.nsv_attrib230   := pi_rowtype.attrib230;
   po_rec_nsv.nsv_attrib231   := pi_rowtype.attrib231;
   po_rec_nsv.nsv_attrib232   := pi_rowtype.attrib232;
   po_rec_nsv.nsv_attrib233   := pi_rowtype.attrib233;
   po_rec_nsv.nsv_attrib234   := pi_rowtype.attrib234;
   po_rec_nsv.nsv_attrib235   := pi_rowtype.attrib235;
   po_rec_nsv.nsv_attrib236   := pi_rowtype.attrib236;
   po_rec_nsv.nsv_attrib237   := pi_rowtype.attrib237;
   po_rec_nsv.nsv_attrib238   := pi_rowtype.attrib238;
   po_rec_nsv.nsv_attrib239   := pi_rowtype.attrib239;
   po_rec_nsv.nsv_attrib240   := pi_rowtype.attrib240;
   po_rec_nsv.nsv_attrib241   := pi_rowtype.attrib241;
   po_rec_nsv.nsv_attrib242   := pi_rowtype.attrib242;
   po_rec_nsv.nsv_attrib243   := pi_rowtype.attrib243;
   po_rec_nsv.nsv_attrib244   := pi_rowtype.attrib244;
   po_rec_nsv.nsv_attrib245   := pi_rowtype.attrib245;
   po_rec_nsv.nsv_attrib246   := pi_rowtype.attrib246;
   po_rec_nsv.nsv_attrib247   := pi_rowtype.attrib247;
   po_rec_nsv.nsv_attrib248   := pi_rowtype.attrib248;
   po_rec_nsv.nsv_attrib249   := pi_rowtype.attrib249;
   po_rec_nsv.nsv_attrib250   := pi_rowtype.attrib250;
   po_rec_nsv.nsv_attrib251   := pi_rowtype.attrib251;
   po_rec_nsv.nsv_attrib252   := pi_rowtype.attrib252;
   po_rec_nsv.nsv_attrib253   := pi_rowtype.attrib253;
   po_rec_nsv.nsv_attrib254   := pi_rowtype.attrib254;
   po_rec_nsv.nsv_attrib255   := pi_rowtype.attrib255;
   po_rec_nsv.nsv_attrib256   := pi_rowtype.attrib256;
   po_rec_nsv.nsv_attrib257   := pi_rowtype.attrib257;
   po_rec_nsv.nsv_attrib258   := pi_rowtype.attrib258;
   po_rec_nsv.nsv_attrib259   := pi_rowtype.attrib259;
   po_rec_nsv.nsv_attrib260   := pi_rowtype.attrib260;
   po_rec_nsv.nsv_attrib261   := pi_rowtype.attrib261;
   po_rec_nsv.nsv_attrib262   := pi_rowtype.attrib262;
   po_rec_nsv.nsv_attrib263   := pi_rowtype.attrib263;
   po_rec_nsv.nsv_attrib264   := pi_rowtype.attrib264;
   po_rec_nsv.nsv_attrib265   := pi_rowtype.attrib265;
   po_rec_nsv.nsv_attrib266   := pi_rowtype.attrib266;
   po_rec_nsv.nsv_attrib267   := pi_rowtype.attrib267;
   po_rec_nsv.nsv_attrib268   := pi_rowtype.attrib268;
   po_rec_nsv.nsv_attrib269   := pi_rowtype.attrib269;
   po_rec_nsv.nsv_attrib270   := pi_rowtype.attrib270;
   po_rec_nsv.nsv_attrib271   := pi_rowtype.attrib271;
   po_rec_nsv.nsv_attrib272   := pi_rowtype.attrib272;
   po_rec_nsv.nsv_attrib273   := pi_rowtype.attrib273;
   po_rec_nsv.nsv_attrib274   := pi_rowtype.attrib274;
   po_rec_nsv.nsv_attrib275   := pi_rowtype.attrib275;
   po_rec_nsv.nsv_attrib276   := pi_rowtype.attrib276;
   po_rec_nsv.nsv_attrib277   := pi_rowtype.attrib277;
   po_rec_nsv.nsv_attrib278   := pi_rowtype.attrib278;
   po_rec_nsv.nsv_attrib279   := pi_rowtype.attrib279;
   po_rec_nsv.nsv_attrib280   := pi_rowtype.attrib280;
   po_rec_nsv.nsv_attrib281   := pi_rowtype.attrib281;
   po_rec_nsv.nsv_attrib282   := pi_rowtype.attrib282;
   po_rec_nsv.nsv_attrib283   := pi_rowtype.attrib283;
   po_rec_nsv.nsv_attrib284   := pi_rowtype.attrib284;
   po_rec_nsv.nsv_attrib285   := pi_rowtype.attrib285;
   po_rec_nsv.nsv_attrib286   := pi_rowtype.attrib286;
   po_rec_nsv.nsv_attrib287   := pi_rowtype.attrib287;
   po_rec_nsv.nsv_attrib288   := pi_rowtype.attrib288;
   po_rec_nsv.nsv_attrib289   := pi_rowtype.attrib289;
   po_rec_nsv.nsv_attrib290   := pi_rowtype.attrib290;
   po_rec_nsv.nsv_attrib291   := pi_rowtype.attrib291;
   po_rec_nsv.nsv_attrib292   := pi_rowtype.attrib292;
   po_rec_nsv.nsv_attrib293   := pi_rowtype.attrib293;
   po_rec_nsv.nsv_attrib294   := pi_rowtype.attrib294;
   po_rec_nsv.nsv_attrib295   := pi_rowtype.attrib295;
   po_rec_nsv.nsv_attrib296   := pi_rowtype.attrib296;
   po_rec_nsv.nsv_attrib297   := pi_rowtype.attrib297;
   po_rec_nsv.nsv_attrib298   := pi_rowtype.attrib298;
   po_rec_nsv.nsv_attrib299   := pi_rowtype.attrib299;
   po_rec_nsv.nsv_attrib300   := pi_rowtype.attrib300;
   po_rec_nsv.nsv_attrib301   := pi_rowtype.attrib301;
   po_rec_nsv.nsv_attrib302   := pi_rowtype.attrib302;
   po_rec_nsv.nsv_attrib303   := pi_rowtype.attrib303;
   po_rec_nsv.nsv_attrib304   := pi_rowtype.attrib304;
   po_rec_nsv.nsv_attrib305   := pi_rowtype.attrib305;
   po_rec_nsv.nsv_attrib306   := pi_rowtype.attrib306;
   po_rec_nsv.nsv_attrib307   := pi_rowtype.attrib307;
   po_rec_nsv.nsv_attrib308   := pi_rowtype.attrib308;
   po_rec_nsv.nsv_attrib309   := pi_rowtype.attrib309;
   po_rec_nsv.nsv_attrib310   := pi_rowtype.attrib310;
   po_rec_nsv.nsv_attrib311   := pi_rowtype.attrib311;
   po_rec_nsv.nsv_attrib312   := pi_rowtype.attrib312;
   po_rec_nsv.nsv_attrib313   := pi_rowtype.attrib313;
   po_rec_nsv.nsv_attrib314   := pi_rowtype.attrib314;
   po_rec_nsv.nsv_attrib315   := pi_rowtype.attrib315;
   po_rec_nsv.nsv_attrib316   := pi_rowtype.attrib316;
   po_rec_nsv.nsv_attrib317   := pi_rowtype.attrib317;
   po_rec_nsv.nsv_attrib318   := pi_rowtype.attrib318;
   po_rec_nsv.nsv_attrib319   := pi_rowtype.attrib319;
   po_rec_nsv.nsv_attrib320   := pi_rowtype.attrib320;
   po_rec_nsv.nsv_attrib321   := pi_rowtype.attrib321;
   po_rec_nsv.nsv_attrib322   := pi_rowtype.attrib322;
   po_rec_nsv.nsv_attrib323   := pi_rowtype.attrib323;
   po_rec_nsv.nsv_attrib324   := pi_rowtype.attrib324;
   po_rec_nsv.nsv_attrib325   := pi_rowtype.attrib325;
   po_rec_nsv.nsv_attrib326   := pi_rowtype.attrib326;
   po_rec_nsv.nsv_attrib327   := pi_rowtype.attrib327;
   po_rec_nsv.nsv_attrib328   := pi_rowtype.attrib328;
   po_rec_nsv.nsv_attrib329   := pi_rowtype.attrib329;
   po_rec_nsv.nsv_attrib330   := pi_rowtype.attrib330;
   po_rec_nsv.nsv_attrib331   := pi_rowtype.attrib331;
   po_rec_nsv.nsv_attrib332   := pi_rowtype.attrib332;
   po_rec_nsv.nsv_attrib333   := pi_rowtype.attrib333;
   po_rec_nsv.nsv_attrib334   := pi_rowtype.attrib334;
   po_rec_nsv.nsv_attrib335   := pi_rowtype.attrib335;
   po_rec_nsv.nsv_attrib336   := pi_rowtype.attrib336;
   po_rec_nsv.nsv_attrib337   := pi_rowtype.attrib337;
   po_rec_nsv.nsv_attrib338   := pi_rowtype.attrib338;
   po_rec_nsv.nsv_attrib339   := pi_rowtype.attrib339;
   po_rec_nsv.nsv_attrib340   := pi_rowtype.attrib340;
   po_rec_nsv.nsv_attrib341   := pi_rowtype.attrib341;
   po_rec_nsv.nsv_attrib342   := pi_rowtype.attrib342;
   po_rec_nsv.nsv_attrib343   := pi_rowtype.attrib343;
   po_rec_nsv.nsv_attrib344   := pi_rowtype.attrib344;
   po_rec_nsv.nsv_attrib345   := pi_rowtype.attrib345;
   po_rec_nsv.nsv_attrib346   := pi_rowtype.attrib346;
   po_rec_nsv.nsv_attrib347   := pi_rowtype.attrib347;
   po_rec_nsv.nsv_attrib348   := pi_rowtype.attrib348;
   po_rec_nsv.nsv_attrib349   := pi_rowtype.attrib349;
   po_rec_nsv.nsv_attrib350   := pi_rowtype.attrib350;
   po_rec_nsv.nsv_attrib351   := pi_rowtype.attrib351;
   po_rec_nsv.nsv_attrib352   := pi_rowtype.attrib352;
   po_rec_nsv.nsv_attrib353   := pi_rowtype.attrib353;
   po_rec_nsv.nsv_attrib354   := pi_rowtype.attrib354;
   po_rec_nsv.nsv_attrib355   := pi_rowtype.attrib355;
   po_rec_nsv.nsv_attrib356   := pi_rowtype.attrib356;
   po_rec_nsv.nsv_attrib357   := pi_rowtype.attrib357;
   po_rec_nsv.nsv_attrib358   := pi_rowtype.attrib358;
   po_rec_nsv.nsv_attrib359   := pi_rowtype.attrib359;
   po_rec_nsv.nsv_attrib360   := pi_rowtype.attrib360;
   po_rec_nsv.nsv_attrib361   := pi_rowtype.attrib361;
   po_rec_nsv.nsv_attrib362   := pi_rowtype.attrib362;
   po_rec_nsv.nsv_attrib363   := pi_rowtype.attrib363;
   po_rec_nsv.nsv_attrib364   := pi_rowtype.attrib364;
   po_rec_nsv.nsv_attrib365   := pi_rowtype.attrib365;
   po_rec_nsv.nsv_attrib366   := pi_rowtype.attrib366;
   po_rec_nsv.nsv_attrib367   := pi_rowtype.attrib367;
   po_rec_nsv.nsv_attrib368   := pi_rowtype.attrib368;
   po_rec_nsv.nsv_attrib369   := pi_rowtype.attrib369;
   po_rec_nsv.nsv_attrib370   := pi_rowtype.attrib370;
   po_rec_nsv.nsv_attrib371   := pi_rowtype.attrib371;
   po_rec_nsv.nsv_attrib372   := pi_rowtype.attrib372;
   po_rec_nsv.nsv_attrib373   := pi_rowtype.attrib373;
   po_rec_nsv.nsv_attrib374   := pi_rowtype.attrib374;
   po_rec_nsv.nsv_attrib375   := pi_rowtype.attrib375;
   po_rec_nsv.nsv_attrib376   := pi_rowtype.attrib376;
   po_rec_nsv.nsv_attrib377   := pi_rowtype.attrib377;
   po_rec_nsv.nsv_attrib378   := pi_rowtype.attrib378;
   po_rec_nsv.nsv_attrib379   := pi_rowtype.attrib379;
   po_rec_nsv.nsv_attrib380   := pi_rowtype.attrib380;
   po_rec_nsv.nsv_attrib381   := pi_rowtype.attrib381;
   po_rec_nsv.nsv_attrib382   := pi_rowtype.attrib382;
   po_rec_nsv.nsv_attrib383   := pi_rowtype.attrib383;
   po_rec_nsv.nsv_attrib384   := pi_rowtype.attrib384;
   po_rec_nsv.nsv_attrib385   := pi_rowtype.attrib385;
   po_rec_nsv.nsv_attrib386   := pi_rowtype.attrib386;
   po_rec_nsv.nsv_attrib387   := pi_rowtype.attrib387;
   po_rec_nsv.nsv_attrib388   := pi_rowtype.attrib388;
   po_rec_nsv.nsv_attrib389   := pi_rowtype.attrib389;
   po_rec_nsv.nsv_attrib390   := pi_rowtype.attrib390;
   po_rec_nsv.nsv_attrib391   := pi_rowtype.attrib391;
   po_rec_nsv.nsv_attrib392   := pi_rowtype.attrib392;
   po_rec_nsv.nsv_attrib393   := pi_rowtype.attrib393;
   po_rec_nsv.nsv_attrib394   := pi_rowtype.attrib394;
   po_rec_nsv.nsv_attrib395   := pi_rowtype.attrib395;
   po_rec_nsv.nsv_attrib396   := pi_rowtype.attrib396;
   po_rec_nsv.nsv_attrib397   := pi_rowtype.attrib397;
   po_rec_nsv.nsv_attrib398   := pi_rowtype.attrib398;
   po_rec_nsv.nsv_attrib399   := pi_rowtype.attrib399;
   po_rec_nsv.nsv_attrib400   := pi_rowtype.attrib400;
   po_rec_nsv.nsv_attrib401   := pi_rowtype.attrib401;
   po_rec_nsv.nsv_attrib402   := pi_rowtype.attrib402;
   po_rec_nsv.nsv_attrib403   := pi_rowtype.attrib403;
   po_rec_nsv.nsv_attrib404   := pi_rowtype.attrib404;
   po_rec_nsv.nsv_attrib405   := pi_rowtype.attrib405;
   po_rec_nsv.nsv_attrib406   := pi_rowtype.attrib406;
   po_rec_nsv.nsv_attrib407   := pi_rowtype.attrib407;
   po_rec_nsv.nsv_attrib408   := pi_rowtype.attrib408;
   po_rec_nsv.nsv_attrib409   := pi_rowtype.attrib409;
   po_rec_nsv.nsv_attrib410   := pi_rowtype.attrib410;
   po_rec_nsv.nsv_attrib411   := pi_rowtype.attrib411;
   po_rec_nsv.nsv_attrib412   := pi_rowtype.attrib412;
   po_rec_nsv.nsv_attrib413   := pi_rowtype.attrib413;
   po_rec_nsv.nsv_attrib414   := pi_rowtype.attrib414;
   po_rec_nsv.nsv_attrib415   := pi_rowtype.attrib415;
   po_rec_nsv.nsv_attrib416   := pi_rowtype.attrib416;
   po_rec_nsv.nsv_attrib417   := pi_rowtype.attrib417;
   po_rec_nsv.nsv_attrib418   := pi_rowtype.attrib418;
   po_rec_nsv.nsv_attrib419   := pi_rowtype.attrib419;
   po_rec_nsv.nsv_attrib420   := pi_rowtype.attrib420;
   po_rec_nsv.nsv_attrib421   := pi_rowtype.attrib421;
   po_rec_nsv.nsv_attrib422   := pi_rowtype.attrib422;
   po_rec_nsv.nsv_attrib423   := pi_rowtype.attrib423;
   po_rec_nsv.nsv_attrib424   := pi_rowtype.attrib424;
   po_rec_nsv.nsv_attrib425   := pi_rowtype.attrib425;
   po_rec_nsv.nsv_attrib426   := pi_rowtype.attrib426;
   po_rec_nsv.nsv_attrib427   := pi_rowtype.attrib427;
   po_rec_nsv.nsv_attrib428   := pi_rowtype.attrib428;
   po_rec_nsv.nsv_attrib429   := pi_rowtype.attrib429;
   po_rec_nsv.nsv_attrib430   := pi_rowtype.attrib430;
   po_rec_nsv.nsv_attrib431   := pi_rowtype.attrib431;
   po_rec_nsv.nsv_attrib432   := pi_rowtype.attrib432;
   po_rec_nsv.nsv_attrib433   := pi_rowtype.attrib433;
   po_rec_nsv.nsv_attrib434   := pi_rowtype.attrib434;
   po_rec_nsv.nsv_attrib435   := pi_rowtype.attrib435;
   po_rec_nsv.nsv_attrib436   := pi_rowtype.attrib436;
   po_rec_nsv.nsv_attrib437   := pi_rowtype.attrib437;
   po_rec_nsv.nsv_attrib438   := pi_rowtype.attrib438;
   po_rec_nsv.nsv_attrib439   := pi_rowtype.attrib439;
   po_rec_nsv.nsv_attrib440   := pi_rowtype.attrib440;
   po_rec_nsv.nsv_attrib441   := pi_rowtype.attrib441;
   po_rec_nsv.nsv_attrib442   := pi_rowtype.attrib442;
   po_rec_nsv.nsv_attrib443   := pi_rowtype.attrib443;
   po_rec_nsv.nsv_attrib444   := pi_rowtype.attrib444;
   po_rec_nsv.nsv_attrib445   := pi_rowtype.attrib445;
   po_rec_nsv.nsv_attrib446   := pi_rowtype.attrib446;
   po_rec_nsv.nsv_attrib447   := pi_rowtype.attrib447;
   po_rec_nsv.nsv_attrib448   := pi_rowtype.attrib448;
   po_rec_nsv.nsv_attrib449   := pi_rowtype.attrib449;
   po_rec_nsv.nsv_attrib450   := pi_rowtype.attrib450;
   po_rec_nsv.nsv_attrib451   := pi_rowtype.attrib451;
   po_rec_nsv.nsv_attrib452   := pi_rowtype.attrib452;
   po_rec_nsv.nsv_attrib453   := pi_rowtype.attrib453;
   po_rec_nsv.nsv_attrib454   := pi_rowtype.attrib454;
   po_rec_nsv.nsv_attrib455   := pi_rowtype.attrib455;
   po_rec_nsv.nsv_attrib456   := pi_rowtype.attrib456;
   po_rec_nsv.nsv_attrib457   := pi_rowtype.attrib457;
   po_rec_nsv.nsv_attrib458   := pi_rowtype.attrib458;
   po_rec_nsv.nsv_attrib459   := pi_rowtype.attrib459;
   po_rec_nsv.nsv_attrib460   := pi_rowtype.attrib460;
   po_rec_nsv.nsv_attrib461   := pi_rowtype.attrib461;
   po_rec_nsv.nsv_attrib462   := pi_rowtype.attrib462;
   po_rec_nsv.nsv_attrib463   := pi_rowtype.attrib463;
   po_rec_nsv.nsv_attrib464   := pi_rowtype.attrib464;
   po_rec_nsv.nsv_attrib465   := pi_rowtype.attrib465;
   po_rec_nsv.nsv_attrib466   := pi_rowtype.attrib466;
   po_rec_nsv.nsv_attrib467   := pi_rowtype.attrib467;
   po_rec_nsv.nsv_attrib468   := pi_rowtype.attrib468;
   po_rec_nsv.nsv_attrib469   := pi_rowtype.attrib469;
   po_rec_nsv.nsv_attrib470   := pi_rowtype.attrib470;
   po_rec_nsv.nsv_attrib471   := pi_rowtype.attrib471;
   po_rec_nsv.nsv_attrib472   := pi_rowtype.attrib472;
   po_rec_nsv.nsv_attrib473   := pi_rowtype.attrib473;
   po_rec_nsv.nsv_attrib474   := pi_rowtype.attrib474;
   po_rec_nsv.nsv_attrib475   := pi_rowtype.attrib475;
   po_rec_nsv.nsv_attrib476   := pi_rowtype.attrib476;
   po_rec_nsv.nsv_attrib477   := pi_rowtype.attrib477;
   po_rec_nsv.nsv_attrib478   := pi_rowtype.attrib478;
   po_rec_nsv.nsv_attrib479   := pi_rowtype.attrib479;
   po_rec_nsv.nsv_attrib480   := pi_rowtype.attrib480;
   po_rec_nsv.nsv_attrib481   := pi_rowtype.attrib481;
   po_rec_nsv.nsv_attrib482   := pi_rowtype.attrib482;
   po_rec_nsv.nsv_attrib483   := pi_rowtype.attrib483;
   po_rec_nsv.nsv_attrib484   := pi_rowtype.attrib484;
   po_rec_nsv.nsv_attrib485   := pi_rowtype.attrib485;
   po_rec_nsv.nsv_attrib486   := pi_rowtype.attrib486;
   po_rec_nsv.nsv_attrib487   := pi_rowtype.attrib487;
   po_rec_nsv.nsv_attrib488   := pi_rowtype.attrib488;
   po_rec_nsv.nsv_attrib489   := pi_rowtype.attrib489;
   po_rec_nsv.nsv_attrib490   := pi_rowtype.attrib490;
   po_rec_nsv.nsv_attrib491   := pi_rowtype.attrib491;
   po_rec_nsv.nsv_attrib492   := pi_rowtype.attrib492;
   po_rec_nsv.nsv_attrib493   := pi_rowtype.attrib493;
   po_rec_nsv.nsv_attrib494   := pi_rowtype.attrib494;
   po_rec_nsv.nsv_attrib495   := pi_rowtype.attrib495;
   po_rec_nsv.nsv_attrib496   := pi_rowtype.attrib496;
   po_rec_nsv.nsv_attrib497   := pi_rowtype.attrib497;
   po_rec_nsv.nsv_attrib498   := pi_rowtype.attrib498;
   po_rec_nsv.nsv_attrib499   := pi_rowtype.attrib499;
   po_rec_nsv.nsv_attrib500   := pi_rowtype.attrib500;
--
END pop_rec_nsv_from_inv_val_mem;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_val_from_rec_nsv (p_attrib_number IN NUMBER) RETURN VARCHAR2 IS
BEGIN
--
   IF  p_attrib_number NOT BETWEEN 1 AND 500
    OR p_attrib_number != TRUNC(p_attrib_number)
    OR p_attrib_number IS NULL
    THEN
      g_value := Null;
   ELSE
      EXECUTE IMMEDIATE         'BEGIN'
                     ||CHR(10)||'   '||g_package_name||'.g_value := '||g_package_name||'.g_rec_nsv.nsv_attrib'||p_attrib_number||';'
                     ||CHR(10)||'END;';
   END IF;
--
   RETURN g_value;
--
END get_val_from_rec_nsv;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE get_route_offsets (pi_job_id IN nm_mrg_sections.nms_mrg_job_id%TYPE) IS
--
   CURSOR cs_nms (c_job_id nm_mrg_sections.nms_mrg_job_id%TYPE) IS
   SELECT nms.ROWID
         ,nms_ne_id_first
         ,nms_begin_mp_first
         ,nms_ne_id_last
         ,nms_end_mp_last
     FROM nm_mrg_sections     nms
   WHERE  nms.nms_mrg_job_id  = c_job_id;
--
   l_tab_rowid             nm3type.tab_rowid;
   l_tab_ne_id_first       nm3type.tab_number;
   l_tab_begin_mp_first    nm3type.tab_number;
   l_tab_ne_id_last        nm3type.tab_number;
   l_tab_end_mp_last       nm3type.tab_number;
--
   l_tab_route_ne_id       nm3type.tab_number;
   l_tab_begin_offset      nm3type.tab_number;
   l_tab_end_offset        nm3type.tab_number;
--
   l_last_parent           NUMBER := -1;
   l_last_child            NUMBER := -1;
--
   l_p_unit                NUMBER;
   l_c_unit                NUMBER;
--
   l_last_p_unit           NUMBER := -1;
   l_last_c_unit           NUMBER := -1;
--
   l_factor                NUMBER;
   l_datum_length          NUMBER;
   l_route_ne_id           NUMBER;
--
   no_slk                  EXCEPTION;
--
   l_format_mask           nm_units.un_format_mask%TYPE;
   l_no_unit               BOOLEAN;
--
   CURSOR cs_nmm (c_ne_id NUMBER) IS
   SELECT route_ne_id
         ,element_length
    FROM  nm_mrg_members
   WHERE  nm_ne_id_of = c_ne_id;
--
   FUNCTION get_new_offset (p_ne_id_in    NUMBER
                           ,p_ne_id_of    NUMBER
                           ,p_mp          NUMBER
                           ,p_conv_factor NUMBER
                           ,p_datum_len   NUMBER
                           ,p_format_mask VARCHAR2 DEFAULT NULL
                           ) RETURN NUMBER IS
--
      CURSOR cs_nm (c_in NUMBER, c_of NUMBER, c_mp NUMBER) IS
      SELECT nm_cardinality
            ,nm_slk
       FROM  nm_members
      WHERE  nm_ne_id_in = c_in
       AND   nm_ne_id_of = c_of
       AND   c_mp BETWEEN nm_begin_mp AND NVL(nm_end_mp,c_mp);
--
      l_num    NUMBER;
      l_slk    NUMBER := 0;
      l_card   NUMBER := 1;
--
      l_answer NUMBER;
--
   BEGIN
--
      OPEN  cs_nm (p_ne_id_in,p_ne_id_of,p_mp);
      FETCH cs_nm INTO l_card, l_slk;
      CLOSE cs_nm;
--
      IF l_card = 1
       THEN
         l_num := p_mp;
      ELSE
         l_num := p_datum_len - p_mp;
      END IF;
--
      l_answer := l_slk + (l_num * p_conv_factor);
--
      IF p_format_mask IS NOT NULL
       THEN
         l_answer := TO_NUMBER(TO_CHAR(l_answer,p_format_mask));
      END IF;
--
      RETURN l_answer;
--
   END get_new_offset;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_route_offsets');
--
   OPEN  cs_nms (pi_job_id);
   FETCH cs_nms
    BULK COLLECT INTO l_tab_rowid
                     ,l_tab_ne_id_first
                     ,l_tab_begin_mp_first
                     ,l_tab_ne_id_last
                     ,l_tab_end_mp_last;
   CLOSE cs_nms;
--
   FOR i IN 1..l_tab_rowid.COUNT
    LOOP
--
      l_route_ne_id  := -1;
      l_datum_length := 0;
--
      OPEN  cs_nmm (l_tab_ne_id_first(i));
      FETCH cs_nmm INTO l_route_ne_id, l_datum_length;
      CLOSE cs_nmm;
      l_tab_route_ne_id(i) := l_route_ne_id;
--
      IF l_last_parent != l_tab_route_ne_id(i)
       THEN
         BEGIN
            l_p_unit   := nm3net.get_gty_units( nm3net.get_gty_type( l_tab_route_ne_id(i) ));
         EXCEPTION
            WHEN OTHERS
             THEN
               l_p_unit:= nm3net.get_nt_units( nm3net.get_nt_type( l_tab_route_ne_id(i) ));
         END;
         l_last_parent := l_tab_route_ne_id(i);
         l_format_mask := nm3unit.get_unit_mask (l_p_unit);
      END IF;
--
      IF l_last_child  != l_tab_ne_id_first(i)
       THEN
         l_c_unit      := nm3net.get_nt_units( nm3net.get_nt_type( l_tab_ne_id_first(i) ));
         l_last_child  := l_tab_ne_id_first(i);
      END IF;
--
      IF  l_last_p_unit != l_p_unit
       OR l_last_c_unit != l_c_unit
       THEN
         l_factor  := Null;
         l_no_unit := FALSE;
         IF  l_c_unit IS NULL
          OR l_p_unit IS NULL
          THEN
            l_no_unit := TRUE;
         ELSIF l_p_unit = l_c_unit
          THEN
            l_factor  := 1;
         ELSE
            l_factor := nm3unit.get_uc(l_c_unit,l_p_unit).uc_conversion_factor;
         END IF;
         l_last_p_unit := l_p_unit;
         l_last_c_unit := l_c_unit;
      END IF;
--
      IF l_no_unit
       THEN
         l_tab_begin_offset(i) := -1;
      ELSIF l_factor IS NULL
       THEN
         l_tab_begin_offset(i) := nm3lrs.get_set_offset (p_ne_parent_id => l_route_ne_id
                                                        ,p_ne_child_id  => l_tab_ne_id_first(i)
                                                        ,p_offset       => l_tab_begin_mp_first(i)
                                                        );
      ELSE
         l_tab_begin_offset(i) := get_new_offset (p_ne_id_in    => l_route_ne_id
                                                 ,p_ne_id_of    => l_tab_ne_id_first(i)
                                                 ,p_mp          => l_tab_begin_mp_first(i)
                                                 ,p_conv_factor => l_factor
                                                 ,p_datum_len   => l_datum_length
                                                 ,p_format_mask => l_format_mask
                                                 );
      END IF;
--
      IF   l_tab_ne_id_first(i)    = l_tab_ne_id_last(i)
       AND l_tab_begin_mp_first(i) = l_tab_end_mp_last(i)
       THEN
         -- This is a point
         l_tab_end_offset(i)   := l_tab_begin_offset(i);
      ELSE
--
         IF l_no_unit
          THEN
            l_tab_end_offset(i)   := -1;
         ELSIF l_factor IS NULL
          THEN
            l_tab_end_offset(i)   := nm3lrs.get_set_offset (p_ne_parent_id => l_route_ne_id
                                                           ,p_ne_child_id  => l_tab_ne_id_last(i)
                                                           ,p_offset       => l_tab_end_mp_last(i)
                                                           );
         ELSE
   --
            OPEN  cs_nmm (l_tab_ne_id_first(i));
            FETCH cs_nmm INTO l_route_ne_id, l_datum_length;
            CLOSE cs_nmm;
   --
            l_tab_end_offset(i)   := get_new_offset (p_ne_id_in    => l_route_ne_id
                                                    ,p_ne_id_of    => l_tab_ne_id_last(i)
                                                    ,p_mp          => l_tab_end_mp_last(i)
                                                    ,p_conv_factor => l_factor
                                                    ,p_datum_len   => l_datum_length
                                                    ,p_format_mask => l_format_mask
                                                    );
         END IF;
      END IF;
      IF  l_tab_end_offset(i)   IS NULL
       OR l_tab_begin_offset(i) IS NULL
       THEN
         RAISE no_slk;
      END IF;
--
   END LOOP;
--
   FORALL i IN 1..l_tab_rowid.COUNT
    UPDATE nm_mrg_sections
     SET   nms_offset_ne_id = l_tab_route_ne_id(i)
          ,nms_begin_offset = l_tab_begin_offset(i)
          ,nms_end_offset   = l_tab_end_offset(i)
    WHERE  ROWID            = l_tab_rowid(i);
--
   nm_debug.proc_end(g_package_name,'get_route_offsets');
--
EXCEPTION
--
   WHEN no_slk
    THEN
      RAISE_APPLICATION_ERROR(-20001,'Route '||nm3net.get_ne_unique(l_last_parent)||' needs to be rescaled. Not all datums have SLK');
--
END get_route_offsets;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_locations_which_match RETURN nm_placement_array IS
--
   l_pl nm_placement_array := nm3pla.initialise_placement_array;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_locations_which_match');
--
--   nm_debug.debug(g_matching_loc);
   EXECUTE IMMEDIATE g_matching_loc;
--
--   nm_debug.debug(g_tab_ne_id_of.COUNT);
   FOR i IN 1..g_tab_ne_id_of.COUNT
    LOOP
      nm3pla.add_element_to_pl_arr (l_pl
                                   ,g_tab_ne_id_of(i)
                                   ,g_tab_begin_mp(i)
                                   ,g_tab_end_mp(i)
                                   ,0
                                   ,FALSE
                                   );
   END LOOP;
--
--   nm_debug.debug('Built the Placement Array');
   -- Defragment the placement array
   IF g_tab_ne_id_of.count > 1
    THEN
      l_pl := nm3pla.defrag_placement_array(l_pl);
--      nm_debug.debug('Defragged the Placement Array');
   END IF;
--
   g_tab_ne_id_of.delete ;
   g_tab_begin_mp.delete ;
   g_tab_end_mp.delete ;
--
   nm_debug.proc_end(g_package_name,'get_locations_which_match');
   RETURN l_pl;
--
END get_locations_which_match;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE build_up_sql_for_matching_locs (p_nqt_seq_no NUMBER) IS
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
      l_text VARCHAR2(32767) := p_text;
   BEGIN
      IF p_nl
       THEN
         l_text := l_text||CHR(10);
      END IF;
      g_matching_loc := g_matching_loc||l_text;
   END append;
--
BEGIN
--
   g_matching_loc := Null;
--
   append ('DECLARE');
   append ('   /* NQT_SEQ_NO - '||p_nqt_seq_no||' */');
   append ('   c_nvl CONSTANT VARCHAR2(30) := nm3type.c_nvl;');
   append ('   CURSOR cs_match (c_row '||g_package_name||'.rec_distinct)IS');
   append ('   SELECT /*+ index ( nmm nmm2_uk ) index ( nmqrt NMQRT2_NE_ID_TYPE ) */');
   append ('          nmm.nm_ne_id_of');
   append ('         ,nmm.nm_begin_mp');
   append ('         ,nmm.nm_end_mp');
   append ('    FROM  nm_mrg_query_results_temp2 nmqrt');
   append ('         ,nm_mrg_members2            nmm');
   append ('   WHERE  nmm.nm_ne_id_in = nmqrt.ne_id');
   append ('    AND   nmm.inv_type    = nmqrt.inv_type');
--
   FOR i IN 1..nm3mrg.g_tab_rec_query_attribs.COUNT
    LOOP
      IF nm3mrg.g_tab_rec_query_attribs(i).nqa_nqt_seq_no = p_nqt_seq_no
       THEN
         append ('     AND  NVL(nmqrt.attrib'||i||',c_nvl) = NVL(c_row.attrib'||i||',c_nvl)');
      END IF;
   END LOOP;
--
   append ('   ORDER BY nmm.nm_seq_no, nmm.nm_begin_mp;');
   append ('BEGIN');
   append ('   OPEN  cs_match ('||g_package_name||'.g_rec_distinct);');
   append ('   FETCH cs_match ');
   append ('    BULK COLLECT');
   append ('    INTO '||g_package_name||'.g_tab_ne_id_of');
   append ('        ,'||g_package_name||'.g_tab_begin_mp');
   append ('        ,'||g_package_name||'.g_tab_end_mp;');
   append ('   CLOSE cs_match;');
   append ('END;');
--
END build_up_sql_for_matching_locs;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE build_up_sql_individual_point (p_job_id NUMBER) IS
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
      l_text VARCHAR2(32767) := p_text;
   BEGIN
      IF p_nl
       THEN
         l_text := CHR(10)||l_text;
      END IF;
      g_matching_loc := g_matching_loc||l_text;
   END append;
--
BEGIN
--
   g_matching_loc := Null;
--
   append ('DECLARE');
   append ('   c_nvl CONSTANT VARCHAR2(30) := nm3type.c_nvl;');
   append ('   CURSOR cs_match IS');
   append ('   SELECT /*+ RULE */');
   append ('          nsv_value_id');
   append ('    FROM  nm_mrg_section_inv_values');
   append ('   WHERE  nsv_mrg_job_id        = '||p_job_id);
   append ('    AND   nsv_inv_type          = nm3mrg.l_rec_nsv.nsv_inv_type');
   append ('    AND   NVL(nsv_x_sect,c_nvl) = NVL(nm3mrg.l_rec_nsv.nsv_x_sect,c_nvl)');
   append ('    AND   nsv_pnt_or_cont       = nm3mrg.l_rec_nsv.nsv_pnt_or_cont');
--
   FOR j IN 1..nm3mrg.g_tab_rec_query_types.COUNT
    LOOP
      IF  nm3mrg.g_single_point_merge  -- If we are merging on a single point then all inventory is treated as point
       OR nm3inv.get_inv_type(nm3mrg.g_tab_rec_query_types(j).nqt_inv_type).nit_pnt_or_cont = 'P'
       THEN
         FOR i IN 1..nm3mrg.g_tab_rec_query_attribs.COUNT
          LOOP
            IF nm3mrg.g_tab_rec_query_attribs(i).nqa_nqt_seq_no = nm3mrg.g_tab_rec_query_types(j).nqt_seq_no
             THEN
               append ('     AND  NVL(nsv_attrib'||i||',c_nvl) = NVL(nm3mrg.l_rec_nsv.nsv_attrib'||i||',c_nvl)');
            END IF;
         END LOOP;
      END IF;
   END LOOP;
--
   append (';',FALSE);
   append ('BEGIN');
   append ('   nm3mrg.l_rec_nsv.nsv_value_id := Null;');
   append ('   OPEN  cs_match;');
   append ('   FETCH cs_match ');
   append ('    INTO nm3mrg.l_rec_nsv.nsv_value_id;');
   append ('   CLOSE cs_match;');
   append ('END;');
--
   EXECUTE IMMEDIATE g_matching_loc;
--
END build_up_sql_individual_point;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE deal_with_point_continous_inv (pi_job_id IN nm_mrg_sections.nms_mrg_job_id%TYPE) IS
BEGIN
   --
   nm_debug.proc_start(g_package_name,'deal_with_point_continous_inv');
   --
   -- This chunk is for dealing with continous items which are located at a single point
   --
   INSERT INTO nm_mrg_sections
          (nms_mrg_job_id
          ,nms_mrg_section_id
          ,nms_offset_ne_id
          ,nms_begin_offset
          ,nms_end_offset
          ,nms_ne_id_first
          ,nms_begin_mp_first
          ,nms_ne_id_last
          ,nms_end_mp_last
          ,nms_orig_sect_id
          )
   SELECT  pi_job_id
          ,section_id
          ,-1
          ,-1
          ,-1
          ,ne_id_of
          ,begin_mp
          ,ne_id_of
          ,end_mp
          ,section_id
    FROM  (SELECT nm3mrg.get_nm_mrg_query_staging_seq section_id FROM DUAL)
         ,nm_mrg_query_members_temp
   WHERE  begin_mp    = end_mp
    AND   pnt_or_cont = 'C';
--
   IF SQL%ROWCOUNT > 0
    THEN
   --
      nm3mrg.g_resequence_reqd := TRUE;
   --
      INSERT INTO nm_mrg_section_members
            (nsm_mrg_job_id
            ,nsm_mrg_section_id
            ,nsm_ne_id
            ,nsm_begin_mp
            ,nsm_end_mp
            ,nsm_measure
            )
      SELECT nms_mrg_job_id
            ,nms_mrg_section_id
            ,nms_ne_id_first
            ,nms_begin_mp_first
            ,nms_end_mp_last
            ,0
       FROM  nm_mrg_sections
      WHERE  nms_mrg_job_id     = pi_job_id
       AND   nms_ne_id_first    = nms_ne_id_last
       AND   nms_begin_mp_first = nms_end_mp_last;
   --
   END IF;
   --
   nm_debug.proc_end(g_package_name,'deal_with_point_continous_inv');
   --
END deal_with_point_continous_inv;
--
------------------------------------------------------------------------------------------------
--
BEGIN
--
   -- Do a dummy call to nm3mrg so that any instantiation code in there gets run
   DECLARE
      l_dummy VARCHAR2(4000);
   BEGIN
      l_dummy := nm3mrg.get_body_version;
   END;
--
end nm3mrg_supplementary;
/
