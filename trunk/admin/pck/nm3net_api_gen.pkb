CREATE OR REPLACE PACKAGE BODY nm3net_api_gen AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3net_api_gen.pkb-arc   2.3   Oct 04 2011 15:43:44   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3net_api_gen.pkb  $
--       Date into PVCS   : $Date:   Oct 04 2011 15:43:44  $
--       Date fetched Out : $Modtime:   Oct 04 2011 15:43:18  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.7
---------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   network API generation package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '$Revision:   2.3  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3net_api_gen';
--
   g_tab_pkh         nm3type.tab_varchar32767;
   g_tab_pkb         nm3type.tab_varchar32767;
--
--   g_write_files_to_utl_file BOOLEAN := FALSE;
--
-----------------------------------------------------------------------------
--
FUNCTION get_api_package_name (p_nt_type nm_types.nt_type%TYPE
                              ) RETURN user_objects.object_name%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_sccs (p_rec_nt nm_types%ROWTYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE append_head (p_text VARCHAR2
                      ,p_nl   BOOLEAN DEFAULT TRUE
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_both (p_text VARCHAR2
                      ,p_nl   BOOLEAN DEFAULT TRUE
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE append_body (p_text VARCHAR2
                      ,p_nl   BOOLEAN DEFAULT TRUE
                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE seperator_head;
--
-----------------------------------------------------------------------------
--
PROCEDURE seperator_body;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_sccs (p_rec_nt nm_types%ROWTYPE) IS
BEGIN
   append_both('--');
   append_both('-----------------------------------------------------------------------------');
   append_both('--');
   append_both('--   SCCS Identifiers :-');
   append_both('--');
   append_both('--       sccsid           : @(#)nm3net_api_gen.pkb	1.7 11/27/02');
   append_both('--       Module Name      : nm3net_api_gen.pkb');
   append_both('--       Date into SCCS   : 02/11/27 14:41:29');
   append_both('--       Date fetched Out : 07/06/13 14:12:58');
   append_both('--       SCCS Version     : 1.7');
   append_both('--');
   append_both('--');
   append_both('--   Author : Jonathan Mills');
   append_both('--');
   append_both('--   NM3 Network element API generated package');
   append_both('--');
   append_both('--  #################');
   append_both('--  # DO NOT MODIFY #');
   append_both('--  #################');
   append_both('--');
   append_both('--  Network Type : '||p_rec_nt.nt_type);
   append_both('--               : '||p_rec_nt.nt_descr);
   append_both('--');
   append_both('--  Generated    : '||to_char(sysdate,nm3type.c_full_date_time_format));
   append_both('--  User         : '||USER);
   append_both('--');
   append_both('-----------------------------------------------------------------------------');
   append_both('--	Copyright (c) exor corporation ltd, 2002');
   append_both('-----------------------------------------------------------------------------');
   append_both('--');
END append_sccs;
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
PROCEDURE append_head (p_text VARCHAR2
                      ,p_nl   BOOLEAN DEFAULT TRUE
                      ) IS
BEGIN
   nm3ddl.append_tab_varchar (g_tab_pkh,p_text,p_nl);
END append_head;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_body (p_text VARCHAR2
                      ,p_nl   BOOLEAN DEFAULT TRUE
                      ) IS
BEGIN
   nm3ddl.append_tab_varchar (g_tab_pkb,p_text,p_nl);
END append_body;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_both (p_text VARCHAR2
                      ,p_nl   BOOLEAN DEFAULT TRUE
                      ) IS
BEGIN
   append_head (p_text,p_nl);
   append_body (p_text,p_nl);
END append_both;
--
-----------------------------------------------------------------------------
--
PROCEDURE seperator_head IS
BEGIN
   append_head('--');
   append_head('-----------------------------------------------------------------------------');
   append_head('--');
END seperator_head;
--
-----------------------------------------------------------------------------
--
PROCEDURE seperator_body IS
BEGIN
   append_body('--');
   append_body('-----------------------------------------------------------------------------');
   append_body('--');
END seperator_body;
--
-----------------------------------------------------------------------------
--
FUNCTION get_api_package_name (p_nt_type nm_types.nt_type%TYPE
                              ) RETURN user_objects.object_name%TYPE IS
BEGIN
--
   RETURN LOWER('NM3API_NET_'||p_nt_type);
--
END get_api_package_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_all IS
--
   CURSOR cs_nt IS
   SELECT nt_type
    FROM  nm_types
   ORDER BY nt_type;
--
   l_tab_nt nm3type.tab_varchar4;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_all');
--
   OPEN  cs_nt;
   FETCH cs_nt
    BULK COLLECT
    INTO l_tab_nt;
   CLOSE cs_nt;
--
   FOR i IN 1..l_tab_nt.COUNT
    LOOP
      build_one (p_nt_type => l_tab_nt(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'build_all');
--
END build_all;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_one (p_nt_type nm_types.nt_type%TYPE) IS
--
   l_package_name user_objects.object_name%TYPE;
   l_rec_nt       nm_types%ROWTYPE;
--
   CURSOR cs_ntc (c_nt_type nm_types.nt_type%TYPE) IS
   SELECT *
    FROM  nm_type_columns
   WHERE  ntc_nt_type   = c_nt_type
    AND   ntc_displayed = 'Y'
   ORDER BY ntc_seq_no;
--
   CURSOR cs_nti (c_nt_type nm_types.nt_type%TYPE) IS
   SELECT *
    FROM  nm_type_inclusion
   WHERE  nti_nw_child_type = c_nt_type
   ORDER BY nti_nw_parent_type;
--
   CURSOR cs_ngt (c_nt_type nm_types.nt_type%TYPE) IS
   SELECT ngt_group_type
    FROM  nm_group_types_all
   WHERE  ngt_nt_type = c_nt_type;
--
   TYPE tab_rec_ntc IS TABLE OF nm_type_columns%ROWTYPE   INDEX BY BINARY_INTEGER;
   TYPE tab_rec_nti IS TABLE OF nm_type_inclusion%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_rec_ntc tab_rec_ntc;
   l_rec_ntc     nm_type_columns%ROWTYPE;
   l_rec_nti     nm_type_inclusion%ROWTYPE;
   l_tab_rec_nti tab_rec_nti;
--
   l_tab_ngt_group_type nm3type.tab_varchar4;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_one');
--
   g_tab_pkh.DELETE;
   g_tab_pkb.DELETE;
--
   l_rec_nt       := nm3get.get_nt (pi_nt_type => p_nt_type);
--
   FOR cs_rec IN cs_ntc (p_nt_type)
    LOOP
      l_tab_rec_ntc (cs_ntc%ROWCOUNT) := cs_rec;
   END LOOP;
--
   FOR cs_rec IN cs_nti (p_nt_type)
    LOOP
      l_tab_rec_nti (cs_nti%ROWCOUNT) := cs_rec;
   END LOOP;
--
   OPEN  cs_ngt (p_nt_type);
   FETCH cs_ngt
    BULK COLLECT
    INTO l_tab_ngt_group_type;
   CLOSE cs_ngt;
--
   l_package_name := get_api_package_name (p_nt_type);
--
   append_both('CREATE OR REPLACE PACKAGE ',FALSE);
   append_body('BODY ',FALSE);
   append_both(Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_package_name||' IS',FALSE);
   append_sccs(l_rec_nt);
--
   append_head('--<PROC NAME="get_version">');
   append_head('-- This function returns the current SCCS version');
   append_head('FUNCTION get_version RETURN VARCHAR2;');
   append_head('--</PROC>');
   seperator_head;
   append_head('--<PROC NAME="get_body_version">');
   append_head('-- This function returns the current SCCS version of the package body');
   append_head('FUNCTION get_body_version RETURN VARCHAR2;');
   append_head('--</PROC>');
--
   append_body('   g_package_name CONSTANT VARCHAR2(30) := '||nm3flx.string(l_package_name)||';');
   append_body('   c_nt_type      CONSTANT nm_types.nt_type%TYPE := '||nm3flx.string(p_nt_type)||';');
--
   seperator_body;
   append_body('FUNCTION get_version RETURN VARCHAR2 IS');
   append_body('BEGIN');
   append_body('  RETURN '||g_package_name||'.get_version;');
   append_body('END get_version;');
   seperator_body;
   append_body('FUNCTION get_body_version RETURN VARCHAR2 IS');
   append_body('BEGIN');
   append_body('  RETURN '||g_package_name||'.get_body_version;');
   append_body('END get_body_version;');
--
-- ## GET_NE_ID
--
   seperator_body;
   seperator_head;
   append_head('--<PROC NAME="get_ne_id">');
   append_head('-- This function returns the NE_ID for the NE_UNIQUE (existing on a specified date)');
   append_head('--  of type "'||p_nt_type||'"');
   append_head('--');
   append_both('FUNCTION get_ne_id (pi_ne_unique      nm_elements.ne_unique%TYPE');
   append_both('                   ,pi_effective_date DATE DEFAULT To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append_both('                   ) RETURN nm_elements.ne_id%TYPE');
   append_head(';',FALSE);
   append_body(' IS',FALSE);
   append_body('--');
   append_body('   c_init_eff_date CONSTANT DATE := To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'');');
   append_body('--');
   append_body('   l_retval nm_elements.ne_id%TYPE;');
   append_body('--');
   append_body('BEGIN');
   append_body('--');
   append_body('   nm_debug.proc_start(g_package_name,'||nm3flx.string('get_ne_id')||');');
   append_body('--');
   append_body('   nm3user.set_effective_date (pi_effective_date);');
   append_body('--');
   append_body('   l_retval := nm3net.get_ne_id (p_ne_unique  => pi_ne_unique');
   append_body('                                ,p_ne_nt_type => c_nt_type');
   append_body('                                );');
   append_body('--');
   append_body('   nm3user.set_effective_date (c_init_eff_date);');
   append_body('--');
   append_body('   nm_debug.proc_end(g_package_name,'||nm3flx.string('get_ne_id')||');');
   append_body('--');
   append_body('   RETURN l_retval;');
   append_body('--');
   append_body('EXCEPTION');
   append_body('   WHEN others');
   append_body('    THEN');
   append_body('      nm3user.set_effective_date (c_init_eff_date);');
   append_body('      RAISE;');
   append_body('END get_ne_id;');
   append_head('--</PROC>');
--
-- ## CREATE_ELEMENT
--
   seperator_body;
   seperator_head;
   append_head('--<PROC NAME="create_element">');
   append_head('-- This procedure will create an element of type "'||p_nt_type||'"');
   append_head('--');
   append_both('PROCEDURE create_element (po_ne_id                          OUT nm_elements.ne_id%TYPE');
   IF l_rec_nt.nt_pop_unique = 'N'
    THEN
      append_both('                         ,pi_ne_unique                   IN     nm_elements.ne_unique%TYPE');
   ELSE
      append_both('                         ,po_ne_unique                      OUT nm_elements.ne_unique%TYPE');
   END IF;
   append_both('                         ,pi_start_date                  IN     nm_elements.ne_start_date%TYPE DEFAULT To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append_both('                         ,pi_ne_admin_unit               IN     nm_elements.ne_admin_unit%TYPE');
   IF l_rec_nt.nt_node_type IS NOT NULL
    THEN
      append_both('                         ,pi_start_node                  IN     nm_elements.ne_no_start%TYPE');
      append_both('                         ,pi_end_node                    IN     nm_elements.ne_no_end%TYPE');
   END IF;
   append_both('                         ,pi_ne_descr                    IN     nm_elements.ne_descr%TYPE');
   IF l_rec_nt.nt_datum      = 'Y'
    THEN
      append_both('                         ,pi_ne_length                   IN     nm_elements.ne_length%TYPE');
   ELSIF l_tab_ngt_group_type.COUNT > 1
    THEN
      append_both('                         ,pi_ne_gty_group_type           IN     nm_elements.ne_gty_group_type%TYPE');
   END IF;
   IF l_tab_rec_ntc.COUNT > 0
    THEN
      append_both('                         --<FLEXIBLE ATTRIBUTES>');
      FOR i IN 1..l_tab_rec_ntc.COUNT
       LOOP
         l_rec_ntc := l_tab_rec_ntc(i);
         append_both('                         ,'||RPAD('pf_'||LOWER(l_rec_ntc.ntc_column_name),30)||' IN     '||RPAD(l_rec_ntc.ntc_column_type,8));
         IF l_rec_ntc.ntc_mandatory = 'N'
          THEN
            append_both (' DEFAULT NULL',FALSE);
         END IF;
         append_both(' -- '||l_rec_ntc.ntc_prompt,FALSE);
      END LOOP;
      append_both('                         --</FLEXIBLE ATTRIBUTES>');
   END IF;
   IF l_tab_rec_nti.COUNT > 0
    THEN
      append_both('                         --<TYPE INCLUSION MEMBER DETAILS>');
      FOR i IN 1..l_tab_rec_nti.COUNT
       LOOP
         l_rec_nti := l_tab_rec_nti(i);
         append_both('                         --   <'||l_rec_nti.nti_nw_parent_type||' - '||nm3net.get_nt_descr(l_rec_nti.nti_nw_parent_type)||'>');
         append_both('                         ,'||RPAD('pi_specify_details_'||LOWER(l_rec_nti.nti_nw_parent_type),30)||' IN     BOOLEAN DEFAULT FALSE');
         append_both('                         ,'||RPAD('pi_nm_seq_no_'||LOWER(l_rec_nti.nti_nw_parent_type),30)||' IN     NUMBER  DEFAULT NULL');
         append_both('                         ,'||RPAD('pi_nm_seg_no_'||LOWER(l_rec_nti.nti_nw_parent_type),30)||' IN     NUMBER  DEFAULT NULL');
         IF nm3net.is_nt_linear (l_rec_nti.nti_nw_parent_type) = 'Y'
          THEN
            append_both('                         ,'||RPAD('pi_nm_slk_'||LOWER(l_rec_nti.nti_nw_parent_type),30)||' IN     NUMBER  DEFAULT NULL');
            append_both('                         ,'||RPAD('pi_nm_true_'||LOWER(l_rec_nti.nti_nw_parent_type),30)||' IN     NUMBER  DEFAULT NULL');
         END IF;
         append_both('                         ,'||RPAD('pi_nm_cardinality_'||LOWER(l_rec_nti.nti_nw_parent_type),30)||' IN     NUMBER  DEFAULT 1');
         append_both('                         --   </'||l_rec_nti.nti_nw_parent_type||'>');
      END LOOP;
      append_both('                         --</TYPE INCLUSION MEMBER DETAILS>');
   END IF;
   append_both('                         )');
   append_head(';',FALSE);
   append_body(' IS',FALSE);
   append_body('--');
   append_body('   c_init_eff_date CONSTANT DATE := To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'');');
   append_body('--');
   append_body('   l_rec_ne nm_elements_all%ROWTYPE;');
   append_body('--');
   append_body('BEGIN');
   append_body('--');
   append_body('   nm_debug.proc_start(g_package_name,'||nm3flx.string('create_element')||');');
   append_body('--');
   append_body('   nm3user.set_effective_date (pi_start_date);');
   append_body('--');
   append_body('   l_rec_ne.ne_id                          := nm3net.get_next_ne_id;');
   append_body('   l_rec_ne.ne_start_date                  := pi_start_date;');
   IF l_rec_nt.nt_pop_unique = 'N'
    THEN
      append_body('   l_rec_ne.ne_unique                      := pi_ne_unique;');
   END IF;
   IF l_rec_nt.nt_node_type IS NOT NULL
    THEN
      append_body('   l_rec_ne.ne_no_start                    := pi_start_node;');
      append_body('   l_rec_ne.ne_no_end                      := pi_end_node;');
   END IF;
   append_body('   l_rec_ne.ne_nt_type                     := c_nt_type;');
   append_body('   l_rec_ne.ne_descr                       := pi_ne_descr;');
   IF l_rec_nt.nt_datum      = 'Y'
    THEN
      append_body('   l_rec_ne.ne_length                      := pi_ne_length;');
   ELSIF l_tab_ngt_group_type.COUNT = 1
    THEN
      append_body('   l_rec_ne.ne_gty_group_type              := '||nm3flx.string(l_tab_ngt_group_type(1))||';');
   ELSIF l_tab_ngt_group_type.COUNT > 1
    THEN
      append_body('   l_rec_ne.ne_gty_group_type              := pi_ne_gty_group_type;');
   END IF;
   append_body('   l_rec_ne.ne_admin_unit                  := pi_ne_admin_unit;');
   IF l_rec_nt.nt_datum = 'Y'
    THEN
      append_body('   l_rec_ne.ne_type                        := nm3extent.c_roi_section;');
   ELSE
      append_body('--');
      append_body('   IF nm3get.get_ngt(pi_ngt_group_type => l_rec_ne.ne_gty_group_type).ngt_sub_group_allowed = '||nm3flx.string('Y'));
      append_body('    THEN');
      append_body('      l_rec_ne.ne_type                     := nm3extent.c_roi_gog;');
      append_body('   ELSE');
      append_body('      l_rec_ne.ne_type                     := nm3extent.c_roi_gos;');
      append_body('   END IF;');
   END IF;
   IF l_tab_rec_ntc.COUNT > 0
    THEN
      append_body('--');
      FOR i IN 1..l_tab_rec_ntc.COUNT
       LOOP
         l_rec_ntc := l_tab_rec_ntc(i);
         append_body('   l_rec_ne.'||RPAD(LOWER(l_rec_ntc.ntc_column_name),30)||' := '||SUBSTR('pf_'||LOWER(l_rec_ntc.ntc_column_name),1,30)||';');
      END LOOP;
   END IF;
   append_body('--');
   append_body('   nm3net.insert_any_element (p_rec_ne         => l_rec_ne');
   append_body('                             ,p_nm_cardinality => Null');
   append_body('                             ,p_auto_include   => TRUE');
   append_body('                             );');
   --
   FOR i IN 1..l_tab_rec_nti.COUNT
    LOOP
      l_rec_nti := l_tab_rec_nti(i);
      append_body('--');
      append_body('   IF pi_specify_details_'||LOWER(l_rec_nti.nti_nw_parent_type));
      append_body('    THEN');
      append_body('      DECLARE');
      append_body('         CURSOR cs_parent IS');
      append_body('         SELECT ROWID');
      append_body('          FROM  nm_members');
      append_body('         WHERE  nm_ne_id_in = (SELECT ne_id');
      append_body('                                FROM  nm_elements');
      append_body('                               WHERE  '||LOWER(l_rec_nti.nti_parent_column)||' = l_rec_ne.'||LOWER(l_rec_nti.nti_child_column));
      append_body('                              )');
      append_body('          AND   nm_ne_id_of = l_rec_ne.ne_id');
      append_body('         FOR UPDATE OF nm_seq_no NOWAIT;');
      append_body('         l_nm_rowid ROWID;');
      append_body('         l_found    BOOLEAN;');
      append_body('      BEGIN');
      append_body('         OPEN  cs_parent;');
      append_body('         FETCH cs_parent INTO l_nm_rowid;');
      append_body('         l_found := cs_parent%FOUND;');
      append_body('         CLOSE cs_parent;');
      append_body('         IF NOT l_found');
      append_body('          THEN');
      append_body('            hig.raise_ner (pi_appl               => nm3type.c_hig');
      append_body('                          ,pi_id                 => 67');
      append_body('                          ,pi_supplementary_info => '||nm3flx.string('Parent record ("'||l_rec_nti.nti_nw_parent_type||'") for ')||'||l_rec_ne.ne_unique||'||nm3flx.string(' WHERE child.'||l_rec_nti.nti_child_column||' = parent.'||l_rec_nti.nti_parent_column));
      append_body('                          );');
      append_body('         END IF;');
      append_body('         UPDATE nm_members_all');
      append_body('          SET   nm_seq_no      = pi_nm_seq_no_'||LOWER(l_rec_nti.nti_nw_parent_type));
      append_body('               ,nm_seg_no      = pi_nm_seg_no_'||LOWER(l_rec_nti.nti_nw_parent_type));
      IF nm3net.is_nt_linear (l_rec_nti.nti_nw_parent_type) = 'Y'
       THEN
         append_body('               ,nm_slk         = pi_nm_slk_'||LOWER(l_rec_nti.nti_nw_parent_type));
         append_body('               ,nm_true        = pi_nm_true_'||LOWER(l_rec_nti.nti_nw_parent_type));
      END IF;
      append_body('               ,nm_cardinality = pi_nm_cardinality_'||LOWER(l_rec_nti.nti_nw_parent_type));
      append_body('         WHERE  ROWID          = l_nm_rowid;');
      append_body('      END;');
      append_body('   END IF;');
   END LOOP;
   append_body('--');
   --
   append_body('   po_ne_id     := l_rec_ne.ne_id;');
   IF l_rec_nt.nt_pop_unique = 'Y'
    THEN
      append_body('   po_ne_unique := l_rec_ne.ne_unique;');
   END IF;
   append_body('--');
   append_body('   nm3user.set_effective_date (c_init_eff_date);');
   append_body('--');
   append_body('   nm_debug.proc_end(g_package_name,'||nm3flx.string('create_element')||');');
   append_body('--');
   append_body('END create_element;');
   append_head('--</PROC>');
--
   seperator_head;
   seperator_body;
   append_both('END '||l_package_name||';');
----
--   IF g_write_files_to_utl_file
--    THEN
--      nm3file.write_file (filename       => l_package_name||'.pkh'
--                         ,max_linesize   => 32767
--                         ,all_lines      => g_tab_pkh
--                         );
--      nm3file.write_file (filename       => l_package_name||'.pkb'
--                         ,max_linesize   => 32767
--                         ,all_lines      => g_tab_pkb
--                         );
--   END IF;
--
   nm3ddl.create_object_and_syns (UPPER(l_package_name)
                                 ,g_tab_pkh
                                 );
   nm3ddl.execute_tab_varchar    (g_tab_pkb);
--
   nm_debug.proc_end(g_package_name,'build_one');
--
EXCEPTION
--
   WHEN others
    THEN
      dbms_output.put_line (l_package_name);
      RAISE;
--
END build_one;
--
-----------------------------------------------------------------------------
--
END nm3net_api_gen;
/
