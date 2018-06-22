CREATE OR REPLACE TRIGGER NM_ASSET_LOCATIONS_ALL_WHO
   BEFORE INSERT OR UPDATE
   ON NM_ASSET_LOCATIONS_ALL
   REFERENCING NEW AS New OLD AS Old
   FOR EACH ROW
DECLARE
   l_sysdate   DATE;
   l_user      VARCHAR2 (30);
BEGIN
   --
   -----------------------------------------------------------------------------
   --
   --   PVCS Identifiers :-
   --
   --       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/nal_asset_locations_all_who.trg-arc   1.1   Jun 22 2018 17:20:04   Rob.Coupe  $
   --       Module Name      : $Workfile:   nal_asset_locations_all_who.trg  $
   --       Date into PVCS   : $Date:   Jun 22 2018 17:20:04  $
   --       Date fetched Out : $Modtime:   Jun 22 2018 09:49:32  $
   --       PVCS Version     : $Revision:   1.1  $
   --
   --   Author : Rob Coupe
   --
   --   Location Bridge data script.
   --
   -----------------------------------------------------------------------------
   --   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
   -----------------------------------------------------------------------------
   --
   --
   SELECT SYSDATE, SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
     INTO l_sysdate, l_user
     FROM DUAL;

   --
   IF INSERTING
   THEN
      IF :new.NAL_ID IS NULL
      THEN
         :new.NAL_ID := NAL_ID_SEQ.NEXTVAL;
      END IF;

      :new.NAL_DATE_CREATED := l_sysdate;
      :new.NAL_CREATED_BY := l_user;
   END IF;

   --
   :new.NAL_DATE_MODIFIED := l_sysdate;
   :new.NAL_MODIFIED_BY := l_user;
--
END NM_ASSET_LOCATIONS_ALL_WHO;
/
