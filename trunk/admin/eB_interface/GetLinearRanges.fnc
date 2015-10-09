CREATE OR REPLACE FUNCTION GetLinearRanges (LocationId      IN INTEGER,
                                               NetworkTypeID   IN INTEGER)
   RETURN SYS_REFCURSOR
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/GetLinearRanges.fnc-arc   1.0   Oct 09 2015 13:31:34   Rob.Coupe  $
   --       Module Name      : $Workfile:   GetLinearRanges.fnc  $
   --       Date into PVCS   : $Date:   Oct 09 2015 13:31:34  $
   --       Date fetched Out : $Modtime:   Oct 07 2015 11:16:02  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe/David Stow
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   --
   retval   SYS_REFCURSOR;
BEGIN
   OPEN retval FOR
      SELECT /*+CARDINALITY (t 10) INDEX(e NE_PK) */ nal_asset_id AssetId,
             lb_object_type AssetType,
             nal_id LocationId,
             t.refnt_type NetworkTypeId,
             t.refnt NetworkElementId,
             e.ne_nt_type,
             e.ne_gty_group_type,
             t.start_m StartM,
             t.end_m EndM,
             u.un_unit_name Unit,
             e.ne_unique NetworkElementName,
             e.ne_descr NetworkElementDescr,
             (SELECT njx_meaning
                FROM nm_juxtapositions, NM_ASSET_TYPE_JUXTAPOSITIONS
               WHERE     najx_inv_type = lb_exor_inv_type
                     AND najx_njxt_id = njx_njxt_id
                     AND njx_code = nal_jxp)
                JXP
        FROM nm_asset_locations,
             lb_types,
             TABLE (LB_LOC.GET_PREF_LOCATION_TAB (nal_id, NetworkTypeID)) t,
             nm_units u,
             nm_elements e
       WHERE     lb_exor_inv_type = nal_nit_type
             AND un_unit_id = t.m_unit
             AND nal_id = LocationId
             AND nal_nit_type = lb_exor_inv_type
             and e.ne_id = refnt;
--
   RETURN retval;
END;
/
