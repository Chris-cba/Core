create or replace trigger nm_nw_ad_link_whole_flag_trg
before insert or update
on nm_nw_ad_link_all 
referencing new as new old as old
for each row
declare
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_nw_ad_link_whole_flag_trg.sql-arc   2.1   Jul 04 2013 09:54:28   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_nw_ad_link_whole_flag_trg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 09:54:28  $
--       Date fetched Out : $Modtime:   Jul 04 2013 09:35:32  $
--       PVCS Version     : $Revision:   2.1  $
begin
  if :new.nad_whole_road = '0' then
    :new.nad_member_id := :new.nad_iit_ne_id;
  else
    :new.nad_member_id := :new.nad_ne_id;
  end if;

end;
/
