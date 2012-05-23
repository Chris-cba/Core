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
        --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_doc_gateway_resolve.vw-arc   1.0   May 23 2012 14:08:54   Steve.Cooper  $
        --       Module Name      : $Workfile:   v_doc_gateway_resolve.vw  $
        --       Date into PVCS   : $Date:   May 23 2012 14:08:54  $
        --       Date fetched Out : $Modtime:   May 23 2012 13:24:46  $
        --       Version          : $Revision:   1.0  $
        --       Based on SCCS version : 
        -------------------------------------------------------------------------
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
