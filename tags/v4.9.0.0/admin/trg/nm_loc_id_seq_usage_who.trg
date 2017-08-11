CREATE OR REPLACE TRIGGER NM_LOC_ID_SEQ_USAGE_WHO
BEFORE INSERT OR UPDATE
ON NM_LOCATIONS_ALL
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
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/trg/nm_loc_id_seq_usage_who.trg-arc   1.0   Aug 11 2017 13:28:34   Rob.Coupe  $
--       Module Name      : $Workfile:   nm_loc_id_seq_usage_who.trg  $
--       Date into PVCS   : $Date:   Aug 11 2017 13:28:34  $
--       Date fetched Out : $Modtime:   Aug 11 2017 13:27:56  $
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
      :new.NM_LOC_ID        := NM_LOC_ID_SEQ.nextval;
      :new.NM_DATE_CREATED  := l_sysdate;
      :new.NM_CREATED_BY    := l_user;
   END IF;
--
   :new.NM_DATE_MODIFIED := l_sysdate;
   :new.NM_MODIFIED_BY   := l_user;
--
END nm_locations_all_who;
/
