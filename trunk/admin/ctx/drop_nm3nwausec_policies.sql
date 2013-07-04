--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/drop_nm3nwausec_policies.sql-arc   1.2   Jul 04 2013 09:23:56   James.Wadsworth  $
--       Module Name      : $Workfile:   drop_nm3nwausec_policies.sql  $
--       Date into SCCS   : $Date:   Jul 04 2013 09:23:56  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:22:04  $
--       SCCS Version     : $Revision:   1.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
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

