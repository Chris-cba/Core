CREATE OR REPLACE PACKAGE BODY nm3job_load AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3job_load.pkb-arc   2.4   Jul 04 2013 16:11:40   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3job_load.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:11:40  $
--       Date fetched Out : $Modtime:   Jul 04 2013 15:45:06  $
--       Version          : $Revision:   2.4  $
--       Based on SCCS version : 1.2
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 Jobs (and operations) CSV Loader Package body
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
   g_package_name    CONSTANT  varchar2(30)   := 'nm3job_load';
--
   stp_is_licensed   CONSTANT  BOOLEAN        := hig.is_product_licensed (nm3type.c_stp);
   c_xsp             CONSTANT  VARCHAR2(3)    := 'XSP';
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
PROCEDURE load_or_validate_njc (p_rec           IN OUT nm_job_control%ROWTYPE
                               ,p_validate_only IN     BOOLEAN
                               ) IS
--
   l_rec_njt    nm_job_types%ROWTYPE;
   l_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;
--
   c_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   l_pl_arr   nm_placement_array;
--
   PROCEDURE set_for_return IS
   BEGIN
      nm3user.set_effective_date (c_eff_date);
   END set_for_return;
--
BEGIN
--
   SAVEPOINT top_of_validate;
--
   IF nm3get.get_njc (pi_njc_unique      => p_rec.njc_unique
                     ,pi_raise_not_found => FALSE
                     ).njc_job_id IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 145
                    ,pi_supplementary_info => 'NJC_UNIQUE'
                    );
   ELSIF p_rec.njc_job_id IS NOT NULL
    AND  nm3get.get_njc (pi_njc_job_id      => p_rec.njc_job_id
                        ,pi_raise_not_found => FALSE
                        ).njc_job_id IS NOT NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 145
                    ,pi_supplementary_info => 'NJC_JOB_ID'
                    );
   END IF;
--
   p_rec.njc_status := nm3job.c_not_started;
--
   l_rec_njt := nm3get.get_njt (pi_njt_type => p_rec.njc_njt_type);
--
   nm3user.set_effective_date (p_rec.njc_effective_date);
--
   IF  p_rec.njc_route_ne_id    IS NULL
    OR p_rec.njc_route_begin_mp IS NULL
    OR p_rec.njc_route_end_mp   IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 112
                    ,pi_supplementary_info => 'Route Information must be provided'
                    );
   END IF;
--
   nm3extent.create_temp_ne (pi_source_id => p_rec.njc_route_ne_id
                            ,pi_source    => nm3extent.c_route
                            ,pi_begin_mp  => p_rec.njc_route_begin_mp
                            ,pi_end_mp    => p_rec.njc_route_end_mp
                            ,po_job_id    => l_nte_job_id
                            );
--
   l_pl_arr := nm3pla.defrag_placement_array(nm3pla.get_placement_from_temp_ne (l_nte_job_id));
--
   IF nm3pla.count_pl_arr_connected_chunks  (l_pl_arr) != 1
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 168
                    --,pi_supplementary_info =>
                    );
   END IF;
--
   IF p_validate_only
    THEN
      ROLLBACK TO top_of_validate;
   ELSE
      p_rec.njc_npe_job_id := nm3extent.create_npe_from_nte (l_nte_job_id);
      nm3ins.ins_njc (p_rec_njc => p_rec);
   END IF;
--
   set_for_return;
--
EXCEPTION
--
   WHEN others
    THEN
      set_for_return;
      RAISE;
--
END load_or_validate_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_njc (p_rec IN OUT nm_job_control%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'validate_njc');
--
   load_or_validate_njc (p_rec           => p_rec
                        ,p_validate_only => TRUE
                        );
--
   nm_debug.proc_end(g_package_name,'validate_njc');
--
END validate_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_njc (p_rec IN OUT nm_job_control%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'load_njc');
--
   load_or_validate_njc (p_rec           => p_rec
                        ,p_validate_only => FALSE
                        );
--
   nm_debug.proc_end(g_package_name,'load_njc');
--
END load_njc;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_objects_for_all_nmo IS
   l_tab_nmo_operation nm3type.tab_varchar30;
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_objects_for_all_nmo');
--
   SELECT nmo_operation
    BULK  COLLECT
    INTO  l_tab_nmo_operation
    FROM  nm_operations;
--
   FOR i IN 1..l_tab_nmo_operation.COUNT
    LOOP
      build_objects_for_nmo (pi_nmo_operation => l_tab_nmo_operation(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'build_objects_for_all_nmo');
--
END build_objects_for_all_nmo;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_objects_for_nmo (pi_nmo_operation nm_operations.nmo_operation%TYPE) IS
--
   l_view   nm3type.tab_varchar32767;
   l_header nm3type.tab_varchar32767;
   l_body   nm3type.tab_varchar32767;
--
--
   c_view_name    CONSTANT VARCHAR2(30) := 'X_LD_'||SUBSTR(pi_nmo_operation,1,23)||'_V';
   c_package_name CONSTANT VARCHAR2(30) := 'X_LD_'||SUBSTR(pi_nmo_operation,1,25);
--
   l_rec_nld               nm_load_destinations%ROWTYPE;
   l_rec_nmo               nm_operations%ROWTYPE;
   l_rec_nlf               nm_load_files%ROWTYPE;
   l_rec_nlfc              nm_load_file_cols%ROWTYPE;
   l_rec_nlfd              nm_load_file_destinations%ROWTYPE;
   l_seq_no                PLS_INTEGER;
   l_col_name              VARCHAR2(30);
   l_source_col            nm_load_file_col_destinations.nlcd_source_col%TYPE;
--
   l_prefix varchar2(30);
   l_suffix varchar2(30);
   l_xsp_exists BOOLEAN;
--
   TYPE tab_nod IS TABLE OF nm_operation_data%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_nod tab_nod;
--
   PROCEDURE append_view (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_view, p_text, p_nl);
   END append_view;
--
   PROCEDURE append_header (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_header, p_text, p_nl);
   END append_header;
--
   PROCEDURE append_body (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3tab_varchar.append (l_body, p_text, p_nl);
   END append_body;
--
   PROCEDURE append_all_3 (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      append_view   (p_text, p_nl);
      append_header (p_text, p_nl);
      append_body   (p_text, p_nl);
   END append_all_3;
--
   PROCEDURE append_header_and_body (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      append_header (p_text, p_nl);
      append_body   (p_text, p_nl);
   END append_header_and_body;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_objects_for_nmo');
--
   l_rec_nmo := nm3get.get_nmo (pi_nmo_operation => pi_nmo_operation);
--
   append_view   ('CREATE OR REPLACE FORCE VIEW '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_view_name||' AS');
   append_header ('CREATE OR REPLACE PACKAGE '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_package_name||' IS');
   append_body   ('CREATE OR REPLACE PACKAGE BODY '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.'||c_package_name||' IS');
   append_view   ('SELECT');
   append_header ('--<PACKAGE>');
   append_all_3  ('--');
   append_all_3  ('-- Generated object for loading data for the ');
   append_all_3  ('--  '||l_rec_nmo.nmo_descr||' ('||pi_nmo_operation||') operation');
   append_all_3  ('--');
   append_all_3  ('-----------------------------------------------------------------------------');
   append_all_3  ('--');
   append_all_3  ('--   SCCS Identifiers :-');
   append_all_3  ('--');
   append_all_3  ('--       sccsid           : @(#)nm3job_load.pkb	1.2 03/07/05');
   append_all_3  ('--       Module Name      : nm3job_load.pkb');
   append_all_3  ('--       Date into SCCS   : 05/03/07 23:55:00');
   append_all_3  ('--       Date fetched Out : 07/06/13 14:12:17');
   append_all_3  ('--       SCCS Version     : 1.2');
   append_all_3  ('--');
   append_all_3  ('--');
   append_all_3  ('--   Author : Jonathan Mills');
   append_all_3  ('--');
   append_all_3  ('--   Generated by NM3 Jobs (and operations) CSV Loader Package body');
   append_all_3  ('--');
   append_all_3  ('-----------------------------------------------------------------------------');
   append_all_3  ('--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
   append_all_3  ('-----------------------------------------------------------------------------');
   append_all_3  ('--');
   append_header ('--</PACKAGE>');
   append_view   ('       njc_unique');
   append_view   ('      ,njo_seq');
   append_view   ('      ,SUBSTR(njc_job_descr,1,50) njo_primary_key');
   SELECT *
    BULK  COLLECT
    INTO  l_tab_nod
    FROM  nm_operation_data
   WHERE  nod_nmo_operation = pi_nmo_operation
   ORDER BY nod_seq;
--
  l_xsp_exists := FALSE;
  FOR i IN 1..l_tab_nod.COUNT
    LOOP
      l_prefix := Null;
      l_suffix := Null;
      IF l_tab_nod(i).nod_data_type = nm3type.c_number
       THEN
         l_prefix := 'TO_NUMBER(';
         l_suffix := ')';
      ELSIF l_tab_nod(i).nod_data_type = nm3type.c_date
       THEN
         l_prefix := 'hig.date_convert(';
         l_suffix := ')';
      END IF;
      IF l_tab_nod(i).nod_data_item = c_xsp
       THEN
         l_xsp_exists := TRUE;
      END IF;
      append_view   ('      ,'||l_prefix||'NJV_VALUE'||l_suffix||' '||l_tab_nod(i).nod_data_item||' -- '||l_tab_nod(i).nod_scrn_text);
   END LOOP;
--
   append_view ('      ,njo_begin_mp');
   append_view ('      ,njo_end_mp');
   append_view ('  FROM nm_job_control');
   append_view ('      ,nm_job_operations');
   append_view ('      ,nm_job_operation_data_values');
   append_view ('WHERE  njo_njc_job_id = njc_job_id');
   append_view (' AND   njv_njc_job_id = njc_job_id');
   append_view (' AND   njo_id         = njv_njo_id');
   append_view (' AND   ROWNUM         = 0');
--
   append_body ('   g_package_name CONSTANT VARCHAR2(30)                     := '||nm3flx.string(c_package_name)||';');
   append_body ('   g_operation    CONSTANT nm_operations.nmo_operation%TYPE := '||nm3flx.string(pi_nmo_operation)||';');
   append_body ('--');
--   append_body ('   TYPE tab_nod IS TABLE OF nm_operation_data%ROWTYPE;');
--   append_body ('   g_tab_nod tab_nod;');
   append_body ('   g_rec_njv nm_job_operation_data_values%ROWTYPE;');
   append_body ('   TYPE tab_njv IS TABLE OF nm_job_operation_data_values%ROWTYPE INDEX BY BINARY_INTEGER;');
   append_body ('   g_tab_njv tab_njv;');
   append_body ('   g_rec_njc nm_job_control%ROWTYPE;');
   append_body ('   c_user_date_mask CONSTANT VARCHAR2(30) := Sys_Context(''NM3CORE'',''USER_DATE_MASK'');');
   append_body ('--');
   append_body ('-----------------------------------------------------------------------------');
   append_body ('--');
   append_body ('PROCEDURE validate_and_arrayify (p_field VARCHAR2, p_value VARCHAR2) IS');
   append_body ('   l_rec_nod  nm_operation_data%ROWTYPE;');
   append_body ('   l_cur      nm3type.ref_cursor;');
   append_body ('   l_sql      nm3type.max_varchar2;');
   append_body ('   l_data_field  VARCHAR2(30);');
   append_body ('   l_desc_tab dbms_sql.desc_tab;');
   append_body ('   l_dummy    PLS_INTEGER;');
   append_body ('   l_found    BOOLEAN;');
   append_body ('BEGIN');
   append_body ('--');
   append_body ('   l_rec_nod := nm3get.get_nod (pi_nod_nmo_operation => g_operation');
   append_body ('                               ,pi_nod_data_item     => p_field');
   append_body ('                               );');
   append_body ('--');
   append_body ('   IF   l_rec_nod.nod_mandatory = '||nm3flx.string('Y'));
   append_body ('    AND p_value IS NULL');
   append_body ('    THEN');
   append_body ('      hig.raise_ner (pi_appl               => nm3type.c_net');
   append_body ('                    ,pi_id                 => 50');
   append_body ('                    ,pi_supplementary_info => p_field');
   append_body ('                    );');
   append_body ('   END IF;');
   append_body ('--');
   append_body ('   IF l_rec_nod.nod_query_sql IS NOT NULL');
   append_body ('    AND p_value IS NOT NULL');
   append_body ('    THEN');
   append_body ('      l_desc_tab := nm3flx.get_col_dets_from_sql (l_rec_nod.nod_query_sql);');
   append_body ('      l_data_field  := l_desc_tab(3).col_name;');
   append_body ('      l_sql := '||nm3flx.string('SELECT 1 FROM (')||'||l_rec_nod.nod_query_sql||'||nm3flx.string(') WHERE ')||'||l_data_field||'||nm3flx.string(' = :a')||';');
   append_body ('      OPEN  l_cur FOR l_sql USING p_value;');
   append_body ('      FETCH l_cur INTO l_dummy;');
   append_body ('      l_found := l_cur%FOUND;');
   append_body ('      CLOSE l_cur;');
   append_body ('      IF NOT l_found');
   append_body ('       THEN');
   append_body ('         hig.raise_ner (pi_appl => nm3type.c_hig');
   append_body ('                       ,pi_id   => 110');
   append_body ('                       ,pi_supplementary_info => p_field||'||nm3flx.string(':')||'||p_value');
   append_body ('                       );');
   append_body ('      END IF;');
   append_body ('   END IF;');
   append_body ('--');
   append_body ('   g_rec_njv.njv_nod_data_item  := p_field;');
   append_body ('   g_rec_njv.njv_value          := p_value;');
   append_body ('   g_tab_njv(g_tab_njv.COUNT+1) := g_rec_njv;');
   append_body ('--');
   append_body ('END validate_and_arrayify;');
   append_body ('--');
   append_body ('-----------------------------------------------------------------------------');
   append_body ('--');
--
   append_header ('--<PROC NAME="VALIDATE">');
   append_header_and_body ('PROCEDURE VALIDATE (p_rec '||c_view_name||'%ROWTYPE)');
   append_header (';',FALSE);
   append_header ('--</PROC>');
   append_body   (' IS',FALSE);
--
   append_body ('--');
   append_body ('   l_rec_jto nm_job_types_operations%ROWTYPE;');
   append_body ('--');
   append_body ('BEGIN');
   append_body ('--');
   append_body ('   nm_debug.proc_start (g_package_name, '||nm3flx.string('VALIDATE')||');');
   append_body ('--');
   append_body ('   g_tab_njv.DELETE;');
   append_body ('--');
   append_body ('   g_rec_njc := nm3get.get_njc (pi_njc_unique => p_rec.njc_unique);');
   append_body ('--');
   append_body ('   l_rec_jto := nm3get.get_jto (pi_jto_njt_type      => g_rec_njc.njc_njt_type');
   append_body ('                               ,pi_jto_nmo_operation => g_operation');
   append_body ('                               );');
   append_body ('--');
   append_body ('   IF nm3get.get_njo (pi_njo_njc_job_id  => g_rec_njc.njc_job_id');
   append_body ('                     ,pi_njo_seq         => p_rec.njo_seq');
   append_body ('                     ,pi_raise_not_found => FALSE');
   append_body ('                     ).njo_id IS NOT NULL');
   append_body ('    THEN');
   append_body ('      hig.raise_ner (pi_appl               => nm3type.c_hig');
   append_body ('                    ,pi_id                 => 145');
   append_body ('                    ,pi_supplementary_info => p_rec.njc_unique||'||nm3flx.string(':')||'||p_rec.njo_seq');
   append_body ('                    );');
   append_body ('   END IF;');
   append_body ('--');
   append_body ('   IF p_rec.njo_begin_mp >= p_rec.njo_end_mp');
   append_body ('    THEN');
   append_body ('      hig.raise_ner (pi_appl => nm3type.c_net');
   append_body ('                    ,pi_id   => 276');
   append_body ('                    );');
   append_body ('   ELSIF p_rec.njo_begin_mp < 0');
   append_body ('    THEN');
   append_body ('      hig.raise_ner (pi_appl => nm3type.c_net');
   append_body ('                    ,pi_id   => 277');
   append_body ('                    );');
   append_body ('   ELSIF (g_rec_njc.njc_route_begin_mp + p_rec.njo_end_mp) > g_rec_njc.njc_route_end_mp');
   append_body ('    THEN');
   append_body ('      hig.raise_ner (pi_appl => nm3type.c_net');
   append_body ('                    ,pi_id   => 278');
   append_body ('                    );');
   append_body ('   END IF;');
   append_body ('--');
   append_body ('   g_rec_njv.njv_njc_job_id    := g_rec_njc.njc_job_id;');
   append_body ('   g_rec_njv.njv_njo_id        := Null;');
   append_body ('   g_rec_njv.njv_nmo_operation := g_operation;');
   append_body ('   g_rec_njv.njv_nod_data_item := Null;');
   append_body ('   g_rec_njv.njv_value         := Null;');
   append_body ('--');
   FOR i IN 1..l_tab_nod.COUNT
    LOOP
      IF l_tab_nod(i).nod_data_type = nm3type.c_date
       THEN
         append_body ('   validate_and_arrayify ('||nm3flx.string(l_tab_nod(i).nod_data_item)||',TO_CHAR(hig.date_convert(p_rec.'||l_tab_nod(i).nod_data_item||'),c_user_date_mask));');
      ELSE
         append_body ('   validate_and_arrayify ('||nm3flx.string(l_tab_nod(i).nod_data_item)||',p_rec.'||l_tab_nod(i).nod_data_item||');');
      END IF;
   END LOOP;
   append_body ('--');
   append_body ('   nm_debug.proc_end (g_package_name, '||nm3flx.string('VALIDATE')||');');
   append_body ('--');
   append_body ('END validate;');
   append_header_and_body ('--');
   append_header_and_body ('-----------------------------------------------------------------------------');
   append_header_and_body ('--');
--
   append_header ('--<PROC NAME="INS">');
   append_header_and_body ('PROCEDURE INS (p_rec '||c_view_name||'%ROWTYPE)');
   append_header (';',FALSE);
   append_header ('--</PROC>');
   append_body   (' IS',FALSE);
--
   append_body ('--');
   append_body ('   l_rec_njo nm_job_operations%ROWTYPE;');
   append_body ('--');
   append_body ('BEGIN');
   append_body ('--');
   append_body ('   nm_debug.proc_start (g_package_name, '||nm3flx.string('INS')||');');
   append_body ('--');
   append_body ('   validate (p_rec);');
   append_body ('--');
   append_body ('   l_rec_njo.njo_njc_job_id         := g_rec_njc.njc_job_id;');
   append_body ('   l_rec_njo.njo_id                 := nm3seq.next_njo_id_seq;');
   append_body ('   l_rec_njo.njo_nmo_operation      := g_operation;');
   append_body ('   l_rec_njo.njo_seq                := p_rec.njo_seq;');
   append_body ('   l_rec_njo.njo_status             := nm3job.c_not_started;');
   append_body ('   l_rec_njo.njo_begin_mp           := p_rec.njo_begin_mp;');
   append_body ('   l_rec_njo.njo_end_mp             := p_rec.njo_end_mp;');
   append_body ('   nm3ins.ins_njo (p_rec_njo => l_rec_njo);');
   append_body ('--');
   append_body ('   FOR i IN 1..g_tab_njv.COUNT');
   append_body ('    LOOP');
   append_body ('      g_tab_njv(i).njv_njo_id := l_rec_njo.njo_id;');
   append_body ('      nm3ins.ins_njv (p_rec_njv => g_tab_njv(i));');
   append_body ('   END LOOP;');
   append_body ('--');
   append_body ('   g_tab_njv.DELETE;');
   append_body ('--');
   append_body ('   nm_debug.proc_end (g_package_name, '||nm3flx.string('INS')||');');
   append_body ('--');
   append_body ('END ins;');
   append_header_and_body ('--');
   append_header_and_body ('-----------------------------------------------------------------------------');
   append_header_and_body ('--');
--
   IF stp_is_licensed
    AND l_xsp_exists
    THEN
      append_header ('--<PROC NAME="check_xsp_exists">');
      append_header_and_body ('FUNCTION check_xsp_exists (p_njc_unique VARCHAR2,p_xsp nm_inv_items.iit_x_sect%TYPE,p_begin_mp NUMBER, p_end_mp NUMBER) RETURN nm_inv_items.iit_x_sect%TYPE');
      append_header (';',FALSE);
      append_header ('--</PROC>');
      append_body   (' IS',FALSE);
      append_body   ('   l_rec_ngq       nm_gaz_query%ROWTYPE;');
      append_body   ('   l_rec_ngqt      nm_gaz_query_types%ROWTYPE;');
      append_body   ('   l_rec_ngqa      nm_gaz_query_attribs%ROWTYPE;');
      append_body   ('   l_rec_ngqv      nm_gaz_query_values%ROWTYPE;');
      append_body   ('   l_result_nte_id NUMBER;');
      append_body   ('   l_source_nte_id NUMBER;');
      append_body   ('   l_extent_match  BOOLEAN;');
      append_body   ('   not_matched     EXCEPTION;');
      append_body   ('BEGIN');
      append_body   ('   g_rec_njc := nm3get.get_njc (pi_njc_unique => p_njc_unique);');
      append_body   ('   SAVEPOINT top_of_xsp_chk;');
      append_body   ('   nm3extent.create_temp_ne (pi_source_id    => g_rec_njc.njc_route_ne_id');
      append_body   ('                            ,pi_source       => nm3extent.c_route');
      append_body   ('                            ,pi_begin_mp     => g_rec_njc.njc_route_begin_mp+p_begin_mp');
      append_body   ('                            ,pi_end_mp       => g_rec_njc.njc_route_begin_mp+p_end_mp');
      append_body   ('                            ,po_job_id       => l_source_nte_id');
      append_body   ('                            );');
      append_body   ('   l_rec_ngq.ngq_id                 := nm3seq.next_ngq_id_seq;');
      append_body   ('   l_rec_ngq.ngq_source_id          := l_source_nte_id;');
      append_body   ('   l_rec_ngq.ngq_source             := nm3extent.c_temp_ne;');
      append_body   ('   l_rec_ngq.ngq_open_or_closed     := nm3gaz_qry.c_closed_query;');
      append_body   ('   l_rec_ngq.ngq_items_or_area      := nm3gaz_qry.c_area_query;');
      append_body   ('   l_rec_ngq.ngq_query_all_items    := '||nm3flx.string('N')||';');
      append_body   ('   l_rec_ngq.ngq_begin_mp           := Null;');
      append_body   ('   l_rec_ngq.ngq_begin_datum_ne_id  := Null;');
      append_body   ('   l_rec_ngq.ngq_begin_datum_offset := Null;');
      append_body   ('   l_rec_ngq.ngq_end_mp             := Null;');
      append_body   ('   l_rec_ngq.ngq_end_datum_ne_id    := Null;');
      append_body   ('   l_rec_ngq.ngq_end_datum_offset   := Null;');
      append_body   ('   l_rec_ngq.ngq_ambig_sub_class    := Null;');
      append_body   ('   nm3ins.ins_ngq (l_rec_ngq);');
      append_body   ('   l_rec_ngqt.ngqt_ngq_id           := l_rec_ngq.ngq_id;');
      append_body   ('   l_rec_ngqt.ngqt_seq_no           := 1;');
      append_body   ('   l_rec_ngqt.ngqt_item_type_type   := nm3gaz_qry.c_ngqt_item_type_type_inv;');
      append_body   ('   l_rec_ngqt.ngqt_item_type        := stp_rc.get_rc_inv_type;');
      append_body   ('   nm3ins.ins_ngqt(l_rec_ngqt);');
      append_body   ('   l_rec_ngqa.ngqa_ngq_id           := l_rec_ngq.ngq_id;');
      append_body   ('   l_rec_ngqa.ngqa_ngqt_seq_no      := l_rec_ngqt.ngqt_seq_no;');
      append_body   ('   l_rec_ngqa.ngqa_seq_no           := 1;');
      append_body   ('   l_rec_ngqa.ngqa_attrib_name      := '||nm3flx.string('IIT_X_SECT')||';');
      append_body   ('   l_rec_ngqa.ngqa_operator         := '||nm3flx.string('AND')||';');
      append_body   ('   l_rec_ngqa.ngqa_pre_bracket      := Null;');
      append_body   ('   l_rec_ngqa.ngqa_post_bracket     := Null;');
      append_body   ('   l_rec_ngqa.ngqa_condition        := '||nm3flx.string('=')||';');
      append_body   ('   nm3ins.ins_ngqa (l_rec_ngqa);');
      append_body   ('   l_rec_ngqv.ngqv_ngq_id           := l_rec_ngqa.ngqa_ngq_id;');
      append_body   ('   l_rec_ngqv.ngqv_ngqt_seq_no      := l_rec_ngqa.ngqa_ngqt_seq_no;');
      append_body   ('   l_rec_ngqv.ngqv_ngqa_seq_no      := l_rec_ngqa.ngqa_seq_no;');
      append_body   ('   l_rec_ngqv.ngqv_sequence         := 1;');
      append_body   ('   l_rec_ngqv.ngqv_value            := p_xsp;');
      append_body   ('   nm3ins.ins_ngqv (l_rec_ngqv);');
      append_body   ('   l_rec_ngqa.ngqa_ngq_id           := l_rec_ngq.ngq_id;');
      append_body   ('   l_rec_ngqa.ngqa_ngqt_seq_no      := l_rec_ngqt.ngqt_seq_no;');
      append_body   ('   l_rec_ngqa.ngqa_seq_no           := 2;');
      append_body   ('   l_rec_ngqa.ngqa_attrib_name      := UPPER(stp_rc.c_layer_attrib_name);');
      append_body   ('   l_rec_ngqa.ngqa_operator         := '||nm3flx.string('AND')||';');
      append_body   ('   l_rec_ngqa.ngqa_pre_bracket      := Null;');
      append_body   ('   l_rec_ngqa.ngqa_post_bracket     := Null;');
      append_body   ('   l_rec_ngqa.ngqa_condition        := '||nm3flx.string('=')||';');
      append_body   ('   nm3ins.ins_ngqa (l_rec_ngqa);');
      append_body   ('   l_rec_ngqv.ngqv_ngq_id           := l_rec_ngqa.ngqa_ngq_id;');
      append_body   ('   l_rec_ngqv.ngqv_ngqt_seq_no      := l_rec_ngqa.ngqa_ngqt_seq_no;');
      append_body   ('   l_rec_ngqv.ngqv_ngqa_seq_no      := l_rec_ngqa.ngqa_seq_no;');
      append_body   ('   l_rec_ngqv.ngqv_sequence         := 1;');
      append_body   ('   l_rec_ngqv.ngqv_value            := '||nm3flx.string('1')||';');
      append_body   ('   nm3ins.ins_ngqv (l_rec_ngqv);');
      append_body   ('   DECLARE');
      append_body   ('      l_ner EXCEPTION;');
      append_body   ('      PRAGMA EXCEPTION_INIT(l_ner,-20000);');
      append_body   ('   BEGIN');
      append_body   ('      l_result_nte_id := nm3gaz_qry.perform_query');
      append_body   ('                               (pi_ngq_id         => l_rec_ngq.ngq_id');
      append_body   ('                               ,pi_effective_date => g_rec_njc.njc_effective_date');
      append_body   ('                               );');
      append_body   ('   EXCEPTION');
      append_body   ('      WHEN l_ner');
      append_body   ('       THEN');
      append_body   ('         IF hig.check_last_ner (pi_appl => nm3type.c_net');
      append_body   ('                               ,pi_id   => 306');
      append_body   ('                               )');
      append_body   ('          THEN');
      append_body   ('            RAISE not_matched;');
      append_body   ('         ELSE');
      append_body   ('            RAISE;');
      append_body   ('         END IF;');
      append_body   ('   END;');
      append_body   ('   l_extent_match := nm3extent.get_nte_length (l_source_nte_id) = nm3extent.get_nte_length (l_result_nte_id);');
      append_body   ('   ROLLBACK TO top_of_xsp_chk;');
      append_body   ('   IF NOT l_extent_match');
      append_body   ('    THEN');
      append_body   ('      RAISE not_matched;');
      append_body   ('   END IF;');
      append_body   ('   RETURN p_xsp;');
      append_body   ('EXCEPTION');
      append_body   ('   WHEN not_matched');
      append_body   ('    THEN');
      append_body   ('      hig.raise_ner (pi_appl               => nm3type.c_net');
      append_body   ('                    ,pi_id                 => 28');
      append_body   ('                    ,pi_supplementary_info => '||nm3flx.string('XSP not found across entire extent'));
      append_body   ('                    );');
      append_body   ('END check_xsp_exists;');
   --
      append_header_and_body ('--');
      append_header_and_body ('-----------------------------------------------------------------------------');
      append_header_and_body ('--');
   END IF;
--
   append_header_and_body ('END '||c_package_name||';');
--
   nm3ddl.create_object_and_syns (p_object_name  => c_view_name
                                 ,p_tab_ddl_text => l_view
                                 );
   nm3ddl.create_object_and_syns (p_object_name  => c_package_name
                                 ,p_tab_ddl_text => l_header
                                 );
   nm3ddl.execute_tab_varchar    (p_tab_varchar  => l_body);
--
   l_rec_nld := nm3get.get_nld (pi_nld_table_name  => c_view_name
                               ,pi_raise_not_found => FALSE
                               );
   IF l_rec_nld.nld_id IS NULL
    THEN
      l_rec_nld.nld_id                := nm3seq.next_nld_id_seq;
      l_rec_nld.nld_table_name        := c_view_name;
      l_rec_nld.nld_table_short_name  := 'XO'||MOD(l_rec_nld.nld_id,1000);
      l_rec_nld.nld_insert_proc       := c_package_name||'.INS';
      l_rec_nld.nld_validation_proc   := c_package_name||'.VALIDATE';
      nm3ins.ins_nld (p_rec_nld => l_rec_nld);
   END IF;
--
   l_rec_nlf.nlf_unique             := l_rec_nmo.nmo_operation;
   --
   nm3del.del_nlf (pi_nlf_unique      => l_rec_nlf.nlf_unique
                  ,pi_raise_not_found => FALSE
                  );
   l_rec_nlf.nlf_id                 := nm3seq.next_nlf_id_seq;
   l_rec_nlf.nlf_descr              := l_rec_nmo.nmo_descr;
   l_rec_nlf.nlf_path               := hig.get_sysopt('UTLFILEDIR');
   l_rec_nlf.nlf_delimiter          := get_default_delimiter;
   l_rec_nlf.nlf_date_format_mask   := Sys_Context('NM3CORE','USER_DATE_MASK');
   l_rec_nlf.nlf_holding_table      := Null;
   --
   nm3ins.ins_nlf (p_rec_nlf => l_rec_nlf);
--
   l_rec_nlfd.nlfd_nlf_id           := l_rec_nlf.nlf_id;
   l_rec_nlfd.nlfd_nld_id           := l_rec_nld.nld_id;
   l_rec_nlfd.nlfd_seq              := 1;
   --
   nm3ins.ins_nlfd (p_rec_nlfd => l_rec_nlfd);
--
   l_seq_no := 0;
--
   l_prefix := SUBSTR(l_rec_nlf.nlf_unique,1,5)||'_';
--
   FOR cs_rec IN (SELECT *
                   FROM  all_tab_columns
                  WHERE  owner      = Sys_Context('NM3CORE','APPLICATION_OWNER')
                   AND   table_name = c_view_name
                  ORDER BY column_id
                 )
    LOOP
      --
      l_seq_no := l_seq_no + 1;
      --
      IF cs_rec.column_name = 'ADMIN_UNIT'
       THEN
         l_rec_nlfc.nlfc_nlf_id            := l_rec_nlf.nlf_id;
         l_rec_nlfc.nlfc_seq_no            := l_seq_no;
         l_rec_nlfc.nlfc_holding_col       := l_prefix||'ADMIN_UNIT_CODE';
         l_col_name                        := l_rec_nlfc.nlfc_holding_col;
         l_rec_nlfc.nlfc_datatype          := nm3type.c_varchar;
         l_rec_nlfc.nlfc_varchar_size      := 10;
         l_rec_nlfc.nlfc_mandatory         := 'Y';
         l_rec_nlfc.nlfc_date_format_mask  := Null;
         nm3ins.ins_nlfc (p_rec_nlfc => l_rec_nlfc);
         l_seq_no := l_seq_no + 1;
         l_rec_nlfc.nlfc_nlf_id            := l_rec_nlf.nlf_id;
         l_rec_nlfc.nlfc_seq_no            := l_seq_no;
         l_rec_nlfc.nlfc_holding_col       := l_prefix||'ADMIN_TYPE';
         l_rec_nlfc.nlfc_datatype          := nm3type.c_varchar;
         l_rec_nlfc.nlfc_varchar_size      := 4;
         l_rec_nlfc.nlfc_mandatory         := 'Y';
         l_rec_nlfc.nlfc_date_format_mask  := Null;
         nm3ins.ins_nlfc (p_rec_nlfc => l_rec_nlfc);
         l_source_col := 'nm3get.get_nau(pi_nau_unit_code=>'||l_rec_nlf.nlf_unique||'.'||l_col_name||',pi_nau_admin_type=>'||l_rec_nlf.nlf_unique||'.'||l_rec_nlfc.nlfc_holding_col||').nau_admin_unit';
      ELSE
--
         l_rec_nlfc.nlfc_nlf_id            := l_rec_nlf.nlf_id;
         l_rec_nlfc.nlfc_seq_no            := l_seq_no;
         l_rec_nlfc.nlfc_holding_col       := SUBSTR(l_prefix||cs_rec.column_name,1,30);
         l_rec_nlfc.nlfc_datatype          := cs_rec.data_type;
         l_rec_nlfc.nlfc_varchar_size      := nm3flx.i_t_e (cs_rec.data_type=nm3type.c_varchar,cs_rec.data_length,Null);
         l_rec_nlfc.nlfc_mandatory         := nm3flx.i_t_e (cs_rec.nullable='Y','N','Y');
         l_rec_nlfc.nlfc_date_format_mask  := Null;
   --
         FOR i IN 1..l_tab_nod.COUNT
          LOOP
            IF l_tab_nod(i).nod_data_item = cs_rec.column_name
             THEN
               l_rec_nlfc.nlfc_mandatory   := l_tab_nod(i).nod_mandatory;
               EXIT;
            END IF;
         END LOOP;
         --
         nm3ins.ins_nlfc (p_rec_nlfc => l_rec_nlfc);
         IF   cs_rec.column_name = c_xsp
          AND stp_is_licensed
          THEN
            l_source_col := c_package_name||'.check_xsp_exists('||l_rec_nlf.nlf_unique||'.'||l_prefix||'NJC_UNIQUE,'||l_rec_nlf.nlf_unique||'.'||l_rec_nlfc.nlfc_holding_col||','||l_rec_nlf.nlf_unique||'.'||l_prefix||'njo_begin_mp,'||l_rec_nlf.nlf_unique||'.'||l_prefix||'njo_end_mp)';
         ELSE
            l_source_col := l_rec_nlf.nlf_unique||'.'||l_rec_nlfc.nlfc_holding_col;
         END IF;
      END IF;
      --
      UPDATE nm_load_file_col_destinations
       SET   nlcd_source_col = l_source_col
      WHERE  nlcd_nlf_id     = l_rec_nlfd.nlfd_nlf_id
       AND   nlcd_nld_id     = l_rec_nlfd.nlfd_nld_id
       AND   nlcd_dest_col   = cs_rec.column_name;
      --
   END LOOP;
--
   nm3load.create_holding_table (l_rec_nlf.nlf_id);
--
   COMMIT;
--
   nm_debug.proc_end(g_package_name,'build_objects_for_nmo');
--
END build_objects_for_nmo;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_delimiter RETURN nm_load_files.nlf_delimiter%TYPE IS
   CURSOR cs_delim IS
   SELECT nlf_delimiter
    FROM  nm_load_files
   GROUP BY nlf_delimiter
   ORDER BY COUNT(*) DESC;
   l_retval nm_load_files.nlf_delimiter%TYPE;
BEGIN
   OPEN  cs_delim;
   FETCH cs_delim INTO l_retval;
   CLOSE cs_delim;
   l_retval := NVL(l_retval,'|');
   RETURN l_retval;
END get_default_delimiter;
--
-----------------------------------------------------------------------------
--
END nm3job_load;
/
