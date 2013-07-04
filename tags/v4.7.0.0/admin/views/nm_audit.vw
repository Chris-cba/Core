CREATE OR REPLACE FORCE VIEW nm_audit AS
SELECT 
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_audit.vw	1.2 01/17/02
--       Module Name      : nm_audit.vw
--       Date into SCCS   : 02/01/17 08:26:57
--       Date fetched Out : 07/06/13 17:08:04
--       SCCS Version     : 1.2
--
--  nm_audit: view providing old interface to new audit table structure 
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
  na_audit_id, 
  nach_column_id  na_column_id, 
  na_timestamp, 
  na_performed_by,
  na_session_id, 
  na_table_name, 
  na_audit_type, 
  na_key_info_1, 
  na_key_info_2, 
  na_key_info_3, 
  na_key_info_4, 
  na_key_info_5, 
  na_key_info_6, 
  na_key_info_7, 
  na_key_info_8, 
  na_key_info_9, 
  na_key_info_10, 
  nach_column_name na_column_name, 
  nach_old_value   na_old_value, 
  nach_new_value   na_new_value
FROM 
  nm_audit_actions, 
  nm_audit_changes 
WHERE 
  na_audit_id = nach_audit_id;
