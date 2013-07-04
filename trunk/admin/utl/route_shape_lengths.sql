-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)route_shape_lengths.sql	1.2 03/16/06
--       Module Name      : route_shape_lengths.sql
--       Date into SCCS   : 06/03/16 14:05:47
--       Date fetched Out : 07/06/13 17:07:27
--       SCCS Version     : 1.2
--
--  This script is used for the 3211 post upgrade
--  Resets measures on Route shapes to match the correct units.
--
--  Author:	Rob Coupe
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--
CREATE OR REPLACE PROCEDURE set_measure (
   p_shape    IN OUT NOCOPY   MDSYS.SDO_GEOMETRY,
   p_factor   IN              NUMBER
)
IS
--this procedure scales the 3rd ordinate by the given factor. It is only of use on 3d shapes where 
--the 3rd ordinate is the measure.
BEGIN
   FOR i IN 1 .. p_shape.sdo_ordinates.LAST
   LOOP
      IF MOD (i, 3) = 0
      THEN
         p_shape.sdo_ordinates (i) := p_shape.sdo_ordinates (i) * p_factor;
      END IF;
   END LOOP;
END;
/


CREATE OR REPLACE PROCEDURE reset_group_shape_units (
   p_nlt_id   IN   nm_linear_types.nlt_id%TYPE
)
IS
--this procedure will extract the themes to be upgraded and if theunit of meaure is appropriate 
--it will perform the update.

   CURSOR c1 (c_nlt_id IN nm_linear_types.nlt_id%TYPE)
   IS
      SELECT nth_theme_id
        FROM nm_themes_all, nm_nw_themes
       WHERE nnth_nlt_id = c_nlt_id
         AND nnth_nth_theme_id = nth_theme_id
         AND nth_base_table_theme IS NULL;

   l_nlt           nm_linear_types%ROWTYPE;
   l_nth           nm_themes_all%ROWTYPE;
   gty_cur         nm3type.ref_cursor;
   cur_str         VARCHAR2 (2000);
   l_d_unit        nm_units.un_unit_id%TYPE;
   l_g_unit        nm_units.un_unit_id%TYPE;
   l_conv_factor   NUMBER;
   l_row           ROWID;
   l_geom          MDSYS.SDO_GEOMETRY;
BEGIN
   l_nlt := nm3get.get_nlt (p_nlt_id);
   nm3net.get_group_units (l_nlt.nlt_gty_type, l_g_unit, l_d_unit);
   l_conv_factor := nm3get.get_uc (l_d_unit, l_g_unit).uc_conversion_factor;

   IF l_nlt.nlt_gty_type IS NOT NULL AND l_conv_factor != 1
   THEN
      FOR irec IN c1 (p_nlt_id)
      LOOP
         l_nth := nm3get.get_nth (irec.nth_theme_id);
         cur_str :=
               'select  rowid shape_row, '
            || l_nth.nth_feature_shape_column
            || ' from '
            || l_nth.nth_feature_table;

         OPEN gty_cur FOR cur_str;
         FETCH gty_cur
          INTO l_row, l_geom;

         WHILE gty_cur%FOUND
         LOOP
            set_measure (l_geom, l_conv_factor);

            EXECUTE IMMEDIATE    'update '
                              || l_nth.nth_feature_table
                              || ' set '
                              || l_nth.nth_feature_shape_column
                              || ' =  :b_geom where rowid = :b_rowid'
                        USING l_geom, l_row;

            FETCH gty_cur
             INTO l_row, l_geom;
         END LOOP;

         CLOSE gty_cur;
      END LOOP;
   END IF;
END;
/

--This is the driving query for the upgrade. It retrieves the themes on which to operate and will 
--re-register the sde data as appropriate.
DECLARE
   CURSOR c_nlt
   IS
      SELECT nlt_id, nlt_nt_type
        FROM nm_linear_types,
             nm_nw_themes,
             nm_themes_all,
             nm_group_types,
             user_tables,
             nm_theme_gtypes,
             nm_nt_groupings,
             nm_types a,
             nm_types b
       WHERE nlt_id = nnth_nlt_id
         AND nnth_nth_theme_id = nth_theme_id
         AND nth_feature_table = table_name
         AND nlt_gty_type = ngt_group_type
         AND ngt_nt_type = nlt_nt_type
         AND ntg_theme_id = nth_theme_id
         AND ntg_gtype = 3002
         AND a.nt_length_unit != b.nt_length_unit
         AND a.nt_type = nlt_nt_type
         AND b.nt_type = nng_nt_type
         AND nng_group_type = nlt_gty_type;
		 
CURSOR c1(c_nlt_id IN nm_linear_types.nlt_id%TYPE)  IS
  SELECT nnth_nth_theme_id
  FROM nm_nw_themes
  WHERE nnth_nlt_id = c_nlt_id;		 
BEGIN
   FOR irec IN c_nlt
   LOOP
--    first reset the units on the group layer

      Reset_Group_Shape_Units (irec.nlt_id);
--
--
--    if sde is registered the sde metadata will need to reflect the change.
--
      IF Hig.get_sysopt('REGSDELAY') = 'Y' THEN
--
--      Now retrieve the units for the particular nt_type.
--           
        Nm3sdm.g_units := Nm3net.get_nt_units( irec.nlt_nt_type);

        IF Nm3sdm.g_units = 1 THEN
 	      Nm3sdm.g_unit_conv := 1;
        ELSE
	     Nm3sdm.g_unit_conv := Nm3get.get_uc ( Nm3sdm.g_units, 1).uc_conversion_factor;
	END IF;

        FOR jrec IN c1(irec.nlt_id) LOOP

          EXECUTE IMMEDIATE 'begin Nm3sde.drop_layer_by_theme('||TO_CHAR(jrec.nnth_nth_theme_id)||'); end;';
           
          EXECUTE IMMEDIATE 'begin Nm3sde.register_sde_layer('||TO_CHAR(jrec.nnth_nth_theme_id)||'); end;';
           
        END LOOP;
      END IF;	
   END LOOP;
END;
/

