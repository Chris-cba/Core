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
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/hig_user_option_list_all.vw-arc   2.3   Apr 13 2018 11:47:16   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   hig_user_option_list_all.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:16  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:31:38  $
--       Version          : $Revision:   2.3  $
-------------------------------------------------------------------------
--
--   Author : G Johnson
--
-----------------------------------------------------------------------------
--   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
