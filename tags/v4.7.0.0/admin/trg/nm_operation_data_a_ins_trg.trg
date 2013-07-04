CREATE OR REPLACE TRIGGER nm_operation_data_a_ins_trg
  AFTER INSERT ON nm_operation_data
  FOR EACH ROW
DECLARE
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_operation_data_a_ins_trg.trg	1.1 07/16/02
--       Module Name      : nm_operation_data_a_ins_trg.trg
--       Date into SCCS   : 02/07/16 11:38:39
--       Date fetched Out : 07/06/13 17:03:33
--       SCCS Version     : 1.1
--
--
--   Author : Jonathan Mills
--
--   TRIGGER nm_operation_data_a_ins_trg
--     AFTER INSERT ON nm_operation_data
--     FOR EACH ROW
--
-- This trigger ensures that if there are new nm_operation_data records added
--  then there are nm_job_operation_data_values created for any jobs which are
--  NOT_STARTED
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
   CURSOR cs_operations (c_operation nm_operation_data.nod_nmo_operation%TYPE) IS
   SELECT njo_njc_job_id
         ,njo_id
    FROM  nm_job_operations
         ,nm_job_control
   WHERE  njo_nmo_operation = c_operation
    AND   njo_njc_job_id    = njc_job_id
    AND   njc_status        = nm3job.c_not_started;
--
   l_tab_njo_njc_job_id nm3type.tab_number;
   l_tab_njo_id         nm3type.tab_number;
--
BEGIN
--
   OPEN  cs_operations (:NEW.nod_nmo_operation);
   FETCH cs_operations BULK COLLECT INTO l_tab_njo_njc_job_id, l_tab_njo_id;
   CLOSE cs_operations;
--
   FORALL i IN 1..l_tab_njo_njc_job_id.COUNT
      INSERT INTO nm_job_operation_data_values
             (njv_njc_job_id
             ,njv_njo_id
             ,njv_nmo_operation
             ,njv_nod_data_item
             ,njv_value
             )
      VALUES (l_tab_njo_njc_job_id(i)
             ,l_tab_njo_id(i)
             ,:NEW.nod_nmo_operation
             ,:NEW.nod_data_item
             ,Null
             );
--
END nm_operation_data_a_ins_trg;
/
