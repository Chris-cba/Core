CREATE OR REPLACE PACKAGE BODY sdl_inclusion
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_inclusion.pkb-arc   1.0   Mar 01 2021 13:07:28   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_inclusion.pkb  $
    --       Date into PVCS   : $Date:   Mar 01 2021 13:07:28  $
    --       Date fetched Out : $Modtime:   Mar 01 2021 13:05:58  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the auto-inclusion tests for SDL network data
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --
    -- The main purpose of this package is to handle the auto-inclusion rules and the means of validating
    -- the SDL load data to ensure the attribute values match the inclusion rules.

    FUNCTION get_unique (p_nt_type IN VARCHAR2)
        RETURN VARCHAR2;

    CURSOR get_inclusion_data (c_batch_id IN NUMBER)
    IS
        SELECT sp_id,
               sp_name,
               profile_nt_type,
               profile_group_type,
               datum_nt_type,
               nti_nw_parent_type,
               nti_nw_child_type,
               nti_parent_column,
               nti_child_column
          FROM V_SDL_PROFILE_NW_TYPES,
               nm_type_inclusion,
               sdl_file_submissions
         WHERE     sp_id = sfs_sp_id
               AND sfs_id = c_batch_id
               AND (   nti_nw_parent_type = profile_nt_type
                    OR nti_nw_child_type = profile_nt_type
                    OR nti_nw_child_type = datum_nt_type);

    PROCEDURE validate_sdl_inclusion_data (p_batch_id IN NUMBER)
    IS
        l_child_column    VARCHAR2 (2000);
        l_parent_column   VARCHAR2 (2000);

        l_inclusion_sql   VARCHAR2 (32767);
    BEGIN
        --    --remove any validation results of type I for the current batch
        --
        --    delete from sdl_validation_results
        --    where svr_sfs_id = p_batch_id
        --    and svr_validation_type = 'I';

        -- For loop is used since very few rows returned, one for each inclusion type and easier to maintain
        FOR irec IN get_inclusion_data (p_batch_id)
        LOOP
            -- we need to check if the inclusion columns use the NE_UNIQUE and if so, construct it if necessary

            IF irec.nti_child_column = 'NE_UNIQUE'
            THEN
                l_child_column := get_unique (irec.nti_nw_child_type);
            ELSE
                l_child_column := irec.nti_child_column;
            END IF;

            IF irec.nti_parent_column = 'NE_UNIQUE'
            THEN
                l_parent_column := get_unique (irec.nti_nw_parent_type);
            ELSE
                l_parent_column := irec.nti_parent_column;
            END IF;

            IF     irec.profile_nt_type = irec.nti_nw_parent_type
               AND irec.datum_nt_type = irec.nti_nw_child_type
            THEN
                --
                -- we are dealing with an inclusion that is the same as that of a route profile to datum
                -- we need to check that the attribution of the actual load data matches the expected inclusion attribution
                --
                l_inclusion_sql :=
                    get_batch_inclusion_string (irec.sp_id,
                                                irec.sp_name,
                                                p_batch_id,
                                                l_parent_column,
                                                l_child_column);

                nm_debug.debug_on;
                nm_debug.debug (l_inclusion_sql);

                EXECUTE IMMEDIATE l_inclusion_sql
                    USING p_batch_id, p_batch_id, p_batch_id;
            ELSE
                -- the inclusion rule does not relate to a load route and datums so the check must be made against the actual DB data

                -- The inclusion may be a route as a member of an area or a datum as a member of an area or linear group.

                IF irec.profile_nt_type = irec.nti_nw_child_type
                THEN
                    -- we are needing to auto-include the profile network type into an existing group
                    l_inclusion_sql :=
                        get_prof_db_inclusion_string (
                            irec.sp_id,
                            irec.sp_name,
                            p_batch_id,
                            irec.nti_nw_parent_type,
                            l_parent_column,
                            l_child_column);

                    nm_debug.debug_on;
                    nm_debug.debug (l_inclusion_sql);

                    EXECUTE IMMEDIATE l_inclusion_sql
                        USING p_batch_id, p_batch_id;
                ELSIF     irec.profile_group_type IS NOT NULL
                      AND irec.datum_nt_type = irec.nti_nw_child_type
                THEN
                    -- we are needing to auto-include the datum network type into an existing group (not of type the same as profile)

                    l_inclusion_sql :=
                        get_datum_db_inclusion_string (
                            irec.sp_id,
                            irec.sp_name,
                            p_batch_id,
                            irec.nti_nw_parent_type,
                            l_parent_column,
                            l_child_column);

                    nm_debug.debug_on;
                    nm_debug.debug (l_inclusion_sql);

                    EXECUTE IMMEDIATE l_inclusion_sql
                        USING p_batch_id, p_batch_id;
                END IF;
            END IF;
        END LOOP;
    END;


    FUNCTION get_batch_inclusion_string (p_sp_id           IN NUMBER,
                                         p_sp_name         IN VARCHAR2,
                                         p_batch_id        IN NUMBER,
                                         p_parent_column   IN VARCHAR2,
                                         p_child_column    IN VARCHAR2)
        RETURN VARCHAR2
    IS
        retval   VARCHAR2 (32767);
        qq       VARCHAR2 (1) := CHR (39);
    BEGIN
        retval :=
               'insert into sdl_validation_results (svr_sld_key, svr_sfs_id, svr_validation_type, svr_status_code, svr_message )'
            || ' select sld_key, :batch_id, '
            || qq
            || 'I'
            || qq
            || ', -20001, '
            || qq
            || 'Load data does not match inclusion rules'
            || qq
            || ' from ( '
            || ' with parent_data as '
            || ' ( select sld_key, '
            || p_parent_column
            || ' parent_key '
            || ' from v_sdl_'
            || p_sp_name
            || '_ne r '
            || ' where batch_id = :batch_id ), '
            || ' child_data as '
            || ' ( select sld_key, '
            || p_child_column
            || ' child_key '
            || ' from v_sdl_wip_'
            || p_sp_name
            || '_datums where batch_id = :batch_id ) '
            || ' select p.sld_key from parent_data p '
            || ' where not exists ( select 1 from child_data c '
            || ' where p.parent_key = c.child_key ))';
        --
        RETURN retval;
    END;

    FUNCTION get_prof_db_inclusion_string (p_sp_id           IN NUMBER,
                                           p_sp_name         IN VARCHAR2,
                                           p_batch_id        IN NUMBER,
                                           p_parent_type     IN VARCHAR2,
                                           p_parent_column   IN VARCHAR2,
                                           p_child_column    IN VARCHAR2)
        RETURN VARCHAR2
    IS
        retval   VARCHAR2 (32767);
        qq       VARCHAR2 (1) := CHR (39);
    BEGIN
        retval :=
               'insert into sdl_validation_results (svr_sld_key, svr_sfs_id, svr_validation_type, svr_status_code, svr_message )'
            || ' select sld_key, :batch_id, '
            || qq
            || 'I'
            || qq
            || ', -20002, '
            || qq
            || 'Load data does not match existing inclusion group data '
            || qq
            || ' from ( '
            || ' with child_data as '
            || ' ( select sld_key, '
            || p_child_column
            || ' child_key '
            || ' from v_sdl_'
            || p_sp_name
            || '_ne where batch_id = :batch_id ) '
            || ' select c.sld_key from child_data c '
            || ' where not exists ( select 1 from nm_elements p '
            || ' where '
            || p_parent_column
            || ' = c.child_key'
            || ' and ne_nt_type = p_parent_type';
        --
        RETURN retval;
    END;

    FUNCTION get_datum_db_inclusion_string (p_sp_id           IN NUMBER,
                                            p_sp_name         IN VARCHAR2,
                                            p_batch_id        IN NUMBER,
                                            p_parent_type     IN VARCHAR2,
                                            p_parent_column   IN VARCHAR2,
                                            p_child_column    IN VARCHAR2)
        RETURN VARCHAR2
    IS
        retval   VARCHAR2 (32767);
        qq       VARCHAR2 (1) := CHR (39);
    BEGIN
        retval :=
               'insert into sdl_validation_results (svr_sld_key, svr_sfs_id, svr_swd_id, svr_validation_type, svr_status_code, svr_message )'
            || ' select sld_key, :batch_id, swd_id, '
            || qq
            || 'I'
            || qq
            || ', -20002, '
            || qq
            || 'Load data does not match existing inclusion group data '
            || qq
            || ' from ( '
            || ' with child_data as '
            || ' ( select sld_key, swd_id, '
            || p_child_column
            || ' child_key '
            || ' from v_sdl_'
            || p_sp_name
            || '_wip_datums where batch_id = :batch_id ) '
            || ' select c.sld_key from child_data c '
            || ' where not exists ( select 1 from nm_elements p '
            || ' where '
            || p_parent_column
            || ' = c.child_key'
            || ' and ne_nt_type = p_parent_type';
        --
        RETURN retval;
    END;

    FUNCTION get_unique (p_nt_type IN VARCHAR2)
        RETURN VARCHAR2
    IS
        l_pop_unique   VARCHAR2 (1);
        retval         VARCHAR2 (2000);
    BEGIN
        SELECT nt_pop_unique
          INTO l_pop_unique
          FROM nm_types
         WHERE nt_type = p_nt_type;

        IF l_pop_unique = 'N'
        THEN
            retval := 'NE_UNIQUE';
        ELSE
            SELECT LISTAGG (ntc_column_name || ntc_separator, '||')
                       WITHIN GROUP (ORDER BY ntc_unique_seq)
              INTO retval
              FROM nm_type_columns
             WHERE ntc_nt_type = p_nt_type AND ntc_unique_seq IS NOT NULL;
        --
        END IF;

        RETURN retval;
    END;

    PROCEDURE create_group_auto_inclusions (ne_ids            IN ptr_num_array_type,
                                            p_group_nt_type   IN VARCHAR2)
    IS
        CURSOR get_inclusion_data (c_nt_type IN VARCHAR2)
        IS
            SELECT nti_nw_parent_type,
                   nti_nw_child_type,
                   nti_parent_column,
                   nti_child_column
              FROM nm_type_inclusion
             WHERE nti_nw_child_type = c_nt_type;

        --
        l_sql   VARCHAR2 (32767);
    BEGIN
        FOR irec IN get_inclusion_data (p_group_nt_type)
        LOOP
            l_sql :=
                   'insert into nm_members (nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type, nm_start_date '
                || ' select p.ne_id, c.ne_id, ''G'', p.ne_gty_group_type, greatest(p.ne_start_date, c.ne_start_date)'
                || ' from nm_elements p, nm_elements c, table(:ne_ids) t'
                || ' where c.ne_id = t.ptr_value '
                || ' and c.'
                || irec.nti_child_column
                || ' = p.'
                || irec.nti_parent_column
                || ' and p.ne_nt_type = :parent_nt_type '
                || ' and c.ne_nt_type = :child_nt_type ';

            EXECUTE IMMEDIATE l_sql
                USING ne_ids, irec.nti_nw_parent_type, irec.nti_nw_child_type;
        END LOOP;
    END;


    PROCEDURE create_datum_auto_inclusions (ne_ids            IN ptr_num_array_type,
                                            p_datum_nt_type   IN VARCHAR2,
                                            p_group_nt_type   IN VARCHAR2)
    IS
        CURSOR get_inclusion_data (c_nt_type         IN VARCHAR2,
                                   c_group_nt_type   IN VARCHAR2)
        IS
            SELECT nti_nw_parent_type,
                   nti_nw_child_type,
                   nti_parent_column,
                   nti_child_column
              FROM nm_type_inclusion
             WHERE     nti_nw_child_type = c_nt_type
                   AND nti_nw_parent_type <> c_group_nt_type;

        l_sql   VARCHAR2 (32767);
    BEGIN
        FOR irec IN get_inclusion_data (p_datum_nt_type, p_group_nt_type)
        LOOP
            l_sql :=
                   'insert into nm_members (nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type, nm_start_date '
                || ' select p.ne_id, c.ne_id, ''G'', p.ne_gty_group_type, greatest(p.ne_start_date, c.ne_start_date)'
                || ' from nm_elements p, nm_elements c, table(:ne_ids) t'
                || ' where c.ne_id = t.ptr_value '
                || ' and c.'
                || irec.nti_child_column
                || ' = p.'
                || irec.nti_parent_column
                || ' and p.ne_nt_type = :parent_nt_type '
                || ' and c.ne_nt_type = :child_nt_type ';

            EXECUTE IMMEDIATE l_sql
                USING ne_ids, irec.nti_nw_parent_type, irec.nti_nw_child_type;
        END LOOP;
    END;
END;