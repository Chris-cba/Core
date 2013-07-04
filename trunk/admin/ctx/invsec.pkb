CREATE OR REPLACE PACKAGE BODY invsec AS
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/invsec.pkb-arc   2.4   Jul 04 2013 09:23:56   James.Wadsworth  $
--       Module Name      : $Workfile:   invsec.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:23:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:22:04  $
--       SCCS Version     : $Revision:   2.4  $
--       Based on SCCS Version     : 1.12
--
--
--   Author : Rob Coupe
--
--   Package for implementing context-based security
--
--   NOTES
--      1 - The inv_predicate (which is used on NM_INV_ITEMS) function returns a
--          string which represents a sub-query, that table <STRONG>cannot</STRONG> be used in
--          conjuntion with a CONNECT BY clause
--
------------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------------------------
--
   g_body_sccsid        CONSTANT  varchar2(2000)                    := '"$Revision:   2.4  $"';
--  g_body_sccsid is the SCCS ID for the package body

   g_package_name       CONSTANT  varchar2(30)                      := 'invsec';
--
   c_nit_inv_type       CONSTANT  user_tab_columns.column_name%TYPE := 'nit_inv_type';
   c_itg_inv_type       CONSTANT  user_tab_columns.column_name%TYPE := 'itg_inv_type';
--
----------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------
--
FUNCTION get_inv_string (p_updating     IN boolean
                        ,p_au_col_name  IN varchar2
                        ,p_inv_type_col IN varchar2
                        ) RETURN varchar2 IS
   l_retval varchar2(2000);
BEGIN
--
-- ################################################################################
--
--  Make sure that if this changes that both get_inv_string and is_inv_item_updatable
--   are changed
--
-- ################################################################################
--
-- Make sure the user can see (or update) inventory in the specified admin group
--
   l_retval := 'exists (SELECT 1 '||CHR(10)||
               '         FROM  NM_USER_AUS '||CHR(10)||
               '              ,NM_ADMIN_GROUPS '||CHR(10)||
               '              ,HIG_USERS '||CHR(10)||
               '        WHERE  HUS_USERNAME         = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'') '||CHR(10)||
               '          AND  NUA_USER_ID          = HUS_USER_ID'||CHR(10);
   IF p_updating
    THEN
      l_retval := l_retval||
               '         AND   NUA_MODE             = '||CHR(39)||c_normal_string||CHR(39)||CHR(10);
   END IF;
   l_retval := l_retval||
               '         AND   NUA_ADMIN_UNIT       = NAG_PARENT_ADMIN_UNIT '||CHR(10)||
               '         AND   NAG_CHILD_ADMIN_UNIT = '||p_au_col_name||CHR(10)||
               '       ) '||CHR(10);
--
-- Make sure the user can see (or update) that inventory type
--
   l_retval := l_retval||
               ' AND '||CHR(10)||
               'exists (SELECT 1 '||CHR(10)||
               '         FROM  HIG_USER_ROLES '||CHR(10)||
               '              ,NM_INV_TYPE_ROLES '||CHR(10)||
               '         WHERE ITR_INV_TYPE = '||p_inv_type_col||CHR(10)||
               '          AND  ITR_HRO_ROLE = HUR_ROLE '||CHR(10)||
               '          AND  HUR_USERNAME = Sys_Context(''NM3_SECURITY_CTX'',''USERNAME'')'||CHR(10);
   IF p_updating
    THEN
      l_retval := l_retval||
               '         AND   ITR_MODE             = '||CHR(39)||c_normal_string||CHR(39)||CHR(10);
   END IF;
   l_retval := l_retval||
               '       )';
--
   RETURN l_retval;
--
END get_inv_string;
--
------------------------------------------------------------------------------------
--
FUNCTION is_inv_item_updatable (p_iit_inv_type           IN nm_inv_types.nit_inv_type%TYPE
                               ,p_iit_admin_unit         IN nm_inv_items.iit_admin_unit%TYPE
                               ,pi_unrestricted_override IN boolean DEFAULT TRUE
                               ) RETURN boolean IS
--
   CURSOR cs_updatable (c_iit_inv_type   IN nm_inv_types.nit_inv_type%TYPE
                       ,c_iit_admin_unit IN nm_inv_items.iit_admin_unit%TYPE
                       ,c_mode           IN varchar2
                       ) IS
   SELECT 1
    FROM  dual
   WHERE  EXISTS (SELECT 1
                   FROM  nm_user_aus
                        ,nm_admin_groups
                  WHERE  nua_user_id          = Sys_Context('NM3CORE','USER_ID')
                   AND   nua_mode             = c_mode
                   AND   nua_admin_unit       = nag_parent_admin_unit
                   AND   nag_child_admin_unit = c_iit_admin_unit
                 )
    AND  EXISTS (SELECT 1
                  FROM  hig_user_roles
                       ,nm_inv_type_roles
                  WHERE itr_inv_type = c_iit_inv_type
                   AND  itr_hro_role = hur_role
                   AND  hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
                   AND  itr_mode     = c_mode
                );
--
   l_dummy      binary_integer;
   l_can_update boolean;
--
BEGIN
--
-- ################################################################################
--
--  Make sure that if this changes that both get_inv_string and is_inv_item_updatable
--   are changed
--
-- ################################################################################
--
   IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     AND pi_unrestricted_override
    THEN
      l_can_update := TRUE;
   ELSE
      OPEN  cs_updatable(p_iit_inv_type,p_iit_admin_unit,c_normal_string);
      FETCH cs_updatable INTO l_dummy;
      l_can_update := cs_updatable%FOUND;
      CLOSE cs_updatable;
   END IF;
--
   RETURN l_can_update;
--
END is_inv_item_updatable;
--
------------------------------------------------------------------------------------
--
FUNCTION inv_predicate( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     THEN
       RETURN NULL;
    ELSE
       --
       -- If we are context is restricted then return the string required to
       --  check if the admin_unit and inv_type are valid.
       --
       -- NOTE - This returns a sub-query, therefore this table cannot be used
       --        in conjuntion with a CONNECT BY clause
       --
       RETURN get_inv_string(TRUE,'iit_admin_unit','iit_inv_type');
    END IF;
--
END inv_predicate;
--
------------------------------------------------------------------------------------
--
FUNCTION inv_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     THEN
       RETURN NULL;
    ELSE
       --
       -- If we are context is restricted then return the string required to
       --  check if the admin_unit and inv_type are valid.
       --
       -- NOTE - This returns a sub-query, therefore this table cannot be used
       --        in conjuntion with a CONNECT BY clause
       --
       RETURN get_inv_string(FALSE,'iit_admin_unit','iit_inv_type');
    END IF;
--
END inv_predicate_read;
--
------------------------------------------------------------------------------------
--
FUNCTION inv_type_predicate( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     THEN
       RETURN NULL;
    ELSE
       --
       -- If we are context is restricted then return the string required to
       --  call the chk_inv_types_for_role function
       --
       RETURN c_start_inv_type_string||c_nit_inv_type||c_end_check_string;
    END IF;
--
END inv_type_predicate;
--
------------------------------------------------------------------------------------
--
FUNCTION inv_type_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     THEN
       RETURN NULL;
    ELSE
       --
       -- If we are context is restricted then return the string required to
       --  call the chk_inv_types_for_role function
       --
       RETURN c_start_inv_type_string||c_nit_inv_type||c_end_check_string_read;
    END IF;
--
END inv_type_predicate_read;
--
------------------------------------------------------------------------------------
--
FUNCTION inv_itg_predicate( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     THEN
       RETURN NULL;
    ELSE
       --
       -- If we are context is restricted then return the string required to
       --  call the chk_inv_types_for_role function
       --
       RETURN c_start_inv_type_string||c_itg_inv_type||c_end_check_string;
    END IF;
--
END inv_itg_predicate;
--
------------------------------------------------------------------------------------
--
FUNCTION inv_itg_predicate_read( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     THEN
       RETURN NULL;
    ELSE
       --
       -- If we are context is restricted then return the string required to
       --  call the chk_inv_types_for_role function
       --
       RETURN c_start_inv_type_string||c_itg_inv_type||c_end_check_string_read;
    END IF;
--
END inv_itg_predicate_read;
--
------------------------------------------------------------------------------------
--
FUNCTION chk_inv_type_valid_for_role (p_inv_type IN nm_inv_items.iit_inv_type%TYPE)
  RETURN varchar2 IS
--
   CURSOR cs_inv_type_valid_for_role (p_inv_type nm_inv_items.iit_inv_type%TYPE) IS
   SELECT itr_mode
    FROM  hig_user_roles
         ,nm_inv_type_roles
   WHERE  itr_inv_type = p_inv_type
    AND   itr_hro_role = hur_role
    AND   hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
    ORDER BY itr_mode;
--
-- Assign FALSE to the return value, then if the cursor is %NOTFOUND then
--  FALSE will be returned
--
   l_retval   nm_inv_type_roles.itr_mode%TYPE := c_false_string;
--
BEGIN
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE' and Sys_Context('NM3_SECURITY_CTX','USERNAME') = Sys_Context('NM3_SECURITY_CTX','ACTUAL_USERNAME')
     THEN
       RETURN 'NORMAL';
    END IF;
--
   OPEN  cs_inv_type_valid_for_role (p_inv_type);
   FETCH cs_inv_type_valid_for_role INTO l_retval;
   CLOSE cs_inv_type_valid_for_role;
--
   RETURN l_retval;
--
END chk_inv_type_valid_for_role;
--
------------------------------------------------------------------------------------
--
FUNCTION nic_is_updatable_from_module(pi_category IN nm_inv_categories.nic_category%TYPE
                                     ,pi_module   IN hig_modules.hmo_module%TYPE
                                     ) RETURN boolean IS

  l_updatable nm_inv_category_modules.icm_updatable%TYPE;

BEGIN

  BEGIN
    SELECT
      icm.icm_updatable
    INTO
      l_updatable
    FROM
      nm_inv_category_modules icm
    WHERE
      icm.icm_nic_category = pi_category
    AND
      icm.icm_hmo_module = pi_module;

  EXCEPTION
    WHEN no_data_found
    THEN
      l_updatable := 'N';

  END;

  RETURN l_updatable = 'Y';

END nic_is_updatable_from_module;
--
------------------------------------------------------------------------------------
--
END invsec;
/
