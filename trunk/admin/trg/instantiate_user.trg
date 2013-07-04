create or replace trigger instantiate_user
after logon on schema
begin
--   SCCS Identifiers :-
--
--       sccsid           : @(#)instantiate_user.trg	1.1 03/01/01
--       Module Name      : instantiate_user.trg
--       Date into SCCS   : 01/03/01 16:24:38
--       Date fetched Out : 07/06/13 17:02:36
--       SCCS Version     : 1.1
--
-- trigger instantiate_user
--  after logon on schema
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

   nm3security.Set_User;
   nm3context.initialise_context;
   nm3user.instantiate_user;
exception
  when others then null;
end instantiate_user;
/
