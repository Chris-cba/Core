--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/utl/compile_lb_objects.sql-arc   1.0   Jan 20 2015 15:33:40   Rob.Coupe  $
--       Module Name      : $Workfile:   compile_lb_objects.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 15:33:40  $
--       Date fetched Out : $Modtime:   Jan 17 2015 09:38:00  $
--       Version          : $Revision:   1.0  $
--
--       Author Rob Coupe (From J. Mills Compile Schema)
-----------------------------------------------------------------------------
--    Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
set verify off
set head off
set feed off
set trimspool on
set pages 0
set lines 200
--
undefine username
undefine filename
--

set term off


DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -942);BEGIN
   EXECUTE IMMEDIATE ('drop table lb_object_dependencies');
EXCEPTION
   WHEN not_exists
   THEN
      NULL;
END;
/


create table lb_object_dependencies
as
select d.d_obj# object_id
      ,d.p_obj# referenced_object_id
 from  sys.dependency$ d
where  d.d_obj# in 
       (select object_id
          From sys.dba_objects o, lb_objects l
             , sys.user$
         where name = USER
           and owner = name
           and o.object_name = l.object_name
           and o.object_type = l.object_type
       )
/


CREATE INDEX IX1 ON
  lb_object_dependencies(OBJECT_ID)
/

CREATE INDEX IX2 ON
  lb_object_dependencies(REFERENCED_OBJECT_ID)
/

create or replace force view ord_obj_by_depend as
select dlevel, v.object_id from (
select max(level) dlevel
      ,object_id
from lb_object_dependencies
connect by nocycle object_id = prior referenced_object_id
group by object_id
) v, lb_objects l, sys.dba_objects o
where o.object_name = l.object_name
and o.object_type = l.object_type
and o.object_id = v.object_id 
/


set term on


PROMPT Starting to generate compile_lb.sql

set termout off
spool compile_lb.sql
select 'SET FEEDBACK OFF' FROM DUAL;
--

select 'PROMPT --###############################################################################' FROM DUAL;
select 'PROMPT -- ' FROM DUAL;
select 'PROMPT --   PVCS Identifiers :- ' FROM DUAL;
select 'PROMPT -- ' FROM DUAL;
select 'PROMPT --       PVCS id          : $Header:   //new_vm_latest/archives/lb/admin/utl/compile_lb_objects.sql-arc   1.0   Jan 20 2015 15:33:40   Rob.Coupe  $ ' FROM DUAL;
select 'PROMPT --       Module Name      : $Workfile:   compile_lb_objects.sql  $ ' FROM DUAL;
select 'PROMPT --       Date into PVCS   : $Date:   Jan 20 2015 15:33:40  $ ' FROM DUAL;
select 'PROMPT --       Date fetched Out : $Modtime:   Jan 17 2015 09:38:00  $ ' FROM DUAL;
select 'PROMPT --       Version          : $Revision:   1.0  $ ' FROM DUAL;
select 'PROMPT -- ' FROM DUAL;
select 'PROMPT --       Author Rob Coupe (From J. Mills Compile Schema) ' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --   Generated compile_lb script' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --   Generated '||to_char(sysdate,'DD-Mon-YYYY HH24:MI:SS') FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT ----------------------------------------------------------------------------- ' FROM DUAL;
select 'PROMPT --    Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved. ' FROM DUAL;
select 'PROMPT ----------------------------------------------------------------------------- ' FROM DUAL;
select 'PROMPT --' FROM DUAL;
--select 'PROMPT --###############################################################################' FROM DUAL;
--SELECT 'PROMPT Remember TYPE definitions which have type or table dependents will not re-compile' FROM DUAL;
--select 'PROMPT --###############################################################################' FROM DUAL;
select 'WHENEVER SQLERROR EXIT ' FROM DUAL;
select 'DECLARE' FROM DUAL;
select ' l_dummy pls_integer;' FROM DUAL;
select ' l_shut_down_initiated BOOLEAN := FALSE;' FROM DUAL;
select ' ex_exor_error EXCEPTION; ' FROM DUAL;
select ' PRAGMA EXCEPTION_INIT(ex_exor_error,-20099);' FROM DUAL;
select '--' FROM DUAL;
select 'BEGIN' FROM DUAL;
select '--' FROM DUAL;
select '   BEGIN' FROM DUAL;
select '     dbms_scheduler.set_scheduler_attribute(''SCHEDULER_DISABLED'', ''TRUE'');' FROM DUAL;
select '     l_shut_down_initiated := TRUE; ' FROM DUAL;
select '     -- flag up that we were able to switch off the scheduler' FROM DUAL;
select '   EXCEPTION' FROM DUAL;
select '   WHEN others THEN ' FROM DUAL;
select '     NULL;' FROM DUAL;
select '   END;' FROM DUAL;
select '--' FROM DUAL;
select ' SELECT COUNT(*)' FROM DUAL;
select ' INTO l_dummy' FROM DUAL;
select ' FROM dual' FROM DUAL;
select ' WHERE exists (SELECT 1' FROM DUAL;
select '               FROM hig_processes a' FROM DUAL;
select '                 , dba_scheduler_jobs b' FROM DUAL;
select '                 , hig_users c' FROM DUAL;
select '               WHERE a.hp_job_name = b.job_name ' FROM DUAL;
select '               AND b.owner = c.hus_username ' FROM DUAL;
select '               AND b.state = ''RUNNING'');' FROM DUAL;
select '--' FROM DUAL;
select '  IF l_dummy = 1 THEN' FROM DUAL;
select '    IF l_shut_down_initiated THEN ' FROM DUAL;
select '     RAISE_APPLICATION_ERROR(-20099,''The Process Framework is shutting down but processes are still running.  Please try again later'');' FROM DUAL;
select '    ELSE' FROM DUAL;
select '     RAISE_APPLICATION_ERROR(-20099,''The Process Framework could not be shut down and processes are still running.  Please check that you have MANAGE SCHEDULER privilege.'');' FROM DUAL;
select '    END IF;' FROM DUAL;
select '  END IF;' FROM DUAL;
select 'EXCEPTION' FROM DUAL;
select '  WHEN ex_exor_error THEN' FROM DUAL;
select '     RAISE; ' FROM DUAL;
select '  WHEN others THEN' FROM DUAL;
select '     Null;' FROM DUAL;
select 'END;' FROM DUAL;
select '/' FROM DUAL;
select 'WHENEVER SQLERROR CONTINUE ' FROM DUAL;
select 'PROMPT Re-Compiling Schema - ignore any errors that are reported during this stage' FROM DUAL;
select 'PROMPT ===========================================================================' FROM DUAL;
select 'PROMPT ' FROM DUAL;
select 'PROMPT ' FROM DUAL;

select 'PROMPT '||OBJECT_TYPE||' '||OWNER||'.'||OBJECT_NAME
       ||CHR(10)
       ||'ALTER '
       ||decode(SUBSTR(OBJECT_TYPE,LENGTH(OBJECT_TYPE)-3,4)
               ,'BODY',SUBSTR(OBJECT_TYPE,1,LENGTH(OBJECT_TYPE)-4)|| OWNER||'.'||OBJECT_NAME || ' compile body' -- To do pack/type bodies
               ,'KAGE',OBJECT_TYPE|| ' '|| OWNER||'.'||OBJECT_NAME || ' compile specification'                  -- to do pack headers
               ,'TYPE',OBJECT_TYPE|| ' '|| OWNER||'."'||OBJECT_NAME || '" compile specification'                  -- to do type headers
               ,OBJECT_TYPE || ' ' || OWNER||'.'||OBJECT_NAME || ' compile'
               )
       ||';'
 from dba_objects       a
     ,ord_obj_by_depend b
where a.owner     = USER
 and  a.OBJECT_ID = B.OBJECT_ID
 and  OBJECT_TYPE in ('PACKAGE BODY'
                     ,'PACKAGE'
                     ,'FUNCTION'
                     ,'PROCEDURE'
                     ,'TRIGGER'
                     ,'VIEW'
                     ,'TYPE'
                     ,'TYPE BODY'
                     ,'MATERIALIZED VIEW'
                     )
 AND  object_name <> 'ORD_OBJ_BY_DEPEND'
 AND  object_name NOT LIKE 'BIN$%'
order by DLEVEL DESC
        ,OBJECT_TYPE
        ,OBJECT_NAME;

--select 'PROMPT ' FROM DUAL;
--select 'PROMPT ' FROM DUAL;
--select 'PROMPT Re-Building Function Based Indexes' FROM DUAL;
--select 'PROMPT ==================================' FROM DUAL;
--select 'PROMPT ' FROM DUAL;

--select 'PROMPT '||INDEX_NAME||CHR(10)||'ALTER INDEX '||INDEX_NAME||' REBUILD;' 
--from   user_indexes ui 
--where  index_type = 'FUNCTION-BASED NORMAL'
--and not exists (select 'against a temp table'
--                from  all_tables atb
--                where atb.owner = ui.table_owner
--                and   atb.table_name  = ui.table_name
--                and atb.temporary = 'Y'); -- do not include indexes against temp tables - thus avoiding ORA-14456: cannot rebuild index on a temporary table 
--
--
--
----
---- Have a look at the errors
----
select 'column text format a120' from dual;
select 'set lines 200' from dual;
select 'PROMPT ' FROM DUAL;
select 'PROMPT List of Compilation Errors (if any)' FROM DUAL;
select 'PROMPT ===================================' FROM DUAL;
SELECT 'SELECT name,type,line,text FROM all_errors, lb_objects WHERE name = object_name and type = object_type and owner = UPPER('||CHR(39)||USER||CHR(39)||') ORDER BY name, type, sequence;'
FROM dual;
--select 'PROMPT List of Disabled Function Based Indexes (if any)' FROM DUAL;
--select 'PROMPT ===================================' FROM DUAL;
--SELECT 'SELECT i.index_name, c.column_expression from user_indexes i, user_IND_EXPRESSIONS c where index_type = ''FUNCTION-BASED NORMAL'' AND funcidx_status = ''DISABLED'' and i.index_name = c.index_name;' FROM DUAL;
select 'set lines 132' from dual;
--
select 'SET FEEDBACK ON' FROM DUAL;
select 'PROMPT ' FROM DUAL;
select 'PROMPT End of compile_lb' FROM DUAL;

spool off

drop view ord_obj_by_depend;
drop table lb_object_dependencies;
undef username
undef filename
set head on
set feed on
set pages 24
set lines 132
set verify OFF
set termout on
PROMPT Now START compile_lb.sql

set serveroutput on
set feedback off
DECLARE
FUNCTION check_lstner RETURN boolean IS
  l_lsnr_count number;
  table_locked EXCEPTION;
  PRAGMA EXCEPTION_INIT( table_locked, -54 );
    lock_alert number;
  BEGIN
  SAVEPOINT lstner;
  LOCK TABLE exor_lock IN EXCLUSIVE MODE NOWAIT;
  ROLLBACK TO SAVEPOINT lstner;
  RETURN FALSE;
EXCEPTION
  WHEN table_locked THEN
   ROLLBACK TO SAVEPOINT lstner;
     RETURN TRUE;
  END;

BEGIN
  IF check_lstner THEN
    dbms_output.put_line(chr(10));
    dbms_output.put_line('***************************************************************************************************');
    dbms_output.put_line('CAUTION: Exor Listeners are currently running - executing compile_lb.sql could result in deadlock');
    dbms_output.put_line('***************************************************************************************************');    
  END IF;

END;
/
