CREATE OR REPLACE PACKAGE BODY lb_reg
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_reg.pkb-arc   1.0   Jan 14 2015 15:36:18   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_reg.pkb  $
--       Date into PVCS   : $Date:   Jan 14 2015 15:36:18  $
--       Date fetched Out : $Modtime:   Jan 14 2015 15:34:48  $
--       PVCS Version     : $Revision:   1.0  $
--
AS
   NOT_EXISTS   EXCEPTION;
   PRAGMA EXCEPTION_INIT (NOT_EXISTS, -942);

   PROCEDURE create_lb_view (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE);

   PROCEDURE create_lb_sdo_view (
      pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE);

--
-----------------------------------------------------------------------------
--

   FUNCTION get_version RETURN varchar2 IS
   BEGIN
      RETURN g_sccsid;
   END get_version;
--
-----------------------------------------------------------------------------
--
   FUNCTION get_body_version RETURN varchar2 IS
   BEGIN
      RETURN g_body_sccsid;
   END get_body_version;
--
-----------------------------------------------------------------------------
--
	  
	  
   PROCEDURE register_lb_asset_type (
      pi_lb_object_type   IN INTEGER,
      pi_LB_asset_class   IN VARCHAR2,
      pi_exor_type        IN VARCHAR2,
      pi_xsp_flag         IN BOOLEAN,
      pi_nlt_id           IN INTEGER DEFAULT NULL,
      pi_role             IN VARCHAR2 DEFAULT NULL,
      pi_role_mode        IN VARCHAR2 DEFAULT 'NORMAL',
      pi_start_date       IN DATE DEFAULT TRUNC (SYSDATE),
      pi_p_or_c           IN VARCHAR2 DEFAULT 'C',
      pi_security_type    IN VARCHAR2 DEFAULT 'NONE')
   IS
      l_nlt_ids   int_array;
   --
   BEGIN
      IF pi_nlt_id IS NOT NULL
      THEN
         l_nlt_ids := int_array (int_array_type (pi_nlt_id));
      END IF;

      register_lb_asset_type (pi_lb_object_type   => pi_lb_object_type,
                              pi_LB_asset_class   => pi_LB_asset_class,
                              pi_exor_type        => pi_exor_type,
                              pi_xsp_flag         => pi_xsp_flag,
                              pi_nlt_ids          => l_nlt_ids,
                              pi_role             => pi_role,
                              pi_role_mode        => pi_role_mode,
                              pi_start_date       => pi_start_date,
                              pi_p_or_c           => pi_p_or_c,
                              pi_security_type    => pi_security_type);
   END;


   PROCEDURE register_lb_asset_type (
      pi_lb_object_type   IN INTEGER,
      pi_LB_asset_class   IN VARCHAR2,
      pi_exor_type        IN VARCHAR2,
      pi_xsp_flag         IN BOOLEAN,
      pi_nlt_ids          IN INT_ARRAY DEFAULT NULL,
      pi_role             IN VARCHAR2 DEFAULT NULL,
      pi_role_mode        IN VARCHAR2 DEFAULT 'NORMAL',
      pi_start_date       IN DATE DEFAULT TRUNC (SYSDATE),
      pi_p_or_c           IN VARCHAR2 DEFAULT 'C',
      pi_security_type    IN VARCHAR2 DEFAULT 'NONE')
   IS
      --
      l_xsp   VARCHAR2 (1);
   BEGIN
      IF pi_xsp_flag
      THEN
         l_xsp := 'Y';
      ELSE
         l_xsp := 'N';
      END IF;

      IF pi_nlt_ids.is_empty
      THEN
         raise_application_error (-20001, 'LB assets must be on-network');
      END IF;

      create_lb_view (pi_exor_type);

      --  register exor inv type

      --
      NM3INV.CREATE_FT_ASSET_FROM_TABLE ('V_LB_' || pi_exor_type,
                                         'EXOR_ID',
                                         pi_exor_type,
                                         pi_lB_asset_class,
                                         pi_start_date,
                                         pi_p_or_c,
                                         'N',
                                         NULL,
                                         NULL,
                                         'NE_ID',
                                         'BEGIN_MP',
                                         'END_MP',
                                         0,
                                         pi_security_type,
                                         pi_role,
                                         pi_role_mode);

      --
      UPDATE nm_inv_types
         SET nit_category = 'L', nit_x_sect_allow_flag = l_xsp
       WHERE nit_inv_type = pi_exor_type;

      --
      INSERT INTO nm_inv_nw (nin_nw_type,
                             nin_nit_inv_code,
                             nin_loc_mandatory,
                             nin_start_date,
                             nin_end_date)
         SELECT nlt_nt_type,
                pi_exor_type,
                'N',
                pi_start_date,
                NULL
           FROM nm_linear_types, TABLE (pi_nlt_ids.ia)
          WHERE nlt_g_i_d = 'D' AND nlt_id = COLUMN_VALUE;

      IF pi_lb_object_type IS NOT NULL
      THEN
         INSERT
           INTO LB_TYPES (LB_OBJECT_TYPE, LB_ASSET_GROUP, LB_EXOR_INV_TYPE)
         VALUES (pi_lb_object_type, pi_LB_asset_class, pi_exor_type);
      END IF;

      --
      INSERT INTO LB_INV_SECURITY (LB_EXOR_INV_TYPE, LB_SECURITY_TYPE)
           VALUES (pi_exor_type, pi_security_type);

      --
      create_lb_sdo_view (pi_exor_type);
   END;



   PROCEDURE create_lb_view (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE)
   IS
      l_str   VARCHAR2 (2000)
         :=    'create or replace view V_LB_'
            || pi_inv_type
            || ' as '
            || 'select nm_ne_id_in exor_id, '
            || '       nm_ne_id_of ne_id, '
            || '       nm_begin_mp begin_mp, '
            || '       nm_end_mp   end_mp, '
            || '       nm_security_id, '
            || '       nal_descr, '
            || '       nal_jxp, '
            || '       nm_start_date, '
            || '       nm_end_date '
            || ' from nm_locations, nm_asset_locations '
            || ' where nm_obj_type = '
            || ''''
            || pi_inv_type
            || ''''
            || ' and nal_id = nm_ne_id_in';
   --
   BEGIN
      EXECUTE IMMEDIATE l_str;
   END;

   --
   PROCEDURE create_lb_sdo_view (
      pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE)
   IS
      l_str   VARCHAR2 (2000)
         :=    'create or replace view v_lb_'
            || pi_inv_type
            || '_sdo as '
            || ' select nal_id, nal_asset_id asset_id, nm_loc_id objectid, nm_ne_id_of ne_id, nm_begin_mp, nm_end_mp, nal_jxp, nal_descr, nm_start_date, nm_end_date, nlg_geometry geoloc '
            || ' from nm_asset_locations, nm_locations, nm_location_geometry '
            || ' where nal_id = nm_ne_id_in  '
            || ' and nal_nit_type = '
            || ''''
            || pi_inv_type
            || ''''
            || ' and nm_obj_type = nal_nit_type '
            || ' and nlg_loc_id = nm_loc_id ';
   BEGIN
      EXECUTE IMMEDIATE l_str;
   END;

   --
   PROCEDURE drop_lb_asset_type (pi_lb_object_type   IN INTEGER,
                                 pi_exor_type        IN VARCHAR2)
   IS
      l_exor_type   lb_types.lb_exor_inv_type%TYPE := pi_exor_type;
   BEGIN
      IF l_exor_type IS NULL
      THEN
         BEGIN
            SELECT lb_exor_inv_type
              INTO l_exor_type
              FROM lb_types
             WHERE lb_object_type = pi_lb_object_type;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END IF;

      IF l_exor_type IS NOT NULL
      THEN
         drop_lb_asset_type (l_exor_type);
      END IF;

      --
      DELETE FROM lb_types
            WHERE     lb_object_type = pi_lb_object_type
                  AND lb_exor_inv_type = NVL (l_exor_type, lb_exor_inv_type);
   END;

   --
   PROCEDURE drop_lb_asset_type (pi_exor_type IN VARCHAR2)
   IS
   BEGIN
      --
      BEGIN
         nm3sdm.drop_layers_by_inv_type (pi_exor_type);
      END;

      DELETE FROM nm_inv_nw
            WHERE nin_nit_inv_code = pi_exor_type;

      DELETE FROM lb_inv_security
            WHERE lb_exor_inv_type = pi_exor_type;

      DELETE FROM nm_inv_type_roles
            WHERE itr_inv_type = pi_exor_type;

      DELETE FROM NM_ASSET_LOCATIONS_ALL
            WHERE nal_nit_type = pi_exor_type;

      DELETE FROM nm_location_geometry
            WHERE nlg_obj_type = pi_exor_type;

      DELETE FROM nm_locations_all
            WHERE nm_obj_type = pi_exor_type;

      DELETE FROM nm_inv_type_attribs
            WHERE ita_inv_type = pi_exor_type;

      DELETE FROM nm_inv_types_all
            WHERE nit_inv_type = pi_exor_type;

      BEGIN
         EXECUTE IMMEDIATE 'drop view V_LB_' || pi_exor_type;
      EXCEPTION
         WHEN not_exists
         THEN
            NULL;
      END;

      BEGIN
         EXECUTE IMMEDIATE 'drop view V_LB_' || pi_exor_type || '_SDO';
      EXCEPTION
         WHEN not_exists
         THEN
            NULL;
      END;
   END;
END;
/