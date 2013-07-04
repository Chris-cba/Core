--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/install/recomp_trg.sql-arc   2.1   Jul 04 2013 14:17:18   James.Wadsworth  $
--       Module Name      : $Workfile:   recomp_trg.sql  $
--       Date into PVCS   : $Date:   Jul 04 2013 14:17:18  $
--       Date fetched Out : $Modtime:   Jul 04 2013 13:42:06  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
REM SCCS ID Keyword, do no remove
define sccsid = '%W% %G%';

DECLARE
   -- recompile triggers
   --
   -- triggers might have been created before packages
   --
   CURSOR c1 IS
   SELECT object_name
   FROM USER_OBJECTS
   WHERE object_type = 'TRIGGER'
   AND status = 'INVALID'
   ;


BEGIN

   FOR c1rec IN c1 LOOP

      EXECUTE IMMEDIATE 'alter trigger ' || c1rec.object_name || ' compile';

   END LOOP;

END;
/
