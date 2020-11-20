/* Formatted on 18/11/2020 18:25:39 (QP5 v5.336) */
CREATE OR REPLACE PACKAGE BODY sdl_invval
AS
    --
    -----------------------------------------------------------------------------
    --
    --   PVCS Identifiers :-
    --
    --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/sdl_invval.pkb-arc   1.4   Nov 20 2020 12:29:54   Rob.Coupe  $
    --       Module Name      : $Workfile:   sdl_invval.pkb  $
    --       Date into PVCS   : $Date:   Nov 20 2020 12:29:54  $
    --       Date fetched Out : $Modtime:   Nov 20 2020 12:28:46  $
    --       PVCS Version     : $Revision:   1.4  $
    --
    --   Author : Rob Coupe
    --
    --   Package responsible for bulk validation of inventory data inside the Spatial/Transportation data loader
    --
    -----------------------------------------------------------------------------
    --   Copyright (c) 2020 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
    --
    g_body_sccsid   CONSTANT VARCHAR2 (2000) := '$Revision:   1.4  $';

    g_sdh_id                 NUMBER;
    g_source_name            VARCHAR2 (30);
    g_inv_type               VARCHAR2 (4);
    g_use_xsp                VARCHAR2 (1);
    g_has_xsp_column         VARCHAR2 (1);
    qq                       CHAR (1) := CHR (39);
    g_unrestricted           VARCHAR2 (5)
        := SYS_CONTEXT ('NM3CORE', 'UNRESTRICTED_INVENTORY');

    --
    FUNCTION get_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_sccsid;
    END get_version;

    --
    -----------------------------------------------------------------------------
    --
    FUNCTION get_body_version
        RETURN VARCHAR2
    IS
    BEGIN
        RETURN g_body_sccsid;
    END get_body_version;

    --

    --procedure validate_xsp( p_sfs_id in number, p_sdh_id in number, p_error_count out number);

    PROCEDURE init_xsp_data (p_sfs_id IN NUMBER, p_sdh_id IN NUMBER);

    PROCEDURE validate_au (p_sfs_id        IN     NUMBER,
                           p_sdh_id        IN     NUMBER,
                           p_error_count      OUT NUMBER);


    PROCEDURE init_globals (p_sdh_id IN NUMBER);

    PROCEDURE validate_inv_data (p_sp_id         IN     NUMBER,
                                 p_sfs_id        IN     NUMBER,
                                 p_sdh_id        IN     NUMBER,
                                 p_error_count      OUT NUMBER)
    IS
        l_sql           CLOB;                              --VARCHAR2 (32767);
        l_dom_sql       CLOB;
        l_mand_sql      CLOB;
        l_length_sql    CLOB;
        l_ins_sql       CLOB;
        --
        l_error_count   NUMBER (38) := 0;
    ---
    BEGIN
        p_error_count := 0;

        init_globals (p_sdh_id);

        DELETE FROM SDL_VALIDATION_RESULTS
              WHERE svr_sfs_id = p_sfs_id;

        EXECUTE IMMEDIATE   'insert into sdl_row_status (srs_sfs_id, srs_sp_id, srs_tld_id, srs_record_no, srs_status) '
                         || ' select :p_sfs_id, :p_sp_id, tld_id, rownum, :p_hold '
                         || ' from '
                         || g_source_name
                         || ' where tld_sfs_id = :p_sfs_id '
                         || ' and not exists ( select 1 from sdl_row_status where srs_sfs_id = :p_sfs_id and srs_tld_id = tld_id )'
            USING p_sfs_id,
                  p_sp_id,
                  'H',
                  p_sfs_id,
                  p_sfs_id;

        UPDATE SDL_ROW_STATUS
           SET srs_status = 'H'
         WHERE srs_status IN ('V', 'E') AND srs_sfs_id = p_sfs_id;


        --        validate_xsp (p_sfs_id, p_sdh_id, l_error_count);

        p_error_count := p_error_count + l_error_count;

        nm_debug.debug_on;
        --
        l_ins_sql :=
               'INSERT INTO sdl_validation_results (svr_id, '
            || ' svr_sld_key, '
            || ' svr_sfs_id, '
            || ' svr_validation_type, '
            || ' svr_sam_id, '
            || ' svr_current_value, '
            || ' svr_status_code, '
            || ' svr_message) ';

        l_dom_sql := get_domain_validation_sql (p_sp_id, p_sfs_id, p_sdh_id);

        nm_debug.delete_debug (TRUE);

        --        nm_debug.debug (l_dom_sql);

        IF l_dom_sql IS NOT NULL
        THEN
            l_sql := l_ins_sql || l_dom_sql;

            nm_debug.debug (l_sql);

            EXECUTE IMMEDIATE l_sql
                USING p_sfs_id;

            --
            l_error_count := SQL%ROWCOUNT;
            p_error_count := p_error_count + l_error_count;
        END IF;

        l_mand_sql :=
            get_mandatory_validation_sql (p_sp_id, p_sfs_id, p_sdh_id);

        IF l_mand_sql IS NOT NULL
        THEN
            l_sql := l_ins_sql || l_mand_sql;

            nm_debug.debug (l_sql);

            EXECUTE IMMEDIATE l_sql
                USING p_sp_id, p_sdh_id, p_sfs_id;

            --
            l_error_count := SQL%ROWCOUNT;
            p_error_count := p_error_count + l_error_count;
        END IF;

        l_length_sql :=
            get_length_validation_sql (p_sp_id, p_sfs_id, p_sdh_id);

        IF l_length_sql IS NOT NULL
        THEN
            l_sql := l_ins_sql || l_length_sql;

            nm_debug.debug (l_sql);

            EXECUTE IMMEDIATE l_sql
                USING p_sp_id, p_sdh_id, p_sfs_id;

            --
            l_error_count := SQL%ROWCOUNT;
            p_error_count := p_error_count + l_error_count;
        END IF;




        --        validate_au (p_sfs_id, p_sdh_id, l_error_count);

        p_error_count := p_error_count + l_error_count;

        UPDATE sdl_row_status
           SET srs_status = 'E'
         WHERE srs_tld_id IN (SELECT svr_sld_key
                                FROM sdl_validation_results
                               WHERE svr_sfs_id = p_sfs_id);

        UPDATE sdl_row_status
           SET srs_status = 'V'
         WHERE NOT EXISTS
                   (SELECT 1
                      FROM sdl_validation_results
                     WHERE svr_sfs_id = p_sfs_id AND svr_sld_key = srs_tld_id);
    END;

    FUNCTION get_domain_validation_sql (p_sp_id    IN NUMBER,
                                        p_sfs_id   IN NUMBER,
                                        p_sdh_id   IN NUMBER)
        RETURN CLOB
    IS
        retval        CLOB;                                --VARCHAR2 (32767);
        l_ita_type    VARCHAR2 (4);
        l_sql_mand    VARCHAR2 (4000);
        l_sql_dom     VARCHAR2 (32767);
        l_sql_attr    CLOB;
        l_sql_len     VARCHAR2 (4000);
        l_sql_dp      VARCHAR2 (4000);
        l_sql_range   VARCHAR2 (4000);
        l_sql_qry     VARCHAR2 (4000);
    BEGIN
        --
        --        init_globals (p_sdh_id);

        nm3ctx.set_context ('STR_DELIMITER', ' OR ');

        --        select substr(attrib_str, 1, length(attrib_str)), substr(value_str, 1, length(value_str))
        SELECT attrib_str, value_str
          INTO l_sql_attr, l_sql_dom
          FROM (  SELECT clob_agg (
                                ' ( case ita_attrib_name '
                             || ' when '
                             || CHR (39)
                             || ita_attrib_name
                             || CHR (39)
                             || ' then 1 else 0 end '
                             || '   = ( select 1 from dual where '
                             || ita_view_attri
                             || ' is not null '
                             || ' and not exists ( SELECT 1 '
                             || '                          FROM nm_inv_attri_lookup '
                             || '                         WHERE     ial_domain = '
                             || CHR (39)
                             || ita_id_domain
                             || CHR (39)
                             || '                               AND ial_value = '
                             || ita_view_attri
                             || ' ) ) ) ')                             value_str,
                            ' case ita_attrib_name '
                         || LISTAGG (
                                   '  when '
                                || CHR (39)
                                || ita_attrib_name
                                || CHR (39)
                                || ' then '
                                || ita_view_attri
                                || ' ',
                                ' ')
                            WITHIN GROUP (ORDER BY ita_disp_seq_no)    attrib_str
                    FROM nm_inv_type_attribs
                   WHERE     ita_inv_type = g_inv_type
                         AND ita_id_domain IS NOT NULL
                ORDER BY ita_disp_seq_no);

        --

        nm_debug.debug ('sql_dom=' || l_sql_dom);

        IF l_sql_dom IS NULL
        THEN
            retval := NULL;
        ELSE
            retval :=
                   ' SELECT svr_id_seq.NEXTVAL, '
                || ' tld_id, '
                || ' tld_sfs_id, '
                || CHR (39)
                || 'L'
                || CHR (39)
                || ', '
                || ' sam_id, '
                || ' attr_value, '
                || ' -20751, '
                || CHR (39)
                || 'Value of '
                || CHR (39)
                || '||ita_view_attri||'
                || CHR (39)
                || ' not in domain list '
                || CHR (39)
                || '||ita_id_domain '
                || '  FROM ( '
                || 'WITH attribs AS '
                || '(SELECT ita_inv_type, '
                || '        ita_attrib_name, '
                || '        ita_view_attri, '
                || '        sam_id, '
                || '        ita_id_domain '
                || '   FROM nm_inv_type_attribs, sdl_attribute_mapping '
                || '  WHERE ita_inv_type = '
                || CHR (39)
                || g_inv_type
                || CHR (39)
                || '  and sam_ne_column_name = ita_attrib_name '
                || '  and ita_id_domain is not NULL '
                || '  and sam_sdh_id = '
                || p_sdh_id
                || ' ) '
                || ' SELECT tld_id, '
                || '       tld_sfs_id, '
                || '       ita_inv_type, '
                || '       ita_attrib_name, '
                || '       ita_view_attri, '
                || '       sam_id, '
                || '       ita_id_domain, '
                || l_sql_attr
                || ' end  attr_value '
                || '  FROM attribs, '
                || g_source_name
                || ' WHERE     ita_inv_type = '
                || CHR (39)
                || g_inv_type
                || CHR (39)
                || '             AND tld_sfs_id = :p_tld_sfs_id '
                || '       AND ( '
                || l_sql_dom
                || ') ) ';
        END IF;

        RETURN retval;
    END;

FUNCTION get_mandatory_validation_sql (
    p_sp_id    IN NUMBER,
    p_sfs_id   IN NUMBER,
    p_sdh_id   IN NUMBER)
    RETURN CLOB
IS
    retval       CLOB;
    l_ita_type   VARCHAR2 (4);
    l_sql_mand   CLOB;
    qq           CHAR (1) := CHR (39);
BEGIN
    --
    BEGIN
        WITH
            attribs
            AS
                (SELECT ita_inv_type,
                        ita_attrib_name,
                        ita_view_attri,
                        ita_disp_seq_no
                   FROM sdl_attribute_mapping,
                        nm_inv_type_attribs,
                        sdl_destination_header
                  WHERE     ita_view_attri = sam_view_column_name
                        AND sdh_sp_id = p_sp_id
                        AND sam_sp_id = sdh_sp_id
                        AND sdh_id = p_sdh_id
                        AND sdh_destination_type = ita_inv_type
                        AND ita_mandatory_yn = 'Y')
        SELECT LISTAGG (
                      '(  case ita_attrib_name when '
                   || ''''
                   || ita_attrib_name
                   || ''''
                   || ' then 1 else 0  end = case when '
                   || ita_view_attri
                   || ' is NULL then 0 else 2 end )',
                   ' OR ')
               WITHIN GROUP (ORDER BY ita_disp_seq_no)
          INTO l_sql_mand
          FROM attribs;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            l_sql_mand := NULL;
    END;

    IF l_sql_mand IS NOT NULL 
    THEN
        retval :=
            TO_CLOB (
                   'select svr_id_seq.nextval, tld_id, tld_sfs_id, '
                || qq
                || 'M'
                || qq
                || ', sam_id, NULL, -20750, '
                || qq
                || 'Mandatory Column missing'||qq
                || ' from ( '
                || ' with attribs as (SELECT sam_id, ita_inv_type, ita_attrib_name, ita_view_attri '
                || '            FROM sdl_attribute_mapping, '
                || '                 nm_inv_type_attribs, '
                || '                 sdl_destination_header '
                || '           WHERE     ita_view_attri = sam_view_column_name '
                || '                 AND sdh_sp_id = :p_sp_id '
                || '                 AND sam_sp_id = sdh_sp_id '
                || '                 AND sdh_id = :p_sdh_id '
                || '                 AND sdh_destination_type = ita_inv_type '
                || '                 AND ita_mandatory_yn = '
                || qq
                || 'Y'
                || qq
                || ') '
                || '  select * from attribs, '||g_source_name
                || ' where tld_sfs_id = :p_sfs_id and ('
                || l_sql_mand
                || '))');
    END IF;

    RETURN retval;
END;


FUNCTION get_length_validation_sql (
    p_sp_id    IN NUMBER,
    p_sfs_id   IN NUMBER,
    p_sdh_id   IN NUMBER)
    RETURN CLOB
IS
    retval          CLOB;
    l_ita_type      VARCHAR2 (4);
    l_attrib_list   CLOB;
    l_sql_length    CLOB;
    qq              CHAR (1) := CHR (39);
BEGIN
    --
    BEGIN
        --we need two quueries of the attributes - one for the list of attributes which will deliver the value into the validation results and the other for the complex set of where-clauses
        -- first the attrib names for the values
        WITH
            attribs
            AS
                (SELECT ita_inv_type,
                        ita_attrib_name,
                        ita_view_attri,
                        ita_disp_seq_no,
                        ita_format,
                        ita_fld_length,
                        ita_dec_places,
                        ita_case,
                        ita_min,
                        ita_max
                   FROM sdl_attribute_mapping,
                        nm_inv_type_attribs  a1,
                        sdl_destination_header
                  WHERE     ita_view_attri = sam_view_column_name
                        AND sdh_sp_id = p_sp_id
                        AND sam_sp_id = sdh_sp_id
                        AND sdh_id = p_sdh_id
                        AND sdh_destination_type = ita_inv_type
                        AND ita_id_domain IS NULL)
        SELECT    'case ita_attrib_name '
               || LISTAGG (
                         ' when '
                      || ''''
                      || ita_attrib_name
                      || ''''
                      || ' then '
                      || CASE ita_format
                             WHEN 'NUMBER'
                             THEN
                                 'to_char(' || ita_view_attri || ')'
                             WHEN 'DATE'
                             THEN
                                    'to_char('
                                 || ita_view_attri
                                 || ', '
                                 || ''''
                                 || 'DD-MON-YYYY'
                                 || ''''
                                 || ')'
                             ELSE
                                 ita_view_attri
                         END,
                      ' ')
                  WITHIN GROUP (ORDER BY ita_disp_seq_no)
               || ' end'
          INTO l_attrib_list
          FROM attribs;

        --now the where clauses

        WITH
            attribs
            AS
                (SELECT ita_inv_type,
                        ita_attrib_name,
                        ita_view_attri,
                        ita_disp_seq_no,
                        ita_format,
                        ita_fld_length,
                        ita_dec_places,
                        ita_case,
                        ita_min,
                        ita_max
                   FROM sdl_attribute_mapping,
                        nm_inv_type_attribs  a1,
                        sdl_destination_header
                  WHERE     ita_view_attri = sam_view_column_name
                        AND sdh_sp_id = p_sp_id
                        AND sam_sp_id = sdh_sp_id
                        AND sdh_id = p_sdh_id
                        AND sdh_destination_type = ita_inv_type
                        AND ita_id_domain IS NULL)
        SELECT LISTAGG (attrib_condition, ' OR ')
                   WITHIN GROUP (ORDER BY ita_disp_seq_no)
          INTO l_sql_length
          FROM (SELECT ita_view_attri,
                       ita_disp_seq_no,
                          ' ( case ita_attrib_name when '
                       || qq
                       || ita_attrib_name
                       || qq
                       || ' then 1 else 0 end = case when length( '
                       || ita_view_attri
                       || ') > '
                       || ita_fld_length
                       || ' then 1 else 2 end )'    attrib_condition
                  FROM attribs
                 WHERE ita_format = 'VARCHAR2'
                UNION ALL
                SELECT ita_view_attri,
                       ita_disp_seq_no,
                          ' ( case ita_attrib_name when '
                       || qq
                       || ita_attrib_name
                       || qq
                       || ' then 1 else 0 end = case when '
                       || ita_view_attri
                       || '> '
                       || ita_max
                       || ' then 1 else 2 end )'
                  FROM attribs
                 WHERE ita_format = 'NUMBER' AND ita_max IS NOT NULL
                UNION ALL
                SELECT ita_view_attri,
                       ita_disp_seq_no,
                          ' ( case ita_attrib_name when '
                       || qq
                       || ita_attrib_name
                       || qq
                       || ' then 1 else 0 end = case when '
                       || ita_view_attri
                       || ' < '
                       || ita_min
                       || ' then 1 else 2 end )'
                  FROM attribs
                 WHERE ita_format = 'NUMBER' AND ita_min IS NOT NULL
                UNION ALL
                SELECT ita_view_attri,
                       ita_disp_seq_no,
                          ' ( case ita_attrib_name when '
                       || qq
                       || ita_attrib_name
                       || qq
                       || ' then 1 else 0 end = case when '
                       || ita_view_attri
                       || '-trunc('
                       || ita_view_attri
                       || ') > 0 then 1 else 2 end )'
                  FROM attribs
                 WHERE ita_format = 'NUMBER' AND ita_dec_places IS NULL
                UNION ALL
                SELECT ita_view_attri,
                       ita_disp_seq_no,
                          ' ( case ita_attrib_name when '
                       || qq
                       || ita_attrib_name
                       || qq
                       || ' then 1 else 0 end = case when length(to_char(trunc('
                       || ita_view_attri
                       || '))) > '
                       || ita_fld_length
                       || ' then 1 else 2 end )'
                  FROM attribs
                 WHERE ita_format = 'NUMBER'
                UNION ALL
                SELECT ita_view_attri,
                       ita_disp_seq_no,
                          ' ( case ita_attrib_name when '
                       || qq
                       || ita_attrib_name
                       || qq
                       || ' then 1 else 0 end = case when nm3flx.str_is_numeric('
                       || ita_view_attri
                       || ') = '||''''||'FALSE'||''''
                       || ' then 1 else 2 end )'
                  FROM attribs
                 WHERE ita_format = 'NUMBER' );
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            l_sql_length := NULL;
    END;

    IF l_sql_length IS NOT NULL
    THEN
        retval :=
            TO_CLOB (
                   'select svr_id_seq.nextval, tld_id, tld_sfs_id, '
                || qq
                || 'M'
                || qq
                || ', sam_id, '
                || l_attrib_list
                || ' , -20750, '
                || qq
                || 'Length of field, range or decimal places violation '
                || qq
                || ' from ( '
                || ' with attribs as (SELECT sam_id, ita_inv_type, ita_attrib_name, ita_view_attri '
                || '            FROM sdl_attribute_mapping, '
                || '                 nm_inv_type_attribs, '
                || '                 sdl_destination_header '
                || '           WHERE     ita_view_attri = sam_view_column_name '
                || '                 AND sdh_sp_id = :p_sp_id '
                || '                 AND sam_sp_id = sdh_sp_id '
                || '                 AND sdh_id = :p_sdh_id '
                || '                 AND sdh_destination_type = ita_inv_type '
                || '                 AND ita_mandatory_yn = '
                || qq
                || 'Y'
                || qq
                || ') '
                || '  select * from attribs, '||g_source_name
                || ' where tld_sfs_id = :p_sfs_id and ('
                || l_sql_length
                || '))');
    END IF;

    RETURN retval;
END;


    PROCEDURE validate_au (p_sfs_id        IN     NUMBER,
                           p_sdh_id        IN     NUMBER,
                           p_error_count      OUT NUMBER)
    IS
        l_sql   VARCHAR2 (32767);
    BEGIN
        --
        EXECUTE IMMEDIATE   'insert into sdl_validation_results (svr_id, svr_sld_key, svr_sfs_id, svr_validation_type, svr_sam_id, svr_column_name, svr_current_value, svr_status_code, svr_message )'
                         || ' select tld_sfs_id, tld_id, 237, '
                         || qq
                         || 'NET-237: Admin unit '
                         || qq
                         || 'admin_unit'
                         || ' is invalid'
                         || qq
                         || ' from '
                         || g_source_name
                         || ' , sdl_destination_header '
                         || ' where tld_sfs_id = :p_tld_sfs_id '
                         || ' and sdh_id = :p_sdh_id '
                         || ' and not exists ( select 1 from nm_admin_units, nm_inv_types '
                         || ' where nit_admin_type = nau_admin_type '
                         || ' and nau_unit_code = admin_unit '
                         || ' and nit_inv_type = sdh_destination_type ) '
            USING p_sfs_id, p_sdh_id;
    END;

    PROCEDURE validate_au_privilege (p_sfs_id        IN     NUMBER,
                                     p_sdh_id        IN     NUMBER,
                                     p_error_count      OUT NUMBER)
    IS
        l_sql          VARCHAR2 (32767);
        l_table_name   VARCHAR2 (30);
    BEGIN
        p_error_count := 0;

        --
        IF g_unrestricted = 'TRUE'
        THEN
            NULL;
        ELSE
            --            init_globals (p_sdh_id);
            l_sql :=
                   'insert into sdl_validation_results (tld_sfs_id, tld_id, error_no, error_message ) '
                || ' select tld_sfs_id, tld_id, 241, '
                || qq
                || 'NET-241: You may not create data with admin unit = '
                || qq
                || '|| admin_unit'
                || ' from '
                || g_source_name
                || ' , sdl_destination_header '
                || ' where tld_sfs_id = :p_tld_sfs_id '
                || ' and sdh_id = :p_sdh_id '
                || ' and not exists ( select 1 from nm_user_aus, nm_admin_groups, nm_admin_units '
                || ' where nau_unit_code = admin_unit '
                || ' and nau_admin_unit = nag_child_admin_unit '
                || ' and nag_parent_admin_unit = nua_admin_unit '
                || ' and nua_user_id = :ctx_user_id   ) ';

            --nm_debug.debug(l_sql);
            EXECUTE IMMEDIATE l_sql
                USING p_sfs_id, p_sdh_id, SYS_CONTEXT ('NM3CORE', 'USER_ID');
        END IF;


        --

        p_error_count := SQL%ROWCOUNT;
    END;

    FUNCTION can_user_load_asset (p_sdh_id IN NUMBER)
        RETURN VARCHAR2
    IS
        retval   VARCHAR2 (10) := 'FALSE';
        l_sql    VARCHAR2 (4000);
    BEGIN
        --        init_globals (p_sdh_id);
        --
        retval := g_unrestricted;

        IF retval = 'FALSE'
        THEN
            BEGIN
                SELECT 'TRUE'
                  INTO retval
                  FROM hig_users, nm_inv_types
                 WHERE     hus_username =
                           SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
                       AND nit_inv_type = g_inv_type
                       AND (    (EXISTS
                                     (SELECT 1
                                        FROM hig_user_roles,
                                             nm_inv_type_roles
                                       WHERE     hur_username = hus_username
                                             AND hur_role = itr_hro_role
                                             AND itr_inv_type = nit_inv_type))
                            AND (EXISTS
                                     (SELECT 1
                                        FROM nm_inv_types,
                                             nm_user_aus,
                                             nm_admin_units,
                                             nm_admin_groups
                                       WHERE     nit_admin_type =
                                                 nau_admin_type
                                             AND nit_inv_type = g_inv_type
                                             AND nau_admin_unit =
                                                 nag_child_admin_unit
                                             AND nag_parent_admin_unit =
                                                 nua_admin_unit
                                             AND nua_user_id =
                                                 TO_NUMBER (
                                                     SYS_CONTEXT ('NM3CORE',
                                                                  'USER_ID')))));
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    retval := 'FALSE';
            --
            END;
        END IF;

        RETURN retval;
    END;

    PROCEDURE validate_xsp (p_sfs_id        IN     NUMBER,
                            p_sdh_id        IN     NUMBER,
                            p_error_count      OUT NUMBER)
    IS
        l_sql   VARCHAR2 (32767);
    BEGIN
        --      init_globals (p_sdh_id);

        -- first stage validation of XSPs - if the asset type does not support XSPs but XSP column is present in the table and populated then raise error

        nm_debug.debug (
            'Table and type = ' || g_source_name || ', ' || g_inv_type);

        BEGIN
            SELECT 'Y'
              INTO g_has_xsp_column
              FROM all_tab_columns
             WHERE     owner = SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
                   AND table_name = g_source_name
                   AND column_name = 'XSP';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                g_has_xsp_column := 'N';
        END;

        nm_debug.debug (
            'XSP Col = ' || g_has_xsp_column || ' use XSP = ' || g_use_xsp);

        IF g_has_xsp_column = 'Y' AND g_use_xsp = 'N'
        THEN
            raise_application_error (
                -20001,
                'XSP is in the holding table when asset does not support use of XSP');
        ELSIF g_has_xsp_column = 'N' AND g_use_xsp = 'Y'
        THEN
            raise_application_error (
                -20002,
                'XSP is not configured in the holding table when asset requires an XSP value');
        END IF;

        IF g_use_xsp = 'Y'
        THEN
            -- second stage validation - just check values against allowable ones
            l_sql :=
                   'insert into sdl_validation_results (svr_id, svr_sld_key, svr_sfs_id, svr_validation_type, svr_column_name, svr_current_value, svr_status_code, svr_message ) '
                || ' select svr_id_seq.nextval, tld_id, tld_sfs_id, '
                || qq
                || 'X'
                || qq
                || ', '
                || qq
                || 'XSP'
                || qq
                || ', xsp 46, '
                || qq
                || 'XSP value is not allowed'
                || qq
                || ' from '
                || g_source_name
                || ' where tld_sfs_id = :p_sfs_id '
                || ' and not exists ( select 1 from nm_xsp_restraints '
                || ' where xsr_ity_inv_code = '
                || qq
                || g_inv_type
                || qq
                || ' and xsr_x_sect_value = xsp ) ';
            --
            nm_debug.debug (l_sql);

            EXECUTE IMMEDIATE l_sql
                USING p_sfs_id;

            p_error_count := SQL%ROWCOUNT;

            -- Now where the network is valid and joins to the network element table, perform more detailed tests. This
            --is very messy to perform as dynamic SQL so populate the XSP in a nested table and use it in the dynamic SQL

            init_xsp_data (p_sfs_id, p_sdh_id);

            INSERT INTO sdl_validation_results (svr_sld_key,
                                                svr_sfs_id,
                                                svr_validation_type,
                                                svr_column_name,
                                                svr_current_value,
                                                svr_status_code,
                                                svr_message)
                  SELECT tld_id,
                         tld_sfs_id,
                         'X',
                         'XSP',
                         xsp,
                         46,
                            'XSP value '
                         || xsp
                         || ' is invalid for this network type/sub-class - '
                         || datum_nt_type
                         || '/'
                         || datum_sub_class
                    FROM (SELECT tld_sfs_id,
                                 tld_id,
                                 xsp,
                                 g.source_ne_id        route_ne_id,
                                 g.source_nt_type      route_nt_type,
                                 G.source_gty_type     route_group_type,
                                 d.ne_id               datum_ne_id,
                                 d.ne_nt_type          datum_nt_type,
                                 d.ne_sub_class        datum_sub_class
                            FROM sdl_xsp_data G, nm_members, nm_elements D
                           WHERE     D.ne_id = nm_ne_id_of
                                 AND nm_ne_id_in = G.source_ne_id
                                 AND NOT EXISTS
                                         (SELECT 1
                                            FROM xsp_restraints,
                                                 nm_nt_groupings
                                           WHERE     xsr_ity_inv_code =
                                                     g.inv_type
                                                 AND G.source_gty_type =
                                                     nng_group_type
                                                 AND xsr_nw_type = nng_nt_type
                                                 AND xsr_scl_class =
                                                     D.ne_sub_class
                                                 AND xsr_x_sect_value = xsp))
                GROUP BY tld_sfs_id,
                         tld_id,
                         xsp,
                         route_ne_id,
                         route_nt_type,
                         route_group_type,
                         datum_nt_type,
                         datum_sub_class;

            p_error_count := p_error_count + SQL%ROWCOUNT;

            UPDATE sdl_row_status s
               SET srs_status = 'E'
             WHERE     srs_sfs_id = p_sfs_id
                   AND EXISTS
                           (SELECT 1
                              FROM sdl_validation_results v
                             WHERE     v.svr_sfs_id = p_sfs_id
                                   AND s.srs_tld_id = v.SVR_SLD_KEY);
        END IF;
    END;

    PROCEDURE init_xsp_data (p_sfs_id IN NUMBER, p_sdh_id IN NUMBER)
    IS
    BEGIN
        DELETE FROM sdl_xsp_data;

        --
        EXECUTE IMMEDIATE   'insert into sdl_xsp_data (sdh_id, tld_sfs_id, tld_id, inv_type, xsp, source_ne_id, source_nlt_id, source_nt_type, source_gty_type ) '
                         || ' select :p_sdh_id, tld_sfs_id, tld_id, :p_inv_type, xsp, ne_id, nlt_id, ne_nt_type, ne_gty_group_type '
                         || ' from '
                         || g_source_name
                         || ', nm_elements, nm_linear_types '
                         || ' where nlt_id = 2 '
                         || ' and ne_nt_type = nlt_nt_type '
                         || ' and nvl(ne_gty_group_type, '
                         || qq
                         || '£$%^'
                         || qq
                         || ' ) = nvl (nlt_gty_type, '
                         || qq
                         || '£$%^'
                         || qq
                         || ' ) '
                         || ' and ne_unique = road_unique '
                         || ' and tld_sfs_id = :p_tld_sfs_id '
            USING p_sdh_id, g_inv_type, p_sfs_id;
    END;


    PROCEDURE init_globals (p_sdh_id IN NUMBER)
    IS
    BEGIN
        g_sdh_id := p_sdh_id;

        SELECT UPPER (
                      'V_TDL_'
                   || sp_id
                   || '_'
                   || sdh_id
                   || '_'
                   || nit_inv_type
                   || '_LD'),
               sdh_destination_type,
               nit_x_sect_allow_flag
          INTO g_source_name, g_inv_type, g_use_xsp
          FROM sdl_destination_header, nm_inv_types, sdl_profiles
         WHERE     sdh_id = p_sdh_id
               AND nit_inv_type = sdh_destination_type
               AND sdh_sp_id = sp_id;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            g_source_name := 'NM_LD_SPDL_LOADER_TMP';
            g_inv_type := 'SPDL';
    END;

    PROCEDURE make_tdl_attribute_adjustments (p_sp_id    IN NUMBER,
                                              p_sfs_id   IN NUMBER)
    IS
        l_sql                VARCHAR2 (32767);
        l_table_names        NM3TYPE.tab_varchar80;
        l_container_names    NM3TYPE.tab_varchar30;
        --
        l_container_attrib   NM3TYPE.tab_varchar30;
        l_dest_attrib        NM3TYPE.tab_varchar30;

        --
        CURSOR grab_containers (c_sp_id IN NUMBER)
        IS
            SELECT tpc_container,
                      'TDL_'
                   || tpc_profile_name
                   || '_'
                   || tpc_container
                   || '_LD'
              FROM v_tdl_profile_containers
             WHERE tpc_sp_id = c_sp_id;

        --
        CURSOR grab_attrib_list (c_sp_id IN NUMBER, c_container IN VARCHAR2)
        IS
              SELECT sam_file_attribute_name, saar_target_attribute_name
                FROM sdl_attribute_adjustment_rules,
                     sdl_attribute_mapping,
                     sdl_profile_file_columns
               WHERE     saar_sp_id = 87
                     AND sam_sp_id = saar_sp_id
                     AND spfc_sp_id = sam_sp_id
                     AND sam_view_column_name = saar_target_attribute_name
            GROUP BY sam_file_attribute_name, saar_target_attribute_name;

        --
        FUNCTION get_saar_case_statement (p_sp_id         IN NUMBER,
                                          p_container     IN VARCHAR2,
                                          p_attrib_name   IN VARCHAR2)
            RETURN VARCHAR2
        AS
            retval   VARCHAR2 (4000);
        BEGIN
              SELECT    'case '
                     || sam_file_attribute_name
                     || LISTAGG (
                               ' when '
                            || CHR (39)
                            || saar_source_value
                            || CHR (39)
                            || ' then '
                            || CHR (39)
                            || saar_adjust_to_value
                            || CHR (39),
                            CHR (13))
                        WITHIN GROUP (ORDER BY saar_id)
                     || ' else '
                     || sam_file_attribute_name
                     || ' end '
                INTO retval
                FROM sdl_attribute_adjustment_rules,
                     sdl_attribute_mapping,
                     sdl_profile_file_columns
               WHERE     saar_sdh_id = sam_sdh_id
                     AND sam_file_attribute_name = spfc_col_name
                     AND saar_target_attribute_name = p_attrib_name
                     AND saar_sp_id = sam_sp_id
                     AND spfc_sp_id = sam_sp_id
                     AND saar_sp_id = p_sp_id
                     AND sam_view_column_name = saar_target_attribute_name
                     AND spfc_container = p_container
            GROUP BY sam_file_attribute_name;

            --
            RETURN retval;
        END;
    --
    BEGIN
        -- grab array of all containers
        OPEN grab_containers (p_sp_id);

        FETCH grab_containers
            BULK COLLECT INTO l_container_names, l_table_names;

        CLOSE grab_containers;

        --
        --  loop over all containers in the profile
        --
        FOR i IN 1 .. l_container_names.COUNT
        LOOP
            OPEN grab_attrib_list (p_sp_id, l_container_names (i));

            FETCH grab_attrib_list
                BULK COLLECT INTO l_container_attrib, l_dest_attrib;

            CLOSE grab_attrib_list;

            BEGIN
                FOR j IN 1 .. l_container_attrib.COUNT
                LOOP
                    l_sql :=
                           'update '
                        || l_table_names (i)
                        || ' set '
                        || l_container_attrib (i)
                        || ' = '
                        || get_saar_case_statement (p_sp_id,
                                                    l_container_names (i),
                                                    l_dest_attrib (j))
                        || ' where tld_sfs_id = :p_sfs_id';

                    --                BEGIN
                    --                    nm_debug.debug (l_sql);
                    --                END;

                    EXECUTE IMMEDIATE l_sql
                        USING p_sfs_id;
                END LOOP;
            END;
        END LOOP;
    END;
END;
/