CREATE OR REPLACE PACKAGE BODY nm3web_map AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web_map.pkb-arc   2.2   May 17 2011 08:26:28   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3web_map.pkb  $
--       Date into PVCS   : $Date:   May 17 2011 08:26:28  $
--       Date fetched Out : $Modtime:   Apr 04 2011 10:20:54  $
--       PVCS Version     : $Revision:   2.2  $
--       Based on         : 1.4
--
--
--   Author : Jonathan Mills
--
--   show items on map package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.2  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web_map';
--
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'GISWEB0020';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
--
-----------------------------------------------------------------------------
--
PROCEDURE sccs_tags IS
BEGIN
   htp.p('<!--');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('--   SCCS Identifiers :-');
   htp.p('--');
   htp.p('--       sccsid           : @(#)nm3web_map.pkb	1.4 12/01/04');
   htp.p('--       Module Name      : nm3web_map.pkb');
   htp.p('--       Date into SCCS   : 04/12/01 16:25:53');
   htp.p('--       Date fetched Out : 07/06/13 14:13:53');
   htp.p('--       SCCS Version     : 1.4');
   htp.p('--');
   htp.p('--');
   htp.p('--   Author : Jonathan Mills');
   htp.p('--');
   htp.p('--    show items on map');
   htp.p('--');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--	Copyright (c) exor corporation ltd, 2002');
   htp.p('-----------------------------------------------------------------------------');
   htp.p('--');
   htp.p('-->');
END sccs_tags;
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
PROCEDURE define_item_to_show IS
--
   CURSOR cs_gt IS
   SELECT *
    FROM  gis_themes
   WHERE  gt_feature_table     IS NOT NULL
    AND   gt_feature_pk_column IS NOT NULL
   ORDER BY gt_route_theme DESC
           ,gt_theme_name;
--
   TYPE tab_rec_gt IS TABLE OF gis_themes%ROWTYPE INDEX BY BINARY_INTEGER;
   l_tab_rec_gt tab_rec_gt;
--
   l_rec_gt gis_themes%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'define_item_to_show');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   IF get_map_server_sysopt_value IS NULL
    THEN
      Null; -- Won't happen
   END IF;
--
   FOR cs_rec IN cs_gt
    LOOP
      l_tab_rec_gt (cs_gt%ROWCOUNT) := cs_rec;
   END LOOP;
--
   htp.tableopen;
   FOR i IN 1..l_tab_rec_gt.COUNT
    LOOP
      htp.tablerowopen;
      htp.p('<TD>');
      l_rec_gt := l_tab_rec_gt(i);
      htp.p('<TABLE BORDER=1 WIDTH=100%>');
      htp.formopen(g_package_name||'.show_item', cattributes => 'NAME="show_item_'||i||'"');
      htp.tablerowopen;
      htp.tableheader(htf.small(l_rec_gt.gt_theme_name),cattributes=>'COLSPAN=3');
      htp.tablerowclose;
      htp.tablerowopen;
      htp.tabledata(htf.small(REPLACE(l_rec_gt.gt_label_column,'_',' ')));
      htp.p('<TD>');
      htp.formhidden (cname    => 'p_gt_theme_id'
                     ,cvalue   => l_rec_gt.gt_theme_id
                     );
      htp.formtext (cname      => 'p_pk_value'
                   ,cmaxlength => 30
                   ,csize      => 30
                   );
      htp.p('</TD>');
      htp.p('<TD>');
      htp.formsubmit (cvalue=>'Show');
      htp.p('</TD>');
      htp.formclose;
      htp.p('</TABLE>');
      htp.p('</TD>');
      htp.tablerowclose;
   END LOOP;
   htp.tableclose;
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'define_item_to_show');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
   WHEN others
    THEN
      nm3web.failure (SQLERRM);
END define_item_to_show;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_gdo  (p_gt_theme_id    gis_themes.gt_theme_id%TYPE
                    ,p_gdo_session_id gis_data_objects.gdo_session_id%TYPE
                    ) IS
--
   c_this_module  CONSTANT hig_modules.hmo_module%TYPE := 'GISWEB0021';
   c_module_title CONSTANT hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'show_gdo');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('<!-- Hide JS Code from old browsers');
   htp.p('document.write("opening graphic....")');
   htp.p('// -->');
   htp.p('</SCRIPT>');
--
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('<!-- Hide JS Code from old browsers');
   htp.p('   top.location = "'||get_url (p_gt_theme_id    => p_gt_theme_id
                                        ,p_gdo_session_id => p_gdo_session_id
                                        )
                              ||'";'
        );
   htp.p('// -->');
   htp.p('</SCRIPT>');
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'show_gdo');
--
END show_gdo;
--
-----------------------------------------------------------------------------
--
PROCEDURE show_item (p_gt_theme_id    gis_themes.gt_theme_id%TYPE
                    ,p_pk_value       VARCHAR2
                    ) IS
--
   PRAGMA AUTONOMOUS_TRANSACTION;
--
   l_gdo_session_id gis_data_objects.gdo_session_id%TYPE;
--
   l_rec_gt nm_themes_all%ROWTYPE;
   l_url    nm3type.max_varchar2;
--
   l_block  nm3type.max_varchar2;
BEGIN
--
   nm_debug.proc_start(g_package_name,'show_item');
--
   nm3web.head(p_close_head => TRUE
              ,p_title      => c_module_title
              );
--
   sccs_tags;
--
   htp.bodyopen;
--
   nm3web.module_startup(pi_module => c_this_module);
--
   l_rec_gt         := nm3get.get_nth (pi_nth_theme_id => p_gt_theme_id);
--
   l_gdo_session_id := higgis.get_session_id;
--
   g_pk_value       := p_pk_value;
   g_gdo_session_id := l_gdo_session_id;
--
--
-- GJ 01-DEC-2004
-- 695972- Following code causes pop-window to appear - so code removed
--   htp.p('<SCRIPT LANGUAGE="JavaScript">');
--   htp.p('<!-- Hide JS Code from old browsers');
--   htp.p('document.write("<BR>Working.....");');
--   htp.p('document.write("<BR><SMALL>'||to_char(sysdate,nm3type.c_full_date_time_format)||'</SMALL>");');
--   htp.p('// -->');
--   htp.p('</SCRIPT>');
   l_block :=            'BEGIN'
              ||CHR(10)||'INSERT INTO '||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.gis_data_objects'
              ||CHR(10)||'      (gdo_session_id'
              ||CHR(10)||'      ,gdo_pk_id'
              ||CHR(10)||'      ,gdo_rse_he_id'
              ||CHR(10)||'      ,gdo_st_chain'
              ||CHR(10)||'      ,gdo_end_chain'
              ||CHR(10)||'      ,gdo_x_val'
              ||CHR(10)||'      ,gdo_y_val'
              ||CHR(10)||'      ,gdo_theme_name'
              ||CHR(10)||'      ,gdo_feature_id'
              ||CHR(10)||'      ,gdo_xsp'
              ||CHR(10)||'      ,gdo_offset'
              ||CHR(10)||'      )'
              ||CHR(10)||'SELECT '||g_package_name||'.g_gdo_session_id'
              ||CHR(10)||'      ,a.'||l_rec_gt.nth_pk_column
              ||CHR(10)||'      ,a.'||l_rec_gt.nth_rse_fk_column
              ||CHR(10)||'      ,'||nm3flx.i_t_e(l_rec_gt.nth_st_chain_column IS NULL
                                                ,'Null'
                                                ,'a.'||l_rec_gt.nth_st_chain_column
                                                )
              ||CHR(10)||'      ,'||nm3flx.i_t_e(l_rec_gt.nth_end_chain_column IS NULL
                                                ,'Null'
                                                ,'a.'||l_rec_gt.nth_end_chain_column
                                                )
              ||CHR(10)||'      ,'||nm3flx.i_t_e(l_rec_gt.nth_x_column IS NULL
                                                ,'Null'
                                                ,'a.'||l_rec_gt.nth_x_column
                                                )
              ||CHR(10)||'      ,'||nm3flx.i_t_e(l_rec_gt.nth_y_column IS NULL
                                                ,'Null'
                                                ,'a.'||l_rec_gt.nth_y_column
                                                )
              ||CHR(10)||'      ,'||nm3flx.string(l_rec_gt.nth_theme_name)
              ||CHR(10)||'      ,'||'Null'
              ||CHR(10)||'      ,'||nm3flx.i_t_e(l_rec_gt.nth_xsp_column IS NULL
                                                ,'Null'
                                                ,'a.'||l_rec_gt.nth_xsp_column
                                                )
              ||CHR(10)||'      ,'||nm3flx.i_t_e(l_rec_gt.nth_offset_field IS NULL
                                                ,'Null'
                                                ,'a.'||l_rec_gt.nth_offset_field
                                                )
              ||CHR(10)||' FROM  '||l_rec_gt.nth_table_name||' a'
              ||CHR(10)||'      ,'||l_rec_gt.nth_feature_table||' b'
              ||CHR(10)||'WHERE  a.'||l_rec_gt.nth_label_column||' LIKE '||g_package_name||'.g_pk_value||'||nm3flx.string('%')
              ||CHR(10)||' AND   a.'||l_rec_gt.nth_pk_column||' = b.'||l_rec_gt.nth_feature_pk_column||';'
              ||CHR(10)||'END;';
   EXECUTE IMMEDIATE l_block;
--
   l_url := get_url (p_gt_theme_id    => p_gt_theme_id
                    ,p_gdo_session_id => l_gdo_session_id
                    );
--
   COMMIT;
--
-- GJ 01-DEC-2004
-- 695972- Following code causes pop-window to appear - so code removed
--   htp.p('<SCRIPT LANGUAGE="JavaScript">');
--   htp.p('<!-- Hide JS Code from old browsers');
--   htp.p('document.write("<BR>opening graphic....")');
--   htp.p('document.write("<BR><SMALL>'||to_char(sysdate,nm3type.c_full_date_time_format)||'</SMALL>")');
--   htp.p('// -->');
--   htp.p('</SCRIPT>');
--
--
   htp.p('<SCRIPT LANGUAGE="JavaScript">');
   htp.p('<!-- Hide JS Code from old browsers');
   htp.p('   window.open("'||l_url||'", "albert","width=700,height=500,toolbar=no,status=no,menubar=no,location=no,directories=no,resizable=yes");');
   htp.p('   history.go(-1);');
   htp.p('// -->');
   htp.p('</SCRIPT>');
--
--   htp.br;
--   htp.anchor (curl  => l_url
--              ,ctext => p_pk_value
--              );
--
   nm3web.close;
--
   nm_debug.proc_end(g_package_name,'show_item');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      ROLLBACK;
   WHEN others
    THEN
      nm3web.failure (SQLERRM);
END show_item;
--
-----------------------------------------------------------------------------
--
FUNCTION get_map_server_sysopt_value RETURN hig_option_values.hov_id%TYPE IS
--
   l_retval hig_option_values.hov_value%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_map_server_sysopt_value');
--
   l_retval := hig.get_sysopt (c_map_server_sysopt);
--
   IF l_retval IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 163
                    ,pi_supplementary_info => c_map_server_sysopt
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_map_server_sysopt_value');
--
   RETURN l_retval;
--
END get_map_server_sysopt_value;
--
-----------------------------------------------------------------------------
--
FUNCTION get_url (p_gt_theme_id    gis_themes.gt_theme_id%TYPE
                 ,p_gdo_session_id gis_data_objects.gdo_session_id%TYPE
                 ) RETURN VARCHAR2 IS
--
   l_retval    nm3type.max_varchar2;
   l_url_start nm3type.max_varchar2;
--
   l_rec_gt    nm_themes_all%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_url');
--
   l_rec_gt    := nm3get.get_nth (pi_nth_theme_id => p_gt_theme_id);
--
   l_url_start := get_map_server_sysopt_value;
--
   l_retval :=  l_url_start||'?'
              ||'Cmd=WHERE'||CHR(38)||'WLayer='||REPLACE(l_rec_gt.nth_theme_name,' ','%20')||CHR(38)||'WWhere='
              ||l_rec_gt.nth_feature_table||'.'||l_rec_gt.nth_feature_pk_column
              ||'%20IN%20(select%20GDO_PK_ID%20from%20'||Sys_Context('NM3CORE','APPLICATION_OWNER')||'.GIS_DATA_OBJECTS%20Where%20GDO_SESSION_ID='||p_gdo_session_id||')';
--
   nm_debug.proc_end(g_package_name,'get_url');
--
   RETURN l_retval;
--
END get_url;
--
-----------------------------------------------------------------------------
--
END nm3web_map;
/
