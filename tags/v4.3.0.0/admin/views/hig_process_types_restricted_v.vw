CREATE OR REPLACE FORCE VIEW hig_process_types_restricted_v AS
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_process_types_restricted_v.vw-arc   3.0   Mar 29 2010 17:14:50   gjohnson  $
--       Module Name      : $Workfile:   hig_process_types_restricted_v.vw  $
--       Date into PVCS   : $Date:   Mar 29 2010 17:14:50  $
--       Date fetched Out : $Modtime:   Mar 29 2010 17:14:16  $
--       Version          : $Revision:   3.0  $
-------------------------------------------------------------------------
     hpt.*
FROM hig_process_types_v hpt
    ,hig_process_type_users_v hus
WHERE hus.hus_username = user
AND   hus.hpt_process_type_id = hpt.hpt_process_type_id
/

COMMENT ON TABLE hig_process_types_restricted_v IS 'Exor Process Framework view.  Process types which are visible to the current user.'
/                                    
             
             