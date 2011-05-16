CREATE OR REPLACE PACKAGE BODY nm3mrg_security AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg_security.pkb-arc   2.2   May 16 2011 14:45:02   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3mrg_security.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:45:02  $
--       Date fetched Out : $Modtime:   Apr 01 2011 10:09:02  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.9
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   NM3 Merge Security package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
-----------------------------------------------------------------------------
--
-- Dependencies in this package should be kept to an absolute minimum
--  pref NM3CONTEXT only
--
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.2  $';
   g_package_name    CONSTANT varchar2(30)   := 'nm3mrg_security';
--
   c_true            CONSTANT varchar2(4)  := 'TRUE';
   c_false           CONSTANT varchar2(5)  := 'FALSE';
   c_normal          CONSTANT varchar2(6)  := 'NORMAL';
   c_true_string     CONSTANT varchar2(6)  := CHR(39)||c_true||CHR(39);
   c_false_string    CONSTANT varchar2(7)  := CHR(39)||c_false||CHR(39);
   c_normal_string   CONSTANT varchar2(8)  := CHR(39)||c_normal||CHR(39);
--   
   c_mrg_au_type     CONSTANT hig_options.hop_value%TYPE := hig.get_sysopt ('MRGAUTYPE');
--
   CURSOR cs_query_visible (c_nmq_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT 1
    FROM  nm_mrg_query
   WHERE  nmq_id = c_nmq_id;
--
   l_dummy pls_integer;
--
   TYPE tab_varchar8 IS TABLE OF VARCHAR2(8) INDEX BY BINARY_INTEGER;
   TYPE tab_boolean  IS TABLE OF BOOLEAN     INDEX BY BINARY_INTEGER;
   TYPE tab_number   IS TABLE OF NUMBER      INDEX BY BINARY_INTEGER;
--
   g_tab_query_mode       tab_varchar8;
   g_tab_query_executable tab_boolean;
   g_tab_query_updatable  tab_boolean;
   g_tab_results_visible  tab_varchar8;
   g_au_list_retrieved    BOOLEAN := FALSE;
   g_tab_au               tab_number;
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
FUNCTION get_nqt_string (p_update boolean) RETURN varchar2 IS
   --
   l_retval varchar2(2000);
   --
BEGIN
   --
   l_retval := g_package_name||'.get_query_mode(nqt_nmq_id)';
   --
   IF p_update
    THEN
      l_retval := l_retval||' = '||c_normal_string;
   ELSE
      l_retval := l_retval||' != '||c_false_string;
   END IF;
   --
   RETURN l_retval;
   --
END get_nqt_string;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nqt_predicate_read ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
  l_retval varchar2(2000) := NULL;
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'FALSE' 
     THEN
       l_retval := get_nqt_string (FALSE);
    END IF;
--
    RETURN l_retval;
--
END mrg_nqt_predicate_read;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nqt_predicate_update ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
  l_retval varchar2(2000) := NULL;
BEGIN
--
    IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'FALSE' 
     THEN
       l_retval := get_nqt_string (TRUE);
    END IF;
--
    RETURN l_retval;
--
END mrg_nqt_predicate_update;
--
-----------------------------------------------------------------------------
--
FUNCTION get_query_mode (pi_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN varchar2 IS
--
   CURSOR cs_mode (c_nmq_id nm_mrg_query.nmq_id%TYPE
                  ) IS
   SELECT /*+ INDEX (nqro nqro_pk) */ nqro.nqro_mode
    FROM  nm_mrg_query_roles nqro
         ,hig_user_roles     hur
   WHERE  nqro.nqro_nmq_id = c_nmq_id
    AND   nqro.nqro_role   = hur.hur_role
    AND   hur.hur_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
   ORDER BY nqro.nqro_mode;
--
   l_retval nm_mrg_query_roles.nqro_mode%TYPE;
--
BEGIN
--
   IF pi_nmq_id IS NULL
    THEN
      l_retval := c_normal;
   ELSIF g_tab_query_mode.EXISTS(pi_nmq_id)
    THEN
      l_retval := g_tab_query_mode(pi_nmq_id);
   ELSE
--      IF c_user_restricted
--       THEN
         OPEN  cs_mode (pi_nmq_id);
         FETCH cs_mode INTO l_retval;
         IF cs_mode%NOTFOUND
          THEN
            l_retval := c_false;
         END IF;
         CLOSE cs_mode;
--      ELSE
--         -- Unrestricted user - Go for it
--         l_retval := c_normal;
--      END IF;
      g_tab_query_mode(pi_nmq_id) := l_retval;
   END IF;
--
   RETURN l_retval;
--
END get_query_mode;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nmq_string (p_type VARCHAR2) RETURN varchar2 IS
--
   l_retval varchar2(2000) := NULL;
--
   c_update CONSTANT BOOLEAN := p_type = 'U';
   c_delete CONSTANT BOOLEAN := p_type = 'D';
   c_select CONSTANT BOOLEAN := p_type = 'S';
--
BEGIN
--
   l_retval    := g_package_name||'.get_query_mode (nmq_id) ';
--
   IF c_select
    THEN
      l_retval := l_retval||'!= '||c_false_string;
   ELSE
      l_retval := l_retval||'= '||c_normal_string;
   END IF;
--
   IF c_update
    THEN
      l_retval := l_retval||' AND '||g_package_name||'.can_all_types_be_seen_char (nmq_id) = '||c_true_string;
   END IF;
--
   RETURN l_retval;
--
END get_nmq_string;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nmq_predicate_read ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
  l_retval varchar2(2000) := NULL;
BEGIN
--
--   IF c_user_restricted
--    THEN
      l_retval := get_nmq_string('S');
--   END IF;
--
   RETURN l_retval;
--
END mrg_nmq_predicate_read;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nmq_predicate_update ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
  l_retval varchar2(2000) := NULL;
BEGIN
--
--   IF c_user_restricted
--    THEN
      l_retval := get_nmq_string('U');
--   END IF;
--
   RETURN l_retval;
END mrg_nmq_predicate_update;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nmq_predicate_delete ( schema_in varchar2, name_in varchar2) RETURN varchar2 IS
  l_retval varchar2(2000) := NULL;
BEGIN
--
--   IF c_user_restricted
--    THEN
      l_retval := get_nmq_string('D');
--   END IF;
--
   RETURN l_retval;
END mrg_nmq_predicate_delete;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nqr_predicate (schema_in varchar2, name_in varchar2) RETURN varchar2 IS
   l_retval varchar2(2000) := NULL;
BEGIN
--
   IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'FALSE' 
    THEN
      l_retval := 'EXISTS (SELECT 1 FROM nm_mrg_query_executable WHERE nmq_id = nqr_nmq_id)'
       ||CHR(10)||' AND '||g_package_name||'.au_can_be_seen (nqr_admin_unit) = '||c_true_string;
   END IF;
--
   RETURN l_retval;
--
END mrg_nqr_predicate;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nms_predicate (schema_in varchar2, name_in varchar2) RETURN varchar2 IS
   l_retval varchar2(2000) := NULL;
BEGIN
   IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'FALSE' 
    THEN
      l_retval := g_package_name||'.results_can_be_seen (nms_mrg_job_id) = '||c_true_string;
   END IF;
   RETURN l_retval;
END mrg_nms_predicate;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_nsv_predicate (schema_in varchar2, name_in varchar2) RETURN varchar2 IS
   l_retval varchar2(2000) := NULL;
BEGIN
   IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'FALSE' 
    THEN
      l_retval := g_package_name||'.results_can_be_seen (nsv_mrg_job_id) = '||c_true_string;
   END IF;
   RETURN l_retval;
END mrg_nsv_predicate;
--
-----------------------------------------------------------------------------
--
FUNCTION is_query_executable (p_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN boolean IS
--
   l_retval boolean;
--
BEGIN
--
   IF p_nmq_id IS NULL
    THEN
      l_retval := TRUE;
   ELSIF g_tab_query_executable.EXISTS (p_nmq_id)
    THEN
      l_retval := g_tab_query_executable(p_nmq_id);
   ELSE
--      IF c_user_restricted
--       THEN
         OPEN  cs_query_visible (p_nmq_id);
         FETCH cs_query_visible INTO l_dummy;
         l_retval := cs_query_visible%FOUND;
         CLOSE cs_query_visible;
         IF l_retval
          THEN
            l_retval := can_all_types_be_seen (p_nmq_id);
         END IF;
--      ELSE
--         l_retval := TRUE;
--      END IF;
      g_tab_query_executable(p_nmq_id) := l_retval;
   END IF;
--
   RETURN l_retval;
--
END is_query_executable;
--
-----------------------------------------------------------------------------
--
FUNCTION is_query_executable_char (p_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN VARCHAR2 IS
   l_retval VARCHAR2(5);
BEGIN
--
   IF is_query_executable (p_nmq_id)
    THEN
      l_retval := c_true;
   ELSE
      l_retval := c_false;
   END IF;
--
   RETURN l_retval;
--
END is_query_executable_char;
--
-----------------------------------------------------------------------------
--
FUNCTION is_query_updatable (p_nmq_id nm_mrg_query.nmq_id%TYPE) RETURN boolean IS
--
   l_retval boolean;
--
BEGIN
--
   IF p_nmq_id IS NULL
    THEN
      l_retval := TRUE;
   ELSIF g_tab_query_updatable.EXISTS (p_nmq_id)
    THEN
      l_retval := g_tab_query_updatable (p_nmq_id);
   ELSE
--      IF c_user_restricted
--       THEN
   --
         l_retval := (get_query_mode (p_nmq_id) = c_normal);
      --
         IF l_retval
          THEN
            -- If we have NORMAL access via the role
            --  check to make sure we can see all the inventory
            l_retval := can_all_types_be_seen (p_nmq_id);
      --
         END IF;
      --
--      ELSE
--         l_retval := TRUE;
--      END IF;
      g_tab_query_updatable (p_nmq_id) := l_retval;
   END IF;
--
   RETURN l_retval;
--
END is_query_updatable;
--
-----------------------------------------------------------------------------
--
FUNCTION mrg_ndq_predicate (schema_in varchar2, name_in varchar2) RETURN varchar2 IS
--
   l_retval varchar2(2000) := NULL;
--
BEGIN
--
   IF Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'FALSE' 
    THEN
      l_retval := 'EXISTS (SELECT 1 FROM nm_inv_types WHERE nit_inv_type = ndq_inv_type)';
   END IF;
--
   RETURN l_retval;
--
END mrg_ndq_predicate;
--
-----------------------------------------------------------------------------
--
FUNCTION query_has_roles(pi_nmq_id IN nm_mrg_query.nmq_id%TYPE
                        ) RETURN boolean IS
--
   l_retval BOOLEAN;
--
BEGIN
--
   BEGIN
      SELECT 1
       INTO  l_dummy
      FROM   dual
      WHERE EXISTS (SELECT 1
                     FROM  nm_mrg_query_roles
                    WHERE  nqro_nmq_id = pi_nmq_id
                   );
      l_retval := TRUE;
   EXCEPTION
      WHEN no_data_found
       THEN
         l_retval := FALSE;
   END;
--
   RETURN l_retval;
--
END query_has_roles;
--
-----------------------------------------------------------------------------
--
FUNCTION results_can_be_seen (pi_nqr_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE) RETURN VARCHAR2 IS
--
   CURSOR cs_nqr (c_nqr_job_id nm_mrg_query_results.nqr_mrg_job_id%TYPE) IS
   SELECT 1
    FROM  nm_mrg_query_results
   WHERE  nqr_mrg_job_id = c_nqr_job_id;
--
   l_retval VARCHAR2(5);
   l_dummy  PLS_INTEGER;
--
BEGIN
--
   IF pi_nqr_job_id IS NULL
    THEN
      l_retval := c_true;
   ELSIF g_tab_results_visible.EXISTS (pi_nqr_job_id)
    THEN
      l_retval := g_tab_results_visible(pi_nqr_job_id);
   ELSE
      OPEN  cs_nqr (pi_nqr_job_id);
      FETCH cs_nqr INTO l_dummy;
      IF cs_nqr%FOUND
       THEN
         l_retval := c_true;
      ELSE
         l_retval := c_false;
      END IF;
      g_tab_results_visible(pi_nqr_job_id) := l_retval;
   END IF;
--
   RETURN l_retval;
--
END results_can_be_seen;
--
-----------------------------------------------------------------------------
--
FUNCTION au_can_be_seen (pi_nqr_admin_unit nm_mrg_query_results.nqr_admin_unit%TYPE) RETURN VARCHAR2 IS
   l_retval VARCHAR2(5);
   l_tab_au tab_number;
BEGIN
--
   IF NOT g_au_list_retrieved
    THEN
--
      IF c_mrg_au_type IS NOT NULL
       THEN
         SELECT /*+ INDEX (nua nua_pk, nau hau_pk) */ nag.nag_child_admin_unit
          BULK  COLLECT
          INTO  l_tab_au
          FROM  nm_user_aus     nua
               ,nm_admin_groups nag
               ,nm_admin_units  nau
         WHERE  nua.nua_user_id      = To_Number(Sys_Context('NM3CORE','USER_ID'))
          AND   nua.nua_admin_unit   = nag.nag_parent_admin_unit
          AND   nag_child_admin_unit = nau.nau_admin_unit
          AND   nau.nau_admin_type   = c_mrg_au_type;
      ELSE
         SELECT /*+ INDEX (nua nua_pk) */ nag.nag_child_admin_unit
          BULK  COLLECT
          INTO  l_tab_au
          FROM  nm_user_aus     nua
               ,nm_admin_groups nag
         WHERE  nua.nua_user_id    = To_Number(Sys_Context('NM3CORE','USER_ID'))
          AND   nua.nua_admin_unit = nag.nag_parent_admin_unit;
      END IF;
--
      FOR i IN 1..l_tab_au.COUNT
       LOOP
         g_tab_au (l_tab_au(i)) := l_tab_au(i);
      END LOOP;
--
      g_au_list_retrieved := TRUE;
--
   END IF;
--
   IF pi_nqr_admin_unit IS NULL
    THEN
      l_retval := c_true;
   ELSIF g_tab_au.EXISTS (pi_nqr_admin_unit)
    THEN
      l_retval := c_true;
   ELSE
      l_retval := c_false;
   END IF;
--
   RETURN l_retval;
--
END au_can_be_seen;
--
-----------------------------------------------------------------------------
--
PROCEDURE reset_security_state_for_nmq (pi_nmq_id IN nm_mrg_query.nmq_id%TYPE) IS
   l_executable BOOLEAN;
   l_updatable  BOOLEAN;
   l_mode       VARCHAR2(8);
BEGIN
--
   g_tab_query_mode.DELETE(pi_nmq_id);
   g_tab_query_executable.DELETE(pi_nmq_id);
   g_tab_query_updatable.DELETE(pi_nmq_id);
   g_tab_results_visible.DELETE(pi_nmq_id);
--
   l_executable := is_query_executable (pi_nmq_id);
   l_mode       := get_query_mode (pi_nmq_id);
   l_updatable  := is_query_updatable (pi_nmq_id);
--
END reset_security_state_for_nmq;
--
-----------------------------------------------------------------------------
--
PROCEDURE reset_all_security_states IS
BEGIN
   g_tab_query_mode.DELETE;
   g_tab_query_executable.DELETE;
   g_tab_query_updatable.DELETE;
   g_tab_results_visible.DELETE;
END reset_all_security_states;
--
-----------------------------------------------------------------------------
--
FUNCTION can_all_types_be_seen (pi_nmq_id IN nm_mrg_query.nmq_id%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_qry_types (c_nmq_id nm_mrg_query.nmq_id%TYPE) IS
   SELECT /*+ INDEX (nqta nqt_pk) */ 1
    FROM  nm_mrg_query_types_all nqta
   WHERE  nqta.nqt_nmq_id = c_nmq_id
    AND   NOT EXISTS (SELECT 1
                       FROM  nm_mrg_query_types nqt
                      WHERE  nqt.nqt_nmq_id = nqta.nqt_nmq_id
                       AND   nqt.nqt_seq_no = nqta.nqt_seq_no
                     );
--
   l_retval BOOLEAN;
--
BEGIN
--
   OPEN  cs_qry_types (pi_nmq_id);
   FETCH cs_qry_types INTO l_dummy;
   l_retval := cs_qry_types%NOTFOUND;
   CLOSE cs_qry_types;
--
   RETURN l_retval;
--
END can_all_types_be_seen;
--
-----------------------------------------------------------------------------
--
FUNCTION can_all_types_be_seen_char (pi_nmq_id IN nm_mrg_query.nmq_id%TYPE) RETURN VARCHAR2 IS
   l_retval VARCHAR2(5);
BEGIN
   IF can_all_types_be_seen (pi_nmq_id)
    THEN
      l_retval := c_true;
   ELSE
      l_retval := c_false;
   END IF;
   RETURN l_retval;
END can_all_types_be_seen_char;
--
-----------------------------------------------------------------------------
--
END nm3mrg_security;
/
