create or replace package body nm3mrg_wrap as
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3mrg_wrap.pkb-arc   2.2   Jul 04 2013 16:16:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3mrg_wrap.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:16:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:16  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.1
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   nm3mrg_wrap package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
--
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.2  $';
  g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3mrg_wrap';
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
PROCEDURE execute_mrg_qry
             (pi_query_id      IN     nm_mrg_query.nmq_id%TYPE
             ,pi_source_id     IN     NUMBER
             ,pi_source        IN     VARCHAR2 DEFAULT nm3extent.c_route
             ,pi_begin_mp      IN     NUMBER   DEFAULT NULL
             ,pi_end_mp        IN     NUMBER   DEFAULT NULL
             ,pi_description   IN     nm_mrg_query_results.nqr_description%TYPE
             ,po_result_job_id IN OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE
             ) IS
--
   l_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_mrg_qry');
--
   nm3extent.create_temp_ne(pi_source_id
                           ,pi_source
                           ,pi_begin_mp
                           ,pi_end_mp
                           ,l_nte_job_id
                           );
--
   nm3mrg.execute_mrg_query
             (pi_query_id
             ,l_nte_job_id
             ,pi_description
             ,po_result_job_id
             );
--
   nm_debug.proc_end(g_package_name,'execute_mrg_qry');
--
END execute_mrg_qry;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_mrg_qry_route
             (pi_query_id      IN     nm_mrg_query.nmq_id%TYPE
             ,pi_route_ne_id   IN     nm_elements.ne_id%TYPE
             ,pi_description   IN     nm_mrg_query_results.nqr_description%TYPE
             ,po_result_job_id IN OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE
             ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_mrg_qry_route');
--
   execute_mrg_qry_partial_route
             (pi_query_id      => pi_query_id
             ,pi_route_ne_id   => pi_route_ne_id
             ,pi_begin_mp      => Null
             ,pi_end_mp        => Null
             ,pi_description   => pi_description
             ,po_result_job_id => po_result_job_id
             );
--
   nm_debug.proc_end(g_package_name,'execute_mrg_qry_route');
--
END execute_mrg_qry_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_mrg_qry_partial_route
             (pi_query_id      IN     nm_mrg_query.nmq_id%TYPE
             ,pi_route_ne_id   IN     nm_elements.ne_id%TYPE
             ,pi_begin_mp      IN     NUMBER
             ,pi_end_mp        IN     NUMBER
             ,pi_description   IN     nm_mrg_query_results.nqr_description%TYPE
             ,po_result_job_id IN OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE
             ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_mrg_qry_partial_route');
--
   execute_mrg_qry
             (pi_query_id      => pi_query_id
             ,pi_source_id     => pi_route_ne_id
             ,pi_source        => nm3extent.c_route
             ,pi_begin_mp      => pi_begin_mp
             ,pi_end_mp        => pi_end_mp
             ,pi_description   => pi_description
             ,po_result_job_id => po_result_job_id
             );
--
   nm_debug.proc_end(g_package_name,'execute_mrg_qry_partial_route');
--
END execute_mrg_qry_partial_route;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_mrg_qry_saved_ne
             (pi_query_id      IN     nm_mrg_query.nmq_id%TYPE
             ,pi_nse_id        IN     nm_saved_extents.nse_id%TYPE
             ,pi_description   IN     nm_mrg_query_results.nqr_description%TYPE
             ,po_result_job_id IN OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE
             ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_mrg_qry_saved_ne');
--
   execute_mrg_qry
             (pi_query_id      => pi_query_id
             ,pi_source_id     => pi_nse_id
             ,pi_source        => nm3extent.c_saved
             ,pi_begin_mp      => Null
             ,pi_end_mp        => Null
             ,pi_description   => pi_description
             ,po_result_job_id => po_result_job_id
             );
--
   nm_debug.proc_end(g_package_name,'execute_mrg_qry_saved_ne');
--
END execute_mrg_qry_saved_ne;
--
-----------------------------------------------------------------------------
--
PROCEDURE execute_mrg_qry_gazeteer
             (pi_query_id      IN     nm_mrg_query.nmq_id%TYPE
             ,pi_id            IN     NUMBER
             ,pi_type          IN     VARCHAR2
             ,pi_description   IN     nm_mrg_query_results.nqr_description%TYPE
             ,po_result_job_id IN OUT nm_mrg_query_results.nqr_mrg_job_id%TYPE
             ) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'execute_mrg_qry_gazeteer');
--
   IF pi_type = 'E'
    THEN
      execute_mrg_qry_saved_ne
             (pi_query_id      => pi_query_id
             ,pi_nse_id        => pi_id
             ,pi_description   => pi_description
             ,po_result_job_id => po_result_job_id
             );
   ELSE
      execute_mrg_qry_route
             (pi_query_id      => pi_query_id
             ,pi_route_ne_id   => pi_id
             ,pi_description   => pi_description
             ,po_result_job_id => po_result_job_id
             );
   END IF;
--
   nm_debug.proc_end(g_package_name,'execute_mrg_qry_gazeteer');
--
END execute_mrg_qry_gazeteer;
--
-----------------------------------------------------------------------------
--
end nm3mrg_wrap;
/
