CREATE OR REPLACE PROCEDURE CloseLinearLocation (
   LocationId IN INTEGER,
   endDate    IN DATE default NULL)
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/CloseLinearLocation.prc-arc   1.0   Oct 09 2015 13:28:24   Rob.Coupe  $
--       Module Name      : $Workfile:   CloseLinearLocation.prc  $
--       Date into PVCS   : $Date:   Oct 09 2015 13:28:24  $
--       Date fetched Out : $Modtime:   Oct 07 2015 11:03:50  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : R.A. Coupe/David Stow
--
--   eB Interface procedure to add a linear location header record
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
    END IF;
   END;
END;
/
