--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/ctx/drop_nm3nwausec_policies.sql-arc   1.3   Apr 26 2018 08:46:04   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   drop_nm3nwausec_policies.sql  $
--       Date into SCCS   : $Date:   Apr 26 2018 08:46:04  $
--       Date fetched Out : $Modtime:   Apr 26 2018 08:44:16  $
--       SCCS Version     : $Revision:   1.3  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

declare
  cursor c1 is
     select * from user_policies where package = 'NM3NWAUSEC';
begin
  for irec in c1 loop
    dbms_rls.drop_policy(sys_context('NM3CORE', 'APPLICATION_OWNER'), irec.object_name, irec.policy_name );
  end loop;
end;
/

