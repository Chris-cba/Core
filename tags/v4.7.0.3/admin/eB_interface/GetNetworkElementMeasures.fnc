CREATE OR REPLACE FUNCTION GetNetworkElementMeasures (
   NetworkElementID   IN INTEGER)
   RETURN SYS_REFCURSOR
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/GetNetworkElementMeasures.fnc-arc   1.0   Oct 19 2015 11:18:58   Rob.Coupe  $
   --       Module Name      : $Workfile:   GetNetworkElementMeasures.fnc  $
   --       Date into PVCS   : $Date:   Oct 19 2015 11:18:58  $
   --       Date fetched Out : $Modtime:   Oct 19 2015 11:17:44  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge procedure to retrieve element and start and end measures
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   retval   SYS_REFCURSOR;
BEGIN
   nm3ctx.set_context ('NLT_NE_ID', TO_CHAR (NetworkElementID));

   OPEN retval FOR
      SELECT ne_id NetworkElementId,
             ne_unique NetworkElementName,
             start_measure StartM,
             end_measure EndM,
             unit_name Unit
        FROM v_nm_nlt_measures;

   RETURN retval;
END;
/
