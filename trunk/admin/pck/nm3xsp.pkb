CREATE OR REPLACE PACKAGE BODY nm3xsp AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3xsp.pkb-arc   2.2   Jul 04 2013 16:41:22   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3xsp.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:41:22  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:22  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--   Author : Darren Cope
--
--   nm3xsp body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';

  g_package_name CONSTANT varchar2(30) := 'nm3xsp';
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
FUNCTION get_xsp_descr(pi_nsc_nw_type     IN nm_type_subclass.nsc_nw_type%TYPE
                      ,pi_nsc_sub_class   IN nm_type_subclass.nsc_sub_class%TYPE
                      ,pi_xsp             IN nm_nw_xsp.nwx_x_sect%TYPE
                      ,pi_raise_not_found IN boolean) RETURN varchar2 IS

CURSOR get_xsp (pi_nsc_nw_type   IN nm_type_subclass.nsc_nw_type%TYPE
               ,pi_nsc_sub_class IN nm_type_subclass.nsc_sub_class%TYPE
               ,pi_xsp           IN nm_nw_xsp.nwx_x_sect%TYPE) IS
SELECT nwx_descr
FROM   nm_xsp nx
WHERE  nx.nwx_x_sect        = pi_xsp
AND    nx.nwx_nw_type       = pi_nsc_nw_type
AND    nx.nwx_nsc_sub_class = pi_nsc_sub_class;

l_retval nm_nw_xsp.nwx_descr%TYPE;
l_found boolean;
BEGIN
  OPEN get_xsp(pi_nsc_nw_type
              ,pi_nsc_sub_class
              ,pi_xsp);
  FETCH get_xsp INTO l_retval;
  l_found := get_xsp%FOUND;
  CLOSE get_xsp;

  IF NOT l_found AND pi_raise_not_found THEN
    hig.raise_ner (pi_appl               => nm3type.c_hig
                  ,pi_id                 => 67
                  ,pi_sqlcode            => -20000
                  ,pi_supplementary_info => 'nm_xsp'
                                            ||CHR(10)||'nwx_x_sect => '||pi_xsp);
  END IF;
  
  RETURN l_retval;

END get_xsp_descr;
--
-----------------------------------------------------------------------------
--
FUNCTION xsp_is_valid(pi_nsc_nw_type     IN nm_type_subclass.nsc_nw_type%TYPE
                     ,pi_nsc_sub_class   IN nm_type_subclass.nsc_sub_class%TYPE
                     ,pi_xsp             IN nm_nw_xsp.nwx_x_sect%TYPE) RETURN boolean IS

l_xsp_descr nm_nw_xsp.nwx_descr%TYPE;
l_retval boolean;

e_not_found EXCEPTION;
PRAGMA EXCEPTION_INIT(e_not_found, -20000);
BEGIN
  
  BEGIN
    l_xsp_descr := get_xsp_descr(pi_nsc_nw_type     => pi_nsc_nw_type
                                ,pi_nsc_sub_class   => pi_nsc_sub_class
                                ,pi_xsp             => pi_xsp
                                ,pi_raise_not_found => TRUE);
    l_retval := TRUE;
  EXCEPTION
    WHEN e_not_found THEN
      l_retval := FALSE;
  END;

  RETURN l_retval;
END xsp_is_valid;
--
-----------------------------------------------------------------------------
--
FUNCTION xsp_valid_for_ne(pi_ne_id           IN nm_elements.ne_id%TYPE
                         ,pi_xsp             IN nm_nw_xsp.nwx_x_sect%TYPE) RETURN boolean IS
l_ne nm_elements_all%ROWTYPE := nm3get.get_ne(pi_ne_id           => pi_ne_id
                                             ,pi_raise_not_found => TRUE);
BEGIN
  RETURN xsp_is_valid(pi_nsc_nw_type     => l_ne.ne_nt_type
                     ,pi_nsc_sub_class   => l_ne.ne_sub_type
                     ,pi_xsp             => pi_xsp);

END xsp_valid_for_ne;
--
-----------------------------------------------------------------------------
--
END nm3xsp;
/
