CREATE OR REPLACE PACKAGE BODY SDO_LRS
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdo_lrs.pkb-arc   1.7   May 07 2019 17:14:38   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdo_lrs.pkb  $
    --       Date into PVCS   : $Date:   May 07 2019 17:14:38  $
    --       Date fetched Out : $Modtime:   May 07 2019 17:13:28  $
    --       PVCS Version     : $Revision:   1.7  $
    --
    --   Author : R.A. Coupe
    --
    --   Package for handling SDO data - acts as a the basis for the replacement of SDO_LRS
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    -- The main purpose of this package is to replicate the functions inside the SDO_LRS package as
    -- supplied under the MDSYS schema and licensed under the Oracle Spatial license on EE.

    g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.7  $';

    g_package_name   CONSTANT VARCHAR2 (30) := 'SDO_LRS';

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

    FUNCTION locate_pt (geom_segment   IN MDSYS.SDO_GEOMETRY,
                        dim_array      IN MDSYS.SDO_DIM_ARRAY,
                        measure        IN NUMBER,
                        offset         IN NUMBER DEFAULT 0)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.LOCATE_PT (geom_segment, measure);
    END;


    FUNCTION locate_pt (geom_segment   IN MDSYS.SDO_GEOMETRY,
                        measure        IN NUMBER,
                        offset         IN NUMBER DEFAULT 0,
                        tolerance      IN NUMBER DEFAULT 1.0e-8)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.LOCATE_PT (geom_segment, measure);
    END;

    FUNCTION connected_geom_segments (
        geom_segment_1   IN MDSYS.SDO_GEOMETRY,
        dim_array_1      IN MDSYS.SDO_DIM_ARRAY,
        geom_segment_2   IN MDSYS.SDO_GEOMETRY,
        dim_array_2      IN MDSYS.SDO_DIM_ARRAY)
        RETURN VARCHAR2
        PARALLEL_ENABLE
    IS
    BEGIN
        IF NM_SDO.is_connected (geom_segment_1,
                                geom_segment_2,
                                dim_array_1 (1).sdo_tolerance) >
           0
        THEN
            RETURN 'TRUE';
        ELSE
            RETURN 'FALSE';
        END IF;
    END;


    FUNCTION concatenate_geom_segments (
        geom_segment_1   IN MDSYS.SDO_GEOMETRY,
        dim_array_1      IN MDSYS.SDO_DIM_ARRAY,
        geom_segment_2   IN MDSYS.SDO_GEOMETRY,
        dim_array_2      IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.merge (geom_segment_1,
                             geom_segment_2,
                             dim_array_1 (1).sdo_tolerance);
    END;

    FUNCTION concatenate_geom_segments (
        geom_segment_1   IN MDSYS.SDO_GEOMETRY,
        geom_segment_2   IN MDSYS.SDO_GEOMETRY,
        tolerance        IN NUMBER DEFAULT 1.0e-8)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.merge (geom_segment_1, geom_segment_2, tolerance);
    END;

    FUNCTION clip_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                dim_array       IN MDSYS.SDO_DIM_ARRAY,
                                start_measure   IN NUMBER,
                                end_measure     IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CLIP (geom            => geom_segment,
                            start_measure   => start_measure,
                            end_measure     => end_measure,
                            tolerance       => dim_array (1).sdo_tolerance);
    END;

    FUNCTION clip_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                start_measure   IN NUMBER,
                                end_measure     IN NUMBER,
                                tolerance       IN NUMBER DEFAULT 1.0e-8)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CLIP (geom            => geom_segment,
                            start_measure   => start_measure,
                            end_measure     => end_measure,
                            tolerance       => tolerance);
    END;

    FUNCTION dynamic_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                              dim_array       IN MDSYS.SDO_DIM_ARRAY,
                              start_measure   IN NUMBER,
                              end_measure     IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN clip_geom_segment (geom_segment    => geom_segment,
                                  dim_array       => dim_array,
                                  start_measure   => start_measure,
                                  end_measure     => end_measure);
    END;

    FUNCTION dynamic_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                              start_measure   IN NUMBER,
                              end_measure     IN NUMBER,
                              tolerance       IN NUMBER DEFAULT 1.0e-8)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN clip_geom_segment (geom_segment    => geom_segment,
                                  start_measure   => start_measure,
                                  end_measure     => end_measure,
                                  tolerance       => tolerance);
    END;


    PROCEDURE split_geom_segment (geom_segment    IN     MDSYS.SDO_GEOMETRY,
                                  dim_array       IN     MDSYS.SDO_DIM_ARRAY,
                                  split_measure   IN     NUMBER,
                                  segment_1          OUT MDSYS.SDO_GEOMETRY,
                                  segment_2          OUT MDSYS.SDO_GEOMETRY)
    IS
    BEGIN
        NM_SDO.SPLIT (geom_segment,
                      split_measure,
                      dim_array (1).sdo_tolerance,
                      segment_1,
                      segment_2);
    END;

    PROCEDURE split_geom_segment (
        geom_segment    IN     MDSYS.SDO_GEOMETRY,
        split_measure   IN     NUMBER,
        segment_1          OUT MDSYS.SDO_GEOMETRY,
        segment_2          OUT MDSYS.SDO_GEOMETRY,
        tolerance       IN     NUMBER DEFAULT 1.0e-8)
    IS
    BEGIN
        NM_SDO.SPLIT (geom_segment,
                      split_measure,
                      tolerance,
                      segment_1,
                      segment_2);
    END;


    FUNCTION scale_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                 dim_array       IN MDSYS.SDO_DIM_ARRAY,
                                 start_measure   IN NUMBER,
                                 end_measure     IN NUMBER,
                                 shift_measure   IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.SCALE_GEOM (geom_segment, start_measure, end_measure);
    END;

    FUNCTION scale_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                 start_measure   IN NUMBER,
                                 end_measure     IN NUMBER,
                                 shift_measure   IN NUMBER,
                                 tolerance       IN NUMBER DEFAULT 1.0e-8)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.SCALE_GEOM (geom_segment, start_measure, end_measure);
    END;

    FUNCTION translate_measure (geom_segment   IN MDSYS.SDO_GEOMETRY,
                                dim_array      IN MDSYS.SDO_DIM_ARRAY,
                                translate_m    IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.translate_measure (geom_segment,
                                         dim_array,
                                         translate_m);
    END;


    FUNCTION translate_measure (geom_segment   IN MDSYS.SDO_GEOMETRY,
                                translate_m    IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.translate_measure (geom_segment, translate_m);
    END;


    FUNCTION geom_segment_start_measure (
        geom_segment   IN MDSYS.SDO_GEOMETRY,
        dim_array      IN MDSYS.SDO_DIM_ARRAY)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_start_measure (geom_segment);
    END;

    FUNCTION geom_segment_start_measure (geom_segment IN MDSYS.SDO_GEOMETRY)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_start_measure (geom_segment);
    END;

    FUNCTION geom_segment_end_measure (geom_segment   IN MDSYS.SDO_GEOMETRY,
                                       dim_array      IN MDSYS.SDO_DIM_ARRAY)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_end_measure (geom_segment);
    END;

    FUNCTION geom_segment_end_measure (geom_segment IN MDSYS.SDO_GEOMETRY)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_end_measure (geom_segment);
    END;


    FUNCTION geom_segment_start_pt (geom_segment   IN MDSYS.SDO_GEOMETRY,
                                    dim_array      IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_start_pt (geom_segment);
    END;


    FUNCTION geom_segment_start_pt (geom_segment IN MDSYS.SDO_GEOMETRY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_start_pt (geom_segment);
    END;


    FUNCTION geom_segment_end_pt (geom_segment   IN MDSYS.SDO_GEOMETRY,
                                  dim_array      IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_end_pt (geom_segment);
    END;


    FUNCTION geom_segment_end_pt (geom_segment IN MDSYS.SDO_GEOMETRY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.geom_segment_end_pt (geom_segment);
    END;


    PROCEDURE redefine_geom_segment (
        geom_segment    IN OUT MDSYS.SDO_GEOMETRY,
        dim_array       IN     MDSYS.SDO_DIM_ARRAY,
        start_measure   IN     NUMBER,
        end_measure     IN     NUMBER)
    IS
    BEGIN
        geom_segment :=
            NM_SDO.REDEFINE_GEOM (geom_segment, start_measure, end_measure);
    END;

    PROCEDURE redefine_geom_segment (
        geom_segment   IN OUT MDSYS.SDO_GEOMETRY,
        dim_array      IN     MDSYS.SDO_DIM_ARRAY)
    IS
    BEGIN
        geom_segment :=
            NM_SDO.REDEFINE_GEOM (geom_segment,
                                  0,
                                  SDO_GEOM.sdo_length (geom_segment, 0.005));
    END;


    PROCEDURE redefine_geom_segment (
        geom_segment    IN OUT MDSYS.SDO_GEOMETRY,
        start_measure   IN     NUMBER,
        end_measure     IN     NUMBER,
        tolerance       IN     NUMBER DEFAULT 1.0e-8)
    IS
    BEGIN
        geom_segment :=
            NM_SDO.REDEFINE_GEOM (geom_segment, start_measure, end_measure);
    END;

    PROCEDURE redefine_geom_segment (
        geom_segment   IN OUT MDSYS.SDO_GEOMETRY,
        tolerance      IN     NUMBER DEFAULT 1.0e-8)
    IS
    BEGIN
        geom_segment :=
            NM_SDO.REDEFINE_GEOM (geom_segment,
                                  0,
                                  SDO_GEOM.sdo_length (geom_segment, 0.005));
    END;

    FUNCTION convert_to_lrs_dim_array (dim_array     IN MDSYS.SDO_DIM_ARRAY,
                                       lower_bound   IN NUMBER DEFAULT NULL,
                                       upper_bound   IN NUMBER DEFAULT NULL,
                                       tolerance     IN NUMBER DEFAULT NULL)
        RETURN MDSYS.SDO_DIM_ARRAY
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CONVERT_TO_LRS_DIM_ARRAY (dim_array,
                                                lower_bound,
                                                upper_bound,
                                                tolerance);
    END;


    --   FUNCTION convert_to_lrs_geom(standard_geom IN MDSYS.SDO_GEOMETRY,
    --                                dim_array     IN MDSYS.SDO_DIM_ARRAY,
    --                                m_pos         IN INTEGER,
    --                                start_measure IN NUMBER ,
    --                                end_measure   IN NUMBER )
    --   RETURN MDSYS.SDO_GEOMETRY DETERMINISTIC PARALLEL_ENABLE;
    --
    --   FUNCTION convert_to_lrs_geom(standard_geom IN MDSYS.SDO_GEOMETRY,
    --                                dim_array     IN MDSYS.SDO_DIM_ARRAY,
    --                                m_pos         IN INTEGER DEFAULT NULL)
    --   RETURN MDSYS.SDO_GEOMETRY DETERMINISTIC PARALLEL_ENABLE;
    --
    --   FUNCTION convert_to_lrs_geom(standard_geom IN MDSYS.SDO_GEOMETRY,
    --                                dim_array     IN MDSYS.SDO_DIM_ARRAY,
    --                                start_measure IN NUMBER ,
    --                                end_measure   IN NUMBER )
    --   RETURN MDSYS.SDO_GEOMETRY DETERMINISTIC PARALLEL_ENABLE;
    --
    --   FUNCTION convert_to_lrs_geom(standard_geom IN MDSYS.SDO_GEOMETRY,
    --                                m_pos         IN INTEGER,
    --                                start_measure IN NUMBER,
    --                                end_measure   IN NUMBER)
    --   RETURN MDSYS.SDO_GEOMETRY DETERMINISTIC PARALLEL_ENABLE;
    --
    FUNCTION convert_to_lrs_geom (standard_geom   IN MDSYS.SDO_GEOMETRY,
                                  start_measure   IN NUMBER,
                                  end_measure     IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.SCALE_GEOM (NM_SDO.CONVERT_TO_LRS_GEOM (standard_geom),
                                  start_measure,
                                  end_measure);
    END;

    --
    --   FUNCTION convert_to_lrs_geom(standard_geom IN MDSYS.SDO_GEOMETRY,
    --                                m_pos         IN INTEGER)
    --   RETURN MDSYS.SDO_GEOMETRY DETERMINISTIC PARALLEL_ENABLE;

    FUNCTION convert_to_lrs_geom (standard_geom IN MDSYS.SDO_GEOMETRY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CONVERT_TO_LRS_GEOM (standard_geom);
    END;


    FUNCTION convert_to_std_dim_array (dim_array IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_DIM_ARRAY
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CONVERT_TO_STD_DIM_ARRAY (dim_array);
    END;

    --   FUNCTION convert_to_std_dim_array(dim_array   IN MDSYS.SDO_DIM_ARRAY,
    --                                     m_pos       IN INTEGER)
    --   RETURN MDSYS.SDO_DIM_ARRAY PARALLEL_ENABLE;

    FUNCTION convert_to_std_geom (lrs_geom    IN MDSYS.SDO_GEOMETRY,
                                  dim_array   IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CONVERT_TO_STD_GEOM (lrs_geom);
    END;

    FUNCTION convert_to_std_geom (lrs_geom IN MDSYS.SDO_GEOMETRY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CONVERT_TO_STD_GEOM (lrs_geom);
    END;

    FUNCTION offset_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                  dim_array       IN MDSYS.SDO_DIM_ARRAY,
                                  start_measure   IN NUMBER,
                                  end_measure     IN NUMBER,
                                  offset          IN NUMBER,
                                  unit            IN VARCHAR2)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.offset_geom_segment (geom_segment,
                                           start_measure,
                                           end_measure,
                                           offset,
                                           dim_array (1).sdo_tolerance);
    END;

    FUNCTION offset_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                  start_measure   IN NUMBER,
                                  end_measure     IN NUMBER,
                                  offset          IN NUMBER,
                                  tolerance       IN NUMBER,
                                  unit            IN VARCHAR2)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.offset_geom_segment (geom_segment,
                                           start_measure,
                                           end_measure,
                                           offset,
                                           tolerance);
    END;

    FUNCTION offset_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                  dim_array       IN MDSYS.SDO_DIM_ARRAY,
                                  start_measure   IN NUMBER,
                                  end_measure     IN NUMBER,
                                  offset          IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.offset_geom_segment (geom_segment,
                                           start_measure,
                                           end_measure,
                                           offset,
                                           dim_array (1).sdo_tolerance);
    END;

    FUNCTION offset_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                  start_measure   IN NUMBER,
                                  end_measure     IN NUMBER,
                                  offset          IN NUMBER,
                                  tolerance       IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.offset_geom_segment (geom_segment,
                                           start_measure,
                                           end_measure,
                                           offset,
                                           tolerance);
    END;

    FUNCTION offset_geom_segment (geom_segment    IN MDSYS.SDO_GEOMETRY,
                                  start_measure   IN NUMBER,
                                  end_measure     IN NUMBER,
                                  offset          IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.CLIP (geom_segment, start_measure, end_measure);
    END;

    FUNCTION find_measure (
        geom_segment      IN MDSYS.SDO_GEOMETRY,
        dim_array         IN MDSYS.SDO_DIM_ARRAY,
        point             IN MDSYS.SDO_GEOMETRY,
        point_dim_array   IN MDSYS.SDO_DIM_ARRAY DEFAULT NULL)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.FIND_MEASURE (geom_segment, point);
    END;

    FUNCTION find_measure (geom_segment   IN MDSYS.SDO_GEOMETRY,
                           point          IN MDSYS.SDO_GEOMETRY,
                           tolerance      IN NUMBER DEFAULT 1.0e-8)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.FIND_MEASURE (geom_segment, point);
    END;

    FUNCTION reverse_measure (geom_segment   IN MDSYS.SDO_GEOMETRY,
                              dim_array      IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.REVERSE_MEASURE (geom_segment);
    END;

    FUNCTION reverse_measure (geom_segment IN MDSYS.SDO_GEOMETRY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.REVERSE_MEASURE (geom_segment);
    END;

    FUNCTION reverse_geometry (geom        IN MDSYS.SDO_GEOMETRY,
                               dim_array   IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.REVERSE_GEOMETRY (geom);
    END;

    FUNCTION reverse_geometry (geom IN MDSYS.SDO_GEOMETRY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.REVERSE_GEOMETRY (geom);
    END;

    FUNCTION project_pt (geom_segment      IN MDSYS.SDO_GEOMETRY,
                         dim_array         IN MDSYS.SDO_DIM_ARRAY,
                         point             IN MDSYS.SDO_GEOMETRY,
                         point_dim_array   IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.PROJECT_PT (geom_segment,
                                  point,
                                  dim_array (1).sdo_tolerance);
    END;

    FUNCTION project_pt (geom_segment   IN MDSYS.SDO_GEOMETRY,
                         dim_array      IN MDSYS.SDO_DIM_ARRAY,
                         point          IN MDSYS.SDO_GEOMETRY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.PROJECT_PT (geom_segment,
                                  point,
                                  dim_array (1).sdo_tolerance);
    END;

    FUNCTION project_pt (geom_segment      IN     MDSYS.SDO_GEOMETRY,
                         dim_array         IN     MDSYS.SDO_DIM_ARRAY,
                         point             IN     MDSYS.SDO_GEOMETRY,
                         point_dim_array   IN     MDSYS.SDO_DIM_ARRAY,
                         offset               OUT NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.PROJECT_PT (geom_segment,
                                  point,
                                  dim_array (1).sdo_tolerance,
                                  offset);
    END;

    FUNCTION project_pt (geom_segment   IN MDSYS.SDO_GEOMETRY,
                         point          IN MDSYS.SDO_GEOMETRY,
                         tolerance      IN NUMBER DEFAULT 1.0e-8)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.PROJECT_PT (geom_segment, point, tolerance);
    END;

    FUNCTION project_pt (geom_segment   IN     MDSYS.SDO_GEOMETRY,
                         point          IN     MDSYS.SDO_GEOMETRY,
                         tolerance      IN     NUMBER,
                         offset            OUT NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.PROJECT_PT (geom_segment,
                                  point,
                                  tolerance,
                                  offset);
    END;

    FUNCTION lrs_intersection (geom_1        IN MDSYS.SDO_GEOMETRY,
                               dim_array_1   IN MDSYS.SDO_DIM_ARRAY,
                               geom_2        IN MDSYS.SDO_GEOMETRY,
                               dim_array_2   IN MDSYS.SDO_DIM_ARRAY)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.lrs_intersection (geom_1, geom_2);
    END;

    FUNCTION lrs_intersection (geom_1      IN MDSYS.SDO_GEOMETRY,
                               geom_2      IN MDSYS.SDO_GEOMETRY,
                               tolerance   IN NUMBER)
        RETURN MDSYS.SDO_GEOMETRY
        DETERMINISTIC
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.lrs_intersection (geom_1, geom_2);
    END;

    FUNCTION geom_segment_length (geom_segment   IN MDSYS.SDO_GEOMETRY,
                                  dim_array      IN MDSYS.SDO_DIM_ARRAY)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.geom_segment_length (geom_segment, dim_array);
    END;

    FUNCTION geom_segment_length (geom_segment   IN MDSYS.SDO_GEOMETRY,
                                  tolerance      IN NUMBER DEFAULT 1.0e-8)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN nm_sdo.geom_segment_length (geom_segment, tolerance);
    END;

    FUNCTION get_measure (point       IN MDSYS.SDO_GEOMETRY,
                          dim_array   IN MDSYS.SDO_DIM_ARRAY)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.GET_MEASURE (point, dim_array);
    END;

    FUNCTION get_measure (point IN MDSYS.SDO_GEOMETRY)
        RETURN NUMBER
        PARALLEL_ENABLE
    IS
    BEGIN
        RETURN NM_SDO.GET_MEASURE (point);
    END;
END;
/