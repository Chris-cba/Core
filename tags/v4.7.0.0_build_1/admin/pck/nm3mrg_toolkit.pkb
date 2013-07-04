CREATE OR REPLACE PACKAGE BODY nm3mrg_toolkit AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg_toolkit.pkb-arc   2.3   Jul 04 2013 16:16:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3mrg_toolkit.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:16:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:16  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.2
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   Merge Additional Tools package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3mrg_toolkit';
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
------------------------------------------------------------------------------------------------
--
FUNCTION copy_mrg_query (pi_nmq_unique_old IN nm_mrg_query.nmq_unique%TYPE
                        ,pi_nmq_unique_new IN nm_mrg_query.nmq_unique%TYPE
                        ,pi_nmq_descr_new  IN nm_mrg_query.nmq_descr%TYPE  DEFAULT NULL
                        ,pi_create_views   IN BOOLEAN                      DEFAULT TRUE
                        ) RETURN nm_mrg_query.nmq_id%TYPE IS
BEGIN
--
   RETURN copy_mrg_query (pi_nmq_id_old     => nm3get.get_nmq (pi_nmq_unique => pi_nmq_unique_old).nmq_id
                         ,pi_nmq_unique_new => pi_nmq_unique_new
                         ,pi_nmq_descr_new  => pi_nmq_descr_new
                         ,pi_create_views   => pi_create_views
                         );
--
END copy_mrg_query;
--
------------------------------------------------------------------------------------------------
--
FUNCTION copy_mrg_query (pi_nmq_id_old     IN nm_mrg_query.nmq_id%TYPE
                        ,pi_nmq_unique_new IN nm_mrg_query.nmq_unique%TYPE
                        ,pi_nmq_descr_new  IN nm_mrg_query.nmq_descr%TYPE  DEFAULT NULL
                        ,pi_create_views   IN BOOLEAN                      DEFAULT TRUE
                        ) RETURN nm_mrg_query.nmq_id%TYPE IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_rec_nmq    nm_mrg_query%ROWTYPE;
   l_tab_nmf_id nm3type.tab_number;
   l_rec_nmf    nm_mrg_output_file%ROWTYPE;
   l_retval     nm_mrg_query.nmq_id%TYPE;
--
BEGIN
--
--nm_debug.delete_debug(TRUE);
--nm_Debug.debug_on;
   nm_debug.proc_start(g_package_name,'copy_mrg_query');
--
   l_rec_nmq := nm3get.get_nmq (pi_nmq_id => pi_nmq_id_old);
--
   IF nm3get.get_nmq (pi_nmq_unique       => pi_nmq_unique_new
                     ,pi_raise_not_found  => FALSE
                     ).nmq_id IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => pi_nmq_unique_new
                    );
   END IF;
--
   nm3lock_gen.lock_nmq (pi_nmq_id => pi_nmq_id_old);
--
   l_retval               := nm3seq.next_nmq_id_seq;
   l_rec_nmq.nmq_id       := l_retval;
   l_rec_nmq.nmq_unique   := pi_nmq_unique_new;
   IF pi_nmq_descr_new IS NOT NULL
    THEN
      l_rec_nmq.nmq_descr := pi_nmq_descr_new;
   END IF;
   nm3ins.ins_nmq (l_rec_nmq);
   -- Need to reassign here as it will have been blanked by the "RETURNING" clause
   --  if you are a restricted user
   l_rec_nmq.nmq_id       := l_retval;
--
   INSERT INTO nm_mrg_query_roles
         (nqro_nmq_id
         ,nqro_role
         ,nqro_mode
         )
   SELECT l_retval
         ,nqro_role
         ,nqro_mode
    FROM  nm_mrg_query_roles
   WHERE  nqro_nmq_id = pi_nmq_id_old;
--
   IF NOT nm3mrg_security.is_query_updatable (l_rec_nmq.nmq_id)
    THEN
      -- If the user only had readonly on the
      --  query then give NORMAL to a role that the user has
      DECLARE
         CURSOR cs_role IS
         SELECT hur_role
          FROM  hig_user_roles
         WHERE  hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
         ORDER BY DECODE(INSTR(hur_role,'MERGE',1,1)
                        ,0,2
                        ,1
                        ) -- Get out any roles with the word "MERGE" in them first
                 ,DECODE(SUBSTR(hur_role,1,3)
                        ,nm3type.c_hig,2
                        ,nm3type.c_net,3
                        ,4
                        );
         l_found    BOOLEAN;
         l_rec_nqro nm_mrg_query_roles%ROWTYPE;
      BEGIN
         --
         OPEN  cs_role;
         FETCH cs_role
          INTO l_rec_nqro.nqro_role;
         l_found := cs_role%FOUND;
         CLOSE cs_role;
         --
         IF NOT l_found
          THEN -- should never happen. all users should at least have HIG_USER
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 28
                          ,pi_supplementary_info => 'User has no roles'
                          );
         END IF;
         --
         -- Delete the row if there is one here
         nm3del.del_nqro (pi_nqro_nmq_id     => l_rec_nmq.nmq_id
                         ,pi_nqro_role       => l_rec_nqro.nqro_role
                         ,pi_raise_not_found => FALSE
                         );
         --
         -- Create the new row
         l_rec_nqro.nqro_nmq_id := l_rec_nmq.nmq_id;
         l_rec_nqro.nqro_mode   := nm3type.c_normal;
         nm3ins.ins_nqro (l_rec_nqro);
         --
      END;
   END IF;
   --
   nm3mrg_security.reset_security_state_for_nmq (l_rec_nmq.nmq_id);
--
   INSERT INTO nm_mrg_query_types
         (nqt_nmq_id
         ,nqt_seq_no
         ,nqt_inv_type
         ,nqt_x_sect
         ,nqt_default
         )
   SELECT l_rec_nmq.nmq_id
         ,nqt_seq_no
         ,nqt_inv_type
         ,nqt_x_sect
         ,nqt_default
    FROM  nm_mrg_query_types
   WHERE  nqt_nmq_id = pi_nmq_id_old;
--
   INSERT INTO nm_mrg_query_attribs
         (nqa_nmq_id
         ,nqa_nqt_seq_no
         ,nqa_attrib_name
         ,nqa_condition
         ,nqa_itb_banding_id
         )
   SELECT l_rec_nmq.nmq_id
         ,nqa_nqt_seq_no
         ,nqa_attrib_name
         ,nqa_condition
         ,nqa_itb_banding_id
    FROM  nm_mrg_query_attribs
   WHERE  nqa_nmq_id = pi_nmq_id_old;
--
   INSERT INTO nm_mrg_query_values
         (nqv_nmq_id
         ,nqv_nqt_seq_no
         ,nqv_attrib_name
         ,nqv_sequence
         ,nqv_value
         )
   SELECT l_rec_nmq.nmq_id
         ,nqv_nqt_seq_no
         ,nqv_attrib_name
         ,nqv_sequence
         ,nqv_value
    FROM  nm_mrg_query_values
   WHERE  nqv_nmq_id = pi_nmq_id_old;
--
   IF pi_create_views
    THEN
      nm3mrg_view.build_view (p_mrg_query_id => l_rec_nmq.nmq_id);
   END IF;
--
   SELECT nmf_id
    BULK  COLLECT
    INTO  l_tab_nmf_id
    FROM  nm_mrg_output_file
   WHERE  nmf_nmq_id = pi_nmq_id_old;
--
   FOR i IN 1..l_tab_nmf_id.COUNT
    LOOP
      nm3mrg_output.duplicate_nmf_and_procs
                       (pi_nmf_id     => l_tab_nmf_id(i)
                       ,pi_nmq_id_new => l_rec_nmq.nmq_id
                       );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'copy_mrg_query');
--
   COMMIT;
--
   RETURN l_retval;
--
END copy_mrg_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_condition_to_query (pi_nmq_id            IN nm_mrg_query.nmq_id%TYPE
                                 ,pi_nit_inv_type      IN nm_inv_types.nit_inv_type%TYPE
                                 ,pi_ita_view_col_name IN nm_inv_type_attribs.ita_view_col_name%TYPE
                                 ,pi_nqa_condition     IN nm_mrg_query_attribs.nqa_condition%TYPE
                                 ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_condition_to_query');
--
   add_condition_to_query (pi_nmq_id            => pi_nmq_id
                          ,pi_nit_inv_type      => pi_nit_inv_type
                          ,pi_iit_x_sect        => Null
                          ,pi_ita_view_col_name => pi_ita_view_col_name
                          ,pi_nqa_condition     => pi_nqa_condition
                          );
--
   nm_debug.proc_end(g_package_name,'add_condition_to_query');
--
END add_condition_to_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_condition_to_query (pi_nmq_id            IN nm_mrg_query.nmq_id%TYPE
                                 ,pi_nit_inv_type      IN nm_inv_types.nit_inv_type%TYPE
                                 ,pi_iit_x_sect        IN nm_inv_items.iit_x_sect%TYPE
                                 ,pi_ita_view_col_name IN nm_inv_type_attribs.ita_view_col_name%TYPE
                                 ,pi_nqa_condition     IN nm_mrg_query_attribs.nqa_condition%TYPE
                                 ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_condition_to_query');
--
   add_condition_to_query (pi_nmq_id            => pi_nmq_id
                          ,pi_nit_inv_type      => pi_nit_inv_type
                          ,pi_iit_x_sect        => pi_iit_x_sect
                          ,pi_ita_view_col_name => pi_ita_view_col_name
                          ,pi_nqa_condition     => pi_nqa_condition
                          ,pi_value             => Null
                          );
--
   nm_debug.proc_end(g_package_name,'add_condition_to_query');
--
END add_condition_to_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_condition_to_query (pi_nmq_id            IN nm_mrg_query.nmq_id%TYPE
                                 ,pi_nit_inv_type      IN nm_inv_types.nit_inv_type%TYPE
                                 ,pi_ita_view_col_name IN nm_inv_type_attribs.ita_view_col_name%TYPE
                                 ,pi_nqa_condition     IN nm_mrg_query_attribs.nqa_condition%TYPE
                                 ,pi_value             IN nm_mrg_query_values.nqv_value%TYPE
                                 ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_condition_to_query');
--
    add_condition_to_query (pi_nmq_id            => pi_nmq_id
                           ,pi_nit_inv_type      => pi_nit_inv_type
                           ,pi_iit_x_sect        => Null
                           ,pi_ita_view_col_name => pi_ita_view_col_name
                           ,pi_nqa_condition     => pi_nqa_condition
                           ,pi_value             => pi_value
                           );
--
   nm_debug.proc_end(g_package_name,'add_condition_to_query');
--
END add_condition_to_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_condition_to_query (pi_nmq_id            IN nm_mrg_query.nmq_id%TYPE
                                 ,pi_nit_inv_type      IN nm_inv_types.nit_inv_type%TYPE
                                 ,pi_iit_x_sect        IN nm_inv_items.iit_x_sect%TYPE
                                 ,pi_ita_view_col_name IN nm_inv_type_attribs.ita_view_col_name%TYPE
                                 ,pi_nqa_condition     IN nm_mrg_query_attribs.nqa_condition%TYPE
                                 ,pi_value             IN nm_mrg_query_values.nqv_value%TYPE
                                 ) IS
   l_tab_values nm3type.tab_varchar2000;
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_condition_to_query');
--
   IF pi_value IS NOT NULL
    THEN
      l_tab_values(1) := pi_value;
   END IF;
--
   add_condition_to_query (pi_nmq_id            => pi_nmq_id
                          ,pi_nit_inv_type      => pi_nit_inv_type
                          ,pi_iit_x_sect        => pi_iit_x_sect
                          ,pi_ita_view_col_name => pi_ita_view_col_name
                          ,pi_nqa_condition     => pi_nqa_condition
                          ,pi_tab_values        => l_tab_values
                          );
--
   nm_debug.proc_end(g_package_name,'add_condition_to_query');
--
END add_condition_to_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_condition_to_query (pi_nmq_id            IN nm_mrg_query.nmq_id%TYPE
                                 ,pi_nit_inv_type      IN nm_inv_types.nit_inv_type%TYPE
                                 ,pi_ita_view_col_name IN nm_inv_type_attribs.ita_view_col_name%TYPE
                                 ,pi_nqa_condition     IN nm_mrg_query_attribs.nqa_condition%TYPE
                                 ,pi_tab_values        IN nm3type.tab_varchar2000
                                 ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_condition_to_query');
--
   add_condition_to_query (pi_nmq_id            => pi_nmq_id
                          ,pi_nit_inv_type      => pi_nit_inv_type
                          ,pi_iit_x_sect        => Null
                          ,pi_ita_view_col_name => pi_ita_view_col_name
                          ,pi_nqa_condition     => pi_nqa_condition
                          ,pi_tab_values        => pi_tab_values
                          );
--
   nm_debug.proc_end(g_package_name,'add_condition_to_query');
--
END add_condition_to_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_condition_to_query (pi_nmq_id            IN nm_mrg_query.nmq_id%TYPE
                                 ,pi_nit_inv_type      IN nm_inv_types.nit_inv_type%TYPE
                                 ,pi_iit_x_sect        IN nm_inv_items.iit_x_sect%TYPE
                                 ,pi_ita_view_col_name IN nm_inv_type_attribs.ita_view_col_name%TYPE
                                 ,pi_nqa_condition     IN nm_mrg_query_attribs.nqa_condition%TYPE
                                 ,pi_tab_values        IN nm3type.tab_varchar2000
                                 ) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_condition_to_query');
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_mrg_query_types
                  WHERE  nqt_nmq_id   = pi_nmq_id
                   AND   nqt_inv_type = pi_nit_inv_type
                   AND ((pi_iit_x_sect IS NULL AND nqt_x_sect IS NULL)
                        OR pi_iit_x_sect = nqt_x_sect
                       )
                 )
    LOOP
      FOR cs_inner IN (SELECT nqa_attrib_name, nqa.ROWID nqa_rowid
                        FROM  nm_mrg_query_attribs nqa
                             ,nm_inv_type_attribs  ita
                       WHERE  nqa.nqa_attrib_name   = ita.ita_attrib_name
                        AND   nqa.nqa_nmq_id        = pi_nmq_id
                        AND   nqa.nqa_nqt_seq_no    = cs_rec.nqt_seq_no
                        AND   ita.ita_inv_type      = cs_rec.nqt_inv_type
                        AND   ita.ita_view_col_name = pi_ita_view_col_name
                      )
       LOOP
         UPDATE nm_mrg_query_attribs
          SET   nqa_condition   = pi_nqa_condition
         WHERE  ROWID           = cs_inner.nqa_rowid;
         DELETE FROM nm_mrg_query_values
         WHERE  nqv_nmq_id      = pi_nmq_id
          AND   nqv_nqt_seq_no  = cs_rec.nqt_seq_no
          AND   nqv_attrib_name = cs_inner.nqa_attrib_name;
         FOR i IN 1..pi_tab_values.COUNT
          LOOP
            INSERT INTO nm_mrg_query_values
                   (nqv_nmq_id
                   ,nqv_nqt_seq_no
                   ,nqv_attrib_name
                   ,nqv_sequence
                   ,nqv_value
                   )
            VALUES (pi_nmq_id
                   ,cs_rec.nqt_seq_no
                   ,cs_inner.nqa_attrib_name
                   ,i
                   ,SUBSTR(pi_tab_values(i),1,80)
                   );
         END LOOP;
      END LOOP;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'add_condition_to_query');
--
END add_condition_to_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_mrg_results_into_table (pi_nqr_job_id          IN nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                        ,pi_view_name           IN VARCHAR2
                                        ,pi_table_name          IN VARCHAR2
                                        ,pi_view_mrg_job_id_col IN VARCHAR2
                                        ,pi_grr_job_id          IN gri_report_runs.grr_job_id%TYPE DEFAULT NULL
                                        ,pi_grr_job_id_col      IN VARCHAR2                        DEFAULT NULL
                                        ) IS
--
   l_tab_cols nm3type.tab_varchar30;
   l_insert   nm3type.max_varchar2;
--
   l_bracket  VARCHAR2(1);
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_insert := l_insert||p_text;
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'insert_mrg_results_into_table');
--
   SELECT tc1.column_name
    BULK  COLLECT
    INTO  l_tab_cols
    FROM  all_tab_columns tc1
         ,all_tab_columns tc2
   WHERE  tc1.owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   tc2.owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   tc1.table_name  = pi_view_name
    AND   tc2.table_name  = pi_table_name
    AND   tc1.column_name = tc2.column_name
   ORDER BY tc1.column_id;
--
   append ('INSERT INTO '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||pi_table_name,FALSE);
   l_bracket := '(';
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      append (l_bracket||l_tab_cols(i));
      l_bracket := ',';
   END LOOP;
   IF   pi_grr_job_id_col IS NOT NULL
    AND pi_grr_job_id     IS NOT NULL
    THEN
      append (l_bracket||pi_grr_job_id_col);
   END IF;
   append (')');
--
   append ('SELECT');
   l_bracket := ' ';
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      append (l_bracket||l_tab_cols(i));
      l_bracket := ',';
   END LOOP;
   IF   pi_grr_job_id_col IS NOT NULL
    AND pi_grr_job_id     IS NOT NULL
    THEN
      append (l_bracket||pi_grr_job_id);
   END IF;
   append (' FROM '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||pi_view_name);
   append ('WHERE '||pi_view_mrg_job_id_col||' = '||pi_nqr_job_id);
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm_debug.set_level(3);
--   nm_debug.debug(l_insert);
--   nm_debug.debug_off;
--
   EXECUTE IMMEDIATE l_insert;
--
   nm_debug.proc_end(g_package_name,'insert_mrg_results_into_table');
--
END insert_mrg_results_into_table;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_grp_for_mrg_conditions (pi_grp_job_id IN gri_run_parameters.grp_job_id%TYPE
                                        ,pi_grp_param  IN gri_run_parameters.grp_param%TYPE
                                        ) RETURN nm3type.tab_varchar2000 IS
   l_tab_grp_value nm3type.tab_varchar2000;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_grp_for_mrg_conditions');
--
   SELECT SUBSTR(grp_value,1,80)
    BULK  COLLECT
    INTO  l_tab_grp_value
    FROM  gri_run_parameters
   WHERE  grp_job_id = pi_grp_job_id
    AND   grp_param  = pi_grp_param
   ORDER BY grp_seq;
--
   nm_debug.proc_end(g_package_name,'get_tab_grp_for_mrg_conditions');
--
   RETURN l_tab_grp_value;
--
END get_tab_grp_for_mrg_conditions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_condition_from_array_count (pi_array_count IN BINARY_INTEGER
                                        ) RETURN VARCHAR2 IS
   l_condition            nm_mrg_query_attribs.nqa_condition%TYPE;
BEGIN
   IF pi_array_count = 0
    THEN
      l_condition := 'IS NULL';
   ELSIF pi_array_count = 1
    THEN
      l_condition := '=';
   ELSE
      l_condition := 'IN';
   END IF;
   RETURN l_condition;
END get_condition_from_array_count;
--
-----------------------------------------------------------------------------
--
END nm3mrg_toolkit;
/
