DECLARE
   CURSOR get_base_table
   IS
      SELECT DISTINCT nth_theme_id
        FROM nm_themes_all,
             nm_nw_themes,
             nm_linear_types,
             nm_nodes,
             nm_types
       WHERE     nlt_g_i_d = 'D'
             AND nlt_id = nnth_nlt_id
             AND nnth_nth_theme_id = nth_theme_id
             AND no_node_type = nt_node_type
             AND nlt_nt_type = nt_type
             AND nth_base_table_theme IS NULL; 
   
   CURSOR get_table
   IS
      SELECT DISTINCT nth_theme_id
        FROM nm_themes_all,
             nm_nw_themes,
             nm_linear_types,
             nm_nodes,
             nm_types
       WHERE     nlt_g_i_d = 'D'
             AND nlt_id = nnth_nlt_id
             AND nnth_nth_theme_id = nth_theme_id
             AND no_node_type = nt_node_type
             AND nlt_nt_type = nt_type
             AND nth_base_table_theme IS NOT NULL;

   theme_id        NM_THEMES_ALL.NTH_THEME_ID%TYPE;
BEGIN

   -- Inserts for the Reshape function
   OPEN get_base_table;

   FETCH get_base_table
   INTO theme_id;

   CLOSE get_base_table;

   INSERT INTO hig_modules (hmo_module,
                            hmo_title,
                            hmo_filename,
                            hmo_module_type,
                            hmo_fastpath_opts,
                            hmo_fastpath_invalid,
                            hmo_use_gri,
                            hmo_application,
                            hmo_menu)
      SELECT 'RESHAPE',
             'Reshape Route',
             'RESHAPE_ROUTE',
             'PLS',
             NULL,
             'N',
             'N',
             'NET',
             NULL
        FROM DUAL
       WHERE NOT EXISTS (SELECT 1
                           FROM HIG_MODULES
                          WHERE HMO_MODULE = 'RESHAPE');


   INSERT INTO hig_module_roles (hmr_module, hmr_role, hmr_mode)
      SELECT 'RESHAPE', 'NET_USER', 'NORMAL'
        FROM DUAL
       WHERE NOT EXISTS
                (SELECT 1
                   FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'RESHAPE' AND HMR_ROLE = 'NET_USER');

   INSERT INTO nm_theme_functions_all (ntf_nth_theme_id,
                                       ntf_hmo_module,
                                       ntf_parameter,
                                       ntf_menu_option,
                                       ntf_seen_in_gis)
      SELECT theme_id,
             'RESHAPE',
             'GIS_SESSION_ID',
             'Reshape Route',
             'Y'
        FROM DUAL
       WHERE NOT EXISTS
                (SELECT 1
                   FROM NM_THEME_FUNCTIONS_ALL
                  WHERE NTF_NTH_THEME_ID = theme_id
                        AND NTF_HMO_MODULE = 'RESHAPE');

   INSERT INTO nm_theme_roles (nthr_theme_id, nthr_role, nthr_mode)
      SELECT theme_id, 'NET_USER', 'NORMAL'
        FROM DUAL
       WHERE NOT EXISTS
                (SELECT 1
                   FROM NM_THEME_ROLES
                  WHERE NTHR_THEME_ID = theme_id AND NTHR_ROLE = 'NET_USER');
                 
   ---------------------------------------------------------------------------            
                
   -- Inserts for the Reverse Datum function

   OPEN get_table;

   FETCH get_table
   INTO theme_id;

   CLOSE get_table;

   INSERT INTO HIG_MODULES (HMO_MODULE,
                            HMO_TITLE,
                            HMO_FILENAME,
                            HMO_MODULE_TYPE,
                            HMO_FASTPATH_INVALID,
                            HMO_USE_GRI,
                            HMO_APPLICATION)
      SELECT 'REVERSE_DATUM',
             'Reverse Shape',
             'NM3SDO_UTIL.REVERSE_DATUM',
             'PLS',
             'N',
             'N',
             'USR'
        FROM DUAL
       WHERE NOT EXISTS (SELECT 1
                           FROM HIG_MODULES
                          WHERE HMO_MODULE = 'REVERSE_DATUM');


   INSERT INTO HIG_MODULE_ROLES (HMR_MODULE, HMR_ROLE, HMR_MODE)
      SELECT 'REVERSE_DATUM', 'NET_USER', 'NORMAL'
        FROM DUAL
       WHERE NOT EXISTS
                (SELECT 1
                   FROM HIG_MODULE_ROLES
                  WHERE HMR_MODULE = 'REVERSE_DATUM'
                        AND HMR_ROLE = 'NET_USER');

   INSERT INTO NM_THEME_FUNCTIONS_ALL (NTF_NTH_THEME_ID,
                                       NTF_HMO_MODULE,
                                       NTF_PARAMETER,
                                       NTF_MENU_OPTION,
                                       NTF_SEEN_IN_GIS)
      SELECT theme_id,
             'REVERSE_DATUM',
             'GIS_SESSION_ID',
             'Reverse Datum',
             'Y'
        FROM DUAL
       WHERE NOT EXISTS
                (SELECT 1
                   FROM NM_THEME_FUNCTIONS_ALL
                  WHERE NTF_NTH_THEME_ID = theme_id
                        AND NTF_HMO_MODULE = 'REVERSE_DATUM');

   INSERT INTO NM_THEME_ROLES (NTHR_THEME_ID, NTHR_ROLE, NTHR_MODE)
      SELECT theme_id, 'NET_USER', 'NORMAL'
        FROM DUAL
       WHERE NOT EXISTS
                (SELECT 1
                   FROM NM_THEME_ROLES
                  WHERE NTHR_THEME_ID = theme_id AND NTHR_ROLE = 'NET_USER');
                  
END;
/
