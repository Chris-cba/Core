--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/admin/utl/drop_lb.sql-arc   1.16   Aug 02 2017 16:36:26   Rob.Coupe  $
--       Module Name      : $Workfile:   drop_lb.sql  $
--       Date into PVCS   : $Date:   Aug 02 2017 16:36:26  $
--       Date fetched Out : $Modtime:   Aug 02 2017 16:35:38  $
--       PVCS Version     : $Revision:   1.16  $
--
--   Author : Rob Coupe
--
--   Location Bridge drop script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

PROMPT Dropping object dependency list

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

PROMPT Dropping objects in LB object registry


DECLARE
   --   LB_OBJECTS_EXISTS   BOOLEAN
   --                          := nm3ddl.does_object_exist ('LB_OBJECTS', 'TABLE');

   TYPE cur_type IS REF CURSOR;

   c1         cur_type;
   CURSTR     VARCHAR2 (2000)
      :=    'select object_name, object_type from lb_objects lo '
         || ' where exists ( select 1 from user_objects o where o.object_name = lo.object_name '
         || ' and o.object_type = lo.object_type ) ';
   obj_name   NM3TYPE.tab_varchar30;
   obj_type   NM3TYPE.tab_varchar30;
BEGIN
   OPEN c1 FOR CURSTR;

   FETCH c1 BULK COLLECT INTO obj_name, obj_type;

   CLOSE c1;

   FOR i IN 1 .. obj_name.COUNT
   LOOP
      BEGIN
         IF obj_type (i) = 'TABLE'
         THEN
            BEGIN
               EXECUTE IMMEDIATE
                     ' alter table '
                  || obj_name (i)
                  || ' drop primary key cascade ';
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;

            EXECUTE IMMEDIATE
               ' drop table ' || obj_name (i) || ' cascade constraints ';
         ELSIF obj_type (i) IN ('VIEW',
                                'SEQUENCE',
                                'PACKAGE',
                                'PROCEDURE',
                                'FUNCTION')
         THEN
            EXECUTE IMMEDIATE ' drop ' || obj_type (i) || ' ' || obj_name (i);
         ELSIF obj_type (i) IN ('TYPE', 'TYPE BODY ')
         THEN
            EXECUTE IMMEDIATE
               ' drop ' || obj_type (i) || ' ' || obj_name (i) || ' FORCE';
         END IF;

         NM3DDL.DROP_SYNONYM_FOR_OBJECT (obj_name (i));
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      --            nm_debug.debug('problem with '||obj_name(i));
      --            raise_application_error ( -20001, obj_name(i) || sqlerrm );
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
/

PROMPT Test for remnants

SET SERVEROUTPUT ON;

DECLARE
   LB_OBJECTS_EXISTS   BOOLEAN
                          := nm3ddl.does_object_exist ('LB_OBJECTS', 'TABLE');

   TYPE cur_type IS REF CURSOR;

   c1                  cur_type;
   CURSTR              VARCHAR2 (2000)
      :=    'select object_name, object_type from lb_objects lo '
         || 'where exists ( select 1 from user_objects o WHERE lo.object_name = o.object_name) ';
   obj_name            NM3TYPE.tab_varchar30;
   obj_type            NM3TYPE.tab_varchar30;
BEGIN
   --   DBMS_OUTPUT.enable (buffer_size => NULL);

   IF LB_OBJECTS_EXISTS
   THEN
      OPEN c1 FOR CURSTR;

      FETCH c1 BULK COLLECT INTO obj_name, obj_type;

      CLOSE c1;

      FOR i IN 1 .. obj_name.COUNT
      LOOP
         DBMS_OUTPUT.put_line (
               ' The object '
            || obj_name (i)
            || ' of type '
            || obj_type (i)
            || ' remains');
      END LOOP;
   ELSE
      DBMS_OUTPUT.put_line (' The object registry has already been dropped');
   END IF;
--   DBMS_OUTPUT.disable;
END;
/

PROMPT Removal of LB object list if exists

--DECLARE
--   not_exists   EXCEPTION;
--   PRAGMA EXCEPTION_INIT (not_exists, -942);
--BEGIN
--   EXECUTE IMMEDIATE 'drop table lb_objects';
--EXCEPTION
--   WHEN not_exists
--   THEN
--      NULL;
--END;
--/

PROMPT Clean up any residual metadata (asset types etc. ) if present

DELETE FROM hig_roles
      WHERE hro_product = 'LB';

DELETE FROM hig_upgrades
      WHERE hup_product = 'LB';

DELETE FROM hig_products
      WHERE hpr_product = 'LB';

DECLARE
   CURSOR c1
   IS
      SELECT nit_inv_type
        FROM nm_inv_types_all
       WHERE nit_category = 'L';
BEGIN
   FOR irec IN c1
   LOOP
      nm3sdm.drop_layers_by_inv_type (irec.nit_inv_type, FALSE);

      BEGIN
         EXECUTE IMMEDIATE
               'delete from nm_inv_nw_all where nin_nit_inv_code = '
            || ''''
            || irec.nit_inv_type
            || '''';

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

COMMIT;

EXIT;
