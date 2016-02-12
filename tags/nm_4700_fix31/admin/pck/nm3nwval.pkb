CREATE OR REPLACE PACKAGE BODY Nm3nwval AS
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3nwval.pkb-arc   2.16   Feb 12 2016 17:13:50   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3nwval.pkb  $
--       Date into PVCS   : $Date:   Feb 12 2016 17:13:50  $
--       Date fetched Out : $Modtime:   Feb 12 2016 17:13:08  $
--       PVCS Version     : $Revision:   2.16  $
--       Based on 1.67
--  
--
--   Author : Jonathan Mills
--
--   nm3nwval package
--
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.16  $"';
--  g_body_sccsid is the SCCS ID for the package body
-----------------------------------------------------------------------------
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3nwval';
--
--all global package variables here

  c_nl CONSTANT VARCHAR2(1) := CHR(10);
--
-- Exception variables
   g_nwval_exception EXCEPTION;
   g_nwval_exc_code  NUMBER;
   g_nwval_exc_msg   VARCHAR2(4000);
--
   g_ne_id_in      NUMBER ;
   g_admin_unit    NUMBER ;
   g_ne_id_of      NUMBER ;
   g_ne_group      VARCHAR2(30);
   g_start_node    NUMBER ;
   g_slk           NUMBER ;
   g_seq_no        NUMBER ;   
--
   g_tab_nm_elements_cols Nm3type.tab_varchar30;
--
   l_empty_rec_ne  nm_elements%ROWTYPE;
--
 --  g_block VARCHAR2(32767);
--
   -- This CURSOR returns all rows from NM_TYPE_COLUMNS
   CURSOR cs_ntc (c_nt_type NM_TYPE_COLUMNS.ntc_nt_type%TYPE) IS
   SELECT *
    FROM  NM_TYPE_COLUMNS
   WHERE  ntc_nt_type = c_nt_type;
--
   -- This CURSOR returns rows from NM_TYPE_COLUMNS where the UNIQUE_SEQ is present (order by unique_seq)
   CURSOR cs_ntc_seq (c_nt_type NM_TYPE_COLUMNS.ntc_nt_type%TYPE) IS
   SELECT *
    FROM  NM_TYPE_COLUMNS
   WHERE  ntc_nt_type = c_nt_type
    AND   ntc_unique_seq IS NOT NULL
   ORDER BY ntc_unique_seq;
--
   CURSOR cs_cols_in_elements (c_owner VARCHAR2
                              ,c_table VARCHAR2
                              ) IS
   SELECT column_name
    FROM  all_tab_columns
   WHERE  owner      = c_owner
    AND   table_name = c_table;
--
   g_tab_vc Nm3type.tab_varchar32767;
   --
   --<USED IN calc_end_slk_and_true>
   g_parent_units     NM_UNITS.un_unit_id%TYPE;
   g_is_linear_inv    BOOLEAN;
   g_last_nm_ne_id_in nm_members.nm_ne_id_in%TYPE;
   g_datum_units      NM_UNITS.un_unit_id%TYPE;
   g_last_nm_ne_id_of nm_members.nm_ne_id_of%TYPE;
   --</USED IN calc_end_slk_and_true>

   TYPE t_nng_val_tab IS TABLE OF t_nng_val_rec INDEX BY BINARY_INTEGER;

   g_nng_val_tab t_nng_val_tab;

   --nm_type_columns validation tabes
   TYPE t_ntc_tab IS TABLE OF NM_TYPE_COLUMNS%ROWTYPE INDEX BY BINARY_INTEGER;

   --variables for ntc triggers
   g_ntc_val_old_tab t_ntc_tab;
   g_ntc_val_new_tab t_ntc_tab;
   g_processing_ntc_val_tab BOOLEAN := FALSE;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE);
--
-----------------------------------------------------------------------------
function check_asset_closure_on_element( pi_ne_id in nm_elements.ne_id%type ) return Boolean;
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
PROCEDURE add_member_to_link(p_ne_id_in      IN      NUMBER
                            ,p_admin_unit    IN      NUMBER
                            ,p_ne_id_of      IN      NUMBER
                            ,p_ne_group      IN      VARCHAR2
                            ,p_start_node    IN      NUMBER
                            ,p_slk           IN      NUMBER
                            ,p_seq_no        IN      NUMBER
                            ) IS
--
   l_rec_nm nm_members%ROWTYPE;
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'add_member_to_link');

   l_rec_nm.nm_ne_id_in            := p_ne_id_in;
   l_rec_nm.nm_ne_id_of            := p_ne_id_of;
   l_rec_nm.nm_type                := 'G';
   l_rec_nm.nm_obj_type            := p_ne_group;
   l_rec_nm.nm_begin_mp            := 0;
   l_rec_nm.nm_start_date          := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_rec_nm.nm_end_date            := NULL;
   l_rec_nm.nm_end_mp              := NULL;
   l_rec_nm.nm_slk                 := p_slk;
   l_rec_nm.nm_cardinality         := 1;
   l_rec_nm.nm_admin_unit          := p_admin_unit;
   l_rec_nm.nm_seq_no              := p_seq_no;
   l_rec_nm.nm_seg_no              := NULL;
   l_rec_nm.nm_true                := NULL;
--
   Nm3net.ins_nm (l_rec_nm);
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'add_member_to_link');
END add_member_to_link;
--
-----------------------------------------------------------------------------
--

PROCEDURE strip_ne_unique (p_ne_unique     IN      VARCHAR2
                          ,p_ne_nt_type    IN      VARCHAR2
                          ,p_ne_owner      IN OUT  VARCHAR2
                          ,p_ne_name_1     IN OUT  VARCHAR2
                          ,p_ne_name_2     IN OUT  VARCHAR2
                          ,p_ne_prefix     IN OUT  VARCHAR2
                          ,p_ne_number     IN OUT  VARCHAR2
                          ,p_ne_sub_type   IN OUT  VARCHAR2
                          ,p_ne_no_start   IN OUT  NUMBER
                          ,p_ne_no_end     IN OUT  NUMBER
                          ,p_ne_sub_class  IN OUT  VARCHAR2
                          ,p_ne_nsg_ref    IN OUT  VARCHAR2
                          ,p_ne_version_no IN OUT  VARCHAR2
                          ,p_ne_group      IN OUT  VARCHAR2
                          ) IS
--
   v_ntc_unique    VARCHAR2(30) := p_ne_unique ;
   v_ntc_column_name VARCHAR2(30);
   v_start_point   NUMBER := 1;
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'strip_ne_unique');

   --initialise record with current data
   g_dyn_rec_ne               := l_empty_rec_ne;
   g_dyn_rec_ne.ne_unique     := p_ne_unique;
   g_dyn_rec_ne.ne_owner      := p_ne_owner;
   g_dyn_rec_ne.ne_name_1     := p_ne_name_1;
   g_dyn_rec_ne.ne_name_2     := p_ne_name_2;
   g_dyn_rec_ne.ne_prefix     := p_ne_prefix;
   g_dyn_rec_ne.ne_number     := p_ne_number;
   g_dyn_rec_ne.ne_sub_type   := p_ne_sub_type;
   g_dyn_rec_ne.ne_no_start   := p_ne_no_start;
   g_dyn_rec_ne.ne_no_end     := p_ne_no_end;
   g_dyn_rec_ne.ne_sub_class  := p_ne_sub_class;
   g_dyn_rec_ne.ne_nsg_ref    := p_ne_nsg_ref;
   g_dyn_rec_ne.ne_version_no := p_ne_version_no;
   g_dyn_rec_ne.ne_group      := p_ne_group;
--
   g_tab_vc.DELETE;
   append('DECLARE',FALSE);
   append('   c_unique CONSTANT nm_elements.ne_unique%TYPE := '||g_package_name||'.g_dyn_rec_ne.ne_unique;');
   append('   l_start_point     BINARY_INTEGER := 1;');
   append('BEGIN');
   append('   NULL;');
--
   FOR rec IN cs_ntc_seq (p_ne_nt_type)
    LOOP
      IF rec.ntc_separator IS NOT NULL
       THEN
         append('   '||g_package_name||'.g_dyn_rec_ne.'||rec.ntc_column_name||' := SUBSTR(c_unique,l_start_point,INSTR(c_unique,'||Nm3flx.string(rec.ntc_separator)||',l_start_point )-l_start_point);');
      ELSE
         append('   '||g_package_name||'.g_dyn_rec_ne.'||rec.ntc_column_name||' := SUBSTR(c_unique,l_start_point,'||rec.ntc_str_length||');');
      END IF;
      append('   IF '||g_package_name||'.g_dyn_rec_ne.'||rec.ntc_column_name||' IS NOT NULL');
      append('    THEN');
      IF rec.ntc_separator IS NOT NULL
       THEN
         append('      l_start_point := l_start_point + NVL(LENGTH('||g_package_name||'.g_dyn_rec_ne.'||rec.ntc_column_name||'),0) + NVL(LENGTH('||Nm3flx.string(rec.ntc_separator)||'),0);');
      ELSE
         append('      l_start_point := l_start_point + NVL(LENGTH('||g_package_name||'.g_dyn_rec_ne.'||rec.ntc_column_name||'),0);');
      END IF;
      append('   END IF;');
   END LOOP;
   append ('END;');
--   nm_debug.debug(g_block);
--         nm_debug.debug(nm3ddl.g_tab_varchar(1),-1);
   Nm3ddl.execute_tab_varchar (g_tab_vc);
--
   -- Copy the values back from the global record
   p_ne_owner      := g_dyn_rec_ne.ne_owner;
   p_ne_name_1     := g_dyn_rec_ne.ne_name_1;
   p_ne_name_2     := g_dyn_rec_ne.ne_name_2;
   p_ne_prefix     := g_dyn_rec_ne.ne_prefix;
   p_ne_number     := g_dyn_rec_ne.ne_number;
   p_ne_sub_type   := g_dyn_rec_ne.ne_sub_type;
   p_ne_no_start   := g_dyn_rec_ne.ne_no_start;
   p_ne_no_end     := g_dyn_rec_ne.ne_no_end;
   p_ne_sub_class  := g_dyn_rec_ne.ne_sub_class;
   p_ne_nsg_ref    := g_dyn_rec_ne.ne_nsg_ref;
   p_ne_version_no := g_dyn_rec_ne.ne_version_no;
   p_ne_group      := g_dyn_rec_ne.ne_group;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'strip_ne_unique');
END strip_ne_unique ;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_nw_element_cols (p_ne_nt_type    IN OUT  VARCHAR2
                                   ,p_ne_owner      IN OUT  VARCHAR2
                                   ,p_ne_name_1     IN OUT  VARCHAR2
                                   ,p_ne_name_2     IN OUT  VARCHAR2
                                   ,p_ne_prefix     IN OUT  VARCHAR2
                                   ,p_ne_number     IN OUT  VARCHAR2
                                   ,p_ne_sub_type   IN OUT  VARCHAR2
                                   ,p_ne_no_start   IN OUT  NUMBER
                                   ,p_ne_no_end     IN OUT  NUMBER
                                   ,p_ne_sub_class  IN OUT  VARCHAR2
                                   ,p_ne_nsg_ref    IN OUT  VARCHAR2
                                   ,p_ne_version_no IN OUT  VARCHAR2
                                   ,p_ne_group      IN OUT  VARCHAR2
                                   ,p_ne_start_date IN      DATE
--
                                   ,p_ne_gty_group_type IN OUT  VARCHAR2
                                   ,p_ne_admin_unit     IN OUT  VARCHAR2
                                   ) IS

  l_default_bvs_tab Nm3type.tab_varchar80;

  l_exe_imm_str Nm3type.max_varchar2;

BEGIN
--
  nm_debug.debug('start validate_nw_element_cols');

   Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'validate_nw_element_cols');

   g_dyn_rec_ne               := l_empty_rec_ne;
--
   g_dyn_rec_ne.ne_nt_type    := p_ne_nt_type;
   g_dyn_rec_ne.ne_owner      := p_ne_owner;
   g_dyn_rec_ne.ne_name_1     := p_ne_name_1;
   g_dyn_rec_ne.ne_name_2     := p_ne_name_2;
   g_dyn_rec_ne.ne_prefix     := p_ne_prefix;
   g_dyn_rec_ne.ne_number     := p_ne_number;
   g_dyn_rec_ne.ne_sub_type   := p_ne_sub_type;
   g_dyn_rec_ne.ne_no_start   := p_ne_no_start;
   g_dyn_rec_ne.ne_no_end     := p_ne_no_end;
   g_dyn_rec_ne.ne_sub_class  := p_ne_sub_class;
   g_dyn_rec_ne.ne_nsg_ref    := p_ne_nsg_ref;
   g_dyn_rec_ne.ne_version_no := p_ne_version_no;
   g_dyn_rec_ne.ne_group      := p_ne_group;
   g_dyn_rec_ne.ne_start_date := p_ne_start_date;

   g_dyn_rec_ne.ne_gty_group_type := p_ne_gty_group_Type;
   g_dyn_rec_ne.ne_admin_unit     := p_ne_admin_unit;


--
   g_tab_vc.DELETE;
   append('DECLARE',FALSE);
   append('  l_sql nm3type.max_varchar2;');

   append('BEGIN');
   append('   NULL;');
--
   FOR cs_rec IN cs_ntc (p_ne_nt_type)
    LOOP
      IF cs_rec.ntc_domain IS NOT NULL
       THEN
         append('   -- ntc_domain');
         append('   IF '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' IS NOT NULL');
         append('    THEN');
         append('      hig.valid_fk_hco(pi_hco_domain     => '||Nm3flx.string(cs_rec.ntc_domain));
         append('                      ,pi_hco_code       => '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name);
         append('                      ,pi_effective_date => '||g_package_name||'.g_dyn_rec_ne.ne_start_date');
         append('                      );');
         append('   END IF;');
      END IF;
      IF cs_rec.ntc_query IS NOT NULL
       THEN
         DECLARE
            l_bind_var VARCHAR2(2000);
         BEGIN
            l_bind_var := Nm3flx.extract_bind_variable(cs_rec.ntc_query,1);

--    This IF is in here to allow the query still to fire if the lookup is on a table other than NM_ELEMENTS to prevent mutation
--



            IF INSTR(UPPER(cs_rec.ntc_query),'NM_ELEMENTS',1) = 0
             THEN -- Allow

               append ('   -- ntc_query');

               append('DECLARE');
               append('  l_meaning VARCHAR2(2000);');
               append('  l_id VARCHAR2(2000);');
               append('  ex_value_not_found   EXCEPTION;');
               append('     PRAGMA EXCEPTION_INIT(ex_value_not_found,-20699);');

               append('BEGIN');
               append(' IF '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' IS NOT NULL THEN');


               IF l_bind_var IS NOT NULL THEN
                      append('--');
                      append('-- The query string for this col has a bind variable so cater for it');
                      append('--');
                      append('  '||g_package_name||'.g_ntc_query := nm3flx.build_lov_sql_string (p_nt_type                    => '||Nm3flx.string(g_dyn_rec_ne.ne_nt_type));
                  append('                                                                  ,p_column_name                => '||Nm3flx.string(cs_rec.ntc_column_name));
                  append('                                                                  ,p_include_bind_variable      => FALSE');
                  append('                                                                  ,p_replace_bind_variable_with => '||g_package_name||'.g_dyn_rec_ne.'||REPLACE(l_bind_var,':',NULL)||');');
                  append(' ');
                 ELSE
                  -- GJ all the CHR(39) bit is to do is to deal with query strings that already have ' in them
                  -- e.g.
                  -- SELECT NSC_SUB_CLASS, NSC_SUB_CLASS NSC_MEANING, Null NSC_ID FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = 'L'
                  -- needs to be converted to
                  -- 'SELECT NSC_SUB_CLASS, NSC_SUB_CLASS NSC_MEANING, Null NSC_ID FROM NM_TYPE_SUBCLASS WHERE NSC_NW_TYPE = ''L'''
                  -- to make the dynamic sql block valid
                  append('   '||g_package_name||'.g_ntc_query := '||Nm3flx.string(REPLACE(cs_rec.ntc_query,CHR(39),CHR(39)||CHR(39)))||';');
               END IF;


               append(' ');
               append(' ');
               append(' ');
               append('    nm3extlov.validate_lov_value(p_statement => '||g_package_name||'.g_ntc_query');
               append('                                ,p_value     => '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name);
               append('                                ,p_meaning   => l_meaning');
               append('                                ,p_id        => l_id');
               append('                                ,pi_match_col => 3);');
               append(' END IF;');
               append(' ');
               append(' ');
               append(' ');

               append('EXCEPTION WHEN ex_value_not_found THEN');
               append('         hig.raise_ner(pi_appl               => nm3type.c_net');
               append('                      ,pi_id                 => 389');
               append('                      ,pi_supplementary_info => '||Nm3flx.string(cs_rec.ntc_prompt)||'||chr(10)||'||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||');');
               append('END;');
           END IF;

         END;




      END IF;
      IF cs_rec.ntc_seq_name IS NOT NULL
       THEN
         append('   -- ntc_seq_name');
         append('   IF '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' IS NULL');
         append('    THEN');
         append('      DECLARE');
         append('         CURSOR cs_nextval IS');
         append('         SELECT '||cs_rec.ntc_seq_name||'.NEXTVAL FROM DUAL;');
         append('         l_nextval BINARY_INTEGER;');
         append('      BEGIN');
         append('         OPEN  cs_nextval;');
         append('         FETCH cs_nextval INTO l_nextval;');
         append('         CLOSE cs_nextval;');
         append('         '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' := TO_CHAR(l_nextval);');
         append('      END;');
         append('   END IF;');
      END IF;

      IF cs_rec.ntc_default IS NOT NULL
       THEN
         append('   -- ntc_default');
         append('   IF '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' IS NULL');
         append('    THEN');

         --get any bind variables in default string
         l_default_bvs_tab := Nm3flx.extract_all_bind_variables(pi_string => cs_rec.ntc_default);

         IF is_nm_elements_col (cs_rec.ntc_default)
          THEN
            -----------------------------------------
           --default is another column in nm_elements
           ------------------------------------------
            append('      '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' := '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_default||';');

         ELSIF l_default_bvs_tab.COUNT > 0
         THEN
           -------------------------------------------
           --default is a function with bind variables
           -------------------------------------------
           append('      l_sql := ''SELECT ' || Nm3flx.repl_quotes_amps_for_dyn_sql(p_text_in => cs_rec.ntc_default) || ' FROM dual'';');

           l_exe_imm_str := '      EXECUTE IMMEDIATE l_sql INTO ' || g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name || ' USING ' ;

           --add using variables, these will be columns stored in the global record
           FOR l_i IN 1..l_default_bvs_tab.COUNT
           LOOP
             l_exe_imm_str := l_exe_imm_str || g_package_name||'.g_dyn_rec_ne.' || REPLACE(l_default_bvs_tab(l_i), ':', '') || ',';
           END LOOP;

           l_exe_imm_str := SUBSTR(l_exe_imm_str, 1, LENGTH(l_exe_imm_str) - 1) || ';';

           append(l_exe_imm_str);
         ELSE
            ---------------------------
            --default is simply a value
            ---------------------------

            -- Start Log 36516
            -- 

            if instr(cs_rec.ntc_default,CHR(39),1) = 0 then
               append('      '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' := '||Nm3flx.string(cs_rec.ntc_default)||';');
            else
               append('      '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' := '||cs_rec.ntc_default||';');
            end if;    
            --
            -- End Log 36516

         END IF;
         append('   END IF;');
      END IF;
      IF cs_rec.ntc_format IS NOT NULL
       THEN
         DECLARE
            l_line_before VARCHAR2(2000);
            l_line_after  VARCHAR2(2000);
            l_before      VARCHAR2(2000);
            l_after       VARCHAR2(2000);
         BEGIN
            append('   -- ntc_format');
            IF cs_rec.ntc_column_type = Nm3type.c_date
             THEN
               l_before := 'TO_CHAR(hig.date_convert(';
               l_after  := '),'||Nm3flx.string(cs_rec.ntc_format)||')';
            ELSE
               l_line_before := 'IF nm3flx.is_numeric('||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||') THEN';
               l_line_after  := 'END IF;';
               l_before := 'LTRIM(TO_CHAR(TO_NUMBER(';
               l_after  := '),'||Nm3flx.string(cs_rec.ntc_format)||'),'||Nm3flx.string(' ')||')';
            END IF;
            append(l_line_before);
            append('      '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' := '||l_before||''||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||l_after||';');
            append(l_line_after);
         END;
      END IF;
      IF    cs_rec.ntc_column_type = Nm3type.c_varchar
       THEN
         append('   -- Check varchar length');
         append('   IF LENGTH('||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||') > '||cs_rec.ntc_str_length);
         append('    THEN');
         append('      hig.raise_ner(pi_appl               => nm3type.c_net');
         append('                   ,pi_id                 => 275');
         append('                   ,pi_supplementary_info => '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name);
         append('                   );');
         append('   END IF;');
      ELSIF cs_rec.ntc_column_type = Nm3type.c_number
       THEN
         append('   -- Check numeric');
         append('   IF NOT nm3flx.is_numeric('||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||')');
         append('    THEN');
         append('      hig.raise_ner(pi_appl               => nm3type.c_hig');
         append('                   ,pi_id                 => 111');
         append('                   ,pi_supplementary_info => '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name);
         append('                   );');
         append('   END IF;');
      ELSIF cs_rec.ntc_column_type = Nm3type.c_date
       THEN
         append('   -- Check date');
         append('   IF   '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' IS NOT NULL');
         append('    AND hig.date_convert('||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||') IS NULL');
         append('    THEN');
         append('      hig.raise_ner(pi_appl               => nm3type.c_hig');
         append('                   ,pi_id                 => 148');
         append('                   ,pi_supplementary_info => '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name);
         append('                   );');
         append('   END IF;');
      END IF;
   END LOOP;
--
   append('END;');

--nm_Debug.debug_on;
--nm3tab_varchar.debug_tab_varchar(g_tab_vc);
--nm_Debug.debug_off;
   Nm3ddl.execute_tab_varchar (g_tab_vc);
--
   p_ne_nt_type    := g_dyn_rec_ne.ne_nt_type;
   p_ne_owner      := g_dyn_rec_ne.ne_owner;
   p_ne_name_1     := g_dyn_rec_ne.ne_name_1;
   p_ne_name_2     := g_dyn_rec_ne.ne_name_2;
   p_ne_prefix     := g_dyn_rec_ne.ne_prefix;
   p_ne_number     := g_dyn_rec_ne.ne_number;
   p_ne_sub_type   := g_dyn_rec_ne.ne_sub_type;
   p_ne_no_start   := g_dyn_rec_ne.ne_no_start;
   p_ne_no_end     := g_dyn_rec_ne.ne_no_end;
   p_ne_sub_class  := g_dyn_rec_ne.ne_sub_class;
   p_ne_nsg_ref    := g_dyn_rec_ne.ne_nsg_ref;
   p_ne_version_no := g_dyn_rec_ne.ne_version_no;
   p_ne_group      := g_dyn_rec_ne.ne_group;
--
   g_dyn_rec_ne    := l_empty_rec_ne;
--
  nm_debug.debug('end validate_nw_element_cols');
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'validate_nw_element_cols');
END validate_nw_element_cols;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_ne_unique (p_ne_unique        OUT VARCHAR2
                           ,p_ne_nt_type    IN     VARCHAR2
                           ,p_ne_owner      IN     VARCHAR2
                           ,p_ne_name_1     IN     VARCHAR2
                           ,p_ne_name_2     IN     VARCHAR2
                           ,p_ne_prefix     IN     VARCHAR2
                           ,p_ne_number     IN     VARCHAR2
                           ,p_ne_sub_type   IN     VARCHAR2
                           ,p_ne_no_start   IN     NUMBER
                           ,p_ne_no_end     IN     NUMBER
                           ,p_ne_sub_class  IN     VARCHAR2
                           ,p_ne_nsg_ref    IN     VARCHAR2
                           ,p_ne_version_no IN     VARCHAR2
                           ,p_ne_group      IN     VARCHAR2
                           ) IS
--
   l_ne_flex_cols_rec Nm3nwval.t_ne_flex_cols_rec;

   l_some_to_substr BOOLEAN := FALSE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'create_ne_unique');
--
   --get formatted values of flex columns
  l_ne_flex_cols_rec.ne_owner        := p_ne_owner;
  l_ne_flex_cols_rec.ne_name_1     := p_ne_name_1;
  l_ne_flex_cols_rec.ne_name_2     := p_ne_name_2;
  l_ne_flex_cols_rec.ne_prefix     := p_ne_prefix;
  l_ne_flex_cols_rec.ne_number     := p_ne_number;
  l_ne_flex_cols_rec.ne_sub_type   := p_ne_sub_type;
  l_ne_flex_cols_rec.ne_sub_class  := p_ne_sub_class;
  l_ne_flex_cols_rec.ne_nsg_ref    := p_ne_nsg_ref;
  l_ne_flex_cols_rec.ne_version_no := p_ne_version_no;
  l_ne_flex_cols_rec.ne_group      := p_ne_group;

  Nm3nwval.get_unique_formatted_flex_cols(pi_ne_nt_type        => p_ne_nt_type
                                         ,pio_ne_flex_cols_rec => l_ne_flex_cols_rec);

   g_dyn_rec_ne               := l_empty_rec_ne;
--
   g_dyn_rec_ne.ne_nt_type    := p_ne_nt_type;
   g_dyn_rec_ne.ne_owner      := l_ne_flex_cols_rec.ne_owner;
   g_dyn_rec_ne.ne_name_1     := l_ne_flex_cols_rec.ne_name_1;
   g_dyn_rec_ne.ne_name_2     := l_ne_flex_cols_rec.ne_name_2;
   g_dyn_rec_ne.ne_prefix     := l_ne_flex_cols_rec.ne_prefix;
   g_dyn_rec_ne.ne_number     := l_ne_flex_cols_rec.ne_number;
   g_dyn_rec_ne.ne_sub_type   := l_ne_flex_cols_rec.ne_sub_type;
   g_dyn_rec_ne.ne_no_start   := p_ne_no_start;
   g_dyn_rec_ne.ne_no_end     := p_ne_no_end;
   g_dyn_rec_ne.ne_sub_class  := l_ne_flex_cols_rec.ne_sub_class;
   g_dyn_rec_ne.ne_nsg_ref    := l_ne_flex_cols_rec.ne_nsg_ref ;
   g_dyn_rec_ne.ne_version_no := l_ne_flex_cols_rec.ne_version_no;
   g_dyn_rec_ne.ne_group      := l_ne_flex_cols_rec.ne_group;
--
   g_tab_vc.DELETE;
   append('BEGIN',FALSE);
--
   FOR cs_rec IN cs_ntc (p_ne_nt_type)
    LOOP
      IF   cs_rec.ntc_string_start IS NOT NULL
       AND cs_rec.ntc_string_end   IS NOT NULL
       AND cs_rec.ntc_column_type = 'VARCHAR2'
       THEN
         append('   '||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||' := nm3flx.mid('||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||','||cs_rec.ntc_string_start||','||cs_rec.ntc_string_end||');');
         l_some_to_substr := TRUE;
      END IF;
   END LOOP;
   append('END;');
   IF l_some_to_substr
    THEN

--nm_debug.debug_on;
--nm3tab_varchar.debug_tab_varchar(g_tab_vc);
      Nm3ddl.execute_tab_varchar (g_tab_vc);
   END IF;
   g_tab_vc.DELETE;
   append('DECLARE',FALSE);
   append('   l_unique nm_elements.ne_unique%TYPE;');
   append('BEGIN');
   FOR cs_rec IN cs_ntc_seq (p_ne_nt_type)
    LOOP
      --
      append('   l_unique := l_unique||'||g_package_name||'.g_dyn_rec_ne.'||cs_rec.ntc_column_name||'||'||Nm3flx.string(cs_rec.ntc_separator)||';');
      --
   END LOOP;
   append('   '||g_package_name||'.g_dyn_rec_ne.ne_unique := l_unique;');
   append('END;');

--nm3tab_varchar.debug_tab_varchar(g_tab_vc);
   Nm3ddl.execute_tab_varchar (g_tab_vc);
--
   p_ne_unique  := UPPER(g_dyn_rec_ne.ne_unique);
--
   g_dyn_rec_ne := l_empty_rec_ne;
--
   Nm_Debug.proc_end(g_package_name,'create_ne_unique');
--
END create_ne_unique;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_and_add_member_to_link (p_ne_nt_type    IN      VARCHAR2
                                       ,p_ne_id         IN      NUMBER
                                       ,p_ne_group      IN      VARCHAR2
                                       ,p_ne_owner      IN      VARCHAR2
                                       ,p_ne_name_1     IN      VARCHAR2
                                       ,p_ne_name_2     IN      VARCHAR2
                                       ,p_ne_prefix     IN      VARCHAR2
                                       ,p_ne_number     IN      VARCHAR2
                                       ,p_ne_sub_type   IN      VARCHAR2
                                       ,p_ne_no_start   IN      NUMBER
                                       ,p_ne_no_end     IN      NUMBER
                                       ,p_ne_sub_class  IN      VARCHAR2
                                       ,p_ne_nsg_ref    IN      VARCHAR2
                                       ,p_ne_version_no IN      VARCHAR2
                                       ) IS
--
   CURSOR cs_nti_by_child (c_nt_type NM_TYPE_INCLUSION.nti_nw_child_type%TYPE) IS
   SELECT *
    FROM  NM_TYPE_INCLUSION
   WHERE  nti_nw_child_type = c_nt_type;
--
   l_rec_nti       NM_TYPE_INCLUSION%ROWTYPE;
   v_l_ne_id       NUMBER;
   v_query_string  VARCHAR2(4000);
   v_admin_unit    NUMBER;
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_and_add_member_to_link');

   OPEN  cs_nti_by_child (p_ne_nt_type);
   FETCH cs_nti_by_child INTO l_rec_nti;
   IF cs_nti_by_child%NOTFOUND
    OR l_rec_nti.nti_auto_include != 'Y'
    THEN
      CLOSE cs_nti_by_child;
      RETURN; -- Can't do anything without NM_TYPE_INCLUSION records
   END IF;
   CLOSE cs_nti_by_child;
--
   g_dyn_rec_ne               := l_empty_rec_ne;
--
   g_dyn_rec_ne.ne_nt_type    := p_ne_nt_type;
   g_dyn_rec_ne.ne_owner      := p_ne_owner;
   g_dyn_rec_ne.ne_name_1     := p_ne_name_1;
   g_dyn_rec_ne.ne_name_2     := p_ne_name_2;
   g_dyn_rec_ne.ne_prefix     := p_ne_prefix;
   g_dyn_rec_ne.ne_number     := p_ne_number;
   g_dyn_rec_ne.ne_sub_type   := p_ne_sub_type;
   g_dyn_rec_ne.ne_no_start   := p_ne_no_start;
   g_dyn_rec_ne.ne_no_end     := p_ne_no_end;
   g_dyn_rec_ne.ne_sub_class  := p_ne_sub_class;
   g_dyn_rec_ne.ne_nsg_ref    := p_ne_nsg_ref;
   g_dyn_rec_ne.ne_version_no := p_ne_version_no;
   g_dyn_rec_ne.ne_group      := p_ne_group;
--
   v_query_string :=            'SELECT ne_id'
                     ||CHR(10)||'      ,ne_admin_unit'
                     ||CHR(10)||' FROM  nm_elements'
                     ||CHR(10)||'WHERE  ne_nt_type = '||Nm3flx.string(l_rec_nti.nti_nw_parent_type)
                     ||CHR(10)||' AND   '||l_rec_nti.nti_parent_column||' = nm3reclass.g_dyn_rec_ne.'||l_rec_nti.nti_child_column;
   EXECUTE IMMEDIATE v_query_string INTO v_l_ne_id ,v_admin_unit ;
--
 -- ###################################################################################################################
 --
 --   NOTHING TO DO WITH ME FROM HERE UNTIL THEN END OF THE PROC - JM 10/07/01
 --
 -- ###################################################################################################################
    g_ne_id_in      := v_l_ne_id;
    g_admin_unit    := v_admin_unit;
    g_ne_id_of      := p_ne_id ;
    g_ne_group      := p_ne_group ;
    g_start_node    := p_ne_no_start;
    DECLARE
            CURSOR c1 IS SELECT     nm_slk + ne_length ,  -- UNITS???????
                                            nm_seq_no + 1 -- CODE CONTROL COLS?????????????
                            FROM            nm_elements ,
                                            nm_members
                            WHERE           nm_ne_id_in = g_ne_id_in
                            AND             nm_ne_id_of = ne_id
                            AND             ne_no_end = g_start_node;

    BEGIN
            OPEN c1;
            FETCH c1 INTO g_slk,g_seq_no;
            CLOSE c1;
/*

            SELECT  nm_slk + ne_length ,
                            nm_seq_no + 1
            INTO            g_slk,
                            g_seq_no
            FROM            nm_elements ,
                            nm_members
            WHERE           nm_ne_id_in = g_ne_id_in
            AND             nm_ne_id_of = ne_id
            AND             ne_no_end = g_start_node;*/
    EXCEPTION
            WHEN NO_DATA_FOUND THEN
                    g_slk := 0;
                    g_seq_no  := 1;
    END;
--              nm3nwval.add_member_to_link(v_l_ne_id, v_admin_unit, p_ne_id , p_ne_group ,p_ne_no_start) ;
--
   g_dyn_rec_ne               := l_empty_rec_ne;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_and_add_member_to_link');
END check_and_add_member_to_link;
--
----------------------------------------------------------------------------
--
PROCEDURE validate_element_for_update  (p_ne_id                   IN OUT nm_elements.ne_id%TYPE
                                       ,p_ne_unique               IN OUT nm_elements.ne_unique%TYPE
                                       ,p_ne_type                 IN OUT nm_elements.ne_type%TYPE
                                       ,p_ne_nt_type              IN OUT nm_elements.ne_nt_type%TYPE
                                       ,p_ne_descr                IN OUT nm_elements.ne_descr%TYPE
                                       ,p_ne_length               IN OUT nm_elements.ne_length%TYPE
                                       ,p_ne_admin_unit           IN OUT nm_elements.ne_admin_unit%TYPE
                                       ,p_ne_start_date           IN OUT nm_elements.ne_start_date%TYPE
                                       ,p_ne_end_date             IN OUT nm_elements.ne_end_date%TYPE
                                       ,p_ne_gty_group_type       IN OUT nm_elements.ne_gty_group_type%TYPE
                                       ,p_ne_owner                IN OUT nm_elements.ne_owner%TYPE
                                       ,p_ne_name_1               IN OUT nm_elements.ne_name_1%TYPE
                                       ,p_ne_name_2               IN OUT nm_elements.ne_name_2%TYPE
                                       ,p_ne_prefix               IN OUT nm_elements.ne_prefix%TYPE
                                       ,p_ne_number               IN OUT nm_elements.ne_number%TYPE
                                       ,p_ne_sub_type             IN OUT nm_elements.ne_sub_type%TYPE
                                       ,p_ne_group                IN OUT nm_elements.ne_group%TYPE
                                       ,p_ne_no_start             IN OUT nm_elements.ne_no_start%TYPE
                                       ,p_ne_no_end               IN OUT nm_elements.ne_no_end%TYPE
                                       ,p_ne_sub_class            IN OUT nm_elements.ne_sub_class%TYPE
                                       ,p_ne_nsg_ref              IN OUT nm_elements.ne_nsg_ref%TYPE
                                       ,p_ne_version_no           IN OUT nm_elements.ne_version_no%TYPE
                                       ) IS
BEGIN
--
   Nm_Debug.proc_start (g_package_name,'validate_element_for_update');
--
   val_nm_elements_record (p_ne_id                   => p_ne_id
                          ,p_ne_unique               => p_ne_unique
                          ,p_ne_type                 => p_ne_type
                          ,p_ne_nt_type              => p_ne_nt_type
                          ,p_ne_descr                => p_ne_descr
                          ,p_ne_length               => p_ne_length
                          ,p_ne_admin_unit           => p_ne_admin_unit
                          ,p_ne_start_date           => p_ne_start_date
                          ,p_ne_end_date             => p_ne_end_date
                          ,p_ne_gty_group_type       => p_ne_gty_group_type
                          ,p_ne_owner                => p_ne_owner
                          ,p_ne_name_1               => p_ne_name_1
                          ,p_ne_name_2               => p_ne_name_2
                          ,p_ne_prefix               => p_ne_prefix
                          ,p_ne_number               => p_ne_number
                          ,p_ne_sub_type             => p_ne_sub_type
                          ,p_ne_group                => p_ne_group
                          ,p_ne_no_start             => p_ne_no_start
                          ,p_ne_no_end               => p_ne_no_end
                          ,p_ne_sub_class            => p_ne_sub_class
                          ,p_ne_nsg_ref              => p_ne_nsg_ref
                          ,p_ne_version_no           => p_ne_version_no
                          );
--
   validate_nw_element_cols (p_ne_nt_type
                            ,p_ne_owner
                            ,p_ne_name_1
                            ,p_ne_name_2
                            ,p_ne_prefix
                            ,p_ne_number
                            ,p_ne_sub_type
                            ,p_ne_no_start
                            ,p_ne_no_end
                            ,p_ne_sub_class
                            ,p_ne_nsg_ref
                            ,p_ne_version_no
                            ,p_ne_group
                            ,p_ne_start_date
--
                            ,p_ne_gty_group_type
                            ,p_ne_admin_unit
                            );
--
   Nm_Debug.proc_end   (g_package_name,'validate_element_for_update');
--
END validate_element_for_update;
--
----------------------------------------------------------------------------
--
PROCEDURE bfr_trigger_validate_element (p_ne_id                   IN OUT nm_elements.ne_id%TYPE
                                       ,p_ne_unique               IN OUT nm_elements.ne_unique%TYPE
                                       ,p_ne_type                 IN OUT nm_elements.ne_type%TYPE
                                       ,p_ne_nt_type              IN OUT nm_elements.ne_nt_type%TYPE
                                       ,p_ne_descr                IN OUT nm_elements.ne_descr%TYPE
                                       ,p_ne_length               IN OUT nm_elements.ne_length%TYPE
                                       ,p_ne_admin_unit           IN OUT nm_elements.ne_admin_unit%TYPE
                                       ,p_ne_start_date           IN OUT nm_elements.ne_start_date%TYPE
                                       ,p_ne_end_date             IN OUT nm_elements.ne_end_date%TYPE
                                       ,p_ne_gty_group_type       IN OUT nm_elements.ne_gty_group_type%TYPE
                                       ,p_ne_owner                IN OUT nm_elements.ne_owner%TYPE
                                       ,p_ne_name_1               IN OUT nm_elements.ne_name_1%TYPE
                                       ,p_ne_name_2               IN OUT nm_elements.ne_name_2%TYPE
                                       ,p_ne_prefix               IN OUT nm_elements.ne_prefix%TYPE
                                       ,p_ne_number               IN OUT nm_elements.ne_number%TYPE
                                       ,p_ne_sub_type             IN OUT nm_elements.ne_sub_type%TYPE
                                       ,p_ne_group                IN OUT nm_elements.ne_group%TYPE
                                       ,p_ne_no_start             IN OUT nm_elements.ne_no_start%TYPE
                                       ,p_ne_no_end               IN OUT nm_elements.ne_no_end%TYPE
                                       ,p_ne_sub_class            IN OUT nm_elements.ne_sub_class%TYPE
                                       ,p_ne_nsg_ref              IN OUT nm_elements.ne_nsg_ref%TYPE
                                       ,p_ne_version_no           IN OUT nm_elements.ne_version_no%TYPE
                                       ) IS
--
   c_pop_unique CONSTANT BOOLEAN := Nm3net.is_pop_unique (p_ne_nt_type);
--
BEGIN
--

  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'bfr_trigger_validate_element');
--
--   IF p_ne_type = 'S'
--    THEN
--
      val_nm_elements_record (p_ne_id                   => p_ne_id
                             ,p_ne_unique               => p_ne_unique
                             ,p_ne_type                 => p_ne_type
                             ,p_ne_nt_type              => p_ne_nt_type
                             ,p_ne_descr                => p_ne_descr
                             ,p_ne_length               => p_ne_length
                             ,p_ne_admin_unit           => p_ne_admin_unit
                             ,p_ne_start_date           => p_ne_start_date
                             ,p_ne_end_date             => p_ne_end_date
                             ,p_ne_gty_group_type       => p_ne_gty_group_type
                             ,p_ne_owner                => p_ne_owner
                             ,p_ne_name_1               => p_ne_name_1
                             ,p_ne_name_2               => p_ne_name_2
                             ,p_ne_prefix               => p_ne_prefix
                             ,p_ne_number               => p_ne_number
                             ,p_ne_sub_type             => p_ne_sub_type
                             ,p_ne_group                => p_ne_group
                             ,p_ne_no_start             => p_ne_no_start
                             ,p_ne_no_end               => p_ne_no_end
                             ,p_ne_sub_class            => p_ne_sub_class
                             ,p_ne_nsg_ref              => p_ne_nsg_ref
                             ,p_ne_version_no           => p_ne_version_no
                             );
--
      IF   p_ne_unique IS NOT NULL
       AND NOT c_pop_unique
       THEN
         Nm3nwval.strip_ne_unique (p_ne_unique
                                  ,p_ne_nt_type
                                  ,p_ne_owner
                                  ,p_ne_name_1
                                  ,p_ne_name_2
                                  ,p_ne_prefix
                                  ,p_ne_number
                                  ,p_ne_sub_type
                                  ,p_ne_no_start
                                  ,p_ne_no_end
                                  ,p_ne_sub_class
                                  ,p_ne_nsg_ref
                                  ,p_ne_version_no
                                  ,p_ne_group
                                  );
      END IF;
--
      Nm3nwval.validate_nw_element_cols (p_ne_nt_type
                                        ,p_ne_owner
                                        ,p_ne_name_1
                                        ,p_ne_name_2
                                        ,p_ne_prefix
                                        ,p_ne_number
                                        ,p_ne_sub_type
                                        ,p_ne_no_start
                                        ,p_ne_no_end
                                        ,p_ne_sub_class
                                        ,p_ne_nsg_ref
                                        ,p_ne_version_no
                                        ,p_ne_group
                                        ,p_ne_start_date
--
                                        ,p_ne_gty_group_type
                                        ,p_ne_admin_unit                                        
                                        );
--
      IF p_ne_id IS NULL
       THEN
     p_ne_id := Nm3net.get_next_ne_id;
      END IF;
--

      IF   p_ne_unique IS NULL
       AND c_pop_unique
       THEN

         Nm3nwval.create_ne_unique (p_ne_unique
                                   ,p_ne_nt_type
                                   ,p_ne_owner
                                   ,p_ne_name_1
                                   ,p_ne_name_2
                                   ,p_ne_prefix
                                   ,p_ne_number
                                   ,p_ne_sub_type
                                   ,p_ne_no_start
                                   ,p_ne_no_end
                                   ,p_ne_sub_class
                                   ,p_ne_nsg_ref
                                   ,p_ne_version_no
                                   ,p_ne_group
                                   );

        IF p_ne_unique IS NULL
        THEN
          --unique is still null so default it to the ne_id
          p_ne_unique := TO_CHAR(p_ne_id);
        END IF;

      END IF;

--
--   END IF;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'bfr_trigger_validate_element');
END bfr_trigger_validate_element;
--
------------------------------------------------------------------------------
--
PROCEDURE val_nm_elements_record (p_ne_id                   IN nm_elements.ne_id%TYPE
                                 ,p_ne_unique               IN nm_elements.ne_unique%TYPE
                                 ,p_ne_type                 IN nm_elements.ne_type%TYPE
                                 ,p_ne_nt_type              IN nm_elements.ne_nt_type%TYPE
                                 ,p_ne_descr                IN nm_elements.ne_descr%TYPE
                                 ,p_ne_length               IN nm_elements.ne_length%TYPE
                                 ,p_ne_admin_unit           IN nm_elements.ne_admin_unit%TYPE
                                 ,p_ne_start_date           IN nm_elements.ne_start_date%TYPE
                                 ,p_ne_end_date             IN nm_elements.ne_end_date%TYPE
                                 ,p_ne_gty_group_type       IN nm_elements.ne_gty_group_type%TYPE
                                 ,p_ne_owner                IN nm_elements.ne_owner%TYPE
                                 ,p_ne_name_1               IN nm_elements.ne_name_1%TYPE
                                 ,p_ne_name_2               IN nm_elements.ne_name_2%TYPE
                                 ,p_ne_prefix               IN nm_elements.ne_prefix%TYPE
                                 ,p_ne_number               IN nm_elements.ne_number%TYPE
                                 ,p_ne_sub_type             IN nm_elements.ne_sub_type%TYPE
                                 ,p_ne_group                IN nm_elements.ne_group%TYPE
                                 ,p_ne_no_start             IN nm_elements.ne_no_start%TYPE
                                 ,p_ne_no_end               IN nm_elements.ne_no_end%TYPE
                                 ,p_ne_sub_class            IN nm_elements.ne_sub_class%TYPE
                                 ,p_ne_nsg_ref              IN nm_elements.ne_nsg_ref%TYPE
                                 ,p_ne_version_no           IN nm_elements.ne_version_no%TYPE
                                 ) IS

/* ERRORS RAISED

-- -20952 'NE_NT_TYPE not supplied'
-- -20951 'NE_UNIQUE not supplied'
-- -20953 'Invalid NE_NT_TYPE supplied'
-- -20954 'Invalid NE_TYPE supplied'
-- -20955 'NE_DESCR not supplied'
-- -20956 'NE_LENGTH not supplied'
-- -20957 'NE_ADMIN_UNIT not supplied'
-- -20958 'Invalid NE_ADMIN_UNIT supplied'
-- -20960 'NE_GTY_GROUP_TYPE must not be supplied'
-- -20961 'Invalid NE_NO_START supplied'
-- -20962 'Invalid NE_NO_END supplied'
-- -20963 'NE_GROUP must not be supplied'
-- -20964 'NE_NAME_1 must not be supplied'
-- -20965 'NE_NAME_2 must not be supplied'
-- -20966 'NE_NSG_REF must not be supplied'
-- -20967 'NE_NUMBER must not be supplied'
-- -20968 'NE_OWNER must not be supplied'
-- -20969 'NE_PREFIX must not be supplied'
-- -20970 'NE_SUB_CLASS must not be supplied'
-- -20971 'NE_SUB_TYPE must not be supplied'
-- -20972 'NE_VERSION_NO must not be supplied'
*/


        v_ne_id                   nm_elements.ne_id%TYPE := p_ne_id;
        v_ne_unique               nm_elements.ne_unique%TYPE := p_ne_unique;
        v_ne_type                 nm_elements.ne_type%TYPE := p_ne_type;
        v_ne_nt_type              nm_elements.ne_nt_type%TYPE := p_ne_nt_type;
        v_ne_descr                nm_elements.ne_descr%TYPE := p_ne_descr;
        v_ne_length               nm_elements.ne_length%TYPE := p_ne_length;
        v_ne_admin_unit           nm_elements.ne_admin_unit%TYPE := p_ne_admin_unit;
        v_ne_start_date           nm_elements.ne_start_date%TYPE := p_ne_start_date;
        v_ne_end_date             nm_elements.ne_end_date%TYPE := p_ne_end_date;
        v_ne_gty_group_type       nm_elements.ne_gty_group_type%TYPE := p_ne_gty_group_type;
        v_ne_owner                nm_elements.ne_owner%TYPE := p_ne_owner;
        v_ne_name_1               nm_elements.ne_name_1%TYPE := p_ne_name_1;
        v_ne_name_2               nm_elements.ne_name_2%TYPE := p_ne_name_2;
        v_ne_prefix               nm_elements.ne_prefix%TYPE := p_ne_prefix;
        v_ne_number               nm_elements.ne_number%TYPE := p_ne_number;
        v_ne_sub_type             nm_elements.ne_sub_type%TYPE := p_ne_sub_type;
        v_ne_group                nm_elements.ne_group%TYPE := p_ne_group;
        v_ne_no_start             nm_elements.ne_no_start%TYPE := p_ne_no_start;
        v_ne_no_end               nm_elements.ne_no_end%TYPE := p_ne_no_end;
        v_ne_sub_class            nm_elements.ne_sub_class%TYPE := p_ne_sub_class;
        v_ne_nsg_ref              nm_elements.ne_nsg_ref%TYPE := p_ne_nsg_ref;
        v_ne_version_no           nm_elements.ne_version_no%TYPE  := p_ne_version_no;
--
   l_rec_nt              NM_TYPES%ROWTYPE;
--
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'val_nm_elements_record');

   --      Validation of Non Flexible Attributes
   --      NE_ID - none required - should be populated by sequence
--
   --      NE_TYPE
   IF p_ne_type NOT IN ('S', 'G', 'P', 'D')
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 201
                   ,pi_supplementary_info => p_ne_type
                   );
   END IF;
--
--      NE_NT_TYPE
--
   IF p_ne_nt_type IS NULL
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 202
                   );
   END IF;
--
   l_rec_nt := Nm3get.get_nt (pi_nt_type => p_ne_nt_type);
--
   IF p_ne_type IN ('S','D') AND l_rec_nt.nt_datum != 'Y'
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 203
                   ,pi_supplementary_info => p_ne_nt_type
                   );
   END IF;
--
   --      NE_UNIQUE
--
   IF l_rec_nt.nt_pop_unique = 'Y'
    THEN
      -- NE_UNIQUE will be populated by the trigger.
      -- Thus No Validation Here
      NULL;
   ELSE
      IF p_ne_unique IS NULL
       THEN
         Hig.raise_ner(pi_appl               => Nm3type.c_hig
                      ,pi_id                 => 99
                      );
      END IF;
   END IF;
--
   --      NE_DESCR
   --      Free Format - must be not null
   IF  p_ne_descr IS NULL
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 204
                   );
   END IF;
--

   --      NE_ADMIN_UNIT
   IF p_ne_admin_unit IS NULL
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 205
                   );
   END IF;
--
   IF p_ne_type != 'D' THEN     -- KD 06/08/09 721802
   DECLARE
      l_rec_nau   nm_admin_units%ROWTYPE;
      l_rec_nsty  NM_AU_SUB_TYPES%ROWTYPE;
      l_suppl     VARCHAR2(100);
   BEGIN
      l_rec_nau := Nm3get.get_nau (pi_nau_admin_unit => p_ne_admin_unit);
      IF l_rec_nau.nau_admin_type != l_rec_nt.nt_admin_type
       THEN
         Hig.raise_ner(pi_appl               => Nm3type.c_hig
                      ,pi_id                 => 88
                      ,pi_supplementary_info => p_ne_admin_unit
                      );
      END IF;



     -- if the admin unit for our element has an admin unit sub-type
     -- and the sub-type polices a group then
     -- check that the admin type for the group type matches that of our element
      IF l_rec_nau.nau_nsty_sub_type IS NOT NULL THEN

       l_rec_nsty := Nm3get.get_nsty(pi_nsty_nat_admin_type => l_rec_nau.nau_admin_type
                                    ,pi_nsty_sub_type       => l_rec_nau.nau_nsty_sub_type);

        IF l_rec_nsty.nsty_ngt_group_type IS NOT NULL THEN
          IF  l_rec_nsty.nsty_ngt_group_type != v_ne_gty_group_type OR v_ne_gty_group_type IS NULL THEN
            l_suppl := 'Element should be of Group Type '||l_rec_nsty.nsty_ngt_group_type;

            Hig.raise_ner(pi_appl               => Nm3type.c_net
                         ,pi_id                 => 386
                         ,pi_supplementary_info => l_suppl);

          END IF;
       END IF;

      END IF;


   END;
   END IF;
--
   --      NE_START_DATE
   IF p_ne_start_date IS NULL
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 206
                   );
   END IF;
--
   -- NE_END_DATE
   -- Optional - therefore no validation required here
--
   --
   -- NE_GTY_GROUP_TYPE
   IF v_ne_gty_group_type IS NOT NULL
    THEN
      DECLARE
         l_rec_ngt nm_group_types%ROWTYPE;
      BEGIN
         l_rec_ngt := Nm3get.get_ngt (pi_ngt_group_type => v_ne_gty_group_type);
         IF l_rec_ngt.ngt_nt_type != l_rec_nt.nt_type
          THEN
            -- Group type NT is inconsistent with NT Type
            Hig.raise_ner(pi_appl               => Nm3type.c_net
                         ,pi_id                 => 341
                         ,pi_supplementary_info => v_ne_gty_group_type||'('||l_rec_ngt.ngt_nt_type||') != '||l_rec_nt.nt_type
                         );
         END IF;
      END;
   END IF;
--
   --  NE_LENGTH must be not null if datum
   IF   p_ne_length IS NULL
    AND l_rec_nt.nt_datum = 'Y'
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_hig
                   ,pi_id                 => 100
                   );
   END IF;
--
   -- NE_NO_START
   -- Must be a valid node for the network type
   IF NOT Nm3net.is_node_valid_for_nw_type(v_ne_no_start,v_ne_nt_type)
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 107
                   ,pi_supplementary_info => 'start'
                   );
   END IF;
--
   -- NE_NO_END
   -- Must be a valid node for the network type
   IF NOT Nm3net.is_node_valid_for_nw_type(v_ne_no_end,v_ne_nt_type)
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 107
                   ,pi_supplementary_info => 'end'
                   );
   END IF;
   --
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'val_nm_elements_record');

EXCEPTION
--
   WHEN g_nwval_exception
    THEN
      RAISE_APPLICATION_ERROR(g_nwval_exc_code,g_nwval_exc_msg);
--
END val_nm_elements_record;
--
-----------------------------------------------------------------------------
--
FUNCTION node_used(p_group   nm_elements.ne_group%TYPE
                  ,p_node_id nm_elements.ne_no_start%TYPE
                  ) RETURN VARCHAR2 IS
--
   CURSOR c1 (c_node_id nm_elements.ne_no_start%TYPE) IS
   SELECT 'Y'
    FROM  nm_elements
   WHERE  ne_group     = p_group
    AND  (ne_no_start  = c_node_id
          OR ne_no_end = c_node_id
         );
--
   l_retval VARCHAR2(1);
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'node_used');

   OPEN  c1 (p_node_id);
   FETCH c1 INTO l_retval;
   IF c1%NOTFOUND
    THEN
      l_retval := 'N';
   END IF;
   CLOSE c1;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'node_used');

   RETURN l_retval;
--
END node_used;
--
-----------------------------------------------------------------------------
--
PROCEDURE route_check  ( p_ne_no_start_new  IN nm_elements.ne_no_start%TYPE
                        ,p_ne_no_end_new    IN nm_elements.ne_no_end%TYPE
                        ,p_ne_sub_class_new IN nm_elements.ne_sub_class%TYPE
                        ,p_ne_group_new     IN nm_elements.ne_group%TYPE
                        ,p_check_only       IN VARCHAR2 DEFAULT 'N'
                        ,p_ne_id            IN nm_elements.ne_id%TYPE DEFAULT NULL
                       )
IS
   l_ne_id nm_elements.ne_id%TYPE  := p_ne_id;
--
   FUNCTION check_ne_id( pi_ne_id nm_elements.ne_id%TYPE)
   RETURN BOOLEAN
   IS
      retval BOOLEAN := FALSE;
   BEGIN
      IF pi_ne_id = l_ne_id THEN
         retval := TRUE;
      END IF;
      RETURN retval;
   END check_ne_id;
--
   PROCEDURE start_node_same_class_check ( pi_ne_no_start_new  IN nm_elements.ne_no_start%TYPE
                                          ,pi_ne_sub_class_new IN nm_elements.ne_sub_class%TYPE
                                          ,pi_ne_group_new     IN nm_elements.ne_group%TYPE
                                          ,pi_check_only       IN VARCHAR2 DEFAULT 'N'
                                         )
   IS
      CURSOR c1 ( c_node nm_elements.ne_no_start%TYPE
                 ,c_sub_class nm_elements.ne_sub_class%TYPE
                 ,c_group nm_elements.ne_group%TYPE
                )
      IS
      SELECT ne_id
      FROM nm_elements
      WHERE ne_no_start = c_node
        AND ne_group = c_group
        AND ne_sub_class = c_sub_class;
--
      l_count NUMBER := 0;
   BEGIN
      --
      -- at the start node specified check that there is only one section of the same
      -- sub_class
      -- nm_debug.debug('pi_check_only ' ||pi_check_only );
      OPEN c1 ( pi_ne_no_start_new, pi_ne_sub_class_new, pi_ne_group_new );
      FETCH c1 INTO l_count;
      IF c1%FOUND THEN
         IF (pi_check_only = 'N') THEN
            CLOSE c1;
            IF NOT check_ne_id( l_count ) THEN
               RAISE_APPLICATION_ERROR( -20100, 'Adding an element with the same sub class as one that exists at this start node.');
            END IF;
         ELSE
            FETCH c1 INTO l_count;
            IF c1%FOUND THEN
               CLOSE c1;
               RAISE_APPLICATION_ERROR( -20101, 'More that one element with this sub-class at this start node.');
            ELSE
               CLOSE c1;
            END IF;
         END IF;
      ELSE
         CLOSE c1;
      END IF;
   END start_node_same_class_check;
--
   PROCEDURE end_node_same_class_check ( pi_ne_no_end_new    IN nm_elements.ne_no_start%TYPE
                                        ,pi_ne_sub_class_new IN nm_elements.ne_sub_class%TYPE
                                        ,pi_ne_group_new     IN nm_elements.ne_group%TYPE
                                        ,pi_check_only       IN VARCHAR2 DEFAULT 'N'
                                       )
   IS
      CURSOR c1 ( c_node nm_elements.ne_no_start%TYPE
                 ,c_sub_class nm_elements.ne_sub_class%TYPE
                 ,c_group nm_elements.ne_group%TYPE
                )
      IS
      SELECT 1
      FROM nm_elements
      WHERE ne_no_end = c_node
        AND ne_group = c_group
        AND ne_sub_class = c_sub_class;
--
      l_count NUMBER;
   BEGIN
      --
      -- at the start node specified check that there is only one section of the same
      -- sub_class
      OPEN c1 ( pi_ne_no_end_new, pi_ne_sub_class_new, pi_ne_group_new );
      FETCH c1 INTO l_count;
      IF c1%FOUND THEN
         IF (pi_check_only = 'N') THEN
            CLOSE c1;
            IF NOT check_ne_id( l_count ) THEN
               RAISE_APPLICATION_ERROR( -20102, 'Adding an element with the same sub class as one that exists at this end node.');
            END IF;
         ELSE
            FETCH c1 INTO l_count;
            IF c1%FOUND THEN
               CLOSE c1;
               RAISE_APPLICATION_ERROR( -20103, 'More that one element with this sub-class at this end node.');
            ELSE
               CLOSE c1;
            END IF;
         END IF;
      ELSE
         CLOSE c1;
      END IF;
   END end_node_same_class_check;
--
   PROCEDURE start_slr_check ( pi_ne_no_start_new  IN nm_elements.ne_no_start%TYPE
                              ,pi_ne_sub_class_new IN nm_elements.ne_sub_class%TYPE
                              ,pi_ne_group_new     IN nm_elements.ne_group%TYPE
                              ,pi_check_only       IN VARCHAR2 DEFAULT 'N')
    IS
      CURSOR c1 ( c_node nm_elements.ne_no_start%TYPE
                 ,c_sub_class nm_elements.ne_sub_class%TYPE
                 ,c_group nm_elements.ne_group%TYPE
                )
      IS
      SELECT 1
      FROM nm_elements
      WHERE ne_no_start = c_node
        AND ne_group = c_group
        AND ne_sub_class = c_sub_class;

      l_count NUMBER;

    BEGIN
       OPEN c1 ( pi_ne_no_start_new, 'S', pi_ne_group_new );
       FETCH c1 INTO l_count;
       IF c1%FOUND THEN
          CLOSE c1;
          IF pi_check_only = 'N' AND
             pi_ne_sub_class_new IN ( 'L','R' ) THEN
             IF NOT check_ne_id( l_count ) THEN
                RAISE_APPLICATION_ERROR( -20104, 'A Single and Left or Right element start at this node');
             END IF;
          ELSE
             OPEN c1 ( pi_ne_no_start_new, 'L', pi_ne_group_new );
             FETCH c1 INTO l_count;
             IF c1%FOUND THEN
                CLOSE c1;
                RAISE_APPLICATION_ERROR( -20105, 'A Single and a Left element start at this node');
             ELSE
                CLOSE c1;
                OPEN c1 ( pi_ne_no_start_new, 'R', pi_ne_group_new );
                FETCH c1 INTO l_count;
                IF c1%FOUND THEN
                   CLOSE c1;
                   RAISE_APPLICATION_ERROR( -20106, 'A Single and a Right element start at this node');
                ELSE
                   CLOSE c1;
                END IF;
             END IF ;
          END IF;
       ELSE
          CLOSE c1;
       END IF;
    END start_slr_check;
--
   PROCEDURE start_check ( pi_ne_no_start_new  IN nm_elements.ne_no_start%TYPE
                          ,pi_ne_sub_class_new IN nm_elements.ne_sub_class%TYPE
                          ,pi_ne_group_new     IN nm_elements.ne_group%TYPE
                          ,pi_check_only       IN VARCHAR2 DEFAULT 'N')
   IS
      -- does an element end at this node
      CURSOR c1 ( c_node nm_elements.ne_no_start%TYPE
                 ,c_sub_class nm_elements.ne_sub_class%TYPE
                 ,c_group nm_elements.ne_group%TYPE
                )
      IS
      SELECT 1
      FROM nm_elements
      WHERE ne_no_end = c_node
        AND ne_group = c_group
        AND ne_sub_class = c_sub_class;
--
      -- elements at this start node
      CURSOR c2 ( c_node nm_elements.ne_no_start%TYPE
                 ,c_sub_class nm_elements.ne_sub_class%TYPE
                 ,c_group nm_elements.ne_group%TYPE
                )
      IS
      SELECT 1
      FROM nm_elements
      WHERE ne_no_start = c_node
        AND ne_group = c_group
        AND ne_sub_class = c_sub_class;
--
      l_count NUMBER;
      l_adding   nm_elements.ne_sub_class%TYPE := pi_ne_sub_class_new;
      l_checking VARCHAR2(1) := NULL;
   BEGIN
      IF pi_ne_sub_class_new IN ( 'L','R' ) THEN
          IF l_adding = 'L' THEN
             l_checking := 'R';
          ELSE
             l_checking := 'L';
          END IF;
--
          -- does a single end at this node
          OPEN c1 ( pi_ne_no_start_new, 'S', pi_ne_group_new );
          FETCH c1 INTO l_count;
          IF c1%FOUND THEN
             CLOSE c1;
             IF pi_check_only = 'Y' THEN
                OPEN c2 ( pi_ne_no_start_new, l_adding, pi_ne_group_new );
                FETCH c2 INTO l_count;
                IF c2%FOUND THEN
                   CLOSE c2;
                   -- is the right at the start?
                   OPEN c2 ( pi_ne_no_start_new, l_checking, pi_ne_group_new );
                   FETCH c2 INTO l_count;
                   IF c2%NOTFOUND THEN
                      CLOSE c2;
                      IF l_adding = 'L' THEN
                         RAISE_APPLICATION_ERROR(-20107,'Left Starts without a right');
                      ELSE
                         RAISE_APPLICATION_ERROR(-20108,'Right Starts without a Left');
                      END IF;
                   ELSE
                      CLOSE c2;
                   END IF;
                ELSE
                   CLOSE c2;
                END IF;
             ELSE
                -- is the right at the start?
                OPEN c2 ( pi_ne_no_start_new, l_checking , pi_ne_group_new );
                FETCH c2 INTO l_count;
                IF c2%NOTFOUND THEN
                   CLOSE c2;
                   IF l_adding = 'L' THEN
                      RAISE_APPLICATION_ERROR(-20109,'Adding a Left without a right');
                   ELSE
                      RAISE_APPLICATION_ERROR(-20110,'Adding a Right without a Left');
                   END IF;
                ELSE
                   CLOSE c2;
                END IF;
             END IF;
          ELSE
             CLOSE c1;
          END IF;
      END IF;
   END start_check;
--
   PROCEDURE end_check ( pi_ne_no_start_new  IN nm_elements.ne_no_start%TYPE
                        ,pi_ne_sub_class_new IN nm_elements.ne_sub_class%TYPE
                        ,pi_ne_group_new     IN nm_elements.ne_group%TYPE
                        ,pi_check_only       IN VARCHAR2 DEFAULT 'N')
   IS
      -- does an element end at this node
      CURSOR c1 ( c_node nm_elements.ne_no_start%TYPE
                 ,c_sub_class nm_elements.ne_sub_class%TYPE
                 ,c_group nm_elements.ne_group%TYPE
                )
      IS
      SELECT 1
      FROM nm_elements
      WHERE ne_no_start = c_node
        AND ne_group = c_group
        AND ne_sub_class = c_sub_class;
--
      -- elements at this start node
      CURSOR c2 ( c_node nm_elements.ne_no_start%TYPE
                 ,c_sub_class nm_elements.ne_sub_class%TYPE
                 ,c_group nm_elements.ne_group%TYPE
                )
      IS
      SELECT 1
      FROM nm_elements
      WHERE ne_no_end = c_node
        AND ne_group = c_group
        AND ne_sub_class = c_sub_class;
--
      l_count NUMBER;
      l_adding nm_elements.ne_sub_class%TYPE := pi_ne_sub_class_new;
      l_checking VARCHAR2(1) := NULL;
   BEGIN
      IF pi_ne_sub_class_new IN ( 'L','R' ) THEN
          IF l_adding = 'L' THEN
             l_checking := 'R';
          ELSE
             l_checking := 'L';
          END IF;
--
          -- does a single start at this node
          OPEN c1 ( pi_ne_no_start_new, 'S', pi_ne_group_new );
          FETCH c1 INTO l_count;
          IF c1%FOUND THEN
             CLOSE c1;
             IF pi_check_only = 'Y' THEN
                OPEN c2 ( pi_ne_no_start_new, l_adding, pi_ne_group_new );
                FETCH c2 INTO l_count;
                IF c2%FOUND THEN
                   CLOSE c2;
                   -- is the right at the start?
                   OPEN c2 ( pi_ne_no_start_new, l_checking, pi_ne_group_new );
                   FETCH c2 INTO l_count;
                   IF c2%NOTFOUND THEN
                      CLOSE c2;
                      IF l_adding = 'L' THEN
                         RAISE_APPLICATION_ERROR(-20111,'Left ends without a right');
                      ELSE
                         RAISE_APPLICATION_ERROR(-20112,'Right ends without a Left');
                      END IF;
                   ELSE
                      CLOSE c2;
                   END IF;
                ELSE
                   CLOSE c2;
                END IF;
             ELSE
                -- is the right at the start?
                OPEN c2 ( pi_ne_no_start_new, l_checking , pi_ne_group_new );
                FETCH c2 INTO l_count;
                IF c2%NOTFOUND THEN
                   CLOSE c2;
                   IF l_adding = 'L' THEN
                      RAISE_APPLICATION_ERROR(-20113,'Adding a Left without a right');
                   ELSE
                      RAISE_APPLICATION_ERROR(-20114,'Adding a Right without a Left');
                   END IF;
                ELSE
                   CLOSE c2;
                END IF;
             END IF;
          ELSE
             CLOSE c1;
          END IF;
      END IF;
   END end_check;
--
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'route_check');

--
-- Checks the elements sub class at a node.
--  Use check only = y if calling from network walker and only checking nodes
-- Raises the following errors
-- Raise_Application_Error( -20100, 'Adding an element with the same sub class as one that exists at this start node.');
-- Raise_Application_Error( -20101, 'More that one element with this sub-class at this start node.');
-- Raise_Application_Error( -20102, 'Adding an element with the same sub class as one that exists at this end node.');
-- Raise_Application_Error( -20103, 'More that one element with this sub-class at this end node.');
-- Raise_Application_Error( -20104, 'A Single and Left or Right element start at this node');
-- Raise_Application_Error( -20105, 'A Single and a Left element start at this node');
-- Raise_Application_Error( -20106, 'A Single and a Right element start at this node');
-- Raise_Application_Error( -20107,'Left Starts without a right');
-- Raise_Application_Error( -20108,'Right Starts without a Left');
-- Raise_Application_Error( -20109,'Adding a Left without a right');
-- Raise_Application_Error( -20110,'Adding a Right without a Left');
-- Raise_Application_Error( -20111,'Left ends without a right');
-- Raise_Application_Error( -20112,'Right ends without a Left');
-- Raise_Application_Error( -20113,'Adding a Left without a right');
-- Raise_Application_Error( -20114,'Adding a Right without a Left');
--
   IF Hig.get_sysopt('CHECKROUTE') = 'Y' THEN
      start_node_same_class_check ( pi_ne_no_start_new  => p_ne_no_start_new
                                   ,pi_ne_sub_class_new => p_ne_sub_class_new
                                   ,pi_ne_group_new     => p_ne_group_new
                                   ,pi_check_only       => p_check_only
                                  );
   --
      end_node_same_class_check ( pi_ne_no_end_new    => p_ne_no_end_new
                                 ,pi_ne_sub_class_new => p_ne_sub_class_new
                                 ,pi_ne_group_new     => p_ne_group_new
                                 ,pi_check_only       => p_check_only
                                );
   --
      start_slr_check ( pi_ne_no_start_new  => p_ne_no_start_new
                       ,pi_ne_sub_class_new => p_ne_sub_class_new
                       ,pi_ne_group_new     => p_ne_group_new
                       ,pi_check_only       => p_check_only
                      );
   --
      start_check ( pi_ne_no_start_new  => p_ne_no_start_new
                   ,pi_ne_sub_class_new => p_ne_sub_class_new
                   ,pi_ne_group_new     => p_ne_group_new
                   ,pi_check_only       => p_check_only
                  );
   --
      end_check ( pi_ne_no_start_new  => p_ne_no_start_new
                 ,pi_ne_sub_class_new => p_ne_sub_class_new
                 ,pi_ne_group_new     => p_ne_group_new
                 ,pi_check_only       => p_check_only
                );
   END IF;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                      ,p_procedure_name => 'route_check');
END route_check;
--
-----------------------------------------------------------------------------
--
   PROCEDURE check_node_slk ( p_nm_id_in    IN nm_elements.ne_id%TYPE
                             ,p_ne_no_start IN nm_elements.ne_no_start%TYPE
                             ,p_new_slk     IN nm_members.nm_slk%TYPE
                             )
   IS
/* ERRORS RAISED

-- -20300 'SLK AT node does NOT equal input SLK'
*/
     CURSOR c1 IS
        SELECT ne_id
        FROM nm_elements
        WHERE ne_id = p_nm_id_in;

   BEGIN
     Nm_Debug.proc_start(p_package_name   => g_package_name
                        ,p_procedure_name => 'check_node_slk');

     FOR c1rec IN c1 LOOP
        IF  p_new_slk != Nm3net.get_node_slk( c1rec.ne_id, p_ne_no_start ) THEN
           RAISE_APPLICATION_ERROR( -20300, 'SLK AT node does NOT equal input SLK');
        END IF;
     END LOOP;

     Nm_Debug.proc_end(p_package_name   => g_package_name
                      ,p_procedure_name => 'check_node_slk');
   END check_node_slk;
--
----------------------------------------------------------------------------------------------
--
PROCEDURE check_members (p_old_nm_ne_id_in   IN     nm_members.nm_ne_id_in%TYPE
                        ,p_old_nm_ne_id_of   IN     nm_members.nm_ne_id_of%TYPE
                        ,p_old_nm_start_date IN     nm_members.nm_start_date%TYPE
                        ,p_old_nm_obj_type   IN     nm_members.nm_obj_type%TYPE
                        ,p_new_nm_ne_id_in   IN     nm_members.nm_ne_id_in%TYPE
                        ,p_new_nm_ne_id_of   IN     nm_members.nm_ne_id_of%TYPE
                        ,p_new_nm_type       IN     nm_members.nm_type%TYPE
                        ,p_new_nm_obj_type   IN OUT nm_members.nm_obj_type%TYPE
                        ,p_new_nm_start_date IN     nm_members.nm_start_date%TYPE
                        ,p_new_nm_end_date   IN     nm_members.nm_end_date%TYPE
                        ,p_new_nm_begin_mp   IN     nm_members.nm_begin_mp%TYPE
                        ,p_new_nm_end_mp     IN     nm_members.nm_end_mp%TYPE
                        ,p_mode              IN     VARCHAR2
                        ) IS
--
   CURSOR c1 ( c_nm_ne_id_in nm_elements.ne_id%TYPE ) IS
     SELECT ne_id
           ,ne_gty_group_type
           ,ne_start_date
           ,ne_end_date
           ,NVL(ne_length,999999999999) ne_length --sm 22102008
     FROM NM_ELEMENTS_ALL
     WHERE ne_id = c_nm_ne_id_in;
--
   CURSOR c2 ( c_nm_ne_id_in nm_elements.ne_id%TYPE ) IS
     SELECT iit_ne_id
           ,iit_inv_type
           ,iit_start_date
           ,iit_end_date
     FROM NM_INV_ITEMS_ALL
     WHERE iit_ne_id = c_nm_ne_id_in;
--
   l_ne_id       nm_members.nm_ne_id_of%TYPE;
   l_nm_obj_type nm_members.nm_obj_type%TYPE;
   l_start_date  nm_members.nm_start_date%TYPE;
   l_end_date    nm_members.nm_end_date%TYPE;
   l_ne_length   NM_ELEMENTS_ALL.ne_length%TYPE;
--
   c_big_date CONSTANT DATE := Nm3type.c_big_date;
--
   l_start_date_out_of_range  EXCEPTION;
   l_end_date_out_of_range    EXCEPTION;
   l_cannot_update_start_date EXCEPTION;
   l_start_date_gt_end_date   EXCEPTION;
   l_has_children             EXCEPTION;
   l_parent_not_found_ele     EXCEPTION;
   l_parent_not_found_inv     EXCEPTION;
--
   measure_out_of_range       EXCEPTION;
--
   l_ner_id             NM_ERRORS.ner_id%TYPE;
   l_ner_appl           NM_ERRORS.ner_appl%TYPE := Nm3type.c_net;

   l_supplementary_info VARCHAR2(500) := 'NM_MEMBERS_ALL('||p_new_nm_ne_id_in||':'||p_new_nm_ne_id_of||':'||p_new_nm_begin_mp||':'||TO_CHAR(p_new_nm_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))||')';
   l_parent_text        VARCHAR2(500) := '.NM_NE_ID_OF - NM_ELEMENTS_ALL.NE_ID';
--
   PROCEDURE validate_dates_against_loc_var IS
   BEGIN
   --
     IF p_new_nm_end_date < p_new_nm_start_date
      THEN
        l_ner_id             := 14;
        l_supplementary_info := l_supplementary_info||TO_CHAR(l_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))||' > '||TO_CHAR(l_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'));
        RAISE l_start_date_gt_end_date;
     END IF;
   --
     IF p_new_nm_start_date NOT BETWEEN l_start_date AND NVL(l_end_date, c_big_date)
      THEN
        l_ner_id             := 11;
        l_supplementary_info := l_supplementary_info||l_parent_text;
        RAISE l_start_date_out_of_range;
     END IF;
   --
     IF p_new_nm_start_date > NVL(l_end_date, c_big_date)
      THEN
        l_ner_id             := 11;
        l_supplementary_info := l_supplementary_info||l_parent_text;
        RAISE l_start_date_out_of_range;
     END IF;
   --
     IF  (p_new_nm_end_date IS NOT NULL
         AND p_new_nm_end_date NOT BETWEEN l_start_date AND NVL(l_end_date, c_big_date)
         )
      OR (p_new_nm_end_date IS     NULL
          AND l_end_date    IS NOT NULL
         )
      THEN
        l_ner_id             := 12;
        l_supplementary_info := l_supplementary_info||l_parent_text;
        RAISE l_end_date_out_of_range;
     END IF;
   --
     IF   l_end_date IS NULL
      AND p_new_nm_end_date IS NOT NULL
      THEN
        IF p_new_nm_end_date NOT BETWEEN l_start_date AND NVL(l_end_date, c_big_date)
         THEN
           l_ner_id             := 12;
           l_supplementary_info := l_supplementary_info||l_parent_text;
           RAISE l_end_date_out_of_range;
        END IF;
     END IF;
   --
  END validate_dates_against_loc_var;
--
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_members');
--
  IF    p_mode = Nm3type.c_updating
   AND (p_old_nm_ne_id_in    <> p_new_nm_ne_id_in
        OR p_old_nm_ne_id_of <> p_new_nm_ne_id_of
       )
   THEN
     Hig.raise_ner(Nm3type.c_net,219);
  END IF;
--
  OPEN  c1 (p_new_nm_ne_id_of);
  FETCH c1 INTO l_ne_id, l_nm_obj_type, l_start_date, l_end_date, l_ne_length;
  CLOSE c1;
--
  IF    p_new_nm_begin_mp NOT BETWEEN 0 AND l_ne_length
   THEN
     RAISE measure_out_of_range;
  ELSIF p_new_nm_end_mp IS NOT NULL
   AND  p_new_nm_end_mp NOT BETWEEN 0 AND l_ne_length
   THEN
     RAISE measure_out_of_range;
  END IF;
  validate_dates_against_loc_var;
--
  IF p_new_nm_type = 'G'
   THEN
     -- check that the new nm_ne_id_of and the nm_ne_id_in
     -- are in nm_elements
--
     l_parent_text := '.NM_NE_ID_IN - NM_ELEMENTS_ALL.NE_ID';
     OPEN  c1(p_new_nm_ne_id_in);
--
     FETCH c1 INTO l_ne_id, l_nm_obj_type, l_start_date, l_end_date, l_ne_length;
--
     IF c1%NOTFOUND
      THEN
        -- no data found
        CLOSE c1;
        RAISE l_parent_not_found_ele;
     ELSE
        CLOSE c1;
        -- parent found, make sure nm_obj_type is same as parent
        -- default any values if inserting
        IF p_mode = Nm3type.c_inserting
         THEN
           Nm_Debug.DEBUG('p_new_nm_obj_type is - '||p_new_nm_obj_type);
           Nm_Debug.DEBUG('settin p_new_obj_type = '||l_nm_obj_type);
           p_new_nm_obj_type := l_nm_obj_type;
        END IF;
     END IF;
--
     -- Let's stick some group type validation in here
     check_member_groups (p_new_nm_ne_id_in
                         ,p_new_nm_ne_id_of);

  ELSIF p_new_nm_type = 'I'
   THEN
     IF Nm3homo.g_homo_touch_flag
     THEN
       l_parent_text := '.NM_NE_ID_IN - NM_INV_ITEMS_ALL.IIT_NE_ID';
       OPEN  c2(p_new_nm_ne_id_in);
--
       FETCH c2 INTO l_ne_id, l_nm_obj_type, l_start_date, l_end_date;
--
       IF c2%NOTFOUND
        THEN
         declare
           l_end_loc_only nm_inv_types.nit_end_loc_only%type;
         begin
           select nit_end_loc_only into l_end_loc_only
           from nm_inv_types_all
           where nit_inv_type = nvl(p_old_nm_obj_type ,p_new_nm_obj_type);
--
           if l_end_loc_only = 'N' then
              nm_debug.debug('end-loc = N, fail!');
              raise l_parent_not_found_inv;
           end if;                     
--
         exception
             when no_data_found then
             close c2;           
             RAISE l_parent_not_found_inv;
         end;
       ELSE
         CLOSE c2;
         -- parent found, make sure nm_obj_type is same as parent
         --  if inserting
         IF p_mode = Nm3type.c_inserting
          THEN
            p_new_nm_obj_type := l_nm_obj_type;
         END IF;
       END IF;
     END IF;
  ELSE
     Hig.raise_ner(Nm3type.c_net,220);
  END IF;
--
  -- Date checking
   IF   p_mode = Nm3type.c_updating
    AND p_new_nm_start_date <> p_old_nm_start_date
    THEN
      l_ner_id := 10;
      RAISE l_cannot_update_start_date;
   END IF;
--
  IF p_new_nm_start_date IS NULL
   THEN
     l_ner_id             := 11;
     RAISE l_start_date_out_of_range;
  END IF;
--
  IF    p_mode = Nm3type.c_updating
   THEN
     IF p_old_nm_obj_type != p_new_nm_obj_type
      THEN
        Hig.raise_ner(Nm3type.c_net,221);
     END IF;
  END IF;
--
  validate_dates_against_loc_var;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_members');
EXCEPTION
--
   WHEN l_cannot_update_start_date
    OR  l_start_date_gt_end_date
    OR  l_has_children
    THEN
      Hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info
                    );
   WHEN l_start_date_out_of_range
    THEN
      Hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info||' '||TO_CHAR(p_new_nm_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))||' > '||TO_CHAR(l_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                    );
   WHEN l_end_date_out_of_range
    THEN
      Hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info||' '||NVL(TO_CHAR(p_new_nm_end_date,Sys_Context('NM3CORE','USER_DATE_MASK')),'Null')||' > '||TO_CHAR(l_end_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                    );
   WHEN l_parent_not_found_ele
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 26
                    ,pi_supplementary_info => p_new_nm_ne_id_in
                    );
   WHEN l_parent_not_found_inv
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_supplementary_info => 'NM_INV_ITEMS : IIT_NE_ID='||p_new_nm_ne_id_in
                    );
   WHEN measure_out_of_range
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 227
                    ,pi_supplementary_info => p_new_nm_begin_mp||'->'||p_new_nm_end_mp||' ('||l_ne_length||')'
                    );
--      RAISE_APPLICATION_ERROR(-20001,'Membership measures out of range of parent element');
--
END check_members;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_member_groups (p_new_nm_ne_id_in   IN     nm_members.nm_ne_id_in%TYPE
                              ,p_new_nm_ne_id_of   IN     nm_members.nm_ne_id_of%TYPE
                               ) IS

   ne_id_in  nm_elements%ROWTYPE;
   ne_id_of  nm_elements%ROWTYPE;

  CURSOR check_grouping(p_ne_gty_group_type_in nm_elements.ne_nt_type%TYPE,
                        p_ne_nt_type_of  nm_elements.ne_nt_type%TYPE) IS
  SELECT '*' FROM nm_nt_groupings
  WHERE nng_nt_type = p_ne_nt_type_of
  AND nng_group_type = p_ne_gty_group_type_in;


  CURSOR check_grouping2(p_ne_nt_type_in nm_elements.ne_nt_type%TYPE,
                        p_ne_nt_type_of  nm_elements.ne_nt_type%TYPE) IS
  SELECT '*' FROM nm_group_relations
  WHERE ngr_parent_group_type = p_ne_nt_type_in
  AND ngr_child_group_type = p_ne_nt_type_of;

  lc_dummy  VARCHAR2(1);

  l_not_a_valid_grouping EXCEPTION;
  l_ner_id             NM_ERRORS.ner_id%TYPE;
  l_ner_appl           NM_ERRORS.ner_appl%TYPE := Nm3type.c_net;
  l_supplementary_info VARCHAR2(500);

BEGIN
--
   Nm_Debug.proc_start(p_package_name   => g_package_name
                      ,p_procedure_name => 'check_member_groups');

--
-- Check that the two members are a valid grouping
--

   ne_id_in := Nm3get.get_ne_all(p_new_nm_ne_id_in);

   ne_id_of := Nm3get.get_ne_all(p_new_nm_ne_id_of);

   IF ne_id_in.ne_type = 'G' THEN

      OPEN check_grouping(ne_id_in.ne_gty_group_type, ne_id_of.ne_nt_type);
      FETCH check_grouping INTO lc_dummy;
      IF check_grouping%NOTFOUND THEN
         CLOSE check_grouping;
         l_ner_id := 380;
         l_supplementary_info := ne_id_in.ne_gty_group_type||' - '||ne_id_of.ne_nt_type;
         RAISE l_not_a_valid_grouping;

      ELSE

         CLOSE check_grouping;

      END IF;

   ELSIF ne_id_in.ne_type = 'P' THEN

      OPEN check_grouping2(ne_id_in.ne_gty_group_type, ne_id_of.ne_gty_group_type);
      FETCH check_grouping2 INTO lc_dummy;
      IF check_grouping2%NOTFOUND THEN

         CLOSE check_grouping2;
         l_ner_id := 380;
         l_supplementary_info := ne_id_in.ne_nt_type||' - '||ne_id_of.ne_nt_type;
         RAISE l_not_a_valid_grouping;

      ELSE

         CLOSE check_grouping2;

      END IF;


   END IF;
--
   Nm_Debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_member_groups');
--
EXCEPTION

   WHEN l_not_a_valid_grouping THEN

      Hig.raise_ner (pi_appl               => l_ner_appl
                    ,pi_id                 => l_ner_id
                    ,pi_supplementary_info => l_supplementary_info
                    );

END check_member_groups;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_tab_excl IS
   l_rec_excl rec_excl;
BEGIN
--
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_tab_excl');
--
   IF g_exclusivity_check
    THEN
--
      FOR i IN 1..g_tab_rec_excl.COUNT
       LOOP
--
         l_rec_excl := g_tab_rec_excl(i);
--
         IF NOT Nm3net.check_exclusive (p_nm_ne_id_in => l_rec_excl.nm_ne_id_in
                                       ,p_nm_ne_id_of => l_rec_excl.nm_ne_id_of
                                       ,p_nm_begin_mp => l_rec_excl.nm_begin_mp
                                       ,p_nm_end_mp   => l_rec_excl.nm_end_mp
                                       )
          THEN
            -- CWS 0110052 Auto Included check added for changing existing members.
             IF NM3NET.CHILD_AUTOINCLUDED_IN_PARENT(pi_nti_nw_parent_type => NM3GET.GET_NE(pi_ne_id =>  l_rec_excl.nm_ne_id_in).ne_nt_type
                                                                                 ,pi_nti_nw_child_type    =>   NM3GET.GET_NE(l_rec_excl.nm_ne_id_of).ne_nt_type
                                                                                 ) = 'Y'
             THEN
                  hig.raise_ner(pi_appl    => nm3type.c_net
                                     ,pi_id      => 8
                                     ,pi_supplementary_info => 'The member is Auto Included in a different parent group.'
                                     );   
             END IF;
          
              --LS allows override of group based on the production option set
              IF hig.get_sysopt('GRPXCLOVWR') = 'Y'  -- LS based on product options exclusive grouping is allowed
              THEN
                  UPDATE nm_members
                  SET    nm_end_date = l_rec_excl.nm_start_date
                  WHERE  nm_ne_id_of = l_rec_excl.nm_ne_id_of
                  AND    nm_obj_type = ( select ne_gty_group_type from nm_elements where ne_id = l_rec_excl.nm_ne_id_in )
                  AND    nm_ne_id_in != l_rec_excl.nm_ne_id_in;              
                  --g_nwval_exc_code := -20051;
                  --g_nwval_exc_msg  := 'Membership is not exclusive';
                  --RAISE g_nwval_exception;
              ELSE
                  hig.raise_ner(pi_appl    => nm3type.c_net
                               ,pi_id      => 41);
              END IF;

         END IF;
--
      END LOOP;
   END IF;
--
   clear_tab_excl;
--
  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_tab_excl');
EXCEPTION
   WHEN g_nwval_exception
    THEN
      clear_tab_excl;
      RAISE_APPLICATION_ERROR(g_nwval_exc_code,g_nwval_exc_msg);
   WHEN OTHERS
    THEN
      clear_tab_excl;
      RAISE;
END process_tab_excl;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_tab_excl IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'clear_tab_excl');

   g_tab_rec_excl.DELETE;

   Nm_Debug.proc_end(p_package_name   => g_package_name
                    ,p_procedure_name => 'clear_tab_excl');
END clear_tab_excl;
--
-----------------------------------------------------------------------------
--
FUNCTION group_has_overlaps(pi_ne_id_in IN nm_members.nm_ne_id_in%TYPE
                           ) RETURN BOOLEAN IS

  CURSOR c_nm(p_ne_id_in IN nm_members.nm_ne_id_in%TYPE) IS
    SELECT
      1
    FROM
      nm_members nm_1
    WHERE
      nm_1.nm_ne_id_in = p_ne_id_in
    AND
      EXISTS (SELECT
                1
              FROM
                nm_members nm_2
              WHERE
                nm_2.nm_ne_id_in = nm_1.nm_ne_id_in
              AND
                nm_2.nm_ne_id_of = nm_1.nm_ne_id_of
              AND
                nm_2.ROWID <> nm_1.ROWID
              AND
                nm_1.nm_begin_mp < NVL(nm_2.nm_end_mp, nm_1.nm_begin_mp + 1)
              AND
                NVL(nm_1.nm_end_mp, nm_2.nm_begin_mp + 1) > nm_2.nm_begin_mp);

  l_dummy PLS_INTEGER;

  l_retval BOOLEAN;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'group_has_overlaps');

  OPEN c_nm(p_ne_id_in => pi_ne_id_in);
    FETCH c_nm INTO l_dummy;
    l_retval := c_nm%FOUND;
  CLOSE c_nm;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'group_has_overlaps');

  RETURN l_retval;

END group_has_overlaps;
--
-----------------------------------------------------------------------------
--
--
  PROCEDURE check_operation( p_operation IN VARCHAR2 )
  IS
  BEGIN
     IF p_operation NOT IN (  c_split,  c_merge,  c_replace,  c_close,
                              c_unclose,  c_closeroute,  c_reclass,  c_reverse ) THEN
        RAISE_APPLICATION_ERROR(-20010,'Invalid Operation');
     END IF;
  END check_operation;
--
  PROCEDURE check_future_date( p_effective_date IN DATE )
  IS
  BEGIN
    IF p_effective_date > TRUNC(SYSDATE) THEN
       Hig.raise_ner (Nm3type.c_net
                     ,165
                     );
       --RAISE_APPLICATION_ERROR( -20001, 'Future effective date not allowed' );
    END IF;
  END check_future_date;
--
   PROCEDURE check_sub_class( p_ne_id_1 nm_elements.ne_id%TYPE
                             ,p_ne_id_2 nm_elements.ne_id%TYPE
                            )
   IS
   CURSOR c1 ( c_ne_id_1 nm_elements.ne_id%TYPE
              ,c_ne_id_2 nm_elements.ne_id%TYPE ) IS
   SELECT 1
   FROM nm_elements a
       ,nm_elements b
   WHERE a.ne_id = c_ne_id_1
     AND b.ne_id = NVL(c_ne_id_2,c_ne_id_1)
     AND NVL(a.ne_sub_class,0) = NVL(b.ne_sub_class,0);

--
   dummy NUMBER(1);
--
   BEGIN
      OPEN c1 ( p_ne_id_1, p_ne_id_2 );
      FETCH c1 INTO dummy;
      IF c1%NOTFOUND THEN
         CLOSE c1;
         RAISE_APPLICATION_ERROR( -20003, 'Sub Class of elements are not the same');
      END IF;
      CLOSE c1;
   END check_sub_class;
--
   PROCEDURE check_elements_connected ( p_ne_id_1 nm_elements.ne_id%TYPE
                                       ,p_ne_id_2 nm_elements.ne_id%TYPE
                                      )
   IS
   BEGIN
      IF NOT Nm3net.check_element_connectivity( p_ne_id_1, p_ne_id_2)  THEN
         RAISE_APPLICATION_ERROR( -20004, 'Elements are NOT connected' );
      END IF;
   END check_elements_connected;
--
   PROCEDURE check_datum_elements ( p_ne_id_1 nm_elements.ne_id%TYPE
                                   ,p_ne_id_2 nm_elements.ne_id%TYPE DEFAULT NULL
                                  )
   IS
   BEGIN
      -- check that the element to be split is a datum element
      IF Nm3net.is_nt_datum(Nm3net.Get_Nt_Type(p_ne_id_1)) = 'N' OR
         Nm3net.is_nt_datum(Nm3net.Get_Nt_Type(NVL(p_ne_id_2,p_ne_id_1))) = 'N'
      THEN
         RAISE_APPLICATION_ERROR( -20005 ,'Not a datum element');
      END IF;
   END check_datum_elements;
--
   PROCEDURE check_network_type ( p_ne_id_1 nm_elements.ne_id%TYPE
                                 ,p_ne_id_2 nm_elements.ne_id%TYPE
                                )
   IS
   BEGIN
      Nm_Debug.proc_start(g_package_name , 'check_network_type');
      IF Nm3net.Get_Nt_Type(p_ne_id_1) !=
         Nm3net.Get_Nt_Type(NVL(p_ne_id_2,p_ne_id_1))
      THEN
         RAISE_APPLICATION_ERROR( -20006, 'Elements must be of the same network type');
      END IF;
      Nm_Debug.proc_end(g_package_name , 'check_network_type');
   END check_network_type;

--
   PROCEDURE check_if_distance_break ( p_ne_id_1 nm_elements.ne_id%TYPE
                                      ,p_ne_id_2 nm_elements.ne_id%TYPE DEFAULT NULL
                                     )
   IS
   CURSOR c1 ( c_ne_id_1 nm_elements.ne_id%TYPE
              ,c_ne_id_2 nm_elements.ne_id%TYPE)
   IS
   SELECT 1
   FROM nm_elements
   WHERE ne_id IN ( c_ne_id_1,NVL(p_ne_id_2,p_ne_id_1) )
   AND ne_type = 'D';
   --
   dummy NUMBER;
   BEGIN
      OPEN c1 ( p_ne_id_1, p_ne_id_2 );
      FETCH c1 INTO dummy;
      IF c1%FOUND THEN
         CLOSE c1;
         RAISE_APPLICATION_ERROR ( -20007, 'Element is a distance break');
      END IF;
      CLOSE c1;
   END check_if_distance_break;
--
  PROCEDURE check_user_can_see_inv( p_ne_id_1 nm_elements.ne_id%TYPE
                                   ,p_ne_id_2 nm_elements.ne_id%TYPE DEFAULT NULL
                                   )
  IS
    cannot_see_inv EXCEPTION;
  BEGIN
     IF NOT Nm3inv_Security.can_usr_see_all_inv_on_element( p_ne_id_1 ) THEN
        RAISE cannot_see_inv;
     END IF;
     IF p_ne_id_2 IS NOT NULL AND
        NOT Nm3inv_Security.can_usr_see_all_inv_on_element( p_ne_id_2 ) THEN
        RAISE cannot_see_inv;
     END IF;
  EXCEPTION
     WHEN cannot_see_inv THEN
      Hig.raise_ner (Nm3type.c_net,172); 
       WHEN OTHERS THEN
        RAISE;
  END check_user_can_see_inv;
--
PROCEDURE network_operations_check ( p_operation IN VARCHAR2
                                    ,p_ne_id_1 IN nm_elements.ne_id%TYPE DEFAULT NULL
                                    ,p_effective_date IN DATE DEFAULT TRUNC(SYSDATE)
                                    ,p_ne_id_2 IN nm_elements.ne_id%TYPE DEFAULT NULL
                                   )
IS
--
  CURSOR cs_exists ( c_ne_id nm_elements.ne_id%TYPE )
  IS
  SELECT ne_id
  FROM nm_elements
  WHERE ne_id = c_ne_id;

  l_ne_id nm_elements.ne_id%TYPE;
  l_ne_row nm_elements%rowtype;
  l_mode varchar2(10);
BEGIN
  Nm_Debug.proc_start(g_package_name , 'network_operations_check');
--
  if p_ne_id_1 is not null then
     l_ne_row := nm3get.get_ne_all(p_ne_id_1);
     l_mode := NM3AUSEC.get_au_mode(sys_context('NM3_SECURITY_CTX', 'USERNAME'), l_ne_row.ne_admin_unit);
  end if;

  -- Some operations might pass in a 2nd ne_id even if it hasn't been
  -- created yet, so check it exists and set it to null if it doesn't

  OPEN cs_exists( p_ne_id_2 );
  FETCH cs_exists INTO l_ne_id;
  IF cs_exists%NOTFOUND THEN
     l_ne_id := NULL;
     CLOSE cs_exists;
  ELSE
     CLOSE cs_exists;
     l_ne_row := nm3get.get_ne_all(l_ne_id);
     l_mode := NM3AUSEC.get_au_mode(sys_context('NM3_SECURITY_CTX', 'USERNAME'), l_ne_row.ne_admin_unit);
  END IF;


  check_operation( p_operation => p_operation );
  

--
  IF p_operation = c_split THEN
       Nm3split.check_element_can_be_split(pi_ne_id          => p_ne_id_1
                                          ,pi_effective_date => p_effective_date);
--     check_future_date( p_effective_date );
--     check_datum_elements( p_ne_id_1 );
--     check_if_distance_break( p_ne_id_1 );
--     check_user_can_see_inv(p_ne_id_1);
  END IF;
--
  IF p_operation = c_merge THEN
       Nm3merge.check_elements_can_be_merged(pi_ne_id_1        => p_ne_id_1
                                            ,pi_ne_id_2        => l_ne_id
                                            ,pi_effective_date => p_effective_date);

--     check_future_date( p_effective_date );
--     check_sub_class( p_ne_id_1, l_ne_id);
--     check_elements_connected( p_ne_id_1, l_ne_id );
--     check_datum_elements( p_ne_id_1, l_ne_id );
--     check_network_type( p_ne_id_1, l_ne_id );
--     check_if_distance_break( p_ne_id_1, l_ne_id );
--     check_user_can_see_inv( p_ne_id_1, l_ne_id );
  END IF;
--
  IF p_operation = c_replace THEN
    check_future_date( p_effective_date );
    check_sub_class( p_ne_id_1, l_ne_id );
    check_datum_elements( p_ne_id_1 );
    check_network_type( p_ne_id_1, l_ne_id );
    check_if_distance_break( p_ne_id_1, l_ne_id );
    check_user_can_see_inv( p_ne_id_1, l_ne_id );
  END IF;
--
  IF p_operation IN (c_close, c_unclose, c_closeroute, c_reverse, c_reclass) THEN
--RC Data Access - allow the test to work as it is for al other operations but these operations may need to access the inventory data.
--So, just seeing the asset data is insufficient - it needs to test if, when locations are closed there are some readonly assets that
--would be affected.Test on the usual 

     IF  NOT Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' 
     AND NOT(check_asset_closure_on_element(pi_ne_id => p_ne_id_1))
     THEN
       --
       hig.raise_ner( pi_appl            => 'NET'
                    , pi_id              => 172);
       --RAISE_APPLICATION_ERROR( -20008, 'User is restricted and does not have access to all inventory on the element');
       --
     END IF;
--
          
  END IF;
--
/*
  IF p_operation = c_close THEN
     --Nm3user.restricted_user_check;
  END IF;
    
  IF p_operation = c_unclose THEN
     Nm3user.restricted_user_check;
  END IF;
--
  IF p_operation = c_closeroute THEN
     Nm3user.restricted_user_check;
  END IF; 
  
  IF p_operation = c_reverse THEN
     Nm3user.restricted_user_check;
  END IF;*/
--
  IF p_operation = c_reclass THEN
--     nm3user.restricted_user_check;
     Nm3reclass.check_element_can_be_reclassed(pi_ne_id          => p_ne_id_1
                                              ,pi_effective_date => p_effective_date);
  END IF;
--
  Nm_Debug.proc_end(g_package_name , 'network_operations_check');
END network_operations_check;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_slk ( p_parent_ne_id IN NUMBER
                     ,p_no_start_new IN NUMBER
                     ,p_no_end_new   IN NUMBER
                     ,p_length       IN NUMBER
                     ,p_sub_class    IN nm_elements.ne_sub_class%TYPE
                     ,p_datum_ne_id  IN nm_elements.ne_id%TYPE
                     )
  -- Checks that the new start/end slks are the same as the existing ones
IS
   CURSOR c_start_slk ( c_start_node NUMBER
                       ,c_parent_ne_id NUMBER
                      )
   IS
   SELECT Nm3net.get_node_slk( nm_ne_id_in
                              ,ne_no_start
                              ,ne_sub_class
                              ,ne_id) slk
   FROM nm_elements, nm_members
   WHERE ne_no_start = c_start_node
   AND nm_ne_id_in = c_parent_ne_id
   AND ne_id = nm_ne_id_of    ;
--
   CURSOR c_end_slk ( c_end_node NUMBER
                     ,c_parent_ne_id NUMBER
                    )
   IS   SELECT Nm3net.get_node_slk( nm_ne_id_in
                                   ,ne_no_end
                                   ,ne_sub_class
                                   ,ne_id) slk
   FROM nm_elements, nm_members
   WHERE ne_no_end = c_end_node
   AND nm_ne_id_in = c_parent_ne_id
   AND ne_id = nm_ne_id_of    ;

   new_start_slk NUMBER;
   new_end_slk NUMBER;
   e_start_slk_error EXCEPTION;
   e_end_slk_error EXCEPTION;
BEGIN
   Nm_Debug.proc_start(g_package_name , 'check_slk');

   -- Only do the check if the parent network type is linear
   IF Nm3net.is_nt_linear(Nm3net.Get_Nt_Type(p_parent_ne_id)) = 'Y' THEN

      new_start_slk := Nm3net.get_new_slk ( p_parent_ne_id => p_parent_ne_id
                                           ,p_no_start_new => p_no_start_new
                                           ,p_no_end_new   => p_no_end_new
                                           ,p_length       => p_length
                                           ,p_sub_class    => p_sub_class
                                           ,p_datum_ne_id  => p_datum_ne_id
                                          );
   --
      new_end_slk := new_start_slk + Nm3unit.convert_unit(  p_un_id_in => Nm3net.get_nt_units(Nm3net.get_datum_nt(p_parent_ne_id))
                                                          , p_un_id_out => Nm3net.get_gty_units(Nm3net.get_gty_type(p_parent_ne_id))
                                                          , p_value => p_length
                                                         );
   --
      FOR c_slk_rec IN c_start_slk (  p_no_end_new,p_parent_ne_id ) LOOP
    --        dbms_output.put_line ( 'start c_slk_rec.slk= ' || c_slk_rec.slk );
         IF c_slk_rec.slk != new_end_slk THEN
            RAISE e_end_slk_error;
         END IF;
      END LOOP;
   --
      FOR c_slk_rec IN c_end_slk (  p_no_start_new, p_parent_ne_id ) LOOP
   --         dbms_output.put_line ( 'end c_slk_rec.slk= ' || c_slk_rec.slk );
         IF c_slk_rec.slk != new_start_slk THEN
            RAISE e_start_slk_error;
         END IF;
      END LOOP;
--
   END IF;
   Nm_Debug.proc_end(g_package_name , 'check_slk');
   EXCEPTION
      WHEN e_start_slk_error THEN
         RAISE_APPLICATION_ERROR( -20198, 'New Start SLK does not match the Existing Start SLK(s)');
      WHEN e_end_slk_error THEN
         RAISE_APPLICATION_ERROR( -20199, 'New End SLK does not match the Existing End SLK(s)');
END check_slk;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
BEGIN
   Nm3ddl.append_tab_varchar(g_tab_vc, p_text, p_nl);
END append;
--
-----------------------------------------------------------------------------
--
FUNCTION is_nm_elements_col (p_column VARCHAR2) RETURN BOOLEAN IS
   l_retval BOOLEAN := FALSE;
BEGIN
   FOR i IN 1..g_tab_nm_elements_cols.COUNT
    LOOP
      IF g_tab_nm_elements_cols(i) = p_column
       THEN
         l_retval := TRUE;
         EXIT;
      END IF;
   END LOOP;
   RETURN l_retval;
END is_nm_elements_col;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_network_metadata RETURN Nm3type.tab_varchar2000 IS
--
   CURSOR cs_nt IS
   SELECT *
    FROM  NM_TYPES;
--
   CURSOR cs_ntc (c_nt VARCHAR2) IS
   SELECT *
    FROM  NM_TYPE_COLUMNS
   WHERE  ntc_nt_type = c_nt;
--
   CURSOR cs_nti_child (c_nt VARCHAR2) IS
   SELECT *
    FROM  NM_TYPE_INCLUSION
   WHERE  nti_nw_child_type = c_nt;
--
   CURSOR cs_nti_parent (c_nt VARCHAR2) IS
   SELECT *
    FROM  NM_TYPE_INCLUSION
   WHERE  nti_nw_parent_type = c_nt;
--
   l_rec_ntc NM_TYPE_COLUMNS%ROWTYPE;
   TYPE tab_rec_ntc IS TABLE OF NM_TYPE_COLUMNS%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_rec_ntc tab_rec_ntc;
--
   l_rec_nti NM_TYPE_INCLUSION%ROWTYPE;
   TYPE tab_rec_nti IS TABLE OF NM_TYPE_INCLUSION%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_rec_nti_parent tab_rec_nti;
   l_tab_rec_nti_child  tab_rec_nti;
   l_tab_rec_ngt        Nm3type.tab_rec_ngt;
--
   l_retval Nm3type.tab_varchar2000;
--
   l_count  PLS_INTEGER := 0;
--
   l_rec_nt NM_TYPES%ROWTYPE;
--
   PROCEDURE add_err (p_ner_id        NUMBER
                     ,p_supplementary VARCHAR2 DEFAULT NULL
                     ,p_appl          VARCHAR2 DEFAULT Nm3type.c_net
                     ) IS
      l_ner_caught EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_ner_caught,-20800);
      l_error      VARCHAR2(4000);
   BEGIN
      Hig.raise_ner (pi_appl               => p_appl
                    ,pi_id                 => p_ner_id
                    ,pi_sqlcode            => -20800
                    ,pi_supplementary_info => p_supplementary
                    );
   EXCEPTION
      WHEN l_ner_caught
       THEN
         l_error := Nm3flx.parse_error_message(SQLERRM,'ORA',1);
         l_count           := l_count + 1;
         l_retval(l_count) := l_rec_nt.nt_type||' - '||l_error;
   END add_err;
--
BEGIN
--
   Nm_Debug.proc_start (g_package_name,'validate_network_metadata');
--
   FOR cs_rec_nt IN cs_nt
    LOOP
--
      l_rec_nt := cs_rec_nt;
--
      IF l_rec_nt.nt_datum       =  'Y'
       AND l_rec_nt.nt_node_type IS NULL
       THEN
         add_err(207);
      END IF;
--
      l_tab_rec_ntc.DELETE;
      FOR cs_rec_ntc IN cs_ntc (l_rec_nt.nt_type)
       LOOP
         l_tab_rec_ntc(l_tab_rec_ntc.COUNT+1) := cs_rec_ntc;
      END LOOP;
--
      DECLARE
         l_unique_seq_found BOOLEAN := FALSE;
         l_tab_unique_seq   Nm3type.tab_varchar30;
      BEGIN
         FOR i IN 1..l_tab_rec_ntc.COUNT
          LOOP
            l_rec_ntc := l_tab_rec_ntc(i);
            IF l_rec_ntc.ntc_unique_seq IS NOT NULL
             THEN
               l_unique_seq_found := TRUE;
               IF l_tab_unique_seq.EXISTS(l_rec_ntc.ntc_unique_seq)
                THEN
                  add_err(208,l_rec_ntc.ntc_unique_seq);
               END IF;
               l_tab_unique_seq(l_rec_ntc.ntc_unique_seq) := l_rec_ntc.ntc_column_name;
            END IF;
            --
            IF l_rec_ntc.ntc_default IS NOT NULL
             AND NOT is_nm_elements_col (l_rec_ntc.ntc_default)
             AND NOT Nm3flx.can_string_be_select_from_dual (l_rec_ntc.ntc_default)
             AND NOT Nm3flx.can_string_be_select_from_tab(pi_string       => l_rec_ntc.ntc_default
                                                         ,pi_table        => 'nm_elements'
                                                         ,pi_remove_binds => TRUE)
             THEN
               add_err(353,l_rec_ntc.ntc_column_name);
            END IF;
            --
         END LOOP;
--
         IF    l_unique_seq_found
          AND  l_rec_nt.nt_pop_unique = 'N'
          THEN
            add_err(209);
         ELSIF NOT l_unique_seq_found
          AND  l_rec_nt.nt_pop_unique = 'Y'
          THEN
            add_err(210);
         END IF;
      END;
--
      l_tab_rec_nti_child.DELETE;
      FOR cs_rec_nti IN cs_nti_child (l_rec_nt.nt_type)
       LOOP
       --  add_err(cs_nti_child%ROWCOUNT||': Child of '||cs_rec_nti.nti_nw_child_type);
         l_tab_rec_nti_child(l_tab_rec_nti_child.COUNT+1) := cs_rec_nti;
      END LOOP;
--
      l_tab_rec_nti_parent.DELETE;
      FOR cs_rec_nti IN cs_nti_parent (l_rec_nt.nt_type)
       LOOP
       --  add_err(cs_nti_parent%ROWCOUNT||': Parent of '||cs_rec_nti.nti_nw_child_type);
         l_tab_rec_nti_parent(l_tab_rec_nti_parent.COUNT+1) := cs_rec_nti;
      END LOOP;
--
      DECLARE
         l_rec_nti2 NM_TYPE_INCLUSION%ROWTYPE;
         PROCEDURE check_col (p_col VARCHAR2) IS
         BEGIN
            IF p_col IS NOT NULL
             AND NOT is_nm_elements_col (p_col)
             THEN
               add_err(211,p_col);
            END IF;
         END check_col;
      BEGIN
         FOR i IN 1..l_tab_rec_nti_child.COUNT
          LOOP
            l_rec_nti := l_tab_rec_nti_child(i);
            --
            check_col (l_rec_nti.nti_parent_column);
            check_col (l_rec_nti.nti_child_column);
            check_col (l_rec_nti.nti_code_control_column);
            --
            FOR j IN 1..l_tab_rec_nti_child.COUNT
             LOOP
               IF   i != j
                THEN
                  l_rec_nti2 := l_tab_rec_nti_child(j);
                  IF l_rec_nti2.nti_child_column = l_rec_nti.nti_child_column
                   THEN
                     add_err(212,l_rec_nti.nti_child_column);
                  END IF;
               END IF;
            END LOOP;
            --
            IF l_rec_nti.nti_code_control_column IS NOT NULL
             THEN
               -- If this is a child with a CC column, make sure it's not also a parent with the same column
               FOR j IN 1..l_tab_rec_nti_parent.COUNT
                LOOP
                  l_rec_nti2 := l_tab_rec_nti_parent(j);
                  IF l_rec_nti2.nti_code_control_column = l_rec_nti.nti_code_control_column
                   THEN
                     add_err(213,l_rec_nti.nti_code_control_column);
                  END IF;
               END LOOP;
            END IF;
            --
         END LOOP;
      END;
--
      DECLARE
         l_rec_nti2 NM_TYPE_INCLUSION%ROWTYPE;
         l_pop_unique BOOLEAN;
      BEGIN
         FOR i IN 1..l_tab_rec_nti_parent.COUNT
          LOOP
            l_rec_nti := l_tab_rec_nti_parent(i);
            --
            FOR j IN 1..l_tab_rec_nti_parent.COUNT
             LOOP
               IF   i != j
                THEN
                  l_rec_nti2 := l_tab_rec_nti_parent(j);
                  IF l_rec_nti2.nti_parent_column = l_rec_nti.nti_parent_column
                   THEN
                     add_err(214,l_rec_nti.nti_parent_column);
                  END IF;
                  IF   l_rec_nti.nti_code_control_column IS NOT NULL
                   AND l_rec_nti2.nti_code_control_column = l_rec_nti.nti_code_control_column
                   THEN
                     add_err(215,l_rec_nti.nti_code_control_column);
                  END IF;
               END IF;
            END LOOP;
            --
            IF l_rec_nti.nti_auto_create = 'Y'
             THEN
               --
               l_pop_unique := Nm3net.is_pop_unique(l_rec_nti.nti_nw_parent_type);
               --
               IF Nm3net.get_nt(l_rec_nti.nti_nw_parent_type).nt_node_type IS NOT NULL
                THEN
                  add_err(257,l_rec_nti.nti_nw_child_type);
               END IF;
               --
               IF   l_rec_nti.nti_parent_column != 'NE_UNIQUE'
                AND NOT l_pop_unique
                THEN
                  add_err(216);
               END IF;
               --
               FOR j IN 1..l_tab_rec_ntc.COUNT
                LOOP
                  --
                  l_rec_ntc := l_tab_rec_ntc(j);
                  IF   l_rec_ntc.ntc_mandatory = 'Y'
                   AND l_rec_ntc.ntc_column_name != l_rec_nti.nti_parent_column
                   THEN
                     add_err (217,l_rec_ntc.ntc_column_name);
                  END IF;
                  --
                  IF   l_rec_ntc.ntc_unique_seq IS NOT NULL
                   AND l_rec_ntc.ntc_column_name != l_rec_nti.nti_parent_column
                   AND l_pop_unique
                   THEN
                     add_err (218,l_rec_ntc.ntc_column_name);
                  END IF;
                  --
               END LOOP;
               --
               l_tab_rec_ngt := Nm3net.get_gty_by_nt_type (p_nt_type => l_rec_nt.nt_type);
               --
               IF l_tab_rec_ngt.COUNT = 0
                THEN
                  add_err (199);
               ELSIF l_tab_rec_ngt.COUNT > 1
                THEN
                  add_err (200);
               END IF;
               --
            END IF;
            --
         END LOOP;
      END;
--
   END LOOP;
--
   Nm_Debug.proc_end (g_package_name,'validate_network_metadata');
--
   RETURN l_retval;
--
END validate_network_metadata;
--
-----------------------------------------------------------------------------
--
FUNCTION network_metadata_is_valid RETURN BOOLEAN IS
--
   l_tab Nm3type.tab_varchar2000;
--
BEGIN
--
   l_tab := validate_network_metadata;
--
   RETURN l_tab.COUNT = 0;
--
END network_metadata_is_valid;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nm_elements_cols RETURN Nm3type.tab_varchar30 IS
BEGIN
   RETURN g_tab_nm_elements_cols;
END get_nm_elements_cols;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_element_b4_row_trigger
                          (p_rec_ne_old NM_ELEMENTS_ALL%ROWTYPE
                          ,p_rec_ne_new NM_ELEMENTS_ALL%ROWTYPE
                          ,p_db_action  VARCHAR2
                          ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'check_element_b4_row_trigger');
--
   IF p_db_action = Nm3type.c_updating
    THEN
      IF p_rec_ne_old.ne_admin_unit != p_rec_ne_new.ne_admin_unit
       THEN
         Hig.raise_ner(Nm3type.c_net,239); -- AU Update not allowed
      END IF;
      IF Nm3ausec.get_au_mode( Sys_Context('NM3_SECURITY_CTX','USERNAME'), p_rec_ne_old.ne_admin_unit ) != Invsec.c_normal_string
       THEN
         Hig.raise_ner(Nm3type.c_net,240);
         --raise_application_error(-20902, 'You may not change this record');
      END IF;
   END IF;
--
   IF Nm3ausec.get_au_mode( Sys_Context('NM3_SECURITY_CTX','USERNAME'), p_rec_ne_new.ne_admin_unit ) != Invsec.c_normal_string
    THEN
      Hig.raise_ner(Nm3type.c_net,241);
      --raise_application_error(-20903, 'You may not enter data with this admin unit');
   END IF;
--
   IF   p_db_action = Nm3type.c_inserting
    OR (p_db_action = Nm3type.c_updating
                 AND (   NVL(p_rec_ne_old.ne_no_start,-1) != NVL(p_rec_ne_new.ne_no_start,-1) -- Start node has changed
                      OR NVL(p_rec_ne_old.ne_no_end,-1)   != NVL(p_rec_ne_new.ne_no_end,-1)   -- End node has changed
                      OR p_rec_ne_old.ne_nt_type          != p_rec_ne_new.ne_nt_type          -- Should not happen
                     )
       )
    THEN
      -- We're either inserting or updating the start or end node
      IF  NOT Nm3net.is_node_valid_on_nt_type(p_rec_ne_new.ne_no_start,p_rec_ne_new.ne_nt_type)
       OR NOT Nm3net.is_node_valid_on_nt_type(p_rec_ne_new.ne_no_end,  p_rec_ne_new.ne_nt_type)
       THEN
         Hig.raise_ner(Nm3type.c_net,107);
      END IF;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'check_element_b4_row_trigger');
--
END check_element_b4_row_trigger;
--
-----------------------------------------------------------------------------
--
PROCEDURE calc_end_slk_and_true (pi_nm_ne_id_in    IN     nm_members.nm_ne_id_in%TYPE
                                ,pi_nm_ne_id_of    IN     nm_members.nm_ne_id_of%TYPE
                                ,pi_nm_type        IN     nm_members.nm_type%TYPE
                                ,pi_nm_obj_type    IN     nm_members.nm_obj_type%TYPE
                                ,pi_nm_slk         IN     nm_members.nm_slk%TYPE
                                ,pi_nm_true        IN     nm_members.nm_true%TYPE
                                ,pi_nm_begin_mp    IN     nm_members.nm_begin_mp%TYPE
                                ,pi_nm_end_mp      IN     nm_members.nm_end_mp%TYPE
                                ,po_nm_end_slk        OUT nm_members.nm_slk%TYPE
                                ,po_nm_end_true       OUT nm_members.nm_true%TYPE
                                ) IS
--
   l_datum_units   NM_UNITS.un_unit_id%TYPE;
   l_parent_units  NM_UNITS.un_unit_id%TYPE;
   l_is_linear_inv BOOLEAN := FALSE;
--
   l_amount_to_add NUMBER;
   l_member_length NUMBER;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'calc_end_slk_and_true');
--
   IF pi_nm_slk IS NOT NULL
    THEN
      IF pi_nm_begin_mp = pi_nm_end_mp
       THEN
         po_nm_end_slk            := pi_nm_slk;
         po_nm_end_true           := pi_nm_true;
      ELSE
         IF pi_nm_ne_id_in = NVL(g_last_nm_ne_id_in,-1)
          THEN -- Retrieve from globals wherever possible
            l_parent_units        := g_parent_units;
            l_is_linear_inv       := g_is_linear_inv;
         ELSE
            IF    pi_nm_type = 'G'
             THEN
               l_parent_units     := Nm3net.get_nt_units_from_ne (pi_nm_ne_id_in);
            ELSIF pi_nm_type = 'I'
             THEN
               l_is_linear_inv    := Nm3inv.get_inv_type(pi_nm_obj_type).nit_linear = 'Y';
            END IF;
            g_parent_units        := l_parent_units;
            g_is_linear_inv       := l_is_linear_inv;
            g_last_nm_ne_id_in    := pi_nm_ne_id_in;
         END IF;
      --
         IF  l_parent_units IS NOT NULL
          OR l_is_linear_inv
          THEN
   --
            IF pi_nm_ne_id_of = NVL(g_last_nm_ne_id_of,-1)
             THEN -- Retrieve from globals wherever possible
               l_datum_units      := g_datum_units;
            ELSE
               l_datum_units      := Nm3net.get_nt_units_from_ne (pi_nm_ne_id_of);
               g_datum_units      := l_datum_units;
               g_last_nm_ne_id_of := pi_nm_ne_id_of;
            END IF;
            l_parent_units        := NVL(l_parent_units,l_datum_units); -- This is for when we're on linear inv
            l_member_length       := pi_nm_end_mp - pi_nm_begin_mp;
            IF l_datum_units = l_parent_units
             THEN
               l_amount_to_add    := l_member_length;
            ELSE
               l_amount_to_add    := Nm3unit.convert_unit (l_datum_units
                                                          ,l_parent_units
                                                             ,l_member_length
                                                       );
            END IF;
            po_nm_end_slk         := pi_nm_slk  + l_amount_to_add;
            po_nm_end_true        := pi_nm_true + l_amount_to_add;
   --
         END IF;
      END IF;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'calc_end_slk_and_true');
--
END calc_end_slk_and_true;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_group_type_inclusion(pi_group_type IN NM_NT_GROUPINGS_ALL.nng_group_type%TYPE
                                    ,pi_nt_type    IN NM_NT_GROUPINGS_ALL.nng_nt_type%TYPE
                                    ) IS

  l_group_nt_type NM_TYPES.nt_type%TYPE;

  l_temp PLS_INTEGER;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_group_type_inclusion');

  l_group_nt_type := Nm3get.get_ngt(pi_ngt_group_type => pi_group_type).ngt_nt_type;

  IF Nm3net.is_nt_inclusion(pi_nt => l_group_nt_type)
  THEN
    --this is an inclusion parent group type
    --check to make sure there are no other children for it
    BEGIN
      SELECT
        1
      INTO
        l_temp
      FROM
        dual
      WHERE
        EXISTS(SELECT
                 1
               FROM
                 NM_NT_GROUPINGS_ALL nng
               WHERE
                 nng.nng_group_type = pi_group_type
               AND
                 nng.nng_nt_type <> pi_nt_type);

      --one already exists
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 345
                   ,pi_supplementary_info => pi_group_type || ':' || pi_nt_type);

    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        --none present, ok to continue
        NULL;

    END;
  END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_group_type_inclusion');

END check_group_type_inclusion;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_nng_tab IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'clear_nng_tab');

  g_nng_val_tab.DELETE;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'clear_nng_tab');

END clear_nng_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE pop_nng_tab(pi_nng_val_rec t_nng_val_rec
                     ) IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'pop_nng_tab');

  g_nng_val_tab(g_nng_val_tab.COUNT + 1) := pi_nng_val_rec;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'pop_nng_tab');

END pop_nng_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_nng_tab IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'process_nng_tab');

  FOR l_i IN 1..g_nng_val_tab.COUNT
  LOOP
    check_group_type_inclusion(pi_group_type => g_nng_val_tab(l_i).group_type
                              ,pi_nt_type    => g_nng_val_tab(l_i).nt_type);
  END LOOP;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'process_nng_tab');

END process_nng_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_unique_formatted_flex_cols(pi_ne_nt_type        IN     nm_elements.ne_nt_type%TYPE
                                        ,pio_ne_flex_cols_rec IN OUT t_ne_flex_cols_rec
                                        ) IS

  l_col_names_tab         Nm3type.tab_varchar30;
  l_col_unique_format_tab Nm3type.tab_varchar4000;

  l_global_field VARCHAR2(100);

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_unique_formatted_flex_cols');

  --get unique columns that need formatting
  SELECT
    ntc.ntc_column_name,
    ntc.ntc_unique_format
  BULK COLLECT INTO
    l_col_names_tab,
    l_col_unique_format_tab
  FROM
    NM_TYPE_COLUMNS ntc
  WHERE
    ntc.ntc_nt_type = pi_ne_nt_type
  AND
    ntc.ntc_unique_seq IS NOT NULL
  AND
    ntc.ntc_unique_format IS NOT NULL;

  IF l_col_names_tab.COUNT > 0
  THEN
    --create plsql block
    g_tab_vc.DELETE;
    append('DECLARE', FALSE);
    append('  l_sql nm3type.max_varchar2;');
    append('BEGIN');
    append('  NULL;');

    FOR l_i IN 1..l_col_names_tab.COUNT
    LOOP
      l_global_field := g_package_name || '.g_dyn_ne_flex_cols_rec.' || l_col_names_tab(l_i);

      append('  l_sql := ''SELECT ' || Nm3flx.repl_quotes_amps_for_dyn_sql(p_text_in => l_col_unique_format_tab(l_i)) || ' FROM dual'';');
      append('  EXECUTE IMMEDIATE l_sql INTO ' || l_global_field || ' USING ' || l_global_field || ';');
    END LOOP;

    append('END;');

    --set dyn rec to in arg
    g_dyn_ne_flex_cols_rec := pio_ne_flex_cols_rec;

    --run block
    Nm3ddl.execute_tab_varchar(p_tab_varchar => g_tab_vc);

    --set out arg to dyn rec
    pio_ne_flex_cols_rec := g_dyn_ne_flex_cols_rec;
  END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_unique_formatted_flex_cols');

END get_unique_formatted_flex_cols;
--
-----------------------------------------------------------------------------
--
FUNCTION all_bind_vars_ne_cols(pi_string IN VARCHAR2
                              ) RETURN BOOLEAN IS

  l_bvs_tab Nm3type.tab_varchar80;

  l_retval BOOLEAN := TRUE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'all_bind_vars_ne_cols');

  l_bvs_tab := Nm3flx.extract_all_bind_variables(pi_string => pi_string);

  FOR l_i IN 1..l_bvs_tab.COUNT
  LOOP
    l_retval := is_nm_elements_col(p_column => UPPER(REPLACE(l_bvs_tab(l_i), ':', '')));
    EXIT WHEN NOT l_retval;
  END LOOP;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'all_bind_vars_ne_cols');

  RETURN l_retval;

END all_bind_vars_ne_cols;
--
-----------------------------------------------------------------------------
--
PROCEDURE ntc_before_iud_row_trg(pi_ntc_old_rec IN NM_TYPE_COLUMNS%ROWTYPE
                                ,pi_ntc_new_rec IN NM_TYPE_COLUMNS%ROWTYPE
                                ,pi_db_action   IN VARCHAR2
                                ) IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ntc_before_iud_row_trg');

  IF pi_db_action IN (Nm3type.c_inserting, Nm3type.c_updating)
  THEN
    -----------------------------------------------------------------
    --check all bind variables in ntc_default are nm_elements columns
    -----------------------------------------------------------------
    IF NOT all_bind_vars_ne_cols(pi_string => pi_ntc_new_rec.ntc_default)
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 354
                   ,pi_supplementary_info => pi_ntc_new_rec.ntc_nt_type
                                             || ':' || pi_ntc_new_rec.ntc_column_name
                                             || ':NTC_DEFAULT');
    END IF;

    -----------------------------------------------------------------------
    --check all bind variables in ntc_unique_format are nm_elements columns
    -----------------------------------------------------------------------
    IF NOT all_bind_vars_ne_cols(pi_string => pi_ntc_new_rec.ntc_unique_format)
    THEN
      Hig.raise_ner(pi_appl               => Nm3type.c_net
                   ,pi_id                 => 354
                   ,pi_supplementary_info => pi_ntc_new_rec.ntc_nt_type
                                             || ':' || pi_ntc_new_rec.ntc_column_name
                                             || ':NTC_UNIQUE_FORMAT');
    END IF;
  END IF;

  IF NOT g_processing_ntc_val_tab
  THEN
    g_ntc_val_old_tab(g_ntc_val_old_tab.COUNT + 1) := pi_ntc_old_rec;
    g_ntc_val_new_tab(g_ntc_val_new_tab.COUNT + 1) := pi_ntc_new_rec;
  END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ntc_before_iud_row_trg');

END ntc_before_iud_row_trg;
--
-----------------------------------------------------------------------------
--
PROCEDURE ntc_after_iud_stm_trg(pi_db_action IN VARCHAR2
                               ) IS

  l_inc_child BOOLEAN;

  l_bvs_tab Nm3type.tab_varchar80;

  l_col NM_TYPE_COLUMNS.ntc_column_name%TYPE;

  FUNCTION col_is_inclusion_child(pi_nt_type IN NM_TYPES.nt_type%TYPE
                                 ,pi_col     IN NM_TYPE_COLUMNS.ntc_column_name%TYPE
                                 ) RETURN BOOLEAN IS

    l_dummy PLS_INTEGER;

  BEGIN
    SELECT
      1
    INTO
      l_dummy
    FROM
      dual
    WHERE
      EXISTS(SELECT
               1
             FROM
               NM_TYPE_INCLUSION nti
             WHERE
               nti.nti_nw_child_type = pi_nt_type
             AND
               nti.nti_child_column = pi_col);

    RETURN TRUE;

  EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
      RETURN FALSE;

  END col_is_inclusion_child;

  PROCEDURE set_updatable_for_ntc(pi_ntc_rec NM_TYPE_COLUMNS%ROWTYPE
                                 ) IS

    l_updatable NM_TYPE_COLUMNS.ntc_updatable%TYPE;

    FUNCTION col_is_derived_inc_child(pi_nt_type IN NM_TYPES.nt_type%TYPE
                                     ,pi_col     IN NM_TYPE_COLUMNS.ntc_column_name%TYPE
                                     ) RETURN BOOLEAN IS

      l_dummy PLS_INTEGER;

    BEGIN
      SELECT
        1
      INTO
        l_dummy
      FROM
        dual
      WHERE
        EXISTS(SELECT
                 1
               FROM
                 NM_TYPE_COLUMNS   ntc,
                 NM_TYPE_INCLUSION nti
               WHERE
                 ntc.ntc_nt_type = pi_nt_type
               AND
                 ntc.ntc_column_name <> pi_col
               AND
                 UPPER(ntc_default) LIKE '%:' || pi_col || '%'
               AND
                 nti.nti_nw_child_type = ntc.ntc_nt_type
               AND
                 nti.nti_child_column = ntc.ntc_column_name);

      RETURN TRUE;

    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        RETURN FALSE;

    END col_is_derived_inc_child;

  BEGIN
    IF pi_ntc_rec.ntc_unique_seq IS NOT NULL
      OR l_inc_child
      OR col_is_derived_inc_child(pi_nt_type => pi_ntc_rec.ntc_nt_type
                                 ,pi_col     => pi_ntc_rec.ntc_column_name)
    THEN
      --used in unqiue, inclusion child or used in derived inclusion child
      l_updatable := 'N';
    ELSE
      l_updatable := 'Y';
    END IF;

    UPDATE
      NM_TYPE_COLUMNS ntc
    SET
      ntc.ntc_updatable = l_updatable
    WHERE
      ntc.ntc_nt_type = pi_ntc_rec.ntc_nt_type
    AND
      ntc.ntc_column_name = pi_ntc_rec.ntc_column_name;

  END set_updatable_for_ntc;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ntc_after_iud_stm_trg');

  IF NOT g_processing_ntc_val_tab
  THEN
    g_processing_ntc_val_tab := TRUE;

    IF pi_db_action IN (Nm3type.c_inserting, Nm3type.c_updating)
    THEN
      --process each row in statement
      FOR l_i IN 1..g_ntc_val_new_tab.COUNT
      LOOP

        -- GJ 12-MAY-2005
        -- Added logic to ensure that the ntc_query fits the structure
        -- required by lov's in forms such as nm0105
        --
        IF g_ntc_val_new_tab(l_i).ntc_query IS NOT NULL THEN
           Nm3flx.validate_ntc_query(pi_query           => g_ntc_val_new_tab(l_i).ntc_query
                                    ,pi_ntc_nt_type        => g_ntc_val_new_tab(l_i).ntc_nt_type
                                    ,pi_ntc_column_name => g_ntc_val_new_tab(l_i).ntc_column_name);

        END IF;

        l_inc_child := col_is_inclusion_child(pi_nt_type => g_ntc_val_new_tab(l_i).ntc_nt_type
                                             ,pi_col     => g_ntc_val_new_tab(l_i).ntc_column_name);

        --set the updatable flag for this record
        set_updatable_for_ntc(pi_ntc_rec => g_ntc_val_new_tab(l_i));

        --set updatable for other records
        IF l_inc_child
          AND g_ntc_val_new_tab(l_i).ntc_default IS NOT NULL
        THEN
          --if we are autoinclude child, set updatable for other cols bound in this default
          l_bvs_tab := Nm3flx.extract_all_bind_variables(pi_string => g_ntc_val_new_tab(l_i).ntc_default);

          FOR l_j IN 1..l_bvs_tab.COUNT
          LOOP
            l_col := REPLACE(l_bvs_tab(l_j), ':', '');

            IF l_col <> g_ntc_val_new_tab(l_i).ntc_column_name
            THEN
              set_updatable_for_ntc(pi_ntc_rec => Nm3get.get_ntc(pi_ntc_nt_type     => g_ntc_val_new_tab(l_i).ntc_nt_type
                                                                ,pi_ntc_column_name => l_col));
            END IF;
          END LOOP;
        END IF;


      END LOOP;
    END IF;

    g_processing_ntc_val_tab := FALSE;
  END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ntc_after_iud_stm_trg');

EXCEPTION
  WHEN OTHERS
  THEN
    g_processing_ntc_val_tab := FALSE;
    RAISE;

END ntc_after_iud_stm_trg;
--
-----------------------------------------------------------------------------
--
PROCEDURE ntc_before_iud_stm_trg(pi_db_action IN VARCHAR2
                                ) IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'ntc_before_iud_stm_trg');

  IF NOT g_processing_ntc_val_tab
  THEN
    g_ntc_val_old_tab.DELETE;
    g_ntc_val_new_tab.DELETE;
  END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'ntc_before_iud_stm_trg');

END ntc_before_iud_stm_trg;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_ne_flex_cols_updatable(pi_ne_nt_type           IN nm_elements.ne_nt_type%TYPE
                                      ,pi_old_ne_flex_cols_rec IN t_ne_flex_cols_rec
                                      ,pi_new_ne_flex_cols_rec IN t_ne_flex_cols_rec
                                      ) IS

  l_plsql Nm3type.max_varchar2;
  -- Bulk network update changes
  -- Added this code to ignore the not updateable flag
  -- when updated from nm3_bulk_attrib_upd
  CURSOR c_get_nav(qp_nt_type  nm_attrib_view_vw.nav_nt_type%TYPE
                  ,qp_col_name nm_attrib_view_vw.nav_col_name%TYPE)
  IS 
  SELECT 'x'
  FROM   nm_attrib_view_vw 
  WHERE  nav_nt_type       = qp_nt_type
  AND    nav_col_name      = qp_col_name 
  AND    nav_col_updatable = 'Y' ;
  l_found Varchar2(1);
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'check_ne_flex_cols_updatable');

  g_dyn_ne_flex_cols_old_rec := pi_old_ne_flex_cols_rec;
  g_dyn_ne_flex_cols_new_rec := pi_new_ne_flex_cols_rec;

  FOR l_rec IN cs_ntc(c_nt_type => pi_ne_nt_type)
  LOOP
      
    IF l_rec.ntc_updatable = 'N'
    THEN
        IF nm3_bulk_attrib_upd.l_allow_attrib_upd = 'Y'
        THEN
            OPEN  c_get_nav(l_rec.ntc_nt_type,l_rec.ntc_column_name);
            FETCH c_get_nav INTO l_found;
            IF  c_get_nav%NOTFOUND  
            THEN
                CLOSE c_get_nav;
                l_plsql :=            'BEGIN'
                        || c_nl || '  nm3nwval.g_dyn_vals_different := NVL(RTRIM(nm3nwval.g_dyn_ne_flex_cols_old_rec.' || l_rec.ntc_column_name || '), nm3type.c_nvl) <> NVL(RTRIM(nm3nwval.g_dyn_ne_flex_cols_new_rec.' || l_rec.ntc_column_name || '), nm3type.c_nvl);'
                        || c_nl || 'END;';

                EXECUTE IMMEDIATE l_plsql;
                IF g_dyn_vals_different
                THEN
                    Hig.raise_ner(pi_appl               => Nm3type.c_net
                                 ,pi_id                 => 338
                                 ,pi_supplementary_info => l_rec.ntc_prompt);
           
               END IF;
            ELSE
                CLOSE c_get_nav;
            END IF ;
        ELSE
            l_plsql :=            'BEGIN'
                    || c_nl || '  nm3nwval.g_dyn_vals_different := NVL(RTRIM(nm3nwval.g_dyn_ne_flex_cols_old_rec.' || l_rec.ntc_column_name || '), nm3type.c_nvl) <> NVL(RTRIM(nm3nwval.g_dyn_ne_flex_cols_new_rec.' || l_rec.ntc_column_name || '), nm3type.c_nvl);'
                    || c_nl || 'END;';

            EXECUTE IMMEDIATE l_plsql;
            IF g_dyn_vals_different
            THEN
                Hig.raise_ner(pi_appl               => Nm3type.c_net
                             ,pi_id                 => 338
                             ,pi_supplementary_info => l_rec.ntc_prompt);
           
            END IF;
        END IF ;
    END IF;
  END LOOP;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'check_ne_flex_cols_updatable');

END check_ne_flex_cols_updatable;


FUNCTION check_asset_closure_on_element (
   pi_ne_id   IN nm_elements.ne_id%TYPE)
   RETURN BOOLEAN
IS
   l_dummy   INTEGER := 0;
   retval    BOOLEAN;
BEGIN
   BEGIN
      SELECT 1
        INTO l_dummy
        FROM DUAL
       WHERE EXISTS
                (SELECT i.nm_obj_type
                   FROM nm_members i
                  WHERE     nm_type = 'I'
                        AND nm_ne_id_of IN (    SELECT m.nm_ne_id_of
                                                  FROM nm_members m
                                            CONNECT BY PRIOR nm_ne_id_in =
                                                          nm_ne_id_of
                                            START WITH nm_ne_id_in = pi_ne_id
                                            UNION
                                            SELECT ne_id
                                              FROM nm_elements
                                             WHERE ne_id = pi_ne_id)
                        AND (   (NOT EXISTS
                                    (SELECT 1
                                       FROM v_nm_user_inv_mode
                                      WHERE inv_type = nm_obj_type)) -- asset type is invisible through roles
                             OR (EXISTS
                                    (SELECT 1
                                       FROM nm_inv_types, v_nm_user_inv_mode
                                      WHERE     inv_type = nm_obj_type
                                            AND inv_type = nit_inv_type
                                            AND access_mode = 'READONLY'
                                            AND nit_end_loc_only = 'N'))
                             OR (EXISTS
                                    (SELECT 1
                                       FROM nm_inv_types, v_nm_user_au_mode
                                      WHERE     admin_unit = nm_admin_unit
                                            AND access_mode = 'READONLY'
                                            AND nit_inv_type = nm_obj_type
                                            AND nit_end_loc_only = 'N'))));

      retval := FALSE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         retval := TRUE;
   END;

   RETURN retval;
END;

--
-----------------------------------------------------------------------------
--
BEGIN
--
   OPEN  cs_cols_in_elements (Sys_Context('NM3CORE','APPLICATION_OWNER'), 'NM_ELEMENTS_ALL');
   FETCH cs_cols_in_elements BULK COLLECT INTO g_tab_nm_elements_cols;
   CLOSE cs_cols_in_elements;
--
END Nm3nwval;
/
