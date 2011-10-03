Create Or Replace Force View V_Nm_Hig1832_User_TS_RG
(
Tablespace_Name
)
As
Select    --
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_hig1832_user_ts_rg.vw-arc   1.0   Oct 03 2011 09:43:48   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_nm_hig1832_user_ts_rg.vw  $
          --       Date into PVCS   : $Date:   Oct 03 2011 09:43:48  $
          --       Date fetched Out : $Modtime:   Sep 20 2011 14:46:36  $
          --       Version          : $Revision:   1.0  $
          -------------------------------------------------------------------------
          --
          ut.Tablespace_Name 
From      User_Tablespaces      ut
Where     ut.Contents           =   'PERMANENT'
And       ut.Tablespace_Name    !=  'HHINV_LOAD_3_SPACE'
Order By  ut.Tablespace_Name
With Read Only
/