CREATE OR REPLACE FUNCTION GetNetworkTypes (AssetType IN INTEGER)
   RETURN SYS_REFCURSOR
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/GetNetworkTypes.fnc-arc   1.1   Jan 02 2019 11:39:20   Chris.Baugh  $
   --       Module Name      : $Workfile:   GetNetworkTypes.fnc  $
   --       Date into PVCS   : $Date:   Jan 02 2019 11:39:20  $
   --       Date fetched Out : $Modtime:   Jan 02 2019 11:39:06  $
   --       PVCS Version     : $Revision:   1.1  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge procedure to generate a cursor for asset type and network relations.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --

   retval   SYS_REFCURSOR;
BEGIN
   nm3ctx.set_context ('LB_ASSET_TYPE', TO_CHAR (AssetType));

   OPEN retval FOR
        SELECT nlt_id NetworkTypeId,
               nt_type NetworkType,
               nlt_g_i_d NetworkFlag,
               nt_descr NetworkTypeDescr,
               un_unit_name Unit,
               un_format_mask UnitMask
          FROM v_lb_networktypes
      ORDER BY nlt_seq_no;

   RETURN retval;
END;
/
