CREATE OR REPLACE PROCEDURE CloseLinearLocation (
   LocationId IN INTEGER,
   endDate    IN DATE default NULL)
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/CloseLinearLocation.prc-arc   1.1   Oct 19 2015 10:55:40   Rob.Coupe  $
--       Module Name      : $Workfile:   CloseLinearLocation.prc  $
--       Date into PVCS   : $Date:   Oct 19 2015 10:55:40  $
--       Date fetched Out : $Modtime:   Oct 19 2015 10:55:14  $
--       PVCS Version     : $Revision:   1.1  $
--
--   Author : R.A. Coupe/David Stow
--
--   eB Interface procedure to close a linear location by location ID.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

BEGIN
--
  BEGIN
    
    UPDATE nm_asset_locations
       SET nal_end_date = NVL (endDate,trunc(sysdate))
    WHERE
       nal_id = LocationId;

    IF sql%rowcount = 0 -- nothing updated.
    THEN
       raise_application_error( -20001, 'Asset location ' || LocationId || ' does not exist and cannot be closed.');
    ELSE
      lb_load.close_location(PI_NAL_ID => LocationId, PI_END_DATE => endDate );
    END IF;
   END;
END;
/
