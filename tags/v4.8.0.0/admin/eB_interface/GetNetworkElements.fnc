CREATE OR REPLACE FUNCTION GetNetworkElements (
   AssetType            IN INTEGER,
   NetworkTypeID        IN INTEGER,
   NetworkElementName   IN VARCHAR2)
   RETURN SYS_REFCURSOR
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/GetNetworkElements.fnc-arc   1.1   Jan 02 2019 11:37:44   Chris.Baugh  $
   --       Module Name      : $Workfile:   GetNetworkElements.fnc  $
   --       Date into PVCS   : $Date:   Jan 02 2019 11:37:44  $
   --       Date fetched Out : $Modtime:   Jan 02 2019 11:36:58  $
   --       PVCS Version     : $Revision:   1.1  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge procedure to retrieve element and LRS metadata
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   RETVAL   SYS_REFCURSOR;
BEGIN
   nm3ctx.set_context ('LB_ASSET_TYPE', TO_CHAR (AssetType));
   nm3ctx.set_context ('NLT_DATA_NLT_ID', TO_CHAR (NetworkTypeID));
   nm3ctx.set_context ('NLT_DATA_UNIQUE', NetworkElementName);

   OPEN retval FOR
      SELECT nlt_id NetworkTypeId,
             ne_id NetworkElementID,
             ne_unique NetworkElementName,
             ne_descr NetworkElementDescr,
             nt_type NetworkElementType,
             nt_descr NetworkTypeDescr,
             un_unit_name Unit
        FROM v_lb_nlt_refnts;

   RETURN retval;
END;
/
