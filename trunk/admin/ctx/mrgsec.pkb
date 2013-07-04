create or replace package body mrgsec as
--
----------------------------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/mrgsec.pkb-arc   2.1   Jul 04 2013 09:23:56   James.Wadsworth  $
--       Module Name      : $Workfile:   mrgsec.pkb  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:23:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:22:04  $
--       SCCS Version     : $Revision:   2.1  $
--       Based on SCCS Version     : 1.10
--
--
--   Author : Jonathan Mills
--
--   Package for implementing context-based security for Merge (Slice+Dice) Process
--
------------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------------------------
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.1  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
    c_user_restricted CONSTANT BOOLEAN := (NOT nm3user.is_user_unrestricted);
    c_user            CONSTANT VARCHAR2(30) := USER;
--
   c_true_string CONSTANT VARCHAR2(30) := nm3flx.string(nm3type.c_true);
--
   g_pub_user     VARCHAR2(30);
   g_pub_user_det VARCHAR2(2000);
--
------------------------------------------------------------------------------------
--
FUNCTION build_nmq_string (p_nmq_id_field VARCHAR2
                          ,p_select_only  BOOLEAN
                          ) RETURN VARCHAR2;
--
------------------------------------------------------------------------------------
--
FUNCTION build_nqr_string (p_nmq_id_field VARCHAR2
                          ,p_select_only  BOOLEAN
                          ) RETURN VARCHAR2;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_updatable (p_nmq_id_col VARCHAR2) RETURN VARCHAR2;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_selectable (p_nmq_id_col VARCHAR2) RETURN VARCHAR2;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_updatable_for_user (p_nmq_id NUMBER
                                ,p_user   VARCHAR2
                                ) RETURN BOOLEAN;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_results_exists (p_nmq_id NUMBER) RETURN BOOLEAN;
--
------------------------------------------------------------------------------------
--
function get_version return varchar2 is
begin
  return g_sccsid;
end get_version;
--
------------------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_updatable (p_nmq_id_col VARCHAR2) RETURN VARCHAR2 IS
BEGIN
--
   RETURN 'mrgsec.is_query_updatable('||p_nmq_id_col||') = '||c_true_string;
--
END qry_updatable;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_selectable (p_nmq_id_col VARCHAR2) RETURN VARCHAR2 IS
BEGIN
--
   RETURN 'EXISTS (SELECT 1 FROM nm_mrg_query WHERE nmq_id = '||p_nmq_id_col||')';
--
END;
--
-----------------------------------------------------------------------------
--
function mrg_nqt_predicate( schema_in varchar2, name_in varchar2) return varchar2 is
  l_retval varchar2(2000) := Null;
begin
--
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required to
       --  call the chk_inv_types_for_role function
       --
       l_retval := mrg_nqt_predicate_read (schema_in, name_in)||CHR(10)
                   ||' AND '||qry_updatable('nqt_nmq_id');
    END IF;
--
    return l_retval;
--
END mrg_nqt_predicate;
--
-----------------------------------------------------------------------------
--
function mrg_nqt_predicate_read ( schema_in varchar2, name_in varchar2) return varchar2 is
  l_retval varchar2(2000) := Null;
begin
--
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required to
       --  call the chk_inv_types_for_role function
       --
       l_retval := invsec.c_start_inv_type_string||'nqt_inv_type'||invsec.c_end_check_string_read;
    END IF;
--
    return l_retval;
--
END mrg_nqt_predicate_read;
--
------------------------------------------------------------------------------------
--
FUNCTION build_nmq_string (p_nmq_id_field VARCHAR2
                          ,p_select_only  BOOLEAN
                          ) RETURN VARCHAR2 IS
--
   l_retval varchar2(2000);
--
BEGIN
--
   l_retval := 'EXISTS (SELECT 1'||CHR(10)||
               '         FROM  nm_mrg_query_users'||CHR(10)||
               '        WHERE  nqu_nmq_id = '||p_nmq_id_field||CHR(10)||
               '         AND   DECODE(nqu_username,'||CHR(39)||'PUBLIC'||CHR(39)||',user,nqu_username) = '||nm3flx.string(c_user);
--
   IF NOT p_select_only
    THEN
      l_retval := l_retval||CHR(10)||
               '         AND   nqu_mode_allowed = '||CHR(39)||nm3type.c_normal||CHR(39);
   END IF;
--
   l_retval := l_retval||CHR(10)||
               '       )';
--
    return l_retval;
--
END build_nmq_string;
--
------------------------------------------------------------------------------------
--
function mrg_nmq_predicate( schema_in varchar2, name_in varchar2) return varchar2 is
  l_retval varchar2(2000) := Null;
begin
--
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       l_retval := build_nmq_string('nmq_id',FALSE);
    END IF;
--
    return l_retval;
--
END mrg_nmq_predicate;
--
------------------------------------------------------------------------------------
--
function mrg_nmq_predicate_read( schema_in varchar2, name_in varchar2) return varchar2 is
  l_retval varchar2(2000) := Null;
begin
--
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       l_retval := build_nmq_string('nmq_id',TRUE);
    END IF;
--
    return l_retval;
--
END mrg_nmq_predicate_read;
--
------------------------------------------------------------------------------------
--
FUNCTION build_nqr_string (p_nmq_id_field VARCHAR2
                          ,p_select_only  BOOLEAN
                          ) RETURN VARCHAR2 IS
   l_retval VARCHAR2(2000);
BEGIN
   -- Can we see the Query
   -- Can we see all of the inv types in the query
   IF NOT p_select_only
    THEN
      l_retval := build_nmq_string('nqr_nmq_id',p_select_only)||
                  'AND ';
   END IF;
--
   l_retval := l_retval||CHR(10)||
               '0 = (SELECT COUNT(*)-nmq_inv_type_x_sect_count'||CHR(10)||
               '      FROM  nm_mrg_query_types'||CHR(10)||
               '           ,nm_mrg_query'||CHR(10)||
               '     WHERE  nmq_id     = nqr_nmq_id'||CHR(10)||
               '      AND   nqt_nmq_id = nmq_id'||CHR(10)||
               '     GROUP BY nmq_inv_type_x_sect_count'||CHR(10)||
               '    )';
--
    return l_retval;
--
END build_nqr_string;
--
------------------------------------------------------------------------------------
--
function mrg_nqr_predicate( schema_in varchar2, name_in varchar2) return varchar2 is
  l_retval varchar2(2000) := Null;
begin
--
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       l_retval := build_nqr_string('nqr_nmq_id',FALSE);
    END IF;
--
    return l_retval;
--
END mrg_nqr_predicate;
--
------------------------------------------------------------------------------------
--
function mrg_nqr_predicate_read( schema_in varchar2, name_in varchar2) return varchar2 is
  l_retval varchar2(2000) := Null;
begin
--
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       l_retval := build_nqr_string('nqr_nmq_id',TRUE);
    END IF;
--
    return l_retval;
--
END mrg_nqr_predicate_read;
--
------------------------------------------------------------------------------------------------
--
function mrg_nqr_predicate_ui( schema_in varchar2, name_in varchar2) return varchar2 IS
BEGIN
   IF NOT c_user_restricted
    THEN
      RETURN Null;
   ELSE
      RETURN 'mrgsec.execute_query_allowed_string(nqr_nmq_id)='||c_true_string;
   END IF;
END mrg_nqr_predicate_ui;
--
------------------------------------------------------------------------------------------------
--
function mrg_nqr_predicate_del( schema_in varchar2, name_in varchar2) return varchar2 IS
BEGIN
   IF NOT c_user_restricted
    THEN
      RETURN Null;
   ELSE
      RETURN 'mrgsec.are_query_results_deletable(nqr_nmq_id) = '||c_true_string;
   END IF;
END mrg_nqr_predicate_del;
--
------------------------------------------------------------------------------------------------
--
FUNCTION execute_query_allowed_string (pi_nmq_id IN nm_mrg_query.nmq_id%TYPE) RETURN VARCHAR2 IS
BEGIN
   IF execute_query_allowed (pi_nmq_id)
    THEN
      RETURN nm3type.c_true;
   ELSE
      RETURN nm3type.c_false;
   END IF;
END execute_query_allowed_string;
--
------------------------------------------------------------------------------------------------
--
FUNCTION execute_query_allowed (pi_nmq_id IN nm_mrg_query.nmq_id%TYPE) RETURN BOOLEAN IS
--
   CURSOR cs_nqt (p_nmq_id nm_mrg_query_users.nqu_nmq_id%TYPE) IS
   SELECT COUNT(*) - nmq.nmq_inv_type_x_sect_count
    FROM  nm_mrg_query       nmq
         ,nm_mrg_query_types nqt
   WHERE  nmq.nmq_id     = p_nmq_id
    AND   nqt.nqt_nmq_id = nmq.nmq_id
   GROUP BY nmq.nmq_inv_type_x_sect_count;
--
   l_count        BINARY_INTEGER;
--
   l_mode_allowed nm_mrg_query_users.nqu_mode_allowed%TYPE;
--
   l_retval BOOLEAN;
--
BEGIN
   IF NOT c_user_restricted
    THEN
      --
      -- This is an UNRESTRICTED user therefore can execute the query regardless
      --
      l_retval := TRUE;
   ELSE
      l_retval := is_query_updatable (pi_nmq_id) = nm3type.c_true;
      IF l_retval
       THEN
         OPEN  cs_nqt (pi_nmq_id);
         FETCH cs_nqt INTO l_count;
         CLOSE cs_nqt;
         l_retval := (l_count = 0); -- If this is zero then the number of query types we can see is the same
                                    -- as the actual number there are, therefore the user can see all of the
                                    -- inv types in the query so are allowed to run the query
      END IF;
   END IF;
--
   RETURN l_retval;
--
END execute_query_allowed;
--
------------------------------------------------------------------------------------
--
FUNCTION is_query_updatable (p_nmq_id IN nm_mrg_query.nmq_id%TYPE) RETURN VARCHAR2 IS
--
   l_dummy  BINARY_INTEGER;
   l_retval VARCHAR2(5);
--
BEGIN
--
   IF NOT c_user_restricted
     OR p_nmq_id IS NULL
    THEN
      --
      -- This is an UNRESTRICTED user therefore can execute the query regardless
      --
      l_retval := nm3type.c_true;
   ELSE
--
      IF qry_updatable_for_user (p_nmq_id, c_user)
       THEN
         l_retval := nm3type.c_true;
      ELSE -- Not assigned NORMAL mode directly, try via PUBLIC
         IF qry_updatable_for_user (p_nmq_id, g_pub_user)
          THEN
            l_retval := nm3type.c_true;
         ELSE
            l_retval := nm3type.c_false;
         END IF;
      END IF;
--
   END IF;
--
   RETURN l_retval;
--
END is_query_updatable;
--
------------------------------------------------------------------------------------
--
function mrg_nqa_predicate( schema_in varchar2, name_in varchar2) return varchar2 IS
BEGIN
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       RETURN qry_updatable('nqa_nmq_id');
    ELSE
       RETURN Null;
    END IF;
END mrg_nqa_predicate;
--
------------------------------------------------------------------------------------
--
function mrg_nqa_predicate_read( schema_in varchar2, name_in varchar2) return varchar2 IS
BEGIN
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       RETURN qry_selectable('nqa_nmq_id');
    ELSE
       RETURN Null;
    END IF;
END mrg_nqa_predicate_read;
--
------------------------------------------------------------------------------------
--
function mrg_nqv_predicate( schema_in varchar2, name_in varchar2) return varchar2 IS
BEGIN
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       RETURN qry_updatable('nqv_nmq_id');
    ELSE
       RETURN Null;
    END IF;
END mrg_nqv_predicate;
--
------------------------------------------------------------------------------------
--
function mrg_nqv_predicate_read( schema_in varchar2, name_in varchar2) return varchar2 IS
BEGIN
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required
       --
       RETURN qry_selectable('nqv_nmq_id');
    ELSE
       RETURN Null;
    END IF;
END mrg_nqv_predicate_read;
--
------------------------------------------------------------------------------------
--
FUNCTION are_query_results_deletable (p_nmq_id IN nm_mrg_query.nmq_id%TYPE) RETURN VARCHAR2 IS
--
   l_retval VARCHAR2(5);
--
BEGIN
--
    IF NOT c_user_restricted
     OR p_nmq_id IS NULL
     THEN
       l_retval := nm3type.c_true;
    ELSE
       IF qry_updatable_for_user (p_nmq_id, c_user)
        THEN
          -- User has NORMAL access directly
          l_retval := nm3type.c_true;
       ELSE
          IF qry_updatable_for_user (p_nmq_id,g_pub_user)
           THEN
             -- They have NORMAL access to the query
             --  but only via PUBLIC, so make sure there aren't any results
             IF qry_results_exists(p_nmq_id)
              THEN
                -- If results exist then they aren't allowed to continue
                l_retval := nm3type.c_false;
             ELSE
                l_retval := nm3type.c_true;
             END IF;
          ELSE
             -- Do not have normal access to query
             l_retval := nm3type.c_false;
          END IF;
       END IF;
    END IF;
--
    RETURN l_retval;
--
END are_query_results_deletable;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_updatable_for_user (p_nmq_id NUMBER
                                ,p_user   VARCHAR2
                                ) RETURN BOOLEAN IS
   CURSOR cs_updatable (c_nmq_id NUMBER
                       ,c_user   VARCHAR2
                       ) IS
   SELECT 1
    FROM  nm_mrg_query_users
   WHERE  nqu_nmq_id       = c_nmq_id
    AND   nqu_username     = c_user
    AND   nqu_mode_allowed = nm3type.c_normal;
   l_dummy  BINARY_INTEGER;
   l_retval BOOLEAN;
BEGIN
   OPEN  cs_updatable (p_nmq_id, p_user);
   FETCH cs_updatable INTO l_dummy;
   l_retval := cs_updatable%FOUND;
   CLOSE cs_updatable;
   RETURN l_retval;
END qry_updatable_for_user;
--
------------------------------------------------------------------------------------
--
FUNCTION qry_results_exists (p_nmq_id NUMBER) RETURN BOOLEAN IS
--
   CURSOR cs_exists (c_nmq_id NUMBER) IS
   SELECT 1
    FROM  nm_mrg_query_results
   WHERE  nqr_nmq_id = c_nmq_id;
--
   l_dummy BINARY_INTEGER;
--
   l_retval BOOLEAN;
--
BEGIN
--
   OPEN  cs_exists (p_nmq_id);
   FETCH cs_exists INTO l_dummy;
   l_retval := cs_exists%FOUND;
   CLOSE cs_exists;
--
   RETURN l_retval;
--
END qry_results_exists;
--
-----------------------------------------------------------------------------
--
function mrg_ndq_predicate ( schema_in varchar2, name_in varchar2) return varchar2 is
  l_retval varchar2(2000) := Null;
begin
--
    IF c_user_restricted
     THEN
       --
       -- If we are context restricted then return the string required to
       --  call the chk_inv_types_for_role function
       --
       l_retval := invsec.c_start_inv_type_string||'ndq_inv_type'||invsec.c_end_check_string_read;
    END IF;
--
    return l_retval;
--
END mrg_ndq_predicate;
--
------------------------------------------------------------------------------------
--
BEGIN
--
   nm3user.get_public_user_details
            (po_pub_username => g_pub_user
            ,po_pub_name     => g_pub_user_det
            );
--
end mrgsec;
/
