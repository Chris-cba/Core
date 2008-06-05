create or replace trigger nm_nw_ad_link_whole_flag_trg
before insert or update
on nm_nw_ad_link_all 
referencing new as new old as old
for each row
declare
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/trg/nm_nw_ad_link_whole_flag_trg.sql-arc   2.0   Jun 05 2008 09:17:34   smarshall  $
--       Module Name      : $Workfile:   nm_nw_ad_link_whole_flag_trg.sql  $
--       Date into PVCS   : $Date:   Jun 05 2008 09:17:34  $
--       Date fetched Out : $Modtime:   Jun 04 2008 09:16:02  $
--       PVCS Version     : $Revision:   2.0  $
begin
  if :new.nad_whole_road = '0' then
    :new.nad_member_id := :new.nad_iit_ne_id;
  else
    :new.nad_member_id := :new.nad_ne_id;
  end if;

end;
/