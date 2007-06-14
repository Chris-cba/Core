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