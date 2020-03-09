CREATE OR REPLACE PACKAGE BODY sdl_edit
AS
    --<PACKAGE>
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_edit.pkb-arc   1.0   Mar 09 2020 09:32:10   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_edit.pkb  $
    --       Date into PVCS   : $Date:   Mar 09 2020 09:32:10  $
    --       Date fetched Out : $Modtime:   Mar 09 2020 09:31:34  $
    --       PVCS Version     : $Revision:   1.0  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling the edits allowed on a SDL record
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2019 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --</PACKAGE>
    g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

    -----------------------------------------------------------------------------
    --
    PROCEDURE INSERT_REVERSAL_DATA (p_sld_keys IN int_array_type);

    PROCEDURE DELETE_DATUMS;

    PROCEDURE INSERT_REVERSED_DATUMS;

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

    PROCEDURE REVERSE_WORING_GEOMETRY (p_sld_key IN NUMBER)
    IS
    BEGIN
        UPDATE sdl_load_data
           SET sld_working_geometry =
                   nm3sdo.REVERSE_GEOMETRY (sld_working_geometry)
         WHERE sld_key = p_sld_key;

        NULL;
    END;

    PROCEDURE REVERSE_WORKING_GEOMETRIES (p_sld_keys IN int_array_type)
    IS
    BEGIN
        UPDATE sdl_load_data
           SET sld_working_geometry =
                   nm3sdo.reverse_geometry (sld_working_geometry)
         WHERE sld_key IN (SELECT COLUMN_VALUE FROM TABLE (p_sld_keys));
    END;

    PROCEDURE REVERSE_DATUM_GEOMETRY (p_sld_key IN NUMBER)
    IS
        l_sld_keys   int_array_type := int_array_type (p_sld_key);
    BEGIN
        reverse_datum_geometries (l_sld_keys);
    END;

    PROCEDURE REVERSE_DATUM_GEOMETRIES (p_sld_keys IN int_array_type)
    IS
    BEGIN
        insert_reversal_data (p_sld_keys);

        delete_datums;

        insert_reversed_datums;
        
        reverse_working_geometries( p_sld_keys );
    END;

    PROCEDURE INSERT_REVERSAL_DATA (p_sld_keys IN int_array_type)
    IS
    BEGIN
        DELETE FROM SDL_WIP_DATUM_REVERSALS;

        INSERT INTO SDL_WIP_DATUM_REVERSALS (BATCH_ID,
                                             SLD_KEY,
                                             SWD_ID,
                                             DATUM_ID,
                                             DATM_GEOM,
                                             HASHCODE,
                                             NODE_TYPE,
                                             NODE_MEASURE,
                                             GEOM_MEASURE,
                                             MAX_DATUM_ID,
                                             LOAD_GEOM_MEASURE,
                                             NEW_DATUM_ID,
                                             NEW_NODE_MEASURE,
                                             NEW_NODE_TYPE,
                                             NEW_START_MEASURE,
                                             NEW_END_MEASURE,
                                             pct_match,
                                             status,
                                             manual_override,
                                             new_ne_id,
                                             NEW_GEOMETRY)
            SELECT batch_id,
                   sld_key,
                   swd_id,
                   datum_id,
                   geom,
                   hashcode,
                   node_type,
                   node_measure,
                   geom_m,
                   max_id,
                   route_len,
                   new_id,
                   new_measure,
                   new_node_type,
                   start_measure,
                   end_measure,
                   pct_match,
                   status,
                   manual_override,
                   new_ne_id,
                   nm_sdo.scale_geom (nm_sdo.reverse_geom_and_measure (geom),
                                      start_measure,
                                      end_measure)
              FROM (SELECT batch_id,
                           sld_key,
                           swd_id,
                           datum_id,
                           geom,
                           hashcode,
                           node_type,
                           node_measure,
                           geom_m,
                           max_id,
                           route_len,
                           new_id,
                           new_measure,
                           new_node_type,
                           MIN (new_measure)
                               OVER (PARTITION BY sld_key, swd_id)
                               start_measure,
                           MAX (new_measure)
                               OVER (PARTITION BY sld_key, swd_id)
                               end_measure,
                           pct_match,
                           status,
                           manual_override,
                           new_ne_id
                      FROM (SELECT batch_id,
                                   sld_key,
                                   swd_id,
                                   datum_id,
                                   geom,
                                   hashcode,
                                   node_type,
                                   node_measure,
                                   end_m - start_m             geom_m,
                                   max_id,
                                   route_len,
                                   max_id - datum_id + 1       new_id,
                                   route_len - node_measure    new_measure,
                                   CASE node_type
                                       WHEN 'S' THEN 'E'
                                       WHEN 'E' THEN 'S'
                                   END                         new_node_type,
                                   pct_match,
                                   status,
                                   manual_override,
                                   new_ne_id
                              FROM (SELECT d.batch_id,
                                           sld_key,
                                           d.swd_id,
                                           datum_id,
                                           geom,
                                           hashcode,
                                           node_type,
                                           node_measure,
                                           SDO_LRS.geom_segment_start_measure (
                                               geom)
                                               start_m,
                                           SDO_LRS.geom_segment_end_measure (
                                               geom)
                                               end_m,
                                           MAX (datum_id)
                                               OVER (PARTITION BY sld_key)
                                               max_id,
                                           MAX (node_measure)
                                               OVER (PARTITION BY sld_key)
                                               route_len,
                                           pct_match,
                                           status,
                                           manual_override,
                                           new_ne_id
                                      FROM sdl_wip_datums       d,
                                           sdl_wip_datum_nodes  n
                                     WHERE     sld_key IN
                                                   (SELECT COLUMN_VALUE
                                                      FROM TABLE (p_sld_keys))
                                           AND n.swd_id = d.swd_id)));
    END;

    PROCEDURE DELETE_DATUMS
    IS
    BEGIN
        DELETE FROM sdl_wip_datum_nodes
              WHERE swd_id IN (SELECT swd_id FROM SDL_WIP_DATUM_REVERSALS);

        DELETE FROM sdl_wip_datums
              WHERE swd_id IN (SELECT swd_id FROM SDL_WIP_DATUM_REVERSALS);
    END;

    PROCEDURE INSERT_REVERSED_DATUMS
    IS
    BEGIN
        INSERT INTO sdl_wip_datums (swd_id,
                                    batch_id,
                                    sld_key,
                                    datum_id,
                                    pct_match,
                                    status,
                                    manual_override,
                                    new_ne_id,
                                    geom)
              SELECT swd_id,
                     batch_id,
                     sld_key,
                     new_datum_id,
                     pct_match,
                     status,
                     manual_override,
                     new_ne_id,
                     (SELECT new_geometry
                        FROM sdl_wip_datum_reversals r2
                       WHERE r2.swd_id = r1.swd_id AND ROWNUM = 1)
                FROM SDL_WIP_DATUM_REVERSALS r1
            GROUP BY swd_id,
                     batch_id,
                     sld_key,
                     new_datum_id,
                     pct_match,
                     status,
                     manual_override,
                     new_ne_id;

        INSERT INTO sdl_wip_datum_nodes (swd_id,
                                         batch_id,
                                         hashcode,
                                         node_type,
                                         node_measure)
            SELECT swd_id,
                   batch_id,
                   hashcode,
                   new_node_type,
                   new_node_measure
              FROM SDL_WIP_DATUM_REVERSALS;
    END;
END sdl_edit;
/