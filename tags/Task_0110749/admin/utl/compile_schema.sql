set verify off
set head off
set feed off
set trimspool on
set pages 999
set lines 200
--
undefine username
undefine filename
--

set term off

DECLARE
 ex_not_exists exception;
 pragma exception_init (ex_not_exists,-942);

BEGIN
  execute immediate('drop table temp_depend');
EXCEPTION
  WHEN ex_not_exists THEN
    Null;
   WHEN others THEN
     RAISE;
END;
/
create table temp_depend as
select d.d_obj# object_id
      ,d.p_obj# referenced_object_id
 from  sys.dependency$ d
where  d.d_obj# in 
       (select object_id
          From sys.dba_objects
             , sys.user$
         where name = USER
           and owner = name
       )
/

CREATE INDEX IX1 ON
  TEMP_DEPEND(OBJECT_ID)
/
CREATE INDEX IX2 ON
  TEMP_DEPEND(REFERENCED_OBJECT_ID)
/
create or replace force view ord_obj_by_depend as
select max(level) dlevel
      ,object_id
from temp_depend
connect by object_id = prior referenced_object_id
group by object_id
/
set term on


PROMPT Starting to generate compile_all.sql

set termout off
spool compile_all.sql
select 'SET FEEDBACK OFF' FROM DUAL;
--
select 'PROMPT --###############################################################################' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT -----------------------------------------------------------------------------' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --   SCCS Identifiers :-' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --       sccsid           : @(#)compile_schema.sql	1.11 09/27/06' FROM DUAL;
select 'PROMPT --       Module Name      : compile_schema.sql' FROM DUAL;
select 'PROMPT --       Date into SCCS   : 06/09/27 13:18:53' FROM DUAL;
select 'PROMPT --       Date fetched Out : 07/06/13 17:07:16' FROM DUAL;
select 'PROMPT --       SCCS Version     : 1.11' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --   Author : Jonathan Mills' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --   Generated compile_all script' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --   Generated '||to_char(sysdate,'DD-Mon-YYYY HH24:MI:SS') FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT -----------------------------------------------------------------------------' FROM DUAL;
select 'PROMPT --	Copyright (c) exor corporation ltd, 2001' FROM DUAL;
select 'PROMPT -----------------------------------------------------------------------------' FROM DUAL;
select 'PROMPT --' FROM DUAL;
select 'PROMPT --###############################################################################' FROM DUAL;
SELECT 'PROMPT Remember TYPE definitions which have type or table dependents will not re-compile' FROM DUAL;
select 'PROMPT --###############################################################################' FROM DUAL;
select 'WHENEVER SQLERROR EXIT ' FROM DUAL;
select ' DECLARE '             FROM DUAL;
select ' CURSOR CHECK_DOWN IS' FROM DUAL; 
select ' (SELECT DISTINCT ''X''' FROM DUAL;
select '    FROM hig_processes a, dba_scheduler_jobs b, hig_users c' FROM DUAL;
select '   WHERE a.hp_job_name = b.job_name AND b.owner = c.hus_username AND b.state = ''RUNNING'');' FROM DUAL;
select '   L_DUMMY VARCHAR2(1);' FROM DUAL;
select ' BEGIN' FROM DUAL;
select '   --' FROM DUAL;
select '   DECLARE' FROM DUAL;
select '     NO_PRIVS EXCEPTION;' FROM DUAL;
select '     PRAGMA EXCEPTION_INIT(NO_PRIVS, -27486);' FROM DUAL;
select '   BEGIN' FROM DUAL;
select '   dbms_scheduler.set_scheduler_attribute(''SCHEDULER_DISABLED'', ''TRUE'');' FROM DUAL;
select '   EXCEPTION' FROM DUAL;
select '   WHEN NO_PRIVS THEN' FROM DUAL;
select '     NULL;' FROM DUAL;
select '   END;' FROM DUAL;
select '   --' FROM DUAL;
select '   OPEN CHECK_DOWN;' FROM DUAL;
select '   FETCH CHECK_DOWN INTO L_DUMMY;' FROM DUAL;
select '   CLOSE CHECK_DOWN;' FROM DUAL;
select '   IF L_DUMMY = ''X'' THEN' FROM DUAL;
select '     RAISE_APPLICATION_ERROR(-20000,''Compile all is not allowed while there are processes running.Please wait for these processes to finish and restart.'');'  FROM DUAL;
select '   END IF;' FROM DUAL;
select ' END;' FROM DUAL;
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
 and  a.OBJECT_ID = B.OBJECT_ID(+)
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

select 'PROMPT ' FROM DUAL;
select 'PROMPT ' FROM DUAL;
select 'PROMPT Re-Building Function Based Indexes' FROM DUAL;
select 'PROMPT ==================================' FROM DUAL;
select 'PROMPT ' FROM DUAL;

select 'PROMPT '||INDEX_NAME||CHR(10)||'ALTER INDEX '||INDEX_NAME||' REBUILD;' 
from   user_indexes ui 
where  index_type = 'FUNCTION-BASED NORMAL'
and not exists (select 'against a temp table'
                from  all_tables atb
                where atb.owner = ui.table_owner
                and   atb.table_name  = ui.table_name
                and atb.temporary = 'Y'); -- do not include indexes against temp tables - thus avoiding ORA-14456: cannot rebuild index on a temporary table 



--
-- Have a look at the errors
--
select 'column text format a120' from dual;
select 'set lines 200' from dual;
select 'PROMPT ' FROM DUAL;
select 'PROMPT List of Compilation Errors (if any)' FROM DUAL;
select 'PROMPT ===================================' FROM DUAL;
SELECT 'SELECT name,type,line,text FROM all_errors WHERE owner = UPPER('||CHR(39)||USER||CHR(39)||') ORDER BY name, type, sequence;'
FROM dual;
select 'PROMPT List of Disabled Function Based Indexes (if any)' FROM DUAL;
select 'PROMPT ===================================' FROM DUAL;
SELECT 'SELECT i.index_name, c.column_expression from user_indexes i, user_IND_EXPRESSIONS c where index_type = ''FUNCTION-BASED NORMAL'' AND funcidx_status = ''DISABLED'' and i.index_name = c.index_name;' FROM DUAL;
select 'set lines 132' from dual;
--
select 'SET FEEDBACK ON' FROM DUAL;
select 'PROMPT ' FROM DUAL;
select 'PROMPT End of compile_all' FROM DUAL;

spool off

drop view ord_obj_by_depend;
drop table temp_depend;
undef username
undef filename
set head on
set feed on
set pages 24
set lines 132
set verify OFF
set termout on
PROMPT Now START compile_all.sql

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
    dbms_output.put_line('CAUTION: Exor Listeners are currently running - executing compile_all.sql could result in deadlock');
    dbms_output.put_line('***************************************************************************************************');	
  END IF;

END;
/

