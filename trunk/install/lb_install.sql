--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //new_vm_latest/archives/lb/install/lb_install.sql-arc   1.11   Oct 29 2015 09:38:04   Rob.Coupe  $
--       Module Name      : $Workfile:   lb_install.sql  $
--       Date into PVCS   : $Date:   Oct 29 2015 09:38:04  $
--       Date fetched Out : $Modtime:   Oct 29 2015 09:38:26  $
--       PVCS Version     : $Revision:   1.11  $
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

Prompt Installation of Location Bridge

Prompt Objects and Data Types

start lb_data_types.sql;

Prompt DDL Script - tables, indexes, constraints etc

start lb_ddl.sql;

Prompt Packages

start ..\admin\pck\LB_GET.pkh;
start ..\admin\pck\LB_LOAD.pkh;
start ..\admin\pck\LB_LOC.pkh;
start ..\admin\pck\LB_OPS.pkh;
start ..\admin\pck\LB_PATH.pkh;
start ..\admin\pck\LB_REF.pkh;
start ..\admin\pck\LB_REG.pkh;
start ..\admin\pck\LB_PATH_REG.pkh;

Prompt Views

start lb_views.sql;

start ..\admin\views\views.sql

Prompt Stand alone procedures

--start ..\admin\pck\get_lb_rpt_d_tab.prc;
--start ..\admin\pck\get_lb_rpt_r_tab.prc;

start ..\admin\pck\create_nlt_geometry_view.prc;

begin
CREATE_NLT_GEOMETRY_VIEW;
end;
/

Prompt Package bodies

start ..\admin\pck\LB_PATH_REG.pkb;
start ..\admin\pck\LB_OPS.pkb
start ..\admin\pck\LB_REG.pkb;
start ..\admin\pck\LB_REF.pkb;
start ..\admin\pck\LB_GET.pkb;
start ..\admin\pck\LB_LOAD.pkb;
start ..\admin\pck\LB_LOC.pkb;
start ..\admin\pck\LB_PATH.pkb;

prompt Creating the registry of Location Bridge Objects

DECLARE
   TYPE object_name_type IS TABLE OF VARCHAR2 (123) INDEX BY binary_integer;

   TYPE object_type_type IS TABLE OF VARCHAR2 (23) INDEX BY binary_integer;

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
   add_object( 'CREATE_NLT_GEOMETRY_VIEW','PROCEDURE');
   add_object( 'LB_ASSET_TYPE_NETWORK','TYPE');
   add_object( 'LB_ASSET_TYPE_NETWORK_TAB','TYPE');
   add_object( 'LB_GET','PACKAGE');
   add_object( 'LB_GET','PACKAGE BODY');
   add_object( 'LB_INV_SECURITY','TABLE');
   add_object( 'LB_JXP','TYPE');
   add_object( 'LB_JXP_TAB','TYPE');
   add_object( 'LB_LINEAR_REFNT','TYPE');
   add_object( 'LB_LINEAR_REFNT_TAB','TYPE');
   add_object( 'LB_LINEAR_TYPE','TYPE');
   add_object( 'LB_LINEAR_TYPE_TAB','TYPE');
   add_object( 'LB_LOAD','PACKAGE');
   add_object( 'LB_LOAD','PACKAGE BODY');
   add_object( 'LB_LOC','PACKAGE');
   add_object( 'LB_LOC','PACKAGE BODY');
   add_object( 'LB_LOCATION_ID','TYPE');
   add_object( 'LB_LOCATION_ID_TAB','TYPE');
   add_object( 'LB_LOC_ERROR','TYPE');
   add_object( 'LB_LOC_ERROR_TAB','TYPE');
   add_object( 'LB_OBJ_GEOM','TYPE');
   add_object( 'LB_OBJ_GEOM_TAB','TYPE');
   add_object( 'LB_OBJ_ID','TYPE');
   add_object( 'LB_OBJ_ID_TAB','TYPE');
   add_object( 'LB_OPS','PACKAGE');
   add_object( 'LB_OPS','PACKAGE BODY');
   add_object( 'LB_PATH','PACKAGE');
   add_object( 'LB_PATH','PACKAGE BODY');
   add_object( 'LB_PATH_REG','PACKAGE');
   add_object( 'LB_PATH_REG','PACKAGE BODY');
   add_object( 'LB_REF','PACKAGE');
   add_object( 'LB_REF','PACKAGE BODY');
   add_object( 'LB_REFNT_MEASURE','TYPE');
   add_object( 'LB_REFNT_MEASURE_TAB','TYPE');
   add_object( 'LB_REG','PACKAGE');
   add_object( 'LB_REG','PACKAGE BODY');
   add_object( 'LB_RPT','TYPE');
   add_object( 'LB_RPT_GEOM','TYPE');
   add_object( 'LB_RPT_GEOM_TAB','TYPE');
   add_object( 'LB_RPT_TAB','TYPE');
   add_object( 'LB_STATS','TYPE');
   add_object( 'LB_STATS','TYPE BODY');
   add_object( 'LB_TYPES','TABLE');
   add_object( 'LB_XSP','TYPE');
   add_object( 'LB_XSP_TAB','TYPE');
   add_object( 'LINEAR_ELEMENT_TYPE','TYPE');
   add_object( 'LINEAR_ELEMENT_TYPES','TYPE');
   add_object( 'LINEAR_LOCATION','TYPE');
   add_object( 'LINEAR_LOCATIONS','TYPE');
   add_object( 'NAL_ID_SEQ','SEQUENCE');
   add_object( 'NLG_ID_SEQ','SEQUENCE');
   add_object( 'NAG_ID_SEQ','SEQUENCE');
   add_object( 'NM_ASSET_GEOMETRY','VIEW');
   add_object( 'NM_ASSET_GEOMETRY_ALL','TABLE');
   add_object( 'NM_ASSET_LOCATIONS','VIEW');
   add_object( 'NM_ASSET_LOCATIONS_ALL','TABLE');
   add_object( 'NM_ASSET_TYPE_JUXTAPOSITIONS','TABLE');
   add_object( 'NM_JUXTAPOSITIONS','TABLE');
   add_object( 'NM_JUXTAPOSITION_TYPES','TABLE');
   add_object( 'NM_LOCATIONS','VIEW');
   add_object( 'NM_LOCATIONS_ALL','TABLE');
   add_object( 'NM_LOCATION_GEOMETRY','TABLE');
   add_object( 'NM_LOC_ID_SEQ','SEQUENCE');
   add_object( 'V_LB_INV_NLT_DATA','VIEW');
   add_object( 'V_LB_NETWORKTYPES','VIEW');
   add_object( 'V_LB_NLT_GEOMETRY','VIEW');
   add_object( 'V_LB_NLT_REFNTS','VIEW');
   add_object( 'V_LB_XSP_LIST','VIEW');
   add_object( 'V_NM_NLT_DATA','VIEW');
   add_object( 'V_NM_NLT_MEASURES','VIEW');
   add_object( 'V_NM_NLT_REFNTS','VIEW');
   add_object( 'V_NM_NLT_UNIT_CONVERSIONS','VIEW');
   add_object('V_LB_DIRECTED_PATH_LINKS','VIEW');  
   add_object('LB_UNITS','TABLE'); 
   add_object('V_LB_PATH_LINKS', 'VIEW');
   add_object('V_LB_PATH_BETWEEN_POINTS', 'VIEW');
   add_object('V_NETWORK_ELEMENTS', 'VIEW');
   
   --   
   FOR i IN 1 .. l_object_name.COUNT
   LOOP
     begin
      INSERT INTO lb_objects (object_name, object_type)
           VALUES (l_object_name (i), l_object_type (i));
     exception
       when dup_val_on_index then
         NULL;
     end;
   END LOOP;
END;
/

commit;

prompt Creating eB interface modules

start ..\admin\eB_interface\install_eB_interface.sql

prompt Creating synonyms

declare
  cursor c1 is
    select * from lb_objects l
    where object_type in ('PACKAGE', 'TABLE', 'VIEW', 'PROCEDURE', 'SEQUENCE' );
begin
  if nvl(hig.get_sysopt('HIGPUBSYN'),'Y') = 'Y' 
  then
     for irec in c1 loop
       NM3DDL.CREATE_SYNONYM_FOR_OBJECT(irec.object_name, 'PUBLIC');
     end loop;
  else
    NM3DDL.REFRESH_PRIVATE_SYNONYMS;
  end if;
end;    
/

insert into hig_upgrades
(hup_product, date_upgraded, from_version, to_version, upgrade_script, executed_by, remarks )
values
('NET', sysdate, '4.0.0.0', '4.1.0.0', 'lb_install', user, 'Location Bridge development version 4.1' )
/

commit;

prompt End of Location Bridge Installation