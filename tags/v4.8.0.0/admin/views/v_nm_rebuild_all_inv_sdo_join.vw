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
          --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_rebuild_all_inv_sdo_join.vw-arc   3.6   Apr 13 2018 11:47:24   Gaurav.Gaurkar  $
          --       Module Name      : $Workfile:   v_nm_rebuild_all_inv_sdo_join.vw  $
          --       Date into PVCS   : $Date:   Apr 13 2018 11:47:24  $
          --       Date fetched Out : $Modtime:   Apr 13 2018 11:41:12  $
          --       Version          : $Revision:   3.6  $
          -----------------------------------------------------------------------------
          --    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
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
          || Chr(10)  ||  'And    s.'     || Initcap(Nvl(rais.Start_Date_Column,'Start_Date')) || '  <=    To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')'
          || Chr(10)  ||  'And    Nvl(s.' || Initcap(Nvl(rais.End_Date_Column,'End_Date')) || ',TO_DATE(''99991231'',''YYYYMMDD'')) >  To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')'  View_Text,
          --
          'Comment on Table ' || rais.View_Name  ||    ' Is ''Created By :V_Nm_Rebuild_All_Inv_Sdo_Join ' 
                                                 || Chr(10) || 'Created On :' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') 
                                                 || Chr(10) || 'Version    :$Revision:   3.6  $'''                                                                                              View_Comments         
From    (
        --Gets the Inventory views that can be rebuilt.
        Select    Nit.Nith_Nit_Id                                                             Inv_Type,
                  Nta.Nth_Feature_Table                                                       Table_Name,
                   'V_'||Nta.Nth_Feature_Table||'_DT'                                         View_Name,
                  nta.Nth_Start_Date_Column                                                   Start_Date_Column,
                  nta.Nth_End_Date_Column                                                     End_Date_Column
        From      Nm_Themes_All     Nta,
                  Nm_Inv_Themes     Nit
        Where     Nit.Nith_Nth_Theme_Id     =       Nta.Nth_Theme_Id
        And       Nta.Nth_Base_Table_Theme  Is      Null
        And       Nta.Nth_Feature_Table     Like    Sys_Context ('NM3SQL', 'THEME_API_FEATURE_TAB')
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
And     Not Exists  (
                  Select  Null
                  From    Nm_Themes_All   nta,
                          Nm_Inv_Themes   nit,
                          Nm_Nw_Ad_Types  nnat
                  Where   nta.Nth_Feature_Table   =   rais.View_Name 
                  And     nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
                  And     nit.Nith_Nit_Id         =   nnat.Nad_Inv_Type
                  And     nnat.Nad_Nt_Type        =   'NSGN' 
                  )  
With Read Only
/
 
