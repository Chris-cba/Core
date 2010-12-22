--
--------------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //vm_latest/archives/nm3/admin/utl/mv_highlight_index.sql-arc   3.0   Dec 22 2010 10:14:32   Ade.Edwards  $
--       Module Name      : $Workfile:   mv_highlight_index.sql  $
--       Date into PVCS   : $Date:   Dec 22 2010 10:14:32  $
--       Date fetched Out : $Modtime:   Dec 22 2010 10:12:08  $
--       PVCS Version     : $Revision:   3.0  $
--
--------------------------------------------------------------------------------
--

PROMPT Drop the Primary Key constraint

DECLARE
  ex_not_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT (ex_not_exists,-02443);
BEGIN
  EXECUTE IMMEDIATE 
    'ALTER TABLE MV_HIGHLIGHT DROP CONSTRAINT MV_HIGHLIGHT_PK';
EXCEPTION
  WHEN ex_not_exists THEN NULL;
END;
/

PROMPT Create a non-unique index to replace it

DECLARE
  ex_not_exists EXCEPTION;
  PRAGMA EXCEPTION_INIT (ex_not_exists,-01418);
BEGIN
  EXECUTE IMMEDIATE
    'DROP INDEX MV_HIGHLIGHT_IND';
  EXECUTE IMMEDIATE
    'CREATE INDEX MV_HIGHLIGHT_IND ON MV_HIGHLIGHT(MV_ID, MV_FEAT_TYPE)';
EXCEPTION
  WHEN ex_not_exists 
  THEN 
    EXECUTE IMMEDIATE
      'CREATE INDEX MV_HIGHLIGHT_IND ON MV_HIGHLIGHT(MV_ID, MV_FEAT_TYPE)';
END;
/

