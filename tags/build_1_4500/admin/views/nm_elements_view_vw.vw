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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_elements_view_vw.vw-arc   3.0   Jun 01 2009 09:53:32   lsorathia  $
--       Module Name      : $Workfile:   nm_elements_view_vw.vw  $
--       Date into PVCS   : $Date:   Jun 01 2009 09:53:32  $
--       Date fetched Out : $Modtime:   May 28 2009 09:12:42  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
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
