--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_obj_on_route.vw-arc   1.7   Jun 09 2020 16:10:12   Rob.Coupe  $
--       Module Name      : $Workfile:   v_obj_on_route.vw  $
--       Date into PVCS   : $Date:   Jun 09 2020 16:10:12  $
--       Date fetched Out : $Modtime:   Jun 09 2020 16:07:58  $
--       Version          : $Revision:   1.7  $
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

DECLARE
   view_does_not_exist   EXCEPTION;
   PRAGMA EXCEPTION_INIT (view_does_not_exist, -12003);
BEGIN
   EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW V_OBJ_ON_ROUTE';
EXCEPTION
   WHEN view_does_not_exist
   THEN
      NULL;
   WHEN OTHERS
   THEN
      RAISE;
END;
/

WHENEVER SQLERROR EXIT;

DECLARE
   l_contexts_are_set   VARCHAR2 (5);
BEGIN
   BEGIN
      SELECT 'TRUE'
        INTO l_contexts_are_set
        FROM DUAL
       WHERE     EXISTS
                    (SELECT 1
                       FROM session_context
                      WHERE     namespace = 'NM3SQL'
                            AND attribute = 'MV_ROUTE_TYPE')
             AND EXISTS
                    (SELECT 1
                       FROM session_context
                      WHERE     namespace = 'NM3SQL'
                            AND attribute = 'MV_DATUM_NLT_ID');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         l_contexts_are_set := 'FALSE';
   END;

   IF l_contexts_are_set != 'TRUE'
   THEN
      raise_application_error (
         -20001,
         'The materialized view is based on context variables which are not set');
   END IF;
END;
/

WHENEVER SQLERROR CONTINUE


CREATE MATERIALIZED VIEW V_OBJ_ON_ROUTE
   (
   REFNT,
   REFNT_TYPE,
   OBJ_TYPE,
   OBJ_ID,
   SEG_ID,
   SEQ_ID,
   DIR_FLAG,
   NM_BEGIN_MP,
   NM_END_MP,
   M_UNIT
   )
   BUILD IMMEDIATE
   REFRESH FORCE
           ON DEMAND
           WITH PRIMARY KEY
AS
   SELECT *
     FROM (WITH inv_types
                AS (SELECT nit_inv_type, nit_pnt_or_cont
                      FROM nm_inv_types
                     WHERE nit_category = 'I')
           --           select * from inv_types )
           SELECT t.*
             FROM TABLE (
                     SELECT lb_get.GET_LB_RPT_R_TAB (
                               CAST (
                                  COLLECT (
                                     lb_rpt (
                                        nm_ne_id_of,
                                        TO_NUMBER (
                                           SYS_CONTEXT (
                                              'NM3SQL',
                                              'MV_DATUM_NLT_ID')),
                                        nm_obj_type,
                                        nm_ne_id_in,
                                        NULL,
                                        NULL,
                                        NULL,
                                        nm_begin_mp,
                                        nm_end_mp,
                                        1)) AS lb_rpt_tab),
                               SYS_CONTEXT ('NM3SQL', 'MV_ROUTE_TYPE'),
                               1000)
                       FROM nm_members, inv_types
                      WHERE     nm_type = 'I'
                            AND nm_obj_type = nit_inv_type
                            AND nit_pnt_or_cont = 'C'
                            AND SUBSTR (nit_inv_type, 1, 1) BETWEEN 'A'
                                                                AND 'M') t
           UNION ALL
           SELECT t.*
             FROM TABLE (
                     SELECT lb_get.GET_LB_RPT_R_TAB (
                               CAST (
                                  COLLECT (
                                     lb_rpt (
                                        nm_ne_id_of,
                                        TO_NUMBER (
                                           SYS_CONTEXT (
                                              'NM3SQL',
                                              'MV_DATUM_NLT_ID')),
                                        nm_obj_type,
                                        nm_ne_id_in,
                                        NULL,
                                        NULL,
                                        NULL,
                                        nm_begin_mp,
                                        nm_end_mp,
                                        1)) AS lb_rpt_tab),
                               SYS_CONTEXT ('NM3SQL', 'MV_ROUTE_TYPE'),
                               1000)
                       FROM nm_members, inv_types
                      WHERE     nm_type = 'I'
                            AND nm_obj_type = nit_inv_type
                            AND nit_pnt_or_cont = 'C'
                            AND SUBSTR (nit_inv_type, 1, 1) BETWEEN 'N'
                                                                AND 'Z') t
           UNION ALL
           SELECT t.*
             FROM TABLE (
                     SELECT lb_get.GET_LB_RPT_R_TAB (
                               CAST (
                                  COLLECT (
                                     lb_rpt (
                                        nm_ne_id_of,
                                        TO_NUMBER (
                                           SYS_CONTEXT (
                                              'NM3SQL',
                                              'MV_DATUM_NLT_ID')),
                                        nm_obj_type,
                                        nm_ne_id_in,
                                        NULL,
                                        NULL,
                                        NULL,
                                        nm_begin_mp,
                                        nm_end_mp,
                                        1)) AS lb_rpt_tab),
                               SYS_CONTEXT ('NM3SQL', 'MV_ROUTE_TYPE'),
                               1000)
                       FROM nm_members, inv_types
                      WHERE     nm_type = 'I'
                            AND nm_obj_type = nit_inv_type
                            AND nit_pnt_or_cont = 'P'
                            AND SUBSTR (nit_inv_type, 1, 1) BETWEEN 'A'
                                                                AND 'H') t
           UNION ALL
           SELECT t.*
             FROM TABLE (
                     SELECT lb_get.GET_LB_RPT_R_TAB (
                               CAST (
                                  COLLECT (
                                     lb_rpt (
                                        nm_ne_id_of,
                                        TO_NUMBER (
                                           SYS_CONTEXT (
                                              'NM3SQL',
                                              'MV_DATUM_NLT_ID')),
                                        nm_obj_type,
                                        nm_ne_id_in,
                                        NULL,
                                        NULL,
                                        NULL,
                                        nm_begin_mp,
                                        nm_end_mp,
                                        1)) AS lb_rpt_tab),
                               SYS_CONTEXT ('NM3SQL', 'MV_ROUTE_TYPE'),
                               1000)
                       FROM nm_members, inv_types
                      WHERE     nm_type = 'I'
                            AND nm_obj_type = nit_inv_type
                            AND nit_pnt_or_cont = 'P'
                            AND SUBSTR (nit_inv_type, 1, 1) BETWEEN 'I'
                                                                AND 'Q') t
           UNION ALL
           SELECT t.*
             FROM TABLE (
                     SELECT lb_get.GET_LB_RPT_R_TAB (
                               CAST (
                                  COLLECT (
                                     lb_rpt (
                                        nm_ne_id_of,
                                        TO_NUMBER (
                                           SYS_CONTEXT (
                                              'NM3SQL',
                                              'MV_DATUM_NLT_ID')),
                                        nm_obj_type,
                                        nm_ne_id_in,
                                        NULL,
                                        NULL,
                                        NULL,
                                        nm_begin_mp,
                                        nm_end_mp,
                                        1)) AS lb_rpt_tab),
                               SYS_CONTEXT ('NM3SQL', 'MV_ROUTE_TYPE'),
                               1000)
                       FROM nm_members, inv_types
                      WHERE     nm_type = 'I'
                            AND nm_obj_type = nit_inv_type
                            AND nit_pnt_or_cont = 'P'
                            AND SUBSTR (nit_inv_type, 1, 1) BETWEEN 'R'
                                                                AND 'Z') t);

COMMENT ON MATERIALIZED VIEW V_OBJ_ON_ROUTE IS
   'Snapshot table for all assets on a section'
/


CREATE INDEX MV_OOR_RT_IDX
   ON V_OBJ_ON_ROUTE (REFNT)
/

CREATE INDEX MV_OOR_INV_IDX
   ON V_OBJ_ON_ROUTE (OBJ_ID, OBJ_TYPE)
/
