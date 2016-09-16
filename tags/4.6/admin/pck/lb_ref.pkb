CREATE OR REPLACE PACKAGE BODY lb_ref
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_ref.pkb-arc   1.8   Sep 16 2016 15:00:30   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_ref.pkb  $
   --       Date into PVCS   : $Date:   Sep 16 2016 15:00:30  $
   --       Date fetched Out : $Modtime:   Sep 16 2016 14:58:36  $
   --       PVCS Version     : $Revision:   1.8  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for handling reference data
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.8  $';

   g_package_name   CONSTANT VARCHAR2 (30) := 'lb_ref';

   --
   -----------------------------------------------------------------------------
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
   -----------------------------------------------------------------------------
   --

   FUNCTION get_linear_types (pi_inv_type IN nm_inv_types.nit_inv_type%TYPE)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      nm3ctx.set_context ('NLT_DATA_INV_TYPE', pi_inv_type);

      OPEN retval FOR SELECT * FROM v_nm_nlt_data;

      RETURN retval;
   END;

   FUNCTION get_linear_types_tab (
      pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE)
      RETURN lb_linear_type_tab
   IS
      retval   lb_linear_type_tab;
   BEGIN
      SELECT lb_linear_type (nlt_id,
                             nt_type,
                             nlt_g_i_d,
                             nt_descr,
                             un_unit_name,
                             un_format_mask)
        BULK COLLECT INTO retval
        FROM v_nm_nlt_data;

      RETURN retval;
   END;

   --
   FUNCTION get_linear_refnt (
      pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE DEFAULT NULL,
      pi_nlt_id     IN nm_linear_types.nlt_id%TYPE DEFAULT NULL,
      pi_unique     IN VARCHAR2 DEFAULT NULL)
      RETURN SYS_REFCURSOR
   IS
      RETVAL   SYS_REFCURSOR;
   BEGIN
      nm3ctx.set_context ('NLT_DATA_INV_TYPE', pi_inv_type);
      nm3ctx.set_context ('NLT_DATA_NLT_ID', TO_CHAR (pi_nlt_id));
      nm3ctx.set_context ('NLT_DATA_UNIQUE', pi_unique);

      OPEN retval FOR SELECT * FROM v_nm_nlt_refnts;

      RETURN retval;
   END;

   FUNCTION get_linear_refnt_tab (
      pi_inv_type   IN nm_inv_types.nit_inv_type%TYPE DEFAULT NULL,
      pi_nlt_id     IN nm_linear_types.nlt_id%TYPE DEFAULT NULL,
      pi_unique     IN VARCHAR2 DEFAULT NULL)
      RETURN lb_linear_refnt_tab
   IS
      RETVAL   LB_LINEAR_REFNT_TAB;
   BEGIN
      nm3ctx.set_context ('NLT_DATA_INV_TYPE', pi_inv_type);
      nm3ctx.set_context ('NLT_DATA_NLT_ID', TO_CHAR (pi_nlt_id));
      nm3ctx.set_context ('NLT_DATA_UNIQUE', pi_unique);

      SELECT lb_linear_refnt (nlt_id,
                              ne_id,
                              ne_unique,
                              ne_descr,
                              nt_type,
                              nt_descr,
                              un_unit_name)
        BULK COLLECT INTO retval
        FROM v_nm_nlt_refnts;

      RETURN retval;
   END;

   --
   FUNCTION get_refnt_measures (pi_ne_id IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
      RETVAL   SYS_REFCURSOR;
   BEGIN
      nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (pi_ne_id));

      OPEN retval FOR SELECT * FROM v_nm_nlt_measures;

      RETURN retval;
   END;

   FUNCTION get_refnt_measures_tab (pi_ne_id IN INTEGER)
      RETURN LB_REFNT_MEASURE_TAB
   IS
      retval   LB_REFNT_MEASURE_TAB;
   BEGIN
      nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (pi_ne_id));

      SELECT LB_REFNT_MEASURE (ne_id,
                               ne_unique,
                               start_measure,
                               end_measure,
                               unit_name)
        BULK COLLECT INTO retval
        FROM v_nm_nlt_measures;

      RETURN retval;
   END;

   --
   FUNCTION get_unit (pi_unit_name      IN VARCHAR2,
                      pi_network_type   IN INTEGER,
                      pi_value          IN NUMBER)
      RETURN NUMBER
   IS
      retval   NUMBER;
   BEGIN
      SELECT pi_value * uc_conversion_factor
        INTO retval
        FROM nm_linear_types, nm_units, nm_unit_conversions
       WHERE     uc_unit_id_in = un_unit_id
             AND un_unit_name = pi_unit_name
             AND uc_unit_id_out = nlt_units
             AND nlt_id = pi_network_type
      UNION ALL
      SELECT pi_value
        FROM nm_linear_types, nm_units
       WHERE     nlt_units = un_unit_id
             AND un_unit_name = pi_unit_name
             AND nlt_id = pi_network_type;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001,
                                  'Invalid Unit Name and network Type');
      WHEN OTHERS
      THEN
         RAISE;
   END;

   FUNCTION GetLocationIDs (AssetType IN INTEGER, AssetID IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      OPEN retval FOR
         SELECT nal_id      LocationId,
                NAL_DESCR   LocationDescription,
                NJX_CODE    JXP,
                NJX_MEANING JXP_DESCR
           FROM NM_ASSET_LOCATIONS,
                LB_TYPES,
                NM_ASSET_TYPE_JUXTAPOSITIONS,
                NM_JUXTAPOSITIONS
          WHERE     NAL_ASSET_ID = AssetId
                AND NAL_NIT_TYPE = LB_EXOR_INV_TYPE
                AND LB_OBJECT_TYPE = AssetType
                AND njx_njxt_id(+) = najx_njxt_id
                AND najx_inv_type(+) = lb_exor_inv_type
                AND nal_jxp = njx_code(+);

      RETURN retval;
   END;

   FUNCTION GetLocationIDs_tab (AssetType IN INTEGER, AssetID IN INTEGER)
      RETURN lb_location_id_tab
   IS
      retval   lb_location_id_tab;
   BEGIN
      SELECT lb_location_id (nal_id,
                             NAL_DESCR,
                             NJX_CODE,
                             NJX_MEANING)
        BULK COLLECT INTO retval
        FROM NM_ASSET_LOCATIONS,
             LB_TYPES,
             NM_ASSET_TYPE_JUXTAPOSITIONS,
             NM_JUXTAPOSITIONS
       WHERE     NAL_ASSET_ID = AssetId
             AND NAL_NIT_TYPE = LB_EXOR_INV_TYPE
             AND LB_OBJECT_TYPE = AssetType
             AND njx_njxt_id(+) = najx_njxt_id
             AND najx_inv_type(+) = lb_exor_inv_type
             AND nal_jxp = njx_code(+);

      RETURN retval;
   END;

   --
   --
   FUNCTION GetXSPList (LocationId IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      OPEN retval FOR
         SELECT DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
           FROM nm_xsp_restraints, nm_locations, nm_elements
          WHERE     nm_ne_id_in = LocationId
                AND ne_id = nm_ne_id_of
                AND ne_nt_type = xsr_nw_type
                AND ne_sub_class = xsr_scl_class
                AND xsr_ity_inv_code = nm_obj_type
         UNION
         SELECT DISTINCT xsr_x_sect_value, xsr_descr
           FROM nm_xsp_restraints,
                nm_locations l,
                nm_elements,
                nm_members   r
          WHERE     l.nm_ne_id_in = LocationId
                AND r.nm_ne_id_of = l.nm_ne_id_of
                AND ne_id = r.nm_ne_id_in
                AND ne_nt_type = xsr_nw_type
                AND r.nm_obj_type = ne_gty_group_type
                AND ne_sub_class = xsr_scl_class
                AND xsr_ity_inv_code = l.nm_obj_type;

      RETURN RETVAL;
   END;

   --
   FUNCTION GetXSP_TAB (LocationId IN INTEGER)
      RETURN LB_XSP_TAB
   IS
      retval   LB_XSP_TAB;
   BEGIN
      SELECT LB_XSP (XSP, XSP_DESCR)
        BULK COLLECT INTO RETVAL
        FROM (SELECT DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
                FROM nm_xsp_restraints, nm_locations, nm_elements
               WHERE     nm_ne_id_in = LocationId
                     AND ne_id = nm_ne_id_of
                     AND ne_nt_type = xsr_nw_type
                     AND ne_sub_class = xsr_scl_class
                     AND xsr_ity_inv_code = nm_obj_type
              UNION
              SELECT DISTINCT xsr_x_sect_value, xsr_descr
                FROM nm_xsp_restraints,
                     nm_locations l,
                     nm_elements,
                     nm_members   r
               WHERE     l.nm_ne_id_in = LocationId
                     AND r.nm_ne_id_of = l.nm_ne_id_of
                     AND ne_id = r.nm_ne_id_in
                     AND ne_nt_type = xsr_nw_type
                     AND r.nm_obj_type = ne_gty_group_type
                     AND ne_sub_class = xsr_scl_class
                     AND xsr_ity_inv_code = l.nm_obj_type);

      RETURN RETVAL;
   END;

   FUNCTION GetXSPList (Inv_type           IN VARCHAR2,
                        NetworkElementID   IN INTEGER,
                        StartDistance      IN NUMBER,
                        EndDistance        IN NUMBER)
      RETURN SYS_REFCURSOR
   IS
      retval     SYS_REFCURSOR;
      l_nlt_id   INTEGER;
   BEGIN
      nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (NetworkElementId));
      nm3ctx.set_context ('START_MEASURE', TO_CHAR (StartDistance));
      nm3ctx.set_context ('END_MEASURE', TO_CHAR (EndDistance));
      nm3ctx.set_context ('NLT_DATA_INV_TYPE', Inv_Type);

      --
      SELECT nlt_id
        INTO l_nlt_id
        FROM nm_linear_types, nm_elements
       WHERE     ne_id = NetworkElementId
             AND ne_nt_type = nlt_nt_type
             AND NVL (ne_gty_group_type, '�$%^') =
                    NVL (nlt_gty_type, '�$%^');

      NM3CTX.SET_CONTEXT ('NLT_DATA_NLT_ID', TO_CHAR (l_nlt_id));

      OPEN retval FOR SELECT xsp, xsp_descr FROM v_lb_xsp_list;

      RETURN RETVAL;
   END;

   FUNCTION GetXSP_Tab (Inv_type           IN VARCHAR2,
                        NetworkElementID   IN INTEGER,
                        StartDistance      IN NUMBER,
                        EndDistance        IN NUMBER)
      RETURN lb_xsp_tab
   IS
      retval     lb_xsp_tab;
      l_nlt_id   INTEGER;
   BEGIN
      nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (NetworkElementId));
      nm3ctx.set_context ('START_MEASURE', TO_CHAR (StartDistance));
      nm3ctx.set_context ('END_MEASURE', TO_CHAR (EndDistance));
      nm3ctx.set_context ('NLT_DATA_INV_TYPE', Inv_Type);

      --
      SELECT nlt_id
        INTO l_nlt_id
        FROM nm_linear_types, nm_elements
       WHERE     ne_id = NetworkElementId
             AND ne_nt_type = nlt_nt_type
             AND NVL (ne_gty_group_type, '�$%^') =
                    NVL (nlt_gty_type, '�$%^');

      NM3CTX.SET_CONTEXT ('NLT_DATA_NLT_ID', TO_CHAR (l_nlt_id));

      SELECT lb_xsp (xsp, xsp_descr)
        BULK COLLECT INTO retval
        FROM v_lb_xsp_list;

      RETURN RETVAL;
   END;

   FUNCTION GetXSPList (AssetType           IN INTEGER,
                        NetworkTypeID       IN INTEGER,
                        NetworkElementID    IN INTEGER,
                        StartDistance       IN NUMBER,
                        StartDistanceUnit   IN VARCHAR2,
                        EndDistance         IN NUMBER,
                        EndDistanceUnit     IN VARCHAR2)
      RETURN SYS_REFCURSOR
   IS
      retval       SYS_REFCURSOR;
      l_inv_type   VARCHAR2 (4);
      l_startM     NUMBER;
      l_endM       NUMBER;
   --
   BEGIN
      IF AssetType IS NULL
      THEN
         raise_application_error (-20001, 'AssetType must be supplied');
      ELSE
         BEGIN
            SELECT lb_exor_inv_type
              INTO l_inv_type
              FROM lb_types
             WHERE lb_object_type = AssetType;

            nm3ctx.set_context ('NLT_DATA_INV_TYPE', l_inv_type);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20002,
                  'No matching Inventory type for AssetType ' || AssetType);
         END;
      END IF;

      l_startM :=
         lb_ref.get_unit (StartDistanceUnit, NetworkTypeId, StartDistance);
      l_endM := lb_ref.get_unit (EndDistanceUnit, NetworkTypeId, EndDistance);

      IF NetworkElementID IS NULL OR AssetType IS NULL
      THEN
         raise_application_error (
            -20003,
            'No network details on which to base XSP lookup');
      END IF;

      --   Convert units to exor base units from eB uniot translations

      nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (NetworkElementId));
      nm3ctx.set_context ('START_MEASURE', TO_CHAR (StartDistance));
      nm3ctx.set_context ('END_MEASURE', TO_CHAR (EndDistance));

      --
      OPEN retval FOR SELECT xsp, xsp_descr FROM v_lb_xsp_list;

      RETURN RETVAL;
   END;

   FUNCTION GetXSP_tab (AssetType           IN INTEGER,
                        NetworkTypeID       IN INTEGER,
                        NetworkElementID    IN INTEGER,
                        StartDistance       IN NUMBER,
                        StartDistanceUnit   IN VARCHAR2,
                        EndDistance         IN NUMBER,
                        EndDistanceUnit     IN VARCHAR2)
      RETURN lb_xsp_tab
   IS
      retval       lb_xsp_tab;
      l_inv_type   VARCHAR2 (4);
      l_startM     NUMBER;
      l_endM       NUMBER;
   --
   BEGIN
      IF AssetType IS NULL
      THEN
         raise_application_error (-20001, 'AssetType must be supplied');
      ELSE
         BEGIN
            SELECT lb_exor_inv_type
              INTO l_inv_type
              FROM lb_types
             WHERE lb_object_type = AssetType;

            nm3ctx.set_context ('NLT_DATA_INV_TYPE', l_inv_type);
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               raise_application_error (
                  -20002,
                  'No matching Inventory type for AssetType ' || AssetType);
         END;
      END IF;

      l_startM :=
         lb_ref.get_unit (StartDistanceUnit, NetworkTypeId, StartDistance);
      l_endM := lb_ref.get_unit (EndDistanceUnit, NetworkTypeId, EndDistance);

      IF NetworkElementID IS NULL OR AssetType IS NULL
      THEN
         raise_application_error (
            -20003,
            'No network details on which to base XSP lookup');
      END IF;

      --   Convert units to exor base units from eB uniot translations

      nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (NetworkElementId));
      nm3ctx.set_context ('START_MEASURE', TO_CHAR (StartDistance));
      nm3ctx.set_context ('END_MEASURE', TO_CHAR (EndDistance));

      --
      SELECT lb_xsp (xsp, xsp_descr)
        BULK COLLECT INTO retval
        FROM v_lb_xsp_list;

      RETURN RETVAL;
   END;


   FUNCTION getJXP (AssetType IN INTEGER)
      RETURN SYS_REFCURSOR
   IS
      retval   SYS_REFCURSOR;
   BEGIN
      OPEN retval FOR
         SELECT NJX_CODE, NJX_MEANING
           FROM NM_ASSET_TYPE_JUXTAPOSITIONS, NM_JUXTAPOSITIONS, LB_TYPES
          WHERE     njx_njxt_id = najx_njxt_id
                AND lb_object_type = AssetType
                AND najx_inv_type = lb_exor_inv_type;

      RETURN retval;
   END;

   FUNCTION getJXP_TAB (AssetType IN INTEGER)
      RETURN lb_jxp_tab
   IS
      retval   lb_jxp_tab;
   BEGIN
      SELECT lb_jxp (NJX_CODE, NJX_MEANING)
        BULK COLLECT INTO retval
        FROM NM_ASSET_TYPE_JUXTAPOSITIONS, NM_JUXTAPOSITIONS, LB_TYPES
       WHERE     njx_njxt_id = najx_njxt_id
             AND lb_object_type = AssetType
             AND najx_inv_type = lb_exor_inv_type;

      RETURN retval;
   END;


   FUNCTION GETASSETYPENETWORKTYPES (AssetType IN INTEGER DEFAULT NULL)
      RETURN SYS_REFCURSOR
   IS
      retval         SYS_REFCURSOR;
      p_asset_type   INTEGER := AssetType;
   BEGIN
      OPEN retval FOR
         SELECT AssetType,
                NetworkTypeId,
                NetworkTypeName,
                NetworkTypeDescr,
                UnitName
           FROM v_lb_inv_nlt_data
          WHERE AssetType = NVL (p_asset_type, AssetType);

      RETURN retval;
   END;


   FUNCTION GETASSETYPENETWORKTYPE_TAB (AssetType IN INTEGER DEFAULT NULL)
      RETURN lb_asset_type_network_tab
   IS
      retval         lb_asset_type_network_tab;
      p_asset_type   INTEGER := AssetType;
   BEGIN
      SELECT lb_asset_type_network (AssetType,
                                    NetworkTypeId,
                                    NetworkType,
                                    NetworkTypeName,
                                    NetworkFlag,
                                    NetworkTypeDescr,
                                    UnitName,
                                    UnitMask)
        BULK COLLECT INTO retval
        FROM v_lb_inv_nlt_data
       WHERE AssetType = NVL (p_asset_type, AssetType);

      RETURN retval;
   END;

   FUNCTION GETASSETNETWORKELEMENTS (
      ASSETTYPE        IN INTEGER DEFAULT NULL,
      NETWORKTYPEID    IN INTEGER DEFAULT NULL,
      NETWORKELEMENT   IN VARCHAR2 DEFAULT NULL)
      RETURN SYS_REFCURSOR
   IS
      RETVAL           SYS_REFCURSOR;
      l_nit_inv_type   nm_inv_types.nit_inv_type%TYPE;
   BEGIN
      BEGIN
         SELECT lb_exor_inv_type
           INTO l_nit_inv_type
           FROM lb_types
          WHERE lb_object_type = ASSETTYPE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_nit_inv_type := NULL;
      END;

      --
      nm3ctx.set_context ('NLT_DATA_INV_TYPE', l_nit_inv_type);
      nm3ctx.set_context ('NLT_DATA_NLT_ID', TO_CHAR (NETWORKTYPEID));
      nm3ctx.set_context ('NLT_DATA_UNIQUE', NETWORKELEMENT);

      OPEN retval FOR SELECT * FROM v_nm_nlt_refnts;

      RETURN retval;
   END;


   FUNCTION GETASSETNETWORKELEMENTS_TAB (
      ASSETTYPE        IN INTEGER DEFAULT NULL,
      NETWORKTYPEID    IN INTEGER DEFAULT NULL,
      NETWORKELEMENT   IN VARCHAR2 DEFAULT NULL)
      RETURN lb_linear_refnt_tab
   IS
      RETVAL           LB_LINEAR_REFNT_TAB;
      l_nit_inv_type   nm_inv_types.nit_inv_type%TYPE;
   --
   BEGIN
      BEGIN
         SELECT lb_exor_inv_type
           INTO l_nit_inv_type
           FROM lb_types
          WHERE lb_object_type = ASSETTYPE;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            l_nit_inv_type := NULL;
      END;

      nm3ctx.set_context ('NLT_DATA_INV_TYPE', l_nit_inv_type);
      nm3ctx.set_context ('NLT_DATA_NLT_ID', TO_CHAR (NETWORKTYPEID));
      nm3ctx.set_context ('NLT_DATA_UNIQUE', NETWORKELEMENT);

      SELECT lb_linear_refnt (nlt_id,
                              ne_id,
                              ne_unique,
                              ne_descr,
                              nt_type,
                              nt_descr,
                              un_unit_name)
        BULK COLLECT INTO retval
        FROM v_nm_nlt_refnts;

      RETURN retval;
   END;

   --
   FUNCTION GET_POINT_OR_CONTINUOUS (ASSETTYPE IN INTEGER)
      RETURN VARCHAR2
   IS
      RETVAL   VARCHAR2 (1);
   BEGIN
        SELECT NIT_PNT_OR_CONT
          INTO RETVAL
          FROM v_lb_type_nw_flags
         WHERE lb_object_type = ASSETTYPE
      GROUP BY nit_pnt_or_cont;

      RETURN RETVAL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20005, 'Asset type is not registered');
   END;

   FUNCTION GET_POINT_OR_CONTINUOUS (INV_TYPE IN VARCHAR2)
      RETURN VARCHAR2
   IS
      RETVAL   VARCHAR2 (1);
   BEGIN
        SELECT NIT_PNT_OR_CONT
          INTO RETVAL
          FROM v_lb_type_nw_flags
         WHERE lb_exor_inv_type = INV_TYPE
      GROUP BY nit_pnt_or_cont;

      RETURN RETVAL;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20005, 'Asset type is not registered');
   END;

   PROCEDURE CHECK_JXP (ASSETTYPE IN INTEGER, JXP IN VARCHAR2)
   IS
      l_exor_njx_code   NM_JUXTAPOSITIONS.NJX_CODE%TYPE;
   BEGIN
      SELECT njx_code
        INTO l_exor_njx_code
        FROM nm_juxtapositions, NM_ASSET_TYPE_JUXTAPOSITIONS, lb_types
       WHERE     najx_njxt_id = njx_njxt_id
             AND njx_meaning = JXP
             AND lb_object_type = ASSETTYPE
             AND lb_exor_inv_type = najx_inv_type;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'Juxtaposition not known');
   END;

   FUNCTION get_xsp_on_lb_rpt_tab (
      p_lb_rpt_tab   IN lb_rpt_tab,
      p_inv_type     IN LB_TYPES.LB_EXOR_INV_TYPE%TYPE)
      RETURN lb_xsp_tab
   IS
      retval   lb_xsp_tab;
   BEGIN
      WITH datum_range AS (SELECT /*+materialise*/
                                 * FROM TABLE (p_lb_rpt_tab))
      SELECT CAST (
                COLLECT (lb_xsp (xsr_x_sect_value, xsr_descr)) AS lb_xsp_tab)
        INTO retval
        FROM (SELECT DISTINCT xsr_x_sect_value, xsr_descr
                FROM (SELECT d.ne_id,
                             d.ne_nt_type,
                             d.ne_gty_group_type,
                             d.ne_sub_class
                        FROM nm_elements d, datum_range
                       WHERE refnt = ne_id
                      --and ne_sub_class is not null
                      UNION ALL
                      SELECT /*+INDEX(m nm_obj_type_ne_id_of_ind) */
                            nm_ne_id_of,
                             g.ne_nt_type,
                             g.ne_gty_group_type,
                             g.ne_sub_class
                        FROM nm_members m, nm_elements g, datum_range
                       WHERE     nm_ne_id_of = refnt
                             AND nm_ne_id_in = g.ne_id
                             AND nm_obj_type = g.ne_gty_group_type --and g.ne_sub_class is not null
                                                                  ) t,
                     xsp_restraints
               WHERE     xsr_nw_type = ne_nt_type
                     AND xsr_ity_inv_code = p_inv_type
                     AND xsr_scl_class = ne_sub_class);

      RETURN retval;
   END;
END lb_ref;
/
