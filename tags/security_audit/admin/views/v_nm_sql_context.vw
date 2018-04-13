Create Or Replace Force View V_Nm_Sql_Context
(
Attribute,
Value
)
As
Select    --
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_sql_context.vw-arc   2.3   Apr 13 2018 11:47:26   Gaurav.Gaurkar  $
          --       Module Name      : $Workfile:   v_nm_sql_context.vw  $
          --       Date into PVCS   : $Date:   Apr 13 2018 11:47:26  $
          --       Date fetched Out : $Modtime:   Apr 13 2018 11:44:38  $
          --       Version          : $Revision:   2.3  $
          -----------------------------------------------------------------------------
          --    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          -- 
          sc.Attribute,
          sc.Value
From      Session_Context   sc
Where     sc.Namespace      =   'NM3SQL'
Order By  sc.Attribute
/

