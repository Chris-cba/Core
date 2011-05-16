CREATE OR REPLACE PACKAGE BODY Nm3homo_Gis AS
--
-----------------------------------------------------------------------------
--
-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/admin/pck/nm3homo_gis.pkb-arc   2.6   May 16 2011 14:44:50   Steve.Cooper  $
-- Module Name : $Workfile:   nm3homo_gis.pkb  $
-- Date into PVCS : $Date:   May 16 2011 14:44:50  $
-- Date fetched Out : $Modtime:   Apr 01 2011 14:09:12  $
-- PVCS Version : $Revision:   2.6  $
-- Based on SCCS version : 
--   Author : Jonathan Mills
--
--   GIS wrapper for asset (and other products) location package body
--
-- 20-01-2005 AE
--            New param - pi_geom -- to allow update/insert of shape
--            Update of point xy/lref on base theme table from both shape
--            and xy passed in.
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid      CONSTANT   VARCHAR2(2000) := '"$Revision:   2.6  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name     CONSTANT   VARCHAR2(30)   := 'nm3homo_gis';
   c_asset_table      CONSTANT   VARCHAR2(30)   := 'NM_INV_ITEMS';
--
   l_raise_hig_151               EXCEPTION;
   l_raise_hig_152               EXCEPTION;
   e_no_network_for_mand_loc_inv EXCEPTION;
   e_homo_xy_update              EXCEPTION;
-----------------------------------------------------------------------------
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
FUNCTION column_exists (p_table_name  VARCHAR2
                       ,p_column_name VARCHAR2
                       ) RETURN BOOLEAN IS
--
   l_retval BOOLEAN;
--
BEGIN
--
   BEGIN
      l_retval := Nm3ddl.get_column_details
                    ( p_column_name => p_column_name
                    , p_table_name  => p_table_name
                    ).table_name IS NOT NULL;
   EXCEPTION
      WHEN OTHERS
       THEN
         l_retval := FALSE;
   END;
--
   RETURN l_retval;
--
END column_exists;
--
-----------------------------------------------------------------------------
--
FUNCTION is_inventory( p_theme IN NM_THEMES_ALL.nth_theme_id%TYPE )
  RETURN BOOLEAN
IS
  dummy NUMBER;
  retval BOOLEAN := FALSE;
  CURSOR c1 ( c_nth IN NM_THEMES_ALL.nth_theme_id%TYPE)
  IS
    SELECT 1 FROM NM_INV_THEMES
     WHERE nith_nth_theme_id = c_nth;
BEGIN
  OPEN  c1( p_theme );
  FETCH c1 INTO dummy;
  retval := c1%FOUND;
  CLOSE c1;
  RETURN retval;
END is_inventory;
--
-----------------------------------------------------------------------------
--
FUNCTION is_ft_inventory( p_theme IN NM_THEMES_ALL.nth_theme_id%TYPE )
  RETURN BOOLEAN
IS
  dummy NUMBER;
  retval BOOLEAN := FALSE;
  CURSOR c1 ( c_nth IN NM_THEMES_ALL.nth_theme_id%TYPE)
  IS
    SELECT 1 FROM NM_INV_THEMES
     WHERE nith_nth_theme_id = c_nth
       AND EXISTS
           (SELECT 1 FROM NM_INV_TYPES
             WHERE nit_inv_type = nith_nit_id
               AND nit_table_name IS NOT NULL);
BEGIN
  OPEN  c1( p_theme );
  FETCH c1 INTO dummy;
  retval := c1%FOUND;
  CLOSE c1;
  RETURN retval;
END is_ft_inventory;
--
-----------------------------------------------------------------------------
--
FUNCTION is_xy_inventory( p_theme IN NM_THEMES_ALL.nth_theme_id%TYPE )
  RETURN BOOLEAN
IS
  --
  dummy  NUMBER;
  retval BOOLEAN := FALSE;
  --
  CURSOR c1 ( c_nth IN NM_THEMES_ALL.nth_theme_id%TYPE)
  IS
    SELECT 1 FROM NM_INV_THEMES
     WHERE nith_nth_theme_id = c_nth
       AND EXISTS
         (SELECT 1 FROM nm_inv_types
           WHERE nit_inv_type = nith_nit_id
             AND nit_use_xy = 'Y');
BEGIN
  OPEN  c1( p_theme );
  FETCH c1 INTO dummy;
  retval := c1%FOUND;
  CLOSE c1;
  RETURN retval;
END is_xy_inventory;
--
-----------------------------------------------------------------------------
--
PROCEDURE check_theme ( pi_rec_theme IN nm_themes_all%ROWTYPE )
IS
  l_rec_gt   nm_themes_all%ROWTYPE := pi_rec_theme;
BEGIN
--
  IF pi_rec_theme.nth_location_updatable = 'N'
   THEN
     RAISE l_raise_hig_151;
  END IF;
--
  IF Higgis.get_user_mode_for_theme (pi_gt_theme_id => pi_rec_theme.nth_theme_id)
     != Nm3type.c_normal
   THEN
     Hig.raise_ner (pi_appl               => Nm3type.c_hig
                   ,pi_id                 => 85
                   ,pi_supplementary_info => l_rec_gt.nth_theme_name
                   );
  END IF;
--
END check_theme;
--
-----------------------------------------------------------------------------
--
FUNCTION get_theme_gtype ( pi_theme_id IN NUMBER )
  RETURN NUMBER
IS
  retval NUMBER;
BEGIN
  SELECT MAX(ntg_gtype)
    INTO retval
    FROM NM_THEME_GTYPES
   WHERE ntg_theme_id = pi_theme_id;
  RETURN retval;
EXCEPTION
  WHEN OTHERS THEN RETURN NULL;
END get_theme_gtype;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_asset_from_shape
            ( pi_item_id        IN NUMBER
            , pi_theme_rec      IN nm_themes_all%ROWTYPE
            , pi_effective_date IN DATE
            , pi_shape          IN mdsys.sdo_geometry )
IS
  l_rec_iit  nm_inv_items%ROWTYPE;
  l_rec_nit  nm_inv_types%ROWTYPE;
  b_ft_asset BOOLEAN := FALSE;
  b_located  BOOLEAN := FALSE;
--
-- AE Task 
-- Round the asset attributes
  TYPE tab_ita IS TABLE OF nm_inv_type_attribs%ROWTYPE INDEX BY BINARY_INTEGER;
  l_tab_ita    tab_ita; 
--/ AE Task
--
  CURSOR get_asset_type ( cp_theme_id IN nm_themes_all.nth_theme_id%TYPE)
  IS
    SELECT DISTINCT(nith_nit_id)
      FROM nm_inv_themes
     WHERE nith_nth_theme_id = cp_theme_id ;
--
  CURSOR check_ft (cp_inv_type IN VARCHAR2)
  IS
    SELECT 1 FROM nm_inv_types
     WHERE nit_table_name IS NOT NULL
       AND EXISTS
         (SELECT 1 FROM nm_inv_themes
           WHERE nith_nit_id = nit_inv_type
             AND nith_nit_id = cp_inv_type
             AND EXISTS
                (SELECT 1 FROM nm_themes_all
                  WHERE nith_nth_theme_id = nth_theme_id
                    AND nth_base_table_theme IS NULL ));
--
  CURSOR get_network_location
          (cp_inv_type IN VARCHAR2)
  IS
    /* get the first network reference until we plug in 'proper' snapping */
    SELECT nin_nw_type
      FROM nm_inv_nw
     WHERE nin_nit_inv_code = cp_inv_type
       AND ROWNUM = 1;
--
  CURSOR get_nw_base_layer
          (cp_nt_type IN VARCHAR2)
  IS
   /* this cursor only deals with datums - not group types */
    SELECT NNTH_NTH_THEME_ID
      FROM nm_linear_types, nm_nw_themes
     WHERE nlt_nt_type = cp_nt_type
       AND nlt_gty_type IS NULL
       AND nlt_g_i_d = 'D'
       AND nlt_id = nnth_nlt_id;
--
  l_inv_type                    nm_inv_types.nit_inv_type%TYPE;
  l_gtype                       nm_theme_gtypes.ntg_gtype%TYPE;
  l_geom                        mdsys.sdo_geometry;
  l_nw_type                     nm_types.nt_type%TYPE;
  l_nw_base_layer               nm_linear_types.nlt_id%TYPE;
  l_base_layer                  NUMBER;
  l_dummy                       NUMBER;
  l_lref                        nm_lref;
  l_point_xy                    BOOLEAN := FALSE;
  l_point_lref                  BOOLEAN := FALSE;
  l_point_lrefxy                BOOLEAN := FALSE;
--
BEGIN
--
--  nm_debug.debug_on;
-- Get the Asset type via NM_INV_NW
  Nm_Debug.DEBUG('Get Asset Type');
  OPEN  get_asset_type ( pi_theme_rec.nth_theme_id );
  FETCH get_asset_type INTO l_inv_type;
  --
  IF get_asset_type%NOTFOUND
  THEN
    RAISE_APPLICATION_ERROR (-20002,'Could not derive Asset type using nm_inv_themes');
  END IF;
  --
  CLOSE get_asset_type;
--
-- Is the Asset a foreign table
  Nm_Debug.DEBUG('Check for FT');
  OPEN  check_ft ( l_inv_type );
  FETCH check_ft INTO l_dummy;
  --
  IF check_ft%FOUND
  THEN
    b_ft_asset := TRUE;
  END IF;
  --
  CLOSE check_ft;
--
-- Get network location if there is one
  Nm_Debug.DEBUG('Get Network Type');
  OPEN  get_network_location ( l_inv_type );
  FETCH get_network_location INTO l_nw_type;
  CLOSE get_network_location;
  --
  IF l_nw_type IS NOT NULL
  THEN
    -- Get the base NW layer to snap to
    Nm_Debug.DEBUG('Get Network Type Layer');
    OPEN  get_nw_base_layer ( l_nw_type);
    FETCH get_nw_base_layer INTO l_nw_base_layer;
    CLOSE get_nw_base_layer;
    --
    IF l_nw_base_layer IS NOT NULL
    THEN
      b_located := TRUE;
    END IF;
    --
  --
  END IF;
--
  l_point_xy     := ( pi_theme_rec.nth_x_column         IS NOT NULL
                  AND pi_theme_rec.nth_y_column         IS NOT NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS     NULL
                  AND pi_theme_rec.nth_st_chain_column  IS     NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
  l_point_lref   := ( pi_theme_rec.nth_x_column         IS     NULL
                  AND pi_theme_rec.nth_y_column         IS     NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS NOT NULL
                  AND pi_theme_rec.nth_st_chain_column  IS NOT NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
  l_point_lrefxy := ( pi_theme_rec.nth_x_column         IS NOT NULL
                  AND pi_theme_rec.nth_y_column         IS NOT NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS NOT NULL
                  AND pi_theme_rec.nth_st_chain_column  IS NOT NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
-- Get inv type record
  l_rec_nit := Nm3get.get_nit ( pi_nit_inv_type => l_inv_type );

-- AE Task 0108730
-- Round the vertices on the shape

  l_geom   := pi_shape;

  DECLARE
    l_x_dp  nm_inv_type_attribs.ita_dec_places%TYPE;
    l_y_dp  nm_inv_type_attribs.ita_dec_places%TYPE;
  BEGIN
  --
    IF l_rec_nit.nit_use_xy = 'Y'
    -- Task 0108875
    -- Correction to 0108730
    -- Make sure it's a point shape before doing any rounding
    AND l_geom.sdo_gtype = 2001
    THEN
    --
      SELECT * BULK COLLECT INTO l_tab_ita
        FROM nm_inv_type_attribs
       WHERE ita_inv_type = l_rec_nit.nit_inv_type;
    --
      IF l_tab_ita.COUNT > 0
      THEN
      --
        FOR i IN 1..l_tab_ita.COUNT
        LOOP
        --
          IF l_tab_ita(i).ita_attrib_name = 'IIT_X'
          AND l_tab_ita(i).ita_dec_places IS NOT NULL
          THEN
            l_x_dp := l_tab_ita(i).ita_dec_places;
          END IF;
        --
          IF l_tab_ita(i).ita_attrib_name = 'IIT_Y'
          AND l_tab_ita(i).ita_dec_places IS NOT NULL
          THEN
            l_y_dp := l_tab_ita(i).ita_dec_places;
          END IF;
        --
        END LOOP;
      --
      END IF;
--  --
--    nm_debug.debug_on;
--    nm_debug.debug('Setting X and Y to - '||ROUND (l_geom.sdo_point.x,l_x_dp)||' : '||ROUND (l_geom.sdo_point.y,l_y_dp));
  --
  -- set the srid
      l_geom := Nm3sdo.get_2d_pt(l_geom);
    --
      IF l_x_dp IS NOT NULL
      THEN
        l_geom.sdo_point.x := ROUND (l_geom.sdo_point.x,l_x_dp);
      END IF;
    --
      IF l_y_dp IS NOT NULL
      THEN
        l_geom.sdo_point.y := ROUND (l_geom.sdo_point.y,l_y_dp);
      END IF;
    --
    END IF;
  --
  END;

-- / AE Task 0108730 finished.
--
  IF pi_theme_rec.nth_dependency = 'I'
  THEN
  --
    Nm_Debug.DEBUG('Independant layer');
    l_gtype  := get_theme_gtype ( pi_theme_rec.nth_theme_id );
  -- nm_theme_gtypes
    IF l_gtype IS NOT NULL
    THEN
      Nm_Debug.DEBUG('SM bug check');
      IF  Nm3sdo.get_dim_from_gtype(l_gtype) = 2
      AND Nm3sdo.get_dim_from_gtype(pi_shape.sdo_gtype) = 3
        THEN
          --l_geom := sdo_lrs.convert_to_std_geom(pi_geom);
          -- SM BUG!!
          l_geom.sdo_gtype := 2002;
      END IF;
    END IF;
  --
    -- Don't try and update shape if Asset is flagged as 'USE XY'
    -- The trigger on nm_inv_items_all will take care of the shape
    -- so we just directly update nm_inv_items_all later in this block
    IF l_rec_nit.nit_use_xy = 'N'
    OR (l_rec_nit.nit_use_xy = 'Y' AND l_geom.sdo_gtype != 2001)
      THEN
      Nm_Debug.DEBUG('Reshaping '||l_geom.sdo_gtype);
      Nm3sdo_Edit.move_reshape
         ( pi_nth_id => pi_theme_rec.nth_theme_id
         , pi_pk     => pi_item_id
         , pi_shape  => l_geom
         , pi_date   => pi_effective_date
         );
      Nm_Debug.DEBUG('Move reshape done');
    END IF;

    IF NOT b_located
    THEN
      -- update xy values on theme table from sdo_point array
      IF l_rec_nit.nit_use_xy = 'Y'
      AND l_geom.sdo_gtype = 2001
      THEN
        Nm3sdo_Edit.update_xy
           ( pi_table_name => c_asset_table
           , pi_pk_column  => pi_theme_rec.nth_pk_column
           , pi_x_column   => 'IIT_X'
           , pi_y_column   => 'IIT_Y'
           , pi_pk_value   => pi_item_id
           , pi_x_value    => l_geom.sdo_point.x
           , pi_y_value    => l_geom.sdo_point.y
           );
      ELSIF l_rec_nit.nit_use_xy = 'N'
      AND l_point_xy
      THEN
        Nm3sdo_Edit.update_xy
           ( pi_table_name => pi_theme_rec.nth_table_name
           , pi_pk_column  => pi_theme_rec.nth_pk_column
           , pi_x_column   => pi_theme_rec.nth_x_column
           , pi_y_column   => pi_theme_rec.nth_y_column
           , pi_pk_value   => pi_item_id
           , pi_x_value    => l_geom.sdo_point.x
           , pi_y_value    => l_geom.sdo_point.y
           );
      END IF;
    --
    ELSIF b_located
    THEN
    --
      IF l_rec_nit.nit_use_xy = 'Y'
      AND l_geom.sdo_gtype = 2001
      THEN
        Nm3sdo_Edit.update_xy
          ( pi_table_name => c_asset_table
          , pi_pk_column  => pi_theme_rec.nth_pk_column
          , pi_x_column   => 'IIT_X'
          , pi_y_column   => 'IIT_Y'
          , pi_pk_value   => pi_item_id
          , pi_x_value    => l_geom.sdo_point.x
          , pi_y_value    => l_geom.sdo_point.y );

      --
      ELSIF l_rec_nit.nit_use_xy = 'N'
      AND   l_point_lrefxy
      AND   l_geom.sdo_gtype = 2001
      THEN
      --
      -- RAC 
      -- Is this correct - the if statement suggest that this portion of code 
      -- should not be used if the asset is driven by XY. So, the layer
      -- shape may be generated by dyn-seg. So why does it update the geometry.
      --<RAC - 3.2.1.1
        l_lref := Nm3sdo.get_nearest_lref( pi_theme_rec.nth_theme_id, l_geom );
      --RAC>

        -- update table with geometry ordinates
        Nm3sdo_Edit.update_point_lref
          ( pi_table_name => pi_theme_rec.nth_table_name
          , pi_pk_column  => pi_theme_rec.nth_pk_column
          , pi_rse_column => pi_theme_rec.nth_rse_fk_column
          , pi_st_chain   => pi_theme_rec.nth_st_chain_column
          , pi_lref_value => l_lref
          , pi_pk_value   => pi_item_id
          );

        -- update xy values on theme table from sdo_point array
        Nm3sdo_Edit.update_xy
          ( pi_table_name => pi_theme_rec.nth_table_name
          , pi_pk_column  => pi_theme_rec.nth_pk_column
          , pi_x_column   => pi_theme_rec.nth_x_column
          , pi_y_column   => pi_theme_rec.nth_y_column
          , pi_pk_value   => pi_item_id
          , pi_x_value    => l_geom.sdo_point.x
          , pi_y_value    => l_geom.sdo_point.y
          );

      END IF;

    END IF;

  ELSE
    RAISE_APPLICATION_ERROR (-20001, 'Theme must be independant of network');
  END IF;
  Nm_Debug.DEBUG('Finished process_asset_from_shape');
END process_asset_from_shape;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_other_from_shape
            ( pi_item_id        IN NUMBER
            , pi_theme_rec      IN nm_themes_all%ROWTYPE
            , pi_effective_date IN DATE
            , pi_shape          IN mdsys.sdo_geometry )
IS
  l_point_xy                    BOOLEAN := FALSE;
  l_point_lref                  BOOLEAN := FALSE;
  l_point_lrefxy                BOOLEAN := FALSE;
  l_geom                        mdsys.sdo_geometry;
  l_gtype                       nm_theme_gtypes.ntg_gtype%TYPE;
  l_lref                        nm_lref;
--
BEGIN
--
  l_point_xy     := ( pi_theme_rec.nth_x_column         IS NOT NULL
                  AND pi_theme_rec.nth_y_column         IS NOT NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS     NULL
                  AND pi_theme_rec.nth_st_chain_column  IS     NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
  l_point_lref   := ( pi_theme_rec.nth_x_column         IS     NULL
                  AND pi_theme_rec.nth_y_column         IS     NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS NOT NULL
                  AND pi_theme_rec.nth_st_chain_column  IS NOT NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
  l_point_lrefxy := ( pi_theme_rec.nth_x_column         IS NOT NULL
                  AND pi_theme_rec.nth_y_column         IS NOT NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS NOT NULL
                  AND pi_theme_rec.nth_st_chain_column  IS NOT NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
  l_gtype := get_theme_gtype ( pi_theme_rec.nth_theme_id );
  l_geom  := pi_shape;

  IF l_gtype IS NOT NULL
  THEN
    IF Nm3sdo.get_dim_from_gtype(l_gtype) = 2
    AND Nm3sdo.get_dim_from_gtype(pi_shape.sdo_gtype) = 3
      THEN
        --l_geom := sdo_lrs.convert_to_std_geom(pi_geom);
        -- SM BUG!!
        l_geom.sdo_gtype := 2002;
    END IF;
  END IF;
--
  Nm3sdo_Edit.move_reshape
    ( pi_nth_id => pi_theme_rec.nth_theme_id
    , pi_pk     => pi_item_id
    , pi_shape  => pi_shape
    , pi_date   => pi_effective_date );
--
  IF  l_point_lref
  THEN

    -- convert to use sdo_point array instead of sdo_ordinate array for xys
    l_geom := Nm3sdo.get_2d_pt(pi_shape);

    --<RAC - 3.2.1.1
    l_lref := Nm3sdo.get_nearest_lref( pi_theme_rec.nth_theme_id, l_geom );
    --RAC>

      -- update table with geometry ordinates
    Nm3sdo_Edit.update_point_lref
      ( pi_table_name => pi_theme_rec.nth_table_name
      , pi_pk_column  => pi_theme_rec.nth_pk_column
      , pi_rse_column => pi_theme_rec.nth_rse_fk_column
      , pi_st_chain   => pi_theme_rec.nth_st_chain_column
      , pi_lref_value => l_lref
      , pi_pk_value   => pi_item_id );

  ELSIF l_point_xy
  THEN

    -- convert to use sdo_point array instead of sdo_ordinate array for xys
    l_geom := Nm3sdo.get_2d_pt(pi_shape);
    -- update xy values on theme table from sdo_point array
    Nm3sdo_Edit.update_xy
     ( pi_table_name => pi_theme_rec.nth_table_name
     , pi_pk_column  => pi_theme_rec.nth_pk_column
     , pi_x_column   => pi_theme_rec.nth_x_column
     , pi_y_column   => pi_theme_rec.nth_y_column
     , pi_pk_value   => pi_item_id
     , pi_x_value    => l_geom.sdo_point.x
     , pi_y_value    => l_geom.sdo_point.y
     );

 ELSIF l_point_lrefxy
  THEN

    -- convert to use sdo_point array instead of sdo_ordinate array for xys
    l_geom := Nm3sdo.get_2d_pt(pi_shape);

    -- derive lref first

    --<RAC - 3.2.1.1
    l_lref := Nm3sdo.get_nearest_lref( pi_theme_rec.nth_theme_id, l_geom );
    --RAC>

    -- update table with geometry ordinates
    Nm3sdo_Edit.update_point_lref
      ( pi_table_name => pi_theme_rec.nth_table_name
      , pi_pk_column  => pi_theme_rec.nth_pk_column
      , pi_rse_column => pi_theme_rec.nth_rse_fk_column
      , pi_st_chain   => pi_theme_rec.nth_st_chain_column
      , pi_lref_value => l_lref
      , pi_pk_value   => pi_item_id
      );

      -- update xy values on theme table from sdo_point array
    Nm3sdo_Edit.update_xy
      ( pi_table_name => pi_theme_rec.nth_table_name
      , pi_pk_column  => pi_theme_rec.nth_pk_column
      , pi_x_column   => pi_theme_rec.nth_x_column
      , pi_y_column   => pi_theme_rec.nth_y_column
      , pi_pk_value   => pi_item_id
      , pi_x_value    => l_geom.sdo_point.x
      , pi_y_value    => l_geom.sdo_point.y
      );

  END IF;
--
END process_other_from_shape;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_located_item
         ( pi_item_id                 IN NUMBER
         , pi_start_ne_id             IN nm_elements.ne_id%TYPE
         , pi_route_ne_id             IN nm_elements.ne_id%TYPE
         , pi_end_ne_id               IN nm_elements.ne_id%TYPE
         , pi_start_offset            IN NUMBER
         , pi_end_offset              IN NUMBER
         , pi_sub_class               IN nm_elements.ne_sub_class%TYPE
         , pi_restrict_excl_sub_class IN VARCHAR2
         , pi_item_is_asset           IN BOOLEAN )
IS
   l_location_is_datum           BOOLEAN := FALSE;
BEGIN
  IF  pi_route_ne_id IS NULL
  AND pi_end_ne_id   IS NULL
  AND pi_end_offset  IS NULL
  THEN
  /* ===========================================
     Derived to be a point item - create extent
    ============================================
  */
    Nm3extent.create_temp_ne (pi_source_id                 => pi_start_ne_id
                             ,pi_source                    => Nm3extent.c_route
                             ,pi_begin_mp                  => pi_start_offset
                             ,pi_end_mp                    => pi_start_offset
                             ,po_job_id                    => g_nte_job_id
                             ,pi_default_source_as_parent  => TRUE
                             ,pi_ignore_non_linear_parents => TRUE
                             );
  ELSE
   /* ================================================
      Derived to be a continuous item - create extent
     =================================================
     -- RAC
     -- The route may be a datum, if so use the create_temp_ne directly
     -- from the nm3extent package - no need for
     -- complex connectivity logic such as sub-class etc.
   */

    l_location_is_datum := FALSE;

    IF pi_route_ne_id IS NULL
    THEN
      l_location_is_datum := TRUE;
    ELSE
      IF Nm3net.is_nt_datum( Nm3get.get_ne( pi_route_ne_id ).ne_nt_type ) = 'Y'
      THEN
        l_location_is_datum := TRUE;
      END IF;
    END IF;

    IF l_location_is_datum
    THEN
      IF pi_start_ne_id = pi_end_ne_id
      THEN
        Nm3extent.create_temp_ne
          ( pi_start_ne_id
          , Nm3extent.c_route
          , pi_start_offset
          , pi_end_offset
          , g_nte_job_id );
      ELSE
        --raise_application_error(-20001, 'No path through distinct datums');
        Hig.raise_ner (pi_appl               => Nm3type.c_net
                      ,pi_id                 => 421
                      );
      END IF;
    ELSE
      Nm3wrap.create_temp_ne_from_route
        ( pi_route                   => pi_route_ne_id
        , pi_start_ne_id             => pi_start_ne_id
        , pi_start_offset            => pi_start_offset
        , pi_end_ne_id               => pi_end_ne_id
        , pi_end_offset              => pi_end_offset
        , pi_sub_class               => pi_sub_class
        , pi_restrict_excl_sub_class => pi_restrict_excl_sub_class
        , pi_homo_check              => pi_item_is_asset
        , po_job_id                  => g_nte_job_id );
    END IF;
  END IF;
END process_located_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_homo_relocate
            ( pi_item_id        IN NUMBER
            , pi_start_ne_id    IN NUMBER
            , pi_nth_theme_id   IN nm_themes_all.nth_theme_id%TYPE
            , pi_effective_date IN DATE )
IS
  l_iit_rec       nm_inv_items_all%ROWTYPE;
  l_temp          NUMBER;
  l_warning_code  NUMBER;
  l_warning_msg   VARCHAR2(250);
  --
  FUNCTION is_ft_asset
             ( pi_theme_id IN NUMBER )
    RETURN BOOLEAN
  IS
    CURSOR c1 (cp_theme_id IN NUMBER)
    IS
      SELECT 1 FROM nm_inv_themes
       WHERE nith_nth_theme_id = cp_theme_id
         AND EXISTS
              (SELECT 1 FROM nm_inv_types
                WHERE nith_nit_id = nit_inv_type
                  AND nit_table_name IS NOT NULL);
  BEGIN
    OPEN  c1 (pi_theme_id);
    FETCH c1 INTO l_temp;
    IF c1%FOUND
    THEN
      CLOSE c1;
      RETURN TRUE;
    ELSE
      CLOSE c1;
      RETURN FALSE;
    END IF;
  END is_ft_asset;
--
BEGIN
--
  -- check to see if FT inventory first.
  IF NOT is_ft_asset ( pi_nth_theme_id )
  THEN
    l_iit_rec := Nm3get.get_iit(pi_iit_ne_id => pi_item_id);
  END IF;
--
  IF pi_start_ne_id IS NOT NULL
  THEN
  
  Nm_Debug.DEBUG('homo-update - '||TO_CHAR( g_nte_job_id ));
  
  
    Nm3homo.homo_update (p_temp_ne_id_in  => g_nte_job_id
                        ,p_iit_ne_id      => pi_item_id
                        ,p_effective_date => pi_effective_date);

  ELSE
    --no network location specified
    --check if location is mandatory
    IF Nm3inv.inv_location_is_mandatory(pi_inv_type => l_iit_rec.iit_inv_type)
    THEN
      RAISE e_no_network_for_mand_loc_inv;
    END IF;

    --end date current location
    Nm3homo.end_inv_location(pi_iit_ne_id      => pi_item_id
                            ,pi_effective_date => pi_effective_date
                            ,po_warning_code   => l_warning_code
                            ,po_warning_msg    => l_warning_msg);

  END IF;
--
END process_homo_relocate;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_snap_from_xy
            ( pi_theme_rec      IN nm_themes_all%ROWTYPE
            , pi_item_id        IN NUMBER
            , pi_x_pos          IN NUMBER
            , pi_y_pos          IN NUMBER
            , pi_effective_date IN DATE )
IS
  l_base_table_nth    nm_themes_all%ROWTYPE;
  l_rec_gt            nm_themes_all%ROWTYPE := pi_theme_rec;
  l_xy_table_name     VARCHAR2(30);
  l_xy_column_name    VARCHAR2(30);
  l_lref              nm_lref;
  l_point_xy          BOOLEAN;
  l_point_lref        BOOLEAN;
  l_point_lrefxy      BOOLEAN;
--
BEGIN
--
  l_point_xy     := ( pi_theme_rec.nth_x_column         IS NOT NULL
                  AND pi_theme_rec.nth_y_column         IS NOT NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS     NULL
                  AND pi_theme_rec.nth_st_chain_column  IS     NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
  l_point_lref   := ( pi_theme_rec.nth_x_column         IS     NULL
                  AND pi_theme_rec.nth_y_column         IS     NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS NOT NULL
                  AND pi_theme_rec.nth_st_chain_column  IS NOT NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
  l_point_lrefxy := ( pi_theme_rec.nth_x_column         IS NOT NULL
                  AND pi_theme_rec.nth_y_column         IS NOT NULL
                  AND pi_theme_rec.nth_rse_fk_column    IS NOT NULL
                  AND pi_theme_rec.nth_st_chain_column  IS NOT NULL
                  AND pi_theme_rec.nth_end_chain_column IS     NULL);
--
/* =====================================================================
    Derive XY table directly from Theme record. If base_theme is
    set then we must be updating a view, so use base table name/columns
   =====================================================================
*/
  IF l_rec_gt.nth_base_table_theme IS NOT NULL
  THEN
    l_base_table_nth :=  Nm3get.get_nth
                          ( pi_nth_theme_id => l_rec_gt.nth_base_table_theme );
    l_xy_table_name  := l_base_table_nth.nth_table_name;
    l_xy_column_name := l_base_table_nth.nth_pk_column;
  ELSE
    l_xy_table_name  := l_rec_gt.nth_table_name;
    l_xy_column_name := l_rec_gt.nth_pk_column;
  END IF;

/* ==============================================================
   If theme x,y columns are supplied, but don't exist, use the
   x,y columns defined on the Inventory type - which may not be
   used for xy storage, but better than nothing..!
   ==============================================================
*/
--
  IF    l_rec_gt.nth_x_column IS NOT NULL
    AND l_rec_gt.nth_y_column IS NOT NULL
  THEN
    IF NOT column_exists ( l_xy_table_name,l_rec_gt.nth_x_column )
       AND is_inventory ( l_rec_gt.nth_theme_id )
       AND NOT is_ft_inventory ( l_rec_gt.nth_theme_id )
    THEN
      l_rec_gt.nth_x_column
           := Nm3get.get_ita
                ( pi_ita_inv_type      => Nm3get.get_iit(pi_iit_ne_id => pi_item_id).iit_inv_type
                , pi_ita_view_col_name => l_rec_gt.nth_x_column ).ita_attrib_name;
    END IF;

    IF NOT column_exists (l_xy_table_name,l_rec_gt.nth_y_column)
       AND is_inventory ( l_rec_gt.nth_theme_id )
       AND NOT is_ft_inventory ( l_rec_gt.nth_theme_id )
    THEN
      l_rec_gt.nth_y_column
           := Nm3get.get_ita
                ( pi_ita_inv_type      => Nm3get.get_iit(pi_iit_ne_id => pi_item_id).iit_inv_type
                , pi_ita_view_col_name => l_rec_gt.nth_y_column).ita_attrib_name;
    END IF;
  END IF;
--
  IF   l_rec_gt.nth_x_column IS NOT NULL
  AND  l_rec_gt.nth_y_column IS NOT NULL
  THEN
    IF  NOT column_exists (l_xy_table_name,l_rec_gt.nth_x_column)
     OR NOT column_exists (l_xy_table_name,l_rec_gt.nth_y_column)
     THEN
       Hig.raise_ner (pi_appl               => Nm3type.c_net
                     ,pi_id                 => 223
                     ,pi_supplementary_info => l_xy_table_name||' - nth_x_column="'||
                                               l_rec_gt.nth_x_column||'";nth_y_column="'||
                                               l_rec_gt.nth_y_column
                     );
    END IF;
  END IF;
--
  IF l_point_xy
  THEN

     Nm3sdo_Edit.update_xy
      ( pi_table_name => l_xy_table_name
      , pi_pk_column  => l_xy_column_name
      , pi_x_column   => l_rec_gt.nth_x_column
      , pi_y_column   => l_rec_gt.nth_y_column
      , pi_pk_value   => pi_item_id
      , pi_x_value    => pi_x_pos
      , pi_y_value    => pi_y_pos
      );

  ELSIF l_point_lref
   THEN

    --<RAC - 3.2.1.1
    l_lref := Nm3sdo.get_nearest_lref( l_rec_gt.nth_theme_id, Nm3sdo.get_2d_pt( pi_x_pos, pi_y_pos ));
    --RAC>

    Nm3sdo_Edit.update_point_lref
      ( pi_table_name => l_xy_table_name
      , pi_pk_column  => l_xy_column_name
      , pi_rse_column => l_rec_gt.nth_rse_fk_column
      , pi_st_chain   => l_rec_gt.nth_st_chain_column
      , pi_lref_value => l_lref
      , pi_pk_value   => pi_item_id
      );
  --
  END IF;
--
END process_snap_from_xy;
--
-----------------------------------------------------------------------------
--
PROCEDURE exec_other_product (p_pack_proc VARCHAR2) IS
BEGIN
   EXECUTE IMMEDIATE 'BEGIN'
          ||CHR(10)||'   '||p_pack_proc
          ||CHR(10)||'         ('||g_package_name||'.g_item_id'
          ||CHR(10)||'         ,'||g_package_name||'.g_nte_job_id'
          ||CHR(10)||'         ,'||g_package_name||'.g_effective_date'
          ||CHR(10)||'         );'
          ||CHR(10)||'END;';
END exec_other_product;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item
 ( pi_gt_theme_id             IN NM_THEMES_ALL.nth_theme_id%TYPE
 , pi_item_id                 IN NUMBER
 , pi_route_ne_id             IN nm_elements.ne_id%TYPE        DEFAULT NULL
 , pi_start_ne_id             IN nm_elements.ne_id%TYPE
 , pi_start_offset            IN NUMBER
 , pi_end_ne_id               IN nm_elements.ne_id%TYPE        DEFAULT NULL
 , pi_end_offset              IN NUMBER                        DEFAULT NULL
 , pi_sub_class               IN nm_elements.ne_sub_class%TYPE DEFAULT NULL
 , pi_restrict_excl_sub_class IN VARCHAR2                      DEFAULT NULL
 , pi_x_pos                   IN NUMBER                        DEFAULT NULL
 , pi_y_pos                   IN NUMBER                        DEFAULT NULL
 , pi_effective_date          IN DATE                          DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
 , pi_geom                    IN MDSYS.SDO_GEOMETRY            DEFAULT NULL
 ) IS

--
   c_init_eff_date               CONSTANT DATE := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_item_is_inventory           BOOLEAN;
   l_item_is_inv_xy              BOOLEAN;
   l_network_location            BOOLEAN := TRUE;
   l_independent                 BOOLEAN;
   l_point_xy                    BOOLEAN := FALSE;
   l_point_lref                  BOOLEAN := FALSE;
   l_point_lrefxy                BOOLEAN := FALSE;
   l_snapped_from_shape          BOOLEAN := FALSE;
   l_relocated_using_homo        BOOLEAN := FALSE;
   l_location_is_datum           BOOLEAN := FALSE;
   l_xy_table_name               VARCHAR2(30);
   l_xy_column_name              VARCHAR2(30);
--
   l_rec_gt                      NM_THEMES_ALL%ROWTYPE;
   l_base_table_nth              NM_THEMES_ALL%ROWTYPE;
   l_rec_nte                     NM_NW_TEMP_EXTENTS%ROWTYPE;
   l_iit_rec                     nm_inv_items%ROWTYPE;
   l_rec_ne_start                nm_elements%ROWTYPE;
   l_rec_ne_end                  nm_elements%ROWTYPE;
   l_gtype                       NM_THEME_GTYPES.ntg_gtype%TYPE;
--
   l_lref                        nm_lref;
   l_geom                        mdsys.sdo_geometry;
   l_warning_code                Nm3type.max_varchar2;
   l_warning_msg                 Nm3type.max_varchar2;
--
   l_geom_validation_message     Nm3type.max_varchar2;
--
BEGIN
--
--  nm_debug.debug_on;
   Nm_Debug.proc_start(g_package_name,'locate_item');
--
   Nm3user.set_effective_date (pi_effective_date);
--
--rc - add the srid because sm can't be bothered to do it.
   l_geom := pi_geom;

   IF l_geom IS NOT NULL THEN
     l_geom := Nm3sdo.set_srid( pi_gt_theme_id, l_geom );
   END IF;     

   l_rec_gt := Nm3get.get_nth (pi_nth_theme_id => pi_gt_theme_id);
--
-- Validate the theme first
   check_theme ( pi_rec_theme => l_rec_gt );

-- Set Asset flags
   l_item_is_inventory := is_inventory    ( l_rec_gt.nth_theme_id );
   l_item_is_inv_xy    := is_xy_inventory ( l_rec_gt.nth_theme_id );
--
   IF l_item_is_inventory
   THEN
     IF l_geom IS NOT NULL
     THEN
         -- Off Network Asset update
         process_asset_from_shape
           ( pi_item_id        => pi_item_id
           , pi_theme_rec      => l_rec_gt
           , pi_effective_date => pi_effective_date
           , pi_shape          => l_geom );

         l_snapped_from_shape := TRUE;

     ELSIF l_geom IS NULL
     AND pi_start_ne_id IS NOT NULL
     THEN
       -- Dynseg asset update
       Nm_Debug.DEBUG( 'locate by ne_id '||TO_CHAR( pi_start_ne_id ) );
       process_located_item
         ( pi_item_id                 => pi_item_id
         , pi_start_ne_id             => pi_start_ne_id
         , pi_route_ne_id             => pi_route_ne_id
         , pi_end_ne_id               => pi_end_ne_id
         , pi_start_offset            => pi_start_offset
         , pi_end_offset              => pi_end_offset
         , pi_sub_class               => pi_sub_class
         , pi_restrict_excl_sub_class => pi_restrict_excl_sub_class
         , pi_item_is_asset           => l_item_is_inventory );

       process_homo_relocate
         ( pi_item_id        => pi_item_id
         , pi_start_ne_id    => pi_start_ne_id
         , pi_nth_theme_id   => l_rec_gt.nth_theme_id
         , pi_effective_date => pi_effective_date );

       l_relocated_using_homo := TRUE;
     END IF;
  --
   ELSIF l_geom IS NOT NULL
     THEN
     l_geom_validation_message := Nm3sdo_Edit.validate_geometry(l_rec_gt.nth_theme_id, l_geom);

     IF l_geom_validation_message = Nm3type.c_true
       THEN
       process_other_from_shape
         ( pi_item_id        => pi_item_id
         , pi_theme_rec      => l_rec_gt
         , pi_effective_date => pi_effective_date
         , pi_shape          => l_geom );
       l_snapped_from_shape := TRUE;
     ELSE
       RAISE_APPLICATION_ERROR (-20010,l_geom_validation_message);
     END IF;
  --
   END IF;
--
  IF l_rec_gt.nth_hpr_product = Nm3type.c_acc
  AND  Hig.is_product_licensed (Nm3type.c_acc)
  THEN
    -- This is accidents and acc is licensed
    exec_other_product ('accloc.locate_acc_by_nte');
  END IF;
--
   g_item_id           := pi_item_id;
   g_effective_date    := pi_effective_date;
   g_x_pos             := pi_x_pos;
   g_y_pos             := pi_y_pos;
--
  IF   NOT l_snapped_from_shape
   AND NOT l_relocated_using_homo
   AND pi_x_pos IS NOT NULL
   AND pi_y_pos IS NOT NULL
    THEN
     process_snap_from_xy
       ( pi_theme_rec      => l_rec_gt
       , pi_item_id        => pi_item_id
       , pi_x_pos          => pi_x_pos
       , pi_y_pos          => pi_y_pos
       , pi_effective_date => pi_effective_date );

  END IF;
--
   Nm3user.set_effective_date (c_init_eff_date);
--
   Nm_Debug.proc_end(g_package_name,'locate_item');
--
EXCEPTION
--
  WHEN l_raise_hig_151
   THEN
     Nm3user.set_effective_date (c_init_eff_date);
     Hig.raise_ner (pi_appl               => Nm3type.c_hig
                   ,pi_id                 => 151
                   ,pi_supplementary_info => l_rec_gt.nth_theme_name
                   );

  WHEN l_raise_hig_152
   THEN
     Nm3user.set_effective_date (c_init_eff_date);
     Hig.raise_ner (pi_appl               => Nm3type.c_hig
                   ,pi_id                 => 152
                   ,pi_supplementary_info => l_rec_gt.nth_hpr_product
                   );

  WHEN e_no_network_for_mand_loc_inv
   THEN
     Nm3user.set_effective_date(c_init_eff_date);
     Hig.raise_ner (pi_appl => Nm3type.c_net
                    ,pi_id   => 344);
  WHEN e_homo_xy_update
   THEN
     Nm3user.set_effective_date(c_init_eff_date);
     RAISE;
  WHEN OTHERS
   THEN
     Nm3user.set_effective_date (c_init_eff_date);
     RAISE;
--
END locate_item;

-----------------------------------------------------------------------------
--
--   nm_debug.debug('<nm3homo_gis.locate_item Parameters>');
--   nm_debug.debug('pi_gt_theme_id     : '||pi_gt_theme_id);
--   nm_debug.debug('pi_item_id         : '||pi_item_id);
--   nm_debug.debug('pi_route_ne_id     : '||pi_route_ne_id);
--   nm_debug.debug(' - route_ne_unique : '||nm3net.get_ne_unique(pi_route_ne_id));
--   nm_debug.debug('pi_start_ne_id     : '||pi_start_ne_id);
--   nm_debug.debug(' - start_ne_unique : '||nm3net.get_ne_unique(pi_start_ne_id));
--   nm_debug.debug('pi_start_offset    : '||pi_start_offset);
--   nm_debug.debug('pi_end_ne_id       : '||pi_end_ne_id);
--   nm_debug.debug(' - end_ne_unique   : '||nm3net.get_ne_unique(pi_end_ne_id));
--   nm_debug.debug('pi_end_offset      : '||pi_end_offset);
--   nm_debug.debug('pi_x_pos           : '||pi_x_pos);
--   nm_debug.debug('pi_y_pos           : '||pi_y_pos);
--   nm_debug.debug('pi_effective_date  : '||pi_effective_date);
--   nm_debug.debug('</nm3homo_gis.locate_item Parameters>');
--
-----------------------------------------------------------------------------
--

PROCEDURE create_members_from_xy( pi_theme_id  IN nm_themes_all.nth_theme_id%TYPE,
                                  pi_iit_ne_id IN nm_members.nm_ne_id_in%TYPE,
								  pi_start_date  IN nm_members.nm_start_date%TYPE,
								  pi_x_st      IN NUMBER,
								  pi_y_st      IN NUMBER,
								  pi_x_end     IN NUMBER,
								  pi_y_end     IN NUMBER ) IS

l_pl   nm_placement_array;
l_nte  nm_nw_temp_extents.nte_job_id%TYPE;
BEGIN

--nm_debug.debug('start');


  l_pl := nm_placement_array( nm_placement_array_type( nm_placement(NULL, NULL, NULL, NULL)));
  l_pl := Nm_Cncts.get_pl_by_xy( pi_theme_id, pi_x_st, pi_y_st, pi_x_end, pi_y_end,'N' );

  IF NOT l_pl.Is_Empty THEN
  
--nm_debug.debug('creating temp ne');

    Nm3extent_O.create_temp_ne_from_pl(
                  pi_pl_arr => l_pl
                 ,po_job_id => l_nte );

--nm_debug.debug('running homo_update '||l_nte);

    Nm3homo.homo_update( p_temp_ne_id_in  => l_nte
                        ,p_iit_ne_id      => pi_iit_ne_id
                        ,p_effective_date => pi_start_date );

--nm_debug.debug('complete');
  ELSE

    RAISE_APPLICATION_ERROR(-20001, 'No member translation');

  END IF;


END create_members_from_xy;


END Nm3homo_Gis;
/

