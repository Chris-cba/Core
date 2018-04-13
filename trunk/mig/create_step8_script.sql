set pages 0
set verify off 
set echo off 

-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/nm3/mig/create_step8_script.sql-arc   2.2   Apr 13 2018 07:38:06   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   create_step8_script.sql  $
--       Date into PVCS   : $Date:   Apr 13 2018 07:38:06  $
--       Date fetched Out : $Modtime:   Apr 13 2018 07:24:54  $
--       PVCS Version     : $Revision:   2.2  $
------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
------------------------------------------------------------------

undefine dir

accept dir prompt    "Enter the location on the database server where log files should be written  [E:\UTL_FILE]: " DEFAULT E:\utl_file


spool do_step_8.SQL


SELECT
      'PROMPT START MIGRATING INV TYPE  '''||nit_inv_type||'''' || chr(10)||
      'set timing on' || chr(10)||
      'set time on' || chr(10)||      
'BEGIN ' ||chr(10)||
'mig_step_8_ind_inv(pi_log_file_location => ''&dir'''||chr(10)||
'               ,pi_inv_type          =>'           ||chr(10)||
'               ,pi_sys_flag          =>'''||nit_inv_type||''''                 ||chr(10)||
'               ,pi_go_on             =>FALSE'                            ||chr(10)||
'               );'                                                                  ||chr(10)||
'END;'  ||chr(10)||
'/' ||chr(10)||
'PROMPT FINISHED MIGRATING INV TYPE  '''||nit_inv_type||'''' 
  FROM nm_inv_types
  ORDER BY nit_inv_type
/

spool off
