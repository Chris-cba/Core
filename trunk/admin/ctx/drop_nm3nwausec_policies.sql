--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/ctx/drop_nm3nwausec_policies.sql-arc   1.1   Nov 29 2012 10:12:06   Rob.Coupe  $
--       Module Name      : $Workfile:   drop_nm3nwausec_policies.sql  $
--       Date into SCCS   : $Date:   Nov 29 2012 10:12:06  $
--       Date fetched Out : $Modtime:   Nov 29 2012 10:11:44  $
--       SCCS Version     : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) Bentley Systems 2012
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

