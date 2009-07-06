-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/drop_sde_logfile_tabs.sql-arc   1.0   Jul 06 2009 17:04:42   cstrettle  $
--       Module Name      : $Workfile:   drop_sde_logfile_tabs.sql  $
--       Date into PVCS   : $Date:   Jul 06 2009 17:04:42  $
--       Date fetched Out : $Modtime:   Jul 06 2009 16:58:44  $
--       Version          : $Revision:   1.0  $
-------------------------------------------------------------------------
--
--
-- Script to remove the sde_logfile_data and sde_logfiles tables
--
-- These tables are recreated by the arcGIS client when required 
-- They are prone to change after an esri upgrade - when using a system generated from
-- a system export or template, the user tables may be incompatible with the esri release
-- and multiple feature selection may fail.
-- 
--
SET SERVEROUTPUT ON
--
DECLARE
    CURSOR c1 IS 
    SELECT owner, table_name
      FROM hig_users, all_tables
     WHERE hus_username = owner
       AND table_name in ('SDE_LOGFILE_DATA','SDE_LOGFILES');
--       
 v_count_success number := 0;
 v_count_fail    number := 0;
--    
begin
  --
  dbms_output.put_line('#### Remove SDE_LOGFILE table script started ####');
  dbms_output.put_line('########');
  --
  for irec in c1 loop
    BEGIN 
    --
      execute immediate 'drop table '||irec.owner||'.'||irec.table_name;
      dbms_output.put_line(irec.owner||'.'||irec.table_name||' has been dropped');
      v_count_success:= v_count_success+1;
    --     
    EXCEPTION   
    WHEN OTHERS THEN
    --
      dbms_output.put_line(irec.owner||'.'||irec.table_name||' could not be droped: '|| SQLERRM);
      v_count_fail:= v_count_fail+1;
    --  
    END;
  end loop;
  --  
  dbms_output.put_line('########');  
  --
  IF v_count_success+v_count_fail = 0 THEN
    dbms_output.put_line('No tables to delete.'); 
  ELSE
    dbms_output.put_line('Successfully deleted: '||v_count_success);
    dbms_output.put_line('Failed to deleted   : '||v_count_fail);
  END IF;
  --
  dbms_output.put_line('########');  
  --
  dbms_output.put_line('#### Remove SDE_LOGFILE table script finished ####');
  --
end;
/