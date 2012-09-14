CREATE OR REPLACE PACKAGE BODY nm3locator AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3locator.pkb 1.21 10/10/06
--       Module Name      : nm3locator.pkb
--       Date into SCCS   : 06/10/10 15:13:24
--       Date fetched Out : 07/06/13 14:12:23
--       SCCS Version     : 1.21
--
--
--   Author : Darren Cope
--
--   nm3locator body
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2004
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '"$Revision:   2.12  $"';

  g_package_name CONSTANT varchar2(30) := 'nm3locator';

  c_default_operator    CONSTANT nm_gaz_query_attribs.ngqa_operator%TYPE := nm3type.c_and_operator;
  c_disp_units_per_char CONSTANT number := 0.1;  
  c_results_table       CONSTANT varchar2(30) := 'nm_locator_results';
  c_nulls_last          CONSTANT varchar2(15) := 'NULLS LAST';

  g_tab_lookup       tab_rec_inv_item_lookup;
  g_inv_type         nm_inv_types_all.nit_inv_type%TYPE;
  g_order_by_clause  all_tab_columns.column_name%TYPE;
  g_ascending        boolean := TRUE;
  l_sql              nm3type.max_varchar2;
  g_checked_items    nm_id_tbl := new nm_id_tbl(); -- stores a copy of the checked items in the locator from
  g_locator_returned boolean DEFAULT FALSE;
  g_eastings         gis_data_objects.gdo_x_val%TYPE;
  g_northings        gis_data_objects.gdo_x_val%TYPE;
  g_multi_coords     nm3sdo_gdo.tab_xys;
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
PROCEDURE add (l_text IN varchar2) IS
BEGIN
  l_sql := l_sql || l_text || CHR(10);
END add;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_sql IS
BEGIN
  l_sql := NULL;
END clear_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_sql IS
BEGIN
  nm_debug.debug(l_sql);
END debug_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_sql IS
BEGIN
  EXECUTE IMMEDIATE l_sql;
END execute_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_all IS
BEGIN
  g_inv_attrs.DELETE;
  g_tab_lookup.DELETE;
  g_checked_items.DELETE;
  g_eastings := NULL;
  g_northings := NULL;

  EXECUTE IMMEDIATE ('TRUNCATE TABLE nm_locator_results');

  clear_sql;

  -- reset FT mapping
  FOR irec IN 1..g_ft_mapping.COUNT LOOP
    g_ft_mapping(irec).ft_col_name := NULL;
    g_ft_mapping(irec).assigned := FALSE;
  END LOOP;
END clear_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_map_table(p_only_assigned boolean) IS
BEGIN
  nm_debug.debug('Map Table Values');
  nm_debug.debug('Inv_col                       ,Assigned, Ft Col                ');
  FOR irec IN 1..g_ft_mapping.COUNT LOOP
    IF p_only_assigned THEN
      IF g_ft_mapping(irec).assigned THEN
        nm_debug.debug(rpad(g_ft_mapping(irec).inv_col_name, 30)||','||RPAD(nm3flx.boolean_to_char(g_ft_mapping(irec).assigned),8)||','||g_ft_mapping(irec).ft_col_name);
      END IF;
    ELSE
      nm_debug.debug(rpad(g_ft_mapping(irec).inv_col_name, 30)||','||RPAD(nm3flx.boolean_to_char(g_ft_mapping(irec).assigned),8)||','||g_ft_mapping(irec).ft_col_name);
    END IF;
  END LOOP;
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_basic_search_condition(pi_inv_type IN nm_inv_type_attribs_all.ita_inv_type%TYPE
                                   ,pi_attrib   IN nm_inv_type_attribs_all.ita_attrib_name%TYPE) RETURN nm_gaz_query_attribs.ngqa_condition%TYPE IS
l_ita nm_inv_type_attribs_all%ROWTYPE;
l_retval nm_gaz_query_attribs.ngqa_condition%TYPE;
BEGIN

  l_ita := nm3get.get_ita(pi_ita_inv_type    => pi_inv_type
                         ,pi_ita_attrib_name => pi_attrib
                         ,pi_raise_not_found => FALSE);
  IF l_ita.ita_attrib_name IS NULL THEN
    CASE pi_attrib
      WHEN 'IIT_X_SECT' THEN
        l_retval :=  nm3type.c_equals;
      WHEN 'IIT_ADMIN_UNIT' THEN
        l_retval :=  nm3type.c_equals;
      WHEN 'IIT_MODIFIED_BY' THEN
        l_retval :=  nm3type.c_equals;
      WHEN 'IIT_CREATED_BY' THEN
        l_retval :=  nm3type.c_equals;
      WHEN 'IIT_PEO_INVENT_BY_ID' THEN
        l_retval :=  nm3type.c_equals;
      ELSE
        l_retval :=  nm3type.c_equals;
      END CASE;
  ELSIF l_ita.ita_id_domain IS NOT NULL THEN
    l_retval := nm3type.c_equals;
  ELSE
    CASE l_ita.ita_format
      WHEN 'VARCHAR2' THEN
       l_retval := 'LIKE';
      WHEN 'NUMBER' THEN
       l_retval := nm3type.c_equals;
      WHEN 'DATE' THEN
       l_retval := nm3type.c_equals;
      ELSE
       l_retval := nm3type.c_equals;
    END CASE;
  END IF;

  RETURN l_retval;
END get_basic_search_condition;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_ngqa_seq(pi_ngqa_ngq_id      IN nm_gaz_query_attribs.ngqa_ngq_id%TYPE
                          ,pi_ngqa_ngqt_seq_no IN nm_gaz_query_attribs.ngqa_ngqt_seq_no%TYPE) RETURN pls_integer IS

CURSOR get_next_seq(pi_ngqa_ngq_id      IN nm_gaz_query_attribs.ngqa_ngq_id%TYPE
                   ,pi_ngqa_ngqt_seq_no IN nm_gaz_query_attribs.ngqa_ngqt_seq_no%TYPE) IS
SELECT NVL(MAX(ngqa_seq_no), 0) + 10 next_seq
FROM  nm_gaz_query_attribs
WHERE ngqa_ngq_id      = pi_ngqa_ngq_id
AND   ngqa_ngqt_seq_no = pi_ngqa_ngqt_seq_no;

l_retval pls_integer;
BEGIN
  OPEN get_next_seq(pi_ngqa_ngq_id
                   ,pi_ngqa_ngqt_seq_no);
  FETCH get_next_seq INTO l_retval;
  CLOSE get_next_seq;

  RETURN l_retval;
END get_next_ngqa_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_ngqv_seq(pi_ngqv_ngq_id      IN nm_gaz_query_values.ngqv_ngq_id%TYPE
                          ,pi_ngqv_ngqt_seq_no IN nm_gaz_query_values.ngqv_ngqt_seq_no%TYPE
                          ,pi_ngqv_ngqa_seq_no IN nm_gaz_query_values.ngqv_ngqa_seq_no%TYPE) RETURN pls_integer IS
CURSOR get_next_seq(pi_ngqv_ngq_id      IN nm_gaz_query_values.ngqv_ngq_id%TYPE
                   ,pi_ngqv_ngqt_seq_no IN nm_gaz_query_values.ngqv_ngqt_seq_no%TYPE
                   ,pi_ngqv_ngqa_seq_no IN nm_gaz_query_values.ngqv_ngqa_seq_no%TYPE) IS
SELECT NVL(MAX(ngqv_sequence), 0) + 10 next_seq
FROM  nm_gaz_query_values
WHERE ngqv_ngq_id      = pi_ngqv_ngq_id
AND   ngqv_ngqt_seq_no = pi_ngqv_ngqt_seq_no
AND   ngqv_ngqa_seq_no = pi_ngqv_ngqa_seq_no;

l_retval pls_integer;
BEGIN
  OPEN get_next_seq(pi_ngqv_ngq_id
                   ,pi_ngqv_ngqt_seq_no
                   ,pi_ngqv_ngqa_seq_no);
  FETCH get_next_seq INTO l_retval;
  CLOSE get_next_seq;

  RETURN l_retval;
END get_next_ngqv_seq;
--
-----------------------------------------------------------------------------
--
PROCEDURE qry_basic_search_attribs(pi_ngqv_ngq_id         IN     nm_gaz_query_values.ngqv_ngq_id%TYPE
                                  ,pi_ngqv_ngqt_seq_no    IN     nm_gaz_query_values.ngqv_ngqt_seq_no%TYPE
                                  ,pi_ngqt_item_type_type IN     nm_gaz_query_types.ngqt_item_type_type%TYPE
                                  ,pi_ngqt_item_type      IN     nm_gaz_query_types.ngqt_item_type%TYPE
                                  ,po_qry_search_attribs  IN OUT tab_rec_basic_query_attribs) IS

  CURSOR get_values_for_attrib (pi_ngqv_ngq_id nm_gaz_query_values.ngqv_ngq_id%TYPE
                               ,pi_attrib_name nm_gaz_query_attribs.ngqa_attrib_name%TYPE) IS
  SELECT ngqv_ngqa_seq_no
        ,ngqv_sequence
        ,ngqv_value
  FROM   nm_gaz_query_attribs
        ,nm_gaz_query_values
  WHERE  ngqv_ngq_id      (+) = ngqa_ngq_id
  AND    ngqv_ngqt_seq_no (+) = ngqa_ngqt_seq_no
  AND    ngqv_ngqa_seq_no (+) = ngqa_seq_no
  AND    ngqa_attrib_name     = pi_attrib_name
  AND    ngqa_ngq_id          = pi_ngqv_ngq_id;

  l_ita_view_col_name nm3type.tab_varchar30;
  l_ita_scrn_text     nm3type.tab_varchar30;
  l_ita_attrib_name   nm3type.tab_varchar30;

  l_sql   nm3type.max_varchar2;
  l_ngqa  nm_gaz_query_attribs%ROWTYPE;
  l_count pls_integer;
--
  FUNCTION attrib_values_exist (pi_attrib_name nm_gaz_query_attribs.ngqa_attrib_name%TYPE) RETURN boolean IS
    l_atr nm_gaz_query_values.ngqv_ngqa_seq_no%TYPE;
    l_seq nm_gaz_query_values.ngqv_sequence%TYPE;
    l_val nm_gaz_query_values.ngqv_value%TYPE;
    l_found boolean;
  BEGIN
    OPEN get_values_for_attrib(pi_ngqv_ngq_id, pi_attrib_name);
    FETCH get_values_for_attrib INTO l_atr, l_seq, l_val;
    l_found := get_values_for_attrib%FOUND;
    CLOSE get_values_for_attrib;

    RETURN l_found;
  END attrib_values_exist;
--
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'qry_basic_search_attribs');

  -- get the sql for the available attributes
  l_sql := nm3gaz_qry.get_ngqa_lov_sql(pi_ngqt_item_type_type    => pi_ngqt_item_type_type
                                      ,pi_ngqt_item_type         => pi_ngqt_item_type
                                      ,pi_queryable_attribs_only => TRUE
                                      ,pi_include_primary_key    => TRUE);
  EXECUTE IMMEDIATE l_sql
  BULK COLLECT INTO l_ita_view_col_name
                   ,l_ita_scrn_text
                   ,l_ita_attrib_name;
  -- now populate the return table
  l_count := 1;
  FOR irec IN 1..l_ita_attrib_name.COUNT LOOP

    -- are there existing values for this attribute?
    -- if so return them
    IF attrib_values_exist(l_ita_attrib_name(irec)) THEN
      FOR i_vals IN get_values_for_attrib(pi_ngqv_ngq_id, l_ita_attrib_name(irec)) LOOP

        po_qry_search_attribs(l_count).ngqa_attrib_name  := l_ita_attrib_name(irec);
        po_qry_search_attribs(l_count).ita_scrn_text     := l_ita_scrn_text(irec);
        po_qry_search_attribs(l_count).ngqv_ngq_id       := pi_ngqv_ngq_id;
        po_qry_search_attribs(l_count).ngqv_ngqt_seq_no  := pi_ngqv_ngqt_seq_no;
        po_qry_search_attribs(l_count).ngqv_ngqa_seq_no  := i_vals.ngqv_ngqa_seq_no;
        po_qry_search_attribs(l_count).ngqv_sequence     := i_vals.ngqv_sequence;
        po_qry_search_attribs(l_count).ngqv_value        := i_vals.ngqv_value;

        l_count := l_count + 1;
      END LOOP;
    ELSE

      po_qry_search_attribs(l_count).ngqa_attrib_name  := l_ita_attrib_name(irec);
      po_qry_search_attribs(l_count).ita_scrn_text     := l_ita_scrn_text(irec);
      po_qry_search_attribs(l_count).ngqv_ngq_id       := pi_ngqv_ngq_id;
      po_qry_search_attribs(l_count).ngqv_ngqt_seq_no  := pi_ngqv_ngqt_seq_no;
      po_qry_search_attribs(l_count).ngqv_ngqa_seq_no  := NULL;
      po_qry_search_attribs(l_count).ngqv_sequence     := NULL;
      po_qry_search_attribs(l_count).ngqv_value        := NULL;

      l_count := l_count + 1;
    END IF;

  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'qry_basic_search_attribs');
END qry_basic_search_attribs;
--
-----------------------------------------------------------------------------
--
PROCEDURE lck_basic_search_attribs(po_qry_search_attribs IN OUT tab_rec_basic_query_attribs) IS
CURSOR get_vals (pi_ngqv_ngq_id        IN     nm_gaz_query_values.ngqv_ngq_id%TYPE
                ,pi_ngqv_ngqt_seq_no   IN     nm_gaz_query_values.ngqv_ngqt_seq_no%TYPE
                ,pi_ngqv_ngqa_seq_no   IN     nm_gaz_query_values.ngqv_ngqa_seq_no%TYPE
                ,pi_ngqv_sequence      IN     nm_gaz_query_values.ngqv_sequence%TYPE)IS
SELECT 1
FROM   nm_gaz_query_values
WHERE  ngqv_ngq_id      = pi_ngqv_ngq_id
AND    ngqv_ngqt_seq_no = pi_ngqv_ngqt_seq_no
AND    ngqv_ngqa_seq_no = pi_ngqv_ngqa_seq_no
AND    ngqv_sequence    = pi_ngqv_sequence
FOR UPDATE OF ngqv_value NOWAIT;

l_dummy pls_integer;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'lck_basic_search_attribs');
  FOR irec IN 1..po_qry_search_attribs.COUNT LOOP
    -- we will not change attributes only insert them through the basic search criteria block
    OPEN get_vals(po_qry_search_attribs(irec).ngqv_ngq_id
                 ,po_qry_search_attribs(irec).ngqv_ngqt_seq_no
                 ,po_qry_search_attribs(irec).ngqv_ngqa_seq_no
                 ,po_qry_search_attribs(irec).ngqv_sequence);
    FETCH get_vals INTO l_dummy;
    CLOSE get_vals;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'lck_basic_search_attribs');
END lck_basic_search_attribs;
--
-----------------------------------------------------------------------------
--
PROCEDURE upd_basic_search_attribs(pi_ngqt_item_type     IN     nm_gaz_query_types.ngqt_item_type%TYPE
                                  ,po_qry_search_attribs IN OUT tab_rec_basic_query_attribs) IS
l_ngqa nm_gaz_query_attribs%ROWTYPE;
l_ngqv nm_gaz_query_values%ROWTYPE;
--
FUNCTION format_val_for_ins(p_val IN varchar2) RETURN varchar2 IS
l_retval nm_gaz_query_values.ngqv_value%TYPE;
BEGIN
  -- if the condition is LIKE and
  -- there is no % in the value then add one at the end
  l_retval := p_val;
  IF l_ngqa.ngqa_condition = 'LIKE' THEN
    IF INSTR(l_retval, '%') = 0 THEN
      l_retval := l_retval || '%';
    END IF;
  END IF;
  RETURN l_retval;
END format_val_for_ins;
--
PROCEDURE insert_attrib_value(p_ind pls_integer) IS
BEGIN

  po_qry_search_attribs(p_ind).ngqv_sequence := get_next_ngqv_seq(po_qry_search_attribs(p_ind).ngqv_ngq_id
                                                                 ,po_qry_search_attribs(p_ind).ngqv_ngqt_seq_no
                                                                 ,po_qry_search_attribs(p_ind).ngqv_ngqa_seq_no);
  l_ngqv.ngqv_ngq_id      := po_qry_search_attribs(p_ind).ngqv_ngq_id;
  l_ngqv.ngqv_ngqt_seq_no := po_qry_search_attribs(p_ind).ngqv_ngqt_seq_no;
  l_ngqv.ngqv_ngqa_seq_no := po_qry_search_attribs(p_ind).ngqv_ngqa_seq_no;
  l_ngqv.ngqv_sequence    := po_qry_search_attribs(p_ind).ngqv_sequence;
  l_ngqv.ngqv_value       := format_val_for_ins(po_qry_search_attribs(p_ind).ngqv_value);

  nm3ins.ins_ngqv(p_rec_ngqv => l_ngqv);
END insert_attrib_value;
--
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'upd_basic_search_attribs');

  FOR irec IN 1..po_qry_search_attribs.COUNT LOOP
    -- has a value been supplied
    -- if not then delete the attribute and value
    IF po_qry_search_attribs(irec).ngqv_value IS NULL THEN
      --
      nm_debug.debug('Value is null');

      nm3del.del_ngqa(pi_ngqa_ngq_id      => po_qry_search_attribs(irec).ngqv_ngq_id
                     ,pi_ngqa_ngqt_seq_no => po_qry_search_attribs(irec).ngqv_ngqt_seq_no
                     ,pi_ngqa_seq_no      => po_qry_search_attribs(irec).ngqv_ngqa_seq_no
                     ,pi_raise_not_found  => FALSE);

      nm3del.del_ngqv(pi_ngqv_ngq_id      => po_qry_search_attribs(irec).ngqv_ngq_id
                     ,pi_ngqv_ngqt_seq_no => po_qry_search_attribs(irec).ngqv_ngqt_seq_no
                     ,pi_ngqv_ngqa_seq_no => po_qry_search_attribs(irec).ngqv_ngqa_seq_no
                     ,pi_ngqv_sequence    => po_qry_search_attribs(irec).ngqv_sequence
                     ,pi_raise_not_found  => FALSE);
    ELSE
      --  does the attribute already exist
      l_ngqa := nm3get.get_ngqa(pi_ngqa_ngq_id      => po_qry_search_attribs(irec).ngqv_ngq_id
                               ,pi_ngqa_ngqt_seq_no => po_qry_search_attribs(irec).ngqv_ngqt_seq_no
                               ,pi_ngqa_seq_no      => po_qry_search_attribs(irec).ngqv_ngqa_seq_no
                               ,pi_raise_not_found  => FALSE);
      IF l_ngqa.ngqa_ngq_id IS NOT NULL THEN
         -- does the value exist, it should do...

         l_ngqv := nm3get.get_ngqv(pi_ngqv_ngq_id      => po_qry_search_attribs(irec).ngqv_ngq_id
                                  ,pi_ngqv_ngqt_seq_no => po_qry_search_attribs(irec).ngqv_ngqt_seq_no
                                  ,pi_ngqv_ngqa_seq_no => po_qry_search_attribs(irec).ngqv_ngqa_seq_no
                                  ,pi_ngqv_sequence    => po_qry_search_attribs(irec).ngqv_sequence
                                  ,pi_raise_not_found  => FALSE);

         IF l_ngqv.ngqv_sequence IS NOT NULL THEN
           -- update the value
           UPDATE nm_gaz_query_values
           SET    ngqv_value       = po_qry_search_attribs(irec).ngqv_value
           WHERE  ngqv_ngq_id      = l_ngqa.ngqa_ngq_id
           AND    ngqv_ngqt_seq_no = l_ngqa.ngqa_ngqt_seq_no
           AND    ngqv_ngqa_seq_no = l_ngqa.ngqa_seq_no
           AND    ngqv_sequence    = po_qry_search_attribs(irec).ngqv_sequence
           RETURNING ngqv_value INTO po_qry_search_attribs(irec).ngqv_value;
         ELSE
           insert_attrib_value(irec);
         END IF;

      ELSE
        -- otherwise insert the attribute
        -- and the value

        po_qry_search_attribs(irec).ngqv_ngqa_seq_no := get_next_ngqa_seq(po_qry_search_attribs(irec).ngqv_ngq_id
                                                                         ,po_qry_search_attribs(irec).ngqv_ngqt_seq_no);
        l_ngqa.ngqa_ngq_id       := po_qry_search_attribs(irec).ngqv_ngq_id;
        l_ngqa.ngqa_ngqt_seq_no  := po_qry_search_attribs(irec).ngqv_ngqt_seq_no;
        l_ngqa.ngqa_seq_no       := po_qry_search_attribs(irec).ngqv_ngqa_seq_no;
        l_ngqa.ngqa_attrib_name  := po_qry_search_attribs(irec).ngqa_attrib_name;
        l_ngqa.ngqa_operator     := c_default_operator;
        l_ngqa.ngqa_pre_bracket  := NULL;
        l_ngqa.ngqa_post_bracket := NULL;
        l_ngqa.ngqa_condition    := get_basic_search_condition(pi_ngqt_item_type
                                                              ,po_qry_search_attribs(irec).ngqa_attrib_name);

        nm3ins.ins_ngqa(p_rec_ngqa => l_ngqa);

        insert_attrib_value(irec);

      END IF;
    END IF;
  END LOOP;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'upd_basic_search_attribs');


END upd_basic_search_attribs;
--
-----------------------------------------------------------------------------
--
FUNCTION asc_or_desc RETURN varchar2 IS
BEGIN
  IF g_ascending THEN
    RETURN 'ASC';
  ELSE
    RETURN 'DESC';
  END IF;
END asc_or_desc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_order_by_clause RETURN varchar2 IS
  l_retval              varchar2(200);
BEGIN
  IF g_order_by_clause IS NOT NULL THEN
  --
    IF nm3get.get_ita( pi_ita_inv_type    => g_inv_type
                     , pi_ita_attrib_name => get_ft_col(g_order_by_clause, g_is_ft)
                     , pi_raise_not_found => FALSE
                     ).ita_id_domain IS NULL
    THEN
    --
      CASE nm3inv.get_attrib_format(pi_inv_type => g_inv_type
                                   ,pi_attrib_name => get_ft_col(g_order_by_clause, g_is_ft))
        WHEN 'NUMBER' THEN
          l_retval := 'TO_NUMBER('||g_order_by_clause||')'||nm3type.c_space||asc_or_desc||nm3type.c_space||c_nulls_last;
        WHEN 'DATE' THEN
          l_retval := 'TO_DATE('||g_order_by_clause||')'||nm3type.c_space||asc_or_desc||nm3type.c_space||c_nulls_last;
        ELSE
          l_retval := g_order_by_clause||nm3type.c_space||asc_or_desc||nm3type.c_space||c_nulls_last;
      END CASE;
    --
    ELSE
    --
      l_retval := g_order_by_clause||nm3type.c_space||asc_or_desc||nm3type.c_space||c_nulls_last;
    --
    END IF;
  ELSE
    l_retval := NULL;
  END IF;

    nm_debug.debug_on;
    nm_debug.debug('2g_inv_type: ' || g_inv_type);
    nm_debug.debug_off;

  RETURN l_retval;
END get_order_by_clause;
--
-----------------------------------------------------------------------------
--
FUNCTION get_order_by_column RETURN varchar2 IS
BEGIN
  RETURN g_order_by_clause;
END get_order_by_column;
--
-----------------------------------------------------------------------------
--
FUNCTION set_order_by_clause (p_order_by IN all_tab_columns.column_name%TYPE) RETURN pls_integer IS
  l_retval pls_integer := c_ascending;
BEGIN
  IF g_order_by_clause = p_order_by AND g_order_by_clause IS NOT NULL THEN
    -- flip order by clause
    IF g_ascending THEN

      g_ascending := FALSE;
      l_retval := c_descending;
    ELSE
      g_ascending := TRUE;
      l_retval := c_ascending;
    END IF;
  END IF;

  g_order_by_clause := p_order_by;

  RETURN l_retval;

END set_order_by_clause;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_order_by_clause (p_order_by IN all_tab_columns.column_name%TYPE) IS
  l_retval pls_integer;
BEGIN
  l_retval := set_order_by_clause(p_order_by => p_order_by);
END set_order_by_clause;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_ft_mapping IS
BEGIN
  FOR irec IN 1..g_ft_mapping.COUNT LOOP
    g_ft_mapping(irec).assigned := FALSE;
    g_ft_mapping(irec).ft_col_name := NULL;
  END LOOP;
END clear_ft_mapping;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ft_col (pi_inv_col   IN all_tab_columns.column_name%TYPE
                    ,pi_inv_is_ft IN boolean) RETURN varchar2 IS
  l_retval all_tab_columns.column_name%TYPE;
BEGIN

  IF NOT pi_inv_is_ft THEN
   l_retval := pi_inv_col;
  ELSE

    FOR irec IN 1..g_ft_mapping.COUNT LOOP
      IF g_ft_mapping(irec).inv_col_name = pi_inv_col
      AND g_ft_mapping(irec).assigned THEN
        l_retval := g_ft_mapping(irec).ft_col_name;
      END IF;
    END LOOP;
  END IF;

  RETURN l_retval;
END get_ft_col;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_col (pi_ft_col IN all_tab_columns.column_name%TYPE
                     ,pi_inv_is_ft IN boolean) RETURN varchar2 IS
  l_retval all_tab_columns.column_name%TYPE;
BEGIN

  IF NOT pi_inv_is_ft THEN
    RETURN pi_ft_col;
  END IF;

  FOR irec IN 1..g_ft_mapping.COUNT LOOP
    IF g_ft_mapping(irec).ft_col_name = pi_ft_col
    AND g_ft_mapping(irec).assigned THEN
      l_retval := g_ft_mapping(irec).inv_col_name;
    END IF;
  END LOOP;

  RETURN l_retval;
END get_inv_col;
--
-----------------------------------------------------------------------------
--
PROCEDURE map_pk (p_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) IS
  l_ind_ne_id pls_integer;
  l_ind_pk_id pls_integer;
  l_pk_col nm_inv_types_all.nit_foreign_pk_column%TYPE := nm3get.get_nit(pi_nit_inv_type => p_inv_type).nit_foreign_pk_column;
BEGIN
  FOR irec IN 1..g_ft_mapping.COUNT LOOP
    IF g_ft_mapping(irec).inv_col_name = 'IIT_NE_ID' THEN
      l_ind_ne_id := irec;
    END IF;

    IF g_ft_mapping(irec).inv_col_name = 'IIT_PRIMARY_KEY' THEN
      l_ind_pk_id := irec;
    END IF;
  END LOOP;

  IF l_ind_ne_id IS NOT NULL THEN
    g_ft_mapping(l_ind_ne_id).assigned := TRUE;
    g_ft_mapping(l_ind_ne_id).ft_col_name := l_pk_col;
  END IF;

  IF l_ind_pk_id IS NOT NULL THEN
    g_ft_mapping(l_ind_pk_id).assigned := TRUE;
    g_ft_mapping(l_ind_pk_id).ft_col_name := l_pk_col;
  END IF;
END map_pk;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_available_map_column RETURN varchar2 IS
 e_too_many_attribs EXCEPTION;
 l_found            boolean := FALSE;
 l_retval           pls_integer;
BEGIN
  FOR irec IN 1..g_ft_mapping.COUNT LOOP
    IF NOT g_ft_mapping(irec).assigned THEN
      l_found  := TRUE;
      l_retval := irec;
    END IF;
  END LOOP;

  IF NOT l_found THEN
    RAISE e_too_many_attribs;
  END IF;

  RETURN l_retval;
EXCEPTION
  WHEN e_too_many_attribs THEN
    hig.raise_ner(nm3type.c_net
                 ,398);
END get_next_available_map_column;
--
-----------------------------------------------------------------------------
--
PROCEDURE assign_map_column(p_col    IN all_tab_columns.column_name%TYPE
                           ,p_format IN nm_inv_type_attribs_all.ita_format%TYPE) IS
  --l_matched_col pls_integer;
  lv_inv_col all_tab_columns.column_name%TYPE;
BEGIN
  --l_matched_col := get_next_available_map_column;
  lv_inv_col := nm3ft_mapping.get_iit_attrib_column(pi_ft_col => p_col
                                                   ,pi_format => p_format);
  FOR i IN 1..g_ft_mapping.count LOOP
    IF g_ft_mapping(i).inv_col_name = lv_inv_col
     THEN
        g_ft_mapping(i).assigned    := TRUE;
        g_ft_mapping(i).ft_col_name := p_col;
        exit;
    END IF;
  END LOOP;
  --
END assign_map_column;
--
-----------------------------------------------------------------------------
--
PROCEDURE apply_ft_cols_to_inv_attr(pi_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) IS
l_cols nm3inv.tab_nita := nm3inv.get_tab_ita_displayed(p_inv_type => pi_inv_type);
BEGIN
  -- clear mapping table
  clear_ft_mapping;
  nm3ft_mapping.map_ft_to_iit(pi_inv_type => pi_inv_type);
  --
  -- map the primary key
  map_pk(pi_inv_type);
  --
  FOR irec IN 1..l_cols.COUNT LOOP
  -- assign cols to attributes
    assign_map_column(l_cols(irec).ita_attrib_name
                     ,l_cols(irec).ita_format);
  END LOOP;
END apply_ft_cols_to_inv_attr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_fixed_cols(pi_inv_type IN nm_inv_types_all.nit_inv_type%TYPE
                       ,p_ft IN boolean) RETURN nm3type.tab_varchar30 IS
  l_retval nm3type.tab_varchar30;
  l_count pls_integer;
--
  PROCEDURE add(p_col IN varchar2) IS
  BEGIN
    l_count := NVL(l_count,0) +1;
    l_retval(l_count) := p_col;

  END add;
--
BEGIN

  add('IIT_NE_ID');

  IF NOT p_ft THEN
    IF NOT nm3inv.attrib_in_use(pi_inv_type, 'IIT_PRIMARY_KEY') THEN
      add('IIT_PRIMARY_KEY');
    END IF;

    add('IIT_DESCR');
  END IF;

  RETURN l_retval;

END get_fixed_cols;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_inv_tab_from_gdo
             ( pi_session_id IN  gis_data_objects.gdo_session_id%TYPE
             , pi_inv_type   IN  nm_inv_items_all.iit_inv_type%TYPE)
IS
  c_cursor_name CONSTANT varchar2(30) := 'c_get_inv';

  l_nit         nm_inv_types_all%ROWTYPE := nm3get.get_nit(pi_inv_type);
  l_ft_inv      boolean := l_nit.nit_table_name IS NOT NULL;
  l_data_source varchar2(30);
  l_fixed_cols  nm3type.tab_varchar30;
  l_attrs       nm3inv.tab_nita := nm3inv.get_tab_ita_displayed(p_inv_type => pi_inv_type);

BEGIN
--
  --nm_debug.debug_on;
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'populate_inv_tab_from_gdo');
--
  clear_all;
  l_fixed_cols := get_fixed_cols(pi_inv_type, l_ft_inv);
  g_inv_attrs  := nm3inv.get_tab_ita(pi_inv_type);
  populate_lookups_for_type(pi_inv_type);

  g_inv_type := pi_inv_type;
  g_is_ft := l_ft_inv;

  IF l_ft_inv THEN
    nm3locator.apply_ft_cols_to_inv_attr(pi_inv_type);
  END IF;

  nm3locator.debug_map_table;

  add('DECLARE');
  add('');

  IF l_ft_inv THEN
    l_data_source := 'l_rec_ft';
    add('   '||l_data_source||' '||l_nit.nit_table_name||'%ROWTYPE;');

    add('  CURSOR '||c_cursor_name||' (pi_session_id IN gis_data_objects.gdo_session_id%TYPE) IS');
    add('  SELECT ft.*');
    add('   FROM  '||l_nit.nit_table_name|| ' ft');
    add('  WHERE  ft.'||l_nit.nit_foreign_pk_column||' IN (SELECT gdo.gdo_pk_id ');
    add('                                                  FROM   gis_data_objects gdo ');
    add('                                                  WHERE  gdo.gdo_session_id = pi_session_id);');

  ELSE

    l_data_source := 'nm3locator.g_inv_rec';

    add('  CURSOR '||c_cursor_name||' (pi_session_id IN gis_data_objects.gdo_session_id%TYPE) IS');
    add('  SELECT /*+ INDEX(iit inv_items_all_pk) */ iit.* ');
    add('  FROM  nm_inv_items iit ');
    add('  WHERE iit.iit_ne_id IN (SELECT gdo.gdo_pk_id ');
    add('                          FROM   gis_data_objects gdo ');
    add('                          WHERE  gdo.gdo_session_id = pi_session_id);');
  END IF;

  add('');
  add('BEGIN');

  add('  FOR irec IN '||c_cursor_name||'('||pi_session_id||')  LOOP');

  -- assign inv type

  add('  INSERT INTO '||c_results_table||' (');
  add('  iit_inv_type');
  FOR irec IN 1..l_fixed_cols.COUNT LOOP
    add('  ,'||l_fixed_cols(irec));
  END LOOP;

  -- assign primary key value
  IF l_ft_inv THEN
    add('  ,iit_primary_key');
  ELSE
    add('  ,iit_start_date');
    add('  ,iit_end_date');
    add('  ,iit_admin_unit');
    add('  ,iit_x_sect');
  END IF;

  FOR i_attr IN 1..l_attrs.COUNT LOOP
    -- now the attribs
    add('  ,'||nm3locator.get_inv_col(l_attrs(i_attr).ita_attrib_name,nm3locator.g_is_ft));
  END LOOP;

  add('  ) VALUES (');
  add(  ''''||pi_inv_type||'''');

  FOR irec IN 1..l_fixed_cols.COUNT LOOP
    add('  ,irec.'||nm3locator.get_ft_col(l_fixed_cols(irec), nm3locator.g_is_ft));
  END LOOP;

  -- assign primary key value
  IF l_ft_inv THEN
    add('  ,irec.'||nm3locator.get_ft_col('IIT_NE_ID', nm3locator.g_is_ft));
  ELSE
    add('  ,irec.iit_start_date');
    add('  ,irec.iit_end_date');
    add('  ,irec.iit_admin_unit');
    add('  ,irec.iit_x_sect');
  END IF;

  FOR i_attr IN 1..l_attrs.COUNT LOOP
    -- now the attribs
    IF l_attrs(i_attr).ita_id_domain IS NOT NULL THEN
      -- lookup the meaning');
      add('  ,nm3locator.get_meaning_from_lookup('''||l_attrs(i_attr).ita_id_domain||''', irec.'||l_attrs(i_attr).ita_attrib_name||')');
    ELSE
      IF  l_attrs(i_attr).ita_format = 'DATE' THEN
        --CWS 03/11/10
        IF nm3flx.get_column_datatype( pi_table_name  => NVL(l_nit.nit_table_name, 'NM_INV_ITEMS_ALL')
                                     , pi_column_name => l_attrs(i_attr).ita_attrib_name) = 'DATE'
        THEN
          add('  ,TO_CHAR(irec.'||l_attrs(i_attr).ita_attrib_name||','''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||''')');
        ELSE
          add('  ,TO_CHAR(TO_DATE(irec.'||l_attrs(i_attr).ita_attrib_name||','''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||'''),'''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||''')');
        END IF;
      ELSE
        add('  ,SUBSTR(irec.'||l_attrs(i_attr).ita_attrib_name||',1,80)');
      END IF;
    END IF;
  END LOOP;

  add('  );');
  add('  END LOOP;');
  add('END;');

  debug_sql;
  execute_sql;
--
  nm_debug.proc_end  (p_package_name   => g_package_name
                     ,p_procedure_name => 'populate_inv_tab_from_gdo');
  --nm_debug.debug_off;
--
END populate_inv_tab_from_gdo;
--
-----------------------------------------------------------------------------
--
--PROCEDURE populate_inv_tab_from_gaz_qry(pi_ngqi_job_id IN  nm_gaz_query_item_list.ngqi_job_id%TYPE
--                                       ,pi_inv_type    IN  nm_inv_items_all.iit_inv_type%TYPE) IS
--
--  c_cursor_name CONSTANT varchar2(30) := 'c_get_inv';
--
--  l_nit         nm_inv_types_all%ROWTYPE := nm3get.get_nit(pi_inv_type);
--  l_ft_inv      boolean := l_nit.nit_table_name IS NOT NULL;
--  l_data_source varchar2(30);
--  l_fixed_cols  nm3type.tab_varchar30;
--  l_attrs       nm3inv.tab_nita := nm3inv.get_tab_ita_displayed(p_inv_type => pi_inv_type);
--
--BEGIN
--  nm_debug.debug_on;
--  nm_debug.debug('## Start Locator Results ');
--  nm_debug.debug_off;
--  
--  nm_debug.proc_start(p_package_name   => g_package_name
--                     ,p_procedure_name => 'populate_inv_tab_from_gaz_qry');
--
--  clear_all;
--
--  l_fixed_cols := get_fixed_cols(pi_inv_type, l_ft_inv);
--
--  g_inv_attrs := nm3inv.get_tab_ita(pi_inv_type);
--  populate_lookups_for_type(pi_inv_type);
--
--  g_inv_type := pi_inv_type;
--  g_is_ft := l_ft_inv;
--
--  IF l_ft_inv THEN
--    nm3locator.apply_ft_cols_to_inv_attr(pi_inv_type);
--  END IF;
--
--  nm3locator.debug_map_table;

--  add('DECLARE');
--
--  IF l_ft_inv THEN
--    l_data_source := 'l_rec_ft';
--    add('   '||l_data_source||' '||l_nit.nit_table_name||'%ROWTYPE;');
--
--    add('  CURSOR '||c_cursor_name||' (p_job_id IN nm_gaz_query_item_list.ngqi_job_id%TYPE) IS');
--    add('  SELECT ft.*');
--    add('   FROM  nm_gaz_query_item_list');
--    add('         ,'||l_nit.nit_table_name|| ' ft');
--    add('  WHERE  ft.'||l_nit.nit_foreign_pk_column||' = ngqi_item_id');
--    add('  AND   ngqi_job_id = p_job_id');
--    add('  AND   NGQI_ITEM_TYPE_TYPE = '||nm3flx.string('I'));
--    add('  AND   NGQI_ITEM_TYPE      = '||nm3flx.string(pi_inv_type)||';');
--
--  ELSE
--
--    l_data_source := 'nm3locator.g_inv_rec';
--
--    add('  CURSOR '||c_cursor_name||' (p_job_id IN nm_gaz_query_item_list.ngqi_job_id%TYPE) IS');
--    add('  SELECT /*+ INDEX(iit inv_items_all_pk) */ iit.* ');
--    add('  FROM  nm_gaz_query_item_list ');
--    add('       ,nm_inv_items iit ');
--    add('  WHERE ngqi_item_id = iit_ne_id');
--    add('  AND   ngqi_job_id = p_job_id');
--    add('  AND   NGQI_ITEM_TYPE_TYPE = '||nm3flx.string('I'));
--    add('  AND   NGQI_ITEM_TYPE      = '||nm3flx.string(pi_inv_type)||';');
--
--  END IF;
--
--  add('BEGIN');
--
--  add('  FOR irec IN '||c_cursor_name||'('||pi_ngqi_job_id||')  LOOP');
--
--  -- assign inv type
--
--  add('  INSERT INTO '||c_results_table||' (');
--  add('  iit_inv_type');
--  FOR irec IN 1..l_fixed_cols.COUNT LOOP
--    add('  ,'||l_fixed_cols(irec));
--  END LOOP;
--
--  -- assign primary key value
--  IF l_ft_inv THEN
--    add('  ,iit_primary_key');
--  ELSE
--    add('  ,iit_start_date');
--    add('  ,iit_end_date');
--    add('  ,iit_admin_unit');
--    add('  ,iit_x_sect');
--  END IF;
--
--  FOR i_attr IN 1..l_attrs.COUNT LOOP
--    -- now the attribs
--    add('  ,'||nm3locator.get_inv_col(l_attrs(i_attr).ita_attrib_name,nm3locator.g_is_ft));
--  END LOOP;
--
--  add('  ) VALUES (');
--  add(  ''''||pi_inv_type||'''');
--
--  FOR irec IN 1..l_fixed_cols.COUNT LOOP
--    add('  ,irec.'||nm3locator.get_ft_col(l_fixed_cols(irec), nm3locator.g_is_ft));
--  END LOOP;
--
--  -- assign primary key value
--  IF l_ft_inv THEN
--    add('  ,irec.'||nm3locator.get_ft_col('IIT_NE_ID', nm3locator.g_is_ft));
--  ELSE
--    add('  ,irec.iit_start_date');
--    add('  ,irec.iit_end_date');
--    add('  ,irec.iit_admin_unit');
--    add('  ,irec.iit_x_sect');
--  END IF;
--
--  FOR i_attr IN 1..l_attrs.COUNT LOOP
--    -- now the attribs
--    IF l_attrs(i_attr).ita_id_domain IS NOT NULL THEN
--      -- lookup the meaning');
--      add('  ,nm3locator.get_meaning_from_lookup('''||l_attrs(i_attr).ita_id_domain||''', irec.'||l_attrs(i_attr).ita_attrib_name||')');
--    ELSE
--      IF  l_attrs(i_attr).ita_format = 'DATE' THEN
--        add('  ,TO_CHAR(irec.'||l_attrs(i_attr).ita_attrib_name||','''||c_date_format||''')');
--      ELSE
--        add('  ,SUBSTR(irec.'||l_attrs(i_attr).ita_attrib_name||',1,80)');
--      END IF;
--    END IF;
--  END LOOP;
--
--  add('  );');
--  add('  END LOOP;');
--  add('END;');
--
--  nm_debug.debug_on;
--  nm_debug.debug('## End Locator Results ');
--  nm_debug.debug_off;
--  
--  debug_sql;
--  execute_sql;
--
--  nm_debug.proc_end(p_package_name   => g_package_name
--                   ,p_procedure_name => 'populate_inv_tab_from_gaz_qry');
----  nm_debug.debug_off;
--END populate_inv_tab_from_gaz_qry;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_inv_tab_from_gaz_qry(pi_ngqi_job_id IN  nm_gaz_query_item_list.ngqi_job_id%TYPE
                                       ,pi_inv_type    IN  nm_inv_items_all.iit_inv_type%TYPE) IS

  c_cursor_name CONSTANT varchar2(30) := 'c_get_inv';

  l_nit         nm_inv_types_all%ROWTYPE := nm3get.get_nit(pi_inv_type);
  l_ft_inv      boolean := l_nit.nit_table_name IS NOT NULL;
  l_data_source varchar2(30);
  l_fixed_cols  nm3type.tab_varchar30;
  l_attrs       nm3inv.tab_nita := nm3inv.get_tab_ita_displayed(p_inv_type => pi_inv_type);

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'populate_inv_tab_from_gaz_qry');

  clear_all;

  l_fixed_cols := get_fixed_cols(pi_inv_type, l_ft_inv);

  g_inv_attrs := nm3inv.get_tab_ita(pi_inv_type);
  populate_lookups_for_type(pi_inv_type);

  g_inv_type := pi_inv_type;
  g_is_ft := l_ft_inv;

  IF l_ft_inv THEN
    nm3locator.apply_ft_cols_to_inv_attr(pi_inv_type);
  END IF;

--  nm3locator.debug_map_table;

  add('BEGIN');

  l_data_source := 'l_rec_ft';
  add('  INSERT INTO '||c_results_table||' (');
  add('  iit_inv_type');
  FOR irec IN 1..l_fixed_cols.COUNT LOOP
    add('  ,'||l_fixed_cols(irec));
  END LOOP;

-- assign primary key value
  IF l_ft_inv THEN
    add('  ,iit_primary_key');
  ELSE
    add('  ,iit_start_date');
    add('  ,iit_end_date');
    add('  ,iit_admin_unit');
    add('  ,iit_x_sect');
  END IF;

  FOR i_attr IN 1..l_attrs.COUNT LOOP
    -- now the attribs
    add('  ,'||nm3locator.get_inv_col(l_attrs(i_attr).ita_attrib_name,nm3locator.g_is_ft));
  END LOOP;

  add('  ) ');

  IF l_ft_inv 
  THEN

    add('  SELECT ');
    add(  ''''||pi_inv_type||'''');

    FOR irec IN 1..l_fixed_cols.COUNT LOOP
      add('  ,ft.'||nm3locator.get_ft_col(l_fixed_cols(irec), nm3locator.g_is_ft));
    END LOOP;

    -- assign primary key value
    IF l_ft_inv THEN
      add('  ,ft.'||nm3locator.get_ft_col('IIT_NE_ID', nm3locator.g_is_ft));
    ELSE
      add('  ,ft.iit_start_date');
      add('  ,ft.iit_end_date');
      add('  ,ft.iit_admin_unit');
      add('  ,ft.iit_x_sect');
    END IF;

    FOR i_attr IN 1..l_attrs.COUNT LOOP
      -- now the attribs
      IF l_attrs(i_attr).ita_id_domain IS NOT NULL THEN
        -- lookup the meaning');
        add('  ,nm3locator.get_meaning_from_lookup('''||l_attrs(i_attr).ita_id_domain||''', ft.'||l_attrs(i_attr).ita_attrib_name||')');
      ELSE
        IF  l_attrs(i_attr).ita_format = 'DATE' THEN
          --CWS 03/11/10
          --add('  ,TO_CHAR(ft.'||l_attrs(i_attr).ita_attrib_name||','''||c_date_format||''')');
          IF nm3flx.get_column_datatype(pi_table_name => l_nit.nit_table_name
                                       ,pi_column_name => l_attrs(i_attr).ita_attrib_name) = 'DATE'
          THEN
            add('  ,TO_CHAR(ft.'||l_attrs(i_attr).ita_attrib_name||','''||Sys_Context('NM3CORE','USER_DATE_MASK')||''')');
          ELSE
            add('  ,TO_CHAR(TO_DATE(ft.'||l_attrs(i_attr).ita_attrib_name||','''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||'''),'''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||''')');
          END IF;
        ELSE
          add('  ,SUBSTR(ft.'||l_attrs(i_attr).ita_attrib_name||',1,80)');
        END IF;
      END IF;
    END LOOP;
    add('   FROM  nm_gaz_query_item_list');
    add('         ,'||l_nit.nit_table_name|| ' ft');
    add('  WHERE  ft.'||l_nit.nit_foreign_pk_column||' = ngqi_item_id');
    add('  AND   ngqi_job_id = '||pi_ngqi_job_id);
    add('  AND   NGQI_ITEM_TYPE_TYPE = '||nm3flx.string('I'));
    add('  AND   NGQI_ITEM_TYPE      = '||nm3flx.string(pi_inv_type)||';');

  ELSE

    l_data_source := 'nm3locator.g_inv_rec';

    add('  SELECT ');
    add(  ''''||pi_inv_type||'''');
    FOR irec IN 1..l_fixed_cols.COUNT LOOP
      add('  ,iit.'||nm3locator.get_ft_col(l_fixed_cols(irec), nm3locator.g_is_ft));
    END LOOP;
    add('  ,iit.iit_start_date');
    add('  ,iit.iit_end_date');
    add('  ,iit.iit_admin_unit');
    add('  ,iit.iit_x_sect');
  --
    FOR i_attr IN 1..l_attrs.COUNT LOOP
      -- now the attribs
      IF l_attrs(i_attr).ita_id_domain IS NOT NULL THEN
        -- lookup the meaning');
        add('  ,nm3locator.get_meaning_from_lookup('''||l_attrs(i_attr).ita_id_domain||''', iit.'||l_attrs(i_attr).ita_attrib_name||')');
      ELSE
        IF  l_attrs(i_attr).ita_format = 'DATE' THEN
          --CWS 03/11/10
          --add('  ,TO_CHAR(iit.'||l_attrs(i_attr).ita_attrib_name||','''||c_date_format||''')');
          IF nm3flx.get_column_datatype(pi_table_name => 'NM_INV_ITEMS'
                                       ,pi_column_name => l_attrs(i_attr).ita_attrib_name) = 'DATE'
          THEN
            add('  ,TO_CHAR(iit.'||l_attrs(i_attr).ita_attrib_name||','''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||''')');
          ELSE
            add('  ,TO_CHAR(TO_DATE(iit.'||l_attrs(i_attr).ita_attrib_name||','''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||'''),'''||NVL(l_attrs(i_attr).ita_format_mask, Sys_Context('NM3CORE','USER_DATE_MASK'))||''')');
          END IF;
        ELSE
          add('  ,SUBSTR(iit.'||l_attrs(i_attr).ita_attrib_name||',1,80)');
        END IF;
      END IF;
    END LOOP;
    add('  FROM  nm_gaz_query_item_list ');
    add('       ,nm_inv_items iit ');
    add('  WHERE ngqi_item_id = iit_ne_id');
    add('  AND   ngqi_job_id = '||pi_ngqi_job_id);
    add('  AND   NGQI_ITEM_TYPE_TYPE = '||nm3flx.string('I'));
    add('  AND   NGQI_ITEM_TYPE      = '||nm3flx.string(pi_inv_type)||';');

  END IF;

  add('END;');

--debug_sql;
--  nm_debug.debug_on;
  nm_debug.debug('populate_inv_tab_from_gaz_qry start SQL');
--  nm_debug.debug_off;

  execute_sql;

--  nm_debug.debug_on;
  nm_debug.debug('populate_inv_tab_from_gaz_qry finished SQL');
--  nm_debug.debug_off;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'populate_inv_tab_from_gaz_qry');
--  nm_debug.debug_off;
END populate_inv_tab_from_gaz_qry;
--
-----------------------------------------------------------------------------
--
PROCEDURE populate_lookups_for_type(pi_type IN nm_inv_types_all.nit_inv_type%TYPE) IS
CURSOR get_all_vals_for_type (pi_type IN nm_inv_types_all.nit_inv_type%TYPE) IS
SELECT ial_domain, ial_value, ial_meaning
FROM nm_inv_attri_lookup_all
WHERE ial_domain IN (SELECT ita_id_domain
                     FROM   nm_inv_type_attribs
                     WHERE  ita_inv_type = pi_type
                     AND    ita_id_domain IS NOT NULL);
l_count pls_integer := 0;
BEGIN

  FOR irec IN get_all_vals_for_type(pi_type) LOOP
    l_count := l_count + 1;
    g_tab_lookup(l_count).ial_domain  := irec.ial_domain;
    g_tab_lookup(l_count).ial_value   := irec.ial_value;
    g_tab_lookup(l_count).ial_meaning := irec.ial_meaning;
  END LOOP;

END populate_lookups_for_type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_max_length_of_lookup(p_domain IN nm_inv_attri_lookup_all.ial_domain%TYPE) RETURN pls_integer IS
l_retval pls_integer := 0;
l_length pls_integer;
BEGIN

  FOR irec IN 1..g_tab_lookup.COUNT LOOP
    IF g_tab_lookup(irec).ial_domain = p_domain THEN
      l_length := NVL(LENGTH(g_tab_lookup(irec).ial_meaning),0);
      IF l_length > l_retval THEN
         l_retval := l_length;
      END IF;
    END IF;
  END LOOP;

  RETURN l_retval;
END get_max_length_of_lookup;
--
-----------------------------------------------------------------------------
--
FUNCTION get_meaning_from_lookup(p_domain IN nm_inv_attri_lookup_all.ial_domain%TYPE
                                ,p_value  IN nm_inv_attri_lookup_all.ial_value%TYPE) RETURN nm_inv_attri_lookup_all.ial_meaning%TYPE IS
l_retval loc_disp_length;
BEGIN
  FOR i IN 1..g_tab_lookup.COUNT LOOP
    IF g_tab_lookup(i).ial_domain = p_domain AND g_tab_lookup(i).ial_value = p_value THEN
      l_retval := g_tab_lookup(i).ial_meaning;
    END IF;
  END LOOP;

  RETURN l_retval;
END get_meaning_from_lookup;
--
-----------------------------------------------------------------------------
--
FUNCTION get_index_of_attr(p_attribute IN nm_inv_type_attribs_all.ita_attrib_name%TYPE) RETURN pls_integer IS
l_retval pls_integer;
l_attrib nm_inv_type_attribs_all.ita_attrib_name%TYPE;
BEGIN

  l_attrib := get_ft_col(p_attribute, g_is_ft);
  FOR irec IN 1..g_inv_attrs.COUNT LOOP
    IF g_inv_attrs(irec).ita_attrib_name = l_attrib THEN
      l_retval := irec;
    END IF;
  END LOOP;

  RETURN l_retval;
END get_index_of_attr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_disp_width_of_attr(p_attribute IN nm_inv_type_attribs_all.ita_attrib_name%TYPE) RETURN number IS
l_retval number := 0;
l_pos pls_integer;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_disp_width_of_attr');

  l_pos := get_index_of_attr(p_attribute);
  IF l_pos IS NOT NULL THEN
    IF g_inv_attrs(l_pos).ita_disp_width IS NOT NULL THEN
      l_retval := g_inv_attrs(l_pos).ita_disp_width * c_disp_units_per_char;
    ELSIF g_inv_attrs(l_pos).ita_id_domain IS NOT NULL THEN
      l_retval := get_max_length_of_lookup(g_inv_attrs(l_pos).ita_id_domain) * c_disp_units_per_char;
    ELSE
      l_retval := g_inv_attrs(l_pos).ita_fld_length * c_disp_units_per_char;
    END IF;

    -- add a bit on for small fields
    IF l_retval < 0.5 THEN
      l_retval := l_retval + c_disp_units_per_char;
    END IF;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_disp_width_of_attr');
  RETURN l_retval;

END get_disp_width_of_attr;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attr_prompt(p_attribute IN nm_inv_type_attribs_all.ita_attrib_name%TYPE) RETURN varchar2 IS

l_retval      nm_inv_type_attribs_all.ita_scrn_text%TYPE;
l_pos         pls_integer;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_attr_prompt');

  l_pos := get_index_of_attr(p_attribute);
  IF l_pos IS NOT NULL THEN
      l_retval := g_inv_attrs(l_pos).ita_scrn_text;
  END IF;

  IF l_retval IS NULL AND p_attribute = 'IIT_PRIMARY_KEY' THEN
    l_retval := 'Asset Id';
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_attr_prompt');
  RETURN l_retval;

END get_attr_prompt;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_inv_detail_record(p_iit_ne_id IN nm_inv_items_all.iit_ne_id%TYPE) IS
  -- only cache the whole row when it is not FT inventory
BEGIN
  IF NOT g_is_ft THEN
    g_inv_rec := nm3get.get_iit(pi_iit_ne_id => p_iit_ne_id);
  ELSE
    -- record the primary key
    g_inv_rec.iit_ne_id := p_iit_ne_id;
  END IF;
END set_inv_detail_record;
--
-----------------------------------------------------------------------------
--
FUNCTION get_attr_detail(pi_inv_type  IN nm_inv_types_all.nit_inv_type%TYPE
                        ,pi_attribute IN nm_inv_type_attribs_all.ita_attrib_name%TYPE) RETURN varchar2 IS
l_pos pls_integer;
l_nit nm_inv_types_all%ROWTYPE := nm3get.get_nit(pi_inv_type);
--
PROCEDURE select_it IS
BEGIN
  add('SELECT');
  IF g_is_ft THEN
    add(get_ft_col(pi_attribute));
  ELSE
    add(pi_attribute);
  END IF;

  add('INTO nm3locator.g_attr_detail');
  add('FROM '||NVL(l_nit.nit_table_name, 'nm_inv_items_all'));

  IF g_is_ft THEN
    add('WHERE '||get_ft_col('IIT_NE_ID')||' = '||g_inv_rec.iit_ne_id||';');
  ELSE
    add('WHERE iit_ne_id = '||g_inv_rec.iit_ne_id||';');
  END IF;
END select_it;
--
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_attr_detail');
  clear_sql;
  l_pos := get_index_of_attr(pi_attribute);

  add('BEGIN');
  IF l_pos IS NOT NULL THEN
    -- if FT then select it in

    IF g_is_ft THEN
      select_it;
    ELSE

      IF g_inv_attrs(l_pos).ita_id_domain IS NOT NULL THEN
        add('  nm3locator.g_attr_detail := nm3locator.get_meaning_from_lookup('||nm3flx.string(g_inv_attrs(l_pos).ita_id_domain)||', nm3locator.g_inv_rec.'||pi_attribute||');');

      ELSE
        -- no domain just get value
        IF g_inv_attrs(l_pos).ita_format = 'DATE' THEN
          --CWS 03/11/10
          --  add('  nm3locator.g_attr_detail := TO_CHAR(nm3locator.g_inv_rec.'||pi_attribute||', '''||c_date_format||''');');
          IF nm3flx.get_column_datatype(pi_table_name => NVL(l_nit.nit_table_name, 'NM_INV_ITEMS_ALL')
                                       ,pi_column_name => g_inv_attrs(l_pos).ita_attrib_name) = 'DATE'
          THEN
            add('  nm3locator.g_attr_detail := TO_CHAR(nm3locator.g_inv_rec.'||pi_attribute||', '''||Sys_Context('NM3CORE','USER_DATE_MASK')||''');');
          ELSE
            add('  nm3locator.g_attr_detail := TO_CHAR(TO_DATE(nm3locator.g_inv_rec.'||pi_attribute||', '''||Sys_Context('NM3CORE','USER_DATE_MASK')||'''), '''||Sys_Context('NM3CORE','USER_DATE_MASK')||''');');
          END IF;
        ELSE
          -- get full value
          select_it;
          --
        END IF;
      END IF;
    END IF;
    add('END;');
    debug_sql;
    execute_sql;

  ELSIF pi_attribute = 'IIT_DESCR' THEN
    IF NOT g_is_ft THEN
      select_it;
      add('END;');
      debug_sql;
      execute_sql;
    ELSE
      -- no description for FT inventory
      g_attr_detail := NULL;
    END IF;

  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_attr_detail');
  RETURN g_attr_detail;
END get_attr_detail;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_disp_attrs (pi_inv_type IN nm_inv_types_all.nit_inv_type%TYPE) RETURN nm3inv.tab_nita IS
  l_ft    boolean := nm3get.get_nit(pi_inv_type).nit_table_name IS NOT NULL;
  l_attrs nm3inv.tab_nita;
BEGIN
  l_attrs := nm3inv.get_tab_ita_displayed(pi_inv_type);

  IF l_ft THEN
    -- if FT then replace the attribute names with real inventory ones
    FOR irec IN 1..l_attrs.COUNT LOOP
      l_attrs(irec).ita_attrib_name := get_inv_col(l_attrs(irec).ita_attrib_name, l_ft);
    END LOOP;
  END IF;

  RETURN l_attrs;
END get_tab_disp_attrs;
--
-----------------------------------------------------------------------------
--
PROCEDURE instantiate_data IS
  l_tab_cols nm3ddl.tab_atc;
BEGIN

  l_tab_cols := nm3ddl.get_all_columns_for_table(p_table_name => 'NM_INV_ITEMS_ALL');

  -- populate table of inventory columns for use with foreign table inventory
  FOR irec IN 1..l_tab_cols.COUNT LOOP
    g_ft_mapping(irec).inv_col_name := l_tab_cols(irec).column_name;
    g_ft_mapping(irec).assigned     := FALSE;
  END LOOP;

END instantiate_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_temp_table(pi_table_name IN varchar2) IS
BEGIN
  IF pi_table_name IS NOT NULL
    AND nm3ddl.does_object_exist(pi_table_name, 'TABLE') THEN
    EXECUTE IMMEDIATE 'drop table '||pi_table_name;
  END IF;
END drop_temp_table;
--
-----------------------------------------------------------------------------
--
FUNCTION get_temp_table_name RETURN varchar2 IS

l_retval varchar2(30);
c_table_base varchar2(30):= 'LOCATOR_EXPORT$$';

CURSOR get_table_name IS
SELECT count(*) + 1
FROM user_tables
WHERE table_name like c_table_base||'%';

BEGIN
  OPEN get_table_name;
  FETCH get_table_name INTO l_retval;
  CLOSE get_table_name;

  l_retval := c_table_base||l_retval;

  RETURN l_retval;
END get_temp_table_name;
--
-----------------------------------------------------------------------------
--
FUNCTION create_table_of_selected_recs(pi_tab_resc IN nm3type.tab_number) RETURN varchar2 IS
  l_table_name varchar2(30);
BEGIN

  l_table_name := get_temp_table_name;

  -- create a temporary table as a copy of inv_items_all
  -- as a store of the contents of the pl/sql table
  clear_sql;

  add('CREATE TABLE '||l_table_name);
  add('(');
  add('   iit_ne_id    number)');
  debug_sql;
  execute_sql;

  FOR irec IN 1..pi_tab_resc.COUNT LOOP
    clear_sql;
    add('    INSERT INTO '||l_table_name);
    add('    (iit_ne_id)');
    add('    VALUES');
    add('    ('||pi_tab_resc(irec)||')');
    debug_sql;
    execute_sql;
  END LOOP;

  RETURN l_table_name;
END create_table_of_selected_recs;
--
-----------------------------------------------------------------------------
--
FUNCTION make_valid_xml_attr(p_attr IN varchar2) RETURN varchar2 IS
BEGIN
  RETURN TRANSLATE(p_attr, '[-''()+,./:=?;!*#@$_%]', '_______________________');
END make_valid_xml_attr;
--
-----------------------------------------------------------------------------
--
FUNCTION num_result_rows RETURN pls_integer IS
  CURSOR get_rows IS
  SELECT COUNT(*)
   FROM  nm_locator_results;

  l_count_rows pls_integer;
BEGIN
  OPEN get_rows;
  FETCH get_rows INTO l_count_rows;
  CLOSE get_rows;

  RETURN l_count_rows;
END num_result_rows;
--
-----------------------------------------------------------------------------
--
PROCEDURE export_results(pi_format        IN varchar2
                        ,pi_filename      IN varchar2
                        ,pi_selected_only IN boolean
                        ,pi_selected_tab  IN varchar2
                        ,pi_inc_lrm       IN boolean
                        ,pi_pref_lrm      IN varchar2) IS

  l_clob       clob;
  l_table_name varchar2(30);
  l_nuf        nm_upload_files%ROWTYPE;
  l_nit        nm_inv_types_all%ROWTYPE;
  l_pref_lrm   nm_group_types_all.ngt_group_type%TYPE;
  l_attrs      nm3inv.tab_nita;

  e_no_rows        EXCEPTION;
  e_already_loaded EXCEPTION;
--
BEGIN
  nm_debug.debug_on;
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'export_results');

  IF pi_inc_lrm THEN
    l_pref_lrm := pi_pref_lrm;
    nm_debug.debug('the pref lrm is '||l_pref_lrm);
  END IF;

  IF num_result_rows = 0 THEN
    RAISE e_no_rows;
  END IF;
  -- check upload file does not exist

  IF nm3get.get_nuf(pi_name => pi_filename
                   ,pi_raise_not_found => FALSE).name IS NOT NULL THEN
    RAISE e_already_loaded;
  END IF;

  --l_nit   := nm3get.get_nit(g_inv_attrs(1).ita_inv_type);
  --l_attrs := nm3inv.get_tab_ita_displayed(p_inv_type => g_inv_attrs(1).ita_inv_type);
  --
  -- Task 0110708
  -- Stop the above bombing out with no_data_found if there are no flex attributes defined 
  --
  l_nit   := nm3get.get_nit(g_inv_type);
  l_attrs := nm3inv.get_tab_ita_displayed(p_inv_type => g_inv_type);
  l_table_name := get_temp_table_name;


  -- create a temporary table as a copy of inv_items_all
  -- as a store of the contents of the pl/sql table
  clear_sql;

  add('CREATE GLOBAL TEMPORARY TABLE '||l_table_name);
  add('(');
  add('   iit_ne_id    number');
  add('  ,iit_inv_type varchar2(80)');
  add('  ,length       number');
  FOR i_attr IN 1..l_attrs.COUNT LOOP
     -- now the attribs');
    IF l_attrs(i_attr).ita_id_domain IS NOT NULL THEN
      -- column contains domain lookup vals
      -- so set the length to be the lookup val length
      add('   ,'||l_attrs(i_attr).ita_attrib_name|| ' varchar2(80)');
    ELSE
      IF l_attrs(i_attr).ita_format = 'VARCHAR2' THEN
        add('   ,'||l_attrs(i_attr).ita_attrib_name|| ' '|| l_attrs(i_attr).ita_format||'('||' '|| l_attrs(i_attr).ita_fld_length||')');
      ELSE
        add('   ,'||l_attrs(i_attr).ita_attrib_name|| ' '|| l_attrs(i_attr).ita_format);
      END IF;
    END IF;
  END LOOP;

  IF NOT g_is_ft THEN
    -- add mandatory attribs
    add('   ,iit_start_date date');
    add('   ,iit_end_date   date');
    add('   ,iit_admin_unit varchar2(40)');
    add('   ,iit_x_sect     varchar2(4)');
  END IF;
  -- LRM details
  IF pi_inc_lrm THEN
    add('   ,ne_unique      varchar2(30)');
    add('   ,ne_descr       varchar2(240)');
    add('   ,ne_start       number');
    add('   ,ne_end         number');
    add('   ,ne_units       varchar2(20)');
    add('   ,ne_gty_type    varchar2(4)');
  END IF;
  add(')');
  debug_sql;
  execute_sql;

  clear_sql;
  add('DECLARE');
  IF g_is_ft THEN
    add('  l_ft '||l_nit.nit_table_name||'%ROWTYPE;');
  END IF;


    add('  CURSOR c1 IS');
  IF pi_selected_only THEN
    add('  SELECT iit_ne_id FROM '||pi_selected_tab||';');
  ELSE
    add('  SELECT iit_ne_id FROM '||c_results_table||';');
  END IF;
    add('');
    add('  irec nm_inv_items_all.iit_ne_id%TYPE;');

  add('  l_pl_arr nm_placement_array;');
  add('  l_place nm_placement;');

  add('BEGIN');

  add('  OPEN c1;');
  add('  LOOP');
  add('    FETCH c1 INTO irec;');
  add('    EXIT WHEN c1%NOTFOUND;');

  IF g_is_ft THEN
    add('   SELECT * INTO l_ft FROM '||l_nit.nit_table_name||' WHERE '||get_ft_col('IIT_NE_ID')||' = irec;');
  ELSE
    add('   nm3locator.set_inv_detail_record(irec);');
  END IF;

  -- now deal with the placement
  IF pi_inc_lrm THEN
    IF l_pref_lrm IS NOT NULL THEN
      add('    l_pl_arr := nm3pla.get_connected_chunks(irec, '''||l_pref_lrm||''');');
    ELSE
--      add('    l_pl_arr := nm3pla.get_connected_chunks(irec);');
      add('    l_pl_arr := NM3PLA.GET_PLACEMENT_FROM_NE(irec);');
    END IF;
  END IF;

  add('');
  add('    INSERT INTO '||l_table_name||' (');
  add('    -- assign mandatory non attribute vals');
  add('     iit_ne_id');
  add('    ,iit_inv_type');

  FOR i_attr IN 1..l_attrs.COUNT LOOP
    -- now the attribs
    add('      ,'||l_attrs(i_attr).ita_attrib_name);
  END LOOP;

  IF NOT g_is_ft THEN
    add('   ,iit_start_date');
    add('   ,iit_end_date  ');
    add('   ,iit_admin_unit');
    add('   ,iit_x_sect    ');
    add('   ,length');
  END IF;

  add('    ) VALUES (');
  IF g_is_ft THEN
    add('    l_ft.'||get_ft_col('IIT_NE_ID'));
    add('   ,'''||l_nit.nit_descr||'''');
    FOR i_attr IN 1..l_attrs.COUNT LOOP
    -- now the attribs'
      add('      ,l_ft.'||l_attrs(i_attr).ita_attrib_name);
    END LOOP;
 --   add('    ,nm3net.get_ne_length(l_ft.'||get_ft_col('IIT_NE_ID')||')');
  ELSE

    add('    nm3locator.g_inv_rec.iit_ne_id');
    add('   ,'''||l_nit.nit_descr||'''');
    FOR i_attr IN 1..l_attrs.COUNT LOOP

      add('      ,nm3locator.get_attr_detail(nm3locator.g_inv_rec.iit_inv_type,'''||get_inv_col(l_attrs(i_attr).ita_attrib_name, g_is_ft)||''')');
    END LOOP;
    add('    ,nm3locator.g_inv_rec.iit_start_date');
    add('    ,nm3locator.g_inv_rec.iit_end_date  ');
    add('    ,nm3net.get_admin_unit_name(nm3locator.g_inv_rec.iit_admin_unit)');
    add('    ,nm3locator.g_inv_rec.iit_x_sect    ');
    add('    ,nm3net.get_ne_length(nm3locator.g_inv_rec.iit_ne_id)');
  END IF;

  add('    );');

  IF pi_inc_lrm THEN
    -- now add the placements
    add('    FOR x IN 1..l_pl_arr.placement_count LOOP');
    add('      l_place := l_pl_arr.npa_placement_array(x);');
    add('      IF x = 1 THEN');
    -- on the first placement update the inventory row that will have already been inserted
    -- for subsequent placements an insert will be required
    add('        UPDATE '||l_table_name);
    add('        SET   ne_unique   = nm3net.get_ne_unique(l_place.pl_ne_id)');
    add('             ,ne_descr    = nm3net.get_ne_descr(l_place.pl_ne_id)');
    add('             ,ne_start    = l_place.pl_start');
    add('             ,ne_end      = l_place.pl_end');
    add('             ,ne_units    = nm3unit.get_unit_name(nm3net.get_nt_units_from_ne(  l_place.pl_ne_id ))');
    add('             ,ne_gty_type = nm3net.get_gty_type(l_place.pl_ne_id)');
    add('        WHERE iit_ne_id = irec;');
    add('      ELSE');
    add('        INSERT INTO '||l_table_name);
    add('        (iit_ne_id');
    --
    -- Insert other columns here
    --
    add('    ,iit_inv_type');
    FOR i_attr IN 1..l_attrs.COUNT LOOP
      -- now the attribs
      add('      ,'||l_attrs(i_attr).ita_attrib_name);
    END LOOP;

    IF NOT g_is_ft THEN
      add('   ,iit_start_date');
      add('   ,iit_end_date  ');
      add('   ,iit_admin_unit');
      add('   ,iit_x_sect    ');
      add('   ,length');
    END IF;
    --
    add('        ,ne_unique');
    add('        ,ne_descr');
    add('        ,ne_start');
    add('        ,ne_end');
    add('        ,ne_units');
    add('        ,ne_gty_type)');
    add('        VALUES');
    add('        (irec');
    --
    -- Insert other columns here
    --
    IF g_is_ft THEN
      add('   ,'''||l_nit.nit_descr||'''');
      FOR i_attr IN 1..l_attrs.COUNT LOOP
      -- now the attribs'
        add('      ,l_ft.'||l_attrs(i_attr).ita_attrib_name);
      END LOOP;
      add('    ,nm3net.get_ne_length(l_ft.'||get_ft_col('IIT_NE_ID')||')');
    ELSE
      add('   ,'''||l_nit.nit_descr||'''');
      FOR i_attr IN 1..l_attrs.COUNT LOOP

        add('      ,nm3locator.get_attr_detail(nm3locator.g_inv_rec.iit_inv_type,'''||get_inv_col(l_attrs(i_attr).ita_attrib_name, g_is_ft)||''')');
      END LOOP;
      IF NOT g_is_ft THEN
        add('    ,nm3locator.g_inv_rec.iit_start_date');
        add('    ,nm3locator.g_inv_rec.iit_end_date  ');
        add('    ,nm3net.get_admin_unit_name(nm3locator.g_inv_rec.iit_admin_unit)');
        add('    ,nm3locator.g_inv_rec.iit_x_sect    ');
        add('    ,nm3net.get_ne_length(nm3locator.g_inv_rec.iit_ne_id)');
      END IF;
    END IF;
    --
    add('        ,nm3net.get_ne_unique(l_place.pl_ne_id)');
    add('        ,nm3net.get_ne_descr(l_place.pl_ne_id)');
    add('        ,l_place.pl_start');
    add('        ,l_place.pl_end');
    add('        ,nm3unit.get_unit_name(nm3net.get_nt_units_from_ne(  l_place.pl_ne_id ))');
    add('        ,nm3net.get_gty_type(l_place.pl_ne_id));');
    add('      END IF;');
    add('    END LOOP;');
  END IF;

  add('  END LOOP;');

  add('  CLOSE c1;');
  add('END;');
  debug_sql;
  execute_sql;

  clear_sql;
  -- now the temporary table is populated, construct the query to extract from it
  add(nm3type.c_select|| ' iit_ne_id ');
  add('      ,iit_inv_type as "TYPE" ');

  FOR i_attr IN 1..l_attrs.COUNT LOOP
     IF pi_format = 'XML' THEN
       add('      ,'||l_attrs(i_attr).ita_attrib_name|| ' as "'|| make_valid_xml_attr(REPLACE(l_attrs(i_attr).ita_scrn_text, nm3type.c_space, '_'))||'"');
     ELSE
       add('      ,'||l_attrs(i_attr).ita_attrib_name|| ' as "'|| REPLACE(l_attrs(i_attr).ita_scrn_text, nm3type.c_space, '_')||'"');
     END IF;
  END LOOP;

  IF NOT g_is_ft THEN
    add('      ,iit_start_date');
    add('      ,iit_end_date  ');
    add('      ,iit_admin_unit');
    add('      ,iit_x_sect    ');
  END IF;
  add('      ,length');

  IF pi_inc_lrm THEN
    add('      ,ne_unique');
    add('      ,ne_descr');
    add('      ,ne_start');
    add('      ,ne_end');
    add('      ,ne_units');
    add('      ,ne_gty_type');
  END IF;

  add(nm3type.c_from || nm3type.c_space|| l_table_name);
  IF get_order_by_clause IS NOT NULL THEN
    add(nm3type.c_order_by || nm3type.c_space || get_order_by_clause);
  END IF;

  debug_sql;
  CASE pi_format
    WHEN 'XML' THEN
      hig_hd_query.get_query_as_xml(p_query => l_sql
                                   ,p_xml   => l_clob);
    ELSE
      hig_hd_query.get_query_as_csv(p_query => l_sql
                                   ,p_csv   => l_clob
                                   ,p_include_headers => TRUE);
  END CASE;

  l_nuf.name         := pi_filename;
  l_nuf.blob_content := nm3clob.clob_to_blob(l_clob);

  nm3ins.ins_nuf(l_nuf);

  drop_temp_table(l_table_name);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'export_results');
EXCEPTION
  WHEN e_no_rows THEN
    --nm_debug.debug('Nothing to do');
    NULL;
  WHEN e_already_loaded THEN
    hig.raise_ner(nm3type.c_hig, 397);
  WHEN OTHERS THEN
    nm_debug.debug(SQLERRM);
    drop_temp_table(l_table_name);
    RAISE;
END export_results;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_layer_mbr_array
            ( po_dimname_array OUT nm3type.tab_varchar2000
            , po_ub_array      OUT nm3type.tab_number
            , po_lb_array      OUT nm3type.tab_number
            , po_tolerance     OUT nm3type.tab_number )
IS
  l_dims                mdsys.sdo_dim_array;
  l_dimname_array       nm3type.tab_varchar2000;
  l_ub_array            nm3type.tab_number;
  l_lb_array            nm3type.tab_number;
  l_tolerance           nm3type.tab_number;
  l_diminfo             mdsys.sdo_dim_array;
BEGIN
  l_dims := nm3sdo.coalesce_nw_diminfo;
  --
  l_dimname_array.DELETE;
  l_ub_array.DELETE;
  l_lb_array.DELETE;
  l_tolerance.DELETE;
  --
  FOR i IN 1..l_dims.COUNT
  LOOP
    l_dimname_array(i) := l_dims(i).sdo_dimname;
    l_ub_array(i)      := l_dims(i).sdo_ub;
    l_lb_array(i)      := l_dims(i).sdo_lb;
    l_tolerance(i)     := l_dims(i).sdo_tolerance;
  END LOOP;
  --
  po_dimname_array := l_dimname_array;
  po_ub_array      := l_ub_array;
  po_lb_array      := l_lb_array;
  po_tolerance     := l_tolerance;
EXCEPTION
  WHEN OTHERS
  THEN RAISE_APPLICATION_ERROR
     (-20001,'Error determining MBR ');
END;
--
-----------------------------------------------------------------------------
--
procedure init_display_attrs_lookup(
   pi_inv_type in nm_inv_types_all.nit_inv_type%TYPE)
is
  l_nit_table constant varchar2(30) := nm3get.get_nit(pi_inv_type).NIT_TABLE_NAME;
begin
  -- for foreign table inventory we need to perofm one extra step
  if l_nit_table is not null then
    nm3locator.g_is_ft := true;
    nm3locator.apply_ft_cols_to_inv_attr(pi_inv_type);
  else
     nm3locator.g_is_ft := false;
  end if;
  nm3locator.g_inv_attrs := nm3inv.get_tab_ita(pi_inv_type);
  nm3locator.populate_lookups_for_type(pi_inv_type);
end;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_type_from_gis_session(pi_session_id IN gis_data_objects.gdo_session_id%TYPE)
RETURN nm3type.tab_varchar4 IS

  CURSOR get_inv_types (pi_session_id IN gis_data_objects.gdo_session_id%TYPE) IS
  SELECT nith_nit_id
  FROM   gis_data_objects
        ,nm_themes_all
        ,nm_inv_themes
  WHERE gdo_theme_name = nth_theme_name
  AND   nth_theme_id   = nith_nth_theme_id
  AND   gdo_session_id = pi_session_id
  GROUP BY nith_nit_id;

  l_retval nm3type.tab_varchar4;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_inv_type_from_gis_session');
  OPEN get_inv_types(pi_session_id);
  FETCH get_inv_types BULK COLLECT INTO l_retval;
  CLOSE get_inv_types;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_inv_type_from_gis_session');

  RETURN l_retval;

END get_inv_type_from_gis_session;
--
-----------------------------------------------------------------------------
--
FUNCTION inv_type_is_in_session(pi_session_id IN gis_data_objects.gdo_session_id%TYPE
                               ,pi_inv_type   IN nm_inv_types_all.nit_inv_type%TYPE)
RETURN boolean IS
  l_retval boolean;
  l_types  nm3type.tab_varchar4;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'inv_type_is_in_session');

  -- check that the session contains a single inventory type
  -- and this inventory type is the one passed in

  l_types := get_inv_type_from_gis_session(pi_session_id => pi_session_id);

  IF NVL(l_types.COUNT, 0) = 1 AND l_types(1) = pi_inv_type THEN
    l_retval := TRUE;
  ELSE
    l_retval := FALSE;
  END IF;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'inv_type_is_in_session');

  RETURN l_retval;
END inv_type_is_in_session;
--
-----------------------------------------------------------------------------
--
FUNCTION get_coords_from_session(pi_session_id IN gis_data_objects.gdo_session_id%TYPE
                                ,po_eastings   OUT gis_data_objects.gdo_x_val%TYPE
                                ,po_northings  OUT gis_data_objects.gdo_y_val%TYPE)
RETURN boolean IS
  CURSOR get_coords(p_session_id IN gis_data_objects.gdo_session_id%TYPE) IS
  SELECT gdo_x_val
        ,gdo_y_val
  FROM gis_data_objects g
  WHERE gdo_session_id = p_session_id
  AND   (gdo_x_val IS NOT NULL
        OR gdo_y_val IS NOT NULL);

  l_tab_eastings  nm3type.tab_number;
  l_tab_northings nm3type.tab_number;
  no_data EXCEPTION;
BEGIN
  nm_debug.debug_on;
  nm_debug.debug('Parameters');
  nm_debug.debug('pi_session_id : '||pi_session_id);
  OPEN get_coords(pi_session_id);
  FETCH get_coords BULK COLLECT INTO l_tab_eastings, l_tab_northings;
  CLOSE get_coords;

  IF NOT l_tab_eastings.EXISTS(1) THEN
    RAISE no_data;
  END IF;

  po_eastings := l_tab_eastings(1);
  po_northings := l_tab_northings(1);
  nm_debug.debug('returning true');
  RETURN TRUE;
EXCEPTION
  WHEN no_data THEN
    nm_debug.debug('Returning false');
    RETURN FALSE;
END get_coords_from_session;
--
-----------------------------------------------------------------------------
--
FUNCTION get_multi_coords_from_gdo(pi_session_id IN gis_data_objects.gdo_session_id%TYPE
                                  ,po_coords    OUT nm3sdo_gdo.tab_xys)
RETURN boolean IS
  CURSOR get_coords(p_session_id IN gis_data_objects.gdo_session_id%TYPE) IS
  SELECT gdo_seq_no+1
        ,gdo_x_val
        ,gdo_y_val
  FROM gis_data_objects g
  WHERE gdo_session_id = p_session_id
  AND   (gdo_x_val IS NOT NULL
        OR gdo_y_val IS NOT NULL)
  ORDER BY gdo_seq_no;

  retval  nm3sdo_gdo.tab_xys;
  no_data EXCEPTION;
BEGIN
  nm_debug.debug_on;
  nm_debug.debug('In multi coords proc');
  nm_debug.debug('Parameters');
  nm_debug.debug('pi_session_id : '||pi_session_id);
  OPEN get_coords(pi_session_id);
  FETCH get_coords BULK COLLECT INTO retval;
  CLOSE get_coords;

  IF retval.COUNT = 0 THEN
    RAISE no_data;
  END IF;
  
  po_coords := retval;

  nm_debug.debug('returning true');
  RETURN TRUE;
EXCEPTION
  WHEN no_data THEN
    nm_debug.debug('Returning false');
    RETURN FALSE;
END get_multi_coords_from_gdo;
--
-----------------------------------------------------------------------------
--
FUNCTION refresh_results_from_map(pi_session_id IN gis_data_objects.gdo_session_id%TYPE
                                 ,pi_inv_type   IN nm_inv_types_all.nit_inv_type%TYPE)
RETURN boolean IS
  cannot_refresh EXCEPTION;
BEGIN

  IF NOT inv_type_is_in_session(pi_session_id => pi_session_id
                               ,pi_inv_type   => pi_inv_type) THEN
    RAISE cannot_refresh;
  END IF;

  -- clear the result table
  clear_all;

  -- repopulate
  populate_inv_tab_from_gdo(pi_session_id => pi_session_id
                           ,pi_inv_type   => pi_inv_type);

  RETURN TRUE;
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'refresh_results_from_map');
EXCEPTION
  WHEN cannot_refresh THEN
    RETURN FALSE; -- do not refresh
  WHEN OTHERS THEN
    RETURN FALSE;
END refresh_results_from_map;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_checked_item_list IS
BEGIN
  g_checked_items.DELETE;
END clear_checked_item_list;
--
-----------------------------------------------------------------------------
--
PROCEDURE send_checked_item_to_db(p_item IN nm_inv_items_all.iit_ne_id%TYPE) IS
BEGIN
  g_checked_items.EXTEND;
  g_checked_items(g_checked_items.COUNT) := p_item;
END send_checked_item_to_db;
--
-----------------------------------------------------------------------------
--
FUNCTION get_selected_items
RETURN nm_id_tbl IS
BEGIN
  RETURN g_checked_items;
END get_selected_items;
--
-----------------------------------------------------------------------------
--
PROCEDURE trim_results_to_selected_items IS
BEGIN
  DELETE FROM nm_locator_results
  WHERE NOT EXISTS (SELECT 1
                    FROM TABLE(CAST(nm3locator.get_selected_items AS nm_id_tbl)) a
                    WHERE iit_ne_id = a.column_value);
END trim_results_to_selected_items;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_locator_lov_return(p_retval IN boolean) IS
BEGIN
  g_locator_returned := p_retval;
END set_locator_lov_return;
--
-----------------------------------------------------------------------------
--
FUNCTION locator_lov_return RETURN boolean IS
BEGIN
  RETURN g_locator_returned;
END locator_lov_return;
--
-----------------------------------------------------------------------------
--
PROCEDURE store_coords(pi_eastings               IN    gis_data_objects.gdo_x_val%TYPE
                      ,pi_northings              IN    gis_data_objects.gdo_x_val%TYPE) IS
BEGIN
  g_eastings  := pi_eastings;
  g_northings := pi_northings;
END store_coords;
--
-----------------------------------------------------------------------------
--
PROCEDURE return_stored_coords(po_eastings               OUT    gis_data_objects.gdo_x_val%TYPE
                              ,po_northings              OUT    gis_data_objects.gdo_x_val%TYPE) IS
BEGIN
  IF g_eastings IS NOT NULL
  AND g_northings IS NOT NULL
  THEN
    po_eastings  := g_eastings;
    po_northings := g_northings;
  ELSE
    -- Task 0108887 / 0108889
    IF g_multi_coords.COUNT > 0
    THEN
      po_eastings := g_multi_coords(1).x_coord;
      po_northings := g_multi_coords(1).y_coord;
    END IF;
  END IF;
END return_stored_coords;
--
-----------------------------------------------------------------------------
--
PROCEDURE store_multi_coords
            (pi_coords IN nm3sdo_gdo.tab_xys) 
IS
BEGIN
  g_multi_coords := pi_coords;
END store_multi_coords;
--
-----------------------------------------------------------------------------
--
PROCEDURE return_multi_stored_coords
            (po_coords OUT nm3sdo_gdo.tab_xys) 
IS
BEGIN
  po_coords := g_multi_coords;
END return_multi_stored_coords;
--
-----------------------------------------------------------------------------
--
FUNCTION is_gdo_multi_coord ( pi_gis_session_id IN gis_data_objects.gdo_session_id%TYPE)
RETURN BOOLEAN
IS
  l_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_count
    FROM gis_data_objects
   WHERE gdo_session_id = pi_gis_session_id
     AND gdo_seq_no IS NOT NULL;
  IF l_count > 0
  THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN raise_application_error (-20999,'No coords exist for '||pi_gis_session_id||' in GIS_DATA_OBJECTS table');
END is_gdo_multi_coord;
--
-----------------------------------------------------------------------------
--
BEGIN
  instantiate_data;
END nm3locator;
/

