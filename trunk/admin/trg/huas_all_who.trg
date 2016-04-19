CREATE OR REPLACE TRIGGER huas_all_who
 BEFORE insert OR update
 ON hig_user_access_security
 FOR each row
DECLARE
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/trg/huas_all_who.trg-arc   1.0   Apr 19 2016 10:15:10   Vikas.Mhetre  $
--       Module Name      : $Workfile:   huas_all_who.trg  $
--       Date into PVCS   : $Date:   Apr 19 2016 10:15:10  $
--       Date fetched Out : $Modtime:   Apr 19 2016 10:14:38  $
--       Version          : $Revision:   1.0  $
-----------------------------------------------------------------------------
--    Copyright (c) 2016 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   l_sysdate DATE;
   l_user    VARCHAR2(30);
BEGIN

   SELECT sysdate
         ,Sys_Context('NM3_SECURITY_CTX','USERNAME')
    INTO  l_sysdate
         ,l_user
    FROM  dual;
--
   IF inserting
    THEN
      :new.huas_date_created  := l_sysdate;
      :new.huas_created_by    := l_user;
   END IF;
--
   :new.huas_date_modified := l_sysdate;
   :new.huas_modified_by   := l_user;
--
END huas_all_who;
/