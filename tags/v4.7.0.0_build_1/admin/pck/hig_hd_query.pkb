CREATE OR REPLACE PACKAGE BODY hig_hd_query AS
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_hd_query.pkb	1.15 07/19/05
--       Module Name      : hig_hd_query.pkb
--       Date into SCCS   : 05/07/19 16:28:23
--       Date fetched Out : 07/06/13 14:10:22
--       SCCS Version     : 1.15
--
--
--   Author : D. Cope
--
--   Package of dynamic sql routines used in xml generation
--
--   FJF 11-Oct-04 Added context get/set to queries
--                 And restrict query on individual fields
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)hig_hd_query.pkb	1.15 07/19/05"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'HIG_HD_QUERY';
--
-- Global defaults
--
   -- there are two date formats as the xml output uses java to construct the output
   -- but the csv is done within the database server. Java's formats differ to the Oracle native ones
   g_date_format        varchar2(40)   DEFAULT 'dd-MM-yyyy HH:mm:ss';
   g_csv_date_format    varchar2(40)   DEFAULT 'dd-MM-yyyy HH24:mi:ss';
   g_tag_case           pls_integer    DEFAULT c_lower_case; -- 1 for lower case 2 for UPPER
   g_row_tag            varchar2(50)   DEFAULT 'ROW'; -- the tag that encloses a queried row
   g_row_set_tag        varchar2(50)   DEFAULT 'ROWSET'; -- the tag that encloses the entire output
   g_null_attribute_ind boolean        DEFAULT FALSE; -- flag for outputting null tags for null values
   g_comma_replacement  varchar2(1)    DEFAULT nm3type.c_space; -- replacement character for , in field data
   g_debug              boolean        DEFAULT TRUE; -- flag for outputting debug information. NB debugging slows down the output
   -- If this package variable is set on the way in then the context will
   -- be taken into account on query construction
   -- default to false to not change existing functionality
   g_set_nm3_context    boolean := false ;
   -- new line
   c_nl                 Constant char(1) := chr(10) ;
   -- ROI for IM
   g_im_roi             nm_elements%ROWTYPE; 

   TYPE r_params IS RECORD (
     hhp_module       hig_hd_modules.hhm_module%TYPE
    ,hhp_parameter    hig_hd_mod_parameters.hhp_parameter%TYPE
    ,hhp_value        varchar2(200)
   );
   
   TYPE tab_params IS TABLE OF r_params INDEX BY binary_integer;
   
   g_params tab_params;
--
-------------------------------------------------------------------- ---------
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
PROCEDURE debug_msg(l_chr IN varchar2) IS

BEGIN
  IF g_debug THEN
     nm_debug.DEBUG(p_text => l_chr);
  END IF;   
END debug_msg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_msg(l_clob IN clob) IS

BEGIN
    IF g_debug THEN
       nm_debug.debug_clob(p_clob => l_clob);
    END IF;
END debug_msg;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_msg(l_tab_varchar IN nm3type.tab_varchar32767) IS

BEGIN
    IF g_debug THEN
       nm3tab_varchar.debug_tab_varchar(l_tab_varchar);
    END IF;
END debug_msg;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_error_message_to_clob(l_msg  IN varchar2
                                     ,p_clob IN OUT NOCOPY clob) IS
BEGIN
   -- also write the message to the debug table
   debug_msg(l_chr => l_msg);

   IF NVL(dbms_lob.getlength(p_clob), 0) = 0 THEN

     dbms_lob.createtemporary(lob_loc => p_clob
                             ,CACHE   => TRUE);
   END IF;
   dbms_lob.writeappend(p_clob, LENGTH(l_msg) + 1, l_msg||nm3type.c_newline);
   
END write_error_message_to_clob;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mu (p_module     IN hig_hd_mod_uses.hhu_hhm_module%TYPE
                ,p_seq        IN hig_hd_mod_uses.hhu_seq%TYPE) RETURN hig_hd_mod_uses%ROWTYPE IS

BEGIN

  RETURN nm3get.get_hhu(pi_hhu_hhm_module => p_module
                       ,pi_hhu_seq        => p_seq);

END get_mu;
--
-----------------------------------------------------------------------------
--
FUNCTION get_musc (p_module     IN hig_hd_selected_cols.hhc_hhu_hhm_module%TYPE
                  ,p_seq        IN hig_hd_selected_cols.hhc_hhu_seq%TYPE
                  ,p_column_seq IN hig_hd_selected_cols.hhc_column_seq%TYPE) RETURN hig_hd_selected_cols%ROWTYPE IS

BEGIN

  RETURN nm3get.get_hhc(pi_hhc_hhu_hhm_module => p_module
                       ,pi_hhc_hhu_seq        => p_seq
                       ,pi_hhc_column_seq     => p_column_seq);

END get_musc;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hhj(pi_module_id IN hig_hd_table_join_cols.hhj_hht_hhu_hhm_module%TYPE
                ,pi_usage_seq IN hig_hd_table_join_cols.hhj_hht_hhu_parent_table%TYPE
                ,pi_join_seq  IN hig_hd_table_join_cols.hhj_hht_join_seq%TYPE
                ) RETURN hig_hd_table_join_cols%ROWTYPE IS

 CURSOR c_mutjc (p_mutjc_module     IN hig_hd_table_join_cols.hhj_hht_hhu_hhm_module%TYPE
                ,p_mutjc_seq        IN hig_hd_table_join_cols.hhj_hht_hhu_parent_table%TYPE
                ,p_mutjc_join_seq   IN hig_hd_table_join_cols.hhj_hht_join_seq%TYPE) IS
 SELECT *
 FROM   hig_hd_table_join_cols
 WHERE  hhj_hht_hhu_hhm_module     = p_mutjc_module
 AND    hhj_hht_hhu_parent_table   = p_mutjc_seq
 AND    hhj_hht_join_seq           = p_mutjc_join_seq;

 v_mutjc_rec  hig_hd_table_join_cols%ROWTYPE;

BEGIN

  FOR v_mutjc_rec IN c_mutjc(pi_module_id
                            ,pi_usage_seq
                            ,pi_join_seq) LOOP

    RETURN(v_mutjc_rec);

  END LOOP;

END get_hhj;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hhm(pi_module IN hig_hd_modules.hhm_module%TYPE
                ) RETURN hig_hd_modules%ROWTYPE IS

BEGIN
  RETURN nm3get.get_hhm(pi_module);
END get_hhm;
--
-----------------------------------------------------------------------------
--
FUNCTION get_hhp(pi_module    IN hig_hd_modules.hhm_module%TYPE
                ,pi_parameter IN hig_hd_mod_parameters.hhp_parameter%TYPE
                ) RETURN hig_hd_mod_parameters%ROWTYPE IS

CURSOR get_hhp (p_module    IN hig_hd_modules.hhm_module%TYPE
               ,p_parameter IN hig_hd_mod_parameters.hhp_parameter%TYPE) IS
SELECT *
FROM   hig_hd_mod_parameters hhp
WHERE  hhp.hhp_hhm_module = p_module
AND    hhp.hhp_parameter  = p_parameter;

l_hhp_rec hig_hd_mod_parameters%ROWTYPE;
BEGIN
  OPEN  get_hhp(pi_module
               ,pi_parameter);
  FETCH get_hhp INTO l_hhp_rec;
  CLOSE get_hhp;
  
  RETURN l_hhp_rec;
END get_hhp;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_joins_for_mod_usage(pi_module         IN     hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                                 ,pi_mod_usage_seq  IN     hig_hd_join_defs.hht_hhu_seq%TYPE
                                 ,po_join_seq_tab      OUT nm3type.tab_number
                                 ,po_join_decsr_tab    OUT nm3type.tab_varchar30
                                 ) IS
  CURSOR get_joins (p_module         IN     hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                   ,p_mod_usage_seq  IN     hig_hd_join_defs.hht_hhu_seq%TYPE) IS
  SELECT hht.hht_join_seq
        ,hht.hht_description
  FROM   hig_hd_join_defs hht
  WHERE  hht.hht_hhu_hhm_module = p_module
  AND    hht.hht_hhu_seq = p_mod_usage_seq;
    
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_joins_for_mod_usage');

  OPEN get_joins(p_module      => pi_module
                ,p_mod_usage_seq => pi_mod_usage_seq);
  FETCH get_joins BULK COLLECT INTO po_join_seq_tab
                                   ,po_join_decsr_tab;
  CLOSE get_joins;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_joins_for_mod_usage');

END get_joins_for_mod_usage;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_columns(pi_module                    IN     hig_hd_modules.hhm_module%TYPE
                     ,pi_seq                       IN     hig_hd_mod_uses.hhu_seq%TYPE
                     ,pi_just_the_order_by_cols    IN     varchar2 DEFAULT 'N'
                     ,pi_just_the_unique_cols      IN     varchar2 DEFAULT 'N'
                     ,pi_summary_view              IN     hig_hd_selected_cols.hhc_summary_view%TYPE DEFAULT 'Y'
                     ,pi_select_rowid              IN     boolean DEFAULT FALSE
                     ,pi_select_unique_identifiers IN     boolean DEFAULT FALSE
                     ,po_columns_tab               OUT    nm3type.tab_varchar2000
                     ,po_alias_tab                 OUT    nm3type.tab_varchar2000
                     ,po_displayed_tab             OUT    nm3type.tab_varchar1
                     ,po_calc_ratio_tab            OUT    nm3type.tab_varchar1) IS

  CURSOR get_cols (p_module                    IN     hig_hd_modules.hhm_module%TYPE
                  ,p_seq                       IN     hig_hd_mod_uses.hhu_seq%TYPE
                  ,p_just_the_order_by_cols    IN     varchar2
                  ,p_just_the_unique_cols      IN     varchar2
                  ,p_summary_view              IN     hig_hd_selected_cols.hhc_summary_view%TYPE
                  ,p_curr_alias                IN     varchar2) IS
  SELECT NVL(c.hhc_function, DECODE(c.hhc_hhl_join_seq, NULL,
                                                             DECODE(c.hhc_calc_ratio,'Y'
                                                                                    , get_ratio_to_report_column(p_curr_alias||nm3type.c_dot||c.hhc_column_name)
                                                                                    , LOWER(p_curr_alias||nm3type.c_dot||c.hhc_column_name)
                                                                    )
                                                           , l.hhl_alias||nm3type.c_dot||c.hhc_column_name
                                          ) ) c_col
        ,LOWER(c.hhc_alias)                         c_col_alias
        ,c.hhc_displayed                            c_col_displayed
        ,NVL(c.hhc_calc_ratio,'N')                  c_col_calc_ratio
  FROM   hig_hd_selected_cols c
        ,hig_hd_lookup_join_defs l
  WHERE  c.hhc_hhu_hhm_module     = p_module
  AND    c.hhc_hhu_seq            = p_seq
  AND    l.hhl_hhu_hhm_module (+) = c.hhc_hhu_hhm_module
  AND    l.hhl_hhu_seq        (+) = c.hhc_hhu_seq
  AND    l.hhl_join_seq       (+) = c.hhc_hhl_join_seq
  AND    c.hhc_summary_view       = DECODE(p_summary_view,'Y','Y',c.hhc_summary_view) -- bring back all cols if not asummary view
  AND ( (p_just_the_order_by_cols = 'Y' AND c.hhc_order_by_seq IS NOT NULL)
         OR
        (p_just_the_order_by_cols = 'N'))
  AND ( (p_just_the_unique_cols = 'Y' AND c.hhc_unique_identifier_seq IS NOT NULL)
         OR
        (p_just_the_unique_cols = 'N'))
  ORDER BY DECODE(p_just_the_unique_cols, 'Y', c.hhc_unique_identifier_seq
                                             , c.hhc_column_seq);

  CURSOR get_unique_cols (p_module     IN hig_hd_modules.hhm_module%TYPE
                         ,p_seq        IN hig_hd_mod_uses.hhu_seq%TYPE
                         ,p_curr_alias IN varchar2) IS 
  SELECT p_curr_alias||nm3type.c_dot||c.hhc_column_name c_col
       ,'xml_unique_identifier_'||c.hhc_unique_identifier_seq c_col_alias
  FROM   hig_hd_selected_cols c
  WHERE  c.hhc_hhu_hhm_module = p_module
  AND    c.hhc_hhu_seq        = p_seq
  AND    c.hhc_unique_identifier_seq IS NOT NULL
  ORDER BY c.hhc_unique_identifier_seq;
  
  v_mu                    hig_hd_mod_uses%ROWTYPE;
  v_current_table_alias   hig_hd_mod_uses.hhu_alias%TYPE;

  ----------------------------------------------------------------------------
  -- temporary pl/sql tables to store unique identifier columns
  -- if required by the user the values in these tables will be derived
  -- from a query and the results appended into the main pl/sql tables passed
  -- back out of this procedure
  ----------------------------------------------------------------------------
  v_uk_columns_tab  nm3type.tab_varchar2000;
  v_uk_alias_tab    nm3type.tab_varchar2000;

  l_next_array_pos pls_integer;

BEGIN
  nm_debug.proc_start(g_package_name, 'get_columns');

  v_mu := get_mu(pi_module, pi_seq);
  v_current_table_alias := NVL(v_mu.hhu_alias, v_mu.hhu_table_name);
  OPEN get_cols(p_module                  => pi_module
               ,p_seq                     => pi_seq
               ,p_just_the_order_by_cols  => pi_just_the_order_by_cols
               ,p_just_the_unique_cols    => pi_just_the_unique_cols
               ,p_summary_view            => pi_summary_view
               ,p_curr_alias              => v_current_table_alias);
  FETCH get_cols BULK COLLECT INTO po_columns_tab
                                  ,po_alias_tab
                                  ,po_displayed_tab
                                  ,po_calc_ratio_tab;
  CLOSE get_cols;

  ----------------------------------
  -- Also grab the ROWID if required
  ----------------------------------
  IF pi_select_rowid AND nm3flx.rowid_can_be_selected(pi_from => v_mu.hhu_table_name) THEN

    l_next_array_pos := po_columns_tab.COUNT +1;

    po_columns_tab(l_next_array_pos) := v_current_table_alias||nm3type.c_dot||'ROWID x_rowid';
    po_alias_tab(l_next_array_pos) := NULL;
    po_displayed_tab(l_next_array_pos) := 'N';
    po_calc_ratio_tab(l_next_array_pos) := 'N';

  END IF;

  ------------------------------------------------------
  -- Also grab the unique identifier columns if required
  ------------------------------------------------------
  IF pi_select_unique_identifiers THEN
    
    OPEN  get_unique_cols(p_module     => pi_module
                         ,p_seq        => pi_seq
                         ,p_curr_alias => v_current_table_alias);
    FETCH get_unique_cols BULK COLLECT INTO v_uk_columns_tab
                                           ,v_uk_alias_tab;
    CLOSE get_unique_cols;

    FOR v_recs IN 1..v_uk_columns_tab.COUNT LOOP

      l_next_array_pos := po_columns_tab.COUNT +1;
  
      po_columns_tab(l_next_array_pos)   := v_uk_columns_tab(v_recs);
      po_alias_tab(l_next_array_pos)     := v_uk_alias_tab(v_recs);
      po_displayed_tab(l_next_array_pos) := 'N';
      po_calc_ratio_tab(l_next_array_pos) := 'N';

    END LOOP;

  END IF;

  nm_debug.proc_end(g_package_name, 'get_columns');

END get_columns;
--
-----------------------------------------------------------------------------
--
function get_nm3_context_query
  (pi_module                    IN     hig_hd_modules.hhm_module%TYPE
  ,pi_seq                       IN     hig_hd_mod_uses.hhu_seq%TYPE
  ,pb_has_where                 IN     boolean
   ) return varchar2 IS

  v_mu                    hig_hd_mod_uses%ROWTYPE;
  v_current_table_alias   hig_hd_mod_uses.hhu_alias%TYPE;

  v_ret_val nm3type.max_varchar2 ;
  
BEGIN

  nm_debug.proc_start(g_package_name, 'get_nm3_context_query');

  if g_set_nm3_context
  then
  
   if pb_has_where
   then
     v_ret_val := 'AND ROWNUM <= 100 ' ;
   else
     v_ret_val := 'WHERE ROWNUM <= 100 ' ;
   end if ;
   v_mu := get_mu(pi_module, pi_seq);
   v_current_table_alias := NVL(v_mu.hhu_alias, v_mu.hhu_table_name);
   
   if g_im_roi.ne_id is not null
   then
     if upper( v_mu.hhu_table_name ) = 'NM_ELEMENTS'
     then
        if g_im_roi.ne_type = 'G'
        then
          v_ret_val := v_ret_val || c_nl
                     || ' and '
                     || v_current_table_alias || c_nl 
                     ||'.ne_id IN ' || c_nl 
                     || '(SELECT nm_ne_id_of FROM nm_members WHERE nm_ne_id_in = '
                     || g_im_roi.ne_id    
                     || ')'     
                     ;

        elsif g_im_roi.ne_type = 'P'
        then
          v_ret_val := v_ret_val || c_nl
                     || ' and '
                     || v_current_table_alias
                     ||'.ne_id IN '|| c_nl 
                     ||'(SELECT nm_ne_id_of ' || c_nl
                     ||'FROM nm_members ' || c_nl
                     ||'CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in ' || c_nl
                     ||'START WITH nm_ne_id_in = '
                     || g_im_roi.ne_id    
                     || ')'     
                     ;
        elsif  g_im_roi.ne_type = 'S'
        then
           v_ret_val := v_ret_val || c_nl
                        ||' and ('
                        ||v_current_table_alias 
                        || '.ne_id = ' 
                        || g_im_roi.ne_id
                        || ')' 
                        ;
        end if ;
     elsif upper( v_mu.hhu_table_name ) = 'NM_NODES'
     then
        if g_im_roi.ne_type = 'G'
        then
           v_ret_val := v_ret_val || c_nl
                        ||' and ('
                        || v_current_table_alias 
                        || '.no_node_id IN '|| c_nl
                        || '(SELECT nnu.nnu_no_node_id '|| c_nl
                        || 'FROM nm_node_usages nnu '|| c_nl
                        || 'WHERE nnu.nnu_ne_id '|| c_nl
                        || 'IN (SELECT nm_ne_id_of '|| c_nl
                        || 'FROM nm_members '|| c_nl
                        || 'WHERE nm_ne_id_in = '
                        || g_im_roi.ne_id || c_nl
                        || 'AND ((nnu.nnu_chain < NVL(nm_end_mp,nnu.nnu_chain+1) '|| c_nl
                        || 'AND NVL(nnu.nnu_chain, nm_begin_mp + 1) > nm_begin_mp ) '|| c_nl
                        || 'OR (nnu.nnu_chain = nnu.nnu_chain AND nnu.nnu_chain BETWEEN nm_begin_mp '|| c_nl
                        || 'AND NVL(nm_end_mp, nnu.nnu_chain) ) ) ) )'
                        || ')'     
                        ;
        elsif g_im_roi.ne_type = 'P'
        then
           v_ret_val := v_ret_val || c_nl
                        ||' and ('
                        || v_current_table_alias 
                        || '.no_node_id IN '|| c_nl
                        || '(SELECT nnu.nnu_no_node_id '|| c_nl
                        || 'FROM nm_node_usages nnu '|| c_nl
                        || 'WHERE EXISTS '|| c_nl
                        || '(SELECT 1 '|| c_nl
                        || 'FROM nm_members '|| c_nl
                        || 'WHERE nm_ne_id_of = nnu.nnu_ne_id '|| c_nl
                        || 'AND ((nnu.nnu_chain < NVL(nm_end_mp,nnu.nnu_chain+1) '|| c_nl
                        || 'AND NVL(nnu.nnu_chain, nm_begin_mp + 1) > nm_begin_mp ) '|| c_nl
                        || 'OR (nnu.nnu_chain = nnu.nnu_chain '|| c_nl
                        || 'AND nnu.nnu_chain BETWEEN nm_begin_mp '|| c_nl
                        || 'AND NVL(nm_end_mp, nnu.nnu_chain) ) ) '|| c_nl
                        || 'AND nm_ne_id_in '|| c_nl
                        || 'IN (SELECT csq2.nm_ne_id_of '|| c_nl
                        || 'FROM nm_members csq2 '|| c_nl
                        || 'CONNECT BY PRIOR csq2.nm_ne_id_of = csq2.nm_ne_id_in '|| c_nl
                        || 'START WITH csq2.nm_ne_id_in = '
                        || g_im_roi.ne_id
                        || ') ) ) '
                        || ')'     
                        ;
        elsif  g_im_roi.ne_type = 'S'
        then
           v_ret_val := v_ret_val || c_nl
                        ||' and ('
                        || v_current_table_alias 
                        || '.no_node_id IN '|| c_nl
                        || '(SELECT nnu.nnu_no_node_id' || c_nl
                        || 'FROM nm_node_usages nnu ' || c_nl
                        || 'WHERE nnu.nnu_ne_id = '
                        || g_im_roi.ne_id
                        || ' ) '
                        || ')'     
                        ;
        end if ;
     
     end if ;

   end if ;
   
  end if ;

  nm_debug.proc_end(g_package_name, 'get_nm3_context_query');
  
  return v_ret_val ;

END get_nm3_context_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ratio_to_report_column(pi_column_name  IN hig_hd_selected_cols.hhc_column_name%TYPE) RETURN varchar2 IS

BEGIN

  RETURN('ROUND(100*(ratio_to_report('||LOWER(pi_column_name)||') over ()),2)');

END get_ratio_to_report_column;
--
-----------------------------------------------------------------------------
--
FUNCTION build_column_list (pi_columns_tab         IN    nm3type.tab_varchar2000
                           ,pi_alias_tab           IN    nm3type.tab_varchar2000
                           ,pi_displayed_tab       IN    nm3type.tab_varchar1
                           ,pi_just_displayed_cols IN    boolean DEFAULT FALSE) RETURN varchar2 IS

l_chr nm3type.max_varchar2;
l_sep varchar2(2) DEFAULT nm3type.c_space||nm3type.c_space;
BEGIN
  nm_debug.proc_start(g_package_name, 'build_column_list');

  FOR v_recs IN 1..pi_columns_tab.COUNT LOOP
    IF NOT (pi_just_displayed_cols AND pi_displayed_tab(v_recs) = 'N') THEN
      l_chr := l_chr||c_nl||l_sep||pi_columns_tab(v_recs)||nm3type.c_space||pi_alias_tab(v_recs);
      l_sep := nm3type.c_comma_sep;
    END IF;

  END LOOP;

  nm_debug.proc_end(g_package_name, 'build_column_list');

  RETURN l_chr;

END build_column_list;
--
-----------------------------------------------------------------------------
--
FUNCTION build_column_list (pi_columns_tab         IN    nm3type.tab_varchar2000
                           ,pi_alias_tab           IN    nm3type.tab_varchar2000) RETURN varchar2 IS
l_dummy_tab nm3type.tab_varchar1;
BEGIN
  nm_debug.proc_start(g_package_name, 'build_column_list');

  RETURN build_column_list(pi_columns_tab         => pi_columns_tab
                          ,pi_alias_tab           => pi_alias_tab
                          ,pi_displayed_tab       => l_dummy_tab 
                          ,pi_just_displayed_cols => FALSE);

END build_column_list;
--
-----------------------------------------------------------------------------
--
FUNCTION get_parent_where_clause(p_muj_module  IN    hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                                ,p_muj_seq     IN    hig_hd_join_defs.hht_hhu_seq%TYPE
                                ,p_rowid       IN    urowid
                                ,p_paramlist   IN    t_param_list DEFAULT g_dummy_table) RETURN varchar2 IS


  v_mu        hig_hd_mod_uses%ROWTYPE;

BEGIN

  -------------------------------------------------------
  -- build a where clause by which to restrict a select
  -- on a table from which we are drilling from
  -------------------------------------------------------
  IF p_rowid IS NOT NULL THEN
     v_mu := get_mu(p_muj_module, p_muj_seq);
     RETURN (NVL(v_mu.hhu_alias,v_mu.hhu_table_name)||'.ROWID = '''|| p_rowid||'''');
  ELSIF p_paramlist.COUNT != 0 THEN
     RETURN(where_based_on_params(p_module        => p_muj_module
                                 ,p_seq           => p_muj_seq
                                 ,p_paramlist     => p_paramlist) );
  ELSE
     RETURN(NULL);
  END IF;
exception
  when others then return(sqlerrm);

END  get_parent_where_clause;
--
-----------------------------------------------------------------------------
--
FUNCTION build_where_clause (p_muj_module        IN    hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                            ,p_muj_seq           IN    hig_hd_join_defs.hht_hhu_seq%TYPE
                            ,p_muj_join_seq      IN    hig_hd_join_defs.hht_join_seq%TYPE
                            ,p_rowid             IN    urowid
                            ,p_paramlist         IN    t_param_list DEFAULT g_dummy_table) RETURN varchar2 IS

  CURSOR get_join_cols(p_module        IN    hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                      ,p_seq           IN    hig_hd_join_defs.hht_hhu_seq%TYPE
                      ,p_join_seq      IN    hig_hd_join_defs.hht_join_seq%TYPE) IS
  SELECT mu1.hhu_table_name                     c_parent_table
        ,NVL(mu1.hhu_alias, mu1.hhu_table_name) c_parent_alias
        ,mutjc.hhj_parent_col                   c_parent_col
        ,mu2.hhu_table_name                     c_child_table
        ,NVL(mu2.hhu_alias, mu2.hhu_table_name) c_child_alias
        ,mutjc.hhj_child_col                    c_child_col
  FROM   hig_hd_table_join_cols    mutjc
        ,hig_hd_mod_uses           mu1
        ,hig_hd_mod_uses           mu2
  WHERE  mutjc.hhj_hht_hhu_hhm_module   = p_module
  AND    mutjc.hhj_hht_hhu_parent_table = p_seq
  AND    mutjc.hhj_hht_join_seq         = p_join_seq
  AND    mu1.hhu_hhm_module             = mutjc.hhj_hht_hhu_hhm_module
  AND    mu1.hhu_seq                    = mutjc.hhj_hht_hhu_parent_table
  AND    mu2.hhu_hhm_module             = mutjc.hhj_hht_hhu_hhm_module
  AND    mu2.hhu_seq                    = mutjc.hhj_hhu_child_table;
  
  v_parent_table_where    nm3type.max_varchar2 DEFAULT NULL;
  l_where                 nm3type.max_varchar2 DEFAULT NULL;
  l_join                  hig_hd_table_join_cols%ROWTYPE;
  l_qry                   nm3type.max_varchar2;
  l_parent_val            nm3type.max_varchar2;
  v_parent_table_tab      nm3type.tab_varchar2000;
  v_parent_alias_tab      nm3type.tab_varchar2000;
  v_parent_col_tab        nm3type.tab_varchar2000;
  v_child_table_tab       nm3type.tab_varchar2000;
  v_child_alias_tab       nm3type.tab_varchar2000;
  v_child_col_tab         nm3type.tab_varchar2000;

BEGIN
  nm_debug.proc_start(g_package_name, 'build_where_clause');

  --------------------------------------------------------------------
  -- work out the restriction that we are to apply to the parent table
  -- i.e. derive the attributes of the parent record that we are to drill down from
  -- and used these to restrict the query on our child table
  --------------------------------------------------------------------
  v_parent_table_where := get_parent_where_clause(p_muj_module  => p_muj_module
                                                 ,p_muj_seq     => p_muj_seq
                                                 ,p_rowid       => p_rowid
                                                 ,p_paramlist   => p_paramlist);


  debug_msg('l_parent_table_where='||v_parent_table_where);

  ----------------------------------------------------------------------------------
  -- loop for every column in the foreign key join on between parent and child table
  ----------------------------------------------------------------------------------
  OPEN get_join_cols(p_module   => p_muj_module
                    ,p_seq      => p_muj_seq
                    ,p_join_seq => p_muj_join_seq);
  FETCH get_join_cols BULK COLLECT INTO v_parent_table_tab
                                      , v_parent_alias_tab
                                      , v_parent_col_tab
                                      , v_child_table_tab
                                      , v_child_alias_tab
                                      , v_child_col_tab;
  CLOSE get_join_cols;
  
  -------------------------------------------------------------------------------------------
  -- this is NOT the most efficient way to derive the join between parent/child tables
  -- because for each join column we need to select a value from the parent table to apply
  -- in the where clause returned by the function
  --             e.g.    child_column_x = 'parent_column_x_value'
  --                 AND child_column_y = 'parent_column_y_value'
  --                 AND child_column_z = 'parent_column_z_value'
  -- Since most table joins would be between a single column it may not be such an issue
  -------------------------------------------------------------------------------------------
  FOR v_recs IN 1..v_parent_table_tab.COUNT LOOP

     ------------------------------------------------------------------------------------------------------
     -- build a query to bring back a join column value from the PARENT table
     -- This is where v_parent_table_where is applied to narrow down to a single record on the parent table
     ------------------------------------------------------------------------------------------------------
     l_qry :=    nm3type.c_select||nm3type.c_space
              || v_parent_col_tab(v_recs)|| c_nl
              || nm3type.c_from|| nm3type.c_space|| v_parent_table_tab(v_recs) ||nm3type.c_space|| v_parent_alias_tab(v_recs)|| c_nl
              || nm3type.c_where || nm3type.c_space|| v_parent_table_where;
    debug_msg('query to get parent value');
    debug_msg(l_qry);
   ----------------------------------------------------
   -- grab the column value from the parent table query
   ----------------------------------------------------
   BEGIN
     EXECUTE IMMEDIATE l_qry INTO  l_parent_val;
   EXCEPTION
     WHEN others THEN
       NULL;
   END;
     -- add the value of the master column got in the select above
     -- to the where clause
     -- so we have <<child_column>> = << parent value >>
     IF l_parent_val IS NOT NULL THEN

      ----------------------------------------------------------------
      -- add the restriction on this column/column value to the clause
      ----------------------------------------------------------------
      nm3flx.add_to_where_clause(pi_existing_clause   => l_where
                                ,pi_prefix_with_where => FALSE
                                ,pi_column_name       => LOWER(v_child_alias_tab(v_recs)|| nm3type.c_dot||v_child_col_tab(v_recs))
                                ,pi_column_datatype   => nm3flx.get_column_datatype(pi_table_name  => v_child_table_tab(v_recs)
                                                                                   ,pi_column_name => v_child_col_tab(v_recs))
                                ,pi_operator          => nm3type.c_equals
                                ,pi_string_value      => l_parent_val
                                );

     END IF;

  END LOOP;


  debug_msg(l_chr =>'Build where clause returns'||l_where);

  nm_debug.proc_end(g_package_name, 'build_where_clause');
  RETURN l_where;

END build_where_clause;
--
--------------------------------------------------------------------------------
--
FUNCTION where_based_on_params  (p_module        IN    hig_hd_mod_uses.hhu_hhm_module%TYPE
                                ,p_seq           IN    hig_hd_mod_uses.hhu_seq%TYPE
                                ,p_paramlist     IN    t_param_list) RETURN varchar2 IS


v_mu                   hig_hd_mod_uses%ROWTYPE;
v_parent_table_where   nm3type.max_varchar2 DEFAULT NULL;
v_uk_columns_tab       nm3type.tab_varchar2000;
v_uk_alias_tab         nm3type.tab_varchar2000;  -- not used for anything but need to store results of get_columns
v_uk_displayed_tab     nm3type.tab_varchar1;     -- not used for anything but need to store results of get_columns
v_uk_calc_ratio_tab    nm3type.tab_varchar1;     -- not used for anything but need to store results of get_columns
v_current_uk_col       hig_hd_selected_cols.hhc_column_name%TYPE;


BEGIN

  ------------------------------------------------------------------------------------------
  -- used in drilling down from one table to another - this function returns a where clause
  -- which is to be applied when deriving values from the parent table
  -- which themselves are used in deriving a drill down query
  ------------------------------------------------------------------------------------------
  nm_debug.proc_start(g_package_name, 'where_based_on_params');

  -------------------------------------------------------------------------------------------------------------------------
  -- Get the parent table details since we'll need the table name when we look to get the datatype for the given uk columns
  -------------------------------------------------------------------------------------------------------------------------
  v_mu := get_mu(p_module, p_seq);

  -----------------------------------------------------------------------
  -- get the list of unique columns on the parent table
  -- get_columns will return the list of unique columns in the correct order
  -- i.e. ordered by hhc_unique_identifier_seq
  -- Assumption is that pl/sql table 'p_params' is in the same order
  -----------------------------------------------------------------------

  get_columns(pi_module                    => p_module
             ,pi_seq                       => p_seq
             ,pi_just_the_order_by_cols    => 'N'
             ,pi_just_the_unique_cols      => 'Y'
             ,pi_summary_view              => 'N'
             ,pi_select_rowid              => FALSE
             ,pi_select_unique_identifiers => FALSE
             ,po_columns_tab               => v_uk_columns_tab
             ,po_alias_tab                 => v_uk_alias_tab
             ,po_displayed_tab             => v_uk_displayed_tab
             ,po_calc_ratio_tab            => v_uk_calc_ratio_tab);

  FOR v_recs IN 1..v_uk_columns_tab.COUNT LOOP

    if p_paramlist.exists( v_recs )
    then

      --------------------------------------------------------------------------------------------
      -- Get the raw column name i.e. get_columns returned column names as table_alias.column_name
      -- Strip the 'table_alias.' prefix from the unique column name
      --------------------------------------------------------------------------------------------
      v_current_uk_col := nm3flx.string_after_character(pi_string    => v_uk_columns_tab(v_recs)
                                                       ,pi_char      => '.');

      --debug_msg ('uk column ('||to_char(v_recs)||')='||v_current_uk_col);

      ----------------------------------------------------------------
      -- add the restriction on this column/column value to the clause
      ----------------------------------------------------------------
      nm3flx.add_to_where_clause(pi_existing_clause   => v_parent_table_where
                                ,pi_prefix_with_where => FALSE
                                ,pi_column_name       => v_uk_columns_tab(v_recs)
                                ,pi_column_datatype   => nm3flx.get_column_datatype(pi_table_name  => v_mu.hhu_table_name
                                                                                   ,pi_column_name => v_current_uk_col)
                                ,pi_operator          => nm3type.c_equals
                                ,pi_string_value      => p_paramlist(v_recs)
                                );

    end if ;
  END LOOP;

  nm_debug.proc_end(g_package_name, 'where_based_on_params');

  RETURN v_parent_table_where;

END where_based_on_params ;
--
-----------------------------------------------------------------------------
--
-- get a lookup join condition
FUNCTION lookup_join_cond (pi_module                  IN     hig_hd_selected_cols.hhc_hhu_hhm_module%TYPE
                          ,pi_musc_seq                IN     hig_hd_selected_cols.hhc_hhu_seq%TYPE
                          ,pi_hhl_join_seq            IN     hig_hd_selected_cols.hhc_hhl_join_seq%TYPE) RETURN varchar2 IS

  CURSOR get_pks(p_module   IN     hig_hd_selected_cols.hhc_hhu_hhm_module%TYPE
                ,p_seq      IN     hig_hd_selected_cols.hhc_hhu_seq%TYPE
                ,p_join_seq IN     hig_hd_selected_cols.hhc_hhl_join_seq%TYPE) IS
  SELECT hho_parent_col
        ,hho_lookup_col
        ,hhl_table_name
        ,hhl_alias
        ,hhl_outer_join
        ,hho_hhl_join_to_lookup
  FROM   hig_hd_lookup_join_defs
        ,hig_hd_lookup_join_cols
  WHERE  hhl_hhu_hhm_module = hho_hhl_hhu_hhm_module
  AND    hhl_hhu_seq        = hho_hhl_hhu_seq
  AND    hhl_join_seq       = hho_hhl_join_seq
  AND    hhl_hhu_hhm_module = p_module
  AND    hhl_hhu_seq        = p_seq
  AND    hhl_join_seq       = p_join_seq;
  
  l_join_cond nm3type.max_varchar2;
  l_sep       varchar2(10) DEFAULT nm3type.c_space;
  l_lookup    hig_hd_lookup_join_defs%ROWTYPE;

  l_table_to_join hig_hd_mod_uses.hhu_table_name%TYPE;
  v_mu                   hig_hd_mod_uses%ROWTYPE;
  v_current_table_alias  hig_hd_mod_uses.hhu_alias%TYPE;
  
BEGIN

  nm_debug.proc_start(g_package_name, 'lookup_join_cond');

  v_mu := get_mu(pi_module, pi_musc_seq);
  v_current_table_alias := NVL(v_mu.hhu_alias, v_mu.hhu_table_name);

-- get pk's or parent table
  FOR l_join IN get_pks(p_module   => pi_module
                       ,p_seq      => pi_musc_seq
                       ,p_join_seq => pi_hhl_join_seq)
  LOOP
      -- for every parent key column
      -- get the child key column
      -- add a = sign

      ------------------------------------------------------------------------------------------------
      --- always select rowid to uniquely identify the record
      --- prefix the join columns with either the table alias as set by a call to get_current_table_alias
      --- which itself is called in get_query
      --- or the lookup table alias
      ------------------------------------------------------------------------------------------------
      
      -- If hho_hhl_join_to_lookup is not null then we join to another lookup table
      IF l_join.hho_hhl_join_to_lookup IS NOT NULL THEN
      
        l_lookup := nm3get.get_hhl(pi_hhl_hhu_hhm_module => pi_module
                                  ,pi_hhl_hhu_seq        => pi_musc_seq
                                  ,pi_hhl_join_seq       => l_join.hho_hhl_join_to_lookup);
                                  
        l_table_to_join := l_lookup.hhl_alias;
      ELSE
        l_table_to_join := v_current_table_alias;
      END IF;
      
      l_join_cond := l_join_cond || l_sep || l_table_to_join||nm3type.c_dot||
                     l_join.hho_parent_col||
                     nm3type.c_space || nm3type.c_equals || nm3type.c_space ||
                     l_join.hhl_alias||nm3type.c_dot||
                     l_join.hho_lookup_col;

      IF l_join.hhl_outer_join = 'Y' THEN
        l_join_cond := l_join_cond || nm3type.c_space|| nm3type.c_outer_join;
      END IF;
-- build a string of the results
      l_sep := nm3type.c_space||nm3type.c_and_operator||nm3type.c_space;
   END LOOP;

   nm_debug.proc_end(g_package_name, 'lookup_join_cond');
-- pass it back
   RETURN l_join_cond;
END lookup_join_cond;
--
-----------------------------------------------------------------------------
--
FUNCTION get_lookup_where (p_module    IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                          ,p_seq       IN     hig_hd_mod_uses.hhu_seq%TYPE) RETURN varchar2 IS

  CURSOR get_join_cols (p_module    IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                       ,p_seq       IN     hig_hd_mod_uses.hhu_seq%TYPE) IS
  SELECT j.hhl_join_seq
        ,j.hhl_fixed_where_clause
  FROM   hig_hd_lookup_join_defs j
  WHERE  j.hhl_hhu_hhm_module = p_module
  AND    j.hhl_hhu_seq        = p_seq;
  
  l_join_cond nm3type.max_varchar2;
  l_sep       varchar2(5) DEFAULT nm3type.c_space;
BEGIN
  nm_debug.proc_start(g_package_name, 'get_lookup_where');
  
  FOR tab IN get_join_cols(p_module => p_module
                          ,p_seq    => p_seq)
  LOOP
    
    l_join_cond := l_join_cond || l_sep || lookup_join_cond(p_module
                                           ,p_seq
                                           ,tab.hhl_join_seq);
    
    l_sep := nm3type.c_space||nm3type.c_and_operator||nm3type.c_space;

    -- add the fixed where clause from the join definition if there is one
    IF tab.hhl_fixed_where_clause IS NOT NULL THEN
      
      l_join_cond := l_join_cond || l_sep || tab.hhl_fixed_where_clause;
      
    END IF;

  END LOOP;

  debug_msg(l_chr => 'get_lookup_where returned '''||l_join_cond||'''');

  nm_debug.proc_end(g_package_name, 'get_lookup_where');
  RETURN l_join_cond;
END get_lookup_where;
--
-----------------------------------------------------------------------------
--
FUNCTION return_lookup_tables(p_module        IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                             ,p_seq           IN     hig_hd_mod_uses.hhu_seq%TYPE) RETURN varchar2 IS

  CURSOR get_tab_alias(p_module        IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                      ,p_seq           IN     hig_hd_mod_uses.hhu_seq%TYPE) IS
  SELECT LOWER(hhl_table_name||nm3type.c_space||NVL(hhl_alias, hhl_table_name)) lookup_tab
  FROM   hig_hd_lookup_join_defs
  WHERE  hhl_hhu_hhm_module = p_module
  AND    hhl_hhu_seq        = p_seq
  UNION
  SELECT LOWER(hhu_table_name||nm3type.c_space||NVL(hhu_alias, hhu_table_name))
  FROM   hig_hd_mod_uses
  WHERE  hhu_hhm_module = p_module
  AND    hhu_seq        = p_seq;
  
  l_chr nm3type.max_varchar2 := NULL;

BEGIN

  nm_debug.proc_start(g_package_name, 'return_lookup_tables');

  -- loop around fetching lookup table name and the alias
  -- concatenate that with the actual table name and alias fron our mod_use
  FOR cols IN get_tab_alias(p_module => p_module
                           ,p_seq    => p_seq)
  LOOP

    -- append the column and alias to the return string
    IF l_chr IS NULL THEN
      l_chr := c_nl||nm3type.c_space||nm3type.c_space||cols.lookup_tab;
    ELSE
      l_chr := l_chr||c_nl||nm3type.c_comma_sep||cols.lookup_tab;
    END IF;

  END LOOP;  
  
  nm_debug.proc_end(g_package_name, 'return_lookup_tables');
  RETURN l_chr;
END return_lookup_tables;
--
-----------------------------------------------------------------------------
--
FUNCTION return_order_by_cols(p_module             IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                             ,p_seq                IN     hig_hd_mod_uses.hhu_seq%TYPE
                             ,p_order_by_module    IN     hig_hd_modules.hhm_module%TYPE           DEFAULT NULL      							 
                             ,p_order_by_override  IN     hig_hd_selected_cols.hhc_alias%TYPE      DEFAULT NULL
                             ,p_order_by_order     IN     varchar2                                 DEFAULT NULL) RETURN varchar2 IS

-- pl/sql tables used when deriving list of order by columns
v_columns_tab       nm3type.tab_varchar2000;
v_alias_tab         nm3type.tab_varchar2000;
v_displayed_tab     nm3type.tab_varchar1;
v_calc_ratio_tab    nm3type.tab_varchar1;

l_chr nm3type.max_varchar2;


BEGIN
  nm_debug.proc_start(g_package_name, 'return_order_by_cols');

   IF p_order_by_override IS NOT NULL AND p_module = p_order_by_module THEN
       l_chr := p_order_by_override||nm3type.c_space||p_order_by_order;
   ELSE

     get_columns(pi_module                    => p_module
                ,pi_seq                       => p_seq
                ,pi_just_the_order_by_cols    => 'Y'
                ,pi_summary_view              => 'N'
                ,pi_select_rowid              => FALSE
                ,pi_select_unique_identifiers => FALSE
                ,po_columns_tab               => v_columns_tab
                ,po_alias_tab                 => v_alias_tab
                ,po_displayed_tab             => v_displayed_tab
                ,po_calc_ratio_tab            => v_calc_ratio_tab);


    FOR v_recs IN 1..v_columns_tab.COUNT LOOP

      IF l_chr IS NULL THEN
        l_chr := c_nl||nm3type.c_space||nm3type.c_space||LOWER(v_columns_tab(v_recs));
      ELSE
        l_chr := l_chr ||c_nl||nm3type.c_comma_sep||LOWER(v_columns_tab(v_recs));
    END IF;

    END LOOP;

    nm_debug.proc_end(g_package_name, 'return_order_by_cols');

  END IF;

  IF l_chr IS NULL THEN
    RETURN l_chr;
  ELSE
    RETURN nm3type.c_order_by||nm3type.c_space||l_chr;
  END IF;

END return_order_by_cols;
--
-----------------------------------------------------------------------------
--
FUNCTION drill_down(p_muj_module                   IN hig_hd_join_defs.hht_hhu_hhm_module%TYPE
                   ,p_muj_seq                      IN hig_hd_join_defs.hht_hhu_seq%TYPE
                   ,p_muj_join_seq                 IN hig_hd_join_defs.hht_join_seq%TYPE
                   ,p_rowid                        IN urowid
                   ,p_where                        IN varchar2
                   ,p_summary_view                 IN varchar2 DEFAULT 'N'
                   ,p_select_rowid                 IN boolean DEFAULT FALSE
                   ,p_select_unique_identifiers    IN boolean DEFAULT FALSE
                   ,p_paramlist                    IN t_param_list DEFAULT g_dummy_table
                   ,p_order_by_module              IN hig_hd_modules.hhm_module%TYPE      DEFAULT NULL
                   ,p_order_by_override            IN hig_hd_selected_cols.hhc_alias%TYPE DEFAULT NULL
                   ,p_order_by_order               IN varchar2 DEFAULT NULL
                   ) RETURN varchar2 IS


v_mutjc_rec           hig_hd_table_join_cols%ROWTYPE;
v_drill_down_to_where nm3type.max_varchar2;
v_drill_down_to_seq   hig_hd_table_join_cols.hhj_child_col%TYPE;

v_query               nm3type.max_varchar2;  -- stores the resulting query that is run by a call to get_xml_for_table

BEGIN
  nm_debug.proc_start(g_package_name, 'drill_down');

  ------------------------------------------------------------------------------------------------------------------
  -- if p_rowid is not null then the drill down where clause will be derived based
  -- on the rowid of the parent record
  -- otherwise it will be based on the unique identifiers of the parent record passed in pl/sql table p_paramlist
  -- It is assumed that the values in p_paramlist are in the same order as the unique columns seq on the parent table
  -------------------------------------------------------------------------------------------------------------------
  debug_msg(l_chr =>' Will attempt to build drill down where clause using;');
  debug_msg(l_chr => 'ROWID: '||NVL(p_rowid,'NO ROWID'));
  debug_msg(l_chr => 'PARAM ELEMENTS: '||TO_CHAR(p_paramlist.COUNT));


  v_drill_down_to_where := build_where_clause(p_muj_module        => p_muj_module
                                             ,p_muj_seq           => p_muj_seq
                                             ,p_muj_join_seq      => p_muj_join_seq
                                             ,p_rowid             => p_rowid
                                             ,p_paramlist         => p_paramlist);

  IF p_where IS NOT NULL THEN
    v_drill_down_to_where := v_drill_down_to_where || nm3type.c_space|| nm3type.c_and_operator
                          || nm3type.c_space|| p_where;
  END IF;


  ------------------------------------------------------------
  -- Get the name of the table the we will be drilling down to
  ------------------------------------------------------------
  v_mutjc_rec := get_hhj(pi_module_id  => p_muj_module
                        ,pi_usage_seq  => p_muj_seq
                        ,pi_join_seq   => p_muj_join_seq);

  v_drill_down_to_seq := v_mutjc_rec.hhj_hhu_child_table;

  debug_msg('new where clause  '||v_drill_down_to_where);


  v_query := get_query( p_summary_view               => p_summary_view
                       ,p_select_rowid               => p_select_rowid
                       ,p_select_unique_identifiers  => p_select_unique_identifiers
                       ,p_module                     => p_muj_module
                       ,p_seq                        => v_drill_down_to_seq
                       ,p_where                      => v_drill_down_to_where
                       ,p_order_by_module            => p_order_by_module
                       ,p_order_by_override          => p_order_by_override
                       ,p_order_by_order             => p_order_by_order);

  nm_debug.proc_end(g_package_name, 'drill_down');
  RETURN (v_query);

END drill_down;
--
-----------------------------------------------------------------------------
--
FUNCTION return_query ( p_module                     IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                       ,p_seq                        IN     hig_hd_mod_uses.hhu_seq%TYPE
                       ,p_where                      IN     varchar2 DEFAULT NULL
                       ,p_summary_view               IN     varchar2 DEFAULT 'N'
                       ,p_select_rowid               IN     boolean DEFAULT FALSE
                       ,p_select_unique_identifiers  IN     boolean DEFAULT FALSE
                       ,p_order_by_module            IN     hig_hd_modules.hhm_module%TYPE      DEFAULT NULL
                       ,p_order_by_override          IN     hig_hd_selected_cols.hhc_alias%TYPE DEFAULT NULL
                       ,p_order_by_order             IN     varchar2 DEFAULT NULL
                       ,p_replace_parameters         IN     boolean  DEFAULT TRUE
                       ,p_just_displayed_cols        IN     boolean  DEFAULT FALSE
                      ) RETURN varchar2
IS

l_lookup_cond nm3type.max_varchar2;

-- pl/sql tables used when deriving list of selected columns
v_columns_tab       nm3type.tab_varchar2000;
v_alias_tab         nm3type.tab_varchar2000;
v_displayed_tab     nm3type.tab_varchar1;
v_calc_ratio_tab    nm3type.tab_varchar1;

l_mu_det            hig_hd_mod_uses%ROWTYPE := get_mu(p_module => p_module
                                                     ,p_seq    => p_seq);
l_sep               varchar2(10) DEFAULT c_nl||nm3type.c_where ||c_nl;
v_query             nm3type.max_varchar2;

BEGIN
   nm_debug.proc_start(g_package_name, 'return_query');

   -----------------------------------------
   -- get the list of columns to select from
   -----------------------------------------
  debug_msg(l_chr => '  get_columns');
  
  get_columns(pi_module                    => p_module
             ,pi_seq                       => p_seq
             ,pi_summary_view              => p_summary_view
             ,pi_select_rowid              => p_select_rowid
             ,pi_select_unique_identifiers => p_select_unique_identifiers
             ,po_columns_tab               => v_columns_tab
             ,po_alias_tab                 => v_alias_tab
             ,po_displayed_tab             => v_displayed_tab
             ,po_calc_ratio_tab            => v_calc_ratio_tab);

  debug_msg(l_chr => '  done');

  v_query :=  nm3type.c_select|| nm3type.c_space|| l_mu_det.hhu_hint_text
           || build_column_list(pi_columns_tab         => v_columns_tab
                               ,pi_alias_tab           => v_alias_tab
                               ,pi_displayed_tab       => v_displayed_tab
                               ,pi_just_displayed_cols => p_just_displayed_cols)|| c_nl
           || nm3type.c_from|| nm3type.c_space|| return_lookup_tables(p_module, p_seq);


  l_lookup_cond := get_lookup_where(p_module, p_seq);
  
  -- add the user where clause
  -- and the where clause generated for lookup tables
  -- and the fixed where clause if there is one
  FOR i IN 1..3 LOOP
    IF i = 1 THEN
      IF p_where IS NOT NULL THEN
         v_query := v_query || l_sep || p_where;
         l_sep := nm3type.c_space || nm3type.c_and_operator || nm3type.c_space;
      END IF;
    END IF;
    IF i = 2 THEN
      IF l_lookup_cond IS NOT NULL THEN
         v_query := v_query || l_sep || l_lookup_cond;
         l_sep := nm3type.c_space || nm3type.c_and_operator || nm3type.c_space;
      END IF;
    END IF;
    IF i = 3 THEN
      IF l_mu_det.hhu_fixed_where_clause IS NOT NULL THEN
         v_query := v_query || l_sep || l_mu_det.hhu_fixed_where_clause;
         l_sep := nm3type.c_space || nm3type.c_and_operator || nm3type.c_space;
      END IF;
    END IF;

  END LOOP;
  
  -- Set the NM3 context
  
  v_query := v_query || c_nl || get_nm3_context_query 
             ( pi_module => p_module
             , pi_seq    => p_seq
             , pb_has_where => instr( upper( v_query ), 'WHERE' ) > 0  ) ;
  
  -- add order by clause at the end
  v_query := v_query || c_nl|| return_order_by_cols(p_module
                                                     , p_seq
                                                     , p_order_by_module
                                                     , p_order_by_override
                                                     , p_order_by_order);

  IF p_replace_parameters THEN
    v_query := replace_parameters_in_query(p_module, v_query);
  END IF;
  
  debug_msg(l_chr => 'return_query returned'||c_nl||v_query);   

  nm_debug.proc_end(g_package_name, 'return_query');

  RETURN v_query;

END return_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_csv_query ( p_module                     IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                        ,p_seq                        IN     hig_hd_mod_uses.hhu_seq%TYPE
                        ,p_where                      IN     varchar2 DEFAULT NULL
                        ,p_summary_view               IN     varchar2 DEFAULT 'N'
                        ,p_select_rowid               IN     boolean DEFAULT FALSE
                        ,p_select_unique_identifiers  IN     boolean DEFAULT FALSE
                        ,p_order_by_module            IN     hig_hd_modules.hhm_module%TYPE      DEFAULT NULL
                        ,p_order_by_override          IN     hig_hd_selected_cols.hhc_alias%TYPE DEFAULT NULL
                        ,p_order_by_order             IN     varchar2 DEFAULT NULL
                        ,p_just_displayed_cols        IN     boolean  DEFAULT FALSE
                        ,p_replace_parameters         IN     boolean  DEFAULT TRUE
                        ) RETURN varchar2
IS
BEGIN

  RETURN return_query ( p_module                     => p_module
                       ,p_seq                        => p_seq
                       ,p_where                      => p_where
                       ,p_summary_view               => p_summary_view
                       ,p_select_rowid               => p_select_rowid
                       ,p_select_unique_identifiers  => p_select_unique_identifiers
                       ,p_order_by_module            => p_order_by_module
                       ,p_order_by_override          => p_order_by_override
                       ,p_order_by_order             => p_order_by_order
                       ,p_replace_parameters         => p_replace_parameters
                       ,p_just_displayed_cols        => p_just_displayed_cols
                       );

END get_csv_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_query ( p_module                     IN     hig_hd_mod_uses.hhu_hhm_module%TYPE
                    ,p_seq                        IN     hig_hd_mod_uses.hhu_seq%TYPE
                    ,p_where                      IN     varchar2 DEFAULT NULL
                    ,p_summary_view               IN     varchar2 DEFAULT 'N'
                    ,p_select_rowid               IN     boolean DEFAULT FALSE
                    ,p_select_unique_identifiers  IN     boolean DEFAULT FALSE
                    ,p_order_by_module            IN     hig_hd_modules.hhm_module%TYPE      DEFAULT NULL
                    ,p_order_by_override          IN     hig_hd_selected_cols.hhc_alias%TYPE DEFAULT NULL
                    ,p_order_by_order             IN     varchar2 DEFAULT NULL
                    ,p_just_displayed_cols        IN     boolean  DEFAULT FALSE
                    ,p_replace_parameters         IN     boolean  DEFAULT TRUE
                    ) RETURN varchar2
IS
BEGIN

  RETURN return_query ( p_module                     => p_module
                       ,p_seq                        => p_seq
                       ,p_where                      => p_where
                       ,p_summary_view               => p_summary_view
                       ,p_select_rowid               => p_select_rowid
                       ,p_select_unique_identifiers  => p_select_unique_identifiers
                       ,p_order_by_module            => p_order_by_module
                       ,p_order_by_override          => p_order_by_override
                       ,p_order_by_order             => p_order_by_order
                       ,p_replace_parameters         => p_replace_parameters
                       ,p_just_displayed_cols        => p_just_displayed_cols
                       );

END get_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_query_defaults (p_xml_context IN dbms_xmlquery.ctxtype) IS
BEGIN
   dbms_xmlquery.settagcase   (ctxhdl => p_xml_context
                              ,tcase => g_tag_case);
   dbms_xmlquery.setdateformat(ctxhdl => p_xml_context
                              ,mask => g_date_format);
   dbms_xmlquery.setrowtag    (ctxhdl => p_xml_context
                              ,tag => g_row_tag);
   dbms_xmlquery.setrowsettag (ctxhdl => p_xml_context
                              ,tag => g_row_set_tag);
   dbms_xmlquery.usenullattributeindicator(ctxhdl => p_xml_context
                                          ,flag => g_null_attribute_ind);
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_query_as_xml(p_query         IN OUT varchar2
                          ,p_xml           IN OUT NOCOPY clob)
IS
   l_xml_context dbms_xmlquery.ctxtype;

BEGIN

   debug_msg('Query to be run ');
   debug_msg(p_query);

   -- get a new context for the query
   l_xml_context := dbms_xmlquery.newcontext(sqlquery => p_query);

   -- now set the formatting defaults

   set_query_defaults(l_xml_context);

   -- execute the qeury and format the output as xml
   -- return the result in the supplied CLOB
   p_xml := dbms_xmlquery.getxml( ctxhdl => l_xml_context);
   -- close the query
   dbms_xmlquery.closecontext(ctxhdl => l_xml_context);

   debug_msg('Result xml');
   debug_msg(p_xml);

EXCEPTION
  WHEN others THEN
  -- write error to the clob
  write_error_message_to_clob('***********************************',p_xml);
  write_error_message_to_clob('The following error has occurred',p_xml);
  write_error_message_to_clob(SQLERRM,p_xml);
  write_error_message_to_clob('Whilst executing the query',p_xml);
  write_error_message_to_clob(p_query,p_xml);
  RAISE;
END get_query_as_xml ;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_query_as_xml(p_query         IN OUT        varchar2
                          ,p_xml           IN OUT NOCOPY varchar2)
IS
   l_xml_clob clob;
BEGIN
   get_query_as_xml(p_query => p_query
                   ,p_xml   => l_xml_clob);

   p_xml := nm3clob.lob_substr (p_clob      => l_xml_clob
                               ,p_offset    => 1
                               ,p_num_chars => 32767);
END get_query_as_xml;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_query_as_xml(p_query         IN OUT        varchar2
                          ,p_xml           IN OUT NOCOPY nm3type.tab_varchar32767)
IS
   l_xml_clob clob;
BEGIN
   get_query_as_xml(p_query => p_query
                   ,p_xml   => l_xml_clob);

   p_xml := nm3clob.clob_to_tab_varchar(l_xml_clob);
END get_query_as_xml;
--
-----------------------------------------------------------------------------
--
PROCEDURE xml_file_from_query(p_query         IN            varchar2
                             ,p_filename      IN            varchar2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  
  l_clob CLOB;
  l_nuf nm_upload_files%ROWTYPE;
  l_query nm3type.max_varchar2;
BEGIN
  l_query := p_query;
  nm3clob.create_clob(l_clob);
  get_query_as_xml(p_query => l_query
                  ,p_xml   => l_clob);

  l_nuf.name     := p_filename;
  l_nuf.doc_size := dbms_lob.getlength(l_clob);
  l_nuf.mime_type := 'application/octet';
  l_nuf.blob_content := nm3clob.clob_to_blob(l_clob);
  nm3ins.ins_nuf(l_nuf);
  
  COMMIT;
END xml_file_from_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_nuf(pi_file IN nm_upload_files.name%TYPE) IS
   PRAGMA autonomous_transaction;
BEGIN
  nm3del.del_nuf(pi_name => pi_file
                ,pi_raise_not_found => FALSE);
  COMMIT;
END delete_nuf;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_dtd_from_query( p_query         IN varchar2
                             ,p_xml           IN OUT NOCOPY clob)
IS
   l_xml_context dbms_xmlquery.ctxtype;
BEGIN
   -- get a new context for the query
   l_xml_context := dbms_xmlquery.newcontext(sqlquery => p_query);

   -- now set the formatting defaults
   set_query_defaults(l_xml_context);

   -- get the DTD and return the result in the supplied CLOB
   p_xml := dbms_xmlquery.getdtd( ctxhdl => l_xml_context);
   -- close the query
   dbms_xmlquery.closecontext(ctxhdl => l_xml_context);

EXCEPTION
  WHEN others THEN
  -- write error to the clob
  write_error_message_to_clob('***********************************',p_xml);
  write_error_message_to_clob('The following error has occurred',p_xml);
  write_error_message_to_clob(SQLERRM,p_xml);
  write_error_message_to_clob('Whilst executing the query',p_xml);
  write_error_message_to_clob(p_query,p_xml);
  RAISE;
END get_dtd_from_query ;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_dtd_from_query( p_query         IN     varchar2
                             ,p_xml_varchar2  IN OUT varchar2)
IS
   l_xml_clob clob;

BEGIN


   get_dtd_from_query( p_query     => p_query
                      ,p_xml       => l_xml_clob);

   p_xml_varchar2 := nm3clob.lob_substr (p_clob      => l_xml_clob
                                        ,p_offset    => 1
                                        ,p_num_chars => 32767);


END get_dtd_from_query ;
--
-----------------------------------------------------------------------------
--
FUNCTION format_columns_for_csv(p_query IN varchar2) RETURN varchar2 IS
l_cols dbms_sql.desc_tab2;
l_retval nm3type.max_varchar2;
l_sep     varchar2(10) := NULL;
BEGIN

  l_cols := nm3flx.get_col_dets_from_sql2(p_query);
  FOR i IN 1..l_cols.COUNT LOOP
    l_retval := l_retval || l_sep ||l_cols(i).col_name;
    l_sep   := '||'',''||';
  END LOOP;
  debug_msg(l_retval);
  RETURN l_retval;
END format_columns_for_csv;
--
-----------------------------------------------------------------------------
--
PROCEDURE select_headings(p_query IN varchar2
                         ,p_csv   IN OUT NOCOPY nm3type.tab_varchar32767)
IS
  l_cols    dbms_sql.desc_tab2;
  l_cursor  nm3type.ref_cursor;
  l_sql     nm3type.max_varchar2;
  l_sep     varchar2(2);
BEGIN

  p_csv.DELETE;
  
  l_cols := nm3flx.get_col_dets_from_sql2(p_sql => p_query);
  
  FOR irec IN 1..l_cols.COUNT LOOP
    l_sql := l_sql || l_sep || CHR(39) ||l_cols(irec).col_name || CHR(39);
    l_sep := nm3type.c_comma_sep;
  END LOOP;
  
  l_sql := nm3type.c_select || nm3type.c_space || l_sql || nm3type.c_space || nm3type.c_from || nm3type.c_space || 'dual';

  l_sql := nm3type.c_select || nm3type.c_space || format_columns_for_csv(l_sql) || nm3type.c_space || nm3type.c_from || nm3type.c_space || 'dual';
  
  OPEN l_cursor FOR l_sql;
  LOOP

    FETCH l_cursor INTO p_csv(p_csv.COUNT + 1);
    
    EXIT WHEN l_cursor%NOTFOUND;
  END LOOP;
  
  CLOSE l_cursor;
  
  -- add the newline
  p_csv(p_csv.COUNT) := p_csv(p_csv.COUNT) || c_nl;
  
END select_headings;
--
-----------------------------------------------------------------------------
--
PROCEDURE select_headings(p_query IN varchar2
                         ,p_csv   IN OUT NOCOPY clob) IS
l_tab_vc nm3type.tab_varchar32767;
BEGIN
  select_headings(p_query => p_query
                 ,p_csv   => l_tab_vc);
  
  p_csv := nm3clob.tab_varchar_to_clob(l_tab_vc);
END select_headings;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_date_format RETURN varchar2 IS
CURSOR get_date IS
  SELECT value 
  FROM   nls_session_parameters
  WHERE  parameter = 'NLS_DATE_FORMAT';
  
  l_retval varchar2(100);
BEGIN
  OPEN get_date;
  FETCH get_date INTO l_retval;
  CLOSE get_date;
  
  RETURN l_retval;
END get_current_date_format;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_query_as_csv(p_query           IN            varchar2
                          ,p_csv             IN OUT NOCOPY nm3type.tab_varchar32767
                          ,p_include_headers IN            boolean)
IS
  l_cursor      pls_integer := dbms_sql.open_cursor;
  l_query       nm3type.max_varchar2;
  l_orig_format varchar2(100);
  l_num_cols    pls_integer;
  l_res         pls_integer;
  l_col_desc    dbms_sql.desc_tab2;
  l_val         nm3type.max_varchar2;
  l_sep         varchar2(1);
  l_count       pls_integer;
BEGIN
  -- clear out any contents 
   p_csv.DELETE;
   
   -- get current date format
   
   l_orig_format := get_current_date_format;

   EXECUTE IMMEDIATE 'alter session set nls_date_format='''||g_csv_date_format||'''';
   
   IF p_include_headers THEN
     select_headings(p_query => p_query
                    ,p_csv   => p_csv);
   END IF;
   
   dbms_sql.parse(l_cursor, p_query, dbms_sql.native);
   
   dbms_sql.describe_columns2(l_cursor, l_num_cols, l_col_desc);
   
   FOR I IN 1..l_num_cols LOOP
     -- fetch all values into a big varchar string
     CASE nm3flx.get_datatype_dbms_sql_desc_rec(p_rec => l_col_desc(i)) 
     WHEN 'VARCHAR2' THEN
       dbms_sql.define_column(l_cursor, i, l_val, l_col_desc(i).col_max_len);
     WHEN 'DATE' THEN
       dbms_sql.define_column(l_cursor, i, l_val, length(g_csv_date_format));
     WHEN 'NUMBER' THEN
       dbms_sql.define_column(l_cursor, i, l_val, l_col_desc(i).col_max_len);
     ELSE 
       dbms_sql.define_column(l_cursor, i, l_val, l_col_desc(i).col_max_len);
     END CASE;
   END LOOP;
   
   debug_msg('Query to be run ');
   debug_msg(l_query);
   
   l_res := dbms_sql.execute(l_cursor);
   
   WHILE (dbms_sql.fetch_rows(l_cursor) > 0) LOOP
     l_sep := NULL;
     l_count := p_csv.COUNT + 1;
     p_csv(l_count) := NULL;
     FOR irec IN 1..l_num_cols LOOP
     
       dbms_sql.column_value(l_cursor, irec, l_val);
       p_csv(l_count) := p_csv(l_count) || l_sep || REPLACE(l_val, CHR(44), g_comma_replacement);
       l_sep := CHR(44);
     END LOOP;
     p_csv(l_count) := p_csv(l_count) || c_nl;
   END LOOP;
   
   debug_msg('Result csv');
   debug_msg(p_csv);
   
   dbms_sql.close_cursor(l_cursor);
   
   EXECUTE IMMEDIATE 'alter session set nls_date_format='''||l_orig_format||'''';
   
END get_query_as_csv;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_query_as_csv(p_query           IN            varchar2
                          ,p_csv             IN OUT NOCOPY clob
                          ,p_include_headers IN            boolean)
IS
l_res nm3type.tab_varchar32767;
BEGIN
  get_query_as_csv(p_query           => p_query
                  ,p_csv             => l_res
                  ,p_include_headers => p_include_headers);

  p_csv := nm3clob.tab_varchar_to_clob(pi_tab_vc => l_res);
  
END get_query_as_csv;
--
-----------------------------------------------------------------------------
--
PROCEDURE csv_file_from_query(p_query         IN            varchar2
                             ,p_filename      IN            varchar2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
  
  l_clob CLOB;
  l_nuf nm_upload_files%ROWTYPE;
BEGIN
  nm3clob.create_clob(l_clob);
  get_query_as_csv(p_query => p_query
                  ,p_csv   => l_clob);

  l_nuf.name     := p_filename;
  l_nuf.doc_size := dbms_lob.getlength(l_clob);
  l_nuf.mime_type := 'application/octet';
  l_nuf.blob_content := nm3clob.clob_to_blob(l_clob);
  nm3ins.ins_nuf(l_nuf);
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END csv_file_from_query;
--
-----------------------------------------------------------------------------
--
-- Parameters
--
PROCEDURE set_parameter(p_module IN hig_hd_modules.hhm_module%TYPE
                       ,p_param  IN hig_hd_mod_parameters.hhp_parameter%TYPE
                       ,p_value  IN varchar2) IS
l_found boolean DEFAULT FALSE;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'set_parameter');

-- if the parameter has already been set then update the value
  
  IF g_params.COUNT != 0 THEN
    FOR i IN g_params.first..g_params.last LOOP
      IF g_params(i).hhp_module = p_module 
         AND g_params(i).hhp_parameter = p_param THEN
  
         l_found := TRUE;
         g_params(i).hhp_value := p_value;
      END IF;
    END LOOP;
  END IF;
  -- if we didnt find the parameter then add it
  IF NOT l_found THEN
    g_params(g_params.COUNT+1).hhp_module    := p_module;
    g_params(g_params.COUNT).hhp_parameter := p_param;
    g_params(g_params.COUNT).hhp_value     := p_value;
    debug_msg(p_param||' set to '|| p_value);
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'set_parameter');
END set_parameter;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_parameters(p_module IN hig_hd_modules.hhm_module%TYPE) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'clear_module_parameters');

  IF p_module IS NULL THEN
    g_params.DELETE;
    
  ELSE
    FOR i IN g_params.first..g_params.last LOOP
    
      IF g_params(i).hhp_module = p_module THEN
        g_params.DELETE(i);
      END IF;
    END LOOP;
  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'clear_module_parameters');
END clear_parameters;
--
-----------------------------------------------------------------------------
--
FUNCTION replace_parameters_in_query (p_module IN hig_hd_modules.hhm_module%TYPE
                                     ,p_query  IN varchar2) RETURN varchar2 IS

CURSOR get_default_values (p_module IN hig_hd_modules.hhm_module%TYPE) IS
SELECT hhp.hhp_parameter
      ,hhp.hhp_default_value
FROM   hig_hd_mod_parameters hhp
WHERE  hhp.hhp_hhm_module = p_module
AND    hhp.hhp_default_value IS NOT NULL;

TYPE l_params   IS TABLE OF hig_hd_mod_parameters.hhp_parameter%TYPE;
TYPE l_vals IS TABLE OF hig_hd_mod_parameters.hhp_default_value%TYPE;
l_def_params l_params;
l_def_vals   l_vals;

l_param CONSTANT varchar2(1) := ':';
l_query nm3type.max_varchar2 := p_query;
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'replace_parameters_in_query');

  -- only perform replacement if there are parameters in the query
  IF INSTR(p_query, l_param) > 0 THEN
  
    FOR i IN 1..g_params.COUNT LOOP
  
      IF g_params(i).hhp_module = p_module THEN
        
        debug_msg('Substituting parameter '||g_params(i).hhp_parameter||' with value '||g_params(i).hhp_value);
        -- now substitute
        l_query := REPLACE(l_query, l_param||g_params(i).hhp_parameter, g_params(i).hhp_value);
      END IF;
      
    END LOOP;
    
    -- now add default vales for any parameters not substituted
    OPEN  get_default_values(p_module);
    FETCH get_default_values BULK COLLECT INTO l_def_params, l_def_vals;
    CLOSE get_default_values;
    
    FOR i IN 1..l_def_params.COUNT LOOP
      l_query := REPLACE(l_query, l_param||l_def_params(i), l_def_vals(i));
    END LOOP;

  END IF;
  
  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'replace_parameters_in_query');

  RETURN l_query;

END replace_parameters_in_query;
--
-----------------------------------------------------------------------------
--
FUNCTION sql_parses_without_error (pi_sql           IN     varchar2
                                  ,po_error_message IN OUT varchar2) RETURN boolean IS

  e_not_all_vars_bound EXCEPTION;
  l_cur pls_integer;
  PRAGMA EXCEPTION_INIT (e_not_all_vars_bound, -1008 );

BEGIN

  po_error_message := NULL;
  l_cur := dbms_sql.open_cursor;
  dbms_sql.parse(c             => l_cur
                ,STATEMENT     => pi_sql
                ,language_flag => dbms_sql.native
                );
  dbms_sql.close_cursor(c => l_cur);
  
  RETURN TRUE;

EXCEPTION
  -- there may be parameters in the query which we cannot supply values for at this point, 
  -- so do not treat this as an error
  WHEN e_not_all_vars_bound THEN
    IF dbms_sql.is_open (c => l_cur) THEN
       dbms_sql.close_cursor(c => l_cur);
    END IF;
    RETURN TRUE;
  WHEN others THEN
    IF dbms_sql.is_open (c => l_cur) THEN
       dbms_sql.close_cursor(c => l_cur);
    END IF;
    po_error_message := SQLERRM;
    RETURN FALSE;

END sql_parses_without_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_xml_tag_case(p_case IN pls_integer)
IS
BEGIN
  IF p_case IN (c_lower_case, c_upper_case) THEN
    g_tag_case := p_case;
  END IF;
END set_xml_tag_case;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_date_format(p_format IN varchar2)
IS
BEGIN
   g_date_format := p_format;
END set_date_format;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_csv_date_format(p_format IN varchar2)
IS
BEGIN
   g_csv_date_format := p_format;
END set_csv_date_format;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_row_tag(p_tag IN varchar2)
IS
BEGIN
   IF g_tag_case = c_lower_case THEN
     g_row_tag := LOWER(p_tag);
   ELSE
     g_row_tag := UPPER(p_tag);
   END IF;
END set_row_tag;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_rowset_tag(p_tag IN varchar2)
IS
BEGIN
   IF g_tag_case = c_lower_case THEN
     g_row_set_tag := LOWER(p_tag);
   ELSE
     g_row_set_tag := UPPER(p_tag);
   END IF;
END set_rowset_tag;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_null_attribute_indicator (p_disp IN boolean) IS
BEGIN
  g_null_attribute_ind := p_disp;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_comma_replacement_char (p_char IN varchar2) IS
BEGIN
  g_comma_replacement := nm3flx.left(p_char, 1);
END;
--
-----------------------------------------------------------------------------
--
FUNCTION get_row_tag RETURN varchar2 IS
BEGIN
  RETURN g_row_tag;

END get_row_tag;
--
-----------------------------------------------------------------------------
--
FUNCTION get_rowset_tag RETURN varchar2 IS
BEGIN
  RETURN g_row_set_tag;

END get_rowset_tag;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xml_tag_case RETURN pls_integer IS
BEGIN
  RETURN g_tag_case;
END get_xml_tag_case;
--
-----------------------------------------------------------------------------
--
FUNCTION get_upper_tag_case RETURN pls_integer IS
BEGIN
  RETURN c_upper_case;
END get_upper_tag_case;
--
-----------------------------------------------------------------------------
--
FUNCTION get_lower_tag_case RETURN pls_integer IS
BEGIN
  RETURN c_lower_case;
END get_lower_tag_case;
--
-----------------------------------------------------------------------------
--
FUNCTION get_null_attribute_indicator RETURN boolean IS
BEGIN
  RETURN g_null_attribute_ind;
END get_null_attribute_indicator;
--
-----------------------------------------------------------------------------
--
FUNCTION get_comma_replacement_char RETURN varchar2 IS
BEGIN
  RETURN g_comma_replacement;
END get_comma_replacement_char;
--
-----------------------------------------------------------------------------
--
procedure nm3_context_on is
begin
  g_set_nm3_context := true ;  
end nm3_context_on;
--
-----------------------------------------------------------------------------
--
procedure nm3_context_off is
begin
  g_set_nm3_context := false ;  
end nm3_context_off;
--
-----------------------------------------------------------------------------
--
function is_nm3_context_on return boolean is
begin
  return g_set_nm3_context ;  
end is_nm3_context_on;
--
-----------------------------------------------------------------------------
--
procedure set_im_roi
  ( pi_roi_id   in integer 
  , pi_eff_date in date
  )
is
begin
  nm3_context_on ;

  -- Trunc of sysdate is the default
  nm3user.SET_EFFECTIVE_DATE(nvl(pi_eff_date,trunc(sysdate)));
  
  if pi_roi_id is not null
  then
    g_im_roi := nm3net.get_ne(pi_roi_id);
  else
    clear_im_roi ;
  end if ;
end set_im_roi;
--
-----------------------------------------------------------------------------
--
procedure clear_im_roi
is
l_roi nm_elements%ROWTYPE;
begin
  g_im_roi := l_roi ;
end clear_im_roi;
END hig_hd_query;
/
