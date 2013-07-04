Create Or Replace Force View V_Nm_Admin_Units_Tree
(
Initial_State,
Depth,
Label,
Icon,
Data,
Pathy
)
As
Select  
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_admin_units_tree.vw-arc   3.1   Jul 04 2013 11:35:12   James.Wadsworth  $
          --       Module Name      : $Workfile:   v_nm_admin_units_tree.vw  $
          --       Date into PVCS   : $Date:   Jul 04 2013 11:35:12  $
          --       Date fetched Out : $Modtime:   Jul 04 2013 11:30:20  $
          --       Version          : $Revision:   3.1  $
          --
          -----------------------------------------------------------------------------
          --   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
          -----------------------------------------------------------------------------
          1                                           Initial_State,
          1                                           Depth,
          nau.Nau_Unit_Code || ' - ' || nau.Nau_Name  Label,
          Nm3Flx.String('dummy')                      Icon,
          nau.Nau_Admin_Unit                          Data,
          '/'                                         Pathy
From      Nm_Admin_Units    nau
Where     nau.Nau_Admin_Unit    =   1
Union All
Select    1                                           Initial_State,
          l_Level+1                                   Depth,
          x.Nau_Unit_Code || ' - ' || x.Nau_Name      Label,
          nm3flx.string('dummy')                      Icon,
          Nau_Admin_Unit                              Data,
          Pathy                                       Pathy
From      (
          Select    tre.Nag_Parent_Admin_Unit,
                    tre.Nag_Child_Admin_Unit,
                    tre.Nau_Name,
                    tre.Nau_Admin_Unit,
                    tre.Nau_Unit_Code,
                    Level L_Level,
                    Sys_Connect_By_Path( tre.Nau_Unit_Code || ' - ' || tre.Nau_Name, '/' ) Pathy
          From      (          
                    Select  nag.Nag_Parent_Admin_Unit,
                            nag.Nag_Child_Admin_Unit,
                            nau.Nau_Name,
                            nau.Nau_Admin_Unit,
                            nau.Nau_Unit_Code
                    From    Nm_Admin_Groups   nag,
                            Nm_Admin_Units    nau
                    Where   nag.Nag_Direct_Link   = 'Y'
                    And     nau.Nau_Admin_Unit    =   nag.Nag_Child_Admin_Unit          
                    ) tre
                    Connect By Prior  tre.Nag_Child_Admin_Unit  =   tre.Nag_Parent_Admin_Unit
                    Start With        tre.Nag_Parent_Admin_Unit =   To_Number(Sys_Context('NM3SQL','HIG1860_ADMIN_UNIT'))
         ) x
Order By Pathy  
With Read Only
/

Comment on Table V_Nm_Admin_Units_Tree Is 'Provides the Admin Units tree given a Admin Unit.'
/

Comment on Column V_Nm_Admin_Units_Tree.Initial_State Is 'The Initial State of the Tree Node.'
/

Comment on Column V_Nm_Admin_Units_Tree.Depth Is 'The Depth of this Element of the tree structure.'
/

Comment on Column V_Nm_Admin_Units_Tree.Label Is 'The Label of this element of the tree structure.'
/

Comment on Column V_Nm_Admin_Units_Tree.Icon Is 'The Icon associated with this element of the tree structure.'
/

Comment on Column V_Nm_Admin_Units_Tree.Data Is 'The Data attribute that is associated with this element of the tree structure.'
/

Comment on Column V_Nm_Admin_Units_Tree.Pathy Is 'The Path showing the structure of where this element is within the Hierarchy.'
/
