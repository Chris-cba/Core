CREATE OR REPLACE PACKAGE BODY higdisco IS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)higdisco.pkb	1.1 05/19/03
--       Module Name      : higdisco.pkb
--       Date into SCCS   : 03/05/19 05:59:13
--       Date fetched Out : 07/06/13 14:10:31
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   Highways Discoverer Interfacing package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2003
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)higdisco.pkb	1.1 05/19/03"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'higdisco';
--
-----------------------------------------------------------------------------
--
    g_disco_user        CONSTANT hig_option_values.hov_value%TYPE := hig.get_sysopt('DISCEULUSR');
    g_disco_version     CONSTANT hig_option_values.hov_value%TYPE := hig.get_sysopt('DISCO_VERS');
    g_prefix            CONSTANT VARCHAR2(10)                     := get_prefix;
    g_complete_prefix   CONSTANT VARCHAR2(61)                     := g_disco_user||'.'||g_prefix;
    g_seq_name          CONSTANT VARCHAR2(30)                     := 'ID_SEQ';
--
    c_sobj              CONSTANT VARCHAR2(4)  := 'SOBJ';
    c_cuo               CONSTANT VARCHAR2(4)  := 'CUO';
    c_exp_type_co       CONSTANT VARCHAR2(4)  := 'CO';
    c_exp_type_fil      CONSTANT VARCHAR2(4)  := 'FIL';
    c_exp_type_jp       CONSTANT VARCHAR2(4)  := 'JP';
    c_ed_type_ped       CONSTANT VARCHAR2(4)  := 'PED';
    c_jp_developer_key  CONSTANT VARCHAR2(14) := 'JOIN_PREDICATE';
    c_jp_name           CONSTANT VARCHAR2(14) := INITCAP(REPLACE(c_jp_developer_key,'_',' '));
    --
    c_obj_table         CONSTANT VARCHAR2(30) := 'OBJS';
    c_ba_obj_link_table CONSTANT VARCHAR2(30) := 'BA_OBJ_LINKS';
    c_ba_table          CONSTANT VARCHAR2(30) := 'BAS';
    c_expressions_table CONSTANT VARCHAR2(30) := 'EXPRESSIONS';
    c_segments_table    CONSTANT VARCHAR2(30) := 'SEGMENTS';
    c_exp_deps_table    CONSTANT VARCHAR2(30) := 'EXP_DEPS';
    c_domain_table      CONSTANT VARCHAR2(30) := 'DOMAINS';
    c_key_cons_table    CONSTANT VARCHAR2(30) := 'KEY_CONS';
    --
    TYPE tab_varchar250 IS TABLE OF VARCHAR2(250)                      INDEX BY BINARY_INTEGER;
--
--------------------------------------------------------------------------
--
PROCEDURE add_value (p_column VARCHAR2, p_value VARCHAR2);
--
--------------------------------------------------------------------------
--
PROCEDURE add_value_num (p_column VARCHAR2, p_value NUMBER);
--
--------------------------------------------------------------------------
--
PROCEDURE add_value_date (p_column VARCHAR2, p_value DATE);
--
--------------------------------------------------------------------------
--
PROCEDURE clear_globals;
--
--------------------------------------------------------------------------
--
PROCEDURE delete_disco_column_value (p_table_name      VARCHAR2
                                    ,p_where_column    VARCHAR2
                                    ,p_where_value     VARCHAR2
                                    ,p_where_operator  VARCHAR2 DEFAULT '='
                                    ,p_raise_not_found BOOLEAN DEFAULT TRUE
                                    );
--
--------------------------------------------------------------------------
--
FUNCTION get_tab_disco_column_value (p_table_name      VARCHAR2
                                    ,p_column_name     VARCHAR2
                                    ,p_where_column    VARCHAR2
                                    ,p_where_value     VARCHAR2
                                    ,p_where_operator  VARCHAR2 DEFAULT '='
                                    ,p_where_column2   VARCHAR2 DEFAULT Null
                                    ,p_where_value2    VARCHAR2 DEFAULT Null
                                    ,p_where_operator2 VARCHAR2 DEFAULT '='
                                    ,p_lock_record     BOOLEAN DEFAULT FALSE
                                    ) RETURN nm3type.tab_varchar32767;
--
--------------------------------------------------------------------------
--
FUNCTION get_disco_column_value (p_table_name      VARCHAR2
                                ,p_column_name     VARCHAR2
                                ,p_where_column    VARCHAR2
                                ,p_where_value     VARCHAR2
                                ,p_where_operator  VARCHAR2 DEFAULT '='
                                ,p_where_column2   VARCHAR2 DEFAULT Null
                                ,p_where_value2    VARCHAR2 DEFAULT Null
                                ,p_where_operator2 VARCHAR2 DEFAULT '='
                                ,p_raise_not_found BOOLEAN DEFAULT TRUE
                                ,p_lock_record     BOOLEAN DEFAULT FALSE
                                ) RETURN VARCHAR2;
--
--------------------------------------------------------------------------
--
PROCEDURE insert_table_values (p_table_name user_tables.table_name%TYPE);
--
--------------------------------------------------------------------------
--
FUNCTION disco_yn (p_yn VARCHAR2) RETURN PLS_INTEGER;
--
--------------------------------------------------------------------------
--
FUNCTION disco_datatype (p_datatype VARCHAR2) RETURN PLS_INTEGER;
--
--------------------------------------------------------------------------
--
FUNCTION chop_up_into_250 (p_tab_vc32767 nm3type.tab_varchar32767) RETURN tab_varchar250;
--
--------------------------------------------------------------------------
--
PROCEDURE add_who_columns (p_prefix VARCHAR2);
--
--------------------------------------------------------------------------
--
FUNCTION get_tab_rec_hdcv (p_hdtc_hdt_id         NUMBER
                          ,p_hdtc_column_name    VARCHAR2
                          ) RETURN tab_rec_hdcv;
--
--------------------------------------------------------------------------
--
PROCEDURE lock_obj_id (p_obj_id NUMBER);
--
--------------------------------------------------------------------------
--
PROCEDURE set_expression_domain (p_exp_id NUMBER
                                ,p_dom_id NUMBER
                                );
--
--------------------------------------------------------------------------
--
FUNCTION get_exp_id_by_obj_and_dev_key (p_obj_id        NUMBER
                                       ,p_developer_key VARCHAR2
                                       ) RETURN NUMBER;
--
--------------------------------------------------------------------------
--
FUNCTION get_constraint_cols (p_constraint_name all_constraints.constraint_name%TYPE) RETURN nm3type.tab_varchar30;
--
--------------------------------------------------------------------------
--
FUNCTION get_obj_id (p_obj_name          VARCHAR2
                    ,p_raise_not_found   BOOLEAN DEFAULT TRUE
                    ) RETURN NUMBER;
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
--------------------------------------------------------------------------
--
PROCEDURE suck_table_into_disco_tables (p_table_name                IN hig_disco_tables.hdt_table_name%TYPE
                                       ,p_hdba_id                   IN hig_disco_business_areas.hdba_id%TYPE DEFAULT NULL
                                       ,p_seq_no                    IN hig_disco_tables.hdt_seq_no%TYPE      DEFAULT NULL
                                       ,p_hide_who_cols             IN BOOLEAN                               DEFAULT TRUE
                                       ,p_create_fk_parents_if_reqd IN BOOLEAN                               DEFAULT TRUE
                                       ) IS
--
   l_rec_hdba hig_disco_business_areas%ROWTYPE;
   l_rec_hdt  hig_disco_tables%ROWTYPE;
   l_hdba_id  hig_disco_business_areas.hdba_id%TYPE := p_hdba_id;
--
   CURSOR cs_comments (c_table_name VARCHAR2) IS
   SELECT SUBSTR(comments,1,240)
    FROM  all_tab_comments
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = c_table_name;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'suck_table_into_disco_tables');
--
   IF NOT (nm3ddl.does_object_exist   (p_object_name => p_table_name
                                      ,p_object_type => 'TABLE'
                                      )
          OR nm3ddl.does_object_exist (p_object_name => p_table_name
                                      ,p_object_type => 'VIEW'
                                      )
          )
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 256
                    ,pi_supplementary_info => p_table_name
                    );
   END IF;
--
   IF l_hdba_id IS NULL
    THEN
      l_hdba_id := get_single_hdba_id;
   END IF;
--
   l_rec_hdba              := get_hdba (l_hdba_id);
--
   l_rec_hdt.hdt_id           := next_hdt_id_seq;
   l_rec_hdt.hdt_hdba_id      := l_hdba_id;
   l_rec_hdt.hdt_table_name   := p_table_name;
   l_rec_hdt.hdt_display_name := LOWER(REPLACE(p_table_name,'_',' '));
   IF p_seq_no IS NULL
    THEN
      l_rec_hdt.hdt_seq_no    := suggest_next_bol_sequence (l_rec_hdba.hdba_name);
   ELSE
      l_rec_hdt.hdt_seq_no    := p_seq_no;
   END IF;
   OPEN  cs_comments (p_table_name);
   FETCH cs_comments INTO l_rec_hdt.hdt_description;
   CLOSE cs_comments;
--
   ins_hdt (l_rec_hdt);
--
   INSERT INTO hig_disco_tab_columns
         (hdtc_hdt_id
         ,hdtc_column_name
         ,hdtc_display_name
        -- ,hdtc_column_source
         ,hdtc_display_seq
         ,hdtc_datatype
         ,hdtc_max_data_width
         )
   SELECT l_rec_hdt.hdt_id
         ,column_name
         ,LOWER(REPLACE(column_name,'_',' '))
       --  ,column_name
         ,column_id
         ,data_type
         ,NVL(data_precision,data_length)
    FROM  all_tab_columns
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = p_table_name
    AND   data_type IN (nm3type.c_date, nm3type.c_varchar, nm3type.c_number);
--
   UPDATE hig_disco_tab_columns
    SET   hdtc_description = (SELECT SUBSTR(comments,1,240)
                               FROM  all_col_comments
                              WHERE  owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
                               AND   table_name  = p_table_name
                               AND   column_name = hdtc_column_name
                             )
   WHERE  hdtc_hdt_id      = l_rec_hdt.hdt_id;
--
   UPDATE hig_disco_tab_columns
    SET   hdtc_format_mask = nm3type.c_full_date_time_format
   WHERE  hdtc_hdt_id      = l_rec_hdt.hdt_id
    AND  (   hdtc_column_name LIKE '%_DATE_MODIFIED'
          OR hdtc_column_name LIKE '%_DATE_CREATED'
         );
--
   IF p_hide_who_cols
    THEN
      UPDATE hig_disco_tab_columns
       SET   hdtc_visible     = 'N'
      WHERE  hdtc_hdt_id      = l_rec_hdt.hdt_id
       AND  (   hdtc_column_name LIKE '%_DATE_MODIFIED'
             OR hdtc_column_name LIKE '%_DATE_CREATED'
             OR hdtc_column_name LIKE '%_CREATED_BY'
             OR hdtc_column_name LIKE '%_MODIFIED_BY'
            );
   END IF;
--
   add_fk_links_for_table (pi_table_name       => p_table_name
                          ,pi_create_if_needed => p_create_fk_parents_if_reqd
                          );
--
   nm_debug.proc_end(g_package_name,'suck_table_into_disco_tables');
--
END suck_table_into_disco_tables;
--
--------------------------------------------------------------------------
--
FUNCTION get_hdba (p_hdba_id         hig_disco_business_areas.hdba_id%TYPE
                  ,p_raise_not_found BOOLEAN DEFAULT TRUE
                  ) RETURN hig_disco_business_areas%ROWTYPE IS
   CURSOR cs_hdba (c_hdba_id hig_disco_business_areas.hdba_id%TYPE) IS
   SELECT *
    FROM  hig_disco_business_areas
   WHERE  hdba_id = c_hdba_id;
   l_found    BOOLEAN;
   l_rec_hdba hig_disco_business_areas%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_hdba');
--
   OPEN  cs_hdba (p_hdba_id);
   FETCH cs_hdba INTO l_rec_hdba;
   l_found := cs_hdba%FOUND;
   CLOSE cs_hdba;
   IF NOT l_found
    AND p_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_business_areas.hdba_id = '||p_hdba_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_hdba');
--
   RETURN l_rec_hdba;
END get_hdba;
--
--------------------------------------------------------------------------
--
FUNCTION get_hdba (p_hdba_name       hig_disco_business_areas.hdba_name%TYPE
                  ,p_raise_not_found BOOLEAN DEFAULT TRUE
                  ) RETURN hig_disco_business_areas%ROWTYPE IS
   CURSOR cs_hdba (c_hdba_name hig_disco_business_areas.hdba_name%TYPE) IS
   SELECT *
    FROM  hig_disco_business_areas
   WHERE  hdba_name = c_hdba_name;
   l_found    BOOLEAN;
   l_rec_hdba hig_disco_business_areas%ROWTYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_hdba');
--
   OPEN  cs_hdba (p_hdba_name);
   FETCH cs_hdba INTO l_rec_hdba;
   l_found := cs_hdba%FOUND;
   CLOSE cs_hdba;
   IF NOT l_found
    AND p_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_business_areas.hdba_name = '||p_hdba_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_hdba');
--
   RETURN l_rec_hdba;
END get_hdba;
--
--------------------------------------------------------------------------
--
FUNCTION next_hdba_id_seq RETURN NUMBER IS
   l_retval NUMBER;
BEGIN
   SELECT hdba_id_seq.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_hdba_id_seq;
--
--------------------------------------------------------------------------
--
FUNCTION next_hdt_id_seq RETURN NUMBER IS
   l_retval NUMBER;
BEGIN
   SELECT hdt_id_seq.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_hdt_id_seq;
--
--------------------------------------------------------------------------
--
FUNCTION curr_hdt_id_seq RETURN NUMBER IS
   l_retval NUMBER;
BEGIN
   SELECT hdt_id_seq.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_hdt_id_seq;
--
--------------------------------------------------------------------------
--
PROCEDURE ins_hdt (p_rec_hdt hig_disco_tables%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_hdt');
--
   INSERT INTO hig_disco_tables
          (hdt_id
          ,hdt_hdba_id
          ,hdt_table_name
          ,hdt_display_name
          ,hdt_seq_no
          ,hdt_description
          )
   VALUES (p_rec_hdt.hdt_id
          ,p_rec_hdt.hdt_hdba_id
          ,p_rec_hdt.hdt_table_name
          ,p_rec_hdt.hdt_display_name
          ,p_rec_hdt.hdt_seq_no
          ,p_rec_hdt.hdt_description
          );
--
   nm_debug.proc_end(g_package_name,'ins_hdt');
--
END ins_hdt;
--
--------------------------------------------------------------------------
--
PROCEDURE create_table_in_eul (p_table_name               hig_disco_tables.hdt_table_name%TYPE
                              ,p_recreate                 BOOLEAN DEFAULT FALSE
                              ,p_create_fk                BOOLEAN DEFAULT TRUE
                              ,p_create_fk_parents_in_eul BOOLEAN DEFAULT TRUE
                              ) IS
   l_rec_hdt            hig_disco_tables%ROWTYPE;
   c_obj_id  CONSTANT   NUMBER       := disco_seq_nextval;
   l_ba_id              NUMBER;
   l_dom_id             NUMBER;
   l_existing_obj_id    NUMBER;
   l_restriction_exp_id NUMBER;
   l_tab_rec_hdtc       tab_rec_hdtc;
   l_rec_hdtc           hig_disco_tab_columns%ROWTYPE;
   l_tab_rec_hdcv       tab_rec_hdcv;
   l_tab_exp_id         nm3type.tab_number;
   l_tab_varchar32767   nm3type.tab_varchar32767;
   l_tab_varchar250     tab_varchar250;
--
   l_segs_reqd          PLS_INTEGER;
   l_seg_chunk          VARCHAR2(250);
--
   PROCEDURE append_tab_vc (p_text VARCHAR2) IS
   BEGIN
      nm3ddl.append_tab_varchar(l_tab_varchar32767,p_text,FALSE);
   END append_tab_vc;
   FUNCTION get_chunk (p_index PLS_INTEGER) RETURN VARCHAR2 IS
      l_retval VARCHAR2(250);
   BEGIN
 --     nm_debug.debug('p_index = '||p_index);
      IF l_tab_varchar250.EXISTS(p_index)
       THEN
         l_retval := l_tab_varchar250(p_index);
      END IF;
     -- nm_debug.debug('chunk'||p_index||'..'||l_retval||'..');
      RETURN l_retval;
   END get_chunk;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_table_in_eul');
--
--nm_debug.delete_debug(TRUE);
--nm_debug.debug_on;
   l_rec_hdt := get_hdt (p_table_name);
--
   l_existing_obj_id := get_obj_id (p_obj_developer_key => p_table_name
                                   ,p_raise_not_found   => FALSE
                                   );
   IF l_existing_obj_id IS NOT NULL
    THEN
      IF p_recreate
       THEN
         -- Delete it all
         delete_object_from_eul (p_obj_id => l_existing_obj_id);
      ELSE
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 64
                       ,pi_supplementary_info => p_table_name
                       );
      END IF;
   END IF;
--
   IF get_obj_id (p_obj_name        => l_rec_hdt.hdt_display_name
                 ,p_raise_not_found => FALSE
                 ) IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 64
                    ,pi_supplementary_info => l_rec_hdt.hdt_display_name
                    );
   END IF;
--
   clear_globals;
   add_value_num  ('OBJ_ID',c_obj_id);
   add_value      ('OBJ_TYPE',c_sobj);
   add_value      ('OBJ_NAME',l_rec_hdt.hdt_display_name);
   add_value      ('OBJ_DEVELOPER_KEY',p_table_name);
   add_value      ('OBJ_DESCRIPTION',l_rec_hdt.hdt_description);
   add_value_num  ('OBJ_BA_ID',Null);
   add_value_num  ('OBJ_HIDDEN',0);
   add_value_num  ('OBJ_DISTINCT_FLAG',0);
   add_value_num  ('OBJ_NDETERMINISTIC',0);
   add_value      ('OBJ_CBO_HINT',Null);
   add_value      ('OBJ_EXT_OBJECT',Null);
   add_value      ('OBJ_EXT_OWNER',Sys_Context('NM3CORE','APPLICATION_OWNER'));
   add_value      ('OBJ_EXT_DB_LINK',Null);
   add_value      ('OBJ_OBJECT_SQL1',Null);
   add_value      ('OBJ_OBJECT_SQL2',Null);
   add_value      ('OBJ_OBJECT_SQL3',Null);
   add_value      ('SOBJ_EXT_TABLE',p_table_name);
   add_value      ('OBJ_USER_PROP2',Null);
   add_value      ('OBJ_USER_PROP1',Null);
   add_value_num  ('OBJ_ELEMENT_STATE',0);
   add_who_columns('OBJ');
   add_value_num  ('NOTM',0);
   insert_table_values (c_obj_table);
--
   l_ba_id := get_ba_id (get_hdba(l_rec_hdt.hdt_hdba_id).hdba_name);
--
   clear_globals;
   add_value_num  ('BOL_ID',disco_seq_nextval);
   add_value_num  ('BOL_BA_ID',l_ba_id);
   add_value_num  ('BOL_OBJ_ID',c_obj_id);
   add_value_num  ('BOL_SEQUENCE',l_rec_hdt.hdt_seq_no);
   add_value_num  ('BOL_ELEMENT_STATE',0);
   add_who_columns('BOL');
   add_value_num  ('NOTM',0);
   insert_table_values (c_ba_obj_link_table);
--
   l_tab_rec_hdtc := get_tab_hdtc (l_rec_hdt.hdt_id);
--
   FOR i IN 1..l_tab_rec_hdtc.COUNT
    LOOP
--
      l_rec_hdtc      := l_tab_rec_hdtc(i);
      validate_rec_hdtc (p_rec_hdtc => l_rec_hdtc);
      l_dom_id        := Null;
      l_tab_exp_id(i) := disco_seq_nextval;
--
      clear_globals;
      add_value_num  ('EXP_ID',l_tab_exp_id(i));
      add_value      ('EXP_TYPE',c_exp_type_co);
      add_value      ('EXP_NAME',l_rec_hdtc.hdtc_display_name);
      add_value      ('EXP_DEVELOPER_KEY',l_rec_hdtc.hdtc_column_name);
      add_value      ('EXP_DESCRIPTION',l_rec_hdtc.hdtc_description);
      add_value      ('EXP_FORMULA1','[6,'||l_tab_exp_id(i)||']');
      add_value_num  ('EXP_DATA_TYPE',disco_datatype(l_rec_hdtc.hdtc_datatype));
      add_value_num  ('EXP_SEQUENCE',l_rec_hdtc.hdtc_display_seq);
      add_value_num  ('IT_DOM_ID',Null);
      add_value_num  ('IT_OBJ_ID',c_obj_id);
      add_value_num  ('IT_DOC_ID',Null);
      DECLARE
         l_mask nm3type.max_varchar2 := l_rec_hdtc.hdtc_format_mask;
      BEGIN
         IF l_mask IS NULL
          THEN
            IF l_rec_hdtc.hdtc_datatype = nm3type.c_date
             THEN
               l_mask := nm3type.c_default_date_format;
            END IF;
         END IF;
         add_value   ('IT_FORMAT_MASK',l_mask);
      END;
      add_value_num  ('IT_MAX_DATA_WIDTH',l_rec_hdtc.hdtc_max_data_width);
      add_value_num  ('IT_MAX_DISP_WIDTH',Null);
      add_value_num  ('IT_ALIGNMENT',1);
      add_value_num  ('IT_WORD_WRAP',disco_yn(l_rec_hdtc.hdtc_word_wrap));
      add_value      ('IT_DISP_NULL_VAL',Null);
      add_value_num  ('IT_FUN_ID',110);
      add_value      ('IT_HEADING',l_rec_hdtc.hdtc_display_name);
      add_value_num  ('IT_HIDDEN',disco_yn(nm3flx.i_t_e(l_rec_hdtc.hdtc_visible='Y','N','Y')));
      add_value_num  ('IT_PLACEMENT',3);
      add_value      ('IT_USER_DEF_FMT',Null);
      add_value_num  ('IT_CASE_STORAGE',3);
      add_value_num  ('IT_CASE_DISPLAY',1);
      add_value      ('IT_EXT_COLUMN',l_rec_hdtc.hdtc_column_name);
      add_value_num  ('CI_IT_ID',Null);
      add_value_num  ('CI_RUNTIME_ITEM',Null);
      add_value_num  ('PAR_MULTIPLE_VALS',Null);
      add_value_num  ('CO_NULLABLE',1);
      add_value_num  ('P_CASE_SENSITIVE',Null);
      add_value_num  ('JP_KEY_ID',Null);
      add_value_num  ('FIL_OBJ_ID',Null);
      add_value_num  ('FIL_DOC_ID',Null);
      add_value_num  ('FIL_RUNTIME_FILTER',Null);
      add_value_num  ('FIL_APP_TYPE',Null);
      add_value      ('FIL_EXT_FILTER',Null);
      add_value      ('EXP_USER_PROP2',Null);
      add_value      ('EXP_USER_PROP1',Null);
      add_value_num  ('EXP_ELEMENT_STATE',0);
      add_who_columns('EXP');
      add_value_num  ('NOTM',0);
      insert_table_values (c_expressions_table);
      IF l_rec_hdtc.hdtc_item_class = 'Y'
       THEN
         DECLARE
            l_name     VARCHAR2(100) := c_obj_id||'_'||p_table_name||'_'||l_rec_hdtc.hdtc_column_name||'_LOV';
         BEGIN
            l_dom_id := disco_seq_nextval;
            clear_globals;
            add_value_num  ('DOM_ID',l_dom_id);
            add_value      ('DOM_NAME',l_name);
            add_value      ('DOM_DEVELOPER_KEY',l_name);
            add_value      ('DOM_DESCRIPTION',Null);
            add_value_num  ('DOM_DATA_TYPE',disco_datatype(l_rec_hdtc.hdtc_datatype));
            add_value_num  ('DOM_LOGICAL_ITEM',0);
            add_value_num  ('DOM_SYS_GENERATED',0);
            add_value_num  ('DOM_CARDINALITY',Null);
            add_value_num  ('DOM_LAST_EXEC_TIME',Null);
            add_value_num  ('DOM_CACHED',1);
            add_value_num  ('DOM_IT_ID_LOV',l_tab_exp_id(i));
            add_value_num  ('DOM_IT_ID_RANK',Null);
            add_value_num  ('DOM_USER_PROP2',Null);
            add_value_num  ('DOM_USER_PROP1',Null);
            add_value_num  ('DOM_ELEMENT_STATE',0);
            add_who_columns('DOM');
            add_value_num  ('NOTM',0);
            insert_table_values (c_domain_table);
            set_expression_domain (p_exp_id => l_tab_exp_id(i)
                                  ,p_dom_id => l_dom_id
                                  );
         END;
      END IF;
      --
      l_tab_rec_hdcv  := get_tab_rec_hdcv (l_rec_hdt.hdt_id,l_rec_hdtc.hdtc_column_name);
      IF l_tab_rec_hdcv.COUNT > 0
       THEN
         -- It has values specified. Create the restriction records
         FOR j IN 1..l_tab_rec_hdcv.COUNT
          LOOP
            l_restriction_exp_id := disco_seq_nextval;
            clear_globals;
            add_value_num  ('EXP_ID',l_restriction_exp_id);
            add_value      ('EXP_TYPE',c_exp_type_fil);
            DECLARE
               l_exp_name nm3type.max_varchar2;
            BEGIN
               l_exp_name := l_rec_hdtc.hdtc_display_name||' = '||nm3flx.string(l_tab_rec_hdcv(j).hdcv_meaning);
               add_value   ('EXP_NAME',l_exp_name);
               add_value   ('EXP_DEVELOPER_KEY',l_tab_exp_id(i)||'_'||l_rec_hdtc.hdtc_column_name||'_'||j);
               IF l_tab_rec_hdcv(j).hdcv_meaning != l_tab_rec_hdcv(j).hdcv_value
                THEN
                  l_exp_name := l_exp_name||' ('||l_tab_rec_hdcv(j).hdcv_value||')';
               END IF;
               add_value   ('EXP_DESCRIPTION',l_exp_name);
            END;
            add_value      ('EXP_FORMULA1','[1,81]([6,'||l_tab_exp_id(i)||'],[5,1,"'||l_tab_rec_hdcv(j).hdcv_value||'"])');
            add_value_num  ('EXP_DATA_TYPE',10);
            add_value_num  ('EXP_SEQUENCE',Null);
            add_value_num  ('IT_DOM_ID',Null);
            add_value_num  ('IT_OBJ_ID',Null);
            add_value_num  ('IT_DOC_ID',Null);
            add_value      ('IT_FORMAT_MASK',Null);
            add_value_num  ('IT_MAX_DATA_WIDTH',Null);
            add_value_num  ('IT_MAX_DISP_WIDTH',Null);
            add_value_num  ('IT_ALIGNMENT',Null);
            add_value_num  ('IT_WORD_WRAP',Null);
            add_value      ('IT_DISP_NULL_VAL',Null);
            add_value_num  ('IT_FUN_ID',Null);
            add_value      ('IT_HEADING',Null);
            add_value_num  ('IT_HIDDEN',Null);
            add_value_num  ('IT_PLACEMENT',Null);
            add_value      ('IT_USER_DEF_FMT',Null);
            add_value_num  ('IT_CASE_STORAGE',Null);
            add_value_num  ('IT_CASE_DISPLAY',Null);
            add_value      ('IT_EXT_COLUMN',Null);
            add_value_num  ('CI_IT_ID',Null);
            add_value_num  ('CI_RUNTIME_ITEM',Null);
            add_value_num  ('PAR_MULTIPLE_VALS',Null);
            add_value_num  ('CO_NULLABLE',Null);
            add_value_num  ('P_CASE_SENSITIVE',1);
            add_value_num  ('JP_KEY_ID',Null);
            add_value_num  ('FIL_OBJ_ID',c_obj_id);
            add_value_num  ('FIL_DOC_ID',Null);
            add_value_num  ('FIL_RUNTIME_FILTER',1);
            add_value_num  ('FIL_APP_TYPE',0);
            add_value      ('FIL_EXT_FILTER',Null);
            add_value      ('EXP_USER_PROP2',Null);
            add_value      ('EXP_USER_PROP1',Null);
            add_value_num  ('EXP_ELEMENT_STATE',0);
            add_who_columns('EXP');
            add_value_num  ('NOTM',0);
            insert_table_values (c_expressions_table);
            clear_globals;
            add_value_num  ('ED_ID',disco_seq_nextval);
            add_value      ('ED_TYPE',c_ed_type_ped);
            add_value_num  ('PD_P_ID',l_restriction_exp_id);
            add_value_num  ('PED_EXP_ID',l_tab_exp_id(i));
            add_value_num  ('PFD_FUN_ID',Null);
            add_value_num  ('PSD_SQ_ID',Null);
            add_value_num  ('CD_EXP_ID',Null);
            add_value_num  ('CFD_FUN_ID',Null);
            add_value_num  ('CID_EXP_ID',Null);
            add_value_num  ('ED_ELEMENT_STATE',0);
            add_who_columns('ED');
            add_value_num  ('NOTM',0);
            insert_table_values (c_exp_deps_table);
         END LOOP;
      END IF;
--
   END LOOP;
--
   l_tab_varchar32767.DELETE;
   append_tab_vc ('(SELECT');
   FOR i IN 1..l_tab_rec_hdtc.COUNT
    LOOP
      l_rec_hdtc      := l_tab_rec_hdtc(i);
      IF i > 1
       THEN
         append_tab_vc(',');
      END IF;
      append_tab_vc(' '||NVL(l_rec_hdtc.hdtc_column_source,l_rec_hdtc.hdtc_column_name)||' AS i'||l_tab_exp_id(i));
   END LOOP;
   append_tab_vc (' FROM '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_rec_hdt.hdt_table_name||')');
-- nm3tab_varchar.debug_tab_varchar (l_tab_varchar32767);
   l_tab_varchar250 := chop_up_into_250 (l_tab_varchar32767);
--
   IF MOD(l_tab_varchar250.COUNT,4) = 0
    THEN
      l_segs_reqd := l_tab_varchar250.COUNT/4;
   ELSE
      l_segs_reqd := TRUNC(l_tab_varchar250.COUNT/4,0)+1;
   END IF;
--
--nm_debug.debug(l_segs_reqd);
   FOR i IN 1..l_segs_reqd
    LOOP
      clear_globals;
      add_value_num  ('SEG_ID',disco_seq_nextval);
      add_value_num  ('SEG_SEG_TYPE',1);
      add_value_num  ('SEG_SEQUENCE',i);
      add_value_num  ('SEG_OBJ_ID',c_obj_id);
      add_value_num  ('SEG_SUMO_ID',Null);
      add_value_num  ('SEG_CUO_ID',Null);
      add_value_num  ('SEG_BQ_ID',Null);
      add_value_num  ('SEG_EXP_ID',Null);
      add_value_num  ('SEG_SMS_ID',Null);
      add_value_num  ('SEG_EL_ID',Null);
      FOR j IN 1..4
       LOOP
         add_value('SEG_CHUNK'||j,get_chunk (((i-1)*4)+j));
      END LOOP;
      add_value_num  ('SEG_ELEMENT_STATE',0);
      add_who_columns('SEG');
      add_value_num  ('NOTM',0);
      insert_table_values (c_segments_table);
   END LOOP;
--
   IF p_create_fk
    THEN
      create_all_fk_by_child (p_child_table_name         => p_table_name
                             ,p_create_fk_parents_in_eul => p_create_fk_parents_in_eul
                             );
   END IF;
--nm_debug.debug_off;
--
   nm_debug.proc_end(g_package_name,'create_table_in_eul');
--
END create_table_in_eul;
--
--------------------------------------------------------------------------
--
FUNCTION get_hdt (p_hdt_table_name  hig_disco_tables.hdt_table_name%TYPE
                 ,p_raise_not_found BOOLEAN DEFAULT TRUE
                 ) RETURN hig_disco_tables%ROWTYPE IS
   CURSOR cs_hdt (c_hdt_table_name hig_disco_tables.hdt_table_name%TYPE) IS
   SELECT *
    FROM  hig_disco_tables
   WHERE  hdt_table_name = c_hdt_table_name;
   l_rec_hdt hig_disco_tables%ROWTYPE;
   l_found    BOOLEAN;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_hdt');
--
   OPEN  cs_hdt (p_hdt_table_name);
   FETCH cs_hdt INTO l_rec_hdt;
   l_found := cs_hdt%FOUND;
   CLOSE cs_hdt;
   IF NOT l_found
    AND p_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_tables.hdt_table_name = '||p_hdt_table_name
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_hdt');
--
   RETURN l_rec_hdt;
END get_hdt;
--
--------------------------------------------------------------------------
--
FUNCTION get_hdt (p_hdt_id          hig_disco_tables.hdt_id%TYPE
                 ,p_raise_not_found BOOLEAN DEFAULT TRUE
                 ) RETURN hig_disco_tables%ROWTYPE IS
   CURSOR cs_hdt (c_hdt_id hig_disco_tables.hdt_id%TYPE) IS
   SELECT *
    FROM  hig_disco_tables
   WHERE  hdt_id = c_hdt_id;
   l_rec_hdt hig_disco_tables%ROWTYPE;
   l_found    BOOLEAN;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_hdt');
--
   OPEN  cs_hdt (p_hdt_id);
   FETCH cs_hdt INTO l_rec_hdt;
   l_found := cs_hdt%FOUND;
   CLOSE cs_hdt;
   IF NOT l_found
    AND p_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_tables.hdt_id = '||p_hdt_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_hdt');
--
   RETURN l_rec_hdt;
END get_hdt;
--
--------------------------------------------------------------------------
--
FUNCTION disco_seq_nextval RETURN NUMBER IS
   l_cur nm3type.ref_cursor;
   l_retval NUMBER;
BEGIN
--
   OPEN  l_cur FOR 'SELECT '||g_complete_prefix||g_seq_name||'.NEXTVAL FROM DUAL';
   FETCH l_cur INTO l_retval;
   CLOSE l_cur;
--
   RETURN l_retval;
--
END disco_seq_nextval;
--
--------------------------------------------------------------------------
--
FUNCTION get_prefix RETURN VARCHAR2 IS
--
   CURSOR cs_au (c_user VARCHAR2) IS
   SELECT 1
    FROM  all_users
   WHERE  username = c_user;
--
   CURSOR cs_at (c_owner VARCHAR2
                ,c_table VARCHAR2
                ) IS
   SELECT 1
    FROM  all_tables
   WHERE  owner     = c_owner
    AND   table_name LIKE c_table||'%'
    AND   ROWNUM    = 1;
--
   l_dummy           PLS_INTEGER;
   l_found           BOOLEAN;
   c_prefix CONSTANT VARCHAR2(30) := 'EUL'||g_disco_version||'_';
--
BEGIN
--
   IF g_disco_user IS NULL
    THEN
      dbms_session.reset_package;
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 179
                    ,pi_supplementary_info => 'Discoverer User not set'
                    );
   ELSIF g_disco_version NOT IN ('4','5')
    THEN
      dbms_session.reset_package;
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 179
                    ,pi_supplementary_info => 'Disco Version not supported'
                    );
   ELSE
   --
      OPEN  cs_au (g_disco_user);
      FETCH cs_au INTO l_dummy;
      l_found := cs_au%FOUND;
      CLOSE cs_au;
      IF NOT l_found
       THEN
         dbms_session.reset_package;
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 179
                       ,pi_supplementary_info => 'User "'||g_disco_user||'" does not exist'
                       );
      END IF;
   --
      OPEN  cs_at (g_disco_user, c_prefix);
      FETCH cs_at INTO l_dummy;
      l_found := cs_at%FOUND;
      CLOSE cs_at;
      IF NOT l_found
       THEN
         dbms_session.reset_package;
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 179
                       ,pi_supplementary_info => 'No disco tables (v'||g_disco_version||') owned by user "'||g_disco_user||'"'
                       );
      END IF;
   --
   END IF;
--
   RETURN c_prefix;
--
END get_prefix;
--
--------------------------------------------------------------------------
--
PROCEDURE insert_table_values (p_table_name user_tables.table_name%TYPE) IS
   l_block nm3type.max_varchar2;
   l_comma VARCHAR2(30);
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      IF p_nl
       THEN
         append(CHR(10),FALSE);
      END IF;
      l_block := l_block||p_text;
   END append;
BEGIN
--
   nm_debug.proc_start(g_package_name,'insert_table_values');
--
   --append ('DECLARE',FALSE);
   append ('BEGIN',FALSE);
   append ('   INSERT INTO '||g_complete_prefix||p_table_name);
   l_comma := '          (';
   FOR i IN 1..g_tab_cols.COUNT
    LOOP
      append (l_comma||g_tab_cols(i));
      l_comma := '          ,';
   END LOOP;
   append ('          )');
   l_comma := '   VALUES (';
   FOR i IN 1..g_tab_cols.COUNT
    LOOP
      append (l_comma||g_package_name||'.g_tab_values_'||lower(g_tab_datatypes(i))||'('||i||')');
      l_comma := '          ,';
   END LOOP;
   append ('          );');
   append ('END;');
   --
--   nm_debug.debug(l_block);
   EXECUTE IMMEDIATE l_block;
--
   nm_debug.proc_end(g_package_name,'insert_table_values');
--
END insert_table_values;
--
--------------------------------------------------------------------------
--
PROCEDURE add_value (p_column VARCHAR2, p_value VARCHAR2) IS
   c_count CONSTANT PLS_INTEGER := g_tab_cols.COUNT + 1;
BEGIN
   g_tab_cols(c_count)            := p_column;
   g_tab_datatypes(c_count)       := nm3type.c_varchar;
   g_tab_values_varchar2(c_count) := p_value;
END add_value;
--
--------------------------------------------------------------------------
--
PROCEDURE add_value_num (p_column VARCHAR2, p_value NUMBER) IS
   c_count CONSTANT PLS_INTEGER := g_tab_cols.COUNT + 1;
BEGIN
   g_tab_cols(c_count)          := p_column;
   g_tab_datatypes(c_count)     := nm3type.c_number;
   g_tab_values_number(c_count) := p_value;
END add_value_num;
--
--------------------------------------------------------------------------
--
PROCEDURE add_value_date (p_column VARCHAR2, p_value DATE) IS
   c_count CONSTANT PLS_INTEGER := g_tab_cols.COUNT + 1;
BEGIN
   g_tab_cols(c_count)        := p_column;
   g_tab_datatypes(c_count)   := nm3type.c_date;
   g_tab_values_date(c_count) := p_value;
END add_value_date;
--
--------------------------------------------------------------------------
--
PROCEDURE clear_globals IS
BEGIN
    g_tab_cols.DELETE;
    g_tab_values_varchar2.DELETE;
    g_tab_values_date.DELETE;
    g_tab_values_number.DELETE;
    g_tab_datatypes.DELETE;
END clear_globals;
--
--------------------------------------------------------------------------
--
PROCEDURE delete_disco_column_value (p_table_name      VARCHAR2
                                    ,p_where_column    VARCHAR2
                                    ,p_where_value     VARCHAR2
                                    ,p_where_operator  VARCHAR2 DEFAULT '='
                                    ,p_raise_not_found BOOLEAN DEFAULT TRUE
                                    ) IS
   l_complete_table_name VARCHAR2(61);
   l_tab_vc              nm3type.tab_varchar32767;
   l_block               nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start(g_package_name,'delete_disco_column_value');
--
   l_complete_table_name := g_complete_prefix||p_table_name;
--
   l_tab_vc := get_tab_disco_column_value (p_table_name      => p_table_name
                                          ,p_column_name     => 'ROWIDTOCHAR(ROWID)'
                                          ,p_where_column    => p_where_column
                                          ,p_where_value     => p_where_value
                                          ,p_where_operator  => p_where_operator
                                          ,p_lock_record     => TRUE
                                          );
   g_tab_rowid.DELETE;
   IF l_tab_vc.COUNT = 0
    THEN
      IF p_raise_not_found
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 67
                       ,pi_supplementary_info => l_complete_table_name||'.'||p_where_column||' '||p_where_operator||' '||p_where_value
                       );
      END IF;
   ELSE
      FOR i IN 1..l_tab_vc.COUNT
       LOOP
         g_tab_rowid(i) := CHARTOROWID(l_tab_vc(i));
      END LOOP;
   --
      l_block :=            'BEGIN'
                 ||CHR(10)||'   FORALL i IN 1..'||g_package_name||'.g_tab_rowid.COUNT'
                 ||CHR(10)||'      DELETE FROM '||l_complete_table_name
                 ||CHR(10)||'      WHERE  ROWID = '||g_package_name||'.g_tab_rowid(i);'
                 ||CHR(10)||'END;';
      EXECUTE IMMEDIATE l_block;
   END IF;
--
   nm_debug.proc_end(g_package_name,'delete_disco_column_value');
--
--
END delete_disco_column_value;
--
--------------------------------------------------------------------------
--
FUNCTION get_disco_column_value (p_table_name      VARCHAR2
                                ,p_column_name     VARCHAR2
                                ,p_where_column    VARCHAR2
                                ,p_where_value     VARCHAR2
                                ,p_where_operator  VARCHAR2 DEFAULT '='
                                ,p_where_column2   VARCHAR2 DEFAULT Null
                                ,p_where_value2    VARCHAR2 DEFAULT Null
                                ,p_where_operator2 VARCHAR2 DEFAULT '='
                                ,p_raise_not_found BOOLEAN  DEFAULT TRUE
                                ,p_lock_record     BOOLEAN  DEFAULT FALSE
                                ) RETURN VARCHAR2 IS
   l_retval              nm3type.max_varchar2;
   l_tab_values          nm3type.tab_varchar32767;
   l_supp_info           nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_disco_column_value');
--
   l_tab_values := get_tab_disco_column_value (p_table_name      => p_table_name
                                              ,p_column_name     => p_column_name
                                              ,p_where_column    => p_where_column
                                              ,p_where_value     => p_where_value
                                              ,p_where_operator  => p_where_operator
                                              ,p_where_column2   => p_where_column2
                                              ,p_where_value2    => p_where_value2
                                              ,p_where_operator2 => p_where_operator2
                                              ,p_lock_record     => p_lock_record
                                              );
   l_supp_info := g_complete_prefix||p_table_name||'.'||p_where_column||' '||p_where_operator||' '||p_where_value;
   IF   l_tab_values.COUNT = 0
    AND p_raise_not_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => l_supp_info
                    );
      l_retval := Null;
   ELSIF l_tab_values.COUNT = 1
    THEN
      l_retval := l_tab_values(1);
   ELSIF l_tab_values.COUNT > 1
    THEN
      -- too many rows
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 105
                    ,pi_supplementary_info => l_supp_info
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_disco_column_value');
--
   RETURN l_retval;
--
END get_disco_column_value;
--
--------------------------------------------------------------------------
--
FUNCTION get_tab_disco_column_value (p_table_name      VARCHAR2
                                    ,p_column_name     VARCHAR2
                                    ,p_where_column    VARCHAR2
                                    ,p_where_value     VARCHAR2
                                    ,p_where_operator  VARCHAR2 DEFAULT '='
                                    ,p_where_column2   VARCHAR2 DEFAULT Null
                                    ,p_where_value2    VARCHAR2 DEFAULT Null
                                    ,p_where_operator2 VARCHAR2 DEFAULT '='
                                    ,p_lock_record     BOOLEAN  DEFAULT FALSE
                                    ) RETURN nm3type.tab_varchar32767 IS
   l_cur                 nm3type.ref_cursor;
   l_dummy               nm3type.max_varchar2;
   l_sql                 nm3type.max_varchar2;
   l_retval              nm3type.tab_varchar32767;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_disco_column_value');
--
   l_sql := 'SELECT '||p_column_name||' FROM '||g_complete_prefix||p_table_name;
--
   IF p_where_column IS NOT NULL
    THEN
      l_sql := l_sql||' WHERE '||p_where_column||' '||p_where_operator||' :a';
   END IF;
--
   IF p_where_column2 IS NOT NULL
    THEN
      l_sql := l_sql||' AND '||p_where_column2||' '||p_where_operator2||' :b';
   END IF;
--
   IF p_lock_record
    THEN
      l_sql := l_sql||' FOR UPDATE NOWAIT';
   END IF;
--   nm_debug.debug(l_sql);
--
   IF p_where_column IS NULL
    THEN
      OPEN  l_cur FOR l_sql;
   ELSIF p_where_column2 IS NULL
    THEN
      OPEN  l_cur FOR l_sql USING p_where_value;
   ELSE
      OPEN  l_cur FOR l_sql USING p_where_value, p_where_value2;
   END IF;
   --
   LOOP
      FETCH l_cur INTO l_dummy;
      EXIT WHEN l_cur%NOTFOUND;
      l_retval(l_retval.COUNT+1) := l_dummy;
   END LOOP;
   CLOSE l_cur;
--
   nm_debug.proc_end(g_package_name,'get_tab_disco_column_value');
--
   RETURN l_retval;
--
END get_tab_disco_column_value;
--
--------------------------------------------------------------------------
--
FUNCTION get_ba_id (p_ba_name VARCHAR2) RETURN NUMBER IS
BEGIN
   RETURN TO_NUMBER(get_disco_column_value (p_table_name     => c_ba_table
                                           ,p_column_name    => 'BA_ID'
                                           ,p_where_column   => 'BA_DEVELOPER_KEY'
                                           ,p_where_value    => p_ba_name
                                           ,p_where_operator => '='
                                           )
                   );
END get_ba_id;
--
--------------------------------------------------------------------------
--
FUNCTION get_exp_id (p_exp_developer_key VARCHAR2) RETURN NUMBER IS
BEGIN
   RETURN TO_NUMBER(get_disco_column_value (p_table_name      => c_expressions_table
                                           ,p_column_name     => 'EXP_ID'
                                           ,p_where_column    => 'EXP_DEVELOPER_KEY'
                                           ,p_where_value     => p_exp_developer_key
                                           ,p_where_operator  => '='
                                           )
                   );
END get_exp_id;
--
--------------------------------------------------------------------------
--
FUNCTION get_obj_id (p_obj_developer_key VARCHAR2
                    ,p_raise_not_found   BOOLEAN DEFAULT TRUE
                    ) RETURN NUMBER IS
BEGIN
   RETURN TO_NUMBER(get_disco_column_value (p_table_name      => c_obj_table
                                           ,p_column_name     => 'OBJ_ID'
                                           ,p_where_column    => 'OBJ_DEVELOPER_KEY'
                                           ,p_where_value     => p_obj_developer_key
                                           ,p_where_operator  => '='
                                           ,p_raise_not_found => p_raise_not_found
                                           )
                   );
END get_obj_id;
--
--------------------------------------------------------------------------
--
FUNCTION get_obj_id (p_obj_name          VARCHAR2
                    ,p_raise_not_found   BOOLEAN DEFAULT TRUE
                    ) RETURN NUMBER IS
BEGIN
   RETURN TO_NUMBER(get_disco_column_value (p_table_name      => c_obj_table
                                           ,p_column_name     => 'OBJ_ID'
                                           ,p_where_column    => 'OBJ_NAME'
                                           ,p_where_value     => p_obj_name
                                           ,p_where_operator  => '='
                                           ,p_raise_not_found => p_raise_not_found
                                           )
                   );
END get_obj_id;
--
--------------------------------------------------------------------------
--
PROCEDURE lock_obj_id (p_obj_id NUMBER) IS
   l_obj_id NUMBER;
BEGIN
--
   nm_debug.proc_start(g_package_name,'lock_obj_id');
--
   l_obj_id := TO_NUMBER(get_disco_column_value (p_table_name      => c_obj_table
                                                ,p_column_name     => 'OBJ_ID'
                                                ,p_where_column    => 'OBJ_ID'
                                                ,p_where_value     => p_obj_id
                                                ,p_where_operator  => '='
                                                ,p_lock_record     => TRUE
                                                )
                        );
--
   nm_debug.proc_end(g_package_name,'lock_obj_id');
--
END lock_obj_id;
--
--------------------------------------------------------------------------
--
FUNCTION get_tab_hdtc (p_hdt_id hig_disco_tables.hdt_id%TYPE) RETURN tab_rec_hdtc IS
   CURSOR cs_hdtc (c_hdtc_hdt_id hig_disco_tab_columns.hdtc_hdt_id%TYPE) IS
   SELECT *
    FROM  hig_disco_tab_columns
   WHERE  hdtc_hdt_id = c_hdtc_hdt_id
   ORDER BY hdtc_display_seq;
   l_tab_rec_hdtc tab_rec_hdtc;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_hdtc');
--
   FOR cs_rec IN cs_hdtc (p_hdt_id)
    LOOP
      l_tab_rec_hdtc(cs_hdtc%ROWCOUNT) := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_tab_hdtc');
--
   RETURN l_tab_rec_hdtc;
END get_tab_hdtc;
--
--------------------------------------------------------------------------
--
FUNCTION disco_datatype (p_datatype VARCHAR2) RETURN PLS_INTEGER IS
   l_retval PLS_INTEGER;
BEGIN
   IF    p_datatype = nm3type.c_varchar
    THEN
      l_retval := 1;
   ELSIF p_datatype = nm3type.c_number
    THEN
      l_retval := 2;
   ELSIF p_datatype = nm3type.c_date
    THEN
      l_retval := 4;
   END IF;
   RETURN l_retval;
END disco_datatype;
--
--------------------------------------------------------------------------
--
FUNCTION disco_yn (p_yn VARCHAR2) RETURN PLS_INTEGER IS
BEGIN
   RETURN nm3flx.i_t_e (p_yn='Y',1,0);
END disco_yn;
--
--------------------------------------------------------------------------
--
FUNCTION chop_up_into_250 (p_tab_vc32767 nm3type.tab_varchar32767) RETURN tab_varchar250 IS
   l_32767     nm3type.max_varchar2;
   l_tab_vc250 tab_varchar250;
   l_sanity    PLS_INTEGER;
BEGIN
--
   nm_debug.proc_start(g_package_name,'chop_up_into_250');
--
   FOR i IN 1..p_tab_vc32767.COUNT
    LOOP
      l_32767  := p_tab_vc32767(i);
      l_sanity := 0;
      WHILE l_32767 IS NOT NULL
       LOOP
         l_sanity := l_sanity + 1;
         l_tab_vc250(l_tab_vc250.COUNT+1) := SUBSTR(l_32767,1,250);
         l_32767 := SUBSTR(l_32767,251);
         IF l_sanity > 132 -- Sanity check. Only 250 only goes into 32767 131 and a bit times.
          THEN
            EXIT;
         END IF;
      END LOOP;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'chop_up_into_250');
--
   RETURN l_tab_vc250;
--
END chop_up_into_250;
--
--------------------------------------------------------------------------
--
PROCEDURE add_who_columns (p_prefix VARCHAR2) IS
   c_sysdate CONSTANT DATE         := SYSDATE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_who_columns');
--
   add_value      (p_prefix||'_CREATED_BY',Sys_Context('NM3_SECURITY_CTX','USERNAME'));
   add_value_date (p_prefix||'_CREATED_DATE',c_sysdate);
   add_value      (p_prefix||'_UPDATED_BY',Sys_Context('NM3_SECURITY_CTX','USERNAME'));
   add_value_date (p_prefix||'_UPDATED_DATE',c_sysdate);
--
   nm_debug.proc_end(g_package_name,'add_who_columns');
--
END add_who_columns;
--
--------------------------------------------------------------------------
--
FUNCTION get_tab_rec_hdcv (p_hdtc_hdt_id         NUMBER
                          ,p_hdtc_column_name    VARCHAR2
                          ) RETURN tab_rec_hdcv IS
   CURSOR cs_hdcv (c_hdcv_hdtc_hdt_id         NUMBER
                  ,c_hdcv_hdtc_column_name    VARCHAR2
                  ) IS
   SELECT *
    FROM  hig_disco_col_values
   WHERE  hdcv_hdtc_hdt_id = c_hdcv_hdtc_hdt_id
    AND   hdcv_hdtc_column_name = c_hdcv_hdtc_column_name
   ORDER BY hdcv_seq_no;
   l_tab_rec_hdcv tab_rec_hdcv;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_rec_hdcv');
--
   FOR cs_rec IN cs_hdcv (p_hdtc_hdt_id
                         ,p_hdtc_column_name
                         )
    LOOP
      l_tab_rec_hdcv (cs_hdcv%ROWCOUNT) := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_tab_rec_hdcv');
--
   RETURN l_tab_rec_hdcv;
END get_tab_rec_hdcv;
--
--------------------------------------------------------------------------
--
PROCEDURE delete_object_from_eul (p_obj_developer_key IN VARCHAR2) IS
   l_obj_id NUMBER;
BEGIN
--
   nm_debug.proc_start(g_package_name,'delete_object_from_eul');
--
   l_obj_id := get_obj_id (p_obj_developer_key => p_obj_developer_key);
   delete_object_from_eul (p_obj_id => l_obj_id);
--
   nm_debug.proc_end(g_package_name,'delete_object_from_eul');
--
END delete_object_from_eul;
--
--------------------------------------------------------------------------
--
PROCEDURE delete_object_from_eul (p_obj_id IN NUMBER) IS
   l_tab_exp_id           nm3type.tab_varchar32767;
   l_tab_key_id           nm3type.tab_varchar32767;
   l_tab_key_id_temp      nm3type.tab_varchar32767;
   l_tab_dom_id           nm3type.tab_varchar32767;
   l_tab_exp_id_using_dom nm3type.tab_varchar32767;
BEGIN
--
   nm_debug.proc_start(g_package_name,'delete_object_from_eul');
--
-- Lock the main obj record for protection
   lock_obj_id (p_obj_id);
--
   -- Get all the KEY_CONS where this is the child
   l_tab_key_id      := get_tab_disco_column_value (p_table_name      => c_key_cons_table
                                                   ,p_column_name     => 'KEY_ID'
                                                   ,p_where_column    => 'KEY_OBJ_ID'
                                                   ,p_where_value     => p_obj_id
                                                   ,p_where_operator  => '='
                                                   ,p_lock_record     => TRUE
                                                   );
   -- Get all the KEY_CONS where this is the parent
   l_tab_key_id_temp := get_tab_disco_column_value (p_table_name      => c_key_cons_table
                                                   ,p_column_name     => 'KEY_ID'
                                                   ,p_where_column    => 'FK_OBJ_ID_REMOTE'
                                                   ,p_where_value     => p_obj_id
                                                   ,p_where_operator  => '='
                                                   ,p_lock_record     => TRUE
                                                   );
   FOR i IN 1..l_tab_key_id_temp.COUNT
    LOOP
      l_tab_key_id(l_tab_key_id.COUNT+1) := l_tab_key_id_temp(i);
   END LOOP;
--
   FOR i IN 1..l_tab_key_id.COUNT
    LOOP
      l_tab_exp_id :=  get_tab_disco_column_value (p_table_name      => c_expressions_table
                                                  ,p_column_name     => 'EXP_ID'
                                                  ,p_where_column    => 'JP_KEY_ID'
                                                  ,p_where_value     => l_tab_key_id(i)
                                                  ,p_where_operator  => '='
                                                  ,p_lock_record     => TRUE
                                                  );
      FOR j IN 1..l_tab_exp_id.COUNT
       LOOP
         delete_disco_column_value (p_table_name      => c_exp_deps_table
                                   ,p_where_column    => 'PD_P_ID'
                                   ,p_where_value     => l_tab_exp_id(j)
                                   ,p_where_operator  => '='
                                   ,p_raise_not_found => FALSE
                                   );
      END LOOP;
      delete_disco_column_value (p_table_name      => c_expressions_table
                                ,p_where_column    => 'JP_KEY_ID'
                                ,p_where_value     => l_tab_key_id(i)
                                ,p_where_operator  => '='
                                ,p_raise_not_found => FALSE
                                );
      delete_disco_column_value (p_table_name      => c_key_cons_table
                                ,p_where_column    => 'KEY_ID'
                                ,p_where_value     => l_tab_key_id(i)
                                ,p_where_operator  => '='
                                ,p_raise_not_found => FALSE
                                );
   END LOOP;
--
   -- Delete the SEGMENTS record
   delete_disco_column_value (p_table_name      => c_segments_table
                             ,p_where_column    => 'SEG_OBJ_ID'
                             ,p_where_value     => p_obj_id
                             ,p_where_operator  => '='
                             ,p_raise_not_found => FALSE
                             );
--
   -- Get all the EXPRESSIONS records relating to conditions
   l_tab_exp_id := get_tab_disco_column_value (p_table_name      => c_expressions_table
                                              ,p_column_name     => 'EXP_ID'
                                              ,p_where_column    => 'FIL_OBJ_ID'
                                              ,p_where_value     => p_obj_id
                                              ,p_where_operator  => '='
                                              ,p_lock_record     => TRUE
                                              );
--
   FOR i IN 1..l_tab_exp_id.COUNT
    LOOP
      -- Delete all the expression dependency records relating to these conditions
      delete_disco_column_value (p_table_name      => c_exp_deps_table
                                ,p_where_column    => 'PD_P_ID'
                                ,p_where_value     => l_tab_exp_id(i)
                                ,p_where_operator  => '='
                                ,p_raise_not_found => FALSE
                                );
   END LOOP;
--
   -- Delete the EXPRESSIONS records relating to conditions
   delete_disco_column_value (p_table_name      => c_expressions_table
                             ,p_where_column    => 'FIL_OBJ_ID'
                             ,p_where_value     => p_obj_id
                             ,p_where_operator  => '='
                             ,p_raise_not_found => FALSE
                             );
--
   -- Get all the EXPRESSIONS records relating to conditions
   l_tab_exp_id := get_tab_disco_column_value (p_table_name      => c_expressions_table
                                              ,p_column_name     => 'EXP_ID'
                                              ,p_where_column    => 'IT_OBJ_ID'
                                              ,p_where_value     => p_obj_id
                                              ,p_where_operator  => '='
                                              ,p_lock_record     => TRUE
                                              );
--
   FOR i IN 1..l_tab_exp_id.COUNT
    LOOP
      -- Get all the DOMAIN records where this is the DOM_IT_ID_LOV
      l_tab_dom_id := get_tab_disco_column_value (p_table_name      => c_domain_table
                                                 ,p_column_name     => 'DOM_ID'
                                                 ,p_where_column    => 'DOM_IT_ID_LOV'
                                                 ,p_where_value     => l_tab_exp_id(i)
                                                 ,p_where_operator  => '='
                                                 ,p_lock_record     => TRUE
                                                 );
      FOR j IN 1..l_tab_dom_id.COUNT
       LOOP
         l_tab_exp_id_using_dom := get_tab_disco_column_value (p_table_name      => c_expressions_table
                                                              ,p_column_name     => 'EXP_ID'
                                                              ,p_where_column    => 'IT_DOM_ID'
                                                              ,p_where_value     => l_tab_dom_id(j)
                                                              ,p_where_operator  => '='
                                                              ,p_lock_record     => TRUE
                                                              );
         FOR k IN 1..l_tab_exp_id_using_dom.COUNT
          LOOP
            set_expression_domain (p_exp_id => l_tab_exp_id_using_dom(k)
                                  ,p_dom_id => Null
                                  );
         END LOOP;
         delete_disco_column_value (p_table_name      => c_domain_table
                                   ,p_where_column    => 'DOM_ID'
                                   ,p_where_value     => l_tab_dom_id(j)
                                   ,p_where_operator  => '='
                                   ,p_raise_not_found => FALSE
                                   );
      END LOOP;
   END LOOP;
--
   -- Delete the EXPRESSIONS records
   delete_disco_column_value (p_table_name      => c_expressions_table
                             ,p_where_column    => 'IT_OBJ_ID'
                             ,p_where_value     => p_obj_id
                             ,p_where_operator  => '='
                             ,p_raise_not_found => FALSE
                             );
--
   -- Delete the BA OBJ LINK records
   delete_disco_column_value (p_table_name      => c_ba_obj_link_table
                             ,p_where_column    => 'BOL_OBJ_ID'
                             ,p_where_value     => p_obj_id
                             ,p_where_operator  => '='
                             ,p_raise_not_found => FALSE
                             );
--
   -- Delete the actual OBJ record
   delete_disco_column_value (p_table_name      => c_obj_table
                             ,p_where_column    => 'OBJ_ID'
                             ,p_where_value     => p_obj_id
                             ,p_where_operator  => '='
                             ,p_raise_not_found => FALSE
                             );
--
   nm_debug.proc_end(g_package_name,'delete_object_from_eul');
--
END delete_object_from_eul;
--
--------------------------------------------------------------------------
--
PROCEDURE set_expression_domain (p_exp_id NUMBER
                                ,p_dom_id NUMBER
                                ) IS
   l_rowid ROWID;
   l_dom_id VARCHAR2(100);
BEGIN
--
   nm_debug.proc_start(g_package_name,'set_expression_domain');
--
   l_rowid := CHARTOROWID(get_disco_column_value (p_table_name      => c_expressions_table
                                                 ,p_column_name     => 'ROWIDTOCHAR(ROWID)'
                                                 ,p_where_column    => 'EXP_ID'
                                                 ,p_where_value     => p_exp_id
                                                 ,p_where_operator  => '='
                                                 ,p_lock_record     => TRUE
                                                 )
                          );
--
   IF p_dom_id IS NULL
    THEN
      l_dom_id := 'Null';
   ELSE
      l_dom_id := TO_CHAR(p_dom_id);
   END IF;
--
   EXECUTE IMMEDIATE            'UPDATE '||g_complete_prefix||c_expressions_table
                     ||CHR(10)||' SET   it_dom_id  = '||l_dom_id
                     ||CHR(10)||'      ,notm       = notm + 1'
                     ||CHR(10)||'WHERE  ROWID = :a'
     USING l_rowid;
--
   nm_debug.proc_end(g_package_name,'set_expression_domain');
--
END set_expression_domain;
--
--------------------------------------------------------------------------
--
PROCEDURE create_foreign_key_link (p_hdfk_id hig_disco_foreign_keys.hdfk_id%TYPE) IS
   l_rec_hdfk       hig_disco_foreign_keys%ROWTYPE;
   l_tab_rec_hdkc   tab_rec_hdkc;
   l_parent_obj_id  NUMBER;
   l_child_obj_id   NUMBER;
   l_key_id         NUMBER;
   l_exp_id         NUMBER;
   l_key_name       VARCHAR2(100);
   l_key_disp_name  VARCHAR2(100);
   l_key_desc       VARCHAR2(240);
   l_exp_formula    VARCHAR2(250);
   l_start          VARCHAR2(1);
   l_tab_parent_exp nm3type.tab_number;
   l_tab_child_exp  nm3type.tab_number;
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_foreign_key_link');
--
   l_rec_hdfk      := get_hdfk (p_hdfk_id => p_hdfk_id);
   l_tab_rec_hdkc  := get_tab_hdkc (p_hdfk_id => p_hdfk_id);
--
   l_parent_obj_id := get_obj_id (p_obj_developer_key => l_rec_hdfk.hdfk_parent_table
                                 ,p_raise_not_found   => TRUE
                                 );
   l_child_obj_id  := get_obj_id (p_obj_developer_key => l_rec_hdfk.hdfk_child_table
                                 ,p_raise_not_found   => TRUE
                                 );
--
   FOR i IN 1..l_tab_rec_hdkc.COUNT
    LOOP
      l_tab_parent_exp(i) := get_exp_id_by_obj_and_dev_key (p_obj_id        => l_parent_obj_id
                                                           ,p_developer_key => l_tab_rec_hdkc(i).hdkc_parent_column
                                                           );
      l_tab_child_exp(i)  := get_exp_id_by_obj_and_dev_key (p_obj_id        => l_child_obj_id
                                                           ,p_developer_key => l_tab_rec_hdkc(i).hdkc_child_column
                                                           );
   END LOOP;
--
   l_key_id        := disco_seq_nextval;
   l_exp_id        := disco_seq_nextval;
--
   l_key_name      := l_rec_hdfk.hdfk_fk_name||'_'||l_rec_hdfk.hdfk_parent_table||'_'||l_rec_hdfk.hdfk_child_table;
   l_key_disp_name := LOWER(REPLACE(l_rec_hdfk.hdfk_fk_name||':'||l_rec_hdfk.hdfk_parent_table||'->'||l_rec_hdfk.hdfk_child_table,'_',' '));
   l_key_desc      := 'Join between '||l_rec_hdfk.hdfk_parent_table||' and '||l_rec_hdfk.hdfk_child_table;
--
-- If there is more than 1 column joining in this FK then we have
--  to prefix the formula with a [1,98] and then seperate all
--  the conditions with a comma
--
   IF l_tab_rec_hdkc.COUNT > 1
    THEN
      l_exp_formula := '[1,98]';
      l_start       := '(';
   ELSE
      l_exp_formula := Null;
      l_start       := Null;
   END IF;
   FOR i IN 1..l_tab_rec_hdkc.COUNT
    LOOP
      IF l_start IS NOT NULL
       THEN
         l_exp_formula := l_exp_formula||l_start;
         l_start       := ',';
      END IF;
      l_exp_formula := l_exp_formula||'[1,81]([6,'||l_tab_parent_exp(i)||'],[6,'||l_tab_child_exp(i)||'])';
   END LOOP;
   IF l_start IS NOT NULL
    THEN
      l_exp_formula := l_exp_formula||')';
   END IF;
--
   clear_globals;
   add_value_num  ('KEY_ID',l_key_id);
   add_value      ('KEY_TYPE','FK');
   add_value      ('KEY_NAME',l_key_disp_name);
   add_value      ('KEY_DEVELOPER_KEY',l_key_name);
   add_value      ('KEY_DESCRIPTION',l_key_desc);
   add_value      ('KEY_EXT_KEY',Null);
   add_value_num  ('KEY_OBJ_ID',l_child_obj_id);
   add_value_num  ('UK_PRIMARY',Null);
   add_value_num  ('FK_KEY_ID_REMOTE',Null);
   add_value_num  ('FK_OBJ_ID_REMOTE',l_parent_obj_id);
   add_value_num  ('FK_ONE_TO_ONE',0);
   add_value_num  ('FK_MSTR_NO_DETAIL',disco_yn(l_rec_hdfk.hdfk_child_optional));
   add_value_num  ('FK_DTL_NO_MASTER',disco_yn(l_rec_hdfk.hdfk_parent_optional));
   add_value_num  ('FK_MANDATORY',0);
   add_value      ('KEY_USER_PROP2',Null);
   add_value      ('KEY_USER_PROP1',Null);
   add_value_num  ('KEY_ELEMENT_STATE',0);
   add_who_columns('KEY');
   add_value_num  ('NOTM',0);
   insert_table_values (c_key_cons_table);
--
   clear_globals;
   add_value_num  ('EXP_ID',l_exp_id);
   add_value      ('EXP_TYPE',c_exp_type_jp);
   add_value      ('EXP_NAME',c_jp_name);
   add_value      ('EXP_DEVELOPER_KEY',c_jp_developer_key);
   add_value      ('EXP_DESCRIPTION',Null);
   add_value      ('EXP_FORMULA1',l_exp_formula);
   add_value_num  ('EXP_DATA_TYPE',10);
   add_value_num  ('EXP_SEQUENCE',1);
   add_value_num  ('IT_DOM_ID',Null);
   add_value_num  ('IT_OBJ_ID',Null);
   add_value_num  ('IT_DOC_ID',Null);
   add_value      ('IT_FORMAT_MASK',Null);
   add_value_num  ('IT_MAX_DATA_WIDTH',Null);
   add_value_num  ('IT_MAX_DISP_WIDTH',Null);
   add_value_num  ('IT_ALIGNMENT',Null);
   add_value_num  ('IT_WORD_WRAP',Null);
   add_value      ('IT_DISP_NULL_VAL',Null);
   add_value_num  ('IT_FUN_ID',Null);
   add_value      ('IT_HEADING',Null);
   add_value_num  ('IT_HIDDEN',Null);
   add_value_num  ('IT_PLACEMENT',Null);
   add_value      ('IT_USER_DEF_FMT',Null);
   add_value_num  ('IT_CASE_STORAGE',Null);
   add_value_num  ('IT_CASE_DISPLAY',Null);
   add_value      ('IT_EXT_COLUMN',Null);
   add_value_num  ('CI_IT_ID',Null);
   add_value_num  ('CI_RUNTIME_ITEM',Null);
   add_value_num  ('PAR_MULTIPLE_VALS',Null);
   add_value_num  ('CO_NULLABLE',Null);
   add_value_num  ('P_CASE_SENSITIVE',1);
   add_value_num  ('JP_KEY_ID',l_key_id);
   add_value_num  ('FIL_OBJ_ID',Null);
   add_value_num  ('FIL_DOC_ID',Null);
   add_value_num  ('FIL_RUNTIME_FILTER',Null);
   add_value_num  ('FIL_APP_TYPE',Null);
   add_value      ('FIL_EXT_FILTER',Null);
   add_value      ('EXP_USER_PROP2',Null);
   add_value      ('EXP_USER_PROP1',Null);
   add_value_num  ('EXP_ELEMENT_STATE',0);
   add_who_columns('EXP');
   add_value_num  ('NOTM',0);
   insert_table_values (c_expressions_table);
--
   FOR i IN 1..l_tab_rec_hdkc.COUNT
    LOOP
      DECLARE
         l_local_ped_exp_id NUMBER := l_tab_parent_exp(i);
      BEGIN
         FOR j IN 1..2
          LOOP
            clear_globals;
            add_value_num  ('ED_ID',disco_seq_nextval);
            add_value      ('ED_TYPE',c_ed_type_ped);
            add_value_num  ('PD_P_ID',l_exp_id);
            add_value_num  ('PED_EXP_ID',l_local_ped_exp_id);
            add_value_num  ('PFD_FUN_ID',Null);
            add_value_num  ('PSD_SQ_ID',Null);
            add_value_num  ('CD_EXP_ID',Null);
            add_value_num  ('CFD_FUN_ID',Null);
            add_value_num  ('CID_EXP_ID',Null);
            add_value_num  ('ED_ELEMENT_STATE',0);
            add_who_columns('ED');
            add_value_num  ('NOTM',0);
            insert_table_values (c_exp_deps_table);
            l_local_ped_exp_id := l_tab_child_exp(i);
         END LOOP;
      END;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'create_foreign_key_link');
--
END create_foreign_key_link;
--
--------------------------------------------------------------------------
--
FUNCTION get_hdfk (p_hdfk_id hig_disco_foreign_keys.hdfk_id%TYPE
                  ) RETURN hig_disco_foreign_keys%ROWTYPE IS
--
   CURSOR cs_hdfk (c_hdfk_id hig_disco_foreign_keys.hdfk_id%TYPE) IS
   SELECT *
    FROM  hig_disco_foreign_keys
   WHERE  hdfk_id = c_hdfk_id;
   l_retval hig_disco_foreign_keys%ROWTYPE;
   l_found  BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_hdfk');
--
   OPEN  cs_hdfk (p_hdfk_id);
   FETCH cs_hdfk INTO l_retval;
   l_found := cs_hdfk%FOUND;
   CLOSE cs_hdfk;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_foreign_keys.hdfk_id='||p_hdfk_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_hdfk');
--
   RETURN l_retval;
--
END get_hdfk;
--
--------------------------------------------------------------------------
--
FUNCTION get_tab_hdkc (p_hdfk_id hig_disco_foreign_keys.hdfk_id%TYPE
                      ) RETURN tab_rec_hdkc IS
   CURSOR cs_hdkc (c_hdkc_hdfk_id hig_disco_foreign_key_cols.hdkc_hdfk_id%TYPE) IS
   SELECT *
    FROM  hig_disco_foreign_key_cols
   WHERE  hdkc_hdfk_id = c_hdkc_hdfk_id
   ORDER BY hdkc_seq_no;
   l_retval tab_rec_hdkc;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tab_hdkc');
--
   FOR cs_rec IN cs_hdkc (p_hdfk_id)
    LOOP
      l_retval(cs_hdkc%ROWCOUNT) := cs_rec;
   END LOOP;
--
   IF l_retval.COUNT = 0
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_foreign_key_cols.hdkc_hdfk_id='||p_hdfk_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_tab_hdkc');
--
   RETURN l_retval;
--
END get_tab_hdkc;
--
--------------------------------------------------------------------------
--
FUNCTION get_exp_id_by_obj_and_dev_key (p_obj_id        NUMBER
                                       ,p_developer_key VARCHAR2
                                       ) RETURN NUMBER IS
BEGIN
   RETURN TO_NUMBER(get_disco_column_value (p_table_name      => c_expressions_table
                                           ,p_column_name     => 'exp_id'
                                           ,p_where_column    => 'IT_OBJ_ID'
                                           ,p_where_value     => p_obj_id
                                           ,p_where_operator  => '='
                                           ,p_where_column2   => 'EXP_DEVELOPER_KEY'
                                           ,p_where_value2    => p_developer_key
                                           ,p_where_operator2 => '='
                                           )
                   );
END get_exp_id_by_obj_and_dev_key;
--
--------------------------------------------------------------------------
--
FUNCTION get_single_hdba_id RETURN hig_disco_business_areas.hdba_id%TYPE IS
   l_retval hig_disco_business_areas.hdba_id%TYPE;
BEGIN
   SELECT hdba_id
    INTO  l_retval
    FROM  hig_disco_business_areas;
   RETURN l_retval;
EXCEPTION
   WHEN no_data_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_business_areas'
                    );
   WHEN too_many_rows
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 105
                    ,pi_supplementary_info => 'hig_disco_business_areas'
                    );
END get_single_hdba_id;
--
--------------------------------------------------------------------------
--
PROCEDURE add_fk_links_for_table (pi_table_name       VARCHAR2
                                 ,pi_create_if_needed BOOLEAN DEFAULT TRUE
                                 ) IS
--
   CURSOR cs_ac_child (c_table_name all_constraints.table_name%TYPE) IS
   SELECT ac1.constraint_name
         ,ac1.table_name
         ,ac1.r_constraint_name
         ,ac2.table_name
    FROM  all_constraints ac1
         ,all_constraints ac2
   WHERE  ac1.owner             = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   ac1.table_name        = c_table_name
    AND   ac1.constraint_type   = 'R'
    AND   ac1.r_owner           = ac2.owner
    AND   ac1.r_constraint_name = ac2.constraint_name
    AND   ac2.table_name       != ac1.table_name -- Do not pick up recursive FKs
   ORDER BY ac1.constraint_name;
--
   l_tab_constraint_name   nm3type.tab_varchar30;
   l_tab_table_name        nm3type.tab_varchar30;
   l_tab_r_constraint_name nm3type.tab_varchar30;
   l_tab_r_table_name      nm3type.tab_varchar30;
   l_rec_hdt               hig_disco_tables%ROWTYPE;
   l_rec_hdt_parent        hig_disco_tables%ROWTYPE;
   l_rec_hdfk              hig_disco_foreign_keys%ROWTYPE;
   l_rec_hdkc              hig_disco_foreign_key_cols%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'add_fk_links_for_table');
--
   l_rec_hdt := get_hdt (pi_table_name);
--
   OPEN  cs_ac_child (pi_table_name);
   FETCH cs_ac_child
    BULK COLLECT
    INTO l_tab_constraint_name
        ,l_tab_table_name
        ,l_tab_r_constraint_name
        ,l_tab_r_table_name;
   CLOSE cs_ac_child;
--
   IF   l_tab_constraint_name.COUNT = 0
    THEN
      -- There are no FK constraints on this "table".
      -- However, this may be because it is a view based on a "_ALL" table
      --  check to see whether it is or not
      IF   nm3ddl.does_object_exist (p_object_name => pi_table_name
                                    ,p_object_type => 'VIEW'
                                    )
       AND nm3ddl.does_object_exist (p_object_name => pi_table_name||'_ALL'
                                    ,p_object_type => 'TABLE'
                                    )
       THEN
         OPEN  cs_ac_child (pi_table_name||'_ALL');
         FETCH cs_ac_child
          BULK COLLECT
          INTO l_tab_constraint_name
              ,l_tab_table_name
              ,l_tab_r_constraint_name
              ,l_tab_r_table_name;
         CLOSE cs_ac_child;
      END IF;
   END IF;
--
   FOR i IN 1..l_tab_constraint_name.COUNT
    LOOP
--
      DECLARE
         l_hdt_doesnt_exist EXCEPTION;
         dont_carry_on      EXCEPTION;
         l_tab_cols_child   nm3type.tab_varchar30;
         l_tab_cols_parent  nm3type.tab_varchar30;
      BEGIN
--
         l_rec_hdt_parent                := get_hdt (p_hdt_table_name  => l_tab_r_table_name(i)
                                                    ,p_raise_not_found => FALSE
                                                    );
--
         IF l_rec_hdt_parent.hdt_id IS NULL
          THEN
            IF pi_create_if_needed
             THEN
               suck_table_into_disco_tables (p_table_name => l_tab_r_table_name(i)
                                            ,p_hdba_id    => l_rec_hdt.hdt_hdba_id
                                            );
            ELSE
               RAISE l_hdt_doesnt_exist;
            END IF;
         END IF;
--
         l_rec_hdfk.hdfk_id              := next_hdfk_id_seq;
         l_rec_hdfk.hdfk_parent_table    := l_tab_r_table_name(i);
         l_rec_hdfk.hdfk_child_table     := pi_table_name;
         l_rec_hdfk.hdfk_fk_name         := l_tab_constraint_name(i);
         l_rec_hdfk.hdfk_parent_optional := 'N';
         l_rec_hdfk.hdfk_child_optional  := 'N';
--
         BEGIN
            ins_hdfk (l_rec_hdfk);
         EXCEPTION
            WHEN dup_val_on_index
             THEN
               RAISE dont_carry_on;
         END;
--
         l_tab_cols_child  := get_constraint_cols (l_tab_constraint_name(i));
         l_tab_cols_parent := get_constraint_cols (l_tab_r_constraint_name(i));
--
         IF l_tab_cols_child.COUNT != l_tab_cols_parent.COUNT
          THEN
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 28
                          ,pi_supplementary_info => 'Child table constraint column count differs from parent table col count'
                          );
         END IF;
--
         l_rec_hdkc.hdkc_hdfk_id          := l_rec_hdfk.hdfk_id;
         FOR j IN 1..l_tab_cols_child.COUNT
          LOOP
            l_rec_hdkc.hdkc_seq_no        := j;
            l_rec_hdkc.hdkc_parent_column := l_tab_cols_parent(j);
            l_rec_hdkc.hdkc_child_column  := l_tab_cols_child(j);
            ins_hdkc (l_rec_hdkc);
         END LOOP;
--
      EXCEPTION
         WHEN l_hdt_doesnt_exist
          OR  dont_carry_on
          THEN
            Null;
      END;
--
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'add_fk_links_for_table');
--
END add_fk_links_for_table;
--
--------------------------------------------------------------------------
--
PROCEDURE ins_hdfk (p_rec_hdfk hig_disco_foreign_keys%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_hdfk');
--
   INSERT INTO hig_disco_foreign_keys
          (hdfk_id
          ,hdfk_parent_table
          ,hdfk_child_table
          ,hdfk_fk_name
          ,hdfk_parent_optional
          ,hdfk_child_optional
          )
   VALUES (p_rec_hdfk.hdfk_id
          ,p_rec_hdfk.hdfk_parent_table
          ,p_rec_hdfk.hdfk_child_table
          ,p_rec_hdfk.hdfk_fk_name
          ,NVL(p_rec_hdfk.hdfk_parent_optional,'N')
          ,NVL(p_rec_hdfk.hdfk_child_optional,'Y')
          );
--
   nm_debug.proc_end(g_package_name,'ins_hdfk');
--
END ins_hdfk;
--
--------------------------------------------------------------------------
--
FUNCTION next_hdfk_id_seq RETURN NUMBER IS
   l_retval NUMBER;
BEGIN
--
   SELECT hdfk_id_seq.NEXTVAL
    INTO  l_retval
    FROM  dual;
--
   RETURN l_retval;
--
END next_hdfk_id_seq;
--
--------------------------------------------------------------------------
--
PROCEDURE ins_hdkc (p_rec_hdkc hig_disco_foreign_key_cols%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_hdkc');
--
   INSERT INTO hig_disco_foreign_key_cols
          (hdkc_hdfk_id
          ,hdkc_seq_no
          ,hdkc_parent_column
          ,hdkc_child_column
          )
   VALUES (p_rec_hdkc.hdkc_hdfk_id
          ,p_rec_hdkc.hdkc_seq_no
          ,p_rec_hdkc.hdkc_parent_column
          ,p_rec_hdkc.hdkc_child_column
          );
--
   nm_debug.proc_end(g_package_name,'ins_hdkc');
--
END ins_hdkc;
--
--------------------------------------------------------------------------
--
FUNCTION get_constraint_cols (p_constraint_name all_constraints.constraint_name%TYPE) RETURN nm3type.tab_varchar30 IS
   l_tab_cols nm3type.tab_varchar30;
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_constraint_cols');
--
   SELECT column_name
    BULK  COLLECT
    INTO  l_tab_cols
    FROM  all_cons_columns
   WHERE  owner           = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   constraint_name = p_constraint_name
   ORDER BY position;
--
   nm_debug.proc_end(g_package_name,'get_constraint_cols');
--
   RETURN l_tab_cols;
--
END get_constraint_cols;
--
--------------------------------------------------------------------------
--
PROCEDURE create_all_fk_by_child (p_child_table_name         hig_disco_foreign_keys.hdfk_child_table%TYPE
                                 ,p_create_fk_parents_in_eul BOOLEAN DEFAULT TRUE
                                 ) IS
--
   CURSOR cs_hdfk (c_child_table_name hig_disco_foreign_keys.hdfk_child_table%TYPE) IS
   SELECT hdfk_id
         ,hdfk_parent_table
    FROM  hig_disco_foreign_keys
   WHERE  hdfk_child_table = c_child_table_name;
--
   l_tab_hdfk_id           nm3type.tab_number;
   l_tab_hdfk_parent_table nm3type.tab_varchar30;
   l_create_link           BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_all_fk_by_child');
--
   OPEN  cs_hdfk (p_child_table_name);
   FETCH cs_hdfk
    BULK COLLECT
    INTO l_tab_hdfk_id
        ,l_tab_hdfk_parent_table;
   CLOSE cs_hdfk;
--
   FOR i IN 1..l_tab_hdfk_id.COUNT
    LOOP
      IF get_obj_id (p_obj_developer_key => l_tab_hdfk_parent_table(i)
                    ,p_raise_not_found   => FALSE
                    ) IS NULL
       THEN
         IF p_create_fk_parents_in_eul
          THEN
            create_table_in_eul (p_table_name               => l_tab_hdfk_parent_table(i)
                                ,p_recreate                 => FALSE
                                ,p_create_fk                => TRUE
                                ,p_create_fk_parents_in_eul => TRUE
                                );
            l_create_link := TRUE;
         ELSE
            l_create_link := FALSE;
         END IF;
      ELSE
         l_create_link := TRUE;
      END IF;
      IF l_create_link
       THEN
         create_foreign_key_link (p_hdfk_id => l_tab_hdfk_id(i));
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'create_all_fk_by_child');
--
END create_all_fk_by_child;
--
--------------------------------------------------------------------------
--
PROCEDURE validate_rec_hdtc (p_rec_hdtc hig_disco_tab_columns%ROWTYPE) IS
--
   l_cur     nm3type.ref_cursor;
   l_dummy   nm3type.max_varchar2;
   l_sql     nm3type.max_varchar2;
   l_rec_hdt hig_disco_tables%ROWTYPE;
   l_column  nm3type.max_varchar2;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_rec_hdtc');
--
   l_rec_hdt := get_hdt(p_hdt_id => p_rec_hdtc.hdtc_hdt_id);
   l_column  := NVL(p_rec_hdtc.hdtc_column_source,p_rec_hdtc.hdtc_column_name);
--
   l_sql :=            'SELECT '||l_column
            ||CHR(10)||' FROM  '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_rec_hdt.hdt_table_name
            ||CHR(10)||'WHERE  ROWNUM=1';
--
   DECLARE
      ora_904 EXCEPTION;
      PRAGMA EXCEPTION_INIT(ora_904,-904);
      ora_902 EXCEPTION;
      PRAGMA EXCEPTION_INIT(ora_902,-902);
      ora_923 EXCEPTION;
      PRAGMA EXCEPTION_INIT(ora_923,-923);
      ora_911 EXCEPTION;
      PRAGMA EXCEPTION_INIT(ora_911,-911);
      ora_936 EXCEPTION;
      PRAGMA EXCEPTION_INIT(ora_936,-936);
      l_cur  PLS_INTEGER;
      PROCEDURE close_cur IS
      BEGIN
         IF dbms_sql.is_open (c => l_cur)
          THEN
            dbms_sql.close_cursor (c => l_cur);
         END IF;
      END close_cur;
   BEGIN
      l_cur := dbms_sql.open_cursor;
      dbms_sql.parse (c             => l_cur
                     ,statement     => l_sql
                     ,language_flag => dbms_sql.native
                     );
      close_cur;
   EXCEPTION
      WHEN ora_904 OR ora_923 OR ora_911 OR ora_936
       THEN
         close_cur;
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 253
                       ,pi_supplementary_info => l_column
                       );
      WHEN ora_902
       THEN
         close_cur;
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 254
                       ,pi_supplementary_info => l_column
                       );
      WHEN others
       THEN
         close_cur;
         RAISE;
   END;
--
   nm_debug.proc_end(g_package_name,'validate_rec_hdtc');
--
END validate_rec_hdtc;
--
--------------------------------------------------------------------------
--
PROCEDURE create_hdcv_from_hig_domain (p_hdtc_hdt_id      hig_disco_tab_columns.hdtc_hdt_id%TYPE
                                      ,p_hdtc_column_name hig_disco_tab_columns.hdtc_column_name%TYPE
                                      ,p_hdo_domain       hig_domains.hdo_domain%TYPE
                                      ) IS
--
   l_rec_hdtc     hig_disco_tab_columns%ROWTYPE;
   l_max_seq_no   PLS_INTEGER;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_hdcv_from_hig_domain');
--
   l_rec_hdtc := get_hdtc  (p_hdtc_hdt_id      => p_hdtc_hdt_id
                           ,p_hdtc_column_name => p_hdtc_column_name
                           );
   validate_rec_hdtc (p_rec_hdtc => l_rec_hdtc);
--
   SELECT NVL(MAX(hdcv_seq_no),0)
    INTO  l_max_seq_no
    FROM  hig_disco_col_values
   WHERE  hdcv_hdtc_hdt_id      = p_hdtc_hdt_id
    AND   hdcv_hdtc_column_name = p_hdtc_column_name;
--
   INSERT INTO hig_disco_col_values
         (hdcv_hdtc_hdt_id
         ,hdcv_hdtc_column_name
         ,hdcv_seq_no
         ,hdcv_value
         ,hdcv_meaning
         )
   SELECT p_hdtc_hdt_id
         ,p_hdtc_column_name
         ,ROWNUM+l_max_seq_no
         ,hco_code
         ,hco_meaning
    FROM (SELECT hco_code
                ,hco_meaning
           FROM  hig_codes
          WHERE  hco_domain = p_hdo_domain
          ORDER BY hco_seq, hco_code
         )
   WHERE NOT EXISTS (SELECT 1
                      FROM  hig_disco_col_values
                     WHERE  hdcv_hdtc_hdt_id      = p_hdtc_hdt_id
                      AND   hdcv_hdtc_column_name = p_hdtc_column_name
                      AND   hdcv_value            = hco_code
                    );
--
   nm_debug.proc_end(g_package_name,'create_hdcv_from_hig_domain');
--
END create_hdcv_from_hig_domain;
--
--------------------------------------------------------------------------
--
PROCEDURE create_hdcv_from_distinct_list (p_hdtc_hdt_id      hig_disco_tab_columns.hdtc_hdt_id%TYPE
                                         ,p_hdtc_column_name hig_disco_tab_columns.hdtc_column_name%TYPE
                                         ) IS
--
   l_sql          nm3type.max_varchar2;
   l_rec_hdt      hig_disco_tables%ROWTYPE;
   l_rec_hdtc     hig_disco_tab_columns%ROWTYPE;
   l_column       nm3type.max_varchar2;
   l_max_seq_no   PLS_INTEGER;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_hdcv_from_distinct_list');
--
   l_rec_hdtc := get_hdtc  (p_hdtc_hdt_id      => p_hdtc_hdt_id
                           ,p_hdtc_column_name => p_hdtc_column_name
                           );
   validate_rec_hdtc (p_rec_hdtc => l_rec_hdtc);
--
   l_rec_hdt := get_hdt(p_hdt_id => l_rec_hdtc.hdtc_hdt_id);
   l_column  := NVL(l_rec_hdtc.hdtc_column_source,l_rec_hdtc.hdtc_column_name);
--
   SELECT NVL(MAX(hdcv_seq_no),0)
    INTO  l_max_seq_no
    FROM  hig_disco_col_values
   WHERE  hdcv_hdtc_hdt_id      = l_rec_hdt.hdt_id
    AND   hdcv_hdtc_column_name = l_rec_hdtc.hdtc_column_name;
--
   l_sql :=            'INSERT INTO hig_disco_col_values'
            ||CHR(10)||'      (hdcv_hdtc_hdt_id'
            ||CHR(10)||'      ,hdcv_hdtc_column_name'
            ||CHR(10)||'      ,hdcv_seq_no'
            ||CHR(10)||'      ,hdcv_value'
            ||CHR(10)||'      ,hdcv_meaning'
            ||CHR(10)||'      )'
            ||CHR(10)||'SELECT '||l_rec_hdt.hdt_id||' hdcv_hdtc_hdt_id'
            ||CHR(10)||'      ,'||nm3flx.string(l_rec_hdtc.hdtc_column_name)||' hdcv_hdtc_column_name'
            ||CHR(10)||'      ,ROWNUM+'||l_max_seq_no||' hdcv_seq_no'
            ||CHR(10)||'      ,value_col hdcv_value'
            ||CHR(10)||'      ,value_col hdcv_meaning'
            ||CHR(10)||' FROM (SELECT '||l_column||' value_col'
            ||CHR(10)||'        FROM  '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_rec_hdt.hdt_table_name
            ||CHR(10)||'       GROUP BY '||l_column
            ||CHR(10)||'      )'
            ||CHR(10)||'WHERE value_col IS NOT NULL'
            ||CHR(10)||' AND  NOT EXISTS (SELECT 1'
            ||CHR(10)||'                   FROM  hig_disco_col_values'
            ||CHR(10)||'                  WHERE  hdcv_hdtc_hdt_id      = '||l_rec_hdt.hdt_id
            ||CHR(10)||'                   AND   hdcv_hdtc_column_name = '||nm3flx.string(l_rec_hdtc.hdtc_column_name)
            ||CHR(10)||'                   AND   hdcv_value            = value_col'
            ||CHR(10)||'                 )';
--
   EXECUTE IMMEDIATE l_sql;
--
   nm_debug.proc_end(g_package_name,'create_hdcv_from_distinct_list');
--
END create_hdcv_from_distinct_list;
--
--------------------------------------------------------------------------
--
FUNCTION get_hdtc  (p_hdtc_hdt_id      hig_disco_tab_columns.hdtc_hdt_id%TYPE
                   ,p_hdtc_column_name hig_disco_tab_columns.hdtc_column_name%TYPE
                   ) RETURN hig_disco_tab_columns%ROWTYPE IS
--
   CURSOR cs_hdtc (c_hdtc_hdt_id      hig_disco_tab_columns.hdtc_hdt_id%TYPE
                  ,c_hdtc_column_name hig_disco_tab_columns.hdtc_column_name%TYPE
                  ) IS
   SELECT *
    FROM  hig_disco_tab_columns
   WHERE  hdtc_hdt_id      = c_hdtc_hdt_id
    AND   hdtc_column_name = c_hdtc_column_name;
--
   l_rec_hdtc hig_disco_tab_columns%ROWTYPE;
   l_found    BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_hdtc');
--
   OPEN  cs_hdtc (p_hdtc_hdt_id,p_hdtc_column_name);
   FETCH cs_hdtc INTO l_rec_hdtc;
   l_found := cs_hdtc%FOUND;
   CLOSE cs_hdtc;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'hig_disco_tab_columns.hdtc_hdt_id='
                                              ||p_hdtc_hdt_id
                                              ||' AND hig_disco_tab_columns.hdtc_column_name='
                                              ||nm3flx.string(p_hdtc_column_name)
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_hdtc');
--
   RETURN l_rec_hdtc;
--
END get_hdtc;
--
--------------------------------------------------------------------------
--
FUNCTION suggest_next_bol_sequence (p_hdba_name hig_disco_business_areas.hdba_name%TYPE) RETURN NUMBER IS
   l_max_hdt_seq_no   NUMBER;
   l_max_bol_sequence NUMBER;
BEGIN
--
   nm_debug.proc_start(g_package_name,'suggest_next_bol_sequence');
--
   SELECT NVL(MAX(hdt_seq_no),0)
    INTO  l_max_hdt_seq_no
    FROM  hig_disco_tables
         ,hig_disco_business_areas
   WHERE  hdt_hdba_id = hdba_id
    AND   hdba_name   = p_hdba_name;
--
   l_max_bol_sequence := TO_NUMBER(get_disco_column_value(p_table_name      => c_ba_obj_link_table
                                                         ,p_column_name     => 'NVL(MAX(bol_sequence),0)'
                                                         ,p_where_column    => 'BOL_BA_ID'
                                                         ,p_where_value     => get_ba_id (p_hdba_name)
                                                         ,p_where_operator  => '='
                                                         ,p_raise_not_found => FALSE
                                                         ,p_lock_record     => FALSE
                                                         )
                                  );
--
   nm_debug.proc_end(g_package_name,'suggest_next_bol_sequence');
--
   RETURN GREATEST(l_max_hdt_seq_no,l_max_bol_sequence)+1;
--
END suggest_next_bol_sequence;
--
--------------------------------------------------------------------------
--
FUNCTION get_disceulusr RETURN hig_option_values.hov_value%TYPE IS
BEGIN
   RETURN g_disco_user;
END get_disceulusr;
--
--------------------------------------------------------------------------
--
FUNCTION get_disco_vers RETURN hig_option_values.hov_value%TYPE IS
BEGIN
   RETURN g_disco_version;
END get_disco_vers;
--
--------------------------------------------------------------------------
--
PROCEDURE suck_other_products (p_suck_type                VARCHAR2                              DEFAULT 'DEF'
                              ,p_item_type                VARCHAR2
                              ,p_table_name               VARCHAR2
                              ,p_seq_no                   PLS_INTEGER                           DEFAULT NULL
                              ,p_hdba_id                  hig_disco_business_areas.hdba_id%TYPE DEFAULT NULL
                              ,p_hide_who_cols            BOOLEAN                               DEFAULT TRUE
                              ,p_create_hdcv_from_domains BOOLEAN                               DEFAULT FALSE
                              ,p_create_parents_if_reqd   BOOLEAN                               DEFAULT TRUE
                              ) IS
--
   -- Take a copy of the globals, just in case someone else decides to use them
   c_item_type                CONSTANT VARCHAR2(30)                          := g_item_type;
   c_table_name               CONSTANT VARCHAR2(30)                          := g_table_name;
   c_seq_no                   CONSTANT PLS_INTEGER                           := g_seq_no;
   c_hdba_id                  CONSTANT hig_disco_business_areas.hdba_id%TYPE := g_hdba_id;
   c_hide_who_cols            CONSTANT BOOLEAN                               := g_hide_who_cols;
   c_create_hdcv_from_domains CONSTANT BOOLEAN                               := g_create_hdcv_from_domains;
   c_create_parents_if_reqd   CONSTANT BOOLEAN                               := g_create_parents_if_reqd;
--
   PROCEDURE raise_not_licensed (p_product VARCHAR2) IS
   BEGIN
      IF NOT hig.is_product_licensed (p_product)
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 50
                       ,pi_supplementary_info => p_product
                       );
      END IF;
   END raise_not_licensed;
BEGIN
--
   nm_debug.proc_start(g_package_name,'suck_other_products');
--
   raise_not_licensed (nm3type.c_hig);
   --
   -- Move values into globals
   --
   g_item_type                := p_item_type;
   g_table_name               := p_table_name;
   g_seq_no                   := p_seq_no;
   g_hdba_id                  := p_hdba_id;
   g_hide_who_cols            := p_hide_who_cols;
   g_create_hdcv_from_domains := p_create_hdcv_from_domains;
   g_create_parents_if_reqd   := p_create_parents_if_reqd;
--
   IF p_suck_type = c_suck_type_def
    THEN
      -- This is just a "default" suck
      suck_table_into_disco_tables (p_table_name                => p_table_name
                                   ,p_hdba_id                   => p_hdba_id
                                   ,p_seq_no                    => p_seq_no
                                   ,p_hide_who_cols             => p_hide_who_cols
                                   ,p_create_fk_parents_if_reqd => p_create_parents_if_reqd
                                   );
   ELSIF p_suck_type IN (c_suck_type_inv,c_suck_type_inv_nw)
    THEN
      raise_not_licensed (nm3type.c_net);
      extr_inv_type_into_disco_model (pi_inv_type        => p_item_type
                                     ,pi_join_to_network => (p_suck_type = c_suck_type_inv_nw)
                                     ,pi_hdba_id         => p_hdba_id
                                     ,pi_seq_no          => p_seq_no
                                     ,pi_hide_who_cols   => p_hide_who_cols
                                     ,pi_create_hdcv     => p_create_hdcv_from_domains
                                     ,pi_create_into_eul => FALSE
                                     );
   ELSIF p_suck_type = c_suck_type_acc
    THEN
      raise_not_licensed (nm3type.c_acc);
      EXECUTE IMMEDIATE 'BEGIN accdisc.extr_ait_id_into_disco_model; END;';
   ELSIF p_suck_type = c_suck_type_str
    THEN
      raise_not_licensed (nm3type.c_str);
      EXECUTE IMMEDIATE 'BEGIN strdisc.extr_sit_id_into_disco_model; END;';
   ELSE
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 313
                    ,pi_supplementary_info => p_suck_type
                    );
   END IF;
   --
   -- Move the original values back into globals
   --
   g_item_type                := c_item_type;
   g_table_name               := c_table_name;
   g_seq_no                   := c_seq_no;
   g_hdba_id                  := c_hdba_id;
   g_hide_who_cols            := c_hide_who_cols;
   g_create_hdcv_from_domains := c_create_hdcv_from_domains;
   g_create_parents_if_reqd   := c_create_parents_if_reqd;
--
   nm_debug.proc_end(g_package_name,'suck_other_products');
--
END suck_other_products;
--
--------------------------------------------------------------------------
--
PROCEDURE extr_inv_type_into_disco_model (pi_inv_type        nm_inv_types.nit_inv_type%TYPE
                                         ,pi_join_to_network BOOLEAN                               DEFAULT FALSE
                                         ,pi_hdba_id         hig_disco_business_areas.hdba_id%TYPE DEFAULT NULL
                                         ,pi_seq_no          PLS_INTEGER                           DEFAULT NULL
                                         ,pi_hide_who_cols   BOOLEAN                               DEFAULT TRUE
                                         ,pi_create_hdcv     BOOLEAN                               DEFAULT TRUE
                                         ,pi_create_into_eul BOOLEAN                               DEFAULT FALSE
                                         ) IS
--
   l_rec_nit          nm_inv_types%ROWTYPE;
   l_view_name        VARCHAR2(30);
   l_tab_rec_hdtc     higdisco.tab_rec_hdtc;
   l_hdt_id           hig_disco_tables.hdt_id%TYPE;
   l_rec_ita          nm_inv_type_attribs%ROWTYPE;
   l_hdt_display_name hig_disco_tables.hdt_display_name%TYPE;
   l_tab_inv_type     nm3type.tab_varchar4;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'extr_inv_type_into_disco_model');
--
   IF pi_inv_type IS NULL
    THEN
      SELECT nit_inv_type
       BULK  COLLECT
       INTO  l_tab_inv_type
       FROM  nm_inv_types;
      FOR i IN 1..l_tab_inv_type.COUNT
       LOOP
         extr_inv_type_into_disco_model (pi_inv_type        => l_tab_inv_type(i)
                                        ,pi_join_to_network => pi_join_to_network
                                        ,pi_hdba_id         => pi_hdba_id
                                        ,pi_seq_no          => pi_seq_no
                                        ,pi_hide_who_cols   => pi_hide_who_cols
                                        ,pi_create_into_eul => pi_create_into_eul
                                        );
      END LOOP;
      RETURN;
   END IF;
--
   l_rec_nit   := nm3get.get_nit (pi_nit_inv_type => pi_inv_type);
--
   IF l_rec_nit.nit_table_name IS NULL
    THEN
      l_view_name := nm3inv_view.work_out_inv_type_view_name (pi_inv_type        => pi_inv_type
                                                             ,pi_join_to_network => pi_join_to_network
                                                             );
   ELSIF pi_join_to_network
    THEN
      RETURN; -- Join to network makes no sense for FTs - just go back
   ELSE
      l_view_name := l_rec_nit.nit_table_name;
   END IF;
--
   DELETE FROM hig_disco_tables
   WHERE  hdt_table_name = l_view_name;
--
   higdisco.suck_table_into_disco_tables (p_table_name    => l_view_name
                                         ,p_hdba_id       => pi_hdba_id
                                         ,p_seq_no        => pi_seq_no
                                         ,p_hide_who_cols => pi_hide_who_cols
                                         );
--
   -- Get the ID of the one just created
   l_hdt_id    := higdisco.curr_hdt_id_seq;
--
   l_hdt_display_name := l_rec_nit.nit_descr;
--
   IF   pi_join_to_network
    AND l_rec_nit.nit_table_name IS NULL
    THEN
      l_hdt_display_name := l_hdt_display_name||' (Network)';
   END IF;
--
   UPDATE hig_disco_tables
    SET   hdt_display_name = l_hdt_display_name
   WHERE  hdt_id           = l_hdt_id;
--
   l_tab_rec_hdtc := higdisco.get_tab_hdtc (p_hdt_id => l_hdt_id);
--
   FOR i IN 1..l_tab_rec_hdtc.COUNT
    LOOP
      l_rec_ita := nm3get.get_ita (pi_ita_inv_type      => pi_inv_type
                                  ,pi_ita_view_col_name => l_tab_rec_hdtc(i).hdtc_column_name
                                  ,pi_raise_not_found   => FALSE
                                  );
      IF l_rec_ita.ita_inv_type IS NOT NULL
       THEN -- This is a INV_TYPE_ATTRIB column
         l_tab_rec_hdtc(i).hdtc_display_name := l_rec_ita.ita_scrn_text;
         IF l_rec_ita.ita_format_mask IS NOT NULL
          THEN
            l_tab_rec_hdtc(i).hdtc_format_mask := l_rec_ita.ita_format_mask;
         ELSIF l_rec_ita.ita_format = nm3type.c_number
          THEN
            l_tab_rec_hdtc(i).hdtc_format_mask := RPAD('9',l_rec_ita.ita_fld_length-NVL(l_rec_ita.ita_dec_places,0)-1,'9');
            l_tab_rec_hdtc(i).hdtc_format_mask := l_tab_rec_hdtc(i).hdtc_format_mask||'0';
            IF NVL(l_rec_ita.ita_dec_places,0) != 0
             THEN
               l_tab_rec_hdtc(i).hdtc_format_mask := l_tab_rec_hdtc(i).hdtc_format_mask||'.'||RPAD('0',l_rec_ita.ita_dec_places,'0');
            END IF;
         END IF;
         --
         IF   l_rec_ita.ita_id_domain IS NOT NULL
          THEN
            l_tab_rec_hdtc(i).hdtc_item_class := 'Y';
            IF pi_create_hdcv
             THEN
               INSERT INTO hig_disco_col_values
                     (hdcv_hdtc_hdt_id
                     ,hdcv_hdtc_column_name
                     ,hdcv_seq_no
                     ,hdcv_value
                     ,hdcv_meaning
                     )
               SELECT l_hdt_id
                     ,l_tab_rec_hdtc(i).hdtc_column_name
                     ,ial_seq
                     ,ial_value
                     ,ial_meaning
                FROM  nm_inv_attri_lookup_all
               WHERE  ial_domain = l_rec_ita.ita_id_domain;
            END IF;
         END IF;
         --
      ELSIF (l_tab_rec_hdtc(i).hdtc_column_name = 'IIT_PRIMARY_KEY'
            AND hig.get_user_or_sys_opt('SHOWINVPK') != 'Y'
            )
       OR    l_tab_rec_hdtc(i).hdtc_column_name = 'IIT_INV_TYPE'
       THEN
         l_tab_rec_hdtc(i).hdtc_visible      := 'N';
      ELSIF l_tab_rec_hdtc(i).hdtc_column_name = 'NAU_UNIT_CODE'
       THEN
         l_tab_rec_hdtc(i).hdtc_display_name := 'Admin Unit Code';
      ELSIF SUBSTR(l_tab_rec_hdtc(i).hdtc_column_name,1,3) = 'IIT'
       THEN
         l_tab_rec_hdtc(i).hdtc_display_name := INITCAP(SUBSTR(l_tab_rec_hdtc(i).hdtc_display_name,5));
      ELSE
         l_tab_rec_hdtc(i).hdtc_display_name := INITCAP(l_tab_rec_hdtc(i).hdtc_display_name);
      END IF;
--
      UPDATE hig_disco_tab_columns
       SET   hdtc_display_name = l_tab_rec_hdtc(i).hdtc_display_name
            ,hdtc_format_mask  = l_tab_rec_hdtc(i).hdtc_format_mask
            ,hdtc_visible      = l_tab_rec_hdtc(i).hdtc_visible
            ,hdtc_item_class   = l_tab_rec_hdtc(i).hdtc_item_class
      WHERE  hdtc_hdt_id       = l_hdt_id
       AND   hdtc_column_name  = l_tab_rec_hdtc(i).hdtc_column_name;
--
   END LOOP;
--
   IF pi_create_into_eul
    THEN
      higdisco.create_table_in_eul (p_table_name => l_view_name
                                   ,p_recreate   => TRUE
                                   );
   END IF;
--
   nm_debug.proc_end(g_package_name,'extr_inv_type_into_disco_model');
--
END extr_inv_type_into_disco_model;
--
--------------------------------------------------------------------------
--
PROCEDURE create_hdba_records_from_disco IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_tab_developer_key nm3type.tab_varchar32767;
   l_tab_hdba_id       nm3type.tab_number;
   l_tab_hdba_name     nm3type.tab_varchar2000;
   l_count             PLS_INTEGER := 0;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_hdba_records_from_disco');
--
   l_tab_developer_key := get_tab_disco_column_value (p_table_name      => c_ba_table
                                                     ,p_column_name     => 'BA_DEVELOPER_KEY'
                                                     ,p_where_column    => Null
                                                     ,p_where_value     => Null
                                                     ,p_where_operator  => Null
                                                     ,p_lock_record     => FALSE
                                                     );
--
   IF l_tab_developer_key.COUNT = 0
    THEN
      -- No business areas exist in the EUL. Error
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 179
                    ,pi_supplementary_info => 'No Business Areas exist in EUL. Create BA in discoverer admin edition'
                    );
   END IF;
--
   FOR i IN 1..l_tab_developer_key.COUNT
    LOOP
      IF get_hdba (p_hdba_name       => l_tab_developer_key(i)
                  ,p_raise_not_found => FALSE
                  ).hdba_name IS NULL
       THEN
         l_count                  := l_count + 1;
         l_tab_hdba_id(l_count)   := next_hdba_id_seq;
         l_tab_hdba_name(l_count) := l_tab_developer_key(i);
      END IF;
   END LOOP;
--
   FORALL i IN 1..l_count
      INSERT INTO hig_disco_business_areas
             (hdba_id
             ,hdba_name
             )
      VALUES (l_tab_hdba_id(i)
             ,l_tab_hdba_name(i)
             );
--
   nm_debug.proc_end(g_package_name,'create_hdba_records_from_disco');
--
   COMMIT;
--
END create_hdba_records_from_disco;
--
--------------------------------------------------------------------------
--
END higdisco;
/
