CREATE OR Replace Force View nm_reserve_words_vw
( 
keyword, 
length, 
reserved, 
res_type, 
res_attr, 
res_semi, 
duplicate
)      
AS   
SELECT  
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_reserve_words_vw.vw-arc   3.1   Aug 10 2009 15:55:44   drawat  $
--       Module Name      : $Workfile:   nm_reserve_words_vw.vw  $
--       Date into PVCS   : $Date:   Aug 10 2009 15:55:44  $
--       Date fetched Out : $Modtime:   Aug 10 2009 15:51:18  $
--       Version          : $Revision:   3.1  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
keyword, 
length, 
reserved, 
res_type, 
res_attr, 
res_semi, 
duplicate
FROM   v$reserved_words        
WHERE  keyword NOT IN ('LAYER','HIERARCHY','CATEGORY','NONE','VALUE') -- Reserve words exclusion list to be maintained here
AND    reserved = 'Y'
/