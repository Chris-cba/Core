CREATE OR REPLACE FORCE VIEW hig_audits_vw
(
 haud_id
,haud_INV_TYPE
,haud_inv_descr
,haud_TABLE_NAME
,haud_ATTRIBUTE_NAME
,haud_screen_text
,haud_PK_ID
,haud_OLD_VALUE
,haud_NEW_VALUE
,haud_TIMESTAMP
,haud_OPERATION
,haud_HUS_USER_ID
,haud_username
,haud_terminal
,haud_os_user
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_audits_vw.vw-arc   3.0   Apr 14 2010 10:45:10   malexander  $
--       Module Name      : $Workfile:   hig_audits_vw.vw  $
--       Date into PVCS   : $Date:   Apr 14 2010 10:45:10  $
--       Date fetched Out : $Modtime:   Apr 14 2010 10:44:40  $
--       Version          : $Revision:   3.0  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
-- 
SELECT  haud_id
       ,haud_nit_inv_type
       ,nit_descr
       ,haud_table_name
       ,haud_attribute_name
       ,ita_scrn_text
       ,haud_pk_id
       ,haud_old_value
       ,haud_new_value
       ,haud_timestamp
       ,Decode(haud_operation,'I','Insert','D','Delete','U','Update')
       ,haud_hus_user_id
       ,hus_name
       ,haud_terminal
       ,haud_os_user
FROM    hig_audits
       ,nm_inv_types
       ,nm_inv_type_attribs
       ,hig_users
WHERE  haud_nit_inv_type   = nit_inv_type
AND    haud_table_name = nit_table_name
AND    haud_attribute_name = ita_attrib_name
AND    haud_nit_inv_type   = ita_inv_type
AND    haud_hus_user_id = hus_user_id
/


