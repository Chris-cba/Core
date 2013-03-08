-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_sde_column_registry.vw-arc   1.0   Mar 08 2013 09:41:32   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_sde_column_registry.vw  $
--       Date into PVCS   : $Date:   Mar 08 2013 09:41:32  $
--       Date fetched Out : $Modtime:   Mar 08 2013 09:40:06  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   View used to predict values in the SDE column_registry
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2013
-----------------------------------------------------------------------------
--
CREATE OR REPLACE VIEW v_nm_sde_column_registry
AS
   SELECT 
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_sde_column_registry.vw-arc   1.0   Mar 08 2013 09:41:32   Rob.Coupe  $
--       Module Name      : $Workfile:   v_nm_sde_column_registry.vw  $
--       Date into PVCS   : $Date:   Mar 08 2013 09:41:32  $
--       Date fetched Out : $Modtime:   Mar 08 2013 09:40:06  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   View used to predict values in the SDE column_registry
--
-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2013
-----------------------------------------------------------------------------
--  
          CAST (SYS_CONTEXT ('NM3SQL', 'NSCR_TABLE_NAME') AS NVARCHAR2 (160))
             table_name,
          CAST (
             SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER') AS NVARCHAR2 (32))
             owner,
          CAST (column_name AS NVARCHAR2 (32)) column_name,
          CAST (sde_type AS INTEGER) sde_type,
          CAST (column_size AS INTEGER) column_size,
          CAST (decimal_digits AS INTEGER) decimal_digits,
          CAST (NULL AS NVARCHAR2 (65)) description,
          CAST ( (bit1 + bit2 + bit3 + bit18) AS INTEGER) object_flags,
          CAST (object_id AS INTEGER) object_id
     FROM (SELECT q1.*,
                  CASE column_name
                     WHEN SYS_CONTEXT ('NM3SQL', 'NSCR_COLUMN_NAME')
                     THEN
                        layer_id
                     ELSE
                        NULL
                  END
                     object_id,
                  NVL (
                     (SELECT 2
                        FROM DUAL
                       WHERE     bit1 = 1
                             AND bit3 = 0
                             AND data_type = 'NUMBER'
                             AND data_precision = 38
                             AND data_scale = 0),
                     0)
                     bit2
             FROM (SELECT column_name,
                          layer_id,
                          data_type,
                          data_precision,
                          data_scale,
                          nullable,
                          CASE data_type
                             WHEN 'SDO_GEOMETRY'
                             THEN
                                8
                             WHEN 'NUMBER'
                             THEN
                                CASE NVL (data_scale, -99)
                                   WHEN -99
                                   THEN
                                      CASE NVL (SIGN (data_precision - 4),
                                                -99)
                                         WHEN -99
                                         THEN
                                            4
                                         WHEN 1
                                         THEN
                                            2
                                         ELSE
                                            1
                                      END
                                   WHEN 0
                                   THEN
                                      CASE NVL (SIGN (data_precision - 4),
                                                -99)
                                         WHEN -99
                                         THEN
                                            4
                                         WHEN 1
                                         THEN
                                            2
                                         ELSE
                                            1
                                      END
                                   ELSE
                                      CASE SIGN (
                                                LEAST (
                                                   data_length,
                                                   NVL (data_precision, 9999))
                                              - 6)
                                         WHEN 1
                                         THEN
                                            4
                                         ELSE
                                            3
                                      END
                                END
                             WHEN 'VARCHAR2'
                             THEN
                                5
                             WHEN 'CHAR'
                             THEN
                                5
                             WHEN 'DATE'
                             THEN
                                7
                             ELSE
                                99
                          END
                             sde_type,
                          CASE data_type
                             WHEN 'SDO_GEOMETRY'
                             THEN
                                NULL
                             WHEN 'DATE'
                             THEN
                                0
                             WHEN 'VARCHAR2'
                             THEN
                                data_length
                             WHEN 'CHAR'
                             THEN
                                data_length
                             WHEN 'NUMBER'
                             THEN
                                CASE NVL (data_scale, -99)
                                   WHEN -99
                                   THEN
                                      CASE NVL (data_precision, -99)
                                         WHEN -99
                                         THEN
                                            CASE data_length
                                               WHEN 22 THEN 0
                                            END
                                         ELSE
                                            CASE data_precision
                                               WHEN 38 THEN 10
                                            END
                                      END
                                   WHEN 0
                                   THEN
                                      CASE data_length
                                         WHEN 22
                                         THEN
                                            LEAST (
                                               NVL (data_precision, 99),
                                               NVL (
                                                  DECODE (data_precision,
                                                          38, 10),
                                                  10))
                                      END
                                   ELSE
                                      data_precision
                                END
                             ELSE
                                98
                          END
                             column_size,
                          CASE data_type
                             WHEN 'NUMBER'
                             THEN
                                CASE NVL (data_precision, -99)
                                   WHEN -99
                                   THEN
                                      CASE NVL (data_scale, -99)
                                         WHEN -99
                                         THEN
                                            0
                                         ELSE
                                            CASE data_length
                                               WHEN 22 THEN 10
                                               ELSE NULL
                                            END
                                      END
                                   ELSE
                                      CASE data_scale
                                         WHEN 0 THEN NULL
                                         ELSE data_scale
                                      END
                                END
                             ELSE
                                NULL
                          END
                             decimal_digits,
                          CASE data_type
                             WHEN 'SDO_GEOMETRY' THEN 131072
                             ELSE 0
                          END
                             bit18,
                          CASE nullable WHEN 'Y' THEN 4 ELSE 0 END bit3,
                          CASE column_name
                             WHEN SYS_CONTEXT ('NM3SQL', 'NSCR_ROWID_COLUMN')
                             THEN
                                1
                             ELSE
                                0
                          END
                             bit1
                     FROM (SELECT t.column_name,
                                  t.data_type,
                                  data_length,
                                  data_precision,
                                  data_scale,
                                  layer_id,
                                  CASE data_type
                                     WHEN 'SDO_GEOMETRY'
                                     THEN
                                        (SELECT nullable
                                           FROM (SELECT 1, nullable
                                                   FROM all_dependencies d,
                                                        mdsys.sdo_geom_metadata_table,
                                                        all_tab_columns c
                                                  WHERE     d.owner =
                                                               SYS_CONTEXT (
                                                                  'NM3CORE',
                                                                  'APPLICATION_OWNER')
                                                        AND sdo_owner =
                                                               SYS_CONTEXT (
                                                                  'NM3CORE',
                                                                  'APPLICATION_OWNER')
                                                        AND name =
                                                               SYS_CONTEXT (
                                                                  'NM3SQL',
                                                                  'NSCR_TABLE_NAME')
                                                        AND referenced_name =
                                                               SDO_TABLE_NAME
                                                        AND c.column_name =
                                                               sdo_column_name
                                                        AND c.table_name =
                                                               sdo_table_name
                                                        AND c.owner =
                                                               SYS_CONTEXT (
                                                                  'NM3CORE',
                                                                  'APPLICATION_OWNER')
                                                 UNION ALL
                                                 SELECT 2, nullable
                                                   FROM all_tab_columns
                                                  WHERE     table_name =
                                                               SYS_CONTEXT (
                                                                  'NM3SQL',
                                                                  'NSCR_TABLE_NAME')
                                                        AND column_name =
                                                               SYS_CONTEXT (
                                                                  'NM3SQL',
                                                                  'NSCR_COLUMN_NAME')
                                                        AND owner =
                                                               SYS_CONTEXT (
                                                                  'NM3CORE',
                                                                  'APPLICATION_OWNER')
                                                 UNION ALL
                                                 SELECT 3, 'Y' FROM DUAL
                                                 ORDER BY 1)
                                          WHERE ROWNUM = 1)
                                     ELSE
                                        t.NULLABLE
                                  END
                                     nullable
                             FROM user_tab_columns t, sde.layers l
                            WHERE     t.table_name =
                                         SYS_CONTEXT ('NM3SQL',
                                                      'NSCR_TABLE_NAME')
                                  AND l.table_name = t.table_name
                                  AND l.owner =
                                         SYS_CONTEXT ('NM3CORE',
                                                      'APPLICATION_OWNER'))) q1);