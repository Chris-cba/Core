create or replace force view vnm_location_types
(nlt_type, nlt_descr, nlt_seq_no, nlt_linear, nlt_units, nlt_start_date, nlt_end_date,
 nlt_admin_type, nlt_g_or_i )
as
select
 ngt_group_type, ngt_descr, ngt_search_group_no, ngt_linear_flag, ngt_linear_units,
 ngt_start_date, ngt_end_date, ngt_admin_type, 'G'
from nm_group_types where ngt_sub_group_allowed = 'N'
union all
select
 nit_inv_type, nit_descr, nit_screen_seq, nit_linear, 1,
 nit_start_date, nit_end_date, nit_admin_type, 'I'
from nm_inv_types
where nit_pnt_or_cont = 'C'
/
