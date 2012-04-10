--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/mv_highlight_index.sql-arc   3.1   Apr 10 2012 15:23:16   Steve.Cooper  $
--       Module Name      : $Workfile:   mv_highlight_index.sql  $
--       Date into PVCS   : $Date:   Apr 10 2012 15:23:16  $
--       Date fetched Out : $Modtime:   Apr 10 2012 15:21:36  $
--       PVCS Version     : $Revision:   3.1  $
--
--------------------------------------------------------------------------------
--

PROMPT Drop the Primary Key constraint

Declare
  Ex_Not_Exists Exception;
  Pragma Exception_Init (Ex_Not_Exists,-02443);
Begin
  Execute Immediate 
    'Alter Table Mv_Highlight Drop Constraint Mv_Highlight_Pk';
Exception
  When Ex_Not_Exists Then Null;
End;
/

PROMPT Drop the Primary Key Index

Declare
  Index_Not_Exists Exception;
  Pragma Exception_Init (Index_Not_Exists,-01418);
Begin
  Execute Immediate 'Drop Index Mv_Highlight_PK';
Exception
  When  Index_Not_Exists Then
    Null;   
End;
/

PROMPT Create a non-unique index to replace it


Declare
  Index_Not_Exists Exception;
  Pragma Exception_Init (Index_Not_Exists,-01418);
Begin
  Execute Immediate 'Drop Index Mv_Highlight_Ind';
Exception
  When  Index_Not_Exists Then
    Null;   
End;
/


Create Index Mv_Highlight_Ind On Mv_Highlight
(
Mv_Id,
Mv_Feat_Type
)
/



