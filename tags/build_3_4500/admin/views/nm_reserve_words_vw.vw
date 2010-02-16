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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_reserve_words_vw.vw-arc   3.2   Feb 16 2010 11:51:38   cstrettle  $
--       Module Name      : $Workfile:   nm_reserve_words_vw.vw  $
--       Date into PVCS   : $Date:   Feb 16 2010 11:51:38  $
--       Date fetched Out : $Modtime:   Feb 15 2010 11:44:40  $
--       Version          : $Revision:   3.2  $
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
WHERE  keyword NOT IN (select nrwe_keyword from nm_reserve_words_ex where nrwe_exclude = 'Y') -- Reserve words exclusion list to be maintained here
AND    reserved = 'Y'
/