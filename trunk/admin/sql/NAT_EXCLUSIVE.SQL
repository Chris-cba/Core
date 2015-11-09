--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/NAT_EXCLUSIVE.SQL-arc   1.0   Nov 09 2015 11:54:44   Rob.Coupe  $
--       Module Name      : $Workfile:   NAT_EXCLUSIVE.SQL  $ 
--       Date into PVCS   : $Date:   Nov 09 2015 11:54:44  $
--       Date fetched Out : $Modtime:   Nov 09 2015 11:54:26  $
--       PVCS Version     : $Revision:   1.0  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------
--
ALTER TABLE nm_au_types
   ADD nat_exclusive VARCHAR2 (1) DEFAULT 'Y'
/

ALTER TABLE HIGHWAYS.NM_AU_TYPES ADD
CONSTRAINT NM_AU_TYPES_EXCL_YN
 CHECK (nat_exclusive IN ('Y', 'N'))
 ENABLE
 VALIDATE
/

