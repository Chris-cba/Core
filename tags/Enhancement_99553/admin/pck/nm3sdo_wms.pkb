CREATE OR REPLACE PACKAGE BODY nm3sdo_wms AS
  --
  -------------------------------------------------------------------------
  --   PVCS Identifiers :-
  --
  --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3sdo_wms.pkb-arc   3.0   Sep 18 2014 13:10:06   Mike.Huitson  $
  --       Module Name      : $Workfile:   nm3sdo_wms.pkb  $
  --       Date into PVCS   : $Date:   Sep 18 2014 13:10:06  $
  --       Date fetched Out : $Modtime:   Sep 17 2014 12:57:20  $
  --       Version          : $Revision:   3.0  $
  --       Based on SCCS version : 1.1
  ---------------------------------------------------------------------------
  --   Author : I Turnbull
  --
  --   nm3sdo_xml body
  --
  -----------------------------------------------------------------------------
  --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
  -----------------------------------------------------------------------------
  --
  --all global package variables here
  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT VARCHAR2(2000) := '$Revision:   3.0  $';
  g_package_name CONSTANT VARCHAR2(30) := 'nm3sdo_xml';
  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_version
    RETURN VARCHAR2 IS
  BEGIN
    RETURN g_sccsid;
  END get_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_body_version
    RETURN VARCHAR2 IS
  BEGIN
    RETURN g_body_sccsid;
  END get_body_version;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION tokenise_clob(pi_clob        IN CLOB
                        ,pi_token       IN VARCHAR2 DEFAULT ','
                        ,pi_trim_values IN BOOLEAN DEFAULT TRUE)
    RETURN nm_max_varchar_tbl AS
    --
    lt_retval  nm_max_varchar_tbl := nm_max_varchar_tbl();
    --
    lv_clob   CLOB;
    lv_char   varchar2(1);
    lv_value  nm3type.max_varchar2 := NULL;
    --
    lv_length  PLS_INTEGER;
    --
  BEGIN
    --
    IF pi_clob IS NOT NULL
     THEN
        lv_clob := pi_clob;
        lv_length := dbms_lob.getlength(lv_clob);
        --
        FOR i IN 1..lv_length LOOP
          --
          lv_char := dbms_lob.substr(lv_clob,1,i);
          --
          IF lv_char != pi_token
           AND i <= lv_length
           THEN
              lv_value := lv_value||lv_char;
          END IF;
          --
          IF (lv_char = pi_token OR i = lv_length)
           AND lv_value IS NOT NULL
           THEN
              IF pi_trim_values
               THEN
                  lv_value := LTRIM(RTRIM(lv_value));
              END IF;
              lt_retval.extend;
              lt_retval(lt_retval.COUNT) := lv_value;
              lv_value := NULL;
          END IF;
          --
        END LOOP;
    END IF;
    --
    RETURN lt_retval;
    --
  END tokenise_clob;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_name(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN nm_wms_themes.nwt_name%TYPE IS
    --
    lv_retval  nm_wms_themes.nwt_name%TYPE;
    --
  BEGIN
    --
    SELECT nwt_name
      INTO lv_retval
      FROM nm_wms_themes
     WHERE nwt_id = pi_nwt_id
         ;
    --
    RETURN lv_retval;
    --
  EXCEPTION
    WHEN no_data_found
     THEN
        raise_application_error(-20001,'Invalid WMS Theme Id supplied ['||pi_nwt_id||'].');
    WHEN others
     THEN
        RAISE;
  END get_wms_theme_name;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nwt(pio_nwt_rec IN OUT nm_wms_themes%ROWTYPE)
    IS
  BEGIN
    --
    INSERT
      INTO nm_wms_themes
          (nwt_id
          ,nwt_name
          ,nwt_is_background
          ,nwt_transparency
          ,nwt_visible_on_startup)
    VALUES(NVL(pio_nwt_rec.nwt_id,nwt_id_seq.NEXTVAL)
          ,pio_nwt_rec.nwt_name
          ,NVL(pio_nwt_rec.nwt_is_background,'Y')
          ,NVL(pio_nwt_rec.nwt_transparency,1)
          ,NVL(pio_nwt_rec.nwt_visible_on_startup,'Y'))
 RETURNING nwt_id
          ,nwt_name
          ,nwt_is_background
          ,nwt_transparency
          ,nwt_visible_on_startup
      INTO pio_nwt_rec.nwt_id
          ,pio_nwt_rec.nwt_name
          ,pio_nwt_rec.nwt_is_background
          ,pio_nwt_rec.nwt_transparency
          ,pio_nwt_rec.nwt_visible_on_startup
         ;
  END ins_nwt;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE ins_nwtr(pio_nwtr_rec IN OUT nm_wms_theme_roles%ROWTYPE)
    IS
  BEGIN
    --
    INSERT
      INTO nm_wms_theme_roles
          (nwtr_nwt_id
          ,nwtr_role)
    VALUES(pio_nwtr_rec.nwtr_nwt_id
          ,pio_nwtr_rec.nwtr_role)
 RETURNING nwtr_nwt_id
          ,nwtr_role
      INTO pio_nwtr_rec.nwtr_nwt_id
          ,pio_nwtr_rec.nwtr_role
         ;
  END ins_nwtr;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme(pi_nwt_id IN  nm_wms_themes.nwt_id%TYPE
                         ,po_cursor OUT sys_refcursor)
    IS
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT nwt_id
          ,nwt_name
          ,nwt_is_background
          ,nwt_transparency
          ,nwt_visible_on_startup
          ,description
          ,service_url
          ,auth_user
          ,auth_password
          ,version
          ,srs
          ,format
          ,bgcolor
          ,transparent
          ,exceptions
          ,capabilities_url
      FROM v_nm_wms_themes
     WHERE nwt_id = pi_nwt_id
         ;
    --
  END get_wms_theme;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme(pi_nwt_id => pi_nwt_id
                 ,po_cursor => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_theme;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_themes(po_cursor IN OUT sys_refcursor)
    IS
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT nwt_id
          ,nwt_name
          ,nwt_is_background
          ,nwt_transparency
          ,nwt_visible_on_startup
          ,description
          ,service_url
          ,auth_user
          ,auth_password
          ,version
          ,srs
          ,format
          ,bgcolor
          ,transparent
          ,exceptions
          ,capabilities_url
      FROM v_nm_wms_themes
         ;
    --
  END get_wms_themes;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_themes
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_themes(po_cursor => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_themes;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_tab
    RETURN wms_theme_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_tab;
    --
  BEGIN
    --
    get_wms_themes(po_cursor => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_wms_theme_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_tab(po_wms_themes IN OUT wms_theme_tab)
    IS
  BEGIN
    --
    po_wms_themes := get_wms_theme_tab;
    --
  END get_wms_theme_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_map_wms_themes(pi_map_name IN  VARCHAR2
                              ,po_cursor   OUT sys_refcursor)
    IS
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT nwt_id
          ,nwt_name
          ,nwt_is_background
          ,nwt_transparency
          ,nwt_visible_on_startup
          ,description
          ,service_url
          ,auth_user
          ,auth_password
          ,layers
          ,version
          ,srs
          ,format
          ,bgcolor
          ,transparent
          ,styles
          ,exceptions
          ,capabilities_url
      FROM v_nm_wms_themes
     WHERE nwt_name IN(SELECT map_themes.name
                         FROM user_sdo_maps maps
                             ,XMLTABLE('/map_definition/theme'
                                       PASSING XMLTYPE(maps.definition)
                                       COLUMNS name  VARCHAR2(32) path '@name') map_themes
                        WHERE maps.name = pi_map_name)
         ;
    --
  END get_map_wms_themes;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_map_wms_themes(pi_map_name IN VARCHAR2)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_map_wms_themes(pi_map_name => pi_map_name
                      ,po_cursor   => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_map_wms_themes;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_map_wms_theme_tab(pi_map_name IN VARCHAR2)
    RETURN wms_theme_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_tab;
    --
  BEGIN
    --
    get_map_wms_themes(pi_map_name => pi_map_name
                      ,po_cursor   => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_map_wms_theme_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_map_wms_theme_tab(pi_map_name   IN     VARCHAR2
                                 ,po_wms_themes IN OUT wms_theme_tab)
    IS
  BEGIN
    --
    po_wms_themes := get_map_wms_theme_tab(pi_map_name => pi_map_name);
    --
  END get_map_wms_theme_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_layers(pi_nwt_name IN  nm_wms_themes.nwt_name%TYPE
                                ,po_cursor   OUT sys_refcursor)
    IS
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT theme_name
          ,layer_name
      FROM v_sdo_wms_theme_layers
     WHERE theme_name = pi_nwt_name
         ;
    --
  END get_wms_theme_layers;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_layers(pi_nwt_name IN nm_wms_themes.nwt_name%TYPE)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_layers(pi_nwt_name => pi_nwt_name
                        ,po_cursor   => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_theme_layers;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_layer_tab(pi_nwt_name IN nm_wms_themes.nwt_name%TYPE)
    RETURN wms_theme_layer_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_layer_tab;
    --
  BEGIN
    --
    get_wms_theme_layers(pi_nwt_name => pi_nwt_name
                        ,po_cursor   => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_wms_theme_layer_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_layer_tab(pi_nwt_name         IN     nm_wms_themes.nwt_name%TYPE
                                   ,po_wms_theme_layers IN OUT wms_theme_layer_tab)
    IS
  BEGIN
  nm_debug.debug_on;
  nm_debug.debug('pi_nwt_name = '||pi_nwt_name);
    --
    po_wms_theme_layers := get_wms_theme_layer_tab(pi_nwt_name => pi_nwt_name);
    --
  nm_debug.debug_off;
  END get_wms_theme_layer_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_layers(pi_nwt_id IN  nm_wms_themes.nwt_id%TYPE
                                ,po_cursor OUT sys_refcursor)
    IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_layers(pi_nwt_name => get_wms_theme_name(pi_nwt_id => pi_nwt_id)
                        ,po_cursor   => lv_cursor);
    --
    po_cursor := lv_cursor;
    --
  END get_wms_theme_layers;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_layers(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_layers(pi_nwt_id => pi_nwt_id
                        ,po_cursor => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_theme_layers;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_layer_tab(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN wms_theme_layer_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_layer_tab;
    --
  BEGIN
    --
    get_wms_theme_layers(pi_nwt_id => pi_nwt_id
                        ,po_cursor => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_wms_theme_layer_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_layer_tab(pi_nwt_id           IN     nm_wms_themes.nwt_id%TYPE
                                   ,po_wms_theme_layers IN OUT wms_theme_layer_tab)
    IS
  BEGIN
    --
    po_wms_theme_layers := get_wms_theme_layer_tab(pi_nwt_id => pi_nwt_id);
    --
  END get_wms_theme_layer_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_params(pi_nwt_name IN  nm_wms_themes.nwt_name%TYPE
                                ,po_cursor   OUT sys_refcursor)
    IS
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT theme_name
          ,param_name
          ,param_value
      FROM v_sdo_wms_theme_params
     WHERE theme_name = pi_nwt_name
         ;
    --
  END get_wms_theme_params;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_params(pi_nwt_name IN nm_wms_themes.nwt_name%TYPE)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_params(pi_nwt_name => pi_nwt_name
                        ,po_cursor   => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_theme_params;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_param_tab(pi_nwt_name IN nm_wms_themes.nwt_name%TYPE)
    RETURN wms_theme_param_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_param_tab;
    --
  BEGIN
    --
    get_wms_theme_params(pi_nwt_name => pi_nwt_name
                        ,po_cursor   => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_wms_theme_param_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_param_tab(pi_nwt_name         IN nm_wms_themes.nwt_name%TYPE
                                   ,po_wms_theme_params IN OUT wms_theme_param_tab)
    IS
  BEGIN
    --
    po_wms_theme_params := get_wms_theme_param_tab(pi_nwt_name => pi_nwt_name);
    --
  END get_wms_theme_param_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_params(pi_nwt_id IN  nm_wms_themes.nwt_id%TYPE
                                ,po_cursor OUT sys_refcursor)
    IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_params(pi_nwt_name => get_wms_theme_name(pi_nwt_id => pi_nwt_id)
                        ,po_cursor   => lv_cursor);
    --
    po_cursor := lv_cursor;
    --
  END get_wms_theme_params;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_params(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_params(pi_nwt_id => pi_nwt_id
                        ,po_cursor => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_theme_params;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_param_tab(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN wms_theme_param_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_param_tab;
    --
  BEGIN
    --
    get_wms_theme_params(pi_nwt_id => pi_nwt_id
                        ,po_cursor => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_wms_theme_param_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_param_tab(pi_nwt_id           IN     nm_wms_themes.nwt_id%TYPE
                                   ,po_wms_theme_params IN OUT wms_theme_param_tab)
    IS
  BEGIN
    --
    po_wms_theme_params := get_wms_theme_param_tab(pi_nwt_id => pi_nwt_id);
    --
  END get_wms_theme_param_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_styles(pi_nwt_name IN  nm_wms_themes.nwt_name%TYPE
                                ,po_cursor   OUT sys_refcursor)
    IS
  BEGIN
    --
    OPEN po_cursor FOR
    SELECT theme_name
          ,style_name
      FROM v_sdo_wms_theme_styles
     WHERE theme_name = pi_nwt_name
         ;
    --
  END get_wms_theme_styles;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_styles(pi_nwt_name IN nm_wms_themes.nwt_name%TYPE)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_styles(pi_nwt_name => pi_nwt_name
                        ,po_cursor => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_theme_styles;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_style_tab(pi_nwt_name IN nm_wms_themes.nwt_name%TYPE)
    RETURN wms_theme_style_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_style_tab;
    --
  BEGIN
    --
    get_wms_theme_styles(pi_nwt_name => pi_nwt_name
                        ,po_cursor   => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_wms_theme_style_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_style_tab(pi_nwt_name         IN nm_wms_themes.nwt_name%TYPE
                                   ,po_wms_theme_styles IN OUT wms_theme_style_tab)
    IS
  BEGIN
    --
    po_wms_theme_styles := get_wms_theme_style_tab(pi_nwt_name => pi_nwt_name);
    --
  END get_wms_theme_style_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_styles(pi_nwt_id IN  nm_wms_themes.nwt_id%TYPE
                                ,po_cursor OUT sys_refcursor)
    IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_styles(pi_nwt_name => get_wms_theme_name(pi_nwt_id => pi_nwt_id)
                        ,po_cursor   => lv_cursor);
    --
    po_cursor := lv_cursor;
    --
  END get_wms_theme_styles;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_styles(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN sys_refcursor IS
    --
    lv_cursor  sys_refcursor;
    --
  BEGIN
    --
    get_wms_theme_styles(pi_nwt_id => pi_nwt_id
                        ,po_cursor => lv_cursor);
    --
    RETURN lv_cursor;
    --
  END get_wms_theme_styles;

  --
  -----------------------------------------------------------------------------
  --
  FUNCTION get_wms_theme_style_tab(pi_nwt_id IN nm_wms_themes.nwt_id%TYPE)
    RETURN wms_theme_style_tab IS
    --
    lv_cursor  sys_refcursor;
    lt_retval  wms_theme_style_tab;
    --
  BEGIN
    --
    get_wms_theme_styles(pi_nwt_id => pi_nwt_id
                        ,po_cursor => lv_cursor);
    --
    FETCH lv_cursor
     BULK COLLECT
     INTO lt_retval;
    CLOSE lv_cursor;
    --
    RETURN lt_retval;
    --
  END get_wms_theme_style_tab;

  --
  -----------------------------------------------------------------------------
  --
  PROCEDURE get_wms_theme_style_tab(pi_nwt_id           IN     nm_wms_themes.nwt_id%TYPE
                                   ,po_wms_theme_styles IN OUT wms_theme_style_tab)
    IS
  BEGIN
    --
    po_wms_theme_styles := get_wms_theme_style_tab(pi_nwt_id => pi_nwt_id);
    --
  END get_wms_theme_style_tab;

--
-------------------------------------------------------------------------------
--
END nm3sdo_wms;
/
