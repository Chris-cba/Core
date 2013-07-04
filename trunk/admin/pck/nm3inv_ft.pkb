CREATE OR REPLACE PACKAGE BODY nm3inv_ft AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_ft.pkb-arc   2.4   Jul 04 2013 16:08:46   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_ft.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:08:46  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       Version          : $Revision:   2.4  $
--       Based on SCCS version : 1.5
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 Inventory Foreign Table package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.4  $';
  g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3inv_ft';
--
   g_rec_nit         NM_INV_TYPES%ROWTYPE;
   g_tab_nita        nm3inv.tab_nita;
--
   c_surrogate_pk_col_name CONSTANT VARCHAR2(30) := 'SURROGATE_PK';
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
PROCEDURE get_tab_rec_ft (p_inv_type        IN     NM_INV_TYPES.nit_inv_type%TYPE
                         ,p_create_snapshot IN     BOOLEAN DEFAULT FALSE
                         ,p_tab_rec_ft      IN OUT tab_rec_ft
                         ) IS
BEGIN
   p_tab_rec_ft := get_tab_rec_ft (p_inv_type);
END get_tab_rec_ft;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_rec_ft (p_inv_type        NM_INV_TYPES.nit_inv_type%TYPE
                        ,p_create_snapshot BOOLEAN DEFAULT FALSE
                        ) RETURN tab_rec_ft IS
--
   l_tab_rec_ft tab_rec_ft;
   l_rec_ft     rec_ft;
--
   l_tab_cols   nm3type.tab_varchar30;
   l_tab_format nm3type.tab_varchar30;
   l_tab_vals   nm3type.tab_varchar4000;
   l_start      VARCHAR2(10);
   l_sql        VARCHAR2(32767);
--
   l_block      nm3type.tab_varchar32767;
--
   l_rec_int    NM_MRG_SECTION_INV_VALUES_ALL%ROWTYPE;
--
   l_view_name    VARCHAR2(30);
   l_view_name_nw VARCHAR2(30);
--
   l_obj          VARCHAR2(30);
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_block,p_text,p_nl);
   END append;
--
   FUNCTION get_an_inv_type_name RETURN NM_INV_TYPES.nit_inv_type%TYPE IS
   --
      l_retval NM_INV_TYPES.nit_inv_type%TYPE;
      got_one  BOOLEAN;
      i        PLS_INTEGER := 0;
   --
      CURSOR cs_nit IS
      SELECT nit_short_descr
       FROM  NM_INV_TYPES
      WHERE  nit_inv_type = l_retval;
      l_nit_short_descr NM_INV_TYPES.nit_short_descr%TYPE;
--
       c_short_descr CONSTANT NM_INV_TYPES.nit_short_descr%TYPE := 'EXCL '||p_inv_type;
   --
   BEGIN
   --
      got_one := TRUE;
      LOOP
         i := i + 1;
         l_retval := SUBSTR(p_inv_type,1,1)||LTRIM(TO_CHAR(i,'000'),' ');
         -- Look to see
         OPEN  cs_nit;
         FETCH cs_nit INTO l_nit_short_descr;
         IF cs_nit%FOUND
          AND l_nit_short_descr = c_short_descr
          THEN
            got_one := TRUE;
         ELSIF cs_nit%NOTFOUND
          THEN
            got_one := TRUE;
         ELSE
            got_one := FALSE;
         END IF;
         CLOSE cs_nit;
         IF got_one
          THEN
            FOR j IN 1..l_tab_rec_ft.COUNT
             LOOP
               IF l_retval = l_tab_rec_ft(j).nit_inv_type
                THEN
                  got_one := FALSE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;
         EXIT WHEN got_one;
      END LOOP;
   --
      RETURN l_retval;
   --
   END get_an_inv_type_name;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_rec_ft');
--
   IF p_inv_type != NVL(g_rec_nit.nit_inv_type, nm3type.c_nvl)
    THEN
      g_rec_nit  := nm3inv.get_inv_type(p_inv_type);
      g_tab_nita := nm3inv.get_tab_ita(p_inv_type);
      g_inv_type := p_inv_type;
   END IF;
--
   IF g_rec_nit.nit_table_name IS NOT NULL
    THEN
      l_view_name    := g_rec_nit.nit_table_name;
      l_view_name_nw := g_rec_nit.nit_table_name;
   ELSE
      l_view_name    := nm3inv.derive_inv_type_view_name(p_inv_type);
      l_view_name_nw := nm3inv.derive_nw_inv_type_view_name(p_inv_type);
   END IF;
--
   IF g_rec_nit.nit_exclusive = 'N'
    THEN
      hig.raise_ner(nm3type.c_net,230);
   END IF;
--
   IF p_create_snapshot
    THEN
      l_obj := 'MATERIALIZED VIEW';
   ELSE
      l_obj := 'VIEW';
   END IF;
--
   IF g_rec_nit.nit_x_sect_allow_flag = 'Y'
    THEN
      l_tab_cols(1)   := 'IIT_X_SECT';
      l_tab_format(1) := 'VARCHAR2';
   END IF;
--
   FOR i IN 1..g_tab_nita.COUNT
    LOOP
      IF g_tab_nita(i).ita_exclusive = 'Y'
       THEN
         l_tab_cols(l_tab_cols.COUNT+1)     := g_tab_nita(i).ita_view_col_name;
         l_tab_format(l_tab_format.COUNT+1) := g_tab_nita(i).ita_format;
      END IF;
   END LOOP;
--
   IF l_tab_cols.COUNT = 0
    THEN
      hig.raise_ner(nm3type.c_net,232);
   END IF;
--
   append ('DECLARE', FALSE);
   append ('--');
   append ('   c_date_format CONSTANT VARCHAR2(20) := '||nm3flx.string('YYYYMMDDHH24MISS')||';');
   append ('--');
   append ('CURSOR cs_distinct IS');
--
   l_start := 'SELECT ';
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      IF l_tab_format(i) = 'DATE'
       THEN
         append (l_start||'TO_CHAR('||l_tab_cols(i)||',c_date_format) '||l_tab_cols(i));
      ELSE
         append (l_start||l_tab_cols(i));
      END IF;
      l_start := '      ,';
   END LOOP;
--
   append (' FROM '||l_view_name);
--
   l_start := 'GROUP BY ';
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      append(l_start||l_tab_cols(i));
      l_start := '        ,';
   END LOOP;
   append (';',FALSE);
   append ('--');
   append ('   l_count PLS_INTEGER := 0;');
   append ('   l_view_name VARCHAR2(500);');
   append ('   l_view_desc VARCHAR2(500);');
   append ('   l_where     VARCHAR2(32767);');
   append ('   l_start     VARCHAR2(20);');
   append ('   l_found     BOOLEAN := FALSE;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   '||g_package_name||'.g_rec_internal.DELETE;');
   append ('   '||g_package_name||'.g_tab_descr.DELETE;');
   append ('   '||g_package_name||'.g_where_clause.DELETE;');
   append ('--');
   append ('   FOR cs_rec IN cs_distinct');
   append ('    LOOP');
   append ('--');
   append ('      l_found     := TRUE;');
   append ('      l_view_name := '||g_package_name||'.g_inv_type;');
   append ('      l_view_desc := '||g_package_name||'.g_inv_type;');
   append ('      l_where     := Null;');
   append ('      l_count     := l_count + 1;');
   append ('      l_start     := '||nm3flx.string('WHERE ')||';');
   append ('--');
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      append ('      '||g_package_name||'.g_rec_internal(l_count).nsv_attrib'||i||' := cs_rec.'||l_tab_cols(i)||';');
      append ('      l_view_name := l_view_name||'||nm3flx.string('_')||'||cs_rec.'||l_tab_cols(i)||';');
      append ('      l_view_desc := l_view_desc||'||nm3flx.string(' - ')||'||cs_rec.'||l_tab_cols(i)||';');
      IF l_tab_format(i)    = 'VARCHAR2'
       THEN
         append ('      l_where := l_where||'||'l_start||'||nm3flx.string(l_tab_cols(i)||' = ')||'||nm3flx.string(cs_rec.'||l_tab_cols(i)||');');
      ELSIF l_tab_format(i) = 'NUMBER'
       THEN
         append ('      l_where := l_where||'||'l_start||'||nm3flx.string(l_tab_cols(i)||' = ')||'||cs_rec.'||l_tab_cols(i)||';');
      ELSE
         append ('      l_where := l_where||'||'l_start||'||nm3flx.string(l_tab_cols(i)||' = ')||'||to_date(nm3flx.string(cs_rec.'||l_tab_cols(i)||',c_date_format));');
      END IF;
      append ('      l_start := CHR(10)||'||nm3flx.string(' AND  ')||';');
   END LOOP;
   append ('--');
   append ('      IF LENGTH(l_view_name) > 30');
   append ('       THEN');
   append ('         hig.raise_ner(pi_appl               => nm3type.c_net');
   append ('                      ,pi_id                 => 229');
   append ('                      ,pi_supplementary_info => l_view_name');
   append ('                      );');
   append ('      END IF;');
   append ('      '||g_package_name||'.g_rec_internal(l_count).nsv_inv_type := SUBSTR(l_view_name,1,30);');
   append ('      '||g_package_name||'.g_tab_descr(l_count)                 := SUBSTR(l_view_desc,1,80);');
   append ('      '||g_package_name||'.g_where_clause(l_count)              := l_where;');
   append ('--');
   append ('   END LOOP;');
   append ('--');
   append ('   IF NOT l_found');
   append ('    THEN');
   append ('      hig.raise_ner(nm3type.c_net,233);');
   append ('   END IF;');
   append ('--');
   append ('END;');
   nm3ddl.debug_tab_varchar(l_block);
--
   nm3ddl.execute_tab_varchar(l_block);
--
   FOR i IN 1..g_rec_internal.COUNT
    LOOP
      l_rec_ft.nit_inv_type   := get_an_inv_type_name;
      l_rec_ft.nit_descr      := g_tab_descr(i);
      l_rec_ft.create_yn      := 'Y';
      l_rec_ft.nit_table_name := g_rec_internal(i).nsv_inv_type;
      l_rec_ft.view_text      := 'CREATE '||l_obj||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_rec_ft.nit_table_name;
      --
      IF p_create_snapshot
       THEN
         l_rec_ft.view_text   := l_rec_ft.view_text
                                 ||CHR(10)||'REFRESH START WITH SYSDATE NEXT TRUNC(SYSDATE)+7';
      END IF;
      --
      l_rec_ft.view_text      := l_rec_ft.view_text||' AS'
                                 ||CHR(10)||'SELECT v.*';
      IF g_rec_nit.nit_table_name IS NULL
       THEN
         l_rec_ft.view_text   := l_rec_ft.view_text
                                 ||CHR(10)||'      ,ROWNUM '||c_surrogate_pk_col_name;
      END IF;
      l_rec_ft.view_text      := l_rec_ft.view_text
                                 ||CHR(10)||' FROM  '||l_view_name_nw||' v'
                                 ||CHR(10)||g_where_clause(i);
      l_tab_rec_ft (l_tab_rec_ft.COUNT+1) := l_rec_ft;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_tab_rec_ft');
--
   RETURN l_tab_rec_ft;
--
END get_tab_rec_ft;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_create (p_inv_type        NM_INV_TYPES.nit_inv_type%TYPE
                    ,p_tab_rec_ft      tab_rec_ft
                    ,p_create_snapshot BOOLEAN DEFAULT FALSE
                    ) IS
--
   PRAGMA autonomous_transaction;
--
   l_rec_ft     rec_ft;
   l_rec_nit    NM_INV_TYPES%ROWTYPE;
   l_tab_nita   nm3inv.tab_nita;
--
   CURSOR cs_nit (c_short_descr VARCHAR2) IS
   SELECT ROWID
         ,nit_inv_type
    FROM  NM_INV_TYPES_ALL
   WHERE  nit_short_descr = c_short_descr
   FOR UPDATE NOWAIT;
--
   l_tab_rowid    nm3type.tab_rowid;
   l_tab_inv_type nm3type.tab_varchar4;
--
   c_short_descr CONSTANT NM_INV_TYPES.nit_short_descr%TYPE := 'EXCL '||p_inv_type;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'do_create');
--
   IF p_inv_type != NVL(g_rec_nit.nit_inv_type, nm3type.c_nvl)
    THEN
      hig.raise_ner(nm3type.c_net,231);
   END IF;
--
   OPEN  cs_nit (c_short_descr);
   FETCH cs_nit BULK COLLECT INTO l_tab_rowid, l_tab_inv_type;
   CLOSE cs_nit;
--
   FORALL i IN 1..l_tab_inv_type.COUNT
      DELETE FROM NM_INV_TYPE_ATTRIBS_ALL
      WHERE  ita_inv_type = l_tab_inv_type(i);
--
   FORALL i IN 1..l_tab_inv_type.COUNT
      DELETE FROM NM_INV_TYPE_ROLES
      WHERE  itr_inv_type = l_tab_inv_type(i);
--
   FORALL i IN 1..l_tab_inv_type.COUNT
      DELETE FROM NM_INV_NW_ALL
      WHERE  nin_nit_inv_code = l_tab_inv_type(i);

   FORALL i IN 1..l_tab_inv_type.COUNT
      DELETE FROM NM_INV_TYPES
      WHERE  ROWID = l_tab_rowid (i);
--
   FOR i IN 1..p_tab_rec_ft.COUNT
    LOOP
--
      l_rec_ft := p_tab_rec_ft(i);
--
      IF NVL(l_rec_ft.create_yn,'Y') = 'Y'
       THEN
--
         DECLARE
            CURSOR cs_obj (c_name  VARCHAR2
                          ) IS
            SELECT object_type
             FROM  ALL_OBJECTS
            WHERE  owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
             AND   object_name = c_name;
            l_type ALL_OBJECTS.object_type%TYPE;
            PROCEDURE do_drop IS
            BEGIN
               EXECUTE IMMEDIATE 'DROP '||l_type||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_rec_ft.nit_table_name;
            END do_drop;
         BEGIN
            OPEN  cs_obj (l_rec_ft.nit_table_name);
            FETCH cs_obj INTO l_type;
            IF cs_obj%FOUND
             THEN
--               nm_debug.debug('DROP '||l_type||' '||c_app_owner||'.'||l_rec_ft.nit_table_name);
               DECLARE
                  l_mat_view EXCEPTION;
                  PRAGMA EXCEPTION_INIT (l_mat_view,-12083);
               BEGIN
                  do_drop;
               EXCEPTION
                  WHEN OTHERS
                   THEN
                     l_type := 'MATERIALIZED VIEW';
                     do_drop;
               END;
            END IF;
            CLOSE cs_obj;
         END;
--
--         nm_debug.debug(l_rec_ft.view_text);
         nm3ddl.create_object_and_syns (l_rec_ft.nit_table_name, l_rec_ft.view_text);
   --
         l_rec_nit                          := g_rec_nit;
         l_rec_nit.nit_inv_type             := l_rec_ft.nit_inv_type;
         l_rec_nit.nit_descr                := l_rec_ft.nit_descr;
         l_rec_nit.nit_short_descr          := c_short_descr;
         l_rec_nit.nit_view_name            := NULL;
         l_rec_nit.nit_category             := 'X';
         l_rec_nit.nit_exclusive            := 'N';
         --
         -- Set it to be XSP not allowed - because if it originally was
         --  XSP allowed then the view would have restricted it to only this XSP anyway
         --
         l_rec_nit.nit_x_sect_allow_flag    := 'N';
         IF l_rec_nit.nit_table_name IS NULL
          THEN
            l_rec_nit.nit_lr_ne_column_name := 'NE_ID_OF';
            l_rec_nit.nit_lr_st_chain       := 'NM_BEGIN_MP';
            l_rec_nit.nit_lr_end_chain      := 'NM_END_MP';
            l_rec_nit.nit_foreign_pk_column := c_surrogate_pk_col_name;
         END IF;
         l_rec_nit.nit_table_name           := l_rec_ft.nit_table_name;
   --
         IF p_create_snapshot
          THEN
            EXECUTE IMMEDIATE 'CREATE INDEX '||SUBSTR(l_rec_ft.nit_table_name,1,27)||'_IX ON '||l_rec_ft.nit_table_name||'('||l_rec_nit.nit_lr_ne_column_name||')';
            --
            -- If we are creating the snapshot then try to put the security policy on if Enterprise Edn
            --
            IF Sys_Context('NM3CORE','ENTERPRISE_EDITION') = 'TRUE'
             THEN
               dbms_rls.add_policy
                          (object_schema   => Sys_Context('NM3CORE','APPLICATION_OWNER')
                          ,object_name     => l_rec_ft.nit_table_name
                          ,policy_name     => SUBSTR(l_rec_ft.nit_table_name,1,25)||'_POL1'
                          ,function_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
                          ,policy_function => 'INVSEC.INV_PREDICATE_READ'
                          ,statement_types => 'SELECT'
                          ,update_check    => TRUE
                          ,ENABLE          => TRUE
                          );
               dbms_rls.add_policy
                          (object_schema   => Sys_Context('NM3CORE','APPLICATION_OWNER')
                          ,object_name     => l_rec_ft.nit_table_name
                          ,policy_name     => SUBSTR(l_rec_ft.nit_table_name,1,25)||'_POL2'
                          ,function_schema => Sys_Context('NM3CORE','APPLICATION_OWNER')
                          ,policy_function => 'INVSEC.INV_PREDICATE'
                          ,statement_types => 'INSERT,UPDATE,DELETE'
                          ,update_check    => TRUE
                          ,ENABLE          => TRUE
                          );
            END IF;
            --
         END IF;
   --
         nm3inv.ins_nit (l_rec_nit);
   --
         l_tab_nita := g_tab_nita;
         FOR i IN 1..l_tab_nita.COUNT
          LOOP
            l_tab_nita(i).ita_inv_type       := l_rec_nit.nit_inv_type;
            l_tab_nita(i).ita_exclusive      := 'N';
            IF g_rec_nit.nit_table_name IS NULL
             THEN
               l_tab_nita(i).ita_attrib_name := l_tab_nita(i).ita_view_col_name;
            END IF;
         END LOOP;
         nm3inv.ins_tab_ita (l_tab_nita);
   --
         INSERT INTO NM_INV_TYPE_ROLES (itr_inv_type,itr_hro_role,itr_mode)
         SELECT l_rec_ft.nit_inv_type
               ,itr_hro_role
               ,nm3type.c_readonly
          FROM  NM_INV_TYPE_ROLES
         WHERE  itr_inv_type = p_inv_type
         GROUP BY l_rec_ft.nit_inv_type
                 ,itr_hro_role
                 ,nm3type.c_readonly;
   --
      END IF;
--
   END LOOP;
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'do_create');
--
END do_create;
--
-----------------------------------------------------------------------------
--
PROCEDURE test (p_inv_type VARCHAR2 DEFAULT 'PLC') IS
   l_tab_rec_ft tab_rec_ft;
BEGIN
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
   l_tab_rec_ft := get_tab_rec_ft (p_inv_type => p_inv_type);
   FOR i IN 1..l_tab_rec_ft.COUNT
    LOOP
      nm_debug.debug(l_tab_rec_ft(i).nit_inv_type||':'||l_tab_rec_ft(i).nit_descr||':'||l_tab_rec_ft(i).nit_table_name);
      nm_debug.debug(l_tab_rec_ft(i).view_text);
   END LOOP;
   do_create (p_inv_type,l_tab_rec_ft);
--   nm_debug.debug_off;
END test;
--
-----------------------------------------------------------------------------
--
END nm3inv_ft;
/
