CREATE OR REPLACE PROCEDURE UpdateLinearLocation (
   LocationIdIn          IN     INTEGER,
   NetworkTypeID         IN     INTEGER,
   NetworkElementID      IN     INTEGER,
   startDistance         IN     NUMBER,
   endDistance           IN     NUMBER,
   XSP                   IN     VARCHAR2,
   JXP                   IN     VARCHAR2,
   LocationDescription   IN     VARCHAR2,
   startDate             IN     DATE DEFAULT TRUNC (SYSDATE),
   LocationIdOut            OUT INTEGER)
AS
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/UpdateLinearLocation.prc-arc   1.0   Oct 19 2015 21:00:30   Rob.Coupe  $
   --       Module Name      : $Workfile:   UpdateLinearLocation.prc  $
   --       Date into PVCS   : $Date:   Oct 19 2015 21:00:30  $
   --       Date fetched Out : $Modtime:   Oct 19 2015 21:00:18  $
   --       PVCS Version     : $Revision:   1.0  $
   --
   --   Author : Rob Coupe/David Stow
   --
   --   Location Bridge procedure to update a linear location.
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --

   l_exor_njx_code   NM_JUXTAPOSITIONS.NJX_CODE%TYPE;
   l_asset_id        nm_asset_locations_all.nal_asset_id%TYPE;
   l_exor_type       nm_asset_locations_all.nal_nit_type%TYPE;
   l_jxp             nm_asset_locations_all.nal_jxp%TYPE;
   l_security_key    nm_asset_locations_all.nal_security_key%TYPE;
BEGIN
   SELECT nal_asset_id,
          nal_nit_type,
          nal_jxp,
          nal_security_key
     INTO l_asset_id,
          l_exor_type,
          l_jxp,
          l_security_key
     FROM nm_asset_locations
    WHERE nal_id = LocationIdIn;

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

   BEGIN
      UPDATE nm_asset_locations
         SET nal_end_date = startDate, nal_jxp = JXP
       WHERE nal_id = LocationIdIn;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error (-20001, 'No asset location to update');
   END;

   --
   BEGIN
      LB_LOAD.CLOSE_LOCATION (LocationIdIn, startDate);
   END;


   LocationIdOut :=
      lb_load.ld_nal (l_exor_type,
                      l_asset_id,
                      LocationDescription,
                      l_exor_njx_code,
                      'Y',
                      'N',
                      startDate,
                      l_security_key);
   lb_load.lb_ld_range (LocationIdOut,
                        l_exor_type,
                        NetworkElementID,
                        NULL,
                        NetworkTypeID,
                        startDistance,
                        endDistance,
                        NULL,
                        NULL,
                        startDate,
                        l_security_key);
END;
/
