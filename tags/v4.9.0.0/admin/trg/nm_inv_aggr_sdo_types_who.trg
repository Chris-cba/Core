CREATE OR REPLACE TRIGGER nm_inv_aggr_sdo_types_who
   BEFORE INSERT OR UPDATE
   ON nm_inv_aggr_sdo_types
   FOR EACH ROW
DECLARE
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_inv_aggr_sdo_types_who.trg-arc   1.0   May 01 2018 08:50:06   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_inv_aggr_sdo_types_who.trg  $
--       Date into PVCS   : $Date:   May 01 2018 08:50:06  $
--       Date fetched Out : $Modtime:   May 01 2018 08:47:52  $
--       PVCS Version     : $Revision:   1.0  $
--
--   Author : Chris Strettle
--
-- TRIGGER ins_nm_members
--       BEFORE  INSERT OR UPDATE
--       ON      NM_MEMBERS_ALL
--       FOR     EACH ROW
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_sysdate   DATE;
   l_user      VARCHAR2 (30);
BEGIN
   SELECT SYSDATE, SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
     INTO l_sysdate, l_user
     FROM DUAL;

   --
   IF INSERTING
   THEN
      :new.DATE_CREATED := l_sysdate;
      :new.CREATED_BY := l_user;
   END IF;

   --
   :new.DATE_MODIFIED := l_sysdate;
   :new.MODIFIED_BY := l_user;
--
END nm_inv_aggr_sdo_types_who;
/