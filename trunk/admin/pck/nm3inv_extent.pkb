CREATE OR REPLACE PACKAGE BODY nm3inv_extent AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_extent.pkb-arc   2.3   Jul 04 2013 16:04:32   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_extent.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:32  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.2
-------------------------------------------------------------------------
--   Author : Kevin Angus
--
--   nm3inv_extent body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
  g_package_name CONSTANT varchar2(30) := 'nm3inv_extent';
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
FUNCTION get_inv_of_type_in_nte(pi_inv_type IN nm_inv_types.nit_inv_type%TYPE
                               ,pi_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                               ) RETURN nm3type.tab_number IS


  l_retval_tab nm3type.tab_number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_inv_of_type_in_nte');

  SELECT
    nm.nm_ne_id_in
  BULK COLLECT INTO
    l_retval_tab
  FROM
    nm_members nm,
    nm_nw_temp_extents nte
  WHERE
    nte.nte_job_id = pi_nte_job_id
  AND
    nm.nm_ne_id_of = nte.nte_ne_id_of
  AND
    ((nm.nm_begin_mp < nte.nte_end_mp
      AND
      nm.nm_end_mp > nte.nte_begin_mp)
    OR
     (nm.nm_begin_mp = nm.nm_end_mp
      AND
      nm.nm_begin_mp BETWEEN nte.nte_begin_mp AND nte.nte_end_mp)
    OR
     (nte.nte_begin_mp = nte.nte_end_mp
      AND
      nte.nte_begin_mp BETWEEN nm.nm_begin_mp AND nm.nm_end_mp))
  AND
    nm.nm_obj_type = pi_inv_type
  GROUP BY
    nm.nm_ne_id_in;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_inv_of_type_in_nte');

  RETURN l_retval_tab;

END get_inv_of_type_in_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION get_inv_of_au_type_in_nte
                            (pi_nte_job_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                            ,pi_admin_type     IN nm_au_types.nat_admin_type%TYPE
                            ) RETURN nm3type.tab_number IS
--
   CURSOR cs_inv_no_hier (c_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                         ,c_admin_type nm_au_types.nat_admin_type%TYPE
                         ,c_nm_type    nm_members.nm_type%TYPE
                         ) IS
   SELECT /*+ RULE */ nm_ne_id_in, nm_obj_type
    FROM  nm_members
         ,nm_nw_temp_extents
   WHERE  nte_job_id                          = c_nte_job_id
    AND   nte_ne_id_of                        = nm_ne_id_of
    AND   nm_type                             = c_nm_type
    AND   nm_end_mp                          >= nte_begin_mp
    AND   nm_begin_mp                        <= nte_end_mp
    AND   nm3ausec.get_au_type(nm_admin_unit) = c_admin_type
    AND   NOT EXISTS (SELECT 1
                       FROM  nm_inv_item_groupings
                      WHERE  nm_ne_id_in = iig_item_id
                     )
   GROUP BY nm_ne_id_in, nm_obj_type;
--
   CURSOR cs_inv_hier (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   SELECT iig_item_id
         ,nm3inv.get_inv_type(iig_item_id)
    FROM  nm_inv_item_groupings
   START WITH iig_parent_id = c_iit_ne_id
   CONNECT BY iig_parent_id = PRIOR iig_item_id
   ORDER BY LEVEL;
--
   l_tab_iit_ne_id_temp1 nm3type.tab_number;
   l_tab_iit_ne_id_temp2 nm3type.tab_number;
   l_tab_inv_type_temp1  nm3type.tab_varchar4;
   l_tab_inv_type_temp2  nm3type.tab_varchar4;
   l_tab_iit_ne_id       nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_inv_of_au_type_in_nte');
--
   OPEN  cs_inv_no_hier (pi_nte_job_id, pi_admin_type, 'I');
   FETCH cs_inv_no_hier
    BULK COLLECT INTO l_tab_iit_ne_id_temp1,l_tab_inv_type_temp1;
   CLOSE cs_inv_no_hier;
--
   FOR i IN 1..l_tab_iit_ne_id_temp1.COUNT
    LOOP
      l_tab_iit_ne_id(l_tab_iit_ne_id.COUNT+1)    := l_tab_iit_ne_id_temp1(i);
      OPEN  cs_inv_hier (l_tab_iit_ne_id_temp1(i));
      FETCH cs_inv_hier BULK COLLECT INTO l_tab_iit_ne_id_temp2,l_tab_inv_type_temp2;
      CLOSE cs_inv_hier;
      FOR j IN 1..l_tab_iit_ne_id_temp2.COUNT
       LOOP
         l_tab_iit_ne_id(l_tab_iit_ne_id.COUNT+1) := l_tab_iit_ne_id_temp2(j);
      END LOOP;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_inv_of_au_type_in_nte');
--
   RETURN l_tab_iit_ne_id;
--
END get_inv_of_au_type_in_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION get_future_inv_au_type_temp_ne
                            (pi_nte_job_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                            ,pi_admin_type     IN nm_au_types.nat_admin_type%TYPE
                            ) RETURN nm3type.tab_number IS
--
   CURSOR cs_inv (c_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                 ,c_admin_type nm_au_types.nat_admin_type%TYPE
                 ,c_nm_type    nm_members.nm_type%TYPE
                 ) IS
   SELECT /*+ RULE */ nm_ne_id_in, nm_obj_type
    FROM  nm_members_all
         ,nm_nw_temp_extents
   WHERE  nte_job_id                          = c_nte_job_id
    AND   nte_ne_id_of                        = nm_ne_id_of
    AND   nm_type                             = c_nm_type
    AND   nm_end_mp                          >= nte_begin_mp
    AND   nm_begin_mp                        <= nte_end_mp
    AND   nm3ausec.get_au_type(nm_admin_unit) = c_admin_type
    AND   nm_start_date                      >  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
   GROUP BY nm_ne_id_in, nm_obj_type;
--
   l_tab_inv_type  nm3type.tab_varchar4;
   l_tab_iit_ne_id nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_future_inv_au_type_temp_ne');
--
   OPEN  cs_inv (pi_nte_job_id, pi_admin_type, 'I');
   FETCH cs_inv
    BULK COLLECT INTO l_tab_iit_ne_id,l_tab_inv_type;
   CLOSE cs_inv;
--
   nm_debug.proc_end(g_package_name,'get_future_inv_au_type_temp_ne');
--
   RETURN l_tab_iit_ne_id;
--
END get_future_inv_au_type_temp_ne;
--
-----------------------------------------------------------------------------
--
END nm3inv_extent;
/
