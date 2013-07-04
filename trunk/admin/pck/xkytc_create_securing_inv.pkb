CREATE OR REPLACE PACKAGE BODY xkytc_create_securing_inv AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)xkytc_create_securing_inv.pkb	1.1 02/02/04
--       Module Name      : xkytc_create_securing_inv.pkb
--       Date into SCCS   : 04/02/02 16:27:46
--       Date fetched Out : 07/06/13 14:14:06
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Kentucky Create Securing inventory package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)xkytc_create_securing_inv.pkb	1.1 02/02/04"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'xkytc_create_securing_inv';
--
-----------------------------------------------------------------------------
--
   g_count                      pls_integer := 0;
   g_tab_ne_id                  nm3type.tab_number;
--
   g_block                      nm3type.max_varchar2;
--
   g_nothing_to_do              EXCEPTION;
--
-----------------------------------------------------------------
--
PROCEDURE process_each_element (p_ne_id         IN nm_elements_all.ne_id%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE prepare_dynamic_block;
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
-----------------------------------------------------------------
--
PROCEDURE clear_globals IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'clear_globals');
--
   g_count := 0;
   g_tab_ne_id.DELETE;
--
   nm_debug.proc_end(g_package_name,'clear_globals');
--
END clear_globals;
--
-----------------------------------------------------------------
--
PROCEDURE append_to_globals (p_ne_id         IN nm_elements_all.ne_id%TYPE
                            ,p_ne_nt_type    IN nm_elements_all.ne_nt_type%TYPE
                            ) IS
--
   CURSOR cs_inv_to_create (c_nt_type nm_elements_all.ne_nt_type%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  xkytc_securing_inventory
                  WHERE  xsi_nt_type = c_nt_type
                 );
   l_dummy pls_integer;
   l_found boolean;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'append_to_globals');
--
   OPEN  cs_inv_to_create (p_ne_nt_type);
   FETCH cs_inv_to_create INTO l_dummy;
   l_found := cs_inv_to_create%FOUND;
   CLOSE cs_inv_to_create;
--
   IF l_found -- There are some inventory types to create data for
    THEN
      g_count                      := g_count + 1;
      g_tab_ne_id(g_count)         := p_ne_id;
   END IF;
--
   nm_debug.proc_end(g_package_name,'append_to_globals');
--
END append_to_globals;
--
-----------------------------------------------------------------
--
PROCEDURE process_globals IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_globals');
--
   BEGIN
      IF g_count > 0
       THEN
         IF NOT nm3user.is_user_unrestricted
          THEN
            hig.raise_ner (pi_appl => nm3type.c_hig
                          ,pi_id   => 86
                          );
         END IF;
         prepare_dynamic_block;
         FOR i IN 1..g_count
          LOOP
            process_each_element (p_ne_id => g_tab_ne_id(i));
         END LOOP;
      END IF;
   EXCEPTION
      WHEN g_nothing_to_do
       THEN
         NULL;
   END;
--
   clear_globals;
--
   nm_debug.proc_end(g_package_name,'process_globals');
--
END process_globals;
--
-----------------------------------------------------------------
--
PROCEDURE process_each_element (p_ne_id         IN nm_elements_all.ne_id%TYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'process_each_element');
--
   g_rec_ne := nm3get.get_ne_all (pi_ne_id => p_ne_id);
--
   EXECUTE IMMEDIATE g_block;
--
   nm_debug.proc_end(g_package_name,'process_each_element');
--
END process_each_element;
--
-----------------------------------------------------------------
--
FUNCTION find_corresponding_au (p_nau_admin_unit nm_admin_units.nau_admin_unit%TYPE
                               ,p_nat_admin_type nm_au_types.nat_admin_type%TYPE
                               ) RETURN nm_admin_units.nau_admin_unit%TYPE IS
--
   l_rec_nau_ele nm_admin_units_all%ROWTYPE;
   l_rec_nau_inv nm_admin_units_all%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'find_corresponding_au');
--
   l_rec_nau_ele := nm3get.get_nau_all (pi_nau_admin_unit => p_nau_admin_unit);
--
   IF p_nat_admin_type = l_rec_nau_ele.nau_admin_type
    THEN
      l_rec_nau_inv := l_rec_nau_ele;
   ELSE
      l_rec_nau_inv := nm3get.get_nau_all (pi_nau_unit_code  => l_rec_nau_ele.nau_unit_code
                                          ,pi_nau_admin_type => p_nat_admin_type
                                          );
   END IF;
--
   nm_debug.proc_end(g_package_name,'find_corresponding_au');
--
   RETURN l_rec_nau_inv.nau_admin_unit;
--
END find_corresponding_au;
--
-----------------------------------------------------------------------------
--
PROCEDURE prepare_dynamic_block IS
--
   CURSOR cs_inv_types IS
   SELECT nit_inv_type
         ,nit_admin_type
    FROM  nm_inv_types_all
         ,xkytc_securing_inventory
   WHERE  xsi_nit_inv_type = nit_inv_type
   GROUP BY nit_inv_type
           ,nit_admin_type;
--
   CURSOR cs_nt_types (c_xsi_nit_inv_type xkytc_securing_inventory.xsi_nit_inv_type%TYPE) IS
   SELECT xsi_nt_type
    FROM  xkytc_securing_inventory
   WHERE  xsi_nit_inv_type = c_xsi_nit_inv_type;
--
   l_tab_inv_type               nm3type.tab_varchar4;
   l_tab_inv_au_type            nm3type.tab_varchar4;
   l_tab_inv_nt_type            nm3type.tab_varchar4;
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append (CHR(10),FALSE);
      END IF;
      g_block := g_block||p_text;
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'prepare_dynamic_block');
--
   OPEN  cs_inv_types;
   FETCH cs_inv_types
    BULK COLLECT
    INTO l_tab_inv_type
        ,l_tab_inv_au_type;
   CLOSE cs_inv_types;
--
   g_block := NULL;
   append ('DECLARE');
   append ('   c_ne_id         CONSTANT nm_elements.ne_id%TYPE         := '||g_package_name||'.g_rec_ne.ne_id;');
   append ('   c_ne_admin_unit CONSTANT nm_elements.ne_admin_unit%TYPE := '||g_package_name||'.g_rec_ne.ne_admin_unit;');
   append ('   c_ne_start_date CONSTANT nm_elements.ne_start_date%TYPE := '||g_package_name||'.g_rec_ne.ne_start_date;');
   append ('   c_ne_nt_type    CONSTANT nm_elements.ne_nt_type%TYPE    := '||g_package_name||'.g_rec_ne.ne_nt_type;');
   append ('   c_ne_unique     CONSTANT nm_elements.ne_unique%TYPE     := '||g_package_name||'.g_rec_ne.ne_unique;');
   append ('   c_status        CONSTANT VARCHAR2(3)                    := nm3ausec.get_status;');
   append ('   l_iit_ne_id              nm_inv_items.iit_ne_id%TYPE;');
   append ('BEGIN');
   IF l_tab_inv_type.COUNT = 0
    THEN
      RAISE g_nothing_to_do;
   ELSE
      append ('   nm3ausec.set_status(nm3type.c_off);');
      FOR i IN 1..l_tab_inv_type.COUNT
       LOOP
         OPEN  cs_nt_types (l_tab_inv_type(i));
         FETCH cs_nt_types
          BULK COLLECT INTO l_tab_inv_nt_type;
         CLOSE cs_nt_types;
         append ('   IF c_ne_nt_type IN (');
         FOR j IN 1..l_tab_inv_nt_type.COUNT
          LOOP
            IF j > 1
             THEN
               append (', ',FALSE);
            END IF;
            append (nm3flx.string(l_tab_inv_nt_type(j)),FALSE);
         END LOOP;
         append (')',FALSE);
         append ('    THEN');
--         append ('      nm_debug.debug('||nm3flx.string(l_tab_inv_type(i))||');');
         append ('      '||LOWER('NM3API_INV_'||l_tab_inv_type(i))||'.ins');
         append ('            (p_iit_ne_id      => l_iit_ne_id');
         append ('            ,p_effective_date => c_ne_start_date');
         append ('            ,p_admin_unit     => '||g_package_name||'.find_corresponding_au(c_ne_admin_unit,'||nm3flx.string(l_tab_inv_au_type(i))||')');
         append ('            ,p_descr          => c_ne_unique');
         append ('            ,p_note           => c_ne_nt_type');
         append ('            ,p_element_ne_id  => c_ne_id');
         append ('            );');
--         append ('      nm_debug.debug('||nm3flx.string(l_tab_inv_type(i)||' : ')||'||l_iit_ne_id);');
         append ('   END IF;');
      END LOOP;
      append ('   nm3ausec.set_status(c_status);');
   END IF;
   append ('EXCEPTION');
   append ('   WHEN others');
   append ('    THEN');
   append ('      nm3ausec.set_status(c_status);');
   append ('      RAISE;');
   append ('END;');
--
   nm_debug.DEBUG(g_block);
--
   nm_debug.proc_end(g_package_name,'prepare_dynamic_block');
--
END prepare_dynamic_block;
--
-----------------------------------------------------------------
--
PROCEDURE end_date_securing_inv (pi_ne_id          IN nm_elements_all.ne_id%TYPE
                                ,pi_effective_date IN nm_elements_all.ne_start_date%TYPE
                                ) IS
--
   l_rec_ne        nm_elements_all%ROWTYPE;
   l_tab_iit_rowid nm3type.tab_rowid;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_date_securing_inv');
--
   l_rec_ne := nm3get.get_ne_all (pi_ne_id => pi_ne_id);
--
   SELECT iit.ROWID
    BULK  COLLECT
    INTO  l_tab_iit_rowid
    FROM  nm_inv_items_all         iit
         ,xkytc_securing_inventory xsi
   WHERE  iit.iit_inv_type  = xsi.xsi_nit_inv_type
    AND   xsi.xsi_nt_type   = l_rec_ne.ne_nt_type
    AND   iit.iit_descr     = l_rec_ne.ne_unique
    AND   iit.iit_note      = l_rec_ne.ne_nt_type;
--
   FORALL i IN 1..l_tab_iit_rowid.COUNT
      UPDATE nm_inv_items_all
       SET   iit_end_date = pi_effective_date
      WHERE  ROWID        = l_tab_iit_rowid(i);
--
   nm_debug.proc_end(g_package_name,'end_date_securing_inv');
--
END end_date_securing_inv;
--
-----------------------------------------------------------------
--
END xkytc_create_securing_inv;
/
