CREATE OR REPLACE PROCEDURE CreateLinearLocation (
   AssetId             IN  INTEGER,
   AssetType           IN  INTEGER,
   JXP                 IN  VARCHAR2,
   LocationDescription IN  VARCHAR2,
   startDate           IN  DATE default trunc(sysdate),
   SecurityKey         IN  INTEGER,
   LocationId          OUT INTEGER)
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/eB_interface/CreateLinearLocation.prc-arc   1.2   Jan 02 2019 11:19:00   Chris.Baugh  $
--       Module Name      : $Workfile:   CreateLinearLocation.prc  $
--       Date into PVCS   : $Date:   Jan 02 2019 11:19:00  $
--       Date fetched Out : $Modtime:   Jan 02 2019 11:18:40  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe/David Stow
--
--   eB Interface procedure to add a linear location header record
--
-----------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--
   l_exor_type       lb_types.lb_exor_inv_type%TYPE;
   l_exor_njx_code   NM_JUXTAPOSITIONS.NJX_CODE%TYPE;
BEGIN
   SELECT lb_exor_inv_type
     INTO l_exor_type
     FROM lb_types
    WHERE lb_object_type = AssetType;

   --
   IF JXP IS NOT NULL
   THEN
      BEGIN
         SELECT njx_code
           INTO l_exor_njx_code
           FROM nm_juxtapositions, NM_ASSET_TYPE_JUXTAPOSITIONS
          WHERE     najx_inv_type = l_exor_type
                AND najx_njxt_id = njx_njxt_id
                AND njx_meaning = JXP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001, 'Juxtaposition not known');
      END;
   END IF;

   LocationId :=
      lb_load.ld_nal (l_exor_type,
                      AssetID,
                      LocationDescription,
                      l_exor_njx_code,
                      'Y',
                      'N',
                      trunc (startDate),
                      SecurityKey);
--

END;
/
