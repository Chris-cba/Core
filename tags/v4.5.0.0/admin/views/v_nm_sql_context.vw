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
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_sql_context.vw-arc   2.1   Feb 25 2011 10:59:16   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_nm_sql_context.vw  $
          --       Date into PVCS   : $Date:   Feb 25 2011 10:59:16  $
          --       Date fetched Out : $Modtime:   Feb 25 2011 10:51:54  $
          --       Version          : $Revision:   2.1  $
          -------------------------------------------------------------------------
          -- 
          sc.Attribute,
          sc.Value
From      Session_Context   sc
Where     sc.Namespace      =   'NM3SQL'
Order By  sc.Attribute
/

