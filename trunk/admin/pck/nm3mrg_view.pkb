create or replace package body nm3mrg_view as
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg_view.pkb-arc   2.7   May 16 2011 14:45:02   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3mrg_view.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:45:02  $
--       Date fetched Out : $Modtime:   Apr 04 2011 09:51:06  $
--       PVCS Version     : $Revision:   2.7  $
--       Based on SCCS version     : 1.38
--
--
--   Author : Jonathan Mills
--
--   NM3 Merge View Creation Package body
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2000
-----------------------------------------------------------------------------
--

/* History
  02.03.09  PT change in build_view() rewrote the logic for _SVL
                now uses a dedicated sql instead of joining the _sec and _val
  04.06.09  PT in V_MRG_xxxxxx removed RULE hint and optimized unit conversion
  13.07.09  PT fixed missing xsp columns in _SVL by fixing t_val loading at the start of _SEC - not all xsp's per type were loaded
  22.07.09  PT modified _SVL to include begin_offset_true and end_offset_true with MRGVIEWTRU option - these are used by the main view
  04.02.10  PT in _SVL fixed the wrong xsp value counts by adding the missing nsv_x_sect criterion to the case count logic
  30.02.10  PT in _SVL corrected the mistiake in counting of null xsp values introduced by the previous fix
*/


   g_body_sccsid      CONSTANT  VARCHAR2(200) := '"$Revision:   2.7  $"';
   g_package_name     CONSTANT  VARCHAR2(30)  := 'nm3mrg_view';
   
   cr constant varchar2(1) := chr(10);
--
--all global package variables here
--
   g_rec_mrg_query   nm_mrg_query%ROWTYPE;
--
   g_view_comment    VARCHAR2(2000);
   g_include_true    BOOLEAN := hig.get_sysopt('MRGVIEWTRU') = 'Y';
--
   CURSOR cs_values_xsp (c_mrg_job_id     NUMBER
                        ,c_mrg_section_id NUMBER
                        ,c_inv_type       VARCHAR2
                        ,c_x_sect         VARCHAR2
                        ) IS
   SELECT nsv.*
    FROM  nm_mrg_section_member_inv nsi
         ,nm_mrg_section_inv_values nsv
   WHERE  nsi.nsi_mrg_job_id     = c_mrg_job_id
    AND   nsi.nsi_mrg_section_id = c_mrg_section_id
    AND   nsi.nsi_inv_type       = c_inv_type
    AND   nsi.nsi_x_sect         = c_x_sect
    AND   nsi.nsi_mrg_job_id     = nsv.nsv_mrg_job_id
    AND   nsi.nsi_value_id       = nsv.nsv_value_id;
--
   CURSOR cs_values_no_xsp (c_mrg_job_id     NUMBER
                           ,c_mrg_section_id NUMBER
                           ,c_inv_type       VARCHAR2
                           ) IS
   SELECT nsv.*
    FROM  nm_mrg_section_member_inv nsi
         ,nm_mrg_section_inv_values nsv
   WHERE  nsi.nsi_mrg_job_id     = c_mrg_job_id
    AND   nsi.nsi_mrg_section_id = c_mrg_section_id
    AND   nsi.nsi_inv_type       = c_inv_type
    AND   nsi.nsi_x_sect         IS NULL
    AND   nsi.nsi_mrg_job_id     = nsv.nsv_mrg_job_id
    AND   nsi.nsi_value_id       = nsv.nsv_value_id;
--
   g_create_snapshot CONSTANT BOOLEAN      := FALSE;
   g_object_type     VARCHAR2(100);
   
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_text     IN VARCHAR2
                 ,p_new_line IN BOOLEAN DEFAULT TRUE
                 );
--
-----------------------------------------------------------------------------
--
PROCEDURE in_view_comment;


  function sql_view_col_name(
     p_inv_type in varchar2
    ,p_xsp in varchar2
    ,p_view_attri in varchar2
  ) return varchar2;
  
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
PROCEDURE append (p_text     IN VARCHAR2
                 ,p_new_line IN BOOLEAN DEFAULT TRUE
                 ) IS
BEGIN
--
   nm3ddl.append_tab_varchar(p_text, p_new_line);
--
END append;
--
-----------------------------------------------------------------------------
--
PROCEDURE in_view_comment IS
BEGIN
   append ('-- ');
   append ('-- '||g_object_type||' generated '||to_char(sysdate,'DD-Mon-YYYY HH24:MI:SS'));
   append ('-- ');
   append ('-- Package Version Details :');
   append ('-- '||get_version);
   append ('-- '||get_body_version);
   append ('-- ');
END in_view_comment;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_view (p_mrg_query_id IN     NUMBER) IS
   l_view VARCHAR2(30);
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_view');
--
   build_view (p_mrg_query_id, l_view);
--
   nm_debug.proc_end(g_package_name,'build_view');
--
END build_view;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_view (p_mrg_query_id IN     NUMBER
                     ,p_view_name       OUT VARCHAR2
                     ) IS
--
   TYPE rec_col_comment IS RECORD
      (column_name  VARCHAR2(30)
      ,comment_text VARCHAR2(2000)
      );
   TYPE tab_rec_col_comment IS TABLE OF rec_col_comment INDEX BY BINARY_INTEGER;
   l_tab_rec_col_comment tab_rec_col_comment;
   l_rec_col_comment     rec_col_comment;
   l_val_view_name       VARCHAR2(30);
   l_all_val_view_name   VARCHAR2(30);
   l_done_a_select       BOOLEAN;
   l_datum_view_name     VARCHAR2(30);
   l_sect_view_name      VARCHAR2(30);
   l_sec_val_view_name   VARCHAR2(30);
   
   l_sql                  varchar2(32767);
   l_sql_view_cols        varchar2(32767);
   l_comma                varchar2(2);
   l_last_xsp             varchar2(20);
   
  type coldef_type is record (
     col_name       varchar2(30)
    ,nsv_name       varchar2(30)
    ,nsv_formatted  varchar2(100)
    ,inv_type       varchar2(10)
    ,xsp            nm_inv_items_all.iit_x_sect%type
  );
  type coldef_tbl is table of coldef_type index by pls_integer;
   
  t_val  coldef_tbl;
  t_sec  coldef_tbl;
  
  l_rec_xsp       nm3mrg.rec_inv_type_xsp;
  l_rec_nita      nm_inv_type_attribs%rowtype;
  l_rec_attrib    nm_mrg_query_attribs%rowtype;
  l_col_sql       varchar2(1000);
  
  j               pls_integer := 0;
  l_unique_cols   varchar2(4000);
   
   
   function get_nm3mrg_inv_type(
      p_nmq_id in nm_mrg_query_types_all.nqt_nmq_id%type
     ,p_seq_no in nm_mrg_query_types_all.nqt_seq_no%type
   ) return nm_mrg_query_types_all.nqt_inv_type%type
   is
      i binary_integer;
   begin
      i := nm3mrg.g_tab_rec_query_types.first;
      while i is not null loop
        if nm3mrg.g_tab_rec_query_types(i).nqt_nmq_id = p_nmq_id
          and nm3mrg.g_tab_rec_query_types(i).nqt_seq_no = p_seq_no
        then
          return nm3mrg.g_tab_rec_query_types(i).nqt_inv_type;
        end if;
        i := nm3mrg.g_tab_rec_query_types.next(i);
      end loop;
      raise no_data_found;
  end;
  

   
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_view');
--
   g_rec_mrg_query := nm3mrg.select_mrg_query (pi_query_id => p_mrg_query_id);
--
  -- this loads the nm3mrg.g_tab_rec_inv_type_xsp table
   nm3mrg.validate_mrg_query(pi_query_id => p_mrg_query_id);
--
   p_view_name     := get_mrg_view_name_by_qry_id(p_mrg_query_id);
--
   g_view_comment  := 'View created for mrg query '||p_mrg_query_id
                      ||' ('||g_rec_mrg_query.nmq_unique||'-'
                      ||REPLACE(g_rec_mrg_query.nmq_descr,CHR(39),Null)||')';
--
   drop_merge_view(p_mrg_query_id);
--
-- ####################################################################################
--
--    Create the V_MRG_xxxxxx_SEC snapshot
--
-- ####################################################################################
--

    -- load sec and val column tables
    for i in 1 .. nm3mrg.g_tab_rec_inv_type_xsp.count loop
      l_rec_xsp           := nm3mrg.g_tab_rec_inv_type_xsp(i);

      t_sec(i).inv_type   := l_rec_xsp.inv_type;
      t_sec(i).xsp        := l_rec_xsp.x_sect;
      t_sec(i).col_name   := l_rec_xsp.inv_type;
      
      if t_sec(i).xsp is not null then
        t_sec(i).col_name := t_sec(i).col_name||'_'||t_sec(i).xsp;
      end if;
      t_sec(i).col_name := t_sec(i).col_name||'_QRY_COUNT';
      
      
      -- this loops through all attributes picking out the ones 
      --  belonging to the outer inv_type_xsp
      for k in 1 .. nm3mrg.g_tab_rec_query_attribs.count loop
        l_rec_attrib        := nm3mrg.g_tab_rec_query_attribs(k);
      
        if l_rec_attrib.nqa_nqt_seq_no = nm3mrg.g_tab_rec_query_types(l_rec_xsp.query_type_id).nqt_seq_no then
          j := j + 1;
          t_val(j).inv_type := l_rec_xsp.inv_type;
          t_val(j).xsp := l_rec_xsp.x_sect;
          l_rec_nita := nm3mrg.get_ita_for_mrg (
                          p_inv_type => l_rec_xsp.inv_type
                         ,p_attrib   => l_rec_attrib.nqa_attrib_name
                       );
          t_val(j).col_name := sql_view_col_name(
                                  p_inv_type => l_rec_xsp.inv_type
                                 ,p_xsp => l_rec_xsp.x_sect
                                 ,p_view_attri => l_rec_nita.ita_view_attri
                               );
                               
          t_val(j).nsv_name       := 'nsv_attrib'||k;
          t_val(j).nsv_formatted  := '<a>.nsv_attrib'||k;
          
          
          if l_rec_attrib.nqa_itb_banding_id is null then
          
            -- If this has a domain then it must always be VARCHAR2 based
            --  and allow enough space for "meaning (value)"
            if l_rec_nita.ita_id_domain is not null then
              t_val(j).nsv_formatted := 'substr('||t_val(j).nsv_formatted||', 1, 120)';
                     
            else
              if l_rec_nita.ita_format = nm3type.c_varchar and l_rec_nita.ita_fld_length > 0 then
                t_val(j).nsv_formatted := 'substr('||t_val(j).nsv_formatted
                  ||', 1, '||l_rec_nita.ita_fld_length||')';
                
              elsif l_rec_nita.ita_format = nm3type.c_number then
                t_val(j).nsv_formatted := 'to_number('||t_val(j).nsv_formatted||')';
                
              elsif l_rec_nita.ita_format = nm3type.c_date then
                t_val(j).nsv_formatted := 'to_date('||t_val(j).nsv_formatted
                  ||', '||nm3flx.string(nvl(l_rec_nita.ita_format_mask,nm3mrg.g_mrg_date_format))||')';
                
              end if;
              
            end if;   -- is domain
  
          end if;  -- is banding
          
        end if;  --  is current inv_type_xsp
      
      end loop;  -- attributes
      
    end loop;  -- inv_type_xsp's
    
    

   FOR l_count IN 1..nm3mrg.g_tab_rec_inv_type_xsp.COUNT
    LOOP
      DECLARE
         l_rec_xsp    nm3mrg.rec_inv_type_xsp := nm3mrg.g_tab_rec_inv_type_xsp(l_count);
         l_col_name   VARCHAR2(30);
         l_count_col  VARCHAR2(300);
      BEGIN
      
         l_count_col := 'count(case when v.nsv_inv_type = '''||l_rec_xsp.inv_type||'''';
         l_col_name := l_rec_xsp.inv_type||'_';
         --
         IF l_rec_xsp.x_sect IS NOT NULL
          THEN
            l_col_name := l_col_name||l_rec_xsp.x_sect||'_';
            l_count_col := l_count_col||' and v.nsv_x_sect = '''||l_rec_xsp.x_sect||'''';
            
         END IF;
         --l_count_col := l_col_name;
         l_count_col := l_count_col||' then 1 end) ';
         l_col_name := l_col_name||'QRY_COUNT';
               
         append('  ,'||l_count_col||' '||l_col_name);
         
--
      END;
   END LOOP;
   


   l_sect_view_name := SUBSTR(p_view_name,1,26)||'_SEC';
   nm3ddl.delete_tab_varchar;
   append('CREATE '||g_object_type||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_sect_view_name||' AS ');
   in_view_comment;

   -- PT add these wrapped here
   --   Can't add them at the original location because they will there be called
   --     for each nm_mrg_section_member_inv record
   if g_include_true then
      append ('select q.*');
      append ('  ,nm3mrg_view.get_true(nms_offset_ne_id,nms_ne_id_first,nms_begin_mp_first) begin_offset_true');
      append ('  ,nm3mrg_view.get_true(nms_offset_ne_id,nms_ne_id_last,nms_end_mp_last) end_offset_true');
      append ('from (');
   end if;
   
   append ('select');
   in_view_comment;
   append ('   r.nqr_mrg_job_id');
   append ('  ,s.nms_mrg_section_id');
   append ('  ,min(nms_offset_ne_id) nms_offset_ne_id');
   append ('  ,min(nms_begin_offset) nms_begin_offset');
   append ('  ,min(nms_end_offset) nms_end_offset');
   append ('  ,min(nqr_date_created) nqr_date_created');
   append ('  ,min(nqr_source_id) nqr_source_id');
   append ('  ,min(nqr_source) nqr_source');
   append ('  ,min(nqr_description) nqr_description');
   append ('  ,min(nqr_admin_unit) nqr_admin_unit');
   append ('  ,min(decode(nms_ne_id_first');
   append ('         ,nms_ne_id_last');
   append ('         ,decode(nms_begin_mp_first, nms_end_mp_last, ''P'', ''C'')');
   append ('         ,''C''');
   append ('         )) pnt_or_cont');
   append ('  ,min(nms_ne_id_first) nms_ne_id_first');
   append ('  ,min(nms_begin_mp_first) nms_begin_mp_first');
   append ('  ,min(nms_ne_id_last) nms_ne_id_last');
   append ('  ,min(nms_end_mp_last) nms_end_mp_last');
   
--
--   nm_debug.debug('-- Write out the columns for the "INV_EXISTS" flag',4);
--
   append ('--');
   append ('-- Columns to indicate which Inv/XSP values have data present here');
   append ('--');
--
   FOR l_count IN 1..nm3mrg.g_tab_rec_inv_type_xsp.COUNT
    LOOP
      DECLARE
         l_rec_xsp    nm3mrg.rec_inv_type_xsp := nm3mrg.g_tab_rec_inv_type_xsp(l_count);
         l_col_name   VARCHAR2(30);
         l_count_col  VARCHAR2(300);
      BEGIN
      
         l_count_col := 'count(case when v.nsv_inv_type = '''||l_rec_xsp.inv_type||'''';
         l_col_name := l_rec_xsp.inv_type||'_';
         --
         IF l_rec_xsp.x_sect IS NOT NULL
          THEN
            l_col_name := l_col_name||l_rec_xsp.x_sect||'_';
            l_count_col := l_count_col||' and v.nsv_x_sect = '''||l_rec_xsp.x_sect||'''';
            
         END IF;
         --l_count_col := l_col_name;
         l_count_col := l_count_col||' then 1 end) ';
         l_col_name := l_col_name||'QRY_COUNT';
               
         append('  ,'||l_count_col||' '||l_col_name);
         
--
      END;
   END LOOP;
   
   append ('from');
   append ('   nm_mrg_query_results_all r');
   append ('  ,nm_mrg_sections_all s');
   append ('  ,nm_mrg_section_member_inv mi');
   append ('  ,nm_mrg_section_inv_values_all v');
   append ('where r.nqr_mrg_job_id = s.nms_mrg_job_id');
   append ('  and s.nms_mrg_job_id = mi.nsi_mrg_job_id');
   append ('  and s.nms_mrg_section_id = mi.nsi_mrg_section_id');
   append ('  and mi.nsi_mrg_job_id = v.nsv_mrg_job_id');
   append ('  and mi.nsi_value_id = v.nsv_value_id');
   append ('  and r.nqr_nmq_id = '||p_mrg_query_id);
   append ('group by');
   append ('   r.nqr_mrg_job_id');
   append ('  ,s.nms_mrg_section_id');
   
   
   if g_include_true then
      append (') q');
   end if;
   
   
--
   nm3ddl.create_object_and_syns(l_sect_view_name);
--   nm_debug.debug('Sql string ^ done',3);
--
   IF g_create_snapshot
    THEN
      -- Only create indexes and constraints on snapshots
      EXECUTE IMMEDIATE 'ALTER TABLE '||l_sect_view_name
                        ||' ADD CONSTRAINT '||SUBSTR(l_sect_view_name,1,27)||'_PK PRIMARY KEY (nqr_mrg_job_id,nms_mrg_section_id)';
   --   EXECUTE IMMEDIATE 'CREATE INDEX '||p_view_name||'_IX  ON '||p_view_name||'(nqr_mrg_job_id)';
   --   EXECUTE IMMEDIATE 'CREATE INDEX '||p_view_name||'_IX2 ON '||p_view_name||'(nms_mrg_section_id)';
   END IF;
--
   EXECUTE IMMEDIATE 'COMMENT ON TABLE '||l_sect_view_name||' IS '||nm3flx.string(g_view_comment);
--
   l_val_view_name := SUBSTR(p_view_name,1,26)||'_VAL';
--
--
-- ####################################################################################
--
--    Create the V_MRG_xxxxxx_VAL snapshot
--
-- ####################################################################################
--

   
   nm3ddl.delete_tab_varchar;
   

   append ('CREATE '||g_object_type||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_val_view_name||' AS ');
   append ('select');
   
   --append ('SELECT /*+ INDEX (nm_mrg_query_results NMQR_NMQ_FK_IND) */');
   in_view_comment;
   append ('   q.nms_mrg_job_id');
   append ('  ,q.nms_mrg_section_id');
--   nm_debug.debug('--  write out the columns for the inv values',4);
--
   append ('--');
   append ('-- Columns to display the data for each INV/XSP/Attrib');
   append ('--');
--
   FOR l_count IN 1..nm3mrg.g_tab_rec_inv_type_xsp.COUNT
    LOOP
      DECLARE
         l_rec_xsp       nm3mrg.rec_inv_type_xsp := nm3mrg.g_tab_rec_inv_type_xsp(l_count);
         l_col_name      VARCHAR2(30);
         l_rec_attrib    nm_mrg_query_attribs%ROWTYPE;
         l_rec_nita      nm_inv_type_attribs%ROWTYPE;
         l_before_format VARCHAR2(30) := NULL;
         l_after_format  VARCHAR2(30) := NULL;
      BEGIN
--
         FOR l_counter IN 1..nm3mrg.g_tab_rec_query_attribs.COUNT
          LOOP
   --
            l_rec_attrib := nm3mrg.g_tab_rec_query_attribs(l_counter);
   --
            IF l_rec_attrib.nqa_nqt_seq_no = nm3mrg.g_tab_rec_query_types(l_rec_xsp.query_type_id).nqt_seq_no
             THEN

               --
               l_rec_nita := nm3mrg.get_ita_for_mrg (p_inv_type => l_rec_xsp.inv_type
                                                    ,p_attrib   => l_rec_attrib.nqa_attrib_name
                                                    );
                                                    
               l_col_name := sql_view_col_name(
                  p_inv_type => l_rec_xsp.inv_type
                 ,p_xsp => l_rec_xsp.x_sect
                 ,p_view_attri => l_rec_nita.ita_view_attri
               );
               
--
               l_before_format := Null;
               l_after_format  := Null;
--
               IF l_rec_attrib.nqa_itb_banding_id IS NULL
                THEN
                  --
                  -- If we aren't banding this attribute then format the field
                  --
                  IF l_rec_nita.ita_id_domain IS NOT NULL
                   THEN
                     --
                     -- If this has a domain then it must always be VARCHAR2 based
                     --  and allow enough space for "meaning (value)"
                     --
                     l_before_format := 'substr(';
                     l_after_format  := ', 1, 120)';
                  ELSE
                     IF    l_rec_nita.ita_format     = nm3type.c_varchar
                      AND  l_rec_nita.ita_fld_length > 0
                      THEN
                        l_before_format := 'substr(';
                        l_after_format  := ', 1, '||l_rec_nita.ita_fld_length||')';
                     ELSIF l_rec_nita.ita_format = nm3type.c_number
                      THEN
                        l_before_format := 'to_number(';
                        l_after_format  := ')';
                     ELSIF l_rec_nita.ita_format = nm3type.c_date
                      THEN
                        l_before_format := 'to_date(';
                        l_after_format  := ', '||nm3flx.string(NVL(l_rec_nita.ita_format_mask,nm3mrg.g_mrg_date_format))||')';
                     END IF;
                  END IF;
               END IF;
               
               if l_rec_xsp.x_sect is not null then
                  append('  ,min(case when q.nsv_inv_type = '''||l_rec_xsp.inv_type
                    ||''' and q.nsv_x_sect = '''||l_rec_xsp.x_sect
                    ||''' then '||l_before_format||'q.nsv_attrib'||l_counter||l_after_format||' end) '||l_col_name);
--
               else
                  append('  ,min(case when q.nsv_inv_type = '''||l_rec_xsp.inv_type
                    ||''' and q.nsv_x_sect is null'
                    ||' then '||l_before_format||'q.nsv_attrib'||l_counter||l_after_format||' end) '||l_col_name);
               
               end if;
               
--
               l_rec_col_comment.column_name  := l_col_name;
               l_rec_col_comment.comment_text := 'NSV_ATTRIB'||l_counter||' - '
                                                 ||l_rec_xsp.inv_type||' - '||l_rec_xsp.x_sect
                                                 ||' - '||l_rec_nita.ita_attrib_name||' - '
                                                 ||l_rec_nita.ita_view_col_name;
               l_tab_rec_col_comment(l_tab_rec_col_comment.COUNT+1) := l_rec_col_comment;
   --
            END IF;
   --
         END LOOP;
--
      END;
   END LOOP;
   
   
   append ('from (');
   append ('select');
   append ('   s.nms_mrg_job_id');
   append ('  ,s.nms_mrg_section_id');
   append ('  ,row_number() over (partition by s.nms_mrg_job_id, s.nms_mrg_section_id, v.nsv_x_sect, v.nsv_inv_type order by v.nsv_value_id) nsv_rownum');
   append ('  ,v.nsv_inv_type');
   append ('  ,v.nsv_x_sect');
   for i in 1..nm3mrg.g_tab_rec_query_attribs.count loop
      append ('  ,v.nsv_attrib'||i);
   end loop;
   append ('from');
   append ('   nm_mrg_query_results_all r');
   append ('  ,nm_mrg_sections_all s');
   append ('  ,nm_mrg_section_member_inv i');
   append ('  ,nm_mrg_section_inv_values_all v');
   append ('where r.nqr_mrg_job_id = s.nms_mrg_job_id');
   append ('  and s.nms_mrg_job_id = i.nsi_mrg_job_id');
   append ('  and s.nms_mrg_section_id = i.nsi_mrg_section_id');
   append ('  and i.nsi_mrg_job_id = v.nsv_mrg_job_id');
   append ('  and i.nsi_value_id = v.nsv_value_id');
   append ('  and r.nqr_nmq_id = '||p_mrg_query_id);
   append (') q');
   append ('where q.nsv_rownum = 1');
   append ('group by');
   append ('   q.nms_mrg_job_id');
   append ('  ,q.nms_mrg_section_id');
   
  nm3ddl.debug_tab_varchar;

   nm3ddl.create_object_and_syns(l_val_view_name);
--
   FOR l_count IN 1..l_tab_rec_col_comment.COUNT
    LOOP
      l_rec_col_comment := l_tab_rec_col_comment(l_count);
      EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||l_val_view_name||'.'||l_rec_col_comment.column_name
                         ||' IS '||nm3flx.string(l_rec_col_comment.comment_text);
   END LOOP;
--
--   nm_debug.debug('Done column comments');
--
   IF g_create_snapshot
    THEN
      -- Only create indexes and constraints on snapshots
      EXECUTE IMMEDIATE 'ALTER TABLE '||l_val_view_name
                        ||' ADD CONSTRAINT '||SUBSTR(l_val_view_name,1,26)||'_PK1 PRIMARY KEY (nms_mrg_job_id,nms_mrg_section_id)';
--
--      nm_debug.debug('Done PK1');
   END IF;
--
   begin -- ignore any errors see log 705258 09/Jun/06
      l_all_val_view_name := SUBSTR(p_view_name,1,26)||'_VLS';
--
--
-- ####################################################################################
--
--    Create the V_MRG_xxxxxx_VLS snapshot
--
-- ####################################################################################
--
--   nm_debug.debug(' Create the V_MRG_xxxxxx_VLS snapshot');
      l_done_a_select := FALSE;
      nm3ddl.delete_tab_varchar;
      append ('CREATE '||g_object_type||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_all_val_view_name||' AS ');
      
      append ('select');
      append ('   s.nms_mrg_job_id');
      append ('  ,s.nms_mrg_section_id');
      append ('  ,v.nsv_inv_type');
      append ('  ,v.nsv_x_sect');
      append ('  ,v.nsv_value_id');
      append ('  ,ta.ita_view_col_name');
      append ('  ,case');      
      

      DECLARE
         l_rec_attrib nm_mrg_query_attribs%ROWTYPE;
         
      BEGIN  
         -- 
         FOR l_counter IN 1..nm3mrg.g_tab_rec_query_attribs.COUNT
          LOOP
            --
            l_rec_attrib := nm3mrg.g_tab_rec_query_attribs(l_counter);
            append ('   when i.nsi_inv_type= '''||get_nm3mrg_inv_type(
                                                     p_nmq_id => l_rec_attrib.nqa_nmq_id
                                                    ,p_seq_no => l_rec_attrib.nqa_nqt_seq_no
                                                  )
              ||''' and qa.nqa_attrib_name = '''||l_rec_attrib.nqa_attrib_name
              ||''' then v.nsv_attrib'||l_counter);

         END LOOP;
      END;

      
      append ('   end attrib_value');
      append ('from');
      append ('   nm_mrg_query_results_all r');
      append ('  ,nm_mrg_sections_all s');
      append ('  ,nm_mrg_section_member_inv i');
      append ('  ,nm_mrg_section_inv_values_all v');
      append ('  ,nm_mrg_query_types t');
      append ('  ,nm_mrg_query_attribs qa');
      append ('  ,nm_inv_type_attribs ta');
      append ('where r.nqr_nmq_id = '||p_mrg_query_id);
      append ('  and r.nqr_mrg_job_id = s.nms_mrg_job_id');
      append ('  and s.nms_mrg_job_id = i.nsi_mrg_job_id');
      append ('  and s.nms_mrg_section_id = i.nsi_mrg_section_id');
      append ('  and i.nsi_mrg_job_id = v.nsv_mrg_job_id');
      append ('  and i.nsi_value_id = v.nsv_value_id');
      append ('  and i.nsi_inv_type = t.nqt_inv_type');
      append ('  and t.nqt_nmq_id = qa.nqa_nmq_id');
      append ('  and t.nqt_seq_no = qa.nqa_nqt_seq_no');
      append ('  and i.nsi_inv_type = ta.ita_inv_type');
      append ('  and qa.nqa_attrib_name = ta.ita_attrib_name');
      
      -- PT: fixed a bug. this seems to be missing also in the original query
      append ('  and t.nqt_nmq_id = '||p_mrg_query_id);
      
      
      --
      nm3ddl.create_object_and_syns(l_all_val_view_name);
      IF g_create_snapshot
       THEN
         -- Only create indexes and constraints on snapshots
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_all_val_view_name
                           ||' ADD CONSTRAINT '||SUBSTR(l_val_view_name,1,26)||'_PK2 PRIMARY KEY (nms_mrg_job_id,nms_mrg_section_id,nsi_value_id,ita_view_col_name)';
      END IF;
    exception
      when others then null ;
    end ;
    
    
    
-- ####################################################################################
--
--    Create the V_MRG_xxxxxx_SVL view
--
-- ####################################################################################
--
--
   l_sec_val_view_name := SUBSTR(p_view_name,1,26)||'_SVL';
   nm3ddl.delete_tab_varchar;
   append ('CREATE '||g_object_type||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||l_sec_val_view_name||' AS ');
   --append ('SELECT /*+ INDEX (NM_MRG_QUERY_RESULTS NMQR_NMQ_FK_IND) */'); -- NM_MRG_SECTION_MEMBERS NMSM_PK,
   --append ('SELECT /*+ RULE */');
   append ('select');
   in_view_comment;
   
    -- sec columns
    append ('   r.nqr_mrg_job_id');
    append ('  ,s.nms_mrg_section_id');
    append ('  ,s.nms_offset_ne_id');
    append ('  ,s.nms_begin_offset');
    append ('  ,s.nms_end_offset');
    -- PT 22.07.09
    if g_include_true then
      append ('  ,nm3mrg_view.get_true(s.nms_offset_ne_id, s.nms_ne_id_first, s.nms_begin_mp_first) begin_offset_true');
      append ('  ,nm3mrg_view.get_true(s.nms_offset_ne_id, s.nms_ne_id_last, s.nms_end_mp_last) end_offset_true');
    end if;
    append ('  ,r.nqr_date_created');
    append ('  ,r.nqr_source_id');
    append ('  ,r.nqr_source');
    append ('  ,r.nqr_description');
    append ('  ,r.nqr_admin_unit');
    append ('  ,decode(s.nms_ne_id_first, s.nms_ne_id_last, decode(s.nms_begin_mp_first, s.nms_end_mp_last, ''P'', ''C''), ''C'') pnt_or_cont');
    append ('  ,s.nms_ne_id_first');
    append ('  ,s.nms_begin_mp_first');
    append ('  ,s.nms_ne_id_last');
    append ('  ,s.nms_end_mp_last');
    
    -- sec columns
    for i in 1 .. t_sec.count loop
      append('  ,'||t_sec(i).col_name);
      
    end loop;
    
    
    -- val columns
    for i in 1 .. t_val.count loop
      append('  ,'||replace(t_val(i).col_name, '<a>', 'rv'));
      
    end loop;
   
    
    append ('from');
         
   -- the q subquery
    append ('   (');
    append ('    select');
    append ('       q.nsi_mrg_job_id');
    append ('      ,q.nsi_mrg_section_id');
    
    
    -- sec min() columns
    for i in 1 .. t_sec.count loop    
      append('      ,min(q.'||t_sec(i).col_name||') '||t_sec(i).col_name);

    end loop;


    -- val case coulumns
    for i in 1 .. t_val.count loop
    
      if t_val(i).xsp is not null then
        append('      ,min(case when q.nsv_inv_type = '''||t_val(i).inv_type
          ||''' and q.nsv_x_sect = '''||t_val(i).xsp
          ||''' then '||replace(t_val(i).nsv_formatted, '<a>', 'q')||' end) '||t_val(i).col_name
        );
      --
      else
        append('      ,min(case when q.nsv_inv_type = '''||t_val(i).inv_type
          ||''' and q.nsv_x_sect is null'
          ||' then '||replace(t_val(i).nsv_formatted, '<a>', 'q')||' end) '||t_val(i).col_name
        );
                           
      end if;
    
    end loop;
    
    
    append ('  from');
    append ('   (');
    append ('    select');
    append ('       mi.nsi_mrg_job_id');
    append ('      ,mi.nsi_mrg_section_id');
    append ('      ,v.nsv_inv_type');
    append ('      ,v.nsv_x_sect');
    
    
    -- sec count() columns
    for i in 1 .. t_sec.count loop
      -- PT 04.02.10 add missing and v.NSV_X_SECT = '''||t_sec(i).inv_type||'' to the case
      
      -- PT 30.03.10 correctly handle null xsp's like min() above
      if t_sec(i).xsp is not null then
        append('      ,count(case when v.nsv_inv_type = '''||t_sec(i).inv_type||''' and v.NSV_X_SECT = '''||t_sec(i).xsp||'''  then 1 end)');
      else
        append('      ,count(case when v.nsv_inv_type = '''||t_sec(i).inv_type||''' and v.NSV_X_SECT is null then 1 end)');
      end if;
      append('        over (partition by mi.nsi_mrg_job_id, mi.nsi_mrg_section_id) '||t_sec(i).col_name);
    
    end loop;


    -- val nsv columns
    for i in 1 .. t_val.count loop
      -- PT 13.07.09: each value only once here
      if nvl(instr(l_unique_cols, ','||t_val(i).nsv_name||','), 0) = 0 then
        l_unique_cols := l_unique_cols||','||t_val(i).nsv_name||',';
        append('      ,v.'||t_val(i).nsv_name);
      end if;
      
    end loop;
    
    
    -- row_number()
    append('      ,row_number() over (partition by mi.nsi_mrg_job_id, mi.nsi_mrg_section_id, v.nsv_x_sect, v.nsv_inv_type order by v.nsv_value_id) nsv_rownum');

    append ('    from');
    append ('        nm_mrg_section_member_inv mi');
    append ('       ,nm_mrg_section_inv_values_all v');
    append ('    where mi.nsi_mrg_job_id IN (');
    append ('          select nqr_mrg_job_id');
    append ('          from nm_mrg_query_results_all');
    append ('          where nqr_nmq_id = '||p_mrg_query_id||')');
    append ('      and mi.nsi_mrg_job_id = v.nsv_mrg_job_id');
    append ('      and mi.nsi_value_id = v.nsv_value_id');
    append ('    ) q');
    append ('    where q.nsv_rownum = 1');
    append ('    group by q.nsi_mrg_job_id, q.nsi_mrg_section_id');
    append ('   ) rv');
    
    append ('  ,nm_mrg_query_results_all r');
    append ('  ,nm_mrg_sections_all s');
    append ('where r.nqr_nmq_id = '||p_mrg_query_id);
    append ('  and r.nqr_mrg_job_id = s.nms_mrg_job_id');
    append ('  and rv.nsi_mrg_job_id = s.nms_mrg_job_id');
    append ('  and rv.nsi_mrg_section_id = s.nms_mrg_section_id');
    
    nm3ddl.debug_tab_varchar;
    nm3ddl.create_object_and_syns(l_sec_val_view_name);
--
   IF g_create_snapshot
    THEN
      -- Only create indexes and constraints on snapshots
      EXECUTE IMMEDIATE 'ALTER TABLE '||l_sec_val_view_name
                        ||' ADD CONSTRAINT '||SUBSTR(l_sec_val_view_name,1,28)||'PK PRIMARY KEY (nqr_mrg_job_id,nms_mrg_section_id)';
   --   EXECUTE IMMEDIATE 'CREATE INDEX '||p_view_name||'_IX  ON '||p_view_name||'(nqr_mrg_job_id)';
   --   EXECUTE IMMEDIATE 'CREATE INDEX '||p_view_name||'_IX2 ON '||p_view_name||'(nms_mrg_section_id)';
   END IF;
--
-- ####################################################################################
--
--    Create the V_MRG_xxxxxx view
--
-- ####################################################################################
--
   nm3ddl.delete_tab_varchar;
   append ('CREATE VIEW '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||p_view_name||' AS ');
   --append ('SELECT /*+ INDEX (NM_MRG_QUERY_RESULTS NMQR_NMQ_FK_IND) */'); -- NM_MRG_SECTION_MEMBERS NMSM_PK,
   append ('SELECT');
   in_view_comment;
   append ('       a.*');
   append ('      ,pe.ne_unique offset_ne_unique');
   append ('      -- ');
   append ('      -- If the source is "ROUTE" and the source_id = offset_id ');
   append ('      --  then this is all on the same route, so use the route_unique');
   append ('      --  for the source_name, otherwise call the function to get the');
   append ('      --  correct name');
   append ('      -- ');
   append ('      ,NVL(DECODE(a.nqr_source');
   append ('                 ,'||nm3flx.string(nm3extent.c_route)||',DECODE(a.nqr_source_id,a.nms_offset_ne_id,pe.ne_unique,Null)');
   append ('                 ,Null');
   append ('                 )');
   append ('          ,nm3extent.get_unique_from_source(a.nqr_source_id,a.nqr_source,'||nm3flx.string('Y')||')');
   append ('          ) nqr_source_name');
--
   append ('      ,c.nsm_ne_id');
   append ('      ,ce.ne_unique datum_ne_unique');
   append ('      ,c.nsm_begin_mp');
   append ('      ,c.nsm_end_mp');
   append ('      ,c.nsm_measure');
   append ('      --');
   append ('      -- Get the NSM (section members) offsets relative to the route');
   append ('      --');
   --
   append('       ,a.nms_begin_offset');
   append('        + decode(c.nsm_measure,0, 0');
   append('         ,decode(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure');
   append('            ,nm3unit.convert_unit(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure))');
   append('        ) nsm_begin_offset');
   append('       ,a.nms_begin_offset');
   append('        + decode(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure + (c.nsm_end_mp - c.nsm_begin_mp)');
   append('          ,nm3unit.convert_unit(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure + (c.nsm_end_mp - c.nsm_begin_mp))');
   append('        ) nsm_end_offset');
--   append('       ');
--   append('       ');
--   append('       ');
--   append ('      ,a.nms_begin_offset + DECODE(c.nsm_measure');
--   append ('                                  ,0,0');
--   append ('                                  ,nm3unit.convert_unit(nm3net.get_nt_units(ce.ne_nt_type)');
--   append ('                                                       ,nm3net.get_nt_units(pe.ne_nt_type)');
--   append ('                                                       ,c.nsm_measure');
--   append ('                                                       )');
--   append ('                                  ) nsm_begin_offset');
--   append ('      ,a.nms_begin_offset + nm3unit.convert_unit(nm3net.get_nt_units(ce.ne_nt_type)');
--   append ('                                                ,nm3net.get_nt_units(pe.ne_nt_type)');
--   append ('                                                ,c.nsm_measure+(c.nsm_end_mp-c.nsm_begin_mp)');
--   append ('                                                ) nsm_end_offset');
   IF g_include_true
    THEN
       append('       ,a.begin_offset_true');
       append('        + decode(c.nsm_measure,0, 0');
       append('         ,decode(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure');
       append('            ,nm3unit.convert_unit(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure))');
       append('        ) nsm_begin_offset_true');
       append('       ,a.begin_offset_true');
       append('        + decode(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure + (c.nsm_end_mp - c.nsm_begin_mp)');
       append('          ,nm3unit.convert_unit(tc.nt_length_unit, tp.nt_length_unit, c.nsm_measure + (c.nsm_end_mp - c.nsm_begin_mp))');
       append('        ) nsm_end_offset_true');
--      append ('      ,a.begin_offset_true + DECODE(c.nsm_measure');
--      append ('                                   ,0,0');
--      append ('                                   ,nm3unit.convert_unit(nm3net.get_nt_units(ce.ne_nt_type)');
--      append ('                                                        ,nm3net.get_nt_units(pe.ne_nt_type)');
--      append ('                                                        ,c.nsm_measure');
--      append ('                                                        )');
--      append ('                                   ) nsm_begin_offset_true');
--      append ('      ,a.begin_offset_true + nm3unit.convert_unit(nm3net.get_nt_units(ce.ne_nt_type)');
--      append ('                                                 ,nm3net.get_nt_units(pe.ne_nt_type)');
--      append ('                                                 ,c.nsm_measure+(c.nsm_end_mp-c.nsm_begin_mp)');
--      append ('                                                 ) nsm_end_offset_true');
   END IF;
   append (' FROM  '||l_sec_val_view_name||' a');
   append ('      ,nm_mrg_section_members c');
   append ('      ,nm_elements            pe');
   append ('      ,nm_elements            ce');
   append ('      ,nm_types tp');
   append ('      ,nm_types tc');
   append ('WHERE a.nqr_mrg_job_id     = c.nsm_mrg_job_id');
   append (' AND  a.nms_mrg_section_id = c.nsm_mrg_section_id');
   append (' AND  a.nms_offset_ne_id   = pe.ne_id');
   append (' AND  c.nsm_ne_id          = ce.ne_id');
   append ('  and pe.ne_nt_type = tp.nt_type');
   append ('  and ce.ne_nt_type = tc.nt_type');
   

   
   nm3ddl.debug_tab_varchar;
   nm3ddl.create_object_and_syns(p_view_name);
--
   nm3ddl.grant_on_object
           (p_grant_to     => nm3type.c_public
           ,p_object_name  => p_view_name
           ,p_grant_select => TRUE
           ,p_grant_insert => FALSE
           ,p_grant_update => FALSE
           ,p_grant_delete => FALSE
           ,p_with_admin   => FALSE
           );

   nm3mrg_sdo.create_spatial_mrg_view( p_mrg_query_id );
		   
--
   nm_debug.proc_end(g_package_name,'build_view');
--
EXCEPTION
--
   WHEN nm3mrg.g_mrg_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3mrg.g_mrg_exc_code,nm3mrg.g_mrg_exc_msg);
--
END build_view;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mrg_inv_value (p_mrg_job_id     IN NUMBER
                           ,p_mrg_section_id IN NUMBER
                           ,p_inv_type       IN VARCHAR2
                           ,p_x_sect         IN VARCHAR2
                           ,p_attrib_number  IN NUMBER
                           ) RETURN VARCHAR2 IS
--
   l_found   BOOLEAN;
   l_retval  nm3type.max_varchar2;
--
BEGIN
--
   IF p_x_sect IS NOT NULL
    THEN
      OPEN  cs_values_xsp (p_mrg_job_id
                          ,p_mrg_section_id
                          ,p_inv_type
                          ,p_x_sect
                          );
      FETCH cs_values_xsp INTO nm3mrg_supplementary.g_rec_nsv;
      l_found := cs_values_xsp%FOUND;
      CLOSE cs_values_xsp;
   ELSE
      OPEN  cs_values_no_xsp (p_mrg_job_id
                             ,p_mrg_section_id
                             ,p_inv_type
                             );
      FETCH cs_values_no_xsp INTO nm3mrg_supplementary.g_rec_nsv;
      l_found := cs_values_no_xsp%FOUND;
      CLOSE cs_values_no_xsp;
   END IF;
--
   IF l_found
    THEN
      l_retval := nm3mrg_supplementary.get_val_from_rec_nsv (p_attrib_number);
   END IF;
--
   RETURN l_retval;
--
END get_mrg_inv_value;
--
-----------------------------------------------------------------------------
--
FUNCTION check_inv_exists (p_mrg_job_id     IN NUMBER
                          ,p_mrg_section_id IN NUMBER
                          ,p_inv_type       IN VARCHAR2
                          ,p_x_sect         IN VARCHAR2
                          ) RETURN nm_mrg_sections.nms_in_results%TYPE IS
--
   l_retval  nm_mrg_sections.nms_in_results%TYPE;
   l_rec_nsv nm_mrg_section_inv_values%ROWTYPE;
--
   l_found   BOOLEAN;
--
BEGIN
--
   IF p_x_sect IS NOT NULL
    THEN
      OPEN  cs_values_xsp (p_mrg_job_id
                          ,p_mrg_section_id
                          ,p_inv_type
                          ,p_x_sect
                          );
      FETCH cs_values_xsp INTO l_rec_nsv;
      l_found := cs_values_xsp%FOUND;
      CLOSE cs_values_xsp;
   ELSE
      OPEN  cs_values_no_xsp (p_mrg_job_id
                             ,p_mrg_section_id
                             ,p_inv_type
                             );
      FETCH cs_values_no_xsp INTO l_rec_nsv;
      l_found := cs_values_no_xsp%FOUND;
      CLOSE cs_values_no_xsp;
   END IF;
--
   IF l_found
    THEN
      l_retval := 'Y';
   ELSE
      l_retval := 'N';
   END IF;
--
   RETURN l_retval;
--
END check_inv_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mrg_view_name_by_job_id (pi_job_id NUMBER) RETURN VARCHAR2 IS
--
   CURSOR cs_nqr (p_mrg_job_id NUMBER) IS
   SELECT nqr_nmq_id
    FROM  nm_mrg_query_results
   WHERE  nqr_mrg_job_id = p_mrg_job_id;
--
   l_nmq_id NUMBER;
--
BEGIN
--
   OPEN  cs_nqr (pi_job_id);
   FETCH cs_nqr INTO l_nmq_id;
   IF cs_nqr%NOTFOUND
    THEN
      CLOSE cs_nqr;
      RAISE_APPLICATION_ERROR(-20001,'No NM_MRG_QUERY_RESULTS record found');
   END IF;
   CLOSE cs_nqr;
--
   RETURN get_mrg_view_name_by_qry_id(l_nmq_id);
--
END get_mrg_view_name_by_job_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mrg_view_name_by_qry_id (pi_qry_id NUMBER) RETURN VARCHAR2 IS
--
   l_rec_qry nm_mrg_query%ROWTYPE;
--
BEGIN
--
   l_rec_qry := nm3mrg.select_mrg_query (pi_qry_id);
--
   RETURN get_mrg_view_name_by_unique(l_rec_qry.nmq_unique);
--
EXCEPTION
--
   WHEN nm3mrg.g_mrg_exception
    THEN
      RAISE_APPLICATION_ERROR(nm3mrg.g_mrg_exc_code,nm3mrg.g_mrg_exc_msg);
--
END get_mrg_view_name_by_qry_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_mrg_view_name_by_unique (pi_unique VARCHAR2) RETURN VARCHAR2 IS
--
   l_retval VARCHAR2(30) := 'V_MRG_';
--
BEGIN
--
   l_retval  := l_retval||pi_unique;
--
   IF NOT nm3flx.is_string_valid_for_object(l_retval)
    THEN
      RAISE_APPLICATION_ERROR(-20001,l_retval||' is not a valid object name');
   END IF;
--
   RETURN l_retval;
--
END get_mrg_view_name_by_unique;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_merge_view (p_view_name VARCHAR2) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_string VARCHAR2(100) := 'DROP '||g_object_type||' '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.';
--
   l_tab_name nm3type.tab_varchar30;
--
   PROCEDURE add_name (p_suffix VARCHAR2) IS
   BEGIN
      l_tab_name(l_tab_name.COUNT+1) := SUBSTR(p_view_name,1,26)||p_suffix;
   END add_name;
--
   PROCEDURE exec_it (p_sql VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE p_sql;
   EXCEPTION
      WHEN OTHERS
       THEN
         Null;
   END exec_it;
--
   PROCEDURE drop_syn (p_name VARCHAR2) IS
   BEGIN
      nm3ddl.drop_synonym_for_object(p_name);
   EXCEPTION
      WHEN OTHERS
       THEN
         Null;
   END drop_syn;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'drop_merge_view');
--
   l_tab_name(1) := p_view_name;
   add_name ('_SEC');
   add_name ('_VAL');
   add_name ('_VLS');
   add_name ('_SVL');
   add_name ('_SDO');
   FOR i IN 1..l_tab_name.COUNT
    LOOP
      drop_syn (l_tab_name(i));
   END LOOP;
   FOR i IN 1..l_tab_name.COUNT
    LOOP
      exec_it (l_string||l_tab_name(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'drop_merge_view');
--
END drop_merge_view;
--
-----------------------------------------------------------------------------
--
PROCEDURE drop_merge_view (p_qry_id NUMBER) IS
--
   c_view_name CONSTANT VARCHAR2(30) := get_mrg_view_name_by_qry_id (p_qry_id);
--
BEGIN
--
   drop_merge_view (c_view_name);
--
END drop_merge_view;
--
-----------------------------------------------------------------------------
--
PROCEDURE refresh_merge_results_snapshot (p_qry_id IN NUMBER) IS
--
   c_view_name VARCHAR2(30);
--
   l_sec_view_name     VARCHAR2(30);
   l_val_view_name     VARCHAR2(30);
   l_all_val_view_name VARCHAR2(30);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'refresh_merge_results_snapshot');
--
   IF g_create_snapshot
    THEN
      c_view_name := get_mrg_view_name_by_qry_id (p_qry_id);
--
      l_sec_view_name     := SUBSTR(c_view_name,1,26)||'_SEC';
      l_val_view_name     := SUBSTR(c_view_name,1,26)||'_VAL';
      l_all_val_view_name := SUBSTR(c_view_name,1,26)||'_VLS';
--
      -- Obviously only refresh if this is a snapshot
      dbms_snapshot.refresh('"'||Sys_Context('NM3CORE','APPLICATION_OWNER')||'"."'||l_sec_view_name||'"');
      dbms_snapshot.refresh('"'||Sys_Context('NM3CORE','APPLICATION_OWNER')||'"."'||l_val_view_name||'"');
      dbms_snapshot.refresh('"'||Sys_Context('NM3CORE','APPLICATION_OWNER')||'"."'||l_all_val_view_name||'"');
   END IF;
--
   nm_debug.proc_end(g_package_name,'refresh_merge_results_snapshot');
--
END refresh_merge_results_snapshot;
--
-----------------------------------------------------------------------------
--
FUNCTION count_inv_vals   (p_mrg_job_id     IN NUMBER
                          ,p_mrg_section_id IN NUMBER
                          ,p_inv_type       IN VARCHAR2
                          ,p_x_sect         IN VARCHAR2
                          ) RETURN NUMBER IS
--
   CURSOR cs_values_xsp_count (p_mrg_job_id     NUMBER
                              ,p_mrg_section_id NUMBER
                              ,p_inv_type       VARCHAR2
                              ,p_x_sect         VARCHAR2
                              ) IS
   SELECT COUNT(distinct nsi_value_id)
    FROM  nm_mrg_section_member_inv nsi
         ,nm_mrg_section_inv_values nsv
   WHERE  nsi.nsi_mrg_job_id     = p_mrg_job_id
    AND   nsi.nsi_mrg_section_id = p_mrg_section_id
    AND   nsi.nsi_inv_type       = p_inv_type
    AND   nsi.nsi_x_sect         = p_x_sect
    AND   nsi.nsi_mrg_job_id     = nsv.nsv_mrg_job_id
    AND   nsi.nsi_value_id       = nsv.nsv_value_id;
--
   CURSOR cs_values_no_xsp_count (p_mrg_job_id     NUMBER
                                 ,p_mrg_section_id NUMBER
                                 ,p_inv_type       VARCHAR2
                                 ) IS
   SELECT COUNT(distinct nsi_value_id)
    FROM  nm_mrg_section_member_inv nsi
         ,nm_mrg_section_inv_values nsv
   WHERE  nsi.nsi_mrg_job_id     = p_mrg_job_id
    AND   nsi.nsi_mrg_section_id = p_mrg_section_id
    AND   nsi.nsi_inv_type       = p_inv_type
    AND   nsi.nsi_x_sect         IS NULL
    AND   nsi.nsi_mrg_job_id     = nsv.nsv_mrg_job_id
    AND   nsi.nsi_value_id       = nsv.nsv_value_id;
--
   l_count NUMBER;
--
BEGIN
--
   IF p_x_sect IS NOT NULL
    THEN
      OPEN  cs_values_xsp_count (p_mrg_job_id
                                ,p_mrg_section_id
                                ,p_inv_type
                                ,p_x_sect
                                );
      FETCH cs_values_xsp_count INTO l_count;
      CLOSE cs_values_xsp_count;
   ELSE
      OPEN  cs_values_no_xsp_count (p_mrg_job_id
                                   ,p_mrg_section_id
                                   ,p_inv_type
                                   );
      FETCH cs_values_no_xsp_count INTO l_count;
      CLOSE cs_values_no_xsp_count;
   END IF;
--
   RETURN l_count;
--
END count_inv_vals;
--
-----------------------------------------------------------------------------
--
FUNCTION can_user_see_merge_views (p_qry_id IN NUMBER) RETURN BOOLEAN IS
--
   c_view_name CONSTANT VARCHAR2(30) := get_mrg_view_name_by_qry_id (p_qry_id);
   l_dummy              PLS_INTEGER;
   l_retval             BOOLEAN;
   l_cur                nm3type.ref_cursor;
--
BEGIN
--
   BEGIN
      OPEN  l_cur FOR 'SELECT 1 FROM '||c_view_name||' WHERE ROWNUM = 1';
      FETCH l_cur INTO l_dummy;
      CLOSE l_cur;
      l_retval := TRUE;
   EXCEPTION
      WHEN others
       THEN
         IF l_cur%ISOPEN
          THEN
            CLOSE l_cur;
         END IF;
         l_retval := FALSE;
   END;
--
   RETURN l_retval;
--
END can_user_see_merge_views;
--
-----------------------------------------------------------------------------
--
FUNCTION get_true (p_offset_ne_id nm_members.nm_ne_id_in%TYPE
                  ,p_datum_ne_id  nm_members.nm_ne_id_of%TYPE
                  ,p_datum_mp     nm_members.nm_begin_mp%TYPE
                  ) RETURN nm_members.nm_true%TYPE IS
BEGIN
   RETURN nm3lrs.get_set_offset_true (p_offset_ne_id,p_datum_ne_id,p_datum_mp);
END get_true;
--
-----------------------------------------------------------------------------


  function sql_view_col_name(
     p_inv_type in varchar2
    ,p_xsp in varchar2
    ,p_view_attri in varchar2
  ) return varchar2
  is
  begin
    if p_xsp is not null then
      return substr(p_inv_type||'_'||p_xsp||'_'||p_view_attri, 1, 30);
    else
      return substr(p_inv_type||'_'||p_view_attri, 1, 30);
   end if;
  end;

--
BEGIN
--
   IF g_create_snapshot
    THEN
      g_object_type := 'MATERIALIZED VIEW';
   ELSE
      g_object_type := 'VIEW';
   END IF;
--
end nm3mrg_view;
/
