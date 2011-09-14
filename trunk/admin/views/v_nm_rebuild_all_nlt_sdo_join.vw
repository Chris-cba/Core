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
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_rebuild_all_nlt_sdo_join.vw-arc   3.1   Sep 14 2011 10:09:18   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_nm_rebuild_all_nlt_sdo_join.vw  $
          --       Date into PVCS   : $Date:   Sep 14 2011 10:09:18  $
          --       Date fetched Out : $Modtime:   Sep 14 2011 09:50:14  $
          --       Version          : $Revision:   3.1  $
          -------------------------------------------------------------------------
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
                                                || Chr(10) || 'Version    :$Revision:   3.1  $'''                                               View_Comments         
From    (        
        --Gets Linear views that can be rebuilt.
        Select  nlt.Nlt_Nt_Type,
                nlt.Nlt_Gty_Type,
                --Remove the suffix and prefix to get the base object name, assumes prefix V_ and suffix _DT.
                Substr(Substr(nta.Nth_Feature_Table,1,Length(nta.Nth_Feature_Table)-3 ),3)  Table_Name,
                nta.Nth_Feature_Table                                                       View_Name,
                'V_NM_'|| nlt.Nlt_Nt_Type || '_' || nlt.Nlt_Gty_Type || '_NT'               Base_View_Name
        From    Nm_Themes_All     nta,
                Nm_Nw_Themes      nnt,
                Nm_Linear_Types   nlt
        Where   nta.Nth_Base_Table_Theme  Is    Not Null
        And     nnt.Nnth_Nth_Theme_Id     =     nta.Nth_Theme_Id 
        And     nnt.Nnth_Nlt_Id           =     nlt.Nlt_Id
        And     nta.Nth_Feature_Table     Like  Sys_Context ('NM3SQL', 'THEME_API_FEATURE_TAB')
        ) rais
With Read Only
/

