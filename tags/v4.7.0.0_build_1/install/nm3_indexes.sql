-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //vm_latest/archives/nm3/install/nm3_indexes.sql-arc   3.1   Jul 04 2013 13:55:14   James.Wadsworth  $
-- Module Name : $Workfile:   nm3_indexes.sql  $
-- Date into PVCS : $Date:   Jul 04 2013 13:55:14  $
-- Date fetched Out : $Modtime:   Jul 04 2013 13:37:36  $
-- PVCS Version : $Revision:   3.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

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
