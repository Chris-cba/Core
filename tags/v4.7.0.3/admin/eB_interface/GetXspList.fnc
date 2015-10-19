CREATE OR REPLACE FUNCTION GetXspList (
   assetType            IN INTEGER, -- External ID of an on-network asset type.
   networkType          IN INTEGER,                   -- ID of a network type.
   networkElement       IN INTEGER, -- ID of a metwork element of the specified type.
   startDistance        IN DECIMAL, -- The start of a linear range as measured from the start of the network element in the units given below.
   startDistanceUnits   IN lb_units.external_unit_id%TYPE, -- External ID of the units of the start distance. If null, the default length units of the linear element will be assumed.
   endDistance          IN DECIMAL, -- The end of the linear range as measured from the start of the network element in the units given below.
   endDistanceUnits     IN lb_units.external_unit_id%TYPE -- External ID of the units of the end distance. If null, the default length units of the linear element will be assumed.
                                                         )
   RETURN SYS_REFCURSOR
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/GetXspList.fnc-arc   1.0   Oct 19 2015 11:32:26   Rob.Coupe  $
   --       Module Name      : $Workfile:   GetXspList.fnc  $
   --       Date into PVCS   : $Date:   Oct 19 2015 11:32:26  $
   --       Date fetched Out : $Modtime:   Oct 19 2015 11:31:58  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge procedure to generate a cursor for asset type and XSP values
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   retval                   SYS_REFCURSOR;
   exorStartDistanceUnits   lb_units.exor_unit_name%TYPE;
   exorEndDistanceUnits     lb_units.exor_unit_name%TYPE;
BEGIN
   -- Map external unit IDs to exor unit IDs as needed
   IF startDistanceUnits IS NOT NULL
   THEN
      BEGIN
         SELECT exor_unit_name
           INTO exorStartDistanceUnits
           FROM lb_units
          WHERE external_unit_id = startDistanceUnits;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RAISE_APPLICATION_ERROR (
               -20777,
                  N'No equivalent exor unit for external unit ID = '
               || startDistanceUnits);
      END;
   END IF;

   IF endDistanceUnits IS NOT NULL
   THEN
      BEGIN
         SELECT exor_unit_name
           INTO exorEndDistanceUnits
           FROM lb_units
          WHERE external_unit_id = endDistanceUnits;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            RAISE_APPLICATION_ERROR (
               -20777,
                  N'No equivalent exor unit for external unit ID = '
               || endDistanceUnits);
      END;
   END IF;

   retval :=
      lb_ref.GetXspList (assetType,
                         networkType,
                         networkElement,
                         startDistance,
                         exorStartDistanceUnits,
                         endDistance,
                         exorEndDistanceUnits);
   RETURN retval;
END;
/
