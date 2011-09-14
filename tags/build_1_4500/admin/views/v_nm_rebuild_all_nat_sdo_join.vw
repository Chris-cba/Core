Create Or Replace Force View V_Nm_Rebuild_All_Nat_Sdo_Join
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
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_rebuild_all_nat_sdo_join.vw-arc   3.1   Sep 14 2011 10:09:18   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_nm_rebuild_all_nat_sdo_join.vw  $
          --       Date into PVCS   : $Date:   Sep 14 2011 10:09:18  $
          --       Date fetched Out : $Modtime:   Sep 14 2011 09:50:32  $
          --       Version          : $Revision:   3.1  $
          -------------------------------------------------------------------------
          --
          vw.View_Name                                                                                                                  View_Name,
          --
          'Create Or Replace View '   
          || Chr(10) || vw.View_Name
          || Chr(10) || 'As'
          || Chr(10) || 'Select   n.*,'
          || Chr(10) || (
                        Case
                          When Nvl( Hig.Get_Sysopt('SDOSURKEY'),'N') = 'Y' Then
                            '         s.Objectid,    ' || Chr(10)
                        End
                        )          
          ||           (
                        Case
                          When  NVL( Hig.Get_Sysopt('SDOSINGSHP'), 'N') = 'N' Then
                            '         s.Ne_Id_Of,    ' || Chr(10) || 
                            '         s.Nm_Begin_Mp, ' || Chr(10) || 
                            '         s.Nm_End_Mp,'    || Chr(10)
                          Else
                            ''
                        End
                        )
                     || '         s.Geoloc'                    
          || Chr(10) || 'From     V_NM_' || vw.Nat_Nt_Type || '_' || vw.Nat_Gty_Group_Type || '_NT n,' 
          || Chr(10) || '         ' || vw.Table_Name || ' s'  
          || Chr(10) || 'Where    n.Ne_Id                                        =   s.Ne_Id'
          || Chr(10) || 'And      s.Start_Date                                   <=  To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')'
          || Chr(10) || 'And      Nvl(s.End_Date,TO_DATE(''99991231'',''YYYYMMDD'')) >   To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')'   View_Text,
          --
          'Comment on Table ' || vw.View_Name ||     ' Is ''Created By :V_Nm_Rebuild_All_Nlt_Sdo_Join ' 
                                                || Chr(10) || 'Created On :' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') 
                                                || Chr(10) || 'Version    :$Revision:   3.1  $'''                                               View_Comments         
From    (        
        --Gets Linear views that can be rebuilt.
        Select  naty.Nat_Nt_Type,
                naty.Nat_Gty_Group_Type,
                --Remove the suffix and prefix to get the base object name, assumes prefix V_ and suffix _DT.
                Substr(Substr(nta.Nth_Feature_Table,1,Length(nta.Nth_Feature_Table)-3 ),3)  Table_Name,
                nta.Nth_Feature_Table                                                       View_Name
        From    Nm_Themes_All   nta,
                Nm_Area_Themes  nat,
                Nm_Area_Types   naty
        Where   nta.Nth_Base_Table_Theme    Is      Not Null
        And     nat.Nath_Nth_Theme_Id       =       nta.Nth_Theme_Id 
        And     nat.Nath_Nat_Id             =       naty.Nat_Id             
        And     nta.Nth_Feature_Table       Like    Sys_Context ('NM3SQL', 'THEME_API_FEATURE_TAB')
        And     naty.Nat_Nt_Type            !=      'NSGN'             
        ) vw
With Read Only
/             
                  
               