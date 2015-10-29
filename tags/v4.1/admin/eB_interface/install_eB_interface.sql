   --   PVCS Identifiers :-
   --
   --       pvcsid           : $Header:   //new_vm_latest/archives/lb/admin/eB_interface/install_eB_interface.sql-arc   1.4   Oct 29 2015 09:00:30   Rob.Coupe  $
   --       Module Name      : $Workfile:   install_eB_interface.sql  $
   --       Date into PVCS   : $Date:   Oct 29 2015 09:00:30  $
   --       Date fetched Out : $Modtime:   Oct 29 2015 09:00:54  $
   --       PVCS Version     : $Revision:   1.4  $
   --
   --   Author : R.A. Coupe
   --
   --   Location Bridge interface for eB install script.
   --
   -----------------------------------------------------------------------------
   -- Copyright (c) 2015 Bentley Systems Incorporated. All rights reserved.
   ----------------------------------------------------------------------------
   --
--start ..\admin\eB_interface\eB_interface.tyh  --RAC the types in this script are already absorbed into main LB installation
start ..\admin\eB_interface\CloseLinearLocation.prc
start ..\admin\eB_interface\CreateLinearLocation.prc
start ..\admin\eB_interface\CreateLinearRange.prc
start ..\admin\eB_interface\GetAssetLinearLocations.fnc
start ..\admin\eB_interface\GetAssetLinearLocationsTab.fnc
start ..\admin\eB_interface\GetLinearElementTypes.prc
start ..\admin\eB_interface\GetLinearLocations.fnc
start ..\admin\eB_interface\GetLinearRanges.fnc
start ..\admin\eB_interface\GetNetworkElementMeasures.fnc
start ..\admin\eB_interface\GetNetworkElements.fnc
start ..\admin\eB_interface\GetNetworkTypes.fnc
start ..\admin\eB_interface\GetXspList.fnc
start ..\admin\eB_interface\GetNetworkLinearLocations.fnc
start ..\admin\eB_interface\GetNetworkLinearLocationsTab.fnc
start ..\admin\eB_interface\lb_register_units.sql
start ..\admin\eB_interface\UpdateLinearLocation.prc
start ..\admin\eB_interface\v_network_elements.sql
start ..\admin\eB_interface\v_network_types.sql


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
   add_object( 'CLOSELINEARLOCATION','PROCEDURE');
   add_object( 'CREATELINEARLOCATION','PROCEDURE');
   add_object( 'CREATELINEARRANGE','PROCEDURE');
   add_object( 'GETASSETLINEARLOCATIONS','FUNCTION');
   add_object( 'GETASSETLINEARLOCATIONSTAB','FUNCTION');
   add_object( 'GETLINEARELEMENTTYPES','FUNCTION');
   add_object( 'GETLINEARLOCATIONS','FUNCTION');
   add_object( 'GETLINEARRANGES','FUNCTION');
   add_object( 'GETNETWORKELEMENTMEASURES','FUNCTION');
   add_object( 'GETNETWORKELEMENTS','FUNCTION');
   add_object( 'GETNETWORKTYPES','FUNCTION');
   add_object( 'GETXSPLIST','FUNCTION');
   add_object( 'GETNETWORKLINEARLOCATIONS','FUNCTION');
   add_object( 'GETNETWORKLINEARLOCATIONSTAB','FUNCTION');
   add_object( 'UPDATELINEARLOCATION','PROCEDURE');
   add_object( 'V_NETWORK_TYPES', 'VIEW' );
   
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
   
prompt end of Location Bridge interface for eB install script



