CREATE OR REPLACE PACKAGE BODY xky_inv_views 
AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xky_inv_views.pkb	1.1 06/03/05
--       Module Name      : xky_inv_views.pkb
--       Date into SCCS   : 05/06/03 09:47:50
--       Date fetched Out : 07/06/13 14:14:05
--       SCCS Version     : 1.1
--
--
--   Author : iturnbull
--
--   xky_inv_views body
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
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '"@(#)xky_inv_views.pkb	1.1 06/03/05"';

  g_package_name CONSTANT VARCHAR2(30) := 'xky_inv_views';
  
  g_string VARCHAR2(2000);
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
PROCEDURE append(pi_text VARCHAR2
                ,pi_crlf VARCHAR2 DEFAULT 'Y')
                
IS
BEGIN
   g_string := g_string || pi_text;
   IF pi_crlf = 'Y'
    THEN 
      g_string := g_string || CHR(10);
   END IF;
END append;
--
-----------------------------------------------------------------------------
--
FUNCTION get_view_name (pi_nit_inv_type nm_inv_types.nit_inv_type%TYPE) 
RETURN VARCHAR2
IS
BEGIN    
   nm_debug.proc_start(g_package_name,'get_view_name');
   
   RETURN 'XKY_'|| pi_nit_inv_type ||'_ON_ROUTE';
   
   nm_debug.proc_end(g_package_name,'get_view_name');
END get_view_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_on_route_view(pi_nit_inv_type nm_inv_types.nit_inv_type%TYPE) 
IS
   l_view_name VARCHAR2(100);
BEGIN
   nm_debug.proc_start(g_package_name,'create_inv_on_route_view');

   l_view_name := get_view_name (pi_nit_inv_type => pi_nit_inv_type);
   
   g_string := NULL;
   
   append ( 'CREATE OR REPLACE FORCE VIEW');
   append ( l_view_name);
   append ( 'AS');
   append ( 'SELECT inv_type.*');
   append ( '     , nm3net.get_ne_unique (pl_ne_id) lrm');
   append ( '     , pl.pl_start start_offset');
   append ( '        , pl.pl_end end_offset');
   append ( '     FROM v_nm_'||pi_nit_inv_type||' inv_type');
   append ( ', TABLE (nm3pla.get_connected_chunks (iit_ne_id, ''RT'').npa_placement_array) pl');
   
   nm_debug.debug_on;
   nm_debug.delete_debug( TRUE );
   nm_debug.DEBUG( g_string);
   
   EXECUTE IMMEDIATE g_string;
   
   nm_debug.proc_end(g_package_name,'create_inv_on_route_view');
    
END create_inv_on_route_view;
--
-----------------------------------------------------------------------------
--
PROCEDURE cre_view_and_synonym(pi_nit_inv_type nm_inv_types.nit_inv_type%TYPE
                              ,pi_cre_synonym VARCHAR2 DEFAULT 'Y')
IS
   l_view_name VARCHAR2(100);
BEGIN
   nm_debug.proc_start(g_package_name,'cre_view_and_synonym');
   
   l_view_name := get_view_name (pi_nit_inv_type => pi_nit_inv_type);

   create_inv_on_route_view( pi_nit_inv_type => pi_nit_inv_type );
   
   IF pi_cre_synonym = 'Y'
    THEN
      nm3ddl.create_synonym_for_object( p_object_name => l_view_name);
   END IF;
   
   nm_debug.proc_end(g_package_name,'cre_view_and_synonym');
END cre_view_and_synonym;
--
-----------------------------------------------------------------------------
--
PROCEDURE cre_all_views(pi_cre_views VARCHAR2
                       ,pi_cre_synonyms VARCHAR2 DEFAULT 'Y')
IS
   CURSOR c_inv_types 
   IS
   SELECT nit_inv_type
   FROM nm_inv_types;
   
   l_view_name VARCHAR2(100);
BEGIN
   nm_debug.proc_start(g_package_name,'cre_all_views');
   
   IF pi_cre_views = 'Y' 
    THEN 
      FOR c_inv_type_rec IN c_inv_types
       LOOP
         create_inv_on_route_view( pi_nit_inv_type => c_inv_type_rec.nit_inv_type );
         IF pi_cre_synonyms = 'Y'
          THEN
             l_view_name := get_view_name (pi_nit_inv_type => c_inv_type_rec.nit_inv_type);
             
            nm3ddl.create_synonym_for_object( p_object_name => l_view_name);
         END IF;
      END LOOP;
   END IF;
      
   nm_debug.proc_end(g_package_name,'cre_all_views');
END cre_all_views;
--
-----------------------------------------------------------------------------
--

END xky_inv_views;
/
