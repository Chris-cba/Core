CREATE OR REPLACE FORCE VIEW hig_process_conns_by_area_v AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_process_conns_by_area_v.vw-arc   3.4   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_process_conns_by_area_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.4  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
       hptc_process_type_id
     , hptc_ftp_connection_id
     , hptc_area_type
     , hptc_area_id_value
     , hig_process_framework.area_meaning_from_id_value(hptc_area_type,hptc_area_id_value) hptc_area_meaning
     , hfc_hft_id 
     , hfc_name 
     , hfc_ftp_host
     , hfc_ftp_in_dir
     , hfc_ftp_out_dir
from  hig_process_conns_by_area    
     ,hig_ftp_connections
where  hptc_ftp_connection_id = hfc_id
/
comment on table hig_process_conns_by_area_v is 'List of the ftp connections broken down by area for process types. '
/ 
