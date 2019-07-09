Create Or Replace Package Body Nm3_Java_Utils
As
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/pck/nm3_java_utils.pkb-arc   1.0   Jul 09 2019 15:35:28   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3_java_utils.pkb  $
--       Date into SCCS   : $Date:   Jul 09 2019 15:35:28  $
--       Date fetched Out : $Modtime:   Jul 04 2019 10:44:48  $
--       SCCS Version     : $Revision:   1.0  $
--         Based on
--
-----------------------------------------------------------------------------
-- Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
-----------
--constants
-----------
--g_body_sccsid is the SCCS ID for the package body

  g_Body_Sccsid           Constant  Varchar2(2000)  :=  '$Revision:   1.0  $';
  g_Package_Name          Constant  Varchar2(30)    :=  'Nm3_Java_Utils';
--
-----------------------------------------------------------------------------------
--
Function Get_Version Return Varchar2
Is
Begin
 Return g_Sccsid;
End Get_Version;
--
-----------------------------------------------------------------------------------
--
Function Get_Body_Version Return Varchar2
Is
Begin
   Return g_Body_Sccsid;
End Get_Body_Version;
--
-----------------------------------------------------------------------------------
--
Function Convert_To_Java_Path (
                              p_Path    In      Varchar2
                              ) Return Varchar2
Is
  l_Path  Varchar2(4000) := p_Path;
Begin
  Nm_Debug.Debug(g_Package_Name || '.Convert_To_Java_Path - Called');
  Nm_Debug.Debug('Parameter - p_Path:' || p_Path);
  l_Path  :=  Replace(p_Path,'\','\\');
  Nm_Debug.Debug(g_Package_Name || '.Convert_To_Java_Path - Finished - Returning:' || l_Path);
  Return (l_Path);
End Convert_To_Java_Path;
--
-----------------------------------------------------------------------------------
--
Procedure Privs_Check (
                      p_Role_Name   In    Varchar2
                      )
Is
  l_Dummy Varchar2(1);
Begin
  Nm_Debug.Debug(g_Package_Name || '.Privs_Check - Called');
  Select  Null
  Into    l_Dummy
  From    User_Role_Privs
  Where   Granted_Role = p_Role_Name;

  Nm_Debug.Debug(g_Package_Name || '.Privs_Check - Finished');

Exception
  When No_Data_Found Then
    Nm_Debug.Debug(g_Package_Name ||'.Privs_Check - Exception You do not have permission to perform this action');
    Raise_Application_Error(-20001,'You do not have permission to perform this action');

End Privs_Check;
--
-----------------------------------------------------------------------------
--
Function Extract_Shapefile  (
                            p_Host                 In Varchar2,
                            p_Port                 In Number,
                            p_Sid                  In Varchar2,
                            p_Username             In Varchar2,
                            p_Password             In Varchar2,
                            p_Table_Column         In Varchar2,
                            p_File_Path            In Varchar2,
                            p_Where_Clause         In Varchar2,
                            p_Attrib_Map_File_Path In Varchar2
                            ) Return Varchar2
As Language Java
Name 'CMDUtilities.extractShapefile(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String) return oracle.sql.string';
--
-----------------------------------------------------------------------------------
--
Function Extract_Shape_File (
                            p_Host                 In Varchar2,
                            p_Port                 In Number,
                            p_Sid                  In Varchar2,
                            p_Username             In Varchar2,
                            p_Password             In Varchar2,
                            p_Table_Column         In Varchar2,
                            p_File_Path            In Varchar2,
                            p_Where_Clause         In Varchar2,
                            p_Attrib_Map_File_Path In Varchar2
                            ) Return Varchar2
Is

Begin
  Nm_Debug.Debug(g_Package_Name || '.Extract_Shape_File - Called');
  Nm_Debug.Debug('Parameter  - p_File_Path :' || p_File_Path);  
  Nm_Debug.Debug('Parameter  - p_Attrib_Map_File_Path :' || p_Attrib_Map_File_Path);

  Privs_Check (           
              p_Role_Name   =>    'EXTRACT_SHAPE_FILE'
              );                              

  Return  (
          Extract_Shapefile (                               
                            p_Host                 =>   p_Host,
                            p_Port                 =>   p_Port,
                            p_Sid                  =>   p_Sid,
                            p_Username             =>   p_Username,
                            p_Password             =>   p_Password,
                            p_Table_Column         =>   p_Table_Column,
                            p_File_Path            =>   Convert_To_Java_Path(p_File_Path),
                            p_Where_Clause         =>   p_Where_Clause,
                            p_Attrib_Map_File_Path =>   Convert_To_Java_Path(p_Attrib_Map_File_Path)
                            )
          );
  
End Extract_Shape_File;   --  do_sde2shp
--
-----------------------------------------------------------------------------
--
Function Upload_Shapefile (
                          p_Host                     In     Varchar2,
                          p_Port                     In     Number,
                          p_Sid                      In     Varchar2,
                          p_Username                 In     Varchar2,
                          p_Password                 In     Varchar2,
                          p_Table_Name               In     Varchar2,
                          p_File_Path                In     Varchar2,
                          p_Unique_Col_Name          In     Varchar2,
                          p_Srid                     In     Number,
                          p_Geom_Col_Name            In     Varchar2,
                          p_X_Bounds                 In     Varchar2,
                          p_Y_Bounds                 In     Varchar2,
                          p_Tolerance                In     Varchar2,
                          p_Mode_Of_Operation        In     Varchar2,
                          p_Unique_Col_Start_Id      In     Number,
                          p_Commit_Interval          In     Number,
                          p_Attrib_Map_File_Path     In     Varchar2
                          ) Return Varchar2
As Language Java
Name 'CMDUtilities.uploadShapefile(java.lang.String, java.lang.Integer, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.Integer, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.Integer, java.lang.Integer, java.lang.String) return oracle.sql.string';
--
-----------------------------------------------------------------------------
--
Function Upload_Shape_File  (
                            p_Host                     In     Varchar2,
                            p_Port                     In     Number,
                            p_Sid                      In     Varchar2,
                            p_Username                 In     Varchar2,
                            p_Password                 In     Varchar2,
                            p_Table_Name               In     Varchar2,
                            p_File_Path                In     Varchar2,
                            p_Unique_Col_Name          In     Varchar2,
                            p_Srid                     In     Number,
                            p_Geom_Col_Name            In     Varchar2,
                            p_X_Bounds                 In     Varchar2,
                            p_Y_Bounds                 In     Varchar2,
                            p_Tolerance                In     Varchar2,
                            p_Mode_Of_Operation        In     Varchar2,
                            p_Unique_Col_Start_Id      In     Number,
                            p_Commit_Interval          In     Number,
                            p_Attrib_Map_File_Path     In     Varchar2
                            ) Return Varchar2
Is

Begin
  Nm_Debug.Debug(g_Package_Name || '.Upload_Shape_File - Called');  
  Nm_Debug.Debug('Parameter  - p_File_Path :' || p_File_Path);  
  Nm_Debug.Debug('Parameter  - p_Attrib_Map_File_Path :' || p_Attrib_Map_File_Path);

  Privs_Check (
              p_Role_Name   =>    'UPLOAD_SHAPE_FILE'
              );

  Nm_Debug.Debug(g_Package_Name || '.Upload_Shape_File - Finished');

  Return  (
          Upload_Shapefile  (
                            p_Host                     =>   p_Host,
                            p_Port                     =>   p_Port,
                            p_Sid                      =>   p_Sid,
                            p_Username                 =>   p_Username,
                            p_Password                 =>   p_Password,
                            p_Table_Name               =>   p_Table_Name,
                            p_File_Path                =>   Convert_To_Java_Path(p_File_Path),
                            p_Unique_Col_Name          =>   p_Unique_Col_Name,
                            p_Srid                     =>   p_Srid,
                            p_Geom_Col_Name            =>   p_Geom_Col_Name,
                            p_X_Bounds                 =>   p_X_Bounds,
                            p_Y_Bounds                 =>   p_Y_Bounds,
                            p_Tolerance                =>   p_Tolerance,
                            p_Mode_Of_Operation        =>   p_Mode_Of_Operation,
                            p_Unique_Col_Start_Id      =>   p_Unique_Col_Start_Id,
                            p_Commit_Interval          =>   p_Commit_Interval,
                            p_Attrib_Map_File_Path     =>   Convert_To_Java_Path(p_Attrib_Map_File_Path)
                            )
          );

End Upload_Shape_File;
--
-----------------------------------------------------------------------------
--
Function Check_Xss  (
                    P_Url_Parameters    In    Varchar2
                    ) Return Varchar2
As Language Java
Name 'CMDUtilities.checkXSS(java.lang.String) return oracle.sql.string';
--
-----------------------------------------------------------------------------
--
Function Check_For_Xss      (
                            P_Url_Parameters     In  Varchar2
                            ) Return Varchar2
Is

Begin
  Privs_Check (
              p_Role_Name   =>    'CHECK_XSS'
              );

  Return  (
          Check_Xss (
                    P_Url_Parameters     =>  P_Url_Parameters
                    )
          );

End Check_For_Xss;
--
-----------------------------------------------------------------------------------
--
End Nm3_Java_Utils;
/


