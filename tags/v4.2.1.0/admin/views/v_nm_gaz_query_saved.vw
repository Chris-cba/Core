CREATE OR REPLACE VIEW v_nm_gaz_query_saved
AS 
   SELECT 
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_gaz_query_saved.vw-arc   3.0   Jul 13 2009 15:44:38   aedwards  $
    --       Module Name      : $Workfile:   v_nm_gaz_query_saved.vw  $
    --       Date into PVCS   : $Date:   Jul 13 2009 15:44:38  $
    --       Date fetched Out : $Modtime:   Jul 13 2009 15:37:22  $
    --       Version          : $Revision:   3.0  $
    --       Based on SCCS version : 
    -------------------------------------------------------------------------
          * 
     FROM v_nm_gaz_query_saved_all
    WHERE ( vngqs_ngqs_query_owner = USER
         OR vngqs_ngqs_query_owner = 'PUBLIC');
/

