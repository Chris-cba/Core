CREATE OR REPLACE PACKAGE BODY nm3sdo_xml AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_xml.pkb-arc   2.3   Jul 04 2013 16:32:56   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3sdo_xml.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:32:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.1
---------------------------------------------------------------------------
--   Author : I Turnbull
--
--   nm3sdo_xml body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   2.3  $';

  g_package_name CONSTANT VARCHAR2(30) := 'nm3sdo_xml';

  g_clob CLOB;
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
   nm3clob.append(p_clob => g_clob
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
FUNCTION build_sdo_geometry( p_sdo_gtype          IN NUMBER DEFAULT 3302
                          ,p_sdo_srid           IN NUMBER DEFAULT NULL
                          ,p_sdo_point          IN mdsys.sdo_point_type DEFAULT null
                          ,p_sdo_elem_info      IN mdsys.sdo_elem_info_array
                          ,p_sdi_ordinate_array IN mdsys.sdo_ordinate_array
                         )
RETURN mdsys.sdo_geometry
IS
BEGIN
   nm_debug.proc_start(g_package_name , 'build_sdo_geometry');
   nm_debug.proc_end(g_package_name , 'build_sdo_geometry');

   RETURN mdsys.sdo_geometry( p_sdo_gtype
                             ,p_sdo_srid
                             ,p_sdo_point
                             ,p_sdo_elem_info
                             ,p_sdi_ordinate_array
                            );

END build_sdo_geometry;
--
-----------------------------------------------------------------------------
--
PROCEDURE  build_ordinate_array( p_node           IN     xmldom.domnode
                                ,p_ordinate_array IN OUT mdsys.sdo_ordinate_array
                                ,p_ordinate_index IN OUT NUMBER
                               )
IS
   coord_node                   xmldom.domnode;
   value_node                   xmldom.domnode;

BEGIN
   nm_debug.proc_start(g_package_name , 'build_ordinate_array');

   coord_node := xmldom.getfirstchild( p_node );
   WHILE xmldom.isnull( coord_node ) = FALSE LOOP
      p_ordinate_index := p_ordinate_index + 1;
      IF p_ordinate_index != 1
       THEN
         p_ordinate_array.EXTEND;
      END IF;

      value_node := xmldom.getfirstchild( coord_node );
--       nm_debug.DEBUG( xmldom.getnodename(coord_node));
--       nm_debug.DEBUG(xmldom.getnodevalue(value_node));

      p_ordinate_array(p_ordinate_index) := xmldom.getnodevalue(value_node);

      coord_node := xmldom.getnextsibling( coord_node );
   END LOOP;

   nm_debug.proc_end(g_package_name , 'build_ordinate_array');
END build_ordinate_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_sdo_elem_info( p_sdo_elem_info   IN OUT mdsys.sdo_elem_info_array
                              ,p_elem_info_index IN OUT NUMBER
                              ,p_ordinate_index  IN     NUMBER
                             )
IS
BEGIN
   p_elem_info_index := p_elem_info_index + 1;
   IF p_elem_info_index != 1
    THEN
      p_sdo_elem_info.EXTEND;
   END IF;
   p_sdo_elem_info(p_elem_info_index) := 1;

   p_elem_info_index := p_elem_info_index + 1;
   p_sdo_elem_info.EXTEND;
   p_sdo_elem_info(p_elem_info_index) := 2;

   p_elem_info_index := p_elem_info_index + 1;
   p_sdo_elem_info.EXTEND;
   p_sdo_elem_info(p_elem_info_index) := p_ordinate_index + 1;


END;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_ordinate_array( p_array mdsys.sdo_ordinate_array)
IS
BEGIN
   FOR i IN 1..p_array.COUNT
   LOOP
     nm_debug.DEBUG( 'Ordinate Array Item '||i||'  = ' ||p_array(i) );
   END LOOP;
END debug_ordinate_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_elem_info_array( p_array mdsys.sdo_elem_info_array)
IS
BEGIN
   FOR i IN 1..p_array.COUNT
   LOOP
     nm_debug.DEBUG( 'Elem Info Array Item '||i||'  = ' ||p_array(i) );
   END LOOP;
END debug_elem_info_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_srsname( p_node     IN xmldom.domnode
                      ,p_srs_name IN OUT NUMBER
                     )
IS
   l_attrib       nm3type.tab_varchar2000;
   l_attrib_value nm3type.tab_varchar2000;
BEGIN
   nm3_xmldtd.get_attribute_and_value( p_node => p_node
                                      ,p_attribute => l_attrib
                                      ,p_attrib_value => l_attrib_value
                                     );
   p_srs_name := TO_NUMBER(l_attrib_value(1));
END get_srsname;
--
-----------------------------------------------------------------------------
--
FUNCTION load_shape ( p_xml CLOB
                     ,p_file_type NM_XML_FILES.nxf_file_type%TYPE
                    )
RETURN mdsys.sdo_geometry
IS
   l_xml CLOB;

   l_doc xmldom.domdocument;
   nl xmldom.domnodelist;
   len1 NUMBER;

   datum_node                   xmldom.domnode; -- <DATUM>
   multilinestringproperty_node xmldom.domnode; -- <gml:multiLineStringProperty>
   multilinestring_node         xmldom.domnode; -- <gml:MultiLineString>
   linestringmember_node        xmldom.domnode; -- <gml:lineStringMember>
   linestring_node              xmldom.domnode;  -- <gml:LineString>
   exorcoord_node               xmldom.domnode;  -- <exorcoord>
--
   l_ordinate_array mdsys.sdo_ordinate_array;
   l_ordinate_index NUMBER;

   l_sdo_elem_info       mdsys.sdo_elem_info_array;
   l_sdo_elem_info_index NUMBER;

   l_srsname NUMBER;
BEGIN
   nm_debug.proc_start(g_package_name , 'load_inv');
--
   l_ordinate_array := mdsys.sdo_ordinate_array(NULL);
   l_ordinate_index := 0;

   l_sdo_elem_info := mdsys.sdo_elem_info_array(NULL);
   l_sdo_elem_info_index :=0 ;

   l_xml := p_xml;

   l_doc := nm3_xmldtd.parseclob( l_xml );

   nl := xmldom.getelementsbytagname(l_doc, p_file_type);
   len1 := xmldom.getlength(nl);

   -- loop through elements
   FOR j IN 0..len1-1 LOOP
      datum_node := xmldom.item(nl, j);
      multilinestringproperty_node := xmldom.getfirstchild( datum_node );
      --nm_debug.debug ( xmldom.getnodename( itemnode ));
      WHILE xmldom.isnull( multilinestringproperty_node ) = FALSE LOOP
         multilinestring_node := xmldom.getfirstchild( multilinestringproperty_node );
         WHILE xmldom.isnull( multilinestring_node ) = FALSE LOOP

            get_srsname( p_node     => multilinestring_node
                        ,p_srs_name =>l_srsname
                       );

            linestringmember_node := xmldom.getfirstchild( multilinestring_node );
            WHILE xmldom.isnull( linestringmember_node ) = FALSE LOOP

               build_sdo_elem_info( p_sdo_elem_info   => l_sdo_elem_info
                                   ,p_elem_info_index => l_sdo_elem_info_index
                                   ,p_ordinate_index  => l_ordinate_index
                                  );

               linestring_node := xmldom.getfirstchild( linestringmember_node );
               WHILE xmldom.isnull( linestring_node ) = FALSE LOOP
                  exorcoord_node := xmldom.getfirstchild( linestring_node );
                  WHILE xmldom.isnull( exorcoord_node ) = FALSE LOOP

                     build_ordinate_array( p_node           => exorcoord_node
                                          ,p_ordinate_array => l_ordinate_array
                                          ,p_ordinate_index => l_ordinate_index
                                         );

                     exorcoord_node := xmldom.getnextsibling( exorcoord_node );
                  END LOOP;
                  linestring_node := xmldom.getnextsibling( linestring_node );
               END LOOP;
               linestringmember_node := xmldom.getnextsibling( linestringmember_node );
            END LOOP;
            multilinestring_node := xmldom.getnextsibling( multilinestring_node );
         END LOOP;
         multilinestringproperty_node := xmldom.getnextsibling( multilinestringproperty_node );
      END LOOP;
  END LOOP;
--
  xmldom.freedocument( l_doc );
--
--   debug_ordinate_array( l_ordinate_array );
--   debug_elem_info_array( l_sdo_elem_info );

   RETURN build_sdo_geometry(p_sdo_srid           => l_srsname
                            ,p_sdo_elem_info      => l_sdo_elem_info
                            ,p_sdi_ordinate_array => l_ordinate_array);
--
   nm_debug.proc_end(g_package_name , 'load_inv');
END load_shape;
--
-----------------------------------------------------------------------------
--
FUNCTION build_xml( p_sdo_geo mdsys.sdo_geometry)
RETURN CLOB
IS

   l_ord_start nm3type.tab_number;
   l_ord_end   nm3type.tab_number;

   l_ind NUMBER;

   PROCEDURE inc
   IS
   BEGIN
      l_ind := l_ind + 1;
   END inc;
BEGIN
   nm_debug.proc_start(g_package_name , 'build_xml');


   FOR i IN 1..(p_sdo_geo.sdo_elem_info.COUNT/3)
    LOOP
      l_ord_start(i) := p_sdo_geo.sdo_elem_info(i*3);
      IF ((i*3)+3) > p_sdo_geo.sdo_elem_info.COUNT
       THEN
         l_ord_end(i) := p_sdo_geo.sdo_ordinates.COUNT;
      ELSE
         l_ord_end(i)   := p_sdo_geo.sdo_elem_info((i*3)+3)-1;
      END IF;
   END LOOP;

   FOR i IN 1..l_ord_start.COUNT LOOP
     nm_debug.DEBUG( 'l_ord_start('||i||')  = ' ||l_ord_start(i) );
   END LOOP;

   FOR i IN 1..l_ord_end.COUNT LOOP
     nm_debug.DEBUG( 'l_ord_end('||i||')  = ' ||l_ord_end(i) );
   END LOOP;

   g_clob := NULL;
   append( nm3_xmldtd.c_start||'datum'||nm3_xmldtd.c_end );
   append( nm3_xmldtd.c_start||'multiLineStringProperty'||nm3_xmldtd.c_end );
   append( nm3_xmldtd.c_start||'MultiLineString'||
           nm3_xmldtd.c_space||'srsName='||
           nm3_xmldtd.c_quote||p_sdo_geo.sdo_srid||nm3_xmldtd.c_quote||
           nm3_xmldtd.c_end );
   FOR i IN 1..(p_sdo_geo.sdo_elem_info.COUNT/3)
    LOOP
      append( nm3_xmldtd.c_start||'LineStringMember'||nm3_xmldtd.c_end );
      append( nm3_xmldtd.c_start||'LineString'||nm3_xmldtd.c_end );

--      FOR j IN 1..(p_sdo_geo.sdo_elem_info.COUNT/3)
 --      LOOP
         l_ind := l_ord_start(i);
         WHILE l_ord_end(i) >= l_ind
         LOOP
            append( nm3_xmldtd.c_start||'exorcoord'||nm3_xmldtd.c_end );

            append( '<X>' || p_sdo_geo.sdo_ordinates(l_ind)||'</X>');
            inc;
            append( '<Y>' || p_sdo_geo.sdo_ordinates(l_ind)||'</Y>');
            inc;
            append( '<M>' || p_sdo_geo.sdo_ordinates(l_ind)||'</M>');
            inc;

            append( nm3_xmldtd.c_start||nm3_xmldtd.c_slash||'exorcoord'||nm3_xmldtd.c_end );
         END LOOP;
   --   END LOOP;
      append( nm3_xmldtd.c_start||nm3_xmldtd.c_slash||'LineString'||nm3_xmldtd.c_end );
      append( nm3_xmldtd.c_start||nm3_xmldtd.c_slash||'LineStringMember'||nm3_xmldtd.c_end );
   END LOOP;
   append( nm3_xmldtd.c_start||nm3_xmldtd.c_slash||'MultiLineString'||nm3_xmldtd.c_end );
   append( nm3_xmldtd.c_start||nm3_xmldtd.c_slash||'multiLineStringProperty'||nm3_xmldtd.c_end );
   append( nm3_xmldtd.c_start||nm3_xmldtd.c_slash||'datum'||nm3_xmldtd.c_end );

   nm_debug.proc_end(g_package_name , 'build_xml');
   RETURN g_clob;
END build_xml;
--
-----------------------------------------------------------------------------
--
END nm3sdo_xml;
/

