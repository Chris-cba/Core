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
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_sql_context.vw-arc   2.2   Jul 04 2013 11:35:14   James.Wadsworth  $
          --       Module Name      : $Workfile:   v_nm_sql_context.vw  $
          --       Date into PVCS   : $Date:   Jul 04 2013 11:35:14  $
          --       Date fetched Out : $Modtime:   Jul 04 2013 11:33:30  $
          --       Version          : $Revision:   2.2  $
          -----------------------------------------------------------------------------
          --    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          -- 
          sc.Attribute,
          sc.Value
From      Session_Context   sc
Where     sc.Namespace      =   'NM3SQL'
Order By  sc.Attribute
/

