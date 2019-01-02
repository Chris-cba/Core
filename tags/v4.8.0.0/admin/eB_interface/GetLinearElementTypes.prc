CREATE OR REPLACE FUNCTION GetLinearElementTypes
   RETURN lb_linear_element_types
IS
   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/GetLinearElementTypes.prc-arc   1.2   Jan 02 2019 11:34:02   Chris.Baugh  $
   --       Module Name      : $Workfile:   GetLinearElementTypes.prc  $
   --       Date into PVCS   : $Date:   Jan 02 2019 11:34:02  $
   --       Date fetched Out : $Modtime:   Jan 02 2019 11:33:38  $
   --       PVCS Version     : $Revision:   1.2  $
   --
   --   Author : R.A. Coupe/David Stow
   --
   --   Location Bridge package for DB retrieval into objects
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
   --

   cur         SYS_REFCURSOR;
   rowcount    PLS_INTEGER := 0;
   assetType   INTEGER;
   id          INTEGER;
   name        VARCHAR2(30);
   description VARCHAR2(80);
   lengthUnit  VARCHAR2(20);
   letypes     lb_linear_element_types;
BEGIN
   OPEN cur FOR
      SELECT
         AssetType,
         NetworkTypeId,
         NetworkTypeName,
         NetworkTypeDescr,
         UnitName
      FROM
         v_lb_inv_nlt_data;

      letypes := lb_linear_element_types();
      LOOP
         FETCH cur INTO assetType, id, name, description, lengthUnit;
         EXIT WHEN cur%NOTFOUND;
         letypes.extend;
         rowcount := rowcount + 1;
         letypes(rowcount) := lb_linear_element_type(assetType, id, name, description, lengthUnit);
      END LOOP;
   CLOSE cur;
   RETURN letypes;
END;
/
