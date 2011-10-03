Create Or Replace Force View V_Nm_Hig_Users
(
Hus_User_Id,
Hus_Name,
Hus_Initials,
Hus_Unrestricted,
Hus_Job_Title,
Hus_Start_Date,
Hus_Agent_Code,
Hus_End_Date,
Hus_Username,
Hus_Admin_Unit,
Default_Tablespace,
Temporary_Tablespace,
Password,
Profile,
Default_TS_Quota,
Quota_Size_Type,
Admin_Unit_Code,
Admin_Unit_Name,
Account_Status,
Hus_Rowid
)
As
Select    --
          -------------------------------------------------------------------------
          --   PVCS Identifiers :-
          --
          --       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/views/v_nm_hig_users.vw-arc   1.0   Oct 03 2011 09:43:48   Steve.Cooper  $
          --       Module Name      : $Workfile:   v_nm_hig_users.vw  $
          --       Date into PVCS   : $Date:   Oct 03 2011 09:43:48  $
          --       Date fetched Out : $Modtime:   Sep 26 2011 14:22:48  $
          --       Version          : $Revision:   1.0  $
          -------------------------------------------------------------------------
          --
          hu.Hus_User_Id,
          hu.Hus_Name,
          hu.Hus_Initials,
          hu.Hus_Unrestricted,
          hu.Hus_Job_Title,
          hu.Hus_Start_Date,
          hu.Hus_Agent_Code,
          hu.Hus_End_Date,
          hu.Hus_Username,
          hu.Hus_Admin_Unit,
          du.Default_Tablespace,
          du.Temporary_Tablespace,
          To_Char(Null),
          du.Profile,
          (
          Case 
            When  dtq.Max_Bytes =  -1 Then 'UNLIMITED'
            Else  To_Char(dtq.Max_Bytes)          
          End
          ) Default_TS_Quota,
          To_Char(Null), --Null means bytes.
          hau.Hau_Unit_Code,
          hau.Hau_Name,
          Nvl(du.Account_Status,'MISSING'),
          hu.Rowid
From      Hig_Users         hu,
          Dba_Users         du,
          Dba_Ts_Quotas     dtq,
          Hig_Admin_Units   hau
Where     hu.Hus_Admin_Unit       =   hau.hau_Admin_Unit(+)
And       hu.Hus_Username         =   du.Username(+)
And       du.Username             =   dtq.Username(+)
And       du.Default_Tablespace   =   dtq.Tablespace_Name(+)
And       (
          Case 
            --All
            When  Sys_Context('NM3SQL','HIG1832_FILTER')        =   'A'                                              Then 1
            --Active
            When  (     Sys_Context('NM3SQL','HIG1832_FILTER')  =   'L' And
                    (   hu.Hus_End_Date  Is Null
                    Or  hu.Hus_End_Date  >  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                    )
                  )                                                                                                   Then 1 
            --End dated.
            When  ( Sys_Context('NM3SQL','HIG1832_FILTER')      =   'E' And 
                    hu.Hus_End_Date  <=  To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                  )                                                                                                   Then 1
          End
          ) = 1
/             
                  