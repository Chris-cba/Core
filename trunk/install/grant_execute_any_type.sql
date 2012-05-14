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
