spool off;

delete from plan_table where statement_id = 'ROB';

explain plan set statement_id = 'ROB'
for 
select * from nm_elements
where exists ( select 'x' from nm_members, nm_user_aus
               where nm_admin_unit = nua_admin_unit
               and nua_user_id = 4
               and ne_type = 'S'
               and nm_ne_id_of= ne_id
               union
               select 'x' from nm_members a, nm_user_aus, nm_members g
               where a.nm_admin_unit = nua_admin_unit
               and nua_user_id = 4
               and ne_type = 'G'
               and g.nm_ne_id_in = ne_id
               and g.nm_ne_id_of = a.nm_ne_id_of
)
/

spool xpl2.out

select lpad(' ',2*level)||operation||' '||options||' '||object_name query_plan
from plan_table where statement_id = 'ROB'
connect by prior id = parent_id and statement_id = 'ROB' 
start with id = 1 and statement_id = 'ROB'
/

rollback;
