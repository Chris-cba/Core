--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_install.sql-arc   1.2   Jan 20 2015 13:23:40   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_install.sql  $
--       Date into PVCS   : $Date:   Jan 20 2015 13:23:40  $
--       Date fetched Out : $Modtime:   Jan 20 2015 13:22:08  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : R.A. Coupe
--
--   Script for initial installation of LB - to be replaced by formal product 
--   install and upgrade scripts
--
-----------------------------------------------------------------------------
-- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
----------------------------------------------------------------------------
--

/* LB Install file */

DECLARE
   not_exists   exception;
   PRAGMA EXCEPTION_INIT (not_exists, -942);
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE LB_OBJECTS';
EXCEPTION
   WHEN not_exists
Then NULL;
end;
/ 

create table lb_objects
( object_name varchar2(128) NOT NULL,
  object_type varchar2(23) NOT NULL )
/
  
  
create unique index LB_OBJECTS_PK on lb_objects (object_name, object_type )
/

ALTER TABLE LB_OBJECTS ADD (
  PRIMARY KEY
  (OBJECT_NAME, OBJECT_TYPE)
  USING INDEX
  ENABLE VALIDATE)
/  


start lb_data_types.sql;

start lb_ddl.sql;

start ..\admin\pck\LB_GET.pkh;
start ..\admin\pck\LB_LOAD.pkh;
start ..\admin\pck\LB_LOC.pkh;
start ..\admin\pck\LB_OPS.pkh;
start ..\admin\pck\LB_PATH.pkh;
start ..\admin\pck\LB_REF.pkh;
start ..\admin\pck\LB_REG.pkh;
start ..\admin\pck\LB_PATH_REG.pkh;

start lb_views.sql;


--start ..\admin\pck\get_lb_rpt_d_tab.prc;
--start ..\admin\pck\get_lb_rpt_r_tab.prc;
start ..\admin\pck\create_nlt_geometry_view.prc;

begin
CREATE_NLT_GEOMETRY_VIEW;
end;
/

start ..\admin\pck\LB_PATH_REG.pkb;
start ..\admin\pck\LB_OPS.pkb
start ..\admin\pck\LB_REG.pkb;
start ..\admin\pck\LB_REF.pkb;
start ..\admin\pck\LB_GET.pkb;
start ..\admin\pck\LB_LOAD.pkb;
start ..\admin\pck\LB_LOC.pkb;
start ..\admin\pck\LB_PATH.pkb;


DECLARE
   TYPE object_name_type IS TABLE OF VARCHAR2 (123) INDEX BY binary_integer;
--
   TYPE object_type_type IS TABLE OF VARCHAR2 (23) INDEX BY binary_integer;
--
   l_object_name   object_name_type;
   l_object_type   object_type_type;

   PROCEDURE add_object (p_object_name VARCHAR2, p_object_type VARCHAR2)
   IS
      i   CONSTANT PLS_INTEGER := l_object_name.COUNT + 1;
   BEGIN
      l_object_name (i) := p_object_name;
      l_object_type (i) := p_object_type;
   END add_object;
BEGIN
   add_object ('LB_PATH_REG', 'PACKAGE');
   add_object ('LB_OPS', 'PACKAGE');
   add_object ('LB_REG', 'PACKAGE');
   add_object ('LB_REF', 'PACKAGE');
   add_object ('LB_GET', 'PACKAGE');
   add_object ('LB_LOAD', 'PACKAGE');
   add_object ('LB_LOC', 'PACKAGE');
   add_object ('LB_PATH', 'PACKAGE');
   add_object ('LB_PATH_REG', 'PACKAGE BODY');
   add_object ('LB_OPS', 'PACKAGE BODY');
   add_object ('LB_REG', 'PACKAGE BODY');
   add_object ('LB_REF', 'PACKAGE BODY');
   add_object ('LB_GET', 'PACKAGE BODY');
   add_object ('LB_LOAD', 'PACKAGE BODY');
   add_object ('LB_LOC', 'PACKAGE BODY');
   add_object ('LB_PATH', 'PACKAGE BODY'); 
   add_object ('CREATE_NLT_GEOMETRY_VIEW','PROCEDURE');  
   add_object ('V_LB_NLT_GEOMETRY', 'VIEW' );
--     
   FOR i IN 1 .. l_object_name.COUNT
   LOOP
      INSERT INTO lb_objects (object_name, object_type)
           VALUES (l_object_name (i), l_object_type (i));
   END LOOP;
END;
/


declare
  cursor c1 is
    select * from lb_objects l
    where object_type in ('PACKAGE', 'TABLE', 'VIEW', 'VIEW', 'PROCEDURE', 'SEQUENCE' );
begin
  for irec in c1 loop
    NM3DDL.CREATE_SYNONYM_FOR_OBJECT(irec.object_name, irec.object_type);
  end loop;
end;    
/

