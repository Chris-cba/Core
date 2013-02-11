--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/install/nm_4500_fix30_dml.sql-arc   1.0   Feb 11 2013 13:02:08   Steve.Cooper  $
--       Module Name      : $Workfile:   nm_4500_fix30_dml.sql  $ 
--       Date into PVCS   : $Date:   Feb 11 2013 13:02:08  $
--       Date fetched Out : $Modtime:   Feb 11 2013 10:28:22  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2012 Bentley Systems Incorporated.
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
