CREATE OR REPLACE PACKAGE BODY nm3webutil
AS
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3webutil.pkb-arc   2.0   Mar 17 2010 12:04:36   aedwards  $
--       Module Name      : $Workfile:   nm3webutil.pkb  $
--       Date into PVCS   : $Date:   Mar 17 2010 12:04:36  $
--       Date fetched Out : $Modtime:   Feb 23 2010 17:31:36  $
--       Version          : $Revision:   2.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid CONSTANT VARCHAR2(2000) := '$Revision:   2.0  $';

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






END nm3webutil;
/


