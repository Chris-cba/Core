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
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/nm_reserve_words_vw.vw-arc   3.0   Apr 24 2009 13:26:32   lsorathia  $
--       Module Name      : $Workfile:   nm_reserve_words_vw.vw  $
--       Date into PVCS   : $Date:   Apr 24 2009 13:26:32  $
--       Date fetched Out : $Modtime:   Apr 24 2009 12:42:24  $
--       Version          : $Revision:   3.0  $
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
WHERE  keyword NOT IN ('LAYER') -- Reserve words exclusion list to be maintained here
AND    reserved = 'Y'
/