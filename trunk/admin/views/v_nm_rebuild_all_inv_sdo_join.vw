Create Or Replace Force View V_Nm_Rebuild_All_Inv_Sdo_Join
(
View_Name,
View_Text,
View_Comments
)
As
Select  
          --
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_rebuild_all_inv_sdo_join.vw-arc   3.0   Sep 02 2011 11:49:00   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_nm_rebuild_all_inv_sdo_join.vw  $
          --       Date into PVCS   : $Date:   Sep 02 2011 11:49:00  $
          --       Date fetched Out : $Modtime:   Aug 16 2011 14:09:24  $
          --       Version          : $Revision:   3.0  $
          -------------------------------------------------------------------------
          --
          rais.View_Name                                                                                                                                                                View_Name,
          --
          'Create Or Replace Force View'            
          || Chr(10)  ||  rais.View_Name
          || Chr(10)  ||  'As'                                                              
          || Chr(10)  ||  'Select '                                                                           
          || Chr(10)  ||  '       i.*, '
          || Chr(10)  ||  (
                          Case
                            When Nvl( Hig.Get_Sysopt('SDOSURKEY'),'N') = 'Y' Then
                              '       s.Objectid,'
                            Else
                              ''
                          End
                          )                 
          ||              '       s.Geoloc'
          || Chr(10)  ||  'From   '   || nit.Inv_Table    || ' i,'
          || Chr(10)  ||  '       '   || rais.Table_Name     || ' s'
          || Chr(10)  ||  'Where  i.' || nit.Join_Column  || '  =     s.Ne_Id '
          || Chr(10)  ||  'And    s.'     || Initcap(Nvl(rais.Start_Date_Column,'Start_Date')) || '  <=    Sys_Context(''NM3CORE'',''APPLICATION_OWNER'')'
          || Chr(10)  ||  'And    Nvl(s.' || Initcap(Nvl(rais.End_Date_Column,'End_Date')) || ',TO_DATE(''99991231'',''YYYYMMDD'')) >  Sys_Context(''NM3CORE'',''APPLICATION_OWNER'')'  View_Text,
          --
          'Comment on Table ' || rais.View_Name  ||    ' Is ''Created By :V_Nm_Rebuild_All_Inv_Sdo_Join ' 
                                                 || Chr(10) || 'Created On :' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') 
                                                 || Chr(10) || 'Version    :$Revision:   3.0  $'''                                                                                              View_Comments         
From    (
        --Gets the Inventory views that can be rebuilt.
        Select    Nit.Nith_Nit_Id                                                             Inv_Type,
                  --Remove the suffix and prefix to get the base object name, assumes prefix V_ and suffix _DT.
                  Substr(Substr(Nta.Nth_Feature_Table,1,Length(Nta.Nth_Feature_Table)-3 ),3)  Table_Name,
                  Nta.Nth_Feature_Table                                                       View_Name,
                  nta.Nth_Start_Date_Column                                                   Start_Date_Column,
                  nta.Nth_End_Date_Column                                                     End_Date_Column
        From      Nm_Themes_All     Nta,
                  Nm_Inv_Themes     Nit
        Where     Nit.Nith_Nth_Theme_Id     =       Nta.Nth_Theme_Id
        And       Nta.Nth_Base_Table_Theme  Is      Not Null
        And       Nta.Nth_Feature_Table     Like    Sys_Context ('NM3SQL', 'THEME_API_FEATURE_TAB')        
        And       Not Exists                (       Select  Null
                                                    From    Nm_Nw_Ad_Types    Nnat
                                                    Where   Nit.Nith_Nit_Id   =    Nnat.Nad_Inv_Type
                                                    And     Nnat.Nad_Nt_Type  =    'NSGN'
                                            )
        ) rais,
        --Gets the meta data for the views.
        (
        Select  nit.Nit_Inv_Type,
                nit.Nit_Table_Name,
                nit.Nit_Foreign_Pk_Column,
                --Keep this Case in sync with the Join_Column one.
                (
                Case
                  When Nit_Table_Name Is Not Null Then
                    nit.Nit_Table_Name
                  Else
                    Nm3inv_View.Derive_Inv_Type_View_Name (pi_Inv_Type => nit.Nit_Inv_Type)                        
                End
                ) Inv_Table,
                --Keep this Case in sync with the Inv_Table one.
                (
                Case
                  When Nit_Table_Name Is Not Null Then
                    InitCap(nit.Nit_Foreign_Pk_Column)
                  Else
                    'Iit_Ne_Id'
                End
                ) Join_Column
        From    Nm_Inv_Types    nit
        ) nit
Where   Nit.Nit_Inv_Type  =   rais.Inv_Type
With Read Only
/
 

