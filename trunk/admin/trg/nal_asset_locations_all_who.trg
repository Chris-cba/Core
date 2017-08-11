CREATE OR REPLACE TRIGGER NM_ASSET_LOCATIONS_ALL_WHO
BEFORE INSERT OR UPDATE
ON NM_ASSET_LOCATIONS_ALL
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
DECLARE
   l_sysdate DATE;
   l_user    VARCHAR2(30);
BEGIN
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/nal_asset_locations_all_who.trg-arc   1.0   Aug 11 2017 13:23:24   Rob.Coupe  $
--       Module Name      : $Workfile:   nal_asset_locations_all_who.trg  $
--       Date into PVCS   : $Date:   Aug 11 2017 13:23:24  $
--       Date fetched Out : $Modtime:   Aug 11 2017 13:22:52  $
--       PVCS Version     : $Revision:   1.0  $
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
   SELECT sysdate
         ,Sys_Context('NM3_SECURITY_CTX','USERNAME')
    INTO  l_sysdate
         ,l_user
    FROM  dual;
--
   IF inserting
    THEN
      :new.NAL_ID            := NAL_ID_SEQ.nextval;
      :new.NAL_DATE_CREATED  := l_sysdate;
      :new.NAL_CREATED_BY    := l_user;
   END IF;
--
   :new.NAL_DATE_MODIFIED := l_sysdate;
   :new.NAL_MODIFIED_BY   := l_user;
--
END NM_ASSET_LOCATIONS_ALL_WHO;
/
