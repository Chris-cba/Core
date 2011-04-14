CREATE OR REPLACE PACKAGE BODY nm3gaz_qry AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3gaz_qry.pkb-arc   2.17   Apr 14 2011 10:16:48   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3gaz_qry.pkb  $
--       Date into PVCS   : $Date:   Apr 14 2011 10:16:48  $
--       Date fetched Out : $Modtime:   Apr 14 2011 10:14:34  $
--       Version          : $Revision:   2.17  $
--       Based on SCCS version : 1.45
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   Gazeteer Query package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   --g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3gaz_qry.pkb 1.45 05/26/06"';
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.17  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3gaz_qry';
--
   c_table_alias     CONSTANT  varchar2(3) := 'qry';
--
   c_ne_sub_class    CONSTANT  varchar2(30) := 'NE_SUB_CLASS';
   c_ne_no_start     CONSTANT  varchar2(30) := 'NE_NO_START';
   c_ne_no_end       CONSTANT  varchar2(30) := 'NE_NO_END';
--
   g_allow_inv_item_type_type  boolean := TRUE;
   g_allow_ele_item_type_type  boolean := TRUE;
   g_allow_ft_inv_types        boolean := TRUE;
   g_allow_xsp                 boolean := TRUE;
--
   g_rec_ngq                   nm_gaz_query%ROWTYPE;
   g_tab_rec_ngqt              tab_rec_ngqt;
   g_tab_rec_ngqa              tab_rec_ngqa;
   g_tab_rec_ngqv              tab_rec_ngqv;
   g_tab_ngqt_area_sql         nm3type.tab_varchar32767;
   g_tab_ngqt_list_sql         nm3type.tab_varchar32767;
   g_tab_nte_job_id            nm3type.tab_number;
   g_tab_is_point_inv          nm3type.tab_boolean;
   g_tab_parse_error_code      nm3type.tab_number;
   g_tab_parse_error_msg       nm3type.tab_varchar32767;
   g_tab_flexible_where        nm3type.tab_varchar32767;
   g_parse_errors_found        boolean;
   g_area_based_query          boolean;
   g_ngqi_job_id               nm_gaz_query_item_list.ngqi_job_id%TYPE;
   g_roi_restricted_item_query boolean;
--
   g_last_run_unique           nm_elements.ne_unique%TYPE;
--
   c_max_bracket_length        pls_integer;
--
   g_point_inv_type_exists        boolean;
   g_non_ft_inv_restriction_exist boolean;
--
   g_rec_selected_item_details    rec_selected_item_details;
   g_selected_ngqi_job_id         nm_gaz_query_item_list.ngqi_job_id%TYPE;
--
   g_stash_ngqi_job_id            nm3type.tab_number;
   g_stash_ngqi_item_type_type    nm3type.tab_varchar4;
   g_stash_ngqi_item_type         nm3type.tab_varchar4;
   g_stash_ngqi_item_id           nm3type.tab_number;
--
   g_qry_inv_type                 nm_inv_types.NIT_INV_TYPE%TYPE;
   g_qry_roi_type                 VARCHAR2(5);
   g_qry_roi_id                   PLS_INTEGER;
--
  PROCEDURE test_debug ( pi_text IN VARCHAR2 )
  IS
  BEGIN
   -- nm_debug.debug_on;
   -- nm_debug.debug(pi_text);
  --  nm_debug.debug_off;
    NULL;
  END test_debug;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_meaning_and_desc_from_val (pi_sql_string  IN     varchar2
                                        ,pi_value       IN     varchar2
                                        ,po_meaning        OUT varchar2
                                        ,po_description    OUT varchar2
                                        );
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_globals (pi_ngq_id             nm_gaz_query.ngq_id%TYPE
                           ,pi_raise_parse_errors boolean DEFAULT TRUE
                           );
--
-----------------------------------------------------------------------------
--
PROCEDURE parse_each_sql (pi_index              pls_integer
                         ,pi_raise_parse_errors boolean DEFAULT TRUE
                         );
--
-----------------------------------------------------------------------------
--
PROCEDURE build_element_restriction_sql (p_ngqt_index pls_integer);
--
-----------------------------------------------------------------------------
--
PROCEDURE build_inv_restriction_sql (p_ngqt_index pls_integer);
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_element_based_deletes;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_inv_temp_ne_creation;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_area (p_index pls_integer
                      ,p_text  varchar2
                      ,p_nl    boolean DEFAULT TRUE
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_list (p_index pls_integer
                      ,p_text  varchar2
                      ,p_nl    boolean DEFAULT TRUE
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_both (p_index pls_integer
                      ,p_text  varchar2
                      ,p_nl    boolean DEFAULT TRUE
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_list_start(p_ngqt_index pls_integer);
--
-----------------------------------------------------------------------------
--
PROCEDURE append_list_end(p_ngqt_index pls_integer);
--
-----------------------------------------------------------------------------
--
PROCEDURE build_flexible_where (p_rec_ngqt nm_gaz_query_types%ROWTYPE
                               ,p_index    pls_integer
                               );
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_sql_area (p_index pls_integer);
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_sql_item (p_index pls_integer);
--
-----------------------------------------------------------------------------
--
PROCEDURE add_for_open_queries;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_rid_of_single_points;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqv_lov_sql_ele (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                              ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                              ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ial_lov_sql (pi_ial_domain nm_inv_attri_lookup.ial_domain%TYPE) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqv_lov_sql_inv (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                              ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                              ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_admin_unit_lov_sql (pi_nat_admin_type nm_au_types.nat_admin_type%TYPE) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sub_class_lov_sql (pi_nt_type nm_types.nt_type%TYPE) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_node_lov_sql (pi_nt_node_type nm_types.nt_node_type%TYPE) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_metamodel_format_ele (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                                       ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                                       ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_metamodel_format_inv (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                                       ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                                       ) RETURN varchar2;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_ngqt_item_type_type (p_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE check_ngqt_item_type (p_ngqt_item_type nm_gaz_query_types.ngqt_item_type%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE create_region_of_interest;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_item_list_retrieval;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_item_type_type_allowed (p_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE);
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
PROCEDURE validate_query (pi_ngq_id         nm_gaz_query.ngq_id%TYPE) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_query');
--
   populate_globals (pi_ngq_id);
--
   nm_debug.proc_end(g_package_name,'validate_query');
--
END validate_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_erroneous_flex_queries
                         (pi_ngq_id                  IN     nm_gaz_query.ngq_id%TYPE
                         ,po_tab_rec_ngqt               OUT tab_rec_ngqt
                         ,po_tab_flx_query              OUT nm3type.tab_varchar32767
                         ,po_tab_flx_qry_error_code     OUT nm3type.tab_number
                         ,po_tab_flx_qry_error_msg      OUT nm3type.tab_varchar32767
                         ,po_parse_errors_found         OUT boolean
                         ) IS
--
   l_tab_for_flex_qry nm3type.tab_varchar32767;
   l_error_count      pls_integer := 0;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_erroneous_flex_queries');
--
   populate_globals (pi_ngq_id,FALSE);
--
   FOR i IN 1..g_tab_parse_error_code.COUNT
    LOOP
      IF g_tab_parse_error_msg(i) IS NOT NULL
       THEN
         l_error_count                            := l_error_count + 1;
         po_tab_rec_ngqt(l_error_count)           := g_tab_rec_ngqt(i);
         po_tab_flx_query(l_error_count)          := g_tab_flexible_where(i);
         po_tab_flx_qry_error_code(l_error_count) := g_tab_parse_error_code(i);
         po_tab_flx_qry_error_msg(l_error_count)  := g_tab_parse_error_msg(i);
      END IF;
   END LOOP;
--
   po_parse_errors_found := g_parse_errors_found;
--
   nm_debug.proc_end(g_package_name,'get_erroneous_flex_queries');
--
END get_erroneous_flex_queries;
--
-----------------------------------------------------------------------------
--
FUNCTION perform_query (pi_ngq_id         nm_gaz_query.ngq_id%TYPE
                       ,pi_effective_date date DEFAULT nm3user.get_effective_date
                       ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
--
   e_query_returns_no_network EXCEPTION;
   l_retval                   number;
   c_init_eff_date   CONSTANT date := nm3user.get_effective_date;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'perform_query');
--
   nm3user.set_effective_date (pi_effective_date);
--
   -- Populate global variables AND validate the query
     validate_query (pi_ngq_id);
--

   IF  g_area_based_query
    OR g_roi_restricted_item_query
    THEN
 
      create_region_of_interest;

   --
      -- If we have point items in here AND it is a "open" query
      --  then add the node points for elements which aren't already in
      --  the temp ne
   
      add_for_open_queries;
   
   END IF;
--
    IF g_area_based_query
    THEN
      -- restrict the subset for any element based deletes -
      --  these are the most efficient, because they are single table only
   
      perform_element_based_deletes;
   
      --
      -- May as well get rid of any DBs FROM the temp NE if we have some inventory
      --  restrictions which are not foreign table based.
      IF g_non_ft_inv_restriction_exist
       THEN
         nm3extent.remove_db_from_temp_ne (pi_job_id => g_nte_job_id);
      END IF;
   --
   
       -- perform all of the inv based deletes
      perform_inv_temp_ne_creation;
   
      --
      IF NOT g_point_inv_type_exists
        AND g_rec_ngq.ngq_open_or_closed = c_closed_query
       THEN
         -- If there are no point inventory restrictions in
         --   existence, then get rid of zero length "chunks" in the temp ne
         get_rid_of_single_points;
      END IF;
   
      --
      -- defrag the resultant temp ne to get the nte_seq_no correct
      nm3extent.defrag_temp_extent(pi_nte_id           => g_nte_job_id
                                  ,pi_force_resequence => TRUE
                                  );
          
   --
      IF g_nte_job_id IS NULL
      THEN
        RAISE e_query_returns_no_network;
      END IF;
      l_retval := g_nte_job_id;
   ELSE
      -- This is an inventory list being returned. g_nte_job_id will
      --  contain the nm_gaz_query_inv_item_list.ngqi_job_id
   
      g_ngqi_job_id := nm3pbi.get_job_id;
   
    --
    -- Task 0110799/0110804/0110805
    -- Validate the query again to pick up the g_ngqi_job_id to stop performance issue looking it up 
    --
      validate_query (pi_ngq_id);
    --
      perform_item_list_retrieval;
   
      l_retval  := g_ngqi_job_id;
   
   END IF;
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end(g_package_name,'perform_query');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN e_query_returns_no_network
   THEN
      nm3user.set_effective_date (c_init_eff_date);
      hig.raise_ner(pi_appl => nm3type.c_net
                   ,pi_id   => 306
                   );
--
--   WHEN others
--    THEN
--      nm3user.set_effective_date (c_init_eff_date);
--   nm_debug.debug(sqlerrm);
--      RAISE;
--
END perform_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_globals (pi_ngq_id             nm_gaz_query.ngq_id%TYPE
                           ,pi_raise_parse_errors boolean DEFAULT TRUE
                           ) IS
--
   CURSOR cs_ngqt (c_ngqt_ngq_id      nm_gaz_query_types.ngqt_ngq_id%TYPE) IS
   SELECT *
    FROM  nm_gaz_query_types
   WHERE  ngqt_ngq_id      = c_ngqt_ngq_id
   ORDER BY ngqt_order_by (ngqt_item_type_type, ngqt_item_type)
           ,ngqt_seq_no;
--
   CURSOR cs_ngqa (c_ngqa_ngq_id      nm_gaz_query_attribs.ngqa_ngq_id%TYPE
                  ,c_ngqa_ngqt_seq_no nm_gaz_query_attribs.ngqa_ngqt_seq_no%TYPE
                  ) IS
   SELECT *
    FROM  nm_gaz_query_attribs
   WHERE  ngqa_ngq_id      = c_ngqa_ngq_id
    AND   ngqa_ngqt_seq_no = c_ngqa_ngqt_seq_no
   ORDER BY ngqa_seq_no;
--
   CURSOR cs_ngqv (c_ngqv_ngq_id      nm_gaz_query_values.ngqv_ngq_id%TYPE
                  ,c_ngqv_ngqt_seq_no nm_gaz_query_values.ngqv_ngqt_seq_no%TYPE
                  ,c_ngqv_ngqa_seq_no nm_gaz_query_values.ngqv_ngqa_seq_no%TYPE
                  ) IS
   SELECT *
    FROM  nm_gaz_query_values
   WHERE  ngqv_ngq_id              = c_ngqv_ngq_id
    AND   ngqv_ngqt_seq_no         = c_ngqv_ngqt_seq_no
    AND   ngqv_ngqa_seq_no         = c_ngqv_ngqa_seq_no
   ORDER BY ngqv_sequence;
--
   l_element_restriction_index pls_integer;
   l_values_count              pls_integer;
--
BEGIN
--
   g_tab_rec_ngqt.DELETE;
   g_tab_rec_ngqa.DELETE;
   g_tab_rec_ngqv.DELETE;
   g_tab_ngqt_area_sql.DELETE;
   g_tab_ngqt_list_sql.DELETE;
   g_tab_is_point_inv.DELETE;
   g_tab_parse_error_code.DELETE;
   g_tab_parse_error_msg.DELETE;
   g_tab_flexible_where.DELETE;
--
   g_point_inv_type_exists        := FALSE;
   g_non_ft_inv_restriction_exist := FALSE;
   g_parse_errors_found           := FALSE;
   g_area_based_query             := FALSE;
   g_roi_restricted_item_query    := FALSE;
--
   c_max_bracket_length     := GREATEST (nm3get.get_hdo (pi_hdo_domain => c_ngqa_pre_bracket_domain).hdo_code_length
                                        ,nm3get.get_hdo (pi_hdo_domain => c_ngqa_post_bracket_domain).hdo_code_length
                                        );
--
   g_rec_ngq                   := nm3get.get_ngq (pi_ngq_id => pi_ngq_id);
   IF g_rec_ngq.ngq_items_or_area = 'A'
    THEN
      g_area_based_query          := TRUE;
      g_roi_restricted_item_query := FALSE;
   ELSE
      g_area_based_query          := FALSE;
      g_roi_restricted_item_query := g_rec_ngq.ngq_query_all_items = 'N';
   END IF;
--
   FOR cs_rec_ngqt IN cs_ngqt (g_rec_ngq.ngq_id)
    LOOP
      --
      -- Set this to false initially
      g_tab_is_point_inv(g_tab_is_point_inv.COUNT+1) := FALSE;
      --

--
-- check the item type type (should be I or E)
--
      check_ngqt_item_type_type (cs_rec_ngqt.ngqt_item_type_type);
      --

--
-- check the inv type
--   
      check_ngqt_item_type (cs_rec_ngqt.ngqt_item_type);
   
   
      IF cs_rec_ngqt.ngqt_item_type_type = c_ngqt_item_type_type_ele
       THEN
         IF   l_element_restriction_index IS NOT NULL
          AND g_area_based_query
          THEN
            -- Not sensible to have query restricted by >1 datum type so fail
            hig.raise_ner (pi_appl => nm3type.c_net
                          ,pi_id   => 290
                          );
         END IF;
         l_element_restriction_index := cs_ngqt%rowcount;
      END IF;
      --
      g_tab_rec_ngqt(g_tab_rec_ngqt.COUNT+1)       := cs_rec_ngqt;
      FOR cs_rec_ngqa IN cs_ngqa (g_rec_ngq.ngq_id, cs_rec_ngqt.ngqt_seq_no)
       LOOP
         g_tab_rec_ngqa(g_tab_rec_ngqa.COUNT+1)    := cs_rec_ngqa;
         l_values_count := 0;
         FOR cs_rec_ngqv IN cs_ngqv (g_rec_ngq.ngq_id, cs_rec_ngqt.ngqt_seq_no, cs_rec_ngqa.ngqa_seq_no)
          LOOP
            g_tab_rec_ngqv(g_tab_rec_ngqv.COUNT+1) := cs_rec_ngqv;
            l_values_count := l_values_count + 1;
         END LOOP;
--
         chk_value_count_for_condition (cs_rec_ngqa.ngqa_condition,l_values_count);
--
      END LOOP;
      --
   END LOOP;
--
   FOR i IN 1..g_tab_rec_ngqt.COUNT
    LOOP
      check_item_type_type_allowed (g_tab_rec_ngqt(i).ngqt_item_type_type);

      IF    g_tab_rec_ngqt(i).ngqt_item_type_type = c_ngqt_item_type_type_ele
       THEN
         build_element_restriction_sql (i);
      ELSIF g_tab_rec_ngqt(i).ngqt_item_type_type = c_ngqt_item_type_type_inv
       THEN

         build_inv_restriction_sql (i);

      END IF;
   END LOOP;
--
   FOR i IN 1..g_tab_ngqt_list_sql.COUNT
    LOOP
      IF g_tab_ngqt_list_sql(i) IS NOT NULL
       THEN
         parse_each_sql (pi_index              => i
                        ,pi_raise_parse_errors => pi_raise_parse_errors
                        );
      END IF;
   END LOOP;
--
END populate_globals;
--
-----------------------------------------------------------------------------
--
PROCEDURE parse_each_sql (pi_index              pls_integer
                         ,pi_raise_parse_errors boolean DEFAULT TRUE
                         ) IS
--
   l_error_code pls_integer;
   l_reason     nm3type.max_varchar2;
   l_ora_20000  EXCEPTION;
   PRAGMA EXCEPTION_INIT(l_ora_20000,-20000);
--
BEGIN
--
--   nm_debug.debug(g_tab_ngqt_area_sql(pi_index));
   g_tab_parse_error_code(pi_index) := NULL;
   g_tab_parse_error_msg(pi_index)  := NULL;
   nm3flx.parse_sql_string (g_tab_ngqt_list_sql(pi_index));
--
EXCEPTION
--
   WHEN l_ora_20000
    THEN
      BEGIN
         IF hig.check_last_ner (nm3type.c_hig,83)
          THEN
--            nm_debug.debug(g_tab_ngqt_area_sql(pi_index));
--            nm_debug.debug(nm3flx.g_last_parse_exception_msg);
            l_error_code := nm3flx.parse_error_code (nm3flx.g_last_parse_exception_msg);
            IF    l_error_code = -933
             THEN
               l_reason := 'probable missing left parenthesis';
            ELSIF l_error_code = -907
             THEN
               l_reason := nm3flx.parse_error_message (nm3flx.g_last_parse_exception_msg);
            ELSE
              RAISE;
            END IF;
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 293
                          ,pi_supplementary_info =>     '"'||g_tab_rec_ngqt(pi_index).ngqt_item_type_type
                                                    ||'":"'||g_tab_rec_ngqt(pi_index).ngqt_item_type
                                                    ||'" - '||l_reason
                                                    ||'('||nm3type.c_ora||l_error_code||')'
                          );
         ELSE
            RAISE;
         END IF;
      EXCEPTION
         WHEN others
          THEN
            g_parse_errors_found := TRUE;
            IF pi_raise_parse_errors
             THEN
               RAISE;
            ELSE
               g_tab_parse_error_code(pi_index)   := SQLCODE;
               IF SQLCODE = -20000
                THEN
                  g_tab_parse_error_msg(pi_index) := nm3flx.parse_error_message(SQLERRM);
               ELSE
                  g_tab_parse_error_msg(pi_index) := SQLERRM;
               END IF;
            END IF;
      END;
END parse_each_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_element_restriction_sql (p_ngqt_index pls_integer) IS
   l_rec_ngqt nm_gaz_query_types%ROWTYPE;
   c_all    CONSTANT VARCHAR2(4)   := nm3flx.i_t_e (NOT g_use_date_based_views
                                                   ,'_all' -- force the balance of truth against this if the boolean is NULL
                                                   ,Null
                                                   );
   c_ne     CONSTANT VARCHAR2(61)  := 'nm_elements'||c_all||' '||c_table_alias;
BEGIN
--
   l_rec_ngqt := g_tab_rec_ngqt(p_ngqt_index);
--
   g_tab_nte_job_id(p_ngqt_index) := NULL;
   --
   append_area (p_ngqt_index,'DELETE /*+ RULE */ nm_nw_temp_extents nte',FALSE);
   append_area (p_ngqt_index,'WHERE nte.nte_job_id = '||g_package_name||'.get_g_nte_job_id');
   append_area (p_ngqt_index,' AND NOT EXISTS (SELECT 1');
   append_area (p_ngqt_index,'                  FROM  '||c_ne,FALSE);
   append_area (p_ngqt_index,'                 WHERE  '||c_table_alias||'.ne_id = nte.nte_ne_id_of');
   --
   append_list_start(p_ngqt_index);
   append_list (p_ngqt_index,'             ,'||nm3flx.string(l_rec_ngqt.ngqt_item_type_type)||' ngqi_item_type_type');
   append_list (p_ngqt_index,'             ,'||c_table_alias||'.ne_nt_type ngqi_item_type');
   append_list (p_ngqt_index,'             ,'||c_table_alias||'.ne_id ngqi_item_id');
   append_list (p_ngqt_index,'        FROM '||c_ne);
   IF  g_roi_restricted_item_query
    OR g_area_based_query
    THEN
      append_list (p_ngqt_index,'             ,nm_nw_temp_extents nte');
      append_list (p_ngqt_index,'       WHERE  nte.nte_job_id   = '||g_package_name||'.get_g_nte_job_id');
      append_list (p_ngqt_index,'        AND   nte.nte_ne_id_of = '||c_table_alias||'.ne_id');
      append_list (p_ngqt_index,'        AND   ');
   ELSE
      append_list (p_ngqt_index,'       WHERE  ');
   END IF;
   append_list (p_ngqt_index,c_table_alias||'.ne_nt_type = '||nm3flx.string(l_rec_ngqt.ngqt_item_type),FALSE);
   --
   build_flexible_where (g_tab_rec_ngqt(p_ngqt_index), p_ngqt_index);
   --
   append_area (p_ngqt_index,'                )');
   append_list_end(p_ngqt_index);
--
END build_element_restriction_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_inv_restriction_sql (p_ngqt_index pls_integer) IS
--
   l_rec_ngq  nm_gaz_query%ROWTYPE;
   l_rec_ngqt nm_gaz_query_types%ROWTYPE;
   l_rec_nit  nm_inv_types%ROWTYPE;
--
   l_ne_id_col       varchar2(61)  := 'nm.nm_ne_id_of';
   l_item_pk_col     varchar2(61)  := c_table_alias||'.iit_ne_id';
   l_begin_mp_col    varchar2(61)  := 'nm.nm_begin_mp';
   l_end_mp_col      varchar2(61)  := 'nm.nm_end_mp';
   l_cardinality_col varchar2(61)  := 'nm.nm_cardinality';
   c_all    CONSTANT VARCHAR2(4)   := nm3flx.i_t_e (NOT g_use_date_based_views
                                                   ,'_all' -- force the balance of truth against this if the boolean is NULL
                                                   ,Null
                                                   );
   c_iit    CONSTANT VARCHAR2(61)  := 'nm_inv_items'||c_all||' '||c_table_alias;
   l_tables          varchar2(100) := c_iit||', nm_members'||c_all||' nm';
--
BEGIN
--
   g_tab_nte_job_id(p_ngqt_index) := nm3net.get_next_nte_id;
--
   l_rec_ngqt := g_tab_rec_ngqt(p_ngqt_index);
--
   l_rec_ngq  := nm3get.get_ngq(pi_ngq_id => l_rec_ngqt.ngqt_ngq_id);
--
   l_rec_nit  := nm3get.get_nit (pi_nit_inv_type => l_rec_ngqt.ngqt_item_type);
--
   g_tab_is_point_inv (p_ngqt_index) := (l_rec_nit.nit_pnt_or_cont = 'P');
--
   append_area (p_ngqt_index,'INSERT INTO nm_nw_temp_extents',FALSE);
   append_area (p_ngqt_index,'      (nte_job_id');
   append_area (p_ngqt_index,'      ,nte_ne_id_of');
   append_area (p_ngqt_index,'      ,nte_begin_mp');
   append_area (p_ngqt_index,'      ,nte_end_mp');
   append_area (p_ngqt_index,'      ,nte_cardinality');
   append_area (p_ngqt_index,'      ,nte_seq_no');
   append_area (p_ngqt_index,'      ,nte_route_ne_id');
   append_area (p_ngqt_index,'      )');
   append_area (p_ngqt_index,'SELECT ilv.nte_job_id');
   append_area (p_ngqt_index,'      ,ilv.nte_ne_id_of');
   append_area (p_ngqt_index,'      ,ilv.nte_begin_mp');
   append_area (p_ngqt_index,'      ,ilv.nte_end_mp');
   append_area (p_ngqt_index,'      ,ilv.nte_cardinality');
   append_area (p_ngqt_index,'      ,ROWNUM');
   append_area (p_ngqt_index,'      ,ilv.nte_route_ne_id');
   append_area (p_ngqt_index,' FROM (SELECT /*+ RULE */');
   append_area (p_ngqt_index,'              '||g_package_name||'.get_g_new_nte_job_id nte_job_id');
--
   IF l_rec_nit.nit_table_name IS NOT NULL
    THEN
      IF NOT g_allow_ft_inv_types
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 314
                       ,pi_supplementary_info => l_rec_nit.nit_inv_type
                       );
      END IF;
   
   
      l_ne_id_col       := c_table_alias||'.'||l_rec_nit.nit_lr_ne_column_name;
      l_begin_mp_col    := c_table_alias||'.'||l_rec_nit.nit_lr_st_chain;
      l_end_mp_col      := c_table_alias||'.'||l_rec_nit.nit_lr_end_chain;
      l_item_pk_col     := c_table_alias||'.'||l_rec_nit.nit_foreign_pk_column;
      l_cardinality_col := '1';
      l_tables          := l_rec_nit.nit_table_name||' '||c_table_alias;
   END IF;
--
   append_area (p_ngqt_index,'             ,'||l_ne_id_col||' nte_ne_id_of');
   append_area (p_ngqt_index,'             ,'||l_begin_mp_col||' nte_begin_mp');
   append_area (p_ngqt_index,'             ,'||l_end_mp_col||' nte_end_mp');
   append_area (p_ngqt_index,'             ,'||l_cardinality_col||' nte_cardinality');
   append_area (p_ngqt_index,'             ,nte.nte_route_ne_id nte_route_ne_id');
   --
   append_list_start(p_ngqt_index);
   append_list (p_ngqt_index,'             ,'||nm3flx.string(l_rec_ngqt.ngqt_item_type_type)||' ngqi_item_type_type');
   append_list (p_ngqt_index,'             ,'||nm3flx.string(l_rec_ngqt.ngqt_item_type)||' ngqi_item_type');
   append_list (p_ngqt_index,'             ,'||l_item_pk_col||' ngqi_item_id');
   --
   IF  g_area_based_query
    OR g_roi_restricted_item_query
    THEN
      -- Task 0109984
      IF l_rec_nit.nit_lr_ne_column_name IS NULL
      AND l_rec_nit.nit_table_name IS NOT NULL
      THEN
        hig.raise_ner(pi_appl               => nm3type.c_net
                     ,pi_id                 => 465
                     ,pi_supplementary_info => '['||l_rec_nit.nit_descr||']');
        --RAISE_APPLICATION_ERROR(-20101,'Please ensure the LR NE_ID Column is set on the Asset metamodel for '||l_rec_nit.nit_descr); 
      END IF;
   --
      append_both (p_ngqt_index,'        FROM  '||l_tables||', nm_nw_temp_extents nte');
    --
    -- Task 0110799
    -- Hard bind the job_id to stop it being looked up on execution time which causes a performance issue by
    -- forcing the use of the wrong index on some configurations.
    --
    --  append_both (p_ngqt_index,'       WHERE  nte.nte_job_id = '||g_package_name||'.get_g_nte_job_id');
      append_both (p_ngqt_index,'       WHERE  nte.nte_job_id = '||NVL(nm3gaz_qry.get_g_nte_job_id,-1));
   --
      IF l_rec_nit.nit_table_name IS NULL
       THEN
         -- This is standard - i.e. NOT FT inventory
         append_both (p_ngqt_index,'        AND   '||c_table_alias||'.iit_ne_id = nm.nm_ne_id_in');
         append_both (p_ngqt_index,'        AND    nm.nm_type = '||nm3flx.string('I')||' AND nm.nm_obj_type = '||nm3flx.string(l_rec_ngqt.ngqt_item_type));
         append_both (p_ngqt_index,'        AND   '||c_table_alias||'.iit_inv_type||Null = '||nm3flx.string(l_rec_ngqt.ngqt_item_type)); -- Suppress index
      END IF;
   --
      append_both (p_ngqt_index,'        AND   '||l_ne_id_col||' = nte.nte_ne_id_of||null /*gj*/');

      IF l_rec_nit.nit_table_name IS NULL
      OR (l_rec_nit.nit_table_name           IS NOT NULL
         AND l_rec_nit.nit_lr_ne_column_name IS NOT NULL
         AND l_rec_nit.nit_lr_st_chain       IS NOT NULL )
      THEN
        IF g_tab_is_point_inv(p_ngqt_index)
        THEN
           append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' BETWEEN nte.nte_begin_mp AND nte.nte_end_mp');
        ELSE
--           append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' <= nte.nte_end_mp');
--           append_both (p_ngqt_index,'        AND   '||l_end_mp_col||' >= nte.nte_begin_mp');
        -- Task 0110467
        -- Don't include line items which just butt upto the end / start
           append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' < nte.nte_end_mp');
           append_both (p_ngqt_index,'        AND   '||l_end_mp_col||' > nte.nte_begin_mp');
        END IF;
      END IF;
      
      build_flexible_where (l_rec_ngqt, p_ngqt_index);
      
    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                                    ABERLOUR START
     >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    */
      /***********************************************************************
        Code for filtering any intermiate network locations from the Source ID
        downwards, stopping before it hits the datum locations (already dealt
        with in the temp_extend above
      ***********************************************************************/
      IF l_rec_ngq.ngq_source = nm3extent.c_route
      THEN
        append_list (p_ngqt_index,'     UNION ');
        append_list (p_ngqt_index,'       SELECT '||g_package_name||'.get_g_ngqi_job_id ngqi_job_id');
        append_list (p_ngqt_index,'             ,'||nm3flx.string(l_rec_ngqt.ngqt_item_type_type)||' ngqi_item_type_type');
        append_list (p_ngqt_index,'             ,'||nm3flx.string(l_rec_ngqt.ngqt_item_type)||' ngqi_item_type');
        append_list (p_ngqt_index,'             ,'||l_item_pk_col||' ngqi_item_id');
        append_both (p_ngqt_index,'        FROM  '||l_tables||', (WITH net_members AS ');
        append_both (p_ngqt_index,'       (');
        append_both (p_ngqt_index,'                  SELECT -1 ');
        append_both (p_ngqt_index,'                       , '||l_rec_ngq.ngq_source_id||'                       nte_ne_id_of ');
        append_both (p_ngqt_index,'                       , 0                                nte_begin_mp ');
        append_both (p_ngqt_index,'                       , nm3net.get_ne_length('||l_rec_ngq.ngq_source_id||') nte_end_mp ');
        append_both (p_ngqt_index,'                       , 1                                nte_seq_no ');
        append_both (p_ngqt_index,'                    FROM DUAL ');
        append_both (p_ngqt_index,'                 UNION ');
        append_both (p_ngqt_index,'                  SELECT level ');
        append_both (p_ngqt_index,'                       , nm_ne_id_of                       nte_ne_id_of ');
  --      append_both (p_ngqt_index,'                       , NVL(nm_slk,    nm_begin_mp)      nte_begin_mp ');
  --      append_both (p_ngqt_index,'                       , NVL(nm_end_slk,nm_end_mp)        nte_end_mp');
        --append_both (p_ngqt_index,'                       , 0                                 nte_begin_mp ');
--        append_both (p_ngqt_index,'                       , nm3net.get_ne_length(nm_ne_id_of) nte_end_mp');
        append_both (p_ngqt_index,'                       , nvl(nm_begin_mp,0)                nte_begin_mp ');
        append_both (p_ngqt_index,'                       , nvl(nm_end_mp, nm3net.get_ne_length(nm_ne_id_of)) nte_end_mp ');
        append_both (p_ngqt_index,'                       , nm_seq_no                         nte_seq_no ');
        append_both (p_ngqt_index,'                    FROM nm_members ');
        --
        -- Task 0110484
        --
        IF l_rec_ngq.ngq_begin_mp IS NOT NULL
        AND l_rec_ngq.ngq_end_mp IS NOT NULL
        THEN
--          append_both (p_ngqt_index,'                   WHERE nm_slk <= '||l_rec_ngq.ngq_end_mp);
--          append_both (p_ngqt_index,'                     AND '||l_rec_ngq.ngq_begin_mp||' >= nm_end_slk');
          append_both (p_ngqt_index,'                   WHERE nm_slk < '||l_rec_ngq.ngq_end_mp);
          append_both (p_ngqt_index,'                     AND '||l_rec_ngq.ngq_begin_mp||' > nm_end_slk');
        END IF;
        append_both (p_ngqt_index,'                 CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in ');
        append_both (p_ngqt_index,'                   START WITH nm_ne_id_in = '||l_rec_ngq.ngq_source_id||' ');
        append_both (p_ngqt_index,'               ) ');
        append_both (p_ngqt_index,'               SELECT * FROM net_members) nte ');
        --append_both (p_ngqt_index,'       WHERE  nte.nte_job_id = '||g_package_name||'.get_g_nte_job_id');
        append_both (p_ngqt_index,'       WHERE  1=1');
     --
        IF l_rec_nit.nit_table_name IS NULL
         THEN
           -- This is standard - i.e. NOT FT inventory
           append_both (p_ngqt_index,'        AND   '||c_table_alias||'.iit_ne_id = nm.nm_ne_id_in');
           append_both (p_ngqt_index,'        AND    nm.nm_type = '||nm3flx.string('I')||' AND nm.nm_obj_type = '||nm3flx.string(l_rec_ngqt.ngqt_item_type));
           append_both (p_ngqt_index,'        AND   '||c_table_alias||'.iit_inv_type||Null = '||nm3flx.string(l_rec_ngqt.ngqt_item_type)); -- Suppress index
        END IF;
     --
        append_both (p_ngqt_index,'        AND   '||l_ne_id_col||' = nte.nte_ne_id_of||null');
      --
        -- Task 0109984
        -- Don't attempt to use the chainage columns if they are not set on the metamodel
        --
        --IF l_rec_nit.nit_lr_st_chain IS NOT NULL
        IF l_begin_mp_col IS NOT NULL
        THEN
          IF g_tab_is_point_inv(p_ngqt_index)
          THEN
             append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' BETWEEN nte.nte_begin_mp AND nte.nte_end_mp');
           ELSE
--             append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' <= nte.nte_end_mp');
--             append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
--                                                           THEN l_end_mp_col
--                                                           ELSE l_begin_mp_col
--                                                         END||' >= nte.nte_begin_mp');
        -- Task 0110467
        -- Don't include line items which just butt upto the end / start
             append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' < nte.nte_end_mp');
             append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
                                                           THEN l_end_mp_col
                                                           ELSE l_begin_mp_col
                                                         END||' > nte.nte_begin_mp');
          END IF;
          -- nm_gaz_query
          IF  l_rec_ngq.ngq_begin_mp IS NOT NULL
          AND l_rec_ngq.ngq_end_mp   IS NOT NULL
          THEN
            IF g_tab_is_point_inv(p_ngqt_index)
            THEN
              append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' BETWEEN '||l_rec_ngq.ngq_begin_mp||' and '||l_rec_ngq.ngq_end_mp );
            ELSE
--              append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' <= '||l_rec_ngq.ngq_end_mp);
--              append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
--                                                            THEN l_end_mp_col
--                                                            ELSE l_begin_mp_col
--                                                          END||' >= '||l_rec_ngq.ngq_begin_mp);
            -- Task 0110467
            -- Don't include line items which just butt upto the end / start
              append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' < '||l_rec_ngq.ngq_end_mp);
              append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
                                                            THEN l_end_mp_col
                                                            ELSE l_begin_mp_col
                                                          END||' > '||l_rec_ngq.ngq_begin_mp);
            END IF;
          END IF;
        END IF;
        
        build_flexible_where (l_rec_ngqt, p_ngqt_index);
        
        /***********************************************************************
          Code for filtering on any Group data immediatly above the datum leve
          that shares the same datums. This helps identify assets where the
          ROI has been passed in as a Street (for example) and the assets are
          located on Sections - same datums, but differnt groups
        ***********************************************************************/
       append_list (p_ngqt_index,'     UNION ');
       append_list (p_ngqt_index,'       SELECT '||g_package_name||'.get_g_ngqi_job_id ngqi_job_id');
       append_list (p_ngqt_index,'             ,'||nm3flx.string(l_rec_ngqt.ngqt_item_type_type)||' ngqi_item_type_type');
       append_list (p_ngqt_index,'             ,'||nm3flx.string(l_rec_ngqt.ngqt_item_type)||' ngqi_item_type');
       append_list (p_ngqt_index,'             ,'||l_item_pk_col||' ngqi_item_id');
  --  --
  --     IF  g_area_based_query
  --      OR g_roi_restricted_item_query
  --      THEN
        append_both (p_ngqt_index,'        FROM  '||l_tables||', nm_nw_temp_extents nte , nm_members ex');
        --
        -- Task 0110799
        -- Hard bind the job_id to stop it being looked up on execution time which causes a performance issue by
        -- forcing the use of the wrong index on some configurations.
        --
        --append_both (p_ngqt_index,'       WHERE  nte.nte_job_id = '||g_package_name||'.get_g_nte_job_id');
        append_both (p_ngqt_index,'       WHERE  nte.nte_job_id = '||NVL(nm3gaz_qry.get_g_nte_job_id,-1));
     --
        IF l_rec_nit.nit_table_name IS NULL
         THEN
           -- This is standard - i.e. NOT FT inventory
           append_both (p_ngqt_index,'        AND   '||c_table_alias||'.iit_ne_id = nm.nm_ne_id_in');
           append_both (p_ngqt_index,'        AND    nm.nm_type = '||nm3flx.string('I')||' AND nm.nm_obj_type = '||nm3flx.string(l_rec_ngqt.ngqt_item_type));
           append_both (p_ngqt_index,'        AND   '||c_table_alias||'.iit_inv_type||Null = '||nm3flx.string(l_rec_ngqt.ngqt_item_type)); -- Suppress index
        END IF;
     --
        --append_both (p_ngqt_index,'        AND   '||l_ne_id_col||' = nte.nte_ne_id_of /*gj*/');
          append_both (p_ngqt_index,'        AND   ex.nm_ne_id_of = nte_ne_id_of||null' );
          append_both (p_ngqt_index,'        AND   '||l_ne_id_col ||' = ex.nm_ne_id_in');
          append_both (p_ngqt_index,'        AND   ex.nm_type = ''G''');
  --
      -- Task 0109984
      -- Don't attempt to use the chainage columns if they are not set on the metamodel
      --
        --IF l_rec_nit.nit_lr_st_chain IS NOT NULL
        IF l_begin_mp_col  IS NOT NULL
        THEN
          IF g_tab_is_point_inv(p_ngqt_index)
          THEN
             append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' BETWEEN ex.nm_slk AND ex.nm_end_slk');
           ELSE
--             append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' <= ex.nm_end_slk');
--             append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
--                                                           THEN l_end_mp_col
--                                                           ELSE l_begin_mp_col
--                                                         END||' >= ex.nm_slk');
            -- Task 0110467
            -- Don't include line items which just butt upto the end / start
             append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' < ex.nm_end_slk');
             append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
                                                           THEN l_end_mp_col
                                                           ELSE l_begin_mp_col
                                                         END||' > ex.nm_slk');
          END IF;
      -- nm_gaz_query
          IF  l_rec_ngq.ngq_begin_mp IS NOT NULL
          AND l_rec_ngq.ngq_end_mp   IS NOT NULL
          THEN
            IF g_tab_is_point_inv(p_ngqt_index)
            THEN
              append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' BETWEEN '||l_rec_ngq.ngq_begin_mp||' and '||l_rec_ngq.ngq_end_mp );
            ELSE
--              append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' <= '||l_rec_ngq.ngq_end_mp);
--              append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
--                                                            THEN l_end_mp_col
--                                                            ELSE l_begin_mp_col
--                                                          END||' >= '||l_rec_ngq.ngq_begin_mp);
            -- Task 0110467
            -- Don't include line items which just butt upto the end / start
              append_both (p_ngqt_index,'        AND   '||l_begin_mp_col||' < '||l_rec_ngq.ngq_end_mp);
              append_both (p_ngqt_index,'        AND   '||CASE WHEN l_rec_nit.nit_lr_end_chain IS NOT NULL 
                                                            THEN l_end_mp_col
                                                            ELSE l_begin_mp_col
                                                          END||' > '||l_rec_ngq.ngq_begin_mp);
            END IF;
          END IF;
        END IF;
      --
        build_flexible_where (l_rec_ngqt, p_ngqt_index);
      --
      END IF;
   --
    /*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
                                    ABERLOUR END
    <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    */
    
   ELSE
      IF l_rec_nit.nit_table_name IS NULL
       THEN
         l_tables := c_iit;
      END IF;
      append_list (p_ngqt_index,'        FROM  '||l_tables);
      IF l_rec_nit.nit_table_name IS NULL
       THEN
         append_list (p_ngqt_index,'       WHERE  '||c_table_alias||'.iit_inv_type = '||nm3flx.string(l_rec_ngqt.ngqt_item_type));
      ELSE
         append_list (p_ngqt_index,'       WHERE  1=1');
      END IF;
      build_flexible_where (l_rec_ngqt, p_ngqt_index);
   END IF;
--
--   build_flexible_where (l_rec_ngqt, p_ngqt_index);
--
   append_area (p_ngqt_index,'       ORDER BY nte.nte_seq_no, '||l_begin_mp_col);
--
   append_area (p_ngqt_index,'      ) ilv');
   append_list_end(p_ngqt_index);
--
END build_inv_restriction_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_list_start(p_ngqt_index pls_integer) IS
BEGIN
   append_list (p_ngqt_index,'INSERT INTO nm_gaz_query_item_list',FALSE);
   append_list (p_ngqt_index,'      (ngqi_job_id');
   append_list (p_ngqt_index,'      ,ngqi_item_type_type');
   append_list (p_ngqt_index,'      ,ngqi_item_type');
   append_list (p_ngqt_index,'      ,ngqi_item_id');
   append_list (p_ngqt_index,'      )');
   append_list (p_ngqt_index,'SELECT ilv.ngqi_job_id');
   append_list (p_ngqt_index,'      ,ilv.ngqi_item_type_type');
   append_list (p_ngqt_index,'      ,ilv.ngqi_item_type');
   append_list (p_ngqt_index,'      ,ilv.ngqi_item_id');
   append_list (p_ngqt_index,' FROM (SELECT '||g_package_name||'.get_g_ngqi_job_id ngqi_job_id');
END append_list_start;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_list_end(p_ngqt_index pls_integer) IS
BEGIN
   append_list (p_ngqt_index,'                ) ilv');
   append_list (p_ngqt_index,'WHERE NOT EXISTS (SELECT 1');
   append_list (p_ngqt_index,'                    FROM nm_gaz_query_item_list ex');
   append_list (p_ngqt_index,'                  WHERE  ex.ngqi_job_id         = ilv.ngqi_job_id');
   append_list (p_ngqt_index,'                   AND   ex.ngqi_item_type_type = ilv.ngqi_item_type_type');
   append_list (p_ngqt_index,'                   AND   ex.ngqi_item_type      = ilv.ngqi_item_type');
   append_list (p_ngqt_index,'                   AND   ex.ngqi_item_id        = ilv.ngqi_item_id');
   append_list (p_ngqt_index,'                 )');
   append_list (p_ngqt_index,'GROUP BY ilv.ngqi_job_id');
   append_list (p_ngqt_index,'        ,ilv.ngqi_item_type_type');
   append_list (p_ngqt_index,'        ,ilv.ngqi_item_type');
   append_list (p_ngqt_index,'        ,ilv.ngqi_item_id');
END append_list_end;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_flexible_where (p_rec_ngqt nm_gaz_query_types%ROWTYPE
                               ,p_index    pls_integer
                               ) IS
--
   l_rec_ngqt             nm_gaz_query_types%ROWTYPE;
   l_rec_ngqa             nm_gaz_query_attribs%ROWTYPE;
   l_rec_ngqv             nm_gaz_query_values%ROWTYPE;
--
   l_start                varchar2(10);
--
   l_values_found         boolean;
   l_first_operator       boolean := TRUE;
--
   l_open_bracket_for_in  varchar2(1);
   l_close_bracket_for_in varchar2(1);
   l_seperator            varchar2(5);
   l_initial_bracket      varchar2(1) := '(';
   l_indent               varchar2(5);
--
   l_attrib_datatype      varchar2(10);
   l_upper                varchar2(5) := 'UPPER';  -- For use with iit_note and iit_descr checking
   l_open_for_upper       varchar2(1) := '(';
   l_close_for_upper      varchar2(1) := ')';
--
   PROCEDURE flex_append (p_index pls_integer
                         ,p_text  varchar2
                         ,p_nl    boolean DEFAULT TRUE
                         ) IS
   BEGIN
      IF p_nl
       THEN
         flex_append (p_index, CHR(10), FALSE);
      END IF;
      g_tab_flexible_where(p_index) := g_tab_flexible_where(p_index)||p_text;
   END flex_append;
--
   PROCEDURE append_all  (p_index pls_integer
                         ,p_text  varchar2
                         ,p_nl    boolean DEFAULT TRUE
                         ) IS
   BEGIN
      flex_append (p_index, p_text, p_nl);
      append_both (p_index, p_text, p_nl);
   END append_all;
--
BEGIN
--
   l_rec_ngqt := g_tab_rec_ngqt(p_index);
--
   g_tab_flexible_where(p_index) := NULL;
--
   append_both (p_index,'--');
   append_both (p_index,'-- <FLEXIBLY_DEFINED_QUERY>');
   append_both (p_index,NULL); -- Force a new line onto the 'main' query, to keep the one which may be displayed a bit tidier
   append_all  (p_index,'--',FALSE);
   append_all  (p_index,'-- <ITEM_TYPE_TYPE : "'||l_rec_ngqt.ngqt_item_type_type||'">');
   append_all  (p_index,'-- <ITEM_TYPE      : "'||l_rec_ngqt.ngqt_item_type||'">');
   append_all  (p_index,'--');
--

   FOR i IN 1..g_tab_rec_ngqa.COUNT
    LOOP
      l_rec_ngqa := g_tab_rec_ngqa(i);
      IF   l_rec_ngqa.ngqa_ngq_id      = p_rec_ngqt.ngqt_ngq_id
       AND l_rec_ngqa.ngqa_ngqt_seq_no = p_rec_ngqt.ngqt_seq_no
       THEN
         IF   l_first_operator
          AND l_rec_ngqa.ngqa_operator != nm3type.c_and_operator
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 292
                          ,pi_supplementary_info => l_rec_ngqt.ngqt_item_type_type||':'||l_rec_ngqt.ngqt_item_type
                          );
         END IF;
         --
         l_first_operator := FALSE;
         --
         append_all  (p_index,l_indent||RPAD(l_rec_ngqa.ngqa_operator,3)
                              ||' '||l_initial_bracket||LPAD(NVL(l_rec_ngqa.ngqa_pre_bracket,' '),c_max_bracket_length,' ')
                  );
         
         IF l_rec_ngqa.ngqa_attrib_name IN ('IIT_NOTE','IIT_DESCR')
         THEN
             append_all  (p_index,l_upper||l_open_for_upper);
         ELSE
             append_all  (p_index,null);
         END IF;
        -- CWS 21/10/09 Task 0108242
        l_attrib_datatype := get_attrib_datatype (p_rec_ngqt,l_rec_ngqa.ngqa_attrib_name);
        --
        IF g_ignore_case AND l_attrib_datatype LIKE '%CHAR%' THEN
          append_all  (p_index,'UPPER(' || c_table_alias||'.'||l_rec_ngqa.ngqa_attrib_name || ')',FALSE);
        ELSE 
          append_all  (p_index,c_table_alias||'.'||LOWER(l_rec_ngqa.ngqa_attrib_name),FALSE);
        END IF;
        --
         IF l_rec_ngqa.ngqa_attrib_name IN ('IIT_NOTE','IIT_DESCR')
         THEN
             append_all  (p_index,l_close_for_upper,FALSE);
         END IF;
                  
         append_all  (p_index,' '||l_rec_ngqa.ngqa_condition||' ');
         
         l_initial_bracket      := NULL;
         l_indent               := '    ';
         l_open_bracket_for_in  := NULL;
         l_close_bracket_for_in := NULL;
         l_seperator            := NULL;
         IF l_rec_ngqa.ngqa_condition LIKE '%IN%'
          THEN
            l_open_bracket_for_in  := '(';
            l_close_bracket_for_in := ')';
            l_seperator            := ',';
         ELSIF l_rec_ngqa.ngqa_condition LIKE '%BETWEEN%'
          THEN
            l_seperator            := ' AND ';
         END IF;
         l_start := l_open_bracket_for_in;
         l_values_found := FALSE;
         --l_attrib_datatype := get_attrib_datatype (p_rec_ngqt,l_rec_ngqa.ngqa_attrib_name);
         FOR j IN 1..g_tab_rec_ngqv.COUNT
          LOOP
            l_rec_ngqv := g_tab_rec_ngqv(j);
            IF   l_rec_ngqa.ngqa_ngq_id      = l_rec_ngqv.ngqv_ngq_id
             AND l_rec_ngqa.ngqa_ngqt_seq_no = l_rec_ngqv.ngqv_ngqt_seq_no
             AND l_rec_ngqa.ngqa_seq_no      = l_rec_ngqv.ngqv_ngqa_seq_no
             THEN
               l_values_found := TRUE;
               IF l_rec_ngqa.ngqa_attrib_name IN ('IIT_NOTE','IIT_DESCR')
               THEN
                   append_all  (p_index,l_upper||l_open_for_upper,FALSE);
               END IF;
               -- CWS 21/10/09 Task 0108242
               IF g_ignore_case AND l_attrib_datatype LIKE '%CHAR%' THEN
                 append_all  (p_index,l_start|| 'UPPER('||nm3pbi.fn_convert_attrib_value(l_rec_ngqv.ngqv_value,l_attrib_datatype) || ')',FALSE);
               ELSE
                 append_all  (p_index,l_start||nm3pbi.fn_convert_attrib_value(l_rec_ngqv.ngqv_value,l_attrib_datatype),FALSE);
               END IF;
               --
               IF l_rec_ngqa.ngqa_attrib_name IN ('IIT_NOTE','IIT_DESCR')
               THEN
                   append_all  (p_index,l_close_for_upper,FALSE);
               --ELSE
                  -- append_all  (p_index,'',FALSE);
               END IF;
               l_start := l_seperator;
            END IF;
         END LOOP;
         IF l_values_found
          THEN
            append_all  (p_index,l_close_bracket_for_in,FALSE);
         END IF;
--
--      NM_DEBUG.DEBUG_ON;
      NM_DEBUG.DEBUG(g_tab_flexible_where(p_index));
--      NM_DEBUG.DEBUG_OFF;
      IF l_rec_ngqa.ngqa_attrib_name = 'IIT_PRIMARY_KEY'
         AND  NOT nm3inv.attrib_in_use(pi_inv_type => p_rec_ngqt.ngqt_item_type_type
                                       ,pi_attrib_name => 'IIT_PRIMARY_KEY')THEN
               /* Added Paul, This allows iit_primary_key to be used in the query when it is not
                  a flexible attribute. If it is a flexible attribute then it is ok to validate it */
          NULL;

      ELSE

         append_all  (p_index
                     ,' /* '
                      ||get_ngqa_lov_meaning(pi_ngqt_item_type_type => p_rec_ngqt.ngqt_item_type_type
                                            ,pi_ngqt_item_type      => p_rec_ngqt.ngqt_item_type
                                            ,pi_value               => l_rec_ngqa.ngqa_attrib_name
                                            )
                      ||' */'
                     ,FALSE
                     );
      END IF;
         IF l_rec_ngqa.ngqa_post_bracket IS NOT NULL
          THEN
            append_all  (p_index,'     '||LPAD(l_rec_ngqa.ngqa_post_bracket,c_max_bracket_length,' '));
         END IF;

      END IF;
   END LOOP;
--

   IF l_first_operator -- i.e. there are no attrbutes specified = purely on existence
    THEN
      append_all  (p_index,'/*');
      append_all  (p_index,hig.raise_and_catch_ner(nm3type.c_net,294));
      append_all  (p_index,'*/');
   ELSE
      append_all  (p_index,'    )');
   END IF;
--
   append_both (p_index,'--');
   append_both (p_index,'-- </FLEXIBLY_DEFINED_QUERY>');
   append_both (p_index,'--');
--
END build_flexible_where;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attrib_datatype (p_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                             ,p_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                             ,p_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                             ) RETURN varchar2 IS
--
   l_rec_ngqt nm_gaz_query_types%ROWTYPE;
--
BEGIN
--
   l_rec_ngqt.ngqt_item_type_type := p_ngqt_item_type_type;
   l_rec_ngqt.ngqt_item_type      := p_ngqt_item_type;
   RETURN get_attrib_datatype (l_rec_ngqt, p_ngqa_attrib_name);
--
END get_attrib_datatype;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attrib_datatype (p_rec_ngqt         nm_gaz_query_types%ROWTYPE
                             ,p_ngqa_attrib_name nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                             ) RETURN varchar2 IS
--
   l_table_name varchar2(30);
--
BEGIN
--
   IF p_rec_ngqt.ngqt_item_type_type = c_ngqt_item_type_type_ele
    THEN
      l_table_name  := 'NM_ELEMENTS_ALL';
   ELSIF p_rec_ngqt.ngqt_item_type_type = c_ngqt_item_type_type_inv
    THEN
      l_table_name  := NVL(nm3get.get_nit(pi_nit_inv_type=>p_rec_ngqt.ngqt_item_type).nit_table_name,'NM_INV_ITEMS_ALL');
   END IF;
--
   RETURN NVL(nm3ddl.get_column_details(p_column_name => p_ngqa_attrib_name
                                       ,p_table_name  => l_table_name
                                       ).data_type
             ,nm3type.c_varchar
             );
--
END get_attrib_datatype;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_area (p_index pls_integer
                      ,p_text  varchar2
                      ,p_nl    boolean DEFAULT TRUE
                      ) IS
BEGIN
--
   IF p_nl
    THEN
      append_area (p_index,CHR(10),FALSE);
   END IF;
--
   IF NOT g_tab_ngqt_area_sql.EXISTS(p_index)
    THEN
      g_tab_ngqt_area_sql(p_index) := NULL;
   END IF;
--
   IF LENGTH(g_tab_ngqt_area_sql(p_index)) + LENGTH (p_text) > 32767
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 291
                    ,pi_supplementary_info => g_tab_rec_ngqt(p_index).ngqt_item_type_type||':'||g_tab_rec_ngqt(p_index).ngqt_item_type
                    );
   END IF;
--
   g_tab_ngqt_area_sql(p_index)    := g_tab_ngqt_area_sql(p_index)||p_text;
--
END append_area;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_list (p_index pls_integer
                      ,p_text  varchar2
                      ,p_nl    boolean DEFAULT TRUE
                      ) IS
BEGIN
--
   IF p_nl
    THEN
      append_list(p_index,CHR(10),FALSE);
   END IF;
--
   IF NOT g_tab_ngqt_list_sql.EXISTS(p_index)
    THEN
      g_tab_ngqt_list_sql(p_index) := NULL;
   END IF;
--
   IF LENGTH(g_tab_ngqt_list_sql(p_index)) + LENGTH (p_text) > 32767
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 291
                    ,pi_supplementary_info => g_tab_rec_ngqt(p_index).ngqt_item_type_type||':'||g_tab_rec_ngqt(p_index).ngqt_item_type
                    );
   END IF;
--
   g_tab_ngqt_list_sql(p_index)    := g_tab_ngqt_list_sql(p_index)||p_text;
--
END append_list;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_both (p_index pls_integer
                      ,p_text  varchar2
                      ,p_nl    boolean DEFAULT TRUE
                      ) IS
BEGIN
   append_area (p_index, p_text, p_nl);
   append_list (p_index, p_text, p_nl);
END append_both;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_nte_job_id RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
BEGIN
   RETURN g_nte_job_id;
END get_g_nte_job_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_ngqi_job_id RETURN nm_gaz_query_item_list.ngqi_job_id%TYPE IS
BEGIN
   RETURN g_ngqi_job_id;
END get_g_ngqi_job_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_g_new_nte_job_id RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
BEGIN
   RETURN g_new_nte_job_id;
END get_g_new_nte_job_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_element_based_deletes IS
BEGIN
--
   FOR i IN 1..g_tab_rec_ngqt.COUNT
    LOOP
      IF    g_tab_rec_ngqt(i).ngqt_item_type_type = c_ngqt_item_type_type_ele
       THEN
         execute_sql_area(i);
      END IF;
   END LOOP;
--
END perform_element_based_deletes;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_inv_temp_ne_creation IS
--
   CURSOR cs_nte (c_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE) IS
   SELECT 1
    FROM  nm_nw_temp_extents
   WHERE  nte_job_id = c_nte_job_id;
--
   l_dummy pls_integer;
   l_found boolean;
--
   l_resultant_nte_job_id          nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   FOR i IN 1..g_tab_rec_ngqt.COUNT
    LOOP
    --
      IF    g_tab_rec_ngqt(i).ngqt_item_type_type = c_ngqt_item_type_type_inv
       THEN
    --
         OPEN  cs_nte (g_nte_job_id);
         FETCH cs_nte INTO l_dummy;
         l_found := cs_nte%FOUND;
         CLOSE cs_nte;
    --
         EXIT WHEN NOT l_found; -- Nothing left in the "master" temp ne - exit
    --
         g_new_nte_job_id := g_tab_nte_job_id(i);
    --
    --   Mark this one as the newest in the nm3extent variable
    --    for any FT views which are based on a temp ne
         nm3extent.g_last_nte_job_id := g_nte_job_id;
    --
         execute_sql_area(i);
         IF g_tab_is_point_inv (i)
          THEN
            DELETE nm_nw_temp_extents
            WHERE  nte_job_id = g_nte_job_id;
            g_nte_job_id := g_tab_nte_job_id(i);
            --
            -- Check to see if the NTE is empty
            OPEN  cs_nte (g_nte_job_id);
            FETCH cs_nte INTO l_dummy;
            l_found := cs_nte%FOUND;
            CLOSE cs_nte;
            IF NOT l_found
             THEN
               g_nte_job_id := NULL;
               EXIT;
            END IF;
            --
         ELSE
            nm3extent.defrag_temp_extent(pi_nte_id           => g_tab_nte_job_id(i)
                                        ,pi_force_resequence => FALSE
                                        );
            nm3extent.create_temp_ne_intx_of_temp_ne
                        (pi_nte_job_id_1         => g_nte_job_id
                        ,pi_nte_job_id_2         => g_tab_nte_job_id(i)
                        ,pi_resultant_nte_job_id => l_resultant_nte_job_id
                        );

            DELETE nm_nw_temp_extents
            WHERE  nte_job_id IN (g_nte_job_id,g_tab_nte_job_id(i));
            g_nte_job_id := l_resultant_nte_job_id;
         END IF;
      END IF;
    --
   END LOOP;
--
END perform_inv_temp_ne_creation;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_sql_area (p_index pls_integer) IS
   l_rc pls_integer;
BEGIN
--   nm_debug.debug(g_tab_ngqt_area_sql(p_index));
   EXECUTE IMMEDIATE g_tab_ngqt_area_sql(p_index);
   l_rc := SQL%rowcount;
--   nm_debug.debug('done :'||l_rc);
END execute_sql_area;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_sql_item (p_index pls_integer) IS
   l_rc pls_integer;
BEGIN
   --nm_debug.debug_on;
   nm_debug.debug(g_tab_ngqt_list_sql(p_index));
   EXECUTE IMMEDIATE g_tab_ngqt_list_sql(p_index);
   l_rc := SQL%rowcount;
   --nm_debug.debug('done :'||l_rc);
   --nm_debug.debug_off;
END execute_sql_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_for_open_queries IS
BEGIN
--
   --changed so that open queries with no point inv defined will still bring back
   --extra point locations
   --IF   g_point_inv_type_exists
    IF g_rec_ngq.ngq_open_or_closed = c_open_query
    THEN
      nm3extent.open_nte_for_adjoining_point(p_nte_job_id=>g_nte_job_id);
   END IF;
--
END add_for_open_queries;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_region_of_interest IS
BEGIN
--
   --nm_debug.debug_on;
--
   nm3debug.debug_ngq(g_rec_ngq);
   -- Create a temp ne for the region of interest
   IF   g_rec_ngq.ngq_begin_datum_ne_id  IS NOT NULL
    AND g_rec_ngq.ngq_begin_datum_offset IS NOT NULL
    AND g_rec_ngq.ngq_end_datum_ne_id    IS NOT NULL
    AND g_rec_ngq.ngq_end_datum_offset   IS NOT NULL
    AND g_rec_ngq.ngq_source             =  nm3extent.c_route
    THEN
      --
      -- If this run has been specified FROM the extent limits form then create using
      --  create_temp_ne_FROM_route
      --
      nm_debug.debug('If this run has been specified FROM the extent limits form then create using create_temp_ne_FROM_route');
      nm3wrap.create_temp_ne_from_route(pi_route                   => g_rec_ngq.ngq_source_id
                                       ,pi_start_ne_id             => g_rec_ngq.ngq_begin_datum_ne_id
                                       ,pi_start_offset            => g_rec_ngq.ngq_begin_datum_offset
                                       ,pi_end_ne_id               => g_rec_ngq.ngq_end_datum_ne_id
                                       ,pi_end_offset              => g_rec_ngq.ngq_end_datum_offset
                                       ,pi_sub_class               => g_rec_ngq.ngq_ambig_sub_class
                                       ,pi_restrict_excl_sub_class => 'N'
                                       ,pi_homo_check              => FALSE
                                       ,po_job_id                  => g_nte_job_id
                                       );
   ELSE
      --
      -- Just create it normally
      --
      nm_debug.debug('Just create it normally');
      nm3extent.create_temp_ne (pi_source_id                 => g_rec_ngq.ngq_source_id
                               ,pi_source                    => g_rec_ngq.ngq_source
                               ,pi_begin_mp                  => g_rec_ngq.ngq_begin_mp
                               ,pi_end_mp                    => g_rec_ngq.ngq_end_mp
                               ,po_job_id                    => g_nte_job_id
                               ,pi_default_source_as_parent  => TRUE
                               ,pi_ignore_non_linear_parents => TRUE
                               );
   END IF;
--
   g_last_run_unique := nm3extent.get_unique_from_source
                           (pi_source_id      => nm3extent.g_last_temp_extent_source_id
                           ,pi_source         => nm3extent.g_last_temp_extent_source
                           ,pi_suppress_error => 'Y'
                           );
--
END create_region_of_interest;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_open_query   RETURN nm_gaz_query.ngq_open_or_closed%TYPE IS
BEGIN
   RETURN c_open_query;
END get_c_open_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_closed_query RETURN nm_gaz_query.ngq_open_or_closed%TYPE IS
BEGIN
   RETURN c_closed_query;
END get_c_closed_query;
--
-----------------------------------------------------------------------------
--
FUNCTION ngqt_order_by (pi_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                       ,pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                       ) RETURN pls_integer IS
--
   l_rec_nit nm_inv_types%ROWTYPE;
   l_retval  pls_integer;
--
BEGIN
--
--   Returns the following
--
--  Ret   Description
--  ---   --------------------------------------
--   1    Element restriction
--   2    Point Inv Restriction (non FT)
--   3    Continuous Inv Restriction (non FT)
--   4    Point Inv Restriction (FT)
--   5    Continuous Inv Restriction (FT)
--
   IF    pi_ngqt_item_type_type = c_ngqt_item_type_type_ele
    THEN
      l_retval := 1;
   ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_inv
    THEN
--
      l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_ngqt_item_type);
--
      IF l_rec_nit.nit_table_name IS NOT NULL
       THEN
         g_non_ft_inv_restriction_exist := TRUE;
      END IF;
--
      IF l_rec_nit.nit_pnt_or_cont = 'P'
       THEN
         l_retval := 2;
         g_point_inv_type_exists := TRUE;
      ELSE
         l_retval := 3;
      END IF;
--
      IF l_rec_nit.nit_table_name IS NOT NULL
       THEN
         l_retval := l_retval + 2;
      END IF;
--
   END IF;
--
   RETURN l_retval;
--
END ngqt_order_by;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_rid_of_single_points IS
BEGIN
   DELETE nm_nw_temp_extents
   WHERE  nte_job_id   = g_nte_job_id
    AND   nte_begin_mp = nte_end_mp;
END get_rid_of_single_points;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqv_lov_sql (pi_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                          ,pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                          ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                          ) RETURN varchar2 IS
--
   l_retval nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ngqv_lov_sql');
--
   IF    pi_ngqt_item_type_type = c_ngqt_item_type_type_ele
    THEN
      l_retval := get_ngqv_lov_sql_ele (pi_ngqt_item_type, pi_ngqa_attrib_name);
   ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_inv
    THEN
      l_retval := get_ngqv_lov_sql_inv (pi_ngqt_item_type, pi_ngqa_attrib_name);
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_ngqv_lov_sql');
--
   RETURN l_retval;
--
END get_ngqv_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sub_class_lov_sql (pi_nt_type nm_types.nt_type%TYPE) RETURN varchar2 IS
BEGIN
   RETURN            'SELECT nsc_sub_class lup_meaning, nsc_descr lup_description, nsc_sub_class lup_value'
          ||CHR(10)||' FROM  nm_type_subclass'
          ||CHR(10)||'WHERE  nsc_nw_type = '||nm3flx.string(pi_nt_type)
          ||CHR(10)||'ORDER BY nsc_seq_no';
END get_sub_class_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_admin_unit_lov_sql (pi_nat_admin_type nm_au_types.nat_admin_type%TYPE) RETURN varchar2 IS
BEGIN
   RETURN            'SELECT nau_unit_code lup_meaning, nau_name lup_description, TO_CHAR(nau_admin_unit) lup_value'
          ||CHR(10)||' FROM  nm_admin_units'
          ||CHR(10)||'WHERE  nau_admin_type = '||nm3flx.string(pi_nat_admin_type);
END get_admin_unit_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_node_lov_sql (pi_nt_node_type nm_types.nt_node_type%TYPE) RETURN varchar2 IS
BEGIN
   RETURN            'SELECT no_node_name lup_meaning, no_descr lup_description, TO_CHAR(no_node_id) lup_value'
          ||CHR(10)||' FROM  nm_nodes'
          ||CHR(10)||'WHERE  no_node_type = '||nm3flx.string(pi_nt_node_type);
END get_node_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_users_lov_sql RETURN varchar2 IS
BEGIN
   RETURN            'SELECT hus_username lup_meaning, hus_name lup_description, hus_username lup_value'
          ||CHR(10)||' FROM  hig_users'
          ||CHR(10)||'ORDER BY hus_name';
END get_users_lov_sql;
--
-----------------------------------------------------------------------------
--
-- LOG  721524
-- LOV  columns had different datatype 
-- changed hus_user_id to to_char
FUNCTION get_user_id_lov_sql RETURN varchar2 IS
BEGIN
   --RETURN 'SELECT To_Char(hus_user_id) lup_value,hus_username lup_meaning, hus_name lup_descr'
   --       ||CHR(10)||' FROM  hig_users'
   --       ||CHR(10)||'ORDER BY hus_name';
   RETURN 'SELECT hus_username lup_meaning, hus_name lup_description, hus_user_id lup_value'
          ||CHR(10)||' FROM  hig_users'
          ||CHR(10)||'ORDER BY hus_name';
END get_user_id_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqv_lov_sql_ele (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                              ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                              ) RETURN varchar2 IS
--
   l_rec_nt  nm_types%ROWTYPE;
   l_rec_ntc nm_type_columns%ROWTYPE;
--
   l_retval        nm3type.max_varchar2;
   l_sql           nm3type.max_varchar2;
   l_tab_cols      nm3type.tab_varchar30;
--
BEGIN
--
   l_rec_nt := nm3get.get_nt (pi_nt_type         => pi_ngqt_item_type
                             ,pi_raise_not_found => TRUE
                             );
--
   IF l_rec_nt.nt_type IS NOT NULL
    THEN
      l_rec_ntc := nm3get.get_ntc (pi_ntc_nt_type     => l_rec_nt.nt_type
                                  ,pi_ntc_column_name => pi_ngqa_attrib_name
                                  ,pi_raise_not_found => FALSE
                                  );
      IF l_rec_ntc.ntc_nt_type IS NOT NULL
       THEN

          l_sql :=nm3flx.build_lov_sql_string (p_nt_type                    => l_rec_nt.nt_type
                                              ,p_column_name                => pi_ngqa_attrib_name
                                               );

-- GJ 17-MAY-2005
-- sql string now derived in a different manner
--
--         l_inclusion_sql := nm3flx.build_inclusion_sql_string
--                                     (pi_nt_type       => l_rec_nt.nt_type
--                                     ,pi_column_name   => pi_ngqa_attrib_name
--                                     ,pi_include_ne_id => FALSE
--                                     );
         IF l_sql IS NOT NULL THEN

          l_tab_cols := nm3flx.get_cols_from_sql(l_sql);

            l_retval := 'SELECT '||l_tab_cols(1)||' lup_meaning, '||l_tab_cols(2)||' lup_description,'||l_tab_cols(3)||' lup_value'
             ||CHR(10)||' FROM  ('||l_sql||')';
--         ELSIF l_rec_ntc.ntc_domain IS NOT NULL
--          THEN
--            l_retval := hig.get_hig_domain_lov_sql (l_rec_ntc.ntc_domain);

         ELSIF pi_ngqa_attrib_name = c_ne_sub_class
          THEN
            l_retval := get_sub_class_lov_sql (l_rec_nt.nt_type);
         END IF;
      ELSE
         IF    pi_ngqa_attrib_name = 'NE_TYPE'
          THEN
            l_retval := hig.get_hig_domain_lov_sql (pi_ngqa_attrib_name);
         ELSIF pi_ngqa_attrib_name = 'NE_ADMIN_UNIT'
          THEN
            l_retval := get_admin_unit_lov_sql (l_rec_nt.nt_admin_type);
         ELSIF pi_ngqa_attrib_name IN (c_ne_no_start,c_ne_no_end)
          THEN
            l_retval := get_node_lov_sql (l_rec_nt.nt_node_type);
         ELSIF pi_ngqa_attrib_name IN ('NE_MODIFIED_BY','NE_CREATED_BY')
          THEN
            l_retval := get_users_lov_sql;
         END IF;
      END IF;
   END IF;
--
   RETURN l_retval;
--ý....
END get_ngqv_lov_sql_ele;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ial_lov_sql (pi_ial_domain nm_inv_attri_lookup.ial_domain%TYPE) RETURN varchar2 IS
BEGIN
   RETURN            'SELECT ial_value lup_meaning, ial_meaning lup_description, ial_value lup_value'
          ||CHR(10)||' FROM  nm_inv_attri_lookup'
          ||CHR(10)||'WHERE  ial_domain = '||nm3flx.string(pi_ial_domain)
          ||CHR(10)||'ORDER BY ial_seq';
END get_ial_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqv_lov_sql_inv (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                              ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                              ) RETURN varchar2 IS
--
   l_rec_nit     nm_inv_types%ROWTYPE;
   l_rec_ita     nm_inv_type_attribs%ROWTYPE;
--
   l_retval      nm3type.max_varchar2;
--
BEGIN
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type    => pi_ngqt_item_type
                               ,pi_raise_not_found => TRUE
                               );
--
   IF l_rec_nit.nit_inv_type IS NOT NULL
    THEN
   --
      l_rec_ita := nm3get.get_ita (pi_ita_inv_type    => l_rec_nit.nit_inv_type
                                  ,pi_ita_attrib_name => pi_ngqa_attrib_name
                                  ,pi_raise_not_found => FALSE
                                  );
   --
      IF l_rec_ita.ita_inv_type IS NOT NULL
       THEN
         IF l_rec_ita.ita_id_domain IS NOT NULL
          THEN
            l_retval := get_ial_lov_sql (pi_ial_domain => l_rec_ita.ita_id_domain);
         END IF;
      ELSE
         IF    pi_ngqa_attrib_name = 'IIT_X_SECT'
          THEN
            IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
             THEN
               l_retval :=            'SELECT xsr_x_sect_value lup_meaning, xsr_descr lup_description, xsr_x_sect_value lup_value'
                           ||CHR(10)||' FROM  xsp_restraints'
                           ||CHR(10)||'WHERE  xsr_ity_inv_code = '||nm3flx.string(pi_ngqt_item_type)
                           ||CHR(10)||'GROUP BY xsr_x_sect_value, xsr_x_sect_value, xsr_descr';
            END IF;
         ELSIF pi_ngqa_attrib_name = 'IIT_ADMIN_UNIT'
          THEN
            l_retval := get_admin_unit_lov_sql (l_rec_nit.nit_admin_type);
         ELSIF pi_ngqa_attrib_name IN ('IIT_MODIFIED_BY','IIT_CREATED_BY')
          THEN
            l_retval := get_users_lov_sql;
         ELSIF pi_ngqa_attrib_name IN ('IIT_PEO_INVENT_BY_ID')
          THEN
            l_retval := get_user_id_lov_sql;
         END IF;
      END IF;
   END IF;
--
   RETURN l_retval;
--
END get_ngqv_lov_sql_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_ngqv_value (pi_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                           ,pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                           ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                           ,pi_nqgv_value          nm_gaz_query_values.ngqv_value%TYPE
                           ) IS
--
   l_format nm_inv_type_attribs.ita_format%TYPE;
   l_dummy  nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'check_ngqv_value');
--
   IF    pi_ngqt_item_type_type = c_ngqt_item_type_type_ele
    THEN
      l_format := get_ngqa_metamodel_format_ele (pi_ngqt_item_type   => pi_ngqt_item_type
                                                ,pi_ngqa_attrib_name => pi_ngqa_attrib_name
                                                );
   ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_inv
    THEN
      l_format := get_ngqa_metamodel_format_inv (pi_ngqt_item_type   => pi_ngqt_item_type
                                                ,pi_ngqa_attrib_name => pi_ngqa_attrib_name
                                                );
   END IF;
--
   IF l_format IS NULL
    THEN
      l_format := get_attrib_datatype (p_ngqt_item_type_type => pi_ngqt_item_type_type
                                      ,p_ngqt_item_type      => pi_ngqt_item_type
                                      ,p_ngqa_attrib_name    => pi_ngqa_attrib_name
                                      );
   END IF;
--
   l_dummy := nm3pbi.fn_convert_attrib_value (pi_value  => pi_nqgv_value
                                             ,pi_format => l_format
                                             );
--
   nm_debug.proc_end(g_package_name,'check_ngqv_value');
--
END check_ngqv_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_metamodel_format_ele (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                                       ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                                       ) RETURN varchar2 IS
--
   l_rec_ntc nm_type_columns%ROWTYPE;
--
   l_retval  nm_inv_type_attribs.ita_format%TYPE;
--
BEGIN
--
-- This function returns the format as mANDated by the metamodel
--  as opposed to get_attrib_datatype which returns as mANDated by the DB.
-- Obviously these may differ. This function is used in the validation of
--  data on entry WHEREas the other is used when deciding how to format
--  this data when it is being used in a dynamic query
--
   l_rec_ntc := nm3get.get_ntc (pi_ntc_nt_type     => pi_ngqt_item_type
                               ,pi_ntc_column_name => pi_ngqa_attrib_name
                               ,pi_raise_not_found => FALSE
                               );
--
   IF l_rec_ntc.ntc_nt_type IS NOT NULL
    THEN
      l_retval := l_rec_ntc.ntc_column_type;
   END IF;
--
   RETURN l_retval;
--
END get_ngqa_metamodel_format_ele;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_metamodel_format_inv (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                                       ,pi_ngqa_attrib_name    nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                                       ) RETURN varchar2 IS
--
   l_retval      nm_inv_type_attribs.ita_format%TYPE;
--
   l_rec_ita     nm_inv_type_attribs%ROWTYPE;
--
BEGIN
--
-- This function returns the format as mANDated by the metamodel
--  as opposed to get_attrib_datatype which returns as mANDated by the DB.
-- Obviously these may differ. This function is used in the validation of
--  data on entry WHEREas the other is used when deciding how to format
--  this data when it is being used in a dynamic query
--
   l_rec_ita := nm3get.get_ita (pi_ita_inv_type    => pi_ngqt_item_type
                               ,pi_ita_attrib_name => pi_ngqa_attrib_name
                               ,pi_raise_not_found => FALSE
                               );
--
   IF l_rec_ita.ita_inv_type IS NOT NULL
    THEN
      l_retval := l_rec_ita.ita_format;
   END IF;
--
   RETURN l_retval;
--
END get_ngqa_metamodel_format_inv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_lov_sql_ele (pi_ngqt_item_type      nm_gaz_query_types.ngqt_item_type%TYPE
                              ) RETURN varchar2 IS
--
   l_retval nm3type.max_varchar2;
   l_rec_nt nm_types%ROWTYPE;
--
BEGIN
--
   l_retval :=      'SELECT lup_meaning, lup_meaning lup_description, lup_value'
         ||CHR(10)||' FROM  (SELECT hco_code lup_value, hco_meaning lup_meaning, hco_seq lup_seq'
         ||CHR(10)||'         FROM  hig_codes'
         ||CHR(10)||'        WHERE  hco_domain    = '||nm3flx.string(c_fixed_cols_domain_ele);
   l_rec_nt := nm3get.get_nt(pi_nt_type=>pi_ngqt_item_type);
   IF l_rec_nt.nt_node_type IS NULL
    THEN
      l_retval := l_retval
         ||CHR(10)||'         AND   hco_code NOT IN ('||nm3flx.string(c_ne_no_start)||','||nm3flx.string(c_ne_no_end)||')';
   END IF;
   IF l_rec_nt.nt_datum != 'Y'
    THEN
      l_retval := l_retval
         ||CHR(10)||'         AND   hco_code != '||nm3flx.string('NE_LENGTH');
   END IF;
   l_retval := l_retval
         ||CHR(10)||'        UNION'
         ||CHR(10)||'        SELECT ntc_column_name lup_value, NVL(ntc_prompt,ntc_column_name) lup_meaning, ntc_seq_no lup_seq'
         ||CHR(10)||'         FROM  nm_type_columns'
         ||CHR(10)||'        WHERE  ntc_nt_type   = '||nm3flx.string(pi_ngqt_item_type)
         ||CHR(10)||'         AND   ntc_displayed = '||nm3flx.string('Y')
         ||CHR(10)||'       )'
         ||CHR(10)||'ORDER BY lup_seq';
--
   RETURN l_retval;
--
END get_ngqa_lov_sql_ele;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_lov_sql_inv (pi_ngqt_item_type  nm_gaz_query_types.ngqt_item_type%TYPE
                              ,pi_queryable_attribs_only boolean DEFAULT FALSE
                              ,pi_inc_primary_key      boolean DEFAULT FALSE) RETURN varchar2 IS
--
   l_retval  nm3type.max_varchar2;
   l_rec_nit nm_inv_types%ROWTYPE;
   l_ft_pk_column VARCHAR2(100);
--
CURSOR ft_cur(p_inv_type VARCHAR2) IS
    SELECT NVL(nit_foreign_pk_column, '-1') 
    FROM nm_inv_types 
    WHERE nit_table_name IS NOT NULL
    AND nit_inv_type = p_inv_type;
--
BEGIN
--
   l_retval :=           'SELECT lup_meaning, lup_description, lup_value'
              ||CHR(10)||' FROM  (SELECT ita_attrib_name lup_value, ita_view_col_name lup_meaning, ita_scrn_text lup_description, ita_disp_seq_no lup_seq'
              ||CHR(10)||'         FROM  nm_inv_type_attribs'
              ||CHR(10)||'        WHERE  ita_inv_type = '||nm3flx.string(pi_ngqt_item_type);
   IF pi_queryable_attribs_only THEN
      l_retval := l_retval
              ||CHR(10)||'        AND ita_queryable = '||nm3flx.string('Y');
   END IF;
   IF pi_inc_primary_key THEN
         OPEN ft_cur(p_inv_type => pi_ngqt_item_type);
         FETCH ft_cur INTO l_ft_pk_column; 
         IF ft_cur%notfound THEN 
            IF NOT nm3inv.attrib_in_use(pi_inv_type => pi_ngqt_item_type
                                       ,pi_attrib_name => 'IIT_PRIMARY_KEY') THEN
                l_retval := l_retval
                      ||CHR(10)||'        UNION '
                      ||CHR(10)||'        SELECT ''IIT_PRIMARY_KEY'' lup_meaning, ''ASSET ID'' lup_desription, ''ASSET ID'' lup_value, 1 lup_seq from dual';
            END IF;
        ELSIF l_ft_pk_column <> '-1' AND NOT nm3inv.attrib_in_use(pi_inv_type => pi_ngqt_item_type, pi_attrib_name => l_ft_pk_column) THEN
          l_retval := l_retval
               ||CHR(10)||'        UNION '
               ||CHR(10)||'        SELECT ''' || l_ft_pk_column || ''' lup_meaning, ''ASSET ID'' lup_desription, ''ASSET ID'' lup_value, 1 lup_seq from dual';
         END IF;
         CLOSE ft_cur;
      END IF;
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_ngqt_item_type);
   IF l_rec_nit.nit_table_name IS NULL
    THEN
      l_retval := l_retval
              ||CHR(10)||'        UNION'
              ||CHR(10)||'        SELECT hco_code lup_value, hco_meaning lup_meaning, hco_meaning lup_description, hco_seq lup_seq'
              ||CHR(10)||'         FROM  hig_codes'
              ||CHR(10)||'        WHERE  hco_domain = '||nm3flx.string(c_fixed_cols_domain_inv);
      IF l_rec_nit.nit_x_sect_allow_flag = 'N'
       OR NOT g_allow_xsp
       THEN
         l_retval := l_retval
              ||CHR(10)||'         AND   hco_code != '||nm3flx.string('IIT_X_SECT');
      END IF;
   END IF;
   l_retval := l_retval
              ||CHR(10)||'       )'
              ||CHR(10)||'ORDER BY lup_seq';
   RETURN l_retval;
--
END get_ngqa_lov_sql_inv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_lov_sql (pi_ngqt_item_type_type    nm_gaz_query_types.ngqt_item_type_type%TYPE
                          ,pi_ngqt_item_type         nm_gaz_query_types.ngqt_item_type%TYPE
                          ,pi_queryable_attribs_only boolean DEFAULT FALSE
                          ,pi_include_primary_key    boolean DEFAULT FALSE
                          ) RETURN varchar2 IS
--
   l_retval nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ngqa_lov_sql');
--
   IF    pi_ngqt_item_type_type = c_ngqt_item_type_type_ele
    THEN
      l_retval := get_ngqa_lov_sql_ele (pi_ngqt_item_type);
   ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_inv
    THEN
      l_retval := get_ngqa_lov_sql_inv (pi_ngqt_item_type
                                       ,pi_queryable_attribs_only
                                       ,pi_include_primary_key);
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_ngqa_lov_sql');
--
   RETURN l_retval;
--
END get_ngqa_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqt_lov_sql (pi_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE
                          ,pi_nit_category_restriction        IN nm_inv_types_all.nit_category%TYPE DEFAULT NULL
                          ,pi_exclude_off_network             IN BOOLEAN DEFAULT FALSE  -- defaulted to protect existing calls to this code
                          ) RETURN varchar2 IS
--
   l_retval nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ngqt_lov_sql');
--
   IF    pi_ngqt_item_type_type = c_ngqt_item_type_type_ele
    AND  g_allow_ele_item_type_type
    THEN

      l_retval :=            'SELECT nt_unique lup_meaning, nt_descr lup_description, nt_type lup_value'
                  ||CHR(10)||' FROM  nm_types'
                  ||CHR(10)||'WHERE  nt_datum = '||nm3flx.string('Y');

-- gj commented out to accommodate nm0590   
--  ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_inv
--  AND  g_allow_inv_item_type_type
    ELSIF g_allow_inv_item_type_type
    THEN

      l_retval :=            'SELECT nit_inv_type lup_meaning, nit_descr lup_description, nit_inv_type lup_value'
                  ||CHR(10)||'FROM  nm_inv_types'
                  ||CHR(10)||'WHERE EXISTS ( SELECT 1'
                               ||CHR(10)||'FROM hig_user_roles ur,'
                               ||CHR(10)||'     nm_inv_type_roles ir,'
                               ||CHR(10)||'     nm_user_aus usr,'
                               ||CHR(10)||'     nm_admin_units au,'
                               ||CHR(10)||'     nm_admin_groups nag,'
                               ||CHR(10)||'     hig_users hus'
                               ||CHR(10)||'WHERE hus.hus_username = USER'
                               ||CHR(10)||'AND ur.hur_role = ir.itr_hro_role'
                               ||CHR(10)||'AND ur.hur_username = hus.hus_username'
                               ||CHR(10)||'AND ir.itr_inv_type = nit_inv_type'
                               ||CHR(10)||'AND usr.nua_admin_unit = au.nau_admin_unit'
                               ||CHR(10)||'AND au.nau_admin_unit = nag_child_admin_unit'
                               ||CHR(10)||'AND au.nau_admin_type = nit_admin_type'
                               ||CHR(10)||'AND usr.nua_admin_unit = nag_parent_admin_unit'
                               ||CHR(10)||'AND usr.nua_user_id = hus.hus_user_id)';

      IF pi_nit_category_restriction IS NOT NULL THEN
         l_retval := l_retval||CHR(10)||'AND  nit_category = '||nm3flx.string(pi_nit_category_restriction);   
   END IF;
          
          
      IF NOT g_allow_ft_inv_types
       THEN
         l_retval := l_retval||CHR(10)||'AND  nit_table_name IS NULL';
      END IF;
   
   IF pi_exclude_off_network  
    THEN
         l_retval := l_retval||CHR(10)||'AND  nm3asset.is_off_network_vc(nit_inv_type) = ''FALSE''';
      END IF;        

   END IF;

   l_retval := l_retval || CHR(10) || 'ORDER BY 1';
--
   nm_debug.proc_end(g_package_name,'get_ngqt_lov_sql');
--
   RETURN l_retval;
--
END get_ngqt_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqt_item_type_type_lov_sq RETURN varchar2 IS
   l_retval nm3type.max_varchar2;
   l_where  varchar2(10) := ' WHERE ';
BEGIN
--
   l_retval :=           'SELECT *'
              ||CHR(10)||' FROM ('
              ||CHR(10)||hig.get_hig_domain_lov_sql (c_nqgt_item_type_type_domain)
              ||CHR(10)||'      )';
--
   IF NOT g_allow_ele_item_type_type
    THEN
      l_retval := l_retval
              ||CHR(10)||l_where||'lup_meaning != '||nm3flx.string(c_ngqt_item_type_type_ele);
      l_where  := '  AND  ';
   END IF;
--
   IF NOT g_allow_inv_item_type_type
    THEN
      l_retval := l_retval
              ||CHR(10)||l_where||'lup_meaning != '||nm3flx.string(c_ngqt_item_type_type_inv);
   END IF;
--
   RETURN l_retval;
--
END get_ngqt_item_type_type_lov_sq;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_pre_bracket_lov_sql RETURN varchar2 IS
BEGIN
   RETURN hig.get_hig_domain_lov_sql (c_ngqa_pre_bracket_domain);
END get_ngqa_pre_bracket_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_post_bracket_lov_sql RETURN varchar2 IS
BEGIN
   RETURN hig.get_hig_domain_lov_sql (c_ngqa_post_bracket_domain);
END get_ngqa_post_bracket_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_operator_lov_sql RETURN varchar2 IS
BEGIN
   RETURN hig.get_hig_domain_lov_sql (c_ngqa_operator_domain);
END get_ngqa_operator_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_condition_lov_sql RETURN varchar2 IS
BEGIN
   RETURN hig.get_hig_domain_lov_sql (c_ngqa_condition_domain);
END get_ngqa_condition_lov_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_sr_condition_lov_sql RETURN varchar2 IS
BEGIN
   RETURN hig.get_hig_domain_lov_sql (c_ngqa_sr_condition_domain);
END get_ngqa_sr_condition_lov_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_ngq_cascade (pi_ngq_id nm_gaz_query.ngq_id%TYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngq_cascade');
--
   del_ngq_cascade_keep_ngq (pi_ngq_id);
--
   DELETE nm_gaz_query
   WHERE  ngq_id      = pi_ngq_id;
--
   nm_debug.proc_end(g_package_name,'del_ngq_cascade');
--
END del_ngq_cascade;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_ngq_cascade_keep_ngq (pi_ngq_id nm_gaz_query.ngq_id%TYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_ngq_cascade_keep_ngq');
--
   DELETE nm_gaz_query_values
   WHERE  ngqv_ngq_id = pi_ngq_id;
--
   DELETE nm_gaz_query_attribs
   WHERE  ngqa_ngq_id = pi_ngq_id;
--
   DELETE nm_gaz_query_types
   WHERE  ngqt_ngq_id = pi_ngq_id;
--
   nm_debug.proc_end(g_package_name,'del_ngq_cascade_keep_ngq');
--
END del_ngq_cascade_keep_ngq;
--
-----------------------------------------------------------------------------
--
PROCEDURE chk_value_count_for_condition (pi_condition   nm_gaz_query_attribs.ngqa_condition%TYPE
                                        ,pi_value_count pls_integer
                                        ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'chk_value_count_for_condition');
--
   IF NOT nm3mrg_supplementary.valid_pbi_condition_values (pi_condition,pi_value_count)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 112
                    ,pi_supplementary_info => pi_condition||':'||pi_value_count
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'chk_value_count_for_condition');
--
END chk_value_count_for_condition;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_ngqt_item_type_type (p_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE) IS
BEGIN
--
   IF p_ngqt_item_type_type NOT IN (c_ngqt_item_type_type_ele
                                   ,c_ngqt_item_type_type_inv
                                   )
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 296
                    ,pi_supplementary_info => p_ngqt_item_type_type
                    );
   END IF;
--
END check_ngqt_item_type_type;
--
-----------------------------------------------------------------------------
--
--
-- GJ - check the inv type being used for the Gaz Query
--
PROCEDURE check_ngqt_item_type (p_ngqt_item_type nm_gaz_query_types.ngqt_item_type%TYPE) IS
BEGIN
--
-- if we have an off network asset type and the query is in the context
-- of some network then rais an error
--
  IF g_area_based_query OR g_roi_restricted_item_query THEN 

   IF nm3asset.is_off_network(pi_nit_inv_type => p_ngqt_item_type) 
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 433
                    ,pi_supplementary_info => p_ngqt_item_type
                    );
   END IF;
   
 END IF;      
--
END check_ngqt_item_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_meaning_and_desc_from_val (pi_sql_string  IN     varchar2
                                        ,pi_value       IN     varchar2
                                        ,po_meaning        OUT varchar2
                                        ,po_description    OUT varchar2
                                        ) IS
--
   l_cur   nm3type.ref_cursor;
   l_sql   nm3type.max_varchar2;
   l_found boolean;
--
BEGIN
--
   IF pi_value IS NOT NULL
    THEN
      IF pi_sql_string IS NOT NULL
       THEN
         l_sql :=           'SELECT lup_meaning, lup_description'
                 ||CHR(10)||' FROM ('
                 ||CHR(10)||pi_sql_string
                 ||CHR(10)||'      )'
                 ||CHR(10)||'WHERE lup_value = :a';
         OPEN  l_cur FOR l_sql USING pi_value;
         FETCH l_cur INTO po_meaning, po_description;
         l_found := l_cur%FOUND;
         CLOSE l_cur;
--
         IF NOT l_found
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 30
                          ,pi_supplementary_info => pi_value
                          );
         END IF;
--
      ELSE
         po_meaning := pi_value;
      END IF;
   END IF;
--
END get_meaning_and_desc_from_val;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqv_lov_meaning (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                               ,pi_ngqt_item_type      IN     nm_gaz_query_types.ngqt_item_type%TYPE
                               ,pi_ngqa_attrib_name    IN     nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                               ,pi_value               IN     nm_gaz_query_values.ngqv_value%TYPE
                               ,pi_condition           IN     varchar2 DEFAULT NULL
                               ,po_meaning                OUT varchar2
                               ,po_description            OUT varchar2
                               ) IS
--
   l_lov_sql_string nm3type.max_varchar2;
   dummy varchar2(2000);
--
BEGIN
--
   po_meaning     := pi_value;
   po_description := NULL;
--
   IF NVL(pi_condition,nm3type.c_nvl) LIKE '%LIKE%'
    AND NVL(INSTR(pi_value,'%',1,1),0) != 0
    THEN
      NULL;
   ELSE
      l_lov_sql_string := get_ngqv_lov_sql (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                                           ,pi_ngqt_item_type      => pi_ngqt_item_type
                                           ,pi_ngqa_attrib_name    => pi_ngqa_attrib_name
                                           );
      IF l_lov_sql_string IS NOT NULL
       THEN
         get_meaning_and_desc_from_val (pi_sql_string  => l_lov_sql_string
                                       ,pi_value       => pi_value
                                       ,po_meaning     => po_meaning
                                       ,po_description => po_description
                                       );
      ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_ele
       THEN
         IF pi_ngqa_attrib_name = 'NE_LENGTH'
          THEN
            DECLARE
               l_unit_id nm_units.un_unit_id%TYPE;
            BEGIN
               l_unit_id      := nm3net.get_nt_units (p_nt_type => pi_ngqt_item_type);
               po_meaning     := nm3unit.get_formatted_value
                                           (p_value   => pi_value
                                           ,p_unit_id => l_unit_id
                                           );
               po_description := nm3unit.get_unit_name (p_un_id => l_unit_id);
            END;
         END IF;
      ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_inv
       THEN
         BEGIN
            nm3inv.validate_flex_inv (p_inv_type               => pi_ngqt_item_type
                                     ,p_attrib_name            => pi_ngqa_attrib_name
                                     ,pi_value                 => pi_value
                                     ,po_value                 => po_meaning
                                     ,po_meaning               => po_description
                                     ,pi_validate_domain_dates => FALSE
                                     );
           IF po_meaning IS NULL THEN
             po_meaning     := pi_value;
           END IF;
         --
         EXCEPTION
            WHEN others
             THEN
             dummy:=dummy || ' error ';
               po_meaning     := pi_value;
               po_description := NULL;
         END;
      END IF;
   END IF;
--
END get_ngqv_lov_meaning;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqv_lov_meaning (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                               ,pi_ngqt_item_type      IN     nm_gaz_query_types.ngqt_item_type%TYPE
                               ,pi_ngqa_attrib_name    IN     nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                               ,pi_meaning             IN     varchar2
                               ,pi_condition           IN     varchar2 DEFAULT NULL
                               ,po_value                  OUT nm_gaz_query_values.ngqv_value%TYPE
                               ,po_meaning                OUT varchar2
                               ,po_description            OUT varchar2
                               ) IS
--
   l_lov_sql_string nm3type.max_varchar2;
   l_match_count    pls_integer;
--
   PROCEDURE internal_get_meaning (pi_sql_string IN     varchar2
                                  ,pi_meaning    IN     varchar2
                                  ,po_matches       OUT pls_integer
                                  ,po_value         OUT varchar2
                                  ,po_meaning       OUT varchar2
                                  ,po_description   OUT varchar2
                                  ) IS
   --
      l_cur nm3type.ref_cursor;
   --
   BEGIN
   --
      po_matches := 0;
   --
      OPEN  l_cur FOR pi_sql_string USING pi_meaning;
      LOOP
         FETCH l_cur INTO po_value, po_meaning, po_description;
         EXIT WHEN l_cur%NOTFOUND;
         po_matches := po_matches + 1;
      END LOOP;
      CLOSE l_cur;
   --
   END internal_get_meaning;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ngqv_lov_meaning');
--
   po_value       := pi_meaning;
   po_meaning     := pi_meaning;
   po_description := NULL;
--
   IF pi_meaning IS NOT NULL
    AND NVL(pi_condition,nm3type.c_nvl) NOT LIKE '%LIKE%'
    THEN
--
      l_lov_sql_string := get_ngqv_lov_sql (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                                           ,pi_ngqt_item_type      => pi_ngqt_item_type
                                           ,pi_ngqa_attrib_name    => pi_ngqa_attrib_name
                                           );
--
      IF l_lov_sql_string IS NOT NULL
       THEN
--
         --
         -- This is a LOV based item
         --
         l_lov_sql_string :=            'SELECT lup_value, lup_meaning, lup_description'
                             ||CHR(10)||' FROM ('
                             ||CHR(10)||l_lov_sql_string
                             ||CHR(10)||' ) WHERE lup_meaning LIKE :a';
--
         internal_get_meaning (pi_sql_string  => l_lov_sql_string
                              ,pi_meaning     => pi_meaning
                              ,po_matches     => l_match_count
                              ,po_value       => po_value
                              ,po_meaning     => po_meaning
                              ,po_description => po_description
                              );
--
         IF l_match_count = 0
          THEN
            internal_get_meaning (pi_sql_string  => l_lov_sql_string
                                 ,pi_meaning     => pi_meaning||'%'
                                 ,po_matches     => l_match_count
                                 ,po_value       => po_value
                                 ,po_meaning     => po_meaning
                                 ,po_description => po_description
                                 );
         END IF;
--
         IF    l_match_count = 0
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 29
           ,pi_sqlcode            => -2001
                          ,pi_supplementary_info => pi_meaning
                          );
         ELSIF l_match_count > 1
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 297
           ,pi_sqlcode            => -2001
                          ,pi_supplementary_info => pi_meaning
                          );
         END IF;
--
      ELSE
--
         --
         -- This is not a LOV based item. Check to make sure what
         --  the user has entered is of the correct datatype etc
--
         check_ngqv_value (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                          ,pi_ngqt_item_type      => pi_ngqt_item_type
                          ,pi_ngqa_attrib_name    => pi_ngqa_attrib_name
                          ,pi_nqgv_value          => pi_meaning
                          );
--
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_ngqv_lov_meaning');
--
END get_ngqv_lov_meaning;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqv_lov_code (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                            ,pi_ngqt_item_type      IN     nm_gaz_query_types.ngqt_item_type%TYPE
                            ,pi_ngqa_attrib_name    IN     nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                            ,pi_description         IN     nm_gaz_query_values.ngqv_value%TYPE
                            ,pi_condition           IN     varchar2 DEFAULT NULL
                            ,po_value               OUT varchar2
                            ,po_meaning             OUT varchar2
                            ,po_description         OUT varchar2
                            ) IS
--
   l_lov_sql_string nm3type.max_varchar2;
   l_match_count    pls_integer;
--
   PROCEDURE internal_get_meaning (pi_sql_string  IN     varchar2
                                  ,pi_description IN     varchar2
                                  ,po_matches       OUT pls_integer
                                  ,po_value         OUT varchar2
                                  ,po_meaning       OUT varchar2
                                  ,po_description   OUT varchar2
                                  ) IS
   --
      l_cur nm3type.ref_cursor;
   --
   BEGIN
   --
      po_matches := 0;
   --
      OPEN  l_cur FOR pi_sql_string USING pi_description;
      LOOP
         FETCH l_cur INTO po_value, po_meaning, po_description;
         EXIT WHEN l_cur%NOTFOUND;
         po_matches := po_matches + 1;
      END LOOP;
      CLOSE l_cur;
   --
   END internal_get_meaning;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ngqv_lov_code');
--
   po_value       := NULL;
   po_meaning     := NULL;
   po_description := NULL;
--
   IF pi_description IS NOT NULL
    AND NVL(pi_condition,nm3type.c_nvl) NOT LIKE '%LIKE%'
    THEN
--
      l_lov_sql_string := get_ngqv_lov_sql (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                                           ,pi_ngqt_item_type      => pi_ngqt_item_type
                                           ,pi_ngqa_attrib_name    => pi_ngqa_attrib_name
                                           );
--
      IF l_lov_sql_string IS NOT NULL
       THEN
--
         --
         -- This is a LOV based item
         --
         l_lov_sql_string :=            'SELECT lup_value, lup_meaning, lup_description'
                             ||CHR(10)||' FROM ('
                             ||CHR(10)||l_lov_sql_string
                             ||CHR(10)||' ) WHERE lup_description LIKE :a';
--
         internal_get_meaning (pi_sql_string  => l_lov_sql_string
                              ,pi_description => pi_description
                              ,po_matches     => l_match_count
                              ,po_value       => po_value
                              ,po_meaning     => po_meaning
                              ,po_description => po_description
                              );
--
         IF l_match_count = 0
          THEN
            internal_get_meaning (pi_sql_string  => l_lov_sql_string
                                 ,pi_description => pi_description||'%'
                                 ,po_matches     => l_match_count
                                 ,po_value       => po_value
                                 ,po_meaning     => po_meaning
                                 ,po_description => po_description
                                 );
         END IF;
--
         IF    l_match_count = 0
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 29
                          ,pi_sqlcode            => -2001
                          ,pi_supplementary_info => pi_description
                          );
         ELSIF l_match_count > 1
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 297
                          ,pi_sqlcode            => -2001
                          ,pi_supplementary_info => pi_description
                          );
         END IF;
--
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_ngqv_lov_code');
--
END get_ngqv_lov_code;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqv_lov_code (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                            ,pi_ngqt_item_type      IN     nm_gaz_query_types.ngqt_item_type%TYPE
                            ,pi_ngqa_attrib_name    IN     nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                            ,pi_description         IN     varchar2
                            ,pi_condition           IN     varchar2 DEFAULT NULL
                            ,po_value                  OUT nm_gaz_query_values.ngqv_value%TYPE
                            ,po_meaning                OUT varchar2
                            ) IS
--
   l_lov_sql_string nm3type.max_varchar2;
   l_match_count    pls_integer;
   l_description    nm_inv_type_attribs_all.ita_scrn_text%TYPE;
--
   PROCEDURE internal_get_code (pi_sql_string  IN     varchar2
                               ,pi_description IN     varchar2
                               ,po_matches       OUT pls_integer
                               ,po_value         OUT varchar2
                               ,po_meaning       OUT varchar2
                               ,po_description   OUT varchar2
                               ) IS
   --
      l_cur nm3type.ref_cursor;
   --
   BEGIN
   --
      po_matches := 0;
   --
      OPEN  l_cur FOR pi_sql_string USING pi_description;
      LOOP
         FETCH l_cur INTO po_value, po_meaning, po_description;
         EXIT WHEN l_cur%NOTFOUND;
         po_matches := po_matches + 1;
      END LOOP;
      CLOSE l_cur;
   --
   END internal_get_code;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ngqv_lov_code');
--
   po_value       := NULL;
   po_meaning     := NULL;
--
   IF pi_description IS NOT NULL
    AND NVL(pi_condition,nm3type.c_nvl) NOT LIKE '%LIKE%'
    THEN
--
      l_lov_sql_string := get_ngqv_lov_sql (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                                           ,pi_ngqt_item_type      => pi_ngqt_item_type
                                           ,pi_ngqa_attrib_name    => pi_ngqa_attrib_name
                                           );
--
      IF l_lov_sql_string IS NOT NULL
       THEN
--
         --
         -- This is a LOV based item
         --
         l_lov_sql_string :=            'SELECT lup_value, lup_meaning, lup_description'
                             ||CHR(10)||' FROM ('
                             ||CHR(10)||l_lov_sql_string
                             ||CHR(10)||' ) WHERE lup_description LIKE :a';
--
         internal_get_code (pi_sql_string  => l_lov_sql_string
                           ,pi_description => pi_description
                           ,po_matches     => l_match_count
                           ,po_value       => po_value
                           ,po_meaning     => po_meaning
                           ,po_description => l_description
                           );
--
         IF l_match_count = 0
          THEN
            internal_get_code (pi_sql_string  => l_lov_sql_string
                              ,pi_description => pi_description||'%'
                              ,po_matches     => l_match_count
                              ,po_value       => po_value
                              ,po_meaning     => po_meaning
                              ,po_description => l_description
                              );
         END IF;
--
         IF    l_match_count = 0
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_hig
                          ,pi_id                 => 29
                          ,pi_sqlcode            => -2001
                          ,pi_supplementary_info => pi_description
                          );
         ELSIF l_match_count > 1
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 297
                          ,pi_sqlcode            => -2001
                          ,pi_supplementary_info => pi_description
                          );
         END IF;
--
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_ngqv_lov_code');
--
END get_ngqv_lov_code;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqa_lov_meaning (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                              ,pi_ngqt_item_type      IN     nm_gaz_query_types.ngqt_item_type%TYPE
                              ,pi_value               IN     varchar2
                              ) RETURN varchar2 IS
--
   l_meaning nm3type.max_varchar2;
   l_desc    nm3type.max_varchar2;
--
BEGIN
--
   get_ngqa_lov_meaning (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                        ,pi_ngqt_item_type      => pi_ngqt_item_type
                        ,pi_value               => pi_value
                        ,po_meaning             => l_meaning
                        ,po_description         => l_desc
                        );
--
--  RETURN l_desc||' ('||l_meaning||')';
   RETURN l_desc;
--
END get_ngqa_lov_meaning;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqa_lov_meaning (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                               ,pi_ngqt_item_type      IN     nm_gaz_query_types.ngqt_item_type%TYPE
                               ,pi_value               IN     varchar2
                               ,po_meaning                OUT varchar2
                               ,po_description            OUT varchar2
                               ) IS
--
   l_lov_sql        nm3type.max_varchar2;
   l_check_from_lov boolean;
   l_rec_nit        nm_inv_types%ROWTYPE;
--
BEGIN
--
   --
   -- Do some extra checking to allow attribs through regardless of them being on the LOV
   --  if they are the PK column
   --
   IF    pi_ngqt_item_type_type = c_ngqt_item_type_type_inv
    THEN
      l_rec_nit := nm3get.get_nit (pi_nit_inv_type => pi_ngqt_item_type);
      l_rec_nit.nit_foreign_pk_column := NVL(l_rec_nit.nit_foreign_pk_column,'IIT_NE_ID');
      l_check_from_lov := pi_value != l_rec_nit.nit_foreign_pk_column;
   ELSIF pi_ngqt_item_type_type = c_ngqt_item_type_type_ele
    THEN
      l_check_from_lov := pi_value != 'NE_ID';
   END IF;
   IF l_check_from_lov
    THEN
      l_lov_sql := get_ngqa_lov_sql (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                                    ,pi_ngqt_item_type      => pi_ngqt_item_type
                                    );
      get_meaning_and_desc_from_val (pi_sql_string  => l_lov_sql
                                    ,pi_value       => pi_value
                                    ,po_meaning     => po_meaning
                                    ,po_description => po_description
                                    );
   ELSE
      po_meaning     := pi_value;
      po_description := pi_value;
   END IF;
--
END get_ngqa_lov_meaning;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqt_lov_meaning (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                               ,pi_value               IN     varchar2
                               ,po_meaning                OUT varchar2
                               ,po_description            OUT varchar2
                               ) IS
BEGIN
--
   get_meaning_and_desc_from_val (pi_sql_string  => get_ngqt_lov_sql (pi_ngqt_item_type_type => pi_ngqt_item_type_type)
                                 ,pi_value       => pi_value
                                 ,po_meaning     => po_meaning
                                 ,po_description => po_description
                                 );
--
END get_ngqt_lov_meaning;
--
-----------------------------------------------------------------------------
--
FUNCTION  get_ngqt_lov_descr (pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                             ,pi_value               IN     varchar2
                             ) RETURN varchar2 IS
   l_meaning nm3type.max_varchar2;
   l_descr   nm3type.max_varchar2;
BEGIN
   get_ngqt_lov_meaning (pi_ngqt_item_type_type => pi_ngqt_item_type_type
                        ,pi_value               => pi_value
                        ,po_meaning             => l_meaning
                        ,po_description         => l_descr
                        );
   RETURN l_descr;
END get_ngqt_lov_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqt_itm_type_type_meaning
                               (pi_value               IN     varchar2
                               ,po_meaning                OUT varchar2
                               ,po_description            OUT varchar2
                               ) IS
BEGIN
--
   get_meaning_and_desc_from_val (pi_sql_string  => get_ngqt_item_type_type_lov_sq
                                 ,pi_value       => pi_value
                                 ,po_meaning     => po_meaning
                                 ,po_description => po_description
                                 );
--
END get_ngqt_itm_type_type_meaning;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqt_item_type_type_descr
                               (pi_value               IN     varchar2
                               ) RETURN varchar2 IS
   l_meaning nm3type.max_varchar2;
   l_descr   nm3type.max_varchar2;
BEGIN
   get_ngqt_itm_type_type_meaning
                        (pi_value               => pi_value
                        ,po_meaning             => l_meaning
                        ,po_description         => l_descr
                        );
   RETURN l_descr;
END get_ngqt_item_type_type_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ngqa_condition_lov_meaning
                               (pi_value               IN     varchar2
                               ,po_meaning                OUT varchar2
                               ,po_description            OUT varchar2
                               ) IS
BEGIN
--
   get_meaning_and_desc_from_val (pi_sql_string  => get_ngqa_condition_lov_sql
                                 ,pi_value       => pi_value
                                 ,po_meaning     => po_meaning
                                 ,po_description => po_description
                                 );
--
END get_ngqa_condition_lov_meaning;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_name  RETURN varchar2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   l_retval := hig.get_ner (nm3type.c_net, 298).ner_descr;
   IF g_last_run_unique IS NOT NULL
    THEN
      l_retval := g_last_run_unique||'-'||l_retval;
   END IF;
   RETURN SUBSTR(l_retval,1,30);
END get_roi_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_descr RETURN varchar2 IS
BEGIN
   RETURN hig.get_ner (nm3type.c_net, 298).ner_descr;
END get_roi_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION  get_gaz_pre_query_sql (pi_roi_type     IN     varchar2
                                ,pi_roi_id       IN     number
                                ,pi_ne_id_col    IN     varchar2
                                ,pi_begin_mp_col IN     varchar2 DEFAULT NULL
                                ,pi_end_mp_col   IN     varchar2 DEFAULT NULL
                                ,pi_where_text   IN     varchar2
                                ,pi_use_all_tabs IN     boolean  DEFAULT FALSE
                                ) RETURN varchar2 IS
--
   l_retval                  nm3type.max_varchar2;
   c_subquery_alias CONSTANT varchar2(30) := LOWER(nm3flx.LEFT(pi_roi_type||'_'||pi_roi_id,30));
   c_end_mp_col     CONSTANT varchar2(61) := NVL(pi_end_mp_col,pi_begin_mp_col);
--
   c_begin_mp       CONSTANT varchar2(9)  := '_begin_mp';
   c_end_mp         CONSTANT varchar2(7)  := '_end_mp';
--
   l_all                     varchar2(4)  := NULL;
--
   PROCEDURE do_partial_bit (p_begin_mp_col varchar2
                            ,p_end_mp_col   varchar2
                            ) IS
   BEGIN
      IF   pi_begin_mp_col IS NOT NULL
       AND c_end_mp_col    IS NOT NULL
        THEN
          l_retval := l_retval
                      ||CHR(10)||'           AND   (('||pi_begin_mp_col||' < NVL('||c_subquery_alias||'.'||p_end_mp_col||','||pi_begin_mp_col||'+1)'
                      ||CHR(10)||'                 AND NVL('||c_end_mp_col||', '||c_subquery_alias||'.'||p_begin_mp_col||' + 1) > '||c_subquery_alias||'.'||p_begin_mp_col
                      ||CHR(10)||'                  )'
                      ||CHR(10)||'               OR ('||pi_begin_mp_col||' = '||c_end_mp_col
                      ||CHR(10)||'                 AND '||pi_begin_mp_col||' BETWEEN '||c_subquery_alias||'.'||p_begin_mp_col||' AND NVL('||c_subquery_alias||'.'||p_end_mp_col||', '||pi_begin_mp_col||')'
                      ||CHR(10)||'                  )'
                      ||CHR(10)||'                 )';
      END IF;
   END do_partial_bit;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_gaz_pre_query_sql');
--
   IF pi_use_all_tabs
    THEN
      l_all := '_all';
   END IF;
--
   l_retval := pi_where_text;
--
   IF   pi_roi_id   IS NOT NULL
    AND pi_roi_type IS NOT NULL
    THEN
      IF l_retval IS NOT NULL
       THEN
         l_retval := l_retval||CHR(10)||' AND ';
      END IF;
      IF    pi_roi_type IN (nm3extent.c_roi_section,nm3extent.c_roi_db)
       THEN
         --user has SELECTed datum section
         l_retval := l_retval||pi_ne_id_col||' = '||pi_roi_id;
      ELSIF pi_roi_type = nm3extent.c_roi_gos
       THEN
         --user has SELECTed group of sections
         l_retval := l_retval||pi_ne_id_col||' IN (SELECT '||c_subquery_alias||'.nm_ne_id_of'
                             ||CHR(10)||'           FROM  nm_members'||l_all||' '||c_subquery_alias
                             ||CHR(10)||'          WHERE  '||c_subquery_alias||'.nm_ne_id_in = '||pi_roi_id;
          do_partial_bit (p_begin_mp_col => 'nm'||c_begin_mp
                         ,p_end_mp_col   => 'nm'||c_end_mp
                         );
         l_retval := l_retval||CHR(10)||'         )';
      ELSIF pi_roi_type = nm3extent.c_roi_gog
       THEN
        --user has SELECTed group of groups
         IF   pi_begin_mp_col IS NULL
          AND c_end_mp_col    IS NULL
          THEN
            l_retval := l_retval||pi_ne_id_col||' IN (SELECT '||c_subquery_alias||'.nm_ne_id_of'
                                ||CHR(10)||'           FROM  nm_members'||l_all||' '||c_subquery_alias
                                ||CHR(10)||'          CONNECT BY PRIOR '||c_subquery_alias||'.nm_ne_id_of = '||c_subquery_alias||'.nm_ne_id_in '
                                ||CHR(10)||'          START WITH '||c_subquery_alias||'.nm_ne_id_in       = '||pi_roi_id
                                ||CHR(10)||'         )';
         ELSE
            -- If we are looking "partially" at a Group of Groups then we need to do another
            --  subquery
            l_retval := l_retval||         'EXISTS (SELECT 1'
                                ||CHR(10)||'        FROM  nm_members'||l_all||' '||c_subquery_alias
                                ||CHR(10)||'       WHERE  '||c_subquery_alias||'.nm_ne_id_of = '||pi_ne_id_col;

            do_partial_bit (p_begin_mp_col => 'nm'||c_begin_mp
                           ,p_end_mp_col   => 'nm'||c_end_mp
                           );
            l_retval := l_retval||CHR(10)||'        AND   '||c_subquery_alias||'.nm_ne_id_in IN (SELECT csq2.nm_ne_id_of'
                                ||CHR(10)||'                                    FROM  nm_members'||l_all||' csq2'
                                ||CHR(10)||'                                   CONNECT BY PRIOR csq2.nm_ne_id_of = csq2.nm_ne_id_in '
                                ||CHR(10)||'                                   START WITH csq2.nm_ne_id_in       = '||pi_roi_id
                                ||CHR(10)||'                                  )';
            l_retval := l_retval||CHR(10)||'       )';
         END IF;
      ELSIF pi_roi_type = nm3extent.c_roi_temp_ne
       THEN
         --user has SELECTed temp NE
         l_retval := l_retval||pi_ne_id_col||' IN (SELECT '||c_subquery_alias||'.nte_ne_id_of'
                             ||CHR(10)||'           FROM  nm_nw_temp_extents '||c_subquery_alias
                             ||CHR(10)||'          WHERE  '||c_subquery_alias||'.nte_job_id = '||pi_roi_id;
         do_partial_bit (p_begin_mp_col => 'nte'||c_begin_mp
                        ,p_end_mp_col   => 'nte'||c_end_mp
                        );
         l_retval := l_retval||CHR(10)||'         )';
      ELSIF pi_roi_type = nm3extent.c_roi_pbi
       THEN
        --user has SELECTed PBI results
         l_retval := l_retval||pi_ne_id_col||' IN (SELECT '||c_subquery_alias||'.npm_ne_id_of'
                             ||CHR(10)||'           FROM  nm_pbi_section_members '||c_subquery_alias
                             ||CHR(10)||'          WHERE  '||c_subquery_alias||'.npm_nqr_job_id = '||pi_roi_id;
         do_partial_bit (p_begin_mp_col => 'npm'||c_begin_mp
                        ,p_end_mp_col   => 'npm'||c_end_mp
                        );
         l_retval := l_retval||CHR(10)||'         )';
      ELSIF pi_roi_type = nm3extent.c_roi_extent
       THEN
        --user has SELECTed saved extent
         l_retval := l_retval||pi_ne_id_col||' IN (SELECT '||c_subquery_alias||'.nsd_ne_id'
                             ||CHR(10)||'           FROM  nm_saved_extent_member_datums '||c_subquery_alias
                             ||CHR(10)||'          WHERE  '||c_subquery_alias||'.nsd_nse_id = '||pi_roi_id;
         do_partial_bit (p_begin_mp_col => 'nsd'||c_begin_mp
                        ,p_end_mp_col   => 'nsd'||c_end_mp
                        );
         l_retval := l_retval||CHR(10)||'         )';
      ELSIF pi_roi_type = nm3extent.c_roi_gis
       THEN
        --user has SELECTed GIS
         l_retval := l_retval||pi_ne_id_col||' IN (SELECT '||c_subquery_alias||'.gdo_pk_id'
                             ||CHR(10)||'           FROM  gis_data_objects '||c_subquery_alias
                             ||CHR(10)||'          WHERE  '||c_subquery_alias||'.gdo_session_id = '||pi_roi_id
                             ||CHR(10)||'         )';
      ELSE
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 110
                       ,pi_supplementary_info => 'pi_roi_type="'||pi_roi_type||'"'
                       );
      END IF;
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_gaz_pre_query_sql');
--
   RETURN l_retval;
--
END get_gaz_pre_query_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_gaz_pre_query_sql (pi_roi_type     IN     varchar2
                                ,pi_roi_id       IN     number
                                ,pi_ne_id_col    IN     varchar2
                                ,pi_begin_mp_col IN     varchar2 DEFAULT NULL
                                ,pi_end_mp_col   IN     varchar2 DEFAULT NULL
                                ,pio_where_text  IN OUT varchar2
                                ,pi_use_all_tabs IN     boolean  DEFAULT FALSE
                                ) IS
BEGIN
--
   pio_where_text := get_gaz_pre_query_sql (pi_roi_type     => pi_roi_type
                                           ,pi_roi_id       => pi_roi_id
                                           ,pi_ne_id_col    => pi_ne_id_col
                                           ,pi_begin_mp_col => pi_begin_mp_col
                                           ,pi_end_mp_col   => pi_end_mp_col
                                           ,pi_where_text   => pio_where_text
                                           ,pi_use_all_tabs => pi_use_all_tabs
                                           );
--
END get_gaz_pre_query_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_ngqa_operator RETURN nm_gaz_query_attribs.ngqa_operator%TYPE IS
BEGIN
   RETURN nm3type.c_and_operator;
END get_default_ngqa_operator;
--
-----------------------------------------------------------------------------
--
FUNCTION ngqa_attrib_name_is_updatable(pi_ngq_id      IN nm_gaz_query.ngq_id%TYPE
                                      ,pi_ngqt_seq_no IN nm_gaz_query_types.ngqt_seq_no%TYPE
                                      ,pi_ngqa_seq_no IN nm_gaz_query_attribs.ngqa_seq_no%TYPE
                                      ) RETURN boolean IS

  l_dummy pls_integer;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ngqa_attribute_is_updatable');

  ---------------------------------------------------
  --check for existence of values for attribute
  --if there are any user cannot update the attribute
  ---------------------------------------------------
  BEGIN
    SELECT
      1
    INTO
      l_dummy
    FROM
      dual
    WHERE
      EXISTS (SELECT
                1
              FROM
                nm_gaz_query_values ngqv
              WHERE
                ngqv.ngqv_ngq_id = pi_ngq_id
              AND
                ngqv.ngqv_ngqt_seq_no = pi_ngqt_seq_no
              AND
                ngqv.ngqv_ngqa_seq_no = pi_ngqa_seq_no);

    l_retval := FALSE;

  EXCEPTION
    WHEN no_data_found
    THEN
      l_retval := TRUE;

  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ngqa_attribute_is_updatable');

  RETURN l_retval;

END ngqa_attrib_name_is_updatable;
--
-----------------------------------------------------------------------------
--
FUNCTION ngqt_type_is_updatable(pi_ngq_id      IN nm_gaz_query.ngq_id%TYPE
                               ,pi_ngqt_seq_no IN nm_gaz_query_types.ngqt_seq_no%TYPE
                               ) RETURN boolean IS

  l_dummy pls_integer;

  l_retval boolean;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ngqt_type_is_updatable');

  ----------------------------------------------
  --check for existence of attributes for type
  --if there are any user cannot update the type
  ----------------------------------------------
  BEGIN
    SELECT
      1
    INTO
      l_dummy
    FROM
      dual
    WHERE
      EXISTS (SELECT
                1
              FROM
                nm_gaz_query_attribs ngqa
              WHERE
                ngqa.ngqa_ngq_id = pi_ngq_id
              AND
                ngqa.ngqa_ngqt_seq_no = pi_ngqt_seq_no);

    l_retval := FALSE;

  EXCEPTION
    WHEN others
    THEN
      l_retval := TRUE;

  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ngqt_type_is_updatable');

  RETURN l_retval;

END ngqt_type_is_updatable;
--
-----------------------------------------------------------------------------
--
PROCEDURE stash_query_definition(pi_ngq_id IN nm_gaz_query.ngq_id%TYPE
                                ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'stash_query_definition');
--
  g_ngq_tab.DELETE;
  g_ngqt_tab.DELETE;
  g_ngqa_tab.DELETE;
  g_ngqv_tab.DELETE;
--
  FOR l_rec IN (SELECT
                  ngq.*
                FROM
                  nm_gaz_query ngq
                WHERE
                  ngq.ngq_id =  pi_ngq_id)
  LOOP
    g_ngq_tab(g_ngq_tab.COUNT + 1) := l_rec;
  END LOOP;

  FOR l_rec IN (SELECT
                  ngqt.*
                FROM
                  nm_gaz_query_types ngqt
                WHERE
                  ngqt.ngqt_ngq_id =  pi_ngq_id)
  LOOP
    g_ngqt_tab(g_ngqt_tab.COUNT + 1) := l_rec;
  END LOOP;

  FOR l_rec IN (SELECT
                  ngqa.*
                FROM
                  nm_gaz_query_attribs ngqa
                WHERE
                  ngqa.ngqa_ngq_id =  pi_ngq_id)
  LOOP
    g_ngqa_tab(g_ngqa_tab.COUNT + 1) := l_rec;
  END LOOP;

  FOR l_rec IN (SELECT
                  ngqv.*
                FROM
                  nm_gaz_query_values ngqv
                WHERE
                  ngqv.ngqv_ngq_id =  pi_ngq_id)
  LOOP
    g_ngqv_tab(g_ngqv_tab.COUNT + 1) := l_rec;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'stash_query_definition');

END stash_query_definition;
--
-----------------------------------------------------------------------------
--
PROCEDURE restore_query_definition IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'restore_query_definition');

  FOR l_i IN 1..g_ngq_tab.COUNT
  LOOP
    --delete query first if it exists
    del_ngq_cascade(pi_ngq_id => g_ngq_tab(l_i).ngq_id);

    nm3ins.ins_ngq(p_rec_ngq => g_ngq_tab(l_i));
  END LOOP;

  FOR l_i IN 1..g_ngqt_tab.COUNT
  LOOP
    nm3ins.ins_ngqt(p_rec_ngqt => g_ngqt_tab(l_i));
  END LOOP;

  FOR l_i IN 1..g_ngqa_tab.COUNT
  LOOP
    nm3ins.ins_ngqa(p_rec_ngqa => g_ngqa_tab(l_i));
  END LOOP;

  FOR l_i IN 1..g_ngqv_tab.COUNT
  LOOP
    nm3ins.ins_ngqv(p_rec_ngqv => g_ngqv_tab(l_i));
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'restore_query_definition');

END restore_query_definition;
--
-----------------------------------------------------------------------------
--
PROCEDURE perform_item_list_retrieval IS
BEGIN
   FOR i IN 1..g_tab_ngqt_list_sql.COUNT
    LOOP
      test_debug ('Executing this '|| g_tab_ngqt_list_sql(i) );
      execute_sql_item(i);
      test_debug ('Execution complete');
   END LOOP;
END perform_item_list_retrieval;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_rec_ngqi (p_ngqi_id nm_gaz_query_item_list.ngqi_job_id%TYPE
                          ) RETURN tab_rec_ngqi IS
--
   CURSOR cs_ngqi (c_ngqi_id nm_gaz_query_item_list.ngqi_job_id%TYPE) IS
   SELECT *
    FROM  nm_gaz_query_item_list
   WHERE  ngqi_job_id = c_ngqi_id;
--
   l_tab_rec_ngqi tab_rec_ngqi;
--
BEGIN
--
   FOR cs_rec IN cs_ngqi (p_ngqi_id)
    LOOP
      l_tab_rec_ngqi (cs_ngqi%rowcount) := cs_rec;
   END LOOP;
--
   RETURN l_tab_rec_ngqi;
--
END get_tab_rec_ngqi;
--
-----------------------------------------------------------------------------
--
PROCEDURE disallow_inv_item_type_type IS
BEGIN
   g_allow_inv_item_type_type := FALSE;
END disallow_inv_item_type_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE allow_inv_item_type_type IS
BEGIN
   g_allow_inv_item_type_type := TRUE;
END allow_inv_item_type_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE disallow_ele_item_type_type IS
BEGIN
   g_allow_ele_item_type_type := FALSE;
END disallow_ele_item_type_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE allow_ele_item_type_type IS
BEGIN
   g_allow_ele_item_type_type := TRUE;
END allow_ele_item_type_type;
--
-----------------------------------------------------------------------------
--
PROCEDURE disallow_ft_inv_types IS
BEGIN
   g_allow_ft_inv_types := FALSE;
END disallow_ft_inv_types;
--
-----------------------------------------------------------------------------
--
PROCEDURE allow_ft_inv_types IS
BEGIN
   g_allow_ft_inv_types := TRUE;
END allow_ft_inv_types;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_item_type_type_allowed (p_ngqt_item_type_type nm_gaz_query_types.ngqt_item_type_type%TYPE) IS
   l_fail boolean;
BEGIN
   l_fail :=   (p_ngqt_item_type_type = c_ngqt_item_type_type_ele AND NOT g_allow_ele_item_type_type)
            OR (p_ngqt_item_type_type = c_ngqt_item_type_type_inv AND NOT g_allow_inv_item_type_type);
   IF l_fail
    THEN
 

      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 313
                    ,pi_supplementary_info => p_ngqt_item_type_type
                    );
   END IF;
END check_item_type_type_allowed;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqt_item_type_type_ele RETURN nm_gaz_query_types.ngqt_item_type_type%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_ngqt_item_type_type_ele');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_ngqt_item_type_type_ele');

  RETURN c_ngqt_item_type_type_ele;

END get_ngqt_item_type_type_ele;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ngqt_item_type_type_inv RETURN nm_gaz_query_types.ngqt_item_type_type%TYPE IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_ngqt_item_type_type_inv');

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_ngqt_item_type_type_inv');

  RETURN c_ngqt_item_type_type_inv;

END get_ngqt_item_type_type_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_selected_item_details (pi_ngqi_item_id        nm_gaz_query_item_list.ngqi_item_id%TYPE
                                    ,pi_ngqi_item_type_type nm_gaz_query_item_list.ngqi_item_type_type%TYPE
                                    ,pi_ngqi_item_type      nm_gaz_query_item_list.ngqi_item_type%TYPE
                                    ) IS
   l_rec_selected_item_details rec_selected_item_details;
BEGIN
   g_selected_ngqi_job_id                           := NULL;
   l_rec_selected_item_details.ngqi_item_id         := pi_ngqi_item_id;
   l_rec_selected_item_details.ngqi_item_type_type  := pi_ngqi_item_type_type;
   l_rec_selected_item_details.ngqi_item_type       := pi_ngqi_item_type;
   g_rec_selected_item_details                      := l_rec_selected_item_details;

  /* nm_debug.debug_on;
   nm_debug.debug('Results');
   nm_debug.debug('Item ID : '||g_rec_selected_item_details.ngqi_item_id);
   nm_debug.debug('Item Type Type: '||g_rec_selected_item_details.ngqi_item_type_type);
   nm_debug.debug('Item Type : '||g_rec_selected_item_details.ngqi_item_type);*/
END set_selected_item_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_selected_item_detail_by_pk (pi_iit_primary_key     nm_inv_items.iit_primary_key%TYPE
                                         ,pi_ngqi_item_type_type nm_gaz_query_item_list.ngqi_item_type_type%TYPE
                                         ,pi_ngqi_item_type      nm_gaz_query_item_list.ngqi_item_type%TYPE
                                         ) IS
   l_rec_selected_item_details rec_selected_item_details;
   c_sqlcode CONSTANT pls_integer := -20555;
BEGIN
   --
   g_selected_ngqi_job_id                           := NULL;
   l_rec_selected_item_details.ngqi_item_type_type  := pi_ngqi_item_type_type;
   l_rec_selected_item_details.ngqi_item_type       := pi_ngqi_item_type;
   l_rec_selected_item_details.iit_primary_key      := pi_iit_primary_key;
   --
   IF g_rec_selected_item_details.ngqi_item_type_type = c_ngqt_item_type_type_ele
    THEN
      DECLARE
         l_rec_ne nm_elements_all%ROWTYPE;
      BEGIN
         l_rec_ne := nm3get.get_ne_all (pi_ne_id             => nm3net.get_ne_id(pi_iit_primary_key)
                                       ,pi_not_found_sqlcode => c_sqlcode
                                       );
         l_rec_selected_item_details.ngqi_item_id    := l_rec_ne.ne_id;
         l_rec_selected_item_details.iit_descr       := l_rec_ne.ne_descr;
      END;
   ELSE
      DECLARE
         l_rec_nit nm_inv_types%ROWTYPE;
         l_rec_iit nm_inv_items%ROWTYPE;
      BEGIN
         l_rec_nit := nm3get.get_nit(pi_nit_inv_type      => l_rec_selected_item_details.ngqi_item_type
                                    ,pi_not_found_sqlcode => c_sqlcode
                                    );
         IF l_rec_nit.nit_table_name IS NULL
          THEN
            l_rec_iit := nm3get.get_iit (pi_iit_primary_key   => pi_iit_primary_key
                                        ,pi_iit_inv_type      => pi_ngqi_item_type
                                        ,pi_not_found_sqlcode => c_sqlcode
                                        );
            l_rec_selected_item_details.ngqi_item_id    := l_rec_iit.iit_ne_id;
            l_rec_selected_item_details.iit_primary_key := l_rec_iit.iit_primary_key;
            l_rec_selected_item_details.iit_descr       := l_rec_iit.iit_descr;
         ELSE
            l_rec_selected_item_details.ngqi_item_id    := l_rec_selected_item_details.iit_primary_key;
            l_rec_selected_item_details.iit_descr       := l_rec_selected_item_details.ngqi_item_id;
         END IF;
      END;
   END IF;
   --
   g_rec_selected_item_details                      := l_rec_selected_item_details;
   --
END set_selected_item_detail_by_pk;
--
-----------------------------------------------------------------------------
--
FUNCTION get_selected_item_details RETURN rec_selected_item_details IS
BEGIN
   IF g_rec_selected_item_details.ngqi_item_id IS NOT NULL
    THEN
      IF g_rec_selected_item_details.iit_primary_key IS NULL
       THEN
         IF g_rec_selected_item_details.ngqi_item_type_type = c_ngqt_item_type_type_ele
          THEN
            DECLARE
               l_rec_ne nm_elements_all%ROWTYPE;
            BEGIN
               l_rec_ne := nm3get.get_ne_all (pi_ne_id => g_rec_selected_item_details.ngqi_item_id);
               g_rec_selected_item_details.iit_primary_key := l_rec_ne.ne_unique;
               g_rec_selected_item_details.iit_descr       := l_rec_ne.ne_descr;
            END;
         ELSE
            DECLARE
               l_rec_nit nm_inv_types%ROWTYPE;
               l_rec_iit nm_inv_items_all%ROWTYPE;
            BEGIN
               l_rec_nit := nm3get.get_nit(pi_nit_inv_type => g_rec_selected_item_details.ngqi_item_type);
               IF l_rec_nit.nit_table_name IS NULL
                THEN
                  l_rec_iit := nm3get.get_iit_all (pi_iit_ne_id => g_rec_selected_item_details.ngqi_item_id);
                  g_rec_selected_item_details.iit_primary_key := l_rec_iit.iit_primary_key;
                  g_rec_selected_item_details.iit_descr       := l_rec_iit.iit_descr;
               ELSE
                  g_rec_selected_item_details.iit_primary_key := g_rec_selected_item_details.ngqi_item_id;
                  g_rec_selected_item_details.iit_descr       := g_rec_selected_item_details.ngqi_item_id;
               END IF;
            END;
         END IF;
      END IF;
   END IF;
   RETURN g_rec_selected_item_details;
END get_selected_item_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_selected_item_list_details (pi_ngqi_job_id nm_gaz_query_item_list.ngqi_job_id%TYPE) IS
   l_rec_selected_item_details rec_selected_item_details;
BEGIN
   g_rec_selected_item_details   := l_rec_selected_item_details;
   g_selected_ngqi_job_id        := pi_ngqi_job_id;
END set_selected_item_list_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_selected_item_list_details RETURN nm_gaz_query_item_list.ngqi_job_id%TYPE IS
BEGIN
   RETURN g_selected_ngqi_job_id;
END get_selected_item_list_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_where_clause_for_selected (p_id_column      varchar2
                                       ,p_item_type_type varchar2 DEFAULT 'I'
                                       ) RETURN varchar2 IS
   l_retval nm3type.max_varchar2;
BEGIN
--
   IF g_selected_ngqi_job_id IS NOT NULL
    THEN
      l_retval := p_id_column||' IN (SELECT ngqi_item_id'
                 ||CHR(10)||'         FROM  nm_gaz_query_item_list'
                 ||CHR(10)||'        WHERE  ngqi_job_id = '||g_selected_ngqi_job_id;
      IF p_item_type_type IS NOT NULL
       THEN
         l_retval := l_retval
                 ||CHR(10)||'         AND   ngqi_item_type_type = '||nm3flx.string(p_item_type_type);
      END IF;
      l_retval := l_retval
                 ||CHR(10)||'        )';
   ELSIF g_rec_selected_item_details.ngqi_item_id IS NOT NULL
    AND  g_rec_selected_item_details.ngqi_item_type_type = NVL(p_item_type_type,g_rec_selected_item_details.ngqi_item_type_type)
    THEN
      l_retval := p_id_column||' = '||g_rec_selected_item_details.ngqi_item_id;
   END IF;
--
   RETURN l_retval;
--
END get_where_clause_for_selected;
--
-----------------------------------------------------------------------------
--
PROCEDURE stash_item_list_details (pi_ngqi_job_id nm_gaz_query_item_list.ngqi_job_id%TYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'stash_item_list_details');
--
   g_stash_ngqi_job_id.DELETE;
   g_stash_ngqi_item_type_type.DELETE;
   g_stash_ngqi_item_type.DELETE;
   g_stash_ngqi_item_id.DELETE;
--
   IF pi_ngqi_job_id IS NOT NULL
    THEN
      SELECT ngqi_job_id
            ,ngqi_item_type_type
            ,ngqi_item_type
            ,ngqi_item_id
       BULK  COLLECT
       INTO  g_stash_ngqi_job_id
            ,g_stash_ngqi_item_type_type
            ,g_stash_ngqi_item_type
            ,g_stash_ngqi_item_id
       FROM  nm_gaz_query_item_list
      WHERE  ngqi_job_id = pi_ngqi_job_id;
   END IF;
--
   nm_debug.proc_end(g_package_name,'stash_item_list_details');
--
END stash_item_list_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE restore_item_list_details IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'restore_item_list_details');
--
   FORALL i IN 1..g_stash_ngqi_job_id.COUNT
      INSERT INTO nm_gaz_query_item_list
             (ngqi_job_id
             ,ngqi_item_type_type
             ,ngqi_item_type
             ,ngqi_item_id
             )
      VALUES (g_stash_ngqi_job_id(i)
             ,g_stash_ngqi_item_type_type(i)
             ,g_stash_ngqi_item_type(i)
             ,g_stash_ngqi_item_id(i)
             );
--
   nm_debug.proc_end(g_package_name,'restore_item_list_details');
--
END restore_item_list_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_items_at_location (pi_ne_id       IN nm_elements.ne_id%TYPE
                                   ,pi_nm_begin_mp IN nm_members.nm_begin_mp%TYPE
                                   ,pi_nm_end_mp   IN nm_members.nm_end_mp%TYPE   DEFAULT NULL
                                   ,pi_npq_id      IN nm_pbi_query.npq_id%TYPE    DEFAULT NULL
                                   ) RETURN tab_rec_ngqi IS
--
   l_rec_ngq      nm_gaz_query%ROWTYPE;
--
   l_ngqi_job_id  nm_gaz_query_item_list.ngqi_job_id%TYPE;
   l_tab_rec_ngqi tab_rec_ngqi;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_all_items_at_location');
--
   l_rec_ngq.ngq_id                 := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_source_id          := pi_ne_id;
   l_rec_ngq.ngq_source             := nm3extent.c_route;
   l_rec_ngq.ngq_open_or_closed     := c_closed_query;
   l_rec_ngq.ngq_items_or_area      := c_items_query;
   l_rec_ngq.ngq_query_all_items    := 'N';
   l_rec_ngq.ngq_begin_mp           := pi_nm_begin_mp;
   l_rec_ngq.ngq_begin_datum_ne_id  := NULL;
   l_rec_ngq.ngq_begin_datum_offset := NULL;
   l_rec_ngq.ngq_end_mp             := NVL(pi_nm_end_mp,pi_nm_begin_mp);
   l_rec_ngq.ngq_end_datum_ne_id    := NULL;
   l_rec_ngq.ngq_end_datum_offset   := NULL;
   l_rec_ngq.ngq_ambig_sub_class    := NULL;
   nm3ins.ins_ngq (l_rec_ngq);
--
   IF pi_npq_id IS NOT NULL
    THEN
      nm3pbi.move_pbi_to_gaz_qry (pi_npq_id => pi_npq_id
                                 ,pi_ngq_id => l_rec_ngq.ngq_id
                                 );
   ELSE
      -- If we haven't specified a PBI query, then
      --   make sure we don't have FT inventory in the LOV - it would take forever
      nm3gaz_qry.disallow_ft_inv_types;
      add_all_possible_types_to_ngq (pi_ngq_id => l_rec_ngq.ngq_id);
   END IF;
--
   l_ngqi_job_id  := perform_query    (pi_ngq_id => l_rec_ngq.ngq_id);
--
   l_tab_rec_ngqi := get_tab_rec_ngqi (p_ngqi_id => l_ngqi_job_id);
--
   nm_debug.proc_end(g_package_name,'get_all_items_at_location');
--
   RETURN l_tab_rec_ngqi;
--
END get_all_items_at_location;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_all_items_at_location (pi_ne_id                    IN     nm_elements.ne_id%TYPE
                                    ,pi_nm_begin_mp              IN     nm_members.nm_begin_mp%TYPE
                                    ,pi_nm_end_mp                IN     nm_members.nm_end_mp%TYPE   DEFAULT NULL
                                    ,pi_npq_id                   IN     nm_pbi_query.npq_id%TYPE    DEFAULT NULL
                                    ,po_tab_item_type_type          OUT nm3type.tab_varchar4
                                    ,po_tab_item_type_type_descr    OUT nm3type.tab_varchar80
                                    ,po_tab_item_type               OUT nm3type.tab_varchar4
                                    ,po_tab_item_type_descr         OUT nm3type.tab_varchar80
                                    ,po_tab_item_id                 OUT nm3type.tab_number
                                    ) IS
   l_tab_rec_ngqi tab_rec_ngqi;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_all_items_at_location');
--
   l_tab_rec_ngqi := get_all_items_at_location (pi_ne_id       => pi_ne_id
                                               ,pi_nm_begin_mp => pi_nm_begin_mp
                                               ,pi_nm_end_mp   => pi_nm_end_mp
                                               ,pi_npq_id      => pi_npq_id
                                               );
--
   FOR i IN 1..l_tab_rec_ngqi.COUNT
    LOOP
      po_tab_item_type_type(i)       := l_tab_rec_ngqi(i).ngqi_item_type_type;
      po_tab_item_type_type_descr(i) := get_ngqt_item_type_type_descr (pi_value => po_tab_item_type_type(i));
      po_tab_item_type(i)            := l_tab_rec_ngqi(i).ngqi_item_type;
      po_tab_item_type_descr(i)      := get_ngqt_lov_descr (pi_ngqt_item_type_type => po_tab_item_type_type(i)
                                                           ,pi_value               => po_tab_item_type(i)
                                                           );
      po_tab_item_id(i)              := l_tab_rec_ngqi(i).ngqi_item_id;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_all_items_at_location');
--
END get_all_items_at_location;
--
-----------------------------------------------------------------------------
--
-- GJ to support NM0590
-- loop through a table of inv categories and insert all types in the category
-- into the gaz query types table
--  
PROCEDURE add_inv_types_for_categories(pi_ngq_id              IN nm_gaz_query.ngq_id%TYPE
                                      ,pi_tab_categories      IN nm3type.tab_varchar4
                                      ,pi_exclude_off_network IN BOOLEAN DEFAULT FALSE) IS
 
   l_cur                 nm3type.ref_cursor;        
   l_lup_meaning         nm3type.max_varchar2;
   l_lup_description     nm3type.max_varchar2;
   l_lup_value           nm3type.max_varchar2;
--
   l_rec_ngqt            nm_gaz_query_types%ROWTYPE;
--
BEGIN

   FOR i IN 1..pi_tab_categories.COUNT
    LOOP
 
  IF pi_tab_categories(i) IS NOT NULL THEN

--nm_debug.debug_on;
--nm_debug.debug('SQL FOR '||pi_tab_categories(i) ||' IS '||get_ngqt_lov_sql (pi_ngqt_item_type_type          => 'I'
--                                       ,pi_nit_category_restriction     => pi_tab_categories(i)
--                                    ,pi_exclude_off_network          => pi_exclude_off_network));
            
            
      OPEN  l_cur FOR get_ngqt_lov_sql (pi_ngqt_item_type_type          => 'I'
                                       ,pi_nit_category_restriction     => pi_tab_categories(i)
                                    ,pi_exclude_off_network          => pi_exclude_off_network);
      LOOP
         FETCH l_cur INTO l_lup_meaning, l_lup_description, l_lup_value;
         EXIT WHEN l_cur%NOTFOUND;
   l_rec_ngqt.ngqt_ngq_id         := pi_ngq_id;
         l_rec_ngqt.ngqt_seq_no         := nm3seq.next_ngqt_seq_no_seq;
         l_rec_ngqt.ngqt_item_type_type := 'I';  -- always 'I' for some reason and not the actual inv category type
         l_rec_ngqt.ngqt_item_type      := l_lup_value;
--         nm3debug.debug_ngqt(l_rec_ngqt);
         nm3ins.ins_ngqt (l_rec_ngqt);
      END LOOP;
      CLOSE l_cur;
     END IF;   
   END LOOP;

END add_inv_types_for_categories;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_all_possible_types_to_ngq (pi_ngq_id nm_gaz_query.ngq_id%TYPE) IS

   l_cur                 nm3type.ref_cursor;
   l_tab_item_type_types nm3type.tab_varchar4;
   l_lup_meaning         nm3type.max_varchar2;
   l_lup_description     nm3type.max_varchar2;
   l_lup_value           nm3type.max_varchar2;   

BEGIN
--
   nm_debug.proc_start(g_package_name,'add_all_possible_types_to_ngq');
--
   OPEN  l_cur FOR get_ngqt_item_type_type_lov_sq;
   LOOP
      FETCH l_cur INTO l_lup_meaning, l_lup_description, l_lup_value;
      EXIT WHEN l_cur%NOTFOUND;
      l_tab_item_type_types (l_tab_item_type_types.COUNT+1) := l_lup_value;
   END LOOP;
   CLOSE l_cur;
   
   add_inv_types_for_categories(pi_ngq_id            => pi_ngq_id
                               ,pi_tab_categories    => l_tab_item_type_types);
   
--
   nm_debug.proc_end(g_package_name,'add_all_possible_types_to_ngq');
--
END add_all_possible_types_to_ngq;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_tab_rec_gaz_restriction (pi_nt_type                 IN OUT nm_types.nt_type%TYPE
                                      ,pi_ngt_group_type          IN     nm_group_types.ngt_group_type%TYPE DEFAULT NULL
                                      ,po_tab_rec_gaz_restriction IN OUT tab_rec_gaz_restriction
                                      ) IS
--
   l_rec_gaz_restriction rec_gaz_restriction;
--
   l_rec_nt              nm_types%ROWTYPE;
   l_rec_ngt             nm_group_types%ROWTYPE;
--
   l_cur                 nm3type.ref_cursor;
--
   l_lup_meaning         nm3type.max_varchar2;
   l_lup_descr           nm3type.max_varchar2;
   l_lup_value           varchar2(30);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_rec_gaz_restriction');
--
   po_tab_rec_gaz_restriction.DELETE;
--
   IF   pi_nt_type        IS NULL
    AND pi_ngt_group_type IS NULL
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 340
                    );
   END IF;
--
   IF pi_ngt_group_type IS NOT NULL
    THEN
      l_rec_ngt        := nm3get.get_ngt (pi_ngt_group_type => pi_ngt_group_type);
   END IF;
--
   l_rec_nt.nt_type := NVL(pi_nt_type,l_rec_ngt.ngt_nt_type);
--
   IF l_rec_nt.nt_type != l_rec_ngt.ngt_nt_type
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 341
                    );
   END IF;
--
   l_rec_nt := nm3get.get_nt (pi_nt_type => l_rec_nt.nt_type);
--
   l_rec_gaz_restriction.nt_type        := l_rec_nt.nt_type;
   l_rec_gaz_restriction.ngt_group_type := pi_ngt_group_type;
--
   OPEN l_cur FOR get_ngqa_lov_sql_ele (l_rec_nt.nt_type);
   LOOP
      --
      FETCH l_cur INTO l_lup_meaning,l_lup_descr,l_lup_value;
      EXIT WHEN l_cur%NOTFOUND;
      --
      l_rec_gaz_restriction.ntc_column_name := l_lup_value;
      l_rec_gaz_restriction.ntc_prompt      := l_lup_meaning;
      l_rec_gaz_restriction.ntc_lov_sql     := get_ngqv_lov_sql_ele (pi_ngqt_item_type   => l_rec_nt.nt_type
                                                                    ,pi_ngqa_attrib_name => l_rec_gaz_restriction.ntc_column_name
                                                                    );
      --
      po_tab_rec_gaz_restriction(po_tab_rec_gaz_restriction.COUNT+1) := l_rec_gaz_restriction;
--      nm_debug.debug(po_tab_rec_gaz_restriction.COUNT);
--      nm_debug.debug('ntc_column_name : '||l_rec_gaz_restriction.ntc_column_name);
--      nm_debug.debug('ntc_prompt      : '||l_rec_gaz_restriction.ntc_prompt);
--      nm_debug.debug('ntc_lov_sql     : '||l_rec_gaz_restriction.ntc_lov_sql);
      --
   END LOOP;
   CLOSE l_cur;
--
   pi_nt_type := l_rec_nt.nt_type;
--
   nm_debug.proc_end(g_package_name,'get_tab_rec_gaz_restriction');
--
END get_tab_rec_gaz_restriction;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pre_qry_sql_gaz_restrict (pi_nt_type                 IN     nm_types.nt_type%TYPE
                                      ,pi_ngt_group_type          IN     nm_group_types.ngt_group_type%TYPE DEFAULT NULL
                                      ,pi_tab_column              IN     nm3type.tab_varchar30
                                      ,pi_tab_value               IN     nm3type.tab_varchar32767
                                      ) RETURN varchar2 IS
--
   l_pre_query_sql   nm3type.max_varchar2;
   c_and  CONSTANT   varchar2(5) := ' AND ';
   l_attrib_datatype nm_inv_type_attribs.ita_format%TYPE;
   l_column          varchar2(100);
   l_value           nm3type.max_varchar2;
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      l_pre_query_sql := l_pre_query_sql||p_text;
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_pre_qry_sql_gaz_restrict');
--
   append ('ne_nt_type = '||nm3flx.string(pi_nt_type),FALSE);
--
   IF pi_ngt_group_type IS NOT NULL
    THEN
      append (c_and||'ne_gty_group_type = '||nm3flx.string(pi_ngt_group_type));
   END IF;
--
   FOR i IN 1..pi_tab_column.COUNT
    LOOP
      IF pi_tab_value(i) IS NOT NULL
       THEN
         l_attrib_datatype := get_attrib_datatype (p_ngqt_item_type_type => c_ngqt_item_type_type_ele
                                                  ,p_ngqt_item_type      => pi_nt_type
                                                  ,p_ngqa_attrib_name    => pi_tab_column(i)
                                                  );
         IF l_attrib_datatype = nm3type.c_number
         THEN
           --treat numeric as a string so user can use wildcards for their query
           l_attrib_datatype := nm3type.c_varchar;
         END IF;

         l_column := pi_tab_column(i);
         l_value  := nm3pbi.fn_convert_attrib_value(pi_tab_value(i),l_attrib_datatype);

         IF pi_tab_column(i) IN ('NE_DESCR', 'IIT_DESCR')
         THEN
           --make query case insensitive for descriptions
           l_column := 'Lower(' || l_column || ')';
           l_value  := 'Lower(' || l_value || ')';
         END IF;

         append (c_and || l_column || ' LIKE ' || l_value);
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_pre_qry_sql_gaz_restrict');
--
   RETURN l_pre_query_sql;
--
END get_pre_qry_sql_gaz_restrict;
--
-----------------------------------------------------------------------------
--
PROCEDURE disallow_xsp_on_inv IS
BEGIN
   g_allow_xsp := FALSE;
END disallow_xsp_on_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE allow_xsp_on_inv IS
BEGIN
   g_allow_xsp := TRUE;
END allow_xsp_on_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_rec_selected_item_details
             (po_item_id    OUT NUMBER
             ,po_item_type  OUT VARCHAR2
             ,po_item_pk    OUT VARCHAR2
             ,po_item_descr OUT VARCHAR2)
IS
BEGIN
   po_item_id    := g_rec_selected_item_details.ngqi_item_id;
   po_item_type  := g_rec_selected_item_details.ngqi_item_type;
   po_item_pk    := g_rec_selected_item_details.iit_primary_key;
   po_item_descr := g_rec_selected_item_details.iit_descr;
END get_rec_selected_item_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_inv_type_for_query (pi_inv_type VARCHAR2)
IS
BEGIN
  g_qry_inv_type := pi_inv_type;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_roi_for_query
             ( pi_roi_id   IN  NUMBER
             , pi_roi_type IN  VARCHAR2 DEFAULT 'E')
IS
BEGIN
  g_qry_roi_id := pi_roi_id;
  g_qry_roi_type := pi_roi_type;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE return_roi_for_query
             ( po_roi_id   OUT  NUMBER
             , po_roi_type OUT  VARCHAR2)
IS
BEGIN
  po_roi_id := g_qry_roi_id;
  po_roi_type := g_qry_roi_type;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION return_inv_type_for_query
  RETURN VARCHAR2
IS
BEGIN
  RETURN g_qry_inv_type;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE initialise_ngqt(pi_ngqt_ngq_id IN nm_gaz_query_types.ngqt_ngq_id%TYPE) IS

BEGIN
--
-- clear any types that may already be there
--
   delete from nm_gaz_query_types where ngqt_ngq_id = pi_ngqt_ngq_id;

END initialise_ngqt;
--
-----------------------------------------------------------------------------
-- GJ - to support NM0590
-- check that gaz query attribute restrictions that have been added to a gaz query type
-- are actually valid i.e. they are against columns that exist for the inv type
--
FUNCTION  ngqa_for_nqt_are_valid(pi_ngqt_nqq_id IN nm_gaz_query_types.NGQT_NGQ_ID%TYPE
                                ,pi_nqqt_seq_no IN nm_gaz_query_types.NGQT_SEQ_NO%TYPE
        ,pi_ngqt_item_type IN nm_gaz_query_types.NGQT_ITEM_TYPE%TYPE) RETURN VARCHAR2 IS

 l_sql     varchar2(2000);
 l_meaning          varchar2(2000);
 l_id               varchar2(2000);


BEGIN

  --
  -- grab the sql that lists all attributes for this inv type 
  -- for example...
  -- SELECT lup_meaning, lup_description, lup_value
  --  FROM  (SELECT ita_attrib_name lup_value, ita_view_col_name lup_meaning, ita_scrn_text lup_description, ita_disp_seq_no lup_seq
  --          FROM  nm_inv_type_attribs
  --         WHERE  ita_inv_type = 'LANE'
  --         UNION
  --         SELECT hco_code lup_value, hco_meaning lup_meaning, hco_meaning lup_description, hco_seq lup_seq
  --          FROM  hig_codes
  --         WHERE  hco_domain = 'GAZ_QRY_FIXED_COLS_I'
  -- 
  --        )
  -- ORDER BY lup_seq
  l_sql := nm3gaz_qry.get_ngqa_lov_sql('I',pi_ngqt_item_type);

--
-- loop through all restrictions for inv type
--
 FOR i IN (select * from nm_gaz_query_attribs
           where NGQA_NGQ_ID = pi_ngqt_nqq_id 
     and   ngqa_ngqt_seq_no = pi_nqqt_seq_no) LOOP
     
  --
  -- check that the attribute that we are adding to this ngqa is an attribute in our list
  -- 
   nm3extlov.validate_lov_value (p_statement => l_sql
                                ,p_value     => i.ngqa_attrib_name
                                ,p_meaning   => l_meaning 
                                ,p_id        => l_id
                                ,pi_match_col => 3) ;

 END LOOP;
 
 RETURN('Y');

EXCEPTION
   WHEN others THEN  -- i.e. not found
      RETURN('N');         
 
END ngqa_for_nqt_are_valid;
--
-----------------------------------------------------------------------------
-- GJ - to support NM0590
-- for given query id and type id add a dead simple restriction into the gaz query type
-- i.e. attrib = value
PROCEDURE simple_restriction_to_type (pi_ngq_id       IN nm_gaz_query.ngq_id%TYPE
                                     ,pi_ngqt_seq_no  IN nm_gaz_query_types.ngqt_seq_no%TYPE
                                     ,pi_attrib_name  IN nm_gaz_query_attribs.ngqa_attrib_name%TYPE
             ,pi_value        IN nm_gaz_query_values.ngqv_value%TYPE) IS
         
 l_rec_ngqa nm_gaz_query_attribs%ROWTYPE;
 l_ngqa_seq_no nm_gaz_query_attribs.ngqa_seq_no%TYPE;
 l_condition   nm_gaz_query_attribs.ngqa_condition%TYPE;
 
 l_rec_ngqv        nm_gaz_query_values%ROWTYPE; 
 
 ex_invalid_column  exception;  -- insert into ngqa may be against attrib not on inv type e.g. iit_primary_key not on a ft inv type
 PRAGMA exception_init(ex_invalid_column,-20200);
         
BEGIN

  l_ngqa_seq_no := nm3seq.next_ngqa_seq_no_seq;

  IF INSTR(pi_value,'%') >0 THEN
    l_condition := 'LIKE';
  ELSE
    l_condition := '=';
  END IF;
--   
  l_rec_ngqa.ngqa_ngq_id       := pi_ngq_id;
  l_rec_ngqa.ngqa_ngqt_seq_no  := pi_ngqt_seq_no;
  l_rec_ngqa.ngqa_seq_no       := l_ngqa_seq_no;
  l_rec_ngqa.ngqa_attrib_name  := pi_attrib_name;
  l_rec_ngqa.ngqa_operator     := 'AND';
  l_rec_ngqa.ngqa_pre_bracket  := '(';
  l_rec_ngqa.ngqa_post_bracket := ')';
  l_rec_ngqa.ngqa_condition    := l_condition;
--
  l_rec_ngqv.ngqv_ngq_id       := l_rec_ngqa.ngqa_ngq_id;
  l_rec_ngqv.ngqv_ngqt_seq_no  := l_rec_ngqa.ngqa_ngqt_seq_no;
  l_rec_ngqv.ngqv_ngqa_seq_no  := l_rec_ngqa.ngqa_seq_no;
  l_rec_ngqv.ngqv_sequence     := 1; 
  l_rec_ngqv.ngqv_value        := pi_value;
--
  nm3ins.ins_ngqa(p_rec_ngqa => l_rec_ngqa);
  nm3ins.ins_ngqv(p_rec_ngqv => l_rec_ngqv);
  
EXCEPTION

 WHEN ex_invalid_column THEN
    Null;
 
 WHEN others THEN
   RAISE;
  
END simple_restriction_to_type;         
--
-----------------------------------------------------------------------------
-- GJ - to support NM0590 
-- for given query id add simple restriction against all types in the query
PROCEDURE add_restriction_to_all_types(pi_ngq_id       IN nm_gaz_query.ngq_id%TYPE
                                      ,pi_attrib_name  IN nm_gaz_query_attribs.ngqa_attrib_name%TYPE
                                      ,pi_value        IN nm_gaz_query_values.ngqv_value%TYPE) IS


BEGIN

 FOR i IN (SELECT ngqt_seq_no from nm_gaz_query_types WHERE ngqt_ngq_id = pi_ngq_id) LOOP
    simple_restriction_to_type (pi_ngq_id       => pi_ngq_id
                               ,pi_ngqt_seq_no  => i.ngqt_seq_no
                               ,pi_attrib_name  => pi_attrib_name
                ,pi_value        => pi_value);
 END LOOP;

END add_restriction_to_all_types;
--
-----------------------------------------------------------------------------
-- GJ - to support NM0590
-- go through all inv types for the gaz query and if there are restrictions
-- in place that are on attributes that do not exist for the inv type
-- remove the inv type from the query
PROCEDURE del_types_with_invalid_restr(pi_ngqt_ngq_id       IN nm_gaz_query_types.ngqt_ngq_id%TYPE) IS

BEGIN

 delete from nm_gaz_query_types
 where ngqt_ngq_id = pi_ngqt_ngq_id
 and   ngqa_for_nqt_are_valid(ngqt_ngq_id, ngqt_seq_no, ngqt_item_type) = 'N';
 
END del_types_with_invalid_restr;
--
-----------------------------------------------------------------------------
--
--
PROCEDURE set_ngq_source_etc(pi_ne_id         IN  nm_elements_all.ne_id%TYPE
                            ,po_ngq_source_id OUT nm_gaz_query.ngq_source_id%TYPE
                            ,po_ngq_source    OUT nm_gaz_query.ngq_source%TYPE
                            ,po_ngq_query_all_items OUT nm_gaz_query.ngq_query_all_items%TYPE) IS

BEGIN

  IF pi_ne_id IS NULL THEN
    po_ngq_source_id            := -1;
    po_ngq_source               := nm3extent.get_temp_ne;  -- "TEMP_NE"
    po_ngq_query_all_items      := 'Y';
  ELSE
    po_ngq_source_id           := pi_ne_id;
    po_ngq_query_all_items      := 'N';            
    IF nm3get.get_ne_all(pi_ne_id => pi_ne_id).ne_type = nm3extent.get_c_roi_extent
      THEN
        po_ngq_source              := nm3extent.get_saved;  -- "SAVED"
      ELSE
        po_ngq_source               := nm3extent.get_route;  -- "ROUTE"
    END IF;
    
  END IF;            

END set_ngq_source_etc;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_ignore_case(p_value  IN  BOOLEAN) IS
BEGIN
   g_ignore_case := p_value;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ignore_case 
RETURN BOOLEAN IS
BEGIN
   RETURN g_ignore_case;
END;
--
-----------------------------------------------------------------------------
--
END nm3gaz_qry;
/
