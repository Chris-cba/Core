CREATE OR REPLACE PACKAGE BODY sdl_validate
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_validate.pkb-arc   1.3   Oct 11 2019 14:40:32   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_validate.pkb  $
    --       Date into PVCS   : $Date:   Oct 11 2019 14:40:32  $
    --       Date fetched Out : $Modtime:   Oct 11 2019 14:39:06  $
    --       PVCS Version     : $Revision:   1.3  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling validation of attributes in a load batch
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is to handle the validation of all the defined attributes in a batch:
    -- Domain based checks
    -- FK based checks
    -- format checks

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.3  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDL_VALIDATE';

    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    PROCEDURE UPDATE_BATCH_FOR_ADJUSTMENT (p_batch_id IN INTEGER)
    IS
        CURSOR c_update IS
            SELECT DISTINCT
                   'SLD_COL_' || sam.sam_col_id     load_column_name,
                   sam.sam_col_id,
                   saaa.saaa_adjusted_value
              FROM sdl_attribute_mapping           sam,
                   sdl_attribute_adjustment_audit  saaa
             WHERE     sam.sam_id = saaa.saaa_sam_id
                   AND saaa.saaa_sfs_id = p_batch_id;

        sql_str   VARCHAR2 (4000);
    BEGIN
        FOR r_update IN c_update
        LOOP
            sql_str :=
                   'UPDATE sdl_load_data '
                || 'SET '
                || r_update.load_column_name
                || ' = '
                || ''''
                || r_update.saaa_adjusted_value
                || ''''
                || ','
                || 'sld_status = '
                || '''ADJUSTED'''
                || ' WHERE sld_key IN (SELECT saaa.saaa_sld_key FROM sdl_attribute_adjustment_audit saaa WHERE saaa.saaa_sfs_id = '
                || p_batch_id
                || ' AND saaa.saaa_sam_id = '
                || r_update.sam_col_id
                || ')'
                || ' AND sld_sfs_id = '
                || p_batch_id;


            EXECUTE IMMEDIATE sql_str;
        END LOOP;
    END update_batch_for_adjustment;


    PROCEDURE VALIDATE_BATCH (p_batch_id IN NUMBER)
    IS
        meta_row        V_SDL_PROFILE_NW_TYPES%ROWTYPE;
        l_unit_factor   NUMBER;
    BEGIN
        SELECT m.*
          INTO meta_row
          FROM V_SDL_PROFILE_NW_TYPES m, sdl_file_submissions
         WHERE sfs_id = p_batch_id AND sp_id = sfs_sp_id;

        --
        SELECT conversion_factor
          INTO l_unit_factor
          FROM mdsys.sdo_dist_units
         WHERE sdo_unit = meta_row.datum_unit_name;

        DELETE FROM sdl_validation_results
              WHERE svr_sfs_id = p_batch_id;

        validate_domain_columns (p_batch_id);

        validate_mandatory_columns (p_batch_id);

        set_working_geometry (p_batch_id, l_unit_factor);
    END;

    PROCEDURE VALIDATE_DOMAIN_COLUMNS (p_batch_id IN NUMBER)
    IS
        sql_str   VARCHAR2 (4000);
    BEGIN
        WITH
            domain_columns
            AS
                (SELECT sam_id,
                        sam_col_id,
                        'sld_col_' || sam_col_id     load_column_name,
                        sam_view_column_name,
                        domain
                   FROM (SELECT *
                           FROM v_nm_nw_columns,
                                sdl_attribute_mapping,
                                sdl_profiles,
                                sdl_file_submissions,
                                nm_linear_types
                          WHERE     sfs_id = p_batch_id
                                AND sfs_sp_id = sp_id
                                AND nlt_id = sp_nlt_id
                                AND sam_sp_id = sp_id
                                AND sam_ne_column_name = column_name
                                AND network_type = nlt_nt_type
                                AND domain IS NOT NULL))
        SELECT    'insert into sdl_validation_results (svr_sfs_id, svr_sld_key, svr_validation_type, svr_sam_id, svr_column_name, svr_current_value, svr_status_code, svr_message) '
               || LISTAGG (
                         'select '
                      || p_batch_id
                      || ','
                      || 'sld_key'
                      || ','
                      || ''''
                      || 'D'
                      || ''''
                      || ','
                      || TO_CHAR (sam_id)
                      || ', '
                      || ''''
                      || load_column_name
                      || ''''
                      || ','
                      || load_column_name
                      || ','
                      || ' -999, '
                      || ''''
                      || 'Domain '
                      || domain
                      || ' value '
                      || load_column_name
                      || ' is invalid'
                      || ''''
                      || ' from sdl_load_data where sld_sfs_id = '
                      || TO_CHAR (p_batch_id)
                      || ' and not exists ( select 1 from hig_codes where hco_domain = '
                      || ''''
                      || domain
                      || ''''
                      || ' and hco_code = '
                      || load_column_name
                      || ')',
                      ' union all ')
                  WITHIN GROUP (ORDER BY sam_id)
          INTO sql_str
          FROM domain_columns;

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        EXECUTE IMMEDIATE sql_str;
    END;


    PROCEDURE VALIDATE_MANDATORY_COLUMNS (p_batch_id IN NUMBER)
    IS
        sql_str   VARCHAR2 (4000);
    BEGIN
        WITH
            mandatory_columns
            AS
                (SELECT sam_id,
                        sam_col_id,
                        'sld_col_' || sam_col_id     load_column_name,
                        sam_view_column_name,
                        domain
                   FROM (SELECT *
                           FROM v_nm_nw_columns,
                                sdl_attribute_mapping,
                                sdl_profiles,
                                sdl_file_submissions,
                                nm_linear_types
                          WHERE     sfs_id = p_batch_id
                                AND sfs_sp_id = sp_id
                                AND nlt_id = sp_nlt_id
                                AND sam_sp_id = sp_id
                                AND sam_ne_column_name = column_name
                                AND network_type = nlt_nt_type
                                AND mandatory = 'Y'))
        SELECT    'insert into sdl_validation_results (svr_sfs_id, svr_sld_key, svr_validation_type, svr_sam_id, svr_column_name, svr_current_value, svr_status_code, svr_message) '
               || LISTAGG (
                         'select '
                      || p_batch_id
                      || ','
                      || 'sld_key'
                      || ','
                      || ''''
                      || 'M'
                      || ''''
                      || ','
                      || TO_CHAR (sam_id)
                      || ', '
                      || ''''
                      || load_column_name
                      || ''''
                      || ','
                      || load_column_name
                      || ','
                      || ' -999, '
                      || ''''
                      || 'Column is marked as mandatory but has no value '
                      || ''''
                      || ' from sdl_load_data where sld_sfs_id = '
                      || TO_CHAR (p_batch_id)
                      || ' and '
                      || load_column_name
                      || ' is null ',
                      ' union all ')
                  WITHIN GROUP (ORDER BY sam_id)
          INTO sql_str
          FROM mandatory_columns;

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        EXECUTE IMMEDIATE sql_str;
    END;

    PROCEDURE VALIDATE_ADJUSTMENT_RULES (p_batch_id IN NUMBER)
    IS
        sql_str   VARCHAR2 (4000);
    BEGIN
        --   DELETE FROM sdl_attribute_adjustment_audit
        --        WHERE saaa_sfs_id = p_batch_id;

        WITH
            adjustment_rules
            AS
                (SELECT sam_id,
                        sam_col_id,
                        'sld_col_' || sam_col_id     load_column_name,
                        sam_view_column_name,
                        saar_id,
                        saar_source_value,
                        saar_adjust_to_value
                   FROM (SELECT sam.sam_id,
                                sam.sam_col_id,
                                sam.sam_view_column_name,
                                saar.saar_id,
                                saar.saar_source_value,
                                saar.saar_adjust_to_value
                           FROM sdl_attribute_mapping           sam,
                                sdl_file_submissions            sfs,
                                sdl_attribute_adjustment_rules  saar
                          WHERE     sfs.sfs_id = p_batch_id
                                AND sam.sam_sp_id = sfs.sfs_sp_id
                                AND sam.sam_sp_id = saar.saar_sp_id
                                AND sam.sam_view_column_name =
                                    saar.saar_target_attribute_name))
        SELECT    'INSERT INTO sdl_attribute_adjustment_audit ( saaa_sld_key, saaa_sfs_id, saaa_saar_id, saaa_sam_id, saaa_original_value, saaa_adjusted_value) '
               || LISTAGG (
                         'SELECT '
                      || 'sld_key'
                      || ','
                      || p_batch_id
                      || ','
                      || saar_id
                      || ','
                      || sam_id
                      || ','
                      || ''''
                      || saar_source_value
                      || ''''
                      || ','
                      || ''''
                      || saar_adjust_to_value
                      || ''''
                      || ' FROM sdl_load_data WHERE sld_sfs_id = '
                      || TO_CHAR (p_batch_id)
                      || ' AND sld_key IN ( SELECT sld_key FROM sdl_load_data WHERE '
                      || load_column_name
                      || CASE
                             WHEN saar_source_value IS NULL THEN ' IS NULL '
                             ELSE ' = '
                         END
                      || saar_source_value
                      || ')',
                      ' UNION ALL ')
                  WITHIN GROUP (ORDER BY sam_id)
          INTO sql_str
          FROM adjustment_rules;

        nm_debug.debug_on;
        nm_debug.debug (sql_str);

        EXECUTE IMMEDIATE sql_str;

        update_batch_for_adjustment (p_batch_id);
    END VALIDATE_ADJUSTMENT_RULES;


    PROCEDURE VALIDATE_PROFILE (p_template_id IN NUMBER)
    IS
        l_dummy   NUMBER := 0;
    BEGIN
        BEGIN
            SELECT 1
              INTO l_dummy
              FROM dba_tab_columns
             WHERE     owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND table_name = 'NM_ELEMENTS_ALL'
                   AND nullable = 'N'
                   AND NOT EXISTS
                           (SELECT 1
                              FROM sdl_attribute_mapping
                             WHERE     sam_sp_id = 2
                                   AND column_name = sam_ne_column_name)
                   AND column_name NOT IN ('NE_ID', -- assigned in upload to main DB
                                           'NE_NT_TYPE', --defined by the template itself
                                           --'NE_ADMIN_UNIT', --we need to do something with this
                                           'NE_TYPE', -- we are only going to load datums (i.e. NE_TYPE = 'S', hard-coded inside the API
                                           'NE_DATE_CREATED',
                                           'NE_DATE_MODIFIED',
                                           'NE_MODIFIED_BY',
                                           'NE_CREATED_BY' -- handled by the trigger
                                                          );
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        --
        IF l_dummy != 0
        THEN
            raise_application_error (
                -20001,
                'Mandatory columns are not catered for in the load file profile');
        END IF;
    END;

    PROCEDURE set_working_geometry (p_batch_id      IN NUMBER,
                                    p_unit_factor   IN NUMBER)
    IS
        l_diminfo    sdo_dim_array;
        l_gtype      NUMBER;
        l_unit_str   VARCHAR2 (30);
        meta_row     V_SDL_PROFILE_NW_TYPES%ROWTYPE;
    BEGIN
        SELECT m.*
          INTO meta_row
          FROM V_SDL_PROFILE_NW_TYPES m, sdl_file_submissions
         WHERE sfs_id = p_batch_id AND sp_id = sfs_sp_id;

        --

        DELETE FROM sdl_validation_results
              WHERE svr_validation_type = 'S' AND svr_sfs_id = p_batch_id;

        SELECT diminfo
          INTO l_diminfo
          FROM user_sdo_geom_metadata
         WHERE     table_name = 'SDL_LOAD_DATA'
               AND column_name = 'SLD_WORKING_GEOMETRY';

        --
        l_gtype := guess_dim_and_gtype (p_batch_id);

        --
        INSERT INTO sdl_validation_results (svr_sfs_id,
                                            svr_validation_type,
                                            svr_sld_key,
                                            svr_column_name,
                                            svr_status_code,
                                            svr_message)
            SELECT p_batch_id,
                   'S',
                   sld_key,
                   'SLD_LOAD_GEOMETRY',
                   -99,
                   SDO_GEOM.validate_geometry_with_context (
                       sdl_set_gtype (sld_load_geometry,
                                      l_gtype,
                                      NULL,
                                      p_unit_factor),
                       l_diminfo)
              FROM sdl_load_data
             WHERE     sld_sfs_id = p_batch_id
                   AND SDO_GEOM.validate_geometry_with_context (
                           sdl_set_gtype (sld_load_geometry,
                                          l_gtype,
                                          NULL,
                                          p_unit_factor),
                           l_diminfo) != 'TRUE';

        --
        UPDATE sdl_load_data a
           SET a.sld_working_geometry =
                   sdl_set_gtype (sld_load_geometry,
                                  l_gtype,
                                  NULL,
                                  p_unit_factor)
         WHERE     sld_sfs_id = p_batch_id
               AND NOT EXISTS
                       (SELECT 1
                          FROM sdl_validation_results
                         WHERE     svr_sfs_id = p_batch_id
                               AND svr_sld_key = sld_key);

        UPDATE sdl_file_submissions
           SET sfs_mbr_geometry =
                   (SELECT sdo_aggr_mbr (sld_working_geometry)
                      FROM sdl_load_data
                     WHERE sld_sfs_id = p_batch_id)
         WHERE sfs_id = p_batch_id;
    --
    END;

    FUNCTION guess_dim_and_gtype (p_batch_id IN NUMBER)
        RETURN NUMBER
    IS
        retval   NUMBER;
        l_mod2   NUMBER;
        l_mod3   NUMBER;
    BEGIN
        SELECT SUM (mod2), SUM (mod3)
          INTO l_mod2, l_mod3
          FROM (SELECT CASE mod2 WHEN 0 THEN 0 ELSE 1 END     mod2,
                       CASE mod3 WHEN 0 THEN 0 ELSE 1 END     mod3
                  FROM (SELECT MOD (ord_count, 2)     mod2,
                               MOD (ord_count, 3)     mod3
                          FROM (  SELECT sld_key, COUNT (*) ord_count
                                    FROM sdl_load_data a,
                                         TABLE (
                                             a.sld_load_geometry.sdo_ordinates)
                                         t
                                   WHERE sld_sfs_id = p_batch_id
                                GROUP BY sld_key)));

        IF l_mod2 = 0 AND l_mod3 = 0
        THEN
            --difficult to know!
            retval := NULL;
        ELSIF l_mod2 = 0 AND l_mod3 > 0
        THEN
            -- Its not 3D so guess we should translate to LRS
            retval := 2002;
        ELSIF l_mod2 > 0 AND l_mod3 > 0
        THEN
            retval := NULL;
        ELSE                                      -- l_mod2 > 0 and l_mod3 = 0
            retval := 3302;
        END IF;

        RETURN retval;
    END;

    FUNCTION sdl_set_gtype (p_geom          IN SDO_GEOMETRY,
                            p_gtype         IN NUMBER,
                            p_length        IN NUMBER DEFAULT NULL,
                            p_unit_factor   IN NUMBER)
        RETURN SDO_GEOMETRY
    IS
        retval    SDO_GEOMETRY := p_geom;
        l_parts   NUMBER;
        qq        CHAR (1) := CHR (39);
    BEGIN
        SELECT COUNT (*) / 3 INTO l_parts FROM TABLE (retval.sdo_elem_info);

        IF retval.sdo_gtype IN (3002, 3006)
        THEN
            IF p_gtype IN (3302, 3306)
            THEN
                retval.sdo_gtype :=
                    CASE WHEN l_parts = 1 THEN 3302 ELSE 3306 END;
            ELSIF p_gtype IN (2002, 2206)
            THEN
                retval.sdo_gtype :=
                    CASE WHEN l_parts = 1 THEN 2002 ELSE 2006 END;
                retval :=
                    SDO_LRS.convert_to_lrs_geom (
                        retval,
                        0,
                        NVL (
                            p_length,
                              SDO_GEOM.sdo_length (retval,
                                                   0.005,
                                                   'unit=METER')
                            / p_unit_factor));
            END IF;
        END IF;

        IF retval.sdo_srid IS NULL
        THEN
            retval.sdo_srid := 2234;
        END IF;

        --
        RETURN retval;
    END;

    PROCEDURE validate_datum_geometry (p_batch_id IN INTEGER)
    IS
        l_diminfo   sdo_dim_array;
        l_gtype     NUMBER;
    BEGIN
        --
        DELETE FROM sdl_validation_results
              WHERE     svr_validation_type = 'S'
                    AND svr_sfs_id = p_batch_id
                    AND svr_swd_id IS NOT NULL;

        SELECT diminfo
          INTO l_diminfo
          FROM user_sdo_geom_metadata
         WHERE table_name = 'SDL_WIP_DATUMS' AND column_name = 'GEOM';

        --
        INSERT INTO sdl_validation_results (svr_sfs_id,
                                            svr_validation_type,
                                            svr_sld_key,
                                            svr_swd_id,
                                            svr_column_name,
                                            svr_status_code,
                                            svr_message)
            SELECT p_batch_id,
                   'S',
                   sld_key,
                   swd_id,
                   'GEOM',
                   -99,
                   SDO_GEOM.validate_geometry_with_context (geom, l_diminfo)
              FROM sdl_wip_datums
             WHERE     batch_id = p_batch_id
                   AND SDO_GEOM.validate_geometry_with_context (geom,
                                                                l_diminfo) !=
                       'TRUE';

        --
        --        check_self_intersections (p_batch_id);

        set_datum_status (p_batch_id);
    END;


    PROCEDURE check_self_intersections (p_batch_id IN INTEGER)
    IS
        g_intersection_mask   VARCHAR2 (100) := 'OVERLAPBDYDISJOINT';
        l_datum_ids           geom_id_tab;
    BEGIN
        SELECT CAST (COLLECT (geom_id (swd_id, geom)) AS geom_id_tab)
          INTO l_datum_ids
          FROM sdl_wip_datums
         WHERE batch_id = p_batch_id;

        --
        FOR i IN 1 .. l_datum_ids.COUNT
        LOOP
            --
            INSERT INTO sdl_validation_results (svr_sfs_id,
                                                svr_validation_type,
                                                svr_column_name,
                                                svr_status_code,
                                                svr_message,
                                                svr_swd_id)
                WITH
                    plines
                    AS
                        (SELECT t.id, t.geom
                           FROM TABLE (
                                    SDL_STATS.GEOM_AS_PLINE_TAB (
                                        l_datum_ids (i).geom)) t)
                SELECT p_batch_id,
                       'I',
                       'GEOM',
                       -98,
                       'Geometry is self-intersecting',
                       l_datum_ids (i).id
                  FROM plines p1, plines p2
                 WHERE     sdo_relate (p1.geom,
                                       p2.geom,
                                       'mask=' || g_intersection_mask) =
                           'TRUE'
                       AND p1.id != p2.id
                       AND p1.id < p2.id - 1;
        END LOOP;
    END;

    PROCEDURE set_datum_status (p_batch_id IN NUMBER)
    IS
    BEGIN
        UPDATE sdl_wip_datums
           SET status = 'VALID'
         WHERE     NOT EXISTS
                       (SELECT 1
                          FROM sdl_validation_results
                         WHERE svr_swd_id = swd_id)
               AND batch_id = p_batch_id
               AND status IN ('NEW', 'VALID', 'INVALID');

        UPDATE sdl_wip_datums
           SET status = 'INVALID'
         WHERE     EXISTS
                       (SELECT 1
                          FROM sdl_validation_results
                         WHERE svr_swd_id = swd_id)
               AND batch_id = p_batch_id
               AND status IN ('NEW', 'VALID', 'INVALID');
    END;
END sdl_validate;
/