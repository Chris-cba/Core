CREATE OR REPLACE PACKAGE BODY nm3_xmldtd AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3_xmldtd.pkb-arc   2.2   Jul 04 2013 15:10:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3_xmldtd.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:10:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:22  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.10
---------------------------------------------------------------------------
--   Author : I Turnbull
--
--   nm3_xmldtd package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global PACKAGE variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'NM3_XMLDTD';
--
  g_dtd CLOB;   
--
--

--
-----------------------------------------------------------------------------
--
--  Forward declarations
--
-- PROCEDURE parsedtdclob ( p_dtd IN clob
--                         ,p_root varchar2 DEFAULT NULL
--                        );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE append ( pi_txt VARCHAR2,p_chr VARCHAR2 DEFAULT 'N' )
IS
BEGIN
--
   nm3clob.append(p_clob => g_dtd
                , p_append => pi_txt);
--
   IF p_chr = 'Y' THEN 
      append ( CHR(10)  );
   END IF;
--
END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_element( p_table VARCHAR2
                        , p_child1 VARCHAR2 DEFAULT NULL
                        , p_child_occurs1 VARCHAR2 DEFAULT NULL
                        , p_child2 VARCHAR2 DEFAULT NULL
                        , p_child_occurs2 VARCHAR2 DEFAULT NULL
                        , p_child3 VARCHAR2 DEFAULT NULL
                        , p_child_occurs3 VARCHAR2 DEFAULT NULL
                        , p_child4 VARCHAR2 DEFAULT NULL
                        , p_child_occurs4 VARCHAR2 DEFAULT NULL
                        , p_child5 VARCHAR2 DEFAULT NULL
                        , p_child_occurs5 VARCHAR2 DEFAULT NULL
                        )
IS
   l_txt VARCHAR2(1000) := NULL;
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_element');
--
   -- create the inv_type element
   l_txt := c_element || p_table || c_space || c_open;
   IF p_child1 IS NULL THEN
      l_txt := l_txt || c_pcdata ;
   ELSE
      l_txt := l_txt || p_child1 || p_child_occurs1;
   END IF;
   IF p_child2 IS NOT NULL THEN
      l_txt := l_txt || c_comma || p_child2 || p_child_occurs2;
   END IF;
   IF p_child3 IS NOT NULL THEN
      l_txt := l_txt || c_comma || p_child3 || p_child_occurs3;
   END IF;
   IF p_child4 IS NOT NULL THEN
      l_txt := l_txt || c_comma || p_child4 || p_child_occurs4;
   END IF;
   IF p_child5 IS NOT NULL THEN
      l_txt := l_txt || c_comma || p_child5 || p_child_occurs5;
   END IF;
   l_txt := l_txt  || c_close || c_end;
   append ( l_txt );
--
   nm_debug.proc_end(g_package_name,'create_element');
--
END create_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_attlist ( p_table VARCHAR2 )
IS
  CURSOR c_tab_cols ( c_tab VARCHAR2)
  IS
  SELECT column_name
        ,data_type
        ,nullable
        ,data_default
  FROM USER_TAB_COLUMNS
  WHERE table_name = UPPER(c_tab);
--
  l_txt VARCHAR2(1000) := NULL;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_attlist');
--
   -- create the inv type columns
   FOR c_tab_cols_rec IN c_tab_cols( p_table ) LOOP
      l_txt := c_attlist || p_table || c_space || c_tab_cols_rec.column_name || c_cdata ;
      IF c_tab_cols_rec.nullable = 'N' THEN
         IF c_tab_cols_rec.data_default IS NULL THEN
            l_txt := l_txt || c_required;
         ELSE
            IF c_tab_cols_rec.data_type = 'DATE' THEN
               l_txt := l_txt || c_required;
            ELSIF c_tab_cols_rec.data_type = 'NUMBER' THEN
               l_txt := l_txt || c_quote||c_tab_cols_rec.data_default||c_quote;
            ELSE
               l_txt := l_txt || c_tab_cols_rec.data_default;
            END IF;
         END IF;
      ELSE
         l_txt := l_txt || c_implied;
      END IF;
      l_txt := l_txt || c_end;
      append( l_txt );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'create_attlist');
--
END create_attlist;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nm_inv_type_dtd ( file_location IN VARCHAR2
                                 , file_name IN VARCHAR2 )
IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_nm_inv_type_dtd');
--
  -- append( c_version);
   append( c_generated_by );
   append( c_element || 'DATA (NM_INV_TYPES_ALL*)' || c_end );
   create_element ( p_table => 'NM_INV_TYPES_ALL'
                  , p_child1 => 'NM_INV_TYPE_ATTRIBS_ALL'
                  , p_child_occurs1 => c_plus
                  , p_child2 => 'NM_INV_NW_ALL'
                  , p_child_occurs2 => c_star
                  );
   create_attlist ( p_table => 'NM_INV_TYPES_ALL' );
--
   create_element (  p_table => 'NM_INV_TYPE_ATTRIBS_ALL'
                  ,  p_child1 => 'NM_INV_TYPE_ATTRIB_BANDINGS'
                  ,  p_child_occurs1 => c_star);
   create_attlist (  p_table => 'NM_INV_TYPE_ATTRIBS_ALL' );
--
   create_element (  p_table => 'NM_INV_TYPE_ATTRIB_BANDINGS'
                  ,  p_child1 => 'NM_INV_TYPE_ATTRIB_BAND_DETS'
                  ,  p_child_occurs1 => c_star);
   create_attlist (  p_table => 'NM_INV_TYPE_ATTRIB_BANDINGS' );
--
   create_element (  p_table => 'NM_INV_TYPE_ATTRIB_BAND_DETS');
   create_attlist (  p_table => 'NM_INV_TYPE_ATTRIB_BAND_DETS' );
--
   create_element (  p_table => 'NM_INV_NW_ALL');
   create_attlist (  p_table => 'NM_INV_NW_ALL' );
--
   -- check its well formed
   parsedtdclob ( g_dtd );
--
   nm3clob.writeclobout(  result => g_dtd
                        , file_location => file_location
                        , file_name => file_name
                       );
--
   nm_debug.proc_end(g_package_name,'create_nm_inv_type_dtd');
--
END create_nm_inv_type_dtd;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_dtd_file ( file_location IN VARCHAR2
                       , file_name IN VARCHAR2 )
IS
  l_dtd CLOB;
--
BEGIN
--
  nm3clob.readclobin(  file_location => 'e:\nm3'
                     , file_name => 'inv_type.dtd'
                     , result => l_dtd);
--
  parsedtdclob ( l_dtd );
--
END validate_dtd_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE parsedtdclob ( p_dtd IN CLOB
                        ,p_root VARCHAR2 DEFAULT NULL
                       )
IS
  l_p xmlparser.parser := xmlparser.newparser;
--
BEGIN
--
  xmlparser.setvalidationmode(l_p, TRUE );
  xmlparser.parsedtdclob(  p => l_p
                         , dtd => p_dtd
                         , root => p_root
                        );
--
  xmlparser.freeparser(l_p);
--
END parsedtdclob;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_simple_dtd ( p_table IN VARCHAR2
                             ,file_location IN VARCHAR2
                             ,file_name IN VARCHAR2 )
IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_simple_dtd');
--
   append( c_version);
   append( c_generated_by );
   create_element ( p_table => p_table
                  );
   create_attlist ( p_table => p_table );

   nm3clob.writeclobout(  result => g_dtd
                        , file_location => file_location
                        , file_name => file_name
                       );
--
   nm_debug.proc_end(g_package_name,'create_simple_dtd');
--
END create_simple_dtd;
--
-----------------------------------------------------------------------------
--
PROCEDURE save_to_table( p_xmldoc CLOB
                        ,p_type VARCHAR2
                        ,p_name VARCHAR2
                       )
IS
  CURSOR c_exists( c_type VARCHAR2, c_name VARCHAR2 )
  IS
  SELECT 1
  FROM NM_XML_FILES
  WHERE EXISTS (SELECT 1 FROM NM_XML_FILES WHERE nxf_type = c_type AND nxf_file_type = c_name);
  l_exists NUMBER;   
BEGIN
  nm_debug.proc_start(g_package_name , 'save_to_table');
--
  IF UPPER(p_type) IN ('XML','DTD','XSD','XSL') THEN
     OPEN c_exists( p_type, p_name );
     FETCH c_exists INTO l_exists;
     nm_debug.debug('l_exists ' ||l_exists );
     IF c_exists%NOTFOUND THEN 
        INSERT INTO NM_XML_FILES(nxf_doc, nxf_type,nxf_file_type,nxf_descr)
         VALUES ( p_xmldoc, UPPER(p_type),p_name,p_name );
     ELSE
         UPDATE NM_XML_FILES
         SET nxf_doc = p_xmldoc
         WHERE nxf_type = p_type
         AND nxf_file_type = p_name;
     END IF;
  ELSE
     RAISE_APPLICATION_ERROR(-20001,'Invalid Type');
  END IF;
--
  nm_debug.proc_end(g_package_name , 'save_to_table');
END save_to_table;
--
PROCEDURE load_and_save ( file_location IN VARCHAR2
                         ,file_name     IN VARCHAR2
                         ,p_name        IN VARCHAR2
                         )
IS
  l_clob CLOB;
BEGIN
  nm_debug.proc_start(g_package_name , 'load_and_save');
    nm3clob.readclobin ( result  => l_clob
                ,file_location => file_location
                ,file_name     => file_name
               );
    save_to_table( l_clob
                  ,nm3flx.get_file_extenstion(file_name)
                  ,p_name
                 );

  nm_debug.proc_end(g_package_name , 'load_and_save');
END load_and_save;
--
FUNCTION check_xml_with_dtd( p_xml CLOB, p_dtd CLOB, p_root_element VARCHAR2 )
RETURN xmldom.domdocument
IS
   l_pdtd xmlparser.parser := xmlparser.newparser;
   l_pxml xmlparser.parser := xmlparser.newparser;
   l_dtd  xmldom.domdocumenttype;
BEGIN
   nm_debug.proc_start(g_package_name , 'check_xml_with_dtd');
--
   xmlparser.parsedtdclob(l_pdtd , p_dtd, p_root_element);
   l_dtd := xmlparser.getdoctype(l_pdtd);
--
   xmlparser.setvalidationmode(l_pxml, TRUE);
   xmlparser.setdoctype(l_pxml, l_dtd);
   xmlparser.parseclob(l_pxml , p_xml);
--
   RETURN xmlparser.getdocument(l_pxml);
--
   xmlparser.freeparser(l_pxml);
   xmlparser.freeparser(l_pdtd);
--
   nm_debug.proc_end(g_package_name , 'check_xml_with_dtd');
--
END check_xml_with_dtd;
--
FUNCTION parseclob( p_xml CLOB)
RETURN xmldom.domdocument
IS
   l_pxml xmlparser.parser := xmlparser.newparser;
   l_doc xmldom.domdocument; 
BEGIN
   nm_debug.proc_start(g_package_name , 'parseclob');
--
   xmlparser.setvalidationmode(l_pxml, FALSE);
   xmlparser.parseclob(l_pxml , p_xml);
--
   l_doc := xmlparser.getdocument(l_pxml);
   xmlparser.freeparser(l_pxml);
   RETURN l_doc;
--
   nm_debug.proc_end(g_package_name , 'parseclob');
--
END parseclob;
--
PROCEDURE  add_to_list(  p_list IN OUT nm3type.tab_varchar30
                       , p_item IN VARCHAR2)
IS
   l_found BOOLEAN ;
BEGIN 
   nm_debug.proc_start(g_package_name , 'add_to_list');
   l_found := FALSE;
   FOR i IN 1..p_list.COUNT LOOP
      IF p_list(i) = p_item THEN 
         l_found := TRUE;   
      END IF;
   END LOOP;
   
   IF l_found = FALSE THEN 
      p_list(p_list.COUNT + 1) := p_item;
   END IF;
   
   nm_debug.proc_end(g_package_name , 'add_to_list');
END add_to_list;
--
FUNCTION is_col_mandatory( p_inv_type VARCHAR2
                          ,p_col_name VARCHAR2)
RETURN VARCHAR2
IS
   CURSOR c_col_mandatory ( c_inv_type VARCHAR2
                           ,c_colname VARCHAR2)
   IS 
   SELECT ita_mandatory_yn
   FROM NM_INV_TYPE_ATTRIBS
   WHERE ita_inv_type = c_inv_type
     AND ita_view_col_name = c_colname;
    
   l_retval VARCHAR2(1); 
   
BEGIN
   nm_debug.proc_start(g_package_name , 'is_col_mandatory');

   OPEN c_col_mandatory( p_inv_type, p_col_name);
   
   FETCH c_col_mandatory INTO l_retval;
   
   IF c_col_mandatory%NOTFOUND THEN 
      l_retval := 'Y';
      CLOSE c_col_mandatory;  
   ELSE
      CLOSE c_col_mandatory;
   END IF;
   
   -- SOME STATIC COLUMNS CAN BE NULL 
   IF   p_col_name = 'IIT_NE_ID'
     OR p_col_name = 'IIT_START_DATE'
     OR p_col_name = 'IIT_END_DATE'
     OR p_col_name = 'IIT_DATE_CREATED'
     OR p_col_name = 'IIT_DATE_MODIFIED' 
     OR p_col_name = 'IIT_CREATED_BY'
     OR p_col_name = 'IIT_MODIFIED_BY'
     OR p_col_name = 'IIT_ADMIN_UNIT'      
     OR p_col_name = 'NE_ID_OF'
     OR p_col_name = 'NM_BEGIN_MP'
     OR p_col_name = 'NM_END_MP'
     OR p_col_name = 'NM_SEQ_NO'
     OR p_col_name = 'NM_START_DATE'
     OR p_col_name = 'NM_END_DATE'
     OR p_col_name = 'NM_ADMIN_UNIT'
     OR p_col_name = 'DATUM_NE_UNIQUE'
     OR p_col_name = 'ROUTE_NE_UNIQUE'
     OR p_col_name = 'ROUTE_NE_ID'
     OR p_col_name = 'ROUTE_SLK_START'
     OR p_col_name = 'ROUTE_SLK_END'
     OR p_col_name = 'IIT_PRIMARY_KEY'
   THEN 
       l_retval := 'N';
   END IF;
   
   nm_debug.proc_end(g_package_name , 'is_col_mandatory');
      
   RETURN l_retval;
   
END is_col_mandatory;

FUNCTION col_required( p_col_name IN VARCHAR2 )
RETURN BOOLEAN
IS
  l_rtrn BOOLEAN := TRUE;
BEGIN

  nm_debug.proc_start(g_package_name , 'col_required');

  IF    p_col_name = 'IIT_DATE_CREATED'
     OR p_col_name = 'IIT_DATE_MODIFIED' 
     OR p_col_name = 'IIT_CREATED_BY'
     OR p_col_name = 'IIT_MODIFIED_BY'         
  THEN
     l_rtrn := FALSE; 
  END IF;
  
  nm_debug.proc_end(g_package_name , 'col_required');
  
  RETURN l_rtrn;

END col_required;


--
PROCEDURE create_inv_items_dtd
IS
  CURSOR c_inv_types 
  IS
  SELECT nit_inv_type 
  FROM NM_INV_TYPES;
  
  l_inv_type nm3type.tab_varchar30; 
  
BEGIN 
  nm_debug.proc_start(g_package_name , 'create_inv_items_dtd');
  
  OPEN c_inv_types;
  FETCH c_inv_types BULK COLLECT INTO l_inv_type;
  CLOSE c_inv_types;
  
  create_inv_items_dtd( l_inv_type );
  
  nm_debug.proc_end(g_package_name , 'create_inv_items_dtd');
END create_inv_items_dtd;
--
PROCEDURE create_inv_items_dtd( p_inv_type nm3type.tab_varchar30 )
IS
   l_dtd CLOB;
BEGIN 
   nm_debug.proc_start( g_package_name , 'create_inv_items_dtd');
   create_inv_items_dtd ( p_inv_type => p_inv_type,
                          p_dtd => l_dtd
                        );
   --
   save_to_table( p_xmldoc => l_dtd
                 ,p_type => 'DTD'
                 ,p_name => 'INV_ITEMS'
                );
   --                           
   nm_debug.proc_end(g_package_name , 'create_inv_items_dtd');
END create_inv_items_dtd;
--
PROCEDURE create_inv_items_dtd( p_inv_type nm3type.tab_varchar30
                               ,p_filename VARCHAR2
                               ,p_filedir  VARCHAR2
                              )
IS
   l_dtd CLOB;
BEGIN 
   nm_debug.proc_start(g_package_name , 'create_inv_items_dtd');
   create_inv_items_dtd ( p_inv_type => p_inv_type,
                          p_dtd => l_dtd
                        );
   nm3clob.writeclobout(  result => l_dtd
                        , file_location => p_filedir
                        , file_name => p_filename
                       );
                           
   nm_debug.proc_end(g_package_name , 'create_inv_items_dtd');
END create_inv_items_dtd;
--
PROCEDURE create_inv_items_dtd( p_inv_type IN nm3type.tab_varchar30
                               ,p_dtd IN OUT CLOB
                              )
IS
   CURSOR c_view_name (c_inv_type VARCHAR2)
   IS
   SELECT nit_view_name
   FROM NM_INV_TYPES
   WHERE nit_inv_type = c_inv_type
   AND nit_table_name IS NULL;
--
   l_first BOOLEAN;
   l_view_name NM_INV_TYPES.nit_view_name%TYPE;
   l_col_name VARCHAR(30);
   l_nullable VARCHAR2(1);
   col_rec nm3type.ref_cursor;
   
   l_elements nm3type.tab_varchar30;
BEGIN
   nm_debug.proc_start(g_package_name , 'create_inv_items_dtd');
   l_elements.DELETE;
   g_dtd := NULL;
   append( c_version);
   append( c_generated_by );
   append( c_element || 'INV_ITEMS '||c_open);
   FOR i IN 1..p_inv_type.COUNT LOOP
      append( p_inv_type(i)||c_star );
      IF i != p_inv_type.COUNT THEN
         append ( c_comma);
      END IF ;
   END LOOP ;
   append ( c_close||c_end );

   FOR i IN 1..p_inv_type.COUNT LOOP
      -- get the view name for the inv_type      
      OPEN c_view_name( p_inv_type(i) );
      FETCH c_view_name INTO l_view_name;
      IF c_view_name%NOTFOUND THEN
        CLOSE c_view_name;
        --RAISE_APPLICATION_ERROR( -20001,'No View name for '||p_inv_type(i));     
      ELSE
        CLOSE c_view_name;
      END IF;
      
      IF l_view_name IS NOT NULL THEN 
         -- user the view to get the column names as we need to include the 
         -- non flexable ones iit_primary_key, ne_id start_date end_date etc     
         append( c_element || p_inv_type(i)||c_space|| c_open );
         OPEN col_rec FOR 'select column_name,nullable'
               ||CHR(10)||'from user_tab_columns'
               ||CHR(10)||'where table_name = :view_name'
               ||CHR(10)||'order by column_id'         
                          USING l_view_name;
                                      
         FETCH col_rec INTO l_col_name;
         append( l_col_name || c_qmark ); -- 1st one is ne_id optional
         add_to_list(l_elements, l_col_name);
         LOOP      
            FETCH col_rec INTO l_col_name, l_nullable;
            EXIT WHEN col_rec%NOTFOUND;  -- exit loop when last row is fetched
            IF col_required( l_col_name ) THEN 
               append( c_comma );                     
               append( l_col_name );
               IF is_col_mandatory(p_inv_type(i),l_col_name) = 'N' THEN 
                  append( c_qmark );
               END IF;
               add_to_list(l_elements, l_col_name);
            END IF;
         END LOOP;    
         CLOSE col_rec;
         -- append the location elements as a choice either section or route
         -- and allow the location to be optional, 0(zero) or more
         append( c_comma||c_open||'SECTION'||c_star||c_bar||'ROUTE'||c_close||c_star);
         append( c_close || c_end );
      END IF;
   END LOOP;
    
   append( c_element || 'ROUTE' || c_space || c_open);
   append( 'ROUTE_NE_UNIQUE' );
   append( c_comma || 'ROUTE_NE_ID' || c_qmark );
   append( c_comma || 'ROUTE_SLK_START');
   append( c_comma || 'ROUTE_SLK_END' || c_qmark ); 
   append( c_comma || 'NM_START_DATE' || c_qmark  );
   append( c_comma || 'NM_END_DATE' || c_qmark );
   append( c_comma || 'NM_ADMIN_UNIT' || c_qmark );
   append( c_close || c_end );

   append( c_element || 'SECTION' || c_space || c_open);
   append( 'DATUM_NE_UNIQUE' );
   append( c_comma || 'NE_ID_OF'||c_qmark );
   append( c_comma || 'NM_BEGIN_MP'  );
   append( c_comma || 'NM_END_MP' ||c_qmark);
   append( c_comma || 'NM_SEQ_NO' ); 
   append( c_comma || 'NM_START_DATE' || c_qmark  );
   append( c_comma || 'NM_END_DATE' || c_qmark );
   append( c_comma || 'NM_ADMIN_UNIT' || c_qmark );
   append( c_close || c_end );
   
   append( c_element || 'ROUTE_NE_UNIQUE' || c_basic_type );
   append( c_element || 'ROUTE_NE_ID'     || c_basic_type );
   append( c_element || 'ROUTE_SLK_START' || c_basic_type );
   append( c_element || 'ROUTE_SLK_END'   || c_basic_type );
   append( c_element || 'NM_START_DATE'   || c_basic_type );
   append( c_element || 'NM_END_DATE'     || c_basic_type );
   append( c_element || 'NM_ADMIN_UNIT'   || c_basic_type );
   append( c_element || 'DATUM_NE_UNIQUE' || c_basic_type );
   append( c_element || 'NE_ID_OF'        || c_basic_type );
   append( c_element || 'NM_BEGIN_MP'     || c_basic_type );
   append( c_element || 'NM_END_MP'       || c_basic_type );
   append( c_element || 'NM_SEQ_NO'       || c_basic_type );
   
   
   FOR i IN 1..l_elements.COUNT LOOP      
      append( c_element || l_elements(i) || c_basic_type );                
   END LOOP;    

   p_dtd := g_dtd;
   --
   nm_debug.proc_end(g_package_name , 'create_inv_items_dtd');
END create_inv_items_dtd;
--
PROCEDURE get_inv_items_xml ( p_inv_type NM_INV_ITEMS.iit_inv_type%TYPE )
IS
   CURSOR c_view_name (c_inv_type VARCHAR2)
   IS
   SELECT nit_view_name
   FROM NM_INV_TYPES
   WHERE nit_inv_type = c_inv_type;

   CURSOR c_cols (c_tab_name VARCHAR2)
   IS 
   SELECT column_name
   FROM USER_TAB_COLUMNS
   WHERE table_name = c_tab_name;
     
   l_view_name NM_INV_TYPES.nit_view_name%TYPE;
   l_col_name VARCHAR(30);
   l_nullable VARCHAR2(1);
   col_rec nm3type.ref_cursor;

   col_names nm3type.tab_varchar30;
   l_sql VARCHAR2(2000);
   l_block CLOB;
   l_dtd CLOB;   
BEGIN
   nm_debug.proc_start(g_package_name , 'get_inv_items_xml');
   
   l_dtd := g_dtd;
   
   OPEN c_view_name( p_inv_type) ;
   FETCH c_view_name INTO l_view_name;
   IF c_view_name%NOTFOUND THEN
     CLOSE c_view_name;
     RAISE_APPLICATION_ERROR( -20001,'No View name for '||p_inv_type);
   END IF;
   CLOSE c_view_name;

   OPEN c_cols (l_view_name);
   FETCH c_cols BULK COLLECT INTO col_names;
   CLOSE c_cols;
   
   l_sql := 'cursor c1 is select'|| CHR(10);
   l_sql := l_sql || col_names(1);
   FOR i IN 2..col_names.last LOOP
      l_sql := l_sql || c_comma|| col_names(i);
   END LOOP;
   l_sql := l_sql || ' From '|| l_view_name||CHR(10);
   l_sql := l_sql || ' where rownum <5'||CHR(10); -- limit the number of rows for testing
   l_sql := l_sql || ';' || CHR(10);

   g_dtd := NULL;   
   append( 'declare','Y' );
   append( l_sql );
   FOR i IN 1..col_names.last LOOP
      append( col_names(i) || c_space || l_view_name||'.'||col_names(i)||'%type;'||CHR(10));
   END LOOP;
   append( 'begin' || CHR(10)) ;
   append( ' nm3_xmldtd.g_dtd := null;' || CHR(10)) ;   
   append( ' for c1rec in c1 loop'||CHR(10));
   append( ' nm3_xmldtd.append( ''<'||p_inv_type||'>''||chr(10));'||CHR(10));
   FOR i IN 1..col_names.last LOOP
      append( 'IF C1REC.'||col_names(i)||' IS NOT NULL THEN ' );
      append( '   nm3_xmldtd.append( ''<'||col_names(i)||'>''||c1rec.'||col_names(i)||'||''</'||col_names(i)||'>''||chr(10));'||CHR(10));
      append( 'END IF;' );
   END LOOP;
   append( ' nm3_xmldtd.append( ''</'||p_inv_type||'>''||chr(10));'||CHR(10));
   append( ' end loop;'||CHR(10));
   append( 'end;' || CHR(10) );   

   l_block := g_dtd;
   -- the PL/SQL block to be executed
   --nm_debug.delete_debug( TRUE );
   --nm_debug.debug_on;
   --nm_debug.debug( 'l_block ' );
   --nm_debug.debug_clob( l_block );
   --nm_debug.debug_off;
   nm3clob.execute_immediate_clob(p_clob => l_block);                      

   dbms_lob.append ( dest_lob => l_dtd, src_lob  => g_dtd);             
   g_dtd := l_dtd;                   
   
   nm_debug.proc_end(g_package_name , 'get_inv_items_xml');
END get_inv_items_xml;
--
PROCEDURE create_inv_items_xml( p_inv_type IN nm3type.tab_varchar30) 
IS
  l_xml CLOB; 
BEGIN 
  create_inv_items_xml( p_inv_type => p_inv_type 
                       ,p_inv_xml  => l_xml);
--
   save_to_table( p_xmldoc => l_xml
                 ,p_type => 'XML'
                 ,p_name => 'INV_ITEMS'
                );                     
END create_inv_items_xml;
--
--
PROCEDURE create_inv_items_xml( p_inv_type nm3type.tab_varchar30
                               ,p_filename VARCHAR2
                               ,p_filedir  VARCHAR2
                              )
IS
   l_dtd CLOB;
BEGIN 
   create_inv_items_xml ( p_inv_type => p_inv_type,
                          p_inv_xml=> l_dtd
                        );
   nm3clob.writeclobout(  result => l_dtd
                        , file_location => p_filedir
                        , file_name => p_filename
                       );                           
END create_inv_items_xml;
--
PROCEDURE create_inv_items_xml( p_inv_type IN nm3type.tab_varchar30 
                               ,p_inv_xml IN OUT CLOB)
IS 
BEGIN 
   nm_debug.proc_start(g_package_name , 'create_inv_items_xml');
   g_dtd := NULL;
   append( '<INV_ITEMS>'||CHR(10) );
   FOR i IN 1..p_inv_type.COUNT LOOP
      get_inv_items_xml( p_inv_type(i));
   END LOOP;
   append( '</INV_ITEMS>' );
   
   p_inv_xml := g_dtd;

--    nm_debug.delete_debug( TRUE );
--    nm_debug.debug_on;
--    nm_debug.debug_clob( g_dtd );
--    nm_debug.debug_off;
   
   nm_debug.proc_end(g_package_name , 'create_inv_items_xml');
END create_inv_items_xml;
--
PROCEDURE build_sql_string ( p_table IN VARCHAR2
                            ,p_string IN OUT VARCHAR2
                           )
IS
   CURSOR c_col_names ( c_tab VARCHAR2) IS
   SELECT column_name
   FROM USER_TAB_COLUMNS
   WHERE table_name = UPPER(c_tab);
BEGIN
   p_string := 'SELECT ';
   FOR c_col_name_rec IN c_col_names(p_table) LOOP
      p_string := p_string ||''''||c_col_name_rec.column_name||'="''||'||c_col_name_rec.column_name||'||''" '' ||' ;
   END LOOP;
   -- remove the last || from the string
   p_string := SUBSTR(p_string,1,LENGTH(p_string)-2);
   p_string := p_string || CHR(10)||'FROM '||p_table;
END build_sql_string;
--
PROCEDURE create_inv_types_xml ( file_location IN VARCHAR2
                               , file_name IN VARCHAR2
                               , p_item_types IN nm3type.tab_varchar30
                               )
IS
  l_where VARCHAR2(2000) := NULL;
BEGIN
  l_where := l_where || 'WHERE nit_inv_type in (';
  FOR i IN 1..p_item_types.COUNT LOOP
     l_where := l_where || p_item_types(i)||',';
  END LOOP;
  l_where := SUBSTR(l_where,1,LENGTH(l_where)-1);
  l_where := l_where || ')';
--
  create_inv_types_xml( file_location
                       ,file_name
                       ,l_where
                      );
END create_inv_types_xml;
--
PROCEDURE create_inv_types_xml ( file_location IN VARCHAR2
                               , file_name IN VARCHAR2
                               , p_item_types IN VARCHAR2
                               )
IS
   c1   nm3type.ref_cursor;
   c2   nm3type.ref_cursor;
   c_inv_types   nm3type.ref_cursor;
--
   l_inv_types        VARCHAR2(2000);
   l_inv_type_attribs VARCHAR2(2000);
   l_txt VARCHAR2(2000);
   l_table VARCHAR2(30);
   l_item_type NM_INV_TYPES.nit_inv_type%TYPE;
   l_where VARCHAR2(2000);
--
BEGIN
--   nm_debug.delete_debug( TRUE );
--   nm_debug.debug_on;
   nm_debug.proc_start(g_package_name , 'create_inv_types_xml');
--
   IF SUBSTR(p_item_types,1,5) = 'WHERE' THEN
      l_where := p_item_types;
   ELSE
      l_where := 'WHERE nit_inv_type = '''||p_item_types||'''';
   END IF;
--
   g_dtd := NULL;
   append ('<?xml version="1.0" encoding="UTF-8"?>');
   append ('<!--XML file generated by exor corp '||TO_CHAR(TRUNC(SYSDATE),'DD-MON-YYYY')||' -->');
   append ('<DATA>'||CHR(10));
--
   OPEN c_inv_types FOR 'select nit_inv_type from nm_inv_types ' || l_where ;
   LOOP
      FETCH c_inv_types INTO l_item_type;
      EXIT WHEN c_inv_types%NOTFOUND;
   --
      -- build nm_inv_types sql
      l_table := 'NM_INV_TYPES';
      build_sql_string( l_table , l_inv_types);
      l_inv_types := l_inv_types || CHR(10)||'WHERE nit_inv_type in ('''||l_item_type||''')';
   --
   --
      append ('<NM_INV_TYPES_ALL ');
   --
      l_txt := NULL;
      OPEN c1 FOR l_inv_types;
      LOOP
         EXIT WHEN c1%NOTFOUND;
         FETCH c1 INTO l_txt;
         IF c1%FOUND THEN
            append ( l_txt|| '>'||CHR(10) );
            -- build nm_inv_type_attribs SQL
            l_table := 'NM_INV_TYPE_ATTRIBS';
            build_sql_string( l_table , l_inv_type_attribs);
            l_inv_type_attribs := l_inv_type_attribs || CHR(10)||'WHERE ita_inv_type in ('''||l_item_type||''')';
            l_txt := NULL;
            OPEN c2 FOR l_inv_type_attribs;
            LOOP
               EXIT WHEN c2%NOTFOUND;
               FETCH c2 INTO l_txt;
               IF c1%FOUND THEN
                  append ('<NM_INV_TYPE_ATTRIBS_ALL '||CHR(10));
                  append ( l_txt || '>' || CHR(10));
                  append ('</NM_INV_TYPE_ATTRIBS_ALL>'||CHR(10));
               END IF;
            END LOOP;
            CLOSE c2;
         END IF;
      END LOOP;
      CLOSE c1;
   --
   --
      append ('</NM_INV_TYPES_ALL>'||CHR(10));
   --
   END LOOP;
--
   append ('</DATA>'||CHR(10));
--
   nm3clob.writeclobout(  result => g_dtd
                        , file_location => file_location
                        , file_name => file_name
                       );
--
   nm_debug.proc_end(g_package_name , 'create_inv_types_xml');
--   nm_debug.debug_off;
END create_inv_types_xml;
--
--
FUNCTION  insert_xmlclob_to_table( xmldoc IN CLOB
                                  ,p_table VARCHAR2
                                  ,p_cols nm3type.tab_varchar30
                                  ,p_rowsettag VARCHAR2 DEFAULT NULL
                                  ,p_rowtag VARCHAR2 DEFAULT NULL
                                  ,p_date_format VARCHAR2 DEFAULT 'dd-MMM-yyyy'
                                 )
RETURN NUMBER
IS
  insctx dbms_xmlsave.ctxtype;
  doc CLOB;
  ROWS NUMBER;
  errornum NUMBER;
  errormsg VARCHAR2(200);
BEGIN
   nm_debug.proc_start(g_package_name , 'insert_xmlclob_to_table');
--
   insctx := dbms_xmlsave.newcontext(p_table); -- get the save context..!
--
   IF p_rowtag IS NOT NULL THEN
      dbms_xmlsave.setrowtag(insctx, p_rowtag);
   END IF;
--
   dbms_xmlsave.clearupdatecolumnlist(insctx); -- clear the update settings
--
   -- set the columns to be updated as a list of values..
   FOR i IN 1..p_cols.COUNT LOOP
      dbms_xmlsave.setupdatecolumn(insctx,p_cols(i));
   END LOOP;
--
   -- set the date format
   dbms_xmlsave.setdateformat( insctx , p_date_format);
   -- Now insert the doc. This will only insert into the above columns
   ROWS := dbms_xmlsave.insertxml(insctx, xmldoc);
--
   dbms_xmlsave.closecontext(insctx);
--
   nm_debug.proc_end(g_package_name , 'insert_xmlclob_to_table');
--
   RETURN ROWS;
--   EXCEPTION 
--   WHEN OTHERS THEN 
--      dbms_xmlsave.getexceptioncontent(insctx, errornum, errormsg);
 --     dbms_xmlsave.closecontext(insctx); 
 --     RAISE_APPLICATION_ERROR( -20100, 'Error Inserting:'||errornum||':'||errormsg); 
--   
END insert_xmlclob_to_table;
--
FUNCTION  insert_xmlclob_to_table( xmldoc IN CLOB
                                  ,p_table VARCHAR2
                                  ,p_rowsettag VARCHAR2 DEFAULT NULL
                                  ,p_rowtag VARCHAR2 DEFAULT NULL
                                  ,p_date_format VARCHAR2 DEFAULT 'dd-MMM-yyyy'
                                 )
RETURN NUMBER
IS
  l_cols nm3type.tab_varchar30;
BEGIN
  RETURN insert_xmlclob_to_table( xmldoc => xmldoc
                                 ,p_table => p_table
                                 ,p_cols => l_cols
                                 ,p_rowsettag => p_rowsettag
                                 ,p_rowtag => p_rowtag
                                 ) ;
END insert_xmlclob_to_table;
--
FUNCTION get_xml( p_type VARCHAR2, p_descr VARCHAR2 )
RETURN CLOB
IS
CURSOR c1 (c_type VARCHAR2, c_descr VARCHAR2)
IS SELECT nxf_doc
  FROM NM_XML_FILES
   WHERE nxf_type = c_type
   AND nxf_file_type = c_descr;
l_retval CLOB := NULL;
BEGIN
   OPEN c1 ( p_type, p_descr );
   FETCH c1 INTO l_retval;
   IF c1%NOTFOUND THEN
      CLOSE c1;
      RAISE_APPLICATION_ERROR( -20001, p_descr || ' ' || p_type  ||' not found');
   END IF;
   CLOSE c1;
   RETURN l_retval;
END get_xml;
--
PROCEDURE get_child_element_and_value( p_node xmldom.domnode )
IS
node_list xmldom.domnodelist;
node xmldom.domnode;
len NUMBER;
element xmldom.domelement;
l_name VARCHAR2(2000);
l_value VARCHAR2(2000);
BEGIN
   IF xmldom.haschildnodes( p_node ) THEN
      node_list := xmldom.getchildnodes( p_node );
      len := xmldom.getlength(node_list);
      node := xmldom.item(node_list, len-1);
      element := xmldom.makeelement(xmldom.getparentnode(node));
      l_name := xmldom.gettagname(element);
      l_value := xmldom.getnodevalue(node);
      nm_debug.debug(l_name || ': ' || l_value);
   END IF;
END get_child_element_and_value;
--
PROCEDURE get_attribute_and_value( p_node IN xmldom.domnode )
IS 
  l_attrib nm3type.tab_varchar2000;
  l_attrib_value nm3type.tab_varchar2000;
BEGIN
  get_attribute_and_value( p_node => p_node
                          ,p_attribute => l_attrib
                          ,p_attrib_value => l_attrib_value
                         ); 
END get_attribute_and_value;
--
PROCEDURE get_attribute_and_value( p_node IN xmldom.domnode
                                  ,p_attribute IN OUT nm3type.tab_varchar2000
                                  ,p_attrib_value IN OUT nm3type.tab_varchar2000
                                 )
IS
named_node_map xmldom.domnamednodemap;
len NUMBER;
node xmldom.domnode;
attrname VARCHAR2(100);
attrval VARCHAR2(100);
--
BEGIN
      -- get all attributes of element
      named_node_map := xmldom.getattributes(p_node);

     IF (xmldom.isnull(named_node_map) = FALSE) THEN
        len := xmldom.getlength(named_node_map);

        -- loop through attributes
        FOR i IN 0..len-1 LOOP
           node := xmldom.item(named_node_map, i);
           attrname := xmldom.getnodename(node);
           attrval := xmldom.getnodevalue(node);
           p_attribute(i+1) := attrname;
           p_attrib_value(i+1) := attrval;
           --nm_debug.debug('  ' || attrname || ' = ' || attrval);
           dbms_output.put_line('  ' || attrname || ' = ' || attrval);
        END LOOP;
     END IF;
END get_attribute_and_value;
--
PROCEDURE read_xmldoc(doc xmldom.domdocument, p_tagname VARCHAR2 DEFAULT '*') IS
nl xmldom.domnodelist;
len1 NUMBER;
n xmldom.domnode;
--
BEGIN
   -- get all elements
   nl := xmldom.getelementsbytagname(doc, p_tagname);
   len1 := xmldom.getlength(nl);
--
   -- loop through elements
   FOR j IN 0..len1-1 LOOP
      n := xmldom.item(nl, j);
--
      get_child_element_and_value( n );
--
      -- get all attributes of element
      get_attribute_and_value( n) ;
--
   END LOOP;
END read_xmldoc;
--
PROCEDURE create_nodepoint_dtd
IS
BEGIN 
   nm_debug.proc_start(g_package_name , 'create_nodepoint_dtd');
   g_dtd := NULL;
   append( c_version);
   append( c_generated_by );
   append( c_element || 'NODES'||c_space||c_open||'NODE'||c_close||c_star||c_end);
   append( c_element || 'NODE' ||c_space||c_open);      
   append( 'NO_DESCR'||c_comma||c_space);
   append( 'NO_NODE_TYPE'||c_comma||c_space);
   append( 'NO_START_DATE'||c_comma||c_space);
   append( 'NO_NODE_NAME'||c_qmark||c_comma||c_space);   
   append( 'NP_DESCR'||c_comma||c_space);
   append( 'NP_GRID_EAST'||c_qmark||c_comma||c_space);
   append( 'NP_GRID_NORTH'||c_qmark);
   append( c_close||c_end );
   append( c_attlist ||'NODE num'||c_cdata||c_required||c_end);
   append( c_element ||'NO_DESCR'||c_basic_type);
   append( c_element ||'NO_NODE_TYPE'||c_basic_type);    
   append( c_element ||'NO_START_DATE'||c_basic_type);
   append( c_element ||'NO_NODE_NAME'||c_basic_type);
   append( c_element ||'NP_DESCR'||c_basic_type);
   append( c_element ||'NP_GRID_EAST'||c_basic_type);
   append( c_element ||'NP_GRID_NORTH'||c_basic_type);      
--
    parsedtdclob ( p_dtd => g_dtd
                  ,p_root => 'NODES');
--
   save_to_table( p_xmldoc => g_dtd
                 ,p_type => 'DTD'
                 ,p_name => 'NODES'
                );
--                   
   nm_debug.proc_end(g_package_name , 'create_nodepoint_dtd');
END create_nodepoint_dtd;
--
--
PROCEDURE create_datum_elements_dtd
IS
   CURSOR element_cols 
   IS
   SELECT column_name, nullable
   FROM USER_TAB_COLUMNS
   WHERE table_name = 'NM_ELEMENTS_ALL'
   AND column_name NOT IN ( 'NE_DATE_MODIFIED'
                           ,'NE_DATE_CREATED'
                           ,'NE_MODIFIED_BY'
                           ,'NE_CREATED_BY'
                           ,'NE_ID')
   ORDER BY nullable ASC;
--   
   l_first BOOLEAN;
   l_type VARCHAR2(20) := 'DATUMS';
BEGIN 
   nm_debug.proc_start(g_package_name , 'create_elements_dtd');
   g_dtd := NULL;
   append( c_version);
   append( c_generated_by );
   append( c_element || 'DATUMS'||c_space||c_open||'DATUM'||c_close||c_star||c_end);
   append( c_element || 'DATUM' ||c_space||c_open);
   l_first := TRUE;
   FOR  element_cols_rec IN element_cols LOOP
      IF l_first THEN 
         l_first := FALSE;
      ELSE
         append( c_comma ); 
      END IF;
      append( element_cols_rec.column_name );
      IF element_cols_rec.nullable = 'Y' OR
         element_cols_rec.column_name = 'NE_UNIQUE' THEN 
         append( c_qmark );
      END IF;
   END LOOP;  
   append( c_close||c_end );
   append( c_attlist ||'DATUM num'||c_cdata||c_required||c_end);
   FOR  element_cols_rec IN element_cols LOOP  
      append( c_element ||element_cols_rec.column_name||c_basic_type);
   END LOOP;
--
    parsedtdclob ( p_dtd => g_dtd
                  ,p_root => l_type);
--
   save_to_table( p_xmldoc => g_dtd
                 ,p_type => 'DTD'
                 ,p_name => l_type
                );
--                   
   nm_debug.proc_end(g_package_name , 'create_elements_dtd');
END create_datum_elements_dtd;
--
PROCEDURE create_groups_dtd
IS
   CURSOR element_cols 
   IS
   SELECT column_name, nullable
   FROM USER_TAB_COLUMNS
   WHERE table_name = 'NM_ELEMENTS_ALL'
   AND column_name NOT IN ( 'NE_DATE_MODIFIED'
                           ,'NE_DATE_CREATED'
                           ,'NE_MODIFIED_BY'
                           ,'NE_CREATED_BY'
                           ,'NE_ID')
   ORDER BY nullable ASC;
--   
   l_first BOOLEAN;
   l_type VARCHAR2(20) := 'GROUPS';
BEGIN 
   nm_debug.proc_start(g_package_name , 'create_elements_dtd');
   g_dtd := NULL;
   append( c_version);
   append( c_generated_by );
   append( c_element || 'GROUPS'||c_space||c_open||'GROUP'||c_close||c_star||c_end);
   append( c_element || 'GROUP' ||c_space||c_open);
   l_first := TRUE;
   FOR  element_cols_rec IN element_cols LOOP
      IF l_first THEN 
         l_first := FALSE;
      ELSE
         append( c_comma ); 
      END IF;
      append( element_cols_rec.column_name );
      IF element_cols_rec.nullable = 'Y' 
       OR element_cols_rec.column_name = 'NE_UNIQUE' THEN 
         append( c_qmark );
      END IF;
   END LOOP;  
   append( c_comma || 'DATUMS' || c_star );  
   append( c_close||c_end );
   append( c_attlist ||'GROUP num'||c_cdata||c_required||c_end);
   FOR  element_cols_rec IN element_cols LOOP  
      append( c_element ||element_cols_rec.column_name||c_basic_type);
   END LOOP;
   
   append( c_element || 'DATUMS'||c_space||c_open );
   append( 'NM_UNIQUE'||c_comma||c_space);
   append( 'NM_BEGIN_MP'||c_comma||c_space);
   append( 'NM_END_MP'||c_qmark||c_comma||c_space);
   append( 'NM_CARDINALITY'||c_comma||c_space);
   append( 'NM_START_DATE'||c_space);
   append( c_close||c_end );
   append( c_element ||'NM_UNIQUE'||c_basic_type);
   append( c_element ||'NM_BEGIN_MP'||c_basic_type);
   append( c_element ||'NM_END_MP'||c_basic_type);
   append( c_element ||'NM_CARDINALITY'||c_basic_type);
   append( c_element ||'NM_START_DATE'||c_basic_type);
--
   save_to_table( p_xmldoc => g_dtd
                 ,p_type => 'DTD'
                 ,p_name => l_type
                );
    parsedtdclob ( p_dtd => g_dtd
                  ,p_root => l_type);
--
   save_to_table( p_xmldoc => g_dtd
                 ,p_type => 'DTD'
                 ,p_name => l_type
                );
--                   
   nm_debug.proc_end(g_package_name , 'create_elements_dtd');
END create_groups_dtd;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_xml( pi_xml_name    NM_UPLOAD_FILES.name%TYPE DEFAULT NULL
                   ,pi_style_sheet NM_UPLOAD_FILES.name%TYPE DEFAULT NULL
                  )
IS
  CURSOR cs_exists ( c_name NM_UPLOAD_FILES.name%TYPE )
  IS
  SELECT name
  FROM NM_UPLOAD_FILES
  WHERE name = c_name;

  l_xml_name    NM_UPLOAD_FILES.name%TYPE;
  l_style_sheet NM_UPLOAD_FILES.name%TYPE;
BEGIN                     
  nm_debug.proc_start(g_package_name , 'show_xml');
  
  IF pi_xml_name IS NULL
  THEN 
    htp.p('XML NOT Found : '|| pi_xml_name);
  END IF;
  
  IF pi_style_sheet IS NULL
  THEN 
    htp.p('XML Style Sheet NOT Found : '|| pi_style_sheet);
  END IF;
  
  
  OPEN cs_exists( pi_xml_name );
  
  FETCH cs_exists INTO l_xml_name;
  
  IF cs_exists%FOUND 
  THEN 
     CLOSE cs_exists;
     
     OPEN cs_exists( pi_style_sheet );
     
     FETCH cs_exists INTO l_style_sheet;
     
     IF cs_exists%FOUND 
     THEN 
        CLOSE cs_exists;
        
        htp.p('<script LANGUAGE="javascript">');
        htp.p('   // load xml');
        htp.p('   var xml = new ActiveXObject("Microsoft.XMLDOM");');
        htp.p('   xml.async = false;');
        htp.p('   xml.load("'||nm3web.get_download_url(l_xml_name)||'")');
        
        htp.p('   // load the xsl');
        htp.p('   var xsl = new ActiveXObject("Microsoft.XMLDOM");');
        htp.p('   xsl.async = false;');
        htp.p('   xsl.load("'||nm3web.get_download_url(l_style_sheet)||'")');
        
        htp.p('   // transform');
        htp.p('   document.write(xml.transformNode(xsl));');
     
        htp.p('</script>');
     ELSE
       CLOSE cs_exists;
     END IF;
  ELSE
     CLOSE cs_exists;
  END IF;
  
  nm_debug.proc_end(g_package_name , 'show_xml');    
  
END show_xml;
--
-----------------------------------------------------------------------------
--

END nm3_xmldtd;
/

