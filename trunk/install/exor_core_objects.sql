-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/exor_core_objects.sql-arc   3.0   Jul 14 2009 09:52:34   lsorathia  $
--       Module Name      : $Workfile:   exor_core_objects.sql  $
--       Date into PVCS   : $Date:   Jul 14 2009 09:52:34  $
--       Date fetched Out : $Modtime:   Jul 14 2009 09:26:14  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 1.1
--       This scripts creates a new package nm3ctx for setting the context variables
-------------------------------------------------------------------------
DECLARE
--
   l_pck      VARCHAR2(1000);
   l_pck_body VARCHAR2(4000);
   l_new_line VARCHAR2(10) := CHR(10) ;
--
BEGIN
--
   l_pck := 'CREATE OR REPLACE PACKAGE nm3ctx AS '                                 ||l_new_line||
            '--'                                                                   ||l_new_line||
            'PROCEDURE set_context(p_attribute in varchar2, p_value in varchar2); '||l_new_line||
            '--'                                                                   ||l_new_line||
            'END nm3ctx;';   
   EXECUTE IMMEDIATE l_pck;

   l_pck_body := 'CREATE OR REPLACE PACKAGE BODY nm3ctx '                             ||l_new_line||
                 'AS'                                                                 ||l_new_line||
                 '--'                                                                 ||l_new_line||
                 'PROCEDURE set_context(p_attribute in varchar2, p_value in varchar2)'||l_new_line||
                 'IS'                                                                 ||l_new_line||
                 '--'                                                                 ||l_new_line||
                 'BEGIN'                                                              ||l_new_line||
                 '--'                                                                 ||l_new_line||
                 '   dbms_session.set_context(''NM3SQL'', p_attribute, p_value);'     ||l_new_line||
                 '--'                                                                 ||l_new_line||
                 'END set_context;'                                                   ||l_new_line||
                 '--'                                                                 ||l_new_line||
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
   Null ;
END ;
/
