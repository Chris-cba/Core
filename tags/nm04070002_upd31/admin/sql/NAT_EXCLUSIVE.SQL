--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/NAT_EXCLUSIVE.SQL-arc   1.1   Nov 09 2015 13:50:28   Rob.Coupe  $
--       Module Name      : $Workfile:   NAT_EXCLUSIVE.SQL  $ 
--       Date into PVCS   : $Date:   Nov 09 2015 13:50:28  $
--       Date fetched Out : $Modtime:   Nov 09 2015 13:50:52  $
--       PVCS Version     : $Revision:   1.1  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------
--
ALTER TABLE nm_au_types
   ADD nat_exclusive VARCHAR2 (1) DEFAULT 'Y'
/

ALTER TABLE NM_AU_TYPES ADD
CONSTRAINT NM_AU_TYPES_EXCL_YN
 CHECK (nat_exclusive IN ('Y', 'N'))
 ENABLE
 VALIDATE
/

