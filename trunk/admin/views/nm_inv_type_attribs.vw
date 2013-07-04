CREATE OR replace force view nm_inv_type_attribs 
(
  ita_inv_type
, ita_attrib_name
, ita_dynamic_attrib
, ita_disp_seq_no
, ita_mandatory_yn
, ita_format
, ita_fld_length
, ita_dec_places
, ita_scrn_text
, ita_id_domain
, ita_validate_yn
, ita_dtp_code
, ita_max
, ita_min
, ita_view_attri
, ita_view_col_name
, ita_start_date
, ita_end_date
, ita_queryable
, ita_ukpms_param_no
, ita_units
, ita_format_mask
, ita_exclusive
, ita_keep_history_yn
, ita_date_created
, ita_date_modified
, ita_modified_by
, ita_created_by
, ita_query
, ita_displayed
, ita_disp_width
, ita_inspectable
, ita_case
)
AS
SELECT
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)nm_inv_type_attribs.vw	1.3 03/24/05
--       Module Name      : nm_inv_type_attribs.vw
--       Date into SCCS   : 05/03/24 16:22:06
--       Date fetched Out : 07/06/13 17:08:09
--       SCCS Version     : 1.3
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
        ita_inv_type
			, ita_attrib_name
			, ita_dynamic_attrib
			, ita_disp_seq_no
			, ita_mandatory_yn
			, ita_format
			, ita_fld_length
			, ita_dec_places
			, ita_scrn_text
			, ita_id_domain
			, ita_validate_yn
			, ita_dtp_code
			, ita_max
			, ita_min
			, ita_view_attri
			, ita_view_col_name
			, ita_start_date
			, ita_end_date
			, ita_queryable
			, ita_ukpms_param_no
			, ita_units
			, ita_format_mask
			, ita_exclusive
			, ita_keep_history_yn
			, ita_date_created
			, ita_date_modified
			, ita_modified_by
			, ita_created_by
			, ita_query
			, ita_displayed
			, ita_disp_width
			, ita_inspectable
			, ita_case
  FROM  nm_inv_type_attribs_all
 WHERE  ita_start_date                                    <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
   AND  NVL(ita_end_date,TO_DATE('99991231','YYYYMMDD'))  >   To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
/
