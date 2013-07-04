CREATE OR REPLACE PACKAGE BODY nm3extent_o AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3extent_o.pkb-arc   2.2   Jul 04 2013 15:33:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3extent_o.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:33:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       Version          : $Revision:   2.2  $
--       Based on SCCS version : 1.7
--
--
--   Author : Kevin Angus
--
--   nm3extent_o package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.2  $';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'NM3EXTENT_O';
--
   g_extent_exception EXCEPTION;
   g_extent_exc_code  number;
   g_extent_exc_msg   varchar2(2000);
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
PROCEDURE create_temp_ne_from_pl(pi_pl_arr                    IN     nm_placement_array
                                ,po_job_id                       OUT nm_nw_temp_extents.nte_job_id%TYPE
                                ,pi_default_parent_id         IN     nm_elements.ne_id%TYPE DEFAULT NULL
                                ,pi_ignore_non_linear_parents IN     boolean DEFAULT FALSE
                                ) IS
--  
  l_pl nm_placement;
--
  l_seq_no pls_integer := 0;
--
  l_rec_nte nm_nw_temp_extents%ROWTYPE;

  l_gty nm_group_types.ngt_group_type%TYPE;

  l_default_parent boolean := FALSE;
--
BEGIN
  nm_debug.proc_start(g_package_name,'create_temp_ne_from_pl');
  
  IF pi_pl_arr.is_empty
  THEN
    g_extent_exc_code := -20212;
    g_extent_exc_msg  := 'No values in placement array.';
    RAISE g_extent_exception;
  END IF;

  -- Get the job_id
  po_job_id := nm3net.get_next_nte_id;

  FOR l_count IN 1..pi_pl_arr.npa_placement_array.COUNT
  LOOP
    l_default_parent := FALSE;

    -- assign it to a simple variable to make stuff easier
    l_pl := pi_pl_arr.npa_placement_array(l_count);

    l_seq_no := l_seq_no + 1;

    l_rec_nte.nte_job_id         := po_job_id;
    l_rec_nte.nte_ne_id_of       := l_pl.pl_ne_id;
    l_rec_nte.nte_begin_mp       := l_pl.pl_start;
    l_rec_nte.nte_end_mp         := l_pl.pl_end;
    l_rec_nte.nte_seq_no         := l_seq_no;
    
--     nm_debug.DEBUG('l_pl.pl_ne_id = ' || l_pl.pl_ne_id);
--     nm_debug.DEBUG('l_pl.pl_start = ' || l_pl.pl_start);
--     nm_debug.DEBUG('l_pl.pl_end = ' || l_pl.pl_end);
--     nm_debug.DEBUG('l_seq_no = ' || l_seq_no);
--
    DECLARE
       l_no_nti EXCEPTION;
       PRAGMA EXCEPTION_INIT (l_no_nti, -20001);

    BEGIN
       l_rec_nte.nte_route_ne_id := nm3net.get_parent_ne_id(p_child_ne_id => l_rec_nte.nte_ne_id_of
                                                           ,p_parent_type => nm3net.get_parent_type(nm3net.get_nt_type(l_rec_nte.nte_ne_id_of))
                                                           );

       l_gty := nm3net.get_ne_gty(pi_ne_id => l_rec_nte.nte_route_ne_id);

       IF pi_ignore_non_linear_parents
         AND l_gty IS NOT NULL
         AND nm3net.get_gty(pi_gty => l_gty).ngt_linear_flag = 'N'
       THEN
         --parent is non-linear and we want to ignore those
         l_default_parent := TRUE;
       END IF;

    EXCEPTION
       WHEN l_no_nti
        THEN
          l_default_parent := TRUE;

    END;

    IF l_default_parent
    THEN
      IF pi_default_parent_id IS NOT NULL
      THEN
        --parent has been supplied
        l_rec_nte.nte_route_ne_id := pi_default_parent_id;
      ELSE
        l_rec_nte.nte_route_ne_id := l_rec_nte.nte_ne_id_of;
      END IF;
    END IF;
      
    BEGIN
      IF pi_default_parent_id IS NOT NULL
      THEN
        SELECT
          nm.nm_cardinality
        INTO
          l_rec_nte.nte_cardinality
        FROM
          nm_members nm
        WHERE
          nm.nm_ne_id_in = pi_default_parent_id
        AND
          nm.nm_ne_id_of = l_rec_nte.nte_ne_id_of
        AND
          l_rec_nte.nte_begin_mp BETWEEN nm.nm_begin_mp AND nm.nm_end_mp;

      ELSE
        l_rec_nte.nte_cardinality := 1;
      END IF;
      
    EXCEPTION
      WHEN no_data_found
      THEN
        l_rec_nte.nte_cardinality := 1;
        
    END;
--
    nm3extent.ins_nte(p_rec_nte => l_rec_nte);
  END LOOP;

  nm_debug.proc_end(g_package_name,'create_temp_ne_from_pl');

EXCEPTION
  WHEN g_extent_exception
  THEN
    RAISE_APPLICATION_ERROR(g_extent_exc_code,g_extent_exc_msg);

END create_temp_ne_from_pl;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pl_from_nte_measures (p_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE
                                  ,p_begin_mp   number
                                  ,p_end_mp     number
                                  ) RETURN nm_placement_array IS
BEGIN
--
   RETURN nm3pla.get_pl_within_measures  (p_pl       => nm3pla.get_placement_from_temp_ne (p_nte_job_id)
                                         ,p_begin_mp => p_begin_mp
                                         ,p_end_mp   => p_end_mp
                                         );
--
END get_pl_from_nte_measures;
--
-----------------------------------------------------------------------------
--
FUNCTION get_pl_from_npe_measures (p_npe_job_id nm_nw_persistent_extents.npe_job_id%TYPE
                                  ,p_begin_mp   number
                                  ,p_end_mp     number
                                  ) RETURN nm_placement_array IS
BEGIN
--
   RETURN nm3pla.get_pl_within_measures  (p_pl       => nm3pla.get_placement_persistent_ne (p_npe_job_id)
                                         ,p_begin_mp => p_begin_mp
                                         ,p_end_mp   => p_end_mp
                                         );
--
END get_pl_from_npe_measures;
--
-----------------------------------------------------------------------------
--
END nm3extent_o;
/
