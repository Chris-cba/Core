--
SET SERVEROUTPUT ON SIZE 100000
--
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/drop_user_policy.sql-arc   3.2   Jul 04 2013 09:23:56   James.Wadsworth  $
--       Module Name      : $Workfile:   drop_user_policy.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:23:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:22:04  $
--       SCCS Version     : $Revision:   3.2  $
--
--   Drop Inventory/Merge security policies using user for 4500 upgrade
--    this script is for use wit 4500 upgrade only and will be made redundant 
--    after this release
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_policies_to_drop (c_owner VARCHAR2) IS
   SELECT object_owner
         ,object_name
         ,policy_name
    FROM  all_policies
   WHERE  object_owner = c_owner
    AND   substr(object_name,1,7) IN ('NM_INV_','NM_MRG_');
   --
BEGIN
--
   FOR cs_rec IN cs_policies_to_drop (User)
    LOOP
      BEGIN
         dbms_rls.drop_policy (object_schema => cs_rec.object_owner
                              ,object_name   => cs_rec.object_name
                              ,policy_name   => cs_rec.policy_name
                              );
         dbms_output.put_line(cs_policies_to_drop%ROWCOUNT||'. '||cs_rec.policy_name||' on '||cs_rec.object_owner||'.'||cs_rec.object_name||' dropped');
      EXCEPTION
         WHEN others
          THEN
            dbms_output.put_line(cs_policies_to_drop%ROWCOUNT||'. ### '||cs_rec.policy_name||' on '||cs_rec.object_name||' ERROR');
            dbms_output.put_line(SUBSTR(SQLERRM,1,255));
      END;
      dbms_output.put_line('--');
   END LOOP;
--
END;
/
