--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/utl/drop_lb.sql-arc   1.10   Dec 03 2015 16:35:30   Rob.Coupe  $
--       Module Name      : $Workfile:   drop_lb.sql  $
--       Date into PVCS   : $Date:   Dec 03 2015 16:35:30  $
--       Date fetched Out : $Modtime:   Dec 03 2015 16:35:38  $
--       PVCS Version     : $Revision:   1.10  $
--
--   Author : Rob Coupe
--
--   Location Bridge drop script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

Prompt Dropping object dependency list

DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'drop table lb_object_dependents';
EXCEPTION
   WHEN not_exists
   THEN
      NULL;
END;
/

Prompt Dropping objects in LB object registry

DECLARE
   CURSOR c1
   IS
      SELECT * FROM lb_objects;
BEGIN
   FOR irec IN c1
   LOOP
      BEGIN
         IF irec.object_type = 'TABLE'
         THEN
            BEGIN
               EXECUTE IMMEDIATE
                     ' alter table '
                  || irec.object_name
                  || ' drop primary key cascade ';
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;

            EXECUTE IMMEDIATE
               ' drop table ' || irec.object_name || ' cascade constraints ';
         ELSIF irec.object_type IN ('VIEW',
                                    'SEQUENCE',
                                    'PACKAGE',
                                    'PROCEDURE',
                                    'FUNCTION')
         THEN
            EXECUTE IMMEDIATE
               ' drop ' || irec.object_type || ' ' || irec.object_name;
         ELSIF irec.object_type IN ('TYPE', 'TYPE BODY ')
         THEN
            EXECUTE IMMEDIATE
                  ' drop '
               || irec.object_type
               || ' '
               || irec.object_name
               || ' FORCE';
         END IF;

         NM3DDL.DROP_SYNONYM_FOR_OBJECT (irec.object_name);
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
/

Prompt Test for remnants

SELECT object_name, object_type, 'Remains in existence'
  FROM lb_objects lo
 WHERE EXISTS
          (SELECT 1
             FROM user_objects o
            WHERE lo.object_name = o.object_name)
/

Prompt Removal of LB object list 

DECLARE
   not_exists   EXCEPTION;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'drop table lb_objects';
EXCEPTION
   WHEN not_exists
   THEN
      NULL;
END;
/

Prompt Clean up any residual metadata

DECLARE
   CURSOR c1
   IS
      SELECT nit_inv_type
        FROM nm_inv_types_all
       WHERE nit_category = 'L';
BEGIN
   FOR irec IN c1
   LOOP
      BEGIN
         EXECUTE IMMEDIATE
               'delete from nm_inv_type_attribs where ita_inv_type = '
            || ''''
            || irec.nit_inv_type
            || '''';

         EXECUTE IMMEDIATE
               'delete from nm_inv_type_roles where itr_inv_type = '
            || ''''
            || irec.nit_inv_type
            || '''';

         EXECUTE IMMEDIATE
               'delete from nm_inv_types_all where nit_inv_type  = '
            || ''''
            || irec.nit_inv_type
            || '''';
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;
   END LOOP;
END;
/

PROMPT Completed lb_drop script
/

