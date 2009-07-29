CREATE OR REPLACE FORCE VIEW nm_attrib_view_vw (
nav_disp_ord,
nav_nt_type ,
nav_inv_type,
nav_col_name,
nav_col_type ,
nav_col_length ,
nav_col_mandatory ,
nav_col_domain,
nav_col_updatable,
nav_col_prompt,
nav_col_format,
nav_col_seq_no,
nav_gty_type ,
nav_parent_type_inc,
nav_child_type_inc,
nav_child_col,
nav_parent_col
)
AS
SELECT
--
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_attrib_view_vw.vw-arc   3.1   Jul 29 2009 15:03:36   lsorathia  $
--       Module Name      : $Workfile:   nm_attrib_view_vw.vw  $
--       Date into PVCS   : $Date:   Jul 29 2009 15:03:36  $
--       Date fetched Out : $Modtime:   Jul 29 2009 15:01:14  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
-- 
1 disp_ord,
       ntc_nt_type ,
       Null ,
       ntc_column_name ,
       ntc_column_type ,
       ntc_str_length ,
       ntc_mandatory ,
       ntc_domain,
       nm3_bulk_attrib_upd.check_col_upd(ntc_column_name,ntc_nt_type),
       ntc_prompt,
       ntc_format,
       ntc_seq_no,
       Null ,
       nm3_bulk_attrib_upd.parent_inclusion_type(ntc_column_name,ntc_nt_type) parent_type_inc,
       nm3_bulk_attrib_upd.child_inclusion_type(ntc_column_name,ntc_nt_type)  child_type_inc,
       (SELECT nti_child_column FROM nm_type_inclusion WHERE  nti_nw_parent_type = ntc_nt_type 
                                                     ) child_col,
       (SELECT nti_parent_column FROM nm_type_inclusion WHERE  nti_nw_child_type = ntc_nt_type AND nti_child_column = ntc_column_name 
                                                     ) parent_col
FROM   nm_type_columns ntc
union
select 2 disp_ord,
       nad_nt_type ,
       ita_inv_type,
       ita_attrib_name,
       ita_format,
       ita_fld_length,
       ita_mandatory_yn,
       ita_id_domain,'Y' ,
       ita_scrn_text,
       ita_format,
       ita_disp_seq_no ,
       nad_gty_type   ,
       Null ,
       Null,
       Null,
       Null 
FROM   nm_inv_type_attribs ita,nm_nw_ad_types nad
WHERE  ita.ita_inv_type =  nad.nad_inv_type
AND    nad_primary_ad   = 'Y'
/
