REM Copyright 2013 Bentley Systems Incorporated. All rights reserved.
REM @(#)do_pre_migration_check.sql	1.3 09/08/04

SET FEEDBACK OFF
SET ECHO OFF
SET TERM ON

prompt
prompt Highways by Exor - Pre-Migration Checker
prompt ========================================
prompt Working.....
prompt

BEGIN
 pre_migration_check.run_check( pi_filename         => 'pre_migration_results'
                              , pi_location         => 'E:\UTL_FILE\'
                              , pi_max_check_issues => 50
                              , pi_chk_road_network => 'Y'
                              , pi_chk_groups       => 'Y'
                              , pi_chk_inv          => 'Y'
                              , pi_chk_inv_hier     => 'Y'
                              , pi_chk_inv_attribs  => 'Y'
                              , pi_chk_spatial      => 'Y'
                              , pi_chk_doc          => 'Y'
                              , pi_chk_misc         => 'Y');
END;
/


prompt Done
Prompt Please check the specified output file for results
prompt
