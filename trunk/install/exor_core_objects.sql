-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exor_core_objects.sql-arc   3.1   Jul 14 2009 12:04:42   lsorathia  $
--       Module Name      : $Workfile:   exor_core_objects.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 12:04:42  $
--       Date fetched Out : $Modtime:   Jul 14 2009 11:57:56  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 1.1
--       This scripts creates a new package nm3ctx for setting the context variables
-------------------------------------------------------------------------
DECLARE
--
   l_pck      VARCHAR2(4000);
   l_pck_body VARCHAR2(4000);
   l_new_line VARCHAR2(10) := CHR(10) ;
--
BEGIN
--
   l_pck := --'CREATE OR REPLACE PACKAGE nm3ctx AS '                                 ||l_new_line||
            --'--'                                                                   ||l_new_line||
            --'PROCEDURE set_context(p_attribute in varchar2, p_value in varchar2); '||l_new_line||
            --'--'                                                                   ||l_new_line||
            --'END nm3ctx;';   
            'create or replace package nm3ctx'||Chr(10)||
            'AS'||Chr(10)||
            '--<PACKAGE>'||Chr(10)||
            '-------------------------------------------------------------------------'||Chr(10)||
            '--   PVCS Identifiers :-'||Chr(10)||
            '--'||Chr(10)||
            '--       PVCS id          : $Header::'||Chr(10)||
            '--       Module Name      : $Workfile:   exor_core_objects.sql  $'||Chr(10)||
            '--       Date into PVCS   : $Date:   Jul 14 2009 12:04:42  $'||Chr(10)||
            '--       Date fetched Out : $Modtime:   Jul 14 2009 11:57:56  $'||Chr(10)||
            '--       Version          : $Revision:   3.1  $'||Chr(10)||
            '--       Based on SCCS version : '||Chr(10)||
            '-------------------------------------------------------------------------'||Chr(10)||
            '--</PACKAGE>'||Chr(10)||
            '--<GLOBVAR>'||Chr(10)||
            '  -----------'||Chr(10)||
            '  --constants'||Chr(10)||
            '  -----------'||Chr(10)||
            '  --g_sccsid is the SCCS ID for the package'||Chr(10)||
            '  g_sccsid CONSTANT VARCHAR2(2000) := ''$Revision:   3.1  $'';'||Chr(10)||
            '--</GLOBVAR>'||Chr(10)||
            '--'||Chr(10)||
            '-----------------------------------------------------------------------------'||Chr(10)||
            '--'||Chr(10)||
            '--<PROC NAME="GET_VERSION">'||Chr(10)||
            '-- This function returns the current SCCS version'||Chr(10)||
            'FUNCTION get_version RETURN varchar2;'||Chr(10)||
            '--</PROC>'||Chr(10)||
            '--'||Chr(10)||
            '-----------------------------------------------------------------------------'||Chr(10)||
            '--'||Chr(10)||
            '--<PROC NAME="GET_BODY_VERSION">'||Chr(10)||
            '-- This function returns the current SCCS version of the package body'||Chr(10)||
            'FUNCTION get_body_version RETURN varchar2;'||Chr(10)||
            '--</PROC>'||Chr(10)||
            '--'||Chr(10)||
            '-----------------------------------------------------------------------------'||Chr(10)||
            '--'||Chr(10)||
            '--<PROC NAME="set_context">'||Chr(10)||
            '-- This Procedure sets the context variable '||Chr(10)||
            'PROCEDURE set_context(p_attribute in varchar2, p_value in varchar2); '||Chr(10)||
            '--</PROC>'||Chr(10)||
            '--'||Chr(10)||
            '-----------------------------------------------------------------------------'||Chr(10)||
            '--'||Chr(10)||
            '--<PRAGMA>'||Chr(10)||
            '  PRAGMA RESTRICT_REFERENCES(get_version, RNDS, WNPS, WNDS);'||Chr(10)||
            '  PRAGMA RESTRICT_REFERENCES(get_body_version, RNDS, WNPS, WNDS);'||Chr(10)||
            '--</PRAGMA>'||Chr(10)||
            '--'||Chr(10)||
            '-----------------------------------------------------------------------------'||Chr(10)||
            '--'||Chr(10)||
            'END nm3ctx ;';


   EXECUTE IMMEDIATE l_pck;

   l_pck_body := 'CREATE OR REPLACE PACKAGE BODY nm3ctx'||Chr(10)||
                 'AS'||Chr(10)||
                 '-------------------------------------------------------------------------'||Chr(10)||
                 '--   PVCS Identifiers :-'||Chr(10)||
                 '--'||Chr(10)||
                 '--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exor_core_objects.sql-arc   3.1   Jul 14 2009 12:04:42   lsorathia  $'||Chr(10)||
                 '--       Module Name      : $Workfile:   exor_core_objects.sql  $'||Chr(10)||
                 '--       Date into PVCS   : $Date:   Jul 14 2009 12:04:42  $'||Chr(10)||
                 '--       Date fetched Out : $Modtime:   Jul 14 2009 11:57:56  $'||Chr(10)||
                 '--       Version          : $Revision:   3.1  $'||Chr(10)||
                 '--       Based on SCCS version : '||Chr(10)||
                 '-------------------------------------------------------------------------'||Chr(10)||
                 '--'||Chr(10)||
                 '--all global package variables here '||Chr(10)||
                 ' '||Chr(10)||
                 '  -----------'||Chr(10)||
                 '  --constants'||Chr(10)||
                 '  -----------'||Chr(10)||
                 '  --g_body_sccsid is the SCCS ID for the package body'||Chr(10)||
                 '  g_body_sccsid  CONSTANT varchar2(2000) := ''$Revision:   3.1  $'';'||Chr(10)||
                 ' '||Chr(10)||
                 '  g_package_name CONSTANT varchar2(30) := ''nm3ctx'' ; '||Chr(10)||
                 '--'||Chr(10)||
                 '-----------------------------------------------------------------------------'||Chr(10)||
                 '--'||Chr(10)||
                 'FUNCTION get_version RETURN varchar2 IS'||Chr(10)||
                 'BEGIN'||Chr(10)||
                 '   RETURN g_sccsid;'||Chr(10)||
                 'END get_version;'||Chr(10)||
                 '--'||Chr(10)||
                 '-----------------------------------------------------------------------------'||Chr(10)||
                 '--'||Chr(10)||
                 'FUNCTION get_body_version RETURN varchar2 IS'||Chr(10)||
                 'BEGIN'||Chr(10)||
                 '   RETURN g_body_sccsid;'||Chr(10)||
                 'END get_body_version;'||Chr(10)||
                 '--'||Chr(10)||
                 '-----------------------------------------------------------------------------'||Chr(10)||
                 '--'||Chr(10)||
                 'PROCEDURE set_context(p_attribute in varchar2, p_value in varchar2)'||Chr(10)||
                 'IS'                                                                 ||Chr(10)||
                 '--'                                                                 ||Chr(10)||
                 'BEGIN'                                                              ||Chr(10)||
                 '--'                                                                 ||Chr(10)||
                 '   dbms_session.set_context(''NM3SQL'', p_attribute, p_value);'     ||Chr(10)||
                 '--'                                                                 ||Chr(10)||
                 'END set_context;'||Chr(10)||
                 '--'||Chr(10)||
                 '-----------------------------------------------------------------------------'||Chr(10)|| 
                 '--'||Chr(10)||
                 'END nm3ctx;';

   EXECUTE IMMEDIATE l_pck_body;

   -- Create Synonyms and grants to public

   EXECUTE IMMEDIATE 'CREATE OR REPLACE CONTEXT NM3SQL USING NM3CTX' ;
   
   BEGIN
      EXECUTE IMMEDIATE 'CREATE PUBLIC SYNONYM NM3CTX FOR NM3CTX' ;
   EXCEPTION
      WHEN OTHERS THEN
      NULL ;
   END ;

   EXECUTE IMMEDIATE 'GRANT EXECUTE ON NM3CTX TO PUBLIC' ;
   
--
EXCEPTION
   WHEN OTHERS THEN
   dbms_output.put_line(sqlerrm); 
END ;
/
