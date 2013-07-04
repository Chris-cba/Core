CREATE OR REPLACE FORCE VIEW nm_elements_view_vw (
nev_ne_id,
nev_ne_unique ,
nev_ne_descr,
nev_ne_type,
nev_ne_nt_type ,
nev_admin_unit_descr ,
nev_ne_start_date ,
nev_ne_gty_group_type,
nev_ne_admin_unit
)
AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_elements_view_vw.vw-arc   3.1   Jul 04 2013 11:20:30   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_elements_view_vw.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:17:28  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
ne_id
      ,ne_unique 
      ,ne_descr
      ,ne_type
      ,ne_nt_type 
      ,nau_unit_code ||' - '||nau_name
      ,ne_start_date 
      ,ne_gty_group_type
      ,ne_admin_unit
FROM   nm_elements ne
      ,nm_admin_units nau
WHERE  ne.ne_admin_unit = nau.nau_admin_unit
/
