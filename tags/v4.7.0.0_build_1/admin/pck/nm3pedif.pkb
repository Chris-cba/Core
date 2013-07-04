CREATE OR REPLACE PACKAGE BODY nm3pedif AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3pedif.pkb-arc   2.2   Jul 04 2013 16:21:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3pedif.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:21:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:18  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.5
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 edif file production body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3pedif';
--
   g_tab_lines        nm3type.tab_varchar32767;
   g_tab_temp_lines   nm3type.tab_varchar32767;
--
  fdest          varchar2(80);         -- Input directory name
  --
  v_filename     varchar2(80);       -- Compound filename
  --
  g_startline  CONSTANT varchar2(1000):='1,EDIF , Version: '||g_sccsid||', Created By: '||USER||', Date: ';
  --
--
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
PROCEDURE move_temp_lines_to_main IS
BEGIN
   FOR i IN 1..g_tab_temp_lines.COUNT
    LOOP
      g_tab_lines(g_tab_lines.COUNT+1) := g_tab_temp_lines(i);
   END LOOP;
END move_temp_lines_to_main;
--
-----------------------------------------------------------------------------
--
PROCEDURE record_type_11 IS
--
   CURSOR cs_det IS
   SELECT   '11' -- Record Identifier
          ||','
          ||'D' -- D - DOT
          ||','
          ||nit_inv_type -- Inv Code
          ||','
          ||nit_descr
          ||','
          ||nit_pnt_or_cont
          ||','
          ||nit_x_sect_allow_flag
          ||','
          ||nit_contiguous
          ||','
          ||nig.itg_parent_inv_type
          ||','
          ||nig.itg_relation
     FROM nm_inv_types  nit
         ,nm_inv_type_groupings_all nig
    WHERE nit_table_name IS NULL
    AND   nig.itg_inv_type (+) = nit.nit_inv_type
    ORDER BY nit_inv_type;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'record_type_11');
--
   OPEN  cs_det;
   FETCH cs_det BULK COLLECT INTO g_tab_temp_lines;
   CLOSE cs_det;
   move_temp_lines_to_main;
--
   nm_debug.proc_end(g_package_name,'record_type_11');
--
END record_type_11;
--
-----------------------------------------------------------------------------
--
PROCEDURE record_type_12 IS
--
   CURSOR cs_det IS
   SELECT   '12'
          ||','
          ||'D' -- DOT
          ||','
          ||ita_inv_type
          ||','
          ||ita_disp_seq_no
          ||','
          ||ita_scrn_text
          ||','
          ||DECODE(ita_format,'NUMBER','I','S')
          ||','
          ||DECODE(ita_format,'DATE',11,LEAST(ita_fld_length,255))
          ||','
          ||ita_dec_places
          ||','
          ||ita_min
          ||','
          ||ita_max
          ||','
          ||DECODE(ita_id_domain,NULL,'N','Y')
          ||','
          ||ita_mandatory_yn
          ||','
          ||DECODE(ita_attrib_name, 'IIT_PRIMARY_KEY', 'Y', 'N')
          ||','
          ||DECODE(ita_attrib_name, 'IIT_FOREIGN_KEY', 'Y', 'N')
    FROM  nm_inv_type_attribs
    WHERE ita_inv_type IN (SELECT nit_inv_type FROM nm_inv_types WHERE nit_table_name IS NULL)
    ORDER BY ita_inv_type, ita_disp_seq_no;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'record_type_12');
--
   OPEN  cs_det;
   FETCH cs_det BULK COLLECT INTO g_tab_temp_lines;
   CLOSE cs_det;
   move_temp_lines_to_main;
--
   nm_debug.proc_end(g_package_name,'record_type_12');
--
END record_type_12;
--
-----------------------------------------------------------------------------
--
PROCEDURE record_type_13 IS
--
   CURSOR cs_det IS
   SELECT   '13'
          ||','
          ||'D' -- DOT
          ||','
          ||ita_inv_type
          ||','
          ||ita_disp_seq_no
          ||','
          ||ial_value
          ||','
          ||ial_meaning
    FROM  nm_inv_type_attribs
         ,nm_inv_attri_lookup
    WHERE ita_id_domain = ial_domain
     AND  ita_inv_type IN (SELECT nit_inv_type FROM nm_inv_types WHERE nit_table_name IS NULL)
   ORDER BY ita_inv_type, ita_disp_seq_no, ial_seq;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'record_type_13');
--
   OPEN  cs_det;
   FETCH cs_det BULK COLLECT INTO g_tab_temp_lines;
   CLOSE cs_det;
   move_temp_lines_to_main;
--
   nm_debug.proc_end(g_package_name,'record_type_13');
--
END record_type_13;
--
-----------------------------------------------------------------------------
--
PROCEDURE record_type_14 IS
--
   CURSOR cs_det IS
   SELECT   '14'
          ||','
          ||'D'
          ||','
          ||nwx_nsc_sub_class
          ||','
          ||nwx_x_sect
          ||','
          ||nwx_descr
          ||','
          ||on_cw
    FROM (SELECT DISTINCT nwx_nsc_sub_class
                         ,nwx_x_sect
                         ,nwx_descr
                         ,DECODE(nwx_offset,Null,'Y','N') on_cw
           FROM  nm_xsp
         );
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'record_type_14');
--
   OPEN  cs_det;
   FETCH cs_det BULK COLLECT INTO g_tab_temp_lines;
   CLOSE cs_det;
   move_temp_lines_to_main;
--
   nm_debug.proc_end(g_package_name,'record_type_14');
--
END record_type_14;
--
-----------------------------------------------------------------------------
--
PROCEDURE record_type_15 IS
--
   CURSOR cs_det IS
   SELECT   '15'
          ||','
          ||'D'
          ||','
          ||xsr_scl_class
          ||','
          ||xsr_ity_inv_code
          ||','
          ||xsr_x_sect_value
          ||','
          ||xsr_descr
    FROM (SELECT DISTINCT xsr_ity_inv_code
                         ,xsr_x_sect_value
                         ,xsr_scl_class
                         ,xsr_descr
           FROM  xsp_restraints
          WHERE xsr_ity_inv_code IN (SELECT nit_inv_type FROM nm_inv_types WHERE nit_table_name IS NULL)
         );
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'record_type_15');
--
   OPEN  cs_det;
   FETCH cs_det BULK COLLECT INTO g_tab_temp_lines;
   CLOSE cs_det;
   move_temp_lines_to_main;
--
   nm_debug.proc_end(g_package_name,'record_type_15');
--
END record_type_15;
--
-----------------------------------------------------------------------------
--
PROCEDURE record_type_31 IS
--
   CURSOR cs_det IS
   SELECT   '31'
          ||','
          ||'D'
          ||','
          ||hus_initials
          ||','
          ||hus_name
    FROM  hig_users
   ORDER BY UPPER(hus_name);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'record_type_31');
--
   OPEN  cs_det;
   FETCH cs_det BULK COLLECT INTO g_tab_temp_lines;
   CLOSE cs_det;
   move_temp_lines_to_main;
--
   nm_debug.proc_end(g_package_name,'record_type_31');
--
END record_type_31;
--
-----------------------------------------------------------------------------
--
FUNCTION processpedif RETURN boolean IS
--
BEGIN
  --
  nm_debug.proc_start(g_package_name,'processpedif');
  --
  IF fdest IS NULL
   THEN
     fdest := hig.get_sysopt('UTLFILEDIR');
  END IF;
  
  v_filename := 'surveyp.ped';
  --
--
   g_tab_lines.DELETE;
--
   g_tab_lines(1) := g_startline||TO_CHAR(SYSDATE,'DDMMYYYYHH24MI');
--
   record_type_11;
--
   record_type_12;
--
   record_type_13;
--
   record_type_14;
--
   record_type_15;
--
   record_type_31;
--
   nm3file.write_file (location     => fdest
                      ,filename     => v_filename
                      ,max_linesize => 32767
                      ,all_lines    => g_tab_lines
                      );
  --
  nm_debug.proc_end(g_package_name,'processpedif');
--
   RETURN TRUE;
--
--EXCEPTION
--   WHEN g_pedif_exception
--    THEN
--      RAISE;
--      RETURN FALSE;
--   WHEN OTHERS
--    THEN
--      RAISE;
--      RETURN FALSE;
END processpedif;
--
-----------------------------------------------------------------------------
--
PROCEDURE main IS
BEGIN
  --
  nm_debug.proc_start(g_package_name,'main');
  --
  dbms_output.put_line('Version: '||g_sccsid);
  dbms_output.put_line('.');
  --
  --
  IF NOT processpedif
   THEN
     dbms_output.put_line('Error: Pedif file generation failed - {Main}');
  ELSE
     dbms_output.put_line('Info : The following file has been generated : ');
     dbms_output.put_line('.');
     dbms_output.put_line('Directory : '||fdest);
     dbms_output.put_line('File      : '||v_filename);
  END IF;

  --
  nm_debug.proc_end(g_package_name,'main');
  --
END main;
--
-----------------------------------------------------------------------------
--
END nm3pedif;
/
