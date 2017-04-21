CREATE OR REPLACE FUNCTION GetAssetLinearLocations (
   AssetId         IN INTEGER,
   AssetType       IN INTEGER,
   NetworkTypeID   IN INTEGER)
   RETURN SYS_REFCURSOR
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/GetAssetLinearLocations.fnc-arc   1.1   Apr 21 2017 15:42:30   Rob.Coupe  $
   --       Module Name      : $Workfile:   GetAssetLinearLocations.fnc  $
   --       Date into PVCS   : $Date:   Apr 21 2017 15:42:30  $
   --       Date fetched Out : $Modtime:   Apr 21 2017 15:32:46  $
   --       PVCS Version     : $Revision:   1.1  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   retval   SYS_REFCURSOR;
BEGIN
   OPEN retval FOR
      SELECT /*+CARDINALITY (t 10) INDEX(e NE_PK) */ nal_asset_id AssetId,
             lb_object_type AssetType,
             nal_id LocationId,
             nal_descr LocationDescription,
             t.refnt_type NetworkTypeId,
             t.refnt NetworkElementId,
             t.start_m StartM,
             t.end_m EndM,
             un_unit_name Unit,
             e.ne_unique NetworkElementName,
             e.ne_descr NetworkElementDescr,
             (SELECT njx_meaning
                FROM nm_juxtapositions, NM_ASSET_TYPE_JUXTAPOSITIONS
               WHERE     najx_inv_type = lb_exor_inv_type
                     AND najx_njxt_id = njx_njxt_id
                     AND njx_code = nal_jxp)
                JXP,
		    nal_start_date StartDate,
			nal_end_date EndDate
        FROM nm_asset_locations,
             lb_types,
             TABLE (LB_LOC.GET_PREF_LOCATION_TAB (nal_id, NetworkTypeID)) t,
             nm_units,
             nm_elements e
       WHERE     lb_exor_inv_type = nal_nit_type
             AND un_unit_id = t.m_unit
             AND nal_asset_id = AssetId
             AND lb_object_type = AssetType
             AND nal_nit_type = lb_exor_inv_type
             and e.ne_id = refnt;

   RETURN retval;
END;
/
