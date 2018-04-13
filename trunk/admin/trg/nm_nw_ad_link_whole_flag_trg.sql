create or replace trigger nm_nw_ad_link_whole_flag_trg
before insert or update
on nm_nw_ad_link_all 
referencing new as new old as old
for each row
declare
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/nm3/admin/trg/nm_nw_ad_link_whole_flag_trg.sql-arc   2.2   Apr 13 2018 11:06:36   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_nw_ad_link_whole_flag_trg.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:06:36  $
--       Date fetched Out : $Modtime:   Apr 13 2018 10:50:04  $
--       PVCS Version     : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
begin
  if :new.nad_whole_road = '0' then
    :new.nad_member_id := :new.nad_iit_ne_id;
  else
    :new.nad_member_id := :new.nad_ne_id;
  end if;

end;
/
