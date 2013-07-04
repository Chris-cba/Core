CREATE OR REPLACE PACKAGE BODY nm3inv_api_gen AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_api_gen.pkb-arc   2.3   Jul 04 2013 16:04:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_api_gen.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:42:28  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.15
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 Inventory API package generation package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3inv_api_gen';
--
   g_tab_pkh         nm3type.tab_varchar32767;
   g_tab_pkb         nm3type.tab_varchar32767;
--
--   g_write_files_to_utl_file BOOLEAN := FALSE;
--
-----------------------------------------------------------------------------
--
FUNCTION get_api_package_name (p_inv_type nm_inv_types.nit_inv_type%TYPE
                              ) RETURN user_objects.object_name%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_sccs (p_rec_nit nm_inv_types%ROWTYPE);
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
PROCEDURE do_basic_ins_parameters (p_tab_rec_ita nm3inv.tab_nita
                                  ,p_function    BOOLEAN DEFAULT FALSE
                                  ,p_xsp_allowed BOOLEAN
                                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE move_flex_to_rec (p_tab_rec_ita nm3inv.tab_nita);
--
-----------------------------------------------------------------------------
--
PROCEDURE move_fixed_to_rec (p_xsp BOOLEAN);
--
-----------------------------------------------------------------------------
--
PROCEDURE move_back_and_end (p_function    BOOLEAN DEFAULT FALSE);
--
-----------------------------------------------------------------------------
--
PROCEDURE end_of_parameters (p_function    BOOLEAN DEFAULT FALSE);
--
-----------------------------------------------------------------------------
--
PROCEDURE location_comment_on;
--
-----------------------------------------------------------------------------
--
PROCEDURE location_comment_off;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_sccs (p_rec_nit nm_inv_types%ROWTYPE) IS
BEGIN
   append_both('--');
   append_both('-----------------------------------------------------------------------------');
   append_both('--');
   append_both('--   SCCS Identifiers :-');
   append_both('--');
   append_both('--       sccsid           : @(#)nm3inv_api_gen.pkb	1.15 03/08/05');
   append_both('--       Module Name      : nm3inv_api_gen.pkb');
   append_both('--       Date into SCCS   : 05/03/08 05:20:49');
   append_both('--       Date fetched Out : 07/06/13 14:11:55');
   append_both('--       SCCS Version     : 1.15');
   append_both('--');
   append_both('--');
   append_both('--   Author : Jonathan Mills');
   append_both('--');
   append_both('--   NM3 Inventory API generated package');
   append_both('--');
   append_both('--  #################');
   append_both('--  # DO NOT MODIFY #');
   append_both('--  #################');
   append_both('--');
   append_both('--  Inventory Type : '||p_rec_nit.nit_inv_type);
   append_both('--                 : '||p_rec_nit.nit_descr);
   append_both('--');
   append_both('--   Generated : '||to_char(sysdate,nm3type.c_full_date_time_format));
   append_both('--   User      : '||USER);
   append_both('--');
   append_both('-----------------------------------------------------------------------------');
   append_both('--	Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
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
PROCEDURE location_comment_on IS
BEGIN
   append_both('               -- <LOCATION DETAILS>');
END location_comment_on;
--
-----------------------------------------------------------------------------
--
PROCEDURE location_comment_off IS
BEGIN
   append_both('               -- </LOCATION DETAILS>');
END location_comment_off;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_basic_ins_parameters (p_tab_rec_ita nm3inv.tab_nita
                                  ,p_function    BOOLEAN DEFAULT FALSE
                                  ,p_xsp_allowed BOOLEAN
                                  ) IS
   l_start VARCHAR2(40);
   l_line  VARCHAR2(200);
   l_rec_ita nm_inv_type_attribs%ROWTYPE;
   PROCEDURE write_it (p_text VARCHAR2) IS
   BEGIN
      append_both(p_text);
      l_start := '              ,';
   END write_it;
BEGIN
   IF p_function
    THEN
     l_start := 'FUNCTION  ins (';
   ELSE
     l_start := 'PROCEDURE ins (';
   END IF;
   seperator_head;
   seperator_body;
   IF NOT p_function
    THEN
      write_it(l_start||RPAD('p_iit_ne_id',31,' ')||'   OUT nm_inv_items_all.iit_ne_id%TYPE');
   END IF;
   write_it(l_start||RPAD('p_effective_date',31,' ')||'IN     nm_inv_items_all.iit_start_date%TYPE DEFAULT To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   write_it(l_start||RPAD('p_admin_unit',31,' ')||'IN     nm_inv_items_all.iit_admin_unit%TYPE');
   IF p_xsp_allowed
    THEN
      write_it(l_start||RPAD('p_x_sect',31,' ')||'IN     nm_inv_items_all.iit_x_sect%TYPE');
   END IF;
   write_it(l_start||RPAD('p_descr',31,' ')||'IN     nm_inv_items_all.iit_descr%TYPE DEFAULT NULL');
   write_it(l_start||RPAD('p_note',31,' ')||'IN     nm_inv_items_all.iit_note%TYPE DEFAULT NULL');
   write_it('               -- <FLEXIBLE ATTRIBUTES>');
   FOR i IN 1..p_tab_rec_ita.COUNT
    LOOP
      l_rec_ita := p_tab_rec_ita (i);
      l_line := SUBSTR('pf_'||LOWER(l_rec_ita.ita_view_col_name),1,30);
      l_line := RPAD(l_line,31,' ');
      l_line := l_line||'IN     nm_inv_items_all.'||LOWER(l_rec_ita.ita_attrib_name)||'%TYPE';
      IF l_rec_ita.ita_mandatory_yn = 'N'
       THEN
         l_line := l_line||' DEFAULT NULL';
      END IF;
      write_it (l_start||l_line);
   END LOOP;
   write_it('               -- </FLEXIBLE ATTRIBUTES>');
END do_basic_ins_parameters;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_one (p_inv_type nm_inv_types.nit_inv_type%TYPE) IS
--
   CURSOR cs_nin (c_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   SELECT 1
    FROM  nm_inv_nw
   WHERE  nin_nit_inv_code = c_inv_type;
--
   CURSOR cs_itg (c_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   SELECT 1
    FROM  nm_inv_type_groupings
   WHERE  itg_inv_type = c_inv_type
    AND   itg_relation = nm3invval.c_at_relation;
--
   l_package_name user_objects.object_name%TYPE;
--
   l_rec_nit      nm_inv_types%ROWTYPE;
   l_tab_rec_ita  nm3inv.tab_nita;
   l_rec_ita      nm_inv_type_attribs%ROWTYPE;
--
   not_building  EXCEPTION;
--
   l_continuous   BOOLEAN;
   l_nin_exists   BOOLEAN;
   l_is_child_at  BOOLEAN;
   l_dummy        PLS_INTEGER;
   l_line  VARCHAR2(200);
   l_start VARCHAR2(200);
--
   l_function     BOOLEAN;
--
   l_xsp_allowed  BOOLEAN;
   l_rowtype_name VARCHAR2(30);
   l_rowtype_type VARCHAR2(80);
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'build_one');
--
   IF NOT g_create_api_inv_packs
    THEN
      RAISE not_building;
   END IF;
--
   g_tab_pkh.DELETE;
   g_tab_pkb.DELETE;
--
   l_rec_nit := nm3inv.get_inv_type (p_inv_type);
--
   l_xsp_allowed := l_rec_nit.nit_x_sect_allow_flag='Y';
--
   IF l_rec_nit.nit_table_name IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 285
                    ,pi_supplementary_info => p_inv_type
                    );
   END IF;
--
   OPEN  cs_nin (p_inv_type);
   FETCH cs_nin INTO l_dummy;
   l_nin_exists := cs_nin%FOUND;
   CLOSE cs_nin;
--
   OPEN  cs_itg (p_inv_type);
   FETCH cs_itg INTO l_dummy;
   l_is_child_at := cs_itg%FOUND;
   CLOSE cs_itg;
--
   l_continuous := l_rec_nit.nit_pnt_or_cont = 'C';
--
   l_tab_rec_ita := nm3inv.get_tab_ita (p_inv_type);
--
   l_package_name := get_api_package_name (p_inv_type);
   l_rowtype_name := 'p_rec_'||lower(p_inv_type);
   l_rowtype_type := nm3inv_view.derive_inv_type_view_name(p_inv_type);
--
   append_both('CREATE OR REPLACE PACKAGE ',FALSE);
   append_body('BODY ',FALSE);
   append_both(Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_package_name||' IS',FALSE);
   append_sccs(l_rec_nit);
--
   append_head('--<PROC NAME="get_version">');
   append_head('FUNCTION get_version RETURN VARCHAR2;');
   append_head('--</PROC>');
   seperator_head;
   append_head('--<PROC NAME="get_body_version">');
   append_head('FUNCTION get_body_version RETURN VARCHAR2;');
   append_head('--</PROC>');
   seperator_head;
--
   append_body('   g_package_name CONSTANT VARCHAR2(30) := '||nm3flx.string(l_package_name)||';');
   append_body('   c_inv_type     CONSTANT nm_inv_types.nit_inv_type%TYPE := '||nm3flx.string(p_inv_type)||';');
   --
   -- ## Check Type private function
   --
   seperator_body;
   append_body('PROCEDURE check_correct_inv_type (p_rowid ROWID) IS');
   append_body('   CURSOR cs_iit IS');
   append_body('   SELECT iit_inv_type');
   append_body('    FROM  nm_inv_items_all');
   append_body('   WHERE  ROWID = p_rowid;');
   append_body('   l_inv_type nm_inv_items.iit_inv_type%TYPE;');
   append_body('   l_found    BOOLEAN;');
   append_body('BEGIN');
   append_body('   OPEN  cs_iit;');
   append_body('   FETCH cs_iit INTO l_inv_type;');
   append_body('   l_found := cs_iit%FOUND;');
   append_body('   CLOSE cs_iit;');
   append_body('   IF NOT l_found');
   append_body('    OR l_inv_type != c_inv_type');
   append_body('    THEN');
   append_body('      hig.raise_ner(pi_appl               => nm3type.c_hig');
   append_body('                   ,pi_id                 => 110');
   append_body('                   ,pi_supplementary_info => l_inv_type||'||nm3flx.string('!=')||'||c_inv_type');
   append_body('                   );');
   append_body('   END IF;');
   append_body('END check_correct_inv_type;');
   --
   seperator_body;
   append_body('FUNCTION get_version RETURN VARCHAR2 IS');
   append_body('BEGIN');
   append_body('  RETURN nm3inv_api_gen.get_version;');
   append_body('END get_version;');
   seperator_body;
   append_body('FUNCTION get_body_version RETURN VARCHAR2 IS');
   append_body('BEGIN');
   append_body('  RETURN nm3inv_api_gen.get_body_version;');
   append_body('END get_body_version;');
   --
   --
   --
   --   ########################################################
   --
   --    GET_IIT_NE_ID Function
   --
   --   ########################################################
   --
   seperator_head;
   seperator_body;
   append_head('--<PROC NAME="get_iit_ne_id">');
   append_head('-- This function returns the internal identifier (IIT_NE_ID) of an inventory');
   append_head('--  record as identified by the IIT_PRIMARY_KEY on a given effective date');
   append_head('--');
   append_both('FUNCTION get_iit_ne_id (p_iit_primary_key IN nm_inv_items.iit_primary_key%TYPE');
   append_both('                       ,p_effective_date  IN DATE DEFAULT To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
   append_both('                       ) RETURN nm_inv_items.iit_ne_id%TYPE');
   append_head(';',FALSE);
   append_body(' IS',FALSE);
   append_body('BEGIN');
   append_body('   RETURN nm3api_inv.get_iit_ne_id(p_iit_primary_key,c_inv_type,p_effective_date);');
   append_body('END get_iit_ne_id;');
   append_head('--</PROC>');
   --
   --
   IF l_tab_rec_ita.COUNT > 0
    THEN
      --
      --   ########################################################
      --
      --    Datetrack Attribute procedures
      --
      --   ########################################################
      --
      seperator_head;
      seperator_body;
      append_head('--<PROC NAME="date_track_upd_attr">');
      append_head('-- This procedure updates the flexible attributes on the');
      append_head('--  specified NM_INV_ITEMS record which exists on the given effective date');
      append_head('-- This maintains history (i.e. end-date at an effective date and create a new item');
      append_head('--  that date onwards');
      append_head('--');
      append_both('PROCEDURE date_track_upd_attr ('||RPAD('p_iit_ne_id',31)||'IN OUT nm_inv_items_all.iit_ne_id%TYPE');
      append_both('                              ,'||RPAD('p_effective_date',31)||'IN     DATE DEFAULT To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
      append_both('                              -- <FLEXIBLE ATTRIBUTES>');
      FOR i IN 1..l_tab_rec_ita.COUNT
       LOOP
         l_start := '                              ,';
         l_rec_ita := l_tab_rec_ita (i);
         l_line := SUBSTR('pf_'||LOWER(l_rec_ita.ita_view_col_name),1,30);
         l_line := RPAD(l_line,31,' ');
         l_line := l_line||'IN     nm_inv_items_all.'||LOWER(l_rec_ita.ita_attrib_name)||'%TYPE';
         IF l_rec_ita.ita_mandatory_yn = 'N'
          THEN
            l_line := l_line||' DEFAULT NULL';
         END IF;
         append_both (l_start||l_line);
      END LOOP;
      append_both('                              -- </FLEXIBLE ATTRIBUTES>');
      append_both('                              )');
      append_head(';',FALSE);
      append_body(' IS',FALSE);
      append_body('   c_eff_date CONSTANT DATE := To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'');');
      append_body('   l_rec_iit           nm_inv_items%ROWTYPE;');
      append_body('   l_rowid             ROWID;');
      append_body('BEGIN');
      append_body('--');
      append_body('   nm_debug.proc_start(g_package_name,'||nm3flx.string('date_track_upd_attr')||');');
      append_body('--');
      append_body('   nm3user.set_effective_date (p_effective_date);');
      append_body('--');
      append_body('   l_rowid := nm3lock_gen.lock_iit (pi_iit_ne_id => p_iit_ne_id);');
      append_body('   check_correct_inv_type (l_rowid);');
      append_body('--');
      append_body('   l_rec_iit := nm3get.get_iit (pi_iit_ne_id => p_iit_ne_id);');
      append_body('--');
      append_body('   l_rec_iit.iit_ne_id       := Null;');
      append_body('   l_rec_iit.iit_start_date  := p_effective_date;');
      append_body('   l_rec_iit.iit_primary_key := Null;');
      move_flex_to_rec (l_tab_rec_ita);
      append_body('   nm3inv_update.date_track_update_item (pi_iit_ne_id_old => p_iit_ne_id');
      append_body('                                        ,pio_rec_iit      => l_rec_iit');
      append_body('                                        );');
      append_body('--');
      append_body('   p_iit_ne_id := l_rec_iit.iit_ne_id;');
      append_body('--');
      append_body('   nm3user.set_effective_date (c_eff_date);');
      append_body('--');
      append_body('   nm_debug.proc_end(g_package_name,'||nm3flx.string('date_track_upd_attr')||');');
      append_body('--');
      append_body('EXCEPTION');
      append_body('   WHEN others');
      append_body('    THEN');
      append_body('      nm3user.set_effective_date (c_eff_date);');
      append_body('      RAISE;');
      append_body('END date_track_upd_attr;');
      append_head('--</PROC>');
      --
      --
      --   ########################################################
      --
      --    Update Attribute procedures
      --
      --   ########################################################
      --
      seperator_head;
      seperator_body;
      append_head('--<PROC NAME="upd_attr">');
      append_head('-- This procedure updates the flexible attributes on the');
      append_head('--  specified NM_INV_ITEMS record which exists on the given effective date');
      append_head('-- This DOES NOT maintain history (i.e. end-date at an effective date and create a new item');
      append_head('--  that date onwards');
      append_head('--');
      append_both('PROCEDURE upd_attr ('||RPAD('p_iit_ne_id',31)||'IN     nm_inv_items_all.iit_ne_id%TYPE');
      append_both('                   ,'||RPAD('p_effective_date',31)||'IN     DATE DEFAULT To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')');
      append_both('                   -- <FLEXIBLE ATTRIBUTES>');
      FOR i IN 1..l_tab_rec_ita.COUNT
       LOOP
         l_start := '                   ,';
         l_rec_ita := l_tab_rec_ita (i);
         l_line := SUBSTR('pf_'||LOWER(l_rec_ita.ita_view_col_name),1,30);
         l_line := RPAD(l_line,31,' ');
         l_line := l_line||'IN     nm_inv_items_all.'||LOWER(l_rec_ita.ita_attrib_name)||'%TYPE';
         IF l_rec_ita.ita_mandatory_yn = 'N'
          THEN
            l_line := l_line||' DEFAULT NULL';
         END IF;
         append_both (l_start||l_line);
      END LOOP;
      append_both('                   -- </FLEXIBLE ATTRIBUTES>');
      append_both('                   )');
      append_head(';',FALSE);
      append_body(' IS',FALSE);
      append_body('   c_eff_date CONSTANT DATE := To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'');');
      append_body('   l_rowid ROWID;');
      append_body('BEGIN');
      append_body('--');
      append_body('   nm_debug.proc_start(g_package_name,'||nm3flx.string('upd_attr')||');');
      append_body('--');
      append_body('   BEGIN');
      append_body('--');
      append_body('      nm3user.set_effective_date (p_effective_date);');
      append_body('--');
      append_body('      l_rowid := nm3lock_gen.lock_iit (pi_iit_ne_id => p_iit_ne_id);');
      append_body('      check_correct_inv_type (l_rowid);');
      append_body('--');
      append_body('      UPDATE nm_inv_items_all');
      l_start := '        SET  ';
      FOR i IN 1..l_tab_rec_ita.COUNT
       LOOP
         l_rec_ita := l_tab_rec_ita (i);
         l_line := LOWER(l_rec_ita.ita_attrib_name);
         l_line := RPAD(l_line,31,' ')||'= ';
         l_line := l_line||SUBSTR('pf_'||LOWER(l_rec_ita.ita_view_col_name),1,30);
         append_body (l_start||l_line);
         l_start := '            ,';
      END LOOP;
      append_body('       WHERE '||RPAD('ROWID',31)||'= l_rowid;');
      append_body('--');
      append_body('      nm3user.set_effective_date(c_eff_date);');
      append_body('--');
      append_body('   EXCEPTION');
      append_body('      WHEN others');
      append_body('       THEN');
      append_body('         nm3user.set_effective_date(c_eff_date);');
      append_body('         RAISE;');
      append_body('   END;');
      append_body('--');
      append_body('   nm_debug.proc_end(g_package_name,'||nm3flx.string('upd_attr')||');');
      append_body('--');
      append_body('END upd_attr;');
      append_head('--</PROC>');
   END IF;
   --
   --
   --
   --   ########################################################
   --
   --    INS procedures
   --
   --   ########################################################
   --
   --
   seperator_head;
   append_head('--<PROC NAME="ins">');
   append_head('-- This set of overloaded procedures and functions provide insert');
   append_head('--  API calls for an inventory item of type "'||p_inv_type||'" and optionally allow');
   append_head('--  location of the item by various methods.');
   append_head('-- ');
   append_head('-- For a fuller explanation of the operations of these procedures please');
   append_head('--  see the nm3api_inv package comments in NM3 Web APD (NMWEB0005)');
   append_head('-- ');
   l_function := FALSE;
   FOR i IN 1..2
    LOOP
      --
      -- ### DO THE BARE INSERT - NO LOCATION ------------------------------------
      --
      do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
      end_of_parameters (l_function);
      move_fixed_to_rec(l_xsp_allowed);
      move_flex_to_rec (l_tab_rec_ita);
      append_body('   nm3api_inv.create_inventory_item (p_rec_iit           => l_rec_iit');
      append_body('                                    ,p_effective_date    => p_effective_date');
      append_body('                                    );');
      move_back_and_end (l_function);
      --
      ------------------------------------------------------------------------------
      --
      IF NOT l_nin_exists
       THEN
         IF i = 1
          THEN
            seperator_head;
            seperator_body;
            append_both('--');
            append_both('-- Not creating location procedures. this inventory type is not');
            append_both('--  allowed to be located on any network types (NM_INV_NW)');
            append_both('--');
         END IF;
      ELSIF l_is_child_at
       THEN
         IF i = 1
          THEN
            seperator_head;
            seperator_body;
            append_both('--');
            append_both('-- Not creating location procedures. this inventory type is');
            append_both('--  to be located via an AT relation of a parent type');
            append_both('--');
         END IF;
      ELSE
         IF l_continuous
          THEN
            do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
            location_comment_on;
            append_both('              ,'||rpad('p_element_ne_unique',31,' ')||'IN     nm_elements.ne_unique%TYPE');
            append_both('              ,'||rpad('p_element_ne_nt_type',31,' ')||'IN     nm_elements.ne_nt_type%TYPE');
            location_comment_off;
            end_of_parameters (l_function);
            move_fixed_to_rec(l_xsp_allowed);
            move_flex_to_rec (l_tab_rec_ita);
            append_body('   nm3api_inv.create_inventory_item (p_rec_iit            => l_rec_iit');
            append_body('                                    ,p_effective_date     => p_effective_date');
            append_body('                                    ,p_element_ne_unique  => p_element_ne_unique');
            append_body('                                    ,p_element_ne_nt_type => p_element_ne_nt_type');
            append_body('                                    );');
            move_back_and_end (l_function);
            --
            ------------------------------------------------------------------------------
            --
            do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
            location_comment_on;
            append_both('              ,'||rpad('p_element_ne_id',31,' ')||'IN     nm_elements.ne_id%TYPE');
            location_comment_off;
            end_of_parameters (l_function);
            move_fixed_to_rec(l_xsp_allowed);
            move_flex_to_rec (l_tab_rec_ita);
            append_body('   nm3api_inv.create_inventory_item (p_rec_iit            => l_rec_iit');
            append_body('                                    ,p_effective_date     => p_effective_date');
            append_body('                                    ,p_element_ne_id      => p_element_ne_id');
            append_body('                                    );');
            move_back_and_end (l_function);
            --
            ------------------------------------------------------------------------------
            --
            do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
            location_comment_on;
            append_both('              ,'||rpad('p_nse_id',31,' ')||'IN     nm_saved_extents.nse_id%TYPE');
            location_comment_off;
            end_of_parameters (l_function);
            move_fixed_to_rec(l_xsp_allowed);
            move_flex_to_rec (l_tab_rec_ita);
            append_body('   nm3api_inv.create_inventory_item (p_rec_iit            => l_rec_iit');
            append_body('                                    ,p_effective_date     => p_effective_date');
            append_body('                                    ,p_nse_id             => p_nse_id');
            append_body('                                    );');
            move_back_and_end (l_function);
            --
            ------------------------------------------------------------------------------
            --
            do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
            location_comment_on;
            append_both('              ,'||rpad('p_route_ne_id',31,' ')||'IN     nm_elements.ne_id%TYPE        DEFAULT NULL');
            append_both('              ,'||rpad('p_start_ne_id',31,' ')||'IN     nm_elements.ne_id%TYPE');
            append_both('              ,'||rpad('p_start_offset',31,' ')||'IN     NUMBER');
            append_both('              ,'||rpad('p_end_ne_id',31,' ')||'IN     nm_elements.ne_id%TYPE');
            append_both('              ,'||rpad('p_end_offset',31,' ')||'IN     NUMBER');
            append_both('              ,'||rpad('p_sub_class',31,' ')||'IN     nm_elements.ne_sub_class%TYPE DEFAULT NULL');
            append_both('              ,'||rpad('p_restrict_excl_sub_class',31,' ')||'IN     VARCHAR2                      DEFAULT NULL');
            location_comment_off;
            end_of_parameters (l_function);
            move_fixed_to_rec(l_xsp_allowed);
            move_flex_to_rec (l_tab_rec_ita);
            append_body('   nm3api_inv.create_inventory_item (p_rec_iit                 => l_rec_iit');
            append_body('                                    ,p_effective_date          => p_effective_date');
            append_body('                                    ,p_route_ne_id             => p_route_ne_id');
            append_body('                                    ,p_start_ne_id             => p_start_ne_id');
            append_body('                                    ,p_start_offset            => p_start_offset');
            append_body('                                    ,p_end_ne_id               => p_end_ne_id');
            append_body('                                    ,p_end_offset              => p_end_offset');
            append_body('                                    ,p_sub_class               => p_sub_class');
            append_body('                                    ,p_restrict_excl_sub_class => p_restrict_excl_sub_class');
            append_body('                                    );');
            move_back_and_end (l_function);
            --
            ------------------------------------------------------------------------------
            --
            do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
            location_comment_on;
            append_both('              ,'||rpad('p_pl_arr',31,' ')||'IN     nm_placement_array');
            location_comment_off;
            end_of_parameters (l_function);
            move_fixed_to_rec(l_xsp_allowed);
            move_flex_to_rec (l_tab_rec_ita);
            append_body('   nm3api_inv.create_inventory_item (p_rec_iit            => l_rec_iit');
            append_body('                                    ,p_effective_date     => p_effective_date');
            append_body('                                    ,p_pl_arr             => p_pl_arr');
            append_body('                                    );');
            move_back_and_end (l_function);
            --
            ------------------------------------------------------------------------------
            --
            do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
            location_comment_on;
            append_both('              ,'||rpad('p_pl',31,' ')||'IN     nm_placement');
            location_comment_off;
            end_of_parameters (l_function);
            move_fixed_to_rec(l_xsp_allowed);
            move_flex_to_rec (l_tab_rec_ita);
            append_body('   nm3api_inv.create_inventory_item (p_rec_iit            => l_rec_iit');
            append_body('                                    ,p_effective_date     => p_effective_date');
            append_body('                                    ,p_pl                 => p_pl');
            append_body('                                    );');
            move_back_and_end (l_function);
         END IF;
         --
         ------------------------------------------------------------------------------
         --
         do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
         location_comment_on;
         append_both('              ,'||rpad('p_element_ne_unique',31,' ')||'IN     nm_elements.ne_unique%TYPE');
         append_both('              ,'||rpad('p_element_ne_nt_type',31,' ')||'IN     nm_elements.ne_nt_type%TYPE');
         IF l_continuous
          THEN
            append_both('              ,'||rpad('p_element_begin_mp',31,' ')||'IN     nm_members.nm_begin_mp%TYPE');
            append_both('              ,'||rpad('p_element_end_mp',31,' ')||'IN     nm_members.nm_end_mp%TYPE');
         ELSE
            append_both('              ,'||rpad('p_element_mp',31,' ')||'IN     nm_members.nm_begin_mp%TYPE');
         END IF;
         location_comment_off;
         end_of_parameters (l_function);
         move_fixed_to_rec(l_xsp_allowed);
         move_flex_to_rec (l_tab_rec_ita);
         append_body('   nm3api_inv.create_inventory_item (p_rec_iit            => l_rec_iit');
         append_body('                                    ,p_effective_date     => p_effective_date');
         append_body('                                    ,p_element_ne_unique  => p_element_ne_unique');
         append_body('                                    ,p_element_ne_nt_type => p_element_ne_nt_type');
         IF l_continuous
          THEN
            append_body('                                    ,p_element_begin_mp   => p_element_begin_mp');
            append_body('                                    ,p_element_end_mp     => p_element_end_mp');
         ELSE
            append_body('                                    ,p_element_begin_mp   => p_element_mp');
            append_body('                                    ,p_element_end_mp     => p_element_mp');
         END IF;
         append_body('                                    );');
         move_back_and_end (l_function);
         --
         ------------------------------------------------------------------------------
         --
         do_basic_ins_parameters (l_tab_rec_ita, l_function, l_xsp_allowed);
         location_comment_on;
         append_both('              ,'||rpad('p_element_ne_id',31,' ')||'IN     nm_elements.ne_id%TYPE');
         IF l_continuous
          THEN
            append_both('              ,'||rpad('p_element_begin_mp',31,' ')||'IN     nm_members.nm_begin_mp%TYPE');
            append_both('              ,'||rpad('p_element_end_mp',31,' ')||'IN     nm_members.nm_end_mp%TYPE');
         ELSE
            append_both('              ,'||rpad('p_element_mp',31,' ')||'IN     nm_members.nm_begin_mp%TYPE');
         END IF;
         location_comment_off;
         end_of_parameters (l_function);
         move_fixed_to_rec(l_xsp_allowed);
         move_flex_to_rec (l_tab_rec_ita);
         append_body('   nm3api_inv.create_inventory_item (p_rec_iit            => l_rec_iit');
         append_body('                                    ,p_effective_date     => p_effective_date');
         append_body('                                    ,p_element_ne_id      => p_element_ne_id');
         IF l_continuous
          THEN
            append_body('                                    ,p_element_begin_mp   => p_element_begin_mp');
            append_body('                                    ,p_element_end_mp     => p_element_end_mp');
         ELSE
            append_body('                                    ,p_element_begin_mp   => p_element_mp');
            append_body('                                    ,p_element_end_mp     => p_element_mp');
         END IF;
         append_body('                                    );');
         move_back_and_end (l_function);
      END IF;
      l_function := TRUE;
   END LOOP;
   append_head('--</PROC>');
   --
   ------------------------------------------------------------------------------
   --
--
   --
   ---- CSV Load procedures -----------------------------------------------------
   --

   seperator_head;
   seperator_body;
   DECLARE
      l_procedure VARCHAR2(30);
      l_descr     VARCHAR2(30);
      l_to_call   VARCHAR2(61);
      l_rec_nld   nm_load_destinations%ROWTYPE;
      l_rec_nldd  nm_load_destination_defaults%ROWTYPE;
   BEGIN
      FOR j IN 1..2
       LOOP
         IF j = 1
          THEN
            l_procedure := 'validate_rowtype';
            l_descr     := 'validates';
            l_to_call   := 'nm3inv.validate_rec_iit';
            l_rec_nld.nld_validation_proc   := l_package_name||'.'||l_procedure;
         ELSE
            l_procedure := 'insert_rowtype';
            l_descr     := 'inserts';
            l_to_call   := 'nm3ins.ins_iit';
            l_rec_nld.nld_insert_proc   := l_package_name||'.'||l_procedure;
         END IF;
         append_head('--<PROC NAME="'||l_procedure||'">');
         append_head('--  this procedure '||l_descr||' a ROWTYPE variable based on the metamodel');
         append_both('PROCEDURE '||l_procedure||' ('||l_rowtype_name||' '||l_rowtype_type||'%ROWTYPE)');
         append_head(';',FALSE);
         append_body(' IS',FALSE);
         --
         append_body('   l_rec_iit nm_inv_items%ROWTYPE;');
         append_body('BEGIN');
         append_body('--');
         append_body('   nm_debug.proc_start(g_package_name,'||nm3flx.string(l_procedure)||');');
         append_body('--');
         append_body('   l_rec_iit.iit_ne_id      := '||l_rowtype_name||'.iit_ne_id;');
         append_body('   l_rec_iit.iit_inv_type   := c_inv_type;');
         append_body('   l_rec_iit.iit_start_date := '||l_rowtype_name||'.iit_start_date;');
         append_body('   l_rec_iit.iit_admin_unit := '||l_rowtype_name||'.iit_admin_unit;');
         append_body('   l_rec_iit.iit_descr      := '||l_rowtype_name||'.iit_descr;');
         append_body('   l_rec_iit.iit_note       := '||l_rowtype_name||'.iit_note;');
         IF l_xsp_allowed
          THEN
            append_body('   l_rec_iit.iit_x_sect     := '||l_rowtype_name||'.iit_x_sect;');
         END IF;
         --
         FOR i IN 1..l_tab_rec_ita.COUNT
          LOOP
            append_body('   l_rec_iit.'||l_tab_rec_ita(i).ita_attrib_name||' := '||l_rowtype_name||'.'||l_tab_rec_ita(i).ita_view_col_name||';');
         END LOOP;
         append_body('--');
         append_body('   '||l_to_call||' (l_rec_iit);');
         append_body('--');
         append_body('   nm_debug.proc_end(g_package_name,'||nm3flx.string(l_procedure)||');');
         append_body('--');
         --
         append_body('END '||l_procedure||';');
         --
         append_head('--</PROC>');
         seperator_head;
         seperator_body;
      END LOOP;
      l_rec_nld.nld_id                 := Null;
      l_rec_nld.nld_table_name         := l_rowtype_type;
      l_rec_nld.nld_table_short_name   := 'V'||p_inv_type;
      IF nm3get.get_nld (pi_nld_table_name  => l_rec_nld.nld_table_name
                        ,pi_raise_not_found => FALSE
                        ).nld_id IS NULL
       THEN
         l_rec_nld.nld_id              := nm3seq.next_nld_id_seq;
         nm3ins.ins_nld (l_rec_nld);
         l_rec_nldd.nldd_nld_id        := l_rec_nld.nld_id;
         l_rec_nldd.nldd_column_name   := 'IIT_NE_ID';
         l_rec_nldd.nldd_value         := 'nm3seq.next_ne_id_seq';
         nm3ins.ins_nldd (l_rec_nldd);
         l_rec_nldd.nldd_column_name   := 'IIT_INV_TYPE';
         l_rec_nldd.nldd_value         := nm3flx.string(p_inv_type);
         nm3ins.ins_nldd (l_rec_nldd);
      END IF;
   END;
   append_both('END '||l_package_name||';');
--
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
   nm_debug.proc_end (g_package_name,'build_one');
--
EXCEPTION
   WHEN not_building
    THEN
      Null;
END build_one;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_all IS
--
   CURSOR cs_nit IS
   SELECT nit_inv_type
    FROM  nm_inv_types
   WHERE  nit_table_name IS NULL
   ORDER BY nit_inv_type;
--
   l_tab_nit_inv_type nm3type.tab_varchar4;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'build_all');
--
   IF g_create_api_inv_packs
    THEN
      OPEN  cs_nit;
      FETCH cs_nit BULK COLLECT INTO l_tab_nit_inv_type;
      CLOSE cs_nit;
--
      FOR i IN 1..l_tab_nit_inv_type.COUNT
       LOOP
         build_one (p_inv_type => l_tab_nit_inv_type(i));
      END LOOP;
   END IF;
--
   nm_debug.proc_end (g_package_name,'build_all');
--
END build_all;
--
-----------------------------------------------------------------------------
--
FUNCTION get_api_package_name (p_inv_type nm_inv_types.nit_inv_type%TYPE
                              ) RETURN user_objects.object_name%TYPE IS
BEGIN
--
   RETURN LOWER('NM3API_INV_'||p_inv_type);
--
END get_api_package_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE move_flex_to_rec (p_tab_rec_ita nm3inv.tab_nita) IS
   l_rec_ita      nm_inv_type_attribs%ROWTYPE;
   l_max_len      PLS_INTEGER := 0;
BEGIN
   append_body('--');
   FOR i IN 1..p_tab_rec_ita.COUNT
    LOOP
      l_max_len := GREATEST(LENGTH(p_tab_rec_ita(i).ita_attrib_name),l_max_len);
   END LOOP;
   FOR i IN 1..p_tab_rec_ita.COUNT
    LOOP
      l_rec_ita := p_tab_rec_ita (i);
      append_body('   l_rec_iit.'||RPAD(lower(l_rec_ita.ita_attrib_name),l_max_len+1,' ')||':= '||lower('pf_'||SUBSTR(l_rec_ita.ita_view_col_name,1,27))||';');
   END LOOP;
   append_body('--');
END move_flex_to_rec;
--
-----------------------------------------------------------------------------
--
PROCEDURE move_fixed_to_rec (p_xsp BOOLEAN) IS
BEGIN
   append_body('   l_rec_iit nm_inv_items%ROWTYPE;');
   append_body('BEGIN');
   append_body('--');
   append_body('   nm_debug.proc_start(g_package_name,'||nm3flx.string('ins')||');');
   append_body('--');
   append_body('   l_rec_iit.iit_ne_id      := Null;');
   append_body('   l_rec_iit.iit_inv_type   := c_inv_type;');
   append_body('   l_rec_iit.iit_start_date := p_effective_date;');
   append_body('   l_rec_iit.iit_admin_unit := p_admin_unit;');
   append_body('   l_rec_iit.iit_descr      := p_descr;');
   append_body('   l_rec_iit.iit_note       := p_note;');
   IF p_xsp
    THEN
      append_body('   l_rec_iit.iit_x_sect     := p_x_sect;');
   END IF;
END move_fixed_to_rec;
--
-----------------------------------------------------------------------------
--
PROCEDURE move_back_and_end (p_function    BOOLEAN DEFAULT FALSE) IS
BEGIN
   append_body('--');
   IF NOT p_function
    THEN
      append_body('   p_iit_ne_id := l_rec_iit.iit_ne_id;');
      append_body('--');
   END IF;
   append_body('   nm_debug.proc_end(g_package_name,'||nm3flx.string('ins')||');');
   IF p_function
    THEN
      append_body('--');
      append_body('   RETURN l_rec_iit.iit_ne_id;');
   END IF;
   append_body('--');
   append_body('END ins;');
END move_back_and_end;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_of_parameters (p_function    BOOLEAN DEFAULT FALSE) IS
BEGIN
   append_both('              )');
   IF p_function
    THEN
      append_both(' RETURN nm_inv_items_all.iit_ne_id%TYPE',FALSE);
   END IF;
   append_head(';',FALSE);
   append_body(' IS',FALSE);
END end_of_parameters;
--
-----------------------------------------------------------------------------
--
END nm3inv_api_gen;
/
