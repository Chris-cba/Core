-- PVCS Identifiers :-
--
-- pvcsid : $Header:   //new_vm_latest/archives/nm3/install/nm3_indexes.sql-arc   3.2   Apr 18 2018 16:09:44   Gaurav.Gaurkar  $
-- Module Name : $Workfile:   nm3_indexes.sql  $
-- Date into PVCS : $Date:   Apr 18 2018 16:09:44  $
-- Date fetched Out : $Modtime:   Apr 18 2018 16:02:10  $
-- PVCS Version : $Revision:   3.2  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2018 Bentley Systems Incorporated. All rights reserved.
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
