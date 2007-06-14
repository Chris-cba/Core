CREATE OR REPLACE PACKAGE BODY nm3eng_dynseg AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3eng_dynseg.pkb	1.13 06/27/06
--       Module Name      : nm3eng_dynseg.pkb
--       Date into SCCS   : 06/06/27 11:43:29
--       Date fetched Out : 07/06/13 14:11:24
--       SCCS Version     : 1.13
--
--
--   Author : Jonathan Mills
--
--   Engineering Dynamic Segmentation package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3eng_dynseg.pkb	1.13 06/27/06"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3eng_dynseg';
--
   g_sql      VARCHAR2(32767);
--
   g_eng_dynseg_exception EXCEPTION;
   g_eng_dynseg_exc_code  NUMBER;
   g_eng_dynseg_exc_msg   VARCHAR2(4000);
--
   g_nms_mrg_job_id nm_mrg_sections.nms_mrg_job_id%TYPE;
   g_nms_section_id nm_mrg_sections.nms_mrg_section_id%TYPE;
   g_nte_job_id     nm_nw_temp_extents.nte_job_id%TYPE;
   g_inv_type       nm_inv_items.iit_inv_type%TYPE;
   g_view_col       nm_inv_type_attribs.ita_view_col_name%TYPE;
   g_xsp            nm_inv_items.iit_x_sect%TYPE;
   --
   g_stat_array     nm_statistic_array;
   g_val_dist_arr   nm_value_distribution_array;
   --
   g_merge_run      BOOLEAN := TRUE;
   g_temp_ne_run    BOOLEAN := FALSE;
   --
   g_stats_run      BOOLEAN := TRUE;
   g_bins_run       BOOLEAN := FALSE;
   --
   g_field_is_number BOOLEAN;
   --
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_stats_arrays (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE     DEFAULT NULL
                                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE DEFAULT NULL
                                ,pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE      DEFAULT NULL
                                ,pi_inv_type         IN VARCHAR2
                                ,pi_xsp              IN VARCHAR2
                                ,pi_view_col         IN VARCHAR2
                                );
--
-----------------------------------------------------------------------------
--
PROCEDURE build_sql (pi_inv_type   IN     VARCHAR2
                    ,pi_xsp        IN     VARCHAR2
                    ,pi_view_col   IN     VARCHAR2
                    ,pi_wrap_nvl   IN     BOOLEAN DEFAULT FALSE
                    ,pi_allow_null IN     BOOLEAN DEFAULT TRUE
                    ,po_dec_places    OUT NUMBER
                    );
--
-----------------------------------------------------------------------------
--
PROCEDURE fetch_sql (pi_nms_mrg_job_id IN nm_mrg_sections.nms_mrg_job_id%TYPE     DEFAULT NULL
                    ,pi_nms_section_id IN nm_mrg_sections.nms_mrg_section_id%TYPE DEFAULT NULL
                    ,pi_nte_job_id     IN nm_nw_temp_extents.nte_job_id%TYPE      DEFAULT NULL
                    ,pi_inv_type         IN VARCHAR2
                    ,pi_xsp              IN VARCHAR2
                    );
--
-----------------------------------------------------------------------------
--
PROCEDURE running_for_merge;
--
-----------------------------------------------------------------------------
--
PROCEDURE running_for_temp_ne;
--
-----------------------------------------------------------------------------
--
PROCEDURE running_stats;
--
-----------------------------------------------------------------------------
--
PROCEDURE running_bins;
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
FUNCTION initialise_val_dist_array RETURN nm_value_distribution_array IS
BEGIN
   RETURN nm_value_distribution_array(nm_value_distribution_arr_type(nm_value_distribution(null,null,null,null))
                                     ,Null
                                     ,Null
                                     ,Null
                                     ,Null
                                     ,Null
                                     ,Null
                                     ,Null
                                     );
END initialise_val_dist_array;
--
------------------------------------------------------------------------------------------------
--
FUNCTION produce_html_table (p_val_dist_arr nm_value_distribution_array) RETURN nm3type.tab_varchar32767 IS
--
   l_retval nm3type.tab_varchar32767;
   l_ind    NUMBER := 1;
   l_val_dist   nm_value_distribution;
--
   c_nbsp   CONSTANT VARCHAR2(6) := CHR(38)||'nbsp;';
--
   PROCEDURE append (p_text VARCHAR2) IS
   BEGIN
      IF length (p_text) + LENGTH(l_retval(l_ind)) > 32767
       THEN
         l_ind           := l_ind + 1;
         l_retval(l_ind) := Null;
      END IF;
      l_retval(l_ind) := l_retval(l_ind)||p_text;
   END append;
--
BEGIN
--
   l_retval(1) := Null;
   IF p_val_dist_arr.is_empty
    THEN
      append ('No Values');
   ELSE
      append ('<TABLE BORDER=1><TR><TH>Value</TH><TH>Length</TH><TH COLSPAN=2>Count</TH><TH COLSPAN=2>% Total Len</TH></TR>');
      FOR i IN 1..p_val_dist_arr.value_dist_count
       LOOP
         l_val_dist := p_val_dist_arr.get_entry(i);
         append (CHR(10)||'<TR>');
         append ('<TD>'||NVL(l_val_dist.nvd_value,'##Null##')||'</TD>');
         append ('<TD>'||l_val_dist.nvd_length||'</TD>');
         append ('<TD>'||l_val_dist.nvd_item_count||'</TD><TD>');
         IF l_val_dist.nvd_item_count = p_val_dist_arr.nvda_most_numerous_amount
          THEN
            append('*');
         ELSE
            append(c_nbsp);
         END IF;
         append ('</TD><TD>'||l_val_dist.nvd_pct_total_length||'</TD><TD>');
         IF l_val_dist.nvd_pct_total_length = p_val_dist_arr.nvda_highest_pct_amount
          THEN
            append('*');
         ELSE
            append(c_nbsp);
         END IF;
         append('</TD></TR>');
      END LOOP;
      append ('</TABLE>');
   END IF;
--
   RETURN l_retval;
--
END produce_html_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_stats_arrays (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE     DEFAULT NULL
                                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE DEFAULT NULL
                                ,pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE      DEFAULT NULL
                                ,pi_inv_type         IN VARCHAR2
                                ,pi_xsp              IN VARCHAR2
                                ,pi_view_col         IN VARCHAR2
                                ) IS
--
   l_dec_places NUMBER;
--
   l_change_reqd BOOLEAN;
--
BEGIN
--
--   nm_debug.debug('populate_stats_arrays 1');
--
   IF g_merge_run
    THEN
      IF   NVL(g_nms_mrg_job_id,-1)      = pi_nms_mrg_job_id
       AND NVL(g_nms_section_id,-1)      = pi_nms_section_id
       AND NVL(g_inv_type,nm3type.c_nvl) = pi_inv_type
       AND NVL(g_xsp,nm3type.c_nvl)      = NVL(pi_xsp,nm3type.c_nvl)
       AND NVL(g_view_col,nm3type.c_nvl) = pi_view_col
       THEN
         l_change_reqd := FALSE;
      ELSE
         l_change_reqd := TRUE;
      END IF;
   ELSIF g_temp_ne_run
    THEN
      IF   NVL(g_nte_job_id,-1)          = NVL(pi_nte_job_id,-1)
       AND NVL(g_inv_type,nm3type.c_nvl) = pi_inv_type
       AND NVL(g_xsp,nm3type.c_nvl)      = NVL(pi_xsp,nm3type.c_nvl)
       AND NVL(g_view_col,nm3type.c_nvl) = pi_view_col
       THEN
         l_change_reqd := FALSE;
      ELSE
         l_change_reqd := TRUE;
      END IF;
   END IF;
--
      Null; -- Everything is the same, so leave it!
--   nm_debug.debug('populate_stats_arrays 2');
   IF l_change_reqd
    THEN
--
--   nm_debug.debug('populate_stats_arrays 3');
      build_sql (pi_inv_type   => pi_inv_type
                ,pi_xsp        => pi_xsp
                ,pi_view_col   => pi_view_col
                ,po_dec_places => l_dec_places
                );
--
--   nm_debug.debug('populate_stats_arrays 4');
      fetch_sql (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                ,pi_nms_section_id => pi_nms_section_id
                ,pi_nte_job_id     => pi_nte_job_id
                ,pi_inv_type       => pi_inv_type
                ,pi_xsp            => pi_xsp
                );
--   nm_debug.debug('populate_stats_arrays 5');
--
      g_nms_mrg_job_id := pi_nms_mrg_job_id;
      g_nms_section_id := pi_nms_section_id;
      g_nte_job_id     := pi_nte_job_id;
      g_inv_type       := pi_inv_type;
      g_xsp            := pi_xsp;
      g_view_col       := pi_view_col;
      --
      -- Compute the statistics
      --
      g_stat_array   := g_stat_array.compute_stats (l_dec_places);
      g_val_dist_arr := g_val_dist_arr.compute_stats (2);
--
--      nm_debug.delete_debug(TRUE);
--      nm_debug.debug_on;
--      nm_debug.debug('NSA_SUM_X              : '||g_stat_array.NSA_SUM_X              ,-1);
--      nm_debug.debug('NSA_SUM_Y              : '||g_stat_array.NSA_SUM_Y              ,-1);
--      nm_debug.debug('NSA_MIN_X              : '||g_stat_array.NSA_MIN_X              ,-1);
--      nm_debug.debug('NSA_MIN_Y              : '||              g_stat_array.NSA_MIN_Y              ,-1);
--      nm_debug.debug('NSA_MAX_X              : '||              g_stat_array.NSA_MAX_X              ,-1);
--      nm_debug.debug('NSA_MAX_Y              : '||              g_stat_array.NSA_MAX_Y              ,-1);
--      nm_debug.debug('NSA_FIRST_X            : '||            g_stat_array.NSA_FIRST_X            ,-1);
--      nm_debug.debug('NSA_FIRST_Y            : '||            g_stat_array.NSA_FIRST_Y            ,-1);
--      nm_debug.debug('NSA_LAST_X             : '||             g_stat_array.NSA_LAST_X             ,-1);
--      nm_debug.debug('NSA_LAST_Y             : '||             g_stat_array.NSA_LAST_Y             ,-1);
--      nm_debug.debug('NSA_Y_WEIGHTED_AVE_X   : '||   g_stat_array.NSA_Y_WEIGHTED_AVE_X   ,-1);
--      nm_debug.debug('NSA_X_WEIGHTED_AVE_Y   : '||   g_stat_array.NSA_X_WEIGHTED_AVE_Y   ,-1);
--      nm_debug.debug('NSA_SUM_XY_PRODUCT     : '||     g_stat_array.NSA_SUM_XY_PRODUCT     ,-1);
--      nm_debug.debug('NSA_MAX_DEC_PLACES_X   : '||   g_stat_array.NSA_MAX_DEC_PLACES_X   ,-1);
--      nm_debug.debug('NSA_MAX_DEC_PLACES_Y   : '||   g_stat_array.NSA_MAX_DEC_PLACES_Y   ,-1);
--      nm_debug.debug_off;
--
   END IF;
--
END populate_stats_arrays;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                               ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                               ,pi_inv_type         IN VARCHAR2
                               ,pi_view_col         IN VARCHAR2
                               ) RETURN VARCHAR2 IS
BEGIN
   RETURN get_most_common_value (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                                ,pi_nms_section_id => pi_nms_section_id
                                ,pi_inv_type       => pi_inv_type
                                ,pi_xsp            => Null
                                ,pi_view_col       => pi_view_col
                                );
END get_most_common_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                               ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                               ,pi_inv_type         IN VARCHAR2
                               ,pi_xsp              IN VARCHAR2
                               ,pi_view_col         IN VARCHAR2
                               ) RETURN VARCHAR2 IS
--
BEGIN
--
   running_for_merge;
   running_bins;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.nvda_highest_pct;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_common_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                               ,pi_inv_type         IN VARCHAR2
                               ,pi_xsp              IN VARCHAR2
                               ,pi_view_col         IN VARCHAR2
                               ) RETURN VARCHAR2 is
BEGIN
--
   running_for_temp_ne;
   running_bins;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.nvda_highest_pct;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_common_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                               ,pi_inv_type         IN VARCHAR2
                               ,pi_view_col         IN VARCHAR2
                               ) RETURN VARCHAR2 IS
BEGIN
   RETURN get_most_common_value (pi_nte_job_id => pi_nte_job_id
                                ,pi_inv_type   => pi_inv_type
                                ,pi_xsp        => Null
                                ,pi_view_col   => pi_view_col
                                );
END get_most_common_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_maximum_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                           ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
   RETURN get_maximum_value (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                            ,pi_nms_section_id => pi_nms_section_id
                            ,pi_inv_type       => pi_inv_type
                            ,pi_xsp            => Null
                            ,pi_view_col       => pi_view_col
                            );
END get_maximum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_maximum_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                           ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_xsp              IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                                 ,pi_nms_section_id => pi_nms_section_id
                                 ,pi_inv_type       => pi_inv_type
                                 ,pi_xsp            => pi_xsp
                                 ,pi_view_col       => pi_view_col
                                 );
--
   RETURN  g_stat_array.nsa_max_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_maximum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_maximum_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_xsp              IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER is
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_max_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_maximum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_maximum_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
   RETURN get_maximum_value (pi_nte_job_id => pi_nte_job_id
                            ,pi_inv_type   => pi_inv_type
                            ,pi_xsp        => Null
                            ,pi_view_col   => pi_view_col
                            );
END get_maximum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_minimum_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                           ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
   RETURN get_minimum_value (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                            ,pi_nms_section_id => pi_nms_section_id
                            ,pi_inv_type       => pi_inv_type
                            ,pi_xsp            => Null
                            ,pi_view_col       => pi_view_col
                            );
END get_minimum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_minimum_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                           ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_xsp              IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_min_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_minimum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_minimum_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_xsp              IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER is
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_min_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_minimum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_minimum_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
   RETURN get_minimum_value (pi_nte_job_id => pi_nte_job_id
                            ,pi_inv_type   => pi_inv_type
                            ,pi_xsp        => Null
                            ,pi_view_col   => pi_view_col
                            );
END get_minimum_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_length_weighted_ave (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                                 ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                                 ,pi_inv_type         IN VARCHAR2
                                 ,pi_view_col         IN VARCHAR2
                                 ) RETURN NUMBER IS
BEGIN
   RETURN get_length_weighted_ave (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                                  ,pi_nms_section_id => pi_nms_section_id
                                  ,pi_inv_type       => pi_inv_type
                                  ,pi_xsp            => Null
                                  ,pi_view_col       => pi_view_col
                                  );
END get_length_weighted_ave;
--
-----------------------------------------------------------------------------
--
FUNCTION get_length_weighted_ave (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                                 ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                                 ,pi_inv_type         IN VARCHAR2
                                 ,pi_xsp              IN VARCHAR2
                                 ,pi_view_col         IN VARCHAR2
                                 ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_y_weighted_ave_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_length_weighted_ave;
--
-----------------------------------------------------------------------------
--
FUNCTION get_length_weighted_ave (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                                 ,pi_inv_type         IN VARCHAR2
                                 ,pi_xsp              IN VARCHAR2
                                 ,pi_view_col         IN VARCHAR2
                                 ) RETURN NUMBER is
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_y_weighted_ave_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_length_weighted_ave;
--
-----------------------------------------------------------------------------
--
FUNCTION get_length_weighted_ave (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                                 ,pi_inv_type         IN VARCHAR2
                                 ,pi_view_col         IN VARCHAR2
                                 ) RETURN NUMBER IS
BEGIN
   RETURN get_length_weighted_ave (pi_nte_job_id => pi_nte_job_id
                                  ,pi_inv_type   => pi_inv_type
                                  ,pi_xsp        => Null
                                  ,pi_view_col   => pi_view_col
                                  );
END get_length_weighted_ave;
--
-----------------------------------------------------------------------------
--
FUNCTION get_median_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                          ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                          ,pi_inv_type         IN VARCHAR2
                          ,pi_view_col         IN VARCHAR2
                          ) RETURN NUMBER IS
BEGIN
   RETURN get_median_value (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                           ,pi_nms_section_id => pi_nms_section_id
                           ,pi_inv_type       => pi_inv_type
                           ,pi_xsp            => Null
                           ,pi_view_col       => pi_view_col
                           );
END get_median_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_median_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                          ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                          ,pi_inv_type         IN VARCHAR2
                          ,pi_xsp              IN VARCHAR2
                          ,pi_view_col         IN VARCHAR2
                          ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_median_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_median_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_median_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                          ,pi_inv_type         IN VARCHAR2
                          ,pi_xsp              IN VARCHAR2
                          ,pi_view_col         IN VARCHAR2
                          ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_median_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_median_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_median_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                          ,pi_inv_type         IN VARCHAR2
                          ,pi_view_col         IN VARCHAR2
                          ) RETURN NUMBER IS
BEGIN
   RETURN get_median_value (pi_nte_job_id => pi_nte_job_id
                           ,pi_inv_type   => pi_inv_type
                           ,pi_xsp        => Null
                           ,pi_view_col   => pi_view_col
                           );
END get_median_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mean_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                        ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                        ,pi_inv_type         IN VARCHAR2
                        ,pi_view_col         IN VARCHAR2
                        ) RETURN NUMBER IS
BEGIN
   RETURN get_mean_value (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => Null
                         ,pi_view_col       => pi_view_col
                         );
END get_mean_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mean_value (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                        ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                        ,pi_inv_type         IN VARCHAR2
                        ,pi_xsp              IN VARCHAR2
                        ,pi_view_col         IN VARCHAR2
                        ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_mean_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_mean_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mean_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                        ,pi_inv_type         IN VARCHAR2
                        ,pi_xsp              IN VARCHAR2
                        ,pi_view_col         IN VARCHAR2
                        ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_mean_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_mean_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mean_value (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                        ,pi_inv_type         IN VARCHAR2
                        ,pi_view_col         IN VARCHAR2
                        ) RETURN NUMBER IS
BEGIN
   RETURN get_mean_value (pi_nte_job_id => pi_nte_job_id
                         ,pi_inv_type   => pi_inv_type
                         ,pi_xsp        => Null
                         ,pi_view_col   => pi_view_col
                         );
END get_mean_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_variance (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                      ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                      ,pi_inv_type         IN VARCHAR2
                      ,pi_view_col         IN VARCHAR2
                      ) RETURN NUMBER IS
BEGIN
   RETURN get_variance (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                       ,pi_nms_section_id => pi_nms_section_id
                       ,pi_inv_type       => pi_inv_type
                       ,pi_xsp            => Null
                       ,pi_view_col       => pi_view_col
                       );
END get_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_variance (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                      ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                      ,pi_inv_type         IN VARCHAR2
                      ,pi_xsp              IN VARCHAR2
                      ,pi_view_col         IN VARCHAR2
                      ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_var_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_variance (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                      ,pi_inv_type         IN VARCHAR2
                      ,pi_xsp              IN VARCHAR2
                      ,pi_view_col         IN VARCHAR2
                      ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_var_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_variance (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                      ,pi_inv_type         IN VARCHAR2
                      ,pi_view_col         IN VARCHAR2
                      ) RETURN NUMBER IS
BEGIN
   RETURN get_variance (pi_nte_job_id => pi_nte_job_id
                       ,pi_inv_type   => pi_inv_type
                       ,pi_xsp        => Null
                       ,pi_view_col   => pi_view_col
                       );
END get_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_standard_deviation (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                                ,pi_inv_type         IN VARCHAR2
                                ,pi_view_col         IN VARCHAR2
                                ) RETURN NUMBER IS
BEGIN
   RETURN get_standard_deviation (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                                 ,pi_nms_section_id => pi_nms_section_id
                                 ,pi_inv_type       => pi_inv_type
                                 ,pi_xsp            => Null
                                 ,pi_view_col       => pi_view_col
                                 );
END get_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_standard_deviation (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                                ,pi_inv_type         IN VARCHAR2
                                ,pi_xsp              IN VARCHAR2
                                ,pi_view_col         IN VARCHAR2
                                ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_sd_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_standard_deviation (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                                ,pi_inv_type         IN VARCHAR2
                                ,pi_xsp              IN VARCHAR2
                                ,pi_view_col         IN VARCHAR2
                                ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_sd_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_standard_deviation (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                                ,pi_inv_type         IN VARCHAR2
                                ,pi_view_col         IN VARCHAR2
                                ) RETURN NUMBER IS
BEGIN
   RETURN get_standard_deviation (pi_nte_job_id => pi_nte_job_id
                                 ,pi_inv_type   => pi_inv_type
                                 ,pi_xsp        => Null
                                 ,pi_view_col   => pi_view_col
                                 );
END get_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_standard_deviation
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_biased_standard_deviation
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_biased_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_standard_deviation
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_biased_sd_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_biased_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_standard_deviation
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_biased_sd_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_biased_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_standard_deviation
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_biased_standard_deviation
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_biased_standard_deviation;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_variance
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_biased_variance
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_biased_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_variance
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_biased_var_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_biased_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_variance
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_biased_var_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_biased_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_biased_variance
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_biased_variance
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_biased_variance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_first_value
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_first_value
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_first_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_first_value
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_first_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_first_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_first_value
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_first_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_first_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_first_value
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_first_value
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_first_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_last_value
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_last_value
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_last_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_last_value
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN g_stat_array.nsa_last_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_last_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_last_value
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_last_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_last_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_last_value
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_last_value
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_last_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN VARCHAR2 IS
BEGIN
   RETURN get_most_frequent_value
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_most_frequent_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN VARCHAR2 IS
BEGIN
--
   running_for_merge;
   running_bins;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.nvda_most_numerous;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_frequent_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN VARCHAR2 IS
BEGIN
--
   running_for_temp_ne;
   running_bins;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.nvda_most_numerous;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_frequent_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN VARCHAR2 IS
BEGIN
   RETURN get_most_frequent_value
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_most_frequent_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value_dets
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
   RETURN get_most_frequent_value_dets
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_most_frequent_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value_dets
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
--
   running_for_merge;
   running_bins;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.get_entry(g_val_dist_arr.nvda_most_numerous_index);
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_frequent_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value_dets
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
--
   running_for_temp_ne;
   running_bins;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.get_entry(g_val_dist_arr.nvda_most_numerous_index);
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_frequent_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_frequent_value_dets
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
   RETURN get_most_frequent_value_dets
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_most_frequent_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value_dets
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
   RETURN get_most_common_value_dets
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_most_common_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value_dets
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
--
   running_for_merge;
   running_bins;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.get_entry(g_val_dist_arr.nvda_highest_pct_index);
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_common_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value_dets
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
--
   running_for_temp_ne;
   running_bins;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr.get_entry(g_val_dist_arr.nvda_highest_pct_index);
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_most_common_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_most_common_value_dets
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution IS
BEGIN
   RETURN get_most_common_value_dets
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_most_common_value_dets;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_distributions
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution_array IS
BEGIN
   RETURN get_value_distributions
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 );
END get_value_distributions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_distributions
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution_array IS
BEGIN
--
   running_for_merge;
   running_bins;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_value_distributions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_distributions
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution_array IS
BEGIN
--
   running_for_temp_ne;
   running_bins;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_val_dist_arr;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_value_distributions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_distributions
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ) RETURN nm_value_distribution_array IS
BEGIN
   RETURN get_value_distributions
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 );
END get_value_distributions;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_existance
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN LEAST(get_value_count
                (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                ,pi_nms_section_id => pi_nms_section_id
                ,pi_inv_type       => pi_inv_type
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ),1);
END get_value_existance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_existance
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN LEAST(get_value_count
                (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                ,pi_nms_section_id => pi_nms_section_id
                ,pi_inv_type       => pi_inv_type
                ,pi_xsp            => pi_xsp
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ),1);
END get_value_existance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_existance
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN LEAST(get_value_count
                (pi_nte_job_id     => pi_nte_job_id
                ,pi_inv_type       => pi_inv_type
                ,pi_xsp            => pi_xsp
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ),1);
END get_value_existance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_existance
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN LEAST(get_value_count
                (pi_nte_job_id     => pi_nte_job_id
                ,pi_inv_type       => pi_inv_type
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ),1);
END get_value_existance;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_count
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_value_count
                 (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                 ,pi_nms_section_id => pi_nms_section_id
                 ,pi_inv_type       => pi_inv_type
                 ,pi_xsp            => Null
                 ,pi_view_col       => pi_view_col
                 ,pi_value          => pi_value
                 );
END get_value_count;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_count
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
--
   l_retval   NUMBER := 0;
   l_val_dist nm_value_distribution;
--
BEGIN
--
   running_for_merge;
   running_bins;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   FOR i IN 1..g_val_dist_arr.value_dist_count
    LOOP
      l_val_dist := g_val_dist_arr.get_entry(i);
      IF  (l_val_dist.nvd_value IS NULL AND pi_value IS NULL)
       OR  l_val_dist.nvd_value = pi_value
       THEN
         l_retval := l_val_dist.nvd_item_count;
         EXIT;
      END IF;
   END LOOP;
--
   RETURN  l_retval;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_value_count;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_count
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
--
   l_retval   NUMBER := 0;
   l_val_dist nm_value_distribution;
--
BEGIN
--
   running_for_temp_ne;
   running_bins;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   FOR i IN 1..g_val_dist_arr.value_dist_count
    LOOP
      l_val_dist := g_val_dist_arr.get_entry(i);
      IF  (l_val_dist.nvd_value IS NULL AND pi_value IS NULL)
       OR  l_val_dist.nvd_value = pi_value
       THEN
         l_retval := l_val_dist.nvd_item_count;
         EXIT;
      END IF;
   END LOOP;
--
   RETURN  l_retval;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_value_count;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value_count
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN NUMBER IS
BEGIN
   RETURN get_value_count
                 (pi_nte_job_id => pi_nte_job_id
                 ,pi_inv_type   => pi_inv_type
                 ,pi_xsp        => Null
                 ,pi_view_col   => pi_view_col
                 ,pi_value      => pi_value
                 );
END get_value_count;
--
-----------------------------------------------------------------------------
--
FUNCTION does_value_exist
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN BOOLEAN IS
BEGIN
   RETURN get_value_count
                (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                ,pi_nms_section_id => pi_nms_section_id
                ,pi_inv_type       => pi_inv_type
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ) > 0;
END does_value_exist;
--
-----------------------------------------------------------------------------
--
FUNCTION does_value_exist
                (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN BOOLEAN IS
BEGIN
   RETURN get_value_count
                (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                ,pi_nms_section_id => pi_nms_section_id
                ,pi_inv_type       => pi_inv_type
                ,pi_xsp            => pi_xsp
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ) > 0;
END does_value_exist;
--
-----------------------------------------------------------------------------
--
FUNCTION does_value_exist
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_xsp              IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN BOOLEAN IS
BEGIN
   RETURN get_value_count
                (pi_nte_job_id     => pi_nte_job_id
                ,pi_inv_type       => pi_inv_type
                ,pi_xsp            => pi_xsp
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ) > 0;
END does_value_exist;
--
-----------------------------------------------------------------------------
--
FUNCTION does_value_exist
                (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                ,pi_inv_type         IN VARCHAR2
                ,pi_view_col         IN VARCHAR2
                ,pi_value            IN VARCHAR2
                ) RETURN BOOLEAN IS
BEGIN
   RETURN get_value_count
                (pi_nte_job_id     => pi_nte_job_id
                ,pi_inv_type       => pi_inv_type
                ,pi_view_col       => pi_view_col
                ,pi_value          => pi_value
                ) > 0;
END does_value_exist;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sum           (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                           ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
   RETURN get_sum           (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                            ,pi_nms_section_id => pi_nms_section_id
                            ,pi_inv_type       => pi_inv_type
                            ,pi_xsp            => Null
                            ,pi_view_col       => pi_view_col
                            );
END get_sum;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sum          
                           (pi_nms_mrg_job_id   IN nm_mrg_sections.nms_mrg_job_id%TYPE
                           ,pi_nms_section_id   IN nm_mrg_sections.nms_mrg_section_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_xsp              IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
--
   running_for_merge;
   running_stats;
--
   populate_stats_arrays (pi_nms_mrg_job_id => pi_nms_mrg_job_id
                         ,pi_nms_section_id => pi_nms_section_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_sum_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_sum;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sum           (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_xsp              IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER is
BEGIN
--
   running_for_temp_ne;
   running_stats;
--
   populate_stats_arrays (pi_nte_job_id     => pi_nte_job_id
                         ,pi_inv_type       => pi_inv_type
                         ,pi_xsp            => pi_xsp
                         ,pi_view_col       => pi_view_col
                         );
--
   RETURN  g_stat_array.nsa_sum_x;
--
EXCEPTION
--
   WHEN g_eng_dynseg_exception
    THEN
      RAISE_APPLICATION_ERROR(g_eng_dynseg_exc_code,g_eng_dynseg_exc_msg);
--
END get_sum;
--
-----------------------------------------------------------------------------
--
FUNCTION get_sum           (pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                           ,pi_inv_type         IN VARCHAR2
                           ,pi_view_col         IN VARCHAR2
                           ) RETURN NUMBER IS
BEGIN
   RETURN get_sum           (pi_nte_job_id => pi_nte_job_id
                            ,pi_inv_type   => pi_inv_type
                            ,pi_xsp        => Null
                            ,pi_view_col   => pi_view_col
                            );
END get_sum;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_sql (pi_inv_type   IN     VARCHAR2
                    ,pi_xsp        IN     VARCHAR2
                    ,pi_view_col   IN     VARCHAR2
                    ,pi_wrap_nvl   IN     BOOLEAN DEFAULT FALSE
                    ,pi_allow_null IN     BOOLEAN DEFAULT TRUE
                    ,po_dec_places    OUT NUMBER
                    ) IS
--
   l_rec_nit  nm_inv_types%ROWTYPE;
   l_rec_ita  nm_inv_type_attribs%ROWTYPE;
--
   l_nvl_before VARCHAR2(4);
   l_nvl_after  VARCHAR2(4);
--
   l_col_name   user_tab_columns.column_name%TYPE;
--
   l_table_name   user_tab_columns.table_name%TYPE;
   l_ne_id_col    user_tab_columns.column_name%TYPE;
   l_begin_mp_col user_tab_columns.column_name%TYPE;
   l_end_mp_col   user_tab_columns.column_name%TYPE;
--
BEGIN
--
   IF g_merge_run
    THEN
      l_table_name   := 'nm_mrg_section_members';
      l_ne_id_col    := 'nsm_ne_id';
      l_begin_mp_col := 'nsm_begin_mp';
      l_end_mp_col   := 'nsm_end_mp';
   ELSIF g_temp_ne_run
    THEN
      l_table_name   := 'nm_nw_temp_extents';
      l_ne_id_col    := 'nte_ne_id_of';
      l_begin_mp_col := 'nte_begin_mp';
      l_end_mp_col   := 'nte_end_mp';
   END IF;
--
   l_rec_nit := nm3inv.get_inv_type (pi_inv_type);
   l_rec_ita := nm3inv.get_ita_by_view_col (pi_inv_type,pi_view_col);
--
   g_field_is_number := (l_rec_ita.ita_format = 'NUMBER');
--
   IF NOT g_field_is_number
    AND g_stats_run
    THEN
      g_eng_dynseg_exc_code  := -20776;
      g_eng_dynseg_exc_msg   := 'Statistical Averages can only be calculated on numeric fields';
      RAISE g_eng_dynseg_exception;
   ELSIF l_rec_nit.nit_x_sect_allow_flag = 'Y'
    AND  pi_xsp IS NULL
    THEN
      g_eng_dynseg_exc_code  := -20778;
      g_eng_dynseg_exc_msg   := 'XSP must be specified when XSP allowed on inv_type';
      RAISE g_eng_dynseg_exception;
   ELSIF l_rec_nit.nit_x_sect_allow_flag != 'Y'
    AND  pi_xsp IS NOT NULL
    THEN
      g_eng_dynseg_exc_code  := -20779;
      g_eng_dynseg_exc_msg   := 'XSP must not be specified when XSP not allowed on inv_type';
      RAISE g_eng_dynseg_exception;
   ELSIF l_rec_nit.nit_table_name IS NOT NULL
    AND  pi_xsp IS NOT NULL
    THEN
      g_eng_dynseg_exc_code  := -20780;
      g_eng_dynseg_exc_msg   := 'XSP must not be specified when inv_type uses a foreign table';
      RAISE g_eng_dynseg_exception;
   END IF;
--
   IF pi_wrap_nvl
    THEN
      l_nvl_before := 'NVL(';
      IF g_field_is_number
       THEN
         l_nvl_after  := ',0)';
      ELSIF l_rec_ita.ita_format = 'DATE'
       THEN
         l_nvl_after  := ',TO_DATE('||nm3flx.string('01011901')||','||nm3flx.string('DDMMYYYY')||'))';
      ELSE
         l_nvl_after  := ','||nm3flx.string('#Null#')||')';
      END IF;
   END IF;
--
   l_col_name    := l_rec_ita.ita_attrib_name;
   po_dec_places := l_rec_ita.ita_dec_places;
--
   IF l_rec_nit.nit_table_name IS NULL
    THEN
      g_sql :=           'SELECT iit_ne_id'
              ||CHR(10)||'      ,'||l_nvl_before||'iit.'||l_col_name||l_nvl_after||' '||l_rec_ita.ita_view_col_name
              ||CHR(10)||'      ,GREATEST(nm.nm_begin_mp,nsm.'||l_begin_mp_col||') nm_begin_mp'
              ||CHR(10)||'      ,LEAST(nm.nm_end_mp,nsm.'||l_end_mp_col||') nm_end_mp'
              ||CHR(10)||'      ,nm.nm_cardinality'
              ||CHR(10)||' FROM  '||l_table_name||' nsm'
              ||CHR(10)||'      ,nm_inv_items           iit'
              ||CHR(10)||'      ,nm_members             nm';
      IF g_merge_run
       THEN
         g_sql := g_sql
              ||CHR(10)||'WHERE  nsm.nsm_mrg_job_id     = :mrg_job_id'
              ||CHR(10)||' AND   nsm.nsm_mrg_section_id = :mrg_section_id';
      ELSIF g_temp_ne_run
       THEN
         g_sql := g_sql
              ||CHR(10)||'WHERE  nsm.nte_job_id         = :nte_job_id';
      END IF;
      g_sql := g_sql
              ||CHR(10)||' AND   nsm.'||l_ne_id_col||'          = nm.nm_ne_id_of'
              ||CHR(10)||' AND   nm.nm_end_mp          > nsm.'||l_begin_mp_col
              ||CHR(10)||' AND   nm.nm_begin_mp        <= nsm.'||l_end_mp_col
              ||CHR(10)||' AND   nm.nm_ne_id_in         = iit.iit_ne_id'
              ||CHR(10)||' AND   nm.nm_type             = '||nm3flx.string('I')
              ||CHR(10)||' AND   nm.nm_obj_type         = :inv_type';
      IF pi_xsp IS NOT NULL
       THEN
         g_sql := g_sql
              ||CHR(10)||' AND   iit.iit_x_sect         = :xsp';
      ELSE
         g_sql := g_sql
              ||CHR(10)||' AND   :xsp IS NULL';
      END IF;
   ELSE
      g_sql :=           'SELECT TRUNC('||l_rec_nit.nit_foreign_pk_column||') '||l_rec_nit.nit_foreign_pk_column
              ||CHR(10)||'      ,'||l_nvl_before||'ft.'||l_col_name||l_nvl_after||' '||l_rec_ita.ita_view_col_name
              ||CHR(10)||'      ,GREATEST(ft.'||l_rec_nit.nit_lr_st_chain||',nsm.'||l_begin_mp_col||') nm_begin_mp'
              ||CHR(10)||'      ,LEAST(ft.'||l_rec_nit.nit_lr_end_chain||',nsm.'||l_end_mp_col||') nm_end_mp'
              ||CHR(10)||'      ,1 nm_cardinality'
              ||CHR(10)||' FROM  '||l_table_name||' nsm'
              ||CHR(10)||'      ,'||l_rec_nit.nit_table_name||' ft';
      IF g_merge_run
       THEN
         g_sql := g_sql
              ||CHR(10)||'WHERE  nsm.nsm_mrg_job_id     = :mrg_job_id'
              ||CHR(10)||' AND   nsm.nsm_mrg_section_id = :mrg_section_id';
      ELSIF g_temp_ne_run
       THEN
         g_sql := g_sql
              ||CHR(10)||'WHERE  nsm.nte_job_id         = :nte_job_id';
      END IF;
      g_sql := g_sql
              ||CHR(10)||' AND   nsm.'||l_ne_id_col||'          = ft.'||l_rec_nit.nit_lr_ne_column_name
              ||CHR(10)||' AND   ft.'||l_rec_nit.nit_lr_end_chain||' > nsm.'||l_begin_mp_col
              ||CHR(10)||' AND   ft.'||l_rec_nit.nit_lr_st_chain||' <= nsm.'||l_end_mp_col
              ||CHR(10)||' AND   :inv_type IS NOT NULL'
              ||CHR(10)||' AND   :xsp      IS NULL';
   END IF;
--
   IF NOT pi_allow_null
    THEN
      g_sql := g_sql
              ||CHR(10)||' AND   '||l_col_name||' IS NOT NULL';
   END IF;
   --
   IF g_merge_run
    THEN
      g_sql := g_sql
               ||CHR(10)||' ORDER BY nsm_mrg_section_id, nsm_measure';
   ELSE
      g_sql := g_sql
               ||CHR(10)||' ORDER BY nte_seq_no';
   END IF;
--   nm_debug.debug(g_sql);
   --
--
END build_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE fetch_sql (pi_nms_mrg_job_id IN nm_mrg_sections.nms_mrg_job_id%TYPE     DEFAULT NULL
                    ,pi_nms_section_id IN nm_mrg_sections.nms_mrg_section_id%TYPE DEFAULT NULL
                    ,pi_nte_job_id     IN nm_nw_temp_extents.nte_job_id%TYPE      DEFAULT NULL
                    ,pi_inv_type       IN VARCHAR2
                    ,pi_xsp            IN VARCHAR2
                    ) IS
--
   l_pk          NUMBER;
   l_value       VARCHAR2(4000);
   l_begin_mp    NUMBER;
   l_end_mp      NUMBER;
   l_cardinality NUMBER;
   l_length      NUMBER;
--
   l_tab_length  nm3type.tab_number;
   l_tab_value   nm3type.tab_varchar32767;
   l_ind         PLS_INTEGER;
--
   l_cur      nm3type.ref_cursor;
--
BEGIN
--
--   nm_debug.debug('######## '||pi_nms_mrg_job_id||':'||pi_nms_section_id,-1);
--
   g_stat_array   := nm3stats.initialise_statistic_array;
   g_val_dist_arr := initialise_val_dist_array;
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm_debug.debug(g_sql);
--   nm_debug.debug(pi_nms_mrg_job_id||':'||pi_nms_section_id||':'||pi_inv_type||':'||pi_xsp);
--   nm_debug.debug_off;
--
   IF g_merge_run
    THEN
      OPEN  l_cur FOR g_sql USING pi_nms_mrg_job_id,pi_nms_section_id,pi_inv_type,pi_xsp;
   ELSIF g_temp_ne_run
    THEN
      OPEN  l_cur FOR g_sql USING pi_nte_job_id,pi_inv_type,pi_xsp;
   END IF;
      --
   LOOP
      --
      FETCH l_cur INTO l_pk, l_value,l_begin_mp,l_end_mp,l_cardinality;
      --
      EXIT WHEN l_cur%NOTFOUND;
      --
      l_length := (l_end_mp-l_begin_mp)*l_cardinality;
      --
      --IF g_field_is_number
       --THEN
         --g_stat_array   := g_stat_array.add_statistic (l_value,l_length);
      --END IF;
      --
      IF l_tab_length.EXISTS(l_pk)
       THEN
         l_tab_length(l_pk) := l_tab_length(l_pk) + l_length;
         IF g_field_is_number
          THEN
            g_stat_array    := g_stat_array.amend_statistic_y_by_x (p_x        => l_value
                                                                   ,p_y_to_add => l_length
                                                                   );
         END IF;
      ELSE
         IF g_field_is_number
          THEN
            g_stat_array    := g_stat_array.add_statistic (l_value,l_length);
         END IF;
         l_tab_value(l_pk)  := l_value;
         l_tab_length(l_pk) := l_length;
      END IF;
      --
--      nm_debug.debug(g_stat_array.statistic_count||'. x='||l_value||',y='||(l_end_mp-l_begin_mp)*l_cardinality,-1);
      --
   END LOOP;
      --
   CLOSE l_cur;
--
   l_ind := l_tab_value.FIRST;
--
   WHILE l_ind IS NOT NULL
    LOOP
      g_val_dist_arr := g_val_dist_arr.add_value (l_tab_value(l_ind),l_tab_length(l_ind));
      l_ind          := l_tab_value.NEXT(l_ind);
   END LOOP;
--
--      nm_debug.debug_off;
--
END fetch_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE running_for_merge IS
BEGIN
   g_merge_run   := TRUE;
   g_temp_ne_run := FALSE;
END running_for_merge;
--
-----------------------------------------------------------------------------
--
PROCEDURE running_for_temp_ne IS
BEGIN
   g_merge_run   := FALSE;
   g_temp_ne_run := TRUE;
END running_for_temp_ne;
--
-----------------------------------------------------------------------------
--
PROCEDURE running_stats IS
BEGIN
   g_stats_run := TRUE;
   g_bins_run  := FALSE;
END running_stats;
--
-----------------------------------------------------------------------------
--
PROCEDURE running_bins IS
BEGIN
   g_stats_run := FALSE;
   g_bins_run  := TRUE;
END running_bins;
--
-----------------------------------------------------------------------------
--
END nm3eng_dynseg;
/
