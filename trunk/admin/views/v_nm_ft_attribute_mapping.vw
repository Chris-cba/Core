CREATE OR REPLACE VIEW V_NM_FT_ATTRIBUTE_MAPPING
(ITA_INV_TYPE, NIT_TABLE_NAME, ITA_ATTRIB_NAME, IIT_ATTRIB_NAME)
AS
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_ft_attribute_mapping.vw-arc   2.2   Jul 04 2013 11:35:14   James.Wadsworth  $
--       Module Name      : $Workfile:   v_nm_ft_attribute_mapping.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:31:18  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
select
 q1.ita_inv_type
,q1.nit_table_name
,q1.ita_attrib_name
,case ita_format2
 when 'PK' then 'IIT_NE_ID'
 when 'CREATE_DATE' then 'IIT_DATE_CREATED'
 when 'DATE' then 'IIT_DATE_ATTRIB'||to_char(rnum + 85)
 when 'VARCHAR2_50' then 'IIT_CHR_ATTRIB'||to_char(rnum + 25)
 when 'VARCHAR2_200' then 'IIT_CHR_ATTRIB'||to_char(rnum + 55)
 when 'VARCHAR2_500' then 'IIT_CHR_ATTRIB'||to_char(rnum + 65)
 when 'NUMBER' then
   case
   when rnum > 20 then 'IIT_NUM_ATTRIB'||to_char(rnum + 75)
   when rnum > 10 then 'IIT_NUM_ATTRIB'||to_char(rnum + 65)
   else 'IIT_NUM_ATTRIB'||to_char(rnum + 15)
   end
 else null
 end IIT_ATTRIB_NAME
from (
select
   a.rid, a.ita_inv_type, t2.nit_table_name, a.ita_attrib_name, a.ita_fld_length, a.ita_format
  ,decode(t.nit_foreign_pk_column, null, a.ita_format2, 'PK') ita_format2
  ,row_number() over (partition by a.ita_inv_type
    , decode(t.nit_foreign_pk_column, null, a.ita_format2, 'PK') order by a.ita_attrib_name) rnum
from
   (select rowid rid
      ,ita_inv_type, ita_attrib_name, ita_fld_length, ita_format, ita_disp_seq_no
      ,case
       when ita_format = 'VARCHAR2' and ita_fld_length > 200 then 'VARCHAR2_500'
       when ita_format = 'VARCHAR2' and ita_fld_length > 50 then 'VARCHAR2_200'
       when ita_format = 'VARCHAR2' then 'VARCHAR2_50'
       when ita_attrib_name in ('CREATE_DATE') then ita_attrib_name
       else ita_format
       end ita_format2
    from nm_inv_type_attribs_all
   ) a
  ,nm_inv_types_all t
  ,nm_inv_types_all t2
where a.ita_inv_type = t.nit_inv_type (+)
  and a.ita_attrib_name = t.nit_foreign_pk_column (+)
  and a.ita_inv_type = t2.nit_inv_type
  and t2.nit_table_name is not null
) q1
/
