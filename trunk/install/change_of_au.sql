--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/install/change_of_au.sql-arc   1.0   Nov 09 2015 13:14:24   Rob.Coupe  $
--       Module Name      : $Workfile:   change_of_au.sql  $ 
--       Date into PVCS   : $Date:   Nov 09 2015 13:14:24  $
--       Date fetched Out : $Modtime:   Nov 09 2015 13:13:06  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------
--
--
-- Script to reset the admin-type of a specific asset type by cloning the existing data.
-- Uses 1000 as an increment

Prompt Creating new admin-type

insert into nm_au_types
(nat_admin_type, nat_descr, nat_exclusive)
values
( 'NEM', 'Administration of Event data', 'Y' )
/


Prompt Creating new parallel admin-units 

insert into nm_admin_units
(nau_admin_unit, nau_unit_code, nau_level, nau_authority_code, nau_name, nau_address1, nau_address2, nau_address3, nau_address4, nau_address5,
nau_phone, nau_fax, nau_comments, nau_last_wor_no, nau_start_date, nau_end_date, nau_admin_type, nau_nsty_sub_type, nau_prefix, nau_minor_undertaker )
select nau_admin_unit + 1000, nau_unit_code, nau_level, nau_authority_code, nau_name, nau_address1, nau_address2, nau_address3, nau_address4, nau_address5,
nau_phone, nau_fax, nau_comments, nau_last_wor_no, nau_start_date, nau_end_date, 'NEM', nau_nsty_sub_type, nau_prefix, nau_minor_undertaker
from nm_admin_units_all, nm_inv_types_all
where nit_inv_type in ('NEVT', 'NIG', 'NELO')
and nit_admin_type = nau_admin_type
/

Prompt Creating new admin hierarchy records

insert into nm_admin_groups
(nag_parent_admin_unit, nag_child_admin_unit, nag_direct_link) 
select nag_parent_admin_unit + 1000, nag_child_admin_unit +1000, nag_direct_link
from nm_admin_groups
where exists ( select 1 from nm_admin_units_all, nm_inv_types_all
               where nit_inv_type in ('NEVT', 'NIG', 'NELO')
               and nit_admin_type = nau_admin_type
               and nau_admin_unit = nag_parent_admin_unit )
/               

Prompt Assigning new admin-types to existing asset types

update nm_inv_types
set nit_admin_type = 'NEM' where nit_inv_type in ('NEVT', 'NIG', 'NELO')
/

Prompt Update of all existing assets to new admin-unit

alter table nm_inv_items_all disable all triggers;

update nm_inv_items_all
set iit_admin_unit = iit_admin_unit + 1000
where iit_inv_type in ('NEVT', 'NIG', 'NELO')
/

alter table nm_inv_items_all enable all triggers;

Prompt Update of all existing asset locations to new admin-unit

alter table nm_members_all disable all triggers;

update nm_members_all
set nm_admin_unit = nm_admin_unit + 1000
where nm_obj_type in ('NEVT', 'NIG', 'NELO')
and nm_type = 'I'
/

alter table nm_members_all enable all triggers;

Prompt Re-setting the sequence

declare
l_max_au integer;
begin
--
  select max (nau_admin_unit) into l_max_au from nm_admin_units_all;
  l_max_au := l_max_au + 100;
--
  execute immediate 'drop sequence nau_admin_unit_seq';
--
  execute immediate 'create sequence nau_admin_unit_seq start with '||to_char(l_max_au);
end;
/

Prompt End of Admin-unit Update script.
