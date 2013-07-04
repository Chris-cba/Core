CREATE OR Replace Force View hig_user_details_vw 
( 
 hud_HUS_USER_ID  
,hud_HUS_INITIALS  
,hud_HUS_NAME  
,hud_HUS_USERNAME  
,hud_HUS_JOB_TITLE
,hud_huc_ID              
,hud_huc_ADDRESS1       
,hud_huc_ADDRESS2       
,hud_huc_ADDRESS3       
,hud_huc_ADDRESS4       
,hud_huc_ADDRESS5       
,hud_huc_tel_type_1     
,hud_huc_TELEPHONE_1    
,hud_huc_primary_tel_1  
,hud_huc_tel_type_2     
,hud_huc_TELEPHONE_2    
,hud_huc_primary_tel_2    
,hud_huc_tel_type_3     
,hud_huc_TELEPHONE_3    
,hud_huc_primary_tel_3    
,hud_huc_tel_type_4     
,hud_huc_TELEPHONE_4    
,hud_huc_primary_tel_4    
,hud_huc_POSTCODE       
,hud_huc_DATE_CREATED   
,hud_huc_DATE_MODIFIED  
,hud_huc_MODIFIED_BY    
,hud_huc_CREATED_BY      
)      
AS   
SELECT  
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/hig_user_details_vw.vw-arc   3.1   Jul 04 2013 11:20:06   James.Wadsworth  $
--       Module Name      : $Workfile:   hig_user_details_vw.vw  $
--       Date into PVCS   : $Date:   Jul 04 2013 11:20:06  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:58:44  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
 HUS_USER_ID  
,HUS_INITIALS  
,HUS_NAME  
,HUS_USERNAME  
,HUS_JOB_TITLE
,huc_ID              
,huc_ADDRESS1       
,huc_ADDRESS2       
,huc_ADDRESS3       
,huc_ADDRESS4       
,huc_ADDRESS5       
,huc_tel_type_1     
,huc_TELEPHONE_1    
,huc_primary_tel_1  
,huc_tel_type_2     
,huc_TELEPHONE_2    
,huc_primary_tel_2    
,huc_tel_type_3     
,huc_TELEPHONE_3    
,huc_primary_tel_3    
,huc_tel_type_4     
,huc_TELEPHONE_4    
,huc_primary_tel_4    
,huc_POSTCODE       
,huc_DATE_CREATED   
,huc_DATE_MODIFIED  
,huc_MODIFIED_BY    
,huc_CREATED_BY      
FROM   hig_users hus,
       hig_user_CONTACTS_ALL huc
WHERE  hus.hus_user_id = huc.huc_hus_user_id(+)
/
