CREATE OR REPLACE PACKAGE BODY hig_hd_extract AS
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_hd_extract.pkb	1.8 05/25/06
--       Module Name      : hig_hd_extract.pkb
--       Date into SCCS   : 06/05/25 10:44:56
--       Date fetched Out : 07/06/13 14:10:20
--       SCCS Version     : 1.8
--
--
--   Author : D. Cope
--
--   Package of dynamic sql routines used to generate xml from metadata
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
-- 02-05-03 DC - nm_debug calls commented out to aid performance
-- 06-05-03 DC - changes arising from testing against version 9.2.0.5.0 of xdk
--             - Queries of more than one attribute now need a row tag, row tag set in set_defaults
--               and removed in strip_header
-- 12-05-03 DC - added support for output of single column lists
--
-- all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)hig_hd_extract.pkb	1.8 05/25/06"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'HIG_HD_EXTRACT';
--
TYPE t_gri_clauses IS RECORD
  (table_name   hig_hd_mod_uses.hhu_table_name%TYPE
  ,where_clause nm3type.max_varchar2);

TYPE tab_rec_gri IS TABLE OF t_gri_clauses;

r_gri_clause tab_rec_gri := tab_rec_gri();
--
-- Global defaults
--
g_xml                   nm3type.tab_varchar32767;
g_header                CONSTANT varchar2(50) := '<?xml version = ''1.0''?>';
g_and_cond              CONSTANT varchar2(5)  := nm3type.c_space||nm3type.c_and_operator||nm3type.c_space;
g_xml_open_start_tag    CONSTANT varchar2(1)  := '<';
g_xml_open_end_tag      CONSTANT varchar2(1)  := '>';
g_xml_close_start_tag   CONSTANT varchar2(2)  := '</';
g_xml_close_end_tag     CONSTANT varchar2(1)  := '>';
g_rowset_tag                     varchar2(30) := 'ROWSET'; 
g_file                           utl_file.file_type;
g_working_clob          clob ;           
-- Exceptions
e_no_such_module EXCEPTION;
PRAGMA EXCEPTION_INIT(e_no_such_module, -20502);
--
-- Error detected is a flag to indicate if there has been an error
-- raised somewhere. When in the recursive create_xml is ensures
-- that the recursive loops are exited quickly and not looped to completion.
g_error_detected boolean DEFAULT FALSE; 
--
-- flag to control the output of headings when outputting csv
g_headers_not_included_yet boolean DEFAULT TRUE;
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
PROCEDURE clear_error IS
BEGIN
  g_error_detected := FALSE;
END clear_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_gri_table IS
BEGIN
  r_gri_clause := tab_rec_gri();
END clear_gri_table;
--
-----------------------------------------------------------------------------
--
PROCEDURE append(p_chrs IN varchar2
                ,p_nl   IN boolean DEFAULT TRUE) IS
BEGIN
  -- if the output file is open write results to it
  -- otherwise add the results to the clob
  IF utl_file.is_open(g_file) THEN

    utl_file.put(g_file, p_chrs);
    
    IF p_nl THEN
      utl_file.new_line(g_file);
    END IF;

    utl_file.fflush(g_file);

  ELSE

    nm3tab_varchar.append(p_tab_vc => g_xml
                         ,p_text   => p_chrs
                         ,p_nl     => p_nl);
  END IF;
END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE append(p_tab_vc IN nm3type.tab_varchar32767
                ,p_nl     IN boolean DEFAULT TRUE) IS


BEGIN
  -- if the output file is open write results to it
  -- otherwise add the results to the clob
  
  IF utl_file.is_open(g_file) THEN
    FOR i IN 1..p_tab_vc.COUNT LOOP
      utl_file.put(g_file, p_tab_vc(i));
    END LOOP;
    
    IF p_nl THEN
      utl_file.new_line(g_file);
    END IF;
    utl_file.fflush(g_file);
  ELSE
    
    FOR i IN 1..p_tab_vc.COUNT LOOP
      append(p_chrs => p_tab_vc(i), p_nl => p_nl);
    END LOOP;

  END IF;

END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE append(p_clob IN clob
                ,p_nl   IN boolean DEFAULT TRUE) IS

BEGIN
  append(p_tab_vc => nm3clob.clob_to_tab_varchar(p_clob)
        ,p_nl     => p_nl);

END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_header IS
BEGIN
  -- add mandatory xml header
  append(g_header); 

END add_header;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_defaults(p_module IN hig_hd_modules.hhm_module%TYPE) IS

BEGIN
  -- lower case output of tags
  hig_hd_query.set_xml_tag_case(1);
  -- set all row tags to null, as this package sets the tags
  hig_hd_query.set_row_tag(NULL);
  hig_hd_query.set_rowset_tag(g_rowset_tag);

END set_defaults;
--
-----------------------------------------------------------------------------
--
FUNCTION strip_header (p_clob IN OUT NOCOPY clob) RETURN varchar2 IS
l_hdr pls_integer DEFAULT LENGTH(g_header);
l_tag pls_integer DEFAULT LENGTH('<'||g_rowset_tag||'>') + 2; -- add 2 on for the carriage returns between header and tag
BEGIN
  -- xml restrictions mean that all queries have to have the xml header
  -- and from xdk version 9.2 onwards they must also have a 
  -- row or rowset tag if more than one column is output
  -- so they need stripping.
  
  RETURN dbms_lob.SUBSTR(p_clob, dbms_lob.getlength(p_clob) - l_hdr - (l_tag * 2) , l_hdr + l_tag + 1);
  
END strip_header;
--
-----------------------------------------------------------------------------
--
PROCEDURE open_tag (p_tag IN hig_hd_modules.hhm_tag%TYPE) IS
BEGIN
  IF p_tag IS NOT NULL THEN
    IF hig_hd_query.get_xml_tag_case = 1 THEN
       append(g_xml_open_start_tag||LOWER(p_tag)||g_xml_open_end_tag);
    ELSE
       append(g_xml_open_start_tag||UPPER(p_tag)||g_xml_open_end_tag);
    END IF;
  END IF;
END open_tag;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_tag (p_tag IN hig_hd_modules.hhm_tag%TYPE) IS
BEGIN
  IF p_tag IS NOT NULL THEN
    IF hig_hd_query.get_xml_tag_case = 1 THEN
       append(g_xml_close_start_tag||LOWER(p_tag)||g_xml_close_end_tag);
    ELSE
       append(g_xml_close_start_tag||UPPER(p_tag)||g_xml_close_end_tag);
    END IF;
  END IF;
END close_tag;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_lob (p_clob IN OUT NOCOPY clob) IS

BEGIN
  dbms_lob.createtemporary(lob_loc => p_clob
                          ,CACHE   => TRUE);

END create_lob;
--
-----------------------------------------------------------------------------
--
PROCEDURE free_lob (p_clob IN OUT NOCOPY clob) IS
BEGIN
  dbms_lob.freetemporary(p_clob);
END free_lob;
--
-----------------------------------------------------------------------------
--
PROCEDURE open_file(p_dir  IN varchar2
                   ,p_file IN varchar2) IS
BEGIN
  g_file := nm3file.fopen(location => p_dir
                         ,filename => p_file
                         ,open_mode => nm3file.c_write_mode
                         ,max_linesize => 32767);
END open_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE close_file IS
BEGIN
  nm3file.fclose(g_file);
END close_file;
--
-----------------------------------------------------------------------------
-- get the parameters supplied
FUNCTION get_gri_vals (p_job        IN gri_run_parameters.grp_job_id%TYPE
                      ,p_param      IN gri_params.gp_param%TYPE
                      ,p_param_type IN gri_params.gp_param_type%TYPE
                      ,p_operator   IN gri_module_params.gmp_operator%TYPE DEFAULT '=') RETURN varchar2 IS

CURSOR all_param_values(p_job        IN gri_run_parameters.grp_job_id%TYPE
                       ,p_param      IN gri_params.gp_param%TYPE
                       ,p_param_type IN gri_params.gp_param_type%TYPE) IS 
SELECT DECODE(p_param_type, 'CHAR',   ''''||grp_value||''''
                          , 'NUMBER', grp_value
                          , 'DATE', ''''||grp_value||'''') itm_val
FROM   gri_run_parameters gr
WHERE  gr.grp_param  = p_param
AND    gr.grp_job_id = p_job
AND    gr.grp_value IS NOT NULL
ORDER BY gr.grp_seq;

l_sep    varchar2(2) DEFAULT NULL;
l_retval nm3type.max_varchar2;
l_vals   pls_integer DEFAULT 0; 

BEGIN
 --nm_debug.proc_start(g_package_name, 'get_gri_vals');
 FOR l_param IN all_param_values(p_job        => p_job
                                ,p_param      => p_param
                                ,p_param_type => p_param_type) LOOP
   IF l_param.itm_val IS NOT NULL THEN
     l_retval := l_retval|| l_sep || l_param.itm_val;
     l_sep := nm3type.c_comma_sep;
     l_vals := l_vals + 1;
   END IF;

 END LOOP;
 -- if more than one value presented then it must be an IN clause
 IF l_vals > 1 THEN
   --nm_debug.proc_end(g_package_name, 'get_gri_vals');
   RETURN nm3type.c_in||' ('||l_retval||')';
 ELSIF l_vals = 1 THEN
    --nm_debug.proc_end(g_package_name, 'get_gri_vals');
   RETURN p_operator || nm3type.c_space || l_retval;
 ELSE
   --nm_debug.proc_end(g_package_name, 'get_gri_vals');
   RETURN NULL;
 END IF;
END get_gri_vals;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_gri_params(p_job      IN gri_run_parameters.grp_job_id%TYPE) IS

CURSOR get_mod_det (p_job_id IN gri_run_parameters.grp_job_id%TYPE) IS
SELECT gmp.gmp_param
      ,NVL(gmp.gmp_base_table_column, gp.gp_column) gmp_column
      ,NVL(gmp.gmp_base_table, gp.gp_table) gmp_table
      ,gp.gp_param_type
      ,gmp.gmp_operator
FROM   gri_module_params     gmp
      ,gri_report_runs       grr
      ,gri_params            gp
WHERE  grr.grr_job_id = p_job_id
AND    grr.grr_module = gmp.gmp_module
AND    gmp.gmp_param  = gp.gp_param;

l_where nm3type.max_varchar2;

PROCEDURE add_entry (p_table hig_hd_mod_uses.hhu_table_name%TYPE
                    ,p_where nm3type.max_varchar2) IS
BEGIN
  --nm_debug.debug('Adding entry for '||p_table||g_and_cond||p_where);
  IF p_where IS NOT NULL THEN
    r_gri_clause.extend;
    r_gri_clause(r_gri_clause.last).table_name   := p_table;
    r_gri_clause(r_gri_clause.last).where_clause := p_where;
  END IF;
  
END;

BEGIN
  --nm_debug.proc_start(g_package_name, 'process_gri_params');
  FOR l_param IN get_mod_det(p_job) LOOP
     
     l_where := get_gri_vals(p_job
                            ,l_param.gmp_param
                            ,l_param.gp_param_type
                            ,l_param.gmp_operator);
     IF l_where IS NOT NULL THEN
       add_entry(l_param.gmp_table
                ,l_param.gmp_column || nm3type.c_space || l_where);
     END IF;

  END LOOP;
  --nm_debug.proc_end(g_package_name, 'process_gri_params');
END process_gri_params;
--
-----------------------------------------------------------------------------
--
FUNCTION get_where_clause_from_gri (p_table  IN hig_hd_mod_uses.hhu_table_name%TYPE
                                   ,p_alias  IN hig_hd_mod_uses.hhu_alias%TYPE) 
RETURN varchar2 IS


l_where  nm3type.max_varchar2 DEFAULT NULL;
l_sep    varchar2(10)         DEFAULT NULL;

BEGIN

  --nm_debug.proc_start(g_package_name, 'get_where_clause_from_gri');
  --nm_debug.debug('Called with '||p_table);
  -- look up where clause in plsql table

  FOR i IN 1..r_gri_clause.COUNT LOOP
    IF r_gri_clause(i).table_name = p_table THEN
      l_where := l_where || l_sep || p_alias || nm3type.c_dot || r_gri_clause(i).where_clause;

      l_sep := g_and_cond;
    END IF;
  END LOOP;

  --nm_debug.debug('Where clause returned is '||l_where);
  --nm_debug.proc_end(g_package_name, 'get_where_clause_from_gri');
  RETURN l_where;
END get_where_clause_from_gri;
--
-----------------------------------------------------------------------------
--
FUNCTION add_to_where(p_where          IN varchar2
                     ,p_new_condition  IN varchar2
                     ,p_operator       IN varchar2 DEFAULT nm3type.c_and_operator) RETURN varchar2 IS
l_retval nm3type.max_varchar2;
BEGIN
  --nm_debug.proc_start(g_package_name, 'add_to_where');
  IF p_new_condition IS NOT NULL THEN
    IF p_where IS NULL THEN
      l_retval := p_new_condition || nm3type.c_space;
    ELSE
      l_retval := p_where || nm3type.c_space || p_operator
                  || nm3type.c_space || p_new_condition;
    END IF;
    
    --nm_debug.debug('add to where returning:'||l_retval);
    --nm_debug.proc_end(g_package_name, 'add_to_where');
    
    RETURN l_retval;
  ELSE
    --nm_debug.debug('add to where returning:'||p_where);
    --nm_debug.proc_end(g_package_name, 'add_to_where');
    
    RETURN p_where;
  END IF;
END add_to_where;
--
-----------------------------------------------------------------------------
--
FUNCTION get_num_cols(p_module   IN hig_hd_modules.hhm_module%TYPE
                     ,p_muj_seq  IN hig_hd_mod_uses.hhu_seq%TYPE) RETURN pls_integer IS

CURSOR get_num_cols (p_module   IN hig_hd_modules.hhm_module%TYPE
                    ,p_muj_seq  IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT COUNT(*) num
FROM   hig_hd_selected_cols
WHERE  hhc_hhu_hhm_module = p_module
AND    hhc_hhu_seq        = p_muj_seq;

l_retval pls_integer;
BEGIN
  OPEN get_num_cols(p_module
                   ,p_muj_seq);
  FETCH get_num_cols INTO l_retval;
  CLOSE get_num_cols;
  
  RETURN l_retval;
END get_num_cols;
--
-----------------------------------------------------------------------------
--
PROCEDURE hier_xml(p_module       IN hig_hd_modules.hhm_module%TYPE
                  ,p_muj_seq      IN hig_hd_mod_uses.hhu_seq%TYPE DEFAULT NULL
                  ,p_parent_muj   IN hig_hd_mod_uses.hhu_seq%TYPE DEFAULT NULL
                  ,p_rowid        IN urowid   DEFAULT NULL
                  ,p_job          IN gri_run_parameters.grp_job_id%TYPE DEFAULT NULL
                  ,p_paramlist    IN hig_hd_query.t_param_list DEFAULT hig_hd_query.g_dummy_table) IS

-- Types
TYPE rc IS REF CURSOR;
--
CURSOR get_child_tables (p_module  IN hig_hd_modules.hhm_module%TYPE
                        ,p_muj_seq IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT hhu_seq
FROM   hig_hd_mod_uses
WHERE  hhu_hhm_module = p_module 
AND    hhu_parent_seq = p_muj_seq
ORDER BY hhu_seq;
--
CURSOR get_join_det (p_module      IN hig_hd_modules.hhm_module%TYPE
                    ,p_parent_seq  IN hig_hd_mod_uses.hhu_seq%TYPE
                    ,p_muj_seq     IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT hhj_hht_join_seq
FROM   hig_hd_table_join_cols
WHERE  hhj_hht_hhu_hhm_module   = p_module
AND    hhj_hht_hhu_parent_table = p_parent_seq
AND    hhj_hhu_child_table      = p_muj_seq;
--
l_table_det       hig_hd_mod_uses%ROWTYPE;
c_get_rowid       rc;
l_query           nm3type.max_varchar2 DEFAULT NULL;
l_row_query       nm3type.max_varchar2 DEFAULT NULL;
l_row             urowid;
l_where_clause    nm3type.max_varchar2 DEFAULT NULL;
l_order_by        nm3type.max_varchar2 DEFAULT NULL;
l_num_cols        pls_integer;
l_param_vals      hig_hd_query.t_param_list DEFAULT hig_hd_query.g_dummy_table;
l_columns_tab     nm3type.tab_varchar2000;
l_alias_tab       nm3type.tab_varchar2000;
l_displayed_tab   nm3type.tab_varchar1;
l_calc_ratio_tab  nm3type.tab_varchar1;

l_row_cur         pls_integer DEFAULT dbms_sql.open_cursor;
l_col_count       pls_integer DEFAULT 0;
l_col_desc        dbms_sql.desc_tab;
l_selecting_rowid boolean DEFAULT TRUE;
l_row_where       nm3type.max_varchar2 DEFAULT NULL;
l_res             pls_integer;
-- Exceptions
e_more_than_one_col EXCEPTION;
PRAGMA EXCEPTION_INIT(e_more_than_one_col, -20122);
BEGIN
  ----nm_debug.proc_start(g_package_name, 'hier_xml');
  ----nm_debug.debug('Called with');
  ----nm_debug.debug('p_muj_seq = '||p_muj_seq);
  ----nm_debug.debug('p_parent_muj = '||p_parent_muj);
  ----nm_debug.debug('p_rowid = '||p_rowid);

  l_table_det := nm3get.get_hhu(pi_hhu_hhm_module => p_module
                               ,pi_hhu_seq        => p_muj_seq);
  
  IF l_table_det.hhu_alias IS NULL THEN
  -- no table alias it is either an error or one column is to be output as a list
    ----nm_debug.debug('Alias is null so getting child columns');

     l_num_cols := get_num_cols(p_module
                               ,p_muj_seq);

    IF l_num_cols != 1 THEN
       RAISE e_more_than_one_col;
    END IF;
  END IF;

  IF p_parent_muj IS NOT NULL THEN

    -- calling build_where_clause
    FOR l_join IN get_join_det (p_module
                               ,p_parent_muj
                               ,p_muj_seq) LOOP

    --  build up where clause add join conditions
    l_where_clause := add_to_where(l_where_clause
                                  ,hig_hd_query.build_where_clause(p_muj_module   => p_module
                                                                  ,p_muj_seq      => p_parent_muj
                                                                  ,p_muj_join_seq => l_join.hhj_hht_join_seq
                                                                  ,p_rowid        => p_rowid
                                                                  ,p_paramlist    => p_paramlist));

    END LOOP;
  END IF;
  
  -- are there unqiue identifiers on the table?
  hig_hd_query.get_columns(pi_module                    => p_module
                          ,pi_seq                       => p_muj_seq
                          ,pi_just_the_order_by_cols    => 'N'
                          ,pi_just_the_unique_cols      => 'Y'
                          ,pi_summary_view              => 'N'
                          ,pi_select_rowid              => FALSE
                          ,pi_select_unique_identifiers => FALSE
                          ,po_columns_tab               => l_columns_tab
                          ,po_alias_tab                 => l_alias_tab
                          ,po_displayed_tab             => l_displayed_tab
                          ,po_calc_ratio_tab            => l_calc_ratio_tab);
  
  --nm_debug.debug(l_columns_tab.COUNT||' unique columns');
  
  IF l_columns_tab.COUNT > 0 THEN
    --nm_debug.debug('not using rowid');
    -- select unqique idenitifiers
    l_query := nm3type.c_select|| nm3type.c_space || hig_hd_query.build_column_list(pi_columns_tab => l_columns_tab
                                                                                   ,pi_alias_tab   => l_alias_tab);
    l_selecting_rowid := FALSE;
  ELSE
    -- get a set of rowids to use to query single rows
 
    l_query := nm3type.c_select|| nm3type.c_space || NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name)||'.ROWID ';
    l_selecting_rowid := TRUE;
  END IF;
  
  l_query := l_query || nm3type.c_newline|| nm3type.c_from || nm3type.c_space || l_table_det.hhu_table_name 
                     ||nm3type.c_space || NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name); 
  
  -- build up the where clause from the gri conditions
  -- and any fixed table where clause
  l_where_clause := add_to_where(l_where_clause
                                ,get_where_clause_from_gri(p_table  => l_table_det.hhu_table_name
                                                          ,p_alias  => NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name)));
  
  l_where_clause := add_to_where(l_where_clause
                                ,l_table_det.hhu_fixed_where_clause);

  IF l_where_clause IS NOT NULL THEN
     l_query := l_query || nm3type.c_space|| nm3type.c_where 
                        || nm3type.c_space || l_where_clause; 
  END IF;
  
  -- add the order by clause
  
  l_order_by := hig_hd_query.return_order_by_cols(p_module => p_module
                                                 ,p_seq    => p_muj_seq);
  IF l_order_by IS NOT NULL THEN
    l_query := l_query || nm3type.c_newline || l_order_by;
  END IF;
  
  -- replace any parameters in the query
  l_query := hig_hd_query.replace_parameters_in_query(p_module => p_module
                                                     ,p_query  => l_query);
  --nm_debug.debug('hier Query is:');
  --nm_debug.debug(l_query);
  
  dbms_sql.parse(l_row_cur, l_query, dbms_sql.native);
  
  dbms_sql.describe_columns(l_row_cur, l_col_count, l_col_desc);
  
  FOR i IN 1..l_col_count LOOP
    IF nm3flx.get_datatype_dbms_sql_desc_rec(l_col_desc(i)) IN ('ROWID', 'UROWID') THEN

      dbms_sql.define_column(l_row_cur, i, l_row);
    ELSE
      l_param_vals(i) := nm3type.c_nvl;
      dbms_sql.define_column(l_row_cur, i, l_param_vals(i), l_col_desc(i).col_max_len);
    END IF;
  END LOOP;
  --nm_debug.debug('pre execute');
  l_res := dbms_sql.EXECUTE(l_row_cur);
  -- build where clause
  --nm_debug.debug('executed');
  
  WHILE (dbms_sql.fetch_rows(l_row_cur) > 0)
  LOOP

      -- for unique key in driving cursor loop
      EXIT WHEN g_error_detected;

      -- get the values back from the cursor
      FOR i IN 1..l_col_count LOOP
        IF nm3flx.get_datatype_dbms_sql_desc_rec(l_col_desc(i)) IN ('ROWID', 'UROWID') THEN
           dbms_sql.column_value(l_row_cur, i, l_row);
        ELSE
           dbms_sql.column_value(l_row_cur, i, l_param_vals(i));
        END IF;
      END LOOP;
            
      -- select row and return as xml
      -- need to set the correct alias
      l_row_where := NULL;
      IF l_selecting_rowid THEN
        -- use rowid to restrict the rows
        l_row_where := NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name) ||'.ROWID = '''|| l_row||'''';
        --nm_debug.debug('where clause using rowid is');
        --nm_debug.debug(l_row_where);
      ELSE
        -- use the list of unique values to restrict the rows

        FOR i IN 1..l_columns_tab.COUNT LOOP
          --nm_debug.debug('Using nm3flx');

          nm3flx.add_to_where_clause(pi_existing_clause   => l_row_where
                                    ,pi_prefix_with_where => FALSE
                                    ,pi_column_name       => l_columns_tab(i)
                                    ,pi_column_datatype   => nm3flx.get_datatype_dbms_sql_desc_rec(l_col_desc(i))
                                    ,pi_operator          => nm3type.c_equals
                                    ,pi_string_value      => l_param_vals(i));
        END LOOP;
        --nm_debug.debug('where clause is');
        --nm_debug.debug(l_row_where);
      END IF;
            
      -- set row tag here 
      if nvl(l_table_det.hhu_tag,'!') <> '.'
      then
        open_tag(l_table_det.hhu_alias);
      end if ;

      -- select row and return as xml
      -- need to set the correct alias
      l_row_query := hig_hd_query.get_query(p_module              => p_module
                                           ,p_seq                 => l_table_det.hhu_seq
                                           ,p_where               => NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name)
                                                                         ||'.ROWID = '''|| l_row||''''
                                           ,p_just_displayed_cols => TRUE);
      if g_working_clob is null
      then
        create_lob(g_working_clob);
      end if ;  

      hig_hd_query.get_query_as_xml(p_query => l_row_query
                                   ,p_xml   => g_working_clob);

      -- append results to main clob
      append(strip_header(g_working_clob), FALSE);
      
      -- for all child tables of this table
      FOR child_tabs IN get_child_tables(p_module
                                        ,l_table_det.hhu_seq) LOOP

         --nm_debug.debug('Recursively calling hier_xml with p_muj_seq as '||child_tabs.hhu_seq||' and p_parent_muj as '||l_table_det.hhu_seq);
         -- output_xml
         hier_xml(p_module       => p_module
                 ,p_muj_seq      => child_tabs.hhu_seq
                 ,p_parent_muj   => l_table_det.hhu_seq 
                 ,p_rowid        => l_row
                 ,p_job          => p_job
                 ,p_paramlist    => l_param_vals);
                   
         -- exit if an error has been detected
         EXIT WHEN g_error_detected;

      END LOOP;

      -- output close rowset tag
      if nvl(l_table_det.hhu_tag,'!') <> '.'
      then
        close_tag(l_table_det.hhu_alias);
      end if ;
   
   END LOOP;
   
   dbms_sql.close_cursor(l_row_cur);

   --nm_debug.proc_end(g_package_name, 'hier_xml');
     
EXCEPTION
  WHEN e_more_than_one_col THEN
     hig.raise_ner(pi_appl => nm3type.c_hig
                  ,pi_id   => 215);
  WHEN others THEN
     IF dbms_sql.is_open (l_row_cur) THEN
           dbms_sql.close_cursor(l_row_cur);
     END IF;
     --nm_debug.debug('Error caught in hier_xml');
     append('*******************************');
     append('Error in output. Last query:');
     append(l_query);
     append('Produced Error:');
     append(SQLERRM);
     -- set the error flag to ensure that
     -- we do not carry on around the loops fetching xml
     g_error_detected := TRUE;

END hier_xml;
--
-----------------------------------------------------------------------------
--
PROCEDURE hier_csv(p_module       IN hig_hd_modules.hhm_module%TYPE
                  ,p_muj_seq      IN hig_hd_mod_uses.hhu_seq%TYPE DEFAULT NULL
                  ,p_parent_muj   IN hig_hd_mod_uses.hhu_seq%TYPE DEFAULT NULL
                  ,p_rowid        IN urowid   DEFAULT NULL
                  ,p_job          IN gri_run_parameters.grp_job_id%TYPE DEFAULT NULL
                  ,p_paramlist    IN hig_hd_query.t_param_list DEFAULT hig_hd_query.g_dummy_table
                  ,p_inc_headers  IN boolean DEFAULT FALSE) IS

--
CURSOR get_child_tables (p_module  IN hig_hd_modules.hhm_module%TYPE
                        ,p_muj_seq IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT hhu_seq
FROM   hig_hd_mod_uses
WHERE  hhu_hhm_module = p_module 
AND    hhu_parent_seq = p_muj_seq
ORDER BY hhu_seq;
--
CURSOR get_join_det (p_module      IN hig_hd_modules.hhm_module%TYPE
                    ,p_parent_seq  IN hig_hd_mod_uses.hhu_seq%TYPE
                    ,p_muj_seq     IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT hhj_hht_join_seq
FROM   hig_hd_table_join_cols
WHERE  hhj_hht_hhu_hhm_module   = p_module
AND    hhj_hht_hhu_parent_table = p_parent_seq
AND    hhj_hhu_child_table      = p_muj_seq;
--
l_table_det       hig_hd_mod_uses%ROWTYPE;
c_get_rowid       nm3type.ref_cursor;
l_query           nm3type.max_varchar2 DEFAULT NULL;
l_row_query       nm3type.max_varchar2 DEFAULT NULL;
l_row             urowid;
l_where_clause    nm3type.max_varchar2 DEFAULT NULL;
l_order_by        nm3type.max_varchar2 DEFAULT NULL;
l_csv             nm3type.tab_varchar32767;
l_param_vals      hig_hd_query.t_param_list DEFAULT hig_hd_query.g_dummy_table;
l_columns_tab     nm3type.tab_varchar2000;
l_alias_tab       nm3type.tab_varchar2000;
l_displayed_tab   nm3type.tab_varchar1;
l_calc_ratio_tab  nm3type.tab_varchar1;

l_row_cur         pls_integer DEFAULT dbms_sql.open_cursor;
l_col_count       pls_integer DEFAULT 0;
l_col_desc        dbms_sql.desc_tab;
l_selecting_rowid boolean DEFAULT TRUE;
l_row_where       nm3type.max_varchar2 DEFAULT NULL;
l_res             pls_integer;
BEGIN
  --nm_debug.proc_start(g_package_name, 'hier_csv');
  --nm_debug.debug('Called with');
  --nm_debug.debug('p_module = '||p_module);
  --nm_debug.debug('p_muj_seq = '||p_muj_seq);
  --nm_debug.debug('p_parent_muj = '||p_parent_muj);
  --nm_debug.debug('p_rowid = '||p_rowid);

  l_table_det := nm3get.get_hhu(pi_hhu_hhm_module => p_module
                               ,pi_hhu_seq        => p_muj_seq);

  IF p_parent_muj IS NOT NULL THEN

    -- calling build_where_clause
    FOR l_join IN get_join_det (p_module
                               ,p_parent_muj
                               ,p_muj_seq) LOOP

    --  build up where clause add join conditions
    l_where_clause := add_to_where(l_where_clause
                                  ,hig_hd_query.build_where_clause(p_muj_module   => p_module
                                                                  ,p_muj_seq      => p_parent_muj
                                                                  ,p_muj_join_seq => l_join.hhj_hht_join_seq
                                                                  ,p_rowid        => p_rowid
                                                                  ,p_paramlist    => p_paramlist));

    END LOOP;
  END IF;
  
  -- are there unqiue identifiers on the table?
  hig_hd_query.get_columns(pi_module                    => p_module
                          ,pi_seq                       => p_muj_seq
                          ,pi_just_the_order_by_cols    => 'N'
                          ,pi_just_the_unique_cols      => 'Y'
                          ,pi_summary_view              => 'N'
                          ,pi_select_rowid              => FALSE
                          ,pi_select_unique_identifiers => FALSE
                          ,po_columns_tab               => l_columns_tab
                          ,po_alias_tab                 => l_alias_tab
                          ,po_displayed_tab             => l_displayed_tab
                          ,po_calc_ratio_tab            => l_calc_ratio_tab);
  
  --nm_debug.debug(l_columns_tab.COUNT||' unique columns');
  
  IF l_columns_tab.COUNT > 0 THEN
    --nm_debug.debug('not using rowid');
    -- select unqique idenitifiers
    l_query := nm3type.c_select|| nm3type.c_space || hig_hd_query.build_column_list(pi_columns_tab => l_columns_tab
                                                                                   ,pi_alias_tab   => l_alias_tab);
    l_selecting_rowid := FALSE;
  ELSE
    -- get a set of rowids to use to query single rows
 
    l_query := nm3type.c_select|| nm3type.c_space || NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name)||'.ROWID ';
    l_selecting_rowid := TRUE;
  END IF;
  
  l_query := l_query || nm3type.c_newline|| nm3type.c_from || nm3type.c_space || l_table_det.hhu_table_name 
                     ||nm3type.c_space || NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name); 
  
  -- build up the where clause from the gri conditions
  -- and any fixed table where clause
  l_where_clause := add_to_where(l_where_clause
                                ,get_where_clause_from_gri(p_table  => l_table_det.hhu_table_name
                                                          ,p_alias  => NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name)));
  
  l_where_clause := add_to_where(l_where_clause
                                ,l_table_det.hhu_fixed_where_clause);

  IF l_where_clause IS NOT NULL THEN
     l_query := l_query || nm3type.c_space|| nm3type.c_where 
                        || nm3type.c_space || l_where_clause; 
  END IF;
  
  -- add the order by clause
  l_order_by := hig_hd_query.return_order_by_cols(p_module => p_module
                                                 ,p_seq    => p_muj_seq);
  IF l_order_by IS NOT NULL THEN
    l_query := l_query || nm3type.c_newline || l_order_by;
  END IF;
  
  -- replace any parameters in the query
  l_query := hig_hd_query.replace_parameters_in_query(p_module => p_module
                                                     ,p_query  => l_query);
  --nm_debug.debug('hier Query is:');
  --nm_debug.debug(l_query);

  dbms_sql.parse(l_row_cur, l_query, dbms_sql.native);
  
  dbms_sql.describe_columns(l_row_cur, l_col_count, l_col_desc);
  
  FOR i IN 1..l_col_count LOOP
    IF nm3flx.get_datatype_dbms_sql_desc_rec(l_col_desc(i)) IN ('ROWID', 'UROWID') THEN

      dbms_sql.define_column(l_row_cur, i, l_row);
    ELSE
      l_param_vals(i) := nm3type.c_nvl;
      dbms_sql.define_column(l_row_cur, i, l_param_vals(i), l_col_desc(i).col_max_len);
    END IF;
  END LOOP;
  --nm_debug.debug('pre execute');
  l_res := dbms_sql.EXECUTE(l_row_cur);
  -- build where clause
  --nm_debug.debug('executed');
  
  WHILE (dbms_sql.fetch_rows(l_row_cur) > 0)
  LOOP

      -- for unique key in driving cursor loop
      EXIT WHEN g_error_detected;

      -- get the values back from the cursor
      FOR i IN 1..l_col_count LOOP
        IF nm3flx.get_datatype_dbms_sql_desc_rec(l_col_desc(i)) IN ('ROWID', 'UROWID') THEN
           dbms_sql.column_value(l_row_cur, i, l_row);
        ELSE
           dbms_sql.column_value(l_row_cur, i, l_param_vals(i));
        END IF;
      END LOOP;

      -- select row and return as xml
      -- need to set the correct alias
      l_row_where := NULL;
      IF l_selecting_rowid THEN
        -- use rowid to restrict the rows
        l_row_where := NVL(l_table_det.hhu_alias, l_table_det.hhu_table_name) ||'.ROWID = '''|| l_row||'''';
        --nm_debug.debug('where clause using rowid is');
        --nm_debug.debug(l_row_where);
      ELSE
        -- use the list of unique values to restrict the rows

        FOR i IN 1..l_columns_tab.COUNT LOOP
          --nm_debug.debug('Using nm3flx');

          nm3flx.add_to_where_clause(pi_existing_clause   => l_row_where
                                    ,pi_prefix_with_where => FALSE
                                    ,pi_column_name       => l_columns_tab(i)
                                    ,pi_column_datatype   => nm3flx.get_datatype_dbms_sql_desc_rec(l_col_desc(i))
                                    ,pi_operator          => nm3type.c_equals
                                    ,pi_string_value      => l_param_vals(i));
        END LOOP;
        --nm_debug.debug('where clause is');
        --nm_debug.debug(l_row_where);
      END IF;
      
      l_row_query := hig_hd_query.get_query(p_module              => p_module
                                           ,p_seq                 => l_table_det.hhu_seq
                                           ,p_where               => l_row_where
                                           ,p_just_displayed_cols => TRUE);

      IF p_inc_headers AND g_headers_not_included_yet THEN
        hig_hd_query.get_query_as_csv(p_query => l_row_query
                                     ,p_csv   => l_csv
                                     ,p_include_headers => TRUE);

        g_headers_not_included_yet := FALSE;
      ELSE
        hig_hd_query.get_query_as_csv(p_query => l_row_query
                                     ,p_csv   => l_csv);
      END IF;

      -- append results
      append(l_csv, FALSE);
      
      -- for all child tables of this table
      FOR child_tabs IN get_child_tables(p_module
                                        ,l_table_det.hhu_seq) LOOP

         --nm_debug.debug('Recursively calling hier_csv with p_muj_seq as '||child_tabs.hhu_seq||' and p_parent_muj as '||l_table_det.hhu_seq);
         -- output_xml
         hier_csv(p_module       => p_module
                 ,p_muj_seq      => child_tabs.hhu_seq
                 ,p_parent_muj   => l_table_det.hhu_seq 
                 ,p_rowid        => l_row
                 ,p_job          => p_job
                 ,p_paramlist    => l_param_vals);
                   
         -- exit if an error has been detected
         EXIT WHEN g_error_detected;

      END LOOP;

   END LOOP;   
   
   dbms_sql.close_cursor(l_row_cur);
   
   --nm_debug.proc_end(g_package_name, 'hier_csv');
   
EXCEPTION
  WHEN others THEN
     IF dbms_sql.is_open (l_row_cur) THEN
           dbms_sql.close_cursor(l_row_cur);
     END IF;
     RAISE;
     /*
     --nm_debug.debug('Error caught in hier_csv');
     append('*******************************');
     append('Error in output. Last query:');
     append(l_query);
     append('Produced Error:');
     --nm_debug.debug(sqlerrm);
     append(SQLERRM);
     -- set the error flag to ensure that
     -- we do not carry on around the loops fetching xml
     g_error_detected := TRUE;
  */
END hier_csv;
--
-----------------------------------------------------------------------------
-- Main Driving function for hier_xml
PROCEDURE create_xml(p_module IN hig_hd_modules.hhm_module%TYPE
                    ,p_job    IN gri_run_parameters.grp_job_id%TYPE DEFAULT NULL) IS

CURSOR get_top_level_tables (p_module IN hig_hd_modules.hhm_module%TYPE) IS
SELECT hhu_seq
FROM   hig_hd_mod_uses
WHERE  hhu_hhm_module = p_module
AND    hhu_parent_seq IS NULL
ORDER BY hhu_seq;

l_hhm hig_hd_modules%ROWTYPE;
BEGIN
  nm_debug.proc_start(g_package_name, 'create_xml');

  -- if gri_job_id specified create gri where clause
  clear_gri_table;
  
  IF p_job IS NOT NULL THEN
    process_gri_params(p_job);
  END IF;
  
  -- output header
  add_header;
  
  -- now add the rowset tag
  l_hhm := nm3get.get_hhm(pi_hhm_module      => p_module
                         ,pi_raise_not_found => TRUE);
  
  open_tag(NVL(l_hhm.hhm_tag, l_hhm.hhm_module));
  
  FOR top_table IN get_top_level_tables(p_module)
  LOOP
    hier_xml(p_module       => p_module
            ,p_muj_seq      => top_table.hhu_seq
            ,p_job          => p_job);
 
  END LOOP;
  
  -- all done now output the end rowset tag
  close_tag(NVL(l_hhm.hhm_tag, l_hhm.hhm_module));
  
  --nm_debug.proc_end(g_package_name, 'create_xml');
END create_xml;
--
-----------------------------------------------------------------------------
-- Main Driving function for hier_xml
PROCEDURE create_csv(p_module      IN hig_hd_modules.hhm_module%TYPE
                    ,p_job         IN gri_run_parameters.grp_job_id%TYPE DEFAULT NULL
                    ,p_inc_headers IN boolean) IS

CURSOR get_top_level_tables (p_module IN hig_hd_modules.hhm_module%TYPE) IS
SELECT hhu_seq
FROM   hig_hd_mod_uses
WHERE  hhu_hhm_module = p_module
AND    hhu_parent_seq IS NULL
ORDER BY hhu_seq;

-- Exceptions
e_no_such_module EXCEPTION;
PRAGMA EXCEPTION_INIT(e_no_such_module, -20120);
BEGIN
  nm_debug.proc_start(g_package_name, 'create_csv');

  -- if gri_job_id specified create gri where clause
  clear_gri_table;
  
  g_headers_not_included_yet := TRUE;
  
  IF p_job IS NOT NULL THEN
    process_gri_params(p_job);
  END IF;
  
  FOR top_table IN get_top_level_tables(p_module)
  LOOP
    hier_csv(p_module       => p_module
            ,p_muj_seq      => top_table.hhu_seq
            ,p_job          => p_job
            ,p_inc_headers  => p_inc_headers);
 
  END LOOP;
  
  nm_debug.proc_end(g_package_name, 'create_csv');
END create_csv;
--
-----------------------------------------------------------------------------
--
FUNCTION output_xml(p_module       IN hig_hd_modules.hhm_module%TYPE
                   ,p_job          IN gri_run_parameters.grp_job_id%TYPE DEFAULT NULL) RETURN clob IS
BEGIN
  nm_debug.proc_start(g_package_name, 'output_xml');
  -- main driving procedure
  
  -- setup defaults
  
  -- setup
  clear_error;
  -- clear lob
  g_xml.DELETE;
  
  set_defaults(p_module);
  
  create_xml(p_module => p_module
            ,p_job    => p_job);

  nm_debug.proc_end(g_package_name, 'output_xml');
  RETURN nm3clob.tab_varchar_to_clob(g_xml);
  
END output_xml;
--
-----------------------------------------------------------------------------
--
PROCEDURE output_xml(p_module       IN hig_hd_modules.hhm_module%TYPE
                    ,p_dir          IN varchar2
                    ,p_filename     IN varchar2
                    ,p_job          IN gri_run_parameters.grp_job_id%TYPE DEFAULT NULL) IS
BEGIN
  nm_debug.proc_start(g_package_name, 'output_xml');
  -- main driving procedure
  
  -- setup defaults
  
  -- setup
  clear_error;
  -- clear lob
  g_xml.DELETE;
  
  set_defaults(p_module);
  
  open_file(p_dir, p_filename);
  
  create_xml(p_module => p_module
            ,p_job    => p_job);

  close_file;

  nm_debug.proc_end(g_package_name, 'output_xml');
END output_xml;
--
-----------------------------------------------------------------------------
--  
PROCEDURE output_csv(p_module          IN hig_hd_modules.hhm_module%TYPE
                    ,p_dir             IN varchar2
                    ,p_filename        IN varchar2
                    ,p_job             IN gri_run_parameters.grp_job_id%TYPE
                    ,p_include_headers IN boolean) IS
BEGIN
  nm_debug.proc_start(g_package_name, 'output_csv');
  -- main driving procedure
  
  -- setup
  clear_error;
  -- clear lob
  g_xml.DELETE;
  
  open_file(p_dir, p_filename);
  
  create_csv(p_module      => p_module
            ,p_job         => p_job
            ,p_inc_headers => p_include_headers);

  close_file;

  nm_debug.proc_end(g_package_name, 'output_csv');
END output_csv;
--
-----------------------------------------------------------------------------
--
FUNCTION output_csv(p_module          IN hig_hd_modules.hhm_module%TYPE
                   ,p_job             IN gri_run_parameters.grp_job_id%TYPE
                   ,p_include_headers IN boolean) RETURN clob IS
BEGIN
  nm_debug.proc_start(g_package_name, 'output_csv');
  -- main driving procedure
  
  -- setup
  clear_error;
  -- clear lob
  g_xml.DELETE;
  
  create_csv(p_module      => p_module
            ,p_job         => p_job
            ,p_inc_headers => p_include_headers);
  
  nm_debug.proc_end(g_package_name, 'output_csv');
  RETURN nm3clob.tab_varchar_to_clob(g_xml);

END output_csv;
--
-----------------------------------------------------------------------------
--
END hig_hd_extract;
/
