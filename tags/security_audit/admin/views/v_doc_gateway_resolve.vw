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
        --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_doc_gateway_resolve.vw-arc   1.2   Apr 13 2018 11:47:22   Gaurav.Gaurkar  $
        --       Module Name      : $Workfile:   v_doc_gateway_resolve.vw  $
        --       Date into PVCS   : $Date:   Apr 13 2018 11:47:22  $
        --       Date fetched Out : $Modtime:   Apr 13 2018 11:36:08  $
        --       Version          : $Revision:   1.2  $
        --       Based on SCCS version : 
        -----------------------------------------------------------------------------
        --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
