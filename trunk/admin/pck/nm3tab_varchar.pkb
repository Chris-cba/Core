CREATE OR REPLACE PACKAGE BODY nm3tab_varchar AS
--
-----------------------------------------------------------------------------
--
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/pck/nm3tab_varchar.pkb-arc   2.5   Jul 04 2013 16:33:00   James.Wadsworth  $
-- Module Name : $Workfile:   nm3tab_varchar.pkb  $
-- Date into PVCS : $Date:   Jul 04 2013 16:33:00  $
-- Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
-- PVCS Version : $Revision:   2.5  $
-- Based on SCCS version : 
--
--
--   Author : Jonathan Mills
--
--   NM3 nm3type.tab_varchar32767 manipulation package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.5  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3tab_varchar';
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
FUNCTION split_string_on_lf (p_string VARCHAR2) RETURN nm3type.tab_varchar32767 IS
--
   l_retval    nm3type.tab_varchar32767;
   l_instr_pos PLS_INTEGER     := 1;
   l_string    VARCHAR2(32767) := p_string;
   l_counter   PLS_INTEGER     := 0;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'split_string_on_lf');
--
   LOOP
--
      l_counter   := l_counter + 1;
      l_instr_pos := INSTR(l_string,CHR(10),1,1);
--
      EXIT WHEN NVL(l_instr_pos,0) = 0;
--
      l_retval(l_counter) := SUBSTR(l_string,1,l_instr_pos);
      l_string            := SUBSTR(l_string,l_instr_pos+1);
--
   END LOOP;
--
   -- Write the last one
   IF l_string IS NOT NULL
    THEN
      l_retval(l_counter) := l_string;
   END IF;
--
   nm_debug.proc_end(g_package_name,'split_string_on_lf');
--
   RETURN l_retval;
--
END split_string_on_lf;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tab_varchar (p_tab_vc nm3type.tab_varchar32767) IS
BEGIN
--
   FOR i IN 1..p_tab_vc.COUNT
    LOOP
      nm_debug.debug(p_tab_vc(i));
   END LOOP;
--
END debug_tab_varchar;
--
-----------------------------------------------------------------------------
--
FUNCTION split_rough_chunked_tab_vc_lf (p_tab_vc nm3type.tab_varchar32767
                                       ) RETURN nm3type.tab_varchar32767 IS
--
   l_retval nm3type.tab_varchar32767;
   l_tab_vc nm3type.tab_varchar32767;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'split_rough_chunked_tab_vc_lf');
--
   FOR i IN 1..p_tab_vc.COUNT
    LOOP
      --
      l_tab_vc := split_string_on_lf(p_tab_vc(i));
      --
      append_tab_varchar (p_tab_vc_main      => l_retval
                         ,p_tab_vc_to_append => l_tab_vc
                         );
      --
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'split_rough_chunked_tab_vc_lf');
--
   RETURN l_retval;
--
END split_rough_chunked_tab_vc_lf;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_tab_varchar (p_tab_vc_main      IN OUT NOCOPY nm3type.tab_varchar32767
                             ,p_tab_vc_to_append IN            nm3type.tab_varchar32767
                             ) IS
--
   l_count PLS_INTEGER := p_tab_vc_main.COUNT;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'append_tab_varchar');
--
   FOR i IN 1..p_tab_vc_to_append.COUNT
    LOOP
      l_count                := l_count + 1;
      p_tab_vc_main(l_count) := p_tab_vc_to_append(i);
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'append_tab_varchar');
--
END append_tab_varchar;
--
-----------------------------------------------------------------------------
--
FUNCTION compress_tab_vc_by_lf (p_tab_vc nm3type.tab_varchar32767
                               ) RETURN nm3type.tab_varchar32767 IS
--
   l_retval nm3type.tab_varchar32767;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'compress_tab_vc_by_lf');
--
   FOR i IN 1..p_tab_vc.COUNT
    LOOP
      append (l_retval,p_tab_vc(i),FALSE);
      IF nm3flx.right(p_tab_vc(i),1) = CHR(10)
       THEN
         l_retval(l_retval.COUNT+1) := Null;
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'compress_tab_vc_by_lf');
--
   RETURN l_retval;
--
END compress_tab_vc_by_lf;
--
-----------------------------------------------------------------------------
--
FUNCTION cleanse_tab_vc (pi_tab_vc             IN nm3type.tab_varchar32767
                        ,pi_remove_blank_lines IN BOOLEAN DEFAULT TRUE
                        ,pi_remove_cr          IN BOOLEAN DEFAULT TRUE
                         ) RETURN nm3type.tab_varchar32767 IS
 
     l_retval nm3type.tab_varchar32767;
     
     l_line nm3type.max_varchar2;

  BEGIN

     FOR i IN 1..pi_tab_vc.COUNT
     LOOP

        l_line := pi_tab_vc(i);

        IF pi_remove_cr AND nm3flx.right(l_line,1) = CHR(10) THEN
               l_line := substr(l_line, 1, length(l_line) - 1);
        END IF;


        IF (l_line IS NOT NULL) OR (l_line IS NULL AND pi_remove_blank_lines = FALSE)  THEN
           l_retval(l_retval.count+1) := l_line;
        END IF;           
           
     END LOOP;

     RETURN l_retval;
  

END cleanse_tab_vc;
--
-----------------------------------------------------------------------------
--
PROCEDURE append (p_tab_vc IN OUT NOCOPY nm3type.tab_varchar32767
                 ,p_text   IN            VARCHAR2
                 ,p_nl     IN            BOOLEAN DEFAULT TRUE
                 ) IS
--
   l_counter PLS_INTEGER := p_tab_vc.COUNT;
--
BEGIN
--
   IF p_nl
    THEN
      append (p_tab_vc,CHR(10),FALSE);
   END IF;
--
   IF  l_counter = 0
    OR LENGTH(p_text) + LENGTH(p_tab_vc(l_counter)) > 32767
    THEN
      l_counter := l_counter + 1;
      p_tab_vc(l_counter) := Null;
   END IF;
--
   p_tab_vc(l_counter) := p_tab_vc(l_counter)||p_text;
--
END append;
--
-----------------------------------------------------------------------------
--
END nm3tab_varchar;
/
