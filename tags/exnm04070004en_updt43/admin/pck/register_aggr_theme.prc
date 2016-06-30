CREATE OR REPLACE PROCEDURE register_aggr_theme (
   p_inv_type   IN nm_inv_types.nit_inv_type%TYPE,
   p_role       IN nm_theme_roles.nthr_role%TYPE)
IS
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/register_aggr_theme.prc-arc   1.0   Jun 30 2016 10:44:30   Rob.Coupe  $
   --       Module Name      : $Workfile:   register_aggr_theme.prc  $
   --       Date into PVCS   : $Date:   Jun 30 2016 10:44:30  $
   --       Date fetched Out : $Modtime:   Jun 30 2016 10:42:54  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --
   --   Author : Rob Coupe
   --
   --   Procedure to register Aggregated Asset Geometry in themes and ESRI metadata.
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --
   -- aggr_theme_registration.sql

   -- The base table of geometry data must be registered as a theme in its own right:

   l_exists   INTEGER;

   l_theme    nm_themes_all.nth_theme_id%TYPE;
BEGIN
   BEGIN
      SELECT 1
        INTO l_exists
        FROM nm_inv_aggr_sdo_types
       WHERE nit_inv_type = p_inv_type;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (
            -20001,
            'Aggregated layer is not available for this inventory type');
   END;

   --
   BEGIN
      SELECT 1
        INTO l_exists
        FROM nm_themes_all
       WHERE nth_feature_table = 'NM_INV_GEOMETRY_ALL';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NM3SDO.REGISTER_SDO_TABLE_AS_THEME ('NM_INV_GEOMETRY_ALL',
                                             'AGGREGATED GEOMETRY TABLE',
                                             'ASSET_ID',
                                             NULL,
                                             'SHAPE',
                                             0.005,
                                             'N',
                                             'N',
                                             'I');
   END;

   --
   l_theme := nth_theme_id_seq.NEXTVAL;

   BEGIN
      INSERT INTO NM_THEMES_ALL (NTH_THEME_ID,
                                 NTH_THEME_NAME,
                                 NTH_TABLE_NAME,
                                 NTH_WHERE,
                                 NTH_PK_COLUMN,
                                 NTH_LABEL_COLUMN,
                                 NTH_RSE_TABLE_NAME,
                                 NTH_RSE_FK_COLUMN,
                                 NTH_ST_CHAIN_COLUMN,
                                 NTH_END_CHAIN_COLUMN,
                                 NTH_X_COLUMN,
                                 NTH_Y_COLUMN,
                                 NTH_OFFSET_FIELD,
                                 NTH_FEATURE_TABLE,
                                 NTH_FEATURE_PK_COLUMN,
                                 NTH_FEATURE_FK_COLUMN,
                                 NTH_XSP_COLUMN,
                                 NTH_FEATURE_SHAPE_COLUMN,
                                 NTH_HPR_PRODUCT,
                                 NTH_LOCATION_UPDATABLE,
                                 NTH_THEME_TYPE,
                                 NTH_DEPENDENCY,
                                 NTH_STORAGE,
                                 NTH_UPDATE_ON_EDIT,
                                 NTH_USE_HISTORY,
                                 NTH_START_DATE_COLUMN,
                                 NTH_END_DATE_COLUMN,
                                 NTH_BASE_TABLE_THEME,
                                 NTH_SEQUENCE_NAME,
                                 NTH_SNAP_TO_THEME,
                                 NTH_LREF_MANDATORY,
                                 NTH_TOLERANCE,
                                 NTH_TOL_UNITS,
                                 NTH_DYNAMIC_THEME)
         SELECT l_theme,
                'AGGREGATED ' || p_inv_type,
                'V_NM_INV_AGGR_' || p_inv_type || '_SDO',
                NULL,
                'AGGR_ASSET_ID',
                'AGGR_ASSET_ID',
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                NULL,
                'V_NM_INV_AGGR_' || p_inv_type || '_SDO',
                'AGGR_ASSET_ID',
                NULL,
                NULL,
                'AGGR_SHAPE',
                'NET',
                'N',
                'SDO',
                'D',
                'S',
                'N',
                'N',
                NULL,
                NULL,
                nth_theme_id,
                NULL,
                'N',
                'N',
                10,
                1,
                'N'
           FROM nm_themes_all
          WHERE nth_feature_table = 'NM_INV_GEOMETRY_ALL';
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX
      THEN
         raise_application_error (
            -20002,
            'Aggregated asset geometry view is already registered as a theme');
   END;

   IF NVL (hig.get_sysopt ('REGSDELAY'), 'N') = 'Y'
   THEN
      NM3SDE.register_sde_layer (l_theme);
   END IF;

   INSERT INTO nm_theme_roles
        VALUES (l_theme, p_role, 'NORMAL');

   INSERT INTO nm_inv_themes (nith_nit_id, nith_nth_theme_id)
        VALUES (p_inv_type, l_theme);
END;
/
