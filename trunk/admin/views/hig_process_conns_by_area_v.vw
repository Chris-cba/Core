CREATE OR REPLACE FORCE VIEW hig_process_conns_by_area_v AS
SELECT 
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_conns_by_area_v.vw-arc   3.2   Nov 23 2010 10:18:00   Chris.Strettle  $
--       Module Name      : $Workfile:   hig_process_conns_by_area_v.vw  $
--       Date into PVCS   : $Date:   Nov 23 2010 10:18:00  $
--       Date fetched Out : $Modtime:   Nov 23 2010 10:15:30  $
--       Version          : $Revision:   3.2  $
-------------------------------------------------------------------------
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