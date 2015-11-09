--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/drop_policies.sql-arc   1.0   Nov 09 2015 11:39:54   Rob.Coupe  $
--       Module Name      : $Workfile:   drop_policies.sql  $
--       Date into SCCS   : $Date:   Nov 09 2015 11:39:54  $
--       Date fetched Out : $Modtime:   Oct 28 2015 12:07:48  $
--       SCCS Version     : $Revision:   1.0  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
/*
Script to remove policies that are deemed extraneous for the HE data access to work as desired.
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

