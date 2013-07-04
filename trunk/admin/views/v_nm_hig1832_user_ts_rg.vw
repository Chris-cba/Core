Create Or Replace Force View V_Nm_Hig1832_User_TS_RG
(
Tablespace_Name
)
As
Select    --
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_hig1832_user_ts_rg.vw-arc   1.1   Jul 04 2013 11:23:48   James.Wadsworth  $
          --       Module Name      : $Workfile:   v_nm_hig1832_user_ts_rg.vw  $
          --       Date into PVCS   : $Date:   Jul 04 2013 11:23:48  $
          --       Date fetched Out : $Modtime:   Jul 04 2013 10:33:42  $
          --       Version          : $Revision:   1.1  $
          -------------------------------------------------------------------------
          --
          ut.Tablespace_Name 
From      User_Tablespaces      ut
Where     ut.Contents           =   'PERMANENT'
And       ut.Tablespace_Name    !=  'HHINV_LOAD_3_SPACE'
Order By  ut.Tablespace_Name
With Read Only
/
