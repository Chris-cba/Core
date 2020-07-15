CREATE OR REPLACE PROCEDURE create_nlt_geometry_view
AS
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/create_nlt_geometry_view.prc-arc   1.6   Jul 15 2020 13:01:22   Rob.Coupe  $
    --       Module Name      : $Workfile:   create_nlt_geometry_view.prc  $
    --       Date into PVCS   : $Date:   Jul 15 2020 13:01:22  $
    --       Date fetched Out : $Modtime:   Jul 15 2020 12:59:46  $
    --       PVCS Version     : $Revision:   1.6  $
    --
    --   Author : R.A. Coupe
    --
    --   View definition for network spatial source for dynamic segmentation
    --
    -----------------------------------------------------------------------------
    -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
    ----------------------------------------------------------------------------
    --

    l_str1   VARCHAR2 (4000);
    l_str2   VARCHAR2 (4000);
    lf       CHAR(1)  := chr(10);
BEGIN
    SELECT LISTAGG (case_stmt,lf) WITHIN GROUP (ORDER BY nlt_id)
      INTO l_str1
      FROM (SELECT nlt_id,
                   nlt_nt_type,
                   nlt_gty_type,
                   nth_theme_id,
                   nth_feature_table,
                   nth_feature_shape_column,
                   nth_feature_pk_column,
                      '         when '
                   || nlt_id
                   || ' then (select '
                   || nth_feature_shape_column
                   || ' from '
                   || nth_feature_table
                   || ' s where s.'
                   || nth_feature_pk_column
                   || ' = e.ne_id '
                   || CASE NVL (nth_start_date_column, '$%^&')
                          WHEN '$%^&'
                          THEN
                              NULL
                          ELSE
                                 ' AND '
                              || nth_start_date_column
                              || ' <=  SYS_CONTEXT ('
                              || ''''
                              || 'NM3CORE'
                              || ''''
                              || ','
                              || ''''
                              || 'EFFECTIVE_DATE'
                              || ''''
                              || ') '
                              || 'AND NVL('
                              || nth_end_date_column
                              || ', TO_DATE ('
                              || ''''
                              || '99991231'
                              || ''''
                              || ','
                              || ''''
                              || 'YYYYMMDD'
                              || ''''
                              || ')) '
                              || ' >  SYS_CONTEXT ('
                              || ''''
                              || 'NM3CORE'
                              || ''''
                              || ','
                              || ''''
                              || 'EFFECTIVE_DATE'
                              || ''''
                              || ') '
                      END
                   || ')'    case_stmt
              FROM nm_nw_themes, nm_themes_all, nm_linear_types
             WHERE     nth_theme_id = nnth_nth_theme_id
                   AND nlt_id = nnth_nlt_id 
                   AND nth_base_table_theme IS NULL);

    --
    --

    IF l_str1 IS NULL
    THEN
        l_str1 := ' mdsys.sdo_geometry( NULL, NULL, NULL, NULL, NULL) ';
    ELSE
        l_str1 := 'case nlt_Id ' || l_str1 || ' end ';
    END IF;

    l_str2 :=
           'create or replace view v_lb_nlt_geometry '||lf
        || ' ( nlt_id, ne_id, geoloc )  '||lf
        || ' as select '||lf
        || '    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/create_nlt_geometry_view.prc-arc   1.6   Jul 15 2020 13:01:22   Rob.Coupe  $ '||lf
        || '    --       Module Name      : $Workfile:   create_nlt_geometry_view.prc  $ '||lf
        || ' nlt_id, ne_id, '||lf
        || l_str1
        || ' from nm_elements e, nm_linear_types '
        || ' where nlt_nt_type = ne_nt_type '
        || ' and nvl(nlt_gty_type, '
        || ''''
        || '$%^&'
        || ''''
        || ' ) = nvl(ne_gty_group_type, '
        || ''''
        || '$%^&'
        || ''''
        || ' ) ';

    nm_debug.debug_on;
    nm_debug.debug (l_str2);

    EXECUTE IMMEDIATE l_str2;

    NM3DDL.CREATE_SYNONYM_FOR_OBJECT ('V_LB_NLT_GEOMETRY');


    SELECT LISTAGG (union_part, lf || ' union all ' || lf)
               WITHIN GROUP (ORDER BY nlt_id)
      INTO l_str1
      FROM (SELECT nlt_id,
                   nlt_nt_type,
                   nlt_gty_type,
                   nth_theme_id,
                   nth_feature_table,
                   nth_feature_shape_column,
                   nth_feature_pk_column,
                      'select /*+INDEX( S '
                   || m.sdo_index_name
                   || ') */'
                   || nth_feature_pk_column
                   || ', '
                   || nth_feature_shape_column
                   || ' from '
                   || nth_feature_table
                   || ' S '    union_part
              FROM nm_nw_themes,
                   nm_themes_all,
                   nm_linear_types,
                   sdo_index_metadata  m
             WHERE     nth_theme_id = nnth_nth_theme_id
                   AND nlt_id = nnth_nlt_id
                   AND nth_base_table_theme IS NULL
                   AND nlt_g_i_d = 'D'
                   AND m.sdo_index_owner = USER
                   AND m.sdo_table_name = nth_feature_table);

    IF l_str1 IS NULL
    THEN
        l_str1 :=
               'select '||lf
            || '    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/create_nlt_geometry_view.prc-arc   1.6   Jul 15 2020 13:01:22   Rob.Coupe  $ '||lf
            || '    --       Module Name      : $Workfile:   create_nlt_geometry_view.prc  $ '||lf
            || ' ne_id, '||lf
            || ' mdsys.sdo_geometry( NULL, NULL, NULL, NULL, NULL) from nm_elements';
    END IF;

    l_str2 :=
           'create or replace view v_lb_nlt_geometry2 '
        || ' ( ne_id, geoloc )  '
        || ' as '
        || l_str1;

    nm_debug.debug (l_str2);

    EXECUTE IMMEDIATE l_str2;

    nm_debug.debug_off;

    NM3DDL.CREATE_SYNONYM_FOR_OBJECT ('V_LB_NLT_GEOMETRY2');
END;
/
