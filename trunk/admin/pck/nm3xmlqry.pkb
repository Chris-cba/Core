CREATE OR REPLACE PACKAGE BODY nm3xmlqry AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3xmlqry.pkb-arc   2.3   Jul 04 2013 16:41:22   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3xmlqry.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:41:22  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:22  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on         : 1.4
--
--
--   Author : A.N. Other
--
--   xml query package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.3  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'NM3XMLQRY';
--
   l_dummy_package_variable number;
--
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

PROCEDURE cre_xml_from_query( p_query         IN     VARCHAR2
                             ,p_xml           IN OUT CLOB
                             ,p_rowsettag     IN VARCHAR2 DEFAULT NULL
                             ,p_rowtag        IN VARCHAR2 DEFAULT NULL
                             ,p_rowidattrname IN VARCHAR2 DEFAULT NULL
                            )
IS
  l_xml_context dbms_xmlquery.ctxtype;
  l_p xmlparser.parser := xmlparser.newparser;
BEGIN
   nm_debug.proc_start(g_package_name , 'cre_xml_from_query');

   l_xml_context := dbms_xmlquery.newcontext(sqlquery => p_query);

   IF p_rowsettag IS NOT NULL
      THEN
      dbms_xmlquery.setrowsettag( ctxhdl=> l_xml_context,  tag => p_rowsettag);
   END IF;

   IF p_rowtag IS NOT NULL
      THEN
      dbms_xmlquery.setrowtag( ctxhdl=> l_xml_context,  tag => p_rowtag);
   END IF;

   IF p_rowidattrname IS NOT NULL
      THEN
      dbms_xmlquery.setrowidattrname( ctxhdl=> l_xml_context,  attrname => p_rowidattrname);
   END IF;

   p_xml := dbms_xmlquery.getxml( ctxhdl => l_xml_context
                               );
   dbms_xmlquery.closecontext(ctxhdl => l_xml_context);


   nm_debug.proc_end(g_package_name , 'cre_xml_from_query');
END cre_xml_from_query ;


function get_obj_details_as_xml_clob( p_ne_id in nm_elements.ne_id%type ) return clob is

retval  CLOB;
xmlqry  varchar2(4000);

l_ne    nm_elements%rowtype;
l_iit   nm_inv_items%rowtype;
l_type  varchar2(1) := null;
l_tab   varchar2(30);
l_col   varchar2(30);
l_set   varchar2(30);
l_row   varchar2(30);
l_dummy varchar2(30);

BEGIN

--  nm_debug.delete_debug( TRUE );
--  nm_debug.debug_on;

--first find what type the id is - is it a datum, a route/group or an inv record
  --
  BEGIN
  --
    l_ne := nm3get.get_ne( p_ne_id );
    l_type := 'N';
    IF l_ne.ne_gty_group_type IS NOT NULL
    THEN
    --
      l_tab  := 'V_NM_'||l_ne.ne_nt_type||'_'||l_ne.ne_gty_group_type||'_NT';
    --
      IF NOT nm3ddl.does_object_exist (l_tab)
      THEN
        nm3inv_view.create_view_for_nt_type(pi_nt_type  => l_ne.ne_nt_type
                                           ,pi_gty_type => l_ne.ne_gty_group_type);
      END IF;
    --
    ELSE
    --
      l_tab  := 'V_NM_'||l_ne.ne_nt_type||'_NT';
    --
      IF NOT nm3ddl.does_object_exist (l_tab)
      THEN
        nm3inv_view.create_view_for_nt_type(pi_nt_type => l_ne.ne_nt_type);
      END IF;
    --
    END IF;
    l_col  := 'NE_ID';
    l_set  := 'Element';
    l_row  := 'NE_ID';

  EXCEPTION
    WHEN OTHERS THEN
       -- Check to see if it's an Asset if not an Element
       BEGIN
         l_iit  := nm3get.get_iit (p_ne_id );
         l_type := 'I';
         l_tab  := nm3inv_view.derive_inv_type_view_name( l_iit.iit_inv_type );
         l_col  := 'IIT_NE_ID';
         l_set  := nm3get.get_nit( l_iit.iit_inv_type ).nit_short_descr;
         l_row  := 'IIT_NE_ID';
         IF NOT nm3ddl.does_object_exist (l_tab,'VIEW')
         THEN
           nm3inv_view.create_inv_view( p_inventory_type  => l_iit.iit_inv_type
                                      , p_join_to_network => FALSE
                                      , p_view_name       => l_dummy);
         END IF;
       END;
  END;

  xmlqry := 'SELECT * from '||l_tab||' where '||l_col||' = '||to_char(p_ne_id);

--  nm_debug.debug( 'query = '|| xmlqry );

  cre_xml_from_query( xmlqry
                    , retval
                    , p_rowsettag     => l_set
                    , p_rowtag        => l_row
--                    , p_rowidattrname => 'NUMBER'
                    );

  return retval;

--  nm3_xmldtd.insert_xmlclob_to_table( xmldoc, p_table, p_rowsettag, p_rowtag, p_date_format );


END;
----------------------------------------------------------------------------------------------------
--

function get_theme_details_as_xml_clob( p_theme_id in nm_themes_all.nth_theme_id%type, p_ne_id in nm_elements.ne_id%type ) return clob is

l_type varchar2(1) := null;
l_tab  varchar2(30);
l_col  varchar2(30);
l_set  varchar2(30);
l_row  varchar2(30);

l_nth nm_themes_all%rowtype;

xmlqry varchar2(4000);

retval clob;

begin

  l_nth := nm3get.get_nth( p_theme_id);

  if l_nth.nth_feature_fk_column is not null and l_nth.nth_feature_table != l_nth.nth_table_name then

    xmlqry := 'select ttab.* from '||l_nth.nth_table_name||' ttab,'||l_nth.nth_feature_table||' ftab'||
              ' where ttab.'||l_nth.nth_pk_column||' = ftab.'||l_nth.nth_feature_fk_column||
              ' and ftab.'||l_nth.nth_feature_pk_column||' = '||to_char(p_ne_id)||
              ' and rownum = 1 ';

  else

    xmlqry := 'select * from '||l_nth.nth_table_name||' ttab'||
              ' where ttab.'||l_nth.nth_pk_column||' = '||to_char(p_ne_id)||
              ' and rownum = 1';

  end if;

--  l_type := 'N';
--  l_tab  := 'V_NM_'||l_ne.ne_nt_type||'_NT';
--  l_col  := 'NE_ID';
  l_set  := 'Theme_Element';
  l_row  := 'NE_ID';

  cre_xml_from_query( xmlqry
                    , retval
                    , p_rowsettag     => l_set
                    , p_rowtag        => l_row
--                    , p_rowidattrname => 'NUMBER'
                    );

  return retval;
end;

-----------------------------------------------------------------------------
--
END nm3xmlqry;
/

