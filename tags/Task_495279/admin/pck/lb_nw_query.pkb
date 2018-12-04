CREATE OR REPLACE PACKAGE BODY lb_nw_query
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_nw_query.pkb-arc   1.2   Dec 04 2018 16:34:46   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_nw_query.pkb  $
   --       Date into PVCS   : $Date:   Dec 04 2018 16:34:46  $
   --       Date fetched Out : $Modtime:   Dec 04 2018 16:33:38  $
   --       PVCS Version     : $Revision:   1.2  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for handling minor set operators
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_get';

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


   FUNCTION get_group_query (p_target_nt_type    IN VARCHAR2,
                             p_target_gty_type   IN VARCHAR2,
                             p_conditions        IN nw_qry_condition_tab)
      RETURN VARCHAR2;

   FUNCTION get_sub_group_query (p_target_nt_type    IN VARCHAR2,
                                 p_target_gty_type   IN VARCHAR2,
                                 p_conditions        IN nw_qry_condition_tab)
      RETURN VARCHAR2;

   /*
         FUNCTION get_attr_predicates (p_target_nt_type    IN VARCHAR2,
                                       p_target_gty_type   IN VARCHAR2,
                                       p_conditions        IN nw_qry_condition_tab)
            RETURN VARCHAR2;

         FUNCTION get_ad_query (p_target_nt_type    IN VARCHAR2,
                                p_target_gty_type   IN VARCHAR2,
                                p_conditions        IN nw_qry_condition_tab)
            RETURN VARCHAR2;
   */

   FUNCTION get_network_query (p_target_nt_type    IN VARCHAR2,
                               p_target_gty_type   IN VARCHAR2,
                               p_conditions        IN nw_qry_condition_tab)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      OPEN retval FOR
            'select nt_unique, ne_id, ne_unique, ne_descr, ne_start_date, nau_unit_code, nau_name, '
         || 'case when nt_datum = '
         || ''''
         || 'Y'
         || ''''
         || ' then ne_length else case when nt_linear = '
         || ''''
         || 'Y'
         || ''''
         || ' then ( select max(nm_end_slk) - min(nm_slk) from nm_members where nm_ne_id_in = ne_id ) else NULL end end element_length '
         || ' from nm_elements, nm_types, nm_admin_units where ne_nt_type = nt_type and ne_admin_unit = nau_admin_unit and ne_nt_type = '
         || ''''
         || p_target_nt_type
         || ''''
         || '  and nvl(ne_gty_group_type, '
         || ''''
         || '$%^&'
         || ''''
         || ') = nvl( '
         || ''''
         || p_target_gty_type
         || ''''
         || ', '
         || ''''
         || '$%^&'
         || ''''
         || ') '
         || get_network_query_string (p_target_nt_type,
                                      p_target_gty_type,
                                      p_conditions);

      RETURN retval;
   END;

   FUNCTION get_network_ids (p_target_nt_type    IN VARCHAR2,
                             p_target_gty_type   IN VARCHAR2,
                             p_conditions        IN nw_qry_condition_tab)
      RETURN int_array_type
   IS
      retval   int_array_type := NM3ARRAY.INIT_INT_ARRAY ().ia;
   BEGIN
      EXECUTE IMMEDIATE
            'select ne_id from nm_elements where ne_nt_type = '
         || ''''
         || p_target_nt_type
         || ''''
         || '  and nvl(ne_gty_group_type, '
         || ''''
         || '$%^&'
         || ''''
         || ') = nvl( '
         || ''''
         || p_target_gty_type
         || ''''
         || ', '
         || ''''
         || '$%^&'
         || ''''
         || ') '
         || get_network_query_string (p_target_nt_type,
                                      p_target_gty_type,
                                      p_conditions)
         BULK COLLECT INTO retval;

      RETURN retval;
   END;


   FUNCTION get_network_query_string (
      p_target_nt_type    IN VARCHAR2,
      p_target_gty_type   IN VARCHAR2,
      p_conditions        IN nw_qry_condition_tab)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (4000);
   BEGIN
      retval :=
            get_group_query (P_TARGET_NT_TYPE,
                             P_TARGET_GTY_TYPE,
                             P_CONDITIONS)
         || get_sub_group_query (P_TARGET_NT_TYPE,
                                 P_TARGET_GTY_TYPE,
                                 P_CONDITIONS)
         || get_attr_predicates (P_TARGET_NT_TYPE,
                                 P_TARGET_GTY_TYPE,
                                 P_CONDITIONS)
         || get_ad_query (P_TARGET_NT_TYPE, P_TARGET_GTY_TYPE, P_CONDITIONS);
      --

      RETURN retval;
   END;


   FUNCTION get_group_query (p_target_nt_type    IN VARCHAR2,
                             p_target_gty_type   IN VARCHAR2,
                             p_conditions        IN nw_qry_condition_tab)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (4000);
   BEGIN
      WITH type_conditions
           AS (  SELECT nt_type,
                        gty_type,
                        CAST (
                           COLLECT (nw_qry_condition (nt_type,
                                                      gty_type,
                                                      col_name,
                                                      operator,
                                                      col_value)) AS nw_qry_condition_tab)
                           condition
                   FROM TABLE (p_conditions) t
               GROUP BY nt_type, gty_type),
           predicates
           AS (SELECT nt_type,
                      gty_type,
                      lb_nw_query.get_attr_predicates (nt_type,
                                                       gty_type,
                                                       condition)
                         group_attr_predicate,
                      get_ad_query (nt_type, gty_type, condition)
                         group_ad_predicate
                 FROM (SELECT t.*
                         FROM type_conditions t, v_group_instance_hierarchy h
                        WHERE     t.nt_type != p_target_nt_type
                              AND h.nt_type = t.nt_type
                              AND h.direction = 'UP'
                              AND group_type = gty_type
                              AND start_nt_type = p_target_nt_type)),
           str_tab
           AS (SELECT    'with element_members (top_ne_id, parent_ne_id, child_ne_id ) '
                      || ' as ( select nm_ne_id_in, nm_ne_id_in,  nm_ne_id_of from nm_members, nm_elements where ne_nt_type = '
                      || ''''
                      || nt_type
                      || ''''
                      || ' and ne_gty_group_type = '
                      || ''''
                      || gty_type
                      || ''''
                      || ' and ne_id = nm_ne_id_in '
                      || group_attr_predicate
                      || ' '
                      || group_ad_predicate
                      || ' union all select nm_ne_id_in, nm_ne_id_in,  nm_ne_id_of from element_members e, nm_members m where m.nm_ne_id_in = e.child_ne_id ) '
                      || ' select child_ne_id from element_members '
                         str
                 FROM predicates)
      SELECT ' and  ne_id in (' || aggrstr || ' ) '
        INTO retval
        FROM (SELECT LISTAGG (str, ' ) and ne_id in (')
                        WITHIN GROUP (ORDER BY 1)
                        aggrstr
                FROM (SELECT str FROM str_tab))
       WHERE aggrstr IS NOT NULL;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         retval := ' ';
         RETURN retval;
   END;

   FUNCTION get_sub_group_query (p_target_nt_type    IN VARCHAR2,
                                 p_target_gty_type   IN VARCHAR2,
                                 p_conditions        IN nw_qry_condition_tab)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (4000);
   BEGIN
      WITH type_conditions
           AS (  SELECT nt_type,
                        gty_type,
                        CAST (
                           COLLECT (nw_qry_condition (nt_type,
                                                      gty_type,
                                                      col_name,
                                                      operator,
                                                      col_value)) AS nw_qry_condition_tab)
                           condition
                   FROM TABLE (p_conditions) t
               GROUP BY nt_type, gty_type),
           predicates
           AS (SELECT nt_type,
                      gty_type,
                      lb_nw_query.get_attr_predicates (nt_type,
                                                       gty_type,
                                                       condition)
                         group_attr_predicate,
                      lb_nw_query.get_ad_query (nt_type, gty_type, condition)
                         group_ad_predicate
                 FROM (SELECT t.*
                         FROM type_conditions t, v_group_instance_hierarchy h
                        WHERE     t.nt_type != p_target_nt_type
                              AND h.nt_type = t.nt_type
                              AND h.direction = 'DOWN'
                              AND NVL (group_type, 'NULL') =
                                     NVL (gty_type, 'NULL')
                              AND start_nt_type = p_target_nt_type)),
           str_tab
           AS (SELECT    'with element_members (top_ne_id, parent_ne_id, child_ne_id ) '
                      || ' as ( select nm_ne_id_in, nm_ne_id_in,  nm_ne_id_of from nm_members, nm_elements where ne_nt_type = '
                      || ''''
                      || nt_type
                      || ''''
                      || ' and nvl(ne_gty_group_type, '
                      || ''''
                      || 'NULL'
                      || ''''
                      || ') = nvl('
                      || ''''
                      || gty_type
                      || ''''
                      || ', '
                      || ''''
                      || 'NULL'
                      || ''''
                      || ') and ne_id = nm_ne_id_of '
                      || group_attr_predicate
                      || ' '
                      || group_ad_predicate
                      || ' union all select nm_ne_id_in, nm_ne_id_in,  nm_ne_id_of from element_members e, nm_members m where m.nm_ne_id_in = e.child_ne_id ) '
                      || ' select parent_ne_id from element_members '
                         str
                 FROM predicates)
      SELECT ' and  ne_id in (' || aggrstr || ' ) '
        INTO retval
        FROM (SELECT LISTAGG (str, ' ) and ne_id in (')
                        WITHIN GROUP (ORDER BY 1)
                        aggrstr
                FROM (SELECT str FROM str_tab))
       WHERE aggrstr IS NOT NULL;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         retval := ' ';
         RETURN retval;
   END;

   FUNCTION get_attr_predicates (p_target_nt_type    IN VARCHAR2,
                                 p_target_gty_type   IN VARCHAR2,
                                 p_conditions        IN nw_qry_condition_tab)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (2000) := NULL;
   BEGIN
        SELECT    ' and '
               || LISTAGG (
                        col_name
                     || ' '
                     || CASE operator WHEN 'EQUAL' THEN '=' ELSE operator END
                     || ' '
                     || CASE field_type
                           WHEN 'VARCHAR2'
                           THEN
                              '''' || col_value || ''''
                           WHEN 'NUMBER'
                           THEN
                              'TO_NUMBER(' || '''' || col_value || '''' || ')'
                           WHEN 'DATE'
                           THEN
                                 'TO_DATE('
                              || ''''
                              || col_value
                              || ''''
                              || ', '
                              || ''''
                              || 'DD-MON-YYYY'
                              || ''''
                              || ')'
                        END,
                     ' AND ')
                  WITHIN GROUP (ORDER BY 1)
          INTO retval
          FROM TABLE (p_conditions) t, v_nm_nw_columns
         WHERE     nt_type = p_target_nt_type
               AND NVL (gty_type, '$$$$') = NVL (p_target_gty_type, '$$$$')
               AND network_type = nt_type
               AND NVL (group_type, '$$$$') = NVL (gty_type, '$$$$')
               AND col_name = column_name
               AND attrib_source IN ('HC', 'TC')
      GROUP BY nt_type, gty_type;

      nm_debug.debug ('attr = ' || retval || ',' || LENGTH (retval));

      IF LENGTH (retval) = 0
      THEN
         retval := ' ';
      END IF;

      nm_debug.debug ('attr = ' || retval || ',' || LENGTH (retval));
      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         retval := ' ';
         RETURN retval;
   END;

   FUNCTION get_ad_query (p_target_nt_type    IN VARCHAR2,
                          p_target_gty_type   IN VARCHAR2,
                          p_conditions        IN nw_qry_condition_tab)
      RETURN VARCHAR2
   IS
      retval   VARCHAR2 (4000) := NULL;
   BEGIN
      WITH aggr_ad_query
           AS (  SELECT nt_type,
                        gty_type,
                        attrib_source,
                        LISTAGG (
                              ita_attrib_name
                           || ' '
                           || CASE operator
                                 WHEN 'EQUAL' THEN '='
                                 ELSE operator
                              END
                           || ' '
                           || CASE field_type
                                 WHEN 'VARCHAR2'
                                 THEN
                                    '''' || col_value || ''''
                                 WHEN 'NUMBER'
                                 THEN
                                       'TO_NUMBER('
                                    || ''''
                                    || col_value
                                    || ''''
                                    || ')'
                                 WHEN 'DATE'
                                 THEN
                                       'TO_DATE('
                                    || ''''
                                    || col_value
                                    || ''''
                                    || ', '
                                    || ''''
                                    || 'DD-MON-YYYY'
                                    || ''''
                                    || ')'
                              END,
                           ' AND ')
                        WITHIN GROUP (ORDER BY 1)
                           ad_condition
                   FROM TABLE (p_conditions) t,
                        v_nm_nw_columns,
                        nm_inv_type_attribs
                  WHERE     nt_type = p_target_nt_type
                        AND NVL (gty_type, '$$$$') =
                               NVL (p_target_gty_type, '$$$$')
                        AND network_type = nt_type
                        AND ita_inv_type = attrib_source
                        AND ita_view_col_name = col_name
                        AND NVL (group_type, '$$$$') = NVL (gty_type, '$$$$')
                        AND col_name = column_name
                        AND attrib_source NOT IN ('HC', 'TC')
               GROUP BY nt_type, gty_type, attrib_source)
      SELECT    ' and ne_id in ('
             || 'select nad_ne_id from nm_nw_ad_link, nm_inv_items '
             || ' where iit_ne_id = nad_iit_ne_id '
             || ' and nad_nt_type = '
             || ''''
             || p_target_nt_type
             || ''''
             || --' and nvl(nad_gty_type, '||''''||'$$$$'||''''||') = nvl('||''''||p_target_gty_type||''''||', '||''''||'$$$$'||''''||')' ||
               ' and nad_inv_type = '
             || ''''
             || attrib_source
             || ''''
             || ' and '
             || ad_condition
             || ' )'
        INTO retval
        FROM aggr_ad_query;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         retval := ' ';
         RETURN retval;
   END;

   FUNCTION get_LOV (p_network_type   IN VARCHAR2,
                     p_group_type     IN VARCHAR2,
                     p_column_name    IN VARCHAR2)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
      l_sql    VARCHAR2 (4000);
   BEGIN
      SELECT lov_query
        INTO l_sql
        FROM v_nm_nw_columns
       WHERE     network_type = p_network_type
             AND NVL (group_type, 'NULL') = NVL (p_group_type, 'NULL')
             AND column_name = p_column_name;

      --
      IF l_sql IS NULL
      THEN
         raise_application_error (
            -20002,
            'A list of values is not available for this network column');
      END IF;

      OPEN retval FOR l_sql;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Network attribute not found');
   END;

   FUNCTION get_nw_and_group_types (
      p_target_nt_type    IN VARCHAR2,
      p_target_gty_type   IN VARCHAR2,
      p_direction         IN VARCHAR2 DEFAULT NULL)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      OPEN retval FOR
         SELECT v.direction Hierarchy_direction,
                v.nt_type type_code,
                nt_unique network_type_name,
                group_type group_type_code,
                ngt_descr group_type_descr
           FROM V_GROUP_INSTANCE_HIERARCHY v, nm_types t, nm_group_types g
          WHERE     start_nt_type = p_target_nt_type
                AND NVL (start_group_type, 'NULL') =
                       NVL (p_target_gty_type, 'NULL')
                AND t.nt_type = v.nt_type
                AND group_type = ngt_group_type(+)
                AND direction = NVL (p_direction, direction);

      RETURN retval;
   END;

   FUNCTION get_parent_groups (pi_asset_id   IN INTEGER,
                               pi_obj_type   IN VARCHAR2)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      OPEN retval FOR
         WITH locations (levl,
                         c_id,
                         m_type,
                         child_element,
                         parent_element,
                         begin_mp,
                         end_mp)
              AS (SELECT 0 levl,
                         1,
                         nm_obj_type,
                         nm_ne_id_of,
                         nm_ne_id_of,
                         nm_begin_mp,
                         nm_end_mp
                    FROM nm_asset_locations, nm_locations
                   WHERE     nal_asset_id = pi_asset_id
                         AND nal_nit_type = pi_obj_type
                         AND nm_ne_id_in = nal_id
                  UNION ALL
                  SELECT 0 levl,
                         1,
                         nm_obj_type,
                         nm_ne_id_of,
                         nm_ne_id_of,
                         nm_begin_mp,
                         nm_end_mp
                    FROM nm_members
                   WHERE     nm_ne_id_in = pi_asset_id
                         AND nm_obj_type = pi_obj_type),
              groups (levl,
                      c_id,
                      p_id,
                      obj_type)
              AS (SELECT DISTINCT 1,
                                  c_id,
                                  m.nm_ne_id_in,
                                  m.nm_obj_type
                    FROM locations, nm_members m
                   WHERE nm_type = 'G' AND nm_ne_id_of = child_element
                  UNION ALL
                  SELECT levl + 1,
                         p_id,
                         nm_ne_id_in,
                         nm_obj_type
                    FROM groups, nm_members
                   WHERE nm_ne_id_of = p_id)
                    SEARCH DEPTH FIRST BY c_id SET order_id
         SELECT levl,
                order_id,
                c_id child_id,
                p_id parent_id,
                obj_type group_type,
                ngt_descr group_type_descr,
                ne_unique element_name,
                ne_descr element_descr
           FROM groups, nm_elements, nm_group_types
          WHERE ne_id = p_id AND ne_gty_group_type = ngt_group_type;

      RETURN retval;
   END;

   FUNCTION get_parent_groups (pi_rpt_tab IN lb_rpt_tab)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      OPEN retval FOR
         WITH locations (levl,
                         c_id,
                         m_type,
                         child_element,
                         parent_element,
                         begin_mp,
                         end_mp)
              AS (SELECT 0 levl,
                         1,
                         obj_type,
                         refnt,
                         refnt,
                         start_m,
                         end_m
                    FROM TABLE (pi_rpt_tab)),
              groups (levl,
                      c_id,
                      p_id,
                      obj_type)
              AS (SELECT DISTINCT 1,
                                  c_id,
                                  m.nm_ne_id_in,
                                  m.nm_obj_type
                    FROM locations, nm_members m
                   WHERE nm_type = 'G' AND nm_ne_id_of = child_element
                  UNION ALL
                  SELECT levl + 1,
                         p_id,
                         nm_ne_id_in,
                         nm_obj_type
                    FROM groups, nm_members
                   WHERE nm_ne_id_of = p_id)
                    SEARCH DEPTH FIRST BY c_id SET order_id
         SELECT levl,
                order_id,
                c_id child_id,
                p_id parent_id,
                obj_type group_type,
                ngt_descr group_type_descr,
                ne_unique element_name,
                ne_descr element_descr
           FROM groups, nm_elements, nm_group_types
          WHERE ne_id = p_id AND ne_gty_group_type = ngt_group_type;

      RETURN retval;
   END;
END;
/
