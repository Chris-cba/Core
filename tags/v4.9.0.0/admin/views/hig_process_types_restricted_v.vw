CREATE OR REPLACE FORCE VIEW hig_process_types_restricted_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_process_types_restricted_v.vw-arc   3.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_process_types_restricted_v.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   3.3  $
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
     hpt.*
FROM hig_process_types_v hpt
    ,hig_process_type_users_v hus
WHERE hus.hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
AND   hus.hpt_process_type_id = hpt.hpt_process_type_id
/

COMMENT ON TABLE hig_process_types_restricted_v IS 'Exor Process Framework view.  Process types which are visible to the current user.'
/                                    
             
             