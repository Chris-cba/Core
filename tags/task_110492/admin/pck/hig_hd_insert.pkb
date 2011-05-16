CREATE OR REPLACE PACKAGE BODY hig_hd_insert AS
--
-----------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_hd_insert.pkb	1.3 03/20/07
--       Module Name      : hig_hd_insert.pkb
--       Date into SCCS   : 07/03/20 09:29:52
--       Date fetched Out : 07/06/13 14:10:21
--       SCCS Version     : 1.3
--
--
--   Author : D. Cope
--
--   Package of dynamic sql routines used in xml file insertion
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
-- all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '@(#)hig_hd_insert.pkb	1.3 03/20/07';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'HIG_HD_INSERT';
--
-- Global defaults
--
  g_rows_inserted pls_integer DEFAULT 0;
--
TYPE t_column_insert IS RECORD
  (r_table_seq  hig_hd_mod_uses.hhu_seq%TYPE
  ,r_column     hig_hd_selected_cols.hhc_column_name%TYPE
  ,r_value      nm3type.max_varchar2
  ,r_format     hig_hd_selected_cols.hhc_format%TYPE);

TYPE tab_rec_col IS TABLE OF t_column_insert;

r_ins_col tab_rec_col := tab_rec_col();
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
FUNCTION lose_extra_comma(p_list IN varchar2) RETURN varchar2 IS

BEGIN
   RETURN rtrim(p_list, ', ');
END lose_extra_comma;
--
-----------------------------------------------------------------------------
--
FUNCTION read_xml_file (p_dir      IN varchar2
                       ,p_file     IN varchar2
                       ,p_err_file IN varchar2 DEFAULT NULL) RETURN xmldom.DOMDocument IS
p   xmlparser.parser;
BEGIN
   --nm_debug.proc_start(g_package_name,'read_xml_file');
-- new parser
   p := xmlparser.newParser;

-- set some characteristics
   xmlparser.setValidationMode(p, FALSE);
   xmlparser.showwarnings(p, TRUE);
   
   IF p_err_file IS NOT NULL THEN
     xmlparser.setErrorLog(p, p_dir || '/' || p_err_file);
   END IF;
   
   xmlparser.setBaseDir(p, p_dir);

-- parse input file
   xmlparser.parse(p, p_dir || '/' || p_file);

   --nm_debug.proc_end(g_package_name,'read_xml_file');
   
   -- get document
   RETURN xmlparser.getDocument(p);
-- deal with exceptions
EXCEPTION

WHEN xmldom.INDEX_SIZE_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Index Size error');

WHEN xmldom.DOMSTRING_SIZE_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'String Size error');

WHEN xmldom.HIERARCHY_REQUEST_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Hierarchy request error');

WHEN xmldom.WRONG_DOCUMENT_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Wrong document error');

WHEN xmldom.INVALID_CHARACTER_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Invalid Character error');

WHEN xmldom.NO_DATA_ALLOWED_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'No data allowed error');

WHEN xmldom.NO_MODIFICATION_ALLOWED_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'No modification allowed error');

WHEN xmldom.NOT_FOUND_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Not found error');

WHEN xmldom.NOT_SUPPORTED_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Not supported error');

WHEN xmldom.INUSE_ATTRIBUTE_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'In use attr error');
END read_xml_file;
--
-----------------------------------------------------------------------------
--
FUNCTION read_xml_clob (p_clob     IN clob) RETURN xmldom.DOMDocument IS
p   xmlparser.parser;
BEGIN
   --nm_debug.proc_start(g_package_name,'read_xml_clob');
-- new parser
   p := xmlparser.newParser;

-- set some characteristics
   xmlparser.setValidationMode(p, FALSE);
   xmlparser.showwarnings(p, TRUE);

-- parse clob
   xmlparser.parseclob(p, p_clob);

   --nm_debug.proc_end(g_package_name,'read_xml_clob');
   
   -- get document
   RETURN xmlparser.getDocument(p);
-- deal with exceptions
EXCEPTION

WHEN xmldom.INDEX_SIZE_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Index Size error');

WHEN xmldom.DOMSTRING_SIZE_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'String Size error');

WHEN xmldom.HIERARCHY_REQUEST_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Hierarchy request error');

WHEN xmldom.WRONG_DOCUMENT_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Wrong document error');

WHEN xmldom.INVALID_CHARACTER_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Invalid Character error');

WHEN xmldom.NO_DATA_ALLOWED_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'No data allowed error');

WHEN xmldom.NO_MODIFICATION_ALLOWED_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'No modification allowed error');

WHEN xmldom.NOT_FOUND_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Not found error');

WHEN xmldom.NOT_SUPPORTED_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'Not supported error');

WHEN xmldom.INUSE_ATTRIBUTE_ERR THEN
   RAISE_APPLICATION_ERROR(-20120, 'In use attr error');
END read_xml_clob;
--
-----------------------------------------------------------------------------
--
PROCEDURE release_document (p_doc    IN xmldom.DOMDocument) IS
BEGIN
  xmldom.freeDocument(p_doc);
END release_document;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_col_to_insert (p_module  IN hig_hd_modules.hhm_module%TYPE
                            ,p_table   IN hig_hd_mod_uses.hhu_seq%TYPE
                            ,p_col     IN hig_hd_selected_cols.hhc_column_name%TYPE
                            ,p_val     IN nm3type.max_varchar2
                            ,p_format  IN hig_hd_selected_cols.hhc_format%TYPE) IS
BEGIN
  --nm_debug.proc_start(g_package_name,'add_col_to_insert');


  r_ins_col.EXTEND;
  r_ins_col(r_ins_col.LAST).r_table_seq     := p_table;
  r_ins_col(r_ins_col.LAST).r_column        := p_col;
  r_ins_col(r_ins_col.LAST).r_value         := p_val;
  r_ins_col(r_ins_col.LAST).r_format        := p_format;
  
  --nm_debug.proc_end(g_package_name,'add_col_to_insert');
        
END add_col_to_insert;
--
-----------------------------------------------------------------------------
--
PROCEDURE commit_rows (p_num_rows_to_commit IN pls_integer) IS
BEGIN

  IF p_num_rows_to_commit IS NOT NULL AND
     MOD(g_rows_inserted, p_num_rows_to_commit) = 0 THEN

     --nm_debug.debug('committing '||p_num_rows_to_commit||' rows');
     COMMIT;

  END IF;
END commit_rows;
--
-----------------------------------------------------------------------------
--
FUNCTION find_parent_value(p_table  IN  hig_hd_mod_uses.hhu_seq%TYPE
                          ,p_col    IN  hig_hd_selected_cols.hhc_column_name%TYPE) RETURN pls_integer IS

l_retval pls_integer DEFAULT NULL;
BEGIN
  --nm_debug.proc_start(g_package_name,'find_parent_value');
  --nm_debug.debug('looking for '||p_table||' '||p_col);

  FOR i IN 1..r_ins_col.COUNT LOOP
    IF r_ins_col(i).r_table_seq  = p_table
       AND r_ins_col(i).r_column = p_col THEN
      
      l_retval := i;
    END IF; 
  END LOOP;
  
  --nm_debug.debug('find parent value returned '''||l_retval||'''');
  RETURN l_retval;
  --nm_debug.proc_start(g_package_name,'find_parent_value');
END find_parent_value;
--
-----------------------------------------------------------------------------
--
FUNCTION select_nodes (p_node IN xmldom.DOMNode
                      ,p_path IN varchar2) RETURN xmldom.DOMNodeList IS
BEGIN
  RETURN xslprocessor.selectNodes(p_node, p_path);
END select_nodes;
--
-----------------------------------------------------------------------------
--
FUNCTION get_top_node (p_doc    IN xmldom.DOMDocument
                      ,p_tag    IN varchar2) RETURN xmldom.DOMNode IS
BEGIN
  
  RETURN xslprocessor.selectSingleNode(xmldom.makeNode(p_doc), '/'||p_tag);
  
END get_top_node;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value(p_node IN xmldom.DOMNode
                  ,p_tag  IN varchar2) RETURN varchar2 IS

  retval                  nm3type.max_varchar2;
  l_db_Version  Constant  V$Instance.Version%Type:=Sys_Context('NM3CORE','DB_VERSION');
BEGIN
--
  g_xmldomnode := p_node;  
  
--
  IF l_db_Version LIKE '10.1.%'  THEN
    -- Oracle 10g release 1
    EXECUTE IMMEDIATE 'BEGIN xslprocessor.valueof ( '||g_package_name||'.g_xmldomnode, :pattern, :val); END'
    USING IN p_tag, OUT retval;
--
  ELSIF l_db_Version LIKE '9.%'  THEN
    -- Oracle 9i
    EXECUTE IMMEDIATE 'BEGIN xslprocessor.valueOf('||g_package_name||'.g_xmldomnode, :p_tag); END'
    INTO retval
    USING p_tag;
  --    
  END IF;
--
  RETURN retval;
END get_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_value(p_doc  IN xmldom.DOMDocument
                  ,p_path IN varchar2) RETURN varchar2 IS
  
  retval                  nm3type.max_varchar2;
  l_db_Version  Constant  V$Instance.Version%Type:=Sys_Context('NM3CORE','DB_VERSION');
BEGIN
  --
  
  g_xmldomdoc := p_doc;
  --
  IF l_db_Version LIKE '10.1.%'  THEN
    -- Oracle 10g release 1
    EXECUTE IMMEDIATE 'BEGIN xslprocessor.valueof( xmldom.makeNode('||g_package_name||'.g_xmldomdoc), :pattern, :val); END'
    USING IN p_path, OUT retval;
--
  ELSIF l_db_Version LIKE '9.%'  THEN
    -- Oracle 9i
    EXECUTE IMMEDIATE 'BEGIN xslprocessor.valueOf( xmldom.makeNode('||g_package_name||'.g_xmldomdoc), :p_tag); END'
    INTO retval
    USING p_path;
  --    
  END IF;
--
  RETURN retval;
--
END get_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_func_value(p_function IN hig_hd_selected_cols.hhc_function%TYPE) RETURN varchar2 IS
l_val nm3type.max_varchar2;
BEGIN

  EXECUTE IMMEDIATE nm3type.c_select|| nm3type.c_space ||p_function|| nm3type.c_newline 
                 || nm3type.c_from ||' dual' INTO l_val; 
  
  RETURN l_val;
EXCEPTION 
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20123, 'Error: Could not insert value from '||p_function);
END get_func_value;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_table_values (p_module IN hig_hd_modules.hhm_module%TYPE
                           ,p_table  IN hig_hd_mod_uses.hhu_seq%TYPE
                           ,p_node   IN xmldom.DOMNode) IS

CURSOR get_cols (p_module IN hig_hd_modules.hhm_module%TYPE
                ,p_table  IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT hhc_column_name
      ,nvl(hhc_alias, hhc_column_name) as tag
      ,hhc_format
      ,hhc_function
FROM   hig_hd_selected_cols
WHERE  hhc_hhu_hhm_module  = p_module
AND    hhc_hhu_seq         = p_table;

BEGIN
  --nm_debug.proc_start(g_package_name,'get_table_values');

  FOR i_c IN get_cols (p_module, p_table) LOOP
    IF i_c.hhc_function IS NOT NULL THEN
      add_col_to_insert(p_module => p_module
                       ,p_table  => p_table
                       ,p_col    => i_c.hhc_column_name
                       ,p_val    => get_func_value(i_c.hhc_function)
                       ,p_format => i_c.hhc_format);
    ELSE
      --nm_debug.debug('column '||i_c.hhc_column_name||' has value '||get_value(p_node, i_c.tag));
      add_col_to_insert(p_module => p_module
                       ,p_table  => p_table
                       ,p_col    => i_c.hhc_column_name
                       ,p_val    => get_value(p_node, i_c.tag)
                       ,p_format => i_c.hhc_format);
    END IF;
  END LOOP;

  --nm_debug.proc_end(g_package_name,'get_table_values');
END get_table_values;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_vals(p_module          IN hig_hd_modules.hhm_module%TYPE
                     ,p_muj_seq         IN hig_hd_mod_uses.hhu_seq%TYPE
                     ,p_owner           IN all_users.username%TYPE DEFAULT Sys_Context('NM3CORE','APPLICATION_OWNER')
                     ,p_commit_per_rows IN pls_integer) IS

CURSOR get_table (p_module   IN hig_hd_modules.hhm_module%TYPE
                 ,p_muj_seq  IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT hhu_table_name
FROM   hig_hd_mod_uses
WHERE  hhu_hhm_module = p_module
AND    hhu_seq        = p_muj_seq;

l_table    hig_hd_mod_uses.hhu_table_name%TYPE;
l_cols     nm3type.max_varchar2;
l_vals     nm3type.max_varchar2;
l_datatype user_tab_columns.data_type%TYPE;

BEGIN
  --nm_debug.proc_start(g_package_name, 'insert_vals');
  --nm_debug.debug(r_ins_col.count||' values on the stack');
  
  OPEN get_table(p_module
                ,p_muj_seq);
  FETCH get_table INTO l_table;
  CLOSE get_table;
  
  FOR i IN 1..r_ins_col.COUNT LOOP
  
    IF r_ins_col(i).r_table_seq = p_muj_seq THEN
      l_cols := l_cols || r_ins_col(i).r_column ||nm3type.c_comma_sep;
      
      l_datatype := nm3flx.get_column_datatype (l_table, r_ins_col(i).r_column);
      
      IF l_datatype IN ('VARCHAR2', 'CHAR') THEN
        IF r_ins_col(i).r_format IS NOT NULL THEN
          l_vals := l_vals ||' TO_CHAR('''|| r_ins_col(i).r_value ||''','''||r_ins_col(i).r_format||'''),';
        
        ELSE
          l_vals := l_vals ||' '''|| r_ins_col(i).r_value ||''',';
        END IF;
      
      ELSIF l_datatype = ('DATE') THEN

        l_vals := l_vals || ' TO_DATE('''||r_ins_col(i).r_value||''', '''||r_ins_col(i).r_format||'''),';

      ELSIF l_datatype = ('NUMBER') THEN
        IF r_ins_col(i).r_value IS NULL THEN
          l_vals := l_vals || ' NULL,';
        ELSE
            IF r_ins_col(i).r_format IS NOT NULL THEN
            l_vals := l_vals ||' TO_CHAR('''|| r_ins_col(i).r_value ||''','''||r_ins_col(i).r_format||'''),';
          ELSE
          l_vals := l_vals ||nm3type.c_space || r_ins_col(i).r_value ||nm3type.c_comma_sep;
          END IF;
        END IF;
        
      ELSE
        IF r_ins_col(i).r_value IS NULL THEN
          l_vals := l_vals || ' NULL,';
        ELSE
        
          l_vals := l_vals || nm3type.c_space || r_ins_col(i).r_value ||nm3type.c_comma_sep;
        END IF;

      END IF;
    END IF;
  END LOOP;

  l_cols := lose_extra_comma(l_cols);
  l_vals := lose_extra_comma(l_vals);
  
  --nm_debug.debug(nm3type.c_insert_into || nm3type.c_space ||p_owner||nm3type.c_dot||l_table ||' ('||l_cols||') '||nm3type.c_values||' ('||l_vals||')',2);
  
  EXECUTE IMMEDIATE nm3type.c_insert_into || nm3type.c_space ||p_owner||nm3type.c_dot||l_table ||
                    ' ('||l_cols||') '||
                    nm3type.c_values||' ('||l_vals||')';
  
  g_rows_inserted := g_rows_inserted + 1;
  
  commit_rows(p_commit_per_rows);
  
  --nm_debug.proc_end(g_package_name,'insert_vals');
EXCEPTION
  WHEN OTHERS THEN
    --nm_debug.debug('*****************************');
    --nm_debug.debug('The following error has occurred');
    --nm_debug.debug(sqlerrm);
    --nm_debug.debug('When executing:');
    --nm_debug.debug(nm3type.c_insert_into || nm3type.c_space ||p_owner||nm3type.c_dot||l_table ||' ('||l_cols||') '||nm3type.c_values||' ('||l_vals||')');
    RAISE;
END insert_vals;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_column_vals IS
BEGIN
  r_ins_col       := tab_rec_col();
  g_rows_inserted := 0;
END clear_column_vals; 
--
-----------------------------------------------------------------------------
--
PROCEDURE trim_last_vals IS
l_table   hig_hd_mod_uses.hhu_seq%TYPE;
BEGIN
  --nm_debug.proc_start(g_package_name,'trim_last_vals');
    
  -- if there is an element to trim
  IF r_ins_col.EXISTS(1) THEN
    
    l_table := r_ins_col(r_ins_col.LAST).r_table_seq;
    --nm_debug.debug('Trimming from stack '||l_table);
      
    WHILE r_ins_col.count > 0 AND r_ins_col(r_ins_col.LAST).r_table_seq = l_table LOOP
      r_ins_col.TRIM;
    END LOOP;
  END IF;

  --nm_debug.proc_end(g_package_name,'trim_last_vals');
END trim_last_vals;
--
-----------------------------------------------------------------------------
--
FUNCTION inserting_table_data(p_module  IN hig_hd_modules.hhm_module%TYPE
                             ,p_muj_seq IN hig_hd_mod_uses.hhu_seq%TYPE) RETURN boolean IS

l_mu    hig_hd_mod_uses%ROWTYPE := nm3get.get_hhu(p_module, p_muj_seq);
BEGIN

  IF l_mu.hhu_load_data = 'Y' THEN
    --nm_debug.debug('To insert into table '||p_muj_seq);
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END inserting_table_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_foreign_key_columns (p_module       IN hig_hd_modules.hhm_module%TYPE
                                  ,p_child_muj    IN hig_hd_mod_uses.hhu_seq%TYPE
                                  ,p_parent_muj   IN hig_hd_mod_uses.hhu_seq%TYPE) IS

CURSOR get_join_cols (p_module       IN hig_hd_modules.hhm_module%TYPE
                     ,p_child_muj    IN hig_hd_mod_uses.hhu_seq%TYPE
                     ,p_parent_muj   IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT jc.hhj_hht_hhu_parent_table
      ,jc.hhj_parent_col
      ,jc.hhj_hhu_child_table
      ,jc.hhj_child_col
FROM   hig_hd_table_join_cols        jc
WHERE  jc.hhj_hht_hhu_hhm_module   = p_module
AND    jc.hhj_hht_hhu_parent_table = p_parent_muj
AND    jc.hhj_hhu_child_table      = p_child_muj;

l_pos  pls_integer;

BEGIN
  --nm_debug.proc_start(g_package_name,'get_foreign_key_columns');
  FOR join_det IN get_join_cols(p_module
                               ,p_child_muj
                               ,p_parent_muj) LOOP

    --nm_debug.debug('adding column '||join_det.hhj_child_col);
    
    l_pos := find_parent_value(p_parent_muj
                              ,join_det.hhj_parent_col);
                              
    add_col_to_insert(p_module => p_module
                     ,p_table  => p_child_muj
                     ,p_col    => join_det.hhj_child_col
                     ,p_val    => r_ins_col(l_pos).r_value
                     ,p_format => r_ins_col(l_pos).r_format); 
                           
  END LOOP;
  --nm_debug.proc_end(g_package_name,'get_foreign_key_columns');

END get_foreign_key_columns;
--
-----------------------------------------------------------------------------
--
PROCEDURE insert_table_details (p_module          IN hig_hd_modules.hhm_module%TYPE
                               ,p_muj_seq         IN hig_hd_mod_uses.hhu_seq%TYPE
                               ,p_base_node       IN xmldom.DOMNode
                               ,p_parent_seq      IN hig_hd_mod_uses.hhu_seq%TYPE DEFAULT NULL
                               ,p_owner           IN all_users.username%TYPE DEFAULT Sys_Context('NM3CORE','APPLICATION_OWNER')
                               ,p_commit_per_rows IN pls_integer DEFAULT NULL) IS

CURSOR get_child_tables (p_module   IN hig_hd_modules.hhm_module%TYPE
                        ,p_muj_seq  IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT hhu_seq
FROM   hig_hd_mod_uses
WHERE  hhu_hhm_module = p_module 
AND    hhu_parent_seq = p_muj_seq
ORDER BY hhu_seq;

CURSOR get_child_alias (p_module   IN hig_hd_modules.hhm_module%TYPE
                       ,p_muj_seq  IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT *
FROM   hig_hd_selected_cols
WHERE  hhc_hhu_hhm_module = p_module
AND    hhc_hhu_seq        = p_muj_seq;

CURSOR get_num_cols (p_module   IN hig_hd_modules.hhm_module%TYPE
                    ,p_muj_seq  IN hig_hd_mod_uses.hhu_seq%TYPE) IS
SELECT count(*) num
FROM   hig_hd_selected_cols
WHERE  hhc_hhu_hhm_module = p_module
AND    hhc_hhu_seq        = p_muj_seq;
 
l_node      xmldom.DOMNode;
nl          xmldom.DOMNodeList;
l_mu        hig_hd_mod_uses%ROWTYPE := nm3get.get_hhu(p_module, p_muj_seq);
l_column    hig_hd_selected_cols%ROWTYPE;
l_num_cols  pls_integer;
-- flag to determine if we are inserting a list of values or a list of different values
l_ins_table boolean DEFAULT TRUE;

e_more_than_one_col EXCEPTION;
PRAGMA EXCEPTION_INIT(e_more_than_one_col, -20122);
BEGIN
  --nm_debug.proc_start(g_package_name, 'insert_table');
    
    IF l_mu.hhu_alias IS NULL THEN
    -- no table alias it is either an error or there is a list of columns in the xml file
      --nm_debug.debug('Alias is null so getting child alias');
      OPEN get_num_cols(p_module
                       ,p_muj_seq);
      FETCH get_num_cols INTO l_num_cols;
      CLOSE get_num_cols;
        
      IF l_num_cols != 1 THEN
         --nm_debug.debug('Cannot insert lists of more than one column. Either use a table alias or a single column in the metadata');
         RAISE_APPLICATION_ERROR(-20122, 'XML does not allow lists of more than one column. Either insert one column or use a table alias');
      END IF;
      
      OPEN get_child_alias(p_module
                          ,p_muj_seq);
      FETCH get_child_alias INTO l_column;
      CLOSE get_child_alias;
      l_mu.hhu_alias := l_column.hhc_alias;
      l_ins_table := FALSE;
    ELSE --parent has an alias so expect a list of differing values
      l_ins_table := TRUE;
    END IF;
    
    nl := select_nodes(p_base_node, l_mu.hhu_alias);
  
    --nm_debug.debug('Number of nodes '||xmldom.getlength(nl));
    
    FOR i IN 0..xmldom.getlength(nl) -1 LOOP
    
      l_node := xmldom.item(nl, i);

        IF l_ins_table THEN
        -- if we are inserting a list of columns from a table then
          get_table_values(p_module => p_module
                          ,p_table  => p_muj_seq
                          ,p_node   => l_node);
      ELSE
        -- we have a list of single columns so fasttrack and add the column values here
        
        add_col_to_insert(p_module => p_module
                         ,p_table  => p_muj_seq
                         ,p_col    => l_column.hhc_column_name
                         ,p_val    => xmldom.getNodeValue(xmldom.getFirstChild(l_node))
                         ,p_format => l_column.hhc_format);
      END IF;
    
      -- depending on the load data flag we may just want to
      -- parse the table data and keep it for foreign key information
      -- instead of load it into tables
      IF inserting_table_data(p_module, p_muj_seq) THEN

        -- get any foreign key values from up the food chain
          IF p_parent_seq IS NOT NULL THEN
            get_foreign_key_columns(p_module     => p_module
                                   ,p_child_muj  => p_muj_seq
                                   ,p_parent_muj => p_parent_seq);
        END IF;
    
    
        insert_vals(p_module          => p_module
                   ,p_muj_seq         => p_muj_seq 
                   ,p_owner           => p_owner
                   ,p_commit_per_rows => p_commit_per_rows);
      END IF;
      
      FOR insert_kids IN get_child_tables(p_module, p_muj_seq) LOOP
      
          -- call recursively passing the node id. parameters child table and node
          -- now perform this for any children of this
        --nm_debug.debug('Recursively called with '||insert_kids.hhu_seq);
          insert_table_details(p_module          => p_module
                              ,p_muj_seq         => insert_kids.hhu_seq
                              ,p_base_node       => l_node
                              ,p_parent_seq      => p_muj_seq
                              ,p_owner           => p_owner
                              ,p_commit_per_rows => p_commit_per_rows);
      END LOOP;
      
      -- now that we have inserted all data for this table and
      -- any children of this we can discard the sotred table information
      trim_last_vals;
      
    END LOOP;
    
  --nm_debug.proc_end(g_package_name,'insert_table');
EXCEPTION
  WHEN OTHERS THEN
    RAISE;
END insert_table_details;
--
-----------------------------------------------------------------------------
--
FUNCTION insert_all_details (p_module          IN hig_hd_modules.hhm_module%TYPE
                            ,p_doc             IN xmldom.DOMDocument
                            ,p_owner           IN all_users.username%TYPE DEFAULT Sys_Context('NM3CORE','APPLICATION_OWNER')
                            ,p_commit_per_rows IN pls_integer DEFAULT 0) RETURN pls_integer IS

CURSOR get_doc_tag (p_module IN hig_hd_modules.hhm_module%TYPE) IS
SELECT nvl(hhm_tag, hhm_module) top_tag
FROM   hig_hd_modules
WHERE  hhm_module = p_module;

CURSOR get_top_level_tables (p_module IN hig_hd_modules.hhm_module%TYPE) IS
SELECT hhu_seq, hhu_table_name
FROM   hig_hd_mod_uses
WHERE  hhu_hhm_module = p_module
AND    hhu_parent_seq IS NULL
ORDER BY hhu_seq;

l_node xmldom.DOMNode;
l_tag  hig_hd_modules.hhm_tag%TYPE;
e_cant_find_top_node EXCEPTION;
PRAGMA EXCEPTION_INIT(e_cant_find_top_node, -25012);

BEGIN 
  --nm_debug.proc_start(g_package_name, 'insert_all_details');  
-- 
  clear_column_vals;
  OPEN get_doc_tag(p_module);
  FETCH get_doc_tag INTO l_tag;
  IF get_doc_tag%NOTFOUND THEN
     CLOSE get_doc_tag;
     RAISE no_data_found;
  ELSE
     CLOSE get_doc_tag;
  END IF;

  l_node := get_top_node(p_doc, l_tag);

  IF xmldom.isNull(l_node) THEN
    --nm_debug.debug('Cannot find top node of document');
    RAISE e_cant_find_top_node;
  ELSE

    --nm_debug.debug('Top node is called '||xmldom.getNodeName(l_node));
    FOR top_table IN get_top_level_tables(p_module) LOOP

        --nm_debug.debug('Calling insert_table_details with table: '||top_table.hhu_table_name);

      insert_table_details(p_module          => p_module
                          ,p_muj_seq         => top_table.hhu_seq
                          ,p_base_node       => l_node
                          ,p_owner           => p_owner
                          ,p_commit_per_rows => p_commit_per_rows);
    END LOOP;
  END IF;
  
  -- if we have got to here then all has gone well so commit remaining rows
  COMMIT;
  
  RETURN g_rows_inserted;
  --nm_debug.proc_end(g_package_name,'insert_all_details');
EXCEPTION
  WHEN e_cant_find_top_node THEN
    RAISE_APPLICATION_ERROR(-25012, 'Processing stopped. Cannot find the root node of the file.');
  WHEN no_data_found THEN
    --nm_debug.debug('Cannot find the document tag for module:'||p_module);
    RAISE;  
END insert_all_details;
--
-----------------------------------------------------------------------------
--
END Hig_Hd_Insert;
/
