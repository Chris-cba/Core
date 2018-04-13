CREATE OR REPLACE VIEW v_nm_gaz_query_saved
AS 
   SELECT 
    -------------------------------------------------------------------------
    --   PVCS Identifiers :-
    --
    --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_gaz_query_saved.vw-arc   3.3   Apr 13 2018 11:47:24   Gaurav.Gaurkar  $
    --       Module Name      : $Workfile:   v_nm_gaz_query_saved.vw  $
    --       Date into PVCS   : $Date:   Apr 13 2018 11:47:24  $
    --       Date fetched Out : $Modtime:   Apr 13 2018 11:41:12  $
    --       Version          : $Revision:   3.3  $
    --       Based on SCCS version : 
    -----------------------------------------------------------------------------
    --    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
    -----------------------------------------------------------------------------
          * 
     FROM v_nm_gaz_query_saved_all
    WHERE ( vngqs_ngqs_query_owner = Sys_Context('NM3_SECURITY_CTX','USERNAME')
         OR vngqs_ngqs_query_owner = 'PUBLIC');
/

