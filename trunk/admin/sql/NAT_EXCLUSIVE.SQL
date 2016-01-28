--   PVCS Identifiers :-
--
--       sccsid           : $Header:   //new_vm_latest/archives/nm3/admin/sql/NAT_EXCLUSIVE.SQL-arc   1.2   Jan 28 2016 12:43:14   Rob.Coupe  $
--       Module Name      : $Workfile:   NAT_EXCLUSIVE.SQL  $ 
--       Date into PVCS   : $Date:   Jan 28 2016 12:43:14  $
--       Date fetched Out : $Modtime:   Jan 28 2016 12:43:06  $
--       PVCS Version     : $Revision:   1.2  $
--
----------------------------------------------------------------------------
--   Copyright (c) 2015 Bentley Systems Incorporated.  All rights reserved.
----------------------------------------------------------------------------
--
prompt Adjustment to Admin Unit Types to add exclusive flag

RENAME NM_AU_TYPES to NM_AU_TYPES_FULL
/

ALTER TABLE nm_au_types_FULL
   ADD nat_exclusive VARCHAR2 (1) DEFAULT 'Y'
/

ALTER TABLE NM_AU_TYPES_FULL ADD
CONSTRAINT NM_AU_TYPES_EXCL_YN
 CHECK (nat_exclusive IN ('Y', 'N'))
 ENABLE
 VALIDATE
/

create or replace view nm_au_types
as select nat_admin_type,
          nat_descr,
          nat_date_created,
          nat_date_modified,
          nat_modified_by,
          nat_created_by
from nm_au_types_full
/
 
DECLARE
   pubsyn   VARCHAR2 (1);
BEGIN
   SELECT hov_value
     INTO pubsyn
     FROM hig_option_values
    WHERE hov_id = 'HIGPUBSYN';
--
   IF pubsyn = 'Y'
   THEN
      DECLARE
         already_exists   EXCEPTION;
         PRAGMA EXCEPTION_INIT (already_exists, -955);
      BEGIN
         EXECUTE IMMEDIATE
               'create public synonym NM_AU_TYPES_FULL for '
            || SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
            || '.NM_AU_TYPES_FULL';
         EXECUTE IMMEDIATE
               'create public synonym NM_AU_TYPES for '
            || SYS_CONTEXT ('NM3CORE', 'APPLICATION_OWNER')
            || '.NM_AU_TYPES';
      EXCEPTION
         WHEN already_exists
         THEN
            NULL;
      END;
   END IF;
END;
/

prompt end of admin type exclusivity upgrade
 

