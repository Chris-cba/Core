CREATE OR REPLACE PROCEDURE create_nlt_geometry_view
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/create_nlt_geometry_view.prc-arc   1.0   Jan 15 2015 20:12:16   Rob.Coupe  $
--       Module Name      : $Workfile:   create_nlt_geometry_view.prc  $
--       Date into PVCS   : $Date:   Jan 15 2015 20:12:16  $
--       Date fetched Out : $Modtime:   Jan 15 2015 20:10:28  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe
--
--   Policy predicates for Location Bridge FGAC security
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

   l_str1   VARCHAR2 (4000);
   l_str2  VARCHAR2 (4000);
BEGIN
   SELECT LISTAGG (case_stmt, CHR (13)) WITHIN GROUP (ORDER BY nlt_id)
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
                           || ' <=  to_date( SYS_CONTEXT ('
                           || ''''
                           || 'NM3CORE'
                           || ''''
                           || ','
                           || ''''
                           || 'EFFECTIVE_DATE'
                           || ''''
                           || '), '||''''||'YYYYMMDD'||''''||') '
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
                           || ' >  to_date( SYS_CONTEXT ('
                           || ''''
                           || 'NM3CORE'
                           || ''''
                           || ','
                           || ''''
                           || 'EFFECTIVE_DATE'
                           || ''''
                           || '), '||''''||'YYYYMMDD'||''''||') '
                     END
                  || ')'
                     case_stmt
             FROM nm_nw_themes, nm_themes_all, nm_linear_types
            WHERE     nth_theme_id = nnth_nth_theme_id
                  AND nlt_id = nnth_nlt_id
                  AND nth_base_table_theme IS NULL);

   --
   
   l_str2 := 'create or replace view v_lb_nlt_geometry '
      || ' ( nlt_id, ne_id, geoloc )  '
      || ' as select nlt_id, ne_id, '
      || '  case nlt_id '
      || l_str1
      || ' end  '
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
   nm_debug.debug( l_str2 );
   
   execute immediate l_str2;

   NM3DDL.CREATE_SYNONYM_FOR_OBJECT('V_LB_NLT_GEOMETRY');
      
END;