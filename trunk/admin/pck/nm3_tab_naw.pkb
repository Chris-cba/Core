CREATE OR REPLACE PACKAGE BODY nm3_tab_naw AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3_tab_naw.pkb-arc   2.2   Jul 04 2013 15:10:54   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3_tab_naw.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:10:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:22  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
-----------------------------------------------------------------------------
--   Author : 
--
--   Generated package DO NOT MODIFY
--
--   get_gen header : "@(#)nm3_tab_naw.pkb	1.1 01/11/06"
--   get_gen body   : @(#)nm3_tab_naw.pkb	1.1 01/11/06
--
-----------------------------------------------------------------------------
--
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--
-----------------------------------------------------------------------------
--
   g_body_sccsid CONSTANT  VARCHAR2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3_tab_naw';
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
--
--   Function to get using NAW_PK constraint
--
FUNCTION get (pi_naw_id            NM_AUDIT_WHEN.naw_id%TYPE
             ,pi_raise_not_found   BOOLEAN     DEFAULT TRUE
             ,pi_not_found_sqlcode PLS_INTEGER DEFAULT -20000
             ) RETURN NM_AUDIT_WHEN%ROWTYPE IS
--
   CURSOR cs_naw IS
   SELECT /*+ FIRST_ROWS(1) INDEX(naw NAW_PK) */ 
          naw_id
         ,naw_table_name
         ,naw_column_name
         ,naw_operator
         ,naw_condition
    FROM  NM_AUDIT_WHEN naw
   WHERE  naw.naw_id = pi_naw_id;
--
   l_found  BOOLEAN;
   l_retval NM_AUDIT_WHEN%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get');
--
   OPEN  cs_naw;
   FETCH cs_naw INTO l_retval;
   l_found := cs_naw%FOUND;
   CLOSE cs_naw;
--
   IF pi_raise_not_found AND NOT l_found
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 67
                    ,pi_sqlcode            => pi_not_found_sqlcode
                    ,pi_supplementary_info => 'NM_AUDIT_WHEN (NAW_PK)'
                                              ||CHR(10)||'naw_id => '||pi_naw_id
                    );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get');
--
   RETURN l_retval;
--
END get;
--
-----------------------------------------------------------------------------
--
FUNCTION next_naw_id_seq RETURN PLS_INTEGER IS
-- Get NAW_ID_SEQ.NEXTVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NAW_ID_SEQ.NEXTVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END next_naw_id_seq;
--
-----------------------------------------------------------------------------
--
FUNCTION curr_naw_id_seq RETURN PLS_INTEGER IS
-- Get NAW_ID_SEQ.CURRVAL
   l_retval PLS_INTEGER;
BEGIN
   SELECT NAW_ID_SEQ.CURRVAL
    INTO  l_retval
    FROM  dual;
   RETURN l_retval;
END curr_naw_id_seq;
--
-----------------------------------------------------------------------------
--
END nm3_tab_naw;
/
