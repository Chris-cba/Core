create or replace package body nm3mrg_output as
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg_output.pkb-arc   2.4   Oct 07 2011 14:41:48   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3mrg_output.pkb  $
--       Date into PVCS   : $Date:   Oct 07 2011 14:41:48  $
--       Date fetched Out : $Modtime:   Oct 07 2011 14:41:38  $
--       Version          : $Revision:   2.4  $
--       Based on SCCS version : 1.22
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 Merge Output body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.4  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3mrg_output';
--
--
   g_mrg_output_exception EXCEPTION;
   g_mrg_output_exc_code  NUMBER;
   g_mrg_output_exc_msg   VARCHAR2(4000);
--
   g_rec_nmf nm_mrg_output_file%ROWTYPE;
   g_rec_nqr nm_mrg_query_results%ROWTYPE;
--
   g_tab_nmf_changed  nm3type.tab_number;
--
   CURSOR cs_nmc (c_nmc_nmf_id nm_mrg_output_cols.nmc_nmf_id%TYPE) IS
   SELECT *
    FROM  nm_mrg_output_cols
   WHERE  nmc_nmf_id = c_nmc_nmf_id
   ORDER BY nmc_seq_no;
--
   CURSOR cs_inst IS
   SELECT *
    FROM  v$instance;
--
   CURSOR cs_decodes (c_nmf_id NUMBER
                     ,c_seq_no NUMBER
                     ) IS
   SELECT nmcd_from_value
         ,nmcd_to_value
     FROM nm_mrg_output_col_decode
   WHERE  nmcd_nmf_id     = c_nmf_id
    AND   nmcd_nmc_seq_no = c_seq_no;
--
   l_tab_from_value nm3type.tab_varchar32767;
   l_tab_to_value   nm3type.tab_varchar32767;
--
   l_inst v$instance%ROWTYPE;
--
   g_do_txt BOOLEAN := TRUE;
   g_do_csv BOOLEAN := FALSE;
   g_do_htm BOOLEAN := FALSE;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_column_name (p_col_name IN OUT VARCHAR2, p_seq_no NUMBER);
FUNCTION get_column_name (p_col_name VARCHAR2, p_seq_no NUMBER) RETURN VARCHAR2;
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
FUNCTION get_cols_for_query (p_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN nm3type.tab_varchar30 IS
--
   CURSOR cs_av (p_view_name VARCHAR2) IS
   SELECT column_name
    FROM  all_tab_columns
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = p_view_name
   ORDER BY column_id;
--
   l_tab_col nm3type.tab_varchar30;
--
BEGIN
--
   FOR cs_rec IN cs_av (nm3mrg_view.get_mrg_view_name_by_qry_id(p_nmq_id)||'_VAL')
    LOOP
      IF cs_rec.column_name NOT LIKE 'NMS%'
       THEN
         l_tab_col(l_tab_col.COUNT+1) := cs_rec.column_name;
      END IF;
   END LOOP;
--
   RETURN l_tab_col;
--
END get_cols_for_query;
--
-----------------------------------------------------------------------------
--
FUNCTION col_ok_for_query (p_nmq_id   nm_mrg_query.nmq_id%TYPE
                          ,p_col_name VARCHAR2
                          ) RETURN BOOLEAN IS
--
   l_tab_col nm3type.tab_varchar30 := get_cols_for_query(p_nmq_id);
--
   l_ok BOOLEAN := FALSE;
--
BEGIN
--
   FOR i IN 1..l_tab_col.COUNT
    LOOP
      IF p_col_name = l_tab_col(i)
       THEN
         l_ok := TRUE;
         EXIT;
      END IF;
   END LOOP;
--
   RETURN l_ok;
--
END col_ok_for_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmf (p_nmf_id nm_mrg_output_file.nmf_id%TYPE) RETURN nm_mrg_output_file%ROWTYPE IS
--
   CURSOR cs_nmf (c_nmf_id nm_mrg_output_file.nmf_id%TYPE) IS
   SELECT *
    FROM  nm_mrg_output_file
   WHERE  nmf_id = c_nmf_id;
--
   l_rec_nmf nm_mrg_output_file%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nmf (p_nmf_id);
   FETCH cs_nmf INTO l_rec_nmf;
   IF cs_nmf%NOTFOUND
    THEN
      g_mrg_output_exc_code := -20881;
      g_mrg_output_exc_msg  := 'NM_MRG_OUTPUT_FILE record not found';
      RAISE g_mrg_output_exception;
   END IF;
   CLOSE cs_nmf;
--
   RETURN l_rec_nmf;
--
EXCEPTION
--
   WHEN g_mrg_output_exception
    THEN
      RAISE_APPLICATION_ERROR(g_mrg_output_exc_code,g_mrg_output_exc_msg);
--
END get_nmf;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmf (p_nmq_id       nm_mrg_output_file.nmf_nmq_id%TYPE
                 ,p_nmf_filename nm_mrg_output_file.nmf_filename%TYPE
                 ) RETURN nm_mrg_output_file%ROWTYPE IS
--
   CURSOR cs_nmf (c_nmq_id       nm_mrg_output_file.nmf_nmq_id%TYPE
                 ,c_nmf_filename nm_mrg_output_file.nmf_filename%TYPE
                 ) IS
   SELECT *
    FROM  nm_mrg_output_file
   WHERE  nmf_nmq_id   = c_nmq_id
    AND   nmf_filename = c_nmf_filename;
--
   l_rec_nmf nm_mrg_output_file%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nmf (p_nmq_id,p_nmf_filename);
   FETCH cs_nmf INTO l_rec_nmf;
   IF cs_nmf%NOTFOUND
    THEN
      g_mrg_output_exc_code := -20881;
      g_mrg_output_exc_msg  := 'NM_MRG_OUTPUT_FILE record not found';
      RAISE g_mrg_output_exception;
   END IF;
   CLOSE cs_nmf;
--
   RETURN l_rec_nmf;
--
EXCEPTION
--
   WHEN g_mrg_output_exception
    THEN
      RAISE_APPLICATION_ERROR(g_mrg_output_exc_code,g_mrg_output_exc_msg);
--
END get_nmf;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_sql (p_nqr_id nm_mrg_query_results.nqr_mrg_job_id%TYPE
                    ,p_nmf_id nm_mrg_output_file.nmf_id%TYPE
                    ) IS
--
   l_sep VARCHAR2(20) := 'SELECT ';
--
   l_view_name VARCHAR2(30);
--
   l_nmc_found BOOLEAN := FALSE;
   l_nvl_char  VARCHAR2(1);
--
   l_column_name VARCHAR2(4000);
--
   l_pad       VARCHAR2(4);
--
   PROCEDURE append (p_text VARCHAR2) IS
   BEGIN
      IF LENGTH(g_sql) + LENGTH(p_text) > 32767
       THEN
         g_mrg_output_exc_code := -20885;
         g_mrg_output_exc_msg  := 'Query string is too large >32K';
         RAISE g_mrg_output_exception;
      END IF;
      g_sql := g_sql||p_text;
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_sql');
--
   g_rec_nmf   := get_nmf(p_nmf_id);
--
   g_sql       := Null;
--
   l_view_name := nm3mrg_view.get_mrg_view_name_by_qry_id(g_rec_nmf.nmf_nmq_id);
--
   IF g_rec_nmf.nmf_csv = 'Y'
    THEN
      l_sep := l_sep||'"';
      FOR cs_rec IN cs_nmc(p_nmf_id)
       LOOP
         append (l_sep||cs_rec.nmc_column_name);
         l_sep       := '"'||CHR(10)||'     '||g_rec_nmf.nmf_sep_char||'"';
         l_nmc_found := TRUE;
      END LOOP;
   ELSE
      FOR cs_rec IN cs_nmc(p_nmf_id)
       LOOP
         --
         l_column_name := Null;
         --
         l_tab_from_value.DELETE;
         l_tab_to_value.DELETE;
         --
         OPEN  cs_decodes (p_nmf_id, cs_rec.nmc_seq_no);
         FETCH cs_decodes BULK COLLECT INTO l_tab_from_value,l_tab_to_value;
         CLOSE cs_decodes;
         --
         IF l_tab_from_value.COUNT = 0
          THEN
            -- There is no decoding, bang out as is
            l_column_name := cs_rec.nmc_column_name;
         ELSE
            -- There is a decode, build up the string
            l_column_name := 'DECODE('||cs_rec.nmc_column_name;
            FOR i IN 1..l_tab_from_value.COUNT
             LOOP
               l_column_name := l_column_name||','||nm3flx.string(l_tab_from_value(i))||','||nm3flx.string(l_tab_to_value(i));
            END LOOP;
            l_column_name := l_column_name||','||cs_rec.nmc_column_name||')';
         END IF;
         --
         IF cs_rec.nmc_data_type = nm3type.c_varchar
          THEN
           l_pad := 'RPAD';
         ELSE
           l_pad := 'LPAD';
         END IF;
         append (l_sep||l_pad||'(SUBSTR(NVL(');
         IF cs_rec.nmc_data_type = nm3type.c_date
          THEN
            append ('TO_CHAR('||l_column_name||','||nm3flx.string(g_rec_nmf.nmf_date_format)||')');
            l_nvl_char := g_rec_nmf.nmf_number_lpad;
         ELSIF cs_rec.nmc_data_type = nm3type.c_number
          THEN
            l_nvl_char := g_rec_nmf.nmf_number_lpad;
            DECLARE
               l_format VARCHAR2(100);
            BEGIN
               IF cs_rec.nmc_pad = 'Y'
                THEN
                  IF cs_rec.nmc_dec_places != 0
                   THEN
                     l_format := RPAD(g_rec_nmf.nmf_number_lpad,cs_rec.nmc_dec_places,g_rec_nmf.nmf_number_lpad);
                  END IF;
                  IF cs_rec.nmc_disp_dp = 'Y'
                   THEN
                     l_format := '.'||l_format;
                  -- Log 698292 Commented multiplication of decimal value
                  --ELSIF cs_rec.nmc_dec_places != 0
                  -- THEN
                  --   l_column_name := 'TRUNC('||l_column_name||'*'||cs_rec.nmc_dec_places||')';
                  END IF;
                  l_format := LPAD(NVL(l_format,g_rec_nmf.nmf_number_lpad),cs_rec.nmc_length,g_rec_nmf.nmf_number_lpad);
                  append ('LTRIM(TO_CHAR('||l_column_name||','||nm3flx.string(l_format)||'),'||nm3flx.string(' ')||')');
               ELSE
                  append (l_column_name);
               END IF;
            END;
         ELSE
            l_nvl_char := g_rec_nmf.nmf_varchar_rpad;
            IF cs_rec.nmc_pad = 'Y'
             THEN
               append ('RPAD('||l_column_name||','||cs_rec.nmc_length||','||nm3flx.string(g_rec_nmf.nmf_varchar_rpad)||')');
            ELSE
               append (l_column_name);
            END IF;
         END IF;
         append (','||nm3flx.string(l_nvl_char)||'),1,'||cs_rec.nmc_length||'),'||cs_rec.nmc_length||','||nm3flx.string(l_nvl_char)||')');
         l_sep := CHR(10)||'     ||';
         l_nmc_found := TRUE;
      END LOOP;
   END IF;
--
   IF NOT l_nmc_found
    THEN
      g_mrg_output_exc_code := -20883;
      g_mrg_output_exc_msg  := 'No NM_MRG_OUTPUT_COLS records defined';
      RAISE g_mrg_output_exception;
   END IF;
--
   append ('             big_col');

   IF g_rec_nmf.nmf_datum = 'Y'
    THEN
      --SSCANLON FIX LOG 706744 22MAR2007
      --nm3mrg_view.pkb automatically creates the view which is being referenced in this package as l_view_name.
      --nm3mrg_view.pkb has been altered and names the ID column in this view as nqr_mrg_job_id (previously it
      --was named nms_mrg_job_id).  This change has now been reflected in the dynamic SQL below.
      append (CHR(10)||' FROM '||l_view_name
            --||CHR(10)||'WHERE nms_mrg_job_id     = '||p_nqr_id   --line commented out SSCANLON FIX LOG 706744 22MAR2007
            ||CHR(10)||'WHERE nqr_mrg_job_id     = '||p_nqr_id     --line added SSCANLON FIX LOG 706744 22MAR2007
             );
      --/SSCANLON FIX LOG 706744 22MAR2007
   ELSE
      append (CHR(10)||' FROM '||l_view_name||'_SEC sec, '||l_view_name||'_VAL val'
            ||CHR(10)||'WHERE sec.nqr_mrg_job_id     = '||p_nqr_id
            ||CHR(10)||' AND  sec.nqr_mrg_job_id     = val.nms_mrg_job_id'
            ||CHR(10)||' AND  sec.nms_mrg_section_id = val.nms_mrg_section_id'
             );
   END IF;
--
   IF g_rec_nmf.nmf_additional_where IS NOT NULL
    THEN
      append (CHR(10)||' AND  '||g_rec_nmf.nmf_additional_where);
   END IF;
   append (CHR(10)||'ORDER BY 1');
--
   nm_debug.proc_end(g_package_name,'build_sql');
--
END build_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION validate_file (p_nmf_id nm_mrg_output_file.nmf_id%TYPE) RETURN VARCHAR2 IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_file');
--
   validate_file (p_nmf_id);
--
   nm_debug.proc_end(g_package_name,'validate_file');
--
   RETURN g_sql;
--
END validate_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_file (p_nmf_id nm_mrg_output_file.nmf_id%TYPE) IS
--
   l_last_rec_nmc nm_mrg_output_cols%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_file');
--
   build_sql (-1, p_nmf_id);
--
   DECLARE
      l_cur  nm3type.ref_cursor;
      l_data nm3type.max_varchar2;
   BEGIN
      OPEN  l_cur FOR  g_sql;
      FETCH l_cur INTO l_data;
      CLOSE l_cur;
   EXCEPTION
      WHEN others
       THEN
         IF l_cur%ISOPEN
          THEN
            CLOSE l_cur;
         END IF;
         g_mrg_output_exc_code := -20884;
         g_mrg_output_exc_msg  := SQLERRM;
         RAISE g_mrg_output_exception;
   END;
--
   l_last_rec_nmc.nmc_seq_no := 0;
   l_last_rec_nmc.nmc_length := 1;
--
   FOR cs_rec IN cs_nmc (p_nmf_id)
    LOOP
      IF cs_rec.nmc_seq_no != (l_last_rec_nmc.nmc_seq_no + l_last_rec_nmc.nmc_length)
       THEN
         g_mrg_output_exc_code := -20885;
         g_mrg_output_exc_msg  := 'Sequence Numbers do not follow sequentially ('||cs_rec.nmc_seq_no||')';
         RAISE g_mrg_output_exception;
      END IF;
      l_last_rec_nmc := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'validate_file');
--
EXCEPTION
--
   WHEN g_mrg_output_exception
    THEN
      RAISE_APPLICATION_ERROR(g_mrg_output_exc_code,g_mrg_output_exc_msg);
--
END validate_file;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_results (p_nqr_id                 nm_mrg_query_results.nqr_mrg_job_id%TYPE
                        ,p_nmf_id                 nm_mrg_output_file.nmf_id%TYPE
                        ,p_prefix                 VARCHAR2
                        ,p_suppress_file_creation BOOLEAN DEFAULT FALSE
                        ,p_produce_server_file    BOOLEAN DEFAULT TRUE
                        ,p_produce_client_file    BOOLEAN DEFAULT FALSE
                        ) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'write_results');
--
   move_data_to_arrays (p_nqr_id => p_nqr_id
                       ,p_nmf_id => p_nmf_id
                       ,p_prefix => p_prefix
                       );
   write_arrays (p_nmf_id     => p_nmf_id
                ,p_prefix     => p_prefix
                ,p_write_txt  => g_do_txt AND (NOT (p_suppress_file_creation))
                ,p_write_csv  => g_do_csv AND (NOT (p_suppress_file_creation))
                ,p_write_html => g_do_htm AND (NOT (p_suppress_file_creation))
                ,p_produce_server_file => p_produce_server_file
                ,p_produce_client_file => p_produce_client_file
                );
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'write_results');
--
EXCEPTION
--
   WHEN g_mrg_output_exception
    THEN
      RAISE_APPLICATION_ERROR(g_mrg_output_exc_code,g_mrg_output_exc_msg);
--
END write_results;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_merge_def (p_nmq_id   IN nm_mrg_query.nmq_id%TYPE
                         ,p_filename IN VARCHAR2 DEFAULT NULL
                         ,p_location IN VARCHAR2 DEFAULT nm3file.c_default_location
                         ) IS
--
   l_lines nm3type.tab_varchar32767;
--
   l_rec_nmq nm_mrg_query%ROWTYPE := nm3mrg_supplementary.select_mrg_query(p_nmq_id);
--
   l_filename VARCHAR2(100) := NVL(p_filename,LOWER(l_rec_nmq.nmq_unique)||'_merge_defn.sql');
--
   c_date_format CONSTANT VARCHAR2(40) := 'DD-Mon-YYYY HH24:MI:SS';
--
   l_got_qry_roles BOOLEAN := FALSE;
--
   c_pct           CONSTANT VARCHAR2(1) := CHR(37);
--
   CURSOR cs_nmc (c_nmf_id NUMBER) IS
   SELECT *
    FROM  nm_mrg_output_cols
   WHERE  nmc_nmf_id = c_nmf_id
   ORDER BY nmc_seq_no;
--
   CURSOR cs_nmcd (c_nmf_id NUMBER
                  ,c_seq_no NUMBER
                  ) IS
   SELECT *
    FROM  nm_mrg_output_col_decode
   WHERE  nmcd_nmf_id     = c_nmf_id
    AND   nmcd_nmc_seq_no = c_seq_no;
--
   PROCEDURE line_write (p_line VARCHAR2) IS
   BEGIN
      l_lines(l_lines.COUNT+1) := p_line;
   END line_write;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'dump_merge_def');
--
   OPEN  cs_inst;
   FETCH cs_inst INTO l_inst;
   CLOSE cs_inst;
--
   line_write('PROMPT Creating Merge Query - '||l_rec_nmq.nmq_unique);
   line_write('DECLARE');
   line_write('--');
   line_write('-----------------------------------------------------------------------------');
   line_write('--');
   line_write('--   SCCS Identifiers :-');
   line_write('--');
   line_write('--       sccsid           : '||c_pct||'W'||c_pct||' '||c_pct||'G'||c_pct);
   line_write('--       Module Name      : '||c_pct||'M'||c_pct);
   line_write('--       Date into SCCS   : '||c_pct||'E'||c_pct||' '||c_pct||'U'||c_pct);
   line_write('--       Date fetched Out : '||c_pct||'D'||c_pct||' '||c_pct||'T'||c_pct);
   line_write('--       SCCS Version     : '||c_pct||'I'||c_pct);
   line_write('--');
   line_write('--  '||l_rec_nmq.nmq_unique);
   line_write('--');
   line_write('--  Generated from instance '||l_inst.instance_name||'@'||l_inst.host_name||' - DB ver : '||l_inst.version);
   line_write('--');
   line_write('--  '||to_char(sysdate,c_date_format));
   line_write('--');
   line_write('--  '||g_package_name||' header : '||get_version);
   line_write('--  '||g_package_name||' body   : '||get_body_version);
   line_write('--');
   line_write('-----------------------------------------------------------------------------');
   line_write('--	Copyright (c) exor corporation ltd, 2001');
   line_write('-----------------------------------------------------------------------------');
   line_write('--');
   line_write('   g_nmq_id      CONSTANT nm_mrg_query.nmq_id%TYPE     := nm3mrg.get_nmq_id;');
   line_write('   c_nmq_unique  CONSTANT nm_mrg_query.nmq_unique%TYPE := '||nm3flx.string(l_rec_nmq.nmq_unique)||';');
   line_write('--');
   line_write('   g_nqt_seq_no           NUMBER;');
   line_write('   g_inv_type             nm_inv_type_attribs.ita_inv_type%TYPE;');
   line_write('   g_attrib_name          nm_inv_type_attribs.ita_attrib_name%TYPE;');
   line_write('--');
   line_write('   l_rec_nmf              nm_mrg_output_file%ROWTYPE;');
   line_write('   l_rec_nmc              nm_mrg_output_cols%ROWTYPE;');
   line_write('   l_rec_nmcd             nm_mrg_output_col_decode%ROWTYPE;');
   line_write('--');
   line_write('   PROCEDURE insert_nqro (p_role VARCHAR2');
   line_write('                         ,p_mode VARCHAR2');
   line_write('                         ) IS');
   line_write('   BEGIN');
   line_write('      INSERT INTO nm_mrg_query_roles');
   line_write('             (nqro_nmq_id');
   line_write('             ,nqro_role');
   line_write('             ,nqro_mode');
   line_write('             )');
   line_write('      VALUES (g_nmq_id');
   line_write('             ,p_role');
   line_write('             ,p_mode');
   line_write('             );');
   line_write('   EXCEPTION');
   line_write('      WHEN others THEN Null;');
   line_write('   END insert_nqro;');
   line_write('--');
   line_write('   PROCEDURE insert_nqt (p_inv_type VARCHAR2');
   line_write('                        ,p_x_sect   VARCHAR2');
   line_write('                        ,p_default  VARCHAR2 DEFAULT '||nm3flx.string('N'));
   line_write('                        ) IS');
   line_write('      l_rec_nqt nm_mrg_query_types%ROWTYPE;');
   line_write('   BEGIN');
   line_write('      g_inv_type             := p_inv_type;');
   line_write('      l_rec_nqt.nqt_nmq_id   := g_nmq_id;');
   line_write('      l_rec_nqt.nqt_seq_no   := nm3seq.next_nqt_seq_no_seq;');
   line_write('      l_rec_nqt.nqt_inv_type := g_inv_type;');
   line_write('      l_rec_nqt.nqt_x_sect   := p_x_sect;');
   line_write('      l_rec_nqt.nqt_default  := p_default;');
   line_write('      g_nqt_seq_no           := l_rec_nqt.nqt_seq_no;');
   line_write('      nm3ins.ins_nmqt (l_rec_nqt);');
   line_write('   END insert_nqt;');
   line_write('--');
   line_write('   PROCEDURE insert_nqa (p_view_col  VARCHAR2');
   line_write('                        ,p_condition VARCHAR2');
   line_write('                        ) IS');
   line_write('      l_rec_nqa nm_mrg_query_attribs%ROWTYPE;');
   line_write('   BEGIN');
   line_write('      g_attrib_name := Null;');
   line_write('      g_attrib_name := nm3get.get_hco (pi_hco_domain      => nm3gaz_qry.c_fixed_cols_domain_inv');
   line_write('                                      ,pi_hco_code        => p_view_col');
   line_write('                                      ,pi_raise_not_found => FALSE');
   line_write('                                      ).hco_code;');
   line_write('      IF g_attrib_name IS NULL');
   line_write('       THEN');
   line_write('         g_attrib_name := nm3get.get_ita_all (pi_ita_inv_type      => g_inv_type');
   line_write('                                             ,pi_ita_view_col_name => p_view_col');
   line_write('                                             ).ita_attrib_name;');
   line_write('      END IF;');
   line_write('      l_rec_nqa.nqa_nmq_id         := g_nmq_id;');
   line_write('      l_rec_nqa.nqa_nqt_seq_no     := g_nqt_seq_no;');
   line_write('      l_rec_nqa.nqa_attrib_name    := g_attrib_name;');
   line_write('      l_rec_nqa.nqa_condition      := p_condition;');
   line_write('      l_rec_nqa.nqa_itb_banding_id := Null;');
   line_write('      nm3ins.ins_nmqa (l_rec_nqa);');
   line_write('   END insert_nqa;');
   line_write('--');
   line_write('   PROCEDURE lock_and_del_nmq (p_nmq_unique VARCHAR2) IS');
   line_write('      l_nmq_rowid ROWID;');
   line_write('   BEGIN');
   line_write('      l_nmq_rowid := nm3lock_gen.lock_nmq (pi_nmq_unique      => p_nmq_unique');
   line_write('                                          ,pi_raise_not_found => FALSE');
   line_write('                                          );');
   line_write('      DELETE FROM nm_mrg_query_all');
   line_write('      WHERE  ROWID = l_nmq_rowid;');
   line_write('   END lock_and_del_nmq;');
   line_write('--');
--
   FOR cs_rec IN (SELECT 1
                   FROM  dual
                  WHERE EXISTS (SELECT *
                                 FROM  nm_mrg_query_values
                                WHERE  nqv_nmq_id = p_nmq_id
                               )
                 )
    LOOP
      line_write('   PROCEDURE insert_nqv (p_seq   NUMBER');
      line_write('                        ,p_value VARCHAR2');
      line_write('                        ) IS');
      line_write('      l_rec_nqv nm_mrg_query_values%ROWTYPE;');
      line_write('   BEGIN');
      line_write('      l_rec_nqv.nqv_nmq_id      := g_nmq_id;');
      line_write('      l_rec_nqv.nqv_nqt_seq_no  := g_nqt_seq_no;');
      line_write('      l_rec_nqv.nqv_attrib_name := g_attrib_name;');
      line_write('      l_rec_nqv.nqv_sequence    := p_seq;');
      line_write('      l_rec_nqv.nqv_value       := p_value;');
      line_write('      nm3ins.ins_nmqv (l_rec_nqv);');
      line_write('   END insert_nqv;');
      line_write('--');
   END LOOP;
--
   line_write('BEGIN');
   line_write('--');
   line_write('   lock_and_del_nmq (c_nmq_unique);');
   line_write('--');
   line_write('   INSERT INTO nm_mrg_query ');
   line_write('          (nmq_id');
   line_write('          ,nmq_unique');
   line_write('          ,nmq_descr');
   line_write('          ,nmq_inner_outer_join');
   line_write('          ,nmq_transient_query');
   line_write('          )');
   line_write('   VALUES (g_nmq_id');
   line_write('          ,c_nmq_unique');
   line_write('          ,'||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(l_rec_nmq.nmq_descr)));
   line_write('          ,'||nm3flx.string(l_rec_nmq.nmq_inner_outer_join));
   line_write('          ,'||nm3flx.string(l_rec_nmq.nmq_transient_query));
   line_write('          );');
   line_write('--');
   FOR cs_nqro IN (SELECT *
                    FROM  nm_mrg_query_roles
                   WHERE  nqro_nmq_id = p_nmq_id
                  )
    LOOP
      l_got_qry_roles := TRUE;
      line_write('   insert_nqro ('||nm3flx.string(cs_nqro.nqro_role)||','||nm3flx.string(cs_nqro.nqro_mode)||');');
      line_write('--');
   END LOOP;
   --
   line_write('   nm3mrg_security.reset_security_state_for_nmq (pi_nmq_id => g_nmq_id);');
   line_write('--');
   --
   IF NOT l_got_qry_roles
    THEN
      line_write('   --##################################################################################');
      line_write('   -- No NM_MRG_QUERY_ROLES defined - only unrestricted users will see this query');
      line_write('   --##################################################################################');
      line_write('--');
   END IF;
--
   FOR cs_nqt IN (SELECT *
                   FROM  nm_mrg_query_types
                  WHERE  nqt_nmq_id = p_nmq_id
                 )
    LOOP
      line_write('   insert_nqt ('||nm3flx.string(cs_nqt.nqt_inv_type)||','||nm3flx.string(cs_nqt.nqt_x_sect)||','||nm3flx.string(cs_nqt.nqt_default)||');');
      line_write('--');
      FOR cs_nqa IN (SELECT *
                      FROM  nm_mrg_query_attribs
                     WHERE  nqa_nmq_id     = p_nmq_id
                      AND   nqa_nqt_seq_no = cs_nqt.nqt_seq_no
                    )
       LOOP
         IF cs_nqa.nqa_itb_banding_id IS NOT NULL
          THEN
            line_write('      --################################');
            line_write('      -- Banding_ID has been set to null');
            line_write('      --################################');
         END IF;
         line_write('      insert_nqa ('||nm3flx.string(NVL(nm3inv.get_inv_type_attr(cs_nqt.nqt_inv_type,cs_nqa.nqa_attrib_name).ita_view_col_name,cs_nqa.nqa_attrib_name))||','||nm3flx.string(cs_nqa.nqa_condition)||');');
         line_write('--');
         FOR cs_nqv IN (SELECT *
                         FROM  nm_mrg_query_values
                        WHERE  nqv_nmq_id      = cs_nqa.nqa_nmq_id
                         AND   nqv_nqt_seq_no  = cs_nqa.nqa_nqt_seq_no
                         AND   nqv_attrib_name = cs_nqa.nqa_attrib_name
                       )
          LOOP
            line_write('         insert_nqv ('||nm3flx.string(cs_nqv.nqv_sequence)||','||nm3flx.string(cs_nqv.nqv_value)||');');
            line_write('--');
         END LOOP;
      END LOOP;
      line_write('--');
   END LOOP;
   line_write('-- Build the merge view for this one');
   line_write('   nm3mrg_view.build_view(g_nmq_id);');
   line_write('--');
--
   FOR cs_rec IN (SELECT *
                   FROM  nm_mrg_output_file
                  WHERE  nmf_nmq_id = p_nmq_id
                 )
    LOOP
--
      line_write('   l_rec_nmf.nmf_id                      := '||g_package_name||'.get_next_nmf_id;');
      line_write('   l_rec_nmf.nmf_nmq_id                  := g_nmq_id;');
      line_write('   l_rec_nmf.nmf_filename                := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_rec.nmf_filename))||';');
      line_write('   l_rec_nmf.nmf_file_path               := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_rec.nmf_file_path))||';');
      line_write('   l_rec_nmf.nmf_route                   := '||nm3flx.string(cs_rec.nmf_route)||';');
      line_write('   l_rec_nmf.nmf_datum                   := '||nm3flx.string(cs_rec.nmf_datum)||';');
      line_write('   l_rec_nmf.nmf_include_header          := '||nm3flx.string(cs_rec.nmf_include_header)||';');
      line_write('   l_rec_nmf.nmf_include_footer          := '||nm3flx.string(cs_rec.nmf_include_footer)||';');
      line_write('   l_rec_nmf.nmf_csv                     := '||nm3flx.string(cs_rec.nmf_csv)||';');
      line_write('   l_rec_nmf.nmf_sep_char                := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_rec.nmf_sep_char))||';');
      line_write('   l_rec_nmf.nmf_additional_where        := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_rec.nmf_additional_where))||';');
      line_write('   l_rec_nmf.nmf_varchar_rpad            := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_rec.nmf_varchar_rpad))||';');
      line_write('   l_rec_nmf.nmf_number_lpad             := '||nm3flx.string(cs_rec.nmf_number_lpad)||';');
      line_write('   l_rec_nmf.nmf_date_format             := '||nm3flx.string(cs_rec.nmf_date_format)||';');
      line_write('   l_rec_nmf.nmf_description             := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_rec.nmf_description))||';');
      line_write('   l_rec_nmf.nmf_template                := '||nm3flx.string(cs_rec.nmf_template)||';');
      line_write('   l_rec_nmf.nmf_append_merge_au_to_path := '||nm3flx.string(cs_rec.nmf_append_merge_au_to_path)||';');
      line_write('   '||g_package_name||'.ins_nmf (l_rec_nmf);');
      line_write('--');
      line_write('   l_rec_nmc.nmc_nmf_id           := l_rec_nmf.nmf_id;');
      line_write('   l_rec_nmcd.nmcd_nmf_id         := l_rec_nmf.nmf_id;');
      line_write('--');
--
--    Loop through all the nm_mrg_output_cols records
--
      FOR cs_cols IN cs_nmc (cs_rec.nmf_id)
       LOOP
--
         line_write('      l_rec_nmc.nmc_seq_no        := '||cs_cols.nmc_seq_no||';');
         line_write('      l_rec_nmc.nmc_length        := '||cs_cols.nmc_length||';');
         line_write('      l_rec_nmc.nmc_column_name   := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_cols.nmc_column_name))||';');
         line_write('      l_rec_nmc.nmc_sec_or_val    := '||nm3flx.string(cs_cols.nmc_sec_or_val)||';');
         line_write('      l_rec_nmc.nmc_data_type     := '||nm3flx.string(cs_cols.nmc_data_type)||';');
         line_write('      l_rec_nmc.nmc_pad           := '||nm3flx.string(cs_cols.nmc_pad)||';');
         line_write('      l_rec_nmc.nmc_dec_places    := '||NVL(TO_CHAR(cs_cols.nmc_dec_places),'Null')||';');
         line_write('      l_rec_nmc.nmc_disp_dp       := '||nm3flx.string(cs_cols.nmc_disp_dp)||';');
         line_write('      l_rec_nmc.nmc_description   := '||nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(cs_cols.nmc_description))||';');
         line_write('      l_rec_nmc.nmc_view_col_name := '||nm3flx.string(cs_cols.nmc_view_col_name)||';');
         line_write('      l_rec_nmc.nmc_order_by      := '||NVL(TO_CHAR(cs_cols.nmc_order_by),'Null')||';');
         line_write('      l_rec_nmc.nmc_order_by_ord  := '||nm3flx.string(cs_cols.nmc_order_by_ord)||';');
         line_write('      l_rec_nmc.nmc_display_sign  := '||nm3flx.string(cs_cols.nmc_display_sign)||';');
         line_write('      '||g_package_name||'.ins_nmc (l_rec_nmc);');
--
         FOR cs_decodes IN cs_nmcd (cs_rec.nmf_id,cs_cols.nmc_seq_no)
          LOOP
            line_write('         l_rec_nmcd.nmcd_nmc_seq_no := '||cs_decodes.nmcd_nmc_seq_no||';');
            line_write('         l_rec_nmcd.nmcd_from_value := '||nm3flx.string(cs_decodes.nmcd_from_value)||';');
            line_write('         l_rec_nmcd.nmcd_to_value   := '||nm3flx.string(cs_decodes.nmcd_to_value)||';');
            line_write('         '||g_package_name||'.ins_nmcd (l_rec_nmcd);');
         END LOOP;
         line_write('--');
--
      END LOOP;
--
      line_write('   COMMIT;');
      line_write('   '||g_package_name||'.create_procedure (p_nmf_id => l_rec_nmf.nmf_id);');
      line_write('--');
--
   END LOOP;
   line_write('END;');
   line_write('/');
--
   nm3file.write_file (location     => p_location
                      ,filename     => l_filename
                      ,max_linesize => 32767
                      ,all_lines    => l_lines
                      );
--
   nm_debug.proc_end(g_package_name,'dump_merge_def');
--
END dump_merge_def;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_all_merge_defs (p_location IN VARCHAR2 DEFAULT nm3file.c_default_location) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'dump_all_merge_defs');
--
   FOR cs_rec IN (SELECT nmq_id FROM nm_mrg_query)
    LOOP
      dump_merge_def(cs_rec.nmq_id,null,p_location);
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'dump_all_merge_defs');
--
END dump_all_merge_defs;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmf (p_rec_nmf nm_mrg_output_file%ROWTYPE) IS
--
   c_n CONSTANT VARCHAR2(1) := 'N';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmf');
--
   INSERT INTO nm_mrg_output_file
          (nmf_id
          ,nmf_nmq_id
          ,nmf_filename
          ,nmf_file_path
          ,nmf_route
          ,nmf_datum
          ,nmf_include_header
          ,nmf_include_footer
          ,nmf_csv
          ,nmf_sep_char
          ,nmf_additional_where
          ,nmf_varchar_rpad
          ,nmf_number_lpad
          ,nmf_date_format
          ,nmf_description
          ,nmf_template
          ,nmf_append_merge_au_to_path
          )
   VALUES (p_rec_nmf.nmf_id
          ,p_rec_nmf.nmf_nmq_id
          ,p_rec_nmf.nmf_filename
          ,p_rec_nmf.nmf_file_path
          ,NVL(p_rec_nmf.nmf_route,c_n)
          ,NVL(p_rec_nmf.nmf_datum,c_n)
          ,NVL(p_rec_nmf.nmf_include_header,c_n)
          ,NVL(p_rec_nmf.nmf_include_footer,c_n)
          ,NVL(p_rec_nmf.nmf_csv,c_n)
          ,p_rec_nmf.nmf_sep_char
          ,p_rec_nmf.nmf_additional_where
          ,p_rec_nmf.nmf_varchar_rpad
          ,p_rec_nmf.nmf_number_lpad
          ,p_rec_nmf.nmf_date_format
          ,p_rec_nmf.nmf_description
          ,NVL(p_rec_nmf.nmf_template,c_n)
          ,NVL(p_rec_nmf.nmf_append_merge_au_to_path,c_n)
          );
--
   nm_debug.proc_end(g_package_name,'ins_nmf');
--
END ins_nmf;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmc (p_rec_nmc        nm_mrg_output_cols%ROWTYPE
                  ,p_supress_dupval BOOLEAN DEFAULT FALSE
                  ) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmc');
--
   BEGIN
      INSERT INTO nm_mrg_output_cols
             (nmc_nmf_id
             ,nmc_seq_no
             ,nmc_length
             ,nmc_column_name
             ,nmc_sec_or_val
             ,nmc_data_type
             ,nmc_pad
             ,nmc_dec_places
             ,nmc_disp_dp
             ,nmc_description
             ,nmc_view_col_name
             ,nmc_order_by
             ,nmc_order_by_ord
             ,nmc_display_sign
             )
      VALUES (p_rec_nmc.nmc_nmf_id
             ,p_rec_nmc.nmc_seq_no
             ,p_rec_nmc.nmc_length
             ,p_rec_nmc.nmc_column_name
             ,p_rec_nmc.nmc_sec_or_val
             ,p_rec_nmc.nmc_data_type
             ,p_rec_nmc.nmc_pad
             ,p_rec_nmc.nmc_dec_places
             ,p_rec_nmc.nmc_disp_dp
             ,p_rec_nmc.nmc_description
             ,p_rec_nmc.nmc_view_col_name
             ,p_rec_nmc.nmc_order_by
             ,p_rec_nmc.nmc_order_by_ord
             ,NVL(p_rec_nmc.nmc_display_sign,'N')
             );
   EXCEPTION
      WHEN dup_val_on_index
       THEN
         IF NOT p_supress_dupval
          THEN
            RAISE;
         END IF;
   END;
--
   nm_debug.proc_end(g_package_name,'ins_nmc');
--
END ins_nmc;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_nmcd (p_rec_nmcd nm_mrg_output_col_decode%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_nmcd');
--
   INSERT INTO nm_mrg_output_col_decode
          (nmcd_nmf_id
          ,nmcd_nmc_seq_no
          ,nmcd_from_value
          ,nmcd_to_value
          )
   VALUES (p_rec_nmcd.nmcd_nmf_id
          ,p_rec_nmcd.nmcd_nmc_seq_no
          ,p_rec_nmcd.nmcd_from_value
          ,p_rec_nmcd.nmcd_to_value
          );
--
   nm_debug.proc_end(g_package_name,'ins_nmcd');
--
END ins_nmcd;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_nmf_id RETURN NUMBER IS
--
   CURSOR cs_next IS
   SELECT nmf_id_seq.NEXTVAL
    FROM  dual;
--
   l_retval NUMBER;
--
BEGIN
--
   OPEN  cs_next;
   FETCH cs_next INTO l_retval;
   CLOSE cs_next;
--
   RETURN l_retval;
--
END get_next_nmf_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nm_seq_no (p_nm_ne_id_in IN nm_members.nm_ne_id_in%TYPE
                       ,p_nm_ne_id_of IN nm_members.nm_ne_id_of%TYPE
                       ,p_mp          IN nm_members.nm_begin_mp%TYPE
                       ) RETURN nm_members.nm_seq_no%TYPE IS
--
   CURSOR cs_nm (c_in nm_members.nm_ne_id_in%TYPE
                ,c_of nm_members.nm_ne_id_of%TYPE
                ,c_mp nm_members.nm_begin_mp%TYPE
                ) IS
   SELECT nm_seq_no
    FROM  nm_members
   WHERE  nm_ne_id_in = c_in
    AND   nm_ne_id_of = c_of
    AND   c_mp BETWEEN nm_begin_mp AND NVL(nm_end_mp,c_mp);
--
   l_retval nm_members.nm_seq_no%TYPE := 0;
--
BEGIN
--
   OPEN  cs_nm (p_nm_ne_id_in,p_nm_ne_id_of,p_mp);
   FETCH cs_nm INTO l_retval;
   CLOSE cs_nm;
--
   RETURN l_retval;
--
END get_nm_seq_no;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nm_seg_no (p_nm_ne_id_in IN nm_members.nm_ne_id_in%TYPE
                       ,p_nm_ne_id_of IN nm_members.nm_ne_id_of%TYPE
                       ,p_mp          IN nm_members.nm_begin_mp%TYPE
                       ) RETURN nm_members.nm_seg_no%TYPE IS
--
   CURSOR cs_nm (c_in nm_members.nm_ne_id_in%TYPE
                ,c_of nm_members.nm_ne_id_of%TYPE
                ,c_mp nm_members.nm_begin_mp%TYPE
                ) IS
   SELECT nm_seg_no
    FROM  nm_members
   WHERE  nm_ne_id_in = c_in
    AND   nm_ne_id_of = c_of
    AND   c_mp BETWEEN nm_begin_mp AND NVL(nm_end_mp,c_mp);
--
   l_retval nm_members.nm_seg_no%TYPE := 0;
--
BEGIN
--
   OPEN  cs_nm (p_nm_ne_id_in,p_nm_ne_id_of,p_mp);
   FETCH cs_nm INTO l_retval;
   CLOSE cs_nm;
--
   RETURN l_retval;
--
END get_nm_seg_no;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_all_procedures IS
BEGIN
   FOR cs_rec IN (SELECT nmf_id FROM nm_mrg_output_file)
    LOOP
       create_procedure (p_nmf_id => cs_rec.nmf_id);
   END LOOP;
END create_all_procedures;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_procedure (p_nmf_id nm_mrg_output_file.nmf_id%TYPE) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   c_proc_name  CONSTANT VARCHAR2(30) := get_proc_name (p_nmf_id);
   c_view_name  CONSTANT VARCHAR2(30) := get_view_name (p_nmf_id);
   c_table_name CONSTANT VARCHAR2(30) := get_table_name(p_nmf_id);
   l_view_name           VARCHAR2(30);
--
   l_tab_rec_nmc tab_rec_nmc;
   l_nvl_char  VARCHAR2(1);
--
   l_column_name VARCHAR2(4000);
--
   l_pad       VARCHAR2(4);
--
   l_line      nm3type.max_varchar2;
--
   l_rec_nmc     nm_mrg_output_cols%ROWTYPE;
--
   l_where_start VARCHAR2(5);
--
   all_done EXCEPTION;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_procedure '||p_nmf_id);
--
   DECLARE
      l_not_found EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_not_found,-20881);
   BEGIN
      g_rec_nmf   := get_nmf(p_nmf_id);
   EXCEPTION
      WHEN l_not_found
       THEN
         --
         -- If we've called this for one that doesnt exist, then
         --  we may be being called because it has been deleted
         -- Therefore have a go to see if we can find any objects to delete
         --
         drop_nmf_objects (p_nmf_id);
         RAISE all_done;
   END;
--
   l_view_name := nm3mrg_view.get_mrg_view_name_by_qry_id(g_rec_nmf.nmf_nmq_id);
--
   FOR cs_rec IN cs_nmc(p_nmf_id)
    LOOP
      l_tab_rec_nmc(l_tab_rec_nmc.COUNT+1) := cs_rec;
   END LOOP;
--
   nm3ddl.delete_tab_varchar;
   nm3ddl.append_tab_varchar('CREATE OR REPLACE VIEW '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_view_name||' AS',FALSE);
--
   --SSCANLON FIX LOG 706744 19MAR2007
   --Field nqr_mrg_job_id needs to be aliased as nms_mrg_job_id so that the fields in the generated view
   --correspond with the code which will facilitate the merge.
   nm3ddl.append_tab_varchar('SELECT nqr_mrg_job_id nms_mrg_job_id');
   --/SSCANLON FIX LOG 706744 19MAR2007
--
   FOR i IN 1..l_tab_rec_nmc.COUNT
    LOOP
      --
      l_rec_nmc := l_tab_rec_nmc(i);
      --
      l_column_name := Null;
      l_line        := Null;
      --
      l_tab_from_value.DELETE;
      l_tab_to_value.DELETE;
      --
      OPEN  cs_decodes (p_nmf_id, l_rec_nmc.nmc_seq_no);
      FETCH cs_decodes BULK COLLECT INTO l_tab_from_value,l_tab_to_value;
      CLOSE cs_decodes;
      --
      IF l_tab_from_value.COUNT = 0
       THEN
         -- There is no decoding, bang out as is
         l_column_name := l_rec_nmc.nmc_column_name;
      ELSE
         -- There is a decode, build up the string
         l_column_name := 'DECODE('||l_rec_nmc.nmc_column_name;
         FOR i IN 1..l_tab_from_value.COUNT
          LOOP
            l_column_name := l_column_name||','||nm3flx.string(l_tab_from_value(i))||','||nm3flx.string(l_tab_to_value(i));
         END LOOP;
         l_column_name := l_column_name||','||l_rec_nmc.nmc_column_name||')';
      END IF;
--
      IF    l_rec_nmc.nmc_data_type = nm3type.c_date
       THEN
         IF l_rec_nmc.nmc_pad = 'Y'
          THEN
            l_line := 'LPAD(';
         END IF;
         l_line    := l_line||'NVL(TO_CHAR('||l_column_name||','||nm3flx.string(g_rec_nmf.nmf_date_format)||'),'||nm3flx.string(g_rec_nmf.nmf_number_lpad)||')';
         IF l_rec_nmc.nmc_pad = 'Y'
          THEN
            l_line := l_line||','||l_rec_nmc.nmc_length||','||nm3flx.string(g_rec_nmf.nmf_number_lpad)||')';
         END IF;
      ELSIF l_rec_nmc.nmc_data_type = nm3type.c_varchar
       THEN
         IF l_rec_nmc.nmc_pad = 'Y'
          THEN
            l_line := 'RPAD(';
         END IF;
         l_line    := l_line||'NVL('||l_column_name||','||nm3flx.string(g_rec_nmf.nmf_varchar_rpad)||')';
         IF l_rec_nmc.nmc_pad = 'Y'
          THEN
            l_line := l_line||','||l_rec_nmc.nmc_length||','||nm3flx.string(g_rec_nmf.nmf_varchar_rpad)||')';
         END IF;
      ELSIF l_rec_nmc.nmc_data_type = nm3type.c_number
       THEN
         DECLARE
            l_format VARCHAR2(100);
         BEGIN
            IF l_rec_nmc.nmc_dec_places != 0
             THEN
               l_format := RPAD(g_rec_nmf.nmf_number_lpad,l_rec_nmc.nmc_dec_places,g_rec_nmf.nmf_number_lpad);
            END IF;
            IF l_rec_nmc.nmc_disp_dp = 'Y'
             THEN
               l_format := '.'||l_format;
            -- Log 698292 Commented multiplication of decimal value
            --ELSIF l_rec_nmc.nmc_dec_places != 0
            -- THEN
            --   l_column_name := 'TRUNC('||l_column_name||'*'||l_rec_nmc.nmc_dec_places||')';
            END IF;
            l_format := LPAD(NVL(l_format,g_rec_nmf.nmf_number_lpad),l_rec_nmc.nmc_length,g_rec_nmf.nmf_number_lpad);
            IF l_rec_nmc.nmc_display_sign = 'Y'
             THEN
               l_format := 'S'||SUBSTR(l_format,2);
            END IF;
            l_line := 'TO_CHAR(NVL('||l_column_name||','||g_rec_nmf.nmf_number_lpad||'),'||nm3flx.string(l_format)||')';
            IF l_rec_nmc.nmc_display_sign = 'N'
             THEN
               l_line := 'SUBSTR('||l_line||',2)';
            END IF;
         END;
      END IF;
--
      get_column_name (l_rec_nmc.nmc_view_col_name,l_rec_nmc.nmc_seq_no);
--
      l_line := '     ,'||l_line||' '||l_rec_nmc.nmc_view_col_name;
      nm3ddl.append_tab_varchar(l_line);
--
      l_tab_rec_nmc(i) := l_rec_nmc;
--
   END LOOP;
--
   IF g_rec_nmf.nmf_datum = 'Y'
    THEN
      nm3ddl.append_tab_varchar(' FROM '||l_view_name);
      l_where_start := 'WHERE';
   ELSE
      nm3ddl.append_tab_varchar(' FROM '||l_view_name||'_SEC sec');
      nm3ddl.append_tab_varchar('     ,'||l_view_name||'_VAL val');
      nm3ddl.append_tab_varchar('WHERE sec.nqr_mrg_job_id     = val.nms_mrg_job_id');
      nm3ddl.append_tab_varchar(' AND  sec.nms_mrg_section_id = val.nms_mrg_section_id');
      l_where_start := ' AND ';
   END IF;
--
   IF g_rec_nmf.nmf_additional_where IS NOT NULL
    THEN
      nm3ddl.append_tab_varchar(l_where_start||' '||g_rec_nmf.nmf_additional_where);
   END IF;
--
   nm3ddl.create_object_and_syns (c_view_name);
   nm3ddl.delete_tab_varchar;
--
   DECLARE
      l_no_table EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_no_table,-00942);
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_table_name;
   EXCEPTION
      WHEN l_no_table THEN NULL;
   END;
--
   nm3ddl.delete_tab_varchar;
   nm3ddl.append_tab_varchar('CREATE GLOBAL TEMPORARY TABLE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_table_name||' AS',FALSE);
   nm3ddl.append_tab_varchar('SELECT *');
   nm3ddl.append_tab_varchar(' FROM  '||c_view_name);
   nm3ddl.append_tab_varchar('WHERE  1 = 2');
   nm3ddl.create_object_and_syns (c_table_name);
   nm3ddl.delete_tab_varchar;
--
   IF g_rec_nmf.nmf_description IS NOT NULL
    THEN
      DECLARE
         PROCEDURE do_comment (p_obj_name VARCHAR2) IS
            l_string  nm3type.max_varchar2;
            l_comment nm3type.max_varchar2;
         BEGIN
            l_comment := nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(g_rec_nmf.nmf_description));
            l_comment := SUBSTR(l_comment,1,INSTR(l_comment,CHR(39),2,1));
            l_string  := 'COMMENT ON TABLE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||p_obj_name||' IS '||l_comment;
            EXECUTE IMMEDIATE l_string;
         EXCEPTION
            WHEN OTHERS THEN NULL;
         END do_comment;
      BEGIN
         do_comment (c_view_name);
         do_comment (c_table_name);
      END;
   END IF;
   FOR i IN 1..l_tab_rec_nmc.COUNT
    LOOP
      l_rec_nmc := l_tab_rec_nmc(i);
      IF l_rec_nmc.nmc_description IS NOT NULL
       THEN
         DECLARE
            PROCEDURE do_comment (p_obj_name VARCHAR2) IS
               l_string  nm3type.max_varchar2;
               l_comment nm3type.max_varchar2;
            BEGIN
               l_comment := nm3flx.string(nm3flx.repl_quotes_amps_for_dyn_sql(l_rec_nmc.nmc_description));
               l_comment := SUBSTR(l_comment,1,INSTR(l_comment,CHR(39),2,1));
               l_string := 'COMMENT ON COLUMN '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||p_obj_name||'.'||l_rec_nmc.nmc_view_col_name||' IS '||l_comment;
               EXECUTE IMMEDIATE l_string;
            EXCEPTION
               WHEN OTHERS THEN NULL;
            END do_comment;
         BEGIN
            do_comment (c_view_name);
            do_comment (c_table_name);
         END;
      END IF;
   END LOOP;
--
   nm3ddl.delete_tab_varchar;
   nm3ddl.append_tab_varchar('CREATE OR REPLACE PROCEDURE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_proc_name||' AS',FALSE);
   nm3ddl.append_tab_varchar('   l_line_txt   nm3type.max_varchar2;');
   nm3ddl.append_tab_varchar('   l_line_html  nm3type.max_varchar2;');
   nm3ddl.append_tab_varchar('   l_line_csv   nm3type.max_varchar2;');
   nm3ddl.append_tab_varchar('   l_count      PLS_INTEGER := 0;');
   nm3ddl.append_tab_varchar('   l_count_html PLS_INTEGER := 0;');
   nm3ddl.append_tab_varchar('   l_sep        VARCHAR2(1);');
   nm3ddl.append_tab_varchar('   l_enc        VARCHAR2(1) := '||nm3flx.string('"')||';');
   nm3ddl.append_tab_varchar('   FUNCTION sys_date RETURN VARCHAR2 IS');
   nm3ddl.append_tab_varchar('   BEGIN');
   nm3ddl.append_tab_varchar('     RETURN TO_CHAR(sysdate,'||nm3flx.string('DD-MON-YYYY HH24:MI:SS')||');');
   nm3ddl.append_tab_varchar('   END sys_date;');
   nm3ddl.append_tab_varchar('BEGIN');
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('   '||g_package_name||'.g_tab_data_csv.DELETE;');
   nm3ddl.append_tab_varchar('   '||g_package_name||'.g_tab_data_html.DELETE;');
   nm3ddl.append_tab_varchar('   '||g_package_name||'.g_tab_data_txt.DELETE;');
   nm3ddl.append_tab_varchar('   l_line_html := '||nm3flx.string('<TABLE BORDER 1><!-- ')||'||sys_date||'||nm3flx.string('-->')||';');
   nm3ddl.append_tab_varchar('   '||g_package_name||'.g_tab_data_html(0) := l_line_html;');
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('   l_sep        := Null;');
   FOR i IN 1..l_tab_rec_nmc.COUNT
    LOOP
      --
      l_rec_nmc := l_tab_rec_nmc(i);
      --
      nm3ddl.append_tab_varchar('   l_count_html:= l_count_html + 1;');
      DECLARE
         l_header VARCHAR2(2000) := INITCAP(REPLACE(l_rec_nmc.nmc_view_col_name,'_',' '));
      BEGIN
         IF l_rec_nmc.nmc_description IS NOT NULL
          THEN
            l_header := nm3flx.repl_quotes_amps_for_dyn_sql(l_rec_nmc.nmc_description);
         END IF;
         nm3ddl.append_tab_varchar('   l_line_html := '||nm3flx.string('<TH>')||'||'||nm3flx.string(l_header)||'||'||nm3flx.string('</TH>')||';');
         IF g_rec_nmf.nmf_include_header = 'Y'
          THEN
            nm3ddl.append_tab_varchar('   l_line_csv  := l_line_csv||l_sep||l_enc||'||nm3flx.string(l_rec_nmc.nmc_view_col_name)||'||l_enc;');
            IF i = 1
             THEN
               nm3ddl.append_tab_varchar('   l_sep       := '||nm3flx.string(NVL(g_rec_nmf.nmf_sep_char,','))||';');
            END IF;
         END IF;
      END;
      nm3ddl.append_tab_varchar('   '||g_package_name||'.g_tab_data_csv(0)             := l_line_csv;');
      nm3ddl.append_tab_varchar('   '||g_package_name||'.g_tab_data_html(l_count_html) := l_line_html;');
   END LOOP;
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('   FOR cs_rec IN (SELECT *');
   nm3ddl.append_tab_varchar('                   FROM  '||c_table_name);
   DECLARE
      CURSOR cs_order_by (c_nmf_id nm_mrg_output_cols.nmc_nmf_id%TYPE) IS
      SELECT nmc_view_col_name
            ,nmc_order_by_ord
            ,nmc_seq_no
       FROM  nm_mrg_output_cols
      WHERE  nmc_nmf_id = c_nmf_id
        AND  nmc_order_by IS NOT NULL
      ORDER BY nmc_order_by, nmc_seq_no;
      l_start VARCHAR2(10) := 'ORDER BY ';
   BEGIN
      FOR cs_rec IN cs_order_by (p_nmf_id)
       LOOP
         nm3ddl.append_tab_varchar('                  '||l_start||get_column_name(cs_rec.nmc_view_col_name,cs_rec.nmc_seq_no)||' '||cs_rec.nmc_order_by_ord);
         l_start := '        ,';
      END LOOP;
   END;
   nm3ddl.append_tab_varchar('                 )');
   nm3ddl.append_tab_varchar('    LOOP');
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('      l_line_txt   := Null;');
   nm3ddl.append_tab_varchar('      l_line_csv   := Null;');
   nm3ddl.append_tab_varchar('      l_line_html  := '||nm3flx.string('<TR>')||';');
   nm3ddl.append_tab_varchar('      l_sep        := Null;');
   nm3ddl.append_tab_varchar('      l_count      := l_count + 1;');
   nm3ddl.append_tab_varchar('      l_count_html := l_count_html + 1;');
   nm3ddl.append_tab_varchar('--');
   FOR i IN 1..l_tab_rec_nmc.COUNT
    LOOP
      --
      l_rec_nmc := l_tab_rec_nmc(i);
      --
      nm3ddl.append_tab_varchar('      l_line_csv  := l_line_csv||l_sep||l_enc||cs_rec.'||l_rec_nmc.nmc_view_col_name||'||l_enc;');
      IF i = 1
       THEN
         nm3ddl.append_tab_varchar('      l_sep       := '||nm3flx.string(NVL(g_rec_nmf.nmf_sep_char,','))||';');
      END IF;
      nm3ddl.append_tab_varchar('      l_line_txt  := l_line_txt||cs_rec.'||l_rec_nmc.nmc_view_col_name||';');
      nm3ddl.append_tab_varchar('      l_line_html := l_line_html||'||nm3flx.string('<TD>')||'||REPLACE(cs_rec.'||l_rec_nmc.nmc_view_col_name||','||nm3flx.string(' ')||',nm3web.c_nbsp)||'||nm3flx.string('</TD>')||';');
   END LOOP;
   nm3ddl.append_tab_varchar('      l_line_html := l_line_html||'||nm3flx.string('</TR>')||';');
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('      '||g_package_name||'.g_tab_data_txt(l_count)       := l_line_txt;');
   nm3ddl.append_tab_varchar('      '||g_package_name||'.g_tab_data_csv(l_count)       := l_line_csv;');
   nm3ddl.append_tab_varchar('      '||g_package_name||'.g_tab_data_html(l_count_html) := l_line_html;');
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('   END LOOP;');
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('   l_line_html := '||nm3flx.string('</TABLE><!-- ')||'||sys_date||'||nm3flx.string('-->')||';');
   nm3ddl.append_tab_varchar('   '||g_package_name||'.g_tab_data_html(l_count_html+1) := l_line_html;');
   nm3ddl.append_tab_varchar('--');
   nm3ddl.append_tab_varchar('END '||c_proc_name||';');
--   nm_debug.debug_on;
--   nm_debug.set_level(3);
--   nm_debug.debug(nm3ddl.g_tab_varchar(1));
--   IF nm3ddl.g_tab_varchar.EXISTS(2)
--    THEN
--      nm_debug.debug(nm3ddl.g_tab_varchar(2));
--   END IF;
--   nm_debug.debug_off;
   nm3ddl.create_object_and_syns (c_proc_name);
   nm3ddl.delete_tab_varchar;
--
   nm_debug.proc_end (g_package_name,'create_procedure');
--
EXCEPTION
--
   WHEN all_done
    THEN
      Null;
--
END create_procedure;
--
-----------------------------------------------------------------------------
--
FUNCTION get_column_name (p_col_name VARCHAR2, p_seq_no NUMBER) RETURN VARCHAR2 IS
   l_col_name VARCHAR2(30) := p_col_name;
BEGIN
   get_column_name (l_col_name, p_seq_no);
   RETURN l_col_name;
END get_column_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_column_name (p_col_name IN OUT VARCHAR2, p_seq_no NUMBER) IS
BEGIN
   p_col_name := NVL(p_col_name,'col_'||p_seq_no);
END get_column_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_proc_name (p_nmf_id nm_mrg_output_file.nmf_id%TYPE
                       ) RETURN VARCHAR2 IS
BEGIN
   RETURN 'NM_MRG_OUTPUT_'||p_nmf_id;
END get_proc_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_view_name (p_nmf_id nm_mrg_output_file.nmf_id%TYPE
                       ) RETURN VARCHAR2 IS
BEGIN
   RETURN 'MRG_OUTPUT_'||p_nmf_id||'_V';
END get_view_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_table_name(p_nmf_id nm_mrg_output_file.nmf_id%TYPE
                       ) RETURN VARCHAR2 IS
BEGIN
   RETURN 'MRG_OUTPUT_'||p_nmf_id||'_T';
END get_table_name;
--
-----------------------------------------------------------------------------
--
PROCEDURE move_data_to_arrays (p_nqr_id nm_mrg_query_results.nqr_mrg_job_id%TYPE
                              ,p_nmf_id nm_mrg_output_file.nmf_id%TYPE
                              ,p_prefix VARCHAR2 DEFAULT NULL
                              ) IS
--
   c_proc_name  CONSTANT VARCHAR2(30) := get_proc_name (p_nmf_id);
   c_view_name  CONSTANT VARCHAR2(30) := get_view_name (p_nmf_id);
   c_table_name CONSTANT VARCHAR2(30) := get_table_name(p_nmf_id);
--
   l_sql        VARCHAR2(4000);
   l_row_count  BINARY_INTEGER;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'move_data_to_arrays');
--
   g_rec_nmf := get_nmf(p_nmf_id);
--
   g_rec_nqr := nm3mrg.select_nqr(p_nqr_id);
--
   IF g_rec_nqr.nqr_nmq_id IS NULL
    THEN
      g_mrg_output_exc_code := -20882;
      g_mrg_output_exc_msg  := 'Query results and query file are for different merge queries:'||g_rec_nmf.nmf_nmq_id||'!='||g_rec_nqr.nqr_nmq_id;
      RAISE g_mrg_output_exception;
   END IF;
--
   IF NVL(g_rec_nmf.nmf_nmq_id,-1) != NVL(g_rec_nqr.nqr_nmq_id,-2)
    THEN
      g_mrg_output_exc_code := -20886;
      g_mrg_output_exc_msg  := 'Query results not found :'||p_nqr_id;
      RAISE g_mrg_output_exception;
   END IF;
--
   IF  NOT nm3ddl.does_object_exist (c_table_name,'TABLE')
    OR NOT nm3ddl.does_object_exist (c_view_name,'VIEW')
    OR NOT nm3ddl.does_object_exist (c_proc_name,'PROCEDURE')
    THEN
      -- If the objects dont exist then create them
      create_procedure (p_nmf_id => p_nmf_id);
   END IF;
   --
   -- Remove rows from the temporary table
   --
   l_sql := 'DELETE FROM '||c_table_name;
   EXECUTE IMMEDIATE l_sql;
--
-- Create a copy of the view for the correct result set
--  in the temp table. This is necessary because of a spurious
--  oracle internal error when i try to reference the view in a
--  procedure
--
   l_sql :=          'INSERT INTO '||c_table_name
          ||CHR(10)||'SELECT /*+ RULE */ *'
          ||CHR(10)||' FROM  '||c_view_name
          ||CHR(10)||'WHERE  nms_mrg_job_id = :nqr_id';
--
   EXECUTE IMMEDIATE l_sql USING p_nqr_id;
   --
   -- Execute the procedure
   --
   l_sql := 'BEGIN '||c_proc_name||'; END;';
   EXECUTE IMMEDIATE l_sql;
--
   l_row_count := g_tab_data_txt.COUNT;
--
   IF g_rec_nmf.nmf_include_header = 'Y'
    THEN
      g_tab_data_txt(0) := '000'||p_prefix||g_rec_nmf.nmf_filename||to_char(g_rec_nqr.nqr_date_created,'YYYYMMDDHH24MI');
   END IF;
--
   IF g_rec_nmf.nmf_include_footer = 'Y'
    THEN
      g_tab_data_txt(g_tab_data_txt.LAST+1) := '999'||LTRIM(TO_CHAR(l_row_count,'000000000'),' ');
   END IF;
--
   nm_debug.proc_end(g_package_name,'move_data_to_arrays');
--
END move_data_to_arrays;
--
-----------------------------------------------------------------------------
--
FUNCTION get_filepath (p_nmf_id     nm_mrg_output_file.nmf_id%TYPE
                      ,p_nqr_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE
                      ) RETURN VARCHAR2 IS
   l_file_path     nm3type.max_varchar2;
   l_dir_sep       hig_option_values.hov_value%TYPE;
   l_rec_nmf       nm_mrg_output_file%ROWTYPE;
   l_rec_nqr       nm_mrg_query_results%ROWTYPE;
BEGIN
   l_rec_nmf       := get_nmf(p_nmf_id);
   l_rec_nqr       := nm3mrg.select_nqr(p_nqr_job_id);
   l_file_path     := l_rec_nmf.nmf_file_path;
   IF l_rec_nmf.nmf_append_merge_au_to_path = 'Y'
    THEN
      l_dir_sep   := NVL(hig.get_sysopt('DIRREPSTRN'),'\'); --'
      l_file_path := l_file_path||l_dir_sep||nm3get.get_nau(pi_nau_admin_unit=>l_rec_nqr.nqr_admin_unit).nau_unit_code;
   END IF;
   RETURN l_file_path;
END get_filepath;
--
-----------------------------------------------------------------------------
--
FUNCTION get_server_filename (p_nmf_id         nm_mrg_output_file.nmf_id%TYPE
                             ,p_prefix         VARCHAR2 DEFAULT NULL
                             ,p_file_extension VARCHAR2
                             ) RETURN VARCHAR2 IS
   l_filename  nm3type.max_varchar2;
   l_extension VARCHAR2(30) := '.'||UPPER(p_file_extension);
BEGIN
--
   l_filename := get_nmf (p_nmf_id).nmf_filename;
   IF p_prefix IS NOT NULL
    THEN
      l_filename := p_prefix||'_'||l_filename;
   END IF;
   --
   IF   nm3flx.right(UPPER(l_filename),4) = '.TXT'
    AND l_extension                      != '.TXT'
    THEN
      l_filename := SUBSTR(l_filename,1,LENGTH(l_filename)-4);
   END IF;
   --
   IF nm3flx.right(UPPER(l_filename),LENGTH(l_extension)) != l_extension
    THEN
      l_filename := l_filename||l_extension;
   END IF;
--
   RETURN l_filename;
--
END get_server_filename;
--
-----------------------------------------------------------------------------
--
FUNCTION get_client_filename  (p_nmf_id         nm_mrg_output_file.nmf_id%TYPE
                              ,p_nqr_job_id     nm_mrg_query_results.nqr_mrg_job_id%TYPE
                              ,p_prefix         VARCHAR2 DEFAULT NULL
                              ,p_file_extension VARCHAR2
                              ) RETURN VARCHAR2 IS
   l_filename  nm3type.max_varchar2;
BEGIN
--
   l_filename := get_server_filename (p_nmf_id         => p_nmf_id
                                     ,p_prefix         => p_prefix
                                     ,p_file_extension => p_file_extension
                                     );
--
   l_filename := p_nqr_job_id||'.'||l_filename;
--
   RETURN l_filename;
--
END get_client_filename;
--
-----------------------------------------------------------------------------
--
PROCEDURE write_arrays (p_nmf_id                 nm_mrg_output_file.nmf_id%TYPE
                       ,p_prefix                 VARCHAR2 DEFAULT NULL
                       ,p_write_txt              BOOLEAN  DEFAULT TRUE
                       ,p_write_csv              BOOLEAN  DEFAULT TRUE
                       ,p_write_html             BOOLEAN  DEFAULT TRUE
                       ,p_produce_server_file    BOOLEAN  DEFAULT TRUE
                       ,p_produce_client_file    BOOLEAN  DEFAULT FALSE
                       ) IS
--
   l_file_path     nm3type.max_varchar2;
   l_data_array    nm3type.tab_varchar32767;
--
   PROCEDURE write_file (p_file_type  VARCHAR2
                        ,p_mime_type  VARCHAR2 DEFAULT NULL
                        ) IS
   l_filename      nm3type.max_varchar2;
   BEGIN
      IF p_produce_server_file
       THEN
         l_filename := get_server_filename (p_nmf_id,p_prefix,p_file_type);
         nm3file.write_file
             (location       => l_file_path
             ,filename       => l_filename
             ,max_linesize   => 32767
             ,all_lines      => l_data_array
             );
       END IF;
       IF p_produce_client_file
        THEN
          l_filename := get_client_filename (p_nmf_id,g_rec_nqr.nqr_mrg_job_id,p_prefix,p_file_type);
          IF l_data_array.COUNT = 0
           THEN
             l_data_array(1) := hig.raise_and_catch_ner (pi_appl => nm3type.c_net
                                                        ,pi_id   => 318
                                                        );
          END IF;
          nm3file.write_file_to_nuf
                            (pi_filename         => l_filename
                            ,pi_all_lines        => l_data_array
                            ,pi_mime_type        => p_mime_type
                            ,pi_append_lf        => TRUE
                            ,pi_delete_if_exists => TRUE
                            ,pi_gateway_table    => 'NM_MRG_QUERY_RESULTS'
                            ,pi_gateway_col_1    => TO_CHAR(g_rec_nqr.nqr_mrg_job_id)
                            );
       END IF;
   END write_file;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'write_arrays');
--
   g_rec_nmf       := get_nmf(p_nmf_id);
   IF p_produce_server_file
    THEN
      l_file_path  := get_filepath (p_nmf_id,g_rec_nqr.nqr_mrg_job_id);
   END IF;
--
   IF p_write_txt
    THEN
      l_data_array := g_tab_data_txt;
      write_file ('TXT');
   END IF;
--
   IF p_write_csv
    THEN
      l_data_array := g_tab_data_csv;
      write_file ('CSV');
   END IF;
--
   IF p_write_html
    THEN
      l_data_array := g_tab_data_html;
      write_file ('HTM','text/html');
   END IF;
--
   nm_debug.proc_end(g_package_name,'write_arrays');
--
END write_arrays;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_change_array IS
BEGIN
   g_tab_nmf_changed.DELETE;
END delete_change_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE add_to_change_array (p_nmf_id nm_mrg_output_file.nmf_id%TYPE) IS
BEGIN
   g_tab_nmf_changed(p_nmf_id) := p_nmf_id;
END add_to_change_array;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_procs_for_changed IS
    i PLS_INTEGER := g_tab_nmf_changed.FIRST;
BEGIN
   WHILE i IS NOT NULL
    LOOP
      create_procedure (i);
      i := g_tab_nmf_changed.NEXT(i);
   END LOOP;
END create_procs_for_changed;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_txt (p_y_or_n VARCHAR2) IS
BEGIN
   g_do_txt := (p_y_or_n='Y');
END do_txt;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_csv (p_y_or_n VARCHAR2) IS
BEGIN
   g_do_csv := (p_y_or_n='Y');
END do_csv;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_htm (p_y_or_n VARCHAR2) IS
BEGIN
   g_do_htm := (p_y_or_n='Y');
END  do_htm;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmc (p_nmc_nmf_id nm_mrg_output_cols.nmc_nmf_id%TYPE
                 ,p_nmc_seq_no nm_mrg_output_cols.nmc_seq_no%TYPE
                 ) RETURN nm_mrg_output_cols%ROWTYPE IS
--
   CURSOR cs_nmc (c_nmc_nmf_id nm_mrg_output_cols.nmc_nmf_id%TYPE
                 ,c_nmc_seq_no nm_mrg_output_cols.nmc_seq_no%TYPE
                 ) IS
   SELECT *
    FROM  nm_mrg_output_cols
   WHERE  nmc_nmf_id = c_nmc_nmf_id
    AND   nmc_seq_no = c_nmc_seq_no;
--
   l_rec_nmc nm_mrg_output_cols%ROWTYPE;
--
BEGIN
--
   OPEN  cs_nmc (c_nmc_nmf_id => p_nmc_nmf_id
                ,c_nmc_seq_no => p_nmc_seq_no
                );
   FETCH cs_nmc INTO l_rec_nmc;
   IF cs_nmc%NOTFOUND
    THEN
      CLOSE cs_nmc;
      hig.raise_ner('HIG',67,-20500,'NM_MRG_OUTPUT_COLS : '||p_nmc_nmf_id||' : '||p_nmc_seq_no);
   END IF;
   CLOSE cs_nmc;
--
   RETURN l_rec_nmc;
--
END get_nmc;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_nmf_objects (p_nmf_id nm_mrg_output_file.nmf_id%TYPE) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   c_proc_name  CONSTANT VARCHAR2(30) := get_proc_name (p_nmf_id);
   c_view_name  CONSTANT VARCHAR2(30) := get_view_name (p_nmf_id);
   c_table_name CONSTANT VARCHAR2(30) := get_table_name(p_nmf_id);
--
   PROCEDURE local_drop (p_obj_type VARCHAR2, p_obj_name VARCHAR2) IS
      l_not_exists EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_not_exists,-942);
      l_not_exists2 EXCEPTION;
      PRAGMA EXCEPTION_INIT(l_not_exists2,-4043);
   BEGIN
      EXECUTE IMMEDIATE 'DROP '||p_obj_type||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||p_obj_name;
      FOR cs_rec IN (SELECT *
                      FROM  all_synonyms
                     WHERE  table_owner = Sys_Context('NM3CORE','APPLICATION_OWNER')
                      AND   table_name  = p_obj_name
                    )
       LOOP
         IF cs_rec.owner = 'PUBLIC'
          THEN
            EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM '||p_obj_name;
         ELSE
            EXECUTE IMMEDIATE 'DROP SYNONYM '||cs_rec.owner||'.'||p_obj_name;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN l_not_exists OR l_not_exists2 THEN Null;
   END local_drop;
--
BEGIN
--
   local_drop('VIEW',c_view_name);
   local_drop('TABLE',c_table_name);
   local_drop('PROCEDURE',c_proc_name);
--
END drop_nmf_objects;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_nmf_objects_from_chg_arr IS
    i PLS_INTEGER := g_tab_nmf_changed.FIRST;
BEGIN
   WHILE i IS NOT NULL
    LOOP
      drop_nmf_objects (i);
      i := g_tab_nmf_changed.NEXT(i);
   END LOOP;
END drop_nmf_objects_from_chg_arr;
--
-----------------------------------------------------------------------------
--
FUNCTION query_can_use_nmf_as_template (pi_nmq_id   nm_mrg_query.nmq_id%TYPE
                                       ,pi_nmf_id   nm_mrg_output_file.nmf_id%TYPE
                                       ) RETURN BOOLEAN IS
--
   CURSOR cs_diffs (c_nmq_id          nm_mrg_query.nmq_id%TYPE
                   ,c_nmq_id_template nm_mrg_query.nmq_id%TYPE
                   ) IS
   SELECT nqt_inv_type
         ,nqt_x_sect
         ,nqa_attrib_name
    FROM  nm_mrg_query_types
         ,nm_mrg_query_attribs
   WHERE  nqt_nmq_id     = c_nmq_id_template
    AND   nqa_nmq_id     = nqt_nmq_id
    AND   nqa_nqt_seq_no = nqt_seq_no
   MINUS
   SELECT nqt_inv_type
         ,nqt_x_sect
         ,nqa_attrib_name
    FROM  nm_mrg_query_types
         ,nm_mrg_query_attribs
   WHERE  nqt_nmq_id     = c_nmq_id
    AND   nqa_nmq_id     = nqt_nmq_id
    AND   nqa_nqt_seq_no = nqt_seq_no;
--
   l_retval  BOOLEAN;
   l_rec_nmf nm_mrg_output_file%ROWTYPE;
   l_dummy   cs_diffs%ROWTYPE;
--
BEGIN
--
   l_rec_nmf := nm3get.get_nmf (pi_nmf_id => pi_nmf_id);
--
   IF NOT nm3mrg_security.is_query_executable (pi_nmq_id)
    THEN
      l_retval := FALSE;
   ELSIF l_rec_nmf.nmf_template != 'Y'
    THEN
      l_retval := FALSE;
   ELSIF l_rec_nmf.nmf_nmq_id = pi_nmq_id
    THEN
      l_retval := TRUE;
   ELSIF NOT nm3mrg_security.is_query_executable (l_rec_nmf.nmf_nmq_id)
    THEN
      l_retval := FALSE;
   ELSE
      OPEN  cs_diffs (pi_nmq_id, l_rec_nmf.nmf_nmq_id);
      FETCH cs_diffs
       INTO l_dummy;
      l_retval := cs_diffs%NOTFOUND;
      CLOSE cs_diffs;
   END IF;
--
   RETURN l_retval;
--
END query_can_use_nmf_as_template;
--
-----------------------------------------------------------------------------
--
FUNCTION query_can_use_nmf_as_temp_char (pi_nmq_id   nm_mrg_query.nmq_id%TYPE
                                        ,pi_nmf_id   nm_mrg_output_file.nmf_id%TYPE
                                        ) RETURN VARCHAR2 IS
BEGIN
   RETURN nm3flx.boolean_to_char (query_can_use_nmf_as_template
                                        (pi_nmq_id   => pi_nmq_id
                                        ,pi_nmf_id   => pi_nmf_id
                                        )
                                  );
END query_can_use_nmf_as_temp_char;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nmf_from_template (pi_nmq_id   nm_mrg_query.nmq_id%TYPE
                                   ,pi_nmf_id   nm_mrg_output_file.nmf_id%TYPE
                                   ,pi_recreate BOOLEAN DEFAULT TRUE
                                   ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_nmf_id             nm_mrg_output_file.nmf_id%TYPE;
   l_rec_nmc            nm_mrg_output_cols%ROWTYPE;
   l_tab_column_name    nm3type.tab_varchar30;
   l_tab_data_type      nm3type.tab_varchar30;
   l_tab_data_length    nm3type.tab_number;
   l_tab_data_precision nm3type.tab_number;
   l_tab_data_scale     nm3type.tab_number;
   l_length             NUMBER;
   c_view_name CONSTANT VARCHAR2(30) := SUBSTR(nm3mrg_view.get_mrg_view_name_by_qry_id (pi_nmq_id),1,26)||'_VAL';
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'create_nmf_from_template');
--
   IF NOT query_can_use_nmf_as_template (pi_nmq_id => pi_nmq_id
                                        ,pi_nmf_id => pi_nmf_id
                                        )
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 265
                    ,pi_supplementary_info => 'NMF definition is invalid for query'
                    );
   END IF;
--
   IF pi_recreate
    THEN
      nm3del.del_nmf (pi_nmf_nmq_id      => pi_nmq_id
                     ,pi_nmf_filename    => nm3get.get_nmq (pi_nmq_id => pi_nmq_id).nmq_unique
                                            ||'_'||nm3get.get_nmf (pi_nmf_id => pi_nmf_id).nmf_filename
                     ,pi_raise_not_found => FALSE
                     );
   ELSIF nm3get.get_nmf (pi_nmf_nmq_id      => pi_nmq_id
                        ,pi_nmf_filename    => nm3get.get_nmf (pi_nmf_id => pi_nmf_id).nmf_filename
                        ,pi_raise_not_found => FALSE
                        ).nmf_id IS NOT NULL
    THEN
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 64
                    );
   END IF;
--
   l_nmf_id := duplicate_nmf_template (pi_nmf_id     => pi_nmf_id
                                      ,pi_nmq_id_new => pi_nmq_id
                                      );
--
   l_rec_nmc.nmc_nmf_id             := l_nmf_id;
   SELECT MAX(nmc_seq_no)
    INTO  l_rec_nmc.nmc_seq_no
    FROM  nm_mrg_output_cols
   WHERE  nmc_nmf_id = l_nmf_id;
   l_rec_nmc.nmc_seq_no := l_rec_nmc.nmc_seq_no + nm3get.get_nmc (pi_nmc_nmf_id => l_rec_nmc.nmc_nmf_id
                                                                 ,pi_nmc_seq_no => l_rec_nmc.nmc_seq_no
                                                                 ).nmc_length;
   l_rec_nmc.nmc_length             := Null;
   l_rec_nmc.nmc_column_name        := Null;
   l_rec_nmc.nmc_sec_or_val         := 'VAL';
   l_rec_nmc.nmc_data_type          := Null;
   l_rec_nmc.nmc_pad                := Null;
   l_rec_nmc.nmc_dec_places         := Null;
   l_rec_nmc.nmc_disp_dp            := Null;
   l_rec_nmc.nmc_description        := Null;
   l_rec_nmc.nmc_view_col_name      := Null;
   l_rec_nmc.nmc_order_by           := Null;
   l_rec_nmc.nmc_order_by_ord       := Null;
   l_rec_nmc.nmc_display_sign       := Null;
--
   SELECT column_name
         ,data_type
         ,data_length
         ,data_precision
         ,data_scale
    BULK  COLLECT
    INTO  l_tab_column_name
         ,l_tab_data_type
         ,l_tab_data_length
         ,l_tab_data_precision
         ,l_tab_data_scale
    FROM  all_tab_columns
   WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name = c_view_name
    AND   column_name NOT IN ('NMS_MRG_JOB_ID','NQR_MRG_JOB_ID','NMS_MRG_SECTION_ID')
    AND   NOT EXISTS (SELECT 1
                       FROM  nm_mrg_output_cols
                      WHERE  nmc_nmf_id      = l_nmf_id
                       AND   nmc_column_name = column_name
                     )
   ORDER BY column_id;
--
   FOR i IN 1..l_tab_column_name.COUNT
    LOOP
      --
      l_rec_nmc.nmc_dec_places       := Null;
      l_rec_nmc.nmc_disp_dp          := Null;
      l_rec_nmc.nmc_length           := Null;
      l_rec_nmc.nmc_column_name      := l_tab_column_name(i);
      l_rec_nmc.nmc_data_type        := l_tab_data_type(i);
      l_rec_nmc.nmc_pad              := 'Y';
      l_rec_nmc.nmc_description      := Null;
      l_rec_nmc.nmc_view_col_name    := l_tab_column_name(i);
      l_rec_nmc.nmc_order_by         := Null;
      l_rec_nmc.nmc_order_by_ord     := Null;
      l_rec_nmc.nmc_display_sign     := 'N';
      IF l_tab_data_type(i) = nm3type.c_varchar
       THEN
         l_rec_nmc.nmc_length := l_tab_data_length(i);
      ELSIF  l_tab_data_type(i) = nm3type.c_date
       THEN
         l_rec_nmc.nmc_length := 30;
      ELSE
         IF l_tab_data_precision(i) IS NULL
          THEN
            l_rec_nmc.nmc_length     := 38;
            l_rec_nmc.nmc_dec_places := 0;
            l_rec_nmc.nmc_disp_dp    := 'N';
         ELSIF NVL(l_tab_data_scale(i),0) != 0
          THEN
            l_rec_nmc.nmc_dec_places := l_tab_data_scale(i);
            l_rec_nmc.nmc_disp_dp    := 'Y';
            l_rec_nmc.nmc_length     := l_tab_data_precision(i)+1;
         ELSE
            l_rec_nmc.nmc_length     := l_tab_data_precision(i);
            l_rec_nmc.nmc_dec_places := 0;
            l_rec_nmc.nmc_disp_dp    := 'N';
         END IF;
      END IF;
      --
      nm3ins.ins_nmc (l_rec_nmc);
      --
      l_rec_nmc.nmc_seq_no           := l_rec_nmc.nmc_seq_no + l_rec_nmc.nmc_length;
      --
   END LOOP;
--
   COMMIT;
--
   nm3mrg_output.create_procedure (p_nmf_id => l_nmf_id);
--
   nm_debug.proc_end(g_package_name,'create_nmf_from_template');
--
END create_nmf_from_template;
--
-----------------------------------------------------------------------------
--
FUNCTION duplicate_nmf_template (pi_nmf_id     nm_mrg_output_file.nmf_id%TYPE
                                ,pi_nmq_id_new nm_mrg_query.nmq_id%TYPE
                                ) RETURN nm_mrg_output_file.nmf_id%TYPE IS
   l_nmf_id nm_mrg_output_file.nmf_id%TYPE;
BEGIN
--
   l_nmf_id := duplicate_nmf (pi_nmf_id,pi_nmq_id_new);
--
   UPDATE nm_mrg_output_file
    SET   nmf_template = 'N'
   WHERE  nmf_id       = l_nmf_id;
--
   RETURN l_nmf_id;
--
END duplicate_nmf_template;
--
-----------------------------------------------------------------------------
--
FUNCTION duplicate_nmf (pi_nmf_id     nm_mrg_output_file.nmf_id%TYPE
                       ,pi_nmq_id_new nm_mrg_query.nmq_id%TYPE
                       ) RETURN nm_mrg_output_file.nmf_id%TYPE IS
--
   l_rec_nmf nm_mrg_output_file%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'duplicate_nmf');
--
   l_rec_nmf              := nm3get.get_nmf (pi_nmf_id => pi_nmf_id);
   l_rec_nmf.nmf_id       := nm3seq.next_nmf_id_seq;
   l_rec_nmf.nmf_filename := nm3get.get_nmq (pi_nmq_id => pi_nmq_id_new).nmq_unique||'_'||l_rec_nmf.nmf_filename;
   l_rec_nmf.nmf_nmq_id   := pi_nmq_id_new;
   ins_nmf (l_rec_nmf);
   --
   INSERT INTO nm_mrg_output_cols
         (nmc_nmf_id
         ,nmc_seq_no
         ,nmc_length
         ,nmc_column_name
         ,nmc_sec_or_val
         ,nmc_data_type
         ,nmc_pad
         ,nmc_dec_places
         ,nmc_disp_dp
         ,nmc_description
         ,nmc_view_col_name
         ,nmc_order_by
         ,nmc_order_by_ord
         ,nmc_display_sign
         )
   SELECT l_rec_nmf.nmf_id
         ,nmc_seq_no
         ,nmc_length
         ,nmc_column_name
         ,nmc_sec_or_val
         ,nmc_data_type
         ,nmc_pad
         ,nmc_dec_places
         ,nmc_disp_dp
         ,nmc_description
         ,nmc_view_col_name
         ,nmc_order_by
         ,nmc_order_by_ord
         ,nmc_display_sign
    FROM  nm_mrg_output_cols
   WHERE  nmc_nmf_id = pi_nmf_id;
   --
   INSERT INTO nm_mrg_output_col_decode
         (nmcd_nmf_id
         ,nmcd_nmc_seq_no
         ,nmcd_from_value
         ,nmcd_to_value
         )
   SELECT l_rec_nmf.nmf_id
         ,nmcd_nmc_seq_no
         ,nmcd_from_value
         ,nmcd_to_value
    FROM  nm_mrg_output_col_decode
   WHERE  nmcd_nmf_id = pi_nmf_id;
--
   nm_debug.proc_end(g_package_name,'duplicate_nmf');
--
   RETURN l_rec_nmf.nmf_id;
--
END duplicate_nmf;
--
-----------------------------------------------------------------------------
--
PROCEDURE duplicate_nmf_and_procs (pi_nmf_id       nm_mrg_output_file.nmf_id%TYPE
                                  ,pi_nmq_id_new   nm_mrg_query.nmq_id%TYPE
                                  ) IS
   l_nmf_id nm_mrg_output_file.nmf_id%TYPE;
BEGIN
--
   l_nmf_id := duplicate_nmf_and_procs (pi_nmf_id
                                       ,pi_nmq_id_new
                                       );
--
END duplicate_nmf_and_procs;
--
-----------------------------------------------------------------------------
--
FUNCTION duplicate_nmf_and_procs (pi_nmf_id       nm_mrg_output_file.nmf_id%TYPE
                                 ,pi_nmq_id_new   nm_mrg_query.nmq_id%TYPE
                                 ) RETURN nm_mrg_output_file.nmf_id%TYPE IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   l_nmf_id nm_mrg_output_file.nmf_id%TYPE;
BEGIN
--
   nm_debug.proc_start(g_package_name,'duplicate_nmf_and_procs');
--
   l_nmf_id := duplicate_nmf (pi_nmf_id,pi_nmq_id_new);
--
   COMMIT; -- need to commit here as nm3mrg_output.create_procedure is
           --  an autonomous transaction so it wouldn't be able to
           --  see the record
--
   nm3mrg_output.create_procedure (p_nmf_id => l_nmf_id);
--
   nm_debug.proc_end(g_package_name,'duplicate_nmf_and_procs');
--
   COMMIT;
--
   RETURN l_nmf_id;
--
END duplicate_nmf_and_procs;
--
-----------------------------------------------------------------------------
--
FUNCTION is_there_a_template_for_query (pi_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN BOOLEAN IS
   CURSOR cs_dummy (c_nmq_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  nm_mrg_output_file
                  WHERE  nmf_template = 'Y'
                   AND   query_can_use_nmf_as_temp_char (c_nmq_id,nmf_id) = 'TRUE'
                 );
   l_found BOOLEAN;
   l_dummy PLS_INTEGER;
BEGIN
   OPEN  cs_dummy (pi_nmq_id);
   FETCH cs_dummy INTO l_dummy;
   l_found := cs_dummy%FOUND;
   CLOSE cs_dummy;
   RETURN l_found;
END is_there_a_template_for_query;
--
-----------------------------------------------------------------------------
--
FUNCTION nmf_exists_for_nmq (pi_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN BOOLEAN IS
   CURSOR cs_found (c_nmq_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT 1
    FROM  nm_mrg_output_file
   WHERE  nmf_nmq_id = c_nmq_id;
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
BEGIN
   OPEN  cs_found (pi_nmq_id);
   FETCH cs_found INTO l_dummy;
   l_found := cs_found%FOUND;
   CLOSE cs_found;
   RETURN l_found;
END nmf_exists_for_nmq;
--
-----------------------------------------------------------------------------
--
end nm3mrg_output;
/
