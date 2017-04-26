CREATE OR REPLACE FUNCTION GetNetworkLinearLocationsTab (
   NetworkTypeID   IN INTEGER) -- Network element type to report locations against
   RETURN lb_linear_locations
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/GetNetworkLinearLocationsTab.fnc-arc   1.2   Apr 26 2017 12:14:50   Rob.Coupe  $
   --       Module Name      : $Workfile:   GetNetworkLinearLocationsTab.fnc  $
   --       Date into PVCS   : $Date:   Apr 26 2017 12:14:50  $
   --       Date fetched Out : $Modtime:   Apr 26 2017 12:14:10  $
   --       PVCS Version     : $Revision:   1.2  $
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

   cur                 SYS_REFCURSOR;
   rowcount            PLS_INTEGER := 0;
   retval              lb_linear_locations;
   l_AssetId           NUMBER(38);    -- ID of the linearly located object
   l_AssetType         NUMBER(38);    -- Type of the linearly located object
   LocationId          NUMBER(38);    -- ID of the linear location
   LocationDescription VARCHAR2(240); -- Linear location description
   l_NetworkTypeId     INTEGER;       -- Network element type
   NetworkElementId    INTEGER;       -- Network element ID
   StartM              NUMBER;        -- Absolute position of start of location
   EndM                NUMBER;        -- Optional absolute position of end of location
   Unit                VARCHAR2(20);  -- Units of start and end position
   NetworkElementName  VARCHAR2(30);  -- Network element unique name
   NetworkElementDescr VARCHAR2(240); -- Optional network element description
   JXP                 VARCHAR2(80);  -- Juxtaposition for this location
   StartDate           DATE;          -- Start date of the asset location '||chr(13)||chr(10)
   EndDate             DATE;          -- End date of the asset location ';
BEGIN
   cur := GetNetworkLinearLocations (NetworkTypeID);
   retval := lb_linear_locations();
   LOOP
      FETCH cur INTO l_AssetId, l_AssetType, LocationId, LocationDescription, l_NetworkTypeId,
         NetworkElementId, StartM, EndM, Unit, NetworkElementName, NetworkElementDescr, JXP, StartDate, EndDate;
      EXIT WHEN cur%NOTFOUND;
      retval.extend;
      rowcount := rowcount + 1;
      retval(rowcount) := lb_linear_location (l_AssetId, l_AssetType, LocationId, LocationDescription,
         l_NetworkTypeId, NetworkElementId, StartM, EndM, Unit, NetworkElementName, NetworkElementDescr, JXP, StartDate, EndDate);
   END LOOP;
   CLOSE cur;
   RETURN retval;
END;
/
