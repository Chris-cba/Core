--
--   PVCS Identifiers :-
--
--       sccsid           : $Header  $
--       Module Name      : $Workfile:   drop_nm3nwausec_policies.sql  $
--       Date into SCCS   : $Date:   Nov 29 2012 10:01:34  $
--       Date fetched Out : $Modtime:   Nov 27 2012 15:13:14  $
--       SCCS Version     : $Revision:   1.0  $
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

