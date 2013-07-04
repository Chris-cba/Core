CREATE OR REPLACE PACKAGE BODY nm3xml_load AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3xml_load.pkb-arc   2.2   Jul 04 2013 16:40:30   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3xml_load.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:40:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:22  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.7
-------------------------------------------------------------------------
--   Author : I Turnbull
--
--   nm3xml_load package body
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
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3xml_load';
--
   g_tab_varchar nm3type.tab_varchar32767;
--
   g_inv_list     nm3type.tab_number;
   g_inv_end_date nm3type.tab_date;
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

PROCEDURE db
IS
   l_v VARCHAR2(4000);
BEGIN

   FOR i IN 1..g_tab_varchar.COUNT LOOP
      l_v := g_tab_varchar(i);
   END LOOP;
END db ;


FUNCTION get_next_batch_id RETURN NUMBER IS
   CURSOR c1 IS
   SELECT batch_id_seq.NEXTVAL FROM dual;

   retval NUMBER;

BEGIN
   nm_debug.proc_start(g_package_name,'get_next_batch_id');

   OPEN c1;

   FETCH c1 INTO retval;

   CLOSE c1;

   nm_debug.proc_end(g_package_name,'get_next_batch_id');

   RETURN retval;
END get_next_batch_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_xml_type ( p_xml CLOB )
RETURN VARCHAR2
IS
   l_doc xmldom.domdocument;
   nl xmldom.domnodelist;
   n xmldom.domnode;
   nodename VARCHAR2(100);
BEGIN
-- Returns the name of the first element
   l_doc := nm3_xmldtd.parseclob( p_xml );
--
   nl := xmldom.getelementsbytagname(l_doc, '*');
--
   n := xmldom.item(nl, 0);
   nodename := xmldom.getnodename( n );

   xmldom.freedocument( l_doc );
--
   RETURN nodename;
END get_xml_type;
--
-----------------------------------------------------------------------------
--
FUNCTION call_xml_loader( p_xml CLOB
                         , p_name VARCHAR2 DEFAULT NULL
                         , p_commit VARCHAR2 DEFAULT 'N')
RETURN NUMBER
IS
  l_name VARCHAR2(100);
  retval NUMBER;
BEGIN
  retval := -1;
  l_name := p_name;
  IF l_name IS NULL THEN
     l_name := get_xml_type( p_xml );
  ELSE
     l_name := get_xml_type( p_xml );
     IF l_name != p_name THEN
        RAISE_APPLICATION_ERROR( -20201,'File Type '||l_name ||' does not match selected type '||p_name);
     END IF;
  END IF;
--
  IF l_name = 'NODES' THEN
     retval := nm3xml_load.load_nodes( p_xml );
  ELSIF l_name = 'DATUMS' THEN
     retval := nm3xml_load.load_datums( p_xml );
  ELSE --l_name = 'INV_ITEMS' THEN
     retval := nm3xml_load.load_inv( p_xml, l_name, p_commit );
--   ELSE
--      RAISE_APPLICATION_ERROR(-20200,'Unknown xml file type : '||l_name);
  END IF;
  RETURN retval;
END call_xml_loader;
--
-----------------------------------------------------------------------------
--
PROCEDURE append ( p_text VARCHAR2
                  ,p_nl   BOOLEAN DEFAULT TRUE
                 )
IS
BEGIN

--    nm_debug.proc_start(g_package_name , 'append');

    nm3ddl.append_tab_varchar(  p_tab => g_tab_varchar
                              , p_text => p_text
                              , p_nl => p_nl);

--    nm_debug.proc_end(g_package_name , 'append');

END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_elements_and_values( p_node IN xmldom.domnode
                                  ,p_elements IN OUT nm3type.tab_varchar2000
                                  ,p_elements_value IN OUT nm3type.tab_varchar2000
                                 )
IS
   datumnode xmldom.domnode;
   nodevalue xmldom.domnode;
   cnt NUMBER;
BEGIN
   datumnode := p_node;
--
   nodevalue := xmldom.getfirstchild( datumnode );
   cnt := 1;
   p_elements(cnt) := xmldom.getnodename( datumnode );
   p_elements_value(cnt) := xmldom.getnodevalue(nodevalue);
   cnt := cnt + 1;
   --nm_debug.debug( xmldom.getnodename( datumnode )||'='||xmldom.getnodevalue(nodevalue));
   WHILE xmldom.isnull( datumnode ) = FALSE LOOP
      datumnode := xmldom.getnextsibling( datumnode );
      IF xmldom.isnull( datumnode ) = FALSE THEN
         nodevalue := xmldom.getfirstchild( datumnode );
         p_elements(cnt) := xmldom.getnodename( datumnode);
         IF xmldom.isnull( nodevalue ) = FALSE THEN
            p_elements_value(cnt) := xmldom.getnodevalue(nodevalue);
         ELSE
            p_elements_value(cnt) := NULL;
         END IF;
         --nm_debug.debug( p_elements(cnt)||'-'||p_elements_value(cnt));
         cnt := cnt + 1;
      END IF;
   END LOOP;
END get_elements_and_values;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nxb( pi_nxb_rec NM_XML_LOAD_BATCHES%ROWTYPE )
IS
BEGIN

-- nm_debug.debug( 'pi_nxb_rec.nxb_type '||pi_nxb_rec.nxb_type );
-- nm_debug.debug( 'pi_nxb_rec.nxb_file_type ' ||pi_nxb_rec.nxb_file_type );
-- nm_debug.debug( 'pi_nxb_rec.nxb_batch_id ' ||pi_nxb_rec.nxb_batch_id );

   INSERT INTO NM_XML_LOAD_BATCHES
   ( nxb_type
   , nxb_file_type
   , nxb_batch_id
   )
   VALUES
   ( 'DTD' --pi_nxb_rec.nxb_type
   , pi_nxb_rec.nxb_file_type
   , pi_nxb_rec.nxb_batch_id
   )  ;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nxl( pi_nxl_rec NM_XML_LOAD_ERRORS%ROWTYPE )
IS
BEGIN
   nm_debug.proc_start(g_package_name , 'ins_nxl');
   -- debug
--    nm_debug.debug_on;
--    nm_debug.debug( 'pi_nxl_rec.nxl_batch_id ' ||pi_nxl_rec.nxl_batch_id );
--    nm_debug.debug( 'pi_nxl_rec.nxl_record_id ' ||pi_nxl_rec.nxl_record_id );
--    nm_debug.debug( 'pi_nxl_rec.nxl_error ' ||pi_nxl_rec.nxl_error );
--    nm_debug.debug( 'pi_nxl_rec.nxl_processed ' ||pi_nxl_rec.nxl_processed );
--   nm_debug.debug_off;


   INSERT INTO NM_XML_LOAD_ERRORS
      ( nxl_batch_id
      , nxl_record_id
      , nxl_error
      , nxl_data
      , nxl_processed
      )
   VALUES
      ( pi_nxl_rec.nxl_batch_id
      , pi_nxl_rec.nxl_record_id
      , pi_nxl_rec.nxl_error
      , pi_nxl_rec.nxl_data
      , pi_nxl_rec.nxl_processed
      )  ;
   
   nm_debug.proc_end(g_package_name , 'ins_nxl');
END ins_nxl;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_batch_record( p_type      IN NM_XML_LOAD_BATCHES.nxb_type%TYPE
                              ,p_file_type IN NM_XML_LOAD_BATCHES.nxb_file_type%TYPE
                              ,p_batch_id  IN OUT NM_XML_LOAD_BATCHES.nxb_batch_id%TYPE
                             )

IS
  PRAGMA autonomous_transaction;

  l_nxb_rec NM_XML_LOAD_BATCHES%ROWTYPE;
BEGIN
  p_batch_id := get_next_batch_id;

  l_nxb_rec.nxb_type := p_type;
  l_nxb_rec.nxb_file_type := p_file_type;
  l_nxb_rec.nxb_batch_id := p_batch_id;

  ins_nxb( l_nxb_rec );

  COMMIT;
END;
--
-----------------------------------------------------------------------------
--

FUNCTION get_next_record_id ( pi_batch_id NM_XML_LOAD_ERRORS.nxl_batch_id%TYPE )
RETURN NM_XML_LOAD_ERRORS.nxl_record_id%TYPE
IS
   CURSOR cs_next_record ( c_batch_id NM_XML_LOAD_ERRORS.nxl_record_id%TYPE )
   IS
   SELECT NVL(MAX(nxl_record_id),0) + 1
   FROM NM_XML_LOAD_ERRORS
   WHERE nxl_batch_id = c_batch_id;

   l_retval NM_XML_LOAD_ERRORS.nxl_record_id%TYPE;

BEGIN
   nm_debug.proc_start(g_package_name , 'get_next_record_id');

   OPEN cs_next_record ( pi_batch_id );

   FETCH cs_next_record INTO l_retval;

   CLOSE cs_next_record;

   nm_debug.proc_end(g_package_name , 'get_next_record_id');
   RETURN l_retval;

END get_next_record_id;

PROCEDURE save_error( p_batch_id NUMBER
                     ,p_error VARCHAR2
                     ,p_data CLOB DEFAULT NULL
                    )
IS
--
  PRAGMA autonomous_transaction;
--
  l_nxl_rec NM_XML_LOAD_ERRORS%ROWTYPE;
BEGIN
   nm_debug.proc_start(g_package_name , 'save_error');

   l_nxl_rec.nxl_batch_id := p_batch_id;
   l_nxl_rec.nxl_record_id := get_next_record_id(p_batch_id);
   l_nxl_rec.nxl_error := p_error;
   l_nxl_rec.nxl_data :=  p_data ;
   l_nxl_rec.nxl_processed := 'N';

   ins_nxl( l_nxl_rec );

   -- its an autonomous_transaction so commit is OK.
   COMMIT;

   nm_debug.proc_end(g_package_name , 'save_error');
END save_error;
--
-----------------------------------------------------------------------------
--
FUNCTION exec_insert ( p_batch_id NUMBER
                      ,p_node     CLOB DEFAULT NULL
                      ,p_commit   VARCHAR2 DEFAULT 'N'
                     )
RETURN NUMBER
IS
   e_unique_constraint EXCEPTION;
   PRAGMA EXCEPTION_INIT(e_unique_constraint, -00001);

   l_error VARCHAR2(4000) := 'error';
BEGIN
   nm_debug.proc_start(g_package_name , 'exec_insert');

   --nm_debug.debug_on;
   --nm3ddl.debug_tab_varchar(g_tab_varchar); 
   
   g_records_processed := g_records_processed + 1;

   nm3ddl.execute_tab_varchar(g_tab_varchar);

   -- No errors raised with the insert so either rollback or commit

   IF p_commit = 'Y' THEN
      COMMIT;
   ELSE
      ROLLBACK;
   END IF;

   -- either way return that one row could have been or
   -- would have been inserted
   RETURN 1;

   EXCEPTION
      WHEN e_unique_constraint THEN
        save_error( p_batch_id => p_batch_id
                   ,p_error => 'Item already exists'
                   ,p_data  => p_node
                  );
      RETURN 0;

      WHEN OTHERS THEN
        l_error := SQLERRM;
        
        save_error( p_batch_id => p_batch_id
                   ,p_error => l_error
                   ,p_data  => p_node
                  );
                  
--         nm_debug.debug_on;
--         nm_debug.debug( 'ERROR ' );
--         nm3ddl.debug_tab_varchar(g_tab_varchar); 
--         nm_debug.debug_off;          
        RETURN 0;

   nm_debug.proc_end(g_package_name , 'exec_insert');
END ;

--
-----------------------------------------------------------------------------
--
PROCEDURE build_inv_insert( p_inv_type VARCHAR2
                           ,p_attrib nm3type.tab_varchar2000
                           ,p_attrib_val nm3type.tab_varchar2000
                           ,p_location nm3type.tab_varchar2000
                           ,p_location_val nm3type.tab_varchar2000
                          )
IS
   l_attrib nm3type.tab_varchar2000;
   l_attrib_val nm3type.tab_varchar2000;
   l_location nm3type.tab_varchar2000;
   l_location_val nm3type.tab_varchar2000;

   l_i NUMBER;

BEGIN
   nm_debug.proc_start(g_package_name , 'build_inv_insert');

   l_attrib := p_attrib;
   l_attrib_val := p_attrib_val;
   l_location := p_location;
   l_location_val := p_location_val;

   -- remove section and route elements
   FOR i IN 1..l_attrib.COUNT LOOP
      IF l_attrib(i) = 'SECTION' OR
         l_attrib(i) = 'ROUTE'
      THEN
         l_attrib.DELETE(i);
         l_attrib_val.DELETE(i);
      END IF;
   END LOOP;

   g_tab_varchar.DELETE;

   append ( 'INSERT INTO '||nm3inv_view.derive_nw_inv_type_view_name( p_inv_type ) );

   append ( nm3_xmldtd.c_open );
   l_i := l_attrib.first;
   WHILE l_i IS NOT NULL LOOP
      append( l_attrib(l_i) );
      IF l_i != l_attrib.last THEN
         append( nm3_xmldtd.c_comma );
      END IF;
   l_i := l_attrib.NEXT(l_i);
   END LOOP;

   IF l_location.COUNT >= 1 THEN
      append ( nm3_xmldtd.c_comma );
   END IF;

   FOR i IN 1..l_location.COUNT LOOP
      append( l_location(i) );
      IF i != l_location.last THEN
         append( nm3_xmldtd.c_comma );
      END IF;
   END LOOP;

   append( nm3_xmldtd.c_close );
   append( 'VALUES' );
   append( nm3_xmldtd.c_open );

   l_i := l_attrib_val.first;
   WHILE l_i IS NOT NULL LOOP
      append( nm3flx.string(l_attrib_val(l_i)) );
      IF l_i != l_attrib_val.last THEN
         append( nm3_xmldtd.c_comma );
      END IF;
   l_i := l_attrib_val.NEXT(l_i);
   END LOOP;

   IF l_location_val.COUNT >= 1 THEN
      append ( nm3_xmldtd.c_comma );
   END IF;

   FOR i IN 1..l_location_val.COUNT LOOP
      append( nm3flx.string(l_location_val(i)) );
      IF i != l_location_val.last THEN
            append( nm3_xmldtd.c_comma );
      END IF;
   END LOOP;

   append( nm3_xmldtd.c_close );

   nm_debug.proc_end(g_package_name , 'build_inv_insert');
END build_inv_insert;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_temp_extent( pi_temp_ne_id  IN  NUMBER
                             ,p_location     IN  nm3type.tab_varchar2000
                             ,p_location_val IN  nm3type.tab_varchar2000
                            )
IS
   l_temp_ext NM_NW_TEMP_EXTENTS%ROWTYPE;
BEGIN
   nm_debug.proc_start(g_package_name , 'add_to_temp_extent');

--    nm_debug.debug_on;
--    nm_debug.debug( 'add_to_temp_extent ' );
--    nm_debug.debug( 'pi_temp_ne_id  = ' ||pi_temp_ne_id );
   
   l_temp_ext.nte_job_id := pi_temp_ne_id;
   l_temp_ext.nte_cardinality := 1;
   l_temp_ext.nte_route_ne_id := NULL;

   FOR i IN 1..p_location.COUNT LOOP
      IF p_location(i) = 'DATUM_NE_UNIQUE' THEN
         l_temp_ext.nte_ne_id_of := nm3net.get_ne_id(p_location_val(i));
      ELSIF p_location(i) = 'NE_ID_OF' THEN
         l_temp_ext.nte_ne_id_of := p_location_val(i);
      ELSIF p_location(i) = 'NM_BEGIN_MP' THEN
         l_temp_ext.nte_begin_mp := p_location_val(i);
      ELSIF p_location(i) = 'NM_END_MP' THEN
         l_temp_ext.nte_end_mp := p_location_val(i);
      ELSIF p_location(i) = 'NM_SEQ_NO' THEN
         l_temp_ext.nte_seq_no := p_location_val(i);
      END IF;
   END LOOP;

   nm3extent.ins_nte( l_temp_ext );
   

   nm_debug.proc_end(g_package_name , 'add_to_temp_extent');
END add_to_temp_extent;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_inv_list
IS
BEGIN

   g_inv_list.DELETE;

   g_inv_end_date.DELETE;

END delete_inv_list;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_inv_list( pi_nm_ne_id_in NM_MEMBERS.nm_ne_id_in%TYPE
                          ,pi_end_date    NM_MEMBERS.nm_end_date%TYPE
                         )
IS
   l_found BOOLEAN;
BEGIN
   nm_debug.proc_start(g_package_name , 'add_to_inv_list');

   l_found := FALSE;
    FOR i IN 1..g_inv_list.COUNT LOOP
       IF g_inv_list(i) = pi_nm_ne_id_in THEN
          l_found := TRUE;
       END IF;
    END LOOP;

    IF l_found = FALSE THEN
       g_inv_list(g_inv_list.COUNT + 1) := pi_nm_ne_id_in;
       g_inv_end_date(g_inv_list.COUNT ) := pi_end_date;
    END IF;

   nm_debug.proc_end(g_package_name , 'add_to_inv_list');
END add_to_inv_list;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_inv_list
IS
   CURSOR cs_inv_loc ( c_nm_ne_id_in NM_MEMBERS.nm_ne_id_in%TYPE )
   IS
   SELECT 1
   FROM NM_MEMBERS
   WHERE nm_ne_id_in = c_nm_ne_id_in;

   CURSOR cs_inv ( c_iit_ne_id NM_MEMBERS.nm_ne_id_in%TYPE )
   IS
   SELECT ROWID
   FROM NM_INV_ITEMS
   WHERE iit_ne_id = c_iit_ne_id
   AND iit_inv_type = ( SELECT nit_inv_type
                        FROM NM_INV_TYPES
                        WHERE nit_inv_type = iit_inv_type
                          AND nit_end_loc_only = 'N')
   FOR UPDATE OF iit_ne_id;

   l_count NUMBER;
   l_row_id ROWID;

BEGIN
   nm_debug.proc_start(g_package_name , 'process_inv_list');

   FOR i IN 1..g_inv_list.COUNT LOOP
      OPEN cs_inv_loc( g_inv_list(i) );

      FETCH cs_inv_loc INTO l_count;

      IF cs_inv_loc%NOTFOUND THEN
         -- endate the inv_item
         -- as it doesn't have any locations
         -- and is not end location only
         OPEN cs_inv ( g_inv_list(i) );
         FETCH cs_inv INTO l_row_id;
         IF cs_inv%FOUND THEN
            UPDATE NM_INV_ITEMS
            SET iit_end_date = g_inv_end_date(i)
            WHERE ROWID = l_row_id;
            CLOSE cs_inv;
         ELSE
            CLOSE cs_inv;
         END IF;
         CLOSE cs_inv_loc;
      ELSE
         CLOSE cs_inv_loc;
      END IF;
   END LOOP;

   nm_debug.proc_end(g_package_name , 'process_inv_list');

END process_inv_list;
--
-----------------------------------------------------------------------------
--
FUNCTION load_inv ( p_filelocation VARCHAR2
                   ,p_filename VARCHAR2
                   ,p_commit   VARCHAR2 DEFAULT 'N'
                  )
RETURN NUMBER
IS
 l_xml CLOB;
BEGIN
 nm3clob.readclobin (  file_location => p_filelocation
                       , file_name => p_filename
                       , result => l_xml);
 RETURN load_inv( p_xml => l_xml
                 ,p_commit => p_commit );
END load_inv;
--

FUNCTION load_inv ( p_xml CLOB
                   ,p_file_type NM_XML_FILES.nxf_file_type%TYPE DEFAULT 'INV_ITEMS'
                   ,p_commit   VARCHAR2 DEFAULT 'N'
                  )
RETURN NUMBER
IS
   l_xml CLOB;
   l_dtd CLOB;
   l_doc xmldom.domdocument;
   nl xmldom.domnodelist;
   len1 NUMBER;
   top xmldom.domnode;  -- INV_ITEMS
   itemnode xmldom.domnode; -- inv type
   attribnode xmldom.domnode; -- iit_inv_type, iit_primary_key
   locationnode xmldom.domnode; -- location SECTION, ROUTE
   l_curr_node xmldom.domnode; -- The current node

   l_curr_node_clob CLOB;
--
   l_attrib nm3type.tab_varchar2000;
   l_attrib_val nm3type.tab_varchar2000;
   l_loc nm3type.tab_varchar2000;
   l_loc_val nm3type.tab_varchar2000;
   l_location nm3type.tab_varchar2000;
   l_location_val nm3type.tab_varchar2000;

   l_inv_type NM_INV_TYPES.nit_inv_type%TYPE;

   cnt NUMBER;
   insert_count NUMBER;

   l_temp_ne_id NUMBER;

   l_commit VARCHAR2(1);
BEGIN
   nm_debug.proc_start(g_package_name , 'load_inv');
--
   l_commit := p_commit;

   insert_count := 0;

   l_xml := p_xml;
--
   l_dtd := nm3_xmldtd.get_xml(  p_type => 'DTD', p_descr => p_file_type);
--
   IF l_commit = 'N' THEN
      l_doc := nm3_xmldtd.check_xml_with_dtd( l_xml, l_dtd, p_file_type);
   ELSE
      l_doc := nm3_xmldtd.parseclob( l_xml );
   END IF;
--
   nl := xmldom.getelementsbytagname(l_doc, p_file_type);
   len1 := xmldom.getlength(nl);
--
   create_batch_record( p_type      => 'XML'
                       ,p_file_type => p_file_type
                       ,p_batch_id  => g_batch_id
                      );

   delete_inv_list;
--
   -- loop through elements
  g_records_processed := 0;
  FOR j IN 0..len1-1 LOOP
      top := xmldom.item(nl, j);
      --nm_debug.debug('TOP = '|| xmldom.getnodename( top ));
         -- get the attributes for the section
         itemnode := xmldom.getfirstchild( top );
         --nm_debug.debug ( xmldom.getnodename( itemnode ));
         WHILE xmldom.isnull( itemnode ) = FALSE LOOP

            --g_records_processed := g_records_processed + 1;

            l_curr_node := xmldom.clonenode(itemnode, TRUE);
            IF xmldom.isnull( l_curr_node ) = FALSE THEN
               nm3clob.create_clob(l_curr_node_clob);
               xmldom.writetoclob(l_curr_node, l_curr_node_clob);
            END IF;

            l_inv_type  := xmldom.getnodename( itemnode );
            --nm_debug.debug( 'ITEM = ' ||l_inv_type );
            attribnode := xmldom.getfirstchild( itemnode );

            get_elements_and_values( p_node => attribnode
                                    ,p_elements => l_attrib
                                    ,p_elements_value => l_attrib_val
                                   );

            l_attrib(l_attrib.COUNT+1) := 'IIT_NE_ID';
            l_attrib_val(l_attrib_val.COUNT+1) := nm3net.get_next_ne_id;

            -- loop until its a location node
            l_temp_ne_id := nm3net.get_next_nte_id;

            WHILE xmldom.isnull( attribnode ) = FALSE
            LOOP
              IF xmldom.getnodename( attribnode ) = 'SECTION' OR
                 xmldom.getnodename( attribnode ) = 'ROUTE'
              THEN
                 locationnode := xmldom.getfirstchild( attribnode );

                 get_elements_and_values( p_node => locationnode
                                         ,p_elements => l_location
                                         ,p_elements_value => l_location_val
                                        );
                 IF xmldom.getnodename( attribnode ) = 'SECTION' THEN
                    -- build up a temp extent of all the individual sections
                    add_to_temp_extent( pi_temp_ne_id => l_temp_ne_id
                                       ,p_location => l_location
                                       ,p_location_val => l_location_val
                                      );
                    l_location.DELETE;
                    l_location_val.DELETE;
                    l_location(1) := 'NE_ID_OF';
                    l_location_val(1) := l_temp_ne_id;
                 END IF;
              END IF;
              --nm_debug.debug( 'ATTRIB = ' ||xmldom.getnodename( attribnode ) );
              attribnode := xmldom.getnextsibling( attribnode ) ;

            END LOOP;
--             nm_debug.debug_on;
--             nm_debug.debug( g_package_name);
--             nm_debug.debug( 'l_temp_ne_id ' || l_temp_ne_id );
--             nm_debug.debug_sql_string( 'select * from nm_nw_temp_extents where nte_job_id = '||l_temp_ne_id );
--             nm_debug.debug_off;
             

            build_inv_insert( p_inv_type => l_inv_type
                             ,p_attrib => l_attrib
                             ,p_attrib_val => l_attrib_val
                             ,p_location => l_location
                             ,p_location_val => l_location_val
                            );

            l_attrib.DELETE;
            l_attrib_val.DELETE;

            l_location.DELETE;
            l_location_val.DELETE;

            insert_count := insert_count + exec_insert( g_batch_id
                                                      , l_curr_node_clob
                                                      , l_commit );

            itemnode := xmldom.getnextsibling( itemnode );

            EXIT WHEN xmldom.isnull(itemnode);
         END LOOP;
  END LOOP;

  process_inv_list;
--
  xmldom.freedocument( l_doc );
--
   RETURN insert_count;
--
   nm_debug.proc_end(g_package_name , 'load_inv');
END load_inv;
--
-----------------------------------------------------------------------------
--
FUNCTION get_existing_inv_item( pi_inv_type   NM_INV_ITEMS.iit_inv_type%TYPE
                               ,pi_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                               ,pi_end_date   NM_MEMBERS.nm_end_date%TYPE
                              )
RETURN  NM_MEMBERS.nm_ne_id_in%TYPE
IS
   CURSOR cs_inv_item ( c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                       ,c_nm_obj_type NM_MEMBERS.nm_obj_type%TYPE
                      )
   IS
   SELECT nm_ne_id_in
   FROM NM_MEMBERS
       ,NM_NW_TEMP_EXTENTS
   WHERE nte_job_id = c_nte_job_id
     AND nm_obj_type = c_nm_obj_type
     AND nm_ne_id_of = nte_ne_id_of;
            
   l_nm_ne_id_in NM_MEMBERS.nm_ne_id_in%TYPE;            
BEGIN 
   nm_debug.proc_start(g_package_name , 'get_existing_inv_item');
   
   OPEN cs_inv_item ( pi_nte_job_id, pi_inv_type );
   
   FETCH cs_inv_item INTO l_nm_ne_id_in;

   IF cs_inv_item%FOUND THEN
      CLOSE cs_inv_item;

      add_to_inv_list( l_nm_ne_id_in, pi_end_date );
   ELSE
      CLOSE cs_inv_item;
   END IF;

   nm_debug.proc_end(g_package_name , 'get_existing_inv_item');

   RETURN l_nm_ne_id_in;
   
END get_existing_inv_item;
--
-----------------------------------------------------------------------------
--                              
FUNCTION   get_existing_inv_item( pi_inv_type NM_INV_ITEMS.iit_inv_type%TYPE
                                 ,pi_unique   NM_ELEMENTS.ne_unique%TYPE
                                 ,pi_begin_mp NM_MEMBERS.nm_begin_mp%TYPE
                                 ,pi_end_mp   NM_MEMBERS.nm_end_mp%TYPE
                                 ,pi_end_date NM_MEMBERS.nm_end_date%TYPE
                                )
RETURN NM_MEMBERS.nm_ne_id_in%TYPE
IS
   CURSOR cs_inv_item ( c_nm_obj_type NM_INV_ITEMS.iit_inv_type%TYPE
                       ,c_unique   NM_ELEMENTS.ne_unique%TYPE
                       ,c_begin_mp NM_MEMBERS.nm_begin_mp%TYPE
                       ,c_end_mp   NM_MEMBERS.nm_end_mp%TYPE
                      )
   IS
   SELECT nm_ne_id_in
   FROM NM_MEMBERS
   WHERE nm_obj_type = c_nm_obj_type
   AND   nm_ne_id_of = nm3net.get_ne_id( c_unique )
   AND   c_begin_mp >= nm_begin_mp
   AND   c_end_mp <= nm_end_mp;

   l_nm_ne_id_in NM_MEMBERS.nm_ne_id_in%TYPE;
BEGIN
   nm_debug.proc_start(g_package_name , 'get_existing_inv_item');

   OPEN cs_inv_item ( pi_inv_type
                     ,pi_unique
                     ,pi_begin_mp
                     ,pi_end_mp
                    );

   FETCH cs_inv_item INTO l_nm_ne_id_in;

   IF cs_inv_item%FOUND THEN
      CLOSE cs_inv_item;

      add_to_inv_list( l_nm_ne_id_in, pi_end_date );
   ELSE
      CLOSE cs_inv_item;
   END IF;

   nm_debug.proc_end(g_package_name , 'get_existing_inv_item');

   RETURN l_nm_ne_id_in;

END get_existing_inv_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_column_type ( p_column_name ALL_TAB_COLUMNS.column_name%TYPE
                          ,p_table_name  ALL_TAB_COLUMNS.table_name%TYPE
                         )
RETURN VARCHAR2
IS
   l_column_details_rec ALL_TAB_COLUMNS%ROWTYPE;
BEGIN 
   nm_debug.proc_start(g_package_name , 'get_column_type');
   
   l_column_details_rec := nm3ddl.get_column_details ( p_column_name => p_column_name
                                                      ,p_table_name  => p_table_name );

   RETURN l_column_details_rec.data_type;
                                                             
   nm_debug.proc_end(g_package_name , 'get_column_type');
END get_column_type;                         
--
-----------------------------------------------------------------------------
--
FUNCTION load_nodes ( p_filelocation VARCHAR2
                     ,p_filename VARCHAR2
                    )
RETURN NUMBER
IS
l_xml CLOB;
BEGIN
   nm_debug.proc_start(g_package_name , 'load_nodes');

   -- load the file into a clob
   nm3clob.readclobin ( result  => l_xml
                       ,file_location => p_filelocation
                       ,file_name     => p_filename
                      );

   nm_debug.proc_end(g_package_name , 'load_nodes');

   RETURN load_nodes( p_xml => l_xml );

END load_nodes;
--
-----------------------------------------------------------------------------
--
FUNCTION load_nodes ( p_xml CLOB )
RETURN NUMBER
IS
l_doc xmldom.domdocument;
l_xml CLOB;
l_dtd CLOB;
l_root VARCHAR2(10) ;
l_rows NUMBER;
BEGIN
   nm_debug.proc_start(g_package_name , 'load_nodes');
--
   l_root := 'NODES';
--
   l_xml := p_xml;
--
   -- gets the nodes DTD from nm_xml table
   l_dtd := nm3_xmldtd.get_xml( p_type => 'DTD'
                               ,p_descr => l_root);
--
   -- validate the xml with the DTD
   l_doc :=  nm3_xmldtd.check_xml_with_dtd( p_xml  => l_xml
                                           ,p_dtd  => l_dtd
                                           ,p_root_element => l_root );
--
   -- free memory used by l_doc
   xmldom.freedocument( l_doc );
--
   -- insert the xml into the nm_points and nm_nodes table
   -- via view v_node_points and instead of trigger on view
   -- commit is implicit.
   l_rows := nm3_xmldtd.insert_xmlclob_to_table( xmldoc => l_xml
                                                 ,p_table => 'V_NODE_POINTS'
                                                 ,p_rowsettag => 'NODES'
                                                 ,p_rowtag => 'NODE'
                                                );
--
  RETURN l_rows;
--
   nm_debug.proc_end(g_package_name , 'load_nodes');
END load_nodes;
--
-----------------------------------------------------------------------------
--
FUNCTION load_datums ( p_filelocation VARCHAR2
                     ,p_filename VARCHAR2
                    )
RETURN NUMBER
IS
l_xml CLOB;
BEGIN
   nm_debug.proc_start(g_package_name , 'load_datums');
   -- load the file into a clob
   nm3clob.readclobin ( result  => l_xml
                       ,file_location => p_filelocation
                       ,file_name     => p_filename
                      );
   nm_debug.proc_end(g_package_name , 'load_datums');
   RETURN load_datums( p_xml => l_xml );
END load_datums;
--
-----------------------------------------------------------------------------
--
FUNCTION load_datums ( p_xml CLOB )
RETURN NUMBER
IS
l_doc xmldom.domdocument;
l_xml CLOB;
l_dtd CLOB;
l_root VARCHAR2(10) ;
l_rows NUMBER;
BEGIN
   nm_debug.proc_start(g_package_name , 'load_datums');
--
   l_root := 'DATUMS';
--
   l_xml := p_xml;
--
   -- gets the nodes DTD from nm_xml table
   l_dtd := nm3_xmldtd.get_xml( p_type => 'DTD'
                               ,p_descr => l_root);
--
   -- validate the xml with the DTD
   l_doc :=  nm3_xmldtd.check_xml_with_dtd( p_xml  => l_xml
                                           ,p_dtd  => l_dtd
                                           ,p_root_element => l_root );
--
   -- free memory used by l_doc
   xmldom.freedocument( l_doc );
--
   -- insert the xml into the nm_points and nm_nodes table
   -- via view v_node_points and instead of trigger on view
   -- commit is implicit.
   l_rows := nm3_xmldtd.insert_xmlclob_to_table( xmldoc => l_xml
                                                 ,p_table => 'V_LOAD_ELEMENTS'
                                                 ,p_rowsettag => 'DATUMS'
                                                 ,p_rowtag => 'DATUM'
                                                );
--
  RETURN l_rows;
--
   nm_debug.proc_end(g_package_name , 'load_datums');
END load_datums;
--
-----------------------------------------------------------------------------
--

PROCEDURE build_rejected_records( pi_type     IN VARCHAR2
                                 ,pi_batch_id IN NUMBER
                                )
IS
  CURSOR cs_errors ( c_batch_id NUMBER )
  IS
  SELECT nxl_data
  FROM NM_XML_LOAD_ERRORS
  WHERE nxl_batch_id = c_batch_id;

  CURSOR cs_check_exists
  IS
  SELECT 1
  FROM NM_UPLOAD_FILES
  WHERE name = 'XML_ERRORS';

  l_clob  CLOB;
  l_blob  BLOB;
  l_dummy NUMBER;

BEGIN
   nm_debug.proc_start(g_package_name , 'build_rejected_records');

   nm3clob.create_clob(l_clob);

   nm3clob.append(  p_clob => l_clob
                  , p_append => nm3_xmldtd.c_start||pi_type||nm3_xmldtd.c_end );

   FOR cs_error_rec IN cs_errors( pi_batch_id ) LOOP
      dbms_lob.append(l_clob,cs_error_rec.nxl_data);

   END LOOP;

   nm3clob.append(  p_clob => l_clob
                  , p_append => nm3_xmldtd.c_start||nm3_xmldtd.c_slash||pi_type||nm3_xmldtd.c_end );


   l_blob := nm3clob.clob_to_blob(l_clob);

   OPEN cs_check_exists;
   FETCH cs_check_exists INTO l_dummy;
   IF cs_check_exists%FOUND THEN

     DELETE NM_UPLOAD_FILES
     WHERE name = 'XML_ERRORS';

   END IF;

   INSERT INTO NM_UPLOAD_FILES
   (name, mime_type, doc_size, dad_charset, last_updated, content_type, blob_content)
   VALUES
   ('XML_ERRORS','text/xml',dbms_lob.getlength(l_blob),'ascii',SYSDATE,'BLOB', l_blob);

   nm_debug.proc_end(g_package_name , 'build_rejected_records');
   EXCEPTION
   WHEN OTHERS
   THEN
     DELETE
       NM_UPLOAD_FILES
     WHERE
       name = 'XML_ERRORS';

END build_rejected_records;
--
-----------------------------------------------------------------------------
--
FUNCTION get_temp_extent( pi_iit_ne_id NM_ELEMENTS.ne_id%TYPE
                         ,pi_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                        )
RETURN NM_ELEMENTS.ne_id%TYPE
IS
   CURSOR cs_locations ( c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE ) 
   IS
   SELECT nte_ne_id_of, 
          nte_begin_mp, 
          nte_end_mp
   FROM NM_NW_TEMP_EXTENTS
   WHERE nte_job_id = c_nte_job_id
   ORDER BY nte_seq_no ;
   
   l_pla     nm_placement_array := nm3pla.initialise_placement_array;
   l_pla_new nm_placement_array := nm3pla.initialise_placement_array;

   l_pl nm_placement := nm3pla.initialise_placement;

   l_temp_ne_id  NM_ELEMENTS.ne_id%TYPE;

BEGIN
   nm_debug.proc_start(g_package_name , 'get_pl');
 
   l_pla := nm3pla.get_placement_from_ne( pi_iit_ne_id );

   FOR c_loc_rec IN cs_locations( pi_nte_job_id ) LOOP
      l_pl.pl_ne_id := c_loc_rec.nte_ne_id_of;
      l_pl.pl_start := c_loc_rec.nte_begin_mp;
      l_pl.pl_end   := c_loc_rec.nte_end_mp;
   
      l_pla_new :=  nm3pla.remove_pl_from_pl_arr( l_pla, l_pl);
      l_pla := l_pla_new;
   END LOOP;

   IF l_pla_new.is_empty THEN
      l_temp_ne_id := -1;
   ELSE
      DELETE FROM NM_NW_TEMP_EXTENTS;
      nm3extent_o.create_temp_ne_from_pl(pi_pl_arr => l_pla_new, po_job_id => l_temp_ne_id);
   END IF;

   nm_debug.proc_end(g_package_name , 'get_pl');

   RETURN l_temp_ne_id;

END get_temp_extent;
--
-----------------------------------------------------------------------------
--
FUNCTION get_temp_extent( pi_iit_ne_id NM_ELEMENTS.ne_id%TYPE
                         ,pi_ne_id NM_ELEMENTS.ne_id%TYPE
                         ,pi_begin NM_MEMBERS.nm_begin_mp%TYPE
                         ,pi_end   NM_MEMBERS.nm_end_mp%TYPE
                        )
RETURN NM_ELEMENTS.ne_id%TYPE
IS
   l_pla     nm_placement_array := nm3pla.initialise_placement_array;
   l_pla_new nm_placement_array := nm3pla.initialise_placement_array;

   l_pl nm_placement := nm3pla.initialise_placement;

   l_temp_ne_id  NM_ELEMENTS.ne_id%TYPE;

BEGIN
   nm_debug.proc_start(g_package_name , 'get_pl');

   l_pla := nm3pla.get_placement_from_ne( pi_iit_ne_id );

   l_pl.pl_ne_id := pi_ne_id;
   l_pl.pl_start := pi_begin;
   l_pl.pl_end   := pi_end;

   l_pla_new :=  nm3pla.remove_pl_from_pl_arr( l_pla, l_pl);

   IF l_pla_new.is_empty THEN
      l_temp_ne_id := -1;
   ELSE
      nm3extent_o.create_temp_ne_from_pl(pi_pl_arr => l_pla_new, po_job_id => l_temp_ne_id);
   END IF;

   nm_debug.proc_end(g_package_name , 'get_pl');

   RETURN l_temp_ne_id;

END get_temp_extent;
--
-----------------------------------------------------------------------------
--

END nm3xml_load;
/
