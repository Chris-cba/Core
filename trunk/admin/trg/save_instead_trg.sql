---------------------------------------------------------------------------------------------------
--
--             **************** Store away the details of any INSTEAD OF triggers *******************
--             "'@(#)save_instead_trg.sql	1.2 05/09/02'"
--             
---------------------------------------------------------------------------------------------------
--

CREATE TABLE NM_INSTALL_TRG_TEMP AS
SELECT trigger_name
      ,SYSDATE snapshot_time
      ,trigger_type
      ,triggering_event
      ,table_name
      ,description
      ,to_lob(trigger_body) trigger_body
FROM USER_TRIGGERS
WHERE trigger_type = 'INSTEAD OF';

ALTER TABLE NM_INSTALL_TRG_TEMP
 ADD (progress VARCHAR2(200));
 
DELETE  NM_INSTALL_TRG_TEMP
WHERE progress IS NOT NULL;


INSERT INTO NM_INSTALL_TRG_TEMP
( trigger_name
, snapshot_time
, trigger_type
, triggering_event
, table_name
, description
, trigger_body
, progress
)
SELECT trigger_name
      ,SYSDATE snapshot_time
      ,trigger_type
      ,triggering_event
      ,table_name
      ,description
      ,to_lob(trigger_body) trigger_body
      ,NULL
FROM USER_TRIGGERS a
WHERE trigger_type = 'INSTEAD OF'
AND NOT EXISTS ( SELECT trigger_name FROM NM_INSTALL_TRG_TEMP WHERE trigger_name = a.trigger_name ); 
