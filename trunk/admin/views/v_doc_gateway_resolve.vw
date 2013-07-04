Create Or Replace View V_Doc_Gateway_Resolve
(
Gateway_Name,
Synonym_Name
)
As
Select
        --
        -------------------------------------------------------------------------
        --   PVCS Identifiers :-
        --
        --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_doc_gateway_resolve.vw-arc   1.1   Jul 04 2013 11:35:12   James.Wadsworth  $
        --       Module Name      : $Workfile:   v_doc_gateway_resolve.vw  $
        --       Date into PVCS   : $Date:   Jul 04 2013 11:35:12  $
        --       Date fetched Out : $Modtime:   Jul 04 2013 11:29:02  $
        --       Version          : $Revision:   1.1  $
        --       Based on SCCS version : 
        -----------------------------------------------------------------------------
        --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
        -----------------------------------------------------------------------------
        --
        Gateway_Name,
        Synonym_Name
From    (        
        Select  dg.Dgt_Table_Name                       Gateway_Name,
                Nvl(dgs.Dgs_Table_Syn,Dgt_Table_Name)   Synonym_Name
        From    Doc_Gateways    dg,
                Doc_Gate_Syns   dgs
        Where   dg.Dgt_Table_Name                                                                       =   dgs.Dgs_Dgt_Table_Name(+)
        And     Nvl(dg.Dgt_Start_Date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'))   >=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
        And     Nvl(dg.Dgt_End_Date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')+1)   >=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
        Union        
        Select  dg.Dgt_Table_Name                       Gateway_Name,
                dg.Dgt_Table_Name                       Synonym_Name
        From    Doc_Gateways    dg
        Where   Nvl(dg.Dgt_Start_Date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY'))   >=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
        And     Nvl(dg.Dgt_End_Date,To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')+1)   >=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')        
        )
/
