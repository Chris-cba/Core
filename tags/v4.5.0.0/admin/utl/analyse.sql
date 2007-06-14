--
set feedback off
set lines 132
set pages 0
--
spool temp.ana
SELECT 'ANALYZE '||object_type||' '||object_name||' COMPUTE STATISTICS;'
from user_objects
where object_type IN ('TABLE','INDEX')
ORDER BY DECODE(object_type
               ,'TABLE',1
               ,'INDEX',2
               ,3
               )
        ,object_name;
spool off
--
prompt .
prompt Doing the analyse statements, this may take some time
prompt .
--
@temp.ana
--
host del temp.ana
--
set pages 50
set feedback on
--
