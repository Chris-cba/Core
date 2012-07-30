------------------------------------------------------------------
-- nm4400_nm4500_metadata_upg.sql
------------------------------------------------------------------


------------------------------------------------------------------

--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/nm4400_nm4500_metadata_upg.sql-arc   3.4   Jul 30 2012 12:59:06   Steve.Cooper  $
--       Module Name      : $Workfile:   nm4400_nm4500_metadata_upg.sql  $
--       Date into PVCS   : $Date:   Jul 30 2012 12:59:06  $
--       Date fetched Out : $Modtime:   Jul 30 2012 12:51:54  $
--       Version          : $Revision:   3.4  $
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
PROMPT Error Messages
SET TERM OFF

------------------------------------------------------------------
-- ASSOCIATED DEVELOPMENT TASK
-- 110847
-- 
-- TASK DETAILS
-- Previously a number of network edits would only be available to unrestricted users. The security has been modified to allow restricted users that can see all the network to make edits also. This included areas such as Closing Elements, Unclosing Elements, Reclassify, Closing of Group of Group and Group of Sections.
-- 
-- 
-- DEVELOPMENT COMMENTS (CHRIS STRETTLE)
-- All new or modified error messages for the 4500 release.
-- 
------------------------------------------------------------------
UPDATE nm_errors
SET ner_descr = 'User does not have access to all assets on the element'
WHERE ner_appl = 'NET'
AND ner_id = 172
/

INSERT INTO NM_ERRORS ( NER_APPL
                      , NER_ID
                      , NER_DESCR)
SELECT 'NET'
     , 556
     , 'Update is not possible. This inventory and network type combination has child records.'
     FROM DUAL
     WHERE NOT EXISTS (SELECT 'X' 
                       FROM NM_ERRORS
                       WHERE NER_APPL = 'NET'
                       AND NER_ID = 556)
/
------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT Load the Synonym exemption table
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- Loads the synonym exemption table with the default exemptions.
-- 
------------------------------------------------------------------
Insert Into
Nm_Syn_Exempt
(
Nsyn_Object_Name,
Nsyn_Object_Type
)
Select    'V_MCP_EXTRACT%',
          'VIEW'
From      Dual
Where     Not Exists  (
                      Select  Null
                      From    Nm_Syn_Exempt
                      Where   Nsyn_Object_Name    =   'V_MCP_EXTRACT%'
                      And     Nsyn_Object_Type    =   'VIEW'
                      )          
/

Insert Into
Nm_Syn_Exempt
(
Nsyn_Object_Name,
Nsyn_Object_Type
)
Select    'V_MCP_UPLOAD%',
          'VIEW'
From      Dual
Where     Not Exists  (
                      Select  Null
                      From    Nm_Syn_Exempt
                      Where   Nsyn_Object_Name    =   'V_MCP_UPLOAD%'
                      And     Nsyn_Object_Type    =   'VIEW'
                      )
/           

------------------------------------------------------------------
SET TERM ON
PROMPT New messages for Hig1832
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- new messages to support hig1832
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
  557,
  'The user you are trying to disable has active job(s), do you want to disable these jobs?'
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
  558,
  'The user has no quota on their default tablespace.'
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/

------------------------------------------------------------------


------------------------------------------------------------------
SET TERM ON
PROMPT New process frequency
SET TERM OFF

------------------------------------------------------------------
-- 
-- DEVELOPMENT COMMENTS (STEVEN COOPER)
-- New process frequency of 30 seconds.
-- 
------------------------------------------------------------------
Begin
  Insert Into Hig_Scheduling_Frequencies
  (
  Hsfr_Frequency_Id,
  Hsfr_Meaning,
  Hsfr_Frequency,
  Hsfr_Interval_In_Mins
  )
  Values
  (
  -2,
  '30 Seconds',
  'freq=secondly; interval=30;',
  Null
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/
------------------------------------------------------------------


------------------------------------------------------------------

Commit;
------------------------------------------------------------------



------------------------------------------------------------------
-- end of script 
------------------------------------------------------------------

