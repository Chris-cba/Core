CREATE OR REPLACE VIEW v_nm_gaz_query_saved
AS 
   SELECT 
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_gaz_query_saved.vw-arc   3.2   Jul 04 2013 11:35:14   James.Wadsworth  $
    --       Module Name      : $Workfile:   v_nm_gaz_query_saved.vw  $
    --       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
    --       Date fetched Out : $Modtime:   Jul 04 2013 11:32:10  $
    --       Version          : $Revision:   3.2  $
    --       Based on SCCS version : 
    -----------------------------------------------------------------------------
    --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
          * 
     FROM v_nm_gaz_query_saved_all
    WHERE ( vngqs_ngqs_query_owner = Sys_Context('NM3_SECURITY_CTX','USERNAME')
         OR vngqs_ngqs_query_owner = 'PUBLIC');
/

