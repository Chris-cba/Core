--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/drop_policies.sql-arc   1.1   Jun 06 2018 09:39:58   Chris.Baugh  $
--       Module Name      : $Workfile:   drop_policies.sql  $
--       Date into SCCS   : $Date:   Jun 06 2018 09:39:58  $
--       Date fetched Out : $Modtime:   Jun 06 2018 09:39:32  $
--       SCCS Version     : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
/*
Script to remove policies that are deemed extraneous for data access to work as desired.
*/
declare
  cursor c1 is
     select * from user_policies 
     where package = 'NM3NWAUSEC' 
     and ( object_name in ('NM_ELEMENTS_ALL','NM_MEMBERS_ALL')
     or ( object_name = 'NM_ADMIN_UNITS_ALL' and SEL = 'YES' ));    
begin
  for irec in c1 loop
    dbms_rls.drop_policy(sys_context('NM3CORE', 'APPLICATION_OWNER'), irec.object_name, irec.policy_name );
  end loop;
end;
/

