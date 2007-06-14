CREATE OR REPLACE PACKAGE BODY nm3api AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm3api.pkb	1.5 09/06/02
--       Module Name      : nm3api.pkb
--       Date into SCCS   : 02/09/06 09:08:22
--       Date fetched Out : 07/06/13 14:10:54
--       SCCS Version     : 1.5
--
--
--   Author : Rob Coupe
--
--   API package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3api.pkb	1.5 09/06/02"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3api';
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
FUNCTION get_ne_id (p_ne_unique      nm_elements.ne_unique%TYPE
                   ,p_ne_nt_type     nm_elements.ne_nt_type%TYPE
                   ,p_effective_date DATE DEFAULT nm3user.get_effective_date
                   ) RETURN nm_elements.ne_id%TYPE IS
--
   c_eff_date CONSTANT DATE := nm3user.get_effective_date;
--
   l_retval            nm_elements.ne_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name, 'get_ne_id');
--
   nm3user.set_effective_date (p_effective_date);
--
   l_retval := nm3net.get_ne_id (p_ne_unique  => p_ne_unique
                                ,p_ne_nt_type => p_ne_nt_type
                                );
--
   nm3user.set_effective_date (c_eff_date);
--
   nm_debug.proc_end (g_package_name, 'get_ne_id');
--
   RETURN l_retval;
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_eff_date);
      RAISE;
--
END get_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_ne_id (p_ne_unique      nm_elements.ne_unique%TYPE
                   ,p_effective_date DATE DEFAULT nm3user.get_effective_date
                   ) RETURN nm_elements.ne_id%TYPE IS
BEGIN
   RETURN get_ne_id (p_ne_unique      => p_ne_unique
                    ,p_ne_nt_type     => Null
                    ,p_effective_date => p_effective_date
                    );
END get_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_effective_date RETURN DATE IS
BEGIN
   RETURN nm3user.get_effective_date;
END get_effective_date;
--
-----------------------------------------------------------------------------
--
PROCEDURE set_effective_date (p_effective_date DATE) IS
BEGIN
   nm3user.set_effective_date (p_effective_date);
END set_effective_date;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nau_admin_unit (p_nau_unit_code  IN nm_admin_units_all.nau_unit_code%TYPE
                            ,p_nau_admin_type IN nm_admin_units_all.nau_admin_type%TYPE
                            ) RETURN nm_admin_units_all.nau_admin_unit%TYPE IS
BEGIN
--
   RETURN nm3get.get_nau_all (pi_nau_unit_code  => p_nau_unit_code
                             ,pi_nau_admin_type => p_nau_admin_type
                             ).nau_admin_unit;
--
END get_nau_admin_unit;
--
-----------------------------------------------------------------------------
--
END nm3api;
/
