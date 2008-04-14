-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/install/nm3_indexes.sql-arc   3.0   Apr 14 2008 09:59:26   jwadsworth  $
-- Module Name : $Workfile:   nm3_indexes.sql  $
-- Date into PVCS : $Date:   Apr 14 2008 09:59:26  $
-- Date fetched Out : $Modtime:   Apr 14 2008 09:58:50  $
-- PVCS Version : $Revision:   3.0  $
--
Declare
  do_nothing exception;
  pragma exception_init(do_nothing,-955);
Begin
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_DMD_IND ON DOCS (DOC_DLC_DMD_ID)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_DTP_IND ON DOCS (DOC_DTP_CODE)');  
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_HAU_IND ON DOCS (DOC_ADMIN_UNIT)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
  Begin
    EXECUTE IMMEDIATE('CREATE INDEX DOC_FK_HUS1_IND ON DOCS (DOC_USER_ID)');
  Exception
    WHEN do_nothing THEN null;
    WHEN others THEN raise;
  End;
  --
 End;
/