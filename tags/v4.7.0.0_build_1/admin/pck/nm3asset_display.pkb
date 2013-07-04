CREATE OR REPLACE PACKAGE BODY nm3asset_display AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3asset_display.pkb-arc   2.5   Jul 04 2013 15:15:40   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3asset_display.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:15:40  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:08  $
--       Version          : $Revision:   2.5  $
--       Based on SCCS version : 1.4
--
--   Author : Kevin Angus
--
--   nm3asset_display body
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.5  $';
  g_package_name CONSTANT VARCHAR2(30) := 'nm3asset_display';
  c_nl CONSTANT VARCHAR2(1) := CHR(10);

  -----------
  --variables
  -----------
  g_num_types_displayed pls_integer;
  g_window_height       number;
  g_window_width        number;

  g_types_list_tab t_types_details_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_distinct_mp_for_point (pi_narh_job_id IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                    ,pi_inv_type    IN     nm_inv_items.iit_inv_type%TYPE
                                    ,pi_x_sect      IN     nm_inv_items.iit_x_sect%TYPE
                                    ,pi_range_begin IN     number DEFAULT NULL
                                    ,pi_range_end   IN     number DEFAULT NULL
                                    ,po_tab_rec_mp    OUT tab_rec_mp
                                    );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_distinct_mp_for_cont (pi_narh_job_id IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                   ,pi_inv_type    IN     nm_inv_items.iit_inv_type%TYPE
                                   ,pi_x_sect      IN     nm_inv_items.iit_x_sect%TYPE
                                   ,pi_range_begin IN     number DEFAULT NULL
                                   ,pi_range_end   IN     number DEFAULT NULL
                                   ,po_tab_rec_mp    OUT tab_rec_mp
                                   );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ref_item_mp_for_point (pi_narh_job_id   IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                    ,pi_inv_type      IN     nm_inv_items.iit_inv_type%TYPE
                                    ,pi_ref_item_id   IN     number
                                    ,pi_ref_item_only IN     boolean DEFAULT FALSE
                                    ,pi_range_begin   IN     number  DEFAULT NULL
                                    ,pi_range_end     IN     number  DEFAULT NULL
                                    ,po_tab_rec_mp       OUT tab_rec_mp
                                    );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ref_item_mp_for_cont (pi_narh_job_id   IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                   ,pi_inv_type      IN     nm_inv_items.iit_inv_type%TYPE
                                   ,pi_ref_item_id   IN     number
                                   ,pi_ref_item_only IN     boolean DEFAULT FALSE
                                   ,pi_range_begin   IN     number  DEFAULT NULL
                                   ,pi_range_end     IN     number  DEFAULT NULL
                                   ,po_tab_rec_mp       OUT tab_rec_mp
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
PROCEDURE set_window_dimensions(pi_num_types IN pls_integer
                               ,pi_height    IN number
                               ,pi_width     IN number
                               ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_window_dimensions');

  g_num_types_displayed := pi_num_types;
  g_window_height       := pi_height;
  g_window_width        := pi_width;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_window_dimensions');

END set_window_dimensions;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_types_list(pi_narh_job_id    IN     nm_assets_on_route_holding.narh_job_id%TYPE
                          ,pi_group_by_xsp   IN     boolean DEFAULT TRUE
                          ,po_types_list_tab    OUT t_types_details_tab
                          ) IS

  c_nl       CONSTANT varchar2(1) := CHR(10);

  c_type_col CONSTANT varchar2(100) := 'narh.narh_nm_obj_type';
  c_xsp_col  CONSTANT varchar2(100) := 'narh.narh_item_x_sect';
  
  l_tab_orderby    nm3type.tab_number;
  l_tab_screenseq  nm3type.tab_number;
  l_tab_nittype    nm3type.tab_varchar4;

--  l_sql nm3type.max_varchar2 :=            'BEGIN'
--                                || c_nl || '  SELECT'
--                                || c_nl || '    narh.narh_nm_obj_type,'
--                                || c_nl || '    narh.narh_item_x_sect'
--                                || c_nl || '  BULK COLLECT INTO'
--                                || c_nl || '    nm3asset_display.g_inv_types_tab,'
--                                || c_nl || '    nm3asset_display.g_inv_xsps_tab'
--                                || c_nl || '  FROM'
--                                || c_nl || '    nm_assets_on_route_holding narh'
--                                || c_nl || '  WHERE'
--                                || c_nl || '    narh.narh_job_id = :p_narh_job_id'
--                                || c_nl || '  AND'
--                                || c_nl || '    narh.narh_item_type_type = :p_item_type_type'
--                                || c_nl || '  GROUP BY';

  l_sql nm3type.max_varchar2 :=            'SELECT'
                                || c_nl || '    narh.narh_nm_obj_type,'
                                || c_nl || '    narh.narh_item_x_sect,'
                                || c_nl || '    NVL(min( nwx_seq ),-1) nwx_seq,'
                                || c_nl || '    nit_screen_seq, '
                                || c_nl || '    nit_inv_type '
                                || c_nl || '  FROM'
                                || c_nl || '    nm_assets_on_route_holding narh'
                                || c_nl || '  , nm_nw_xsp '
                                || c_nl || '  , nm_inv_types '
                                || c_nl || '  WHERE'
                                || c_nl || '    narh.narh_job_id = :p_narh_job_id'
                                || c_nl || '  AND'
                                || c_nl || '    narh.narh_item_type_type = :p_item_type_type'
                                || c_nl || '  AND'
                                || c_nl || '    narh_item_x_sect = nwx_x_sect (+)'
                                || c_nl || '  AND'
                                || c_nl || '    narh_item_type = nit_inv_type'
                                || c_nl || '  GROUP BY';

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'build_types_list');

  g_types_list_tab.DELETE;

  IF pi_group_by_xsp
  THEN
    l_sql :=            l_sql
             || c_nl || '  ' || c_xsp_col  || ','
             || c_nl || '  ' || c_type_col;
  ELSE
    l_sql :=            l_sql
             || c_nl || '  ' || c_type_col  || ','
             || c_nl || '  ' || c_xsp_col;
  END IF;
  l_sql :=  l_sql ||' ,nit_screen_seq, nit_inv_type';
  l_sql :=  l_sql ||' ORDER BY nwx_seq NULLS FIRST, nit_screen_seq, nit_inv_type';
  
 -- l_sql :=            l_sql || ';'
        --   || c_nl || 'END;';
--
  EXECUTE IMMEDIATE l_sql
     BULK COLLECT 
     INTO nm3asset_display.g_inv_types_tab
        , nm3asset_display.g_inv_xsps_tab
        , l_tab_orderby
        , l_tab_screenseq
        , l_tab_nittype
    USING pi_narh_job_id,
          nm3gaz_qry.get_ngqt_item_type_type_inv;
--
  FOR l_i IN 1..g_inv_types_tab.COUNT
  LOOP
  --
    g_types_list_tab(l_i).inv_type   := g_inv_types_tab(l_i);
    g_types_list_tab(l_i).xsp        := g_inv_xsps_tab(l_i);
    g_types_list_tab(l_i).label_text := g_inv_types_tab(l_i) || ' ' || g_inv_xsps_tab(l_i);
  --
  END LOOP;

  po_types_list_tab := g_types_list_tab;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'build_types_list');

END build_types_list;
--
-----------------------------------------------------------------------------
--
FUNCTION get_type_details(pi_index IN pls_integer
                         ) RETURN t_types_details_rec IS

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_type_details');

  IF pi_index NOT BETWEEN 1 AND g_types_list_tab.COUNT
  THEN
    RETURN NULL;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_type_details');

  RETURN g_types_list_tab(pi_index);

END get_type_details;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_ref_item_data_for_window(pi_narh_job_id         IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                        ,pi_measure_start       IN     number
                                        ,pi_measure_end         IN     number
                                        ,pi_ref_type            IN     nm_inv_types.nit_inv_type%TYPE
                                        ,pi_current_ref_item_id IN     nm_inv_items.iit_ne_id%TYPE
                                        ,pi_ref_item_only       IN     boolean
                                        ,pi_x_scale_factor      IN     number
                                        ,pi_y_scale_factor      IN     number
                                        ,po_ref_items_data_tab     OUT t_ref_item_data_tab
                                        ) IS

  l_ref_item_chunks tab_rec_mp;

BEGIN
  get_ref_item_mp(pi_narh_job_id   => pi_narh_job_id
                 ,pi_inv_type      => pi_ref_type
                 ,pi_ref_item_id   => pi_current_ref_item_id
                 ,pi_ref_item_only => pi_ref_item_only
                 ,pi_range_begin   => pi_measure_start
                 ,pi_range_end     => pi_measure_end
                 ,po_tab_rec_mp    => l_ref_item_chunks);

  FOR l_i IN 1..l_ref_item_chunks.COUNT
  LOOP
    po_ref_items_data_tab(l_i).current_ref := l_ref_item_chunks(l_i).is_ref_item;
    po_ref_items_data_tab(l_i).start_x     := (l_ref_item_chunks(l_i).begin_mp - pi_measure_start) * pi_x_scale_factor;
    po_ref_items_data_tab(l_i).end_x       := (l_ref_item_chunks(l_i).end_mp - pi_measure_start) * pi_x_scale_factor;
  END LOOP;

END build_ref_item_data_for_window;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_window_data(pi_narh_job_id         IN     nm_assets_on_route_holding.narh_job_id%TYPE
                           ,pi_type_start_index    IN     pls_integer
                           ,pi_type_end_index      IN     pls_integer
                           ,pi_measure_start       IN     number
                           ,pi_measure_end         IN     number
                           ,pi_ref_type            IN     nm_inv_types.nit_inv_type%TYPE
                           ,pi_current_ref_item_id IN     nm_inv_items.iit_ne_id%TYPE
                           ,pi_ref_item_only       IN     boolean
                           ,po_ditem_data_tab         OUT t_ditem_details_tab
                           ,po_ref_items_data_tab     OUT t_ref_item_data_tab
                           ) IS

  c_x_scale_factor CONSTANT number := g_window_width / (pi_measure_end - pi_measure_start);
  c_y_scale_factor CONSTANT number := g_window_height / (pi_type_end_index - pi_type_start_index);

  l_distinct_chunks_tab tab_rec_mp;

  l_types_count pls_integer := 0;

  l_index pls_integer;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'build_window_data');

  po_ditem_data_tab.DELETE;
  po_ref_items_data_tab.DELETE;

  FOR l_i IN pi_type_start_index..LEAST(g_types_list_tab.COUNT, pi_type_end_index)
  LOOP
    l_types_count := l_types_count + 1;

    --get chunks for this type and xsp
    get_distinct_mp(pi_narh_job_id => pi_narh_job_id
                   ,pi_inv_type    => g_types_list_tab(l_i).inv_type
                   ,pi_x_sect      => g_types_list_tab(l_i).xsp
                   ,pi_range_begin => pi_measure_start
                   ,pi_range_end   => pi_measure_end
                   ,po_tab_rec_mp  => l_distinct_chunks_tab);

    FOR l_j IN 1..l_distinct_chunks_tab.COUNT
    LOOP
      l_index := po_ditem_data_tab.COUNT + 1;

      po_ditem_data_tab(l_index).inv_type    := g_types_list_tab(l_i).inv_type;
      po_ditem_data_tab(l_index).xsp         := g_types_list_tab(l_i).xsp;
      po_ditem_data_tab(l_index).begin_mp    := l_distinct_chunks_tab(l_j).begin_mp;
      po_ditem_data_tab(l_index).end_mp      := l_distinct_chunks_tab(l_j).end_mp;
      po_ditem_data_tab(l_index).item_count  := l_distinct_chunks_tab(l_j).item_count;
      po_ditem_data_tab(l_index).info_text   := g_types_list_tab(l_i).inv_type
                                                || ' (' || l_distinct_chunks_tab(l_j).item_count || ')';
      po_ditem_data_tab(l_index).point       := l_distinct_chunks_tab(l_j).begin_mp = l_distinct_chunks_tab(l_j).end_mp;
      po_ditem_data_tab(l_index).start_x     := (l_distinct_chunks_tab(l_j).begin_mp - pi_measure_start) * c_x_scale_factor;
      po_ditem_data_tab(l_index).start_y     := l_types_count;
      po_ditem_data_tab(l_index).end_x       := (l_distinct_chunks_tab(l_j).end_mp - pi_measure_start) * c_x_scale_factor;
      po_ditem_data_tab(l_index).end_y       := l_types_count;
    END LOOP;
  END LOOP;

  IF pi_ref_type IS NOT NULL
  THEN
    build_ref_item_data_for_window(pi_narh_job_id         => pi_narh_job_id
                                  ,pi_measure_start       => pi_measure_start
                                  ,pi_measure_end         => pi_measure_end
                                  ,pi_ref_type            => pi_ref_type
                                  ,pi_current_ref_item_id => pi_current_ref_item_id
                                  ,pi_ref_item_only       => pi_ref_item_only
                                  ,pi_x_scale_factor      => c_x_scale_factor
                                  ,pi_y_scale_factor      => c_y_scale_factor
                                  ,po_ref_items_data_tab  => po_ref_items_data_tab);
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'build_window_data');

END build_window_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_distinct_mp (pi_narh_job_id IN     nm_assets_on_route_holding.narh_job_id%TYPE
                          ,pi_inv_type    IN     nm_inv_items.iit_inv_type%TYPE
                          ,pi_x_sect      IN     nm_inv_items.iit_x_sect%TYPE
                          ,pi_range_begin IN     number DEFAULT NULL
                          ,pi_range_end   IN     number DEFAULT NULL
                          ,po_tab_rec_mp     OUT tab_rec_mp
                          ) IS
--
   l_rec_nit nm_inv_types%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_distinct_mp');
--
   IF nm3get.get_nit(pi_nit_inv_type=>pi_inv_type).nit_pnt_or_cont = 'P'
    THEN
      get_distinct_mp_for_point (pi_narh_job_id => pi_narh_job_id
                                ,pi_inv_type    => pi_inv_type
                                ,pi_x_sect      => pi_x_sect
                                ,pi_range_begin => pi_range_begin
                                ,pi_range_end   => pi_range_end
                                ,po_tab_rec_mp  => po_tab_rec_mp
                                );
   ELSE
      get_distinct_mp_for_cont  (pi_narh_job_id => pi_narh_job_id
                                ,pi_inv_type    => pi_inv_type
                                ,pi_x_sect      => pi_x_sect
                                ,pi_range_begin => pi_range_begin
                                ,pi_range_end   => pi_range_end
                                ,po_tab_rec_mp  => po_tab_rec_mp
                                );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_distinct_mp');
--
END get_distinct_mp;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_distinct_mp_for_point (pi_narh_job_id IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                    ,pi_inv_type    IN     nm_inv_items.iit_inv_type%TYPE
                                    ,pi_x_sect      IN     nm_inv_items.iit_x_sect%TYPE
                                    ,pi_range_begin IN     number DEFAULT NULL
                                    ,pi_range_end   IN     number DEFAULT NULL
                                    ,po_tab_rec_mp     OUT tab_rec_mp
                                    ) IS
--
   l_tab_begin_mp   nm3type.tab_number;
   l_tab_end_mp     nm3type.tab_number;
   l_tab_item_count nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_distinct_mp_for_point');
--
   IF pi_x_sect IS NULL
    THEN
      SELECT narh_placement_begin_mp
            ,narh_placement_end_mp
            ,COUNT(*)
       BULK  COLLECT
       INTO  l_tab_begin_mp
            ,l_tab_end_mp
            ,l_tab_item_count
       FROM  nm_assets_on_route_holding
      WHERE  narh_job_id      = pi_narh_job_id
       AND   narh_item_type   = pi_inv_type
       AND   narh_placement_begin_mp BETWEEN NVL(pi_range_begin,narh_placement_begin_mp) AND NVL(pi_range_end,narh_placement_begin_mp)
      GROUP BY narh_placement_begin_mp
              ,narh_placement_end_mp;
   ELSE
      SELECT narh_placement_begin_mp
            ,narh_placement_end_mp
            ,COUNT(*)
       BULK  COLLECT
       INTO  l_tab_begin_mp
            ,l_tab_end_mp
            ,l_tab_item_count
       FROM  nm_assets_on_route_holding
      WHERE  narh_job_id      = pi_narh_job_id
       AND   narh_item_type   = pi_inv_type
       AND   narh_item_x_sect = pi_x_sect
       AND   narh_placement_begin_mp BETWEEN NVL(pi_range_begin,narh_placement_begin_mp) AND NVL(pi_range_end,narh_placement_begin_mp)
      GROUP BY narh_placement_begin_mp
              ,narh_placement_end_mp;
   END IF;
--
   FOR i IN 1..l_tab_begin_mp.COUNT
    LOOP
      po_tab_rec_mp(i).begin_mp   := l_tab_begin_mp(i);
      po_tab_rec_mp(i).end_mp     := l_tab_end_mp(i);
      po_tab_rec_mp(i).item_count := l_tab_item_count(i);
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_distinct_mp_for_point');
--
END get_distinct_mp_for_point;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_distinct_mp_for_cont (pi_narh_job_id IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                   ,pi_inv_type    IN     nm_inv_items.iit_inv_type%TYPE
                                   ,pi_x_sect      IN     nm_inv_items.iit_x_sect%TYPE
                                   ,pi_range_begin IN     number DEFAULT NULL
                                   ,pi_range_end   IN     number DEFAULT NULL
                                   ,po_tab_rec_mp     OUT tab_rec_mp
                                   ) IS
--
   CURSOR cs_exists_xsp (c_narh_job_id nm_assets_on_route_holding.narh_job_id%TYPE
                        ,c_inv_type    nm_inv_items.iit_inv_type%TYPE
                        ,c_x_sect      nm_inv_items.iit_x_sect%TYPE
                        ,c_mp          number
                        ) IS
   SELECT COUNT(*)
    FROM  nm_assets_on_route_holding
   WHERE  narh_job_id      = c_narh_job_id
    AND   narh_item_type   = c_inv_type
    AND   narh_item_x_sect = c_x_sect
    AND   c_mp            >= narh_placement_begin_mp
    AND   c_mp            <  narh_placement_end_mp;
--
   CURSOR cs_exists_no_xsp (c_narh_job_id nm_assets_on_route_holding.narh_job_id%TYPE
                           ,c_inv_type    nm_inv_items.iit_inv_type%TYPE
                           ,c_mp          number
                           ) IS
   SELECT COUNT(*)
    FROM  nm_assets_on_route_holding
   WHERE  narh_job_id      = c_narh_job_id
    AND   narh_item_type   = c_inv_type
    AND   c_mp            >= narh_placement_begin_mp
    AND   c_mp            <  narh_placement_end_mp;
--
   l_match_count pls_integer;
--
   l_tab_mp_temp nm3type.tab_number;
   l_tab_mp      nm3type.tab_number;
   l_rec_mp      rec_mp;
   l_tab_rec_mp  tab_rec_mp;
   l_count_temp  pls_integer := 0;
   l_count       pls_integer := 0;
   l_count_final pls_integer := 0;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_distinct_mp_for_cont');
--
   IF pi_x_sect IS NULL
    THEN
      SELECT mp
       BULK  COLLECT
       INTO  l_tab_mp_temp
       FROM (SELECT narh_placement_begin_mp mp
              FROM  nm_assets_on_route_holding
             WHERE  narh_job_id      = pi_narh_job_id
              AND   narh_item_type   = pi_inv_type
             UNION
             SELECT LEAST(narh_placement_end_mp,NVL(pi_range_end,narh_placement_end_mp)) mp
              FROM  nm_assets_on_route_holding
             WHERE  narh_job_id      = pi_narh_job_id
              AND   narh_item_type   = pi_inv_type
             ORDER BY 1
            );
   ELSE
      SELECT mp
       BULK  COLLECT
       INTO  l_tab_mp_temp
       FROM (SELECT narh_placement_begin_mp mp
              FROM  nm_assets_on_route_holding
             WHERE  narh_job_id      = pi_narh_job_id
              AND   narh_item_type   = pi_inv_type
              AND   narh_item_x_sect = pi_x_sect
             UNION
             SELECT LEAST(narh_placement_end_mp,NVL(pi_range_end,narh_placement_end_mp)) mp
              FROM  nm_assets_on_route_holding
             WHERE  narh_job_id      = pi_narh_job_id
              AND   narh_item_type   = pi_inv_type
              AND   narh_item_x_sect = pi_x_sect
             ORDER BY 1
            );
   END IF;
--
   IF l_tab_mp_temp.COUNT > 0
    THEN
--
      IF   pi_range_begin IS NOT NULL
       AND pi_range_end   IS NOT NULL
       THEN
         l_tab_mp(0) := 0; -- Put a value on Array Position 0 temporarily
         FOR i IN 1..l_tab_mp_temp.COUNT
          LOOP
            IF  l_tab_mp_temp(i) < pi_range_begin
             THEN
               IF l_tab_mp(l_count_temp) != pi_range_begin
                THEN
                  l_count_temp           := l_count_temp + 1;
                  l_tab_mp(l_count_temp) := pi_range_begin;
               END IF;
            ELSIF l_tab_mp_temp(i) > pi_range_end
             THEN
               IF l_tab_mp(l_count_temp) != pi_range_end
                THEN
                  l_count_temp           := l_count_temp + 1;
                  l_tab_mp(l_count_temp) := pi_range_end;
               END IF;
            ELSE
               l_count_temp := l_count_temp + 1;
               l_tab_mp(l_count_temp) := l_tab_mp_temp(i);
            END IF;
         END LOOP;
         l_tab_mp.DELETE(0); -- Remove value from pos 0
      ELSE -- No range - return all
         l_tab_mp := l_tab_mp_temp;
      END IF;
--
      l_rec_mp.begin_mp := l_tab_mp(1);
--
      FOR i IN 2..l_tab_mp.COUNT
       LOOP
         l_rec_mp.end_mp       := l_tab_mp(i);
         l_count               := l_count + 1;
         l_tab_rec_mp(l_count) := l_rec_mp;
         l_rec_mp.begin_mp     := l_tab_mp(i);
      END LOOP;
--
      FOR i IN 1..l_count
       LOOP
--
         IF pi_x_sect IS NULL
          THEN
            OPEN  cs_exists_no_xsp (pi_narh_job_id
                                   ,pi_inv_type
                                   ,l_tab_rec_mp(i).begin_mp
                                   );
            FETCH cs_exists_no_xsp INTO l_match_count;
            CLOSE cs_exists_no_xsp;
         ELSE
            OPEN  cs_exists_xsp (pi_narh_job_id
                                ,pi_inv_type
                                ,pi_x_sect
                                ,l_tab_rec_mp(i).begin_mp
                                );
            FETCH cs_exists_xsp INTO l_match_count;
            CLOSE cs_exists_xsp;
         END IF;
         IF l_match_count > 0
          THEN
            l_count_final                            := l_count_final + 1;
            po_tab_rec_mp(l_count_final)             := l_tab_rec_mp(i);
            po_tab_rec_mp(l_count_final).item_count  := l_match_count;
            po_tab_rec_mp(l_count_final).is_ref_item := FALSE;
         END IF;
      END LOOP;
--
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_distinct_mp_for_cont');
--
END get_distinct_mp_for_cont;
--
-----------------------------------------------------------------------------
--
FUNCTION get_narh_order_by(pi_table_alias IN varchar2 DEFAULT NULL
                          ) RETURN varchar2 IS

  l_prefix varchar2(100);

  l_retval nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_narh_order_by');

  IF pi_table_alias IS NOT NULL
  THEN
    l_prefix := pi_table_alias || '.';
  END IF;

  l_retval :=            '  ' || l_prefix || 'narh_placement_begin_mp,'
              || c_nl || '  ' || l_prefix || 'narh_placement_end_mp,'
              || c_nl || '  ' || l_prefix || 'narh_item_type';

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_narh_order_by');

  RETURN l_retval;

END get_narh_order_by;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ordered_narh_row_number(pi_narh_job_id IN nm_assets_on_route_holding.narh_job_id%TYPE
                                    ,pi_rowid       IN ROWID
                                    ) RETURN pls_integer IS

  l_sql nm3type.max_varchar2;

  l_retval pls_integer;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_ordered_narh_row_number');

  l_sql :=            'SELECT'
           || c_nl || '  row_number'
           || c_nl || 'FROM'
           || c_nl || '  (SELECT'
           || c_nl || '     ROWNUM row_number,'
           || c_nl || '     narh_rowid'
           || c_nl || '   FROM'
           || c_nl || '     (SELECT'
           || c_nl || '        rowid narh_rowid'
           || c_nl || '      FROM'
           || c_nl || '        nm_assets_on_route_holding narh'
           || c_nl || '      WHERE'
           || c_nl || '        narh.narh_job_id = :p_narh_job_id'
           || c_nl || '      AND'
           || c_nl || '        narh.narh_item_type_type = :p_item_type_type'
           || c_nl || '      ORDER BY'
           || c_nl || '        ' || get_narh_order_by || '))'
           || c_nl || 'WHERE'
           || c_nl || '  narh_rowid = :p_rowid';

  EXECUTE IMMEDIATE l_sql INTO l_retval USING pi_narh_job_id,
                                              nm3gaz_qry.get_ngqt_item_type_type_inv,
                                              pi_rowid;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_ordered_narh_row_number');

  RETURN l_retval;

END get_ordered_narh_row_number;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_items_at_mp (pi_narh_job_id   IN     nm_assets_on_route_holding.narh_job_id%TYPE
                          ,pi_inv_type      IN     nm_inv_items.iit_inv_type%TYPE
                          ,pi_x_sect        IN     nm_inv_items.iit_x_sect%TYPE
                          ,pi_mp            IN     number
                          ,po_inv_items_tab IN OUT t_inv_items_tab
                          ) IS

   l_rowid_tab    nm3type.tab_rowid;
   l_ne_id_tab    nm3type.tab_number;
   l_begin_mp_tab nm3type.tab_number;
   l_end_mp_tab   nm3type.tab_number;
   l_pk_tab       nm3type.tab_varchar2000;
   l_descr_tab    nm3type.tab_varchar2000;

   l_count pls_integer;

BEGIN
   nm_debug.proc_start(g_package_name,'get_items_at_mp');

   SELECT
     narh.ROWID,
     narh.narh_ne_id_in,
     narh.narh_placement_begin_mp,
     narh.narh_placement_end_mp,
     iit.iit_primary_key,
     iit.iit_descr
   BULK COLLECT INTO
     l_rowid_tab,
     l_ne_id_tab,
     l_begin_mp_tab,
     l_end_mp_tab,
     l_pk_tab,
     l_descr_tab
   FROM
     nm_assets_on_route_holding narh,
     nm_inv_items               iit
   WHERE
     narh_job_id = pi_narh_job_id
   AND
     narh_item_type = pi_inv_type
   AND
     NVL(narh_item_x_sect,nm3type.c_nvl) = NVL(pi_x_sect,nm3type.c_nvl)
   AND
     ((pi_mp >= narh_placement_begin_mp
       AND pi_mp <  narh_placement_end_mp)
      OR
      (narh_placement_begin_mp = narh_placement_end_mp
       AND pi_mp = narh_placement_begin_mp))
   AND
     iit.iit_ne_id(+) = narh.narh_ne_id_in; -- CWS 697246 13/02/2009 Added so Strip Map functionality works for foreign tables.

   po_inv_items_tab.DELETE;

   l_count := l_rowid_tab.COUNT;

   IF l_count > 0
   THEN
     FOR l_i IN 1..l_count
     LOOP
       po_inv_items_tab(l_i).iit_ne_id       := l_ne_id_tab(l_i);
       po_inv_items_tab(l_i).iit_primary_key := l_pk_tab(l_i);
       po_inv_items_tab(l_i).iit_descr       := l_descr_tab(l_i);
       po_inv_items_tab(l_i).pl_begin_mp     := l_begin_mp_tab(l_i);
       po_inv_items_tab(l_i).pl_end_mp       := l_end_mp_tab(l_i);
       po_inv_items_tab(l_i).narh_rowid      := ROWIDTOCHAR(l_rowid_tab(l_i));
     END LOOP;
   END IF;

   nm_debug.proc_end(g_package_name,'get_items_at_mp');

END get_items_at_mp;
--
-----------------------------------------------------------------------------
--
FUNCTION get_type_index(pi_inv_type IN nm_inv_types.nit_inv_type%TYPE
                       ,pi_xsp      IN nm_xsp.nwx_x_sect%TYPE
                       ) RETURN pls_integer IS

  l_retval pls_integer;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_type_index');

  FOR l_i IN 1..g_types_list_tab.COUNT
  LOOP
    IF g_types_list_tab(l_i).inv_type = pi_inv_type
      AND NVL(g_types_list_tab(l_i).xsp, nm3type.c_nvl) = NVL(pi_xsp, nm3type.c_nvl)
    THEN
      l_retval := l_i;
      EXIT;
    END IF;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_type_index');

  RETURN l_retval;

END get_type_index;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ref_item_mp (pi_narh_job_id   IN     nm_assets_on_route_holding.narh_job_id%TYPE
                          ,pi_inv_type      IN     nm_inv_items.iit_inv_type%TYPE
                          ,pi_ref_item_id   IN     number
                          ,pi_ref_item_only IN     boolean DEFAULT FALSE
                          ,pi_range_begin   IN     number  DEFAULT NULL
                          ,pi_range_end     IN     number  DEFAULT NULL
                          ,po_tab_rec_mp       OUT tab_rec_mp
                          ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ref_item_mp');
--
   IF nm3get.get_nit(pi_nit_inv_type=>pi_inv_type).nit_pnt_or_cont = 'P'
    THEN
      get_ref_item_mp_for_point (pi_narh_job_id   => pi_narh_job_id
                                ,pi_inv_type      => pi_inv_type
                                ,pi_ref_item_id   => pi_ref_item_id
                                ,pi_ref_item_only => pi_ref_item_only
                                ,pi_range_begin   => pi_range_begin
                                ,pi_range_end     => pi_range_end
                                ,po_tab_rec_mp    => po_tab_rec_mp
                                );
   ELSE
      get_ref_item_mp_for_cont  (pi_narh_job_id   => pi_narh_job_id
                                ,pi_inv_type      => pi_inv_type
                                ,pi_ref_item_id   => pi_ref_item_id
                                ,pi_ref_item_only => pi_ref_item_only
                                ,pi_range_begin   => pi_range_begin
                                ,pi_range_end     => pi_range_end
                                ,po_tab_rec_mp    => po_tab_rec_mp
                                );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_ref_item_mp');
--
END get_ref_item_mp;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ref_item_mp_for_point (pi_narh_job_id   IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                    ,pi_inv_type      IN     nm_inv_items.iit_inv_type%TYPE
                                    ,pi_ref_item_id   IN     number
                                    ,pi_ref_item_only IN     boolean DEFAULT FALSE
                                    ,pi_range_begin   IN     number  DEFAULT NULL
                                    ,pi_range_end     IN     number  DEFAULT NULL
                                    ,po_tab_rec_mp       OUT tab_rec_mp
                                    ) IS
--
   CURSOR cs_is_ref_item (c_narh_job_id nm_assets_on_route_holding.narh_job_id%TYPE
                         ,c_ref_item_id number
                         ,c_begin_mp    number
                         ,c_end_mp      number
                         ) IS
   SELECT 1
    FROM  nm_assets_on_route_holding
   WHERE  narh_job_id             = c_narh_job_id
    AND   narh_ne_id_in           = c_ref_item_id
    AND   narh_placement_begin_mp = c_begin_mp
    AND   narh_placement_end_mp   = c_end_mp;
--
   l_dummy          pls_integer;
   l_tab_rec_mp     tab_rec_mp;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ref_item_mp_for_point');
--
   get_distinct_mp_for_point (pi_narh_job_id => pi_narh_job_id
                             ,pi_inv_type    => pi_inv_type
                             ,pi_x_sect      => NULL
                             ,pi_range_begin => pi_range_begin
                             ,pi_range_end   => pi_range_end
                             ,po_tab_rec_mp  => l_tab_rec_mp
                             );
--
   FOR i IN 1..l_tab_rec_mp.COUNT
    LOOP
      OPEN  cs_is_ref_item (pi_narh_job_id
                           ,pi_ref_item_id
                           ,l_tab_rec_mp(i).begin_mp
                           ,l_tab_rec_mp(i).end_mp
                           );
      FETCH cs_is_ref_item INTO l_dummy;
      l_tab_rec_mp(i).is_ref_item := cs_is_ref_item%FOUND;
      CLOSE cs_is_ref_item;
      IF (l_tab_rec_mp(i).is_ref_item AND pi_ref_item_only)
       OR NOT pi_ref_item_only
       THEN
         po_tab_rec_mp(po_tab_rec_mp.COUNT+1) := l_tab_rec_mp(i);
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_ref_item_mp_for_point');
--
END get_ref_item_mp_for_point;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ref_item_mp_for_cont (pi_narh_job_id   IN     nm_assets_on_route_holding.narh_job_id%TYPE
                                   ,pi_inv_type      IN     nm_inv_items.iit_inv_type%TYPE
                                   ,pi_ref_item_id   IN     number
                                   ,pi_ref_item_only IN     boolean DEFAULT FALSE
                                   ,pi_range_begin   IN     number  DEFAULT NULL
                                   ,pi_range_end     IN     number  DEFAULT NULL
                                   ,po_tab_rec_mp       OUT tab_rec_mp
                                   ) IS
--
   CURSOR cs_is_ref_item (c_narh_job_id nm_assets_on_route_holding.narh_job_id%TYPE
                         ,c_ref_item_id number
                         ,c_begin_mp    number
                         ,c_end_mp      number
                         ) IS
   SELECT 1
    FROM  nm_assets_on_route_holding
   WHERE  narh_job_id              = c_narh_job_id
    AND   narh_ne_id_in            = c_ref_item_id
    AND   narh_placement_end_mp    > c_begin_mp
    AND   narh_placement_begin_mp  < c_end_mp;
--
   l_dummy          pls_integer;
   l_tab_rec_mp     tab_rec_mp;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_ref_item_mp_for_cont');
--
   get_distinct_mp_for_cont (pi_narh_job_id => pi_narh_job_id
                            ,pi_inv_type    => pi_inv_type
                            ,pi_x_sect      => NULL
                            ,pi_range_begin => pi_range_begin
                            ,pi_range_end   => pi_range_end
                            ,po_tab_rec_mp  => l_tab_rec_mp
                            );
--
   FOR i IN 1..l_tab_rec_mp.COUNT
    LOOP
      OPEN  cs_is_ref_item (pi_narh_job_id
                           ,pi_ref_item_id
                           ,l_tab_rec_mp(i).begin_mp
                           ,l_tab_rec_mp(i).end_mp
                           );
      FETCH cs_is_ref_item INTO l_dummy;
      l_tab_rec_mp(i).is_ref_item := cs_is_ref_item%FOUND;
      CLOSE cs_is_ref_item;
      IF (l_tab_rec_mp(i).is_ref_item AND pi_ref_item_only)
       OR NOT pi_ref_item_only
       THEN
         po_tab_rec_mp(po_tab_rec_mp.COUNT+1) := l_tab_rec_mp(i);
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_ref_item_mp_for_cont');
--
END get_ref_item_mp_for_cont;
--
-----------------------------------------------------------------------------
--
END nm3asset_display;
/
