CREATE OR REPLACE VIEW nm_au_types
AS
   SELECT 
--
-----------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_au_types.vw-arc   1.0   May 01 2018 10:46:00   Chris.Baugh  $
--       Module Name      : $Workfile:   nm_au_types.vw  $
--       Date into PVCS   : $Date:   May 01 2018 10:46:00  $
--       Date fetched Out : $Modtime:   May 01 2018 10:21:28  $
--       Version          : $Revision:   1.0  $
--
-----------------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated.  All rights reserved.
-----------------------------------------------------------------------------------
--
     nat_admin_type,
     nat_descr,
     nat_date_created,
     nat_date_modified,
     nat_modified_by,
     nat_created_by
FROM nm_au_types_full
/