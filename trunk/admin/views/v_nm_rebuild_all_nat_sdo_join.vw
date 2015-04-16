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
          --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_rebuild_all_nat_sdo_join.vw-arc   3.5   Apr 16 2015 20:39:28   Rob.Coupe  $
          --       Module Name      : $Workfile:   v_nm_rebuild_all_nat_sdo_join.vw  $
          --       Date into PVCS   : $Date:   Apr 16 2015 20:39:28  $
          --       Date fetched Out : $Modtime:   Apr 16 2015 21:36:10  $
          --       Version          : $Revision:   3.5  $
          -----------------------------------------------------------------------------
          --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
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
                          When ( NVL( Hig.Get_Sysopt('SDOSINGSHP'), 'N') = 'N' AND 
						         Ngt_Sub_Group_Allowed = 'N' )  Then
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
                                                || Chr(10) || 'Version    :$Revision:   3.5  $'''                                               View_Comments         
From    (        
        --Gets Linear views that can be rebuilt.
        Select  naty.Nat_Nt_Type,
                naty.Nat_Gty_Group_Type,
                ngt.Ngt_Sub_Group_allowed,
                nta.Nth_Feature_Table                                                       Table_Name,
                'V_'||nta.Nth_Feature_table||'_DT'                                          View_Name
        From    Nm_Themes_All   nta,
                Nm_Area_Themes  nat,
                Nm_Area_Types   naty,
				Nm_Group_Types  ngt

        Where   nta.Nth_Base_Table_Theme    Is      Null
        And     nat.Nath_Nth_Theme_Id       =       nta.Nth_Theme_Id 
        And     nat.Nath_Nat_Id             =       naty.Nat_Id    
        And     ngt.Ngt_Group_type          =       naty.Nat_Gty_Group_Type
        And     ngt.Ngt_Nt_TYpe             =       naty.Nat_Nt_Type
        And     nta.Nth_Feature_Table       Like    Sys_Context ('NM3SQL', 'THEME_API_FEATURE_TAB')        
        ) vw
Where   Not Exists  (
                    Select  Null
                    From    Nm_Themes_All     nta,
                            Nm_Area_Themes    nat,
                            Nm_Area_Types     naty
                    Where   nta.Nth_Feature_Table =   vw.View_Name
                    And     nta.Nth_Theme_Id      =   nat.Nath_Nth_Theme_Id
                    And     nat.Nath_Nat_Id       =   naty.Nat_Id
                    And     naty.Nat_Nt_Type      =   'NSGN'
                    )
With Read Only
/             
                  
               
