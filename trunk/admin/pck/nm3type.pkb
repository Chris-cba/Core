CREATE OR REPLACE PACKAGE BODY nm3type AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3type.pkb-arc   2.2   Jul 04 2013 16:35:52   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3type.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:35:52  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:20  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.6 
-------------------------------------------------------------------------
--
--   Author : Jonathan Mills
--
--   Types package
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3type';
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
PROCEDURE dump_tab_number (p_tab_number IN tab_number) IS
--
   l_count binary_integer;
--
BEGIN
--
   IF p_tab_number.COUNT > 0
    THEN
      l_count := p_tab_number.first;
      LOOP
         nm_debug.debug(l_count||':'||p_tab_number(l_count));
         l_count := p_tab_number.NEXT(l_count);
         EXIT WHEN l_count IS NULL;
      END LOOP;
   ELSE
      nm_debug.debug('PL/SQL table empty');
   END IF;
--
END dump_tab_number;
--
-----------------------------------------------------------------------------
--
PROCEDURE dump_tab_boolean (p_tab_boolean IN tab_boolean) IS
--
   l_count binary_integer;
--
   l_string varchar2(5);
--
BEGIN
--
   IF p_tab_boolean.COUNT > 0
    THEN
      l_count := p_tab_boolean.first;
      LOOP
         IF p_tab_boolean(l_count)
          THEN
            l_string := 'TRUE';
         ELSE
            l_string := 'FALSE';
         END IF;
         nm_debug.debug(l_count||':'||l_string);
         l_count := p_tab_boolean.NEXT(l_count);
         EXIT WHEN l_count IS NULL;
      END LOOP;
   ELSE
      nm_debug.debug('PL/SQL table empty');
   END IF;
--
END dump_tab_boolean;
--
-----------------------------------------------------------------------------
--
FUNCTION get_constant(pi_constant_name in varchar2)
  RETURN varchar2 IS
  --
  l_workbuff varchar2(200) ;
  --
BEGIN
  --
  execute immediate 'begin :x := '||g_package_name||'.'||pi_constant_name||'; end;'
    using out l_workbuff ;
  --
  return l_workbuff;
  --
EXCEPTION
  when others
   then
      raise_application_error(-20001,sqlerrm||' Unknown package constant '||pi_constant_name);
END get_constant;
--
-----------------------------------------------------------------------------
--
FUNCTION get_default_date_format RETURN varchar2 IS
BEGIN
  RETURN c_default_date_format;
END get_default_date_format;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nvl                 RETURN varchar2 IS
BEGIN
   RETURN c_nvl                ;
END get_nvl                ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_readonly            RETURN varchar2 IS
BEGIN
   RETURN c_readonly           ;
END get_readonly           ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_normal              RETURN varchar2 IS
BEGIN
   RETURN c_normal             ;
END get_normal             ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_true                RETURN varchar2 IS
BEGIN
   RETURN c_true               ;
END get_true               ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_false               RETURN varchar2 IS
BEGIN
   RETURN c_false              ;
END get_false              ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_updating            RETURN varchar2 IS
BEGIN
   RETURN c_updating           ;
END get_updating           ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inserting           RETURN varchar2 IS
BEGIN
   RETURN c_inserting          ;
END get_inserting          ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_deleting            RETURN varchar2 IS
BEGIN
   RETURN c_deleting           ;
END get_deleting           ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_on                  RETURN varchar2 IS
BEGIN
   RETURN c_on                 ;
END get_on                 ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_off                 RETURN varchar2 IS
BEGIN
   RETURN c_off                ;
END get_off                ;
--
-----------------------------------------------------------------------------
--
FUNCTION get_big_date            RETURN date IS
BEGIN
   RETURN c_big_date;
END get_big_date;
--
-----------------------------------------------------------------------------
--
FUNCTION get_yes RETURN varchar2 IS
BEGIN
   RETURN c_yes;
   
END get_yes;
--
-----------------------------------------------------------------------------
--
FUNCTION get_no RETURN varchar2 IS
BEGIN
   RETURN c_no;
   
END get_no;
--
-----------------------------------------------------------------------------
--
FUNCTION get_cancel RETURN varchar2 IS
BEGIN
   RETURN c_cancel;
   
END get_cancel;
--
-----------------------------------------------------------------------------
--
END nm3type;
/
