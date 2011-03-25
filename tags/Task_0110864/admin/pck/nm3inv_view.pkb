CREATE OR REPLACE PACKAGE BODY nm3inv_view AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_view.pkb-arc   2.11   Mar 25 2011 15:41:58   Chris.Strettle  $
--       Module Name      	: $Workfile:   nm3inv_view.pkb  $
--       Date into PVCS   	: $Date:   Mar 25 2011 15:41:58  $
--       Date fetched Out 	: $Modtime:   Mar 23 2011 14:42:14  $
--       PVCS Version     	: $Revision:   2.11  $
--       Based on SCCS version 	: 1.56
--
--
--   Author : Jonathan Mills
--
--   nm3inv_view package body
--
-----------------------------------------------------------------------------
--      Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  varchar2(80) := '$Revision::   2.11     $';
--  g_body_sccsid is the SCCS ID for the package body
--
--all global package variables here
--
   g_package_name CONSTANT varchar2(30) := 'nm3inv_view';
--
   g_inv_view_exception EXCEPTION;
   g_inv_view_exc_code  number;
   g_inv_view_exc_msg   varchar2(4000);
--
   c_application_owner CONSTANT varchar2(30) := hig.get_application_owner;
--
   g_attr_prefix                        varchar2(8) := 'ATTRIB';

   g_mapcapture_holding_table  CONSTANT varchar2(30) := 'NM_LD_MC_ALL_INV_TMP';
   g_mapcapture_installed      CONSTANT boolean      := (NVL(hig.get_sysopt('MAPCAPTURE'),'N')='Y');
   g_create_inv_on_route_views CONSTANT boolean      := (NVL(hig.get_sysopt('INVROUTEVW'),'N')='Y');
--
   CURSOR cs_all_attribs (c_inv_type varchar2) IS
   SELECT *
    FROM  nm_inv_type_attribs
   WHERE  ita_inv_type = c_inv_type
   ORDER BY ita_disp_seq_no;
--
   l_tab_iit_column      nm3type.tab_varchar2000;
   l_tab_view_column     nm3type.tab_varchar30;
   l_tab_flex_column     nm3type.tab_boolean;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_inv_instead_of_trigger(p_inv_type nm_inv_types.nit_inv_type%TYPE);
--
----------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------
--
PROCEDURE create_view (p_inventory_type  IN nm_inv_types.nit_inv_type%TYPE
                      ,p_join_to_network IN boolean DEFAULT FALSE
                      ) IS
--
   l_comment_sql     varchar2(32767);
--
   l_view_name user_views.view_name%TYPE := work_out_inv_type_view_name(p_inventory_type,p_join_to_network);
--
   l_inv_view_text varchar2(32767);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_view');
--
   l_inv_view_text := get_create_inv_view_text (p_inventory_type,p_join_to_network);

--   nm_debug.debug(l_inv_view_text);

   --drop view first as it is safer than just create or replacing it
   --Oracle gets knickers in twist when there is an instead of trigger
   DECLARE
     e_view_does_not_exist EXCEPTION;
     PRAGMA EXCEPTION_INIT(e_view_does_not_exist, -942);

   BEGIN
     EXECUTE IMMEDIATE 'drop view ' || l_view_name;

   EXCEPTION
     WHEN e_view_does_not_exist
     THEN
       NULL;

   END;

   nm3ddl.create_object_and_syns(l_view_name
                                ,l_inv_view_text
                                );
--
   IF nm3inv.get_inv_type(p_inventory_type).nit_update_allowed = 'N'
    AND NOT p_join_to_network
    THEN
      -- System Data - Create instead of trigger
      create_inv_instead_of_trigger(p_inventory_type);
   END IF;
--
   l_comment_sql :=  'COMMENT ON TABLE '||l_view_name||' IS '
                     ||CHR(39)||'View for inventory type '||p_inventory_type;
   IF p_join_to_network
    THEN
      l_comment_sql := l_comment_sql||' joined to network';
   END IF;
   l_comment_sql := l_comment_sql||', generated '||TO_CHAR(SYSDATE,'HH24:MI:SS DD-Mon-YYYY')||CHR(39);
--
   EXECUTE IMMEDIATE l_comment_sql;
--
   IF NOT p_join_to_network
    AND nm3inv_api_gen.g_create_api_inv_packs
    THEN
      nm3inv_api_gen.build_one (p_inventory_type);
   END IF;
   IF   p_join_to_network
    AND g_create_inv_on_route_views
    THEN
      create_inv_on_route_view (pi_inv_type => p_inventory_type);
   END IF;

   IF p_join_to_network
    THEN
      create_inv_nw_trigger( pi_inv_type => p_inventory_type );
   END IF;
--
   nm_debug.proc_end(g_package_name,'create_view');
--
END create_view;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_inv_view (p_inventory_type  IN  nm_inv_types.nit_inv_type%TYPE
                          ,p_join_to_network IN  boolean DEFAULT FALSE
                          ,p_view_name       OUT user_views.view_name%TYPE
                          ) IS
--
   specified_view_in_use EXCEPTION;
   PRAGMA EXCEPTION_INIT (specified_view_in_use,-20002);
--
   CURSOR cs_nin (c_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   SELECT 1
    FROM  nm_inv_nw
   WHERE  nin_nit_inv_code = c_inv_type;
--
   l_join_to_network boolean := p_join_to_network;
   l_dummy           pls_integer;

   l_plsql nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_inv_view');
--
   IF l_join_to_network
    THEN
      --
      -- If we are asking to create the _NW view, only do it if there is a NM_INV_NW record for this item
      --
      OPEN  cs_nin (p_inventory_type);
      FETCH cs_nin INTO l_dummy;
      l_join_to_network := cs_nin%FOUND;
      CLOSE cs_nin;
   END IF;
--
   p_view_name := work_out_inv_type_view_name(p_inventory_type,l_join_to_network);
--
   create_view(p_inventory_type,l_join_to_network);
--
   IF g_mapcapture_installed
    THEN
      create_mapcapture_csv_metadata(p_inventory_type);
   END IF;
--
   --------------------------------------------
   --Structural Projects road construction view
   --------------------------------------------
   IF NOT l_join_to_network
     AND hig.is_product_licensed(pi_product => nm3type.c_stp)
     AND nm3inv.get_inv_type(pi_inv_type => p_inventory_type).nit_category = nm3type.c_stp_nit_category
   THEN
     l_plsql :=               'BEGIN'
                || CHR(10) || '  stp_view.create_rc_inv_view(pi_rc_inv_view_name => :p_view_name);'
                || CHR(10) || 'END;';

     EXECUTE IMMEDIATE l_plsql USING p_view_name;
   END IF;

   nm_debug.proc_end(g_package_name,'create_inv_view');
--
END create_inv_view;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_common_columns RETURN nm3type.tab_varchar30 IS
l_std_cols nm3type.tab_varchar30;
BEGIN

   l_std_cols(l_std_cols.COUNT+1) := 'iit_ne_id';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_inv_type';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_primary_key';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_start_date';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_date_created';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_date_modified';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_created_by';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_modified_by';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_admin_unit';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_descr';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_note';
   l_std_cols(l_std_cols.COUNT+1) := 'iit_peo_invent_by_id';

   RETURN l_std_cols;
END get_common_columns;
--
-----------------------------------------------------------------------------
--
FUNCTION get_create_inv_view_text (p_inventory_type   IN nm_inv_types.nit_inv_type%TYPE
                                  ,p_join_to_network  IN boolean DEFAULT FALSE
                                  ) RETURN varchar2 IS
--
   l_create_view_sql      varchar2(32767);
--
   inv_type_is_ft      EXCEPTION;
--
   c_new_line CONSTANT varchar2(1) := CHR(10);
--
   l_view_name user_views.view_name%TYPE := work_out_inv_type_view_name(p_inventory_type,p_join_to_network);
--
   l_rec_nit nm_inv_types%ROWTYPE := nm3inv.get_inv_type(p_inventory_type);
--
   l_get_route_measures boolean;
--
   CURSOR cs_nin (c_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   SELECT nt_type
         ,nt_length_unit
    FROM  nm_inv_nw
         ,nm_types
   WHERE  nin_nit_inv_code = c_inv_type
    AND   nin_nw_type      = nt_type;
--
   CURSOR cs_nti (c_child_type nm_type_inclusion.nti_nw_child_type%TYPE) IS
   SELECT nt_type
         ,nt_length_unit
    FROM  nm_type_inclusion
         ,nm_types
   WHERE  nti_nw_child_type  = c_child_type
    AND   nti_nw_parent_type = nt_type;
   l_cs_nti cs_nti%ROWTYPE;
   CURSOR cs_uc (c_parent number
                ,c_child  number
                ) IS
   SELECT uc_function
    FROM  nm_unit_conversions
   WHERE  uc_unit_id_in = c_child
    AND   uc_unit_id_out = c_parent;
   l_func nm_unit_conversions.uc_function%TYPE;
--
   l_tab_conversion_st  nm3type.tab_varchar2000;
   l_tab_conversion_end nm3type.tab_varchar2000;
--
   l_tab_datum_nt_type nm3type.tab_varchar30;
   l_tab_datum_unit    nm3type.tab_number;
   l_tab_std_cols      nm3type.tab_varchar30;
--
   l_decode_on_nt_reqd boolean := FALSE;
--
   l_comma varchar2(1);
--
   PROCEDURE add_col_to_arrays (p_iit_col  varchar2
                               ,p_view_col varchar2 DEFAULT NULL
                               ,p_flex_col BOOLEAN  DEFAULT FALSE
                               ) IS
   BEGIN
      l_tab_iit_column(l_tab_iit_column.COUNT+1)   := p_iit_col;
      l_tab_view_column(l_tab_view_column.COUNT+1) := NVL(p_view_col,p_iit_col);
      l_tab_flex_column(l_tab_flex_column.COUNT+1) := p_flex_col;
   END add_col_to_arrays;
--
BEGIN
--
   IF l_rec_nit.nit_table_name IS NOT NULL
    THEN
      -- This is a foreign table, bail out
      RAISE inv_type_is_ft;
   END IF;
--
   IF NOT p_join_to_network
    OR NVL(hig.get_sysopt('INVVIEWSLK'),'N') != 'Y'
    THEN
      l_get_route_measures := FALSE;
   ELSE
      l_get_route_measures := TRUE;
   --
      OPEN  cs_nin (p_inventory_type);
      FETCH cs_nin BULK COLLECT INTO l_tab_datum_nt_type, l_tab_datum_unit;
      CLOSE cs_nin;
   --
      FOR i IN 1..l_tab_datum_nt_type.COUNT
       LOOP
         OPEN  cs_nti (l_tab_datum_nt_type(i));
         FETCH cs_nti INTO l_cs_nti;
         IF  cs_nti%NOTFOUND
          OR l_cs_nti.nt_length_unit = l_tab_datum_unit(i)
          THEN
            l_tab_conversion_st(i)  := 'decode( route_mem.nm_cardinality, 1, route_mem.nm_slk + inv_mem.nm_begin_mp, '||
                                        '  -1, route_mem.nm_end_slk - inv_mem.nm_end_mp )';
            l_tab_conversion_end(i) := 'decode( route_mem.nm_cardinality, 1, route_mem.nm_slk + inv_mem.nm_end_mp'||
                                        '  -1, route_mem.nm_end_slk - inv_mem.nm_begin_mp )';
         ELSE
            OPEN  cs_uc (l_cs_nti.nt_length_unit,l_tab_datum_unit(i));
            FETCH cs_uc INTO l_func;
            CLOSE cs_uc;
            l_tab_conversion_st(i)  := 'decode( route_mem.nm_cardinality, 1, route_mem.nm_slk + DECODE(inv_mem.nm_begin_mp,0,0,'||l_func||'(inv_mem.nm_begin_mp)), '||
                                        '  -1, route_mem.nm_end_slk - '||l_func||'(inv_mem.nm_end_mp) )';
            l_tab_conversion_end(i) := 'decode( route_mem.nm_cardinality, 1, route_mem.nm_slk + '||l_func||'(inv_mem.nm_end_mp)'||
                                        '  -1, route_mem.nm_end_slk - DECODE(inv_mem.nm_begin_mp,0,0,'||l_func||'(inv_mem.nm_begin_mp)) )';

            l_tab_conversion_st(i)  := 'route_mem.nm_slk + DECODE(inv_mem.nm_begin_mp,0,0,'||l_func||'(inv_mem.nm_begin_mp))';
            l_tab_conversion_end(i) := 'route_mem.nm_slk + '||l_func||'(inv_mem.nm_end_mp)';
         END IF;
         CLOSE cs_nti;
      END LOOP;
   --
      FOR i IN 2..l_tab_conversion_st.COUNT
       LOOP
         IF l_tab_conversion_st(i) != l_tab_conversion_st(i-1)
          THEN
            l_decode_on_nt_reqd := TRUE;
         END IF;
      END LOOP;
--
   END IF;
--
   l_tab_iit_column.DELETE;
   l_tab_view_column.DELETE;
--
   l_tab_std_cols := get_common_columns;

   FOR i IN 1..l_tab_std_cols.COUNT
    LOOP
      add_col_to_arrays(l_tab_std_cols(i));
   END LOOP;

   IF l_rec_nit.nit_update_allowed = 'Y'
   THEN
     -- if not update_allowed we cannot have function based columns
     -- as they will prevents inserts throught the view
     add_col_to_arrays ('SUBSTR(nm3ausec.get_nau_unit_code(iit_admin_unit),1,10)','nau_unit_code');
   END IF;

   IF l_rec_nit.nit_x_sect_allow_flag = 'Y'
    THEN
      add_col_to_arrays ('iit_x_sect');
   END IF;
   add_col_to_arrays ('iit_end_date');
--
   l_create_view_sql := 'CREATE OR REPLACE FORCE VIEW '||hig.get_application_owner||'.'||l_view_name||c_new_line||' AS ';
   l_create_view_sql := l_create_view_sql||'SELECT ';
   IF    p_join_to_network
    AND l_get_route_measures
    THEN
      l_create_view_sql := l_create_view_sql||' /*+ INDEX (nm_inv_items iit_nit_fk_ind) */ ';
   END IF;
   l_create_view_sql := l_create_view_sql||c_new_line||
                        '--'||c_new_line||
                        '-- View "'||l_view_name||'" for inv_type "'||p_inventory_type||
                        '" built '||TO_CHAR(SYSDATE,'HH24:MI:SS DD-MON-YYYY')||c_new_line||
                        '--  by user "'||USER||'"'||c_new_line||
                        '--'||c_new_line||
                        '--'||get_version||c_new_line||
                        '--'||get_body_version||c_new_line||
                        '--'||c_new_line;
   l_comma := ' ';
   FOR i IN 1..l_tab_iit_column.COUNT
    LOOP
      l_create_view_sql := l_create_view_sql||'      '||l_comma||l_tab_iit_column(i)||' '||l_tab_view_column(i)||c_new_line;
      l_comma := ',';
   END LOOP;
--
   FOR each_attribute IN cs_all_attribs (p_inventory_type)
    LOOP
--
      DECLARE
         l_before_format varchar2(30) := NULL;
         l_after_format  varchar2(30) := NULL;
         l_view_col_name varchar2(30);
      BEGIN
--
         IF    SUBSTR(each_attribute.ita_attrib_name,1,14) = 'IIT_CHR_ATTRIB'
          AND  each_attribute.ita_fld_length               > 0
          AND  l_rec_nit.nit_update_allowed = 'Y'  -- if not update_allowed we cannot have function based columns
                                                   -- as they will prevents inserts throught the view
          THEN
            l_before_format := 'SUBSTR(';
            l_after_format  := ',1,'||each_attribute.ita_fld_length||')';
         END IF;
--
         l_view_col_name := each_attribute.ita_view_col_name;
--
         add_col_to_arrays (LOWER(each_attribute.ita_attrib_name),l_view_col_name, TRUE);
         l_create_view_sql := l_create_view_sql
                              ||'      ,'||l_before_format||LOWER(each_attribute.ita_attrib_name)||l_after_format
                              ||' '||l_view_col_name||c_new_line;
--
      END;
--
   END LOOP;
--
   IF p_join_to_network
    THEN
      l_create_view_sql := l_create_view_sql
                           ||'      -- NM_MEMBERS columns'||c_new_line
                           ||'      ,inv_mem.nm_ne_id_of ne_id_of'||c_new_line
                           ||'      ,nm3net.get_ne_unique(inv_mem.nm_ne_id_of) member_unique'||c_new_line
                           ||'      ,inv_mem.nm_begin_mp'||c_new_line
                           ||'      ,inv_mem.nm_end_mp'||c_new_line
                           ||'      ,inv_mem.nm_seq_no'||c_new_line
                           ||'      ,inv_mem.nm_start_date'||c_new_line
                           ||'      ,inv_mem.nm_end_date'||c_new_line;
      IF l_rec_nit.nit_linear = 'Y'
       THEN
         l_create_view_sql := l_create_view_sql
                           ||'      ,inv_mem.nm_slk'||c_new_line
                           ||'      ,inv_mem.nm_seg_no'||c_new_line
                           ||'      ,inv_mem.nm_cardinality'||c_new_line;
      END IF;
      l_create_view_sql := l_create_view_sql
                           ||'      ,inv_mem.nm_admin_unit'||c_new_line;
      IF l_get_route_measures
       THEN
         l_create_view_sql := l_create_view_sql
                           ||'      -- columns added because of getting parent SLK'||c_new_line;
         IF l_tab_datum_nt_type.COUNT = 1
          THEN
            l_create_view_sql := l_create_view_sql
                           ||'      ,SUBSTR(nm3net.get_ne_unique(inv_mem.nm_ne_id_of),1,30) datum_ne_unique'||c_new_line;
         ELSE
            l_create_view_sql := l_create_view_sql
                           ||'      ,datum.ne_unique datum_ne_unique'||c_new_line;
         END IF;
         l_create_view_sql := l_create_view_sql
                           ||'      ,SUBSTR(nm3net.get_ne_unique(route_mem.nm_ne_id_in),1,30) route_ne_unique'||c_new_line
                           ||'      ,route_mem.nm_ne_id_in route_ne_id'||c_new_line;
         IF l_tab_datum_nt_type.COUNT > 0
          THEN
            IF l_decode_on_nt_reqd
             THEN
               l_create_view_sql := l_create_view_sql
                                 ||'      ,DECODE(datum.ne_nt_type'||c_new_line;
               FOR i IN 1..l_tab_datum_nt_type.COUNT
                LOOP
                  l_create_view_sql := l_create_view_sql
                                 ||'             ,'||nm3flx.string(l_tab_datum_nt_type(i))||','||l_tab_conversion_st(i)||c_new_line;
               END LOOP;
               l_create_view_sql := l_create_view_sql
                                 ||'             ) route_slk_start'||c_new_line;
      --
               IF l_rec_nit.nit_pnt_or_cont = 'C'
                THEN
                  l_create_view_sql := l_create_view_sql
                                    ||'      ,DECODE(datum.ne_nt_type'||c_new_line;
                  FOR i IN 1..l_tab_datum_nt_type.COUNT
                   LOOP
                     l_create_view_sql := l_create_view_sql
                                    ||'             ,'||nm3flx.string(l_tab_datum_nt_type(i))||','||l_tab_conversion_end(i)||c_new_line;
                  END LOOP;
                  l_create_view_sql := l_create_view_sql
                                    ||'             ) route_slk_end'||c_new_line;
               END IF;
            ELSE
               -- Only 1 NT or they are all the same, so no decode required
               l_create_view_sql := l_create_view_sql
                                 ||'      ,'||l_tab_conversion_st(1)||' route_slk_start'||c_new_line;
               l_create_view_sql := l_create_view_sql
                                 ||'      ,'||l_tab_conversion_end(1)||' route_slk_end'||c_new_line;
            END IF;
         END IF;
--
      END IF;
   END IF;
--
   l_create_view_sql := l_create_view_sql||' FROM  nm_inv_items inv'||c_new_line;
--
   IF p_join_to_network
    THEN
      l_create_view_sql := l_create_view_sql||'      ,nm_members   inv_mem'||c_new_line;
      IF l_get_route_measures
       THEN
         IF l_tab_datum_nt_type.COUNT != 1
          THEN
            l_create_view_sql := l_create_view_sql||'      ,nm_elements  datum'||c_new_line;
         END IF;
         l_create_view_sql := l_create_view_sql||'      ,nm_members   route_mem'||c_new_line;
      END IF;
   END IF;
--
   l_create_view_sql := l_create_view_sql||' WHERE iit_inv_type                = '||nm3flx.string(p_inventory_type)||c_new_line;
--
   IF p_join_to_network
    THEN
      l_create_view_sql := l_create_view_sql||'  AND  inv_mem.nm_ne_id_in';
      IF l_rec_nit.nit_use_xy = 'Y'
       THEN
          l_create_view_sql := l_create_view_sql||'(+)';
      END IF;
      l_create_view_sql := l_create_view_sql||  '         = iit_ne_id'||c_new_line;
    IF l_get_route_measures
       THEN
         l_create_view_sql := l_create_view_sql||'  AND  route_mem.nm_ne_id_of       = inv_mem.nm_ne_id_of'||c_new_line;
         IF l_tab_datum_nt_type.COUNT != 1
          THEN
            l_create_view_sql := l_create_view_sql||'  AND  inv_mem.nm_ne_id_of         = datum.ne_id'||c_new_line;
         END IF;
         l_create_view_sql := l_create_view_sql||'  AND  route_mem.nm_type           = '||nm3flx.string('G')||c_new_line;
         DECLARE
            CURSOR cs_ngt_group_type (c_datum_type varchar2) IS
            SELECT ngt_group_type
             FROM  nm_group_types
                  ,nm_type_inclusion
            WHERE  nti_nw_child_type = c_datum_type
             AND   ngt_nt_type       = nti_nw_parent_type;
            l_autoinc_group_type     nm_group_types.ngt_group_type%TYPE := nm3type.c_nvl;
         BEGIN
            l_create_view_sql := l_create_view_sql||'  AND  route_mem.nm_obj_type = ';
            IF l_tab_datum_nt_type.COUNT > 1
             THEN
               l_create_view_sql := l_create_view_sql||'DECODE(datum.ne_nt_type'||c_new_line;
               FOR i IN 1..l_tab_datum_nt_type.COUNT
                LOOP
                  l_autoinc_group_type := nm3type.c_nvl;
                  OPEN  cs_ngt_group_type (l_tab_datum_nt_type(i));
                  FETCH cs_ngt_group_type INTO l_autoinc_group_type;
                  CLOSE cs_ngt_group_type;
                  l_create_view_sql := l_create_view_sql
                           ||'                                           ,'||nm3flx.string(l_tab_datum_nt_type(i))||','||nm3flx.string(l_autoinc_group_type)||c_new_line;
               END LOOP;
               l_create_view_sql := l_create_view_sql||'                                           )';
            ELSIF l_tab_datum_nt_type.COUNT = 1
             THEN
               l_autoinc_group_type := nm3type.c_nvl;
               OPEN  cs_ngt_group_type (l_tab_datum_nt_type(1));
               FETCH cs_ngt_group_type INTO l_autoinc_group_type;
               CLOSE cs_ngt_group_type;
               l_create_view_sql := l_create_view_sql||nm3flx.string(l_autoinc_group_type);
            END IF;
            l_create_view_sql := l_create_view_sql||' /* Null is concatentated to suppress the use of the NM_MEMBERS_ALL.NM_OBJ_TYPE_IND index */'||c_new_line;
         END;
      END IF;
   END IF;
--
   -- Make view READ ONLY
   IF   NOT p_join_to_network
    AND l_rec_nit.nit_update_allowed = 'Y'
    THEN
      l_create_view_sql := l_create_view_sql||' WITH READ ONLY';
   END IF;
--
--   nm_debug.debug(l_create_view_sql);
   RETURN l_create_view_sql;
--
EXCEPTION
--
  WHEN inv_type_is_ft
   THEN
     RAISE_APPLICATION_ERROR( -20001, 'View cannot be created for INV_TYPES with foreign tables');
--
END get_create_inv_view_text;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_all_inv_views IS

--TYPE l_TYPE_ROLES_REC IS RECORD
--(NM_INV_TYPE_ROLES%rowtype);

TYPE l_TYPE_ROLES_TAB IS
table of NM_INV_TYPE_ROLES%rowtype;

BEGIN
--
   nm_debug.proc_start(g_package_name,'create_all_inv_views');
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
   DBMS_OUTPUT.ENABLE(1000000);
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_inv_types
                  WHERE  nit_table_name IS NULL -- ### Don't do Foreign Tables
                  ORDER BY nit_inv_type
                 )
    LOOP
      DECLARE
         l_current_view_name user_views.view_name%TYPE;
         l_created_string    varchar2(80) := 'Created ';
      BEGIN
--
--       Create the inventory views
--
--         nm_debug.debug('Pre call to create_inv_view (no network)',4);
         create_inv_view (cs_rec.nit_inv_type
                         ,FALSE
                         ,l_current_view_name
                         );
--
         l_created_string    := l_created_string||' - '||l_current_view_name;
--
--       Create the inventory views joined to the network
--
--         nm_debug.debug('Pre call to create_inv_view (network)',4);
         create_inv_view (cs_rec.nit_inv_type
                         ,TRUE
                         ,l_current_view_name
                         );
--
         l_created_string    := l_created_string||' - '||l_current_view_name;
--
         DBMS_OUTPUT.PUT_LINE (l_created_string);
--         nm_debug.debug(l_created_string);
--
      EXCEPTION
          WHEN others
           THEN
--
             DBMS_OUTPUT.PUT_LINE ('ERROR '||l_current_view_name);
             DBMS_OUTPUT.PUT_LINE ('......'||SUBSTR(SQLERRM,1,74));
--             nm_debug.debug('ERROR : '||l_current_view_name||' : '||SQLERRM);
--
      END;
   END LOOP;
--   nm_debug_off;
--
   nm_debug.proc_end(g_package_name,'create_all_inv_views');
--
END create_all_inv_views;
--
----------------------------------------------------------------------------------------------
--
FUNCTION work_out_inv_type_view_name (pi_inv_type         IN nm_inv_types.nit_inv_type%TYPE
                                     ,pi_join_to_network  IN boolean DEFAULT FALSE
                                     ) RETURN varchar2 IS
--
   l_view_name user_views.view_name%TYPE;
--
BEGIN
--
   IF pi_join_to_network
    THEN
      l_view_name := derive_nw_inv_type_view_name(pi_inv_type);
   ELSE
      l_view_name := derive_inv_type_view_name(pi_inv_type);
   END IF;
--
   RETURN l_view_name;
--
END work_out_inv_type_view_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION derive_inv_type_view_name (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE) RETURN varchar2 IS
BEGIN
--
   RETURN 'V_NM_'||pi_inv_type;
--
END derive_inv_type_view_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_mapcapture_csv_unique_ref (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE) RETURN varchar2 IS
BEGIN
--
   RETURN  'MC_'||pi_inv_type||'_INV';
--
END get_mapcapture_csv_unique_ref;
--
----------------------------------------------------------------------------------------------
--
FUNCTION get_mapcapture_load_dest (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE) RETURN varchar2 IS
BEGIN
--
   RETURN 'NM_LD_MC_ALL_INV_TMP';
--
END get_mapcapture_load_dest;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_on_route_view_name (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE) RETURN varchar2 IS
BEGIN
--
   RETURN 'V_NM_'||pi_inv_type||'_ON_ROUTE';
--
END get_inv_on_route_view_name;
--
----------------------------------------------------------------------------------------------
--
FUNCTION derive_nw_inv_type_view_name (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE) RETURN varchar2 IS
BEGIN
--
   RETURN derive_inv_type_view_name(pi_inv_type)||'_NW';
--
END derive_nw_inv_type_view_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_mapcapture_csv_metadata (pi_inv_type    varchar2)
IS
--
  PRAGMA autonomous_transaction;

  l_mc_descr  CONSTANT nm_load_files.nlf_descr%TYPE := 'MapCapture load file definition for inventory type ';

  l_load_file_name nm_load_files.nlf_unique%TYPE := get_mapcapture_csv_unique_ref(pi_inv_type);
  l_nlf_rec        nm_load_files%ROWTYPE;
  l_nlfc_rec       nm_load_file_cols%ROWTYPE;
  l_nld_rec        nm_load_destinations%ROWTYPE;
  l_nlfd_rec       nm_load_file_destinations%ROWTYPE;
  l_mc_cols        nm3ddl.tab_atc;
  l_std_cols       nm3type.tab_varchar30 := get_common_columns;
  --
  FUNCTION column_already_defined(pi_nlf_id IN nm_load_files.nlf_id%TYPE
                                 ,pio_col   IN OUT varchar2) RETURN boolean IS
  CURSOR get_col(p_nlf_id IN nm_load_files.nlf_id%TYPE
                ,p_col    IN nm_load_file_cols.nlfc_holding_col%TYPE) IS
  SELECT 1
  FROM   nm_load_file_cols nlfc
  WHERE  nlfc.nlfc_nlf_id = p_nlf_id
  AND    nlfc.nlfc_holding_col = p_col;

  dummy   pls_integer;
  l_found boolean;
  BEGIN
    -- iit_x_sect comes at the end of the record so dont allow it anywhere else
    -- It is also recorded against some inventory types and not all and so causes
    -- MapCapture problems
    IF pio_col IN ('IIT_X_SECT') THEN
      RETURN TRUE;
    END IF;
    OPEN get_col(pi_nlf_id
                ,pio_col);
    FETCH get_col INTO dummy;
    l_found := get_col%FOUND;
    CLOSE get_col;
    IF l_found THEN
       IF pio_col = 'IIT_PRIMARY_KEY' THEN
         -- the primary key is allowed as an attribute
         -- so if it already exists as a holding column assign it to another column
         pio_col := 'NLM_PRIMARY_KEY';
         RETURN FALSE;
       ELSE
         RETURN TRUE;
       END IF;
    ELSE
       RETURN FALSE;
    END IF;
  END column_already_defined;
  --
  FUNCTION get_column_name (pi_column IN varchar2
                           ,pi_nlf_id IN nm_load_files.nlf_id%TYPE) RETURN varchar2 IS

  l_col varchar2(30) := UPPER(pi_column);
  BEGIN
    -- if the column name is one of the route columns then
    -- do not try to get the attribute
    IF l_col IN ('NE_ID', 'NM_START', 'NM_END', 'IIT_X_SECT', 'IIT_END_DATE', 'NAU_UNIT_CODE') THEN
      RETURN l_col;
    END IF;

    FOR i IN 1..l_std_cols.COUNT LOOP
      IF UPPER(l_std_cols(i)) = l_col THEN
        -- its a standard column so no need to get the column name from the attrbute table
        RETURN l_col;
      END IF;
    END LOOP;

   -- otherwise it is not a common column so we need to look up the actual
   -- inventory column in the attribs table
    l_col := UPPER(nm3inv.get_ita_by_view_col(pi_inv_type      => pi_inv_type
                                             ,pi_view_col_name => l_col).ita_attrib_name);

    RETURN l_col;
  END get_column_name;
  --
  FUNCTION get_next_seq_no (p_nlf_id IN nm_load_files.nlf_id%TYPE) RETURN pls_integer IS
    CURSOR get_seq (p_nlf_id IN nm_load_files.nlf_id%TYPE) IS
    SELECT NVL(MAX(nlfc_seq_no),0)
    FROM   nm_load_file_cols
    WHERE  nlfc_nlf_id = p_nlf_id;

    l_retval pls_integer;
  BEGIN
    OPEN get_seq(p_nlf_id);
    FETCH get_seq INTO l_retval;
    CLOSE get_seq;

    RETURN l_retval +1;
  END get_next_seq_no;
  --
  PROCEDURE insert_extra_columns(p_nlf_id IN nm_load_files.nlf_id%TYPE) IS
  l_extra_rec nm_load_file_cols%ROWTYPE;
  BEGIN

      l_extra_rec.nlfc_nlf_id           := p_nlf_id;
      l_extra_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
      l_extra_rec.nlfc_holding_col      := 'NLM_X_SECT';
      l_extra_rec.nlfc_datatype         := 'VARCHAR2';
      l_extra_rec.nlfc_varchar_size     := 4;
      l_extra_rec.nlfc_date_format_mask := NULL;
      l_extra_rec.nlfc_mandatory        := 'N';

      nm3ins.ins_nlfc(l_extra_rec);

      l_extra_rec.nlfc_nlf_id           := p_nlf_id;
      l_extra_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
      l_extra_rec.nlfc_holding_col      := 'NLM_INVENT_DATE';
      l_extra_rec.nlfc_datatype         := 'DATE';
      l_extra_rec.nlfc_varchar_size     := NULL;
      l_extra_rec.nlfc_date_format_mask := nm3mapcapture_int.c_date_format;
      l_extra_rec.nlfc_mandatory        := 'Y';

      nm3ins.ins_nlfc(l_extra_rec);

      l_extra_rec.nlfc_nlf_id           := p_nlf_id;
      l_extra_rec.nlfc_seq_no           := get_next_seq_no(p_nlf_id);
      l_extra_rec.nlfc_holding_col      := 'NLM_ACTION_CODE';
      l_extra_rec.nlfc_datatype         := 'VARCHAR2';
      l_extra_rec.nlfc_varchar_size     := 1;
      l_extra_rec.nlfc_date_format_mask := NULL;
      l_extra_rec.nlfc_mandatory        := 'Y';

      nm3ins.ins_nlfc(l_extra_rec);
  END insert_extra_columns;
BEGIN

  nm_debug.proc_start(g_package_name,'create_mapcapture_csv_metadata');

  -- first check that the mapcap_dir is set
  IF hig.get_sysopt('MAPCAP_DIR') IS NULL THEN
    hig.raise_ner(pi_appl               => nm3type.c_hig
                 ,pi_id                 => 163
                 ,pi_supplementary_info => 'MAPCAP_DIR');
  END IF;

  -- delete previous definition first
  nm3del.del_nlf(pi_nlf_unique => l_load_file_name
                ,pi_raise_not_found => FALSE);

  -- check that the view exists
  IF nm3ddl.does_object_exist(p_object_name => nm3inv_view.get_inv_on_route_view_name(pi_inv_type)
                             ,p_object_type => 'VIEW') THEN
    l_nlf_rec.nlf_id     := nm3load.get_next_nlf_id;
    l_nlf_rec.nlf_unique := l_load_file_name;
    l_nlf_rec.nlf_descr  := l_mc_descr||pi_inv_type;
    l_nlf_rec.nlf_path   := hig.get_sysopt('MAPCAP_DIR');
    l_nlf_rec.nlf_delimiter := CHR(44);
    l_nlf_rec.nlf_date_format_mask := nm3mapcapture_int.c_date_format;
    l_nlf_rec.nlf_holding_table := g_mapcapture_holding_table;

    nm3ins.ins_nlf(p_rec_nlf => l_nlf_rec);

    -- now create the file columns based on the definition of
    -- the inv_on_route view. Which MapCapture selects from to get
    -- the inventory in the first place
    l_mc_cols := nm3ddl.get_all_columns_for_table(nm3inv_view.get_inv_on_route_view_name(pi_inv_type));
    FOR i IN 1..l_mc_cols.COUNT LOOP

      l_nlfc_rec.nlfc_holding_col      := get_column_name(l_mc_cols(i).column_name
                                                         ,l_nlf_rec.nlf_id);

      IF NOT column_already_defined(l_nlf_rec.nlf_id
                                   ,l_nlfc_rec.nlfc_holding_col) THEN

        l_nlfc_rec.nlfc_nlf_id           := l_nlf_rec.nlf_id;
        l_nlfc_rec.nlfc_seq_no           := get_next_seq_no(l_nlf_rec.nlf_id);
        l_nlfc_rec.nlfc_datatype         := l_mc_cols(i).data_type;

        IF l_mc_cols(i).data_type = 'VARCHAR2' THEN
          l_nlfc_rec.nlfc_varchar_size     := l_mc_cols(i).data_length;
          l_nlfc_rec.nlfc_date_format_mask := NULL;
        ELSIF l_mc_cols(i).data_type = 'DATE' THEN
          l_nlfc_rec.nlfc_varchar_size := NULL;
          l_nlfc_rec.nlfc_date_format_mask := l_nlf_rec.nlf_date_format_mask;
        ELSE
          l_nlfc_rec.nlfc_varchar_size := NULL;
          l_nlfc_rec.nlfc_date_format_mask := NULL;
        END IF;

        IF l_mc_cols(i).nullable = 'N' THEN
          l_nlfc_rec.nlfc_mandatory := 'Y';
        ELSE
          l_nlfc_rec.nlfc_mandatory := 'N';
        END IF;

        nm3ins.ins_nlfc(l_nlfc_rec);

      END IF;

    END LOOP;

    insert_extra_columns(l_nlf_rec.nlf_id);

    -- now create the file destination defnintions
    -- get the destination
    l_nld_rec := nm3get.get_nld(pi_nld_table_name => get_mapcapture_load_dest(pi_inv_type));

    l_nlfd_rec.nlfd_nlf_id := l_nlf_rec.nlf_id;
    l_nlfd_rec.nlfd_nld_id := l_nld_rec.nld_id;
    l_nlfd_rec.nlfd_seq    := 1;

    nm3ins.ins_nlfd(p_rec_nlfd => l_nlfd_rec);

    -- trigger on nm_load_file_destinations fires and creates a file_destination column for
    -- every column in the holding table.

    -- now add the destination columns
    -- to values supplied in the file

    UPDATE nm_load_file_col_destinations
    SET    nlcd_source_col = l_nlf_rec.nlf_unique||'.'||nlcd_dest_col
    WHERE  nlcd_nlf_id = l_nlf_rec.nlf_id
    AND    nlcd_nld_id = l_nld_rec.nld_id
    AND   (nlcd_dest_col IN (SELECT nlfc_holding_col
                             FROM nm_load_file_cols nlfc
                             WHERE nlfc_nlf_id = l_nlf_rec.nlf_id)
       OR  nlcd_dest_col IN ('BATCH_NO', 'RECORD_NO')); -- need to copy over the batch and record nu

  END IF;

  COMMIT;
  nm_debug.proc_end(g_package_name,'create_mapcapture_csv_metadata');
END create_mapcapture_csv_metadata;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_all_mapcapture_csv_data IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_all_mapcapture_csv_data');
--
   FOR cs_rec IN (SELECT nit_inv_type
                   FROM  nm_inv_types
                  WHERE  nit_table_name IS NULL -- ### Don't do Foreign Tables
                  ORDER BY nit_inv_type
                 )
   LOOP
      create_mapcapture_csv_metadata (cs_rec.nit_inv_type);
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'create_all_mapcapture_csv_data');
--
END create_all_mapcapture_csv_data;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_all_ft_inv_for_nt_type (pi_delete_existing_inv_type IN boolean DEFAULT FALSE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_all_ft_inv_for_nt_type');
--
   FOR cs_rec IN (SELECT nt_type
                   FROM  nm_types
                  WHERE  nt_linear = 'Y'
                   AND   nt_datum  = 'Y'
                 )
    LOOP
      create_ft_inv_for_nt_type (pi_nt_type                  => cs_rec.nt_type
                                ,pi_inv_type                 => NULL
                                ,pi_delete_existing_inv_type => pi_delete_existing_inv_type
                                );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'create_all_ft_inv_for_nt_type');
--
END create_all_ft_inv_for_nt_type;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_ft_inv_for_nt_type (pi_nt_type                  IN varchar2
                                    ,pi_inv_type                 IN varchar2 DEFAULT NULL
                                    ,pi_delete_existing_inv_type IN boolean  DEFAULT FALSE
                                    ) IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_nt (c_nt_type varchar2) IS
   SELECT *
    FROM  nm_types
   WHERE  nt_type = c_nt_type;
--
   CURSOR cs_nat (c_nat_admin_type varchar2) IS
   SELECT MIN(nau_start_date)
    FROM  nm_admin_units
   WHERE  nau_admin_type = c_nat_admin_type;
--
   CURSOR cs_lock_existing (c_inv_type varchar2) IS
   SELECT nit_category
    FROM  nm_inv_types
         ,nm_inv_type_attribs
   WHERE  nit_inv_type = c_inv_type
    AND   ita_inv_type = nit_inv_type
   FOR UPDATE NOWAIT;
--
   l_exists_already   boolean;
   l_nit_category     nm_inv_types.nit_category%TYPE;
   c_nit_category CONSTANT nm_inv_types.nit_category%TYPE := 'F';
--
   l_dummy            pls_integer;
--
   l_rec_nt           nm_types%ROWTYPE;
   l_rec_nit          nm_inv_types%ROWTYPE;
   l_rec_ngt          nm_group_types%ROWTYPE;
--
   l_tab_column       nm3type.tab_varchar2000;
   l_tab_alias        nm3type.tab_varchar30;
--
   l_tab_nita         nm3inv.tab_nita;
--
   l_line_begin       varchar2(10) := '       ';
--
   l_inv_type         nm_inv_types.nit_inv_type%TYPE := NVL(pi_inv_type,pi_nt_type);
--
   l_sql varchar2(32767);
--
   l_rec_ntc       nm_type_columns%ROWTYPE;
--
   c_number  CONSTANT varchar2(8) := 'NUMBER';
   c_varchar CONSTANT varchar2(8) := 'VARCHAR2';
   c_date    CONSTANT varchar2(8) := 'DATE';
--
   c_owner   CONSTANT varchar2(30) := hig.get_application_owner;
--
   l_tab_vc   nm3type.tab_varchar32767;
--
-- CWS 703001
    TYPE l_TYPE_ROLES_TAB IS
    table of NM_INV_TYPE_ROLES%rowtype;
--
    TYPE l_TYPE_ATTRIBS_TAB IS
    table of nm_inv_type_attribs_all%rowtype;
--
    l_TYPE_ATTRIBS l_TYPE_ATTRIBS_TAB:= l_TYPE_ATTRIBS_TAB();
--
    l_TYPE_ROLES l_TYPE_ROLES_TAB:= l_TYPE_ROLES_TAB();
--
    l_primary VARCHAR2(1);
    l_rec_ntc2      nm_inv_type_attribs_all%ROWTYPE;
--
   CURSOR chk_for_primary IS
   SELECT 'Y' FROM nm_nw_ad_types
   WHERE nad_nt_type = pi_nt_type
   AND nad_primary_ad = 'Y';
--
   PROCEDURE add_data (p_col_name   varchar2
                      ,p_alias      varchar2
                      ,p_static_col boolean DEFAULT TRUE
                      ) IS
      --
      CURSOR cs_atc (c_owner       varchar2
                    ,c_table_name  varchar2
                    ,c_column_name varchar2
                    ) IS
      SELECT *
       FROM  all_tab_columns
      WHERE  owner      = c_owner
       AND   table_name = c_table_name
       AND   column_name = c_column_name;
      --
      l_rec_atc all_tab_columns%ROWTYPE;
      --
      l_col_name  varchar2(2000);
      l_rec_ita   nm_inv_type_attribs%ROWTYPE;
      --
   BEGIN
--
      l_tab_column(l_tab_column.COUNT+1) := p_col_name;
      l_tab_alias(l_tab_alias.COUNT+1)   := p_alias;
--
      l_rec_ita.ita_inv_type        := l_rec_nit.nit_inv_type;
      l_rec_ita.ita_attrib_name     := NVL(p_alias,p_col_name);
      l_rec_ita.ita_dynamic_attrib  := 'N';
      l_rec_ita.ita_disp_seq_no     := l_tab_column.COUNT*10;
      --
      IF p_static_col
       THEN
         l_col_name := p_col_name;
      ELSE
         l_col_name := l_rec_ntc.ntc_column_name;
      END IF;
      --
      OPEN  cs_atc (c_owner, 'NM_ELEMENTS_ALL',l_col_name);
      FETCH cs_atc INTO l_rec_atc;
      CLOSE cs_atc;
      --
      l_rec_ita.ita_id_domain       := NULL;
      --
      IF p_static_col
       THEN
         IF l_rec_atc.nullable = 'Y'
          THEN
            l_rec_ita.ita_mandatory_yn  := 'N';
         ELSE
            l_rec_ita.ita_mandatory_yn  := 'Y';
         END IF;
         l_rec_ita.ita_format           := NVL(l_rec_atc.data_type,c_varchar);
         IF    l_rec_atc.data_type = c_number
          THEN
            IF l_rec_atc.data_precision IS NOT NULL
             THEN
               l_rec_ita.ita_fld_length := l_rec_atc.data_precision;
               l_rec_ita.ita_dec_places := l_rec_atc.data_scale;
            ELSE
               l_rec_ita.ita_fld_length := 38;
            END IF;
         ELSIF l_rec_atc.data_type = c_varchar
          THEN
            l_rec_ita.ita_fld_length := NVL(l_rec_atc.data_length,38);
         ELSE
            l_rec_ita.ita_fld_length := 11;
         END IF;
      ELSE
         l_rec_ita.ita_mandatory_yn    := l_rec_ntc.ntc_mandatory;
         l_rec_ita.ita_format          := l_rec_ntc.ntc_column_type;
         l_rec_ita.ita_fld_length      := l_rec_ntc.ntc_str_length;
         l_rec_ita.ita_dec_places      := NULL;
         IF l_rec_ntc.ntc_domain IS NOT NULL
          THEN
            l_rec_ita.ita_id_domain    := nm3inv.duplicate_hdo_as_id
                                             (p_hdo_domain      => l_rec_ntc.ntc_domain
                                             ,p_id_start_date   => l_rec_nit.nit_start_date
                                             ,p_optional_prefix => l_rec_nit.nit_inv_type
                                             );
         END IF;
      END IF;
      l_rec_ita.ita_scrn_text       := NVL(l_rec_ntc.ntc_prompt,INITCAP(REPLACE(l_rec_ita.ita_attrib_name,'_',' ')));
      IF SUBSTR(l_rec_ita.ita_scrn_text,1,3) = 'Ne '
       THEN
         l_rec_ita.ita_scrn_text    := SUBSTR(l_rec_ita.ita_scrn_text,4);
      END IF;
      l_rec_ita.ita_validate_yn     := 'N';
      l_rec_ita.ita_dtp_code        := NULL;
      l_rec_ita.ita_max             := NULL;
      l_rec_ita.ita_min             := NULL;
      l_rec_ita.ita_view_attri      := l_rec_ita.ita_attrib_name;
      l_rec_ita.ita_view_col_name   := l_rec_ita.ita_attrib_name;
      l_rec_ita.ita_start_date      := l_rec_nit.nit_start_date;
      l_rec_ita.ita_end_date        := NULL;
      l_rec_ita.ita_queryable       := 'N';
      l_rec_ita.ita_ukpms_param_no  := NULL;
      l_rec_ita.ita_units           := NULL;
      l_rec_ita.ita_format_mask     := NULL;
      l_rec_ita.ita_exclusive       := 'N';
      l_rec_ita.ita_exclusive       := 'N';
      l_rec_ita.ITA_DISPLAYED       := 'Y';
      l_rec_ita.ITA_DISP_WIDTH      := 1;
      --
      l_tab_nita (l_tab_nita.COUNT+1) := l_rec_ita;
--
   END add_data;
--
BEGIN
--
   nm_debug.proc_start(g_package_name, 'create_ft_inv_for_nt_type');
   --
   l_rec_ngt:= nm3get.get_ngt( pi_ngt_group_type => pi_nt_type
                             , pi_raise_not_found => FALSE);
   --
   l_rec_nt:= nm3get.get_nt( pi_nt_type => NVL(l_rec_ngt.ngt_nt_type, pi_nt_type)
                           , pi_raise_not_found => FALSE);
   --
     IF l_rec_nt.nt_type IS NULL
      THEN
        hig.raise_ner(pi_appl               => nm3type.c_net
                     ,pi_id                 => 244
                     ,pi_supplementary_info => pi_nt_type
                     );
     END IF;
   --
  /* IF  l_rec_nt.nt_linear != 'Y'
    OR l_rec_nt.nt_datum  != 'Y'
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 245
                   ,pi_supplementary_info => NULL
                   );
   END IF;*/
--
   OPEN  cs_lock_existing (l_inv_type);
   FETCH cs_lock_existing INTO l_nit_category;
   l_exists_already := cs_lock_existing%FOUND;
   CLOSE cs_lock_existing;
--
   IF l_exists_already
    THEN
      IF pi_delete_existing_inv_type
       THEN
         IF l_nit_category != c_nit_category
          THEN
            hig.raise_ner(pi_appl               => nm3type.c_net
                         ,pi_id                 => 246
                         ,pi_supplementary_info => l_nit_category||' != '||c_nit_category
                         );
         END IF;                
-- CWS 703001
--
         SELECT * BULK COLLECT 
         INTO l_TYPE_ROLES 
         FROM NM_INV_TYPE_ROLES
         WHERE  itr_inv_type = l_inv_type;
         --
         SELECT * BULK COLLECT 
         INTO l_TYPE_ATTRIBS 
         FROM nm_inv_type_attribs_all
         WHERE  ita_inv_type = l_inv_type;
         --
         delete FROM NM_INV_TYPE_ROLES
         WHERE  itr_inv_type = l_inv_type;
         --
         DELETE FROM nm_inv_type_attribs_all
         WHERE  ita_inv_type = l_inv_type;
         
         DELETE FROM nm_inv_types_all
         WHERE  nit_inv_type = l_inv_type;
      ELSE
         hig.raise_ner(pi_appl               => nm3type.c_hig
                      ,pi_id                 => 64
                      ,pi_supplementary_info => l_inv_type
                      );
      END IF;
   END IF;
--
   l_rec_nit.nit_inv_type          := l_inv_type;
   l_rec_nit.nit_pnt_or_cont       := 'C';
   l_rec_nit.nit_x_sect_allow_flag := 'N';
   l_rec_nit.nit_elec_drain_carr   := 'C';
   l_rec_nit.nit_contiguous        := 'N';
   l_rec_nit.nit_replaceable       := 'N';
   l_rec_nit.nit_exclusive         := 'N';
   l_rec_nit.nit_category          := c_nit_category;
   l_rec_nit.nit_descr             := SUBSTR('FT Inv for "'||NVL(l_rec_ngt.ngt_descr,l_rec_nt.nt_descr)||'"',1,80);
   l_rec_nit.nit_linear            := 'N';
   l_rec_nit.nit_use_xy            := 'N';
   l_rec_nit.nit_multiple_allowed  := 'N';
   l_rec_nit.nit_end_loc_only      := 'N';
   l_rec_nit.nit_screen_seq        := NULL;
   l_rec_nit.nit_view_name         := NULL;
   OPEN  cs_nat (l_rec_nt.nt_admin_type);
   FETCH cs_nat INTO l_rec_nit.nit_start_date;
   CLOSE cs_nat;
   l_rec_nit.nit_start_date        := NVL(l_rec_nit.nit_start_date,nm3user.get_effective_date);
   l_rec_nit.nit_end_date          := NULL;
   l_rec_nit.nit_short_descr       := NVL(l_rec_ngt.ngt_descr, l_rec_nt.nt_unique);
   l_rec_nit.nit_flex_item_flag    := 'N';
   --
   IF l_rec_ngt.ngt_group_type IS NULL 
   THEN
     l_rec_nit.nit_table_name        := derive_inv_type_view_name(pi_nt_type)||'_NT';
   ELSE
     l_rec_nit.nit_table_name        := derive_inv_type_view_name(pi_nt_type)||'_'|| l_rec_ngt.ngt_nt_type ||'_NT';
   END IF;
   --
   l_rec_nit.nit_lr_ne_column_name := 'NE_ID';
   l_rec_nit.nit_lr_st_chain       := 'NE_BEGIN_MP';
   l_rec_nit.nit_lr_end_chain      := 'NE_LENGTH';
   l_rec_nit.nit_admin_type        := l_rec_nt.nt_admin_type;
   l_rec_nit.nit_icon_name         := NULL;
   l_rec_nit.nit_top               := 'N';
   l_rec_nit.nit_foreign_pk_column := 'NE_FT_PK_COL';
--
   add_data ('NE_ID',NULL);
   add_data ('NE_ID','NE_FT_PK_COL');
   add_data ('NE_UNIQUE',NULL);
  -- add_data ('TO_NUMBER(0)','NE_BEGIN_MP');
   add_data ('NE_LENGTH',NULL);
   --
   IF l_rec_ngt.ngt_group_type IS NULL
   THEN
     add_data ('NE_NO_START','START_NODE_ID');
     add_data ('NE_NO_END','END_NODE_ID');
   END IF;
   --
   add_data ('NE_DESCR',NULL);
   add_data ('NE_START_DATE',NULL);
   add_data ('NE_END_DATE',NULL);
   add_data ('NE_ADMIN_UNIT',NULL);
   add_data ('SUBSTR(nm3ausec.get_nau_unit_code(NE_ADMIN_UNIT),1,10)','ADMIN_UNIT_CODE');
   add_data ('NE_GTY_GROUP_TYPE',NULL);
   --
   FOR cs_rec IN (SELECT *
                   FROM  nm_type_columns
                  WHERE  ntc_nt_type = pi_nt_type
               ORDER BY  NTC_SEQ_NO)
    LOOP
      l_rec_ntc := cs_rec;
      DECLARE
         l_temp_column varchar2(30);
         l_temp_alias  varchar2(30);
         l_exists      boolean;
      BEGIN
         --
         l_temp_column := cs_rec.ntc_column_name;
         l_temp_alias := SUBSTR(UPPER(REPLACE(cs_rec.ntc_prompt,' ','_')),1,30);
         IF NOT nm3flx.is_string_valid_for_object (l_temp_alias)
          OR nm3flx.is_reserved_word (l_temp_alias)
          THEN
            l_temp_alias := NULL;
         END IF;
         --
         -- Check to make sure we dont already have this alias
         --
         l_exists := FALSE;
         --
         FOR i IN 1..l_tab_alias.COUNT
          LOOP
            l_exists := l_tab_alias(i) = l_temp_alias;
            EXIT WHEN l_exists;
         END LOOP;
         --
         IF l_exists
          THEN
            l_temp_alias := NULL;
            l_exists     := FALSE;
            FOR i IN 1..l_tab_column.COUNT
             LOOP
               l_exists := l_tab_column(i) = l_temp_column;
               EXIT WHEN l_exists;
            END LOOP;
            IF NOT l_exists
             THEN
               l_temp_column  := NULL;
            END IF;
         END IF;
         --
         IF l_temp_column IS NOT NULL
          THEN
            add_data (l_temp_column, l_temp_alias, FALSE);
         END IF;
         --
      END;
   END LOOP;
   --
   OPEN chk_for_primary;
   FETCH chk_for_primary INTO l_primary;
   IF chk_for_primary%NOTFOUND THEN
      CLOSE chk_for_primary;
      l_primary := 'N';
   ELSE
      CLOSE chk_for_primary;
      NULL;
   END IF;

   IF l_primary = 'Y' THEN
    --  Now add the extra attribute columns
      FOR cs_rec IN ( SELECT * FROM nm_inv_type_attribs_all
                      WHERE ita_inv_type = (SELECT nad_inv_type FROM nm_nw_ad_types
                                            WHERE nad_nt_type = l_rec_nt.nt_type
                                            AND NVL(nad_gty_type, '-1') = NVL(l_rec_ngt.ngt_group_type, '-1')
                                            AND nad_primary_ad = 'Y')
                      ORDER BY ita_disp_seq_no
                    )
      LOOP
         DECLARE
            l_rec_ita   nm_inv_type_attribs%ROWTYPE;
         BEGIN
              l_rec_ita:= cs_rec;
              --
              l_rec_ita.ita_inv_type        := l_rec_nit.nit_inv_type;
              l_rec_ita.ita_attrib_name     := NVL(SUBSTR(UPPER(REPLACE(cs_rec.ita_view_col_name,' ','_')),1,30),l_rec_ita.ita_attrib_name);
              l_rec_ita.ita_dynamic_attrib  := 'N';
              l_rec_ita.ita_disp_seq_no     := l_tab_nita.COUNT*10+10;
              IF NOT nm3get.get_id(pi_id_domain => l_rec_ita.ita_id_domain,pi_raise_not_found => FALSE).id_start_date < l_rec_nit.nit_start_date
              THEN
                l_rec_ita.ita_id_domain       := NULL;
              END IF;
              l_rec_ita.ita_mandatory_yn    := l_rec_ntc.ntc_mandatory;
              l_rec_ita.ita_validate_yn     := 'N';
              l_rec_ita.ita_dtp_code        := NULL;
              l_rec_ita.ita_view_attri      := l_rec_ita.ita_attrib_name;
              l_rec_ita.ita_view_col_name   := l_rec_ita.ita_attrib_name;
              l_rec_ita.ita_start_date      := l_rec_nit.nit_start_date;
              l_rec_ita.ita_end_date        := NULL;
              l_rec_ita.ita_queryable       := 'N';
              l_rec_ita.ita_ukpms_param_no  := NULL;
              l_rec_ita.ita_exclusive       := 'N';
              l_rec_ita.ita_displayed       := 'Y';
              l_rec_ita.ita_disp_width      := nvl(l_rec_ita.ITA_DISP_WIDTH, 10);
              --
              l_tab_nita (l_tab_nita.COUNT+1) := l_rec_ita;
         END;
         --
      END LOOP;
   END IF;
   --
   IF NOT nm3ddl.does_object_exist(p_object_name => l_rec_nit.nit_table_name
                                  ,p_object_type => 'VIEW')
   THEN
   --
     IF l_rec_ngt.ngt_group_type IS NULL 
     THEN
       create_view_for_nt_type (pi_nt_type);
     ELSE
       create_view_for_nt_type ( pi_nt_type  => l_rec_ngt.ngt_nt_type
                               , pi_gty_type => l_rec_ngt.ngt_group_type);
     END IF;
   --
   END IF;
   --
   nm3inv.ins_nit (l_rec_nit);
   nm3inv.ins_tab_ita (l_tab_nita);
     
   -- CWS 703001
   FOR i in 1..l_TYPE_ROLES.count LOOP
   INSERT INTO NM_INV_TYPE_ROLES 
   values l_TYPE_ROLES(i);
   end loop;
   
   COMMIT;
--
   nm_debug.proc_end(g_package_name, 'create_ft_inv_for_nt_type');
--
END create_ft_inv_for_nt_type;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_view_for_nt_type (pi_nt_type  IN VARCHAR2) IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_nt (c_nt_type varchar2) IS
   SELECT *
    FROM  nm_types
   WHERE  nt_type = c_nt_type;
--
   CURSOR cs_nat (c_nat_admin_type varchar2) IS
   SELECT MIN(nau_start_date)
    FROM  nm_admin_units
   WHERE  nau_admin_type = c_nat_admin_type;
--
   CURSOR chk_for_primary IS
   SELECT 'Y' FROM nm_nw_ad_types
   WHERE nad_nt_type = pi_nt_type
   AND nad_primary_ad = 'Y';
--
   l_exists_already   boolean;
   l_dummy            pls_integer;
--
   l_rec_nt           nm_types%ROWTYPE;
--
   l_tab_column       nm3type.tab_varchar2000;
   l_tab_alias        nm3type.tab_varchar30;
--
   l_line_begin       varchar2(10) := '       ';
--
   l_sql varchar2(32767);
--
   l_rec_ntc       nm_type_columns%ROWTYPE;
   l_rec_ntc2      nm_inv_type_attribs_all%ROWTYPE;
--
   c_number  CONSTANT varchar2(8) := 'NUMBER';
   c_varchar CONSTANT varchar2(8) := 'VARCHAR2';
   c_date    CONSTANT varchar2(8) := 'DATE';
--
   c_owner   CONSTANT varchar2(30) := hig.get_application_owner;
--
   l_tab_vc   nm3type.tab_varchar32767;
--
   l_primary VARCHAR2(1);
--

   PROCEDURE add_data (p_col_name   varchar2
                      ,p_alias      varchar2
                      ,p_static_col boolean DEFAULT TRUE
                      ) IS
      --
      CURSOR cs_atc (c_owner       varchar2
                    ,c_table_name  varchar2
                    ,c_column_name varchar2
                    ) IS
      SELECT *
       FROM  all_tab_columns
      WHERE  owner      = c_owner
       AND   table_name = c_table_name
       AND   column_name = c_column_name;
      --
      l_rec_atc all_tab_columns%ROWTYPE;
      --
      l_col_name  varchar2(2000);
--
   BEGIN
--
      nm_debug.debug('in add'||p_col_name);
      l_tab_column(l_tab_column.COUNT+1) := p_col_name;
      l_tab_alias(l_tab_alias.COUNT+1)   := p_alias;

--
      --
      IF p_static_col
       THEN
         l_col_name := p_col_name;
      ELSE
         l_col_name := l_rec_ntc.ntc_column_name;
      END IF;
      --
      OPEN  cs_atc (c_owner, 'NM_ELEMENTS_ALL',l_col_name);
      FETCH cs_atc INTO l_rec_atc;
      CLOSE cs_atc;
      --

--    l_tab_nita (l_tab_nita.COUNT+1) := l_rec_ita;
--
   END add_data;

--
BEGIN
--
   nm_debug.proc_start(g_package_name, 'create_view_for_nt_type');
--
   add_data ('a.NE_ID',NULL);
   add_data ('a.NE_ID','NE_FT_PK_COL');
   add_data ('a.NE_UNIQUE',NULL);
   add_data ('TO_NUMBER(0)','NE_BEGIN_MP');
   add_data ('a.NE_LENGTH',NULL);
   add_data ('a.NE_NO_START','START_NODE_ID');
   add_data ('a.NE_NO_END','END_NODE_ID');
   add_data ('a.NE_DESCR',NULL);
   add_data ('a.NE_START_DATE',NULL);
   add_data ('a.NE_END_DATE',NULL);
   add_data ('a.NE_ADMIN_UNIT',NULL);
   add_data ('SUBSTR(nm3ausec.get_nau_unit_code(a.NE_ADMIN_UNIT),1,10)','ADMIN_UNIT_CODE');

-- only use this if the NT is used as a group of sections!

   add_data ('a.NE_GTY_GROUP_TYPE',NULL);

   OPEN  cs_nt (pi_nt_type);
   FETCH cs_nt INTO l_rec_nt;
   IF cs_nt%NOTFOUND
    THEN
      CLOSE cs_nt;
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 244
                   ,pi_supplementary_info => pi_nt_type
                   );
   END IF;
   CLOSE cs_nt;
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_type_columns
                  WHERE  ntc_nt_type = pi_nt_type
                  ORDER BY NTC_SEQ_NO) --sscanlon fix
    LOOP
      l_rec_ntc := cs_rec;
      DECLARE
         l_temp_column varchar2(30);
         l_temp_alias  varchar2(30);
         l_exists      boolean;
      BEGIN
         --
         l_temp_column := 'a.'||cs_rec.ntc_column_name;
         l_temp_alias := SUBSTR(UPPER(REPLACE(cs_rec.ntc_prompt,' ','_')),1,30);
         IF NOT nm3flx.is_string_valid_for_object (l_temp_alias)
          OR nm3flx.is_reserved_word (l_temp_alias)
          THEN
            l_temp_alias := NULL;
         END IF;
         --
         -- Check to make sure we dont already have this alias
         --
         l_exists := FALSE;
         --
         FOR i IN 1..l_tab_alias.COUNT
          LOOP
            l_exists := l_tab_alias(i) = l_temp_alias;
            EXIT WHEN l_exists;
         END LOOP;
         --
         IF l_exists
          THEN
            l_temp_alias := NULL;
            l_exists     := FALSE;
            FOR i IN 1..l_tab_column.COUNT
             LOOP
               l_exists := l_tab_column(i) = l_temp_column;
               EXIT WHEN l_exists;
            END LOOP;
            IF NOT l_exists
             THEN
               l_temp_column  := NULL;
            END IF;
         END IF;
         --
         IF l_temp_column IS NOT NULL
          THEN
            add_data (l_temp_column, l_temp_alias, FALSE);
         END IF;
         --
      END;
   END LOOP;


   OPEN chk_for_primary;
   FETCH chk_for_primary INTO l_primary;
   IF chk_for_primary%NOTFOUND THEN
      CLOSE chk_for_primary;
      l_primary := 'N';
   ELSE
      CLOSE chk_for_primary;
      NULL;
   END IF;

   IF l_primary = 'Y' THEN
    --  Now add the extra attribute columns
      FOR cs_rec IN ( SELECT * FROM nm_inv_type_attribs_all
                      WHERE ita_inv_type = (SELECT nad_inv_type FROM nm_nw_ad_types
                                            WHERE nad_nt_type = pi_nt_type
                                            AND nad_gty_type IS NULL
                                            AND nad_primary_ad = 'Y')
                      ORDER BY ita_disp_seq_no
                    )


      LOOP

         l_rec_ntc2 := cs_rec;

         DECLARE
            l_temp_column varchar2(30);
            l_temp_alias  varchar2(30);
            l_exists      boolean;
         BEGIN
         --
            l_temp_column := 'c.'||cs_rec.ita_attrib_name;
            l_temp_alias := SUBSTR(UPPER(REPLACE(cs_rec.ita_view_col_name,' ','_')),1,30);
            IF NOT nm3flx.is_string_valid_for_object (l_temp_alias)
            OR nm3flx.is_reserved_word (l_temp_alias)
            THEN
               l_temp_alias := NULL;
            END IF;
         --
         -- Check to make sure we dont already have this alias
         --
            l_exists := FALSE;
         --
            FOR i IN 1..l_tab_alias.COUNT
            LOOP
               l_exists := l_tab_alias(i) = l_temp_alias;
               EXIT WHEN l_exists;
            END LOOP;
         --
            IF l_exists
            THEN
               l_temp_alias := NULL;
               l_exists     := FALSE;
               FOR i IN 1..l_tab_column.COUNT
               LOOP
                  l_exists := l_tab_column(i) = l_temp_column;
                  EXIT WHEN l_exists;
               END LOOP;
               IF NOT l_exists
               THEN
                  l_temp_column  := NULL;
               END IF;
            END IF;
         --
            IF l_temp_column IS NOT NULL
            THEN
               add_data (l_temp_column, l_temp_alias, FALSE);
            END IF;
         --

         END;
      END LOOP;

   END IF;
   --
  /* IF l_rec_nt.nt_datum = 'Y' THEN
      add_data ('NE_NO_START','START_NODE_ID');
      add_data ('NE_NO_END','END_NODE_ID');
   END IF;*/
   --
   nm_debug.debug('CREATE OR REPLACE VIEW '||c_owner||'.'||'V_NM_'||pi_nt_type||'_NT');
   l_tab_vc.DELETE;
   nm3ddl.append_tab_varchar(l_tab_vc,'CREATE OR REPLACE VIEW '||c_owner||'.'||'V_NM_'||pi_nt_type||'_NT'||' AS',FALSE);
   nm3ddl.append_tab_varchar(l_tab_vc,'SELECT ');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'-----------------------------------------------------------------------------');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   SCCS Identifiers :-');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       sccsid           : @(#)nm3inv_view.pkb	1.32 08/19/02');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       Module Name      : nm3inv_view.pkb');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       Date into SCCS   : 02/08/19 10:15:30');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       Date fetched Out : 02/11/22 16:14:52');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       SCCS Version     : 1.32');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   Author : Jonathan Mills, mods by RC');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   NT view for NT_TYPE "'||pi_nt_type||'"');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   Generated by '||g_package_name||' package body');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'-----------------------------------------------------------------------------');
   nm3ddl.append_tab_varchar(l_tab_vc,'--      Copyright (c) exor corporation ltd, 2001');
   nm3ddl.append_tab_varchar(l_tab_vc,'-----------------------------------------------------------------------------');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   FOR i IN 1..l_tab_alias.COUNT
    LOOP

      nm3ddl.append_tab_varchar(l_tab_vc,l_line_begin||l_tab_column(i)||' '||l_tab_alias(i));
      l_line_begin := '      ,';

   END LOOP;

   IF l_primary = 'N' THEN

      nm3ddl.append_tab_varchar(l_tab_vc,' FROM nm_elements a');
      nm3ddl.append_tab_varchar(l_tab_vc,' WHERE a.ne_nt_type = '||nm3flx.string(pi_nt_type));
      -- nm3ddl.append_tab_varchar(l_tab_vc,' AND  ne_type    = '||nm3flx.string('S'));
      nm3ddl.append_tab_varchar(l_tab_vc,' WITH READ ONLY');
      nm3ddl.create_object_and_syns ('V_NM_'||pi_nt_type||'_NT',l_tab_vc);
      l_tab_vc.DELETE;

   ELSE

      nm3ddl.append_tab_varchar(l_tab_vc, ' FROM  nm_elements a '||
                                          ' LEFT OUTER JOIN nm_nw_ad_link b '||
                                          ' ON b.nad_ne_id = a.ne_id '||
                                          ' AND b.nad_id IN (SELECT nad_id '||
                                          '                  FROM nm_nw_ad_types '||
                                          '                  WHERE nad_nt_type = '||nm3flx.string(pi_nt_type));
      nm3ddl.append_tab_varchar(l_tab_vc, '                  AND nad_gty_type IS NULL '||
                                          '                  AND nad_primary_ad = '||nm3flx.string('Y')||')'||
                                          ' LEFT OUTER JOIN nm_inv_items_all c '||
                                          ' ON  b.nad_iit_ne_id = c.iit_ne_id ');
      nm3ddl.append_tab_varchar(l_tab_vc, ' WHERE a.ne_nt_type = '||nm3flx.string(pi_nt_type)||
                                          ' AND a.ne_gty_group_type IS NULL ');
      nm3ddl.append_tab_varchar(l_tab_vc, ' WITH READ ONLY');
      nm3ddl.create_object_and_syns ('V_NM_'||pi_nt_type||'_NT',l_tab_vc);
      l_tab_vc.DELETE;

   END IF;
   --
   COMMIT;

--
   nm_debug.proc_end(g_package_name, 'create_ft_inv_for_nt_type');
--
END create_view_for_nt_type;
--
----------------------------------------------------------------------------------------------------
--
PROCEDURE create_view_for_nt_type (pi_nt_type  IN varchar2,
                                   pi_gty_type IN varchar2) IS
--
   PRAGMA autonomous_transaction;
--
   CURSOR cs_nt (c_nt_type varchar2) IS
   SELECT *
   FROM  nm_types
   WHERE  nt_type = c_nt_type;
--
   CURSOR cs_nat (c_nat_admin_type varchar2) IS
   SELECT MIN(nau_start_date)
   FROM  nm_admin_units
   WHERE  nau_admin_type = c_nat_admin_type;
--
   CURSOR chk_for_primary IS
   SELECT 'Y' FROM nm_nw_ad_types
   WHERE  nad_nt_type = pi_nt_type
   AND    nad_gty_type = pi_gty_type
   AND    nad_primary_ad = 'Y';
--
   l_exists_already   boolean;
   l_dummy            pls_integer;
--
   l_rec_nt           nm_types%ROWTYPE;
--
   l_tab_column       nm3type.tab_varchar2000;
   l_tab_alias        nm3type.tab_varchar30;
--
   l_line_begin       varchar2(10) := '       ';
--
   l_sql varchar2(32767);
--
   l_rec_ntc       nm_type_columns%ROWTYPE;
   l_rec_ntc2      nm_inv_type_attribs_all%ROWTYPE;
--
   c_number  CONSTANT varchar2(8) := 'NUMBER';
   c_varchar CONSTANT varchar2(8) := 'VARCHAR2';
   c_date    CONSTANT varchar2(8) := 'DATE';
--
   c_owner   CONSTANT varchar2(30) := hig.get_application_owner;
--
   l_tab_vc   nm3type.tab_varchar32767;
--
   l_primary          varchar2(1);
--

   PROCEDURE add_data (p_col_name   varchar2
                      ,p_alias      varchar2
                      ,p_static_col boolean DEFAULT TRUE
                      ) IS
      --
      CURSOR cs_atc (c_owner       varchar2
                    ,c_table_name  varchar2
                    ,c_column_name varchar2
                    ) IS
      SELECT *
       FROM  all_tab_columns
      WHERE  owner      = c_owner
       AND   table_name = c_table_name
       AND   column_name = c_column_name;
      --
      l_rec_atc all_tab_columns%ROWTYPE;
      --
      l_col_name  varchar2(2000);
--
   BEGIN
--
      l_tab_column(l_tab_column.COUNT+1) := p_col_name;
      l_tab_alias(l_tab_alias.COUNT+1)   := p_alias;
--
      --
      IF p_static_col
       THEN
         l_col_name := p_col_name;
      ELSE
         l_col_name := l_rec_ntc.ntc_column_name;
      END IF;
      --
      OPEN  cs_atc (c_owner, 'NM_ELEMENTS_ALL',l_col_name);
      FETCH cs_atc INTO l_rec_atc;
      CLOSE cs_atc;
      --
--
   END add_data;

--
BEGIN
--
   nm_debug.proc_start(g_package_name, 'create_view_for_nt_type');
--
   add_data ('a.NE_ID',NULL);
   add_data ('a.NE_ID','NE_FT_PK_COL');
   add_data ('a.NE_UNIQUE',NULL);
   add_data ('TO_NUMBER(0)','NE_BEGIN_MP');
   add_data ('a.NE_LENGTH',NULL);
   add_data ('a.NE_DESCR',NULL);
   add_data ('a.NE_START_DATE',NULL);
   add_data ('a.NE_END_DATE',NULL);
   add_data ('a.NE_ADMIN_UNIT',NULL);
   add_data ('SUBSTR(nm3ausec.get_nau_unit_code(a.NE_ADMIN_UNIT),1,10)','ADMIN_UNIT_CODE');
   -- only use this if the NT is used as a group of sections!
   add_data ('a.NE_GTY_GROUP_TYPE',NULL);
   --
 /*  IF l_rec_nt.nt_datum = 'Y' THEN
      add_data ('NE_NO_START','START_NODE_ID');
      add_data ('NE_NO_END','START_NODE_ID');
   END IF;*/
   --
   OPEN  cs_nt (pi_nt_type);
   FETCH cs_nt INTO l_rec_nt;
   IF cs_nt%NOTFOUND
    THEN
      CLOSE cs_nt;
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 244
                   ,pi_supplementary_info => pi_nt_type
                   );
   END IF;
   CLOSE cs_nt;
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_type_columns
                  WHERE  ntc_nt_type = pi_nt_type
                 )
    LOOP
      l_rec_ntc := cs_rec;
      DECLARE
         l_temp_column varchar2(30);
         l_temp_alias  varchar2(30);
         l_exists      boolean;
      BEGIN
         --
         l_temp_column := 'a.'||cs_rec.ntc_column_name;
         l_temp_alias := SUBSTR(UPPER(REPLACE(cs_rec.ntc_prompt,' ','_')),1,30);
         IF NOT nm3flx.is_string_valid_for_object (l_temp_alias)
          OR nm3flx.is_reserved_word (l_temp_alias)
          THEN
            l_temp_alias := NULL;
         END IF;
         --
         -- Check to make sure we dont already have this alias
         --
         l_exists := FALSE;
         --
         FOR i IN 1..l_tab_alias.COUNT
          LOOP
            l_exists := l_tab_alias(i) = l_temp_alias;
            EXIT WHEN l_exists;
         END LOOP;
         --
         IF l_exists
          THEN
            l_temp_alias := NULL;
            l_exists     := FALSE;
            FOR i IN 1..l_tab_column.COUNT
             LOOP
               l_exists := l_tab_column(i) = l_temp_column;
               EXIT WHEN l_exists;
            END LOOP;
            IF NOT l_exists
             THEN
               l_temp_column  := NULL;
            END IF;
         END IF;
         --
         IF l_temp_column IS NOT NULL
          THEN
            add_data (l_temp_column, l_temp_alias, FALSE);
         END IF;
         --
      END;
   END LOOP;



   OPEN chk_for_primary;
   FETCH chk_for_primary INTO l_primary;
   IF chk_for_primary%NOTFOUND THEN
      CLOSE chk_for_primary;
      l_primary := 'N';
   ELSE
      CLOSE chk_for_primary;
      NULL;
   END IF;

  --  Now add the flexible attribute columns
   FOR cs_rec IN (SELECT * FROM nm_inv_type_attribs_all
                  WHERE ita_inv_type = (SELECT nad_inv_type FROM nm_nw_ad_types
                                        WHERE nad_nt_type = pi_nt_type
                                        AND nad_gty_type = pi_gty_type
                                        AND nad_primary_ad = 'Y')
                  ORDER BY ita_disp_seq_no
                )

    LOOP

      l_rec_ntc2 := cs_rec;

      DECLARE
         l_temp_column varchar2(30);
         l_temp_alias  varchar2(30);
         l_exists      boolean;
      BEGIN
         --
         l_temp_column := 'c.'||cs_rec.ita_attrib_name;
         l_temp_alias := SUBSTR(UPPER(REPLACE(cs_rec.ita_view_col_name,' ','_')),1,30);
         IF NOT nm3flx.is_string_valid_for_object (l_temp_alias)
          OR nm3flx.is_reserved_word (l_temp_alias)
          THEN
            l_temp_alias := NULL;
         END IF;
         --
         -- Check to make sure we dont already have this alias
         --
         l_exists := FALSE;
         --
         FOR i IN 1..l_tab_alias.COUNT
          LOOP
            l_exists := l_tab_alias(i) = l_temp_alias;
            EXIT WHEN l_exists;
         END LOOP;
         --
         IF l_exists
          THEN
            l_temp_alias := NULL;
            l_exists     := FALSE;
            FOR i IN 1..l_tab_column.COUNT
             LOOP
               l_exists := l_tab_column(i) = l_temp_column;
               EXIT WHEN l_exists;
            END LOOP;
            IF NOT l_exists
             THEN
               l_temp_column  := NULL;
            END IF;
         END IF;
         --
         IF l_temp_column IS NOT NULL
          THEN
            add_data (l_temp_column, l_temp_alias, FALSE);
         END IF;
         --

      END;
   END LOOP;
--
   --nm_debug.debug('CREATE OR REPLACE VIEW '||c_owner||'.'||'V_NM_'||pi_nt_type||'_'||pi_gty_type||'_NT');
   l_tab_vc.DELETE;
   nm3ddl.append_tab_varchar(l_tab_vc,'CREATE OR REPLACE VIEW '||c_owner||'.'||'V_NM_'||pi_nt_type||'_'||pi_gty_type||'_NT AS ',FALSE);
   nm3ddl.append_tab_varchar(l_tab_vc,'SELECT ');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'-----------------------------------------------------------------------------');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   SCCS Identifiers :-');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       sccsid           : @(#)nm3inv_view.pkb	1.32 08/19/02');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       Module Name      : nm3inv_view.pkb');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       Date into SCCS   : 02/08/19 10:15:30');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       Date fetched Out : 02/11/22 16:14:52');
   nm3ddl.append_tab_varchar(l_tab_vc,'--       SCCS Version     : 1.32');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   Author : Jonathan Mills, mods by RC and PS');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   NT view for NT_TYPE "'||pi_nt_type||'" and GTY_TYPE "'||pi_gty_type||'"');
   nm3ddl.append_tab_varchar(l_tab_vc,'--   Generated by '||g_package_name||' package body');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');
   nm3ddl.append_tab_varchar(l_tab_vc,'-----------------------------------------------------------------------------');
   nm3ddl.append_tab_varchar(l_tab_vc,'--      Copyright (c) exor corporation ltd, 2001');
   nm3ddl.append_tab_varchar(l_tab_vc,'-----------------------------------------------------------------------------');
   nm3ddl.append_tab_varchar(l_tab_vc,'--');

--

   FOR i IN 1..l_tab_alias.COUNT
    LOOP
      nm3ddl.append_tab_varchar(l_tab_vc,l_line_begin||l_tab_column(i)||' '||l_tab_alias(i));
      l_line_begin := '      ,';

   END LOOP;

--
  IF l_primary = 'N'
  THEN
  --
    nm3ddl.append_tab_varchar(l_tab_vc,' FROM nm_elements a');
    nm3ddl.append_tab_varchar(l_tab_vc,'WHERE ne_nt_type = '||nm3flx.string(pi_nt_type));
    nm3ddl.append_tab_varchar(l_tab_vc,'  AND ne_gty_group_type = '||nm3flx.string(pi_gty_type));
    -- nm3ddl.append_tab_varchar(l_tab_vc,' AND  ne_type    = '||nm3flx.string('S'));
    nm3ddl.append_tab_varchar(l_tab_vc,'WITH READ ONLY');

  ELSIF l_primary = 'Y'
  THEN
  --
    nm3ddl.append_tab_varchar(l_tab_vc, '  FROM nm_elements a '||
                                        '  LEFT OUTER JOIN nm_nw_ad_link b '||
                                        '    ON b.nad_ne_id = a.ne_id '||
                                        '   AND b.nad_id IN (SELECT nad_id '||
                                        '                      FROM nm_nw_ad_types ');
    nm3ddl.append_tab_varchar(l_tab_vc, '                     WHERE nad_nt_type    = '||nm3flx.string(pi_nt_type));
    nm3ddl.append_tab_varchar(l_tab_vc, '                       AND nad_gty_type   = '||nm3flx.string(pi_gty_type));
    nm3ddl.append_tab_varchar(l_tab_vc, '                       AND nad_primary_ad = '||nm3flx.string('Y')||')'||
                                        '  LEFT OUTER JOIN nm_inv_items_all c '||
                                        '    ON  b.nad_iit_ne_id    = c.iit_ne_id '||
                                        ' WHERE a.ne_nt_type        = '||nm3flx.string(pi_nt_type));
    nm3ddl.append_tab_varchar(l_tab_vc, '   AND a.ne_gty_group_type = '||nm3flx.string(pi_gty_type));
    nm3ddl.append_tab_varchar(l_tab_vc, '  WITH READ ONLY');
  --
  END IF;
--
  nm_debug.debug_on;
  FOR i IN 1..l_tab_vc.COUNT
  LOOP
    nm_debug.debug(l_tab_vc(i));
  END LOOP;
--
  nm3ddl.create_object_and_syns ('V_NM_'||pi_nt_type||'_'||pi_gty_type||'_NT',l_tab_vc);
  l_tab_vc.DELETE;
  --
  COMMIT;
--
  nm_debug.proc_end(g_package_name, 'create_ft_inv_for_nt_type');
--
END create_view_for_nt_type;
--
----------------------------------------------------------------------------------------------------
--
FUNCTION get_nt_view_name (pi_nt_type  IN VARCHAR2,
                           pi_gty_type IN VARCHAR2 DEFAULT NULL
                          )  RETURN VARCHAR2 IS

   --
   CURSOR check_obj_exists (p_owner VARCHAR2,
                            p_object VARCHAR2) IS
   SELECT 'x'
   FROM  all_objects
   WHERE  owner       = p_owner
   AND   object_name = p_object;

   --
   g_application_owner user_users.username%TYPE := Hig.get_application_owner;

   lc_view_name all_objects.object_name%TYPE;

   l_dummy VARCHAR2(1);

   view_not_exist EXCEPTION;
   --

BEGIN
   --
   IF pi_gty_type IS NULL THEN

      lc_view_name := 'V_NM_'||pi_nt_type||'_NT';

   ELSE

      lc_view_name := 'V_NM_'||pi_nt_type||'_'||pi_gty_type||'_NT';

   END IF;
   --
   OPEN  check_obj_exists(g_application_owner, lc_view_name);
   FETCH check_obj_exists INTO l_dummy;
   IF check_obj_exists%NOTFOUND THEN
      CLOSE check_obj_exists;
      RAISE view_not_exist;
   END IF;
   CLOSE check_obj_exists;
   --
   RETURN lc_view_name;
   --

EXCEPTION

   WHEN view_not_exist THEN

      hig.raise_ner(pi_appl => nm3type.c_net
                   ,pi_id       => 256 );

END;
--
----------------------------------------------------------------------------------------------------
--
PROCEDURE create_inv_nw_trigger( pi_inv_type    varchar2
                                ,pi_attr_prefix varchar2 DEFAULT NULL
                               )
IS
--
   l_old_attr_prefix varchar2(25) := g_attr_prefix;
--
   CURSOR cs_check_for_dup_seq_no (c_inv_type varchar2) IS
   SELECT ita_disp_seq_no
    FROM  nm_inv_type_attribs
   WHERE  ita_inv_type = c_inv_type
   GROUP BY ita_disp_seq_no
   HAVING COUNT(*) > 1;
--
   l_dummy cs_check_for_dup_seq_no%ROWTYPE;
--
   l_join_to_network boolean := FALSE;
--
   l_view_name user_views.view_name%TYPE;
--
   l_rec_nit nm_inv_types%ROWTYPE := nm3inv.get_inv_type(pi_inv_type);
--
   l_get_route_measures boolean;
--
   l_instead_of_insert_trig_name varchar2(30);
--
   TYPE rec_cols IS RECORD
      (table_col_name varchar2(30)
      ,view_col_name  varchar2(30)
      ,description    varchar2(2000)
      ,use_val_on_ins varchar2(1)
      );
   TYPE tab_rec_cols IS TABLE OF rec_cols INDEX BY binary_integer;
   l_rec_cols     rec_cols;
   l_tab_rec_cols tab_rec_cols;
--
   l_max_length   number := 0;
--
   l_nm_inv_type_rec nm_inv_types%ROWTYPE;
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar( p_text, p_nl );
   END append;
--
   PROCEDURE set_vars_for_return IS
   BEGIN
      g_attr_prefix               := l_old_attr_prefix;
   END set_vars_for_return;
--
   PROCEDURE add_rec_cols (p_rec_cols IN OUT rec_cols) IS
      l_empty_rec_cols rec_cols;
   BEGIN
--
      l_tab_rec_cols(l_tab_rec_cols.COUNT+1) := p_rec_cols;
--
      IF LENGTH(p_rec_cols.table_col_name) > l_max_length
       THEN
         l_max_length := LENGTH(p_rec_cols.table_col_name);
      END IF;
--
      IF l_tab_rec_cols.COUNT = 1
       THEN
         append ('       ');
      ELSE
         append ('      ,');
      END IF;
--
      append (RPAD(p_rec_cols.table_col_name,30),FALSE);
--
      IF p_rec_cols.table_col_name != p_rec_cols.view_col_name
       THEN
         append (' '||p_rec_cols.view_col_name,FALSE);
      END IF;
--
      IF LENGTH(p_rec_cols.view_col_name) > 30
       THEN
         g_inv_view_exc_code := -20012;
         g_inv_view_exc_msg  := g_inv_view_exc_msg||'Column ('||p_rec_cols.view_col_name||') with col_name width > 10 would be created';
         RAISE g_inv_view_exception;
      END IF;
--
      p_rec_cols := l_empty_rec_cols;
--
   END add_rec_cols;
--
   PROCEDURE append_comment_block (p_obj_type varchar2, p_obj_name varchar2) IS
   BEGIN
      append ('--');
      append ('-- '||p_obj_type||' "'||p_obj_name||'" for inv_type "'||pi_inv_type||'" built '||TO_CHAR(SYSDATE,'HH24:MI:SS DD-MON-YYYY'));
      append ('--  by user "'||USER||'"');
      append ('--');
      append ('-- '||get_version);
      append ('-- '||get_body_version);
      append ('--');
   END append_comment_block;
--

BEGIN
   nm_debug.proc_start(g_package_name , 'create_inv_nw_trigger');
--
   IF NVL(hig.get_sysopt('INVVIEWSLK'),'N') != 'Y'
    THEN
      l_get_route_measures := FALSE;
   ELSE
      l_get_route_measures := TRUE;
   END IF;
--
   g_inv_view_exc_msg  := 'Cannot create NW view trigger for "'||pi_inv_type||'". ';
--
   OPEN  cs_check_for_dup_seq_no (pi_inv_type);
   FETCH cs_check_for_dup_seq_no INTO l_dummy;
   IF cs_check_for_dup_seq_no%FOUND
    THEN
      CLOSE cs_check_for_dup_seq_no;
      g_inv_view_exc_code := -20011;
      g_inv_view_exc_msg  := g_inv_view_exc_msg||'Duplicate ITA_DISP_SEQ_NO records exist';
      RAISE g_inv_view_exception;
   END IF;
   CLOSE cs_check_for_dup_seq_no;
--
   l_view_name                   := derive_nw_inv_type_view_name(pi_inv_type);
   l_instead_of_insert_trig_name := l_view_name||'_I_TRG';
--
   IF pi_attr_prefix IS NOT NULL
    THEN
      g_attr_prefix := pi_attr_prefix;
   END IF;
--
   nm3ddl.delete_tab_varchar;
--
   l_rec_cols.table_col_name    := 'IIT_NE_ID';
   l_rec_cols.view_col_name     := 'IIT_NE_ID';
   l_rec_cols.use_val_on_ins    := 'N';
   add_rec_cols (l_rec_cols);
   --
   l_rec_cols.table_col_name    := 'IIT_INV_TYPE';
   l_rec_cols.view_col_name     := 'IIT_INV_TYPE';
   add_rec_cols (l_rec_cols);
   --
   l_rec_cols.table_col_name    := 'IIT_PRIMARY_KEY';
   l_rec_cols.view_col_name     := 'IIT_PRIMARY_KEY';
   add_rec_cols (l_rec_cols);
   --
   l_rec_cols.table_col_name    := 'IIT_START_DATE';
   l_rec_cols.view_col_name     := 'IIT_START_DATE';
   add_rec_cols (l_rec_cols);
   --
   l_rec_cols.table_col_name    := 'IIT_ADMIN_UNIT';
   l_rec_cols.view_col_name     := 'IIT_ADMIN_UNIT';
   add_rec_cols (l_rec_cols);
   --
   l_rec_cols.table_col_name := 'IIT_X_SECT';
   l_rec_cols.view_col_name  := 'IIT_X_SECT';
   IF l_rec_nit.nit_x_sect_allow_flag = 'N'
    THEN
      l_rec_cols.use_val_on_ins := 'N';
      l_rec_cols.description    := ' - XSP not allowed - only here for ease of creating the XML Stuff';
   END IF;
   add_rec_cols (l_rec_cols);
   --
   l_rec_cols.table_col_name    := 'IIT_END_DATE';
   l_rec_cols.view_col_name     := 'IIT_END_DATE';
   add_rec_cols (l_rec_cols);
   --
   FOR each_attribute IN cs_all_attribs (pi_inv_type)
    LOOP
--
      l_rec_cols.table_col_name := each_attribute.ita_attrib_name;
--      l_rec_cols.view_col_name  :=  g_attr_prefix||each_attribute.ita_disp_seq_no||'it';
      l_rec_cols.view_col_name  :=  each_attribute.ita_view_col_name;
      l_rec_cols.description    := ' - '||each_attribute.ita_view_col_name;
--
      IF each_attribute.ita_mandatory_yn = 'Y'
       THEN
         l_rec_cols.description := l_rec_cols.description||' - MANDATORY';
      END IF;
--
      add_rec_cols (l_rec_cols);
--
   END LOOP;
--
   l_nm_inv_type_rec := nm3inv.get_inv_type( pi_inv_type );

   --
   -- If you ere going to create any INSTEAD OF triggers
   --  they could by put in here by looping through l_tab_rec_cols
   --
   nm3ddl.delete_tab_varchar;
   append ('CREATE OR REPLACE TRIGGER '||c_application_owner||'.'||l_instead_of_insert_trig_name);
   append (' INSTEAD OF INSERT');
   IF l_nm_inv_type_rec.nit_use_xy = 'Y'
    THEN
      append ('         OR UPDATE');
   END IF;
   append (' ON '||c_application_owner||'.'||l_view_name);
   append (' FOR EACH ROW');
   append ('DECLARE');
   append_comment_block('Instead Of Trigger',l_instead_of_insert_trig_name);
   append ('--');
   append ('   CURSOR cs_check (c_pk       nm_inv_items.iit_primary_key%TYPE');
   append ('                   ,c_inv_type nm_inv_items.iit_inv_type%TYPE');
   append ('                   ) IS');
   append ('   SELECT ROWID');
   append ('    FROM  nm_inv_items');
   append ('   WHERE  iit_primary_key = c_pk');
   append ('    AND   iit_inv_type    = c_inv_type;');
   append ('--');
   append ('   CURSOR cs_inv_exists (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE');
   append ('                   ) IS');
   append ('   SELECT iit_ne_id');
   append ('    FROM  nm_inv_items');
   append ('   WHERE  iit_ne_id = c_iit_ne_id;');
   append ('--');
   append ('   l_rec_iit    nm_inv_items%ROWTYPE;');
   append ('   l_temp_ne_id NUMBER;');
   append ('   l_inv_rowid  ROWID;');
   append ('   l_ne_id      nm_elements.ne_id%TYPE;');
   append ('   l_ne_unique  nm_elements.ne_unique%TYPE;');
   append ('   l_start      nm_members.nm_begin_mp%type;');
   append ('   l_end        nm_members.nm_end_mp%type;');
   append ('   l_dummy      number;');
   append ('   l_effective_date DATE;');
   append ('   l_warning_code VARCHAR2(80);');
   append ('   l_warning_msg  VARCHAR2(80);');
   append ('--');
   append ('BEGIN');
   append ('--');
   IF l_nm_inv_type_rec.nit_use_xy = 'Y'
    THEN
      append ('IF UPDATING');
      append ('  THEN');
      append (' ' );
      append ('   IF NVL(:NEW.ne_id_of,:OLD.ne_id_of) IS NOT NULL');
      append ('     THEN');
      append ('       nm3extent.create_temp_ne(pi_source_id                 => NVL(:NEW.ne_id_of,:OLD.ne_id_of)' );
      append ('                               ,pi_source                    => nm3extent.c_route' );
      append ('                               ,pi_begin_mp                  => :NEW.nm_begin_mp' );
      append ('                               ,pi_end_mp                    => :NEW.nm_end_mp');
      append ('                               ,po_job_id                    => l_temp_ne_id' );
      append ('                               ); ' );
      append (' ');
      append ('       nm3homo.homo_update');
      append ('                   (p_temp_ne_id_in  => l_temp_ne_id');
      append ('                   ,p_iit_ne_id      => NVL(:NEW.iit_ne_id,:OLD.iit_ne_id)');
      append ('                   ,p_effective_date => nm3user.get_effective_date');
      append ('                   );');
      append ('   END IF;');
      append ('ELSIF INSERTING');
      append ('  THEN');
   END IF;
   append ('--');
   append ('   IF :NEW.iit_ne_id IS NULL THEN');
   append ('      l_rec_iit.iit_ne_id := nm3net.get_next_ne_id;');
   append ('   ELSE');
   append ('      l_rec_iit.iit_ne_id := :NEW.iit_ne_id;');
   append ('   END IF;');
   append ('--');
   append ('   l_rec_iit.'||RPAD('iit_inv_type',l_max_length)||' := '||nm3flx.string(pi_inv_type)||';');
   --
   FOR i IN 1..l_tab_rec_cols.COUNT
    LOOP
      l_rec_cols := l_tab_rec_cols(i);
      IF   NVL(l_rec_cols.use_val_on_ins,'Y')    = 'Y'
       AND SUBSTR(l_rec_cols.table_col_name,1,4) = 'IIT_'
        THEN
         append ('   l_rec_iit.'||RPAD(LOWER(l_rec_cols.table_col_name),l_max_length)||' := :NEW.'||LOWER(l_rec_cols.view_col_name)||';');
      END IF;
   END LOOP;
   --
   append ('--');
   append ('   IF l_rec_iit.iit_start_date IS NULL');
   append ('    THEN');
   append ('      l_rec_iit.iit_start_date := nm3user.get_effective_date;');
   append ('   END IF;');
   --
   append ('--');
   append ('   IF l_rec_iit.iit_primary_key IS NULL');
   append ('    THEN');
   append ('      l_rec_iit.iit_primary_key := l_rec_iit.iit_ne_id;');
   append ('   END IF;');
   --
   append ('--');
   append ('   IF l_rec_iit.iit_admin_unit IS NULL');
   append ('    THEN');
   append ('      l_rec_iit.iit_admin_unit  := nm3ausec.get_highest_au_of_au_type('||nm3flx.string(l_rec_nit.nit_admin_type)||');');
   append ('   END IF;');
   --
   append ('--');
   append ('   l_effective_date := nm3user.get_effective_date;');
   append ('   nm3user.set_effective_date(l_rec_iit.iit_start_date);');
   --
   append ('--');
   append ('   OPEN  cs_check (l_rec_iit.iit_primary_key, l_rec_iit.iit_inv_type);');
   append ('   FETCH cs_check INTO l_inv_rowid;');
   append ('   IF cs_check%FOUND');
   append ('    THEN');
   append ('      UPDATE nm_inv_items');
   append ('       SET   iit_end_date = nvl(l_rec_iit.iit_start_date,l_rec_iit.iit_end_date)');
   append ('      WHERE  ROWID        = l_inv_rowid');
   append ('        AND  l_rec_iit.iit_end_date IS NULL;');
   append ('   END IF;');
   append ('   CLOSE cs_check;');

   append ('--');
   append ('   IF l_rec_iit.iit_end_date IS NULL THEN ');
   append ('      nm3inv.insert_nm_inv_items (l_rec_iit);');
   append ('   END IF;');
   append ('--');
   IF l_get_route_measures
     THEN
       append ('   IF :NEW.datum_ne_unique IS NULL AND');
       append ('      :NEW.ne_id_of IS NULL  ');
       append ('      AND');
       append ('      (:NEW.route_ne_id IS NOT NULL OR');
       append ('       :NEW.route_ne_unique IS NOT NULL)');
       append ('      THEN ');
       append ('--');
       append ('      l_ne_id := NVL(:NEW.route_ne_id,nm3net.get_ne_id(:NEW.route_ne_unique));');
       append ('      l_start := :NEW.route_slk_start;');
       IF l_nm_inv_type_rec.nit_pnt_or_cont = 'C'
        THEN
          append ('      l_end   := :NEW.route_slk_end;');
       ELSE
          append ('      l_end   := l_start;');
       END IF;
       append ('--');
       append ('      nm3extent.create_temp_ne');
       append ('        (pi_source_id => l_ne_id');
       append ('        ,pi_source    => nm3extent.c_route');
       append ('        ,pi_begin_mp  => l_start');
       append ('        ,pi_end_mp    => l_end');
       append ('        ,po_job_id    => l_temp_ne_id');
       append ('        );');
       append ('   END IF;');
       append ('--');
       append ('   IF :NEW.route_ne_unique IS NULL AND');
       append ('      :NEW.route_ne_id IS NULL THEN ');
       append ('      l_temp_ne_id := :NEW.ne_id_of;');
       append ('   END IF;');
   END IF;
   append ('--');
   append ('   IF l_rec_iit.iit_end_date IS NOT NULL THEN ');
   append ('      l_rec_iit.iit_ne_id := ');
   append ('      nm3xml_load.get_existing_inv_item( pi_inv_type   => '||nm3flx.string(pi_inv_type));
   append ('                                        ,pi_nte_job_id => l_temp_ne_id');
   append ('                                        ,pi_end_date => l_rec_iit.iit_end_date');
   append ('                                       );');
   append ('--');
   append ('      l_temp_ne_id := NM3XML_LOAD.GET_TEMP_EXTENT( pi_iit_ne_id  => l_rec_iit.iit_ne_id');
   append ('                                                  ,pi_nte_job_id => l_temp_ne_id');
   append ('                                                 );');
   append ('--');
   append ('      l_rec_iit.iit_start_date := l_rec_iit.iit_END_date;');
   append ('--');
   append ('   END IF;');

   append ('--');
   append ('   IF l_temp_ne_id = -1 THEN');
   append ('      nm3homo.end_inv_location( pi_iit_ne_id      => l_rec_iit.iit_ne_id');
   append ('                               ,pi_effective_date => l_rec_iit.iit_start_date');
   append ('                               ,po_warning_code   => l_warning_code ');
   append ('                               ,po_warning_msg    => l_warning_msg');
   append ('                               ,pi_ignore_item_loc_mand => true');
   append ('                              );');
   append ('   ELSE   ');
   append ('      IF l_temp_ne_id IS NOT NULL THEN');
   append ('         nm3homo.homo_update');
   append ('           (p_temp_ne_id_in  => l_temp_ne_id');
   append ('           ,p_iit_ne_id      => l_rec_iit.iit_ne_id');
   append ('           ,p_effective_date => l_rec_iit.iit_start_date');
   append ('           );');
   append ('      END IF;');
   append ('   END IF;');
   append ('--');
   append ('   nm3user.set_effective_date(l_effective_date);');
   append ('--');
   --
   IF l_nm_inv_type_rec.nit_use_xy = 'Y'
    THEN
      append ('END IF;');
   END IF;
   append ('EXCEPTION');
   append ('   WHEN OTHERS THEN');
   append ('       nm3user.set_effective_date(l_effective_date);');
   append ('       RAISE;');
   append ('END '||l_instead_of_insert_trig_name||';');
   --
   nm3ddl.execute_tab_varchar;
   --
   set_vars_for_return;
   g_inv_view_exc_msg := NULL;
   nm3ddl.delete_tab_varchar;
--
   nm_debug.proc_end(g_package_name , 'create_inv_nw_trigger');
--
EXCEPTION
--
   WHEN g_inv_view_exception
    THEN
      set_vars_for_return;
      RAISE_APPLICATION_ERROR(g_inv_view_exc_code,g_inv_view_exc_msg);
--
   WHEN others
    THEN
      set_vars_for_return;
      RAISE;

END create_inv_nw_trigger;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_all_inv_nw_trigger( pi_attr_prefix varchar2 DEFAULT NULL )
IS

   CURSOR cs_inv_types IS
   SELECT nit_inv_type
   FROM nm_inv_types
   WHERE nit_table_name IS NULL;

BEGIN
   nm_debug.proc_start(g_package_name , 'create_all_inv_nw_trigger');

   FOR crec IN cs_inv_types LOOP

      nm3inv_view.create_inv_nw_trigger( pi_inv_type    => crec.nit_inv_type );

   END LOOP;

   nm_debug.proc_end(g_package_name , 'create_all_inv_nw_trigger');
END create_all_inv_nw_trigger;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_inv_instead_of_trigger(p_inv_type nm_inv_types.nit_inv_type%TYPE) IS
   c_view_name    CONSTANT varchar2(30) := derive_inv_type_view_name(p_inv_type);
   c_trigger_name CONSTANT varchar2(30) := c_view_name||'_INSTEAD_IUD_TRG';
   l_tab_vc nm3type.tab_varchar32767;
--
   l_start varchar2(7) := ' SET   ';
--
   l_col          VARCHAR2(30);
   l_tab_ignore   nm3type.tab_boolean;
   l_ignore_list  nm3type.tab_varchar30;
--
   l_index          PLS_INTEGER;
   l_local_iit_col  nm3type.tab_varchar2000 := l_tab_iit_column;
--
BEGIN
--
   nm_debug.proc_start(g_package_name , 'create_inv_instead_of_trigger');
--
   l_tab_vc.DELETE;
   nm3ddl.append_tab_varchar(l_tab_vc,'CREATE OR REPLACE TRIGGER '||c_application_owner||'.'||c_trigger_name,FALSE);
   nm3ddl.append_tab_varchar(l_tab_vc,' INSTEAD OF INSERT OR UPDATE OR DELETE');
   nm3ddl.append_tab_varchar(l_tab_vc,'  ON '||c_application_owner||'.'||c_view_name);
   nm3ddl.append_tab_varchar(l_tab_vc,' FOR EACH ROW');
   nm3ddl.append_tab_varchar(l_tab_vc,'DECLARE');
   nm3ddl.append_tab_varchar(l_tab_vc,'   l_rec_iit nm_inv_items%ROWTYPE;');
   nm3ddl.append_tab_varchar(l_tab_vc,'BEGIN');
   nm3ddl.append_tab_varchar(l_tab_vc,'   IF DELETING');
   nm3ddl.append_tab_varchar(l_tab_vc,'    THEN');
   nm3ddl.append_tab_varchar(l_tab_vc,'      DELETE FROM nm_inv_items');
   nm3ddl.append_tab_varchar(l_tab_vc,'      WHERE  iit_ne_id = :OLD.iit_ne_id;');
   nm3ddl.append_tab_varchar(l_tab_vc,'   ELSIF UPDATING');
   nm3ddl.append_tab_varchar(l_tab_vc,'    THEN');
   nm3ddl.append_tab_varchar(l_tab_vc,'      UPDATE nm_inv_items');
--
   FOR i IN 1..l_tab_iit_column.COUNT
    LOOP
      l_col := UPPER(l_tab_iit_column(i));
      IF NOT l_tab_flex_column(i)
       AND nm3inv.is_column_allowable_for_flex (l_col) = nm3type.c_true
       THEN
         -- this is a potential flex column, but it is specified as a fixed col - see if we want to get rid
         FOR j IN i+1..l_tab_iit_column.COUNT
          LOOP
            IF UPPER(l_tab_iit_column(j)) = l_col
             THEN
               -- this is the same column used again
               l_local_iit_col.DELETE(i);
               EXIT;
            END IF;
         END LOOP;
      END IF;
   END LOOP;
--
   l_index := l_local_iit_col.FIRST;
   WHILE l_index IS NOT NULL
    LOOP
      nm3ddl.append_tab_varchar(l_tab_vc,'      '||l_start||RPAD(l_tab_iit_column(l_index),30,' ')||' = :NEW.'||l_tab_view_column(l_index));
      l_start := '      ,';
      l_index := l_local_iit_col.NEXT(l_index);
   END LOOP;
--
   nm3ddl.append_tab_varchar(l_tab_vc,'      WHERE  '||RPAD(l_tab_iit_column(1),30,' ')||' = :OLD.'||l_tab_view_column(1)||';');
   nm3ddl.append_tab_varchar(l_tab_vc,'   ELSIF INSERTING');
   nm3ddl.append_tab_varchar(l_tab_vc,'    THEN');
--
   l_index := l_local_iit_col.FIRST;
   WHILE l_index IS NOT NULL
    LOOP
      nm3ddl.append_tab_varchar(l_tab_vc,'      l_rec_iit.'||RPAD(l_tab_iit_column(l_index),30,' ')||' := :NEW.'||l_tab_view_column(l_index)||';');
      l_index := l_local_iit_col.NEXT(l_index);
   END LOOP;
--
   nm3ddl.append_tab_varchar(l_tab_vc,'      nm3inv.insert_nm_inv_items(l_rec_iit);');
--
   nm3ddl.append_tab_varchar(l_tab_vc,'   END IF;');
   nm3ddl.append_tab_varchar(l_tab_vc,'END '||c_trigger_name||';');
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm3ddl.debug_tab_varchar(l_tab_vc);
   nm3ddl.execute_tab_varchar(l_tab_vc);
--   nm_debug.debug_off;
   l_tab_vc.DELETE;
--
   nm_debug.proc_end(g_package_name , 'create_inv_instead_of_trigger');
--
END create_inv_instead_of_trigger;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_inv_on_route_view (pi_inv_type    varchar2
                                   ,pi_attr_prefix varchar2 DEFAULT NULL
                                   ) IS
--
   l_old_attr_prefix varchar2(25) := g_attr_prefix;
--
   CURSOR c_inv_view_check ( c_view_name varchar2 )
   IS
   SELECT 1
   FROM user_views
   WHERE view_name = c_view_name;
--
   l_dummy c_inv_view_check%ROWTYPE;
--
   l_join_to_network boolean := FALSE;
--
   l_view_name user_views.view_name%TYPE;
   l_inv_view_name user_views.view_name%TYPE;
--
   l_ddl          nm3type.tab_varchar32767;
--
   PROCEDURE append (p_text varchar2, p_nl boolean DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_ddl,p_text);
   END append;
--
   PROCEDURE set_vars_for_return IS
   BEGIN
      g_attr_prefix               := l_old_attr_prefix;
   END set_vars_for_return;
--
--
   PROCEDURE append_comment_block (p_obj_type varchar2, p_obj_name varchar2) IS
   BEGIN
      append ('--');
      append ('-- '||p_obj_type||' "'||p_obj_name||'" for inv_type "'||pi_inv_type||'" built '||TO_CHAR(SYSDATE,'HH24:MI:SS DD-MON-YYYY'));
      append ('--  by user "'||USER||'"');
      append ('--');
      append ('-- '||get_version);
      append ('-- '||get_body_version);
      append ('--');
   END append_comment_block;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_inv_on_route_view');
--
   g_inv_view_exc_msg  := 'Cannot create inv on route view for "'||pi_inv_type||'". ';
--
   l_view_name := get_inv_on_route_view_name(pi_inv_type);
   l_inv_view_name := derive_inv_type_view_name (pi_inv_type => pi_inv_type);
--
   -- Check that the inv_view exists
   OPEN c_inv_view_check ( l_inv_view_name );
   FETCH c_inv_view_check INTO l_dummy;
   IF c_inv_view_check%NOTFOUND THEN
      CLOSE c_inv_view_check;
      g_inv_view_exc_code := -20011;
      g_inv_view_exc_msg  := g_inv_view_exc_msg||'Inv view for '|| pi_inv_type || ' does not exists';
      RAISE g_inv_view_exception;
   END IF;

   IF pi_attr_prefix IS NOT NULL
    THEN
      g_attr_prefix := pi_attr_prefix;
   END IF;
--
   l_ddl.DELETE;
   append ('CREATE OR REPLACE FORCE VIEW '||hig.get_application_owner||'.'||l_view_name||' AS ');
--
   append ('SELECT ');
   append_comment_block('View',l_view_name);
   --
   append ('      inv.*');
   append ('    , nte_ne_id_of ne_id');
   append ('    , nte_begin_mp nm_start');
   append ('    , nte_end_mp nm_end ');
   append ('FROM  NM_NW_TEMP_EXTENTS ');
   append ('    , '|| l_inv_view_name ||' inv');
   append ('WHERE nte_job_id      =  nm3route_ref.get_g_job_id');
   append ('  AND nte_route_ne_id = inv.iit_ne_id');
--
   nm3ddl.create_object_and_syns(l_view_name,l_ddl);
--
   set_vars_for_return;
   g_inv_view_exc_msg := NULL;
   l_ddl.DELETE;
--
   nm_debug.proc_end(g_package_name,'create_inv_on_route_view');
--
EXCEPTION
--
   WHEN g_inv_view_exception
    THEN
      set_vars_for_return;
      RAISE_APPLICATION_ERROR(g_inv_view_exc_code,g_inv_view_exc_msg);
--
   WHEN others
    THEN
      set_vars_for_return;
      RAISE;
--
END create_inv_on_route_view;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE create_all_inv_on_route_view (pi_attr_prefix varchar2 DEFAULT NULL) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_all_inv_on_route_view');
--
   FOR cs_rec IN (SELECT nit_inv_type
                   FROM  nm_inv_types
                  WHERE  nit_table_name IS NULL -- ### Don't do Foreign Tables
                  ORDER BY nit_inv_type
                 )
    LOOP
      DECLARE
         l_inv_view_does_not_exist EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_inv_view_does_not_exist,-20011);
      BEGIN
         create_inv_on_route_view (cs_rec.nit_inv_type,pi_attr_prefix);
      EXCEPTION
         WHEN l_inv_view_does_not_exist
          THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM,1,255));
--            nm_debug.debug(SQLERRM);
      END;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'create_all_inv_on_route_view');
--
END create_all_inv_on_route_view;
--
----------------------------------------------------------------------------------------------
--
END nm3inv_view;
/
