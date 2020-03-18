-----------------------------------------------------------------------------
-- sdl_spidx.sql
----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/install/sdl_spidx.sql-arc   1.1   Mar 18 2020 07:50:02   Vikas.Mhetre  $
--       Module Name      : $Workfile:   sdl_spidx.sql  $
--       Date into PVCS   : $Date:   Mar 18 2020 07:50:02  $
--       Date fetched Out : $Modtime:   Mar 18 2020 07:37:02  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

DECLARE
    l_diminfo   sdo_dim_array;
    l_srid      NUMBER := NULL;

    --
    PROCEDURE insert_sdo_metadata (p_table_name    IN VARCHAR2,
                                   p_column_name   IN VARCHAR2,
                                   p_diminfo          sdo_dim_array,
                                   p_srid             NUMBER)
    IS
    BEGIN
        INSERT INTO mdsys.sdo_geom_metadata_table (sdo_owner,
                                                   sdo_table_name,
                                                   sdo_column_name,
                                                   sdo_diminfo,
                                                   sdo_srid)
             VALUES (SYS_CONTEXT ('Nm3CORE', 'APPLICATION_OWNER'),
                     p_table_name,
                     p_column_name,
                     p_diminfo,
                     p_srid);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            NULL;
    END;
BEGIN
    BEGIN
        l_diminfo := nm3sdo.coalesce_nw_diminfo;

        --
        SELECT sdo_srid
          INTO l_srid
          FROM mdsys.sdo_geom_metadata_table, nm_themes_all, nm_nw_themes
         WHERE     sdo_owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
               AND sdo_table_name = nth_feature_table
               AND sdo_column_name = nth_feature_shape_column
               AND nth_theme_id = nnth_nth_theme_id
               AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            NULL;
    END;

    IF l_srid IS NULL OR l_diminfo IS NULL
    THEN
        raise_application_error (
            -20001,
            'The network spatial metadata has not been configured please re-run this script when the configuration is complete so spatial indexes can be created');
    ELSE
        --
        insert_sdo_metadata ('SDL_LOAD_DATA',
                             'SLD_WORKING_GEOMETRY',
                             l_diminfo,
                             l_srid);
        insert_sdo_metadata ('SDL_WIP_DATUMS',
                             'GEOM',
                             l_diminfo,
                             l_srid);
        insert_sdo_metadata ('SDL_PLINE_STATISTICS',
                             'SLPS_PLINE_GEOMETRY',
                             SDO_LRS.convert_to_std_dim_array (l_diminfo),
                             l_srid);
        insert_sdo_metadata ('SDL_WIP_PT_GEOM',
                             'GEOM',
                             l_diminfo,
                             l_srid);
        insert_sdo_metadata ('SDL_WIP_NODES',
                             'NODE_GEOM',
                             SDO_LRS.convert_to_std_dim_array (l_diminfo),
                             l_srid);
        insert_sdo_metadata ('SDL_WIP_GRADE_SEPARATIONS',
                             'SGS_GEOM',
                             SDO_LRS.convert_to_std_dim_array (l_diminfo),
                             l_srid);
        insert_sdo_metadata ('SDL_FILE_SUBMISSIONS',
                             'SFS_MBR_GEOMETRY',
                             SDO_LRS.convert_to_std_dim_array (l_diminfo),
                             l_srid);
     /* insert_sdo_metadata ('SDL_WIP_INTSCT_GEOM',
                             'GEOM',
                             l_diminfo,
                             l_srid);
        insert_sdo_metadata ('SDL_WIP_SELF_INTERSECTIONS',
                             'GEOM',
                             l_diminfo,
                             l_srid); */

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_LOAD_DATA_SPIDX ON SDL_LOAD_DATA (SLD_WORKING_GEOMETRY) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_WIP_DATUMS_SPIDX ON SDL_WIP_DATUMS (GEOM) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_PLINE_STATISTICS_SPIDX ON SDL_PLINE_STATISTICS (SLPS_PLINE_GEOMETRY) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_WIP_PT_GEOM_SPIDX ON SDL_WIP_PT_GEOM (GEOM) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_WIP_NODES_SPIDX ON SDL_WIP_NODES (NODE_GEOM) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_WIP_GRADE_SEPARATIONS_SPIDX ON SDL_WIP_GRADE_SEPARATIONS (SGS_GEOM) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_FILE_SUBMISSIONS_SPIDX ON SDL_FILE_SUBMISSIONS (SFS_MBR_GEOMETRY) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

     /* EXECUTE IMMEDIATE   'CREATE INDEX SDL_WIP_INTSCT_GEOM_SPIDX ON SDL_WIP_INTSCT_GEOM (GEOM) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE   'CREATE INDEX SDL_WIP_SELF_INTERSECTIONS_SPIDX ON SDL_WIP_SELF_INTERSECTIONS (GEOM) '
                         || ' INDEXTYPE IS MDSYS.SPATIAL_INDEX'; */
    END IF;
END;
/