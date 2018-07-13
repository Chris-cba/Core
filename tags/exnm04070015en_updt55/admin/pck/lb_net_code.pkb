CREATE OR REPLACE PACKAGE BODY lb_net_code
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_net_code.pkb-arc   1.2   Jul 13 2018 14:39:22   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_net_code.pkb  $
   --       Date into PVCS   : $Date:   Jul 13 2018 14:39:22  $
   --       Date fetched Out : $Modtime:   Jul 13 2018 14:38:44  $
   --       PVCS Version     : $Revision:   1.2  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for snapping and net-coding
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.2  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_net_code';

   FUNCTION get_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_sccsid;
   END get_version;

   --
   -----------------------------------------------------------------------------
   --

   FUNCTION get_body_version
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;

   --
   -----------------------------------------------------------------------------
   --

   FUNCTION lb_snap_xy_to_nw (pi_x          IN NUMBER,
                              pi_y          IN NUMBER,
                              pi_in_srid    IN NUMBER,
                              pi_buffer     IN NUMBER,
                              pi_in_uol     IN nm_units.un_unit_id%TYPE,
                              pi_out_srid   IN NUMBER,
                              pi_out_uol    IN nm_units.un_unit_id%TYPE,
                              pi_themes     IN nm_theme_array_type,
                              CARDINALITY   IN INTEGER)
      RETURN lb_snap_tab
   AS
      retval         lb_snap_tab;
      l_sql          VARCHAR2 (4000);
      qq             CHAR (1) := CHR (39);
      tol            NUMBER := 0.005;
      l_units_in     nm_units.un_unit_name%TYPE;
      l_units_out    nm_units.un_unit_name%TYPE;

      invalid_unit   EXCEPTION;
      PRAGMA EXCEPTION_INIT (invalid_unit, -29902);
   BEGIN
      /*
        Check the supplied units
      */
      BEGIN
         SELECT un_unit_name
           INTO l_units_in
           FROM nm_units
          WHERE un_unit_id = pi_in_uol;

         SELECT un_unit_name
           INTO l_units_out
           FROM nm_units
          WHERE un_unit_id = pi_out_uol;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20010,
               'Unit of measure not found, check Exor units data');
      END;

      BEGIN
         WITH themes
              AS (SELECT t.*,
                         nlt_id,
                         nlt_units,
                         pi_in_srid in_srid
                    FROM TABLE (pi_themes) t, nm_nw_themes, nm_linear_types
                   WHERE nlt_id = nnth_nlt_id AND nnth_nth_theme_id = nthe_id)
         SELECT LISTAGG (
                      ' select s.'
                   || nth_feature_pk_column
                   || ' ne_id'
                   || ', s.'
                   || nth_feature_shape_column
                   || ' geom , '
                   || nlt_id
                   || ' nlt_id, '
                   || CASE in_srid
                         WHEN srid
                         THEN
                            ' in_pt.pt_input_geom '
                         ELSE
                               'sdo_cs.transform(in_pt.pt_input_geom, '
                            || srid
                            || ') '
                      END
                   || ' pt_input_geom '
                   || ', '
                   || nlt_units
                   || ' base_nw_unit, '
                   || pi_in_srid
                   || ' in_srid, '
                   || srid
                   || ' base_srid, '
                   || pi_out_srid
                   || ' out_srid '
                   || 'FROM '
                   || nth_feature_table
                   || ' s, in_pt '
                   || ' WHERE sdo_within_distance ( '
                   || nth_feature_shape_column
                   || ', '
                   || CASE in_srid
                         WHEN srid
                         THEN
                            ' pt_input_geom, '
                         ELSE
                               'sdo_cs.transform(pt_input_geom, '
                            || srid
                            || '), '
                      END
                   || ' buffer_string) = '
                   || ''''
                   || 'TRUE'
                   || '''',
                   ' union all ')
                WITHIN GROUP (ORDER BY nthe_id)
           INTO l_sql
           --, nth_theme_id, nth_feature_table, nth_feature_shape_column, nth_feature_pk_column
           FROM nm_themes_all, themes, user_sdo_geom_metadata
          WHERE nthe_id = nth_theme_id AND nth_feature_table = table_name;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (
               -20011,
               'The list of themes does not match the Exor network themes');
      END;

      IF l_sql IS NULL
      THEN
         raise_application_error (
            -20012,
            'The list of themes does not match the Exor network themes');
      END IF;

--      nm_debug.debug ('SQL = ' || l_sql);


      BEGIN
         l_sql :=
               ' WITH '
            || '  in_pt as ( select '
            || qq
            || 'distance = '
            || qq
            || '||to_char(:buffer)||'
            || qq
            || ' unit='
            || l_units_in
            || qq
            || ' buffer_string, '
            || '  sdo_geometry(2001, :in_srid, sdo_point_type( :x , :y, NULL), NULL, NULL) pt_input_geom, :out_srid out_srid, :out_uom out_uom from dual ), '
            || ' snaps AS ( '
            || l_sql
            || ')'
            || ' SELECT CAST (COLLECT (lb_snap(q1.ne_id, nlt_id, q1.ne_nt_type, q1.ne_gty_group_type, q1.ne_unique, q1.ne_descr, '
            || 'sdo_lrs.geom_segment_start_measure(proj_pt)*uc_conversion_factor, distance, '
            || TO_CHAR (pi_out_uol)
            || ', '
            || qq
            || l_units_out
            || qq
            || ','
            || ' case base_srid when out_srid then geom else sdo_cs.transform(geom, out_srid) end, '
            || ' case base_srid when out_srid then proj_pt else sdo_cs.transform(proj_pt, out_srid) end '
            || ' )) as lb_snap_tab ) '
            || ' FROM (SELECT /*+INDEX(e NE_PK) */ s.ne_id, s.nlt_id, e.ne_unique, e.ne_descr, e.ne_nt_type, e.ne_gty_group_type, pt_input_geom, in_srid, out_srid, base_srid,'
            || '  SDO_LRS.project_pt ( geom, pt_input_geom) '
            || '   proj_pt, '
            || '  sdo_geom.sdo_distance ( geom, pt_input_geom, :tol, '
            || qq
            || 'unit='
            || l_units_out
            || qq
            || ') distance, '
            || ' geom, '
            || ' base_nw_unit '
            || ' FROM snaps s, nm_elements e '
            || '     WHERE s.ne_id = e.ne_id order by 8 ) q1, nm_unit_conversions where uc_unit_id_in = base_nw_unit and uc_unit_id_out = :out_uol '
            || '        order by distance ';

--       nm_debug.debug (l_sql);

         EXECUTE IMMEDIATE l_sql
            INTO retval
            USING pi_buffer,
                  pi_in_srid,
                  pi_x,
                  pi_y,
                  pi_out_srid,
                  pi_out_uol,
                  tol,
                  pi_out_uol;
      EXCEPTION
         WHEN invalid_unit
         THEN
            raise_application_error (
               -20902,
               'Invalid Unit, the Exor unit name must match the unit name in SDO_DIST_UNITS table');
      END;

      RETURN retval;
   END;
END;
/
