CREATE OR REPLACE FORCE VIEW hig_process_types_restricted_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_types_restricted_v.vw-arc   3.1   May 17 2011 08:32:42   Steve.Cooper  $
--       Module Name      : $Workfile:   hig_process_types_restricted_v.vw  $
--       Date into PVCS   : $Date:   May 17 2011 08:32:42  $
--       Date fetched Out : $Modtime:   May 05 2011 15:24:38  $
--       Version          : $Revision:   3.1  $
-------------------------------------------------------------------------
     hpt.*
FROM hig_process_types_v hpt
    ,hig_process_type_users_v hus
WHERE hus.hus_username = Sys_Context('NM3_SECURITY_CTX','USERNAME')
AND   hus.hpt_process_type_id = hpt.hpt_process_type_id
/

COMMENT ON TABLE hig_process_types_restricted_v IS 'Exor Process Framework view.  Process types which are visible to the current user.'
/                                    
             
             