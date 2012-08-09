------------------------------------------------------------------
-- nm4500_nm4600_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4500_nm4600_metadata_upg.sql-arc   1.2   Aug 09 2012 09:37:20   Rob.Coupe  $
--       Module Name      : $Workfile:   nm4500_nm4600_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Aug 09 2012 09:37:20  $
--       Date fetched Out : $Modtime:   Aug 09 2012 09:26:08  $
--       Version          : $Revision:   1.2  $
--
------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2011

SET ECHO OFF
SET LINESIZE 120
SET HEADING OFF
SET FEEDBACK OFF

DECLARE
  l_temp nm3type.max_varchar2;
BEGIN
  -- Dummy call to HIG to instantiate it
  l_temp := hig.get_version;
  l_temp := nm_debug.get_version;
EXCEPTION
  WHEN others
   THEN
 Null;
END;
/

BEGIN
  nm_debug.debug_off;
END;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New process to clean up forms parameter table everyday
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New process to clean up forms parameter table everyday
-- 
------------------------------------------------------------------
Begin
  Insert Into Hig_Process_Types
  (
  Hpt_Process_Type_Id,
  Hpt_Name,
  Hpt_Descr,
  Hpt_What_To_Call,
  Hpt_Initiation_Module,
  Hpt_Internal_Module,
  Hpt_Internal_Module_Param,
  Hpt_Process_Limit,
  Hpt_Restartable,
  Hpt_See_In_Hig2510,
  Hpt_Polling_Enabled,
  Hpt_Polling_Ftp_Type_Id,
  Hpt_Area_Type
  )
  Values
  ( 
  -3,
  'Core Housekeeping',
  'A general collection of Core housekeeping routines.',
  'Hig_Router_Params_Utils.Clear_Down_Old_Params;',
  Null,
  Null,
  Null,
  Null,
  'N',
  'Y',
  'N',
  Null,
  Null
  ); 
Exception
  When Dup_Val_On_Index Then
    Null;
End;  
/

Begin                   
  Insert Into Hig_Process_Type_Roles
  (
  Hptr_Process_Type_Id,
  Hptr_Role
  )
  Values
  ( 
  -3,
  'NET_ADMIN' 
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

Begin
  Insert Into Hig_Process_Type_Frequencies
  (
  Hpfr_Process_Type_Id,
  Hpfr_Frequency_Id,
  Hpfr_Seq
  )
  Values 
  (
  -3,
  -11,
  1
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

Declare
  l_Process_Id            Hig_Processes.Hp_Process_Id%Type;
  l_Job_Name              Hig_Processes.Hp_Job_Name%Type;
  l_Scheduled_Start_Date  Date;
Begin
  dbms_scheduler.set_scheduler_attribute('SCHEDULER_DISABLED', 'FALSE');
--
  Hig_Process_Api.Create_And_Schedule_Process (
                                              pi_Process_Type_Id           =>   -3,
                                              pi_Initiators_Ref            =>   'COREHOUSE',
                                              pi_Start_Date                =>   Sysdate,
                                              pi_Frequency_Id              =>   -11,
                                              po_Process_Id                =>   l_Process_Id,
                                              po_Job_Name                  =>   l_Job_Name,
                                              po_Scheduled_Start_Date      =>   l_Scheduled_Start_Date
                                              );
  dbms_scheduler.set_scheduler_attribute('SCHEDULER_DISABLED', 'TRUE');
--
   Commit;
  Dbms_Output.Put_Line('Created Core Houseleeping Process');                                              
  Dbms_Output.Put_Line('Process_Id:'            || To_Char(l_Process_Id) );
  Dbms_Output.Put_Line('Job_Name:'              || l_Job_Name);
  Dbms_Output.Put_Line('Scheduled_Start_Date:'  || To_Char(l_Scheduled_Start_Date,'dd-mm-yyyy hh24:mi.ss'));  
End;
/


------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New messages used within the user form hig1832.
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New messages used within the user form hig1832.
-- 
------------------------------------------------------------------
Begin
  Insert Into Nm_Errors
  (
  Ner_Appl,
  Ner_Id,
  Ner_Descr
  )
  Values
  (
  'NET',
  559,
  'User Successfully Unlocked'
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

Begin
  Insert Into Nm_Errors
  (
  Ner_Appl,
  Ner_Id,
  Ner_Descr
  )
  Values
  (
  'NET',
  560,
  'Invalid Username'
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Error Messages
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (LINESH SORATHIA)
-- New error message for Navigator.
-- 
------------------------------------------------------------------
INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'HIG'
     , 557
     , 'Asset is end dated'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'HIG'
                       AND NER_ID = 557)
/
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

