CREATE OR REPLACE PACKAGE BODY lb_security
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_security.pkb-arc   1.0   Jan 15 2015 15:01:26   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_security.pkb  $
--       Date into PVCS   : $Date:   Jan 15 2015 15:01:26  $
--       Date fetched Out : $Modtime:   Jan 15 2015 14:59:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   Policy predicates for Location Bridge FGAC security
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_security	';

   qq                        VARCHAR2 (1) := CHR (39);

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

   --
   -----------------------------------------------------------------------------
   --
   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

   --
   -----------------------------------------------------------------------------
   --

   FUNCTION loc_predicate (schema_in VARCHAR2, NAME_IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN get_loc_string;
   END;

   --

   FUNCTION nal_predicate (schema_in VARCHAR2, NAME_IN VARCHAR2)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN get_nal_string;
   END;


   FUNCTION get_loc_string
      RETURN VARCHAR2
   IS
      l_str   VARCHAR2 (4000);
   BEGIN
      IF NVL (SYS_CONTEXT ('NM3CORE', 'UNRESTRICTED_INVENTORY'), 'N') = 'Y'
      THEN
         RETURN NULL;
      ELSE
         l_str :=
               ' exists ( select 1 from lb_types, lb_user_scopes  '
            || ' where nm_obj_type = lb_exor_inv_type  '
            || ' and lb_security_type = '
            || qq
            || 'SCOPE'
            || qq
            || '  and nm_security_id = scope_id  '
            || '  and hus_username = sys_context('
            || qq
            || 'NM3_SECURITY_CTX'
            || qq
            || ', '
            || qq
            || 'USERNAME'
            || qq
            || ' )  '
            || '  union all   '
            || '  select 1 from lb_types, nm_user_aus, nm_admin_groups   '
            || '  where nm_obj_type = lb_exor_inv_type  '
            || '  and lb_security_type in ( '
            || qq
            || 'ADMIN_UNIT'
            || qq
            || ', '
            || qq
            || 'INHERIT'
            || qq
            || ' )  '
            || '  and nm_security_id = nag_child_admin_unit  '
            || '  and nag_parent_admin_unit = nua_admin_unit  '
            || '  and nua_user_id = sys_context('
            || qq
            || 'NM3CORE'
            || qq
            || ', '
            || qq
            || 'USER_ID'
            || qq
            || ' ) '
            || '  union all  '
            || '  select 1 from lb_types   '
            || '  where nm_obj_type = lb_exor_inv_type   '
            || '  and lb_security_type = '
            || qq
            || 'NONE'
            || qq
            || ' )  '
            || ' and exists ( select 1 from lb_types, nm_inv_type_roles, hig_user_roles '
            || ' where lb_exor_inv_type = itr_inv_type '
            || ' and itr_hro_role = hur_role '
            || ' and hur_username = sys_context('
            || qq
            || 'NM3_SECURITY_CTX'
            || qq
            || ', '
            || qq
            || 'USERNAME'
            || qq
            || ' )) ';
         --
         RETURN l_str;
      END IF;
   END;

   FUNCTION get_nal_string
      RETURN VARCHAR2
   IS
      l_str   VARCHAR2 (4000);
   BEGIN
      IF NVL (SYS_CONTEXT ('NM3CORE', 'UNRESTRICTED_INVENTORY'), 'N') = 'Y'
      THEN
         RETURN NULL;
      ELSE
         l_str :=
               ' exists ( select 1 from lb_types, lb_user_scopes  '
            || ' where nal_nit_type = lb_exor_inv_type  '
            || '  and lb_security_type = '
            || qq
            || 'SCOPE'
            || qq
            || '   and nal_security_key = scope_id '
            || '   and hus_username = sys_context('
            || qq
            || 'NM3_SECURITY_CTX'
            || qq
            || ', '
            || qq
            || 'USERNAME'
            || qq
            || ' )  '
            || '   union all '
            || ' select 1 from lb_types, nm_user_aus, nm_admin_groups '
            || '  where nal_nit_type = lb_exor_inv_type  '
            || '  and lb_security_type =  '
            || qq
            || 'ADMIN_UNIT'
            || qq
            || '  and nal_security_key = nag_child_admin_unit '
            || '  and nag_parent_admin_unit = nua_admin_unit '
            || '  and nua_user_id = sys_context('
            || qq
            || 'NM3CORE'
            || qq
            || ', '
            || qq
            || 'USER_ID'
            || qq
            || ' ) '
            || '  union all '
            || '  select 1 from lb_types  '
            || '  where nal_nit_type = lb_exor_inv_type '
            || '  and lb_security_type in ( '
            || qq
            || 'NONE'
            || qq
            || ', '
            || qq
            || 'INHERIT'
            || qq
            || ' )  )'
            || ' and exists ( select 1 from lb_types, nm_inv_type_roles, hig_user_roles '
            || ' where lb_exor_inv_type = itr_inv_type '
            || '  and itr_hro_role = hur_role '
            || '  and hur_username = sys_context('
            || qq
            || 'NM3_SECURITY_CTX'
            || qq
            || ', '
            || qq
            || 'USERNAME'
            || qq
            || ' ))  ';
      END IF;

      RETURN l_str;
   END;
END;