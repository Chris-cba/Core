CREATE OR REPLACE PROCEDURE CreateLinearRange (
   LocationId         IN  INTEGER,
   AssetId            IN  INTEGER,
   AssetType          IN  INTEGER,
   NetworkTypeID      IN  INTEGER,
   NetworkElementID   IN  INTEGER,
   startDistance      IN  NUMBER,
   startDistanceUnits IN  lb_units.external_unit_id%TYPE,
   startXsp           IN  nm_nw_xsp.nwx_x_sect%TYPE,
   endDistance        IN  NUMBER,
   endDistanceUnits   IN  lb_units.external_unit_id%TYPE,
   endXsp             IN  nm_nw_xsp.nwx_x_sect%TYPE,
   startDate          IN  DATE default trunc(sysdate),
   SecurityKey        IN  INTEGER,
   linearRangeId      OUT INTEGER)
AS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/CreateLinearRange.prc-arc   1.0   Oct 09 2015 13:29:14   Rob.Coupe  $
   --       Module Name      : $Workfile:   CreateLinearRange.prc  $
   --       Date into PVCS   : $Date:   Oct 09 2015 13:29:14  $
   --       Date fetched Out : $Modtime:   Oct 07 2015 11:31:34  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   l_xsp            nm_nw_xsp.nwx_x_sect%TYPE;
   l_externalUnitId lb_units.external_unit_id%TYPE;
   l_exorUnitId     lb_units.exor_unit_id%TYPE := null; -- Default to units of preferred network type.
   l_exorType       lb_types.lb_exor_inv_type%TYPE;
BEGIN
   IF endDistance IS NOT NULL AND startXsp <> endXsp
   THEN
      RAISE_APPLICATION_ERROR( -20777, N'Exor requires the from and to lateral referent types to be identical.' );
   END IF;
   l_xsp := startXsp;

   IF endDistance IS NOT NULL AND startDistanceUnits <> endDistanceUnits
   THEN
      RAISE_APPLICATION_ERROR( -20777, N'Exor requires the start and end distance units to be identical.' );
   END IF;
   l_externalUnitId := startDistanceUnits;

   -- Map external asset type to exor asset type
   SELECT lb_exor_inv_type
      INTO l_exorType
      FROM lb_types
   WHERE lb_object_type = AssetType;

   -- Map external unit ID to exor unit ID if needed
   IF l_externalUnitId IS NOT NULL
   THEN
      BEGIN
         SELECT exor_unit_id
            INTO l_exorUnitId
            FROM lb_units
         WHERE external_unit_id = l_externalUnitId;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR( -20777, N'No equivalent exor unit for external unit ID = ' || l_externalUnitId );
      END;
   END IF;

   lb_load.lb_ld_range (LocationId,
                      l_exorType,
                      NetworkElementID,
                      NULL,
                      NetworkTypeID,
                      startDistance,
                      endDistance,
                      l_exorUnitId,
                      l_xsp,
                      trunc (startDate),
                      SecurityKey);

   linearRangeId := 1; -- TODO - get from lb_load.lb_ld_RPt
--
END;
/
