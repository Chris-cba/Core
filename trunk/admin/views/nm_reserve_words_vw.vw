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
--       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/nm_reserve_words_vw.vw-arc   3.4   Apr 13 2018 11:47:20   Gaurav.Gaurkar  $
--       Module Name      : $Workfile:   nm_reserve_words_vw.vw  $
--       Date into PVCS   : $Date:   Apr 13 2018 11:47:20  $
--       Date fetched Out : $Modtime:   Apr 13 2018 11:36:08  $
--       Version          : $Revision:   3.4  $
--       Based on SCCS version : 
-------------------------------------------------------------------------
--
-----------------------------------------------------------------------------
-- Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
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
