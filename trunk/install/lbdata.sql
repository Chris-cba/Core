--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //new_vm_latest/archives/lb/install/lbdata.sql-arc   1.2   Nov 08 2017 15:00:26   Rob.Coupe  $
--       Module Name      : $Workfile:   lbdata.sql  $
--       Date into PVCS   : $Date:   Nov 08 2017 15:00:26  $
--       Date fetched Out : $Modtime:   Nov 08 2017 14:59:10  $
--       PVCS Version     : $Revision:   1.2  $
--
--   Author : Rob Coupe
--
--   Location Bridge data script.
--
-----------------------------------------------------------------------------
--   Copyright (c) 2014 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--

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
   add_object( 'LB_INV_SECURITY', 'TABLE');
   add_object( 'NM_LOC_ID_SEQ','SEQUENCE');
   add_object( 'V_LB_INV_NLT_DATA','VIEW');
   add_object( 'V_LB_NETWORKTYPES','VIEW');
   add_object( 'V_LB_NLT_GEOMETRY','VIEW');
   add_object( 'V_LB_NLT_GEOMETRY2','VIEW');   
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
   add_object('LB_NW_EDIT', 'PACKAGE');
   add_object('LB_NW_EDIT', 'PACKAGE BODY');
   add_object('LB_ELEMENT_HISTORY', 'TABLE');
   add_object('LB_EDIT_TRANSACTION','TYPE');
   add_object('LB_EDIT_TRANSACTION_TAB', 'TYPE');
   add_object('V_LB_TYPE_NW_FLAGS', 'VIEW');  
   add_object('LB_LINEAR_LOCATION','TYPE');
   add_object('LB_LINEAR_LOCATIONS','TYPE');
   add_object('LB_LINEAR_ELEMENT_TYPE','TYPE');
   add_object('LB_LINEAR_ELEMENT_TYPES','TYPE');
   add_object('NAJX_ID_SEQ', 'SEQUENCE');
   add_object('NJX_ID_SEQ', 'SEQUENCE');
   add_object('V_NM_DATUM_THEMES', 'VIEW');
   add_object('MAKE_NW_FROM_LREFS', 'PROCEDURE');
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

Commit;

Prompt Location Bridge Inventory Category

INSERT into nm_inv_categories
( nic_category, nic_descr )
select 'L', 'Location Bridge'
from dual
where not exists ( select 1 from nm_inv_categories where nic_category = 'L' )
/

Prompt Location Bridge - Admin Unit

insert into nm_au_types
(nat_admin_type, nat_descr )
select 'NONE', 'No Admin-Unit Security'
from dual
where not exists ( select 1 from nm_au_types where nat_admin_type = 'NONE' )
/ 

commit;

Prompt Location Bridge Unit Translation Data

Insert into LB_UNITS
   (EXTERNAL_UNIT_ID, EXTERNAL_UNIT_NAME, EXOR_UNIT_ID, EXOR_UNIT_NAME)
 select 50, 'METRE', 1, 'Metres' 
 from dual where not exists ( select 1 from lb_units where exor_unit_id = 1 )
 and exists ( select 1 from nm_units where un_unit_id = 1 );
 
Insert into LB_UNITS
   (EXTERNAL_UNIT_ID, EXTERNAL_UNIT_NAME, EXOR_UNIT_ID, EXOR_UNIT_NAME)
Select 236, 'KILOMETRE', 2, 'Kilometers'
from dual where not exists ( select 1 from lb_units where exor_unit_id = 2 )
 and exists ( select 1 from nm_units where un_unit_id = 2 );
 
Insert into LB_UNITS
   (EXTERNAL_UNIT_ID, EXTERNAL_UNIT_NAME, EXOR_UNIT_ID, EXOR_UNIT_NAME)
Select 51, 'CENTIMETRE', 3, 'Centimetres'
from dual where not exists ( select 1 from lb_units where exor_unit_id = 3 )
 and exists ( select 1 from nm_units where un_unit_id = 3 );
 
Insert into LB_UNITS
   (EXTERNAL_UNIT_ID, EXTERNAL_UNIT_NAME, EXOR_UNIT_ID, EXOR_UNIT_NAME)
Select 321, 'MILE', 4, 'Miles'
from dual where not exists ( select 1 from lb_units where exor_unit_id = 4 )
 and exists ( select 1 from nm_units where un_unit_id = 4 );

Insert into LB_UNITS
   (EXTERNAL_UNIT_ID, EXTERNAL_UNIT_NAME, EXOR_UNIT_ID, EXOR_UNIT_NAME)
Select 77, 'DEGREE', 5, 'Degrees'
from dual where not exists ( select 1 from lb_units where exor_unit_id = 5 )
 and exists ( select 1 from nm_units where un_unit_id = 5 );

Insert into LB_UNITS
   (EXTERNAL_UNIT_ID, EXTERNAL_UNIT_NAME, EXOR_UNIT_ID, EXOR_UNIT_NAME)
Select 13, 'RADIAN', 6, 'Radians'
from dual where not exists ( select 1 from lb_units where exor_unit_id = 6 )
 and exists ( select 1 from nm_units where un_unit_id = 6 );

commit;

Prompt New System option for network graph generation

insert into hig_option_list
(hol_id, hol_product, hol_name, hol_remarks, hol_domain, hol_datatype, hol_mixed_case, hol_user_option, hol_max_length )
select 'LBNWBUFFER', 'LB', 'LB Graph Buffer', 'The size of the buffer in meters around an object to from the spatial intersection for construction of a dynamic network property graph',
       NULL, 'NUMBER', 'N', 'N', 2000 from dual
where not exists ( select 1 from hig_option_list where hol_id = 'LBNWBUFFER'   ); 

insert into hig_option_values
( hov_id, hov_value )
select 'LBNWBUFFER', '200'
from dual
where not exists ( select 1 from hig_option_values where hov_id = 'LBNWBUFFER' );

commit;   
