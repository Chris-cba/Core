CREATE OR REPLACE PACKAGE BODY nm3pbi IS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3pbi.pkb-arc   2.3   Jul 04 2013 16:21:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3pbi.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.24
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   PBI package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--  g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.3  $';
  g_package_name    CONSTANT  varchar2(30) := 'nm3pbi';
--
------------------------------------------------------------------------------------------------
--
--
-- variables for storing query definition data
--
   g_npq_id            nm_pbi_query.npq_id%TYPE;
   g_nqr_job_id        nm_pbi_query_results.nqr_job_id%TYPE;
   g_ngq_id            nm_gaz_query.ngq_id%TYPE;
   g_result_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;
   g_pl                nm_placement_array;
--
   g_poe_split   CONSTANT boolean := (hig.get_sysopt('PBIPOE') = 'Y');
--
---- Package Local Procedure Definitions -------------------------------------------------------
--
FUNCTION create_ngq_from_npq (pi_npq_id     nm_pbi_query.npq_id%TYPE
                             ,pi_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                             ) RETURN nm_gaz_query.ngq_id%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE store_temp_ne_as_pbi_results;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_placement_array_on_route;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_route_ne_id_from_temp_ne (pi_nte_ne_id_of nm_nw_temp_extents.nte_ne_id_of%TYPE
                                      ) RETURN nm_nw_temp_extents.nte_route_ne_id%TYPE;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE store_placement_array;
--
-----Global Procedures -------------------------------------------------------------------------
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
PROCEDURE execute_pbi_query
             (pi_query_id      IN     nm_pbi_query.npq_id%TYPE
             ,pi_nte_job_id    IN     nm_members.nm_ne_id_in%TYPE
             ,pi_description   IN     nm_pbi_query_results.nqr_description%TYPE
             ,po_result_job_id    OUT nm_pbi_query_results.nqr_job_id%TYPE
             ) IS
--
   l_rec_nqr                  nm_pbi_query_results%ROWTYPE;
--
BEGIN
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--
   nm_debug.proc_start(g_package_name,'execute_pbi_query');
--
   IF pi_nte_job_id IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 110
                    ,pi_supplementary_info => 'pi_nte_job_id cannot be null'
                    );
   END IF;
--
   validate_pbi_query (pi_query_id   => pi_query_id
                      ,pi_nte_job_id => pi_nte_job_id
                      );
--
-- Get the JOB_ID
--
   po_result_job_id := get_job_id;
   g_nqr_job_id     := po_result_job_id;
--
   g_result_nte_job_id := nm3gaz_qry.perform_query
                               (pi_ngq_id         => g_ngq_id
                               ,pi_effective_date => To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                               );
--
-- Store the NM_PBI_QUERY_RESULTS record
--
   l_rec_nqr.nqr_npq_id      := pi_query_id;
   l_rec_nqr.nqr_job_id      := po_result_job_id;
   l_rec_nqr.nqr_source_id   := nm3extent.g_last_temp_extent_source_id;
   l_rec_nqr.nqr_source      := nm3extent.g_last_temp_extent_source;
   l_rec_nqr.nqr_description := pi_description;
   nm3ins.ins_npqr (l_rec_nqr);
--
   store_temp_ne_as_pbi_results;
--
   nm_debug.proc_end(g_package_name,'execute_pbi_query');
--
END execute_pbi_query;
--
------------------------------------------------------------------------------------------------
--
FUNCTION fn_convert_attrib_value (pi_value  IN varchar2
                                 ,pi_format IN varchar2
                                 ) RETURN varchar2 IS
--
   l_retval                       varchar2(32767);
   c_date_format         CONSTANT varchar2(30) := 'DD-MON-YYYY HH24:MI:SS';
   c_date_format_no_time CONSTANT varchar2(30) := 'DD-MON-YYYY';
   l_date_format                  varchar2(30);
--
BEGIN
--
   IF    pi_format = nm3type.c_number
    THEN
      IF NOT nm3flx.is_numeric (pi_value)
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 111
                       ,pi_supplementary_info => pi_value
                       );
      END IF;
      l_retval := pi_value;
   ELSIF pi_format = nm3type.c_date
    THEN
      DECLARE
         l_date date;
      BEGIN
         l_date := hig.date_convert(pi_value);
         IF l_date IS NULL
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 148
                          ,pi_supplementary_info => pi_value
                          );
         END IF;
--
         l_date_format := nm3flx.i_t_e (l_date = TRUNC(l_date)
                                       ,c_date_format_no_time
                                       ,c_date_format
                                       );
--
         l_retval := 'TO_DATE('||nm3flx.string(TO_CHAR(l_date,l_date_format))
                          ||','||nm3flx.string(l_date_format)
                          ||')';
--
      END;
   ELSE
      l_retval := nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(pi_value));
   END IF;
--
   RETURN l_retval;
--
END fn_convert_attrib_value;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_job_id RETURN number IS
BEGIN
--
   RETURN nm3seq.next_rtg_job_id_seq;
--
END get_job_id;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_nqt_seq_no RETURN number IS
BEGIN
--
   RETURN nm3seq.next_nqt_seq_no_seq;
--
END get_nqt_seq_no;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_npq_id RETURN number IS
BEGIN
--
   RETURN nm3seq.next_nmq_id_seq;
--
END get_npq_id;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE save_gaz_query_as_pbi (pi_ngq_id     IN     nm_gaz_query.ngq_id%TYPE
                                ,pi_npq_unique IN     nm_pbi_query.npq_unique%TYPE
                                ,pi_npq_descr  IN     nm_pbi_query.npq_descr%TYPE
                                ,po_npq_id        OUT nm_pbi_query.npq_id%TYPE
                                ) IS
--
   l_rec_npq nm_pbi_query%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'save_gaz_query_as_pbi');
--
   po_npq_id            := nm3seq.next_npq_id_seq;
   l_rec_npq.npq_id     := po_npq_id;
   l_rec_npq.npq_unique := pi_npq_unique;
   l_rec_npq.npq_descr  := pi_npq_descr;
   nm3ins.ins_npq (l_rec_npq);
--
   INSERT INTO nm_pbi_query_types
         (nqt_npq_id
         ,nqt_seq_no
         ,nqt_item_type_type
         ,nqt_item_type
         )
   SELECT po_npq_id
         ,ngqt_seq_no
         ,ngqt_item_type_type
         ,ngqt_item_type
    FROM  nm_gaz_query_types
   WHERE  ngqt_ngq_id = pi_ngq_id;
--
   INSERT INTO nm_pbi_query_attribs
         (nqa_npq_id
         ,nqa_nqt_seq_no
         ,nqa_seq_no
         ,nqa_attrib_name
         ,nqa_operator
         ,nqa_pre_bracket
         ,nqa_post_bracket
         ,nqa_condition
         )
   SELECT po_npq_id
         ,ngqa_ngqt_seq_no
         ,ngqa_seq_no
         ,ngqa_attrib_name
         ,ngqa_operator
         ,ngqa_pre_bracket
         ,ngqa_post_bracket
         ,ngqa_condition
    FROM  nm_gaz_query_attribs
   WHERE  ngqa_ngq_id = pi_ngq_id;
--
   INSERT INTO nm_pbi_query_values
         (nqv_npq_id
         ,nqv_nqt_seq_no
         ,nqv_nqa_seq_no
         ,nqv_sequence
         ,nqv_value
         )
   SELECT po_npq_id
         ,ngqv_ngqt_seq_no
         ,ngqv_ngqa_seq_no
         ,ngqv_sequence
         ,ngqv_value
    FROM  nm_gaz_query_values
   WHERE  ngqv_ngq_id = pi_ngq_id;
--
   nm_debug.proc_end(g_package_name,'save_gaz_query_as_pbi');
--
END save_gaz_query_as_pbi;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE save_gaz_query_as_pbi_auton (pi_ngq_id     IN     nm_gaz_query.ngq_id%TYPE
                                      ,pi_npq_unique IN     nm_pbi_query.npq_unique%TYPE
                                      ,pi_npq_descr  IN     nm_pbi_query.npq_descr%TYPE
                                      ,po_npq_id        OUT nm_pbi_query.npq_id%TYPE
                                      ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'save_gaz_query_as_pbi_auton');
--
   nm3gaz_qry.stash_query_definition (pi_ngq_id);
--
   save_stashed_gaz_query_as_pbi (pi_ngq_tab    => nm3gaz_qry.g_ngq_tab
                                 ,pi_ngqt_tab   => nm3gaz_qry.g_ngqt_tab
                                 ,pi_ngqa_tab   => nm3gaz_qry.g_ngqa_tab
                                 ,pi_ngqv_tab   => nm3gaz_qry.g_ngqv_tab
                                 ,pi_npq_unique => pi_npq_unique
                                 ,pi_npq_descr  => pi_npq_descr
                                 ,po_npq_id     => po_npq_id
                                 );
--
   nm_debug.proc_end(g_package_name,'save_gaz_query_as_pbi_auton');
--
END save_gaz_query_as_pbi_auton;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE save_stashed_gaz_query_as_pbi (pi_ngq_tab    IN     nm3gaz_qry.tab_rec_ngq
                                        ,pi_ngqt_tab   IN     nm3gaz_qry.tab_rec_ngqt
                                        ,pi_ngqa_tab   IN     nm3gaz_qry.tab_rec_ngqa
                                        ,pi_ngqv_tab   IN     nm3gaz_qry.tab_rec_ngqv
                                        ,pi_npq_unique IN     nm_pbi_query.npq_unique%TYPE
                                        ,pi_npq_descr  IN     nm_pbi_query.npq_descr%TYPE
                                        ,po_npq_id        OUT nm_pbi_query.npq_id%TYPE
                                        ) IS
   PRAGMA autonomous_transaction;
   l_ngq_id nm_gaz_query.ngq_id%TYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'save_stashed_gaz_query_as_pbi');
--
   nm3gaz_qry.g_ngq_tab  := pi_ngq_tab;
   nm3gaz_qry.g_ngqt_tab := pi_ngqt_tab;
   nm3gaz_qry.g_ngqa_tab := pi_ngqa_tab;
   nm3gaz_qry.g_ngqv_tab := pi_ngqv_tab;
--
   IF pi_ngq_tab.COUNT > 1
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 322
                    );
   END IF;
--
   -- Give the gaz query a different ngq_id to the one it was stashed from
   --  this gets around a deadlock problem
   l_ngq_id                                := nm3seq.next_ngq_id_seq;
   nm3gaz_qry.g_ngq_tab(1).ngq_id          := l_ngq_id;
   FOR i IN 1..nm3gaz_qry.g_ngqt_tab.COUNT
    LOOP
      nm3gaz_qry.g_ngqt_tab(i).ngqt_ngq_id := l_ngq_id;
   END LOOP;
   FOR i IN 1..nm3gaz_qry.g_ngqa_tab.COUNT
    LOOP
      nm3gaz_qry.g_ngqa_tab(i).ngqa_ngq_id := l_ngq_id;
   END LOOP;
   FOR i IN 1..nm3gaz_qry.g_ngqv_tab.COUNT
    LOOP
      nm3gaz_qry.g_ngqv_tab(i).ngqv_ngq_id := l_ngq_id;
   END LOOP;
--
   nm3gaz_qry.restore_query_definition;
--
   FOR i IN 1..pi_ngq_tab.COUNT
    LOOP
      save_gaz_query_as_pbi (pi_ngq_id     => l_ngq_id
                            ,pi_npq_unique => pi_npq_unique
                            ,pi_npq_descr  => pi_npq_descr
                            ,po_npq_id     => po_npq_id
                            );
   END LOOP;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'save_stashed_gaz_query_as_pbi');
--
END save_stashed_gaz_query_as_pbi;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE move_pbi_to_gaz_qry (pi_npq_id IN   nm_pbi_query.npq_id%TYPE
                              ,pi_ngq_id IN   nm_gaz_query.ngq_id%TYPE
                              ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'move_pbi_to_gaz_qry');
--
   INSERT INTO nm_gaz_query_types
         (ngqt_ngq_id
         ,ngqt_seq_no
         ,ngqt_item_type_type
         ,ngqt_item_type
         )
   SELECT pi_ngq_id
         ,nqt_seq_no
         ,nqt_item_type_type
         ,nqt_item_type
    FROM  nm_pbi_query_types
   WHERE  nqt_npq_id = pi_npq_id;
--
   INSERT INTO nm_gaz_query_attribs
         (ngqa_ngq_id
         ,ngqa_ngqt_seq_no
         ,ngqa_seq_no
         ,ngqa_attrib_name
         ,ngqa_operator
         ,ngqa_pre_bracket
         ,ngqa_post_bracket
         ,ngqa_condition
         )
   SELECT pi_ngq_id
         ,nqa_nqt_seq_no
         ,nqa_seq_no
         ,nqa_attrib_name
         ,nqa_operator
         ,nqa_pre_bracket
         ,nqa_post_bracket
         ,nqa_condition
    FROM  nm_pbi_query_attribs
   WHERE  nqa_npq_id = pi_npq_id;
--
   INSERT INTO nm_gaz_query_values
         (ngqv_ngq_id
         ,ngqv_ngqt_seq_no
         ,ngqv_ngqa_seq_no
         ,ngqv_sequence
         ,ngqv_value
         )
   SELECT pi_ngq_id
         ,nqv_nqt_seq_no
         ,nqv_nqa_seq_no
         ,nqv_sequence
         ,nqv_value
    FROM  nm_pbi_query_values
   WHERE  nqv_npq_id = pi_npq_id;
--
   -- Validate the gaz query because some of the stuff which is stored in
   --  the pbi query may not be valid for this gaz query
   nm3gaz_qry.validate_query (pi_ngq_id => pi_ngq_id);
--
   nm_debug.proc_end(g_package_name,'move_pbi_to_gaz_qry');
--
END move_pbi_to_gaz_qry;
--
------------------------------------------------------------------------------------------------
--
FUNCTION create_ngq_from_npq (pi_npq_id     nm_pbi_query.npq_id%TYPE
                             ,pi_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                             ) RETURN nm_gaz_query.ngq_id%TYPE IS
--
   l_rec_ngq  nm_gaz_query%ROWTYPE;
--
BEGIN
--
   l_rec_ngq.ngq_id                   := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_source_id            := pi_nte_job_id;
   l_rec_ngq.ngq_source               := nm3extent.c_temp_ne;
   l_rec_ngq.ngq_open_or_closed       := nm3gaz_qry.c_closed_query;
   
   IF NVL(pi_nte_job_id, -1) = -1
   THEN
     l_rec_ngq.ngq_query_all_items    := 'Y';
     l_rec_ngq.ngq_items_or_area      := nm3gaz_qry.c_items_query;
   ELSE
     l_rec_ngq.ngq_query_all_items    := 'N';
     l_rec_ngq.ngq_items_or_area      := nm3gaz_qry.c_area_query;
   END IF;
   
   l_rec_ngq.ngq_begin_mp             := NULL;
   l_rec_ngq.ngq_end_mp               := NULL;
   
   nm3ins.ins_ngq (l_rec_ngq);
--
   move_pbi_to_gaz_qry (pi_npq_id => pi_npq_id
                       ,pi_ngq_id => l_rec_ngq.ngq_id
                       );
--
   RETURN l_rec_ngq.ngq_id;
--
END create_ngq_from_npq;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE validate_pbi_query (pi_query_id    IN     nm_pbi_query.npq_id%TYPE
                             ,pi_nte_job_id  IN     nm_members.nm_ne_id_in%TYPE DEFAULT NULL
                             ) IS
--
   l_rec_npq nm_pbi_query%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_pbi_query');
--
   -- switch everything in gaz query to "allow"
   nm3gaz_qry.allow_ele_item_type_type;
   nm3gaz_qry.allow_inv_item_type_type;
   nm3gaz_qry.allow_ft_inv_types;
--
   l_rec_npq := nm3get.get_npq (pi_npq_id => pi_query_id);
--
   g_npq_id  := pi_query_id;
   g_ngq_id  := create_ngq_from_npq (pi_npq_id     => pi_query_id
                                    ,pi_nte_job_id => NVL(pi_nte_job_id,-1)
                                    );
   g_pl      := nm3pla.initialise_placement_array;
   nm3gaz_qry.validate_query (pi_ngq_id =>  g_ngq_id);
--
   nm_debug.proc_end(g_package_name,'validate_pbi_query');
--
END validate_pbi_query;
--
------------------------------------------------------------------------------------------------
--
FUNCTION select_npr (pi_job_id IN nm_pbi_query_results.nqr_job_id%TYPE)
                     RETURN nm_pbi_query_results%ROWTYPE IS
--
   CURSOR cs_nqr (p_job_id nm_pbi_query_results.nqr_job_id%TYPE) IS
   SELECT *
    FROM  nm_pbi_query_results
   WHERE  nqr_job_id = p_job_id;
--
   l_rec_nqr nm_pbi_query_results%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nqr (pi_job_id);
   FETCH cs_nqr INTO l_rec_nqr;
--
   IF cs_nqr%NOTFOUND
    THEN
      CLOSE cs_nqr;
      RAISE_APPLICATION_ERROR(-20001,'NM_PBI_QUERY_RESULTS RECORD NOT FOUND - '||pi_job_id);
   END IF;
--
   CLOSE cs_nqr;
--
   RETURN l_rec_nqr;
--
END select_npr;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_npq (pi_query_id number) RETURN nm_pbi_query%ROWTYPE IS
BEGIN
--
   RETURN nm3get.get_npq (pi_npq_id => pi_query_id);
--
END get_npq;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE split_placement_array_on_route IS
--
   l_prior_route_ne_id nm_nw_temp_extents.nte_route_ne_id%TYPE;
   l_route_ne_id       nm_nw_temp_extents.nte_route_ne_id%TYPE;
--
   l_last_ne_id        nm_elements.ne_id%TYPE := -1;
--
   l_pl nm_placement;
--
   l_change         nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'split_placement_array_on_route');
--
   l_prior_route_ne_id := get_route_ne_id_from_temp_ne(g_pl.npa_placement_array(1).pl_ne_id);
--
-- Identify points at which to throw a change of route
--
   FOR l_count IN 2..g_pl.npa_placement_array.COUNT
    LOOP
--
      l_pl := g_pl.npa_placement_array(l_count);
--
      IF l_last_ne_id <> l_pl.pl_ne_id
       THEN
         -- Only bother looking up the route, if this is for a different NE_ID
         --  99% of the time it will be, but every little helps!
         l_route_ne_id := get_route_ne_id_from_temp_ne(l_pl.pl_ne_id);
      END IF;
--
      IF l_pl.pl_measure <> 0
       THEN
         IF   l_prior_route_ne_id <> l_route_ne_id
          -- If this is a different route and it's NOT already splitting here
          THEN
            l_change(l_change.COUNT+1) := l_count;
         ELSIF g_poe_split
          AND  nm3net.is_node_poe (l_route_ne_id, l_last_ne_id, l_pl.pl_ne_id)
          THEN
            -- If we are splitting the results on POE and there is one then split it
            l_change(l_change.COUNT+1) := l_count;
         END IF;
      END IF;
--
      l_last_ne_id        := l_pl.pl_ne_id;
      l_prior_route_ne_id := l_route_ne_id;
--
   END LOOP;
--
-- Throw changes of route
--
   FOR l_count IN 1..l_change.COUNT
    LOOP
      l_pl := g_pl.npa_placement_array(l_change(l_count));
      g_pl := nm3pla.split_placement_array
                    (this_npa => g_pl
                    ,pi_ne_id => l_pl.pl_ne_id
                    ,pi_mp    => l_pl.pl_start
                    );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'split_placement_array_on_route');
--
END split_placement_array_on_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE store_temp_ne_as_pbi_results IS
BEGIN
--
   g_pl := nm3pla.get_placement_from_temp_ne (g_result_nte_job_id);
--
   IF g_pl.placement_count > 0
    THEN
      g_pl := nm3pla.defrag_placement_array (g_pl);
      split_placement_array_on_route;
      store_placement_array;
   END IF;
--
END store_temp_ne_as_pbi_results;
--
------------------------------------------------------------------------------------------------
--
FUNCTION get_route_ne_id_from_temp_ne (pi_nte_ne_id_of nm_nw_temp_extents.nte_ne_id_of%TYPE
                                      ) RETURN nm_nw_temp_extents.nte_route_ne_id%TYPE IS
--
   CURSOR cs_nte (c_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE
                 ,c_nte_ne_id_of nm_nw_temp_extents.nte_ne_id_of%TYPE
                 ) IS
   SELECT nte_route_ne_id
    FROM  nm_nw_temp_extents
   WHERE  nte_job_id   = c_nte_job_id
    AND   nte_ne_id_of = c_nte_ne_id_of;
--
   l_retval nm_nw_temp_extents.nte_route_ne_id%TYPE := pi_nte_ne_id_of;
--
BEGIN
--
   OPEN  cs_nte (g_result_nte_job_id, pi_nte_ne_id_of);
   FETCH cs_nte INTO l_retval;
   CLOSE cs_nte;
--
   RETURN l_retval;
--
END get_route_ne_id_from_temp_ne;
--
------------------------------------------------------------------------------------------------
--
PROCEDURE store_placement_array IS
--
   l_tab_ne_id     nm3type.tab_number;
   l_tab_begin_mp  nm3type.tab_number;
   l_tab_end_mp    nm3type.tab_number;
   l_tab_measure   nm3type.tab_number;
   l_tab_pl_id     nm3type.tab_number;
--
   l_current_pl_id number := 0;
--
   l_rec_nps       nm_pbi_sections%ROWTYPE;
--
   l_pl            nm_placement := g_pl.npa_placement_array(1);
   l_prior_pl      nm_placement;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'store_placement_array');
--
   l_rec_nps.nps_npq_id         := g_npq_id;
   l_rec_nps.nps_nqr_job_id     := g_nqr_job_id;
   l_rec_nps.nps_offset_ne_id   := get_route_ne_id_from_temp_ne(l_pl.pl_ne_id);
   l_rec_nps.nps_begin_offset   := nm3lrs.get_set_offset
                                            (l_rec_nps.nps_offset_ne_id
                                            ,l_pl.pl_ne_id
                                            ,l_pl.pl_start
                                            );
   l_rec_nps.nps_ne_id_first    := l_pl.pl_ne_id;
   l_rec_nps.nps_begin_mp_first := l_pl.pl_start;
--
   --get attributes of array elements
   FOR i IN 1..g_pl.npa_placement_array.COUNT
    LOOP
--
      l_pl := g_pl.npa_placement_array(i);
--
      IF l_pl.pl_measure = 0
       THEN
--
         l_current_pl_id := l_current_pl_id + 1;
--
         IF i > 1
          THEN
            l_prior_pl := g_pl.npa_placement_array(i - 1);
            l_rec_nps.nps_end_offset  := nm3lrs.get_set_offset
                                            (l_rec_nps.nps_offset_ne_id
                                            ,l_prior_pl.pl_ne_id
                                            ,l_prior_pl.pl_end
                                            );
            l_rec_nps.nps_ne_id_last  := l_prior_pl.pl_ne_id;
            l_rec_nps.nps_end_mp_last := l_prior_pl.pl_end;
            nm3ins.ins_nps (l_rec_nps);
         END IF;
         l_rec_nps.nps_section_id     := l_current_pl_id;
         l_rec_nps.nps_offset_ne_id   := get_route_ne_id_from_temp_ne(l_pl.pl_ne_id);
         l_rec_nps.nps_begin_offset   := nm3lrs.get_set_offset
                                                  (l_rec_nps.nps_offset_ne_id
                                                  ,l_pl.pl_ne_id
                                                  ,l_pl.pl_start
                                                  );
         l_rec_nps.nps_ne_id_first    := l_pl.pl_ne_id;
         l_rec_nps.nps_begin_mp_first := l_pl.pl_start;
--
      END IF;
--
      IF l_pl.pl_ne_id != 0 THEN
         l_tab_pl_id(i)    := l_current_pl_id;
         l_tab_ne_id(i)    := l_pl.pl_ne_id;
         l_tab_begin_mp(i) := l_pl.pl_start;
         l_tab_end_mp(i)   := l_pl.pl_end;
         l_tab_measure(i)  := l_pl.pl_measure;
      END IF;
--
   END LOOP;
--
   -- Create the last NPS record as we're always working 1 behind
   l_prior_pl := g_pl.npa_placement_array(g_pl.npa_placement_array.COUNT);
   l_rec_nps.nps_end_offset  := nm3lrs.get_set_offset
                                   (l_rec_nps.nps_offset_ne_id
                                   ,l_prior_pl.pl_ne_id
                                   ,l_prior_pl.pl_end
                                   );
   l_rec_nps.nps_ne_id_last  := l_prior_pl.pl_ne_id;
   l_rec_nps.nps_end_mp_last := l_prior_pl.pl_end;
   nm3ins.ins_nps (l_rec_nps);
--
   --insert record for each array element
   FORALL i IN 1..g_pl.npa_placement_array.COUNT
     INSERT INTO nm_pbi_section_members
             (npm_npq_id
             ,npm_nqr_job_id
             ,npm_nps_section_id
             ,npm_ne_id_of
             ,npm_begin_mp
             ,npm_end_mp
             ,npm_measure
             )
      VALUES (g_npq_id
             ,g_nqr_job_id
             ,l_tab_pl_id(i)
             ,l_tab_ne_id(i)
             ,l_tab_begin_mp(i)
             ,l_tab_end_mp(i)
             ,l_tab_measure(i)
             );
--
   nm_debug.proc_end(g_package_name,'store_placement_array');
--
END store_placement_array;
--
------------------------------------------------------------------------------------------------
--
END nm3pbi;
/
