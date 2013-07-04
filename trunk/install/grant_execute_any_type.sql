--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/grant_execute_any_type.sql-arc   1.1   Jul 04 2013 13:45:30   James.Wadsworth  $
--       Module Name      : $Workfile:   grant_execute_any_type.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 13:45:30  $
--       Date fetched Out : $Modtime:   Jul 04 2013 12:00:14  $
--       Version          : $Revision:   1.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
Grant Execute Any Type  To Hig_User
/

Begin
  For x In  (
            Select  drp.Grantee
            From    Dba_Role_Privs    drp
            Where   drp.Granted_Role    =   'HIG_USER'
            And     Not Exists      (
                                    Select    Null     
                                    From      Dba_Sys_Privs   dsp
                                    Where     dsp.Privilege    Like   'EXECUTE ANY TYPE'
                                    And       dsp.Grantee      =     drp.Grantee
                                    )
            )
  Loop
    Execute Immediate 'Grant Execute Any Type to ' || x.Grantee;    
  End Loop;
End;
/
