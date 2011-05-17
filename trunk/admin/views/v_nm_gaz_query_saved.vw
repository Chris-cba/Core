CREATE OR REPLACE VIEW v_nm_gaz_query_saved
AS 
   SELECT 
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_gaz_query_saved.vw-arc   3.1   May 17 2011 08:32:46   Steve.Cooper  $
    --       Module Name      : $Workfile:   v_nm_gaz_query_saved.vw  $
    --       Date into PVCS   : $Date:   May 17 2011 08:32:46  $
    --       Date fetched Out : $Modtime:   May 06 2011 09:55:14  $
    --       Version          : $Revision:   3.1  $
    --       Based on SCCS version : 
    -------------------------------------------------------------------------
          * 
     FROM v_nm_gaz_query_saved_all
    WHERE ( vngqs_ngqs_query_owner = Sys_Context('NM3_SECURITY_CTX','USERNAME')
         OR vngqs_ngqs_query_owner = 'PUBLIC');
/

