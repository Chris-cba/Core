--  '@(#)param.sql	1.1 04/18/01' - SCCS INFO
--    The two minus signs are needed to make the line a COMMENT line
--    The word REM does NOT work.

SELECT rpad(gmp_param_descr,29,' '),
       grp_shown,
       grp_descr
FROM   gri_module_params,
       gri_run_parameters,
       gri_report_runs
WHERE
       grp_job_id = to_number(:job_id)
AND
       grr_job_id = to_number(:job_id)
AND
       grp_param = gmp_param
AND
       gmp_module = grr_module
ORDER BY
         grp_seq
