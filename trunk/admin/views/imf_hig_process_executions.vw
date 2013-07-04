CREATE OR REPLACE FORCE VIEW imf_hig_process_executions(
        Execution_id
       ,process_id
       ,Process_Name
       ,Process_description
       ,Outcome
       ,Admin_unit_id
       ,admin_unit_code
       ,admin_unit_name
       ,initiated_user
       ,Contract_code
       ,Contract_name
       ,Execution_start
       ,Execution_end
       ) AS    
SELECT        
--            
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--          
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/views/imf_hig_process_executions.vw-arc   3.1   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   imf_hig_process_executions.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:33:40  $
--       PVCS Version     : $Revision:   3.1  $
--            
--------------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
--------------------------------------------------------------------------------
--           
        hpjr_job_run_seq
       ,hpal_process_id
       ,hpt_name
       ,hpt_descr
       ,(SELECT hco_meaning
         FROM hig_codes
         WHERE hco_domain = 'PROCESS_SUCCESS_FLAG'
         AND hco_code     = hpal_success_flag)
       ,hpal_admin_unit
       ,hpal_unit_code
       ,hpal_unit_name
       ,hpal_initiated_user
       ,hpal_con_code
       ,hpal_con_name
       ,To_Date(To_Char(hpjr_start,'DD-Mon-YYYY HH24:mi:ss'),'DD-Mon-YYYY HH24:mi:ss')
       ,To_Date(To_Char(hpjr_end,'DD-Mon-YYYY HH24:mi:ss'),'DD-Mon-YYYY HH24:mi:ss')
FROm    hig_process_job_runs
       ,hig_process_alert_log
       ,hig_process_types
WHERE   hpjr_process_id  = hpal_process_id
AND     hpjr_job_run_seq = hpal_job_run_seq
AND     hpal_process_type_id = hpt_process_type_id
WITH READ ONLY
/


COMMENT ON TABLE imf_hig_process_executions IS 'Process Execution foundation view showing details of all the Processes';

COMMENT ON COLUMN imf_hig_process_executions.execution_id IS 'Combination of Execution_id and process_id makes a unique identifier for a Process Execution';

COMMENT ON COLUMN imf_hig_process_executions.process_id IS 'Combination of Execution_id and process_id makes a unique identifier for a Process Execution';

COMMENT ON COLUMN imf_hig_process_executions.Process_Name IS 'Name of the Process';

COMMENT ON COLUMN imf_hig_process_executions.Process_description IS 'Description of the Process';

COMMENT ON COLUMN imf_hig_process_executions.Outcome IS 'Outcome of the Process Execution, Y = Success, N = Fail, TBD = To Be Determined, I = Interim';

COMMENT ON COLUMN imf_hig_process_executions.Admin_unit_id IS 'Admin Unit Id for which the Process is been Executed';

COMMENT ON COLUMN imf_hig_process_executions.admin_unit_code IS 'Admin Unit Code for which the Process is been Executed';

COMMENT ON COLUMN imf_hig_process_executions.admin_unit_name IS 'Admin Unit Name for which the Process is been Executed';

COMMENT ON COLUMN imf_hig_process_executions.initiated_user IS 'Oracle User Name who has initatiated the Process execution';

COMMENT ON COLUMN imf_hig_process_executions.Contract_code IS 'Contract code for which the Process is been Executed';

COMMENT ON COLUMN imf_hig_process_executions.Contract_name IS 'Contract name for which the Process is been Executed';

COMMENT ON COLUMN imf_hig_process_executions.Execution_start IS 'Start Datetime of the Process Execution';

COMMENT ON COLUMN imf_hig_process_executions.Execution_end IS 'End Datetime of the Process Execution';







