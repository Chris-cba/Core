CREATE OR REPLACE PACKAGE BODY nm_inv_sdo_aggr
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm_inv_sdo_aggr.pkb-arc   1.0   Apr 20 2016 15:09:26   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_inv_sdo_aggr.pkb  $
--       Date into PVCS   : $Date:   Apr 20 2016 15:09:26  $
--       Date fetched Out : $Modtime:   Apr 20 2016 15:09:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   Package for code which produces aggregated geometry for assets.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
   PROCEDURE gen_inv_aggr_sdo (
      pi_inv_type   IN     nm_inv_types.nit_inv_type%TYPE,
      po_cur           OUT VARCHAR2,
      p_limit       IN     INTEGER DEFAULT 500)
   IS
      nit_not_found     PLS_INTEGER := -20002;
      l_nit_row         nm_inv_types%ROWTYPE;

      TYPE geocurtyp IS REF CURSOR;

      geocur            geocurtyp;
      cur_string        VARCHAR2 (4000);

      l_table_name      VARCHAR2 (30);
      l_pk_column       VARCHAR2 (30);
      l_st_column       VARCHAR2 (30);
      l_end_column      VARCHAR2 (30);
      l_ne_column       VARCHAR2 (30);
      l_feature_table   VARCHAR2 (30);
      l_feature_pk      VARCHAR2 (30);
      l_feature_shape   VARCHAR2 (30);
      l_nw_type         VARCHAR2 (4);

      l_asset_id        NM3TYPE.TAB_NUMBER;
      l_asset_type      NM3TYPE.TAB_VARCHAR4;
      l_start_date      NM3TYPE.TAB_DATE;

      TYPE tab_geom IS TABLE OF MDSYS.sdo_geometry
         INDEX BY BINARY_INTEGER;

      l_geom            TAB_GEOM;

      l_geom_str        VARCHAR2 (2000);

      dml_errors        EXCEPTION;
      PRAGMA EXCEPTION_INIT (dml_errors, -24381);

      error_count       NUMBER;

      qq                VARCHAR2 (1) := CHR (39);
   BEGIN
      nm_debug.debug_on;
      l_nit_row := nm3get.get_nit (pi_inv_type, TRUE, nit_not_found);
      --
      l_table_name := NVL (l_nit_row.nit_table_name, 'NM_MEMBERS'); -- Take date tracking out for now
      l_pk_column := NVL (l_nit_row.nit_foreign_pk_column, 'NM_NE_ID_IN');
      l_st_column := NVL (l_nit_row.nit_lr_st_chain, 'NM_BEGIN_MP');
      l_end_column := NVL (l_nit_row.nit_lr_end_chain, 'NM_END_MP');
      l_ne_column := NVL (l_nit_row.nit_lr_ne_column_name, 'NM_NE_ID_OF');

      --
      SELECT nin_nw_type,
             nth_feature_table,
             nth_feature_pk_column,
             nth_feature_shape_column
        INTO l_nw_type,
             l_feature_table,
             l_feature_pk,
             l_feature_shape
        FROM nm_inv_nw,
             nm_inv_types,
             nm_linear_types,
             nm_nw_themes,
             nm_themes_all
       WHERE     nin_nit_inv_code = nit_inv_type
             AND nin_nit_inv_code = pi_inv_type
             AND nin_nw_type = nlt_nt_type
             AND nlt_g_i_d = 'D'
             AND nnth_nlt_id = nlt_id
             AND nnth_nth_theme_id = nth_theme_id
             AND nth_base_table_theme IS NULL;

      --
      l_geom_str := 'sdo_aggr_union (sdoaggrtype (shape, 0.005))';

      IF l_nit_row.nit_pnt_or_cont = 'P'
      THEN
         l_geom_str := 'shape';
      END IF;

      --
      cur_string :=
            'SELECT asset_id, asset_type, trunc(sysdate), '
         || l_geom_str
         || ' FROM (SELECT '
         || l_pk_column
         || ' asset_id, '
         || qq
         || pi_inv_type
         || qq
         || ' asset_type, '
         || '   SDO_LRS.convert_to_std_geom (SDO_LRS.clip_geom_segment ( '
         || l_feature_shape
         || ','
         || l_st_column
         || ','
         || l_end_column
         || ',0.005 )) shape '
         || ' FROM '
         || l_table_name
         || ', '
         || l_feature_table
         || ' WHERE   '
         || l_feature_pk
         || ' = '
         || l_ne_column;

      --
      IF l_nit_row.nit_table_name IS NULL
      THEN
         cur_string :=
               cur_string
            || '   AND nm_obj_type = '
            || qq
            || pi_inv_type
            || qq
            || '   AND nm_type = '
            || qq
            || 'I'
            || qq
            || ')';
      ELSE
         cur_string := cur_string || ' ) ';
      END IF;

      IF l_nit_row.nit_pnt_or_cont != 'P'
      THEN
         cur_string := cur_string || ' GROUP BY asset_id, asset_type ';
      END IF;

      nm_debug.debug (cur_string);

      DECLARE
         already_deferred   EXCEPTION;
         PRAGMA EXCEPTION_INIT (already_deferred, -29874);
      BEGIN
         EXECUTE IMMEDIATE
               'alter index nig_spidx parameters ('
            || ''''
            || 'index_status=deferred'
            || ''''
            || ')';
      EXCEPTION
         WHEN already_deferred
         THEN
            NULL;
         WHEN OTHERS
         THEN
            RAISE;
      END;

      po_cur := cur_string;

      OPEN geocur FOR cur_string;

      FETCH geocur
         BULK COLLECT INTO l_asset_id,
              l_asset_type,
              l_start_date,
              l_geom
         LIMIT p_limit;

      WHILE l_asset_id.COUNT > 0
      LOOP
         BEGIN
            FORALL i IN 1 .. l_asset_id.COUNT SAVE EXCEPTIONS
               INSERT INTO nm_inv_geometry_all (asset_id,
                                                asset_type,
                                                start_date,
                                                shape)
                    VALUES (l_asset_id (i),
                            l_asset_type (i),
                            l_start_date (i),
                            l_geom (i));

            COMMIT;
         --
         EXCEPTION
            WHEN dml_errors
            THEN
               error_count := SQL%BULK_EXCEPTIONS.COUNT;
               nm_debug.debug (
                  'Number of statements that failed: ' || error_count);
         END;

         FETCH geocur
            BULK COLLECT INTO l_asset_id,
                 l_asset_type,
                 l_start_date,
                 l_geom
            LIMIT p_limit;
      END LOOP;

      CLOSE geocur;

      COMMIT;

      EXECUTE IMMEDIATE
            'alter index nig_spidx parameters ('
         || ''''
         || 'index_status=synchronize'
         || ''''
         || ')';
   END;



   -----
   PROCEDURE create_aggr_sdo_view (
      pi_inv_type    IN nm_inv_types.nit_inv_type%TYPE,
      pi_view_name   IN VARCHAR2 DEFAULT NULL)
   IS
   l_view_name varchar2(30) := NVL (pi_view_name, 'V_' || pi_inv_type || '_AGGR_SDO');
   BEGIN
      EXECUTE IMMEDIATE
            'create or replace view '||l_view_name
         || ' as select * from nm_inv_geometry where asset_type = '
         || ''''
         || pi_inv_type
         || '''';
   --
      INSERT into mdsys.SDO_GEOM_METADATA_TABLE
      ( SDO_OWNER, SDO_TABLE_NAME, SDO_COLUMN_NAME, SDO_DIMINFO, SDO_SRID )
      select sys_context('NM3CORE', 'APPLICATION_OWNER'), l_view_name, 'SHAPE', sdo_diminfo, sdo_srid
      from mdsys.SDO_GEOM_METADATA_TABLE
      where sdo_owner = sys_context('NM3CORE', 'APPLICATION_OWNER')
      and sdo_table_name = 'NM_INV_GEOMETRY_ALL' and sdo_column_name = 'SHAPE';
      
   END;
   
END;
/

