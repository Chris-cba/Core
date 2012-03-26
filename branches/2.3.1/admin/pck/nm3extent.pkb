CREATE OR REPLACE PACKAGE BODY Nm3extent IS
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3extent.pkb-arc   2.3.1.1   Mar 26 2012 10:46:56   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3extent.pkb  $
--       Date into SCCS   : $Date:   Mar 26 2012 10:46:56  $
--       Date fetched Out : $Modtime:   Mar 26 2012 10:44:12  $
--       SCCS Version     : $Revision:   2.3.1.1  $
--       Based on 
--
--
--       Author : Kevin Angus
--
--       nm3extent package - Functions + Procedures for dealing with saved, persistent
--                           and temporary extents.
--
-----------------------------------------------------------------------------
--    Copyright (c) exor corporation ltd, 2007
-----------------------------------------------------------------------------
--
  g_package_name CONSTANT VARCHAR2(30) := 'nm3extent';
  --
  --g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"@(#)nm3extent.pkb	1.77 05/02/06"';
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.3.1.1  $';
--  g_body_sccsid is the SCCS ID for the package body
--
  g_extent_exception EXCEPTION;
  g_extent_exc_code  NUMBER;
  g_extent_exc_msg   VARCHAR2(2000);
  --
  g_gis_nse_id          NM_SAVED_EXTENTS.nse_id%TYPE;
--
  g_tab_nte_ne_id_of    Nm3type.tab_number;
  g_tab_nte_begin_mp    Nm3type.tab_number;
  g_tab_nte_end_mp      Nm3type.tab_number;
  g_tab_nte_cardinality Nm3type.tab_number;
  g_tab_nte_seq_no      Nm3type.tab_number;
  g_tab_nte_route_ne_id Nm3type.tab_number;
  TYPE t_tab_of_tab_number IS TABLE OF Nm3type.tab_number INDEX BY BINARY_INTEGER ;
--
  --
  ------- Local Procedures ----------------------------------------------------
  --
  PROCEDURE db ( mesg IN VARCHAR2 ) IS
  BEGIN
    RETURN ;
    DBMS_OUTPUT.PUT_LINE(mesg);
  END db ;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_saved_ne
                  (pi_nse_id IN     NM_SAVED_EXTENTS.nse_id%TYPE
                  ,po_job_id    OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  );
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE nte_intx_nte(p_nte1           IN nm_nw_temp_extents.nte_job_id%type
                        ,p_nte2           IN nm_nw_temp_extents.nte_job_id%type
                        ,p_nte3           OUT nm_nw_temp_extents.nte_job_id%type
                        ) ;
--                        
  PROCEDURE nte_intx_nte(pi_smallest_nte   IN OUT NOCOPY tab_nte
                        ,pi_largest_nte    IN OUT NOCOPY tab_nte
                        ,po_nte_result     IN OUT NOCOPY tab_nte
                        ) ;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_route
                  (pi_route_ne_id               IN     nm_elements.ne_id%TYPE
                  ,pi_begin_mp                  IN     nm_members.nm_begin_mp%TYPE DEFAULT NULL
                  ,pi_end_mp                    IN     nm_members.nm_end_mp%TYPE DEFAULT NULL
                  ,po_job_id                       OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  ,pi_default_route_as_parent   IN     BOOLEAN DEFAULT FALSE
                  ,pi_ignore_non_linear_parents IN     BOOLEAN DEFAULT FALSE
                  );
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_pbi
                  (pi_pbi_job_id IN     NM_PBI_QUERY_RESULTS.nqr_job_id%TYPE
                  ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  );
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_pbi_sect(pi_pbi_job_id IN     NM_PBI_QUERY_RESULTS.nqr_job_id%TYPE
                                        ,pi_section_id IN     NM_PBI_SECTIONS.nps_section_id%TYPE
                                        ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                        );
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_merge
                  (pi_mrg_job_id IN     nm_mrg_query_results.nqr_mrg_job_id%TYPE
                  ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  );
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_mrg_sect(pi_mrg_job_id IN     nm_mrg_sections.nms_mrg_job_id%TYPE
                                        ,pi_section_id IN     nm_mrg_sections.nms_mrg_section_id%TYPE
                                        ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                        );
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE check_valid_source
                  (pi_source IN NM_PBI_QUERY_RESULTS.nqr_source%TYPE);
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_gis
                  (pi_session_id IN  GIS_DATA_OBJECTS.gdo_session_id%TYPE
                  ,po_job_id         OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  );
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE insert_nte_globals (p_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE);
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_ncg(pi_ncg_rec IN NM_CREATE_GROUP_TEMP%ROWTYPE);
  --
  -----------------------------------------------------------------------------
  --
  --
  ------- Global Procedures ---------------------------------------------------
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
  FUNCTION get_next_nse_id RETURN NM_SAVED_EXTENTS.nse_id%TYPE IS
  --
    CURSOR c1 IS
      SELECT
        nse_id_seq.NEXTVAL
      FROM
        dual;
  --
    l_retval NM_SAVED_EXTENTS.nse_id%TYPE;
  --
  BEGIN
    OPEN c1;
      FETCH c1 INTO l_retval;
    CLOSE c1;
  --
    RETURN l_retval;
  END get_next_nse_id;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_next_nsm_id RETURN NM_SAVED_EXTENT_MEMBERS.nsm_id%TYPE IS
  --
    CURSOR c1 IS
      SELECT
        nsm_id_seq.NEXTVAL
      FROM
        dual;
  --
    l_retval NM_SAVED_EXTENT_MEMBERS.nsm_id%TYPE;
  --
  BEGIN
    OPEN c1;
      FETCH c1 INTO l_retval;
    CLOSE c1;
  --
    RETURN l_retval;
  END get_next_nsm_id;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_nse(pi_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE
                  ) RETURN NM_SAVED_EXTENTS%ROWTYPE IS
  --
    CURSOR c1(p_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS
      SELECT
        *
      FROM
        NM_SAVED_EXTENTS
      WHERE
        nse_id = p_nse_id;
  --
    l_retval NM_SAVED_EXTENTS%ROWTYPE;
  BEGIN
    OPEN c1(pi_nse_id);
      FETCH c1 INTO l_retval;
      IF c1%NOTFOUND THEN
        CLOSE c1;
        RAISE_APPLICATION_ERROR(-20001,'Saved extent ' || pi_nse_id || ' not found.');
      END IF;
    CLOSE c1;
  --
    RETURN l_retval;
  END get_nse;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_nsm(pi_nsm_id IN NM_SAVED_EXTENT_MEMBERS.nsm_id%TYPE
                  ) RETURN NM_SAVED_EXTENT_MEMBERS%ROWTYPE IS

    CURSOR c_nsm(p_nsm_id NM_SAVED_EXTENT_MEMBERS.nsm_id%TYPE) IS
      SELECT
        *
      FROM
        NM_SAVED_EXTENT_MEMBERS nsm
      WHERE
        nsm.nsm_id = p_nsm_id;

    l_retval NM_SAVED_EXTENT_MEMBERS%ROWTYPE;

  BEGIN
    OPEN c_nsm(p_nsm_id => pi_nsm_id);
      FETCH c_nsm INTO l_retval;
      IF c_nsm%NOTFOUND
      THEN
        g_extent_exc_code := -20217;
        g_extent_exc_msg  := 'NM_SAVED_EXTENT_MEMBERS record not found nsm_id= ' || pi_nsm_id;
        RAISE g_extent_exception;
      END IF;
    CLOSE c_nsm;

    RETURN l_retval;

  EXCEPTION
    WHEN g_extent_exception
    THEN
      RAISE_APPLICATION_ERROR(g_extent_exc_code, g_extent_exc_msg);

  END get_nsm;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nse(pi_rec_nse NM_SAVED_EXTENTS%ROWTYPE) IS
  BEGIN
     INSERT INTO NM_SAVED_EXTENTS
            (nse_id
            ,nse_owner
            ,nse_name
            ,nse_descr
            ,nse_pbi
            )
     VALUES (pi_rec_nse.nse_id
            ,pi_rec_nse.nse_owner
            ,pi_rec_nse.nse_name
            ,pi_rec_nse.nse_descr
            ,NVL(pi_rec_nse.nse_pbi,'N')
            );
  END ins_nse;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nsm(pi_rec_nsm NM_SAVED_EXTENT_MEMBERS%ROWTYPE) IS
  BEGIN
     INSERT INTO NM_SAVED_EXTENT_MEMBERS
            (nsm_nse_id
            ,nsm_id
            ,nsm_ne_id
            ,nsm_begin_mp
            ,nsm_end_mp
            ,nsm_begin_no
            ,nsm_end_no
            ,nsm_begin_sect
            ,nsm_begin_sect_offset
            ,nsm_end_sect
            ,nsm_end_sect_offset
            ,nsm_seq_no
            ,nsm_datum
            ,nsm_sub_class
            ,nsm_sub_class_excl
            ,nsm_restrict_excl_sub_class
            )
     VALUES (pi_rec_nsm.nsm_nse_id
            ,pi_rec_nsm.nsm_id
            ,pi_rec_nsm.nsm_ne_id
            ,pi_rec_nsm.nsm_begin_mp
            ,pi_rec_nsm.nsm_end_mp
            ,pi_rec_nsm.nsm_begin_no
            ,pi_rec_nsm.nsm_end_no
            ,pi_rec_nsm.nsm_begin_sect
            ,pi_rec_nsm.nsm_begin_sect_offset
            ,pi_rec_nsm.nsm_end_sect
            ,pi_rec_nsm.nsm_end_sect_offset
            ,pi_rec_nsm.nsm_seq_no
            ,pi_rec_nsm.nsm_datum
            ,pi_rec_nsm.nsm_sub_class
            ,pi_rec_nsm.nsm_sub_class_excl
            ,pi_rec_nsm.nsm_restrict_excl_sub_class
            );
  END ins_nsm;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nsm(pi_tab_rec_nsm tab_nsm) IS
  BEGIN
     FOR l_count IN 1..pi_tab_rec_nsm.COUNT
      LOOP
        ins_nsm (pi_tab_rec_nsm(l_count));
     END LOOP;
  END ins_nsm;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nsd(pi_nsd_rec NM_SAVED_EXTENT_MEMBER_DATUMS%ROWTYPE) IS
  BEGIN
    INSERT INTO NM_SAVED_EXTENT_MEMBER_DATUMS
          (nsd_nse_id
          ,nsd_nsm_id
          ,nsd_ne_id
          ,nsd_begin_mp
          ,nsd_end_mp
          ,nsd_seq_no
          ,nsd_cardinality
          )
    VALUES(pi_nsd_rec.nsd_nse_id
          ,pi_nsd_rec.nsd_nsm_id
          ,pi_nsd_rec.nsd_ne_id
          ,pi_nsd_rec.nsd_begin_mp
          ,pi_nsd_rec.nsd_end_mp
          ,pi_nsd_rec.nsd_seq_no
          ,pi_nsd_rec.nsd_cardinality
          );
  END ins_nsd;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nsd(pi_tab_rec_nsd tab_nsd) IS
  BEGIN
     FOR l_count IN 1..pi_tab_rec_nsd.COUNT
      LOOP
        ins_nsd (pi_tab_rec_nsd(l_count));
     END LOOP;
  END ins_nsd;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE del_nsd(pi_nsm_id IN NM_SAVED_EXTENT_MEMBERS.nsm_id%TYPE
                   ) IS
  BEGIN
    DELETE
      NM_SAVED_EXTENT_MEMBER_DATUMS
    WHERE
      nsd_nsm_id = pi_nsm_id;
  END del_nsd;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE del_nsm(pi_nsm_id IN NM_SAVED_EXTENT_MEMBERS.nsm_id%TYPE
                   ) IS
  BEGIN
    DELETE
      NM_SAVED_EXTENT_MEMBERS
    WHERE
      nsm_id = pi_nsm_id;
  END;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE del_nse(pi_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE
                   ) IS

    CURSOR c1(p_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS
      SELECT
        nsm_id
      FROM
        NM_SAVED_EXTENT_MEMBERS
      WHERE
        nsm_nse_id = p_nse_id;

  BEGIN
    FOR rec IN c1(pi_nse_id) LOOP
      del_nsm(pi_nsm_id => rec.nsm_id);
    END LOOP;

    DELETE
      NM_SAVED_EXTENTS
    WHERE
      nse_id = pi_nse_id;

  END del_nse;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE del_members(pi_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS

    CURSOR c1(p_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS
      SELECT
        nsm.nsm_id
      FROM
        NM_SAVED_EXTENT_MEMBERS nsm
      WHERE
        nsm.nsm_nse_id = p_nse_id;

  BEGIN
    FOR l_rec IN c1(pi_nse_id)
    LOOP
    	Nm3extent.del_nsd(pi_nsm_id => l_rec.nsm_id);
    	Nm3extent.del_nsm(pi_nsm_id => l_rec.nsm_id);
    END LOOP;
  END;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE pop_nsd_datum(pi_nsm_rec IN NM_SAVED_EXTENT_MEMBERS%ROWTYPE
                         ) IS

    l_nsd_rec NM_SAVED_EXTENT_MEMBER_DATUMS%ROWTYPE;

  BEGIN
    l_nsd_rec.nsd_nse_id      := pi_nsm_rec.nsm_nse_id;
    l_nsd_rec.nsd_nsm_id      := pi_nsm_rec.nsm_id;
    l_nsd_rec.nsd_ne_id       := pi_nsm_rec.nsm_ne_id;
    l_nsd_rec.nsd_begin_mp    := pi_nsm_rec.nsm_begin_mp;
    l_nsd_rec.nsd_end_mp      := pi_nsm_rec.nsm_end_mp;
    l_nsd_rec.nsd_seq_no      := 1;
    l_nsd_rec.nsd_cardinality := 1;

    ins_nsd(l_nsd_rec);
  END pop_nsd_datum;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE pop_nsd_linear(pi_nsm_rec NM_SAVED_EXTENT_MEMBERS%ROWTYPE
                          ) IS

    l_rvs_sub_class NM_TYPE_SUBCLASS.nsc_sub_class%TYPE;

    l_pl nm_placement_array;

    l_nsd_tab tab_nsd;

  BEGIN
    IF pi_nsm_rec.nsm_sub_class IS NOT NULL
    THEN
      l_rvs_sub_class := Nm3rvrs.reverse_sub_class(pi_nt_type    => Nm3net.get_datum_nt(pi_ne_id => pi_nsm_rec.nsm_ne_id)
                                                  ,pi_sub_class  => pi_nsm_rec.nsm_sub_class
                                                  ,pi_error_flag => 'Y');
    ELSE
      l_rvs_sub_class := NULL;
    END IF;

    --create placement array of connected sections along route
    l_pl := Nm3pla.get_connected_extent(pi_st_lref   => nm_lref(pi_nsm_rec.nsm_begin_sect, pi_nsm_rec.nsm_begin_sect_offset)
                                       ,pi_end_lref  => nm_lref(pi_nsm_rec.nsm_end_sect, pi_nsm_rec.nsm_end_sect_offset)
                                       ,pi_route     => pi_nsm_rec.nsm_ne_id
                                       ,pi_sub_class => l_rvs_sub_class);

    --delete child datum records
    del_nsd(pi_nsm_rec.nsm_id);

    --insert datum sub elements
    IF l_pl.npa_placement_array.COUNT > 0
    THEN
      FOR l_i IN l_pl.npa_placement_array.FIRST..l_pl.npa_placement_array.LAST
      LOOP
        l_nsd_tab(l_i).nsd_nse_id      := pi_nsm_rec.nsm_nse_id;
        l_nsd_tab(l_i).nsd_nsm_id      := pi_nsm_rec.nsm_id;
        l_nsd_tab(l_i).nsd_ne_id       := l_pl.npa_placement_array(l_i).pl_ne_id;
        l_nsd_tab(l_i).nsd_begin_mp    := l_pl.npa_placement_array(l_i).pl_start;
        l_nsd_tab(l_i).nsd_end_mp      := l_pl.npa_placement_array(l_i).pl_end;
        l_nsd_tab(l_i).nsd_seq_no      := l_i;
        l_nsd_tab(l_i).nsd_cardinality := 1;
      END LOOP;

      ins_nsd(l_nsd_tab);
    END IF;
  END pop_nsd_linear;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE pop_nsd_non_linear(pi_nsm_rec NM_SAVED_EXTENT_MEMBERS%ROWTYPE
                              ) IS

    CURSOR c1(p_group IN nm_elements.ne_id%TYPE) IS
      SELECT
        nm_ne_id_of ne_id,
        nm_begin_mp,
        nm_end_mp
  		FROM
  		  nm_members
  		WHERE
  		  Nm3net.get_ne_gty(nm_ne_id_of) IS NULL
  		CONNECT BY
  		  PRIOR nm_ne_id_of = nm_ne_id_in
  		--AND
  		--  nm3net.get_ne_gty(nm_ne_id_of) IS NULL
  		START WITH
  		  nm_ne_id_in = p_group;

    l_nsd_rec NM_SAVED_EXTENT_MEMBER_DATUMS%ROWTYPE;

    l_i PLS_INTEGER := 0;

  BEGIN
    FOR rec IN c1(pi_nsm_rec.nsm_ne_id)
    LOOP
      l_i := l_i + 1;

      l_nsd_rec.nsd_nse_id      := pi_nsm_rec.nsm_nse_id;
      l_nsd_rec.nsd_nsm_id      := pi_nsm_rec.nsm_id;
      l_nsd_rec.nsd_ne_id       := rec.ne_id;
      l_nsd_rec.nsd_begin_mp    := rec.nm_begin_mp;
      l_nsd_rec.nsd_end_mp      := rec.nm_end_mp;
      l_nsd_rec.nsd_seq_no      := l_i;
      l_nsd_rec.nsd_cardinality := 1;

      BEGIN
        ins_nsd(l_nsd_rec);
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
          --ignore records that have already been added
          NULL;
      END;
    END LOOP;
  END pop_nsd_non_linear;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE pop_nsd_excl_sub_class(pi_nsm_rec IN NM_SAVED_EXTENT_MEMBERS%ROWTYPE
                                  ) IS

    l_pl nm_placement_array;

    l_nsd_tab tab_nsd;

  BEGIN
    --get placement array of all datums of specified sub class in extent
    l_pl := Nm3pla.get_pl_by_excl_sub_class(pi_st_lref   => nm_lref(lr_ne_id  => pi_nsm_rec.nsm_begin_sect
                                                                   ,lr_offset => pi_nsm_rec.nsm_begin_sect_offset)
                                           ,pi_end_lref  => nm_lref(lr_ne_id  => pi_nsm_rec.nsm_end_sect
                                                                   ,lr_offset => pi_nsm_rec.nsm_end_sect_offset)
                                           ,pi_route     => pi_nsm_rec.nsm_ne_id
                                           ,pi_sub_class => pi_nsm_rec.nsm_sub_class_excl);

    IF NOT(l_pl.is_empty)
    THEN
      --populate table with details of datums in extent
      FOR l_i IN l_pl.npa_placement_array.FIRST..l_pl.npa_placement_array.LAST
      LOOP
        l_nsd_tab(l_i).nsd_nse_id      := pi_nsm_rec.nsm_nse_id;
        l_nsd_tab(l_i).nsd_nsm_id      := pi_nsm_rec.nsm_id;
        l_nsd_tab(l_i).nsd_ne_id       := l_pl.npa_placement_array(l_i).pl_ne_id;
        l_nsd_tab(l_i).nsd_begin_mp    := l_pl.npa_placement_array(l_i).pl_start;
        l_nsd_tab(l_i).nsd_end_mp      := l_pl.npa_placement_array(l_i).pl_end;
        l_nsd_tab(l_i).nsd_seq_no      := l_i;
        l_nsd_tab(l_i).nsd_cardinality := 1;
      END LOOP;

      --insert table data into nsd
      ins_nsd(pi_tab_rec_nsd => l_nsd_tab);
    END IF;
  END;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE pop_nsd(pi_nsm_id IN NM_SAVED_EXTENT_MEMBERS.nsm_id%TYPE
                   ) IS

    l_nsm_rec NM_SAVED_EXTENT_MEMBERS%ROWTYPE;

    l_ne_gty nm_elements.ne_gty_group_type%TYPE;

  BEGIN
    --get nsm details
    l_nsm_rec := get_nsm(pi_nsm_id => pi_nsm_id);

    --get group type of nsm element
    l_ne_gty := Nm3net.get_ne_gty(l_nsm_rec.nsm_ne_id);

    --pop nsd based on type of nsm
    IF l_ne_gty IS NULL
    THEN
      --nsm is a datum
      pop_nsd_datum(pi_nsm_rec => l_nsm_rec);

    ELSIF l_nsm_rec.nsm_restrict_excl_sub_class = 'Y'
    THEN
      --exclusive sub class nsm
      pop_nsd_excl_sub_class(pi_nsm_rec => l_nsm_rec);

    ELSIF NVL(Nm3net.is_gty_linear(l_ne_gty), 'N') = 'Y'
    THEN
      --nsm is linear
      pop_nsd_linear(pi_nsm_rec => l_nsm_rec);

    ELSE
      --nsm is non linear
      pop_nsd_non_linear(pi_nsm_rec => l_nsm_rec);
    END IF;
  END pop_nsd;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE check_valid_source
                  (pi_source IN NM_PBI_QUERY_RESULTS.nqr_source%TYPE) IS
  BEGIN
     IF pi_source NOT IN (c_saved,c_route,c_pbi,c_pbi_sect,c_gis,c_merge_sect,c_temp_ne, c_merge)
      THEN
        RAISE_APPLICATION_ERROR(-20211,'Invalid source for temporary extent '||pi_source);
     END IF;
  END check_valid_source;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_roi (pi_roi_id                    IN     NM_PBI_QUERY_RESULTS.nqr_source_id%TYPE
                                    ,pi_roi_type                  IN     NM_PBI_QUERY_RESULTS.nqr_source%TYPE
                                    ,po_job_id                       OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                    ,pi_default_source_as_parent  IN     BOOLEAN DEFAULT FALSE
                                    ,pi_ignore_non_linear_parents IN     BOOLEAN DEFAULT FALSE
                                    ) IS
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_temp_ne_from_roi');
  --
     create_temp_ne (pi_source_id                 => pi_roi_id
                    ,pi_source                    => get_nte_source_from_roi_type(pi_roi_type)
                    ,pi_begin_mp                  => NULL
                    ,pi_end_mp                    => NULL
                    ,po_job_id                    => po_job_id
                    ,pi_default_source_as_parent  => pi_default_source_as_parent
                    ,pi_ignore_non_linear_parents => pi_ignore_non_linear_parents
                    );
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne_from_roi');
  --
  END create_temp_ne_from_roi;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne (pi_source_id                 IN     NM_PBI_QUERY_RESULTS.nqr_source_id%TYPE
                           ,pi_source                    IN     NM_PBI_QUERY_RESULTS.nqr_source%TYPE
                           ,pi_begin_mp                  IN     nm_members.nm_begin_mp%TYPE DEFAULT NULL
                           ,pi_end_mp                    IN     nm_members.nm_end_mp%TYPE DEFAULT NULL
                           ,po_job_id                       OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                           ,pi_default_source_as_parent  IN     BOOLEAN DEFAULT FALSE
                           ,pi_ignore_non_linear_parents IN     BOOLEAN DEFAULT FALSE
                           ,pi_source_id_2               IN     NM_PBI_QUERY_RESULTS.nqr_source_id%TYPE DEFAULT NULL
                           ) IS
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_temp_ne');
  --
     check_valid_source(pi_source);
  --
     IF    pi_source <> c_route
      AND (pi_begin_mp IS NOT NULL
           OR pi_end_mp IS NOT NULL
          )
      THEN
        g_extent_exc_code  := -20215;
        g_extent_exc_msg   := 'begin_mp and end_mp only valid for source of '||c_route;
        RAISE g_extent_exception;
     END IF;
  --
     DECLARE
        l_temp_ne_source EXCEPTION;
     BEGIN
        IF pi_source = c_temp_ne
         THEN
           -- If the source is a temp ne
           --  then just return itself
           po_job_id := pi_source_id;
           RAISE l_temp_ne_source;
        END IF;
     --
        g_last_temp_extent_source_id := NULL;
        g_last_temp_extent_source    := NULL;
        g_last_nte_job_id            := -1;
     --
        IF    pi_source = c_saved
         THEN
     --
           create_temp_ne_from_saved_ne (pi_source_id, po_job_id);
     --
        ELSIF pi_source = c_route
         THEN
     --
           create_temp_ne_from_route (pi_source_id
                                     ,pi_begin_mp
                                     ,pi_end_mp
                                     ,po_job_id
                                     ,pi_default_source_as_parent
                                     ,pi_ignore_non_linear_parents
                                     );
     --
        ELSIF pi_source = c_pbi
         THEN
     --
           create_temp_ne_from_pbi (pi_source_id, po_job_id);
     --
        ELSIF pi_source = c_pbi_sect
         THEN
     --
           create_temp_ne_from_pbi_sect(pi_pbi_job_id => pi_source_id
                                       ,pi_section_id => pi_source_id_2
                                       ,po_job_id     => po_job_id);
     --
        ELSIF pi_source = c_merge
         THEN
     --
           create_temp_ne_from_merge (pi_source_id, po_job_id);
     --
        ELSIF pi_source = c_merge_sect
         THEN
     --
           create_temp_ne_from_mrg_sect(pi_mrg_job_id => pi_source_id
                                       ,pi_section_id => pi_source_id_2
                                       ,po_job_id     => po_job_id);
     --
        ELSIF pi_source = c_gis
         THEN
     --
           create_temp_ne_from_gis (pi_source_id, po_job_id);
     --
        END IF;
     --
     EXCEPTION
        WHEN l_temp_ne_source
         THEN
           NULL;
     END;
     --
     IF g_last_nte_job_id != po_job_id
      THEN
        -- If this temp ne is a different number
        --  to the last one we had then set the fields
        -- This is so that we still end up with a sensible
        --  source when we create a temp ne from a temp ne
        g_last_temp_extent_source_id := pi_source_id;
        g_last_temp_extent_source    := pi_source;
        g_last_nte_job_id            := po_job_id;
     END IF;
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne');
  --
  EXCEPTION
  --
     WHEN g_extent_exception
      THEN
        RAISE_APPLICATION_ERROR(g_extent_exc_code,g_extent_exc_msg);
  --
  END create_temp_ne;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_saved_ne
                  (pi_nse_id IN     NM_SAVED_EXTENTS.nse_id%TYPE
                  ,po_job_id    OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  ) IS
  --
     CURSOR cs_saved (p_nse_id NUMBER) IS
     SELECT  nsd_ne_id
            ,nsd_begin_mp
            ,nsd_end_mp
            ,nsd_cardinality
            ,nsd_ne_id --nm3net.get_parent_ne_id(nsd_ne_id,nm3net.get_parent_type(nm3net.get_nt_type(nsd_ne_id)))
      FROM   NM_SAVED_EXTENT_MEMBERS
            ,NM_SAVED_EXTENT_MEMBER_DATUMS
      WHERE  nsm_nse_id = p_nse_id
       AND   nsd_nse_id = nsm_nse_id
       AND   nsd_nsm_id = nsm_id
      ORDER BY nsm_seq_no, nsd_seq_no;
  --
     l_rec_nse NM_SAVED_EXTENTS%ROWTYPE;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_temp_ne_from_saved_ne');
  --
     l_rec_nse := get_nse (pi_nse_id);
  --
     -- Get the job_id
     po_job_id := Nm3net.get_next_nte_id;
  --
     OPEN  cs_saved (pi_nse_id);
     FETCH cs_saved
      BULK COLLECT
      INTO g_tab_nte_ne_id_of
          ,g_tab_nte_begin_mp
          ,g_tab_nte_end_mp
          ,g_tab_nte_cardinality
          ,g_tab_nte_route_ne_id;
     CLOSE cs_saved;
     FOR i IN 1..g_tab_nte_ne_id_of.COUNT
      LOOP
        g_tab_nte_seq_no(i) := i;
     END LOOP;
  --
     insert_nte_globals(po_job_id);
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne_from_saved_ne');
  --
  END create_temp_ne_from_saved_ne;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_route
                  (pi_route_ne_id               IN     nm_elements.ne_id%TYPE
                  ,pi_begin_mp                  IN     nm_members.nm_begin_mp%TYPE DEFAULT NULL
                  ,pi_end_mp                    IN     nm_members.nm_end_mp%TYPE DEFAULT NULL
                  ,po_job_id                       OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  ,pi_default_route_as_parent   IN     BOOLEAN DEFAULT FALSE
                  ,pi_ignore_non_linear_parents IN     BOOLEAN DEFAULT FALSE
                  ) IS

     CURSOR cs_group_of_groups (c_ne_id NUMBER) IS
     SELECT nm_ne_id_of
           ,nm_begin_mp
           ,ne_length
           ,nm_cardinality
           ,route_ne_id
      FROM (SELECT nm_ne_id_in
                  ,nm_ne_id_of
                  ,nm_begin_mp
                  ,NVL(nm_end_mp,ne_length) ne_length
                  ,nm_cardinality
                  ,nm_seq_no
                  ,nm_ne_id_of route_ne_id
             FROM (SELECT nm_ne_id_in
                         ,nm_ne_id_of
                         ,nm_begin_mp
                         ,nm_end_mp
                         ,nm_cardinality
                         ,nm_seq_no
                    FROM  nm_members
                   CONNECT BY PRIOR nm_ne_id_of = nm_ne_id_in
                   START WITH nm_ne_id_in       = c_ne_id
                  )
                 ,nm_elements
            WHERE  nm_ne_id_of = ne_id
             AND   ne_type     = 'S'
           )
     ORDER BY nm_ne_id_in, nm_seq_no;
--
     CURSOR cs_location (c_ne_id NUMBER) IS
     SELECT nm_ne_id_of
           ,nm_begin_mp
           ,nm_end_mp
           ,nm_cardinality
           ,nm_ne_id_of --nm3net.get_parent_ne_id(nm_ne_id_of,nm3net.get_parent_type(ne_nt_type))
       FROM nm_members
      WHERE nm_ne_id_in = c_ne_id
     ORDER BY nm_seq_no;
  --
     l_pl_arr nm_placement_array;
     l_pl     nm_placement;
  --
     l_rec_ne  nm_elements%ROWTYPE;
  --
     l_rec_iit nm_inv_items%ROWTYPE;
     l_rec_nte NM_NW_TEMP_EXTENTS%ROWTYPE;
  --
     l_check_inv           BOOLEAN := FALSE;
     l_section_only        BOOLEAN := FALSE;
     l_group_of_groups     BOOLEAN := FALSE;
  --
     l_insert_using_pl_arr BOOLEAN := FALSE;

     l_pl_parent_id nm_elements.ne_id%TYPE;

     l_lref_tab     Nm3lrs.lref_table;

     l_parent_units NM_UNITS.un_unit_id%TYPE;
     l_child_units  NM_UNITS.un_unit_id%TYPE;
  
     -- LS 
     l_nm_lref      nm_lref ;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_temp_ne_from_route');
  --
     DECLARE
        no_nm_elements_found EXCEPTION;
        PRAGMA EXCEPTION_INIT (no_nm_elements_found,-20001);
     BEGIN
        l_rec_ne  := Nm3net.get_ne (pi_route_ne_id);
        IF l_rec_ne.ne_type = 'S'
         THEN
           l_section_only := TRUE;
        ELSIF l_rec_ne.ne_type = 'P'
         THEN
           l_group_of_groups := TRUE;
        END IF;
     EXCEPTION
        WHEN no_nm_elements_found
         THEN
           -- If no NM_ELEMENTS record found for this one
           --  then it may be an inventory item so have a look
           l_check_inv := TRUE;
     END;
--
     IF l_check_inv
      THEN
        l_rec_iit := Nm3inv.get_inv_item(pi_route_ne_id);
        IF l_rec_iit.iit_ne_id IS NULL
         THEN
           -- If there's no inventory found then is doesn't
           --  exist so splatter
           g_extent_exc_code  := -20213;
           g_extent_exc_msg   := 'NE_ID : '||pi_route_ne_id||' not found, neither on NM_ELEMENTS nor on NM_INV_ITEMS';
           RAISE g_extent_exception;
        END IF;
     END IF;
  --
     -- Get the job_id
     po_job_id := Nm3net.get_next_nte_id;
  --
     IF l_section_only
      THEN
        -- If we are operating only on a single section then create a single
        --  entry in the placement array with the details for that element
        l_pl_arr := Nm3pla.initialise_placement_array
                                    (pi_ne_id   => pi_route_ne_id
                                    ,pi_start   => NVL(pi_begin_mp,0)
                                    ,pi_end     => NVL(pi_end_mp,l_rec_ne.ne_length)
                                    ,pi_measure => 0
                                    );
        l_insert_using_pl_arr := TRUE;
     ELSIF NOT l_group_of_groups
      THEN
        -- If we are dealing with a group of sections or an inventory
        --  item then do nm3pla.get_placement_from_ne to get all of
        --  the membership records for that ne_id
        --
        IF  (pi_begin_mp IS NULL
            AND pi_end_mp   IS NULL
            )
         OR l_check_inv
         THEN
           --
           OPEN  cs_location (pi_route_ne_id);
           FETCH cs_location
            BULK COLLECT
            INTO g_tab_nte_ne_id_of
                ,g_tab_nte_begin_mp
                ,g_tab_nte_end_mp
                ,g_tab_nte_cardinality
                ,g_tab_nte_route_ne_id;
           CLOSE cs_location;
           FOR i IN 1..g_tab_nte_ne_id_of.COUNT
            LOOP
              g_tab_nte_seq_no(i) := i;
           END LOOP;
	   insert_nte_globals(po_job_id);
        ELSE
           IF pi_begin_mp = pi_end_mp
           THEN
             --point on the route
             --Nm3net.get_group_units(pi_ne_id       => pi_route_ne_id
             --                      ,po_group_units => l_parent_units
             --                      ,po_child_units => l_child_units);

             --Nm3lrs.get_ambiguous_lrefs(p_parent_id    => pi_route_ne_id
             --                          ,p_parent_units => l_parent_units
             --                          ,p_datum_units  => l_child_units
             --                          ,p_offset       => pi_begin_mp
             --                          ,p_lrefs        => l_lref_tab);

             --IF l_lref_tab.COUNT = 1
             --THEN
             --  l_pl_arr := Nm3pla.initialise_placement_array(pi_ne_id   => l_lref_tab(1).r_ne_id
             --                                               ,pi_start   => l_lref_tab(1).r_offset
             --                                               ,pi_end     => l_lref_tab(1).r_offset
             --                                               ,pi_measure => 0);

             --  l_insert_using_pl_arr := TRUE;

             --ELSIF l_lref_tab.COUNT > 1
             --THEN
               --route reference is ambiguous
             --  Hig.raise_ner(pi_appl               => Nm3type.c_net
             --               ,pi_id                 => 312
             --               ,pi_supplementary_info => Nm3net.get_ne_unique(p_ne_id => pi_route_ne_id)
             --                                        || ':' || pi_begin_mp);
             --ELSE
               --no datum reference found
             l_nm_lref := NM3LRS.GET_DISTINCT_OFFSET(nm_lref(pi_route_ne_id, pi_begin_mp)) ;
             IF l_nm_lref.lr_ne_id IS NULL
             THEN
               --no datum reference found
               Hig.raise_ner(pi_appl               => Nm3type.c_net
                            ,pi_id                 => 85
                            ,pi_supplementary_info => Nm3net.get_ne_unique(p_ne_id => pi_route_ne_id)
                                                      || ':' || pi_begin_mp);
             END IF;
             l_pl_arr := Nm3pla.initialise_placement_array(pi_ne_id   => l_nm_lref.lr_ne_id
                                                          ,pi_start   => l_nm_lref.lr_offset
                                                          ,pi_end     => l_nm_lref.lr_offset
                                                          ,pi_measure => 0);

             l_insert_using_pl_arr := TRUE;
           ELSE
             --continuous extent
             l_pl_arr := Nm3pla.get_sub_placement (nm_placement(pi_route_ne_id,pi_begin_mp,pi_end_mp,0));
             l_insert_using_pl_arr := TRUE;
             IF l_pl_arr.is_empty
              THEN
                g_extent_exc_code  := -20212;
                g_extent_exc_msg   := 'No values in placement array for '||pi_route_ne_id;
                RAISE g_extent_exception;
             END IF;
           END IF;
        END IF;
--
     ELSE -- Group of groups
--
	     OPEN  cs_group_of_groups (pi_route_ne_id);
	     FETCH cs_group_of_groups
	      BULK COLLECT
	      INTO g_tab_nte_ne_id_of
	          ,g_tab_nte_begin_mp
	          ,g_tab_nte_end_mp
	          ,g_tab_nte_cardinality
	          ,g_tab_nte_route_ne_id;
	     CLOSE cs_group_of_groups;
	     FOR i IN 1..g_tab_nte_ne_id_of.COUNT
	      LOOP
	        g_tab_nte_seq_no(i) := i;
	     END LOOP;
	  --
	     insert_nte_globals(po_job_id);
  --
     END IF;
  --
     IF l_insert_using_pl_arr
      THEN
        IF pi_default_route_as_parent
        THEN
          l_pl_parent_id := pi_route_ne_id;
        END IF;

        Nm3extent_O.create_temp_ne_from_pl(pi_pl_arr                    => l_pl_arr
                                          ,po_job_id                    => po_job_id
                                          ,pi_default_parent_id         => l_pl_parent_id
                                          ,pi_ignore_non_linear_parents => pi_ignore_non_linear_parents);
     END IF;
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne_from_route');
  --
  END create_temp_ne_from_route;
  --
  -------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_pbi
                  (pi_pbi_job_id IN     NM_PBI_QUERY_RESULTS.nqr_job_id%TYPE
                  ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  ) IS
  --
     CURSOR cs_nqm (p_job_id NUMBER) IS
     SELECT npm.npm_ne_id_of
           ,npm.npm_begin_mp
           ,npm.npm_end_mp
           ,Nm3net.get_cardinality(nps.nps_offset_ne_id,npm.npm_ne_id_of)
           ,nps.nps_offset_ne_id
      FROM  NM_PBI_SECTION_MEMBERS npm
           ,NM_PBI_SECTIONS        nps
     WHERE  npm.npm_nqr_job_id = p_job_id
      AND   nps.nps_npq_id     = npm.npm_npq_id
      AND   nps.nps_nqr_job_id = npm.npm_nqr_job_id
      AND   nps.nps_section_id = npm.npm_nps_section_id
     ORDER BY nps.nps_section_id, npm.npm_measure;
  --

     l_rec_nqr NM_PBI_QUERY_RESULTS%ROWTYPE;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_temp_ne_from_pbi');
  --
     l_rec_nqr := Nm3pbi.select_npr (pi_pbi_job_id);
  --
     -- Get the job_id
     po_job_id := Nm3net.get_next_nte_id;
  --
     OPEN  cs_nqm (pi_pbi_job_id);
     FETCH cs_nqm
      BULK COLLECT
      INTO g_tab_nte_ne_id_of
          ,g_tab_nte_begin_mp
          ,g_tab_nte_end_mp
          ,g_tab_nte_cardinality
          ,g_tab_nte_route_ne_id;
     CLOSE cs_nqm;
     FOR i IN 1..g_tab_nte_ne_id_of.COUNT
      LOOP
        g_tab_nte_seq_no(i) := i;
     END LOOP;
  --
     insert_nte_globals(po_job_id);
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne_from_pbi');
  --
  END create_temp_ne_from_pbi;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_pbi_sect(pi_pbi_job_id IN     NM_PBI_QUERY_RESULTS.nqr_job_id%TYPE
                                        ,pi_section_id IN     NM_PBI_SECTIONS.nps_section_id%TYPE
                                        ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                        ) IS

     l_rec_nqr NM_PBI_QUERY_RESULTS%ROWTYPE;

  BEGIN
     Nm_Debug.proc_start(g_package_name,'create_temp_ne_from_pbi_sect');
  --
     l_rec_nqr := Nm3pbi.select_npr (pi_pbi_job_id);
  --
     -- Get the job_id
     po_job_id := Nm3net.get_next_nte_id;
  --
     --In the following query cardinality is hardcoded to 1. It should
     --really be: nm3net.get_cardinality(nps.nps_offset_ne_id,npm.npm_ne_id_of)
     --but pbi section only has one parent route id against it. If
     --section spans multiple routes then get_cardinality will fail. This is
     --a structural flaw in the mrg tables. Query will need to be changed
     --when the structure has changed.

     SELECT
       npm.npm_ne_id_of,
       npm.npm_begin_mp,
       npm.npm_end_mp,
       1,
       nps.nps_offset_ne_id
     BULK COLLECT INTO
       g_tab_nte_ne_id_of,
       g_tab_nte_begin_mp,
       g_tab_nte_end_mp,
       g_tab_nte_cardinality,
       g_tab_nte_route_ne_id
     FROM
       NM_PBI_SECTIONS        nps,
       NM_PBI_SECTION_MEMBERS npm
     WHERE
       nps.nps_nqr_job_id = pi_pbi_job_id
     AND
       nps.nps_section_id = pi_section_id
     AND
       npm.npm_npq_id = nps.nps_npq_id
     AND
       npm.npm_nqr_job_id = nps.nps_nqr_job_id
     AND
       npm.npm_nps_section_id = nps.nps_section_id
     ORDER BY
        npm.npm_measure;

     FOR i IN 1..g_tab_nte_ne_id_of.COUNT
     LOOP
       g_tab_nte_seq_no(i) := i;
     END LOOP;
  --
     insert_nte_globals(po_job_id);
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne_from_pbi_sect');
  --
  END create_temp_ne_from_pbi_sect;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_merge
                  (pi_mrg_job_id IN     nm_mrg_query_results.nqr_mrg_job_id%TYPE
                  ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  ) IS
  --
     CURSOR cs_nsm (p_job_id NUMBER) IS
     SELECT nsm.nsm_ne_id
           ,nsm.nsm_begin_mp
           ,nsm.nsm_end_mp
           ,Nm3net.get_cardinality(nms.nms_offset_ne_id,nsm.nsm_ne_id)
           ,nms.nms_offset_ne_id
      FROM  NM_MRG_SECTION_MEMBERS nsm
           ,nm_mrg_sections        nms
     WHERE  nms.nms_mrg_job_id     = p_job_id
      AND   nms.nms_mrg_job_id     = nsm.nsm_mrg_job_id
      AND   nms.nms_mrg_section_id = nsm.nsm_mrg_section_id
     ORDER BY nms.nms_mrg_section_id, nsm.nsm_measure;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_temp_ne_from_merge');
  --
     -- Get the job_id
     po_job_id := Nm3net.get_next_nte_id;
  --
     OPEN  cs_nsm (pi_mrg_job_id);
     FETCH cs_nsm
      BULK COLLECT
      INTO g_tab_nte_ne_id_of
          ,g_tab_nte_begin_mp
          ,g_tab_nte_end_mp
          ,g_tab_nte_cardinality
          ,g_tab_nte_route_ne_id;
     CLOSE cs_nsm;
     FOR i IN 1..g_tab_nte_ne_id_of.COUNT
      LOOP
        g_tab_nte_seq_no(i) := i;
     END LOOP;
  --
     insert_nte_globals(po_job_id);
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne_from_merge');
  --
  END create_temp_ne_from_merge;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_mrg_sect(pi_mrg_job_id IN     nm_mrg_sections.nms_mrg_job_id%TYPE
                                        ,pi_section_id IN     nm_mrg_sections.nms_mrg_section_id%TYPE
                                        ,po_job_id        OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                        ) IS
  BEGIN
    Nm_Debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'create_temp_ne_from_mrg_sect');

    po_job_id := Nm3net.get_next_nte_id;

    --In the following query cardinality is hardcoded to 1. It should
    --really be: nm3net.get_cardinality(nms.nms_offset_ne_id, nsm.nsm_ne_id)
    --but mrg section only has one parent route id against it. If
    --section spans multiple routes then get_cardinality will fail. This is
    --a structural flaw in the mrg tables. Query will need to be changed
    --when the structure has changed.

    SELECT
      nsm.nsm_ne_id,
      nsm.nsm_begin_mp,
      nsm.nsm_end_mp,
      1,
      nms.nms_offset_ne_id
    BULK COLLECT INTO
      g_tab_nte_ne_id_of,
      g_tab_nte_begin_mp,
      g_tab_nte_end_mp,
      g_tab_nte_cardinality,
      g_tab_nte_route_ne_id
    FROM
      nm_mrg_sections        nms,
      NM_MRG_SECTION_MEMBERS nsm
    WHERE
      nms.nms_mrg_job_id = pi_mrg_job_id
    AND
      nms.nms_mrg_section_id = pi_section_id
    AND
      nsm.nsm_mrg_job_id = nms.nms_mrg_job_id
    AND
      nsm.nsm_mrg_section_id = nms.nms_mrg_section_id
    ORDER BY
      nsm.nsm_measure;

    FOR l_i IN 1..g_tab_nte_ne_id_of.COUNT
    LOOP
       g_tab_nte_seq_no(l_i) := l_i;
    END LOOP;

    insert_nte_globals(po_job_id);

    Nm_Debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_temp_ne_from_mrg_sect');

  END create_temp_ne_from_mrg_sect;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_saved_ne_from_ne_id
                           (pi_ne_id     IN     nm_members.nm_ne_id_in%TYPE
                           ,pi_begin_mp  IN     nm_members.nm_begin_mp%TYPE     DEFAULT NULL
                           ,pi_end_mp    IN     nm_members.nm_end_mp%TYPE       DEFAULT NULL
                           ,pi_nse_owner IN     NM_SAVED_EXTENTS.nse_owner%TYPE DEFAULT USER
                           ,pi_nse_name  IN     NM_SAVED_EXTENTS.nse_name%TYPE  DEFAULT NULL
                           ,pi_nse_descr IN     NM_SAVED_EXTENTS.nse_descr%TYPE DEFAULT NULL
                           ,po_nse_id       OUT NM_SAVED_EXTENTS.nse_id%TYPE
                           ) IS
  --
     l_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
     l_nse_name   NM_SAVED_EXTENTS.nse_name%TYPE  := pi_nse_name;
     l_nse_descr  NM_SAVED_EXTENTS.nse_descr%TYPE := pi_nse_descr;
  --
     l_check_inv  BOOLEAN;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_saved_ne_from_ne_id');
  --
     --nm_debug.debug('Creating Temp NE from route');
     create_temp_ne_from_route
                  (pi_route_ne_id => pi_ne_id
                  ,pi_begin_mp    => pi_begin_mp
                  ,pi_end_mp      => pi_end_mp
                  ,po_job_id      => l_nte_job_id
                  );
  --
     --nm_debug.debug('looking at the name');
     IF l_nse_name IS NULL
      THEN
        DECLARE
           l_rec_ne nm_elements%ROWTYPE;
           no_ele   EXCEPTION;
           PRAGMA EXCEPTION_INIT (no_ele, -20001);
        BEGIN
           --
           l_rec_ne    := Nm3net.get_ne (pi_ne_id);
           l_nse_name  := l_rec_ne.ne_unique;
           l_nse_descr := l_rec_ne.ne_descr;
           --
           l_check_inv := FALSE;
        EXCEPTION
           WHEN no_ele
            THEN
              l_check_inv := TRUE;
        END;
        IF l_check_inv
         THEN
           DECLARE
              l_rec_iit nm_inv_items%ROWTYPE;
           BEGIN
              l_rec_iit   := Nm3inv.get_inv_item (pi_ne_id);
              l_nse_name  := Nm3flx.LEFT(l_rec_iit.iit_inv_type||':'||l_rec_iit.iit_primary_key,30);
              l_nse_descr := l_rec_iit.iit_descr;
           END;
        END IF;
     END IF;
     IF l_nse_name  IS NULL
      THEN
        -- Somehow it's neither a NM_ELEMENT nor a NM_INV_ITEMS record....
        l_nse_name  := pi_ne_id;
     END IF;
     IF l_nse_descr IS NULL
      THEN
        l_nse_descr := 'Created '||TO_CHAR(SYSDATE,'DD-Mon-YYYY HH24:MI:SS');
     END IF;
  --
     --nm_debug.debug('Creating saved NE from Temp NE');
     create_saved_ne_from_temp_ne
                  (pi_nte_job_id => l_nte_job_id
                  ,pi_nse_owner  => pi_nse_owner
                  ,pi_nse_name   => l_nse_name
                  ,pi_nse_descr  => l_nse_descr
                  ,po_nse_id     => po_nse_id
                  );
  --
     Nm_Debug.proc_end(g_package_name,'create_saved_ne_from_ne_id');
  --
  END create_saved_ne_from_ne_id;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_saved_ne_from_temp_ne
                           (pi_nte_job_id IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                           ,pi_nse_owner  IN     NM_SAVED_EXTENTS.nse_owner%TYPE DEFAULT USER
                           ,pi_nse_name   IN     NM_SAVED_EXTENTS.nse_name%TYPE
                           ,pi_nse_descr  IN     NM_SAVED_EXTENTS.nse_descr%TYPE
                           ,po_nse_id        OUT NM_SAVED_EXTENTS.nse_id%TYPE
                           ) IS
  --
     CURSOR cs_nte (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
     SELECT nte_ne_id_of
           ,nte_begin_mp
           ,nte_end_mp
           ,nte_cardinality
           ,nte_seq_no
           ,Nm3extent.get_next_nsm_id
      FROM  NM_NW_TEMP_EXTENTS
     WHERE  nte_job_id = c_nte_job_id
     ORDER BY nte_seq_no;
  --
     l_tab_ne_id       Nm3type.tab_number;
     l_tab_begin_mp    Nm3type.tab_number;
     l_tab_end_mp      Nm3type.tab_number;
     l_tab_cardinality Nm3type.tab_number;
     l_tab_seq_no      Nm3type.tab_number;
     l_tab_nsm_id      Nm3type.tab_number;
  --
     l_rec_nse NM_SAVED_EXTENTS%ROWTYPE;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_saved_ne_from_temp_ne');
  --
    --
     po_nse_id           := get_next_nse_id;
  --
     l_rec_nse.nse_id    := po_nse_id;
     l_rec_nse.nse_owner := NVL(pi_nse_owner,USER);
     l_rec_nse.nse_name  := pi_nse_name;
     l_rec_nse.nse_descr := NVL(pi_nse_descr
                               ,'Saved extent created from temp_ne'
                               );
     l_rec_nse.nse_pbi   := 'N';
  --
     ins_nse(l_rec_nse);
  --
     OPEN  cs_nte (pi_nte_job_id);
     FETCH cs_nte
      BULK COLLECT
      INTO l_tab_ne_id
          ,l_tab_begin_mp
          ,l_tab_end_mp
          ,l_tab_cardinality
          ,l_tab_seq_no
          ,l_tab_nsm_id;
     CLOSE cs_nte;
  --
     FORALL i IN 1..l_tab_ne_id.COUNT
        INSERT INTO NM_SAVED_EXTENT_MEMBERS
               (nsm_nse_id
               ,nsm_id
               ,nsm_ne_id
               ,nsm_begin_mp
               ,nsm_end_mp
               ,nsm_seq_no
               ,nsm_datum
               ,nsm_restrict_excl_sub_class
               )
        VALUES (l_rec_nse.nse_id
               ,l_tab_nsm_id(i)
               ,l_tab_ne_id(i)
               ,l_tab_begin_mp(i)
               ,l_tab_end_mp(i)
               ,l_tab_seq_no(i)
               ,'Y'
               ,'N'
               );
--
     FORALL i IN 1..l_tab_ne_id.COUNT
        INSERT INTO NM_SAVED_EXTENT_MEMBER_DATUMS
               (nsd_nse_id
               ,nsd_nsm_id
               ,nsd_ne_id
               ,nsd_begin_mp
               ,nsd_end_mp
               ,nsd_seq_no
               ,nsd_cardinality
               )
        VALUES (l_rec_nse.nse_id
               ,l_tab_nsm_id(i)
               ,l_tab_ne_id(i)
               ,l_tab_begin_mp(i)
               ,l_tab_end_mp(i)
               ,l_tab_seq_no(i)
               ,l_tab_cardinality(i)
               );
  --
     Nm_Debug.proc_end(g_package_name,'create_saved_ne_from_temp_ne');
  --
  END create_saved_ne_from_temp_ne;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nte (p_rec_nte NM_NW_TEMP_EXTENTS%ROWTYPE) IS
  BEGIN
  --
     INSERT INTO NM_NW_TEMP_EXTENTS
            (nte_job_id
            ,nte_ne_id_of
            ,nte_begin_mp
            ,nte_end_mp
            ,nte_cardinality
            ,nte_seq_no
            ,nte_route_ne_id
            )
     VALUES (p_rec_nte.nte_job_id
            ,p_rec_nte.nte_ne_id_of
            ,p_rec_nte.nte_begin_mp
            ,p_rec_nte.nte_end_mp
            ,p_rec_nte.nte_cardinality
            ,p_rec_nte.nte_seq_no
            ,p_rec_nte.nte_route_ne_id
            );
  --
  END ins_nte;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_saved RETURN NM_PBI_QUERY_RESULTS.nqr_source%TYPE IS
  BEGIN
     RETURN c_saved;
  END get_saved;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_temp_ne RETURN NM_PBI_QUERY_RESULTS.nqr_source%TYPE IS
  BEGIN
     RETURN c_temp_ne;
  END get_temp_ne;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_route RETURN NM_PBI_QUERY_RESULTS.nqr_source%TYPE IS
  BEGIN
     RETURN c_route;
  END get_route;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_pbi RETURN NM_PBI_QUERY_RESULTS.nqr_source%TYPE IS
  BEGIN
     RETURN c_pbi;
  END get_pbi;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_merge RETURN NM_PBI_QUERY_RESULTS.nqr_source%TYPE IS
  BEGIN
     RETURN c_merge;
  END get_merge;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_saved_ne_from_pbi
                  (pi_nqr_job_id IN     NM_PBI_QUERY_RESULTS.nqr_job_id%TYPE
                  ,pi_nse_owner  IN     NM_SAVED_EXTENTS.nse_owner%TYPE DEFAULT NULL
                  ,pi_nse_name   IN     NM_SAVED_EXTENTS.nse_name%TYPE  DEFAULT NULL
                  ,pi_nse_descr  IN     NM_SAVED_EXTENTS.nse_descr%TYPE DEFAULT NULL
                  ,po_nse_id        OUT NM_SAVED_EXTENTS.nse_id%TYPE
                  ) IS
  --
     l_rec_nqr NM_PBI_QUERY_RESULTS%ROWTYPE;
     l_rec_nse NM_SAVED_EXTENTS%ROWTYPE;
     l_rec_npq NM_PBI_QUERY%ROWTYPE;
  --
     CURSOR cs_nps (c_job_id NM_PBI_QUERY_RESULTS.nqr_job_id%TYPE) IS
     SELECT *
      FROM  NM_PBI_SECTIONS
     WHERE  nps_nqr_job_id = c_job_id;
  --
     CURSOR cs_npm (c_job_id NM_PBI_QUERY_RESULTS.nqr_job_id%TYPE
                   ,c_pl_id  NM_PBI_SECTIONS.nps_section_id%TYPE
                   ) IS
     SELECT *
      FROM  NM_PBI_SECTION_MEMBERS
     WHERE  npm_nqr_job_id      = c_job_id
      AND   npm_nps_section_id  = c_pl_id
     ORDER BY npm_measure;
  --
     l_pre_name  VARCHAR2(30);
     l_post_name VARCHAR2(30);
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_saved_ne_from_pbi');
  --
     l_rec_nqr := Nm3pbi.select_npr (pi_nqr_job_id);
  --
     l_rec_npq := Nm3pbi.get_npq (l_rec_nqr.nqr_npq_id);
  --
     po_nse_id           := get_next_nse_id;
  --
     l_rec_nse.nse_id    := po_nse_id;
     l_rec_nse.nse_owner := NVL(pi_nse_owner,USER);
     IF pi_nse_name IS NOT NULL
      THEN
        l_rec_nse.nse_name  := pi_nse_name;
     ELSE
        l_pre_name          := po_nse_id||'.';
        l_post_name         := '-'||pi_nqr_job_id;
        l_rec_nse.nse_name  := l_pre_name
                               ||SUBSTR(l_rec_npq.npq_unique,1,30-LENGTH(l_pre_name||l_post_name))
                               ||l_post_name;
     END IF;
     l_rec_nse.nse_descr := NVL(pi_nse_descr
                               ,'Saved extent created for '
                                ||l_rec_npq.npq_descr||', job_id '||pi_nqr_job_id
                                ||' run on '||TO_CHAR(l_rec_nqr.nqr_date_created,'DD-Mon-YYYY HH24:MI')
                               );
     l_rec_nse.nse_pbi   := 'Y';
  --
     ins_nse(l_rec_nse);
  --
     FOR cs_rec IN cs_nps (pi_nqr_job_id)
      LOOP
        DECLARE
           l_rec_nsm     NM_SAVED_EXTENT_MEMBERS%ROWTYPE;
           l_rec_nsd     NM_SAVED_EXTENT_MEMBER_DATUMS%ROWTYPE;
           l_datum_count PLS_INTEGER := 0;
--
           l_tab_rec_nsd tab_nsd;
     --
           CURSOR cs_nm (p_nm_ne_id_in NUMBER
                        ,p_nm_ne_id_of NUMBER
                        ) IS
           SELECT nm_cardinality
            FROM  nm_members
           WHERE  nm_ne_id_in = p_nm_ne_id_in
            AND   nm_ne_id_of = p_nm_ne_id_of;
     --
        BEGIN
--
           l_rec_nsm.nsm_nse_id                  := l_rec_nse.nse_id;
           l_rec_nsm.nsm_id                      := get_next_nsm_id;
           l_rec_nsm.nsm_seq_no                  := cs_rec.nps_section_id;
           l_rec_nsm.nsm_ne_id                   := cs_rec.nps_offset_ne_id;
           l_rec_nsm.nsm_begin_mp                := cs_rec.nps_begin_offset;
           l_rec_nsm.nsm_end_mp                  := cs_rec.nps_end_offset;
           l_rec_nsm.nsm_restrict_excl_sub_class := 'N';
--
           FOR cs_datum_rec IN cs_npm (pi_nqr_job_id, cs_rec.nps_section_id)
            LOOP
              --
              l_datum_count := l_datum_count + 1;
              --
              l_rec_nsd.nsd_nse_id      := l_rec_nsm.nsm_nse_id;
              l_rec_nsd.nsd_nsm_id      := l_rec_nsm.nsm_id;
              l_rec_nsd.nsd_ne_id       := cs_datum_rec.npm_ne_id_of;
              l_rec_nsd.nsd_begin_mp    := cs_datum_rec.npm_begin_mp;
              l_rec_nsd.nsd_end_mp      := cs_datum_rec.npm_end_mp;
              l_rec_nsd.nsd_seq_no      := l_datum_count;
              BEGIN
                 l_rec_nsd.nsd_cardinality := Nm3net.get_cardinality
                                                (l_rec_nsm.nsm_ne_id
                                                ,cs_datum_rec.npm_ne_id_of
                                                );
              EXCEPTION
                 WHEN OTHERS
                  THEN
                    l_rec_nsd.nsd_cardinality := 1;
              END;
              --
              l_tab_rec_nsd(l_datum_count) := l_rec_nsd;
              --
           END LOOP;
--
           IF l_datum_count = 1
            THEN
              l_rec_nsm.nsm_datum          := 'Y';
           ELSE
              l_rec_nsm.nsm_datum          := 'N';
           END IF;
--
           ins_nsm (l_rec_nsm);
           ins_nsd (l_tab_rec_nsd);
--
        END;
     END LOOP;
  --
     Nm_Debug.proc_end(g_package_name,'create_saved_ne_from_pbi');
  --
  END create_saved_ne_from_pbi;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_saved_ne_from_merge
                  (pi_nqr_mrg_job_id IN     nm_mrg_query_results.nqr_mrg_job_id%TYPE
                  ,pi_nse_owner      IN     NM_SAVED_EXTENTS.nse_owner%TYPE DEFAULT NULL
                  ,pi_nse_name       IN     NM_SAVED_EXTENTS.nse_name%TYPE  DEFAULT NULL
                  ,pi_nse_descr      IN     NM_SAVED_EXTENTS.nse_descr%TYPE DEFAULT NULL
                  ,po_nse_id            OUT NM_SAVED_EXTENTS.nse_id%TYPE
                  ) IS
  --
     CURSOR cs_nms (c_job_id nm_mrg_sections.nms_mrg_job_id%TYPE) IS
     SELECT *
      FROM  nm_mrg_sections
     WHERE  nms_mrg_job_id = c_job_id;
  --
     CURSOR cs_nsm (c_job_id     NM_MRG_SECTION_MEMBERS.nsm_mrg_job_id%TYPE
                   ,c_section_id NM_MRG_SECTION_MEMBERS.nsm_mrg_section_id%TYPE
                   ) IS
     SELECT *
      FROM  NM_MRG_SECTION_MEMBERS
     WHERE  nsm_mrg_job_id      = c_job_id
      AND   nsm_mrg_section_id  = c_section_id
     ORDER BY nsm_measure;
  --
     l_pre_name  VARCHAR2(30);
     l_post_name VARCHAR2(30);
  --
     l_rec_nqr nm_mrg_query_results%ROWTYPE;
     l_rec_nse NM_SAVED_EXTENTS%ROWTYPE;
     l_rec_nmq nm_mrg_query%ROWTYPE;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_saved_ne_from_merge');
  --
     l_rec_nqr := Nm3mrg.select_nqr (pi_nqr_mrg_job_id);
  --
     l_rec_nmq := Nm3mrg.select_mrg_query (l_rec_nqr.nqr_nmq_id);
  --
     po_nse_id           := get_next_nse_id;
  --
     l_rec_nse.nse_id    := po_nse_id;
     l_rec_nse.nse_owner := NVL(pi_nse_owner,USER);
     IF pi_nse_name IS NOT NULL
      THEN
        l_rec_nse.nse_name  := pi_nse_name;
     ELSE
        l_pre_name          := po_nse_id||'.';
        l_post_name         := '-'||pi_nqr_mrg_job_id;
        l_rec_nse.nse_name  := l_pre_name
                               ||SUBSTR(l_rec_nmq.nmq_unique,1,30-LENGTH(l_pre_name||l_post_name))
                               ||l_post_name;
     END IF;
     l_rec_nse.nse_descr := NVL(pi_nse_descr
                               ,'Saved extent created for '
                                ||l_rec_nmq.nmq_descr||', job_id '||pi_nqr_mrg_job_id
                                ||' run on '||TO_CHAR(l_rec_nqr.nqr_date_created,'DD-Mon-YYYY HH24:MI')
                               );
     l_rec_nse.nse_pbi   := 'Y';
  --
     ins_nse(l_rec_nse);
  --
     FOR cs_rec IN cs_nms (pi_nqr_mrg_job_id)
      LOOP
        DECLARE
           l_rec_nsm     NM_SAVED_EXTENT_MEMBERS%ROWTYPE;
           l_rec_nsd     NM_SAVED_EXTENT_MEMBER_DATUMS%ROWTYPE;
           l_datum_count PLS_INTEGER := 0;
--
           l_tab_rec_nsd tab_nsd;
     --
           CURSOR cs_nm (p_nm_ne_id_in NUMBER
                        ,p_nm_ne_id_of NUMBER
                        ) IS
           SELECT nm_cardinality
            FROM  nm_members
           WHERE  nm_ne_id_in = p_nm_ne_id_in
            AND   nm_ne_id_of = p_nm_ne_id_of;
     --
        BEGIN
--
           l_rec_nsm.nsm_nse_id                  := l_rec_nse.nse_id;
           l_rec_nsm.nsm_id                      := get_next_nsm_id;
           l_rec_nsm.nsm_seq_no                  := cs_rec.nms_mrg_section_id;
           l_rec_nsm.nsm_ne_id                   := cs_rec.nms_offset_ne_id;
           l_rec_nsm.nsm_begin_mp                := cs_rec.nms_begin_offset;
           l_rec_nsm.nsm_end_mp                  := cs_rec.nms_end_offset;
           l_rec_nsm.nsm_restrict_excl_sub_class := 'N';
--
           FOR cs_datum_rec IN cs_nsm (pi_nqr_mrg_job_id, cs_rec.nms_mrg_section_id)
            LOOP
              --
              l_datum_count := l_datum_count + 1;
              --
              l_rec_nsd.nsd_nse_id      := l_rec_nsm.nsm_nse_id;
              l_rec_nsd.nsd_nsm_id      := l_rec_nsm.nsm_id;
              l_rec_nsd.nsd_ne_id       := cs_datum_rec.nsm_ne_id;
              l_rec_nsd.nsd_begin_mp    := cs_datum_rec.nsm_begin_mp;
              l_rec_nsd.nsd_end_mp      := cs_datum_rec.nsm_end_mp;
              l_rec_nsd.nsd_seq_no      := l_datum_count;
              BEGIN
                 l_rec_nsd.nsd_cardinality := Nm3net.get_cardinality
                                                (l_rec_nsm.nsm_ne_id
                                                ,l_rec_nsd.nsd_ne_id
                                                );
              EXCEPTION
                 WHEN OTHERS
                  THEN
                    l_rec_nsd.nsd_cardinality := 1;
              END;
              --
              l_tab_rec_nsd(l_datum_count) := l_rec_nsd;
              --
           END LOOP;
--
           IF l_datum_count = 1
            THEN
              l_rec_nsm.nsm_datum          := 'Y';
           ELSE
              l_rec_nsm.nsm_datum          := 'N';
           END IF;
--
           ins_nsm (l_rec_nsm);
           ins_nsd (l_tab_rec_nsd);
--
        END;
     END LOOP;
  --
     Nm_Debug.proc_end(g_package_name,'create_saved_ne_from_merge');
  --
  END create_saved_ne_from_merge;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE gis_create_saved_ne
                 (pi_gdo_session_id IN GIS_DATA_OBJECTS.gdo_session_id%TYPE
                 ,pi_nse_owner      IN NM_SAVED_EXTENTS.nse_owner%TYPE
                 ,pi_nse_name       IN NM_SAVED_EXTENTS.nse_name%TYPE
                 ,pi_nse_descr      IN NM_SAVED_EXTENTS.nse_descr%TYPE
                 ) IS
--
     CURSOR cs_gdo (c_session_id GIS_DATA_OBJECTS.gdo_session_id%TYPE) IS
     SELECT ne_id
           ,ne_length
           ,gdo_st_chain
           ,gdo_end_chain
      FROM  GIS_DATA_OBJECTS
           ,nm_elements
     WHERE  gdo_session_id = c_session_id
      AND   gdo_pk_id      = ne_id;
  --
     l_dummy       cs_gdo%ROWTYPE;
  --
     l_rec_nse     NM_SAVED_EXTENTS%ROWTYPE;
     l_rec_nsm     NM_SAVED_EXTENT_MEMBERS%ROWTYPE;
     l_rec_nsd     NM_SAVED_EXTENT_MEMBER_DATUMS%ROWTYPE;
  --
     l_rec_count   PLS_INTEGER := 0;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'gis_create_saved_ne');
  --
     g_gis_nse_id := NULL;
  --
     OPEN  cs_gdo (pi_gdo_session_id);
     FETCH cs_gdo INTO l_dummy;
     IF cs_gdo%NOTFOUND
      THEN
        CLOSE cs_gdo;
        g_extent_exc_code  := -20221;
        g_extent_exc_msg   := 'No GIS_DATA_OBJECTS records found which '
                              ||'join to NM_ELEMENTS for this gdo_session_id';
        RAISE g_extent_exception;
     END IF;
     CLOSE cs_gdo;
--
     l_rec_nse.nse_id    := get_next_nse_id;
     l_rec_nse.nse_owner := pi_nse_owner;
     l_rec_nse.nse_name  := pi_nse_name;
     l_rec_nse.nse_descr := pi_nse_descr;
     l_rec_nse.nse_pbi   := 'N';
  --
     ins_nse (l_rec_nse);
  --
     FOR cs_rec IN cs_gdo (pi_gdo_session_id)
      LOOP
      --
        l_rec_count := l_rec_count + 1;
      --
        l_rec_nsm.nsm_nse_id                  := l_rec_nse.nse_id;
        l_rec_nsm.nsm_id                      := get_next_nsm_id;
        l_rec_nsm.nsm_ne_id                   := cs_rec.ne_id;
        l_rec_nsm.nsm_begin_mp                := cs_rec.gdo_st_chain;
        l_rec_nsm.nsm_end_mp                  := cs_rec.gdo_end_chain;
        l_rec_nsm.nsm_seq_no                  := l_rec_count;
        l_rec_nsm.nsm_datum                   := 'Y';
        l_rec_nsm.nsm_restrict_excl_sub_class := 'N';
     --
        ins_nsm(l_rec_nsm);
     --
        l_rec_nsd.nsd_nse_id             := l_rec_nse.nse_id;
        l_rec_nsd.nsd_nsm_id             := l_rec_nsm.nsm_id;
        l_rec_nsd.nsd_ne_id              := cs_rec.ne_id;
        l_rec_nsd.nsd_begin_mp           := cs_rec.gdo_st_chain;
        l_rec_nsd.nsd_end_mp             := cs_rec.gdo_end_chain;
        l_rec_nsd.nsd_seq_no             := 1;
        l_rec_nsd.nsd_cardinality        := 1;
     --
        ins_nsd(l_rec_nsd);
     --
     END LOOP;
     --
     g_gis_nse_id := l_rec_nse.nse_id;
  --
     --nm_debug.debug('Created Saved Extent - NSE_ID : '||g_gis_nse_id);
     --nm_debug.debug('With '||l_rec_count||' records');
  --
     Nm_Debug.proc_end(g_package_name,'gis_create_saved_ne');
  --
  EXCEPTION
  --
     WHEN g_extent_exception
      THEN
        RAISE_APPLICATION_ERROR(g_extent_exc_code,g_extent_exc_msg);
  --
  END gis_create_saved_ne;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_last_gis_nse_id RETURN NM_SAVED_EXTENTS.nse_id%TYPE IS
  BEGIN
     RETURN g_gis_nse_id;
  END get_last_gis_nse_id;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_unique_from_source
                       (pi_source_id      IN NM_PBI_QUERY_RESULTS.nqr_source_id%TYPE
                       ,pi_source         IN NM_PBI_QUERY_RESULTS.nqr_source%TYPE
                       ,pi_suppress_error IN VARCHAR2 DEFAULT 'N'
                       ) RETURN VARCHAR2 IS
--
     l_retval VARCHAR2(4000);
     c_raise_error CONSTANT BOOLEAN := pi_suppress_error != 'Y';
  --
  BEGIN
  --
     check_valid_source(pi_source);
  --
     IF    pi_source = c_saved
      THEN
  --
        DECLARE
           l_rec_nse NM_SAVED_EXTENTS%ROWTYPE;
           l_not_found EXCEPTION;
           PRAGMA EXCEPTION_INIT(l_not_found,-20001);
        BEGIN
           l_rec_nse := get_nse (pi_source_id);
           l_retval  := l_rec_nse.nse_name;
        EXCEPTION
           WHEN l_not_found
            THEN
              IF c_raise_error
               THEN
                 RAISE;
              END IF;
        END;
  --
     ELSIF pi_source = c_route
      THEN
  --
        DECLARE
           l_rec_ne   nm_elements%ROWTYPE;
           no_nm_elements_found EXCEPTION;
           PRAGMA EXCEPTION_INIT (no_nm_elements_found,-20001);
        BEGIN
           l_rec_ne  := Nm3net.get_ne (pi_source_id);
           l_retval  := l_rec_ne.ne_unique;
        EXCEPTION
           WHEN no_nm_elements_found
            THEN
              -- If no NM_ELEMENTS record found for this one
              --  then it may be an inventory item so have a look
              NULL;
        END;
   --
        DECLARE
           l_rec_iit nm_inv_items%ROWTYPE;
        BEGIN
           IF l_retval IS NULL
            THEN
              l_rec_iit := Nm3inv.get_inv_item(pi_source_id);
              IF l_rec_iit.iit_ne_id IS NULL
               THEN
                 -- If there's no inventory found then is doesn't
                 --  exist so splatter
                 IF c_raise_error
                  THEN
                    g_extent_exc_code  := -20213;
                    g_extent_exc_msg   := 'NE_ID : '||pi_source_id||' not found, neither on NM_ELEMENTS nor on NM_INV_ITEMS';
                    RAISE g_extent_exception;
                 END IF;
              END IF;
              l_retval := l_rec_iit.iit_primary_key;
           END IF;
        END;
  --
     ELSIF pi_source = c_pbi
      THEN
  --
        DECLARE
           l_rec_nqr NM_PBI_QUERY_RESULTS%ROWTYPE;
           l_not_found EXCEPTION;
           PRAGMA EXCEPTION_INIT(l_not_found,-20001);
        BEGIN
  --
           l_rec_nqr := Nm3pbi.select_npr (pi_source_id);
           l_retval  := l_rec_nqr.nqr_description;
        EXCEPTION
           WHEN l_not_found
            THEN
              IF c_raise_error
               THEN
                 RAISE;
              END IF;
        END;
  --
     ELSIF pi_source = c_merge
      THEN
  --
        DECLARE
           l_rec_nqr nm_mrg_query_results%ROWTYPE;
        BEGIN
  --
           l_rec_nqr := Nm3mrg.select_nqr (pi_source_id);
           l_retval  := l_rec_nqr.nqr_description;
     --
        END;
  --
     ELSIF pi_source = c_temp_ne
      THEN
  --
        l_retval := 'Temporary Network Extent';
  --
     END IF;
  --
     RETURN l_retval;
  --
  EXCEPTION
  --
     WHEN g_extent_exception
      THEN
        RAISE_APPLICATION_ERROR(g_extent_exc_code,g_extent_exc_msg);
  --
  END get_unique_from_source;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION check_nse_nt_types(pi_nse_id     IN NM_SAVED_EXTENTS.nse_id%TYPE
                             ,pi_group_type IN nm_group_types.ngt_group_type%TYPE
                             ) RETURN BOOLEAN IS

    CURSOR c1(p_nse_id     IN NM_SAVED_EXTENTS.nse_id%TYPE
             ,p_group_type IN nm_group_types.ngt_group_type%TYPE) IS
      SELECT
        1
      FROM
        NM_SAVED_EXTENT_MEMBER_DATUMS,
        nm_elements
      WHERE
        nsd_nse_id = p_nse_id
      AND
        nsd_ne_id = ne_id
      AND
        ne_nt_type NOT IN (SELECT
                             nng_nt_type
                           FROM
                             nm_nt_groupings
                           WHERE
                             nng_group_type = p_group_type);

    n PLS_INTEGER;
    retval BOOLEAN := TRUE;

  BEGIN
    OPEN c1(pi_nse_id
           ,pi_group_type);
      FETCH c1 INTO n;
      IF c1%FOUND THEN
        retval := FALSE;
      END IF;
    CLOSE c1;

    RETURN retval;
  END check_nse_nt_types;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION extent_is_partial(pi_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE
                            ) RETURN BOOLEAN IS

    CURSOR c1(p_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS
      SELECT
        1
      FROM
        NM_SAVED_EXTENT_MEMBER_DATUMS
      WHERE
        nsd_nse_id = p_nse_id
      AND
        nsd_end_mp <> Nm3net.Get_Ne_Length(nsd_ne_id);

    n PLS_INTEGER;
    retval BOOLEAN := FALSE;

  BEGIN
    OPEN c1(pi_nse_id);
      FETCH c1 INTO n;
      IF c1%FOUND THEN
        retval := TRUE;
      END IF;
    CLOSE c1;

    RETURN retval;
  END extent_is_partial;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION extent_is_exclusive(pi_nse_id     IN NM_SAVED_EXTENTS.nse_id%TYPE
                              ,pi_group_type IN nm_group_types.ngt_group_type%TYPE
                              ) RETURN BOOLEAN IS

    CURSOR c1(p_nse_id     IN NM_SAVED_EXTENTS.nse_id%TYPE
             ,p_group_type IN nm_group_types.ngt_group_type%TYPE) IS
      SELECT
        1
      FROM
        nm_members,
        nm_elements,
        NM_SAVED_EXTENT_MEMBER_DATUMS
      WHERE
        nm_ne_id_of = nsd_ne_id
      AND
	      nm_ne_id_in = ne_id
      AND
        ne_gty_group_type = pi_group_type
      AND
        nsd_nse_id = p_nse_id
      AND
        nsd_begin_mp < NVL(nm_end_mp, nsd_begin_mp - 1)
	    AND
        nsd_end_mp > nm_begin_mp;

    n PLS_INTEGER;
    retval BOOLEAN := TRUE;

  BEGIN
    OPEN c1(pi_nse_id
           ,pi_group_type);
      FETCH c1 INTO n;
      IF c1%FOUND THEN
        retval := FALSE;
      END IF;
    CLOSE c1;

    RETURN retval;
  END extent_is_exclusive;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION check_element_dates(pi_nse_id     IN NM_SAVED_EXTENTS.nse_id%TYPE
                              ,pi_start_date IN DATE
                              ) RETURN BOOLEAN IS

    CURSOR c1(p_nse_id     IN NM_SAVED_EXTENTS.nse_id%TYPE
             ,p_eff_date IN DATE) IS
      SELECT
        1
      FROM
        NM_SAVED_EXTENT_MEMBER_DATUMS nsd,
        NM_ELEMENTS_ALL               ne
      WHERE
        nsd.nsd_nse_id = p_nse_id
      AND
        nsd.nsd_ne_id = ne.ne_id
      AND
        ((ne.ne_end_date IS NOT NULL
          AND
          ne.ne_end_date <= p_eff_date
         )
         OR
         ne.ne_start_date > p_eff_date
        );

    l_dummy PLS_INTEGER;
    l_retval BOOLEAN;

  BEGIN
    OPEN c1(p_nse_id   => pi_nse_id
           ,p_eff_date => pi_start_date);

      FETCH c1 INTO l_dummy;

      IF c1%FOUND
      THEN
        l_retval := FALSE;

      ELSE
        l_retval := TRUE;
      END IF;

    CLOSE c1;

    RETURN l_retval;
  END check_element_dates;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION create_group_from_nse(pi_nse_id            IN     NM_SAVED_EXTENTS.nse_id%TYPE
                                ,pio_ne_rec           IN OUT NOCOPY nm_elements%ROWTYPE
                                ,pi_offset            IN     NUMBER                             DEFAULT 0
                                ,pi_check_overlaps    IN     BOOLEAN                            DEFAULT TRUE
                                ,po_rescale_loop         OUT BOOLEAN
                                ) RETURN nm_elements.ne_id%TYPE IS

    CURSOR c_nsd(p_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS
      SELECT
        nsm.nsm_seq_no      seq_1,
        nsd.nsd_seq_no      seq_2,
        nsd.nsd_ne_id       ne_id,
        nsd.nsd_begin_mp    begin_mp,
        nsd.nsd_end_mp      end_mp,
        nsd.nsd_cardinality nsd_cardinality,
        ne.ne_length       ne_length
      FROM
        NM_SAVED_EXTENT_MEMBERS       nsm,
        NM_SAVED_EXTENT_MEMBER_DATUMS nsd,
        nm_elements                   ne
      WHERE
        nsd.nsd_nse_id = p_nse_id
      AND
        nsd.nsd_nsm_id = nsm.nsm_id
      AND
        ne.ne_id = nsd.nsd_ne_id
      ORDER BY
        nsd.nsd_ne_id,
        nsd.nsd_begin_mp,
        nsm.nsm_seq_no,
        nsd.nsd_seq_no;

     CURSOR c_ncg(p_job_id IN NM_CREATE_GROUP_TEMP.ncg_job_id%TYPE) IS
       SELECT
         *
       FROM
         NM_CREATE_GROUP_TEMP ncg
       WHERE
         ncg.ncg_job_id = p_job_id
       ORDER BY
         ncg_seq_1,
         ncg_seq_2;

    CURSOR c_create_check(p_ne_id IN nm_elements.ne_id%TYPE) IS
      SELECT
        1
      FROM
        nm_elements
      WHERE
        ne_id = p_ne_id;

    c_pop_unique CONSTANT BOOLEAN := Nm3net.is_pop_unique(pio_ne_rec.ne_nt_type);

    l_temp PLS_INTEGER;

    l_ne_id nm_elements.ne_id%TYPE;

    l_end_mp nm_members.nm_end_mp%TYPE;

    l_ne_rec nm_elements%ROWTYPE;
    l_nm_rec nm_members%ROWTYPE;

    l_gty_rec nm_group_types%ROWTYPE;

    l_ncg_rec NM_CREATE_GROUP_TEMP%ROWTYPE;

    l_ne_no_start nm_nodes.no_node_id%TYPE;
    l_ne_no_end   nm_nodes.no_node_id%TYPE;

  BEGIN
    Nm_Debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'create_group_from_nse');

    IF pi_check_overlaps
      AND saved_ne_has_overlaps(pi_nse_id => pi_nse_id)
    THEN
      g_extent_exc_code := -20225;
      g_extent_exc_msg  := 'Extent has overlaps. NSE_ID = ' || pi_nse_id;

      RAISE g_extent_exception;
    END IF;

    --get group type details
    l_gty_rec := Nm3net.get_gty(pi_gty => pio_ne_rec.ne_gty_group_type);

    --validate flex columns for new element
    Nm3nwval.validate_nw_element_cols(p_ne_nt_type    => pio_ne_rec.ne_nt_type
                                     ,p_ne_owner      => pio_ne_rec.ne_owner
                                     ,p_ne_name_1     => pio_ne_rec.ne_name_1
                                     ,p_ne_name_2     => pio_ne_rec.ne_name_2
                                     ,p_ne_prefix     => pio_ne_rec.ne_prefix
                                     ,p_ne_number     => pio_ne_rec.ne_number
                                     ,p_ne_sub_type   => pio_ne_rec.ne_sub_type
                                     ,p_ne_no_start   => l_ne_no_start
                                     ,p_ne_no_end     => l_ne_no_end
                                     ,p_ne_sub_class  => pio_ne_rec.ne_sub_class
                                     ,p_ne_nsg_ref    => pio_ne_rec.ne_nsg_ref
                                     ,p_ne_version_no => pio_ne_rec.ne_version_no
                                     ,p_ne_group      => pio_ne_rec.ne_group
                                     ,p_ne_start_date => pio_ne_rec.ne_start_date
                                     ,p_ne_gty_group_type => pio_ne_rec.ne_gty_group_type
                                     ,p_ne_admin_unit     => pio_ne_rec.ne_admin_unit
                                     );

    IF c_pop_unique
    THEN
      --create ne_unique for new element from flex columns
      Nm3nwval.create_ne_unique(p_ne_unique     => pio_ne_rec.ne_unique
                               ,p_ne_nt_type    => pio_ne_rec.ne_nt_type
                               ,p_ne_owner      => pio_ne_rec.ne_owner
                               ,p_ne_name_1     => pio_ne_rec.ne_name_1
                               ,p_ne_name_2     => pio_ne_rec.ne_name_2
                               ,p_ne_prefix     => pio_ne_rec.ne_prefix
                               ,p_ne_number     => pio_ne_rec.ne_number
                               ,p_ne_sub_type   => pio_ne_rec.ne_sub_type
                               ,p_ne_no_start   => NULL
                               ,p_ne_no_end     => NULL
                               ,p_ne_sub_class  => pio_ne_rec.ne_sub_class
                               ,p_ne_nsg_ref    => pio_ne_rec.ne_nsg_ref
                               ,p_ne_version_no => pio_ne_rec.ne_version_no
                               ,p_ne_group      => pio_ne_rec.ne_group);
    END IF;

    --create group master record
    Nm3net.grp_insert_element(p_ne_id             => l_ne_id
                             ,p_ne_unique         => pio_ne_rec.ne_unique
                             ,p_ne_type           => 'G'
                             ,p_ne_nt_type        => pio_ne_rec.ne_nt_type
                             ,p_ne_descr          => pio_ne_rec.ne_descr
                             ,p_ne_length         => NULL
                             ,p_ne_admin_unit     => pio_ne_rec.ne_admin_unit
                             ,p_ne_start_date     => pio_ne_rec.ne_start_date
                             ,p_ne_end_date       => NULL
                             ,p_ne_gty_group_type => pio_ne_rec.ne_gty_group_type
                             ,p_ne_no_start       => NULL
                             ,p_ne_no_end         => NULL
                             ,p_ne_owner          => pio_ne_rec.ne_owner
                             ,p_ne_name_1         => pio_ne_rec.ne_name_1
                             ,p_ne_name_2         => pio_ne_rec.ne_name_2
                             ,p_ne_prefix         => pio_ne_rec.ne_prefix
                             ,p_ne_number         => pio_ne_rec.ne_number
                             ,p_ne_sub_type       => pio_ne_rec.ne_sub_type
                             ,p_ne_group          => pio_ne_rec.ne_group
                             ,p_ne_sub_class      => pio_ne_rec.ne_sub_class
                             ,p_ne_nsg_ref        => pio_ne_rec.ne_nsg_ref
                             ,p_ne_version_no     => pio_ne_rec.ne_version_no
                             ,p_nm_slk            => NULL
                             ,p_nm_cardinality    => NULL);

    OPEN c_create_check(p_ne_id => l_ne_id);
      FETCH c_create_check INTO l_temp;
      IF c_create_check%NOTFOUND
      THEN
        --network type has no nm_type_inclusion records so grp_insert_element will not
        --have inserted an nm_element record. So we do one manually...
        pio_ne_rec.ne_id       := l_ne_id;
        pio_ne_rec.ne_type     := 'G';
        pio_ne_rec.ne_length   := NULL;
        pio_ne_rec.ne_end_date := NULL;
        pio_ne_rec.ne_no_start := NULL;
        pio_ne_rec.ne_no_end   := NULL;

        Nm3net.ins_ne(pi_rec_ne => pio_ne_rec);
      END IF;
    CLOSE c_create_check;

    l_ncg_rec.ncg_job_id := Nm3pbi.get_job_id;

    --process datums in extent to deal with overlaps
    FOR l_rec IN c_nsd(p_nse_id => pi_nse_id)
    LOOP
      IF l_rec.ne_id = NVL(l_ncg_rec.ncg_ne_id, -1)
        AND l_rec.begin_mp <= NVL(l_ncg_rec.ncg_end_mp, l_rec.ne_length)
      THEN
        --same datum, overlapping
        --check end of new record
        IF NVL(l_rec.end_mp, l_rec.ne_length) > NVL(l_ncg_rec.ncg_end_mp, l_rec.ne_length)
        THEN
          --new record extends existing record of datum
          l_ncg_rec.ncg_end_mp := NVL(l_rec.end_mp, l_rec.ne_length);
        END IF;
      ELSE
        --new datum
        --insert last ncg record
        IF l_ncg_rec.ncg_ne_id IS NOT NULL
        THEN
          ins_ncg(pi_ncg_rec => l_ncg_rec);
        END IF;

        --work out end mp
        l_end_mp := l_rec.end_mp;

        --create record for temp table ncg
        l_ncg_rec.ncg_ne_id       := l_rec.ne_id;
        l_ncg_rec.ncg_begin_mp    := l_rec.begin_mp;
        l_ncg_rec.ncg_end_mp      := l_end_mp;
        l_ncg_rec.ncg_seq_1       := l_rec.seq_1;
        l_ncg_rec.ncg_seq_2       := l_rec.seq_2;
        l_ncg_rec.ncg_cardinality := l_rec.nsd_cardinality;
      END IF;
    END LOOP;

    IF l_ncg_rec.ncg_ne_id IS NOT NULL
    THEN
      --insert last ncg record created by above loop
      ins_ncg(pi_ncg_rec => l_ncg_rec);
    END IF;

    --add standard data to member record
    l_nm_rec.nm_ne_id_in   := l_ne_id;
    l_nm_rec.nm_start_date := pio_ne_rec.ne_start_date;
    l_nm_rec.nm_admin_unit := pio_ne_rec.ne_admin_unit;
    l_nm_rec.nm_type       := 'G';
    l_nm_rec.nm_obj_type   := pio_ne_rec.ne_gty_group_type;

    --create nm_member records
    FOR l_rec IN c_ncg(p_job_id => l_ncg_rec.ncg_job_id)
    LOOP
      --set fields in member record
      l_nm_rec.nm_ne_id_of    := l_rec.ncg_ne_id;
      l_nm_rec.nm_begin_mp    := l_rec.ncg_begin_mp;
      l_nm_rec.nm_end_mp      := l_rec.ncg_end_mp;
      l_nm_rec.nm_seq_no      := c_ncg%rowcount;
      l_nm_rec.nm_cardinality := l_rec.ncg_cardinality;

      Nm3net.ins_nm(pi_rec_nm => l_nm_rec);
    END LOOP;

    IF l_gty_rec.ngt_linear_flag = 'Y'
    THEN
      --rescale linear groups
      DECLARE
        e_rescale_loop EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_rescale_loop, -20207);

      BEGIN
        Nm3rsc.rescale_route(pi_ne_id          => l_ne_id
                            ,pi_effective_date => pio_ne_rec.ne_start_date
                            ,pi_offset_st      => pi_offset
                            ,pi_st_element_id  => NULL
                            ,pi_use_history    => 'N'
                            ,pi_ne_start       => NULL);

      EXCEPTION
        WHEN e_rescale_loop
        THEN
          po_rescale_loop := TRUE;

      END;
    END IF;

    Nm_Debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_group_from_nse');

    RETURN l_ne_id;

  EXCEPTION
    WHEN g_extent_exception
    THEN
      RAISE_APPLICATION_ERROR(g_extent_exc_code, g_extent_exc_msg);

  END;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION extent_datum_count(pi_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE
                             ) RETURN PLS_INTEGER IS

   CURSOR c1(p_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS
     SELECT
       COUNT(*)
     FROM
       NM_SAVED_EXTENT_MEMBER_DATUMS nsd
     WHERE
       nsd.nsd_nse_id = p_nse_id;

    l_retval PLS_INTEGER;

  BEGIN
    OPEN c1(p_nse_id => pi_nse_id);
      FETCH c1 INTO l_retval;
    CLOSE c1;

    RETURN l_retval;
  END extent_datum_count;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_temp_ne_from_gis
                  (pi_session_id IN  GIS_DATA_OBJECTS.gdo_session_id%TYPE
                  ,po_job_id         OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                  ) IS
  --
     CURSOR cs_gdo (c_session_id IN  GIS_DATA_OBJECTS.gdo_session_id%TYPE)IS
     SELECT gdo_pk_id
           ,NVL(gdo_st_chain,0)
           ,NVL(gdo_end_chain,ne_length)
           ,1
           ,gdo_pk_id -- nm3net.get_parent_ne_id(gdo_pk_id,nm3net.get_parent_type(ne_nt_type))
      FROM  GIS_DATA_OBJECTS
           ,nm_elements
     WHERE  gdo_session_id = c_session_id
      AND   gdo_pk_id      = ne_id;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name,'create_temp_ne_from_gis');
  --
     -- Get the job_id
     po_job_id := Nm3net.get_next_nte_id;
  --
     OPEN  cs_gdo (pi_session_id);
     FETCH cs_gdo
      BULK COLLECT
      INTO g_tab_nte_ne_id_of
          ,g_tab_nte_begin_mp
          ,g_tab_nte_end_mp
          ,g_tab_nte_cardinality
          ,g_tab_nte_route_ne_id;
     CLOSE cs_gdo;
     FOR i IN 1..g_tab_nte_ne_id_of.COUNT
      LOOP
        g_tab_nte_seq_no(i) := i;
     END LOOP;
  --
     insert_nte_globals(po_job_id);
  --
     Nm_Debug.proc_end(g_package_name,'create_temp_ne_from_gis');
  --
  END create_temp_ne_from_gis;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE debug_temp_extents (pi_nte_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE DEFAULT NULL) IS
  l_temp_nte tab_nte ;
  BEGIN
   Nm_Debug.proc_start(g_package_name,'debug_temp_extents');
   Nm_Debug.DEBUG('Debug NTE started for '||pi_nte_job_id);
   l_temp_nte := get_tab_nte (pi_nte_job_id) ;
   debug_tab_nte (l_temp_nte);
   Nm_Debug.DEBUG('Debug NTE finished for '||pi_nte_job_id);
   Nm_Debug.proc_end(g_package_name,'debug_temp_extents');
  END debug_temp_extents;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE lock_temp_extent_datums (pi_nte_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
    CURSOR c1(c_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT nte_ne_id_of
       FROM  NM_NW_TEMP_EXTENTS
      WHERE  nte_job_id = c_job_id;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name, 'lock_temp_extent_datums');
  --
    FOR cs_rec IN c1(pi_nte_job_id)
     LOOP
       Nm3lock.lock_element_and_members (cs_rec.nte_ne_id_of);
  --     nm_debug.debug('Locking '||cs_rec.ne_unique);
    END LOOP;
  --
     Nm_Debug.proc_end(g_package_name, 'lock_temp_extent_datums');
  --
  END lock_temp_extent_datums;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE lock_persistent_extent_datums (pi_npe_job_id IN NM_NW_PERSISTENT_EXTENTS.npe_job_id%TYPE) IS
    CURSOR c1(c_job_id NM_NW_PERSISTENT_EXTENTS.npe_job_id%TYPE) IS
      SELECT npe_ne_id_of
       FROM  NM_NW_PERSISTENT_EXTENTS
      WHERE  npe_job_id = c_job_id;
  --
  BEGIN
  --
     Nm_Debug.proc_start(g_package_name, 'lock_persistent_extent_datums');
  --
    FOR cs_rec IN c1(pi_npe_job_id)
     LOOP
       Nm3lock.lock_element_and_members (cs_rec.npe_ne_id_of);
  --     nm_debug.debug('Locking '||cs_rec.ne_unique);
    END LOOP;
  --
     Nm_Debug.proc_end(g_package_name, 'lock_persistent_extent_datums');
  --
  END lock_persistent_extent_datums;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION temp_ne_has_overlaps(pi_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                               ) RETURN BOOLEAN IS

    CURSOR c1(p_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT
        1
      FROM
        NM_NW_TEMP_EXTENTS nte_1
      WHERE
        nte_1.nte_job_id = p_job_id
      AND
        EXISTS (SELECT
                  1
                FROM
                  NM_NW_TEMP_EXTENTS nte_2
                WHERE
                  nte_2.nte_job_id = nte_1.nte_job_id
                AND
                  nte_1.nte_ne_id_of = nte_2.nte_ne_id_of
                AND
                  nte_1.ROWID <> nte_2.ROWID
                AND
                  nte_1.nte_begin_mp < NVL(nte_2.nte_end_mp, nte_1.nte_begin_mp + 1)
                AND
                  NVL(nte_1.nte_end_mp, nte_2.nte_begin_mp + 1) > nte_2.nte_begin_mp);

    l_dummy PLS_INTEGER;
    l_retval BOOLEAN;

  BEGIN
    OPEN c1(p_job_id => pi_job_id);
      FETCH c1 INTO l_dummy;
      l_retval := c1%FOUND;
    CLOSE c1;

    RETURN l_retval;

  END temp_ne_has_overlaps;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE combine_temp_nes(pi_job_id_1       IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                            ,pi_job_id_2       IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                            ,pi_check_overlaps IN BOOLEAN DEFAULT TRUE
                            ) IS

    CURSOR c1(p_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT
        COUNT(*)
      FROM
        NM_NW_TEMP_EXTENTS
      WHERE
        nte_job_id = p_job_id;

    l_num_existing PLS_INTEGER;

  BEGIN
    --count extents in
    OPEN c1(p_job_id => pi_job_id_1);
      FETCH c1 INTO l_num_existing;
    CLOSE c1;

    --move second extent's members into first
    UPDATE
      NM_NW_TEMP_EXTENTS
    SET
      nte_job_id = pi_job_id_1,
      nte_seq_no = nte_seq_no + l_num_existing
    WHERE
      nte_job_id = pi_job_id_2;

    --check for overlaps if necessary
    IF pi_check_overlaps
      AND temp_ne_has_overlaps(pi_job_id => pi_job_id_1)
    THEN
      g_extent_exc_code := -20216;
      g_extent_exc_msg  := 'Extent "' || pi_job_id_1 || '" has overlaps';
      RAISE g_extent_exception;
    END IF;
--
    g_combine_temp_ne_called := TRUE;
--
  EXCEPTION
    WHEN g_extent_exception
    THEN
      RAISE_APPLICATION_ERROR(g_extent_exc_code, g_extent_exc_msg);

  END combine_temp_nes;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE remove_db_from_temp_ne(pi_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                  ) IS
  BEGIN
    DELETE
      NM_NW_TEMP_EXTENTS nte
    WHERE
      nte.nte_job_id = pi_job_id
    AND
      EXISTS (SELECT
                1
              FROM
                nm_elements ne
              WHERE
                nte.nte_ne_id_of = ne.ne_id
              AND
                ne.ne_type = 'D');

  END remove_db_from_temp_ne;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE insert_nte_globals (p_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
  BEGIN
  --
  -- This loop is here for dealing with non-inclusion data
  --
     FOR i IN 1..g_tab_nte_ne_id_of.COUNT
      LOOP
        DECLARE
           l_ne_id NUMBER := g_tab_nte_ne_id_of(i);
           l_parent_type NM_TYPES.nt_type%TYPE;
        BEGIN
           IF l_ne_id = g_tab_nte_route_ne_id(i)
            THEN
              l_parent_type := Nm3net.get_parent_type(p_nt_type     => Nm3net.Get_Nt_Type(l_ne_id)
                                                     ,p_linear_only => TRUE
                                                     );
              g_tab_nte_route_ne_id(i) := Nm3net.get_parent_ne_id(p_child_ne_id => l_ne_id
                                                                 ,p_parent_type => l_parent_type
                                                                 );
           END IF;
        EXCEPTION
           WHEN OTHERS
            THEN
              g_tab_nte_route_ne_id(i) := l_ne_id;
        END;
     END LOOP;
  --
     FORALL i IN 1..g_tab_nte_ne_id_of.COUNT
       INSERT INTO NM_NW_TEMP_EXTENTS
              (nte_job_id
              ,nte_ne_id_of
              ,nte_begin_mp
              ,nte_end_mp
              ,nte_cardinality
              ,nte_seq_no
              ,nte_route_ne_id
              )
       VALUES (p_job_id
              ,g_tab_nte_ne_id_of(i)
              ,g_tab_nte_begin_mp(i)
              ,g_tab_nte_end_mp(i)
              ,g_tab_nte_cardinality(i)
              ,g_tab_nte_seq_no(i)
              ,g_tab_nte_route_ne_id(i)
              );
  --
  END insert_nte_globals;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION count_routes_in_temp_ne(pi_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                  ) RETURN PLS_INTEGER IS

    CURSOR c_nte(p_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
      SELECT
        COUNT(DISTINCT nte.nte_route_ne_id)
      FROM
        NM_NW_TEMP_EXTENTS nte
      WHERE
        nte.nte_job_id = p_job_id;

    l_count PLS_INTEGER;

  BEGIN
    OPEN c_nte(p_job_id => pi_job_id);
      FETCH c_nte INTO l_count;
    CLOSE c_nte;

    RETURN l_count;

  END count_routes_in_temp_ne;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION temp_ne_valid_for_homo(pi_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                 ) RETURN BOOLEAN IS
  BEGIN
    RETURN NVL(Hig.get_sysopt(p_option_id => 'MULTINVRTE'), 'N') = 'Y'
           OR
           count_routes_in_temp_ne(pi_job_id => pi_job_id) = 1;

  END temp_ne_valid_for_homo;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION nse_name_is_unique(pi_name   IN VARCHAR2
                             ,pi_nse_id IN VARCHAR2
                             ) RETURN BOOLEAN IS

    CURSOR c_nse(p_name   VARCHAR2
                ,p_nse_id VARCHAR2) IS
      SELECT
        1
      FROM
        NM_SAVED_EXTENTS
      WHERE
        nse_id <> NVL(p_nse_id, -1)
      AND
        nse_name = p_name;

    l_dummy PLS_INTEGER;

    l_retval BOOLEAN;

  BEGIN
    OPEN c_nse(p_name   => pi_name
              ,p_nse_id => pi_nse_id);
      FETCH c_nse INTO l_dummy;
      l_retval := c_nse%NOTFOUND;
    CLOSE c_nse;

    RETURN l_retval;

  END nse_name_is_unique;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION saved_ne_has_overlaps(pi_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE
                                ) RETURN BOOLEAN IS

    CURSOR c_nsd(p_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE) IS
      SELECT
        1
      FROM
        NM_SAVED_EXTENT_MEMBER_DATUMS nsd_1
      WHERE
        nsd_1.nsd_nse_id = p_nse_id
      AND
        EXISTS (SELECT
                  1
                FROM
                  NM_SAVED_EXTENT_MEMBER_DATUMS nsd_2
                WHERE
                  nsd_2.nsd_nse_id = nsd_1.nsd_nse_id
                AND
                  nsd_1.nsd_ne_id = nsd_2.nsd_ne_id
                AND
                  nsd_1.ROWID <> nsd_2.ROWID
                AND
                  nsd_1.nsd_begin_mp < nsd_2.nsd_end_mp
                AND
                  nsd_1.nsd_end_mp > nsd_2.nsd_begin_mp);

    l_dummy PLS_INTEGER;
    l_retval BOOLEAN;

  BEGIN
    OPEN c_nsd(p_nse_id => pi_nse_id);
      FETCH c_nsd INTO l_dummy;
      l_retval := c_nsd%FOUND;
    CLOSE c_nsd;

    RETURN l_retval;

  END saved_ne_has_overlaps;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_ncg(pi_ncg_rec IN NM_CREATE_GROUP_TEMP%ROWTYPE) IS
  BEGIN
    INSERT INTO
      NM_CREATE_GROUP_TEMP
          (ncg_job_id
          ,ncg_ne_id
          ,ncg_begin_mp
          ,ncg_end_mp
          ,ncg_cardinality
          ,ncg_seq_1
          ,ncg_seq_2)
    VALUES(pi_ncg_rec.ncg_job_id
          ,pi_ncg_rec.ncg_ne_id
          ,pi_ncg_rec.ncg_begin_mp
          ,pi_ncg_rec.ncg_end_mp
          ,pi_ncg_rec.ncg_cardinality
          ,pi_ncg_rec.ncg_seq_1
          ,pi_ncg_rec.ncg_seq_2);
  END ins_ncg;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION saved_ne_contents_updated(pi_nse_id IN NM_SAVED_EXTENTS.nse_id%TYPE
                                    ) RETURN BOOLEAN IS

    l_dummy PLS_INTEGER;

    l_retval BOOLEAN;

  BEGIN
    BEGIN
      SELECT
        1
      INTO
        l_dummy
      FROM
        dual
      WHERE
        EXISTS (SELECT
                  1
                FROM
                  NM_SAVED_EXTENT_MEMBERS       nsm,
                  NM_SAVED_EXTENT_MEMBER_DATUMS nsd,
                  NM_ELEMENTS_ALL               ne
                WHERE
                  nsm.nsm_nse_id = pi_nse_id
                AND
                  nsd.nsd_ne_id = ne.ne_id
                AND
                  nsd.nsd_nsm_id = nsm.nsm_id
                AND
                  nsm.nsm_date_modified <= ne.ne_date_modified);

      l_retval := TRUE;

    EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
        l_retval := FALSE;

    END;

    RETURN l_retval;

  END saved_ne_contents_updated;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_last_nte_job_id RETURN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE IS
  BEGIN
     RETURN g_last_nte_job_id;
  END get_last_nte_job_id;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION nte_is_single_point (p_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                               ) RETURN BOOLEAN IS
--
     CURSOR cs_nte (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
     SELECT nte_begin_mp
           ,nte_end_mp
      FROM  NM_NW_TEMP_EXTENTS
     WHERE  nte_job_id  = c_nte_job_id
      AND   ROWNUM     <= 2;
--
     l_rec  cs_nte%ROWTYPE;
     l_rec2 cs_nte%ROWTYPE;
--
     l_retval BOOLEAN;
--
  BEGIN
--
     OPEN  cs_nte (p_nte_job_id);
     FETCH cs_nte INTO l_rec;
     IF l_rec.nte_begin_mp != l_rec.nte_end_mp
      THEN
        l_retval := FALSE; -- Different MP therefore FALSE
     ELSE
        FETCH cs_nte INTO l_rec2;
        IF cs_nte%FOUND
         THEN
           l_retval := FALSE; -- >1 record therefore false
        ELSE
           l_retval := TRUE;  -- only 1 record and MP is the same
        END IF;
     END IF;
     CLOSE cs_nte;
--
     RETURN l_retval;
--
  END nte_is_single_point;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE debug_tab_nte (p_tab_nte IN OUT NOCOPY tab_nte) IS
  BEGIN
   FOR i IN 1..p_tab_nte.COUNT
    LOOP
      Nm_Debug.DEBUG('------------');
      Nm_Debug.DEBUG('NTE_NE_ID_OF    : '||p_tab_nte(i).nte_ne_id_of||' ('||Nm3net.get_ne_unique(p_tab_nte(i).nte_ne_id_of)||')');
      Nm_Debug.DEBUG('NTE_BEGIN_MP    : '||p_tab_nte(i).nte_begin_mp);
      Nm_Debug.DEBUG('NTE_END_MP      : '||p_tab_nte(i).nte_end_mp);
      Nm_Debug.DEBUG('NTE_CARDINALITY : '||p_tab_nte(i).nte_cardinality );
      Nm_Debug.DEBUG('NTE_SEQ_NO      : '||p_tab_nte(i).nte_seq_no);
      BEGIN
         Nm_Debug.DEBUG('NTE_ROUTE_NE_ID : '||p_tab_nte(i).nte_route_ne_id||' ('||Nm3net.get_ne_unique(p_tab_nte(i).nte_route_ne_id)||')');
      EXCEPTION
         WHEN OTHERS
          THEN
            Nm_Debug.DEBUG('NTE_ROUTE_NE_ID : '||p_tab_nte(i).nte_route_ne_id);
      END;
   END LOOP;
  END debug_tab_nte;
  --
  -----------------------------------------------------------------------------
  --
PROCEDURE create_temp_ne_intx_of_temp_ne
                      (pi_tab_nte_1 IN OUT NOCOPY tab_nte
                      ,pi_tab_nte_2 IN OUT NOCOPY tab_nte
                      ,po_tab_intx  IN OUT NOCOPY tab_nte
                      ) IS
--
BEGIN
  --
   Nm_Debug.proc_start (g_package_name,'create_temp_ne_intx_of_temp_ne');

   IF pi_tab_nte_1.COUNT = 0 OR pi_tab_nte_2.COUNT = 0
   THEN
     RETURN ;
   END IF ;

   -- Call the helper with the correct order for the smallest/largest data set
   IF pi_tab_nte_1.COUNT > pi_tab_nte_2.COUNT
   THEN
     nte_intx_nte(pi_smallest_nte  => pi_tab_nte_2
                 ,pi_largest_nte   => pi_tab_nte_1
                 ,po_nte_result => po_tab_intx
                 );
   ELSE
     nte_intx_nte(pi_smallest_nte  => pi_tab_nte_1
                 ,pi_largest_nte   => pi_tab_nte_2
                 ,po_nte_result => po_tab_intx
                 );
   END IF ;
 --
   Nm_Debug.proc_end (g_package_name,'create_temp_ne_intx_of_temp_ne');
 --
END create_temp_ne_intx_of_temp_ne;
  --
  -----------------------------------------------------------------------------
  --
PROCEDURE create_temp_ne_intx_of_temp_ne
                      (pi_nte_job_id_1         IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                      ,pi_nte_job_id_2         IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                      ,pi_resultant_nte_job_id    OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                      ) IS
--
--   l_tab_a         tab_nte;
--   l_tab_b         tab_nte;
--   l_tab_a_intx_b  tab_nte;
--
BEGIN
 --
   Nm_Debug.proc_start (g_package_name,'create_temp_ne_intx_of_temp_ne');
 --
 --RC Task 0111807 - this code is not ideal. The data in the existing extents is perfectly formed to allow a direct query to generate a resultant extent. 
 --Original commented out until proper regression testing is completed. Perhaps there may be a reason why this is coded in this way but I can't see it.
 --It is likely to result in poor performance as well.
 --
 
 /* Task 0111807
   l_tab_a := get_tab_nte (pi_nte_job_id_1);
   l_tab_b := get_tab_nte (pi_nte_job_id_2);
 --
   create_temp_ne_intx_of_temp_ne
                      (pi_tab_nte_1 => l_tab_a
                      ,pi_tab_nte_2 => l_tab_b
                      ,po_tab_intx  => l_tab_a_intx_b
                      );
   IF l_tab_a_intx_b.COUNT > 0
    THEN
      ins_tab_nte (l_tab_a_intx_b);
      pi_resultant_nte_job_id := l_tab_a_intx_b(1).nte_job_id;
   END IF;
   l_tab_b.DELETE ;
   l_tab_b.DELETE ;
   l_tab_a_intx_b.DELETE ;
 --
*/ -- end  Task 0111807

   Nte_Intx_Nte(  p_nte1  => pi_nte_job_id_1
                 ,p_nte2  => pi_nte_job_id_2
                 ,p_nte3  => pi_resultant_nte_job_id ); 
                  
   Nm_Debug.proc_end (g_package_name,'create_temp_ne_intx_of_temp_ne');
 --
END create_temp_ne_intx_of_temp_ne;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION create_nte_from_npe(pi_npe_job_id IN NM_NW_PERSISTENT_EXTENTS.npe_job_id%TYPE
                              ) RETURN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE IS

    l_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE := Nm3net.get_next_nte_id;

  BEGIN
    Nm_Debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'create_nte_from_npe');

    INSERT INTO
      NM_NW_TEMP_EXTENTS(nte_job_id
                        ,nte_ne_id_of
                        ,nte_begin_mp
                        ,nte_end_mp
                        ,nte_cardinality
                        ,nte_seq_no
                        ,nte_route_ne_id)
    SELECT
      l_nte_job_id,
      npe_ne_id_of,
      npe_begin_mp,
      npe_end_mp,
      npe_cardinality,
      npe_seq_no,
      npe_route_ne_id
    FROM
      NM_NW_PERSISTENT_EXTENTS npe
    WHERE
      npe.npe_job_id = pi_npe_job_id;

    Nm_Debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_nte_from_npe');

    RETURN l_nte_job_id;

  END create_nte_from_npe;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION create_npe_from_nte(pi_nte_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                              ) RETURN NM_NW_PERSISTENT_EXTENTS.npe_job_id%TYPE IS

    l_npe_job_id NM_NW_PERSISTENT_EXTENTS.npe_job_id%TYPE := Nm3net.get_next_nte_id;

  BEGIN
    Nm_Debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'create_npe_from_nte');

    INSERT INTO
      NM_NW_PERSISTENT_EXTENTS(npe_job_id
                              ,npe_ne_id_of
                              ,npe_begin_mp
                              ,npe_end_mp
                              ,npe_cardinality
                              ,npe_seq_no
                              ,npe_route_ne_id)
    SELECT
      l_npe_job_id,
      nte_ne_id_of,
      nte_begin_mp,
      nte_end_mp,
      nte_cardinality,
      nte_seq_no,
      nte_route_ne_id
    FROM
      NM_NW_TEMP_EXTENTS nte
    WHERE
      nte.nte_job_id = pi_nte_job_id;

    Nm_Debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_npe_from_nte');

    RETURN l_npe_job_id;

  END create_npe_from_nte;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_nte_length(pi_nte_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                         ) RETURN NUMBER IS

    l_retval NUMBER;

  BEGIN
    Nm_Debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'get_nte_length');

    SELECT /*+RULE*/
      SUM(nte.nte_end_mp - nte.nte_begin_mp)
    INTO
      l_retval
    FROM
      NM_NW_TEMP_EXTENTS nte
    WHERE
      nte.nte_job_id = pi_nte_id;

    Nm_Debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_nte_length');

    RETURN l_retval;

  END get_nte_length;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_npe_length(pi_npe_id IN NM_NW_PERSISTENT_EXTENTS.npe_job_id%TYPE
                         ) RETURN NUMBER IS

    l_retval NUMBER;

  BEGIN
    Nm_Debug.proc_start(p_package_name   => g_package_name
                       ,p_procedure_name => 'get_npe_length');

    SELECT /*+RULE*/
      SUM(npe.npe_end_mp - npe.npe_begin_mp)
    INTO
      l_retval
    FROM
      NM_NW_PERSISTENT_EXTENTS npe
    WHERE
      npe.npe_job_id = pi_npe_id;

    Nm_Debug.proc_end(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_npe_length');

    RETURN l_retval;

  END get_npe_length;
  --
  -----------------------------------------------------------------------------
  --
PROCEDURE defrag_temp_extent (pi_nte_id           IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                             ,pi_force_resequence IN BOOLEAN DEFAULT FALSE
                             ) IS
--
   l_tab_old_nte_ne_id_of           Nm3type.tab_number;
   l_tab_old_nte_begin_mp           Nm3type.tab_number;
   l_tab_old_nte_end_mp             Nm3type.tab_number;
   l_tab_old_nte_cardinality        Nm3type.tab_number;
   l_tab_old_nte_seq_no             Nm3type.tab_number;
   l_tab_old_nte_route_ne_id        Nm3type.tab_number;
--
   l_tab_new_nte_ne_id_of           Nm3type.tab_number;
   l_tab_new_nte_begin_mp           Nm3type.tab_number;
   l_tab_new_nte_end_mp             Nm3type.tab_number;
   l_tab_new_nte_cardinality        Nm3type.tab_number;
   l_tab_new_nte_seq_no             Nm3type.tab_number;
   l_tab_new_nte_route_ne_id        Nm3type.tab_number;
--
   l_new_index                      PLS_INTEGER := 0;
   l_merge_done                     BOOLEAN     := FALSE;
--
   PROCEDURE move_old_to_new (p_old_index PLS_INTEGER) IS
   BEGIN
      l_new_index := l_new_index + 1;
      l_tab_new_nte_ne_id_of(l_new_index)    := l_tab_old_nte_ne_id_of(p_old_index);
      l_tab_new_nte_begin_mp(l_new_index)    := l_tab_old_nte_begin_mp(p_old_index);
      l_tab_new_nte_end_mp(l_new_index)      := l_tab_old_nte_end_mp(p_old_index);
      l_tab_new_nte_cardinality(l_new_index) := l_tab_old_nte_cardinality(p_old_index);
      l_tab_new_nte_seq_no(l_new_index)      := l_new_index;
      l_tab_new_nte_route_ne_id(l_new_index) := l_tab_old_nte_route_ne_id(p_old_index);
   END move_old_to_new;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'defrag_temp_extent');
--
   SELECT nte_ne_id_of
         ,nte_begin_mp
         ,nte_end_mp
         ,nte_cardinality
         ,nte_seq_no
         ,nte_route_ne_id
    BULK  COLLECT
    INTO  l_tab_old_nte_ne_id_of
         ,l_tab_old_nte_begin_mp
         ,l_tab_old_nte_end_mp
         ,l_tab_old_nte_cardinality
         ,l_tab_old_nte_seq_no
         ,l_tab_old_nte_route_ne_id
    FROM  NM_NW_TEMP_EXTENTS
   WHERE  nte_job_id = pi_nte_id
   ORDER BY nte_ne_id_of, nte_begin_mp, nte_end_mp; -- MJA log 701649 16-Aug-07
   --ORDER BY nte_seq_no, nte_ne_id_of, nte_begin_mp;
--
   DECLARE
      l_nothing_to_do EXCEPTION;
   BEGIN
--
      IF l_tab_old_nte_ne_id_of.COUNT IN (0,1)
       THEN
         -- If there is either no records or only 1
         --  in the temp no, so no defragmentation reqd
         RAISE l_nothing_to_do;
      END IF;
--
      l_merge_done := FALSE;
--
      move_old_to_new (p_old_index => 1);
--
      FOR i IN 2..l_tab_old_nte_ne_id_of.COUNT
       LOOP
         IF   l_tab_old_nte_ne_id_of(i-1) != l_tab_old_nte_ne_id_of(i)
          OR  l_tab_old_nte_begin_mp(i)    > l_tab_old_nte_end_mp(i-1)
          OR (l_tab_old_nte_begin_mp(i)    > l_tab_old_nte_end_mp(i)
              AND l_tab_old_nte_end_mp(i) != l_tab_old_nte_begin_mp(i-1)
             )
          THEN
            -- This is on a new element or there is a gap
            move_old_to_new (p_old_index => i);
         ELSE
            l_merge_done := TRUE;
            l_tab_new_nte_begin_mp(l_new_index) := LEAST(l_tab_new_nte_begin_mp(l_new_index),l_tab_old_nte_begin_mp(i));
            l_tab_new_nte_end_mp(l_new_index)   := GREATEST(l_tab_new_nte_end_mp(l_new_index),l_tab_old_nte_end_mp(i));
         END IF;
      END LOOP;
--
      IF NOT l_merge_done
       AND NOT pi_force_resequence
       THEN
         -- Nothing has been merged, so no point deleting and re-creating
         RAISE l_nothing_to_do;
      END IF;
--
      DELETE NM_NW_TEMP_EXTENTS
      WHERE  nte_job_id = pi_nte_id;
--
      FORALL i IN 1..l_tab_new_nte_end_mp.COUNT
         INSERT INTO NM_NW_TEMP_EXTENTS
                (nte_job_id
                ,nte_ne_id_of
                ,nte_begin_mp
                ,nte_end_mp
                ,nte_cardinality
                ,nte_seq_no
                ,nte_route_ne_id
                )
         VALUES (pi_nte_id
                ,l_tab_new_nte_ne_id_of(i)
                ,l_tab_new_nte_begin_mp(i)
                ,l_tab_new_nte_end_mp(i)
                ,l_tab_new_nte_cardinality(i)
                ,l_tab_new_nte_seq_no(i)
                ,l_tab_new_nte_route_ne_id(i)
                );
--
   EXCEPTION
      WHEN l_nothing_to_do
       THEN
         NULL;
   END;
--
   Nm_Debug.proc_end(g_package_name,'defrag_temp_extent');
--
END defrag_temp_extent;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_tab_nte (pi_tab_nte IN OUT NOCOPY tab_nte) IS
BEGIN
  -- I know you want to do a forall here but you can't (at least with 9i)
  -- you get
  -- PLS-00436: implementation restriction: cannot reference fields of
  -- BULK In-BIND table of records
   FOR i IN 1..pi_tab_nte.COUNT
    LOOP
      ins_nte (pi_tab_nte(i));
   END LOOP;
END ins_tab_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_nte (pi_nte_id  IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                     ) RETURN tab_nte IS
--
   CURSOR cs_nte (c_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
   SELECT *
    FROM  NM_NW_TEMP_EXTENTS
   WHERE  nte_job_id = c_nte_job_id
   ORDER BY nte_seq_no, nte_ne_id_of, nte_begin_mp;
--
   l_tab_nte tab_nte;
--
BEGIN
--
  OPEN cs_nte(pi_nte_id);
  FETCH cs_nte BULK COLLECT INTO l_tab_nte ;
  CLOSE cs_nte ;
  RETURN l_tab_nte;
--
END get_tab_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE nte_minus_nte (pi_nte_1      IN OUT NOCOPY tab_nte
                        ,pi_nte_2      IN OUT NOCOPY tab_nte
                        ,po_nte_result IN OUT NOCOPY tab_nte
                        ) IS
--
   l_nte_result NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'nte_minus_nte');
--
   l_nte_result := Nm3net.get_next_nte_id;
--
   po_nte_result := pi_nte_1;

   --
   FOR i IN 1..po_nte_result.COUNT
   LOOP
     po_nte_result(i).nte_job_id := l_nte_result;
   END LOOP;
   --
   -- If you are doing a minus of the empty set then just return
   -- the original set
   IF pi_nte_2.COUNT <> 0
   THEN
     FOR i IN 1..pi_nte_2.COUNT
     LOOP
       remove_rec_nte_from_nte (pi_tab_rec_nte  => po_nte_result
                              ,pi_rec_nte      => pi_nte_2(i)
                              );
     END LOOP;
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'nte_minus_nte');
--
END nte_minus_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE nte_minus_nte (pi_nte_1      IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                        ,pi_nte_2      IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                        ,po_nte_result    OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                        ) IS
--
   l_tab_nte_1 tab_nte;
   l_tab_nte_2 tab_nte;
   l_tab_nte_3 tab_nte;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'nte_minus_nte');
--
   l_tab_nte_1 := get_tab_nte(pi_nte_id => pi_nte_1);
   l_tab_nte_2 := get_tab_nte(pi_nte_id => pi_nte_2);

   po_nte_result := Nm3net.get_next_nte_id;
--
   nte_minus_nte (pi_nte_1      => l_tab_nte_1
                 ,pi_nte_2      => l_tab_nte_2
                 ,po_nte_result => l_tab_nte_3
                 );
--
   FOR i IN 1..l_tab_nte_3.COUNT
    LOOP
      po_nte_result := l_tab_nte_3(i).nte_job_id;
      ins_nte (l_tab_nte_3(i));
   END LOOP;
--
   Nm_Debug.proc_end(g_package_name,'nte_minus_nte');
--
END nte_minus_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE remove_rec_nte_from_nte (pi_nte_id  IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                  ,pi_rec_nte IN NM_NW_TEMP_EXTENTS%ROWTYPE
                                  ) IS
--
   l_tab_nte tab_nte;
--
BEGIN
--
   l_tab_nte := get_tab_nte (pi_nte_id);
--
   IF l_tab_nte.COUNT > 0
    THEN
      remove_rec_nte_from_nte (pi_tab_rec_nte => l_tab_nte
                              ,pi_rec_nte     => pi_rec_nte
                              );
      DELETE NM_NW_TEMP_EXTENTS
      WHERE  nte_job_id = l_tab_nte(1).nte_job_id;
      ins_tab_nte (l_tab_nte);
   END IF;
--
END remove_rec_nte_from_nte;
--
-----------------------------------------------------------------------------
--
PROCEDURE remove_rec_nte_from_nte (pi_tab_rec_nte  IN OUT NOCOPY tab_nte
                                  ,pi_rec_nte      IN     NM_NW_TEMP_EXTENTS%ROWTYPE
                                  ) IS
--
   l_tab_new_nte tab_nte;
   l_rec_nte     NM_NW_TEMP_EXTENTS%ROWTYPE;
   l_new_rec_nte NM_NW_TEMP_EXTENTS%ROWTYPE;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'remove_rec_nte_from_nte');
--
   DECLARE
      l_nothing_to_do EXCEPTION;
   BEGIN
   --
      IF  pi_rec_nte.nte_ne_id_of IS NULL
       OR pi_rec_nte.nte_begin_mp IS NULL
       OR pi_rec_nte.nte_end_mp   IS NULL
       OR pi_tab_rec_nte.COUNT = 0
       THEN
         RAISE l_nothing_to_do;
      END IF;
   --
      IF pi_rec_nte.nte_begin_mp > pi_rec_nte.nte_end_mp
       THEN
         RAISE_APPLICATION_ERROR(-20001,'Start MP cannot be after End MP :'||pi_rec_nte.nte_begin_mp||' > '||pi_rec_nte.nte_end_mp);
      END IF;
   --
      FOR i IN 1..pi_tab_rec_nte.COUNT
       LOOP
         l_rec_nte := pi_tab_rec_nte(i);
         IF l_rec_nte.nte_ne_id_of = pi_rec_nte.nte_ne_id_of
          THEN
            IF    l_rec_nte.nte_begin_mp  = l_rec_nte.nte_end_mp
             AND  pi_rec_nte.nte_begin_mp = pi_rec_nte.nte_end_mp
             AND  l_rec_nte.nte_begin_mp  = pi_rec_nte.nte_begin_mp
             THEN
               -- If this is a point and the one in the array is a point then remove it
               NULL;
            ELSIF l_rec_nte.nte_end_mp < pi_rec_nte.nte_begin_mp
             THEN
               --
               -- This placement ends before the start of the chunk to remove
               --
               l_tab_new_nte (l_tab_new_nte.COUNT+1) := l_rec_nte;
            ELSIF l_rec_nte.nte_begin_mp > pi_rec_nte.nte_end_mp
             THEN
               --
               -- This placement starts after the end of the chunk to remove
               --
               l_tab_new_nte (l_tab_new_nte.COUNT+1) := l_rec_nte;
            ELSE
               --
               -- This placement is affected
               --
               l_new_rec_nte     := l_rec_nte;
--
               IF l_rec_nte.nte_begin_mp < pi_rec_nte.nte_begin_mp
                THEN
                  --
                  -- This placement starts before the one to remove
                  --
                  l_new_rec_nte.nte_begin_mp   := l_rec_nte.nte_begin_mp;
                  l_new_rec_nte.nte_end_mp     := pi_rec_nte.nte_begin_mp;
                  l_tab_new_nte (l_tab_new_nte.COUNT+1) := l_new_rec_nte;
               END IF;
--
               IF l_rec_nte.nte_end_mp > pi_rec_nte.nte_end_mp
                THEN
                  --
                  -- This placement ends after the one to remove
                  --
                  l_new_rec_nte.nte_begin_mp   := pi_rec_nte.nte_end_mp;
                  l_new_rec_nte.nte_end_mp     := l_rec_nte.nte_end_mp;
                  l_tab_new_nte (l_tab_new_nte.COUNT+1) := l_new_rec_nte;
               END IF;
--
            END IF;
         ELSE
            -- Different element - add regardless
            l_tab_new_nte (l_tab_new_nte.COUNT+1) := l_rec_nte;
         END IF;
      END LOOP;
--
      pi_tab_rec_nte := l_tab_new_nte;
--
   EXCEPTION
      WHEN l_nothing_to_do
       THEN
         NULL;
   END;
--
   Nm_Debug.proc_end(g_package_name,'remove_rec_nte_from_nte');
--
END remove_rec_nte_from_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nte_source_from_roi_type (pi_roi_type VARCHAR2) RETURN NM_PBI_QUERY_RESULTS.nqr_source%TYPE IS
--
   l_source NM_PBI_QUERY_RESULTS.nqr_source%TYPE;
--
BEGIN
--
   IF    pi_roi_type = c_roi_extent
    THEN
      l_source := c_saved;
   ELSIF pi_roi_type = c_roi_temp_ne
    THEN
      l_source := c_temp_ne;
   ELSIF pi_roi_type = c_roi_pbi
    THEN
      l_source := c_pbi;
   ELSIF pi_roi_type = c_roi_gis
    THEN
      l_source := c_gis;
   ELSE
      l_source := c_route;
   END IF;
--
   RETURN l_source;
--
END get_nte_source_from_roi_type;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_type_from_nte_source(pi_source    IN NM_PBI_QUERY_RESULTS.nqr_source%TYPE
                                     ,pi_source_id IN NUMBER
                                     ) RETURN VARCHAR2 IS

  e_invalid_source EXCEPTION;

  l_retval VARCHAR2(2000);

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_roi_type_from_nte_source');

  IF pi_source = Nm3extent.get_saved
  THEN
    l_retval := c_roi_extent;

  ELSIF pi_source = Nm3extent.get_temp_ne
  THEN
    l_retval := c_roi_temp_ne;

  ELSIF pi_source = Nm3extent.get_pbi
  THEN
    l_retval := c_roi_pbi;

  ELSIF pi_source = Nm3extent.get_route
  THEN
    l_retval := Nm3get.get_ne_all(pi_ne_id => pi_source_id).ne_type;
  ELSE
    RAISE e_invalid_source;
  END IF;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_roi_type_from_nte_source');

  RETURN l_retval;

EXCEPTION
  WHEN e_invalid_source
  THEN
    Hig.raise_ner(pi_appl               => Nm3type.c_hig
                 ,pi_id                 => 110
                 ,pi_supplementary_info => 'get_roi_type_from_nte_source.pi_source= "' || pi_source || '"');

END get_roi_type_from_nte_source;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_roi_details (pi_roi_type    IN     VARCHAR2
                          ,pi_roi_id      IN     NUMBER
                          ,po_roi_details    OUT rec_roi_details
                          ) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'get_roi_details');
--
   po_roi_details.roi_id          := NULL;
   po_roi_details.roi_type        := NULL;
   po_roi_details.roi_name        := NULL;
   po_roi_details.roi_descr       := NULL;
   po_roi_details.roi_group_type  := NULL;
   po_roi_details.roi_icon        := NULL;
   po_roi_details.roi_linear      := NULL;
   po_roi_details.roi_min_mp      := NULL;
   po_roi_details.roi_max_mp      := NULL;
   po_roi_details.roi_units       := NULL;
   po_roi_details.roi_datum_units := NULL;
--
   IF pi_roi_id IS NOT NULL
    THEN
      po_roi_details.roi_id       := pi_roi_id;
      po_roi_details.roi_type     := pi_roi_type;
--
      IF pi_roi_type IN (c_roi_section,c_roi_db,c_roi_gos,c_roi_gog)
       THEN
         ---------
         --element
         ---------
         DECLARE
            l_rec_ne nm_elements%ROWTYPE;
            l_nt_rec NM_TYPES%ROWTYPE;

         BEGIN
            l_rec_ne := Nm3net.get_ne(pi_roi_id);
            l_nt_rec := Nm3net.get_nt(pi_nt_type => l_rec_ne.ne_nt_type);

            po_roi_details.roi_name       := l_rec_ne.ne_unique;
            po_roi_details.roi_descr      := l_rec_ne.ne_descr;
            po_roi_details.roi_group_type := l_rec_ne.ne_gty_group_type;

            IF l_rec_ne.ne_gty_group_type IS NOT NULL
             THEN
               po_roi_details.roi_icon  := Nm3net.get_gty_icon(l_rec_ne.ne_gty_group_type);
            END IF;

            IF l_rec_ne.ne_gty_group_type IS NULL
              OR Nm3net.is_gty_linear(p_gty => l_rec_ne.ne_gty_group_type) = 'Y'
            THEN
              --linear
              po_roi_details.roi_linear := TRUE;

              IF l_rec_ne.ne_type = 'S'
              THEN
                po_roi_details.roi_min_mp      := 0;
                po_roi_details.roi_max_mp      := l_rec_ne.ne_length;
              	po_roi_details.roi_datum_units := l_nt_rec.nt_length_unit;
              ELSE
              	po_roi_details.roi_min_mp      := Nm3net.get_min_slk(pi_ne_id => pi_roi_id);
              	po_roi_details.roi_max_mp      := Nm3net.get_max_slk(pi_ne_id => pi_roi_id);
              END IF;

              IF l_rec_ne.ne_type = 'G'
              THEN
                Nm3net.get_group_units(pi_group_type  => l_rec_ne.ne_gty_group_type
                                      ,po_group_units => po_roi_details.roi_units
                                      ,po_child_units => po_roi_details.roi_datum_units);
              ELSE
              	po_roi_details.roi_units       := l_nt_rec.nt_length_unit;
              END IF;
            ELSE
              --non-linear
	            po_roi_details.roi_linear := FALSE;
            END IF;
         END;

      ELSIF pi_roi_type = c_roi_extent
       THEN
         --------
         --extent
         --------
         DECLARE
            l_rec_nse NM_SAVED_EXTENTS%ROWTYPE;
         BEGIN
            l_rec_nse                := Nm3extent.get_nse(pi_roi_id);
            po_roi_details.roi_name  := l_rec_nse.nse_name;
            po_roi_details.roi_descr := SUBSTR(l_rec_nse.nse_descr, 1, 80);
         END;

      ELSIF pi_roi_type = c_roi_pbi
       THEN
         -----
         --pbi
         -----
         DECLARE
            l_rec_nqr NM_PBI_QUERY_RESULTS%ROWTYPE;
            l_rec_npq NM_PBI_QUERY%ROWTYPE;
         BEGIN
            l_rec_nqr                := Nm3pbi.select_npr (pi_roi_id);
            l_rec_npq                := Nm3pbi.get_npq    (l_rec_nqr.nqr_npq_id);
            po_roi_details.roi_name  := l_rec_npq.npq_unique;
            po_roi_details.roi_descr := l_rec_nqr.nqr_description;
         END;

      ELSIF pi_roi_type = c_roi_temp_ne
       THEN
         ---------
         --temp ne
         ---------
         po_roi_details.roi_name     := Nm3gaz_Qry.get_roi_name;
         po_roi_details.roi_descr    := Nm3gaz_Qry.get_roi_descr;

      ELSIF pi_roi_type = c_roi_gis
       THEN
         -----
         --gis
         -----
         po_roi_details.roi_name     := Higgis.get_roi_name;
         po_roi_details.roi_descr    := Higgis.get_roi_descr;
      ELSE
         Hig.raise_ner (pi_appl               => Nm3type.c_hig
                       ,pi_id                 => 110
                       ,pi_supplementary_info => 'pi_roi_type="'||pi_roi_type||'"'
                       );
      END IF;
--
   END IF;
--
   Nm_Debug.proc_end(g_package_name,'get_roi_details');
--
END get_roi_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_details(pi_roi_type    IN     VARCHAR2
                        ,pi_roi_id      IN     NUMBER
                        ) RETURN rec_roi_details IS

  l_retval rec_roi_details;

BEGIN
  get_roi_details(pi_roi_type    => pi_roi_type
                 ,pi_roi_id      => pi_roi_id
                 ,po_roi_details => l_retval);

  RETURN l_retval;

END get_roi_details;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_name  (pi_roi_type    IN     VARCHAR2
                       ,pi_roi_id      IN     NUMBER
                       ) RETURN nm_elements.ne_unique%TYPE IS
BEGIN
   RETURN get_roi_details(pi_roi_type => pi_roi_type
                         ,pi_roi_id   => pi_roi_id
                         ).roi_name;
END get_roi_name;
--
-----------------------------------------------------------------------------
--
FUNCTION get_roi_descr (pi_roi_type    IN     VARCHAR2
                       ,pi_roi_id      IN     NUMBER
                       ) RETURN nm_elements.ne_descr%TYPE IS
BEGIN
   RETURN get_roi_details(pi_roi_type => pi_roi_type
                         ,pi_roi_id   => pi_roi_id
                         ).roi_descr;
END get_roi_descr;
--
-----------------------------------------------------------------------------
--
PROCEDURE copy_nte_into_arrays(pi_nte_id               IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                              ,po_nte_job_id_tab          OUT Nm3type.tab_number
                              ,po_nte_ne_id_of_tab        OUT Nm3type.tab_number
                              ,po_nte_begin_mp_tab        OUT Nm3type.tab_number
                              ,po_nte_end_mp_tab          OUT Nm3type.tab_number
                              ,po_nte_cardinality_tab     OUT Nm3type.tab_number
                              ,po_nte_seq_no_tab          OUT Nm3type.tab_number
                              ,po_nte_route_ne_id_tab     OUT Nm3type.tab_number
                              ) IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'copy_nte_into_arrays');

  SELECT
    nte.nte_job_id,
    nte.nte_ne_id_of,
    nte.nte_begin_mp,
    nte.nte_end_mp,
    nte.nte_cardinality,
    nte.nte_seq_no,
    nte.nte_route_ne_id
  BULK COLLECT INTO
    po_nte_job_id_tab,
    po_nte_ne_id_of_tab,
    po_nte_begin_mp_tab,
    po_nte_end_mp_tab,
    po_nte_cardinality_tab,
    po_nte_seq_no_tab,
    po_nte_route_ne_id_tab
  FROM
    NM_NW_TEMP_EXTENTS nte
  WHERE
    nte.nte_job_id = pi_nte_id;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'copy_nte_into_arrays');

END copy_nte_into_arrays;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_temp_ne_from_arrays(pi_nte_ne_id_of_tab     IN     Nm3type.tab_number
                                    ,pi_nte_begin_mp_tab     IN     Nm3type.tab_number
                                    ,pi_nte_end_mp_tab       IN     Nm3type.tab_number
                                    ,pi_nte_cardinality_tab  IN     Nm3type.tab_number
                                    ,pi_nte_seq_no_tab       IN     Nm3type.tab_number
                                    ,pi_nte_route_ne_id_tab  IN     Nm3type.tab_number
                                    ,po_nte_id                  OUT NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                    ) IS
BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_temp_ne_from_arrays');

  po_nte_id := Nm3net.get_next_nte_id;

  FORALL l_i IN 1..pi_nte_ne_id_of_tab.COUNT
    INSERT INTO
      NM_NW_TEMP_EXTENTS(nte_job_id
                        ,nte_ne_id_of
                        ,nte_begin_mp
                        ,nte_end_mp
                        ,nte_cardinality
                        ,nte_seq_no
                        ,nte_route_ne_id)
    VALUES(po_nte_id
          ,pi_nte_ne_id_of_tab(l_i)
          ,pi_nte_begin_mp_tab(l_i)
          ,pi_nte_end_mp_tab(l_i)
          ,pi_nte_cardinality_tab(l_i)
          ,pi_nte_seq_no_tab(l_i)
          ,pi_nte_route_ne_id_tab(l_i));

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_temp_ne_from_arrays');

END create_temp_ne_from_arrays;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_saved_ne_from_nte_aut(pi_nte_ne_id_of_tab     IN     Nm3type.tab_number
                                      ,pi_nte_begin_mp_tab     IN     Nm3type.tab_number
                                      ,pi_nte_end_mp_tab       IN     Nm3type.tab_number
                                      ,pi_nte_cardinality_tab  IN     Nm3type.tab_number
                                      ,pi_nte_seq_no_tab       IN     Nm3type.tab_number
                                      ,pi_nte_route_ne_id_tab  IN     Nm3type.tab_number
                                      ,pi_nse_owner            IN     NM_SAVED_EXTENTS.nse_owner%TYPE DEFAULT USER
                                      ,pi_nse_name             IN     NM_SAVED_EXTENTS.nse_name%TYPE
                                      ,pi_nse_descr            IN     NM_SAVED_EXTENTS.nse_descr%TYPE
                                      ,po_nse_id                  OUT NM_SAVED_EXTENTS.nse_id%TYPE
                                      ) IS

  PRAGMA autonomous_transaction;

  l_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_saved_ne_from_nte_aut');

  create_temp_ne_from_arrays(pi_nte_ne_id_of_tab    => pi_nte_ne_id_of_tab
                            ,pi_nte_begin_mp_tab    => pi_nte_begin_mp_tab
                            ,pi_nte_end_mp_tab      => pi_nte_end_mp_tab
                            ,pi_nte_cardinality_tab => pi_nte_cardinality_tab
                            ,pi_nte_seq_no_tab      => pi_nte_seq_no_tab
                            ,pi_nte_route_ne_id_tab => pi_nte_route_ne_id_tab
                            ,po_nte_id              => l_nte_job_id);

  debug_temp_extents(l_nte_job_id);

  create_saved_ne_from_temp_ne(pi_nte_job_id => l_nte_job_id
                              ,pi_nse_owner  => pi_nse_owner
                              ,pi_nse_name   => pi_nse_name
                              ,pi_nse_descr  => pi_nse_descr
                              ,po_nse_id     => po_nse_id);

  COMMIT;

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_saved_ne_from_nte_aut');

END create_saved_ne_from_nte_aut;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_saved_ne_from_gaz_query(pi_ngq_id     IN     NM_GAZ_QUERY.ngq_id%TYPE
                                        ,pi_nse_owner  IN     NM_SAVED_EXTENTS.nse_owner%TYPE DEFAULT USER
                                        ,pi_nse_name   IN     NM_SAVED_EXTENTS.nse_name%TYPE
                                        ,pi_nse_descr  IN     NM_SAVED_EXTENTS.nse_descr%TYPE
                                        ,po_nse_id        OUT NM_SAVED_EXTENTS.nse_id%TYPE
                                        ) IS

  l_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;

  l_nte_job_id_tab      Nm3type.tab_number;
  l_nte_ne_id_of_tab    Nm3type.tab_number;
  l_nte_begin_mp_tab    Nm3type.tab_number;
  l_nte_end_mp_tab      Nm3type.tab_number;
  l_nte_cardinality_tab Nm3type.tab_number;
  l_nte_seq_no_tab      Nm3type.tab_number;
  l_nte_route_ne_id_tab Nm3type.tab_number;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'create_saved_ne_from_gaz_query');

  l_nte_job_id := Nm3gaz_Qry.perform_query(pi_ngq_id         => pi_ngq_id
                                          ,pi_effective_date => Nm3user.get_effective_date);

  copy_nte_into_arrays(pi_nte_id              => l_nte_job_id
                      ,po_nte_job_id_tab      => l_nte_job_id_tab
                      ,po_nte_ne_id_of_tab    => l_nte_ne_id_of_tab
                      ,po_nte_begin_mp_tab    => l_nte_begin_mp_tab
                      ,po_nte_end_mp_tab      => l_nte_end_mp_tab
                      ,po_nte_cardinality_tab => l_nte_cardinality_tab
                      ,po_nte_seq_no_tab      => l_nte_seq_no_tab
                      ,po_nte_route_ne_id_tab => l_nte_route_ne_id_tab);

  create_saved_ne_from_nte_aut(pi_nte_ne_id_of_tab    => l_nte_ne_id_of_tab
                              ,pi_nte_begin_mp_tab    => l_nte_begin_mp_tab
                              ,pi_nte_end_mp_tab      => l_nte_end_mp_tab
                              ,pi_nte_cardinality_tab => l_nte_cardinality_tab
                              ,pi_nte_seq_no_tab      => l_nte_seq_no_tab
                              ,pi_nte_route_ne_id_tab => l_nte_route_ne_id_tab
                              ,pi_nse_owner           => pi_nse_owner
                              ,pi_nse_name            => pi_nse_name
                              ,pi_nse_descr           => pi_nse_descr
                              ,po_nse_id              => po_nse_id);

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'create_saved_ne_from_gaz_query');

END create_saved_ne_from_gaz_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE open_nte_for_adjoining_point (p_nte_job_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
--
   PROCEDURE do_it_for_node_type (p_node_type nm_node_usages.nnu_node_type%TYPE) IS
   BEGIN
      SELECT /*+ RULE */
             nnu2.nnu_ne_id
            ,nnu2.nnu_chain
            ,nnu2.nnu_chain
            ,1
            ,nte.nte_seq_no
            ,nnu2.nnu_ne_id
        BULK COLLECT
        INTO g_tab_nte_ne_id_of
            ,g_tab_nte_begin_mp
            ,g_tab_nte_end_mp
            ,g_tab_nte_cardinality
            ,g_tab_nte_seq_no
            ,g_tab_nte_route_ne_id
        FROM nm_node_usages     nnu1
            ,nm_node_usages     nnu2
            ,NM_NW_TEMP_EXTENTS nte
      WHERE  nte.nte_job_id      =   p_nte_job_id
       AND   nte.nte_ne_id_of    =   nnu1.nnu_ne_id
       AND   nnu1.nnu_chain     IN (nte.nte_begin_mp, nte.nte_end_mp)
       AND   nnu1.nnu_node_type  =   p_node_type
       AND   nnu1.nnu_no_node_id =   nnu2.nnu_no_node_id
       AND   NOT EXISTS (SELECT 1
                          FROM  NM_NW_TEMP_EXTENTS nte2
                         WHERE  nte2.nte_job_id =  p_nte_job_id
                          AND   nnu2.nnu_ne_id  =  nte2.nte_ne_id_of
                          AND   nnu2.nnu_chain IN (nte2.nte_begin_mp, nte2.nte_end_mp)
                        );
      insert_nte_globals (p_nte_job_id);
   END do_it_for_node_type;
--
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'open_nte_for_adjoining_point');
--
-- Have to do it for each node type seperately otherwise
--  in the case below the intersecting point is added twice
--  because the NOT EXISTS does not pick up the fact
--  that it had already been found in the same statement for another
--  element
--                        x
--                        |
--                        |
--                        |
--                        |
-- x----------------------x------------------------x
--
   do_it_for_node_type (p_node_type => 'S');
   do_it_for_node_type (p_node_type => 'E');
--
   Nm_Debug.proc_end(g_package_name,'open_nte_for_adjoining_point');
--
END open_nte_for_adjoining_point;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_extent
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_extent;
END get_c_roi_extent;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_pbi
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_pbi;
END get_c_roi_pbi;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_temp_ne
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_temp_ne;
END get_c_roi_temp_ne;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_section
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_section;
END get_c_roi_section;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_db
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_db;
END get_c_roi_db;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_gos
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_gos;
END get_c_roi_gos;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_gog
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_gog;
END get_c_roi_gog;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_roi_gis
RETURN VARCHAR2
IS
BEGIN
   RETURN c_roi_gis;
END get_c_roi_gis;
--
-----------------------------------------------------------------------------
--
FUNCTION get_nte_unit_id (p_nte_job_id NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) RETURN NM_UNITS.un_unit_id%TYPE IS
   l_tab_un_unit_id Nm3type.tab_number;
   l_retval         NM_UNITS.un_unit_id%TYPE;
BEGIN
   SELECT /*+ RULE */ nt_length_unit
    BULK  COLLECT
    INTO  l_tab_un_unit_id
    FROM  NM_NW_TEMP_EXTENTS
         ,nm_elements
         ,NM_TYPES
   WHERE  nte_job_id   = p_nte_job_id
    AND   nte_ne_id_of = ne_id
    AND   ne_nt_type   = nt_type
   GROUP BY nt_length_unit;
   IF l_tab_un_unit_id.COUNT = 1
    THEN
      l_retval := l_tab_un_unit_id(1);
   ELSIF l_tab_un_unit_id.COUNT > 1
    THEN
      Hig.raise_ner (pi_appl => Nm3type.c_net
                    ,pi_id   => 323
                    );
   END IF;
   RETURN l_retval;
END get_nte_unit_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_connected_chunks_for_nte(pi_nte_job_id  IN     NM_NW_TEMP_EXTENTS.nte_job_id%TYPE
                                      ,pi_route_id    IN     nm_elements.ne_id%TYPE
                                      ,pi_obj_type    IN     nm_members.nm_obj_type%TYPE
                                      ,pio_chunks_tab IN OUT NOCOPY Nm3route_Ref.tab_rec_route_loc_dets
                                      ) IS

  l_pl     nm_placement;
  l_pl_arr nm_placement_array;

BEGIN
  Nm_Debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'get_connected_chunks_for_nte');

  l_pl_arr := Nm3pla.get_connected_chunks(p_nte_job_id => pi_nte_job_id
                                         ,p_route_id   => pi_route_id
                                         ,p_obj_type   => pi_obj_type);

  pio_chunks_tab := Nm3asset.pop_route_loc_det_tab_from_pl(pi_pl_arr => l_pl_arr);

  Nm_Debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'get_connected_chunks_for_nte');

END get_connected_chunks_for_nte;
--
-----------------------------------------------------------------------------
--
FUNCTION remove_overlaps(pi_nte_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE)
RETURN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE IS

  CURSOR get_entries_on_datum(pi_nte_id IN NM_NW_TEMP_EXTENTS.nte_job_id%TYPE) IS
  SELECT nte.*
  FROM   NM_NW_TEMP_EXTENTS nte
  WHERE  nte_job_id = pi_nte_id
  ORDER BY MIN(nte_seq_no) OVER (PARTITION BY nte_ne_id_of ORDER BY nte_seq_no ASC)
          ,nte_ne_id_of
          ,nte_begin_mp ASC
          ,nte_end_mp DESC;

  l_curr_nte            NM_NW_TEMP_EXTENTS%ROWTYPE;
  l_last_nte            NM_NW_TEMP_EXTENTS%ROWTYPE;
  l_nte_job_id          NM_NW_TEMP_EXTENTS.nte_job_id%TYPE;
  l_found               BOOLEAN;
  l_nte_ne_id_of_tab    Nm3type.tab_number;
  l_nte_begin_mp_tab    Nm3type.tab_number;
  l_nte_end_mp_tab      Nm3type.tab_number;
  l_nte_cardinality_tab Nm3type.tab_number;
  l_nte_seq_no_tab      Nm3type.tab_number;
  l_nte_route_ne_id_tab Nm3type.tab_number;

  nothing_to_do         EXCEPTION;

  PROCEDURE add_to_array(p_nte NM_NW_TEMP_EXTENTS%ROWTYPE) IS
    l_count PLS_INTEGER;
  BEGIN
    l_count := l_nte_ne_id_of_tab.COUNT + 1;

    l_nte_ne_id_of_tab(l_count)    := p_nte.nte_ne_id_of;
    l_nte_begin_mp_tab(l_count)    := p_nte.nte_begin_mp;
    l_nte_end_mp_tab(l_count)      := p_nte.nte_end_mp;
    l_nte_cardinality_tab(l_count) := p_nte.nte_cardinality;
    l_nte_seq_no_tab(l_count)      := l_count;
    l_nte_route_ne_id_tab(l_count) := p_nte.nte_route_ne_id;
  END add_to_array;
  --
  PROCEDURE upd_end_of_last(p_end NM_NW_TEMP_EXTENTS.nte_end_mp%TYPE) IS
  BEGIN
    l_nte_end_mp_tab(l_nte_end_mp_tab.COUNT) := p_end;
  END upd_end_of_last;
  --
BEGIN
  -- for an overlap there must be more than one entry per road
  -- so restrict by that
  OPEN  get_entries_on_datum(pi_nte_id);
  FETCH get_entries_on_datum INTO l_curr_nte;
  l_found := get_entries_on_datum%FOUND;
  IF NOT l_found THEN
    -- no rows to process
    CLOSE get_entries_on_datum;
    RAISE nothing_to_do;
  END IF;
  add_to_array(l_curr_nte);

  LOOP
    l_last_nte := l_curr_nte;
    FETCH get_entries_on_datum INTO l_curr_nte;
    EXIT WHEN get_entries_on_datum%NOTFOUND;

    IF l_curr_nte.nte_ne_id_of = l_last_nte.nte_ne_id_of THEN
      -- last road is the same check for overlaps
      IF (l_curr_nte.nte_begin_mp = l_last_nte.nte_begin_mp)
         OR (l_curr_nte.nte_begin_mp <= NVL(l_last_nte.nte_end_mp, Nm3net.get_datum_element_length(l_last_nte.nte_ne_id_of)))
      THEN
        -- we have an overlap
        -- unless the end mp of this is beyond the last then ignore
        -- of one of the end mp's are null then ignore
        IF NVL(l_curr_nte.nte_end_mp, 0) > NVL(l_last_nte.nte_end_mp,0) THEN
          upd_end_of_last(l_curr_nte.nte_end_mp);
        END IF;
      ELSE
        add_to_array(l_curr_nte);
      END IF;
    ELSE
      -- different datum to last - no overlap
      add_to_array(l_curr_nte);
    END IF;
  END LOOP;
  CLOSE get_entries_on_datum;

  create_temp_ne_from_arrays(pi_nte_ne_id_of_tab    => l_nte_ne_id_of_tab
                            ,pi_nte_begin_mp_tab    => l_nte_begin_mp_tab
                            ,pi_nte_end_mp_tab      => l_nte_end_mp_tab
                            ,pi_nte_cardinality_tab => l_nte_cardinality_tab
                            ,pi_nte_seq_no_tab      => l_nte_seq_no_tab
                            ,pi_nte_route_ne_id_tab => l_nte_route_ne_id_tab
                            ,po_nte_id              => l_nte_job_id);

  RETURN l_nte_job_id;
EXCEPTION
  WHEN nothing_to_do THEN
    RETURN pi_nte_id;
END remove_overlaps;
--
-- RC Task 0111807 - problem in the Nte_Intx_Nte procedure - it is not commutative - different results are created as
-- the order of arguments changes. The original procedure exits but a new one has been created which operates directly on
-- the extent and not the tab_nte arguments..
--
Procedure Nte_Intx_Nte( p_nte1 in nm_nw_temp_extents.nte_job_id%type, 
                        p_nte2 in nm_nw_temp_extents.nte_job_id%type, 
                        p_nte3 out nm_nw_temp_extents.nte_job_id%type ) is
begin
p_nte3 := Nm3net.get_next_nte_id;
insert into nm_nw_temp_extents
( nte_job_id, nte_ne_id_of, nte_begin_mp, nte_end_mp, nte_cardinality, nte_seq_no, nte_route_ne_id )
select p_nte3, a.nte_ne_id_of, greatest( a.nte_begin_mp, b.nte_begin_mp ), least( a.nte_end_mp, b.nte_end_mp ), a.nte_cardinality, a.nte_seq_no, a.nte_route_ne_id
from nm_nw_temp_extents a,  nm_nw_temp_extents b
where a.nte_job_id = p_nte1
and   b.nte_job_id = p_nte2
and   a.nte_begin_mp <= b.nte_end_mp
and   b.nte_begin_mp <= a.nte_end_mp
and a.nte_ne_id_of = b.nte_ne_id_of;
end;

--
-----------------------------------------------------------------------------
-- This assumes that the smallest and largest NTE's have been set
Procedure Nte_Intx_Nte(
                      pi_Smallest_Nte   In Out Nocopy Tab_Nte,
                      pi_Largest_Nte    In Out Nocopy Tab_Nte,
                      po_Nte_Result     In Out Nocopy Tab_Nte
                      ) 
Is
  l_nte_from_list       t_tab_of_tab_number ;
  l_Of_List             Nm3type.Tab_Number ;
  l_Common_Elements     Nm3type.Tab_Number ;
  l_Nte_A               Nm_Nw_Temp_Extents%Rowtype ;
  l_Nte_B               Nm_Nw_Temp_Extents%Rowtype ;
  l_Nte_Result          Nm_Nw_Temp_Extents.Nte_Job_Id%Type;
  l_Overlaps_Expanded   Boolean ;
  l_Of                  Number ;
  
  -- Copy the Parameters so when we call Expand_Overlaps the changed arrays are not passed all the way back out of Nte_Intx_Nte, 
  --   corrupting the assest and route data. for the next interation
  l_Smallest_Nte      Tab_Nte :=pi_Smallest_Nte;
  l_Largest_Nte       Tab_Nte :=pi_Largest_Nte;
  
  --
  --
  --
  Function Nte_Is_Common  (
                          p_Nte_1 In Nm_Nw_Temp_Extents%Rowtype,
                          p_Nte_2 In Nm_Nw_Temp_Extents%Rowtype
                          ) Return Boolean
  Is
  Begin
    -- We have already checked that the 'of' values are the same
    -- Nodes have been expanded so all we need to worry
    -- about is equality
    Return  (    p_Nte_1.Nte_End_Mp   = p_Nte_2.Nte_End_Mp
            And  p_Nte_1.Nte_Begin_Mp = p_Nte_2.Nte_Begin_Mp
            );
  End Nte_Is_Common ;
  --
  --
  --
  Procedure Expand_Overlaps
    ( p_Nte_1            In Out Nocopy Nm_Nw_Temp_Extents%Rowtype
    , p_Nte_2            In Out Nocopy Nm_Nw_Temp_Extents%Rowtype
    , p_Overlap_Expanded In Out Nocopy Boolean
    ) Is
  
  l_New_Rec_Nte   Nm_Nw_Temp_Extents%Rowtype ;
  
  Begin
    -- Code adapted from remove_rec_nte_from_nte
    -- We have already checked that the 'of' values are the same
    If        p_Nte_1.Nte_Begin_Mp  =   p_Nte_2.Nte_Begin_Mp
        And   p_Nte_1.Nte_End_Mp    =   p_Nte_2.Nte_End_Mp  Then
      
      Db('1');
      Return ;
      
    Elsif   p_Nte_1.Nte_End_Mp  <   p_Nte_2.Nte_Begin_Mp  Then
      --
      -- This placement ends before the start of the chunk to remove
      --
      Db('2');
      Return ;
    
    Elsif p_Nte_1.Nte_Begin_Mp  >   p_Nte_2.Nte_End_Mp  Then
      --
      -- This placement starts after the end of the chunk to remove
      --
      Return ;
    Else
      --null ;
      --
      -- This placement is affected
      --
      l_New_Rec_Nte     := p_Nte_1;
      --
      If P_Nte_1.Nte_Begin_Mp < P_Nte_2.Nte_Begin_Mp  Then
        --
        -- This placement starts before the one to remove
        --
        l_New_Rec_Nte.Nte_Begin_Mp   := p_Nte_1.Nte_Begin_Mp;
        l_New_Rec_Nte.Nte_End_Mp     := p_Nte_2.Nte_Begin_Mp;
        Db('3');
      End If;
      --
      If P_Nte_1.Nte_End_Mp > P_Nte_2.Nte_End_Mp  Then
        --
        -- This placement ends after the one to remove
        --
        l_New_Rec_Nte.Nte_Begin_Mp   := p_Nte_2.Nte_End_Mp;
        l_New_Rec_Nte.Nte_End_Mp     := p_Nte_1.Nte_End_Mp;
        Db('4');
      End If;
      --
      p_Nte_1             :=  l_New_Rec_Nte ;
      p_Nte_2             :=  l_New_Rec_Nte ;
      p_Overlap_Expanded  :=  True ;
      Db('5');
    End If ;
  End Expand_Overlaps ;
  --
  --
  -- Debug and unit test harness code
  Procedure Dump_Of_List  (
                          Nam   Varchar2, 
                          L     T_Tab_Of_Tab_Number
                          )
  Is
    l_Of  Integer ;
  Begin
    Db('dump ' || Nam );
    l_Of := L.First ;
    Loop
      Exit When l_Of Is Null ;
      
      For i In 1..L(l_Of).Count
      Loop
        Db('l_of,i,val ' ||l_Of  || ',' || i || ',' || L(l_Of)(i));
      End Loop ;
      
      l_Of := L.Next(l_Of) ;
      
    End Loop ;
    
    Db('dump ' || Nam || ' finished ' );
    
  End Dump_Of_List ;
  --
  --
  --  
  Procedure Dump_List (
                      Nam                 Varchar2,
                      L     In Out Nocopy Tab_Nte
                      )
  Is
  Begin
    Db('dump ' || Nam );

    Db('i,NTE_JOB_ID,NTE_NE_ID_OF,NTE_BEGIN_MP,NTE_END_MP,NTE_CARDINALITY,NTE_SEQ_NO,NTE_ROUTE_NE_ID');
    For i In 1..L.Count
    Loop
      Db(i|| ',' ||L(i).Nte_Job_Id||',' ||L(i).Nte_Ne_Id_Of||',' ||L(i).Nte_Begin_Mp||',' ||L(i).Nte_End_Mp||',' ||L(i).Nte_Cardinality||',' ||L(i).Nte_Seq_No||',' ||L(i).Nte_Route_Ne_Id);
    End Loop ;

    Db('dump ' || Nam || ' finished ' );

  End Dump_List ;
  --
  --
  --
Begin -- main program
  Nm_Debug.Proc_Start (G_Package_Name,'nte_intx_nte');
  po_Nte_Result.Delete;

  If     l_Smallest_Nte.Count = 0   
     Or  l_Largest_Nte.Count  = 0   Then
    Return ;
  End If ;

  If l_Smallest_Nte.Count > l_Largest_Nte.Count  Then
    Raise_Application_Error(-20193,'Smallest and largest NTE tables are the wrong way round - giving up');
  End If ;

  l_Nte_Result := Nm3net.Get_Next_Nte_Id;

  -- Pre-process the from list for the larger table
  -- this will give us a list of lists of the indicies of the nte
  -- indexed by the 'of' id of each ne

  For i In 1..l_Largest_Nte.Count
  Loop
    l_Of := l_Largest_Nte(I).Nte_Ne_Id_Of ;
    Db( 'processing ' || I || ' l_of = ' || l_Of ) ;
    If Not L_Nte_From_List.Exists(l_Of) Then
      l_Nte_From_List(l_Of)(1) := i ;
    Else
      l_Nte_From_List(l_Of)(l_Nte_From_List(l_Of).Count+1) := i;
    End If ;
  End Loop ;

  Dump_Of_List( 'l_nte_from_list', L_Nte_From_List ) ;
  Dump_List( 'pi_largest_nte', l_Largest_Nte ) ;
  Dump_List( 'pi_smallest_nte', l_Smallest_Nte ) ;

  Db('!');
  -- return ;

  l_Overlaps_Expanded := True ;
  -- Keep going around until there are no overlaps to expand
  -- l_of is being used as a marker to stop infinite loops
  -- (which should never happen but ...)
  l_Of := 1 ;
  While l_Overlaps_Expanded   And   l_Of < 20
  Loop
    l_Overlaps_Expanded := False ;
    For i_Small In 1..l_Smallest_Nte.Count
    Loop
      If L_Nte_From_List.Exists(l_Smallest_Nte(i_Small).Nte_Ne_Id_Of)  Then
        l_Of_List := l_Nte_From_List(l_Smallest_Nte(i_Small).Nte_Ne_Id_Of) ;
        l_Nte_A := l_Smallest_Nte(i_Small) ;
        For i_Large In 1..l_Of_List.Count
        Loop
          Expand_Overlaps( l_Smallest_Nte(i_Small), l_Largest_Nte( l_Of_List( i_Large ) ), l_Overlaps_Expanded ) ;
        End Loop ;
      End If ;
    End Loop ;
    l_Of := l_Of + 1 ;
  End Loop ;
   
  Db('l_of is ' || L_Of ) ;

  -- because overlaps have been expanded then the membership becomes a simple equality test
  For i_Small In 1..l_Smallest_Nte.Count
  Loop
    -- If we have a common 'of' then check to see if it's a true
    -- intersection
    Db(1) ;
    l_Of := l_Smallest_Nte(i_Small).Nte_Ne_Id_Of ;
    -- Do we have a list of 'of' records for the current nte?
    If l_Nte_From_List.Exists(l_Of) Then
      Db(2) ;
      l_Of_List   :=  l_Nte_From_List(l_Of) ;
      l_Nte_A     :=  l_Smallest_Nte(i_Small) ;
      
      For i_Large In 1..l_Of_List.Count
      Loop
        Db('i_large ' || i_Large ) ;
        -- if an item exists in l_common_elements then we've already
        -- included it so don't bother including it again
        If Not l_Common_Elements.Exists(l_Of_List(i_Large)) Then
          Db('not exists');
          l_Nte_B := l_Largest_Nte(l_Of_List(i_Large));
          -- Do the nte's intersect?
          If Nte_Is_Common(l_Nte_A,l_Nte_B) Then
            Db('common_nte');
            Po_Nte_Result(po_Nte_Result.Count+1) :=l_Nte_B ;
            Po_Nte_Result(po_Nte_Result.Count).Nte_Job_Id := l_Nte_Result;
            -- This is a marker to say we've already identified this one
            l_Common_Elements(l_Of_List(i_Large)) := 1 ;
          End If ;
        End If ;
      End Loop ;
    End If ;
  End Loop ;

  --
  Nm_Debug.Proc_End (G_Package_Name,'nte_intx_nte');
  --

End Nte_Intx_Nte ;
--
-----------------------------------------------------------------------------
--
END Nm3extent;
/
