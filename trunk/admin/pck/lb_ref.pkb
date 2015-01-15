CREATE OR REPLACE PACKAGE BODY lb_ref
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/pck/lb_ref.pkb-arc   1.0   Jan 15 2015 15:27:08   Rob.Coupe  $
   --       Module Name      : $Workfile:   lb_ref.pkb  $
   --       Date into PVCS   : $Date:   Jan 15 2015 15:27:08  $
   --       Date fetched Out : $Modtime:   Jan 15 2015 15:26:36  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for handling reference data
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   g_body_sccsid    CONSTANT VARCHAR2 (2000) := '$Revision:   1.0  $';

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
         SELECT nal_id LocationId, NAL_DESCR LocationDescription, NJX_CODE JXP, NJX_MEANING JXP_DESCR
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
   FUNCTION GetXSPList (AssetType           IN INTEGER,
                        NetworkTypeID       IN INTEGER,
                        NetworkElementID    IN INTEGER,
                        StartDistance       IN NUMBER,
                        StartDistanceUnit   IN VARCHAR2,
                        EndDistance         IN NUMBER,
                        EndDistanceUnit     IN VARCHAR2)
      RETURN SYS_REFCURSOR
   IS
      retval     SYS_REFCURSOR;
      --
      l_startM   NUMBER;
      l_endM     NUMBER;
   --
   BEGIN
      IF AssetType IS NULL
      THEN
         raise_application_error (-20001, 'AssetType must be supplied');
      END IF;

      l_startM :=
         lb_ref.get_unit (StartDistanceUnit, NetworkTypeId, StartDistance);
      l_endM := lb_ref.get_unit (EndDistanceUnit, NetworkTypeId, EndDistance);

      IF NetworkElementID IS NOT NULL AND AssetType IS NOT NULL
      THEN
         OPEN retval FOR
            SELECT                   /* +INDEX( e NE_PK) +CARDINALITY(t 10) */
                   DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
              FROM nm_elements e,
                   nm_xsp_restraints,
                   lb_types,
                   TABLE (
                      get_lb_rpt_d_tab (LB_RPT_TAB (LB_RPt (NetworkElementID,
                                                            NetworkTypeId,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            1,
                                                            l_startM,
                                                            l_endM,
                                                            NULL)))) t
             WHERE     ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = lb_exor_inv_type
                   AND lb_object_type = AssetType
                   AND xsr_nw_type = ne_nt_type
                   AND ne_id = t.refnt
            UNION
            SELECT /*+ INDEX(m NM_OBJ_TYPE_NE_ID_OF_IND) CARDINALITY(t 10)  */
                   DISTINCT xsr_x_sect_value, xsr_descr
              FROM nm_elements e,
                   nm_members m,
                   lb_types,
                   nm_xsp_restraints,
                   TABLE (
                      get_lb_rpt_d_tab (LB_RPT_TAB (LB_RPt (NetworkElementId,
                                                            NetworkTypeId,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            NULL,
                                                            1,
                                                            l_startM,
                                                            l_endM,
                                                            NULL)))) t
             WHERE     nm_ne_id_of = refnt
                   AND nm_ne_id_in = ne_id
                   AND ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = lb_exor_inv_type
                   AND lb_object_type = AssetType
                   AND xsr_nw_type = ne_nt_type
            UNION
            SELECT                   /* +INDEX( e NE_PK) +CARDINALITY(t 10) */
                   DISTINCT xsr_x_sect_value XSP, xsr_descr XSP_DESCR
              FROM nm_elements e, nm_xsp_restraints, lb_types
             WHERE     ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = lb_exor_inv_type
                   AND lb_object_type = AssetType
                   AND xsr_nw_type = ne_nt_type
                   AND ne_id = NetworkElementId
            UNION ALL
            SELECT /*+ INDEX(m NM_OBJ_TYPE_NE_ID_OF_IND) CARDINALITY(t 10)  */
                   DISTINCT xsr_x_sect_value, xsr_descr
              FROM nm_elements e,
                   nm_members m,
                   lb_types,
                   nm_xsp_restraints
             WHERE     nm_ne_id_of = NetworkElementId
                   AND nm_ne_id_in = ne_id
                   AND ne_sub_class = xsr_scl_class
                   AND xsr_ity_inv_code = lb_exor_inv_type
                   AND lb_object_type = AssetType
                   AND xsr_nw_type = ne_nt_type;
      END IF;

      RETURN retval;
   END;

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
                nm_members r
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
--

   FUNCTION GETASSETYPENETWORKTYPES( AssetType IN INTEGER DEFAULT NULL) 
      RETURN SYS_REFCURSOR 
   IS   
      retval   SYS_REFCURSOR;
      p_asset_type INTEGER := AssetType;
   BEGIN
      OPEN retval FOR
         SELECT AssetType,
   NetworkTypeId,
   NetworkTypeName,
   NetworkTypeDescr,
   UnitName from 
           v_lb_inv_nlt_data
   where AssetType = nvl( p_asset_type, AssetType);           

      RETURN retval;
   END;




END lb_ref;
/