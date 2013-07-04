Create Or Replace Force View V_Nm_Rebuild_All_Nlt_Sdo_Join
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
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_rebuild_all_nlt_sdo_join.vw-arc   3.3   Jul 04 2013 11:35:14   James.Wadsworth  $
          --       Module Name      : $Workfile:   v_nm_rebuild_all_nlt_sdo_join.vw  $
          --       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
          --       Date fetched Out : $Modtime:   Jul 04 2013 11:33:06  $
          --       Version          : $Revision:   3.3  $
          -----------------------------------------------------------------------------
          --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          --
          rais.View_Name                                                                                                                View_Name,
          --
          'Create Or Replace View '   
          || Chr(10) || rais.View_Name
          || Chr(10) || 'As'
          || Chr(10) || 'Select   n.*,'
          || Chr(10) || (
                        Case
                          When  Nvl( Hig.Get_Sysopt('SDOSURKEY'),'N') = 'Y' Then
                            '         s.Objectid,'       || Chr(10)  
                          Else
                            ''
                        End
                        )
                     || '         s.Geoloc'                    
          || Chr(10) || 'From     ' || Base_View_Name  || ' n,'
          || Chr(10) || '         ' || Table_Name      || ' s'
          || Chr(10) || 'Where    n.Ne_Id  = s.Ne_Id'
          || Chr(10) || 'And      s.Start_Date                                       <=  To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')'
          || Chr(10) || 'And      Nvl(s.End_Date,TO_DATE(''99991231'',''YYYYMMDD'')) >   To_Date(Sys_Context(''NM3CORE'',''EFFECTIVE_DATE''),''DD-MON-YYYY'')'   View_Text,
          --
          'Comment on Table ' || rais.View_Name ||     ' Is ''Created By :V_Nm_Rebuild_All_Nlt_Sdo_Join ' 
                                                || Chr(10) || 'Created On :' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss') 
                                                || Chr(10) || 'Version    :$Revision:   3.3  $'''                                               View_Comments         
From    (        
        --Gets Linear views that can be rebuilt.
        Select  nlt.Nlt_Nt_Type,
                nlt.Nlt_Gty_Type,
                nta.Nth_Feature_Table                                                       Table_Name,
                'V_'||nta.nth_feature_table||'_DT'                                          View_Name,
                'V_NM_'|| nlt.Nlt_Nt_Type || '_' || nlt.Nlt_Gty_Type || '_NT'               Base_View_Name
        From    Nm_Themes_All     nta,
                Nm_Nw_Themes      nnt,
                Nm_Linear_Types   nlt
        Where   nta.Nth_Base_Table_Theme  Is    Null
        And     nnt.Nnth_Nth_Theme_Id     =     nta.Nth_Theme_Id 
        And     nnt.Nnth_Nlt_Id           =     nlt.Nlt_Id
        And     nta.Nth_Feature_Table     Like  Sys_Context ('NM3SQL', 'THEME_API_FEATURE_TAB')
        ) rais
With Read Only
/

