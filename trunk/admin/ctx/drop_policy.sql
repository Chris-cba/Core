--
SET SERVEROUTPUT ON SIZE 100000
--
DECLARE
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/drop_policy.sql-arc   2.0   Jun 14 2007 09:25:04   smarshall  $
--       Module Name      : $Workfile:   drop_policy.sql  $
--       Date into SCCS   : $Date:   Jun 14 2007 09:25:04  $
--       Date fetched Out : $Modtime:   Jun 14 2007 09:24:34  $
--       SCCS Version     : $Revision:   2.0  $
--       Based on SCCS Version     : 1.9
--
--   Drop Inventory/Merge security policies
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2001
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
   FOR cs_rec IN cs_policies_to_drop (nm3context.get_context(pi_attribute=>'APPLICATION_OWNER'))
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
