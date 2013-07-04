CREATE OR REPLACE FORCE VIEW hig_process_polled_conns_v AS
 SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_polled_conns_v.vw-arc   3.1   Jul 04 2013 11:20:04   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_process_polled_conns_v.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:53:46  $
--       Version          : $Revision:   3.1  $
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-- 
        c.*
       ,b.hp_process_id
   from  hig_process_conns_by_area a
        ,hig_processes b
        ,hig_ftp_connections c
  where  hptc_process_type_id = hp_process_type_id
    and    hptc_area_type = hp_area_type
    and    hptc_area_id_value = hp_area_id
    and    hp_polling_flag = 'Y'
    and    c.hfc_id = hptc_ftp_connection_id
 UNION ALL
 select c.*
       ,a.hp_process_id
   from  hig_processes a
        ,hig_process_types b
        ,hig_ftp_connections c
  where    a.hp_polling_flag = 'Y'
    and    a.hp_area_type IS NULL
    and    a.hp_process_type_id = b.hpt_process_type_id
    and    b.hpt_polling_ftp_type_id = c.hfc_hft_id
/
comment on table hig_process_polled_conns_v is 'For a given process this view delivers the list of ftp connections to be polled when the process runs'
/
