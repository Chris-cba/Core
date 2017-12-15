CREATE OR REPLACE PROCEDURE create_nlt_geometry_view
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/create_nlt_geometry_view.prc-arc   1.4   Dec 15 2017 11:38:38   Rob.Coupe  $
   --       Module Name      : $Workfile:   create_nlt_geometry_view.prc  $
   --       Date into PVCS   : $Date:   Dec 15 2017 11:38:38  $
   --       Date fetched Out : $Modtime:   Dec 15 2017 11:36:16  $
   --       PVCS Version     : $Revision:   1.4  $
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
BEGIN
   SELECT LISTAGG (case_stmt, CHR (10)) WITHIN GROUP (ORDER BY nlt_id)
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
                  || ')'
                     case_stmt
             FROM nm_nw_themes, nm_themes_all, nm_linear_types
            WHERE     nth_theme_id = nnth_nth_theme_id
                  AND nlt_id = nnth_nlt_id
                  AND nth_base_table_theme IS NULL);

   --
   --
   
   if l_str1 is NULL then
     l_str1 := ' mdsys.sdo_geometry( NULL, NULL, NULL, NULL, NULL) ';
   else
     l_str1 := 'case nlt_Id '||l_str1||' end ';
   end if;
   
   l_str2 :=
         'create or replace view v_lb_nlt_geometry '
      || ' ( nlt_id, ne_id, geoloc )  '
      || ' as select nlt_id, ne_id, '
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


   SELECT LISTAGG (union_part, CHR (10) || ' union all ' || CHR (10))
             WITHIN GROUP (ORDER BY nlt_id)
     INTO l_str1
     FROM (SELECT nlt_id,
                  nlt_nt_type,
                  nlt_gty_type,
                  nth_theme_id,
                  nth_feature_table,
                  nth_feature_shape_column,
                  nth_feature_pk_column,
                     'select '
                  || nth_feature_pk_column
                  || ', '
                  || nth_feature_shape_column
                  || ' from '
                  || nth_feature_table
                     union_part
             FROM nm_nw_themes, nm_themes_all, nm_linear_types
            WHERE     nth_theme_id = nnth_nth_theme_id
                  AND nlt_id = nnth_nlt_id
                  AND nth_base_table_theme IS NULL
                  AND nlt_g_i_d = 'D');

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
