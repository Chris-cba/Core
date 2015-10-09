CREATE OR REPLACE FUNCTION GetAssetLinearLocationsTab (
   AssetId         IN INTEGER, -- ID of a linearly located asset
   AssetType       IN INTEGER, -- Type of the linearly located asset
   NetworkTypeID   IN INTEGER) -- Network element type to report locations against
   RETURN linear_locations
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/GetAssetLinearLocationsTab.fnc-arc   1.0   Oct 09 2015 13:30:10   Rob.Coupe  $
   --       Module Name      : $Workfile:   GetAssetLinearLocationsTab.fnc  $
   --       Date into PVCS   : $Date:   Oct 09 2015 13:30:10  $
   --       Date fetched Out : $Modtime:   Oct 07 2015 11:34:20  $
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

   cur                 SYS_REFCURSOR;
   rowcount            PLS_INTEGER := 0;
   retval              linear_locations;
   l_AssetId           NUMBER(38);    -- ID of the linearly located object
   l_AssetType         NUMBER(38);    -- Type of the linearly located object
   LocationId          NUMBER(38);    -- ID of the linear location
   LocationDescription VARCHAR2(240); -- Linear location description
   l_NetworkTypeId     INTEGER;       -- Network element type
   NetworkElementId    INTEGER;       -- Network element ID
   StartM              NUMBER;        -- Absolute position of start of location
   EndM                NUMBER;        -- Optional absolute position of end of location
   ExorUnitName        lb_units.exor_unit_name%TYPE;   -- Units of start and end position. Exor unit name.
   ExternalUnitId      lb_units.external_unit_id%TYPE; -- Units of start and end position. External system's unit ID.
   NetworkElementName  VARCHAR2(30);  -- Network element unique name
   NetworkElementDescr VARCHAR2(240); -- Optional network element description
   JXP                 VARCHAR2(80);  -- Juxtaposition for this location
BEGIN
   cur := GetAssetLinearLocations (AssetId, AssetType, NetworkTypeID);
   retval := linear_locations();
   LOOP
      FETCH cur INTO l_AssetId, l_AssetType, LocationId, LocationDescription, l_NetworkTypeId,
         NetworkElementId, StartM, EndM, ExorUnitName, NetworkElementName, NetworkElementDescr, JXP;
      EXIT WHEN cur%NOTFOUND;

      -- Map exor unit name to external unit ID
      BEGIN
         SELECT external_unit_id
            INTO ExternalUnitId
            FROM lb_units
         WHERE exor_unit_name = ExorUnitName;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR( -20777, N'No equivalent external unit for exor unit ''' || ExorUnitName || '''.' );
      END;

      retval.extend;
      rowcount := rowcount + 1;
      retval(rowcount) := linear_location (l_AssetId, l_AssetType, LocationId, LocationDescription,
         l_NetworkTypeId, NetworkElementId, StartM, EndM, ExternalUnitId, NetworkElementName, NetworkElementDescr, JXP);
   END LOOP;
   CLOSE cur;
   RETURN retval;
END;
/
