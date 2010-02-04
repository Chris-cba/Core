CREATE OR REPLACE FORCE VIEW  hig_user_option_list_all
(  HUOL_ID
,  HUOL_PRODUCT
,  HUOL_NAME
,  HUOL_REMARKS
,  HUOL_DOMAIN
,  HUOL_DATATYPE
,  HUOL_MIXED_CASE
,  HUOL_PRODUCT_OPTION
,  HUOL_MAX_LENGTH)
AS 
SELECT
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_user_option_list_all.vw-arc   2.1   Feb 04 2010 10:26:20   cstrettle  $
--       Module Name      : $Workfile:   hig_user_option_list_all.vw  $
--       Date into PVCS   : $Date:   Feb 04 2010 10:26:20  $
--       Date fetched Out : $Modtime:   Feb 04 2010 10:22:08  $
--       Version          : $Revision:   2.1  $
-------------------------------------------------------------------------
--
--   Author : G Johnson
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2005
-----------------------------------------------------------------------------
--   
   HOL_ID
,  HOL_PRODUCT
,  HOL_NAME
,  HOL_REMARKS
,  HOL_DOMAIN
,  HOL_DATATYPE
,  HOL_MIXED_CASE
,  HOL_USER_OPTION
,  HOL_MAX_LENGTH
FROM hig_option_list
WHERE hol_user_option = 'Y'
UNION
SELECT   
   HUOL_ID
,  HUOL_PRODUCT
,  HUOL_NAME
,  HUOL_REMARKS
,  HUOL_DOMAIN
,  HUOL_DATATYPE
,  HUOL_MIXED_CASE
,  'N'
,  HUOL_MAX_LENGTH
FROM hig_user_option_list
WHERE not exists (select 'x'
                  from hig_option_list
				  where hol_id = huol_id)
ORDER BY 2,1
/
