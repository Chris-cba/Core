
CREATE OR REPLACE force PACKAGE BODY nm3extent IS
  --   SCCS Identifiers :-
  --
  --       sccsid           : %W% %G%
  --       Module Name      : %M%
  --       Date into SCCS   : %E% %U%
  --       Date fetched Out : %D% %T%
  --       SCCS Version     : %I%
  --
  --
  --   Author : Kevin Angus
  --
  --     nm3extent package - Functions + Procedures for dealing with temporary
  --                         extents.
  --
------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------
  --
   g_body_sccsid     CONSTANT  varchar2(2000) := '"%W% %G%"';
--  g_body_sccsid is the SCCS ID for the package body
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
  FUNCTION check_element_nt_types(pi_job_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                                 ,pi_group_type IN nm_group_types.ngt_group_type%TYPE
                                 ) RETURN boolean IS

    CURSOR c1 IS
      SELECT
        1
      FROM
        nm_nw_temp_extents,
        nm_elements
      WHERE
        nte_job_id = pi_job_id
      AND
        nte_datum = 'Y'
      AND
        nte_ne_id = ne_id
      AND
        ne_nt_type NOT IN (SELECT
                             nng_nt_type
                           FROM
                             nm_nt_groupings
                           WHERE
                             nng_group_type = pi_group_type);

    n      pls_integer;
    retval boolean := TRUE;

  BEGIN
    OPEN c1;
      FETCH c1 INTO n;
      IF c1%FOUND THEN
        retval := FALSE;
      END IF;
    CLOSE c1;

    RETURN retval;
  END check_element_nt_types;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION is_extent_partial(pi_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                            ) RETURN boolean IS

    CURSOR c1 IS
      SELECT
        1
      FROM
        nm_nw_temp_extents
      WHERE
        nte_job_id = pi_job_id
      AND
        nte_datum = 'Y'
      AND
        nte_end <> nm3net.get_ne_length(nte_ne_id);

    n      pls_integer;
    retval boolean := FALSE;

  BEGIN
    OPEN c1;
      FETCH c1 INTO n;
      IF c1%FOUND THEN
        retval := TRUE;
      END IF;
    CLOSE c1;

    RETURN retval;
  END is_extent_partial;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION is_extent_exclusive(pi_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                              ,pi_group_type IN nm_group_types.ngt_group_type%TYPE
                              ) RETURN boolean IS


    CURSOR c1 IS
      SELECT
        1
      FROM
        nm_members,
        nm_elements,
        nm_nw_temp_extents
      WHERE
        nm_ne_id_of = nte_ne_id
      AND
	      nm_ne_id_in = ne_id
      AND
        ne_gty_group_type = pi_group_type
      AND
        nte_job_id = pi_job_id
      AND
        nte_datum = 'Y';

    n      pls_integer;
    retval boolean := TRUE;

  BEGIN
    OPEN c1;
      FETCH c1 INTO n;
      IF c1%FOUND THEN
        retval := FALSE;
      END IF;
    CLOSE c1;

    RETURN retval;
  END is_extent_exclusive;
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION check_element_dates(pi_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                              ,pi_start_date IN DATE
                              ) RETURN boolean IS

    CURSOR c1 IS
      SELECT
        1
      FROM
        nm_nw_temp_extents,
        nm_elements
      WHERE
        nte_job_id = pi_job_id
      AND
        nte_datum = 'Y'
      AND
        nte_ne_id = ne_id
      AND
        (ne_start_date > pi_start_date
         OR
         ne_end_date <= pi_start_date);

    n      pls_integer;
    retval boolean := TRUE;

  BEGIN
    OPEN c1;
      FETCH c1 INTO n;
      IF c1%FOUND THEN
        retval := FALSE;
      END IF;
    CLOSE c1;

    RETURN retval;
  END check_element_dates;
  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE create_group(pi_job_id            IN nm_nw_temp_extents.nte_job_id%TYPE
                        ,pi_ne_unique         IN nm_elements.ne_unique%TYPE
                        ,pi_ne_type           IN nm_elements.ne_type%TYPE           DEFAULT 'G'
                        ,pi_ne_nt_type        IN nm_elements.ne_nt_type%TYPE
                        ,pi_ne_descr          IN nm_elements.ne_descr%TYPE
                        ,pi_ne_admin_unit     IN nm_elements.ne_admin_unit%TYPE
                        ,pi_ne_start_date     IN nm_elements.ne_start_date%TYPE
                        ,pi_ne_gty_group_type IN nm_elements.ne_gty_group_type%TYPE
                        ,pi_ne_owner          IN nm_elements.ne_owner%TYPE          DEFAULT NULL
                        ,pi_ne_name_1         IN nm_elements.ne_name_1%TYPE         DEFAULT NULL
                        ,pi_ne_name_2         IN nm_elements.ne_name_2%TYPE         DEFAULT NULL
                        ,pi_ne_prefix         IN nm_elements.ne_prefix%TYPE         DEFAULT NULL
                        ,pi_ne_number         IN nm_elements.ne_number%TYPE         DEFAULT NULL
                        ,pi_ne_sub_type       IN nm_elements.ne_sub_type%TYPE       DEFAULT NULL
                        ,pi_ne_group          IN nm_elements.ne_group%TYPE          DEFAULT NULL
                        ,pi_ne_sub_class      IN nm_elements.ne_sub_class%TYPE      DEFAULT NULL
                        ,pi_ne_nsg_ref        IN nm_elements.ne_nsg_ref%TYPE        DEFAULT NULL
                        ,pi_ne_version_no     IN nm_elements.ne_version_no%TYPE     DEFAULT NULL
                        ,pi_offset            IN number                             DEFAULT 0
                        ) IS

    CURSOR temp_extents_c IS
      SELECT
        nte_ne_id,
        nte_st,
        nte_end
      FROM
        nm_nw_temp_extents
      WHERE
        nte_job_id = pi_job_id
      AND
        nte_datum = 'Y';

    v_ne_id     nm_elements.ne_id%TYPE;
    v_nm_end_mp nm_members.nm_end_mp%TYPE;

  BEGIN
    v_ne_id := nm3net.get_next_ne_id;

    --create group master record
    INSERT INTO nm_elements
           (ne_id
           ,ne_unique
           ,ne_type
           ,ne_nt_type
           ,ne_descr
           ,ne_admin_unit
           ,ne_start_date
           ,ne_gty_group_type
           ,ne_owner
           ,ne_name_1
           ,ne_name_2
           ,ne_prefix
           ,ne_number
           ,ne_sub_type
           ,ne_group
           ,ne_sub_class
           ,ne_nsg_ref
           ,ne_version_no
           )
    VALUES (v_ne_id
           ,pi_ne_unique
           ,pi_ne_type
           ,pi_ne_nt_type
           ,pi_ne_descr
           ,pi_ne_admin_unit
           ,pi_ne_start_date
           ,pi_ne_gty_group_type
           ,pi_ne_owner
           ,pi_ne_name_1
           ,pi_ne_name_2
           ,pi_ne_prefix
           ,pi_ne_number
           ,pi_ne_sub_type
           ,pi_ne_group
           ,pi_ne_sub_class
           ,pi_ne_nsg_ref
           ,pi_ne_version_no
           );

    --create group member records
    FOR rec IN temp_extents_c LOOP

      IF rec.nte_end = nm3net.get_ne_length(rec.nte_ne_id) THEN
        --if element is not partial then end_mp is NULL
        v_nm_end_mp := NULL;
      ELSE
        v_nm_end_mp := rec.nte_end;
      END IF;

      INSERT INTO nm_members
             (nm_ne_id_in
             ,nm_ne_id_of
             ,nm_begin_mp
             ,nm_start_date
             ,nm_end_mp
             ,nm_admin_unit
             ,nm_seq_no
             ,nm_type
             ,nm_obj_type
             )
      VALUES (v_ne_id
             ,rec.nte_ne_id
             ,rec.nte_st
             ,pi_ne_start_date
             ,v_nm_end_mp
             ,pi_ne_admin_unit
             ,ROWNUM
             ,'G'
             ,pi_ne_nt_type
             );
    END LOOP


    COMMIT;

    --set offsets for linear groups
    IF nm3net.is_gty_linear(pi_ne_gty_group_type) = 'Y' THEN

      nm3pla.set_route_offsets(v_ne_id
                              ,pi_offset);

      nm3pla.update_route_offsets(v_ne_id
                                 ,nm3net.get_nt_units(pi_ne_nt_type)
                                 ,'Y');
    END IF;

  END;
  --
  -----------------------------------------------------------------------------
  --
END nm3extent;
/
