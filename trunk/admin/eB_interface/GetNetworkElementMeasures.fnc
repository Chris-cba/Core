CREATE OR REPLACE FUNCTION GetNetworkElementMeasures (
   NetworkElementID   IN INTEGER)
   RETURN SYS_REFCURSOR
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/GetNetworkElementMeasures.fnc-arc   1.1   Jan 02 2019 11:36:38   Chris.Baugh  $
   --       Module Name      : $Workfile:   GetNetworkElementMeasures.fnc  $
   --       Date into PVCS   : $Date:   Jan 02 2019 11:36:38  $
   --       Date fetched Out : $Modtime:   Jan 02 2019 11:36:24  $
   --       PVCS Version     : $Revision:   1.1  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge procedure to retrieve element and start and end measures
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
