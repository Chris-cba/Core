--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/extent_fk_cascade.sql-arc   1.4   Jul 04 2013 13:45:30   James.Wadsworth  $
--       Module Name      : $Workfile:   extent_fk_cascade.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:59:54  $
--       Version          : $Revision:   1.4  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
/* script to tidy-up extents

This is shipped as a fix for 4500 (fix1) and 4400 (fix11). 
It is intended to help the removal of faulty extents that have been created using SM with route layers.

It does nto fix the immediate problem but provides a partial solution to help the user clea up faulty extents.

Ticket number 8001269723.

*/

alter table nm_saved_extent_member_datums
drop constraint nsd_nsm_fk;

alter table NM_SAVED_EXTENT_MEMBERS drop constraint nsu_nse_fk;

begin
  delete from nm_saved_extent_member_datums
  where not exists ( select 1 from nm_saved_extent_members  where nsm_id = nsd_nsm_id and nsm_nse_id = nsd_nse_id );
exception
  when no_data_found then null;
end;
/

begin
  delete from nm_saved_extent_member_datums
  where not exists ( select 1 from nm_saved_extents where nse_id = nsd_nse_id );
exception
  when no_data_found then null;
end;
/

begin
  delete from nm_saved_extent_members
  where not exists ( select 1 from nm_saved_extents where nse_id = nsm_nse_id );
exception
  when no_data_found then null;
end;
/

ALTER TABLE NM_SAVED_EXTENT_MEMBERS ADD 
CONSTRAINT nsu_nse_fk
FOREIGN KEY (NSM_NSE_ID)
REFERENCES NM_SAVED_EXTENTS (NSE_ID)
ON DELETE CASCADE
ENABLE
VALIDATE;

ALTER TABLE NM_SAVED_EXTENT_MEMBER_DATUMS ADD 
CONSTRAINT nsd_nsm_fk
FOREIGN KEY (NSD_NSE_ID, NSD_NSM_ID)
REFERENCES NM_SAVED_EXTENT_MEMBERS (NSM_NSE_ID, NSM_ID)
ON DELETE CASCADE
ENABLE
VALIDATE;
