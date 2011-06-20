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
,haud_description
)
AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_audits_vw.vw-arc   3.2   Jun 20 2011 11:40:48   Linesh.Sorathia  $
--       Module Name      : $Workfile:   hig_audits_vw.vw  $
--       Date into PVCS   : $Date:   Jun 20 2011 11:40:48  $
--       Date fetched Out : $Modtime:   Jun 20 2011 10:05:44  $
--       Version          : $Revision:   3.2  $
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
       ,haud_description
FROM    hig_audits
       ,nm_inv_types
       ,nm_inv_type_attribs
       ,hig_users
WHERE  haud_nit_inv_type   = nit_inv_type
AND    haud_table_name = nit_table_name
AND    haud_attribute_name = ita_attrib_name
AND    haud_nit_inv_type   = ita_inv_type
AND    haud_hus_user_id = hus_user_id
AND    1 = hig_audit.security_check(nit_category,nit_table_name,nit_foreign_pk_column,haud_pk_id)
/

