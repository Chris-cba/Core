CREATE OR REPLACE PACKAGE BODY nm3api AS
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/admin/pck/nm3api.pkb-arc   2.2.1.0   Oct 12 2011 11:59:20   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3api.pkb  $
--       Date into PVCS   : $Date:   Oct 12 2011 11:59:20  $
--       Date fetched Out : $Modtime:   Oct 12 2011 11:56:58  $
--       PVCS Version     : $Revision:   2.2.1.0  $
--       Based on SCCS version 1.5: 
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
   g_body_sccsid constant varchar2(30) :='"$Revision:   2.2.1.0  $"';
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
                   ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                   ) RETURN nm_elements.ne_id%TYPE IS
--
   c_eff_date CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
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
                   ,p_effective_date DATE DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
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
Function Get_Effective_Date Return Date
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   Return (To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'));
End Get_Effective_Date;
--
-----------------------------------------------------------------------------
--
Procedure Set_Effective_Date (p_Effective_Date Date)
Is
Begin
  --  This is a backwards compatible version of this procedure/function, since not all products made the required changes in time for 4500.
  --  this shares the same header as the 4400 version but uses 4500 contexts behind the scenes.
  --  this function should not be used for any new development and will be removed in a future release.
   Nm3User.Set_Effective_Date (p_Effective_Date);    
End Set_Effective_Date;

--
-----------------------------------------------------------------------------
--
END nm3api;
/
