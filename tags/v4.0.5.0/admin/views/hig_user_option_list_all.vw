CREATE OR REPLACE FORCE VIEW  hig_user_option_list_all
(  HUOL_ID
,  HUOL_PRODUCT
,  HUOL_NAME
,  HUOL_REMARKS
,  HUOL_DOMAIN
,  HUOL_DATATYPE
,  HUOL_MIXED_CASE
,  HUOL_PRODUCT_OPTION)
AS 
SELECT
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       sccsid           : @(#)hig_user_option_list_all.vw	1.1 10/26/05
--       Module Name      : hig_user_option_list_all.vw
--       Date into SCCS   : 05/10/26 17:28:35
--       Date fetched Out : 07/06/13 17:08:02
--       SCCS Version     : 1.1
--
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
FROM hig_user_option_list
WHERE not exists (select 'x'
                  from hig_option_list
				  where hol_id = huol_id)
ORDER BY 2,1
/
