CREATE OR REPLACE PACKAGE BODY nm3inv_composite AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_composite.pkb-arc   2.5   Jul 04 2013 16:04:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_composite.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       PVCS Version     : $Revision:   2.5  $
--       Based on SCCS Version: 1.3
--
--   Author : Jonathan Mills
--
--   Composite Inventory package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
/* History
  26.03.09 PT in refresh_nmnd() added logic to call new code in nm3inv_composite2
            To run old code set option INVCOMP32 = 'Y'
            requires any version of nm3inv_composite2.pkh
*/

--
   g_body_sccsid   constant varchar2(200) :='"$Revision:   2.5  $"';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3inv_composite';
--
   g_mrg_results_table VARCHAR2(30);
   g_tab_inv_type_to_validate nm3type.tab_varchar4;
--
   c_session_id CONSTANT NUMBER       := USERENV('SESSIONID');
   c_inv_items  CONSTANT VARCHAR2(30) := 'NM_INV_ITEMS_ALL';
   g_ok_to_turn_off_au_security BOOLEAN;
   g_last_nqt_inv_type  nm_inv_types.nit_inv_type%TYPE;
   g_maintain_history   BOOLEAN;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_no_iit_locks;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_no_locks_internal (p_table_name VARCHAR2
                                  ,p_ner_appl   VARCHAR2
                                  ,p_ner_id     NUMBER
                                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it (p_text      VARCHAR2
                 ,p_append    BOOLEAN DEFAULT TRUE
                 ,p_timestamp BOOLEAN DEFAULT TRUE
                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE log_arr (p_text      nm3type.tab_varchar32767
                  ,p_append    BOOLEAN DEFAULT TRUE
                  ,p_timestamp BOOLEAN DEFAULT TRUE
                  );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_and_check_results_valid (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                      ,p_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_for_nt_type (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                 ,p_nt_type           nm_types.nt_type%TYPE
                                 ,p_effective_date    DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_for_temp_ne (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                 ,p_nte_job_id        nm_nw_temp_extents.nte_job_id%TYPE
                                 ,p_effective_date    DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_from_mrg_results (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                      ,p_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_from_mrg_section (p_nmnd_nit_inv_type  nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                      ,p_nms_mrg_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE
                                      ,p_nms_mrg_section_id nm_mrg_sections.nms_mrg_section_id%TYPE
                                      );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_the_inv (pi_rec_nms nm_mrg_sections%ROWTYPE);
--
-----------------------------------------------------------------------------
--
FUNCTION get_temp_ne_subset_nqt (p_nqt_rowid  ROWID
                                ,p_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                                ) RETURN nm_nw_temp_extents.nte_job_id%TYPE;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_for_element (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                 ,p_ne_id             nm_elements.ne_id%TYPE
                                 ,p_effective_date    DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 );
--
-----------------------------------------------------------------------------
--
FUNCTION get_changed_assets_since_last (p_nmnd_nmq_id    nm_mrg_nit_derivation.nmnd_nmq_id%TYPE
                                       ,p_nte_job_id     nm_nw_temp_extents.nte_job_id%TYPE
                                       ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                       ) RETURN nm_nw_temp_extents.nte_job_id%TYPE;
--
-----------------------------------------------------------------------------
--
FUNCTION get_changed_asset_area (p_nqt_rowid ROWID) RETURN NUMBER;
--
-----------------------------------------------------------------------------
--
FUNCTION run_ngq (p_nqg_id         nm_gaz_query.ngq_id%TYPE
                 ,p_effective_date DATE    DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                 ,p_use_date_based BOOLEAN DEFAULT TRUE
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
-----------------------------------------------------------------------------
--
PROCEDURE build_and_parse_sql (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                              ,p_check_all_mand_fields BOOLEAN DEFAULT TRUE
                              ) IS
   --
   TYPE tab_nmid IS TABLE OF nm_mrg_ita_derivation%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_nmid tab_nmid;
   l_tab_columns nm3type.tab_varchar30;
   --
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (g_block, p_text, p_nl);
   END append;
   --
   PROCEDURE check_l_tab_columns IS
      l_col_string  nm3type.max_varchar2;
   BEGIN
      IF l_tab_columns.COUNT != 0
       THEN
         FOR i IN 1..l_tab_columns.COUNT
          LOOP
            l_col_string := l_col_string||nm3flx.i_t_e(i>1,',',Null)||l_tab_columns(i);
         END LOOP;
         hig.raise_ner (pi_appl               => nm3type.c_hig
                       ,pi_id                 => 107
                       ,pi_supplementary_info => l_col_string
                       );
      END IF;
   END check_l_tab_columns;
   --
BEGIN
   g_nmnd_nit_inv_type := p_nmnd_nit_inv_type;
   g_rec_nmnd          := get_nmnd (p_nmnd_nit_inv_type);
   g_block.DELETE;
   append ('DECLARE');
   append ('--');
   append ('   CURSOR cs_results (c_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE');
   append ('                     ,c_section_id nm_mrg_sections.nms_mrg_section_id%TYPE');
   append ('                     ) IS');
   append ('   SELECT *');
   append ('    FROM  '||g_mrg_results_table||' '||g_mrg_record_name);
   append ('   WHERE  nqr_mrg_job_id     = c_job_id');
   append ('    AND   nms_mrg_section_id = c_section_id');
   IF g_rec_nmnd.nmnd_where_clause IS NOT NULL
    THEN
      append ('    AND  ('||g_rec_nmnd.nmnd_where_clause||')');
   END IF;
   append (';',FALSE);
   append ('--');
   append ('   '||g_inv_record_name||' nm_inv_items%ROWTYPE;');
   append ('   '||g_mrg_record_name||' '||g_mrg_results_table||'%ROWTYPE;');
   append ('   l_found BOOLEAN;');
   append ('--');
   append ('BEGIN');
   append ('--');
   append ('   IF NOT '||g_package_name||'.g_parse_only');
   append ('    THEN');
   append ('      OPEN  cs_results ('||g_package_name||'.g_nms_mrg_job_id,'||g_package_name||'.g_nms_mrg_section_id);');
   append ('      FETCH cs_results INTO '||g_mrg_record_name||';');
   append ('      l_found := cs_results%FOUND;');
   append ('      CLOSE cs_results;');
   append ('--');
   append ('      '||g_package_name||'.g_where_clause_failed := FALSE;');
   append ('      IF NOT l_found');
   append ('       THEN');
   IF g_rec_nmnd.nmnd_where_clause IS NOT NULL
    THEN
      append ('         '||g_package_name||'.g_where_clause_failed := TRUE;');
   ELSE
      append ('         hig.raise_ner (pi_appl               => nm3type.c_hig');
      append ('                       ,pi_id                 => 67');
      append ('                       ,pi_supplementary_info => '||nm3flx.string(g_mrg_results_table));
      append ('                       );');
   END IF;
   append ('      END IF;');
   append ('--');
   append ('      IF NOT '||g_package_name||'.g_where_clause_failed');
   append ('       THEN');
   append ('         '||g_inv_record_name||'.iit_ne_id      := nm3seq.next_ne_id_seq;');
   append ('         '||g_inv_record_name||'.iit_inv_type   := '||g_package_name||'.g_nmnd_nit_inv_type;');
   append ('         '||g_inv_record_name||'.iit_start_date := To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'');');
   append ('      END IF;');
   append ('--');
   append ('   END IF;');
   append ('--');
   --
   SELECT *
    BULK  COLLECT
    INTO  l_tab_nmid
    FROM  nm_mrg_ita_derivation
   WHERE  nmid_ita_inv_type = g_nmnd_nit_inv_type
   ORDER BY nmid_seq_no;
   --
   append ('   IF '||g_package_name||'.g_where_clause_failed');
   append ('    THEN');
   append ('      '||g_package_name||'.g_rec_iit := Null;');
   append ('   ELSE');
   FOR i IN 1..l_tab_nmid.COUNT
    LOOP
      IF UPPER(l_tab_nmid(i).nmid_ita_attrib_name) = 'IIT_ADMIN_UNIT'
       THEN
         check_au_derivation (pi_nmid_ita_inv_type => l_tab_nmid(i).nmid_ita_inv_type
                             ,pi_nmid_derivation   => l_tab_nmid(i).nmid_derivation
                             );
      END IF;
      append ('      '||g_inv_record_name||'.'||l_tab_nmid(i).nmid_ita_attrib_name||' := '||l_tab_nmid(i).nmid_derivation||';');
   END LOOP;
   --
   append ('      '||g_package_name||'.g_rec_iit := '||g_inv_record_name||';');
   append ('   END IF;');
   append ('--');
   append ('END;');
--
   log_it ('g_nmnd_nit_inv_type  = '||g_nmnd_nit_inv_type);
   log_it ('g_nms_mrg_job_id     = '||g_nms_mrg_job_id);
   log_it ('g_nms_mrg_section_id = '||g_nms_mrg_section_id);
   log_it ('g_parse_only         = '||nm3flx.boolean_to_char(g_parse_only));
--
   log_arr (g_block);
   g_parse_only := TRUE;
   nm3ddl.execute_tab_varchar (g_block);
   g_parse_only := FALSE;
--
   IF p_check_all_mand_fields
    THEN
      --
      -- This code only checks to see if there is a derivation for each mandatory
      --  (both on NM_INV_ITEMS and logically) field. if the derivation evaluates to
      --  Null in individual circumstances then this will be trapped in the creation of
      --  the asset
      --
      -- Check for mandatory in the table itself.
      --
      SELECT column_name
       BULK  COLLECT
       INTO  l_tab_columns
       FROM  all_tab_columns
      WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
       AND   table_name = c_inv_items
       AND   nullable   = 'N'
       AND   allowable_inv_column (column_name) = 'TRUE'
        AND  NOT EXISTS (SELECT 1
                          FROM  nm_mrg_ita_derivation
                         WHERE  nmid_ita_inv_type    = g_nmnd_nit_inv_type
                          AND   nmid_ita_attrib_name = column_name
                        );
      check_l_tab_columns;
      SELECT ita_attrib_name
       BULK  COLLECT
       INTO  l_tab_columns
       FROM  nm_inv_type_attribs
      WHERE  ita_inv_type     = g_nmnd_nit_inv_type
       AND   ita_mandatory_yn = 'Y'
       AND   NOT EXISTS (SELECT 1
                          FROM  nm_mrg_ita_derivation
                         WHERE  nmid_ita_inv_type    = ita_inv_type
                          AND   nmid_ita_attrib_name = ita_attrib_name
                        );
      check_l_tab_columns;
   END IF;
--
END build_and_parse_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_nmnd (p_nmnd_nit_inv_type     nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                        ,p_check_all_mand_fields BOOLEAN DEFAULT TRUE
                        ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'validate_nmnd');
--
   get_and_check_results_valid (p_nmnd_nit_inv_type => p_nmnd_nit_inv_type
                               ,p_nqr_mrg_job_id    => -1
                               );
--
   build_and_parse_sql (p_nmnd_nit_inv_type     => p_nmnd_nit_inv_type
                       ,p_check_all_mand_fields => p_check_all_mand_fields
                       );
--
   nm_debug.proc_start (g_package_name,'validate_nmnd');
--
END validate_nmnd;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_nmnd (p_rec_nmnd nm_mrg_nit_derivation%ROWTYPE) IS
   l_rec_nit nm_inv_types%ROWTYPE;
BEGIN
--
   nm_debug.proc_start (g_package_name,'check_nmnd');
--
   l_rec_nit := nm3get.get_nit (pi_nit_inv_type => p_rec_nmnd.nmnd_nit_inv_type);
--
   IF invsec.chk_inv_type_valid_for_role (l_rec_nit.nit_inv_type) = invsec.c_false_string
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 86
                    ,pi_supplementary_info => Null
                    );
   ELSIF l_rec_nit.nit_category != c_composite_nic_category
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 400
                    ,pi_supplementary_info => 'nit_category-'||l_rec_nit.nit_category||' != '||c_composite_nic_category
                    );
   ELSIF l_rec_nit.nit_exclusive != 'Y'
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 401
                    ,pi_supplementary_info => 'nit_exclusive-'||l_rec_nit.nit_exclusive||' != "Y"'
                    );
--   ELSIF l_rec_nit.nit_x_sect_allow_flag != 'N'
--    THEN
--      hig.raise_ner (pi_appl               => nm3type.c_net
--                    ,pi_id                 => 402
--                    ,pi_supplementary_info => 'nit_x_sect_allow_flag-'||l_rec_nit.nit_x_sect_allow_flag||' != "N"'
--                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'check_nmnd');
--
END check_nmnd;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmnd (pi_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                  ) RETURN nm_mrg_nit_derivation%ROWTYPE IS
--
   CURSOR cs_nmnd (c_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE) IS
   SELECT *
    FROM  nm_mrg_nit_derivation
   WHERE  nmnd_nit_inv_type = c_nmnd_nit_inv_type;
--
   l_rec_nmnd nm_mrg_nit_derivation%ROWTYPE;
   l_found    BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_nmnd');
--
   OPEN  cs_nmnd (pi_nmnd_nit_inv_type);
   FETCH cs_nmnd INTO l_rec_nmnd;
   l_found := cs_nmnd%FOUND;
   CLOSE cs_nmnd;
--
   IF NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'nm_mrg_nit_derivation.nmnd_nit_inv_type="'||pi_nmnd_nit_inv_type||'"'
                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'get_nmnd');
--
   RETURN l_rec_nmnd;
--
END get_nmnd;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_and_check_results_valid (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                      ,p_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                      ) IS
--
   l_rec_nqr      nm_mrg_query_results%ROWTYPE;
   l_rec_nmnd     nm_mrg_nit_derivation%ROWTYPE;
   l_rec_nit      nm_inv_types%ROWTYPE;
   l_nmq_unique_1 nm_mrg_query.nmq_unique%TYPE;
   l_nmq_unique_2 nm_mrg_query.nmq_unique%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_and_check_results_valid');
--
   l_rec_nmnd         := get_nmnd (pi_nmnd_nit_inv_type => p_nmnd_nit_inv_type);
   l_rec_nit          := nm3get.get_nit (pi_nit_inv_type => l_rec_nmnd.nmnd_nit_inv_type);
   g_nmnd_is_point    := l_rec_nit.nit_pnt_or_cont = 'P';
   g_last_update_date := l_rec_nmnd.nmnd_last_refresh_date;
   IF p_nqr_mrg_job_id != -1
    THEN
   --
      l_rec_nqr  := nm3get.get_nmqr (pi_nqr_mrg_job_id => p_nqr_mrg_job_id);
   --
      IF l_rec_nmnd.nmnd_nmq_id != l_rec_nqr.nqr_nmq_id
       THEN
         l_nmq_unique_1 := nm3get.get_nmq (pi_nmq_id          => l_rec_nmnd.nmnd_nmq_id
                                          ,pi_raise_not_found => FALSE
                                          ).nmq_unique;
         l_nmq_unique_2 := nm3get.get_nmq (pi_nmq_id          => l_rec_nqr.nqr_nmq_id
                                          ,pi_raise_not_found => FALSE
                                          ).nmq_unique;
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 121
                       ,pi_supplementary_info => l_nmq_unique_1||' != '||l_nmq_unique_2
                       );
      END IF;
   --
   END IF;
--
   g_mrg_results_table := get_merge_results_view (l_rec_nmnd.nmnd_nmq_id);
--
   nm_debug.proc_end (g_package_name,'get_and_check_results_valid');
--
END get_and_check_results_valid;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_from_mrg_results (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                      ,p_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                      ) IS
--
   l_rec_nqr                nm_mrg_query_results%ROWTYPE;
   l_tab_nms_mrg_section_id nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inv_from_mrg_results');
--
   get_and_check_results_valid (p_nmnd_nit_inv_type => p_nmnd_nit_inv_type
                               ,p_nqr_mrg_job_id    => p_nqr_mrg_job_id
                               );
--
   SELECT nms_mrg_section_id
    BULK  COLLECT
    INTO  l_tab_nms_mrg_section_id
    FROM  nm_mrg_sections
   WHERE  nms_mrg_job_id = p_nqr_mrg_job_id
   ORDER BY nms_mrg_section_id;
--
   FOR i IN 1..l_tab_nms_mrg_section_id.COUNT
    LOOP
      create_inv_from_mrg_section (p_nmnd_nit_inv_type  => p_nmnd_nit_inv_type
                                  ,p_nms_mrg_job_id     => p_nqr_mrg_job_id
                                  ,p_nms_mrg_section_id => l_tab_nms_mrg_section_id(i)
                                  );
   END LOOP;
--
   DELETE FROM nm_mrg_query_results
   WHERE  nqr_mrg_job_id = p_nqr_mrg_job_id;
--
   nm_debug.proc_end (g_package_name,'create_inv_from_mrg_results');
--
END create_inv_from_mrg_results;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_from_mrg_section (p_nmnd_nit_inv_type  nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                      ,p_nms_mrg_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE
                                      ,p_nms_mrg_section_id nm_mrg_sections.nms_mrg_section_id%TYPE
                                      ) IS
--
   l_rec_nms  nm_mrg_sections%ROWTYPE;
--
   l_create_chunk BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inv_from_mrg_section');
--
   get_and_check_results_valid (p_nmnd_nit_inv_type => p_nmnd_nit_inv_type
                               ,p_nqr_mrg_job_id    => p_nms_mrg_job_id
                               );
--
   l_rec_nms := nm3get.get_nms (pi_nms_mrg_job_id     => p_nms_mrg_job_id
                               ,pi_nms_mrg_section_id => p_nms_mrg_section_id
                               );
--
   l_create_chunk :=    (g_nmnd_is_point
                          AND l_rec_nms.nms_ne_id_first    = l_rec_nms.nms_ne_id_last
                          AND l_rec_nms.nms_begin_mp_first = l_rec_nms.nms_end_mp_last
                         )
                     OR (NOT g_nmnd_is_point
                         AND (l_rec_nms.nms_ne_id_first       != l_rec_nms.nms_ne_id_last
                              OR l_rec_nms.nms_begin_mp_first != l_rec_nms.nms_end_mp_last
                             )
                        );
--
   IF l_create_chunk
    THEN
      IF  g_nmnd_nit_inv_type != p_nmnd_nit_inv_type
       THEN
         build_and_parse_sql (p_nmnd_nit_inv_type);
      END IF;
   --
      g_nms_mrg_job_id     := p_nms_mrg_job_id;
      g_nms_mrg_section_id := p_nms_mrg_section_id;
   --
      create_the_inv (l_rec_nms);
   --
   END IF;
--
   nm_debug.proc_end (g_package_name,'create_inv_from_mrg_section');
--
END create_inv_from_mrg_section;
--
-----------------------------------------------------------------------------
--
FUNCTION get_item_detail (p_rec_iit nm_inv_items%ROWTYPE) RETURN VARCHAR2 IS
--
   CURSOR cs_attribs (c_inv_type nm_mrg_ita_derivation.nmid_ita_inv_type%TYPE) IS
   SELECT nmid_ita_attrib_name
         ,LOWER(REPLACE(DECODE(ita_view_col_name
                              ,NULL,nmid_ita_attrib_name
                              ,ita_view_col_name||' ('||nmid_ita_attrib_name||')'
                              )
                        ,'_'
                        ,' '
                        )
               ) ita_view_col_name
    FROM  nm_mrg_ita_derivation
         ,nm_inv_type_attribs
   WHERE  nmid_ita_inv_type    = c_inv_type
    AND   nmid_ita_inv_type    = ita_inv_type (+)
    AND   nmid_ita_attrib_name = ita_attrib_name (+)
   ORDER BY nmid_seq_no;
--
   l_sql nm3type.max_varchar2;
   PROCEDURE append (p_Text varchar2) IS
   BEGIN
      g_string_temp := g_string_temp||p_text;
   END append;
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_item_detail');
--
   g_string_temp  := Null;
   g_rec_iit_temp := p_rec_iit;
   append (htf.tableopen (cattributes=>'BORDER=1'));
   l_sql :=        'DECLARE'
        ||CHR(10)||' l_rec nm_inv_items%ROWTYPE := '||g_package_name||'.g_rec_iit_temp;'
        ||CHR(10)||' l_str nm3type.max_varchar2 := '||g_package_name||'.g_string_temp;'
        ||CHR(10)||' PROCEDURE add_it(p_head VARCHAR2,p_body VARCHAR2) IS'
        ||CHR(10)||' BEGIN'
        ||CHR(10)||'  l_str := l_str||htf.tablerowopen||htf.tableheader(p_head)||htf.tabledata(NVL(p_body,nm3web.c_nbsp))||htf.tablerowclose;'
        ||CHR(10)||' END add_it;'
        ||CHR(10)||' PROCEDURE add_it(p_head VARCHAR2,p_body NUMBER) IS'
        ||CHR(10)||' BEGIN'
        ||CHR(10)||'  add_it (p_head,TO_CHAR(p_body));'
        ||CHR(10)||' END add_it;'
        ||CHR(10)||' PROCEDURE add_it(p_head VARCHAR2,p_body DATE) IS'
        ||CHR(10)||' BEGIN'
        ||CHR(10)||'  add_it (p_head,TO_CHAR(p_body,Sys_Context(''NM3CORE'',''USER_DATE_MASK'')));'
        ||CHR(10)||' END add_it;'
        ||CHR(10)||'BEGIN';
--
   FOR cs_rec IN cs_attribs (p_rec_iit.iit_inv_type)
    LOOP
      l_sql := l_sql||CHR(10)||' add_it('||nm3flx.string(cs_Rec.ita_view_col_name)||',l_rec.'||cs_rec.nmid_ita_attrib_name||');';
   END LOOP;
--
   l_sql := l_sql
        ||CHR(10)||' '||g_package_name||'.g_string_temp := l_str;'
        ||CHR(10)||'END;';
--
--   log_it (l_sql);
   DECLARE
      l_6502 EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_6502,-6502);
   BEGIN
      EXECUTE IMMEDIATE l_sql;
      append (htf.tableclose);
   EXCEPTION
      WHEN l_6502
       THEN
         Null;
   END;
--
   nm_debug.proc_end (g_package_name,'get_item_detail');
--
   RETURN g_string_temp;
END get_item_detail;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nms_detail (p_nms_mrg_job_id     nm_mrg_sections.nms_mrg_job_id%TYPE
                        ,p_nms_mrg_section_id nm_mrg_sections.nms_mrg_section_id%TYPE
                        ) RETURN VARCHAR2 IS
   l_retval nm3type.max_Varchar2;
   PROCEDURE append (p_Text varchar2) IS
   BEGIN
      l_retval := l_retval||p_text;
   END append;
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_nms_detail');
--
   append (htf.tableopen (cattributes=>'BORDER=1'));
   append (htf.tablerowopen);
   append (htf.tableheader('Element',cattributes=>'COLSPAN=2'));
   append (htf.tableheader('From'));
   append (htf.tableheader('To'));
   append (htf.tablerowclose);
--
   DECLARE
      l_6502 EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_6502,-6502);
   BEGIN
      FOR cs_rec IN (SELECT ne_unique
                           ,ne_nt_type
                           ,nsm_begin_mp
                           ,nsm_end_mp
                      FROM  nm_mrg_section_members
                           ,nm_elements
                     WHERE  nsm_mrg_job_id     = p_nms_mrg_job_id
                      AND   nsm_mrg_section_id = p_nms_mrg_section_id
                      AND   ne_id              = nsm_ne_id
                     ORDER BY nsm_measure
                    )
       LOOP
         append (htf.tablerowopen);
         append (htf.tabledata (cs_rec.ne_unique));
         append (htf.tabledata (cs_rec.ne_nt_type));
         append (htf.tabledata (cs_rec.nsm_begin_mp));
         append (htf.tabledata (cs_rec.nsm_end_mp));
         append (htf.tablerowclose);
      END LOOP;
      append (htf.tableclose);
   EXCEPTION
      WHEN l_6502
       THEN
         Null;
   END;
--
   nm_debug.proc_end (g_package_name,'get_nms_detail');
--
   RETURN l_retval;
--
END get_nms_detail;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_error (p_sqlerrm VARCHAR2) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'append_error');
--
   g_error_count                   := g_error_count + 1;
   g_tab_error_item(g_error_count) := get_item_detail (g_rec_iit);
   g_tab_error_locn(g_error_count) := get_nms_detail (g_nms_mrg_job_id,g_nms_mrg_section_id);
   g_tab_error_errm(g_error_count) := nm3flx.parse_error_message(p_sqlerrm);
--
   nm_debug.proc_end (g_package_name,'append_error');
--
END append_error;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_item IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'append_item');
--
   g_inv_count                  := g_inv_count + 1;
   --
   -- JM - 18/08/05 - don't append details for all items created
   --                 this will potentially create a massive email
   --
--   g_tab_done_item(g_inv_count) := get_item_detail (g_rec_iit);
--   g_tab_done_locn(g_inv_count) := get_nms_detail (g_nms_mrg_job_id,g_nms_mrg_section_id);
--
   nm_debug.proc_end (g_package_name,'append_item');
--
END append_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_the_inv (pi_rec_nms nm_mrg_sections%ROWTYPE) IS
   l_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;
   c_ausec_status CONSTANT VARCHAR2(30) := nm3ausec.get_status;
   PROCEDURE del_nte IS
   BEGIN
      DELETE FROM nm_nw_temp_extents
      WHERE  nte_job_id = l_nte_job_id;
   END del_nte;
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_the_inv');
   --
   nm3ddl.execute_tab_varchar (g_block);
   --
   IF NOT g_where_clause_failed
    THEN
      --
      l_nte_job_id := -1;
      --
      del_nte;
   --
      nm3ins.ins_iit (g_rec_iit);
      --
      -- Create the temp ne manually rather than calling
      --  create_temp_ne as it does some stuff which is unecessary
      --  for this (like working out the parent ne_id) which slows it
      --  down dramatically
      --
      INSERT INTO nm_nw_temp_extents
            (nte_job_id
            ,nte_ne_id_of
            ,nte_begin_mp
            ,nte_end_mp
            ,nte_cardinality
            ,nte_seq_no
            ,nte_route_ne_id
            )
      SELECT l_nte_job_id
            ,nsm_ne_id
            ,nsm_begin_mp
            ,nsm_end_mp
            ,1
            ,ROWNUM
            ,pi_rec_nms.nms_offset_ne_id
       FROM (SELECT nsm_ne_id
                   ,nsm_begin_mp
                   ,nsm_end_mp
              FROM  nm_mrg_section_members
             WHERE  nsm_mrg_job_id     = g_nms_mrg_job_id
              AND   nsm_mrg_section_id = g_nms_mrg_section_id
             ORDER BY nsm_measure
            );
      --
      IF g_ok_to_turn_off_au_security
       THEN
         nm3ausec.set_status (nm3type.c_off);
      END IF;
      --
      nm3homo.homo_update (p_temp_ne_id_in  => l_nte_job_id
                          ,p_iit_ne_id      => g_rec_iit.iit_ne_id
                          ,p_effective_date => g_rec_iit.iit_start_date
                          );
      nm3ausec.set_status (c_ausec_status);
      --
      del_nte;
      --
      append_item;
      --
   END IF;
--
   nm_debug.proc_end (g_package_name,'create_the_inv');
--
EXCEPTION
   WHEN others
    THEN
      nm3ausec.set_status (c_ausec_status);
      append_error (SQLERRM);
END create_the_inv;
--
-----------------------------------------------------------------------------
--
--PROCEDURE analyse_table_and_indexes (p_table VARCHAR2) IS
--   l_tab_ind nm3type.tab_varchar30;
--BEGIN
----
--   nm_debug.proc_start (g_package_name,'analyse_table_and_indexes');
----
--   dbms_stats.gather_table_stats (ownname => c_app_owner
--                                 ,tabname => p_table
--                                 ,cascade => true
--                                 );
--   SELECT index_name
--    BULK  COLLECT
--    INTO  l_tab_ind
--    FROM  all_indexes
--   WHERE  owner      = c_app_owner
--    AND   table_name = p_table;
--   FOR j IN 1..l_tab_ind.COUNT
--    LOOP
--      dbms_stats.gather_index_stats (ownname => c_app_owner
--                                    ,indname => l_tab_ind(j)
--                                    );
--   END LOOP;
----
--   nm_debug.proc_end (g_package_name,'analyse_table_and_indexes');
----
--END analyse_table_and_indexes;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_all_elements_by_nt (pi_nt_type       IN     nm_types.nt_type%TYPE
                                 ,po_tab_ne_id        OUT nm3type.tab_number
                                 ,po_tab_ne_unique    OUT nm3type.tab_varchar30
                                 ) IS
BEGIN
   SELECT ne_id
         ,ne_unique
    BULK  COLLECT
    INTO  po_tab_ne_id
         ,po_tab_ne_unique
    FROM  nm_elements
   WHERE  ne_nt_type = pi_nt_type;
END get_all_elements_by_nt;
--
-----------------------------------------------------------------------------
--
FUNCTION create_tmp_ne_for_items_in_arr (pi_tab_item_id        IN nm3type.tab_number
                                        ,pi_tab_item_type_type IN nm3type.tab_varchar4
                                        ,pi_tab_item_type      IN nm3type.tab_varchar4
                                        ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
   l_tab_nm_ne_id_of    nm3type.tab_number;
   l_tab_nm_begin_mp    nm3type.tab_number;
   l_tab_nm_end_mp      nm3type.tab_number;
   l_tab_nm_cardinality nm3type.tab_number;
   l_tab_nm_ne_id_in    nm3type.tab_number;
   l_tab_nm_seq_no      nm3type.tab_number;
   l_tab_item_type_type nm3type.tab_varchar4;
   l_tab_item_type      nm3type.tab_varchar4;
   l_nte_job_id         nm_nw_temp_extents.nte_job_id%TYPE;
--
   CURSOR cs_current_mem IS
   SELECT /*+ INDEX (nm nm_pk) */
          nm_ne_id_of
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_cardinality
         ,nm_ne_id_in
         ,item_type_type
         ,item_type
    FROM  nm_members nm
         ,nm_mrg_inv_derivation_nte_temp
   WHERE  nm_ne_id_in = nte_job_id
   ORDER BY nm_ne_id_in, nm_seq_no;
--
   CURSOR cs_end_dated_mem IS
   SELECT /*+ INDEX (nm nm_pk) */
          nm_ne_id_of
         ,nm_begin_mp
         ,nm_end_mp
         ,nm_cardinality
         ,nm_ne_id_in
         ,item_type_type
         ,item_type
    FROM  nm_members_all nm
         ,nm_mrg_inv_derivation_nte_temp
   WHERE  nm_ne_id_in = nte_job_id
    AND   nm_date_modified >  g_last_update_date
    AND   nm_start_date    <= To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
    AND  NOT (nm_end_date IS NULL OR nm_end_date > To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'))
   ORDER BY nm_ne_id_in, nm_date_created, nm_seq_no;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_tmp_ne_for_items_in_arr');
--
log_it('before insert into nm_mrg_inv_derivation_nte_temp');
   DELETE nm_mrg_inv_derivation_nte_temp;
   FORALL i IN 1..pi_tab_item_id.COUNT
       INSERT INTO nm_mrg_inv_derivation_nte_temp
              (nte_job_id
              ,item_type_type
              ,item_type
              )
       VALUES (pi_tab_item_id(i)
              ,pi_tab_item_type_type(i)
              ,pi_tab_item_type(i)
              );
--
log_it('before bulk collect for all memberships');
   OPEN  cs_current_mem;
   FETCH cs_current_mem
    BULK COLLECT
    INTO l_tab_nm_ne_id_of
        ,l_tab_nm_begin_mp
        ,l_tab_nm_end_mp
        ,l_tab_nm_cardinality
        ,l_tab_nm_ne_id_in
        ,l_tab_item_type_type
        ,l_tab_item_type;
   CLOSE cs_current_mem;
log_it('after bulk collect for all memberships ('||l_tab_nm_ne_id_of.COUNT||' records)');
--
   FOR cs_rec IN cs_end_dated_mem 
    LOOP
      DECLARE
         c CONSTANT PLS_INTEGER := l_tab_nm_ne_id_of.COUNT+1;
      BEGIN
         l_tab_nm_ne_id_of(c)    := cs_rec.nm_ne_id_of;
         l_tab_nm_begin_mp(c)    := cs_rec.nm_begin_mp;
         l_tab_nm_end_mp(c)      := cs_rec.nm_end_mp;
         l_tab_nm_cardinality(c) := cs_rec.nm_cardinality;
         l_tab_nm_ne_id_in(c)    := cs_rec.nm_ne_id_in;
         l_tab_item_type_type(c) := cs_rec.item_type_type;
         l_tab_item_type(c)      := cs_rec.item_type;
      END;
   END LOOP;
--
   FOR i IN 1..l_tab_nm_ne_id_of.COUNT
    LOOP
      l_tab_nm_seq_no(i)  := i;
      IF l_tab_item_type_type(i) != nm3gaz_qry.c_ngqt_item_type_type_ele
       THEN
         l_tab_nm_ne_id_in(i) := l_tab_nm_ne_id_of(i);
      END IF;
   END LOOP;
   l_nte_job_id := nm3net.get_next_nte_id;
log_it('before bulk insert for all nte');
   FORALL i IN 1..l_tab_nm_ne_id_of.COUNT
      INSERT INTO nm_nw_temp_extents
             (nte_job_id
             ,nte_ne_id_of
             ,nte_begin_mp
             ,nte_end_mp
             ,nte_cardinality
             ,nte_seq_no
             ,nte_route_ne_id
             )
      VALUES (l_nte_job_id
             ,l_tab_nm_ne_id_of(i)
             ,l_tab_nm_begin_mp(i)
             ,l_tab_nm_end_mp(i)
             ,l_tab_nm_cardinality(i)
             ,l_tab_nm_seq_no(i)
             ,l_tab_nm_ne_id_in(i)
             );
--
log_it('after bulk insert for all nte');
   DELETE nm_mrg_inv_derivation_nte_temp;
--
   nm_debug.proc_end (g_package_name,'create_tmp_ne_for_items_in_arr');
--
   RETURN l_nte_job_id;
--
END create_tmp_ne_for_items_in_arr;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_for_nt_type (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                 ,p_nt_type           nm_types.nt_type%TYPE
                                 ,p_effective_date    DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 ) IS
   c_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_st_time           NUMBER;
   l_tab_ne_id         nm3type.tab_number;
   l_tab_ne_unique     nm3type.tab_varchar30;
   l_rec_nmnd          nm_mrg_nit_derivation%ROWTYPE;
--
   l_nte_job_id         nm_nw_temp_extents.nte_job_id%TYPE;
   l_nte_job_id2        nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inv_for_nt_type');
--
   nm3user.set_effective_date (p_effective_date);
   l_rec_nmnd         := get_nmnd (pi_nmnd_nit_inv_type => p_nmnd_nit_inv_type);
--
   get_all_elements_by_nt (pi_nt_type       => p_nt_type
                          ,po_tab_ne_id     => l_tab_ne_id
                          ,po_tab_ne_unique => l_tab_ne_unique
                          );
--
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm_debug.set_level(0);
--
   g_last_update_date := l_rec_nmnd.nmnd_last_refresh_date;
--
   FOR i IN 1..l_tab_ne_id.COUNT
    LOOP
--      l_st_time := dbms_utility.get_time;
      create_inv_for_element (p_nmnd_nit_inv_type => p_nmnd_nit_inv_type
                             ,p_ne_id             => l_tab_ne_id(i)
                             ,p_effective_date    => p_effective_date
                             );
--         log_it(l_tab_ne_unique(i)||':'||((dbms_utility.get_time-l_st_time)/100),0);
   END LOOP;
--   nm_debug.set_level(3);
--   nm_debug.debug_off;
--
   nm3user.set_effective_date (c_eff_date);
--
   nm_debug.proc_end (g_package_name,'create_inv_for_nt_type');
--
--EXCEPTION
--   WHEN others
--    THEN
--      nm3user.set_effective_date (c_eff_date);
--      RAISE;
END create_inv_for_nt_type;
--
-----------------------------------------------------------------------------
--
FUNCTION this_nte_has_inv (p_nte_job_id NUMBER) RETURN BOOLEAN IS
   l_retval BOOLEAN;
BEGIN
   l_retval := TRUE;
   RETURN l_retval;
END this_nte_has_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_for_element (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                 ,p_ne_id             nm_elements.ne_id%TYPE
                                 ,p_effective_date    DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 ) IS
--
   l_rec_nmnd          nm_mrg_nit_derivation%ROWTYPE;
   l_rec_ne            nm_elements%ROWTYPE;
   c_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_nte_job_id        nm_nw_temp_extents.nte_job_id%TYPE;
   l_nte_job_id2       nm_nw_temp_extents.nte_job_id%TYPE;
   l_mrg_job_id        nm_mrg_query_results.nqr_mrg_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inv_for_element');
--
   nm3user.set_effective_date (p_effective_date);
   l_rec_nmnd         := get_nmnd (pi_nmnd_nit_inv_type => p_nmnd_nit_inv_type);
   l_rec_ne           := nm3get.get_ne (pi_ne_id => p_ne_id);
   g_last_update_date := l_rec_nmnd.nmnd_last_refresh_date;
--
   nm3extent.create_temp_ne (pi_source_id      => l_rec_ne.ne_id
                            ,pi_source         => nm3extent.c_route
                            ,po_job_id         => l_nte_job_id
                            );
--
   IF this_nte_has_inv (l_nte_job_id)
    THEN
      create_inv_for_temp_ne (p_nmnd_nit_inv_type => p_nmnd_nit_inv_type
                             ,p_nte_job_id        => l_nte_job_id
                             ,p_effective_date    => p_effective_date
                             );
   END IF;
--
   DELETE FROM nm_nw_temp_extents
   WHERE  nte_job_id = l_nte_job_id;
--
   nm3user.set_effective_date (c_eff_date);
--
   nm_debug.proc_end (g_package_name,'create_inv_for_element');
--
END create_inv_for_element;
--
-----------------------------------------------------------------------------
--

FUNCTION get_union_of_nte (p_nte_job_id_parent     nm_nw_temp_extents.nte_job_id%TYPE
                          ,p_tab_nte_job_id_subset nm3type.tab_number
                          ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
   l_retval           nm_nw_temp_extents.nte_job_id%TYPE;
   l_tab_nte_ne_id_of nm3type.tab_number;
   l_tab_nte          nm3extent.tab_nte;
   l_seq_no           NUMBER := 0;
   l_rec_nte          nm_nw_temp_extents%ROWTYPE;
   l_tab_nte_union    nm3extent.tab_nte;
   l_tab_done         nm3type.tab_boolean;
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_union_of_nte');
--
   DELETE FROM nm_mrg_inv_derivation_nte_temp;
--
   FORALL i IN 1..p_tab_nte_job_id_subset.COUNT
      INSERT INTO nm_mrg_inv_derivation_nte_temp (nte_job_id)
      VALUES (p_tab_nte_job_id_subset(i));
--
   SELECT a.nte_ne_id_of
    BULK  COLLECT
    INTO  l_tab_nte_ne_id_of
    FROM  nm_nw_temp_extents a
   WHERE  a.nte_job_id = p_nte_job_id_parent
    AND   EXISTS (SELECT 1
                   FROM  nm_nw_temp_extents b, nm_mrg_inv_derivation_nte_temp c
                  WHERE  b.nte_job_id   = c.nte_job_id
                   AND   a.nte_ne_id_of = b.nte_ne_id_of
                 )
   ORDER BY a.nte_seq_no;
--
   l_retval := nm3net.get_next_nte_id;
--
   FOR i IN 1..l_tab_nte_ne_id_of.COUNT
    LOOP
--
      IF l_tab_done.EXISTS (l_tab_nte_ne_id_of(i))
       THEN
         Null;
      ELSE
   --
--         log_it(i||'.'||l_tab_nte_ne_id_of(i)||':'||nm3net.get_ne_unique(l_tab_nte_ne_id_of(i) ));
   --
         l_tab_done (l_tab_nte_ne_id_of(i)) := TRUE;
   --
         SELECT b.*
          BULK  COLLECT
          INTO  l_tab_nte
         FROM   nm_nw_temp_extents b, nm_mrg_inv_derivation_nte_temp c
         WHERE  b.nte_job_id          = c.nte_job_id
          AND   l_tab_nte_ne_id_of(i) = b.nte_ne_id_of
         ORDER BY nte_begin_mp, nte_end_mp;
   --
         l_rec_nte := Null;
         FOR j IN 1..l_tab_nte.COUNT
          LOOP
--            log_it(' '||j||'.'||l_tab_nte(j).nte_begin_mp||'-'||l_tab_nte(j).nte_end_mp);
            IF j = 1
             THEN
--               log_it('j=1!!!!');
               l_seq_no                     := l_seq_no + 1;
               l_rec_nte                    := l_tab_nte(j);
               l_rec_nte.nte_job_id         := l_retval;
               l_rec_nte.nte_seq_no         := l_seq_no;
            ELSE
               IF l_tab_nte(j).nte_begin_mp > l_rec_nte.nte_end_mp
                THEN
                  -- gap - throw;
                  l_tab_nte_union(l_seq_no) := l_rec_nte;
                  l_seq_no                  := l_seq_no + 1;
                  l_rec_nte                 := l_tab_nte(j);
                  l_rec_nte.nte_job_id      := l_retval;
                  l_rec_nte.nte_seq_no      := l_seq_no;
               ELSIF l_tab_nte(j).nte_end_mp > l_rec_nte.nte_end_mp
                THEN
                  l_rec_nte.nte_end_mp      := l_tab_nte(j).nte_end_mp;
               END IF;
            END IF;
            --
         END LOOP;
   --
         IF l_rec_nte.nte_job_id IS NOT NULL
          THEN -- throw the last one
            l_tab_nte_union(l_seq_no) := l_rec_nte;
         END IF;
      END IF;
--
   END LOOP;
--
   nm3extent.ins_tab_nte (l_tab_nte_union);
--
   DELETE FROM nm_mrg_inv_derivation_nte_temp;
--
   nm_debug.proc_end (g_package_name,'get_union_of_nte');
--
   RETURN l_retval;
--
END get_union_of_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_gaz_qry_from_nqt (p_nqt_rowid  ROWID
                                 ,p_ngq_id     nm_gaz_query.ngq_id%TYPE
                                 ) IS
   l_rec_nqt  nm_mrg_query_types%ROWTYPE;
   l_tab_nqa  nm3mrg.tab_mrg_qry_attribs;
   l_tab_nqv  nm3mrg.tab_mrg_qry_values;
   l_rec_ngqt nm_gaz_query_types%ROWTYPE;
   l_rec_ngqa nm_gaz_query_attribs%ROWTYPE;
   l_rec_ngqv nm_gaz_query_values%ROWTYPE;
BEGIN
--
   SELECT *
    INTO  l_rec_nqt
    FROM  nm_mrg_query_types
   WHERE  ROWID = p_nqt_rowid;
--
   g_last_nqt_inv_type := l_rec_nqt.nqt_inv_type;
--
   l_rec_ngqt.ngqt_ngq_id                   := p_ngq_id;
   l_rec_ngqt.ngqt_seq_no                   := 1;
   l_rec_ngqt.ngqt_item_type_type           := nm3gaz_qry.c_ngqt_item_type_type_inv;
   l_rec_ngqt.ngqt_item_type                := l_rec_nqt.nqt_inv_type;
   nm3ins.ins_ngqt(l_rec_ngqt);
--
   l_rec_ngqa.ngqa_ngq_id                   := l_rec_ngqt.ngqt_ngq_id;
   l_rec_ngqa.ngqa_ngqt_seq_no              := l_rec_ngqt.ngqt_seq_no;
   l_rec_ngqa.ngqa_seq_no                   := 0;
   l_rec_ngqa.ngqa_attrib_name              := Null;
   l_rec_ngqa.ngqa_operator                 := 'AND';
   l_rec_ngqa.ngqa_pre_bracket              := Null;
   l_rec_ngqa.ngqa_post_bracket             := Null;
   l_rec_ngqa.ngqa_condition                := '=';
--
   l_rec_ngqv.ngqv_ngq_id                   := l_rec_ngqa.ngqa_ngq_id;
   l_rec_ngqv.ngqv_ngqt_seq_no              := l_rec_ngqa.ngqa_ngqt_seq_no;
   l_rec_ngqv.ngqv_ngqa_seq_no              := 0;
   l_rec_ngqv.ngqv_sequence                 := Null;
   l_rec_ngqv.ngqv_value                    := Null;
--
   IF l_rec_nqt.nqt_x_sect IS NOT NULL
    THEN
      l_rec_ngqa.ngqa_seq_no                := l_rec_ngqa.ngqa_seq_no +  1;
      l_rec_ngqa.ngqa_attrib_name           := 'IIT_X_SECT';
      l_rec_ngqa.ngqa_condition             := '=';
      nm3ins.ins_ngqa (l_rec_ngqa);
      l_rec_ngqv.ngqv_ngqa_seq_no           := l_rec_ngqa.ngqa_seq_no;
      l_rec_ngqv.ngqv_sequence              := 1;
      l_rec_ngqv.ngqv_value                 := l_rec_nqt.nqt_x_sect;
      nm3ins.ins_ngqv (l_rec_ngqv);
   END IF;
--
   SELECT *
    BULK  COLLECT
    INTO  l_tab_nqa
    FROM  nm_mrg_query_attribs
   WHERE  nqa_nmq_id     = l_rec_nqt.nqt_nmq_id
    AND   nqa_nqt_seq_no = l_rec_nqt.nqt_seq_no
    AND   nqa_condition IS NOT NULL;
--
   FOR i IN 1..l_tab_nqa.COUNT
    LOOP
--
      SELECT *
       BULK  COLLECT
       INTO  l_tab_nqv
       FROM  nm_mrg_query_values
      WHERE  nqv_nmq_id       = l_tab_nqa(i).nqa_nmq_id
       AND   nqv_nqt_seq_no   = l_tab_nqa(i).nqa_nqt_seq_no
       AND   nqv_attrib_name  = l_tab_nqa(i).nqa_attrib_name
      ORDER BY nqv_sequence;
--
      IF nm3mrg_supplementary.valid_pbi_condition_values (l_tab_nqa(i).nqa_condition
                                                         ,l_tab_nqv.COUNT
                                                         )
       THEN
         l_rec_ngqa.ngqa_seq_no                := l_rec_ngqa.ngqa_seq_no +  1;
         l_rec_ngqa.ngqa_attrib_name           := l_tab_nqa(i).nqa_attrib_name;
         l_rec_ngqa.ngqa_condition             := l_tab_nqa(i).nqa_condition;
         nm3ins.ins_ngqa (l_rec_ngqa);
         FOR j IN 1..l_tab_nqv.COUNT
          LOOP
            l_rec_ngqv.ngqv_ngqa_seq_no           := l_rec_ngqa.ngqa_seq_no;
            l_rec_ngqv.ngqv_sequence              := j;
            l_rec_ngqv.ngqv_value                 := l_tab_nqv(j).nqv_value;
            nm3ins.ins_ngqv (l_rec_ngqv);
         END LOOP;
      END IF;
--
   END LOOP;
--
   l_rec_ngqa.ngqa_seq_no                := l_rec_ngqa.ngqa_seq_no +  1;
   l_rec_ngqa.ngqa_attrib_name           := 'IIT_DATE_MODIFIED';
   l_rec_ngqa.ngqa_condition             := '>';
   nm3ins.ins_ngqa (l_rec_ngqa);
   l_rec_ngqv.ngqv_ngqa_seq_no           := l_rec_ngqa.ngqa_seq_no;
   l_rec_ngqv.ngqv_sequence              := 1;
   l_rec_ngqv.ngqv_value                 := TO_CHAR(g_last_update_date,nm3type.c_full_date_time_format);
   nm3ins.ins_ngqv (l_rec_ngqv);
--
END build_gaz_qry_from_nqt;
--
-----------------------------------------------------------------------------
--
FUNCTION duplicate_nte (p_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                       ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
   l_retval   nm_nw_temp_extents.nte_job_id%TYPE;
BEGIN
--
   nm_debug.proc_start (g_package_name,'duplicate_nte');
--
   l_retval := nm3net.get_next_nte_id;
--
   INSERT INTO nm_nw_temp_extents
         (nte_job_id
         ,nte_ne_id_of
         ,nte_begin_mp
         ,nte_end_mp
         ,nte_cardinality
         ,nte_seq_no
         ,nte_route_ne_id
         )
   SELECT l_retval
         ,nte_ne_id_of
         ,nte_begin_mp
         ,nte_end_mp
         ,nte_cardinality
         ,nte_seq_no
         ,nte_route_ne_id
    FROM  nm_nw_temp_extents
   WHERE  nte_job_id = p_nte_job_id;
--
   nm_debug.proc_start (g_package_name,'duplicate_nte');
--
   RETURN l_retval;
--
END duplicate_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION get_temp_ne_subset_nqt (p_nqt_rowid  ROWID
                                ,p_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                                ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
--
   l_retval   nm_nw_temp_extents.nte_job_id%TYPE;
   l_rec_ngq  nm_gaz_query%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_temp_ne_subset_nqt');
--
   l_retval := duplicate_nte (p_nte_job_id);
--
   l_rec_ngq.ngq_id                         := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_source_id                  := l_retval;
   l_rec_ngq.ngq_source                     := nm3extent.c_temp_ne;
   l_rec_ngq.ngq_open_or_closed             := nm3gaz_qry.c_closed_query;
   l_rec_ngq.ngq_items_or_area              := nm3gaz_qry.c_area_query;
   l_rec_ngq.ngq_query_all_items            := 'N';
   l_rec_ngq.ngq_begin_mp                   := Null;
   l_rec_ngq.ngq_begin_datum_ne_id          := Null;
   l_rec_ngq.ngq_begin_datum_offset         := Null;
   l_rec_ngq.ngq_end_mp                     := Null;
   l_rec_ngq.ngq_end_datum_ne_id            := Null;
   l_rec_ngq.ngq_end_datum_offset           := Null;
   l_rec_ngq.ngq_ambig_sub_class            := Null;
   nm3ins.ins_ngq (l_rec_ngq);
--
   build_gaz_qry_from_nqt (p_nqt_rowid  => p_nqt_rowid
                          ,p_ngq_id     => l_rec_ngq.ngq_id
                          );
--
   l_retval := run_ngq (p_nqg_id         => l_rec_ngq.ngq_id
                       ,p_use_date_based => FALSE
                       );
--
--log_it(l_rec_nqt.nqt_inv_type||'-'||l_rec_nqt.nqt_x_sect);
--log_it('l_rec_ngq.ngq_id='||l_rec_ngq.ngq_id);
--log_it('p_nte_job_id='||p_nte_job_id);
--   DELETE FROM nm_gaz_query
--   WHERE ngq_id = l_rec_ngq.ngq_id;
   nm3del.del_ngq (pi_ngq_id => l_rec_ngq.ngq_id);
--
   nm_debug.proc_end (g_package_name,'get_temp_ne_subset_nqt');
--
--log_it('l_retval='||l_retval);
   RETURN l_retval;
--
END get_temp_ne_subset_nqt;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_inv_by_nte (p_inv_type       nm_inv_types.nit_inv_type%TYPE
                              ,p_nte_job_id     nm_nw_temp_Extents.nte_job_id%TYPE
                              ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                              ) IS
--
   CURSOR cs_items (c_job_id NUMBER) IS
   SELECT ngqi_item_id
         ,ROWID
    FROM  nm_gaz_query_item_list
   WHERE  ngqi_job_id = c_job_id;
--
   l_rec_ngq  nm_gaz_query%ROWTYPE;
   l_rec_ngqt nm_gaz_query_types%ROWTYPE;
   l_job      nm_nw_temp_extents.nte_job_id%TYPE;
--
   l_items_to_end_date nm3type.tab_number;
   l_ngqi_rowid        nm3type.tab_rowid;
BEGIN
--
   nm_debug.proc_start (g_package_name,'end_date_inv_by_nte');
--
   l_rec_ngq.ngq_id                         := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_source_id                  := duplicate_nte (p_nte_job_id);
   l_rec_ngq.ngq_source                     := nm3extent.c_temp_ne;
   l_rec_ngq.ngq_open_or_closed             := nm3gaz_qry.c_closed_query;
   l_rec_ngq.ngq_items_or_area              := nm3gaz_qry.c_items_query;
   l_rec_ngq.ngq_query_all_items            := 'N';
   l_rec_ngq.ngq_begin_mp                   := Null;
   l_rec_ngq.ngq_begin_datum_ne_id          := Null;
   l_rec_ngq.ngq_begin_datum_offset         := Null;
   l_rec_ngq.ngq_end_mp                     := Null;
   l_rec_ngq.ngq_end_datum_ne_id            := Null;
   l_rec_ngq.ngq_end_datum_offset           := Null;
   l_rec_ngq.ngq_ambig_sub_class            := Null;
   nm3ins.ins_ngq (l_rec_ngq);
--
   l_rec_ngqt.ngqt_ngq_id                   := l_rec_ngq.ngq_id;
   l_rec_ngqt.ngqt_seq_no                   := 1;
   l_rec_ngqt.ngqt_item_type_type           := nm3gaz_qry.c_ngqt_item_type_type_inv;
   l_rec_ngqt.ngqt_item_type                := p_inv_type;
   nm3ins.ins_ngqt (l_rec_ngqt);
--
   l_job := run_ngq (p_nqg_id         => l_rec_ngq.ngq_id
                    ,p_effective_date => p_effective_date
                    );
--
   IF l_job IS NOT NULL
    THEN
      OPEN  cs_items (l_job);
      FETCH cs_items
       BULK COLLECT
       INTO l_items_to_end_date
           ,l_ngqi_rowid;
      CLOSE cs_items;
   --
      FOR i IN 1..l_items_to_end_date.COUNT
       LOOP
         DECLARE
            l_warning_code nm3type.max_varchar2;
            l_warning_msg  nm3type.max_varchar2;
         BEGIN
            nm3homo.end_inv_location_by_temp_ne
                       (pi_iit_ne_id      => l_items_to_end_date(i)
                       ,pi_nte_job_id     => l_rec_ngq.ngq_source_id
                       ,pi_effective_date => p_effective_date
                       ,po_warning_code   => l_warning_code
                       ,po_warning_msg    => l_warning_msg
                       );
         END;
      END LOOP;
   --
      IF NOT g_maintain_history
       THEN
         FORALL i IN 1..l_items_to_end_date.COUNT
            DELETE nm_members_all
            WHERE  nm_ne_id_in = l_items_to_end_date(i)
             AND NOT (nm_end_date IS NULL
                      OR nm_end_date > p_effective_date
                     );
         FORALL i IN 1..l_items_to_end_date.COUNT
            DELETE nm_inv_items_all
            WHERE  iit_ne_id = l_items_to_end_date(i)
             AND NOT EXISTS (SELECT 1
                              FROM  nm_members_all
                             WHERE  nm_ne_id_in = iit_ne_id
                            );
      END IF;
   --
      FORALL i IN 1..l_ngqi_rowid.COUNT
         DELETE FROM nm_gaz_query_item_list
         WHERE  ROWID = l_ngqi_rowid(i);
   END IF;
--
   nm3del.del_ngq (pi_ngq_id => l_rec_ngq.ngq_id);
--
   nm_debug.proc_end (g_package_name,'end_date_inv_by_nte');
--
END end_date_inv_by_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inv_for_temp_ne (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                 ,p_nte_job_id        nm_nw_temp_extents.nte_job_id%TYPE
                                 ,p_effective_date    DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                 ) IS
--
   l_rec_nmnd          nm_mrg_nit_derivation%ROWTYPE;
   c_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_mrg_job_id        nm_mrg_query_results.nqr_mrg_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inv_for_temp_ne');
--
   nm3user.set_effective_date (p_effective_date);
   l_rec_nmnd := get_nmnd (pi_nmnd_nit_inv_type => p_nmnd_nit_inv_type);
--
   IF nm3extent.g_last_temp_extent_source_id IS NULL
    THEN
      nm3extent.g_last_temp_extent_source_id := -1;
      nm3extent.g_last_temp_extent_source    := nm3extent.c_temp_ne;
   END IF;
--
   end_date_inv_by_nte (p_inv_type       => p_nmnd_nit_inv_type
                       ,p_nte_job_id     => p_nte_job_id
                       ,p_effective_date => p_effective_date
                       );
--
   nm3mrg.execute_mrg_query (pi_query_id       => l_rec_nmnd.nmnd_nmq_id
                            ,pi_nte_job_id     => p_nte_job_id
                            ,pi_description    => 'Transient Query run for NTE : '||p_nte_job_id
                            ,po_result_job_id  => l_mrg_job_id
                            );
--
   create_inv_from_mrg_results (p_nmnd_nit_inv_type => p_nmnd_nit_inv_type
                               ,p_nqr_mrg_job_id    => l_mrg_job_id
                               );
--
   nm3mrg.delete_query_results (l_mrg_job_id);
--
   nm3user.set_effective_date (c_eff_date);
--
   nm_debug.proc_end (g_package_name,'create_inv_for_temp_ne');
--
END create_inv_for_temp_ne;
--
-----------------------------------------------------------------------------
--
PROCEDURE nmid_b_iu_stm_trg IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'nmid_b_iu_stm_trg');
--
   g_tab_inv_type_to_validate.DELETE;
--
   nm_debug.proc_end (g_package_name,'nmid_b_iu_stm_trg');
--
END nmid_b_iu_stm_trg;
--
-----------------------------------------------------------------------------
--
PROCEDURE nmid_b_iu_row_trg (p_rec_nmid nm_mrg_ita_derivation%ROWTYPE) IS
   l_found BOOLEAN := FALSE;
BEGIN
--
   nm_debug.proc_start (g_package_name,'nmid_b_iu_row_trg');
--
   FOR i IN 1..g_tab_inv_type_to_validate.COUNT
    LOOP
      l_found := g_tab_inv_type_to_validate(i) = p_rec_nmid.nmid_ita_inv_type;
      EXIT WHEN l_found;
   END LOOP;
   IF NOT l_found
    THEN
      g_tab_inv_type_to_validate(g_tab_inv_type_to_validate.COUNT+1) := p_rec_nmid.nmid_ita_inv_type;
   END IF;
--
   nm_debug.proc_end (g_package_name,'nmid_b_iu_row_trg');
--
END nmid_b_iu_row_trg;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_au_derivation (pi_nmid_ita_inv_type nm_mrg_ita_derivation.nmid_ita_inv_type%TYPE
                              ,pi_nmid_derivation   nm_mrg_ita_derivation.nmid_derivation%TYPE
                              ) IS
--
   c_mrg_dot      CONSTANT VARCHAR2(40) := UPPER(g_mrg_record_name||'.');
   c_mrg_dot_len  CONSTANT PLS_INTEGER  := LENGTH(c_mrg_dot);
   l_derivation   nm_mrg_ita_derivation.nmid_derivation%TYPE := UPPER(pi_nmid_derivation);
   l_deriv_ok     BOOLEAN := FALSE;
   l_inv_type     VARCHAR2(4);
   l_rec_nit_dest nm_inv_types%ROWTYPE;
   l_rec_nit_src  nm_inv_types%ROWTYPE;
   l_rec_nau      nm_admin_units%ROWTYPE;
   l_dummy        nm3type.max_varchar2;
   l_cur          nm3type.ref_cursor;
--
BEGIN
--
   l_rec_nit_dest := nm3get.get_nit (pi_nit_inv_type => pi_nmid_ita_inv_type);
   g_ok_to_turn_off_au_security := TRUE;
   IF nm3flx.can_string_be_select_from_dual (l_derivation)
    THEN
      g_ok_to_turn_off_au_security := FALSE;
      l_deriv_ok                   := TRUE;
      OPEN  l_cur FOR 'SELECT '||l_derivation||' FROM DUAL';
      FETCH l_cur
       INTO l_dummy;
      CLOSE l_cur;
      l_rec_nau := nm3get.get_nau_all (pi_nau_admin_unit  => l_dummy
                                      ,pi_raise_not_found => FALSE
                                      );
      IF l_rec_nau.nau_admin_unit IS NULL
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 406
                       ,pi_supplementary_info => l_derivation
                       );
      ELSIF l_rec_nau.nau_admin_type != l_rec_nit_dest.nit_admin_type
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 407
                       ,pi_supplementary_info => l_derivation
                       );
      END IF;
   ELSIF SUBSTR(l_derivation,1,c_mrg_dot_len) != c_mrg_dot
    THEN
      l_deriv_ok := FALSE;
   ELSIF SUBSTR(l_derivation,-11) != '_ADMIN_UNIT'
    THEN
      l_deriv_ok := FALSE;
   ELSE
      l_inv_type := SUBSTR(l_derivation,5,4);
      IF INSTR(l_inv_type,'_') != 0
       THEN
         l_inv_type := SUBSTR(l_inv_type,1,INSTR(l_inv_type,'_')-1);
      END IF;
      l_rec_nit_src  := nm3get.get_nit (pi_nit_inv_type => l_inv_type);
      IF l_rec_nit_dest.nit_admin_type != l_rec_nit_src.nit_admin_type
       THEN
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 404
                       ,pi_supplementary_info => pi_nmid_derivation
                       );
      ELSE
         l_deriv_ok := TRUE;
      END IF;
   END IF;
--
   IF NOT l_deriv_ok
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 405
                    ,pi_supplementary_info => pi_nmid_derivation
                    );
   END IF;
--
END check_au_derivation;
--
-----------------------------------------------------------------------------
--
PROCEDURE nmid_a_iu_stm_trg IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'nmid_a_iu_stm_trg');
--
   FOR i IN 1..g_tab_inv_type_to_validate.COUNT
    LOOP
      validate_nmnd (p_nmnd_nit_inv_type     => g_tab_inv_type_to_validate(i)
                    ,p_check_all_mand_fields => FALSE -- do not check at this stage
                    );
   END LOOP;
--
   g_tab_inv_type_to_validate.DELETE;
--
   nm_debug.proc_end (g_package_name,'nmid_a_iu_stm_trg');
--
END nmid_a_iu_stm_trg;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mrg_record_name RETURN VARCHAR2 IS
BEGIN
   RETURN g_mrg_record_name;
END get_mrg_record_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_record_name RETURN VARCHAR2 IS
BEGIN
   RETURN g_inv_record_name;
END get_inv_record_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_no_refresh_running (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE) IS
--
   CURSOR cs_chk (c_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE) IS
   SELECT nmndr_refresh_start_date
    FROM  nm_mrg_nit_derivation_refresh
   WHERE  nmndr_nmnd_nit_inv_type   = c_nmnd_nit_inv_type
    AND   nmndr_refresh_finish_date IS NULL;
--
   l_found    BOOLEAN;
   l_date     DATE;
   l_rec_nmnd nm_mrg_nit_derivation%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_end (g_package_name,'check_no_refresh_running');
--
   l_rec_nmnd := get_nmnd (p_nmnd_nit_inv_type);
--
   OPEN  cs_chk (p_nmnd_nit_inv_type);
   FETCH cs_chk
    INTO l_date;
   l_found := cs_chk%FOUND;
   CLOSE cs_chk;
--
   IF l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 408
                    ,pi_supplementary_info => p_nmnd_nit_inv_type||' started '||to_char(l_date,nm3type.c_full_date_Time_format)
                    );
   END IF;
--
   IF NOT nmq_is_only_ft_inv (l_rec_nmnd.nmnd_nmq_id)
    THEN
      check_no_iit_locks;
   END IF;
--
   nm_debug.proc_start (g_package_name,'check_no_refresh_running');
--
END check_no_refresh_running;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_nmnd (p_nmnd_nit_inv_type  nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                       ,p_effective_date     DATE    DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                       ,p_force_full_refresh BOOLEAN DEFAULT FALSE
                       ) IS
--
   l_tab_nt_type          nm3type.tab_varchar4;
   c_sysdate     CONSTANT DATE := SYSDATE;
   l_rec_nmnd             nm_mrg_nit_derivation%ROWTYPE;
   l_nte                  NUMBER;
   l_tab_ne_id            nm3type.tab_number;
   l_tab_ne_unique        nm3type.tab_varchar30;
   l_nt_type_nte          nm_nw_temp_extents.nte_job_id%TYPE;
   l_nmndr_rowid          ROWID;
   l_refresh              BOOLEAN;
   l_ft_only              BOOLEAN;
   l_tab_mail_text_detail nm3type.tab_varchar32767;
--
   c_mail_title           VARCHAR2(80);
--
   l_tab_to  nm3mail.tab_recipient;
   l_tab_cc  nm3mail.tab_recipient;
   l_tab_bcc nm3mail.tab_recipient;
--
   PROCEDURE append (p_text VARCHAR2) IS
   BEGIN
      IF p_text IS NOT NULL
       THEN
         g_tab_mail_text(g_tab_mail_text.COUNT+1) := p_text;
      END IF;
   END append;
   PROCEDURE append_detail (p_text VARCHAR2) IS
   BEGIN
      IF p_text IS NOT NULL
       THEN
         l_tab_mail_text_detail(l_tab_mail_text_detail.COUNT+1) := p_text;
      END IF;
   END append_detail;
   PROCEDURE append_pair (p_header VARCHAR2,p_data VARCHAR2) IS
   BEGIN
      append (htf.tablerowopen);
      append (htf.tableheader (p_header));
      append (htf.tabledata (p_data));
      append (htf.tablerowclose);
   END append_pair;
--
   PROCEDURE create_nmndr IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      DELETE nm_mrg_nit_derivation_refresh
      WHERE  nmndr_nmnd_nit_inv_type   =  p_nmnd_nit_inv_type
       AND   nmndr_refresh_finish_date IS NULL;
      INSERT INTO nm_mrg_nit_derivation_refresh
             (nmndr_nmnd_nit_inv_type
             ,nmndr_refresh_start_date
             ,nmndr_refresh_finish_date
             )
      VALUES (p_nmnd_nit_inv_type
             ,c_sysdate
             ,Null
             )
      RETURNING ROWID INTO l_nmndr_rowid;
      COMMIT;
   END create_nmndr;
--
   PROCEDURE send_mail (p_title_suffix VARCHAR2 DEFAULT NULL) IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      l_tab_text nm3type.tab_varchar32767 := g_tab_mail_text;
   BEGIN
      append (htf.tableclose);
      --
      IF g_error_count > 0
       THEN
         append (htf.tableopen (cattributes=>'BORDER=1'));
         append (htf.tablerowopen);
         append (htf.tableheader('Exception'));
         append (htf.tableheader('Item'));
         append (htf.tableheader('Location'));
         append (htf.tablerowclose);
         FOR i IN 1..g_error_count
          LOOP
            append (htf.tablerowopen);
            append ('<TD>');
            IF g_tab_error_errm.EXISTS(i)
             THEN
               append (g_tab_error_errm(i));
            ELSE
               append (nm3web.c_nbsp);
            END IF;
            append ('</TD>');
            append ('<TD>');
            IF g_tab_error_item.EXISTS(i)
             THEN
               append (g_tab_error_item(i));
            ELSE
               append (nm3web.c_nbsp);
            END IF;
            append ('</TD>');
            append ('<TD>');
            IF g_tab_error_locn.EXISTS(i)
             THEN
               append (g_tab_error_locn(i));
            ELSE
               append (nm3web.c_nbsp);
            END IF;
            append ('</TD>');
            append (htf.tablerowclose);
         END LOOP;
         append (htf.tableclose);
      END IF;
      --
      append (htf.bodyclose);
      append (htf.htmlclose);
      nm3mail.write_mail_complete
                (p_from_user        => l_tab_to(1).rcpt_id
                ,p_subject          => c_mail_title||nm3flx.i_t_e (p_title_suffix IS NULL,Null,' '||p_title_suffix)
                ,p_html_mail        => TRUE
                ,p_tab_to           => l_tab_to
                ,p_tab_cc           => l_tab_cc
                ,p_tab_bcc          => l_tab_bcc
                ,p_tab_message_text => g_tab_mail_text
                );
      g_tab_mail_text := l_tab_text;
      COMMIT;
   END send_mail;
--
   PROCEDURE delete_nmndr IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      DELETE FROM nm_mrg_nit_derivation_refresh
      WHERE  ROWID = l_nmndr_rowid;
      COMMIT;
   END delete_nmndr;
--
BEGIN

  -- call new merge code if not flagged to old - RAC  changed default to call old when no option available
  if nvl(hig.get_sysopt('INVCOMP32'), 'Y') != 'Y' then
    nm3inv_composite2.call_rebuild(
       p_dbms_job_no  => null
      ,p_inv_type     => p_nmnd_nit_inv_type
      ,p_effective_date => p_effective_date
    );


  -- call old code as flagged
  else

   nm_debug.proc_start (g_package_name,'refresh_nmnd');
--
   nm3user.set_effective_date (p_effective_date);
--
-- RAC - move call to get_nmnd to allow reference to it.
--
   l_rec_nmnd := get_nmnd (pi_nmnd_nit_inv_type => p_nmnd_nit_inv_type);

   l_ft_only := nmq_is_only_ft_inv (l_rec_nmnd.nmnd_nmq_id);
--
   l_refresh := l_rec_nmnd.nmnd_last_refresh_date > c_bonfire_night -- If never been refreshed
                AND NOT l_ft_only                                   -- or merge is purely foreign table inv
                AND NOT p_force_full_refresh;                       -- or we are forcing a full refresh
--
   c_mail_title := p_nmnd_nit_inv_type||' '||nm3flx.i_t_e (l_refresh,'refresh','rebuild');
--
   g_tab_mail_text.DELETE;
   g_tab_error_item.DELETE;
   g_tab_error_locn.DELETE;
   g_tab_error_errm.DELETE;
--   g_tab_done_item.DELETE;
--   g_tab_done_locn.DELETE;
--
   g_inv_count   := 0;
   g_error_count := 0;
--
   append (htf.htmlopen);
   append (htf.headopen);
   append (htf.title (c_mail_title));
   append (get_static_css_link_text);
   append (htf.headclose);
   append (htf.bodyopen);
   append (htf.tableopen (cattributes=>'BORDER=1'));
   append_pair ('Inv Type',p_nmnd_nit_inv_type);
   append_pair ('Effective Date',TO_CHAR(To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'),Sys_Context('NM3CORE','USER_DATE_MASK')));
   append_pair ('Start Time',TO_CHAR(SYSDATE,nm3type.c_full_Date_time_Format));
--
   l_rec_nmnd := get_nmnd (pi_nmnd_nit_inv_type => p_nmnd_nit_inv_type);
--
   g_maintain_history := l_rec_nmnd.nmnd_maintain_history = 'Y';
--
   nm3lock_gen.lock_nit (pi_nit_inv_type => p_nmnd_nit_inv_type);
--
   l_tab_to(1).rcpt_id   := l_rec_nmnd.nmnd_nmu_id_admin;
   l_tab_to(1).rcpt_type := nm3mail.c_user;
   l_tab_cc(1)           := l_tab_to(1);
   l_tab_cc(1).rcpt_id   := get_nmu_id_for_hig_owner;
   IF l_tab_cc(1).rcpt_id = l_tab_to(1).rcpt_id
    THEN
      l_tab_cc.DELETE;
   END IF;
--
   IF NOT l_ft_only
    THEN
      check_no_iit_locks;
   END IF;
   create_nmndr;
--
   send_mail ('underway');
--
   SELECT nmndn_nt_type
    BULK  COLLECT
    INTO  l_tab_nt_type
    FROM  nm_mrg_nit_derivation_nw
   WHERE  nmndn_nmnd_nit_inv_type = p_nmnd_nit_inv_type;
--
   g_nmnd_nit_inv_type := nm3type.c_nvl;
   g_last_update_date  := l_rec_nmnd.nmnd_last_refresh_date;
--
   FOR i IN 1..l_tab_nt_type.COUNT
    LOOP
      IF l_refresh
       THEN
         log_it('pre get_all_elements_by_nt');
         get_all_elements_by_nt (pi_nt_type       => l_tab_nt_type(i)
                                ,po_tab_ne_id     => l_tab_ne_id
                                ,po_tab_ne_unique => l_tab_ne_unique
                                );
         log_it('pre create_tmp_ne_for_items_in_arr');
         DECLARE
            l_tab_ngqi_item_type_type nm3type.tab_varchar4;
            l_tab_ngqi_item_type      nm3type.tab_varchar4;
         BEGIN
            FOR q IN 1..l_tab_ne_id.COUNT
             LOOP
               l_tab_ngqi_item_type_type(q) := nm3gaz_qry.c_ngqt_item_type_type_ele;
               l_tab_ngqi_item_type(q)      := l_tab_nt_type(i);
            END LOOP;
            l_nt_type_nte := create_tmp_ne_for_items_in_arr
                                    (pi_tab_item_id        => l_tab_ne_id
                                    ,pi_tab_item_type_type => l_tab_ngqi_item_type_type
                                    ,pi_tab_item_type      => l_tab_ngqi_item_type
                                    );
         END;
         log_it('pre get_changed_assets_since_last');
         l_nte := get_changed_assets_since_last (p_nmnd_nmq_id    => l_rec_nmnd.nmnd_nmq_id
                                                ,p_nte_job_id     => l_nt_type_nte
                                                ,p_effective_date => p_effective_date
                                                );
         log_it('pre create_inv_for_temp_ne');
--       nm3extent.DEBUG_TEMP_EXTENTS(l_nte);
         create_inv_for_temp_ne (p_nmnd_nit_inv_type => l_rec_nmnd.nmnd_nit_inv_type
                                ,p_nte_job_id        => l_nte
                                ,p_effective_date    => p_effective_date
                                );
      ELSE
         create_inv_for_nt_type (p_nmnd_nit_inv_type => p_nmnd_nit_inv_type
                                ,p_nt_type           => l_tab_nt_type(i)
                                ,p_effective_date    => p_effective_date
                                );
      END IF;
   END LOOP;
   append_pair ('Finish Time',TO_CHAR(SYSDATE,nm3type.c_full_Date_time_format));
   append_pair ('Items Created',g_inv_count);
   IF g_error_count > 0
    THEN
      append_pair ('Item Exception Count',g_error_count);
   END IF;
--
   send_mail ('complete');
--
   UPDATE nm_mrg_nit_derivation
    SET   nmnd_last_refresh_date = c_sysdate
   WHERE  nmnd_nit_inv_type      = p_nmnd_nit_inv_type;
--
   IF NOT l_refresh -- i.e. we've rebuilt it
    THEN
      UPDATE nm_mrg_nit_derivation
       SET   nmnd_last_rebuild_date = c_sysdate
      WHERE  nmnd_nit_inv_type      = p_nmnd_nit_inv_type;
   END IF;
--
   UPDATE nm_mrg_nit_derivation_refresh
    SET   nmndr_refresh_finish_date = SYSDATE
   WHERE  ROWID                     = l_nmndr_rowid;
--
--   IF g_inv_count > 0
--    THEN
--      l_tab_mail_text_detail.DELETE;
--      append_detail(htf.htmlopen);
--      append_detail(htf.headopen);
--      append_detail(get_static_css_link_text);
--      append_detail(htf.headclose);
--      append_detail(htf.bodyopen);
--      append_detail(htf.tableopen(cattributes=>'BORDER=1'));
--      FOR i iN 1..g_inv_count
--       LOOP
--         append_detail (htf.tablerowopen);
--         append_detail ('<TD>');
--         append_detail (g_tab_done_item(i));
--         append_detail ('</TD>');
--         append_detail ('<TD>');
--         append_detail (g_tab_done_locn(i));
--         append_detail ('</TD>');
--         append_detail (htf.tablerowclose);
--      END LOOP;
--      append_detail(htf.tableclose);
--      append_detail(htf.bodyclose);
--      append_detail(htf.htmlclose);
--      nm3mail.write_mail_complete
--                (p_from_user        => l_tab_to(1).rcpt_id
--                ,p_subject          => c_mail_title||' detail'
--                ,p_html_mail        => TRUE
--                ,p_tab_to           => l_tab_to
--                ,p_tab_cc           => l_tab_cc
--                ,p_tab_bcc          => l_tab_bcc
--                ,p_tab_message_text => g_tab_mail_text
--                );
--   END IF;
--
   COMMIT;
--
   nm_debug.proc_end (g_package_name,'refresh_nmnd');
--

  end if; --if nvl(hig.get_sysopt('INVCOMP32'), 'N') != 'Y'

EXCEPTION
   WHEN others
    THEN
      append_pair ('Exception',nm3flx.parse_error_message(SQLERRM));
      send_mail ('exception');
      delete_nmndr;
--      RAISE;
END refresh_nmnd;
--
-----------------------------------------------------------------------------
--
FUNCTION get_changed_assets_since_last (p_nmnd_nmq_id    nm_mrg_nit_derivation.nmnd_nmq_id%TYPE
                                       ,p_nte_job_id     nm_nw_temp_extents.nte_job_id%TYPE
                                       ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                       ) RETURN nm_nw_temp_extents.nte_job_id%TYPE IS
--
   l_retval nm_nw_temp_extents.nte_job_id%TYPE;
   c_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_tab_nqt_seq_no   nm3type.tab_number;
   l_tab_nqt_rowid    nm3type.tab_rowid;
   l_tab_nte_job_id   nm3type.tab_number;
   l_tab_nqt_inv_type nm3type.tab_varchar4;
   l_nte_job_id_tmp   nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_changed_assets_since_last');
--
   nm3user.set_effective_date (p_effective_date);
--
   SELECT nqt_seq_no
         ,ROWID
         ,nqt_inv_type
    BULK  COLLECT
    INTO  l_tab_nqt_seq_no
         ,l_tab_nqt_rowid
         ,l_tab_nqt_inv_type
    FROM  nm_mrg_query_types
   WHERE  nqt_nmq_id = p_nmnd_nmq_id;
--
   FOR i IN 1..l_tab_nqt_seq_no.COUNT
    LOOP
      l_nte_job_id_tmp    := Null;
--      log_it('get_changed_asset_area  (p_nqt_rowid  => ');
      IF nm3get.get_nit (pi_nit_inv_type => l_tab_nqt_inv_type(i)).nit_table_name IS NULL
       THEN -- don't do this for FT inventory types in the query - they are only updated on a full rebuild
         l_nte_job_id_tmp    := get_changed_asset_area  (p_nqt_rowid  => l_tab_nqt_rowid(i));
         IF l_nte_job_id_tmp IS NOT NULL
          THEN
            l_tab_nte_job_id(l_tab_nte_job_id.COUNT+1) := l_nte_job_id_tmp;
         END IF;
      END IF;
   END LOOP;
--
   log_it('Before get_union_of_nte');
   l_retval := get_union_of_nte (p_nte_job_id_parent     => p_nte_job_id
                                ,p_tab_nte_job_id_subset => l_tab_nte_job_id
                                );
   log_it('After get_union_of_nte');
--
   nm3user.set_effective_date (c_eff_date);
--
   nm_debug.proc_end (g_package_name,'get_changed_assets_since_last');
--
   RETURN l_retval;
--
EXCEPTION
   WHEN others
    THEN
      nm3user.set_effective_date (c_eff_date);
      RAISE;
END get_changed_assets_since_last;
--
-----------------------------------------------------------------------------
--
FUNCTION get_changed_asset_area (p_nqt_rowid ROWID) RETURN NUMBER IS
   l_retval       NUMBER := Null;
   l_ngqi_job_id  NUMBER;
   l_rec_ngq nm_gaz_query%ROWTYPE;
   l_tab_ngqi_item_id        nm3type.tab_number;
   l_tab_ngqi_item_type_type nm3type.tab_varchar4;
   l_tab_ngqi_item_type      nm3type.tab_varchar4;
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_changed_asset_area');
--
   l_rec_ngq.ngq_id                         := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_source_id                  := -1;
   l_rec_ngq.ngq_source                     := nm3extent.c_temp_ne;
   l_rec_ngq.ngq_open_or_closed             := nm3gaz_qry.c_closed_query;
   l_rec_ngq.ngq_items_or_area              := nm3gaz_qry.c_items_query;
   l_rec_ngq.ngq_query_all_items            := 'Y';
   l_rec_ngq.ngq_begin_mp                   := Null;
   l_rec_ngq.ngq_begin_datum_ne_id          := Null;
   l_rec_ngq.ngq_begin_datum_offset         := Null;
   l_rec_ngq.ngq_end_mp                     := Null;
   l_rec_ngq.ngq_end_datum_ne_id            := Null;
   l_rec_ngq.ngq_end_datum_offset           := Null;
   l_rec_ngq.ngq_ambig_sub_class            := Null;
   nm3ins.ins_ngq (l_rec_ngq);
--
   build_gaz_qry_from_nqt (p_nqt_rowid  => p_nqt_rowid
                          ,p_ngq_id     => l_rec_ngq.ngq_id
                          );
--
   l_ngqi_job_id := run_ngq (p_nqg_id         => l_rec_ngq.ngq_id
                            ,p_use_date_based => FALSE
                            );
--
   IF l_ngqi_job_id IS NOT NULL
    THEN
      SELECT ngqi_item_id
            ,ngqi_item_type_type
            ,ngqi_item_type
       BULK  COLLECT
       INTO  l_tab_ngqi_item_id
            ,l_tab_ngqi_item_type_type
            ,l_tab_ngqi_item_type
       FROM  nm_gaz_query_item_list
      WHERE  ngqi_job_id = l_ngqi_job_id;
      DELETE
       FROM  nm_gaz_query_item_list
      WHERE  ngqi_job_id = l_ngqi_job_id;
      l_retval := create_tmp_ne_for_items_in_arr (pi_tab_item_id        => l_tab_ngqi_item_id
                                                 ,pi_tab_item_type_type => l_tab_ngqi_item_type_type
                                                 ,pi_tab_item_type      => l_tab_ngqi_item_type
                                                 );
   END IF;
--
   nm3del.del_ngq (pi_ngq_id => l_rec_ngq.ngq_id);
--
   nm_debug.proc_end (g_package_name,'get_changed_asset_area');
--
   RETURN l_retval;
--
END get_changed_asset_area;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_arr (p_text      nm3type.tab_varchar32767
                  ,p_append    BOOLEAN DEFAULT TRUE
                  ,p_timestamp BOOLEAN DEFAULT TRUE
                  ) IS
BEGIN
   log_it (p_text      => Null
          ,p_append    => p_append
          ,p_timestamp => p_timestamp
          );
   FOR i IN 1..p_text.COUNT
    LOOP
      log_it (p_text      => p_text(i)
             ,p_append    => TRUE
             ,p_timestamp => FALSE
             );
   END LOOP;
END log_arr;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_it (p_text      VARCHAR2
                 ,p_append    BOOLEAN DEFAULT TRUE
                 ,p_timestamp BOOLEAN DEFAULT TRUE
                 ) IS
--   c_file CONSTANT VARCHAR2(34)               := g_package_name||'.log';
--   c_dir  CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt('UTLFILEDIR');
BEGIN
   IF p_append
    THEN
      Null;
--      xmrwa_log.open_append_and_close
--                 (pi_filename           => c_file
--                 ,pi_location           => c_dir
--                 ,pi_include_timestamp  => p_timestamp
--                 ,pi_text               => p_text
--                 );
   ELSE
      Null;
--      xmrwa_log.open_write_and_close
--                 (pi_filename           => c_file
--                 ,pi_location           => c_dir
--                 ,pi_include_timestamp  => p_timestamp
--                 ,pi_text               => p_text
--                 );
   END IF;
END log_it;
--
-----------------------------------------------------------------------------
--
FUNCTION get_bonfire_night RETURN DATE IS
BEGIN
   RETURN c_bonfire_night;
END get_bonfire_night;
--
-----------------------------------------------------------------------------
--
FUNCTION get_not_null (pi_ita_mandatory_yn VARCHAR2
                      ,pi_atc_nullable     VARCHAR2
                      ,pi_column_name      VARCHAR2
                      ,pi_nit_x_sect_allow VARCHAR2
                      ) RETURN VARCHAR2 IS
   c_not_null CONSTANT VARCHAR2(8) := 'NOT NULL';
   l_bool   BOOLEAN;
BEGIN
   IF pi_ita_mandatory_yn IS NOT NULL
    THEN
      l_bool := pi_ita_mandatory_yn='Y';
   ELSE
      IF   pi_column_name = 'IIT_X_SECT'
       THEN
         l_bool := pi_nit_x_sect_allow = 'Y';
      ELSE
         l_bool := pi_atc_nullable = 'N';
      END IF;
   END IF;
   RETURN nm3flx.i_t_e (l_bool,c_not_null,Null);
END get_not_null;
--
-----------------------------------------------------------------------------
--
FUNCTION allowable_inv_column (p_column VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN nm3flx.boolean_to_char(NOT p_column IN ('IIT_CREATED_BY'
                                                 ,'IIT_DATE_CREATED'
                                                 ,'IIT_DATE_MODIFIED'
                                                 ,'IIT_INV_TYPE'
                                                 ,'IIT_MODIFIED_BY'
                                                 ,'IIT_NE_ID'
                                                 ,'IIT_PRIMARY_KEY'
                                                 ,'IIT_FOREIGN_KEY'
                                                 ,'IIT_START_DATE'
                                                 )
                                );
END allowable_inv_column;
--
-----------------------------------------------------------------------------
--
FUNCTION get_composite_nic_category RETURN nm_inv_categories.nic_category%TYPE IS
BEGIN
   RETURN c_composite_nic_category;
END get_composite_nic_category;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_pending_nmnd (p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                               ) IS
--
   CURSOR cs_nmnd_rebuild IS
   SELECT nmnd_nit_inv_type
    FROM  nm_mrg_nit_derivation
   WHERE  (nmnd_last_rebuild_date + nmnd_rebuild_interval_days) < SYSDATE
    AND   NOT EXISTS (SELECT 1
                       FROM  nm_mrg_nit_derivation_refresh
                      WHERE  nmndr_nmnd_nit_inv_type   = nmnd_nit_inv_type
                       AND   nmndr_refresh_finish_date IS NULL
                     );
--
   CURSOR cs_nmnd_refresh IS
   SELECT nmnd_nit_inv_type
    FROM  nm_mrg_nit_derivation
   WHERE  (nmnd_last_refresh_date + nmnd_refresh_interval_days) <  SYSDATE
    AND   (nmnd_last_rebuild_date + nmnd_rebuild_interval_days) >= SYSDATE
    AND   NOT EXISTS (SELECT 1
                       FROM  nm_mrg_nit_derivation_refresh
                      WHERE  nmndr_nmnd_nit_inv_type   = nmnd_nit_inv_type
                       AND   nmndr_refresh_finish_date IS NULL
                     );
--
   l_tab_nit nm3type.tab_varchar4;
--
   l_block         nm3type.max_varchar2;
   l_job           BINARY_INTEGER;
   c_mask CONSTANT VARCHAR2(30) := 'DD/MM/YYYY';
   l_some_to_do    BOOLEAN := FALSE;
--
   PROCEDURE do_nit_arr (p_rebuild BOOLEAN) IS
   BEGIN
      FOR i IN 1..l_tab_nit.COUNT
       LOOP
         l_some_to_do := TRUE;
         l_block := l_block
                 ||CHR(10)||'  do_it ('||nm3flx.string(l_tab_nit(i))||','||nm3flx.boolean_to_char(p_rebuild)||');';
      END LOOP;
   END do_nit_arr;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'refresh_pending_nmnd');
--
   l_block :=            '-- rebuild/refresh all pending composite'
              ||CHR(10)||'DECLARE'
              ||CHR(10)||'  c_eff_date CONSTANT DATE := TO_DATE('||nm3flx.string(TO_CHAR(p_effective_date,c_mask))||','||nm3flx.string(c_mask)||');'
              ||CHR(10)||'  PROCEDURE do_it (pi_inv_type VARCHAR2, p_rebuild BOOLEAN) IS'
              ||CHR(10)||'  BEGIN'
              ||CHR(10)||'    '||g_package_name||'.refresh_nmnd'
              ||CHR(10)||'       (p_nmnd_nit_inv_type  => pi_inv_type'
              ||CHR(10)||'       ,p_effective_date     => c_eff_date'
              ||CHR(10)||'       ,p_force_full_refresh => p_rebuild'
              ||CHR(10)||'       );'
              ||CHR(10)||'  END do_it;'
              ||CHR(10)||'BEGIN';
--
   OPEN  cs_nmnd_rebuild;
   FETCH cs_nmnd_rebuild
    BULK COLLECT
    INTO l_tab_nit;
   CLOSE cs_nmnd_rebuild;
--
   do_nit_arr (TRUE);
--
   OPEN  cs_nmnd_refresh;
   FETCH cs_nmnd_refresh
    BULK COLLECT
    INTO l_tab_nit;
   CLOSE cs_nmnd_refresh;
--
   do_nit_arr (FALSE);
--
   l_block := l_block
              ||CHR(10)||'END;';
   IF l_some_to_do
    THEN
      create_dbms_job (pi_what              => l_block
                      ,pi_when              => SYSDATE
                      ,pi_next              => Null
                      ,pi_allow_duplicate   => FALSE
                      ,pi_commit_autonomous => TRUE
                      );
   END IF;
--
   nm_debug.proc_end (g_package_name,'refresh_pending_nmnd');
--
END refresh_pending_nmnd;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_nmnd_as_job (p_nmnd_nit_inv_type  nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                              ,p_effective_date     DATE    DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                              ,p_force_full_refresh BOOLEAN DEFAULT FALSE
                              ) IS
   l_block         nm3type.max_varchar2;
   l_job           BINARY_INTEGER;
   c_mask CONSTANT VARCHAR2(30) := 'DD/MM/YYYY';
BEGIN
--
   nm_debug.proc_start (g_package_name,'refresh_nmnd_as_job');
--
   l_block :=            '-- '||p_nmnd_nit_inv_type||' refresh'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||'   '||g_package_name||'.refresh_nmnd'
              ||CHR(10)||'                 (p_nmnd_nit_inv_type  => '||nm3flx.string(p_nmnd_nit_inv_type)
              ||CHR(10)||'                 ,p_effective_date     => TO_DATE('||nm3flx.string(TO_CHAR(p_effective_date,c_mask))||','||nm3flx.string(c_mask)||')'
              ||CHR(10)||'                 ,p_force_full_refresh => '||nm3flx.boolean_to_char(p_force_full_refresh)
              ||CHR(10)||'                 );'
              ||CHR(10)||'END;';
--
   create_dbms_job (pi_what              => l_block
                   ,pi_when              => SYSDATE
                   ,pi_next              => Null
                   ,pi_allow_duplicate   => FALSE
                   ,pi_commit_autonomous => TRUE
                   );
--
   nm_debug.proc_end (g_package_name,'refresh_nmnd_as_job');
--
END refresh_nmnd_as_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmu_id_for_hig_owner RETURN nm_mail_users.nmu_id%TYPE IS
--
   CURSOR cs_nmu IS
   SELECT nmu_id
    FROM  nm_mail_users
         ,hig_users
   WHERE  hus_username = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   hus_user_id  = nmu_hus_user_id;
--
   l_nmu_id nm_mail_users.nmu_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_nmu_id_for_hig_owner');
--
   OPEN  cs_nmu;
   FETCH cs_nmu
    INTO l_nmu_id;
   CLOSE cs_nmu;
--
   nm_debug.proc_end (g_package_name,'get_nmu_id_for_hig_owner');
--
   RETURN l_nmu_id;
--
END get_nmu_id_for_hig_owner;
--
-----------------------------------------------------------------------------
--
FUNCTION does_table_have_locks (p_table_name VARCHAR2) RETURN BOOLEAN IS
   CURSOR cs_lock (c_table_name VARCHAR2
                  ,c_audsid     NUMBER
                  ) IS
   SELECT /*+ RULE */
          1
     FROM v$lock      lk
         ,dba_objects ob
         ,v$session   se
    WHERE lk.TYPE IN ('TM', 'UL')
      AND lk.id1         = ob.object_id
      AND lk.sid         = se.sid
      AND se.sid        != c_audsid
      AND ob.owner       = Sys_Context('NM3CORE','APPLICATION_OWNER')
      AND ob.object_name = c_table_name;
   l_dummy       PLS_INTEGER;
   l_lock_exists BOOLEAN;
BEGIN
--
   nm_debug.proc_start (g_package_name,'does_table_have_locks');
--
   OPEN  cs_lock (p_table_name, c_session_id);
   FETCH cs_lock
    INTO l_dummy;
   l_lock_exists := cs_lock%FOUND;
   CLOSE cs_lock;
--
   nm_debug.proc_end (g_package_name,'does_table_have_locks');
--
   RETURN l_lock_exists;
--
END does_table_have_locks;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_no_locks_internal (p_table_name VARCHAR2
                                  ,p_ner_appl   VARCHAR2
                                  ,p_ner_id     NUMBER
                                  ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'ensure_table_has_no_locks');
--
   IF does_table_have_locks (p_table_name)
    THEN
      hig.raise_ner (pi_appl               => p_ner_appl
                    ,pi_id                 => p_ner_id
                    ,pi_supplementary_info => p_table_name
                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'ensure_table_has_no_locks');
--
END check_no_locks_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_no_iit_locks IS
BEGIN
--
   check_no_locks_internal (p_table_name => 'NM_INV_ITEMS_ALL'
                           ,p_ner_appl   => nm3type.c_net
                           ,p_ner_id     => 411
                           );
--
END check_no_iit_locks;
--
-----------------------------------------------------------------------------
--
PROCEDURE ensure_table_has_no_locks (p_table_name VARCHAR2) IS
BEGIN
--
   check_no_locks_internal (p_table_name => p_table_name
                           ,p_ner_appl   => nm3type.c_net
                           ,p_ner_id     => 409
                           );
--
END ensure_table_has_no_locks;
--
-----------------------------------------------------------------------------
--
FUNCTION nmq_includes_ft_inv (p_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_check (c_nmq_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  nm_mrg_query_types
                        ,nm_inv_types
                  WHERE  nqt_nmq_id   = c_nmq_id
                   AND   nqt_inv_type = nit_inv_type
                   AND   nit_table_name IS NOT NULL
                 );
--
   l_dummy   PLS_INTEGER;
   l_retval  BOOLEAN;
   l_rec_nmq nm_mrg_query%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'nmq_includes_ft_inv');
--
   l_rec_nmq := nm3get.get_nmq (pi_nmq_id => p_nmq_id);
--
   OPEN  cs_check (p_nmq_id);
   FETCH cs_check
    INTO l_dummy;
   l_retval := cs_check%FOUND;
   CLOSE cs_check;
--
   nm_debug.proc_end (g_package_name,'nmq_includes_ft_inv');
--
   RETURN l_retval;
--
END nmq_includes_ft_inv;
--
-----------------------------------------------------------------------------
--
FUNCTION nmq_is_only_ft_inv (p_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_check (c_nmq_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  NOT EXISTS (SELECT 1
                       FROM  nm_mrg_query_types
                            ,nm_inv_types
                      WHERE  nqt_nmq_id   = c_nmq_id
                       AND   nqt_inv_type = nit_inv_type
                       AND   nit_table_name IS NULL
                     );
--
   l_dummy   PLS_INTEGER;
   l_retval  BOOLEAN;
   l_rec_nmq nm_mrg_query%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'nmq_is_only_ft_inv');
--
   l_rec_nmq := nm3get.get_nmq (pi_nmq_id => p_nmq_id);
--
   OPEN  cs_check (p_nmq_id);
   FETCH cs_check
    INTO l_dummy;
   l_retval := cs_check%FOUND;
   CLOSE cs_check;
--
   nm_debug.proc_end (g_package_name,'nmq_is_only_ft_inv');
--
   RETURN l_retval;
--
END nmq_is_only_ft_inv;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_static_css_link IS
   l_text nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_static_css_link_text');
--
   l_text := get_static_css_link_text;
   IF l_text IS NOT NULL
    THEN
      htp.p (l_text);
   END IF;
--
   nm_debug.proc_end (g_package_name,'get_static_css_link_text');
--
END do_static_css_link;
--
-----------------------------------------------------------------------------
--
FUNCTION get_static_css_link_text RETURN VARCHAR2 IS
   l_hov_value hig_option_values.hov_value%TYPE;
   l_retval    nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_static_css_link_text');
--
   l_hov_value := hig.get_sysopt('HIG_ST_CSS');
   IF l_hov_value IS NOT NULL
    THEN
      l_retval := htf.linkrel (crel => 'STYLESHEET'
                              ,curl => l_hov_value
                              );
   END IF;
--
   nm_debug.proc_end (g_package_name,'get_static_css_link_text');
--
   RETURN l_retval;
--
END get_static_css_link_text;
--
-----------------------------------------------------------------------------
--
PROCEDURE submit_refresh_pending_job (p_interval_days PLS_INTEGER DEFAULT 1) IS
   l_what nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start (g_package_name,'submit_refresh_pending_job');
--
   l_what :=            '-- the job which creates the job which refreshes the composite inv types'
             ||CHR(10)||'   '||g_package_name||'.refresh_pending_nmnd;';
--
   create_job_to_run_every_n_days (p_what          => l_what
                                  ,p_interval_days => p_interval_days
                                  );
--
   nm_debug.proc_end (g_package_name,'submit_refresh_pending_job');
--
END submit_refresh_pending_job;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_job_to_run_every_n_days (p_what          VARCHAR2
                                         ,p_interval_days PLS_INTEGER DEFAULT 1
                                         ) IS
   l_next nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_job_to_run_every_n_days');
--
   IF NVL(p_interval_days,0) > 0
    THEN
      l_next := 'TRUNC(SYSDATE)+'||p_interval_days;
   END IF;
--
   create_dbms_job (pi_what              => p_what
                   ,pi_when              => TRUNC(SYSDATE)+1
                   ,pi_next              => l_next
                   ,pi_allow_duplicate   => FALSE
                   ,pi_commit_autonomous => TRUE
                   );
--
   nm_debug.proc_end (g_package_name,'create_job_to_run_every_n_days');
--
END create_job_to_run_every_n_days;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_dbms_job (pi_what              VARCHAR2
                          ,pi_when              DATE     DEFAULT SYSDATE
                          ,pi_next              VARCHAR2 DEFAULT Null
                          ,pi_allow_duplicate   BOOLEAN  DEFAULT FALSE
                          ,pi_commit_autonomous BOOLEAN  DEFAULT TRUE
                          ) IS
   PROCEDURE create_it IS
      l_job NUMBER;
   BEGIN
      dbms_job.submit (job       => l_job
                      ,what      => pi_what
                      ,next_date => pi_when
                      ,interval  => pi_next
                      );
   END create_it;
   PROCEDURE create_it_auton IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      create_it;
      COMMIT;
   END create_it_auton;
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_dbms_job');
--
   nm3dbms_job.make_sure_processes_available;
--
   IF NOT pi_allow_duplicate
    AND nm3dbms_job.does_job_exist_by_what (pi_what)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 412
                    ,pi_supplementary_info => CHR(10)||pi_what
                    );
   END IF;
--
   IF pi_commit_autonomous
    THEN
      create_it_auton;
   ELSE
      create_it;
   END IF;
--
   nm_debug.proc_end (g_package_name,'create_dbms_job');
--
END create_dbms_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_merge_view_alias RETURN VARCHAR2 IS
BEGIN
   RETURN g_mrg_record_name;
END get_merge_view_alias;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_view_alias RETURN VARCHAR2 IS
BEGIN
   RETURN g_inv_record_name;
END get_inv_view_alias;
--
-----------------------------------------------------------------------------
--
FUNCTION get_merge_results_view (p_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN VARCHAR2 IS
   l_retval nm3type.max_varchar2;
BEGIN
   IF p_nmq_id IS NOT NULL
    THEN
      DECLARE
         l_no_query EXCEPTION;
         PRAGMA EXCEPTION_INIT (l_no_query, -20901);
      BEGIN
         l_retval := nm3mrg_view.get_mrg_view_name_by_qry_id(pi_qry_id => p_nmq_id)||'_SVL';
      EXCEPTION
         WHEN l_no_query
          THEN
            l_retval := Null;
      END;
   END IF;
   RETURN l_retval;
END get_merge_results_view;
--
-----------------------------------------------------------------------------
--
FUNCTION run_ngq (p_nqg_id         nm_gaz_query.ngq_id%TYPE
                 ,p_effective_date DATE    DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                 ,p_use_date_based BOOLEAN DEFAULT TRUE
                 ) RETURN NUMBER IS
   l_job NUMBER;
BEGIN
   DECLARE
      its_a_ner EXCEPTION;
      PRAGMA EXCEPTION_INIT (its_a_ner,-20000);
   BEGIN
      nm3gaz_qry.g_use_date_based_views := p_use_date_based;
      l_job := nm3gaz_qry.perform_query (pi_ngq_id         => p_nqg_id
                                        ,pi_effective_date => p_effective_date
                                        );
      nm3gaz_qry.g_use_date_based_views := TRUE;
   EXCEPTION
      WHEN its_a_ner
       THEN
         nm3gaz_qry.g_use_date_based_views := TRUE;
         IF hig.check_last_ner (pi_appl => nm3type.c_net
                               ,pi_id   => 306
                               )
          THEN
            l_job := Null;
         ELSE
            RAISE;
         END IF;
   END;
   RETURN l_job;
END run_ngq;
--
-----------------------------------------------------------------------------
--
END nm3inv_composite;
/
