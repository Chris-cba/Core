create or replace force view v_nm_element_history
( old_ne_id, new_ne_id,
old_ne_unique, old_ne_descr,
new_ne_unique, new_ne_descr, neh_operation,
NEH_EFFECTIVE_DATE, NEH_ACTIONED_DATE, NEH_ACTIONED_BY )
as select
neh_ne_id_old, neh_ne_id_new, o.ne_unique, o.ne_descr,
n.ne_unique, n.ne_descr, neh_operation, NEH_EFFECTIVE_DATE, NEH_ACTIONED_DATE, NEH_ACTIONED_BY
from nm_elements_all o, nm_elements_all n, nm_element_history
where n.ne_id = neh_ne_id_new
and   o.ne_id = neh_ne_id_old
/
