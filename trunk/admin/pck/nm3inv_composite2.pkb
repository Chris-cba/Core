CREATE OR REPLACE PACKAGE BODY nm3inv_composite2 AS
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_composite2.pkb-arc   2.0   Jul 23 2007 14:30:44   smarshall  $
--       Module Name      : $Workfile:   nm3inv_composite2.pkb  $
--       Date into PVCS   : $Date:   Jul 23 2007 14:30:44  $
--       Date fetched Out : $Modtime:   Jul 23 2007 14:30:24  $
--       PVCS Version     : $Revision:   2.0  $
--       Based on sccs version : 
--
--   Author : Priidu
--
--   Bulk Merge Composite Inventory package body
--
-----------------------------------------------------------------------------
--   Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
--all global package variables here h
--
  g_body_sccsid   constant  varchar2(30) := '"$Revision:   2.0  $"';
  g_package_name  constant  varchar2(30) := 'nm3inv_composite2';

  -- Bulk merge types
  type xsp_tbl is table of nm_inv_items_all.iit_x_sect%type index by binary_integer;
  type mp_tbl is table of nm_members_all.nm_begin_mp%type index by binary_integer;
  type id_tbl is table of nm_members_all.nm_ne_id_of%type index by binary_integer;
  type obj_type_tbl is table of nm_members_all.nm_obj_type%type index by binary_integer;
  type rowid_tbl is table of rowid index by binary_integer;
  type merge_tbl_rec is record(
     --xsp xsp_tbl
     ne_id id_tbl
    ,begin_mp mp_tbl
    ,end_mp mp_tbl
    ,iit_id id_tbl
    ,obj_type obj_type_tbl
    ,iit_rowid rowid_tbl
  );
  
  function get_iit_tmp_rec(
     p_rowid in rowid
  ) return nm_inv_items_all%rowtype;
  
  
  procedure release_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  );
  procedure get_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  );
  
  procedure load_gaz_criteria(
     pt_ne in nm_id_tbl
    ,pt_nse in nm_id_tbl
  );
  
  procedure send_mail2(
     p_title in varchar2
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_user_id in nm_mail_users.nmu_id%type
    ,pt_lines in nm3type.tab_varchar32767
  );
  
  function to_string_attrib_tbl(p_tbl in attrib_tbl) return varchar2;
  
  procedure process_exclusive_attrs(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,pt_attr in out attrib_tbl
  );

--
  g_mrg_results_table VARCHAR2(30);
  g_tab_inv_type_to_validate nm3type.tab_varchar4;
--
  c_app_owner  CONSTANT VARCHAR2(30) := hig.get_application_owner;
  c_session_id CONSTANT NUMBER       := USERENV('SESSIONID');
  c_inv_items  CONSTANT VARCHAR2(30) := 'NM_INV_ITEMS_ALL';
  g_ok_to_turn_off_au_security BOOLEAN;
  g_last_nqt_inv_type  nm_inv_types.nit_inv_type%TYPE;
   
  cr  constant varchar2(1) := chr(10);
   
  m_next_iit_ne_id      nm_inv_items_all.iit_ne_id%type;
  m_next_iit_ne_id_flag pls_integer := 0;


--
-----------------------------------------------------------------------------
--
PROCEDURE get_and_check_results_valid (p_nmnd_nit_inv_type nm_mrg_nit_derivation.nmnd_nit_inv_type%TYPE
                                      ,p_nqr_mrg_job_id    nm_mrg_query_results.nqr_mrg_job_id%TYPE
                                      );

--
-----------------------------------------------------------------------------
--

  
  function get_version return varchar2 is
  begin
     return g_sccsid;
  end get_version;
  --
  -----------------------------------------------------------------------------
  --
  function get_body_version return varchar2 is
  begin
     return g_body_sccsid;
  end get_body_version;
  

  
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
  nm3dbg.putln(g_package_name||'.build_and_parse_sql('
    ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
    ||', p_check_all_mand_fields='||nm3dbg.to_char(p_check_all_mand_fields)
    ||')');
  nm3dbg.ind;

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
   append ('         '||g_inv_record_name||'.iit_start_date := nm3user.get_effective_date;');
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

   --putln(substr('g_block='||g_block(1), 1, 4000));
   nm3dbg.putln('g_block='||g_block(1));
   

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
      WHERE  owner      = c_app_owner
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
   
   nm3dbg.deind;
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
  nm3dbg.putln(g_package_name||'.get_and_check_results_valid('
    ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
    ||', p_nqr_mrg_job_id='||p_nqr_mrg_job_id
    ||')');
  nm3dbg.ind;
  

   l_rec_nmnd         := get_nmnd (pi_nmnd_nit_inv_type => p_nmnd_nit_inv_type);
   l_rec_nit          := nm3get.get_nit (pi_nit_inv_type => l_rec_nmnd.nmnd_nit_inv_type);
   g_nmnd_is_point    := l_rec_nit.nit_pnt_or_cont = 'P';
   g_last_update_date := l_rec_nmnd.nmnd_last_refresh_date;
   
   
   -- this checks that the mrg_query of the mrg_job_id is same as
   --   that of the comp inv_type
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
                                          
         -- Query is invalid                              
         hig.raise_ner (pi_appl               => nm3type.c_net
                       ,pi_id                 => 121
                       ,pi_supplementary_info => l_nmq_unique_1||' != '||l_nmq_unique_2
                       );
      END IF;
   --
   END IF;
--
   g_mrg_results_table := get_merge_results_view (l_rec_nmnd.nmnd_nmq_id);
  nm3dbg.putln('g_mrg_results_table='||g_mrg_results_table);
--
--   nm_debug.proc_end (g_package_name,'get_and_check_results_valid');
--
  nm3dbg.deind;
END get_and_check_results_valid;
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

  
  -- This is called separateley from nm0420 before job submit
  procedure check_no_refresh_running(
     p_nmnd_nit_inv_type in nm_mrg_nit_derivation.nmnd_nit_inv_type%type
  )
  is
  begin
    nm3dbg.putln(g_package_name||'.check_no_refresh_running('
      ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
      ||')');
    
    if p_nmnd_nit_inv_type is null then
      raise_application_error(-20001, g_package_name||'.check_no_refresh_running: Invalid argument');
    end if;
    
    get_lock(
       p_inv_type => p_nmnd_nit_inv_type
    );
    release_lock(
       p_inv_type => p_nmnd_nit_inv_type
    );
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.check_no_refresh_running('
        ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
        ||')');
      raise;
  end;


  
  -- This is the original direct call procedure, now a wrapper
  procedure refresh_nmnd(
     p_nmnd_nit_inv_type  in nm_mrg_nit_derivation.nmnd_nit_inv_type%type
    ,p_effective_date     in date
    ,p_force_full_refresh in boolean
  )
  is
  begin
    nm3dbg.putln(g_package_name||'.refresh_nmnd('
        ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
        ||', p_effective_date='||p_effective_date
        ||', p_force_full_refresh='||nm3dbg.to_char(p_force_full_refresh)
        ||')');
    nm3dbg.ind;
    
    if not p_force_full_refresh then
       raise_application_error(-20085,
        'p_force_full_refresh=false no longer supported');
    end if;
    
    call_rebuild(
       p_dbms_job_no    => null
      ,p_inv_type       => p_nmnd_nit_inv_type
      ,p_effective_date => p_effective_date
    );

    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.refresh_nmnd('
        ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
        ||', p_effective_date='||p_effective_date
        ||', p_force_full_refresh='||nm3dbg.to_char(p_force_full_refresh)
        ||')');
      raise;
  end;
    

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
PROCEDURE refresh_pending_nmnd (p_effective_date DATE DEFAULT nm3user.get_effective_date
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
                              ,p_effective_date     DATE    DEFAULT nm3user.get_effective_date
                              ,p_force_full_refresh BOOLEAN DEFAULT FALSE
                              ) IS
   l_block         nm3type.max_varchar2;
   l_job           BINARY_INTEGER;
   c_mask CONSTANT VARCHAR2(30) := 'DD/MM/YYYY';
   
BEGIN
  nm3dbg.putln(g_package_name||'.refresh_nmnd_as_job('
    ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
    ||', p_effective_date='||p_effective_date
    ||', p_force_full_refresh='||nm3dbg.to_char(p_force_full_refresh)
    ||')');
  nm3dbg.ind;
  
--
   l_block :=            '-- '||p_nmnd_nit_inv_type||' refresh'
              ||CHR(10)||'BEGIN'
              ||CHR(10)||'   '||g_package_name||'.refresh_nmnd'
              ||CHR(10)||'                 (p_nmnd_nit_inv_type  => '||nm3flx.string(p_nmnd_nit_inv_type)
              ||CHR(10)||'                 ,p_effective_date     => TO_DATE('||nm3flx.string(TO_CHAR(p_effective_date,c_mask))||','||nm3flx.string(c_mask)||')'
              ||CHR(10)||'                 ,p_force_full_refresh => '||nm3flx.boolean_to_char(p_force_full_refresh)
              ||CHR(10)||'                 );'
              ||CHR(10)||'END;';
              
   nm3dbg.putln('l_block='||l_block);
--
   create_dbms_job (pi_what              => l_block
                   ,pi_when              => SYSDATE
                   ,pi_next              => Null
                   ,pi_allow_duplicate   => FALSE
                   ,pi_commit_autonomous => TRUE
                   );
               
  nm3dbg.deind;

exception
  when others then
    nm3dbg.puterr(sqlerrm||': '||g_package_name||'.refresh_nmnd_as_job('
      ||'p_nmnd_nit_inv_type='||p_nmnd_nit_inv_type
      ||', p_effective_date='||p_effective_date
      ||', p_force_full_refresh='||nm3dbg.to_char(p_force_full_refresh)
      ||')');
    raise;

END refresh_nmnd_as_job;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmu_id_for_hig_owner RETURN nm_mail_users.nmu_id%TYPE IS
--
   CURSOR cs_nmu (c_user VARCHAR2) IS
   SELECT nmu_id
    FROM  nm_mail_users
         ,hig_users
   WHERE  hus_username = c_user
    AND   hus_user_id  = nmu_hus_user_id;
--
   l_nmu_id nm_mail_users.nmu_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'get_nmu_id_for_hig_owner');
--
   OPEN  cs_nmu (c_app_owner);
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
  nm3dbg.putln(g_package_name||'.create_dbms_job('
    ||'pi_when='||pi_when
    ||', pi_next='||pi_next
    ||', pi_allow_duplicate='||nm3dbg.to_char(pi_allow_duplicate)
    ||', pi_commit_autonomous='||nm3dbg.to_char(pi_commit_autonomous)
    ||')');
  nm3dbg.ind;
  nm3dbg.putln('pi_what='||pi_what);
  
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
   
  nm3dbg.deind;

exception
  when others then
    nm3dbg.puterr(substr(
      sqlerrm||': '||g_package_name||'.create_dbms_job('
      ||'pi_when='||pi_when
      ||', pi_next='||pi_next
      ||', pi_allow_duplicate='||nm3dbg.to_char(pi_allow_duplicate)
      ||', pi_commit_autonomous='||nm3dbg.to_char(pi_commit_autonomous)
      ||', pi_what='||pi_what
      ||')', 1, 4000));
    raise;
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


  --------------------------------------------------------------------
  -- Call and job submit procedures
  --------------------------------------------------------------------
  
  
  
  -- A dbms_job_submit wrapper
  -- The only added value is the logging of the call
  -- Use sql_dbms_job_what() to get the WHAT sql 
  procedure submit_job(
     p_job out binary_integer
    ,p_what_hint in varchar2
    ,p_what in varchar2
    ,p_next_date in date
    ,p_interval in varchar2
  )
  is
    l_job         binary_integer;
    l_broken      varchar2(1);
    l_this_date   date;
    l_len         binary_integer := length(p_what_hint);
    cur           sys_refcursor;
    
    pragma autonomous_transaction;
  begin
    nm3dbg.putln(g_package_name||'.submit_job('
      ||'p_what_hint='||p_what_hint
      ||', p_what='||p_what
      ||', p_next_date='||p_next_date
      ||', p_interval='||p_interval
      ||')');
      
    if p_what_hint is null
      or p_what is null
      or p_next_date is null
    then
      raise_application_error(-20001, 'Bad attribute');
    end if;
      
      
    -- select the current jobs of this hint in order
    -- 1)broken, 2)not running 3)running
    for r in (
      select j.job, j.broken, j.this_date, j.interval, j.failures
      from sys.user_jobs j
      where substr(j.what, 4, l_len) = p_what_hint
      order by j.broken desc, j.this_date nulls first, j.next_date
    )
    loop
      if r.broken = 'Y' then
        dbms_job.remove(r.job);
      
      elsif r.this_date is null then
        dbms_job.remove(r.job);
        
      else
        raise_application_error(-20001
          ,p_what_hint||' is currently running');
          
      end if;

    end loop;
      
    dbms_job.submit(
       job       => p_job
      ,what      => '-- '||p_what_hint||chr(10)||p_what
      ,next_date => p_next_date
      ,interval  => p_interval
    );
    commit;
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.submit_job('
        ||'p_what_hint='||p_what_hint
        ||', p_what='||p_what
        ||', p_next_date='||p_next_date
        ||', p_interval='||p_interval
        ||')');
      rollback;
      raise;
    
  end;
  
  
  
  -- This builds a hit to the dbms_job WHAT sql
  -- the hint will be the first line in WHAT
  -- the hint can be used to determine if a job is already submitted
  function sql_dbms_job_what_hint(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_interval in varchar2
  ) return varchar2
  is
  begin
    if p_interval is null then
      return 'Derived Assets ad hoc: '||p_inv_type;
    else
      return 'Derived Assets regular: '||p_inv_type;
    end if;
  end;
  
  
  -- This returns the plsql code block to be submitted with dbms_job
  --  if p_effective_date is null then sysdate will be used
  --    leave null when submitting the standard recurring job
  function sql_dbms_job_what(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_send_mail in boolean
    ,p_ne_delim in varchar2
    ,p_nse_delim in varchar2
    ,p_attr1 in varchar2
    ,p_value1 in varchar2
    ,p_attr2 in varchar2
    ,p_value2 in varchar2
    ,p_attr3 in varchar2
    ,p_value3 in varchar2
  ) return varchar2
  is
    l_sql   varchar2(32767);
    cr      constant varchar2(1) := chr(10);
    l_effective_date varchar2(40);
    l_hint  varchar2(100);
    
  begin
    if p_effective_date is null then
      l_effective_date := 'trunc(sysdate)';
    else
      l_effective_date := 'to_date('''||to_char(p_effective_date, 'YYYYMMDD')||''', ''YYYYMMDD'')';
    end if;
    
    if p_send_mail is not null then
      l_sql := l_sql
        ||cr||'  ,p_send_mail => '||nm3flx.boolean_to_char(p_send_mail);
    end if;
    if p_ne_delim is not null then
      l_sql := l_sql
        ||cr||'  ,p_ne_delim => '''||p_ne_delim||'''';
    end if;
    if p_nse_delim is not null then
      l_sql := l_sql
        ||cr||'  ,p_nse_delim => '''||p_nse_delim||'''';
    end if;
    if p_attr1 is not null then
      l_sql := l_sql
        ||cr||'  ,p_attr1 => '''||p_attr1||''''
        ||cr||'  ,p_value1 => '''||p_value1||'''';
    end if;
    if p_attr2 is not null then
      l_sql := l_sql
        ||cr||'  ,p_attr2 => '''||p_attr2||''''
        ||cr||'  ,p_value2 => '''||p_value2||'''';
    end if;
    if p_attr3 is not null then
      l_sql := l_sql
        ||cr||'  ,p_attr3 => '''||p_attr3||''''
        ||cr||'  ,p_value3 => '''||p_value3||'''';
    end if;
    
    -- note: the first parameter is special parameter recognized by dbms_job
    --  this gives the call_rebuild() a chance to remove the job on failure
    return    'nm3inv_composite2.call_rebuild('
        ||cr||'   p_dbms_job_no => job'
        ||cr||'  ,p_inv_type => '''||p_inv_type||''''
        ||cr||'  ,p_effective_date => '||l_effective_date
            ||l_sql
        ||cr||');';
  end;

  
  -- this is the access point for both the dmbs_job and direct calling
  --  the p_attr0 and p_value0 are paris of merge query exclusive attributes
  --  the p_ne_id and p_nse_id come from the from
  --    that makes a direct call to run rebuild
  --    (in theory, they could be specified in dbms_job as well)
  -- This procedure is called inside dbms_job plsql block
  procedure call_rebuild(
     p_dbms_job_no in binary_integer
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_send_mail in boolean
    ,p_ne_delim in varchar2
    ,p_nse_delim in varchar2
    ,p_attr1 in varchar2
    ,p_value1 in varchar2
    ,p_attr2 in varchar2
    ,p_value2 in varchar2
    ,p_attr3 in varchar2
    ,p_value3 in varchar2
  )
  is
    r_nmnd  nm_mrg_nit_derivation%rowtype;
    l_keep_history boolean := false;
    t_attr  attrib_tbl;
    i       binary_integer := 0;
    l_admin_unit_id hig_users.hus_admin_unit%type;
    t_ne    nm_id_tbl;
    t_nse   nm_id_tbl;
    
  begin
    nm3dbg.putln(g_package_name||'.call_rebuild('
      ||'p_dbms_job_no='||p_dbms_job_no
      ||', p_inv_type='||p_inv_type
      ||', p_effective_date='||p_effective_date
      ||', p_ne_delim='||p_ne_delim
      ||', p_nse_delim='||p_nse_delim
      ||', p_attr1='||p_attr1
      ||', p_value1='||p_value1
      ||', p_attr2='||p_attr2
      ||', p_value2='||p_value2
      ||', p_attr3='||p_attr3
      ||', p_value3='||p_value3
      ||')');
    nm3dbg.ind;
    
    select * into r_nmnd 
    from nm_mrg_nit_derivation
    where nmnd_nit_inv_type = p_inv_type;
    
    
    select u.hus_admin_unit into l_admin_unit_id
    from hig_users u
    where u.hus_user_id = r_nmnd.nmnd_nmu_id_admin;
    
    if r_nmnd.nmnd_maintain_history = 'Y' then
      l_keep_history := true;
    end if;
    
    
    -- fill the t_attr with merge query exclusive attributes
    for r in (
      select upper(a.ita_attrib_name) ita_attrib_name
      from nm_inv_type_attribs_all a
      where a.ita_inv_type = p_inv_type
        and a.ita_exclusive = 'Y'
    )
    loop
      i := i + 1;
      t_attr(i).name := r.ita_attrib_name;
      if upper(p_attr1) = t_attr(i).name then
        t_attr(i).value := p_value1;
      elsif upper(p_attr2) = t_attr(i).name then
        t_attr(i).value := p_value2;
      elsif upper(p_attr3) = t_attr(i).name then
        t_attr(i).value := p_value3;
      elsif p_attr1||p_attr2||p_attr3 is not null then
        raise_application_error(-20101
          ,'Invalid merge query exclusive attribute specified');
      end if;
      
    end loop;
    
    
    -- split the ne and nse criteria delimited id strings into tables
    nm3sql.split_id_tbl(
       p_tbl    => t_ne
      ,p_string => p_ne_delim
      ,p_delim  => ','
    );
    nm3sql.split_id_tbl(
       p_tbl    => t_nse
      ,p_string => p_nse_delim
      ,p_delim  => ','
    );
  
  
    -- call the main rebuild processing function 
    do_rebuild(
       p_op_context     => p_dbms_job_no
      ,p_inv_type       => r_nmnd.nmnd_nit_inv_type
      ,p_nmq_id         => r_nmnd.nmnd_nmq_id
      ,p_effective_date => p_effective_date
      ,p_admin_unit_id  => l_admin_unit_id
      ,p_admin_id       => r_nmnd.nmnd_nmu_id_admin
      ,p_mrg_view       => 'V_MRG_'||r_nmnd.nmnd_nit_inv_type||'_SVL'
      ,p_mrg_view_where => r_nmnd.nmnd_where_clause
      ,pt_unique_attr   => t_attr
      ,p_keep_history   => l_keep_history
      ,p_send_mail      => p_send_mail
      ,p_nt_type        => r_nmnd.nmnd_nt_type
      ,p_ngt_group_type => r_nmnd.nmnd_ngt_group_type
      ,pt_ne            => t_ne
      ,pt_nse           => t_nse
      ,p_ignore_poe     => true
    );
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.call_rebuild('
        ||'p_dbms_job_no='||p_dbms_job_no
        ||', p_inv_type='||p_inv_type
        ||', p_ne_delim='||p_ne_delim
        ||', p_nse_delim='||p_nse_delim
        ||', p_attr1='||p_attr1
        ||', p_value1='||p_value1
        ||', p_attr2='||p_attr2
        ||', p_value2='||p_value2
        ||', p_attr3='||p_attr3
        ||', p_value3='||p_value3
        ||')');
      if p_dbms_job_no is not null then
        dbms_job.broken(p_dbms_job_no, true);
        --dbms_job.remove(p_dbms_job_no);
      end if;
      raise;
 
  end;

  

  -----------------------------------------------------------------------
  -- The main work procedures
  -----------------------------------------------------------------------
  
  -- This is the main work procedure
  -- normally this proc is always running in its own session
  --  as it is called via the dbms_job.submit procedure
  procedure do_rebuild(
     p_op_context in pls_integer
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_nmq_id in nm_mrg_query_all.nmq_id%type
    ,p_effective_date in date
    ,p_admin_unit_id in nm_admin_units_all.nau_admin_unit%type
    ,p_admin_id in hig_users.hus_user_id%type
    ,p_mrg_view in varchar2
    ,p_mrg_view_where in varchar2
    ,pt_unique_attr in attrib_tbl
    ,p_keep_history in boolean
    ,p_send_mail in boolean
    ,p_nt_type in nm_types.nt_type%type
    ,p_ngt_group_type in nm_group_types_all.ngt_group_type%type
    ,pt_ne in nm_id_tbl
    ,pt_nse in nm_id_tbl
    ,p_ignore_poe in boolean
  )
  is
    l_mrg_job_id  nm_mrg_query_results_all.nqr_mrg_job_id%type;
    l_all_routes  boolean := false;
    l_nqr_description nm_mrg_query_results_all.nqr_description%type;
    l_sqlcount    number(8);
    l_sqlcount2   number(8);
    t_id          nm_id_tbl := new nm_id_tbl();
    t_attr        attrib_tbl := pt_unique_attr;
    l_effective_date constant date := nm3user.get_effective_date;
    l_route_id    nm_elements_all.ne_id%type;
    --
    t_events      nm3type.tab_varchar32767;
    l_op_index    pls_integer;
    l_op_slno     pls_integer;
    r_longops     nm3sql.longops_rec;
    i             binary_integer;
    
  begin
    nm3dbg.debug_on; nm3dbg.timing_on;
    nm3dbg.putln(g_package_name||'.do_rebuild('
      ||'p_op_context='||p_op_context
      ||', p_inv_type='||p_inv_type
      ||', p_nmq_id='||p_nmq_id
      ||', p_effective_date='||p_effective_date
      ||', p_admin_unit_id='||p_admin_unit_id
      ||', p_admin_id='||p_admin_id
      ||', p_mrg_view='||p_mrg_view
      ||', p_mrg_view_where='||p_mrg_view_where
      ||', pt_unique_attr.count='||pt_unique_attr.count
      ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
      ||', p_nt_type='||p_nt_type
      ||', p_ngt_group_type='||p_ngt_group_type
      ||', pt_ne.count='||pt_ne.count
      ||', pt_nse.count='||pt_nse.count
      ||', p_ignore_poe='||nm3dbg.to_char(p_ignore_poe)
      ||')');
    nm3dbg.ind;
    
    
    l_nqr_description := 'Derived Asset '''||p_inv_type||''' rebuild';
    
    t_events(t_events.count+1) := 'Rebuild job parameters: '
      ||'job_context='||p_op_context
      ||', inv_type='||p_inv_type
      ||', effective_date='||p_effective_date
      ||', admin_id='||p_admin_id
      ||', keep_history='||nm3dbg.to_char(p_keep_history)
      ||', exclusive_attributes='||to_string_attrib_tbl(pt_unique_attr)
      ||', network_type='||p_nt_type
      ||', group_type='||p_ngt_group_type
      ||', route_count='||pt_ne.count
      ||', saved_extent_count='||pt_nse.count;
    
    
    -- process the unique attributes
    --  this validates and builds the value sql string
    process_exclusive_attrs(
       p_inv_type => p_inv_type
      ,pt_attr => t_attr
    );
    
    
    -- the serializable ensures that we don't have invitem edits between
    --  the merge query steps
    -- if we do the transaction fails
    set transaction isolation level serializable;
    
    
    if l_effective_date = p_effective_date then null;
    else
      nm3user.set_effective_date(p_effective_date);
    end if;
    
    -- validate input parameters
    if p_inv_type is null
      or p_effective_date is null
    then
      raise_application_error(-20101, 'Invalid or missimg parameters');
    end if;
    
    -- Todo!
    if p_ngt_group_type is null then
      raise_application_error(-20101
      , 'Runnig derivied assets without specifying the Driving Group Type is not yet implemented');
      
    end if;
    
    
    
    
    -- 0 initialize
    r_longops.rindex      := dbms_application_info.set_session_longops_nohint;
    r_longops.op_name     := 'Derived asset rebuild';
    r_longops.context     := p_op_context;
    r_longops.sofar       := 0;
    r_longops.totalwork   := 6;
    r_longops.target_desc  := p_inv_type;
    nm3sql.set_longops(p_rec => r_longops, p_increment => 0);

    -- 1. Populate the network criteria
    -- 1.1 We have datums/routes/extents selected via Gazetteer
    if pt_ne.count > 0 or pt_nse.count > 0 then
      load_gaz_criteria(
         pt_ne => pt_ne
        ,pt_nse => pt_nse   
      );
      
    -- 1.3 we have a group type (linear)
    elsif p_ngt_group_type is not null then
      nm3bulk_mrg.load_group_type_datums(p_ngt_group_type);
      
      
    -- 1.4 we have a network type (linear)
    elsif p_nt_type is not null then
      raise_application_error(-20099
        ,'Running Derived Assets on network type only not yet implemented');
      
    -- 1.5 no network criteria specified
    else
      raise_application_error(-20099
        ,'Running Derived Assets on the whole network not yet implemented');
      l_all_routes := true;
    
    end if;
    
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    t_events(t_events.count+1) := 'Loaded criteria datum count: '||nm3sql.get_id_tbl_count;
    

    -- 2,3,4. Run the bulk merge query
    nm3bulk_mrg.std_run(
       p_nmq_id         => p_nmq_id
      ,p_nqr_admin_unit => p_admin_unit_id
      ,p_nmq_descr      => l_nqr_description
      ,p_route_id       => l_route_id
      ,p_route_type     => p_ngt_group_type
      ,p_all_routes     => l_all_routes
      ,p_ignore_poe     => p_ignore_poe
      ,p_mrg_job_id     => l_mrg_job_id
      ,p_longops_rec    => r_longops
    );
    commit;
    t_events(t_events.count+1) := 'Merge job committed with id: '||l_mrg_job_id;
    
    
    -- 5. Popluate the iit temp table
    ins_iit_tmp_values(
       p_inv_type => p_inv_type
      ,p_mrg_view => p_mrg_view
      ,p_mrg_view_where => p_mrg_view_where
      ,p_effective_date => p_effective_date
      ,p_mrg_job_id => l_mrg_job_id
      ,pt_attr => t_attr
      ,p_sqlcount => l_sqlcount
    );
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    t_events(t_events.count+1) := 'Loaded temporary invitems count: '||l_sqlcount;
    
    
    -- 6. Create the composite inv items and placements
    process_from_iit_tmp(
       p_inv_type       => p_inv_type
      ,p_mrg_job_id     => l_mrg_job_id
      ,p_effective_date => p_effective_date
      ,pt_attr          => t_attr
      ,p_iit_tmp_cardinality => l_sqlcount
      ,p_keep_history   => p_keep_history
      ,p_item_count     => l_sqlcount
      ,p_member_count   => l_sqlcount2
    );
    commit;
    t_events(t_events.count+1) := 'Final invitems count: '||l_sqlcount
      ||', member count: '||l_sqlcount2;
    nm3sql.set_longops(p_rec => r_longops, p_increment => 1);
    
    if p_send_mail then
      send_mail2(
         p_title => 'Run Derived Assets Complete'
        ,p_inv_type => p_inv_type
        ,p_effective_date => p_effective_date
        ,p_user_id => p_admin_id
        ,pt_lines => t_events
      );
    end if;
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||'; '||g_package_name||'.do_rebuild('
        ||'p_op_context='||p_op_context
        ||', p_inv_type='||p_inv_type
        ||', p_nmq_id='||p_nmq_id
        ||', p_effective_date='||p_effective_date
        ||', p_admin_unit_id='||p_admin_unit_id
        ||', p_mrg_view='||p_mrg_view
        ||', p_mrg_view_where='||p_mrg_view_where
        ||', pt_unique_attr.count='||pt_unique_attr.count
        ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
        ||', p_nt_type='||p_nt_type
        ||', p_ngt_group_type='||p_ngt_group_type
        ||', pt_ne.count='||pt_ne.count
        ||', pt_nse.count='||pt_nse.count
        ||', p_ignore_poe='||nm3dbg.to_char(p_ignore_poe)
        ||')');
        nm3user.set_effective_date(l_effective_date);
        if p_send_mail then
          t_events(t_events.count+1) := sqlerrm;
          send_mail2(
             p_title => 'Run Derived Assets Error'
            ,p_inv_type => p_inv_type
            ,p_effective_date => p_effective_date
            ,p_user_id => p_admin_id
            ,pt_lines => t_events
          );
        end if;
        raise;
    
  end;
  
  
  
  procedure process_exclusive_attrs(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,pt_attr in out attrib_tbl
  )
  is
    l_count pls_integer := 0;
    l_found boolean := false;
    i       binary_integer;
    r_ita   nm_inv_type_attribs_all%rowtype;
      
    function sql_format_attr_value(
       p_value in varchar2
      ,p_format in varchar2
      ,p_format_mask in varchar2) return varchar2
    is
    begin
      if p_value is null then
        return null;
      end if;
      case p_format
      when 'NUMBER' then
        return p_value;
      when 'DATE' then
        if p_format_mask is not null then
          return 'to_date('''||p_value||''','''||p_format_mask||''')';
        else
          return 'to_date('''||p_value||''')';
        end if;
      else
        return ''''||p_value||'''';
      end case;
    end;
    
  begin
  
    -- compare the passed in parameters table to the exclusive attributes specified in metadata
    --  if not all passed in then raise error    
    for r in (
      select upper(a.ita_attrib_name) ita_attrib_name
      from nm_inv_type_attribs_all a
      where a.ita_inv_type = p_inv_type
        and a.ita_exclusive = 'Y'
    )
    loop
      l_found := false;
      for i in 1 .. pt_attr.count loop
        if upper(pt_attr(i).name) = r.ita_attrib_name then
          l_found := true;
          exit;
        end if;
      end loop;
      if not l_found then
        raise_application_error(-20040, 'Exclusive attribue not specified');
      end if;
      l_count := l_count + 1;
    end loop;
    if l_count = pt_attr.count then null;
    else
      raise_application_error(-20040, 'Invalid exclusive attribute specified');
    end if;
    nm3dbg.putln('exclusive attribute count: '||l_count);

  
    -- build the unique attributes where string
    i := pt_attr.first;
    while i is not null loop
      select * into r_ita
      from nm_inv_type_attribs_all a
      where a.ita_inv_type = p_inv_type
        and a.ita_attrib_name = upper(pt_attr(i).name);
              
      pt_attr(i).sql_value := sql_format_attr_value(
          p_value       => pt_attr(i).value
         ,p_format      => r_ita.ita_format
         ,p_format_mask => r_ita.ita_format_mask
      );
            
      i := pt_attr.next(i);
    end loop;
  
  end;
  
  
  -- this is the main processing function
  --  that creates the invitem and member records
  procedure process_from_iit_tmp(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_mrg_job_id in id_type
    ,p_effective_date in date
    ,pt_attr in attrib_tbl
    ,p_iit_tmp_cardinality in number
    ,p_keep_history in boolean
    ,p_item_count out pls_integer
    ,p_member_count out pls_integer
  )
  is

    type rowid_tbl  is table of rowid index by binary_integer;
    t_rowid   rowid_tbl;
    l_enddate_count pls_integer;
    l_delete_count  pls_integer;
    l_invitem_count pls_integer;

    l_sql         varchar2(32767);
    l_sql_where   varchar2(4000);
    i             binary_integer;

    

  -- the main procedure body starts here
  begin
    nm3dbg.putln(g_package_name||'.process_from_iit_tmp('
      ||'p_inv_type='||p_inv_type
      ||', pt_attr='||to_string_attrib_tbl(pt_attr)
      ||', p_iit_tmp_cardinality='||p_iit_tmp_cardinality
      ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
      ||')');
    nm3dbg.ind;
    
    p_item_count := 0;
    
    

    -- build the exclusive attribute where string
    --  this is used in enddating/deleting existing members and invitems    
    i := pt_attr.first;
    while i is not null loop
      l_sql_where := l_sql_where
        ||cr||'  and i.'||lower(pt_attr(i).name)||' = v.'||lower(pt_attr(i).name);
      i := pt_attr.next(i);
    end loop;
    

    
    -- the sql to select the existing nm_members_records
    --  affected by the rebuild
    l_sql := 
            'select'
      ||cr||'   m.rowid row_id'
      ||cr||'from'
      ||cr||'   nm_mrg_section_members sm'
      ||cr||'  ,nm_mrg_derived_inv_values_tmp v'
      ||cr||'  ,nm_members m'
      ||cr||'  ,nm_inv_items_all i'
      ||cr||'where sm.nsm_mrg_job_id = :p_mrg_job_id'
      ||cr||'  and sm.nsm_mrg_section_id = v.mrg_section_id'
      ||cr||'  and m.nm_ne_id_of = sm.nsm_ne_id'
      ||cr||'  and m.nm_obj_type = :p_inv_type'
      ||cr||'  and m.nm_ne_id_in = i.iit_ne_id'
      ||cr||'  and ((sm.nsm_begin_mp < m.nm_end_mp'
      ||cr||'      and sm.nsm_end_mp > m.nm_begin_mp)'
      ||cr||'    or (sm.nsm_begin_mp = m.nm_begin_mp'
      ||cr||'      and sm.nsm_end_mp = m.nm_end_mp))'
          ||l_sql_where;
    nm3dbg.putln(l_sql);
    
    
    -- 1. delete or enddate the existing member records
    -- 1.1 end date
    if p_keep_history then
      
      -- select the rowids of existng member records affected by the rebuild
      execute immediate l_sql
      bulk collect into t_rowid
      using p_mrg_job_id, p_inv_type;
      nm3dbg.putln('existing members collect count: '||sql%rowcount);
            
            
      -- 2.1.1 end date the members whose start date is not rebuild's effective date
      -- if the effective date is same as old start date (two edits in same day)
      --  then we must delete, not enddate
      forall i in 1 .. t_rowid.last
        delete from nm_members_all
        where rowid = t_rowid(i)
          and nm_start_date = p_effective_date;
      l_delete_count := sql%rowcount;
      nm3dbg.putln('existing members delete count: '||l_delete_count);
          
          
      -- set the enddate for the rest (the normal processing)
      forall i in 1 .. t_rowid.last
        update nm_members_all
          set nm_end_date = p_effective_date
        where rowid = t_rowid(i)
          and nm_start_date != p_effective_date;
      l_enddate_count := sql%rowcount;
      nm3dbg.putln('existing members enddate count: '||l_enddate_count);
    
    
    
    -- 2.2 no history, delete
    else
      execute immediate
              'delete from nm_members'
        ||cr||'where rowid in ('
        ||cr||l_sql
        ||cr||')'
      using p_mrg_job_id, p_inv_type;

      l_delete_count := sql%rowcount;
      nm3dbg.putln('existing members delete count: '||l_delete_count);
      
    end if;
    
    
    -- 2. Insert the new invitems and members
    
    -- 2.1 Insert invitems
    insert into nm_inv_items_all(
      iit_ne_id, iit_inv_type, iit_primary_key, iit_start_date, iit_admin_unit, iit_descr
      , iit_foreign_key, iit_located_by, iit_position, iit_x_coord, iit_y_coord
      , iit_num_attrib16, iit_num_attrib17, iit_num_attrib18, iit_num_attrib19, iit_num_attrib20
      , iit_num_attrib21, iit_num_attrib22, iit_num_attrib23, iit_num_attrib24, iit_num_attrib25
      , iit_chr_attrib26, iit_chr_attrib27, iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30
      , iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33, iit_chr_attrib34, iit_chr_attrib35
      , iit_chr_attrib36, iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39, iit_chr_attrib40
      , iit_chr_attrib41, iit_chr_attrib42, iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45
      , iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48, iit_chr_attrib49, iit_chr_attrib50
      , iit_chr_attrib51, iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54, iit_chr_attrib55
      , iit_chr_attrib56, iit_chr_attrib57, iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60
      , iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63, iit_chr_attrib64, iit_chr_attrib65
      , iit_chr_attrib66, iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69, iit_chr_attrib70
      , iit_chr_attrib71, iit_chr_attrib72, iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75
      , iit_num_attrib76, iit_num_attrib77, iit_num_attrib78, iit_num_attrib79, iit_num_attrib80
      , iit_num_attrib81, iit_num_attrib82, iit_num_attrib83, iit_num_attrib84, iit_num_attrib85
      , iit_date_attrib86, iit_date_attrib87, iit_date_attrib88, iit_date_attrib89, iit_date_attrib90
      , iit_date_attrib91, iit_date_attrib92, iit_date_attrib93, iit_date_attrib94, iit_date_attrib95
      , iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour, iit_colour_txt, iit_coord_flag
      , iit_description, iit_diagram, iit_distance, iit_end_chain, iit_gap, iit_height, iit_height_2
      , iit_id_code, iit_instal_date, iit_invent_date, iit_inv_ownership, iit_itemcode, iit_lco_lamp_config_id
      , iit_length, iit_material, iit_material_txt, iit_method, iit_method_txt, iit_note, iit_no_of_units
      , iit_options, iit_options_txt, iit_oun_org_id_elec_board, iit_owner, iit_owner_txt
      , iit_peo_invent_by_id, iit_photo, iit_power, iit_prov_flag, iit_rev_by, iit_rev_date
      , iit_type, iit_type_txt, iit_width, iit_xtra_char_1
      , iit_xtra_date_1, iit_xtra_domain_1, iit_xtra_domain_txt_1, iit_xtra_number_1
      , iit_x_sect, iit_det_xsp, iit_offset, iit_x, iit_y, iit_z
      , iit_num_attrib96, iit_num_attrib97, iit_num_attrib98, iit_num_attrib99, iit_num_attrib100
      , iit_num_attrib101, iit_num_attrib102, iit_num_attrib103, iit_num_attrib104, iit_num_attrib105
      , iit_num_attrib106, iit_num_attrib107, iit_num_attrib108, iit_num_attrib109, iit_num_attrib110
      , iit_num_attrib111, iit_num_attrib112, iit_num_attrib113, iit_num_attrib114, iit_num_attrib115
    )
    select
      iit_ne_id, iit_inv_type, iit_ne_id, p_effective_date, iit_admin_unit, iit_descr
      , iit_foreign_key, iit_located_by, iit_position, iit_x_coord, iit_y_coord
      , iit_num_attrib16, iit_num_attrib17, iit_num_attrib18, iit_num_attrib19, iit_num_attrib20
      , iit_num_attrib21, iit_num_attrib22, iit_num_attrib23, iit_num_attrib24, iit_num_attrib25
      , iit_chr_attrib26, iit_chr_attrib27, iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30
      , iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33, iit_chr_attrib34, iit_chr_attrib35
      , iit_chr_attrib36, iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39, iit_chr_attrib40
      , iit_chr_attrib41, iit_chr_attrib42, iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45
      , iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48, iit_chr_attrib49, iit_chr_attrib50
      , iit_chr_attrib51, iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54, iit_chr_attrib55
      , iit_chr_attrib56, iit_chr_attrib57, iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60
      , iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63, iit_chr_attrib64, iit_chr_attrib65
      , iit_chr_attrib66, iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69, iit_chr_attrib70
      , iit_chr_attrib71, iit_chr_attrib72, iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75
      , iit_num_attrib76, iit_num_attrib77, iit_num_attrib78, iit_num_attrib79, iit_num_attrib80
      , iit_num_attrib81, iit_num_attrib82, iit_num_attrib83, iit_num_attrib84, iit_num_attrib85
      , iit_date_attrib86, iit_date_attrib87, iit_date_attrib88, iit_date_attrib89, iit_date_attrib90
      , iit_date_attrib91, iit_date_attrib92, iit_date_attrib93, iit_date_attrib94, iit_date_attrib95
      , iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour, iit_colour_txt, iit_coord_flag
      , iit_description, iit_diagram, iit_distance, iit_end_chain, iit_gap, iit_height, iit_height_2
      , iit_id_code, iit_instal_date, iit_invent_date, iit_inv_ownership, iit_itemcode, iit_lco_lamp_config_id
      , iit_length, iit_material, iit_material_txt, iit_method, iit_method_txt, iit_note, iit_no_of_units
      , iit_options, iit_options_txt, iit_oun_org_id_elec_board, iit_owner, iit_owner_txt
      , iit_peo_invent_by_id, iit_photo, iit_power, iit_prov_flag, iit_rev_by, iit_rev_date
      , iit_type, iit_type_txt, iit_width, iit_xtra_char_1
      , iit_xtra_date_1, iit_xtra_domain_1, iit_xtra_domain_txt_1, iit_xtra_number_1
      , iit_x_sect, iit_det_xsp, iit_offset, iit_x, iit_y, iit_z
      , iit_num_attrib96, iit_num_attrib97, iit_num_attrib98, iit_num_attrib99, iit_num_attrib100
      , iit_num_attrib101, iit_num_attrib102, iit_num_attrib103, iit_num_attrib104, iit_num_attrib105
      , iit_num_attrib106, iit_num_attrib107, iit_num_attrib108, iit_num_attrib109, iit_num_attrib110
      , iit_num_attrib111, iit_num_attrib112, iit_num_attrib113, iit_num_attrib114, iit_num_attrib115
    from
      nm_mrg_derived_inv_values_tmp;
    nm3dbg.putln('inserted invitems count: '||sql%rowcount);
      
      
    -- 2.2 insert members
    insert into nm_members_all (
      nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type
      , nm_begin_mp, nm_start_date, nm_end_mp
      , nm_cardinality, nm_admin_unit
    )
    select
       v.iit_ne_id, sm.nsm_ne_id, 'I', p_inv_type
      ,sm.nsm_begin_mp, p_effective_date, sm.nsm_end_mp
      ,1, v.iit_admin_unit
    from
       nm_mrg_section_members sm
      ,nm_mrg_derived_inv_values_tmp v
    where sm.nsm_mrg_section_id = v.mrg_section_id
      and sm.nsm_mrg_job_id = p_mrg_job_id;
    nm3dbg.putln('inserted memebers count: '||sql%rowcount);
  
  
  
    -- 3. enddate/delete the invitems that may have been left without placement
    if p_keep_history then
      update nm_inv_items_all i
        set i.iit_end_date = p_effective_date
      where i.iit_inv_type = p_inv_type
        and i.iit_end_date is null
        and not exists (
          select null from nm_members
          where nm_ne_id_in = i.iit_ne_id
        );
      nm3dbg.putln('enddated childless invitem count: '||sql%rowcount);
      
    else
      delete from nm_inv_items_all i
      where i.iit_inv_type = p_inv_type
        and i.iit_end_date is null
        and not exists (
          select null from nm_members
          where nm_ne_id_in = i.iit_ne_id
        );
      nm3dbg.putln('deleted childless invitem count: '||sql%rowcount);
    end if;

    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.process_from_iit_tmp('
        ||'p_inv_type='||p_inv_type
        ||', pt_attr='||to_string_attrib_tbl(pt_attr)
        ||', p_iit_tmp_cardinality='||p_iit_tmp_cardinality
        ||', p_keep_history='||nm3dbg.to_char(p_keep_history)
        ||')');
      raise;
  end;
  
  
  
  
  -- this loads the iit records with correct drived values
  --  into a temp table nm_mrg_derived_inv_values_tmp
  -- autonomous transaction
  procedure ins_iit_tmp_values(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_mrg_job_id in nm_mrg_query_results_all.nqr_mrg_job_id%type
    ,p_mrg_view in varchar2
    ,p_mrg_view_where in varchar2
    ,p_effective_date in date
    ,pt_attr in attrib_tbl
    ,p_sqlcount out number
  )
  is
    l_sql   varchar2(32767);
    l_sql_mrg_view_where varchar2(4000) := p_mrg_view_where;
    cr      constant varchar2(1) := chr(10);
    i       binary_integer;
    l_derivation  varchar2(4000);
    
    pragma autonomous_transaction;
    
  begin
    nm3dbg.putln(g_package_name||'.ins_iit_tmp_values('
      ||'p_inv_type='||p_inv_type
      ||', p_mrg_job_id='||p_mrg_job_id
      ||', p_mrg_view='||p_mrg_view
      ||', p_mrg_view_where='||p_mrg_view_where
      ||', p_effective_date='||p_effective_date
      ||')');
    nm3dbg.ind;
    
    -- nm_mrg_derived_inv_values_tmp is global temporary on commit preserve rows
    execute immediate
      'truncate table nm_mrg_derived_inv_values_tmp';

      
    -- build the load sql string
    -- mrg is assumed to be alias in the derivation strings
    for r in (
       select
          case tc.column_name
          when 'IIT_NE_ID' then 'nm3net.get_next_ne_id'
          when 'IIT_INV_TYPE' then ''''||p_inv_type||''''
          when 'IIT_START_DATE' then ':p_effective_date'
          else nvl(d.nmid_derivation, 'null')
          end nmid_derivation
         ,tc.column_name
       from
          (select * from nm_mrg_ita_derivation where nmid_ita_inv_type = p_inv_type) d
         ,(select column_name, column_id
          from user_tab_cols
          where table_name = 'NM_INV_ITEMS_ALL') tc
       where tc.column_name = d.nmid_ita_attrib_name (+)
       order by tc.column_id
    )
    loop
      -- for exclusive attribute replace the derivation with the user value if given
      l_derivation := r.nmid_derivation;
      i := pt_attr.first;
      while i is not null loop
        if pt_attr(i).name = r.column_name and pt_attr(i).value is not null then
          l_derivation := pt_attr(i).sql_value;
          i := null;
        else
          i := pt_attr.next(i);
        end if;
      end loop;
      l_sql := l_sql||cr||','||l_derivation||' '||r.column_name;
      
    end loop;
    
    
    if l_sql_mrg_view_where is not null then
      l_sql_mrg_view_where :=
        cr||'  and '||l_sql_mrg_view_where;
    end if;
    
    l_sql := 'insert /*+ append */ into nm_mrg_derived_inv_values_tmp'
       ||cr||'select'
       ||cr||' mrg.nqr_mrg_job_id'
       ||cr||',mrg.nms_mrg_section_id'
           ||l_sql
       ||cr||'from '||p_mrg_view||' mrg'
       ||cr||'where mrg.nqr_mrg_job_id = :p_mrg_job_id'
           ||l_sql_mrg_view_where;
       
    nm3dbg.putln(l_sql);
       
    execute immediate l_sql using p_effective_date, p_mrg_job_id;
    p_sqlcount := sql%rowcount;
    
    commit;
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.ins_iit_tmp_values('
        ||'p_inv_type='||p_inv_type
        ||', p_mrg_job_id='||p_mrg_job_id
        ||', p_mrg_view='||p_mrg_view
        ||', p_mrg_view_where='||p_mrg_view_where
        ||', p_effective_date='||p_effective_date
        ||')');
      rollback;
      raise;

  end;

  
  
  ----------------------------------------------------------------------
  -- Support procedures
  ----------------------------------------------------------------------


  function sql_mrg_iit_record(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  ) return varchar2
  is
    l_sql varchar2(32767);
    cr    constant varchar2(1) := chr(10);
  begin
    for r in (
       select
          nvl(d.nmid_derivation, 'null') nmid_derivation
         ,tc.column_name
       from
          nm_mrg_ita_derivation d
         ,(select column_name, column_id
          from user_tab_cols
          where table_name = 'NM_INV_ITEMS_ALL') tc
       where tc.column_name = d.nmid_ita_attrib_name (+)
         and (d.nmid_ita_inv_type = p_inv_type or d.nmid_ita_inv_type is null)
       order by tc.column_id
    )
    loop
      l_sql := l_sql||cr||','||r.nmid_derivation||' '||r.column_name;
    end loop;
    return l_sql;
  end;
  
  
  
  
  function get_iit_tmp_rec(
     p_rowid in rowid
  ) return nm_inv_items_all%rowtype
  is
    l_rec nm_inv_items_all%rowtype;
  begin
    select
      iit_ne_id, iit_inv_type, iit_primary_key, iit_start_date, iit_date_created
    , iit_date_modified, iit_created_by, iit_modified_by, iit_admin_unit, iit_descr
    , iit_end_date, iit_foreign_key, iit_located_by, iit_position, iit_x_coord, iit_y_coord
    , iit_num_attrib16, iit_num_attrib17, iit_num_attrib18, iit_num_attrib19, iit_num_attrib20
    , iit_num_attrib21, iit_num_attrib22, iit_num_attrib23, iit_num_attrib24, iit_num_attrib25
    , iit_chr_attrib26, iit_chr_attrib27, iit_chr_attrib28, iit_chr_attrib29, iit_chr_attrib30
    , iit_chr_attrib31, iit_chr_attrib32, iit_chr_attrib33, iit_chr_attrib34, iit_chr_attrib35
    , iit_chr_attrib36, iit_chr_attrib37, iit_chr_attrib38, iit_chr_attrib39, iit_chr_attrib40
    , iit_chr_attrib41, iit_chr_attrib42, iit_chr_attrib43, iit_chr_attrib44, iit_chr_attrib45
    , iit_chr_attrib46, iit_chr_attrib47, iit_chr_attrib48, iit_chr_attrib49, iit_chr_attrib50
    , iit_chr_attrib51, iit_chr_attrib52, iit_chr_attrib53, iit_chr_attrib54, iit_chr_attrib55
    , iit_chr_attrib56, iit_chr_attrib57, iit_chr_attrib58, iit_chr_attrib59, iit_chr_attrib60
    , iit_chr_attrib61, iit_chr_attrib62, iit_chr_attrib63, iit_chr_attrib64, iit_chr_attrib65
    , iit_chr_attrib66, iit_chr_attrib67, iit_chr_attrib68, iit_chr_attrib69, iit_chr_attrib70
    , iit_chr_attrib71, iit_chr_attrib72, iit_chr_attrib73, iit_chr_attrib74, iit_chr_attrib75
    , iit_num_attrib76, iit_num_attrib77, iit_num_attrib78, iit_num_attrib79, iit_num_attrib80
    , iit_num_attrib81, iit_num_attrib82, iit_num_attrib83, iit_num_attrib84, iit_num_attrib85
    , iit_date_attrib86, iit_date_attrib87, iit_date_attrib88, iit_date_attrib89, iit_date_attrib90
    , iit_date_attrib91, iit_date_attrib92, iit_date_attrib93, iit_date_attrib94, iit_date_attrib95
    , iit_angle, iit_angle_txt, iit_class, iit_class_txt, iit_colour, iit_colour_txt
    , iit_coord_flag, iit_description, iit_diagram, iit_distance, iit_end_chain, iit_gap
    , iit_height, iit_height_2, iit_id_code, iit_instal_date, iit_invent_date, iit_inv_ownership
    , iit_itemcode, iit_lco_lamp_config_id, iit_length, iit_material, iit_material_txt, iit_method
    , iit_method_txt, iit_note, iit_no_of_units, iit_options, iit_options_txt
    , iit_oun_org_id_elec_board, iit_owner, iit_owner_txt, iit_peo_invent_by_id, iit_photo
    , iit_power, iit_prov_flag, iit_rev_by, iit_rev_date, iit_type, iit_type_txt, iit_width
    , iit_xtra_char_1, iit_xtra_date_1, iit_xtra_domain_1, iit_xtra_domain_txt_1, iit_xtra_number_1
    , iit_x_sect, iit_det_xsp, iit_offset, iit_x, iit_y, iit_z
    , iit_num_attrib96, iit_num_attrib97, iit_num_attrib98, iit_num_attrib99, iit_num_attrib100
    , iit_num_attrib101, iit_num_attrib102, iit_num_attrib103, iit_num_attrib104, iit_num_attrib105
    , iit_num_attrib106, iit_num_attrib107, iit_num_attrib108, iit_num_attrib109, iit_num_attrib110
    , iit_num_attrib111, iit_num_attrib112, iit_num_attrib113, iit_num_attrib114, iit_num_attrib115
    into l_rec
    from nm_mrg_derived_inv_values_tmp
    where rowid = p_rowid;
    return l_rec;
  end;
  
  
  
  
  

  procedure send_mail2(
     p_title in varchar2
    ,p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_effective_date in date
    ,p_user_id in nm_mail_users.nmu_id%type
    ,pt_lines in nm3type.tab_varchar32767
  )
  is
    t_mail        nm3type.tab_varchar32767;
    t_mail_to     nm3mail.tab_recipient;
    t_mail_cc     nm3mail.tab_recipient;
    t_mail_bcc    nm3mail.tab_recipient;
    l_css         varchar2(500);
    
    procedure putln(p_line in varchar2)
    is
    begin
      t_mail(t_mail.count+1) := p_line;
    end;
    
  begin
    nm3dbg.putln(g_package_name||'.send_mail2('
      ||'p_title='||p_title
      ||', p_inv_type='||p_inv_type
      ||', p_effective_date='||p_effective_date
      ||', p_user_id='||p_user_id
      ||', pt_lines.count='||pt_lines.count
      ||')');
    nm3dbg.ind;
    
     --This returns the value of the HIG_ST_CSS product option. this option
     --  is in place for sites who wish to use a static (i.e. not from within the RDBMS)
     --  CSS document.
     -- The text returned is in the format
     --  <LINK REL="STYLESHEET" HREF="\\Dachom17\iris\Public\iris.css">
    l_css := hig.get_sysopt('HIG_ST_CSS');
    if l_css is not null then
      l_css := htf.linkrel(
         crel => 'STYLESHEET'
        ,curl => l_css
      );
    end if;
  
    putln(htf.htmlopen);
    putln(htf.headopen);
    putln(htf.title(p_title));
    putln(l_css);
    putln(htf.headclose);
    putln(htf.bodyopen);
    putln(htf.tableopen(cattributes=>'BORDER=1'));
    --
    putln(htf.tablerowopen);
    putln(htf.tableheader('Inv Type'));
    putln(htf.tabledata(p_inv_type));
    putln(htf.tablerowclose);
    --
    putln(htf.tablerowopen);
    putln(htf.tableheader('Effective Date'));
    putln(htf.tabledata(to_char(p_effective_date, nm3user.get_user_date_mask)));
    putln(htf.tablerowclose);
    
    -- put out the event lines
    for i in 1 .. pt_lines.count loop
      putln(htf.tablerowopen);
      putln(htf.tableheader(i));
      putln(htf.tabledata(pt_lines(i)));
      putln(htf.tablerowclose);
    end loop;

    putln(htf.tableclose);
    putln(htf.bodyclose);
    putln(htf.htmlclose);
      
    t_mail_to(1).rcpt_id   := p_user_id;
    t_mail_to(1).rcpt_type := nm3mail.c_user;
    t_mail_cc(1)           := t_mail_to(1);
    t_mail_cc(1).rcpt_id   := get_nmu_id_for_hig_owner;
    if t_mail_cc(1).rcpt_id = t_mail_to(1).rcpt_id then
      t_mail_cc.delete;
    end if;
    
    nm3mail.write_mail_complete(
       p_from_user        => p_user_id
      ,p_subject          => ltrim(p_title||' '||p_inv_type||' rebuild')
      ,p_html_mail        => true
      ,p_tab_to           => t_mail_to
      ,p_tab_cc           => t_mail_cc
      ,p_tab_bcc          => t_mail_bcc
      ,p_tab_message_text => t_mail
    );
    
    nm3dbg.deind;
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.send_mail2('
        ||'p_title='||p_title
        ||', p_inv_type='||p_inv_type
        ||', p_effective_date='||p_effective_date
        ||', p_user_id='||p_user_id
        ||', pt_lines.count='||pt_lines.count
        ||')');
      -- fail quietly here, the error is logged
      -- raise;
  end;

  
  
  
  
  -- this aquires a custom exclusive lock for running the rebuild on given inv type
  --  second attempt by same session also raises error
  procedure get_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  )
  is    
    l_lock_name    constant varchar2(30) := 'DA_'||p_inv_type;
    l_lock_handle  varchar2(128);
    l_lock_value   integer;
 
  begin
    nm3dbg.putln(g_package_name||'.get_lock('
      ||'p_inv_type='||p_inv_type
      ||')');
    
    if p_inv_type is null then
      raise_application_error(-20001, g_package_name||'.get_lock: bad call');
    end if;
     
    dbms_lock.allocate_unique(
       lockname         => l_lock_name
      ,lockhandle       => l_lock_handle  -- out
      ,expiration_secs  => 864000         -- default
    );
    
    l_lock_value := dbms_lock.request(
       lockhandle         => l_lock_handle
      ,lockmode           => dbms_lock.x_mode
      ,timeout            => 1
      ,release_on_commit  => false
    );
    
    -- success
    if l_lock_value = 0 then
      null;
      
    -- 1 locked by other session, 4 locked by ourselves
    elsif l_lock_value in (1, 4) then
      hig.raise_ner (
          pi_appl               => nm3type.c_net
         ,pi_id                 => 408
         ,pi_supplementary_info => p_inv_type --||' started '||to_char(l_date,nm3type.c_full_date_Time_format)
      );
    else
      raise_application_error(-20099, 'Internal dbms_lock error: '||l_lock_value);
    end if;
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.get_lock('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  
  procedure release_lock(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
  )
  is    
    l_lock_name    constant varchar2(30) := 'DA_'||p_inv_type;
    l_lock_handle  varchar2(128);
    l_lock_value   integer;
 
  begin
    nm3dbg.putln(g_package_name||'.release_lock('
      ||'p_inv_type='||p_inv_type
      ||')');
      
    if p_inv_type is null then
      raise_application_error(-20001, g_package_name||'.release_lock: bad call');
    end if;
     
    dbms_lock.allocate_unique(
       lockname         => l_lock_name
      ,lockhandle       => l_lock_handle  -- out
      ,expiration_secs  => 864000         -- default
    );
    
    l_lock_value := dbms_lock.release(
       lockhandle       => l_lock_handle
    );
    
  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.release_lock('
        ||'p_inv_type='||p_inv_type
        ||')');
      raise;
    
  end;
  
  
  
  -- this loads the nm3sql id table with the criteria datum ids'
  --  taken from the element/route/extent ids passed in by pt_gaz
  -- called from do_rebuild()
  procedure load_gaz_criteria(
     pt_ne in nm_id_tbl
    ,pt_nse in nm_id_tbl
  )
  is
    i       binary_integer := pt_ne.first;
    t_group nm_id_tbl := new nm_id_tbl();
    t_datum nm_id_tbl := new nm_id_tbl();
    cur     sys_refcursor;
  begin
    nm3dbg.putln(g_package_name||'.load_gaz_criteria('
      ||'pt_ne.count='||pt_ne.count
      ||', pt_nse.count='||pt_nse.count
      ||')');
      
    -- divide the datum and group elements into different tables
    while i is not null loop
      if nm3net.element_is_a_datum(pt_ne(i)) then
        t_datum.extend;
        t_datum(t_datum.last) := pt_ne(i);
      else
        t_group.extend;
        t_group(t_group.last) := pt_ne(i);
      end if;
      i := pt_ne.next(i);
    end loop;
    
      
    -- open the distinct union query over three sources
    --  1) extents 2) datums 3) groups
    --  and load the criteria datum ids from this query
    open cur for
      select distinct id from (
        select /*+ cardinality(x 2) */ d.nsd_ne_id id
        from
           nm_saved_extent_member_datums d
          ,table(cast(pt_nse as nm_id_tbl)) x
        where d.nsd_nse_id = x.column_value
        union all
        select column_value id
        from
           table(cast(t_datum as nm_id_tbl))
        union all
        select /*+ cardinality(x2 2) */ m.nm_ne_id_of id
        from 
           nm_members m
          ,table(cast(t_group as nm_id_tbl)) x2
        where nm_ne_id_in = x2.column_value
      );
    nm3sql.load_id_tbl(cur);

  exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.load_gaz_criteria('
        ||'pt_ne.count='||pt_ne.count
        ||', pt_nse.count='||pt_nse.count
        ||')');
      raise;
    
  end;
  
  
  
  -- this returns the progress message from session_longops system view
  --  the do_rebuild is updating the longops record as it progresses
  --  the p_context is user specified number
  --    in our case it is the job_no of the dbms_job that that started the rebuild
  function get_progress_text(
     p_inv_type in nm_inv_types_all.nit_inv_type%type
    ,p_job_no in binary_integer
  ) return varchar2
  is
    l_text varchar2(512 byte);
  begin
    if p_job_no is not null then
      select o.message into l_text
      from sys.v_$session_longops o
      where o.target_desc = p_inv_type
        and o.context = p_job_no;
    end if;
    return l_text;
  exception
    when no_data_found then
      return '#error: Operation not found';
    when too_many_rows then
      return '#error: Duplicate operation';
  end;
    
    
    
  
  
  
  function to_string_attrib_tbl(p_tbl in attrib_tbl) return varchar2
  is
    l_ret varchar2(32767);
    i     binary_integer := p_tbl.first;
  begin
    while i is not null loop
      l_ret := l_ret||'('||p_tbl(i).name||' '||p_tbl(i).value||')';
      i := p_tbl.next(i);
    end loop;
    return '('||l_ret||')';
  end;
  
  
  

--
-----------------------------------------------------------------------------
--
END;
/
