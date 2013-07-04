CREATE OR REPLACE PACKAGE BODY nm3web_fav AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3web_fav.pkb-arc   2.3   Jul 04 2013 16:35:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3web_fav.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
--       PVCS Version     : $Revision:   2.3  $
--       Based on         : 1.2
--
--
--   Author : Jonathan Mills
--
--   nm3 web favourites package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.3  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3web_fav';
--
   c_this_module       CONSTANT  hig_modules.hmo_module%TYPE := 'NMWEB0004';
   c_this_module_title CONSTANT  hig_modules.hmo_title%TYPE  := hig.get_module_title(c_this_module);
--
   c_folder_link CONSTANT VARCHAR2(100) := Null; -- 'nm3web.empty_frame';
--
   c_download_link CONSTANT VARCHAR2(100) := nm3web.get_download_url(null);
--
   c_web           CONSTANT hig_modules.hmo_module_type%TYPE := 'WEB';
   c_url           CONSTANT hig_modules.hmo_module_type%TYPE := 'URL';
--
   c_fav_type_folder CONSTANT VARCHAR2(1) := 'F';
   c_fav_type_module CONSTANT VARCHAR2(1) := 'M';
--
   c_y               CONSTANT VARCHAR2(1) := 'Y';
   c_n               CONSTANT VARCHAR2(1) := 'N';
--
-----------------------------------------------------------------------------
--
PROCEDURE append_faves (p_tab_type   nm3type.tab_varchar4
                       ,p_tab_child  nm3type.tab_varchar30
                       ,p_tab_parent nm3type.tab_varchar30
                       ,p_tab_descr  nm3type.tab_varchar2000
                       ,p_tab_level  nm3type.tab_number
                       );
--
-----------------------------------------------------------------------------
--
FUNCTION escape_it (p_text VARCHAR2) RETURN VARCHAR2;
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
PROCEDURE show_favourites IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'show_favourites');
--
   nm3web.module_startup(c_this_module);
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_this_module_title
               );
--
   htp.p('<FRAMESET cols="200,*"> ');
   htp.p('  <FRAME src="'||g_package_name||'.left_frame" name="treeframe" > ');
   htp.p('  <FRAME SRC="nm3web.empty_frame" name="basefrm"> ');
   htp.p('</FRAMESET>');
   htp.htmlclose;
--
   nm_debug.proc_end(g_package_name,'show_favourites');
--
EXCEPTION
   WHEN nm3web.g_you_should_not_be_here
    THEN
      NULL;
   WHEN others
    THEN
      nm3web.failure(SQLERRM);
END show_favourites;
--
-----------------------------------------------------------------------------
--
PROCEDURE left_frame IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'left_frame');
--
   nm3web.module_startup(c_this_module);
--
   nm3web.head (p_close_head => FALSE
               ,p_title      => c_this_module_title
               );
   htp.p('');
   htp.p('');
   htp.p('<!-- NO CHANGES PAST THIS LINE -->');
   htp.p('');
   htp.p('');
   htp.p('<!-- Code for browser detection -->');
   htp.p('<script src="'||c_download_link||'ua.js"></script>');
   htp.p('');
   htp.p('<!-- Infrastructure code for the tree -->');
   htp.p('<script src="'||c_download_link||'ftiens4.js"></script>');
   htp.p('');
   htp.p('<!-- Execution of the code that actually builds the specific tree.');
   htp.p('     The variable foldersTree creates its structure with calls to');
   htp.p('	 gFld, insFld, and insDoc -->');
   htp.p('<script src="'||g_package_name||'.define_tree_favourites"></script>');

   htp.p('');
   htp.p('</head>');
   htp.p('');
   htp.p('<body topmargin=16 marginheight=16>');
   htp.p('');
   htp.p('<!-- Removing this link will make the script stop working -->');
 --  htp.p('<div style="position:absolute; top:0; left:0; "><table border=0><tr><td><font size=-2><a style="font-size:6pt;text-decoration:none;color:gray" href=http://www.mmartins.com target=_top></a></font></td></table></div>');
   htp.p('<div style="position:absolute; top:0; left:0; "><table border=0><tr><td><font size=-5><a style="font-size:1pt;text-decoration:none;color:gray" href="http://www.mmartins.com" target=_top></a></font></td></table></div>');
   htp.p('');
   htp.p('<!-- Build the browsers objects and display default view of the');
   htp.p('     tree. -->');
   htp.p('<script>initializeDocument()</script>');
   htp.p('');
   htp.p('</html>');


   nm_debug.proc_end(g_package_name,'left_frame');
--
END left_frame;
--
-----------------------------------------------------------------------------
--
FUNCTION allowable_web_form (p_type   VARCHAR2
                            ,p_module VARCHAR2
                            ) RETURN VARCHAR2 IS
   l_retval VARCHAR2(1);
   CURSOR cs_hmo (c_module VARCHAR2) IS
   SELECT DECODE(hmo_module_type
                ,c_web,c_y
                ,c_url,c_y
                ,c_n
                )
    FROM  hig_modules
   WHERE  hmo_module = c_module;
BEGIN
   IF p_type = c_fav_type_folder
    THEN
      l_retval := c_y;
   ELSIF p_type = c_fav_type_module
    AND  p_module = c_this_module
    THEN
      l_retval := c_n;
   ELSE
      IF nm3user.user_can_run_module (p_module)
       THEN
        OPEN  cs_hmo(p_module);
        FETCH cs_hmo INTO l_retval;
        CLOSE cs_hmo;
      ELSE
        l_retval := c_n;
      END IF;
   END IF;
   RETURN l_retval;
END allowable_web_form;
--
-----------------------------------------------------------------------------
--
PROCEDURE define_tree_favourites IS
--
   CURSOR cs_products IS
   SELECT hpr_product
         ,hpr_product_name
    FROM  hig_products
   WHERE EXISTS (SELECT 1
                  FROM  hig_modules
                       ,hig_module_roles
                       ,hig_user_roles
                 WHERE  hmo_application       = hpr_product
                  AND   hmo_module_type       = c_web
                  AND   hmo_module            = hmr_module
                  AND   hur_role              = hmr_role
                  AND   hur_username          = Sys_Context('NM3_SECURITY_CTX','USERNAME')
                  AND   hmo_fastpath_invalid != c_y
                  AND   hmo_module           != c_this_module
                )
   ORDER BY hpr_sequence;
--
   CURSOR cs_modules (c_app VARCHAR2) IS
   SELECT hmo_module
         ,hmo_title
    FROM  hig_modules
         ,hig_module_roles
         ,hig_user_roles
   WHERE  hmo_application       = c_app
    AND   hmo_module_type       = c_web
    AND   hmo_fastpath_invalid != c_y
    AND   hmo_module           != c_this_module
    AND   hmo_module            = hmr_module
    AND   hur_role              = hmr_role
    AND   hur_username          = Sys_Context('NM3_SECURITY_CTX','USERNAME')
   GROUP BY hmo_title
           ,hmo_module;
--
   l_tab_hmo_type    nm3type.tab_varchar4;
   l_tab_hmo_child   nm3type.tab_varchar30;
   l_tab_hmo_parent  nm3type.tab_varchar30;
   l_tab_hmo_descr   nm3type.tab_varchar2000;
   l_tab_hmo_level   nm3type.tab_number;
--
   l_count  PLS_INTEGER := 0;
--
   c_launchpad VARCHAR2(23) := 'Launchpad (web modules)';
--
   l_tab_initial_state nm3type.tab_number;
   l_tab_depth         nm3type.tab_number;
   l_tab_label         nm3type.tab_varchar80;
   l_tab_icon          nm3type.tab_varchar30;
   l_tab_data          nm3type.tab_varchar30;
   l_tab_parent        nm3type.tab_varchar30;
--
   PROCEDURE append_it IS
      l_tab_fav_type   nm3type.tab_varchar4;
      l_tab_fav_child  nm3type.tab_varchar30;
      l_tab_fav_parent nm3type.tab_varchar30;
      l_tab_fav_descr  nm3type.tab_varchar2000;
      l_tab_fav_level  nm3type.tab_number;
      c                PLS_INTEGER;
      l_add            BOOLEAN;
      l_is_module      BOOLEAN;
   BEGIN
      FOR i IN 1..l_tab_initial_state.COUNT
       LOOP
         l_is_module := l_tab_icon(i) = 'exormini';
         IF l_is_module
          THEN
            l_add := nm3get.get_hmo (pi_hmo_module      => l_tab_data(i)
                                    ,pi_raise_not_found => FALSE
                                    ).hmo_module_type IN (c_web,c_url);
         ELSE
            l_add := TRUE;
         END IF;
         IF l_add
          THEN
            c := l_tab_fav_type.COUNT+1;
            l_tab_fav_type(c)   := nm3flx.i_t_e(l_is_module
                                               ,c_fav_type_module
                                               ,c_fav_type_folder
                                               );
            l_tab_fav_child(c)  := l_tab_data(i);
            l_tab_fav_parent(c) := l_tab_parent(i);
            l_tab_fav_descr(c)  := l_tab_label(i);
            l_tab_fav_level(c)  := l_tab_depth(i);
         END IF;
      END LOOP;
      append_faves (p_tab_type   => l_tab_fav_type
                   ,p_tab_child  => l_tab_fav_child
                   ,p_tab_parent => l_tab_fav_parent
                   ,p_tab_descr  => l_tab_fav_descr
                   ,p_tab_level  => l_tab_fav_level
                   );
   END append_it;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'define_tree_favourites');
--
--   htp.p('// You can find instructions for this file here:');
--   htp.p('// http://www.mmartins.com');
--   htp.p('');
--   htp.p('');
   htp.p('// Decide if the names are links or just the icons');
   htp.p('USETEXTLINKS = 1  //replace 0 with 1 for hyperlinks');
--   htp.p('');
   htp.p('// Decide if the tree is to start all open or just showing the root folders');
   htp.p('STARTALLOPEN = 0 //replace 0 with 1 to show the whole tree');
--   htp.p('');
   htp.p('foldersTree = gFld("<FONT SIZE=-1>Favourites</FONT>", "'||c_folder_link||'")');
--
   higfav.get_hstf_for_tree (po_tab_initial_state => l_tab_initial_state
                            ,po_tab_depth         => l_tab_depth
                            ,po_tab_label         => l_tab_label
                            ,po_tab_icon          => l_tab_icon
                            ,po_tab_data          => l_tab_data
                            ,po_tab_parent        => l_tab_parent
                            );
   append_it;
   higfav.get_hsf_for_tree  (po_tab_initial_state => l_tab_initial_state
                            ,po_tab_depth         => l_tab_depth
                            ,po_tab_label         => l_tab_label
                            ,po_tab_icon          => l_tab_icon
                            ,po_tab_data          => l_tab_data
                            ,po_tab_parent        => l_tab_parent
                            );
   append_it;
   higfav.get_huf_for_tree  (po_tab_initial_state => l_tab_initial_state
                            ,po_tab_depth         => l_tab_depth
                            ,po_tab_label         => l_tab_label
                            ,po_tab_icon          => l_tab_icon
                            ,po_tab_data          => l_tab_data
                            ,po_tab_parent        => l_tab_parent
                            );
   append_it;
--
   l_count := l_count + 1;
   l_tab_hmo_type(l_count)   := c_fav_type_folder;
   l_tab_hmo_child(l_count)  := c_launchpad;
   l_tab_hmo_parent(l_count) := Null;
   l_tab_hmo_descr(l_count)  := c_launchpad;
   l_tab_hmo_level(l_count)  := 1;
   FOR cs_rec IN cs_products
    LOOP
      l_count := l_count + 1;
      l_tab_hmo_type(l_count)   := c_fav_type_folder;
      l_tab_hmo_child(l_count)  := cs_rec.hpr_product;
      l_tab_hmo_parent(l_count) := c_launchpad;
      l_tab_hmo_descr(l_count)  := cs_rec.hpr_product_name;
      l_tab_hmo_level(l_count)  := 2;
      FOR cs_inner IN cs_modules (cs_rec.hpr_product)
       LOOP
         l_count := l_count + 1;
         l_tab_hmo_type(l_count)   := c_fav_type_module;
         l_tab_hmo_child(l_count)  := cs_inner.hmo_module;
         l_tab_hmo_parent(l_count) := cs_rec.hpr_product;
         l_tab_hmo_descr(l_count)  := cs_inner.hmo_title;
         l_tab_hmo_level(l_count)  := 3;
      END LOOP;
   END LOOP;
--
   append_faves (p_tab_type   => l_tab_hmo_type
                ,p_tab_child  => l_tab_hmo_child
                ,p_tab_parent => l_tab_hmo_parent
                ,p_tab_descr  => l_tab_hmo_descr
                ,p_tab_level  => l_tab_hmo_level
                );
--
   nm_debug.proc_end(g_package_name,'define_tree_favourites');
--
END define_tree_favourites;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_faves (p_tab_type   nm3type.tab_varchar4
                       ,p_tab_child  nm3type.tab_varchar30
                       ,p_tab_parent nm3type.tab_varchar30
                       ,p_tab_descr  nm3type.tab_varchar2000
                       ,p_tab_level  nm3type.tab_number
                       ) IS
--
   l_parent      VARCHAR2(30);
   l_prev_parent VARCHAR2(30) := nm3type.c_nvl;
   l_folder      VARCHAR2(30);
   l_prev_folder VARCHAR2(30) := nm3type.c_nvl;
--
   l_lpad        VARCHAR2(30);
--
   l_tab_vc nm3type.tab_varchar32767;
--
   l_url    nm3type.max_varchar2;
--
   c_level_name CONSTANT VARCHAR2(30) := 'fld_lev';
--
   FUNCTION is_childless (p_i PLS_INTEGER) RETURN BOOLEAN IS
      l_retval BOOLEAN;
   BEGIN
      IF NOT p_tab_parent.EXISTS(p_i+1)
       THEN
         l_retval := TRUE;
      ELSE
         l_retval := NOT (p_tab_parent(p_i+1) = p_tab_child(p_i));
      END IF;
      RETURN l_retval;
   END is_childless;
--
   FUNCTION font_it (p_text VARCHAR2) RETURN VARCHAR2 IS
   BEGIN
      RETURN '<FONT SIZE=-1>'||escape_it(p_text)||'</FONT>';
   END font_it;
--
BEGIN
   FOR i IN 1..p_tab_level.COUNT
    LOOP
      l_lpad := RPAD(' ',(p_tab_level(i)*3),' ');
      IF p_tab_level(i) = 1
       THEN
         l_parent := 'foldersTree';
      ELSE
         l_parent := c_level_name||ltrim(to_char(p_tab_level(i)-1),' ');
      END IF;
      IF p_tab_type(i) = c_fav_type_folder
       THEN
         l_folder := c_level_name||ltrim(to_char(p_tab_level(i)),' ');
         IF l_folder = l_prev_folder
          THEN
            l_tab_vc.DELETE(l_tab_vc.COUNT);
         END IF;
         IF NOT is_childless(i)
          THEN
            l_tab_vc(l_tab_vc.COUNT+1) := l_lpad||l_folder||' = insFld('||l_parent||', gFld("'||font_it(p_tab_descr(i))||'", "'||c_folder_link||'"))';
            l_prev_folder := l_folder;
         END IF;
      ELSE
         l_url := NVL(nm3get.get_hum (pi_hum_hmo_module  => p_tab_child(i)
                                     ,pi_raise_not_found => FALSE
                                     ).hum_url
                     ,'nm3web.run_module?pi_module='||p_tab_child(i)
                     );
         l_tab_vc(l_tab_vc.COUNT+1) := l_lpad||'insDoc('||l_parent||', gLnk(0, "'||font_it(p_tab_descr(i))||'", "'||l_url||'"))';
         l_prev_folder := nm3type.c_nvl;
      END IF;
      l_prev_parent := l_parent;
   END LOOP;
   nm3web.htp_tab_varchar(l_tab_vc);
END append_faves;
--
-----------------------------------------------------------------------------
--
FUNCTION escape_it (p_text VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   RETURN nm3web.replace_chevrons(REPLACE(p_text
                                         ,'"'
                                         ,nm3web.get_escape_char('"')
                                         )
                                 );
END escape_it;
--
-----------------------------------------------------------------------------
--
END nm3web_fav;
/
