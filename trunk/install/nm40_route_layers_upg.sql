-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm40_route_layers_upg.sql	1.2 01/05/07
--       Module Name      : nm40_route_layers_upg.sql
--       Date into SCCS   : 07/01/05 16:43:31
--       Date fetched Out : 07/06/13 13:59:24
--       SCCS Version     : 1.2
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

DECLARE
  qq varchar2(10) := CHR (39);
  CURSOR get_dt_feature_views 
  IS
    SELECT nth_theme_id, nth_feature_table, nth_feature_shape_column
         , nth_feature_pk_column, vnnt_type, vnnt_nt_type, vnnt_gty_type
      FROM nm_themes_all, v_nm_net_themes_all
     WHERE vnnt_nth_theme_id = nth_theme_id 
       AND vnnt_gty_type IS NOT NULL
       AND nth_feature_table LIKE '%SDO_DT';
--
----------------------------------------------------------------------------------
--
  PROCEDURE create_nlt_sdo_join_view
             ( pi_nt_type      IN nm_types.nt_type%TYPE
             , pi_gty_type     IN nm_group_types.ngt_group_type%TYPE
             , pi_feature_view IN user_views.view_name%TYPE )
  IS
    l_sql        VARCHAR2(10000);
    s_col_list   VARCHAR2(100)  := 's.geoloc';
  BEGIN
  --
    IF nm3sdo.use_surrogate_key = 'Y'
    THEN
      s_col_list := 's.objectid, s.geoloc';
    END IF;
  --
    l_sql :=  'CREATE OR REPLACE VIEW '||pi_feature_view
           ||' AS SELECT n.*, '
           || s_col_list
           || ' FROM '
           || ' V_NM_'
           || pi_nt_type
           || '_'
           || pi_gty_type
           || '_NT'
           || ' n,'
           || replace(replace(pi_feature_view,'_DT',NULL),'V_',NULL)
           || ' s WHERE n.ne_id = s.ne_id '
           || ' AND s.start_date <= (SELECT nm3context.get_effective_date FROM DUAL) '
           || ' AND  NVL(s.end_date,TO_DATE('
           || qq
           || '99991231'
           || qq
           || ','
           || qq
           || 'YYYYMMDD'
           || qq
           || ')) > (SELECT nm3context.get_effective_date FROM DUAL)';
  --
    nm3ddl.create_object_and_syns (pi_feature_view, l_sql);
  --
  END create_nlt_sdo_join_view;
--
----------------------------------------------------------------------------------
--
  PROCEDURE create_nat_sdo_join_view
    ( pi_nt_type       IN   NM_TYPES.nt_type%TYPE
    , pi_gty_type      IN   nm_group_types.ngt_group_type%TYPE
    , pi_feature_view  IN   VARCHAR2)
  IS
   cur_string   VARCHAR2 (2000);
   s_col_list   VARCHAR2 (100) := 's.ne_id_of, s.nm_begin_mp, s.nm_end_mp, s.geoloc';
  BEGIN
  --
    IF Nm3sdo.use_surrogate_key = 'Y'
    THEN
       s_col_list := 's.objectid, ' || s_col_list;
    END IF;
  --
    cur_string :=
          'CREATE OR REPLACE VIEW '
       || pi_feature_view
       || ' AS SELECT n.*, '
       || s_col_list
       || ' FROM '
       || ' V_NM_'
       || pi_nt_type
       || '_'
       || pi_gty_type
       || '_NT'
       || ' n,'
       || replace(replace(pi_feature_view,'_DT',NULL),'V_',NULL)
       || ' s WHERE n.ne_id = s.ne_id '
       || ' AND s.start_date <= (SELECT nm3context.get_effective_date FROM DUAL) '
       || ' AND  NVL(s.end_date,TO_DATE('
       || qq
       || '99991231'
       || qq
       || ','
       || qq
       || 'YYYYMMDD'
       || qq
       || ')) > (SELECT nm3context.get_effective_date FROM DUAL)';
  --
    Nm3ddl.create_object_and_syns (pi_feature_view, cur_string);
  --
  END create_nat_sdo_join_view;
--
----------------------------------------------------------------------------------
--
BEGIN
--
  FOR i IN get_dt_feature_views 
  LOOP
  --
  -- Create group type view
    nm3inv_view.create_view_for_nt_type(pi_nt_type  => i.vnnt_nt_type
                                      , pi_gty_type => i.vnnt_gty_type);
  --
    IF i.vnnt_type = 'A'
    THEN 
    -- Area type (non linear)
      BEGIN
        create_nat_sdo_join_view ( i.vnnt_nt_type
                                 , i.vnnt_gty_type
                                 , i.nth_feature_table 
                                 );
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    ELSIF i.vnnt_type = 'L'
    THEN 
    -- Linear type
      BEGIN
        create_nlt_sdo_join_view ( i.vnnt_nt_type
                                 , i.vnnt_gty_type
                                 , i.nth_feature_table 
                                 );
      EXCEPTION
        WHEN OTHERS THEN NULL;
      END;
    END IF;
  END LOOP; 
END;
/

