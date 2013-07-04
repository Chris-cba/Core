CREATE OR REPLACE PACKAGE BODY nm3webutil
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3webutil.pkb-arc   2.3   Jul 04 2013 16:40:30   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3webutil.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:40:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 16:36:38  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.3  $';

  g_package_name CONSTANT varchar2(30) := 'nm3webutil';
  
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
FUNCTION get_filter (pi_tab_wildcards      IN nm3type.tab_varchar80
                    ,pi_tab_descriptions   IN nm3type.tab_varchar80) RETURN VARCHAR2 IS


 l_retval nm3type.max_varchar2;

BEGIN

  IF pi_tab_wildcards.COUNT = 0 THEN
  
   l_retval := '|*.*|*.*|';
   
  ELSE

      l_retval := '|';
      FOR i IN 1..pi_tab_wildcards.COUNT LOOP
        l_retval := l_retval || NVL(pi_tab_descriptions(i),pi_tab_wildcards(i))||'|'||pi_tab_wildcards(i)||'|' ;
      END LOOP;   
  END IF; 
  
  RETURN(l_Retval);
  
END get_filter;
--
-----------------------------------------------------------------------------
--
FUNCTION get_work_folder RETURN VARCHAR2 IS

BEGIN
    RETURN hig.get_user_or_sys_opt('WORKFOLDER');
END get_work_folder;
--
-----------------------------------------------------------------------------
--
  FUNCTION start_file_on_client ( pi_os  IN VARCHAR2
                                , pi_file IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
    IF UPPER(pi_os) LIKE '%WIN%'
    AND pi_file IS NOT NULL
    THEN
        retval := 'cmd /c ' ||' "'||pi_file||'"' ;
    END IF;
    RETURN retval;
  END start_file_on_client;
--
-----------------------------------------------------------------------------
--
  FUNCTION open_folder_on_client ( pi_os     IN VARCHAR2
                                 , pi_folder IN VARCHAR2 )
    RETURN VARCHAR2
  IS
    retval nm3type.max_varchar2;
  BEGIN
    IF UPPER(pi_os) LIKE '%WIN%'
    AND pi_folder IS NOT NULL
    THEN
        retval := 'explorer ' ||' "'||pi_folder||'"' ;
    END IF;
    RETURN retval;
  END open_folder_on_client;
--
-----------------------------------------------------------------------------
--
END nm3webutil;
/


