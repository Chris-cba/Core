create or replace force view vus_nm_elements
(NE_ID,
 NE_UNIQUE,
 NE_NT_TYPE,
 NE_DESCR,
 NE_LENGTH,
 NE_LENGTH_UNIT,
 NE_LENGTH_UNIT_NAME,
 NE_GTY_GROUP_TYPE,
 NE_DATE_CREATED,
 NE_DATE_MODIFIED,
 NE_MODIFIED_BY,
 NE_CREATED_BY,
 NE_START_DATE,
 NE_END_DATE,
 NE_OWNER,
 NE_NAME_1,
 NE_NAME_2,
 NE_PREFIX,
 NE_NUMBER,
 NE_SUB_TYPE,
 NE_GROUP,
 NE_NO_START,
 NE_NO_END,
 NE_SUB_CLASS,
 NE_NSG_REF,
 NE_VERSION_NO )
as
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/vus_nm_elements.vw-arc   2.2   Jul 04 2013 11:35:14   James.Wadsworth  $
--       Module Name      : $Workfile:   vus_nm_elements.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:34:30  $
--       Version          : $Revision:   2.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
select
 NE_ID,
 NE_UNIQUE,
 NE_NT_TYPE,
 NE_DESCR,
 nm3unit.convert_unit( nm3net.get_nt_units( ne_nt_type ),
        Sys_Context('NM3CORE','USER_LENGTH_UNITS'), NE_LENGTH) ,
 Sys_Context('NM3CORE','USER_LENGTH_UNITS'),
 nm3unit.get_unit_name( Sys_Context('NM3CORE','USER_LENGTH_UNITS') ),
 NE_GTY_GROUP_TYPE,
 NE_DATE_CREATED,
 NE_DATE_MODIFIED,
 NE_MODIFIED_BY,
 NE_CREATED_BY,
 NE_START_DATE,
 NE_END_DATE,
 NE_OWNER,
 NE_NAME_1,
 NE_NAME_2,
 NE_PREFIX,
 NE_NUMBER,
 NE_SUB_TYPE,
 NE_GROUP,
 NE_NO_START,
 NE_NO_END,
 NE_SUB_CLASS,
 NE_NSG_REF,
 NE_VERSION_NO
from nm_elements
/
