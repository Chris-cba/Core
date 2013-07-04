--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4500_fix30_dml.sql-arc   1.1   Jul 04 2013 13:48:08   James.Wadsworth  $
--       Module Name      : $Workfile:   nm_4500_fix30_dml.sql  $ 
--       Date into PVCS   : $Date:   Jul 04 2013 13:48:08  $
--       Date fetched Out : $Modtime:   Jul 04 2013 11:54:24  $
--       PVCS Version     : $Revision:   1.1  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

Begin
  Insert Into Nm_Errors
  (
  Ner_Appl,
  Ner_Id,
  Ner_Her_No,
  Ner_Descr,
  Ner_Cause
  )
  Values
  (
  'HIG',
  558,
  Null,
  'Not all selections could be deleted',
  Null
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
  Ner_Her_No,
  Ner_Descr,
  Ner_Cause
  )
  Values
  (
  'HIG',
  559,
  Null,
  'All selections deleted',
  Null
  );
Exception
  When Dup_Val_On_Index Then
    Null;
End;
/
