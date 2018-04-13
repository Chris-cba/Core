Create Or Replace Force View V_Nm_Hig1832_User_TS_RG
(
Tablespace_Name
)
As
Select    --
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //new_vm_latest/archives/nm3/admin/views/v_nm_hig1832_user_ts_rg.vw-arc   1.2   Apr 13 2018 11:47:24   Gaurav.Gaurkar  $
          --       Module Name      : $Workfile:   v_nm_hig1832_user_ts_rg.vw  $
          --       Date into PVCS   : $Date:   Apr 13 2018 11:47:24  $
          --       Date fetched Out : $Modtime:   Apr 13 2018 11:40:54  $
          --       Version          : $Revision:   1.2  $
          -------------------------------------------------------------------------
          --
		  --
		  --------------------------------------------------------------------------------------------------------------------
		  --   Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
		  --------------------------------------------------------------------------------------------------------------------
		  --
          ut.Tablespace_Name 
From      User_Tablespaces      ut
Where     ut.Contents           =   'PERMANENT'
And       ut.Tablespace_Name    !=  'HHINV_LOAD_3_SPACE'
Order By  ut.Tablespace_Name
With Read Only
/
