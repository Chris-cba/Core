Create Or Replace Package Body Nm3Sdm
As
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3sdm.pkb-arc   2.73   Apr 15 2015 14:49:38   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3sdm.pkb  $
--       Date into PVCS   : $Date:   Apr 15 2015 14:49:38  $
--       Date fetched Out : $Modtime:   Apr 15 2015 14:48:38  $
--       PVCS Version     : $Revision:   2.73  $
--
--   Author : R.A. Coupe
--
--   Spatial Data Manager specific package body
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2011
-----------------------------------------------------------------------------
--
--all global package variables here
--
  g_Body_Sccsid     Constant Varchar2 (2000) := '"$Revision:   2.73  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
  g_Package_Name    Constant Varchar2 (30)   := 'NM3SDM';
--

-- nw modules - use 1 for all, 2 for GoG and 3 for GoS
   
  g_Network_Modules  Ptr_Vc_Array := Ptr_Vc_Array ( Ptr_Vc_Array_Type(
                                                                     Ptr_Vc( 1, 'NM0105' ) -- elements
                                                                    ,Ptr_Vc( 2, 'NM0115' ) -- GOG
                                                                    ,Ptr_Vc( 3, 'NM0110' ) -- GOS
                                                                    ,Ptr_Vc( 1, 'NM1100' ) -- Gazetteer
                                                                    ));

  -- inv modules - use 1 for all, 2 where not applicable to FT

  g_Asset_Modules    Ptr_Vc_Array := Ptr_Vc_Array ( Ptr_Vc_Array_Type  (
                                                                       Ptr_Vc( 2, 'NM0510' ) -- assets
                                                                      ,Ptr_Vc( 2, 'NM0570' ) -- find asset
                                                                      ,Ptr_Vc( 2, 'NM0572' ) -- Locator
                                                                      ,Ptr_Vc( 2, 'NM0535' ) -- BAU
                                                                      ,Ptr_Vc( 2, 'NM0590' ) -- Asset Maintenance
                                                                      ,Ptr_Vc( 2, 'NM0560' ) -- Assets on a Route -- AE 4053
                                                                      ,Ptr_Vc( 2, 'NM0573' ) -- Asset Grid - AE 4100
                                                                      ));
  e_Not_Unrestricted Exception;
  e_No_Analyse_Privs Exception;
    
  Type t_View_Rec Is Record (
                            View_Name       User_Views.View_Name%Type,
                            View_Text       Varchar2(4000),
                            View_Comments   User_Tab_Comments.Comments%Type
                            );
                          
  Type t_View_Tab Is Table Of t_View_Rec Index By Binary_Integer;  
  
-----------------------------------------------------------------------------
  Function Get_Nat_Feature_Table_Name (
                                      p_Nt_Type    In   Nm_Types.Nt_Type%Type,
                                      p_Gty_Type   In   Nm_Group_Types.Ngt_Group_Type%Type
                                      ) Return Varchar2;

Procedure Create_G_of_G_Group_Layer (
                                        p_Nt_Type    In   Nm_Types.Nt_Type%Type,
                                        p_Gty_Type   In   Nm_Group_Types.Ngt_Group_Type%Type,
                                        p_Job_Id     In   Number Default Null
                                        );
--
  Function Get_Nat_Feature_Table_Name (
                                      p_Nt_Type    In   Nm_Types.Nt_Type%Type,
                                      p_Gty_Type   In   Nm_Group_Types.Ngt_Group_Type%Type
                                      ) Return Varchar2
  Is
  Begin
    Return 'NM_NAT_' || p_Nt_Type || '_' || p_Gty_Type || '_SDO';
  End Get_Nat_Feature_Table_Name;

-----------------------------------------------------------------------------------------------------------------

  Function Check_Sub_Sde_Exempt( pi_obj_name in varchar2) return Boolean is
  retval     Boolean := FALSE;
  l_dummy    Integer;
  begin
    select 1
    into l_dummy
    from all_objects, nm_sde_sub_layer_exempt
    where object_name like nssl_object_name
    and object_type = nssl_object_type
    and owner = sys_context('NM3CORE', 'APPLICATION_OWNER')
    and object_name = pi_obj_name
    and rownum = 1;
    retval := SQL%FOUND;
    return retval;
  exception
    when no_data_found then
      return FALSE;
  end;

  -----------------------------------------------------------------------------
--
Function test_theme_for_update( p_Theme in NM_THEMES_ALL.NTH_THEME_ID%TYPE ) Return Boolean is
  retval   Boolean := FALSE;
  l_normal integer := 0;
begin
  if p_Theme is null then
    return TRUE;
  end if;
--  
  select 1  into l_normal
  from dual where exists 
     ( select 1
       from ( select nth_theme_id
              from nm_themes_all 
              where nth_base_table_theme in (
                 select nvl(nth_base_table_theme, nth_theme_id )
                 from nm_themes_all where nth_theme_id = p_Theme )), 
                      nm_theme_roles, 
                      hig_user_roles
                 where nthr_theme_id = nth_theme_id
                 and nthr_role = hur_role
                 and hur_username = SYS_CONTEXT ('NM3_SECURITY_CTX', 'USERNAME')
                 and nthr_mode = 'NORMAL' ) ;
--
  if l_normal = 1 then
    retval := TRUE;
  else
    retval := FALSE;
  end if;
  return retval;
exception
  when no_data_found then
    Return FALSE;
end;  
--
-----------------------------------------------------------------------------
--
Function User_Is_Unrestricted Return Boolean
Is
Begin
 Return Sys_Context('NM3CORE','UNRESTRICTED_INVENTORY') = 'TRUE';
End User_Is_Unrestricted;
--
-----------------------------------------------------------------------------
--
Function Get_Asset_Modules Return Ptr_Vc_Array
Is
Begin
 Return G_Asset_Modules;
End Get_Asset_Modules;
--
-----------------------------------------------------------------------------
--
Procedure  Create_Theme_Functions (
                                  p_Theme   In  Number,
                                  p_Pa      In  Ptr_Vc_Array,
                                  p_Exclude In  Number
                                  )
Is
  Cursor C1 ( 
            c_Theme In Number,
            c_Pa    In Ptr_Vc_Array,
            c_Excl  In Number
            )
  Is
    Select  f.Ptr_Value Module,
            hm.Hmo_Title
    From    Hig_Modules hm,
            Table ( c_Pa.Pa ) f
    Where   f.Ptr_Value         =   hm.Hmo_Module
    And     Nvl(C_Excl, -999)   !=  Decode( c_Excl, Null, 0, f.Ptr_Id );

Begin
  --  failure of 9i to perform insert in an efficient way using ptrs - needs simple loop

  For Ntf In C1( p_Theme, p_Pa, p_Exclude )
  Loop
    Insert Into Nm_Theme_Functions_All
    (
    Ntf_Nth_Theme_Id,
    Ntf_Hmo_Module,
    Ntf_Parameter,
    Ntf_Menu_Option,
    Ntf_Seen_In_Gis
    )
    Values
    (
    p_Theme,
    Ntf.Module,
    'GIS_SESSION_ID',
    Ntf.Hmo_Title,
    Decode( Ntf.Module, 'NM0572', 'N', 'Y' )
    );
  End Loop;

End Create_Theme_Functions;
--
-----------------------------------------------------------------------------
--
Function Get_Version Return Varchar2
Is
Begin
  Return G_Sccsid;
End Get_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Body_Version Return Varchar2
Is
Begin
  Return G_Body_Sccsid;
End Get_Body_Version;
--
-----------------------------------------------------------------------------
--
Function Get_Base_Themes  (
                          p_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                          ) Return Nm_Theme_Array
Is
  Retval Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;
         
Begin
  Select   Nm_Theme_Entry( nbt.Nbth_Base_Theme )
  Bulk Collect 
  Into    Retval.Nta_Theme_Array      
  From    Nm_Base_Themes  nbt
  Where   nbt.Nbth_Theme_Id = p_Theme_Id;
               
  Return Retval;
     
End Get_Base_Themes;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Procedure Process_View_DDL  (
                            p_View_Rec    In    t_View_Rec  
                            )
Is
Begin  
  Nm_Debug.Debug('Nm3Sdm.Process_View_DDL - Called');
    
  Nm_Debug.Debug('Processing :' || p_View_Rec.View_Name);      
  Nm_Debug.Debug(Substr('DDL:'  || p_View_Rec.View_Text,1,4000) );
    
  Begin

    Nm3Ddl.Create_Object_And_Syns( p_View_Rec.View_Name, p_View_Rec.View_Text );
        
    Nm_Debug.Debug('View Comments:' || p_View_Rec.View_Comments);

    Execute Immediate (p_View_Rec.View_Comments);
       
  Exception
      When Others Then
        Nm_Debug.Debug('EXCEPTION - When Others:' || Sqlcode || ':' || Sqlerrm );
        Raise_Application_Error (-20001,'Unable to create view ' || p_View_Rec.View_Name || ':' || Chr(10) || p_View_Rec.View_Text || Chr(10) || Sqlcode || ':' || Sqlerrm);
  End;
  Nm_Debug.Debug('Nm3Sdm.Process_View_DDL - Finished');
End Process_View_DDL;
--
------------------------------------------------------------------------------
--
Function Build_Nat_Sdo_Join_View Return User_Views.View_Name%Type
Is

  l_View_Tab    t_View_Tab;
  View_Creation_Error   Exception;
  Pragma Exception_Init(View_Creation_Error,-20001);
Begin
  Nm_Debug.Debug('Nm3Sdm.Build_Nat_Sdo_Join_View - Called');
    
  Select        View_Name,
                View_Text,
                View_Comments 
  Bulk Collect    
  Into          l_View_Tab
  From          V_Nm_Rebuild_All_Nat_Sdo_Join;
    
  For x In  1 .. l_View_Tab.Count
  Loop
    Begin
      Process_View_DDL (p_View_Rec=> l_View_Tab(x));
    Exception
      When View_Creation_Error Then
        Null;
    End;                                             
  End Loop;
       
  Nm_Debug.Debug('Nm3Sdm.Build_Nat_Sdo_Join_View - Finished');
    
  --Only return a view name if we only processed one view.
  Return ((Case When l_View_Tab.Count = 1 Then l_View_Tab(1).View_Name Else Null End) );
    
End Build_Nat_Sdo_Join_View;
--
------------------------------------------------------------------------------
--
Function Create_Nat_Sdo_Join_View (
                                  p_Feature_Table_Name  In    Varchar2
                                  ) Return User_Views.View_Name%Type
Is
  l_View_Name   User_Views.View_Name%Type; 
Begin
  Nm_Debug.Debug('Nm3Sdm.Create_Nat_Sdo_Join_View - Called');
  Nm_Debug.Debug('Parameter - p_Feature_Table_Name:' || p_Feature_Table_Name);

  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',p_Feature_Table_Name );
   
  l_View_Name:=Build_Nat_Sdo_Join_View;

  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',Null );
            
  Nm_Debug.Debug('Nm3Sdm.Create_Nat_Sdo_Join_View - Finished - Returning:');
    
  Return l_View_Name;
End Create_Nat_Sdo_Join_View;
--
------------------------------------------------------------------------------
--
Procedure Rebuild_All_NAT_Sdo_Join_View
Is
  l_View_Name   User_Views.View_Name%Type;    
Begin
  Nm_Debug.Debug('nm3sdm.Rebuild_All_NAT_Sdo_Join_View - Called');
    
  --This limits the rows returned by the V_Nm_Rebuild_All_Nat_Sdo_Join view, which is used by Build_Nat_Sdo_Join_View.
  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB','NM_%_SDO');
    
  l_View_Name:=Build_Nat_Sdo_Join_View;
    
  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',Null );

  Nm_Debug.Debug('nm3sdm.Rebuild_All_NAT_Sdo_Join_View - Finished');              
End Rebuild_All_NAT_Sdo_Join_View;  
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Build_Nlt_Sdo_Join_View Return User_Views.View_Name%Type
Is

  l_View_Tab    t_View_Tab;
  View_Creation_Error   Exception;
  Pragma Exception_Init(View_Creation_Error,-20001);
Begin
  Nm_Debug.Debug('Nm3Sdm.Build_Nlt_Sdo_Join_View - Called');
    
  Select        View_Name,
                View_Text,
                View_Comments 
  Bulk Collect    
  Into          l_View_Tab
  From          V_Nm_Rebuild_All_Nlt_Sdo_Join;
    
  For x In  1 .. l_View_Tab.Count
  Loop
    Begin
      Process_View_DDL (p_View_Rec=> l_View_Tab(x));
    Exception
      When View_Creation_Error Then
        Null;
    End;                                            
  End Loop;
       
  Nm_Debug.Debug('Nm3Sdm.Build_Nlt_Sdo_Join_View - Finished');
    
  --Only return a view name if we only processed one view.
  Return ((Case When l_View_Tab.Count = 1 Then l_View_Tab(1).View_Name Else Null End) );
    
End Build_Nlt_Sdo_Join_View;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Create_Nlt_Sdo_Join_View (
                                  p_Feature_Table_Name         In    Varchar2
                                  ) Return User_Views.View_Name%Type
Is

  l_View_Name   User_Views.View_Name%Type;
    
Begin
  Nm_Debug.Debug('Nm3Sdm.Create_Nlt_Sdo_Join_View - Called');
  Nm_Debug.Debug('Parameter - p_Feature_Table_Name:'              || p_Feature_Table_Name);

  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',p_Feature_Table_Name );
   
  l_View_Name:=Build_Nlt_Sdo_Join_View;

  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',Null );
            
  Nm_Debug.Debug('Nm3Sdm.Create_Nlt_Sdo_Join_View - Finished - Returning:');
    
  Return l_View_Name;
      
 End Create_Nlt_Sdo_Join_View;
--
------------------------------------------------------------------------------
--
Procedure Rebuild_All_NLT_Sdo_Join_Views
Is
  l_View_Name   User_Views.View_Name%Type;    
Begin
  Nm_Debug.Debug('nm3sdm.Rebuild_All_NLT_Sdo_Join_Views - Called');
    
  --This limits the rows returned by the V_Nm_Rebuild_All_Nlt_Sdo_Join view, which is used by Build_nlt_Sdo_Join_View.
  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB','NM_%_SDO');
    
  l_View_Name:=Build_Nlt_Sdo_Join_View;
    
  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',Null );

  Nm_Debug.Debug('nm3sdm.Rebuild_All_NLT_Sdo_Join_Views - Finished');
End Rebuild_All_NLT_Sdo_Join_Views;  
--
-----------------------------------------------------------------------------
--
Function Get_Theme_Nt (
                      p_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                      ) Return Nm_Linear_Types.Nlt_Nt_Type%Type
Is

  Retval   Nm_Linear_Types.Nlt_Nt_Type%Type;
    
Begin
  Begin
    Select  nlt.Nlt_Nt_Type
    Into    Retval
    From    Nm_Themes_All     nta,
            Nm_Nw_Themes      nnt,
            Nm_Linear_Types   nlt
    Where   nlt.Nlt_Id              =   Nnth_Nlt_Id
    And     nnt.Nnth_Nth_Theme_Id   =   nta.Nth_Theme_Id
    And     nta.Nth_Theme_Id        =   p_Theme_Id
    And     nta.Nth_Theme_Type      =   'SDO'
    And     Rownum                  =   1;
  Exception
    When No_Data_Found Then
      Hig.Raise_Ner (
                    pi_Appl         => Nm3Type.C_Hig,
                    pi_Id           => 192,
                    pi_Sqlcode      => -20001
                    );
  End;

  Return Retval;
End Get_Theme_Nt;
--
-----------------------------------------------------------------------------
--
Function Get_Node_Table (
                        p_Node_Type In Nm_Node_Types.Nnt_Type%Type
                        ) Return Varchar2
Is
Begin
  Return 'V_NM_NO_' || p_Node_Type || '_SDO';
End Get_Node_Table;
--
---------------------------------------------------------------------------------------------------
--
Procedure Register_Npl_Theme
Is
  l_Rec_Nth Nm_Themes_All%Rowtype;
  l_Rec_Ntg Nm_Theme_Gtypes%Rowtype;
Begin
  l_Rec_Nth.Nth_Theme_Id             := Nm3Seq.Next_Nth_Theme_Id_Seq;
  l_Rec_Nth.Nth_Theme_Name           := 'POINT_LOCATIONS';
  l_Rec_Nth.Nth_Table_Name           := 'NM_POINT_LOCATIONS';
  l_Rec_Nth.Nth_Pk_Column            := 'NPL_ID';
  l_Rec_Nth.Nth_Label_Column         := 'NPL_ID';
  l_Rec_Nth.Nth_Feature_Table        := 'NM_POINT_LOCATIONS';
  l_Rec_Nth.Nth_Feature_Shape_Column := 'NPL_LOCATION';
  l_Rec_Nth.Nth_Feature_Pk_Column    := 'NPL_ID';
  l_Rec_Nth.Nth_Use_History          := 'N';
  l_Rec_Nth.Nth_Hpr_Product          := 'NET';
  l_Rec_Nth.Nth_Theme_Type           := 'SDO';
  l_Rec_Nth.Nth_Location_Updatable   := 'N';
  l_Rec_Nth.Nth_Dependency           := 'I';
  l_Rec_Nth.Nth_Storage              := 'S';
  l_Rec_Nth.Nth_Update_On_Edit       := 'N';
  l_Rec_Nth.Nth_Use_History          := 'N';
  l_Rec_Nth.Nth_Snap_To_Theme        := 'N';
  l_Rec_Nth.Nth_Lref_Mandatory       := 'N';
  l_Rec_Nth.Nth_Tolerance            := 10;
  l_Rec_Nth.Nth_Tol_Units            := 1;
  l_Rec_Nth.Nth_Dynamic_Theme        := 'N';
    
  Nm3Ins.Ins_Nth(l_Rec_Nth);
  --
  l_Rec_Ntg.Ntg_Theme_Id  :=  l_Rec_Nth.Nth_Theme_Id;
  l_Rec_Ntg.Ntg_Seq_No    :=  1;
  l_Rec_Ntg.Ntg_Xml_Url   :=  Null;
  l_Rec_Ntg.Ntg_Gtype     :=  '2001';
    
  Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);
    
  --
  If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then
    Execute Immediate (   ' begin  '
                      || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( l_Rec_Nth.Nth_Theme_Id)||')'
                      || '; end;'
                      );
  End If;
End Register_Npl_Theme;
--
----------------------------------------------------------------------------------------
--
-- The registration of a node theme depends on the existence of the nm_point_locations registry entry
-- If it is not present, then register this first.
-- RAC December 2005
Function Register_Node_Theme  (
                              p_Node_Type     In   Varchar2,
                              p_Table_Name    In   Varchar2,
                              p_Column_Name   In   Varchar2
                              ) Return Number
Is
  Retval      Number;
  l_Nth       Nm_Themes_All%Rowtype;
  l_Rec_Ntg   Nm_Theme_Gtypes%Rowtype;
Begin
  Retval := Higgis.Next_Theme_Id;

  l_Nth.Nth_Base_Table_Theme := Get_Theme_From_Feature_Table ('NM_POINT_LOCATIONS'
                                                            , 'NM_POINT_LOCATIONS' );
  If l_Nth.Nth_Base_Table_Theme Is Null Then
    --
    Register_Npl_Theme;
  End If;

  l_Nth.Nth_Theme_Id              := Retval;
  l_Nth.Nth_Theme_Name            := 'NODE_' || p_Node_Type;
  l_Nth.Nth_Table_Name            := p_Table_Name;
  l_Nth.Nth_Where                 := Null;
  l_Nth.Nth_Pk_Column             := 'NO_NODE_ID';
  l_Nth.Nth_Label_Column          := 'NO_NODE_NAME';
  l_Nth.Nth_Rse_Table_Name        := 'NM_ELEMENTS';
  l_Nth.Nth_Rse_Fk_Column         := Null;
  l_Nth.Nth_St_Chain_Column       := Null;
  l_Nth.Nth_End_Chain_Column      := Null;
  l_Nth.Nth_Offset_Field          := Null;
  l_Nth.Nth_Feature_Table         := 'V_NM_NO_'||p_Node_Type||'_SDO';
  l_Nth.Nth_Feature_Pk_Column     := 'NPL_ID';
  l_Nth.Nth_Feature_Fk_Column     := Null;
  l_Nth.Nth_Xsp_Column            := Null;
  l_Nth.Nth_Feature_Shape_Column  := 'GEOLOC';
  l_Nth.Nth_Hpr_Product           := 'NET';
  l_Nth.Nth_Location_Updatable    := 'N';
  l_Nth.Nth_Theme_Type            := 'SDO';
  l_Nth.Nth_Dependency            := 'I';
  l_Nth.Nth_Storage               := 'S';
  l_Nth.Nth_Update_On_Edit        := 'N';
  l_Nth.Nth_Use_History           := 'N';
  l_Nth.Nth_Lref_Mandatory        := 'N';
  l_Nth.Nth_Tolerance             := 10;
  l_Nth.Nth_Tol_Units             := 1;

  Nm3Ins.Ins_Nth (L_Nth);
  --
  --  Build theme gtype rowtype
  l_Rec_Ntg.Ntg_Theme_Id  := L_Nth.Nth_Theme_Id;
  l_Rec_Ntg.Ntg_Seq_No    := 1;
  l_Rec_Ntg.Ntg_Xml_Url   := Null;
  l_Rec_Ntg.Ntg_Gtype     := '2001';

  Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

  Commit;

  If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then
      
    Execute Immediate (   ' begin  '
                      || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( L_Nth.Nth_Theme_Id )||')'
                      || '; end;'
                      );
  --  place exception into dynamic sql ananymous block. This is dynamic sql to avoid compilation probs
  End If;

  Return Retval;

Exception
  When No_Data_Found  Then
    Hig.Raise_Ner (
                  pi_Appl         => Nm3Type.C_Hig,
                  pi_Id           => 193,
                  pi_Sqlcode      => -20003
                  );
End Register_Node_Theme;
--
-----------------------------------------------------------------------------
--
Function Create_Node_Metadata (
                              p_Node_Type In Nm_Node_Types.Nnt_Type%Type
                              ) Return Number
Is
  Cur_String    Varchar2 (4000);
  l_Node_View   Varchar2 (30);
  Retval        Number;
Begin
  -- AE check to make sure user is unrestricted
  If Not User_Is_Unrestricted Then
    Raise E_Not_Unrestricted;
  End If;
      
  --create node view based on points - this assumes that the points are either
  --held as a geo-enabled column this work on 8i by cloning the point-locations table
  --
  l_Node_View := Get_Node_Table (p_Node_Type);
  Cur_String  := 'create or replace view '
               || l_Node_View
               || ' as select /*+INDEX( NM_NODES_ALL,NN_NP_FK_IND)*/ p.npl_id, n.*, p.npl_location geoloc '
               || 'from nm_nodes n, nm_point_locations p '
               || 'where n.NO_NP_ID = p.NPL_ID '
               || 'and   n.no_node_type = '
               || ''''
               || p_Node_Type
               || '''';
     
  Nm3Ddl.Create_Object_And_Syns( l_Node_View, Cur_String );

  Insert Into Mdsys.Sdo_Geom_Metadata_Table
  (
  Sdo_Table_Name,
  Sdo_Column_Name,
  Sdo_Diminfo,
  Sdo_Srid,
  Sdo_Owner
  )
  Select  l_Node_View,
          'GEOLOC',
          Sdo_Diminfo,
          Sdo_Srid,
          Sys_Context('NM3CORE','APPLICATION_OWNER')
  From    Mdsys.Sdo_Geom_Metadata_Table
  Where   Sdo_Table_Name  =   'NM_POINT_LOCATIONS'
  And     Sdo_Column_Name =   'NPL_LOCATION'
  And     Sdo_Owner       =   Sys_Context('NM3CORE','APPLICATION_OWNER');

  Retval := Register_Node_Theme (p_Node_Type, l_Node_View, 'GEOLOC');
    
  Return Retval;

End Create_Node_Metadata;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Get_Nlt_Spatial_Table  (
                                p_Nlt In Nm_Linear_Types%Rowtype
                                ) Return Varchar2
Is
  Retval   Varchar2 (30);
Begin
  Retval := 'NM_NLT_' || p_Nlt.Nlt_Nt_Type;

  If p_Nlt.Nlt_Gty_Type Is Not Null
  Then
     Retval := Retval || '_' || p_Nlt.Nlt_Gty_Type;
  End If;

  Retval := Retval || '_SDO';
    
  Return Retval;
End Get_Nlt_Spatial_Table;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Nlt_Base_Themes  (
                              p_Nlt_Id In Nm_Linear_Types.Nlt_Id%Type
                              ) Return Nm_Theme_Array
Is
  Retval Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;

Begin
  Select  Nm_Theme_Entry(Nnth_Nth_Theme_Id)
  Bulk Collect
  Into    Retval.Nta_Theme_Array    
  From    Nm_Nw_Themes      nnt,
          Nm_Linear_Types   nlt1,
          Nm_Nt_Groupings   nng,
          Nm_Linear_Types   nlt2,
          Nm_Themes_All     nta
  Where   nlt2.Nlt_Id               =   p_Nlt_Id
  And     nlt1.Nlt_Id               =   nnt.Nnth_Nlt_Id
  And     nng.Nng_Group_Type        =   nlt2.Nlt_Gty_Type
  And     nng.Nng_Nt_Type           =   nlt1.Nlt_Nt_Type
  And     nta.Nth_Theme_Id          =   nnt.Nnth_Nth_Theme_Id
  And     nta.Nth_Base_Table_Theme  Is  Null
  And     nlt1.Nlt_G_I_D            =   'D';

  If Retval.Nta_Theme_Array.Last Is Null  Then
    Hig.Raise_Ner (
                  pi_Appl               =>  Nm3Type.C_Hig,
                  pi_Id                 =>  267,
                  pi_Sqlcode            =>  -20003,
                  pi_Supplementary_Info =>  To_Char( P_Nlt_Id )
                  );
  End If;
    
  Return Retval;
    
End Get_Nlt_Base_Themes;
--
-----------------------------------------------------------------------------
--
Procedure Create_Spatial_Table  (
                                p_Table               In   Varchar2,
                                p_Mp_Flag             In   Boolean Default False,
                                p_Start_Date_Column   In   Varchar2 Default Null,
                                p_End_Date_Column     In   Varchar2 Default Null
                                )
Is
  Cur_String            Varchar2 (2000);
  Con_String            Varchar2 (2000);
  Uk_String             Varchar2 (2000);
  b_Use_History         Constant Boolean :=p_Start_Date_Column Is Not Null And p_End_Date_Column Is Not Null;
Begin
  --

  If p_Mp_Flag Then
    If Nm3Sdo.Use_Surrogate_Key = 'N' Then
      If b_Use_History  Then
        Cur_String := 'create table '
                    || p_Table
                    || ' ( ne_id number(38) not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   '
                    || p_Start_Date_Column
                    || ' date, '
                    || p_End_Date_Column
                    || ' date, '
                    || 'date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
        Con_String := 'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id, '
                    || p_Start_Date_Column
                    || ' start_date )';
      Else
        Cur_String := 'create table '
                    || p_Table
                    || ' ( ne_id number(38) not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
        Con_String := 'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id )';
      End If;

      Execute Immediate Cur_String;

      Execute Immediate Con_String;
    Else   -- surrogate key = Y
      If b_Use_History Then
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( objectid number(38) not null, '
                    || '   ne_id number(38) not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   '
                    || p_Start_Date_Column
                    || ' date, '
                    || '   '
                    || p_End_Date_Column
                    || ' date, date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
        Con_String :=  'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id, '
                    || p_Start_Date_Column
                    || ' )';
      Else  -- no history
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( objectid number(38) not null, '
                    || '   ne_id number(38) not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
        Con_String :=  'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id )';
      End If; -- history

      Uk_String :=  'alter table '
                 || p_Table
                 || ' ADD ( CONSTRAINT '
                 || p_Table
                 || '_UK UNIQUE '
                 || ' (objectid))';

      Execute Immediate Cur_String;

      Execute Immediate Con_String;
      
      Execute Immediate Uk_String;

    End If;
  Else --single part - assumed multi-row
    If Nm3Sdo.Use_Surrogate_Key = 'N' Then
      If B_Use_History  Then
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( ne_id number(38) not null, '
                    || '   ne_id_of number(9) not null, '
                    || '   nm_begin_mp number not null, '
                    || '   nm_end_mp number not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   '
                    || p_Start_Date_Column
                    || ' date, '
                    || p_End_Date_Column
                    || ' date, date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
      Else -- no history
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( ne_id number(38) not null, '
                    || '   ne_id_of number(9) not null, '
                    || '   nm_begin_mp number not null, '
                    || '   nm_end_mp number not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
      End If; --history

     Execute Immediate Cur_String;
       
    Else -- surrogate key = Y
      If b_Use_History Then
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( objectid number(38) not null, '
                    || '   ne_id number(38) not null, '
                    || '   ne_id_of number(9) not null, '
                    || '   nm_begin_mp number not null, '
                    || '   nm_end_mp number not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   '
                    || p_Start_Date_Column
                    || ' date, '
                    || p_End_Date_Column
                    || ' date, date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
      Else --no history
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( objectid number(38) not null, '
                    || '   ne_id number(38) not null, '
                    || '   ne_id_of number(9) not null, '
                    || '   nm_begin_mp number not null, '
                    || '   nm_end_mp number not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
      End If; --history

      Execute Immediate Cur_String;

    End If; -- surrogate key

    If b_Use_History Then
      Cur_String := 'alter table '
                 || p_Table
                 || ' ADD CONSTRAINT '
                 || p_Table
                 || '_PK PRIMARY KEY '
                 || ' ( ne_id, ne_id_of, nm_begin_mp, '
                 || p_Start_Date_Column
                 || ' )';
    Else
      Cur_String := 'alter table '
                 || p_Table
                 || ' ADD CONSTRAINT '
                 || p_Table
                 || '_PK PRIMARY KEY '
                 || ' ( ne_id, ne_id_of, nm_begin_mp )';
    End If;

    Execute Immediate Cur_String;

    If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
      Cur_String := 'alter table '
                 || p_Table
                 || ' ADD ( CONSTRAINT '
                 || p_Table
                 || '_UK UNIQUE '
                 || ' ( objectid ))';

      Execute Immediate Cur_String;

     End If; -- surrogate key

     Cur_String := 'create index '|| p_Table
                || '_NW_IDX'|| ' on '|| p_Table|| ' ( ne_id_of, nm_begin_mp )';

     Execute Immediate Cur_String;

  End If; --single-part or multi-part
  
  nm3ddl.create_synonym_for_object(p_object_name => p_Table);

End Create_Spatial_Table;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Procedure Create_Spatial_Date_View  (
                                    p_Table            In   Varchar2,
                                    p_Start_Date_Col   In   Varchar2 Default Null,
                                    p_End_Date_Col     In   Varchar2 Default Null
                                    )
Is
  Cur_String         Varchar2 (2000);
  l_Start_Date_Col   Varchar2 (30)   := 'start_date';
  l_End_Date_Col     Varchar2 (30)   := 'end_date';
Begin
  --
  If p_Start_Date_Col Is Not Null Then
    l_Start_Date_Col := p_Start_Date_Col;
  End If;

  If p_End_Date_Col Is Not Null Then
    l_End_Date_Col := p_End_Date_Col;
  End If;

  --
  Cur_String := 'create or replace force view v_'
             || p_Table
             || ' as select * from '
             || p_Table
             || ' where  '
             || l_Start_Date_Col
             || ' <= Sys_Context(''NM3CORE'',''EFFECTIVE_DATE'') '
             || ' and  NVL('
             || l_End_Date_Col
             || ',TO_DATE(''99991231'',''YYYYMMDD'')) > Sys_Context(''NM3CORE'',''EFFECTIVE_DATE'') ';
  --
  -- AE 23-SEP-2008
  -- We will now use views instead of synonyms to provide subordinate user access
  -- to spatial objects
  -- CWS 0108742 Change back to using synonyms
  Nm3Ddl.Create_Object_And_Syns( 'V_'||P_Table, Cur_String );

End Create_Spatial_Date_View;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Procedure Create_Nlt_Spatial_Idx  (
                                  p_Nlt     In   Nm_Linear_Types%Rowtype,
                                  p_Table   In   Varchar2
                                  )
Is
  --bug in oracle 8 - spatial index name can only be 18 chars
  --best kept to a quadtree in Oracle 8, Rtree in 9i
  Cur_String   Varchar2 (2000);
Begin
  Cur_String :=
                'create index NLT_'
             || p_Nlt.Nlt_Nt_Type
             || '_'
             || p_Nlt.Nlt_Gty_Type
             || '_spidx on '
             || p_Table
             || ' ( geoloc ) indextype is mdsys.spatial_index';
               
  Execute Immediate Cur_String;
End Create_Nlt_Spatial_Idx;
--
-----------------------------------------------------------------------------
--
--temp function until the DB design is finished and the gets can be
--generated
  
Function Get_Nlt  (
                  pi_Nlt_Id In Nm_Linear_Types.Nlt_Id%Type
                  ) Return Nm_Linear_Types%Rowtype
Is
  Retval   Nm_Linear_Types%Rowtype;
Begin
  Begin
    Select  *
    Into    Retval
    From    Nm_Linear_Types   nlt
    Where   nlt.Nlt_Id = pi_Nlt_Id;
  Exception
   When No_Data_Found Then
     Null;
  End;

 Return Retval;
End Get_Nlt; 
--
---------------------------------------------------------------------------------------------------
--
Procedure Create_Base_Themes  (
                              p_Theme_Id    In Number,
                              p_Base        In Nm_Theme_Array
                              )
Is
Begin
  If P_Base.Nta_Theme_Array(1).Nthe_Id Is Null Then
    Null;
  Else
    For i In 1..p_Base.Nta_Theme_Array.Last
    Loop

      Insert Into Nm_Base_Themes
      (
      Nbth_Theme_Id,
      Nbth_Base_Theme
      )
      Values
      (
      p_Theme_Id,
      p_Base.Nta_Theme_Array(i).Nthe_Id
      );
        
    End Loop;
  End If;
End Create_Base_Themes;
--
---------------------------------------------------------------------------------------------------
--
Function Register_Lrm_Theme (
                            p_Nlt_Id           In   Number,
                            p_Base             In   Nm_Theme_Array,
                            p_Table_Name       In   Varchar2,
                            p_Column_Name      In   Varchar2,
                            p_Name             In   Varchar2 Default Null,
                            p_View_Flag        In   Varchar2 Default 'N',
                            p_Base_Table_Nth   In   Nm_Themes_All.Nth_Theme_Id%Type Default Null
                            ) Return Number
Is
  Retval        Number;
  l_D_Or_S      Varchar2 (1);
  l_View_Name   Varchar2 (30);
  l_Pk_Col      Varchar2 (30)                       := 'NE_ID';
  l_Nth         Nm_Themes_All%Rowtype;
  l_Nlt         Nm_Linear_Types%Rowtype;
  l_Name        Nm_Themes_All.Nth_Theme_Name%Type   := Upper (p_Name);
  l_Rec_Nnth    Nm_Nw_Themes%Rowtype;
  l_Rec_Ntg     Nm_Theme_Gtypes%Rowtype;
  l_Mp_Gtype    Number := To_Number(Nvl(Hig.Get_Sysopt('SDOMPGTYPE'),'3302'));

Begin
  l_Nlt := Get_Nlt (p_Nlt_Id);
  g_Units := Nm3Net.Get_Nt_Units( l_Nlt.Nlt_Nt_Type);

  If g_Units = 1 Then
    g_Unit_Conv := 1;
  Else
    g_Unit_Conv := Nm3Get.Get_Uc ( g_Units, 1).Uc_Conversion_Factor;
  End If;

  If l_Name Is Null Then
     l_Name := Upper (Substr (l_Nlt.Nlt_Descr, 1, 30));
  End If;

  If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
    l_Pk_Col := 'OBJECTID';
    --  to make sm work we need to use NE_ID
    l_Pk_Col := 'NE_ID';
  End If;

  Retval                := Higgis.Next_Theme_Id;
  l_Nth.Nth_Theme_Id    := Retval;
  l_Nth.Nth_Theme_Name  := l_Name;
  l_Nth.Nth_Table_Name  := p_Table_Name;
  l_Nth.Nth_Where       := Null;
  l_Nth.Nth_Pk_Column   := 'NE_ID';
  --
  -- Task ID 0107889 - Set Label Column to NE_ID for Group layer base table themes
  -- 05/10/09 AE Further restrict on the non DT theme 
  --
  If      p_Base_Table_Nth      Is        Null
      Or  l_Nth.Nth_Theme_Name  Not Like  '%DT' Then
    l_Nth.Nth_Label_Column := 'NE_ID';
  Else
    l_Nth.Nth_Label_Column := 'NE_UNIQUE';
  End If;
  --
  l_Nth.Nth_Rse_Table_Name        := 'NM_ELEMENTS';
  l_Nth.Nth_Rse_Fk_Column         := 'NE_ID';
  l_Nth.Nth_St_Chain_Column       := Null;
  l_Nth.Nth_End_Chain_Column      := Null;
  l_Nth.Nth_X_Column              := Null;
  l_Nth.Nth_Y_Column              := Null;
  l_Nth.Nth_Offset_Field          := Null;
  l_Nth.Nth_Feature_Table         := p_Table_Name;
  l_Nth.Nth_Feature_Pk_Column     := l_Pk_Col;
  l_Nth.Nth_Feature_Fk_Column     := 'NE_ID';
  l_Nth.Nth_Xsp_Column            := Null;
  l_Nth.Nth_Feature_Shape_Column  := 'GEOLOC';
  l_Nth.Nth_Hpr_Product           := 'NET';
  l_Nth.Nth_Location_Updatable    := 'N';
  l_Nth.Nth_Theme_Type            := 'SDO';
  l_Nth.Nth_Dependency            := 'D';
  l_Nth.Nth_Storage               := 'S';
  l_Nth.Nth_Update_On_Edit        := 'D';
  l_Nth.Nth_Use_History           := 'Y';
  l_Nth.Nth_Start_Date_Column     := 'START_DATE';
  l_Nth.Nth_End_Date_Column       := 'END_DATE';
  l_Nth.Nth_Base_Table_Theme      := p_Base_Table_Nth;
  l_Nth.Nth_Sequence_Name         := 'NTH_' || Nvl(p_Base_Table_Nth,Retval) || '_SEQ';
  l_Nth.Nth_Snap_To_Theme         := 'N';
  l_Nth.Nth_Lref_Mandatory        := 'N';
  l_Nth.Nth_Tolerance             := 10;
  l_Nth.Nth_Tol_Units             := 1;

  Nm3Ins.Ins_Nth (l_Nth);

  l_Rec_Nnth.Nnth_Nlt_Id        := p_Nlt_Id;
  l_Rec_Nnth.Nnth_Nth_Theme_Id  := Retval;

  Nm3Ins.Ins_Nnth (l_Rec_Nnth);
  --
  --  Build theme gtype rowtype

  l_Rec_Ntg.Ntg_Theme_Id := Retval;
  l_Rec_Ntg.Ntg_Seq_No   := 1;
  l_Rec_Ntg.Ntg_Xml_Url  := Null;
  l_Rec_Ntg.Ntg_Gtype    := l_Mp_Gtype;

  Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

  --  Build the base themes

  Create_Base_Themes( Retval, p_Base );

    --
  If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then
    Execute Immediate (   ' begin  '
                      || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( L_Nth.Nth_Theme_Id )||');'
                      || ' end;'
                     );
  End If;

  If P_View_Flag = 'Y'  Then
    Declare
      l_Role   Varchar2 (30);
    Begin
      l_Role := Hig.Get_Sysopt ('SDONETROLE');

      If l_Role Is Not Null Then
        Insert Into Nm_Theme_Roles
        (
        Nthr_Theme_Id,
        Nthr_Role,
        Nthr_Mode
        )
        Values
        (
        Retval,
        l_Role,
        'NORMAL'
        );
      End If;
    End;
  End If;
  --
  -- create the theme functions - exclude gog
  --
  Create_Theme_Functions( p_Theme => l_Nth.Nth_Theme_Id, p_Pa => g_Network_Modules, p_Exclude => 2 );

  Return Retval;

End Register_Lrm_Theme;
--
-----------------------------------------------------------------------------
--
Procedure Make_Nt_Spatial_Layer (
                                pi_Nlt_Id   In   Nm_Linear_Types.Nlt_Id%Type,
                                p_Gen_Pt    In   Number Default 0,
                                p_Gen_Tol   In   Number Default 0,
                                p_Job_Id    In   Number Default Null
                                )
Is
  /*
  ** not expected to be used for datum layers
  */
  l_Nlt                Nm_Linear_Types%Rowtype     := Nm3Get.Get_Nlt (Pi_Nlt_Id);
  l_Nlt_Seq            Varchar2(30);
  l_Base_Themes        Nm_Theme_Array;
  l_Theme_Id           Nm_Themes_All.Nth_Theme_Id%Type;
  l_Theme_Name         Nm_Themes_All.Nth_Theme_Name%Type;
  l_Base_Table_Theme   Nm_Themes_All.Nth_Theme_Id%Type;
  l_Tab                Varchar2 (30);
  l_View               Varchar2 (30);
  l_Usgm               User_Sdo_Geom_Metadata%Rowtype;
  l_Diminfo            Mdsys.Sdo_Dim_Array;
  l_Srid               Number;
  --
Begin
  -- AE check to make sure user is unrestricted
  If Not User_Is_Unrestricted Then
    Raise E_Not_Unrestricted;
  End If;
  --
  -----------------------------------------------------------------------
  -- Table name is the is derived based on nt/gty
  -----------------------------------------------------------------------

  l_Tab := Get_Nlt_Spatial_Table (l_Nlt);

  -----------------------------------------------------------------------
  -- Will always be a group according to Linear types..
  -----------------------------------------------------------------------
  If l_Nlt.Nlt_G_I_D = 'G'  Then
    l_Base_Themes := Get_Nlt_Base_Themes( pi_Nlt_Id );
  End If;

  If L_Base_Themes.Nta_Theme_Array(1).Nthe_Id Is Null Then
    Hig.Raise_Ner (
                  pi_Appl         => Nm3Type.C_Hig,
                  pi_Id           => 266,
                  pi_Sqlcode      => -20001
                  );
  End If;

  -----------------------------------------------------------------------
  -- Create the nt view if not already there
  -----------------------------------------------------------------------
    
  If Not Nm3Ddl.Does_Object_Exist (l_View, 'VIEW') Then
    Nm3Inv_View.Create_View_For_Nt_Type (l_Nlt.Nlt_Nt_Type);
  End If;

  -----------------------------------------------------------------------
  -- Create spatial data in table + create date tracked view
  -----------------------------------------------------------------------
  Create_Spatial_Table (l_Tab, True, 'START_DATE', 'END_DATE');
    
  Create_Spatial_Date_View (l_Tab);
    
  -----------------------------------------------------------------------
  -- Clone SDO metadata from it's base layer
  -----------------------------------------------------------------------
    
  Nm3Sdo.Set_Diminfo_And_Srid( l_Base_Themes, l_Diminfo, l_Srid );

  l_Diminfo(3).Sdo_Tolerance := Nm3Unit.Get_Tol_From_Unit_Mask(Nm3Net.Get_Nt_Units(l_Nlt.Nlt_Nt_Type));
  l_Usgm.Table_Name  := l_Tab;
  l_Usgm.Column_Name := 'GEOLOC';
  l_Usgm.Diminfo     := l_Diminfo;
  l_Usgm.Srid        := l_Srid;

  Nm3Sdo.Ins_Usgm ( l_Usgm );

  l_Usgm.Table_Name := 'V_'|| l_Tab;

  Nm3Sdo.Ins_Usgm ( l_Usgm );

  -----------------------------------------------------------------------
  -- Register Theme for table
  -----------------------------------------------------------------------

  l_Theme_Name := Substr (l_Nlt.Nlt_Descr, 1, 26);


  l_Theme_Id := Register_Lrm_Theme  (
                                    p_Nlt_Id           => pi_Nlt_Id,
                                    p_Base             => l_Base_Themes,
                                    p_Table_Name       => l_Tab,
                                    p_Column_Name      => 'GEOLOC',
                                    p_Name             => l_Theme_Name || '_TAB'
                                    );
  l_Base_Table_Theme := l_Theme_Id;

  l_Nlt_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);

  -----------------------------------------------------------------------
  -- Register Theme for date view
  -----------------------------------------------------------------------

  l_Theme_Id := Register_Lrm_Theme  (
                                    p_Nlt_Id              => pi_Nlt_Id,
                                    p_Base                => l_Base_Themes,
                                    p_Table_Name          => 'V_' || l_Tab,
                                    p_Column_Name         => 'GEOLOC',
                                    p_Name                => l_Theme_Name,
                                    p_View_Flag           => 'Y',
                                    p_Base_Table_Nth      => l_Base_Table_Theme
                                   );

  -----------------------------------------------------------------------
  -- Need a join view between spatial table and NT view
  -----------------------------------------------------------------------

  l_View := Create_Nlt_Sdo_Join_View  (
                                      p_Feature_Table_Name  =>  l_Tab
                                      );

  -----------------------------------------------------------------------
  -- Create the spatial data
  -----------------------------------------------------------------------

  Nm3Sdo.Create_Nt_Data( Nm3Get.Get_Nth(l_Base_Table_Theme), pi_Nlt_Id, l_Base_Themes, p_Job_Id );

  -----------------------------------------------------------------------
  -- Table needs a spatial index
  -----------------------------------------------------------------------

  Create_Nlt_Spatial_Idx (l_Nlt, l_Tab);

  -----------------------------------------------------------------------
  -- Register theme for _DT attribute view
  -----------------------------------------------------------------------

  If G_Date_Views = 'Y' Then

    l_Usgm.Table_Name := l_View;

    Nm3Sdo.Ins_Usgm ( l_Usgm );

    l_Theme_Name := Substr (l_Nlt.Nlt_Descr, 1, 27) || '_DT';
    l_Theme_Id := Register_Lrm_Theme  (
                                      p_Nlt_Id              => pi_Nlt_Id,
                                      p_Base                => l_Base_Themes,
                                      p_Table_Name          => l_View,
                                      p_Column_Name         => 'GEOLOC',
                                      p_Name                => l_Theme_Name,
                                      p_View_Flag           => 'Y',
                                      p_Base_Table_Nth      => l_Base_Table_Theme
                                      );
  End If;

  -----------------------------------------------------------------------
  -- Analyse table
  -----------------------------------------------------------------------
  Begin
    Nm3Ddl.Analyse_Table  (
                          pi_Table_Name          => l_Tab,
                          pi_Schema              => Sys_Context('NM3CORE','APPLICATION_OWNER'),
                          pi_Estimate_Percentage => Null,
                          pi_Auto_Sample_Size    => False
                          );
  Exception
    When Others Then
      Raise E_No_Analyse_Privs;
  End;
  --
  Nm_Debug.Proc_End (G_Package_Name, 'make_nt_spatial_layer');
  --
Exception
  When E_Not_Unrestricted Then
    Raise_Application_Error (-20777,'Restricted users are not permitted to create SDO layers');
  When E_No_Analyse_Privs Then
    Raise_Application_Error (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                    'Please ensure the correct role/privs are applied to the user');
End Make_Nt_Spatial_Layer; 
--
-----------------------------------------------------------------------------
--
Function Get_Nth (
                 pi_Nth_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                 ) Return Nm_Themes_All%Rowtype
Is
  Retval   Nm_Themes_All%Rowtype;
Begin
  Begin
    Select  *
    Into    Retval
    From    Nm_Themes_All
    Where   Nth_Theme_Id = pi_Nth_Theme_Id;
  Exception
    When No_Data_Found Then
      Null;
  End;

  Return Retval;
End Get_Nth;
--
-----------------------------------------------------------------------------
--Note that this is temporary - theoretically, the function needs to be
--able to return all themes for a NT - its a many to many when you include
--schematics etc.
--Also, for now it assumes it is a base datum for use in the split/merge routines
--
-- The p_Gt Parameter is not used and is included just to keep the header signature the same.
Function Get_Nt_Theme (
                      p_Nt   In   Nm_Types.Nt_Type%Type,
                      p_Gt In Nm_Group_Types.Ngt_Group_Type%Type Default Null
                      ) Return Nm_Themes_All.Nth_Theme_Id%Type
Is
  Retval   Nm_Themes_All.Nth_Theme_Id%Type;
Begin
  Begin 
    Select  Nth_Theme_Id
    Into    Retval
    From    Nm_Themes_All     nta,
            Nm_Nw_Themes      nnt,
            Nm_Linear_Types   nlt
    Where   nlt.Nlt_Id                =   nnt.Nnth_Nlt_Id
    And     nnt.Nnth_Nth_Theme_Id     =   nta.Nth_Theme_Id
    And     nlt.Nlt_Nt_Type           =   p_Nt
    And     nta.Nth_Theme_Type        =   'SDO'
    And     nta.Nth_Base_Table_Theme  Is  Null
    And     Not Exists                (
                                      Select  Null
                                      From    Nm_Base_Themes    nbt
                                      Where   nbt.Nbth_Theme_Id = nta.Nth_Theme_Id
                                      );
  Exception
    When No_Data_Found Then
      Null;
  End;

 Return Retval;
   
 End Get_Nt_Theme;
--
-----------------------------------------------------------------------------
--
Procedure  Split_Element_At_Xy (
                               p_Layer   In      Number,
                               p_Ne_Id   In      Number,
                               p_Measure In      Number,
                               p_X       In      Number,
                               p_Y       In      Number,
                               p_Ne_Id_1 In      Number,
                               p_Ne_Id_2 In      Number,
                               p_Geom_1      Out Mdsys.Sdo_Geometry,
                               p_Geom_2      Out Mdsys.Sdo_Geometry
                               )
Is
  l_Geom    Mdsys.Sdo_Geometry := Nm3Sdo.Get_Layer_Element_Geometry( p_Layer, p_Ne_Id );

  l_Measure  Number;
  l_Distance Number;
  l_Usgm     User_Sdo_Geom_Metadata%Rowtype;
  l_End      Number;
  l_tol      Number;
Begin
  l_Usgm := Nm3Sdo.Get_Theme_Metadata( p_Layer );
  If Nm3Sdo.Element_Has_Shape( p_Layer, p_Ne_Id ) = 'TRUE'  Then
    l_Distance := sdo_geom.sdo_distance( l_geom, nm3sdo.get_2d_pt(p_x, p_y), 0.005);
    if l_Distance > to_number( nvl(hig.get_sysopt('SDOPROXTOL'), 2 )) then
      raise_application_error(-20001, 'Split position is not in close proximity to element geometry');
    end if;
    
    l_Measure := Nm3Sdo.Get_Measure ( p_Layer, p_Ne_Id, p_X, p_Y ).Lr_Offset;

      select NM3SDO.GET_TOL_FROM_UNIT_MASK(nt_length_unit) into l_tol 
        from nm_elements, nm_types where ne_id = p_Ne_Id and ne_nt_type = nt_type;

    l_End   := Nm3Net.Get_Datum_Element_Length( p_Ne_Id );
    
      if l_measure < l_tol or abs(l_End - l_measure ) < l_tol then
        raise_application_error(-20001, 'Split position cannot be at the start or end of an element');
      end if;
    
    Sdo_Lrs.Split_Geom_Segment( l_Geom, l_Usgm.Diminfo, l_Measure, p_Geom_1, p_Geom_2 );

    If p_Measure Is Not Null Then
      l_Measure := p_Measure;        
    End If;
      

    p_Geom_1 := Sdo_Lrs.Scale_Geom_Segment  (
                                            Geom_Segment  => p_Geom_1,
                                            Dim_Array     => l_Usgm.Diminfo,
                                            Start_Measure => 0,
                                            End_Measure   => l_Measure,
                                            Shift_Measure => 0 
                                            );

    l_End   := Nm3Net.Get_Datum_Element_Length( p_Ne_Id ) - l_Measure;

    p_Geom_2 := Sdo_Lrs.Scale_Geom_Segment  (
                                            Geom_Segment  => p_Geom_2,
                                            Dim_Array     => l_Usgm.Diminfo,
                                            Start_Measure => 0,
                                            End_Measure   => l_End,
                                            Shift_Measure => 0
                                            );
  Else
    p_Geom_1 := Null;
    p_Geom_2 := Null;

  End If;

End Split_Element_At_Xy;
--
-----------------------------------------------------------------------------
--
Procedure Split_Element_Shapes  (
                                p_Ne_Id     In   Nm_Elements.Ne_Id%Type,
                                p_Measure   In   Number,
                                p_Ne_Id_1   In   Nm_Elements.Ne_Id%Type,
                                p_Ne_Id_2   In   Nm_Elements.Ne_Id%Type,
                                p_X         In   Number Default Null,
                                p_Y         In   Number Default Null
                                )
Is
  l_Layer   Number;
  l_Geom1   Mdsys.Sdo_Geometry;
  l_Geom2   Mdsys.Sdo_Geometry;
Begin
  l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id).Ne_Nt_Type);
  
  IF NOT test_theme_for_update(l_layer) then
    HIG.RAISE_NER('NET', 339);
  END IF;

  If Nm3Sdo.Element_Has_Shape (L_Layer, P_Ne_Id) = 'TRUE' Then
    If p_X Is Null And p_Y Is Null Then

      Nm3Sdo.Split_Element_At_Measure (
                                      p_Layer        => l_Layer,
                                      p_Ne_Id        => p_Ne_Id,
                                      p_Measure      => p_Measure,
                                      p_Ne_Id_1      => p_Ne_Id_1,
                                      p_Ne_Id_2      => p_Ne_Id_2,
                                      p_Geom1        => l_Geom1,
                                      p_Geom2        => l_Geom2
                                      );
    Elsif p_X Is Not Null And p_Y Is Not Null Then

      Split_Element_At_Xy (
                          p_Layer        =>   l_Layer,
                          p_Ne_Id        =>   p_Ne_Id,
                          p_Measure      =>   p_Measure,
                          p_X            =>   p_X,
                          p_Y            =>   p_Y,
                          p_Ne_Id_1      =>   p_Ne_Id_1,
                          p_Ne_Id_2      =>   p_Ne_Id_2,
                          p_Geom_1       =>   l_Geom1,
                          p_Geom_2       =>   l_Geom2
                          );

    Else
      Raise_Application_Error(-20001, 'Incompatible values');

    End If;

    Nm3Sdo.Insert_Element_Shape (
                                p_Layer      => l_Layer,
                                p_Ne_Id      => p_Ne_Id_1,
                                p_Geom       => l_Geom1
                                );
         
    Nm3Sdo.Insert_Element_Shape (
                                p_Layer      => l_Layer,
                                p_Ne_Id      => p_Ne_Id_2,
                                p_Geom       => l_Geom2
                                );
  End If;

End Split_Element_Shapes;
--
-----------------------------------------------------------------------------
--
Procedure Ins_Usgm (Pi_Rec_Usgm In Out User_Sdo_Geom_Metadata%Rowtype)
Is
Begin
  Nm_Debug.Proc_Start (G_Package_Name, 'ins_usgm');

  Insert Into Mdsys.Sdo_Geom_Metadata_Table
  (
  Sdo_Table_Name,
  Sdo_Column_Name,
  Sdo_Diminfo,
  Sdo_Srid,
  Sdo_Owner
  )
  Values
  (
  pi_Rec_Usgm.Table_Name,
  pi_Rec_Usgm.Column_Name,
  pi_Rec_Usgm.Diminfo,
  pi_Rec_Usgm.Srid,
  Sys_Context('NM3CORE','APPLICATION_OWNER')
  )
  Returning 
  Sdo_Table_Name,
  Sdo_Column_Name,
  Sdo_Diminfo,
  Sdo_Srid
  Into
  pi_Rec_Usgm.Table_Name,
  pi_Rec_Usgm.Column_Name,
  pi_Rec_Usgm.Diminfo,
  pi_Rec_Usgm.Srid;

  Nm_Debug.Proc_End (G_Package_Name, 'ins_usgm');
    
End Ins_Usgm;
--
-----------------------------------------------------------------------------
--
Procedure Merge_Element_Shapes  (
                                p_Ne_Id           In   Nm_Elements.Ne_Id%Type,
                                p_Ne_Id_1         In   Nm_Elements.Ne_Id%Type,
                                p_Ne_Id_2         In   Nm_Elements.Ne_Id%Type,
                                p_Ne_Id_To_Flip   In   Nm_Elements.Ne_Id%Type
                                )
Is
  l_Layer   Number;
  l_Geom    Mdsys.Sdo_Geometry;
Begin
  l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (P_Ne_Id).Ne_Nt_Type);
  
  if not test_theme_for_update(l_Layer) then
    HIG.RAISE_NER('NET', 339);
  END IF;
  

  If      Nm3Sdo.Element_Has_Shape (L_Layer, P_Ne_Id_1) = 'TRUE'
      And Nm3Sdo.Element_Has_Shape (L_Layer, P_Ne_Id_2) = 'TRUE'  Then
        
    Nm3Sdo.Merge_Element_Shapes (
                                p_Layer              => l_Layer,
                                p_Ne_Id_1            => p_Ne_Id_1,
                                p_Ne_Id_2            => p_Ne_Id_2,
                                p_Ne_Id_To_Flip      => p_Ne_Id_To_Flip,
                                p_Geom               => l_Geom
                                );

    If L_Geom Is Not Null Then
      Nm3Sdo.Insert_Element_Shape (
                                  p_Layer      => l_Layer,
                                  p_Ne_Id      => p_Ne_Id,
                                  p_Geom       => l_Geom
                                  );
    End If;
  End If;
End Merge_Element_Shapes;
--
-----------------------------------------------------------------------------
--
Procedure Replace_Element_Shape (
                                p_Ne_Id_Old   In   Nm_Elements.Ne_Id%Type,
                                p_Ne_Id_New   In   Nm_Elements.Ne_Id%Type
                                )
Is
  l_Layer_Old   Number;
  l_Layer_New   Number;
  l_Geom        Mdsys.Sdo_Geometry;
Begin
  l_Layer_Old := Get_Nt_Theme (Nm3Get.Get_Ne_All (p_Ne_Id_Old).Ne_Nt_Type);
  l_Layer_New := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id_New).Ne_Nt_Type);

  IF NOT test_theme_for_update(l_Layer_Old) then
    HIG.RAISE_NER('NET', 339);
  END IF;

  If      Nm3Sdo.Element_Has_Shape (l_Layer_Old, p_Ne_Id_Old) = 'TRUE' 
      And l_Layer_New Is Not Null Then
    l_Geom := Nm3Sdo.Get_Layer_Element_Geometry (l_Layer_Old, p_Ne_Id_Old);
    --  The old element shape must be end-dated
    --  The new one must be created
    --  All affected shapes inside asset layers must be regenerated
    Nm3Sdo.Insert_Element_Shape (
                                p_Layer      => l_Layer_New,
                                p_Ne_Id      => p_Ne_Id_New,
                                p_Geom       => l_Geom
                                );
    End If;   
End Replace_Element_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Reverse_Element_Shape (
                                p_Ne_Id_Old   In   Nm_Elements.Ne_Id%Type,
                                p_Ne_Id_New   In   Nm_Elements.Ne_Id%Type
                                )
Is
  l_Layer   Number;
  l_Geom    Mdsys.Sdo_Geometry;
Begin
  l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne_All (p_Ne_Id_Old).Ne_Nt_Type);

  IF NOT test_theme_for_update(l_Layer) then
    HIG.RAISE_NER('NET', 339);
  END IF;  

  If Nm3Sdo.Element_Has_Shape (l_Layer, p_Ne_Id_Old) = 'TRUE' Then
      
    l_Geom := Nm3Sdo.Get_Layer_Element_Geometry (l_Layer, p_Ne_Id_Old);
      
    l_Geom := Nm3Sdo.Reverse_Geometry (p_Geom => l_Geom);
      
    Nm3Sdo.Insert_Element_Shape (
                                p_Layer      => l_Layer,
                                p_Ne_Id      => p_Ne_Id_New,
                                p_Geom       => l_Geom
                                );
    End If;
End Reverse_Element_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Recalibrate_Element_Shape (
                                    p_Ne_Id               In   Nm_Elements.Ne_Id%Type,
                                    p_Measure             In   Number,
                                    p_New_Length_To_End   In   Nm_Elements.Ne_Length%Type
                                    )
Is
  l_Layer     Number;
  l_Pt_Geom   Mdsys.Sdo_Geometry;
  l_Geom      Mdsys.Sdo_Geometry;
Begin  
  l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id).Ne_Nt_Type);

  IF NOT test_theme_for_update(l_Layer) then
    HIG.RAISE_NER('NET', 339);
  END IF;


  If Nm3Sdo.Element_Has_Shape (l_Layer, p_Ne_Id) = 'TRUE' Then

    l_Geom := Nm3Sdo.Get_Layer_Element_Geometry (l_Layer, p_Ne_Id);

    l_Geom := Nm3Sdo.Recalibrate_Geometry (
                                          p_Layer              => l_Layer,
                                          p_Ne_Id              => p_Ne_Id,
                                          p_Geom               => l_Geom,
                                          p_Measure            => p_Measure,
                                          p_Length_To_End      => p_New_Length_To_End
                                          );
    Nm3Sdo.Delete_Layer_Shape (
                              p_Layer => l_Layer,
                              p_Ne_Id => p_Ne_Id
                              );

    Nm3Sdo.Insert_Element_Shape (
                                p_Layer      => l_Layer,
                                p_Ne_Id      => p_Ne_Id,
                                p_Geom       => l_Geom
                                );
    --  The measures on the routes will be affected
    --  However, the nm_true will be out of step - this should be done on a resequence

    --  The other layers are also affected, but since the calling process will affect the members, best left to
    --  the trigger to deal with it.
  End If;
End Recalibrate_Element_Shape;
--
-------------------------------------------------------------------------------------------------------------------
--
Procedure Shift_Asset_Shapes  (
                              p_Ne_Id               In   Nm_Elements.Ne_Id%Type,
                              p_Measure             In   Number,
                              p_New_Length_To_End   In   Nm_Elements.Ne_Length%Type
                              )
Is
  l_Layer     Number;
  l_Pt_Geom   Mdsys.Sdo_Geometry;
  l_Geom      Mdsys.Sdo_Geometry;
Begin
  l_Layer := Get_Nt_Theme (Nm3Get.Get_Ne (p_Ne_Id).Ne_Nt_Type);

  If Nm3Sdo.Element_Has_Shape (l_Layer, p_Ne_Id) = 'TRUE' Then

    --  remove all existing shapes - they will move with the shift
    Nm3Sdo.Add_New_Inv_Shapes (
                              p_Layer      => l_Layer,
                              p_Ne_Id      => p_Ne_Id,
                              p_Geom       => l_Geom
                              );
  End If;
End Shift_Asset_Shapes;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Inv_Base_Themes  (
                              p_Inv_Type In Nm_Inv_Nw.Nin_Nit_Inv_Code%Type
                              ) Return Nm_Theme_Array
Is
  Retval Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;
Begin
  Select  Nm_Theme_Entry(nta.Nth_Theme_Id)
  Bulk Collect 
  Into    Retval.Nta_Theme_Array
  From    Nm_Nw_Themes    nnt,
          Nm_Themes_All   nta,
          Nm_Linear_Types nlt,
          Nm_Inv_Nw       nin
  Where   nin.Nin_Nit_Inv_Code      =   p_Inv_Type
  And     nin.Nin_Nw_Type           =   nlt.Nlt_Nt_Type
  And     nlt.Nlt_Id                =   nnt.Nnth_Nlt_Id
  And     nta.Nth_Base_Table_Theme  Is  Null
  And     nnt.Nnth_Nth_Theme_Id     =   nta.Nth_Theme_Id
  And     Not Exists            (   Select  Null
                                    From    Nm_Base_Themes  nbt
                                    Where   nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                                );

  If Retval.Nta_Theme_Array.Last Is Null  Then
    -- no base theme availible
    Hig.Raise_Ner (Pi_Appl         => Nm3Type.C_Hig,
                   Pi_Id           => 194,
                   Pi_Sqlcode      => -20001
                  );
  End If;
    
  Return Retval;
End Get_Inv_Base_Themes;
--
---------------------------------------------------------------------------------------------------
--
Function Register_Inv_Theme (
                            pi_Nit             In   Nm_Inv_Types%Rowtype,
                            p_Base_Themes      In   Nm_Theme_Array,
                            p_Table_Name       In   Varchar2,
                            p_Spatial_Column   In   Varchar2 Default 'GEOLOC',
                            p_Fk_Column        In   Varchar2 Default 'NE_ID',
                            p_Name             In   Varchar2 Default Null,
                            p_View_Flag        In   Varchar2 Default 'N',
                            p_Pk_Column        In   Varchar2 Default 'NE_ID',
                            p_Base_Table_Nth   In   Nm_Themes_All.Nth_Theme_Id%Type Default Null
                            ) Return Number
Is
  l_Immediate_Or_Deferred   Varchar2 (1)              := 'I';
  l_F_Fk_Column             Varchar2 (30)             := 'NE_ID';
  l_Pk_Column               Varchar2 (30);
  l_Name                    Varchar2 (30);
  l_T_Pk_Column             Varchar2 (30);
  l_T_Fk_Column             Varchar2 (30);
  l_T_Uk_Column             Varchar2 (30);
  l_T_Begin_Col             Varchar2 (30);
  l_Tab                     Varchar2 (30);
  l_End_Mp                  Varchar2 (30)             := Null;
  Retval                    Number;
  l_Nth                     Nm_Themes_All%Rowtype;
  l_Rec_Nith                Nm_Inv_Themes%Rowtype;
  l_Rec_Ntg                 Nm_Theme_Gtypes%Rowtype;

Begin
  l_Name := Upper (p_Name);

  If l_Name Is Null Then
    l_Name :=  Upper (Nvl  (  pi_Nit.Nit_Short_Descr,
                              Substr (Pi_Nit.Nit_Inv_Type || '-' || pi_Nit.Nit_Descr,1,30)
                           )
                      );
  End If;

  If p_View_Flag = 'Y'  Then
    l_Immediate_Or_Deferred := 'N';
    l_F_Fk_Column           := Null;
  End If;

  l_Pk_Column := p_Fk_Column;

  If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
    If p_Pk_Column Is Not Null Then      
      l_Pk_Column := p_Pk_Column;
    Else
      --  to make SM work for now we have to put the NE_ID in!
      l_Pk_Column := 'NE_ID';
    End If;
  End If;

  Retval := Higgis.Next_Theme_Id;

  If Pi_Nit.Nit_Pnt_Or_Cont = 'C' Then
    l_End_Mp := 'NM_END_MP';
  End If;

  If Pi_Nit.Nit_Table_Name Is Not Null  Then
    --  Foreign table
    l_Tab         := pi_Nit.Nit_Table_Name;
    l_T_Pk_Column := pi_Nit.Nit_Foreign_Pk_Column;
    l_T_Fk_Column := pi_Nit.Nit_Lr_Ne_Column_Name;
    l_T_Uk_Column := pi_Nit.Nit_Foreign_Pk_Column;
    l_T_Begin_Col := pi_Nit.Nit_Lr_St_Chain;

    l_immediate_or_deferred := 'N';
    
    If pi_Nit.Nit_Pnt_Or_Cont = 'C' Then
      l_End_Mp := pi_Nit.Nit_Lr_End_Chain;
    End If;
  Else
    l_Tab :=  Nm3Inv_View.Work_Out_Inv_Type_View_Name (pi_Nit.Nit_Inv_Type);
    l_T_Pk_Column := 'IIT_NE_ID';
    l_T_Fk_Column := 'NE_ID_OF';
    l_T_Uk_Column := 'IIT_PRIMARY_KEY';
    l_T_Begin_Col := 'NM_BEGIN_MP';

    If pi_Nit.Nit_Pnt_Or_Cont = 'C'  Then
      l_End_Mp := 'NM_END_MP';
    End If;
  End If;

--  Build theme rowtype
  l_Nth.Nth_Theme_Id               := Retval;
  l_Nth.Nth_Theme_Name             := l_Name;
  l_Nth.Nth_Table_Name             := l_Tab;
  l_Nth.Nth_Where                  := Null;
  l_Nth.Nth_Pk_Column              := l_T_Pk_Column;
  l_Nth.Nth_Label_Column           := l_T_Uk_Column;
  l_Nth.Nth_Rse_Table_Name         := 'NM_ELEMENTS';
  l_Nth.Nth_Rse_Fk_Column          := l_T_Fk_Column;
  l_Nth.Nth_St_Chain_Column        := l_T_Begin_Col;
  l_Nth.Nth_End_Chain_Column       := l_End_Mp;
  l_Nth.Nth_X_Column               := Null;
  l_Nth.Nth_Y_Column               := Null;
  l_Nth.Nth_Offset_Field           := Null;
  l_Nth.Nth_Feature_Table          := p_Table_Name;
  l_Nth.Nth_Feature_Pk_Column      := l_Pk_Column;
  l_Nth.Nth_Feature_Fk_Column      := l_F_Fk_Column;
  l_Nth.Nth_Xsp_Column             := Null;
  l_Nth.Nth_Feature_Shape_Column   := p_Spatial_Column;
  l_Nth.Nth_Hpr_Product            := 'NET';
  l_Nth.Nth_Location_Updatable     := 'N';
  l_Nth.Nth_Theme_Type             := 'SDO';
  l_Nth.Nth_Dependency             := 'D';
  l_Nth.Nth_Storage                := 'S';
  l_Nth.Nth_Update_On_Edit         := l_Immediate_Or_Deferred;
  l_Nth.Nth_Use_History            := 'Y';
  l_Nth.Nth_Start_Date_Column      := 'START_DATE';
  l_Nth.Nth_End_Date_Column        := 'END_DATE';
  l_Nth.Nth_Base_Table_Theme       := p_Base_Table_Nth;
  l_Nth.Nth_Sequence_Name          := 'NTH_' || Nvl(p_Base_Table_Nth,Retval) || '_SEQ';
  l_Nth.Nth_Snap_To_Theme          := 'N';
  l_Nth.Nth_Lref_Mandatory         := 'N';
  l_Nth.Nth_Tolerance              := 10;
  l_Nth.Nth_Tol_Units              := 1;
  --
  Nm3Ins.Ins_Nth (L_Nth);
  --  Build inv theme link
  l_Rec_Nith.Nith_Nit_Id        := pi_Nit.Nit_Inv_Type;
  l_Rec_Nith.Nith_Nth_Theme_Id  := Retval;
  --
  Nm3Ins.Ins_Nith (L_Rec_Nith);
  --  Build theme gtype rowtype
  l_Rec_Ntg.Ntg_Theme_Id  := l_Nth.Nth_Theme_Id;
  l_Rec_Ntg.Ntg_Seq_No    := 1;
  l_Rec_Ntg.Ntg_Xml_Url   := Null;

  If pi_Nit.Nit_Pnt_Or_Cont = 'P' Then
    l_Rec_Ntg.Ntg_Gtype := '2001';
  Elsif pi_Nit.Nit_Pnt_Or_Cont = 'C'  Then
     l_Rec_Ntg.Ntg_Gtype := 3302;
  End If;

  Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

  Create_Base_Themes( Retval, p_Base_Themes );
  --
  If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then
     Execute Immediate (   'begin '
                        || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( l_Nth.Nth_Theme_Id )||')'
                        || '; end;'
                       );
  End If;

  If p_View_Flag = 'Y'  Then
    Insert Into Nm_Theme_Roles
    (
    Nthr_Theme_Id,
    Nthr_Role,
    Nthr_Mode
    )
    Select  Retval,
            nitr.Itr_Hro_Role,
            nitr.Itr_Mode
    From    Nm_Inv_Type_Roles nitr
    Where   Itr_Inv_Type = pi_Nit.Nit_Inv_Type;
  End If;
  --
  -- register the theme functions
  --

  If pi_Nit.Nit_Table_Name Is Null Then
    Create_Theme_Functions( p_Theme => l_Nth.Nth_Theme_Id, p_Pa => g_Asset_Modules, p_Exclude => Null );
  Else
    -- FT exclude data with a 2
    Create_Theme_Functions( p_Theme => l_Nth.Nth_Theme_Id, p_Pa => g_Asset_Modules, p_Exclude => 2 );
  End If;

  Return Retval;
    
End Register_Inv_Theme;
--
---------------------------------------------------------------------------------------------------
--
Function Register_Ona_Theme (
                            pi_Nit             In   Nm_Inv_Types%Rowtype,
                            p_Table_Name       In   Varchar2,
                            p_Spatial_Column   In   Varchar2 Default 'GEOLOC',
                            p_Fk_Column        In   Varchar2 Default 'NE_ID',
                            p_Name             In   Varchar2 Default Null,
                            p_View_Flag        In   Varchar2 Default 'N',
                            p_Pk_Column        In   Varchar2 Default 'NE_ID',
                            p_Base_Table_Nth   In   Nm_Themes_All.Nth_Theme_Id%Type Default Null
                            ) Return Number
Is
  l_Immediate_Or_Deferred   Varchar2 (1)                           := 'N';
  l_Pk_Column               Varchar2 (30);
  l_Name                    Varchar2 (30);
  l_T_Pk_Column             Varchar2 (30);
  l_T_Fk_Column             Varchar2 (30);
  l_T_Uk_Column             Varchar2 (30);
  l_T_Begin_Col             Varchar2 (30);
  l_T_End_Col               Varchar2 (30);
  l_T_X_Col                 Varchar2 (30);
  l_T_Y_Col                 Varchar2 (30);
  --
  l_Tab                     Varchar2 (30);
  l_End_Mp                  Varchar2 (10)                         := Null;
  Retval                    Number;
  l_Nth                     Nm_Themes_All%Rowtype;
  l_Rec_Base_Nth            Nm_Themes_All%Rowtype;
  l_Rec_Nith                Nm_Inv_Themes%Rowtype;
  l_Rec_Ntg                 Nm_Theme_Gtypes%Rowtype;
  l_Nth_Start_Date_Column   Nm_Themes_All.Nth_Start_Date_Column%Type;
  l_Nth_End_Date_Column     Nm_Themes_All.Nth_End_Date_Column%Type;
  l_Nth_Base_Table_Theme    Nm_Themes_All.Nth_Base_Table_Theme%Type;
  l_Nth_Sequence_Name       Nm_Themes_All.Nth_Sequence_Name%Type;
  l_Nth_Snap_To_Theme       Nm_Themes_All.Nth_Snap_To_Theme%Type;
  l_Nth_Lref_Mandatory      Nm_Themes_All.Nth_Lref_Mandatory%Type;
  l_Nth_Tolerance           Nm_Themes_All.Nth_Tolerance%Type;
  l_Nth_Tol_Units           Nm_Themes_All.Nth_Tol_Units%Type;
  e_Dup_Nth                 Exception;
  e_Dup_Nith                Exception;
  e_Dup_Ntg                 Exception;

  --
  Function Get_Base_Gtype (
                          Cp_Theme_Id In Number
                          ) Return Number
  Is
     Retval   Number;
  Begin
    Select  Max (Ntg_Gtype)
    Into    Retval
    From    Nm_Theme_Gtypes
    Where   Ntg_Theme_Id = Cp_Theme_Id;

    Return Retval;
      
  Exception
    When Others
    Then
      Hig.Raise_Ner (Pi_Appl         => Nm3Type.C_Hig,
                     Pi_Id           => 268,
                     Pi_Sqlcode      => -20001
                    );
  End Get_Base_Gtype;
------------
--
------------
Begin
    --
  Nm_Debug.Proc_Start (G_Package_Name, 'register_ona_theme');
  --
  l_Name := Upper (p_Name);

  If l_Name Is Null Then
       
     l_Name :=  Upper (Nvl (pi_Nit.Nit_Short_Descr,
                        Substr (pi_Nit.Nit_Inv_Type || '-' || pi_Nit.Nit_Descr,1,30)
                      ));
  End If;

  If pi_Nit.Nit_Table_Name Is Not Null  Then
     l_Pk_Column := pi_Nit.Nit_Foreign_Pk_Column;
  Else
     L_Pk_Column := 'IIT_NE_ID';
  End If;
  --
  If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
     l_Pk_Column := 'IIT_NE_ID';
  End If;
  --
  Retval := Higgis.Next_Theme_Id;

  If pi_Nit.Nit_Table_Name Is Not Null  Then
     --  Foreign table
     l_Tab          :=  pi_Nit.Nit_Table_Name;
     l_T_Pk_Column  :=  pi_Nit.Nit_Foreign_Pk_Column;
     l_T_Uk_Column  :=  pi_Nit.Nit_Foreign_Pk_Column;
  Else
    l_Tab           := Nm3Inv_View.Work_Out_Inv_Type_View_Name (pi_Nit.Nit_Inv_Type);
    l_T_Pk_Column   := 'IIT_NE_ID';
    l_T_Uk_Column   := 'IIT_PRIMARY_KEY';

     If Pi_Nit.Nit_Use_Xy = 'Y'
     Then
        L_T_X_Col := 'IIT_X';
        L_T_Y_Col := 'IIT_Y';
     End If;
  End If;

  --
  If p_Base_Table_Nth Is Not Null Then
    l_Rec_Base_Nth :=  Nm3Get.Get_Nth (pi_Nth_Theme_Id => p_Base_Table_Nth);
  End If;

  --
  l_Nth.Nth_Theme_Id               := Retval;
  l_Nth.Nth_Theme_Name             := l_Name;
  l_Nth.Nth_Table_Name             := l_Tab;
  l_Nth.Nth_Where                  := Null;
  l_Nth.Nth_Pk_Column              := l_T_Pk_Column;
  l_Nth.Nth_Label_Column           := l_T_Uk_Column;
  l_Nth.Nth_X_Column               := l_T_X_Col;
  l_Nth.Nth_Y_Column               := l_T_Y_Col;
  l_Nth.Nth_Feature_Table          := p_Table_Name;
  l_Nth.Nth_Feature_Pk_Column      := Nvl (p_Pk_Column,l_Rec_Base_Nth.Nth_Feature_Pk_Column);
  l_Nth.Nth_Feature_Shape_Column   := p_Spatial_Column;
  l_Nth.Nth_Hpr_Product            := 'NET';
  l_Nth.Nth_Location_Updatable     := Nvl (l_Rec_Base_Nth.Nth_Location_Updatable, 'N');
  l_Nth.Nth_Theme_Type             := 'SDO';
  l_Nth.Nth_Dependency             := 'I';
  l_Nth.Nth_Storage                := 'S';
  l_Nth.Nth_Update_On_Edit         := l_Immediate_Or_Deferred;
  l_Nth.Nth_Use_History            := 'Y';
  l_Nth.Nth_Start_Date_Column      := Nvl (l_Rec_Base_Nth.Nth_Start_Date_Column, 'START_DATE');
  l_Nth.Nth_End_Date_Column        := Nvl (l_Rec_Base_Nth.Nth_End_Date_Column, 'END_DATE');
  l_Nth.Nth_Base_Table_Theme       := p_Base_Table_Nth;
  l_Nth.Nth_Sequence_Name          := Nvl (l_Rec_Base_Nth.Nth_Sequence_Name, 'NTH_' || Retval || '_SEQ');
  l_Nth.Nth_Snap_To_Theme          := Nvl (l_Rec_Base_Nth.Nth_Snap_To_Theme, 'N');
  l_Nth.Nth_Lref_Mandatory         := Nvl (l_Rec_Base_Nth.Nth_Lref_Mandatory, 'N');
  l_Nth.Nth_Tolerance              := Nvl (l_Rec_Base_Nth.Nth_Tolerance, 10);
  l_Nth.Nth_Tol_Units              := 1;
  --
  Begin
    Nm3Ins.Ins_Nth (l_Nth);
  Exception
    When Dup_Val_On_Index Then
      Raise E_Dup_Nth;
  End;
  --
  l_Rec_Nith.Nith_Nit_Id        := pi_Nit.Nit_Inv_Type;
  l_Rec_Nith.Nith_Nth_Theme_Id  := Retval;

  Begin
    Nm3Ins.Ins_Nith (l_Rec_Nith);
  Exception
    When Dup_Val_On_Index Then
      Raise E_Dup_Nith;
  End;

  -- Create GTYPE record
  l_Rec_Ntg.Ntg_Gtype := Get_Base_Gtype (l_Rec_Base_Nth.Nth_Theme_Id);

  If l_Rec_Ntg.Ntg_Gtype Is Not Null  Then
    l_Rec_Ntg.Ntg_Theme_Id  := l_Nth.Nth_Theme_Id;
    l_Rec_Ntg.Ntg_Seq_No    := 1;
  End If;

  Begin
    Nm3Ins.Ins_Ntg (P_Rec_Ntg => L_Rec_Ntg);
  Exception
    When Dup_Val_On_Index Then
      Raise E_Dup_Ntg;
  End;

  If p_View_Flag = 'Y'  Then
    Insert Into Nm_Theme_Roles
    (
    Nthr_Theme_Id,
    Nthr_Role,
    Nthr_Mode
    )
    Select  Retval,
            nitr.Itr_Hro_Role,
            nitr.Itr_Mode
    From    Nm_Inv_Type_Roles   nitr
    Where   nitr.Itr_Inv_Type   =   pi_Nit.Nit_Inv_Type;
  End If;

  --
  -- create the theme functions
  --
  If Pi_Nit.Nit_Table_Name Is Null Then

    Create_Theme_Functions( p_Theme => l_Nth.Nth_Theme_Id, p_Pa => g_Asset_Modules, p_Exclude => Null );

  Else

    Create_Theme_Functions( p_Theme => l_Nth.Nth_Theme_Id, p_Pa => g_Asset_Modules, p_Exclude => 2 );

  End If;

  --
  Return Retval;
  --
  Nm_Debug.Proc_End (G_Package_Name, 'register_ona_theme');
 --
Exception
  When E_Dup_Nth  Then
    Hig.Raise_Ner (
                  pi_Appl         => Nm3Type.C_Hig,
                  pi_Id           => 269,
                  pi_Sqlcode      => -20001
                  );
  When E_Dup_Nith Then
    Hig.Raise_Ner (
                  pi_Appl         => Nm3Type.C_Hig,
                  pi_Id           => 270,
                  pi_Sqlcode      => -20001
                  );
  When E_Dup_Ntg  Then
    Hig.Raise_Ner (
                  pi_Appl         => Nm3Type.C_Hig,
                  pi_Id           => 271,
                  pi_Sqlcode      => -20001
                  );
End Register_Ona_Theme;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Nat_Base_Themes  (
                              p_Gty_Type In Nm_Area_Types.Nat_Gty_Group_Type%Type
                              ) Return Nm_Theme_Array 
Is
  Retval Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;

Begin
  Select  Nm_Theme_Entry(nta.Nth_Theme_Id)
  Bulk Collect 
  Into    Retval.Nta_Theme_Array
  From    Nm_Nw_Themes      nnt,
          Nm_Linear_Types   nlt,
          Nm_Themes_All     nta,
          Nm_Nt_Groupings   nng
  Where   nng.Nng_Group_Type        =   p_Gty_Type
  And     nng.Nng_Nt_Type           =   nlt.Nlt_Nt_Type
  And     nlt.Nlt_G_I_D             =   'D'
  And     nta.Nth_Base_Table_Theme  Is  Null
  And     nlt.Nlt_Gty_Type          Is  Null
  And     nlt.Nlt_Id                =   nnt.Nnth_Nlt_Id
  And     nnt.Nnth_Nth_Theme_Id     =   nta.Nth_Theme_Id
  And     Not Exists                (   Select  Null 
                                        From    Nm_Base_Themes  nbt
                                        Where   nta.Nth_Theme_Id = nbt.Nbth_Theme_Id
                                    );

  If Retval.Nta_Theme_Array.Last Is Null Then
    Hig.Raise_Ner   (
                    pi_Appl               =>  Nm3Type.C_Hig,
                    pi_Id                 =>  272,
                    pi_Sqlcode            =>  -20001,
                    pi_Supplementary_Info =>  p_Gty_Type
                    );
  End If;
  Return Retval;
End Get_Nat_Base_Themes;
--
---------------------------------------------------------------------------------------------------
--
Function Register_Nat_Theme (
                            p_Nt_Type          In   Nm_Types.Nt_Type%Type,
                            p_Gty_Type         In   Nm_Group_Types.Ngt_Group_Type%Type,
                            p_Base_Themes      In   Nm_Theme_Array,
                            p_Table_Name       In   Varchar2,
                            p_Spatial_Column   In   Varchar2 Default 'GEOLOC',
                            p_Fk_Column        In   Varchar2 Default 'NE_ID',
                            p_Name             In   Varchar2 Default Null,
                            p_View_Flag        In   Varchar2 Default 'N',
                            p_Base_Table_Nth   In   Nm_Themes_All.Nth_Theme_Id%Type Default Null
                            ) Return Number
Is
  Retval                    Number;
  l_Nat_Id                  Number;
  l_Name                    Varchar2 (30)                     := Nvl (p_Name, p_Table_Name);
  l_Immediate_Or_Deferred   Varchar2 (1)                      := 'I';
  l_Nat                     Nm_Area_Types%Rowtype;
  l_Nth_Id                  Nm_Themes_All.Nth_Theme_Id%Type;
  l_Nth                     Nm_Themes_All%Rowtype;
  l_Rec_Ntg                 Nm_Theme_Gtypes%Rowtype;

Begin

  If p_View_Flag = 'Y'  Then
    l_Immediate_Or_Deferred := 'N';                --no update for views
  End If;

  Select  Nat_Id_Seq.Nextval
  Into    l_Nat_Id
  From    Dual;

  l_Nat.Nat_Id              :=  l_Nat_Id;
  l_Nat.Nat_Nt_Type         :=  p_Nt_Type;
  l_Nat.Nat_Gty_Group_Type  :=  p_Gty_Type;
  l_Nat.Nat_Descr           :=  'Spatial Representation of ' || p_Gty_Type || ' Groups';
  l_Nat.Nat_Seq_No          :=  1;
  l_Nat.Nat_Start_Date      :=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
  l_Nat.Nat_End_Date        :=  Null;
  l_Nat.Nat_Shape_Type      :=  'TRACED';

  Begin
    Insert Into Nm_Area_Types
    (
    Nat_Id,
    Nat_Nt_Type,
    Nat_Gty_Group_Type,
    Nat_Descr,
    Nat_Seq_No,
    Nat_Start_Date,
    Nat_End_Date,
    Nat_Shape_Type
    )
    Values
    (
    l_Nat.Nat_Id,
    l_Nat.Nat_Nt_Type,
    l_Nat.Nat_Gty_Group_Type,
    l_Nat.Nat_Descr,
    l_Nat.Nat_Seq_No,
    l_Nat.Nat_Start_Date,
    l_Nat.Nat_End_Date,
    l_Nat.Nat_Shape_Type
    );
  Exception
    When Dup_Val_On_Index Then
      Select  nat.Nat_Id
      Into    l_Nat_Id
      From    Nm_Area_Types nat
      Where   nat.Nat_Nt_Type         =   p_Nt_Type
      And     nat.Nat_Gty_Group_Type  =   p_Gty_Type;
  End;

  Retval := Nm3Seq.Next_Nth_Theme_Id_Seq;

  -- generate the theme
  l_Nth_Id              :=  Retval;
  l_Nth.Nth_Theme_Id    :=  l_Nth_Id;
  l_Nth.Nth_Theme_Name  :=  l_Name;
  l_Nth.Nth_Table_Name  :=  p_Table_Name;
  l_Nth.Nth_Where       :=  Null;
  l_Nth.Nth_Pk_Column   :=  'NE_ID';
  --
  -- Task ID 0107889 - Set Label Column to NE_ID for Group layer base table themes
  -- 05/10/09 AE Further restrict on the non DT theme 
  --
    
  If      p_Base_Table_Nth      Is        Null
      Or  l_Nth.Nth_Theme_Name  Not Like  '%DT' Then
    l_Nth.Nth_Label_Column := 'NE_ID';
  Else
    l_Nth.Nth_Label_Column := 'NE_UNIQUE';
  End If;
  --
  
  l_Nth.Nth_Rse_Table_Name        :=  'NM_ELEMENTS';
  l_Nth.Nth_Rse_Fk_Column         :=  Null;
  l_Nth.Nth_St_Chain_Column       :=  Null;
  l_Nth.Nth_End_Chain_Column      :=  Null;
  l_Nth.Nth_X_Column              :=  Null;
  l_Nth.Nth_Y_Column              :=  Null;
  l_Nth.Nth_Offset_Field          :=  Null;
  l_Nth.Nth_Feature_Table         :=  p_Table_Name;
  l_Nth.Nth_Feature_Pk_Column     :=  'NE_ID';
  l_Nth.Nth_Feature_Fk_Column     :=  P_Fk_Column;
  l_Nth.Nth_Xsp_Column            :=  Null;
  l_Nth.Nth_Feature_Shape_Column  :=  p_Spatial_Column;
  l_Nth.Nth_Hpr_Product           :=  'NET';
  l_Nth.Nth_Location_Updatable    :=  'N';
  l_Nth.Nth_Theme_Type            :=  'SDO';
  l_Nth.Nth_Dependency            :=  'D';
  l_Nth.Nth_Storage               :=  'S';
  l_Nth.Nth_Update_On_Edit        :=  l_Immediate_Or_Deferred;
  l_Nth.Nth_Use_History           :=  'Y';
  l_Nth.Nth_Start_Date_Column     :=  'START_DATE';
  l_Nth.Nth_End_Date_Column       :=  'END_DATE';
  l_Nth.Nth_Base_Table_Theme      :=  p_Base_Table_Nth;
  l_Nth.Nth_Sequence_Name         :=  'NTH_' || Nvl(p_Base_Table_Nth,Retval) || '_SEQ';
  l_Nth.Nth_Snap_To_Theme         :=  'N';
  l_Nth.Nth_Lref_Mandatory        :=  'N';
  l_Nth.Nth_Tolerance             :=  10;
  l_Nth.Nth_Tol_Units             :=  1;
  Nm3Ins.Ins_Nth (l_Nth);
  --
  --  Build theme gtype rowtype
  l_Rec_Ntg.Ntg_Theme_Id  :=  l_Nth_Id;
  l_Rec_Ntg.Ntg_Seq_No    :=  1;
  l_Rec_Ntg.Ntg_Xml_Url   :=  Null;
  l_Rec_Ntg.Ntg_Gtype     :=  '2002';
  Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);

  -- generate the link
  Insert Into Nm_Area_Themes
  (
  Nath_Nat_Id,
  Nath_Nth_Theme_Id
  )
  Values
  (
  l_Nat_Id,
  l_Nth_Id
  );
    
  Create_Base_Themes( l_Nth_Id, p_Base_Themes );

  If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then 
    Execute Immediate (   'begin '
                      || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( l_Nth.Nth_Theme_Id )||');'
                      || 'end;'
                      );
  End If;

  If p_View_Flag = 'N'  Then
      
    Declare
      l_Role   Varchar2 (30);
    Begin
      l_Role := Hig.Get_Sysopt ('SDONETROLE');

      If l_Role Is Not Null Then
          
        Insert Into Nm_Theme_Roles
        (
        Nthr_Theme_Id,
        Nthr_Role,
        Nthr_Mode
        )
        Values
        (
        l_Nth_Id,
        l_Role,
        'NORMAL'
        );
          
      End If;
    End;
  End If;

  Declare
    l_Type Number;
  Begin
    If Nm3Net.Get_Gty_Sub_Group_Allowed( p_Gty_Type ) = 'Y' Then
      l_Type := 3;
    Else
      l_Type := 2;
    End If;
      
    Create_Theme_Functions( p_Theme => l_Nth.Nth_Theme_Id, p_Pa => g_Network_Modules, p_Exclude => l_Type );
      
  End;

  Return l_Nth_Id;
End Register_Nat_Theme;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Nlt_Descr  (
                        p_Nlt_Id In Number
                        ) Return Varchar2
Is
  Retval   Nm_Linear_Types.Nlt_Descr%Type;
Begin
  Begin
    Select  Nlt_Descr
    Into    Retval
    From    Nm_Linear_Types
    Where   Nlt_Id = p_Nlt_Id;
  Exception
    When No_Data_Found Then
      Null;
  End;
  Return Retval;
End Get_Nlt_Descr;
--
-----------------------------------------------------------------------------
--
-- Task 0108731
-- 
Function Register_Ona_Base_Theme  ( 
                                  pi_Asset_Type   In  Nm_Inv_Types.Nit_Inv_Type%Type,
                                  pi_Gtype        In  Nm_Theme_Gtypes.Ntg_Gtype%Type,
                                  pi_S_Date_Col   In  User_Tab_Columns.Column_Name%Type Default Null,
                                  pi_E_Date_Col   In  User_Tab_Columns.Column_Name%Type Default Null
                                  ) Return Nm_Themes_All%Rowtype
Is
  l_Rec_Nit    Nm_Inv_Types%Rowtype;
  l_Rec_Nth    Nm_Themes_All%Rowtype;
  l_Rec_Nthr   Nm_Theme_Roles%Rowtype;
  l_Rec_Ntg    Nm_Theme_Gtypes%Rowtype;
--
  Function Derive_Shape_Col (
                            pi_Table_Name In User_Tab_Cols.Table_Name%Type
                            ) Return User_Tab_Cols.Column_Name%Type
  Is
    l_Retval User_Tab_Cols.Column_Name%Type;
  Begin
    Begin
      Select utc.Column_Name
      Into   l_Retval
      From   User_Tab_Cols  utc
      Where  utc.Table_Name  =   pi_Table_Name
      And    utc.Data_Type   =   'SDO_GEOMETRY';

    Exception
      When No_Data_Found Or Too_Many_Rows Then
        l_Retval:='UNKNOWN';
    End;       
    Return l_Retval;      
  End Derive_Shape_Col;
--
Begin
  --
  l_Rec_Nit := Nm3Get.Get_Nit (pi_Nit_Inv_Type => pi_Asset_Type);
  --
  l_Rec_Nth.Nth_Theme_Id   := Nm3Seq.Next_Nth_Theme_Id_Seq;
  l_Rec_Nth.Nth_Theme_Name := Upper(Substr(l_Rec_Nit.Nit_Inv_Type||'-'
                              ||l_Rec_Nit.Nit_Descr, 1, 26)||'_TAB');
  --
  If l_Rec_Nit.Nit_Category = 'F' Then
    -- foreign table asset type
    l_Rec_Nth.Nth_Table_Name             := l_Rec_Nit.Nit_Table_Name;
    l_Rec_Nth.Nth_Pk_Column              := l_Rec_Nit.Nit_Foreign_Pk_Column;
    l_Rec_Nth.Nth_Label_Column           := l_Rec_Nit.Nit_Foreign_Pk_Column;
    l_Rec_Nth.Nth_Feature_Table          := l_Rec_Nit.Nit_Table_Name;
    l_Rec_Nth.Nth_Feature_Pk_Column      := l_Rec_Nit.Nit_Foreign_Pk_Column;
    l_Rec_Nth.Nth_Feature_Shape_Column   := Derive_Shape_Col (l_Rec_Nit.Nit_Table_Name);
  Else
    -- nm_inv_items_all asset type
    l_Rec_Nth.Nth_Table_Name             := l_Rec_Nit.Nit_View_Name;
    l_Rec_Nth.Nth_Pk_Column              := 'IIT_NE_ID';
    l_Rec_Nth.Nth_Label_Column           := 'IIT_NE_ID';
    l_Rec_Nth.Nth_Feature_Table          := Nm3Sdm.Get_Ona_Spatial_Table (l_Rec_Nit.Nit_Inv_Type);
    l_Rec_Nth.Nth_Feature_Pk_Column      := 'NE_ID';
    l_Rec_Nth.Nth_Feature_Shape_Column   := 'GEOLOC';
  End If;
  --
  l_Rec_Nth.Nth_Dependency               := 'I';
  l_Rec_Nth.Nth_Update_On_Edit           := 'N';
--
  If l_Rec_Nit.Nit_Use_Xy = 'Y' Then
    l_Rec_Nth.Nth_X_Column               := 'IIT_X';
    l_Rec_Nth.Nth_Y_Column               := 'IIT_Y';
  End If;
--
  l_Rec_Nth.Nth_Hpr_Product              := 'NET';
  l_Rec_Nth.Nth_Storage                  := 'S';
  l_Rec_Nth.Nth_Location_Updatable       := 'Y';
  l_Rec_Nth.Nth_Tolerance                := 10;
  l_Rec_Nth.Nth_Tol_Units                := 1;
  l_Rec_Nth.Nth_Snap_To_Theme            := 'N';
  l_Rec_Nth.Nth_Lref_Mandatory           := 'N';
  l_Rec_Nth.Nth_Theme_Type               := 'SDO';
-- 
  If L_Rec_Nit.Nit_Table_Name Is Null Then
    l_Rec_Nth.Nth_Use_History            := 'Y';
    l_Rec_Nth.Nth_Start_Date_Column      := Nvl(pi_S_Date_Col,'START_DATE');
    l_Rec_Nth.Nth_End_Date_Column        := Nvl(pi_E_Date_Col,'END_DATE');
  Else
    If    (pi_S_Date_Col Is Not Null
      And  pi_E_Date_Col Is Not Null) Then
      l_Rec_Nth.Nth_Use_History            := 'Y';
      l_Rec_Nth.Nth_Start_Date_Column      := pi_S_Date_Col;
      l_Rec_Nth.Nth_End_Date_Column        := pi_E_Date_Col;
    Else
      l_Rec_Nth.Nth_Use_History            := 'N';
      l_Rec_Nth.Nth_Start_Date_Column      := Null;
      l_Rec_Nth.Nth_End_Date_Column        := Null;
    End If;
  End If;
  -- Insert new theme
  Nm3Ins.Ins_Nth (L_Rec_Nth);
  -- Insert theme gtype
  l_Rec_Ntg.Ntg_Theme_Id                 := l_Rec_Nth.Nth_Theme_Id;
  l_Rec_Ntg.Ntg_Gtype                    := pi_Gtype;
  l_Rec_Ntg.Ntg_Seq_No                   := 1;
  Nm3Ins.Ins_Ntg (l_Rec_Ntg);
  --
  Return L_Rec_Nth;
  --
End Register_Ona_Base_Theme;
--
---------------------------------------------------------------------------------------------------
--
-- Task 0108731
--
Procedure Make_Ona_Inv_Spatial_Layer  (
                                      pi_Nit_Inv_Type   In  Nm_Inv_Types.Nit_Inv_Type%Type,
                                      pi_Nth_Gtype      In  Nm_Theme_Gtypes.Ntg_Gtype%Type    Default Null,
                                      pi_S_Date_Col     In  User_Tab_Columns.Column_Name%Type Default Null,
                                      pi_E_Date_Col     In  User_Tab_Columns.Column_Name%Type Default Null
                                      )
Is
Begin
  --
  Make_Ona_Inv_Spatial_Layer (
                             pi_Nit_Inv_Type => pi_Nit_Inv_Type,
                             pi_Nth_Theme_Id => Register_Ona_Base_Theme  (
                                                                         pi_Nit_Inv_Type,
                                                                         pi_Nth_Gtype,
                                                                         pi_S_Date_Col,
                                                                         pi_E_Date_Col).Nth_Theme_Id,
                             pi_Nth_Gtype    => pi_Nth_Gtype
                             );
 --
End Make_Ona_Inv_Spatial_Layer;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Procedure Create_Ona_Spatial_Idx  (
                                  p_Nit     In   Nm_Inv_Types.Nit_Inv_Type%Type,
                                  p_Table   In   Varchar2
                                  )
Is
--bug in oracle 8 - spatial index name can only be 18 chars
    Cur_String   Varchar2 (2000);
Begin
  Cur_String := 'create index ONA_'
               || P_Nit
               || '_spidx on '
               || P_Table
               || ' ( geoloc ) indextype is mdsys.spatial_index'
               || ' parameters ('
               || ''''
               || 'sdo_indx_dims=2'
               || ''''
               || ')';
  Execute Immediate Cur_String;
End Create_Ona_Spatial_Idx;
--
---------------------------------------------------------------------------------------------------
--
Procedure Make_Ona_Inv_Spatial_Layer  (
                                      pi_Nit_Inv_Type   In   Nm_Inv_Types.Nit_Inv_Type%Type,
                                      pi_Nth_Theme_Id   In   Nm_Themes_All.Nth_Theme_Id%Type Default Null,
                                      pi_Create_Flag    In   Varchar2 Default 'TRUE',
                                      pi_Nth_Gtype      In   Nm_Theme_Gtypes.Ntg_Gtype%Type Default Null
                                      )
 /*
Create a non-dynsegged SDO Spatial Layer for a given
pi_nit_inv_type   => Asset Type
pi_create_flag    => Create Asset SDO feature table
*/
Is
  l_Nit              Nm_Inv_Types%Rowtype;
  l_Rec_Nith         Nm_Inv_Themes%Rowtype;
  l_Rec_Nth          Nm_Themes_All%Rowtype;
  l_Tab              Varchar2 (30);
  b_Create_Tab       Boolean                   := Pi_Create_Flag = 'TRUE';
  l_Theme_Id         Nm_Themes_All.Nth_Theme_Id%Type;
  l_Theme_Name       Nm_Themes_All.Nth_Theme_Name%Type;
  l_Inv_Seq          Varchar2 (30);
  l_Dummy            Number;
  l_Base_Table_Nth   Nm_Themes_All.Nth_Theme_Id%Type;
  l_Rec_Nth_Base     Nm_Themes_All%Rowtype;
  l_Start_Date_Col   Varchar2 (30);
  l_End_Date_Col     Varchar2 (30);
  l_View             Varchar2 (30);
  l_Dt_View_Pk_Col   Varchar2 (30);
  l_Base_Themes      Nm_Theme_Array;
  Has_Network        Boolean;
  --
  Function Has_Nin Return Boolean
  Is
    l_Retval  Boolean;
    l_Dummy   Varchar2(10);
  Begin
    Begin
      Select  'exists' 
      Into    l_Dummy
      From    Nm_Inv_Nw
      Where   Nin_Nit_Inv_Code = Pi_Nit_Inv_Type
      And     Rownum = 1;
        
      l_Retval:=True;
        
    Exception
      When No_Data_Found Then
      l_Retval:=False;
    End;
    Return(l_Retval);
  End Has_Nin;
  --
  Procedure Create_Objectid_Trigger   (
                                      p_Table_Name   In   Nm_Themes_All.Nth_Feature_Table%Type,
                                      p_Theme_Id     In   Nm_Themes_All.Nth_Theme_Id%Type
                                      )
  Is
    l_Temp          Varchar2 (1);
    l_Trigger_Name  Constant User_Triggers.Trigger_Name%Type  := p_Table_Name|| '_BI_TRG'  ;
  --
  Begin
    Begin
      Select  Null
      Into    l_Temp
      From    User_Tab_Cols   utc
      Where   utc.Table_Name    =   p_Table_Name
      And     utc.Column_Name   =   'OBJECTID';

      Execute Immediate
      'Create Or Replace Trigger '|| l_Trigger_Name                   || Chr (10) ||
      'Before Insert On '|| p_Table_Name                              || Chr (10) ||
      'For Each Row '                                                 || Chr (10) ||
      'Begin'                                                         || Chr (10) ||  
      '  --Created By :nm3sdm.Create_Objectid_Trigger '               || Chr (10) ||
      '  --Created On :' || To_Char(Sysdate,'dd-mm-yyyy hh24:mi.ss')  || Chr (10) ||
      '  --Version    :' || g_Body_Sccsid                             || Chr (10) ||
      '  Select   NTH_'|| p_Theme_Id|| '_SEQ.Nextval '                || Chr (10) ||
      '  Into     :NEW.Objectid'                                      || Chr (10) ||
      '  From     Dual;'                                              || Chr (10) ||
      'End ' || l_Trigger_Name || ';';
        
    Exception
      When No_Data_Found Then
        Null;
    End;

  End Create_Objectid_Trigger; 
    --
  Procedure Populate_Xy_Sdo_Data  (
                                  p_Asset_Type In Nm_Inv_Types.Nit_Inv_Type%Type 
                                  )
  Is
  Begin
    -- Task 0108731
    -- Populate the XY data using the Asset type rather than 
    -- row by row
    Nm3Sdo_Edit.Process_Inv_Xy_Update(pi_Inv_Type=>p_Asset_Type);
  End Populate_Xy_Sdo_Data;
    --
  Procedure Populate_Nm_Base_Themes (
                                    p_Nth_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                                    )
  Is
  Begin
    For i In 1..l_Base_Themes.Nta_Theme_Array.Last
    Loop
      Insert Into Nm_Base_Themes
      (
      Nbth_Theme_Id,
      Nbth_Base_Theme
      )
      Values
      (
      p_Nth_Theme_Id,
      l_Base_Themes.Nta_Theme_Array(i).Nthe_Id
      );
    End Loop;
  End Populate_Nm_Base_Themes;
  --
  --
   
Begin
  -- AE check to make sure user is unrestricted
  If Not User_Is_Unrestricted Then
    Raise E_Not_Unrestricted;
  End If;
  --
  Nm_Debug.Proc_Start (G_Package_Name, 'make_ona_inv_spatial_layer');
  --
  l_Rec_Nth := Nm3Get.Get_Nth (Pi_Nth_Theme_Id => Pi_Nth_Theme_Id);
  --
  -- Task 0108890 - GIS0020 - Error when creating ONA layer
  -- Ensure the Asset views are in place
  -- RAC - correction to the task - off network assets need the asset view and not the one linking the asset to the NW.
  -- RAC - further correction - don't create an asste view when a FT asset
  ---------------------------------------------------------------
  -- Validate asset type
  ---------------------------------------------------------------
  l_Nit := Nm3Get.Get_Nit (pi_Nit_Inv_Type => pi_Nit_Inv_Type);

  If l_Nit.Nit_Table_Name  is null 
  Then
    Declare
      View_Name User_Views.View_Name%Type;
    Begin
      Nm3Inv_View.Create_Inv_View(Pi_Nit_Inv_Type,FALSE,View_Name);
    End;
  End If;
  --
  --  Nm_Debug.debug_on;
  ---------------------------------------------------------------
  -- Set has network associated flag
  ---------------------------------------------------------------
  Has_Network := Has_Nin;
      
  If Has_Network  Then
    l_Base_Themes := Get_Inv_Base_Themes ( Pi_Nit_Inv_Type );
  End If;
  ---------------------------------------------------------------
  -- Derive SDO table name
  ---------------------------------------------------------------
  If B_Create_Tab Then
    --  Nm_Debug.DEBUG ('create table for ' || l_nit.nit_inv_type);
    l_Tab := Get_Ona_Spatial_Table (l_Nit.Nit_Inv_Type);

    --
    If     l_Rec_Nth.Nth_Use_History        =   'Y'
      And l_Rec_Nth.Nth_Start_Date_Column   Is  Not Null
      And l_Rec_Nth.Nth_End_Date_Column     Is  Not Null  Then
        
      l_Start_Date_Col  := l_Rec_Nth.Nth_Start_Date_Column;
      l_End_Date_Col    := l_Rec_Nth.Nth_End_Date_Column;
        
    End If;

    --
    -- mp flag set
    Create_Spatial_Table (L_Tab, True, l_Start_Date_Col, l_End_Date_Col);

    -- if gtype is provided, then use it to register SDO metadata
    -- TOLERANCE???
     If Pi_Nth_Gtype Is Not Null  Then
      l_Dummy :=  Nm3Sdo.Create_Sdo_Layer (
                                          Pi_Table_Name       => l_Tab,
                                          Pi_Column_Name      => 'GEOLOC',
                                          Pi_Gtype            => Pi_Nth_Gtype
                                          );
     End If;

    ---------------------------------------------------------------
    -- Table needs a spatial index
    ---------------------------------------------------------------
    Create_Ona_Spatial_Idx (Pi_Nit_Inv_Type, L_Tab);
    -- Table already exists - check to see if it's registered
  Else
    If Pi_Nth_Theme_Id Is Not Null And Pi_Nth_Gtype Is Not Null Then
      If Not Nm3Sdo.Is_Table_Regd
                       (P_Feature_Table      => L_Rec_Nth.Nth_Feature_Table,
                        P_Col                => L_Rec_Nth.Nth_Feature_Shape_Column
                       )  Then
          
        l_Dummy :=  Nm3Sdo.Create_Sdo_Layer (
                                            Pi_Table_Name       => l_Rec_Nth.Nth_Feature_Table,
                                            Pi_Column_Name      => l_Rec_Nth.Nth_Feature_Shape_Column,
                                            Pi_Gtype            => Pi_Nth_Gtype
                                            );
      End If;
    End If;
  End If;

  --
  If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then
      
    Begin
      Execute Immediate (   'begin '
                        || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( Pi_Nth_Theme_Id )||');'
                        || 'end;'
                        );
    Exception
      When Others Then
        Null;
    End;
  End If;
  --
  ---------------------------------------------------------------
  -- Populate base themes for current theme
  ---------------------------------------------------------------
  If Has_Network  Then
    Populate_Nm_Base_Themes( p_Nth_Theme_Id => Pi_Nth_Theme_Id);
  End If;
  --
  If Pi_Nth_Theme_Id Is Null  Then
    ---------------------------------------------------------------
    -- Derive theme name
    ---------------------------------------------------------------
    l_Theme_Name := Nvl (l_Nit.Nit_Short_Descr,Substr (l_Nit.Nit_Inv_Type || '-' || L_Nit.Nit_Descr,1,30)|| '_TAB');
    ---------------------------------------------------------------
    -- Create the theme for table
    -- ( NM_NIT_<ASSET_TYPE>_SDO )
    ---------------------------------------------------------------
    l_Theme_Id := Register_Ona_Theme  (
                                      l_Nit,
                                      l_Tab,
                                      'GEOLOC',
                                      Null,
                                      Substr (l_Theme_Name, 1, 26) || '_TAB'
                                      );

    Begin
      If Nm3Sdo.Use_Surrogate_Key = 'Y' Then

        l_Inv_Seq := Nm3Sdo.Create_Spatial_Seq (Pi_Nth_Theme_Id);
        Create_Objectid_Trigger (
                                p_Table_Name      => l_Tab,
                                p_Theme_Id        => pi_Nth_Theme_Id
                                );
      End If;
    Exception
      When Others Then

        Hig.Raise_Ner (
                      pi_Appl               =>  Nm3Type.C_Hig,
                      pi_Id                 =>  273,
                      pi_Sqlcode            =>  -20001,
                      pi_Supplementary_Info =>  'NTH_'||To_Char(L_Theme_Id)||'_SEQ'
                      );
    End;
    Else
      -- Just link the theme to the inv type
      l_Rec_Nith.Nith_Nit_Id        := l_Nit.Nit_Inv_Type;
      l_Rec_Nith.Nith_Nth_Theme_Id  := pi_Nth_Theme_Id;
      Nm3Ins.Ins_Nith (L_Rec_Nith);

      ---------------------------------------------------------------
      -- Create surrogate key sequence if needed
      ---------------------------------------------------------------
      Begin
        If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
            
          l_Inv_Seq := Nm3Sdo.Create_Spatial_Seq (pi_Nth_Theme_Id);
          Create_Objectid_Trigger (
                                  p_Table_Name      => l_Tab,
                                  p_Theme_Id        => pi_Nth_Theme_Id
                                  );
        End If;
      Exception
        When Others Then
          Hig.Raise_Ner (
                        pi_Appl         => Nm3Type.C_Hig,
                        pi_Id           => 273,
                        pi_Sqlcode      => -20001
                        );
      End;
  End If;

  --
  If     l_Rec_Nth.Nth_Use_History        =   'Y'
     And l_Rec_Nth.Nth_Start_Date_Column  Is  Not Null
     And l_Rec_Nth.Nth_End_Date_Column    Is  Not Null  Then
       
    ---------------------------------------------------------------
    -- Create spatial date view
    ---------------------------------------------------------------
    Create_Spatial_Date_View  (
                              l_Rec_Nth.Nth_Feature_Table,
                              l_Rec_Nth.Nth_Start_Date_Column,
                              l_Rec_Nth.Nth_End_Date_Column
                              );
    ---------------------------------------------------------------
    -- Get rowtype of the base theme
    ---------------------------------------------------------------
    l_Rec_Nth_Base := Nm3Get.Get_Nth (pi_Nth_Theme_Id      => pi_Nth_Theme_Id);
    ---------------------------------------------------------------
    -- Create theme for View
    -- ( V_NM_ONA_<ASSET_TYPE>_SDO )
    ---------------------------------------------------------------
    l_Theme_Id := Register_Ona_Theme  (
                                      pi_Nit                =>  l_Nit,
                                      p_Table_Name          =>  'V_'||L_Rec_Nth_Base.Nth_Feature_Table,
                                      p_Spatial_Column      =>  l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                                      p_Fk_Column           =>  l_Rec_Nth_Base.Nth_Feature_Pk_Column,
                                      p_View_Flag           =>  'Y',
                                      p_Pk_Column           =>  l_Rec_Nth_Base.Nth_Feature_Pk_Column,
                                      p_Base_Table_Nth      =>  l_Rec_Nth_Base.Nth_Theme_Id
                                      );

    If Not Nm3Sdo.Is_Table_Regd (
                                p_Feature_Table      =>   'V_'|| L_Rec_Nth_Base.Nth_Feature_Table,
                                p_Col                =>   l_Rec_Nth_Base.Nth_Feature_Shape_Column
                                ) Then
      l_Dummy :=  Nm3Sdo.Create_Sdo_Layer (
                                          pi_Table_Name       =>  'V_'|| L_Rec_Nth_Base.Nth_Feature_Table,
                                          pi_Column_Name      =>  l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                                          pi_Gtype            =>  pi_Nth_Gtype
                                          );
    End If;

    --
    If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then
      Begin
        Execute Immediate (   ' begin  '
                      || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( L_Theme_Id )||')'
                      || '; end;'
                     );
      Exception
         When Others
         Then Null;
      End;
    End If;
    --
  End If;

  ---------------------------------------------------------------
  -- Populate base themes for current theme
  ---------------------------------------------------------------

  If      g_Date_Views                    =   'Y'
      And l_Rec_Nth.Nth_Use_History       =   'Y'
      And l_Rec_Nth.Nth_Start_Date_Column Is  Not Null
      And l_Rec_Nth.Nth_End_Date_Column   Is  Not Null  Then
        
      ---------------------------------------------------------------
      -- Create _DT view for attributes for Asset type
      ---------------------------------------------------------------

    l_View := Create_Inv_Sdo_Join_View  ( 
                                        p_Feature_Table_Name => l_Rec_Nth_Base.Nth_Feature_Table
                                        );
    If L_Nit.Nit_Table_Name Is Null Then
      l_Dt_View_Pk_Col := 'IIT_NE_ID';
    Else
      l_Dt_View_Pk_Col := l_Rec_Nth_Base.Nth_Feature_Pk_Column;
    End If;

    l_Theme_Id := Register_Ona_Theme  (
                                      pi_Nit             => l_Nit,
                                      p_Table_Name       => l_View,
                                      p_Spatial_Column   => l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                                      p_Fk_Column        => l_Rec_Nth_Base.Nth_Feature_Fk_Column,
                                      p_Name             => Rtrim(L_Rec_Nth_Base.Nth_Theme_Name,'_TAB')||'_DT',
                                      p_View_Flag        => 'Y',
                                      p_Pk_Column        => l_Dt_View_Pk_Col,
                                      p_Base_Table_Nth   => l_Rec_Nth_Base.Nth_Theme_Id
                                      ) ;

    If Not Nm3Sdo.Is_Table_Regd (
                                p_Feature_Table => l_View,
                                p_Col           => l_Rec_Nth_Base.Nth_Feature_Shape_Column
                                ) Then
      l_Dummy :=  Nm3Sdo.Create_Sdo_Layer (
                                          pi_Table_Name       =>  l_View,
                                          pi_Column_Name      =>  l_Rec_Nth_Base.Nth_Feature_Shape_Column,
                                          pi_Gtype            =>  pi_Nth_Gtype
                                          );
    End If;

    --
    If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then

      Begin
        Execute Immediate (   ' begin  '
                          || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( L_Theme_Id )||');'
                          || ' end;'
                          );
      Exception
        When Others  Then
          Null;
      End;
    End If;
    ---------------------------------------------------------------
    -- Populate base themes for current theme
    ---------------------------------------------------------------
    If Has_Network  Then
      Populate_Nm_Base_Themes( p_Nth_Theme_Id => l_Theme_Id);
    End If;
    --
  End If;
  --
  ---------------------------------------------------------------
  -- Populate Layer table (if any data availible)
  ---------------------------------------------------------------
  If l_Nit.Nit_Use_Xy = 'Y' Then
    -- Task 0108731
    -- Populate the XY data using the Asset type rather than 
    -- row by row
    Populate_Xy_Sdo_Data ( p_Asset_Type => l_Nit.Nit_Inv_Type );
  End If;
  ---------------------------------------------------------------
  -- Analyze spatial table
  ---------------------------------------------------------------
  Begin
    Nm3Ddl.Analyse_Table  (
                          pi_Table_Name          =>   l_Rec_Nth.Nth_Feature_Table,
                          pi_Schema              =>   Sys_Context('NM3CORE','APPLICATION_OWNER'),
                          pi_Estimate_Percentage =>   Null,
                          pi_Auto_Sample_Size    =>   False
                          );
  Exception
    When Others Then
      Raise E_No_Analyse_Privs;
  End;
  --
  Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
  --
Exception
  When E_Not_Unrestricted Then
    Raise_Application_Error (-20777,'Restricted users are not permitted to create SDO layers');
  When E_No_Analyse_Privs Then
    Raise_Application_Error (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                    'Please ensure the correct role/privs are applied to the user');
  --
End Make_Ona_Inv_Spatial_Layer;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Procedure Create_Inv_Spatial_Idx  (
                                  p_Nit     In   Nm_Inv_Types.Nit_Inv_Type%Type,
                                  p_Table   In   Varchar2
                                  )
Is
  --bug in oracle 8 - spatial index name can only be 18 chars
  Cur_String   Varchar2 (2000);
Begin
  Cur_String := 'create index NIT_'
             || p_Nit
             || '_spidx on '
             || p_Table
             || ' ( geoloc ) indextype is mdsys.spatial_index'
             || ' parameters ('
             || ''''
             || 'sdo_indx_dims=2'
             || ''''
             || ')';
  Execute Immediate Cur_String;
End Create_Inv_Spatial_Idx;
--
---------------------------------------------------------------------------------------------------
--

--  Create a dynsegged SDO Spatial layer for a given
--  pi_nit_inv_type  => Asset type
--  pi_create_flag   => Create Asset SDO feature table flag
--  pi_base_layer    => Layer to dynseg to
 
Procedure Make_Inv_Spatial_Layer  (
                                  pi_Nit_Inv_Type   In   Nm_Inv_Types.Nit_Inv_Type%Type,
                                  pi_Create_Flag    In   Varchar2 Default 'TRUE',
                                  p_Job_Id          In   Number Default Null
                                  )
Is
  l_Nit                Nm_Inv_Types%Rowtype;
  lcur                 Nm3Type.Ref_Cursor;
  l_Base               Nm_Themes_All.Nth_Theme_Id%Type;
  l_Tab                Varchar2 (30);
  l_Base_Table         Varchar2 (30);
  l_View               Varchar2 (30);
  l_Inv_Seq            Varchar2 (30);
  l_Base_Table_Theme   Nm_Themes_All.Nth_Theme_Id%Type;
  l_Geom               Mdsys.Sdo_Geometry;
  l_Ne                 Nm_Elements.Ne_Id%Type;
  l_Theme_Id           Nm_Themes_All.Nth_Theme_Id%Type;
  l_Base_Themes        Nm_Theme_Array;
  l_Theme_Name         Nm_Themes_All.Nth_Theme_Name%Type;
  l_Diminfo            Mdsys.Sdo_Dim_Array;
  l_Srid               Number;
  l_Usgm               User_Sdo_Geom_Metadata%Rowtype;
  l_Themes             Int_Array := Nm3Array.Init_Int_Array;
  l_Inv_View_Name      Varchar2(30);

Begin
  -- AE check to make sure user is unrestricted
  If Not User_Is_Unrestricted  Then
    Raise E_Not_Unrestricted;
  End If;
  ---------------------------------------------------------------
  -- Validate asset type
  ---------------------------------------------------------------
  l_Nit := Nm3Get.Get_Nit (pi_Nit_Inv_Type => pi_Nit_Inv_Type);
  ---------------------------------------------------------------
  -- Derive SDO table name
  ---------------------------------------------------------------
  l_Tab := Get_Inv_Spatial_Table (l_Nit.Nit_Inv_Type);

  ---------------------------------------------------------------
  -- Derive base layers to dynseg and Validate base layer
  ---------------------------------------------------------------

  l_Base_Themes := Get_Inv_Base_Themes( pi_Nit_Inv_Type );

  Nm3Sdo.Set_Diminfo_And_Srid( l_Base_Themes, l_Diminfo, l_Srid );

  If l_Nit.Nit_Pnt_Or_Cont = 'P' Then

    l_Diminfo := Sdo_Lrs.Convert_To_Std_Dim_Array(l_Diminfo);

  End If;
--RAC - only create inv views for FT asset type
  If l_Nit.Nit_Table_Name is NULL and Not Nm3Ddl.Does_Object_Exist( Nm3Inv_View.Derive_Inv_Type_View_Name(Pi_Nit_Inv_Type)
                                 , 'VIEW'
                                 , Sys_Context('NM3CORE','APPLICATION_OWNER') ) Then
    Nm3Inv_View.Create_Inv_View(Pi_Nit_Inv_Type, False, L_Inv_View_Name);
  End If;

  ---------------------------------------------------------------
  -- Create the table and history view
  ---------------------------------------------------------------
  If pi_Create_Flag = 'TRUE'  Then
    If l_Nit.Nit_Table_Name Is Not Null Then
      Create_Spatial_Table (l_Tab, False, 'START_DATE', 'END_DATE');
    Else
      Create_Spatial_Table (l_Tab, False, 'START_DATE', 'END_DATE');
    End If;
  End If;

  ---------------------------------------------------------------
  -- Create spatial date view
  ---------------------------------------------------------------
  Create_Spatial_Date_View (l_Tab);
  ---------------------------------------------------------------
  -- Derive theme name
  ---------------------------------------------------------------
  l_Theme_Name := Nvl (l_Nit.Nit_Short_Descr,Substr (l_Nit.Nit_Inv_Type || '-' || l_Nit.Nit_Descr, 1, 30));

  ---------------------------------------------------------------
  -- Set the registration of metadata
  ---------------------------------------------------------------
  l_Usgm.Table_Name  :=   l_Tab;
  l_Usgm.Column_Name :=   'GEOLOC';
  l_Usgm.Diminfo     :=   l_Diminfo;
  l_Usgm.Srid        :=   l_Srid;

  Nm3Sdo.Ins_Usgm ( l_Usgm );
  ---------------------------------------------------------------
  -- Create the theme for table
  -- ( NM_NIT_<ASSET_TYPE>_SDO )
  ---------------------------------------------------------------
  l_Theme_Id := Register_Inv_Theme  (
                                    pi_Nit                =>  l_Nit,
                                    p_Base_Themes         =>  l_Base_Themes,
                                    p_Table_Name          =>  l_Tab,
                                    p_Spatial_Column      =>  'GEOLOC',
                                    p_Fk_Column           =>  'NE_ID',
                                    p_Name                =>  Substr (l_Theme_Name,1,26)|| '_TAB'
                                    );
  l_Base_Table_Theme := l_Theme_Id;
    
  l_Themes.Ia(1) := l_Theme_Id;

  ---------------------------------------------------------------
  -- Create surrogate key sequence if needed
  ---------------------------------------------------------------
  If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
    l_Inv_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);
  End If;

  ---------------------------------------------------------------
  -- Create theme for View
  -- ( V_NM_NIT_<ASSET_TYPE>_SDO )
  ---------------------------------------------------------------
  l_Theme_Id := Nm3Sdo.Clone_Layer (l_Base_Table_Theme, 'V_' || l_Tab, 'GEOLOC');

  l_Theme_Id := Register_Inv_Theme  (
                                    pi_Nit                =>  l_Nit,
                                    p_Base_Themes         =>  l_Base_Themes,
                                    p_Table_Name          =>  'V_' || l_Tab,
                                    p_Spatial_Column      =>  'GEOLOC',
                                    p_Fk_Column           =>  'NE_ID',
                                    p_Name                =>  l_Theme_Name,
                                    p_View_Flag           =>  'Y',
                                    p_Base_Table_Nth      =>  l_Base_Table_Theme
                                    );

  l_Themes := l_Themes.Add_Element( l_Theme_Id );

  ---------------------------------------------------------------
  -- Need a join view between spatial table history view and Inv view
  ---------------------------------------------------------------
  l_View := Create_Inv_Sdo_Join_View (l_Tab);

  ---------------------------------------------------------------
  -- Create SDO metadata for the attribute joined view
  --  ( V_NM_NIT_<ASSET_TYPE>_SDO_DT )
  ---------------------------------------------------------------
  l_Theme_Id := Nm3Sdo.Clone_Layer (l_Base_Table_Theme, l_View, 'GEOLOC');
  ---------------------------------------------------------------
  -- For now, register both the join view and the base layer
  ---------------------------------------------------------------
  l_Theme_Name := Substr (Nvl (l_Nit.Nit_Short_Descr,l_Nit.Nit_Inv_Type || '-' || L_Nit.Nit_Descr),1,27)|| '_DT';

  ---------------------------------------------------------------
  -- Make the view layer dependent on the parent asset shape
  ---------------------------------------------------------------
  If g_Date_Views = 'Y' Then

    l_Theme_Id := Register_Inv_Theme  (
                                      pi_Nit                =>  l_Nit,
                                      p_Base_Themes         =>  l_Base_Themes,
                                      p_Table_Name          =>  l_View,
                                      p_Spatial_Column      =>  'GEOLOC',
                                      p_Fk_Column           =>  'IIT_NE_ID',
                                      p_Name                =>  l_Theme_Name,
                                      p_View_Flag           =>  'Y',
                                      p_Pk_Column           =>  'IIT_NE_ID',
                                      p_Base_Table_Nth      =>  l_Base_Table_Theme
                                      );

    l_Themes := l_Themes.Add_Element( l_Theme_Id );
                 
  End If;
  ---------------------------------------------------------------
  -- Populate the SDO table and create (clone) the SDO metadata
  -- for table and date tracked view
  --   (   NM_NIT_<ASSET_TYPE>_SDO )
  --   ( V_NM_NIT_<ASSET_TYPE>_SDO )
  ---------------------------------------------------------------

  If pi_Create_Flag = 'TRUE'  Then
    Nm3Sdo.Create_Inv_Data  (
                            p_Table_Name      =>  l_Tab,
                            p_Inv_Type        =>  pi_Nit_Inv_Type,
                            p_Seq_Name        =>  l_Inv_Seq,
                            p_Pnt_Or_Cont     =>  l_Nit.Nit_Pnt_Or_Cont,
                            p_Job_Id          =>  p_Job_Id
                            );
  End If;
  ---------------------------------------------------------------
  -- Table needs a spatial index
  ---------------------------------------------------------------
  Create_Inv_Spatial_Idx (pi_Nit_Inv_Type, l_Tab);
  ---------------------------------------------------------------
  -- Analyze spatial table
  ---------------------------------------------------------------

  Begin
    Nm3Ddl.Analyse_Table  (
                          pi_Table_Name          => l_Tab,
                          pi_Schema              => Sys_Context('NM3CORE','APPLICATION_OWNER'),
                          pi_Estimate_Percentage => Null,
                          pi_Auto_Sample_Size    => False
                          );
  Exception
    When Others Then
      Raise E_No_Analyse_Privs;
  End;
  --
  Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
  --
  Exception
    When E_Not_Unrestricted Then
      Raise_Application_Error (-20777,'Restricted users are not permitted to create SDO layers');
    When E_No_Analyse_Privs Then
      Raise_Application_Error (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                      'Please ensure the correct role/privs are applied to the user');

  End Make_Inv_Spatial_Layer;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Datum_Layer_From_Gty (
                                  p_Gty   In   Nm_Linear_Types.Nlt_Gty_Type%Type
                                  ) Return Nm_Theme_Array
Is
  Retval   Nm_Theme_Array := Nm3Array.Init_Nm_Theme_Array;

Begin
  Select  Nm_Theme_Entry(Nnth_Nth_Theme_Id)
  Bulk Collect Into Retval.Nta_Theme_Array
  From    Nm_Nw_Themes Nnt,
          Nm_Linear_Types Nlt,
          Nm_Nt_Groupings_All Nng
  Where   Nlt.Nlt_Id          =   Nnt.Nnth_Nlt_Id
  And     Nlt.Nlt_Nt_Type     =   Nng.Nng_Nt_Type
  And     Nng.Nng_Group_Type  =   p_Gty;

  If Retval.Nta_Theme_Array(1).Nthe_Id Is Null Then
     Hig.Raise_Ner (Pi_Appl         => Nm3Type.C_Hig,
                    Pi_Id           => 195,
                    Pi_Sqlcode      => -20001
                   );
  End If;

  Return Retval;
End Get_Datum_Layer_From_Gty;
--
---------------------------------------------------------------------------------------------------
--
Procedure Make_Datum_Layer_Dt (
                              pi_Nth_Theme_Id       In Nm_Themes_All.Nth_Theme_Id%Type,
                              pi_New_Feature_Table  In Nm_Themes_All.Nth_Feature_Table%Type Default Null
                              )
Is
  ---------------------------------------------------------------------------
  -- This procedure is designed to create a date tracked view of a given Datum
  --SDO layer.
  --It creates the view, metadata, theme. Renames base table to _TABLE.
  --This is required so that MSV can display current shapes, as it is unable
  --to perform a join back to nm_elements
  ---------------------------------------------------------------------------
  --
  e_Not_Datum_Layer       Exception;
  e_New_Ft_Exists         Exception;
  e_Already_Base_Theme    Exception;
  e_Used_As_Base_Theme    Exception;
  --
  lf                      Varchar2(5) := Chr(10);
  l_New_Table_Name        Nm_Themes_All.Nth_Feature_Table%Type;
  l_View_Sql              Nm3Type.Max_Varchar2;
  l_Rec_Nth               Nm_Themes_All%Rowtype;
  l_Rec_New_Nth           Nm_Themes_All%Rowtype;
  l_Rec_Nthr              Nm_Theme_Roles%Rowtype;
  --
  Function Is_Datum_Layer (
                          pi_Nth_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                          ) Return Boolean
  Is
    l_Dummy   Pls_Integer;
    l_Retval  Boolean:=True;
  Begin
    Begin
      --
      Select  nta.Nth_Theme_Id
      Into    l_Dummy
      From    Nm_Themes_All   nta
      Where   Exists    (
                        Select  Null
                        From    Nm_Nw_Themes  nnt
                        Where   nta.Nth_Theme_Id  =   nnt.Nnth_Nth_Theme_Id
                        And     Exists            (   Select  Null
                                                      From    Nm_Linear_Types
                                                      Where   Nlt_Id    = Nnth_Nlt_Id
                                                      And     Nlt_G_I_D = 'D'
                                                  )
                        )
      And     Nth_Theme_Id = pi_Nth_Theme_Id;
      --
      Exception
        When No_Data_Found  Then
          l_Retval:=False;
      End;
      Return(l_Retval);        
    End Is_Datum_Layer;
  --
  Function Used_As_A_Base_Theme (
                                pi_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                                ) Return Boolean
  Is
    l_Dummy   Varchar2(1);
    l_Retval  Boolean:=True;
  Begin
    Begin
      Select  Null
      Into    l_Dummy
      From    Nm_Themes_All
      Where   Nth_Base_Table_Theme  =   pi_Theme_Id;    
    Exception
      When No_Data_Found  Then
        l_Retval := False;
    End;
    Return(l_Retval);        
  End Used_As_A_Base_Theme;
  --
Begin
  ---------------------------------------------------------------------------
  -- Check to make sure user is unrestricted
  ---------------------------------------------------------------------------
  If Not User_Is_Unrestricted Then
    Raise e_Not_Unrestricted;
  End If;
  ---------------------------------------------------------------------------
  -- Make sure theme passed in is a datum layer
  ---------------------------------------------------------------------------
  l_Rec_Nth := Nm3Get.Get_Nth ( pi_Nth_Theme_Id => pi_Nth_Theme_Id );

  If Not Is_Datum_Layer ( pi_Nth_Theme_Id ) Then
    Raise e_Not_Datum_Layer;
  End If;
  ---------------------------------------------------------------------------
  -- Check to make sure the Theme passed in a view based theme!
  ---------------------------------------------------------------------------
  If l_Rec_Nth.Nth_Base_Table_Theme Is Not Null Then
    Raise e_Already_Base_Theme;
  End If;

  If Used_As_A_Base_Theme ( pi_Nth_Theme_Id ) Then
    Raise e_Used_As_Base_Theme;
  End If;
  --
  ---------------------------------------------------------------------------
  -- Rename datum table
  ---------------------------------------------------------------------------
  l_New_Table_Name := Nvl( pi_New_Feature_Table, Upper(l_Rec_Nth.Nth_Feature_Table)||'_TABLE');

  If Nm3Ddl.Does_Object_Exist (l_New_Table_Name)  Then
    Raise e_New_Ft_Exists;
  End If;

  Execute Immediate 'RENAME '||l_Rec_Nth.Nth_Feature_Table||' TO '||l_New_Table_Name;
  ---------------------------------------------------------------------------
  --Create SDO metadata for renamed feature table
  ---------------------------------------------------------------------------
  Execute Immediate
    'INSERT INTO user_sdo_geom_metadata'                                      ||Lf||
    ' (SELECT '||Nm3Flx.String(l_New_Table_Name)                              ||Lf||
    '       , column_name, diminfo, srid '                                    ||Lf||
    '    FROM user_sdo_geom_metadata '                                        ||Lf||
    '   WHERE table_name  = '||Nm3Flx.String(l_Rec_Nth.Nth_Feature_Table)     ||Lf||
    '     AND column_name = '||Nm3Flx.String(l_Rec_Nth.Nth_Feature_Shape_Column)||')';

  ---------------------------------------------------------------------------
  -- Create date based view
  ---------------------------------------------------------------------------
  l_View_Sql :=
    'CREATE OR REPLACE FORCE VIEW '||l_Rec_Nth.Nth_Feature_Table              ||Lf||
    'AS'                                                                      ||Lf||
    'SELECT sdo.*'                                                            ||Lf||
    '  FROM '||l_New_Table_Name||' sdo '                                      ||Lf||
    ' WHERE EXISTS ( SELECT 1 FROM nm_elements ne '                           ||Lf||
                    ' WHERE ne.ne_id = sdo.'||l_Rec_Nth.Nth_Feature_Pk_Column||')';

  Execute Immediate L_View_Sql;

  ---------------------------------------------------------------------------
  -- Create new theme - but to maintain foreign keys, we need to update the old one
  -- so that it points to the new feature table using base theme
  ---------------------------------------------------------------------------

  l_Rec_New_Nth                    := l_Rec_Nth;
  l_Rec_New_Nth.Nth_Theme_Id       := Nm3Seq.Next_Nth_Theme_Id_Seq;
  l_Rec_New_Nth.Nth_Theme_Name     := l_Rec_New_Nth.Nth_Theme_Name||'_TAB';
  l_Rec_New_Nth.Nth_Feature_Table  := l_New_Table_Name;

  Nm3Ins.Ins_Nth(l_Rec_New_Nth);

  Insert Into Nm_Nw_Themes
  (
  Nnth_Nlt_Id,
  Nnth_Nth_Theme_Id
  )
  Select  Nnth_Nlt_Id,
          l_Rec_New_Nth.Nth_Theme_Id
  From    Nm_Nw_Themes
  Where   Nnth_Nth_Theme_Id = l_Rec_Nth.Nth_Theme_Id;

  ---------------------------------------------------------------------------
  -- Update (now the) view theme to point to new table
  ---------------------------------------------------------------------------
  Begin
    Update  Nm_Themes_All
       Set  Nth_Base_Table_Theme  =   l_Rec_New_Nth.Nth_Theme_Id
     Where  Nth_Theme_Id          =   pi_Nth_Theme_Id;
  End;

  ---------------------------------------------------------------------------
  --  Update the NM_BASE_THEME record to point at the base table theme
  --  where the base theme is incorrectly set to a view based theme
  ---------------------------------------------------------------------------
  Update Nm_Base_Themes
  Set   Nbth_Base_Theme =   (
                            Select Nth_Base_Table_Theme
                            From Nm_Themes_All
                            Where Nth_Theme_Id  = Nbth_Base_Theme
                            )
  Where Exists          (   Select  1
                            From    Nm_Themes_All
                            Where   Nth_Theme_Id          = Nbth_Base_Theme
                            And     Nth_Base_Table_Theme Is Not Null
                        );
  ---------------------------------------------------------------------------
  -- Create SDE layer if needed
  ---------------------------------------------------------------------------
  If Hig.Get_User_Or_Sys_Opt('REGSDELAY') = 'Y' Then
    Execute Immediate (   ' begin  '
                      || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( l_Rec_New_Nth.Nth_Theme_Id )||')'
                      || '; end;'
                      );
  End If;
  ---------------------------------------------------------------------------
  -- Touch the nm_theme_roles to action creation of subuser views + metadata
  ---------------------------------------------------------------------------
  Update  Nm_Theme_Roles
  Set     Nthr_Role     = Nthr_Role
  Where   Nthr_Theme_Id = pi_Nth_Theme_Id;

  --
Exception
  When E_Not_Datum_Layer  Then
    Hig.Raise_Ner (
                  pi_Appl               =>  Nm3Type.C_Hig,
                  pi_Id                 =>  274,
                  pi_Sqlcode            =>  -20001,
                  pi_Supplementary_Info =>  l_Rec_Nth.Nth_Theme_Name
                  );

  When E_New_Ft_Exists  Then
    Hig.Raise_Ner (
                  pi_Appl               =>  Nm3Type.C_Hig,
                  pi_Id                 =>  275,
                  pi_Sqlcode            =>  -20001,
                  pi_Supplementary_Info =>  l_New_Table_Name
                  );

  When E_Already_Base_Theme Then
    Raise_Application_Error(-20101 ,l_Rec_Nth.Nth_Theme_Name||' is not a base table theme');

  When E_Used_As_Base_Theme Then
    Raise_Application_Error(-20102 ,pi_Nth_Theme_Id||' is already setup as a base table theme');

  When Others Then

    Begin
      Execute Immediate 'RENAME '||l_New_Table_Name||' to '||l_Rec_Nth.Nth_Feature_Table;
    Exception
      When Others Then Null;
    End;
    --
    Begin
      Execute Immediate 'DROP VIEW '||l_Rec_Nth.Nth_Feature_Table;
    Exception
      When Others Then Null;
    End;
    --
    Begin
      Delete 
      From    User_Sdo_Geom_Metadata
      Where   Table_Name  = l_New_Table_Name
      And     Column_Name = l_Rec_Nth.Nth_Feature_Shape_Column;
    Exception
      When Others Then Null;
    End;
    --
    Raise;
--
End Make_Datum_Layer_Dt;
--
---------------------------------------------------------------------------------------------------
--
Procedure Make_All_Datum_Layers_Dt
Is
Begin
  For i In  (
            Select  *
            From    Nm_Themes_All nta
            Where   Exists      (
                                Select  Null
                                From    Nm_Nw_Themes  nnt
                                Where   nta.Nth_Theme_Id  =   nnt.Nnth_Nth_Theme_Id
                                And     Exists          (   Select  Null
                                                            From    Nm_Linear_Types nlt
                                                            Where   nlt.Nlt_Id    =   nnt.Nnth_Nlt_Id
                                                            And     nlt.Nlt_G_I_D =   'D'
                                                        )
                                )
            And     nta.Nth_Base_Table_Theme Is Null
            -- AE
            -- Make sure we don't pick up themes that are already
            -- used as base table themes - i.e. they don't need this
            -- running again !
            And     Not Exists  (
                                Select  Null
                                From    Nm_Themes_All nta2
                                Where   nta.Nth_Theme_Id = nta2.Nth_Base_Table_Theme
                                )
            )
  Loop
    Make_Datum_Layer_Dt ( pi_Nth_Theme_Id => i.Nth_Theme_Id );
  End Loop;
End Make_All_Datum_Layers_Dt;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Datum_Layer_From_Route (
                                    p_Ne_Id In Nm_Elements.Ne_Id%Type
                                    )  Return Nm_Theme_Array
Is
Begin
  Return Get_Datum_Layer_From_Gty
                                (Nm3Get.Get_Ne (p_Ne_Id).Ne_Gty_Group_Type
                                );
End Get_Datum_Layer_From_Route;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Datum_Layer_From_Nlt (
                                  p_Nlt_Id In Nm_Linear_Types.Nlt_Id%Type
                                  )  Return Nm_Theme_Array
Is
  Nltrow   Nm_Linear_Types%Rowtype   := Nm3Get.Get_Nlt (p_Nlt_Id);
Begin
  Return Get_Datum_Layer_From_Gty (Nltrow.Nlt_Gty_Type);
End Get_Datum_Layer_From_Nlt;
--
---------------------------------------------------------------------------------------------------
--
Function Element_Exists_In_Theme  (
                                  p_Ne_Id               In   Nm_Elements.Ne_Id%Type,
                                  p_Feature_Table       In   Varchar2,
                                  p_Feature_Fk_Column   In   Varchar2
                                  ) Return Boolean
Is
  Type Curtyp Is Ref Cursor;

  In_Theme     Curtyp;
  Cur_String   Varchar2 (2000)
     :=    'select 1 from '
        || P_Feature_Table
        || ' where '
        || P_Feature_Fk_Column
        || ' = :c_ne_id';
  l_Dummy      Number;
  Retval       Boolean;
Begin
  Open In_Theme For Cur_String Using p_Ne_Id;

  Fetch In_Theme
  Into  l_Dummy;

  Retval := In_Theme%Found;

  Close In_Theme;

  Return Retval;
End Element_Exists_In_Theme;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Prevent_Operation  (
                            p_Ne_Id In Nm_Elements.Ne_Id%Type
                            ) Return Boolean
Is
  Retval   Boolean := False;
--
Begin
  -- look for an independent SDE theme for this network type
  For Irec In (
              Select  Nth.Nth_Theme_Id,
                      Nth.Nth_Feature_Table,
                      Nth.Nth_Feature_Fk_Column
              From    Nm_Nw_Themes      Nwt,
                      Nm_Elements_All   Ne,
                      Nm_Themes_All     Nth,
                      Nm_Linear_Types   Nlt
              Where   Ne.Ne_Id              =   p_Ne_Id
              And     Nwt.Nnth_Nlt_Id       =   Nlt.Nlt_Id
              And     Nwt.Nnth_Nth_Theme_Id =   Nth.Nth_Theme_Id
              And     Nlt.Nlt_Nt_Type       =   Ne.Ne_Nt_Type
              And     Decode (Nlt.Nlt_G_I_D,
                             'D', 'NOT_USED',
                             'G', Ne.Ne_Gty_Group_Type
                              )             
                      =
                      Decode (Nlt.Nlt_G_I_D,
                             'D', 'NOT_USED',
                             'G', Nlt.Nlt_Gty_Type
                             )
              And     Nth.Nth_Theme_Type  = 'SDE'
              And     Nth.Nth_Storage     = 'S'
              And     Nth.Nth_Dependency  = 'I'
              )
  Loop
    If Element_Exists_In_Theme (
                               p_Ne_Id                  => p_Ne_Id,
                               p_Feature_Table          => Irec.Nth_Feature_Table,
                               p_Feature_Fk_Column      => Irec.Nth_Feature_Fk_Column
                               )  Then
      Retval := True;
      Exit;
    End If;
  End Loop;

  Return Retval;
End Prevent_Operation;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
Procedure Remove_Element_Shapes (
                                p_Ne_Id In Nm_Elements.Ne_Id%Type
                                )
Is
--
Begin
  --
  For Irec In (
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column
              From    Nm_Themes_All     nta,
                      Nm_Nw_Themes      nnt,
                      Nm_Linear_Types   nlt,
                      Nm_Elements       ne
              Where   nlt.Nlt_Id                              =   nnt.Nnth_Nlt_Id
              And     nta.Nth_Theme_Id                        =   nnt.Nnth_Nth_Theme_Id
              And     nlt.Nlt_Nt_Type                         =   ne.Ne_Nt_Type
              And     Nvl (nlt.Nlt_Gty_Type, Nm3Type.Get_Nvl) =   Nvl (ne.Ne_Gty_Group_Type, Nm3Type.Get_Nvl)
              And     ne.Ne_Id                                =   p_Ne_Id
              ) 
  Loop
     --
     Execute Immediate    'DELETE FROM '
                       || Irec.Nth_Feature_Table
                       || ' WHERE '
                       || Irec.Nth_Feature_Pk_Column
                       || ' = :ne_id'
                 Using p_Ne_Id;
  End Loop;
  --
End Remove_Element_Shapes;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Procedure Regenerate_Affected_Shapes  (
                                      p_Nm_Type       In   Nm_Members.Nm_Type%Type,
                                      p_Nm_Obj_Type   In   Nm_Members.Nm_Obj_Type%Type,
                                      p_Ne_Id         In   Nm_Elements.Ne_Id%Type
                                      )
Is
  Inv_Upd   Varchar2 (2000)
     :=    'update :table_name '
        || 'set :shape_col = nm3sdm.get_shape_from_ne( :ne_id ) '
        || 'where :ne_col = :ne_id';
  Nw_Upd    Varchar2 (2000)
     :=    'update :table_name '
        || 'set :shape_col = nm3sdm.get_route_shape( :ne_id ) '
        || 'where :ne_col = :ne_id';
Begin
  If P_Nm_Type = 'I'  Then
    For Irec In (
                Select  nta.Nth_Theme_Id,
                        nta.Nth_Feature_Table,
                        nta.Nth_Feature_Shape_Column,
                        nta.Nth_Feature_Fk_Column
                 From   Nm_Inv_Themes   nit,
                        Nm_Themes_All   nta
                Where   nit.Nith_Nth_Theme_Id =   nta.Nth_Theme_Id
                And     nit.Nith_Nit_Id       =   p_Nm_Obj_Type           
                )
    Loop
      Execute Immediate Inv_Upd
                  Using Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Shape_Column,
                        p_Ne_Id,
                        Irec.Nth_Feature_Fk_Column,
                        p_Ne_Id;
    End Loop;
  Else
    For Irec In  (
                 Select  nta.Nth_Theme_Id,
                         nta.Nth_Feature_Table,
                         nta.Nth_Feature_Shape_Column,
                         nta.Nth_Feature_Fk_Column
                 From    Nm_Nw_Themes       nnt,
                         Nm_Themes_All      nta,
                         Nm_Linear_Types    nlt
                 Where   nnt.Nnth_Nth_Theme_Id  =   nta.Nth_Theme_Id
                 And     nlt.Nlt_Id             =   nnt.Nnth_Nlt_Id
                 And     nlt.Nlt_Gty_Type       =   p_Nm_Obj_Type
                 )
    Loop
      Execute Immediate Nw_Upd
                  Using Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Shape_Column,
                        p_Ne_Id,
                        Irec.Nth_Feature_Fk_Column,
                        p_Ne_Id;
    End Loop;
  End If;
End Regenerate_Affected_Shapes;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Get_Ona_Spatial_Table  (
                                p_Nit In Nm_Inv_Types.Nit_Inv_Type%Type
                                ) Return Varchar2
Is  
Begin
  Return 'NM_ONA_' || p_Nit || '_SDO';
End Get_Ona_Spatial_Table;
--
-------------------------------------------------------------------------------------------------------
--
Function Get_Inv_Spatial_Table  (
                                p_Nit In Nm_Inv_Types.Nit_Inv_Type%Type
                                ) Return Varchar2
Is
Begin
  Return 'NM_NIT_' || P_Nit || '_SDO';
End Get_Inv_Spatial_Table;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Get_Nt_Spatial_Table (
                              p_Nt_Type    In   Nm_Types.Nt_Type%Type,
                              p_Gty_Type   In   Nm_Group_Types.Ngt_Group_Type%Type Default Null
                              ) Return Varchar2
Is
  Retval   Varchar2 (30) := 'NM_NLT_' || p_Nt_Type;
Begin

  If p_Gty_Type Is Not Null Then
    Retval := Retval || '_' || p_Gty_Type;
  End If;

  Retval := Retval || '_SDO';
  
  Return Retval;
End Get_Nt_Spatial_Table;

--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Get_Nt_View_Name (
                          p_Nt_Type    In   Nm_Types.Nt_Type%Type,
                          p_Gty_Type   In   Nm_Group_Types.Ngt_Group_Type%Type
                          ) Return Varchar2
Is
  l_Retval  Varchar2(30);
Begin
  If p_Gty_Type Is Not Null Then
    l_Retval:= 'V_NM_' || p_Nt_Type ||'_'|| p_Gty_Type|| '_NT';
  Else
    l_Retval:= 'V_NM_' || p_Nt_Type || '_NT';
  End If;
  Return(l_Retval);
End Get_Nt_View_Name;
--
---------------------------------------------------------------------------------------------------
--
Function Inv_Has_Shape  (
                        p_Ne_Id      In   Nm_Elements.Ne_Id%Type,
                        p_Obj_Type   In   Nm_Members.Nm_Obj_Type%Type
                        ) Return Boolean
Is
  Nthrec       Nm_Themes_All%Rowtype;
  Rcur         Nm3Type.Ref_Cursor;
  Cur_String   Varchar2 (2000);
  Dummy        Integer;
  Retval       Boolean                 := False;
Begin
  For Irec In (
              Select  nit.Nith_Nth_Theme_Id Nth_Theme_Id
              From    Nm_Inv_Themes nit
              Where   nit.Nith_Nit_Id = p_Obj_Type
              )
  Loop
    Nthrec := Get_Nth (Irec.Nth_Theme_Id);

    If Nm3Ddl.Does_Object_Exist  (p_Object_Name      => Nthrec.Nth_Feature_Table)  Then
      Cur_String :=
                    'select 1 from '
                 || Nthrec.Nth_Feature_Table
                 || ' where '
                 || Nthrec.Nth_Feature_Pk_Column
                 || ' = :ne_val';

      Open Rcur For Cur_String Using p_Ne_Id;

      Fetch Rcur
      Into Dummy;

      If Rcur%Found Then
        Retval := True;
        Exit;
      End If;
    End If;
  End Loop;

  Return Retval;
End Inv_Has_Shape;
--
---------------------------------------------------------------------------------------------------
--
Function Nlt_Has_Shape  (
                        p_Ne_Id    In   Nm_Elements.Ne_Id%Type,
                        p_Nlt_Id   In   Nm_Linear_Types.Nlt_Id%Type
                        ) Return Boolean
Is
  Nthrec       Nm_Themes_All%Rowtype;
  Rcur         Nm3Type.Ref_Cursor;
  Cur_String   Varchar2 (2000);
  Dummy        Integer;
  Retval       Boolean                 := False;
Begin
  For Irec In (
              Select  nnt.Nnth_Nth_Theme_Id  Nth_Theme_Id
              From    Nm_Nw_Themes  nnt
              Where   nnt.Nnth_Nlt_Id = p_Nlt_Id
              )
  Loop
    Nthrec := Get_Nth (Irec.Nth_Theme_Id);

    If Nm3Ddl.Does_Object_Exist (p_Object_Name      => Nthrec.Nth_Feature_Table)  Then

      Cur_String :=
                    'select 1 from '
                 || Nthrec.Nth_Feature_Table
                 || ' where '
                 || Nthrec.Nth_Feature_Pk_Column
                 || ' = :ne_val';

      Open Rcur For Cur_String Using p_Ne_Id;
      Fetch Rcur
      Into Dummy;

      If Rcur%Found Then
        Retval := True;
        Exit;
      End If;
    End If;
  End Loop;

  Return Retval;
End Nlt_Has_Shape;
--
---------------------------------------------------------------------------------------------------
--
Function Area_Has_Shape (
                        p_Ne_Id    In   Nm_Elements.Ne_Id%Type,
                        p_Nat_Id   In   Nm_Area_Types.Nat_Id%Type
                        ) Return Boolean
Is
  Nthrec       Nm_Themes_All%Rowtype;
  Rcur         Nm3Type.Ref_Cursor;
  Cur_String   Varchar2 (2000);
  Dummy        Integer;
  Retval       Boolean                 := False;
Begin
  For Irec In (
              Select  nat.Nath_Nth_Theme_Id Nth_Theme_Id
              From    Nm_Area_Themes  nat
              Where   nat.Nath_Nat_Id = p_Nat_Id
              )
  Loop
    Nthrec := Get_Nth (Irec.Nth_Theme_Id);

    If Nm3Ddl.Does_Object_Exist (p_Object_Name      => Nthrec.Nth_Feature_Table)  Then
      Cur_String :=
                    'select 1 from '
                 || Nthrec.Nth_Feature_Table
                 || ' where '
                 || Nthrec.Nth_Feature_Pk_Column
                 || ' = :ne_val';

      Open Rcur For Cur_String Using P_Ne_Id;

      Fetch Rcur
      Into Dummy;

      If Rcur%Found Then
        Retval := True;
        Exit;
      End If;
    End If;
  End Loop;

  Return Retval;
End Area_Has_Shape;
--
---------------------------------------------------------------------------------------------------
--
Function Datum_Has_Shape  (
                          p_Ne_Id In Nm_Elements.Ne_Id%Type
                          ) Return Boolean
Is
  Lnerec       Nm_Elements%Rowtype     := Nm3Get.Get_Ne (p_Ne_Id);

  Nthrec       Nm_Themes_All%Rowtype;
  Rcur         Nm3Type.Ref_Cursor;
  Cur_String   Varchar2 (2000);
  Dummy        Integer;
  Retval       Boolean                 := False;
Begin
  For Irec In (
              Select  nnt.Nnth_Nth_Theme_Id Nth_Theme_Id
              From    Nm_Nw_Themes    nnt,
                      Nm_Linear_Types nlt
              Where   nnt.Nnth_Nlt_Id   = nlt.Nlt_Id
              And     nlt.Nlt_Nt_Type   = Lnerec.Ne_Nt_Type
              )
  Loop
    Nthrec := Get_Nth (Irec.Nth_Theme_Id);

    If Nm3Ddl.Does_Object_Exist (p_Object_Name      => Nthrec.Nth_Feature_Table)  Then
      Cur_String :=
                    'select 1 from '
                 || Nthrec.Nth_Feature_Table
                 || ' where '
                 || Nthrec.Nth_Feature_Pk_Column
                 || ' = :ne_val';

      Open Rcur For Cur_String Using P_Ne_Id;

      Fetch Rcur
      Into Dummy;

      If Rcur%Found Then
        Retval := True;
        Exit;
      End If;
    End If;
  End Loop;

  Return Retval;
End Datum_Has_Shape;
--
---------------------------------------------------------------------------------------------------
--
Function Get_Nlt_Id_From_Gty  (
                              pi_Gty In Nm_Group_Types.Ngt_Group_Type%Type
                              )  Return Nm_Linear_Types.Nlt_Id%Type
Is
  Retval   Nm_Linear_Types.Nlt_Id%Type;
Begin
  Begin
    Select  Nlt_Id
    Into    Retval
    From    Nm_Linear_Types nlt
    Where   nlt.Nlt_Gty_Type =  pi_Gty
    And     Rownum           =  1;
  Exception
    When No_Data_Found Then
      Null;
  End;

  Return Retval;
End Get_Nlt_Id_From_Gty;
--
-----------------------------------------------------------------------------
--
Function Get_Nat_Id_From_Gty  (
                              pi_Gty In Nm_Group_Types.Ngt_Group_Type%Type
                              ) Return Nm_Area_Types.Nat_Id%Type
Is
  Retval   Nm_Area_Types.Nat_Id%Type;
Begin
  Begin
    Select  nat.Nat_Id
    Into    Retval
    From    Nm_Area_Types   nat
    Where   nat.Nat_Gty_Group_Type = pi_Gty;
    
  Exception
    When No_Data_Found Then
      Null;
  End;
  
  Return Retval;
End Get_Nat_Id_From_Gty;
--
-----------------------------------------------------------------------------
--  
Function Has_Shape  (
                    p_Ne_Id      In   Nm_Elements.Ne_Id%Type,
                    p_Obj_Type   In   Nm_Members.Nm_Obj_Type%Type,
                    p_Type       In   Nm_Members.Nm_Type%Type Default 'I'
                    ) Return Boolean
Is
  l_Nlt_Id   Nm_Linear_Types.Nlt_Id%Type;
  l_Nat_Id   Nm_Area_Types.Nat_Id%Type;
  Retval     Boolean                       := False;
Begin
  If p_Type = 'I' Then
    Retval := Inv_Has_Shape (p_Ne_Id, p_Obj_Type);
  Elsif p_Type = 'G'  Then
    l_Nlt_Id := Get_Nlt_Id_From_Gty (p_Obj_Type);

    If l_Nlt_Id Is Not Null Then
      Retval := Nlt_Has_Shape (p_Ne_Id, l_Nlt_Id);
    Else
      l_Nat_Id := Get_Nat_Id_From_Gty (p_Obj_Type);

      If L_Nat_Id Is Not Null Then
        Retval := Area_Has_Shape (p_Ne_Id, l_Nat_Id);
      End If;
    End If;
  Elsif p_Type = 'D'  Then
    -- datum
    Retval := Datum_Has_Shape (p_Ne_Id);
  End If;

  Return Retval;
End Has_Shape;
--
---------------------------------------------------------------------------------------------------
--
Procedure Set_Obj_Shape_End_Date  (
                                  p_Obj_Type   In   Nm_Members.Nm_Obj_Type%Type,
                                  p_Ne_Id      In   Nm_Members.Nm_Ne_Id_In%Type,
                                  p_End_Date   In   Nm_Members.Nm_Start_Date%Type
                                  )
Is
  Cur_String   Varchar2 (2000);
Begin
  Cur_String :=
                'update '
             || Get_Inv_Spatial_Table (p_Obj_Type)
             || ' set end_date = :p_end_date '
             || ' where ne_id = :ne ';

  Execute Immediate Cur_String
              Using p_End_Date, p_Ne_Id;
End Set_Obj_Shape_End_Date;
--
-----------------------------------------------------------------------------
--
Procedure Insert_Obj_Shape  (
                            p_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                            p_Ne_Id        In   Nm_Members.Nm_Ne_Id_In%Type,
                            p_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_End_Date     In   Nm_Members.Nm_Start_Date%Type Default Null,
                            p_Geom         In   Mdsys.Sdo_Geometry
                            )
Is
  Cur_String   Varchar2 (2000);
Begin
  Cur_String := 'insert into '
             || Get_Inv_Spatial_Table (p_Obj_Type)
             || ' ( ne_id, geoloc, start_date, end_date )'
             || ' values ( :p_ne_id, :p_geom, :p_start_date, :p_end_date )';

  Execute Immediate Cur_String  Using p_Ne_Id, p_Geom, p_Start_Date, p_End_Date;
  
Exception
  When Dup_Val_On_Index Then
    Cur_String  :=
                   'delete from '
                || Get_Inv_Spatial_Table (P_Obj_Type)
                || ' where ne_id = :p_ne_id and start_date = :p_start_date';

    Execute Immediate Cur_String  Using P_Ne_Id, P_Start_Date;

    Cur_String  := 'insert into '
                || Get_Inv_Spatial_Table (P_Obj_Type)
                || ' ( ne_id, geoloc, start_date, end_date )'
                || ' values ( :p_ne_id, :p_geom, :p_start_date, :p_end_date )';

    Execute Immediate Cur_String Using P_Ne_Id, P_Geom, P_Start_Date, P_End_Date;
End Insert_Obj_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Update_Member_Shape (
                              p_Nm_Ne_Id_In      In   Nm_Members.Nm_Ne_Id_In%Type,
                              p_Nm_Ne_Id_Of      In   Nm_Members.Nm_Ne_Id_Of%Type,
                              p_Nm_Obj_Type      In   Nm_Members.Nm_Obj_Type%Type,
                              p_Old_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                              p_New_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                              p_Nm_End_Mp        In   Nm_Members.Nm_End_Mp%Type,
                              p_Old_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                              p_New_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                              p_Nm_End_Date      In   Nm_Members.Nm_End_Date%Type,
                              p_Nm_Type          In   Nm_Members.Nm_Type%Type
                              )
Is
Begin
  If p_Nm_Type = 'I'  Then
    Update_Inv_Shape  (
                      p_Nm_Ne_Id_In         => p_Nm_Ne_Id_In,
                      p_Nm_Ne_Id_Of         => p_Nm_Ne_Id_Of,
                      p_Nm_Obj_Type         => p_Nm_Obj_Type,
                      p_Old_Begin_Mp        => p_Old_Begin_Mp,
                      p_New_Begin_Mp        => p_New_Begin_Mp,
                      p_Nm_End_Mp           => p_Nm_End_Mp,
                      p_Old_Start_Date      => p_Old_Start_Date,
                      p_New_Start_Date      => p_New_Start_Date,
                      p_Nm_End_Date         => p_Nm_End_Date
                      );
  Elsif p_Nm_Type = 'G' Then
    Update_Gty_Shape  (
                      p_Nm_Ne_Id_In         => p_Nm_Ne_Id_In,
                      p_Nm_Ne_Id_Of         => p_Nm_Ne_Id_Of,
                      p_Nm_Obj_Type         => p_Nm_Obj_Type,
                      p_Old_Begin_Mp        => p_Old_Begin_Mp,
                      p_New_Begin_Mp        => p_New_Begin_Mp,
                      p_Nm_End_Mp           => p_Nm_End_Mp,
                      p_Old_Start_Date      => p_Old_Start_Date,
                      p_New_Start_Date      => p_New_Start_Date,
                      p_Nm_End_Date         => p_Nm_End_Date
                      );
  End If;
End Update_Member_Shape;

--
-----------------------------------------------------------------------------
--
Procedure Update_Inv_Shape  (
                            p_Nm_Ne_Id_In      In   Nm_Members.Nm_Ne_Id_In%Type,
                            p_Nm_Ne_Id_Of      In   Nm_Members.Nm_Ne_Id_Of%Type,
                            p_Nm_Obj_Type      In   Nm_Members.Nm_Obj_Type%Type,
                            p_Old_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_New_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_Nm_End_Mp        In   Nm_Members.Nm_End_Mp%Type,
                            p_Old_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_New_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_Nm_End_Date      In   Nm_Members.Nm_End_Date%Type
                            )
Is
  Upd_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
  l_Nit        Nm_Inv_Types%Rowtype   := Nm3Get.Get_Nit (P_Nm_Obj_Type);
Begin
  --  allow for many layers of the same asset type
  For Irec In   (
                Select  nta.Nth_Feature_Table,
                        nta.Nth_Feature_Pk_Column,
                        nta.Nth_Feature_Fk_Column,
                        nbt.Nbth_Base_Theme,
                        nta.Nth_Xsp_Column
                From    Nm_Themes_All     nta,
                        Nm_Inv_Themes     nit,
                        Nm_Base_Themes    nbt,
                        Nm_Nw_Themes      nnt,
                        Nm_Elements       ne,
                        Nm_Linear_Types   nlt
                Where   nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
                And     nta.Nth_Theme_Id        =   nbt.Nbth_Theme_Id
                And     nit.Nith_Nit_Id         =   p_Nm_Obj_Type
                And     nta.Nth_Update_On_Edit  =   'I'
                And     ne.Ne_Id                =   p_Nm_Ne_Id_Of
                And     ne.Ne_Nt_Type           =   nlt.Nlt_Nt_Type
                And     nnt.Nnth_Nth_Theme_Id   =   nbt.Nbth_Base_Theme
                And     nlt.Nlt_Id              =   nnt.Nnth_Nlt_Id
                )
  Loop
     Upd_String :=  'update '
                || Irec.Nth_Feature_Table
                || ' set geoloc = :newshape, '
                || '     nm_begin_mp = :new_begin_mp,'
                || '     nm_end_mp   = :new_end_mp, '
                || '     start_date = :new_start_date, '
                || '     end_date   = :new_end_date '
                || '  where ne_id = :ne_id'
                || ' and ne_id_of = :ne_id_of '
                || ' and nm_begin_mp = :nm_begin_mp '
                || ' and start_date  = :old_start_date ';

    If l_Nit.Nit_Pnt_Or_Cont = 'P'  Then
      l_Geom := Nm3Sdo.Get_Pt_Shape_From_Ne (
                                            Irec.Nbth_Base_Theme,
                                            p_Nm_Ne_Id_Of,
                                            p_New_Begin_Mp
                                            );
    Else
      l_Geom := Nm3Sdo.Get_Shape_From_Nm    (
                                            Irec.Nbth_Base_Theme,
                                            p_Nm_Ne_Id_In,
                                            p_Nm_Ne_Id_Of,
                                            p_New_Begin_Mp,
                                            p_Nm_End_Mp
                                            );
    End If;

     -- CWS Lateral Offset change.
    If        Irec.Nth_Xsp_Column Is Not Null
        And   Nvl(Hig.Get_Sysopt('XSPOFFSET'),'N') = 'Y'   Then

       If l_nit.nit_pnt_or_cont = 'P'
       Then
          
          l_Geom := sdo_lrs.convert_to_std_geom( Nm3Sdo_Dynseg.Get_Shape( Irec.Nbth_Base_Theme, p_Nm_Ne_Id_In, p_Nm_Ne_Id_Of, p_New_Begin_Mp, p_Nm_End_Mp ));
       Else
          
          l_Geom := Nm3Sdo_Dynseg.Get_Shape( Irec.Nbth_Base_Theme, p_Nm_Ne_Id_In, p_Nm_Ne_Id_Of, p_New_Begin_Mp, p_Nm_End_Mp );
       End if;

    End If;

    Execute Immediate Upd_String
    Using l_Geom,
          p_New_Begin_Mp,
          p_Nm_End_Mp,
          p_New_Start_Date,
          p_Nm_End_Date,
          p_Nm_Ne_Id_In,
          p_Nm_Ne_Id_Of,
          p_Old_Begin_Mp,
          p_Old_Start_Date;
  End Loop;
End Update_Inv_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Update_Gty_Shape  (
                            p_Nm_Ne_Id_In      In   Nm_Members.Nm_Ne_Id_In%Type,
                            p_Nm_Ne_Id_Of      In   Nm_Members.Nm_Ne_Id_Of%Type,
                            p_Nm_Obj_Type      In   Nm_Members.Nm_Obj_Type%Type,
                            p_Old_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_New_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_Nm_End_Mp        In   Nm_Members.Nm_End_Mp%Type,
                            p_Old_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_New_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_Nm_End_Date      In   Nm_Members.Nm_End_Date%Type
                            )
Is

  Upd_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
Begin
  --allow for many layers of the same gty type
  For Irec In   (
                Select  Nth_Feature_Table,
                        Nth_Feature_Pk_Column,
                        Nth_Feature_Fk_Column,
                        Nbth_Base_Theme,
                        'G' I_Or_G,
                        p_Nm_Obj_Type Obj_Type
                From    Nm_Themes_All     nta,
                        Nm_Area_Types     nat,
                        Nm_Area_Themes    nath,
                        Nm_Base_Themes    nbt,
                        Nm_Nw_Themes      nnt,
                        Nm_Elements       ne,
                        Nm_Linear_Types   nlt
                Where   nta.Nth_Theme_Id        =   nath.Nath_Nth_Theme_Id
                And     nta.Nth_Theme_Id        =   nbt.Nbth_Theme_Id
                And     nath.Nath_Nat_Id        =   nat.Nat_Id
                And     nat.Nat_Gty_Group_Type  =   p_Nm_Obj_Type
                And     nta.Nth_Theme_Type      =   'SDO'
                And     ne.Ne_Id                =   p_Nm_Ne_Id_Of
                And     ne.Ne_Nt_Type           =   nlt.Nlt_Nt_Type
                And     nnt.Nnth_Nth_Theme_Id   =   nbt.Nbth_Base_Theme
                And     nlt.Nlt_Id              =   nnt.Nnth_Nlt_Id
                And     nta.Nth_Update_On_Edit  =   'I'
                Union
                Select  Nth_Feature_Table,
                        Nth_Feature_Pk_Column,
                        Nth_Feature_Fk_Column,
                        Nbth_Base_Theme,
                        'I',
                        Nad_Inv_Type
                From    Nm_Themes_All   nta,
                        Nm_Inv_Themes   nit,
                        Nm_Base_Themes  nbt,
                        Nm_Nw_Themes    nnt,
                        Nm_Elements     ne,
                        Nm_Linear_Types nlt,
                        Nm_Nw_Ad_Types  nnat
                Where   nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
                And     nta.Nth_Theme_Id        =   nbt.Nbth_Theme_Id
                And     nnat.Nad_Gty_Type       =   p_Nm_Obj_Type
                And     nnat.Nad_Inv_Type       =   nit.Nith_Nit_Id
                And     nta.Nth_Theme_Type      =   'SDO'
                And     ne.Ne_Id                =   p_Nm_Ne_Id_Of
                And     ne.Ne_Nt_Type           =   nlt.Nlt_Nt_Type
                And     nnt.Nnth_Nth_Theme_Id   =   nbt.Nbth_Base_Theme
                And     nlt.Nlt_Id              =   nnt.Nnth_Nlt_Id
                And     nta.Nth_Update_On_Edit  =   'I'
                )
  Loop
    If Irec.I_Or_G = 'G' Then
      Upd_String := 'update '
                  || Irec.Nth_Feature_Table
                  || ' set geoloc = :newshape, '
                  || '     nm_begin_mp = :new_begin_mp,'
                  || '     nm_end_mp   = :new_end_mp '
                  || '  where ne_id = :ne_id'
                  || ' and ne_id_of = :ne_id_of '
                  || ' and nm_begin_mp = :nm_begin_mp '
                  || ' and end_date is null';
      l_Geom := Sdo_Lrs.Convert_To_Std_Geom( Nm3Sdo.Get_Shape_From_Nm (
                                                                      Irec.Nbth_Base_Theme,
                                                                      p_Nm_Ne_Id_In,
                                                                      p_Nm_Ne_Id_Of,
                                                                      p_New_Begin_Mp,
                                                                      p_Nm_End_Mp
                                                                     ));
      Execute Immediate Upd_String
      Using   l_Geom,
              p_New_Begin_Mp,
              p_Nm_End_Mp,
              p_Nm_Ne_Id_In,
              p_Nm_Ne_Id_Of,
              p_Old_Begin_Mp;
    Else
      Upd_String := 'update '
                  || Irec.Nth_Feature_Table
                  || ' set geoloc = :newshape, '
                  || '     nm_begin_mp = :new_begin_mp,'
                  || '     nm_end_mp   = :new_end_mp '
                  || '  where ne_id in ( select nad_iit_ne_id '
                  ||                   ' from nm_nw_ad_link '
                  ||                   ' where nad_ne_id = :ne_id'
                  ||                   ' and nad_gty_type =  :gty_type '
                  ||                   ' and nad_inv_type =  :obj_type '
                  ||                   ' and nad_whole_road = :whole_road  ) '
                  || ' and ne_id_of = :ne_id_of '
                  || ' and nm_begin_mp = :nm_begin_mp '
                  || ' and end_date is null';
      l_Geom := Nm3Sdo.Get_Shape_From_Nm  (
                                          Irec.Nbth_Base_Theme,
                                          p_Nm_Ne_Id_In,
                                          p_Nm_Ne_Id_Of,
                                          p_New_Begin_Mp,
                                          p_Nm_End_Mp
                                          );

      Execute Immediate Upd_String
      Using l_Geom,
            p_New_Begin_Mp,
            p_Nm_End_Mp,
            p_Nm_Ne_Id_In,
            p_Nm_Obj_Type,
            Irec.Obj_Type,
            '1',
            p_Nm_Ne_Id_Of,
            p_Old_Begin_Mp;
    End If;
  End Loop;
End Update_Gty_Shape;
--
-----------------------------------------------------------------------------
--
Procedure End_Member_Shape  (
                            p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                            p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                            p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                            p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                            p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type,
                            p_Nm_Type         In   Nm_Members.Nm_Type%Type
                            )
Is
Begin
  If p_Nm_Type = 'I'  Then
    End_Inv_Shape (
                  p_Nm_Ne_Id_In        => p_Nm_Ne_Id_In,
                  p_Nm_Ne_Id_Of        => p_Nm_Ne_Id_Of,
                  p_Nm_Obj_Type        => p_Nm_Obj_Type,
                  p_Nm_Begin_Mp        => p_Nm_Begin_Mp,
                  p_Nm_End_Mp          => p_Nm_End_Mp,
                  p_Nm_Start_Date      => p_Nm_Start_Date,
                  p_Nm_End_Date        => p_Nm_End_Date
                  );
  Elsif p_Nm_Type = 'G' Then
    End_Gty_Shape (
                  p_Nm_Ne_Id_In        => p_Nm_Ne_Id_In,
                  p_Nm_Ne_Id_Of        => p_Nm_Ne_Id_Of,
                  p_Nm_Obj_Type        => p_Nm_Obj_Type,
                  p_Nm_Begin_Mp        => p_Nm_Begin_Mp,
                  p_Nm_End_Mp          => p_Nm_End_Mp,
                  p_Nm_Start_Date      => p_Nm_Start_Date,
                  p_Nm_End_Date        => p_Nm_End_Date
                  );
  End If;
End End_Member_Shape;
--
-----------------------------------------------------------------------------
--
Procedure End_Inv_Shape (
                        p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                        p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                        p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                        p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                        p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                        p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                        p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type
                        )
Is
  Upd_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
Begin
  --allow for many layers of the same asset type
  For Irec In (
              Select    Nth_Feature_Table,
                        Nth_Feature_Pk_Column,
                        Nth_Feature_Fk_Column
              From      Nm_Themes_All   nta,
                        Nm_Inv_Themes   nit
              Where     nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
              And       nit.Nith_Nit_Id         =   p_Nm_Obj_Type
              And       nta.Nth_Update_On_Edit  =   'I'
              )
  Loop
    -- AE - 718333
    -- Include begin_mp and only operate on open shapes
    --
    -- Later change (30-MAR-09) remove the end_date check because this procedure
    -- is used for un-endating too
     Upd_String :=
           'update '
        || Irec.Nth_Feature_Table
        || '  set end_date    = :end_date '
        || 'where ne_id       = :ne_id '
        || '  and ne_id_of    = :ne_id_of '
        || '  and nm_begin_mp = :nm_begin_mp ';

    -- AE - 718333
    -- Include begin_mp and only operate on open shapes
    -- End of changes
    --
    --RAC - Task 0111157 - the update string must update the shape end date on the basis
    --      of the actual start-date for the specific mamber that is targetted.
    --      Without this, the end-date of an asset  (hence members) will update the end-date on
    --      all shape records that have the same begin-mp - including those that are already ended.
  
    If p_Nm_End_Date Is Not Null Then
       Upd_String := Upd_String ||' and end_date is null and start_date = :start_date';
    Else
       Upd_String := Upd_String ||' and start_date = :start_date';
    End If;
  
    Execute Immediate Upd_String
    Using p_Nm_End_Date,
          p_Nm_Ne_Id_In,
          p_Nm_Ne_Id_Of,
          p_Nm_Begin_Mp,
          p_Nm_Start_Date;
  End Loop;
End End_Inv_Shape;
--
-----------------------------------------------------------------------------
--
Procedure End_Gty_Shape (
                        p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                        p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                        p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                        p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                        p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                        p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                        p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type
                        )
Is
  
  Upd_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
  l_Ne_Id      Number;
Begin
  --allow for many layers of the same asset type
  For Irec In   (
                Select  nta.Nth_Feature_Table,
                        nta.Nth_Feature_Pk_Column,
                        nta.Nth_Feature_Fk_Column,
                        'G' G_Or_I,
                        p_Nm_Obj_Type Obj_Type
                From    Nm_Themes_All   nta,
                        Nm_Area_Types   nat,
                        Nm_Area_Themes  nath
                Where   nta.Nth_Theme_Id        =   nath.Nath_Nth_Theme_Id
                And     nath.Nath_Nat_Id        =   nat.Nat_Id
                And     nat.Nat_Gty_Group_Type  =   p_Nm_Obj_Type
                And     nta.Nth_Theme_Type      =   'SDO'
                And     nta.Nth_Update_On_Edit  =   'I'
                Union
                Select  nta.Nth_Feature_Table,
                        nta.Nth_Feature_Pk_Column,
                        nta.Nth_Feature_Fk_Column,
                        'I' G_Or_I,
                        nit.Nith_Nit_Id
                From    Nm_Themes_All   nta,
                        Nm_Nw_Ad_Types  nat,
                        Nm_Inv_Themes   nit
                Where   nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
                And     nit.Nith_Nit_Id         =   nat.Nad_Inv_Type
                And     nat.Nad_Gty_Type        =   p_Nm_Obj_Type
                And     nta.Nth_Update_On_Edit  =   'I'
                )
  Loop
    If Irec.G_Or_I = 'G' Then
      --
      -- AE - 718333
      -- Include begin_mp and only operate on open shapes
      --
      -- Later change (30-MAR-09) remove the end_date check because this procedure
      -- is used for un-endating too
      --
      Upd_String := 'update '|| Irec.Nth_Feature_Table
                  || '  set end_date    = :end_date '
                  || 'where ne_id       = :ne_id '
                  || '  and ne_id_of    = :ne_id_of '
                  || '  and nm_begin_mp = :nm_begin_mp ';

      -- AE - 718333
      -- Include begin_mp and only operate on open shapes
      -- End of changes

      --RAC - Task 0111157 - the update string must update the shape end date on the basis
      --      of the actual start-date for the specific mamber that is targetted.
      --      Without this, the end-date of an asset  (hence members) will update the end-date on
      --      all shape records that have the same begin-mp - including those that are already ended.

      If P_Nm_End_Date Is Not Null Then
        Upd_String := Upd_String ||' and end_date is null and start_date = :start_date';
      Else
        Upd_String := Upd_String ||' and start_date = :start_date';
      End If;

      Execute Immediate Upd_String
      Using   p_Nm_End_Date,
              p_Nm_Ne_Id_In,
              p_Nm_Ne_Id_Of,
              p_Nm_Begin_Mp,
              p_Nm_Start_Date;
    Else
      --
      -- Later change (30-MAR-09) remove the end_date check because this procedure
      -- is used for un-endating too

      Upd_String := 'update '|| Irec.Nth_Feature_Table
                || '   set end_date = :end_date '
                || ' where ne_id_of = :ne_id_of '
                ||   ' and nm_begin_mp = :nm_begin_mp '
                ||   ' and ne_id in ( select nad_iit_ne_id '
                                   || ' from nm_nw_ad_link '
                                   ||' where nad_gty_type   = :p_gty_type '
                                    || ' and nad_inv_type   = :obj_type '
                                    || ' and nad_ne_id      = :nm_ne_id_in '
                                    || ' and nad_whole_road = :whole_road )';
      --
      -- AE 27-MAR-2009
      -- Pass in nm_begin_mp !!
      --

      --RAC - Task 0111157 - the update string must update the shape end date on the basis
      --      of the actual start-date for the specific mamber that is targetted.
      --      Without this, the end-date of an asset  (hence members) will update the end-date on
      --      all shape records that have the same begin-mp - including those that are already ended.
        
      If P_Nm_End_Date Is Not Null Then
        Upd_String := Upd_String ||' and end_date is null and start_date = :start_date';
      Else
        Upd_String := Upd_String ||' and start_date = :start_date';
      End If;
        
      Execute Immediate Upd_String
      Using   p_Nm_End_Date,
              p_Nm_Ne_Id_Of,
              p_Nm_Begin_Mp,
              p_Nm_Obj_Type,
              Irec.Obj_Type,
              p_Nm_Ne_Id_In,
              '1',
              p_Nm_Start_Date;
    End If;
  End Loop;
End End_Gty_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Add_Member_Shape  (
                            p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                            p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                            p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                            p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                            p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type,
                            p_Nm_Type         In   Nm_Members.Nm_Type%Type
                            )
Is
Begin
  If P_Nm_Type = 'I'  Then
    Add_Inv_Shape (
                  p_Nm_Ne_Id_In        => p_Nm_Ne_Id_In,
                  p_Nm_Ne_Id_Of        => p_Nm_Ne_Id_Of,
                  p_Nm_Obj_Type        => p_Nm_Obj_Type,
                  p_Nm_Begin_Mp        => p_Nm_Begin_Mp,
                  p_Nm_End_Mp          => p_Nm_End_Mp,
                  p_Nm_Start_Date      => p_Nm_Start_Date,
                  p_Nm_End_Date        => p_Nm_End_Date
                  );
  Elsif P_Nm_Type = 'G' Then
    Add_Gty_Shape (
                  p_Nm_Ne_Id_In        => p_Nm_Ne_Id_In,
                  p_Nm_Ne_Id_Of        => p_Nm_Ne_Id_Of,
                  p_Nm_Obj_Type        => p_Nm_Obj_Type,
                  p_Nm_Begin_Mp        => p_Nm_Begin_Mp,
                  p_Nm_End_Mp          => p_Nm_End_Mp,
                  p_Nm_Start_Date      => p_Nm_Start_Date,
                  p_Nm_End_Date        => p_Nm_End_Date
                 );
  End If;
End Add_Member_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Remove_Member_Shape (
                              p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                              p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                              p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                              p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                              p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                              p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                              p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type,
                              p_Nm_Type         In   Nm_Members.Nm_Type%Type
                              )
Is
Begin
  If P_Nm_Type = 'I'  Then
   Remove_Inv_Shape (
                    p_Nm_Ne_Id_In        => p_Nm_Ne_Id_In,
                    p_Nm_Ne_Id_Of        => p_Nm_Ne_Id_Of,
                    p_Nm_Obj_Type        => p_Nm_Obj_Type,
                    p_Nm_Begin_Mp        => p_Nm_Begin_Mp,
                    p_Nm_End_Mp          => p_Nm_End_Mp,
                    p_Nm_Start_Date      => p_Nm_Start_Date,
                    p_Nm_End_Date        => p_Nm_End_Date
                    );
  Elsif P_Nm_Type = 'G' Then
    Remove_Gty_Shape  (
                      p_Nm_Ne_Id_In        => p_Nm_Ne_Id_In,
                      p_Nm_Ne_Id_Of        => p_Nm_Ne_Id_Of,
                      p_Nm_Obj_Type        => p_Nm_Obj_Type,
                      p_Nm_Begin_Mp        => p_Nm_Begin_Mp,
                      p_Nm_End_Mp          => p_Nm_End_Mp,
                      p_Nm_Start_Date      => p_Nm_Start_Date,
                      p_Nm_End_Date        => p_Nm_End_Date
                      );
  End If;
End Remove_Member_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Add_Inv_Shape (
                        p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                        p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                        p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                        p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                        p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                        p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                        p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type
                        )
Is
  Ins_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
  l_Nit        Nm_Inv_Types%Rowtype   := Nm3Get.Get_Nit (p_Nm_Obj_Type);
  l_Objid      Number;
Begin
  --allow for many layers of the same asset type, only deal with immediate themes
  For Irec In   (
                Select    nta.Nth_Theme_Id,
                          nta.Nth_Feature_Table,
                          nta.Nth_Feature_Pk_Column,
                          nta.Nth_Feature_Fk_Column,
                          nbt.Nbth_Base_Theme,
                          nta.Nth_Xsp_Column
                From      Nm_Themes_All     nta,
                          Nm_Inv_Themes     nit,
                          Nm_Base_Themes    nbt,
                          Nm_Nw_Themes      nnt,
                          Nm_Elements       ne,
                          Nm_Linear_Types   nlt
                Where     nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
                And       nta.Nth_Theme_Id        =   nbt.Nbth_Theme_Id
                And       nit.Nith_Nit_Id         =   p_Nm_Obj_Type
                And       nta.Nth_Update_On_Edit  =   'I'
                And       ne.Ne_Id                =   p_Nm_Ne_Id_Of
                And       ne.Ne_Nt_Type           =   nlt.Nlt_Nt_Type
                And       nnt.Nnth_Nth_Theme_Id   =   nbt.Nbth_Base_Theme
                And       nlt.Nlt_Id              =   nnt.Nnth_Nlt_Id
                )
  Loop
    If Nm3Sdo.Use_Surrogate_Key = 'N' Then
      Ins_String := 'insert into '
                 || Irec.Nth_Feature_Table
                 || ' ( ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                 || ' values (:ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

      If L_Nit.Nit_Pnt_Or_Cont = 'P'  Then
        l_Geom := Nm3Sdo.Get_Pt_Shape_From_Ne (
                                              Irec.Nbth_Base_Theme,
                                              p_Nm_Ne_Id_Of,
                                              p_Nm_Begin_Mp
                                              );
      Else
        l_Geom := Nm3Sdo.Get_Shape_From_Nm  (
                                            Irec.Nbth_Base_Theme,
                                            p_Nm_Ne_Id_In,
                                            p_Nm_Ne_Id_Of,
                                            p_Nm_Begin_Mp,
                                            p_Nm_End_Mp
                                            );
      End If;

      If      Irec.Nth_Xsp_Column                   Is  Not Null 
          And Nvl(Hig.Get_Sysopt('XSPOFFSET'),'N')  =   'Y' Then

        l_Geom := Nm3Sdo_Dynseg.Get_Shape( Irec.Nbth_Base_Theme, P_Nm_Ne_Id_In, P_Nm_Ne_Id_Of, P_Nm_Begin_Mp, P_Nm_End_Mp );
           
      End If;

      If l_Geom Is Not Null Then
        
        Execute Immediate Ins_String
        Using   p_Nm_Ne_Id_In,
                p_Nm_Ne_Id_Of,
                p_Nm_Begin_Mp,
                p_Nm_End_Mp,
                l_Geom,
                p_Nm_Start_Date,
                p_Nm_End_Date;
      End If;
    Else
      Execute Immediate    'select '
                          || Nm3Sdo.Get_Spatial_Seq (Irec.Nth_Theme_Id)
                          || '.nextval from dual'
      Into  l_Objid;

      Ins_String := 'insert into '
                 || Irec.Nth_Feature_Table
                 || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                 || ' values (:objectid, :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

      If l_Nit.Nit_Pnt_Or_Cont = 'P'  Then
          l_Geom := Nm3Sdo.Get_Pt_Shape_From_Ne (
                                                Irec.Nbth_Base_Theme,
                                                p_Nm_Ne_Id_Of,
                                                p_Nm_Begin_Mp
                                                );
      Else
        l_Geom := Nm3Sdo.Get_Shape_From_Nm  (
                                            Irec.Nbth_Base_Theme,
                                            p_Nm_Ne_Id_In,
                                            p_Nm_Ne_Id_Of,
                                            p_Nm_Begin_Mp,
                                            p_Nm_End_Mp
                                           );
      End If;

      If      Irec.Nth_Xsp_Column                   Is  Not Null 
          And Nvl(Hig.Get_Sysopt('XSPOFFSET'),'N')  =   'Y'   Then

        If l_Nit.Nit_Pnt_Or_Cont = 'P'  Then
             l_Geom := Sdo_Lrs.Convert_To_Std_Geom(Nm3Sdo_Dynseg.Get_Shape  (
                                                                            Irec.Nbth_Base_Theme,
                                                                            p_Nm_Ne_Id_In,
                                                                            p_Nm_Ne_Id_Of,
                                                                            p_Nm_Begin_Mp,P_Nm_End_Mp 
                                                                            ));
        Else
             l_Geom := Nm3Sdo_Dynseg.Get_Shape  (
                                                Irec.Nbth_Base_Theme,
                                                p_Nm_Ne_Id_In,
                                                p_Nm_Ne_Id_Of,
                                                p_Nm_Begin_Mp,
                                                p_Nm_End_Mp
                                                );
        End If;
      End If;

      If l_Geom Is Not Null Then
        Execute Immediate Ins_String
        Using   l_Objid,
                p_Nm_Ne_Id_In,
                p_Nm_Ne_Id_Of,
                p_Nm_Begin_Mp,
                p_Nm_End_Mp,
                l_Geom,
                p_Nm_Start_Date,
                p_Nm_End_Date;
      End If;
    End If;
  End Loop;
End Add_Inv_Shape;
--
---------------------------------------------------------------------------------------------------
--
Procedure Remove_Inv_Shape  (
                            p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                            p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                            p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                            p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                            p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type
                            )
Is
  
  Del_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
  l_Nit        Nm_Inv_Types%Rowtype   := Nm3Get.Get_Nit (p_Nm_Obj_Type);
Begin
  --allow for many layers of the same asset type, only address immediate themes
  For Irec In (
              Select  nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Fk_Column
              From    Nm_Themes_All   nta,
                      Nm_Inv_Themes   nit
              Where   nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
              And     nit.Nith_Nit_Id         =   p_Nm_Obj_Type
              And     nta.Nth_Update_On_Edit  =   'I'
              )
  Loop
    Del_String :=  'delete from '
                || Irec.Nth_Feature_Table
                || ' where ne_id = :ne_id'
                || ' and ne_id_of = :ne_id_of '
                || ' and nm_begin_mp = :ne_begin_mp '
                || ' and start_date = :start_date';

    Execute Immediate Del_String
    Using   p_Nm_Ne_Id_In,
            p_Nm_Ne_Id_Of,
            p_Nm_Begin_Mp,
            p_Nm_Start_Date;
  End Loop;
End Remove_Inv_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Add_Gty_Shape (
                        p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                        p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                        p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                        p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                        p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                        p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                        p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type
                        )
Is
  Ins_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
  l_Objid      Number;
  l_Seq_Name   Varchar2(30);
Begin
  --allow for many layers of the same group type, only deal with immediate themes
  For Irec In (
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Shape_Column,
                      nta.Nth_Feature_Fk_Column,
                      nbt.Nbth_Base_Theme,
                      'G' G_Or_I,
                      p_Nm_Obj_Type Obj_Type
              From    Nm_Themes_All     nta,
                      Nm_Area_Themes    nat,
                      Nm_Area_Types     naty,
                      Nm_Base_Themes    nbt,
                      Nm_Nw_Themes      nnt,
                      Nm_Elements       ne,
                      Nm_Linear_Types   nlt
              Where   nta.Nth_Theme_Id        =   nat.Nath_Nth_Theme_Id
              And     nta.Nth_Theme_Id        =   nbt.Nbth_Theme_Id
              And     nat.Nath_Nat_Id         =   naty.Nat_Id
              And     naty.Nat_Gty_Group_Type =   p_Nm_Obj_Type
              And     nta.Nth_Update_On_Edit  =   'I'
              And     ne.Ne_Id                =   p_Nm_Ne_Id_Of
              And     ne.Ne_Nt_Type           =   nlt.Nlt_Nt_Type
              And     nnt.Nnth_Nth_Theme_Id   =   nbt.Nbth_Base_Theme
              And     nlt.Nlt_Id              =   nnt.Nnth_Nlt_Id
              Union
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Shape_Column,
                      nta.Nth_Feature_Fk_Column,
                      nbt.Nbth_Base_Theme,
                      'I',
                      nal.Nad_Inv_Type
              From    Nm_Themes_All   nta,
                      Nm_Inv_Themes   nit,
                      Nm_Base_Themes  nbt,
                      Nm_Nw_Themes    nnt,
                      Nm_Elements     ne,
                      Nm_Linear_Types nlt,
                      Nm_Nw_Ad_Link   nal
              Where   nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
              And     nta.Nth_Theme_Id        =   nbt.Nbth_Theme_Id
              And     nal.Nad_Inv_Type        =   nit.Nith_Nit_Id
              And     nal.Nad_Gty_Type        =   p_Nm_Obj_Type
              And     nta.Nth_Update_On_Edit  =   'I'
              And     ne.Ne_Id                =   p_Nm_Ne_Id_Of
              And     ne.Ne_Nt_Type           =   nlt.Nlt_Nt_Type
              And     nnt.Nnth_Nth_Theme_Id   =   nbt.Nbth_Base_Theme
              And     nlt.Nlt_Id              =   nnt.Nnth_Nlt_Id
              And     nal.Nad_Ne_Id           =   p_Nm_Ne_Id_In
              )
  Loop
    If Irec.G_Or_I = 'G' Then
      Execute Immediate    'select '
                          || Nm3Sdo.Get_Spatial_Seq (Irec.Nth_Theme_Id)
                          || '.nextval FROM DUAL'
      Into l_Objid;

      Ins_String := 'insert into '
                 || Irec.Nth_Feature_Table
                 || ' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                 || ' values (:objectid, :ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, :geoloc, :start_date, :end_date )';

      l_Geom := Sdo_Lrs.Convert_To_Std_Geom (
                                            Nm3Sdo.Get_Shape_From_Nm  (
                                                                      Irec.Nbth_Base_Theme,
                                                                      p_Nm_Ne_Id_In,
                                                                      p_Nm_Ne_Id_Of,
                                                                      p_Nm_Begin_Mp,
                                                                      p_Nm_End_Mp
                                                                      ));
      --
      -- Task 0108237
      -- AE don't process this insert if the shape is null
      --
      If l_Geom Is Not Null Then
        Execute Immediate Ins_String
        Using   l_Objid,
                p_Nm_Ne_Id_In,
                p_Nm_Ne_Id_Of,
                p_Nm_Begin_Mp,
                p_Nm_End_Mp,
                l_Geom,
                p_Nm_Start_Date,
                p_Nm_End_Date;
      End If;
    Else

      l_Seq_Name := Nm3Sdo.Get_Spatial_Seq (Irec.Nth_Theme_Id);

      Ins_String := 'insert into '
                || Irec.Nth_Feature_Table
                ||' ( objectid, ne_id, ne_id_of, nm_begin_mp, nm_end_mp, geoloc, start_date, end_date )'
                ||' select '||L_Seq_Name||'.nextval, nad_iit_ne_id, :ne_id_of, :nm_begin_mp, :nm_end_mp, '
                ||' Nm3sdo.get_shape_from_nm ('||To_Char(Irec.Nbth_Base_Theme)||', '
                ||' :group_ne_id, '
                ||' :ne_id_of, '
                ||' :nm_begin_mp, '
                ||' :nm_end_mp ), :start_date, :end_date '
                ||' from nm_nw_ad_link where nad_ne_id = :group_ne_id '
                ||' and nad_inv_type = :obj_type '
                ||' and nad_whole_road = '||''''||'1'||'''';

      Execute Immediate Ins_String
      Using   p_Nm_Ne_Id_Of,
              p_Nm_Begin_Mp,
              p_Nm_End_Mp,
              p_Nm_Ne_Id_In,
              p_Nm_Ne_Id_Of,
              p_Nm_Begin_Mp,
              p_Nm_End_Mp,
              p_Nm_Start_Date,
              p_Nm_End_Date,
              p_Nm_Ne_Id_In,
              Irec.Obj_Type;
    End If;
  End Loop;
End Add_Gty_Shape;
--
---------------------------------------------------------------------------------------------------
--
Procedure Remove_Gty_Shape  (
                            p_Nm_Ne_Id_In     In   Nm_Members.Nm_Ne_Id_In%Type,
                            p_Nm_Ne_Id_Of     In   Nm_Members.Nm_Ne_Id_Of%Type,
                            p_Nm_Obj_Type     In   Nm_Members.Nm_Obj_Type%Type,
                            p_Nm_Begin_Mp     In   Nm_Members.Nm_Begin_Mp%Type,
                            p_Nm_End_Mp       In   Nm_Members.Nm_End_Mp%Type,
                            p_Nm_Start_Date   In   Nm_Members.Nm_Start_Date%Type,
                            p_Nm_End_Date     In   Nm_Members.Nm_End_Date%Type
                            )
Is
  Del_String   Varchar2 (2000);
  l_Geom       Mdsys.Sdo_Geometry;
Begin

  For Irec In (
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Fk_Column,
                      'G' Ad_Flag
              From    Nm_Themes_All   nta,
                      Nm_Area_Themes  nat,
                      Nm_Area_Types   naty
              Where   nta.Nth_Theme_Id          =   nat.Nath_Nth_Theme_Id
              And     nat.Nath_Nat_Id           =   naty.Nat_Id
              And     naty.Nat_Gty_Group_Type   =   p_Nm_Obj_Type
              And     nta.Nth_Update_On_Edit    =   'I'
              Union
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Fk_Column,
                      'I'
              From    Nm_Themes_All   nta,
                      Nm_Nw_Ad_Types  nat,
                      Nm_Inv_Themes   nit
              Where   nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
              And     nit.Nith_Nit_Id         =   nat.Nad_Inv_Type
              And     nat.Nad_Gty_Type        =   p_Nm_Obj_Type
              And     nta.Nth_Update_On_Edit  =   'I'
              )
  Loop
  If Irec.Ad_Flag = 'G' Then
    Del_String := 'delete from '
              || Irec.Nth_Feature_Table
              || ' where ne_id = :ne_id'
              || ' and ne_id_of = :ne_id_of '
              || ' and nm_begin_mp = :ne_begin_mp '
              || ' and start_date = :start_date';
  Else  
    Del_String := 'delete from '
              || Irec.Nth_Feature_Table
              || ' where ne_id in ( select nad_iit_ne_id from nm_nw_ad_link where nad_ne_id =  :ne_id )'
              || ' and ne_id_of = :ne_id_of '
              || ' and nm_begin_mp = :ne_begin_mp '
              || ' and start_date = :start_date';
  End If;

  Execute Immediate Del_String
  Using   p_Nm_Ne_Id_In,
          p_Nm_Ne_Id_Of,
          p_Nm_Begin_Mp,
          p_Nm_Start_Date;
  End Loop;
End Remove_Gty_Shape;
--
--
-- A procedure to re-set the route shapes for a specific route from and including a specific date 
-- 
procedure reset_route_shapes( p_ne_id in nm_elements.ne_id%type) as --, p_date in date) as
cursor c1 ( c_ne_id in nm_elements.ne_id%type) is
select * from (
select ne_id, start_date, lead ( start_date, 1) over (order by start_date ) end_date
from (
with membs as ( select nm_ne_id_in, nm_start_date, nm_end_date from nm_members_all where nm_ne_id_in = c_ne_id ) -- and nm_start_date >= c_date )
select distinct ne_id, start_date
from (
select distinct nm_ne_id_in ne_id, nm_start_date start_date 
from membs
union
select distinct nm_ne_id_in, nm_end_date
from membs 
)
order by start_date desc
 )
 )
where nvl(start_date, to_date('05-NOV-1605')) != nvl(end_date, to_date('05-NOV-1605'))
order by start_date desc;
--
l_geom mdsys.sdo_geometry;
--
begin
--nm_debug.debug_on;
  For Irec In (
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Fk_Column,
                      nta.Nth_Feature_Shape_Column,
                      nta.Nth_Sequence_Name
              From    Nm_Themes_All     nta,
                      Nm_Nw_Themes      nnt,
                      User_Tables       ut,
                      Nm_Linear_Types   nlt,
                      Nm_Elements_All   nea
              Where   nta.Nth_Theme_Id  =   nnt.Nnth_Nth_Theme_Id
              And     ut.Table_Name     =   nta.Nth_Feature_Table
              And     nnt.Nnth_Nlt_Id   =   nlt.Nlt_Id
              And     nlt.Nlt_Gty_Type  =   nea.Ne_Gty_Group_Type
              And     nlt.Nlt_Nt_Type   =   nea.Ne_Nt_Type
              And     nea.Ne_Id         =   p_Ne_Id
              )
  Loop
--
  begin
    execute immediate 'delete from '||irec.Nth_Feature_Table||' where '||irec.Nth_Feature_Pk_Column||' = :p_ne_id ' using p_ne_id;
  exception 
    when no_data_found then
      null;
  end;
--  
  nm_debug.debug('go into loop?');
  for idates in c1(p_ne_id) loop
    nm_debug.debug('In loop '||idates.start_date);
    begin
      nm3user.set_effective_date( idates.start_date );
      l_geom := nm3sdo.get_route_shape(p_ne_id);
      if l_geom is not null then
        begin
          execute immediate 'insert into '||irec.Nth_Feature_Table||
               '( objectid, ne_id, geoloc, start_date, end_date ) '||
               ' select '||irec.Nth_Sequence_Name||'.nextval, :p_ne_id, :l_geom, :start_date, :end_date from dual ' using p_ne_id, l_geom, idates.start_date, idates.end_date;
        exception
          when others then
            null;
        end;
      end if;                
    end;
  end loop;
  end loop;
  nm3user.set_effective_date(trunc(sysdate));
exception
  when others then
    nm3user.set_effective_date(trunc(sysdate));
    raise;    
end;
--
---------------------------------------------------------------------------------------------------
--
Procedure Reshape_Route (
                        pi_Ne_Id            In   Nm_Elements.Ne_Id%Type,
                        pi_Effective_Date   In   Date,
                        pi_Use_History      In   Varchar2
                        )
Is
  l_Nlt_Id     Nm_Linear_Types.Nlt_Id%Type;
  l_Nlt        Nm_Linear_Types%Rowtype;
  Cur_String   Varchar2 (2000);
  l_Base_Nth   Nm_Themes_All%Rowtype;
  l_Count      Number;
  l_Shape      Mdsys.Sdo_Geometry;
  l_Next       Number;
  l_Date       Date;

  --------------------
  Function Get_Shape_Start_Date (
                                p_Table    In   Varchar2,
                                p_Column   In   Varchar2,
                                p_Value    In   Number
                                ) Return Date
  Is
    Retval   Date;
  Begin
    Begin
      Execute Immediate    'select start_date from '
                       || p_Table
                       || ' where '
                       || p_Column
                       || ' = :ne_id '
                       || ' and end_date is null'
      Into  Retval
      Using p_Value;

       Return Retval;
    Exception
      When No_Data_Found Then
        Retval:=Null;
    End;
    Return(Retval);          
  End Get_Shape_Start_Date;
  --------------------
  Procedure End_Shape (
                      p_Table       In        Varchar2,
                      p_Column      In        Varchar2,
                      p_Value       In        Number,
                      p_Effective   In        Date,
                      p_Count           Out   Number
                      )
  Is
  Begin
    Execute Immediate    'update '
                       || p_Table
                       || ' set end_date = :effective '
                       || ' where '
                       || p_Column
                       || ' = :ne_id'
                       || ' and end_date is null'
    Using p_Effective,
          p_Value;

     p_Count := Sql%Rowcount;
  End End_Shape;
  --------------------
  Function Get_Next_Theme_Seq (
                              p_Theme In Number
                              ) Return Number
  Is
    Retval   Number;
    curstr   Varchar2(200);
    seqname  Varchar2(30) := Nm3Sdo.Get_Spatial_Seq (p_Theme);
  Begin
     Execute Immediate    'select '
                       || Nm3Sdo.Get_Spatial_Seq (p_Theme)
                       || '.nextval from dual'
                  Into Retval;
     Return Retval;
  End Get_Next_Theme_Seq;
  --------------------
  Procedure Update_Shape (
                         p_Table          In        Varchar2,
                         p_Column         In        Varchar2,
                         p_Value          In        Number,
                         p_Shape_Column   In        Varchar2,
                         p_Shape          In        Mdsys.Sdo_Geometry,
                         p_Count              Out   Number
  )
  Is
  Begin
    Execute Immediate    'update '
                     || p_Table
                     || ' set '
                     || p_Shape_Column
                     || ' = :shape '
                     || ' where '
                     || p_Column
                     || ' = :ne_id'
                     || ' and end_date is null'
    Using p_Shape, 
          p_Value;

    p_Count := Sql%Rowcount;
  End Update_Shape;
  --------------------
  Procedure Update_Shape_and_Date (
                         p_Table          In        Varchar2,
                         p_Column         In        Varchar2,
                         p_Value          In        Number,
                         p_Effective      In        Date,
                         p_Shape_Column   In        Varchar2,
                         p_Shape          In        Mdsys.Sdo_Geometry,
                         p_Count              Out   Number
  )
  Is
  l_date date;
  Begin 
  
    p_Count := 0;
   
    Begin 
      Execute Immediate 'select last_start from ( select first_value (start_date) over (order by start_date desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_start '||
                        ' from '||p_Table||' where ne_id = :ne ) where rownum = 1 ' into l_date using p_Value;
    Exception
      When no_data_found then
        l_date := null;  -- if no data then no update can be performed
    End;
    
    if l_date is not null then
    
      Execute Immediate    'update '
                       || p_Table
                       || ' set '
                       || p_Shape_Column
                       || ' = :shape ,'
                       || 'start_date = :effective,'
                       || 'end_date   =  NULL '
                       || ' where '
                       || p_Column
                       || ' = :ne_id'
                       || ' and start_date = :st_date'
      Using p_Shape, 
            p_Effective,
            p_Value,
            l_date;
            

      p_Count := Sql%Rowcount;
    End If;
  End Update_Shape_and_Date;
  
  Procedure Update_End_Date (
                         p_Table          In        Varchar2,
                         p_Column         In        Varchar2,
                         p_Value          In        Number,
                         p_Effective      In        Date,
                         p_Shape_Column   In        Varchar2,
                         p_Shape          In        Mdsys.Sdo_Geometry,
                         p_Count              Out   Number
  )
  Is
  l_date date;
  Begin 
  
    p_Count := 0;
   
    Begin 
      Execute Immediate 'select last_start from ( select first_value (start_date) over (order by start_date desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_start '||
                        ' from '||p_Table||' where ne_id = :ne ) where rownum = 1 ' into l_date using p_Value;
    Exception
      When no_data_found then
        l_date := null;  -- if no data then no update can be performed
    End;
    
    if l_date is not null then
    
      Execute Immediate    'update '
                       || p_Table
                       || ' set end_date = :effective '
                       || ' where '
                       || p_Column
                       || ' = :ne_id'
                       || ' and start_date = :st_date'
      Using p_Effective,
            p_Value,
            l_date;
            

      p_Count := Sql%Rowcount;
    End If;
  End Update_End_Date;
  
  Procedure Delete_Shape  (
                          p_Table    In       Varchar2,
                          p_Column   In       Varchar2,
                          p_Value    In       Number,
                          p_Count       Out   Number
                          )
  Is
  Begin
    Execute Immediate    'delete from '
                     || p_Table
                     || ' where '
                     || p_Column
                     || ' = :ne_id'
                     || ' and end_date is null'
                 Using p_Value;

    p_Count := Sql%Rowcount;
  End Delete_Shape;
  --------------------
  Procedure Delete_Extraneous_Shapes  (
                          p_Table    In       Varchar2,
                          p_Column   In       Varchar2,
                          p_Value    In       Number,
                          p_Date     In       Date,
                          p_Count       Out   Number
                          )
  Is
  Begin
    Execute Immediate    'delete from '
                     || p_Table
                     || ' where '
                     || p_Column
                     || ' = :ne_id'
                     || ' and start_date > :st_date '
                 Using p_Value, p_Date;

    p_Count := Sql%Rowcount;
  End Delete_Extraneous_Shapes;
  --------------------
  
  Procedure Insert_Shape  (
                          p_Table          In       Varchar2,
                          p_Column         In       Varchar2,
                          p_Value          In       Number,
                          p_Shape_Column   In       Varchar2,
                          p_Shape          In       Mdsys.Sdo_Geometry,
                          p_Seq_No         In       Number,
                          p_Effective      In       Date,
                          p_Count             Out   Number
                          )
  Is
  Begin
     If Nm3Sdo.Use_Surrogate_Key = 'N'  Then
        Execute Immediate    'insert into '
                          || p_Table
                          || '( '
                          || p_Column
                          || ','
                          || p_Shape_Column
                          || ','
                          || 'start_date )'
                          || ' values (:ne_id, :shape, :start_date) '
        Using p_Value,
              p_Shape,
              p_Effective;

        p_Count := Sql%Rowcount;
     Else
      Execute Immediate    'insert into '
                         || p_Table
                         || '( objectid, '
                         || p_Column
                         || ','
                         || p_Shape_Column
                         || ','
                         || 'start_date )'
                         || ' values (:objectid, :ne_id, :shape, :start_date) '
      Using   p_Seq_No,
              p_Value,
              p_Shape,
              p_Effective;

      p_Count := Sql%Rowcount;
     End If;
  End Insert_Shape;
  ---------------------
Begin
 reset_route_shapes(  p_ne_id => pi_Ne_Id ); --, p_date => pi_Effective_Date );
/*
  For Irec In (
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Fk_Column,
                      nta.Nth_Feature_Shape_Column
              From    Nm_Themes_All     nta,
                      Nm_Nw_Themes      nnt,
                      User_Tables       ut,
                      Nm_Linear_Types   nlt,
                      Nm_Elements_All   nea
              Where   nta.Nth_Theme_Id  =   nnt.Nnth_Nth_Theme_Id
              And     ut.Table_Name     =   nta.Nth_Feature_Table
              And     nnt.Nnth_Nlt_Id   =   nlt.Nlt_Id
              And     nlt.Nlt_Gty_Type  =   nea.Ne_Gty_Group_Type
              And     nlt.Nlt_Nt_Type   =   nea.Ne_Nt_Type
              And     nea.Ne_Id         =   pi_Ne_Id
              )
  Loop
    
    --only operate on base table data
    
    l_Shape := Nm3Sdo.Get_Route_Shape (pi_Ne_Id);

      -- first check the start date of the current shape if one exists.
    l_Date := Get_Shape_Start_Date (
                                    Irec.Nth_Feature_Table,
                                    Irec.Nth_Feature_Pk_Column,
                                    pi_Ne_Id
                                    );

    if l_shape is not null and l_date is not null then 

      If L_Date = Pi_Effective_Date Then

        Update_Shape (Irec.Nth_Feature_Table,
                      Irec.Nth_Feature_Pk_Column,
                      pi_Ne_Id,
                      Irec.Nth_Feature_Shape_Column,
                      l_Shape,
                      l_Count
                    );
                    
      Elsif L_Date > Pi_Effective_Date Then
--
--     Test to see if these shapes are valid - if they are just frm some useless resequence from SM then we can trash them
--      
        declare 
          l_last_date date; 
        begin
          select max(greatest(nm_start_date, nvl(nm_end_date, to_date('01-jan-1000', 'DD-MON-YYYY'))))
          into l_last_date
          from nm_members_all
          where nm_ne_id_in =  pi_Ne_Id; 
          
--        nm_debug.debug('Max date of all members is '||l_last_date );
          
          if l_last_date >= l_date then      
      
--          nm_debug.debug('update shape and date');
            
            Update_shape_and_Date(
                       Irec.Nth_Feature_Table,
                       Irec.Nth_Feature_Pk_Column,
                       pi_Ne_Id,
                       l_last_date,
                       Irec.Nth_Feature_Shape_Column,
                       l_Shape,
                       l_count );
          Else
          
--          nm_debug.debug('deleting extraneous shapes' );
            
            Delete_Extraneous_Shapes (
                       Irec.Nth_Feature_Table,
                       Irec.Nth_Feature_Pk_Column,
                       pi_Ne_Id,
                       l_last_date,
                       l_count );

--          nm_debug.debug('update shape and date 2');
                    
            Update_End_Date(
                       Irec.Nth_Feature_Table,
                       Irec.Nth_Feature_Pk_Column,
                       pi_Ne_Id,
                       l_last_date,
                       Irec.Nth_Feature_Shape_Column,
                       l_Shape,
                       l_count );                       
            
            If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
              l_Next := Get_Next_Theme_Seq (Irec.Nth_Theme_Id);
            End If;

--          nm_debug.debug('Inserting new shape');   
 
            Insert_Shape  (
                      Irec.Nth_Feature_Table,
                      Irec.Nth_Feature_Pk_Column,
                      pi_Ne_Id,
                      Irec.Nth_Feature_Shape_Column,
                      l_Shape,
                      l_Next,
                      pi_Effective_Date,
                      l_Count
                      );
          End If;  
        End;      

      Else
       
        -- existing date is less than effective date - check history flags                  
      
        If pi_Use_History = 'Y' Then
        
  --      nm_debug.debug('Ending existing shape');   
          End_Shape (
                    Irec.Nth_Feature_Table,
                    Irec.Nth_Feature_Pk_Column,
                    pi_Ne_Id,
                    pi_Effective_Date,
                    l_Count
                    );
          If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
            l_Next := Get_Next_Theme_Seq (Irec.Nth_Theme_Id);
          End If;

--        nm_debug.debug('Inserting new shape');   
          Insert_Shape  (
                        Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Pk_Column,
                        pi_Ne_Id,
                        Irec.Nth_Feature_Shape_Column,
                        l_Shape,
                        l_Next,
                        pi_Effective_Date,
                        l_Count
                        );
--        nm_debug.debug('Inserted - count = '||l_count );                        
        Else
        
--        nm_debug.debug('No history');   

          -- Not using history but there is an existing shape to be swapped - just update
          
          Update_Shape (Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Pk_Column,
                        pi_Ne_Id,
                        Irec.Nth_Feature_Shape_Column,
                        l_Shape,
                        l_Count
                       );
                                
        End If;-- history
      End If; -- dates
      
    Else  -- either existing date is null or new shape is null
    
--    nm_debug.debug('either existing date is null or new shape is null');
      
      If l_Shape Is Not Null  Then
           Update_Shape (
                        Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Pk_Column,
                        pi_Ne_Id,
                        Irec.Nth_Feature_Shape_Column,
                        l_Shape,
                        l_Count
                        );

        If l_Count = 0  Then
          If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
            l_Next := Get_Next_Theme_Seq (Irec.Nth_Theme_Id);
          End If;

--        nm_debug.debug('Inserting new shape');
          Insert_Shape  (
                        Irec.Nth_Feature_Table,
                        Irec.Nth_Feature_Pk_Column,
                        pi_Ne_Id,
                        Irec.Nth_Feature_Shape_Column,
                        l_Shape,
                        l_Next,
                        pi_Effective_Date,
                        l_Count
                        );
        End If;
      Else  -- existing date is not null but new shape is null
--      nm_debug.debug(' existing date is not null but new shape is null');
        
        If pi_Use_History = 'Y' then
          End_Shape (
                    Irec.Nth_Feature_Table,
                    Irec.Nth_Feature_Pk_Column,
                    pi_Ne_Id,
                    pi_Effective_Date,
                    l_Count
                    );
        Else                
          Delete_Shape (
                      Irec.Nth_Feature_Table,
                      Irec.Nth_Feature_Pk_Column,
                      pi_Ne_Id,
                      l_Count
                      );
        End If; -- new shape is null and existing shape exists
      End If;
    End If;  
  End Loop;
  nm_debug.debug_off;
*/
End Reshape_Route;
--
-----------------------------------------------------------------------------
--
Procedure Delete_Route_Shape  (
                              p_Ne_Id In Number
                              )
Is

Begin
  For Irec In (
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Fk_Column,
                      nta.Nth_Feature_Shape_Column
              From    Nm_Themes_All     nta,
                      Nm_Nw_Themes      nnt,
                      User_Tables       ut,
                      Nm_Linear_Types   nlt,
                      Nm_Elements       ne
              Where   nta.Nth_Theme_Id  =   nnt.Nnth_Nth_Theme_Id
              And     ut.Table_Name     =   nta.Nth_Feature_Table
              And     nnt.Nnth_Nlt_Id   =   nlt.Nlt_Id
              And     nlt.Nlt_Gty_Type  =   ne.Ne_Gty_Group_Type
              And     nlt.Nlt_Nt_Type   =   ne.Ne_Nt_Type
              And     ne.Ne_Id          =   p_Ne_Id
              )
  Loop
    Execute Immediate    'delete from '
                     || Irec.Nth_Feature_Table
                     || ' where '
                     || Irec.Nth_Feature_Pk_Column
                     || ' = :ne_id'
    Using p_Ne_Id;
  End Loop;
End Delete_Route_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Restore_Route_Shape (P_Ne_Id In Number, P_Date In Date)
Is
  C_Str   Varchar2 (2000);
Begin
  For Irec In (
              Select  nta.Nth_Theme_Id,
                      nta.Nth_Feature_Table,
                      nta.Nth_Feature_Pk_Column,
                      nta.Nth_Feature_Fk_Column,
                      nta.Nth_Feature_Shape_Column
              From    Nm_Themes_All     nta,
                      Nm_Nw_Themes      nnt,
                      User_Tables       ut,
                      Nm_Linear_Types   nlt,
                      Nm_Elements       ne
              Where   nta.Nth_Theme_Id  =   nnt.Nnth_Nth_Theme_Id
              And     ut.Table_Name     =   nta.Nth_Feature_Table
              And     nnt.Nnth_Nlt_Id   =   nlt.Nlt_Id
              And     nlt.Nlt_Gty_Type  =   ne.Ne_Gty_Group_Type
              And     nlt.Nlt_Nt_Type   =   ne.Ne_Nt_Type
              And     ne.Ne_Id          =   p_Ne_Id
              )
  Loop
    C_Str :=  'update '
          || Irec.Nth_Feature_Table
          || ' set end_date = null where '
          || Irec.Nth_Feature_Pk_Column
          || ' = :ne_id and end_date = :end_date '
          || ' and start_date = ( select max (start_date) '
          || '  from '
          || Irec.Nth_Feature_Table
          || ' where ne_id = :ne_id '
          || '  and end_date = :end_date ) ';

    Execute Immediate C_Str
    Using   p_Ne_Id,
            p_Date,
            p_Ne_Id,
            p_Date;
  End Loop;
End Restore_Route_Shape;
--
-----------------------------------------------------------------------------
--
Procedure Refresh_Nt_Views
Is
Begin
  For Irec In (
              Select  nt.Nt_Type
              From    Nm_Types  nt
              )
  Loop
    Nm3Inv_View.Create_View_For_Nt_Type (pi_Nt_Type => Irec.Nt_Type);
  End Loop;
End Refresh_Nt_Views;
--
-----------------------------------------------------------------------------------------------------------------------------------
--
Procedure Make_Group_Layer  (
                            p_Nt_Type              In   Nm_Types.Nt_Type%Type,
                            p_Gty_Type             In   Nm_Group_Types.Ngt_Group_Type%Type,
                            Linear_Flag_Override   In   Varchar2   Default 'N',
                            p_Job_Id               In   Number     Default Null
                            )
As
  l_Nlt    Nm_Linear_Types.Nlt_Id%Type;
  l_View   Varchar2 (30)      := Get_Nt_View_Name (p_Nt_Type, p_Gty_Type);
Begin
  If Not User_Is_Unrestricted Then
    Raise E_Not_Unrestricted;
  End If;

  If Not Nm3Ddl.Does_Object_Exist (l_View, 'VIEW')  Then
     Nm3Inv_View.Create_View_For_Nt_Type (p_Nt_Type);
     
     If NM3NET.GET_GTY_SUB_GROUP_ALLOWED( p_Gty_Type) = 'N' then
        Nm3Inv_View.Create_Ft_Inv_For_Nt_Type  (
                                               pi_Nt_Type                  => p_Gty_Type,
                                               pi_Inv_Type                 => Null,
                                               pi_Delete_Existing_Inv_Type => True
                                               );
     End If;
  End If;

  If      Nm3Net.Is_Gty_Linear (p_Gty_Type)   = 'Y'
     And  Linear_Flag_Override                = 'N' Then
     
    l_Nlt := Get_Nlt_Id_From_Gty (p_Gty_Type);
    Make_Nt_Spatial_Layer (
                          pi_Nlt_Id =>  l_Nlt,
                          p_Job_Id  =>  p_Job_Id
                          );     
  Elsif NM3NET.get_gty_sub_group_allowed(p_Gty_Type) = 'N' then
    Create_Non_Linear_Group_Layer (
                                  p_Nt_Type   =>  p_Nt_Type,
                                  p_Gty_Type  =>  p_Gty_Type,
                                  p_Job_Id    =>  p_Job_Id
                                  );
  Else
    Create_G_of_G_Group_Layer(p_Nt_TYpe    => p_Nt_Type,
                              p_Gty_Type   => p_Gty_Type,
                              p_Job_Id     => p_Job_Id );
  End If;
Exception
  When E_Not_Unrestricted Then
    Raise_Application_Error (-20777,'Restricted users are not permitted to create SDO layers');
End Make_Group_Layer;
--
-----------------------------------------------------------------------------------------------------------------------------------
--
Procedure Create_G_of_G_Group_Layer (
                                        p_Nt_Type    In   Nm_Types.Nt_Type%Type,
                                        p_Gty_Type   In   Nm_Group_Types.Ngt_Group_Type%Type,
                                        p_Job_Id     In   Number Default Null
                                        )
As
  l_Tab              Nm_Themes_All.Nth_Feature_Table%Type;
  l_View             Nm_Themes_All.Nth_Table_Name%Type;
  l_Seq              Varchar2 (30);

  l_Base_Themes      Nm_Theme_Array;
  l_Diminfo          Mdsys.Sdo_Dim_Array;
  l_Srid             Number;

  l_Usgm             User_Sdo_Geom_Metadata%Rowtype;

  l_Theme_Id         Nm_Themes_All.Nth_Theme_Id%Type;
  l_V_Theme_Id       Nm_Themes_All.Nth_Theme_Id%Type;
--
  
function get_base_themes return nm_theme_array is
retval nm_theme_array := NM3ARRAY.INIT_NM_THEME_ARRAY;
begin
         select cast (collect (nm_theme_entry(nth_theme_id) ) as nm_theme_array_type )
         into retval.nta_theme_array
         from ( 
        select * from v_nm_sub_group_structure g, v_nm_network_themes t
        where g.child_nt_type    = t.nt_type (+)
        and   nvl(g.child_group_type,'£$%^') = nvl(t.gty_type, '£$%^')
--        and g.parent_group_type = 'GR20'
        and nth_base_table_theme is null
        and nth_feature_table not like 'SECT_SS%' ) t2
        where rownum = 1
        order by levl;
return retval;
end;        
   
--
-----------------------------------------------------------------------------------------------------------------
--Function Register_Nat_Theme (
--                            p_Nt_Type          In   Nm_Types.Nt_Type%Type,
--                            p_Gty_Type         In   Nm_Group_Types.Ngt_Group_Type%Type,
--                            p_Base_Themes      In   Nm_Theme_Array,
--                            p_Table_Name       In   Varchar2,
--                            p_Spatial_Column   In   Varchar2 Default 'GEOLOC',
--                            p_Fk_Column        In   Varchar2 Default 'NE_ID',
--                            p_Name             In   Varchar2 Default Null,
--                            p_View_Flag        In   Varchar2 Default 'N',
--                            p_Base_Table_Nth   In   Nm_Themes_All.Nth_Theme_Id%Type Default Null
--                            ) Return Number
--Is
--  Retval                    Number;
--  l_Nat_Id                  Number;
--  l_Name                    Varchar2 (30)                     := Nvl (p_Name, p_Table_Name);
--  l_Immediate_Or_Deferred   Varchar2 (1)                      := 'D';
--  l_Nat                     Nm_Area_Types%Rowtype;
--  l_Nth_Id                  Nm_Themes_All.Nth_Theme_Id%Type;
--  l_Nth                     Nm_Themes_All%Rowtype;
--  l_Rec_Ntg                 Nm_Theme_Gtypes%Rowtype;
--
--Begin
--
--  If p_View_Flag = 'Y'  Then
--    l_Immediate_Or_Deferred := 'N';                --no update for views
--  End If;
--
--  Select  Nat_Id_Seq.Nextval
--  Into    l_Nat_Id
--  From    Dual;
--
--  l_Nat.Nat_Id              :=  l_Nat_Id;
--  l_Nat.Nat_Nt_Type         :=  p_Nt_Type;
--  l_Nat.Nat_Gty_Group_Type  :=  p_Gty_Type;
--  l_Nat.Nat_Descr           :=  'Spatial Representation of ' || p_Gty_Type || ' Groups';
--  l_Nat.Nat_Seq_No          :=  1;
--  l_Nat.Nat_Start_Date      :=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--  l_Nat.Nat_End_Date        :=  Null;
--  l_Nat.Nat_Shape_Type      :=  'TRACED';
--
--  Begin
--    Insert Into Nm_Area_Types
--    (
--    Nat_Id,
--    Nat_Nt_Type,
--    Nat_Gty_Group_Type,
--    Nat_Descr,
--    Nat_Seq_No,
--    Nat_Start_Date,
--    Nat_End_Date,
--    Nat_Shape_Type
--    )
--    Values
--    (
--    l_Nat.Nat_Id,
--    l_Nat.Nat_Nt_Type,
--    l_Nat.Nat_Gty_Group_Type,
--    l_Nat.Nat_Descr,
--    l_Nat.Nat_Seq_No,
--    l_Nat.Nat_Start_Date,
--    l_Nat.Nat_End_Date,
--    l_Nat.Nat_Shape_Type
--    );
--  Exception
--    When Dup_Val_On_Index Then
--      Select  nat.Nat_Id
--      Into    l_Nat_Id
--      From    Nm_Area_Types nat
--      Where   nat.Nat_Nt_Type         =   p_Nt_Type
--      And     nat.Nat_Gty_Group_Type  =   p_Gty_Type;
--  End;
--
--  Retval := Nm3Seq.Next_Nth_Theme_Id_Seq;
--
--  nm_debug.debug('Assemble theme data - name = '||l_name );
--  -- generate the theme
--  l_Nth_Id              :=  Retval;
--  l_Nth.Nth_Theme_Id    :=  l_Nth_Id;
--  l_Nth.Nth_Theme_Name  :=  l_Name;
--  l_Nth.Nth_Table_Name  :=  p_Table_Name;
--  l_Nth.Nth_Where       :=  Null;
--  l_Nth.Nth_Pk_Column   :=  'NE_ID';
--  --
--  -- Task ID 0107889 - Set Label Column to NE_ID for Group layer base table themes
--  -- 05/10/09 AE Further restrict on the non DT theme 
--  --
--    
--  If      p_Base_Table_Nth      Is        Null
--      Or  l_Nth.Nth_Theme_Name  Not Like  '%DT' Then
--    l_Nth.Nth_Label_Column := 'NE_ID';
--  Else
--    l_Nth.Nth_Label_Column := 'NE_UNIQUE';
--  End If;
--  --
--  nm_debug.debug('Theme creation ');
--  
--  l_Nth.Nth_Rse_Table_Name        :=  'NM_ELEMENTS';
--  l_Nth.Nth_Rse_Fk_Column         :=  Null;
--  l_Nth.Nth_St_Chain_Column       :=  Null;
--  l_Nth.Nth_End_Chain_Column      :=  Null;
--  l_Nth.Nth_X_Column              :=  Null;
--  l_Nth.Nth_Y_Column              :=  Null;
--  l_Nth.Nth_Offset_Field          :=  Null;
--  l_Nth.Nth_Feature_Table         :=  p_Table_Name;
--  l_Nth.Nth_Feature_Pk_Column     :=  'NE_ID';
--  l_Nth.Nth_Feature_Fk_Column     :=  P_Fk_Column;
--  l_Nth.Nth_Xsp_Column            :=  Null;
--  l_Nth.Nth_Feature_Shape_Column  :=  p_Spatial_Column;
--  l_Nth.Nth_Hpr_Product           :=  'NET';
--  l_Nth.Nth_Location_Updatable    :=  'N';
--  l_Nth.Nth_Theme_Type            :=  'SDO';
--  l_Nth.Nth_Dependency            :=  'D';
--  l_Nth.Nth_Storage               :=  'S';
--  l_Nth.Nth_Update_On_Edit        :=  l_Immediate_Or_Deferred;
--  l_Nth.Nth_Use_History           :=  'Y';
--  l_Nth.Nth_Start_Date_Column     :=  'START_DATE';
--  l_Nth.Nth_End_Date_Column       :=  'END_DATE';
--  l_Nth.Nth_Base_Table_Theme      :=  p_Base_Table_Nth;
--  l_Nth.Nth_Sequence_Name         :=  'NTH_' || Nvl(p_Base_Table_Nth,Retval) || '_SEQ';
--  l_Nth.Nth_Snap_To_Theme         :=  'N';
--  l_Nth.Nth_Lref_Mandatory        :=  'N';
--  l_Nth.Nth_Tolerance             :=  10;
--  l_Nth.Nth_Tol_Units             :=  1;
--  nm_debug.debug('Theme creation - '||l_Nth.nth_theme_id);
--
--  Nm3Ins.Ins_Nth (l_Nth);
--  nm_debug.debug('Theme creation - inserted ');
--  --
--  --  Build theme gtype rowtype
--  l_Rec_Ntg.Ntg_Theme_Id  :=  l_Nth_Id;
--  l_Rec_Ntg.Ntg_Seq_No    :=  1;
--  l_Rec_Ntg.Ntg_Xml_Url   :=  Null;
--  l_Rec_Ntg.Ntg_Gtype     :=  '2006';
--  Nm3Ins.Ins_Ntg (p_Rec_Ntg => l_Rec_Ntg);
--
--  -- generate the link
--  Insert Into Nm_Area_Themes
--  (
--  Nath_Nat_Id,
--  Nath_Nth_Theme_Id
--  )
--  Values
--  (
--  l_Nat_Id,
--  l_Nth_Id
--  );
--    
----  Create_Base_Themes( l_Nth_Id, p_Base_Themes );
--
--  If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then 
--    Execute Immediate (   'begin '
--                      || '    nm3sde.register_sde_layer( p_theme_id => '||To_Char( l_Nth.Nth_Theme_Id )||');'
--                      || 'end;'
--                      );
--  End If;
--
--  If p_View_Flag = 'N'  Then
--      
--    Declare
--      l_Role   Varchar2 (30);
--    Begin
--      l_Role := Hig.Get_Sysopt ('SDONETROLE');
--
--      If l_Role Is Not Null Then
--          
--        Insert Into Nm_Theme_Roles
--        (
--        Nthr_Theme_Id,
--        Nthr_Role,
--        Nthr_Mode
--        )
--        Values
--        (
--        l_Nth_Id,
--        l_Role,
--        'NORMAL'
--        );
--          
--      End If;
--    End;
--  End If;
--
--  Declare
--    l_Type Number;
--  Begin
--    If Nm3Net.Get_Gty_Sub_Group_Allowed( p_Gty_Type ) = 'Y' Then
--      l_Type := 3;
--    Else
--      l_Type := 2;
--    End If;
--      
----    Create_Theme_Functions( p_Theme => l_Nth.Nth_Theme_Id, p_Pa => g_Network_Modules, p_Exclude => l_Type );
--      
--  End;
--
--  Return l_Nth_Id;
--End Register_Nat_Theme;
--
--
Procedure Create_Spatial_Table  (
                                p_Table               In   Varchar2,
                                p_Start_Date_Column   In   Varchar2 Default Null,
                                p_End_Date_Column     In   Varchar2 Default Null
                                )
Is
  Cur_String            Varchar2 (2000);
  Con_String            Varchar2 (2000);
  Uk_String             Varchar2 (2000);
  b_Use_History         Constant Boolean :=p_Start_Date_Column Is Not Null And p_End_Date_Column Is Not Null;
Begin
  --

      If b_Use_History Then
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( objectid number(38) not null, '
                    || '   ne_id number(38) not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   '
                    || p_Start_Date_Column
                    || ' date, '
                    || '   '
                    || p_End_Date_Column
                    || ' date, date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
        Con_String :=  'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id, '
                    || p_Start_Date_Column
                    || ' )';
      Else  -- no history
        Cur_String :=  'create table '
                    || p_Table
                    || ' ( objectid number(38) not null, '
                    || '   ne_id number(38) not null, '
                    || '   geoloc mdsys.sdo_geometry not null,'
                    || '   date_created date, date_modified date,'
                    || '   modified_by varchar2(30), created_by varchar2(30) )';
        Con_String :=  'alter table '
                    || p_Table
                    || ' ADD CONSTRAINT '
                    || p_Table
                    || '_PK PRIMARY KEY '
                    || ' ( ne_id )';
      End If; -- history

      Uk_String :=  'alter table '
                 || p_Table
                 || ' ADD ( CONSTRAINT '
                 || p_Table
                 || '_UK UNIQUE '
                 || ' (objectid))';

      Execute Immediate Cur_String;

      Execute Immediate Con_String;
      
      Execute Immediate Uk_String;

 
  nm3ddl.create_synonym_for_object(p_object_name => p_Table);

End Create_Spatial_Table;
--
  

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
Begin

  nm_debug.delete_debug(true);
  nm_debug.debug_on;
  NM_DEBUG.DEBUG(l_tab);

  nm3ctx.set_context('PARENT_GROUP_TYPE', p_Gty_Type ); 

  l_Tab   := Get_Nat_Feature_Table_Name (p_Nt_Type, p_Gty_Type);  
  
  nm_debug.debug('Table name = '||l_tab );
  
--l_View  := Get_Nt_View_Name (p_Nt_Type, p_Gty_Type);

  l_Base_Themes := Get_Base_Themes;

  nm_debug.debug(to_char(l_base_themes.nta_theme_array(1).nthe_id));
  
  Nm3Sdo.Set_Diminfo_And_Srid( l_Base_Themes, l_Diminfo, l_Srid );
  
  if l_diminfo.count > 2 then

    l_Diminfo := Sdo_Lrs.Convert_To_Std_Dim_Array(l_Diminfo);
    
  end if;

  --check tha the effective date is today - otherwise the layer will be out of step already!
  --generate the area type
  --
  nm_debug.debug('Creating spatial table ');
  
  Create_Spatial_Table (l_Tab, 'START_DATE', 'END_DATE');
  
  nm_debug.debug('Created Table '||l_Tab );
  ---------------------------------------------------------------
  -- Set the registration of metadata
  ---------------------------------------------------------------
  l_Usgm.Table_Name  := l_Tab;
  l_Usgm.Column_Name := 'GEOLOC';
  l_Usgm.Diminfo     := l_Diminfo;
  l_Usgm.Srid        := l_Srid;

  Nm3Sdo.Ins_Usgm ( l_Usgm );

  l_Theme_Id := Register_Nat_Theme  (
                                    p_Nt_Type,
                                    p_Gty_Type,
                                    l_Base_Themes,
                                    l_Tab,
                                    'GEOLOC',
                                    'NE_ID',
                                    Null,
                                    'N'
                                    );
  l_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);

--  If Not Nm3Ddl.Does_Object_Exist (l_View, 'VIEW')  Then
--    Nm3Inv_View.Create_View_For_Nt_Type (p_Nt_Type, p_Gty_Type);
--  End If;

/*
  Create_Spatial_Date_View (l_Tab);

  l_Usgm.Table_Name  := 'V_' || l_Tab;
  Nm3Sdo.Ins_Usgm ( l_Usgm );

  l_V_Theme_Id := Register_Nat_Theme  (
                                      p_Nt_Type,
                                      p_Gty_Type,
                                      l_Base_Themes,
                                      'V_' || L_Tab,
                                      'GEOLOC',
                                      'NE_ID',
                                      'V_'|| L_Tab,
                                      'Y',
                                      l_Theme_Id
                                      );
*/                  

  nm_debug.debug_on;
  nm_debug.debug('Creating data');                    
                                      
  nm3sdo.create_gofg_Data (
                                p_Table_Name    => l_Tab,
                                p_Gty_Type      => p_Gty_Type,
                                p_Seq_Name      => l_Seq,
                                p_Job_Id        => p_Job_Id
                                );
  --table needs a spatial index

  Nm3Sdo.Create_Spatial_Idx (l_Tab);


  --need a join view between spatial table and NT view

/* No need for these view types yet 

  l_View := nm3sdm.Create_Nat_Sdo_Join_View  (
                                      p_Feature_Table_Name  => l_Tab
                                      ); 
  l_Usgm.Table_Name  := l_View;

  Nm3Sdo.Ins_Usgm ( l_Usgm );

  If G_Date_Views = 'Y' Then
    L_V_Theme_Id := Register_Nat_Theme  (
                                        p_Nt_Type,
                                        p_Gty_Type,
                                        l_Base_Themes,
                                        l_View,
                                        'GEOLOC',
                                        'NE_ID',
                                        Null,
                                        'Y',
                                        l_Theme_Id
                                       );
  End If;
*/

  Begin
    Nm3Ddl.Analyse_Table  (
                          pi_Table_Name          => l_Tab,
                          pi_Schema              => Sys_Context('NM3CORE','APPLICATION_OWNER'),
                          pi_Estimate_Percentage => Null,
                          pi_Auto_Sample_Size    => False
                          );
--  Exception
--    When Others Then
--      Raise E_No_Analyse_Privs;
  End;
  --
--  Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
  --
--Exception
--  When E_Not_Unrestricted Then
--    Raise_Application_Error (-20777,'Restricted users are not permitted to create SDO layers');
--  
--  When E_No_Analyse_Privs Then
--    Raise_Application_Error (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
--                                    'Please ensure the correct role/privs are applied to the user');

End Create_G_of_G_Group_Layer;
--
------------------------------------
--


Procedure Create_Non_Linear_Group_Layer (
                                        p_Nt_Type    In   Nm_Types.Nt_Type%Type,
                                        p_Gty_Type   In   Nm_Group_Types.Ngt_Group_Type%Type,
                                        p_Job_Id     In   Number Default Null
                                        )
As
  l_Tab              Nm_Themes_All.Nth_Feature_Table%Type;
  l_View             Nm_Themes_All.Nth_Table_Name%Type;
  l_Seq              Varchar2 (30);

  l_Base_Themes      Nm_Theme_Array;
  l_Diminfo          Mdsys.Sdo_Dim_Array;
  l_Srid             Number;

  l_Usgm             User_Sdo_Geom_Metadata%Rowtype;

  l_Theme_Id         Nm_Themes_All.Nth_Theme_Id%Type;
  l_V_Theme_Id       Nm_Themes_All.Nth_Theme_Id%Type;

-----------------------------------------------------------------------------------------------------------------
Begin
  l_Tab   := Get_Nat_Feature_Table_Name (p_Nt_Type, p_Gty_Type);
  l_View  := Get_Nt_View_Name (p_Nt_Type, p_Gty_Type);

  l_Base_Themes := Get_Nat_Base_Themes(p_Gty_Type);

  Nm3Sdo.Set_Diminfo_And_Srid( l_Base_Themes, l_Diminfo, l_Srid );

  l_Diminfo := Sdo_Lrs.Convert_To_Std_Dim_Array(l_Diminfo);

  --check tha the effective date is today - otherwise the layer will be out of step already!
  --generate the area type
  --
  Create_Spatial_Table (l_Tab, False, 'START_DATE', 'END_DATE');
  
  ---------------------------------------------------------------
  -- Set the registration of metadata
  ---------------------------------------------------------------
  l_Usgm.Table_Name  := l_Tab;
  l_Usgm.Column_Name := 'GEOLOC';
  l_Usgm.Diminfo     := l_Diminfo;
  l_Usgm.Srid        := l_Srid;

  Nm3Sdo.Ins_Usgm ( l_Usgm );

  l_Theme_Id := Register_Nat_Theme  (
                                    p_Nt_Type,
                                    p_Gty_Type,
                                    l_Base_Themes,
                                    l_Tab,
                                    'GEOLOC',
                                    'NE_ID',
                                    Null,
                                    'N'
                                    );
  l_Seq := Nm3Sdo.Create_Spatial_Seq (l_Theme_Id);

  If Not Nm3Ddl.Does_Object_Exist (l_View, 'VIEW')  Then
    Nm3Inv_View.Create_View_For_Nt_Type (p_Nt_Type, p_Gty_Type);
  End If;

  Create_Spatial_Date_View (l_Tab);

  l_Usgm.Table_Name  := 'V_' || l_Tab;
  Nm3Sdo.Ins_Usgm ( l_Usgm );

  l_V_Theme_Id := Register_Nat_Theme  (
                                      p_Nt_Type,
                                      p_Gty_Type,
                                      l_Base_Themes,
                                      'V_' || L_Tab,
                                      'GEOLOC',
                                      'NE_ID',
                                      Null,
                                      'Y',
                                      l_Theme_Id
                                      );
  Nm3Sdo.Create_Non_Linear_Data (
                                p_Table_Name    => l_Tab,
                                p_Gty_Type      => p_Gty_Type,
                                p_Seq_Name      => l_Seq,
                                p_Job_Id        => p_Job_Id
                                );
  --table needs a spatial index

  Nm3Sdo.Create_Spatial_Idx (l_Tab);

  --need a join view between spatial table and NT view

  l_View := Create_Nat_Sdo_Join_View  (
                                      p_Feature_Table_Name  => l_Tab
                                      ); 
  l_Usgm.Table_Name  := l_View;

  Nm3Sdo.Ins_Usgm ( l_Usgm );

  If G_Date_Views = 'Y' Then
    L_V_Theme_Id := Register_Nat_Theme  (
                                        p_Nt_Type,
                                        p_Gty_Type,
                                        l_Base_Themes,
                                        l_View,
                                        'GEOLOC',
                                        'NE_ID',
                                        Null,
                                        'Y',
                                        l_Theme_Id
                                       );
  End If;

  Begin
    Nm3Ddl.Analyse_Table  (
                          pi_Table_Name          => l_Tab,
                          pi_Schema              => Sys_Context('NM3CORE','APPLICATION_OWNER'),
                          pi_Estimate_Percentage => Null,
                          pi_Auto_Sample_Size    => False
                          );
  Exception
    When Others Then
      Raise E_No_Analyse_Privs;
  End;
  --
  Nm_Debug.Proc_End (G_Package_Name, 'make_ona_inv_spatial_layer');
  --
Exception
  When E_Not_Unrestricted Then
    Raise_Application_Error (-20777,'Restricted users are not permitted to create SDO layers');
  
  When E_No_Analyse_Privs Then
    Raise_Application_Error (-20778,'Layer created - but user does not have ANALYZE ANY granted. '||
                                    'Please ensure the correct role/privs are applied to the user');

End Create_Non_Linear_Group_Layer;
--
----------------------------------------------------------------------------------------------------------------------------------
--
Function Get_Theme_From_Feature_Table (
                                      p_Table   In   Nm_Themes_All.Nth_Feature_Table%Type
                                      ) Return Number
Is
  Retval   Number;
Begin
  Begin
    Select  nta.Nth_Theme_Id
    Into    Retval
    From    Nm_Themes_All   nta
    Where   nta.Nth_Feature_Table =   p_Table
    And     rownum                =   1;
  Exception
    When No_Data_Found Then 
      Retval := Null;
  End;

  Return Retval;
End Get_Theme_From_Feature_Table;
------------------------------------------------------------------------
Function Get_Theme_From_Feature_Table (
                                      p_Table         In   Nm_Themes_All.Nth_Feature_Table%Type,
                                      p_Theme_Table   In   Nm_Themes_All.Nth_Table_Name%Type
                                      ) Return Number
Is
  Retval   Number;
Begin
  Begin
    Select  nta.Nth_Theme_Id
    Into    Retval
    From    Nm_Themes_All   nta
    Where   nta.Nth_Feature_Table = p_Table
    And     nta.Nth_Table_Name    = p_Theme_Table;
  Exception
    When No_Data_Found Then
      Retval:=Null;
  End;
  Return Retval;
End Get_Theme_From_Feature_Table;
--
----------------------------------------------------------------------------------------------------------------------------------
--
Procedure Drop_Unused_Sequences
Is
Begin
  For Irec In (
              Select  usq.Sequence_Name
              From    User_Sequences    usq
              Where   usq.Sequence_Name   Like 'NTH%'
              And     Not Exists          (
                                          Select  Null
                                          From    Nm_Themes_All nta
                                          Where   To_Char (nta.Nth_Theme_Id) =  Substr (usq.Sequence_Name,5,Instr (Substr (usq.Sequence_Name, 5), '_')- 1)
                                          )
              And     usq.Sequence_Name   !=  'NTH_THEME_ID_SEQ'
              )
  Loop
    Nm3Ddl.Drop_Synonym_For_Object (Irec.Sequence_Name);
    Execute Immediate 'drop sequence ' || Irec.Sequence_Name;
  End Loop;
End Drop_Unused_Sequences;
--
----------------------------------------------------------------------------------------------------------------------------------
--
-- When updating members, test to see if a theme is immediate - not appropriate to linear layers
--
Function Get_Update_Flag  (
                          p_Type          In   Varchar2,
                          p_Obj_Type      In   Varchar2,
                          p_Update_Flag   In   Varchar2 Default Null
                          ) Return Varchar2
Is
  Retval   Nm_Themes_All.Nth_Update_On_Edit%Type:= 'N';

Begin
  If p_Type = 'I' Then
    Begin
      Select  nta.Nth_Update_On_Edit
      Into    Retval
      From    Nm_Themes_All   nta,
              Nm_Inv_Themes   nit
      Where   nta.Nth_Theme_Id        =   nit.Nith_Nth_Theme_Id
      And     nit.Nith_Nit_Id         =   p_Obj_Type
      And     nta.Nth_Update_On_Edit  =   Decode (p_Update_Flag,Null, nta.Nth_Update_On_Edit,p_Update_Flag)
      And     rownum                  =   1;
    Exception
      When No_Data_Found Then
        Retval := 'N';        
    End;

  Elsif p_Type = 'G'  Then
    Begin     
      Select  nta.Nth_Update_On_Edit
      Into    Retval
      From    Nm_Themes_All   nta,
              Nm_Area_Themes  nat,
              Nm_Area_Types   naty
      Where   nta.Nth_Theme_Id        =   nat.Nath_Nth_Theme_Id
      And     nat.Nath_Nat_Id         =   naty.Nat_Id
      And     naty.Nat_Gty_Group_Type =   p_Obj_Type
      And     nta.Nth_Update_On_Edit  =   Decode (p_Update_Flag,Null, nta.Nth_Update_On_Edit,p_Update_Flag)
      And     Rownum                  =   1;
    Exception
      When No_Data_Found Then 
        Retval := 'N';
    End;
  End If;

  Return Retval;
End Get_Update_Flag;
--
-------------------------------------------------------------------------------------------------------------------------------
--
Procedure Attach_Theme_To_Ft  (
                              p_Nth_Id In Number,
                              p_Ft_Nit In Varchar2
                              )
Is
  l_Nth   Nm_Themes_All%Rowtype;
  l_Nit   Nm_Inv_Types%Rowtype;
Begin
  l_Nth := Nm3Get.Get_Nth (p_Nth_Id);
  l_Nit := Nm3Get.Get_Nit (p_Ft_Nit);

  If l_Nth.Nth_Table_Name != l_Nit.Nit_Table_Name Then
    Hig.Raise_Ner (
                  pi_Appl         =>  Nm3Type.C_Hig,
                  pi_Id           =>  249,
                  pi_Sqlcode      =>  -20001
                  );
    --  raise_application_error(-20001,'FT and theme do not match');
  Else
    Insert Into Nm_Inv_Themes
    (
    Nith_Nit_Id,
    Nith_Nth_Theme_Id
    )
    Values
    (
    l_Nit.Nit_Inv_Type,
    l_Nth.Nth_Theme_Id
    );
  End If;
End Attach_Theme_To_Ft;
--
-------------------------------------------------------------------------------------------------------------------------------
--
Procedure Register_Sdo_Table_As_Ft_Theme  (
                                          p_Nit_Type           In   Nm_Inv_Types.Nit_Inv_Type%Type,
                                          p_Shape_Col          In   Varchar2,
                                          p_Tol                In   Number Default 0.005,
                                          p_Cre_Idx            In   Varchar2 Default 'N',
                                          p_Estimate_New_Tol   In   Varchar2 Default 'N'
                                          )
Is
  l_Nit      Nm_Inv_Types%Rowtype;
  l_Nth_Id   Number;
Begin
  l_Nit := Nm3Get.Get_Nit (p_Nit_Type);

  If L_Nit.Nit_Table_Name Is Null Then
    
    Hig.Raise_Ner (
                  pi_Appl         =>  Nm3Type.C_Hig,
                  pi_Id           =>  250,
                  pi_Sqlcode      =>  -20001
                  );
    --  raise_application_error( -20001, 'Inventory type is not a foreign table');
  End If;

  Nm3Sdo.Register_Sdo_Table_As_Theme  (
                                      l_Nit.Nit_Table_Name,
                                      l_Nit.Nit_Foreign_Pk_Column,
                                      l_Nit.Nit_Foreign_Pk_Column,
                                      p_Shape_Col,
                                      p_Tol,
                                      p_Cre_Idx,
                                      p_Estimate_New_Tol
                                      );
  l_Nth_Id := Get_Theme_From_Feature_Table  (
                                            l_Nit.Nit_Table_Name
                                            );
  Attach_Theme_To_Ft  (
                      l_Nth_Id,
                      l_Nit.Nit_Inv_Type
                      );
  
End Register_Sdo_Table_As_Ft_Theme;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Drop_Trigger_By_Theme_Id  (
                                    p_Nth_Id In Nm_Themes_All.Nth_Theme_Id%Type
                                    )
Is
  -- CWS 0110345 Trigger changed to ignore nm_themes_all. Table nm_themes_all 
  -- is no longer referenced in cursor and any exception raised by dynamic sql
  -- will be caught. 
  --
Begin
  For Irec In (
              Select  ut.Trigger_Name
              From    User_Triggers     ut
              Where   ut.Trigger_Name   Like 'NM_NTH_' || To_Char(p_Nth_Id) || '_SDO%'
              )
  Loop
    Begin
      Execute Immediate 'DROP TRIGGER '||Irec.Trigger_Name;
    Exception
      When Others Then
        Null;
    End;
 End Loop;
End Drop_Trigger_By_Theme_Id;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Drop_Layer  (
                      p_Nth_Id               In   Nm_Themes_All.Nth_Theme_Id%Type,
                      p_Keep_Theme_Data      In   Varchar2 Default 'N',
                      p_Keep_Feature_Table   In   Varchar2 Default 'N'
                      )
Is
  l_Nth         Nm_Themes_All%Rowtype;
  l_Seq         Varchar2 (30);
--
Begin
  l_Nth := Nm3Get.Get_Nth (p_Nth_Id);

  Drop_Trigger_By_Theme_Id( p_Nth_Id );

  If l_Nth.Nth_Feature_Table Is Not Null  Then
    If Hig.Get_Sysopt ('REGSDELAY') = 'Y' Then
      
      Declare             
       Not_There   Exception;
        Pragma Exception_Init (Not_There, -20001);
      Begin
        Execute Immediate (  'begin '
                          || '   nm3sde.drop_layer_by_theme( p_theme_id => '
                          || To_Char (L_Nth.Nth_Theme_Id)
                          || ');'
                          || 'end;'
                          );
      Exception
        When Not_There  Then
          Null;
      End;
      
    End If;

    If p_Keep_Feature_Table = 'N' Then
      Begin
        -- AE 23-SEP-2008
        -- Drop views instead of synonyms
        Nm3Ddl.Drop_Views_For_Object (l_Nth.Nth_Feature_Table);

      Exception
        When Others Then
          Null;
        --    problem in privileges on the development schema - dropping synonyms failed - needs further investigation.
      End;

      Begin
        --cws
        Nm3Ddl.Drop_Synonym_For_Object (l_Nth.Nth_Feature_Table);

      Exception
        When Others  Then
          Null;
          --    problem in privileges on the development schema - dropping synonyms failed - needs further investigation.
      End;

      Drop_Object (l_Nth.Nth_Feature_Table);
      Nm3Sdo.Drop_Metadata (l_Nth.Nth_Feature_Table);

      If Nm3Sdo.Use_Surrogate_Key = 'Y' Then
        l_Seq := Nm3Sdo.Get_Spatial_Seq (p_Nth_Id);

        If Nm3Ddl.Does_Object_Exist (l_Seq) Then
          Begin
            Nm3Ddl.Drop_Synonym_For_Object (l_Seq);
          Exception
            When Others Then
              Null;
          End;
          Drop_Object (l_Seq);
        End If;
      End If;     
    End If; -- keep feature table end if
  End If;
  --
  If p_Keep_Theme_Data = 'N'  Then
    Delete
    From  Nm_Themes_All nta
    Where nta.Nth_Theme_Id = p_Nth_Id;
  End If;
  --
End Drop_Layer;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Function Get_Object_Type  (
                          p_Object In Varchar2
                          ) Return Varchar2
Is
  Retval    Varchar2 (30);
Begin
  Begin
    Select  ao.Object_Type
    Into    Retval
    From    All_Objects   ao
    Where   ao.Owner        =   Sys_Context('NM3CORE','APPLICATION_OWNER')
    And     ao.Object_Name  =   p_Object
    And     Rownum          =   1;
  Exception
    When No_Data_Found Then
      Hig.Raise_Ner (
                    pi_Appl         =>  Nm3Type.C_Hig,
                    pi_Id           =>  257,
                    pi_Sqlcode      =>  -20001
                    );
  End;
  
  Return Retval;
End Get_Object_Type;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Drop_Object (
                      p_Object_Name In Varchar2
                      )
Is
  l_Obj_Type   Varchar2 (30);
  Pragma Autonomous_Transaction;
Begin
  If Nm3Ddl.Does_Object_Exist (p_Object_Name) Then
    l_Obj_Type := Get_Object_Type (p_Object_Name);
    
    Execute Immediate 'drop ' || l_Obj_Type || ' ' || p_Object_Name;
    
  End If;
End Drop_Object;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Drop_Layers_By_Inv_Type (
                                  p_Nit_Id       In   Nm_Inv_Types.Nit_Inv_Type%Type,
                                  p_Keep_Table   In   Boolean Default False
                                  )
Is
  l_Tab_Nth_Id   Nm3Type.Tab_Number;
  l_Keep_Table   Varchar2 (1);
  
Begin
  If p_Keep_Table Then
     l_Keep_Table := 'Y';
  Else
     l_Keep_Table := 'N';
  End If;

  Select      nit.Nith_Nth_Theme_Id
  Bulk Collect
  Into        l_Tab_Nth_Id
  From        Nm_Inv_Themes   nit,
              Nm_Themes_All   nta
  Where       nit.Nith_Nit_Id   =   p_Nit_Id
  And         nta.Nth_Theme_Id  =   nit.Nith_Nth_Theme_Id
  Order By    Decode(Nth_Base_Table_Theme, Null, 'B', 'A');

  For i In 1 .. l_Tab_Nth_Id.Count
  Loop
    Nm3Sdm.Drop_Layer (
                      p_Nth_Id                  => l_Tab_Nth_Id (i),
                      p_Keep_Feature_Table      => l_Keep_Table
                      );
  End Loop;
End Drop_Layers_By_Inv_Type;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Drop_Layers_By_Gty_Type (
                                  p_Gty   In   Nm_Group_Types.Ngt_Group_Type%Type
                                  )
Is
  --
  l_Tab_Nth_Id   Nm3Type.Tab_Number;
  l_Tab_Order    Nm3Type.Tab_Varchar1;
  --
Begin
  Select        nnt.Nnth_Nth_Theme_Id,
                Decode(nta.Nth_Base_Table_Theme, Null, 'A', 'B')
  Bulk Collect 
  Into          l_Tab_Nth_Id,
                l_Tab_Order
  From          Nm_Nw_Themes      nnt,
                Nm_Linear_Types   nlt,
                Nm_Themes_All     nta
  Where         nnt.Nnth_Nlt_Id       =    nlt.Nlt_Id
  And           nlt.Nlt_Gty_Type      =   p_Gty
  And           nnt.Nnth_Nth_Theme_Id =   nta.Nth_Theme_Id
  Union
  Select        Nath_Nth_Theme_Id,
                Decode(Nth_Base_Table_Theme, Null, 'A', 'B')
  From          Nm_Area_Themes    nat,
                Nm_Area_Types     naty,
                Nm_Themes_All     nta
  Where         nat.Nath_Nat_Id           =   naty.Nat_Id
  And           naty.Nat_Gty_Group_Type   =   p_Gty
  And           nat.Nath_Nth_Theme_Id     =   nta.Nth_Theme_Id
  Order By 2 Desc;

  For i In 1 .. l_Tab_Nth_Id.Count
  Loop
     Drop_Layer (p_Nth_Id => l_Tab_Nth_Id (i));
  End Loop;
End Drop_Layers_By_Gty_Type;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Function Type_Has_Shape (
                        p_Type In Varchar2
                        )  Return Boolean
Is
  Retval   Boolean;
  Dummy   Varchar2(1);
Begin
  Begin
    Select  Null
    Into    Dummy
    From    Dual
    Where   Exists (
                   Select Null
                   From   Nm_Area_Types
                   Where  Nat_Gty_Group_Type = p_Type
                   Union
                   Select Null
                   From   Nm_Inv_Themes
                   Where  Nith_Nit_Id = p_Type
                   );
    Retval:=True;                   
  Exception
    When No_Data_Found Then
      Retval:=False;
  End;

  Return Retval;
End Type_Has_Shape;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Function Theme_Is_Ft  (
                      P_Nth_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                      ) Return Boolean
Is
  Retval    Boolean := False;
  l_Dummy   Number;
Begin
  Begin
    Select  Null
    Into    l_Dummy
    From    Nm_Themes_All   nta,
            Nm_Inv_Themes   nith,
            Nm_Inv_Types    nit
    Where   nta.Nth_Theme_Id    =   nith.Nith_Nth_Theme_Id
    And     nith.Nith_Nit_Id    =   Nit_Inv_Type
    And     nit.Nit_Table_Name  Is  Not Null
    And     rownum              =   1;
    
    Retval:=True;
    
  Exception
    When No_Data_Found Then
      Retval:=False;
  End;          

  Return Retval;
End Theme_Is_Ft;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Set_Subuser_Globals_Nthr  (
                                    pi_Role       In   Nm_Theme_Roles.Nthr_Role%Type,
                                    pi_Theme_Id   In   Nm_Theme_Roles.Nthr_Theme_Id%Type,
                                    pi_Mode       In   Varchar2
                                    )
Is
Begin
  g_Role_Array (g_Role_Idx) := pi_Role;
  g_Theme_Role (g_Role_Idx) := pi_Theme_Id;
  g_Role_Op (g_Role_Idx)    := pi_Mode;
End Set_Subuser_Globals_Nthr;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Set_Subuser_Globals_Hur (
                                  pi_Role       In   Nm_Theme_Roles.Nthr_Role%Type,
                                  pi_Username   In   Hig_User_Roles.Hur_Username%Type,
                                  pi_Mode       In   Varchar2
                                  )
Is
Begin
  g_Role_Array (g_Role_Idx)     := pi_Role;
  g_Username_Array (g_Role_Idx) := pi_Username;
  g_Role_Op (g_Role_Idx)        := pi_Mode;
End Set_Subuser_Globals_Hur;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Drop_Feature_View (
                            pi_Owner In Varchar2,
                            pi_View_Name In Varchar2
                            )
Is
  Pragma Autonomous_Transaction;
Begin
  Begin
    Execute Immediate 'DROP VIEW '||pi_Owner||'.'||pi_View_Name;
  Exception
    When Others Then
      Null;
  End;

  Begin
    Execute Immediate 'DROP SYNONYM '||pi_Owner||'.'||pi_View_Name;
  Exception
    When Others Then
    Null;
  End;
End Drop_Feature_View;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Create_Feature_View (
                              pi_Owner In Varchar2,
                              pi_View_Name In Varchar2
                              )
Is
  Pragma Autonomous_Transaction;
Begin
  Begin
    -- CWS
    Execute Immediate 'DROP VIEW '|| pi_Owner||'.'|| pi_View_Name;
  Exception
    When Others Then
      Null;
  End;
  
  Begin
    -- CWS
    Execute Immediate ('CREATE OR REPLACE SYNONYM '|| pi_Owner ||'.'|| pi_View_Name || ' FOR ' || Sys_Context('NM3CORE','APPLICATION_OWNER') || '.' || pi_View_Name);
  Exception
    When Others Then
      Null;
  End;
End Create_Feature_View;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Process_Subuser_Nthr
  /* Procedure to deal with creating subordinate user metadata triggered on
   nm_theme_roles data */
Is
  --
  Procedure Create_Sub_Sdo_Layer  (
                                  pi_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type,
                                  pi_Role     In Nm_Theme_Roles.Nthr_Role%Type
                                  )
  Is
  Begin
    --
    -- Insert the USGM based on current theme and role
    --
    nm_debug.debug_on;
    nm_debug.debug('Running Create_Sub_Sdo_Layer from Process_Subuser_Nthr for '||pi_theme_id||' - '||pi_role);
    Insert Into Mdsys.Sdo_Geom_Metadata_Table G
    (
    Sdo_Owner,
    Sdo_Table_Name,
    Sdo_Column_Name,
    Sdo_Diminfo,
    Sdo_Srid
    )
    Select  x.Hus_Username,
            x.Nth_Feature_Table,
            x.Nth_Feature_Shape_Column,
            u.Sdo_Diminfo,
            u.Sdo_Srid
    From    Mdsys.Sdo_Geom_Metadata_Table u,
            (
            Select  y.Hus_Username,
                    y.Nth_Feature_Table,
                    y.Nth_Feature_Shape_Column
            From   -- Layers based on role - more than likely views
                   (
                   Select   hu.Hus_Username,
                            nta.Nth_Feature_Table,
                            nta.Nth_Feature_Shape_Column
                   From     Nm_Themes_All     nta,
                            Nm_Theme_Roles    ntr,
                            Hig_User_Roles    hur,
                            Hig_Users         hu,
                            All_Users         au
                  Where     Nthr_Theme_Id     =       nta.Nth_Theme_Id
                  And       nta.Nth_Theme_Id  =       pi_Theme_Id
                  And       ntr.Nthr_Role     =       hur.Hur_Role
                  And       hur.Hur_Role      =       pi_Role
                  And       hur.Hur_Username  =       hu.Hus_Username
                  And       hu.Hus_Username   =       au.Username
                  And       hu.Hus_Username   !=      Sys_Context('NM3CORE','APPLICATION_OWNER')
                  And       Not               Exists  (
                                                      Select  Null
                                                      From    Mdsys.Sdo_Geom_Metadata_Table g1
                                                      Where   g1.Sdo_Owner        =   hu.Hus_Username
                                                      And     g1.Sdo_Table_Name   =   nta.Nth_Feature_Table
                                                      And     g1.Sdo_Column_Name  =   nta.Nth_Feature_Shape_Column
                                                      )
                  Union All
                  -- Base table themes
                  Select  hu.Hus_Username,
                          nta2.Nth_Feature_Table,
                          nta2.Nth_Feature_Shape_Column
                  From    Nm_Themes_All   nta,
                          Hig_Users       hu,
                          All_Users       au,
                          Nm_Themes_All   nta2
                  Where   nta2.Nth_Theme_Id   =       nta.Nth_Base_Table_Theme
                  And     nta.Nth_Theme_Id    =       Pi_Theme_Id
                  And     hu.Hus_Username     =       au.Username
                  And     hu.Hus_Username     !=      Sys_Context('NM3CORE','APPLICATION_OWNER')
                  And     Not                 Exists  (
                                                      Select  Null
                                                      From    Mdsys.Sdo_Geom_Metadata_Table G1
                                                      Where   g1.Sdo_Owner        =   hu.Hus_Username
                                                      And     g1.Sdo_Table_Name   =   nta2.Nth_Feature_Table
                                                      And     g1.Sdo_Column_Name  =   nta2.Nth_Feature_Shape_Column
                                                      )
                  ) y
                  Group By  y.Hus_Username,
                            y.Nth_Feature_Table,
                            y.Nth_Feature_Shape_Column
            ) x
    Where   u.Sdo_Table_Name    =   x.Nth_Feature_Table
    And     u.Sdo_Column_Name   =   x.Nth_Feature_Shape_Column
    And     u.Sdo_Owner         =   Sys_Context('NM3CORE','APPLICATION_OWNER');

    For i In  (
              Select  x.Hus_Username,
                      x.Nth_Feature_Table,
                      x.Nth_Feature_Shape_Column
              From    -- Layers based on role - more than likely views
                      (
                      Select  hu.Hus_Username,
                              nta.Nth_Feature_Table,
                              nta.Nth_Feature_Shape_Column
                      From    Nm_Themes_All     nta,
                              Nm_Theme_Roles    ntr,
                              Hig_User_Roles    hur,
                              Hig_Users         hu,
                              All_Users         au
                      Where   ntr.Nthr_Theme_Id   =   nta.Nth_Theme_Id
                      And     nta.Nth_Theme_Id    =   pi_Theme_Id
                      And     ntr.Nthr_Role       =   hur.Hur_Role
                      And     hur.Hur_Role        =   pi_Role
                      And     hur.Hur_Username    =   hu.Hus_Username
                      And     hu.Hus_Username     =   au.Username
                      And     hu.Hus_Username     !=  Sys_Context('NM3CORE','APPLICATION_OWNER')
                      Union All
                      -- Base table themes
                      Select  Hus_Username,
                              nta2.Nth_Feature_Table,
                              nta2.Nth_Feature_Shape_Column
                      From    Nm_Themes_All   nta,
                              Hig_Users       hu,
                              All_Users       au,
                              Nm_Themes_All   nta2
                      Where   nta2.Nth_Theme_Id   =   nta.Nth_Base_Table_Theme
                      And     nta.Nth_Theme_Id    =   Pi_Theme_Id
                      And     hu.Hus_Username     =   au.Username
                      And     hu.Hus_Username     !=  Sys_Context('NM3CORE','APPLICATION_OWNER')
                      ) x
              Group By  x.Hus_Username,
                        x.Nth_Feature_Table,
                        x.Nth_Feature_Shape_Column
              )
  Loop
    --
    -- No longer required.
    --Create_Feature_View (I.Hus_Username, I.Nth_Feature_Table);
    
    If Hig.Get_User_Or_Sys_Opt('REGSDELAY') = 'Y' Then
    
      If NOT check_sub_sde_exempt( i.nth_feature_table ) Then

        Begin
          Execute Immediate(' begin '||
                              'nm3sde.create_sub_sde_layer ( p_theme_id => '|| pi_Theme_Id
                                                        || ',p_username => '''|| i.Hus_Username
                                                        || ''');'||
                                                          ' end;');
        Exception
          When Others Then
            Null;
        End;
      
      End If;

    End If;

  End Loop;

  End Create_Sub_Sdo_Layer;
  --
  --------------------------------------------------------------------------
  --
  Procedure Delete_Sub_Sdo_Layer  (
                                  pi_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type,
                                  pi_Role     In Nm_Theme_Roles.Nthr_Role%Type
                                  )
  Is
    l_Tab_Owner       Nm3Type.Tab_Varchar30;
    l_Tab_Table_Name  Nm3Type.Tab_Varchar30;
    l_Tab_Column_Name Nm3Type.Tab_Varchar30;
  --
  Begin
  --
    Select        Hus_Username,
                  Nth_Feature_Table,
                  Nth_Feature_Shape_Column
    Bulk Collect 
    Into          l_Tab_Owner,
                  l_Tab_Table_Name,
                  l_Tab_Column_Name
    From          (
                  Select  Hus_Username,
                          Nth_Feature_Table,
                          Nth_Feature_Shape_Column
                  From    (
                          Select  hu.Hus_Username,
                                  nta.Nth_Feature_Table,
                                  nta.Nth_Feature_Shape_Column
                          From    Nm_Themes_All     nta,
                                  Hig_User_Roles    hur,
                                  Hig_Users         hu,
                                  All_Users         au
                          Where   nta.Nth_Theme_Id    =   pi_Theme_Id
                          And     hur.Hur_Role        =   pi_Role
                          And     hur.Hur_Username    =   hu.Hus_Username
                          And     hu.Hus_Username     =   au.Username
                          And     hu.Hus_Username     !=  Sys_Context('NM3CORE','APPLICATION_OWNER')
                          And     Not Exists          (   Select  Null
                                                          From    Hig_User_Roles  hur2,
                                                                  Nm_Theme_Roles  ntr
                                                          Where   hur2.Hur_Username     =   hu.Hus_Username
                                                          And     hur2.Hur_Role         =   ntr.Nthr_Role
                                                          And     ntr.Nthr_Theme_Id     =   nta.Nth_Theme_Id
                                                          And     hur2.Hur_Role         !=  Pi_Role
                                                      )
                          Group By  hu.Hus_Username,
                                    nta.Nth_Feature_Table,
                                    nta.Nth_Feature_Shape_Column
                          )
                  ) Layers;
  --
  If l_Tab_Owner.Count > 0  Then
    
    Forall i In 1..l_Tab_Owner.Count
      Delete  Mdsys.Sdo_Geom_Metadata_Table
      Where   Sdo_Owner         = l_Tab_Owner(i)
      And     Sdo_Table_Name    = l_Tab_Table_Name(i)
      And     Sdo_Column_Name   = l_Tab_Column_Name(i);

    -----------------------------------
    -- Drop subordinate feature views
    -----------------------------------

    For i In 1..l_Tab_Owner.Count Loop

      Drop_Feature_View (l_Tab_Owner(i), l_Tab_Table_Name(i));

      -----------------------------------------
      -- Drop SDE layers for subordinate users
      -----------------------------------------

      If Hig.Get_User_Or_Sys_Opt('REGSDELAY') = 'Y' Then
        
        Begin
          Execute Immediate 'begin '||
                              'nm3sde.drop_sub_layer_by_table( '
                            ||Nm3Flx.String(l_Tab_Table_Name(i))||','
                            ||Nm3Flx.String(l_Tab_Column_Name(i))||','
                            ||Nm3Flx.String(l_Tab_Owner(i))||');'
                           ||' end;';
        Exception
          When Others Then
            Null;
        End;
      End If;
      End Loop;
    End If;
  End Delete_Sub_Sdo_Layer;
  --
Begin
  --
  --------------------------------------------------------------
  -- Loop through the rows being processed from nm_theme_roles
  --------------------------------------------------------------

  -----------
  -- INSERTS
  -----------

  For i In 1 .. G_Role_Idx
  Loop

    Begin
      If g_Role_Op (i) = 'I' Then

        Create_Sub_Sdo_Layer  (
                              pi_Theme_Id => g_Theme_Role (i),
                              pi_Role     => g_Role_Array (i)
                              );
       ----------
       -- DELETES
       ----------
      Elsif g_Role_Op (i) = 'D'  Then
        Delete_Sub_Sdo_Layer  (
                              pi_Theme_Id =>  g_Theme_Role (i),
                              pi_Role     =>  g_Role_Array (i)
                              );
      End If;

    Exception
      When No_Data_Found Then
        Null;
    End;
 End Loop;

Exception
 When No_Data_Found Then
  Null;

End Process_Subuser_Nthr;
--
---------------------------------------------------------------------------------------------------------------------------------
--
 Procedure Process_Subuser_Hur
/* Procedure to deal with creating subordinate user metadata triggered on
 nm_theme_roles data */
Is
  --
  Procedure Create_Sub_Sdo_Layers (
                                  pi_Username In Hig_Users.Hus_Username%Type,
                                  pi_Role     In Nm_Theme_Roles.Nthr_Role%Type
                                  )
  Is
    l_User Hig_Users.Hus_Username%Type := pi_Username;
  Begin
    --
    nm_debug.debug_on;
    nm_debug.debug('Running Create_Sub_Sdo_Layer from Process_Subuser_Hur for '||pi_Username||' - '||pi_role);
    
    Insert Into Mdsys.Sdo_Geom_Metadata_Table g
    (
    Sdo_Owner,
    Sdo_Table_Name,
    Sdo_Column_Name,
    Sdo_Diminfo,
    Sdo_Srid
    )
    Select  l_User,
            y.Nth_Feature_Table,
            y.Nth_Feature_Shape_Column,
            u.Sdo_Diminfo,
            u.Sdo_Srid
    From    Mdsys.Sdo_Geom_Metadata_Table u,
            (
            Select  x.Nth_Feature_Table,
                    x.Nth_Feature_Shape_Column
            From    -- Layers based on role - more than likely views
                    (
                    Select  nta.Nth_Feature_Table,
                            nta.Nth_Feature_Shape_Column
                    From    Nm_Themes_All   nta,
                            Nm_Theme_Roles  ntr
                    Where   ntr.Nthr_Theme_Id   =     nta.Nth_Theme_Id
                    And     ntr.Nthr_Role       =     pi_Role
                    And     Not Exists          (
                                                Select  Null
                                                From    Mdsys.Sdo_Geom_Metadata_Table g1
                                                Where   g1.Sdo_Owner        = l_User
                                                And     g1.Sdo_Table_Name   = nta.Nth_Feature_Table
                                                And     g1.Sdo_Column_Name  = nta.Nth_Feature_Shape_Column
                                                )
                    Union All
                    -- Base table themes
                    Select  nta2.Nth_Feature_Table,
                            nta2.Nth_Feature_Shape_Column
                    From    Nm_Themes_All     nta,
                            Nm_Theme_Roles    ntr,
                            Nm_Themes_All     nta2
                    Where   nta2.Nth_Theme_Id   =   nta.Nth_Base_Table_Theme
                    And     Nthr_Theme_Id       =   nta.Nth_Theme_Id
                    And     Nthr_Role           =   pi_Role
                    And     Not Exists          (   Select  Null
                                                    From    Mdsys.Sdo_Geom_Metadata_Table g1
                                                    Where   g1.Sdo_Owner        =   l_User
                                                    And     g1.Sdo_Table_Name   =   nta2.Nth_Feature_Table
                                                    And     g1.Sdo_Column_Name  =   nta2.Nth_Feature_Shape_Column
                                                 )
                    ) x
                    Group By  Nth_Feature_Table,
                              Nth_Feature_Shape_Column
            ) y
    Where   u.Sdo_Table_Name    =   y.Nth_Feature_Table
    And     u.Sdo_Column_Name   =   y.Nth_Feature_Shape_Column
    And     u.Sdo_Owner         =   Sys_Context('NM3CORE','APPLICATION_OWNER');

    For i In  (
              Select  y.Nth_Theme_Id,
                      y.Nth_Feature_Table,
                      y.Nth_Feature_Shape_Column
              From    (
                      Select  x.Nth_Theme_Id,
                              x.Nth_Feature_Table,
                              x.Nth_Feature_Shape_Column
                      From    -- Layers based on role - more than likely views
                              (
                              Select  nta.Nth_Theme_Id,
                                      nta.Nth_Feature_Table,
                                      nta.Nth_Feature_Shape_Column
                              From    Nm_Themes_All   nta,
                                      Nm_Theme_Roles  ntr
                              Where   ntr.Nthr_Theme_Id   =   nta.Nth_Theme_Id
                              And     ntr.Nthr_Role       =   pi_Role
                              Union All
                              -- Base table themes
                              Select  nta2.Nth_Theme_Id,
                                      nta2.Nth_Feature_Table,
                                      nta2.Nth_Feature_Shape_Column
                              From    Nm_Themes_All   nta,
                                      Nm_Theme_Roles  ntr,
                                      Nm_Themes_All   nta2
                              Where   nta2.Nth_Theme_Id   =   nta.Nth_Base_Table_Theme
                              And     ntr.Nthr_Theme_Id   =   nta.Nth_Theme_Id
                              And     ntr.Nthr_Role       =   pi_Role
                              ) x
                      Group By  x.Nth_Theme_Id,
                                x.Nth_Feature_Table,
                                x.Nth_Feature_Shape_Column
                      ) y
              )
    Loop
      --
      -- No longer required
      -- Create_Feature_View (Pi_Username, I.Nth_Feature_Table);
      --
      If Hig.Get_User_Or_Sys_Opt('REGSDELAY') = 'Y' Then
      
        If NOT check_sub_sde_exempt( i.nth_feature_table ) Then
      
          Begin
            Execute Immediate (' begin '||
                               'nm3sde.create_sub_sde_layer ( p_theme_id => '|| To_Char (I.Nth_Theme_Id)
                                                         || ',p_username => '''|| Pi_Username
                                                      || ''');'||
                            ' end;');
          Exception
            When Others Then 
              Null;
          End;
        
        End If;
        
      End If;
      
    End Loop;
  Exception
    When Others Then
      Null;
  End Create_Sub_Sdo_Layers;
  --
  Procedure Delete_Sdo_Layers_By_Role (
                                      pi_Username In Hig_Users.Hus_Username%Type,
                                      pi_Role     In Nm_Theme_Roles.Nthr_Role%Type
                                      )
  Is
    l_Tab_Owner       Nm3Type.Tab_Varchar30;
    l_Tab_Table_Name  Nm3Type.Tab_Varchar30;
    l_Tab_Column_Name Nm3Type.Tab_Varchar30;
  Begin
    Select        Layers.Hus_Username,
                  Layers.Nth_Feature_Table,
                  Layers.Nth_Feature_Shape_Column
    Bulk Collect 
    Into          l_Tab_Owner,
                  l_Tab_Table_Name,
                  l_Tab_Column_Name
    From          (
                  Select    x.Hus_Username,
                            x.Nth_Feature_Table,
                            x.Nth_Feature_Shape_Column
                  From      (
                            Select  hu.Hus_Username,
                                    nta.Nth_Feature_Table,
                                    nta.Nth_Feature_Shape_Column
                            From    Nm_Themes_All   nta,
                                    Nm_Theme_Roles  ntr,
                                    Hig_Users       hu,
                                    All_Users       au
                            Where   ntr.Nthr_Theme_Id =   nta.Nth_Theme_Id
                            And     ntr.Nthr_Role     =   pi_Role
                            And     hu.Hus_Username   =   au.Username
                            And     au.Username       =   pi_Username
                            And     hu.Hus_Username   !=  Sys_Context('NM3CORE','APPLICATION_OWNER')
                            And     Not Exists    ( 
                                                  Select  Null
                                                  From    Hig_User_Roles  hur,
                                                          Nm_Theme_Roles  ntr2
                                                  Where   hur.Hur_Username      =   pi_Username
                                                  And     hur.Hur_Role          =   ntr2.Nthr_Role
                                                  And     ntr2.Nthr_Theme_Id    =   nta.Nth_Theme_Id
                                                  And     hur.Hur_Role          !=  pi_Role
                                                  )
                            Group By  hu.Hus_Username,
                                      nta.Nth_Feature_Table,
                                      nta.Nth_Feature_Shape_Column
                            ) x
                  ) Layers;

    If l_Tab_Owner.Count > 0  Then

      Forall i In 1..l_Tab_Owner.Count
        Delete Mdsys.Sdo_Geom_Metadata_Table
        Where   Sdo_Owner         = l_Tab_Owner(i)
        And     Sdo_Table_Name    = l_Tab_Table_Name(i)
        And     Sdo_Column_Name   = l_Tab_Column_Name(i);

      -----------------------------------
      -- Drop subordinate feature views
      -----------------------------------

      For i In 1..l_Tab_Owner.Count Loop

        Drop_Feature_View (l_Tab_Owner(i), l_Tab_Table_Name(i));

        -----------------------------------------
        -- Drop SDE layers for subordinate users
        -----------------------------------------

        If Hig.Get_User_Or_Sys_Opt('REGSDELAY') = 'Y' Then

          Begin
            Execute Immediate 'begin '||
                                'nm3sde.drop_sub_layer_by_table( '
                                           ||Nm3Flx.String(L_Tab_Table_Name(I))||','
                                           ||Nm3Flx.String(L_Tab_Column_Name(I))||','
                                           ||Nm3Flx.String(L_Tab_Owner(I))||');'
                          ||' end;';
           --
          Exception
            When Others Then
              Null;
          End;
        End If;
      End Loop;
    End If;
  --
  End Delete_Sdo_Layers_By_Role;
  --
Begin
  For i In 1 .. g_Role_Idx
  Loop
    Begin
      --
      -- INSERTS
      --
      If g_Role_Op (g_Role_Idx) = 'I' Then
          
        Create_Sub_Sdo_Layers (
                              pi_Username => g_Username_Array (i),
                              pi_Role     => g_Role_Array (i)
                              );
        --
        --
        -- DELETES
        --
      Elsif g_Role_Op (g_Role_Idx) = 'D'  Then

        Delete_Sdo_Layers_By_Role (
                                  pi_Username =>  g_Username_Array (i),
                                  pi_Role     =>  g_Role_Array (i)
                                  );
       End If;

    Exception
      When No_Data_Found Then
        Null;
    End;
  End Loop;
Exception
  When No_Data_Found Then
    Null;
End Process_Subuser_Hur;
--
---------------------------------------------------------------------------------------------------------------------------------
--
Procedure Create_Nth_Sdo_Trigger  (
                                  p_Nth_Theme_Id   In   Nm_Themes_All.Nth_Theme_Id%Type,
                                  p_Restrict       In   Varchar2 Default Null
                                  )
Is
  lf                    Varchar2 (1)                     := Chr (10);
  lq                    Varchar2 (1)                     := Chr (39);
  l_Update_Str          Varchar2 (2000);
  l_Comma               Varchar2 (1)                     := Null;
  l_Trg_Name            Varchar2 (30);
  l_Tab_Or_View         Varchar2 (5);
  l_Date                Varchar2 (100);
  l_Nth                 Nm_Themes_All%Rowtype;
  l_Base_Table_Nth      Nm_Themes_All%Rowtype;
  l_Tab_Vc              Nm3Type.Tab_Varchar32767;

  Cursor C1 (Objname In Varchar2)
  Is
  Select  uo.Object_Type
  From    User_Objects  uo
  Where   uo.Object_Name = Objname;

  Ex_Invalid_Sequence   Exception;

  --
  --
  -- Function eventually needs to go into nm3sdo package
  --
  Function Get_Sdo_Trg_Name_A (
                              p_Nth_Id   In   Nm_Themes_All.Nth_Theme_Id%Type
                              ) Return Varchar2
  Is
  Begin
    Return ('NM_NTH_' || To_Char (p_Nth_Id) || '_SDO_A_ROW_TRG');
  End Get_Sdo_Trg_Name_A;
  --
  --
  -- Function eventually needs to go into nm3sdo package
  --
  Function Get_Sdo_Trg_Name_B (
                              p_Nth_Id   In   Nm_Themes_All.Nth_Theme_Id%Type
                              ) Return Varchar2
  Is
  Begin
    Return ('NM_NTH_' || To_Char (p_Nth_Id) || '_SDO_B_ROW_TRG');
  End Get_Sdo_Trg_Name_B;

  Procedure Append  (
                    Pi_Text In Nm3Type.Max_Varchar2
                    )
  Is
  Begin
    Nm3Ddl.Append_Tab_Varchar (l_Tab_Vc, pi_Text);
  End Append;
--
Begin
  --
  --
  -- Driving Theme
  --
  l_Nth := Nm3Get.Get_Nth (pi_Nth_Theme_Id => p_Nth_Theme_Id);
  --
  -- Base Table Theme
  --
  
  If l_Nth.Nth_Base_Table_Theme Is Null Then
    l_Base_Table_Nth := l_Nth;        -- base theme is the driving theme
  Else
    l_Base_Table_Nth := Nm3Get.Get_Nth (pi_Nth_Theme_Id      => l_Nth.Nth_Base_Table_Theme);
  End If;


  Open C1 (L_Base_Table_Nth.Nth_Table_Name);

  Fetch C1
   Into L_Tab_Or_View;

  Close C1;

  -- If the theme has an associated sequence then ensure that the sequence
  -- actually exists - cos we are about to reference it in our generated trigger
  --
  If l_Base_Table_Nth.Nth_Sequence_Name Is Not Null Then
    
    If Not Nm3Ddl.Does_Object_Exist (
                                    p_Object_Name      => l_Base_Table_Nth.Nth_Sequence_Name,
                                    p_Object_Type      => 'SEQUENCE'
                                    ) Then
        Raise Ex_Invalid_Sequence;
    End If;
  End If;

  --    we need to differentiate between join FT data and single table FT data. The first needs an after trigger the second should not be using this
  --    approach - it just needs a theme trigger to set the column, no insert/update/delete.

  l_Trg_Name := Get_Sdo_Trg_Name_A (l_Base_Table_Nth.Nth_Theme_Id);

  If l_Base_Table_Nth.Nth_Rse_Fk_Column Is Not Null Then
     l_Update_Str := l_Base_Table_Nth.Nth_Rse_Fk_Column;
     l_Comma := ',';
  End If;

  If L_Base_Table_Nth.Nth_St_Chain_Column Is Not Null Then
     
     l_Update_Str :=  l_Update_Str || l_Comma || l_Base_Table_Nth.Nth_St_Chain_Column;
     l_Comma := ',';
  End If;

  If l_Base_Table_Nth.Nth_End_Chain_Column Is Not Null  Then
     l_Update_Str :=  l_Update_Str || l_Comma || l_Base_Table_Nth.Nth_End_Chain_Column;
     l_Comma := ',';
  End If;

  -- if the x and y column are used as drivers, there should be no triggering
  -- when the element FK or offsets are changed.
  If l_Base_Table_Nth.Nth_X_Column Is Not Null  Then
     l_Update_Str := l_Base_Table_Nth.Nth_X_Column;
     l_Comma := ',';
  End If;

  If l_Base_Table_Nth.Nth_Y_Column Is Not Null  Then
    l_Update_Str :=
    l_Update_Str || l_Comma || l_Base_Table_Nth.Nth_Y_Column;
  End If;
  --
  l_Tab_Vc.Delete;
  -- This is the more common trigger - a theme by pure XY or by LRef.
  -- The trigger is an after row trigger and will fire on either update
  -- of XY or on update of LRef columns.
  Append ('CREATE OR REPLACE TRIGGER ' || Lower (l_Trg_Name));
  l_Date := To_Char (Sysdate, 'DD-MON-YYYY HH:MI');
  Append ('--');
  Append
     ('--------------------------------------------------------------------------'
     );
  Append ('--');
  Append ('--   PVCS Identifiers :-');
  Append ('--');
  Append ('--       PVCS id          : $Header::c   '|| Get_Body_Version);
  Append ('--       Module Name      : $Workfile:   nm3sdm.pkb  $');
  Append ('--       Version          : ' || G_Body_Sccsid);
  Append ('--');
  Append ('-----------------------------------------------------------------------------');
  Append ('--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.');
  Append ('-----------------------------------------------------------------------------');
  Append ('-- Author : R Coupe');
  Append ('--          G Johnson / A Edwards');
  Append ('--');
  Append ('--  #################');
  Append ('--  # DO NOT MODIFY #');
  Append ('--  #################');
  Append ('--');
  Append (   '-- Trigger is built dynamically from the theme '
          || l_Nth.Nth_Theme_Id
          || ' on '
          || l_Nth.Nth_Theme_Name
         );
  Append ('--');
  Append ('-- Generated on ' || l_Date);
  Append ('--');
  Append (' ');

  -- Need to cater for views or tables
  -- difficulty with views is that the update seldom occurs on the view!
  If l_Tab_Or_View = 'TABLE'  Then
    Append ('AFTER');
  Else
    Append ('INSTEAD OF ');
  End If;

  Append ('DELETE OR INSERT OR UPDATE of ' || Lower (l_Update_Str));
  Append ('ON ' || l_Base_Table_Nth.Nth_Table_Name);
  Append ('FOR EACH ROW');
  Append ('DECLARE' || Lf);
  Append (' l_geom mdsys.sdo_geometry;');
  Append (' l_lref nm_lref;' || Lf);
  Append ('--');
  Append
     ('--------------------------------------------------------------------------'
     );
  Append ('--');
  --
  -- DELETE PROCEDURE
  --
  Append (' PROCEDURE del IS ');
  Append (' BEGIN');
  Append ('');
  Append (   '    -- Delete from feature table '
          || Lower (l_Base_Table_Nth.Nth_Feature_Table)
         );
  Append ('    DELETE FROM ' || Lower (l_Base_Table_Nth.Nth_Feature_Table));
  Append (   '          WHERE '
          || Lower (Nvl(l_Base_Table_Nth.Nth_Feature_Fk_Column, l_Base_Table_Nth.Nth_Feature_Pk_Column))
          || ' = :OLD.'
          || Lower (l_Base_Table_Nth.Nth_Pk_Column)
          || ';'
         );
  Append (' ');
  Append
     (' EXCEPTION -- when others to cater for attempted delete where no geom values supplied e.g. no x/y'
     );
  Append ('     WHEN others THEN');
  Append ('       Null;');
  Append (' END del;');
  Append ('--');
  Append
     ('--------------------------------------------------------------------------'
     );
  Append ('--');
  --
  -- INSERT PROCEDURE
  --
  Append (' PROCEDURE ins IS ');
  Append (' BEGIN');
  Append ('');
  Append (   '   -- Insert into feature table '
          || Lower (l_Base_Table_Nth.Nth_Feature_Table)
         );
  Append ('    INSERT INTO ' || Lower (l_Base_Table_Nth.Nth_Feature_Table));
  Append ('    ( ' || Lower (l_Base_Table_Nth.Nth_Feature_Pk_Column));
  Append ('    , ' || Lower (l_Base_Table_Nth.Nth_Feature_Shape_Column));

  If l_Base_Table_Nth.Nth_Sequence_Name Is Not Null Then
    Append ('    , objectid');
  End If;

  Append ('    )');
  Append ('    VALUES ');
  Append ('    ( :NEW.' || Lower (l_Base_Table_Nth.Nth_Pk_Column));

  --------------------------------------------------------------------------------------
  -- POINT X,Y ITEM
  --------------------------------------------------------------------------------------
  If     l_Base_Table_Nth.Nth_X_Column Is Not Null
     And l_Base_Table_Nth.Nth_Y_Column Is Not Null  Then
     
    Append ('    , mdsys.sdo_geometry');
    Append ('       ( 2001');
    Append ('       , sys_context(''NM3CORE'',''THEME' || l_Base_Table_Nth.Nth_Theme_Id || 'SRID'')');
    Append ('       , mdsys.sdo_point_type');
    Append ('          ( :NEW.' || Lower (l_Base_Table_Nth.Nth_X_Column));
    Append ('           ,:NEW.' || Lower (l_Base_Table_Nth.Nth_Y_Column));
    Append ('           , NULL)');
    Append ('       , NULL');
    Append ('       , NULL) -- geometry derived from X,Y values');
    --------------------------------------------------------------------------------------
    -- POINT Linear Reference ITEM
    --------------------------------------------------------------------------------------
  Elsif     l_Base_Table_Nth.Nth_St_Chain_Column  Is Not Null
        And l_Base_Table_Nth.Nth_End_Chain_Column Is Null Then
    
    Append (  ',nm3sdo.get_pt_shape_from_ne ( ');
    Append (   '                                 :NEW.'
           || Lower (l_Base_Table_Nth.Nth_Rse_Fk_Column)
          );
    Append (   '                                 ,:NEW.'
           || Lower (l_Base_Table_Nth.Nth_St_Chain_Column)
           || ') -- geometry derived from start chainage reference'
          );
    --------------------------------------------------------------------------------------
    -- CONTINUOUS Linear Reference ITEM
    --------------------------------------------------------------------------------------
  Elsif     l_Base_Table_Nth.Nth_St_Chain_Column  Is Not Null
        And l_Base_Table_Nth.Nth_End_Chain_Column Is Not Null Then
    -- Assume that the XY are not populated and that the theme table is linearly referenced.
    Append ('    , nm3sdo.get_placement_geometry');
    Append (   '              ( ');
    Append ('                 nm_placement ');
    Append (   '                   ( :NEW.'
           || Lower (l_Base_Table_Nth.Nth_Rse_Fk_Column)
          );
    Append (   '                   , :NEW.'
           || Lower (l_Base_Table_Nth.Nth_St_Chain_Column)
          );
    Append (   '                   , :NEW.'
           || Lower (l_Base_Table_Nth.Nth_End_Chain_Column)
          );
    Append
       ('              , 0))  -- geometry derived from linear reference');
  End If;

  If l_Base_Table_Nth.Nth_Sequence_Name Is Not Null Then
    Append (   '    , '
           || Lower (L_Base_Table_Nth.Nth_Sequence_Name)
           || '.NEXTVAL'
          );
  End If;

  Append ('    );');

  -----------------------------------------------------------------------------------
  -- If Start Chain and LR columns are defined too, then re-project xy onto
  -- Road to work out LR NE ID and Offset values
  -----------------------------------------------------------------------------------
  If     l_Base_Table_Nth.Nth_X_Column          Is Not Null
     And l_Base_Table_Nth.Nth_Y_Column          Is Not Null
     And l_Base_Table_Nth.Nth_St_Chain_Column   Is Not Null
     And l_Base_Table_Nth.Nth_Rse_Fk_Column     Is Not Null
     And l_Base_Table_Nth.Nth_End_Chain_Column  Is Null  Then
     
    Append(   Lf
         || Lf
         || '    -- Network and Chainage supplied - so derive LR from XY values and update'
         || Lf
         || '    l_lref := nm3sdo.nm3sdo.get_nw_snaps_at_xy '
        );
    Append ('               ( '||To_Char(L_Base_Table_Nth.Nth_Theme_Id));
    Append (   '               , :NEW.'
           || Lower (L_Base_Table_Nth.Nth_X_Column)
          );
    Append (   '               , :NEW.'
           || Lower (L_Base_Table_Nth.Nth_Y_Column)
           || ');'
          );
    Append (   Lf
           || '    :NEW.'
           || Lower (L_Base_Table_Nth.Nth_Rse_Fk_Column)
           || ' := l_lref.lr_ne_id;'
           || Lf
          );
    Append (   '    :NEW.'
           || Lower (L_Base_Table_Nth.Nth_St_Chain_Column)
           || ' := nm3unit.get_formatted_value '
          );
    Append ('               ( l_lref.lr_offset');
    Append
        ('               , nm3net.get_nt_units_from_ne(l_lref.lr_ne_id)');
    Append ('               );');
  End If;

  Append (' ');
  Append
     (' EXCEPTION -- when others to cater for attempted insert where no geom values supplied e.g. no x/y'
     );
  Append ('    WHEN others THEN');
  Append ('       Null;');
  Append (' END ins;');
  Append ('--');
  Append
     ('--------------------------------------------------------------------------'
     );
  Append ('--');
  --
  -- UPDATE PROCEDURE
  --
  Append (' PROCEDURE upd IS ');
  Append (' BEGIN');
  Append ('');
  Append (   '    -- Update feature table '
          || Lower (l_Base_Table_Nth.Nth_Feature_Table)
         );
  --
  --
  -- 04-FEB-2009
  -- AE Make sure the X and Y columns are not null before updating.. otherwise we'll delete
  --
  If     l_Base_Table_Nth.Nth_X_Column Is Not Null
     And l_Base_Table_Nth.Nth_Y_Column Is Not Null  Then

    Append ('--');
    Append (' IF :NEW.'||Lower (l_Base_Table_Nth.Nth_X_Column)|| ' IS NOT NULL');
    Append ('    AND :NEW.'||Lower (l_Base_Table_Nth.Nth_Y_Column)|| ' IS NOT NULL');
    Append (' THEN ');

  End If;

  Append ('--');
  Append ('    UPDATE ' || Lower (l_Base_Table_Nth.Nth_Feature_Table));
  Append (   '       SET '
          || Lower (l_Base_Table_Nth.Nth_Feature_Pk_Column)
          || ' = :NEW.'
          || Lower (l_Base_Table_Nth.Nth_Pk_Column)
         );

  --------------------------------------------------------------------------------------
  -- POINT X,Y ITEM
  --------------------------------------------------------------------------------------
  If     l_Base_Table_Nth.Nth_X_Column Is Not Null
     And l_Base_Table_Nth.Nth_Y_Column Is Not Null  Then

    Append (   '         , '
           || Lower (l_Base_Table_Nth.Nth_Feature_Shape_Column)
           || ' = mdsys.sdo_geometry'
          );
    Append ('                          ( 2001 ');
    Append ('                          , sys_context(''NM3CORE'',''THEME' || l_Base_Table_Nth.Nth_Theme_Id || 'SRID'')');
    Append ('                          , mdsys.sdo_point_type');
    Append (   '                             ( :NEW.'
           || Lower (l_Base_Table_Nth.Nth_X_Column)
          );
    Append (   '                             , :NEW.'
           || Lower (l_Base_Table_Nth.Nth_Y_Column)
          );
    Append ('                             ,  NULL)');
    Append ('                          , NULL ');
    Append
      ('                          , NULL)  -- geometry derived from X,Y values'
      );
    --------------------------------------------------------------------------------------
    -- POINT Linear Reference ITEM
    --------------------------------------------------------------------------------------
  Elsif     l_Base_Table_Nth.Nth_St_Chain_Column  Is Not Null
        And l_Base_Table_Nth.Nth_End_Chain_Column Is Null Then
    
    Append (   '              ,'
           || l_Base_Table_Nth.Nth_Feature_Shape_Column
           || '=nm3sdo.get_pt_shape_from_ne('
           || ':new.'
           || l_Base_Table_Nth.Nth_Rse_Fk_Column
           || ',:new.'
           || l_Base_Table_Nth.Nth_St_Chain_Column
           || ')'
          );
    --------------------------------------------------------------------------------------
    -- CONTINUOUS Linear Reference ITEM
    --------------------------------------------------------------------------------------
  Elsif     l_Base_Table_Nth.Nth_St_Chain_Column Is Not Null
        And l_Base_Table_Nth.Nth_End_Chain_Column Is Not Null Then
    
    -- Assume that the XY are not populated and that the theme table is linearly referenced.
    Append (   '         , '
           || (   Lower (l_Base_Table_Nth.Nth_Feature_Shape_Column)
               || ' = nm3sdo.get_placement_geometry ('
              )
          );
    Append ('                               ' || 'nm_placement');
    Append (   '                                 ( :NEW.'
           || Lower (l_Base_Table_Nth.Nth_Rse_Fk_Column)
          );
    Append (   '                                 , :NEW.'
           || Lower (l_Base_Table_Nth.Nth_St_Chain_Column)
          );
    Append (   '                                 , :NEW.'
           || Lower (l_Base_Table_Nth.Nth_End_Chain_Column)
          );
    Append
      ('                             , 0)) -- geometry derived from linear reference'
      );
  End If;

  Append (   '     WHERE '
          || Lower (l_Base_Table_Nth.Nth_Feature_Pk_Column)
          || ' = :OLD.'
          || l_Base_Table_Nth.Nth_Pk_Column
          || ';'
          || Lf
         );
  Append ('    IF SQL%ROWCOUNT=0 THEN');
  Append ('       ins;');

  -----------------------------------------------------------------------------------
  -- If Start Chain and LR columns are defined too, then re-project xy onto
  -- Road to work out LR NE ID and Offset values
  -----------------------------------------------------------------------------------
  If     l_Base_Table_Nth.Nth_X_Column          Is Not Null
     And l_Base_Table_Nth.Nth_Y_Column          Is Not Null
     And l_Base_Table_Nth.Nth_St_Chain_Column   Is Not Null
     And l_Base_Table_Nth.Nth_Rse_Fk_Column     Is Not Null
     And l_Base_Table_Nth.Nth_End_Chain_Column  Is Null  Then

     Append ('    ELSE');
     Append
        (   '    -- Network and Chainage supplied - so derive LR from XY values and update'
         || Lf
         || '       l_lref := nm3sdo.get_nw_snaps_at_xy ' );
     Append ('                  '||To_Char( l_Base_Table_Nth.Nth_Theme_Id));
     Append (   '                  , :NEW.'
             || Lower (l_Base_Table_Nth.Nth_X_Column)
            );
     Append (   '                  , :NEW.'
             || Lower (l_Base_Table_Nth.Nth_Y_Column)
             || ');'
            );
     Append (   Lf
             || '       :NEW.'
             || Lower (l_Base_Table_Nth.Nth_Rse_Fk_Column)
             || ' := l_lref.lr_ne_id;'
             || Lf
            );
     Append (   '       :NEW.'
             || Lower (l_Base_Table_Nth.Nth_St_Chain_Column)
             || ' := nm3unit.get_formatted_value '
            );
     Append ('                  ( l_lref.lr_offset');
     Append
        ('                  , nm3net.get_nt_units_from_ne(l_lref.lr_ne_id)'
        );
     Append ('                  );');
     Append ('    END IF;' || Lf);
  Else
     Append ('    END IF;' || Lf);
  End If;

  -- 04-FEB-2009
  -- AE Make sure the X and Y columns are not null before updating.. otherwise we'll delete
  --
  If     l_Base_Table_Nth.Nth_X_Column Is Not Null
     And l_Base_Table_Nth.Nth_Y_Column Is Not Null  Then

    Append ('--');
    Append (' ELSE');
    Append ('--');
    Append ('    del; ');
    Append ('--');
    Append (' END IF; ');
  End If;

  Append (' ');
  Append
     (' EXCEPTION -- when others to cater for attempted update where no geom values supplied e.g. no x/y'
     );
  Append ('     WHEN others THEN');
  Append ('       Null;');
  Append (' END upd;');
  Append ('--');
  Append
     ('--------------------------------------------------------------------------'
     );
  Append ('--');
  Append ('BEGIN');
  Append ('--');
  
  If p_Restrict Is Not Null Then
    Append ('IF ' ||p_Restrict || ' THEN');
  End If;
  
  Append ('   nm3sdm.set_theme_srid_ctx( pi_theme_id => ' || l_Base_Table_Nth.Nth_Theme_Id || ');');
  Append ('--');
  Append ('   IF DELETING THEN');
  Append ('        del;');
  Append ('   ELSIF INSERTING THEN');
  Append ('        ins;');
  Append ('   ELSIF UPDATING THEN');
  Append ('        upd;');
  Append ('   END IF;');
  If p_Restrict Is Not Null Then
    Append ('END IF;');
  End If;
  Append ('EXCEPTION');
  Append ('   WHEN NO_DATA_FOUND THEN');
  Append ('     NULL; -- no data in spatial table to update or delete');
  Append ('   WHEN OTHERS THEN');
  Append ('     RAISE;');
  Append ('END ' || Lower (l_Trg_Name) || ';');
  Append ('--');
  Append
     ('--------------------------------------------------------------------------'
     );
  Append ('--');
  Nm3Ddl.Execute_Tab_Varchar (L_Tab_Vc);
Exception
  When Ex_Invalid_Sequence  Then
    Hig.Raise_Ner (
                  pi_Appl                    =>   Nm3Type.C_Hig,
                  pi_Id                      =>   257,
                  pi_Sqlcode                 =>   -20001,
                  pi_Supplementary_Info      =>   l_Base_Table_Nth.Nth_Sequence_Name
                                                  || Chr (10)
                                                  || 'Please check your theme.'
                  );
End Create_Nth_Sdo_Trigger;
--
-----------------------------------------------------------------------------
--
Procedure Get_Dynseg_Nt_Types (
                              Pi_Asset_Type   In       Nm_Inv_Types.Nit_Inv_Type%Type,
                              Po_Locations    In Out   Tab_Nin_Sdo
                              )
Is
  l_Tab_Layer      Nm3Type.Tab_Number;
  l_Tab_Location   Nm3Type.Tab_Varchar4;
  l_Retval         Tab_Nin_Sdo;
Begin
  Nm_Debug.Proc_Start (G_Package_Name, 'get_dynseg_nt_type');

  Select        nlt.Nlt_Nt_Type,
                nta.Nth_Theme_Id Base_Theme
  Bulk Collect 
  Into          l_Tab_Location,
                l_Tab_Layer
  From    Nm_Inv_Nw         nin,
          Nm_Themes_All     nta,
          Nm_Nw_Themes      nnt,
          Nm_Linear_Types   nlt
  Where   nlt.Nlt_Id              =   nnt.Nnth_Nlt_Id
  And     nnt.Nnth_Nth_Theme_Id   =   nta.Nth_Theme_Id
  And     nlt.Nlt_Nt_Type         =   nin.Nin_Nw_Type
  And     nta.Nth_Theme_Type      =   'SDO'
  And     nin.Nin_Nit_Inv_Code    =   pi_Asset_Type;

  For i In 1 .. l_Tab_Layer.Count
  Loop
    l_Retval (i).p_Layer_Id := l_Tab_Layer (i);
    l_Retval (i).p_Location := l_Tab_Location (i);
  End Loop;

  po_Locations := l_Retval;
  Nm_Debug.Proc_End (G_Package_Name, 'get_dynseg_nt_type');

Exception
  When No_Data_Found  Then
    po_Locations := l_Retval;
End Get_Dynseg_Nt_Types;
--
-----------------------------------------------------------------------------
--
Procedure Get_Existing_Themes_For_Table (
                                        pi_Theme_Table   In       Nm_Themes_All.Nth_Theme_Name%Type,
                                        po_Themes        In Out   Tab_Nth
                                        )
Is
  l_Retval   Tab_Nth;
Begin
  Nm_Debug.Proc_End (G_Package_Name, 'get_existing_themes_for_table');

  Select        *
  Bulk Collect
  Into          l_Retval
  From          Nm_Themes_All nta
  Where         nta.Nth_Table_Name  =   pi_Theme_Table
  And           nta.Nth_Theme_Type  =   'SDO';

  po_Themes := l_Retval;
  --
  Nm_Debug.Proc_End (G_Package_Name, 'get_existing_themes_for_table');
  --
Exception
  When No_Data_Found  Then
    po_Themes := l_Retval;
End Get_Existing_Themes_For_Table;
--
-----------------------------------------------------------------------------
--
Procedure Get_Nlt_Block (
                        pi_Theme_Id   In       Nm_Themes_All.Nth_Theme_Id%Type,
                        po_Results    In Out   Tab_Nlt_Block
                        )
Is
  Type Tab_Nlt Is Table Of Nm_Linear_Types%Rowtype Index By Binary_Integer;

  l_Tab_Nlt      Tab_Nlt;
  l_Retval       Tab_Nlt_Block;
  l_Unit_Descr   Nm_Units.Un_Unit_Name%Type;
  
Begin
  Select        *
  Bulk Collect
  Into          l_Tab_Nlt
  From          Nm_Linear_Types nlt
  Where         nlt.Nlt_Id  In  (
                                Select  nnt.Nnth_Nlt_Id
                                From    Nm_Nw_Themes    nnt
                                Where   nnt.Nnth_Nth_Theme_Id = pi_Theme_Id
                                );

  For i In 1 .. l_Tab_Nlt.Count
  Loop
     l_Unit_Descr :=  Nm3Get.Get_Un (
                                    pi_Un_Unit_Id           => l_Tab_Nlt (i).Nlt_Units,
                                    pi_Raise_Not_Found      => False
                                    ).Un_Unit_Name;
                                    
     l_Retval (i).Nlt_Nth_Theme_Id  :=  pi_Theme_Id;
     l_Retval (i).Nlt_Id            :=  l_Tab_Nlt (i).Nlt_Id;
     l_Retval (i).Nlt_Seq_No        :=  l_Tab_Nlt (i).Nlt_Seq_No;
     l_Retval (i).Nlt_Descr         :=  l_Tab_Nlt (i).Nlt_Descr;
     l_Retval (i).Nlt_Nt_Type       :=  l_Tab_Nlt (i).Nlt_Nt_Type;
     l_Retval (i).Nlt_Gty_Type      :=  l_Tab_Nlt (i).Nlt_Gty_Type;
     l_Retval (i).Nlt_Admin_Type    :=  l_Tab_Nlt (i).Nlt_Admin_Type;
     l_Retval (i).Nlt_Start_Date    :=  l_Tab_Nlt (i).Nlt_Start_Date;
     l_Retval (i).Nlt_End_Date      :=  l_Tab_Nlt (i).Nlt_End_Date;
     l_Retval (i).Nlt_Units         :=  l_Tab_Nlt (i).Nlt_Units;
     l_Retval (i).Nlt_Units_Descr   :=  l_Unit_Descr;
  End Loop;

  po_Results := l_Retval;
Exception
  When No_Data_Found  Then
    po_Results := l_Retval;
End Get_Nlt_Block;
--
-----------------------------------------------------------------------------
--
Procedure Get_Nat_Block (
                        pi_Theme_Id   In       Nm_Themes_All.Nth_Theme_Id%Type,
                        po_Results    In Out   Tab_Nat_Block
                        )
Is
  Type Tab_Nat Is Table Of Nm_Area_Types%Rowtype  Index By Binary_Integer;

  l_Tab_Nat   Tab_Nat;
  l_Retval    Tab_Nat_Block;
Begin
  Select        naty.*
  Bulk Collect 
  Into          l_Tab_Nat
  From          Nm_Area_Types naty
  Where         naty.Nat_Id  In   (
                                  Select  nat.Nath_Nat_Id
                                  From    Nm_Area_Themes  nat
                                  Where   nat.Nath_Nth_Theme_Id   =   pi_Theme_Id
                                  );

  For i In 1 .. l_Tab_Nat.Count
  Loop
    l_Retval (i).Nat_Nth_Theme_Id     :=  pi_Theme_Id;
    l_Retval (i).Nat_Seq_No           :=  l_Tab_Nat (i).Nat_Seq_No;
    l_Retval (i).Nat_Descr            :=  l_Tab_Nat (i).Nat_Descr;
    l_Retval (i).Nat_Nt_Type          :=  l_Tab_Nat (i).Nat_Nt_Type;
    l_Retval (i).Nat_Gty_Group_Type   :=  l_Tab_Nat (i).Nat_Gty_Group_Type;
    l_Retval (i).Nat_Start_Date       :=  l_Tab_Nat (i).Nat_Start_Date;
    l_Retval (i).Nat_End_Date         :=  l_Tab_Nat (i).Nat_End_Date;
    l_Retval (i).Nat_Shape_Type       :=  l_Tab_Nat (i).Nat_Shape_Type;
  End Loop;

  po_Results := l_Retval;
  
Exception
  When No_Data_Found  Then
    po_Results := l_Retval;
End Get_Nat_Block;
--
-----------------------------------------------------------------------------
--
Procedure Get_Nit_Block (
                        pi_Theme_Id   In       Nm_Themes_All.Nth_Theme_Id%Type,
                        po_Results    In Out   Tab_Nit_Block
                        )
Is
  Type Tab_Nit Is Table Of Nm_Inv_Types%Rowtype Index By Binary_Integer;

  l_Tab_Nit   Tab_Nit;
  l_Retval    Tab_Nit_Block;
Begin
  Select        nity.*
  Bulk Collect 
  Into          l_Tab_Nit
  From          Nm_Inv_Types    nity,
                Nm_Inv_Themes   nith
  Where         nity.Nit_Inv_Type       =   nith.Nith_Nit_Id
  And           nith.Nith_Nth_Theme_Id  =   pi_Theme_Id;

  For i In 1 .. l_Tab_Nit.Count
  Loop
    l_Retval (i).Nit_Nth_Theme_Id       :=  pi_Theme_Id;
    l_Retval (i).Nit_Inv_Type           :=  l_Tab_Nit (i).Nit_Inv_Type;
    l_Retval (i).Nit_Descr              :=  l_Tab_Nit (i).Nit_Descr;
    l_Retval (i).Nit_View_Name          :=  l_Tab_Nit (i).Nit_View_Name;
    l_Retval (i).Nit_Use_Xy             :=  l_Tab_Nit (i).Nit_Use_Xy;
    l_Retval (i).Nit_Pnt_Or_Cont        :=  l_Tab_Nit (i).Nit_Pnt_Or_Cont;
    l_Retval (i).Nit_Linear             :=  l_Tab_Nit (i).Nit_Linear;
    l_Retval (i).Nit_Table_Name         :=  l_Tab_Nit (i).Nit_Table_Name;
    l_Retval (i).Nit_Lr_St_Chain        :=  l_Tab_Nit (i).Nit_Lr_St_Chain;
    l_Retval (i).Nit_Lr_End_Chain       :=  l_Tab_Nit (i).Nit_Lr_End_Chain;
    l_Retval (i).Nit_Lr_Ne_Column_Name  :=  l_Tab_Nit (i).Nit_Lr_Ne_Column_Name;
  End Loop;

  po_Results := l_Retval;
Exception
  When No_Data_Found  Then
    po_Results := l_Retval;
End Get_Nit_Block;
--
-----------------------------------------------------------------------------
--
Procedure Create_Msv_Themes
As
  l_Rec_Nth    Nm_Themes_All%Rowtype;
  l_Rec_Nthr   Nm_Theme_Roles%Rowtype;

  Function Get_Pk_Column  (
                          pi_Table_Name In Varchar2
                          ) Return Varchar2
  Is
    l_Col   Varchar2 (30);
  Begin
    Begin
      Select  Ucc.Column_Name
      Into    L_Col
      From    User_Constraints    Uco,
              User_Cons_Columns   Ucc
      Where   Uco.Owner           =   User
      And     Ucc.Owner           =   User
      And     Uco.Table_Name      =   pi_Table_Name
      And     Uco.Constraint_Type =   'P'
      And     Uco.Constraint_Name =   Ucc.Constraint_Name
      And     Uco.Table_Name      =   Ucc.Table_Name;

    Exception
      When Others  Then
        l_Col:= 'UNKNOWN';
    End;
    
    Return(l_Col);
            
  End Get_Pk_Column;
--
Begin
  For i In  (
            Select  ust.*
            From    User_Sdo_Themes   ust
            Where   Not Exists  (
                                Select  Null
                                From    Nm_Themes_All   nta
                                Where   nta.Nth_Theme_Name  =   ust.Name
                                And     nta.Nth_Theme_Type  =   'SDO'
                                )
            )
  Loop
    Begin
      l_Rec_Nth.Nth_Theme_Id                := Nm3Seq.Next_Nth_Theme_Id_Seq;
      l_Rec_Nth.Nth_Theme_Name              := i.Name;
      l_Rec_Nth.Nth_Table_Name              := i.Base_Table;
      l_Rec_Nth.Nth_Pk_Column               := Get_Pk_Column (i.Base_Table);
      l_Rec_Nth.Nth_Label_Column            := l_Rec_Nth.Nth_Pk_Column;
      l_Rec_Nth.Nth_Hpr_Product             := Nm3Type.C_Net;
      l_Rec_Nth.Nth_Location_Updatable      := 'N';
      l_Rec_Nth.Nth_Dependency              := 'I';
      l_Rec_Nth.Nth_Storage                 := 'S';
      l_Rec_Nth.Nth_Update_On_Edit          := 'N';
      l_Rec_Nth.Nth_Use_History             := 'N';
      l_Rec_Nth.Nth_Snap_To_Theme           := 'N';
      l_Rec_Nth.Nth_Lref_Mandatory          := 'N';
      l_Rec_Nth.Nth_Tolerance               := 10;
      l_Rec_Nth.Nth_Tol_Units               := 1;
      l_Rec_Nth.Nth_Theme_Type              := 'SDO';
      l_Rec_Nth.Nth_Feature_Table           := i.Base_Table;
      l_Rec_Nth.Nth_Feature_Shape_Column    := i.Geometry_Column;
      l_Rec_Nth.Nth_Feature_Pk_Column       := l_Rec_Nth.Nth_Pk_Column;
      Nm3Ins.Ins_Nth (l_Rec_Nth);

      l_Rec_Nthr.Nthr_Theme_Id := l_Rec_Nth.Nth_Theme_Id;
      l_Rec_Nthr.Nthr_Role := 'HIG_USER';
      l_Rec_Nthr.Nthr_Mode := 'NORMAL';
      Nm3Ins.Ins_Nthr (l_Rec_Nthr);

    Exception
      When Others Then
         Nm_Debug.Debug (   'Unable to create theme for '
                         || I.Name
                         || ' - '
                         || Sqlerrm
                        );
    End;
  End Loop;

End Create_Msv_Themes;
--
------------------------------------------------------------------------------
--
Procedure Create_Msv_Feature_Views  (
                                    pi_Username  In   Hig_Users.Hus_Username%Type Default Null
                                    )
  --
  -- View created for subordinate users that need access to the Highways owner
  -- SDO layers when using Mapviewer
  --
  -- This is due to Mapviewer requiring the object to exist as a view, rather
  -- than access it via via synonyms
  --
  -- USER_SDO_GEOM_METADATA still needs to exist for each subordinate user
  --
As
  l_Higowner       Varchar2 (30)         := Sys_Context('NM3CORE','APPLICATION_OWNER');
  l_Tab_Username   Nm3Type.Tab_Varchar30;
  l_Tab_Ftabs      Nm3Type.Tab_Varchar30;
  l_Nl             Varchar2 (10)         := Chr (10);
  --
  Function Is_Priv_View (
                        pi_View_Name    In   Dba_Views.View_Name%Type,
                        pi_Owner        In   Dba_Views.Owner%Type
                        ) Return Boolean
  Is
     l_Var    Varchar2 (10);
     l_Retval Boolean;

  Begin
    Begin
      Select  Null
      Into    l_Var
      From    Dba_Views dv
      Where   dv.View_Name   =   pi_View_Name
      And     dv.Owner       =   pi_Owner;

      l_Retval :=True;

    Exception
      When No_Data_Found Then
        l_Retval:= False;
    End;

    Return (l_Retval);

  End Is_Priv_View;

Begin
  -- Collect subordinate users (that actually exist)
  Begin
    Select        hu.Hus_Username
    Bulk Collect 
    Into          l_Tab_Username
    From          Hig_Users   hu
    Where         hu.Hus_Is_Hig_Owner_Flag  =   'N'
    And           Exists                    (   Select  Null
                                                From    Dba_Users du
                                                Where   du.Username             =   hu.Hus_Username
                                                And     Nvl(pi_Username,'^$^')  =   Nvl(hu.Hus_Username,'^$^'));
  Exception
    When No_Data_Found Then
      Null;
  End;

  --
  -- Find which feature tables we need to create views for
  -- We only need views for feature tables that contain SRIDS

  -- not longer the case - will create views for all feature tables
  --
  Begin
    Select        nta.Nth_Feature_Table
    Bulk Collect
    Into          l_Tab_Ftabs
    From          Nm_Themes_All   nta
    Where         nta.Nth_Theme_Type  =   'SDO'
    And           Exists              (   Select  Null
                                          From    User_Sdo_Geom_Metadata  usgm
                                          Where   usgm.Table_Name   =   nta.Nth_Feature_Table
                                      );
  Exception
     When No_Data_Found Then
      Null;
  End;
  
  If      l_Tab_Username.Count  > 0
      And l_Tab_Ftabs.Count     > 0 Then
    
    -- Create views for subordiate user(s)
    
    For i In 1 .. l_Tab_Username.Count
    Loop
      For t In 1 .. l_Tab_Ftabs.Count
      Loop
        If Is_Priv_View (l_Tab_Ftabs (t), l_Tab_Username (i)) Then
          Begin
            Execute Immediate    'DROP VIEW '
                              || l_Tab_Username (i)
                              || '.'
                              || l_Tab_Ftabs (t);
          Exception
             When Others Then
              Null;
          End;
        End If;

        Begin
          Execute Immediate ('CREATE OR REPLACE SYNONYM '|| l_Tab_Username(i)||'.'||l_Tab_Ftabs (t) || 
                             ' FOR ' || Sys_Context('NM3CORE','APPLICATION_OWNER') || '.' || l_Tab_Ftabs (t));
        Exception
           When Others  Then
            Null;
        End;
      End Loop;
    End Loop;
  End If;
--
Exception
  When Others Then
     Null;
End Create_Msv_Feature_Views;
--
-----------------------------------------------------------------------------
--
-- Refreshes user_sdo_geom_metadata for a given subordinate user
--
Procedure Refresh_Usgm  (
                        pi_Sub_Username    In   Hig_Users.Hus_Username%Type,
                        pi_Role_Restrict   In   Boolean Default True
                        )
Is
  Type Tab_Usgm Is Table Of User_Sdo_Geom_Metadata%Rowtype  Index By Binary_Integer;

  l_Tab_Usgm   Tab_Usgm;
  l_Sql        Nm3Type.Max_Varchar2;
  Nl           Varchar2 (10)        := Chr (10);

Begin
  l_Sql :=  'INSERT INTO mdsys.sdo_geom_metadata_table '||Nl||
            '(sdo_owner, sdo_table_name, '||Nl||
            ' sdo_column_name, sdo_diminfo, '||Nl||
            ' sdo_srid ) '||Nl||
            'SELECT '''||Pi_Sub_Username||''', sdo_table_name, sdo_column_name, sdo_diminfo, sdo_srid '||Nl||
            '  FROM mdsys.sdo_geom_metadata_table a'||Nl||
            ' WHERE sdo_owner = Sys_Context(''NM3CORE'',''APPLICATION_OWNER'') '||Nl||
            '   AND NOT EXISTS '||Nl||
            '     (SELECT 1 FROM mdsys.sdo_geom_metadata_table b '||Nl||
            '       WHERE '''||Pi_Sub_Username||'''  = b.sdo_owner '||Nl||
            '         AND a.sdo_table_name  = b.sdo_table_name '||Nl||
            '         AND a.sdo_column_name = b.sdo_column_name ) ';
  
  If Pi_Role_Restrict Then
    l_Sql :=  l_Sql
          || Nl
          || 'AND EXISTS '|| Nl
          || ' (SELECT 1 ' || Nl
          || '    FROM gis_themes ' || Nl
          || '   WHERE gt_feature_table = sdo_table_name)';
  End If;

 Execute Immediate l_Sql;

Exception
  When No_Data_Found  Then
     Hig.Raise_Ner (Pi_Appl         => Nm3Type.C_Hig,
                    Pi_Id           => 279,
                    Pi_Sqlcode      => -20001
                   );
 
End Refresh_Usgm;
--
--
-----------------------------------------------------------------------------
--
Procedure Get_Datum_Xy_From_Measure (
                                    p_Ne_Id     In        Number,
                                    p_Measure   In        Number,
                                    p_X             Out   Number,
                                    p_Y             Out   Number
                                    )
Is
Begin
  Nm3Sdo.Get_Datum_Xy_From_Measure( p_Ne_Id, p_Measure, p_X, p_Y );
End Get_Datum_Xy_From_Measure;
-----------------------------------------------------------------------------
--
Procedure Create_Theme_Xy_View  (
                                p_Theme_Id  In  Number
                                )
Is
  l_Th       Nm_Themes_All%Rowtype;
  l_Vw       Varchar2(34);
  l_Ddl_Text Varchar2(2000);
Begin
  l_Th := Nm3Get.Get_Nth( p_Theme_Id );
  
  If Substr(l_Th.Nth_Feature_Table, 1 ) = 'V' Then
    l_Vw := l_Th.Nth_Feature_Table||'_XY';
  Else
    l_Vw := 'V_NM_'||l_Th.Nth_Feature_Table||'_XY';
  End If;

  l_Vw := Substr( l_Vw, 1, 30);

  l_Ddl_Text := 'create or replace view '||l_Vw||' as select t.*, v.x, v.y, v.z '||
                ' from '||l_Th.Nth_Feature_Table||' t, table ( sdo_util.getvertices( t.'||l_Th.Nth_Feature_Shape_Column||' ) ) v ';

  Nm3Ddl.Create_Object_And_Syns( l_Vw, l_Ddl_Text );
End Create_Theme_Xy_View;
--
-----------------------------------------------------------------------------
--
Procedure Drop_Layers_By_Node_Type  (
                                    pi_Node_Type         In Nm_Node_Types.Nnt_Type%Type
                                    )
Is
  l_View_Name    User_Views.View_Name%Type;
  l_Nth_Theme_Id Nm_Themes_All.Nth_Theme_Id%Type;
  l_Column_Name  User_Tab_Columns.Column_Name%Type := 'GEOLOC';
  l_Rec_Nth      Nm_Themes_All%Rowtype;
  l_Sql          Nm3Type.Max_Varchar2;
  lf             Varchar2(4)  := Chr(10);
Begin
  Nm_Debug.Proc_Start(G_Package_Name,'drop_layers_by_node_type');

  l_View_Name     := Get_Node_Table(pi_Node_Type);
  l_Nth_Theme_Id  := Get_Theme_From_Feature_Table(l_View_Name);
    
  If l_Nth_Theme_Id Is Null Then
    -- If no theme exists by feature table (i.e. V_NM_NO_ROAD_<>) then
    -- try and derive by theme name.
    -- These might be old node layers (pre 3211) where feature table
    -- was set to nm_point_locations.
    l_Nth_Theme_Id := Nm3Get.Get_Nth  (
                                      pi_Nth_Theme_Name  => 'NODE_'||pi_Node_Type,
                                      pi_Raise_Not_Found => False
                                      ).Nth_Theme_Id;
  End If;

  If l_Nth_Theme_Id Is Not Null Then
    -- Theme exists, so use it
    l_Rec_Nth := Nm3Get.Get_Nth (l_Nth_Theme_Id);
      
    If L_Rec_Nth.Nth_Feature_Table = 'NM_POINT_LOCATIONS' Then
      Drop_Layer  (
                  p_Nth_Id             => l_Rec_Nth.Nth_Theme_Id,
                  p_Keep_Theme_Data    => 'N',
                  p_Keep_Feature_Table => 'Y'
                  );
    Else
      Drop_Layer  (
                  p_Nth_Id             => l_Nth_Theme_Id
                  );
    End If;
  Else
    -- No theme, so attempt to clear up
    Nm3Sdo.Drop_Metadata(l_View_Name);

    Begin
      Nm3Sdo.Drop_Sub_Layer_By_Table(l_View_Name,'GEOLOC');

    Exception 
      When Others Then
        Null;
    End;

    Drop_Object(l_View_Name);

    Declare
      No_Public_Syn_Exists Exception;
      Pragma Exception_Init ( No_Public_Syn_Exists, -20304 );
        
      No_Private_Syn_Exists Exception;
      Pragma Exception_Init ( No_Private_Syn_Exists, -1434 );
        
    Begin
      -- AE 23-SEP-2008
      -- Drop views instead of synonyms
      Nm3Ddl.Drop_Views_For_Object (l_View_Name);
    Exception
      When No_Public_Syn_Exists Then
        Null; -- we don't care - as long as it does not exist now.
          
      When No_Private_Syn_Exists Then
        Null; -- we don't care - as long as it does not exist now.
    End;

    Begin
      Execute Immediate
        'BEGIN '||Chr(10)||
        '  Nm3sde.drop_layer_by_table(l_view_name, '||Nm3Flx.String('GEOLOC')||');'||Chr(10)||
        'END';
    Exception
      When Others Then
        Null;
    End;
  End If;

  Nm_Debug.Proc_End(G_Package_Name,'drop_layers_by_node_type');
--
End Drop_Layers_By_Node_Type;
--
-----------------------------------------------------------------------------
--
Procedure Refresh_Node_Layers
Is
  l_Int           Integer;
  l_Rec_Nth       Nm_Themes_All%Rowtype;
  l_Rec_Npl_Nth   Nm_Themes_All%Rowtype;
  l_Theme_Id      Nm_Themes_All.Nth_Theme_Id%Type;
Begin
  -- Test for nm_point_locations theme
  l_Theme_Id := Get_Theme_From_Feature_Table  (
                                              'NM_POINT_LOCATIONS',
                                              'NM_POINT_LOCATIONS'
                                              );
  If l_Theme_Id Is Null Then
    Register_Npl_Theme;
  End If;

  For i In  (
            Select  *
            From    Nm_Node_Types
            )
  Loop
    Drop_Layers_By_Node_Type (i.Nnt_Type);
    l_Int := Create_Node_Metadata (i.Nnt_Type);
  End Loop;
--
End Refresh_Node_Layers;
--
-----------------------------------------------------------------------------
--
Function Get_Global_Unit_Factor Return Number Is
Begin
  Return G_Unit_Conv;
End Get_Global_Unit_Factor;
--
------------------------------------------------------------------------------
-- AE Added new procedure to maintain visable themes
-- very basic version to start with, it doesn't deal with it on a user basis,
-- so changes affect all users
--
Procedure Maintain_Ntv  (
                        pi_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type,
                        pi_Mode     In Varchar2
                        )
Is
  l_Default_Vis Varchar2(1) := Nvl(Hig.Get_User_Or_Sys_Opt('DEFVISNTH'),'N');
Begin
  If pi_Mode = 'INSERTING'  Then

    Insert Into Nm_Themes_Visible
    (
    Ntv_Nth_Theme_Id,
    Ntv_Visible
    )
    Values
    (
    pi_Theme_Id,
    l_Default_Vis
    );
  End If;

End Maintain_Ntv;
--
------------------------------------------------------------------------------
--
Procedure Set_Theme_Srid_Ctx  (
                              pi_Theme_Id In Nm_Themes_All.Nth_Theme_Id%Type
                              )
Is
  l_Srid                Varchar2 (10);
  l_Sdo                 User_Sdo_Geom_Metadata%Rowtype;
  --
Begin
  If Sys_Context('NM3CORE', 'THEME'|| pi_Theme_Id ||'SRID') Is Null Then 
    l_Sdo := Nm3Sdo.Get_Theme_Metadata (pi_Theme_Id);
--    l_Srid :=  Nvl (To_Char (l_Sdo.Srid), 'NULL');
    l_Srid :=  To_Char (l_Sdo.Srid);

    Nm3Ctx.Set_Core_Context (
                            p_Attribute   => 'THEME'|| pi_Theme_Id || 'SRID',
                            p_Value       => l_Srid
                            );
  End If;
End Set_Theme_Srid_Ctx;
--
------------------------------------------------------------------------------
--
Function Build_Inv_Sdo_Join_View Return User_Views.View_Name%Type
Is

  l_View_Tab    t_View_Tab;
  View_Creation_Error   Exception;
  Pragma Exception_Init(View_Creation_Error,-20001);
Begin
  Nm_Debug.Debug('Nm3Sdm.Build_Inv_Sdo_Join_View - Called');
    
  Select        View_Name,
                View_Text,
                View_Comments 
  Bulk Collect    
  Into          l_View_Tab
  From          V_Nm_Rebuild_All_Inv_Sdo_Join;
    
  For x In  1 .. l_View_Tab.Count
  Loop
    Begin
      Process_View_DDL (p_View_Rec=> l_View_Tab(x));
    Exception
      When View_Creation_Error Then
        Null;
    End;                                             
  End Loop;
       
  Nm_Debug.Debug('Nm3Sdm.Build_Inv_Sdo_Join_View - Finished');
    
  --Only return a view name if we only processed one view.
  Return ((Case When l_View_Tab.Count = 1 Then l_View_Tab(1).View_Name Else Null End) );
    
End Build_Inv_Sdo_Join_View;
--
-------------------------------------------------------------------------------------------------------------------------------------
--
Function Create_Inv_Sdo_Join_View (
                                  p_Feature_Table_Name  In    Varchar2
                                  ) Return  User_Views.View_Name%Type
Is
  l_View_Name   User_Views.View_Name%Type; 
Begin
  Nm_Debug.Debug('Nm3Sdm.Create_Inv_Sdo_Join_View - Called');
  Nm_Debug.Debug('Parameter - p_Feature_Table_Name:'              || p_Feature_Table_Name);

  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',p_Feature_Table_Name );
   
  l_View_Name:=Build_Inv_Sdo_Join_View;

  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',Null );
            
  Nm_Debug.Debug('Nm3Sdm.Create_Inv_Sdo_Join_View - Finished - Returning:');
    
  Return l_View_Name;

End Create_Inv_Sdo_Join_View;
--
------------------------------------------------------------------------------
--
Procedure Rebuild_All_Inv_Sdo_Join_View
Is
  l_View_Name   User_Views.View_Name%Type;    
Begin
  Nm_Debug.Debug('nm3sdm.Rebuild_All_Inv_Sdo_Join_View - Called');
    
  --This limits the rows returned by the V_Nm_Rebuild_All_Inv_Sdo_Join view, which is used by Build_Inv_Sdo_Join_View.
  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB','NM_%_SDO');
    
  l_View_Name:=Build_Inv_Sdo_Join_View;
    
  Nm3Ctx.Set_Context('THEME_API_FEATURE_TAB',Null );

  Nm_Debug.Debug('nm3sdm.Rebuild_All_Inv_Sdo_Join_View - Finished');
End Rebuild_All_Inv_Sdo_Join_View;

--
-----------------------------------------------------------------------------
--Added these functions / procedure back in due to SM, impact.
-----------------------------------------------------------------------------
--
 
--
-----------------------------------------------------------------------------
--
   FUNCTION get_node_type (p_nt_type IN NM_TYPES.nt_type%TYPE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN Nm3get.get_nt (pi_nt_type => p_nt_type).nt_node_type;
   END get_node_type;

--
-----------------------------------------------------------------------------
--
   FUNCTION get_node_type (p_theme_id IN NM_THEMES_ALL.nth_theme_id%TYPE)
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN get_node_type
                         (p_nt_type      => get_theme_nt
                                                     (p_theme_id      => p_theme_id)
                         );
   END get_node_type;   
--
-----------------------------------------------------------------------------
--
   FUNCTION get_details (
      p_theme_id   IN   NM_THEMES_ALL.nth_theme_id%TYPE,
      p_ne_id      IN   NUMBER
   )
      RETURN CLOB
   IS
   BEGIN
      RETURN Nm3xmlqry.get_theme_details_as_xml_clob (p_theme_id, p_ne_id);
   END get_details;

-----------------------------------------------------------------------------
--
   FUNCTION get_details (p_ne_id IN NUMBER)
      RETURN CLOB
   IS
   BEGIN
      RETURN Nm3xmlqry.get_obj_details_as_xml_clob (p_ne_id);
   END get_details;
--
-----------------------------------------------------------------------------
--
   PROCEDURE create_element_shape_from_xml (
      p_layer   IN   NUMBER,
      p_ne_id   IN   nm_elements.ne_id%TYPE,
      p_xml     IN   CLOB
   )
   IS
      l_geom   MDSYS.SDO_GEOMETRY;
   BEGIN
      ----   nm_debug.debug_on;
      ----   nm_debug.delete_debug(TRUE);

      ----   nm_debug.DEBUG_CLOB( P_CLOB => p_xml );
      l_geom := Nm3sdo_Xml.load_shape (p_xml            => p_xml,
                                       p_file_type      => 'datum');
      Nm3sdo.insert_element_shape (p_layer      => p_layer,
                                   p_ne_id      => p_ne_id,
                                   p_geom       => l_geom
                                  );
   END;
--
-----------------------------------------------------------------------------
--
--

   PROCEDURE reshape_element (
      p_ne_id   IN   nm_elements.ne_id%TYPE,
      p_geom    IN   MDSYS.SDO_GEOMETRY
   )
   IS
      l_layer    NUMBER;
      l_old_geom mdsys.sdo_geometry;
      l_new_geom mdsys.sdo_geometry;
      l_length   NUMBER;
      l_usgm     user_sdo_geom_metadata%ROWTYPE;
      l_rec_nth  nm_themes_all%ROWTYPE;
   BEGIN
      --nm_debug.debug_on;
      --nm_debug.debug('changing shapes');
      l_layer := get_nt_theme (Nm3get.get_ne (p_ne_id).ne_nt_type);
      l_rec_nth := nm3get.get_nth(l_layer);

      IF Nm3sdo.element_has_shape (l_layer, p_ne_id) = 'TRUE'
      THEN

         -- AE 09-FEB-2009
         -- Brought across the code from 2.10.1.1 branch into the mainstream
         -- version so that the SRID is set on the reshape

         l_old_geom := nm3sdo.get_layer_element_geometry( l_layer, p_ne_id );

         l_new_geom := p_geom;

         IF NVL(l_old_geom.sdo_srid, -9999)  != NVL( l_new_geom.sdo_srid, -9999)
         THEN
           l_new_geom.sdo_srid := l_old_geom.sdo_srid;
         END IF;
      --
      -- Task 0110101
      -- Bring code across from NM3SDO insert_element_shape to validate the
      -- length of the geometry being passed into this procedure
      --
         l_usgm := nm3sdo.get_usgm ( pi_table_name  => l_rec_nth.nth_feature_table
                                   , pi_column_name => l_rec_nth.nth_feature_shape_column );
      --
         l_length := nm3net.get_ne_length ( p_ne_id );
      --
         IF NVL(sdo_lrs.geom_segment_end_measure ( l_new_geom, l_usgm.diminfo ), -9999) != l_length 
         THEN
            sdo_lrs.redefine_geom_segment ( l_new_geom, l_usgm.diminfo, 0, l_length );
         END IF;
      --
         IF sdo_lrs.geom_segment_end_measure ( l_new_geom, l_usgm.diminfo ) != l_length
         THEN
           hig.raise_ner(pi_appl    => nm3type.c_hig
                        ,pi_id      => 204
                        ,pi_sqlcode => -20001 );
         END IF;
      --
      -- Task 0110101 Done
      --
         nm3sdo_edit.reshape ( l_layer, p_ne_id, l_new_geom );
      --
         nm3sdo.change_affected_shapes (p_layer      => l_layer,
                                        p_ne_id      => p_ne_id);
      ELSE
         nm3sdo.insert_element_shape (p_layer      => l_layer,
                                      p_ne_id      => p_ne_id,
                                      p_geom       => p_geom
                                     );
         nm3sdo.change_affected_shapes (p_layer      => l_layer,
                                        p_ne_id      => p_ne_id);
      END IF;

   END reshape_element;
--
-----------------------------------------------------------------------------
--
   PROCEDURE move_node (
      p_no_node_id   IN   nm_nodes.no_node_id%TYPE,
      p_x            IN   NUMBER,
      p_y            IN   NUMBER
   )
   IS
      l_np_id   NM_POINTS.np_id%TYPE;
   BEGIN
      l_np_id := Nm3get.get_no (pi_no_node_id => p_no_node_id).no_np_id;
      UPDATE NM_POINTS np
         SET np.np_grid_east = p_x,
             np.np_grid_north = p_y
       WHERE np.np_id = l_np_id;
   END;   
--
------------------------------------------------------------------------------
--
End Nm3Sdm;
/

