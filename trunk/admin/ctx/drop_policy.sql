--
SET SERVEROUTPUT ON SIZE 100000
--
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/drop_policy.sql-arc   2.2   Jul 04 2013 09:23:56   James.Wadsworth  $
--       Module Name      : $Workfile:   drop_policy.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:23:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:22:04  $
--       SCCS Version     : $Revision:   2.2  $
--       Based on SCCS Version     : 1.9
--
--   Drop Inventory/Merge security policies
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
   FOR cs_rec IN cs_policies_to_drop (Sys_Context('NM3CORE','APPLICATION_OWNER'))
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
