--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/0110864_spatial_join_view_refresh.sql-arc   1.1   Jul 04 2013 10:29:54   James.Wadsworth  $
--       Module Name      : $Workfile:   0110864_spatial_join_view_refresh.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:29:54  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:19:26  $
--       Version          : $Revision:   1.1  $
--       Author           : Chris Strettle 25/03/2011
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
DECLARE
  CURSOR network_type_cur IS
  SELECT * 
  FROM
  (SELECT ngt_nt_type , ngt_group_type FROM nm_group_types
  UNION
  SELECT nt_type, NULL FROM nm_types
  WHERE nt_datum = 'Y')
  WHERE EXISTS
  (SELECT 'X' 
     FROM user_views 
    WHERE view_name = NVL2(ngt_group_type, 'V_NM_'||ngt_nt_type || '_' || ngt_group_type || '_NT', 'V_NM_'||ngt_nt_type || '_NT'));
  --
  CURSOR group_type_cur IS
    select nth_feature_table
         , 'V_'|| nth_feature_table || '_DT' view_name
         , vnnt_nt_type
         , vnnt_gty_type
         , NVL2(vnnt_gty_type, 'V_NM_'||vnnt_nt_type || '_' || vnnt_gty_type || '_NT', 'V_NM_'||vnnt_nt_type || '_NT') nt_view_name
         , nth_theme_id
         , nth_feature_shape_column
         , nth_end_date_column
    from v_nm_net_themes_all a, nm_themes_all b
    where vnnt_nth_theme_id = nth_theme_id
    and vnnt_nth_base_table_theme IS NULL
    and vnnt_nt_type not in ('NSGN')
    and vnnt_lr_type  <> 'D';
  --
  cur_string  VARCHAR2 (2000);
  --
BEGIN
  --
  -- Refresh all network views that exist
  --
  FOR network_type_rec IN network_type_cur LOOP
    --
    IF network_type_rec.ngt_group_type IS NULL
    THEN
      --
      dbms_output.put_line('Refresh network type view for ' || network_type_rec.ngt_nt_type);
      nm3inv_view.create_view_for_nt_type( network_type_rec.ngt_nt_type);
      --
    ELSE
      --
      dbms_output.put_line('Refresh network type view for ' || network_type_rec.ngt_nt_type || ' & ' || network_type_rec.ngt_group_type);
      nm3inv_view.create_view_for_nt_type( network_type_rec.ngt_nt_type
                                         , network_type_rec.ngt_group_type);
      --
    END IF;
    --
  END LOOP;
  --
  -- Refresh spatial join view and sde column registry
  --
  FOR group_type_rec IN group_type_cur LOOP
    --
    -- Refresh sdo join view
    --
    dbms_output.put_line('Refresh theme views for ' || group_type_rec.view_name);
    --
          cur_string :=
          'create or replace view '|| group_type_rec.view_name|| ' as '
       || 'select n.*, s.objectid, s.' || NVL(group_type_rec.nth_feature_shape_column, 'geoloc')
       || ' from  ' || group_type_rec.nt_view_name || ' n,'
       || group_type_rec.nth_feature_table || ' s' 
       || ' where n.ne_id = s.ne_id '
       || ' and s.start_date <= (select nm3context.get_effective_date from dual) '
       || ' and NVL(s.end_date,TO_DATE(''99991231'',''YYYYMMDD'')) > (select nm3context.get_effective_date from dual)';
    --
    dbms_output.put_line(group_type_rec.nt_view_name || ' => ' || cur_string);
    --
    nm3ddl.create_object_and_views (group_type_rec.nt_view_name, cur_string);
    --
    --Create SDE metadata
    --
    -- Check if the layer exists and if registration of SDE layers is allowed.
    --
    IF nm3sde.get_sde_layer_id_from_theme(group_type_rec.nth_theme_id,'TRUE') IS NOT NULL
    AND NVL(hig.get_user_or_sys_opt('REGSDELAY'), 'N') = 'Y'
    THEN
      --
      dbms_output.put_line(group_type_rec.view_name || ' SDE Layer exists. Row being added.');
      --
      EXECUTE IMMEDIATE
      ' DELETE FROM sde.column_registry a' ||
      ' WHERE table_name = ''' || group_type_rec.view_name || '''' ||
      ' AND owner IN (SELECT hus_username FROM hig_users, all_users WHERE hus_username = username)' ||
      ' AND EXISTS (SELECT ''X''' ||
      '             FROM sde.layers c' ||
      '            WHERE c.table_name = a.table_name' ||
      '              AND c.owner = a.owner)';
      --
      nm3sde.create_column_registry( p_table  => group_type_rec.view_name
                                   , p_column => group_type_rec.nth_feature_shape_column
                                   , p_rowid  => 'OBJECTID'
                                   );
    --
    --Create subordinate user column registry for new column(s)
    --
    EXECUTE IMMEDIATE
      'INSERT INTO sde.column_registry( table_name' ||
      '                              , owner' ||
      '                              , column_name' ||
      '                              , sde_type' ||
      '                              , column_size' ||
      '                              , decimal_digits' ||
      '                              , description' ||
      '                              , object_flags' ||
      '                              , object_id)' ||
      ' SELECT table_name' ||
      '      , hus_username' ||
      '      , column_name' ||
      '      , sde_type' ||
      '      , column_size' ||
      '      , decimal_digits' ||
      '      , description' ||
      '      , object_flags' ||
      '      , object_id' ||
      '   FROM sde.column_registry a' ||
      '      , hig_users ' ||
      '      , all_users ' ||
      '   WHERE table_name = ''' || group_type_rec.view_name || '''' ||
      '   AND hus_username != hig.get_application_owner' ||
      '   AND username = hus_username' ||
      '   AND NOT EXISTS (SELECT ''X''' ||
      '                     FROM sde.column_registry b ' ||
      '                    WHERE a.column_name = b.column_name' ||
      '                      AND b.owner = hus_username' ||
      '                      AND b.table_name = a.table_name)' ||
      '   AND EXISTS (SELECT ''X''' ||
      '             FROM sde.layers c' ||
      '            WHERE c.table_name = a.table_name' ||
      '              AND c.owner = hus_username)';
    END IF;
  --
  END LOOP;
  --
  COMMIT;
  --
END;
/


